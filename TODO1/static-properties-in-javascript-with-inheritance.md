> * 原文地址：[Static Properties in JavaScript Classes with Inheritance](http://thecodebarbarian.com/static-properties-in-javascript-with-inheritance.html)
> * 原文作者：[Valeri Karpov](http://www.twitter.com/code_barbarian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/static-properties-in-javascript-with-inheritance.md](https://github.com/xitu/gold-miner/blob/master/TODO1/static-properties-in-javascript-with-inheritance.md)
> * 译者：
> * 校对者：

# Static Properties in JavaScript Classes with Inheritance

Since ES6, JavaScript enjoys support for classes and [static functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes/static) akin to static functions in other object-oriented languages. Unfortunately, JavaScript lacks support for static properties, and [recommended solutions on Google](https://esdiscuss.org/topic/define-static-properties-and-prototype-properties-with-the-class-syntax) fail to take into account inheritance. I ran into this problem when [implementing a new Mongoose feature](https://github.com/Automattic/mongoose/issues/6912) that requires a more robust notion of static properties. Specifically, I need static properties that support inheritance via setting `prototype` or via [`extends`](https://medium.com/beginners-guide-to-mobile-web-development/super-and-extends-in-javascript-es6-understanding-the-tough-parts-6120372d3420). In this article, I'll describe a pattern for implementing static properties in ES6.

## Static Methods and Inheritance

Suppose you have a simple ES6 class with a static method.

```javascript
class Base {
  static foo() {
    return 42;
  }
}
```

You can use `extends` to create a subclass and still have access to the `foo()` function.

```javascript
class Sub extends Base {}

Sub.foo(); // 42
```

You can also use [static getters and setters](https://stackoverflow.com/questions/41426658/es6-how-to-access-a-static-getter-from-an-instance) to set a static property on the `Base` class.

```javascript
let foo = 42;

class Base {
  static get foo() { return foo; }
  static set foo(v) { foo = v; }
}
```

Unfortunately, this pattern has undesirable behavior when you subclass `Base`. If you set `foo` on a subclass, it will set `foo` for the `Base` class and all other subclasses.

```javascript
class Sub extends Base {}

console.log(Base.foo, Sub.foo);

Sub.foo = 43;

// Prints "43, 43". The above set `Base.foo` as well as `Sub.foo`
console.log(Base.foo, Sub.foo);
```

The problem gets worse if your property is an array or an object. Because of prototypical inheritance, if `foo` is an array, every subclass will have a reference to the same copy of the array as shown below.

```javascript
class Base {
  static get foo() { return this._foo; }
  static set foo(v) { this._foo = v; }
}

Base.foo = [];

class Sub extends Base {}

console.log(Base.foo, Sub.foo);

Sub.foo.push('foo');

// Both arrays now contain 'foo' because they are the same array!
console.log(Base.foo, Sub.foo);
console.log(Base.foo === Sub.foo); // true
```

So JavaScript supports static getters and setters, but using them with objects or arrays is a footgun. Turns out you can do it with a little help from [JavaScript's built-in `hasOwnProperty()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/hasOwnProperty) function.

## Static Properties With Inheritance

The key idea is that a JavaScript class is just another object, so you can distinguish between [own properties](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyNames) and inherited properties.

```javascript
class Base {
  static get foo() {
    // If `_foo` is inherited or doesn't exist yet, treat it as `undefined`
    return this.hasOwnProperty('_foo') ? this._foo : void 0;
  }
  static set foo(v) { this._foo = v; }
}

Base.foo = [];

class Sub extends Base {}

// Prints "[] undefined"
console.log(Base.foo, Sub.foo);
console.log(Base.foo === Sub.foo); // false

Base.foo.push('foo');

// Prints "['foo'] undefined"
console.log(Base.foo, Sub.foo);
console.log(Base.foo === Sub.foo); // false
```

This pattern is neat with classes, but it also works with pre-ES6 JavaScript inheritance. This is important because Mongoose still uses pre-ES6 style inheritance. In hindsight we should have switched sooner, but this feature is the first time we've seen a clear advantage to using ES6 classes and inheritance over just setting a function's `prototype`.

```javascript
function Base() {}

Object.defineProperty(Base, 'foo', {
  get: function() { return this.hasOwnProperty('_foo') ? this._foo : void 0; },
  set: function(v) { this._foo = v; }
});

Base.foo = [];

// Pre-ES6 inheritance
function Sub1() {}
Sub1.prototype = Object.create(Base.prototype);
// Static properties were annoying pre-ES6
Object.defineProperty(Sub1, 'foo', Object.getOwnPropertyDescriptor(Base, 'foo'));

// ES6 inheritance
class Sub2 extends Base {}

// Prints "[] undefined"
console.log(Base.foo, Sub1.foo);
// Prints "[] undefined"
console.log(Base.foo, Sub2.foo);

Base.foo.push('foo');

// Prints "['foo'] undefined"
console.log(Base.foo, Sub1.foo);
// Prints "['foo'] undefined"
console.log(Base.foo, Sub2.foo);
```

## Moving On

ES6 classes have a major advantage over old school `Sub.prototype = Object.create(Base.prototype)` because `extends` copies over static properties and functions. With a little extra work using [`Object.hasOwnProperty()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/hasOwnProperty), you can create static getters and setters that handle inheritance correctly. Be very careful with static properties in JavaScript: `extends` still uses prototypical inheritance under the hood. That means static objects and arrays are shared between all subclasses unless you use the `hasOwnProperty()` pattern from this article.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
