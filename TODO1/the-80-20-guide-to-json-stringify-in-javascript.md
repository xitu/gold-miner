> * 原文地址：[The 80/20 Guide to JSON.stringify in JavaScript](http://thecodebarbarian.com/the-80-20-guide-to-json-stringify-in-javascript.html)
> * 原文作者：[Valeri Karpov](http://www.twitter.com/code_barbarian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-80-20-guide-to-json-stringify-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-80-20-guide-to-json-stringify-in-javascript.md)
> * 译者：
> * 校对者：

# The 80/20 Guide to JSON.stringify in JavaScript

The [`JSON.stringify()` function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify) is the canonical way to convert a JavaScript object to [JSON](https://www.json.org/). Many JavaScript frameworks use `JSON.stringify()` under the hood: [Express' `res.json()`](http://expressjs.com/en/4x/api.html#res.json), [Axios' `post()`](https://github.com/axios/axios#example), and [Webpack stats](https://webpack.js.org/configuration/stats/) all call `JSON.stringify()`. In this article, I'll provide a practical overview of `JSON.stringify()`, including error cases.

## Getting Started

All modern JavaScript runtimes support `JSON.stringify()`. Even Internet Explorer has [`JSON.stringify()` support since IE8](https://blogs.msdn.microsoft.com/ie/2008/09/10/native-json-in-ie8/). Here's an example of converting a simple object to JSON:

```javascript
const obj = { answer: 42 };

const str = JSON.stringify(obj);
str; // '{"answer":42}'
typeof str; // 'string'
```

You may see `JSON.stringify()` used with [`JSON.parse()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/parse) as shown below. This pattern is one way of [deep cloning a JavaScript object](https://flaviocopes.com/how-to-clone-javascript-object/#json-serialization).

```javascript
const obj = { answer: 42 };
const clone = JSON.parse(JSON.stringify(obj));

clone.answer; // 42
clone === obj; // false
```

## Errors and Edge Cases

[`JSON.stringify()` throws an error when it detects a cyclical object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify#Exceptions). In other words, if an object `obj` has a property whose value is `obj`, `JSON.stringify()` will throw an error.

```javascript
const obj = {};
// Cyclical object that references itself
obj.prop = obj;

// Throws "TypeError: TypeError: Converting circular structure to JSON"
JSON.stringify(obj);
```

That is the only case where `JSON.stringify()` throws an exception, unless you're using custom `toJSON()` functions or replacer functions. However, you should still wrap `JSON.stringify()` calls in `try/catch`, because circular objects do pop up in practice.

There are several edge cases where `JSON.stringify()` doesn't throw an error, but you might expect it does. For example, `JSON.stringify()` converts `NaN` and `Infinity` to `null`:

```javascript
const obj = { nan: parseInt('not a number'), inf: Number.POSITIVE_INFINITY };

JSON.stringify(obj); // '{"nan":null,"inf":null}'
```

`JSON.stringify()` also strips out properties whose values are functions or `undefined`:

```javascript
const obj = { fn: function() {}, undef: undefined };

// Empty object. `JSON.stringify()` removes functions and `undefined`.
JSON.stringify(obj); // '{}'
```

## Pretty Printing


The first parameter to `JSON.stringify()` is the object to serialize to JSON. `JSON.stringify()` actually takes 3 parameters, and the 3rd parameter is called `spaces`. The `spaces` parameter is used for formatting JSON output in a human readable way.

You can set the `spaces` parameter to either be a string or a number. If `spaces` is not undefined, `JSON.stringify()` will put each key in the JSON output on its own line, and prefix each key with `spaces`. 

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

// Use 2 spaces when formatting JSON output. Equivalent to the above.
JSON.stringify(obj, null, 2);
```

The `spaces` string doesn't have to be all whitespace, although in practice it usually will be. For example:

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


The 2nd parameter to `JSON.stringify()` is the `replacer` function. In the above examples, `replacer` was `null`. JavaScript calls the replacer function with every key/value pair in the object, and uses the value the replacer function returns. For example:

```javascript
const obj = { a: 1, b: 2, c: 3, d: { e: 4 } };

// `replacer` increments every number value by 1. The output will be:
// '{"a":2,"b":3,"c":4,"d":{"e":5}}'
JSON.stringify(obj, function replacer(key, value) {
  if (typeof value === 'number') {
    return value + 1;
  }
  return value;
});
```

The replacer function is useful for omitting sensitive data. For example, suppose you wanted to omit all [keys that contain the substring 'password'](https://masteringjs.io/tutorials/fundamentals/contains-substring#case-insensitive-search):

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
  // This function gets called 5 times. `key` will be equal to:
  // '', 'name', 'password', 'nested', 'hashedPassword'
  if (key.match(/password/i)) {
    return undefined;
  }
  return value;
});
```

## The `toJSON()` Function

The `JSON.stringify()` function also traverses the object looking for properties that have a `toJSON()` function. If it finds a `toJSON()` function, `JSON.stringify()` calls the `toJSON()` function and uses the return value as a replacement. For example:

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

The `toJSON()` function can return any value, including objects, primitives, or `undefined`. If `toJSON()` returns `undefined`, `JSON.stringify()` will ignore that property.

Many JavaScript modules use `toJSON()` to ensure sophisticated objects get serialized correctly, like [Mongoose documents](https://mongoosejs.com/docs/api.html#document_Document-toJSON) and [Moment objects](https://momentjs.com/docs/#/displaying/as-json/).

## Moving On

The `JSON.stringify()` function is a core JavaScript fundamental. Many libraries and frameworks use it under the hood, so a solid understanding of `JSON.stringify()` lets you do more with your favorite npm modules. For example, you can define alternate [date formatting](https://masteringjs.io/tutorials/fundamentals/date_format) for your Express REST API using a custom `toJSON()` function on the native `Date` class, or ensure that a circular client-side object gets converted to JSON correctly when sending an HTTP request with Axios.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
