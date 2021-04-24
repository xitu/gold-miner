> * 原文地址：[When “Compat” libraries won’t save you](https://proandroiddev.com/when-compat-libraries-do-not-save-you-dc55f16b4160)
> * 原文作者：[Danny Preussler](https://dpreussler.medium.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/when-compat-libraries-do-not-save-you.md](https://github.com/xitu/gold-miner/blob/master/article/2021/when-compat-libraries-do-not-save-you.md)
> * 译者：
> * 校对者：

# When “Compat” libraries won’t save you

And why you should avoid using the “*NewApi*” suppression!

![[https://unsplash.com/photos/EgGIPA68Nwo](https://unsplash.com/photos/EgGIPA68Nwo)](https://miro.medium.com/max/12000/1*_UZ7BojQmk2vRCTx6XIdLA.jpeg)

The idea of “Compat” libraries was probably one of the key aspects of Android dominating the mobile space. Other than with iOS, Android users often could not update their operating system after a new version launch, simply as their phones won’t allow them to, the Android problem of [fragmentation](https://www.androidauthority.com/android-fragmentation-linux-kernel-1057450/). But developers still wanted to use the latest features to compete. The solution was simple: instead of adding new APIs to the operating system, you shipped those directly with your app by using a “backport” version Google gave you.

It all started with [ActionBar Sherlock](https://github.com/JakeWharton/ActionBarSherlock) by [Jake Wharton](https://medium.com/u/8ddd94878165) then got adopted by Google with in their “support libraries”. Later on, this was mirrored as *AndroidX* under the *Jetpack* umbrella.

## Same but different

Under the hood, not all of those “compat”-APIs are made the same way. Some, like the ones for Fragments, are complete copies of the code. You either use `android.app.Fragment` from the OS (actually deprecated) or `androidx.fragment.app.Fragment`. Both don't share any code or have a common base class (which is why we also have two versions of the `FragmentManager`).

On the other hand`AppCompatActivity` for example, simply extends the original `Activity`. Also`AppCompatImageButton` still is an `ImageButton`!

We can see that sometimes these “Compat”-classes are just a “bridge” to add missing functionalities and sometimes they are complete duplicates.

## Let’s look at another example!

One area that changed a lot over time is the notification API from Android. There was a time where every Google I/O introduced a new API change.

Good that we have `NotificationManagerCompat` to save us!?

If, for example, we need to get the notification channel groups:

```kotlin
val groups = notificationManagerCompat.notificationChannelGroups
```

We don't need to worry about the groups being supported on all OS versions, as it is handled under the hood for us:

```kotlin
public List<NotificationChannelGroup> getNotificationChannelGroups() {
    if (Build.VERSION.SDK_INT >= 26) {
        return mNotificationManager.getNotificationChannelGroups();
    }
    return Collections.emptyList();
}
```

If we were before API level 26 we simply get an empty list, otherwise, we get the new channel groups that were introduced in 26.

You can find even more complex checks inside [NotificationManagerCompat](https://github.com/androidx/androidx/blob/androidx-main/core/core/src/main/java/androidx/core/app/NotificationManagerCompat.java#L230).

But if you look closer,`NotificationManagerCompat` will return us the actual API classes. In the example code above a list of `NotificationChannelGroup`, this is not a copied “compat”-version, but as of the check, safe to use:

```kotlin
val groups = notificationManagerCompat.notificationChannelGroups
val channels = groups.flatMap {
    it.channels.filter { it.shouldShowLights() }
}
```

Here we only want those groups whose channels are triggering lights, which is API level 26 and above. As we are using a class that is of higher API level than our minimum SDK, the compiler will warn us here:

![](https://miro.medium.com/max/1692/1*WWdcZVLzzaXduUd1RT0vBg.png)

The compiler doesn't care that we used `NotificationManagerCompat` to get there.

We have multiple ways of solving this:

![](https://miro.medium.com/max/1816/1*L_wx_xAhVMYE0SVzE7_AJw.png)

Adding the `RequiresApi` annotation to our method won’t make much sense, as we would simply move the warning to the calling function. Surrounding with a check feels obsolete as this check was already done by `NotificationManagerCompat` as shown above!

Seems the best option is to pick suppression:

```kotlin
@SuppressLint("NewApi")
private fun checkChannels() {
   val groups = notificationManagerCompat.notificationChannelGroups
   val channels = groups.flatMap {
        it.channels.filter { it.shouldShowLights() }
   }
   ...
}
```

## New requirements coming in

Let’s assume we get the additional requirement to filter out the groups that got blocked. We can add a simple check for that:

```kotlin
@SuppressLint("NewApi")
private fun checkChannels() {
    val groups = notificationManager.notificationChannelGroups
    val channels = groups.filterNot { it.isBlocked }.flatMap {
        it.channels.filter { it.shouldShowLights()}
    }
    ...
}
```

Everything looks fine, right?

## Boom!

But we just introduced a **crash**!  
The reason is: `isBlocked` was only introduced in API level 28 and we did not check for that! Despite we used `NotificationManagerCompat`, we still ran into an API level issue!

And because we suppressed the`NewApi` warnings, we didn't get any warning on this one!

We need to **be really careful when it comes to suppression of this annotation**!

## Solutions?

As it is only available for method-level (not for individual statements), the best approach is to compose one-liner methods that can fit our needs.

Thanks to extension functions this can be very easy:

```kotlin
@SuppressLint("NewApi") // SDK 26
fun NotificationChannelGroup.lightingChannels() = 
   channels.filterLightingOnes()

@SuppressLint("NewApi") // SDK 26
private fun List<NotificationChannel>.filterLightingOnes() = 
   filter { it.shouldShowLights() }
```

If we used this approach with the above example, we would have gotten the warning the moment we added `isBlocked`.

![](https://miro.medium.com/max/3032/1*OpkxXOXSGueoW_TyJyXw3A.png)

Of course, it is a bit more work for us as developers but our users will appreciate a crash-free app!

## The Linter

The example shown was not a bug of a compat-library but rather hidden by the suppression. This could have happened with many other APIs as well.

* Don’t fall into this trap !  
* Using Compat versions might give us false security and trick us into believing that we won’t have to think about these issues.

And again, try to **avoid** **suppressing** `NewApi`**!**

Instead, use direct version checks like:

```kotlin
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P)
```

Unfortunately, the linter is not very smart here. It would not understand slight variations like:

```kotlin
.filter { Build.VERSION.SDK_INT >= Build.VERSION_CODES.P }
```

## Call for help?

Maybe some of you want to look more into this, with some custom lint rules. Basically, we would need something like:

```kotlin
@CheckedUpTo(Build.VERSION_CODES.P)
```

That would internally work similar to `SuppressLint(“NewApi”)` but only for API calls that require nothing higher than P.

For now, make the existing linter functionality work for you. For example by also adding `@RequiresApi(Build.VERSION_CODES.P)` to your own code, so you are always forced to handle those.

Remember, these annotations are also considered as documentation to the reader of your code.

PS: the latest alpha of NotificationCompat will bring us compat-versions for `NotificationChannel` and `NotificationChannelGroup` 🥳

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
