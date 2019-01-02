> * 原文链接 : [Closures Capture Semantics, Part 1: Catch them all!](http://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/)
* 原文作者 : [Olivier Halligon](http://alisoftware.github.io/about/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Nicolas(Yifei) Li](https://github.com/yifili09) 
* 校对者: [Liz](https://github.com/lizwangying), [Gran](https://github.com/Graning)

# 深入理解 Swift 中闭包的捕捉语义（一）

即使是有 `ARC` 的今天，理解内存管理和对象的生命周期仍旧是非常重要的。当使用闭包的时候是一个特例，它在 `Swift` 中出现的场景越来越多，比起 `Objective` 的代码块的捕获规则有很多不同的捕获语法。让我们看看它们是如果工作的吧。

## 概述

在 `Swift` 中，闭包捕获了他们引用到的变量: 默认情况下，在闭包外申明的变量会被使用这些变量的闭包在内部保留，为了确保他们在闭包被执行的时候仍旧存在。

对于这篇文章的来说，让我们定义一个简单的 `Pokemon` 类，举个例子:



    class Pokemon: CustomDebugStringConvertible {
      let name: String
      init(name: String) {
        self.name = name
      }
      var debugDescription: String { return "\(name)>" }
      deinit { print("\(self) escaped!") }
    }



让我们声明一个简单的方法，它用闭包作为参数，并且过几秒后（使用 `GCD`）执行这个闭包。通过这个方法，我们用下面的这个例子来看看闭包是如何捕捉外部变量的。



    func delay(seconds: NSTimeInterval, closure: ()->()) {
      let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
      dispatch_after(time, dispatch_get_main_queue()) {
        print("🕑")
        closure()
      }
    }

ℹ️️ 在 `Swift 3` 中，上面的方法将会被这样的形式替换改写:


    func delay(seconds: Int, closure: ()->()) {
      let time = DispatchTime.now() + .seconds(seconds)
      DispatchQueue.main.after(when: time) {
        print("🕑")
        closure()
      }
    }

## 默认捕捉的语法

现在，让我们开始一个简单的例子:


    func demo1() {
      let pokemon = Pokemon(name: "Mewtwo")
      print("before closure: \(pokemon)")
      delay(1) {
        print("inside closure: \(pokemon)")
      }
      print("bye")
    }



这看上去很简单，但是有趣的是，这个闭包会在 `demo1()` 方法函数执行完成后 1 秒后被执行，并且我们已退出了方法函数的作用域... 当然 `Pokemon` 仍然是存在的，当这个代码块在下一个 1 秒后再次被执行的时候！ 


    before closure: <Pokemon Mewtwo>
    bye
    🕑
    inside closure: <Pokemon Mewtwo>
    <Pokemon Mewtwo> escaped!




这是因为这个闭包坚定地捕获了这个 `pokemon` 变量: 因为 `Swfit` 的编译器看见了这个被闭包内部引用的 `pokemon` 变量，它便自动的捕获了这个（默认情况下强捕获），所以这个 `pokemon` 是会一直存在的，只要这个闭包也存在。

所以，闭包很像 `精灵球` 😆  只要你保留~~精灵球~~在闭包周围, `pokemon` 变量也会同样在这里，但是当那个~~精灵球~~被释放了，那个被引用的 `pokemon` 变量也会被释放。

在这个例子中，当这个闭包被 `GCD` 执行后，这个闭包自行释放，就是 `Pokemon` 内部的 `init` 方法执行的时候。

ℹ️ 如果 `Swift` 并没有自动捕获到这个 `pokemon` 变量，这意味着这个 `pokemon` 必将有时间跳出这个作用域，当调用到 `demo1` 方法的尾端的时候，并且当这个闭包被下一个后 1 秒再次执行的时候，这个 `pokemon` 将不会再存在... 可能会导致一个崩溃。  
谢天谢地，`Swift` 聪明多了，并且它能为我们捕获到这个 `pokemon`。在之后的文章里，我们能看到，当我们需要他们的时候，怎么去弱捕获这些变量。

## 被捕获到的变量都被执行的时候定值

一个需要注意的至关重要的是，尽管**在 `Swift` 中，被捕获的变量在闭包被执行的时候才被定值**<sup>[1](http://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/#fn:block-modifier)</sup>. 我们能说它捕获到了这个变量的_引用_(或者 _指针_)。

所以，这里有一个有趣的例子:



    func demo2() {
      var pokemon = Pokemon(name: "Pikachu")
      print("before closure: \(pokemon)")
      delay(1) {
        print("inside closure: \(pokemon)")
      }
      pokemon = Pokemon(name: "Mewtwo")
      print("after closure: \(pokemon)")
    }



你能猜到什么会被打印出来么？这里是答案:


    before closure: <Pokemon Pikachu>
    <Pokemon Pikachu> escaped!
    after closure: <Pokemon Mewtwo>
    🕑
    inside closure: <Pokemon Mewtwo>
    <Pokemon Mewtwo> escaped!




注意，在创建了闭包_之后_，我们改变了 `pokemon` 对象，当这个闭包在 1 秒之后执行（当我们已经从 `demo2()` 函数方法作用域退出了），我们打印出了一个新的 `pokemon`，并不是先前旧的那个！这是因为，`Swift` 默认捕获到了变量的引用。

所以在这里，我们把 `pokemon` 初始化成 `Pikachu`，之后，我们把它的值改成 `Mewtwo`，所以 `Pikachu` （的引用）被释放了 - 因为再没有其他变量保留它了。1 秒钟之后，这个闭包被执行，并且它打印出了变量 `pokemon` 的内容，它是由闭包通过引用捕获的。

这个闭包并没有捕获 `Pikachu`（这个 `pokemon` 是在闭包创建的时候我们获得的），但更是对 `pokemon` 变量的引用 - 当这个闭包被执行的时候，它现在被定值为`Mewtwo`。

令人奇怪的是，这个在`值类型`中也行得通，例如 `Int`:



    func demo3() {
      var value = 42
      print("before closure: \(value)")
      delay(1) {
        print("inside closure: \(value)")
      }
      value = 1337
      print("after closure: \(value)")
    }



结果是:



    before closure: 42
    after closure: 1337
    🕑
    inside closure: 1337



是的，这个闭包打印出了_新_的 `Int` 的值 - 即使 `Int` 是一个`值类型`! - 因为它捕获了变量的引用，不是变量本身的内容。

## 你能修改在闭包内捕获的值

注意，如果捕获的值是一个 `var` （并不是一个 `let`），你还是可以修改这个值 **在闭包内部**<sup>[2](http://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/#fn:objc_block_modify)</sup>.



    func demo4() {
      var value = 42
      print("before closure: \(value)")
      delay(1) {
        print("inside closure 1, before change: \(value)")
        value = 1337
        print("inside closure 1, after change: \(value)")
      }
      delay(2) {
        print("inside closure 2: \(value)")
      }
    }



这个代码运行的结果是:


    before closure: 42
    🕑
    inside closure 1, before change: 42
    inside closure 1, after change: 1337
    🕑
    inside closure 2: 1337




所以在这里，这个 `value` 变量已经从代码块的内部被改变了（即使他被捕获了，他也并不是以一个静态拷贝捕获的，但是仍然引用了同一个变量）。并且第二个代码块看到新的值，即使它在之后被执行 - 并且当第一个代码块已经被释放的时候，它已经离开  `demo4()` 方法函数的作用域了!

## 捕获一个作为一个静态拷贝的变量

如果你想要在闭包**创建**的时候捕获变量的值，而不是仅仅当闭包执行的时候去获取它的定值，你能使用一个**捕获列表**。

**捕获列表**可以被编码在方括号的中间，在闭包开括号的右边（并且在闭包的参数 / 或者有返回值之前）<sup>[3](http://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/#fn:in-keyword)</sup>。

为了在闭包创建的时候，捕获变量的值（而不是这个变量本身的引用），你可以使用 `[localVar = varToCapture]` 捕获列表。以下是它大概的样子:



    func demo5() {
      var value = 42
      print("before closure: \(value)")
      delay(1) { [constValue = value] in
        print("inside closure: \(constValue)")
      }
      value = 1337
      print("after closure: \(value)")
    }



结果会是:


    before closure: 42
    after closure: 1337
    🕑
    inside closure: 42




与之前的 `demo3()` 的代码对比，（我们会）发现这个值可以被闭包打印出了... 是 `value` 变量的内容，在闭包被**创建的时候** - 在它被赋值为新的 `1337` 之前 - 即使这个代码块在这个新的赋值_之后_被执行。

这就是 `[constValue = value]` 在闭包里的作用: 当闭包被创建的时候，捕获 `value` 的_值_ - 并且不是这个变量本身被定值之后的引用。

## 回到 `Pokemons`

我们在上面看到的，也意味着，如果这个值是一个引用类型 - 就好像我们的 `Pokemon` 类 - 这个闭包并没有强捕获这个变量的引用，而是捕获到了一个原始实例的副本，在被捕获的时候，包含在 `pokemon` 变量中的。



    func demo6() {
      var pokemon = Pokemon(name: "Pikachu")
      print("before closure: \(pokemon)")
      delay(1) { [pokemonCopy = pokemon] in
        print("inside closure: \(pokemonCopy)")
      }
      pokemon = Pokemon(name: "Mewtwo")
      print("after closure: \(pokemon)")
    }


这就好像，如果我们创建一个中间变量去指向同一个 `pokemon`，并且捕获这个变量:


    func demo6_equivalent() {
      var pokemon = Pokemon(name: "Pikachu")
      print("before closure: \(pokemon)")
      // here we create an intermediate variable to hold the instance 
      // pointed by the variable at that point in the code:
      let pokemonCopy = pokemon
      delay(1) {
        print("inside closure: \(pokemonCopy)")
      }
      pokemon = Pokemon(name: "Mewtwo")
      print("after closure: \(pokemon)")
    }




_事实上，使用这个捕获列表和上面的代码一样... 除了这个 `pokemonCopy` 的中间变量是闭包的局部变量，并且将只能在闭包内被访问。_

和这个 `demo6()` 对比 - 它使用 `[pokemonCopy = pokemon] in ...` - 而且 `demo2()` - 它并没有，相反直接使用 `pokemon`。`demo6()` 输出了这个: 



    before closure: <Pokemon Pikachu>
    after closure: <Pokemon Mewtwo>
    <Pokemon Mewtwo> escaped!
    🕑
    inside closure: <Pokemon Pikachu>
    <Pokemon Pikachu> escaped!



以下解释了发生了什么:

* `Pikachu` 被创建了；
* 之后它通过闭包被以一个副本形式捕获（捕获了 `pokemon` 的值）
* 所以，在后面的几行代码中，我们为 `pokemon` 赋上一个新的值 `Pokemon Mewtwo`，此时 `Pikachu` _恰好_没有被释放，因为它仍被闭包保留着。
* 当我们从 `demo6` 方法函数作用域中退出，`Mewtwo` 被释放了，因为 `pokemon` 变量本身 - 它是唯一被强引用的 - 离开了作用域。
* 之后，当这个闭包被执行的时候，它打印出 `“Pikachu”`，因为，它是 `Pokemon` 在闭包被创建时候通过捕获列表捕获到的。
* 之后这个闭包被 `GCD` 释放，所以这个 `Pikachu Pokemon` 被保留着。

相反，回到上面 `demo2` 的代码: 

* `Pikachu` 被创建了；
* 之后，闭包只是捕获了对 `pokemon` 变量的**引用**，并不是真正的`Pikachu pokemon `变量包含的值。
* 所以，当 `pokemon` 之后被赋值为一个新的值 `Mewtwo`，`Pikachu`，并且立即被释放了。
* 但是这个 `pokemon` _变量_ （在那时候，保留了`Mewtwo pokemon `）仍然被闭包强引用着。
* 所以，这就是 `pokemon` 被打印出的，当闭包在 1 秒之后被执行的时候。
* 并且那个 `Mewtwo` 仅仅被释放一次，这个闭包之后被 `GCD` 释放了。

## 结合我们之前所有讨论的

所以...... 你全都掌握了么？我知道，我们到此为止已经讨论了很多了......

这是一个更加人为的例子，同时混合了执行时定值和在闭包创建时捕获的值 - 多谢捕获列表 - 和捕获变量的引用，和在闭包执行时定值:



    func demo7() {
      var pokemon = Pokemon(name: "Mew")
      print("➡️ Initial pokemon is \(pokemon)")

      delay(1) { [capturedPokemon = pokemon] in
        print("closure 1 — pokemon captured at creation time: \(capturedPokemon)")
        print("closure 1 — variable evaluated at execution time: \(pokemon)")
        pokemon = Pokemon(name: "Pikachu")
        print("closure 1 - pokemon has been now set to \(pokemon)")
      }

      pokemon = Pokemon(name: "Mewtwo")
      print("🔄 pokemon changed to \(pokemon)")

      delay(2) { [capturedPokemon = pokemon] in
        print("closure 2 — pokemon captured at creation time: \(capturedPokemon)")
        print("closure 2 — variable evaluated at execution time: \(pokemon)")
        pokemon = Pokemon(name: "Charizard")
        print("closure 2 - value has been now set to \(pokemon)")
      }
    }


你还能猜到这个的输出结果么？可能会比较难猜，但是这对你自己尝试去确认输出的内容来说是个非常好的练习，去检查你是否掌握了今天所有的课程......

![drumroll](http://ac-Myg6wSTV.clouddn.com/0c59ce77448794cf9dcc.gif)

好吧，这里就是代码的输出。你是不是正确理解了？


    ➡️ Initial pokemon is <Pokemon Mew>
    🔄 pokemon changed to <Pokemon Mewtwo>
    🕑
    closure 1 — pokemon captured at creation time: <Pokemon Mew>
    closure 1 — variable evaluated at execution time: <Pokemon Mewtwo>
    closure 1 - pokemon has been now set to <Pokemon Pikachu>
    <Pokemon Mew> escaped!
    🕑
    closure 2 — pokemon captured at creation time: <Pokemon Mewtwo>
    closure 2 — variable evaluated at execution time: <Pokemon Pikachu>
    <Pokemon Pikachu> escaped!
    closure 2 - value has been now set to <Pokemon Charizard>
    <Pokemon Mewtwo> escaped!
    <Pokemon Charizard> escaped!

所以，这里发生了什么？变得更加复杂了，让我们一步一步详细道来:

1.  ➡️ `pokemon` 在初始化的时候被设值为 `Mew`
2. 之后，1 号闭包被创建，并且 `pokemon` 的_值_被捕获成一个新的 `capturedPokemon` 变量 - 它对于闭包来说是一个局部变量（并且 `pokemon` 变量的引用也被捕获了，因为 `capturedPokemon` 和 `pokemon` 同时被闭包的代码使用）
3.  🔄  之后， `pokemon` 的值被修改为 `Mewtwo`
4. 之后，2 号闭包被创建，并且 `pokemon`的_值_（那时候还是 `Mewtwo`）被捕获成一个新的 `capturedPokemon` 变量 - 它对于闭包来说是一个局部变量（并且 `pokemon` 变量的引用也被捕获了，因为他们同时被闭包的代码使用）
5. 现在，`demo8()` 方法函数结束了。
6.  🕑  1 秒之后, GCD 开始执行第一个闭包(1 号闭包)。
    * 打印出了这个_值_ `Mew`，它在第 2 步创建闭包的时候被 `capturePokemon` 捕获
    * 它也会对当前的 `pokemon` 变量定值，通过引用捕获，它仍然是 `Mewtwo`（就和我们在第 5 步退出 `demo8()` 方法函数退出之前一样）
    * 之后，它把 `pokemon` 变量的值设定为 `Pikachu`（再一次，这个闭包捕获了一个对变量 `pokemon` 的_引用_，所以这个和 `demo8()` 中使用的变量一样，也和其他闭包一样，它为这个变量赋值。）
    * 当这个闭包完成了执行，并且被 `GCD` 释放，`Mew` 已不再被任何地方保留，所以他需要被释放。但是 `Mewtwo` 仍然被第二个闭包的 `capturedPokemon` 捕获着，并且 `Pikachu` 仍然保存在 `pokemon` 变量中，它也被第二个闭包引用着。
7.  🕑  另一个 1 秒之后，`GCD` 执行了第二个闭包（2 号闭包）。
    * 打印出了这个_值_ `Mewtwo`，它在第 4 步创建闭包的时候被 `capturedPokemon` 捕获。
    * 它也对当前的 `pokemon` 变量定值，通过引用捕获，是 `Pikachu`（因为它已经被 1 号闭包修改过了。）
    * 最后，它把 `pokemon` 变量的值设定为 `Charizard`，并且这个 `Pikachu pokemon` 只被那个 `pokemon` 变量引用，并且不在被任何人保留，所以它被释放了。
    * 当这个闭包完成了执行，并且被 `GCD` 释放，这个 `capturedPokemon` 离开了本地的作用域，所以 `Mewtwo` 也被释放了，并且 `pokemon` 变量已经不在被任何人引用，`Charizard pokemon` 也是，所以它也被释放了。

## 总结

仍然对所有的技巧感到困惑么？那很正常。闭包的捕捉语义在某种成都上说是复杂的，特别是上面的那个精心策划的例子。但是请记住下面这几点:

* `Swift` 闭包捕获了一个对外部变量需要在闭包内部使用的一个_引用_。
* 那个引用在**闭包被执行的时候获得定值**。
* 作为对这个变量的引用的捕捉（并且不是这个变量自身），**你能从闭包内部修改这个变量的值**（当然，如果这个变量被声明为 `var` 并且不是 `let`）
* **相反，你能告诉 `Swfit` 在闭包创建的时候对这个变量定值** 并且把这个_值_保存在本地的一个静态变量中，而不是捕获变量本身。你可以通过使用**捕获列表**，在括号内表达。

我会让今天的课程结束，因为它可能很难理解。请不要犹豫去尝试使用和测试这个代码，或者在代码编辑器里修改他们，让自己了清晰的理解所有的东西是怎么运作的。

一旦你更加清晰的理解这些内容，那就是时候开始这个博客的下一部分了，我们将讨论有关_弱_捕获变量，为了防止循环引用，和在闭包中，到底什么是 `[weak self]`，什么是 `[unowned self]`。

_感谢 [@merowing](https://twitter.com/merowing_)，因为和他讨论了在 `Slack` 中所有的这些捕获语义和一些有关闭包被执行时捕获变量并且为它定值的内容！ 你可以访问 [他的博客](http://merowing.info) 😉_

1. 对于知道 `Objective-C` 的读者来说，你们能注意到，`Swift` 表现得和 `Objective-C` 的默认 `block` 语法不同，但是相反，它和在 `Objective-C` 中有 `__block` 修饰符的变量很像。[↩](#fnref:block-modifier)

2. 不像 `ObjC` 默认的表现...，更像是当你正在 `Objective-C` 中使用 `__block` [↩](#fnref:objc_block_modify)

3. 请注意，即使在我们的例子中，我们仅捕获了一个变量，你还是可以在捕获列表中增加多个捕获的变量，这就是为什么它被叫做_列表_。当然，如果你没有列出闭包参数列表，你讲仍就能放置 `in` 这个关键字，在捕获列表去从闭包体内分离他们之后。[↩](#fnref:in-keyword)
