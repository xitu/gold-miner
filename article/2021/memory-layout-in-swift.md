> * 原文地址：[Memory layout in Swift](https://theswiftdev.com/memory-layout-in-swift/)
> * 原文作者：[Tibor Bödecs](https://theswiftdev.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/memory-layout-in-swift.md](https://github.com/xitu/gold-miner/blob/master/article/2021/memory-layout-in-swift.md)
> * 译者：
> * 校对者：

# Memory layout in Swift

## Memory layout of value types in Swift

Memory is just a bunch of \`1\`s and \`0\`s, simply called [bits](https://en.wikipedia.org/wiki/Bit) (binary digits). If we group the flow of bits into groups of 8, we can call this new unit [byte](https://en.wikipedia.org/wiki/Byte) (eight bit is a byte, e.g. binary 10010110 is hex 96). We can also visualize these bytes in a [hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal) form (e.g. 96 A6 6D 74 B2 4C 4A 15 etc). Now if we put these hexa representations into groups of 8, we'll get a new unit called [word](https://en.wikipedia.org/wiki/Word_(computer_architecture)).

This 64bit memory (a word represents 64bit) layout is the basic foundation of our modern [x64](https://en.wikipedia.org/wiki/64-bit_computing) CPU architecture. Each word is associated with a virtual memory address which is also represented by a ([usually 64bit](https://superuser.com/questions/1188364/what-is-the-size-of-an-address-of-a-variable-in-memory-on-a-64-bit-processor-in)) hexadecimal number. Before the [x86-64](https://en.wikipedia.org/wiki/X86-64) era the [x32 ABI](https://en.wikipedia.org/wiki/X32_ABI) used 32bit long [addresses](https://en.wikipedia.org/wiki/Byte_addressing), with a maximum memory limitation of 4GiB. Fortunately we use x64 nowadays. 💪

So how do we store our data types in this [virtual memory](https://en.wikipedia.org/wiki/Virtual_memory) address space? Well, long story short, we allocate just the right amount of space for each data type and write the hex representation of our values into the memory. It's magic, provided by the operating system and it just works.

We could also start talking about [memory segmentation](https://en.wikipedia.org/wiki/Memory_segmentation), paging, and other low level stuff, but honestly speaking I really don't know how those things work just yet. As I'm digging deeper and deeper into [low level stuff](https://en.wikipedia.org/wiki/Low-level_programming_language) like this I'm learning a lot about how computers work under the hood.

One important thing is that I already know and I want to share with you. It is all about [memory access](https://cs.stackexchange.com/questions/45083/cpu-reading-cycles) on various architectures. For example if a CPU's bus width is 32bit that means the CPU can only read 32bit words from the memory under 1 read cycle. Now if we simply write every object to the memory without proper data separation that can cause some trouble.

```
┌──────────────────────────┬──────┬───────────────────────────┐
│           ...            │  4b  │            ...            │
├──────────────────────────┴───┬──┴───────────────────────────┤
│            32 bytes          │            32 bytes          │
└──────────────────────────────┴──────────────────────────────┘
```

As you can see if our memory data is misaligned, the first 32bit read cycle can only read the very first part of our 4bit data object. It'll take 2 read cycles to get back our data from the given memory space. This is very inefficient and also dangerous, that's why most of the systems won't allow you unaligned access and the program will simply crash. So how does our [memory layout](https://stevenpcurtis.medium.com/memorylayout-in-swift-c4e70bb32e3f) looks like in Swift? Let's take a quick look at our data types using the built-in [MemoryLayout](https://swiftdoc.org/v3.1/type/memorylayout/) enum type.

```swift
print(MemoryLayout<Bool>.size)      // 1
print(MemoryLayout<Bool>.stride)    // 1
print(MemoryLayout<Bool>.alignment) // 1


print(MemoryLayout<Int>.size)       // 8
print(MemoryLayout<Int>.stride)     // 8
print(MemoryLayout<Int>.alignment)  // 8
```

As you can see Swift stores a Bool value using 1 byte and (on 64bit systems) Int will be stored using 8 bytes. So, what the heck is the difference between [size, stride and alignment](https://swiftunboxed.com/internals/size-stride-alignment/)?

The **alignment** will tell you how much memory is needed (multiple of the alignment value) to save things perfectly aligned on a memory buffer. **Size** is the number of bytes required to actually store that type. **Stride** will tell you about the distance between two elements on the buffer. Don't worry if you don't understand a word about these informal definitions, it'll all make sense just in a moment.

```swift
struct Example {
    let foo: Int  // 8
    let bar: Bool // 1
}

print(MemoryLayout<Example>.size)      // 9
print(MemoryLayout<Example>.stride)    // 16
print(MemoryLayout<Example>.alignment) // 8
```

When constructing new data types, a struct in our case (classes work different), we can calculate the memory layout properties, based on the memory layout attributes of the participating variables.

```
┌─────────────────────────────────────┬─────────────────────────────────────┐
│         16 bytes stride (8x2)       │         16 bytes stride (8x2)       │
├──────────────────┬──────┬───────────┼──────────────────┬──────┬───────────┤
│       8 bytes    │  1b  │  7 bytes  │      8 bytes     │  1b  │  7 bytes  │
├──────────────────┴──────┼───────────┼──────────────────┴──────┼───────────┤
│   9 bytes size (8+1)    │  padding  │   9 bytes size (8+1)    │  padding  │
└─────────────────────────┴───────────┴─────────────────────────┴───────────┘
```

In Swift, simple types have the same alignment value size as their size. If you store standard Swift data types on a contiguous memory buffer there's no padding needed, so every stride will be equal with the alignment for those types.

When working with compound types, such as the `Example` struct is, the [memory alignment](https://stackoverflow.com/questions/47610995/alignment-vs-stride-in-swift) value for that type will be selected using the maximum value (8) of the properties alignments. Size will be the sum of the properties (8 + 1) and stride can be calculated by rounding up the size to the next the next multiple of the alignment. Is this true in every case? Well, not exactly...

```swift
struct Example {
    let bar: Bool // 1
    let foo: Int  // 8
}

print(MemoryLayout<Example>.size)      // 16
print(MemoryLayout<Example>.stride)    // 16
print(MemoryLayout<Example>.alignment) // 8
```

What the heck happened here? Why did the size increase? Size is tricky, because if the padding comes in between the stored variables, then it'll increase the overall size of our type. You can't start with 1 byte then put 8 more bytes next to it, because you'd misalign the integer type, so you need 1 byte, then 7 bytes of padding and finally the 8 bypes to store the integer value.

```
┌─────────────────────────────────────┬─────────────────────────────────────┐
│        16 bytes stride (8x2)        │        16 bytes stride (8x2)        │
├──────────────────┬───────────┬──────┼──────────────────┬───────────┬──────┤
│     8 bytes      │  7 bytes  │  1b  │     8 bytes      │  7 bytes  │  1b  │
└──────────────────┼───────────┼──────┴──────────────────┼───────────┼──────┘
                   │  padding  │                         │  padding  │       
┌──────────────────┴───────────┴──────┬──────────────────┴───────────┴──────┐
│       16 bytes size (1+7+8)         │       16 bytes size (1+7+8)         │
└─────────────────────────────────────┴─────────────────────────────────────┘
```

This is the main reason why the second example struct has a slightly increased size value. Feel free to create other types and practice by drawing the memory layout for them, you can always check if you were correct or not by printing the memory layout at runtime using Swift. 💡

> This whole problem is real nicely explained on the [\[swift unboxed\]](https://swiftunboxed.com/internals/size-stride-alignment/) blog. I would also like to recommend [this article by Steven Curtis](https://stevenpcurtis.medium.com/memorylayout-in-swift-c4e70bb32e3f) and there is one more great post about [Unsafe Swift: A road to memory](https://medium.com/swlh/unsafe-swift-a-road-to-memory-15e7d7e701f9). These writings helped me a lot to understand memory layout in Swift. 🙏

## Reference types and memory layout in Swift

I mentioned earlier that **classes** behave quite different that's because they are reference types. Let me change the `Example` type to a class and see what happens with the memory layout.

```swift
class Example {
    let bar: Bool = true // 1
    let foo: Int = 0 // 8
}

print(MemoryLayout<Example>.size)      // 8
print(MemoryLayout<Example>.stride)    // 8
print(MemoryLayout<Example>.alignment) // 8
```

What, why? We were talking about memory reserved in the [stack](https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding), until now. The **stack** memory is reserved for static memory allocation and there's an other thing called **heap** for dynamic memory allocation. We could simply say, that value types (struct, Int, Bool, Float, etc.) live in the stack and reference types (classes) are allocated in the heap, which is not 100% true. Swift is smart enough to perform additional memory optimizations, but for the sake of "simplicity" let's just stop here.

You might ask the question: [why is there a stack and a heap](https://stackoverflow.com/questions/7123936/why-is-there-a-stack-and-a-heap)? The answer is that they are quite different. The stack can be faster, because memory allocation happens using push / pop operations, but you can only add or remove items to / from it. The stack size is also limited, have you ever seen a stack overflow error? The heap allows random memory allocations and you have to make sure that you also deallocate what you've reserved. The other downside is that the allocation process has some overhead, but there is no size limitation, except the physical amount of RAM. The [stack and the heap](https://www.guru99.com/stack-vs-heap.html) is quite different, but they are both extremely useful memory storages. 👍

Back to the topic, how did we get 8 for every value (size, stride, alignment) here? We can calculate the real [size (in bytes) of an object on the heap](https://stackoverflow.com/questions/40312123/get-the-size-in-bytes-of-an-object-on-the-heap) by using the `class_getInstanceSize` method. A class always has a 16 bytes of metadata (just print the size of an empty class using the get instance size method) plus the calculated size for the instance variables.

```swift
class Empty {}
print(class_getInstanceSize(Empty.self)) // 16

class Example {
    let bar: Bool = true // 1 + 7 padding
    let foo: Int = 0     // 8
}
print(class_getInstanceSize(Example.self)) // 32 (16 + 16)
```

The memory layout of a class is always 8 byte, but the actual size that it'll take from the heap depends on the instance variable types. The other 16 byte comes from the ["is a" pointer](https://stackoverflow.com/questions/10998984/isa-pointer-in-objective-c) and the reference count. If you know about the Objective-C runtime a bit then this can sound familiar, but if not, then don't worry too much about ISA pointers for now. We'll talk about them next time. 😅

Swift uses [Automatic Reference Counting (ARC)](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html) to track and manage your app's memory usage. In most of the cases you don't have to worry about manual memory management, thanks to ARC. You just have to make sure that you don't create strong reference cycles between class instances. Fortunately those cases can be resolved easily with [weak or unowned references](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html#ID52). 🔄

```swift
class Author {
    let name: String

    /// weak reference is required to break the cycle.
    weak var post: Post?

    init(name: String) { self.name = name }
    deinit { print("Author deinit") }
}

class Post {
    let title: String
    
    /// this can be a strong reference
    var author: Author?

    init(title: String) { self.title = title }
    deinit { print("Post deinit") }
}


var author: Author? = Author(name: "John Doe")
var post: Post? = Post(title: "Lorem ipsum dolor sit amet")

post?.author = author
author?.post = post

post = nil
author = nil

/// Post deinit
/// Author deinit
```

As you can see in the example above if we don't use a weak reference then objects will reference each other strongly, this creates a reference cycle and they won't be deallocated (deinit won't be called at all) even if you set individual pointers to nil. This is a very basic example, but the real question is when do I have to use weak, unowned or strong? 🤔

I don't like to say "it depends", so instead, I'd like to point you into the right direction. If you take a closer look at the official documentation about [Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html), you'll see what captures values:

* Global functions are closures that have a name and don’t capture any values.
* Nested functions are closures that have a name and can capture values from their enclosing function.
* Closure expressions are unnamed closures written in a lightweight syntax that can capture values from their surrounding context.

As you can see [global (static functions) don't increment reference counters](https://stackoverflow.com/questions/28951324/why-is-the-weak-self-reference-in-the-uiview-animation-closure-causing-a-compila/48420485). Nested functions on the other hand will capture values, same thing applies to closure expressions and unnamed closures, but it's a bit more complicated. I'd like to recommend the following two articles to understand more about closures and capturing values:

* [You don't (always) need \[weak self\]](https://medium.com/flawless-app-stories/you-dont-always-need-weak-self-a778bec505ef)
* [Weak, strong, unowned, oh my!](https://krakendev.io/blog/weak-and-unowned-references-in-swift)

Long story short, retain cycles suck, but in most of the cases you can avoid them just by using just the right keyword. Under the hood, ARC does a great job, except a few edge cases when you have to break the cycle. Swift is a [memory-safe](https://docs.swift.org/swift-book/LanguageGuide/MemorySafety.html) programming language by design. The language ensures that every object will be initialized before you could use them, and objects living in the memory that aren't referenced anymore will be deallocated automatically. Array indices are also checked for out-of-bounds errors. This gives us an extra layer of safety, except if you write unsafe Swift code... 🤓

Anyway, in a nutshell, this is how the memory layout looks like in the Swift programming language.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
