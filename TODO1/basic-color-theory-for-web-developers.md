> * 原文地址：[Basic Color Theory for Web Developers](https://dev.to/nzonnenberg/basic-color-theory-for-web-developers-15a0)
> * 原文作者：[Nicole Zonnenberg](https://dev.to/nzonnenberg)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/basic-color-theory-for-web-developers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/basic-color-theory-for-web-developers.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[Mcskiller](https://github.com/Mcskiller)，[kasheemlew](https://github.com/kasheemlew)

# Web 开发者需要了解的基础色彩理论

如果你上过艺术课，一定会发现基本上所有课堂墙上都挂了一个“色轮”。在课堂上，可能需要你混合各种颜色，画出你自己的作品。

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--OE8uCwmx--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/cgr160zn3evkbry9h3l7.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--OE8uCwmx--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/cgr160zn3evkbry9h3l7.png)

在小学美术课上应该讲过**一次色**（primary color，即三原色）与**二次色**（seondary color，间色），如果你在小学之后还上过美术课，应该还了解过**三次色**（tertiary color，副色）。

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--jDnCmgm0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/h1li6xy7lsolpx1pfd7y.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--jDnCmgm0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/h1li6xy7lsolpx1pfd7y.jpg)

不过如果你在高中或者更高层次的学校中学习过艺术，那你就会发现，色轮是展示[色彩理论](https://en.wikipedia.org/wiki/Color_theory)、练习混色以及研究色彩组合的最简单的方法。

## 何谓色彩理论？

**色彩理论简史**：爱德华·马奈（Édouard Manet）、埃德加·德加（Edgar Degas）、克洛德·莫奈（Claude Monet）等印象派的画家在抛弃写实，而开始尝试捕捉**光色**时，色彩理论就诞生了。

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--8liyegSH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/qg743mrylv8mon76b4z0.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--8liyegSH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/qg743mrylv8mon76b4z0.jpg)  

上图为莫奈的 Haystacks 系列画作

**简单来说**：色彩理论研究的是人的眼睛如何将光波转化为颜色。匹配或相似的色彩往往有着相似或互补的波。

因此可以将色彩理论归结为光波科学，来解释为什么可以看到各种颜色。不过在本文中，我们只专注于两个问题：

*   为什么有些颜色可以完美搭配？
*   我们该如何选择“正确”的颜色？

颜色的搭配问题有点像“与生俱来”的东西。不管怎样，在网页或者 App 里用纯绿色的背景是绝对让人无法忍受的！

下面我列了一个简表，当你遇到与色彩有关的问题时可以参考：

## Level 1：单色

**单色**就是单一的颜色，或者同种颜色的多个色调的组合。

> **在 Web 开发时**，你可以在[这个网页中](https://www.w3schools.com/colors/colors_picker.asp)选择并查询某种颜色的 Hex 代码，并且可以在不影响色调的情况下让颜色更亮或更暗。

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--T_AVlepc--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/48ktxlwm7qq095mkwuoa.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--T_AVlepc--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/48ktxlwm7qq095mkwuoa.jpg)

这就是最简单的网页配色方法。诸如 [Facebook](http://facebook.com)、[Twitter](http://twitter.com) 之类的网站大都是用的这种单色配色方案。黑色、白色、天蓝色组合而成的简单配色，让这些社交 App 更加简洁。

只有用户的头像、链接、照片有着不同的颜色，这些不同的颜色可以被用户识别，更好地找到他们感兴趣的帖子和账号。

如果 Twitter 的网页上还有其它的颜色，就会让区分帖子、发帖人变得困难。

一般来说，即使你需要多种颜色，也得有个主色，所谓背景或者标题的颜色。

> **专业建议**：如果你的网页要使用单色配色，请确保阴影可以清晰地将各个元素区分开了。否则用户在阅读文本或分离网页元素时将很不方便。

## Level 2：互补色

如果不想在配色中只用各种各样的“橙色”怎么办？如果你想让链接突出，但又不和导航栏或者背景色冲突怎么办？

如果我们遵循基本色彩理论，解决上述问题的方案就是去寻找**互补色**。

可以在色轮中一种颜色相对的位置找到它的**互补**色。

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--laijYZC7--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/3fj00kbhg6s8nqpm3ut9.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--laijYZC7--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/3fj00kbhg6s8nqpm3ut9.jpg)

每种**主色**都与一种**副色**作为互补色相对应。有种方法可以轻松记住颜色如何匹配：如果一种**副色**和一种**主色**匹配，那么**副色**的构成色一定不含**主色**。比如，红色的互补色是绿色，而绿色由蓝色和黄色组成。

> **专业建议**：一次只增加一种颜色，并保持页面简单。不要为了呈现一个完整的彩虹配色牺牲了你干净、好用的布局。不然，你可能会做出上世纪 90 年代流行的经典网站（比如[这个](https://spacejam.com/)）。

## 继续升级...

随着你的设计水平的提高，就能自如地挑战自己的极限了。配色并不是什么可怕的工作。你可以多多关注一些配色水平高的开发者（比如[他](https://www.alispit.tel/#/) ）和设计师。多问问自己喜欢什么配色、不喜欢什么配色、为什么，这样就能建立自己的品味与品牌。

## Web 开发者的色彩 Hack

试试自己手写一些 hex 代码、RBG 数字来尝试各种色彩的组合与混合。如果你是 SASS 的粉丝，可以把配好的颜色存储在文件中，日后在项目中导入。如果你的工作是构建页面结构而不是视觉设计（由客户或者产品经理决定），可以把这些颜色当做是占位符，让页面看起来更加明了。

请确保：

*   所有东西都是可读的。
*   链接、标题等你想要强调的东西应该与纯文本有所区别。
*   用户可以轻松地区分网页的不同部分（比如导航栏、主要内容、文章等）。

## 在线工具

*   [Palleton.com](http://paletton.com/)
*   [Coolors.co](https://coolors.co/)

[Doug R. Thomas, Esq.](https://dev.to/ferkungamaboobo) 强烈推荐以下网站：

*   [Color.Adobe.com](https://color.adobe.com/)
*   [WebAIM — 颜色对比度检查器](https://webaim.org/resources/contrastchecker/) - 确保文本在背景上的可读性。
*   [Coblis — 色盲模拟器](https://www.color-blindness.com/coblis-color-blindness-simulator/) - 用色盲滤镜来测试你的布局截图，以确保内容对所有受众都是可读的。

## 拓展阅读

希望在读完这篇文章后，你不再为给网站、网页、app 配色感到犯愁。如果你对这个主题感兴趣，强烈建议去了解[更多相关知识](https://www.colormatters.com/color-and-design/basic-color-theory)。本文只是浅显地进行了讲解，你可以读[这篇文章](https://99designs.com/blog/tips/the-7-step-guide-to-understanding-color-theory/)了解更多关于色调和阴影的知识。

最后我想说，在你给自己的项目进行配色时，并不存在”错误答案“。许多人认为品味是天生就有的，正是它帮助你寻找美妙的设计、带来灵感、尝试各种组合，最终为你和你的品牌找到最适合方案。祝你好运！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
