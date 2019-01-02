>* 原文链接 : [用户界面中的排版](https://viljamis.com/2016/typography-for-user-interfaces/)
* 原文作者 : [Viljami Salminen](https://viljamis.com/about/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [circlelove](https://github.com/circlelove)
* 校对者:[ruixi](https://github.com/ruixi)，[wild-flame](https://github.com/wild-flame)

# 用户界面中的字体

回想2004年，在我刚入行的时候，[sIFR](http://mikeindustries.com/blog/archive/2004/08/sifr) 是最火的东西。它是由[Shaun Inman](http://shauninman.com/pendium/)公司开发的，其自定义字体嵌入在一个小小的 flash 动画里，它可以用在一些 JavaScript 和 CSS 中。那时候，它基本上就是[Firefox](https://www.mozilla.org/en-US/firefox/new/) 或 [Safari](http://www.apple.com/safari/)浏览器自定义字体的唯一选择。事实上，随着 iPhone （不支持 Flash ）的发布，该技术对于 Flash 的依赖使它很快就过时了。

> 编辑代码写我们的界面，文本界面和排版布局是我们主要的要求对象。

2008年，各大浏览器终于开始支持新的 CSS3 [@font-face rule](https://www.w3.org/TR/css-fonts-3/)。 它早就在1998年的 CSS 规范中出现了，但是后来被单独拉了出来。我记得当我设法说服我们的一位客户使用新的@字体-表情以及依赖[progressive enhancement](https://en.wikipedia.org/wiki/Progressive_enhancement) 为已经支持该功能的浏览器提供强化体验时候的兴奋。

从我在这个行业以来，我已经逐渐开始喜欢类型和进入设置它的所有细节。在这篇文章中，我要分享一些我学到的基础知识，并希望帮助您更好地为用户界面设置类型。



##第一个 GUI [#](https://viljamis.com/2016/typography-for-user-interfaces/#the-first-guis "右键来复制链接到#第一个GUIs")


尽管排版的历史可以追溯到大概[五千多年](https://viljamis.com/2013/prototyping-responsive-typography/)，我们的图形用户界面只有四十年的发展。一个关键转折点在1973年，当 [Xerox](https://en.wikipedia.org/wiki/Xerox) 引入了 [Alto](https://en.wikipedia.org/wiki/Xerox_Alto)，它从本质上创建了我们现代图形用户界面的基础。_Alto_ 比其他 GUI 早十年踏入市场，被视为计算机的未来。


![](http://ac-Myg6wSTV.clouddn.com/f8a8eab03c083c011ef2.png)

80年代早期开发的_Alto_  进展为 [Xerox Star](https://en.wikipedia.org/wiki/Xerox_Star) 成为首个带有 GUI 的商业化操作系统。

![](http://ac-Myg6wSTV.clouddn.com/05e7c24bffd97ab16471.png)

尽管_Alto_ 和 _Star_ 都没有实现突破，它们对于未来出现的[苹果(http://www.apple.com/) 和 [微软](https://www.microsoft.com/en-us/) 变革性的鼠标驱动  GUI 影响巨大。几年之后，在1984年，[Steve Jobs](https://en.wikipedia.org/wiki/Steve_Jobs) 带来了第一个 [Mac OS](https://www.youtube.com/watch?v=VtvjbmoDx-I).

![](http://ac-Myg6wSTV.clouddn.com/9172afe82db3c54f6e84.gif)

Macintosh 的发布意味着用户排版对于大众来说有史以来第一次变得触手可及。[初代Mac](https://en.wikipedia.org/wiki/Macintosh_128K)预装了很多 [图标字体](https://en.wikipedia.org/wiki/Fonts_on_Macintosh)，在接下来几年里面，许多字体工厂开始设计发行他们的数字版本的流行字体。

![](http://ac-Myg6wSTV.clouddn.com/7f17f13d792c5b467d6a.gif)

更细致地检查早期的图形用户界面，我们意识到它们多数的元素是书面语。这些 GUIs 是彻底的纯文本 ——— 独立词组的罗列集合。


我们也可以对现代的界面进行一个类似的调查。编辑代码写我们的界面，文本界面和排版布局是我们主要的要求对象

## 文本即界面[#](https://viljamis.com/2016/typography-for-user-interfaces/#text-is-interface "右键复制链接#text-is-interface")[#]

界面的每个字词都十分重要。好的书写造就好的设计。文本是核心的[界面](http://thomasbyttebier.be/blog/the-best-ui-typeface-goes-unnoticed)，是我们这些设计文案的设计师造就了这种信息。

看看下面的图像案例，想象着在你前面的桌子上分解元素。观察剩下了什么。几个单词，两个图片和几个图表的集合。

![](http://ac-Myg6wSTV.clouddn.com/304f7794e6e2220121f3.jpg)

我们的工作不是把屏幕上杂乱无章的东西让它们看起来可心，而是从最重要的[复制和内容](https://viljamis.com/2013/prototyping-responsive-typography/)开始，再从中绘制细节。那是我们草图的核心所在。

字形的清晰也十分关键。开始可能感觉它没那么重要，尤其是在我们的大脑只需要稍微楞个神来辨认字形的时候。但是复杂情况下，出现各种字母组合的时候，排版的重要性就体现出来了。

当然，还有更多的界面设计细节需要注意；例如平衡，布局，层次和结构.，但良好的文案和排版
 [的重要性占95%](https://ia.net/know-how/the-web-is-all-about-typography-period).

> "伟大的设计师知道如何用文本而不是内容工作，他将文本视作用户界面."


> 
> – Oliver Reichenstein

## 怎样阅读[#](https://viljamis.com/2016/typography-for-user-interfaces/#how-we-read "Right click to copy a link to #how-we-read")


如果我们放在屏幕上的文字如此重要，那么我们应该花些时间研究我们如何阅读以及它如何影响我们的设计。

> 
> 少于20字的单词读起来比小单词组成的长句子更慢

一个重要的发现让我回归的就是阅读_Billy Whited’s_ 文章 [为用户界面设置书写](http://blog.typekit.com/2013/03/28/setting-type-for-user-interfaces/), 我们这样阅读是否是最高效的。这意味着单个单词少于20字的单词读起来比小单词组成的长句子更慢



事实上，当我们阅读长句子的时候，眼睛扫过的地方并不是以一种光滑的路线走的。相反，它们会跳跃，这称作
![扫视](https://viljamis.com/type-for-ui/img/saccades.svg)


扫视提高我们的阅读能力让我们完全跳过少量意义不大的词语。这是要注意的一个关键因素，因为我们的界面大部分含有独立的词语。本质上讲，我们根本无法依赖扫视。


最后，[理解](http://researchonline.rca.ac.uk/957/1/Sofie_Beier_Typeface_Legibility_2009.pdf) 确定了独立单词在阅读过程中的最重要的地位，我们的字体选择如何重要就显而易见了。
![](https://viljamis.com/type-for-ui/img/bouma.svg)


过去，许多人认为我们通过所谓的[Bouma shape](https://en.wikipedia.org/wiki/Bouma)理解词语意思，或者词语的外形。[在](http://blog.typekit.com/2013/03/28/setting-type-for-user-interfaces/) [后来](http://www.microsoft.com/typography/ctfonts/wordrecognition.aspx) [研究](https://typography.guru/journal/how-do-we-read-words-and-how-should-we-set-them-r19/) [这](http://researchonline.rca.ac.uk/957/1/Sofie_Beier_Typeface_Legibility_2009.pdf) 被证明是有错误的，可读性和字体的易读性不应该仅仅通过生成好的 Bouma shape 来判定。想法，我们要更多地关注字体形式。

## 字母的可读性来自什么?[#](https://viljamis.com/2016/typography-for-user-interfaces/#what-makes-letters-legible "Right click to copy a link to #what-makes-letters-legible")

乍一看似乎这个问题很难或者根本无法回答。因为阅读是一种习惯，读的最多的东西读得好。那我们如何衡量怎样的特征使字母更易读呢？为了开始理解这个，我们首先需要把句子破成词组，词组破成字母，字母破成更小的我们能注意到的细节部分。


2008年， [维多利亚大学](http://www.uvic.ca/) did [empirical tests](https://typekit.files.wordpress.com/2013/03/fiset_psychscience_2008.pdf) 心理系解释了小写字母和大写拉丁字母是阅读最高效的部分。

![](http://ac-Myg6wSTV.clouddn.com/11c589fd7d99f3b411e5.jpg)

该研究解释了不少有意思的东西。首先，它说明了线条端点是确认字母极为重要的部分。
![](http://ac-Myg6wSTV.clouddn.com/38e3c405a7cc17950e30.jpg)


上面的图表示认知字母的时候那些区域关注度最高。这些字体的这些部分应该做的既普通又能强调字母的区分度。

2010年 [Sofie Beier](https://www.researchgate.net/profile/Sofie_Beier/publications) 和 [Kevin Larson](http://www.typecon.com/speakers/kevin-larson),[另一项研究](http://www.ingentaconnect.com/content/jbp/idj/2010/00000018/00000002/art00004),关注的是字母被误认的变化和频率。

![](http://ac-Myg6wSTV.clouddn.com/3f1d105d8753dc2a3b46.jpg)


研究发现一些衍生版本比其他的更易读，尽管字体里面带有类似的大小、高度和个性化。结果显示较窄的字母稍宽一些更容易被接受，[ x -字高](https://en.wikipedia.org/wiki/X-height) 有了 [升部](https://en.wikipedia.org/wiki/Ascender_%28typography%29) 比 [降部](http://www.typographydeconstructed.com/descender/)更容易辨识。

![](http://ac-Myg6wSTV.clouddn.com/d8a68ba28736039ee717.jpg)](http://legibilityapp.com/)

利用近期项目中[我构建的工具](http://legibilityapp.com/)我们可以了解到更多关于给定字体易读性的信息。[Legibility App](http://legibilityapp.com/) 让你可以通过引入各种滤镜模拟不同的 _(often harsh)_ 视图状况--例如 模糊、滤镜、像素画化。这个 app 还处在测试版，今后将用在Chrome](https://www.google.com/chrome/browser/desktop/), [Opera](http://www.opera.com/) 和 [Safari](http://www.apple.com/safari/)上.

## 在 UI 界面找什么?[#](https://viljamis.com/2016/typography-for-user-interfaces/#what-to-look-for-in-a-nbsp-ui-typeface "Right click to copy a link to #what-to-look-for-in-a-nbsp-ui-typeface")


理解了我们的阅读方式和字母易读的特征使我们对于选择合适的 UI 界面有了一个整体的了解。下面是我收集的10点建议。

### 1\. 易读性[#](https://viljamis.com/2016/typography-for-user-interfaces/#1-legibility "Right click to copy a link to #1-legibility")

易读性是要考虑的首要因素。字母形式要清晰可辨。可辨的字母形式在用户界面元素中效果更好。<sup>[[5](https://prowebtype.com/picking-ui-type/)]</sup> 许多[无衬线字体](https://en.wikipedia.org/wiki/Sans-serif) 包括 [Helvetica](https://en.wikipedia.org/wiki/Helvetica), 其大写的I和小写的l无法分辨，使得它们不适合作为用户界面。
![](https://viljamis.com/type-for-ui/img/legibility.svg)。

[Source Sans Pro](https://github.com/adobe-fonts/source-sans-pro)字体 在左，Helvetica 字体在右。Helvetica 字体的前三个字母几乎无法辨认。Source Sans Pro 字体就显得相当不错。有些人认为 Helvetica在任何的 UI 作字体都糟透了，因为它不是为了屏幕而设计的。


> Helvetica 糟透了。它不是为了屏幕上的小字设计的. 像 ‘milliliter’就很难辨认.”
> 
> – Erik Spiekermann


当苹果 "短促地" 改用 Helvetica 作为他们主要的界面字体的时候，导致了相当的易用和易读性讨论。最后，这也是苹果设计我们熟知的[San Francisco](https://developer.apple.com/fonts/)字体的原因。


![](http://ac-Myg6wSTV.clouddn.com/50141b85472e3156ca89.png) <span class="desc">图片来源: [Thomas Byttebier](http://thomasbyttebier.be/blog/the-best-ui-typeface-goes-unnoticed)</span>

### 2\. 朴素[#](https://viljamis.com/2016/typography-for-user-interfaces/#2-modesty "Right click to copy a link to #2-modesty")

理想的 UI 界面并不扎眼，甚至不起眼。当用户完成他们的任务的时候，你选择的字体应该在他们的考虑之外，只让用户关注到文字的内容而无需费力辨认字体。

![](https://viljamis.com/type-for-ui/img/modesty.svg)

### 3\. 灵活性[#](https://viljamis.com/2016/typography-for-user-interfaces/#3-flexibility "Right click to copy a link to #3-flexibility")

一个 UI 字体需要有灵活性.我们为媒介设计体验,不可能控制用户的能力、内容、浏览器、屏幕尺寸、链接速度甚至输入法。


我们选择的字体应该适应相当多的语境，在不同尺寸、设备中运行良好，尤其是小屏幕的状态下。无衬线字体的设计就是为了小尺寸解决方案被引用了<sup>[[5](https://prowebtype.com/picking-ui-type/)]</sup>。

![](https://viljamis.com/type-for-ui/img/flexibility3.svg)

### 4\. 大 x-height[#](https://viljamis.com/2016/typography-for-user-interfaces/#4-large-x-height "Right click to copy a link to #4-large-x-height")

X-height 意思是小写字母 “x” 的高度。你想看大号字体 [x-height](https://en.wikipedia.org/wiki/X-height) 因为读起来比小写的更加舒服。不过别走太远，因为太大的 x-height 下，字母 _n_ and _h_ 就难以区分了 

![](https://viljamis.com/type-for-ui/img/x-height.svg)

### 5\.宽比例[#](https://viljamis.com/2016/typography-for-user-interfaces/#5-wide-proportions "Right click to copy a link to #5-wide-proportions")


比例指的是字符的宽高比。你想要找到较宽比例的字体，因为它的易读性好，适合屏幕上的小字阅读。

![](https://viljamis.com/type-for-ui/img/proportions.svg)<span class="desc">图片来源: [Adobe Acumin](http://acumin.typekit.com/design/)</span>

### 6\.松散字母间距 [#](https://viljamis.com/2016/typography-for-user-interfaces/#6-loose-letter-spacing "Right click to copy a link to #6-loose-letter-spacing")

> 重要原则就是字母的间距要比字体当中字母内间距小一些。

字母的间距是十分重要的空间。字母靠得太近影响阅读。一个好的 UI 字体应该在两个字母当中留下喘息的空间，也是为了创造一个平稳的节奏。


另一方面，如果你留下太多空间，就会破坏单词的完整性。重要原则就是字母的间距要比字体当中字母内间距小一些。
![](https://viljamis.com/type-for-ui/img/spacing.svg)

### 7\. 小的笔画对比[#](https://viljamis.com/2016/typography-for-user-interfaces/#7-low-stroke-contrast "Right click to copy a link to #7-low-stroke-contrast")

好的 UI 字体笔画对比较小。高对比的字体，在字号较大的时候看起来不错，可是对于屏幕上的小字来说，细笔画就容易消失了。另一方面，我们有[Arial](https://en.wikipedia.org/wiki/Arial) 还有[Helvetica](https://en.wikipedia.org/wiki/Helvetica)的字体，相当小的笔画对比让字母辨析变得困难。


一些都是为了寻找二者平衡。想像你在地平线上，你想找些更多的东西。

![](https://viljamis.com/type-for-ui/img/contrast.svg)

### 8\. 字体特征[#](https://viljamis.com/2016/typography-for-user-interfaces/#8-opentype-features "Right click to copy a link to #8-opentype-features")

确认你选定字体支持[OpenType 特征](https://typofonderie.com/font-support/opentype-features/) 是非常重要的，因为它提供了更多的灵活性。通常包括对不同语言和 [特殊字符](https://en.wikipedia.org/wiki/List_of_Unicode_characters)的支持。


对我而言，最有用的 Opentype 字体特征是[tabular figures](https://www.fonts.com/content/learning/fontology/level-3/numbers/proportional-vs-tabular-figures)，它是数字的，带有相同的宽度。或许做计时器的时候你会想要用到它，或者做 IP 显示表盘的时候用用会不错。

![](http://ac-Myg6wSTV.clouddn.com/4d4aaafae8af043b335e.png) <span class="desc">

图片来源: [Fontblog](http://www.fontblog.de/das-ende-der-postscript-type-1-schriften/)</span>

### 9\. 备用字体[#](https://viljamis.com/2016/typography-for-user-interfaces/#9-fallback-fonts "Right click to copy a link to #9-fallback-fonts")

下面是一种大家都非常熟悉的场景。在实际内容下载显示完全之前，[web 字体](https://en.wikipedia.org/wiki/Web_typography) 阻碍了这个过程。

![](http://ac-Myg6wSTV.clouddn.com/c78ea12592cc07fdc519.png) <span class="desc">
图片来源: [Filament Group](https://www.filamentgroup.com/lab/weight-wait.html)</span>

通过在无障碍的方式下载字体，这可以轻松地调节，大幅度消减了内容加载时间。缺点是自定义字体加载的时候，我们需要从 [默认系统字体](http://www.granneman.com/webdev/coding/css/fonts-and-formatting/default-fonts/)中定义备用字体。


![](http://ac-Myg6wSTV.clouddn.com/7351c4f5beff01c1bb7a.png) 

<span class="desc">图片来源: [Filament Group](https://www.filamentgroup.com/lab/weight-wait.html)</span>

### 10\. 字体微调[#](https://viljamis.com/2016/typography-for-user-interfaces/#10-hinting "Right click to copy a link to #10-hinting")


字体微调是字体适应屏幕可读的最大化的一个过程。 [Hinting](https://en.wikipedia.org/wiki/Font_hinting) 
尝试通过提供一系列不同尺寸下的指南使得向量曲线更好地适应像素网格。对于低分辨率屏幕实现清晰易读来说至关重要。

微调最初是苹果公司创造的，但是自从 [TrueType font format](https://en.wikipedia.org/wiki/TrueType)这种被称作“微调”的淡出，我目前认为你只有在支持[IE8](https://en.wikipedia.org/wiki/Internet_Explorer_8) 或需要 [TTF](https://viljamis.com/2016/typography-for-user-interfaces/%28https://en.wikipedia.org/wiki/TrueType%29) 或[EOT format](https://en.wikipedia.org/wiki/Embedded_OpenType)的更低版本浏览器的时候会用到。

![](http://ac-Myg6wSTV.clouddn.com/88f0ad59f7eab23c41fc.jpg) <span class="desc">图片来源: [Typotheque](https://www.typotheque.com/articles/hinting)</span>

## 前景[#](https://viljamis.com/2016/typography-for-user-interfaces/# "Right click to copy a link to #")

对我们来说这是一个相对较短的旅程，我期待看到 web 字体的行为、[typographic tools](https://typecast.com/) 成熟化、以及 [font formats](https://en.wikipedia.org/wiki/Category:Font_formats) 个性和我们对于字体的使用方面有更多的进展，

> 归根结底，好的字体能给每个人带来生产力，它甚至可以 [拯救你](https://www.propublica.org/article/how-typography-can-save-your-life).

我想象这我们可以看到更多的[革新](https://en.wikipedia.org/wiki/Progressive_enhancement) 体验，文字本身的意义比我们所建议的字体设置更为重要<sup>[[6](http://nicewebtype.com/)]</sup>。它本质上是事物如何在 web 上运行，但我们才刚刚开始认真对待这个事情。

理想的排版，我们同样需要尽可能多地了解用户的阅读界面。这似乎是理所当然的，但并非如此<sup>[[7](http://alistapart.com/column/responsive-typography-is-a-physical-discipline)]</sup> 。今后的字体对于周边的了解会使它开始对其他因素做出响应，例如 [视窗](https://en.wikipedia.org/wiki/Viewport)、[分辨率](https://en.wikipedia.org/wiki/Display_resolution)、[类渲染引擎](http://typerendering.com/) used、 [背景光线](https://developer.mozilla.org/en-US/docs/Web/API/Ambient_Light_Events)、[屏幕亮度](https://en.wikipedia.org/wiki/Lumen_%28unit%29) 甚至是 [视物距离](http://webdesign.maratz.com/lab/responsivetypography/)。

我还预测到字体的易读性调整会最终和[系统辅助功能选项](http://www.apple.com/accessibility/ios/)想联系，字体就可以自动适应不同用户的需要。

总之，我预见 UI 排版的未来就是一切传感器和字体格式可以对已知数据进行相应，最终是有情境认知、对我们的工作流集成了更多的智能算法的[新的排版工具](http://www.jon.gold/2016/05/robot-design-school/) 。

所有的一切就是我们可以配合字体对处理的上下文进行更好的响应。

![](http://ac-Myg6wSTV.clouddn.com/80d9d0e3f6fc41bfbe05.jpg) <span class="desc">图片来源: [Luke Wroblewski](https://www.flickr.com/photos/lukew/10430507184/in/photostream/)</span>

为了减少工作……
![](http://ac-Myg6wSTV.clouddn.com/22b56fb16d9a52e6a0fb.jpg) <span class="desc">

图片来源: [Samsung GearVR](http://www.samsung.com/us/explore/gear-vr/)</span>

…让我们的界面更快捷…
![](http://ac-Myg6wSTV.clouddn.com/0dc8c285f6f0f0a33bf9.jpg) <span class="desc">

图片来源: [MozVR](https://mozvr.com/)</span>

…更方便…

![](http://ac-Myg6wSTV.clouddn.com/163c2a0f3290257250e5.jpg)<span class="desc">

图片来源: [Callan & Co](http://kallan.co/)</span>

…最终更易读、高效…

![](http://ac-Myg6wSTV.clouddn.com/452d1e7bcde24b7e1cc8.jpg)<span class="desc">

图片来源: [Microsoft Hololens](https://www.microsoft.com/microsoft-hololens/en-us)</span>

…因为本质上讲，好的排版是为了方便人们的，他甚至可以 [拯救你的人生](https://www.propublica.org/article/how-typography-can-save-your-life).<span title="Made with love by @viljamis" class="fleuron"> ❦</span>

**这篇文章大体上是基于我在一帕洛阿尔托个内部的设计研讨会 [Idean](http://www.idean.com/) 的内容,[可以查看幻灯片](https://viljamis.com/type-for-ui/).**
[](https://twitter.com/intent/tweet?text=Typography+for+User%C2%A0Interfaces&url=http://viljamis.com/2016/typography-for-user-interfaces/&via=viljamis)

