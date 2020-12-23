> - 原文地址：[Is Virtual DOM Derived From Document Fragments?](https://medium.com/better-programming/is-virtual-dom-derived-from-document-fragments-74f8841f9e6d)
> - 原文作者：[Jennifer Fu](https://medium.com/@jenniferfubook)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/is-virtual-dom-derived-from-document-fragments.md](https://github.com/xitu/gold-miner/blob/master/article/2020/is-virtual-dom-derived-from-document-fragments.md)
> - 译者：[regon-cao](https://github.com/regon-cao)
> - 校对者：[zenblo](https://github.com/zenblo) [Usualminds](https://github.com/Usualminds)

# 虚拟 DOM 源自文档片段吗？

![Photo by [Manuel Sardo](https://unsplash.com/@manuelsardo?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*DPFY7vtuIvJOsS0x)

[虚拟 DOM](https://reactjs.org/docs/faq-internals.html) 是 React 的一个核心概念。它是保留在内存中并与实际 DOM 同步的 UI 的表现形式。[React DOM](https://github.com/facebook/react/tree/master/packages/react-dom) 通过本地协调差异来维护虚拟 DOM，其更改基于 React 拉取计划并插入到实际 DOM 中。

`[DocumentFragment](https://developer.mozilla.org/en-US/docs/Web/API/DocumentFragment)` 是一个定义了最小文档对象而没有父对象的接口。它被当作轻量级的 `Document` ，用来存储 DOM 对象。文档片段对实际 DOM 没有影响，但其子节点可以按需插入到实际的 DOM 里。

虚拟 DOM 和文档片段采用相同的理念去提升 UI 的性能。这能说明虚拟 DOM 源自文档片段吗？

让我们来深入了解 JavaScript、React 和 Angular 里的相关概念。

## 什么是 DOM？

[文档对象模型 (DOM) ](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Introduction) 是由 web 文档结构和内容组成的数据对象。DOM 是 HTML 和 XML 的一个接口，我们可以通过它来修改文档结构、样式和内容。DOM 将文档表示为节点和对象，这样 JavaScript 之类的编程语言就可以访问 web 页面了。

这是一个 DOM 树的例子：

![Image credit: Wikipedia](https://cdn-images-1.medium.com/max/2000/0*TKQ3K93zzwrqDFcb.png)

你想测试一下页面加载 1,000,000 个节点的性能吗？尝试下面的 `index.html`：

```HTML
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
  </head>
  <body>
    <div id="container"></div>
    <script>
      function addChildren(container) {
        const startTime = new Date();
        for (let i = 0; i < 1000000; i++) {
          const child = document.createElement('div');
          child.innerText = i;
          container.appendChild(child);
        }
        const endTime = new Date();
        console.log(endTime - startTime); // 大约 2514ms
      }
      const container = document.getElementById('container');
      addChildren(container);
    </script>
  </body>
</html>
```

每次运行的加载时间都有些变化，但基本都在 2.5 秒左右。

DOM 操作的代价很昂贵，添加和删除元素会导致页面内容的重绘和重排。

## 为什么使用文档片段？

`document.createDocumentFragment()` 创建了一个空的 `DocumentFragment`，可以添加不被屏幕渲染的 DOM 节点进去。在离屏 DOM 树创建之后，`DocumentFragment` 的子节点可以按需更新到真正的 DOM 中去。

因为文档片段存在内存中，并非实际 DOM 的一部分，给它添加子元素不会引起页面回流（元素的位置和几何形状的计算）。通过文档片段批量更新减少了更新次数，从而更有可能提升性能。

下面是如何使用文档片段的例子：

```HTML
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
  </head>
  <body>
    <div id="container"></div>
    <script>
      function addChildren(container) {
        const startTime = new Date();
        for (let i = 0; i < 1000000; i++) {
          const child = document.createElement('div');
          child.innerText = i;
          container.appendChild(child);
        }
        const endTime = new Date();
        console.log(endTime - startTime); // 大约 1223ms
      }
      const container = document.getElementById('container');
      const fragment = document.createDocumentFragment();
      addChildren(fragment);
      const startTime = new Date();
      container.appendChild(fragment);
      const endTime = new Date();
      console.log(endTime - startTime); // 大约 324ms
    </script>
  </body>
</html>
```

每次运行的加载时间都有些变化，但基本都在 1.5 秒左右。

在子元素插入到实际 DOM 之后（第 25 行），文档片段会变成空对象。如果你想复用更新的内容，在插入 DOM 之前先克隆一下文档片段。

有趣的是，可以利用空文档片段来重复构建将来的更新。

## 虚拟 DOM 是如何工作的？

虚拟 DOM 源自文档片段吗？

答案是否定的，虚拟 DOM 不使用任何文档片段。

当然，虚拟 DOM 源自使用虚构的 DOM 来提高性能的这一概念。但是虚拟 DOM 是为大规模更新而设计的。它也可以应用于不存在 DOM 的环境，比如 Node.js。React 是第一个使用虚拟 DOM 的主流框架。此外，Vue、Ember、Preact 和 Mithril 都采用了虚拟 DOM 技术。

React 在第 16 版之后一直使用 [Fiber 架构](https://github.com/acdlite/react-fiber-architecture)。

> “在一次交互中，不需要每个更新都立即执行；实际上这么做得不偿失，它会导致帧丢失并降低用户体验。
>
> 不同的更新有不同的优先级 — 比如动画的更新应该优先于数据的更新被完成。
>
> 基于推送的方式要求应用(实际是开发者) 去决定如何安排更新计划。基于拉取的方式让框架（React）变的聪明了，它可以替你做出决定。” — [GitHub 上的 React Fiber 架构](https://github.com/acdlite/react-fiber-architecture)

React 具有一些独立的消除差异和渲染的阶段。

- **处理差异:** React 用来区分两棵树之间差异的算法决定了哪些内容需要修改。不同的组件被认为是不同的树。React 不会试图区分它们，而是完全替换旧树。列表的差异是用键来区分的。键应该是稳定的，可预测的，独一无二的。
- **渲染:** 渲染过程根据差异点来实际更新和渲染应用程序。它可以将渲染工作分割成块，并将块分散到多个帧上执行。它使用一个虚拟的栈帧来控制工作，给不同类型的工作设置优先级，重复执行之前完成的工作，终止不再需要的工作。

这种分割让 React DOM 和 React Native 在共享同一个协调器的同时可以使用各自的渲染器。

下面是一个展示虚拟 DOM 优势的例子。这是 [Create React App](https://medium.com/better-programming/10-fun-facts-about-create-react-app-eb7124aa3785) 里经过修改的 `public/index.html`：

```HTML
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta
      name="description"
      content="Web site created using create-react-app"
    />
    <link rel="apple-touch-icon" href="%PUBLIC_URL%/logo192.png" />
    <!--
      manifest.json provides metadata used when your web app is installed on a
      user's mobile device or desktop. See https://developers.google.com/web/fundamentals/web-app-manifest/
    -->
    <link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
    <!--
      Notice the use of %PUBLIC_URL% in the tags above.
      It will be replaced with the URL of the `public` folder during the build.
      Only files inside the `public` folder can be referenced from the HTML.
Unlike "/favicon.ico" or "favicon.ico", "%PUBLIC_URL%/favicon.ico" will
      work correctly both with client-side routing and a non-root public URL.
      Learn how to configure a non-root public URL by running `npm run build`.
    -->
    <title>React App</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <span id="pureDom"></span>
    <span id="root"></span>
    <!--
      This HTML file is a template.
      If you open it directly in the browser, you will see an empty page.
You can add webfonts, meta tags, or analytics to this file.
      The build step will place the bundled scripts into the <body> tag.
To begin the development, run `npm start` or `yarn start`.
      To create a production bundle, use `npm run build` or `yarn build`.
    -->
  </body>
</html>
```

第 30 行和第 31 行是两个并排的 `span` 元素。

下面是修改后的 `src/app.js` 文件，它返回了一个 `select` 元素。从 React 17 开始，React 组件可以单独使用 JSX 而无需引入 React。

```JavaScript
function App() {
  return (
    <select>
      <option value="apple">Apple</option>
      <option value="pear">Pear</option>
    </select>
  );
}
export default App;
```

The following is a modified `src/index.js`:

```JavaScript
import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';

const updateRender = () => {
  document.getElementById('pureDom').innerHTML = `
  <select>
    <option value="apple">Apple</option>
    <option value="pear">Pear</option>
  </select>
  `;

  ReactDOM.render(
    <React.StrictMode>
      <App />
    </React.StrictMode>,
    document.getElementById('root')
  );
};

setInterval(updateRender, 1000);

// 如果想在你的应用里测试性能, 可以传递一个函数记录结果 （例如：reportWebVitals(console.log)）
// 或者发送到统计端口。 学习更多： https://bit.ly/CRA-vitals
reportWebVitals();
```

第 8-13 行使用实际的 DOM 渲染一个 `select` 元素。

第 15-20 行使用虚拟 DOM 渲染一个 `select` 元素。

下面显示的是两个并排的选中 `Apple` 的 `select` 元素。

![](https://cdn-images-1.medium.com/max/2000/1*4JdRMubVMO74wspoE7sIDQ.png)

当在第 23 行触发更新时，两个 `select` 元素每秒都会被创建一次。

尝试为两个 `select` 选中 `Pear`。

![](https://cdn-images-1.medium.com/max/2000/1*oypRBs4_g8WmGAYFbq1Zbw.png)

左边的 `select` 是直接渲染到 DOM 里，频繁的创建让我们不能选中 `Pear`。

右边的 `select` 首先渲染到虚拟 DOM 里，频繁的创建是发生在虚拟 DOM 里的。因此，这个 `select` 元素能正常工作。

## 关于 React 片段

为了让情况更加有趣，React 创建了 `React.Fragment` 语法，它可以包裹一组子元素而不额外引入新的 DOM 节点。下面的是 `React.Fragment` 的例子。

```JavaScript
return (
  <React.Fragment>
    {new Array(1000000).fill(0).map((_, i) => (
      <div key={i}>{i}</div>
    ))}
  </React.Fragment>
);
```

`React.Fragment` 可以被简写成空标签：

```JavaScript
return (
  <>
    {new Array(1000000).fill(0).map((_, i) => (
      <div key={i}>{i}</div>
    ))}
  <>
);
```

直接用带有键的 `\<React.Fragment>` 申明一个 React 片段。这是[官方文档](https://reactjs.org/docs/fragments.html)提供的一个例子：

```JavaScript
function Glossary(props) {
  return (
    <dl>
      {props.items.map(item => (
        // 没有 `key`, React 会发出警告
        <React.Fragment key={item.id}>
          <dt>{item.term}</dt>
          <dd>{item.description}</dd>
        </React.Fragment>
      ))}
    </dl>
  );
}
```

除了命名相似，React 片段和文档片段没有任何关系。

---

## 什么是增量 DOM?

[增量 DOM](https://github.com/google/incremental-dom) 是一个构建 DOM 树并在数据变化时正确地更新它们的库。它和虚拟 DOM 不同之处在于不创建中间树（直接在真正的 DOM 里修改）。这种方式明显减少了增量更新 DOM 树时的内存分配和反复的垃圾回收次数，因此在某些情况下可以显著地提升性能。

增量 DOM 移除了 DOM 的额外拷贝。这样减少了内存使用量，但也降低了寻找 DOM 树差异的速度。减少内存使用量对于手机或者其他内存受限的设备至关重要。

增量 DOM 主要用作模板语言（如 Angular）的编译目标。从第 9 版开始，Angular 采用了 Angular Ivy，它是一个编译器并且在运行时使用增量 DOM。

这是来自[官方网站](http://google.github.io/incremental-dom/)的例子：

```JavaScript
function renderPart() {
  elementOpen('div');
    text('Hello world');
  elementClose('div');
}
```

上面的代码被转换为：

```JavaScript
<div>
  Hello world
</div>
```

调用上面的 `renderPart` 函数，`patch` 函数可以将想要的结构渲染到已经存在的 `Element` 或者 `Document` 里。

```JavaScript
patch(document.getElementById('someId'), renderPart);
```

## 什么是影子 DOM?

影子 DOM 是一种确保代码、样式和结构封装在一个单独的、隐藏的 DOM 树中的技术。影子 DOM 可以被附加到 DOM 中的元素里。影子 DOM 是 Web 组件的一部分，使用一套不同的技术来创建可重用的自定义元素。

下面是影子 DOM 的一个例子：

```HTML
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <script>
      class NewNumberListElement extends HTMLElement {
        constructor() {
          super();
          const shadow = this.attachShadow({ mode: 'open' });
          for (let i = 0; i < 1000000; i++) {
            const child = document.createElement('div');
            child.innerText = i;
            shadow.appendChild(child);
          }
        }
      }

      customElements.define('new-number-list-element', NewNumberListElement);
    </script>
  </head>
  <body>
    <div id="container">
      <new-number-list-element />
    </div>
  </body>
</html>
```

第 8-18 行用影子 DOM 定义了一个元素类。类名被定义为一个新标签名 `new-number-list-element`，并注册到了 `window.customElements` 上（第 20 行）。第 25 行使用了新创建的标签。

在 Angular Ivy 之前，旧的编译器和运行时的视图引擎使用的就是影子 DOM。

## 总结

我们已经回答了 “虚拟 DOM 源自文档片段吗？” 这个问题。

在这一长串的回答中，我们探讨了 DOMs，文档片段，虚拟 DOM，React 片段，增量 DOM 和 影子 DOM。这些知识对我们面试和日常编码都有用处。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
