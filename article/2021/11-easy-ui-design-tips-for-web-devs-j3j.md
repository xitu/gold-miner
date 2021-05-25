> * 原文地址：[11 Easy UI Design Tips for Web Devs](https://dev.to/doabledanny/11-easy-ui-design-tips-for-web-devs-j3j)
> * 原文作者：[Danny Adams](https://dev.to/doabledanny)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/11-easy-ui-design-tips-for-web-devs-j3j.md](https://github.com/xitu/gold-miner/blob/master/article/2021/11-easy-ui-design-tips-for-web-devs-j3j.md)
> * 译者：[5Reasons](https://github.com/5Reasons)
> * 校对者：[Kimhooo](https://github.com/Kimhooo)、[KimYangOfCat](https://github.com/KimYangOfCat)

![头图](https://res.cloudinary.com/practicaldev/image/fetch/s--xHif6hhs--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/b33yd1o2sxrm8wvfbm1b.jpg)

# 为 Web 开发同学准备的 11 个简单实用的 UI 设计小技巧

当开始学习 Web 开发时，我们大部分人都没有设计相关的经验，也没有可以依靠的 UI 设计师。因此，本文将分享 11 个简单实用的 UI 设计基础技巧，来帮助你的项目看起来更规整且时尚。

本文首发于原作者的个人博客 [DoableDanny.com](https://www.doabledanny.com/UI-Design-Tips-for-Web-Devs)。如果你觉得这篇文章写得不错，可以考虑关注原作者的 [Youtube 频道](https://www.youtube.com/channel/UC0URylW_U4i26wN231yRqvA)！

## 1. 保持风格一致

[![一致性的范例](https://res.cloudinary.com/practicaldev/image/fetch/s--JCUuNeJ5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/y94y3colvzfiih57bolk.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--JCUuNeJ5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/y94y3colvzfiih57bolk.png)

在上方的例子中，你会发现三个图标有着截然不同的风格和颜色：

* 日历图标由灰色和绿色的线条组成
* 锁的图标是由一个实心的橙色圆环为基础，中间加上一个白色的填充图案，没有什么线条轮廓
* 点赞图标则有一条较细的黑色轮廓，整体呈现出一种曲线感

这三个图标没有一个一致的主题 —— 它们的形状、颜色、尺寸和轮廓粗细都有所不同。

在例图的下半部分中，三个图标看起来有着一致的风格。它们都有简单的黑灰色轮廓，高度和宽度也保持了统一。

同时，在下半部分中，文本和图标都保持着向左对齐。当然，我也可以把它们调整为居中对齐。对齐的方式不是重点，关键的是一定要保持风格的一致性。

以我的经验来说，当我们需要展示博客这一类的长文本时，最好向左对齐，这能让文本更易于阅读。当处理较短的内容时，向左对齐或居中对齐都是不错的选择。

## 2. 使用高质量的图像

[![贴画 vs 优质的图片](https://res.cloudinary.com/practicaldev/image/fetch/s--h5JqDvUv--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vfdpbqclz1qgfhqin020.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--h5JqDvUv--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vfdpbqclz1qgfhqin020.png)

对于十来岁的小家伙来说，使用例图中上半部分这样的贴画可能是很棒的，但是使用这样的素材会让网站显得特别不专业。

你可以从 [https://www.unsplash.com](https://www.unsplash.com) 免费下载专业、优质的图像用于你的项目中。

## 3. 注重反差、对比

[![让背景图片上的文字变得更易阅读](https://res.cloudinary.com/practicaldev/image/fetch/s--4Qo6ujyj--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/heicl1riiwipqchivyw6.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--4Qo6ujyj--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/heicl1riiwipqchivyw6.png)

如果背景是浅色的，我们应该使用深色的字体。反之，在深色的背景上则应使用浅色的字体。这是个简单易懂的道理。我在浏览网页时最常发现的问题就是，有些网页开发者使用花里胡哨的图片作为背景，然后把文字放在这种晃眼的背景上，这会让网站的内容非常难以阅读。

解决方案：

1. 使用图像叠加。例如，如果你使用的是浅色文本，在背景图像上叠加一层深色（使用rgba的半透明div背景色），并降低不透明度，这样能让图像的外观变暗，从而使浅色的文本更清晰。记得给文本一个比图像叠加更高的 z-index，让文字位于顶部!
2. 选择例子中这类的背景图片。图片中应该有一片颜色较为统一的部分来展示文字信息。

除此之外，例图中还有一个值得关注的的点。导航栏中的 logo、网页左侧的正文部分以及“start my journey”按钮在竖直方向上保持了左侧对齐。这也是一种设计上的一致性，这些细节是让你的网页变得井然有序的关键。

## 4. 妙用留白

[![丑陋的留白 vs 好看的留白](https://res.cloudinary.com/practicaldev/image/fetch/s--jb9nZWm2--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/iwg0sh21rcw44tboskgk.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--jb9nZWm2--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/iwg0sh21rcw44tboskgk.jpg)

在例图上半部分，“SomeCompany” logo 与页面顶端的空隙明显没有和导航栏右侧的文字保持一致。而在例图下半部分中，两者与上半部分的空隙是一样的。

上图中，正文和标题、按钮的距离都太近了，看起来非常的局促。而下图在同样的部分留出了一些空隙，看起来好多了。

在下图中，我们还可以看到，相较于标题和 logo 之间的距离，标题离正文是更近的。密切相关的部分应该离得更近一些，来表明这种相关性。当然，也不能像上图的错误范例那样离得太近了。

## 5. 用字体大小营造视觉层次

你的眼中可能会被上一张例图中的“The Road Less Travlled”所吸引。显然，这是因为它的字体较大而且轮廓突出。同样的，颜色也能够引人注目，例如上图中“start my journey”的按钮。

一个常见的错误是把导航栏的 logo 设置的过大了，或者把导航栏设置成过于显眼的颜色。

我们应该让读者的注意力集中于我们的内容，而非 logo 或者导航栏。

## 6. 最好使用同一个字体

[![好的字体 vs 坏的字体](https://res.cloudinary.com/practicaldev/image/fetch/s--SvQoT7fR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/io6mymdjufk8m11zwlr6.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--SvQoT7fR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/io6mymdjufk8m11zwlr6.png)

最好保持字体的一致性。我们不需要把字体设置的过于复杂。应该避免使用“Times New Roman”（太多人用它了）和“Comic Sans”（这个字体过于老气了）。

Nunito、Helvatica 或 Sans Serif 都是比较合适的现代字体。

当然了，如果你觉得自己的设计显得有些单调，也可以在标题上使用第二种字体（比如这篇博客的标题部分就是如此！）。

在字体大小方面，正文内容通常会选用 18 像素到 21 像素。

## 7. 色彩与阴影

[![改变文本的对比度](https://res.cloudinary.com/practicaldev/image/fetch/s--Kv7iUmyD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ehtbk36cscfa1nqm6yu7.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Kv7iUmyD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ehtbk36cscfa1nqm6yu7.png)

注意不要使用太多颜色。过多的色彩会让页面看起来杂乱且不专业，特别是当你对设计没有概念时。记住保持设计的简约。

选择一个颜色作为基调，然后使用调色（添加白色）或阴影（添加黑色）进行微调。

然后选择一种主要的“有激励性的”颜色来突出区域，并寻找“互补配色方案”。

我会使用 [coolors](https://coolors.co/330088) 来找到合适的颜色并且进行调色。

## 8. 圆角与锐角

[![聊天气泡](https://res.cloudinary.com/practicaldev/image/fetch/s--qyVtATCJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/o69k4gosugpsc0xtrhhv.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--qyVtATCJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/o69k4gosugpsc0xtrhhv.png)

锐角和突出的边缘可以吸引人们的注意力，上图聊天气泡中突出的尖角就是一个例子。

我们可以利用这个技巧做些什么呢？把按钮设为圆角。你应该让用户的注意力集中在按钮中心的内容上，而非按钮的四个角上。

## 9. 别再使用早已过时的边框了

[![有边框 vs 无边框](https://res.cloudinary.com/practicaldev/image/fetch/s--BwZtt2Qa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jtarukxei807yi5cij02.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--BwZtt2Qa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jtarukxei807yi5cij02.png)

在网页应用早期，边框几乎无处不在。而如今，最好不要过多的使用边框 —— 这会让网页变得更加清爽。边框在很多时候有些多余。

当然了，也不是说完全不能使用边框，它们在需要分割网页的不同内容时仍旧能起到作用。我想说的是，不要过多的使用边框，过于繁杂、抓眼的边框是不美观的。

## 10. 别在导航栏使用下划线

[![有下划线 vs 无下划线](https://res.cloudinary.com/practicaldev/image/fetch/s--DIBnjFhK--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/rv79dgu4btx374uwj412.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--DIBnjFhK--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/rv79dgu4btx374uwj412.png)

下换线实在是太老气了，没有下划线的页面显然更加简洁。

在鼠标悬浮、输入聚焦时加上下划线或者改变字体颜色、大小会是更好的做法。

为了识别超链接、便于用户跳转，对于正文中的链接，我们还是应该用下划线修饰。我想说的是，避免在没有超链接的文本上使用下划线。

## 11. 下载一个设计软件

我曾经在开始开发一个项目时苦恼于应该如何设计项目的样式。尝试不同的颜色、不断实验各种元素的位置，这些代码上的调整简直让我折寿了。

使用设计软件可以帮助你可以更快地迭代想法。我现在使用免费的 AdobeXD 来将元素拖放到合适的位置，快速的得到一个 UI 设计稿然后开始编写代码。Figma 也很流行，但它不是免费的。

## 我参考的优秀文章

* 心理学在优秀网页设计中的应用 [https://www.doabledanny.com/persuasive-web-design](https://www.doabledanny.com/persuasive-web-design)
* 化腐朽为神奇，重构一个糟透了的设计 [https://www.youtube.com/watch?v=0JCUH5daCCE&t=112s](https://www.youtube.com/watch?v=0JCUH5daCCE&t=112s)
* 震撼的 UI 技巧 [https://medium.com/refactoring-ui/7-practical-tips-for-cheating-at-design-40c736799886](https://medium.com/refactoring-ui/7-practical-tips-for-cheating-at-design-40c736799886)
* 优秀 UI 设计中的科学[https://www.youtube.com/watch?v=nx1tOOc_3fU](https://www.youtube.com/watch?v=nx1tOOc_3fU)

如果您喜欢这篇文章，可以通过订阅原作者的 [Youtube 频道](https://www.youtube.com/channel/UC0URylW_U4i26wN231yRqvA)或访问他的 [博客](https://www.doabledanny.com/blog/)来表示感谢，并且及时获取新的文章。

您也可以通过原作者的 [推特](https://twitter.com/DoableDanny)来联系他！

感谢您的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
