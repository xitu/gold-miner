> * 原文地址：[Converting your iOS App to Android Using Kotlin](https://www.raywenderlich.com/7266-converting-your-ios-app-to-android-using-kotlin?utm_source=mobiledevweekly&utm_medium=email)
> * 原文作者：[Lisa Luo](https://www.raywenderlich.com/u/luoser)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/converting-your-ios-app-to-android-using-kotlin.md](https://github.com/xitu/gold-miner/blob/master/TODO1/converting-your-ios-app-to-android-using-kotlin.md)
> * 译者：
> * 校对者：

# Converting your iOS App to Android Using Kotlin

## In this tutorial, you’ll see first-hand how similar these languages are and how simple it is to convert Swift to Kotlin by porting an iOS app to Android.

Mobile devices are your everyday companions: You bring them in your backpack and pockets nearly everywhere you go. Technology continues to tailor to your mobile devices, making mobile development increasingly more prevalent as a hobby and profession.

Often, a developer will choose one platform for which to develop, the most common being Android or iOS. This choice is often guided by one’s resources (e.g., her or his personal device) or circumstance. Many developers tend to stick to building exclusively for their one chosen platform. Android and iOS engineers have historically worked with quite different languages and IDEs, making crossover between developing for both platforms daunting and rare, despite all the similarities between the two mobile platforms.

But languages and tooling for Android and iOS development have improved immensely over just the past few years — primarily the emergence of _Kotlin_ and _Swift_, two expressive languages that have eased the barrier between cross-platform learning. After mastering the language fundamentals, code can easily be translated from Swift to Kotlin.

![](https://koenig-media.raywenderlich.com/uploads/2018/10/ktswift-480x310.png)

In this tutorial, you’ll see first-hand how similar these languages are and how simple it is to translate Swift to Kotlin. First, using Xcode, you will explore an iOS app written in Swift, then you will re-write the same app in Kotlin using Android Studio.

> _Note:_ Some familiarity of Swift and iOS fundamentals _or_ Kotlin and Android fundamentals is helpful for completing this tutorial. You can catch up on Swift for iOS in [these tutorials](https://www.raywenderlich.com/5993-your-first-ios-app) or Kotlin on Android [here](https://www.raywenderlich.com/291-beginning-android-development-with-kotlin-part-one-installing-android-studio).

## Getting Started

Download the starter projects for this tutorial using the _Download materials_ button at the top or bottom of this tutorial.

### iOS App Architecture

Open the iOS sample app final project in Xcode and run it in the iPhonesimulator. The app will prompt you to log in. Log in to the app using any username and a password that is at least six characters long. The password should contain at least one numeric character.

[![Screenshot of login screen](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_1-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_1.png)

Logging in to the app via username and password brings you to the main attraction: the bear! Give it a poke a few times to see what happens… but be careful.

[![Screenshot of app with image of bear and Poke button](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_2-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_2.png)

Now, you’ll focus on the two `ViewController`s for the architecture of this simple app, one for each of your interactive screens.

1.  `LoginViewController` and
2.  `BearViewController`

Locate these controllers in the project. The app launches the `LoginViewController` first, which holds the `TextField` and `Button` UI components defined in the _Main.storyboard_. Also, note that the `LoginViewController` contains two helper functions for validating the password, as well as two helper functions for displaying invalid password errors. These are two of the Swift functions that you’ll re-write in Kotlin.

The `BearViewController` also references UI components defined in the shared _Main.storyboard_. Often, in iOS development, each `ViewController` will have separate storyboard views. In this tutorial, you’ll focus on the `ViewController` logic components rather than the UI. In the `BearViewController`, you keep a reference to a variable called `tapCount` that updates every time you tap your `pokeButton`, triggering the different bear states.

## Swift to Kotlin: Fundamentals

Now that you have a general overview of the app, take a technical detour and dive into some language specifics using playgrounds. For Swift, create a new _Blank_ playground in Xcode using _File ▸ New ▸ Playground…_ and then it’s time to write some code!

[![Menu File ▸ New ▸ Playground](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_3-480x191.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/ios_3.png)

[![Blank Swift playground option](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.01.26-AM-446x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.01.26-AM.png)

### Variables and Optionals

In Swift there is a concept called _optional_ values. An optional value either contains a value, or `nil`. Paste this code into your Swift playground:

```
var hello = "world"
hello = "ok"

let hey = "world"
hey = "no"
```

Swift uses `var` and `let` to define variables, two prefixes that define mutability. You can only define variables declared with `let` once, which is why you see the compiler error, whereas `var` variables can change during runtime.

[![Cannot assign value compiler error](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.04.18-AM-480x52.png)](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.04.18-AM.png)

Add type signatures to your code in the playground, so that it now looks like this:

```
var hello: String? = "world"
hello = "ok"

let hey: String = "world"
hey = "no"
```

By adding these type signatures to the two variables, you’ve made `hello` a _nullable_ String, signified by the `?` in `String?`, while `hey` is a _non-null_ String. Nullable variables are called _Optional_ in Swift.

Why is this detail important? Null values often cause pesky crashes in apps, especially when your source of data isn’t always defined within the client (e.g., if you are expecting a value from the server, and it doesn’t come back). Having simple prefixes such as `let` and `var` allow you to have a built-in, on-the-fly check that prevents the program from compiling when the values can be null. See [this related tutorial](https://www.raywenderlich.com/693-an-introduction-to-functional-programming-in-swift) about functional programming in Swift for more information.

But what about Android? Nullability is often cited as one of the biggest pain points of Android development in Java. NPEs — or Null Pointer Exceptions — are frequently the cause of program crashes due to the poor handling of null values. In Java, the best you can do is to use the `@NonNull` or `@Nullable` support annotations to warn of nullable values. However, these warnings don’t prevent you from compiling and shipping your apps. Fortunately, Kotlin is here to save the day! [See this introduction to Kotlin](https://www.raywenderlich.com/331-kotlin-for-android-an-introduction) for more information.

Open up the Kotlin playground at [try.kotlinlang.org](https://try.kotlinlang.org/) and paste the lines of code that you just wrote in the Swift playground to replace the body of the `main` function:

[![Kotlin playground with main function body replaced](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.20.37-AM-480x176.png)](https://koenig-media.raywenderlich.com/uploads/2018/09/Screen-Shot-2018-09-17-at-11.20.37-AM.png)

Amazing, right? You can copy code from one playground to another, even though the playgrounds use different languages. Of course, the syntax isn’t exactly the same. Kotlin uses `val` instead of `let`, so now change that modifier to the Kotlin way of declaring an immutable variable, like so:

```
fun main(args: Array<String>) {
  var hello: String? = "world"
  hello = "ok"

  val hey: String = "world"
  hey = "no"
}
```

Now that you changed `let` to `val`, you have Kotlin code!

Click _Run_ in the top right corner and you’ll see the meaningful error:

[![Kotlin compiler error](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_5-480x41.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_5.png)

This is saying the same thing you saw in the Swift playground. Just like `let`, you cannot reassign `val`.

### Manipulating Lists (Map)

First-class list manipulation is another extremely powerful feature of Swift. If you want to double all the values in an integer array, you simply call `map`on the array and multiply each value by two. Paste this code in the Swift playground.

```
let xs = [1, 2, 3]
print(xs.map { $0 * 2 })
```

In Kotlin, you can do the same! Again, copy and paste the code from the Swift playground to the Kotlin playground. After making changes to make it match Kotlin syntax, you’ll have this:

```
val xs = listOf(1, 2, 3)
print(xs.map { it * 2 })
```

To get here, you:

1.  Change `let` to `val` again as you did in the previous example.
2.  Change the way you declare your array of integers by using `listOf()` instead of square brackets.
3.  Change `$0` to reference the value inside the map function to `it`.`$0` represents the first element of a closure in Swift; in Kotlin, you use the reserved keyword `it` in a lambda.

This is so much better than manually having to loop through an array one value at a time to multiply all the integer values by two!

_Bonus_: See what other functions you can apply to lists in Swift and Kotlin! Doubling integers is a great example. Or one could use `filter` to filter for specific values in the list, or `flatMap`, another quite powerful, built-in list operator that flattens nested arrays. Here’s an example in Kotlin that you can run in the Kotlin playground:

```
val xs = listOf(listOf(1, 2, 3))
print(xs.flatMap { it.map { it * 2 }})
```

You could go on for quite a few tutorials with all of the Swift and Kotlin goodness, but you’d run out of time to write your Poke the Bear app in Kotlin, and you certainly don’t want to leave your Android users hanging with just an iOS app as per usual!

## Writing the Android App

Open the starter Android app in Android Studio 3.1.4 or higher. Again, you can find this by clicking the _Download materials_ button at the top of bottom of this tutorial. You can open the project by going to _File ▸ New ▸ Import Project_, and selecting the root folder of the starter project. This project is a bit more bare bones than the completed iOS app — but not to fear! This tutorial will guide you through building the Android version of the app!

### Implementing the LoginActivity

Open the _app ▸ java ▸ com.raywenderlich.pokethebear ▸ LoginActivity.kt_ file in the Android project. This mirrors your `LoginViewController` in the iOS project. The Android starter project has an XML layout file corresponding to this activity so take a peek at the _app ▸ res ▸ layout ▸ activity_login.xml_ to reference the views you’ll use here, namely the `login_button` and `password_edit_text`.

[![Android login screen](https://koenig-media.raywenderlich.com/uploads/2018/09/activity_login_xml-192x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/09/activity_login_xml.png)

**Input Validation**

The first function you’ll copy over from your Swift project file, _LoginViewController.swift_, is the function named `containsNumbers`:  
￼
```
private func containsNumbers(string: String) -> Bool {
  let numbersInString = string.filter { ("0"..."9").contains($0) }
  return !numbersInString.isEmpty
}
```

Again, using your radical cross-platform copy-and-paste approach, copy the function and paste it inside the `LoginActivity` class in the _LoginActivity.kt_ file in Android Studio. After making some changes, here’s the Kotlin code you have:

```
private fun containsNumbers(string: String): Boolean {
  val numbersInString = string.filter { ("0".."9").contains(it.toString()) }
  return numbersInString.isNotEmpty()
}
```

1.  As you previously did in your playground, you change `let` to `val` for the immutable declaration of the return value.
2.  For the function declaration, drop the ‘c’ from `func` and have some `fun`! You declare Kotlin methods using `fun` rather than `func`.
3.  The return value of the function in Kotlin is denoted by a colon `:` rather than a lambda symbol`->`.
4.  Also, in Kotlin a boolean is called `Boolean` instead of `Bool`.
5.  To have a closed `Range` in Kotlin, you need to use two dots instead of 3, so `"0"..."9"` changes to `"0".."9"`.
6.  Just as you did with the `map` example in the playground, you also have to convert `$0` to `it`. Also, convert `it` to a String for the `contains` comparison in Kotlin.
7.  Finally, you do a little cleanup in Kotlin with the return statement. Instead of using `!` to negate an empty check, you simply use the Kotlin `String` function `isNotEmpty`.

Now, the code syntax is changed from Swift to Kotlin.

Copy over the `passwordIsValid` function from the `LoginViewController` in the iOS project and paste it into the class of the Android project:

```
private func passwordIsValid(passwordInput: String) -> Bool {
  return passwordInput.count >= 6 && self.containsNumbers(string: passwordInput)
}
```

Make the appropriate changes to translate the code from Swift to Kotlin again; you should end up with something like this:

```
private fun passwordIsValid(passwordInput: String): Boolean {
  return passwordInput.length >= 6 && this.containsNumbers(string = passwordInput)
}
```

Some differences here is that you’re using:

1.  `length` instead of `count`,
2.  `this` instead of `self`, and
3.  `string =` instead of `string:`.

Note that the `string =` param label is not required in Kotlin. It helps with keeping the similarity between both languages for this tutorial. In practice, labels are a wonderful detail that Kotlin included to make default function parameters reachable from Java code. Read up more on `@JvmOverloads` functions [here](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.jvm/-jvm-overloads/index.html) to learn more about default params!

_Showing Errors_

Copy the `showLengthError` and `showInvalidError` functions over from the `LoginViewController` in the iOS project to the body of the `LoginActivity` class in the Android project.

The `showLengthError` function determines whether or not the password entered by the user contains six or more characters, and displays an appropriate alert message if it is not:

```
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

The `showInvalidError` function determines whether or not the password entered by the user contains at least one numeric character, and the it displays an appropriate alert message if it does not:

```
private func showInvalidError() {
  let alert = UIAlertController(title: "Error", 
    message: "Password must contain a number (0-9)", 
    preferredStyle: UIAlertControllerStyle.alert)
  alert.addAction(UIAlertAction(title: "Okay", 
    style: UIAlertActionStyle.default, handler: nil))
  self.present(alert, animated: true, completion: nil)
}
```

Now, you must translate the newly copied functions’ code syntax from Swift to Kotlin in your Android app. Your new `showError` functions will require a reach back into the knowledge of the good ol’ Android API! You’ll now implement the equivalent of `UIAlertController` using an `AlertDialog.Builder`. You can see more information about common design patterns such as AlertDialog in [this tutorial](https://www.raywenderlich.com/470-common-design-patterns-for-android-with-kotlin). The dialog’s title, message and positive button strings are already included in your `strings.xml`, so go ahead and use those! Replace `showLengthError` with this code:

```
private fun showLengthError() {
  AlertDialog.Builder(this)
    .setTitle(getString(R.string.error))
    .setMessage(getString(R.string.length_error_body))
    .setPositiveButton(getString(R.string.okay), null)
    .show()
}
```

Use the same format to create your `showInvalidError` AlertDialog. Replace the copied method with the following:

```
private fun showInvalidError() {
  AlertDialog.Builder(this)
    .setTitle(getString(R.string.error))
    .setMessage(getString(R.string.invalid_error_body))
    .setPositiveButton(getString(R.string.okay), null)
    .show()
}
```

_Handling Button Taps_

Now that you have written the validation and error display functions, put it all together by implementing your `loginButtonClicked` function! An interesting difference to note between Android and iOS is that your Android view is created and set explicitly in your first lifecycle callback, `onCreate()`, whereas your _Main.storyboard_ in the iOS app is implicitly linked in Swift. You can learn more about the Android lifecycle in this tutorial [here](https://www.raywenderlich.com/500-introduction-to-android-activities-with-kotlin).

Here is the `loginButtonTapped` function from the iOS project.

```
@IBAction func loginButtonTapped(_ sender: Any) {
  let passwordInput = passwordEditText.text ?? ""
  if (passwordIsValid(passwordInput: passwordInput)) {
    self.performSegue(withIdentifier: "pushBearViewController", sender: self)
  } else if (passwordInput.count < 6) {
    self.showLengthError()
  } else if (!containsNumbers(string: passwordInput)) {
    self.showInvalidError()
  }
}
```

Copy and paste the body of the `loginButtonTapped` function from the iOS project into the body of the `loginButtonClicked` function in the Android project and make the small changes you have now mastered to change the syntax from Swift to Kotlin.

```
val passwordInput = this.password_edit_text.text.toString()
if (passwordIsValid(passwordInput = passwordInput)) {
  startActivity(Intent(this, BearActivity::class.java))
} else if (passwordInput.length < 6) {
  this.showLengthError()
} else if (!containsNumbers(string = passwordInput)) {
  this.showInvalidError()
}
```

Two differences here are the method of extracting the string from the EditText and the means of displaying the new activity. You use the statement `this.password_edit_text.text.toString()` to get the text from the `passwordInput` view. Then, make a call to the `startActivity` function passing in an `Intent` to launch the `BearActivity` activity. The rest should be pretty straightforward.

Your `LoginActivity` is now done. _Build and run_ the app in Android Studio to see your first implemented activity displayed on a device or in the emulator. Enter any string value for the username and play around with valid and invalid password combinations to ensure that your error dialogs show as expected.

[![Kotlin login screen](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_6-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_6.png)

A successful login in will reveal the bear screen, which you’ll implement right now!

### Implementing the BearActivity

Open _app ▸ java ▸ com.raywenderlich.pokethebear ▸ BearActivity.kt_ — your soon-to-be Kotlin version of _BearViewController.swift_. You'll start modifying this Activity by implementing the helper functions, `bearAttack` and `reset`. You’ll see in the Swift file that `bearAttack` is responsible for setting the UI state, hiding the Poke button for five seconds, and then resetting the screen:

```
private func bearAttack() {
  self.bearImageView.image = imageLiteral(resourceName: "bear5")
  self.view.backgroundColor = .red
  self.pokeButton.isHidden = true
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5), 
    execute: { self.reset() })
}
```

Copy the function from the iOS project, paste it into the body of the `bearAttack` function in the Android project, and then make some minor syntax changes. Make the remaining changes so the body of the Kotlin `bearAttack` function looks like this:

```
private fun bearAttack() {
  this.bear_image_view.setImageDrawable(getDrawable(R.drawable.bear5))
  this.bear_container.setBackgroundColor(getColor(R.color.red))
  this.poke_button.visibility = View.INVISIBLE
  this.bear_container.postDelayed({ reset() }, TimeUnit.SECONDS.toMillis(5))
}
```

The changes you made include:

1.  Call the `setImageDrawable` function to set the image resource for the `bear_image_view` to the _bear5.png_ drawable resource, which is already included in the project in the _app ▸ res ▸ drawable_ folder.
2.  Then call the `setBackgroundColor` function to set the `bear_container` view’s background to your predefined color resource, `R.color.red`.
3.  Change the `isHidden` property to be `visibility` instead to toggle your button’s visibility to `View.INVISIBLE`.
4.  Perhaps the least intuitive change to the code you made is re-writing the `DispatchQueue` action, but have no fear! Android’s sister to `asyncAfter` is a simple `postDelayed` action that you set on the view `bear_container`.

Getting close! There is another function to translate from Swift to Kotlin. Repeat the conversion process by copying the body of the Swift `reset` function and pasting it into the Android project's `BearActivity` class `reset`:

```
self.tapCount = 0
self.bearImageView.image = imageLiteral(resourceName: "bear1")
self.view.backgroundColor = .white
self.pokeButton.isHidden = false
```

Then make similar changes resulting in:

```
this.tapCount = 0
this.bear_image_view.setImageDrawable(getDrawable(R.drawable.bear1))
this.bear_container.setBackgroundColor(getColor(R.color.white))
this.poke_button.visibility = View.VISIBLE
```

The last step to is to copy the body of the `pokeButtonTapped` function from the iOS project and paste it into the Android project. This `if/else` statement will require very little Android-specific changes, thanks to the similarities between Swift and Kotlin. Make sure the body of your Kotlin `pokeButtonClicked` looks like this:

```
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

> _Bonus_: This if/else ladder can easily be replaced with more expressive [control-flow statements](https://kotlinlang.org/docs/reference/control-flow.html), like a `switch`, or `when` in Kotlin.

Try it out if you'd like to simplify the logic.

Now all the functions have been ported from the iOS app and translated from Swift to Kotlin. _Build and Run_ the app on a device or in the emulator to give it a go and you can now visit your furry friend behind the Login screen.

[![Android screen with bear and poke button](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_7-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/kotlin_7.png)

Congratulations — you have translated an iOS app into a brand new Android app by converting Swift to Kotlin. You’ve crossed platforms by moving Swift code from an iOS project in Xcode into an Android app in Android Studio, changing Swift to Kotlin! Not many people and developers can say that and that’s pretty neat.

### Where to Go From Here

Download the fully finished projects using the _Download materials_ button at the top or bottom of this tutorial to see how it went.

If you’re a Swift developer or new to Kotlin in Android, [check out the official Kotlin docs](https://kotlinlang.org/docs/reference/) to go more in depth with the languages. You already know how to run the Kotlin playground to try out snippets, and there are runnable code widgets written right into the docs. If you are already a Kotlin developer, try writing an app in Swift.

If you enjoyed the side-by-side comparisons of Swift and Kotlin, [check out more of them in this article](http://nilhcem.com/swift-is-like-kotlin/). Your faithful author also gave a quick talk about Swift and Kotlin with an iOS colleague at UIConf, [which you can watch here](https://www.youtube.com/watch?v=_DuGaAkQSnM).

We hope that you have enjoyed this tutorial on how to convert your iOS app written in Swift to Kotlin creating a whole new Android app. We also hope you continue to explore both languages and both platforms. If you have any questions or comments, please join us the forum discussion below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
