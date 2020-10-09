> * 原文地址：[Using Service Workers with React](https://blog.bitsrc.io/using-service-workers-with-react-27a4c5e2d1a9)
> * 原文作者：[Shaumik Daityari](https://medium.com/@ds_mik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/using-service-workers-with-react.md](https://github.com/xitu/gold-miner/blob/master/article/2020/using-service-workers-with-react.md)
> * 译者：[plusmultiply0](https://github.com/plusmultiply0)
> * 校对者：[loststar](https://github.com/loststar)

# 在 React 中使用 Service Worker

![Image by [200 Degrees](https://pixabay.com/users/200degrees-2051452/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2165376) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2165376)](https://cdn-images-1.medium.com/max/2560/1*WAsSdE5Mh8fHLlDQDVYnSA.png)

如果你在前端开发中使用 React，那么你有可能听说过 Service Worker。如果你不确定它是做什么的，或者不知道如何适当的配置它，这份在 React 中使用 Service Worker 的初学者指南，将会让你在 React 中实现功能丰富的离线体验，有一个良好的开端。

Service Worker 是由客户端浏览器运行的脚本。它们和 DOM 没有直接关系并且提供了许多与网络相关且开箱即用的功能。Service Worker 是构建离线应用的基础。它也具有推送通知和后台同步等功能。

如果你能在 React 中启用并正确配置 Service Worker，你就可以通过拦截和管理网络请求以探索无尽的可能性。当你用 `create-react-app` 命令创建 React 应用时，Service Worker 会通过内置的 `SWPrecacheWebpackPlugin` 插件自动被添加进应用。Service Worker 确保了网络不再是响应请求的瓶颈。

## Service Worker：使用案例

网络连接的丢失是开发者在确保稳定连接时面临的常见问题。因此，近些年来，通过离线应用以确保良好的用户体验的概念逐渐流行起来。Service Worker 为 web 开发者提供了诸多好处：

* 提升网站性能，仅缓存让网站加载得更快的关键部分
* 通过离线优先来增强用户体验，即使用户失去了网络连接，也能正常使用应用
* 具有通知和推送功能的 API，这是传统 web 技术所没有的
* 具有后台同步功能，你可以推迟某些操作直到网络连接恢复以确保持续的用户体验

## Service Worker：生命周期

Service Worker 的生命周期与 web 应用的生命周期无关。你可以通过使用 JavaScript 来注册 Service Worker 以安装它。这会指示浏览器开始在后台安装 Service Worker，同时也在缓存必需的资产文件。当安装的步骤成功后，激活的过程就开始了。一旦被激活后，它将与作用域内的所有页面产生关联。除非被获取和消息（Fetch/Messahe）事件所调用，否则它将会终止以节省内存。

Service Worker 的生命周期显然需要开发人员编码来完成。在 React 中的 Service Worker 的生命周期是由 React 自身来处理，这让开发者启用 Service Worker 的过程变得更加简单了。

![Service Worker Lifecycle ([Source](https://developers.google.com/web/fundamentals/primers/service-workers))](https://cdn-images-1.medium.com/max/2000/1*HUnu3nbBSq2lDoOSllBkiA.png)

## React Service Workers：关键因素

在进行 React Service Worker 的配置和激活前，让我们来看一下使用 Service Worker 的规则和注意事项。

* Service Worker 被浏览器在其自己的全局脚本上下文环境中执行。这意味着你不能直接访问页面中的 DOM 元素。因此，需要一个间接的方式来让 Service Worker 与它控制的页面进行通信。这个可以通过使用 [postMessage](https://developer.mozilla.org/en-US/docs/Web/API/Client/postMessage) 接口来实现。
* 除了在 localhost 下运行时，Service Worker 只能运行在 `HTTPS` 协议下。
* Service Worker 不限于特定的页面，因此可以被重复使用。
* Service Worker 是事件驱动的。这意味着一旦它们运行结束就不能保留任何信息。为了访问先前状态的信息，你需要使用 [IndexedDB API](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)。

## 启用 React Service Worker

当你通过 `create-react-app` 命令创建 React 应用时，项目的结构应该如下面所示：

```
├── README.md
├── node_modules
├── package.json
├── .gitignore
├── build
├── public
│   ├── favicon.ico
│   ├── index.html
│   └── manifest.json
└── src
    ├── App.css
    ├── App.js
    ├── App.test.js
    ├── index.css
    ├── index.js
    ├── logo.svg
    └── serviceWorker.js
```

注意位于 `src` 目录下的 `serviceWorker.js` 文件。默认情况下，这个文件会随你创建 React 应用时一同被创建。

现在，Service Worker 还没有注册。所以，你应该先注册它,然后再将它用于你的应用。

为了注册 Service Worker，打开 `src/index.js` 文件，然后找到下面这一行代码：

```js
serviceWorker.unregister();
```

将代码改成下面这样。

```js
serviceWorker.register();
```

现在，这行代码就能让你在 React 应用中使用 Service Worker。

在一般的 web 应用中，你需要自己编写 Service Worker 的整个生命周期的代码。然而，React 默认提供了 Service Worker 并且能让开发者直接使用它。打开 `src/serviceWorker.js` 文件，你会注意到 Service Worker 的底层方法都是现成的。

## 在开发环境中使用 React Service Worker

当你在 `serviceWorker.js` 文件中查看 `register()` 函数时，你会注意到，默认情况下，它只在生产环境中有用（`process.env.NODE_ENV === 'production'` 是被设置的条件之一）。如下有两个变通的方法：

* 你可以在 `register()` 函数中去掉判断条件以在开发模式下启用它。但是，这可能会导致某些缓存问题。
* 一个更简单的方法是，创建生产版本的 React 应用并运行在本地服务器上。你可以通过运行以下的命令来实现：

```
$ yarn global add serve
$ yarn build
$ serve -s build
```

在浏览器中打开 `localhost:5000` 来看看具体效果。

## 在 CRA 中配置自定义 Service Worker

CRA 的默认 `service-worker.js` 文件缓存所有的静态资产文件（aeests）。为了给 Service Worker 添加新的功能，你需要创建一个 `custom-service-worker.js` 文件，然后修改 `register()` 函数来加载你的自定义文件。

看到 `serviceWorker.js` 文件的第 34 行，找到 `load()` 事件监听器然后在里面添加你的自定义文件。

```js
window.addEventListener('load', () => {
     const swUrl = `${process.env.PUBLIC_URL}/custom-service-worker.js`;
     ...
}
```

接着，像下面这样更新 `package.json` 文件。

```
"scripts": {
   "start": "react-app-rewired start",
   "build": "react-app-rewired build",
   "test": "react-app-rewired test",
   "eject": "react-app-rewired eject"
},
```

安装 [Google’s Workbox plugin](https://developers.google.com/web/tools/workbox/guides/codelabs/webpack)

```bash
npm install --save-dev workbox-build
```

然后，你需要创建一个配置文件以指示 CRA 来插入你的自定义 Service Worker。

```js
const WorkboxWebpackPlugin = require("workbox-webpack-plugin");
module.exports = function override(config, env) {
  config.plugins = config.plugins.map((plugin) => {
    if (plugin.constructor.name === "GenerateSW") {
      return new WorkboxWebpackPlugin.InjectManifest({
       swSrc: "./src/custom-service-worker.js",
       swDest: "service-worker.js"
      });
    }
    return plugin;
  });
  return config;
};
```

如下所示，你可以创建一个自定义 Service Worker 来缓存特定的目录。

```js
workbox.routing.registerRoute(
  new RegExp("/path/to/cache/directory/"),
  workbox.strategies.NetworkFirst()
);
workbox.precaching.precacheAndRoute(self.__precacheManifest || [])
```

确保重新构建你的应用以让上述更改生效。

## 总结回顾

在本文中，我们介绍了 Service Worker 是什么，使用它的原因以及在 React 应用中使用和配置 Service Worker 的过程。Service Worker 是现代 web 开发的关键部分，在现有的 React 应用中加上 Service Worker 是一个非常棒的主意。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
