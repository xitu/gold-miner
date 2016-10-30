> * 原文地址：[Whole-Module Optimization in Swift 3](https://swift.org/blog/whole-module-optimizations/)
* 原文作者：[Erik Eckstein](https://github.com/eeckstein/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Edison Hsu](https://github.com/Edison-Hsu)
* 校对者：

# Swift 3 语言中的全模块优化




全模块优化是一种 Swfit 编译器的优化模式。全模块优化性能的提升很大程度上取决于这个项目，但是它能达到 2 倍甚至 5 倍的提升。 

开启全模块优化可以使用 `-whole-module-optimization` （或者 `-wmo`）标识，并且在 Xcode 8 中默认在新项目中被打开。另外 Swfit 的包管理器在发布构建中使用全模块优化编译。 

那么它是关于什么的？让我们先看看没有全模块优化编译器是如何工作的。

### 如何编译模块

一个模块是 Swift 文件的集合。每个模块编译下至一个独立分布单元－一个框架（framework)或一个可执行程序。在单文件编译（没有 `-wmo`）中，Swift 编译器分别编译模块中的每一个文件。事实上，这就是幕后发生的事情。作为一个使用者你不需要手动做这些。编译器驱动或者 Xcode 构建系统会自动完成。

![single file compilation](https://swift.org/assets/images/wmo-blog/single-file.png)

在读取和处理一个源文件（并且完成其他工作，比如类型检查）之后，编译器开始优化 Swift 代码，生成机器码和写目标文件。最终，链接器结合所有目标文件并且生成共享库或者可执行文件。

在单文件编译中编译器的优化作用于仅局限于一个文件。这限制了跨函数优化，比如函数内联或者泛型特殊化，调用和定义在同一文件中的函数。

下面看一个例子。假设我们模块中的一个文件，名为 utils.swift，其中包含一个泛型的实用数据结构体 `Container`，其中含有一个方法 `getElement` 并且这个方法在模块中到处被调用，比如在 main.swift 中。

main.swift:



    func add (c1: Container, c2: Container) -> Int {
      return c1.getElement() + c2.getElement()
    }



utils.swift:



    struct Container {
      var element: T

      func getElement() -> T {
        return element
      }
    }



当编译器优化 main.swift 时，它并不知道 `getElement` 如何被实现。它只知道它是存在的。所以编译器生成了一个 `getElement` 的调用。另一个方面，当编译器优化 utils.swift 时，它并不知道函数被调用了哪个具体的类型。所以它只能生成一个通用版本的函数，这个函数比专注于具体类型的代码慢很多。

即使简单的在 `getElement` 中返回声明，都需要在类型的元数据中查找来解决如何拷贝元素。它可以是一个简单的 `Int`，但它也可以是一个更大的类型，甚至涉及一些引用计数操作。这些编译器都不知道。

### 全模块优化

拥有全模块优化的编译器可以做的好很多。当使用 `-wmo` 项目编译时，编译器将模块作为一个整体来优化其中的所有文件。

![whole-module compilation](https://swift.org/assets/images/wmo-blog/wmo.png)

这么做有两个巨大优势。首先，编译器了解模块中所有函数的实现，所以它能够实行诸如函数内联和函数特殊化的优化。函数特殊化是指编译器创建一个新版本的函数，这个函数通过一个特定的调用上下文来优化性能。例如，编译器能够通过具体的类型特殊化一个泛型函数。

在我们的例子中，编译器产生了一个使用具体类型 `Int` 来特殊化泛型 `Container` 的版本。



    struct Container {
      var element: Int

      func getElement() -> Int {
        return element
      }
    }



然后编译器可以在 `add` 函数中内联已经特殊化的 `getElement` 函数。



    func add (c1: Container, c2: Container) -> Int {
      return c1.element + c2.element
    }



这个编译仅涉及几个机器指令。对比单文件代码有很大的不同，我们有两个调用 `getElement` 泛型函数。

跨文件的函数特殊化和函数内联仅是全模块优化的例子。如果编译器了解函数的实现，即使编译器决定不内联一个函数，它也有很大帮助。举例说，它能推出它的引用计数操作的行为。有了这个认识，编译器就能够在函数调用中删除冗余的引用计数操作。

全模块优化的第二大好处是，编译器能够推出所有非公有（non-public）函数的使用。非公有函数仅能在模块中被使用，所以编译器确认了解这些函数的所有引用。那么编译器可以用这个信息做什么？

One very basic optimization is the elimination of so called “dead” functions and methods. These are functions and methods which are never called or otherwise used. With whole-module optimizations the compiler knows if a non-public function or method is not used at all, and if that’s the case it can eliminate it. So why would a programmer write a function, which is not used at all? Well, this is not the most important use case for dead function elimination. Often functions become dead as a side-effect of other optimizations.

Let’s assume that the `add` function is the only place where `Container.getElement` is called. After inlining `getElement`, this function is not used anymore, so it can be removed. Even if the compiler decides to not inline `getElement`, the compiler can remove the original generic version of `getElement`, because the `add` function only calls the specialized version.

### Compile time

With single-file compilation the compiler driver starts the compilation for each file in a separate process, which can be done in parallel. Also, files which were not modified since the last compilation don’t need to be recompiled (assuming all dependencies are also unmodified). That’s called incremental compilation. All this saves a lot of compile time, especially if you only make a small change. How does this work in whole-module compilation? Let’s look at how the compiler works in whole-module optimization mode in more detail.

![whole-module compilation details](https://swift.org/assets/images/wmo-blog/wmo-detail.png)

Internally the compiler runs in multiple phases: parser, type checking, SIL optimizations, LLVM backend.

Parsing and type checking is very fast in most cases, and we expect it to get even faster in subsequent Swift releases. The SIL optimizer (SIL stands for “Swift Intermediate Language”) performs all the important Swift-specific optimizations, like generic specialization, function inlining, etc. This phase of the compiler typically takes about one third of the compilation time. Most of the compilation time is consumed by the LLVM backend which runs lower-level optimizations and does the code generation.

After performing whole-module optimizations in the SIL optimizer the module is split again into multiple parts. The LLVM backend processes the split parts in multiple threads. It also avoids re-processing of a part if that part didn’t change since the previous build. So even with whole-module optimizations, the compiler is able to perform a big part of the compilation work in parallel (multi-threaded) and incrementally.

### Conclusion

Whole-module optimization is a great way to get maximum performance without having to worry about how to distribute Swift code across files in a module. If optimizations, like described above, kick in at a critical code section, performance can be up to five times better than with single-file compilation. And you get this high performance with much better compile times than typical to monolithic whole-program optimization approaches.



