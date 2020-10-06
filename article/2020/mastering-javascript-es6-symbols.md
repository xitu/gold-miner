> * 原文地址：[Mastering JavaScript ES6 Symbols](https://blog.bitsrc.io/mastering-javascript-es6-symbols-6453da3bd46c)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/mastering-javascript-es6-symbols.md](https://github.com/xitu/gold-miner/blob/master/article/2020/mastering-javascript-es6-symbols.md)
> * 译者：[Inchill](https://github.com/Inchill)
> * 校对者：[plusmultiply0](https://github.com/plusmultiply0)

# 掌握 JavaScript ES6 中的 Symbol 类型

![](https://cdn-images-1.medium.com/max/2560/1*E5bxT-J688MnfPJ92Zr25A.png)

JavaScript 是 Web 开发的核心之一。JavaScript，也被称为 ECMAScript，于 1997 年标准化。至此以后，该语言中出现了下述原始值。

* Undefined
* Null
* Big Int(ES2020 中新增)
* Boolean
* Number
* String

`null` 被标记为 JavaScript 中的原始值之一，因为它的作用显然是原始的。但是在某些情况下，`null` 并不像它最初看起来那样“原始”。每个 Object 都是从 `null` 值派生的，因此 `typeof` 运算符将为其返回一个对象。

但是随着 2015 年 ES6 的发布，一个新的原始类型 —— **Symbol**，被添加了进去。它们与以前的原始值相比有很大的不同。它们只是值，不是字符串，也不是数字或者对象。它们只是 **Symbols**。

## 这个新的原始类型是关于什么的？

Symbol 原始类型是关于唯一性的。它的值是一个唯一的标识符。您可以简单地调用 `Symbol()` 并获得唯一的标识符。作为可选项，您也可以传递描述作为构造函数参数。

您应该记住的一点是，Symbol 始终是唯一的。即使您将相同的描述作为构造函数参数传递给两个 Symbol，它们还是会有所不同。

许多人认为 Symbol 是一种获得唯一值的方式。但是只有一部分是对的。尽管 Symbol 是唯一的，但是您永远不会通过控制台记录它来获得唯一的值。您只能将其分配给一个变量，并将该变量用作唯一标识符。

换句话说，Symbol 不会给出唯一的值，例如一个可能看起来像 **285af1ae40223348538204f8c3a58f34** 的 ID。但是与此相反，当您打印一个 Symbol 时，您将收到 `Symbol()` 或 `Symbol(description)`。请记住，它不是字符串，而是普通的旧 **Symbol**。

```js
typeof Symbol()
"symbol"
```

您可以通过在 Symbol 上调用 `toString()` 方法来获取字符串。但这也只会为您提供先前获得的值的字符串。

## 注意事项

#### 不会自动转换为字符串

`window.alert()` 接收一个字符串类型的参数。但是，即使您传递了一个 `number` 甚至是 `null`，您也不会收到错误提示。JavaScript 会隐式地将数据类型转换为字符串并显示它。但是对于 Symbol，JavaScript 不会将其隐式地转换为字符串。这是为了保持这两个分开，因为它们根本上是不同的，不应该意外地将一个转换成另一个。

#### 在对象字面量中使用 Symbol 作为键

看一下下面的代码。

```js
let id = Symbol("id");

let obj = {
  id: 1
};
// 这是字符串 “id” 作为键。而不是 Symbol
```

在上述例子中，尽管我们将一个 `id` 属性赋值给 `obj` 对象，但是它不是我们在前一行定义的 `id` 变量。为了将 `id` 变量设置为键，我们应该使用 `[]`。

```js
let id = Symbol("id");

let obj = {
  [id]: 1
};
```

同样地，您不能使用点语法访问以 Symbol 为键的属性。您必须使用上述提到的方括号来访问属性。

```js
console.log(obj.id);
//undefined

console.log(obj[id]);
//1
```

#### 常见的对象检查功能会跳过 Symbol

由于 Symbol 是为了避免冲突而设计的，因此在 JavaScript 最常见的对象检查功能（例如 `for-in` 循环）中会跳过 Symbol 属性。在 `Object.keys(obj)` 和 `Object.getOwnPropertyNames(obj)` 中也将忽略作为属性键的 Symbol。

还要注意，当您使用 `JSON.stringify()` 时，将忽略对象的 Symbol 属性。

## 全局 Symbol 注册表

正如我们在上面看到的，即使将相同的描述作为参数传递给 Symbol，Symbol 也是唯一的。但是在某些情况下，您需要在多个网页或同一网页中的多个模块间来共享一个 Symbol。在这种情况下，您可以使用**全局 Symbol 注册表**。

虽然这听起来像一个复杂的系统，但它的接口使用起来相当简单。

#### Symbol.for(key)

这个方法会在**全局 Symbol 注册表**中搜索既有的 Symbol，并在找到后返回。如果未找到，它将使用传递的健在**全局 Symbol 注册表**中创建一个 Symbol 并将其返回。

```js
let userId = Symbol.for('user_id');
// 从全局 Symbol 表中读取
// 如果未找到则创建一个 Symbol

let userID = Symbol.for('user_id');
// 从全局 Symbol 表中读取


console.log(userID === userId);
// true
```

#### Symbol.keyFor(sym)

此方法与 `Symbol.for()` 方法相反。这将从全局 Symbol 注册表中检索给定 Symbol 的共享 Symbol 键。

```js
// 从全局 Symbol 表中读取
let userId = Symbol.for('user_id');
let userName = Symbol.for('username');

console.log(Symbol.keyFor(userId));
// user_id

console.log(Symbol.keyFor(userName));
// username
```

## 用例

#### 隐藏属性

假设您要开发一个库来对项目列表进行排序。

您会如何解决呢？

您有多种解决方法。您可以忽略列表是否已排序并对它重新进行排序。尽管最终结果将是一个已排序列表，但是由于该算法对已排序的数组实施了实际的排序过程，因此效率不高。

我们可以简单地设置一个标志来表示列表是否已排序，而不是实施一个过大的解决方案。这很容易使我们仅在未排序列表时对其进行排序。

该实现看起来与此类似。

```js
if (!list.isSorted) {
  sortAlgorithm(list);
}
list.isSorted = true;
```

尽管以上实现可以很好地完成其工作，但是在某些方面却失败了。

* 使用 `for-in`或 `Object.keys()` 时，访问列表的任何其他代码都可能使您的属性绊倒。
* 如果您使用一个库来实现排序算法，那么聪明的库所有者可能已经设置了 `isSorted` 标志。如果上下文更大，那么您做同样的事情将过犹不及。
* 如果您是该库的所有者，一个聪明的开发者会尝试自己设置该标志，这类似于上述情况。

在这种情况下，Symbol 会很完美，因为它们可以避免冲突。

```js
let id = Symbol('id');

let user = {
  name: "Jane Doe",
  [id]: 1
};

console.log(user[id]);
// 1

// ---------------------------------

// 有人尝试向 user 添加自己的 ID

user.id = '124C';


console.log(user[id]);
// 1


console.log(user.id);
// '124C'

// ---------------------------------
  
// 有人试图将自己的 ID 作为 Symbol 添加到 user
let id2 = Symbol('id');

user[id2] = '9990X';


console.log(user[id]);
// 1


console.log(user.id);
// '124C'

console.log(user[id2]);
// '9990X'
```

#### 系统 Symbol

JavaScript 使用几个内部 Symbol 来微调它在各个方面的性能。其中一些是，

* Symbol.asyncIterator
* Symbol.hasInstance
* Symbol.isConcatSpreadable
* Symbol.iterator

您可以在[**这里**](https://tc39.es/ecma262/#sec-well-known-symbols)读到更多相关资料。

---

**注意：Symbol 不是 100％ 完全隐藏**

您仍然可以使用 `Object.getOwnPropertySymbols(obj)` 和 `Reflect.ownKeys(obj)` 之类的方法来接收用作对象键的 Symbol。您可能想知道为什么。我个人认为 Symbol 被创立是为了避免**意外的命名冲突**。如果有人真的想覆盖 Symbol 属性键，那么我认为他们有可能这样做。

## React 中关于 Symbol 的普遍问题

在关于 [Bits and Pieces](https://blog.bitsrc.io/?source=post_page-----2b6fa2cecfe2----------------------&gi=39b41a3c39ac) 编辑器的讨论中，我被要求解决 React JS 中涉及 Symbol 的问题。以下是所提出问题的链接。

[将 Symbol 用于数组或迭代器的子项的键 · Issue #11996 · facebook/react, github.com](https://github.com/facebook/react/issues/11996)

#### 正被要求实现的特性

对于那些没有浏览过上面的链接或不了解正在发生的事情的人，以下是为您提供的摘要。

React 开发人员应该熟悉键的概念。以下是截取自 React 文档的[术语表](https://reactjs.org/docs/glossary.html#keys)。

> “键”是创建元素数组时需要包括的特殊字符串属性。键可帮助 React 识别哪些项已更改，添加或删除。应该为数组中的元素提供键，以使元素具有稳定的标识。

我相信以上片段解释了什么是键。

键存在的根本原因是唯一性。它需要能够唯一地标识数组中的同级元素。这听起来是一个很好的 Symbol 用例，因为它们是唯一的，可以用来唯一地标识数组中的每个同级元素。

但是，当您将 Symbol 添加为数组元素的键时，您将收到以下[错误](https://codesandbox.io/s/happy-wright-07ryi?file=/src/App.js)。

![Error Screenshot by Author](https://cdn-images-1.medium.com/max/2238/1*JJAf4BVLrMt61Rj4wc9-zQ.png)

出现上述错误的原因是键的类型应为 **string**。如果您还记得我们前文所提及的，那么就会知道 Symbol 不是字符串类型，而且它们不会像其他原始数据类型那样隐式地转换自己。

**大家正在要求实现的特性是允许原生支持 Symbol 作为键来使用，因为它们不会自动将自身转换为字符串。**

#### 为什么 react 团队拒绝并关闭了这个 issue

Dan Abramov 评论并关闭了此 issue，并提到“**除非是误解，否则我看不出允许这么使用 Symbol 的实际用例**”。他还提到，您可以简单地使用“**自定义 ID 或用户名**”或您处理数据的地方附带的内容。

**我想从两个角度发表我的观点。**

首先，在某些情况下，您可能会在没有 ID 的情况下处理数据列表。当从前端收集数据并显示为列表时，可能会发生这种情况。想想我在演示中使用的数字列表示例。如果数字是由用户输入的呢？您将必须设置一个计数器，以便为每个条目分配唯一的键。有些人会采用为每个元素分配数组索引的方法，但这是一个[非常糟糕的主意](https://medium.com/@robinpokorny/index-as-a-key-is-an-anti-pattern-e0349aece318)。您不能将输入值作为键，因为可能有重复的输入。正如所建议的那样，Symbol 将成为一种更简单的选择。

#### 但是....

该提案有根本上的错误。请看下面的代码。

```ts
<ul>
  <li key={Symbol()}>1</li>
  <li key={Symbol()}>2</li>
  <li key={Symbol()}>3</li>
  <li key={Symbol()}>1</li>
</ul>
```

如您所见，这 4 个键都是唯一的。当元素值发生变化时，React 知道是哪一个发生了变化，并触发重建。但是当 DOM 树重建时，该特定元素的键将再次更改，因为 `Symbol()` 每次在被内联使用时都会被赋予唯一值。每一次渲染的`键`都不同，这将迫使 React 重新挂载元素或组件。

如果您不清楚在上述情况下 DOM 树的构建过程和变更检测是如何工作的，请仔细阅读这份[文档中的说明](https://reactjs.org/docs/reconciliation.html)。

通过使用全局 Symbol 注册表 —— `Symbol.for(key)`，可以避免这个重新渲染问题，因为每次调用 Symbol 时，都会在全局注册表中查找 Symbol，如果找到，它将被返回。

#### 但是又一次....

这种方法也有问题。若要从全局注册表中检索 Symbol，您应该提供 Symbol 的键，而该键本身是唯一的。如果您仔细想想，这个键本身对于标识每个元素是唯一的。那么我们为什么需要在那个实例上再创建一个 Symbol 呢？

#### 注意

但是 [Eduardo](https://github.com/esanzgar) 提供了一种解决方案，一旦使用 Symbol 初始化了对象或数组，那么它们就永远不会被重新初始化。这意味着值在每次渲染时不会被重新计算，因此值 (Symbol) 将始终相同。此方法只能在某些情况下起作用。

```ts
import React from 'react';

const TODO = [
  {id: Symbol(), content: 'Wake up'},
  {id: Symbol(), content: 'Go to sleep'},
];

const App = () => {
  return (
    <>
      {TODO.map(({id, content}) => (
        <p key={id}>{content}</p>
      ))}
    </>
  );
};

export default App;
```

您应该注意，所有给定的解决方案都可以使用，但是它们会触发不必要的重新挂载，并在内存和 CPU 上造成不必要的负载。我们的目标是想出一个解决方案，让使用 Symbol 也可以是高效的。

如果您有任何意见，请随时在下面评论。

感谢您的阅读，祝您编码愉快。

**参考文档**

- [JavaScript Info](https://javascript.info/symbol)
- [Mozilla Blog](https://hacks.mozilla.org/2015/06/es6-in-depth-symbols/)
- [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol)
- [ECMA Script Specs](https://tc39.es/ecma262/#sec-well-known-symbols)
- [React Docs](https://reactjs.org/docs/lists-and-keys.html#keys)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
