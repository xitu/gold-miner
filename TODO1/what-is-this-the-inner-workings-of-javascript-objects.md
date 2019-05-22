> * 原文地址：[What is `this`? The Inner Workings of JavaScript Objects](https://medium.com/javascript-scene/what-is-this-the-inner-workings-of-javascript-objects-d397bfa0708a)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-this-the-inner-workings-of-javascript-objects.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-this-the-inner-workings-of-javascript-objects.md)
> * 译者：
> * 校对者：

# What is `this`? The Inner Workings of JavaScript Objects

![**Photo: Curious by Liliana Saeb (CC BY 2.0)**](https://cdn-images-1.medium.com/max/3200/1*q-p49V6XkQRrvh5w4vauSg.jpeg)

JavaScript is a multi-paradigm language that supports object-oriented programming and dynamic binding. Dynamic binding is a powerful concept which allows the structure of your JavaScript code to change at runtime, but that extra power and flexibility comes at the cost of some confusion, and a lot of that confusion is centered around how this behaves in JavaScript.

## Dynamic Binding

Dynamic binding is the process of determining the method to invoke at runtime rather than compile time. JavaScript accomplishes that with `this` and the prototype chain. In particular, the meaning of `this` inside a method is determined at runtime, and the rules change depending on how that method was defined.

Let’s play a game. I call this game “What is `this`?"

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

Before you continue, write down your answers. After you’ve done so, `console.log()` your answers to check them. Did you guess right?

Let’s start with the first case and work our way down. `obj.getThis()` returns `undefined`, but why? Arrow functions can never have their own `this` bound. Instead, they always delegate to the lexical scope. In the root scope of an ES6 module, the lexical scope in this case would have an undefined `this`. `obj.getThis.call(a)` is also undefined, for the same reason. For arrow functions, `this` can't be reassigned, even with `.call()` or `.bind()`. It will always delegate to the lexical `this`.

`obj.getThis2()` gets its binding via the normal method invocation process. If there is no previous `this` binding, and the function can have `this` bound (i.e., it's not an arrow function), `this` gets bound to the object the method is invoked on with the `.` or `[squareBracket]` property access syntax.

`obj.getThis2.call(a)` is a little trickier. The `call()` method calls a function with a given `this` value and optional arguments. In other words, it gets its `this` binding from the `.call()` parameter, so `obj.getThis2.call(a)` returns the `a`object.

With obj.getThis3 = obj.getThis.bind(obj);, we're trying to bind an arrow function, which we've already determined will not work, so we're back to `undefined` for both `obj.getThis3()`, and `obj.getThis3.call(a)`.

You can bind regular methods, so `obj.getThis4()` returns `obj`, as expected, and because it's already been bound with obj.getThis4 = obj.getThis2.bind(obj);, `obj.getThis4.call(a)` respects the first binding and returns `obj` instead of `a`.

## Curve Ball

Same challenge, but this time, with `class` using the public fields syntax ([Stage 3](https://github.com/tc39/proposal-class-fields) at the time of this writing, available by default in Chrome and with @babel/plugin-proposal-class-properties):

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

Write your answers down before you continue.

Ready?

With the exception of `obj2.getThis2.call(a)`, these all return the object instance. The exception returns the `a` object. The arrow function **still delegates to lexical `this`.** The difference is that lexical `this` is different for class properties. Under the hood, that class property assignment is being compiled to something like this:

```js
class Obj {
  constructor() {
    this.getThis = () => this;
  }
...
```

In other words, the arrow function is being defined **inside the context of the constructor function.** Since it’s a class, the only way to create an instance is to use the `new` keyword (omitting `new` will throw an error).

One of the most important things that the `new` keyword does is instantiate a new object instance and bind `this` to it in the constructor. This behavior, combined with the other behaviors we've already mentioned above should explain the rest.

## Conclusion

How did you do? Did you get them all right? A good understanding of how `this` behaves in JavaScript will save you a lot of time debugging tricky issues. If you got any of the answers wrong, it would serve you well to practice. Play with the examples, then come back and test yourself again until you can both ace the test, and explain to somebody else why the methods return what they return.

If that was harder than you expected, you’re not alone. I’ve tested quite a few developers on this topic, and I think only one developer has aced it so far.

What started as dynamic method lookups that you could redirect with `.call()`, `.bind()`, or `.apply()` has become significantly more complex with the addition of `class` and arrow function behavior. It may be helpful to compartmentalize a little. Remember that arrow functions always delegate `this` to the lexical scope, and that `class` `this` is actually lexically scoped to the constructor functions under the hood. If you're ever in doubt about what `this` is, remember to use your debugger to verify the object is what you think it is.

Remember also that in JavaScript, you can do a lot without ever using `this`. In my experience, almost anything can be reimplemented in terms of pure functions which take all the arguments they apply to as explicit parameters (you can think of `this` as an implicit parameter with mutable state). Logic encapsulated in pure functions is deterministic, which makes it more testable, and has no side-effects, which means that unlike manipulating `this`, you're unlikely to break anything else. Every time you mutate `this`, you take the chance that something else dependent on the value of `this` will break.

That said, `this` is sometimes useful. For instance, to share methods between a large number of objects. Even in functional programming, `this` can be useful to access other methods on the object to implement algebraic derivations to build new algebras on top of existing ones. For instance, a generic `.flatMap()` can be derived by accessing `this.map()` and `this.constructor.of()`.

***

**Eric Elliott** is a distributed systems expert and author of the books, [“Composing Software”](https://leanpub.com/composingsoftware) and [“Programming JavaScript Applications”](http://pjabook.com). As co-founder of [DevAnywhere.io](https://devanywhere.io), he teaches developers the skills they need to work remotely and embrace work/life balance. He builds and advises development teams for crypto projects, and has contributed to software experiences for **Adobe Systems, Zumba Fitness,** **The Wall Street Journal,** **ESPN,** **BBC,** and top recording artists including **Usher, Frank Ocean, Metallica,** and many more.

**He enjoys a remote lifestyle with the most beautiful woman in the world.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
