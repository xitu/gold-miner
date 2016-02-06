  - 原文链接: `Optimization Tips <https://github.com/apple/swift/blob/master/docs/OptimizationTips.rst>`_
  - 原文作者 : `apple <https://github.com/apple>`_
  - 译文出自 : `掘金翻译计划 <https://github.com/xitu/gold-miner>`_
  - 译者 : `iThreeKing <https://github.com/iThreeKing>`_
  - 校对者: `nathanwhy <https://github.com/nathanwhy>`_、`walkingway <https://github.com/walkingway>`_
  - 状态 :  完成

编写高性能的 Swift 代码
===================================

这篇文章整合了许多编写高性能的 Swift 代码的提示与技巧。文章的受众是编译器和标准库的开发者。

这篇文章中的一些技巧可以帮助提高你的 Swift 程序质量，并且可以减少代码中的容易出现的错误，使代码更具可读性。显式地标记出最终类和类的协议是两个显而易见的例子。然而，文章中描述的一些技巧是不符合规定的，扭曲的，仅仅解决由于编译器或者语言暂时限制的问题。文章中的建议来自多方面的权衡，例如程序运行时，二进制大小，代码可读性等等。


启用优化
======================

每个人应该做的第一件事是启用优化。 Swift 提供了三种不同的优化级别：

- ``-Onone``: 这是为正常开发准备，它执行最少的优化并保留所有调试的信息。
- ``-O``: 是为大多数生产代码准备，编译器执行积极的优化，可以很大程度上改变提交代码的类型和数量。调试信息同样会被输出，但是有损耗。
- ``-Ounchecked``: 这个是特定的优化模式，为了特定的库或应用程序，舍弃安全性来提高性能。编译器将移除所有溢出检查以及一些隐式类型检查。由于这样会导致未被发现的存储安全问题和整数溢出，所以一般情况下并不会使用这种模式。仅使用于你已经仔细审查了自己的代码对于整数溢出和类型转换是友好的情况下。

在 Xcode UI 中，人们可以按照下面修改当前优化级别：

...


优化整个组件
==========================

默认情况下 Swift 单独编译每个文件。这使得 Xcode 可以非常快速的并行编译多个文件。然而，分开编译每个文件可以阻止某些编译器优化。 Swift 也可以把整个程序看做一个文件来编译，并把程序当成单个编译单元来优化。这个模式可以使用命令行 ``-whole-module-optimization`` 来启用。在这种模式下程序需要花费更长的时间来编译，但运行起来却更快。

这个模式可以通过 Xcode 构建设置中的'Whole Module Optimization'来启用。


降低动态调度 (Reducing Dynamic Dispatch)
=========================

在默认情况下， Swift 是一个类似 Objective-C 的动态语言。与 Objective-C 不同的是，程序员在必要的时候可移除或减少 Swift 这种动态特性，从而提高运行时性能。本节将提供几个能够被用于操作语言结构的例子。

动态调度
----------------

在默认情况下，类使用动态调度的方法和属性访问。因此在下面的代码片段中， ``a.aProperty``, ``a.doSomething()`` 和
``a.doSomethingElse()`` 都将通过动态调度来调用:

::

  class A {
    var aProperty: [Int]
    func doSomething() { ... }
    dynamic doSomethingElse() { ... }
  }

  class B : A {
    override var aProperty {
      get { ... }
      set { ... }
    }

    override func doSomething() { ... }
  }

  func usingAnA(a: A) {
    a.doSomething()
    a.aProperty = ...
  }

在 Swift 中，动态调度默认通过一个 vtable [1]_ （虚函数表）间接调用。如果使用 ``dynamic`` 关键字声明, Swift 的调用方式将变为：『通过 Objective-C 的消息传递机制 』。在上面这两种情况下，后者『通过 Objective-C 的消息传递』要比直接进行函数调用慢，因为他阻止了编译器的很多优化 [2]_ ，除了自身的间接调用开销。在性能优先的代码中，人们常常想限制这种动态行为。

建议：当你在声明时知道不会被重写时使用 'final'
--------------------------------------------------------------------------------

``final`` 关键字是类、方法或属性声明中的限制，从而让声明不被重写。这就意味着编译器可以使用直接函数调用代替间接函数调用。例如下面的 ``C.array1`` 和 ``D.array1`` 将会被直接访问 [3]_ 。与之相反， ``D.array2`` 将通过一个虚函数表访问：

::

  final class C {
    // 类'C'中没有声明可以被重写
    var array1: [Int]
    func doSomething() { ... }
  }

  class D {
    final var array1 [Int] //'array1'不可以被计算属性重写
    var array2: [Int]      //'array2'*可以*被计算属性重写
  }

  func usingC(c: C) {
     c.array1[i] = ... //可以直接使用C.array而不用通过动态调用
     c.doSomething() = ... //可以直接调用C.doSomething而不用通过虚函数表访问
  }

  func usingD(d: D) {
     d.array1[i] = ... //可以直接使用D.array1而不用通过动态调用
     d.array2[i] = ... //将通过动态调用使用D.array2
  }

建议：当声明不需要被文件外部访问到的时候，使用'private'
-----------------------------------------------------------------------------------

在声明中使用 ``private`` 关键字，会限制对其声明文件的可见性。这会让编译器能查出所有其它潜在的重写声明。因此，由于没有了这样的声明，编译器就可以自动推断出 ``final`` 关键字，并移除间接的方法调用和域访问。例如下面，假设在同一文件中 ``E`` , ``F`` 并没有任何重写声明，那么 ``e.doSomething()`` 和 ``f.myPrivateVar`` 将可以被直接访问：

::

  private class E {
    func doSomething() { ... }
  }

  class F {
    private var myPrivateVar : Int
  }

  func usingE(e: E) {
    e.doSomething() // 文件中没有替代类来声明这个类
                    // 编译器可以移除 doSomething() 的虚拟调用
                    // 并直接调用类 E 的 doSomething 方法
  }

  func usingF(f: F) -> Int {
    return f.myPrivateVar
  }

高效地使用容器类型
=================================

通用的容器 Array 和 Dictionary 是 Swift 标准库提供的一个重要特性。本节将解释如何用高性能方式使用这些类型。

建议：在数组中使用值类型
--------------------------------

在 Swift 中，类型可以分为不同的两类：值类型（结构体，枚举，元组）和引用类型（类）。一个关键的差别就是 NSArray 中不能含有值类型。因此当使用值类型时，优化器就不需要去处理对 NSArray 的支持，从而可以在数组上省去大部分的消耗。

此外，相比引用类型，如果值类型递归地包含引用类型，那么值类型仅需要引用计数器。使用不含引用类型的值类型，就可以避免额外的开销（数组内的元素执行 retain、release 操作所产生的通讯量）。

::

  // 这里不要使用类
  struct PhonebookEntry {
    var name : String
    var number : [Int]
  }

  var a : [PhonebookEntry]

牢记在使用大的值类型和引用类型之间要做好权衡。在某些情况下，拷贝和移动大的值类型消耗要大于移除桥接和保留/释放的消耗。

建议：当 NSArray 桥接不必要时，使用 ContiguousArray 存储引用类型
-------------------------------------------------------------------------------------

如果你需要一个引用类型的数组，并且数组不需要被桥接到 NSArray ，使用 ContiguousArray 代替 Array 。

::

  class C { ... }
  var a: ContiguousArray<C> = [C(...), C(...), ..., C(...)]

建议：使用就地转变而不是对象的再分配
-----------------------------------------------------------

在 Swift 中，所有的标准库容器都是值类型，使用 COW(copy-on-write) [4]_ 机制执行拷贝以代替直接拷贝。在很多情况下，通过保持容器的引用而不是执行深度拷贝能够让编译器节省不必要的拷贝。如果容器的引用计数大于1并且容器发生转变，这将只通过拷贝底层容器实现。例如下面的情况，当 ``d`` 被分配给 ``c`` 时不进行拷贝，但当 ``d`` 通过结构的改变附加到 ``2``，那么 ``d`` 就会被拷贝，然后 ``2`` 就会被附加到 ``d``：

::

  var c: [Int] = [ ... ]
  var d = c        //这里没有拷贝
  d.append(2)      //这里*有*拷贝

如果用户不小心，有时 COW 机制会引起额外的拷贝。例如，在函数中，试图通过对象的再分配执行修改操作。在 Swift 中，所有的参数传递时都会被拷贝，例如，参数在调用之前会保留，然后在调用结束时会释放。也就是像下面的函数：

::

  func append_one(a: [Int]) -> [Int] {
    a.append(1)
    return a
  }

  var a = [1, 2, 3]
  a = append_one(a)

尽管 ``a`` （一开始未执行 append 操作）在 ``append_one`` 之后也没有使用，但仍然可能会被拷贝 [5]_ 。这可以通过使用参数 ``inout`` 来避免：

::

  func append_one_in_place(inout a: [Int]) {
    a.append(1)
  }

  var a = [1, 2, 3]
  append_one_in_place(&a)

未检查操作
====================

在执行普通的整数运算时，Swift 会检查运算结果是否溢出，从而消除 bug。然而在已知没有内存安全问题发生的高性能代码中，这样的检查是不合适的。

建议：如果你知道不会发生溢出时，使用未检查整型计算
---------------------------------------------------------------------------------------

在性能优先的代码中，如果你知道代码是安全的，那么你可以忽略溢出检查。

::

  a : [Int]
  b : [Int]
  c : [Int]

  //前提：对于所有的 a[i], b[i],a[i] + b[i]都不会溢出！
  for i in 0 ... n {
    c[i] = a[i] &+ b[i]
  }

泛型
========

Swift通过使用泛型类型，提供了一种十分强大的抽象机制。 Swift 编译器发出一个具体的代码块，从而可以对任何 ``T`` 执行 ``MySwiftFunc<T>``。生成的代码需要一个函数指针表和一个包含 ``T`` 的封装作为额外参数。通过传递不同的函数指针表及封装提供的抽象大小，从而来说明 ``MySwiftFunc<Int>`` 和 ``MySwiftFunc<String>`` 之间的不同行为。一个泛型的例子：

::

  class MySwiftFunc<T> { ... }

  MySwiftFunc<Int> X    // 将通过 Int 类型传递代码
  MySwiftFunc<String> Y // 此处为 String 类型

当启用优化时， Swift 编译器查看每段调用的代码，并试着查明其中具体使用的类型(例如:非泛型类型)。如果泛型函数定义对优化器可见，并且具体类型已知，那么 Swift 编译器将产生一个具有特殊类型的特殊泛型函数。这一过程被称作 *特殊化*，从而可以避免与泛型关联的消耗。一些泛型的例子：

::

  class MyStack<T> {
    func push(element: T) { ... }
    func pop() -> T { ... }
  }

  func myAlgorithm(a: [T], length: Int) { ... }

  //编译器可以特殊化 MyStack[Int] 的代码
  var stackOfInts: MyStack[Int]
  //使用整型类型的栈
  for i in ... {
    stack.push(...)
    stack.pop(...)
  }

  var arrayOfInts: [Int]
  //编译器可以为目标为 [Int] 的 myAlgorithm 函数执行一个特殊化版本

  myAlgorithm(arrayOfInts, arrayOfInts.length)

建议：将泛型声明放在使用它的文件中
---------------------------------------------------------------------

只有泛型声明在当前模块可见，优化器才能进行特殊化。这样只发生在使用泛型和声明泛型在同一个文件中的情况下。*注意*标准库是一个例外。在标准库中声明泛型，可以对所有模块可见且进行特殊化。

建议：允许编译器进行泛型特殊化
------------------------------------------------------------

只有调用和被调用函数位于同一编译单元，编译器才能够对泛型代码进行特殊化。我们可以使用一个技巧让编译器对被调用函数进行优化，就是在被调用函数的编译单元中执行类型检查代码。进行类型检查的代码会被重新发送来调用泛型函数---但是这样做会包含类型信息。在下面的代码中，我们在函数"play_a_game"中插入类型检查，使代码运行速度提高了几百倍。

::

  //Framework.swift:

  protocol Pingable { func ping() -> Self }
  protocol Playable { func play() }

  extension Int : Pingable {
    func ping() -> Int { return self + 1 }
  }

  class Game<T : Pingable> : Playable {
    var t : T

    init (_ v : T) {t = v}

    func play() {
      for _ in 0...100_000_000 { t = t.ping() }
    }
  }

  func play_a_game(game : Playable ) {
    //这个检查允许优化器对泛型函数'play'进行特殊化

    if let z = game as? Game<Int> {
      z.play()
    } else {
      game.play()
    }
  }

  /// -------------- >8

  // Application.swift:

  play_a_game(Game(10))


 Swift 中大的值类型的开销
==============================

在 Swift 中，值保留有一份独有的数据拷贝。使用值类型有很多优点，比如能保证值具有独立的状态。当我们拷贝值时(等同于分配，初始化和参数传递)，程序将会创建一份新的拷贝。对于一些大的值类型，这样的拷贝是相当耗时的，也可能会影响到程序的性能。

.. 更多关于值类型的知识:
.. https://developer.apple.com/swift/blog/?id=10

考虑下面的代码，代码中使用'值'类型的节点定义了一棵树。树的节点包括其它使用协议的节点。计算机图形场景通常由不同的实体和变形体构成，而他们都能表示为值的形式，所以这个例子很有实际意义。

.. 查看面向协议编程:
.. https://developer.apple.com/videos/play/wwdc2015-408/

::

  protocol P {}
  struct Node : P {
    var left, right : P?
  }

  struct Tree {
    var node : P?
    init() { ... }
  }


当树进行拷贝(传递参数，初始化或者赋值操作)，整棵树都要被拷贝。这是一个花销很大的操作，需要调用很多 malloc/free (分配/释放)以及大量引用计数操作。

然而，我们并不是真的关心值是否被拷贝，只要这些值还保留在内存中。

建议：对大的值类型使用 copy-on-write 机制
----------------------------------------------------

减少拷贝大的值类型的开销，可以采用 copy-on-write 的方法。实现 copy-on-write 机制最简单的办法就是采用已经存在的 copy-on-write 的数据结构，比如数组。 Swift 的数组是值类型，因为它具有 copy-on-write 的特性，所以当数组作为参数被传递时，并不需要每次都进行拷贝。

在我们'树'的例子中，通过将树中的内容封装到数组中，从而减少拷贝带来的开销。通过这一简单的改变就能极大地提示我们树的数据结构性能，数组作为参数传递的开销从 O(n) 降到了 O(1) 。

::

  struct Tree : P {
    var node : [P?]
    init() {
      node = [ thing ]
    }
  }


使用数组来实现 COW 机制有两个明显的缺点。第一个问题就是数组中类似"append"和"count"的方法，它们在值封装中没有任何作用。这些方法让引用封装变得很不方便。我们可以通过创建一个隐藏未用到的 API 的封装结构来解决这个问题，并且优化器会移除它的开销，但是这样的封装并不能解决第二个问题。第二个问题就是数组内存在保证程序安全性和与 Objective-C 进行交互的代码， Swift 会检查索引访问是否在数组边界内，以及保存值时会判断数组存储时否需要扩展存储空间。这些操作运行时都会降低程序速度。

一个替代方法就是实现一个 copy-on-write 机制的数据结构来代替数组作为值封装。下面的例子就是介绍如何构建一个这样的数据结构：

.. Note: 这样的解决办法，对于嵌套结构并非最优，并且一个基于 COW 数据结构的 addressor 会更加高效。然而在这种情况下，抛开标准库执行 addressor 是行不通的。

.. 更多细节详见 Mike Ash 的博文:
.. https://www.mikeash.com/pyblog/friday-qa-2015-04-17-lets-build-swiftarray.html

::

  final class Ref<T> {
    var val : T
    init(_ v : T) {val = v}
  }

  struct Box<T> {
      var ref : Ref<T>
      init(_ x : T) { ref = Ref(x) }

      var value: T {
          get { return ref.val }
          set {
            if (!isUniquelyReferencedNonObjC(&ref)) {
              ref = Ref(newValue)
              return
            }
            ref.val = newValue
          }
      }
  }

``Box`` 类型可以代替上个例子中的数组。

不安全的代码
===========

 Swift 中类总是采用引用计数。 Swift 编译器会在每次对象被访问时插入增加引用计数的代码。例如，考虑一个通过使用类实现遍历链表的例子。遍历链表是通过从一个节点到下一个节点移动引用实现： ``elem = elem.next``。每次我们移动这个引用， Swift 将会增加 ``next`` 对象的引用计数，并且减少前一个对象的引用计数。这样的引用计数方法成本很高，但只要我们使用 Swift 的类就无法避免。

::

  final class Node {
   var next: Node?
   var data: Int
   ...
  }


建议：使用非托管的引用来避免引用计数带来的开销
---------------------------------------------------------------------

在性能优先代码中，你可以选择使用未托管的引用。其中 ``Unmanaged<T>`` 结构体就允许开发者关闭对于特殊引用的自动引用计数 (ARC) 功能。

::

    var Ref : Unmanaged<Node> = Unmanaged.passUnretained(Head)

    while let Next = Ref.takeUnretainedValue().next {
      ...
      Ref = Unmanaged.passUnretained(Next)
    }


协议
=========

建议：标记只能由类实现的协议为类协议
----------------------------------------------------------------------------

 Swift 可以限定协议只能通过类实现。标记协议只能由类实现的一个优点就是，编译器可以基于只有类实现协议这一事实来优化程序。例如，如果 ARC 内存管理系统知道正在处理类对象，那么就能够简单的保留(增加对象的引用计数)它。如果编译器不知道这一事实，它就不得不假设结构体也可以实现协议，那么就需要准备保留或者释放不可忽视的结构体，这样做的代价很高。

如果限定只能由类实现某个协议，那么就需要标记类实现的协议为类协议，以便获得更好的运行性能。

::

  protocol Pingable : class { func ping() -> Int }

.. https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html



脚注
=========

.. [1]  虚拟方法表或者'vtable'是一种被包含类型方法地址实例引用的类型特定表。动态分发执行时，首先要从对象中查找这张表，然后在表中查找方法。

.. [2]  这是因为编译器不知道具体哪个函数被调用。

.. [3]  例如，直接加载类域或者直接调用函数。

.. [4]  解释 COW 是什么。

.. [5]  在某些情况下，优化器能够通过直接插入和 ARC 优化，来移除保持的引用、这种释放确保拷贝不会发生。
