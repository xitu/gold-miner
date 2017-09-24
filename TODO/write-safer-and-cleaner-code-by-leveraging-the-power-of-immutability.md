> * 原文地址：[Write safer and cleaner code by leveraging the power of “Immutability”
](https://medium.freecodecamp.com/write-safer-and-cleaner-code-by-leveraging-the-power-of-immutability-7862df04b7b6)
> * 原文作者：本文已获原作者 [Guido Schmitz](https://medium.freecodecamp.com/@guidsen) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[gy134340](https://github.com/gy134340)
> * 校对者：[bambooom](https://github.com/bambooom),[xunge0613](https://github.com/xunge0613)

# 利用 Immutability（不可变性）编写更为简洁高效的代码

![](https://cdn-images-1.medium.com/max/2000/1*eO8-0-GT5ht8CR7TdK9knA.jpeg)

图片来自[https://unsplash.com](https://unsplash.com)

不可变性是函数式编程中的一部分，它可以使你写出更安全更简洁的代码。我将会通过一些 JavaScript 的例子来告诉你如何达到不可变性。

**根据维基（ [地址](https://en.wikipedia.org/wiki/Immutable_object) ）：**

> 一个不可变对象（不能被改变的对象）是指在创建之后其状态不能被更改的对象，这与在创建之后可以被更改的可变对象（可以被改变的对象）相反。在某些情况下，一个对象的外部状态如果从外部看来没有变化，那么即使它的一些内部属性更改了，仍被视为不可变对象。

### 不可变的数组

数组是了解不可变性如何运作的一个很好的起点。我们来看一下。

```
const arrayA = [1, 2, 3];
arrayA.push(4);

const arrayB = arrayA;
arrayB.push(5);

console.log(arrayA); // [1, 2, 3, 4, 5]
console.log(arrayB); // [1, 2, 3, 4, 5]
```

例子中 **arrayB** 是 **arrayA** 的引用，所以如果我们通过 push 方法向任意数组中添加一个值 5，那么就会间接影响到另外一个，这个是违反不可变性的原则的。

我们可以通过使用 [slice](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice) 函数以达到不可变性(译者注：slice 相当于浅复制，要求数组中的每一项必须是简单数据类型。如 undefined、Number、null、String、Boolean 等)，进而优化我们的例子，此时代码的行为是完全不一样的。

```
const arrayA = [1, 2, 3];
arrayA.push(4);

const arrayB = arrayA.slice(0);
arrayB.push(5);

console.log(arrayA); // [1, 2, 3, 4]
console.log(arrayB); // [1, 2, 3, 4, 5]
```

这才是我们要的，代码不改变其它的值。

记住：当使用 [push](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/push) 来给数组添加一个值时，你在**改变**这个数组，因为这样可能会影响代码里的其他部分，所以你想要避免使变量值发生改变。[slice](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/slice) 会返回一个复制的数组。

### 函数

现在你知道了如何避免改变其它的值。那如何写「纯」的函数呢？纯函数是指不会产生任何副作用，也不会改变状态的函数。

我们来看一个示例函数，其原理与前面数组示例的原理相同。首先我们写一个会改变其它值的函数，然后我们将这个函数优化为「纯」函数。

```
const add = (arrayInput, value) => {
  arrayInput.push(value);

  return arrayInput;
};
```

```
const array = [1, 2, 3];

console.log(add(array, 4)); // [1, 2, 3, 4]
console.log(add(array, 5)); // [1, 2, 3, 4, 5]
```

于是我们又一次**改变**输入的变量的值，这使得这个函数变得不可预测。在函数式编程的世界里，有一个关于函数的铁律：**函数对于相同的输入应当返回相同的值。**

上面的函数违反了这一规则，每次我们调用 **add** 方法，它都会改变**数组**变量导致结果不一样。

让我们来看看怎样修改 **add** 函数来使其不可变。

```
const add = (arrayInput, value) => {
  const copiedArray = arrayInput.slice(0);
  copiedArray.push(value);

  return copiedArray;
};

const array = [1, 2, 3];
```

```
const resultA = add(array, 4);
console.log(resultA); // [1, 2, 3, 4]
```

```
const resultB = add(array, 5);
console.log(resultB); // [1, 2, 3, 5]
```

现在我们可以多次调用这个函数，且相同的输入获得相同的输出，与预期一致。这是因为我们不再改变 **array** 变量。我们把这个函数叫做“纯函数”。

> **注意：** 你还可以使用 **concat**，来代替 **slice** 和 **push**。
> 即：arrayInput.concat(value);

我们还可以使用 ES6 的[扩展语法](https://developer.mozilla.org/nl/docs/Web/JavaScript/Reference/Operators/Spread_operator)，来简化函数。

```
const add = (arrayInput, value) => […arrayInput, value];
```

### 并发

NodeJS 的应用有一个叫并发的概念，并发操作是指两个计算可以同时的进行而不用管另外的一个。如果有两个线程，第二个计算不需要等待第一个完成即可开始。

![](https://cdn-images-1.medium.com/max/800/1*LS1VkNditQwYMJvtIPAhdg.png)

可视化的并发操作

NodeJS 用事件循环机制使并发成为可能。事件循环重复接收事件，并一次触发一个监听该事件的处理程序。这个模型允许 NodeJS 的应用处理大规模的请求。如果你想学习更多，读一下[这篇关于事件循环的文章](https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick)。

不可变性跟并发又有什么关系呢？由于多个操作可能会并发地改变函数的作用域的值，这将会产生不可靠的输出和导致意想不到的结果。注意函数是否改变它作用域之外的值，因为这可能真的会很危险。

### 下一步

不可变性是学习函数式编程过程中的一个重要概念。你可以了解一下由 Facebook 开发者写的 [ImmutableJS](https://facebook.github.io/immutable-js)，这一个库提供一些不可变的数据结构，比如说 **Map**、**Set**、和 **List**。

[![](http://i2.muimg.com/1949/d4d40e047da813b5.png)](https://medium.com/@dtinth/immutable-js-persistent-data-structures-and-structural-sharing-6d163fbd73d2)

点击 💙 让更多的人可以在 Medium 上看见这篇文章，感谢阅读。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。

