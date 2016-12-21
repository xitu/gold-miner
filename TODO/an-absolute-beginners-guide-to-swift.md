> * 原文链接: [Absolute Beginner's Guide to Swift](http://blog.teamtreehouse.com/an-absolute-beginners-guide-to-swift)
* 原文作者 : [Amit Bijlani](http://blog.teamtreehouse.com/author/amitbijlani)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [cdpath](https://github.com/cdpath)
* 校对者 : [Zhangjd (达仔(*/ω＼*))](https://github.com/Zhangjd)、[CaesarPan (Caesar)](https://github.com/CaesarPan)
* 状态 : 完成
* 说明 : 注释皆为译者注

# Swift 新手指南

**更新:** 我们高兴地宣布 Treehouse 已经发布了[学习 Swift 教程](http://teamtreehouse.com/learn-swift "Learn Swift on Treehouse")！快来学习 Swift 基础知识， Swift 函数并用 Swift 构建两个真正的 App吧。 [了解详情](http://teamtreehouse.com/learn-swift "Learn Swift on Treehouse")。

## 为什么选择 Swift？

如果你没听过 Swift，这里简单介绍一下。Apple 刚刚为 iOS 和 OSX 开发者带来了全新的 Swift 语言。我们知道 Apple 自 2010 年开始开发 Swift ，距第一个 SDK [^1: iPhone OS 1.x: SDK]发布已有两年。Apple 认识到了 Objective-C 的局限性，毕竟它已有 30 年的历史，是时候作出改变了。但是以 Apple 的风格，发布一个半成品语言不可想象的。Apple 认为尽管 Objective-C 有不少缺点，依然可以将其利用到极致，Apple 做到了。

在第一个 SDK 发布后的六年里，有 120 万个 App 提交到了 App Store。数百万的程序员领略了 Objective-C 语法的晦涩难懂并认识到了其局限性。最近有几个直言不讳的家伙决定站出来[大胆](http://ashfurrow.com/blog/we-need-to-replace-objective-c)[表达](http://informalprotocol.com/2014/02/replacing-cocoa/)他们对这一过时语言的困扰。

Swift 是众多热爱打磨新语言的聪明人历时四年多的杰作。他们到处寻求灵感，不仅仅发明了这门新语言还创造了相关工具让其易于学习。

谈到 Swift 之时，Apple 提到了三点重要考量：安全，现代，强大。Swift 名符其实。下文概括了一些上手 Swift 所必备的基础知识。如果已了解一门编程语言，你会在 Swift 上看到许多其他现代编程语言的影子。你或许会问为什么一定要重新发明一门语言，这已经超出本文的范畴，我们会在其他博文中讨论。

## 用 Swift

首先，下载并安装 [Xcode](https://developer.apple.com/devcenter/ios/index.action)。搞定之后，打开 Xcode，在菜单栏依次点击：File -> New -> 在左侧选择来源（iOS 或 OSX 都可以） -> Playground。给 Playground 起个名字就可以开始啦。

要不然就打开终端使用 REPL（读取﹣求值﹣输出循环）。

**使用终端指导**

1\. 打开终端

2\. 如果装有多个版本的 Xcode，请将 Xcode 6[^2: 最新版为 Xcode 7] 设置为默认版本。如果只有 Xcode 6 直接跳到第三步，不然就输入下面这行：

`sudo xcode-select -s /Applications/Xcode6-Beta.app/Contents/Developer/`

在撰写本文时 Xcode 6 的 beta 版叫做“Xcode6-Beta”。在用 `xcode-select` 的时候务必去“应用程序”文件夹下检查一下 Xcode 的名字。

3\. 要开启 REPL，输入：

`xcrun swift`

## 基础

### 变量

和其他编程语言一样，Swift 使用变量存储数据。要声明一个变量，必须显式使用 `var` 关键字。

    var greeting: String = "Hello World"

上述代码告诉系统你想要创建一个名为 `greeting` 的变量，`String` 类型，内容是 “Hello World” 文本。

如果将字符串赋值给变量，Swift 会聪明地推断出变量应该是字符串类型的。所以上例不用显式地指定变量类型。所以上例最好写成：

    var greeting = "Hello World" // 推断为字符串类型

变量一经创建就可以修改，所以可以给 `greeting` 变量再加上一行，做出修改：

    var greeting = "Hello World" // 推断为字符串类型
    
    greeting = "Hello Swift"

写应用程序时经常会遇到一旦将变量初始化就不再修改它的场景。Apple 设计了两种类型：可变的和不可变的。「可变」意味着变量可被修改，「不可变」则不可修改。默认情况下都是「不可变」的，这意味着值不会改变，由此 App 可以在多线程环境下更快更安全地运行。要创建不可变的常量请使用关键字 `let`。

如果将上面 greeting 例子中的 `var` 修改为 `let`，第二行会报编译器错误，因为不能修改 `greeting`。

    let greeting = "Hello World"
    greeting = "Hello Swift" //编辑器错误

再举一个例子说明为什么使用以及何时应该使用 `let`。

    let languageName: String = "Swift"

    var version: Double = 1.0

    let introduced: Int = 2014

    let isAwesome: Bool = true

上述代码不仅展示了 Swift 支持的多种类型，还道出了使用 `let` 的原因。除了 Swift 的版本号[^3: 即 `version` 变量]，其他都是常量。你或许会争辩说 `isAwesome` 是否是常数存在争议，但是读完本文你就会同意我的结论。

因为类型可以推断出来，可以简写如下：

    let languageName = "Swift" // 推断为字符串类型

    var version = 1.0 // 推断为 Double 型

    let introduced = 2014 // 推断为 Int 型

    let isAwesome = true // 推断为 Bool 型

### 字符串

上面的例子用到了字符串类型。接下来我们看看如何用 `+` 操作符来拼接两个字符串。

    let title = "An Absolute Beginners Guide to Swift"
    let review = "Is Awesome!"
    let description = title + " - " + review
    // description = "An Absolute Beginners Guide to Swift - Is Awesome!"

字符串具有强大的字符串插值特性，可以用变量来创建字符串。

    let datePublished = "June 9th, 2014"

    let postMeta = "Blog Post published on: \(datePublished)"

    // postMeta = "Blog Post published on: June 9th, 2014"

上述所有例子使用的都是 `let`，也就是说这些字符串创建之后不可修改。当然如果需要修改字符串，那么用 `var` 关键字就好了。

### 其他类型

除字符串类型以外，还有 `Int` 表示整数，`Double` 和 `Float` 表示浮点数以及`Bool` 表示布尔值（比如真或假）。这些类型都可以跟字符串类型一样通过类型推导自动得到，所以创建变量时没有必要显式写出类型。

`Float` 和 `Double` 的区别在于精度不同，能存储的最大数字也不同。

*   Float：代表 32位 浮点型数字，精度只有 6 位十进制数字。
*   Double：代表 64位 浮点型数字，精度可达 15 位十进制数字。

默认情况下浮点数会被推断为 `Double` 类型。

    var version = 1.0 // 推断为 Double 型

当然也可以显式声明为 `Float` 型。

    var version: Float = 1.0

## 集合类型

### 数组

集合类型有两种。第一种是数组类型，也就是可以通过从 0 开始的索引访问的数据元素的集合。

    var cardNames: [String] = ["Jack", "Queen", "King"]

    // Swift 可以推断出 cardNames 是 [String] 类型，所以可以写成：

    var cardNames = ["Jack", "Queen", "King"] // inferred as [String]

数组有两种：包含单一数据类型的数组和包含多种数据类型的数组。Swift 追求安全性，所以更偏好前者，但是也可以用通用类型类来兼容后者。上面例子是字符串数组，也就是单一数据类型的数组。

要访问数组中的元素需要使用下标：

    println(cardNames[0])

注意：我们使用 `println` 函数[^4: Swift 2 中请使用 `print`]将 “Jack” 这个值打印到控制台，后面还加上了换行。

### 修改数组

新建一个数组来存储代办事项列表吧：

    var todo = ["Write Blog","Return Call"]

要确保使用了 `var` 关键字，这样才可以修改数组。

要在 `todo` 数组中加入新元素要用到 `+=` 操作符：

    todo += "Get Grocery"

要在 `todo` 数组中加入多个元素很简单，追加到数组上就好：

    todo += ["Send email", "Pickup Laundry"]

要替换数组中已有的元素，下标索引出要修改的元素再赋一个新值就好了：

    todo[0] = "Proofread Blog Post"

要替换数组的一定范围内的元素的话就要提供该范围内的元素的新值：

    todo[2..<5] =="" ["pickup="" laundry","get="" grocery",="" "cook="" dinner"]="" <="" code="">

### 字典

第二种集合类型是 `字典`，类似于其他编程语言中的哈希表。字典可以存储_键值对_，可以根据键访问对应的值。

比如，可以通过指定键和对应的值来指定一组扑克牌：

    var cards = ["Jack" : 11, "Queen" : 12, "King" : 13]

上面代码中的扑克牌名是键，对应数字是值。键不一定非得是 `字符串` 类型，完全可以是任意类型，值也是如此。

### 修改字典

如果要给 `cards` 字典添加一张 “A” 要怎么办呢？其实只要把键当作下标，赋给它一个新值就好了。注意：`cards` 被声明为 `var` 变量，也就是说值可以改变。

    cards["ace"] = 15

上面这行我们搞错了 “A” 对应的数字，需要将其改正。只要再将键作为下标，给它一个新值就好了。

    cards["ace"] = 1

检索字典中的值：

    println(cards["ace"])

## 控制流

### 循环

如果都不能用来循环，那么集合类型还有什么好处呢？Swift 提供了 `while`，`do-while`，`for` 以及 `for-in` 循环。我们来依次看一看。

所有循环中 `while` 是最简单的，其表示只要条件为 `真` 就不断执行代码段。当条件变为 `假` 时，停止执行。

    while !complete {
        println("Downloading...")
    }

注意：`complete` 变量前面的感叹号表示「非」，读作「不满足」。

同样地，使用 `do-while` 循环可以保证代码块至少执行一次。

    var message = "Starting to download"
    do {
        println(message)
        message = "Downloading.."
    } while !complete 

上面代码中稍后调用的 `println` 表达式会打印「下载中......」。[^5: 第一次调用的 `pringln` 会打印「开始下载」]

使用一般形式的 for 循环可以指定一个数字然后不断增加那个数字，直到一个特定的值。

    for var i = 1; i < cardNames.count; ++i {
        println(cardNames[i])
    }

还可以使用简单的 `for-in` 形式，它会创建一个临时变量，在遍历数组时对其赋值。

    for cardName in cardNames {
        println(cardName)
    }

上述代码会打印数组中的全部扑克牌名。还可以使用「区间」来实现。值的「区间」用两个或三个点表示。

比如：

*   1...10 表示 1 到 10 的数字「区间」。这三个点表示闭区间，因为包括最大值。
*   1..<10 表示 1 到 9 的数字「区间」。两个点和小于号表示半开半闭区间，因为不包括最大值。

比如用 `for-in` 结合区间来打印 2 的乘法表：

    for number in 1...10 {
        println("\(number) times 2 is \(number*2)")
    }

还可以遍历 `cards` 字典同时打印键和值：

    for (cardName, cardValue) in cards {
        println("\(cardName) = \(cardValue)")
    }

### If 表达式

要控制代码流程当然要用 `if` 表达式。

    if cardValue == 11 {
        println("Jack")
    } else if cardValue == 12 {
        println("Queen")
    } else {
        println("Not found")
    }

注意：`if` 的语法允许有括号，不强制要求。但是大括号 `{}` 必须有，这点和其他编程语言不同。

### Switch 表达式

Swift 中的 `switch` 表达式功能丰富特性众多。下面是 `switch` 表达式的一些基本规则：


*   每个 `case` 表达式后面不要求有 `break` 表达式。
*   `switch` 没有被限制为整数类型，其可以用来匹配多种类型的值：`String`，`Int` 或者 `Double`，而且还可以使用任何对象。
*   `switch` 表达式必须对应每一个可能值，否则得使用 `default case` 让代码更安全。如果没有为每一个可能值都提供 `case` 也没有使用 `default` 那么会报编译错误：“switch 必须是完备的”。

    switch cardValue {
        case 11:
            println("Jack")
        case 12: 
            println("Queen")
        default:
            println("Not found")
    }

假如有一个距离变量，需要根据距离值打印消息。可以利用多个 `case` 表达式来使用多个值。

    switch distance {
        case 0:
            println("not a valid distance")
        case 1,2,3,4,5:
            println("near")
        case 6,7,8,9,10:
            println("far")
        default:
            println("too far")
    }

还有时候使用多个值还是有局限性。这时就要使用区间了。想一想，如果要把距离大于 10 且小于 100 定义为「远」，应该如何表达呢？

    switch distance {
        case 0:
            println("not a valid distance")

        case 1..10:
            println("near")

        case 10..100 :
            println("far")

        default:
            println("too far")

    }

猜猜上述代码会打印什么出来？

## 函数

最后要提的是函数，我们之前在很多例子中使用过的 `println` 就是函数。要如何自己定义一个函数呢？

要定义一个函数非常简单，使用 `func` 关键字再起个函数名就好了。

    func printCard() {
        println("Queen")
    }

如果一个函数只能打印扑克牌名（比如 “Queen”）似乎没什么用处。如果能够给它传入一个参数然后打印任意的扑克牌名呢？[^6: 也没什么用......]

    func printCard(cardName: String) {
        println(cardName)
    }

当然，并没有限制说只能使用一个参数。传入多个参数是可以的。

    func printCard(cardName: String, cardValue: Int) {
        println("\(cardName) = \(cardValue)")
    }

如果只想让函数构建一个字符串并返回字符串的值而不是打印出来要怎么做呢？只要在函数声明的结尾（`->` 之后）指定返回值（类型）就好了。

    func buildCard(cardName: String, cardValue: Int) -> String {
        return "\(cardName) = \(cardValue)"
    }

上述代码的意思是创建名为 `buildCard` 的函数，接受两个参数，返回一个字符串。

## 总结

如果能坚持读到这里，恭喜你已经掌握了 Swift 基础！虽然这些还只是 Swift 的皮毛，你或许需要花一些时间吸收这些知识。需要学习的东西还有很多，在 Treehouse 我们致力于向你提供学习 Swift 所需的全部知识。

如果想要学习 Swift 基础，在 Treehouse 报名参加 Amit 的[学习 Swift](http://teamtreehouse.com/learn-swift "Learn Swift on Treehouse") 课程吧。



