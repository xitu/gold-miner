
> * 原文地址：[Why Composition is Harder with Classes](https://medium.com/javascript-scene/why-composition-is-harder-with-classes-c3e627dcd0aa)
> * 原文作者：[
Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/why-composition-is-harder-with-classes.md](https://github.com/xitu/gold-miner/blob/master/TODO/why-composition-is-harder-with-classes.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[sunui](https://github.com/sunui) [IridescentMia](https://github.com/IridescentMia)

# 为什么在使用了类之后会使得组合变得愈发困难（软件编写）（第九部分）

![Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)（译注：该图是用 PS 将烟雾处理成方块状后得到的效果，参见 [flickr](https://www.flickr.com/photos/68397968@N07/11432696204)。）

> 注意：这是 “软件编写” 系列文章的第十部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科 [Composability](https://en.wikipedia.org/wiki/Composability)）。后续还有更多精彩内容，敬请期待！
> [< 上一篇](https://juejin.im/post/59c8c8756fb9a00a681ae5bd) | [<< 返回第一篇](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.mda)

前文中，我们仔细审视了工厂函数，并且也看到了在使用了函数式 mixins 之后，它们能很好地服务于函数组合。现在，我们还将更加仔细地看看类，验证 `class` 的机制是如何妨碍了组合式软件编写。

但我们并不完全否定类，一些优秀的类使用案例和如何更加安全地使用类也是本文将会探讨的。

ES6 拥有了一个便捷的 `class` 语法，这也让你不免怀疑为什么我们还需要工厂函数。二者最显著的区别是构造函数以及 `class` 要使用 `new` 关键字。但 `new` 究竟做了什么？

- 创建了一个新的对象，并且将构造函数中的 `this` 绑定到了该对象。
- 如果你没有显式地在构造函数中返回其他对象，那么构造函数将隐式地返回 `this`。
- 将对象的 `[[Prototype]]` （一个内部引用） 属性设置为 `Constructor.prototype`，从而有 `Object.getPrototypeOf(instance) === Constructor.prototype`。
- 声明构造函数引用，令 `instance.constructor === Constructor`。

所有的这些都意味着，与工厂函数不同，类并不是完成组合式函数 mixin 的好手段。虽然你仍可以使用 `class` 来完成组合，但在后文中你将看到，这是一个非常复杂的过程，你的煞费苦心并不值当。

## 委托原型

最终，你可能需要将类重构为工厂函数，但是如果你要求调用者使用 `new` 关键字，那么重构将会以各种你无法预见到的方式打破原有的客户端代码。首先，不同于类和构造函数，工厂函数不会自动地构造一条委托原型链。

`[[Prototype]]` 链接是服务于原型委托的，如果你有数以百万计的对象，它将能帮你节约内存，亦或当你需要在程序中在 16 毫秒内的渲染循环中访问一个对象成千上万的属性时，它能够带来一些微小的性能提升。

如果你并不需要内存或者性能上的微型优化，`[[Prototype]]` 链接就弊大于利了。在 JavaScript 中，原型链加强了 `instanceof` 运算符，但不幸的是，由于以下两个原因，`instanceof` 并不可靠：

在 ES5 中，`Constructor.prototype` 链接是动态可重配的，这一特性在你需要创建抽象工厂时显得尤为方便，但是如果你使用了该特性，当 `Constructor.prototype` 引用的对象和 `[[Prototype]]` 属性指向的不是同一对象时，`instanceof` 会引起伪阴性（false negative），即丢失了对象和所属类的关系：

```
class User {
  constructor ({userName, avatar}) {
    this.userName = userName;
    this.avatar = avatar;
  }
}
const currentUser = new User({
  userName: 'Foo',
  avatar: 'foo.png'
});
User.prototype = {}; // 重配了 User 原型
console.log(
  currentUser instanceof User, // <-- false -- 糟糕！
  // 但是该对象的形态确实满足 User 类型
  // { avatar: "foo.png", userName: "Foo" }
  currentUser
);
```

Chrome 意识到了这个问题，所以在属性描述之中，将 `Constructor.prototype` 的 `configurable` 属性设置为了 `false`。然而，Babel 就没有实现类似的行为，所以 Babel 编译后的代码将表现得和 ES5 的构造函数一样。而当你试图重新配置 `Constructor.prototype` 属性时，V8 将静默失败。无论是哪种方式，你都得不到你想要的结果。更加糟糕的是，重新设置 `Constructor.prototype` 会是前后矛盾的，因此我不推荐这样做。

更常见的问题是，JavaScript 会拥有多个执行上下文 -- 相同代码所在的内存沙盒会访问不同的物理内存地址。例如，如果在父 frame 中有一个构造函数，且在 `iframe` 中有相同的构造函数，那么父 frame 中的 `Constructor.prototype` 和 `iframe` 中的 `Constructor.prototype` 将不会引用相同的内存位置。这是因为 JavaScript 中的对象值在底层是内存引用的，而不同的 frame 指向内存的不同内存位置，所以 `===` 将会检查失败。

`instanceof` 的另一个问题是，它是一个名义上的类型检查而非结构类型检查，这意味着如果你开始使用了 `class` 并在之后切换到了抽象工厂，所有调用了 `instanceof` 的代码将不再能明白新的实现，即便这些代码都满足了接口约束。例如，你已经构建了一个音乐播放器接口，之后产品团队要求你为视频播放也提供支持，之后的之后，又叫你支持全景视频。视频播放器对象和音乐播放器对象是使用一致的控制策略：播放，停止，倒回，快进。

但是如果你使用了 `instanceof` 作为对象类型检查，所有实现了你的视频接口类的对象不会满足代码中已经存在的 `foo instanceof AudioInterface` 检查。

这些检查本应当成功的，然而现在却失败了。在其他语言中，通过允许一个类声明其所实现的接口，实现了可共享接口，从而也就解决了上面的问题。但在 JavaScript 中，这一点尚不能做到。

在 JavaScript 中，如果你不需要委托原型链接（`[[Prototype]]`）的话，就打断委托原型链，让每次对象的类型判断检查都失败，错就错个彻底，这才是使用 `instanceof` 的最好方式。这样的处理方式你也不会对对象类型判断的可靠性产生误解。这其实是让你不要相信 `instanceof`，它也就无法对你撒谎了。

## .contructor 属性

`.constructor` 在 JavaScript 中已经鲜有使用了，它本该很有用，将它放入你的对象实例中也会是个好主意。但大多数情况下，如果你不尝试使用它来进行类型检测的话，它会是毛病重重的，并且，它也是不安全的，原因和 `instanceof` 不安全的原因一样。

**理论上来说**，`.constructor` 对于创建通用函数很有用，这些通用函数能够返回你传入对象的新实例。

**实践中**，在 JavaScript 中，有许多不同的方式来创建新的实例。即使是一些微不足道的目的，让对象保持一个其构造函数的引用，和知道如何使用构造函数够实例化新的对象也并不是一件事儿，我们可以看到下面这个例子，如何创建一个与指定对象同类型的空实例，首先，我们借助于 `new` 及对象的 `.constructor` 属性：

```
// 返回任何传入对象类型的空实例？
const empty = ({ constructor } = {}) => constructor ?
  new constructor() :
  undefined
;
const foo = [10];
console.log(
  empty(foo) // []
);
```

对于数组类型来说，这段代码工作良好。那么我们试试返回 Promise 类型的空对象：

```
// 返回任何传入对象类型的空实例？
const empty = ({ constructor } = {}) => constructor ?
  new constructor() :
  undefined
;
const foo = Promise.resolve(10);
console.log(
  empty(foo) // [TypeError: Promise resolver undefined is
             //  not a function]
);
```

注意到代码中的 `new` 关键字，这是问题的来源。可以认为，在任何工厂函数中使用 `new` 关键字是不安全的，有时它会造成错误。

要使上述代码正确工作，我们需要有一个标准的方式来传入一个新的值到新的实例中，这个方式将使用一个不需要 `new` 的标准工厂函数。对此，这里有个规范：任何构造函数或者工厂方法都需要一个 [`.of()` 的静态方法]((https://github.com/fantasyland/fantasy-land#of-method)。`.of()` 是一个工厂函数，它能根据你传入的对象，返回对应类型的新实例。

现在，我们可以使用 `.of()` 来创建一个更好的通用 `empty()` 函数：

```
// 返回任何传入对象类型的空实例？
const empty = ({ constructor } = {}) => constructor.of ?
  constructor.of() :
  undefined
;
const foo = [23];
console.log(
  empty(foo) // []
);
```

不幸的是，`.of()` 静态方法才开始在 JavaScript 中得到支持。`Promise` 对象没有 `.of()` 静态方法，但有一个与之行为一致的静态方法 `.resolve()`，因此，我们的通用工厂函数无法工作在 `Promise` 对象上：

```
// 返回任意对象类型的空实例？
const empty = ({ constructor } = {}) => constructor.of ?
  constructor.of() :
  undefined
;
const foo = Promise.resolve(10);
console.log(
  empty(foo) // undefined
);
```

同样地，如果字符串、数字、object、map、weak map、set 等类型也提供了 `.of()` 静态方法，那么 `.constructor` 属性将成为 JavaScript 中更加有用的特性。我们能够使用它来构建一个富工具函数库，这个库能够工作在 functor，monad 以及其他任何代数类型上。

对于一个工厂函数来说，添加 `.constructor` 和 `.of()` 是非常容易的：

```
const createUser = ({
  userName = 'Anonymous',
  avatar = 'anon.png'
} = {}) => ({
  userName,
  avatar,
  constructor: createUser
});
createUser.of = createUser;
// 测试 .of 和 .constructor:
const empty = ({ constructor } = {}) => constructor.of ?
  constructor.of() :
  undefined
;
const foo = createUser({ userName: 'Empty', avatar: 'me.png' });
console.log(
  empty(foo), // { avatar: "anon.png", userName: "Anonymous" }
  foo.constructor === createUser.of, // true
  createUser.of === createUser       // true
);
```

你甚至可以通过 `Object.create()` 方法来让 `.constructor` 不可枚举（译注：这样 `Object.keys()` 等方法就无法拿到 `.constructor` 属性）：

```
const createUser = ({
  userName = 'Anonymous',
  avatar = 'anon.png'
} = {}) => Object.assign(
  Object.create({
    constructor: createUser
  }), {
    userName,
    avatar
  }
);
```

## 从类切到工厂将是一次巨大的变迁

工厂函数通过下面这些方式提高了代码的灵活性：

- 将对象实例化细节从调用代码处解耦。
- 允许你返回任意类型，例如，使用一个对象池控制垃圾收集器。
- 不要提供任何的类型保证，这样，调用者也不会尝试使用  `instanceof` 或者其他不可靠的类型检测手段，这些手段往往会在跨执行上下文调用或是当你切换到一个抽象工厂时破坏了原有的代码。
- 由于工厂函数不提供任何类型保证，工厂就能动态地切换到抽象工厂的实现。例如，一个媒体播放器工厂变为了一个抽象工厂，该工厂提供一个 `.play()` 方法来满足不同的媒体类型。
- 使用工厂函数将更利于函数组合。

尽管多数目标能够通过类完成，但是使用工厂函数，将会让一切变得更加轻松。使用工厂函数，将更少地遇到 bug，更少地陷入复杂性的泥潭，以及更少的代码。

基于以上原因，更加推崇将 `class` 重构为工厂函数，但也要注意，重构会是个复杂并且有可能产生错误的过程。在每一个面向对象语言中，从类到工厂函数的重构都是一个普遍的需求。关于此，你可以在 Martin Fowler、Kent Beck、John Brant、William Opdyke 和 Don Roberts 的这篇文章中知道更多：[Refactoring: Improving the Design of Existing Code](https://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672/ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=eejs-20&linkId=e7d5f652bc860f02c27ec352e1b8342c)

由于 `new` 改变了一个函数调用的行为，从类到工厂函数进行的重构将是一个潜在的巨大改变。换言之，强制调用者使用 `new` 将不可避免地将调用者限制到构造函数的实现中，因此，`new` 将潜在地引起巨大的调用相关的 API 的实现改变。

我们已经见识过了，下面这些隐式行为会让从类到工厂的转变成为一个巨大的改变：

- 工厂函数创建的实例不再具有 `[[Prototype]]` 链接，那么该实例所有调用 `instanceof` 进行类型检测的代码都需要修改。
- 工厂函数创建的实例不再具有 `.constructor` 属性，所有用到该实例 `.constructor` 属性的代码都需要修改。

这两个问题可以通过在工厂函数创建对象的过程中绑定这两个属性来补救。

你也要留心 `this` 可能会绑定到工厂函数的调用环境，这在使用 `new` 时是不需要考虑的（译注：`new` 会将 `this` 默认绑定到新创建的对象上）。如果你想要将抽象工厂原型存储为工厂函数的静态属性，这会让问题变得更加棘手。

这是也是另一个需要留意的问题。所有的 `class` 调用都必须使用 `new`。省略了 `new` 的话，将会抛出如下错误：

```
class Foo {};
// TypeError: Class constructor Foo cannot be invoked without 'new'
const Bar = Foo();
```

在 ES6 及以上的版本，更常使用箭头函数来创建工厂，但是在 JavaScript 中，由于箭头函数不会拥有自己的 `this` 绑定，用 `new` 来调用一个箭头函数将会抛出错误：

```
const foo = () => ({});
// TypeError: foo is not a constructor
const bar = new foo();
```

所以，你无法在 ES6 环境下去将类重构为一个箭头函数工厂。但这无关紧要，彻头彻尾的失败是件好事儿，这会让你断了使用 `new` 的念想。

但是，如果你将箭头函数编译为标准函数来允许对标准函数使用 `neW`，就会错上加错。在构建应用程序时，代码工作良好，但是应用切到生产环境时，也许会导致错误，从而影响了用户体验，甚至让整个应用崩溃。

一个编辑器默认配置的变化就能破坏你的应用，甚至是你都没有改变任何你自己撰写的代码。再唠叨一句：

> **警告：**从 `class` 到箭头函数的工厂的重构可能能在某一编译器下工作，但是如果工厂被编译为了一个原生箭头函数，你的应用将因为不能对该箭头函数使用 `new` 而崩溃。

## 代码要求使用 new 违反了开闭原则

开闭原则指的是，我们的 API 应当对扩展开放，而对修改封闭。由于对某个类常见的扩展是将它变为一个灵活性更高的工厂函数，但是这个重构如上文所说是一个巨大的改变，因此 `new` 关键字是对扩展封闭而对修改开放的，这与开闭原则相悖。

如果你的 `class` API 是公开的，或者如果你和一个大型团队一起服务于一个大型项目，重构很可能破坏一些你无法意识到的代码。更好的做法是淘汰掉整个类（译注：也要淘汰类的相关操作，如 `new`，`instanceof` 等），并将其替代为工厂函数。

该过程将一个小的，兴许能够静默解决的技术问题变为了极大的人的问题，新的重构将要求开发者对此具有足够的意识，受教育程度，以及愿意入伙重构，因此，这样的重构会是一个十分繁重的任务。

我已经见到过了 `new` 多次引起了非常令人头痛的问题，但这很容易避免：

> 使用工厂函数替代类。

## 类关键字以及继承

`class` 关键字被认为是为 JavaScript 中的对象模式创建提供了更棒的语法，但在某些方面，它仍有不足：

### 友好的语法

`class` 的初衷是要提供一个友好的语法来在 JavaScript 中模拟其他语言中的 `class`。但我们需要问问自己，究竟在 JavaScript 中是否真的需要来模拟其他语言中的 `class`？

JavaScript 的工厂函数提供了一个更加友好的语法，开箱即用，非常简单。通常，一个对象字面量就足够完成对象创建了。如果你需要创建多个实例，工厂函数会是接下来的选择。

在 Java 和 C++ 中，相较于类，工厂函数更加复杂，但由于其提供的高度灵活性，工厂仍然值得创建。在 JavaScript 中，相较于类，工厂则更加简单，但是却更加强大。

下面的代码使用类来创建对象：

```
class User {
  constructor ({userName, avatar}) {
    this.userName = userName;
    this.avatar = avatar;
  }
}
const currentUser = new User({
  userName: 'Foo',
  avatar: 'foo.png'
});
```

同样的功能，我们替换为工厂函数试试：

```
const createUser = ({ userName, avatar }) => ({
  userName,
  avatar
});
const currentUser = createUser({
  userName: 'Foo',
  avatar: 'foo.png'
});
```

如果熟悉 JavaScript 以及箭头函数，那么能够感受到工厂函数更简洁的语法及因此带来的代码可读性的提高。或许你还倾向于 `new`，但下面这篇文章阐述了应当避免使用的 `new` 的原因：[Familiarity bias may be holding you back](https://medium.com/javascript-scene/familiarity-bias-is-holding-you-back-its-time-to-embrace-arrow-functions-3d37e1a9bb75)。

还有别的工厂优于类的论证吗？

## 性能及内存占用

> 委托原型好处寥寥。

`class` 语法稍优于 ES5 的构造函数，其主要目的在于为对象建立委托原型链，但是委托原型实在是好处寥寥。原因主要归结于性能。

`class` 提供了两个性能优化方式：属性检索优化以及存在委托原型上的属性会共享内存。

大多数现代设备的 RAM 都不小，任何类型的闭包作用域或者属性检索都能达到成百上千的 ops。所以是否使用 `class` 造成的性能差异在现代设备中几乎可以忽略不计了。

当然，也有例外。RxJS 使用了 `class` 实例，是因为它们确实比闭包性能好些，但是 RxJS 作为一个工具库，有可能工作在操作频繁的上下文中，因此它需要限制其渲染循环在 16 毫秒内完成，这无可厚非。

ThreeJS 也使用了类，但你知道的，ThreeJS 是一个 3d 渲染库，常用于开发游戏引擎，对性能极度苛求，每 16 毫秒的渲染循环就要操作上千个对象。

上面两个例子想说明的是，作为对性能有要求的库，它们使用 `class` 是合情合理的。

在一般的应用开发中，我们应当避免提前优化，只有在性能需要提升或者遭遇瓶颈时才考虑去优化它。对于大多数应用来说，性能优化的点在于网络的请求和响应，过渡动画，静态资源的缓存策略等等。

诸如使用 `class` 这样的微型优化对性能的优化是有限的，除非你真正发现了性能问题，并找准了瓶颈发生的位置。

取而代之的，你更应当关注和优化代码的可维护性和灵活性。

## 类型检测

JavaScript 中的类是动态的，`instanceof` 的类型检测不会真正地跨执行上下文工作，所以基于 `class` 的类型检测不值得考虑。类型检测可能导致 bug，你的应用程序也不需要那么严格，造成复杂性的提高。

## 使用 `extends` 进行类继承

类继承会造成的这些问题想必你已经听过多次了：

- **紧耦合**: 在面向对象程序设计中，类继承会造成最紧的耦合。
- **层级不灵活**: 随着开发时间的增长，所有的类层级最终都不适应于新的用例，但紧耦合又限制了代码重构的可能性。
- **猩猩/香蕉 问题**: 继承的强制性。“你只想要一个香蕉，但是你最终得到的却是一个拿着香蕉的猩猩以及整个丛林 ” 这句话来自 Joe Armstrong 在 [Coders at Work](https://www.amazon.com/Coders-Work-Reflections-Craft-Programming/dp/1430219483/ref=as_li_ss_tl?s=books&ie=UTF8&qid=1500436305&sr=1-1&keywords=coders+at+work&linkCode=ll1&tag=eejs-20&linkId=45e89bc5d776b1326c2ae90355e9ccac) 中提到的
- **代码重复**: 由于不灵活的层级及 猩猩/香蕉 问题，代码重用往往只能靠复制/粘贴，这违反了 DRY（Don't Repeat Yourself）原则，反而一开始就违背了继承的初衷。

`extends` 的唯一目的是创建一个单一祖先的 class 分类法。一些机智的 hacker 读了本文会说：“我不认同你的看法，类也是可组合的 ”。对此，我的回答是 “但是你脱离了 `extend`，使用对象组合来替代类继承，在 JavaScript 中是更加简单，安全的方式”

## 如果你足够仔细的话，类也是 OK 的

我说了很多工厂替代掉类的好处，但你仍坚持使用类的话，不妨再看看我下面的一些建议，它们帮助你更安全地使用类：

- 避免使用 `instanceof`。由于 JavaScript 是动态语言并且拥有多个执行上下文，`instanceof` 总是难以反映期望的类型检测结果。如果之后你要切换到抽象工厂，这也会造成问题。
- 避免使用 `extends`。不要多次继承一个单一层级。“应当优先考虑对象组合而不是类继承” 这句话源自 [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented-ebook/dp/B000SEIBB8/ref=as_li_ss_tl?s=digital-text&ie=UTF8&qid=1500478917&sr=1-1&keywords=design+patterns&linkCode=ll1&tag=eejs-20&linkId=7443052c45c6e7d9cb7f6b06fa58b488)
- 避免导出你的类。使用 `class` 会让应用获得一定程度的性能提升，但是导出一个工厂来创建实例是为了不鼓励用户来继承你撰写好的类，也避免他们使用 `new` 来实例化对象。
- 避免使用 `new`。尽量不直接使用 `new`，也不要强制你的调用者使用它，取而代之的是，你可以导出一个工厂供调用者使用。

下面这些情况你可以使用类：

- **你正使用某个框架创建 UI 组件**，例如你正使用 React 或者 Angular 撰写组件。这些框架会将你的组件类包裹为工厂函数，并负责组件的实例化，所以也避免了用户去使用 `new`。
- **你从不会继承你的类或者组件**。尝试使用对象组合、函数组合、高阶函数、高阶组件或者模块，相较于类继承，它们更利于代码复用。
- **你需要优化性能**。只要记住你使用了类之后应当暴露工厂而不是类给用户，让用户避免使用 `new` 和 `extend`。

在大多数情况下，工厂函数将更好地服务于你。

在 JavaScript 中，工厂比类或者构造函数更加简单。我们在撰写应用时，应当先从简单的模式开始，直到需要时，才渐进到更复杂的模式。

[下一篇: 使用函数完成的可组合类型 >](https://medium.com/javascript-scene/composable-datatypes-with-functions-aec72db3b093)

## 接下来

想学习更多 JavaScript 函数式编程吗？

[跟着 Eric Elliott 学 Javacript](http://ericelliottjs.com/product/lifetime-access-pass/)，机不可失时不再来！

[<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg">](https://ericelliottjs.com/product/lifetime-access-pass/)

**Eric Elliott** 是  [**“编写 JavaScript 应用”**](http://pjabook.com) （O’Reilly） 以及 [**“跟着 Eric Elliott 学 Javascript”**](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 **Adobe Systems**、**Zumba Fitness**、**The Wall Street Journal**、**ESPN** 和 **BBC** 等 , 也是很多机构的顶级艺术家，包括但不限于 **Usher**、**Frank Ocean** 以及 **Metallica**。

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
