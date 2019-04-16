> * 原文地址：[Planning for Responsive Images](https://css-tricks.com/planning-for-responsive-images/)
> * 原文作者：[Chris Nwamba](https://css-tricks.com/author/chris92/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/planning-for-responsive-images.md](https://github.com/xitu/gold-miner/blob/master/TODO1/planning-for-responsive-images.md)
> * 译者：[LucaslEliane](https://github.com/LucaslEliane)
> * 校对者：[portandbridge](https://github.com/portandbridge)，[ericjin](https://github.com/jxderic)

# 使用网格布局实现响应式图片

当我第一次将一张图片响应式地展示在页面中的时候，我使用的是下面四行非常简单的代码：

```
img {
  max-width: 100%;
  height auto; /* default */
}
```

虽然，对我这样一个开发人员来说是有效的，但是对于用户来说，却不是非常友好。如果 `src` 中的图片文件较大呢？在开发人员的高端设备上（比如，我的具有 16 GB RAM 的设备），很少甚至从不出现性能问题。但是在低端设备上呢？情况就不一样了。

![image at multiple screen sizes](https://css-tricks.com/wp-content/uploads/2019/02/s_FC2DE27452E05E045139FF003894009220F80784C1D613CC87FFB9D39C36AD83_1548753777363_rri-bad.png)

上面的插图不是非常详细。我来自尼日利亚，如果你需要你的产品能够在非洲工作，那么你不应该看上面的那张图。请看下面这张图片

![](https://css-tricks.com/wp-content/uploads/2019/02/s_FC2DE27452E05E045139FF003894009220F80784C1D613CC87FFB9D39C36AD83_1548754128425_atlas_SkfTnjyiz2x.png)

如今，价格最低的 iPhone 售价平均为 300 美元。即使 iPhone 是衡量**快速**设备的门槛，普通非洲人也买不起。

首先，如果你能够理解上面的智能手机的产业分析，你就能够明白为什么设置 CSS 的宽度并不是实现响应式图片的好办法了。你会问为什么？请让我先来解释一下图像的含义。

### 图像的细微差别

图像对于用户是非常有吸引力的，但是对于我们开发者来说是一项间距的任务，因为我们必须考虑到下面的因素：

* 格式
* 图像占用磁盘大小
* 渲染尺寸（浏览器中的布局高度和宽度）
* 原始尺寸（原始图片的高度和宽度）
* 宽高比

那么，我们如何选择正确的参数，并且巧妙地混合和匹配上面的几个因素，来为用户提供最佳的体验呢？反过来说，最终的答案取决于下面几个问题的答案。

* 图像是由用户动态创建的还是由视觉设计团队静态创建的？
* 如果图像的宽度和高度不成比例地改变，会影响图像的质量吗？
* 所有的图像都以相同的宽度和高度渲染吗？渲染的时候，这些图像必须有特定的宽高比还是完全不同宽高比？
* 在不同视口上呈现图像的时候，必须要考虑什么？

记下你的答案。它们不仅仅可以帮助您了解自己的图像 —— 它们的来源，技术要求等 —— 还可以让您在交付的时候，能够做出正确的选择。

### 图像传递时的临时策略

图像的传递已经从简单的 URL 添加到 `src` 属性转变到更加复杂的场景下了。在深入研究它们之前，让我们先谈谈用于呈现图像的多种选项，以便您在可以指定策略，选择在**何时**以及**如何**传递和渲染图像。

首先，需要确定图像的来源。这样可以对于部分因为不好分类或者来源不清而难以处理的图像来确定其处理方式，并且可以尽可能有效地处理图像。

通常，图像是属于以下两者之一的：

* **动态的**：动态图像是用户自己上传的，或者由系统中的其他事件生成。
* **静态的**：摄影师，设计师，或者您自己（开发人员）为网站创建的。

让我们深入研究一下针对每种类型的图像的策略。

#### 动态图像策略

静态图像非常容易使用。相较而言，动态图像比较棘手并且容易出现问题。可以通过什么方法来弱化他们的动态特性，并且使其像静态图像一样更加可控呢？有两个途径：**校验**和**智能裁剪**。

##### 校验

为用户制定一些对于图像的限制规则，来向用户说明我们可以接收什么类型的图像或者不能接收什么类型的图像。现在，我们可以验证图像的所有属性，也就是：

* 格式
* 图像占用空间的大小
* 尺寸
* 宽高比

**注意**：渲染尺寸是在渲染的过程中确定的，所以没有必要验证这一项。

在验证过后，我们可以得到一系列的可预测的图像，这些图像会变得更加易于使用。

##### 智能裁剪

处理动态图像的另外一种策略是智能地裁剪这些图像，来避免删除掉重要的内容，并且将图像的主要内容着重展示出来。这很难做到。但是，您可以利用开源的工具或者专门从事图像管理的 SaaS 公司提供的人工智能服务。下面是一个例子。

* * *

一旦为动态图像确定了策略，请创建一个包含图像的所有布局选项的规则表。以下是一个例子，这个例子非常值得分析，来帮你确定最重要的设备以及视口大小。

![](https://user-images.githubusercontent.com/26959437/55000964-93be5780-500e-11e9-9846-6253266db41e.png)

### 最（次）低限度

现在抛开响应式的复杂性，并且做我们最为擅长的事情 —— 使用 HTML 代码结合使用了最大宽度的 CSS。

下面的代码会渲染一些图片：

```
<main>
  <figure>
    <img src="https://res.cloudinary.com/...w700/ps4-slim.jpg" alt="PS4 Slim">
  </figure>
      
  <figure>
    <img src="https://res.cloudinary.com/...w700/x-box-one-s.jpg" alt="X Box One S">
  </figure>
      
  <!-- More images -->
    
  <figure>
    <img src="https://res.cloudinary.com/...w700/tv.jpg" alt="Tv">
  </figure>
</main>
```

**注意：**图像 URL 中的省略号指定了文件夹，图像的尺寸和裁剪策略，这些信息包含了太多细节，因此对于其进行了截断，让我们将关注点集中到重要的地方。上述代码完整的版本，可以参阅下面的 CodePen 示例。

这是网络上能够找到的最短示例，能够让图像变成响应式的：

```
/* The parent container */
main {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
}

img {
  max-width: 100%;
}
```

假如图像的宽度和高度是可变的，那么请将 `max-width` 替换为 `object-fit`，并且将属性值设为 `cover`。

![](https://css-tricks.com/wp-content/uploads/2019/02/s_FC2DE27452E05E045139FF003894009220F80784C1D613CC87FFB9D39C36AD83_1548841978428_Jan-30-201913-52-23.gif)

Jo Franchetti 的博客[使用 CSS Grid 的常见响应式布局](https://medium.com/samsung-internet-dev/common-responsive-layouts-with-css-grid-and-some-without-245a862f48df)中解释了 `grid-template-columns` 属性是如何使整个布局自适应（响应式）的。

可以参阅 [CodePen](https://codepen.io) 上，Chris Nwamba ([@codebeast](https://codepen.io/codebeast)) 的这段代码：[Grid 相册](https://codepen.io/codebeast/pen/vbXWEM/)。

然而，以上的内容并不是我们想要的，因为……

* 高端和低端设备的图像尺寸和大小相同，并且
* 我们可能会希望对于图像的宽度更加严格，而不是将其设置为 250，并且让其不断增大。

好吧，这部分只涵盖了“最低限度”，所以做到这样就够了。

### 布局变化

图像的布局发生变化的时候，最糟糕的事情就是图像的渲染发生垮塌。由于图像可能具有不同的尺寸（宽度和高度），因此我们需要指定如何去渲染图像。

我们应该智能地将所有图像裁剪成统一的尺寸吗？我们应该保留视口的宽高比，并且改变另外一个视口的比例吗？这应该由我们自己决定。

在网格布局中的图像，比如上述示例中的具有不同宽高比的图像，我们可以视觉适配（[art direction](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images#Art_direction)）方面的技术来渲染图像，视觉适配可以帮助我们来实现这样的目标：

![](https://css-tricks.com/wp-content/uploads/2019/03/planning-rwd-images.gif)

有关分辨率切换和响应式图像中的视觉适配，[请阅读 Jason Grigsby 的一系列文章](https://cloudfour.com/thinks/responsive-images-101-definitions/)。另外一个信息丰富的参考资料是 Eric Portis 的响应式图像指南，[第一部分](https://cloudinary.com/blog/responsive_images_guide_part_1_what_does_it_mean_for_an_image_to_be_responsive)，[第二部分](https://cloudinary.com/blog/responsive_images_guide_part_2_variable_image_resolution)，以及[第三部分](https://cloudinary.com/blog/responsive_images_guide_part_3_variable_image_encoding)。

让我们看一下下面的代码示例。

```
<main>
  <figure>
    <picture>
      <source media="(min-width: 900px)" srcset="https://res.cloudinary.com/.../c_fill,g_auto,h_1400,w_700/camera-lens.jpg">
      
      <img src="https://res.cloudinary.com/.../c_fill,g_auto,h_700,w_700/camera-lens.jpg" alt="Camera lens">
    </picture>
  </figure>
  
  <figure>
    <picture>
      <source media="(min-width: 700px)" srcset="https://res.cloudinary.com/.../c_fill,g_auto,h_1000,w_1000/ps4-pro.jpg"></source>
    </picture>
    <img src="https://res.cloudinary.com/.../c_fill,g_auto,h_700,w_700/ps4-pro.jpg" alt="PS4 Pro">
  </figure>
</main>
```

我们仅在视口宽度超过 700 px 的时候，渲染 700 px x 700 px 的图像，而不是简单的渲染 700 px 宽度的图像。如果视口较大，则会进行下面的渲染：

* 相机镜头的图像会被渲染为 700 px 宽、1000 px 高的图像（700 px x 1000 px）。
* PS4 Pro 的图像会被渲染为 1000 px x 1000 px。

### 视觉适配

通过裁剪图像使其变成响应式，我们可能会在无意之中裁减掉图像中的重要内容，例如主体的面部。如前所述，AI 开源工具可以辅助智能裁剪，并且重新聚焦于图像中的主要对象。此外，[Nadav Soferman 关于智能裁剪的文章](https://cloudinary.com/blog/introducing_smart_cropping_intelligent_quality_selection_and_automated_responsive_images)是非常有用的入门指南。

#### 严格的网格和跨度

本文中关于响应式图像的第一个例子是比较灵活的。在宽度至少有 300 px 的情况下，网格项会根据视口宽度自动适配，这样很不错。

另一方面，我们可能希望根据设计规范对网格项使用更加严格的规则。在这种情况下，媒体查询就会排上用场了。

或者，我们可以利用 `grid-span` 功能创建不同宽度和长度的网格项。

```
@media(min-width: 700px) {
  main {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
  }
}

@media(min-width: 900px) {
  main {
    display: grid;
    grid-template-columns: repeat(3, 1fr)
  }
  figure:nth-child(3) {
    grid-row: span 2;
  }
  figure:nth-child(4) {
    grid-column: span 2;
    grid-row: span 2;
  }
}
```

对于宽视口中 1000 px x 1000 px 的正方形图像，我们可以让其在行和列上分别跨越两个网格单元。在更宽的视口上，更改为纵向（700 px x 1000 px）的图像，使其跨越两行。

可以参阅 [CodePen](https://codepen.io) 上，Chris Nwamba ([@codebeast](https://codepen.io/codebeast)) 的这段代码：[网格相册 [视觉适配]](https://codepen.io/codebeast/pen/exdMjj/)。

### 渐进式优化

盲目的优化与没有优化一样蹩脚。如果没有事先的衡量，请不要专注于优化。如果优化没有数据的支持，请不要进行优化。

尽管如此，在上述的示例中，有足够的空间允许你去优化。我们从最低限度开始，向您展示了一些蛮酷的技巧，现在我们有了一个可以正常工作的响应式网格布局。接下来的问题是，“如果页面包含 20 - 100 个图像，那么用户体验会是什么样的呢？”

答案是这样的：我们必须要保证在进行大量图像渲染的时候，图像的大小适合于渲染它们的设备。为此，我们需要指定多个图像的 URL，而不是一个。浏览器将根据判断标准选择正确（最优）的一个。该技术在响应式图像中称为**分辨率切换**。我们可以关注下面的这个代码示例：

```
<img 
  srcset="https://res.cloudinary.com/.../h_300,w_300/v1548054527/ps4.jpg 300w,
          https://res.cloudinary.com/.../h_700,w_700/v1548054527/ps4.jpg 700w,
          https://res.cloudinary.com/.../h_1000,w_1000/v1548054527/ps4.jpg 1000w"
             
  sizes="(max-width: 700px) 100vw, (max-width: 900px) 50vw, 33vw"
  src="https://res.cloudinary.com/.../h_700,w_700/v1548054527/ps4.jpg 700w"
  alt="PS4 Slim">
```

Harry Roberts 的推文直观地解释了会发生什么（译者注：考虑到没有科学上网的小伙伴，相关 tweet 会整理到附录中）：

> 我发现（到目前为止）提取/解释 `srcset` 和 `sizes` 的最简单的方法是：[pic.twitter.com/I6YW0AqKfM](https://t.co/I6YW0AqKfM)（译者注：图片见底部[附录 A](附录-A)）
>
> — Harry Roberts (@csswizardry) [March 1, 2017](https://twitter.com/csswizardry/status/836960832789565440?ref_src=twsrc%5Etfw)

当我第一次尝试分辨率切换的时候，我感到了困惑，并且发了下面的推文：

> 我知道 img 标签的 srcset 属性中的宽度描述符表示图像的源宽度（原始文件宽度）。
> 
> 我不知道的是，为什么需要这个属性？浏览器根据这个值做了什么？ cc [@grigs](https://twitter.com/grigs?ref_src=twsrc%5Etfw) 🤓
> 
> — Christian Nwamba (@codebeast) [October 5, 2018](https://twitter.com/codebeast/status/1048216018315829250?ref_src=twsrc%5Etfw)

向 Jason Grigsby 在回复中的解释致敬（译者注：Jason Grigsby 的回复见底部[附录 B](#附录-B)）。

由于分辨率的切换，如果调整浏览器大小，则会针对对应的视口大小，下载对应大小的图像；因此小型手机会下载小图像（这样对于 CPU 和 RAM 来说都很好），而大型视口则会下载较大的图像。

![](https://css-tricks.com/wp-content/uploads/2019/02/s_FC2DE27452E05E045139FF003894009220F80784C1D613CC87FFB9D39C36AD83_1548841685176_Screenshot2019-01-30at1.46.40PM.png)

上表中显示浏览器下载了具有不同磁盘大小（红色框）的相同图像（蓝色框）。

可以参阅 [CodePen](https://codepen.io) 上，Chris Nwamba ([@codebeast](https://codepen.io/codebeast)) 的这段代码：[网格相册 [优化]](https://codepen.io/codebeast/pen/wNodJR/)。

Cloudinary 的开源、免费的[响应式图像断点生成器](https://www.responsivebreakpoints.com/)可以将网站的图像调整为多种屏幕尺寸。但是，在许多情况下，单独设置 `srcset` 和 `sizes` 就足够了。

### 结论

本文旨在提供一种简单并且有效的指导原则，以便从多种可用的选项设置中，找到可以进行响应式图像布局的属性。熟悉 CSS 网格，视觉适配和分辨率切换三种方法，你将在短暂的时间内，成为一名高手。请保持练习。

### 附录

#### 附录 A

下图为 @Harry Roberts 对于 `srcset` 和 `sizes` 属性的解释。

![对于 srcset 和 sizes 属性的解释](https://p1.music.126.net/tPePXHOoLfzqt_pvCadCAQ==/109951163958080282.jpg)

#### 附录 B

下面是 Jason Grigsby 对于作者 twitter 的回复内容，原回复请看文中给到的相关链接。

> 我认为是这样的，图片的宽度描述符是一个浏览器可以选择的数组。
> 你不是在告诉浏览器去选择什么，而是在告诉浏览器选项是什么。

> 它就像货架上面的一堆产品。你要把消费者选择产品时会用到的特征列出来。
> 在这种情况下，消费者是浏览器，它需要知道的特征是图像的宽度。

> 所以 srcset 不是规定性的，我们只是提供一系列选项。浏览器是如何在图像之间选择的呢？
> 这就是 sizes 属性的来源。它允许浏览器根据当前的视口计算页面上图像框的大小。

> 我们可以这样想象，当浏览器站在一堆图像前，使用 `sizes` 属性计算图像在页面中的大小，然后可能会考虑网络速度以及其他因素，然后说：“我将会选择第二张图片，非常感谢。”
>
> - Jason Grigsby

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
