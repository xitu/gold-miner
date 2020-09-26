> * 原文地址：[Mastering JavaScript ES6 Symbols](https://blog.bitsrc.io/mastering-javascript-es6-symbols-6453da3bd46c)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/mastering-javascript-es6-symbols.md](https://github.com/xitu/gold-miner/blob/master/article/2020/mastering-javascript-es6-symbols.md)
> * 译者：
> * 校对者：

# Mastering JavaScript ES6 Symbols

![](https://cdn-images-1.medium.com/max/2560/1*E5bxT-J688MnfPJ92Zr25A.png)

JavaScript is one of the cores of web development. JavaScript, also known as ECMAScript was standardized in 1997. Since then, the below primitive values were present in the language.

* Undefined
* Null
* Big Int(newly added in ES2020)
* Boolean
* Number
* String

`null` is labeled as one of the primitive values in JavaScript, since its action is apparently primitive. But in some situations, `null` is not as “primitive” as it first seems! Every Object is derived from `null` value, and therefore `typeof` operator returns an object for it.

But with the release of ES6 in 2015, a newer primitive type — **Symbol**, was added. They were quite different from the previous primitives. They were simply values, not strings, nor numbers nor even Objects. They were just **Symbols**.

## What is This New Primitive All About?

The Symbol primitive is all about uniqueness. Its value is a unique identifier. You can simply call `Symbol()` and get a unique identifier. Optionally, you can pass a description as well.

One of the key things you should remember is that, Symbols are always unique. Even if you pass the same description to two Symbols, they will still be different.

A lot of people think of Symbols as a way of receiving a unique value. But only part of this is true. Although Symbols are unique, you will never receive the unique value by console logging it. You can only assign it to a variable and use that variable as a unique identifier.

In other words, your Symbol would not give a unique value like an ID which might look like **285af1ae40223348538204f8c3a58f34**. But rather, when you console a Symbol, you will receive `Symbol()` or `Symbol(description)` . Remember that it would not be a string, rather a plain old **Symbol.**

```js
typeof Symbol()
"symbol"
```

You can obtain a string by calling the `toString()` method on the Symbol. But that too would only give you a string representation of the previously obtained value.

## Things to keep in mind

#### No auto-conversion to string

The `window.alert()` receives a parameter of type string. But even if you do pass a `number` or even `null`, you will not receive an error. Rather JavaScript implicitly converts the data type into a string and displays it. But with the case of Symbols, JavaScript does not implicitly convert it to a string. It is to keep these two separate as they are fundamentally different and should not accidentally convert one into another.

#### Using Symbols as keys in an Object literal

Take a look at the below code.

```js
let id = Symbol("id");

let obj = {
  id: 1
};
//This is string "id" as key. Not our Symbol
```

In the above example, although we have assigned a `id` property to our `obj` object, it is not the `id` variable we had defined the line before. In order to set the `id` variable as a key, we should use `[ ]` .

```js
let id = Symbol("id");

let obj = {
  [id]: 1
};
```

Similarly, you can’t access symbol-keyed properties using the dot-syntax. You have to use square brackets like above.

```js
console.log(obj.id);
//undefined

console.log(obj[id]);
//1
```

#### Symbols are skipped by common object inspection features

As Symbols were designed to avoid collisions, Symbolic properties are skipped in JavaScript’s most common object-inspection features such as `for-in` loop. Symbols as property keys are also ignored in `Object.keys(obj)` and Object.getOwnPropertyNames(obj) .

Also note that Symbol properties of an object are ignored when you use `JSON.stringify()`.

## Global Symbol Registry

As we have seen above, Symbols are unique, even with the same descriptions we pass as parameters. But there might be instances where you need multiple web pages or multiple modules within the same web page to share a Symbol. At moments like this, you can use the **Global Symbol Registry.**

Although it sounds like a complicated system, the interface is quite simple to use.

#### Symbol.for(key)

This method searches for existing symbols in the **global symbol registry** with the provided key and returns it if found. If not found, it would create a Symbol with the key in the **global symbol registry** and returns it.

```js
let userId = Symbol.for('user_id');
//read from global registry
//create Symbol if not exists

let userID = Symbol.for('user_id');
//read from global registry


console.log(userID === userId);
//true
```

#### Symbol.keyFor(sym)

This method performs the reverse of the `Symbol.for()` method. This retrieves a shared symbol key from the global symbol registry for the given symbol.

```js
//read from global registry
let userId = Symbol.for('user_id');
let userName = Symbol.for('username');

console.log(Symbol.keyFor(userId));
//user_id

console.log(Symbol.keyFor(userName));
//username
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
