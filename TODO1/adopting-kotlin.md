> * 原文地址：[Adopting Kotlin: Incorporating Kotlin in your large app](https://medium.com/androiddevelopers/adopting-kotlin-50c0df79b879)
> * 原文作者：[Tiem Song](https://medium.com/@tiembo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/adopting-kotlin.md](https://github.com/xitu/gold-miner/blob/master/TODO1/adopting-kotlin.md)
> * 译者：
> * 校对者：

# Adopting Kotlin: Incorporating Kotlin in your large app

![](https://cdn-images-1.medium.com/max/2000/1*fherNTB7HBzPv5SZAJZ-Lg.png)

Illustration by [Virginia Poltrack](https://twitter.com/VPoltrack)

(This article is also available in Chinese at [WeChat](https://mp.weixin.qq.com/s/UJipNKgGPzZ1iPJBAaLJXw) / 中文版请参考 [WeChat](https://mp.weixin.qq.com/s/UJipNKgGPzZ1iPJBAaLJXw))

One of the recurring questions developers ask me at conferences is “What’s the best way to add Kotlin to my existing Android app?” If you work in a team with more than a handful of people, adopting a new language can become complex. Over time, my answer has become longer and I’ve fine-tuned it based on my own experiences adding Kotlin to existing projects, and speaking with others — both at Google and the external developer community — about their journeys.

Here’s a guide to help you successfully introduce Kotlin to existing projects on larger teams. Many teams within Google, including the Android Developer Relations team, have used these techniques successfully. Two notable examples are the [2018 Google I/O app](https://github.com/google/iosched), which was rewritten completely in Kotlin, and [Plaid](https://github.com/nickbutcher/plaid), which has a mix of Java and Kotlin.

### How to add Kotlin to an app

#### Designate a Kotlin champion

You should start by designating a person in your team to become the Kotlin expert and mentor. Quite often this person will be obvious: the one who is the most interested in using Kotlin. It could very well be you since you are reading this. This individual should focus on learning as much as possible about Kotlin and researching ideas on how to best incorporate Kotlin into the existing app. They should proactively share their Kotlin knowledge, and become the “go to” person for any questions from the team. This person should also participate in Java and Kotlin code reviews to ensure that changes follow Kotlin conventions and facilitate language interoperability (such as nullability annotations).

#### Learn the basics

While the Kotlin champion is spending time deep-diving into Kotlin, everyone else on the team should establish a baseline knowledge about Kotlin. If your team is just getting started with Kotlin there are a lot of resources you can use to learn the language and how it interacts with Android. I highly recommend starting with the [Kotlin Koans](https://kotlinlang.org/docs/tutorials/koans.html), a series of small exercises that provides a tour of Kotlin’s features. It was a fun way for me to learn Kotlin.

The official site for Kotlin ([kotlinlang.org](https://kotlinlang.org)) offers [reference documents](http://kotlinlang.org/docs/reference/) for working with the [Kotlin standard library](http://kotlinlang.org/api/latest/jvm/stdlib/index.html) and step-by-step [tutorials](http://kotlinlang.org/docs/tutorials/) for accomplishing different tasks in Kotlin. The Android Developers site also has [several resources](https://developer.android.com/kotlin/index.html) on working with Kotlin in Android.

#### Form a study group

After the team is comfortable writing basic Kotlin, it’s a good time to form a study group. Kotlin is evolving quickly with many new features in the pipeline, such as [Coroutines](https://kotlinlang.org/docs/reference/coroutines.html) and [Multiplatform](https://kotlinlang.org/docs/reference/multiplatform.html). Regular group discussions help you understand upcoming language features and reinforces Kotlin best practices at your company.

#### Write tests in Kotlin

Many teams have found that writing tests in Kotlin is a great way to start using it in their projects, as it doesn’t impact your production code and isn’t bundled with your app package.

Your team can either write new tests or convert existing tests to Kotlin. Tests are useful to check for code regressions, and they add a level of confidence when refactoring your code. These tests will be especially useful when converting existing Java code into Kotlin.

#### Write new code in Kotlin

Before converting existing Java code to Kotlin, start by adding small pieces of Kotlin code to your app’s codebase. Begin with a small class or top-level helper function, making sure to add the relevant [annotations](https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html) to the Kotlin code to ensure proper interoperability from the Java code.

#### Analyze impact on APK size and build performance

Adding Kotlin to your app may increase both the APK size and build times. We recommend that you use [Proguard](https://developer.android.com/studio/build/shrink-code) to ensure that your release APKs are as small as possible and to reduce any increase in the number of methods. After running Proguard, the Kotlin impact on your APK size should be quite small, especially when you are just starting off.

For Kotlin-only projects and mixed-language projects (that are written in Java and Kotlin) there is a slight increase in compile and build times. However, many developers feel that the increased productivity of writing in Kotlin is a worthwhile trade-off. The Kotlin and Android teams are aware of longer build times and are continually striving to improve this important part of the development process. You should measure and monitor the build performance impact for your projects.

#### Update existing code to Kotlin

Once your team is comfortable using Kotlin, you can start to convert your existing code to Kotlin.

One extreme option is to start over and rewrite your app entirely in Kotlin. We took this approach with the [2018 Google I/O Android app](https://android-developers.googleblog.com/2018/08/google-releases-source-for-google-io.html), but this is probably not an option for most teams, as they need to ship software while adopting new technologies. Fortunately, Kotlin and the Java programming language are fully interoperable, so you can migrate your project one class at a time.

A more realistic approach is to use the [code converter](https://developer.android.com/studio/projects/add-kotlin#convert-to-kotlin-code) in Android Studio, which converts the code in a Java file to Kotlin. In addition, the IDE offers an option to convert to Kotlin any Java code pasted from the clipboard into a Kotlin file. The converter doesn’t always produce the most idiomatic Kotlin. You’ll need to review each file, but it’s a great way to save time and see how Kotlin looks like in your codebase.

Note that while Java and Kotlin are 100% interoperable they are not source compatible. It is not possible to write a single file in both Java and Kotlin. Consult the [Kotlin](https://kotlinlang.org/docs/reference/java-interop.html) and [Android](https://android.github.io/kotlin-guides/interop.html) guides for more tips on writing interoperable code between Java and Kotlin.

### Convince management to adopt Kotlin

After gaining some experience with Kotlin, you may know in your heart of hearts that Kotlin is right for your team. But how do you convince your leadership or stakeholder teams about adopting Kotlin, when they don’t share your love for data classes, smart casts, and extension functions? How best to address this varies based on your specific situation. Below, we suggest some potential speaking points with data you can use to back up your claims.

*   **The team is more productive with Kotlin.** You can show data comparing the average lines of code per file between Kotlin and Java. It’s pretty common to see lines of code reduction of 25% or more. Less code to write also means less code to test and maintain, allowing your team to develop new features faster. In addition, you can track how fast your team spent developing a feature in Kotlin compared to a similar feature in Java.
*   **Kotlin increases app quality.** Kotlin’s null-safety feature is well-known, but there are many [other safety features](https://proandroiddev.com/kotlin-avoids-entire-categories-of-java-defects-89f160ba4671) to help you avoid entire categories of code defects. One idea from Pinterest is to track your defect rate in each module of your app as you migrate them from Java to Kotlin. You should see the defect rate declining. You can watch Pinterest talk about this in this [Android Developer Story video](https://www.youtube.com/watch?v=c6mhYGCKeaI&t=1m14s). There is also a [recent academic research](https://www.theregister.co.uk/2018/08/02/kotlin_code_quality/) to back up this claim.
*   **Kotlin makes your team happier.** Happiness is hard to quantify, but you can find a way to demonstrate your team’s excitement about Kotlin to your management. Kotlin is the #2 most-loved programming language based on the [2018 StackOverflow survey](https://insights.stackoverflow.com/survey/2018#most-loved-dreaded-and-wanted).
*   **The industry is moving towards Kotlin.** 26% of the top 1000 Android apps on Play are already using Kotlin. This includes heavy hitters like Twitter, Pinterest, WeChat, American Express, and many more. Kotlin is also the #2 fastest growing mobile programming language according to Redmonk. Dice has also publicized that the number of Kotlin jobs have [experienced meteoric rise](https://insights.dice.com/2018/09/24/kotlin-jobs-meteoric-rise-android/).

### Going beyond

After you’ve had some hands-on experience adding Kotlin to your app, here are some additional tips to help incorporate Kotlin into your everyday development.

#### Define project-specific style conventions

The [Kotlin](https://kotlinlang.org/docs/reference/coding-conventions.html) and [Android Kotlin](https://android.github.io/kotlin-guides/) style guides establish great baselines for formatting Kotlin code. Beyond those, it’s a good idea to establish conventions and idioms that work best for your team.

One strategy for implementing unified Kotlin style is to customize Android Studio’s [code style settings](https://www.jetbrains.com/help/idea/copying-code-style-settings.html). Another strategy is to use a linter. In the [Sunflower](https://github.com/googlesamples/android-sunflower) and [Plaid](https://github.com/nickbutcher/plaid) projects, we used [ktlint](https://ktlint.github.io/) to enforce code styles. Ktlint provides great style defaults that follow standard Kotlin style guides that can also be customized to your team’s specific needs.

#### Use only as much as needed

It’s easy to go overboard with Kotlin syntactic sugar, wrapping statements in `apply`, `let`, `use`, and other great language features. In general, it’s better to favor readability over minimizing lines of code. For example, in Plaid we determined that an `apply` block should have at least two lines. Explore what works best for your team and add that to your style guide.

#### Explore sample projects and case studies

The resources section below lists sample projects that Googlers have migrated to Kotlin, along with case studies from companies that have added Kotlin to their projects.

### Frequently Asked Questions

As with any new technology, there are unknowns. Here are some questions we’ve heard from developers adopting Kotlin, along with suggestions to address them.

#### How do I convince fellow engineers to use a new language?

At Google I/O, I discussed various approach for engineers to adopt Kotlin with [Andrey Breslav](https://twitter.com/abreslav), the lead language designer of Kotlin. He and I agreed that the best approach is to try some Kotlin implementation with your team and then evaluate to see if it works for your situation. At the end of the day, if the minuses outweigh the pluses, you can pass on Kotlin — and Andrey says he’s OK with that!

#### Isn’t it hard to learn Kotlin?

Most developers pick up Kotlin fairly quickly. Experienced Java developers can use the same tools to develop in both Java and Kotlin. Ruby and Python developers will find similar language features in Kotlin, such as method chaining.

#### Will Google continue to support Kotlin for Android development?

**Yes!** Google is committed in its support for Kotlin.

### In conclusion

I hope this guide provides inspiration for you and your teams to add Kotlin to your apps. While the steps may be daunting, almost everyone I’ve spoken with found a renewed joy in software development after adopting Kotlin

Note that while this article is mostly written for Android apps, its concepts are applicable to any Java-based project, from Android apps to server-side programming.

Thanks for reading, and good luck in your journey adding Kotlin to your app!

### Continue exploring

The following is a collection of resources to aid your adoption of Kotlin:

**The official language site for Kotlin is [kotlinlang.org](https://kotlinlang.org):**

*   Write Kotlin code by following the [tutorials](https://kotlinlang.org/docs/tutorials/) or [Kotlin Koans](https://kotlinlang.org/docs/tutorials/koans.html) (you can even [try it online](https://try.kotlinlang.org/) with your browser)
*   Browse [reference documents](https://kotlinlang.org/docs/reference/) for working with the Kotlin [standard library](https://kotlinlang.org/api/latest/jvm/stdlib/index.html)
*   Read up on new features such as [Coroutines](https://kotlinlang.org/docs/reference/coroutines.html) and [Multiplatform](https://kotlinlang.org/docs/reference/multiplatform.html)

**[Developing Android apps with Kotlin](https://developer.android.com/kotlin) from [developer.android.com](https://developer.android.com):**

**Style and interoperability guides:**

*   General Kotlin [coding conventions](https://kotlinlang.org/docs/reference/coding-conventions.html)
*   Android Kotlin [style guide](https://android.github.io/kotlin-guides/index.html)
*   Interoperability guides for calling [Java code from Kotlin](https://kotlinlang.org/docs/reference/java-interop.html), [calling Kotlin from java](https://kotlinlang.org/docs/reference/java-to-kotlin-interop.html), and general [Android interop guides](https://android.github.io/kotlin-guides/interop.html)
*   Defining Android Studio’s [code style settings](https://www.jetbrains.com/help/idea/copying-code-style-settings.html)
*   [KtLint](https://ktlint.github.io/) — a Kotlin linter with built-in formatter

**Code samples:**

*   [2018 Google I/O Android app](https://github.com/google/iosched)
*   [Plaid](https://github.com/nickbutcher/plaid)
*   [Sunflower](https://github.com/googlesamples/android-sunflower)
*   [Tivi](https://github.com/chrisbanes/tivi)
*   [Topeka](https://github.com/googlesamples/android-topeka)
*   Additional [code samples](https://developer.android.com/samples/index.html?language=kotlin) on [developer.android.com](http://developer.android.com/)

**Case studies:**

*   Basecamp — “[How we made Basecamp 3’s Android app 100% Kotlin](https://m.signalvnoise.com/how-we-made-basecamp-3s-android-app-100-kotlin-35e4e1c0ef12)”
*   Camera360 — “[Android Developer Story: Camera360 achieves global success with Kotlin and new technologies](https://youtu.be/r6itIxyUhc8)” (video in Chinese with English subtitles)
*   Hootsuite — “[Down of the Age of Kotlin at Hootsuite](http://code.hootsuite.com/dawn-of-the-age-of-kotlin-at-hootsuite/)”
*   Keepsafe — “[Lessons from converting an app to 100% Kotlin](https://medium.com/keepsafe-engineering/lessons-from-converting-an-app-to-100-kotlin-68984a05dcb6)”
*   Pinterest — “[Kotlin for grumpy Java developers](https://medium.com/@Pinterest_Engineering/kotlin-for-grumpy-java-developers-8e90875cb6ab)”

— Articles

*   [31 days of Kotlin](https://twitter.com/i/moments/980488782406303744) on Twitter — a daily Kotlin tip during March 2018 from [@AndroidDev](https://twitter.com/androiddev). Each of the 31 tweets explores a specific feature of Kotlin and can serve as a guided tour for improving Kotlin usage over the course of a month. Blog post recaps are also available: [Week 1](https://medium.com/google-developers/31daysofkotlin-week-1-recap-fbd5a622ef86), [Week 2](https://medium.com/google-developers/31daysofkotlin-week-2-recap-9eedcd18ef8), [Week 3](https://medium.com/google-developers/31daysofkotlin-week-3-recap-20b20ca9e205), [Week 4](https://medium.com/google-developers/31daysofkotlin-week-4-recap-d820089f8090)
*   [Lessons learned while converting to Kotlin with Android Studio](https://medium.com/google-developers/lessons-learned-while-converting-to-kotlin-with-android-studio-f0a3cb41669) — article by [Ben Baxter](https://twitter.com/benjamintravels), Partner Developer Advocate @ Google
*   [Migrating and Android project to Kotlin](https://medium.com/google-developers/migrating-an-android-project-to-kotlin-f93ecaa329b7) — article by [Ben Weiss](https://twitter.com/keyboardsurfer), Android Developer Relations @ Google

_Thanks to_ [_James Lau_](https://twitter.com/jmslau) _and_ [_Sean McQuillan_](https://twitter.com/objcode)

*   [And](https://medium.com/tag/android?source=post)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
