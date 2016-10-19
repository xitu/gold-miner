> * 原文链接: [3D Force Touch: beyond peek & pop](https://medium.com/produkt-blog/3d-force-touch-beyond-peek-pop-c448edc2b1f5#.4miueafqm)
* 原文作者 : [Victor Baro](https://medium.com/@victorbaro)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [shiguol(SAlex)](https://github.com/shiguol)
* 校对者 : [cdpath (cdpath)](https://github.com/cdpath) [nathanwhy (nathan)](https://github.com/nathanwhy)
* 状态 : 完成

# 3D Force Touch 的新玩儿法 

几天前我买了部 iPhone 6S，接着我被 **3D touch** 功能深深地吸引住了，于是迫不及待地体验了一番。

<iframe width="382" height="214" src="https://www.youtube.com/embed/d-hlQISXj8M" frameborder="0" allowfullscreen=""></iframe>

在一个应用程序中，Peek 和 pop 是一个很出彩的特性。不过话说回来：我们没有太多的控制权。我们只能添加一个预览功能和几个动作 - iOS 系统会管理剩下的工作。

因为我探索了 _3D Touch_ 功能，就一直在思考与内容互动的新方式。Peek 和 pop 是一个很好的交互方式; 但我真正想要的是创建自定义的控制技术。

我们需要考虑的是，由于 _3D touch_ 仅在 iPhone 6S 和 6S Plus 上提供，所以不应该存在**仅**能使用该动作执行的功能。用户应不依赖 _3D touch_ 也可以完成所有功能（就像使用 Peek 和 pop 实现的一样）, 而 _3D touch_ 最好只提供额外的交互体验。

#### 访问 force 属性

新的 force 属性在 UITouch 类中。如果想获得用户 _touch_ 事件，我们应该重写 _touches_ 相关方法（类如：touchesBegan, touchesMoved, touchesEnded）, 或者继承相关类（例如 UIView，UIButton；见例1），抑或继承实现一个手势（见下文，例 2 和 例 3）；


    import UIKit.UIGestureRecognizerSubclass

    class ForceGestureRecognizer: UIGestureRecognizer {

        var forceValue: CGFloat = 0

        override func touchesBegan(touches: Set, withEvent event: UIEvent) {
            super.touchesBegan(touches, withEvent: event)
            state = .Began
            handleForceWithTouches(touches)
        }

        override func touchesMoved(touches: Set, withEvent event: UIEvent) {
            super.touchesMoved(touches, withEvent: event)
            state = .Changed
            handleForceWithTouches(touches)
        }

        override func touchesEnded(touches: Set, withEvent event: UIEvent) {
            super.touchesEnded(touches, withEvent: event)
            state = .Ended
            handleForceWithTouches(touches)
        }

        func handleForceWithTouches(touches: Set) {
            if touches.count != 1 {
                state = .Failed
                return
            }
            guard let touch = touches.first else {
                state = .Failed
                return
            }
            forceValue = touch.force
        }
    }


在这里，我们可以看到 force 属性值介于 0.0 ~ 6.667 之间；关于该值的更多讨论，推荐看这篇文章[探索 Apple`s 3D Touch](https://medium.com/@rknla/exploring-apple-s-3d-touch-f5980ef45af5).

#### 例 1: Force Button

**Force Button** 是 UIButton 的子类，可根据按压的力量变化来修改按钮的阴影属性（见文章开头处视频）。

    func shadowWithAmount(amount: CGFloat) {
        self.layer.shadowColor = shadowColor.CGColor
        self.layer.shadowOpacity = shadowOpacity
        let widthFactor = maxShadowOffset.width/maxForceValue
        let heightFactor = maxShadowOffset.height/maxForceValue
        self.layer.shadowOffset = CGSize(width: maxShadowOffset.width - amount * widthFactor, height: maxShadowOffset.height - amount * heightFactor)
        self.layer.shadowRadius = maxShadowRadius - amount
    }

上面的函数依据按压力的大小来修改按钮的阴影。你可以找到另外一个例子，解释了如何依据按压力的大小来缩放按钮，[文章在这里]（https://github.com/Produkt/3dForceTouchExamples）。

这个按钮使用 _3D touch_ 技术只实现了视觉上的反馈，它没有任何额外的功能。其实，它可以在用户用力按压按钮时系统回调的事件（如 _UIControlEvents.ForceMaxInside）中进行我们自己额外的事件响应。

#### Example 2: Zooming

<iframe width="382" height="214" src="https://www.youtube.com/embed/8RcDqH4kfo8" frameborder="0" allowfullscreen=""></iframe>

我们都是用来双指的捏来实现放大和缩小，这样操作起来感觉自然。然而，有时候当你单手拿着手机时，双指缩放手势操作起来会感觉怪怪的。谷歌地图应用程序尝试通过使用 _doble-tap-longPress-drag_ 手势来解决这个的问题（这感觉怪怪的，如果你不使用它）。

当使用 ForceGestureRecognizer 手势时（见上面的代码），该手势在你拖拽时也很容易放大和缩小。如果你有一个 iPhone6S 可以试一试，这感觉太棒了。

为了达到这个效果，我简单地应用一个 CATransform3D 缩放效果到 ImageView 的层。这样，图像从它的中心进行缩放。通过按住并移动我的手指（缩小到一个特定的区域），我就可以根据手指的位置更新图片的锚点。

    func imagePressed(sender: ForceGestureRecognizer) {
        let point = sender.locationInView(self.view)
        let imageCoordPoint = CGPointMake(point.x - initialFrame.origin.x, point.y - initialFrame.origin.y)

        var xValue = max(0, imageCoordPoint.x / initialFrame.size.width)
        var yValue = max(0, imageCoordPoint.y / initialFrame.size.height)

        xValue = min(xValue, 1)
        yValue = min(yValue, 1)

        let anchor = CGPointMake(xValue, yValue)
        mainImageView.layer.anchorPoint = anchor
        let forceValue = max(1, sender.forceValue)
        mainImageView.layer.transform = CATransform3DMakeScale(forceValue, forceValue, 1)

        if sender.state == .Ended {
            mainImageView.layer.anchorPoint = CGPointMake(0.5, 0.5)
            mainImageView.layer.transform = CATransform3DIdentity
        }
    }

最后一个关于 _3D_touch_ 的交互特性我觉得就是**控制动画**了.不过，实话说，我还没有发现这种相互作用的任何有趣的用途（不是作为精细调谐），但我想提一提它（有人可能会发现它很有用）。

这里有一个动画视频是由 _3D_touch_ 进行的控制。

<iframe width="382" height="214" src="https://www.youtube.com/embed/LXQ-iSYhHFI" frameborder="0" allowfullscreen=""></iframe></div>

这里还有给设计师和工程师的一些示例演示了使用 _3D_touch_ 进行交互的方法。我希望我已经说服你去尝试 _3D_touch_。

我想通过推荐[FlexMonkey 的博客]（http://flexmonkey.blogspot.com.es）最新文章：[3D Retouch]（http://flexmonkey.blogspot.com.es/2015/10/3D-retouch-experimental-retouching-app.html），在这篇文章中，他使用 3D Touch 修改滤镜的强度。

整个项目在这里[github]（https://github.com/Produkt/3dForceTouchExamples）。

_特别感谢 @pivalue_
