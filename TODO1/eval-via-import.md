> * 原文地址：[Evaluating JavaScript code via `import()`](https://2ality.com/2019/10/eval-via-import.html)
> * 原文作者：[Dr. Axel Rauschmayer](http://dr-axel.de/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/eval-via-import.md](https://github.com/xitu/gold-miner/blob/master/TODO1/eval-via-import.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[quzhen12](https://github.com/quzhen12)，[weisiwu](https://github.com/weisiwu)

# 使用 `import()` 执行 JavaScript 代码

使用 [`import()` 操作符](https://exploringjs.com/impatient-js/ch_modules.html#loading-modules-dynamically-via-import)，我们可以动态加载 ECMAScript 模块。但是 `import()` 的应用不仅于此，它还可以作为 `eval()` 的替代品，用来执行 JavaScript 代码（[这一点是最近 Andrea Giammarchi 向我指出的](https://twitter.com/WebReflection/status/1171697666335662086)）。这篇博客将会解释这是如何实现的。

## `eval()` 不支持 `export` 和 `import`

`eval()` 的一大缺陷是：它不支持例如 `export` 和 `import` 这样的模块语法。

但是如果放弃 `eval()` 而改为使用 `import()`，我们就可以执行带有模块的代码，在后文你将能看到这是如何实现的。

未来，我们也许可以使用 [**Realms**](https://github.com/tc39/proposal-realms)，它也许会是能够支持模块的、更强大的下一代 `eval()`。

## 使用 `import()` 执行简单的代码

下面，我们从使用 `import()` 来执行 `console.log()` 开始学习：

```js
const js = `console.log('Hello everyone!');`;
const encodedJs = encodeURIComponent(js);
const dataUri = 'data:text/javascript;charset=utf-8,'
  + encodedJs;
import(dataUri);

// 输出：
// 'Hello everyone!'
```

这段代码执行后发生了什么？

* 首先，我们创建了所谓的 [**数据 URI**](https://en.wikipedia.org/wiki/Data_URI_scheme)。这种类型的 URI 协议是 `data:`。URI 的剩余部分中包含了所有资源的编码，而不是指向资源本身的地址。这样，数据 URI 就包含了一个完整的 ECMAScript 模块 —— 它的 content 类型是 `text/javascript`。
* 然后我们动态引入模块，于是代码被执行。

注意：这段代码只能在浏览器中运行。在 Node.js 环境中，`import()` 不支持数据 URI。

### 获取被执行模块的导出

由 `import()` 返回的 Promise 的完成态是一个模块命名空间对象。这让我们可以获取到模块的默认导出以及命名导出。在下面的例子中，我们获取得是默认导出：

```js
const js = `export default 'Returned value'`;
const dataUri = 'data:text/javascript;charset=utf-8,'
  + encodeURIComponent(js);
import(dataUri)
  .then((namespaceObject) => {
    assert.equal(namespaceObject.default, 'Returned value');
  });
```

## 使用标记模版创建数据 URI

使用一个适当的方法 `esm`（后文我们会看到该方法是如何实现的），我们可以重写上文的例子，并通过一个[标记模版](https://exploringjs.com/impatient-js/ch_template-literals.html#tagged-templates)创建数据 URI：

```js
const dataUri = esm`export default 'Returned value'`;
import(dataUri)
  .then((namespaceObject) => {
    assert.equal(namespaceObject.default, 'Returned value');
  });
```

`esm` 的实现如下：

```js
function esm(templateStrings, ...substitutions) {
  let js = templateStrings.raw[0];
  for (let i=0; i<substitutions.length; i++) {
    js += substitutions[i] + templateStrings.raw[i+1];
  }
  return 'data:text/javascript;base64,' + btoa(js);
}
```

我们把编码方式从 `charset=utf-8` 切换为 `base64`，它们两者的对比如下：

* 源代码：`'a' < 'b'`
* 第一个数据 URI：`data:text/javascript;charset=utf-8,'a'%20%3C%20'b'`
* 第二个数据 URI：`data:text/javascript;base64,J2EnIDwgJ2In`

每种编码方式都各有利弊：

* `charset=utf-8`（又称百分号编码）的优势：
    * 大部分源码仍具有可读性。
* `base64` 的优势：
    * URI 更精短。
    * 更易嵌套（后文我们会看到），因为它不包含任何如撇号这样的特殊字符。

`btoa()` 是一个用来将字符串编码为 base 64 代码的全局工具函数。注意：

* 在 Node.js 环境下不可用。
* 仅对码点值在 0 至 255 范围内的 Unicode 字符有效。

## 执行引用了其他模块的模块

通过标记模版，我们可以嵌套数据 URI，并编码引用了 `m1` 模块的 `m2` 模块：

```js
const m1 = esm`export function f() { return 'Hello!' }`;
const m2 = esm`import {f} from '${m1}'; export default f()+f();`;
import(m2)
  .then(ns => assert.equal(ns.default, 'Hello!Hello!'));
```

## 扩展阅读

* [关于数据 URIs 的维基百科](https://en.wikipedia.org/wiki/Data_URI_scheme)
* [“JavaScript for impatient programmers” 中关于 `import()` 的章节](https://exploringjs.com/impatient-js/ch_modules.html#loading-modules-dynamically-via-import)
* [“JavaScript for impatient programmers” 中关于标签模版的章节](https://exploringjs.com/impatient-js/ch_template-literals.html#tagged-templates)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
