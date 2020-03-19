> * 原文地址：[Elements of JavaScript Style](https://medium.com/javascript-scene/elements-of-javascript-style-caa8821cb99f)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/elements-of-javascript-style.md](https://github.com/xitu/gold-miner/blob/master/TODO1/elements-of-javascript-style.md)
> * 译者：
> * 校对者：

# Elements of JavaScript Style

![Out of the Blue — Iñaki Bolumburu (CC BY-NC-ND 2.0)](https://cdn-images-1.medium.com/max/2400/1*7qYONdlJuS0pkUpdav-LQQ.jpeg)

> **Note:** This post is now part of the [“Composing Software” book](https://leanpub.com/composingsoftware).

In 1920, [“The Elements of Style” by William Strunk Jr](https://www.amazon.com/Elements-Style-Fourth-William-Strunk/dp/020530902X/ref=as_li_ss_tl?ie=UTF8&qid=1493260884&sr=8-1&keywords=the+elements+of+style&linkCode=ll1&tag=eejs-20&linkId=f7eb0eacba0eab243899626551113119). was published, which set guidelines for English language style that have lasted the test of time. You can improve your code by applying similar standards to your code style.

The following are guidelines, not immutable laws. There may be valid reasons to deviate from them if doing so clarifies the meaning of the code, but [be vigilant and self-aware](https://medium.com/javascript-scene/familiarity-bias-is-holding-you-back-its-time-to-embrace-arrow-functions-3d37e1a9bb75). These guidelines have stood the test of time for good reason: They’re usually right. Deviate from them only for good reason — not simply on a whim or a personal style preference.

Almost every guideline from **the elementary principles of composition** applies to source code:

* Make the paragraph the unit of composition: One paragraph to each topic.
* Omit needless words.
* Use active voice.
* Avoid a succession of loose sentences.
* Keep related words together.
* Put statements in positive form.
* Use parallel construction on parallel concepts.

We can apply nearly identical concepts to code style:

1. Make the function the unit of composition. One job for each function.
2. Omit needless code.
3. Use active voice.
4. Avoid a succession of loose statements.
5. Keep related code together.
6. Put statements and expressions in positive form.
7. Use parallel code for parallel concepts.

## 1. Make the function the unit of composition. One job for each function.

> The essence of software development is composition. We build software by composing modules, functions, and data structures together.

> Understanding how to write and compose functions is a fundamental skill for software developers.

Modules are simply collections of one or more functions or data structures, and data structures are how we represent program state, but nothing interesting happens until we apply a function.

In JavaScript, there are three kinds of functions:

* Communicating functions: Functions which perform I/O.
* Procedural functions: A list of instructions, grouped together.
* Mapping functions: Given some input, return some corresponding output.

While all useful programs need I/O, and many programs follow some procedural sequences, the majority of your functions should be mapping functions: Given some input, the function will return some corresponding output.

**One thing for each function**: If your function is for I/O, don’t mix that I/O with mapping (calculation). If your function is for mapping, don’t mix it with I/O. By definition, procedural functions violate this guideline. Procedural functions also violate another guideline: Avoid a succession of loose statements.

The ideal function is a simple, deterministic, pure function:

* Given the same input, always return the same output
* No side-effects

See also, [“What is a Pure Function?”](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976)

## 2. Omit needless code.

> “Vigorous writing is concise. A sentence should contain no unnecessary words, a paragraph no unnecessary sentences, for the same reason that a drawing should have no unnecessary lines and a machine no unnecessary parts. This requires not that the writer make all sentences short, or avoid all detail and treat subjects only in outline, but that every word tell.” [Needless words omitted.]
~ William Strunk, Jr., The Elements of Style

Concise code is critical in software because more code creates more surface area for bugs to hide in. **Less code= fewer places for bugs to hide = fewer bugs.**

Concise code is more legible because it has a higher signal-to-noise ratio: The reader must sift through less syntax noise to reach the meaning. **Less code = less syntax noise = stronger signal for meaning transmission.**

To borrow a word from The Elements of Style: Concise code is more **vigorous.**

```
function secret (message) {
  return function () {
    return message;
  }
};
```

Can be reduced to:

```
const secret = msg => () => msg;
```

This is much more readable to those familiar with concise arrow functions (introduced in 2015 with ES6). It omits unnecessary syntax: Braces, the `function` keyword, and the `return` statement.

The first includes unnecessary syntax. Braces, the `function` keyword, and the `return` statement serve no purpose to those familiar with concise arrow syntax. It exists only to make the code familiar to those who are not yet fluent with ES6.

ES6 has been the language standard since 2015. It’s time to [get familiar](https://medium.com/javascript-scene/familiarity-bias-is-holding-you-back-its-time-to-embrace-arrow-functions-3d37e1a9bb75).

#### Omit Needless Variables

Sometimes we’re tempted to assign names to things that don’t really need to be named. The problem is that [the human brain has a limited number of resources available in working memory](http://www.nature.com/neuro/journal/v17/n3/fig_tab/nn.3655_F2.html), and each variable must be stored as a discrete quanta, occupying one of the available working memory slots.

For this reason, experienced developers learn to eliminate variables that don’t need to exist.

For example, in most situations, you should omit variables created only to name return values. The name of your function should provide adequate information about what the function will return. Consider the following:

```
const getFullName = ({firstName, lastName}) => {
  const fullName = firstName + ' ' + lastName;
  return fullName;
};
```

vs…

```
const getFullName = ({firstName, lastName}) => (
  firstName + ' ' + lastName
);
```

Another common way developers can reduce variables is to take advantage of function composition and point-free style.

**Point-free style** is a way of defining functions without referencing the arguments on which the functions operate. Common ways of achieving point-free style include currying and function composition.

Let’s look at an example using curry:

```
const add2 = a => b => a + b;

// Now we can define a point-free inc()
// that adds 1 to any number.
const inc = add2(1);

inc(3); // 4
```

Take a look at the definition of the `inc()` function. Notice that it doesn’t use the `function` keyword, or the `=>` syntax. There’s no place to list parameters, because the function doesn’t make use of a parameter list internally. Instead, it returns a function that knows how to deal with arguments.

Let’s look at another example using function composition. **Function composition** is the process of applying a function to the result of another function application. Whether you realize it or not, you use function composition all the time. You use it whenever you chain methods like `.map()` or `promise.then()`, for example. In it’s most basic form, it looks like this: `f(g(x))`. In algebra this composition is usually written `f ∘ g` (often pronounced, “f **after** g” or “f **composed with** g”).

When you compose two functions together, you eliminate the need to create a variable to hold the intermediary value between the two function applications. Let’s see how function composition can clean up some code:

```
const g = n => n + 1;
const f = n => n * 2;

// With points:
const incThenDoublePoints = n => {
  const incremented = g(n);
  return f(incremented);
};

incThenDoublePoints(20); // 42

// compose2 - Take two functions and return their composition
const compose2 = (f, g) => x => f(g(x));

// Point-free:
const incThenDoublePointFree = compose2(f, g);

incThenDoublePointFree(20); // 42
```

You can do the same thing with any functor. A [**functor**](https://medium.com/javascript-scene/functors-categories-61e031bac53f) is anything you can map over, e.g., arrays (`Array.map()`) or promises (`promise.then()`). Let’s write another version of `compose2` using map chaining for function composition:

```
const compose2 = (f, g) => x => [x].map(g).map(f).pop();

const incThenDoublePointFree = compose2(f, g);

incThenDoublePointFree(20); // 42
```

You’re doing much the same thing every time you use promise chains.

Virtually every functional programming library has at least two versions of compose utilities: `compose()` which applies functions right-to-left, and `pipe()`, which applies functions left-to-right.

Lodash calls them `compose()` and `flow()`. When I use them from Lodash, I always import it like this:

```
import pipe from 'lodash/fp/flow';
pipe(g, f)(20); // 42
```

However, this isn’t much more code, and it does the same thing:

```
const pipe = (...fns) => x => fns.reduce((acc, fn) => fn(acc), x);
pipe(g, f)(20); // 42
```

If this function composition stuff sounds alien to you, and you’re not sure how you’d use it, give this careful thought:

> he essence of software development is composition. We build applications by composing smaller modules, functions, and data structures.

From that you can conclude that understanding the tools of function and object composition are as fundamental as a home builder understanding drills and nail guns.

When you use imperative code to piece together functions with intermediary variables, that’s like composing those pieces with duct tape and crazy glue.

Remember:

* If you can say the same thing with less code, without changing or obfuscating the meaning, you should.
* If you can say the same thing with fewer variables, without changing or obfuscating the meaning, you should.

## 3. Use Active Voice

> “The active voice is usually more direct and vigorous than the passive.” ~ William Strunk, Jr., The Elements of Style

Name things as directly as possible.

* `myFunction.wasCalled()` is better than `myFunction.hasBeenCalled()`
* `createUser()` is better than `User.create()`
* `notify()` is better than `Notifier.doNotification()`

Name predicates and booleans as if they are yes or no questions:

* `isActive(user)` is better than `getActiveStatus(user)`
* `isFirstRun = false;` is better than `firstRun = false;`

Name functions using verb forms:

* `increment()` is better than `plusOne()`
* `unzip()` is better than `filesFromZip()`
* `filter(fn, array)` is better than matchingItemsFromArray(fn, array)

**Event Handlers**

Event handlers and lifecycle methods are an exception to the verb rule because they’re used as qualifiers; instead of expressing what to do, they express **when** to do it. They should be named so that they read, “\<when to act>, \<verb>”.

* `element.onClick(handleClick)` is better than `element.click(handleClick)`
* component.onDragStart(handleDragStart) is better than component.startDrag(handleDragStart)

In the second forms, it looks like we’re trying to trigger the event, rather than respond to it.

#### Lifecycle Methods

Consider the following alternatives for a component hypothetical lifecycle method which exists to call a handler function before a component updates:

* componentWillBeUpdated(doSomething)
* componentWillUpdate(doSomething)
* `beforeUpdate(doSomething)`

In the first example, we use passive voice (will be updated instead of will update). It is a mouthful, and not any more clear than the other alternatives.

The second example is much better, but the whole point of this lifecycle method is to call a handler. `componentWillUpdate(handler)` reads as if it will update the handler, but that’s not what we mean. We mean, “before the component updates, call the handler”. `beforeComponentUpdate()` expresses the intention more clearly.

We can simplify even further. Since these are methods, the subject (the component) is built-in. Referring to it in the method name is redundant. Think about how it would read if you called these methods directly: component.componentWillUpdate(). That’s like saying, “Jimmy Jimmy will have steak for dinner.” You don’t need to hear the subject’s name twice.

* component.beforeUpdate(doSomething) is better than component.beforeComponentUpdate(doSomething)

**Functional mixins** are functions that add properties and methods to an object. The functions are applied one after the other in an pipeline — like an assembly line. Each functional mixin takes the `instance` as an input, and tacks some stuff onto it before passing it on to the next function in the pipeline.

I like to name functional mixins using adjectives. You can often use “ing” or “able” suffixes to find useful adjectives. Examples:

* const duck = composeMixins(flying, quacking);
* const box = composeMixins(iterable, mappable);

## 4. Avoid a Succession of Loose Statements

> “…a series soon becomes monotonous and tedious.”
~ William Strunk, Jr., The Elements of Style

Developers frequently string together sequences of events in a procedure: a group of loosely related statements designed to run one after the other. An excess of procedures is a recipe for spaghetti code.

Such sequences are frequently repeated by many parallel forms, each of them subtly and sometimes unexpectedly divergent. For example, a user interface component shares the same core needs with virtually all other user interface components. Its concerns can be broken up into lifecycle stages and managed by separate functions.

Consider the following sequence:

```
const drawUserProfile = ({ userId }) => {
  const userData = loadUserData(userId);
  const dataToDisplay = calculateDisplayData(userData);
  renderProfileData(dataToDisplay);
};
```

This function is really handling three different things: loading data, calculating view state from loaded data, and rendering.

In most modern front-end application architectures, each of these concerns is considered separately. By separating these concerns, we can easily mix and match different functions for each concern.

For example, we could replace the renderer completely, and it would not impact the other parts of the program, e.g., React’s wealth of custom renderers: ReactNative for native iOS & Android apps, AFrame for WebVR, ReactDOM/Server for server-side rendering, etc…

Another problem with this function is that you can’t simply calculate the data to be displayed and generate the markup without first loading the data. What if you’ve already loaded the data? You end up doing work that you didn’t need to do in subsequent calls.

Separating the concerns also makes them independently testable. I like to unit test my applications and display test results with each change as I’m writing the code. However, if we’re tying **render code** to **data loading code**, I can’t simply pass some fake data to the rendering code for testing purposes. I have to test the whole component end-to-end — a process which can be time consuming due to browser loading, asynchronous network I/O, etc…

I won’t get immediate feedback from my unit tests. Separating the functions allows you to test units in isolation from each other.

This example already has separate functions which we can feed to different lifecycle hooks in the application. Loading can be triggered when the component is mounted by the application. Calculating & rendering can happen in response to view state updates.

The result is software with responsibilities more clearly delineated: Each component can reuse the same structure and lifecycle hooks, and the software performs better; we don’t repeat work that doesn’t need to be repeated in subsequent cycles.

## 5. Keep related code together.

Many frameworks and boilerplates prescribe a method of program organization where files are grouped by technical type. This is fine if you’re building a small calculator or To Do app, but for larger projects, it’s usually better to group files together by feature.

For example, here are two alternative file hierarchies for a To Do app by type and feature:

**Grouped by type:**

```
.
├── components
│   ├── todos
│   └── user
├── reducers
│   ├── todos
│   └── user
└── tests
    ├── todos
    └── user
```

**Grouped by feature:**

```
.
├── todos
│   ├── component
│   ├── reducer
│   └── test
└── user
    ├── component
    ├── reducer
    └── test
```

When you group files together by feature, you avoid scrolling up and down in your file list to find all the files you need to edit to get a single feature working.

> Colocate files related by feature.

## 6. Put statements and expressions in positive form.

> “Make definite assertions. Avoid tame, colorless, hesitating, non-committal language. Use the word **not** as a means of denial or in antithesis, never as a means of evasion.”
~ William Strunk, Jr., The Elements of Style

* `isFlying` is better than `isNotFlying`
* `late` is better than `notOnTime`

#### If Statements

```
if (err) return reject(err);

// do something...
```

…is better than:

```
if (!err) {
  // ... do something
} else {
  return reject(err);
}
```

#### Ternaries

```
{
  [Symbol.iterator]: iterator ? iterator : defaultIterator
}
```

…is better than:

```
{
  [Symbol.iterator]: (!iterator) ? defaultIterator : iterator
}
```

#### Prefer Strong Negative Statements

Sometimes we only care about a variable if it’s missing, so using a positive name would force us to negate it with the `!` operator. In those cases, prefer a strong negative form. The word “not” and the `!` operator create weak expressions.

* `if (missingValue)` is better than `if (!hasValue)`
* `if (anonymous)` is better than `if (!user)`
* `if (isEmpty(thing))` is better than `if (notDefined(thing))`

#### Avoid null and undefined arguments in function calls

Don’t require function callers to pass `undefined` or `null` in place of an optional parameter. Prefer named options objects instead:

```
const createEvent = ({
  title = 'Untitled',
  timeStamp = Date.now(),
  description = ''
}) => ({ title, description, timeStamp });

// later...
const birthdayParty = createEvent({
  title: 'Birthday Party',
  description: 'Best party ever!'
});
```

…is better than:

```
const createEvent = (
  title = 'Untitled',
  timeStamp = Date.now(),
  description = ''
) => ({ title, description, timeStamp });

// later...
const birthdayParty = createEvent(
  'Birthday Party',
  undefined, // This was avoidable
  'Best party ever!'  
);
```

## Use Parallel Code for Parallel Concepts

> “…parallel construction requires that expressions of similar content and function should be outwardly similar. The likeness of form enables the reader to recognize more readily the likeness of content and function.”
~ William Strunk, Jr., The Elements of Style

There are few problems in applications that have not been solved before. We end up doing the same things over and over again. When that happens, it’s an opportunity for abstraction. Identify the parts that are the same, and build an abstraction that allows you to supply only the parts that are different. This is exactly what libraries and frameworks do for us.

UI components are a great example. Less than a decade ago, it was common to mingle UI updates using jQuery with application logic and network I/O. Then people began to realize that we could apply MVC to web apps on the client-side, and people began to separate models from UI update logic.

Eventually, web apps landed on a component model approach, which lets us declaratively model our components using things like JSX or HTML templates.

What we ended up with is a way of expressing UI update logic the same way for every component, rather than different imperative code for each one.

For those familiar with components, it’s pretty easy to see how each component works: There’s some declarative markup expressing the UI elements, event handlers for hooking up behaviors, and lifecycle hooks for attaching callbacks that will run when we need them to.

When we repeat similar pattern for similar problems, anybody familiar with the pattern should be able to quickly learn what the code does.

## Conclusion: Code Should Be Simple, Not Simplistic

> Vigorous writing is concise. A sentence should contain no unnecessary words, a paragraph no unnecessary sentences, for the same reason that a drawing should have no unnecessary lines and a machine no unnecessary parts. **This requires not that the writer make all sentences short, or avoid all detail and treat subjects only in outline, but that every word tell.** [Emphasis added.]
~ William Strunk, Jr., The Elements of Style

ES6 was standardized in 2015, yet in 2017, many developers avoid features such as concise arrow functions, implicit return, rest and spread operators, etc… in the guise of writing code that is easier to read because it is [more familiar](https://medium.com/javascript-scene/familiarity-bias-is-holding-you-back-its-time-to-embrace-arrow-functions-3d37e1a9bb75). That is a big mistake. Familiarity comes with practice, and with familiarity, the concise features in ES6 are clearly superior to the ES5 alternatives: **concise code is simple** compared to the syntax-heavy alternative.

Code should be simple, not simplistic.

Given that concise code is:

* Less bug prone
* Easier to debug

And given that bugs:

* Are extremely expensive to fix
* Tend to cause more bugs
* Interrupt the flow of normal feature development

And given that concise code is also:

* Easier to write
* Easier to read
* Easier to maintain

It is worth the training investment to bring developers up to speed using techniques such as concise syntax, currying & composition. When we fail to do so for the sake of familiarity, we talk down to readers of our code so that they can better understand it, like an adult speaking baby-talk to a toddler.

Assume the reader knows nothing about the implementation, but do not assume that the reader is stupid, or that the reader doesn’t know the language.

Be clear, but don’t dumb it down. To dumb things down is both wasteful and insulting. Make the investment in practice and familiarity in order to gain a better programming vocabulary, and a more vigorous style.

> Code should be simple, not simplistic.

---

****Eric Elliott** is the author of [“Programming JavaScript Applications”](http://pjabook.com) (O’Reilly), and cofounder of [DevAnywhere.io](https://devanywhere.io/). He has contributed to software experiences for **Adobe Systems**, **Zumba Fitness**, **The Wall Street Journal**, **ESPN**, **BBC**, and top recording artists including **Usher**, **Frank Ocean**, **Metallica**, and many more.**

**He works anywhere he wants with the most beautiful woman in the world.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
