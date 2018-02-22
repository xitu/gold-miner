> * 原文地址：[Why Your App Looks Better in Sketch: Exploring rendering differences between Sketch and iOS](https://medium.com/@nathangitter/why-your-app-looks-better-in-sketch-3a01b22c43d7)
> * 原文作者：[Nathan Gitter](https://medium.com/@nathangitter?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/why-your-app-looks-better-in-sketch.md](https://github.com/xitu/gold-miner/blob/master/TODO/why-your-app-looks-better-in-sketch.md)
> * 译者：Ryden Sun
> * 校对者：

# 为什么你的APP在Sketch上看起来更好: 探索Sketch和iOS的渲染差异

### 找出两幅图的差异

你能找到下面两幅图之间的不同点吗？

![](https://cdn-images-1.medium.com/max/1000/1*y4jskGqLNFIK_XnJD2ivcw.jpeg)

如果你仔细看， 可能会注意到一些微妙的差别：

右面的这幅图:

1. 有更大的阴影.
2. 有更深的渐变.
3. “in”这个单词在段落的第一行

左边的这幅图是Sketch的一张截图， 右边的图是iOS系统实际产出的图。这些差别会在图片渲染的时候出现。 他们有完全相同的字体，行间距，阴影半径，颜色和渐变属性 - 所有的这些常量都是相同的。

![](https://cdn-images-1.medium.com/max/800/1*nVZjiFK-DJllaBRrep5W2Q.gif)

你可以看到，原始设计图的某些方面在从设计图到真实代码的转变过程中有所丢失。我们会对这些细节进行探索，因此你可以知道去注意哪里并且如何修复这些问题。

### 我们为什么要关心

设计对于移动APP的成功来说是至关重要的。尤其在iOS平台，用户已经习惯了APP运行顺畅并且界面优美。

如果你是一个移动应用的设计者或者开发者，你知道小的细节对于终端的用户体验是多么的重要。高质量的软件只能从那些深切在乎他们的作品的人们中产出。

APP为什么有可能看起来并不像原始设计稿那样好，这是由很多原因的。我们会调查更精细的原因中的其中一个 - Sketch 和 iOS 渲染时的不同。

![](https://cdn-images-1.medium.com/max/2000/1*MOcAlyqfmddQ0Ytpjw6ORA.jpeg)

### 转化过程中的丢失

某些特定类型的用户体验因素在Sketch和iOS上有显著的不同。我们将探索一下几个因素：

1. 排版
2. 阴影
3. 渐变

### 1. 排版

排版有许多种实现方式, 但在这个测试中我将会用label来实现（Sketch中的“Text”元素，iOS中的‘UILabel’）。
让我们一起来看一下其中的一些不同:

![](https://cdn-images-1.medium.com/max/1000/1*1hmlpwlESTIIh7jOHL57Ug.jpeg)

上面这个例子中最大的不同就是换行的位置。 设计图中的第三组文字以“This text is SF Semibold”开始，在“25”后面进行换行，但在app中，换行是在“points”后进行的。这个相同的问题会发生在那些换行不一致的的文字段落中。
另一个比较小的不同是leading（行间距）和tracking（字符间距）在Sketch中稍大一些。

当他们直接被覆盖时，这些不同会被更容易看到：

![](https://cdn-images-1.medium.com/max/800/1*kLWEbWg31g1H4Gw06uYPQg.gif)

那另外的字体会怎样呢? 将San Francisco字体替换成Lato（一个更广泛使用的免费字体），我们得到了下面的结果：

![](https://cdn-images-1.medium.com/max/800/1*-HuZDeMf9cc9H2Q3aIYDkw.gif)

效果好了很多!

行间距和字符间距仍旧存在一些不同，但是大体上是小了。不过要注意，如果文字需要和其他元素对齐比如背景图片，这些小的偏移量可能会相当明显。

#### 如何修复

其中的一些问题是和iOS的默认字体：San Francisco有关的。当iOS渲染系统字体时，他会自动包括基于字号的字符间距。这个自应用的字符间距表可以[在苹果网站上](https://developer.apple.com/fonts/)获得。有一个[Sketch 插件](https://github.com/kylehickinson/Sketch-SF-UI-Font-Fixer)叫做“SF Font Fixer”，它在Sketch中反应出了这些值。 我十分推荐它如果你的设计稿用到了San Francisco字体。

(边注: 要一直记住在Sketch中将text box（Sketch控件）紧紧包住文字四周。这个可以通过选择文字并且打开“Fixed”和“Auto”对齐来实现，接着重置text box的宽度。如果存在任何额外的空间，这会轻易的导致不正确的值输入到布局中。)

### 2. 阴影

阴影并不像排版一样有全局布局的规则，它并没有清晰的规划。

![](https://cdn-images-1.medium.com/max/1000/1*5KfDKJNuPB_dTDI9XDX2hA.jpeg)

我们可以在上面的图片中清晰的看到，阴影在iOS上默认的会大一些。在上面的这些例子中，这一点在长方形的边框上造成了最明显的不同。

阴影是比较棘手的，因为Sketch和iOS的变量是不一样的。最大的不同是‘CALayer’没有“spread”的概念，即使我们可以通过增大layer的面积使他包含整个阴影来解决。

![](https://cdn-images-1.medium.com/max/1000/1*0DdS1KFBq89nKNn_dWnfTg.jpeg)

阴影可以在Sketch和iOS的不同上变化很广泛。我曾看到过一些阴影在Sketch上看起来很好但在真机上几乎不可见，即使他们有一模一样的参数。

![](https://cdn-images-1.medium.com/max/800/1*6lznpdyRVwU1kS77-6qeug.gif)

#### 如何修复

阴影很棘手并且需要手动的调节来匹配原始的设计图。时常地，阴影半径需要变小并且不透明度需要变高。

```
// old
layer.shadowColor = UIColor.black.cgColor
layer.shadowOpacity = 0.2
layer.shadowOffset = CGSize(width: 0, height: 4)
layer.shadowRadius = 10

// new
layer.shadowColor = UIColor.black.cgColor
layer.shadowOpacity = 0.3
layer.shadowOffset = CGSize(width: 0, height: 6)
layer.shadowRadius = 7
```

所需的改变是会根据大小，颜色和形状来变化的-这里，我们仅仅需要一些很小的调整。

### 3. 渐变

渐变结果证明也是很麻烦。

![](https://cdn-images-1.medium.com/max/1000/1*Gmw_KgTd_o2BNIbsmEDIXw.jpeg)

三个渐变中， 只有“橙色”（上）和“blue”（右下）有所差异。

橙色的渐变在Sketch上看起来更加横向，但是在iOS上更加的竖向。因此，整体的颜色渐变在最终的app上要比设计时更黑一些。

蓝色渐变的不同更加的突出一些-iOS上的角度更加的偏向垂直。这个渐变是被三种颜色来定义的：左下角的浅蓝色，中间的深蓝和右上角的粉色。

![](https://cdn-images-1.medium.com/max/800/1*4D59Cblav3cAaA4OZS0ATQ.gif)

#### **如何修复**

如果渐变是需要角度的，那开始点和结束点可能需要一些调整。尝试根据这些不同轻轻地偏移`CAGradientLayer`的`startPoint`和`endPoint`属性。

```
// old
layer.startPoint = CGPoint(x: 0, y: 1)
layer.endPoint = CGPoint(x: 1, y: 0)

// new
layer.startPoint = CGPoint(x: 0.2, y: 1)
layer.endPoint = CGPoint(x: 0.8, y: 0)
```

这里没有什么魔法公式-这些值需要不断的调整迭代知道两个结果在视觉上匹配。

*Jirka Třečák 发布了[一个精彩的回复](https://medium.com/@JiriTrecak/as-for-the-gradients-there-actually-is-a-magic-formula-89055944b52a) ，包含了链接来解释渐变在渲染时是如何工作的。如果你想深入源码了解的话可以去看一下！

### 自己亲眼看看

我创建了一个演示app来在真机上简单的看一下这些不同。它包含了上面的这些例子，同时还有源码和原始的Sketch文件所以你可以任意的调整这些常量。

这是一个很好的办法来在团队内部增强意识-只需要把你的手机给他们然后他们自己就会看到。简单地触摸屏幕上任意地方就可以切换图片（类似于上面的gif图片）。

获得开源的演示app: [https://github.com/nathangitter/sketch-vs-ios](https://github.com/nathangitter/sketch-vs-ios)

![](https://cdn-images-1.medium.com/max/1000/1*CkGRiP4ZvKpBEHdw_4dwdQ.jpeg)

Sketch vs iOS 演示 APP - 自己试一下！

### 总结

不要假设同样的值意味着同样的结果。即使数值是匹配的，实际的视觉表现也可能不匹配。 

在最后， 任何设计在实现后都需要迭代。设计师和工程师良好地协作对于高质量最终产品是起决定性的。

* * *

喜欢这个故事？在Medium这里留下一些掌声并且分享给你的iOS 设计/开发 朋友。想要持续获取移动app 设计/开发 的最新信息？ 在Twitter上关注我们： [https://twitter.com/nathangitter](https://twitter.com/nathangitter)

感谢[Rick Messer](https://medium.com/@rickmesser)和[David Okun](https://twitter.com/dokun24)对这篇文章的校正。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
