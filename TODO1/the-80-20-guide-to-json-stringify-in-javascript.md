> * 原文地址：[The 80/20 Guide to JSON.stringify in JavaScript](http://thecodebarbarian.com/the-80-20-guide-to-json-stringify-in-javascript.html)
> * 原文作者：[Valeri Karpov](http://www.twitter.com/code_barbarian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-80-20-guide-to-json-stringify-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-80-20-guide-to-json-stringify-in-javascript.md)
> * 译者：[JerryFD](https://github.com/Jerry-FD)
> * 校对者：[Usey95](https://github.com/Usey95)，[mnikn](https://github.com/mnikn)

# JavaScript 中 JSON.stringify 的二八法则

[函数 `JSON.stringify()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify) 是一个把 JavaScript object 转换成 [JSON](https://www.json.org/) 的标准方法。很多 JavaScript 框架在底层都使用了 `JSON.stringify()`，例如：[Express' `res.json()`](http://expressjs.com/en/4x/api.html#res.json)、[Axios' `post()`](https://github.com/axios/axios#example) 和 [Webpack stats](https://webpack.js.org/configuration/stats/) 都在底层调用了 `JSON.stringify()`。这篇文章会提供一个实用的、包含异常情况的 `JSON.stringify()` 的概述。

## 开始

几乎所有现代的 JavaScript 运行环境都支持 `JSON.stringify()`。甚至 IE 浏览器自从 [IE8 起就支持JSON.stringify()](https://blogs.msdn.microsoft.com/ie/2008/09/10/native-json-in-ie8/)。下面是一个把普通的 object 转换成 JSON 的例子：

```javascript
const obj = { answer: 42 };

const str = JSON.stringify(obj);
str; // '{"answer":42}'
typeof str; // 'string'
```

如你所见，下面的例子是 `JSON.stringify()` 和 [`JSON.parse()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/parse) 一起使用的。这种写法可以用来[深拷贝 JavaScript 对象](https://flaviocopes.com/how-to-clone-javascript-object/#json-serialization)。

```javascript
const obj = { answer: 42 };
const clone = JSON.parse(JSON.stringify(obj));

clone.answer; // 42
clone === obj; // false
```

## 错误和边界处理

[如果 `JSON.stringify()` 的参数是 cyclical object，则会抛出一个错误](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify#Exceptions)。也就是说，如果对象 `obj` 有一个属性，这个属性的值是 `obj` 本身，那么 `JSON.stringify()` 会抛出一个错误。

```javascript
const obj = {};
// 循环 object 指向它自身
obj.prop = obj;

// 抛出 "TypeError: TypeError: Converting circular structure to JSON"
JSON.stringify(obj);
```

这是 `JSON.stringify()` 唯一抛出异常的场景，除非你使用自定义的 `toJSON()` 函数或者使用替代函数（replacer）。然而即便这样，你也还是得把 `JSON.stringify()` 包在 `try/catch` 里调用，因为循环 objects 还是可能会出现。

还有很多边界场景 `JSON.stringify()` 不会抛出异常，但其结果可能不如你所想。比如，`JSON.stringify()` 会把 `NaN` 和 `Infinity` 转换成 `null`：

```javascript
const obj = { nan: parseInt('not a number'), inf: Number.POSITIVE_INFINITY };

JSON.stringify(obj); // '{"nan":null,"inf":null}'
```

`JSON.stringify()` 也会把属性值为函数或者 `undefined` 的内容干掉：

```javascript
const obj = { fn: function() {}, undef: undefined };

// 空 object `JSON.stringify()` 过滤 functions 和 `undefined`。
JSON.stringify(obj); // '{}'
```

## 优化输出

`JSON.stringify()` 的第一个参数是要被序列化成 JSON 的 object。实际上 `JSON.stringify()` 接受 3 个参数，第三个参数 `spaces`（译注：空隙）。参数 `spaces` 用来将 JSON 格式化输出成方便阅读的格式。

参数 `spaces` 可以是 string 或 number。如果 `spaces` 不是 undefined，那么`JSON.stringify()` 则会把 JSON 中的每一个 key 单独作为一行输出，并且加上 `spaces` 的前缀。

```javascript
const obj = { a: 1, b: 2, c: 3, d: { e: 4 } };

// '{"a":1,"b":2,"c":3,"d":{"e":4}}'
JSON.stringify(obj);

// {
//   "a": 1,
//   "b": 2,
//   "c": 3,
//   "d": {
//     "e": 4
//   }
// }
JSON.stringify(obj, null, '  ');

// 使用 2 个空格来格式化 JSON 输出。和上面的例子等价。
JSON.stringify(obj, null, 2);
```

把参数 `spaces` 作为字符串使用时，虽然在实际场景中大多是使用空格，但其实不限制必须全是空格。例如：

```javascript
// {
// __"a": 1,
// __"b": 2,
// __"c": 3,
// __"d": {
// ____"e": 4
// __}
// }
JSON.stringify(obj, null, '__');
```

## Replacers

`JSON.stringify()` 的第二个参数是 `replacer` 函数。在上面的例子中，`replacer` 是 `null`。JavaScript 针对 object 中的每一个 key/value 对都会调用 replacer 函数，使用函数的返回值作为属性的值。例如：

```javascript
const obj = { a: 1, b: 2, c: 3, d: { e: 4 } };

// `replacer` 使每个数字的值加 1。输出：
// '{"a":2,"b":3,"c":4,"d":{"e":5}}'
JSON.stringify(obj, function replacer(key, value) {
  if (typeof value === 'number') {
    return value + 1;
  }
  return value;
});
```

替代函数（译注：replacer）在过滤敏感词的场景非常有用。例如，假设你想过滤所有[包含 'password' 及 'password' 子字符串的 keys](https://masteringjs.io/tutorials/fundamentals/contains-substring#case-insensitive-search)：

```javascript
const obj = {
  name: 'Jean-Luc Picard',
  password: 'stargazer',
  nested: {
    hashedPassword: 'c3RhcmdhemVy'
  }
};

// '{"name":"Jean-Luc Picard","nested":{}}'
JSON.stringify(obj, function replacer(key, value) {
  // 这个函数会被调用 5 次。 `key` 等于：
  // '', 'name', 'password', 'nested', 'hashedPassword'
  if (key.match(/password/i)) {
    return undefined;
  }
  return value;
});
```

## 函数 `toJSON()`

`JSON.stringify()` 函数会遍历 object 寻找含有 `toJSON()` 函数的属性。如果它找到了 `toJSON()` 函数，`JSON.stringify()` 会调用 `toJSON()` 函数，并使用其返回值作为替代。例如：

```javascript
const obj = {
  name: 'Jean-Luc Picard',
  nested: {
    test: 'not in output',
    toJSON: () => 'test'
  }
};

// '{"name":"Jean-Luc Picard","nested":"test"}'
JSON.stringify(obj);
```

函数 `toJSON()` 可以返回任何值，包括对象、原始类型的值，甚至 `undefined`。如果 `toJSON()` 返回 `undefined`，`JSON.stringify()` 会忽略这个属性。

许多 JavaScript 模块使用 `toJSON()` 这一特性来保证复杂的对象能被正确的序列化。比如 [Mongoose documents](https://mongoosejs.com/docs/api.html#document_Document-toJSON) 和 [Moment objects](https://momentjs.com/docs/#/displaying/as-json/)。

## 后续

 函数 `JSON.stringify()` 是 JavaScript 基础的核心。许多库和框架在底层都使用了它，所以对 `JSON.stringify()` 的扎实理解，可以帮助更好的学习你感兴趣的 npm 模块。比如，针对你的 Express REST API，可以借用自定义 `toJSON()` 函数的能力来处理原生的 `Date` 类，以此实现一个[日期格式化](https://masteringjs.io/tutorials/fundamentals/date_format) 的替代方案，或者，当使用 Axios 发送 HTTP 请求时，确保客户端的循环对象能被正确的转换成 JSON。（译注：帕累托法则即 80/20 Rule，一般指 20% 的输入，决定 80% 的结果的现象。）

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
