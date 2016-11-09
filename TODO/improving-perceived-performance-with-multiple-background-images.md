
> * 原文地址：[Improving Perceived Performance with Multiple Background Images](http://csswizardry.com/2016/10/improving-perceived-performance-with-multiple-background-images/)
* 原文作者：[Harry](https://twitter.com/csswizardry)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Cyseria](https://github.com/cyseria)
* 校对者：[luoyaqifei](https://github.com/luoyaqifei)，[rottenpen](https://github.com/rottenpen)


我现在在火车上，信号很差。很多网站完全拒绝加载，就算加载了，也会丢失很多图片，留下很大的白洞。幸运的是大多图片都不是我想找的主要内容，但是他们的丢失让会我一直想等其他资源加载出来，在许多情况下是可感知的性能比实际表现本身更重要。于是我产生了一个小想法。

前阵子，我是一个非常高调、高流量的竞选网站的顾问，遗憾的是我不能透露它的名字。我是半路加入来使事情变得更“快”的。

网站的显著特征就是在头部有一张很大的图片，即使在网络情况较好的情况下也需要花一点时间去加载。我做了很多事情想让图片预加载，提前触发请求之类的，其中一个简单的技巧就是将图像的平均颜色作为“背景颜色”，这样图片加载的时候用户就不会看到巨大的白块了。这样，感知性能得到显著的改善,而且工作量少得难以置信:

1. 用 Photoshop 打开图片
2. 滤镜 >> 模糊 >> 平均 （Filter » Blur » Average）
3. 用吸管（Eyedropper）吸取样本块的颜色
4. 将该颜色应用于“背景颜色”（`background-color`:）
```
        .masthead {
          background-image: url(/img/masthead.jpg);
          background-color: #3d332b;
        }
```
    
这个方法我在自己网站首页的页头上也有用到：如果图片需要很长时间去加载，就给用户一个填充的颜色。然而，我现在在火车上打开自己的网站，看到的情况是这样的：

![](http://csswizardry.com/wp-content/uploads/2016/10/screenshot-missing-image.png)

[查看高清大图 (104KB)](http://csswizardry.com/wp-content/uploads/2016/10/screenshot-missing-image-full.png)


图像的关键实际上不是内容，所以它有没有加载完毕并没有太大的关系。虽然可能比我的脸好看些，但仍然不太和谐：毕竟这只是一个扁平的,没有灵魂的色彩。那么怎样才能改善呢？

## 使用 CSS 渐变和多背景

简单来说，我想做一个大概跟图片差不多的 CSS 渐变。我不能强调“大概”这个词是否准确：我们重新讨论几团相似的平均颜色。我当时想把这个作为背景图像的图像本身，然而脑海里的是：噢，不！这张图片已经是一个背景图像。不用担心，我们可以在 [IE9+](http://caniuse.com/#feat=multibackgrounds) 中对同一个元素定义多背景。可以在同一个声明中定义实际的图片和他的大致渐变色。
这意味着，如果你的浏览器有 CSS

1. 它能够大致地绘制 CSS 样式
2. 它能够在加载的时候发送网络请求获取实际的图片

查看更多关于[CSS 多背景](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Background_and_Borders/Using_CSS_multiple_backgrounds)的资料

## 让结果更加近似



为了得到能用在页头的 CSS 样式，我用 Photoshop 打开了图片并且对不同的颜色域进行了分离。因为这张图里面的很多物品是从上到下的，所以我做了一个垂直分割。很方便的这些颜色区域基本在 25% 的区间。

![](http://csswizardry.com/wp-content/uploads/2016/10/screenshot-slices-before.jpg)

[查看高清大图 (140KB)](http://csswizardry.com/wp-content/uploads/2016/10/screenshot-slices-before-full.jpg)


然后我单独选择每个部分并执行 滤镜>>模糊>>平均，然后图片变成这样

![](http://csswizardry.com/wp-content/uploads/2016/10/screenshot-slices-after.png)

[查看高清大图 (2KB)](http://csswizardry.com/wp-content/uploads/2016/10/screenshot-slices-after-full.png)


下一步是对每种颜色进行取样并且将它们转换成 CSS 渐变样式：


    linear-gradient(to right, #807363 0%, #251d16 50%, #3f302b 75%, #100b09 100%)




看起来像这样：

我现在需要做的就是把这个作为我的背景图像 `background-image` 的第二属性值:


    .page-head--masthead {
      background-image: url(/img/css/masthead-large.jpg),
                        linear-gradient(to right, #807363 0%, #251d16 50%, #3f302b 75%, #100b09 100%);
    }


多背景的叠加顺序是这样的，第一个值（本例中是一个实际的图像）是最上面的图片，然后下一个属性放在下一个图层，等等。

这就意味着，如果图片加载失败，我们可以看到：
![](http://csswizardry.com/wp-content/uploads/2016/10/screenshot-missing-image-after.png)

[查看高清大图 (144KB)](http://csswizardry.com/wp-content/uploads/2016/10/screenshot-missing-image-after-full.png)


没有太大的差异，但是比起一个扁平的图片会更加具体：在丢失图片的普通组合上添加一部分纹理和提示就够了。

## 实际上
因此，你可以看到，实现这种技术需要大量的体力劳动，除非有一个可靠的自动化工具，我认为这是一个技术最好的使用场景就像我这样的：一个低频率更改的特殊图片。

从这将是下一个级别的平均颜色图像和应用,作为一个“背景颜色”。不需要渐变和多背景，但它仍然需要每张图象干预。

然而，我很满意这种方式，为用户提供更大量的网络条件差。如果你的网站也有类似的静态图片，我建议尝试这种方法。

[你喜欢这篇文章吗？**雇佣我吧**](http://csswizardry.com/work/)



