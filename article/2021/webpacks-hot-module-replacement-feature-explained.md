> * 原文地址：[Webpack’s Hot Module Replacement Feature Explained](https://blog.bitsrc.io/webpacks-hot-module-replacement-feature-explained-43c13b169986)
> * 原文作者：[Nathan Sebhastian](https://medium.com/@nathansebhastian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/webpacks-hot-module-replacement-feature-explained.md](https://github.com/xitu/gold-miner/blob/master/article/2021/webpacks-hot-module-replacement-feature-explained.md)
> * 译者：
> * 校对者：

# Webpack’s Hot Module Replacement Feature Explained

![](https://cdn-images-1.medium.com/max/2024/1*q3OLOdT-Ep86tfnvugnabw.png)

Developing a JavaScript application involves reloading the browser each time you save code changes in order to refresh the user interface.

Developer tools like Webpack can even run in **watch mode** to monitor your project files for changes. As soon as Webpack detected a change, it will rebuild the application and the browser is reloaded automatically.

But soon developers started to think, is there a way to actually save and reflect changes to the browser without reloading? After all, reloading means losing whatever process you’re making on the UI:

* Any modal or dialog box you’re working on will be gone. You need to go back and redo the steps to make them appear again.
* The state of your application will be reset. If you’re using libraries like React or Vue, this means you need to redo the process to change the state or persist state to the local storage.
* Persisting state to the local storage means writing code. Unless you’re actually persisting state in production, you need to add and remove the code each time you’re developing, which is very inconvenient.
* Even a small change in the CSS code will refresh the browser.

The [Hot Module Replacement (HMR)](https://webpack.js.org/concepts/hot-module-replacement/) feature was created to solve the above problems, and today it has been a valuable help for speeding up front-end development.

## How Hot Module Replacement works

HMR allows you to exchange, add, or remove JavaScript modules while the application is running, all without having to reload the browser. This is made possible in Webpack by creating an **HMR server** inside Webpack Development Server ([webpack-dev-server](https://github.com/webpack/webpack-dev-server)) that communicates with **HMR runtime** in the browser through a websocket.

![How HMR works in a nutshell](https://cdn-images-1.medium.com/max/3840/1*UGYFDKGrQF6ID3CofCHUwg.png)

The process for exchanging modules are as follows:

* The first time you build the application, Webpack generates a manifest file. The manifest contains a compilation hash and a list of all modules. Webpack will inject the **HMR runtime** into the generated `bundle.js` file
* You save file changes, which is detected by Webpack
* The Webpack compiler will build your application with the changes, creating a new manifest file and comparing it with the old one. This process is also known as a **hot update**.
* The **hot update** will be sent to the **HMR server**, which will send the updates to **HMR runtime**.
* **HMR runtime** will unpack the **hot update** and use the appropriate loader to handle the changes. If you have CSS changes, then the CSS loader or Style loader will be called. If you have JavaScript code changes, then usually Babel loader will be called.

By enabling the HMR feature, refreshing the browser in order to download a new bundle becomes unnecessary. The HMR runtime will accept incoming requests from the HMR server that contains the manifest file and chunks of code that will replace the current one in the browser.

When you save code changes while running an application with HMR enabled, you can actually see the hot update file being sent from the HMR server on your Network tab:

![Hot update files under the Network tab](https://cdn-images-1.medium.com/max/2880/1*phxmgjIC0OrLPZVFsWlvyA.png)

When a **hot update** failed to replace the code in the browser, the HMR runtime will let webpack-dev-server know. The webpack-dev-server will then refresh the browser to download a new `bundle.js` file. This behavior can be disabled by adding `hotOnly: true` to your Webpack configuration.

## How to enable HMR feature

To enabling HMR in your project, you need to let your application know how to handle **hot updates.** You can do so by implementing the `module.hot` API exposed by Webpack.

First, you need to enable HMR by adding `hot: true` to your Webpack configuration file as follows:

```js
// webpack.config.js

module.exports = {
  entry: {
     app: './src/index.js',
  },
  devtool: 'inline-source-map',
  devServer: {
    hot: true,
    // ... other config omitted
  },
  plugins: [
    // Enable the plugin
    new webpack.HotModuleReplacementPlugin(),
  ],
}
```

After that, you must handle incoming HMR request by using `module.hot` API. Here’s an implementation example on a vanilla JS project:

```js
// index.js

import component from "./component";

document.body.appendChild(component);

// Check if HMR interface is enabled
if (module.hot) {
  // Accept hot update
  module.hot.accept();
}
```

Once the hot update is accepted, the HMR runtime and the loaders will take over to handle the update.

Still implementing HMR for complex applications can be tricky because you may run into undesired side effects, such as [an event handler still bound to the old function](https://webpack.js.org/guides/hot-module-replacement/#enabling-hmr). This is especially true when you’re using libraries like React or Vue. Furthermore, you also need to make sure that [HMR is only enabled on development](https://webpack.js.org/guides/production/).

Before you try to implement HMR on your own, I’d recommend you to first look for available solutions for your project because HMR has already been integrated into many popular JavaScript application generators.

Both Create React App and Next.js have React Fast Refresh, which is a React-specific implementation of hot reloading, and Vue CLI version 3 has HMR implemented through [vue-loader](https://github.com/vuejs/vue-loader). [Svelte](https://github.com/sveltejs/svelte-loader) and [Angular](https://github.com/PatrickJS/angular-hmr) also has their own HMR integrations, so you don’t have to write the integration from scratch.

## Conclusion

Hot Module Replacement is a feature that enables you to see code changes in the browser without having to refresh it, allowing you to preserve the state of your front-end application.

But implementing HMR can be tricky because it can incur side effects. Fortunately, HMR has already been implemented in many JavaScript application generators, so you can enjoy the feature without having to implement it yourself.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
