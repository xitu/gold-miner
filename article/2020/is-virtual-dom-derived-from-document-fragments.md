> * 原文地址：[Is Virtual DOM Derived From Document Fragments?](https://medium.com/better-programming/is-virtual-dom-derived-from-document-fragments-74f8841f9e6d)
> * 原文作者：[Jennifer Fu](https://medium.com/@jenniferfubook)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/is-virtual-dom-derived-from-document-fragments.md](https://github.com/xitu/gold-miner/blob/master/article/2020/is-virtual-dom-derived-from-document-fragments.md)
> * 译者：
> * 校对者：

# Is Virtual DOM Derived From Document Fragments?

![Photo by [Manuel Sardo](https://unsplash.com/@manuelsardo?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*DPFY7vtuIvJOsS0x)

The [virtual DOM](https://reactjs.org/docs/faq-internals.html) is a core concept of React. It’s a representation of the UI that’s kept in memory and synced with the actual DOM. The [React DOM](https://github.com/facebook/react/tree/master/packages/react-dom) maintains the virtual DOM by reconciling the differences locally. The changes are inserted into the actual DOM based on the React pulling schedule.

`[DocumentFragment](https://developer.mozilla.org/en-US/docs/Web/API/DocumentFragment)` is an interface that defines the minimal document object without a parent. It’s used as a lightweight version of `Document` and stores DOM objects. Document fragments have no effect on the actual DOM. But their children can be added to the actual DOM on demand.

The virtual DOM and document fragments use the same concept to improve the UI performance. Is the virtual DOM derived from document fragments?

Let’s take a look at these JavaScript, React, and Angular concepts in depth.

## What’s a DOM?

A [document object model (DOM)](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Introduction) is the data representation of objects that comprise the structure and content of a document on the web. A DOM is an interface for HTML and XML documents. It represents the page so that programs can change the document structure, style, and content. The DOM represents the document as nodes and objects. In this way, programming languages, such as JavaScript, can connect to the page.

This is an example of a DOM tree:

![Image credit: Wikipedia](https://cdn-images-1.medium.com/max/2000/0*TKQ3K93zzwrqDFcb.png)

Do you want to evaluate performance while under the pressure of loading 1,000,000 nodes? Try out the following `index.html`:

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
        console.log(endTime - startTime); // around 2514ms
      }
      const container = document.getElementById('container');
      addChildren(container);
    </script>
  </body>
</html>
```

The time duration varies for each run, but it's approximately 2.5 seconds.

DOM manipulation is an expensive operation. Adding/removing an element results in intermediate repaints and reflows of the content.

## Why Are Document Fragments Used?

document.createDocumentFragment() creates a new empty `DocumentFragment` into which DOM nodes can be added to build an offscreen DOM tree. After the offscreen DOM tree is built, the child nodes of `DocumentFragment` can be updated to the DOM as needed.

Since a document fragment is in the memory and not part of the actual DOM, appending children to it doesn't cause page reflow (the computation of an element’s position and geometry). Likely, batching changes with fewer updates by document fragments will end up with better performance.

Here’s an example of how the document fragment is used:

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
        console.log(endTime - startTime); // around 1223ms
      }
      const container = document.getElementById('container');
      const fragment = document.createDocumentFragment();
      addChildren(fragment);
      const startTime = new Date();
      container.appendChild(fragment);
      const endTime = new Date();
      console.log(endTime - startTime); // around 324ms
    </script>
  </body>
</html>
```

The time duration varies for each run, but it’s approximately 1.5 seconds.

After appending children to the actual DOM (line 25), the document fragment becomes empty. If you want to reuse the updated contents, clone the document fragment before appending it to the DOM.

Interestingly, the empty document fragment can be reused to build future updates.

## How Does a Virtual DOM Work?

Is a virtual DOM derived from document fragments?

No, a virtual DOM doesn’t use any document fragments.

Yes, a virtual DOM is derived from the concept to use an imaginary DOM for the purpose of performance improvement. However, a virtual DOM is designed for large-scale updates. It can also be applied to an environment where a DOM doesn't exist, such as Node.js. React was the first mainstream framework to use a virtual DOM. In addition, a virtual DOM has been adopted by Vue, Ember, Preact, and Mithril.

Beginning in version 16, React has been using the [Fiber Architecture](https://github.com/acdlite/react-fiber-architecture).

> “In a UI, it’s not necessary for every update to be applied immediately; in fact, doing so can be wasteful, causing frames to drop and degrading the user experience.
>
> Different types of updates have different priorities — an animation update needs to complete more quickly than, for example, an update from a data store.
>
> A push-based approach requires the app (you, the programmer) to decide how to schedule work. A pull-based approach allows the framework (React) to be smart and make those decisions for you.” — [React Fiber Architecture on GitHub](https://github.com/acdlite/react-fiber-architecture)

React is designed to have separate phases of reconciliation and rendering.

* **Reconciliation:** The algorithm React uses to diff one tree with another to determine which parts need to be changed. Different component types are assumed to generate substantially different trees. React won’t attempt to diff them but rather replace the old tree completely. Diffing of lists is performed using keys. Keys should be stable, predictable, and unique.
* **Rendering:** The process uses diff information to actually update the rendered app. It can split rendering work into chunks and spread it out over multiple frames. It uses a virtual stack frame to pause work and come back to it later, assign priority to different types of work, reuse previously completed work, and abort work if it’s no longer needed.

This separation allows the React DOM and React Native to use their own renderers while sharing the same reconciler.

Here’s an example to show the advantages of Virtual DOM. This is modified `public/index.html` from [Create React App](https://medium.com/better-programming/10-fun-facts-about-create-react-app-eb7124aa3785):

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

Line 30 and 31 are two side-by-side `span` elements.

The following is a modified `src/app.js` file that renders a `select` element in React. Beginning in React 17, React components no longer need to import React for using JSX.

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

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
```

Lines 8-13 render a `select` element using the actual DOM.

Lines 15-20 render a `select` element using a virtual DOM.

It shows two `select` elements side by side with `Apple` selected.

![](https://cdn-images-1.medium.com/max/2000/1*4JdRMubVMO74wspoE7sIDQ.png)

When the update is triggered by line 23, two `select` elements are recreated every second.

Try to select `Pear` for both elements.

![](https://cdn-images-1.medium.com/max/2000/1*oypRBs4_g8WmGAYFbq1Zbw.png)

The left `select` is directly rendered to the DOM. The recreation makes it impossible to choose `Pear`.

The right `select` is rendered to the virtual DOM first. The frequent recreation happens on the virtual DOM instead of the actual DOM. Therefore, the `select` element works properly.

## About React Fragment

To make the situation more interesting, React created a syntax to group a list of children without adding extra nodes to the DOM. This syntax is called `React.Fragment`. The following is an example of `React.Fragment`.

```JavaScript
return (
  <React.Fragment>
    {new Array(1000000).fill(0).map((_, i) => (
      <div key={i}>{i}</div>
    ))}
  </React.Fragment>
);
```

`React.Fragment` can be simplified to an empty tag:

```JavaScript
return (
  <>
    {new Array(1000000).fill(0).map((_, i) => (
      <div key={i}>{i}</div>
    ))}
  <>
);
```

Fragments declared with the explicit `\<React.Fragment>` syntax may have keys. This is an example provided by [the official document](https://reactjs.org/docs/fragments.html):

```JavaScript
function Glossary(props) {
  return (
    <dl>
      {props.items.map(item => (
        // Without the `key`, React will fire a key warning
        <React.Fragment key={item.id}>
          <dt>{item.term}</dt>
          <dd>{item.description}</dd>
        </React.Fragment>
      ))}
    </dl>
  );
}
```

Besides the naming, fragments have nothing to do with document fragments.

---

## What’s Incremental DOM?

[Incremental DOM](https://github.com/google/incremental-dom) is a library for building up DOM trees and updating them in place when data changes. It differs from a virtual DOM approach in that no intermediate tree is created (the existing tree is mutated in place). This approach significantly reduces memory allocation and GC thrashing for incremental updates to the DOM tree, therefore increasing performance significantly in some cases.

Incremental DOM removes the additional copy of the DOM. This results in reduced memory usage, but this also results in reduced speed while looking for differences. The reduced memory usage is key for mobile or other memory-constrained devices.

Incremental DOM is primarily intended as a compilation target for templating languages such as Angular. Beginning in version 9, Angular adopted Angular Ivy, which is a compiler and runtime that uses an incremental DOM.

This is an example from [the official website](http://google.github.io/incremental-dom/):

```JavaScript
function renderPart() {
  elementOpen('div');
    text('Hello world');
  elementClose('div');
}
```

The above code would correspond to:

```JavaScript
<div>
  Hello world
</div>
```

Using the `renderPart` function from above, the `patch` function can be used to render the desired structure into an existing `Element` or `Document`.

```JavaScript
patch(document.getElementById('someId'), renderPart);
```

## What’s Shadow DOM?

Shadow DOM is a technique ensuring that the code, styling, and structure are encapsulated in a separate, hidden DOM tree. Shadow DOM can be attached to an element in a DOM. The Shadow DOM is part of Web Components, a suite of different technologies to create reusable custom elements.

The following is an example of Shadow DOM:

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

Lines 8-18 define an element class in Shadow DOM. This class is defined as a new tag, `new-number-list-element`, registered to `window.customElements` (line 20). The newly created custom element is used at line 25.

Before Angular Ivy, the old compiler and runtime was View Engine, which used Shadow DOM.

## Conclusion

We have answered the question “is a virtual DOM derived from document fragments?”

For the long answer, we’ve walked though DOMs, document fragments, the virtual DOM, React fragments, Incremental DOM, and Shadow DOM. This knowledge is useful for interviews as well as for daily coding.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
