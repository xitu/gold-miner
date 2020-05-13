> * 原文地址：[Writing Type-Safe Polymorphic React Components (Without Crashing TypeScript)](https://blog.andrewbran.ch/polymorphic-react-components/)
> * 原文作者：[Andrew Branch](https://blog.andrewbran.ch/about) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/polymorphic-react-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/polymorphic-react-components.md)
> * 译者：[zoomdong](https://github.com/fireairforce)
> * 校对者：[Raoul1996](https://github.com/Raoul1996),[Gesj-yean](https://github.com/Gesj-yean)

# 编写类型安全的多态 React 组件（不会导致 TypeScript 崩溃）

在设计可重用性的 React 组件时，通常需要组件支持在不同情况下传入不同的 DOM 属性。假设你正在构建一个 `<Button />` 组件。首先，你只需要允许将自定义的 `className` 合并进去，但以后，你需要支持与该组件无关，但是和组件使用的上下文有关的各种属性和事件处理方法。例如：需要传入 Tooltip 组件的 `aria-describedby` 属性，或是在组件内写 `tableIndex` 和 `onKeyDown` 属性触发的焦点事件。

Button 组件不可能预测和处理每一个可能使用的特殊的上下文，因此有一个合理的理由可以允许任意额外的 props 给 Button 组件，并让它传递无法理解的额外的 props。

```tsx
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  color?: ColorName;
  icon?: IconName;
}

function Button({ color, icon, className, children, ...props }: ButtonProps) {
  return (
    <button
      {...props}
      className={getClassName(color, className)}
    >
      <FlexContainer>
        {icon && <Icon name={icon} />}
        <div>{children}</div>
      </FlexContainer>
    </button>
  );
}
```

举个例子，我们可以将额外的 props 传递给 `<button>` 元素，它支持参数的类型检查。由于 props 类型继承自 `React.ButtonHTMLAttributes`，我们只能通过 props 传递一些参数来完善 `<button>`：

```tsx
<Button onKeyDown={({ currentTarget }) => { /* do something */ }} />
<Button foo="bar" /> // Correctly errors 👍
```

## 当透传参数还不够时
在你将 Button v1 版本发给产品研发团队半小时之后，他们会来问你一个问题：怎么使用 Button 来做 react-router 的 Link？怎样做一个链接到外部站点的 HTMLAnchorElement？你发给他们的组件**仅仅**是渲染成 HTMLButtonElement。

如果我们不关心类型安全，我们可以很轻松的使用普通 JavaScript 来写这个：

```tsx
function Button({
  color,
  icon,
  className,
  children,
  tagName: TagName,
  ...props
}) {
  return (
    <TagName
      {...props}
      className={getClassName(color, className)}
    >
      <FlexContainer>
        {icon && <Icon name={icon} />}
        <div>{children}</div>
      </FlexContainer>
    </TagName>
  );
}

Button.defaultProps = { tagName: 'button' };
```

这使得使用者可以轻松的使用他们喜欢的任意标签或组件来作为容器：

```tsx
<Button tagName="a" href="https://github.com">GitHub</Button>
<Button tagName={Link} to="/about">About</Button>
```

但是？我们如何使用使类型正确呢？Button 的 props 不能再无条件的继承自 `React.ButtonHTMLAttributes`，因为多余的 props 不能传递给 `<button>`。

> 适当的警告：深入到完全未知的领域，来解释为什么不能很好地工作的几个原因。如果你更愿意相信我的话，你可以[跳到](#an-alternative-approach)一个更好的解决方案。

![ ](https://github.com/andrewbranch/blog/blob/master/posts/images/rabbit-dark.png)

我们先从一个简单的例子开始，只允许 `tagName` 为 `'a'` 或 `'button'`。（我还会删除一些影响简洁性的 props 和属性。）这是一次合理的尝试：

```tsx
interface ButtonProps {
  tagName: 'a' | 'button';
}

function Button<P extends ButtonProps>({ tagName: TagName, ...props }: P & JSX.IntrinsicElements[P['tagName']]) {
  return <TagName {...props} />;
}

<Button tagName="a" href="/" />
```

> 注意：要理解这一点，要具备 [JSX.IntrinsicElements](https://github.com/DefinitelyTyped/DefinitelyTyped/blob/0bb210867d16170c4a08d9ce5d132817651a0f80/types/react/index.d.ts#L2829) 的基础知识。这是 React 类型定义的维护者之一对 [TypeScript 中的 JSX 的深入研究](https://dev.to/ferdaber/typescript-and-jsx-part-iii---typing-the-props-for-a-component-1pg2)。

出现的两个直接观察的结果是

1. 它不会编译 —— 它用很多字告诉我们，`props.ref` 的类型不适合 `TagName` 的类型。
2. 尽管如此，当 `tagName` 被推断为字符串文字类型时，它确实会产生我们想要的结果。我们甚至可以从 `AnchorHTMLAttributes` 那里得到完整的信息：

![A screenshot of VS Code’s completion list in a JSX property position on the Button JSX tag from the previous example. The list includes href, hrefLang, inputMode, and other valid properties of anchor tags and button tags.](https://github.com/andrewbranch/blog/blob/master/posts/images/jsx-prop-completions.png)

然而，更多的实验表明，我们也有效地禁用了多余的属性检查：

```tsx
<button href="/" fakeProp={1} /> // correct errors 👍
<Button tagName="button" href="/" fakeProp={1} /> // no errors 👎
```

Button 上的每个 prop 都将被推断为类型参数 `P` 的属性，而类型参数 `P` 又成为被允许的 prop 的一部分。换句话说，允许的 props 总是包括你传递的所有 props。当你添加一个 prop 时，它就成为了 Button 的 props 的一部分。（实际上，你可以通过在上面的示例中悬停在 `Button` 的内容来看到这一点。）这显然与你打算如何定义 React 组件相反。

### `ref` 有什么问题？

如果你还没有被说服放弃使用这种方法，或者你只是好奇为什么上面的代码片段编译得不好，更深入一些。在你使用 `Omit<typeof props, 'ref'>` 实现一个比较清晰的解决方案时，会被警告：`ref` 并不是唯一的问题，这只是第一个问题。其余的问题是每个事件处理程序的 prop。[^1]

那么 `ref` 和 `onCopy` 有什么共同点呢？他们都有共同的形式：`(param: T) => void`，其中 `T` 指的是渲染的 DOM 元素的实例类型：例如 `HTMLButtonElement` 用于按钮， `HTMLAnchorElement` 用于锚点。如果要调用被调用参数类型的并集，则必须传递它们的参数类型的交集，以确保无论在运行时调用哪个函数，该函数都将接收对其参数期望的子类型。[^2] 简单的例子如下：

```ts
function addOneToA(obj: { a: number }) {
  obj.a++;
}

function addOneToB(obj: { b: number }) {
  obj.b++;
}

// 假设我们有一个函数
// 它可以是上面声明的函数类型
declare var fn: typeof addOneToA | typeof addOneToB;

// 函数可能会访问我们传递的任何一个属性 'a' 或 'b'
// 因此直观地说
// 对象需要定义这两个属性
fn({ a: 0 });
fn({ b: 0 });
fn({ a: 0, b: 0 });
```

在这个例子中，可以很容易看出来我们必须向 `fn` 传递一个类型为 `{ a: number, b: number }` 的对象，它是 `{ a: number }` 和 `{ b: number }` 的交集。同样这也会发生在 `ref` 和所有的事件处理程序上面：

```ts
type Props1 = JSX.IntrinsicElements['a' | 'button'];

// 简化为：
type Props2 =
  | JSX.IntrinsicElements['a']
  | JSX.IntrinsicElements['button'];

// 这意味着 ref 是...
type Ref =
  | JSX.IntrinsicElements['a']['ref']
  | JSX.IntrinsicElements['button']['ref'];

// 这是函数的并集！
declare var ref: Ref;
// 忽略掉字符串的引用
if (typeof ref === 'function') {
  // 因此，它需要 `HTMLButtonElement & HTMLAnchorElement`
  ref(new HTMLButtonElement());
  ref(new HTMLAnchorElement());
}
```

现在我们可以看到，为什么 `ref` 不要参数类型是 `HTMLAnchorElement | HTMLButtonElement` 的并集，而是需要它们的交集：`HTMLAnchorElement & HTMLButtonElement` —— 理论上可行的类型，但不是在 DOM 中出现的类型。而且我们直观地知道，如果我们有一个 React 元素，要么是锚，要么是 Button，传递给 `ref` 的值要么是 `HTMLAnchorElement`，要么是 `HTMLButtonElement`，所以我们提供给 `ref` 的函数应该是能够接受 `HTMLAnchorElement | HTMLButtonElement` 的。因此，回到原来的组件，我们可以看到当 `P['tagName']` 是一个并集的时候，`JSX.IntrinsicElements[P['tagName']]` 能够合理的允许使用不安全的回调类型，而这正是编译器所不接受的。通过忽略此类型错误可能出现的不安全操作的例子：

```tsx
<Button
  tagName={'button' as 'a' | 'button'}
  ref={(x: HTMLAnchorElement) => x.href.toLowerCase()}
/>
```

### 写一个更好的 `props` 类型

我认为使这个问题不直观的原因是你总是希望将 `tagName` 实例化为一个字符串文本类型，而不是一个联合类型。在这种情况下，`JSX.IntrinsicElements[P['tagName']]` 是合理。然而在组件函数内部，`TagName` 看起来是联合类型，因此 props 输入的时候要为交集。事实证明，这是[可能的](https://stackoverflow.com/questions/50374908/transform-union-type-to-intersection-type)，但是这有点老套。因此在这我们甚至不会把 `UnionToIntersection` 写下来。私底下不要这么做：

```tsx
interface ButtonProps {
  tagName: 'a' | 'button';
}

function Button<P extends ButtonProps>({
  tagName: TagName,
  ...props
}: P & UnionToIntersection<JSX.IntrinsicElements[P['tagName']]>) {
  return <TagName {...props} />;
}

<Button tagName="button" type="foo" /> // Correct error! 🎉
```

当 `tagName` 是一个联合类型的时候又会怎么样呢？

```tsx
<Button
  tagName={'button' as 'a' | 'button'}
  ref={(x: HTMLAnchorElement) => x.href.toLowerCase()} // 🎉
/>
```

不过，我们不要过早地庆祝：我们还没有有效的解决缺乏过多的属性检查，这是一个不可接受的折衷。

### 回到多余属性检查

正如我们之前所发现的，过量属性检查来带问题是，我们所有的props都会成为类型参数 `P` 的一部分。我们需要一个类型参数，以便将 `tagName` 推断为字符串文字单位类型，而不是一个联合类型，可能其他属性根本不需要是泛型的：

```tsx
interface ButtonProps<T extends 'a' | 'button'> {
  tagName: T;
}

function Button<T extends 'a' | 'button'>({
  tagName: TagName,
  ...props
}: ButtonProps<T> & UnionToIntersection<JSX.IntrinsicElements[T]>) {
  return <TagName {...props} />;
}
```

这是什么新的和不寻常的错误？

它来自 `TagName` 泛型 和 React 对 [JSX.LibraryManagedAttributes](https://github.com/DefinitelyTyped/DefinitelyTyped/blob/e4a0d4f532b177fc800e8ade7f1b39e9879d4b3c/types/react/index.d.ts#L2817-L2821) 的定义作为一种[分配性条件类型](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-8.html#distributive-conditional-types)的组合。TypeScript 目前不允许将任何东西赋值给条件类型，条件类型的检查类型（在 `?` 之前）是通用的：

```ts
type AlwaysNumber<T> = T extends unknown ? number : number;

function fn<T>() {
  let x: AlwaysNumber<T> = 3;
}
```

显然，声明的 `x` 类型总是 `number`，但 `3` 不能赋值给它。你看到的是一个保守的简化，可以防止分布可能更改结果类型的情况：

```ts
// 这些类型看起来相同，因为所有的 `T` 都拓展了 `unknown`
type Keys<T> = keyof T;
type KeysConditional<T> = T extends unknown ? keyof T : never;

// 这里是一样的
type X1 = Keys<{ x: any, y: any }>;
type X2 = KeysConditional<{ x: any, y: any }>;

// 但这里不相同
type Y1 = Keys<{ x: any } | { y: any }>;
type Y2 = KeysConditional<{ x: any } | { y: any }>;
```

由于这里演示的分布式特性，在实例化泛型条件类型之前假设它的任何内容通常都是不安全的。

### 分布式施密特分布性，我将让它工作

假设你解决了这个可分配性错误，并准备将所有的 `'a' | 'button'` 替换为 `keyof JSX.IntrinsicElements`。

```tsx
interface ButtonProps<T extends keyof JSX.IntrinsicElements> {
  tagName: T;
}

function Button<T extends keyof JSX.IntrinsicElements>({
  tagName: TagName,
  ...props
}: ButtonProps<T> & UnionToIntersection<JSX.IntrinsicElements[T]>) {
  // @ts-ignore YOLO
  return <TagName {...props} />;
}

<Button tagName="a" href="/" />
``` 

那么，恭喜你成功弄崩了 TypeScript 3.4！约束类型 `keyof JSX.IntrinsicElements` 173 个键的联合类型，类型检查器将用它们的约束实例化泛型，来确保所有可能的实例化都是安全的。这意味着 `ButtonProps<T>` 是 173 个对象类型的并集，并且可以说 `UnionToIntersection<...>` 是一个包裹在另一个对象类型中的条件类型，其中一个条件类型分布到另一个 173 个类型的并集上，并在此类型推断上进行调用。简而言之，你刚刚发明了一个无法在节点的默认堆大小内进行推理的 Button。而且我们甚至从来没有考虑过支持 `<Button tagName={Link} />`！

TypeScript 3.5 可以通过推迟大量简化条件类型的工作来处理这个问题，而不会崩溃，但是你真的想编写只等待合适时机爆发处理操作的组件吗？

> 如果你认真看到了这里，我真的很感动。我花了几个星期才到这里，但只花了你十分钟！

![ ](https://github.com/andrewbranch/blog/raw/master/posts/images/rabbit-head-dark.png)

## 另一种方法

当我们回到画板，刷新一下我们真正想要完成的东西。我们的按钮组件是这样的：

* 能够接受任意的 props，例如 `onKeyDown` 和 `aria-describedby`
* 能够被渲染为 `button`， 带有 `href` 属性的 `a` 标签， 或者带有 `to` 属性的 `Link` 组件
* 确保根元素具有它需要的所有 props，并且没有不支持的
* 不会使 TypeScript 崩溃或者使编辑器卡顿

事实证明，我们可以使用渲染 prop 来完成这些工作。我建议命名为 `renderContainer` 并给它一个合理的默认值：

```tsx
interface ButtonInjectedProps {
  className: string;
  children: JSX.Element;
}

interface ButtonProps {
  color?: ColorName;
  icon?: IconName;
  className?: string;
  renderContainer: (props: ButtonInjectedProps) => JSX.Element;
  children?: React.ReactChildren;
}

function Button({ color, icon, children, className, renderContainer }: ButtonProps) {
  return renderContainer({
    className: getClassName(color, className),
    children: (
      <FlexContainer>
        {icon && <Icon name={icon} />}
        <div>{children}</div>
      </FlexContainer>
    ),
  });
}

const defaultProps: Pick<ButtonProps, 'renderContainer'> = {
  renderContainer: props => <button {...props} />
};
Button.defaultProps = defaultProps;
```

让我们尝试一下：

```tsx
// 简单的默认设置
<Button />

// 渲染为 Link，强制设置 `to` 属性
<Button
  renderContainer={props => <Link {...props} to="/" />}
/>

// 渲染为锚点，接收 `href` 属性
<Button
  renderContainer={props => <a {...props} href="/" />}
/>

// 渲染为带有 `aria-describedby` 属性的 button
<Button
  renderContainer={props =>
    <button {...props} aria-describedby="tooltip-1" />}
/>
```

我们完全消除了 `keyof JSX.IntrinsicElements` 的 173 个组成联合键类型造成的类型错误，同时允许更大的灵活性，它是完美的，类型安全的。任务也完成了 🎉 

## 覆盖的 prop 警告
这样的 API 设计成本很小。犯这样的错误很容易：

```tsx
<Button
  color={ColorName.Blue}
  renderContainer={props =>
    <button {...props} className="my-custom-button" />}
/>
```

`{...props}` 已经包含了 `className`，它使 Button 看起来更漂亮并且呈蓝色，并且这里我们用 `my-custom-button` 完全覆盖了类 `className`。

一方面，这提供了最高程度的可定制性 —— 用户可以完全控制哪些内容可以放到容器中，哪些不可以，允许进行以前不可能进行的细粒度定制。但是另一方面，你可能在 99% 的情况下都希望合并这些类，因为它视觉上看起来是零碎的，并不是明显的。

根据组件的复杂性、用户的身份以及文档的可靠性，这些可能是严重的问题，也可能不是。当我开始在自己的工作中使用这样的模式时，我写了一个 [小的实用程序](https://github.com/andrewbranch/merge-props)来帮忙实现附加 props 的合并：

```tsx
<Button
  color={ColorName.Blue}
  renderContainer={props =>
    <button {...mergeProps(props, {
      className: 'my-custom-button',
      onKeyDown: () => console.log('keydown'),
    })} />}
/>
```

这样可以确保正确合并类名，如果 `ButtonInjectedProps` 扩展其定义来注入自己的 `onKeyDown`，则将运行此处提供的注入的类名和控制台日志记录的类名。

- [^1]:
  如果需要，你可以通过查看 React 类型并注释掉 [ref属性](https://github.com/DefinitelyTyped/DefinitelyTyped/blob/86303f134e12cf701a3f3f5e24867c3559351ea2/types/react/index.d.ts#L97) 来发现这一点。编译器错误仍然存在，只是将 `onCopy` 替换为前面所说的 `ref`。
- [^2]: 
我试图直观地解释这种关系，但这是因为参数是函数签名中的逆变位置。关于这个话题有几个[很好](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-6.html)的[解释](https://www.stephanboyer.com/post/132/what-are-covariance-and-contravariance)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
