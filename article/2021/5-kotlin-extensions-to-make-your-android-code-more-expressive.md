> - 原文地址：[5 Kotlin Extensions To Make Your Android Code More Expressive](https://betterprogramming.pub/5-kotlin-extensions-to-make-your-android-code-more-expressive-4c9243cb9466)
> - 原文作者：[Siva Ganesh Kantamani](https://medium.com/@sgkantamani)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-kotlin-extensions-to-make-your-android-code-more-expressive.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-kotlin-extensions-to-make-your-android-code-more-expressive.md)
> - 译者：[keepmovingljzy](https://github.com/keepmovingljzy)
> - 校对者：[PassionPenguin](https://github.com/PassionPenguin)

# 5 个 Kotlin 扩展技巧让你的 Android 代码更具表现力

![](https://cdn-images-1.medium.com/max/12000/0*7wBRYeSryL8YT5u_)

你可能已经看过一堆关于 Kotlin 扩展相关的文章了，但这篇文章不仅仅只是关于扩展。它是关于如何让你的代码更具表现力，所以我专门讲解并概括我的顶级扩展，使代码尽可能自然一些。

本文的主要目的是学习如何使用扩展，而不是复制代码片段，以自己的方式表达代码。

## 介绍

Kotlin 是一种现代的、富有表现力的语言，它是为开发人员而构建的。在我看来，好的 Kotlin 代码就是能够以自然、可读的方式表达自己的代码。

从 Java 转到 Kotlin 对我来说在很多方面都是一个巨大的转变，但我认为这在每个方面都是最好的。你可以参考 [我之前的文章](https://medium.com/better-programming/my-journey-from-java-to-kotlin-3bfcbcc6b734)。

我最喜欢 Kotlin 的一点是扩展。作为一名移动端 Java 开发人员，我从未想过向任何类添加自定义功能，尤其是向第三方库中的类添加自定义功能。但是当我听到扩展的概念时，着实让我大吃一惊。对于 Android 开发者来说，这个特性打开了大量代码增强的大门。

> “Kotlin 提供了新功能扩展类的能力，而无需继承该类或使用类似装饰器之类的设计模式。这是通过称为扩展的特殊声明来完成。” — [Kotlin 文档](https://kotlinlang.org/docs/extensions.html)

如果你想学习更多 Kotlin 扩展相关知识，阅读这篇文章：[使用 Kotlin 进行高级 Android 编程](https://medium.com/better-programming/advanced-android-programming-with-kotlin-5e40b1be22bb)

我使用 Kotlin 扩展来使代码更具表现力，并使语言尽可能自然。

不要再拖了，开干！

## 1. 显示，隐藏，移除（视图）

移动开发人员的常见任务之一是隐藏和显示视图。如果你使用 Java，你需要调用 `setVisibility` 方法传入`View.VISIBILE`或 `View.GONE` 来实现。 如下：

```
view.setVisibility(View.GONE)
```

代码可以工作而且没有问题。但是使用 `set` 和 `get` 方法让它看起来更笨拙而不自然，Kotlin 提供了一种便利的方式来赋值，而不需要使用 `set` 和 `get` 方法。现有代码如下：

```
view.visibility = View.GONE
```

即使现在，由于赋值操作符的存在，它看起来也不自然，所以我想，“为什么我不使用扩展来使它尽可能自然呢？”这时我开始使用以下扩展：

```Kotlin
fun View.show(){
    this.visibility = View.VISIBLE
}

fun View.hide() {
    this.visibility = View.INVISIBLE
}

fun View.remove(){
    this.visibility = View.GONE
}
```

现在你可以使用如下方式：

```
view.show()
view.hide() 
view.remove()
```

现在看起来更友好更自然。我很乐意优化它，所以如果你有任何建议，请留下评论。

## 2. 校验

在任何开发环境中，验证字符串都是至关重要的。回到 2015 年，当我刚开始我的职业生涯，我看到一些应用程序显示`null`在一些文本字段中。这是因为没有适当的验证。

在使用 Kotlin 之前，我会维护一个实用工具类，并包含一些静态函数来验证字符串。看看 Java 中的一个简单验证函数：

```Java
// Function in utility class
public static Boolean isStringNotNullOrEmpty(String data){
    return data != null && data.trim().length() > 0 
            && !data.equalsIgnoreCase("null");
}

// Usage at call site
if(Utility.isStringNotNullOrEmpty(data))
```

从本质上讲数据类型不过是类。 因此我们可以使用 Kotlin 扩展来添加验证功能。 例如，我创建了以下 Kotlin 扩展，其数据类型为 `String`，以检查其是否有效：

```Kotlin
//Extension function
fun String?.valid() : Boolean =
        this != null && !this.equals("null", true)
                && this.trim().isNotEmpty()

// Usage at call site
if(data.valid())
```

显然，`data.valid()` 看起来比 Utility.isStringNotNullOrEmpty(data) 更简洁，可读性更好。调用数据类型上的扩展函数似乎比触发某些工具类函数更自然。下面是几个扩展，可以启发你编写自己的验证扩展：

```Kotlin
//Email Validation
fun String.isValidEmail(): Boolean
  = this.isNotEmpty() && Patterns.EMAIL_ADDRESS.matcher(this).matches()

//Phone number format
fun String.formatPhoneNumber(context: Context, region: String): String? {
    val phoneNumberKit = PhoneNumberUtil.createInstance(context)
    val number = phoneNumberKit.parse(this, region)
    if (!phoneNumberKit.isValidNumber(number))
        return null

    return phoneNumberKit.format(number, PhoneNumberUtil.PhoneNumberFormat.INTERNATIONAL)
}
```

## 3. 提取 Bundle 参数

在 Android 中，我们通过捆绑一个键值对在组件之间传递数据。通常在从 bundle 中检索数据之前，我们必须检查一些东西。首先，我们应该检查我们正在寻找的键是否在 bundle 中。然后我们需要检查它是否有一个有效的值。通常做法如下：

```Kotlin
fun extractData(extras : Bundle){
    if (extras.containsKey("name") && extras.getString("name").valid()){
        val name = extras.getString("name")
    }
}
```

这涉及到更多的手写代码，坦率地说，它看起来并不漂亮。想象一下，如果有 5 个参数，代码看起来会有多乏味。就像我说的，代码应该尽可能自然，而且需要最少的手动调用。

在这里，我使用了四个扩展函数：两个用于 Activity，两个用于 Fragment。同样，为每个组件提供一对，以获得一个非空值或一个可空值。如下：

```Kotlin
// Activity related
inline fun <reified  T : Any> Activity.getValue(
    lable : String, defaultvalue : T? = null) = lazy{
    val value = intent?.extras?.get(lable)
    if (value is T) value else defaultvalue
}

inline fun <reified  T : Any> Activity.getValueNonNull(
    lable : String, defaultvalue : T? = null) = lazy{
    val value = intent?.extras?.get(lable)
    requireNotNull((if (value is T) value else defaultvalue)){lable}
}

// Fragment related
inline fun <reified T: Any> Fragment.getValue(lable: String, defaultvalue: T? = null) = lazy {
    val value = arguments?.get(lable)
    if (value is T) value else defaultvalue
}

inline fun <reified T: Any> Fragment.getValueNonNull(lable: String, defaultvalue: T? = null) = lazy {
    val value = arguments?.get(lable)
    requireNotNull(if (value is T) value else defaultvalue) { lable }
}
```

要了解内联函数和具体类型等高级特性，请参考[系列文章](https://medium.com/better-programming/advanced-android-programming-with-kotlin-5e40b1be22bb)。

现在让我们看看如何使用上面的扩展：

```Kotlin
val firstName by getValue<String>("firstName") // String?
val lastName by getValueNonNull<String>("lastName") // String
```

这种方式有三个优点：

1. 简洁，可读性好，代码量少。
2. 空安全。
3. 懒加载。

## 4. 资源扩展

在 Android 中，我们需要通过资源类访问项目资源。这涉及到一些每次需要从资源文件中检索数据时都需要手动编写的样板代码。如果没有任何扩展，检索 color 或 drawable 代码如下：

```Kotlin
val color = ContextCompat.getColor(ApplicationCalss.instance, R.color.dark_blue)
val drawable = ContextCompat.getDrawable(MavrikApplication.instance, R.drawable.launcher)
```

当尝试获取任何资源时，您需要通过生成的 R 文件中的资源 ID 访问它。ID 的数据类型是`Int`。因此，我们可以为每种资源类型编写 integer 类的扩展，并使用它们以减少样板代码增加可读性：

```Kotlin
//Extensions
fun Int.asColor() = ContextCompat.getColor(ApplicationCalss.instance, this)
fun Int.asDrawable() = ContextCompat.getDrawable(MavrikApplication.instance, this)

//Usage at call site
val color = R.color.dark_blie.asColor()
val drawable = R.drawable.launcher.asDrawable()
```

## 5. 显示 Alert Dialog, Toast, or Snackbar

当涉及到前端开发时，无论使用哪种平台，有时都需要向用户显示弹出框。可能是用于显示不重要的数据，或者弹出提示用户确定或者显示一些错误。

当你想要显示一个简单的弹出信息，你需要写的代码可能会很长。甚至不打算弹出对话框。这些都是常见的场景。它们应该简洁且易于实现。这就是为什么我使用下面的扩展，使代码尽可能被简洁的调用：

```Kotlin
// Show alert dialog
fun Context.showAlertDialog(positiveButtonLable : String = getString(R.string.okay),
                            title : String = getString(R.string.app_name) , message : String,
                               actionOnPositveButton : () -> Unit) {
    val builder = AlertDialog.Builder(this)
            .setTitle(title)
            .setMessage(message)
            .setCancelable(false)
            .setPositiveButton(positiveButtonLable) { dialog, id ->
                dialog.cancel()
                actionOnPositveButton()
            }
    val alert = builder.create()
    alert?.show()
}

// Toash extensions
fun Context.showShotToast(message : String){
    Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
}

fun Context.showLongToast(message : String){
    Toast.makeText(this, message, Toast.LENGTH_LONG).show()
}

// Snackbar Extensions
fun View.showShotSnackbar(message : String){
    Snackbar.make(this, message, Snackbar.LENGTH_SHORT).show()
}

fun View.showLongSnackbar(message : String){
    Snackbar.make(this, message, Snackbar.LENGTH_LONG).show()
}

fun View.snackBarWithAction(message : String, actionlable : String,
                            block : () -> Unit){
    Snackbar.make(this, message, Snackbar.LENGTH_LONG)
            .setAction(actionlable) {
                block()
            }
}
```

编写这些扩展是一次性的工作。看看这些扩展的用法：

```Kotlin
// To show an alert dialog in activities, fragments and more
showAlertDialog(message){
  //TODO on user click on positive button on alert dialog
}

//To show toast in activities, fragments and more
showShotToast(message)
showLongToast(message)

//To show Snackbar applied on any active view
showShotSnackbar(message)
showLongSnackbar(message)
snackBarWithAction(message, lable){
  //TODO on user click on snackbar action lable
}
```

常见的场景应该尽可能容易实现、可读性好和自然。

我希望你学到了一些有用的东西。感谢你的阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
