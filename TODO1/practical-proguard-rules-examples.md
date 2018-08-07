> * 原文地址：[Practical ProGuard rules examples](https://medium.com/google-developers/practical-proguard-rules-examples-5640a3907dc9)
> * 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/practical-proguard-rules-examples.md](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-proguard-rules-examples.md)
> * 译者：
> * 校对者：

# Practical ProGuard rules examples

In my previous article I explained [why everyone should use ProGuard for their Android apps](https://medium.com/google-developers/troubleshooting-proguard-issues-on-android-bce9de4f8a74), how to enable it and what kind of errors you might encounter when doing so. There was a lot of theory involved, as I think it’s important to understand the underlying principles in order to be prepared to deal with any potential problems.

I also talked in a separate article about the very specific problem of [configuring ProGuard for an Instant App](https://medium.com/google-developers/enabling-proguard-in-an-android-instant-app-fbd4fc014518) build.

In this part, I’d like to talk about the practical examples of ProGuard rules on a medium sized sample app: [Plaid](https://github.com/nickbutcher/plaid) by [Nick Butcher](https://medium.com/@crafty).

### Lessons learned from Plaid

Plaid actually turned out to be a great subject for researching ProGuard problems, as it contains a mix of 3rd party libraries that use things like annotation processing and code generation, reflection, java resource loading and native code (JNI). I extracted and jotted down some practical advice that should apply to other apps in general:

### Data classes

```
public class User {  
  String name;  
  int age;  
  ...  
}
```

Probably every app has some kind of data class (also known as DMOs, models, etc. depending on context and where they sit in your app’s architecture). The thing about data objects is that usually at some point they will be loaded or saved (serialized) into some other medium, such as network (an HTTP request), a database (through an ORM), a JSON file on disk or in a Firebase data store.

Many of the tools that simplify serializing and deserializing these fields rely on reflection. GSON, Retrofit, Firebase — they all inspect field names in data classes and turn them into another representation (for example: `{“name”: “Sue”, “age”: 28}`), either for transport or storage. The same thing happens when they read data into a Java object — they see a key-value pair `“name”:”John”` and try to apply it to a Java object by looking up a `String name` field.

**Conclusion**: We cannot let ProGuard rename or remove any fields on these data classes, as they have to match the serialized format. It’s a safe bet to add a `@Keep` annotation on the whole class or a wildcard rule on all your models:

```
-keep class io.plaidapp.data.api.dribbble.model.** { *; }
```

> **_Warning_**_: It’s possible to make a mistake when testing if your app is susceptible to this issue. For example, if you serialize an object to JSON and save it to disk in version N of your app without the proper keep rules, the saved data might look like this:_ `_{“a”: “Sue”, “b”: 28}_`_. Because ProGuard renamed your fields to_ `_a_` _and_ `_b_`_, everything will seem to work, data will be saved and loaded correctly._

> _However, when you build your app again and release version_ N+1 _of your app, ProGuard might decide to rename your fields to something different, such as_ `_c_` _and_ `_d_`_. As a result, data saved previously will fail to load._

> _You_ **_must_** _ensure you have the proper keep rules in the first place._

### Java code called from native side (JNI)

Android’s [default ProGuard files](https://developer.android.com/studio/build/shrink-code.html#shrink-code) (you should always include them, they have some really useful rules) already contain a rule for methods that are _implemented_ on the native side (`-keepclasseswithmembernames class * { native <methods>; }`). Unfortunately there is no catch-all way to keep code invoked in the opposite direction: from JNI into Java.

With JNI it’s entirely possible to construct a JVM object or find and call a method on a JVM handle from C/C++ code and in fact, [one of the libraries used in Plaid does that](https://github.com/Uncodin/bypass/blob/master/platform/android/library/jni/bypass.cpp#L61).

**Conclusion**: Because ProGuard can only inspect Java classes, it will not know about any usages that happen in native code. We must explicitly retain such usages of classes and members via a `@Keep` annotation or `-keep` rule.

```
-keep, includedescriptorclasses   
            class in.uncod.android.bypass.Document { *; }  
-keep, includedescriptorclasses   
            class in.uncod.android.bypass.Element { *; }
```

### Opening resources from JAR/APK

Android has its own resources and assets system that normally shouldn’t be a problem for ProGuard. However, in plain Java there is another [mechanism for loading resources straight from a JAR file](https://docs.oracle.com/javase/8/docs/technotes/guides/lang/resources.html) and some third-party libraries might be using it even when compiled in Android apps (in that case they will try to load from the APK).

The problem is that usually these classes will look for resources under their own package name (which translates to a file path in the JAR or APK). ProGuard can rename package names when obfuscating, so after compilation it might happen that the class and its resource file are no longer in the same package in the final APK.

To identify loading resources in this way, you can look for calls to `Class.getResourceAsStream / getResource` and `ClassLoader.getResourceAsStream / getResource` in your code and in any third party libraries you depend on.

**Conclusion**: We should keep the name of any class that loads resources from the APK using this mechanism.

In Plaid, there are actually two — one in the _OkHttp_ library and one in _Jsoup_:

```
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase  
-keepnames class org.jsoup.nodes.Entities
```

### How to come up with rules for third party libraries

In an ideal world, every dependency you use would supply their required ProGuard rules in the AAR. Sometimes they forget to do this or only publish JARs, which don’t have a standardized way to supply ProGuard rules.

In that case, before you start debugging your app and coming up with rules, remember to check the documentation. Some library authors supply recommended ProGuard rules (such as Retrofit used in Plaid) which can save you a lot of time and frustration. Unfortunately, many libraries don’t (such as is the case with Jsoup and Bypass mentioned in this article). Also be aware that in some cases the config supplied with the library will only work with optimizations disabled, so if you are turning them on you might be in uncharted territory.

So how to come up with rules when the library doesn’t supply them?  
I can only give you some pointers:

1.  Read the build output and logcat!
2.  Build warnings will tell you which `-dontwarn` rules to add
3.  `ClassNotFoundException`, `MethodNotFoundException` and `FieldNotFoundException` will tell you which `-keep` rules to add

> You should be glad when your app crashes with ProGuard enabled — you’ll have somewhere to start your investigation :)

> The worst class of problems to debug are when you app works, but for example doesn’t show a screen or doesn’t load data from the network.

> That’s where you need to consider some of the scenarios I described in this article and get your hands dirty, even diving into the third party code and understanding why it might fail, such as when it uses reflection, introspection or JNI.

### Debugging and stack traces

ProGuard will by default remove many code attributes and hidden metadata that are not required for program execution . Some of those are actually useful to the developer — for example, you might want to retain source file names and line numbers for stack traces to make debugging easier:

```
-keepattributes SourceFile, LineNumberTable
```

> You should also remember to [save the ProGuard mappings files produced when you build a release version and upload them to Play](https://developer.android.com/studio/build/shrink-code.html#decode-stack-trace) to get de-obfuscated stack traces from any crashes experienced by your users.

If you are going to attach a debugger to step through method code in a ProGuarded build of your app, you should also keep the following attributes to retain some debug information about local variables (you only need this line in your `debug` build type):

```
-keepattributes LocalVariableTable, LocalVariableTypeTable
```

### Minified debug build type

The default build types are configured such that _debug_ doesn’t run ProGuard. That makes sense, because we want to iterate and compile fast when developing, but still want the release build to use ProGuard to be as small and optimized as possible.

But in order to fully test and debug any ProGuard problems, it’s good to set up a separate, minified debug build like this:

```
buildTypes {
  debugMini {
    initWith debug
    minifyEnabled true
    shrinkResources true
    proguardFiles getDefaultProguardFile('proguard-android.txt'), 
                  'proguard-rules.pro'
    matchingFallbacks = ['debug']
  }
}
```

With this build type, you’ll be able to [connect the debugger](https://developer.android.com/studio/debug/index.html), [run UI tests](https://developer.android.com/training/testing/ui-testing/espresso-testing.html) (also on a CI server) or [monkey test](https://developer.android.com/studio/test/monkey.html) your app for possible problems on a build that’s as close to your release build as possible.

**Conclusion**: When you use ProGuard you should always QA your release builds thoroughly, either by having end-to-end tests or manually going through all screens in your app to see if anything is missing or crashing.

### Runtime annotations, type introspection

ProGuard will by default remove all annotations and even some surplus type information from your code. For some libraries that’s not a problem — those that process annotations and generate code at compile time (such as _Dagger 2_ or _Glide_ and many more) might not need these annotations later on when the program runs.

There is another class of tools that actually inspect annotations or look at type information of parameters and exceptions at runtime. Retrofit for example does this by intercepting your method calls by using a `Proxy` object, then looking at annotations and type information to decide what to put or read from the HTTP request.

**Conclusion**: Sometimes it’s required to retain type information and annotations that are read at runtime, as opposed to compile time. You can check out the [attributes list in the ProGuard manual](https://www.guardsquare.com/en/proguard/manual/attributes).

```
-keepattributes *Annotation*, Signature, Exception
```

> If you’re using the default Android ProGuard configuration file (`_getDefaultProguardFile('proguard-android.txt')_`), the first two options — Annotations and Signature — are specified for you. If you’re not using the default you have to make sure to add them yourself (it also doesn’t hurt to just duplicate them if you know they’re a requirement for your app).

### Moving everything to the default package

The `[-repackageclasses](https://www.guardsquare.com/en/proguard/manual/usage#repackageclasses)` option is not added by default in the ProGuard config. If you are already obfuscating your code and have fixed any problems with proper keep rules, you can add this option to further reduce DEX size. It works by moving all classes to the default (root) package, essentially freeing up the space taken up by strings like “_com.example.myapp.somepackage_”.

```
-repackageclasses
```

### ProGuard optimizations

As I mentioned before, ProGuard can do 3 things for you:

1.  it gets rid of unused code,
2.  renames identifiers to make the code smaller,
3.  performs whole program optimizations.

The way I see it, everyone should try and configure their build to get 1. and 2. working.

To unlock 3. (additional optimizations), you have to use a different default ProGuard configuration file. Change the `proguard-android.txt` parameter to `proguard-android-optimize.txt` in your `build.gradle`:

```
release {
  minifyEnabled true
  proguardFiles 
      getDefaultProguardFile('proguard-android-optimize.txt'),
      'proguard-rules.pro'
}
```

This will make your release build slower, but will potentially make your app run faster and reduce code size even further, thanks to optimizations such as method inlining, class merging and more aggressive code removal. Be prepared however, that it might introduce new and difficult to diagnose bugs, so use it with caution and if anything isn’t working, be sure to disable certain optimizations or disable the use of the optimizing config altogether.

In the case of Plaid, ProGuard optimizations interfered with how Retrofit uses Proxy objects without concrete implementations, and stripped away some method parameters that were actually required. I had to add this line to my config:

```
-optimizations !method/removal/parameter
```

You can find a [list of possible optimizations and how to disable them in the ProGuard manual](https://www.guardsquare.com/en/proguard/manual/optimizations).

### When to use `@Keep` and `-keep`

`@Keep` support is actually implemented as a bunch of `-keep` rules in the default Android ProGuard rules file, so they’re essentially equivalent. Specifying `-keep` rules is more flexible as it offers wildcards, you can also use different variants which do slightly different things (`-keepnames`, `-keepclasseswithmembers` [and more](https://www.guardsquare.com/en/proguard/manual/usage#keepoverview)).

Whenever a simple “keep this class” or “keep this method” rule is needed though, I actually prefer the simplicity of adding a`@Keep` annotation on the class or member, as it stays close to the code, almost like documentation.

If some other developer coming after me wants to refactor the code, they will know immediately that a class/member marked with `@Keep` requires special handling, without having to remember to consult the ProGuard configuration and risking breaking something. Also most code refactorings in the IDE should retain the `@Keep` annotation with the class automatically.

### Plaid stats

Here are some stats from Plaid, which show how much code I managed to remove using ProGuard. On a more complex app with more dependencies and a larger DEX the savings can be even more substantial.

![](https://cdn-images-1.medium.com/max/1600/1*SMf2Q7j5sL_iu3bcsiLBYw.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
