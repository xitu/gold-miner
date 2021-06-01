> * 原文地址：[Jetpack Compose: An easy way to RecyclerView (Part I)](https://www.waseefakhtar.com/android/recyclerview-in-jetpack-compose/)
> * 原文作者：[Waseef Akhtar](https://www.waseefakhtar.com/author/waseefakhtar/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/recyclerview-in-jetpack-compose.md](https://github.com/xitu/gold-miner/blob/master/article/2021/recyclerview-in-jetpack-compose.md)
> * 译者：
> * 校对者：

# Jetpack Compose: An easy way to RecyclerView (Part I)

If you're new to Jetpack Compose and looking at all the cool UI screens and animations around the internet like me, you're probably a bit overwhelmed but also curious about how things work in compose.

![Jetpack Compose: An easy way to RecyclerView (Part I)](/content/images/size/w2000/2021/04/Jetpack-Compose-highres-5-1.jpg)

If you're new to Jetpack Compose and looking at all the cool UI screens and animations around the internet like me, you're probably a bit overwhelmed but also curious about how things work in compose.

Since I'm new to learning Jetpack Compose like most of you, the recent #AndroidDevChallenge was a good opportunity for me to get my hands dirty and write some Jetpack Compose UIs. Since I learnt tons of stuff with a basic app, I thought my learnings would make a good series of blog posts to help all of you.

With this series of blog posts, we'll create a basic app by showing a list of puppies for adoption, styling our app overall, and implementing a detailed view screen for each puppy.

By the end of the series of posts, we would've achieved our app looking like this:

![](https://www.waseefakhtar.com/content/images/2021/04/New--1-.gif)

So without further ado, let's get started!

## Background ✍️

* Jetpack Compose is a newly announced UI toolkit for building native UIs for Android using Kotlin that is going to very soon replace the current approach of building UIs with XML.
* It is written from the ground up in Kotlin.
* It simplifies UI development on Android with less code and powerful tools.
* Learn more at [https://developer.android.com/jetpack/compose](https://developer.android.com/jetpack/compose)

## Prerequisite ☝️

Since Jetpack Compose is not currently fully supported by stable Android Studio at the moment, for this tutorial, I’ve used [Android Studio 2020.3.1 Canary 14](https://developer.android.com/studio/preview) but I believe that the steps I give would work quite fine on newer and more stable AS versions as they start supporting Jetpack Compose.

## Project Setup ⚙️

To get things started, here’s what you do:

1. Open a new project.
2. Select an ****Empty** Compose **Activity**** Project Template and give your app a name. This would create an empty Android project.

![](https://www.waseefakhtar.com/content/images/2021/04/1-10.png)

![](https://www.waseefakhtar.com/content/images/2021/04/2-9.png)

## Running the project 🏃‍♂️

Before we start writing our first line of Jetpack Compose code, let's run our current project set up by AS for us. Since we're using unstable/preview versions of Jetpack Compose and AS, chances are, there are some unknown issues that you might encounter along the way. So it's always a good idea to run your project after each change.

In my case here, after running the project for the first time, I ran into this:

```
An exception occurred applying plugin request [id: 'com.android.application']
> Failed to apply plugin 'com.android.internal.application'.
   > com.android.builder.errors.EvalIssueException: The option 'android.enableBuildCache' is deprecated.
     The current default is 'false'.
     It was removed in version 7.0 of the Android Gradle plugin.
     The Android-specific build caches were superseded by the Gradle build cache (https://docs.gradle.org/current/userguide/build_cache.html).

* Try:
Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output. Run with --scan to get full insights.
```

In order to solve it:

1. Open `gradle.properties`.
2. Remove the line `android.enableBuildCache=true`.

Upon running the project again, you should see a sample Compose app that AS has built for us.

![](https://www.waseefakhtar.com/content/images/2021/04/3-9.png)

Upon a successful run, we're now ready to get our hands dirty!

## Writing our first line of Compose ✨

In order to start writing our app, we need to first structure our app to what I call Jetpack Compose conventions since I've often seen it as a common structure among Google Codelabs.

First things first:

1. Open `MainActivity.kt`.
2. Create a new composable function under your `MainActivity` class.
3. Import `Scaffold` into your file if it's not imported automatically and is shown as an unresolved reference.

###### What is Scaffold? 🤔

If you read Scaffold's definition, it is mentioned that Scaffold implements the basic material design visual layout structure in Compose. So it's generally a good idea to start your screen structure with Android's own visual layout structure.

4\. Replace your sample Hello World greeting by calling `MyApp()` inside onCreate.

Next, we need to write our content that we added to our Scaffold's content parameter, `BarkHomeContent()`.

But first, we do know that we need to display a list of puppies with some sort of detail for each puppy and perhaps a picture to go along with it. In order to do so, we need to create a Data class that holds information for each puppy and a Data Provider that provides us with a list of puppies in their correct structure to be displayed in our list.

## Setting puppies for adoption 🐶

In a real scenario, our data would generally be provided by a backend through some sort of RESTful API that we need to work with asynchronously and write a different flow for. But for learning purposes, we're going to fake our data and write all our puppies information and add their pictures in our app itself.

In order to do so:

1. Create a new class called `Puppy.kt`.
2. Write a data class with fields of all the properties that we're going to have in order to populate our list items with:

Next, we're going to add some cute pictures of puppies to add it for each puppies. To make your life easier, feel free to download the set of photos from my GitHub project here:

[

waseefakhtar/bark

An Android App for the #AndroidDevChallenge. Contribute to waseefakhtar/bark development by creating an account on GitHub.

![](https://github.githubassets.com/favicons/favicon.svg)GitHubwaseefakhtar

![](https://opengraph.githubassets.com/0de026bcb938b30ccb00b58a8008136705db30c646b5163160c44a0dcd48e234/waseefakhtar/bark)

](https://github.com/waseefakhtar/bark/tree/main/app/src/main/res/drawable-nodpi)

After downloading,

1. Select all the files.
2. Copy the files.
3. In Android Studio, under **/res**, select **/drawable** and paste all your files.

![](https://www.waseefakhtar.com/content/images/2021/04/4-6.png)

1. When prompted with the dialog asking for which directory to add them to, select `drawable-nodpi`. (If you can't see it, you can manually create the directory under **/res** or just paste your files inside **/drawable**)

![](https://www.waseefakhtar.com/content/images/2021/04/5-5.png)

Now we're finally going to write out DataProvider class to structure our data for the list.

1. Create a new class called `DataProvider.kt`.
2. Write an object declaration and create a list with information about each puppy. (Feel free to copy all the text to save your time building the app)

And we're done getting our puppies ready for adoption. 🐶

## Displaying Puppies in a list 📝

Now, going back to where we left off when calling `BarkHomeContent()` inside `MyApp()`, we're finally going to create a list item and populate our list with the data we just created.

First things first,

1. Create a new class called `BarkHome.kt`.
2. Add the composable function, `BarkHomeContent()`, inside the new class.
3. Import all the missing references.

Note: You might notice that at this point, you might have a different version of `items` function that we need, considering that the parameter `items =` is not resolved. In that case, you need to manually import the reference for it at the top of class: `import androidx.compose.foundation.lazy.items`.

Now, there's quite a bit going on here, let's explain it one by one.

1. On line 3, we define a `puppies` variable but with a `remember { }` keyword. A remember function in a composable function simply stores the current state of the variable (in our case, the `puppies` variable) when the state of the list changes. This would be quite useful in a real-life scenario where the list changes from the back-end or from user events if we have any UI elements that let users change the state of the list. In our current case, we do not have such functionality but it's still a good practice to persist the state of our puppy list. To learn more about states, have a look at the docs:

[

State and Jetpack Compose | Android Developers

![](https://www.gstatic.com/devrel-devsite/prod/vdb246b8cc5a5361484bf12c07f2d17c993026d30a19ea3c7ace6f0263f62c0dd/android/images/touchicon-180.png)Android Developers

![](https://developer.android.com/images/jetpack/compose/udf-hello-screen.png)

](https://developer.android.com/jetpack/compose/state)

2. On line 4, we call a `LazyColumn` composable. This is the equivalent of the RecyclerView that we as Android developers are quite familiar with. This honestly calls for a big celebration because of how easy it is to create a dynamic list with Jetpack Compose. 🎉

3. On line 5, inside `LazyColumn` params, we give it a nice little padding to give our items a bit of a breathing space, and

4. On lines 7-11, inside `LazyColumn`'s content, we call the `items` function that takes our `puppies` list as the first param, and a composable `itemContent` (that we're going to create next) that takes our list item composable to populate with each item in the list.

## Creating a list item 📝

Next, we're going to create our list item composable that we're going to call `PuppyListItem`:

1. Create a new Kotlin file, `PuppyListItem.kt`.
2. Write a new simple composable function in the class that takes a `Puppy` type as a param.
3. Inside the function, create a `Row` that represents a row in a list.
4. Inside the `Row`, create a column of two texts and pass in the puppy title on the first text and a view detail as the second text.

This is the result when running the app after creating our `PuppyListItem`.

![](https://www.waseefakhtar.com/content/images/2021/04/6-4.png)

Not very nice looking. But there are easy steps to style our item.

## Styling List item 🎨

1. Add a bit of a padding and make the texts full width for some breathing space.

![](https://www.waseefakhtar.com/content/images/2021/04/7-3.png)

2. Surround your `Row` with a `Card` composable and style it as you please.

![](https://www.waseefakhtar.com/content/images/2021/04/8-2.png)

Finally, we need to add an image for each puppy. In order to do so:

1. Create a new composable function, `PuppyImage()` under `PuppyListItem()`, passing the `puppy` param.
2. Call the `Image` composable function and style it as you please:

3. Finally, call `PuppyImage()` the first thing inside your `Row` in `PuppyListItem()`.

![](https://www.waseefakhtar.com/content/images/2021/04/9-2.png)

And voilà! we're done populating our dynamic list view with our data. And that's about it for this post.

The two things left now are to:

1. Style the app to our final look.
2. Implement a detailed view screen.

Happy coding! 💻

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
