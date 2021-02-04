> * 原文地址：[How the new ‘Top Level await’ feature works in JavaScript](https://medium.com/javascript-in-plain-english/javascript-top-level-await-in-a-nutshell-4e352b3fc8c8)
> * 原文作者：[Kesk noren](https://medium.com/@kesk)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-top-level-await-in-a-nutshell.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-top-level-await-in-a-nutshell.md)
> * 译者：[ssshooter](https://ssshooter.com/tag/coding/)
> * 校对者：[xionglong58](https://github.com/xionglong58) [niayyy-S](https://github.com/niayyy-S)

# 如何在 JavaScript 中使用新特性“顶层 await”

> 简短有效的 JavaScript 课，让你看懂顶层 await。

![Photo by John Petalcurin](https://cdn-images-1.medium.com/max/11720/1*Pct48neOTBFhjsQHYYoTLw.jpeg)

以前要使用 await，相关代码必须位于 async 函数内部。换言之你不能在函数外使用 await。顶层 await 能使模块表现得像 async 函数一样。

模块是异步的，拥有 import 和 export，而这两者也是存在于顶层。这样做的实际意义是，如果你想提供一个依赖于其它异步任务的模块来做某些操作，那么你实际上没有更好的选择。

顶层 await 可以解决这个问题，能让开发人员可以在 async 函数外使用 await 关键字。凭借顶层 await，ECMAScript 模块可以等待资源的获取，导致其它 import 它们的模块也等待资源加载完后才开始执行。如果模块加载失败或者用于加载第一个下载的资源，也可以将其用作加载依赖的回退。

注意：

* 顶层 await **只能用在模块的顶层**，不支持传统的 script 标签或非 async 函数。
* 此文撰写时（23/02/2020），此特性处于 ECMAScript stage 3。

## 使用示例

使用顶层 await，在模块中以下代码将正常工作

## 1. 模块加载失败时使用回退

以下例子尝试加载一个来自 first.com 的 JavaScript 模块，加载失败会有回退方案：

```js
//module.mjs

let module;

try {
  module= await import('https://first.com/libs.com/module1');
} catch {
  module= await import('https://second.com/libs/module1');
}
```

## 2. 使用加载最快的资源

这里 res 变量的初始值由最先结束的下载请求决定。

```js
//module.mjs

const resPromises = [    
    donwloadFromResource1Site,
    donwloadFromResource2Site
 ];

const res = await Promise.any(resPromises);
```

## 3. 资源初始化

顶层 await 允许你在模块中 await promise，如同它们被包裹在一个 async 函数中。这非常有用，比如说，初始化应用程序：

```js
//module.mjs

import { dbConnector} from './dbUtils.js'

//connect() return a promise.
const connection = await dbConnector.connect();

export default function(){connection.list()}
```

## 4. 动态加载模块

允许模块动态决定依赖库。

```js
//module.mjs

const params = new URLSearchParams(window.location.search);
const lang = params.get('lang');
const messages = await import(`./messages-${lang}.mjs`);
```

## 5. DevTools 中也能在函数 async 外部使用 await？

以前在 async 函数外使用 await 会报语法错误 `SyntaxError: await is only valid in async function`，而现在可以正常使用了。

chrome 80 和 firefox 72.0.2 的 **DevTools** 测试可行。但此功能暂时还是非标准功能，不能再 nodejs 中使用。

```js
const helloPromise = new Promise((resolve)=>{
  setTimeout(()=> resolve('Hello world!'), 5000);
})

const result =  await helloPromise;console.log(result);

//5 seconds later...:
//Hello world!
```

## 实现情况

* V8 启用 flag：— — harmony-top-level-await
* WebPack（5.0.0 实验性支持）
* Babel 已支持 ([babel/plugin-syntax-top-level-await](https://babeljs.io/docs/en/babel-plugin-syntax-top-level-await))

## 参考资料

* [https://github.com/bmeck/top-level-await-talking/](https://github.com/bmeck/top-level-await-talking/)
* [https://github.com/tc39/proposal-top-level-await#use-cases](https://github.com/tc39/proposal-top-level-await#use-cases)

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
