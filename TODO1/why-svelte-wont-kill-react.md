> * 原文地址：[Why Svelte won’t kill React](https://medium.com/javascript-in-plain-english/why-svelte-wont-kill-react-3cfdd940586a)
> * 原文作者：[Kit Isaev](https://medium.com/@nikis05)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-svelte-wont-kill-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-svelte-wont-kill-react.md)
> * 译者：[👊Badd](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[PingHGao](https://github.com/PingHGao), [shixi-li](https://github.com/shixi-li)

# 为何 Svelte 杀不死 React

#### 是仅现状造成的吗？还是说只因为 React 更强大？

当我刚刚开始读 Svelte 的文档时，我发现这东西太振奋人心了，我简直想要在 Medium 上写封表扬信给它。而当我读完来自官方博客和社区的一些文章后，我就冷静下来了，因为我注意到了一些在 JavaScript 世界中很常见的言辞 —— 这种言辞让我**非常**苦恼。

> 嘿，是否还记得那个 30 年来人类绞尽脑汁想要解决的问题？我刚刚发现了一个通用的解决方案！为什么它还没征服全世界？这多么显而易见啊。Facebook 的营销团队正在密谋对付我们。

在我看来，你可以说你的工具与现有的工具相比是革命性的。而且人很难对自己的作品保持完全公正的态度，这我能理解。举个正面的例子 —— 与其他解决方案比起来，我觉得 Vue 实在是[干得漂亮](https://vuejs.org/v2/guide/comparison.html)。没错，确实存在一些我不敢苟同的质疑声音，但这些声音都在传达一个建设性的信息：

> 我们的解决方案是怎样怎样的，还有别的一些现有的解决方案。而且我们坚信我们的方案更优秀，原因是什么什么。一些常见的反对论点是什么什么。

Svelte 的官方博客却正好相反，它通过只显露片面的事实来愚弄读者，甚至有时会宣扬一些关于 Web 技术和其他库（我会着重提到 React，只因我对它的理解更深一些）的不实言论。因此在本文中，我会对 Svelte 调侃一二，平衡一下官方吹斜的天平。话虽如此，我仍认为 Svelte 中还是有闪光点的，我会在文末告诉你原因 😊

![[imgflip.com](https://imgflip.com/i/122lno)](https://cdn-images-1.medium.com/max/2000/1*w4uLFcsyeLWeVetzq0VgqQ.jpeg)

## 何为 Svelte？

Svelte 是一个构建用户界面的工具。主流的框架 —— 如 React 和 Vue —— 都是利用虚拟 DOM 根据组件输出进行高效的 DOM 更新，而 Svelte 没有走这条路线，它使用静态分析，在运行时创建 DOM 更新代码<sup>[1](#footnote1)</sup>。 一个 Svelte 组件长这样：

**App.svelte**

```html
<script>
 import Thing from './Thing.svelte';

let things = [
  { id: 1, color: '#0d0887' },
  { id: 2, color: '#6a00a8' },
  { id: 3, color: '#b12a90' },
  { id: 4, color: '#e16462' },
  { id: 5, color: '#fca636' }
 ];

function handleClick() {
  things = things.slice(1);
 }
</script>

<button on:click={handleClick}>
 Remove first thing
</button>

{#each things as thing}
 <Thing color={thing.color}/>
{/each}
```

**Thing.svelte**

```html
<script>
 export let color;
</script>

<p>
 <span style="background-color: {color}">current</span>
</p>

<style>
 span {
  display: inline-block;
  padding: 0.2em 0.5em;
  margin: 0 0.2em 0.2em 0;
  width: 4em;
  text-align: center;
  border-radius: 0.2em;
  color: white;
 }
</style>
```

而对应的 React 组件是这样的：

```jsx
import React, {useState} from 'react'
import styled from 'styled-components';

const things = [
  { id: 1, color: '#0d0887' },
  { id: 2, color: '#6a00a8' },
  { id: 3, color: '#b12a90' },
  { id: 4, color: '#e16462' },
  { id: 5, color: '#fca636' }
 ];

const Block = styled.span`
  display: inline-block;
  padding: 0.2em 0.5em;
  margin: 0 0.2em 0.2em 0;
  width: 4em;
  text-align: center;
  border-radius: 0.2em;
  color: white;
  background-color: ${props => props.backgroundColor}
`;

const Thing = ({color}) => {
  return (
    <p>
      <Block backgroundColor={color} />
    </p>
  );
}

export const App = () => {
  const [things, setThings] = useState(things);
  const removeFirstThing = () => setThings(things.slice(1))
  return (
    <>
      <button onClick={removeFirstThing} />
      {things.map(thing =>
        <Thing key={thing.key} color={thing.color} />
      }
    </>
  );
}
```

#### Svelte 不是一个框架 —— 它是一种语言

Svelte 简单地用 `<script>` 和 `<style>` 创建 Vue 风格的“单文件组件”。该语言中增加了一些结构，用以解决 UI 开发中最大的问题之一 —— 状态管理。

我在[上一篇文章](https://medium.com/swlh/what-is-the-best-state-container-library-for-react-b6989a45f236)提到了几个在 React 里用 JavaScript 解决此问题的方法。Svelte 借助其作为编译器之便利，使得响应性成为该语言的特性 <sup>[2](#footnote2)</sup>。Svelte 引入了两种新型的语言结构来达到这个目的。

* 在语句前加 `$:` 能够[让该语句具有响应性](https://svelte.dev/tutorial/reactive-declarations)的运算符，即每当该语句读取的变量有更新时，它都会被重新执行。一个语句可以是一次赋值（即“依赖变量”或“派生变量”）、一个代码块或者一个调用（即“作用”）。这有点类似 MobX 的方式，只不过是集成到语言中了。
* `$` 一个能[创建指向仓库（存储状态的容器）的订阅](https://svelte.dev/tutorial/auto-subscriptions)的运算符，当组件解除挂载时，该订阅即被自动取消。

Svelte 的响应性概念使我们能够使用常规的 JavaScript 变量存储状态 —— 不再需要状态容器了。但这样做真的提升了开发体验（DX）吗？

![[reddit.com](https://www.reddit.com/r/PrequelMemes/comments/arg2rb/when_people_think_obiwan_only_says_i_dont_think/)](https://cdn-images-1.medium.com/max/2000/1*c0shUq7fn3MHYBr39JJvQQ.jpeg)

## Svelte 的响应性

> React 最初的承诺是，你可以在每次状态改变时重新渲染整个应用，而无需担心性能问题。而实际上，我认为那不准确。如果确实如此，那像 `shouldComponentUpdate`（一种告诉 React 何时可以安全跳过一个组件的方法）这种优化就没有存在的必要了 —— Rich Harris，Svelte 的维护者<sup>[3](#footnote3)</sup>
>
> 真正的问题在于，程序员花费了大量的时间在错误的地点和时间去担心效率；**在编程中，过早优化是万恶（或者至少大部分）之源**。—— Donald Knuth，美国计算机科学家<sup>[4](#footnote4)</sup>

首先，我们得搞清楚一点。就算你的代码中没有任何 `shouldComponentUpdate` 这类优化标识，React 也**不会**在每个状态改变时就重新渲染整个应用。这很容易验证 —— 你只需在应用的根组件调用一次 `console.log`。

![](https://cdn-images-1.medium.com/max/2000/1*ZykZcYuvyFsz-kHNRIJTpg.png)

在此例中，除非 `isAuthorized` 发生改变，否则 `App` 不会被重新渲染。任何子组件的改变都不会导致 `App` 重新渲染。仅当组件自己的状态改变，或者被 React Context 触发，或者父组件重新渲染时，它才会被重新渲染。

最后一种情况导致了所谓的**无用渲染** —— 预先知道父组件重新渲染不会导致子组件 DOM 层级发生任何改变时的渲染。这种无用渲染发生在子组件的 prop 不可变，或者这种改变不会影响可视界面的情况中。你可以通过定义 `shouldComponentUpdate`（或者使用 `React.memo` 作为一个更现代化的功能备选方案）来避免无用渲染。

#### 仅在特殊情况下优化，不要默认开启优化

在绝大多数情况下，无用渲染并没有什么坏处。它们耗费的资源小到了肉眼不可见的程度。事实上，对每个组件的 prop 进行浅层（我甚至都不用说深层）的前后比较，比简单粗暴地重新渲染整个子树占用的资源还多。这就是为什么 React 回退到把 `shouldComponentUpdate: () => true` 作为默认设置。此外，React 团队甚至在调试工具中移除了“highlight updates”特性，因为此前人们习惯毫无根据的优化任何一个无用渲染<sup>[5](#footnote5)</sup>。

这是一个非常危险的做法，因为每次优化都意味着要做假设。当你压缩一张图片时，你就会假设有些负载可以在不影响质量的前提下被削减，当你向后端增加缓存数据时，你就会假设 API 可能会返回相同的结果。恰当的假设能让你节省资源。而不恰当的假设就会给应用带来 Bug。这就是应该合理做优化的原因。

Svelte 选择了相反的处理方式。除非你用 `$:` 运算符做出了明确指定，否则组件代码不会在更新时重新运行。我可不想花上几十个小时来查找我哪个地方忘了加 `$:` 运算符，并试图搞清楚为何我的应用跑不起来 —— 只为了用户能享受那快了 20 毫秒的重渲染。如果偶然遇到一个体积庞大的组件，我确实会优化它，但那是极其少见的情况了。在这一点上死扣开发体验是没有意义的。

#### Svelte 的优化不够优

顺便说，如果我们要在技术上较真，其实 Svelte 检查某个更新是否必需的结果也不总是最优的。假设一个组件的计算开销非常大，它接受一个这样的 prop：`Array<{id: string, otherProps}>`。假设我已知 id 都是唯一的，数组中的元素是不可变的，我可以通过下列代码得出某个更新是否必要：

```js
const shouldUpdate = (prevArr, nextArr) => {
  if (prevArr.length !== nextArr.length) return true;
  return nextArr.some((item, index) => item.id !== prevArr[index].id)
}
```

在 Svelte 中，无法指定自定义的反应比较器（Reaction comparator），只能像这样比较数组：

```js
export function safe_not_equal(a, b) { 
  return a != a ? b == b : a !== b 
    || ((a && typeof a === 'object') || typeof a === 'function');
}
```

我可以使用一些第三方内存工具给 Svelte 的比较器**打个补丁**，这我能接受，但我在意的是 —— 世上没有仙丹神药，优化得“过了头”就会造成束手束脚的限制。

#### 意义不明的状态更新

在 React 中，当你想要更新状态，你必须调用 `setState`。而在 Svelte 中，要更新状态，你得这样：

> …… 被更新的变量的名字必须位于赋值运算的左侧。

Svelte 很神奇地给内部运行时用于出发反应的空函数添加一个调用。这可能会让人抓狂。

```js
const foo = obj.foo;
foo.bar = 'baz';
obj = obj; // 如果你不这样做，更新就不会发生
```

同样，用 `push` 或或其他变种方法更新一个数组，都不会自动触发组件更新。因此你必须用数组或对象扩展：

```js
arr = [...arr, newItem];
obj = {...obj, updatedValue: newValue};
```

这跟在 React 中基本一致，除了在 React 里你要调用函数并把被更新的状态传给函数，而在 Svelte 中你会有种正在处理常规的可变变量的错觉。这种体验会从某种程度上降低 Svelte 的优势，降低你发出“哇哦你看太酷了，Svelte 是一个编译器”这种惊叹的冲动。

## 虚拟 DOM

> 虚拟 DOM 很有价值，因为它使你能在构建应用时不用考虑状态转变，并且性能**一般都足够强劲** —— Rich Harris，Svelte 的维护者<sup>[6](#footnote6)</sup>

Svelte 博客中几乎每篇文章都声称，虚拟 DOM[是一个不必要的开销](https://svelte.dev/blog/virtual-dom-is-pure-overhead)，而且开销相当大，可以轻易地用预先生成的 DOM 更新器替换它并且无副作用。但这句话对吗？不全对。

![[quickmeme.com](http://www.quickmeme.com/meme/362wa3)](https://cdn-images-1.medium.com/max/2000/1*jomQ-J1bF6mx8eziWMnMww.jpeg)

#### 虚拟 DOM 会增加开销吗？

是的，肯定会。虚拟 DOM 不是个特性，把它放进应用中，并不能妙手回春地让潜在的“真实”DOM 和浏览器跑得更快。它只是一种将易写、易读、易调试的声明式代码转为高效、易于执行的命令式 DOM 操作。

但开销就一定是不好的吗？我觉得不是 —— 否则 Svelte 的维护者就得用 Rust 或 C 来写他们的编译器了，因为 JavaScript 的垃圾收集器就是最大的开销。我猜在决定编译器的技术栈时，他们做了一个权衡 —— 开销有多高与社区得到的好处有多大之间的取舍。在这种情况下，开销相对不高 —— 设备上并没有一直在运行的编译器，你只是时不时地运行它而已，涉及到的计算不多，几秒钟的时间不会给用户体验造成很大影响。另一方面，因为 Svelte 基于 JavaScript，并把 JavaScript 作为执行环境，用 TypeScript/JavaScript 开发的工具为开发体验提供了相对可观的好处：每个对此工具感兴趣的人 —— 因此想贡献代码或需要学习编译器源代码 —— 可能都是了解 JavaScript 的人。

因此，对于开销总是需要权衡的。使用虚拟 DOM 所花费的开销是否值得？

#### 虚拟 DOM 的开销

下载、解析并渲染一个 React 应用需要多长时间？

Rich Harris 本人对第一个问题给出了如是答案：

> 我们向用户装载的代码太多了。与许多其他前端开发者一样，我曾一直拒绝承认此事实，觉得给一个页面加载 100kb 的 JavaScript 也无不妥 —— [少用一个 .jpg 就行了](https://twitter.com/miketaylr/status/227056824275333120)！<sup>[7](#footnote7)</sup>

但接下来他说：

> 100kb 的 .js 和 100kb 的 .jpg 不可等而视之。不仅仅是网络时间开销会使应用的启动性能变差，消耗在解析和评估脚本上的时间也会导致此效果，并且在这段时间内浏览器是完全无响应的。<sup>[7](#footnote7)</sup>

听起来好怕怕呀，让我们用 Google Chrome 浏览器的 Audit 工具测量一下。很幸运，借助 [realworld.io](https://realworld.io)，我们能测出结果：

[React-redux](https://react-redux.realworld.io/)：

![](https://cdn-images-1.medium.com/max/2000/1*SA3Uq_pUV82XGQ7JoK6yMw.png)

[Svelte](https://realworld.svelte.dev/)：

![](https://cdn-images-1.medium.com/max/2000/1*apQnSN_tRBq7z_U0D3p_Rg.png)

区别就是 0.15 秒 —— 毛毛雨啦。

那基准测试呢？Svelte 博客提到的[基准测试](https://github.com/krausest/js-framework-benchmark)表明，滑动 1000 行，React 需要 430.7 毫秒，而 Svelte 可以在 51.8 毫秒内做到。

但是这个度量标准并不可信，因为这种特殊操作是 React 做出[协调假设](https://reactjs.org/docs/reconciliation.html)导致的弱点 —— 这种场景在现实世界中很少见，同样的基准测试表明，React 和 Svelte 在几乎其他所有的案例中的差异都可以忽略不计。

![Svelte 和 React-redux 在 hooks 上的比较](https://cdn-images-1.medium.com/max/2000/1*toE8L_WfxGiuMn16chedjQ.png)

现在，我们终于意识到，那些基准测试应该信一半扔一半。我们有窗口和虚拟化可以利用，一次渲染 1000 行真是个馊主意。说真的，你真这样干过吗？

![[tenor.com](https://tenor.com/view/well-then-your-are-lost-you-are-lost-obi-wan-kenobi-starwars-gif-7897510)](https://cdn-images-1.medium.com/max/2000/1*qvW2rqknyPnztVy4KTUfzA.png)

但 Svelte 的维护者声称虚拟 DOM 完全没必要 —— 那何必浪费**任何**资源呢？什么都不做最节约资源。

#### 虚拟 DOM 的杀手锏

虚拟 DOM 有一个杀手锏，是 Svelte 无论如何都打不败的。那就是把组件层级作为对象来处理的能力。

React 代码：

```jsx
const UnorderedList = ({children}) => (
  <ul>
    {
      children.map((child, i) => <li key={i}>{child}</li>
    }
  </ul>
)

const App = () => (
  <UnorderedList>
    <a href="http://example.com">Example</a>
    <span>Example</span>
    Text
  </UnorderedList>
);
```

这个任务对 React 来说小菜一碟，但对 Svelte 来说难于登天。因为模板不是图灵完备（Turing-complete）的，如果是，那它们就得需要虚拟 DOM。看起来似乎问题不大，但对我来说，已经是一个足够正当的理由去给应用额外增加 0.15 秒到 0.25 秒的响应时间了。这正是我们需要虚拟 DOM 之处 —— 我们可能不需要用它来进行响应式的状态更新、条件渲染或者列表渲染，但只要我们有了它，我们就能把组件层级作为完全动态的、可控的对象来处理。没有这个功能，你不可能写出一个真正的声明式应用。

## 暂时性的限制（未来会修复）

还有其他几个不使用 Svelte 的原因，它们可能会被修复。这需要社区成员大量的辛勤付出，但只要成本大于收益，修复就不会发生。

#### 不支持 TypeScript

由于 Svelte 使用了模板，所以很难实现对 TypeScript 的完全支持，比如如 React 一般实现让我们觉得十分便利的支持 prop 检查的 TypeScript 支持。想解决这个问题，要么在 Microsoft TypeScript 实现中做大幅更改（这不太可能，因为 Svelte 的影响力远不如 React），要么新建一个 fork 然后坚持不懈地维护。代码生成也是个可选方案，但对元素层级中的每个细微的改变都运行一次代码生成器，是个可怕的开发体验。

#### 不成熟

> 考虑互用性。想要用 npm 安装炫酷的日历工具并用在自己的应用中？在以前，只有你用的是（一个确定版本的）该工具适配的框架才行 —— 如果 `cool-calendar-widget` 是用 React 开发的，而你在用 Angular，那么好吧，算你倒霉。但如果该工具的作者用了 Svelte 开发，那么你可以随意用哪种框架开发要使用该工具的应用。—— Rich Harris，Svelte 的维护者<sup>[7](#footnote7)</sup>

支持 React 的工具已经是应有尽有了 —— 十几个 GraphQL 客户端、超过 30 个表单状态管理工具、上百个日期组件。

![在 NPM 搜索 “svelte”](https://cdn-images-1.medium.com/max/2000/1*1M853tgrdLL2y9YnUp_Otw.png)

![在 NPM 搜索 “react”](https://cdn-images-1.medium.com/max/2000/1*PNnZjKUyyHMDT6UBd9PBJQ.png)

如果是在 2013 年，那 Svelte 这个功能可以算是杀手锏了，但如今已经不值一提了。

## 前途光明？

虽然上面说了一些局限，但我觉得 Svelte 实际上提出一了个前途无量的概念。没错，如果不牺牲灵活性和代码可重用性，就无法通过模板完整地表达现代应用程序。但**绝大多数**的应用做的都只是条件渲染和列表渲染罢了。然后，我再说一遍，如果我只是在组件中使用 `onChange={e => setState(e.target.value)}` 并渲染一打 `<div>`，那我们为何还要去支持键盘事件、鼠标滚轮事件和内容可编辑功能呢？

实话实说，我并不相信 Svelte 能以当前这种形式打败 React、横扫世界。但如果有一个框架，它没有任何特定的限制，却能 100% 甩脱所有无用的部分，那就太酷了。要是能生成一些在运行时可用的有关其正确执行的构建时提示，那就更棒了。

## 说说可读性

我们已经知道了，Svelte 的主打特性不是性能（这方面的益处微不足道），也没那么神奇（有些警告信息在 JavaScript 里非常少见，理解起来非常吃力，而且缺少调试工具的支持简直雪上加霜），更不具备互用性（放在 2014 年可能还算个角色，但如今我们的 React-NG-Vue 三大框架下已经应有尽有了）。那可读性方面如何呢？

> 差距如此明显，实在不多见 —— 在我的经验里，一个 React 组件要比对应的 Svelte 组件大 40% —— Rich Harris，Svelte 的维护者<sup>[8](#footnote8)</sup>。

![[youtube.com](https://www.youtube.com/watch?v=byP3lzjuQH4)](https://cdn-images-1.medium.com/max/2000/1*H3YESgYacAyOpH31TVVNSQ.jpeg)

每段代码你只会写一次，但会读许多次。我知道这是个人喜好的问题，也知道这是个有争议的话题，但我觉得 JSX 和常规 JavaScript 流运算符要比其他任何形式的 `{#blocks}` 和指令都要通俗易懂。在 Vue 大红大紫前，我就是它的忠实粉丝了。后来我时不时会被一些限制和意义不明的模板绊倒，于是开始全面使用 JSX —— 而因为 JSX 和 Vue 不是一个风格，我后来就转向了 React。我不想再重蹈覆辙。

---

**感谢阅读！ 😍**

衷心希望你们喜欢本文。如果你有什么高见，想要交流或者研讨 —— 我全心全意地欢迎你在评论区留言！

---

引用：

<a name="footnote1">1</a>：[https://svelte.dev/](https://svelte.dev/)  
<a name="footnote2">2</a>：[https://github.com/sveltejs/rfcs/blob/master/text/0001-reactive-assignments.md](https://github.com/sveltejs/rfcs/blob/master/text/0001-reactive-assignments.md)  
<a name="footnote3">3</a>：[https://svelte.dev/blog/virtual-dom-is-pure-overhead](https://svelte.dev/blog/virtual-dom-is-pure-overhead)  
<a name="footnote4">4</a>：[https://en.wikiquote.org/wiki/Donald_Knuth](https://en.wikiquote.org/wiki/Donald_Knuth)  
<a name="footnote5">5</a>：[https://www.reddit.com/r/reactjs/comments/cqx554/introducing_the_new_react_devtools/ex1r9nb/](https://www.reddit.com/r/reactjs/comments/cqx554/introducing_the_new_react_devtools/ex1r9nb/)  
<a name="footnote6">6</a>：[https://svelte.dev/blog/virtual-dom-is-pure-overhead](https://svelte.dev/blog/virtual-dom-is-pure-overhead)  
<a name="footnote7">7</a>：[https://svelte.dev/blog/frameworks-without-the-framework](https://svelte.dev/blog/frameworks-without-the-framework)  
<a name="footnote8">8</a>： [https://svelte.dev/blog/write-less-code](https://svelte.dev/blog/write-less-code)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
