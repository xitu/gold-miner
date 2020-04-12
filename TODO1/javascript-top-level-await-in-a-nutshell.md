> * 原文地址：[How the new ‘Top Level Await’ feature works in JavaScript](https://medium.com/javascript-in-plain-english/javascript-top-level-await-in-a-nutshell-4e352b3fc8c8)
> * 原文作者：[Kesk noren](https://medium.com/@kesk)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-top-level-await-in-a-nutshell.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-top-level-await-in-a-nutshell.md)
> * 译者：
> * 校对者：

# How the new ‘Top Level Await’ feature works in JavaScript

> Short, useful JavaScript lessons — make it easy.

![Photo by John Petalcurin](https://cdn-images-1.medium.com/max/11720/1*Pct48neOTBFhjsQHYYoTLw.jpeg)

Previously, in order to use await, code needed to be inside a function marked as async. This meant that you couldn’t use await outside any function notation. Top-level await enables modules to act like async functions.

Modules are asynchronous and have an import and export, and those also expressed at the top-level. The practical implication of this is that if you wanted to provide a module that relied on some asynchronous task in order to do something you had really no good choices.

Top-level await comes to solve this and enables developers to use the await keyword outside async functions. With top-level await, ECMAScript Modules can await resources, causing other modules who import them to wait before they start evaluating their body, or you can use it also as a loading dependency fallback if a module loading fails or to use to load the first resource downloaded.

Notes:

* Top-level await **only works at the top level of modules**. There is no support for classic scripts or non-async functions.
* ECMAScript stage 3 as of the time of this writing(23/02/2020).

## Use cases

With top-level await, the next code works the way you’d expect within modules

## 1. Using a fallback if module loading fails

The following example attempts to load a JavaScript module from first.com, falling back to if that fails:

```js
//module.mjs

let module;

try {
  module= await import('https://first.com/libs.com/module1');
} catch {
  module= await import('https://second.com/libs/module1');
}
```

## 2. Using whichever resource loads fastest

Here res variable is initialized via whichever download finishes first.

```js
//module.mjs

const resPromises = [    
    donwloadFromResource1Site,
    donwloadFromResource2Site
 ];

const res = await Promise.any(resPromises);
```

## 3. Resource initialization

The top-level await allows you to await promises in modules as if they were wrapped in an async function. This is useful, for example, to perform app initialization:

```js
//module.mjs

import { dbConnector} from './dbUtils.js'

//connect() return a promise.
const connection = await dbConnector.connect();

export default function(){connection.list()}
```

## 4. Loading modules dynamically

This allows for Modules to use runtime values in order to determine dependencies.

```js
//module.mjs

const params = new URLSearchParams(window.location.search);
const lang = params.get('lang');
const messages = await import(`./messages-${lang}.mjs`);
```

## 5. Using await outside async functions in DevTools?

Before with async/await, attempting to use an await outside an async function resulted in a: “ SyntaxError: await is only valid in async function” Now, you can use it without it being inside in an async function.

This has been tested in chrome 80 and in firefox 72.0.2 **DevTools**. However, this functionality is non-standard and doesn’t work in nodejs.

```js
const helloPromise = new Promise((resolve)=>{
  setTimeout(()=> resolve('Hello world!'), 5000);
})

const result =  await helloPromise;console.log(result);

//5 seconds later...:
//Hello world!
```

## Implementations

* V8 with flag: — — harmony-top-level-await
* Webpack (experimental support in 5.0.0)
* Parser support has been added to Babel ([babel/plugin-syntax-top-level-await](https://babeljs.io/docs/en/babel-plugin-syntax-top-level-await)).

## References

* [https://github.com/bmeck/top-level-await-talking/](https://github.com/bmeck/top-level-await-talking/)
* [https://github.com/tc39/proposal-top-level-await#use-cases](https://github.com/tc39/proposal-top-level-await#use-cases)

Thanks for reading me!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
