> * 原文地址：[Lenses: Composable Getters and Setters for Functional Programming](https://medium.com/javascript-scene/lenses-b85976cb0534)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lenses-composable-getters-and-setterssfor-functional-programming.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lenses-composable-getters-and-setterssfor-functional-programming.md)
> * 译者：
> * 校对者：

# Lenses: Composable Getters and Setters for Functional Programming

![](https://cdn-images-1.medium.com/max/2000/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)

> **Note:** This is part of the [**“Composing Software” book**](https://leanpub.com/composingsoftware) that started life right here as a blog post series. It covers functional programming and compositional software techniques in JavaScript (ES6+) from the ground up.  
> [_< Previous_](https://github.com/xitu/gold-miner/blob/master/TODO1/transducers-efficient-data-processing-pipelines-in-javascript.md) _|_ [_<< Start over at Part 1_](https://juejin.im/post/5c0dd214518825444758453a)

A lens is a composable pair of pure getter and setter functions which focus on a particular field inside an object, and obey a set of axioms known as the lens laws. Think of the object as the _whole_ and the field as the _part_. The getter takes a whole and returns the part of the object that the lens is focused on.

```
// view = whole => part
```

The setter takes a whole, and a value to set the part to, and returns a new whole with the part updated. Unlike a function which simply sets a value into an object’s member field, Lens setters are pure functions:

```
// set = whole => part => whole
```

> **Note:** In this text, we’re going to use some naive lenses in the code examples just to give you a beneath-the-hood peek at the general concept. For production code, you should look at a well tested library like Ramda, instead. The API differs between different lens libraries, and it’s possible to express lenses in more composable, elegant ways than they are presented here.

Imagine you have a tuple array representing a point’s `x`, `y`, and `z` coordinates:

```
[x, y, z]
```

To get or set each field individually, you might create three lenses. One for each axis. You could manually create getters which focus on each field:

```
const getX = ([x]) => x;
const getY = ([x, y]) => y;
const getZ = ([x, y, z]) => z;

console.log(
  getZ([10, 10, 100]) // 100
);
```

Likewise, the corresponding setters might look like this:

```
const setY = ([x, _, z]) => y => ([x, y, z]);

console.log(
  setY([10, 10, 10])(999) // [10, 999, 10]
);
```

### Why Lenses?

State shape dependencies are a common source of coupling in software. Many components may depend on the shape of some shared state, so if you need to later change the shape of that state, you have to change logic in multiple places.

Lenses allow you to abstract state shape behind getters and setters. Instead of littering your codebase with code that dives deep into the shape of a particular object, import a lens. If you later need to change the state shape, you can do so in the lens, and none of the code that depends on the lens will need to change.

This follows the principle that a small change in requirements should require only a small change in the system.

### Background

In 1985, [“Structure and Interpretation of Computer Programs”](https://www.amazon.com/Structure-Interpretation-Computer-Programs-Engineering/dp/0262510871/ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=eejs-20&linkId=9fac31d60f8b9b60f63f71ab716694bc) described getter and setter pairs (called `put` and `get` in the text) as a way to isolate an object's shape from the code that uses the object. The text shows how to create generic selectors that access parts of a complex number independent of how the number is represented. That isolation is useful because it breaks state shape dependencies. These getter/setter pairs were a bit like referenced queries which have existed in relational databases for decades.

Lenses took the concept further by making getter/setter pairs more generic and composable. They were popularized after Edward Kmett released the Lens library for Haskell. He was influenced by Jeremy Gibbons and Bruno C. d. S. Oliveira, who demonstrated that traversals express the iterator pattern, Luke Palmer’s “accessors”, Twan van Laarhoven, and Russell O’Connor.

> **Note:** An easy mistake to make is to equate the modern notion of a functional lens with Anamorphisms, based on Erik Meijer, Maarten Fokkinga, and Ross Paterson’s [“Functional Programming with Bananas, Lenses, Envelopes and Barbed Wire”](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.41.125) in 1991. “The term ‘lens’ in the functional reference sense refers to the fact that it looks at part of a whole. The term ‘lens’ in a recursion scheme sense refers to the fact that `[(` and `)]` syntactically look kind of like concave lenses. **tl;dr** They have nothing to do with one another." ~ [Edward Kmett on Stack Overflow](https://stackoverflow.com/questions/17198072/how-is-anamorphism-related-to-lens)

### Lens Laws

The lens laws are algebraic axioms which ensure that the lens is well behaved.

1.  `view(lens, set(lens, a, store)) ≡ a` — If you set a value into the store, and immediately view the value through the lens, you get the value that was set.
2.  `set(lens, b, set(lens, a, store)) ≡ set(lens, b, store)` — If you set a lens value to `a` and then immediately set the lens value to `b`, it's the same as if you'd just set the value to `b`.
3.  `set(lens, view(lens, store), store) ≡ store` — If you get the lens value from the store, and then immediately set that value back into the store, the value is unchanged.

Before we dive into code examples, remember that if you’re using lenses in production, you should probably be using a well tested lens library. The best one I know of in JavaScript is Ramda. We’re going to skip that for now and build some naive lenses ourselves, just for the sake of learning:

```
// Pure functions to view and set which can be used with any lens:
const view = (lens, store) => lens.view(store);
const set = (lens, value, store) => lens.set(value, store);

// A function which takes a prop, and returns naive
// lens accessors for that prop.
const lensProp = prop => ({
  view: store => store[prop],
  // This is very naive, because it only works for objects:
  set: (value, store) => ({
    ...store,
    [prop]: value
  })
});

// An example store object. An object you access with a lens
// is often called the "store" object:
const fooStore = {
  a: 'foo',
  b: 'bar'
};

const aLens = lensProp('a');
const bLens = lensProp('b');

// Destructure the `a` and `b` props from the lens using
// the `view()` function.
const a = view(aLens, fooStore);
const b = view(bLens, fooStore);
console.log(a, b); // 'foo' 'bar'

// Set a value into our store using the `aLens`:
const bazStore = set(aLens, 'baz', fooStore);

// View the newly set value.
console.log( view(aLens, bazStore) ); // 'baz'
```

Let’s prove the lens laws for these functions:

```
const store = fooStore;

{
  // `view(lens, set(lens, value, store))` = `value`
  // If you set a value into the store, and immediately
  // view the value through the lens, you get the value
  // that was set.
  const lens = lensProp('a');
  const value = 'baz';

  const a = value;
  const b = view(lens, set(lens, value, store));

  console.log(a, b); // 'baz' 'baz'
}

{
  // set(lens, b, set(lens, a, store)) = set(lens, b, store)
  // If you set a lens value to `a` and then immediately set the lens value to `b`,
  // it's the same as if you'd just set the value to `b`.
  const lens = lensProp('a');

  const a = 'bar';
  const b = 'baz';

  const r1 = set(lens, b, set(lens, a, store));
  const r2 = set(lens, b, store);
  
  console.log(r1, r2); // {a: "baz", b: "bar"} {a: "baz", b: "bar"}
}

{
  // `set(lens, view(lens, store), store)` = `store`
  // If you get the lens value from the store, and then immediately set that value
  // back into the store, the value is unchanged.
  const lens = lensProp('a');

  const r1 = set(lens, view(lens, store), store);
  const r2 = store;
  
  console.log(r1, r2); // {a: "foo", b: "bar"} {a: "foo", b: "bar"}
}
```

### Composing Lenses

Lenses are composable. When you compose lenses, the resulting lens will dive deep into the object, traversing the full object path. Let’s import the more full-featured `lensProp` from Ramda to demonstrate:

```
import { compose, lensProp, view } from 'ramda';

const lensProps = [
  'foo',
  'bar',
  1
];

const lenses = lensProps.map(lensProp);
const truth = compose(...lenses);

const obj = {
  foo: {
    bar: [false, true]
  }
};

console.log(
  view(truth, obj)
);
```

That’s great, but there’s more to composition with lenses that we should be aware of. Let’s take a deeper dive.

### Over

It’s possible to apply a function from `a => b` in the context of any functor data type. We've already demonstrated that functor mapping _is composition._ Similarly, we can apply a function to the value of focus in a lens. Typically, that value would be of the same type, so it would be a function from `a => a`. The lens map operation is commonly called "over" in JavaScript libraries. We can create it like this:

```
// over = (lens, f: a => a, store) => store
const over = (lens, f, store) => set(lens, f(view(lens, store)), store);

const uppercase = x => x.toUpperCase();

console.log(
  over(aLens, uppercase, store) // { a: "FOO", b: "bar" }
);
```

Setters obey the functor laws:

```
{ // if you map the identity function over a lens
  // the store is unchanged.
  const id = x => x;
  const lens = aLens;
  const a = over(lens, id, store);
  const b = store;

  console.log(a, b);
}
```

For the composition example, we’re going to use an auto-curried version of over:

```
import { curry } from 'ramda';

const over = curry(
  (lens, f, store) => set(lens, f(view(lens, store)), store)
);
```

Now it’s easy to see that lenses under the over operation also obey the functor composition law:

```
{ // over(lens, f) after over(lens g) is the same as
  // over(lens, compose(f, g))
  const lens = aLens;

  const store = {
    a: 20
  };

  const g = n => n + 1;
  const f = n => n * 2;

  const a = compose(
    over(lens, f),
    over(lens, g)
  );

  const b = over(lens, compose(f, g));

  console.log(
    a(store), // {a: 42}
    b(store)  // {a: 42}
  );
}
```

We’ve barely scratched the surface of lenses here, but it should be enough to get you started. For a lot more, detail, Edward Kmett has spoken a lot on the topic, and many people have written much more in-depth explorations.

* * *

**_Eric Elliott_** _is a distributed systems expert and author of the books,_ [_“Composing Software”_](https://leanpub.com/composingsoftware) _and_ [_“Programming JavaScript Applications”_](https://ericelliottjs.com/product/programming-javascript-applications-ebook/)_. As co-founder of_ [_DevAnywhere.io_](https://devanywhere.io/)_, he teaches developers the skills they need to work remotely and embrace work/life balance. He builds and advises development teams for crypto projects, and has contributed to software experiences for_ **_Adobe Systems,_**  **_Zumba Fitness,_**  **_The Wall Street Journal,_**  **_ESPN,_**  **_BBC,_** _and top recording artists including_ **_Usher, Frank Ocean, Metallica,_** _and many more._

_He enjoys a remote lifestyle with the most beautiful woman in the world._

Thanks to [JS_Cheerleader](https://medium.com/@JS_Cheerleader?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
