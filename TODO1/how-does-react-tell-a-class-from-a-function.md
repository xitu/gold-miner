> * 原文地址：[How Does React Tell a Class from a Function?](https://overreacted.io/how-does-react-tell-a-class-from-a-function/)
> * 原文作者：[Dan Abramov](https://mobile.twitter.com/dan_abramov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-does-react-tell-a-class-from-a-function.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-does-react-tell-a-class-from-a-function.md)
> * 译者：[Washington Hua](https://tonghuashuo.github.io)
> * 校对者：

# React 是如何区分 Class 和 Function 的 ?

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

（直到[最近](https://reactjs.org/docs/hooks-intro.html)，这是使用 state 特性的唯一方式）

当你想要渲染一个 `<Greeting />` 组件时，你并不关心它是如何定义的：

```
// 是类还是函数 - 无所谓
<Greeting />
```

但 _React 本身_ 在意其中的差别！

如果 `Greeting` 是一个函数，React 需要调用它。

```
// 你的代码
function Greeting() {
  return <p>Hello</p>;
}

// React 内部
const result = Greeting(props); // <p>Hello</p>
```

但如果 `Greeting` 是一个类，React 需要先用 `new` 操作符将其实例化， _然后_ 调用当菜生成的实例的 `render` 方法：

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

**所以 React 是怎么识别 class 还是 function的？**

就像我在[上一篇博客](/why-do-we-write-super-props/)中提到的，**你并不 _需要_ 知道这个才能高效使用 React。** 我好几年都不知道这个。请不要把这变成一道面试题。事实上，这篇博客更多的是关于 JavaScript 而不是 React。

这篇博客是写给想知道 React 具体是 _如何_ 工作的好奇读者的。你是那样的人吗？那我们开始吧。

**这将是一段漫长的旅程。系好安全带。这篇文章并没有多少关于 React 本身的信息，但我们会涉及到 `new`、`this`、`class`、箭头函数、`prototype`、`__proto__`、`instanceof` 等方面，以及这些东西是如何在 JavaScript 中一起工作的。幸运的是，你并不需要在 _使用_ React 时一直想着这些，除非你正在实现 React ...**

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

在过去，JavaScript 还没有类。但是，你可以使用普通函数来表示模拟。**具体来讲，只要在函数调用前加上 `new` 操作符，你就可以把 _任何_ 函数当做一个类的构造函数来用：**

```
// 只是一个函数
function Person(name) {
  this.name = name;
}

var fred = new Person('Fred'); // ✅ Person {name: 'Fred'}
var george = Person('George'); // 🔴 没用的
```

现在你依然可以这样写！在 DevTools 里试试吧。

如果你调用 `Person('Fred')` 时**没有**加 `new`，其中的 `this` 会指向某个全局且无用的东西（比如说，`window` 或者 `undefined`）。所以我们的代码会崩溃，或者做一些像设置 `window.name` 一样的傻事。

通过在调用前增加 `new`， 我们说：“嘿 JavaScript，我知道 `Person` 只是个函数，但让我们假装它是个构造函数吧。 **创建一个 `{}` 对象并把 `Person` 中的 `this` 指向那个对象，以便我可以通过类似 `this.name` 的形式去设置一些东西。然后把这个对象返回给我。**”

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

`new` 在 JavaScript 中已经存在了好久了。然而类还只是最近的事。这使得我们能够重构我们前面的代码以使它更符合我们的本意：

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

_捕捉开发者的本意_ 是语言和 API 设计中非常重要的一点。

如果你写了一个函数，JavaScript 没办法判断它应该像 `alert()` 一样被调用，还是应该被视作像 `new Person()` 的构造函数。 忘记给像 `Person` 这样的函数指定 `new` 会导致令人费解的行为。

**类语法允许我们说：“这不仅仅是个函数 — 这是个类并且它有构造函数”.** 如果你在调用它时忘了加 `new`， JavaScript 会报错：

```
let fred = new Person('Fred');
// ✅  如果 Person 是个函数：有效
// ✅  如果 Person 是个类：依然有效

let george = Person('George'); // 我们忘记使用 `new`
// 😳 如果 Person 是个长得像构造函数的方法：令人困惑的行为
// 🔴 如果 Person 是个类：立即失败
```

这帮助我们在早期捕捉错误，而不会遇到类似 `this.name` 被当成 `window.name` 而不是 `george.name` 被对待的隐晦错误。

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

这意味着麻烦

* * *

在我们看到 React 如何处理这个问题之前，我们需要铭记大部分 React 的用户会使用诸如 Babel 的编译器来把类等现代化的特性编译走以便能在老旧的浏览器上运行。因此我们需要在我们的设计中考虑编译器。

在 Babel 的早期版本中，类不加 `new` 也可以被调用。但这个问题已经被修复了 — 通过生成外的代码。

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

你或许已经在你构建出来的包中坚果类似的代码。这就是那些 `_classCallCheck` 函数做的事。（你可以通过启用“loose mode”来关闭检查以减小打出来的包的尺寸，但这或许会使你最终转向原生类时变得复杂）

* * *

至此，你应该已经大致理解了调用时加不加 `new` 的差别：

|            | `new Person()`               | `Person()`                          |
| ---------- | ---------------------------- | ----------------------------------- |
| `class`    | ✅ `this` 是一个 `Person` 实例 | 🔴 `TypeError`                      |
| `function` | ✅ `this` 是一个 `Person` 实例 | 😳 `this` 是 `window` 或 `undefined` |

这就是为什么让 React 正确调用你的组件是这么的重要。 **如果你的组件被定义为一个类， React 需要使用 `new` 来调用它**

所以 React 能检查出某样东西是否是类呢？

没那么容易！ 即便我们能够 [在 JavaScript 中区分类和函数](https://stackoverflow.com/questions/29093396/how-do-you-check-the-difference-between-an-ecmascript-6-class-and-function)，面对被 Babel 等工具处理过的类这还是没用。对浏览器而言，它们只是不同的函数。这是 React 的不幸。

* * *

好，那么或许 React 可以直接在每次调用时都加上 `new`？很遗憾，这也并不总是有用。

对于常规函数，用 `new` 调用会给它们一个 `this` 作为对象实例。对于写作构造函数的函数（比如我们前面提到的 `Person`）是可取的，但对函数组件这就或许就比较令人困惑了：

```
function Greeting() {
  // 这里我们并不期望 `this` 是任何类型的实例
  return <p>Hello</p>;
}
```

这暂且还能忍，还有两个 _其他_ 理由会扼杀这个想法。

* * *

第一个理由是 why always using `new` wouldn’t work is that for native arrow functions (not the ones compiled by Babel), calling with `new` throws an error:

```
const Greeting = () => <p>Hello</p>;
new Greeting(); // 🔴 Greeting is not a constructor
```

This behavior is intentional and follows from the design of arrow functions. One of the main perks of arrow functions is that they _don’t_ have their own `this` value — instead, `this` is resolved from the closest regular function:

```
class Friends extends React.Component {
    render() {    const friends = this.props.friends;
    return friends.map(friend =>
        <Friend
        // `this` is resolved from the `render` method        size={this.props.size}        name={friend.name}
        key={friend.id}
        />
    );
    }
}
```

Okay, so **arrow functions don’t have their own `this`.** But that means they would be entirely useless as constructors!

```
const Person = (name) => {
    // 🔴 This wouldn’t make sense!
    this.name = name;
}
```

Therefore, **JavaScript disallows calling an arrow function with `new`.** If you do it, you probably made a mistake anyway, and it’s best to tell you early. This is similar to how JavaScript doesn’t let you call a class _without_ `new`.

This is nice but it also foils our plan. React can’t just call `new` on everything because it would break arrow functions! We could try detecting arrow functions specifically by their lack of `prototype`, and not `new` just them:

```
(() => {}).prototype // undefined
(function() {}).prototype // {constructor: f}
```

But this [wouldn’t work](https://github.com/facebook/react/issues/4599#issuecomment-136562930) for functions compiled with Babel. This might not be a big deal, but there is another reason that makes this approach a dead end.

* * *

Another reason we can’t always use `new` is that it would preclude React from supporting components that return strings or other primitive types.

```
function Greeting() {
    return 'Hello';
}

Greeting(); // ✅ 'Hello'
new Greeting(); // 😳 Greeting {}
```

This, again, has to do with the quirks of the [`new` operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new) design. As we saw earlier, `new` tells the JavaScript engine to create an object, make that object `this` inside the function, and later give us that object as a result of `new`.

However, JavaScript also allows a function called with `new` to _override_ the return value of `new` by returning some other object. Presumably, this was considered useful for patterns like pooling where we want to reuse instances:

```
// Created lazilyvar zeroVector = null;
function Vector(x, y) {
    if (x === 0 && y === 0) {
    if (zeroVector !== null) {
        // Reuse the same instance      return zeroVector;    }
    zeroVector = this;
    }
    this.x = x;
    this.y = y;
}

var a = new Vector(1, 1);
var b = new Vector(0, 0);var c = new Vector(0, 0); // 😲 b === c
```

However, `new` also _completely ignores_ a function’s return value if it’s _not_ an object. If you return a string or a number, it’s like there was no `return` at all.

```
function Answer() {
    return 42;
}

Answer(); // ✅ 42
new Answer(); // 😳 Answer {}
```

There is just no way to read a primitive return value (like a number or a string) from a function when calling it with `new`. So if React always used `new`, it would be unable to add support components that return strings!

That’s unacceptable so we need to compromise.

* * *

What did we learn so far? React needs to call classes (including Babel output) _with_ `new` but it needs to call regular functions or arrow functions (including Babel output) _without_ `new`. And there is no reliable way to distinguish them.

**If we can’t solve a general problem, can we solve a more specific one?**

When you define a component as a class, you’ll likely want to extend `React.Component` for built-in methods like `this.setState()`. **Rather than try to detect all classes, can we detect only `React.Component` descendants?**

Spoiler: this is exactly what React does.

* * *

Perhaps, the idiomatic way to check if `Greeting` is a React component class is by testing if `Greeting.prototype instanceof React.Component`:

```
class A {}
class B extends A {}

console.log(B.prototype instanceof A); // true
```

I know what you’re thinking. What just happened here?! To answer this, we need to understand JavaScript prototypes.

You might be familiar with the “prototype chain”. Every object in JavaScript might have a “prototype”. When we write `fred.sayHi()` but `fred` object has no `sayHi` property, we look for `sayHi` property on `fred`’s prototype. If we don’t find it there, we look at the next prototype in the chain — `fred`’s prototype’s prototype. And so on.

**Confusingly, the `prototype` property of a class or a function _does not_ point to the prototype of that value.** I’m not kidding.

```
function Person() {}

console.log(Person.prototype); // 🤪 Not Person's prototype
console.log(Person.__proto__); // 😳 Person's prototype
```

So the “prototype chain” is more like `__proto__.__proto__.__proto__` than `prototype.prototype.prototype`. This took me years to get.

What’s the `prototype` property on a function or a class, then? **It’s the `__proto__` given to all objects `new`ed with that class or a function!**

```
function Person(name) {
    this.name = name;
}
Person.prototype.sayHi = function() {
    alert('Hi, I am ' + this.name);
}

var fred = new Person('Fred'); // Sets `fred.__proto__` to `Person.prototype`
```

And that `__proto__` chain is how JavaScript looks up properties:

```
fred.sayHi();
// 1. Does fred have a sayHi property? No.
// 2. Does fred.__proto__ have a sayHi property? Yes. Call it!

fred.toString();
// 1. Does fred have a toString property? No.
// 2. Does fred.__proto__ have a toString property? No.
// 3. Does fred.__proto__.__proto__ have a toString property? Yes. Call it!
```

In practice, you should almost never need to touch `__proto__` from the code directly unless you’re debugging something related to the prototype chain. If you want to make stuff available on `fred.__proto__`, you’re supposed to put it on `Person.prototype`. At least that’s how it was originally designed.

The `__proto__` property wasn’t even supposed to be exposed by browsers at first because the prototype chain was considered an internal concept. But some browsers added `__proto__` and eventually it was begrudgingly standardized (but deprecated in favor of `Object.getPrototypeOf()`).

**And yet I still find it very confusing that a property called `prototype` does not give you a value’s prototype** (for example, `fred.prototype` is undefined because `fred` is not a function). Personally, I think this is the biggest reason even experienced developers tend to misunderstand JavaScript prototypes.

* * *

This is a long post, eh? I’d say we’re 80% there. Hang on.

We know that when say `obj.foo`, JavaScript actually looks for `foo` in `obj`, `obj.__proto__`, `obj.__proto__.__proto__`, and so on.

With classes, you’re not exposed directly to this mechanism, but `extends` also works on top of the good old prototype chain. That’s how our React class instance gets access to methods like `setState`:

```
class Greeting extends React.Component {  render() {
    return <p>Hello</p>;
    }
}

let c = new Greeting();
console.log(c.__proto__); // Greeting.prototype
console.log(c.__proto__.__proto__); // React.Component.prototypeconsole.log(c.__proto__.__proto__.__proto__); // Object.prototype

c.render();      // Found on c.__proto__ (Greeting.prototype)
c.setState();    // Found on c.__proto__.__proto__ (React.Component.prototype)c.toString();    // Found on c.__proto__.__proto__.__proto__ (Object.prototype)
```

In other words, **when you use classes, an instance’s `__proto__` chain “mirrors” the class hierarchy:**

```
// `extends` chain
Greeting
    → React.Component
    → Object (implicitly)

// `__proto__` chain
new Greeting()
    → Greeting.prototype
    → React.Component.prototype
        → Object.prototype
```

2 Chainz.

* * *

Since the `__proto__` chain mirrors the class hierarchy, we can check whether a `Greeting` extends `React.Component` by starting with `Greeting.prototype`, and then following down its `__proto__` chain:

```
// `__proto__` chain
new Greeting()
    → Greeting.prototype // 🕵️ We start here    → React.Component.prototype // ✅ Found it!      → Object.prototype
```

Conveniently, `x instanceof Y` does exactly this kind of search. It follows the `x.__proto__` chain looking for `Y.prototype` there.

Normally, it’s used to determine whether something is an instance of a class:

```
let greeting = new Greeting();

console.log(greeting instanceof Greeting); // true
// greeting (🕵️‍ We start here)
//   .__proto__ → Greeting.prototype (✅ Found it!)
//     .__proto__ → React.Component.prototype
//       .__proto__ → Object.prototype

console.log(greeting instanceof React.Component); // true
// greeting (🕵️‍ We start here)
//   .__proto__ → Greeting.prototype
//     .__proto__ → React.Component.prototype (✅ Found it!)
//       .__proto__ → Object.prototype

console.log(greeting instanceof Object); // true
// greeting (🕵️‍ We start here)
//   .__proto__ → Greeting.prototype
//     .__proto__ → React.Component.prototype
//       .__proto__ → Object.prototype (✅ Found it!)

console.log(greeting instanceof Banana); // false
// greeting (🕵️‍ We start here)
//   .__proto__ → Greeting.prototype
//     .__proto__ → React.Component.prototype
//       .__proto__ → Object.prototype (🙅‍ Did not find it!)
```

But it would work just as fine to determine if a class extends another class:

```
console.log(Greeting.prototype instanceof React.Component);
// greeting
//   .__proto__ → Greeting.prototype (🕵️‍ We start here)
//     .__proto__ → React.Component.prototype (✅ Found it!)
//       .__proto__ → Object.prototype
```

And that check is how we could determine if something is a React component class or a regular function.

* * *

That’s not what React does though. 😳

One caveat to the `instanceof` solution is that it doesn’t work when there are multiple copies of React on the page, and the component we’re checking inherits from _another_ React copy’s `React.Component`. Mixing multiple copies of React in a single project is bad for several reasons but historically we’ve tried to avoid issues when possible. (With Hooks, we [might need to](https://github.com/facebook/react/issues/13991) force deduplication though.)

One other possible heuristic could be to check for presence of a `render` method on the prototype. However, at the time it [wasn’t clear](https://github.com/facebook/react/issues/4599#issuecomment-129714112) how the component API would evolve. Every check has a cost so we wouldn’t want to add more than one. This would also not work if `render` was defined as an instance method, such as with the class property syntax.

So instead, React [added](https://github.com/facebook/react/pull/4663) a special flag to the base component. React checks for the presence of that flag, and that’s how it knows whether something is a React component class or not.

Originally the flag was on the base `React.Component` class itself:

```
// Inside React
class Component {}
Component.isReactClass = {};

// We can check it like this
class Greeting extends Component {}
console.log(Greeting.isReactClass); // ✅ Yes
```

However, some class implementations we wanted to target [did not](https://github.com/scala-js/scala-js/issues/1900) copy static properties (or set the non-standard `__proto__`), so the flag was getting lost.

This is why React [moved](https://github.com/facebook/react/pull/5021) this flag to `React.Component.prototype`:

```
// Inside React
class Component {}
Component.prototype.isReactComponent = {};

// We can check it like this
class Greeting extends Component {}
console.log(Greeting.prototype.isReactComponent); // ✅ Yes
```

**And this is literally all there is to it.**

You might be wondering why it’s an object and not just a boolean. It doesn’t matter much in practice but early versions of Jest (before Jest was Good™️) had automocking turned on by default. The generated mocks omitted primitive properties, [breaking the check](https://github.com/facebook/react/pull/4663#issuecomment-136533373). Thanks, Jest.

The `isReactComponent` check is [used in React](https://github.com/facebook/react/blob/769b1f270e1251d9dbdce0fcbd9e92e502d059b8/packages/react-reconciler/src/ReactFiber.js#L297-L300) to this day.

If you don’t extend `React.Component`, React won’t find `isReactComponent` on the prototype, and won’t treat component as a class. Now you know why [the most upvoted answer](https://stackoverflow.com/a/42680526/458193) for `Cannot call a class as a function` error is to add `extends React.Component`. Finally, a [warning was added](https://github.com/facebook/react/pull/11168) that warns when `prototype.render` exists but `prototype.isReactComponent` doesn’t.

* * *

You might say this story is a bit of a bait-and-switch. **The actual solution is really simple, but I went on a huge tangent to explain _why_ React ended up with this solution, and what the alternatives were.**

In my experience, that’s often the case with library APIs. For an API to be simple to use, you often need to consider the language semantics (possibly, for several languages, including future directions), runtime performance, ergonomics with and without compile-time steps, the state of the ecosystem and packaging solutions, early warnings, and many other things. The end result might not always be the most elegant, but it must be practical.

**If the final API is successful, _its users_ never have to think about this process.** Instead they can focus on creating apps.

But if you’re also curious… it’s nice to know how it works.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
