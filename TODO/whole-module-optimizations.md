> * 原文地址：[Whole-Module Optimization in Swift 3](https://swift.org/blog/whole-module-optimizations/)
* 原文作者：[Erik Eckstein](https://github.com/eeckstein/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Edison Hsu](https://github.com/Edison-Hsu)
* 校对者：[冯志浩](https://github.com/fengzhihao123) [王子建](https://github.com/Romeo0906)

# Swift 3 语言中的全模块优化




全模块优化是一种 Swift 编译器的优化模式。全模块优化的性能提升很大程度上因项目而异，可达到 2 倍甚至 5 倍的提升。 

开启全模块优化可以使用 `-whole-module-optimization` （或者 `-wmo`）编译器标识，并且在 Xcode 8 中默认在新项目中被打开。另外 Swift 的包管理器在发布构建中使用全模块优化编译。 

那么它是关于什么的？让我们先看看没有全模块优化编译器是如何工作的。

### 什么是模块和如何编译模块

一个模块是 Swift 文件的集合。每个模块编译成一个独立分布单元－框架（framework)或可执行程序。在单文件编译（没有 `-wmo`）中，Swift 编译器分别编译模块中的每一个文件。事实上，这就是背后发生的事情。作为一个使用者你不需要手动做这些。编译器驱动或者 Xcode 构建系统会自动完成。

![single file compilation](https://swift.org/assets/images/wmo-blog/single-file.png)

在读取和解析一个源文件（并且完成其他工作，比如类型检查）之后，编译器开始优化 Swift 代码，生成机器码和写目标文件。最终，链接器链接所有目标文件并且生成共享库或者可执行文件。

在单文件编译中编译器的优化仅局限于单个文件。这限制了跨函数优化，比如调用和定义在同一文件中的函数内联或者泛型特殊化。

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



当编译器优化 main.swift 时，它并不知道 `getElement` 如何被实现。它只知道它是存在的。所以编译器生成了一个 `getElement` 的调用。另一个方面，当编译器优化 utils.swift 时，它并不知道函数被调用了哪个具体的类型。所以它只能生成一个通用版本的函数，这比具体类型特殊化过的代码慢很多。

即使简单的在 `getElement` 中返回声明，都需要在类型的元数据中查找来解决如何拷贝元素。它可以是一个简单的 `Int`，但它也可以是一个更大的类型，甚至涉及一些引用计数操作。这些编译器都不知道。

### 全模块优化

拥有全模块优化的编译器可以做的好很多。当使用 `-wmo` 选项编译时，编译器将模块作为一个整体来优化其中的所有文件。

![whole-module compilation](https://swift.org/assets/images/wmo-blog/wmo.png)

这么做有两个巨大优势。首先，编译器了解模块中所有函数的实现，所以它能够执行诸如函数内联和函数特殊化等优化。函数特殊化是指编译器创建一个新版本的函数，这个函数通过一个特定的调用上下文来优化性能。例如，编译器能够针对各种具体类型对泛型函数进行特殊化处理。

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



这个编译仅生成几个机器指令。对比单文件代码有很大的不同，单文件编译中会两次调用 `getElement` 泛型函数。

跨文件的函数特殊化和函数内联仅是全模块优化的例子。如果编译器了解函数的实现，即使编译器决定不内联一个函数，它也有很大帮助。举例说，它能推出它的引用计数操作的行为。有了这个认识，编译器就能够在函数调用中删除冗余的引用计数操作。

全模块优化的第二大好处是，编译器能够推出所有非公有（non-public）函数的使用。非公有函数仅能在模块内部调用，所以编译器能够确定这些函数的所有引用。那么编译器可以用这个信息做什么？

一个非常基本的优化是消除所谓的「死」函数和方法。这些函数和方法是从未被调用和使用的。使用全模块优化，编译器知道一个非公有函数或方法是否根本没有被使用，如果是这种情况，那么编译器会除去它。为什么程序员会写一个从未被使用的函数？好吧，这不是死函数消除的最重要用例。常用函数变为死函数是其他优化的一个副作用。

我们假设 `add` 函数只在 `Container.getElement` 中被调用。在内联 `getElement` 之后，这个函数不在被使用，所以它可以被删除。即使编译器决定不内联 `getElement`，编译器也能删除原始 `getElement` 的泛型版本，因为 `add` 函数只调用特殊化的版本。

### 编译时间

单文件编译时，编译器驱动在不同的进程中开始编译每个文件，这能被并行地完成。此外，自从上次编译之后没有被修改的文件就不需要重新编译（假设所有依赖也没有修改）。这被称为增式编译。它节省了大量的编译时间，尤其是当你做了一个小改动的时候。在全模块编译中如何使这个成为可能？让我们来看看全模块优化模式更多的细节。

![whole-module compilation details](https://swift.org/assets/images/wmo-blog/wmo-detail.png)

编译过程有多个阶段：分析程序，类型检查，SIL 优化，LLVM 后端。

大多数情况下，分析程序和类型检查是非常快的，并且我们希望它们在后续的 Swift 发行版中变得更快。SIL 优化程序（SIL 代表 「Swift 中间语言」（Swift Intermediate Language））执行所有 Swift 特定的重要优化，例如泛型特殊化，函数内联等等。编译器的这个阶段通常需要大约三分之一的编译时间。大多数的编译时间花费在 LLVM 后端，它执行更底层的优化和生成代码。

执行全模块优化之后，在 SIL 优化程序中模块被分为多个部分。LLVM 后端使用多线程处理各个部分。如果这个部分自从上次构建以来未被修改，它也会避免重复处理。所以即使使用全模块优化，编译器也能够并行和增量地执行大型编译工作。

### 结论

全模块优化是一个不用担心如何分配模块中的 Swift 代码也能够得到极大的性能提升的方法，而且。如果上述优化能够在关键代码段执行，性能能够比单文件编译提高 5 倍。并且相比于传统的庞大的全程序优化方法，你能够得到更快的编译时间。



