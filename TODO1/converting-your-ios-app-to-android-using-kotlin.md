> * 原文地址：[Converting your iOS App to Android Using Kotlin](https://www.raywenderlich.com/7266-converting-your-ios-app-to-android-using-kotlin?utm_source=mobiledevweekly&utm_medium=email)
> * 原文作者：[Lisa Luo](https://www.raywenderlich.com/u/luoser)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/converting-your-ios-app-to-android-using-kotlin.md](https://github.com/xitu/gold-miner/blob/master/TODO1/converting-your-ios-app-to-android-using-kotlin.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：

# 使用 Kotlin 将你的 iOS 应用程序转换为 Android

## 在本教程中，你将目睹这些语言的相似之处以及通过 iOS 应用程序移植到 Android 时让 Swift 转换为 Kotlin 是多么容易。

移动设备是你的日常伴侣，无论你走到哪里，都可以将它们放入背包和口袋。技术将不断适应你的移动设备，使移动开发作为一个人的业余爱好或是专业都将越来越普遍。

通常开发人员会选择一个开发平台，最常见的是 Android 或 iOS。 这种选择一般由一个人的所能得到的资源（例如，她或他的个人设备）或环境引导。许多开发人员倾向于坚持专门为他们选择的平台构建应用程序。Android 和 iOS 工程师历来都使用完全不同的语言和 IDE ，尽管两个移动平台之间存在太多相似之处，但在杂糅两个平台的开发是令人生畏并且很罕见的。

但是 Android 和 iOS 开发的语言和工具在过去几年中得到了极大的改善，主要是 **Kotlin** 和 **Swift** 的诞生，这两种表达语言缓解了跨平台学习之间的障碍。掌握了语言基础知识后，代码可以很容易地从 Swift 转换为 Kotlin。

![](https://koenig-media.raywenderlich.com/uploads/2018/10/ktswift-480x310.png)

在本教程中，你将亲眼看到这些语言的相似之处，以及将 Swift 转换为 Kotlin 是多么容易。 首先使用 Xcode ，你将探索用 Swift 编写的 iOS 应用程序，然后你将使用 Kotlin 在 Android Studio 中重新编写相同的应用程序。

> **注意**：熟悉 Swift 和 iOS 的基础知识或 Kotlin 和 Android 的基础知识有助于完成本教程。你可以在[这些教程](https://www.raywenderlich.com/5993-your-first-ios-app)里了解适用于 iOS 的 Swift 或 [这些教程](https://www.raywenderlich.com/291-beginning-android-development-with-kotlin-part-one-installing-android-studio)了解 Android 上的 Kotlin。

## 入门

使用**[此链接](https://koenig-media.raywenderlich.com/uploads/2018/10/PokeTheBear.zip)**下载本教程的入门项目。

### iOS 应用程序架构

在 Xcode 中打开 iOS 示例应用程序的 **Finished **项目并在 iPhone 模拟器上运行它，该应用程序将提示你登录。使用任意至少六个字符长的用户名和密码登录该应用程序，密码应至少包含一个数字字符。

[![Screenshot of login screen](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_1-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_1.png)

通过用户名和密码登录应用程序将带你到主要功能模块：有一头熊在这里！捅它几次看看会发生什么……但你要小心

[![Screenshot of app with image of bear and Poke button](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_2-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_2.png)

现在你将专注于这个简单应用程序架构的两个 `ViewController`，每个交互式屏幕都有一个。

1.  `LoginViewController` 和
2.  `BearViewController`

在项目中找到这些控制器，该应用程序首先启动 `LoginViewController`，它包含了 **Main.storyboard** 中定义的 `TextField` 和 `Button` 的 UI 组件。另外请注意，`LoginViewController` 包含了两个用于验证密码的辅助函数，以及两个用于显示无效密码错误的辅助函数，这些是你将在 Kotlin 中重写的两个 Swift 函数。

`BearViewController` 还引用 **Main.storyboard** 中定义的 UI 组件。通常在 iOS 开发中，每个 `ViewController` 都有单独的 storyboard。在本教程中你将专注于 `ViewController` 逻辑组件而不是 UI。在 `BearViewController` 中，你保持对一个名为 `tapCount`的变量的引用，每次你点击你的 `tapCount` 时它都会更新，从而触发不同的熊的状态。

## Swift 到 Kotlin：基础部分

现在你已经对该应用程序有了个大体的了解，现在可以进行技术改造并使用 playground 深入了解一些语言方面的细节了。对于 Swift，在 Xcode 里点击 **File ▸ New ▸ Playground** 来创建一个新的 **Blank** 的 playground，然后就可以候编写一些代码了！

[![Menu File ▸ New ▸ Playground](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_3-480x191.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_3.png)

[![Blank Swift playground option](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.01.26-AM-446x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.01.26-AM.png)

### 变量和可选项

在 Swift 中有一个称为可选值的概念。可选值包含一个值或为 `nil`。将此代码粘贴到 Swift playground：

```swift
var hello = "world"
hello = "ok"

let hey = "world"
hey = "no"
```

Swift 使用 `var` 和 `let` 来定义变量，两个前缀定义了可变性。`let ` 声明变量之后不可修改，这就是为什么编译器会报错，而 `var` 变量可以在运行时更改。

[![Cannot assign value compiler error](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.04.18-AM-480x52.png)](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.04.18-AM.png)

在 playground 中的代码添加类型声明，现在它看起来会像这样：

```swift
var hello: String? = "world"
hello = "ok"

let hey: String = "world"
hey = "no"
```

通过将这些类型的签名添加到两个变量中，你已经将 `hello` 设置为 **可为空** 的String，由 `String?` 中的 `?` 表示，而 `hey` 是一个 **非空** 的 String。 可为空的变量在 Swift 中称为 **Optional**。

为什么这个细节很重要？空值通常会导致应用程序中出现令人讨厌的崩溃，尤其是当你的数据源并不是始终在客户端中进行定义时（例如，如果你希望服务器获得某个值而且它并没有返回）。使用 `let` 和 `var` 之类的简单前缀允许你进行内置的动态检查以防止程序在值为空时进行编译。有关更多信息，请参阅有关 Swift 中函数编程的 [相关教程](https://www.raywenderlich.com/693-an-introduction-to-functional-programming-in-swift)。

但是 Android 又会是怎样呢？可空性通常被认为是 Java 开发中最大的痛点之一。NPE（或空指针异常）通常是由于空值处理不当导致程序崩溃的原因。 在Java中，你可以做的最有效的事是使用 `@NonNull` 或 `@Nullable` 注解来警告该值是否可为空。但是这些警告不会阻止你编译和运行应用程序。幸运的是，Kotlin 拯救了它！有关更多信息，请参阅 [Kotlin 的介绍](https://www.raywenderlich.com/331-kotlin-for-android-an-introduction)。

在 [try.kotlinlang.org](https://try.kotlinlang.org/) 打开 Kotlin playground 并粘贴刚刚在 Swift playground 中编写的代码来替换 `main` 函数的主体：

[![Kotlin playground with main function body replaced](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.20.37-AM-480x176.png)](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.20.37-AM.png)

太棒了对吧？你可以将代码从一个 playground 复制到另一个 playground，即使 playground 使用不同的语言。 当然，语法并不完全相同。Kotlin 使用 `val` 代替 `let`，所以现在将该关键词更改为 Kotlin 中声明不可变变量的方式，如下所示：

```kotlin
fun main(args: Array<String>) {
  var hello: String? = "world"
  hello = "ok"

  val hey: String = "world"
  hey = "no"
}
```

既然你做出了改变，让我们从 `let` 转向 `val`，你就得到了 Kotlin 代码！

点击右上角的 **Run**，你会看到一个错误：

[![Kotlin compiler error](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_5-480x41.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_5.png)

这就是你在 Swift playground 看到的同样的东西。就像 `let` 一样你也不能重新给 `val` 赋值。

### 操作数组（Map）

数组在 Swift 里作为一等公民，操作起来功能非常强大。如果要将整数数组中的所有值加倍，只需调用 `map` 函数并将其中每个值乘以 2 即可。将此代码粘贴到 Swift playground 中。

```swift
let xs = [1, 2, 3]
print(xs.map { $0 * 2 })
```

在 Kotlin里，你也可以这样做！再一次的，将代码从 Swift playground 复制并粘贴到 Kotlin playground。再进行修改以使其与 Kotlin 语法后，你将得到以下内容：

```kotlin
val xs = listOf(1, 2, 3)
print(xs.map { it * 2 })
```

为了到这一步，你需要：

1.  像上一个示例中那样，再次把 `let` 改为 `val` 。
2.  使用 `listOf()` 而不是方括号来更改声明整数数组的方式。
3.  在 map 函数里把 `$0` 改为 `it` 以引用其中的值。`$0` 表示 Swift 中闭包的第一个元素，而在 Kotlin 中你要在 lambda 表达式中使用保留关键字。

这比手动一次次遍历数组的每一个值再将所有整数乘以 2 要好得多！

**奖励**：现在看看你可以在 Swift 和 Kotlin 中对数组应用哪些其函数把！使整数翻倍就是一个很好的例子。或者可以使用 `filter` 来过滤数组中的特定值，或者 `flatMap`（另一个非常强大的内置数组运算符），用于展平嵌套数组。这是 Kotlin 的一个例子，你可以运行 Kotlin playground 了：

```kotlin
val xs = listOf(listOf(1, 2, 3))
print(xs.flatMap { it.map { it * 2 }})
```

你可以继续使用 Swift 和 Kotlin 的所有优点，但是你没时间用 Kotlin 编写你的 Poke the Bear 应用程序了，你肯定不希望像平常一样丢给你的 Android 用户一个 iOS 应用程序而让他们不知所措！

## 编写 Android 应用程序

在 Android Studio 3.1.4 或更高版本中打开 Android Starter 应用。你可以点击 **File ▸ New ▸ Import Project** 来导入项目，然后选择 Kotlin-Starter 项目的根文件夹来打开项目。这个项目比之前完成的 iOS 应用程序更加简单，但不要害怕！本教程将指导你构建 Android 版本的应用程序！

### 实现 LoginActivity

打开 **app ▸ java ▸ com.raywenderlich.pokethebear ▸ LoginActivity.kt**  文件。这和了 iOS 项目中的  `LoginViewController` 类似。 Android 入门项目有一个与此 activity 相对应的 XML 布局文件，请打开 **app ▸ res ▸ layout ▸ activity_login.xml** 以引用你将在此处使用的视图，即 `login_button` 和 `password_edit_text`。

[![Android login screen](https://koenig-media.raywenderlich.com/uploads/2018/09/activity_login_xml-192x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/09/activity_login_xml.png)

**输入验证**

现在你将从 Swift 项目文件 **LoginViewController.swift** 复制的第一个名为 `containsNumbers` 的函数：￼

```swift
private func containsNumbers(string: String) -> Bool {
  let numbersInString = string.filter { ("0"..."9").contains($0) }
  return !numbersInString.isEmpty
}
```

再一次地，你可以使用你激进的跨平台复制粘贴方法，复制该函数并将其粘贴到 Android Studio 中**LoginActivity.kt** 文件中的 `LoginActivity` 类中。做了一些更改之后，以下是你现在的 Kotlin 代码：

```kotlin
private fun containsNumbers(string: String): Boolean {
  val numbersInString = string.filter { ("0".."9").contains(it.toString()) }
  return numbersInString.isNotEmpty()
}
```

1.  正如你之前在 playground 上所做的那样，将 `let` 更改为 `val` 以声明不可变的返回值。
2.  对于函数声明，你可以体会到从 `func` 中删除 'c' 获得的一些乐趣！你使用 `fun` 而不是 `func` 来声明 Kotlin 里的函数。
3.  Kotlin 中函数的返回值用冒号 `:` 表示而不是 lambda 符号 `->`。
4.  此外，在 Kotlin 中，布尔值被称为 `Boolean` 而不是 `Bool`。
5.  要在 Kotlin 中有声明一个闭区间 `Range`，你需要使用两个点而不是三个，所以 `"0"..."9"` 要改为 `"0".."9"`。
6.  就像你在 playground 中使用 `map` 一样，你还必须将 `$0 ` 转换为 `it`。此外，在 Kotlin 中调用 `contain` 来比较需要将 `it` 转换为 String。
7.  最后，你使用 return 语句在 Kotlin 中进行一些清理。你只需使用 Kotlin 里 `String` 的函数 `isNotEmpty` 来检查是否为空，而不是用 `!`。

现在，代码语句从 Swift 更改为了 Kotlin。

从 iOS 项目中的 `LoginViewController` 复制 `passwordIsValid` 函数并将其粘贴到 Android 项目的类中：

```swift
private func passwordIsValid(passwordInput: String) -> Bool {
  return passwordInput.count >= 6 && self.containsNumbers(string: passwordInput)
}
```

这还需要进行适当的更改来将代码从 Swift 转换为 Kotlin。你应该得到这样的代码：

```kotlin
private fun passwordIsValid(passwordInput: String): Boolean {
  return passwordInput.length >= 6 && this.containsNumbers(string = passwordInput)
}
```

其中还有一些细节的差异：

1.  用 `length` 而不是 `count`
2.  用 `this` 而不是 `self`
3.  用 `string =` 而不是 `string:`

请注意，在此教程中 Kotlin 中不需要用 `string =`，它有助于保持本教程中两种语言之间的相似性。 在其他实践里的标签是 Kotlin 为了使 Java 代码可以访问默认函数参数而包含的更多细节。 阅读有关 `@JvmOverloads` 函数的[更多信息](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.jvm/-jvm-overloads/index.html)以了解有关默认参数的更多信息！

**显示错误**

将 `showLengthError` 和 `showInvalidError` 函数从 iOS 项目中的 `LoginViewController` 复制到 Android 项目中 `LoginActivity` 类里。

`showLengthError` 函数确定用户输入的密码是否包含六个或更多字符，如果不是，则显示相应的警报消息：

```swift
private func showLengthError() {
  let alert = UIAlertController(title: "Error", 
    message: "Password must contain 6 or more characters", 
    preferredStyle: UIAlertControllerStyle.alert)
  alert.addAction(UIAlertAction(title: "Okay", 
    style: UIAlertActionStyle.default, 
    handler: nil))
  self.present(alert, animated: true, completion: nil)
}
```

`showInvalidError` 函数确定用户输入的密码是否包含至少一个数字字符，如果不是，则显示相应的警告消息：

```swift
private func showInvalidError() {
  let alert = UIAlertController(title: "Error", 
    message: "Password must contain a number (0-9)", 
    preferredStyle: UIAlertControllerStyle.alert)
  alert.addAction(UIAlertAction(title: "Okay", 
    style: UIAlertActionStyle.default, handler: nil))
  self.present(alert, animated: true, completion: nil)
}
```

现在，你必须在 Android 应用中将新复制的函数的代码并从 Swift 转换为 Kotlin。你的新 `showError` 函数需要重新引入 Android 的 API。你现在将使用 `AlertDialog.Builder` 实现 `UIAlertController` 相似的功能。你可以在[本教程](https://www.raywenderlich.com/470-common-design-patterns-for-android-with-kotlin)中查看有关常见设计模式的更多信息，例如 AlertDialog。对话框的标题，消息和正按钮字符串已包含在 `strings.xml` 中，因此请继续使用它们！用以下代码替换 `showLengthError`：

```kotlin
private fun showLengthError() {
  AlertDialog.Builder(this)
    .setTitle(getString(R.string.error))
    .setMessage(getString(R.string.length_error_body))
    .setPositiveButton(getString(R.string.okay), null)
    .show()
}
```

使用相同的格式创建含有 `showInvalidError` 的 AlertDialog。用以下内容替换复制的方法：

```kotlin
private fun showInvalidError() {
  AlertDialog.Builder(this)
    .setTitle(getString(R.string.error))
    .setMessage(getString(R.string.invalid_error_body))
    .setPositiveButton(getString(R.string.okay), null)
    .show()
}
```

**处理按钮点击实践**

现在你已经完成了验证和错误显示功能，通过实现 `loginButtonClicked` 函数可以把它们放在一起。Android 和 iOS 之间需要注意的一个很有趣的区别是，你的 Android 视图是在第一个生命周期回调 `onCreate()` 中显式创建和设置的，而 iOS 应用中的 **Main.storyboard** 是在 Swift 中隐式链接的。你可以在 [此处](https://www.raywenderlich.com/500-introduction-to-android-activities-with-kotlin) 详细了解本教程中的 Android 生命周期。

这是 iOS 项目中的 `loginButtonTapped` 函数。

```swift
@IBAction func loginButtonTapped(_ sender: Any) {
  let passwordInput = passwordEditText.text ?? ""
  if passwordIsValid(passwordInput: passwordInput) {
    self.performSegue(withIdentifier: "pushBearViewController", sender: self)
  } else if passwordInput.count < 6 {
    self.showLengthError()
  } else if !containsNumbers(string: passwordInput) {
    self.showInvalidError()
  }
}
```

将 iOS 项目中 `loginButtonTapped` 函数的主体部分复制并粘贴到 Android 项目中 `loginButtonClicked` 函数的主体中，并进行你现在已经掌握的小改动，将语法从 Swift 更改为 Kotlin。

```kotlin
val passwordInput = this.password_edit_text.text.toString()
if (passwordIsValid(passwordInput = passwordInput)) {
  startActivity(Intent(this, BearActivity::class.java))
} else if (passwordInput.length < 6) {
  this.showLengthError()
} else if (!containsNumbers(string = passwordInput)) {
  this.showInvalidError()
}
```

这里有两个不同之处，分别是从 EditText 中提取字符串的方法以及显示新 activity 的方法。你可以使用语句 `this.password_edit_text.text.toString()` 从 `passwordInput` 视图中获取文本。 然后，调用 `startActivity` 函数传入 `Intent` 以启动 `BearActivity` 活动。其余的都应该非常简单。

你的 `LoginActivity` 现已完成。现在 Android Studio 中编译并运行应用程序，查看你的设备或自带模拟器中显示的第一个已实现的活动。输入用户名的任何字符串值，并使用有效和无效的密码组合，以确保你的错误对话框显示达到了预期。

[![Kotlin login screen](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_6-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_6.png)

成功登录后将屏幕上将显示一只熊，你现在可以来实现它了！

### 实现熊的活动

打开 **app ▸ java ▸ com.raywenderlich.pokethebear ▸ BearActivity.kt**，你的 BearViewController.swift 文件即将变成 Kotlin 的版本。你将通过实现辅助函数 `bearAttack` 和 `reset` 来开始修改此 Activity。你将在 Swift 文件中看到 `bearAttack` 负责设置UI状态，隐藏Poke按钮五秒钟，然后重置屏幕：

```swift
private func bearAttack() {
  self.bearImageView.image = imageLiteral(resourceName: "bear5")
  self.view.backgroundColor = .red
  self.pokeButton.isHidden = true
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5), 
    execute: { self.reset() })
}
```

从 iOS 项目中复制该函数并将其粘贴到 Android 项目中的`bearAttack` 函数体中，然后进行一些小的语法修改让 Kotlin 中的 `bearAttack` 函数的主体如下所示：

```kotlin
private fun bearAttack() {
  this.bear_image_view.setImageDrawable(getDrawable(R.drawable.bear5))
  this.bear_container.setBackgroundColor(getColor(R.color.red))
  this.poke_button.visibility = View.INVISIBLE
  this.bear_container.postDelayed({ reset() }, TimeUnit.SECONDS.toMillis(5))
}
```

你做出的修改包括：

1.  调用 `setImageDrawable` 函数将 `bear_image_view` 的图像资源设置为 **bear5.png** 可绘制的资源，该资源已包含在 **app ▸ res ▸ drawable** 目录下。
2.  然后调用 `setBackgroundColor` 函数将 `bear_container` 视图的背景设置为预先定义的颜色 `R.color.red`。
3.  将 `isHidden` 属性更改为 `visibility`，而不是将按钮的可见性切换为 `View.INVISIBLE`。
4.  也许你对代码的最不直观的改变是重写 `DispatchQueue`，但不要害怕！Android的 `asyncAfter` 是一个简单的 `postDelayed` 动作，你在 `bear_container` 视图上设置。

几乎就要完成了！还有另一个要从 Swift 转换为 Kotlin 的功能。复制 Swift `reset` 函数的主体并将其粘贴到Android项目的 `BearActivity` 类重置中来重复这个转换过程：

```swift
self.tapCount = 0
self.bearImageView.image = imageLiteral(resourceName: "bear1")
self.view.backgroundColor = .white
self.pokeButton.isHidden = false
```

然后进行类似的更改：

```kotlin
this.tapCount = 0
this.bear_image_view.setImageDrawable(getDrawable(R.drawable.bear1))
this.bear_container.setBackgroundColor(getColor(R.color.white))
this.poke_button.visibility = View.VISIBLE
```

最后一步是从 iOS 项目中复制 `pokeButtonTapped` 函数的主体并将其粘贴到 Android 项目中。由于 Swift 和 Kotlin 之间的相似性，这个 `if/else` 语句将也需要对 Android 作出更改，虽然修改非常小。这样确保了你的 Kotlin 中 `pokeButtonClicked` 函数主体看起来像这样：

```kotlin
this.tapCount = this.tapCount + 1
if (this.tapCount == 3) {
  this.bear_image_view.setImageDrawable(getDrawable(R.drawable.bear2))
} else if (this.tapCount == 7) {
  this.bear_image_view.setImageDrawable(getDrawable(R.drawable.bear3))
} else if (this.tapCount == 12) {
  this.bear_image_view.setImageDrawable(getDrawable(R.drawable.bear4))
} else if (this.tapCount == 20) {
  this.bearAttack()
}
```

> **额外声明**：这个if / else 阶梯语句可以很容易地用更具表现力的[控制流语句](https://kotlinlang.org/docs/reference/control-flow.html)替换，比如在Kotlin中的 `switch` 或者 `when`。

如果你想简化逻辑，请尝试一下。

现在所有功能都已从 iOS 应用程序移植并从 Swift 转换为 Kotlin。在真机或模拟器中编译并运行应用程序并开始使用，现在你可以在登录屏幕后面出现了你的毛茸茸的朋友。

[![Android screen with bear and poke button](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_7-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_7.png)

恭喜你，你已将 Swift 转换为 Kotlin，将 iOS 应用程序转换为全新的 Android 应用程序。你已经通过将 Swift 代码从 Xcode 中的 iOS 项目移动到 Android Studio 中的 Android 应用程序，将 Swift 转换为 Kotlin 来实现跨平台！没有多少人和开发人员会说，而且这也非常简洁。

### 接下来该干嘛？

使用本教程顶部的 **链接** 下载已经完成的项目来看看它是如何进行的。

如果你是一名 Swift 开发人员，或者是 Android 中的 Kotlin 新手，请查看[Kotlin 官方文档](https://kotlinlang.org/docs/reference/)以更深入地了解这些语言。你已经知道如何运行 Kotlin playground 来尝试用代码片段，并且可以在文档中编写可运行的代码小部件。 如果你已经是 Kotlin 开发人员，请尝试在 Swift 中编写应用程序。

如果你喜欢 Swift 和 Kotlin 的并排比较，请在[本文](http://nilhcem.com/swift-is-like-kotlin/)中查看更多内容。你忠实的作者还与 UIConf 的 iOS 同事就 Swift 和 Kotlin 进行了一个快速的讨论，你可以在[这里](https://www.youtube.com/watch?v=_DuGaAkQSnM)观看到。

我们希望你喜欢本教程，了解如何把 Swift 编写的 iOS 应用程序转换为 Kotlin 以及创建一个全新的 Android 应用程序。我们也希望你继续探索这两种语言和两种平台。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
