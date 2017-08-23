
  > * 原文地址：[Web fonts: when you need them, when you don’t](https://hackernoon.com/web-fonts-when-you-need-them-when-you-dont-a3b4b39fe0ae)
  > * 原文作者：[David Gilbertson](https://hackernoon.com/@david.gilbertson)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/web-fonts-when-you-need-them-when-you-dont.md](https://github.com/xitu/gold-miner/blob/master/TODO/web-fonts-when-you-need-them-when-you-dont.md)
  > * 译者：[undead25](https://github.com/undead25)
  > * 校对者：

  # 网络字体：什么时候需要，什么时候不需要

  ![](https://cdn-images-1.medium.com/max/2000/1*Y4_EhogCnZQyALLuvQLDKQ.jpeg)

图片来源于 [Unsplash](https://unsplash.com/?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText) 上的 [Marcus dePaula](https://unsplash.com/photos/tk7OAxsXNL0?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText)

我并不热衷笼统的陈述你“应该”或“不应该”使用网络字体，但我认为应该有**一些**指导方针来帮助我们决定是否使用它们。

接下来的篇幅会很长，但是它的主旨是：如果你正在制作一个网站，而你即将去寻找完美的网络字体，请至少**考虑**使用系统字体。

也许你会这样考虑：

![](https://cdn-images-1.medium.com/max/2000/1*MpuDht99XGlRIFlhjFb2yQ.png)

我怀疑对于某些人来说，决策过程更像是这样：

![](https://cdn-images-1.medium.com/max/2000/1*UuhYbCYMjgFk18srTw6rIQ.png)

如果你一直在使用网络字体，那么认为“系统字体”很丑也不足为怪，因为“系统”这个词本身就会让人觉得很丑，所以你才会这么想。

为了让大家觉得是在看同一个页面，至少是在看同一本书，我想给大家展示一个使用系统字体的网页。这可能不是最好的方式，但我希望能以此改变那些负面的观念。

![](https://cdn-images-1.medium.com/max/2000/1*fp9yphAAvXxSD3WbYKXhMA.png)

并不丑啊。

---

你可能希望打开你自己的网站并尝试以下字体系列，看看感觉如何：

    -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;

---

或者你可以使用扩展测试驱动器，并使用类似于 [Stylebot](https://chrome.google.com/webstore/detail/stylebot/oiaejidbmkiecgbjeifoejpgmdaleoha) 的 Chrome 扩展程序来设置特定 CSS 选择器或站点的字体系列。这样，当你访问你的站点时，更改会保持一致。

有了这个令人惊讶的简短介绍，下面让我们在那个流程图中的每个问题上花点时间。

### 字体对你的品牌至关重要吗？

这是最简单的方法。如果答案是肯定的，请停止阅读 —— 下面没有什么可看的了。我真的不介意你直接跳到评论，告诉我我太天真了。

![](https://cdn-images-1.medium.com/max/2000/1*olLYhG5bwvR-YvWwIomuDg.png)

只看这种字体，人就算了。

显然，我不会建议 **The New Yorker** 不使用 Irvin 字体，或者 Apple.com 不使用 San Francisco 字体。即使像耐克这样的网站，我也不会建议他们不要这样做（“One Nike Currency” 字体是十分平常的），因为那是**他们**的字体。

**结论**：如果你的字体是你品牌的一部分，那么显然要使用该字体。否则，请看下面的内容！

### 字体是否使你的网站更容易阅读？

看看这张图片中的文字，只看字体，内容是不相关的。

![](https://cdn-images-1.medium.com/max/1600/1*wSyM5c15HIlxioEOpl2cPw.png)

我想如果你是一个煤矿工人，那这是相关的，只是这篇文章和它不相关。
让自己形成一个意见，稍后再回来。

---

如果在你的网站上，连续阅读的平均字数是 4 个，那么眼疲劳不是那么的大。也许这就是为什么 Facebook、Twitter、Gmail 和 eBay 都使用系统字体（在大多数地方）。

但是，如果用户到你的网站上阅读 10 分钟，你希望你的文本能够很容易地吸引注意力。

（关于衬线的注意事项：到目前为止，我所使用的术语“系统字体”指的是将 font-family 设置为 `-apple-system, BlinkMacSystemFont` 等，它们是无衬线字体。同样的想法也适用于衬线字体。**The New York Times**, **The Boston Globe**, **The Australian** 这些网站都给 body 定义了像 `georgia, "times new roman", times, serif` 的字体。）

Medium.com 是一个很好的例子，我确定你很熟悉它。显然他们在排版上花了很多心思。从那些可爱的短划线到你甚至都没有注意到的不同宽度的空格，Medium 的字体与系统字体是不一样的。

但这不应该让你认为一个网站有使用网络字体**才**容易阅读。

如果你是开发人员，可能已经花了很多时间盯着 GitHub 上的文字。你知道这些文字是没有加载任何一个网络字体实现的吗？太不可思议了。

我想如果明天 GitHub 从系统字体转换为 `Source Sans Pro`，没有人会注意到。同样，我敢打赌，如果 NPM 放弃了 `Source Sans Pro` 并使用系统字体，也没有人会注意到。

这就是它的关键，你的用户（不是你）会注意到网络字体和系统字体在可读性上的差异吗？

先不要回答，因为……

#### 维基百科的奇特案例

维基百科已经[对他们的排版做了大量的思考](https://www.mediawiki.org/wiki/Typography_refresh)。他们得出结论是，系统字体才是他们需要的。

这对他们来说挺好的。

但令我感到困惑的是，在桌面版的尺寸上，他们没有执行过一个度量标准（行宽度），并且使用的是 14px 的字体（在 2014 年更新之前，它是 13px）。

我认为这样做肯定是有充分的理由的，但此生我都不清楚是什么理由。也许与垂直扫描文章有关，我不知道。

我一直在使用 18px 文字和 700px 行宽度的维基百科，现在已经没有任何抱怨了。

![](https://cdn-images-1.medium.com/max/2000/1*CGgCTocnhmQLpaWYeRh6-A.png)

感谢 [Skinny 拓展程序](https://chrome.google.com/webstore/detail/skinny/lfohknefidgmanghfabkohkmlgbhmeho)（无耻的插件）。

当我经常被迫返回到默认视图时，它就会进入我的脑海。

![](https://cdn-images-1.medium.com/max/2000/1*-psbviYTpIj2VOo4r8yiGg.png)

维基百科：自 2001 年以来锻炼颈部肌肉，就像在月球上看一场羽毛球比赛。

（我对维基百科的建议：明天将桌面版正文文本改为 15px，然后在未来五年每年增加 1px —— 仍然会比现在阅读的文字小。）

这个小问题的关键是：如果你的文本在一开始就难以阅读，那么网络字体只能提供小的改进。因此，在考虑字体之前，应该先要了解可读文字排版的基础。

---

如果你不了解排版，但关心可读性，请尝试以此为起点：

- 至少 18px 的字体大小
- 1.6 的行距
- #333 或其周围的字体颜色
- 限制行宽度为 700px

但不要相信我的话，你可以从 Medium、The New Yorker、Smashing Magazine、longform.org，甚至 Node 和 NPM 文档中获得灵感。他们都清楚地考虑到可读性，你会发现他们之间有一些明显的相似之处。

将基本原理整理后，你就可以比较系统字体和网络字体了。

（我有一个预感，人们会争论这一点。提供宽泛的建议是我的错 —— 所以我会在这里说明：用常识来解释你在互联网上读到的内容，调整自己的品味，不要做你不想做的事情。也不要吃洗碗机，如果疼痛持续，就去看医生。）

---

现在，我希望你答应我，你不会往上翻。

因为……

这就是上面出现过的文本块。

![](https://cdn-images-1.medium.com/max/1600/1*Q-h43aVyuDsrHRVXqx7QbQ.png)

比第一个更容易阅读吗？更难读？还是一样？

很容易，当给出的两大块文本并排放在一起时，让你的眼睛在它们之间移动，最终说服自己其中一个比另一个更容易阅读。但如果没有直接的比较导致差异不明显，那么你可能有两个完全可以接受的字体。

为了满足需求，这里将它们并排放置，你可以很清楚地看到它们是不同的。一个是网络字体，而另一个是系统字体。

![](https://cdn-images-1.medium.com/max/2000/1*eS3Yg49ckvxMdo9dv-OPQA.png)

资料来源：[New Republic](https://newrepublic.com/minutes/143094/eliminating-coal-save-lives-per-year-entire-coal-industry-employs)（另外，我在图片中处理了 3 个不同的地方）。

我不会告诉你哪张图使用的是网络字体，哪张图使用的是系统字体。

那么，回到流程图的问题上：“网络字体让你的网站更容易阅读吗？”。我想，在寒冷的光线下，任何一个理性的人都会看着上面的比较，然后说**不**，他们中没有一个比另外一个更容易阅读。

（现在我想一想，这实际上是一个很好的测试，看看你是否是一个理性的人。）

**结论**：如果你的网站没有太多的文字，那么网络字体对可读性几乎没有任何影响。但如果你的网站都是关于阅读的，这可能不是那么容易。**我**认为 Medium 网站的字体肯定会让文字更加愉快地被阅读。**我**认为这和 New Republic 网站的字体没有任何区别。你需要为你网站的读者找到客观回答这个问题的方法。

如果你认为网络字体对可读性没有什么意义，那么你将更接近最终目标 —— 不必担心网络字体。

### 你能在没有 FOUT 的情况下加载字体吗？

如果你的流程图远远落后，所讨论的网络字体与你的品牌无关，并且不会提高可读性。但这当然不意味着你不应该使用它。

除非你遇到了 **F**lash **O**f **U**nstyled **T**ext（文本无样式闪烁）。因为那确实太丑了。

对不起，**New Republic**，我准备更深入地对你展开讨论。这并不是出于我本意，是因为你向我的浏览器发送了 524 KB 的字体。 

下面是上图文章中的字体加载情况。

![](https://cdn-images-1.medium.com/max/1600/1*6GoQ3zcV8mA-lufM3iMd1A.png)

载入一篇 New Republic 网站的文章。在 Chrome 开发者工具的网络面板中，限制网速为 “Fast 3G”，然后仅对字体进行过滤。
文章的正文副本在 1.45 秒内可见。这是一个很大的努力。

讲真的，3G 网络 1.45 秒的时间，打败了互联网绝大部分的网站【鼓励一下】。

然后在 1.65 秒的时候图片被加载了。但从这一点开始，一切都在走下坡路，就像奶酪追逐节一样。

**九秒钟后**，在 10.85 秒时，网络字体就绪，文本闪烁，因为系统字体被替换为网络字体了。我去。

但这还没完，哦，不。在 12.58 秒时，它会再次闪烁，因为 700-weight 字体被加载了（在每篇文章的开头句子中使用 —— 所以这将改变其余的副本），然后在 12.7 秒时，400 斜体可用，文本再次闪烁。

所有这一切，事实上是大多数人都无法区分这两种字体。

我能说的是，这里使用的 `Balto` 和 `Lava` 字体不仅是 542 KB，它们每年也要 2000 美元左右。确实是这样。

这肯定会让我的钱包很紧。

有趣的是，我想很多人在看到这篇文章的标题时，会认为这是一篇关于一些开发人员看不到精细排版中的价值的吐槽。但恰恰相反。上述行为是对视觉体验的攻击，并且可以通过使用看起来几乎相同的系统字体来**避免**。

---

但是，我们在这里先退一步。很明显，这个网站的设计师并**不想**它在加载时这么烦人。这显然不仅仅只有 **New Republic** 遇到了这种情况。那么一个网站怎么会这样呢？

更重要的是，你如何避免**你的网站**遇到这种情况？

我认为设计决策可能发生在 Sketch 设计的前面，或者用本地安装的字体来查看网站，所以假定**使用网络字体没有什么负面影响**。

这是不正确的，因为任何曾经使用过互联网的人都可以告诉你。

也许如果 Sketch 或者 Photoshop 有一个插件，在你每次打开一个文件时都会显示 10 秒钟的系统字体，那么世界上将会有更少的不必要的网络字体。

我的建议：了解网络字体是如何展示给你的用户的，而不是停留在静态设计上，它不会出现任何烦人的闪烁的无样式文本。

**结论：**如果你不能避免 FOUT，那么请避免使用网络字体。

（如果你在本轮中被淘汰，你可以向上滚动并查看一些避免 FOUT 的提示。）

### 你想在所有设备上使用相同的字体吗？

在这里我只有这一步，因为我已经听到过很多次，并想要解决它。但坦白说，我并没有解决这个问题。

为什么要在所有设备上使用相同的字体？在表面看来，这听起来像是一个愚蠢的问题。我试图用 `5 Whys` 进行分析，但我在第二个上面卡住了。

从我的理解来看，我的想法是，如果我正在 Mac 的 Safari 中浏览一些袜子，然后离开家，坐上火车，用我的 Android 浏览同一个网站，如果我看到的是不同的字体，那将是一件很**糟糕**的事情。

我理解“一致性很重要”这一普遍观点。但……真的吗？在流程图中的这一点上？

我只能代表我自己，但是如果我从坐在沙发上，用一个 15 英寸 220 PPI 的 LCD 屏浏览你的桌面版网站，到火车上的脏房间里面，用一个 5.5 英寸 534 PPI 的 OLED 屏浏览你的手机版网站，我并不在乎我在看到的是什么字体，几乎肯定不会注意到从 San Francisco 到 Roboto 字体的变化。

我只是看着我手机上的袜子。

![](https://cdn-images-1.medium.com/max/2000/1*KCk6znjIEeYIT9Xirnh2EQ.png)

谢谢 [readymag](https://readymag.com/arzamas/132908/9/)。

但就像我说的，我仅代表我自己。也许只有我一个人有这样的想法，其他所有人都会对 Roboto/San Francisco 的切换感到非常困惑。

我只是一个孤独的数据点。

---

我也听说过这样的争论，在所有设备上使用相同字体，意味着你可以依靠具有一致粗细的文本，并始终占用相同的空间。

不是这样的。

![](https://cdn-images-1.medium.com/max/1600/1*5-yDFIJgMvqyr-ugdYUMOA.jpeg)

macOS 是的 Safari。

![](https://cdn-images-1.medium.com/max/1600/1*8cXq51gj6yp2kZfD_ePdIQ.png)

Windows 上的 Chrome。

我使用 macOS/Windows 的时间大概是一半一半（我好像有点像流浪汉），而 Windows 上的文本通常看起来更轻。但让事情变得复杂的是，Windows 有这样一整个叫做 ClearType 的东西，这意味着你实际上并不知道字体是如何展示给不同的用户的。

因此，你需要接受的是，即使使用网络字体，你的文本在 Mac 和 Windows 上的显示也会有所不同，几乎肯定会在不同的地方进行包装（注意主段落的第一行）。

**结论**：如果你明白你的文字在所有设备上（永远）不会看起来一样，但仍然希望在所有设备上使用相同的字体，那么选择是明确的：你将需要一个网络字体。不然呢……

### 使用网络字体会让你更开心吗？

因此，你已有了一个字体，**无关**你的品牌，也**不**增加可读性，你**可以**在没有难看的闪烁无样式文本的情况下加载它，而且你已经接受了设备之间不可避免的不一致。

现在怎么办?

你可能已经注意到，我的流程图中缺少了“它看起来更好吗？”。我向你保证，这不是因为我觉得外观并不重要。美学是非常重要的，这也是为什么我早上要梳头发。

它之所以没有出现在流程图中，是因为网络字体天生比系统字体更好看的误解。

也许是时候我们更仔细地看看这些“系统”字体了……

如果你今天使用系统字体，你的用户将获得 MacOS 和 iOS 上的 `San Francisco`，Android 上的 `Roboto` 和 Windows 上的 `Segoe UI`。

这些是 Apple、Google 和 Microsoft 选择来作为界面外观的字体。它们都是经过精心设计的，所以他们肯定不应该被认为是像 `Open Sans`，`Proxima Nova` 和 `Lato` 这样的字体。

（我想要说的是，这些系统字体比大多数网络字体都要好，但排版爱好者是一个暴力的群体，所以我不会说这样的话。）

系统字体可以像网络字体一样漂亮，如果你对字体的外观感兴趣，那么你应该努力去了解你的网站使用系统字体看起来怎么样。也许它看起来更好 —— 这不会是一个惊喜吗？

---

所以，你已经检查了系统字体，它们可不会为你做这些。现在，你只需要为你的网站选择字体，就像你要选择调色板和布局一样。

幸运的是，我们在流程图的末尾，所以如果你想使用网络字体，那么你就应该使用一个网络字体。

我感谢你花时间考虑系统字体，并祝愿你和你的网络字体永远幸福。

**结论**：如果你想使用网络字体，那你就使用吧。**但**如果这是你在所有这些之后得出的结论，实际上可能还有一件事情需要担心，系统实际上是非常棒的，然后使用系统字体。

每个人都是赢家。

### My opinion

The above was a rather boring ending, wasn’t it. “Do whatever makes you happy” — bleugh.

Now on to the important stuff. What *I* think.

*I* think web fonts are used as the default mode of operation rather than as the result of a considered decision making process.

I think, um, exactly half the sites that use web fonts could get rid of them and be better off.

I think the worst ones will actually be losing traffic because of their slow-to-load web fonts.

Things like the below are particularly outrageous. Users are given a blank page to stare at for three unnecessary seconds while this site loads a pretty font.

![](https://cdn-images-1.medium.com/max/2000/1*dlpNsFiPLVf7L8XTSZjsVA.png)

This really grinds my gears.

It’s like if you came over to my house to visit and I made you stand in the corner staring at a blank wall for three minutes while I brushed my hair.

If your site loads like this, you’re effectively saying “my font is more important than my content, and your time”.

I won’t give away the site (because I like the content and don’t think they deserve a public shaming), but you’re probably keen to see the unique, beautiful web font that causes this egregious delay.

So here is one paragraph in the system font you could have been reading straight away, and one in the wunderfont that users are kept waiting three seconds to see.

![](https://cdn-images-1.medium.com/max/1600/1*SvPa6OyravMecd045jf16Q.png)

It’s magnificent, isn’t it? Majestic, even. I wish that *all* sites kept me waiting an extra three seconds so that I could feast my eyes on the beauty that is this truly exhilarating typeface.

OK that’s enough of my opinions. I’m running out of breath and I just remembered I’m trying to be less sarcastic.

So let’s move on from me berating others for their choices and finish with something more practical.

### How to do web fonts right

Contrary to the vibe you may have gotten from the above, I don’t think the web should do away entirely with web fonts. But if you’re going to use them, there’s a right way and a wrong way. Below, you will find both.

---

The reason web fonts can be slow is that the browser doesn’t find out about them until quite late in the loading process. The browser must load a bunch of HTML and CSS *before* learning that it needs your fancy font that you totally need. (Dammit, some sarcasm slipped through. Apologies.)

Only then will the browser begin downloading the font. Here’s the assets loading for a page with nothing more than some HTML, CSS, and a single web font:

![](https://cdn-images-1.medium.com/max/1600/1*gfeEGIGmAgZ10PtxM53vSA.png)

The blue bar is HTML, purple is CSS and grey is the font file.

You can see that as the browser is parsing the HTML, it discovers a reference to the CSS file and starts downloading it. Once you’ve finished noticing that, notice that only once the CSS is completely downloaded does the browser realise you’re going to need a font. So the page is actually ready to go before the font even *begins* to download.

It’s a bit hard to see, but across the top are screenshots of the page as it’s loading. If you squint (although if you ask me, squinting makes it even harder to see things), you can see that the text is rendered only once the font is ready (at about 2400ms).

Your other option is to load the font via CSS — the sort of snippet you’re encouraged to use by Google Fonts. This basically loads a CSS file that defines some font-face rules that point to font files on Google’s servers. So the load pattern looks like this:

![](https://cdn-images-1.medium.com/max/1600/1*Gdclz9iXlIXiZdP629I4AA.png)

The green is the font file. The end result is much the same. We’re waiting for ages before we event start downloading the font.

---

But what if you could add one line of code and start the font downloading sooner? Like…

![](https://cdn-images-1.medium.com/max/1600/1*a1AvziD3XHE_dt4u4tUW3g.png)

Wouldn’t that be frikken awesome?

Well… drop this in your HTML before you define your CSS file and Bob’s your uncle.

```
<link
  rel="preload"
  href="./fonts/sedgwick-ave-v1-latin-regular.woff2"
  as="font"
  type="font/woff2"
  crossorigin
>
<link rel="stylesheet" href="main.css" />
```

Yes yes, technically not one line.

`rel=preload` only covers about 50% of users right now [August 2017], but it’s [just about to land in Firefox and Safari](http://caniuse.com/#feat=link-rel-preload) so things are quickly getting better.

Your alternative, the `FontFace` API, [covers a lot more ground](http://caniuse.com/#feat=font-loading) — closer to 80% of users. You can use it right before you point to your CSS to start the browser downloading immediately.

```
<script>
  if ('FontFace' in window) {
    var sedgwickAveFont = new FontFace(
      'Sedgwick Ave',
      'url(./fonts/sedgwick-ave-v1-latin-regular.woff2)',
      {
        style: 'normal',
        weight: '400',
      }
    );
    sedgwickAveFont.load().then(function() {
      document.fonts.add(sedgwickAveFont);
    });
  }
</script>

<link rel="stylesheet" href="main.css" />
```

I highly recommend reading [Web Font Optimization](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/webfont-optimization) if this floats your boat

The result is just as wonderful:

![](https://cdn-images-1.medium.com/max/1600/1*1Igz81o2h0lfGld6ukAfrA.png)

And in a neat stroke of luck, `.woff2` support is more or less a superset of `FontFace` support, so you only need to bother specifying the one font format when you use `FontFace`.

You can then have fallbacks for `.woff` and `.ttf` and whatever else you like in your usual `@font-face` rules.

```
@font-face {
  font-family: 'Sedgwick Ave';
  font-style: normal;
  font-weight: 400;
  src:  url('./fonts/sedgwick-ave-v1-latin-regular.woff2') format('woff2'),
  url('./fonts/sedgwick-ave-v1-latin-regular.woff') format('woff');
  font-display: block;
}
```

One last thing… so your font is now starting to download a lot sooner, you can hopefully avoid the dreaded FOUT entirely. But maybe there will be a few hundred milliseconds between the CSS arriving and the font arriving.

In this period, the browser knows what font to use, but doesn’t have it yet. What’s cool is that you can control what it does during this time by defining the `font-display` property in the `@font-face` rule.

In the above example, I can be pretty sure the font is going to arrive within a few hundred milliseconds of the CSS, since they’re about the same size, coming from the same server, starting at the same time.

In this case, I want to block the text from showing until the font arrives to save myself from the dreaded FOUT. I do this by setting `font-display` to `block`.

On the flip-side, if you think the font might not arrive for several seconds after your CSS, you might want to set it to `swap` so the browser shows the unstyled text immediately, thus letting your reader read.

[The spec](https://tabatkins.github.io/specs/css-font-display/#font-display-desc) explains the details in fairly simple language (I only read the green boxes). All this is Chrome-only as of August 2017.

---

Here’s a codepen that will list a bunch of fonts and show you which ones are supported on your current device.

I’m not sure that it’s actually useful but it was a bit of fun trying to work out how to do it. Lemme know if you’d like some fonts added to the list.

[![](https://s3-us-west-2.amazonaws.com/i.cdpn.io/326282.PKJvow.2cabcc11-62f6-4e7f-abfc-1c756aa59002.png)](https://hackernoon.com/media/39b5620b39b011d96f5a261b318ff3b7?postId=a3b4b39fe0ae)

That’s about it.

Bye.


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  