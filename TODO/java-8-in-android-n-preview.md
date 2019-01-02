>* 原文链接 : [Java 8 in Android N Preview](https://medium.com/@sergii/java-8-in-android-n-preview-76184e2ab7ad#.ywf5x3l8w)
* 原文作者 : [Sergii Zhuk](https://medium.com/@sergii)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [markzhai](https://github.com/markzhai)
* 校对者: [narcotics726](https://github.com/narcotics726), [MiJack](https://github.com/MiJack)

# 在 Android N 预览版中使用 Java 8 的新特性

Android团队最近发布了Android N Preview，带来了很多提升，包括由Jack编译器提供的Java 8支持。在这篇文章中，我们将来看看它究竟对Android开发者意味着什么，以及如何尝试新的语言特性。

> _免责声明: 本信息在2016年3月30日是有效的，我不确定在下个release版本中，Google团队会增加什么新的没有在此提到的Java 8特性。_

![](https://cdn-images-1.medium.com/max/800/1*0Vex_2H0J7MBBiu1EqMtaw.png)

<figcaption>图片 by [Android Police<sup class="readableLinkFootnote"></sup>](http://www.androidpolice.com/2016/03/09/android-n-feature-spotlight-jack-compiler-gains-support-for-many-java-8-language-features-including-lambdas-streams-functional-interfaces-and-more/)</figcaption>

### 概览

在这篇文章中，去介绍Oracle Java 8的新特性并没有太大意义 —— 很多信息已经在互联网上有了。我个人最喜欢的是Simon Ritter的“[Java SE 8的55个新特性<sup class="readableLinkFootnote"></sup>](https://www.youtube.com/watch?v=rtAredKhyac)”。

另一方面，Android [官方的Java 8公告<sup class="readableLinkFootnote"></sup>](http://android-developers.blogspot.de/2016/03/first-preview-of-android-n-developer.html) 留下了很多开放的问题给开发者们，感觉上并非所有的原生 Java 8 功能都是可用的。更详细的 [技术公告<sup class="readableLinkFootnote"></sup>](http://developer.android.com/intl/ru/preview/j8-jack.html) 确认了这一点。我们可以根据在 Android N 中的可用性，将这些语言特性分类如下：

Android Gingebread (API 9)及以上:

*   [Lambda 表达式](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)
*   [java.util.function](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html)

Android N及以上:

*   [默认和静态interface方法](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html)
*   [可重复的注解](https://docs.oracle.com/javase/tutorial/java/annotations/repeating.html)
*   [流(Streams)](http://www.oracle.com/technetwork/articles/java/ma14-java-se-8-streams-2177646.html)
*   反射APIs

所以对Java 8特性和使用的minSdkVersion之间的关联性，开发者必须去精心选择。我们也必须注意到语言向后兼容是由Jack编译器提供的。在概念上，Jack编译器将javac，ProGuard，以及dex的功能 [合并 <sup class="readableLinkFootnote"></sup>](https://www.guardsquare.com/blog/the_upcoming_jack_and_jill_compilers_in_android)到了一个转换步骤中。[这意味着<sup class="readableLinkFootnote"></sup>](http://trickyandroid.com/the-dark-world-of-jack-and-jill/)其中没有中间的Java字节码可用，且像是JaCoCo和Mockito的工具将无法工作，DexGuard也一样 (ProGuard的企业版本)。让我们祈祷这只是一个早期的preview版本，且这些问题将在未来被修复。

Lambda表达式以及相关的函数功能APIs —— 这是一个每个Android开发都会喜欢的东西。这类功能将会对增加代码可读性极为有用 —— 它替代了提供事件监听器的匿名内部类。而之前只能通过 [额外的工具<sup class="readableLinkFootnote"></sup>](http://zserge.com/blog/android-lambda.html) 来实现，或者由Android Studio编辑器去折叠代码。

默认及静态interface方法可以帮助我们减少额外的工具类的数量，但显然不是最需要的特性。还有一些其他的新增功能，我希望去说的更详细一些，因此不在本文的范围内。

对我来说最有趣的事 —— Java 8 流(Streams) —— 在当前的预览版中不可用。我们可以发现事实上它 [刚被merge<sup class="readableLinkFootnote"></sup>](https://android.googlesource.com/platform/libcore/+/916b0af2ccdd1bdfc0283b1096b291c40997d05f) 到AOSP源码，所以期望可以在下个N Preview 或者 Beta release中见到它。如果你实在等不及去浏览 —— 可以试试使用 [Lightweight-Stream-API<sup class="readableLinkFootnote"></sup>](https://github.com/aNNiMON/Lightweight-Stream-API)，目前的一个开源向后兼容。

### 示例项目

[官方手册<sup class="readableLinkFootnote"></sup>](http://developer.android.com/preview/setup-sdk.html)提供了指示，甚至还有图展示了如何去配置你的项目使用 Android N Preview 和 Java 8。在这儿没什么可以再说的，就跟着指示走吧。

![](http://ww4.sinaimg.cn/large/a490147fjw1f2w1lxrva9j20m803pt9h.jpg)

下一步是去配置你的app模块的 build.gradle 文件。你可以在下面看到实例的 build.gradle 文件。从N SDK上的公告来看，似乎可以设置 _minSdkVersion_ 为 Jelly Bean 或者 KitKat。 但… 在将 _targetSdkVersion_ 设为Android N Preview后，[将无法工作在API低于N的设备上<sup class="readableLinkFootnote"></sup>](http://stackoverflow.com/questions/36278517/java-8-in-android-n-preview)。另外，如果你把 _minSdkVersion_ 设置为23或者更低 —— Java 8代码将无法编译。这里是一些在 [SO forums<sup class="readableLinkFootnote"></sup>](http://stackoverflow.com/questions/35929484/android-n-cannot-run-on-lower-api-though-minsdk-set-to-14)的hack，描述了怎么设置minSdk为想要的值并使得app可以工作。我希望你不会在生产代码中使用这种方法 :)

我决定保持实例代码干净，所以没有添加任何hack手段来做低版本兼容，请读者自由去尝试或者使用N的测试设备/模拟器。

```
android {
    compileSdkVersion 'android-N'
    buildToolsVersion '24.0.0 rc1'

    defaultConfig {
        applicationId "org.sergiiz.thermometer"
        minSdkVersion 'N' // 在 N Preview 中不能使用低于N的版本
        targetSdkVersion 'N'
        versionCode 1
        versionName "1.0"
        jackOptions{
            enabled true
        }
    }
    compileOptions {
        targetCompatibility 1.8
        sourceCompatibility 1.8
    }
    //...
}
```

请注意这个设置是跟着新的[文档<sup class="readableLinkFootnote"></sup>](http://developer.android.com/preview/j8-jack.html)来的，使用了新的 Gradle DSL 方法 _jackOptions_ 来配置Jack编译器设置，在更老的版本中，我们使用 _useJack true_ 来达到同样的结果。

所以来试着实现一些Java 8的优雅代码到我们陈旧的Thermometer项目。

这是一个接口，包含了默认方法：

```
public interface Thermometer {

   void setCelsius(final float celsiusValue);

   float getValue();

   String getSign();

   default String getFormattedValue(){
      return String.format(Locale.getDefault(),
            "The temperature is %.2f %s", getValue(), getSign());
   }
}
```

实现了这个接口的类：

```
public class FahrenheitThermometer implements Thermometer {

   private float fahrenheitDeg;

   public FahrenheitThermometer(float celsius) {
      setCelsius(celsius);
   }

   @Override
   public void setCelsius(float celsius) {
      fahrenheitDeg = celsius * 9 / 5 + 32f;
   }

   @Override
   public float getValue() {
      return fahrenheitDeg;
   }

   @Override
   public String getSign() {
      return Constants.DEGREE + "F";
   }
}
```

增加一个点击事件的lambda函数：

```
buttonFahrenheit.setOnClickListener(view1 -> {
   fahrenheitThermometer.setCelsius(currentCelsius);
   String text = fahrenheitThermometer.getFormattedValue();
   makeText(MainActivity.this, text, Toast.LENGTH_SHORT).show();
});
```

例子的完整源码可见 [GitHub repository<sup class="readableLinkFootnote"></sup>](https://github.com/sergiiz/AndroidNPreviewJ8)。

### 总结

在这篇文章中，我们了解了Java 8的用例，以及目前其在Android N Preview SDK的实现情况。我们也看到了当前Jack编译器的限制，及其在最后发布前可能被修复的功能。在demo项目中我们检验了如何去使用新的Java 8特性，以及它们可以被应用的target SDK版本。
