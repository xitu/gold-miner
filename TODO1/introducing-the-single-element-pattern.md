> * 原文地址：[Introducing the Single Element Pattern: Rules and best practices for creating reliable building blocks with React and other component-based libraries.](https://medium.freecodecamp.org/introducing-the-single-element-pattern-dfbd2c295c5d)
> * 原文作者：[Diego Haz](https://medium.freecodecamp.org/@diegohaz)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-the-single-element-pattern.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-the-single-element-pattern.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[Hopsken](https://hopsken.com/)

# 单元素组件模式简介

## 使用 React 或其它基于组件的库创建可靠构建模块的规则和最佳实践。

![](https://cdn-images-1.medium.com/max/1000/1*safLOvm16NWX1Z4mPBHNCQ.png)

在 2002 年 — 当我开始构建网页的时候 — 包括我在内的大多数开发者都使用 `<table>` 标签来构建网页布局。

直到 2005 年，我才开始遵循[网页标准](https://en.wikipedia.org/wiki/Web_standards)。

> 如果有网站或网页宣称遵循网页标准，通常就表示他们的网页符合 HTML、CSS、JavaScript 等标准。HTML 的部分也要满足无障碍性以及 HTML 语义的要求。

我了解了语义化和无障碍性，然后开始使用正确的 HTML 标签和外部 CSS。我很自豪地将 [W3C 认证徽章](https://www.w3.org/QA/Tools/Icons)添加到我制作的每个网站。

![](https://cdn-images-1.medium.com/max/800/1*pFL99e3lxpYN-Fp24HfdBw.jpeg)

我们编写的 HTML 代码和输出到浏览器中的真实代码非常相似。这意味着使用 [W3C 验证器](https://validator.w3.org/) 和其它工具来验证输出代码的规范性也可以告诉我们如何写出更好的代码。

时光流逝。为了分离前端中可重用部分，我使用过 PHP、模版系统、jQuery、Polymer、Angular 和 React。尤其是后几个，最近三年我一直在使用它们。

随着时间的推移，我们编写的代码和用户实际使用的代码越来越不同了。现在，我们使用不同方式（例如 Babel 和 TypeScript）来编译代码。我们使用 [ES2015+](https://devhints.io/es6) 和 [JSX](https://reactjs.org/docs/introducing-jsx.html) 规范编写，但最终的输出代码就只是 HTML 和 JavaScript。

如今，虽然我们还会使用 W3C 的工具来验证我们的网站，但对于编写代码没有太大帮助。我们仍在追求代码稳定和可维护的最佳实践。而且，如果你正在读这篇文章，我想你也有同样的诉求。

我为你准备了一些东西。

### 单元素组件模式（[Singel 源码](https://github.com/diegohaz/singel)）

我已经不知道写过多少个组件了。但如果把 Polymer、Angular 和 React 的项目都加起来，我敢说这个数字肯定超过一千了。

除公司项目外，我还维护了一个包含 40 多个示例组件的 [React 模版库](https://github.com/diegohaz/arc)。另外，我正在和 [Raphael Thomazella](https://github.com/Thomazella) 维护一套[交互式 UI 组件库](https://github.com/diegohaz/reas)，他为这个项目贡献了很多。

许多开发者都有一个误解：如果以一个完美的文件结构来开始一个项目，那么他们就不会遇到任何问题。事实上，文件结构的一致性没那么重要。如果你的组件没有遵循明确定义的规则，这最终会使你的项目很难维护。

在创建和维护了那么多组件之后，我发现了一些使它们更加一致和可靠的特性，这样用起来会更加愉快。一个组件越像一个 HTML 元素，它就会变得越**可靠**。

> 没有什么比一个 `<div>` 标签更可靠了。

使用组件时，你可以问问自己下面的问题：

*   问题 #1：如果我需要将 props 传递给嵌套元素会怎么样？
*   问题 #2：由于某种原因，这个组件会使应用中断吗？
*   问题 #3：如果我想传递 `id` 或其它 HTML 属性会怎么样？
*   问题 #4：我可以通过传递 `className` 或 `style` 属性来自定义组件样式吗？
*   问题 #5：事件是如何处理的呢？

**可靠性**意味着，在这种情况下，不需要打开文件查看源码来了解它的工作原理。如果你在使用一个 `<div>`，你马上就会知道答案，如下：

*   [规则 #1：每次只渲染一个元素](#2249)
*   [规则 #2：从不中断应用](#a129)
*   [规则 #3：应用所有作为属性传递的 HTML 属性](#cbaa)
*   [规则 #4：应用作为属性传递的样式规则](#f168)
*   [规则 #5：应用所有作为属性传递的事件处理方法](#3646)

我把这一组规则称为 [Singel](https://github.com/diegohaz/singel)。

### 重构驱动开发

> 先让它工作，然后再去优化。

当然，不可能让所有组件都遵循 [Singel](https://github.com/diegohaz/singel) 全部规则。在某情况下 — 实际上很多情况下 — 你不得不至少打破第一条规则。

应该遵循这些规则的组件是应用中最重要的部分：原子、原始、构建块、元素或任何称为基础的组件。这篇文章中，我将统称它们为**单个元素**。

其中一些很容易抽象出来，比如：`Button`、`Image` 和 `Input`。也可以说是那些和 HTML 元素有直接关系的组件。在其它情况下，只有在重复代码时才会识别出它们。那也没关系。

通常，无论何时你需要更改某个组件时，不管是添加新功能，还是修复问题，你可能会看到 — 或者开始编写重复的样式和行为。这就是需要将它抽象为一个新的单元素信号。

单元素组件与其它组件的比值越高，应用就会越稳定、越方便维护。

将它们放到单独的文件夹中 — 比如：`elements`, `atoms`, `primitives`，因此，无论何时你需要导入这些组件时，你都会确信它们遵循了规则。

### 一个实例

在本文中，我重点放在 React 上。同样的规则也适用于其它任何基于组件的库。

这就是说，我们有一个 `Card` 组件。它由 `Card.js` 和 `Card.css` 组成，在 `Card.css` 文件中我们为 `.card`、`.top-bar`、`.avatar` 和其它类选择器配置了样式规则。

![](https://cdn-images-1.medium.com/max/800/1*Sm0TM1LOvrWi0WBVjVRIsA.png)

```
const Card = ({ profile, imageUrl, imageAlt, title, description }) => (
  <div className="card">
    <div className="top-bar">
      <img className="avatar" src={profile.photoUrl} alt={profile.photoAlt} />
      <div className="username">{profile.username}</div>
    </div>
    <img className="image" src={imageUrl} alt={imageAlt} />
    <div className="content">
      <h2 className="title">{title}</h2>
      <p className="description">{description}</p>
    </div>
  </div>
);
```

在某些时候，应用中的其它位置也有可能使用头像。为了不重复 HTML 和 CSS 代码，我们要创建一个新的 `Avatar` 单元素组件，然后就能复用它了。

#### 规则 #1：每次只渲染一个元素

它由 `Avatar.js` 和 `Avatar.css` 组成，后者配置了我们从 `Card.css` 中取出用于 `.avatar` 的样式，最终返回一个 `<img>` 元素：

```
const Avatar = ({ profile, ...props }) => (
  <img
    className="avatar" 
    src={profile.photoSrc} 
    alt={profile.photoAlt} 
    {...props} 
  />
);
```

下面是我们如何在 `Card` 和应用中其它位置使用它：

```
<Avatar profile={profile} />
```

#### 规则 #2：从不中断应用

一个 `<img>` 元素，虽然 `src` 属性是必须的，如果你不传递它，也不会中断应用。但是，对于我们的应用，如果不传递 `profile`，那么这个组件就会中断应用。

![](https://cdn-images-1.medium.com/max/800/1*aAB2QAEHkWxMBo-UFaCsUA.png)

React 16 版本中提供了一个名为 `componentDidCatch` 的[新的生命周期方法](https://reactjs.org/blog/2017/07/26/error-handling-in-react-16.html)，可以用来优雅地处理组件内部错误。虽然在应用中实现边界错误处理是一种很好的做法，但这也会掩盖单元素组件中的错误。

我们必须确保 `Avatar` 组件本身是可靠的，并考虑到所需要的属性父组件可能不会传递的情况。在这种情况下，除了在使用 `profile` 之前检查它是否存在之外，还要使用 `Flow`、`TypeScript` 或 `PropTypes` 对这种情况给出警告，如下：

```
const Avatar = ({ profile, ...props }) => (
  <img 
    className="avatar" 
    src={profile && profile.photoUrl} 
    alt={profile && profile.photoAlt} 
    {...props}
  />
);

Avatar.propTypes = {
  profile: PropTypes.shape({
    photoUrl: PropTypes.string.isRequired,
    photoAlt: PropTypes.string.isRequired
  }).isRequired
};
```

现在我们不传递任何属性来使用 `<Avatar />` 组件，来看看控制台会给出什么警告：

![](https://cdn-images-1.medium.com/max/800/1*5Cjn18Fr2n_O1wHMGff4wQ.png)

通常，我们会忽略这些警告并在控制台中累积几个。因为当新警告出现时，我们永远不会在意，所以 `PropTypes` 无法发挥作用。因此，在这些警告累积之前，请务必解决。

#### 规则 #3：应用所有作为属性传递的 HTML 属性

目前为止，我们的单元素组件使用了名为 `profile` 的自定义属性。我们应该避免使用自定义属性，特别是当它们直接映射为 HTML 属性时。查看下面的[建议 #1: 避免使用自定义属性](#c3e6)了解更多。

通过将所有属性传递给底层元素，就可以在单元素组件中轻松实现应用所有 HTML 属性。我们可以通过传递相应的 HTML 属性来解决自定义属性问题：

```
const Avatar = props => <img className="avatar" {...props} />;

Avatar.propTypes = {
  src: PropTypes.string.isRequired,
  alt: PropTypes.string.isRequired
};
```

现在 `Avatar` 使用起来更像一个 HTML 元素了：

```
<Avatar src={profile.photoUrl} alt={profile.photoAlt} />
```

如果底层 HTML 元素接受 `children` 属性，这条规则也同样适用。

#### 规则 #4：应用作为属性传递的样式规则

在应用中的某个地方，你可能希望单元素组件有一个稍微不同的样式。你应该可以通过 `className` 或 `style` 属性来自定义它。

单元素组件内部样式等同于浏览器应用到原生 HTML 元素的样式。也就是说，当我们的 `Avatar` 组件收到一个 `className` 属性时，不应该用来替换内部值 — 而是追加进去。

```
const Avatar = ({ className, ...props }) => (
  <img className={`avatar ${className}`} {...props} />
);

Avatar.propTypes = {
  src: PropTypes.string.isRequired,
  alt: PropTypes.string.isRequired,
  className: PropTypes.string
};
```

如果我们将 `style` 属性应用于 `Avatar` 组件，可以使用[对象扩展](https://github.com/tc39/proposal-object-rest-spread/blob/master/Spread.md) 轻松完成应用：

```
const Avatar = ({ className, style, ...props }) => (
  <img 
    className={`avatar ${className}`}
    style={{ borderRadius: "50%", ...style }}
    {...props} 
  />
);

Avatar.propTypes = {
  src: PropTypes.string.isRequired,
  alt: PropTypes.string.isRequired,
  className: PropTypes.string,
  style: PropTypes.object
};
```

现在我们就可以像下面这样将新样式应用到单元素组件：

```
<Avatar
  className="my-avatar"
  style={{ borderWidth: 1 }}
/>
```

如果你发现自己需要复制新样式，请毫不犹豫地创建另一个组成 `Avatar` 的单元素组件。创建一个包含另一个单元素组件没问题 — 通常也是必须的。

#### 规则 #5：应用所有作为属性传递的事件处理方法

由于我们将所有属性向下传递，单元素组件已经准备好接收任何事件处理属性。但是，如果组件内部已经应用了这个事件的处理，我们该怎么办？

这种情况下，我们有两个选择：使用传递的处理方法替换掉内部处理方法，或者两个都调用。这取决于你。只要确保**始终**应用来自属性传递的事件处理方法。

```
const callAll = (...fns) => (...args) => fns.forEach(fn => fn && fn(...args));

const internalOnLoad = () => console.log("loaded");

const Avatar = ({ className, style, onLoad, ...props }) => (
  <img 
    className={`avatar ${className}`}
    style={{ borderRadius: "50%", ...style }}
    onLoad={callAll(internalOnLoad, onLoad)}
    {...props} 
  />
);

Avatar.propTypes = {
  src: PropTypes.string.isRequired,
  alt: PropTypes.string.isRequired,
  className: PropTypes.string,
  style: PropTypes.object,
  onLoad: PropTypes.func
};
```

### 建议

#### [建议 #1: 避免使用自定义属性](#c3e6)

在创建单元素组件 — 特别是在应用中开发新功能时 — 很容易去添加自定义属性来满足不同的使用。

使用 `Avatar` 组件举个例子，设计师建议有些地方头像是方形的，而其它地方应该是圆形。你也许认为给组件添加一个 `rounded` 属性是一个好主意。

除非你正在创建一个文档良好的开源库，否则，**千万不要那样**。除了文档需要，那样还会导致不可扩展和代码的不可维护。总是创建一个新的单元素组件 — 比如 `AvatarRounded` — 它会渲染 `Avatar` 并做一些修改，而不是去添加自定义属性。

如果你坚持使用独特的描述性命名、创建可靠的组件，你将会创建成百上千个组件。它们依然是高度可维护的。组件名就可以作为文档。

#### 建议 #2：接收作为属性传递的 HTML 元素

并不是每个自定义属性都是不好的。有时你想要改变单元素组件中包裹的 HTML 元素。通过添加一个自定义属性来达到这个目的可能是唯一方法。

```
const Button = ({ as: T, ...props }) => <T {...props} />;

Button.propTypes = {
  as: PropTypes.oneOfType([PropTypes.string, PropTypes.func])
};

Button.defaultProps = {
  as: "button"
};
```

一个常见的例子是将 `Button` 组件渲染为 `<a>` 元素，如下：

```
<Button as="a" href="https://google.com">
  Go To Google
</Button>
```

或者作为另一个元素的使用：

```
<Button as={Link} to="/posts">
  Posts
</Button>
```

如果你对这个功能感兴趣，我建议你看一下 [Reas](https://github.com/diegohaz/reas) 项目，这是一个使用 Singel 理念构建的 React UI 工具包。

### 使用 Singel CLI 来验证你的单元素组件

最后，在阅读完所有内容之后，你可能想知道是否有工具可以根据此模式自动验证元素。我开发了这样一个工具，叫做 [Singel CLI](https://github.com/diegohaz/singel)。

如果你想在正在进行的项目中使用它，我建议你创建一个新的文件夹并把你的单元素组件放在里面。

如果你正在使用 React，你可以通过 **npm** 安装 `singel` 并运行它，如下：

```
$ npm install --global singel
$ singel components/*.js
```

输出结果类似于下面这样：

![](https://cdn-images-1.medium.com/max/800/1*fE7wp8PS2EG7043OYcQhkg.png)

另一种方法是在项目中作为开发依赖安装，并在 `package.json` 文件中添加脚本：

```
$ npm install --dev singel

{  
  "scripts": {  
    "singel": "singel components/*.js"  
  }  
}
```

然后，运行 **npm** 脚本吧：

```
$ npm run singel
```

### 感谢阅读！

如果你喜欢这篇文章并发现它很有用，你可以通过以下方式来表达你的支持：

*   点击 ❤️ 按钮喜欢这篇文章
*   Star ⭐️ 我的 GitHub 项目：[https://github.com/diegohaz/singel](https://github.com/diegohaz/singel)
*   在 GitHub 上关注我：[https://github.com/diegohaz](https://github.com/diegohaz)
*   在 Twitter 上关注我：[https://twitter.com/diegohaz](https://twitter.com/diegohaz)

感谢 [Raphael Thomazella](https://medium.com/@thomazella?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
