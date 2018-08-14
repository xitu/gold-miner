> * 原文地址：[Building Fluid Interfaces: How to create natural gestures and animations on iOS](https://medium.com/@nathangitter/building-fluid-interfaces-ios-swift-9732bb934bf5)
> * 原文作者：[Nathan Gitter](https://medium.com/@nathangitter?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-fluid-interfaces-ios-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-fluid-interfaces-ios-swift.md)
> * 译者：
> * 校对者：

# Building Fluid Interfaces

## How to create natural gestures and animations on iOS

At WWDC 2018, Apple designers presented a talk titled [“Designing Fluid Interfaces”](https://developer.apple.com/videos/play/wwdc2018/803/), explaining the design reasoning behind the gestural interface of iPhone X.

![](https://cdn-images-1.medium.com/max/1600/1*EZJGlfbTCPSEq7Exwjla1Q.png)

Apple’s WWDC18 presentation “Designing Fluid Interfaces”

It’s my favorite WWDC talk ever—I highly recommend it.

The talk provided some technical guidance, which is exceptional for a design presentation, but it was pseudo-code, leaving a lot of unknowns.

![](https://cdn-images-1.medium.com/max/1600/1*m_arQ47qnUvIFPNCHRxt7Q.png)

Some Swift-like code from the presentation.

If you try implement these ideas, you might notice a gap between inspiration and implementation.

My goal is to bridge this gap by providing working code examples of every major topic in the presentation.

![](https://cdn-images-1.medium.com/max/1600/1*zvcJzQnHtJRrDhvfV9XaYw.gif)

The eight (8) interfaces we will create. Buttons, springs, custom interactions, and more!

Here’s an outline of what we’ll cover:

1.  A brief summary of the “Designing Fluid Interfaces” talk.
2.  Eight fluid interfaces, the design theory behind them, and the code to build them.
3.  Applications for designers and developers.

### What are fluid interfaces?

A fluid interface might also be called “fast”, “smooth”, “natural”, or “magical”. It’s a frictionless experience that just feels “right”.

The WWDC presentation talks about fluid interfaces as “an extension of your mind” and “an extension of the natural world”. An interface is fluid when it behaves according to the way people think, not the way machines think.

### What makes them fluid?

Fluid interfaces are responsive, interruptible, and redirectable. Here’s an example of the swipe-to-go-home gesture on iPhone X:

![](https://cdn-images-1.medium.com/max/1600/1*XxdPbsgL9qeY4QXr1pztfw.gif)

Apps can be closed during their launch animation.

The interface immediately reacts to the user’s input, can be stopped at any point in the process, and can even change course midway.

### Why do we care about fluid interfaces?

1.  Fluid interfaces improve the user’s experience, making every interaction feel quick, lightweight, and meaningful.
2.  They give the user a feeling of control, which builds trust with your app and your brand.
3.  They are hard to build. A fluid interface is difficult to copy and can be a competitive advantage.

### The Interfaces

For the remainder of this post, I will show you how to build eight (8) interfaces which cover all the major topics in the presentation.

![](https://cdn-images-1.medium.com/max/1600/1*989Lsw_y9JcZsJrAVyxEEQ.png)

Icons representing the eight (8) interfaces we will build.

![](https://cdn-images-1.medium.com/max/2000/1*slFD9J80nOOOjm9dsn6aGQ.png)

### Interface #1: Calculator Button

This is a button that mimics the behavior of buttons in the iOS calculator app.

![](https://cdn-images-1.medium.com/max/1600/1*h-Y4Y6K8uxu1mZ6NYst4MA.gif)

#### Key Features

1.  Highlights instantly on touch.
2.  Can be tapped rapidly even when mid-animation.
3.  User can touch down and drag outside of the button to cancel the tap.
4.  User can touch down, drag outside, _drag back in_, and confirm the tap.

#### Design Theory

We want buttons that feel responsive, acknowledging to the user that they are functional. In addition, we want the action to be cancellable if the user decides against their action after they touched down. This allows users to make quicker decisions since they can perform actions in parallel with thought.

![](https://cdn-images-1.medium.com/max/1600/1*ccdkb04pc02QvnfYJtum8g.png)

Slides from the WWDC presentation showing how gestures in parallel with thought make actions faster.

#### Critical Code

The first step to create this button is to use a `UIControl` subclass, not a `UIButton` subclass. A `UIButton` would work fine, but since we are customizing the interaction, we won’t need any of its features.

```
CalculatorButton: UIControl {
    public var value: Int = 0 {
        didSet { label.text = “\(value)” }
    }
    private lazy var label: UILabel = { ... }()
}
```

Next, we will use `UIControlEvents` to assign functions to the various touch interactions.

```
addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
```

We group the `touchDown` and `touchDragEnter` events into a single “event” called `touchDown` , and we can group the `touchUpInside`, `touchDragExit`, and `touchCancel` events into a single event called `touchUp`.

(For a description of all available`UIControlEvents`, check out [the documentation](https://developer.apple.com/documentation/uikit/uicontrolevents?language=objc).)

This gives us two functions to handle the animations.

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

On `touchDown`, we cancel the existing animation if needed, and instantly set the color to the highlighted color (in this case a light gray).

On `touchUp`, we create a new animator and start the animation. Using a `UIViewPropertyAnimator` makes it easy to cancel the highlight animation.

(Side note: This is not the exact behavior of the buttons in the iOS calculator app, which allow a touch that began in a different button to activate it if the touch was dragged inside the button. In most cases, a button like the one I created here is the intended behavior for iOS buttons.)

### Interface #2: Spring Animations

This interface shows how a spring animation can be created by specifying a “damping” (bounciness) and “response” (speed).

![](https://cdn-images-1.medium.com/max/1600/1*S0s0LiggTJm1U44lC4kcfg.gif)

#### Key Features

1.  Uses “design-friendly” parameters.
2.  No concept of animation duration.
3.  Easily interruptible.

#### Design Theory

Springs make great animation models because of their speed and natural appearance. A spring animation starts incredibly quickly, spending most of its time gradually approaching its final state. This is perfect for creating interfaces that feel responsive—they spring to life!

A few additional reminders when designing spring animations:

1.  Springs don’t have to be springy. Using a damping value of 1 will create an animation that slowly comes to rest without any bounciness. Most animations should use a damping value of 1.
2.  Try to avoid thinking about duration. In theory, a spring never fully comes to rest, and forcing a duration on the spring can cause it to feel unnatural. Instead, play with the damping and response values until it feels right.
3.  Interruption is critical. Because springs spend so much of their time close to their final value, users may think the animation has completed and will try to interact with it again.

#### Critical Code

In UIKit, we can create a spring animation with a `UIViewPropertyAnimator` and a `UISpringTimingParameters` object. Unfortunately, there is no initializer that just takes a `damping` and `response`. The closest we can get is the `UISpringTimingParameters` initializer that takes a mass, stiffness, damping, and initial velocity.

```
UISpringTimingParameters(mass: CGFloat, stiffness: CGFloat, damping: CGFloat, initialVelocity: CGVector)
```

We would like to create a convenience initializer that takes a damping and response, and maps it to the required mass, stiffness, and damping.

With a little bit of physics, we can derive the equations we need:

![](https://cdn-images-1.medium.com/max/1600/1*G_83X45IJ6J8Cedkvue_WA.png)

Solving for the spring constant and damping coefficient.

With this result, we can create our own `UISpringTimingParameters` with exactly the parameters we desire.

```
extension UISpringTimingParameters {
    convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }
}
```

This is how we will specify spring animations for all other interfaces.

#### The Physics Behind Spring Animations

Want to go deeper on spring animations? Check out this incredible post by Christian Schnorr: [Demystifying UIKit Spring Animations](https://medium.com/ios-os-x-development/demystifying-uikit-spring-animations-2bb868446773).

![](https://cdn-images-1.medium.com/max/1600/1*NPFOJlbdIyjPXLYU4nJxUQ.png)

After reading his post, spring animations finally clicked for me. Huge shout-out to Christian for helping me understand the math behind these animations and for teaching me how to solve second-order differential equations.

### Interface #3: Flashlight Button

Another button, but with much different behavior. This mimics the behavior of the flashlight button on the lock screen of iPhone X.

![](https://cdn-images-1.medium.com/max/1600/1*nrzZVlSrZ7hhrxRe_Sl_bA.gif)

#### Key Features

1.  Requires an intentional gesture with 3D touch.
2.  Bounciness hints at the required gesture.
3.  Haptic feedback confirms activation.

#### Design Theory

Apple wanted to create a button that was easily and quickly accessible, but couldn’t be triggered accidentally. Requiring force pressure to activate the flashlight is a great choice, but lacks affordance and feedback.

In order to solve those problems, the button is springy and grows as the user applies force, hinting at the required gesture. In addition, there are two separate vibrations of haptic feedback: one when the required amount of force is applied, and another when the button activates as the force is reduced. These haptics mimic the behavior of a physical button.

#### Critical Code

To measure the amount of force being applied to the button, we can use the `UITouch` object provided in touch events.

```
override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    guard let touch = touches.first else { return }
    let force = touch.force / touch.maximumPossibleForce
    let scale = 1 + (maxWidth / minWidth - 1) * force
    transform = CGAffineTransform(scaleX: scale, y: scale)
}
```

We calculate a scale transform based on the current force, so that the button grows with increasing pressure.

Since the button could be pressed but not yet activated, we need to keep track of the button’s current state.

```
enum ForceState {
    case reset, activated, confirmed
}

private let resetForce: CGFloat = 0.4
private let activationForce: CGFloat = 0.5
private let confirmationForce: CGFloat = 0.49
```

Having the confirmation force be slightly lower than the activation force prevents the user from rapidly activating and de-activating the button by quickly crossing the force threshold.

For haptic feedback, we can use `UIKit`’s feedback generators.

```
private let activationFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

private let confirmationFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
```

Finally, for the bouncy animations, we can use a `UIViewPropertyAnimator` with the custom `UISpringTimingParameters` initializers we created before.

```
let params = UISpringTimingParameters(damping: 0.4, response: 0.2)
let animator = UIViewPropertyAnimator(duration: 0, timingParameters: params)
animator.addAnimations {
    self.transform = CGAffineTransform(scaleX: 1, y: 1)
    self.backgroundColor = self.isOn ? self.onColor : self.offColor
}
animator.startAnimation()
```

### Interface #4: Rubberbanding

Rubberbanding occurs when a view resists movement. An example is when a scrolling view reaches the end of its content.

![](https://cdn-images-1.medium.com/max/1600/1*y0jRo2TeJ9VtCZPmQxyRLw.gif)

#### Key Features

1.  Interface is always responsive, even when an action is invalid.
2.  De-synced touch tracking indicates a boundary.
3.  Amount of motion lessens further from the boundary.

#### Design Theory

Rubberbanding is a great way to communicate invalid actions while still giving the user a sense of control. It softly indicates a boundary, pulling them back into a valid state.

#### Critical Code

Luckily, rubberbanding is straightforward to implement.

```
offset = pow(offset, 0.7)
```

By using an exponent between 0 and 1, the view’s offset is moved less the further it is away from its resting position. Use a larger exponent for less movement and a smaller exponent for more movement.

For a little more context, this code is usually implemented in a `UIPanGestureRecognizer` callback whenever the touch moves. The offset can be calculated with the delta between the current and original touch locations, and the offset can be applied with a translation transform.

```
var offset = touchPoint.y - originalTouchPoint.y  
offset = offset > 0 ? pow(offset, 0.7) : -pow(-offset, 0.7)  
view.transform = CGAffineTransform(translationX: 0, y: offset)
```

Note: This is not how Apple performs rubberbanding with elements like scroll views. I like this method because of its simplicity, but there are more complex functions for different behaviors.

### Interface #5: Acceleration Pausing

To view the app switcher on iPhone X, the user swipes up from the bottom of the screen and pauses midway. This interface re-creates this behavior.

![](https://cdn-images-1.medium.com/max/1600/1*GMqctAhbjqpmWmAtsKVeDg.gif)

#### Key Features

1.  Pause is calculated based on the gesture’s acceleration.
2.  Faster stopping results in a faster response.
3.  No timers.

#### Design Theory

Fluid interfaces should be fast. A delay from a timer, even if short, can make an interface feel sluggish.

This interface is particularly cool because its reaction time is based on the user’s motion. If they quickly pause, the interface quickly responds. If they slowly pause, it slowly responds.

#### Critical Code

In order to measure acceleration, we can track the most recent values of the pan gesture’s velocity.

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

This code updates the `velocities` array to always have the last seven velocities, which are used to calculate the acceleration.

To determine if the acceleration is great enough, we can measure the difference between the first velocity in our array against the current velocity.

```
if abs(velocity) > 100 || abs(offset) < 50 { return }
let ratio = abs(firstRecordedVelocity - velocity) / abs(firstRecordedVelocity)
if ratio > 0.9 {
    pauseLabel.alpha = 1
    feedbackGenerator.impactOccurred()
    hasPaused = true
}
```

We also check to make sure that the motion has a minimum displacement and velocity. If the gesture has lost more than 90% of its velocity, we consider it to be paused.

My implementation is not perfect. In my testing it seems to work pretty well, but there is an opportunity for a better heuristic to measure acceleration.

### Interface #6: Rewarding Momentum

A drawer with open and closed states that has bounciness based on the velocity of the gesture.

![](https://cdn-images-1.medium.com/max/1600/1*Wwh583M_4qLWg8Pb16mNeA.gif)

#### Key Features

1.  Tapping the drawer opens it without bounciness.
2.  Flicking the drawer opens it _with_ bounciness.
3.  Interactive, interruptible, and reversible.

#### Design Theory

This drawer shows the concept of rewarding momentum. When the user swipes a view with velocity, it’s much more satisfying to animate the view with bounciness. This makes the interface feel alive and fun.

When the drawer is tapped, it animates without bounciness, which feels appropriate, since a tap has no momentum in a particular direction.

When designing custom interactions, it’s important to remember that interfaces can have different animations for different interactions.

#### Critical Code

To simplify the logic of tapping versus panning, we can use a custom gesture recognizer subclass that immediately enters the `began` state on touch down.

```
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
}
```

This also allows the user to tap on the drawer during its motion to pause it, similar to tapping on a scroll view that’s currently scrolling. To handle taps, we can check if the velocity is zero when the gesture ends and continue the animation.

```
if yVelocity == 0 {
    animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
}
```

To handle a gesture with velocity, we first need to calculate its velocity relative to the total remaining displacement.

```
let fractionRemaining = 1 - animator.fractionComplete
let distanceRemaining = fractionRemaining * closedTransform.ty
if distanceRemaining == 0 {
    animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    break
}
let relativeVelocity = abs(yVelocity) / distanceRemaining
```

We can use this relative velocity to continue the animation with the timing parameters that include a little bit of bounciness.

```
let timingParameters = UISpringTimingParameters(damping: 0.8, response: 0.3, initialVelocity: CGVector(dx: relativeVelocity, dy: relativeVelocity))

let newDuration = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters).duration

let durationFactor = CGFloat(newDuration / animator.duration)

animator.continueAnimation(withTimingParameters: timingParameters, durationFactor: durationFactor)
```

Here we are creating a new `UIViewPropertyAnimator` to calculate the time the animation should take so we can provide the correct `durationFactor` when continuing the animation.

There are more complexities related to reversing the animation that I am not going to cover here. If you want to learn more, I wrote a full tutorial for this component: [Building Better iOS App Animations](http://www.swiftkickmobile.com/building-better-app-animations-swift-uiviewpropertyanimator/).

### Interface #7: FaceTime PiP

A re-creation of the picture-in-picture UI of the iOS FaceTime app.

![](https://cdn-images-1.medium.com/max/1600/1*zHlr_QAPv7YpEF5wb6YZAQ.gif)

#### Key Features

1.  Lightweight, airy interaction.
2.  Projected position is based on `UIScrollView`'s deceleration rate.
3.  Continuous animation that respects the gesture’s initial velocity.

#### Critical Code

Our end goal is to write something like this.

```
let params = UISpringTimingParameters(damping: 1, response: 0.4, initialVelocity: relativeInitialVelocity)

let animator = UIViewPropertyAnimator(duration: 0, timingParameters: params)

animator.addAnimations {
    self.pipView.center = nearestCornerPosition
}

animator.startAnimation()
```

We would like to create an animation with an initial velocity that matches the velocity of the pan gesture and animate the pip to the nearest corner.

First, let’s calculate the initial velocity.

To do this, we need to calculate a relative velocity based on the current velocity, current position, and target position.

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

We can split the velocity into its x and y components and determine the relative velocity for each.

Next, let’s calculate the corner for the PiP to animate to.

In order to make our interface feel natural and lightweight, we are going to project the final position of the PiP based on its current motion. If the PiP were to slide and come to a stop, where would it land?

```
let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
let velocity = recognizer.velocity(in: view)
let projectedPosition = CGPoint(
    x: pipView.center.x + project(initialVelocity: velocity.x, decelerationRate: decelerationRate),
    y: pipView.center.y + project(initialVelocity: velocity.y, decelerationRate: decelerationRate)
)
let nearestCornerPosition = nearestCorner(to: projectedPosition)
```

We can use the deceleration rate of a `UIScrollView` to calculate this resting position. This is important because it references the user’s muscle memory for scrolling. If a user knows about how far a view scrolls, they can use that previous knowledge to intuitively guess how much force is needed to move the PiP to their desired target.

This deceleration rate is also quite generous, making the interaction feel lightweight—only a small flick is needed to send the PiP flying all the way across the screen.

We can use the projection function provided in the “Designing Fluid Interfaces” talk to calculate the final projected position.

```
/// Distance traveled after decelerating to zero velocity at a constant rate.
func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
    return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate)
}
```

The last piece missing is the logic to find the nearest corner based on the projected position. To do this we can loop through all corner positions and find the one with the smallest distance to the projected landing position.

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

To summarize the final implementation: We use `UIScrollView`'s deceleration rate to project the pip’s motion to its final resting position, and calculate the relative velocity to feed it all into `UISpringTimingParameters`.

### Interface #8: Rotation

Applying the concepts from the PiP interface to a rotation animation.

![](https://cdn-images-1.medium.com/max/1600/1*jL07YlwI-5skQGkc4W8OeQ.gif)

#### Key Features

1.  Uses projection to respect the gesture’s velocity.
2.  Always ends in a valid orientation.

#### Critical Code

The code here is very similar to the previous PiP interface. We will use the same building blocks, except swapping the `nearestCorner` function for a `closestAngle` function.

```
func project(...) { ... }

func relativeVelocity(...) { ... }

func closestAngle(...) { ... }
```

When it’s time to finally create the `UISpringTimingParameters`, we are required to use a `CGVector` for the initial velocity even though our rotation only has one dimension. In any case where the animated property has only one dimension, set the `dx` value to the desired velocity and set the `dy` value to zero.

```
let timingParameters = UISpringTimingParameters(  
    damping: 0.8,  
    response: 0.4,  
    initialVelocity: CGVector(dx: relativeInitialVelocity, dy: 0)  
)
```

Internally the animator will ignore the `dy` value and use the `dx` value to create the timing curve.

### Try it yourself!

These interfaces are much more fun on a real device. To play with these interfaces yourself, the demo app is [available on GitHub](https://github.com/nathangitter/fluid-interfaces).

![](https://cdn-images-1.medium.com/max/2000/1*7gS4SLe571r7RZvpps3X9A.png)

The fluid interfaces demo app, available on GitHub!

### Practical Applications

#### For Designers

1.  Think about interfaces as fluid mediums of expression, not collections of static elements.
2.  Consider animations and gestures early in the design process. Layout tools like Sketch are fantastic, but don’t offer the full expressivity of the device.
3.  Prototype with developers. Get design-minded developers to help you prototype animations, gestures, and haptics.

#### For Developers

1.  Apply the tips from these interfaces to your own custom components. Think about how they might be combined in new and interesting ways.
2.  Educate your designers about new possibilities. Many are not aware of the full power of 3D touch, haptics, gestures, and spring animations.
3.  Prototype with designers. Help them see their designs on a real device, and create tools to help them design more effectively.

* * *

If you enjoyed this post, please leave some claps. 👏👏👏

**You can clap up to 50 times**, so get clicking/tapping! 😉

Please share the post with your iOS designer / iOS developer friends on your social media outlet of choice.

If you like this kind of stuff, you should follow me on Twitter. I only post high-quality tweets. [twitter.com/nathangitter](https://twitter.com/nathangitter)

Thanks to [David Okun](https://twitter.com/dokun24) for revising drafts of this post.

Thanks to [Christian Schnorr](https://medium.com/@jenoxx?source=post_page) and [David Okun](https://medium.com/@davidokun?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
