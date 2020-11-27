> - 原文地址：[JavaScript Decorators From Scratch](https://blog.bitsrc.io/javascript-decorators-from-scratch-c4cfd6c33d70)
> - 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-decorators-from-scratch.md](https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-decorators-from-scratch.md)
> - 译者：[regon-cao](https://github.com/regon-cao)
> - 校对者：[zenblo](https://github.com/zenblo)

# 从零开始了解 JavaScript 装饰器

![Photo by [Manja Vitolic](https://unsplash.com/@madhatterzone?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*9zWhtS-gknJ6IVc3)

## 什么是装饰器?

装饰器只是一种用另一个函数包装一个函数以扩展其现有功能的函数。您可以使用另一段代码来“装饰”现有代码。对于那些熟悉函数组合或高阶函数的人来说，这个概念并不陌生。

装饰器并不是什么新鲜事物。它已经出现在 Python 等其他语言中，甚至在 JavaScript 函数式编程中。我们稍后再谈论这个话题。

## 为何使用装饰器?

装饰器让您可以编写更简洁的代码并实现组合。它还可以帮助您将相同的功能扩展到多个函数和类，从而使您能够编写出更容易调试和维护的代码。

装饰器还可以减少代码的相互干扰，因为它可以将所有增强特性的代码从核心函数中移除。它还使您能够在不增加代码复杂度的情况下添加新的特性。

在第 2 阶段的提案中，可能会有很多对类装饰器有用的提议。

## 函数装饰器

#### 什么是函数装饰器?

函数装饰器就是简单的函数。它们接收一个原函数作为参数，并返回另一个增强和扩展原函数参数的新函数。新函数不修改原函数参数，而是在它自己的函数体中使用原函数参数。这和之前提到的高阶函数非常相似。

#### 函数装饰器是如何工作的?

让我们通过一个示例来理解函数装饰器。

参数验证在编程中很常见。在 Java 之类的语言中，如果函数需要两个参数，而传递了三个参数，则会收到一个异常。但是在 JavaScript 中，您不会收到任何错误，因为多余的参数被直接忽略了。这种行为有时令人恼火，有时又很有用。

为了确保传递给函数的参数是有效的，我们可以在入口验证它们。这是一个简单的过程，您可以检查每个参数是否具有所需的数据类型，并确保参数的数量不超过所需的参数数量。

但是对几个函数重复相同的过程会导致代码重复。您可以简单地使用装饰器来帮助您进行验证，并在需要进行参数验证的地方复用它。

```JavaScript
//装饰器函数
const allArgsValid = function(fn) {
  return function(...args) {
  if (args.length != fn.length) {
      throw new Error('Only submit required number of params');
    }
    const validArgs = args.filter(arg => Number.isInteger(arg));
    if (validArgs.length < fn.length) {
      throw new TypeError('Argument cannot be a non-integer');
    }
    return fn(...args);
  }
}

//普通的乘法函数
let multiply = function(a,b){
	return a*b;
}

//装饰乘法函数，只接收指定数量的且为整数的参数
multiply = allArgsValid(multiply);

multiply(6, 8);
//48

multiply(6, 8, 7);
//Error: Only submit required number of params

multiply(3, null);
//TypeError: Argument cannot be a non-integer

multiply('',4);
//TypeError: Argument cannot be a non-integer
```

`allArgsValid` 是一个装饰器函数，它接收一个函数作为参数。这个装饰器函数返回另一个封装了函数参数的函数。而且，当传递进来的函数的参数是有效整数时它就会调用参数函数。否则，将抛出错误。它还检查传递的参数数量，并确保不会超过所需的参数个数。

随后，我们将一个将两个数字相乘的函数赋给一个名为 `multiply` 的变量。我们将这个乘法函数传递给 `allArgsValid`，并将返回的新函数再次赋值给 `multiply` 变量。这使得它在需要时更容易被重用。

```js
//普通加法函数
let add = function (a, b) {
  return a + b;
};

//装饰加法函数，只接收指定数量的且为整数的参数
add = allArgsValid(add);

add(6, 8);
//14

add(3, null);
//TypeError: Argument cannot be a non-integer

add("", 4);
//TypeError: Argument cannot be a non-integer
```

## TC39类装饰器提案

在 JavaScript 函数式编程领域，函数装饰器已经存在了很长时间。类装饰器的提案目前处在第 2 阶段。

JavaScript 类并不是真正的类，它们只是原型模式的语法糖。只是类语法让开发人员使用起来更简单方便些。

现在我们可以得出这样的结论：类就是简单的函数。您现在可能想知道，为什么我们不能简单地在类中使用函数装饰器呢?完全可以。

让我们通过一个示例来了解如何实现这一点。

```js
function log(fn) {
  return function () {
    console.log("Execution of " + fn.name);
    console.time("fn");
    let val = fn();
    console.timeEnd("fn");
    return val;
  };
}

class Book {
  constructor(name, ISBN) {
    this.name = name;
    this.ISBN = ISBN;
  }

  getBook() {
    return `[${this.name}][${this.ISBN}]`;
  }
}

let obj = new Book("HP", "1245-533552");
let getBook = log(obj.getBook);
console.log(getBook());
//TypeError: Cannot read property 'name' of undefined
```

上面错误的原因是当 `getBook` 方法被调用时，它实际上调用了 `log` 装饰器函数返回的匿名函数。在这个匿名函数中调用了 `obj.getBook`，但是匿名函数中的 `this` 值引用的是全局对象，而不是 book 对象。因此，我们得到了类型错误。

我们可以通过将 book 对象的实例传递给 `getBook` 方法来解决这个问题。

```js
function log(classObj, fn) {
  return function () {
    console.log("Execution of " + fn.name);
    console.time("fn");
    let val = fn.call(classObj);
    console.timeEnd("fn");
    return val;
  };
}

class Book {
  constructor(name, ISBN) {
    this.name = name;
    this.ISBN = ISBN;
  }

  getBook() {
    return `[${this.name}][${this.ISBN}]`;
  }
}

let obj = new Book("HP", "1245-533552");
let getBook = log(obj, obj.getBook);
console.log(getBook());
//[HP][1245-533552]
```

我们将 bookObj 传递给 log 装饰器函数，它将作为 `this` 传递给 `obj.getBook` 方法。

**这个方法可以解决问题, 但它像是一个替代方案。在新的提案中，通过装饰器语法可以更合理更高效的来解决我们的问题。**

> **注意 —— 运行下面的例子需要使用 Babel。在线尝试这些例子 Jsfiddle 是一个不错的选择。由于这些提案还没有最终定稿，您应该避免在生产环境中使用它们，因为未来可能会发生变化，而且目前的性能也并不完美。**

## 类装饰器

在新的提案中装饰器采用以 `@` 符号为前缀的特殊语法。我们将采用新的语法来调用 log 装饰器。

```
@log
```

在提案中的装饰器有了一些改动。当装饰器用在类上的时候，它会接收一个 target 参数，tagrget 是被装饰的类的对象实例。

由于能够访问 target 参数，您可以根据需要修改类的构造函数，添加新的原型属性等。

让我们看一下之前用过的 Book 的例子。

```js
function log(target) {
  return function (...args) {
    console.log("Constructor called");
    return new target(...args);
  };
}

@log
class Book {
  constructor(name, ISBN) {
    this.name = name;
    this.ISBN = ISBN;
  }

  getBook() {
    return `[${this.name}][${this.ISBN}]`;
  }
}

let obj = new Book("HP", "1245-533552");
//调用 Constructor
console.log(obj.getBook());
//HP][1245-533552]
```

如上所示，`log` 装饰器接收 `target` 参数并返回一个匿名函数，该函数执行 log 语句，创建并返回 Book 类的实例。您可以通过 `target.prototype.property` 在 `target` 添加新的原型属性。

您甚至可以在一个类上使用多个装饰器。

```js
function logWithParams(...params) {
  return function (target) {
    return function (...args) {
      console.table(params);
      return new target(...args);
    };
  };
}

@log
@logWithParams("param1", "param2")
class Book {
  //和之前一样的代码
}

let obj = new Book("HP", "1245-533552");
//调用 Constructor 
//参数被打印成 table
console.log(obj.getBook());
//[HP][1245-533552]
```

## 类属性装饰器

类属性装饰器和类装饰器语法差不多，都是采用 `“@”` 作为前缀。您也可以给装饰器传递参数作为类的属性。

#### 类方法装饰器

传递给类方法装饰器的参数与类装饰器的参数不同。类方法装饰器接收三个参数而不是一个参数。具体如下：

- Target — 一个包含类的构造函数和方法在内的对象。
- Name — 正在被调用的方法名称。
- Descriptor — 正在被调用的方法的描述对象。 你可以通过[这里](https://flaviocopes.com/javascript-property-descriptors/)了解更多的关于属性描述符的知识。

类方法的描述符对象有下面 4 个属性，大部分情况下操作它们就可以满足需求了。

- Configurable — 决定了属性描述符是否可修改，布尔值。
- Enumerable — 决定了对象枚举时是否可见，布尔值。
- Value — 属性的值。这里指向一个函数。
- Writable — 决定了属性是否可被重写，布尔值。

让我们再看一下 Book 类的例子。

```js
//只读装饰器函数
function readOnly(target, name, descriptor) {
  descriptor.writable = false;
  return descriptor;
}

class Book {
  //在这调用
  @readOnly
  getBook() {
    return `[${this.name}][${this.ISBN}]`;
  }
}

let obj = new Book("HP", "1245-533552");

obj.getBook = "Hello";

console.log(obj.getBook());
//[HP][1245-533552]
```

上面示例的 `readOnly` 装饰器，通过将描述符的 writable 属性设置为 `false` 来使 `Book` 类中的 `getBook` 方法为只读。此属性默认值为 `true`。

如果 writable 属性没有被操作，那么可以很容易地覆盖 getBook 属性，如下所示：

```js
obj.getBook = "Hello";

console.log(obj.getBook);
//Hello
```

#### 类字段装饰器

与类方法一样，类字段也可以被修饰。typescript 已经支持类字段，但它仍在 JavaScript 的第 3 阶段提案中。

类字段装饰器接收的参数和类方法装饰器是一样的，唯一的区别在于描述符对象。与类方法不同，描述符对象在类字段上使用时不包括 `value` 属性，而是被替换成了一个叫做 `initializer` 的函数。由于类字段仍然在提案阶段，你可以在[文档](https://github.com/tc39/proposal-class-fields#execution-of-initializer-expressions)中阅读更多关于 initializer 的信息。initializer 函数将返回类字段变量的初始值。

此外，当字段值未定义时，描述符对象的 `writable` 属性将不存在。

让我们看一个例子来进一步理解这一点。我们将再次使用我们的 `Book` 类。

```js
function upperCase(target, name, descriptor) {
  if (descriptor.initializer && descriptor.initializer()) {
    let val = descriptor.initializer();
    descriptor.initializer = function () {
      return val.toUpperCase();
    };
  }
}

class Book {
  @upperCase
  id = "az092b";

  getId() {
    return `${this.id}`;
  }

  //其他代码
}

let obj = new Book("HP", "1245-533552");

console.log(obj.getId());
//AZ092B
```

上面的示例将 `id` 属性的值转换为了大写。它使用 upperCase 装饰器，该函数检查 initializer 是否存在，以确保该值不是 `undefined`，再检查该值是否为真，然后将其转换为大写。调用 `getId` 方法可以看到大写的值。你也可以在类字段上使用装饰器时传递参数给它。

## 使用案例

装饰器的使用案例有很多。这里有几个在实际应用中的例子。

#### 在 Angular 中使用装饰器

如果有人熟悉 typescript 和 Angular，他们肯定会遇到 Angular 类中使用的装饰器。你会发现诸如 “@Component”，“@NgModule”，“@Injectable”，“@Pipe”等。这些内置的装饰器用来修饰类。

#### MobX

MobX 在版本 6 之前大力推崇和使用了 “@observable”，“@computed”，“@action”装饰器。由于提案没有被标准化的原因，MobX 目前不再鼓励使用装饰器了。文档申明如下：

> 但是，目前装饰器不是一个 ES 的标准,并且标准化过程会持续很长一段时间。另外装饰器标准的实现方式可能和之前的也不同。

#### Core Decorators JS

这个 JavaScript 库提供了现成的装饰器。尽管此库基于第 0 阶段的装饰器提案，但库的作者要等到第 3 阶段提案时才更新库。

这个库附带了诸如 “@readonly”、“@time”、“@deprecate” 等装饰器。你可以通过[这里](https://github.com/jayphelps/core-decorators)了解更多。

#### Redux Library in React

React 的 Redux 库包含一个 `connect` 方法，允许您将 React 组件连接到 Redux 仓库。该库还允许将 `connect` 方法用作装饰器。

```js
//使用装饰器之前
class MyApp extends React.Component {
  // ...定义您自己的应用
}
export default connect(mapStateToProps, mapDispatchToProps)(MyApp);

//使用装饰器之后
@connect(mapStateToProps, mapDispatchToProps)
export default class MyApp extends React.Component {
  // ...定义您自己的应用
}
```

Felix Kling 的 Stack Overflow 的[回答](https://stackoverflow.com/a/32675956) 解释了这一点。

此外，尽管 `connect` 支持装饰器语法，但 redux 团队并不鼓励这样做，主要是因为处于第 2 阶段提案的装饰器未来可能会变化。

---

总之，装饰器是一个可以让您编写出灵活代码的有力工具。在不久的将来您会经常遇到它。

感谢阅读，编码快乐！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
