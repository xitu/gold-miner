> * 原文地址：[Private Variables in JavaScript](https://marcusnoble.co.uk/2018-02-04-private-variables-in-javascript/)
> * 原文作者：[Marcus Noble](https://marcusnoble.co.uk/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/private-variables-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO/private-variables-in-javascript.md)
> * 译者：[Noah Gao](https://noahgao.net)
> * 校对者：[老教授](https://juejin.im/user/58ff449a61ff4b00667a745c) [ryouaki](https://github.com/ryouaki)

# JavaScript 中的私有变量

最近 JavaScript 有了很多改进，新的语法和功能一直在被增加进来。但有些东西并没有改变，一切仍然是对象，几乎所有东西都可以在运行时被改变，并且没有公共、私有属性的概念。但是我们自己可以用一些技巧来改变这种情况，在这篇文章中，我介绍各种可以实现私有变量的方式。

在 2015 年，JavaScript 有了 [类](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes) ，对于那些从 更传统的 C 语系语言（如 Java 和 C#）过来的程序员们，他们会更熟悉这种操作对象的方式。但是很明显，这些类不像你习惯的那样 -- 它的属性没有修饰符来控制访问，并且所有属性都需要在函数中定义。

那么我们如何才能保护那些不应该在运行时被改变的数据呢？我们来看看一些选项。

> 在整篇文章中，我将反复用到一个用于构建形状的示例类。它的宽度和高度只能在初始化时设置，提供一个属性来获取面积。有关这些示例中使用的 `get` 关键字的更多信息，请参阅我之前的文章 [Getters 和 Setters](https://marcusnoble.co.uk/2018-01-26-getters-and-setters-in-javascript)。

## 命名约定

第一个也是最成熟的方法是使用特定的命名约定来表示属性应该被视为私有。通常以下划线作为属性名称的前缀（例如 `_count` ）。这并没有真正阻止变量被访问或修改，而是依赖于开发者之间的相互理解，认为这个变量应该被视为限制访问。

``` javascript
class Shape {
  constructor(width, height) {
    this._width = width;
    this._height = height;
  }
  get area() {
    return this._width * this._height;
  }
}

const square = new Shape(10, 10);
console.log(square.area);    // 100
console.log(square._width);  // 10
```

## WeakMap

想要稍有一些限制性，您可以使用 WeakMap 来存储所有私有值。这仍然不会阻止对数据的访问，但它将私有值与用户可操作的对象分开。对于这种技术，我们将 WeakMap 的关键字设置为私有属性所属对象的实例，并且我们使用一个函数（我们称之为 `internal` ）来创建或返回一个对象，所有的属性将被存储在其中。这种技术的好处是在遍历属性时或者在执行 `JSON.stringify` 时不会展示出实例的私有属性，但它依赖于一个放在类外面的可以访问和操作的 WeakMap 变量。

```javascript
const map = new WeakMap();

// 创建一个在每个实例中存储私有变量的对象
const internal = obj => {
  if (!map.has(obj)) {
    map.set(obj, {});
  }
  return map.get(obj);
}

class Shape {
  constructor(width, height) {
    internal(this).width = width;
    internal(this).height = height;
  }
  get area() {
    return internal(this).width * internal(this).height;
  }
}

const square = new Shape(10, 10);
console.log(square.area);      // 100
console.log(map.get(square));  // { height: 100, width: 100 }
```

## Symbol

Symbol 的实现方式与 WeakMap 十分相近。在这里，我们可以使用 [Symbol](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol) 作为 key 的方式创建实例上的属性。这可以防止该属性在遍历或使用 `JSON.stringify` 时可见。不过这种技术需要为每个私有属性创建一个 Symbol。如果您在类外可以访问该 Symbol，那你还是可以拿到这个私有属性。

```javascript
const widthSymbol = Symbol('width');
const heightSymbol = Symbol('height');

class Shape {
  constructor(width, height) {
    this[widthSymbol] = width;
    this[heightSymbol] = height;
  }
  get area() {
    return this[widthSymbol] * this[heightSymbol];
  }
}

const square = new Shape(10, 10);
console.log(square.area);         // 100
console.log(square.widthSymbol);  // undefined
console.log(square[widthSymbol]); // 10
```

## 闭包

到目前为止所显示的所有技术仍然允许从类外访问私有属性，闭包为我们提供了一种解决方法。如果您愿意，可以将闭包与 WeakMap 或 Symbol 一起使用，但这种方法也可以与标准 JavaScript 对象一起使用。闭包背后的想法是将数据封装在调用时创建的函数作用域内，但是从内部返回函数的结果，从而使这一作用域无法从外部访问。

```javascript
function Shape() {
  // 私有变量集
  const this$ = {};

  class Shape {
    constructor(width, height) {
      this$.width = width;
      this$.height = height;
    }

    get area() {
      return this$.width * this$.height;
    }
  }

  return new Shape(...arguments);
}

const square = new Shape(10, 10);
console.log(square.area);  // 100
console.log(square.width); // undefined
```

这种技术存在一个小问题，我们现在存在两个不同的 `Shape` 对象。代码将调用外部的 `Shape` 并与之交互，但返回的实例将是内部的 `Shape`。这在大多数情况下可能不是什么大问题，但会导致 `square instanceof Shape` 表达式返回 `false`，这可能会成为代码中的问题所在。

解决这一问题的方法是将外部的 Shape 设置为返回实例的原型：

```javascript
return Object.setPrototypeOf(new Shape(...arguments), this);
```

不幸的是，这还不够，只更新这一行现在会将 `square.area` 视为未定义。这是由于 `get` 关键字在幕后工作的缘故。我们可以通过在构造函数中手动指定 getter 来解决这个问题。

```javascript
function Shape() {
  // 私有变量集
  const this$ = {};

  class Shape {
    constructor(width, height) {
      this$.width = width;
      this$.height = height;

      Object.defineProperty(this, 'area', {
        get: function() {
          return this$.width * this$.height;
        }
      });
    }
  }

  return Object.setPrototypeOf(new Shape(...arguments), this);
}

const square = new Shape(10, 10);
console.log(square.area);             // 100
console.log(square.width);            // undefined
console.log(square instanceof Shape); // true
```

或者，我们可以将 `this` 设置为实例原型的原型，这样我们就可以同时使用 `instanceof` 和 `get`。在下面的例子中，我们有一个原型链 `Object -> 外部的 Shape -> 内部的 Shape 原型 -> 内部的 Shape`。

```javascript
function Shape() {
  // 私有变量集
  const this$ = {};

  class Shape {
    constructor(width, height) {
      this$.width = width;
      this$.height = height;
    }

    get area() {
      return this$.width * this$.height;
    }
  }

  const instance = new Shape(...arguments);
  Object.setPrototypeOf(Object.getPrototypeOf(instance), this);
  return instance;
}

const square = new Shape(10, 10);
console.log(square.area);             // 100
console.log(square.width);            // undefined
console.log(square instanceof Shape); // true
```

## Proxy

[Proxy](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy) 是 JavaScript 中一项美妙的新功能，它将允许你有效地将对象包装在名为 Proxy 的对象中，并拦截与该对象的所有交互。我们将使用 Proxy 并遵照上面的 `命名约定` 来创建私有变量，但可以让这些私有变量在类外部访问受限。

Proxy 可以拦截许多不同类型的交互，但我们要关注的是 [`get`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/get) 和 [`set`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/set)，Proxy 允许我们分别拦截对一个属性的读取和写入操作。创建 Proxy 时，你将提供两个参数，第一个是您打算包裹的实例，第二个是您定义的希望拦截不同方法的 “处理器” 对象。

我们的处理器将会看起来像是这样：

```javascript
const handler = {
  get: function(target, key) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    }
    return target[key];
  },
  set: function(target, key, value) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    }
    target[key] = value;
  }
};
```

在每种情况下，我们都会检查被访问的属性的名称是否以下划线开头，如果是的话我们就抛出一个错误从而阻止对它的访问。

```javascript
class Shape {
  constructor(width, height) {
    this._width = width;
    this._height = height;
  }
  get area() {
    return this._width * this._height;
  }
}

const handler = {
  get: function(target, key) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    }
    return target[key];
  },
  set: function(target, key, value) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    }
    target[key] = value;
  }
}

const square = new Proxy(new Shape(10, 10), handler);
console.log(square.area);             // 100
console.log(square instanceof Shape); // true
square._width = 200;                  // 错误：试图访问私有属性
```

正如你在这个例子中看到的那样，我们保留使用 `instanceof` 的能力，也就不会出现一些意想不到的结果。

不幸的是，当我们尝试执行 `JSON.stringify` 时会出现问题，因为它试图对私有属性进行格式化。为了解决这个问题，我们需要重写 `toJSON` 函数来仅返回“公共的”属性。我们可以通过更新我们的 get 处理器来处理 `toJSON` 的特定情况：

> 注：这将覆盖任何自定义的 `toJSON` 函数。

```javascript
get: function(target, key) {
  if (key[0] === '_') {
    throw new Error('Attempt to access private property');
  } else if (key === 'toJSON') {
    const obj = {};
    for (const key in target) {
      if (key[0] !== '_') {           // 只复制公共属性
        obj[key] = target[key];
      }
    }
    return () => obj;
  }
  return target[key];
}
```

我们现在已经封闭了我们的私有属性，而预计的功能仍然存在，唯一的警告是我们的私有属性仍然可被遍历。`for(const key in square)` 会列出 `_width` 和 `_height`。谢天谢地，这里也提供一个处理器！我们也可以拦截对 `getOwnPropertyDescriptor` 的调用并操作我们的私有属性的输出：

```javascript
getOwnPropertyDescriptor(target, key) {
  const desc = Object.getOwnPropertyDescriptor(target, key);
  if (key[0] === '_') {
    desc.enumerable = false;
  }
  return desc;
}
```

现在我们把所有特性都放在一起：

```javascript
class Shape {
  constructor(width, height) {
    this._width = width;
    this._height = height;
  }
  get area() {
    return this._width * this._height;
  }
}

const handler = {
  get: function(target, key) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    } else if (key === 'toJSON') {
      const obj = {};
      for (const key in target) {
        if (key[0] !== '_') {
          obj[key] = target[key];
        }
      }
      return () => obj;
    }
    return target[key];
  },
  set: function(target, key, value) {
    if (key[0] === '_') {
      throw new Error('Attempt to access private property');
    }
    target[key] = value;
  },
  getOwnPropertyDescriptor(target, key) {
    const desc = Object.getOwnPropertyDescriptor(target, key);
    if (key[0] === '_') {
      desc.enumerable = false;
    }
    return desc;
  }
}

const square = new Proxy(new Shape(10, 10), handler);
console.log(square.area);             // 100
console.log(square instanceof Shape); // true
console.log(JSON.stringify(square));  // "{}"
for (const key in square) {           // No output
  console.log(key);
}
square._width = 200;                  // 错误：试图访问私有属性
```

Proxy 是现阶段我在 JavaScript 中最喜欢的用于创建私有属性的方法。这种类是以老派 JS 开发人员熟悉的方式构建的，因此可以通过将它们包装在相同的 Proxy 处理器来兼容旧的现有代码。

## 附： TypeScript 中的处理方式

[TypeScript](https://www.typescriptlang.org/) 是 JavaScript 的一个超集，它会编译为原生 JavaScript 用在生产环境。允许指定私有的、公共的或受保护的属性是 TypeScript 的特性之一。

```javascript
class Shape {
  private width;
  private height;

  constructor(width, height) {
    this.width = width;
    this.height = height;
  }

  get area() {
    return this.width * this.height;
  }
}
const square = new Shape(10, 10)
console.log(square.area); // 100
```

使用 TypeScript 需要注意的重要一点是，它只有在 **编译** 时才获知这些类型，而私有、公共修饰符在编译时才有效果。如果你尝试访问 `square.width`，你会发现，居然是可以的。只不过 TypeScript 会在编译时给你报出一个错误，但不会停止它的编译。

```javascript
// 编译时错误：属性 ‘width’ 是私有的，只能在 ‘Shape’ 类中访问。
console.log(square.width); // 10
```

TypeScript 不会自作聪明，不会做任何的事情来尝试阻止代码在运行时访问私有属性。我只把它列在这里，也是让大家意识到它并不能直接解决问题。你可以 [自己观察一下](https://www.typescriptlang.org/play/index.html#src=class%20Shape%20%7B%0D%0A%20%20private%20width%3B%0D%0A%20%20private%20height%3B%0D%0A%0D%0A%20%20constructor(width%2C%20height)%20%7B%0D%0A%20%20%20%20this.width%20%3D%20width%3B%0D%0A%20%20%20%20this.height%20%3D%20height%3B%0D%0A%20%20%7D%0D%0A%0D%0A%20%20get%20area()%20%7B%0D%0A%20%20%20%20return%20this.width%20*%20this.height%3B%0D%0A%20%20%7D%0D%0A%7D%0D%0A%0D%0Aconst%20square%20%3D%20new%20Shape(10%2C%2010)%0D%0Aconsole.log(square.area)%3B%20%20%2F%2F%20100%0D%0Aconsole.log(square.width)%3B%20%2F%2F10) 由上面的 TypeScript 创建出的 JavaScript 代码。

## 未来

我已经向大家介绍了现在可以使用的方法，但未来呢？事实上，未来看起来很有趣。目前有一个提案，向 JavaScript 的类中引入 [private fields](https://github.com/tc39/proposal-class-fields#private-fields)，它使用 `＃` 符号表示它是私有的。它的使用方式与命名约定技术非常类似，但对变量访问提供了实际的限制。

```javascript
class Shape {
  #height;
  #width;

  constructor(width, height) {
    this.#width = width;
    this.#height = height;
  }

  get area() {
    return this.#width * this.#height;
  }
}

const square = new Shape(10, 10);
console.log(square.area);             // 100
console.log(square instanceof Shape); // true
console.log(square.#width);           // 错误：私有属性只能在类中访问
```

如果你对此感兴趣，可以阅读以下 [完整的提案](https://tc39.github.io/proposal-class-fields/) 来得到更接近事实真相的细节。我觉得有趣的一点是，私有属性需要预先定义，不能临时创建或销毁。对我来说，这在 JavaScript 中感觉像是一个非常陌生的概念，所以看看这个提案如何继续发展将变得非常有趣。目前，这一提案更侧重于私有的类属性，而不是私有函数或对象层面的私有成员，这些可能会晚一些出炉。

## NPM 包 -- Privatise

在写这篇文章时，我还发布了一个 NPM 包来帮助创建私有属性 -- [privatise](https://www.npmjs.com/package/@averagemarcus/privatise)。我使用了上面介绍的 Proxy 方法，并增加额外的处理器以允许传入类本身而不是实例。所有代码都可以在 GitHub 上找到，欢迎大家提出任何 PR 或 Issue。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
