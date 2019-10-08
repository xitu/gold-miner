> * 原文地址：[Evaluating JavaScript code via `import()`](https://2ality.com/2019/10/eval-via-import.html)
> * 原文作者：[Dr. Axel Rauschmayer](http://dr-axel.de/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/eval-via-import.md](https://github.com/xitu/gold-miner/blob/master/TODO1/eval-via-import.md)
> * 译者：
> * 校对者：

# Evaluating JavaScript code via `import()`

[The `import()` operator](https://exploringjs.com/impatient-js/ch_modules.html#loading-modules-dynamically-via-import) lets us dynamically load ECMAScript modules. But they can also be used to evaluate JavaScript code ([as Andrea Giammarchi recently pointed out to me](https://twitter.com/WebReflection/status/1171697666335662086)), as an alternative to `eval()`. This blog post explains how that works.

## `eval()` does not support `export` and `import`

A significant limitation of `eval()` is that it doesn’t support module syntax such as `export` and `import`.

If we use `import()` instead of `eval()`, we can actually evaluate module code, as we will see later in this blog post.

In the future, we may get [**Realms**](https://github.com/tc39/proposal-realms) which are, roughly, a more powerful `eval()` with support for modules.

## Evaluating simple code via `import()`

Let’s start by evaluating a `console.log()` via `import()`:

```js
const js = `console.log('Hello everyone!');`;
const encodedJs = encodeURIComponent(js);
const dataUri = 'data:text/javascript;charset=utf-8,'
  + encodedJs;
import(dataUri);

// Output:
// 'Hello everyone!'
```

What is going on here?

* First we create a so-called [**data URI**](https://en.wikipedia.org/wiki/Data_URI_scheme). The protocol of this kind of URI is `data:`. The remainder of the URI encodes the full resource instead pointing to it. In this case, the data URI contains a complete ECMAScript module – whose content type is `text/javascript`.
* Then we dynamically import this module and therefore execute it.

Warning: This code only works in web browsers. On Node.js, `import()` does not support data URIs.

### Accessing an export of an evaluated module

The fulfillment value of the Promise returned by `import()` is a module namespace object. That gives us access to the default export and the named exports of the module. In the following example, we access the default export:

```js
const js = `export default 'Returned value'`;
const dataUri = 'data:text/javascript;charset=utf-8,'
  + encodeURIComponent(js);
import(dataUri)
  .then((namespaceObject) => {
    assert.equal(namespaceObject.default, 'Returned value');
  });
```

## Creating data URIs via tagged templates

With an appropriate function `esm` (whose implementation we’ll see later), we can rewrite the previous example and create the data URI via a [tagged template](https://exploringjs.com/impatient-js/ch_template-literals.html#tagged-templates):

```js
const dataUri = esm`export default 'Returned value'`;
import(dataUri)
  .then((namespaceObject) => {
    assert.equal(namespaceObject.default, 'Returned value');
  });
```

The implementation of `esm` looks as follows:

```js
function esm(templateStrings, ...substitutions) {
  let js = templateStrings.raw[0];
  for (let i=0; i<substitutions.length; i++) {
    js += substitutions[i] + templateStrings.raw[i+1];
  }
  return 'data:text/javascript;base64,' + btoa(js);
}
```

For the encoding, we have switched from `charset=utf-8` to `base64`. Compare:

* Source code: `'a' < 'b'`
* Data URI 1: `data:text/javascript;charset=utf-8,'a'%20%3C%20'b'`
* Data URI 2: `data:text/javascript;base64,J2EnIDwgJ2In`

Each of the two ways of encoding has different pros and cons:

* Benefits of `charset=utf-8` (percent-encoding):
    * Much of the source code is still readable.
* Benefits of `base64`:
    * The URIs are usually shorter.
    * Easier to nest (as we’ll see later), because it doesn’t contain special characters such as apostrophes.

`btoa()` is a global utility function that encodes a string via base 64. Caveats:

* It is not available on Node.js.
* It should only be used for characters whose Unicode code points range from 0 to 255.

## Evaluating a module that imports another module

With tagged templates, we can nest data URIs and encode a module `m2` that imports another module `m1`:

```js
const m1 = esm`export function f() { return 'Hello!' }`;
const m2 = esm`import {f} from '${m1}'; export default f()+f();`;
import(m2)
  .then(ns => assert.equal(ns.default, 'Hello!Hello!'));
```

## Further reading

* [Wikipedia on Data URIs](https://en.wikipedia.org/wiki/Data_URI_scheme)
* [Section on `import()` in “JavaScript for impatient programmers”](https://exploringjs.com/impatient-js/ch_modules.html#loading-modules-dynamically-via-import)
* [Section on tagged templates in “JavaScript for impatient programmers”](https://exploringjs.com/impatient-js/ch_template-literals.html#tagged-templates)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
