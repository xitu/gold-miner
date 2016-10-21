>* 原文链接 : [Regarding Swift build time optimizations](https://medium.com/@RobertGummesson/regarding-swift-build-time-optimizations-fc92cdd91e31#.w81y3zhjr)
* 原文作者 : [Robert Gummesson](https://medium.com/@RobertGummesson)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [杨龙龙](http://www.yanglonglong.com)
* 校对者: [申冠华](https://github.com/shenAlexy), [Jack King](https://github.com/Jack-Kingdom)

# 关于 Swift 编译时性能优化的一些思考

![](http://ww3.sinaimg.cn/large/005SiNxygw1f3p3jimjllj31jk0dwqft.jpg)

上周，我读了 [@nickoneill](https://medium.com/@nickoneill) 一篇优秀的帖子 [Speeding Up Slow Swift Build Times](https://medium.com/swift-programming/speeding-up-slow-swift-build-times-922feeba5780#.k0pngnkns) 之后，我发现用一个略不同以往的角度去读Swift代码，并不是很难。

一行之前很简洁的代码，现在却出现了新的问题——它是否应该重构为9行代码来达到更快的编译速度？ (_nil coalescing 运算符就是一个例子_)孰轻孰重？简洁的代码还是对编译器友好的代码？ 我觉得，它取决于项目的大小和开发者的想法。

#### 但请等等... 这里有一个Xcode插件

在讲一些例子之前，我首先想到了通过手工提取日志信息是非常耗时的事情。通过命令行工具实现会相对容易一些，但是我把它往前推进了一步：集成为[Xcode插件](https://github.com/RobertGummesson/BuildTimeAnalyzer-for-Xcode)。

![](http://ww1.sinaimg.cn/large/005SiNxygw1f3p3hhivppj30m809lwis.jpg)

在这个例子中，最初的目的仅仅是识别并修复代码中最耗时的地方，但是现在我觉得它成为了一个必须要迭代的过程。这样我才可以更加高效地构建代码，并且防止在项目中出现耗时的函数。

#### 不少惊喜

我经常在不同的 Git 分支中跳转，并且等待一个暖慢的项目编译简直是在浪费我的生命。因此我思考了很长时间，一个玩具项目（大约两万行 Swift 代码）会编译如此长的时间。

当我知道是什么原因导致它如此慢之后，我不得不承认我震惊了，一行代码居然需要几秒的编译时间。

让我们来看几个例子。

#### Nil 合并运算符

编译器肯定不喜欢这里的第一种方法。在展开下面两处简写的代码之后，构建时间减少了 **99.4%**。

    // 构建时间： 5238.3ms
    return CGSize(width: size.width + (rightView?.bounds.width ?? 0) + (leftView?.bounds.width ?? 0) + 22, height: bounds.height)

    // 构建时间： 32.4ms
    var padding: CGFloat = 22
    if let rightView = rightView {
        padding += rightView.bounds.width
    }

    if let leftView = leftView {
        padding += leftView.bounds.width
    }
    return CGSizeMake(size.width + padding, bounds.height)

#### ArrayOfStuff + [Stuff]

这个看起来像下面这样：

    return ArrayOfStuff + [Stuff]  
    // 而不是  
    ArrayOfStuff.append(stuff)  
    return ArrayOfStuff

我经常这么做，并且它影响了每次构建的时间。下面是最糟糕的一个例子，改写后构建时间可以减少 **97.9%**。

    // 构建时间： 1250.3ms
    let systemOptions = [ 7, 14, 30, -1 ]
    let systemNames = (0...2).map{ String(format: localizedFormat, systemOptions[$0]) } + [NSLocalizedString("everything", comment: "")]
    // Some code in-between 
    labelNames = Array(systemNames[0..<count]) + [systemNames.last!]

    // 构建时间： 25.5ms
    let systemOptions = [ 7, 14, 30, -1 ]
    var systemNames = systemOptions.dropLast().map{ String(format: localizedFormat, $0) }
    systemNames.append(NSLocalizedString("everything", comment: ""))
    // Some code in-between
    labelNames = Array(systemNames[0..<count])
    labelNames.append(systemNames.last!)

#### 三元运算符

仅仅是通过替换三元运算符为 if else 语句就能减少 **92.9%** 的构建时间。如果使用一个for循环替换 _map_ 函数，它又能减少另一个 75%（但是我的眼睛可就受不了咯😉）。

    // 构建时间： 239.0ms
    let labelNames = type == 0 ? (1...5).map{type0ToString($0)} : (0...2).map{type1ToString($0)}

    // 构建时间： 16.9ms
    var labelNames: [String]
    if type == 0 {
        labelNames = (1...5).map{type0ToString($0)}
    } else {
        labelNames = (0...2).map{type1ToString($0)}
    }

#### 转换 CGFloat 到 CGFloat

这里我所说的并不一定正确。变量已经使用了 CGFloat 并且有一些括号也是多余的。在清理了这些冗余之后，构建时间能减少 **99.9%**。

    // 构建时间： 3431.7 ms
    return CGFloat(M_PI) * (CGFloat((hour + hourDelta + CGFloat(minute + minuteDelta) / 60) * 5) - 15) * unit / 180

    // 构建时间： 3.0ms
    return CGFloat(M_PI) * ((hour + hourDelta + (minute + minuteDelta) / 60) * 5 - 15) * unit / 180

#### Round()

这个一个非常奇怪的例子，下面的例子中变量是一个局部变量与实例变量的混合。这个问题可能不是四舍五入本身，而是结合代码的方法。去掉四舍五入的方法大概能减少 **97.6%** 的构建时间。

    // 构建时间： 1433.7ms
    let expansion = a — b — c + round(d * 0.66) + e
    // 构建时间： 34.7ms
    let expansion = a — b — c + d * 0.66 + e

注意：所有的测试都在 MacBook Air (13-inch, Mid 2013)中进行。

#### 尝试它

无论你是否面临过构建时间太长的问题，编写对编译器友好的代码都是非常有用的。我确定你自己会在其中找到一些惊喜。作为参考，这里有完整的代码，在我的工程中可以5秒内完成编译...

    import UIKit

    class CMExpandingTextField: UITextField {

        func textFieldEditingChanged() {
            invalidateIntrinsicContentSize()
        }

        override func intrinsicContentSize() -> CGSize {
            if isFirstResponder(), let text = text {
                let size = text.sizeWithAttributes(typingAttributes)
                return CGSize(width: size.width + (rightView?.bounds.width ?? 0) + (leftView?.bounds.width ?? 0) + 22, height: bounds.height)
            }
            return super.intrinsicContentSize()
        }
    }

