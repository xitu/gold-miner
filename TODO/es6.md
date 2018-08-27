> * 原文链接: [ES6 Overview in 350 Bullet Points](https://ponyfoo.com/articles/es6)
* 原文作者 : [Nicolas Bevacqua](https://ponyfoo.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 :
* 状态 : 待定

# 350 个特性看透 ES6

### Introduction

*   ES6 – also known as Harmony, `es-next`, ES2015 – is the latest finalized specification of the language
*   The ES6 specification was finalized in **June 2015**, _(hence ES2015)_
*   Future versions of the specification will follow the `ES[YYYY]` pattern, e.g ES2016 for ES7
    *   **Yearly release schedule**, features that don’t make the cut take the next train
    *   Since ES6 pre-dates that decision, most of us still call it ES6
    *   Starting with ES2016 (ES7), we should start using the `ES[YYYY]` pattern to refer to newer versions
    *   Top reason for naming scheme is to pressure browser vendors into quickly implementing newest features

### Tooling

*   To get ES6 working today, you need a **JavaScript-to-JavaScript** _transpiler_
*   Transpilers are here to stay
    *   They allow you to compile code in the latest version into older versions of the language
    *   As browser support gets better, we’ll transpile ES2016 and ES2017 into ES6 and beyond
    *   We’ll need better source mapping functionality
    *   They’re the most reliable way to run ES6 source code in production today _(although browsers get ES5)_
*   Babel _(a transpiler)_ has a killer feature: **human-readable output**
*   Use [`babel`](http://babeljs.io/) to transpile ES6 into ES5 for static builds
*   Use [`babelify`](https://github.com/babel/babelify) to incorporate `babel` into your [Gulp, Grunt, or `npm run`](https://ponyfoo.com/articles/gulp-grunt-whatever) build process
*   Use Node.js `v4.x.x` or greater as they have decent ES6 support baked in, thanks to `v8`
*   Use `babel-node` with any version of `node`, as it transpiles modules into ES5
*   Babel has a thriving ecosystem that already supports some of ES2016 and has plugin support
*   Read [A Brief History of ES6 Tooling](https://ponyfoo.com/articles/a-brief-history-of-es6-tooling)

### Assignment Destructuring

*   `var {foo} = pony` is equivalent to `var foo = pony.foo`
*   `var {foo: baz} = pony` is equivalent to `var baz = pony.foo`
*   You can provide default values, `var {foo='bar'} = baz` yields `foo: 'bar'` if `baz.foo` is `undefined`
*   You can pull as many properties as you like, aliased or not
    *   `var {foo, bar: baz} = {foo: 0, bar: 1}` gets you `foo: 0` and `baz: 1`
*   You can go deeper. `var {foo: {bar}} = { foo: { bar: 'baz' } }` gets you `bar: 'baz'`
*   You can alias that too. `var {foo: {bar: deep}} = { foo: { bar: 'baz' } }` gets you `deep: 'baz'`
*   Properties that aren’t found yield `undefined` as usual, e.g: `var {foo} = {}`
*   Deeply nested properties that aren’t found yield an error, e.g: `var {foo: {bar}} = {}`
*   It also works for arrays, `[a, b] = [0, 1]` yields `a: 0` and `b: 1`
*   You can skip items in an array, `[a, , b] = [0, 1, 2]`, getting `a: 0` and `b: 2`
*   You can swap without an _“aux”_ variable, `[a, b] = [b, a]`
*   You can also use destructuring in function parameters
    *   Assign default values like `function foo (bar=2) {}`
    *   Those defaults can be objects, too `function foo (bar={ a: 1, b: 2 }) {}`
    *   Destructure `bar` completely, like `function foo ({ a=1, b=2 }) {}`
    *   Default to an empty object if nothing is provided, like `function foo ({ a=1, b=2 } = {}) {}`
*   Read [ES6 JavaScript Destructuring in Depth](https://ponyfoo.com/articles/es6-destructuring-in-depth)

### Spread Operator and Rest Parameters

*   Rest parameters is a better `arguments`
    *   You declare it in the method signature like `function foo (...everything) {}`
    *   `everything` is an array with all parameters passed to `foo`
    *   You can name a few parameters before `...everything`, like `function foo (bar, ...rest) {}`
    *   Named parameters are excluded from `...rest`
    *   `...rest` must be the last parameter in the list
*   Spread operator is better than magic, also denoted with `...` syntax
    *   Avoids `.apply` when calling methods, `fn(...[1, 2, 3])` is equivalent to `fn(1, 2, 3)`
    *   Easier concatenation `[1, 2, ...[3, 4, 5], 6, 7]`
    *   Casts array-likes or iterables into an array, e.g `[...document.querySelectorAll('img')]`
    *   Useful when [destructuring](#assignment-destructuring) too, `[a, , ...rest] = [1, 2, 3, 4, 5]` yields `a: 1` and `rest: [3, 4, 5]`
    *   Makes `new` + `.apply` effortless, `new Date(...[2015, 31, 8])`
*   Read [ES6 Spread and Butter in Depth](https://ponyfoo.com/articles/es6-spread-and-butter-in-depth)

### Arrow Functions

*   Terse way to declare a function like `param => returnValue`
*   Useful when doing functional stuff like `[1, 2].map(x => x * 2)`
*   Several flavors are available, might take you some getting used to
    *   `p1 => expr` is okay for a single parameter
    *   `p1 => expr` has an implicit `return` statement for the provided `expr` expression
    *   To return an object implicitly, wrap it in parenthesis `() => ({ foo: 'bar' })` or you’ll get **an error**
    *   Parenthesis are demanded when you have zero, two, or more parameters, `() => expr` or `(p1, p2) => expr`
    *   Brackets in the right-hand side represent a code block that can have multiple statements, `() => {}`
    *   When using a code block, there’s no implicit `return`, you’ll have to provide it – `() => { return 'foo' }`
*   You can’t name arrow functions statically, but runtimes are now much better at inferring names for most methods
*   Arrow functions are bound to their lexical scope
    *   `this` is the same `this` context as in the parent scope
    *   `this` can’t be modified with `.call`, `.apply`, or similar _“reflection”-type_ methods
*   Read [ES6 Arrow Functions in Depth](https://ponyfoo.com/articles/es6-arrow-functions-in-depth)

### Template Literals

*   You can declare strings with ``` (backticks), in addition to `"` and `'`
*   Strings wrapped in backticks are _template literals_
*   Template literals can be multiline
*   Template literals allow interpolation like ``ponyfoo.com is ${rating}`` where `rating` is a variable
*   You can use any valid JavaScript expressions in the interpolation, such as ``${2 * 3}`` or ``${foo()}``
*   You can use tagged templates to change how expressions are interpolated
    *   Add a `fn` prefix to `fn`foo, ${bar} and ${baz}``
    *   `fn` is called once with `template, ...expressions`
    *   `template` is `['foo, ', ' and ', '']` and `expressions` is `[bar, baz]`
    *   The result of `fn` becomes the value of the template literal
    *   Possible use cases include input sanitization of expressions, parameter parsing, etc.
*   Template literals are almost strictly better than strings wrapped in single or double quotes
*   Read [ES6 Template Literals in Depth](https://ponyfoo.com/articles/es6-template-strings-in-depth)

### Object Literals

*   Instead of `{ foo: foo }`, you can just do `{ foo }` – known as a _property value shorthand_
*   Computed property names, `{ [prefix + 'Foo']: 'bar' }`, where `prefix: 'moz'`, yields `{ mozFoo: 'bar' }`
*   You can’t combine computed property names and property value shorthands, `{ [foo] }` is invalid
*   Method definitions in an object literal can be declared using an alternative, more terse syntax, `{ foo () {} }`
*   See also [`Object`](#object) section
*   Read [ES6 Object Literal Features in Depth](https://ponyfoo.com/articles/es6-object-literal-features-in-depth)

### Classes

*   Not _“traditional”_ classes, syntax sugar on top of prototypal inheritance
*   Syntax similar to declaring objects, `class Foo {}`
*   Instance methods _– `new Foo().bar` –_ are declared using the short [object literal](#object-literals) syntax, `class Foo { bar () {} }`
*   Static methods _– `Foo.isPonyFoo()` –_ need a `static` keyword prefix, `class Foo { static isPonyFoo () {} }`
*   Constructor method `class Foo { constructor () { /* initialize instance */ } }`
*   Prototypal inheritance with a simple syntax `class PonyFoo extends Foo {}`
*   Read [ES6 Classes in Depth](https://ponyfoo.com/articles/es6-classes-in-depth)

### Let and Const

*   `let` and `const` are alternatives to `var` when declaring variables
*   `let` is block-scoped instead of lexically scoped to a `function`
*   `let` is [hoisted](https://ponyfoo.com/articles/javascript-variable-hoisting) to the top of the block, while `var` declarations are hoisted to top of the function
*   “Temporal Dead Zone” – TDZ for short
    *   Starts at the beginning of the block where `let foo` was declared
    *   Ends where the `let foo` statement was placed in user code _(hoisiting is irrelevant here)_
    *   Attempts to access or assign to `foo` within the TDZ _(before the `let foo` statement is reached)_ result in an error
    *   Helps prevent mysterious bugs when a variable is manipulated before its declaration is reached
*   `const` is also block-scoped, hoisted, and constrained by TDZ semantics
*   `const` variables must be declared using an initializer, `const foo = 'bar'`
*   Assigning to `const` after initialization fails silently (or **loudly** _– with an exception –_ under strict mode)
*   `const` variables don’t make the assigned value immutable
    *   `const foo = { bar: 'baz' }` means `foo` will always reference the right-hand side object
    *   `const foo = { bar: 'baz' }; foo.bar = 'boo'` won’t throw
*   Declaration of a variable by the same name will throw
*   Meant to fix mistakes where you reassign a variable and lose a reference that was passed along somewhere else
*   In ES6, **functions are block scoped**
    *   Prevents leaking block-scoped secrets through hoisting, `{ let _foo = 'secret', bar = () => _foo; }`
    *   Doesn’t break user code in most situations, and typically what you wanted anyways
*   Read [ES6 Let, Const and the “Temporal Dead Zone” (TDZ) in Depth](https://ponyfoo.com/articles/es6-let-const-and-temporal-dead-zone-in-depth)

### Symbols

*   A new primitive type in ES6
*   You can create your own symbols using `var symbol = Symbol()`
*   You can add a description for debugging purposes, like `Symbol('ponyfoo')`
*   Symbols are immutable and unique. `Symbol()`, `Symbol()`, `Symbol('foo')` and `Symbol('foo')` are all different
*   Symbols are of type `symbol`, thus: `typeof Symbol() === 'symbol'`
*   You can also create global symbols with `Symbol.for(key)`
    *   If a symbol with the provided `key` already existed, you get that one back
    *   Otherwise, a new symbol is created, using `key` as its description as well
    *   `Symbol.keyFor(symbol)` is the inverse function, taking a `symbol` and returning its `key`
    *   Global symbols are **as global as it gets**, or _cross-realm_. Single registry used to look up these symbols across the runtime
        *   `window` context
        *   `eval` context
        *   `<iframe>`context, `Symbol.for('foo') === iframe.contentWindow.Symbol.for('foo')`
*   There’s also “well-known” symbols
    *   Not on the global registry, accessible through `Symbol[name]`, e.g: `Symbol.iterator`
    *   Cross-realm, meaning `Symbol.iterator === iframe.contentWindow.Symbol.iterator`
    *   Used by specification to define protocols, such as the [_iterable_ protocol](#iterators) over `Symbol.iterator`
    *   They’re not **actually well-known** – in colloquial terms
*   Iterating over symbol properties is hard, but not impossible and definitely not private
    *   Symbols are hidden to all pre-ES6 “reflection” methods
    *   Symbols are accessible through `Object.getOwnPropertySymbols`
    *   You won’t stumble upon them but you **will** find them if _actively looking_
*   Read [ES6 Symbols in Depth](https://ponyfoo.com/articles/es6-symbols-in-depth)

### Iterators

*   Iterator and iterable protocol define how to iterate over any object, not just arrays and array-likes
*   A well-known `Symbol` is used to assign an iterator to any object
*   `var foo = { [Symbol.iterator]: iterable}`, or `foo[Symbol.iterator] = iterable`
*   The `iterable` is a method that returns an `iterator` object that has a `next` method
*   The `next` method returns objects with two properties, `value` and `done`
    *   The `value` property indicates the current value in the sequence being iterated
    *   The `done` property indicates whether there are any more items to iterate
*   Objects that have a `[Symbol.iterator]` value are _iterable_, because they subscribe to the iterable protocol
*   Some built-ins like `Array`, `String`, or `arguments` – and `NodeList` in browsers – are iterable by default in ES6
*   Iterable objects can be looped over with `for..of`, such as `for (let el of document.querySelectorAll('a'))`
*   Iterable objects can be synthesized using the spread operator, like `[...document.querySelectorAll('a')]`
*   You can also use `Array.from(document.querySelectorAll('a'))` to synthesize an iterable sequence into an array
*   Iterators are _lazy_, and those that produce an infinite sequence still can lead to valid programs
*   Be careful not to attempt to synthesize an infinite sequence with `...` or `Array.from` as that **will** cause an infinite loop
*   Read [ES6 Iterators in Depth](https://ponyfoo.com/articles/es6-iterators-in-depth)

### Generators

*   Generator functions are a special kind of _iterator_ that can be declared using the `function* generator () {}` syntax
*   Generator functions use `yield` to emit an element sequence
*   Generator functions can also use `yield*` to delegate to another generator function _– or any iterable object_
*   Generator functions return a generator object that’s adheres to both the _iterable_ and _iterator_ protocols
    *   Given `g = generator()`, `g` adheres to the iterable protocol because `g[Symbol.iterator]` is a method
    *   Given `g = generator()`, `g` adheres to the iterator protocol because `g.next` is a method
    *   The iterator for a generator object `g` is the generator itself: `g[Symbol.iterator]() === g`
*   Pull values using `Array.from(g)`, `[...g]`, `for (let item of g)`, or just calling `g.next()`
*   Generator function execution is suspended, remembering the last position, in four different cases
    *   A `yield` expression returning the next value in the sequence
    *   A `return` statement returning the last value in the sequence
    *   A `throw` statement halts execution in the generator entirely
    *   Reaching the end of the generator function signals `{ done: true }`
*   Once the `g` sequence has ended, `g.next()` simply returns `{ done: true }` and has no effect
*   It’s easy to make asynchronous flows feel synchronous
    *   Take user-provided generator function
    *   User code is suspended while asynchronous operations take place
    *   Call `g.next()`, unsuspending execution in user code
*   Read [ES6 Generators in Depth](https://ponyfoo.com/articles/es6-generators-in-depth)

### Promises

*   Follows the [`Promises/A+`](https://promisesaplus.com/) specification, was widely implemented in the wild before ES6 was standarized _(e.g [`bluebird`](https://github.com/petkaantonov/bluebird))_
*   Promises behave like a tree. Add branches with `p.then(handler)` and `p.catch(handler)`
*   Create new `p` promises with `new Promise((resolve, reject) => { /* resolver */ })`
    *   The `resolve(value)` callback will fulfill the promise with the provided `value`
    *   The `reject(reason)` callback will reject `p` with a `reason` error
    *   You can call those methods asynchronously, blocking deeper branches of the promise tree
*   Each call to `p.then` and `p.catch` creates another promise that’s blocked on `p` being settled
*   Promises start out in _pending_ state and are **settled** when they’re either _fulfilled_ or _rejected_
*   Promises can only be settled once, and then they’re settled. Settled promises unblock deeper branches
*   You can tack as many promises as you want onto as many branches as you need
*   Each branch will execute either `.then` handlers or `.catch` handlers, never both
*   A `.then` callback can transform the result of the previous branch by returning a value
*   A `.then` callback can block on another promise by returning it
*   `p.catch(fn).catch(fn)` won’t do what you want – unless what you wanted is to catch errors in the error handler
*   [`Promise.resolve(value)`](https://ponyfoo.com/articles/es6-promises-in-depth#using-promiseresolve-and-promisereject) creates a promise that’s fulfilled with the provided `value`
*   [`Promise.reject(reason)`](https://ponyfoo.com/articles/es6-promises-in-depth#using-promiseresolve-and-promisereject) creates a promise that’s rejected with the provided `reason`
*   [`Promise.all(...promises)`](https://ponyfoo.com/articles/es6-promises-in-depth#leveraging-promiseall-and-promiserace) creates a promise that settles when all `...promises` are fulfilled or 1 of them is rejected
*   [`Promise.race(...promises)`](https://ponyfoo.com/articles/es6-promises-in-depth#leveraging-promiseall-and-promiserace) creates a promise that settles as soon as 1 of `...promises` is settled
*   Use [Promisees](http://bevacqua.github.io/promisees/) – the promise visualization playground – to better understand promises
*   Read [ES6 Promises in Depth](https://ponyfoo.com/articles/es6-promises-in-depth)

### Maps

*   A replacement to the common pattern of creating a hash-map using plain JavaScript objects
    *   Avoids security issues with user-provided keys
    *   Allows keys to be arbitrary values, you can even use DOM elements or functions as the `key` to an entry
*   `Map` adheres to _[iterable](#iterators)_ protocol
*   Create a `map` using `new Map()`
*   Initialize a map with an `iterable` like `[[key1, value1], [key2, value2]]` in `new Map(iterable)`
*   Use `map.set(key, value)` to add entries
*   Use `map.get(key)` to get an entry
*   Check for a `key` using `map.has(key)`
*   Remove entries with `map.delete(key)`
*   Iterate over `map` with `for (let [key, value] of map)`, the spread operator, `Array.from`, etc
*   Read [ES6 Maps in Depth](https://ponyfoo.com/articles/es6-maps-in-depth)

### WeakMaps

*   Similar to `Map`, but not quite the same
*   `WeakMap` isn’t iterable, so you don’t get enumeration methods like `.forEach`, `.clear`, and others you had in `Map`
*   `WeakMap` keys must be reference types. You can’t use value types like symbols, numbers, or strings as keys
*   `WeakMap` entries with a `key` that’s the only reference to the referenced variable are subject to garbage collection
*   That last point means `WeakMap` is great at keeping around metadata for objects, while those objects are still in use
*   You avoid memory leaks, without manual reference counting – think of `WeakMap` as [`IDisposable`](https://msdn.microsoft.com/en-us/library/system.idisposable%28v=vs.110%29.aspx?f=255&MSPPError=-2147217396) in .NET
*   Read [ES6 WeakMaps in Depth](https://ponyfoo.com/articles/es6-weakmaps-sets-and-weaksets-in-depth#es6-weakmaps)

### Sets

*   Similar to `Map`, but not quite the same
*   `Set` doesn’t have keys, there’s only values
*   `set.set(value)` doesn’t look right, so we have `set.add(value)` instead
*   Sets can’t have duplicate values because the values are also used as keys
*   Read [ES6 Sets in Depth](https://ponyfoo.com/articles/es6-weakmaps-sets-and-weaksets-in-depth#es6-sets)

### WeakSets

*   `WeakSet` is sort of a cross-breed between `Set` and `WeakMap`
*   A `WeakSet` is a set that can’t be iterated and doesn’t have enumeration methods
*   `WeakSet` values must be reference types
*   `WeakSet` may be useful for a metadata table indicating whether a reference is actively in use or not
*   Read [ES6 WeakSets in Depth](https://ponyfoo.com/articles/es6-weakmaps-sets-and-weaksets-in-depth#es6-weaksets)

### Proxies

*   Proxies are created with `new Proxy(target, handler)`, where `target` is any object and `handler` is configuration
*   The default behavior of a `proxy` acts as a passthrough to the underlying `target` object
*   Handlers determine how the underlying `target` object is accessed on top of regular object property access semantics
*   You pass off references to `proxy` and retain strict control over how `target` can be interacted with
*   Handlers are also known as traps, these terms are used interchangeably
*   You can create **revocable** proxies with `Proxy.revocable(target, handler)`
    *   That method returns an object with `proxy` and `revoke` properties
    *   You could [destructure](#destructuring) `var {proxy, revoke} = Proxy.revocable(target, handler)` for convenience
    *   You can configure the `proxy` all the same as with `new Proxy(target, handler)`
    *   After `revoke()` is called, the `proxy` will **throw** on _any operation_, making it convenient when you can’t trust consumers
*   [`get`](https://ponyfoo.com/articles/es6-proxies-in-depth#get) – traps `proxy.prop` and `proxy['prop']`
*   [`set`](https://ponyfoo.com/articles/es6-proxies-in-depth#set) – traps `proxy.prop = value` and `proxy['prop'] = value`
*   [`has`](https://ponyfoo.com/articles/es6-proxy-traps-in-depth#has) – traps `in` operator
*   [`deleteProperty`](https://ponyfoo.com/articles/es6-proxy-traps-in-depth#deleteproperty) – traps `delete` operator
*   [`defineProperty`](https://ponyfoo.com/articles/es6-proxy-traps-in-depth#defineproperty) – traps `Object.defineProperty` and declarative alternatives
*   [`enumerate`](https://ponyfoo.com/articles/es6-proxy-traps-in-depth#enumerate) – traps `for..in` loops
*   [`ownKeys`](https://ponyfoo.com/articles/es6-proxy-traps-in-depth#ownkeys) – traps `Object.keys` and related methods
*   [`apply`](https://ponyfoo.com/articles/es6-proxy-traps-in-depth#apply) – traps _function calls_
*   [`construct`](https://ponyfoo.com/articles/morees6-proxy-traps-in-depth#construct) – traps usage of the `new` operator
*   [`getPrototypeOf`](https://ponyfoo.com/articles/morees6-proxy-traps-in-depth#getprototypeof) – traps internal calls to `[[GetPrototypeOf]]`
*   [`setPrototypeOf`](https://ponyfoo.com/articles/morees6-proxy-traps-in-depth#setprototypeof) – traps calls to `Object.setPrototypeOf`
*   [`isExtensible`](https://ponyfoo.com/articles/morees6-proxy-traps-in-depth#isextensible) – traps calls to `Object.isExtensible`
*   [`preventExtensions`](https://ponyfoo.com/articles/morees6-proxy-traps-in-depth#preventextensions) – traps calls to `Object.preventExtensions`
*   [`getOwnPropertyDescriptor`](https://ponyfoo.com/articles/morees6-proxy-traps-in-depth#getownpropertydescriptor) – traps calls to `Object.getOwnPropertyDescriptor`
*   Read [ES6 Proxies in Depth](https://ponyfoo.com/articles/es6-proxies-in-depth)
*   Read [ES6 Proxy Traps in Depth](https://ponyfoo.com/articles/es6-proxy-traps-in-depth)
*   Read [More ES6 Proxy Traps in Depth](https://ponyfoo.com/articles/more-es6-proxy-traps-in-depth)

### Reflection

*   `Reflection` is a new static built-in (think of `Math`) in ES6
*   `Reflection` methods have sensible internals, e.g `Reflect.defineProperty` returns a boolean instead of throwing
*   There’s a `Reflection` method for each proxy trap handler, and they represent the default behavior of each trap
*   Going forward, new reflection methods in the same vein as `Object.keys` will be placed in the `Reflection` namespace
*   Read [ES6 Reflection in Depth](https://ponyfoo.com/articles/es6-reflection-in-depth)

### `Number`

*   Use `0b` prefix for binary, and `0o` prefix for octal integer literals
*   `Number.isNaN` and `Number.isFinite` are like their global namesakes, except that they _don’t_ coerce input to `Number`
*   `Number.parseInt` and `Number.parseFloat` are exactly the same as their global namesakes
*   `Number.isInteger` checks if input is a `Number` value that doesn’t have a decimal part
*   `Number.EPSILON` helps figure out negligible differences between two numbers – e.g. `0.1 + 0.2` and `0.3`
*   `Number.MAX_SAFE_INTEGER` is the largest integer that can be safely and precisely represented in JavaScript
*   `Number.MIN_SAFE_INTEGER` is the smallest integer that can be safely and precisely represented in JavaScript
*   `Number.isSafeInteger` checks whether an integer is within those bounds, able to be represented safely and precisely
*   Read [ES6 `Number` Improvements in Depth](https://ponyfoo.com/articles/es6-number-improvements-in-depth)

### `Math`

*   [`Math.sign`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathsign) – sign function of a number
*   [`Math.trunc`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathtrunc) – integer part of a number
*   [`Math.cbrt`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathcbrt) – cubic root of value, or `∛‾value`
*   [`Math.expm1`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathexpm1) – `e` to the `value` minus `1`, or `e<sup>value</sup> - 1`
*   [`Math.log1p`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathlog1p) – natural logarithm of `value + 1`, or `_ln_(value + 1)`
*   [`Math.log10`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathlog10) – base 10 logarithm of `value`, or `_log_<sub>10</sub>(value)`
*   [`Math.log2`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathlog2) – base 2 logarithm of `value`, or `_log_<sub>2</sub>(value)`
*   [`Math.sinh`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathsinh) – hyperbolic sine of a number
*   [`Math.cosh`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathcosh) – hyperbolic cosine of a number
*   [`Math.tanh`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathtanh) – hyperbolic tangent of a number
*   [`Math.asinh`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathasinh) – hyperbolic arc-sine of a number
*   [`Math.acosh`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathacosh) – hyperbolic arc-cosine of a number
*   [`Math.atanh`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathatanh) – hyperbolic arc-tangent of a number
*   [`Math.hypot`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathhypot) – square root of the sum of squares
*   [`Math.clz32`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathclz32) – leading zero bits in the 32-bit representation of a number
*   [`Math.imul`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathimul) – _C-like_ 32-bit multiplication
*   [`Math.fround`](https://ponyfoo.com/articles/es6-math-additions-in-depth#mathfround) – nearest single-precision float representation of a number
*   Read [ES6 `Math` Additions in Depth](https://ponyfoo.com/articles/es6-math-additions-in-depth)

### `Array`

*   [`Array.from`](https://ponyfoo.com/articles/es6-array-extensions-in-depth#arrayfrom) – create `Array` instances from arraylike objects like `arguments` or iterables
*   [`Array.of`](https://ponyfoo.com/articles/es6-array-extensions-in-depth#arrayof) – similar to `new Array(...items)`, but without special cases
*   [`Array.prototype.copyWithin`](https://ponyfoo.com/articles/es6-array-extensions-in-depth#arrayprototypecopywithin) – copies a sequence of array elements into somewhere else in the array
*   [`Array.prototype.fill`](https://ponyfoo.com/articles/es6-array-extensions-in-depth#arrayprototypefill) – fills all elements of an existing array with the provided value
*   [`Array.prototype.find`](https://ponyfoo.com/articles/es6-array-extensions-in-depth#arrayprototypefind) – returns the first item to satisfy a callback
*   [`Array.prototype.findIndex`](https://ponyfoo.com/articles/es6-array-extensions-in-depth#arrayprototypefindindex) – returns the index of the first item to satisfy a callback
*   [`Array.prototype.keys`](https://ponyfoo.com/articles/es6-array-extensions-in-depth#arrayprototypekeys) – returns an iterator that yields a sequence holding the keys for the array
*   [`Array.prototype.values`](https://ponyfoo.com/articles/es6-array-extensions-in-depth#arrayprototypevalues) – returns an iterator that yields a sequence holding the values for the array
*   [`Array.prototype.entries`](https://ponyfoo.com/articles/es6-array-extensions-in-depth#arrayprototypeentries) – returns an iterator that yields a sequence holding key value pairs for the array
*   [`Array.prototype[Symbol.iterator]`](https://ponyfoo.com/articles/es6-array-extensions-in-depth#arrayprototype-symboliterator) – exactly the same as the [`Array.prototype.values`](https://ponyfoo.com/articles/es6-array-extensions-in-depth#arrayprototypevalues) method
*   Read [ES6 `Array` Extensions in Depth](https://ponyfoo.com/articles/es6-array-extensions-in-depth)

### `Object`

*   [`Object.assign`](https://ponyfoo.com/articles/es6-object-changes-in-depth#objectassign) – recursive shallow overwrite for properties from `target, ...objects`
*   [`Object.is`](https://ponyfoo.com/articles/es6-object-changes-in-depth#objectis) – like using the `===` operator programmatically, but also `true` for `NaN` vs `NaN` and `+0` vs `-0`
*   [`Object.getOwnPropertySymbols`](https://ponyfoo.com/articles/es6-object-changes-in-depth#objectgetownpropertysymbols) – returns all own property symbols found on an object
*   [`Object.setPrototypeOf`](https://ponyfoo.com/articles/es6-object-changes-in-depth#objectsetprototypeof) – changes prototype. Equivalent to `target.__proto__` setter
*   See also [Object Literals](#object-literals) section
*   Read [ES6 `Object` Changes in Depth](https://ponyfoo.com/articles/es6-object-changes-in-depth)

### Strings and Unicode

*   String Manipulation
    *   [`String.prototype.startsWith`](https://ponyfoo.com/articles/es6-strings-and-unicode-in-depth#stringprototypestartswith) – whether the string starts with `value`
    *   [`String.prototype.endsWith`](https://ponyfoo.com/articles/es6-strings-and-unicode-in-depth#stringprototypeendswith) – whether the string ends in `value`
    *   [`String.prototype.includes`](https://ponyfoo.com/articles/es6-strings-and-unicode-in-depth#stringprototypeincludes) – whether the string contains `value` anywhere
    *   [`String.prototype.repeat`](https://ponyfoo.com/articles/es6-strings-and-unicode-in-depth#stringprototyperepeat) – returns the string repeated `amount` times
    *   [`String.prototype[Symbol.iterator]`](https://ponyfoo.com/articles/es6-strings-and-unicode-in-depth#stringprototype-symboliterator) – lets you iterate over a sequence of unicode code points _(not characters)_
*   [Unicode](https://ponyfoo.com/articles/es6-strings-and-unicode-in-depth#unicode)
    *   [`String.prototype.codePointAt`](https://ponyfoo.com/articles/es6-strings-and-unicode-in-depth#stringprototypecodepointat) – base-10 numeric representation of a code point at a given position in string
    *   [`String.fromCodePoint`](https://ponyfoo.com/articles/es6-strings-and-unicode-in-depth#stringfromcodepoint%60) – given `...codepoints`, returns a string made of their unicode representations
    *   [`String.prototype.normalize`](https://ponyfoo.com/articles/es6-strings-and-unicode-in-depth#stringprototypenormalize) – returns a normalized version of the string’s unicode representation
*   Read [ES6 Strings and Unicode Additions in Depth](https://ponyfoo.com/articles/es6-strings-and-unicode-in-depth)

### Modules

*   [Strict Mode](https://ponyfoo.com/articles/es6-modules-in-depth#strict-mode) is turned on by default in the ES6 module system
*   ES6 modules are files that [`export`](https://ponyfoo.com/articles/es6-modules-in-depth#export) an API
*   [`export default value`](https://ponyfoo.com/articles/es6-modules-in-depth#exporting-a-default-binding) exports a default binding
*   [`export var foo = 'bar'`](https://ponyfoo.com/articles/es6-modules-in-depth#named-exports) exports a named binding
*   Named exports are bindings that [can be changed](https://ponyfoo.com/articles/es6-modules-in-depth#bindings-not-values) at any time from the module that’s exporting them
*   `export { foo, bar }` exports [a list of named exports](https://ponyfoo.com/articles/es6-modules-in-depth#exporting-lists)
*   `export { foo as ponyfoo }` aliases the export to be referenced as `ponyfoo` instead
*   `export { foo as default }` marks the named export as the default export
*   As [a best practice](https://ponyfoo.com/articles/es6-modules-in-depth#best-practices-and-export), `export default api` at the end of all your modules, where `api` is an object, avoids confusion
*   Module loading is implementation-specific, allows interoperation with CommonJS
*   [`import 'foo'`](https://ponyfoo.com/articles/es6-modules-in-depth#import) loads the `foo` module into the current module
*   [`import foo from 'ponyfoo'`](https://ponyfoo.com/articles/es6-modules-in-depth#importing-default-exports) assigns the default export of `ponyfoo` to a local `foo` variable
*   [`import {foo, bar} from 'baz'`](https://ponyfoo.com/articles/es6-modules-in-depth#importing-named-exports) imports named exports `foo` and `bar` from the `baz` module
*   `import {foo as bar} from 'baz'` imports named export `foo` but aliased as a `bar` variable
*   `import {default} from 'foo'` also imports the default export
*   `import {default as bar} from 'foo'` imports the default export aliased as `bar`
*   `import foo, {bar, baz} from 'foo'` mixes default `foo` with named exports `bar` and `baz` in one declaration
*   [`import * as foo from 'foo'`](https://ponyfoo.com/articles/es6-modules-in-depth#import-all-the-things) imports the namespace object
    *   Contains all named exports in `foo[name]`
    *   Contains the default export in `foo.default`, if a default export was declared in the module
*   Read [ES6 Modules Additions in Depth](https://ponyfoo.com/articles/es6-modules-in-depth)

Time for a bullet point detox. Then again, I _did warn you_ to read the [article series](https://ponyfoo.com/articles/tagged/es6-in-depth) instead. Don’t forget to subscribe and maybe even [contribute to keep Pony Foo alive](http://patreon.com/bevacqua). Also, did you try the [Konami code](https://en.wikipedia.org/wiki/Konami_Code) just yet?
