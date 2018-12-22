> * 原文地址：[Static Properties in JavaScript Classes with Inheritance](http://thecodebarbarian.com/static-properties-in-javascript-with-inheritance.html)
> * 原文作者：[Valeri Karpov](http://www.twitter.com/code_barbarian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/static-properties-in-javascript-with-inheritance.md](https://github.com/xitu/gold-miner/blob/master/TODO1/static-properties-in-javascript-with-inheritance.md)
> * 译者：
> * 校对者：

# 继承 JavaScript 类中的静态属性

自 ES6 发布以来，JavaScript 对类和[静态函数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes/static)的支持类似其他面向对象语言中的静态函数。不幸的是，JavaScript 缺乏对静态属性的支持，而且[谷歌上的推荐方案](https://esdiscuss.org/topic/define-static-properties-and-prototype-properties-with-the-class-syntax)没有考虑到继承问题。在[实现一个 Mongoose 特性](https://github.com/Automattic/mongoose/issues/6912)的时候，我陷入了一个需要更健壮的静态属性概念的困难。尤其是我需要通过设置 `prototype` 或者 [`extends`](https://medium.com/beginners-guide-to-mobile-web-development/super-and-extends-in-javascript-es6-understanding-the-tough-parts-6120372d3420) 来支持继承静态属性。在本文，我将介绍在 ES6 中实现静态属性的模式。

## 静态方法和继承

假设你有一个带有静态方法的简单的符合 ES6 语法的类。

```javascript
class Base {
  static foo() {
    return 42;
  }
}
```

你可以使用 `extends` 创建一个子类并且能够继续使用 `foo()` 函数。

```javascript
class Sub extends Base {}

Sub.foo(); // 42
```

你可以使用[静态的 getter 和 setter](https://stackoverflow.com/questions/41426658/es6-how-to-access-a-static-getter-from-an-instance) 在 `Base` 类中设置一个静态的属性。

```javascript
let foo = 42;

class Base {
  static get foo() { return foo; }
  static set foo(v) { foo = v; }
}
```

不幸的是，在继承 `Base` 的时候，这个模式就行不通了。如果你设置子类 `foo` 的值，它将会覆盖 `Base` 和所有其他的子类的 `foo` 。

```javascript
class Sub extends Base {}

console.log(Base.foo, Sub.foo);

Sub.foo = 43;

// 打印 "43, 43"。 在上面会覆盖 “Base.foo” 和 “Sub.foo” 的值
console.log(Base.foo, Sub.foo);
```

如果属性是一个数组或者是对象这个问题会变得更糟。因为典型的继承，如果 `foo` 是一个数组，每一个子类都会有一个数组副本的引用，如下所示。

```javascript
class Base {
  static get foo() { return this._foo; }
  static set foo(v) { this._foo = v; }
}

Base.foo = [];

class Sub extends Base {}

console.log(Base.foo, Sub.foo);

Sub.foo.push('foo');

// 现在这两个数组都包含 “foo”，因为它们都是同一个数组
console.log(Base.foo, Sub.foo);
console.log(Base.foo === Sub.foo); // true
```

所以 JavaScript 支持静态的 getter 和 setter，但是在数组和对象的情况下使用它们将会是搬起石头砸自己脚。事实证明，你可以在 [JavaScript 内置的 `hasOwnProperty()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/hasOwnProperty) 函数的帮助实现它。

## 继承静态属性

关键思想是 JavaScript 类只是另一个对象，所以你可以区分 [本身的属性](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/getOwnPropertyNames) 和继承的属性。

```javascript
class Base {
  static get foo() {
    // 如果 “_foo” 被继承了，或者不存在的时候将它当做 “undefined”
    return this.hasOwnProperty('_foo') ? this._foo : void 0;
  }
  static set foo(v) { this._foo = v; }
}

Base.foo = [];

class Sub extends Base {}

// 打印 “[] undefined”
console.log(Base.foo, Sub.foo);
console.log(Base.foo === Sub.foo); // false

Base.foo.push('foo');

// 打印 “['foo'] undefined”
console.log(Base.foo, Sub.foo);
console.log(Base.foo === Sub.foo); // false
```

这个模式在类中的实现是很简洁，它也可以被用于 ES6 之前的 JavaScript 标准的继承。这一点很重要，因为 Mongoose 仍然使用 ES6 风格之前的继承。事后看来，我们本应该尽早使用这个方法，这个特性是我们第一次看到使用 ES6 类和继承比只设置函数的 `prototype` 有明显优势。

```javascript
function Base() {}

Object.defineProperty(Base, 'foo', {
  get: function() { return this.hasOwnProperty('_foo') ? this._foo : void 0; },
  set: function(v) { this._foo = v; }
});

Base.foo = [];

// ES6 之前版本的继承
function Sub1() {}
Sub1.prototype = Object.create(Base.prototype);
// Static properties were annoying pre-ES6
Object.defineProperty(Sub1, 'foo', Object.getOwnPropertyDescriptor(Base, 'foo'));

// ES6 的继承
class Sub2 extends Base {}

// 打印 “[] undefined”
console.log(Base.foo, Sub1.foo);
// 打印 “[] undefined”
console.log(Base.foo, Sub2.foo);

Base.foo.push('foo');

// 打印 “['foo'] undefined”
console.log(Base.foo, Sub1.foo);
// 打印 “['foo'] undefined”
console.log(Base.foo, Sub2.foo);
```

## 继续前进

ES6 类相对于老的 `Sub.prototype = Object.create(Base.prototype)` 有一个主要的优势，因为它 `extends` 了静态属性和函数的副本。使用 [`Object.hasOwnProperty()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/hasOwnProperty)  做一些额外的工作，就可以创建正确处理继承的静态 getter 和 setter。在 JavaScript 中使用静态属性要非常地小心：`extends` 在底层仍然使用典型的继承。这意味着，除非你使用本篇文章提到的 `hasOwnProperty()` 模式，否则静态的对象和数组在所有的子类中被共享。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
