
> * 原文地址：[Fast Properties in V8](https://v8project.blogspot.jp/2017/08/fast-properties.html)
> * 原文作者：[Camillo Bruni](https://plus.google.com/115597567207091386344)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/fast-properties-in-v8.md](https://github.com/xitu/gold-miner/blob/master/TODO/fast-properties-in-v8.md)
> * 译者：[Cherry](https://github.com/sunshine940326)
> * 校对者：[dearpork](https://github.com/dearpork)、[薛定谔的猫](https://github.com/Aladdin-ADD)

# V8 引擎怎样对属性进行快速访问

在这篇文章中我将要解释 V8 引擎内部是如何处理 JavaScript 属性的。从 JavaScript 的角度来看，属性们区别并不大，JavaScript 对象表现形式更像是字典，字符串作为键，任意对象作为值。[ECMAScript 语言规范](https://tc39.github.io/ecma262/#sec-ordinaryownpropertykeys) 中，对象的数字索引和其他类型索引在规范中没有明确区分，但是在 V8 引擎内部却不是这样的。除此之外，不同属性的行为基本相同，和他们可不可以进行整数索引没有关系。

然而在 V8 引擎中属性的不同表现形式确实会对性能和内存有影响，在这篇文章中我们来解析 V8 引擎是如何能够在动态添加属性时进行快速的属性访问的，理解属性是如何工作的，以解释 V8 引擎是如何的优化，（例如 [内联缓存](http://mrale.ph/blog/2012/06/03/explaining-js-vms-in-js-inline-caches.html) ）。

这篇文章解释了处理整数索引属性和命名属性的不同之处，之后我们展示了 V8 中是如何为了提供一个快速的方式定义一个对象的模型在添加一个命名属性时使用 HiddenClasses。然后，我们将继续深入了解如何根据使用情况进行属性名的命名优化，以便能够快速访问或者快速修改。在最后一节中，我们介绍 V8 如何处理整数索引属性或数组索引的详细信息。                                    

## 命名属性和元素

让我们从分析一个非常简单的对象开始，比如：`{a: "foo", b: "bar"}`。这个对象有两个命名属性，`"a" 和 "b"`。它没有使用任何的整数索引作为属性名。我们也可以使用索引访问属性，特别是对象为数组的情况。例如，数组 `["foo", "bar"]` 有两个可以使用数组索引的属性：索引为 0 的值是 `"foo"`，索引为 1 的值是 `"bar"`。

这是 V8 一般处理属性的第一个主要区别。

下图显示了一个 JavaScript 的基本对象在内存中的样子。
![](https://2.bp.blogspot.com/-85h60IlpPP0/WaZyqIVb4BI/AAAAAAAABVo/07d2HYCaz8ojd3e6w2mmtls3jYPlzc7SwCEwYBhgL/s640/V8%2BBlog%2BPost%2BProperties%2B%25281%2529V8%2BBlog%2BPost%2BProperties%2B%25281%2529-opt.png)

元素和属性存储在两个独立的数据结构中，这使得使用不同的模式添加和访问属性和元素将会更加高效。

元素主要用于各种 [Array.prototype methods](https://tc39.github.io/ecma262/#sec-properties-of-the-array-prototype-object) 例如 `pop` 或 `slice`。考虑到这些函数是在连续范围存储区域内访问属性的，V8 引擎内部大部分情况下也将他们表示为简单的数组。稍后我们将解释如何使用一个稀疏的基于字典的表示来节省内存。

命名属性的存储类似于稀疏数组的存储。然而，与元素不同，我们不能简单的使用键推断其在属性数组中的位置，我们需要一些额外的元数据。在 V8 中，每一个 JavaScript 对象都有一个相关联的 `HiddenClass`。这个 `HiddenClass` 存储了一个对象的模型信息，在其他方面，有一个从属性名到属性索引映射。我们有时使用一个字典来代替简单的数组。我们专门会在一个章节中更详细地解释这一点。

**本节重点:**

- 数组索引属性存储在单独的元素存储区中。
- 命名属性存储在属性存储区中。
- 元素和属性可以是数组或字典。
- 每个 JavaScript 对象有一个和对象的模型相关联的 `HiddenClass` 。

## HiddenClasses 和描述符数组

在介绍了元素和命名属性的大致区别之后，我们需要来看一下 HiddenClasses 在 V8 中是怎么工作的。HiddenClass 存储了一个对象的元数据，包括对象和对象引用原型的数量。HiddenClasses 在典型的面向对象的编程语言的概念中和“类”类似。然而，在像 JavaScript 这样的基于原型的编程语言中，一般不可能预先知道类。因此，在这种情况下，在 V8 引擎中，HiddenClasses 创建和更新属性的动态变化。HiddenClasses 作为一个对象模型的标识，并且是 V8 引擎优化编译器和内联缓存的一个非常重要的因素。通过 HiddenClass 可以保持一个兼容的对象结构，这样的话实例可以直接使用内联的属性。

让我们来看一下 HiddenClass 的重点

![](https://3.bp.blogspot.com/-DOwcud2emlM/WaZyqD5ijnI/AAAAAAAABVo/qM1VSAAvGb8UdkSDR7voqnsl7PPyP83nwCEwYBhgL/s640/V8%2BBlog%2BPost%2BProperties%2B%25283%2529V8%2BBlog%2BPost%2BProperties%2B%25283%2529-opt.png)

在 V8 中，JavaScript 对象的第一部分就是指向 HiddenClass。（实际上，V8 中的任何对象都在堆中并且受垃圾回收器管理。）在属性方面，最重要的信息是第三段区域，它存储属性的数量，以及一个指向描述符数组的指针。描述符数组包含有关命名属性的信息，如名称本身和存储值的位置。注意，我们不在这里跟踪整数索引属性，因此描述符数组中没有整数索引的条目。

关于 HiddenClasses 的基本假设是对象具有相同的结构，例如，相同的顺序对应相同的属性，共用相同的 HiddenClass。当我们给一个对象添加一个属性的时候我们使用不同的 HiddenClass 实现。在下面的例子中，我们从一个空对象开始并且添加三个命名属性。

![](https://2.bp.blogspot.com/-QryvU5yH54E/WaZypyDcL5I/AAAAAAAABVo/7A7nQTGpHnYh3nj2Z1ycEzKJMzMaASQ0ACEwYBhgL/s640/V8%2BBlog%2BPost%2BProperties%2B%25282%2529V8%2BBlog%2BPost%2BProperties%2B%25282%2529-opt.png)

每次加入一个新属性时，对象的 HiddenClass 就会改变，在 V8 引擎的后台会创建一个将 HiddenClass 连接在一起的转移树。V8 引擎就知道你添加的 HiddenClass 是哪一个了，例如，属性 “a” 添加到一个空对象中，如果你以相同的顺序添加相同的属性，这个转化树会使用相同的 HiddenClass。下面的示例表明，即使在两者之间添加简单的索引属性，我们也将遵循相同的转换树。

![](https://1.bp.blogspot.com/-T2N4cAFYhH4/WaZz-dXh50I/AAAAAAAABV0/7TuUAyt5zUoTnLK-ESMHpY4YS44_lwAPwCEwYBhgL/s640/8.opt.png)

**本节重点：**

- 结构相同的对象（相同的顺序对于相同的属性）有相同的 HiddenClasses。
- 默认情况下，每添加一个新的命名属性将产生了一个新的 HiddenClasses。
- 增加数组索引属性并不创造新 HiddenClasses。

## 三种不同的命名属性

在概述了 V8 引擎是如何使用 HiddenClasses 来追踪对象的模型之后，我们来看一下这些属性实际上是如何储存的。正如上面介绍所介绍的，有两种基本属性：命名属性和索引属性。以下部分是命名属性:

一个简单的对象，例如 `{a: 1, b: 2}` 在 V8 引擎的内部有多种表现形式，虽然 JavaScript 对象或多或少的和外部的字典相似，V8 引擎仍然试图避免和字典类似因为他们妨碍某些优化，例如 [内联缓存](https://en.wikipedia.org/wiki/Inline_caching)，我们将在一篇单独的文章中解释。

**In-object 属性和一般属性：** V8 引擎支持直接储存在所谓的 In-object 的属性。这些是 V8 引擎中可用的最快速的属性，因为他们可以直接访问。In-object 属性的数量是由对象的初始大小决定的。如果在对象中添加超出存储空间的属性，那么他们会储存在属性存储区中。属性存储多了一层间接寻址但这是独立的区域。

![](https://4.bp.blogspot.com/-d2tpi7Ag4Xc/WaZyrJLvHoI/AAAAAAAABVo/ckwdEeuj0asJWRwVcNfLNX8b_9V5uOdvACEwYBhgL/s640/V8%2BBlog%2BPost%2BProperties%2B%25285%2529V8%2BBlog%2BPost%2BProperties%2B%25285%2529-opt.png)

**快属性 VS 慢属性：** 下一个重要的区别来自于快属性和慢属性。通常，我们将存储在线性属性存储区域的属性称为快属性。快属性仅通过属性存储区的索引访问，为了在属性存储区的实际位置得到属性的名字，我们必须通过在 HiddenClass 中的描述符数组。  

![](https://1.bp.blogspot.com/-5koeeNOIEAA/WaZ1GIxOgcI/AAAAAAAABWE/pVHJMYKV2oAdLVnOH7mJS4CcOnsGr5GngCEwYBhgL/s640/10-opt.png)

然而，从一个对象中添加或删除多个属性，会为了保持描述符数组和 HiddenClasses 而产生大量的时间和内存的开销。因此，V8 引擎也支持所谓的慢属性，一个有慢属性的对象有一个自包含的字典作为属性存储区。所有的属性元数据都不再存储在 HiddenClass 的描述符数组而是直接在属性字典。因此，属性可以添加和删除不更新的 HiddenClass。由于内联缓存不使用字典属性，后者通常比快速属性慢。

**本节重点：**

1. 有三种不同的命名属性类型：对象、快字典和慢字典。

- 在对象属性中直接存储在对象本身上，并提供最快的访问速度。
- 快属性存储在属性存储区，所有的元数据存储在 HiddenClass 的描述符数组中。
- 慢属性存储在自身的属性字典中，元数据不再存储于 HiddenClass。

2. 慢属性允许高效的属性删除和添加，但访问速度比其他两种类型慢。

## 元素或数组索引属性

到目前为止，我们已经了解了命名属性，在研究的过程中忽略数组中常用的整数索引属性。处理整数索引属性并不比命名属性简单。虽然所有的索引属性总是单独存放在元素存储中，但是有 20 种不同类型的元素！

**元素是连续的的还是有缺省的：** V8 引擎的第一个主要区别是元素在存储区是连续的还是有缺省的。如果删除索引元素，或者在不定义索引元素的情况下，就会在存储区中有一个缺省。一个简单的例子是 `[1,,3]`，第二个位置缺省。下面的例子说明了这个问题：

```
const o = ["a", "b", "c"];
console.log(o[1]);          // 打印 "b".

delete o[1];                // 删除一个属性.
console.log(o[1]);          // 打印 "undefined"; 第二个属性不存在
o.__proto__ = {1: "B"};     // 在原型上定义第二个属性

console.log(o[0]);          // 打印 "a".
console.log(o[1]);          // 打印 "B".
console.log(o[2]);          // 打印
console.log(o[3]);          // 打印 undefined
```

![](https://4.bp.blogspot.com/-IYamXWTAJWc/WaZ0hiBb5VI/AAAAAAAABV8/9BRrrSGMsxkJkjtH2bEqw2qg_UszfNBBACEwYBhgL/s400/9-opt.png)

简言之，如果接收器上不存在属性，我们必须继续在原型链上查找。如果元素是自包含的，我们不在 HiddenClass 中存储有关当前索引的属性，我们需要一个特殊的值，称为 `the_hole`，来标记该位置的属性是不存在的。这个数组函数的性能是至关重要的。如果我们知道有没有缺省，即元素是连续的，我们可以不用昂贵代价来查询原型链来进行本地操作。

**快速元素和字典元素:** 元素的第二个主要区别是它们是快速的还是字典模式的。快速元素是简单的 VM 内部数组，其中属性索引映射到元素存储区中的索引。然而，这种简单的表示在稀疏数组中是相当浪费的。在这种情况下，我们使用基于字典的表示来节省内存，以访问速度稍微慢一些为代价：
```
const sparseArray = [];
sparseArray[1 << 20] = "foo"; // 使用字典元素创建一个数组。
```

在这个例子中，如果分配一个 10K 的全排列会更浪费。所以取而代之的是 V8 创建的一个字典，我们在其中存储三个一模一样的键值描述符。本例中的键为 10000，值为“字符串”还有一个默认描述符。因为我们没有办法在 HiddenClass 存储区描述细节，在 V8 中 当你定义一个索引属性与自定义描述符存储在慢元素中：

```
const array = [];
Object.defineProperty(array, 0, {value: "fixed", configurable});
console.log(array[0]);      // 打印 "fixed".
array[0] = "other value";   // 不能重新第 1 个索引.
console.log(array[0]);      // 仍然打印 "fixed".
```

在这个例子中，我们在数组上添加了一个 `configurable` 为 `false` 的属性。此信息存储在慢元素字典三元组的描述符部分中。需要注意的是，在慢元素对象上，数组函数的执行速度要慢得多。

**小整数和双精度元素：** 对于快速元素，V8中还有另一个重要的区别。例如，如果你只保存整数数组，一个常见的例子：GC 没有接受数组，因为整数直接编码为所谓的小整数（SMIS）。另一个特例是数组，它们只包含双精度数。不像SMIS，浮点数通常表示为对象占用的几个字符。然而，V8 使用两行来存储纯双精度组，以避免内存和性能开销。下面的示例列出了 SMI 和双精度元素的 4 个示例：

```
const a1 = [1,   2, 3];  // Smi Packed
const a2 = [1,    , 3];  // Smi Holey, a2[1] reads from the prototype
const b1 = [1.1, 2, 3];  // Double Packed
const b2 = [1.1,  , 3];  // Double Holey, b2[1] reads from the prototype
```

**特别的元素:** 到目前为止，我们涵盖了 20 种不同元素中的 7 种。为简单起见，我们排除了 9 元种 数组类型，两个字符串包装等等，两个参数对象。

**ElementsAccessor:** 你可以想象我们并不想为了每一种元素在 C++ 中写 20 次数组函数。这就是 C++ 的奇妙之处。为了代替一次又一次数组函数的实现，我们在从后备存储访问元素建立了 ElementsAccessor 。ElementsAccessor 依赖 CRTP 创建每一个数组函数的专业版。所以，如果你调用数组中的一些方法例如 slice，将通过调用 V8 引擎的内部调用内置 C++ 编写的，ElementsAccessor 的专业版：

![](https://3.bp.blogspot.com/-VZ1f0pKwu9g/WaZyrpJ-2qI/AAAAAAAABVo/UZp0rgWPM_QorIHTDBHJCvYUVhnND8DlQCEwYBhgL/s640/V8%2BBlog%2BPost%2BProperties%2B%25287%2529V8%2BBlog%2BPost%2BProperties%2B%25287%2529-opt.png)

**本节重点：**

- 有快速模式和字典模式索引属性和元素。
- 快速属性可以被打包并且他们可以包含被删除索引属性缺省的标志。
- 数组元素类型固定，以加速数组函数并减少 GC 开销，方便引擎优化。

了解属性如何工作是在 V8 中许多优化的关键。对于 JavaScript 开发人员来说，这些内部决策中有很多是不可见的，但它们解释了为什么某些代码模式比其他代码模式更快。更改属性或元素类型通常让 V8 创造不同的 HiddenClass，[阻碍 V8 优化的原因](http://mrale.ph/blog/2015/01/11/whats-up-with-monomorphism.html)。敬请期待我以后的文章：V8 引擎 VM 内部是如何工作的。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
