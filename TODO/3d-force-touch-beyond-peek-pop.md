> * 原文链接: [3D Force Touch: beyond peek & pop](https://medium.com/produkt-blog/3d-force-touch-beyond-peek-pop-c448edc2b1f5#.4miueafqm)
* 原文作者 : [Victor Baro](https://medium.com/@victorbaro)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 :
* 状态 : 待定

A few days ago I bought an iPhone 6S. I was super impressed with its new **3D touch** and I could not wait to start experimenting.

<iframe width="382" height="214" src="https://www.youtube.com/embed/d-hlQISXj8M" frameborder="0" allowfullscreen=""></iframe>

Peek & pop is a great feature to include in an app. The downside: we don’t have much control over it. We can only add a preview and a few actions — iOS manages the rest.

Since I discovered _3D Touch_, I have been thinking about new ways of interacting with the content. Peek & pop is a great interaction; but what I really want is to create my own controls.

We need to take into account that, because _3D touch_ is only available in iPhone 6S and 6S Plus, no action should be completed **just** by using this feature. The user should be able to achieve any action without using _3D touch_ (just like peek & pop does), and _3D touch_ should only provide an extra level of interaction.

#### Accessing force property

The new force property can be found in UITouch class. To get the user _touch_ we should override _touches_ methods (touchesBegan, touchesMoved, touchesEnded), either subclassing (e.g. UIView, UIButton; see example 1) or creating a gesture recognizer (see below; used in examples 2 and 3).

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

The force value goes from 0.0 to 6.667\. For further details, I extremely recommend [Exploring Apple’s 3D Touch post](https://medium.com/@rknla/exploring-apple-s-3d-touch-f5980ef45af5).

#### Example 1: Force Button

**Force Button** is a subclass of UIButton that modifies its shadow based on the input force (as seen in the top video).

    func shadowWithAmount(amount: CGFloat) {
        self.layer.shadowColor = shadowColor.CGColor
        self.layer.shadowOpacity = shadowOpacity
        let widthFactor = maxShadowOffset.width/maxForceValue
        let heightFactor = maxShadowOffset.height/maxForceValue
        self.layer.shadowOffset = CGSize(width: maxShadowOffset.width - amount * widthFactor, height: maxShadowOffset.height - amount * heightFactor)
        self.layer.shadowRadius = maxShadowRadius - amount
    }

The above function modifies the button shadow based on input force. You can find another example on how to modify the button scale while its being pressed [here](https://github.com/Produkt/3dForceTouchExamples).

This button uses _3D touch_ only for visual purposes, it does not add any extra feature. It might be nice to add an extra event (e.g. _UIControlEvents.ForceMaxInside)_ to add a taget action once the user has pressed the button to its maximum force.

#### Example 2: Zooming

<iframe width="382" height="214" src="https://www.youtube.com/embed/8RcDqH4kfo8" frameborder="0" allowfullscreen=""></iframe>

We are all used to pinch to zoom in and out, it feels natural. However, sometimes it is tricky to use 2 fingers while holding the device with 1 hand. Google maps app tries to solve this issue by using a _doble-tap-longPress-drag_ gesture (which feels weird if you are not use to it).

Using ForceGestureRecognizer (see code above), it is really easy to zoom in and out while dragging your finger. If you have an iPhone 6S give it a go, it feels great.

To achieve this effect, I simply apply a CATransform3D scale to the imageView layer. By doing this, the image scales from its center. To move the image under my finger (zooming to an specific area) I need to update the anchorPoint based on the finger’s location.

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

The last interaction I am proposing for the 3D _touch_ is to **control an animation**. To be honest, I haven’t found any interesting use for this interaction (other than being great for fine-tunning), but I would like to mention it (someone might find it useful).

Here is a quick video of an animation being controlled with _3D touch._

<iframe width="382" height="214" src="https://www.youtube.com/embed/LXQ-iSYhHFI" frameborder="0" allowfullscreen=""></iframe></div>

These are just a few examples of new ways of interaction that _3D Touch_ brings to designers and developers. I hope I have convinced you to try _3D Touch_.

I would like to finish by recommending [FlexMonkey’s bog](http://flexmonkey.blogspot.com.es), and specially his latest post: [3D Retouch](http://flexmonkey.blogspot.com.es/2015/10/3d-retouch-experimental-retouching-app.html), where he uses 3D Touch to modify the intensity of filters.

Find the whole project in [github](https://github.com/Produkt/3dForceTouchExamples).

_Special thanks to @pivalue_
