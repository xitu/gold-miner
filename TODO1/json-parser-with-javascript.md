> * 原文地址：[JSON Parser with JavaScript](https://lihautan.com/json-parser-with-javascript/)
> * 原文作者：[Tan Li Hau](https://lihautan.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/json-parser-with-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/json-parser-with-javascript.md)
> * 译者：[Gavin-Gong](https://github.com/Gavin-Gong)
> * 校对者：[vitoxli](https://github.com/vitoxli)，[Chorer](https://github.com/Chorer)

# 使用 JavaScript 编写 JSON 解析器

这周的 Cassidoo 的每周简讯有这么一个面试题：
> 写一个函数，这个函数接收一个正确的 JSON 字符串并将其转化为一个对象（或字典，映射等，这取决于你选择的语言）。示例输入：

```text
fakeParseJSON('{ "data": { "fish": "cake", "array": [1,2,3], "children": [ { "something": "else" }, { "candy": "cane" }, { "sponge": "bob" } ] } } ')
```

一度我忍不住想这样写：

```js
const fakeParseJSON = JSON.parse;
```

但是，我记起我写过一些关于 AST 的文章：

* [使用 Babel 创建自定义 JavaScript 语法](/creating-custom-javascript-syntax-with-babel)
* [一步一步教你写一个自定义 babel 转化器](/step-by-step-guide-for-writing-a-babel-transformation)
* [使用 JavaScript 操作 AST](/manipulating-ast-with-javascript)

其中包括编译器管道的概述，以及如何操作 AST，但是我还没有详细介绍如何实现解析器。

这是因为在一篇文章中实现 JavaScript 编译器对我来说是一项艰巨的任务。

好了，不用担心。JSON 也是一种语言。它有自己的语法，你可以查阅它的 [规范](https://www.json.org/json-en.html)。编写 JSON 解析器所需的知识和技术可以助你编写 JS 解析器。

那么，让我们开始编写一个 JSON 解析器吧！

## 理解语法

如果你有查看 [规范页面](https://www.json.org/json-en.html)，你会发现两个图：

* 左边的 [语法图 (或者铁路图)](https://en.wikipedia.org/wiki/Syntax_diagram)，

![https://www.json.org/img/object.png](https://www.json.org/img/object.png) Image source: [https://www.json.org/img/object.png](https://www.json.org/img/object.png)

* 右边的 [The McKeeman Form](https://www.crockford.com/mckeeman.html)，[巴科斯-诺尔范式(BNF)](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form) 的一种变体

```text
json
  element

value
  object
  array
  string
  number
  "true"
  "false"
  "null"

object
  '{' ws '}'
  '{' members '}'
```

两个图是等价的。

一个基于视觉，一个基于文本。基于文本语法的语法 —— 巴科斯-诺尔范式，通常被提供给另一个解析这种语法并为其生成解析器的解析器，终于说到解析器了！🤯

在本文中，我们将重点关注铁路图，因为它是可视化的，而且似乎对我更友好。

让我们看看第一张铁路图：

![https://www.json.org/img/object.png](https://www.json.org/img/object.png) Image source: [https://www.json.org/img/object.png](https://www.json.org/img/object.png)

我们可以看出这是 **『object』** 在 JSON 中的语法。

我们从左边开始，沿着箭头走，一直走到右边为止。

圈圈里面是字符，例如 `{`、`,`、`:`、`}`，矩形里面是其它语法的占位符，例如 `whitespace`、`string` 和 `value`。因此要解析『whitespace』，我们需要查阅 **『whitepsace』** 语法。

因此，对于一个对象而言，从左边开始，第一个字符必须是一个左花括号 `{`。然后我们有两种情况：

* `whitespace` → `}` → 结束，或者
* `whitespace` → `string` → `whitespace` → `:` → `value` → `}` → 结束

当然当你抵达『value』的时候，你可以选择继续下去：

* → `}` → 结束，或者
* → `,` → `whitespace` → … → `value`

你可以继续循环，直到你决定去：

* → `}` → 结束。

那么，我想我们现在已经熟悉了铁路图，让我们继续到下一节。

## 实现解析器

让我们从以下结构开始：

```js
function fakeParseJSON(str) {
  let i = 0;
  // TODO
}
```

我们初始化 `i` 将其作为当前字符的索引值，只要 `i` 值到达 `str` 的长度，我们就会结束函数。

让我们实现 **『object』** 语法：

```js
function fakeParseJSON(str) {
  let i = 0;
  function parseObject() {
    if (str[i] === '{') {
      i++;
      skipWhitespace();

      // 如果不是 '}',
      // 我们接收 string -> whitespace -> ':' -> value -> ... 这样的路径字符串
      while (str[i] !== '}') {
        const key = parseString();
        skipWhitespace();
        eatColon();
        const value = parseValue();
      }
    }
  }
}
```

我们可以调用 `parseObject` 来解析类似『string』和『whitespace』之类的语法，只要我们实现这些功能，一切都会工作🤞。

我忘了加上一个逗号 `,`。`,`只出现在我们开始第二次 `whitespace` → `string` → `whitespace` → `:` → … 循环之前。

在此基础上，我们增加了以下几行：

```js
function fakeParseJSON(str) {
  let i = 0;
  function parseObject() {
    if (str[i] === '{') {
      i++;
      skipWhitespace();

      let initial = true;
      // 如果不是 '}',
      // 我们接收 string -> whitespace -> ':' -> value -> ... 这样的路径字符串
      while (str[i] !== '}') {
        if (!initial) {
          eatComma();
          skipWhitespace();
        }
        const key = parseString();
        skipWhitespace();
        eatColon();
        const value = parseValue();
        initial = false;      }
      // 移动到下一个 '}' 字符
      i++;
    }
  }
}
```

一些命名约定：

* 当我们根据语法解析代码并使用返回值时，命名为 `parseSomething`
* 当我们期望字符在那里，但是我们没有使用字符时，命名为 `eatSomething`
* 当字符不存在，我们也可以接受。命名为 `skipSomething`

让我们实现 `eatComma` 和 `eatColon`：

```js
function fakeParseJSON(str) {
  // ...
  function eatComma() {
    if (str[i] !== ',') {
      throw new Error('Expected ",".');
    }
    i++;
  }

  function eatColon() {
    if (str[i] !== ':') {
      throw new Error('Expected ":".');
    }
    i++;
  }
}
```

目前为止我们成功实现一个 `parseObject` 语法，但是这个解析函数返回什么值呢？

不错，我们需要返回一个 JavaScript 对象：

```js
function fakeParseJSON(str) {
  let i = 0;
  function parseObject() {
    if (str[i] === '{') {
      i++;
      skipWhitespace();

      const result = {};
      let initial = true;
      // 如果不是 '}',
      // 我们接收 string -> whitespace -> ':' -> value -> ... 这样的路径字符串
      while (str[i] !== '}') {
        if (!initial) {
          eatComma();
          skipWhitespace();
        }
        const key = parseString();
        skipWhitespace();
        eatColon();
        const value = parseValue();
        result[key] = value;        initial = false;
      }
      // 移动到下一个 '}' 字符
      i++;

      return result;    }
  }
}
```

既然你已经看到我实现了『object』语法，现在是时候让你尝试一下『array』语法了：

![https://www.json.org/img/array.png](https://www.json.org/img/array.png) Image source: [https://www.json.org/img/array.png](https://www.json.org/img/array.png)

```js
function fakeParseJSON(str) {
  // ...
  function parseArray() {
    if (str[i] === '[') {
      i++;
      skipWhitespace();

      const result = [];
      let initial = true;
      while (str[i] !== ']') {
        if (!initial) {
          eatComma();
        }
        const value = parseValue();
        result.push(value);
        initial = false;
      }
      // 移动到下一个 '}' 字符
      i++;
      return result;
    }
  }
}
```

现在，我们来看一个更有趣的语法，『value』：

![https://www.json.org/img/value.png](https://www.json.org/img/value.png) Image source: [https://www.json.org/img/value.png](https://www.json.org/img/value.png)

一个值以 『whitespace』 开始，然后是以下任何一种：『string』、『number』、『object』、『array』、『true』、『false』或者『null』，然后以一个『whitespace』结束：

```js
function fakeParseJSON(str) {
  // ...
  function parseValue() {
    skipWhitespace();
    const value =
      parseString() ??
      parseNumber() ??
      parseObject() ??
      parseArray() ??
      parseKeyword('true', true) ??
      parseKeyword('false', false) ??
      parseKeyword('null', null);
    skipWhitespace();
    return value;
  }
}
```

`??` 称之为 [空值合并运算符](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing_operator)，它类似我们用来设置默认值 `foo || default` 中的 `||`，只要`foo`是假值，`||` 就会返回 `default`，
而空值合并运算符只会在 `foo` 为 `null` 或 `undefined` 时返回 `default`。

`parseKeyword` 将检查当前 `str.slice(i)` 是否与关键字字符串匹配，如果匹配，将返回关键字值：

```js
function fakeParseJSON(str) {
  // ...
  function parseKeyword(name, value) {
    if (str.slice(i, i + name.length) === name) {
      i += name.length;
      return value;
    }
  }
}
```

这就是 `parseValue`！

我们还有 3 个以上的语法要实现，但我为了控制文章篇幅，在下面的 [CodeSandbox](https://codesandbox.io/s/json-parser-k4c3w?from-embed) 中实现这些语法。

在我们完成所有的语法实现之后，现在让我们返回 `parseValue` 返回的 json 值：

```js
function fakeParseJSON(str) {
  let i = 0;
  return parseValue();

  // ...
}
```

就是这样！

好吧，别急，我的朋友，我们刚刚完成了理想情况，那非理想情况呢？

## 处理意外输入

作为一个优秀的开发人员，我们也需要优雅地处理非理想情况。对于解析器，这意味着使用适当的错误消息大声警告开发人员。

让我们来处理两个最常见的错误情况：

* Unexpected token
* Unexpected end of string

### Unexpected token

### Unexpected end of string

在所有的 while 循环中，例如 `parseObject` 中的 while 循环：

```js
function fakeParseJSON(str) {
  // ...
  function parseObject() {
    // ...
    while(str[i] !== '}') {
```

我们需要确保访问的字符不会超过字符串的长度。这发生在字符串意外结束时，而我们仍然在等待一个结束字符 —— `}`。比如说下面的例子：

```js
function fakeParseJSON(str) {
  // ...
  function parseObject() {
    // ...
    while (i < str.length && str[i] !== '}') {      // ...
    }
    checkUnexpectedEndOfInput();
    // 移动到下一个 '}' 字符
    i++;

    return result;
  }
}
```

## 加倍努力

你还记得当你还是一个初级开发者时，每次遇到含糊不清的语法报错时，你都完全不知道哪里出错了吗？
现在你更有经验了，是时候停止这种恶性循环，停止吐槽了。

```js
Unexpected token "a"
```

然后让用户盯着屏幕发呆。

有很多比吐槽更好的处理错误消息的方法，下面是一些你可以考虑添加到你的解析器的要点：

### 错误代码和标准错误消息

标准关键字对用户谷歌寻求帮助很有用。

```js
// 不要这样显示
Unexpected token "a"
Unexpected end of input

// 而要这样显示
JSON_ERROR_001 Unexpected token "a"
JSON_ERROR_002 Unexpected end of input
```

### 更好地查看哪里出了问题

像 Babel 这样的解析器，会向你显示一个代码框架，它是一个带有下划线、箭头或突出显示错误的代码片段

```js
// 不要这样显示
Unexpected token "a" at position 5

// 而要这样显示
{ "b"a
      ^
JSON_ERROR_001 Unexpected token "a"
```

一个如何输出代码片段的例子：

```js
function fakeParseJSON(str) {
  // ...
  function printCodeSnippet() {
    const from = Math.max(0, i - 10);
    const trimmed = from > 0;
    const padding = (trimmed ? 3 : 0) + (i - from);
    const snippet = [
      (trimmed ? '...' : '') + str.slice(from, i + 1),
      ' '.repeat(padding) + '^',
      ' '.repeat(padding) + message,
    ].join('\n');
    console.log(snippet);
  }
}
```

### 错误恢复建议

如果可能的话，解释出了什么问题，并给出解决问题的建议

```js
// 不要这样显示
Unexpected token "a" at position 5

// 而要这样显示
{ "b"a
      ^
JSON_ERROR_001 Unexpected token "a".
Expecting a ":" over here, eg:
{ "b": "bar" }
      ^
You can learn more about valid JSON string in http://goo.gl/xxxxx
```

如果可能，根据解析器目前收集的上下文提供建议

```js
fakeParseJSON('"Lorem ipsum');

// 这样显示
Expecting a `"` over here, eg:
"Foo Bar"
        ^

// 这样显示
Expecting a `"` over here, eg:
"Lorem ipsum"
            ^
```

基于上下文的建议会让人感觉更有关联性和可操作性。
记住所有的建议，用以下几点检查已经更新的 [CodeSandbox](https://codesandbox.io/s/json-parser-with-error-handling-hjwxk?from-embed)

* 有意义的错误消息
* 带有错误指向失败点的代码段
* 为错误恢复提供建议

## 总结

要实现解析器，你需要从语法开始。
你可以用铁路图或巴科斯-诺尔范式来使语法正式化。设计语法是最困难的一步。
一旦你解决了语法问题，就可以开始基于语法实现解析器。
错误处理很重要，更重要的是要有有意义的错误消息，以便用户知道如何修复它。
现在，你已经了解了如何实现简单的解析器，现在应该关注更复杂的解析器了：

* [Babel parser](https://github.com/babel/babel/tree/master/packages/babel-parser)
* [Svelte parser](https://github.com/sveltejs/svelte/tree/master/src/compiler/parse)

最后，请关注 [@cassidoo](https://twitter.com/cassidoo)，她的每周简讯棒极了！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
