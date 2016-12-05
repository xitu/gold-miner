> * 原文地址：[How to generate haptic feedback with UIFeedbackGenerator](https://www.hackingwithswift.com/example-code/uikit/how-to-generate-haptic-feedback-with-uifeedbackgenerator)
* 原文作者：[twostraws](https://twitter.com/twostraws)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[owenlyn](https://github.com/owenlyn)
* 校对者：[luoyaqifei](http://www.zengmingxia.com/) [Tuccuay](https://github.com/Tuccuay)

# 如何使用 UIFeedbackGenerator 让应用支持 iOS 10 的触觉反馈




## 始于 iOS 10.0

iOS 10 引入了一种新的、产生触觉反馈的方式，它通过使用所有应用共享的预定义震动模式，来帮助用户认识到不同的震动反馈有不同的含义。这个功能的核心由 `UIFeedbackGenerator` 提供，不过这只是一个抽象类 (abstract class) —— 你真正需要关注的三个类是 `UINotificationFeedbackGenerator`，`UIImpactFeedbackGenerator`，和 `UISelectionFeedbackGenerator`。

其中的第一个，`UINotificationFeedbackGenerator` 让你可以根据三种系统事件：`error`，`success`，和 `warning` 来产生反馈。第二个，`UIImpactFeedbackGenerator`，它可以产生三种不同程度的、 Apple 所说的“物理与视觉相得益彰的体验”。最后一个， `UISelectionFeedbackGenerator` 会在用户改变他们在屏幕上的选择（例如滑动一个转盘选择器）的时候被触发，产生一个相应的反馈。

**这时候，只有 iPhone 7 和 iPhone 7 Plus 内置的新 Taptic 引擎支持这些应用程序接口（API）。其他设备只能静静地忽略这些触觉反馈的请求。**

想要试试这些新的 API，你需要在 Xcode 里新建一个 Single View Application 的模板，然后用以下测试脚手架替换内置的 `ViewController` 类：:

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

当你在手机上运行它的时候，按下 "Tap here!" 按钮可以轮流按顺序体验各种震动选项。

一个小贴士：因为系统准备触觉反馈需要一段时间，Apple 建议，触发触觉效果之前，在你的生成器 (generator) 内调用 `prepare()` 方法。如果你不这么做的话，在视觉效果和对应的震动之间确实会有一个小小的延迟，这给用户造成的迷惑可能会大过它的用处。

尽管从技术上来说，你可以给任何东西都加一个“操作成功”的反馈，但如果这么做而又做得不恰当的话，反而会给用户带来困惑，尤其是那些在人机交互上严重依赖触觉反馈的用户。Apple 特别要求开发者们要“恰如其分”的使用它们，尤其不要在给定的情境下使用错误的触觉反馈，而且记住，并不是所有的设备都支持这个新的触觉反馈 —— 毕竟你还要考虑那些旧 iPhone 的用户呐~

这个方案对你有帮助吗？请把它分享给更多人吧！






