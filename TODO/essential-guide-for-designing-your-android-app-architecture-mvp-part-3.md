> * 原文地址：[Essential Guide For Designing Your Android App Architecture: MVP: Part 3 (Dialog, ViewPager, RecyclerView, and Adapters)](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-3-dialog-viewpager-and-7bdfab86aabb)
> * 原文作者：[Janishar Ali](https://blog.mindorks.com/@janishar.ali?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/essential-guide-for-designing-your-android-app-architecture-mvp-part-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/essential-guide-for-designing-your-android-app-architecture-mvp-part-3.md)
> * 译者：[woitaylor](https://github.com/woitaylor)
> * 校对者：[hanliuxin5](https://github.com/hanliuxin5)

# Android MVP 架构必要知识：第三部分（Dialog，ViewPager，RecyclerView 以及 Adapters)

![](https://cdn-images-1.medium.com/max/2000/1*pjBVelQ5lYEA_yLHK7j1Jg.png)


Android MVP 架构系列文章的第1部分和第2部分自发布以来非常受欢迎，对此我感到很高兴。并且因为你们的建议和贡献，项目也优化得更好了。

在这个开发过程中，许多人询问过如何在这个架构中使用 `Dialog` 以及基于 `Adapter` 的视图。因此，我会在这篇博客中补充这两点。

如果你还没有阅读前面两篇博客，那么我会强烈建议在阅读本文之前阅读这两篇博客。下面是博客的链接地址：

- [[译] Android MVP 架构必要知识：第一部分](https://juejin.im/entry/58a27b2d2f301e006958d4aa)
- [[译] Android MVP 架构必要知识：第二部分](https://juejin.im/entry/58a5992961ff4b006c4455e3)
- [**MindorksOpenSource/android-mvp-architecture**
仓库里面有实现该框架完整的示例代码](https://github.com/MindorksOpenSource/android-mvp-architecture)

在这篇文章中，我会添加一个评分对话框和 `Feed` 界面来扩展这个框架。

> 译者：`Feed` 指的是 `RSS` 订阅源，[Feed 百科](https://baike.baidu.com/item/Feed/15181?fr=aladdin),下面的译文中我就直接使用 `Feed` 或者 `RSS`。

> 精益求精

我们先看下效果图：

![](https://cdn-images-1.medium.com/max/400/1*DRA1PXswO3sl-_a3aebk9Q.png)

![](https://cdn-images-1.medium.com/max/400/1*R9fplojmQyuOvQEAnlfv1g.png)

![](https://cdn-images-1.medium.com/max/400/1*2u_3aDsu-vLwQi40bWpx5w.png)


#### 评分对话框

1. 评分对话框显示 5 个星星，用户可以根据自己的满意度来选择星星的个数。
2. 如果星星数量小于 5，我们将会修改对话框来显示一个反馈表单，用来询问用户的改进建议。
3. 如果星星个数为 5。我们就在对话框中显示一个跳转到应用商城（这里指的是 `google play`）的选项。用户可以在那里进行评论。
4. 评分信息会发送到应用的后台服务端。

注意：从用户的角度来看评分对话框并不是必须的，但是对我们开发者来说却很重要。所以，应用需要很巧妙地设计这个执行流程。

> 我建议把对话框里面相邻控件的间距调大点。

#### Feed 界面

1. 这个界面会有两个子界面。
2. 子界面 1：博客 `RSS` 的列表界面。
3. 子界面 2：开源代码 `RSS` 的列表界面。

#### 博客 `RSS` 子界面

1. 从服务器获取数据。
2. 用数据填充 `RecyclerView` 中的 `CardView`。

#### 开源项目 `RSS` 子界面

1. 从服务器获取仓库数据。
2. 这些仓库数据用来填充 `RecyclerView` 里面的 `CardView`。

现在，我们明确了业务需求，接下来就是根据这些需求来扩展已有的架构。

> 我不会把整个代码片段都贴在这里，因为它太长了。而是在浏览器的新标签中打开这个 [MVP 项目](https://github.com/MindorksOpenSource/android-mvp-architecture)。后面我们就在这两个标签中来回切换。

概述:

添加以下几个类

(在[项目](https://github.com/MindorksOpenSource/android-mvp-architecture)的 [com.mindorks.framework.mvp.ui.base](https://github.com/MindorksOpenSource/android-mvp-architecture/tree/master/app/src/main/java/com/mindorks/framework/mvp/ui/base) 包里面查看代码 )

1. **BaseDialog**：这个类里面我们添加 `Dialog` 的模板代码，以及一些通用的方法。实际项目用到的 `Dialog` 可以通过扩展该基类来实现。
2. **DialogMvpView**：这个接口定义了 `Presenter` 与 `Dialogs` 交互的API。
3. **BaseViewHolder**：它定义了 `RecyclerView` 绑定框架，并实现了 `ViewHolder` 被复用时自动清理视图的功能。

``` java
public abstract class BaseDialog extends DialogFragment implements DialogMvpView
```

> 关于框架的一点说明。

> 所有相关的功能应该组合在一起，我称之为功能点的封装，使他们相互独立。

#### [评分对话框](https://github.com/MindorksOpenSource/android-mvp-architecture/tree/master/app/src/main/java/com/mindorks/framework/mvp/ui/main/rating):

1. 可以通过左侧抽屉的菜单列表打开这个对话框。
2. 它的实现和[**第二篇**](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-2-b2ac6f3f9637)博客里面的MVP组件很相似。

**在你浏览器的新标签中打开**[**project repo**](https://github.com/MindorksOpenSource/android-mvp-architecture/tree/master/app/src/main/java/com/mindorks/framework/mvp/ui/main/rating)**，彻底研究评分对话框部分在项目中的实现**

关于对话框的一点说明

> 有些应用可能会用到很多小对话框，对于这种情况我们可以创建通用的 `mvpview`，`mvppresenter` 和 `presenter` 给这些对话框使用。

#### [Feed 部分:](https://github.com/MindorksOpenSource/android-mvp-architecture/tree/master/app/src/main/java/com/mindorks/framework/mvp/ui/feed)

1. 这个包里面包含了 `FeedActivity` 和它的 `MVP` 组件，`FeedPagerAdapter`，`blog` 包以及 `opensource` 包。
2. **blog**: 这个包里面有 `BlogFragment` 和它的 `MVP` 组件以及 `RecyclerView` 的 `BlogAdapter`。
3. **opensource**: 这个包里面有 `OpenSourceFragment` 和它的 `MVP` 组件以及  `RecyclerView` 的 `OpenSourceAdapter`。
4. `FragmentStatePagerAdapter` 用于创建 `BlogFragment` 和 `OpenSourceFragment`。

> 永远不要在任何 `Adapter` 类里面实例化任何对象，或者使用 `new` 操作符生成对象。请通过 `dagger` 注入来获取它们。

`OpenSourceAdapter` 和 `BlogAdapter` 是 `RecyclerView.Adapter<BaseViewHolder>` 的实现类。在这个项目里面，当没有可用数据的时候会显示一个空视图。用户可以点击 `RETRY` 按钮来重新获取数据，并在获取到数据的时候删除该空视图。

> `API` 数据分页和网络状态的处理就留给你作为练习。

**现在请通过项目来研究代码，仔细研究XML中的布局以及如何通过代码操作视图。**

如果您觉得有困难或需要任何帮助或改善，请在 `Mindorks` 社区提出你的问题：点击[**这里**](https://mindorks.com/join-community)加入 `Mindorks Android` 社区，在这里我们可以相互学习。

* * *

**感谢您阅读这篇文章，如果你觉得这篇文章对你有帮助，别忘了点下面的 ❤ 。这会帮助更多人从这篇文章中学到知识。**

如果想获取更多编程知识，在 Medium 上关注[**我**](https://medium.com/@janishar.ali) 和 [**Mindorks**](https://blog.mindorks.com/)，这样你就能在新文章发布的第一时间收到通知了。

[Check out all the Mindorks best articles here.](https://mindorks.com/blogs)

你也可以通过 [**Twitter**](https://twitter.com/janisharali)**,** [**Linkedin**](https://www.linkedin.com/in/janishar-ali-8135a451/)**,** [**Github**](https://github.com/janishar)**,** 和 [**Facebook**](https://www.facebook.com/janishar.ali) **加我好友。**

Coder’s Rock :)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

