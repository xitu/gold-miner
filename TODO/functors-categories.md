> * 原文地址：[Functors & Categories](https://medium.com/javascript-scene/functors-categories-61e031bac53f)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Functors & Categories #

## Composable Software ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg">

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)
> Note: This is part of the “Composing Software” series on learning functional programming and compositional software techniques in JavaScript ES6+ from the ground up. Stay tuned. There’s a lot more of this to come!
> [< Previous](https://medium.com/javascript-scene/reduce-composing-software-fe22f0c39a1d#.w4y0mlpcs) | [<< Start over at Part 1](https://medium.com/javascript-scene/the-rise-and-fall-and-rise-of-functional-programming-composable-software-c2d91b424c8c#.2dfd6n6qe) 

A **functor** is something that can be mapped over. In other words, it’s a container which has an interface which can be used to apply a function to the values inside it. When you see the word functor, you should think *“mappable”.*

The term “functor” comes from category theory. In category theory, a functor is a mapping between categories. Loosely, a **category** is a group of things, where each “thing” can be any value. In code, a functor is sometimes represented as an object with a `.map()` method that maps from one set of values to another.

A functor supplies a box with zero or more things inside, and a mapping interface. An array is a good example of a functor, but many other kinds of objects can be mapped over as well, including single valued-objects, streams, trees, objects, etc…

For collections (arrays, streams, etc…), `.map()` typically iterates over the collection and applies the given function to each value in the collection, but not all functors iterate.

In JavaScript, Arrays and Promises are functors (`.then()` obeys the functor laws), but lots of libraries exist that will turn a variety of other things into functors, too.

In Haskell, the functor type is defined as:

```
fmap :: (a -> b) -> f a -> f b
```

Given a function that takes an `a` and returns a `b` and a functor with zero or more `a`s inside it: `fmap` returns a box with zero or more `b`s inside it. The `f a` and `f b` bits can be read as “a functor of `a`” and “a functor of `b`”, meaning `f a` has `a`s inside the box, and `f b` has `b`s inside the box.

Using a functor is easy — just call `map()`:

```
const f = [1, 2, 3];
f.map(double); // [2, 4, 6]
```

### Functor Laws ###

Categories have two important properties:

1. Identity
2. Composition

Since a functor is a mapping between categories, functors must respect identity and composition. Together, they’re known as the functor laws.

### Identity ###

If you pass the identity function (`x => x`) into `f.map()`, where `f` is any functor, the result should be equivalent to (have the same meaning as) `f`:

```
const f = [1, 2, 3];
f.map(x => x); // [1, 2, 3]
```

### Composition ###

Functors must obey the composition law: `F.map(x => f(g(x)))` is equivalent to `F.map(g).map(f)`.

Function Composition is the application of one function to the result of another, e.g., given an `x` and the functions, `f` and `g`, the composition `(f ∘ g)(x)` (usually shortened to `f ∘ g` - the `(x)` is implied) means `f(g(x))`.

A lot of functional programming terms come from category theory, and the essence of category theory is composition. Category theory is scary at first, but easy. Like jumping off a diving board or riding a roller coaster. Here’s the foundation of category theory in a few bullet points:

- A category is a collection of objects and arrows between objects (where “object” can mean literally anything).
- Arrows are known as morphisms. Morphisms can be thought of and represented in code as functions.
- For any group of connected objects, `a -> b -> c`, there must be a composition which goes directly from `a -> c`.
- All arrows can be represented as compositions (even if it’s just a composition with the object’s identity arrow). All objects in a category have identity arrows.

Say you have a function `g` that takes an `a` and returns a `b`, and another function `f` that takes a `b` and returns a `c`; there must also be a function `h` that represents the composition of `f` and `g`. So, the composition from `a -> c`, is the composition `f ∘ g` (`f`*after*`g`). So, `h(x) = f(g(x))`. Function composition works right to left, not left to right, which is why `f ∘ g` is frequently called `f`*after*`g`.

Composition is associative. Basically that means that when you’re composing multiple functions (morphisms if you’re feeling fancy), you don’t need parenthesis:

```
h∘(g∘f) = (h∘g)∘f = h∘g∘f
```

Let’s take another look at the composition law in JavaScript:

Given a functor, `F`:

```
const F = [1, 2, 3];
```

The following are equivalent:

```
F.map(x => f(g(x)));

// is equivalent to...

F.map(g).map(f);
```

### Endofunctors ###

An endofunctor is a functor that maps from a category back to the same category.

A functor can map from category to category: `F a -> F b`

An endofunctor maps from a category to the same category: `F a -> F a`

`F` here represents a *functor type* and `a` represents a category variable (meaning it can represent any category, including a set or a category of all possible values in a data type).

A monad is an endofunctor. Remember:

> *“A monad is just a monoid in the category of endofunctors. What’s the problem?”*

Hopefully that quote is starting to make a little more sense. We’ll get to monoids and monads later.

### Build Your Own Functor ###

Here’s a simple example of a functor:

```
const Identity = value => ({
  map: fn => Identity(fn(value))
});
```

As you can see, it satisfies the functor laws:

```
// trace() is a utility to let you easily inspect
// the contents.
const trace = x => {
  console.log(x);
  return x;
};

const u = Identity(2);

// Identity law
u.map(trace);             // 2
u.map(x => x).map(trace); // 2

const f = n => n + 1;
const g = n => n * 2;

// Composition law
const r1 = u.map(x => f(g(x)));
const r2 = u.map(g).map(f);

r1.map(trace); // 5
r2.map(trace); // 5
```

Now you can map over any data type, just like you can map over an array. Nice!

That’s about as simple as a functor can get in JavaScript, but it’s missing some features we expect from data types in JavaScript. Let’s add them. Wouldn’t it be cool if the `+` operator could work for number and string values?

To make that work, all we need to do is implement `.valueOf()` -- which also seems like a convenient way to unwrap the value from the functor:

```
const Identity = value => ({
  map: fn => Identity(fn(value)),

  valueOf: () => value,
});

const ints = (Identity(2) + Identity(4));
trace(ints); // 6

const hi = (Identity('h') + Identity('i'));
trace(hi); // "hi"
```

Nice. But what if we want to inspect an `Identity` instance in the console? It would be cool if it would say `"Identity(value)"`, right. Let's add a `.toString()` method:

```
toString: () => `Identity(${value})`,
```

Cool. We should probably also enable the standard JS iteration protocol. We can do that by adding a custom iterator:

```
  [Symbol.iterator]: () => {
    let first = true;
    return ({
      next: () => {
        if (first) {
          first = false;
          return ({
            done: false,
            value
          });
        }
        return ({
          done: true
        });
      }
    });
  },
```

Now this will work:

```
// [Symbol.iterator] enables standard JS iterations:
const arr = [6, 7, ...Identity(8)];
trace(arr); // [6, 7, 8]
```

What if you want to take an `Identity(n)` and return an array of Identities containing `n + 1`, `n + 2`, and so on? Easy, right?

```
const fRange = (
  start,
  end
) => Array.from(
  { length: end - start + 1 },
  (x, i) => Identity(i + start)
);
```

Ah, but what if you want this to work with any functor? What if we had a spec that said that each instance of a data type must have a reference to its constructor? Then you could do this:

```
const fRange = (
  start,
  end
) => Array.from(
  { length: end - start + 1 },

  // change `Identity` to `start.constructor`
  (x, i) => start.constructor(i + start)
);

const range = fRange(Identity(2), 4);
range.map(x => x.map(trace)); // 2, 3, 4
```

What if you want to test to see if a value is a functor? We could add a static method on `Identity` to check. We should throw in a static `.toString()` while we're at it:

```
Object.assign(Identity, {
  toString: () => 'Identity',
  is: x => typeof x.map === 'function'
});
```

Let’s put all this together:

```
const Identity = value => ({
  map: fn => Identity(fn(value)),

  valueOf: () => value,

  toString: () => `Identity(${value})`,

  [Symbol.iterator]: () => {
    let first = true;
    return ({
      next: () => {
        if (first) {
          first = false;
          return ({
            done: false,
            value
          });
        }
        return ({
          done: true
        });
      }
    });
  },

  constructor: Identity
});

Object.assign(Identity, {
  toString: () => 'Identity',
  is: x => typeof x.map === 'function'
});
```

Note you don’t need all this extra stuff for something to qualify as a functor or an endofunctor. It’s strictly for convenience. All you *need* for a functor is a `.map()` interface that satisfies the functor laws.

### Why Functors? ###

Functors are great for lots of reasons. Most importantly, they’re an abstraction that you can use to implement lots of useful things in a way that works with any data type. For instance, what if you want to kick off a chain of operations, but only if the value inside the functor is not `undefined` or `null`?

```
// Create the predicate
const exists = x => (x.valueOf() !== undefined && x.valueOf() !== null);

const ifExists = x => ({
  map: fn => exists(x) ? x.map(fn) : x
});

const add1 = n => n + 1;
const double = n => n * 2;

// Nothing happens...
ifExists(Identity(undefined)).map(trace);
// Still nothing...
ifExists(Identity(null)).map(trace);

// 42
ifExists(Identity(20))
  .map(add1)
  .map(double)
  .map(trace)
;
```

Of course, functional programming is all about composing tiny functions to create higher level abstractions. What if you want a generic map that works with any functor? That way you can partially apply arguments to create new functions.

Easy. Pick your favorite auto-curry, or use this magic spell from before:

```
const curry = (
  f, arr = []
) => (...args) => (
  a => a.length === f.length ?
    f(...a) :
    curry(f, a)
)([...arr, ...args]);
```

Now we can customize map:

```
const map = curry((fn, F) => F.map(fn));

const double = n => n * 2;

const mdouble = map(double);
mdouble(Identity(4)).map(trace); // 8
```

### Conclusion ###

Functors are things we can map over. More specifically, a functor is a mapping from category to category. A functor can even map from a category back to the same category (i.e., an *endofunctor*).

A category is a collection of objects, with arrows between objects. Arrows represent morphisms (aka functions, aka compositions). Each object in a category has an identity morphism (`x => x`). For any chain of objects `A -> B -> C` there must exist a composition `A -> C`.

Functors are great higher-order abstractions that allow you to create a variety of generic functions that will work for any data type.

**To be continued…**

### Next Steps ###

Want to learn more about functional programming in JavaScript?

[Learn JavaScript with Eric Elliott](http://ericelliottjs.com/product/lifetime-access-pass/). If you’re not a member, you’re missing out!

[<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg">
](https://ericelliottjs.com/product/lifetime-access-pass/) 

***Eric Elliott*** is the author of [*“Programming JavaScript Applications”*](http://pjabook.com)  (O’Reilly), and [*“Learn JavaScript with Eric Elliott”*](http://ericelliottjs.com/product/lifetime-access-pass/) . He has contributed to software experiences for **Adobe Systems, Zumba Fitness, The Wall Street Journal, ESPN, BBC**, and top recording artists including **Usher, Frank Ocean, Metallica**, and many more.

*He spends most of his time in the San Francisco Bay Area with the most beautiful woman in the world.*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
