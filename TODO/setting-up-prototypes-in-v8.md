> * 原文地址：[Setting up prototypes in V8](https://medium.com/@tverwaes/setting-up-prototypes-in-v8-ec9c9491dfe2)
> * 原文作者：[Toon Verwaest](https://medium.com/@tverwaes?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/setting-up-prototypes-in-v8.md](https://github.com/xitu/gold-miner/blob/master/TODO/setting-up-prototypes-in-v8.md)
> * 译者：[缪宇](https://juejin.im/user/57df39fca0bb9f0058a3c63d/posts)
> * 校对者：[zhmhhu](https://github.com/zhmhhu) [老教授](https://juejin.im/user/58ff449a61ff4b00667a745c) 

# 在 V8 引擎中设置原型（prototypes）

原型（比如 `func.prototype` ）是用来模拟类的实现。它们通常包含类的所有方法，它们的 `__proto__` 就是“父类（superclass）”，它们设置好后就不会修改了。

原型在设置时的性能表现对于应用程序的启动时间至关重要，因为此时通常要建立起整个类的层次结构。


### 转换对象形态（Transitioning object shapes）

对象被编码的主要方式是将**隐藏类（描述）**和**对象（内容）**分隔开。当一个对象被实例化，和之前来自同一个构造函数的对象使用相同的**初始化隐藏类**。当属性被添加，对象从一个隐藏类切换到另一个隐藏类，通常是在所谓的“转换树（transition tree）”中重复之前的转换。举个例子，比如我们有以下的构造函数：

```
function C() {
  this.a = 1;
  this.b = 2;
}
```
如果我们实例化一个对象 `var o = new C()`，它首先会使用一个没有任何属性的初始化隐藏类 M0。当 `a` 被添加，我们将从 M0 切换到一个新的隐藏类 M1，M1 描述属性 `a`。接着添加 `b` 的时候，我们再切换到另一个新的隐藏类来描述 `a` 和 `b`。

如果我们现在实例化第二个对象 `var o2 = new C()`，它将重复上面的转换。从 M0 开始，接着 M1，最后是 M2。`a` 和 `b` 被添加完成。

这样做有三个重要的好处：

1.  尽管创建第一个对象的开销是很大的，并且要求我们创建所有隐藏的类和转换，但是创建后续对象是非常快的。
2.  结果对象比完整的字典要小。我们只需要在对象中存储值，而不需要存储关于属性的信息（比如名称）。
3.  我们现在在内联缓存（inline cache）和优化代码时有一个对象形态可以使用，以后访问类似形态的对象就可以在同一位置找，方便快捷。

这样有利于频繁创建相似形态的对象。同样的事情也发生在对象字面量中：`{a:1, b:2}` 内部也会有隐藏类 M0，M1 和 M2。

网上有很多相关知识讲解，大家可以去看看 Lars Bak 的视频：

YouTube 视频见：[V8: an open source JavaScript engine](https://youtu.be/hWhMKalEicY)

### 原型（Prototypes）就像特别的雪花

不同于常规构造函数实例化对象，原型是典型的不与其他对象分享形态的对象。这会带来三点变化：

1.  通常来讲，没有对象能从缓存的转换（cached transitions）中受益，而且设置转换树（transition tree）的开销也是没有必要的。
2.  创建所有转换隐藏类的内存开销是很大的。事实上，在改变这个之前，我们通常会看到为了一个简单的原型就要用上一大堆的隐藏类。
3.  从一个原型中加载实际上并不像在原型链中使用那么常见。如果我们通过原型链从一个原型对象中加载，我们将不会分发原型的隐藏类，以及需要用不同的方法检查它是否有效。

为了优化原型，V8 对其形态的跟踪不同于常规的转换对象，我们不需要跟踪转换树（transition tree），而是将隐藏类调整为原型对象，让它保持高性能。举个例子，比如执行 `delete object.property` 会拖慢对象的性能，但如果是原型就不会出现这种情况。因为我们总是会保持它们的可缓存性（有些问题我们还在解决中）。

我们也改变了原型的设置。原型包含了2个重要的阶段：**设置**和**使用**。原型在**设置**阶段被编译成字典对象（dictionary objects）。在那个状态下存储原型的速度非常快的，而且不需要进入 C++ 的运行时（跨边界的花销是非常巨大的）。与创建一个转换隐藏类来初始化对象相比，这是一个巨大的进步，因为前者必须进入C++ 运行时才行。

任何对原型的直接访问，或者通过原型链访问原型，都会将它切换成**使用**状态，这样确保了所有访问从此时开始是快速的。当处于使用状态，即使你删除属性，在删除之后我们也会快速的切换回来。

```
function Foo() {}
// 现在 proto 对象是"设置"模式。
var proto = Foo.prototype;
proto.method1 = function() { ... }
proto.method2 = function() { ... }

var o = new Foo();
// 切换 proto 到"使用"模式。
o.method1();

// 也会切换 proto 到"使用"模式。
proto.method1.call(o);
```

### 它是原型吗？

为了用上上面说的优化方法，我们需要知道一个对象是否真的会被作为原型使用。由于 JavaScript 的特性，我们很难在编译阶段分析你的代码。出于这个原因，我们甚至没有尝试在对象创建过程中确定什么东西最终会成为原型（当然，以后可能会发生变化）。一旦我们看到一个对象赋值给一个原型，我们将对它进行标记。举个例子来讲：

```
var o = {x:1};
func.prototype = o;
```

一开始我们也不知道 `o` 用作原型，直到赋值给 `func.prototype`。我像往常那样花费巨大的开销来创建对象。一旦像它那样被赋值，它就被标记成原型，进入**设置**阶段。当你使用它，就会进入**使用**阶段。

如果你像下面这样写，我们会在属性添加前就知道 `o` 是一个原型。于是它将在添加属性前进入设置阶段，后面的代码执行就会快得多：

```
var o = {};
func.prototype = o;
o.x = 1;
```

注意你也可以这样使用 `var o = func.prototype`，因为很显然 `func.prototype` 在创建时就知道它是一个原型。

### 怎样设置原型（prototypes）？

如果你用下面的方式设置原型，我们在方法添加之前很容易就知道 func.prototype 就是一个原型：

```
// 如果默认的 Object.prototype 为 __proto__，则省略下面这行代码。
func.prototype = Object.create(…);
func.prototype.method1 = …
func.prototype.method2 = …
```

虽然已经很不错了，但事实上我们不得不为每个方法都加载一次 `func.prototype`。尽管最近我们正在进一步优化 `func.prototype` 的加载，但这种加载是不必要的，性能和内存的使用将比直接访问本地变量访问更糟糕。

简而言之，理想的原型设置方法如下：

```
var proto = func.prototype = Object.create(…);
proto.method1 = …
proto.method2 = …
```

感谢 [Benedikt Meurer](https://medium.com/@bmeurer?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
