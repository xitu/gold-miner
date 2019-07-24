> * 原文地址：[Is postMessage slow?](https://dassur.ma/things/is-postmessage-slow/)
> * 原文作者：[Surma](https://dassur.ma)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/is-postmessage-slow.md](https://github.com/xitu/gold-miner/blob/master/TODO1/is-postmessage-slow.md)
> * 译者：
> * 校对者：

# Is postMessage slow?

No, not really. (It depends.)

What does “slow” mean? [I said it before](/things/less-snakeoil/), and I will say it again: If you didn’t measure it, it is not slow, and even if you measure it, the numbers are meaningless without context.

That being said, the fact that people will not even consider adopting [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Worker) because of their concerns about the performance of `postMessage()`, means that this is worth investigating. [My last blog post](/things/when-workers/) on workers got [responses](https://twitter.com/dfabu/status/1139567716052930561) along these lines, too. Let’s put actual numbers to the performance of `postMessage()` and see at what point you risk blowing your budgets. What can you do if vanilla `postMessage()` is too slow for your use-case?

Ready? Go.

## How postMessage works

Before we start measuring, we need to understand **what** `postMessage()` is and which part of it we want to measure. Otherwise, [we’ll end up gathering meaningless data](/things/deep-copy/) and drawing meaningless conclusions.

`postMessage()` is part of the [HTML spec](https://html.spec.whatwg.org/multipage/) (not [ECMA-262](http://www.ecma-international.org/ecma-262/10.0/index.html#Title)!). As I mentioned in my [deep-copy post](/things/deep-copy/), `postMessage()` relies on structured cloning to copy the message from one JavaScript realm to another. Taking a closer look at [the specification of `postMessage()`](https://html.spec.whatwg.org/multipage/web-messaging.html#message-port-post-message-steps), it turns out that structured cloning is a two-step process:

### Structured Clone algorithm

1. Run `StructuredSerialize()` on the message
2. Queue a task in the receiving realm, that will execute the following steps:
    1. Run `StructuredDeserialize()` on the serialized message
    2. Create a `MessageEvent` and dispatch a `MessageEvent` with the deserialized message on the receiving port

This is a simplified version of the algorithm so we can focus on the parts that matter for this blog post. It’s **technically** incorrect, but catches the spirit, if you will. For example, `StructuredSerialize()` and `StructuredDeserialize()` are not real functions in the sense that they are not exposed via JavaScript ([yet](https://github.com/whatwg/html/pull/3414)). What do these two functions actually do? For now, **you can think of `StructuredSerialize()` and `StructuredDeserialize()` as smarter versions of `JSON.stringify()` and `JSON.parse()`**, respectively. They are smarter in the sense that they handle cyclical data structures, built-in data types like `Map`, `Set` and `ArrayBuffer` etc. But do these smarts come at a cost? We’ll get back to that later.

Something that the algorithm above doesn’t spell out explicitly is the fact that **serialization blocks the sending realm, while deserialization blocks the receiving realm.** And there’s more: It turns out that both Chrome and Safari defer running `StructuredDeserialize()` until you actually access the `.data` property on the `MessageEvent`. Firefox on the other hand deserializes before dispatching the event.

> **Note:** Both of these behaviors **are** spec-compatible and perfectly valid. [I opened a bug with Mozilla](https://bugzilla.mozilla.org/show_bug.cgi?id=1564880), asking if they are willing to align their implementation, as it puts the developer in control when to take the “performance hit” of deserializing big payloads.

With that in mind, we have to make a choice **what** to benchmark: We could measure end-to-end, so measuring how much time it takes to send a message from a worker to the main thread. However, that number would capture the sum of serialization and deserialization, each of which are happening in different realms. Remember: **This whole spiel with workers is motivated by wanting to keep the main thread free and responsive.** Alternatively, we could limit the benchmarks to Chrome and Safari and measure how long it takes to access the `.data` property to measure `StructuredDeserialize()` in isolation, which would exclude Firefox from the benchmark. I also haven’t found a way to measure `StructuredSerialize()` in isolation, short of running a trace. Neither of these choices are ideal, but in the spirit of building resilient web apps, **I decided to run the end-to-end benchmark to provide an **upper bound** for the cost of `postMessage()`.**

Armed with a conceptual understanding of `postMessage()` and the determination to measure, I shall use microbenchmarks. Please mind the gap between these numbers and reality.

## Benchmark 1: How long does sending a message take?

![Two JSON objects showing depth and breadth](https://dassur.ma/things/is-postmessage-slow/breadth-depth.svg)

Depth and breadth vary between 1 and 6. For each permutation, 1000 objects will be generated.

The benchmark will generate an object with a specific “breadth” and “depth”. The values for breadth and depth lie between 1 and 6. **For each combination of breadth and depth, 1000 unique objects will be `postMessage()`’d from a worker to the main thread**. The property names of these objects are random 16-digit hexadecimal numbers as a string, the values are either a random boolean, a random float or again a random string in the from of a 16-digit hexadecimal number. **The benchmark will measure the transfer time and calculate the 95th percentile.**

### Results

![](https://dassur.ma/things/is-postmessage-slow/nokia2-chrome.svg)

![](https://dassur.ma/things/is-postmessage-slow/pixel3-chrome.svg)

![](https://dassur.ma/things/is-postmessage-slow/macbook-chrome.svg)

![](https://dassur.ma/things/is-postmessage-slow/macbook-firefox.svg)

![](https://dassur.ma/things/is-postmessage-slow/macbook-safari.svg)

The benchmark was run on Firefox, Safari and Chrome on a 2018 MacBook Pro, on Chrome on a Pixel 3XL and on Chrome on a Nokia 2.

> **Note:** You can find the benchmark data, to code to generate it and the code for the visualization in [this gist](https://gist.github.com/surma/08923b78c42fab88065461f9f507ee96). Also, this was the first time in my life writing Python. Don’t be too harsh on me.

The benchmark data from the Pixel 3 and especially Safari might look a bit suspicious to you. When Spectre & Meltdown were discovered, all browsers disabled [`SharedArrayBuffer`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer) and reduced the precision of timers like [`performance.now()`](https://developer.mozilla.org/en-US/docs/Web/API/Performance/now), which I use to measure. Only Chrome was able to revert some these changes since they shipped [Site Isolation](https://www.chromium.org/Home/chromium-security/site-isolation) to Chrome on desktop. More concretely that means that browsers clamp the precision of `performance.now()` to the following values:

* Chrome (desktop): 5µs
* Chrome (Android): 100µs
* Firefox (desktop): 1ms (clamping can be disabled flag, which I did)
* Safari (desktop): 1ms

The data shows that the complexity of the object is a strong factor in how long it takes to serialize and deserialize an object. This should not be surprising: Both the serialization and deserialization process have to traverse the entire object one way or another. The data indicates furthermore that the size of the JSON representation of an object is a good predictor for how long it takes to transfer that object.

## Benchmark 2: What makes postMessage slow?

To verify, I modified the benchmark: I generate all permutations of breadth and depth between 1 and 6, but in addition all leaf properties have a string value with a length between 16 bytes and 2KiB.

### Results

![A graph showing the correlation between payload size and transfer time for postMessage](https://dassur.ma/things/is-postmessage-slow/correlation.svg)

Transfer time has a strong correlation with the length of the string returned by `JSON.stringify()`.

I think the correlation is strong enough to issue a rule of thumb: **The stringified JSON representation of an object is roughly proportional to its transfer time.** However, even more important to note is the fact that **this correlation only becomes relevant for big objects**, and by big I mean anything over 100KiB. While the correlation holds mathematically, the divergence is much more visible at smaller payloads.

## Evaluation: It’s about sending a message

We have data, but it’s meaningless if we don’t contextualize it. If we want to draw **meaningful** conclusions, we need to define “slow”. Budgets are a helpful tool here, and I will once again go back to the [RAIL](https://developers.google.com/web/fundamentals/performance/rail) guidelines to establish our budgets.

In my experience, a web worker’s core responsibility is, at the very least, managing your app’s state object. State often only changes when the user interacts with your app. According to RAIL, we have 100ms to react to user interactions, which means that **even on the slowest devices, you can `postMessage()` objects up to 100KiB and stay within your budget.**

This changes when you have JS-driven animations running. The RAIL budget for animations is 16ms, as the visuals need to get updated every frame. If we send a message from the worker that would block the main thread for longer than that, we are in trouble. Looking at the numbers from our benchmarks, everything up to 10KiB will not pose a risk to your animation budget. That being said, **this is a strong reason to prefer CSS animations and transitions over main-thread JS-driven animations.** CSS animations and transitions runs on a separate thread — the compositor thread — and are not affected by a blocked main thread.

## Must. send. moar. data.

In my experience, `postMessage()` is not the bottleneck for most apps that are adopting an off-main-thread architecture. I will admit, however, that there might be setups where your messages are either really big or you need to send a lot of them at a high frequency. What can you do if vanilla `postMessage()` is too slow for you?

### Patching

In the case of state objects, the objects themselves can be quite big, but it’s often only a handful of deeply nested properties that change. We encountered this problem in [PROXX](https://proxx.app), our PWA Minesweeper clone: The game state consists of a 2-dimensional array for the game grid. Each cell stores whether it’s a mine, if it’s been revealed or if it’s been flagged:

```typescript
interface Cell {
  hasMine: boolean;
  flagged: boolean;
  revealed: boolean;
  touchingMines: number;
  touchingFlags: number;
}
```

That means the biggest possible grid of 40 by 40 cells adds up to ~134KiB of JSON. Sending an entire state object is out of the question. **Instead of sending the entire new state object whenever something changes, we chose to record the changes and send a patchset instead.** While we didn’t use [ImmerJS](https://github.com/immerjs/immer), a library for working with immutable objects, it does provide a quick way to generate and apply such patchsets:

```js
// worker.js
immer.produce(stateObject, draftState => {
  // Manipulate `draftState` here
}, patches => {
  postMessage(patches);
});

// main.js
worker.addEventListener("message", ({data}) => {
  state = immer.applyPatches(state, data);
  // React to new state
}
```

The patches that ImmerJS generates look like this:

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

This means that the amount that needs to get transferred is proportional to the size of your changes, not the size of the object.

### Chunking

As I said, for state objects it’s **often** only a handful of properties that change. But not always. In fact, [PROXX](https://proxx.app) has a scenario where patchsets could turn out quite big: The first reveal can affect up to 80% of the game field, which adds up to a patchset of about ~70KiB. When targeting feature phones, that is too much, especially as we might have JS-driven WebGL animations running.

We asked ourselves an architectural question: Can our app support partial updates? Patchsets are a collection of patches. **Instead of sending all patches in the patchset at once, you can “chunk” the patchset into smaller partitions and apply them sequentially.** Send patches 1-10 in the first message, 11-20 on the next, and so on. If you take this to the extreme, you are effectively **streaming** your patches, allowing you to use all the patterns you might know and love from reactive programming.

Of course, this can result in incomplete or even broken visuals if you don’t pay attention. However, you are in control of how the chunking happens and could reorder the patches to avoid any undesired effects. For example, you could make sure that the first chunk contains all patches affecting on-screen elements, and put the remaining patches in to a couple of patchsets to give the main thread room to breathe.

We do chunking in [PROXX](https://proxx.app). When the user taps a field, the worker iterates over the entire grid to figure out which fields need to be updated and collects them in a list. If that list grows over a certain threshold, we send what we have so far to the main thread, empty the list and continue iterating the game field. These patchsets are small enough that even on a feature phone the cost of `postMessage()` is negligible and we still have enough main thread budget time to update our game’s UI. The iteration algorithm works from the first tile outwards, meaning our patches are ordered in the same fashion. If the main thread can only fit one message into its frame budget (like on the Nokia 8110), the partial updates disguise as a reveal animation. If we are on a powerful machine, the main thread will keep processing message events until it runs out of budget just by nature JavaScript’s event loop.

视频链接：https://dassur.ma/things/is-postmessage-slow/proxx-reveal.mp4

Classic sleight of hand: In [PROXX], the chunking of the patchset looks like an animation. This is especially visible on low-end mobile phones or on desktop with 6x CPU throttling enabled.

### Maybe JSON?

`JSON.parse()` and `JSON.stringify()` are incredibly fast. JSON is a small subset of JavaScript, so the parser has fewer cases to handle. Because of their frequent usage, they have also been heavily optimized. [Mathias recently pointed out](https://twitter.com/mathias/status/1143551692732030979), that you can sometimes reduce parse time of your JavaScript by wrapping big objects into `JSON.parse()`. **Maybe we can use JSON to speed up `postMessage()` as well? Sadly, the answer seems to be no:**

![A graph comparing the duration of sending an object to serializing, sending, and deserializing an object.](https://dassur.ma/things/is-postmessage-slow/serialize.svg)

Comparing the performance of manual JSON serialization to vanilla `postMessage()` yields no clear result.

While there is no clear winner, vanilla `postMessage()` seems to perform better in the best case, and equally bad in the worst case.

### Binary formats

Another way to deal with the performance impact of structured cloning is to not use it at all. Apart from structured cloning objects, `postMessage()` can also **transfer** certain types. `ArrayBuffer` is one of these [transferable](https://developer.mozilla.org/en-US/docs/Web/API/Transferable) types. As the name implies, transferring an `ArrayBuffer` does not involve copying. The sending realm actually loses access to the buffer and it is now owned by the receiving realm. **Transferring an `ArrayBuffer` is extremely fast and independent of the size of the `ArrayBuffer`**. The downside is that `ArrayBuffer` are just a continuous chunk of memory. We are not working with objects and properties anymore. For an `ArrayBuffer` to be useful we have to decide how our data is marshalled ourselves. This in itself has a cost, but by knowing the shape or structure of our data at build time we can potentially tap into many optimizations that are unavailable to a generic cloning algorithm.

One format that allows you to tap into these optimizations are [FlatBuffers](https://google.github.io/flatbuffers/). FlatBuffers have compilers for JavaScript (and other languages) that turn schema descriptions into code. That code contains functions to serialize and deserialize your data. Even more interestingly: FlatBuffers don’t need to parse (or “unpack”) the entire `ArrayBuffer` to return a value it contains.

### WebAssembly

What about everyone’s favorite: WebAssembly? One approach is to use WebAssembly to look at serialization libraries in the ecosystems of other languages. [CBOR](https://cbor.io), a JSON-inspired binary object format, has been implemented in many languages. [ProtoBuffers](https://developers.google.com/protocol-buffers/) and the aforementioned [FlatBuffers](https://google.github.io/flatbuffers/) have wide language support as well.

However, we can be more cheeky here: We can rely on the memory layout of the language as our serialization format. I wrote [a little example](./binary-state-rust) using [Rust](https://www.rust-lang.org): It defines a `State` struct (symbolic for whatever your app’s state looks like) with some getter and setter methods so I can inspect and manipulate the state from JavaScript. To “serialize” the state object, I just copy the chunk of memory occupied by the struct. To deserialize, I allocate a new `State` object, and overwrite it with the data passed to the deserialization function. Since I’m using the same WebAssembly module in both cases, the memory layout will be identical.

> This is just a proof-of-concept. You can easily tap into undefined behavior if your struct contains pointers (like `Vec` and `String` do). There’s also some unnecessary copying going on. Code responsibly!

```rust
pub struct State {
    counters: [u8; NUM_COUNTERS]
}

#[wasm_bindgen]
impl State {
    // Constructors, getters and setter...

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

> **Note:** [Ingvar](https://twitter.com/rreverser) pointed me to [Abomonation](https://github.com/TimelyDataflow/abomonation), a seriously questionable serialization library that works even **with** pointers. His advice: “Do \[not\] try this!”.

The WebAssembly module ends up at about 3KiB gzip’d, most of which stems from memory management and some core library functions. The entire state object is sent whenever something changes, but due to the transferability of `ArrayBuffers`, this is extremely cheap. In other words: **This technique should have near-constant transfer time, regardless of state size.** It will, however, be more costly to access state data. There’s always a tradeoff!

This technique also requires that the state struct does not make any use of indirection like pointers, as those values will become invalid when copied to a new WebAssembly module instance. As a result, you will probably struggle to use this approach with higher-level languages. My recommendations are C, Rust and AssemblyScript, as you are in full control and have sufficient insight into memory layout.

### SABs & WebAssembly

> **Heads up:** This section works with `SharedArrayBuffer`, which have been disabled in all browsers except Chrome on desktop. This is being worked on, but no ETA can be given on this.

Especially from game developers, I have heard multiple requests to give JavaScript the capability to share objects across multiple threads. I think this is unlikely to ever be added to JavaScript itself, as it breaks one of the fundamentals assumptions of JavaScript engines. However, there is an exception to this called [`SharedArrayBuffer`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer) (“SABs”). SABs behave exactly like `ArrayBuffers`, but instead of one realm losing access when being transferred , they can be cloned and **both** realms will have access to the same underlying chunk of memory. **SABs allows the JavaScript realms to adopt a shared memory model.** For synchronization between realms, there’s [`Atomics`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics) which provide Mutexes and atomic operations.

With SABs, you’d only have to transfer a chunk of memory once at the start of your app. However, in addition to the binary representation problem, you’d have to use `Atomics` to prevent one realm from reading the state object while the other realm is still writing and vice-versa. This can have a considerable performance impact.

As an alternative to using SABs and serializing/deserializing data manually, you could embrace **threaded** WebAssembly. WebAssembly has standardized support for threads, but is gated on the availability of SABs. **With threaded WebAssembly you can write code with the exact same patterns you are used to from threaded programming languages.** This, of course, comes at the cost of development complexity, orchestration and potentially bigger and monolithic modules that need to get shipped.

## Conclusion

Here’s my verdict: Even on the slowest devices, you can `postMessage()` objects up to 100KiB and stay within your 100ms response budget. If you have JS-driven animations, payloads up to 10KiB are risk-free. This should be sufficient for most apps. **`postMessage()` does have a cost, but not the extent that it makes off-main-thread architectures unviable.**

If your payloads are bigger than this, you can try sending patches or switching to a binary format. **Considering state layout, transferability and patchability as an architectural decision from the start can help your app run on a wider spectrum of devices.** If you feel like a shared memory model is your best bet, WebAssembly will pave that way for you in the near future.

As I already hinted at in [an older blog post](/things/actormodel/) about the Actor Model, I strongly believe we can implement performant off-main-thread architectures on the web **today**, but this requires us leaving our comfort zone of threaded languages and the web’s all-on-main-by-default. We need to explore alternative architectures and models that **embrace** the constraints of the Web and JavaScript. The benefits are worth it.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
