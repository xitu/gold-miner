> * 原文地址：[Mastering JavaScript ES6 Symbols](https://blog.bitsrc.io/mastering-javascript-es6-symbols-6453da3bd46c)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/mastering-javascript-es6-symbols.md](https://github.com/xitu/gold-miner/blob/master/article/2020/mastering-javascript-es6-symbols.md)
> * 译者：[Inchill](https://github.com/Inchill)
> * 校对者：

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

但是随着 2015 年 ES6 的发布，一个更新的原始类型 —— **Symbol**，被添加了进去。它们与以前的原始值相比有很大的不同。它们只是值，不是字符串，也不是数字甚至对象。它们只是 **Symbols**。

## 这个新的原始类型是关于什么的？

Symbol 原始类型是关于唯一性的。它的值是一个唯一的标识符。您可以简单地调用 `Symbol()` 并获得唯一的标识符。作为可选项，您也可以传递描述作为参数。

您应该记住的一点是，Symbol 始终是唯一的。即使您将相同的描述传递给两个 Symbol，它们还是会有所不同。

许多人认为 Symbol 是一种获得唯一值的方式。但是只有一部分是对的。尽管 Symbol 是唯一的，但是您永远不会通过控制台记录它来获得唯一的值。您只能将其分配给一个变量，并将该变量用作唯一标识符。

换句话说，Symbol 不会给出唯一的值，例如一个可能看起来像 **285af1ae40223348538204f8c3a58f34** 的 ID。但是与此相反，当您打印一个 Symbol 时，您将收到 `Symbol()` 或 `Symbol(description)`。请记住，它不是字符串，而是普通的旧 **Symbol**。

```js
typeof Symbol()
"symbol"
```

您可以通过在 Symbol 上调用 `toString()` 方法来获取字符串。但这也只会为您提供先前获得的值的字符串表示形式。

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

#### 通用对象检查功能会跳过 Symbol

由于 Symbol 是为了避免冲突而设计的，因此在 JavaScript 最常见的对象检查功能(例如 `for-in` 循环)中会跳过 Symbol 属性。在 `Object.keys(obj)`和`Object.getOwnPropertyNames(obj)` 中也将忽略作为属性键的 Symbol。

还要注意，当您使用 `JSON.stringify()` 时，将忽略对象的 Symbol 属性。

## 全局 Symbol 注册表

正如我们在上面看到的，即使将相同的描述作为参数传递给 Symbol，Symbol 也是唯一的。但是在某些情况下，您需要在多个网页或同一网页中的多个模块间来共享一个 Symbol。在这种情况下，您可以使用**全局 Symbol 注册表**。

虽然这听起来像一个复杂的系统，但它的界面使用起来相当简单。

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

## Use Cases

#### Hidden properties

Let’s imagine that you want to develop a library to sort a list of items.

How can you solve this?

You have many ways of solving this. You can ignore whether the list is sorted and re-sort it. Although the end result would be a sorted list, it will be inefficient as the algorithm implements the actual sorting process on an already sorted array.

Rather than implementing a solution that would be an overkill, we can simply set a flag to denote whether the list has been sorted or not. This would easily allow us to sort our list only when it has not been sorted.

The implementation would look somewhat similar to this.

```js
if (list.isSorted) {
  sortAlgorithm(list);
}
list.isSorted = true;
```

Although the above implementation does its job perfectly, it fails under certain aspects.

* Any other code accessing your list can stumble over your property when using `for-in` or `Object.keys()` .
* If you are using a library to implement the sort algorithm, the clever library owner might have set a `isSorted` flag already. You doing the same thing would be an overkill if the context was bigger.
* If you were the owner of the library and a clever developer tries to set the flag themself, it would be similar to the above scenario.

In a situation like this, Symbols would be perfect as they avoid collisions.

```js
let id = Symbol('id');

let user = {
	name:"Jane Doe",
  	[id]:1
};

console.log(user[id]);
//1

// ---------------------------------

//someone tries to add their own ID to user

user.id = '124C';


console.log(user[id]);
//1


console.log(user.id);
//'124C'

// ---------------------------------
  
//someone tries to add their own ID to user as a Symbol
let id2 = Symbol('id');

user[id2] = '9990X';


console.log(user[id]);
//1


console.log(user.id);
//'124C'

console.log(user[id2]);
//'9990X'
```

#### System Symbols

JavaScript uses several internal Symbols to fine tune it’s performance under various aspects. Some of them are,

* Symbol.asyncIterator
* Symbol.hasInstance
* Symbol.isConcatSpreadable
* Symbol.iterator

You can read more about them over [**here**](https://tc39.es/ecma262/#sec-well-known-symbols).

---

**Note: Symbols are not 100% totally hidden**

You can still users methods such as Object.getOwnPropertySymbols(obj) and `Reflect.ownKeys(obj)` to receive the Symbols used as Object keys. You might wonder why. I personally feel that Symbols were created to avoid **unintentional naming collisions**. If someone really wanted to overwrite the Symbolic property key, then I think it would be possible for them to do so.

## Popular Issue Raised in React Regarding Symbols

During the discussion with the editor of [Bits and Pieces](https://blog.bitsrc.io/?source=post_page-----2b6fa2cecfe2----------------------&gi=39b41a3c39ac), I was asked to address an issue raised in React JS involving Symbols. Below is a link to the raised issue.

[Symbols as keys in children as arrays or iterators · Issue #11996 · facebook/react, github.com](https://github.com/facebook/react/issues/11996)

#### Feature being requested

For those who did not go through the above link or did not understand what was happening, below is a summary for you.

React developers should be familiar with the concept of keys. Below is an extract from the [glossary](https://reactjs.org/docs/glossary.html#keys) of React docs.

> A “key” is a special string attribute you need to include when creating arrays of elements. Keys help React identify which items have changed, are added, or are removed. Keys should be given to the elements inside an array to give the elements a stable identity.

I believe the above passage explains what keys are.

The fundamental reason for keys is uniqueness. It is needed to be able to identify sibling elements in an array uniquely. This sounds like a great use case for Symbols as they are unique and can be used to identify each sibling element in an array uniquely.

But when you add a Symbol as a key to an array element, you will receive the following error. You can view the source code for the below example over [here](https://codesandbox.io/s/happy-wright-07ryi?file=/src/App.js).

![Error Screenshot by Author](https://cdn-images-1.medium.com/max/2238/1*JJAf4BVLrMt61Rj4wc9-zQ.png)

The reason for the above error is that keys are expected to be of type **string**. If you remember what we had gone through, Symbols are not of string type and they do not implicitly convert themselves unlike other primitive data types.

**The feature being requested is to allow support for Symbols as keys natively because they do not auto convert themselves to strings.**

#### Why the team refused and closed this issue

Dan Abramov commented and closed down this issue mentioning “**I don’t see a practical use case for allowing Symbols, except a misunderstanding**”. He also mentions that you can simply use the “**customer ID, or username**” or something that comes with the data you’re handling.

**I would like to voice out my opinion from both perspectives.**

First of all, there can be instances where you would be handling a list of data without an ID as such. This can happen when the data is collected from the front-end and displayed as a list. Think of the number list example I had used in the demo. What if the numbers were entered by the user? You would have to set a counter to assign a unique key to each entry. Some would take the approach of assigning the array index to each element, but that is known to be a [really bad idea](https://medium.com/@robinpokorny/index-as-a-key-is-an-anti-pattern-e0349aece318). You cannot make the input value as a key because there can be duplicate inputs. As proposed, Symbols would make an easier alternative.

#### But….

There is something fundamentally wrong in the proposal. Have a look at the below code example.

```ts
<ul>
  <li key={Symbol()}>1</li>
  <li key={Symbol()}>2</li>
  <li key={Symbol()}>3</li>
  <li key={Symbol()}>1</li>
</ul>
```

As you can see, all 4 keys are unique. When there is a change in an element value, React knows which one has changed, and triggers a rebuild. But when the tree is rebuilt, the key of that specific element would change again as `Symbol()` would give a unique value every time it is called as it is being used inline. The `key` would be different on every render, which would force React to re-mount the element/component.

If you are not clear on how the tree building process and change detection work in the above scenario, please go through this [explanation given in the docs](https://reactjs.org/docs/reconciliation.html).

You can avoid this re-render issue by using the global symbol registry — `Symbol.for(key)` as every time you call for a Symbol, you would look for the Symbol in the global registry and if found, it will be returned.

#### But again….

There is something wrong with this approach too. For you to retrieve a Symbol from the global registry, you should provide the key of the Symbol which itself is unique. If you think about it, that key itself is unique to identify each element. Then why do we need to create a Symbol at that instance?

#### NOTE

But there was a solution provided by [Eduardo](https://github.com/esanzgar) where you initialize the object or array once with the Symbols and then they are never re-initialized. Which means the value will not be re-calculated on each render and therefore the values(Symbols) will always be the same. This approach can work on certain situations only.

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

You should note that all of the given solutions would work, but they would trigger unnecessary re-mounts and cause unwanted load on the memory and CPU. The goal is to come up with a solution using Symbols that can be efficient as well.

If you have any comments, please feel free to drop them below.

Thank you for reading and happy coding.

**Resources**

- [JavaScript Info](https://javascript.info/symbol)
- [Mozilla Blog](https://hacks.mozilla.org/2015/06/es6-in-depth-symbols/)
- [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol)
- [ECMA Script Specs](https://tc39.es/ecma262/#sec-well-known-symbols)
- [React Docs](https://reactjs.org/docs/lists-and-keys.html#keys)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
