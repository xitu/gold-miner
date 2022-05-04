> - 原文地址：[New Suspense SSR Architecture in React 18](https://github.com/reactwg/react-18/discussions/37)
> - 原文作者：[]()
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/new-suspense-ssr-architecture-in-react-18.md](https://github.com/xitu/gold-miner/blob/master/article/2021/new-suspense-ssr-architecture-in-react-18.md)
> - 译者：[NieZhuZhu（弹铁蛋同学）](https://github.com/NieZhuZhu)
> - 校对者：[Kimberly](https://github.com/kimberlyohq)、[Zavier](https://github.com/zaviertang)

# React 18 中新的 Suspense SSR 架构

## 概述

React 18 将包括对 React 服务器端渲染（SSR）性能的架构改进。这些改进是实质性的，并且是几年来工作的结晶。这些改进大多是在幕后进行的，但有一些选择性机制你需要注意，特别是如果你**不使用**框架的话。

主要的新 API 是  `pipeToNodeWritable`，你可以在 [Upgrading to React 18 on the Server](https://github.com/reactwg/react-18/discussions/22) 中了解到。我们计划在细节上做更多的实现，因为这不是最终版本，并且还有一些事情需要解决。

现有的主要的 API 是  `<Suspense>`.

本文是对新的架构以及它的设计和所解决的问题的简单概述。

## 简而言之

服务器端渲染（在这篇文章中缩写为 “SSR”）让你能在服务器上将 React 组件生成 HTML，并将该 HTML 发送给你的用户。SSR 能让你的用户在你的 JavaScript 包加载和运行之前看到页面的内容。

React 中的 SSR 总是分几个步骤进行：

- 在服务器上获取整个应用的数据。
- 然后在服务器上将整个应用程序渲染成 HTML 并在响应中返回。
- 然后在客户端加载整个应用程序的 JavaScript 代码。
- 然后在客户端将 JavaScript 逻辑绑定到服务器为整个应用程序生成的 HTML（这个过程叫 “hydration”）。

关键在于，每一步都必须在下一步开始之前一次性完成整个应用程序的工作。如果你的应用程序的某些部分比其他部分慢，这样做的效率不高。这也是几乎所有具有一定规模的应用面临的问题。

React 18 让你使用  `<Suspense>`  来将你的应用程序分解成较小的独立单元。这些单元将独立完成这些步骤，并且不会阻碍应用程序的其他部分。因此，你的应用程序的用户将更快地看到内容，并能更快地开始与应用程序交互。你的应用程序中最慢的部分不会拖累那些较快的部分。这些优化是自动的。你不需要写任何特殊的代码来实现这个功能。

这也意味着 `React.lazy` 现在可以和 SSR 一起 “正常工作”。这里有一个 [demo](https://codesandbox.io/s/github/facebook/react/tree/master/fixtures/ssr2?file=/src/App.js).

**(如果你不使用框架，你将需要改变 HTML 生成的具体方式 [wired up] (https://codesandbox.io/s/github/facebook/react/tree/master/fixtures/ssr2?file=/server/render.js:590-1736)。)**

## 什么是 SSR？

当用户加载你的应用程序时，你希望尽快展示一个完全可交互的页面：

![](https://camo.githubusercontent.com/8b2ae54c1de6c1b24d9080d2a50a68141f7f57252803543c30cc69cdd4b82fa1/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f784d50644159634b76496c7a59615f3351586a5561413f613d354748716b387a7939566d523255565a315a38746454627373304a7553335951327758516f3939666b586361)

这幅插图用绿色来表达页面的可交互的部分。换句话说，它们所有的 JavaScript 事件处理程序都已经绑定好了，点击按钮可以更新状态等等。

然而，在页面的 JavaScript 代码完全加载之前，该页面是不能交互的。这包括 React 本身和你的应用程序代码。对于具有一定规模的应用程序，大部分的加载时间将用于下载你的应用程序代码。

如果你不使用 SSR，用户在 JavaScript 加载时看到的唯一东西就是一个空白的页面。

![](https://camo.githubusercontent.com/7fac45f105cd741a94db77234465c4c85843b1e6f902b21bbdb1fe5b52d25a05/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f39656b30786570614f5a653842764679503244652d773f613d6131796c464577695264317a79476353464a4451676856726161375839334c6c726134303732794c49724d61)

这不是很好，这就是为什么我们建议使用 SSR。SSR 让你在**服务器上**把你的 React 组件渲染成 HTML 并发送给用户。HTML 的交互性不强（除了简单的内置网络交互，如链接和表单输入）。但是，它能让用户在 JavaScript 仍在加载时看到**一些东西**。

![](https://camo.githubusercontent.com/e44ee4be56e56e74da3b9f7f5519ca6197b24e9c34488df933140950f1b31c38/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f534f76496e4f2d73625973566d5166334159372d52413f613d675a6461346957316f5061434668644e36414f48695a396255644e78715373547a7a42326c32686b744a3061)

这里，屏幕中灰色部分代表还没有完全可交互的部分。你的应用程序的 JavaScript 代码还没有加载完成，所以点击按钮是没有任何响应的。但特别是对于内容繁杂的网站，SSR 非常有用，因为它可以让网络连接较差的用户在 JavaScript 加载时开始阅读或查看内容。

当 React 和你的应用代码都在加载时，你要让这个 HTML 是可交互的。你告诉 React：“这是在服务器上生成这个 HTML 的 `App` 组件。将事件处理程序绑定到该 HTML 上！” React 会在内存中渲染你的组件树，但不是为其生成 DOM 节点，而是将所有逻辑绑定到现有的 HTML 上。

这个渲染组件和绑定事件处理程序的过程被称为 “hydration”。（这就像是用事件处理程序当作 “水” 来浇灌 “干燥” 的 HTML。至少，我是这样向自己解释这个术语的。）

hydration 之后，就是 “React 正常操作”：你的组件可以设置状态，响应点击等等：

![](https://camo.githubusercontent.com/98a383f6de8ee2bde7516dc540aae6d9bb02a074c43c201ef6746bf3b8450420/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f715377594e765a58514856423970704e7045344659673f613d6c3150774c4844306b664a61495971474930646a53567173574a345544324c516134764f6a6f4b7249785161)

你可以看到 SSR 有点像 “魔术”。它不能使你的应用程序更快地完全可交互。相反，它让你更快地展示你的应用程序的非交互式版本，以便用户在等待 JS 加载时可以查看静态内容。然而，这一招对于网络连接不畅的人来说有很大的不同，而且提高了整体的感知性能。它还有助于你的搜索引擎排名，既是因为有更容易的索引，也是因为有更快的响应速度。

> **注意： 不要将 SSR 与服务器组件混淆。服务器组件是一个更具实验性的功能，目前仍在研究中，并且可能不会成为 React 18 最初版本的一部分。你从[这里](https://reactjs.org/blog/2020/12/21/data-fetching-with-react-server-components.html)可以了解服务器组件。服务器组件是对 SSR 的补充，并将成为数据获取的推荐方式之一，但这篇文章并不介绍它们。**

## 今天 SSR 有哪些问题？

上述方法是可行的，但在许多方面，它并不是最佳的。

### 在展示任何东西之前，必须先获取所有东西

如今 SSR 的一个问题是，它不允许组件 “等待数据”。在目前的 API 中，当你渲染到 HTML 时，你必须已经在服务器上为你的组件准备好所有的数据。这意味着你必须在服务器上收集**所有的**数据，然后才能开始向客户端发送**任何** HTML。这样是很低效的。

例如，假设你想渲染一个带有评论的帖子。尽早显示评论是很重要的，所以你要在服务器的 HTML 输出中包括它们。但你的数据库或 API 层很慢，这是你无法控制的。现在，你必须做出一些艰难的选择。如果你把它们从服务器输出中排除，在 JS 加载完毕之前，用户就不会看到它们。但如果你把它们包含在服务器输出中，你就必须推迟发送其余的 HTML（例如，导航栏、侧边栏，甚至是文章内容），直到评论加载完毕，你才能渲染完整的组件树。这样并不好。

> 顺便提一下，一些数据获取方案会反复尝试将树渲染成 HTML 并丢弃结果，直到数据被解决。因为 React 没有提供更符合人体工程学的选项。我们想提供一个不需要如此极端妥协的解决方案。

### 你必须先装好所有的东西，然后才能对任何东西进行 hydration

在你的 JavaScript 代码加载后，你会告诉 React 将 HTML “hydrate” 并使其具有交互性。 React 在渲染你的组件时将 “走” 过服务器生成的 HTML，并将事件处理程序绑定到该 HTML 上。为了使其发挥作用，你的组件在浏览器中生成的树必须与服务器生成的树相匹配。否则 React 就不能 “匹配它们！” 这样做的一个非常不幸的后果是，你必须在客户端加载**所有**组件的 JavaScript，才能开始对**任何**组件进行 hydration

例如，假设评论小组件包含很多复杂的交互逻辑，并且需要花费一些时间为其加载 JavaScript。 现在你不得不再次做出艰难的选择。把服务器上的评论渲染成 HTML，以便尽早显示给用户，这是一个好办法。但是，由于如今的 hydration 只能一次完成，所以在加载评论小组件的代码之前，你不能开始 hydrate 导航栏、侧边栏和文章内容。当然，你可以使用代码分割并单独加载，但你必须将注释从服务器 HTML 中排除。否则 React 将不知道如何处理这块 HTML（它的代码在哪里？），并在 hydration 过程中删除它。

### 在与任何东西互动之前，你必须 hydrate 所有的东西

hydration 本身也有一个类似的问题。如今，React 一次性完成树的 hydration。这意味着，一旦它开始 hydrate（本质上是调用你的组件函数），React 就不会停止 hydration 的过程，直到它为整个树完成 hydration。因此，你必须等待**所有的**组件被 hydrated，才能与**任何**组件进行交互。

例如，我们说评论小组件有昂贵的渲染逻辑。它在你的电脑上可能运行得很快，但在低端设备上运行这些逻辑的成本并不低，甚至可能使得屏幕被锁定好几秒钟。当然，在理想情况下，我们在客户端不会这样的逻辑（这是服务器组件可以帮助解决的问题）。但对于某些逻辑来说，这是不可避免的。这是因为它决定了所附的事件处理程序应该做什么，而且对于交互性是至关重要的。因此，一旦开始 hydration，用户就不能与导航栏、侧边栏或文章内容互动，直到整棵树完成 hydration。对于导航来说，这是特别不幸的，因为用户可能想完全离开这个页面，但由于我们正忙于 hydration，我们把他们留在他们不再关心的当前页面上。

### 我们如何解决这些问题？

这些问题之间有一个共同点。它们迫使你在早做一些事情（但因为它阻碍了所有其他工作，导致用户体验被损害），或晚做一些事情（但因为你浪费时间，导致用户体验被损害）之间做出选择。

这是因为有一个 “瀑布”（流程）：获取数据（服务器）→ 渲染成 HTML（服务器）→ 加载代码（客户端）→ hydration（客户端）。任何一个阶段都不能在前一个阶段结束之前开始。 这就是为什么它的效率很低。我们的解决方案是将工作分开，这样我们就可以为屏幕的一部分而不是整个应用程序做这些阶段的工作。

这并不是一个新奇的想法：比如说：[Marko](https://tech.ebayinc.com/engineering/async-fragments-rediscovering-progressive-html-rendering-with-marko/) 是实现该模式的一个 JavaScript 网络框架。将这样的模式适应于 React 编程模型具有一定的挑战性。我们也因此花了一段时间来解决这个难题。我们在 2018 年为此目的引入了 `<Suspense>` 组件。当我们引入它时，我们只支持它在客户端进行惰性加载代码。但我们的目标是将它与服务器渲染结合起来，解决这些问题。

让我们看看如何在 React 18 中使用 `<Suspense>` 来解决这些问题。

## React 18：流式 HTML 和选择性 hydration

在 React 18 中，有两个主要的 SSR 功能是由 Suspense 解锁的。

- 在服务器上流式传输 HTML。要使用这个功能，你需要从 `renderToString` 切换到新的 `pipeToNodeWritable` 方法，如[此处描述](https://github.com/reactwg/react-18/discussions/22)。
- 在客户端进行选择性的 hydration。要使用这个功能，你需要在客户端 [切换到`createRoot`](https://github.com/reactwg/react-18/discussions/5)，然后开始用 `<Suspense>` 包装你的应用程序的一部分。

为了了解这些功能的作用以及它们如何解决上述问题，让我们回到我们的例子。

### 在所有数据被获取之前，使用流式 HTML

如今的 SSR 中，渲染 HTML 和 hydration 是 “全有或全无” 的。首先，你要渲染所有的 HTML：

```source-js
<main>
  <nav>
    <!--NavBar -->
    <a href="/">Home</a>
   </nav>
  <aside>
    <!-- Sidebar -->
    <a href="/profile">Profile</a>
  </aside>
  <article>
    <!-- Post -->
    <p>Hello world</p>
  </article>
  <section>
    <!-- Comments -->
    <p>First comment</p>
    <p>Second comment</p>
  </section>
</main>
```

客户端最终会收到它：

![](https://camo.githubusercontent.com/e44ee4be56e56e74da3b9f7f5519ca6197b24e9c34488df933140950f1b31c38/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f534f76496e4f2d73625973566d5166334159372d52413f613d675a6461346957316f5061434668644e36414f48695a396255644e78715373547a7a42326c32686b744a3061)

然后你加载所有的代码，并对整个应用程序进行 hydration：

![](https://camo.githubusercontent.com/8b2ae54c1de6c1b24d9080d2a50a68141f7f57252803543c30cc69cdd4b82fa1/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f784d50644159634b76496c7a59615f3351586a5561413f613d354748716b387a7939566d523255565a315a38746454627373304a7553335951327758516f3939666b586361)

但是 React 18 给了你一个新的可能性。你可以用 `<Suspense>` 来包装页面的一部分。

例如，让我们包裹评论块并告诉 React，在它准备好之前，React 应该显示 `<Spinner /> `组件。

```source-js
<Layout>
  <NavBar />
  <Sidebar />
  <RightPane>
    <Post />
    <Suspense fallback={<Spinner />}>
      <Comments />
    </Suspense>
  </RightPane>
</Layout>
```

通过将 `<Comments>` 包装成 `<Suspense>`，我们告诉 React，它不需要等待评论就可以开始为页面的其他部分传输 HTML。相反，React 将发送占位符（一个旋转器）而不是评论：

![](https://camo.githubusercontent.com/484be91b06f3f998b3bda9ba3efbdb514394ab70484a8db2cf5774e32f85a2b8/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f704e6550316c4253546261616162726c4c71707178413f613d716d636f563745617955486e6e69433643586771456961564a52637145416f56726b39666e4e564646766361)

现在在最初的 HTML 中找不到评论了：

```source-js
<main>
  <nav>
    <!--NavBar -->
    <a href="/">Home</a>
   </nav>
  <aside>
    <!-- Sidebar -->
    <a href="/profile">Profile</a>
  </aside>
  <article>
    <!-- Post -->
    <p>Hello world</p>
  </article>
  <section id="comments-spinner">
    <!-- Spinner -->
    <img width=400 src="spinner.gif" alt="Loading..." />
  </section>
</main>
```

事情到这里还没有结束。当服务器上的评论数据准备好后，React 会将额外的 HTML 发送到同一个流中，以及一个最小的内联 `<script>` 标签，将 HTML 放在 “正确的地方”。

```source-js
<div hidden id="comments">
  <!-- Comments -->
  <p>First comment</p>
  <p>Second comment</p>
</div>
<script>
  // This implementation is slightly simplified
  document.getElementById('sections-spinner').replaceChildren(
    document.getElementById('comments')
  );
</script>
```

因此，甚至在 React 本身加载到客户端之前，迟来的评论的 HTML 就会 “弹出”。

![](https://camo.githubusercontent.com/e44ee4be56e56e74da3b9f7f5519ca6197b24e9c34488df933140950f1b31c38/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f534f76496e4f2d73625973566d5166334159372d52413f613d675a6461346957316f5061434668644e36414f48695a396255644e78715373547a7a42326c32686b744a3061)

这就解决了我们的第一个问题。现在你不必在显示任何东西之前获取所有的数据了。如果屏幕的某些部分延迟了最初的 HTML，你就不必在延迟**所有的** HTML 或将其排除在 HTML 之外之间做出选择。你可以只允许那部分内容在 HTML 流中稍后 “涌入”。

不同于传统的流式 HTML，它不一定要按照自上而下的顺序发生。例如，如果**侧边栏**需要一些数据，你可以用 Suspense 包装它，React 将会发出一个占位符，然后继续渲染帖子。然后，当侧边栏的 HTML 准备好了，React 会把它和 `<script>` 标签一起流出来，把它插入到正确的位置 ——— 尽管帖子的 HTML（在树中更远的地方）已经被发送出去了！没有要求数据以任何特定的顺序加载。你指定旋转器应该出现在哪里，剩下的就由 React 来解决。

> **注意事项：为了使其发挥作用，你的数据获取解决方案需要与 Suspense 集成。服务器组件将与 Suspense 开箱即用，但我们也将为独立的 React 数据获取库提供一种方法来与之集成。**

### 在所有代码加载之前对页面进行 hydration

我们可以提前发送最初的 HTML，但我们仍然有一个问题。在加载评论小组件的 JavaScript 代码之前，我们不能在客户端开始对我们的应用程序进行 hydration。如果代码的大小很大，这可能需要一段时间。

为了避免大型包，你通常会使用 “代码拆分”：你可以指定一段代码不需要同步加载，你的打包工具将把它分割成一个单独的 `<script>` 标签。

你可以使用 `React.lazy` 进行代码分割，将评论代码从主包中分割出来。

```source-js
import { lazy } from 'react';

const Comments = lazy(() => import('./Comments.js'));

// ...

<Suspense fallback={<Spinner />}>
  <Comments />
</Suspense>
```

以前，这与服务器渲染中是不奏效的。（据我们所知，即使是流行的变通方法也迫使你在选择不使用代码拆分组件的 SSR 或在所有代码加载后对其进行 hydration 之间做出选择，这在某种程度上违背了代码拆分的目的）。

但在 React 18 中，`<Suspense>` 可以让你在评论小组件加载之前就 hydrate 应用程序。

从用户的角度来看，最初他们看到的是以 HTML 形式流进来的非交互式内容。

![](https://camo.githubusercontent.com/484be91b06f3f998b3bda9ba3efbdb514394ab70484a8db2cf5774e32f85a2b8/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f704e6550316c4253546261616162726c4c71707178413f613d716d636f563745617955486e6e69433643586771456961564a52637145416f56726b39666e4e564646766361)

![](https://camo.githubusercontent.com/e44ee4be56e56e74da3b9f7f5519ca6197b24e9c34488df933140950f1b31c38/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f534f76496e4f2d73625973566d5166334159372d52413f613d675a6461346957316f5061434668644e36414f48695a396255644e78715373547a7a42326c32686b744a3061)

然后你告诉 React 进行 hydration。虽然评论的代码还没有出现，但也没关系：

![](https://camo.githubusercontent.com/4892961ac26f8b8dacbd53189a8d3fd1b076aa16fe451f8e2723528f51b80f66/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f304e6c6c3853617732454247793038657149635f59413f613d6a396751444e57613061306c725061516467356f5a56775077774a357a416f39684c31733349523131636f61)

这是一个选择性 hydration 的例子。通过将 `Comments` 包裹在 `<Suspense>`中，你告诉 React，他们不应该阻止页面的其他部分进行流式传输 ——— 而且，事实证明，也不应该阻止 hydration。这意味着第二个问题已经解决了：你不再需要等待所有的代码加载完成，才能开始 hydration。React 可以在加载部分时同时进行 hydration。

React 会在评论部分的代码加载完毕后开始对其部分进行 hydration：

![](https://camo.githubusercontent.com/8b2ae54c1de6c1b24d9080d2a50a68141f7f57252803543c30cc69cdd4b82fa1/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f784d50644159634b76496c7a59615f3351586a5561413f613d354748716b387a7939566d523255565a315a38746454627373304a7553335951327758516f3939666b586361)

得益于选择性 hydration，一块沉重的 JS 并不妨碍页面的其他部分具有交互性。

### 在所有的 HTML 都被流化之前，对页面进行 hydration

React 会自动处理这一切，所以你不需要担心事情会以意外的顺序发生。例如，也许 HTML 需要一段时间来加载，即使它正在被流化：

![](https://camo.githubusercontent.com/484be91b06f3f998b3bda9ba3efbdb514394ab70484a8db2cf5774e32f85a2b8/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f704e6550316c4253546261616162726c4c71707178413f613d716d636f563745617955486e6e69433643586771456961564a52637145416f56726b39666e4e564646766361)

如果 JavaScript 代码的加载时间早于所有的 HTML，React 就没有理由等待了！它将为页面的其他部分进行 hydration：

![](https://camo.githubusercontent.com/ee5fecf223cbbcd6ca8c80beb99dbea40ccbacf1b281f4cf8ac6970c554eefa3/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f384c787970797a66786a4f4a753475344e44787570413f613d507a6a534e50564c61394a574a467a5377355776796e56354d715249616e6c614a4d77757633497373666761)

当评论的 HTML 加载时，因为 JS 还没有出现，所以它将显示为非交互式：

![](https://camo.githubusercontent.com/4892961ac26f8b8dacbd53189a8d3fd1b076aa16fe451f8e2723528f51b80f66/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f304e6c6c3853617732454247793038657149635f59413f613d6a396751444e57613061306c725061516467356f5a56775077774a357a416f39684c31733349523131636f61)

最后，当评论小组件的 JavaScript 代码加载时，页面将变得完全可交互：

![](https://camo.githubusercontent.com/8b2ae54c1de6c1b24d9080d2a50a68141f7f57252803543c30cc69cdd4b82fa1/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f784d50644159634b76496c7a59615f3351586a5561413f613d354748716b387a7939566d523255565a315a38746454627373304a7553335951327758516f3939666b586361)

### 在所有组件完成 hydration 之前与页面互动

当我们将评论包裹在 `<Suspense>` 中时，还有一项改进发生在幕后。现在它们的 hydration 不再阻碍浏览器做其他工作。

例如，假设用户在评论正在 hydration 时点击了侧边栏：

![](https://camo.githubusercontent.com/6cc4eeef439feb3c17d0ac09c701c0deffe170c60a039afa8c0b85d7d4b9c9ef/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f5358524b357573725862717143534a3258396a4769673f613d77504c72596361505246624765344f4e305874504b356b4c566839384747434d774d724e5036374163786b61)

在 React 18 中，浏览器可以在给 Suspense 里的内容进行 hydration 的过程中出现的微小空隙中进行事件处理。得益于此，点击被立即处理，在低端设备上长时间的 hydration 过程中，浏览器不会出现卡顿。例如，这可以让用户从他们不再感兴趣的页面上导航离开。

在我们的例子中，只有评论被包裹在 Suspense 中，所以对页面的其他部分进行 hydration 是一次性的。然而，我们可以通过在更多的地方使用 Suspense 来解决这个问题。例如，让我们把侧边栏也包起来。

```source-js
<Layout>
  <NavBar />
  <Suspense fallback={<Spinner />}>
    <Sidebar />
  </Suspense>
  <RightPane>
    <Post />
    <Suspense fallback={<Spinner />}>
      <Comments />
    </Suspense>
  </RightPane>
</Layout>
```

现在**两者**都可以在包含导航条和帖子的初始 HTML 之后从服务器上流传。但这也会对 hydration 产生影响。比方说，它们的 HTML 已经加载，但它们的代码还没有加载：

![](https://camo.githubusercontent.com/9eab3bed0a55170fde2aa2f8ac197bc06bbe157b6ee9446c7e0749409b8ed978/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f78744c50785f754a55596c6c6746474f616e504763413f613d4e617972396c63744f6b4b46565753344e374e6d625335776a39524473344f63714f674b7336765a43737361)

然后，包含侧边栏和评论代码的包被加载。React 将尝试对它们进行 hydration，从它在树中较早发现的 Suspense 边界开始（在这个例子中，它是侧边栏）：

![](https://camo.githubusercontent.com/6542ff54670ab46abfeb816c60c870ad6194ab15c09977f727110e270517b243/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f424333455a4b72445f72334b7a4e47684b33637a4c773f613d4778644b5450686a6a7037744b6838326f6533747974554b51634c616949317674526e385745713661447361)

但是，假设用户开始与评论小组件进行互动，其代码也被加载：

![](https://camo.githubusercontent.com/af5a0db884da33ba385cf5f2a2b7ed167c4eaf7b1e28f61dac533a621c31414b/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f443932634358744a61514f4157536f4e2d42523074413f613d3069613648595470325a6e4d6a6b774f75615533725248596f57754e3659534c4b7a49504454384d714d4561)

React 会**记录**点击，并优先给评论进行 hydration，因为它更紧急：

![](https://camo.githubusercontent.com/f76a33458a3e698125063884035e7f126104bc2c27c30c02fe8e9ebdf3048c7b/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f5a647263796a4c49446a4a304261385a53524d546a513f613d67397875616d6c427756714d77465a3567715a564549497833524c6e7161485963464b55664f554a4d707761)

在评论被 hydrated 后，React “重放” 记录的点击事件（通过再次派发），并让你的组件对互动做出反应。 然后，现在 React 没有什么紧急的事情要做，因此 React 会给侧边栏进行 hydration：

![](https://camo.githubusercontent.com/64ea29524fa1ea2248ee0e721d1816387127507fd3d73a013f89266162b20fba/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f525a636a704d72424c6f7a694635625a792d396c6b773f613d4d5455563334356842386e5a6e6a4a4c3875675351476c7a4542745052373963525a354449483471644b4d61)

这解决了我们的第三个问题。得益于选择性 hydration，我们不必 “为了与任何东西互动而对所有东西进行 hydration”。 React 尽早开始给所有东西进行 hydration。它根据用户的互动情况，优先考虑屏幕上最紧急的部分。如果你考虑到在整个应用程序中采用 Suspense，边界将变得更加细化，那么选择性 hydration 的好处就更加明显：

![](https://camo.githubusercontent.com/dbbedbfe934b41a8b4e4ed663d66e94c3e748170df599c20e259680037bc506c/68747470733a2f2f717569702e636f6d2f626c6f622f5963474141416b314234322f6c5559557157304a38525634354a39505364315f4a513f613d39535352654f4a733057513275614468356f6932376e61324265574d447a775261393739576e566e52684561)

在这个例子中，用户点击第一条评论时，正好是 hydration 的开始。React 会优先给所有父级 Suspense 边界的内容进行 hydration，但会跳过任何不相关的兄弟节点。因为交互路径上的组件优先被 hydrated，这创造了 hydration 是即时的错觉。React 会在之后对应用程序的其他部分进行 hydration。

在实践中，你可能会在你的应用程序的根部附近添加 Suspense：

```source-js
<Layout>
  <NavBar />
  <Suspense fallback={<BigSpinner />}>
    <Suspense fallback={<SidebarGlimmer />}>
      <Sidebar />
    </Suspense>
    <RightPane>
      <Post />
      <Suspense fallback={<CommentsGlimmer />}>
        <Comments />
      </Suspense>
    </RightPane>
  </Suspense>
</Layout>
```

在这个例子中，最初的 HTML 可以包括 `<NavBar>` 的内容，但其余的内容会在相关代码加载后立即流入，并分部分进行 hydration，优先考虑用户互动过的部分。

> **注意：你可能想知道你的应用程序如何能在这种不完全 hydrated 的状态下运作。设计中有一些微妙的细节，使其发挥作用。例如，不是对每个单独的组件分别进行 hydration，而是对整个 `<Suspense>` 边界进行 hydration。因为 `<Suspense>` 已经被用于不会立即出现的内容，所以你的代码对它的孩子不能立即出现的情况有自适应性。React 总是以父级优先的顺序进行 hydration，所以组件总是有它们的 props 组合。 React 在事件发生地的整个父树 hydration 之前，暂不分派事件。最后，如果父类的更新方式导致尚未 hydrated 的 HTML 变得陈旧，React 将隐藏它，并用你指定的 `fallback` 来代替它，直到代码加载完毕。这确保了树在用户面前显得一致。你不需要考虑这个，但这就是该功能发挥作用的原因。**

## Demo

我们准备了一个 [你可以尝试的演示](https://codesandbox.io/s/github/facebook/react/tree/master/fixtures/ssr2?file=/src/App.js)，看看新的 Suspense SSR 架构如何运作。它被人为地放慢了速度，所以你可以在 `server/delays.js` 中调整延时。

- `API_DELAY`  让你使评论在服务器上需要更长的时间来获取，展示 HTML 的其他部分如何提前发送。
- `JS_BUNDLE_DELAY`  让你延迟 `<script>` 标签的加载，展示评论小组件的 HTML 如何在 React 和你的应用程序包下载之前 “弹出”。
- `ABORT_DELAY` 让你看到服务器 “放弃”，并在服务器上获取时间过长时将渲染工作移交给客户端。

## 总结

React 18 为 SSR 提供了两个主要功能：

- 流式 HTML 让你尽早开始发送 HTML，流式 HTML 的额外内容与 `<script>` 标签一起放在正确的地方。
- 选择性 hydration 让你在 HTML 和 JavaScript 代码完全下载之前，尽早开始为你的应用程序进行 hydration。它还优先为用户正在互动的部分进行 hydration，创造一种即时 hydration 的错觉。

这些功能解决了 React 中 SSR 的三个长期存在的问题：

- 你不再需要等待所有的数据在服务器上加载后再发送 HTML。相反，一旦你有足够的数据来显示应用程序的外壳，你就开始发送 HTML，其余的 HTML 在准备好后再进行流式传输。
- 你不再需要等待所有的 JavaScript 加载来开始 hydration。相反，你可以使用代码拆分和服务器渲染。服务器 HTML 将被保留，React 将在相关代码加载时对其进行 hydration。
- 你不再需要等待所有的组件被 hydrated 后才开始与页面互动了。相反，你可以依靠选择性 hydration，来优先考虑用户正在与之互动的组件，并尽早对它们进行 hydration。

`Suspense` 组件作为所有这些功能的选择。这些改进本身是在 React 内部自动进行的，我们期望它们能与大多数现有的 React 代码一起使用。这展示了声明性地表达加载状态的力量。从 `if (isLoading)` 到 `<Suspense>` 可能看不出很大的变化，但它却是解锁这些改进的关键。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
