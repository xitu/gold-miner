> * 原文地址：[Prototyping Animations in Swift](https://medium.com/s23nyc-tech/prototyping-animations-in-swift-97a9cfb1f41b)
> * 原文作者：[Jason Wilkin](https://medium.com/@jason_wilkin?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/prototyping-animations-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/prototyping-animations-in-swift.md)
> * 译者：
> * 校对者：

# Prototyping Animations in Swift

One of my favorite things about building mobile applications is bringing a designer’s creation to life. Being able to harness the power of the iPhone and create experiences that delight users is one of the reasons I wanted to become an iOS developer. So when the design team at s23NYC came to me with the animation prototype for SNKRS Pass I was excited but also very scared:

![](https://cdn-images-1.medium.com/max/800/1*3HOg8B2Wgg8aYx-jt3VJkw.gif)

Where to begin? It can be a daunting question when looking at a complex animation mock-up. In this blog post we will break down an animation into pieces and prototype iteratively to build a reusable, animated wave view.

* * *

### Prototyping in a Playground

Before we dive in, it will be useful to setup an environment where we can rapidly prototype our animation without having to continuously build and run with every small change we make. Luckily, Apple gave us Swift Playgrounds, which is the perfect place to sketch out front-end code quickly without having to use a full application container.

Let’s create a new Playground in Xcode by selecting File > New > Playground… from the menu bar. We can choose the **Single View** playground template to get the Playground live view code written for us in a nice template. We’ll make sure to select the Assistant Editor so that we can see live updates as we code.

![](https://cdn-images-1.medium.com/max/800/1*-zmk2zyLGlQQUJPBO3JCbg.png)

### Animating Waves

This animation we’re building is one of the final parts of the SNKRS Pass experience, which is a new way to reserve access to the newest and hottest Nike shoes at retail stores. When a user goes to pick up their shoes, we want to give them a digital pass that feels like a golden ticket. The background animation is meant to mimic a holographic sticker of authenticity. When the user tilts the device, the animation reacts, and moves around as if a light is reflecting off of it.

Let’s start very simply by creating some concentric circles:

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

Easy enough. Now how to animate these outwards? We’ll make use of CAAnimation and Timer to continuously add and animate these CAShapes. There are two parts to this animation: scaling the shape’s path and increasing the shape’s bounds. It’s important to animate the bounds in tandem with a scale transform on the shape so that the circle moves to fill the screen. If we don’t animate the bounds, the circles would expand while keeping their initial origin at the center of the view (expanding down to the lower right corner). So let’s add both of these animations to an animation group to perform them at the same time. It’s important to remember that CAShape and CAAnimation require converting UIKit values to their CGPath and CGColor counter parts. Otherwise, the animation will just fail silently! We’ll also make use of the CAAnimation delegate method animationDidStop to remove the shape layer from the view once its animation completes.

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
        // Scaling animation
        let finalRect = self.bounds.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        let finalPath = UIBezierPath(ovalIn: finalRect)
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = waveLayer.path
        animation.toValue = finalPath.cgPath
        
        // Bounds animation
        let posAnimation = CABasicAnimation(keyPath: "bounds")
        posAnimation.fromValue = waveLayer.bounds
        posAnimation.toValue = finalRect
        
        // Group
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

Trippy! Next, we will swap out the circles for our custom path. In order to generate a custom path, we can use [PaintCode](https://www.paintcodeapp.com/) to help generate code. In this blog post, we’ll be using a star shape for our wave path:

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

(Not to scale)

The tricky part with using a custom path is that we now need to scale this path instead of generating a final circle path from the bounds of the AnimatedWaveView. Since we want this view to be reusable, we need to calculate how much to scale the shape’s path and bounds based on the final destination rect. We can create a CGAffineTransform based on the ratio of the path’s final bounds to its initial bounds. We also multiply this ratio by the _scaleFactor_ of 2.25 so that the path expands larger than the view before completing. We need to do this so that the shape completely fills the corners of our view, rather than just disappearing once it reaches the view’s size. Let’s build the initial and final paths during initialization and update the final path if our view’s frame changes:

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
After updating our animation group to use our new _finalPath_ property and using the _initialPath_ inside _buildWave()_, we’ll have an updated path animation:

![](https://cdn-images-1.medium.com/max/800/1*W7v-DukdmbIgkVf3htpTMQ.gif)

The final piece to making sure we can reuse this wave animation in different sizes is to refactor the Timer approach. Rather than continuously creating new waves, we can create all of the waves at once and stagger the start time on CAAnimation. This is done by setting the _timeOffset_ on the CAAnimation group. By giving each animation group a slightly different _timeOffset_, we run all animations in parallel from different starting points. We will calculate the offset by dividing the total duration of the animation by the number of waves on screen:

```
// 7px between each wave
fileprivate let waveIntervals: CGFloat = 7

// Timing ratio is 40 seconds for a diameter of 667
fileprivate let timingRatio: CFTimeInterval = 40.0 / 667.0

public func makeWaves() {
  
    // Get the greater value of width or height
    let diameter = self.bounds.width > self.bounds.height ? self.bounds.width : self.bounds.height

    // Calculate radus substracting the initial starting rect
    let radius = (diameter - baseRect.width) / 2

    // Divide radius up by each wave
    let numberOfWaves = Int(radius / waveIntervals)

    // Duration needs to change based on diameter so that the animation speed is the same for any view size
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

We’ll pass the _duration_ and _timeOffset_ down to the _animateWave()_ method. Let’s add in a fade-in animation as part of the group to make things a bit smoother:

```
private func animateWave(waveLayer: CAShapeLayer, duration: CFTimeInterval, offset: CFTimeInterval) {
    // Fade-in animation
    let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
    fadeInAnimation.fromValue = 0
    fadeInAnimation.toValue = 0.9
    fadeInAnimation.duration = 0.5

    // Path animation
    let pathAnimation = CABasicAnimation(keyPath: "path")
    pathAnimation.fromValue = waveLayer.path
    pathAnimation.toValue = finalPath.cgPath

    // Bounds animation
    let boundsAnimation = CABasicAnimation(keyPath: "bounds")
    let scaleTransform = buildScaleTransform()
    boundsAnimation.fromValue = waveLayer.bounds
    boundsAnimation.toValue = waveLayer.bounds.applying(scaleTransform)

    // Animation Group
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

Now we can draw each waves and add animations all at once when calling _makeWaves()._ Let’s take a look at our hard work:

![](https://cdn-images-1.medium.com/max/800/1*NKetxE_MBLhJrpiOgj4rHg.gif)

Woohoo! We now have a reusable animated wave view!

### Adding a Gradient

The next step is to improve our wave animation by adding a gradient. We’d also like to animate the gradient in relation to device motion, so we will create a gradient layer and keep a reference to it. I explored putting semi-transparent wave layers on top of the gradient but the best solution was to add the wave layers to a parent layer and set it as the mask of the gradient layer. With this approach, the parent layer draws the gradient itself, which looks much more effective:

![](https://cdn-images-1.medium.com/max/800/1*BF921yl9t9RX0agWCnNWrA.gif)

```
private func buildWaves() -> [CAShapeLayer] {
        
    // Get the greater value of width or height
    let diameter = self.bounds.width > self.bounds.height ? self.bounds.width : self.bounds.height

    // Calculate radus substracting the initial starting rect
    let radius = (diameter - baseRect.width) / 2

    // Divide radius up by each wave
    let numberOfWaves = Int(radius / waveIntervals)

    // Duration needs to change based on diameter so that the animation speed is the same for any view size
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

### Motion Tracking

The next step is animating the gradient to move in correlation with device motion tracking. We want to create a holographic effect that mimics light reflecting against the surface of the view as you tilt it in your hands. To achieve this, we will add a gradient which rotates around the center of the view. We will use CoreMotion and the CMMotionManager to track accelerometer updates and use this data for our interactive animation. NSHipster has a [fantastic write-up on CMDeviceMotion](http://nshipster.com/cmdevicemotion/) if you’re looking for a deeper dive into what CoreMotion has to offer. For our AnimatedWaveView, we will only need the CMDeviceMotion _gravity_ property (CMAcceleration) which will give us the acceleration velocity of the device. We will only need to track the X and Y axis as the user tilts the device horizontally and vertically:

![](https://cdn-images-1.medium.com/max/800/1*f_KMSGaHGcgAV6_W_OP6NQ.png)

[https://developer.apple.com/documentation/coremotion/getting_raw_accelerometer_events#2904020](https://developer.apple.com/documentation/coremotion/getting_raw_accelerometer_events#2904020)

So X and Y will be from -1 to +1 with (0,0) being the origin (device resting flat on a table face up). Now how do we want to use this data?

At first, I tried using CAGradientLayer and thought rotating the gradient would create this shimmering effect. We could update its _startPoint_ and _endPoint_ based on the CMDeviceMotion _gravity_. CAGradientLayer is a linear gradient, so revolving _startPoint_ and _endPoint_ around the center will effectively rotate the gradient. Let’s convert the X and Y values from _gravity_ to the degree value we would use to rotate the gradient:

```
fileprivate let motionManager = CMMotionManager()

func trackMotion() {
    if motionManager.isDeviceMotionAvailable {
        // Set how often the motion call back will trigger (in seconds)
        motionManager.deviceMotionUpdateInterval = 2.0 / 60.0
        let motionQueue = OperationQueue()
        motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: { [weak self] (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else { return }
            // Tilting the device horizontally should have a greater effect on the shimmer
            let xValBooster: Double = 3.0
            // Convert the x and y values to radians
            let radians = atan2(data.gravity.x * xValBooster, data.gravity.y)
            // Convert radians to degrees
            var angle = radians * (180.0 / Double.pi)
            while angle < 0 {
                angle += 360
            }
            self?.rotateGradient(angle: angle)
        })  
    }
}
```

Note: We can’t simulate motion tracking in the simulator or in a Playground so we’ll need to switch to working in a Xcode project with a real device.

After some initial testing with design, we felt the need to add a booster to the X value returned from _gravity_ so that the gradient would rotate at a faster rate. So we multiply the _gravity.x_ before converting to radians.

To perform the rotation of the gradient, we’ll need to convert the angle at which the device is rotated to the start and end points of the rotation arc: _startPoint_ and _endPoint_ for the gradient. There is a really smart StackOverflow answer we can use to achieve this:

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

Busting out some trigonometry! Now we’ve converted degrees to our new _startPoint_ and _endPoint_.

![](https://cdn-images-1.medium.com/max/800/1*l_V_LhGj645oaObSZUhfTw.gif)

This is ok…but can we do better? Most definitely! Let’s take this to the next level…

CAGradientLayer doesn’t support radial gradients…but that doesn’t mean it can’t be done! We can use CGGradient to create our own CALayer class, RadialGradientLayer. The tricky part here is making sure to cast an array of CGColors to a CFArray during the initialization of the CGGradient. It took a bit of trial and error to figure out exactly what kind of array needed to be casted to a CFArray and that locations could simply be an array of CGFloats to satisfy the UnsafePointer<CGFloat>? Type.

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
        
        // Create a range of locations (CGFloats) from 0-1 for each color
        let step: CGFloat = 1.0 / CGFloat(colors.count)
        var locations = [CGFloat]()
        for i in 0 ..< colors.count {
            locations.append(CGFloat(i) * step)
        }
        
        // Create the CGGradient
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) else {
            ctx.restoreGState()
            return
        }
        let gradRadius = min(self.bounds.size.width, self.bounds.size.height)
        // Draw the radial gradient in the context, starting at the center and ending at view bounds
        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: gradRadius, options: [])
        ctx.restoreGState()
    }
}
```

At last we have all the pieces in place! Now we can swap out the CAGradientLayer for our shiny new RadialGradientLayer and calculate a mapping of device gravity X and Y to a coordinate position for the gradient. We’ll convert the gravity values to a float percentage between 0.0 and 1.0 to calculate how to move the gradient.

```
private func trackMotion() {
    if motionManager.isDeviceMotionAvailable {
        // Set how often the motion call back will trigger (in seconds)
        motionManager.deviceMotionUpdateInterval = 2.0 / 60.0
        let motionQueue = OperationQueue()
        motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: { [weak self] (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else { return }
            // Move the gradient to a new position
            self?.moveGradient(x: data.gravity.x, y: data.gravity.y)
        })  
    }
}

private func moveGradient(gravityX: Double, gravityY: Double) {
    DispatchQueue.main.async {
        // Use gravity as a percentage of the view's vertical/horizonal bounds to calculate new x & y
        let x = (CGFloat(gravityX + 1) * self.bounds.width) / 2
        let y = (CGFloat(-gravityY + 1) * self.bounds.height) / 2
        // Update gradient center position
        self.gradientLayer.center = CGPoint(x: x, y: y)
        self.gradientLayer.setNeedsDisplay()
    }
}
```

Now let’s circle back to the _makeWaves_ and _addGradientLayer_ method and make sure everything is connected together:

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

Drumroll please…

此处视频请到[原文](https://medium.com/s23nyc-tech/prototyping-animations-in-swift-97a9cfb1f41b)查看。

Now that’s pretty slick!

Attached is the the final example project with all of the code in its final state. I encourage you to try running this on a device and play around with it!

* [**j-wilkin/AnimatedWaveView**: AnimatedWaveView - An interactive wave animation view built in Swift](https://github.com/j-wilkin/AnimatedWaveView)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
