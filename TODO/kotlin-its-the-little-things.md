> * 原文地址：[Kotlin: It’s the little things](https://m.signalvnoise.com/kotlin-its-the-little-things-8c0f501bc6ea)
> * 原文作者：[Dan Kim](https://m.signalvnoise.com/@lateplate)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

---

# Kotlin: It’s the little things

Kotlin has a bunch of amazing features, and certain ones tend to grab the headlines — things like [extension functions](https://kotlinlang.org/docs/reference/extensions.html#extension-functions), [higher order functions](https://kotlinlang.org/docs/reference/lambdas.html), and [null safety](https://kotlinlang.org/docs/reference/null-safety.html) among them. And rightfully so — those are all incredibly powerful, fundamental features of the language upon which everything else builds on.

![](https://cdn-images-1.medium.com/max/800/1*O9IHQ8ivLkRCDLBtGZvaNg.png)

And while I love those features, there are a handful of small things you don’t hear much about that I really appreciate on a day-to-day basis.

These are simple, small niceties — the little things you do hundreds of times a day but nothing you’d consider “advanced”. They’re common sense language features that, when compared to Java, end up saving you a bunch of cognitive overhead, keystrokes, and time.

Take this simple, albeit highly contrived,example:

```
// Java
1 | View view = getLayoutInflater().inflate(layoutResource, group);
2 | view.setVisibility(View.GONE)
3 | System.out.println(“View " + view + " has visibility " + view.getVisibility() + ".");

// Kotlin
1 | val view = layoutInflater.inflate(layoutResource, group)
2 | view.visibility = View.GONE
3 | println(“View $view has visibility ${view.visibility}.")
```

At first glance the Kotlin version may look similar, as the differences are subtle. But there’s some great stuff to unpack that’ll make your life much better in the long run.

Given that example, let’s take a look at **five things from Java that you’ll never need to do in Kotlin.**

*(Note: For clarity in the code snippets, Java is always shown first and Kotlin second. Contextual code is truncated and the diffs are bolded.)*

#### 1. Declare variable types

```
View view
vs.
val view
```

Instead of explicitly declaring a variable type (in this case a `View`) Kotlin simply infers it from whatever is assigned to it. You just write `val` or `var`, assign it, and get on with your day. One less thing to think about.

#### 2. Concatenate Strings into an unreadable mess

```
“View " + view + " has visibility " + view.getVisibility() + "."
vs.
“View $view has visibility ${view.visibility}."
```

Kotlin provides [String interpolation](https://kotlinlang.org/docs/reference/idioms.html#string-interpolation). It’s such a stupid simple feature to have that makes working with Strings much easier and more readable. It’s particularly useful for logging.

#### 3. Call getters/setters

```
getLayoutInflater().inflate();
view.setVisibility(View.GONE);
view.getVisibility();
vs.
layoutInflater.inflate()
view.visibility = View.GONE
view.visibility
```

Kotlin provides accessors for existing Java getters and setters so that they can be used just like properties. The resulting conciseness (fewer parenthesis and `get` / `set` prefixes) improves readability considerably.

*(Occasionally the Kotlin compiler can’t reconcile the getters/setters for a class and this won’t work, but that’s relatively rare.)*

#### 4. Call painfully long boilerplate methods

```
System.out.println();
vs.
println()
```

Kotlin provides you with concise convenience methods that wrap many painfully long Java calls. `println` is the most basic (though admittedly not the most practical) example, but [Kotlin’s standard library](https://kotlinlang.org/api/latest/jvm/stdlib/) has a boatload of useful tools that cut down on Java’s inherent verbosity.

#### 5. Write semicolons

```
;
;
vs.

```

Need I say more?

🏅*Honorable mention: Not shown, but you *[*never have to write the *](https://kotlinlang.org/docs/reference/classes.html#creating-instances-of-classes)`[*new*](https://kotlinlang.org/docs/reference/classes.html#creating-instances-of-classes)`[* keyword *](https://kotlinlang.org/docs/reference/classes.html#creating-instances-of-classes)*ever again either!*

---

Look, I know these aren’t mind-blowing features. But these little things, in aggregate over many months and tens of thousands of lines of code, can make a big difference in your work. It really is one of those things you have to experience to appreciate.

Put all these little things together with Kotlin’s headline features and you’re in for a real treat. 🍩

---

*If this article was helpful to you, please do hit the *💚* button below. Thanks!*

*We’re hard at work making the *[*Basecamp 3 Android app*](https://play.google.com/store/apps/details?id=com.basecamp.bc3)* better every day (in Kotlin, of course). Please check it out!*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
