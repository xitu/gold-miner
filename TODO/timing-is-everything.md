> * 原文地址：[Timing is Everything](https://medium.com/google-developers/timing-is-everything-8218b8df5485#.tlp6t4pxv)
* 原文作者：[Chet Haase](https://medium.com/@chethaase)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Siegen](https://github.com/siegeout)
* 校对者：[Nicolas(Yifei) Li](https://github.com/yifili09) ,[zale](https://github.com/zhangliukun)

## 用定制的非线性定时曲线改善你的动画


在现实世界中的运动是非线性的。（当你穿过街道时，你只要略微将你盯着手机的眼睛瞄一眼街道就足够保证你不会被车撞到。）当我们走路的时候，我们在加速。当我们停止的时候，我们慢慢减速到 0（除非我们被车撞了，这样我们会体验到我们朝着另一个方向突然加速）。当我们下落的时候，重力使我们加速下落，当我们跳起的时候，它又会降低我们的上升速度。无论如何，我们无法在整个运动中保持一个恒定的移动速度。



所以作为人类，当我们看到屏幕上的运动时（我们正在观看手机上的动画，并没有留意到那些正在靠近我们的车辆的时候。），我们期望它也是同样的非线性，因为这样会让人感觉更自然。通常来说，我们在应用里尝试实现的自然交互，它是用来帮助用户更好的理解这些应用里的虚拟世界究竟在发生什么。不要尝试用你奇特的动画技巧让他们惊奇；给他们感受起来很自然的动画，以便于他们可以更容易的使用你的应用然后完成他们需要做的事情。

#### Android Interpolation



从一开始， Android 就已经提供了通过它的  [Interpolator](https://developer.android.com/reference/android/view/animation/Interpolator.html)  实现来制作非线性动画对象的能力。事实上，默认的动画通常是[加速进入和减速退出运动](https://developer.android.com/reference/android/view/animation/AccelerateDecelerateInterpolator.html)中的一个。更加重要的是，Android 也为开发者提供了改变默认运动的能力，以此来提供其他类型的速度变化。举个例子，你可以使你的动画快速的开始然后减速退出。或者，慢慢的开始然后逐渐加速。自从  Lollipop 版本 (API 21)发布了以后，Android 又提供了[基于路径的定时曲线](https://developer.android.com/reference/android/view/animation/PathInterpolator.html)来完成更加复杂和灵活的控制。甚至于，如果你想要凸显你的奇特，你可以使用[线性 interpolation](https://developer.android.com/reference/android/view/animation/LinearInterpolator.html) (但是请不要这样做)。




有了这么多的选项，那么问题来了：你应该为你的动画使用哪一个呢？


#### 如此多的选择！



在今年的 Google I/O 大会上，一个开发者靠近我问道：“我应该使用什么类型的 interpolation 来让一个 text 元素从边上滑入？”


这是一个好问题，我建议更多的开发者应该为他们自己的应用问一下这个问题。



不幸的是，这个问题的答案是一个令人并不满意的模糊答案，“看情况”。这取决于你，你的应用，这个动画的上下文，你的用户，以及许多其他的因素，没人可以简单的为你做决定。确实是有某种程度上较好与较坏方式的判定（例如：不要为移动的物体使用 LinearInterpolator ，让你的动画尽可能的快）。但是并没有可以通用的“正确”答案。


我的推荐（确切答案的一个微不足道的替代品）是使用不同的 interpolators，然后在他具体的情况下试验下，选择感觉最好的那个。或者，更一般的说，写一个简单的测试应用，允许他使用不同 interpolator，然后简单的比较下。



我意识到这是我们能为他（也是为每个人）提供的东西。这不是一个难写的应用，但是用来比较内置的interpolator还是很有用的，对开发者来说它应该是很方便的，无论是使用或者是修改他们任意的定制需求。



所以下面的就是：

#### [InterpolatorPlayground](https://github.com/google/android-ui-toolkit-demos/tree/master/Animations/InterpolatorPlayground)






![](http://ac-Myg6wSTV.clouddn.com/a821863d8a772e1050f8.png)




InterpolatorPlayground 实战


介绍下 [InterpolatorPlayground](https://github.com/google/android-ui-toolkit-demos/tree/master/Animations/InterpolatorPlayground),这是一个简单的 Android 应用，你可以使用它来选择几个标准 interpolator 中的一个，然后实验看看它们是如何影响一个动画的。你可以改变动画的持续时间以及 interpolator 的构造参数。通过给 UI 中各种对象添加 interpolation 动画，你可以使 interpolation 曲线和产生的影响可视化。最后，你可以为两个 PathInterpolator 选项（平方和立方）拖动控制点来看看如何使用这个具体的类创建非常个性和灵活的定时曲线。



你也可以运行一些有趣的(尽管用处不大) interpolator，例如反弹和冲出（主要是因为他们在运行的时候看起来很有趣）。



一旦你决定为你的应用使用一个你喜欢的动画，简单地记下 UI 中的参数，然后在你的代码里使用那些参数创建适当的 Interpolator。


#### 它是怎样的运行

在你的代码里插入一个 Interpolator 之后你就可以调用它。你可以不用理解其中的细节；你真正需要的是你正在寻找的运动效果。


但是如果你不关心它是如何运行的，那为什么你还要选择成为一名程序员呢？细节才是真正有趣的地方。


interpolator 运行的方式，或者更具体地说，interpolator 影响动画定时曲线，是通过改变当前完成时间的百分比来进行的。在 Android 中的每个动画都设置了一个持续时间（默认的时长是 300 毫秒）。在动画持续时间内的任意一个时间点，系统计算出已经运行了多长时间，然后调用 animation 让它根据之前得到的时间来计算新的 animated 值。运行时间可以被表达成一个比例因子（0 是开始，1 是结束）。举个例子，一个 animation 正进行到中间时刻，那么它当前完成的比例因子就是  0.5，它的计算值就处于它的起始值和结束值的中间。



但是我们没有直接传递那个比例因子,替代的我们通过一个 Interpolator 传递比例因子，这个 Interpolator 把当前完成的比例因子作为输入然后返回另一个比例因子作为输出。被插入的比例因子被我们传递给 animation 对象进行计算。


所以为了改变一个 animation 对象的定时曲线，我们只需要提供一个功能，它把一个当前已完成的比例因子转换成另一个比例因子，然后使用这个新的比例因子来计算  animation 值。


举个非常简单的例子，假设我们创建了一个 Interpolator 通过返回比例因子的相反值来反转 animation，它看起来是这样的：

     public class ReverseInterpolator implements Interpolator {
        @Override 
        public float getInterpolation(float fraction) {
            return 1 - fraction;
        }
    }



这个 interpolator 会使 animation 在开始的时候计算它的结束值（当输入的比例因子为 0 的时候，被插入的比例因子则是 1 ）然后在结束的时候计算开始值（当输入比例因子为 1 的时候，被插入的比例因子则是 0 ）.它会适当地改变那些位于结束值和起始值中间的比例因子。



Android 中内置的 Interpolator 类使用类似的功能，简单的（例如 LinearInterpolator，它只是简单的返回输入值）和更加复杂的（例如 PathInterpolator，它使用平方、立方或者贝塞尔曲线决定返回值）都被用来计算比例因子，这样使得丰富多彩的各种定时曲线都能符合大部分期望。如果你没有找到你想要的，实现你自己的 Interpolator 也是很容易的。



在此同时，把视线从你的屏幕上移开。有辆车正在开过来。


