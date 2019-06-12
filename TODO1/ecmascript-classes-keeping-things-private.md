> * 原文地址：[ECMAScript Classes - Keeping Things Private](https://devinduct.com/blogpost/23/ecmascript-classes-keeping-things-private)
> * 原文作者：[Milos Protic](https://devinduct.com/blogpost/23/ecmascript-classes-keeping-things-private)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ecmascript-classes-keeping-things-private.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ecmascript-classes-keeping-things-private.md)
> * 译者：[ZavierTang](https://github.com/ZavierTang)
> * 校对者：[Xuyuey](https://github.com/Xuyuey), [lgh757079506](https://github.com/lgh757079506)

# ECMAScript 类 —— 定义私有属性

## 介绍

像往常一样，我们将从一些理论知识开始介绍。ES 的类是 JavaScript 中新的语法糖。它提供了一种简洁的编写方法，并且实现了与我们使用原型链相同的功能。唯一的区别是，它看起来更像是面向对象编程了，而且，如果你是 C# 或 Java 开发者，感觉会更友好。有人可能会说它们不适合 JavaScript，但对我来说，使用类或 ES5 的原型都没有问题。

它提供了一种更简单的方式来封装和定义多个属性，这些属性可以在具体的实例对象上被访问到。事实上，我们可以通过类的方式编写更少的代码来实现更多的功能。有了类，JavaScript 正朝着面向对象的方式发展，通过使用类，我们可以实现面向对象编程，而不是函数式编程。不要误解我的意思，函数式编程并不是一件坏事，实际上，这是一件好事，它也有一些优于类的好处，但这应该是另一篇文章要讨论的主题。

举一个实际的例子，每当我们想在应用程序中定义来自真实世界的事物时，我们都会使用一个类来描述它。例如，building、car、motorcycle……它们代表一类真实的事物。

## 可访问范围

在后端语言中，我们有访问修饰符或可见性级别，如 `public`、`private`、`protected`、`internal`、`package`……不幸的是，JavaScript 仅以自己的方式支持前两种方法。它不通过编写访问修饰符（`public` 或 `private`）来声明字段，JavaScript 在某种程度上假定所有的区域都是公共的，这就是我写这篇文章的原因。

注意，我们有一种方法可以在类上声明私有和公共的字段，但是这些字段声明方法还是实验性的特性，因此还不能安全的使用它。

```js
class SimCard {
  number; // public field
  type; // public field
  #pinCode; // private field
}
```

> **如果没有像 Babel 这样的编译器，就不支持使用上面这样的字段声明方式。**

## 定义私有属性 —— 封装

封装是编程中的一个术语，比如它用来描述某个变量是受保护的或对外部是不可见的。为了保持数据私有并且只对内部可见，我们需要**封装**它。在本文中，我们将使用几种不同的方法来封装私有数据。让我们开始吧。

### 1. 习惯约定

这种方式只是假定数据或变量的 `private` 状态。实际上，它们是公开的，外部可以访问。我了解到的两种最常见的定义私有状态的习惯约定是 `$` 和 `_` 前缀。如果某个变量以这些符号作为前缀（通常在整个应用中会规定使用某一个)，那么该变量应该作为非公共属性来处理。

```js
class SimCard {
  constructor(number, type, pinCode) {
    this.number = number;
    this.type = type;
    
    // 这个属性被定义为私有的
    this._pinCode = pinCode;
  }
}

const card = new SimCard("444-555-666", "Micro SIM", 1515);

// 这里，我们将访问私有的 _pinCode 属性，这并不是我们预期的行为
console.log(card._pinCode); // 输出 1515
```

### 2. 闭包

闭包对于控制变量的可访问性非常有用。它被 JavaScript 开发者使用了几十年。这种方法为我们提供了真正的私有性，数据对外部来说是无法访问的，它只能被内部访问。这里我们要做的是在类构造函数中创建局部变量，并用闭包捕获它们。要实现这个效果，方法必须定义在实例上，而不是在原型链上。

```js
class SimCard {
  constructor(number, type, pinCode) {
    this.number = number;
    this.type = type;

    let _pinCode = pinCode;
    // 这个属性被定义为私有的
    this.getPinCode = () => {
        return _pinCode;
    };
  }
}

const card = new SimCard("444-555-666", "Nano SIM", 1515);
console.log(card._pinCode); // 输出 undefined
console.log(card.getPinCode()); // 输出 1515
```

### 3. Symbols 和 Getters

Symbol 是 JavaScript 中一种新的基本数据类型。它是在 ECMAScript 6 中引入的。`Symbol()` 返回的每个值都是唯一的，这种类型的主要目的是用作对象属性的标识符。

由于我们的意图是在类定义的外部创建 Symbol 变量，但也不是全局的，所以引入了模块。这样，我们能够在模块内部创建私有字段，将它们定义到类的构造函数中，并通过 `getter` 返回 Symbol 变量对应的值。注意，我们可以使用在原型链上创建的方法来代替 `getter`。我选择了 `getter` 方法，因为这样我们就不需要调用函数来获取值了。

```js
const SimCard = (() => {
  const _pinCode = Symbol('PinCode');

  class SimCard {
    constructor(number, type, pinCode) {
      this.number = number;
      this.type = type;
      this[_pinCode] = pinCode;
    }

    get pinCode() {
       return this[_pinCode];
    }
  }
  
  return SimCard;
})();

const card = new SimCard("444-555-666", "Nano SIM", 1515);
console.log(card._pinCode); // 输出 undefined
console.log(card.pinCode); // 输出 1515
```

这里需要指出的一点是 `Object.getOwnPropertySymbols` 方法，此方法可用于访问我们用来保存私有属性的 Symbol 变量。上面的类中的 `_pinCode` 值就可以这样被获取到:

```js
const card = new SimCard("444-555-666", "Nano SIM", 1515);
console.log(card[Object.getOwnPropertySymbols(card)[0]]); // 输出 1515

```

### 4. Map 和 Getters

ECMAScript 6 还引入了 `Map` 和 `WeakMap`。它们以键值对的形式存储数据，这使得它们非常适合存储我们的私有变量。在我们的示例中，`Map` 被定义在模块的内部，并且在类的构造函数中设置每个私有属性的键值。这个值被类的 `getter` 引用，同样，我们不需要调用函数来获取值。另外，请注意，考虑到 `Map` 本身的结构，我们不需要为每个私有属性定义 `Map` 映射。

```js
const SimCard = (() => {
  const _privates = new Map();

  class SimCard {
    constructor(number, type, pinCode, pukCode) {
      this.number = number;
      this.type = type;
      _privates.set('pinCode', pinCode);
      _privates.set('pukCode', pukCode);
    }

    get pinCode() {
       return _privates.get('pinCode');
    }

    get pukCode() {
       return _privates.get('pukCode');
    }
  }
  
  return SimCard;
})();

const card = new SimCard("444-555-666", "Nano SIM", 1515, 45874589);
console.log(card.pinCode); // 输出 1515
console.log(card.pukCode); // 输出 45874589
console.log(card._privates); // 输出 undefined
```

注意，在这种方法中，我们也可以使用普通对象而不是 `Map`，并在构造函数中动态地为其分配值。

## 总结和进一步阅读

希望这些示例对你会有帮助，并且能够用到你的工作中。如果是的话，并且你也喜欢这篇文章，那欢迎分享。这里我只实现了 Twitter 的分享按钮，（哈哈）但我也正在实现其他的方式。

如果要进一步阅读，我推荐一篇文章：[JavaScript Clean Code - Best Practices](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-clean-code-best-practices.md)

感谢你的阅读，下一篇文章再见。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
