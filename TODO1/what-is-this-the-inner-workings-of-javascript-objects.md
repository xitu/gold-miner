> * 原文地址：[What is `this`? The Inner Workings of JavaScript Objects](https://medium.com/javascript-scene/what-is-this-the-inner-workings-of-javascript-objects-d397bfa0708a)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-this-the-inner-workings-of-javascript-objects.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-this-the-inner-workings-of-javascript-objects.md)
> * 译者：[fireairforce](https://github.com/fireairforce)
> * 校对者：[ezioyuan](https://github.com/ezioyuan), [Baddyo](https://github.com/Baddyo)

# 什么是 `this`？JavaScript 对象的内部工作原理

![**Photo: Curious by Liliana Saeb (CC BY 2.0)**](https://cdn-images-1.medium.com/max/3200/1*q-p49V6XkQRrvh5w4vauSg.jpeg)

JavaScript 是一种支持面向对象编程和动态绑定的多范型语言。动态绑定是一个强大的概念，它允许 JavaScript 代码的结构在运行时改变，但是这种额外的功能和灵活性是以一些混乱为代价的，并且很多混乱主要集中在 JavaScript 的行为方式上。

## 动态绑定

动态绑定指的是在运行时而不是编译时，确定要调用的方法的过程。JavaScript 通过 `this` 和原型链来实现这点。特别是，方法内部 `this` 的指向是在运行时确认的，而且指向会根据方法的定义而改变。

下面来玩个游戏。游戏的名字叫做“什么是 `this`”？

```js
const a = {
  a: 'a'
};

const obj = {
  getThis: () => this,
  getThis2 () {
    return this;
  }
};
obj.getThis3 = obj.getThis.bind(obj);
obj.getThis4 = obj.getThis2.bind(obj);

const answers = [
  obj.getThis(),
  obj.getThis.call(a),
  obj.getThis2(),
  obj.getThis2.call(a),
  obj.getThis3(),
  obj.getThis3.call(a),
  obj.getThis4(),
  obj.getThis4.call(a)
];
```

在继续阅读之前，请你先把答案写出来。完成后再用 `console.log()` 来检查你的答案是否正确。你答对了吗？

我们先从第一个例子开始，然后依次解释下面的样例。`obj.getThis()` 返回了 `undefined`, 但是为什么呢？因为箭头函数永远都没有自己的 `this` 绑定。作为替代的是，它总是会委托给词法作用域。在 ES6 模块的根作用域中，这个例子里面的词法作用域将具有未定义的 `this`。那么 `obj.getThis.call(a)` 同样也会返回 undefined。对于箭头函数来说，即使使用 `.call()` 或 `.bind()`，也不能重新修改 `this`。它总是会去委托词法作用域里面的 `this`。

`obj.getThis2()` 通过常规方法调用过程来获取 `this` 的绑定。如果函数以前没有绑定 `this`，那么它可以有 `this` 绑定（该函数不是箭头函数），`this` 会使用 `.` 或方括号 `[ ]` 属性访问语法来绑定到调用改方法的对象上。

`obj.getThis2.call(a)` 有点不好分析。`call()` 方法使用给定的 `this` 值和可选参数调用函数。换句话说，这个函数通过 `.call()` 的参数来获取绑定到 `this`，因此 `obj.getThis2.call(a)` 会返回 `a` 对象。

我们试图通过 `obj.getThis3 = obj.getThis.bind(obj);` 来绑定一个箭头函数，前面我们已经确定这里不会起作用，所以 `obj.getThis3()` 和 `obj.getThis3.call(a)` 都会返回 `undefined`。

我们可以绑定常规的方法，因此 `obj.getThis4()` 方法会按照预期返回 `obj`，因为它已经通过 `obj.getThis4 = obj.getThis2.bind(obj)` 绑定了 `this`，所以 `obj.getThis4.call(a)` 会优先返回第一次绑定时的 `obj` 而不是 `a`。

## 弧线球

同样的挑战，但这一次，我们使用带公共字段语法（本文撰写时，该语法已推进到 TC39 委员会的[第三阶段](https://github.com/tc39/proposal-class-fields), 默认支持 Chrome 和 @babel/plugin-proposal-class-properties）的 `class`：

```js
class Obj {
  getThis = () => this
  getThis2 () {
    return this;
  }
}

const obj2 = new Obj();
obj2.getThis3 = obj2.getThis.bind(obj2);
obj2.getThis4 = obj2.getThis2.bind(obj2);

const answers2 = [
  obj2.getThis(),
  obj2.getThis.call(a),
  obj2.getThis2(),
  obj2.getThis2.call(a),
  obj2.getThis3(),
  obj2.getThis3.call(a),
  obj2.getThis4(),
  obj2.getThis4.call(a)
];
```

在继续之前先写下你的答案。

准备好检查答案了吗？

除了 `obj2.getThis2.call(a)`，这些调用都会返回对象的实例。`obj2.getThis2.call(a)` 返回 `a` 对象。箭头函数**仍然会去绑定词法作用域的 `this`**。区别只是在于词法的 `this` 属性不同。在这种情况下，类属性复制会被编译成类似下面这样的东西：

```js
class Obj {
  constructor() {
    this.getThis = () => this;
  }
...
```

换句话说，箭头函数是在**构造函数的上下文中**被定义的。由于它是一个类，创建实例的唯一方法是使用 `new` 关键字（忽略 new 将抛出错误）。

`new` 关键字最重要的一个作用是实例化一个新的对象并且在构造函数中绑定 `this`。这种行为，结合我们之间提到的其他行为应该可以解释剩下的例子了。

## 结论

你是怎么理解的？你有理解上面的内容吗？对 JavaScript 中 `this` 的透彻理解，能够大大缩短调试棘手的问题的时间。如果上面你有任何错误的答案，那么你应该好好练习一下。仔细琢磨这些例子，然后再来测试自己，直到你能完全通过测试，并且能够向其他人解释为什么这些方法会返回相应的内容。

如果你觉得这比你想象中的难，这并不是你一个人会这样。我针对这些问题测试过不少的开发人员，到目前为止只有一个开发人员能够很好的解释这些问题。

随着 `class` 或者箭头函数的增加，使用 `.call()`、`.bind()` 或 `.apply()` 重定向的动态方法查找变得更加复杂。稍微划分一下可能会有所帮助。请记住，箭头函数总是会将 `this` 委托给词法作用域，而 `class` 中的 `this` 实际上在词法上把作用域限定在构造函数中了。如果你还对 `this` 是什么有疑惑，记住使用调式工具来验证对象是否是你认为的对象。

同时也记住，在 JavaScript 中，你也可以在不使用 `this` 的情况下做很多事情。根据我的经验，几乎所有东西都可以使用纯函数来重新实现，它们可以将其所应用的参数都设为显式的参数（你可以把 `this` 理解为具有可变状态的隐式参数）。封装在纯函数中的逻辑具有确定性，这使得它更易于测试，并且没有副作用，这意味着与操作 `this` 不同，你不太可能破坏其它的东西。每次当你转换 `this` 时，你都要冒依赖于 `this` 值相关的内容会崩溃的风险。

即便如此，`this` 有时也是有用的。例如，在大量对象之间共享方法。即使是在函数式编程中，`this` 也可用于访问对象上的其它方法，以实现代数派生，从而在现有代数的基础上构建新的代数。例如，可以通过访问 `this.map()` 和 `this.constructor.of()` 派生一个通用的 `.flatMap()`。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
