> * 原文地址：[Code Splitting with Parcel Web App Bundler](https://hackernoon.com/code-splitting-with-parcel-web-app-bundler-fe06cc3a20da)
> * 原文作者：[Ankush Chatterjee](https://hackernoon.com/@ankushc?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/code-splitting-with-parcel-web-app-bundler.md](https://github.com/xitu/gold-miner/blob/master/TODO/code-splitting-with-parcel-web-app-bundler.md)
> * 译者：[kk](https://github.com/kangkai124)
> * 校对者：

# 使用 web 应用打包工具 Parcel 实现代码分割

![](https://cdn-images-1.medium.com/max/800/1*3Tp8OGHuIlun20JS84i7DA.gif)

代码分割！这是当今 web 发展中很流行的词语。今天，我们将探索代码分割，看看如何使用 parcel 轻松地实现它。

#### 什么是代码分割？

如果你对它很熟悉，那么你可以跳过这部分。不然的话，还是接着往下读吧。

如果你使用 JavaScript 框架进行前端开发的话，你肯定会把所有的模块打包成一个大的 JavaScript 文件，在页面中引用来它实现需要的功能。但是，这些包太大了！你写了一个十分复杂的 web 应用，包括很多部分，它们肯定会被打包成很大的一个文件；而且对于大文件来说，在网速较慢的情况下下载会需要更长的时间。关键是，用户需要一次性下载全部吗？

想象有这么一个电子商务的单页面应用。用户登录查看产品清单，他可能只是想看一下产品，但是他已经花了很长时间，下载到的 JavaScript 不仅仅是渲染产品那部分，还渲染了过滤、产品详情、供货等等等等。

如果这样做的话，那对用户太不公平了！如果我们只加载用户需要的那部分代码，是不是特别赞？

所以，这种把比较大的包拆分成多个更小的包的方法就是代码分割。这些更小的包可以按需或者异步加载。虽然听上去很难实现，但是像 webpack 这种现代打包工具 可以让代码分割变得简单一些，而 parcel 则把简单提升了几个级别。

![](https://cdn-images-1.medium.com/max/800/1*WKxqnQQJjn03TXiBM4TYfw.png)

文件拆分成了这些可爱的小 baby 们。来自 [Shreya](https://medium.com/@shreyawriteshere) [[Instagram](https://www.instagram.com/shreyadoodles/)]

#### Parcel 到底是什么呢？

[Parcel](https://parceljs.org/) 是一个

> 极速零配置 web 应用打包工具

它使得模块打包变得十分简单！如果你还不知道 parcel，推荐你先看一下 [Indrek Lasn](https://medium.com/@wesharehoodies) 写的 [这篇文章](https://medium.freecodecamp.org/all-you-need-to-know-about-parcel-dbe151b70082)。

#### 开始吧！

嗯...代码部分，我不会使用任何框架（你经常使用的那些），而且用不用框架处理起来是一样的。下面例子会用非常简单的代码展示如何拆分代码。

创建一个新的文件夹， `初始化` 一个项目，使用

```
npm init
```

或者，

```
yarn init
```

选择你喜欢的方式（yarn 是我的菜 😉），然后按照下图创建一些文件。

![](https://cdn-images-1.medium.com/max/800/1*oZy87TFDpGZYXf05uunBxA.png)

世界上最简单的结构有没有

这个例子中，我们只在 `index.html` 中引入 `index.js` 文件，然后通过一个事件（这里例子中我们使用点击按钮）加载 `someModule.js` 文件，并渲染里面的一些内容。

打开 `index.html` 添加如下代码。

```
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Code Splitting like Humans</title>
  </head>
  <body>
    <button id="bt">Click</button>
    <div class="holder"></div>
    <script src="./index.js"></script>
  </body>
</html>
```

没什么特殊的，只是一个 HTML 模板，包括一个 button 按钮 和渲染 `someModule.js` 内容的 `div` 。

接下来我们来写 `someModule`文件。

```
console.log("someModule.js loaded");
module.exports = {
  render : function(element){
      element.innerHTML = "You clicked a button";
  }
}
```

我们 export 了一个对象，它有一个 `render` 方法，接收一个元素并将「You clicked a button」渲染到这个元素内部。

现在有意思了。在我们的 `index.js` 中，我们要触发 button 按钮的点击事件，动态的加载  `someModule`。

对于动态的异步加载，我们使用 `import()` 语法，它会按需异步加载一个模块。

看一下如何使用，

```
import('./path/to/module').then(function(page){
//Do Something
});
```

因为 `import` 是异步的，所以我们用 `then` 来处理它返回的 promise 对象。在 `then` 方法中，我们传入一个函数，这个函数接收从该模块加载进来的对象。这和 `const page = require('./path/to/module');` 很相似， 只是动态异步执行而已。

在我们的例子中这么写，

```
import('./someModule').then(function (page) {
   page.render(document.querySelector(".holder"));
});
```

于是我们加载了 `someModule` 并调用了它的 render 方法。

接着把它加到按钮点击事件的监听函数中。

```
console.log("index.js loaded");
window.onload = function(){
       document.querySelector("#bt").addEventListener('click',function(evt){
     console.log("Button Clicked");
     import('./someModule').then(function (page) {
         page.render(document.querySelector(".holder"));
     });
});
}
```

至此代码已经写完了，让我们开始使用 parcel 吧。Parcel 会自动执行所有的配置工作！

```
parcel index.html
```

它会产生以下的文件。

![](https://cdn-images-1.medium.com/max/800/1*NEtHUZA1zchHSsWuOqB6mQ.png)

在你的浏览器中运行，观察页面。

![](https://cdn-images-1.medium.com/max/800/1*RIhun_YTgvmtvHgeqKWNkw.png)

控制台输出

![](https://cdn-images-1.medium.com/max/800/1*kS4YO7jH-6sA49LuWs-lsA.png)

Network 显示

可以从控制台输出看到，`someModule` 在按钮被点击之后才被加载。通过 network 可以看到调用 import 后，`codesplit-parcel.js` 是如何加载模块的。

代码分割是多么神奇的一件事，既然我们可以可以这么简单的实现，那我们有理由不用吗？💞💞


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
