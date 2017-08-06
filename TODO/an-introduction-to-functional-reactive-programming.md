> * 原文地址：[An Introduction to Functional Reactive Programming](http://blog.danlew.net/2017/07/27/an-introduction-to-functional-reactive-programming/)
> * 原文作者：[Daniel Lew](https://github.com/dlew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/an-introduction-to-functional-reactive-programming.md](https://github.com/xitu/gold-miner/blob/master/TODO/an-introduction-to-functional-reactive-programming.md)
> * 译者：
> * 校对者：

# An Introduction to Functional Reactive Programming

I gave a talk this year about functional reactive programming (FRP) that attempted to break down what gives FRP its name and why you should care. Here's a write-up of that talk.

---

## Introduction

Functional reactive programming has been all the rage in the past few years. But what is it, exactly? And why should you care?

Even for people who are currently using FRP frameworks like RxJava, the fundamental reasoning behind FRP may be mysterious. I'm going to break down that mystery today, doing so by splitting up FRP into its individual components: reactive programming and functional programming.

## Reactive Programming

[![](http://blog.danlew.net/content/images/2017/07/slide01-1.png)](http://blog.danlew.net/content/images/2017/07/slide01-1.png)

First, let's take a look at what it means to write reactive code.

Let's start with a simple example: a switch and a light bulb. As you flick the switch, the light bulb turns on and off.

In coding terms, the two components are coupled. Usually you don't give much thought to *how* they are coupled, but let's dig deeper.

[![](http://blog.danlew.net/content/images/2017/07/slide02-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide02.png)

One approach is to have the switch modify the state of the bulb. In this case, the switch is **proactive**, pushing new states to the bulb; whereas the bulb is **passive**, simply receiving commands to change its state.

We'll represent this relationship by putting the arrow on the switch - that is, the one connecting the two components is the switch, not the bulb.

[![](http://blog.danlew.net/content/images/2017/07/slide03-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide03.png)

Here's a sketch of the proactive solution: the `Switch` contains an instance of the `LightBulb`, which it then modifies whenever its state changes.

[![](http://blog.danlew.net/content/images/2017/07/slide04-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide04.png)

The other way to couple these components would be to have the bulb listen to the state of the switch then modify itself accordingly. In this model, the bulb is **reactive**, changing its state based on the switch's state; whereas the switch is **observable**, in that others can observe its state changes.

[![](http://blog.danlew.net/content/images/2017/07/slide05-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide05.png)

Here's a sketch of the reactive solution: the `LightBulb` takes in a `Switch` that it listens to for events, then modifies its own state based on the listener.

[![](http://blog.danlew.net/content/images/2017/07/slide06-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide06.png)

To the end user, both the proactive and reactive code lead to the same result. What are the differences between each approach?

The first difference is who controls the `LightBulb`. In the proactive model, it must be some *external* component that calls `LightBulb.power()`. With reactive, it is the `LightBulb` itself that controls its luminosity.

The second difference is who determines what the `Switch` controls. In the proactive model, the `Switch` itself determines who it controls. In the reactive model, the `Switch` is ignorant of what it's driving, since others hook into it via a listener.

You get the sense that the two models are mirror images of each other. There's a duality between proactive and reactive coding.


However, there is a subtle difference in how tightly or loosely coupled the two components are. In the proactive model, modules control each other directly. In the reactive model, modules control themselves and hook up to each other indirectly.

[![](http://blog.danlew.net/content/images/2017/07/slide07-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide07.png)

Let's see how this plays out in a real-life example. Here's the Trello home screen. It's showing the boards you have from the database. How does this relationship play out with a proactive or reactive model?

[![](http://blog.danlew.net/content/images/2017/07/slide08-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide08.png)

With a proactive model, whenever the database changes, it pushes those changes to the UI. But this doesn't make any sense: Why does my database have to care about the UI at all? Why should it have to check if the home screen is being displayed, and know whether it should push new data to it? The proactive model creates a bizarrely tight coupling between my DB and my UI.

[![](http://blog.danlew.net/content/images/2017/07/slide09-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide09.png)

The reactive model, by contrast, is much cleaner. Now my UI listens to changes in the database and updates itself when necessary. The database is just a dumb repository of knowledge that provides a listener. It can be updated by anyone, and those changes are simply reflected wherever they are needed in the UI.

[![](http://blog.danlew.net/content/images/2017/07/slide10-thumb.jpg)](http://blog.danlew.net/content/images/2017/07/slide10.jpg)

This is the Hollywood principle in action: don't call us, we'll call you. And it's great for loosely coupling code, allowing you to encapsulate your components.

We can now answer what reactive programming is: it's when you focus on using reactive code first, instead of your default being proactive code.

[![](http://blog.danlew.net/content/images/2017/07/slide11-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide11.png)

Our simple listener isn't great if you want to default to reactive, though. It's got a couple problems:

First, every listener is unique. We have `Switch.OnFlipListener`, but that's only usable with `Switch`. Each module that can be observed must implement its own listener setup. Not only does that mean a bunch of busywork implementing boilerplate code, it also means that you cannot reuse reactive patterns since there's no common framework to build upon.

The second problem is that every observer has to have direct access to the observable component. The `LightBulb` has to have direct access to `Switch` in order to start listening to it. That results in a tight coupling between modules, which ruins our goals.

[![](http://blog.danlew.net/content/images/2017/07/slide12-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide12.png)

What we'd really like is if `Switch.flips()` returned some generalized type that can be passed around. Let's figure out what type we could return that satisfies our needs.

[![](http://blog.danlew.net/content/images/2017/07/slide13-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide13.png)

There are four essential objects that a function can return. On one axis is how many of an item is returned: either a single item, or multiple items. On the other axis is whether the item is returned immediately (sync) or if the item represents a value that will be delivered later (async).

[![](http://blog.danlew.net/content/images/2017/07/slide14-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide14.png)

The sync returns are simple. A single return is of type `T`: any object. Likewise, multiple items is just an `Iterable<T>`.

It's simple to program with synchronous code because you can start using the returned values when you get them, but we're not in that world. Reactive coding is inherently asynchronous: there's no way to know when the observable component will emit a new state.

[![](http://blog.danlew.net/content/images/2017/07/slide15-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide15.png)

As such, let's examine async returns. A single async item is equivalent to `Future<T>`. Good, but not quite what we want yet - an observable component may have multiple items (e.g., `Switch` can be flicked on/off many times).

What we really want is in that bottom right corner. What we're going to call that last quadrant is an `Observable<T>`. An `Observable` is the basis for all reactive frameworks.

[![](http://blog.danlew.net/content/images/2017/07/slide16-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide16.png)

Let's look at how `Observable<T>` works. In our new code, `Switch.flips()` returns an `Observable<Boolean>` - that is, a sequence of true/false that represents the state of the `Switch`. Now our `LightBulb`, instead of consuming the `Switch` directly, will subscribe to an `Observable<Boolean>` that the `Switch` provides.

This code behaves the same as our non-`Observable` code, but fixes the two problems I outlined earlier. `Observable<T>` is a generalized type, allowing us to build upon it. And it can be passed around, so our components are no longer tightly coupled.

[![](http://blog.danlew.net/content/images/2017/07/slide17-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide17.png)

Let's solidify the basics of what an `Observable` is. An `Observable` is a collection of items over time.

What I'm showing here is a marble diagram. The line represents time, whereas the circles represent events that the `Observable` would push to its subscribers.

`Observable` can result in one of two possible terminal states as well: successful completions and errors.

[![](http://blog.danlew.net/content/images/2017/07/slide18-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide18.png)

A successful completion is represented by a vertical line in the marble diagram. Not all collections are infinite and it is necessary to be able to represent that. For example, if you are streaming a video on Netflix, at some point that video will end.

[![](http://blog.danlew.net/content/images/2017/07/slide19-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide19.png)

An error is represented by an X and is the result of the stream of data becoming invalid for some reason. For example, if someone took a sledgehammer to our switch, then it's worth informing everyone that our switch has not only stopped emitting any new states, but that it isn't even valid to listen to anymore because it's broken.

## Functional Programming

[![](http://blog.danlew.net/content/images/2017/07/slide20-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide20.png)

Let's set aside reactive programming for a bit and jump into what functional programming entails.

Functional programming focuses on functions. Duh, right? Well, I'm not talking about any plain old function: we're cooking with **pure functions**.

[![](http://blog.danlew.net/content/images/2017/07/slide21-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide21.png)

Let me explain what a pure function is through counter-example.

Suppose we have this perfectly reasonable `add()` function which adds two numbers together. But wait, what's in all that empty space in the function?

[![](http://blog.danlew.net/content/images/2017/07/slide22-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide22.png)

Oops! It looks like `add()` sends some text to stdout. This is what's known as a **side effect**. The goal of `add()` is not to print to stdout; it's to add two numbers. Yet it's modifying the global state of the application.

But wait, there's more.

[![](http://blog.danlew.net/content/images/2017/07/slide23-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide23.png)

Ouch! Not only does it print to stdout, but it also kills the program. If all you did was look at the function definition (two ints in, one int out) you would have no idea what devastation using this method would cause to your application.

[![](http://blog.danlew.net/content/images/2017/07/slide24-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide24.png)

Let's look at another example.

Here, we're going to take a list and see if the sum of the elements is the same as the product. I would think this would be true for `[1, 2, 3]` because `1 + 2 + 3 == 6` and `1 * 2 * 3 == 6`.

[![](http://blog.danlew.net/content/images/2017/07/slide25-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide25.png)

However, check out how the `sum()` method is implemented. It doesn't affect the global state of our app, but it does modify one of its inputs! This means that the code will misfire, because by the time `product(numbers)` is run, `numbers` will be empty. While rather contrived, this sort of problem can come up all the time in actual, impure functions.

[![](http://blog.danlew.net/content/images/2017/07/slide26-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide26.png)

A side effect occurs anytime you change state external to the function. As you can see by now, side effects can make coding difficult. Pure functions do not allow for any side effects.

Interestingly, this means that pure functions *must* return a value. Having a return type of `void` would mean that a pure function would do nothing, since it cannot modify its inputs or any state outside of the function.

It also means that your function's inputs must be immutable. We can't allow the inputs to be mutable; otherwise concurrent code could change the input while a function is executing, breaking purity. Incidentally, this also implies that outputs should also be immutable (otherwise they can't be fed as inputs to other pure functions).

[![](http://blog.danlew.net/content/images/2017/07/slide27-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide27.png)

There's a second aspect to pure functions, which is that given the same inputs, they must always return the same outputs. In other words, they cannot rely on any external state to the function.

For example, check out this function that greets a user. It doesn't have any side effects, but it randomly returns one of two greetings. The randomness is provided via an external, static function.

This makes coding much more difficult for two reasons. First, the function has inconsistent results regardless of your input. It's a lot easier to reason about code if you know that the same input to a function results in the same output. And second, you now have an external dependency inside of a function; if that external dependency is changed in any way, the function may start to behave differently.

What may be confusing to the object-oriented developer is that this means a pure function cannot even access the state of the class it is contained within. For example, `Random`'s methods are inherently impure because they return new values on each invocation, based on `Random`'s internal state.

[![](http://blog.danlew.net/content/images/2017/07/slide28-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide28.png)

In short: functional programming is based on pure functions. Pure functions are ones that don't consume or mutate external state - they depend entirely on their inputs to derive their output.

[![](http://blog.danlew.net/content/images/2017/07/slide29-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide29.png)

One point of confusion that often hits people first introduced to FP: how do you mutate anything? For example, what if I want to take a list of integers and double all their values? Surely you have to mutate the list, right?

Well, not quite. You can use a pure function that transforms the list for you. Here's a pure function that doubles the values of a list. No side effects, no external state, and no mutation of inputs/outputs. The function does the dirty mutation work for you so that you don't have to.

However, this method we've written is highly inflexible. All it can do is double each number in an array, but I can imagine many other manipulations we could do to an integer array: triple all values, halve all values... the ideas are endless.

[![](http://blog.danlew.net/content/images/2017/07/slide30-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide30.png)

Let's write a generalized integer array manipulator. We'll start with a `Function` interface; this allows us to define how we want to manipulate each integer.

Then, we'll write a `map()` function that takes both the integer array *and* a `Function`. For each integer in the array, we can apply the `Function`.

Voila! With a little extra code, we can now map *any* integer array to another integer array.

[![](http://blog.danlew.net/content/images/2017/07/slide31-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide31.png)

We can take this example even further: why not use generics so that we can transform any list from one type to another? It's not so hard to change the previous code to do so.

Now, we can map any `List<T>` to `List<R>`. For example, we can take a list of strings and convert it into a list of each string's length.

Our `map()` is known as a **higher-order function** because it takes a function as a parameter. Being able to pass around and use functions is a powerful tool because it allows code to be much more flexible. Instead of writing repetitious, instance-specific functions, you can write generalized functions like `map()` that are reusable in many circumstances.

[![](http://blog.danlew.net/content/images/2017/07/slide-31.2-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide-31.2.png)

Beyond just being easier to work with due to a lack of external state, pure functions also make it much easier to compose functions. If you know that one function is `A -> B` and another is `B -> C`, we can then stick the two functions together to create `A -> C`.

While you *could* compose impure functions, there are often unwanted side effects that occur, meaning it's hard to know if composing functions will work correctly. Only pure functions can assure coders that composition is safe.

[![](http://blog.danlew.net/content/images/2017/07/slide-31.3-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide-31.3.png)

Let's look at an example of composition. Here's another common FP function - `filter()`. It lets us narrow down the items in a list. Now we can filter our list before transforming it by composing the two functions.

We now have a couple small but powerful transformation functions, and their power is increased greatly by allowing us to compose them together.

There is far more to functional programming than what I've presented here, but this crash course is enough to understand the "FP" part of "FRP" now.

## Functional Reactive Programming

[![](http://blog.danlew.net/content/images/2017/07/slide32-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide32.png)

Let's examine how functional programming can augment reactive code.

Suppose that our `Switch`, instead of providing an `Observable<Boolean>`, instead provides its own enum-based stream `Observable<State>`.

There's seemingly no way we can use `Switch` for our `LightBulb` now since we've got incompatible generics. But there is an obvious way that `Observable<State>` mimics `Observable<Boolean>` - what if we could convert from a stream of one type to another?

Remember the `map()` function we just saw in FP? It converts a synchronous collection of one type to another. What if we could apply the same idea to an asynchronous collection like an `Observable`?

[![](http://blog.danlew.net/content/images/2017/07/slide33-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide33.png)

Ta-da: here's `map()`, but for `Observable`. `Observable.map()` is what's known as an **operator**. Operators let you transform an `Observable` stream in basically any way imagineable.

The marble diagram for an operator is a bit more complex than what we saw before. Let's break it down:
H2M_LI_HEADER The top line represents the input stream: a series of colored circles.
H2M_LI_HEADER The middle box represents the operator: converts a circle to a square.
H2M_LI_HEADER The bottom line represents the output stream: a series of colored squares.

Essentially, it's a 1:1 conversion of each item in the input stream.

[![](http://blog.danlew.net/content/images/2017/07/slide34-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide34.png)

Let's apply that to our switch problem. We start with an `Observable<State>`. Then we use `map()` so that every time a new `State` is emitted it's converted to a `Boolean`; thus `map()` returns `Observable<Boolean>`. Now that we have the correct type, we can construct our `LightBulb`.

[![](http://blog.danlew.net/content/images/2017/07/slide-34.2-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide-34.2.png)

Alright, that's useful. But what does this have to do with pure functions? Couldn't you write anything inside `map()`, including side effects? Sure, you could... but then you make the code difficult to work with. Plus, you miss out on some side-effect-free composition of operators.

Imagine our `State` enum has more than two states, but we only care about the fully on/off state. In that case, we want to filter out any in-between states. Oh look, there's a `filter()` operator in FRP as well; we can compose that with our `map()` to get the results we want.

If you compare this FRP code to the FP code I had in the previous section, you'll see how remarkably similar they are. The only difference is that the FP code was dealing with a synchronous collection, whereas the FRP code is dealing with an asynchronous collection.

[![](http://blog.danlew.net/content/images/2017/07/slide35-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide35.png)

There are a ton of operators in FRP, covering many common cases for stream manipulation, that can be applied and composed together. Let's look at a real-life example.

The Trello main screen I showed before was quite simplified - it just had a big arrow going from the database to the UI. But really, there are a bunch of sources of data that our home screen uses.

In particular, we've got source of teams, and inside of each team there can be multiple boards. We want to make sure that we're receiving this data in sync; we don't want to have mismatched data, such as a board without its parent team.

[![](http://blog.danlew.net/content/images/2017/07/slide36-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide36.png)

To solve this problem we can use the `combineLatest()` operator, which takes multiple streams and combines them into one compound stream. What is particularly useful is that it updates every time *any* of its input streams update, so we can ensure that the packaged data we send to the UI is complete and up-to-date.

[![](http://blog.danlew.net/content/images/2017/07/slide37-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide37.png)

There really are a wealth of operators in FRP. Here's just a few of the useful ones... often, when people first get involved with FRP they see the list of operators and faint.

However, the goal of these operators isn't to overwhelm - it's to model typical flows of data within an application. They're your friends, not your enemies.

My suggestion for dealing with this is to take it one step at a time. Don't try to memorize all the operators at once; instead, just realize that an operator probably already exists for what you want to do. Look them up when you need them, and after some practice you'll get used to them.

## Takeaway

I endeavored to answer the question "what is functional reactive programming?" We now have an answer: it's reactive streams combined with functional operators.

But why should you try out FRP?

Reactive streams allow you to write modular code by standardizing the method of communication between components. The reactive data flow allows for a loose coupling between these components, too.

Reactive streams are also inherently asynchronous. Perhaps your work is entirely synchronous, but most applications I've worked on depend on asynchronous user-input and concurrent operations. It's easier to use a framework which is designed with asynchronous code in mind than try to write your own concurrency solution.

The functional part of FRP is useful because it gives you the tools to work with streams in a sane manner. Functional operators allow you to control how the streams interact with each other. It also gives you tools for reproducing common logic that comes up with coding in general.

Functional reactive programming is not intuitive. Most people start by coding proactively and impurely, myself included. You do it long enough and it starts to solidify in your mind that proactive, impure coding is the only solution. Breaking free of this mindset can enable you to write more effective code through functional reactive programming.

## Resources

I want to thank/point out some resources I drew upon for this talk.

- [cycle.js has a great explanation of proactive vs. reactive code](https://cycle.js.org/streams.html), which I borrowed from heavily for this talk.

- [Erik Meijer gave a fantastic talk on the proactive/reactive duality](https://channel9.msdn.com/Events/Lang-NEXT/Lang-NEXT-2014/Keynote-Duality).  I borrowed the four fundamental effects of functions from here. The talk is quite mathematical but if you can get through it, it's very enlightening.

- If you want to get more into functional programming, I suggest trying using an actual FP language. Haskell is particularly illuminating because of its strict adherence to FP, which means you can't cheat your way out of actually learning it. ["Learn you a Haskell" is a good, free online book](http://learnyouahaskell.com/) if you want to investigate further.

- If you want to learn more about FRP, check out [my own series of blog posts about it](http://blog.danlew.net/2014/09/15/grokking-rxjava-part-1/). Some of the topics covered in those posts are covered here, so reading both would be a bit repetitive, but it goes into more details on RxJava in particular.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
