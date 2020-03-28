> * 原文地址：[Master the JavaScript Interview: What is a Pure Function?](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/master-the-javascript-interview-what-is-a-pure-function.md](https://github.com/xitu/gold-miner/blob/master/TODO1/master-the-javascript-interview-what-is-a-pure-function.md)
> * 译者：[niayyy-S](https://github.com/niayyy-S)
> * 校对者：[chaingangway](https://github.com/chaingangway)、[IAMSHENSH](https://github.com/IAMSHENSH)

# 掌握 JavaScript 面试：什么是纯函数？

![Image: Pure — carnagenyc (CC-BY-NC 2.0)](https://cdn-images-1.medium.com/max/2048/1*gF8oCkYNvktBbAAG-nxYrg.jpeg)

纯函数对于实现各种目的是必不可少的，包括函数式编程，可靠地并发和 React + Redux 构造的应用程序。但是纯函数是什么意思？

我们将通过来自 [《跟 Eric Elliott 学习 JavaScript》](http://ericelliottjs.com/product/lifetime-access-pass/) 的免费课程来回答的这个问题：

在我们解决什么是纯函数这个问题之前，仔细研究一下什么是函数可能更好。也许存在一种不一样的看待函数的方式，会让函数式编程更易于理解。

#### 什么是函数？

**函数**是一个过程：它需要一些叫做**参数**的输入，然后产生一些叫做**返回值**的输出。函数可以用于以下目的：

* **映射：**基于输入值产生一些的输出。函数把输入值**映射到**输出值。
* **过程化：**可以调用一个函数去执行一系列步骤。该一系列步骤称为过程，而这种方式的编程称为**面向过程编程**。
* **I/O：**一些函数存在与系统其他部分进行通信，例如屏幕，存储，系统日志或网络。

#### 映射

纯函数都是关于映射的。函数将输入参数映射到返回值，这意味着对于每组输入，都存在对应的输出。函数将获取输入并返回相应的输出。

**`Math.max()`** 以一组数字作为参数并返回最大数字：

```js
Math.max(2, 8, 5); // 8
```

在此示例中，2，8 和 5 是**参数**。它们是传递给函数的值。

**`Math.max()`** 是一个可以接受任意数量的参数并返回最大参数值的函数。在这个案例中，我们传入的最大数是 8，对应了返回的数字。

函数在计算和数学中非常重要。它们帮助我们用合适的方式处理数据。好的程序员会给函数起描述性的名称，以便当我们查看代码时，我们可以通过函数名了解函数的作用。

数学也有函数，它们的工作方式与 JavaScript 中的函数非常相似。您可能见过代数函数。他们看起来像这样：

**f**(**x**) = 2**x**

这意味着我们要声明了一个名为 f 的函数，它接受一个叫 x 的参数并将 x 乘以 2。

要使用这个函数，我们只需为 x 提供一个值：

**f**(2)

在代数中，这意味着与下面的写法完全相同：

4

因此，在任何看到 **f**(2) 的地方都可以替换 4。

现在让我们用 JavaScript 来描述这个函数：

```js
const double = x => x * 2;
```

你可以使用 **`console.log()`** 检查函数输出：

```js
console.log( double(5) ); // 10
```

还记得我说过的在数学函数中，你可以替换 **`f(2)`** 为 **`4`** 吗？在这种情况下，JavaScript 引擎用 **`10`** 替换 **`double(5)`**。

因此， **`console.log( double(5) );`** 与 **`console.log(10);`** 相同

这是真实存在的，因为 **`double()`** 是一个纯函数，但是如果 **`double()`** 有副作用，例如将值保存到磁盘或打印到控制台，用 10 替换 **`double(5)`** 会改变函数的含义。

如果想要引用透明，则需要使用纯函数。

#### 纯函数

**纯函数**是一个函数，其中：

* 给定相同的输入，将始终返回相同的输出。
* 无副作用。

> 如果你合理调用一个函数，而没有使用它的返回值，则毫无疑问不是纯函数。对于纯函数来说，相当于未进行调用。

我建议你偏向于使用纯函数。意思是，如果使用纯函数实现程序需求是可行的，应该优先选择使用。纯函数接受一些输入，并根据输入返回一些输出。它们是程序中最简单的可重用代码块。也许计算机科学中最重要的设计原理是 KISS（保持简单明了）。我更喜欢保持傻瓜式的简单。纯函数是傻瓜式简单的最佳方式。

纯函数具有许多有益的特性，并构成了**函数式编程**的基础。纯函数完全独立于外部状态，因此，它们不受所有与共享可变状态有关问题的影响。它们的独立特性也使其成为跨多个 CPU 以及整个分布式计算集群进行并行处理的极佳选择，这使其对许多类型的科学和资源密集型计算任务至关重要。

纯函数也是非常独立的 —— 在代码中可以轻松移动，重构以及重组，使程序更灵活并能够适应将来的更改。

#### 共享状态问题

几年前，我正在开发一个应用程序，该程序允许用户搜索音乐艺术家的数据库并将该艺术家的音乐播放列表加载到 web 播放器中。大约在 Google Instant 上线的那个时候，当输入搜索查询时，它会显示即时搜索结果。AJAX 驱动的自动完成功能风靡一时。

唯一的问题是，用户输入的速度通常快于 API 的自动完成搜索并返回响应的速度，从而导致一些奇怪的错误。这将触发竞争条件（race condition），在此情况下，较新的结果可能会被过期的所取代。

为什么会这样呢？因为每个 AJAX 成功处理程序都有权直接更新显示给用户的建议列表。最慢的 AJAX 请求总是可以通过盲目替换获得用户的注意，即使这些替换的结果可能是较新的。

为了解决这个问题，我创建了一个建议管理器 —— 一个单一数据源去管理查询建议的状态。它知道当前有一个待处理的 AJAX 请求，并且当用户输入新内容时，这个待处理的 AJAX 请求将在发出新请求之前被取消，因此一次只有一个响应处理程序将能够触发 UI 状态更新。

任何种类的异步操作或并发都可能导致类似的竞争条件。如果输出取决于不可控事件的顺序（例如网络，设备延迟，用户输入，随机性等），则会发生竞争条件。实际上，如果你正在使用共享状态，并且该状态依赖于一系列不确定性因素，总而言之，输出都是无法预测的，这意味着无法正确测试或完全理解。正如 Martin Odersky（Scala 语言的创建者）所说：

> **不确定性 = 并行处理 + 可变状态**

程序的确定性通常是计算中的理想属性。可能你认为还好，因为 JS 在单线程中运行，因此不受并行处理问题的影响，但是正如 AJAX 示例所示，单线程JS引擎并不意味着没有并发。相反，JavaScript 中有许多并发来源。API I/O，事件侦听，Web Worker，iframe 和超时都可以将不确定性引入程序中。将其与共享状态结合起来，就可以得出解决 bug 的方法。

纯函数可以帮助你避免这些 bug。

#### 给定相同的输入，始终返回相同的输出

使用上面的 **`double()`** 函数，你可以用结果替换函数调用，程序仍然具有相同的含义 —— **`double(5)`** 始终与程序中的 **`10`** 具有相同含义，而不管上下文如何，无论调用它多少次或何时调用。

但是你不能对所有函数都这么认为。某些函数依赖于你传入的参数以外的信息来产生结果。

考虑以下示例：

```js
Math.random(); // => 0.4011148700956255
Math.random(); // => 0.8533405303023756
Math.random(); // => 0.3550692005082965
```

尽管我们没有传递任何参数到任何函数调用的，他们都产生了不同的输出，这意味着 **`Math.random()`** 是**不是纯函数**。

**`Math.random()`** 每次运行时，都会产生一个介于 0 和 1 之间的新随机数，因此很明显，你不能只用 0.4011148700956255 替换它而不改变程序的含义。

那将每次都会产生相同的结果。当我们要求计算机产生一个随机数时，通常意味着我们想要一个与上次不同的结果。每一面都印着相同数字的一对骰子有什么意义呢？

有时我们必须询问计算机当前时间。我们不会详细地了解时间函数的工作原理。只需复制以下代码：

```js
const time = () => new Date().toLocaleTimeString();

time(); // => "5:15:45 PM"
```

如果用当前时间取代 **`time()`** 函数的调用会发生什么？

它总是输出相同的时间：这个函数调用被替换的时间。换句话说，它只能每天产生一次正确的输出，并且仅当你在替换函数的确切时刻运行程序时才可以。

很明显，**`time()`** 不像 **`double()`** 函数。

**如果函数在给定相同的输入的情况下始终产生相同的输出，则该函数是纯函数**。你可能还记得代数课上的这个规则：相同的输入值将始终映射到相同的输出值。但是，许多输入值可能会映射到相同的输出值。例如，以下函数是**纯函数**：

```js
const highpass = (cutoff, value) => value >= cutoff;
```

相同的输入值将始终映射到相同的输出值：

```js
highpass(5, 5); // => true
highpass(5, 5); // => true
highpass(5, 5); // => true
```

许多输入值可能映射到相同的输出值：

```js
highpass(5, 123); // true
highpass(5, 6);   // true
highpass(5, 18);  // true

highpass(5, 1);   // false
highpass(5, 3);   // false
highpass(5, 4);   // false
```

纯函数一定不能依赖任何外部可变状态，因为它不再是确定性的或引用透明的。

## 纯函数不会产生副作用

纯函数不会产生任何副作用，意味着它无法更改任何外部状态。

## 不变性

JavaScript 的对象参数是引用的，这意味着如果函数更改对象或数组参数上的属性，则将使该函数外部可访问的状态发生变化。纯函数不得改变外部状态。

考虑一下这种改变的，**不纯的** **`addToCart()`** 函数：

```JavaScript
// 不纯的 addToCart 函数改变了现有的 cart 对象
const addToCart = (cart, item, quantity) => {
  cart.items.push({
    item,
    quantity
  });
  return cart;
};


test('addToCart()', assert => {
  const msg = 'addToCart() should add a new item to the cart.';
  const originalCart =     {
    items: []
  };
  const cart = addToCart(
    originalCart,
    {
      name: "Digital SLR Camera",
      price: '1495'
    },
    1
  );

  const expected = 1; // cart 中的商品数
  const actual = cart.items.length;

  assert.equal(actual, expected, msg);

  assert.deepEqual(originalCart, cart, 'mutates original cart.');
  assert.end();
});

```

这个函数通过传递 cart 对象，添加商品和商品数量到 cart 对象上来调用的。然后，该函数返回相同的 cart 对象，并添加了商品。

这样做的问题是，我们刚刚改变了一些共享状态。其他函数可能依赖于 cart 对象状态 —— 被该函数调用之前的状态，而现在我们已经更改了这个共享状态，如果我们改变函数调用的顺序，我们不得不担心将会对程序逻辑上产生怎样的影响。重构代码可能会导致 bug 出现，从而可能破坏订单并导致客户不满意。

现在考虑这个版本：

```JavaScript
// 纯 addToCart() 函数返回一个新的 cart 对象
// 这不会改变原始对象
const addToCart = (cart, item, quantity) => {
  const newCart = lodash.cloneDeep(cart);

  newCart.items.push({
    item,
    quantity
  });
  return newCart;

};


test('addToCart()', assert => {
  const msg = 'addToCart() should add a new item to the cart.';
  const originalCart = {
    items: []
  };

  // npm 上的 deep-freeze
  // 如果原始对象被改变，则抛出一个错误
  deepFreeze(originalCart);

  const cart = addToCart(
    originalCart,
    {
      name: "Digital SLR Camera",
      price: '1495'
    },
    1
  );


  const expected = 1;  // cart 中的商品数
  const actual = cart.items.length;

  assert.equal(actual, expected, msg);

  assert.notDeepEqual(originalCart, cart,
    'should not mutate original cart.');
  assert.end();
});

```

在此示例中，我们在对象中嵌套了一个数组，这是我要进行深克隆的原因。这比你通常要处理的状态更为复杂。对于大多数事情，你可以将其分解为较小的块。

例如，Redux 让你可以组成 reducers，而不是在每个 reducers 中的解决整个应用程序状态。结果是，你不必每次更新整个应用程序状态的一小部分时就创建一个深克隆。相反，你可以使用非破坏性数组方法，或 **`Object.assign()`** 更新应用状态的一小部分。

轮到你了。[Fork 这个 codepen 代码](http://codepen.io/ericelliott/pen/MyojLq?editors=0010)，并将非纯函数转换为纯函数。使单元测试通过而不更改测试。

#### 探索这个系列

* [什么是闭包？](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-closure-b2f0d2152b36#.ecfskj935)
* [类和原型继承有什么区别？](https://medium.com/javascript-scene/master-the-javascript-interview-what-s-the-difference-between-class-prototypal-inheritance-e4cd0a7562e9#.h96dymht1)
* [什么是纯函数？](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976#.4256pjcfq)
* [函数由什么构成？](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-function-composition-20dfb109a1a0#.i84zm53fb)
* [什么是函数式编程？](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-functional-programming-7f218c68b3a0#.jddz30xy3)
* [什么是 Promise ？](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-promise-27fc71e77261#.aa7ubggsy)
* [软技能](https://medium.com/javascript-scene/master-the-javascript-interview-soft-skills-a8a5fb02c466)

> 该帖子已包含在《Composing Software》书中。**[ 买这本书](https://leanpub.com/composingsoftware) | [索引](https://medium.com/javascript-scene/composing-software-the-book-f31c77fc3ddc) | [<上一页](https://medium.com/javascript-scene/why-learn-functional-programming-in-javascript-composing-software-ea13afc7a257) | [下一页>](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-functional-programming-7f218c68b3a0)**

---

**埃里克·埃利奥特（Eric Elliott）** 是一名分布式系统专家，并且是[《Composing Software》](https://leanpub.com/composingsoftware)和[《Programming JavaScript Applications》](https://ericelliottjs.com/product/programming-javascript-applications-ebook/)这两本书的作者。作为 [DevAnywhere.io](https://devanywhere.io/) 的联合创始人，他教开发人员远程工作和实现工作 / 生活平衡所需的技能。他建立并为加密项目的开发团队提供咨询，并为 **Adobe 公司、Zumba Fitness、《华尔街日报》、ESPN、BBC** 和包括 **Usher、Frank Ocean、Metallica** 在内的顶级唱片艺术家的软件体验做出了贡献。

**他与世界上最美丽的女人一起享受着远程办公的生活方式。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
