> * 原文地址：[5 Kotlin Extensions To Make Your Android Code More Expressive](https://betterprogramming.pub/5-kotlin-extensions-to-make-your-android-code-more-expressive-4c9243cb9466)
> * 原文作者：[Siva Ganesh Kantamani](https://medium.com/@sgkantamani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-kotlin-extensions-to-make-your-android-code-more-expressive.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-kotlin-extensions-to-make-your-android-code-more-expressive.md)
> * 译者：
> * 校对者：

# 5 Kotlin Extensions To Make Your Android Code More Expressive

![](https://cdn-images-1.medium.com/max/12000/0*7wBRYeSryL8YT5u_)

You might have already gone through a bunch of articles on Kotlin extensions, but this article is not all about extensions. It’s about making your code expressive, so I’ve concentrated on explaining and including my top extensions that keep code as natural as possible.

The main goal is to learn how to make your code expressive in your own way by using the concept of extensions rather than copy-pasting the code snippets.

## Introduction

Kotlin is a modern and expressive language built with developers in mind. In my view, good Kotlin code is nothing but code that can express itself in a natural, readable way.

Switching from Java to Kotlin was a huge transformation for me in many ways, but I would say it’s for the best in every aspect. You can read all about it in [my previous article](https://medium.com/better-programming/my-journey-from-java-to-kotlin-3bfcbcc6b734).

One of the things I love most about Kotlin is the concept of extensions. As a mobile Java developer, I never thought about the ability to add custom functionality to any class — especially not to a class in a third-party library. But when I heard about the concept of extensions, it blew my mind. For an Android developer, this feature opens the gates to numerous code enhancements.

> “Kotlin provides the ability to extend a class with new functionality without having to inherit from the class or use design patterns such as Decorator. This is done via special declarations called extensions.” — [Kotlin’s documentation](https://kotlinlang.org/docs/extensions.html)

To learn more about Kotlin extensions, read the following article: [Advanced Android Programming With Kotlin](https://medium.com/better-programming/advanced-android-programming-with-kotlin-5e40b1be22bb)

I use Kotlin extensions to make the code expressive and keep the language as natural as possible.

Without further delay, let’s dive in.

## 1. Show, Hide, and Remove

One of the common tasks for a mobile developer is to hide and show views. If you use Java, you need to call the `setVisibility` function and pass `View.VISIBILE` or `View.GONE` based on the requirement. Have a look:

```
view.setVisibility(View.GONE)
```

There is nothing wrong with this code. It works. But using `set` and `get` functions makes it look more clunky than natural. Kotlin provides an out-of-the-box way to assign values without using `set` and `get` functions. Now it looks like this:

```
view.visibility = View.GONE
```

Even now, it doesn’t look natural because of the assignment operator, so I thought, “Why can’t I use extensions to make it as natural as possible?” That’s when I started using the following extensions:

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

Now we can use it as shown below:

```
view.show()
view.hide() 
view.remove()
```

Now it looks better — more natural. I would love to optimize it, so if you have any suggestions, please leave a comment.

## 2. Validations

Validating strings is crucial in any dev environment. Back in 2015, when I was starting my career, I saw a few apps that showed `null` in some text fields. This was because there was no proper validation.

Before Kotlin, I would maintain a utility class and include some static functions to validate strings. Have a look at a simple validation function in Java:

```Java

// Function in utility class
public static Boolean isStringNotNullOrEmpty(String data){
    return data != null && data.trim().length() > 0 
            && !data.equalsIgnoreCase("null");
}

// Usage at call site
if(Utility.isStringNotNullOrEmpty(data))
```

At their core, data types are nothing but classes. So we can use Kotlin extensions to add validation functionality. For instance, I’ve created the following Kotlin extension of data type `String` to check if it’s valid:

```Kotlin

//Extension function
fun String?.valid() : Boolean =
        this != null && !this.equals("null", true)
                && this.trim().isNotEmpty()

// Usage at call site
if(data.valid())
```

Well, `data.valid()` seems cleaner and more readable to me than Utility.isStringNotNullOrEmpty(data). Invoking extension functions on the data types seems more natural than triggering some utility function. Below are a couple of extensions to boost your motivation to write your own validation extensions:

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

## 3. Extract Bundle Parameters

In Android, we pass data between components via a bundle — a key-value pair. Usually, we have to check a few things before retrieving data from the bundle. First, we should check if the key we’re looking for is in the bundle. Then we need to check whether it has a valid value. Usually, we do that in the following way:

```Kotlin
fun extractData(extras : Bundle){
    if (extras.containsKey("name") && extras.getString("name").valid()){
        val name = extras.getString("name")
    }
}
```

This involves more manual code, and to be frank, it’s not pretty to look at. Imagine how tedious the code might look if you have five parameters. As I said, code should be as natural as possible and also involve minimal manual work.

Here, I’m using four extension functions: two for activities and two for fragments. Again, a pair for each component to get a non-null value or a nullable value. Have a look:

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

To learn about advanced features like inline functions and reified types, please go through [this series of articles](https://medium.com/better-programming/advanced-android-programming-with-kotlin-5e40b1be22bb).

Now let’s see how to use the extensions above:

```Kotlin
val firstName by getValue<String>("firstName") // String?
val lastName by getValueNonNull<String>("lastName") // String
```

This approach has three advantages:

1. Clean, readable, and minimal code.
2. Null-safe values.
3. Lazy execution.

## 4. Resource Extensions

In Android, we need to access project-level resources via a resource class. This involves some boilerplate code that we need to manually write each time we want to retrieve data from the resource file. Without any extensions, retrieving a color or drawable looks like this:

```Kotlin
val color = ContextCompat.getColor(ApplicationCalss.instance, R.color.dark_blue)
val drawable = ContextCompat.getDrawable(MavrikApplication.instance, R.drawable.launcher)
```

When trying to retrieve any resource, you need to access it via the resource ID from the generated R file. The data type of the ID is `Int`. So we can write extensions to the integer class for each resource type and use them at the call site to reduce the boilerplate code and make it readable:

```Kotlin
//Extensions
fun Int.asColor() = ContextCompat.getColor(ApplicationCalss.instance, this)
fun Int.asDrawable() = ContextCompat.getDrawable(MavrikApplication.instance, this)

//Usage at call site
val color = R.color.dark_blie.asColor()
val drawable = R.drawable.launcher.asDrawable()
```

## 5. Show Alert Dialog, Toast, or Snackbar

When it comes to frontend development, regardless of the platform, there will be times when you want to show an alert to the user. It might be a toast used for unimportant data or alert dialogs to take confirmations or show some error.

When you want to show a simple toast message, the statement you need to write can be quite lengthy. I’m not even going to get into alert dialogs. These are common tasks. They should be concise and easy to implement. That’s why I use the following extensions to make code as concise as possible at the call site:

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

Writing these extensions is a one-time job. Have a look at the usage of these extensions at the call site:

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

Common tasks should be as easy to implement, readable, and natural as possible.

That is all for now. I hope you learned something useful. Thanks for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
