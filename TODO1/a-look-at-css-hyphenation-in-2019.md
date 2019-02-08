> * 原文地址：[A look at CSS hyphenation in 2019](https://justmarkup.com/log/2019/01/a-look-at-css-hyphenation-in-2019/)
> * 原文作者：[Michael Scharnagl](http://twitter.com/justmarkup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-look-at-css-hyphenation-in-2019.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-look-at-css-hyphenation-in-2019.md)
> * 译者：
> * 校对者：

# 2019 CSS 新属性“连字符”初探

我最近在制作一个使用大标题（字体大小）的网站，也有德语版本，这意味着经常存在相当长的单词，并且周围的容器腾出的空间不足以美观地展示它。如果没有做任何调整措施，就会出现水平滚动条，这将“损坏”我们的页面布局。因此，我重读了大约四年前写的 [如何处里页面中的长单词](https://justmarkup.com/log/2015/07/dealing-with-long-words-in-css/) 一文并且实现了最终的解决方案。

这些解决方案似乎还能起到很好的作用，但这些方法仍然存在一些问题。让我们来看看 CSS Hyphenation（连字符样式）的浏览器支持情况，今天的我们该如何使用它以及我们希望在浏览器中看到哪些功能。

## 浏览器支持情况

浏览器对 [CSS 连字符样式](https://caniuse.com/#feat=css-hyphens) 支持的非常好。您应该记住，虽然它适用于 Mac 和 Android 平台上基于 Chromium 的浏览器，但它在 [Windows 和 Linux](https://bugs.chromium.org/p/chromium/issues/detail?id=652964) 上暂时不起作用（至少在2019年1月之前），并且它在 Opera Mini 和其他一些移动浏览器（Blackberry 浏览器，IE 移动设备......）中也不起作用，但整体支持是可靠的。

## 使用 CSS 连字符

要使用连字符，我们仍然需要为 IE 、Edge 和 Chromium 添加前缀，因此最好对每个应该使用连字符的文本使用以下内容：

```
.hyphenate {
  -webkit-hyphens: auto;
  -ms-hyphens: auto;
  hyphens: auto;
}
```

如果您可能想要在不受支持的浏览器中切分单词而不是修改布局，我建议你像下面这样做。这样，所有单词将在受支持的浏览器中连字符，并在不受支持的浏览器中分成新行。

```
.hyphenate {
  overflow-wrap: break-word;
  word-wrap: break-word;
  -webkit-hyphens: auto;
  -ms-hyphens: auto;
  hyphens: auto;
}
```

现在，我们今天知道如何使用CSS Hyphenation，让我们看看它还有那些缺陷。

## 太多连字符

我们对连字符的最大问题是它经常使用简单的连字符。这意味着以下示例，在这里它连接约瑟夫（约瑟夫）一词，但这看起来不太好。它还使文本更难阅读，因此不太容易访问。

![Über Josef Hauser](https://justmarkup.com/log/wp-content/uploads/2019/01/josef-hauser.png)

这是因为，除非UA（客户端）能够计算出更好的值，否则预示着 `hyphens: auto` 将把原来的单词查分成看似前后都有两个单词，这样看起来总共就好像有五个单词。这意味着连字符将用于每个单词，其长度至少为五个字符，并且它会在至少两个字符之后或之前中断。

我不确定他们为什么想出这个默认值，但现在我们已经拥有了这样一个值。不过好在规范中已经定义了一个解决方案 —— [连字符字符数限制属性](https://www.w3.org/TR/css-text-4/#hyphenate-char-limits).  
它指定了带连字符的单词中的最小字符数，因此我们可以使用它来覆盖默认值5（单词长度）2（连字符之前）2（连字符之后）。

因此，理论上我们可以使用以下配置仅对10个或以上字符的单词使用连字符，并且仅在四个字符之前或之后中断：

```
hyphenate-limit-chars: 10 4 4;
```

实际上，此属性仍仅在 Internet Explorer 10+ 和 Edge 中以 -ms 前缀支持。为连字符限制字符提供更好的支持真的很棒 —— 所以请让你最喜欢的浏览器知道你想要它，谢谢！以下是 [Chromium](https://bugs.chromium.org/p/chromium/issues/detail?id=924069) and here for [Firefox](https://bugzilla.mozilla.org/show_bug.cgi?id=1521723) 的问题。

特别提醒：基于 Webkit 的浏览器（Safari）支持 -webkit-hyphenate-limit-before、-webkit-hyphenate-limit-after和-webkit-hyphenate-limit-lines [properties](https://github.com/WebKit/webkit/blob/master/LayoutTests/fast/text/hyphenate-limit-before-after.html)，它还允许您定义最小长度和分割之前和之后的最小字符数。

正如你所看到的那样，支持 CSS Hyphenation 在2019年是非常有希望的。对我来说唯一的问题是缺乏对 hyphenate-limit-chars 属性的支持，当有足够的用户或者开发者要求时，它有望在将来变得更好。

18.01.2018更新：添加了 [Alexander Rutz](https://twitter.com/petitsanimaux/status/1089841643195383814) 和 [Jiminy Panoz](https://twitter.com/JiminyPan/status/1089841172040876032) 所述的有关webkit的浏览器的类似属性的信息。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
