> * 原文地址：[How Does React Tell a Class from a Function?](https://overreacted.io/how-does-react-tell-a-class-from-a-function/)
> * 原文作者：[Dan Abramov](https://mobile.twitter.com/dan_abramov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-does-react-tell-a-class-from-a-function.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-does-react-tell-a-class-from-a-function.md)
> * 译者：[Washington Hua](https://tonghuashuo.github.io)
> * 校对者：

# React 如何区分 Class 和 Function ?

让我们来看一下这个以函数形式定义的 `Greeting` 组件：

```
function Greeting() {
  return <p>Hello</p>;
}
```

React 也支持将他定义成一个类：

```
class Greeting extends React.Component {
  render() {
    return <p>Hello</p>;
  }
}
```

（直到 [最近](https://reactjs.org/docs/hooks-intro.html)，这是使用 state 特性的唯一方式）

当你要渲染一个 `<Greeting />` 组件时，你并不需要关心它是如何定义的：

```
// 是类还是函数 —— 无所谓
<Greeting />
```

但 **React 本身**在意其中的差别！

如果 `Greeting` 是一个函数，React 需要调用它。

```
// 你的代码
function Greeting() {
  return <p>Hello</p>;
}

// React 内部
const result = Greeting(props); // <p>Hello</p>
```

但如果 `Greeting` 是一个类，React 需要先用 `new` 操作符将其实例化，**然后** 调用刚才生成实例的 `render` 方法：

```
// 你的代码
class Greeting extends React.Component {
  render() {
    return <p>Hello</p>;
  }
}

// React 内部
const instance = new Greeting(props); // Greeting {}
const result = instance.render(); // <p>Hello</p>
```

无论哪种情况 React 的目标都是去获取渲染后的节点（在这个案例中，`<p>Hello</p>`）。但具体的步骤取决于 `Greeting` 是如何定义的。

**所以 React 是怎么知道某样东西是 class 还是 function 的呢？**

就像我 [上一篇博客](https://overreacted.io/why-do-we-write-super-props/) 中提到的，**你并不 _需要_ 知道这个才能高效使用 React。** 我几年来都不知道这个。请不要把这变成一道面试题。事实上，这篇博客更多的是关于 JavaScript 而不是 React。

这篇博客是写给那些对 React 具体是 **如何** 工作的表示好奇的读者的。你是那样的人吗？那我们一起深入探讨一下吧。

**这将是一段漫长的旅程，系好安全带。这篇文章并没有多少关于 React 本身的信息，但我们会涉及到 `new`、`this`、`class`、箭头函数、`prototype`、`__proto__`、`instanceof` 等方面，以及这些东西是如何在 JavaScript 中一起工作的。幸运的是，你并不需要在 _使用_ React 时一直想着这些，除非你正在实现 React ...**

（如果你真的很想知道答案，直接翻到最下面）

* * *

首先，我们需要理解为什么把函数和类分开处理很重要。注意看我们是怎么使用 `new` 操作符来调用一个类的：

```
// 如果 Greeting 是一个函数
const result = Greeting(props); // <p>Hello</p>

// 如果 Greeting 是一个类
const instance = new Greeting(props); // Greeting {}
const result = instance.render(); // <p>Hello</p>
```

我们来简单看一下 `new` 在 JavaScript 是干什么的。

* * *

在过去，JavaScript 还没有类。但是，你可以使用普通函数来模拟。**具体来讲，只要在函数调用前加上 `new` 操作符，你就可以把 _任何_ 函数当做一个类的构造函数来用：**

```
// 只是一个函数
function Person(name) {
  this.name = name;
}

var fred = new Person('Fred'); // ✅ Person {name: 'Fred'}
var george = Person('George'); // 🔴 没用的
```

现在你依然可以这样写！在 DevTools 里试试吧。

如果你调用 `Person('Fred')` 时 **没有** 加 `new`，其中的 `this` 会指向某个全局且无用的东西（比如，`window` 或者 `undefined`），因此我们的代码会崩溃，或者做一些像设置 `window.name` 之类的傻事。

通过在调用前增加 `new`， 我们说：“嘿 JavaScript，我知道 `Person` 只是个函数，但让我们假装它是个构造函数吧。 **创建一个 `{}` 对象并把 `Person` 中的 `this` 指向那个对象，以便我可以通过类似 `this.name` 的形式去设置一些东西，然后把这个对象返回给我。**”

这就是 `new` 操作符所做的事。

```
var fred = new Person('Fred'); // 和 `Person` 中的 `this` 等效的对象
```

`new` 操作符同时也把我们放在 `Person.prototype` 上的东西放到了 `fred` 对象上：

```
function Person(name) {
  this.name = name;
}
Person.prototype.sayHi = function() {  alert('Hi, I am ' + this.name);}
var fred = new Person('Fred');
fred.sayHi();
```

这就是在 JavaScript 直接支持类之前，人们模拟类的方式。

* * *

`new` 在 JavaScript 中已经存在了好久了，然而类还只是最近的事，它的出现让我们能够重构我们前面的代码以使它更符合我们的本意：

```
class Person {
  constructor(name) {
    this.name = name;
  }
  sayHi() {
    alert('Hi, I am ' + this.name);
  }
}

let fred = new Person('Fred');
fred.sayHi();
```

**捕捉开发者的本意** 是语言和 API 设计中非常重要的一点。

如果你写了一个函数，JavaScript 没办法判断它应该像 `alert()` 一样被调用，还是应该被视作像 `new Person()` 一样的构造函数。忘记给像 `Person` 这样的函数指定 `new` 会导致令人费解的行为。

**类语法允许我们说：“这不仅仅是个函数 —— 这是个类并且它有构造函数”。** 如果你在调用它时忘了加 `new`， JavaScript 会报错：

```
let fred = new Person('Fred');
// ✅  如果 Person 是个函数：有效
// ✅  如果 Person 是个类：依然有效

let george = Person('George'); // 我们忘记使用 `new`
// 😳 如果 Person 是个长得像构造函数的方法：令人困惑的行为
// 🔴 如果 Person 是个类：立即失败
```

这可以帮助我们在早期捕捉错误，而不会遇到类似 `this.name` 被当成 `window.name` 对待而不是 `george.name` 的隐晦错误。

然而，这意味着 React 需要在调用所有类之前加上 `new`，而不能把它直接当做一个常规的函数去调用，因为 JavaScript 会把它当做一个错误对待！

```
class Counter extends React.Component {
  render() {
    return <p>Hello</p>;
  }
}

// 🔴 React 不能简单这么做:
const instance = Counter(props);
```

这意味着麻烦。

* * *

在我们看到 React 如何处理这个问题之前，很重要的一点就是要记得大部分 React 的用户会使用 Babel 等编译器来编译类等现代化的特性以便能在老旧的浏览器上运行。因此我们需要在我们的设计中考虑编译器。

在 Babel 的早期版本中，类不加 `new` 也可以被调用。但这个问题已经被修复了 —— 通过生成额外的代码的方式。

```
function Person(name) {
  // 稍微简化了一下 Babel 的输出：
  if (!(this instanceof Person)) {
    throw new TypeError("Cannot call a class as a function");
  }
  // Our code:
  this.name = name;
}

new Person('Fred'); // ✅ OK
Person('George');   // 🔴 无法把类当做函数来调用
```

你或许已经在你构建出来的包中见过类似的代码，这就是那些 `_classCallCheck` 函数做的事。（你可以通过启用“loose mode”来关闭检查以减小构建包的尺寸，但这或许会使你最终转向真正的原生类时变得复杂）

* * *

至此，你应该已经大致理解了调用时加不加 `new` 的差别：

|            | `new Person()`               | `Person()`                          |
| ---------- | ---------------------------- | ----------------------------------- |
| `class`    | ✅ `this` 是一个 `Person` 实例 | 🔴 `TypeError`                      |
| `function` | ✅ `this` 是一个 `Person` 实例 | 😳 `this` 是 `window` 或 `undefined` |

这就是 React 正确调用你的组件很重要的原因。 **如果你的组件被定义为一个类，React 需要使用 `new` 来调用它**

所以 React 能检查出某样东西是否是类吗？

没那么容易！即便我们能够 [在 JavaScript 中区分类和函数](https://stackoverflow.com/questions/29093396/how-do-you-check-the-difference-between-an-ecmascript-6-class-and-function)，面对被 Babel 等工具处理过的类这还是没用。对浏览器而言，它们只是不同的函数。这是 React 的不幸。

* * *

好，那 React 可以直接在每次调用时都加上 `new` 吗？很遗憾，这种方法并不总是有用。

对于常规函数，用 `new` 调用会给它们一个 `this` 作为对象实例。对于用作构造函数的函数（比如我们前面提到的 `Person`）是可取的，但对函数组件这或许就比较令人困惑了：

```
function Greeting() {
  // 我们并不期望 `this` 在这里表示任何类型的实例
  return <p>Hello</p>;
}
```

这暂且还能忍，还有两个 **其他** 理由会扼杀这个想法。

* * *

关于为什么总是使用 `new` 是没用的的第一个理由是，对于原生的箭头函数（不是那些被 Babel 编译过的），用 `new` 调用会抛出一个错误：

```
const Greeting = () => <p>Hello</p>;
new Greeting(); // 🔴 Greeting 不是一个构造函数
```

这个行为是遵循箭头函数的设计而刻意为之的。箭头函数的一个附带作用是它 **没有** 自己的 `this` 值 —— `this` 解析自离得最近的常规函数：

```
class Friends extends React.Component {
  render() {
    const friends = this.props.friends;
    return friends.map(friend =>
      <Friend
        // `this` 解析自 `render` 方法
        size={this.props.size}
        name={friend.name}
        key={friend.id}
      />
    );
  }
}
```

OK，所以 **箭头函数没有自己的 `this`。**但这意味着它作为构造函数是完全无用的！

```
const Person = (name) => {
  // 🔴 这么写是没有意义的！
  this.name = name;
}
```

因此，**JavaScript 不允许用 `new` 调用箭头函数。** 如果你这么做，你或许已经犯了错，最好早点告诉你。这和 JavaScript 不让你 **不加** `new` 去调用一个类是类似的。

这样很不错，但这也让我们的计划受阻。React 不能简单对所有东西都使用 `new`，因为会破坏箭头函数！我们可以利用箭头函数没有 `prototype` 的特点来检测箭头函数，不对它们使用 `new`：

```
(() => {}).prototype // undefined
(function() {}).prototype // {constructor: f}
```

但这对于被 Babel 编译过的函数是 [没用](https://github.com/facebook/react/issues/4599#issuecomment-136562930) 的。这或许没什么大不了，但还有另一个原因使得这条路不会有结果。

* * *

另一个我们不能总是使用 `new` 的原因是它会妨碍 React 支持返回字符串或其它原始类型的组件。

```
function Greeting() {
  return 'Hello';
}

Greeting(); // ✅ 'Hello'
new Greeting(); // 😳 Greeting {}
```

这，再一次，和 [`new` 操作符](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new) 的怪异设计有关。如我们之前所看到的，`new` 告诉 JavaScript 引擎去创建一个对象，让这个对象成为函数内部的 `this`，然后把这个对象作为 `new` 的结果给我们。

然而，JavaScript 也允许一个使用 `new` 调用的函数返回另一个对象以 **覆盖** `new` 的返回值。或许，这在我们利用诸如“对象池模式”来对组件进行复用时是被认为有用的：

```
// 创建了一个懒变量 zeroVector = null;
function Vector(x, y) {
  if (x === 0 && y === 0) {
    if (zeroVector !== null) {
      // 复用同一个实例
      return zeroVector;
    }
    zeroVector = this;
  }
  this.x = x;
  this.y = y;
}

var a = new Vector(1, 1);
var b = new Vector(0, 0);
var c = new Vector(0, 0); // 😲 b === c
```

然而，如果一个函数的返回值 **不是** 一个对象，它会被 `new` **完全忽略**。如果你返回了一个字符串或数字，就好像完全没有 `return` 一样。

```
function Answer() {
  return 42;
}

Answer(); // ✅ 42
new Answer(); // 😳 Answer {}
```

当使用 `new` 调用函数时，是没办法读取原始类型（例如一个数字或字符串）的返回值的。因此如果 React 总是使用 `new`，就没办法增加对返回字符串的组件的支持！

这是不可接受的，因此我们必须妥协。

* * *

至此我们学到了什么？React 在调用类（包括 Babel 输出的）时 **需要用** `new`，但在调用常规函数或箭头函数时（包括 Babel 输出的）**不需要用** `new`，并且没有可靠的方法来区分这些情况。

**如果我们没法解决一个笼统的问题，我们能解决一个具体的吗？**

当你把一个组件定义为类，你很可能会想要扩展 `React.Component` 以便获取内置的方法，比如 `this.setState()`。 **与其试图检测所有的类，我们能否只检测 `React.Component` 的后代呢？**

剧透：React 就是这么干的。

* * *

或许，检查 `Greeting` 是否是一个 React 组件类的最符合语言习惯的方式是测试 `Greeting.prototype instanceof React.Component`：

```
class A {}
class B extends A {}

console.log(B.prototype instanceof A); // true
```

我知道你在想什么，刚才发生了什么？！为了回答这个问题，我们需要理解 JavaScript 原型。

你或许对“原型链”很熟悉。JavaScript 中的每一个对象都有一个“原型”。当我们写 `fred.sayHi()` 但 `fred` 对象没有 `sayHi` 属性，我们尝试到 `fred` 的原型上去找 `sayHi` 属性。要是我们在这儿找不到，就去找原型链的下一个原型 —— `fred` 的原型的原型，以此类推。

**费解的是，一个类或函数的 `prototype` 属性 _并不_ 指向那个值的原型。** 我没开玩笑。

```
function Person() {}

console.log(Person.prototype); // 🤪 不是 Person 的原型
console.log(Person.__proto__); // 😳 Person 的原型
```

因此“原型链”更像是 `__proto__.__proto__.__proto__` 而不是 `prototype.prototype.prototype`，我花了好几年才搞懂这一点。

那么函数和类的 `prototype` 属性又是什么？**是用 `new` 调用那个类或函数生成的所有对象的 `__proto__` ！**

```
function Person(name) {
  this.name = name;
}
Person.prototype.sayHi = function() {
  alert('Hi, I am ' + this.name);
}

var fred = new Person('Fred'); // 设置 `fred.__proto__` 为 `Person.prototype`
```

那个 `__proto__` 链才是 JavaScript 用来查找属性的：

```
fred.sayHi();
// 1. fred 有 sayHi 属性吗？不。
// 2. fred.__proto__ 有 sayHi 属性吗？是的，调用它！

fred.toString();
// 1. fred 有 toString 属性吗？ 不。
// 2. fred.__proto__ 有 toString 属性吗？ 不。
// 3. fred.__proto__.__proto__ 有 toString 属性吗？是的，调用它！
```

在实战中，你应该几乎永远不需要直接在代码里动到 `__proto__` 除非你在调试和原型链相关的问题。如果你想让某样东西在 `fred.__proto__` 上可用，你应该把它放在 `Person.prototype`，至少它最初是这么设计的。

`__proto__` 属性甚至一开始就不应该被浏览器暴露出来，因为原型链应该被视为一个内部概念，然而某些浏览器增加了 `__proto__` 并最终勉强被标准化（但已被废弃并推荐使用 `Object.getPrototypeOf()`）。

**然而一个名叫“原型”的属性却给不了我一个值的“原型”这一点还是很让我困惑**（例如，`fred.prototype` 是未定义的，因为 `fred` 不是一个函数）。个人观点，我觉得这是即便有经验的开发者也容易误解 JavaScript 原型链的最大原因。

* * *

这篇博客很长，是吧？已经到 80% 了，坚持住。

我们知道当说 `obj.foo` 的时候，JavaScript 事实上会沿着 `obj`, `obj.__proto__`, `obj.__proto__.__proto__` 等等一路寻找 `foo`。

在使用类时，你并非直接面对这一机制，但 `extends` 的原理依然是基于这项老旧但有效的原型链机制。这也是的我们的 React 类实例能够访问如 `setState` 这样方法的原因：

```
class Greeting extends React.Component {
  render() {
    return <p>Hello</p>;
  }
}

let c = new Greeting();
console.log(c.__proto__); // Greeting.prototype
console.log(c.__proto__.__proto__); // React.Component.prototype
console.log(c.__proto__.__proto__.__proto__); // Object.prototype

c.render();      // 在 c.__proto__ (Greeting.prototype) 上找到
c.setState();    // 在 c.__proto__.__proto__ (React.Component.prototype) 上找到
c.toString();    // 在 c.__proto__.__proto__.__proto__ (Object.prototype) 上找到
```

换句话说，**当你在使用类的时候，实例的 `__proto__` 链“镜像”了类的层级结构：**

```
// `extends` 链
Greeting
  → React.Component
    → Object (间接的)

// `__proto__` 链
new Greeting()
  → Greeting.prototype
    → React.Component.prototype
      → Object.prototype
```

2 条链。

* * *

既然 `__proto__` 链镜像了类的层级结构，我们可以检查一个 `Greeting` 是否扩展了 `React.Component`，我们从 `Greeting.prototype` 开始，一路沿着 `__proto__` 链：

```
// `__proto__` chain
new Greeting()
  → Greeting.prototype // 🕵️ 我们从这儿开始
    → React.Component.prototype // ✅ 找到了！
      → Object.prototype
```

方便的是，`x instanceof Y` 做的就是这类搜索。它沿着 `x.__proto__` 链寻找 `Y.prototype` 是否在那儿。

通常，这被用来判断某样东西是否是一个类的实例：

```
let greeting = new Greeting();

console.log(greeting instanceof Greeting); // true
// greeting (🕵️‍ 我们从这儿开始)
//   .__proto__ → Greeting.prototype (✅ 找到了！)
//     .__proto__ → React.Component.prototype
//       .__proto__ → Object.prototype

console.log(greeting instanceof React.Component); // true
// greeting (🕵️‍ 我们从这儿开始)
//   .__proto__ → Greeting.prototype
//     .__proto__ → React.Component.prototype (✅ 找到了！)
//       .__proto__ → Object.prototype

console.log(greeting instanceof Object); // true
// greeting (🕵️‍ 我们从这儿开始)
//   .__proto__ → Greeting.prototype
//     .__proto__ → React.Component.prototype
//       .__proto__ → Object.prototype (✅ 找到了！)

console.log(greeting instanceof Banana); // false
// greeting (🕵️‍ 我们从这儿开始)
//   .__proto__ → Greeting.prototype
//     .__proto__ → React.Component.prototype
//       .__proto__ → Object.prototype (🙅‍ 没找到！)
```

但这用来判断一个类是否扩展了另一个类还是有效的

```
console.log(Greeting.prototype instanceof React.Component);
// greeting
//   .__proto__ → Greeting.prototype (🕵️‍ 我们从这儿开始)
//     .__proto__ → React.Component.prototype (✅ 找到了！)
//       .__proto__ → Object.prototype
```

这种检查方式就是我们判断某样东西是一个 React 组件类还是一个常规函数的方式。

* * *

然而 React 并不是这么做的 😳

关于 `instanceof` 解决方案有一点附加说明，当页面上有多个 React 副本，并且我们要检查的组件继承自 **另一个** React 副本的 `React.Component` 时，这种方法是无效的。在一个项目里混合多个 React 副本是不好的，原因有很多，但站在历史角度来看，我们试图尽可能避免问题。（有了 Hooks，我们 [或许得](https://github.com/facebook/react/issues/13991) 强制避免重复）

另一点启发可以是去检查原型链上的 `render` 方法。然而，当时还 [不确定](https://github.com/facebook/react/issues/4599#issuecomment-129714112) 组件的 API 会如何演化。每一次检查都有成本，所以我们不想再多加了。如果 `render` 被定义为一个实例方法，例如使用类属性语法，这个方法也会失效。

因此, React 为基类 [增加了](https://github.com/facebook/react/pull/4663) 一个特别的标记。React 检查是否有这个标记，以此知道某样东西是否是一个 React 组件类。

最初这个标记是在 `React.Component` 这个基类自己身上：

```
// React 内部
class Component {}
Component.isReactClass = {};

// 我们可以像这样检查它
class Greeting extends Component {}
console.log(Greeting.isReactClass); // ✅ 是的
```

然而，有些我们希望作为目标的类实现 [并没有](https://github.com/scala-js/scala-js/issues/1900) 复制静态属性（或设置非标准的 `__proto__`），标记也因此丢失。

这也是为什么 React 把这个标记 [移动到了](https://github.com/facebook/react/pull/5021) `React.Component.prototype`：

```
// React 内部
class Component {}
Component.prototype.isReactComponent = {};

// 我们可以像这样检查它
class Greeting extends Component {}
console.log(Greeting.prototype.isReactComponent); // ✅ 是的
```

**说真的这就是全部了。**

你或许奇怪为什么是一个对象而不是一个布尔值。实战中这并不重要，但早期版本的 Jest (在 Jest 商品化之前) 是默认开始自动模拟功能的，生成的模拟数据省略掉了原始类型属性，[破坏了检查](https://github.com/facebook/react/pull/4663#issuecomment-136533373)。谢了，Jest。

一直到今天，[React 都在用](https://github.com/facebook/react/blob/769b1f270e1251d9dbdce0fcbd9e92e502d059b8/packages/react-reconciler/src/ReactFiber.js#L297-L300) `isReactComponent` 进行检查。

如果你不扩展 `React.Component`，React 不会在原型上找到 `isReactComponent`，因此就不会把组件当做类处理。现在你知道为什么解决 `Cannot call a class as a function` 错误的 [得票数最高的答案](https://stackoverflow.com/a/42680526/458193) 是增加 `extends React.Component`。最后，我们还 [增加了一项警告](https://github.com/facebook/react/pull/11168)，当 `prototype.render` 存在但 `prototype.isReactComponent` 不存在时会发出警告。

* * *

你或许会觉得这个故事有一点“标题党”。 **实际的解决方案其实真的很简单，但我花了大量的篇幅在转折上来解释 _为什么_ React 最终选择了这套方案，以及还有哪些候选方案。**

以我的经验来看，设计一个库的 API 也经常会遇到这种情况。为了一个 API 能够简单易用，你经常需要考虑语义化（可能的话，为多种语言考虑，包括未来的发展方向）、运行时性能、有或没有编译时步骤的工程效能、生态的状态以及打包方案、早期的警告，以及很多其它问题。最终的结果未必总是最优雅的，但必须要是可用的。

**如果最终的 API 成功的话, _它的用户_ 永远不必思考这一过程.** 他们只需要专心创建应用就好了。

但如果你同时也很好奇...知道它是怎么工作的也是极好的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
