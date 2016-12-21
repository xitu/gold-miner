> * 原文地址：[How Can Swift Language Features Improve Testability?](http://qualitycoding.org/swift-testability/)
* 原文作者：[Jon Reid](http://qualitycoding.org/contact/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[steinliber](https://github.com/steinliber)
* 校对者：[Edison-Hsu](https://github.com/Edison-Hsu)  [Graning](https://github.com/Graning)


我知道如何编写具有可测试性的 C++ 和 Objective-C ，但是 Swift 在这方面又是怎么做的呢？

一种编程语言的特性和整体感觉可以对我们如何表述代码产生巨大的影响。相信你们中的大多数人都已经知道这一点，因为你们很早就开始学习 Swift，并且已经领先于我，我非常乐于去追赶你们。Swift 的特性就像新的玩具一样！但是这些特性又是如何影响可测试性的呢?

![](http://qualitycoding.org/jrwp/wp-content/uploads/2016/09/tool-contrast@2x.jpg)

## 编写可测试的代码

**透露一个秘密：下面的书本链接是个附带链接，如果你买了其中的任何东西，我可以赚取一定的提成，对你来说不造成任何额外费用。**

单元测试最大的挑战就是编写可测试的代码。这通常就意味这第一次重新学习如何编写代码！这本书 [Working Effectively with Legacy Code](http://www.amazon.com/gp/product/0131177052/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0131177052&linkCode=as2&tag=qualitycoding-20&linkId=CMFUKIQWYHGBBOSN) 提供了许多技巧来帮助在编写代码时不用考虑其可测试性。这些技术比如说‘子类和方法重载’在处理遗留代码时可以做的很好，所以我也开始在实施 TDD 的过程中使用它们。

但是有一天，我问自己，‘为什么我一直在写遗留代码’

换句话说，这些处理遗留代码的技术是一种权宜之计。难道没有不求助于变通方案便可提高可测试性的方法？

于是我找到了 [Dependency Injection](http://qualitycoding.org/dependency-injection/)。依赖注入的其中一个目的就是提供对它正在测试的代码提供一个测试完整的控制。

基于不同的语言特性可以使依赖注入变得更加简单。构造器注入在 DI 中是一种更好的形式。Swift 默认的参数值可以使构造器注入更加简单。（但是如果你有一个 Swift 闭包属性？并且有一个默认闭包？请看下文！）

## 回顾：在 Objective-C 下 Marvel API 的验证

我第一次学习单元测试和 TDD 是在写 C++ 的时候。而当我开始转而使用 Objective-C，这简直是一股清流！生产代码和测试代码都变得更加易读和易写。

现在我再重新做我的（令人可悲的是还没完成）[TDD sample app](http://qualitycoding.org/tdd-sample-archives/)，这一次是用 Swift 语言。漫威浏览器将会成为一个简单的 app 在漫威宇宙中探索动漫角色。

这其中的一大部分已经知道如何与 Marvel API 交换信息。这开始于[spike solution in Objective-C](http://qualitycoding.org/spike-solution-techniques/)。为了把 spike 变为符合 TDD 的代码，我必须处理两个会使单元测试变得棘手的东西。

* 时间戳
* MD5 哈希

相比于把所有问题都事先解决，我首先尝试了子类和方法重载这个方法。也就是说我把这两个东西的作用域绑定在方法上，然后创建了一个特殊的子类，这个子类只用于重载这两个方法。

这是一种处理遗留代码的技术，但是在开始时这任然是一个不错的方法。所谓的诀窍不是在这个方面。

我们如何设计可以被替代的东西？我想到了使用[策略模式](https://en.wikipedia.org/wiki/Strategy_pattern)，但是我决定使用代码块来代替。我把这些块变做属性。就是这个想法打开了属性注入的大门。

我们如何可以提供一个默认的代码块？当然，我可以在初始化程序中做到这点。但是这会使初始化程序变得到处都是，我使用了惰性属性－没有推迟它们的初始化，而是把它们移出了初始化程序。

## 测试依赖于时间的代码

在开始使用 Swift 时，一些原先在 Objective-C 的代码实现一直困扰着我。为了保持代码简单，时间戳是作为一个惰性属性实现的，它记录了第一次访问的时间。多个对这个实例的调用都会得到相同的结果。我尝试使用工厂模式来隐藏这个。

J. B. Rainsberger 对于这个问题有篇很好的文章。这篇文章实际上是关于一个更笼统的问题：使你的抽象层级正确，但是这次的案例是依赖于时间的代码。在[Beyond Mock Objects](http://blog.thecodewhisperer.com/permalink/beyond-mock-objects)中，他描述了一个例子，这个例子在一个阶段会需要不同的实例：

> 我也发现这有点奇怪。我在一个方面简化了依赖，而在另一个方面使依赖变得更加复杂：客户端对于每个请求都必须初始化一个新的控制器，或者换句话说，控制器有请求作用域。这听起来是错误的。

我鼓励你去研究下这篇文章。基本上，与其在问题中有一个方法来决定时间戳，我们可以简单地把时间戳作为参数传递。这是方法注入的一个经典用法。

在 Objective-C 中可以使用级联方法来实现方法注入。接口应该十分清晰：

    - (NSString *)URLParameters;
    - (NSString *)URLParametersWithTimestamp:(NSString *)timestamp;

第一个方法调用了第二个方法，提供了一个默认值:

    - (NSString *)URLParameters
    {
        return [self URLParametersWithTimestamp:[self timestamp]];
    }

Swift 使它变得更简单。我们可以简单的使用默认参数值而不是使用级联方法。

		func urlParameters(
	    timestamp: String = MarvelAuthentication.timestamp(),
	    /* more to come here */) -> String

其中一个复杂的地方是：Swift 并不允许我们调用另一个实例方法来获取默认的值。所以如果你可以，使它作为一个类型方法实现。（如果不行，我们总是可以依靠级联方法）

## Swift 默认的属性值

当我在 Objective-C 中使用属性注入，我通常会为属性设定默认的值。我们可以在初始化程序中建立小的属性。但是有时候你并不想在初始化程序中的代码是和程序无关的。或者有的时候它并不小－它是一个代码块。在这些时候，我会使用 Objective-C 中的惰性属性用法。

这是我如何实现计算 MD5 哈希值的代码块：

    - (NSString *(^)(NSString *))calculateMD5
    {
        if (!_calculateMD5)
        {
            _calculateMD5 = ^(NSString *str){
                /* Actual body goes here */
            };
        }
        return _calculateMD5;
    }

但是 Swift 允许我们在属性定义的地方设置默认的属性值。这是一个有默认值的闭包属性：

		var md5: (String) -> String = { str in
	    /* Actual body goes here */
	}

哇，这也简单太多了吧！

## 闭包实验

这是我主要测试现在看起来的样子，这还是不错的：

    func testUrlParameters_ShouldHaveTimestampPublicKeyAndHashedConcatenation() {
    			sut.privateKey = "Private"
    			sut.publicKey = "Public"
    			sut.md5 = { str in return "MD5" + str + "MD5" }
    
    			let params = sut.urlParameters(timestamp: "Timestamp")
    
    			XCTAssertEqual(params, "&ts=Timestamp&apikey=Public&hash=MD5TimestampPrivatePublicMD5")
    	}

正如你可以看到的，我覆盖了 MD5 的闭包用于保持测试的可理解性。这个测试表明产生的 URL 参数是对的。你可以看到如何使用哈希工作的。

但是随后我想到，为什么要覆盖一个闭包属性呢？为什么不把 MD5 算法当作一个参数传进去呢？如果我们把它作为最后一个参数，那么我们就可以使用尾部闭包语法：

    func testUrlParameters_ShouldHaveTimestampPublicKeyAndHashedConcatenation() {
            sut.privateKey = "Private"
            sut.publicKey = "Public"
    
            let params = sut.urlParameters(timestamp: "Timestamp") { str in
                return "MD5" + str + "MD5"
            }
    
            XCTAssertEqual(params, "&ts=Timestamp&apikey=Public&hash=MD5TimestampPrivatePublicMD5")
        }

这代码的可读性更强吗？老实说，我认为它甚至变得有点更糟糕了。我使用空行把我的测试分成了 ‘Three A's’ （ Arrange（安排）, Act（执行）, Assert（断言））。我认为这个特定的闭包弄乱了我的执行部分，同时它也没有名字，这使人更难理解它代表的是什么。

但是我不得不设法找出来！

## 可测试的 Swift

以下使我至今为止学到的 Swift 是如何使我们可以简单写出写兼顾可测试性和清晰的代码

**默认:** Swfit 的默认值简化了许多依赖注入技术：

*   构造注入：在初始化器中使用默认参数
*   属性注入：使用默认的属性值
*   方法注入：在任何方法中使用默认的参数值

**闭包:** Swift 闭包的一致的语法可以在多种地方引进接缝.

*   闭包属性
*   闭包参数
*   因为语法并没有大范围的改动，重构比较简单
*   因为函数是闭包的，你可以在任何想要的地方抽取想要的闭包。为什么要在一行里做所有事呢？

我并不想滥用闭包。选择是，总会有一个合适的抽象层级等待被发现然后使用于策略模式。但是每一个缝隙都是一个提高可测试性的机会

我仍然只学了 Swift 的皮毛。我从 Joe Masilotti 的文章 [Better Unit Testing with Swift](http://masilotti.com/better-swift-unit-testing/) 了解到协议提供了极大的机会。但是其它语言特性是如何影响可测试性的？比如说枚举或者泛型？跟着我来把它们探索清楚，测试驱动的 Swift，[subscribe today](http://qualitycoding.org/subscribe/) ！

**你使用了哪些 Swift 的特性来提高可测试性？我应该探索哪些特性？可以在下面的评论中留言让我知道**

