> * 原文地址：[Is postMessage slow?](https://dassur.ma/things/is-postmessage-slow/)
> * 原文作者：[Surma](https://dassur.ma)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/is-postmessage-slow.md](https://github.com/xitu/gold-miner/blob/master/TODO1/is-postmessage-slow.md)
> * 译者：[linxiaowu66](https://github.com/linxiaowu66)
> * 校对者：[MarchYuanx](https://github.com/MarchYuanx), [TiaossuP](https://github.com/TiaossuP)

# postMessage 很慢吗？

不，不一定（视情况而定）

这里的“慢”是什么意思呢？[我之前在这里提及过](https://dassur.ma/things/less-snakeoil/)，在这里再说一遍：如果你不度量它，它并不慢，即使你度量它，但是没有上下文，数字也是没有意义的。

话虽如此，人们甚至不会考虑采用 [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Worker)，因为他们担心 `postMessage()` 的性能，这意味着这是值得研究的。[我的上一篇博客文章](https://dassur.ma/things/when-workers/)也得到了类似的[回复](https://twitter.com/dfabu/status/1139567716052930561)。让我们将实际的数字放在 `postMessage()` 的性能上，看看你会在什么时候冒着超出承受能力的风险。如果连普通的 `postMessage()` 在你的使用场景下都太慢，那么你还可以做什么呢?

准备好了吗？继续往下阅读吧。

## postMessage 是怎么工作的？

在开始度量之前，我们需要了解**什么是** `postMessage()`，以及我们想度量它的哪一部分。否则，[我们最终将收集无意义的数据](https://dassur.ma/things/deep-copy/)并得出无意义的结论。

`postMessage()` 是 [HTML规范](https://html.spec.whatwg.org/multipage/) 的一部分（而不是 [ECMA-262](http://www.ecma-international.org/ecma-262/10.0/index.html#Title)！）正如我在 [deep-copy 一文](https://dassur.ma/things/deep-copy/)中提到的，`postMessage()` 依赖于结构化克隆数据，将消息从一个 JavaScript 空间复制到另一个 JavaScript 空间。仔细研究一下 [`postMessage()` 的规范](https://html.spec.whatwg.org/multipage/webmessaging.html#message-port-post-message-steps)，就会发现结构化克隆是一个分两步的过程：

### 结构化克隆算法

1. 在消息上执行 `StructuredSerialize()`
2. 在接收方中任务队列中加入一个任务，该任务将执行以下步骤：
    1. 在序列化的消息上执行 `StructuredDeserialize()`
    2. 创建一个 `MessageEvent` 并派发一个带有该反序列化消息的 `MessageEvent` 事件到接收端口上

这是算法的一个简化版本，因此我们可以关注这篇博客文章中重要的部分。虽然这在**技术上**是不正确的，但它却抓住了精髓。例如，`StructuredSerialize()` 和 `StructuredDeserialize()` 在实际场景中并不是真正的函数，因为它们不是通过 JavaScript（[不过有一个 HTML 提案打算将它们暴露出去](https://github.com/whatwg/html/pull/3414)）暴露出去的。那这两个函数实际上是做什么的呢？现在，**你可以将 `StructuredSerialize()` 和 `StructuredDeserialize()` 视为 `JSON.stringify()` 和 `JSON.parse()` 的智能版本**。从处理循环数据结构、内置数据类型（如 `Map`、`Set`和`ArrayBuffer`）等方面来说，它们更聪明。但是，这些聪明是有代价的吗？我们稍后再讨论这个问题。

上面的算法没有明确说明的是，**序列化会阻塞发送方，而反序列化会阻塞接收方。** 另外还有：Chrome 和 Safari 都推迟了运行 `StructuredDeserialize()`，直到你实际访问了 `MessageEvent` 上的 `.data` 属性。另一方面，Firefox 在派发事件之前会反序列化。

> **注意：** 这两个行为**都是**兼容规范的，并且完全有效。[我在 Mozilla 上提了一个bug](https://bugzilla.mozilla.org/show_bug.cgi?id=1564880)，询问他们是否愿意调整他们的实现，因为这可以让开发人员去控制什么时候应该受到反序列化大负载的“性能冲击”。

考虑到这一点，我们必须选择对**什么**来进行基准测试：我们可以端到端进行度量，所以可以度量一个 worker 发送消息到主线程所花费的时间。然而，这个数字将捕获序列化和反序列化的时间总和，但是它们却分别发生在不同的空间下。记住：**与 worker 的整个通信的都是主动的，这是为了保持主线程自由和响应性。** 或者，我们可以将基准测试限制在 Chrome 和 Safari 上，并单独测量从 `StructuredDeserialize()` 到访问 `.data` 属性的时间，这个需要把 Firefox 排除在基准测试之外。我还没有找到一种方法来单独测量 `StructuredSerialize()`，除非运行的时候调试跟踪代码。这两种选择都不理想，但本着构建弹性 web 应用程序的精神，**我决定运行端到端基准测试，为 `postMessage()` 提供一个上限。**

有了对 `postMessage()` 的概念理解和评测的决心，我将使用 ☠️ 微基准 ☠️。请注意这些数字与现实之间的差距。

## 基准测试 1：发送一条消息需要花费多少时间？

![Two JSON objects showing depth and breadth](https://dassur.ma/things/is-postmessage-slow/breadth-depth.svg)

深度和宽度在 1 到 6 之间变化。对于每个置换，将生成 1000 个对象。

基准将生成具有特定“宽度”和“深度”的对象。宽度和深度的值介于 1 和 6 之间。**对于宽度和深度的每个组合，1000 个唯一的对象将从一个 worker `postMessage()` 到主线程**。这些对象的属性名都是随机的 16 位十六进制数字符串，这些值要么是一个随机布尔值，要么是一个随机浮点数，或者是一个来自 16 位十六进制数的随机字符串。**基准测试将测量传输时间并计算第 95 个百分位数。**

### 测量结果

![](https://dassur.ma/things/is-postmessage-slow/nokia2-chrome.svg)

![](https://dassur.ma/things/is-postmessage-slow/pixel3-chrome.svg)

![](https://dassur.ma/things/is-postmessage-slow/macbook-chrome.svg)

![](https://dassur.ma/things/is-postmessage-slow/macbook-firefox.svg)

![](https://dassur.ma/things/is-postmessage-slow/macbook-safari.svg)

这一基准测试是在 2018 款的 MacBook Pro上的 Firefox、 Safari、和 Chrome 上运行，在 Pixel 3XL 上的 Chrome 上运行，在 诺基亚 2 上的 Chrome 上运行。

> **注意：** 你可以在 [gist](https://gist.github.com/surma/08923b78c42fab88065461f9f507ee96) 中找到基准数据、生成基准数据的代码和可视化代码。而且，这是我人生中第一次编写 Python。别对我太苛刻。

Pixel 3 的基准测试数据，尤其是 Safari 的数据，对你来说可能有点可疑。当 [Spectre & Meltdown](https://zhuanlan.zhihu.com/p/32784852) 被发现的时候,所有的浏览器会禁用 [SharedArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer) 并将我要测量使用的 [performance.now()](https://developer.mozilla.org/en-US/docs/Web/API/Performance/now) 函数实行计时器的精度减少。只有 Chrome 能够还原这些更改，因为它们将[站点隔离](https://www.chromium.org/home/chromisecurity/site-isolation)发布到 Chrome 桌面版。更具体地说，这意味着浏览器将 `performance.now()` 的精度限制在以下值上:

* Chrome（桌面版）：5µs
* Chrome（安卓系统）：100µs
* Firefox（桌面版）：1ms（该限制可以禁用掉，我就是禁用掉的）
* Safari（桌面版）：1ms

数据显示，对象的复杂性是决定对象序列化和反序列化所需时间的重要因素。这并不奇怪：序列化和反序列化过程都必须以某种方式遍历整个对象。数据还表明，对象 JSON 化后的大小可以很好地预测传输该对象所需的时间。

## 基准测试 2：什么导致 postMessage 变慢了？

为了验证这个，我修改了基准测试：我生成了宽度和深度在 1 到 6 之间的所有排列，但除此之外，所有叶子属性都有一个长度在 16 字节到 2 KiB 之间的字符串值。

### 测试结果

![A graph showing the correlation between payload size and transfer time for postMessage](https://dassur.ma/things/is-postmessage-slow/correlation.svg)

传输时间与 `JSON.stringify()` 返回的字符串长度有很强的相关性。

我认为这种相关性足够强，可以给出一个经验法则：**对象的 JSON 字符串化后的大小大致与它的传输时间成正比。** 然而，更需要注意的事实是，**这种相关性只与大对象相关**，我说的大是指超过 100 KiB 的任何对象。虽然这种相关性在数学上是成立的，但在较小的有效载荷下，这种差异更为明显（译者注：怀疑这句话作者应该是写错了，应该表述为差异不明显）。

## 评估：发送一条信息

我们有数据，但如果我们不把它上下文化，它就没有意义。如果我们想得出**有意义的**结论，我们需要定义“慢”。预算在这里是一个有用的工具，我将再次回到 [RAIL](https://developer.google.com/web/fundamentals/performance/rail) 指南来确定我们的预期。

根据我的经验，一个 web worker 的核心职责至少是管理应用程序的状态对象。状态通常只在用户与你的应用程序交互时才会发生变化。根据 RAIL 的说法，我们有 100 ms 来响应用户交互，这意味着**即使在最慢的设备上，你也可以 `postMessage()` 高达 100 KiB 的对象，并保持在你的预期之内。**

当运行 JS 驱动的动画时，这种情况会发生变化。动画的 RAIL 预算是 16 ms，因为每一帧的视觉效果都需要更新。如果我们从 worker 那里发送一条消息，该消息会阻塞主线程的时间超过这个时间，那么我们就有麻烦了。从我们的基准数据来看，任何超过 10 KiB 的动画都不会对你的动画预算构成风险。也就是说，**这就是我们更喜欢用 CSS animation 和 transition 而不是 JS 驱动主线程绘制动画的一个重要原因。** CSS animation 和 transition 运行在一个单独的线程 - 合成线程 - 不受阻塞的主线程的影响。

## 必须发送更多的数据

以我的经验，对于大多数采用非主线程架构的应用程序来说，`postMessage()` 并不是瓶颈。不过，我承认，在某些设置中，你的消息可能非常大，或者需要以很高的频率发送大量消息。如果普通 `postMessage()` 对你来说太慢的话，你还可以做什么?

### 打补丁

在状态对象的情况下，对象本身可能非常大，但通常只有少数几个嵌套很深的属性会发生变化。我们在 [PROXX](https://proxx.app) 中遇到了这个问题，我们的 PWA 版本扫雷：游戏状态由游戏网格的二维数组组成。每个单元格存储这些字段：是否有雷，以及是被发现的还是被标记的。

```typescript
interface Cell {
  hasMine: boolean;
  flagged: boolean;
  revealed: boolean;
  touchingMines: number;
  touchingFlags: number;
}
```

这意味着最大的网格( 40 × 40 个单元格)加起来的 JSON 大小约等于 134 KiB。发送整个状态对象是不可能的。**我们选择记录更改并发送一个补丁集，而不是在更改时发送整个新的状态对象。** 虽然我们没有使用 [ImmerJS](https://github.com/immerjs/immer)，这是一个处理不可变对象的库，但它提供了一种快速生成和应用补丁集的方法：

```js
// worker.js
immer.produce(stateObject, draftState => {
  // 在这里操作 `draftState`
}, patches => {
  postMessage(patches);
});

// main.js
worker.addEventListener("message", ({data}) => {
  state = immer.applyPatches(state, data);
  // 对新状态的反应
}
```

ImmerJS 生成的补丁如下所示：

```json
[
  {
    "op": "remove",
    "path": [ "socials", "gplus" ]
  },
  {
    "op": "add",
    "path": [ "socials", "twitter" ],
    "value": "@DasSurma"
  },
  {
    "op": "replace",
    "path": [ "name" ],
    "value": "Surma"
  }
]
```

这意味着需要传输的数据量与更改的大小成比例，而不是与对象的大小成比例。

### 分块

正如我所说，对于状态对象，**通常**只有少数几个属性会改变。但并非总是如此。事实上，[PROXX](https://proxx.app) 有这样一个场景，补丁集可能会变得非常大：第一个展示可能会影响多达 80% 的游戏字段，这意味着补丁集有大约 70 KiB 的大小。当目标定位于功能手机时，这就太多了，特别是当我们可能运行 JS 驱动的 WebGL 动画时。

我们问自己一个架构上的问题：我们的应用程序能支持部分更新吗？Patchsets 是补丁的集合。**你可以将补丁集“分块”到更小的分区中，并按顺序应用补丁，而不是一次性发送补丁集中的所有补丁。** 在第一个消息中发送补丁 1 - 10，在下一个消息中发送补丁 11 - 20，以此类推。如果你将这一点发挥到极致，那么你就可以有效地让你的补丁**流式化**，从而允许你使用你可能知道的设计模式以及喜爱的响应式编程。

当然，如果你不注意，这可能会导致不完整甚至破碎的视觉效果。然而，你可以控制分块如何进行，并可以重新排列补丁以避免任何不希望的效果。例如，你可以确保第一个块包含所有影响屏幕元素的补丁，并将其余的补丁放在几个补丁集中，以给主线程留出喘息的空间。

我们在 [PROXX](https://proxx.app) 上做分块。当用户点击一个字段时，worker 遍历整个网格，确定需要更新哪些字段，并将它们收集到一个列表中。如果列表增长超过某个阈值，我们就将目前拥有的内容发送到主线程，清空列表并继续迭代游戏字段。这些补丁集足够小，即使在功能手机上， `postMessage()` 的成本也可以忽略不计，我们仍然有足够的主线程预算时间来更新我们的游戏 UI。迭代算法从第一个瓦片向外工作，这意味着我们的补丁以相同的方式排列。如果主线程只能在帧预算中容纳一条消息（就像 Nokia 8110），那么部分更新就会伪装成一个显示动画。如果我们在一台功能强大的机器上，主线程将继续处理消息事件，直到超出预算为止，这是 JavaScript 的事件循环的自然结果。

视频链接：https://dassur.ma/things/is-postmessage-slow/proxx-reveal.mp4

经典手法：在 [PROXX] 中，补丁集的分块看起来像一个动画。这在支持 6x CPU 节流的台式机或低端手机上尤其明显。

### 也许应该 JSON?

`JSON.parse()` 和 `JSON.stringify()` 非常快。JSON 是 JavaScript 的一个小子集，所以解析器需要处理的案例更少。由于它们的频繁使用，它们也得到了极大的优化。[Mathias 最近指出](https://twitter.com/mathias/status/1143551692732030979)，有时可以通过将大对象封装到 `JSON.parse()` 中来缩短 JavaScript 的解析时间。**也许我们也可以使用 JSON 来加速 `postMessage()` ？遗憾的是，答案似乎是否定的：**

![将发送对象的持续时间与序列化、发送和反序列化对象进行比较的图](https://dassur.ma/things/is-postmessage-slow/serialize.svg)

将手工 JSON 序列化的性能与普通的 `postMessage()` 进行比较，没有得到明确的结果。

虽然没有明显的赢家，但是普通的 `postMessage()` 在最好的情况下表现得更好，在最坏的情况下表现得同样糟糕。

### 二进制格式

处理结构化克隆对性能影响的另一种方法是完全不使用它。除了结构化克隆对象外，`postMessage()` 还可以**传输**某些类型。`ArrayBuffer` 是这些[可转换](https://developer.mozilla.org/en-US/docs/Web/API/Transferable)类型之一。顾名思义，传输 `ArrayBuffer` 不涉及复制。发送方实际上失去了对缓冲区的访问，现在是属于接收方的。**传输一个 `ArrayBuffer` 非常快，并且独立于 `ArrayBuffer`的大小。** 缺点是 `ArrayBuffer` 只是一个连续的内存块。我们就不能再处理对象和属性。为了让 `ArrayBuffer` 发挥作用，我们必须自己决定如何对数据进行编组。这本身是有代价的，但是通过了解构建时数据的形状或结构，我们可以潜在地进行许多优化，而这些优化是一般克隆算法无法实现的。

一种允许你使用这些优化的格式是 [FlatBuffers](https://google.github.io/flatbuffers/)。Flatbuffers 有 JavaScript （和其他语言）对应的编译器，可以将模式描述转换为代码。该代码包含用于序列化和反序列化数据的函数。更有趣的是：Flatbuffers 不需要解析（或“解包”）整个 `ArrayBuffer` 来返回它包含的值。

### WebAssembly

那么使用每个人都喜欢的 WebAssembly 呢?一种方法是使用 WebAssembly 查看其他语言生态系统中的序列化库。[CBOR](https://cbor.io) 是一种受 json 启发的二进制对象格式，已经在许多语言中实现。[ProtoBuffers](https://developer.google.com/protocol-buffers/) 和前面提到的 [FlatBuffers](https://google.github.io/flatbuffers/) 也有广泛的语言支持。

然而，我们可以在这里更厚颜无耻：我们可以依赖该语言的内存布局作为序列化格式。我用 [Rust](https://www.rust-lang.org) 编写了[一个小例子](https://dassur.ma/things/is-postmessage-slow/binary-state-rust)：它用一些 getter 和 setter 方法定义了一个 `State` 结构体(无论你的应用程序的状态如何，它都是符号)，这样我就可以通过 JavaScript 检查和操作状态。要“序列化”状态对象，只需复制结构所占用的内存块。为了反序列化，我分配一个新的 `State` 对象，并用传递给反序列化函数的数据覆盖它。由于我在这两种情况下使用相同的 WebAssembly 模块，内存布局将是相同的。

> 这只是一个概念的证明。如果你的结构包含指针（如 `Vec` 和 `String`），那么你就很容易陷入未定义的行为错误中。同时还有一些不必要的复制。所以请对代码负责任!

```rust
pub struct State {
    counters: [u8; NUM_COUNTERS]
}

#[wasm_bindgen]
impl State {
    // 构造器, getters and setter...

    pub fn serialize(&self) -> Vec<u8> {
        let size = size_of::<State>();
        let mut r = Vec::with_capacity(size);
        r.resize(size, 0);
        unsafe {
            std::ptr::copy_nonoverlapping(
                self as *const State as *const u8,
                r.as_mut_ptr(),
                size
            );
        };
        r
    }
}

#[wasm_bindgen]
pub fn deserialize(vec: Vec<u8>) -> Option<State> {
    let size = size_of::<State>();
    if vec.len() != size {
        return None;
    }

    let mut s = State::new();
    unsafe {
        std::ptr::copy_nonoverlapping(
            vec.as_ptr(),
            &mut s as *mut State as *mut u8,
            size
        );
    }
    Some(s)
}
```

> **注意：** [Ingvar](https://twitter.com/rreverser) 向我指出了 [Abomonation](https://github.com/TimelyDataflow/abomonation)，是一个严重有问题的序列化库，虽然可以使用指针的概念。他的建议：“不要使用这个库！”。

WebAssembly 模块最终 gzip 格式大小约为 3 KiB，其中大部分来自内存管理和一些核心库函数。当某些东西发生变化时，就会发送整个状态对象，但是由于 `ArrayBuffers` 的可移植性，其成本非常低。换句话说：**该技术应该具有几乎恒定的传输时间，而不管状态大小。** 然而，访问状态数据的成本会更高。总是要权衡的!

这种技术还要求状态结构不使用指针之类的间接方法，因为当将这些值复制到新的 WebAssembly 模块实例时，这些值是无效。因此，你可能很难在高级语言中使用这种方法。我的建议是 C、 Rust 和 AssemblyScript，因为你可以完全控制内存并对内存布局有足够的了解。

### SAB 和 WebAssembly

> **提示：** 本节适用于 `SharedArrayBuffer`，它在除桌面端的 Chrome 外的所有浏览器中都已禁用。这正在进行中，但是不能给出 ETA。

特别是从游戏开发人员那里，我听到了多个请求，要求 JavaScript 能够跨多个线程共享对象。我认为这不太可能添加到 JavaScript 本身，因为它打破了 JavaScript 引擎的一个基本假设。但是，有一个例外叫做 [`SharedArrayBuffer`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer) ("SABs")。SABs 的行为完全类似于 `ArrayBuffers`，但是在传输时，不像 `ArrayBuffers` 那样会导致其中一方失去访问权， SAB 可以克隆它们，并且**双方**都可以访问到相同的底层内存块。**SABs 允许 JavaScript 空间采用共享内存模型。** 对于多个空间之间的同步，有 [`Atomics`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics) 提供互斥和原子操作。

使用 SABs，你只需在应用程序启动时传输一块内存。然而，除了二进制表示问题之外，你还必须使用 `Atomics` 来防止其中一方在另一方还在写入的时候读取状态对象，反之亦然。这可能会对性能产生相当大的影响。

除了使用 SABs 和手动序列化/反序列化数据之外，你还可以使用**线程化**的 WebAssembly。WebAssembly 已经标准化了对线程的支持，但是依赖于 SABs 的可用性。**使用线程化的 WebAssembly，你可以使用与使用线程编程语言相同的模式编写代码**。当然，这是以开发复杂性、编排以及可能需要交付的更大、更完整的模块为代价的。

## 结论

我的结论是：即使在最慢的设备上，你也可以使用 `postMessage()` 最大 100 KiB 的对象，并保持在 100 ms 响应预算之内。如果你有 JS 驱动的动画，有效载荷高达 10 KiB 是无风险的。对于大多数应用程序来说，这应该足够了。**`postMessage()` 确实有一定的代价，但还不到让非主线程架构变得不可行的程度。**

如果你的有效负载大于此值，你可以尝试发送补丁或切换到二进制格式。**从一开始就将状态布局、可移植性和可补丁性作为架构决策，可以帮助你的应用程序在更广泛的设备上运行。** 如果你觉得共享内存模型是你最好的选择，WebAssembly 将在不久的将来为你铺平道路。

我已经在[一篇旧的博文](https://dassur.ma/things/actormodel/)上暗示 Actor Model，我坚信我们可以在**如今**的 web 上实现高性能的非主线程架构，但这需要我们离开线程化语言的舒适区以及 web 中那种默认在所有主线程工作的模式。我们需要探索另一种架构和模型，**拥抱** Web 和 JavaScript 的约束。这些好处是值得的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
