> * 原文地址：[Essential Guide For Designing Your Android App Architecture: MVP: Part 3 (Dialog, ViewPager, RecyclerView, and Adapters)](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-3-dialog-viewpager-and-7bdfab86aabb)
> * 原文作者：[Janishar Ali](https://blog.mindorks.com/@janishar.ali?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/essential-guide-for-designing-your-android-app-architecture-mvp-part-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/essential-guide-for-designing-your-android-app-architecture-mvp-part-3.md)
> * 译者：
> * 校对者：

# Essential Guide For Designing Your Android App Architecture: MVP: Part 3 (Dialog, ViewPager, RecyclerView, and Adapters)

![](https://cdn-images-1.medium.com/max/2000/1*pjBVelQ5lYEA_yLHK7j1Jg.png)

cover

I am extremely happy that the MVP architecture that we built in part 1 and part 2 together in this article series was very well received and the project repository itself got polished since its release, through your inputs and pull requests.

During the course of this development, many of you inquired about the implementation of Dialogs and Adapter based views in this architecture. So, I am writing this article to explain the place-holding for these.

In case you have not read the earlier resources then I would highly recommend reading those before going along this article. Here are the links for the resources:

- [[译] Android MVP 架构必要知识：第一部分](https://juejin.im/entry/58a27b2d2f301e006958d4aa)
- [[译] Android MVP 架构必要知识：第二部分](https://juejin.im/entry/58a5992961ff4b006c4455e3)
- [**MindorksOpenSource/android-mvp-architecture**
android-mvp-architecture - This repository contains a detailed sample app that implements MVP architecture using…](https://github.com/MindorksOpenSource/android-mvp-architecture)

In this article, we will extend the architecture with the addition of a rating dialog and feed Activity.

> Beauty lies in precision.

Let’s list down all the features and use cases first:

![](https://cdn-images-1.medium.com/max/400/1*DRA1PXswO3sl-_a3aebk9Q.png)

![](https://cdn-images-1.medium.com/max/400/1*R9fplojmQyuOvQEAnlfv1g.png)

![](https://cdn-images-1.medium.com/max/400/1*2u_3aDsu-vLwQi40bWpx5w.png)

view-images

#### RateUs Dialog

1. The rating dialog will display 5 starts for selection to the user as per his app experience.
2. If stars < 5 then we modify the dialog to reveal a feedback form asking the improvements.
3. If stars = 5 then we will modify the dialog to show play-store rating option to take the user there to add review.
4. The rating information will be send to the app’s backend server.

Note: The rating dialog is non-required featured from the user’s end but is highly valuable from the developer’s end. So, the app has to be very subtle to enforce this.

> I recommend using large spaced intervals between two consecutive programmatically rating dialog display.

#### Feed Activity

1. This activity will display two tabs.
2. Tab 1: Blog feed cards.
3. Tab 2: OpenSource feed cards.

#### Blog Feed Tab

1. It will fetch the blog data from server API.
2. The blog data will be populated as cards in the RecyclerView.

#### OpenSource Feed Tab

1. It will fetch the repositories data from server API.
2. The repositories data will be populated as cards in the RecyclerView.

Now that we have defined our features list and use-cases, let’s sketch the architecture for their realization.

> I won’t be adding the entire class code snippet here because it obstruct the focus because of the length. So, what we will do instead is that, we will open the [MVP project](https://github.com/MindorksOpenSource/android-mvp-architecture) in the next tab and switch between them.

Sketch:

We will add below-mentioned base classes

(see inside `[com.mindorks.framework.mvp.ui.base](https://github.com/MindorksOpenSource/android-mvp-architecture/tree/master/app/src/main/java/com/mindorks/framework/mvp/ui/base)` package in the [project](https://github.com/MindorksOpenSource/android-mvp-architecture))

1. **BaseDialog**: This handles most of the boiler plate and adds common functionality for the actual dialogs that will be built upon them.
2. **DialogMvpView**: This interface defines the APIs for the Presenter classes to interact with the Dialogs.
3. **BaseViewHolder**: It defines the framework for RecyclerView binding and auto clearing the views when the ViewHolder is recycled.

```
public abstract class BaseDialog extends DialogFragment implements DialogMvpView
```

> A note for the architecture.

> All the relevant features should be grouped together I call is _encapsulating the features_, making them independent from each other.

#### [RateUs Dialog](https://github.com/MindorksOpenSource/android-mvp-architecture/tree/master/app/src/main/java/com/mindorks/framework/mvp/ui/main/rating):

1. The dialog access is made available through the Drawer.
2. The implementation is similar to any MVP view component that we saw in [**part 2**](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-2-b2ac6f3f9637) of the article.

**Switch to the next tab on your browser and study it’s implementation in the** [**project repo**](https://github.com/MindorksOpenSource/android-mvp-architecture/tree/master/app/src/main/java/com/mindorks/framework/mvp/ui/main/rating) **thoroughly.**

A note for the Dialog

> Sometimes there may be a case for many small dialogs, then we could create a common mvpview, mvppresenter and presenter to share between them.

#### [Feed:](https://github.com/MindorksOpenSource/android-mvp-architecture/tree/master/app/src/main/java/com/mindorks/framework/mvp/ui/feed)

1. This package contains the FeedActivity and its MVP components along this FeedPagerAdapter, blog package and opensource package.
2. **blog**: This package contains BlogFragment and it’s MVP components and BlogAdapter for RecyclerView.
3. **opensource**: This package contains OpenSourceFragment and it’s MVP components and OpenSourceAdapter for RecyclerView.
4. The FragmentStatePagerAdapter creates BlogFragment and OpenSourceFragment.

> Never instantiate any class in any Adapter or else where using `new` operator instead provide them through modules as a dependency.

OpenSourceAdapter and BlogAdapter is an implementation of `RecyclerView.Adapter<BaseViewHolder>`. In the case where no data is available then an empty view is shown that displays forced retry for the user and is removed when the data appears.

> The pagination for API data and network state handling is left as an exercise.

**Go through the project now to study the code. Focus on the branching and also how view is defined in XML as well as programmatically.**

If you find any difficulties or need any explanation or improvement then join mindorks community and put questions there: [**click here**](https://mindorks.com/join-community)to become a part of Android community at Mindorks and learn from each other.

* * *

**Thanks for reading this article. Be sure to click ❤ below to recommend this article if you found it helpful. It would let others get this article in feed and spread the knowledge.**

For more about programming, follow [**me**](https://medium.com/@janishar.ali) and [**Mindorks**](https://blog.mindorks.com/), so you’ll get notified when we write new posts.

[Check out all the Mindorks best articles here.](https://mindorks.com/blogs)

Also, Let’s become friends on[**Twitter**](https://twitter.com/janisharali)**,** [**Linkedin**](https://www.linkedin.com/in/janishar-ali-8135a451/)**,** [**Github**](https://github.com/janishar)**,** and[**Facebook**](https://www.facebook.com/janishar.ali)**.**

Coder’s Rock :)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
