> * 原文地址：[Building Fluid Interfaces: How to create natural gestures and animations on iOS](https://medium.com/@nathangitter/building-fluid-interfaces-ios-swift-9732bb934bf5)
> * 原文作者：[Nathan Gitter](https://medium.com/@nathangitter?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-fluid-interfaces-ios-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-fluid-interfaces-ios-swift.md)
> * 译者：[RydenSun](https://github.com/xitu/gold-miner)
> * 校对者：

# 构建流畅的交互界面

## 如何在 iOS 上创建自然的交互手势及动画

在 WWDC 2018 上，苹果设计师进行了一次题为  [“设计流畅的交互界面”](https://developer.apple.com/videos/play/wwdc2018/803/) 的演讲，解释了 iPhone X 手势交互体系背后的设计理念。

![](https://cdn-images-1.medium.com/max/1600/1*EZJGlfbTCPSEq7Exwjla1Q.png)

苹果 WWDC18 演讲 “设计流畅的交互界面”

这是我最喜欢的 WWDC 分享 —— 我十分推荐它

这次分享提供了一些技术性指导，这对一个设计演讲来说是很特殊的，但它只是一些伪代码，留下了太多的未知。

![](https://cdn-images-1.medium.com/max/1600/1*m_arQ47qnUvIFPNCHRxt7Q.png)

演讲中一些看起来像 Swift 的代码。

如果你想尝试实现这些想法，你可能会发现想法和实现是有差距的。

我的目的就是通过为演讲中的每一个主要话题，都提供关键的代码，来填补中间的差距。

![](https://cdn-images-1.medium.com/max/1600/1*zvcJzQnHtJRrDhvfV9XaYw.gif)

我们会创建 8 个界面。 按钮，弹簧动画，自定义界面和更多。

这是我们今天会讲到的内容概览：

1.  “设计流畅的交互界面”分享的简短总结。
2.  8 个流畅的交互界面，背后的设计理念和构建的代码。
3.  设计师和开发者的实际应用

### 什么是流畅的交互界面?

一个流畅交互界面也可以被描述为“快”，“顺滑”，“自然”或是“奇妙”。它是一种光滑的，无摩擦的体验，让你只会感觉到它是对的。

WWDC 分享认为流畅的交互界面是“你思想的延伸”或是“自然世界的延伸”。当一个界面是按照人们的想法做事，而不是按照机器的想法时，他就是流畅的。

### 是什么让它们流畅？

流畅的交互界面是响应式的，可中断的，并且是可重定向的。这是一个 iPhone X 滑动返回首页的手势案例：

![](https://cdn-images-1.medium.com/max/1600/1*XxdPbsgL9qeY4QXr1pztfw.gif)

应用在启动动画中是可以被关闭的。

交互界面即时相应用户的输入，可以在任何进程中停止，甚至可以中途改变动画方向。

### 我们为什么关注流畅的交互界面？

1.  流畅的交互界面提升了用户体验，让用户感觉每一个交互都是快的，轻量和有意义的。
2.  它们给予用户一种掌控感，这为你的应用与品牌建立了信任感。
3.  它们很难被构建。一个流畅的交互界面是很难被仿造，这是一个有力的竞争优势。

### 交互界面

这篇文章剩下的部分，我会为你们展示怎样来构建 WWDC 分享中提到的 8 个主要的界面。

![](https://cdn-images-1.medium.com/max/1600/1*989Lsw_y9JcZsJrAVyxEEQ.png)

图标代表了我们要构建的 8 个交互界面。

![](https://cdn-images-1.medium.com/max/2000/1*slFD9J80nOOOjm9dsn6aGQ.png)

### 交互界面 #1: 计算器按钮

这个按钮模仿了 iOS 计算器应用中按钮的表现行为。

![](https://cdn-images-1.medium.com/max/1600/1*h-Y4Y6K8uxu1mZ6NYst4MA.gif)

#### 核心功能

1.  被点击时马上高亮。
2.  即便处于动画中也可以被立即点击。
3.  用户可以在按住手势结束时或手指脱离按钮时取消点击。
4.  用户可以在按住手势结束时，手指脱离按钮和手指重回按钮来确认点击。

#### 设计理念

我们希望按钮感觉是即时相应的，让用户确认它们是有功能的。 另外，我们希望操作是可以被取消的，如果用户在按下按钮时决定撤销操作。这允许用户更快的做决定，因为他们可以在考虑的同时进行操作。

![](https://cdn-images-1.medium.com/max/1600/1*ccdkb04pc02QvnfYJtum8g.png)

WWDC 分享上的幻灯片，展示了手势是如何与想法同时进行的，以此让操作更迅速。

#### 关键代码

第一步是创建一个按钮，继承自 `UIControl`，不是继承自 `UIButton`。 `UIButton`也可以正常工作，但我们既然要自定义交互，那我们就不需要它的任何功能了。

```
CalculatorButton: UIControl {
    public var value: Int = 0 {
        didSet { label.text = “\(value)” }
    }
    private lazy var label: UILabel = { ... }()
}
```

下一步，我们会使用 `UIControlEvents` 来为各种点击交互事件分配响应的功能。

```
addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
```

我们将 `touchDown` 和 `touchDragEnter` 组合到一个单独的事件，叫做 `touchDown`，并且我们将 `touchUpInside`，`touchDragExit` 和 `touchCancel` 组合一个单独的事件，叫做 `touchUp`。

(查看 [这个文档](https://developer.apple.com/documentation/uikit/uicontrolevents?language=objc) 来获取所有可用的 `UIControlEvents` 的描述。)

这让我们有两个方法来处理动画。

```
private var animator = UIViewPropertyAnimator()
@objc private func touchDown() {
    animator.stopAnimation(true)
    backgroundColor = highlightedColor
}
@objc private func touchUp() {
    animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
        self.backgroundColor = self.normalColor
    })
    animator.startAnimation()
}
```

在 `touchDown`，我们根据需要取消存在的动画，然后马上将颜色设置成高亮颜色（在这里是浅灰色）。

在 `touchUp`，我们创建了一个新的 animator 并且将动画启动。使用 `UIViewPropertyAnimator` ，可以轻松地取消高亮动画。

(幻灯片笔记: 这不是严谨的 iOS 计算器应用中按钮的表现，它允许手势从别的按钮移动到这个按钮来启动电机事件。大多数情况下，我在这里创建的按钮就是 iOS 按钮的预期行为)

### 交互界面 #2: 弹簧动画

这个交互展示了弹簧动画是如何可以通过指定一个“阻尼”（反弹）和“响应”（速度）来创建的。

![](https://cdn-images-1.medium.com/max/1600/1*S0s0LiggTJm1U44lC4kcfg.gif)

#### 核心功能

1.  使用“对设计友好”的参数。
2.  对动画持续时间无概念。
3.  可轻易中断。

#### 设计理念

弹簧是一个很好的动画模型，因为它的速度和自然的外观表现。一个弹簧动画可以及其迅速的开始，用其大多数的时间来慢慢接近最终状态。 这对创建一个响应式的交互界面来说是完美的。

设计弹簧动画时的几个额外的提醒：

1. 弹簧动画不需要有弹性。使用数值为 1 的阻尼会构建一个动画，它慢慢的向剩下部分靠近，但没有任何反弹。大多数动画应该使用值为 1 的阻尼。
2. 尝试着避免考虑时长。理论上，一个弹簧动画从来不会完全靠近其余的部分，如果强加上时长限制，会造成动画的不自然。相反，要不断调整阻尼和响应值知道它感觉对。
3. 可中断性是很关键的。因为弹簧动画消耗了它们绝大部分的时间来接近最终值，用户可能会认为动画已经完成并且会尝试再与它交互。

#### 关键代码

在 UIKit 中，我们可以用 `UIViewPropertyAnimator` 和一个  `UISpringTimingParameters` 对象来构建一个弹簧动画。不幸的是，它没有一个只接受“阻尼”和“相应”的初始化构造器。我们能得到的最接近的初始化构造器是 `UISpringTimingParameters`，它需要质量，硬度，阻尼和初始加速度这几个参数。

```
UISpringTimingParameters(mass: CGFloat, stiffness: CGFloat, damping: CGFloat, initialVelocity: CGVector)
```

我们希望创建一个简便的初始化构造器，只使用阻尼和响应这两个参数，并且将它们映射至需要的质量，硬度和阻尼。

使用一点物理知识，我们可以导出我们需要的公示：

![](https://cdn-images-1.medium.com/max/1600/1*G_83X45IJ6J8Cedkvue_WA.png)

弹簧动画的常量和阻尼系数的解决方案。

有了这个结果，我们正好可以使用我们想要的参数来创建我们自己的 `UISpringTimingParameters`。

```
extension UISpringTimingParameters {
    convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }
}
```

这就是我们如何可以指定弹簧动画到所有其他的交互界面。

#### 弹簧动画背后的物理学

想深入研究弹簧动画？ 看看 Christian Schnorr 发的这篇极好的文章：[Demystifying UIKit Spring Animations](https://medium.com/ios-os-x-development/demystifying-uikit-spring-animations-2bb868446773).

![](https://cdn-images-1.medium.com/max/1600/1*NPFOJlbdIyjPXLYU4nJxUQ.png)

读了他的文章之后，我最终理解了弹簧动画。对 Christian 大大的致敬，因为它帮助我理解了这些动画背后的数学理论，而且教我如何解二阶微分方程。

### 交互界面 #3: 手电筒按钮

又是一个按钮，但又不同的表现形式。它模仿了 iPhone X 锁屏上的手电筒按钮。

![](https://cdn-images-1.medium.com/max/1600/1*nrzZVlSrZ7hhrxRe_Sl_bA.gif)

#### 核心功能

1.  需要一个使用 3D Touch 的强力手势。
2.  对手势有反弹提示。
3.  对确认启动有震动反馈。

#### 设计理念

苹果希望创建一个按钮，它可以轻易的并且快速的被接触到，但是并不会被不小心出发。需要强压来启动手电筒是一个很棒的选择，但是缺少了功能的可见性和反馈性。

为了解决这个问题，这个按钮是有弹性的，并且会随着用户按压的力度来变大。除此之外，有两个单独的触觉震动反馈：一个是在达到要求的力度按压时，另一个是按压结束按钮被触发时。这些触觉模拟了物理按钮的表现形式。

#### 关键代码

为了衡量按压按钮的力度，我们可以使用 touch 事件提供的 `UITouch` 对象。

```
override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    guard let touch = touches.first else { return }
    let force = touch.force / touch.maximumPossibleForce
    let scale = 1 + (maxWidth / minWidth - 1) * force
    transform = CGAffineTransform(scaleX: scale, y: scale)
}
```

我们基于用户按压力度计算了缩放比例，这样可以让按钮随着用户按压力度变大。

既然按钮可以被按压但不会启动，我们需要持续追踪按钮的实时状态。

```
enum ForceState {
    case reset, activated, confirmed
}

private let resetForce: CGFloat = 0.4
private let activationForce: CGFloat = 0.5
private let confirmationForce: CGFloat = 0.49
```

通过将确认压力设置到稍小于启动压力，防止用户通过快速的超过压力阈值来频繁的启动和取消启动按钮。

对于触觉反馈，我们可以使用  `UIKit`’ 的反馈生成器。

```
private let activationFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

private let confirmationFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
```

最后，对于反弹动画，我们可以使用 `UIViewPropertyAnimator` 并且配合我们前面构建的 `UISpringTimingParameters` 初始化构造器。

```
let params = UISpringTimingParameters(damping: 0.4, response: 0.2)
let animator = UIViewPropertyAnimator(duration: 0, timingParameters: params)
animator.addAnimations {
    self.transform = CGAffineTransform(scaleX: 1, y: 1)
    self.backgroundColor = self.isOn ? self.onColor : self.offColor
}
animator.startAnimation()
```

### 交互界面 #4: 橡皮筋动画

橡皮筋动画发生在视图抗拒移动时。一个例子就是当滚动视图滑到最底部时。

![](https://cdn-images-1.medium.com/max/1600/1*y0jRo2TeJ9VtCZPmQxyRLw.gif)

#### 核心功能

1.  交互界面永远是可响应的，即使当操作是无效的。
2.  不同步的触摸追踪，代表了边界。
3.  随着远离边界，移动距离变小。

#### 设计理念

橡皮筋动画是一种很好的方式来沟通无效的操作，它仍然会给用户一种掌控感。它温柔的告诉你这是一个边界，将它们拉回到有效的状态。

#### 关键代码

幸运的是，橡皮筋动画实现起来很直接。

```
offset = pow(offset, 0.7)
```

通过使用 0 到 1 之间的一个指数，视图会随着远离原始位置，移动越来越少。要移动的少就用一个大的指数，移动的多就使用一个小的指数。

再详细一点，这段代码一般是在触摸移动时，在 `UIPanGestureRecognizer` 回调中实现的。

```
var offset = touchPoint.y - originalTouchPoint.y  
offset = offset > 0 ? pow(offset, 0.7) : -pow(-offset, 0.7)  
view.transform = CGAffineTransform(translationX: 0, y: offset)
```

注意:这并不是苹果如何使用想 scroll view 这些元素来实现橡皮筋动画。我喜欢这个方法，是因为它简单，但对不同的表现，还有很多更复杂的方法。

### 交互界面 #5: 加速中止

为了看 iPhone X 上的应用切换，用户需要从屏幕底部向上滑，并且在中途停止。这个交互界面就是为了创建这个表现形式。

![](https://cdn-images-1.medium.com/max/1600/1*GMqctAhbjqpmWmAtsKVeDg.gif)

#### 核心功能

1.  中止是基于收拾加速度来计算的。
2.  越快的停止导致越快的响应。
3.  没有计时器。

#### 设计理念

流畅的交互界面应该是快速的。计时器产生的延迟，即便很短，也会让界面感到卡顿。

这个交互十分酷，因为它的反应时间是根据用户手势运动的。如果他们很快停止，界面会很快响应。如果他们慢慢停止，界面就慢慢响应。

#### 关键代码

为了衡量加速度，我们可以追踪最新的拖拽手势的速度值。

```
private var velocities = [CGFloat]()
private func track(velocity: CGFloat) {
    if velocities.count < numberOfVelocities {
        velocities.append(velocity)
    } else {
        velocities = Array(velocities.dropFirst())
        velocities.append(velocity)
    }
}
```

这段代码更新了 `velocities` 数组，这样可以一直持有最新的 7 个速度值，这些可以被用来计算加速度值。

为了判断加速度是否足够大，我们可以计算数组中第一个速度值和目前速度值的差。

```
if abs(velocity) > 100 || abs(offset) < 50 { return }
let ratio = abs(firstRecordedVelocity - velocity) / abs(firstRecordedVelocity)
if ratio > 0.9 {
    pauseLabel.alpha = 1
    feedbackGenerator.impactOccurred()
    hasPaused = true
}
```

我们也要确保手势移动有一个最小位移和速度。如果手势已经慢下来超过 90%，我们会考虑将它停止。

我的实现并不完美。在我的测视里，它看起来工作的不错，但还有机会深入探索加速度的计算方法。

### 交互界面 #6: 奖励有势头的动画（自我驱动移动）一些反弹

一个抽屉动画，有打开和关闭状态，他们会根据手势的速度有一些反弹

![](https://cdn-images-1.medium.com/max/1600/1*Wwh583M_4qLWg8Pb16mNeA.gif)

#### 核心功能

1.  点击抽屉动画，没有反弹。
2.  轻弹出抽屉，有反弹。
3.  可交互，可中断并且可逆。

#### 设计理念

抽屉动画展示了这个交互界面的理念。当用户有一定速度的滑动某个视图，将动画附带一些反弹会更令人满意。这样交互界面感觉像活得，也更有趣。

当抽屉被点击时，它的动画是没有反弹的，这感觉起来是对的，因为点击时没有任何明确方向的势头的。

当设计自定义的交互界面时，要谨记界面对于不同的交互是有不同的动画的。

#### 关键代码

为了简化点击与拖拽手势的逻辑，我们可以使用一个自定义的手势识别器的子类，在点击的一瞬间进入 `began` 状态。

```
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
}
```

这可以让用户在抽屉运动时，点击抽屉来停止它，这就像点击一个正在滚动的滚动视图。为了处理这些点击，我们可以检查当手势停止时，速度是否为 0 并继续动画。

```
if yVelocity == 0 {
    animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
}
```

为了处理带有速度的手势，我们首先需要计算它相对于剩下的总距离的速度。

```
let fractionRemaining = 1 - animator.fractionComplete
let distanceRemaining = fractionRemaining * closedTransform.ty
if distanceRemaining == 0 {
    animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    break
}
let relativeVelocity = abs(yVelocity) / distanceRemaining
```

当我们可以使用这个相对速度时，配合计时变量来继续这个包含一点反弹的动画。

```
let timingParameters = UISpringTimingParameters(damping: 0.8, response: 0.3, initialVelocity: CGVector(dx: relativeVelocity, dy: relativeVelocity))

let newDuration = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters).duration

let durationFactor = CGFloat(newDuration / animator.duration)

animator.continueAnimation(withTimingParameters: timingParameters, durationFactor: durationFactor)
```

这里我们创建有一个新的 `UIViewPropertyAnimator` 来计算动画需要的时间，这样我们可以在继续动画时提供正确的 `durationFactor`。

关于动画的回转，会更复杂，我这里就不介绍了。如果你想知道的哦更多，我写了一个关于这部分的完整的教程：[构建更好的 iOS APP 动画](http://www.swiftkickmobile.com/building-better-app-animations-swift-uiviewpropertyanimator/).

### 交互动画 #7: FaceTime PiP

重新创造 iOS FaceTime 应用中的 picture-in-picture UI。

![](https://cdn-images-1.medium.com/max/1600/1*zHlr_QAPv7YpEF5wb6YZAQ.gif)

#### 核心功能

1.  轻量，轻快的交互
2.  投影位置是基于 `UIScrollView` 的减速速率。
3.  有遵循手势最初速度的持续动画。

#### 关键代码

我们最终的目的是写一些这样的代码。

```
let params = UISpringTimingParameters(damping: 1, response: 0.4, initialVelocity: relativeInitialVelocity)

let animator = UIViewPropertyAnimator(duration: 0, timingParameters: params)

animator.addAnimations {
    self.pipView.center = nearestCornerPosition
}

animator.startAnimation()
```

我们希望创建一个带有初始速度的动画，并且与拖拽手势的速度相匹配。并且进行 pip 动画到最近的角落。

首先，我们需要计算初始速度。

为了能做到这个，我们需要计算基于目前速度，目前为止和目标为止的相对速度。

```
let relativeInitialVelocity = CGVector(
    dx: relativeVelocity(forVelocity: velocity.x, from: pipView.center.x, to: nearestCornerPosition.x),
    dy: relativeVelocity(forVelocity: velocity.y, from: pipView.center.y, to: nearestCornerPosition.y)
)

func relativeVelocity(forVelocity velocity: CGFloat, from currentValue: CGFloat, to targetValue: CGFloat) -> CGFloat {
    guard currentValue - targetValue != 0 else { return 0 }
    return velocity / (targetValue - currentValue)
}
```

我们可以将速度分解为 x 和 y 两部分，并且决定它们各自的相对速度。

下一步，我们为 PiP 动画计算各个角落。

为了让我们的交互界面感觉自然并且轻量，我们要基于它现在的移动来投影 PiP 的最终位置。如果 PiP 可以滑动并且停止，它最终停在哪里？

```
let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
let velocity = recognizer.velocity(in: view)
let projectedPosition = CGPoint(
    x: pipView.center.x + project(initialVelocity: velocity.x, decelerationRate: decelerationRate),
    y: pipView.center.y + project(initialVelocity: velocity.y, decelerationRate: decelerationRate)
)
let nearestCornerPosition = nearestCorner(to: projectedPosition)
```

我们可以使用 `UIScrollView` 的减速速率来计算剩下的位置。这很重要，因为它与用户滑动的肌肉记忆相关。如果一个用户知道一个视图需要滚动多远，他们可以使用之前的知识直觉地猜测 PiP 到最终目标需要多大力。

这个减速速率也是很宽泛的，让交互感到轻量——只需要一个小小的推动就可以送 PiP 飞到屏幕的另一端。

我们可以使用“设计流畅的交互界面”分享中的投影方法来计算最终的投影位置。

```
/// Distance traveled after decelerating to zero velocity at a constant rate.
func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
    return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate)
}
```

最后缺失的一块就是基于投影位置找到最近的角落的逻辑。我们可以循环所有角落的位置并且找到一个和投影位置距离最小的角落。

```
func nearestCorner(to point: CGPoint) -> CGPoint {
    var minDistance = CGFloat.greatestFiniteMagnitude
    var closestPosition = CGPoint.zero
    for position in pipPositions {
        let distance = point.distance(to: position)
        if distance < minDistance {
            closestPosition = position
            minDistance = distance
        }
    }
    return closestPosition
}
```

总结最终的实现：我们使用了 `UIScrollView` 的减速速率来投影 pip 的运动到它最终的位置，并且计算了相对速度传入了 `UISpringTimingParameters`。

### 交互界面 #8: 旋转

将 PiP 的原理应用到一个旋转动画。

![](https://cdn-images-1.medium.com/max/1600/1*jL07YlwI-5skQGkc4W8OeQ.gif)

#### 核心功能

1.  使用投影来遵循手势的速度。
2.  永远停在一个有效的方向。

#### 关键代码

这里的代码和前面的 PiP 很像。 我们会使用同样的构造回调，除了将 `nearestCorner` 方法换成 `closestAngle`。

```
func project(...) { ... }

func relativeVelocity(...) { ... }

func closestAngle(...) { ... }
```

当最终是时候创建一个 `UISpringTimingParameters`，针对初始速度，我们是需要使用一个 `CGVector`，即使我们的旋转只有一个维度。任何情况下，如果动画属性只有一个维度，将 `dx` 值设为期望的速度，将 `dy` 值设为 0.

```
let timingParameters = UISpringTimingParameters(  
    damping: 0.8,  
    response: 0.4,  
    initialVelocity: CGVector(dx: relativeInitialVelocity, dy: 0)  
)
```

在内部，动画会忽略 `dy` 的值而使用 `dx` 的值来创建时间曲线。

### 自己试一试！

这些交互在真机上更有趣。要自己玩一下这些交互的，这个是 demo 应用，可以在 [GitHub](https://github.com/nathangitter/fluid-interfaces) 上获取到。

![](https://cdn-images-1.medium.com/max/2000/1*7gS4SLe571r7RZvpps3X9A.png)

流畅的交互界面 demo 应用，可以在 GitHub 上获取！

### 实际应用

#### 对于设计师

1.  把交互界面考虑成流程的表达中介，而不是一些固定元素的组合。
2.  在设计流程早期就考虑动画和手势。Sketch 这些排版工具是很好用的，但是并不会像设备一样提供完整的表现。
3.  跟开发工程师进行原型展示。让有设计思维的开发工程师帮助你开发原型的动画，手势和触觉反馈。

#### 对于开发工程师

1.  将这些建议应用到你自己开发的自定义交互组件上。考虑如何更有趣的将它们结合到一起。
2.  教育你的设计师关于这些新的可能。许多设计师没有意识到 3D touch，触觉反馈，手势和弹簧动画的真正力量。
3.  与设计师一起演示原型。帮助他们在真机上查看自己的设计，并且创建一些工具帮助他们，来让设计更加的有效率。

* * *

如果你喜欢这篇文章，请留下一些鼓掌。 👏👏👏

**你可以点击鼓掌 50 次！**, 所以赶快点啊！ 😉

请将这篇文章在社交媒体上分享给你的 iOS 设计师/iOS 开发工程师朋友。

如果你喜欢这种内容，你应该在 Twitter 上关注我。 我只发高质量的内容。[twitter.com/nathangitter](https://twitter.com/nathangitter)

感谢 [David Okun](https://twitter.com/dokun24) 校验。

感谢 [Christian Schnorr](https://medium.com/@jenoxx?source=post_page) 和 [David Okun](https://medium.com/@davidokun?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
