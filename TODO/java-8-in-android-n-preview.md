>* 原文链接 : [Java 8 in Android N Preview](https://medium.com/@sergii/java-8-in-android-n-preview-76184e2ab7ad#.ywf5x3l8w)
* 原文作者 : [Sergii Zhuk](https://medium.com/@sergii)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Android team recently released Android N Preview with many new improvements including Java 8 support by the Jack compiler. In this blog post we’ll check what it actually means for Android developers and how to try new language features.

> _Disclaimer: this information is valid for 30th of March 2016, I’m sure that on the next releases Google team will add some more Java 8 features which are not observed here._

![](https://cdn-images-1.medium.com/max/800/1*0Vex_2H0J7MBBiu1EqMtaw.png)

<figcaption>Image by [Android Police<sup class="readableLinkFootnote"></sup>](http://www.androidpolice.com/2016/03/09/android-n-feature-spotlight-jack-compiler-gains-support-for-many-java-8-language-features-including-lambdas-streams-functional-interfaces-and-more/)</figcaption>

### See the bigger picture

In this blog post it won’t make sense to introduce the new features of Oracle Java 8 — a lot of information is already available in the Internet. My personal favorite is “[55 New Features in Java SE 8<sup class="readableLinkFootnote"></sup>](https://www.youtube.com/watch?v=rtAredKhyac)” by Simon Ritter.

On the other hand, the [official Java 8 announcement<sup class="readableLinkFootnote"></sup>](http://android-developers.blogspot.de/2016/03/first-preview-of-android-n-developer.html) for Android leaves some open questions for developers and sounds like the original Java 8 functionality could be not always available for us. More detailed [technical announcement<sup class="readableLinkFootnote"></sup>](http://developer.android.com/intl/ru/preview/j8-jack.html) confirmed that. We can classify availability of Java 8 Language features as the following:

Android Gingebread (API 9) and above:

*   [Lambda expressions](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)
*   [java.util.function](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html)

Android N and above:

*   [Default and static interface methods](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html)
*   [Repeatable annotations](https://docs.oracle.com/javase/tutorial/java/annotations/repeating.html)
*   [Streams](http://www.oracle.com/technetwork/articles/java/ma14-java-se-8-streams-2177646.html)
*   Reflection APIs

So the developer should be really selective with the relevance between Java 8 features and minSdkVersion used. Also we should note that the language backward compatibility is provided by Jack compiler. Conceptually, the Jack compiler [consolidates <sup class="readableLinkFootnote"></sup>](https://www.guardsquare.com/blog/the_upcoming_jack_and_jill_compilers_in_android)the functionality of javac, ProGuard, and dex in a single conversion step. [It means<sup class="readableLinkFootnote"></sup>](http://trickyandroid.com/the-dark-world-of-jack-and-jill/) that there is no intermediate Java bytecode available and tools like JaCoCo and Mockito won’t work, the same is valid for DexGuard (enterprise version of ProGuard). Let’s hope that it is still an early preview and these issues will be fixed in the future.

Lambda expressions and related function utility APIs — here is a thing every Android developer will like. This sort of feature will be extremely useful to increase code readability — it replaces anonymous inner classes when providing event listeners. Previously it wasn’t available without [extra tools<sup class="readableLinkFootnote"></sup>](http://zserge.com/blog/android-lambda.html) or Android Studio editor folding the code.

Default and static interface methods could help us to decrease amount of extra classes for utilities, but obviously it is not the most demanded feature ever. Some other added functionality I’d call rather specific and thus took out of scope for this post.

The most interesting thing for me — Java 8 Streams — is not available in the current preview. We can find that actually it has been [just merged<sup class="readableLinkFootnote"></sup>](https://android.googlesource.com/platform/libcore/+/916b0af2ccdd1bdfc0283b1096b291c40997d05f) to AOSP sources, so looking forward to see it in the next N Preview or Beta release. If you are really don’t want to wait exploring Streams — try to use [Lightweight-Stream-API<sup class="readableLinkFootnote"></sup>](https://github.com/aNNiMON/Lightweight-Stream-API) opensource backport for now.

### Example project

The [official manual<sup class="readableLinkFootnote"></sup>](http://developer.android.com/preview/setup-sdk.html) provides instructions and even a diagram how to configure your project to work with Android N Preview and Java 8\. Nothing to add here, just go with the flow.

![](http://ww4.sinaimg.cn/large/a490147fjw1f2w1lxrva9j20m803pt9h.jpg)

The next step is to setup you app module build.gradle file. Below you can see the example build.gradle file. From the N SDK announcement above it seems to be possible to use _minSdkVersion_ for Jelly Bean or KitKat. Buut… with Android N Preview _targetSdkVersion_ it [won’t work on devices with API lower than N<sup class="readableLinkFootnote"></sup>](http://stackoverflow.com/questions/36278517/java-8-in-android-n-preview). Moreover, if you set _minSdkVersion_ value to 23 and lower — Java 8 code won’t compile. Here are some hacks on [SO forums<sup class="readableLinkFootnote"></sup>](http://stackoverflow.com/questions/35929484/android-n-cannot-run-on-lower-api-though-minsdk-set-to-14) describing how to set minSdk to the intended value and make app work. I hope you won’t do that for a production code :)

I’ve decided to keep the example below clean and haven’t added any hacks for a lower version compatibility, feel free to do it on your own or just enjoy N test devices/emulators.

```
android {
    compileSdkVersion 'android-N'
    buildToolsVersion '24.0.0 rc1'

    defaultConfig {
        applicationId "org.sergiiz.thermometer"
        minSdkVersion 'N' // Can't use lower in N Preview
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

Please note that this configuration follows new [docs<sup class="readableLinkFootnote"></sup>](http://developer.android.com/preview/j8-jack.html) with updated Gradle DSL method _jackOptions_ to setup Jack compiler config, in the older versions we were using _useJack true_ to reach the same result.

So let’s implement some Java 8 elegant code into our good old Thermometer project.

Here is an interface, which contains the default method:

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

Class which implements this interface:

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

And a lambda function for click events:

```
buttonFahrenheit.setOnClickListener(view1 -> {
   fahrenheitThermometer.setCelsius(currentCelsius);
   String text = fahrenheitThermometer.getFormattedValue();
   makeText(MainActivity.this, text, Toast.LENGTH_SHORT).show();
});
```

The full source of example you can find at [GitHub repository<sup class="readableLinkFootnote"></sup>](https://github.com/sergiiz/AndroidNPreviewJ8).

### Conclusion

In this post we saw use-cases of Java 8 and the current state of its implementation in Android N Preview SDK. We saw limitations of the existing Jack compiler functionality that may be fixed before the final release. In the demo project we checked how to use new Java 8 features and for which target SDKs they can be applied.

