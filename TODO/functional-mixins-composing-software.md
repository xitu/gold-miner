> * 原文地址：[Functional Mixins](https://medium.com/javascript-scene/functional-mixins-composing-software-ffb66d5e731c)
> * 原文作者：本文已获原作者 [Eric Elliott](https://medium.com/@_ericelliott) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[Tina92](https://github.com/Tina92) [reid3290](https://github.com/reid3290)

---

# 函数式 Mixin（软件编写）（第七部分）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg">

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0) （译注：该图是用 PS 将烟雾处理成方块状后得到的效果，参见 [flickr](https://www.flickr.com/photos/68397968@N07/11432696204)。））

> 注意：这是 “软件编写” 系列文章的第七部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科
> [< 上一篇](https://github.com/xitu/gold-miner/blob/master/TODO/functors-categories.md) | [<< 返回第一篇](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md) | [下一篇 >](https://github.com/xitu/gold-miner/blob/master/TODO/javascript-factory-functions-with-es6.md)

**函数式 Mixins** 是通过管道（pipeline）连接起来的、可组合的工厂函数。每一个工厂函数就类似于流水线上的工人，负责为原始对象添加一个额外的属性或者行为。函数式 Mixin 不依赖一个基础工厂函数或者构造函数，我们仅仅需要向 Mixin 管道入口塞入任意一个对象，在管道出口就能获得该对象的增强版本。

函数式 Mixin 有这么一些特点：

- 可以实现数据私有（通过闭包）。
- 可以继承私有状态。
- 可以实现多继承。
- 不存在[菱形问题](https://www.wikiwand.com/en/Multiple_inheritance#/The_diamond_problem)，在 JavaScript 实现的函数式 Mixin 中，有这么一个原则 -- 后进有效（last in wins）。
- 不需要基类。

### 动机

现如今的软件开发都是在做组合工作：我们将大型的、复杂的问题，划分成多个小的、简单的问题，对各个小问题的解决最终就构成了我们的应用。

组合有下面这两个基本元素：

- 函数
- 数据结构

这些基本元素组成了应用结构。通常，复合对象（composite objects）是通过类继承（某个类从父类继承了许多功能，再通过扩展或者重载来增强自身）产生的。类继承的问题在于，它描述的是一个 **is-a** 的思考，例如，“一个管理员也是一个员工”，这种思考方式会造成很多的设计问题：

- **紧耦合问题**：由于子类依赖于父类的实现，在面向对象设计中，类继承无法避免的产生了最紧耦合。
- **基类的脆弱问题**：由于紧耦合的存在，对基类的更改可能会破坏大量的子类-甚至潜在改变由第三方管理的代码。作者可能在不知情的状态下破坏了代码。
- **不够灵活的继承层次问题**：由于各个类都是由一个祖先分类演化开来，久而久之，对于新的用例，我们将难以确定其类别。（译注：比如绿色卡车这个类应当继承自卡车类，还是继承自绿色类？）
- **不得已的复制问题**：由于不够灵活的继承层次，新的用例通常都是通过复制实现的，而不是扩展，这就造成了相似类之间可能存在歧义。一旦出现了复制问题，那么新的类该从哪个类继承，为什么要从这个类继承，都变得模棱两可了。
- **猩猩和香蕉问题**：“面向对象的问题在于解决问题时不得不构建一整个隐性环境。这好比你只想要一只香蕉，但最终拿到的确是拿着猩猩的香蕉和整个丛林。” ~ Joe Armstrong 在其著作 [Coders at Work](http://www.amazon.com/gp/product/1430219483?ie=UTF8&amp;camp=213733&amp;creative=393185&amp;creativeASIN=1430219483&amp;linkCode=shr&amp;tag=eejs-20&amp;linkId=3MNWRRZU3C4Q4BDN) 中这样描述面向对象。

在 “认为一个管理员是一个员工”（is-a） 的思维模式下，你如何通过类继承实现这么一个场景：雇佣一个外部顾问来临时执行一些管理性质的工作。如果你提前就知道这个场景面临的种种需求，也许类继承可以工作良好，但至少我个人从未见过谁能对此了若指掌。随着应用规模的膨胀，更有效的功能扩展方式也渐渐出现。

Mixin 横空出世，提供了类继承所不能及的灵活性。

### 什么是 Mixin ？

> **“优先考虑对象组合而不是类继承”** 这句话出自 “四人帮（the Gang of Four，GoF）” 的著作 [**Design Patterns: Elements of Reusable Object Oriented Software**](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612/ref=as_li_ss_tl?ie=UTF8&amp;qid=1494993475&amp;sr=8-1&amp;keywords=design+patterns&amp;linkCode=ll1&amp;tag=eejs-20&amp;linkId=6c553f16325f3939e5abadd4ee04e8b4)

Mixin 是一个**对象组合**的形式，某个组件特性将被混入（mixin）到复合对象中，这样，每个 Mixin 的特性也能变成这个复合对象的特性。

“mixins” 这个术语在面向对象程序设计中是来自于出售自助口味冰淇淋的甜品店。在这样的冰淇淋店中，你买不到一个多种口味的冰淇淋，你只能买到一个原味冰淇淋，然后根据自己的口味，添加其他风味的酱料。

对象的 Mixin 过程与之类似：一开始，你只有一个空对象，通过不断混入新的特性来扩展这个对象。由于 JavaScript 支持动态对象扩展（译注：`obj.newProp = xxx`），并且对象不依赖于类，因此，在 JavaScript 中进行 Mixin 将无比简单，这也让 Mixin 成为了 JavaScript 最常用的继承方式。下面这个例子展示了我们如何获得一个多味冰淇淋：

```js
const chocolate = {
  hasChocolate: () => true
};

const caramelSwirl = {
  hasCaramelSwirl: () => true
};

const pecans = {
  hasPecans: () => true
};

const iceCream = Object.assign({}, chocolate, caramelSwirl, pecans);

/*
// 如果你所采用的环境支持解构赋值，也可以这么做：
const iceCream = {...chocolate, ...caramelSwirl, ...pecans};
*/

console.log(`
  hasChocolate: ${ iceCream.hasChocolate() }
  hasCaramelSwirl: ${ iceCream.hasCaramelSwirl() }
  hasPecans: ${ iceCream.hasPecans() }
`);
```

程序输出如下：

```
hasChocolate: true
hasCaramelSwirl: true
hasPecans: true
```

### 什么是函数式继承 ？

使用函数式继承（Functional Inheritance）来增加对象特性的方式是，将一个增强函数（augmenting function）直接应用到对象实例上。函数能通过闭包来实现数据私有，增强函数使用动态对象扩展来为对象增加新的属性或者方法。

让我们看一下 Douglas Crackford 给出的函数式继承的例子：

```js
// 基础对象工厂
function base(spec) {
    var that = {}; // 创建一个空对象
    that.name = spec.name; // 为对象增加一个 “name” 属性
    return that; // 生产完毕，返回该对象
}

// 构造一个子对象，该对象产生（继承）自基础对象工厂
function child(spec) {
    // 通过 “基础” 构造函数来创建对象
    var that = base(spec);
    // 通过增强函数来动态扩展对象
    that.sayHello = function() {
        return 'Hello, I\'m ' + that.name;
    };
    return that; // 返回该对象
}

// Usage
var result = child({ name: 'a functional object' });
console.log(result.sayHello()); // "Hello, I'm a functional object"
```

由于 `child()` 紧耦合于 `base()`，当我们创建更多的子孙对象 `grandchild()`、`greateGrandChild()` 时，就不得不面临类继承所面临的问题。

### 什么是函数式 Mixin ？

使用函数式 Mixin 扩展对象依赖于一些可组合的函数，这些函数能够将新的特性混入到指定对象上。新的属性或者行为来自于指定的对象。函数式的 Mixin 不依赖于基础对象构造工厂，传递任意一个对象，经过混入，就能得的扩展后的对象。

我们看到下面的一个例子，`flying()` 将能够为对象添加飞行的能力：

```js
// flying 是一个可组合的函数
const flying = o => {
  let isFlying = false;

  return Object.assign({}, o, {
    fly () {
      isFlying = true;
      return this;
    },

    isFlying: () => isFlying,

    land () {
      isFlying = false;
      return this;
    }
  });
};

const bird = flying({});
console.log( bird.isFlying() ); // false
console.log( bird.fly().isFlying() ); // true
```

注意到，当我们调用 `flying()` 方法时，我们需要将待扩展的对象传入，函数式 Mixin 是服务于函数组合的。我们再创建一个喊叫 Mixin，当我们传递一个喊叫函数 `quack`，`quacking()` 这个 Mixin 就能为对象添加喊叫的能力：

```js
const quacking = quack => o => Object.assign({}, o, {
  quack: () => quack
});

const quacker = quacking('Quack!')({});
console.log( quacker.quack() ); // 'Quack!'
```

### 对函数式 Mixin 进行组合

函数式 Mixin 可以通过一个简单的组合函数进行组合。现在，对象具备了飞行和喊叫的能力：

```js
const createDuck = quack => quacking(quack)(flying({}));

const duck = createDuck('Quack!');

console.log(duck.fly().quack());
```

这段代码可能不是那么易读，并且，也不容易 debug 或者改变组合顺序。

这是一个标准的函数组合方式，在前面的章节中，我们知道，更优雅的组合方式是 `composing()` 或者 `pipe()`。如果我们使用 `pipe()` 方法来反转函数的组合顺序，那么组合能够被读成 `Object.assign({}, ...)` 或者 `{...object, ...spread}`，这保证了 mixin 的顺序是按照声明顺序的。如果出现了属性冲突，那么按照**后进有效**的原则处理。

```js
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);
// 如果不想用自定义的 `pipe()`
// 可以 import pipe from `lodash/fp/flow`

const createDuck = quack => pipe(
  flying,
  quacking(quack)
)({});

const duck = createDuck('Quack!');

console.log(duck.fly().quack());
```

### 什么时候使用函数式 Mixin ？

你应该尽可能使用最简单的抽象来解决问题。首先被你考虑的应该是最简单的纯函数。如果对象需要维持一个持续的状态，那么考虑使用工厂函数。如果需要构建更加复杂的对象，再考虑使用函数式 Mixin。

下面列举了一些函数式 Mixin 的适用场景：

- 应用状态管理，例如 Redux store。
- 特定的横切关注点或者服务（cross-cutting concerns and services），例如一个集中的日志管理。
- 具有生命周期钩子的 UI 组件。
- 可组合的数据类型，例如，JavaScript 的 `Array` 类型通过 Mixin 实现 `Semigroup`、`Functor`、`Foldable` 等。

一些代数结构可能派生于另一些代数结构，这意味着某个特定的派生能够组合成新的数据类型，而不需要重新自定义实现。

### 注意了

大多数问题通过纯函数就解决了，但函数式 Mixin 却并非如此。类似于类继承，函数式 Mixin 也有其自身的一些问题，甚至于，它可能重现类继承所面临的问题。

你可以采纳下面这些建议来规避这个问题：

- 在必须的情况下，按照从左到右的顺序考虑实现方式：纯函数 > 工厂函数 > 函数式 Mixin > 类。
- 避免使用 “is-a” 关系来组织对象、Mixin 以及数据类型。
- 避免 Mixin 间的隐式依赖，无论如何，函数式 Mixin 都不应该自我维护状态，也不需要其他的 Mixin。（译注：后文会解释什么叫做隐式依赖）。
- “函数式 Mixin” 不意味着 “函数式编程”。

### 类

类继承几乎（甚至可以说是从来）不是 JavaScript 中扩展功能的最佳途径，但不一定所有人都这么想，因此你无法控制一些第三方库或者框架去使用类和类继承。在这种情况下，对于使用了 `class` 关键字的库或者框架来说，需要做到：

1. 不要求你（指使用这些库或框架的开发者）使用它们的类来扩展自己的类（不要求你去构建一个多层次的类层级）。
2. 不要求你直接使用 `new` 关键字，换言之，由框架去负责对象实例化过程。

Angular 2+ 和 React 都满足了这些要求，所以只要你不扩展自己的类，你就大可放心的使用它们。React 允许你不使用类来构建组件，但是你的组件可能因此丧失掉一些 React 中一些基类所提供的优化措施，并且，你的组件可能也无法像文档范例中描述的那样去工作。即便如此，在使用 React 的任何时候，你都应当优先考虑使用函数形式来构建组件。

#### 类的性能

在一些浏览器中，类可能带来了某些 JavaScript 引擎的优化。但是，在绝大多数场景中，这些优化不会对你的应用性能产生明显的提高。实际上，多年以来，人们都不需要担心使用 `class` 带来的性能差异。无论你怎么构建对象，对象的创建和属性访问已经够快了（每秒上百万的 ops）。

当然，这倒不是说 RxJS、Lodash 的作者们可以不去看看使用 `class` 能为创建对象带来多大的性能提升。而是说除非你在减少使用 `class` 的过程中遭遇了严重的性能瓶颈，否则你的优化都更应当着眼于构建整洁、灵活的代码，而不是去担心不用类丢掉的性能。

### 隐式依赖

你可能对怎么创建函数式 Mixin，并让他们协同工作饶有兴趣。想象你现在要为你的应用构建一个配置管理器，这个管理器能为应用生成配置，并且，当代码试图访问不存在的配置时，还能进行警告。

可能你会这样实现:

```js
// 日志 Mxin
const withLogging = logger => o => Object.assign({}, o, {
  log (text) {
    logger(text)
  }
});

// 在配置 Mixin 中，没有显式地依赖日志 Mixin：withLogging
const withConfig = config => (o = {
  log: (text = '') => console.log(text)
}) => Object.assign({}, o, {
  get (key) {
    return config[key] == undefined ?

      // vvv 这里出现了隐式依赖 vvv
      this.log(`Missing config key: ${ key }`) :
      // ^^^ 这里出现了隐式依赖 ^^^

      config[key]
    ;
  }
});

// 由于依赖隐藏，另一个模块需要引入 withLogging 及 withConfig
const createConfig = ({ initialConfig, logger }) =>
  pipe(
    withLogging(logger),
    withConfig(initialConfig)
  )({})
;

// elsewhere...
const initialConfig = {
  host: 'localhost'
};

const logger = console.log.bind(console);

const config = createConfig({initialConfig, logger});

console.log(config.get('host')); // 'localhost'
config.get('notThere'); // 'Missing config key: notThere'
```

译注：在这种实现中，`withConfig` 这个 Mixin 在为对象 `o` 添加功能时，依赖了对象 `o` 的 `log` 方法，因此，需要保证 `o` 具备 `log` 方法。

也可能你会这样实现：

```js
import withLogging from './with-logging';

const addConfig = config => o => Object.assign({}, o, {
  get (key) {
    return config[key] == undefined ?
      this.log(`Missing config key: ${ key }`) :
      config[key]
    ;
  }
});

const withConfig = ({ initialConfig, logger }) => o =>
  pipe(

    // vvv 在此组合显式依赖 vvv
    withLogging(logger),
    // ^^^ 在此组合显式依赖 ^^^

    addConfig(initialConfig)
  )(o)
;

// 配置工厂现在只需要知道 withConfig
const createConfig = ({ initialConfig, logger }) =>
  withConfig({ initialConfig, logger })({})
;

const initialConfig = {
  host: 'localhost'
};

const logger = console.log.bind(console);

const config = createConfig({initialConfig, logger});

console.log(config.get('host')); // 'localhost'
config.get('notThere'); // 'Missing config key: notThere'
```

译注：在这个实现中，`withConfig` 显式依赖了 `withLogging`，因此，不用保证 `o` 具有 `log` 方法，`withLogging` 能够为 `o` 提供 `log` 能力。

选择哪种实现，是取决于多个方面的。使用提升后的数据类型来使得函数式 Mixin 工作是可行的，但如果是这样的话，在函数签名和 API 文档中，API 约定需要设计的足够清晰。

这也就是为什么在隐式依赖的版本中，会为 `o` 设置默认值。由于 JavaScript 缺乏类型声明的能力，我们只能通过默认值来保障类型正确：

```js
const withConfig = config => (o = {
  log: (text = '') => console.log(text)
}) => Object.assign({}, o, {
  // ...
})
```

如果你使用 TypeScript 或者 Flow，更好的方式是为对象需求声明一个显式接口。

### 函数式 Mixin 与 函数式编程

贯穿函数式 Mixin 的“函数式”不意味着这种 Mixin 具备“函数式编程”提倡的函数纯度。实际上函数式 Mixin 通常都是面向对象风格的，并且充斥着副作用。许多函数式 Mixin 都会改变你传入的对象，这个你务必注意。

话说回来，一些开发者可能更偏爱函数式编程风格，因此，也就不会为传入对象维护一个引用标识。在撰写 Mixin 时，你要假定使用这些 Mixin 的代码风格不只是函数式的，也可能是面向对象的，甚至是各种风格杂糅在一起的。

这意味着如果你需要返回对象实例，那么就返回 `this` 而不是闭包中的对象实例引用。在函数式编码风格下，闭包中的对象实例引用可能反映的不是用一个对象。译注：在下面这段代码中，`fly()` 返回了 `this` 而不是闭包中保存的 `o`：

```js
const flying = o => {
  let isFlying = false;

  return Object.assign({}, o, {
    fly () {
      isFlying = true;
      return this;
    },

    isFlying: () => isFlying,

    land () {
      isFlying = false;
      return this;
    }
  });
};
```

另外，你得知道对象的扩展是通过 `Object.assign()` 或者 `{...object, ...spread}` 实现的，这意味着如果你的对象有不可枚举的属性，它们将不会出现在最终的对象上：

```js
const a = Object.defineProperty({}, 'a', {
  enumerable: false,
  value: 'a'
});

const b = {
  b: 'b'
};

console.log({...a, ...b}); // { b: 'b' }
```

如果你正使用函数式 Mixin，而没有使用函数式编程，那么就别指望这些 Mixin 是纯的。相反，你得认为待扩展的基础对象可能是可变的，Mixin 也是充斥着副作用的，也没有引用透明的保障，亦即，对由函数式 Mixin 组合成的工厂进行缓存，通常是不安全的。

### 总结

函数式 Mixin 是一系列可组合的工厂函数，这些工厂函数能为对象增添属性或者行为，这些函数就好比流水线的各个站点一样。相较于类继承 “is-a” 的思考模式，函数式 Mixin 帮助对象从多个源获得特性，其所表达的是 **has-a**、**uses-a**、或者说 **can-do** 的思考模式。

需要注意的是，“函数式 Mixin” 没有向你暗示“函数式编程”，其仅仅描述了 -- “使用函数实现的 Mixin”。当然了，函数式 Mixin 也可以使用函数式编程的风格来撰写，这样能帮助我们避免副作用并且保证引用透明。但对于第三方库所提供的函数式 Mixin，就可能充斥着副作用和不确定性了。

- 不同于简单对象 Mixin，函数式 Mixin 可以通过闭包来实现真正的数据私有，以及对私有数据的继承。
- 不同于单一祖先的类继承，函数式 Mixin 能够支持多祖先，在这种情形下，它就像是装饰器（decorators）、特征（traits）、或者多继承（multiple inheritance）。
- 不同于 C++ 中的多继承，使用 JavaScript 实现的函数式 Mixin 在面临多继承问题时，基本不会存在菱形问题，当属性或者方法冲突时，认为最后进入的 Mixin 为胜出者，将采纳他提供的特性。
- 不同于类的装饰器、特征、或者多继承，函数式 Mixin 不需要基类。

最后，你还要切记，不要把事情搞复杂，函数式 Mixin 不是必需的，对于某个问题，你的解决思路应当是：

纯函数 > 工厂函数 > 函数式 Mixin > 类

**未完待续……**

### 接下来

想学习更多 JavaScript 函数式编程吗？

[跟着 Eric Elliott 学 Javacript](http://ericelliottjs.com/product/lifetime-access-pass/)，机不可失时不再来！

[<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg">](https://ericelliottjs.com/product/lifetime-access-pass/)

**Eric Elliott** 是  [**“编写 JavaScript 应用”**](http://pjabook.com) （O’Reilly） 以及 [**“跟着 Eric Elliott 学 Javascript”**](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 **Adobe Systems**、**Zumba Fitness**、**The Wall Street Journal**、**ESPN** 和 **BBC** 等 , 也是很多机构的顶级艺术家，包括但不限于 **Usher**、**Frank Ocean** 以及 **Metallica**。

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
