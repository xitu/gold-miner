> * 原文地址：[Running UITests with Facebook login in iOS](https://hackernoon.com/running-uitests-with-facebook-login-in-ios-4ac998940c42)
> * 原文作者：[Khoa Pham](https://hackernoon.com/@onmyway133?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/running-uitests-with-facebook-login-in-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO1/running-uitests-with-facebook-login-in-ios.md)
> * 译者：
> * 校对者：

# Running UITests with Facebook login in iOS

![](https://cdn-images-1.medium.com/max/800/0*Opf2sAlTPclE_4kE.jpg)

Source: Google

Today I’m trying to run some UITest on my app, which uses Facebook login. And here are some of my notes on it.

![](https://cdn-images-1.medium.com/max/600/0*e0lQASZpw5qGT7jn.gif)

### Challenges

*   The challenges with Facebook is it uses `Safari controller`, we we deal mostly with `web view` for now. Starting from iOS 9+, Facebook decided to use `safari` instead of `native facebook app` to avoid app switching. You can read the detail here [Building the Best Facebook Login Experience for People on iOS 9](https://developers.facebook.com/blog/post/2015/10/29/Facebook-Login-iOS9/)
*   It does not have wanted `accessibilityIdentifier` or `accessibilityLabel`
*   The webview content may change in the future 😸

### Create a Facebook test user

Luckily, you don’t have to create your own Facebook user to test. Facebook supports test users that you can manage permissions and friends, very handy

![](https://cdn-images-1.medium.com/max/800/0*kVdiqx7CB7b43dRw.png)

When creating the test user, you have the option to select language. That will be the displayed language in Safari web view. I choose `Norwegian` 🇳🇴 for now

![](https://cdn-images-1.medium.com/max/800/0*H7V1GZN413eb1y4n.png)

### Click the login button and show Facebook login

Here we use the default `FBSDKLoginButton`

```
var showFacebookLoginFormButton: XCUIElement {
  return buttons["Continue with Facebook"]
}
```

And then tap it

```
app.showFacebookLoginFormButton.tap()
```

### Check login status

When going to safari Facebook form, user may have already logged in or not. So we need to handle these 2 cases. When user has logged in, Facebook will say something like “you have already logged in” or the `OK` button.

The advice here is to put breakpoint and `po app.staticTexts`, `po app.buttons` to see which UI elements are at a certain point.

You can check for the static text, or simply just the `OK` button

```
var isAlreadyLoggedInSafari: Bool {
  return buttons["OK"].exists || staticTexts["Du har allerede godkjent Blue Sea."].exists
}
```

### Wait and refresh

But Facebook form is a webview, so its content is a bit dynamic. And UITest seems to cache content for fast query, so before checking `staticTexts`, we need to `wait` and `refresh the cache`

```
app.clearCachedStaticTexts()
```

This is the `wait` function

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

### Wait for element to appear

But a more solid approach would be to wait for element to appear. For Facebook login form, they should display a `Facebook` label after loading. So we should wait for this element

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

And call this before you do any further inspection on elements in Facebook login form

```
wait(for: app.staticTexts["Facebook"], timeout: 5)
```

### If user is logged in

After login, my app shows the main controller with a map view inside. So a basic test would be to check the existence of that map

```
if app.isAlreadyLoggedInSafari {
  app.okButton.tap()

  handleLocationPermission()
  // Check for the map
  XCTAssertTrue(app.maps.element(boundBy: 0).exists)
}
```

### Handle interruption

You know that when showing the map with location, `Core Location` will ask for permission. So we need to handle that interruption as well. You need to ensure to call it early before the alert happens

```
fileprivate func handleLocationPermission() {
  addUIInterruptionMonitor(withDescription: "Location permission", handler: { alert in
    alert.buttons.element(boundBy: 1).tap()
    return true
  })
}
```

There is another problem, this `monitor` won't be called. So the workaround is to call `app.tap()` again when the alert will happen. In my case, I call `app.tap()` when my `map` has been shown for 1,2 seconds, just to make sure `app.tap()` is called after alert is shown

For a more detailed guide, please read [#48](https://github.com/onmyway133/blog/issues/48)

### If user is not logged in

In this case, we need to fill in email and password. You can take a look at the `The full source code`section below. When things don't work or `po` does not show you the elements you needed, it's probably because of caching or you need to wait until dynamic content finishes rendering.

You need to wait for element to appear

### Tap on the text field

You may get `Neither element nor any descendant has keyboard focus`, here are the workaround

*   If you test on Simulator, make sure `Simulator -> Hardware -> Keyboard -> Connect Hardware Keyboard` is not checked
*   `wait` a bit after tap

```
app.emailTextField.tap()
```

### Clear all the text

The idea is to move the caret to the end of the textField, then apply each `delete key` for each character, then type the next text

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

### Change language

For my case, I want to test in Norwegian, so we need to find the `Norwegian` option and tap on that. It is identified as `static text` by `UI Test`

```
var norwegianText: XCUIElement {
  return staticTexts["Norsk (bokmål)"]
}

wait(for: app.norwegianText, timeout: 1)
app.norwegianText.tap()
```

### The email text field

Luckily, email text field is detected by `UI Test` as `text field` element, so we can query for that. This uses predicate

```
var emailTextField: XCUIElement {
  let predicate = NSPredicate(format: "placeholderValue == %@", "E-post eller mobil")
  return textFields.element(matching: predicate)
}
```

### The password text field

`UI Test` can't seem to identify the password text field, so we need to search for it by `coordinate`

```
var passwordCoordinate: XCUICoordinate {
  let vector = CGVector(dx: 1, dy: 1.5)
  return emailTextField.coordinate(withNormalizedOffset: vector)
}
```

This is the document for `func coordinate(withNormalizedOffset normalizedOffset: CGVector) -> XCUICoordinate`

> _Creates and returns a new coordinate with a normalized offset.  
> The coordinate’s screen point is computed by adding normalizedOffset multiplied by the size of the element’s frame to the origin of the element’s frame._

Then type the password

```
app.passwordCoordinate.tap()
app.typeText("My password")
```

We should not use `app.passwordCoordinate.referencedElement` because it will point to email text field ❗️ 😢

### Run that test again

Go to `Xcode -> Product -> Perform Actions -> Test Again` to run the previous test again

![](https://cdn-images-1.medium.com/max/800/0*kYHd-HY0mLvgdXUs.png)

Here are the full source code

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

### One more thing

Thanks to the helpful feedback on my article Original story [https://github.com/onmyway133/blog/issues/44](https://github.com/onmyway133/blog/issues/44), here are some more ideas

*   To look for password text fields, we can actually use `secureTextFields` instead of coordinate
*   The `wait` function should be made as an extension to `XCUIElement` so other element can use that. Or you can just use the old `expectation` style, which does not involve a hardcoded interval value.

### Where to go from here

I found these guides to cover many aspects of UITests, worth taking a look

*   [UI-Testing-Cheat-Sheet](https://github.com/joemasilotti/UI-Testing-Cheat-Sheet)
*   [Everything About Xcode UI Testing](http://samwize.com/2016/02/28/everything-about-xcode-ui-testing-snapshot/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
