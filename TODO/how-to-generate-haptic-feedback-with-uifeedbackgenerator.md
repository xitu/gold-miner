> * 原文地址：[How to generate haptic feedback with UIFeedbackGenerator](https://www.hackingwithswift.com/example-code/uikit/how-to-generate-haptic-feedback-with-uifeedbackgenerator)
* 原文作者：[twostraws](https://twitter.com/twostraws)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# How to generate haptic feedback with UIFeedbackGenerator




## Available from iOS 10.0

iOS 10 introduces new ways of generating haptic feedback using predefined vibration patterns shared by all apps, thus helping users understand that various types of feedback carry special significance. The core of this functionality is provided by `UIFeedbackGenerator`, but that's just an abstract class – the three classes you really care about are `UINotificationFeedbackGenerator`, `UIImpactFeedbackGenerator`, and `UISelectionFeedbackGenerator`.

The first of these, `UINotificationFeedbackGenerator`, lets you generate feedback based on three system events: error, success, and warning. The second, `UIImpactFeedbackGenerator`, lets you generate light, medium, and heavy effects that Apple says provide a "physical metaphor that complements the visual experience." Finally, `UISelectionFeedbackGenerator` generates feedback that should be triggered when the user is changing their selection on screen, e.g. moving through a picker wheel.

**At this time, only the new Taptic Engine found in the iPhone 7 and iPhone 7 Plus support these APIs. Other devices silently ignore the haptic requests.**

To start trying these APIs yourself, create a Single View Application template in Xcode, then replace the built-in `ViewController` class with this test harness:

    import UIKit

    class ViewController: UIViewController {
    	var i = 0

    	override func viewDidLoad() {
    		super.viewDidLoad()

    		let btn = UIButton()
    		btn.translatesAutoresizingMaskIntoConstraints = false

    		btn.widthAnchor.constraint(equalToConstant: 128).isActive = true
    		btn.heightAnchor.constraint(equalToConstant: 128).isActive = true
    		btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    		btn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    		btn.setTitle("Tap here!", for: .normal)
    		btn.setTitleColor(UIColor.red, for: .normal)
    		btn.addTarget(self, action: #selector(tapped), for: .touchUpInside)

    		view.addSubview(btn)
    	}

    	func tapped() {
    		i += 1
    		print("Running \(i)")

    		switch i {
    		case 1:
    			let generator = UINotificationFeedbackGenerator()
    			generator.notificationOccurred(.error)

    		case 2:
    			let generator = UINotificationFeedbackGenerator()
    			generator.notificationOccurred(.success)

    		case 3:
    			let generator = UINotificationFeedbackGenerator()
    			generator.notificationOccurred(.warning)

    		case 4:
    			let generator = UIImpactFeedbackGenerator(style: .light)
    			generator.impactOccurred()

    		case 5:
    			let generator = UIImpactFeedbackGenerator(style: .medium)
    			generator.impactOccurred()

    		case 6:
    			let generator = UIImpactFeedbackGenerator(style: .heavy)
    			generator.impactOccurred()

    		default:
    			let generator = UISelectionFeedbackGenerator()
    			generator.selectionChanged()
    			i = 0
    		}
    	}
    }

When you run that on your phone, pressing the "Tap here!" button cycles through all the vibration options in order.

One tip: because it can take a small amount of time for the system to prepare haptic feedback, Apple recommends you call the `prepare()` method on your generator before triggering the haptic effect. If you don't do this, and there _is_ a slight delay between the visual effect and the matching haptic, it might confuse users more than it helps.

Although you can technically use a success notification feedback for whatever you want, doing so inappropriately may confuse users, particularly those who are heavily reliant on haptic feedback for device interaction. Apple specifically requests that you use them judiciously, that you avoid using the wrong haptic for a given situation, and that you remember not all devices support this new haptic feedback – you need to consider older iPhones too.

Did this solution work for you? Please pass it on!

[Tweet](https://twitter.com/share)

**Other people are reading…**

**About the Swift Knowledge Base**

This is part of the [Swift Knowledge Base](https://www.hackingwithswift.com/example-code), a free, searchable collection of solutions for common iOS questions.



**Want to learn Swift faster?**

Get 38 Swift projects in PDF and HTML: buy the Hacking with Swift book! It contains over 1200 pages of hands-on Swift tutorials, and will really help boost your iOS career



Copyright ©2016 Paul Hudson. [Follow me: @twostraws](http://twitter.com/twostraws).



