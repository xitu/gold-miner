> * 原文地址：[Using Service Workers with React](https://blog.bitsrc.io/using-service-workers-with-react-27a4c5e2d1a9)
> * 原文作者：[Shaumik Daityari](https://medium.com/@ds_mik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/using-service-workers-with-react.md](https://github.com/xitu/gold-miner/blob/master/article/2020/using-service-workers-with-react.md)
> * 译者：
> * 校对者：

# Using Service Workers with React

![Image by [200 Degrees](https://pixabay.com/users/200degrees-2051452/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2165376) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2165376)](https://cdn-images-1.medium.com/max/2560/1*WAsSdE5Mh8fHLlDQDVYnSA.png)

If you use React for front end development, chances are that you have heard of service workers. If you are not sure what they do, or how to configure them properly, this beginner’s guide to service workers in React should serve as a good first step in creating feature-rich, offline experiences in React.

Service workers are scripts that are run by the browser. They do not have any direct relationship with the DOM. They provide many out of the box network-related features. Service workers are the foundation of building an offline experience. They enable features such as push notifications and background sync.

Service workers are scripts that are run by the browser of a client. They do not have any direct relationship with the DOM. They provide many out of the box network-related features. Service workers are the foundation of building an offline experience. They enable features such as push notifications and background sync.

If you develop the ability to activate and properly configure service workers in React, you can utilize endless possibilities by judiciously intercepting and managing network requests. In React, service workers are automatically added when you create your application through the `create-react-app` command, through `SWPrecacheWebpackPlugin`. Service workers ensure that the network is not a bottleneck to serve new requests.

## Service Workers: Use Cases

The loss of network is a common issue that developers face in ensuring a seamless connection. Thus, in recent times, the concept of offline applications to ensure superior user experience is gaining popularity. Service workers provide web developers with a lot of benefits:

* They improve the performance of your website. Caching key parts of your website only helps in making it load faster.
* Enhances user experience through an offline-first outlook. Even if one loses connectivity, one can continue to use the application normally.
* They enable notification and push APIs, which are not available through traditional web technologies.
* They enable you to perform background sync. You can defer certain actions until network connectivity is restored to ensure a seamless experience to the user.

## Service Workers: Lifecycle

The lifecycle of a service worker is not linked to that of your web application. You install a service worker by registering it using JavaScript. This instructs the browser to begin installing it in the background. This is also the time when you get to cache your required assets. When the installation step is successful, the activation process starts. Once activated, the service worker is associated with any page in its scope. Unless it is invoked by an event, it will be terminated.

The lifecycle of a service worker typically needs to be coded by the developer. In case of service workers in React, the life cycle management is handled by React itself, which makes the process easier for a developer to enable and use service workers.

![Service Worker Lifecycle ([Source](https://developers.google.com/web/fundamentals/primers/service-workers))](https://cdn-images-1.medium.com/max/2000/1*HUnu3nbBSq2lDoOSllBkiA.png)

## React Service Workers: Key Considerations

Before you jump onto the activation and configuration of a React service worker, let us look at the principles and considerations that govern the usage of service workers.

* Service workers are executed by the browser in their own global script context. This means that you do not have direct access to your page’s DOM elements. Therefore, you need an indirect way for service workers to communicate with pages that they are supposed to control. This is handled through the `[postMessage](https://developer.mozilla.org/en-US/docs/Web/API/Client/postMessage)` interface.
* Service workers run only on the `HTTPS` protocol. The only exception here is when you run it in localhost.
* They are not tied to a particular page, and therefore, can be reused.
* Service workers are event-driven. This means that service workers can not retain any information once they shut down. In order to access information from earlier states, you need to use the [IndexedDB API](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API).

## Activate React Service Workers

When you create a React application through the `create-react-app` command, the project layout looks like the structure shown below:

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

Notice the `serviceWorker.js` file in the `src` directory. By default, this file is generated when you create a React application.

At this stage, your service worker is not registered, so you will have to first register it before utilizing it in your application.

To register the service worker, navigate to the `src/index.js` file, and look for the following line:

```js
serviceWorker.unregister();
```

Change it to the following line.

```js
serviceWorker.register();
```

This single line change will now enable you to use service workers in your React application.

In a general web application, you would have to code the whole lifecycle of a service worker. However, React enables service workers by default and allows a developer to directly get into working with them. Navigate to the `src/serviceWorker.js` file and you will notice that the underlying methods of a service worker are present.

## Working with React Service Workers in Development Environment

If you explore the function `register()` in the file `serviceWorker.js`, you would notice that by default, it works only in production mode (process.env.NODE_ENV === 'production' is set as one of the conditions). There are two workarounds to it.

* You can remove this condition from the function `register()` to enable it in development mode. However, this could potentially lead to some caching issues.
* A cleaner way of enabling service workers is to create a production version of your React app, and then serve it. You can run the following commands to do so:

```
$ yarn global add serve
$ yarn build
$ serve -s build
```

Head over to `localhost:5000` in a browser to check the served application.

## Configure a Custom Service Worker to CRA

CRA’s default `service-worker.js` caches all static assets. To add any new functionality to your service workers, you need to create a new file `custom-service-worker.js` and then modify the `register()` function to load your custom file.

Around line 34 in the `serviceWorker.js` file, look for the `load()` even listener and add your custom file to it.

```js
window.addEventListener('load', () => {
     const swUrl = `${process.env.PUBLIC_URL}/custom-service-worker.js`;
     ...
}
```

Next, update the `package.json` file as below.

```
"scripts": {
   "start": "react-app-rewired start",
   "build": "react-app-rewired build",
   "test": "react-app-rewired test",
   "eject": "react-app-rewired eject"
},
```

In this step, we will invoke [Google’s Workbox plugin](https://developers.google.com/web/tools/workbox/guides/codelabs/webpack).

```bash
npm install --save-dev workbox-build
```

Next, you need to create a config file to instruct CRA to insert our custom service worker.

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

You can then proceed to create the custom service worker to cache a particular directory as shown below.

```js
workbox.routing.registerRoute(
  new RegExp("/path/to/cache/directory/"),
  workbox.strategies.NetworkFirst()
);
workbox.precaching.precacheAndRoute(self.__precacheManifest || [])
```

Ensure that you build your application again for the changes to take effect.

## Final Thoughts

In this post, we covered what service workers are, why they should be used, and the process of using and configuring service workers in your React application. Service workers form a critical part of modern web development and it is a good idea to incorporate them into your existing React applications.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
