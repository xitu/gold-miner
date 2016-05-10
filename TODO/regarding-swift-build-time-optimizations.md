>* 原文链接 : [Regarding Swift build time optimizations](https://medium.com/@RobertGummesson/regarding-swift-build-time-optimizations-fc92cdd91e31#.w81y3zhjr)
* 原文作者 : [Robert Gummesson](https://medium.com/@RobertGummesson)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

![](http://ww3.sinaimg.cn/large/005SiNxygw1f3p3jimjllj31jk0dwqft.jpg)

### Regarding Swift build time optimizations

After I read [@nickoneill](https://medium.com/@nickoneill)’s excellent post [Speeding Up Slow Swift Build Times](https://medium.com/swift-programming/speeding-up-slow-swift-build-times-922feeba5780#.k0pngnkns) last week, it’s hard not to look at Swift code in a slightly different light.

A single line of what could be considered clean code now raises a new question — should it be refactored to 9 lines to please the compiler? (_see the nil coalescing operator example further down_)What is more important? Concise code or compiler friendly code? Well, it depends on project size and developer frustration.

#### But wait… There is an Xcode plugin for that

Before getting to some examples, let me first mention that going through log files manually is very time consuming. Someone came up with a terminal command to make it easier but I took it a step further and threw together [an Xcode plugin](https://github.com/RobertGummesson/BuildTimeAnalyzer-for-Xcode).

![](http://ww1.sinaimg.cn/large/005SiNxygw1f3p3hhivppj30m809lwis.jpg)

In my case, the initial aim was to just identify and fix the most time consuming areas but I’m now of the opinion that it has to become more of an iterative process. That way I can, other than making the code build more efficiently, also guard against time consuming functions entering the project in first place.

#### More than a few surprises

I frequently jump back and forth various Git branches and waiting for a slow project to compile tends to end up wasting a lot of time. I’ve been wondering for quite some time why a pet project of mine (roughly 20k lines of Swift code) builds as slowly as it does.

After having learnt what really caused it, I must admit I am really quite surprised to see single lines of code requiring several seconds to compile.

Let’s have a look at a few examples.

#### Nil Coalescing Operator

The compiler certainly didn’t like the first approach here. After unwrapping the two views, the build time was reduced by **99.4%**.

    // Build time: 5238.3ms
    return CGSize(width: size.width + (rightView?.bounds.width ?? 0) + (leftView?.bounds.width ?? 0) + 22, height: bounds.height)

    // Build time: 32.4ms
    var padding: CGFloat = 22
    if let rightView = rightView {
        padding += rightView.bounds.width
    }

    if let leftView = leftView {
        padding += leftView.bounds.width
    }
    return CGSizeMake(size.width + padding, bounds.height)

#### ArrayOfStuff + [Stuff]

This one goes something like this:

    return ArrayOfStuff + [Stuff]  
    // rather than  
    ArrayOfStuff.append(stuff)  
    return ArrayOfStuff

I do this fairly regularly and it has an impact on the required build time every time. The below was the worst one and the build time reduction here was **97.9%**.

    // Build time: 1250.3ms
    let systemOptions = [ 7, 14, 30, -1 ]
    let systemNames = (0...2).map{ String(format: localizedFormat, systemOptions[$0]) } + [NSLocalizedString("everything", comment: "")]
    // Some code in-between 
    labelNames = Array(systemNames[0..<count]) + [systemNames.last!]

    // Build time: 25.5ms
    let systemOptions = [ 7, 14, 30, -1 ]
    var systemNames = systemOptions.dropLast().map{ String(format: localizedFormat, $0) }
    systemNames.append(NSLocalizedString("everything", comment: ""))
    // Some code in-between
    labelNames = Array(systemNames[0..<count])
    labelNames.append(systemNames.last!)

#### Ternary operator

By doing nothing more than replacing the ternary operator with an if else statement, the build time was reduced by **92.9%**. If _map_ is replaced with a for loop, it will drop another 75% (but then my eyes would hurt). 😉

    // Build time: 239.0ms
    let labelNames = type == 0 ? (1...5).map{type0ToString($0)} : (0...2).map{type1ToString($0)}

    // Build time: 16.9ms
    var labelNames: [String]
    if type == 0 {
        labelNames = (1...5).map{type0ToString($0)}
    } else {
        labelNames = (0...2).map{type1ToString($0)}
    }

#### Casting CGFloat to CGFloat

Not sure what I was thinking here. The values were already CGFloat and some parentheses were redundant. After cleaning up the mess, the build time dropped by **99.9%**.

    // Build time: 3431.7 ms
    return CGFloat(M_PI) * (CGFloat((hour + hourDelta + CGFloat(minute + minuteDelta) / 60) * 5) - 15) * unit / 180

    // Build time: 3.0ms
    return CGFloat(M_PI) * ((hour + hourDelta + (minute + minuteDelta) / 60) * 5 - 15) * unit / 180

#### Round()

This is a really odd one. The below example variables are a mix of local and instance variables. The problem is likely not the rounding itself but a combination of code in the method. Removing the rounding did a massive difference though, **97.6%** to be precise.

    // Build time: 1433.7ms
    let expansion = a — b — c + round(d * 0.66) + e
    // Build time: 34.7ms
    let expansion = a — b — c + d * 0.66 + e

Note: All measures where made on a MacBook Air (13-inch, Mid 2013).

#### Try it out

Whether or not you have a problem with slow build times, it is still useful to build an understanding of what confuses the compiler. I’m sure you’ll find a few surprises yourself. As a reference, here is the full code for the one requiring 5+ seconds to compile in my project…

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

