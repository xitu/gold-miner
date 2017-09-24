
> * 原文地址：[Why Composition is Harder with Classes](https://medium.com/javascript-scene/why-composition-is-harder-with-classes-c3e627dcd0aa)
> * 原文作者：[
Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/why-composition-is-harder-with-classes.md](https://github.com/xitu/gold-miner/blob/master/TODO/why-composition-is-harder-with-classes.md)
> * 译者：
> * 校对者：

# Why Composition is Harder with Classes

![Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

> Note: This is part of the “Composing Software” series on learning functional programming and compositional software techniques in JavaScript ES6+ from the ground up. Stay tuned. There’s a lot more of this to come!

Previously, we examined factory functions and looked at how easy it is to use them for composition using functional mixins. Now we’re going to look at classes in more detail, and examine how the mechanics of `class` get in the way of composition.

We’ll also take a look at the good use-cases for classes and how to use them safely.

ES6 includes a convenient `class` syntax, so you may be wondering why we should care about factories at all. The most obvious difference is that constructors and `class` require the `new` keyword. But what does `new` actually do?

- Creates a new object and binds `this` to it in the constructor function.
- Implicitly returns `this`, unless you explicitly return another object.
- Sets the instance `[[Prototype]]` (an internal reference) to `Constructor.prototype`, so that `Object.getPrototypeOf(instance) === Constructor.prototype`.
- Sets the `instance.constructor === Constructor`.

All of that implies that, unlike factory functions, classes are not a good solution for composing functional mixins. You can still achieve composition using `class`, but it’s a much more complex process, and as you’ll see, the additional costs are usually not worth the extra effort.

## The Delegate Prototype

You may eventually need to refactor from a class to a factory function, and if you require callers to use the `new` keyword, that refactor could break client code you’re not even aware of in a couple of ways. First, unlike classes and constructors, factory functions don’t automatically wire up a delegate prototype link.

The `[[Prototype]]` link is used for prototype delegation, which is a convenient way to conserve memory if you have millions of objects, or to squeeze a micro-performance boost out of your program if you need to access tens of thousands of properties on an object within a 16 ms render loop cycle.

If you don’t need to micro-optimize memory or performance, the `[[Prototype]]` link can do more harm than good. The prototype chain powers the `instanceof` operator in JavaScript, and unfortunately `instanceof` lies for two reasons:

In ES5, the `Constructor.prototype` link was dynamic and reconfigurable, which could be a handy feature if you need to create an abstract factory — but if you use that feature, `instanceof` will give you false negatives if the `Constructor.prototype` does not currently reference the same object in memory that the instance `[[Prototype]]` references:

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
User.prototype = {};
console.log(
  currentUser instanceof User, // <-- false -- Oops!
// But it clearly has the correct shape:
  // { avatar: "foo.png", userName: "Foo" }
  currentUser
);
```

Chrome solves the problem by making the `Constructor.prototype` property `configurable: false` in the property descriptor. However, Babel does not currently mirror that behavior, so Babel compiled code will behave like ES5 constructors. V8 silently fails if you attempt to reconfigure the `Constructor.prototype` property. Either way, you won’t get the results you expected. Worse: the behavior is inconsistent. I don’t recommend reassigning `Constructor.prototype`.

A more common problem is that JavaScript has multiple execution contexts — memory sandboxes where the same code will access different physical memory locations. If you have a constructor in a parent frame, for example, and the same constructor in an `iframe`, the parent frame’s `Constructor.prototype` will not reference the same memory location as the `Constructor.prototype` in the `iframe`. Object values in JavaScript are memory references under the hood, and different frames point to different locations in memory, so `===` checks will fail.

Another problem with `instanceof` is that it is a nominal type check rather than a structural type check, which means that if you start with a `class` and later switch to an abstract factory, all the calling code using `instanceof` won’t understand new implementations even if they satisfy the same interface contract. For example, say you’re tasked with building a music player interface. Later on the product team tells you to add support for videos. Later still, they ask you to add support for 360 videos. They all supply the same controls: play, stop, rewind, fast forward.

But if you’re using `instanceof` checks, members of your video interface class won’t satisfy the `foo instanceof AudioInterface` checks already in the codebase.

They’ll fail when they should succeed. Sharable interfaces in other languages solve this problem by allowing a class to declare that it implements a specific interface. That’s not currently possible in JavaScript.

The best way to deal with `instanceof` in JavaScript is to break the delegate prototype link if it’s not required, and let instanceof fail hard for every call. That way you won’t get a false sense of reliability. Don’t listen to `instanceof`, and it will never lie to you.

## The .constructor Property

The `.constructor` property is a rarely used feature in JavaScript, but it could be very useful, and it’s a good idea to include it on your object instances. It’s mostly harmless if you don’t try to use it for type checking (which is unsafe for the same reasons `instanceof` is unsafe).

**In theory**, `.constructor` could be useful to make generic functions which are capable of returning a new instance of whatever object you pass in.

**In practice**, there are many different ways to create new instances of things in JavaScript — having a reference to the constructor is not the same thing as knowing how to instantiate a new object with it — even for seemingly trivial purposes, such as creating an empty instance of a given object:

```
// Return an empty instance of any object type?
const empty = ({ constructor } = {}) => constructor ?
  new constructor() :
  undefined
;
const foo = [10];
console.log(
  empty(foo) // []
);
```

It seems to work with Arrays. Let’s try it with Promises:

```
// Return an empty instance of any type?
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

Note the `new` keyword in the code. That’s most of the problem. It’s not safe to assume that you can use the `new` keyword with any factory function. Sometimes, that will cause errors.

What we would need to make this work is to have a standard way to pass a value into a new instance using a standard factory function that doesn’t require `new`. There is a specification for that: a static method on any factory or constructor called `.of()`. [The](https://github.com/fantasyland/fantasy-land#of-method) [`.of()`](https://github.com/fantasyland/fantasy-land#of-method) [method](https://github.com/fantasyland/fantasy-land#of-method) is a factory that returns a new instance of the data type containing whatever you pass into `.of()`.

We could use `.of()` to create a better version of the generic `empty()` function:

```
// Return an empty instance of any type?
const empty = ({ constructor } = {}) => constructor.of ?
  constructor.of() :
  undefined
;
const foo = [23];
console.log(
  empty(foo) // []
);
```

Unfortunately, the static `.of()` method is just beginning to gain support in JavaScript. The `Promise` object does have a static method that acts like `.of()`, but it’s called `.resolve()` instead, so our generic `empty()` won’t work with promises:

```
// Return an empty instance of any type?
const empty = ({ constructor } = {}) => constructor.of ?
  constructor.of() :
  undefined
;
const foo = Promise.resolve(10);
console.log(
  empty(foo) // undefined
);
```

Likewise, there’s no `.of()` for strings, numbers, objects, maps, weak maps, or sets in JavaScript as of this writing.

If support for the `.of()` method catches on in other standard JavaScript data types, the `.constructor` property could eventually become a much more useful feature of the language. We could use it to build a rich library of utility functions capable of acting on a variety of functors, monads, and other algebraic datatypes.

It’s easy to add support for `.constructor` and `.of()` to a factory:

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
// testing .of and .constructor:
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

You can even make `.constructor` non-enumerable by adding to the delegate prototype with `Object.create()`:

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

## Class to Factory is a Breaking Change

Factories allow increased flexibility in the following ways:

- Decouple instantiation details from calling code.
- Allow you to return arbitrary objects — for instance, to use an object pool to tame the garbage collector.
- Don’t pretend to provide any type guarantees, so callers are less tempted to use `instanceof` and other unreliable type checking measures, which might break code across execution contexts, or if you switch to an abstract factory.
- Because they don’t pretend to provide type guarantees, factories can dynamically swap implementations for abstract factories. e.g., a media player that swaps out the `.play()` method for different media types.
- Adding capability with composition is easier with factories.

While it’s possible to accomplish most of these goals using classes, it’s easier to do so with factories. There are fewer potential bug pitfalls, less complexity to juggle, and a lot less code.

For these reasons, it’s often desirable to refactor from a `class` to a factory, but it can be a complex, error prone process. Refactoring from classes to factories is a common need in every OO language. You can read more about it in [“Refactoring: Improving the Design of Existing Code”](https://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672/ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=eejs-20&linkId=e7d5f652bc860f02c27ec352e1b8342c) by Martin Fowler, Kent Beck, John Brant, William Opdyke, and Don Roberts.

Due to the fact that `new` changes the behavior of a function being called, changing from a class or constructor to a factory function is a potentially breaking change. In other words, forcing callers to use `new` could unwittingly lock callers into the constructor implementation, so `new` leaks potentially breaking implementation details into the calling API.

As we have already seen, the following implicit behaviors can make the switch a breaking change:

- Absence of the `[[Prototype]]` link from factory instances will break caller `instanceof` checks.
- Absence of the `.constructor` property from factory instances could break code that relies on it.

Both problems can be remedied by manually hooking those properties up in your factories.

Internally, you’ll also need to be mindful that `this` may be dynamically bound from factory call sites, which is not the case when callers use `new`. That can complicate matters if you want to store alternate abstract factory prototypes as static properties on the factory.

There is another problem, too. All `class` callers must use `new`. Leaving it off in ES6 will always throw:

```
class Foo {};
// TypeError: Class constructor Foo cannot be invoked without 'new'
const Bar = Foo();
```

In ES6+, arrow functions are commonly used to create factories, but because arrow functions don’t have their own this binding in JavaScript, invoking an arrow function with new throws an error:

```
const foo = () => ({});
// TypeError: foo is not a constructor
const bar = new foo();
```

So, if you try to refactor from a class to an arrow function factory, it will fail in native ES6 environments, which is OK. Failing hard is a good thing.

But, if you compile arrow functions to standard functions, it will fail to fail. That’s bad, because it should be an error. It will “work” while you’re building the app, but potentially fail in production where it could impact the user experience, or even prevent the app from working at all.

A change in the compiler default settings could break your app, even if you didn’t change any of your own code. That gotcha bears repeating:

> **Warning:** Refactoring from a `class` to an arrow function factory might seem to work with a compiler, but if the code compiles the factory to a native arrow function, your app will break because you can’t use `new` with arrow functions.

## Code that Requires new Violates the Open/Closed Principle

Our APIs should be open to extension, but closed to breaking changes. Since a common extension to a class is to turn it into a more flexible factory, but that refactor is a breaking change, code that requires the `new` keyword is closed for extension and open to breaking changes. That’s the opposite of what we want.

The impact of this is larger than it seems at first. If your `class` API is public, or if you work on a very large app with a very large team, the refactor is likely to break code you’re not even aware of. It’s a better idea to deprecate the class entirely and replace it with a factory function to move forward.

That process changes a small technical problem that can be solved silently by code into an unbounded people problem that requires awareness, education, and buy-in — a much more expensive refactor!

I’ve seen the `new` issue cause very expensive headaches many times, and it’s trivially easy to avoid:

> Export a factory instead of a class.

## The class Keyword and extends

The `class` keyword is supposed to be a nicer syntax for object creation patterns in JavaScript, but it falls short in several ways:

### Friendly Syntax

The primary purpose of `class` was to provide a friendly syntax to mimic `class` from other languages in JavaScript. The question we should ask ourselves though is, does JavaScript really need to mimic `class` from other languages?

JavaScript’s factory functions provide a friendlier syntax out of the box, with much less complexity. Often, an object literal is good enough. If you need to create many instances, factories are a good next step.

In Java and C++, factories are more complicated than classes, but they’re often worth building anyway because they provide enhanced flexibility. In JavaScript, factories are less complicated and more flexible than classes.

Compare the class:

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

Vs the equivalent factory…

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

With JavaScript and arrow function familiarity, factories are clearly less syntax and easier to read. Maybe you prefer to see the `new` keyword, but there are good reasons to avoid `new`. [Familiarity bias may be holding you back](https://medium.com/javascript-scene/familiarity-bias-is-holding-you-back-its-time-to-embrace-arrow-functions-3d37e1a9bb75).

What other arguments are there?

## Performance and Memory

> Good use-cases for delegate prototypes are rare.

`class` syntax is a little nicer than the equivalent syntax for ES5 constructor functions, but the primary purpose is to hook up the delegate prototype chain, and good use-cases for delegate prototypes are rare. It really boils down to performance.

`class` offers two kinds of performance optimizations: Property lookup optimizations and shared memory for properties stored on the delegate prototype.

Most modern devices have RAM measured in gigabytes and any type of closure scope or property lookup is measured in hundreds of thousands or millions of ops/second, so performance differences are rarely measurable in the context of an application, let alone impactful.

There are exceptions, of course. RxJS used `class` instances because they’re faster than closure scopes, but RxJS is a general purpose utility library that might be used in the context of hundreds of thousands operations that need to be squeezed into a 16ms render loop.

ThreeJS uses classes, but ThreeJS is a 3d rendering library which might be used for game engines manipulating thousands of objects every 16ms.

It makes sense for libraries like ThreeJS and RxJS to go to extremes optimizing wherever they can.

In the context of applications, we should avoid premature optimization, and focus our efforts only where they’ll make a large impact. For most applications, that means our network calls & payloads, animations, asset caching strategies, etc…

Don’t micro-optimize for performance unless you’ve noticed a performance problem, profiled your application code, and pinpointed a real bottleneck.

Instead, you should optimize code for maintenance and flexibility.

## Type Checking

Classes in JavaScript are dynamic, and `instanceof` checks don’t work across execution contexts, so type checking based on `class` is a non-starter. It’s unreliable. It’s likely to cause bugs and make your application unnecessarily rigid.

## Class Inheritance with `extends`

Class inheritance causes several well-known problems that bear repeating:

- **Tight coupling**: Class inheritance is the tightest form of coupling available in object-oriented design.
- **Inflexible hierarchies**: Given enough time and users, all class hierarchies are eventually wrong for new use-cases, but tight coupling makes refactors difficult.
- **Gorilla/Banana problem**: No selective inheritance. “You wanted a banana but what you got was a gorilla holding the banana and the entire jungle.” ~ Joe Armstrong in “[Coders at Work](https://www.amazon.com/Coders-Work-Reflections-Craft-Programming/dp/1430219483/ref=as_li_ss_tl?s=books&ie=UTF8&qid=1500436305&sr=1-1&keywords=coders+at+work&linkCode=ll1&tag=eejs-20&linkId=45e89bc5d776b1326c2ae90355e9ccac)”
- **Duplication by necessity**: Due to inflexible hierarchies and the gorilla/banana problem, code reuse is often accomplished by copy/paste, violating DRY (Don’t Repeat Yourself) and defeating the entire purpose of inheritance in the first place.

The only purpose of `extends` is to create single-ancestor class taxonomies. Some clever hacker will read this and say, “Ah hah! Not so! You can do class composition!” To which I would answer, “ah, but now you’re using object composition instead of class inheritance, and there are easier, safer ways to do that in JavaScript without `extends`.”

## Classes are OK if You’re Careful

With all the warnings out of the way, some clear guidelines emerge that can help you use classes safely:

- Avoid `instanceof` — it lies because JavaScript is dynamic and has multiple execution contexts, and `instanceof` fails in both situations. It can also cause problems if you switch to an abstract factory down the road.
- Avoid `extends` — don’t extend a single hierarchy more than once. “Favor object composition over class inheritance.” ~ [“Design Patterns: Elements of Reusable Object-Oriented Software”](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented-ebook/dp/B000SEIBB8/ref=as_li_ss_tl?s=digital-text&ie=UTF8&qid=1500478917&sr=1-1&keywords=design+patterns&linkCode=ll1&tag=eejs-20&linkId=7443052c45c6e7d9cb7f6b06fa58b488)
- Avoid exporting your class. Use `class` internally for performance gains, but export a factory that creates instances in order to discourage users from extending your class and avoid forcing callers to use `new`.
- Avoid `new`. Try to avoid using it directly whenever it makes sense, and don’t force your callers to use it. (Export a factory, instead).

It’s OK to use class if:

- **You’re building UI components for a framework** like React or Angular. Both frameworks wrap your component classes into factories and manage instantiation for you, so you don’t have to use `new` in your own code.
- **You never inherit from your own classes or components**. Instead, try object composition, function composition, higher order functions, higher order components, or modules — all of them are better code reuse patterns than class inheritance.
- **You need to optimize performance**. Just remember to export a factory so callers don’t have to use `new` and don’t get lured into the `extends` trap.

In most other situations, factories will serve you better.

Factories are simpler than classes or constructors in JavaScript. Always start with the simplest solution and progress to more complex solutions only as-needed.

[Next: Composable Datatypes with Functions >](https://medium.com/javascript-scene/composable-datatypes-with-functions-aec72db3b093)

## Next Steps

Want to learn more about object composition with JavaScript?

[Learn JavaScript with Eric Elliott.](http://ericelliottjs.com/product/lifetime-access-pass/) If you’re not a member, you’re missing out!

![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)

**Eric Elliott** is the author of [“Programming JavaScript Applications”](http://pjabook.com/) (O’Reilly), and [“Learn JavaScript with Eric Elliott”](http://ericelliottjs.com/product/lifetime-access-pass/). He has contributed to software experiences for **Adobe Systems**, **Zumba Fitness**, **The Wall Street Journal**, **ESPN**, **BBC**, and top recording artists including **Usher**, **Frank Ocean**, **Metallica**, and many more.

He spends most of his time in the San Francisco Bay Area with the most beautiful woman in the world.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
