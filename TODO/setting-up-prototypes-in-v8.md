> * 原文地址：[Setting up prototypes in V8](https://medium.com/@tverwaes/setting-up-prototypes-in-v8-ec9c9491dfe2)
> * 原文作者：[Toon Verwaest](https://medium.com/@tverwaes?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/setting-up-prototypes-in-v8.md](https://github.com/xitu/gold-miner/blob/master/TODO/setting-up-prototypes-in-v8.md)
> * 译者：
> * 校对者：

# Setting up prototypes in V8

Prototypes (as in `func.prototype`) are used to emulate classes. They typically contain all methods of the class, their `__proto__` is the “superclass”, and they do not change after they are set up.

The performance of setting up prototypes is important for startup time of applications since that’s often when the entire class hierarchy is set up.

### Transitioning object shapes

The main way objects are encoded is by separating the _hidden class_ (description) from the _object_ (content). When new objects are instantiated, they are created using the same _initial hidden class_ as previous objects from the same constructor. As properties are added, objects _transition_ from hidden class to hidden class, typically following previous transitions in the so-called “transition tree”. E.g., if we have the following constructor:

```
function C() {
  this.a = 1;
  this.b = 2;
}
```

If we instantiate an object `var o = new C()`, it starts out using an initial hidden class M0 attached to C without any properties. When `a` is added, we transition from that hidden class to a new hidden class M1 that described the property `a`. And then when we add `b`, we go to a new hidden class that describes both `a` and `b`.

If we now instantiate a second object `var o2 = new C()` it will follow those transitions. It starts out using M0, then goes to M1 and finally M2 as `a` and `b` are added.

Doing this has 3 main advantages:

1.  Even though setting up the first object is fairly expensive and requires us to create all the hidden classes and transitions, setting up subsequent objects is really fast.
2.  The resulting objects are smaller than full dictionaries would be. We only need to store values in the object rather than also information about the property (such as the name).
3.  We now have a shape description we can use in both inline caches and optimized code to quickly access similarly shaped objects in a single location.

This works very well for object shapes that are expected to reoccur very frequently. A similar thing happens internally for object literals: `{a:1, b:2}` will also internally have hidden classes M0, M1 and M2.

A lot has been written about this; see e.g., the following explanation by Lars Bak:

YouTube 视频见：https://youtu.be/hWhMKalEicY

### Prototypes are special snowflakes

Unlike instances created from regular constructors, prototypes are typically unique objects that don’t share shape with other of objects. This changes the calculation for all 3 points above:

1.  There’s typically no object that will benefit from the cached transitions, and setting up the transition tree is just an unnecessary cost.
2.  There’s nothing to offset the memory overhead from creating all the transitioning hidden classes. In fact, before we changed this, we’d typically see a large fraction of hidden classes used for single prototypes.
3.  Loading from a prototype is actually not as common as using it through the prototype chain. If we load from a prototype object through a prototype chain, we won’t have dispatched on the prototype’s hidden class and need a different way to check if it’s valid anyway.

To optimize prototypes, V8 keeps track of their shape differently from regular transitioning objects. Instead of keeping track of the transition tree, we tailor the hidden class to the prototype object, and always keep it fast. E.g., even if `delete object.property` would typically turn objects into a “slow” state, this isn’t the case for prototypes. We’ll always keep them cacheable (with some caveats that we’re working on resolving).

We also changed how we set up prototypes. Prototypes have 2 main phases: _setup_ and _use._ Prototypes in the _setup_ phase are encoded as dictionary objects. Stores to prototypes in that state are really fast, and do not necessarily need to enter the C++ runtime (a boundary crossing which is pretty expensive). This is a huge improvement over the initial object setup that needs to create a transitioning hidden class; partially because this has to be done in the C++ runtime.

Any direct access to the prototype, or access through a prototype chain, will transition it to _use_ state, making sure that all such accesses from now on are fast. And as stated above, even if you delete a property, we’ll turn it fast again afterwards.

```
function Foo() {}
// Now proto is in "setup" mode.
var proto = Foo.prototype;
proto.method1 = function() { ... }
proto.method2 = function() { ... }

var o = new Foo();
// Transitions proto to "use" mode.
o.method1();

// Also transitions proto to "use" mode.
proto.method1.call(o);
```

### Is it a prototype?

To be able to benefit from any of the above, we need to know that an object is actually used as a prototype. Because of the nature of JS, it’s very hard to analyze your program at compile time. For that reason we don’t even try to figure out at object creation whether something will end up as a prototype at this moment (this may change over time of course…). Once we see an object installed as a prototype, we’ll mark it as such. E.g., if you do:

```
var o = {x:1};
func.prototype = o;
```

we don’t know that `o` is used as a prototype until fully at the end. We’ll have created the object in the typical fairly expensive transition-creating manner. Once it’s installed though, it’s marked as a prototype, and goes into the _setup_ state. And into the _use_ phaseonce you start using it.

If instead you’d do the following, we’ll know that `o` is a prototype before any properties are added. It’ll go into the _setup_ phase before properties are added, and it’ll be much faster:

```
var o = {};
func.prototype = o;
o.x = 1;
```

Note that it’s also fine to just use `var o = func.prototype`, since `func.prototype` is always created as something that knows it’s a prototype; obviously ;-).

### How to set up prototypes

If you set up your prototype in the following way, you get the benefit that we know func.prototype is a prototype before methods are added:

```
// Omit the following line if the default Object.prototype as __proto__ is fine.
func.prototype = Object.create(…);
func.prototype.method1 = …
func.prototype.method2 = …
```

While this is already pretty good, we actually have to load `func.prototype` for each method. Even though we have recently further optimized specifically the `func.prototype` loads, they are unnecessary and will be worse for performance and memory usage than just direct local variable access.

In short, the ideal way to setup prototypes is as follows:

```
var proto = func.prototype = Object.create(…);
proto.method1 = …
proto.method2 = …
```

Thanks to [Benedikt Meurer](https://medium.com/@bmeurer?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
