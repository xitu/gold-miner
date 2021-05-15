> * 原文地址：[Speed of Rust vs. C](https://kornel.ski/rust-c-speed)
> * 原文作者：kornelski
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/speed-of-rust-vs-c.md](https://github.com/xitu/gold-miner/blob/master/article/2021/speed-of-rust-vs-c.md)
> * 译者：
> * 校对者：

# Speed of Rust vs. C

The run-time speed and memory usage of programs written in Rust should about the same as of programs written in C, but overall programming style of these languages is different enough that it's hard to generalize their speed. This is a summary of where they're the same, where C is faster, and where Rust is faster.

Disclaimer: It's not meant to be an objective benchmark uncovering indisputable truths about these languages. There's a significant difference between what these languages can achieve in theory, and how they're used in practice. This particular comparison is based on my own subjective experience that includes having deadlines, writing bugs, and being lazy. I've been using Rust as my main language for over 4 years, and C for a decade before that. I'm specifically comparing to just C here, as a comparison with C++ would have many more "ifs" and "buts" that I don't want to get into.

In short:

- Rust's abstractions are a double-edged sword. They can hide suboptimal code, but also make it easier to make algorithmic improvements and take advantage of highly optimized libraries.
- I'm never worried that I'm going to hit a performance dead-end with Rust. There's always the `unsafe` escape hatch that allows very low-level optimizations (and it's not needed often).
- Fearless concurrency is real. The occasional awkwardness of the borrow checker pays off in making parallel programming *practical*.

My overall feeling is that if I could spend infinite time and effort, my C programs would be as fast or faster than Rust, because theoretically there's nothing that C can't do that Rust can. But in practice C has fewer abstractions, primitive standard library, dreadful dependency situation, and I just don't have the time to reinvent the wheel, optimally, every time.

## Both are "portable assemblers"

Both Rust and C give control over the layout of data structures, integer sizes, stack vs heap memory allocation, pointer indirections, and generally translate to understandable machine code with little "magic" inserted by the compiler. Rust even admits that bytes have 8 bits and signed integers can overflow!

Even though Rust has higher-level constructs such as iterators, traits and smart pointers, they're designed to predictably optimize to straightforward machine code (AKA "zero-cost abstractions"). Memory layout of Rust's types is simple, e.g. growable strings and vectors are exactly `{byte*, capacity, length}`. Rust doesn't have any concept like move or copy constructors, so passing of objects is guaranteed to be no more complicated than passing a pointer or `memcpy`.

Borrow-checking is only a compile-time static analysis. It doesn't *do* anything, and lifetime information is even completely stripped out before code generation. There's no autoboxing or anything clever like that.

One case where Rust falls short of being "dumb" code generator is [unwinding](https://github.com/rust-lang/project-ffi-unwind). While Rust doesn't use exceptions for normal error handling, a panic (unhandled fatal error) may optionally behave like a C++ exception. It can be disabled at compilation time (panic = abort), but even then Rust doesn't like to be mixed with C++ exceptions or `longjmp`.

## Same old LLVM back-end

Rust has a good integration with LLVM, so it supports Link-Time Optimization, including ThinLTO and even inlining across C/C++/Rust language boundaries. There's profile-guided optimization, too. Even though `rustc` generates more verbose LLVM IR than `clang`, the optimizer can still deal with it pretty well.

Some of my C code is a bit faster when compiled with GCC than LLVM, and there's no Rust front-end for [GCC yet](https://github.com/Rust-GCC/gccrs), so Rust misses out on that.

In theory, Rust allows even better optimizations than C thanks to stricter immutability and aliasing rules, but in practice this doesn't happen yet. Optimizations beyond what C does are a work-in-progress in LLVM, so Rust still hasn't reached its full potential.

## Both allow hand-tuning, with minor exceptions

Rust code is low-level and predictable enough that I can hand-tune what assembly it will optimize to. Rust supports SIMD intrinsics, has good control over inlining, calling conventions, etc. Rust is similar enough to C that C profilers usually work with Rust out of the box (e.g. I can use Xcode's Instruments on a program that's a Rust-C-Swift sandwich).

In general, where the performance is absolutely critical and needs to be hand-optimized to the last bit, optimizing Rust isn't much different from C.

There are some low-level features that Rust doesn't have a proper replacement for:

- *computed* goto. "Boring" uses of `goto` can be replaced with other constructs in Rust, like `loop {break}`. In C many uses of `goto` are for cleanup, which Rust doesn't need thanks to RAII/destructors. However, there's a non-standard `goto *addr` extension that's very useful for interpreters. Rust can't do it directly (you can write a `match` and *hope* it'll optimize), but OTOH if I needed an interpreter, I'd try to leverage [Cranelift JIT](https://lib.rs/crates/cranelift) instead.
- `alloca` and C99 variable-length arrays. These are [controversial](https://www.phoronix.com/scan.php?page=news_item&px=Linux-Kills-The-VLA) even in C, so Rust stays away from them.

It's worth noting that Rust currently supports only one 16-bit architecture. The [tier 1 support](https://forge.rust-lang.org/platform-support.html) is focused on 32-bit and 64-bit platforms.

## Small overheads of Rust

However, where Rust isn't hand-tuned, some inefficiencies can creep in:

- Rust's lack of implicit type conversion and indexing only with `usize` nudges users to use just this type, even where smaller types would suffice. That's in contrast with C where a 32-bit `int` is the popular choice. Indexing by `usize` is easier to optimize on 64-bit platforms without relying on undefined behavior, but the extra bits may put more pressure on registers and memory.


- Idiomatic Rust always passes pointer *and size* for strings and slices. It wasn't until I ported a couple codebases from C to Rust, that I realized just how many C functions only take a pointer to memory, without a size, and hope for the best (the size is either known indirectly from the context, or just assumed to be large enough for the task).


- Not all bounds checks are optimized out. `for item in arr` or `arr.iter().for_each(…)` are as efficient as they can be, but if the form `for i in 0..len {arr[i]}` is needed, then performance depends on the LLVM optimizer being able to prove the length matches. Sometimes it can't, and the bound checks inhibit autovectorization. Of course, there are various workarounds for this, both safe and unsafe.

- "Clever" memory use is frowned upon in Rust. In C, anything goes. For example, in C I'd be tempted to reuse a buffer allocated for one purpose for another purpose later (a technique known as HEARTBLEED). It's convenient to have fixed-size buffers for variable-size data (e.g. `PATH_MAX`) to avoid (re)allocation of growing buffers. Idiomatic Rust still gives a lot control over memory allocation, and can do basics like memory pools, combining multiple allocations into one, preallocating space, etc., but in general it steers users towards "boring" use or memory.

- In cases where borrow checking rules make things hard, the easy way out is to do extra copying or use reference counting. Over time I've learned a bunch of borrow-checker tricks, and adjusted my coding style to be borrow-checker friendly, so this doesn't come up often any more. This never becomes a *major* problem, because if necessary, there's always a fallback to "raw" pointers.

    Rust's borrow checker is [infamous for hating doubly-linked lists](https://rust-unofficial.github.io/too-many-lists/), but luckily it happens that linked lists are slow on 21st-century hardware anyway (poor cache locality, no vectorization). Rust's standard library has linked lists, as well as faster and borrow-checker-friendly containers to choose from.

    There are two more cases that the borrow checker can't tolerate: memory-mapped files (magical changes from outside of the process violate immutable^exclusive semantics of references) and self-referential structs (passing of the struct by value would make its inner pointers dangle). These cases are solved either with raw pointers that are as safe as every pointer in C, or mental gymnastics to make safe abstractions around them.

- To Rust, single-threaded programs just don't exist as a concept. Rust allows individual data structures to be non-thread-safe for performance, but anything that is allowed to be shared between threads (including global variables) has to be synchronized or marked as `unsafe`.
- I keep forgetting that Rust's strings support some cheap in-place operations, such as `make_ascii_lowercase()` (a direct equivalent of what I'd do in C), and unnecessarily use Unicode-aware, copying `.to_lowercase()`. Speaking of strings, the UTF-8 encoding is not as big of a problem as it may seem, because strings have `.as_bytes()` view, so they can be processed in Unicode-ignorant way if needed.
- libc bends over backwards to make `stdout` and `putc` reasonably fast. Rust's libstd has less magic, so I/O isn't buffered unless wrapped in a `BufWriter`. I've seen people complain that their Rust is slower than Python, and it was because Rust spent 99% of the time flushing the result byte by byte, exactly as told.

## Executable sizes

Every operating system ships some built-in standard C library that is ~30MB of code that C executables get for "free", e.g. a small "Hello World" C executable can't actually print anything, it only calls the `printf` shipped with the OS. Rust can't count on OSes having *Rust's* standard library built-in, so Rust executables bundle their own standard library (300KB or more). Fortunately, it's a one-time overhead and [can be reduced](https://github.com/johnthagen/min-sized-rust). For embedded development, the standard library can be turned off and Rust will generate "bare" code.

On per-function basis Rust code is about the same size as C, but there's a problem of "generics bloat". Generic functions get optimized versions for each type they're used with, so it's possible to end up with 8 versions of the same function. [`cargo-bloat`](https://lib.rs/cargo-bloat) helps finding these.

It's super easy to use dependencies in Rust. Similarly to JS/npm, there's a culture of making small single-purpose libraries, but they do add up. Eventually all my executables end up containing Unicode normalization tables, 7 different random number generators, and an HTTP/2 client with Brotli support. `cargo-tree` is useful for deduping and culling them.

## Small wins for Rust

I've talked a lot about overheads, but Rust also has places where it ends up more efficient and faster:

- C libraries typically return opaque pointers to their data structures, to hide implementation details and ensure there's only one copy of each instance of the struct. This costs heap allocations and pointer indirections. Rust's built-in privacy, single-ownership rules, and coding conventions let libraries expose their objects without indirection, so that callers can decide whether to put them on the heap or on the stack. Objects on the stack can can be optimized very aggressively, and even optimized out entirely.
- Rust by default can inline functions from the standard library, dependencies, and other compilation units. In C I'm sometimes reluctant to split files or use libraries, because it affects inlining and requires micromanagement of headers and symbol visibility.
- Struct fields are reordered to minimize padding. Compiling C with `Wpadding` shows how often I forget about this detail.
- Strings have their size encoded in their "fat" pointer. This makes length checks fast, eliminates risk of [accidental O(n²)](https://nee.lv/2021/02/28/How-I-cut-GTA-Online-loading-times-by-70/) string loops, and allows making substrings in-place (e.g. splitting a string into tokens) without modifying memory or copying to add the `\0` terminator.
- Like C++ templates, Rust generates copies of generic code for each type they're used with, so functions like `sort()` and containers like hash tables are always optimized for their type. In C I have to choose between hacks with macros or less efficient functions that work on `void*` and run-time variable sizes.
- Rust iterators can be combined into chains that get optimized together as one unit. So instead of a series of calls `buy(it); use(it); break(it); change(it); mail(upgrade(it));` that may end up rewriting the same buffer many times, I can call `it.buy().use().break().change().upgrade().mail()` that compiles to one `buy_use_break_change_mail_upgrade(it)` optimized to do all of that in a single combined pass. `(0..1000).map(|x| x*2).sum()` compiles to `return 999000`.
- Similarly, there are `Read` and `Write` interfaces that allow functions to stream unbuffered data. They combine nicely, so I can write data to a stream that calculates CRC of the data on the fly, adds framing/escaping if needed, compresses it, and writes it to the network, all in one call. And I can pass such combined stream as an output stream to my HTML templating engine, so now each HTML tag will be smart enough to send itself compressed. The underlying mechanism is just a pyramid of plain `next_stream.write(bytes)` calls, so technically nothing stops me from doing the same in C, except the lack of traits and generics in C means it's very hard to actually do that in practice, other than with callbacks set up at run time, which isn't as efficient.
- In C it's perfectly rational to overuse linear search and linked lists, because who's going to maintain yet another half-assed implementation of hash table? There are no built-in containers, dependencies are a pain, so I cut corners to get stuff done. Unless absolutely necessary, I won't bother to write a sophisticated implementation of a B-tree. I'll use `qsort` + `bisect` and call it a day. OTOH in Rust it takes only 1 or 2 lines of code to get very high quality implementations all kinds of containers. This means that my Rust programs can afford to use proper, incredibly well-optimized data structures *every time*.
- These days everything seems to require JSON. Rust's `serde` is one of the fastest JSON parsers in the world, and it parses directly into Rust structs, so use of the parsed data is very fast and efficient, too.

## Big win for Rust

Rust enforces thread-safety of all code and data, even in 3rd party libraries, even if authors of that code didn't pay attention to thread safety. Everything either upholds specific thread-safety guarantees, or won't be allowed to be used across threads. If I write any code that is not thread safe, the compiler will point out exactly where it is unsafe.

That's a dramatically different situation than C. Usually no library functions can be trusted to be thread-safe unless they're clearly documented otherwise. It's up to the programmer to ensure all of the code is correct, and the compiler generally can't help with any of this. Multi-threaded C code carries a lot more responsibility, a lot more risk, so it's appealing to pretend multi-core CPUs are just a fad, and imagine users have better things to do with the remaining 7 or 15 cores.

Rust guarantees freedom from data races and memory unsafety (e.g. use-after-free bugs, even across threads). Not just some races that could be found with heuristics or at runtime in instrumented builds, but *all* data races everywhere. This is life-saving, because data races are the worst kind of concurrency bugs. They'll happen on my users' machines, but not in my debugger. There are other kinds of concurrency bugs, such as poor use of locking primitives causing higher-level logical race conditions or deadlocks, and Rust can't eliminate them, but they're usually easier to reproduce and fix.

In C I won't dare to do more than a couple of OpenMP pragmas on simple `for` loops. I've tried being more adventurous with tasks and threads, and ended up regretting it every time.

Rust has has good libraries for data parallelism, thread pools, queues, tasks, lock-free data structures, etc. With the help of such building blocks, and the strong safety net of the type system, I can parallelize Rust programs quite easily. In some cases it's sufficient to replace `iter()` with `par_iter()`, and if it compiles, it works! It's not always a linear speed-up (Amdahl's law is brutal), but it's often a 2×-3× speed-up for relatively little work.

There's an interesting difference how Rust and C libraries document thread-safety. Rust has a vocabulary for specific aspects of thread-safety, such as `Send` and `Sync`, guards and cells. In C, there's no word for "you can allocate it on one thread, and free it on another thread, but you can't use it from two threads at once". Rust describes thread-safety in terms of data types, which generalizes to all functions using them. In C thread-safety is talked about in the context of individual functions and configuration flags. Rust's guarantees tend to be compile-time, or at least unconditional. In C it's common to find "this is thread safe only when the turboblub option is set to 7".

## To sum it up

Rust is low-level enough that if necessary, it can be optimized for maximum performance just as well as C. Higher-level abstractions, easy memory management, and abundance of available libraries tend to make Rust programs have more code, do more, and if left unchecked, can add up to bloat. However, Rust programs also optimize quite well, sometimes better than C. While C is good for writing minimal code on byte-by-byte pointer-by-pointer level, Rust has powerful features for efficiently combining multiple functions or even whole libraries together.

But the biggest potential is in ability to fearlessly parallelize majority of Rust code, even when the equivalent C code would be too risky to parallelize. In this aspect Rust is a much more mature language than C.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
