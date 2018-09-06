> * 原文地址：[Running UITests with Facebook login in iOS](https://hackernoon.com/running-uitests-with-facebook-login-in-ios-4ac998940c42)
> * 原文作者：[Khoa Pham](https://hackernoon.com/@onmyway133?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/running-uitests-with-facebook-login-in-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO1/running-uitests-with-facebook-login-in-ios.md)
> * 译者： [LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：[Alan](https://github.com/Wangalan30)

# 在 iOS 中使用 UITests 测试 Facebook 登录功能

![](https://cdn-images-1.medium.com/max/800/0*Opf2sAlTPclE_4kE.jpg)

图片来源: 谷歌

今天我正试图在我的应用程序上运行一些 UITest，它集成了 Facebook 登录功能。以下是我的一些笔记。

![](https://cdn-images-1.medium.com/max/600/0*e0lQASZpw5qGT7jn.gif)

### 挑战

*   对我们来说，使用 Facebook 的挑战主要在于， 它使用了 `Safari controller`，而我们主要处理 `web view`。从 iOS 9+ 开始，Facebook 决定使用 `safari` 取代 `native facebook app` 以此来避免应用间的切换。你可以在这里阅读详细信息 [在iOS 9上为人们构建最佳的 Facebook 登录体验](https://developers.facebook.com/blog/post/2015/10/29/Facebook-Login-iOS9/)
*   它并没有我们想要的 `accessibilityIdentifier` 或者 `accessibilityLabel`
*   webview 内容将来可能会发生变化 😸

### 创建一个 Facebook 测试用户

幸运的是，您不必创建自己的 Facebook 用户用于测试。Facebook 支持创建测试用户，可以管理权限和好友，非常方便

![](https://cdn-images-1.medium.com/max/800/0*kVdiqx7CB7b43dRw.png)

当我们创建测试用户时，您还可以选择不同语言。这将是 Safari Web 视图中显示的语言。我现在选择的是 `Norwegian` 🇳🇴 

![](https://cdn-images-1.medium.com/max/800/0*H7V1GZN413eb1y4n.png)

### 单击登录按钮并显示 Facebook 登录

这里我们使用默认的 `FBSDKLoginButton`

```
var showFacebookLoginFormButton: XCUIElement {
  return buttons["Continue with Facebook"]
}
```

然后点击它

```
app.showFacebookLoginFormButton.tap()
```

### 检查登录状态

当在 Safari 访问 Facebook 表单时，用户也许已经登录过，也许没有。所以我们需要处理这两种情况。所以我们需要处理这两个场景。当用户已经登录时，Facebook 会返回`你已经登录`或 `OK` 按钮。

这里的建议是添加断点，然后使用 `lldb` 命令 `po app.staticTexts` 和 `po app.buttons`，查看当前断点下的 UI 元素。

您可以检查静态文本，或只是点击 `OK` 按钮

```
var isAlreadyLoggedInSafari: Bool {
  return buttons["OK"].exists || staticTexts["Du har allerede godkjent Blue Sea."].exists
}
```

### 等待并刷新

因为 Facebook 表单是一个 webview ，所以它的内容是有点动态的。并且 UITest 似乎会缓存内容以便快速查询，因此在检查 `staticTexts` 之前，我们需要 `wait` 和 `refresh the cache`

```
app.clearCachedStaticTexts()
```

这里实现了 `wait` 功能

```
extension XCTestCase {
  func wait(for duration: TimeInterval) {
    let waitExpectation = expectation(description: "Waiting")

    let when = DispatchTime.now() + duration
    DispatchQueue.main.asyncAfter(deadline: when) {
      waitExpectation.fulfill()
    }

    // We use a buffer here to avoid flakiness with Timer on CI
    waitForExpectations(timeout: duration + 0.5)
  }
}
```

### 等待元素出现

但更保险的方法是等待元素出现。对于 Facebook 登录表单来说，他们会在加载后显示 `Facebook` 的标签。所以我们应该等待这个元素出现

```
extension XCTestCase {
  /// Wait for element to appear
  func wait(for element: XCUIElement, timeout duration: TimeInterval) {
    let predicate = NSPredicate(format: "exists == true")
    let _ = expectation(for: predicate, evaluatedWith: element, handler: nil)

    // Here we don't need to call `waitExpectation.fulfill()`

    // We use a buffer here to avoid flakiness with Timer on CI
    waitForExpectations(timeout: duration + 0.5)
  }
}
```

在对 Facebook 登录表单中的元素进行任何进一步检查之前，请调用此方法

```
wait(for: app.staticTexts["Facebook"], timeout: 5)
```

### 如果用户已登录

登录后，我的应用程序会在主控制器中显示一个地图页面。因此，我们需要简单的测试一下，检查该地图是否存在

```
if app.isAlreadyLoggedInSafari {
  app.okButton.tap()

  handleLocationPermission()
  // Check for the map
  XCTAssertTrue(app.maps.element(boundBy: 0).exists)
}
```

### 处理中断

我们知道，当要显示位置地图时，`Core Location` 会发送请求许可。所以我们也需要处理这种中断。你需要确保在弹框弹出之前尽早调用它

```
fileprivate func handleLocationPermission() {
  addUIInterruptionMonitor(withDescription: "Location permission", handler: { alert in
    alert.buttons.element(boundBy: 1).tap()
    return true
  })
}
```

还有一个问题，这个`监视器`不会被调用。所以解决方法是在弹框弹起时再次调用 `app.tap()`。 对我来说，我会在我的 ‘地图’ 显示1到2秒后调用 `app.tap()`，这是为了确保在显示弹框之后再调用 `app.tap()`

更详细的指南，请阅读 [#48](https://github.com/onmyway133/blog/issues/48)

### 如果用户未登录

在这种情况下，我们需要填写邮箱账户和密码。 您可以查看下面的`完整源代码`部分。当如果方法不起作用或者 `po` 命令并没有打印出你需要的元素时，这可能是因为缓存或者你需要等到动态内容渲染完成后在再尝试。

您需要等待元素出现

### 点击文本输入框

如果遇到这种情况 `Neither element nor any descendant has keyboard focus`, 这是解决方法

*   如果你在模拟器上测试, 请确保没有选中 `Simulator -> Hardware -> Keyboard -> Connect Hardware Keyboard` 
*   点击后稍微 `稍等` 一下 

```
app.emailTextField.tap()
```

### 清除所有文字

此举是为了将光标移动到文本框末尾，然后依次删除每一个字符，并键入新的文本

```
extension XCUIElement {
  func deleteAllText() {
    guard let string = value as? String else {
      return
    }

    let lowerRightCorner = coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.9))
    lowerRightCorner.tap()

    let deletes = string.characters.map({ _ in XCUIKeyboardKeyDelete }).joined(separator: "")
    typeText(deletes)
  }
}
```

### 修改语言环境

对我来说，我想用挪威语进行测试，所以我们需要找到 `Norwegian` 选项并点击它。它被 `UI Test` 识别为`静态文本`

```
var norwegianText: XCUIElement {
  return staticTexts["Norsk (bokmål)"]
}

wait(for: app.norwegianText, timeout: 1)
app.norwegianText.tap()
```

### 邮箱账户输入框

幸运的是，邮箱账户输入框可以被 `UI Test` 检测为 `text field` 元素，因此我们可以查询它。 这里使用谓词

```
var emailTextField: XCUIElement {
  let predicate = NSPredicate(format: "placeholderValue == %@", "E-post eller mobil")
  return textFields.element(matching: predicate)
}
```

### 密码输入框

`UI Test` 似乎无法识别出密码输入框，因此我们需要通过 `coordinate` 进行搜索

```
var passwordCoordinate: XCUICoordinate {
  let vector = CGVector(dx: 1, dy: 1.5)
  return emailTextField.coordinate(withNormalizedOffset: vector)
}
```

下面是这个方法的文档描述`func coordinate(withNormalizedOffset normalizedOffset: CGVector) -> XCUICoordinate`

> _创建并返回带有标准化偏移量的新坐标。 
> 坐标的屏幕点是通过将 normalizedOffset 乘以元素 `frame` 的大小与元素 `frame` 的原点相加来计算的。_

然后输入密码

```
app.passwordCoordinate.tap()
app.typeText("My password")
```

我们不应该使用 `app.passwordCoordinate.referencedElement` 因为它会指向邮箱账户输入框 ❗️ 😢

### 再次运行该测试

这里我们从 `Xcode -> Product -> Perform Actions -> Test Again` 再次运行上一个测试

![](https://cdn-images-1.medium.com/max/800/0*kYHd-HY0mLvgdXUs.png)

以下是完整的源代码

```
import XCTest
class LoginTests: XCTestCase {
  var app: XCUIApplication!
  func testLogin() {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
    passLogin()
  }
}
extension LoginTests {
  func passLogin() {
    // Tap login
    app.showFacebookLoginFormButton.tap()
    wait(for: app.staticTexts["Facebook"], timeout: 5) // This requires a high timeout
     
    // There may be location permission popup when showing map
    handleLocationPermission()    
    if app.isAlreadyLoggedInSafari {
      app.okButton.tap()
      // Show map
      let map = app.maps.element(boundBy: 0)
      wait(for: map, timeout: 2)
      XCTAssertTrue(map.exists)
      // Need to interact with the app for interruption monitor to work
      app.tap()
    } else {
      // Choose norsk
     wait(for: app.norwegianText, timeout: 1)
      app.norwegianText.tap()
      app.emailTextField.tap()
      app.emailTextField.deleteAllText()
      app.emailTextField.typeText("mujyhwhbby_1496155833@tfbnw.net")
      app.passwordCoordinate.tap()
      app.typeText("Bob Alageaiecghfb Sharpeman")
      // login
      app.facebookLoginButton.tap()
      // press OK
      app.okButton.tap()
      // Show map
      let map = app.maps.element(boundBy: 0)
      wait(for: map, timeout: 2)
      XCTAssertTrue(map.exists)
      // Need to interact with the app for interruption monitor to work
      app.tap()
    }
  }
  fileprivate func handleLocationPermission() {
    addUIInterruptionMonitor(withDescription: "Location permission", handler: { alert in
      alert.buttons.element(boundBy: 1).tap()
      return true
    })
  }
}
fileprivate extension XCUIApplication {
  var showFacebookLoginFormButton: XCUIElement {
    return buttons["Continue with Facebook"]
  }
  var isAlreadyLoggedInSafari: Bool {
    return buttons["OK"].exists || staticTexts["Du har allerede godkjent Blue Sea."].exists
  }
  var okButton: XCUIElement {
    return buttons["OK"]
  }
  var norwegianText: XCUIElement {
    return staticTexts["Norsk (bokmål)"]
  }
  var emailTextField: XCUIElement {
    let predicate = NSPredicate(format: "placeholderValue == %@", "E-post eller mobil")
    return textFields.element(matching: predicate)
  }
  var passwordCoordinate: XCUICoordinate {
    let vector = CGVector(dx: 1, dy: 1.5)
    return emailTextField.coordinate(withNormalizedOffset: vector)
  }
  var facebookLoginButton: XCUIElement {
    return buttons["Logg inn"]
  }
}
extension XCTestCase {
  func wait(for duration: TimeInterval) {
    let waitExpectation = expectation(description: "Waiting")
    let when = DispatchTime.now() + duration
    DispatchQueue.main.asyncAfter(deadline: when) {
      waitExpectation.fulfill()
    }
    // We use a buffer here to avoid flakiness with Timer on CI
    waitForExpectations(timeout: duration + 0.5)
  }
  /// Wait for element to appear
  func wait(for element: XCUIElement, timeout duration: TimeInterval) {
    let predicate = NSPredicate(format: "exists == true")
    let _ = expectation(for: predicate, evaluatedWith: element, handler: nil)
    // We use a buffer here to avoid flakiness with Timer on CI
    waitForExpectations(timeout: duration + 0.5)
  }
}
extension XCUIApplication {
  // Because of "Use cached accessibility hierarchy"
  func clearCachedStaticTexts() {
    let _ = staticTexts.count
  }
  func clearCachedTextFields() {
    let _ = textFields.count
  }
  func clearCachedTextViews() {
    let _ = textViews.count
  }
}
extension XCUIElement {
  func deleteAllText() {
    guard let string = value as? String else {
      return
    }
    let lowerRightCorner = coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.9))
    lowerRightCorner.tap()
    let deletes = string.characters.map({ _ in XCUIKeyboardKeyDelete }).joined(separator: "")
    typeText(deletes)
  }
}
```

### 另外一点

感谢这些我原创文章的有用反馈 [https://github.com/onmyway133/blog/issues/44](https://github.com/onmyway133/blog/issues/44), 这里有一些更多的点子

*   要查找密码输入框，实际上我们可以使用 `secureTextFields` 来代替使用 `coordinate`
*   `wait` 函数应该作为 `XCUIElement` 的扩展，以便于其他元素可以使用它。或者你可以使用旧的 `expectation` 样式，这不涉及硬编码的间隔值。

### 进一步拓展

这些指南涵盖了 UITests 许多方面的内容，值得一看

*   [UI-Testing-Cheat-Sheet](https://github.com/joemasilotti/UI-Testing-Cheat-Sheet)
*   [Everything About Xcode UI Testing](http://samwize.com/2016/02/28/everything-about-xcode-ui-testing-snapshot/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
