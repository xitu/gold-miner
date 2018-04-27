> * 原文地址：[Prototyping Animations in Swift](https://medium.com/s23nyc-tech/prototyping-animations-in-swift-97a9cfb1f41b)
> * 原文作者：[Jason Wilkin](https://medium.com/@jason_wilkin?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/prototyping-animations-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/prototyping-animations-in-swift.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：[talisk](https://github.com/talisk)、[melon8](https://github.com/melon8)

# 使用 Swift 实现原型动画

关于开发移动应用，我最喜欢作的事情之一就是让设计师的创作活跃起来。我想成为 iOS 开发者的原因之一就是能够利用 iPhone 的力量，创造出友好的用户体验。因此，当 s23NYC 的设计团队带着 SNKRS Pass 的动画原型来到我面前时，我既兴奋同时又非常害怕：

![](https://cdn-images-1.medium.com/max/800/1*3HOg8B2Wgg8aYx-jt3VJkw.gif)

应该从哪里开始呢？当看到一个复杂的动画模型时，这可能是一个令人头疼的问题。在这篇文章中，我们将分解一个动画和原型迭代来开发一个可复用的动画波浪视图。

* * *

### 在 Playground 中的原型设计

在我们开始之前，我们需要建立一个环境，在这个环境中，我们可以迅速设计我们的动画原型，而不必不断地构建和运行我们所做的每一个细微的变化。幸运的是，苹果给我们提供了 Swift Playground，这是一个很好的能够快速草拟前端代码的理想场所，而无需使用完整的应用容器。

通过菜单栏中选择 File > New > Playground…，让我们在 Xcode 创建一个新的 Playground。选择**单视图** Playground 模板，里面写好了一个 live view 的模版代码。我们需要确保选择 Assistant Editor，以便我们的代码能够实时更新。

![](https://cdn-images-1.medium.com/max/800/1*-zmk2zyLGlQQUJPBO3JCbg.png)

### 水波动画

我们正在制作的这个动画是 SNKRS Pass 体验的最后部分之一，这是一种新的方式，可以在零售店预定最新和最热门的耐克鞋。当用户去拿他们的鞋子时，我们想给他们一张数字通行证，感觉就像一张金色的门票。背景动画的目的是模仿立体物品的真实性。当用户倾斜该设备时，动画会作出反应并四处移动，就像光线从设备上反射出来一样。

让我们从简单地创建一些同心圆开始：

```
final class AnimatedWaveView: UIView {
    
    public func makeWaves() {
        var i = 1
        let baseDiameter = 25
        var rect = CGRect(x: 0, y: 0, width: baseDiameter, height: baseDiameter)
        // Continue adding waves until the next wave would be outside of our frame
        while self.frame.contains(rect) {
            let waveLayer = buildWave(rect: rect)
            self.layer.addSublayer(waveLayer)
            i += 1
            // Increase size of rect with each new wave layer added
            rect = CGRect(x: 0, y: 0, width: baseDiameter * i, height: baseDiameter * i)
        }
    }
    
    private func buildWave(rect: CGRect) -> CAShapeLayer {
        let circlePath = UIBezierPath(ovalIn: rect)
        let waveLayer = CAShapeLayer()
        waveLayer.bounds = rect
        waveLayer.frame = rect
        waveLayer.position = self.center
        waveLayer.strokeColor = UIColor.black.cgColor
        waveLayer.fillColor = UIColor.clear.cgColor
        waveLayer.lineWidth = 2.0
        waveLayer.path = circlePath.cgPath
        waveLayer.strokeStart = 0
        waveLayer.strokeEnd = 1
        return waveLayer
    }
}
```

![](https://cdn-images-1.medium.com/max/800/1*HyJxGRHIus_TkVvL2uW5MA.png)

这非常简单。现在如何将同心圆不停地向外扩大呢？我们将使用 CAAnimation 和 Timer 不断添加 CAShape，并让它们动起来。这个动画有两个部分：缩放形状的路径和增加形状的边界。重要的是，通过缩放变换对边界做动画，使圆圈移动最终充满屏幕。如果我们没有执行边界的动画，圆圈将不断扩大，但会保持其视图的原点在视图的中心（向右下角扩展）。因此，让我们将这两个动画添加到一个动画组，以便同时执行它们。记住，CAShape 和 CAAnimation 需要将 UIKit 的值转换为它们的 CGPath 和 CGColor 计数器。否则，动画就会悄无声息地失败！我们还将使用 CAAnimation 放入委托方法 animationDidStop 在动画完成后从视图中删除形状图层。

```
final class AnimatedWaveView: UIView {
    
    private let baseRect = CGRect(x: 0, y: 0, width: 25, height: 25)
    
    public func makeWaves() {
        DispatchQueue.main.async {
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.addAnimatedWave), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func addAnimatedWave() {
        let waveLayer = self.buildWave(rect: baseRect)
        self.layer.addSublayer(waveLayer)
        self.animateWave(waveLayer: waveLayer)
    }
    
    private func buildWave(rect: CGRect) -> CAShapeLayer {
        let circlePath = UIBezierPath(ovalIn: rect)
        let waveLayer = CAShapeLayer()
        waveLayer.bounds = rect
        waveLayer.frame = rect
        waveLayer.position = self.center
        waveLayer.strokeColor = UIColor.black.cgColor
        waveLayer.fillColor = UIColor.clear.cgColor
        waveLayer.lineWidth = 2.0
        waveLayer.path = circlePath.cgPath
        waveLayer.strokeStart = 0
        waveLayer.strokeEnd = 1
        return waveLayer
    }
    
    private let scaleFactor: CGFloat = 1.5
    
    private func animateWave(waveLayer: CAShapeLayer) {
        // 缩放动画
        let finalRect = self.bounds.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        let finalPath = UIBezierPath(ovalIn: finalRect)
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = waveLayer.path
        animation.toValue = finalPath.cgPath
        
        // 边界动画
        let posAnimation = CABasicAnimation(keyPath: "bounds")
        posAnimation.fromValue = waveLayer.bounds
        posAnimation.toValue = finalRect
        
        // 动画组
        let scaleWave = CAAnimationGroup()
        scaleWave.animations = [animation, posAnimation]
        scaleWave.duration = 10
        scaleWave.setValue(waveLayer, forKey: "waveLayer")
        scaleWave.delegate = self
        scaleWave.isRemovedOnCompletion = true
        waveLayer.add(scaleWave, forKey: "scale_wave_animation")
    }
}

extension AnimatedWaveView: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let waveLayer = anim.value(forKey: "waveLayer") as? CAShapeLayer {
            waveLayer.removeFromSuperlayer()
        }
    }
}
```

![](https://cdn-images-1.medium.com/max/800/0*S_Gt_5S6BNy3fdIE.)

接下来，我们将为自定义路径更替圆形。为了生成自定义路径，我们可以使用 [PaintCode](https://www.paintcodeapp.com/) 来帮助生成代码。在这篇文章中，我们将使用一个星形的波纹路径：

```
struct StarBuilder {
    static func buildStar() -> UIBezierPath {
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 12.5, y: 0))
        starPath.addLine(to: CGPoint(x: 14.82, y: 5.37))
        starPath.addLine(to: CGPoint(x: 19.85, y: 2.39))
        starPath.addLine(to: CGPoint(x: 18.57, y: 8.09))
        starPath.addLine(to: CGPoint(x: 24.39, y: 8.64))
        starPath.addLine(to: CGPoint(x: 20, y: 12.5))
        starPath.addLine(to: CGPoint(x: 24.39, y: 16.36))
        starPath.addLine(to: CGPoint(x: 18.57, y: 16.91))
        starPath.addLine(to: CGPoint(x: 19.85, y: 22.61))
        starPath.addLine(to: CGPoint(x: 14.82, y: 19.63))
        starPath.addLine(to: CGPoint(x: 12.5, y: 25))
        starPath.addLine(to: CGPoint(x: 10.18, y: 19.63))
        starPath.addLine(to: CGPoint(x: 5.15, y: 22.61))
        starPath.addLine(to: CGPoint(x: 6.43, y: 16.91))
        starPath.addLine(to: CGPoint(x: 0.61, y: 16.36))
        starPath.addLine(to: CGPoint(x: 5, y: 12.5))
        starPath.addLine(to: CGPoint(x: 0.61, y: 8.64))
        starPath.addLine(to: CGPoint(x: 6.43, y: 8.09))
        starPath.addLine(to: CGPoint(x: 5.15, y: 2.39))
        starPath.addLine(to: CGPoint(x: 10.18, y: 5.37))
        starPath.close()
        return starPath
    }
}
```

![](https://cdn-images-1.medium.com/max/800/1*plbhAHOZPINSokz4MARg8w.png)

（不按比例）

使用自定义路径的棘手之处在于，我们现在需要扩展这条路径，而不是从 AnimatedWaveView 的边界生成一个最终的圆路径。因为我们希望这个视图是可以重用的，所以我们需要计算基于最终目标 rect 的形状的路径和边界的大小。我们可以根据路径最终边界与其最初边界的比例来创建 CGAffineTransform。我们还将这个比例乘以 2.25 的比例因子，以便在完成之前路径扩展大于视图。我们还需要将形状完全填充我们视图的每个角落，而不是一旦到达视图的大小就消失。让我们在初始化期间构建初始路径和最终路径，并在视图的框架发生改变时，更新最终路径:

```
private let initialPath: UIBezierPath = StarBuilder.buildStar()
private var finalPath: UIBezierPath = StarBuilder.buildStar()

let scaleFactor: CGFloat = 2.25

override var frame: CGRect {
    didSet {
        self.finalPath = calculateFinalPath()
    }
}

override init(frame: CGRect) {
    super.init(frame: frame)
    self.finalPath = calculateFinalPath()
}

private func calculateFinalPath() -> UIBezierPath {
    let path = StarBuilder.buildStar()
    let scaleTransform = buildScaleTransform()
    path.apply(scaleTransform)
    return path
}

private func buildScaleTransform() -> CGAffineTransform {
    // Grab initial and final shape diameter
    let initialDiameter = self.initialPath.bounds.height
    let finalDiameter = self.frame.height
    // Calculate the factor by which to scale the shape.
    let transformScaleFactor = finalDiameter / initialDiameter * scaleFactor
    // Build the transform
    return CGAffineTransform(scaleX: transformScaleFactor, y: transformScaleFactor)
}
```
在更新动画组后，使用新的 **finalPath** 属性、 **initialPath** 和内部的 **buildWave()** 方法，我们会得到一个更新的路径动画：

![](https://cdn-images-1.medium.com/max/800/1*W7v-DukdmbIgkVf3htpTMQ.gif)

确保我们可以在不同的大小能重用水波动画的最后一步是：重构定时器方法。而不是一直创建新的水波，我们可以一次性创建所有的波纹，同时用 CAAnimation 错开时间来执行动画。这可以通过 CAAnimation 组中设置 **timeoffset** 来实现。通过给每个动画组一个稍微不同的 **timeoffset**，我们可以从不同的起点同时运行所有动画。我们将用动画的总持续时间除以屏幕上的波数来计算偏移量：

```
// 每波之间 7 个像素点
fileprivate let waveIntervals: CGFloat = 7

// 当直径为 667 时，定时比为 40 秒。
fileprivate let timingRatio: CFTimeInterval = 40.0 / 667.0

public func makeWaves() {
  
    // 获得较大的宽度或高度值
    let diameter = self.bounds.width > self.bounds.height ? self.bounds.width : self.bounds.height

    // 计算半径减去初始 rect 的宽度
    let radius = (diameter - baseRect.width) / 2

    // 把半径除以每个波的长度
    let numberOfWaves = Int(radius / waveIntervals)

    // 持续时间需要根据直径来进行更改，以便在任何视图大小下动画速度都是相同的。
    let animationDuration = timingRatio * Double(diameter)

    for i in 0 ..< numberOfWaves {
        let timeOffset = Double(i) * (animationDuration / Double(numberOfWaves))
        self.addAnimatedWave(timeOffset: timeOffset, duration: animationDuration)
    }
}

private func addAnimatedWave(timeOffset: CFTimeInterval, duration: CFTimeInterval) {
    let waveLayer = self.buildWave(rect: baseRect, path: initialPath.cgPath)
    self.layer.addSublayer(waveLayer)
    self.animateWave(waveLayer: waveLayer, duration: duration, offset: timeOffset)
}
```

我们将 **duration** 和 **timeOffset** 作为参数传给 **animateWave()** 方法。让我们添加一个淡入动画作为组合的一部分，让动画变得更加流畅：

```
private func animateWave(waveLayer: CAShapeLayer, duration: CFTimeInterval, offset: CFTimeInterval) {
    // 淡入动画
    let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
    fadeInAnimation.fromValue = 0
    fadeInAnimation.toValue = 0.9
    fadeInAnimation.duration = 0.5

    // 路径动画
    let pathAnimation = CABasicAnimation(keyPath: "path")
    pathAnimation.fromValue = waveLayer.path
    pathAnimation.toValue = finalPath.cgPath

    // 边界动画
    let boundsAnimation = CABasicAnimation(keyPath: "bounds")
    let scaleTransform = buildScaleTransform()
    boundsAnimation.fromValue = waveLayer.bounds
    boundsAnimation.toValue = waveLayer.bounds.applying(scaleTransform)

    // 动画组合
    let scaleWave = CAAnimationGroup()
    scaleWave.animations = [fadeInAnimation, boundsAnimation, pathAnimation]
    scaleWave.duration = duration
    scaleWave.isRemovedOnCompletion = false
    scaleWave.repeatCount = Float.infinity
    scaleWave.fillMode = kCAFillModeForwards
    scaleWave.timeOffset = offset
    waveLayer.add(scaleWave, forKey: waveAnimationKey)
}
```

现在，我们可以在调用 **makewaves()** 方法来同时绘制每个波形并添加动画。让我们来看看效果：

![](https://cdn-images-1.medium.com/max/800/1*NKetxE_MBLhJrpiOgj4rHg.gif)

喔呼！我们现在有一个可复用的动画波浪视图！

### 添加渐变

下一步是通过添加一个渐变来改进我们的水波动画。我们还希望渐变能随设备移动传感器一起变化，因此我们将创建一个渐变层并保持对它的引用。我将半透明的水波层放在渐变的上面，但最好的解决方案是将所有水波层边加到一个父层里，并将这个父层其设置为渐变层的遮罩。通过这种方法，父层会自己去绘制渐变，这看起来更有效：

![](https://cdn-images-1.medium.com/max/800/1*BF921yl9t9RX0agWCnNWrA.gif)

```
private func buildWaves() -> [CAShapeLayer] {
        
    // 获得较大的宽度或高度值
    let diameter = self.bounds.width > self.bounds.height ? self.bounds.width : self.bounds.height

    // 计算半径减去初始 rect 的宽度
    let radius = (diameter - baseRect.width) / 2

    // 把半径除以每个波的长度
    let numberOfWaves = Int(radius / waveIntervals)

    // 持续时间需要根据直径来进行更改，以便在任何视图大小下动画速度都是相同的。
    let animationDuration = timingRatio * Double(diameter)

    var waves: [CAShapeLayer] = []
    for i in 0 ..< numberOfWaves {
        let timeOffset = Double(i) * (animationDuration / Double(numberOfWaves))
        let wave = self.buildAnimatedWave(timeOffset: timeOffset, duration: animationDuration)
        waves.append(wave)
    }

    return waves
}

public func makeWaves() {
    let waves = buildWaves()
    let maskLayer = CALayer()
    maskLayer.backgroundColor = UIColor.clear.cgColor
    waves.forEach { maskLayer.addSublayer($0) }
    self.addGradientLayer(withMask: maskLayer)
    self.setNeedsDisplay()
}

private func addGradientLayer(withMask maskLayer: CALayer) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.black.cgColor, UIColor.lightGray.cgColor, UIColor.white.cgColor]
    gradientLayer.mask = maskLayer
    gradientLayer.frame = self.frame
    gradientLayer.bounds = self.bounds
    self.layer.addSublayer(gradientLayer)
}

private func buildAnimatedWave(timeOffset: CFTimeInterval, duration: CFTimeInterval) -> CAShapeLayer {
    let waveLayer = self.buildWave(rect: baseRect, path: initialPath.cgPath)
    self.animateWave(waveLayer: waveLayer, duration: duration, offset: timeOffset)
    return waveLayer
}
```

### 运动追踪

下一步是要将渐变动画化，使之与设备运动跟踪。我们想要创造一种全息效果，当你将它倾斜在手中时，它能模仿反射在视图表面的光。为此，我们将添加一个围绕视图中心旋转的渐变。我们将使用 CoreMotion 和 CMMotionManager 跟踪加速度计的实时更新，并将此数据用于交互式动画。如果你想深入了解 CoreMotion 所提供的内容，NSHipster 上有[一篇很棒的关于 CMDeviceMotion 的文章](http://nshipster.com/cmdevicemotion/)。对于我们的 AnimatedWaveView，我们只需 CMDeviceMoving 中的  **gravity** 属性（CMAcceleration），它将返回设备的加速度。当用户水平和垂直地倾斜设备时，我们只需要跟踪 X 和 Y 轴：

![](https://cdn-images-1.medium.com/max/800/1*f_KMSGaHGcgAV6_W_OP6NQ.png)

[https://developer.apple.com/documentation/coremotion/getting_raw_accelerometer_events#2904020](https://developer.apple.com/documentation/coremotion/getting_raw_accelerometer_events#2904020)

 X 和 Y 会是从 -1 到 +1 之间的值，以(0，0)为原点（设备平放在桌子上，面朝上）。现在我们要如何使用这些数据？

起初，我尝试使用 CAGradientLayer，并认为旋转渐变后会产生这种闪光效果。我们可以根据 CMDeviceMotion 的 **gravity** 来更新它的 **startPoint** 和 **endPoint**。Cagradientlayer 是一个线性渐变，因此围绕中心的旋转 **startPoint** 和 **endPoint** 将有效地旋转渐变。让我们把 x 和 y 值从 **gravity** 转换成我们用来旋转渐变的程度值：

```
fileprivate let motionManager = CMMotionManager()

func trackMotion() {
    if motionManager.isDeviceMotionAvailable {
        // 设置动作回调触发的频率（秒为单位）
        motionManager.deviceMotionUpdateInterval = 2.0 / 60.0
        let motionQueue = OperationQueue()
        motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: { [weak self] (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else { return }
            // 水平倾斜设备会对闪烁效果影响更大
            let xValBooster: Double = 3.0
            // 将 x 和 y 值转换为弧度
            let radians = atan2(data.gravity.x * xValBooster, data.gravity.y)
            // 将弧度转换为度数
            var angle = radians * (180.0 / Double.pi)
            while angle < 0 {
                angle += 360
            }
            self?.rotateGradient(angle: angle)
        })  
    }
}
```

注意：我们不能在模拟器或 Playground 中模拟运动跟踪，因此要在 Xcode 项目中用真机进行测试。

在进行一些初步的设计测试之后，我们觉得有必要通过增加一个 booster 变量来改变 **gravity** 返回的 X 值，这样渐变层就会以更快的速度旋转。因此，在转换成弧度之前，我们要先乘以 **gravity.x**。 

为了能够让渐变层旋转，我们需要将设备旋转的角度转换为旋转弧的起点和终点：渐变的 **startPoint** 和 **endPoint**。StackOverflow 上有一个非常棒的解决方法，我们可以用来实现一下：

```
fileprivate func rotateGradient(angle: Float) {
    DispatchQueue.main.async {
        // https://stackoverflow.com/questions/26886665/defining-angle-of-the-gradient-using-cagradientlayer
        let alpha: Float = angle / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        self.gradientLayer.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        self.gradientLayer.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
    }
}
```

拿出一些三角学的知识！现在，我们已经将度数转换会新的 **startPoint** 和 **endPoint** 。

![](https://cdn-images-1.medium.com/max/800/1*l_V_LhGj645oaObSZUhfTw.gif)

这没什么……但我们能做得更好吗？那是必须的。让我们进入下一个阶段……

CAGradientLayer 不支持径向渐变……但这并不意味着这是不可能的！我们可以使用 CGGradient 创建我们自己的 CALayer 类 RadialGradientLayer。这里棘手的部分就是要确保在 CGGradient 初始化期间需要将一个 CGColor 数组强制转换为一个 CFArray。这需要一直反复的尝试，才能准确地找出需要将哪种类型的数组转换为 CFArray，并且这些位置可能只是一个用来满足 `UnaspectPoint<CGFloat>?` 类型的 CGFloat 数组。

```
class RadialGradientLayer: CALayer {
    
    var colors: [CGColor] = []
    var center: CGPoint = CGPoint.zero
    
    override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    init(colors: [CGColor], center: CGPoint) {
        self.colors = colors
        self.center = center
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 为每种颜色创建从 0 到 1 的一系列的位置（CGFloat 类型）。
        let step: CGFloat = 1.0 / CGFloat(colors.count)
        var locations = [CGFloat]()
        for i in 0 ..< colors.count {
            locations.append(CGFloat(i) * step)
        }
        
        // 创建 CGGradient 
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) else {
            ctx.restoreGState()
            return
        }
        let gradRadius = min(self.bounds.size.width, self.bounds.size.height)
        // 在 context 中绘制径向渐变，从中心开始，在视图边界结束。
        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: gradRadius, options: [])
        ctx.restoreGState()
    }
}
```

我们终于把所有的东西都准备好了！现在我们可以把 CAGradientLayer 替换成我们新的 RadialGradientLayer，并计算设备重力 x 和 y 到梯度坐标位置的映射。我们将重力值转换为在 0.0 和 1.0 之间浮点数，以计算如何移动渐变层。

```
private func trackMotion() {
    if motionManager.isDeviceMotionAvailable {
        // 设置动作回调触发的频率（秒为单位）
        motionManager.deviceMotionUpdateInterval = 2.0 / 60.0
        let motionQueue = OperationQueue()
        motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: { [weak self] (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else { return }
            // 将渐变层移动到新位置
            self?.moveGradient(x: data.gravity.x, y: data.gravity.y)
        })  
    }
}

private func moveGradient(gravityX: Double, gravityY: Double) {
    DispatchQueue.main.async {
        // 使用重力作为视图垂直或水平边界的百分比来计算新的 x 和 y
        let x = (CGFloat(gravityX + 1) * self.bounds.width) / 2
        let y = (CGFloat(-gravityY + 1) * self.bounds.height) / 2
        // 更新渐变层的中心位置
        self.gradientLayer.center = CGPoint(x: x, y: y)
        self.gradientLayer.setNeedsDisplay()
    }
}
```

现在让我们回到 **makeWaves** 和 **addGradientLayer** 方法，并确保所有工作准备就绪：

```
private var gradientLayer = RadialGradientLayer()

public func makeWaves() {
    let waves = buildWaves()
    let maskLayer = CALayer()
    maskLayer.backgroundColor = UIColor.clear.cgColor
    waves.forEach({ maskLayer.addSublayer($0) })
    addGradientLayer(withMask: maskLayer)
    trackMotion()
}

private func addGradientLayer(withMask maskLayer: CALayer) {
    let colors = gradientColors.map({ $0.cgColor })
    gradientLayer = RadialGradientLayer(colors: colors, center: self.center)
    gradientLayer.mask = maskLayer
    gradientLayer.frame = self.frame
    gradientLayer.bounds = self.bounds
    self.layer.addSublayer(gradientLayer)
}
```

下面激动的时刻来临了……

此处视频请到[原文](https://medium.com/s23nyc-tech/prototyping-animations-in-swift-97a9cfb1f41b)查看。

现在，是非常顺畅的！

附件是最后一个示例项目的完整工程，所有的代码处于最终状态。我推荐你试着在设备上运行，好好地玩下！

* [**j-wilkin/AnimatedWaveView**: AnimatedWaveView - An interactive wave animation view built in Swift](https://github.com/j-wilkin/AnimatedWaveView)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
