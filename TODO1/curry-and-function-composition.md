> * 原文地址：[Curry and Function Composition](https://medium.com/javascript-scene/curry-and-function-composition-2c208d774983)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/curry-and-function-composition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/curry-and-function-composition.md)
> * 译者：
> * 校对者：

# Curry and Function Composition

![](https://cdn-images-1.medium.com/max/2000/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)

> Note: This is part of the “Composing Software” series on learning functional programming and compositional software techniques in JavaScript ES6+ from the ground up. Stay tuned. There’s a lot more of this to come!  
> [< Previous](https://github.com/xitu/gold-miner/blob/master/TODO1/the-forgotten-history-of-oop.md) | [<< Start over at Part 1](https://github.com/xitu/gold-miner/blob/a9a689ee3df732ea0c9e88207ad6cf0a10ad7d4b/TODO1/composing-software-an-introduction.md)

With the dramatic rise of functional programming in mainstream JavaScript, curried functions have become common in many applications. It’s important to understand what they are, how they work, and how to put them to good use.

### What is a curried function?

A curried function is a function that takes multiple arguments _one at a time._ Given a function with 3 parameters, the curried version will take one argument and return a function that takes the next argument, which returns a function that takes the third argument. The last function returns the result of applying the function to all of its arguments.

You can do the same thing with more or fewer parameters. For example, given two numbers, `a` and `b` in curried form, return the sum of `a` and `b`:

```
// add = a => b => Number
const add = a => b => a + b;
```

To use it, we must apply both functions, using the function application syntax. In JavaScript, the parentheses `()` after the function reference triggers function invocation. When a function returns another function, the returned function can be immediately invoked by adding an extra set of parentheses:

```
const result = add(2)(3); // => 5
```

First, the function takes `a`, and then _returns a new function,_ which then takes `b` returns the sum of `a` and `b`. Each argument is taken _one at a time._ If the function had more parameters, it could simply continue to return new functions until all of the arguments are supplied and the application can be completed.

The `add` function takes one argument, and then returns a **partial application** of itself with `a` **fixed** in the closure scope. A **closure** is a function bundled with its lexical scope. Closures are created at runtime during function creation. Fixed means that the variables are assigned values in the closure's bundled scope.

The parentheses in the example above represent function invocations: `add` is invoked with `2`, which returns a partially applied function with `a` fixed to `2`. Instead of assigning the return value to a variable or otherwise using it, we immediately invoke the returned function by passing `3` to it in parentheses, which completes the application and returns `5`.

### What is a partial application?

A **partial application** is a function which has been applied to some, but not yet all of its arguments. In other words, it’s a function which has some arguments _fixed_ inside its closure scope. A function with some of its parameters fixed is said to be _partially applied_.

### What’s the Difference?

Partial applications can take as many or as few arguments a time as desired. Curried functions on the other hand _always_ return a unary function: a function which takes _one argument._

All curried functions return partial applications, but not all partial applications are the result of curried functions.

The unary requirement for curried functions is an important feature.

### What is point-free style?

Point-free style is a style of programming where function definitions do not make reference to the function’s arguments. Let’s look at function definitions in JavaScript:

```
function foo (/* parameters are declared here*/) {
  // ...
}

const foo = (/* parameters are declared here */) => // ...

const foo = function (/* parameters are declared here */) {
  // ...
}
```

How can you define functions in JavaScript without referencing the required parameters? Well, we can’t use the `function`keyword, and we can't use an arrow function (`=>`) because those require any formal parameters to be declared (which would reference its arguments). So what we'll need to do instead is call a function that returns a function.

Create a function that increments whatever number you pass to it by one using point-free style. Remember, we already have a function called `add` that takes a number and returns a partially applied function with its first parameter fixed to whatever you pass in. We can use that to create a new function called `inc()`:

```
// inc = n => Number
// Adds 1 to any number.
const inc = add(1);

inc(3); // => 4
```

This gets interesting as a mechanism for generalization and specialization. The returned function is just a _specialized version_ of the more general `add()` function. We can use `add()` to create as many specialized versions as we want:

```
const inc10 = add(10);
const inc20 = add(20);

inc10(3); // => 13
inc20(3); // => 23
```

And of course, these all have their own closure scopes (closures are created at function creation time — when `add()` is invoked), so the original `inc()` keeps working:

```
inc(3) // 4
```

When we create `inc()` with the function call `add(1)`, the `a` parameter inside `add()` gets _fixed_ to `1` inside the returned function that gets assigned to `inc`.

Then when we call `inc(3)`, the `b` parameter inside `add()` is replaced with the argument value, `3`, and the application completes, returning the sum of `1` and `3`.

All curried functions are a form of higher-order function which allows you to create specialized versions of the original function for the specific use case at hand.

### Why do we curry?

Curried functions are particularly useful in the context of function composition.

In algebra, given two functions, `f` and `g`:

```
f: a -> b
g: b -> c
```

You can compose those functions together to create a new function, `h` from `a` directly to `c`:

```
// Algebra definition, borrowing the `.` composition operator
// from Haskell

h: a -> c
h = f . g = f(g(x))
```

In JavaScript:

```
const g = n => n + 1;
const f = n => n * 2;

const h = x => f(g(x));

h(20); //=> 42
```

The algebra definition:

```
f . g = f(g(x))
```

Can be translated into JavaScript:

```
const compose = (f, g) => f(g(x));
```

But that would only be able to compose two functions at a time. In algebra, it’s possible to write:

```
g . f . h
```

We can write a function to compose as many functions as you like. In other words, `compose()` creates a pipeline of functions with the output of one function connected to the input of the next.

Here’s the way I usually write it:

```
const compose = (...fns) => x => fns.reduceRight((y, f) => f(y), x);
```

This version takes any number of functions and returns a function which takes the initial value, and then uses `reduceRight()` to iterate right-to-left over each function, `f`, in `fns`, and apply it in turn to the accumulated value, `y`. What we're accumulating with the accumulator, `y` in this function is the return value for the function returned by `compose()`.

Now we can write our composition like this:

```
const g = n => n + 1;
const f = n => n * 2;

// replace `x => f(g(x))` with `compose(f, g)`
const h = compose(f, g);

h(20); //=> 42
```

### Trace

Function composition using point-free style creates very concise, readable code, but it can come at the cost of easy debugging. What if you want to inspect the values between functions? `trace()` is a handy utility that will allow you to do just that. It takes the form of a curried function:

```
const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};
```

Now we can inspect the pipeline:

```
const compose = (...fns) => x => fns.reduceRight((y, f) => f(y), x);

const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

/*
Note: function application order is
bottom-to-top:
*/

const h = compose(
  trace('after f'),
  f,
  trace('after g'),
  g
);

h(20);
/*
after g: 21
after f: 42
*/
```

`compose()` is a great utility, but when we need to compose more than two functions, it's sometimes handy if we can read them in top-to-bottom order. We can do that by reversing the order the functions are called. There's another composition utility called `pipe()` that composes in reverse order:

```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);
```

Now we can write the above code like this:

```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

/*
Now the function application order
runs top-to-bottom:
*/
const h = pipe(
  g,
  trace('after g'),
  f,
  trace('after f'),
);

h(20);
/*
after g: 21
after f: 42
*/
```

### Curry and Function Composition, Together

Even outside the context of function composition, currying is certainly a useful abstraction we can use to specialize functions. For example, a curried version of `map()` can be specialized to do many different things:

```
const map = fn => mappable => mappable.map(fn);

const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);
const log = (...args) => console.log(...args);

const arr = [1, 2, 3, 4];
const isEven = n => n % 2 === 0;

const stripe = n => isEven(n) ? 'dark' : 'light';
const stripeAll = map(stripe);
const striped = stripeAll(arr); 
log(striped);
// => ["light", "dark", "light", "dark"]

const double = n => n * 2;
const doubleAll = map(double);
const doubled = doubleAll(arr);
log(doubled);
// => [2, 4, 6, 8]
```

But the real power of curried functions is that they simplify function composition. A function can take any number of inputs, but can only return a single output. In order for functions to be composable, the output type must align with the expected input type:

```
f: a => b
g:      b => c
h: a    =>   c
```

If the `g` function above expected two parameters, the output from `f` wouldn't line up with the input for `g`:

```
f: a => b
g:     (x, b) => c
h: a    =>   c
```

How do we get `x` into `g` in this scenario? Usually, the answer is to _curry_ `_g_`_._

Remember the definition of a curried function is a function which takes multiple parameters _one at a time_ by taking the first argument and returning a series of functions which each take the next argument until all the parameters have been collected.

The key words in that definition are “one at a time”. The reason that curried functions are so convenient for function composition is that they transform functions which expect multiple parameters into functions which can take a single argument, allowing them to fit in a function composition pipeline. Take the `trace()` function as an example, from earlier:

```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

const h = pipe(
  g,
  trace('after g'),
  f,
  trace('after f'),
);

h(20);
/*
after g: 21
after f: 42
*/
```

`trace()` defines two parameters, but takes them one at a time, allowing us to specialize the function inline. If `trace()` were not curried, we couldn't use it in this way. We'd have to write the pipeline like this:

```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = (label, value) => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

const h = pipe(
  g,
  // the trace() calls are no longer point-free,
  // introducing the intermediary variable, `x`.
  x => trace('after g', x),
  f,
  x => trace('after f', x),
);

h(20);
```

But simply currying a function is not enough. You also need to ensure that the function is expecting parameters in the correct order to specialize them. Look what happens if we curry `trace()` again, but flip the parameter order:

```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = value => label => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

const h = pipe(
  g,
  // the trace() calls can't be point-free,
  // because arguments are expected in the wrong order.
  x => trace(x)('after g'),
  f,
  x => trace(x)('after f'),
);

h(20);
```

If you’re in a pinch, you can fix that problem with a function called `flip()`, which simply flips the order of two parameters:

```
const flip = fn => a => b => fn(b)(a);
```

Now we can crate a `flippedTrace()` function:

```
const flippedTrace = flip(trace);
```

And use it like this:

```
const flip = fn => a => b => fn(b)(a);
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = value => label => {
  console.log(`${ label }: ${ value }`);
  return value;
};
const flippedTrace = flip(trace);

const g = n => n + 1;
const f = n => n * 2;

const h = pipe(
  g,
  flippedTrace('after g'),
  f,
  flippedTrace('after f'),
);

h(20);
```

But a better approach is to write the function correctly in the first place. The style is sometimes called “data last”, which means that you should take the specializing parameters first, and take the data the function will act on last. That gives us the original form of the function:

```
const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};
```

Each application of `trace()` to a `label` creates a specialized version of the trace function that is used in the pipeline, where the label is fixed inside the returned partial application of `trace`. So this:

```
const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const traceAfterG = trace('after g');
```

… is equivalent to this:

```
const traceAfterG = value => {
  const label = 'after g';
  console.log(`${ label }: ${ value }`);
  return value;
};
```

If we swapped `trace('after g')` for `traceAfterG`, it would mean the same thing:

```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};

// The curried version of trace()
// saves us from writing all this code...
const traceAfterG = value => {
  const label = 'after g';
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

const h = pipe(
  g,
  traceAfterG,
  f,
  trace('after f'),
);

h(20);
```

### Conclusion

A **curried function** is a function which takes multiple parameters one at a time, by taking the first argument, and returning a series of functions which each take the next argument until all the parameters have been fixed, and the function application can complete, at which point, the resulting value is returned.

A **partial application** is a function which has already been applied to some — but not yet all — of its arguments. The arguments which the function has already been applied to are called _fixed parameters_.

**Point-free style** is a way of defining a function without reference to its arguments. Generally, a point-free function is created by calling a function which returns a function, such as a curried function.

**Curried functions are great for function composition,** because they allow you to easily convert an n-ary function into the unary function form needed for function composition pipelines: Functions in a pipeline must expect exactly one argument.

**Data last functions** are convenient for function composition, because they can be easily used in point-free style.

### Next Steps

A complete video walkthrough of this is available to members of [EricElliottJS.com](https://ericelliottjs.com/). Members, visit the [ES6 Curry & Composition lesson](https://ericelliottjs.com/premium-content/es6-curry-composition/).

* * *

**_Eric Elliott_** _is the author of_ [_“Programming JavaScript Applications”_](http://pjabook.com) _(O’Reilly), and cofounder of the software mentorship platform,_ [_DevAnywhere.io_](https://devanywhere.io/)_. He has contributed to software experiences for_ **_Adobe Systems_**_,_ **_Zumba Fitness_**_,_ **_The Wall Street Journal_**_,_ **_ESPN_**_,_ **_BBC_**_, and top recording artists including_ **_Usher_**_,_ **_Frank Ocean_**_,_ **_Metallica_**_, and many more._

_He works remote from anywhere with the most beautiful woman in the world._

Thanks to [JS_Cheerleader](https://medium.com/@JS_Cheerleader?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
