
> * 原文地址：[Using Feature Queries in CSS](https://hacks.mozilla.org/2016/08/using-feature-queries-in-css/)
> * 原文作者：[Jen Simmons](http://jensimmons.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/using-feature-queries-in-css.md](https://github.com/xitu/gold-miner/blob/master/TODO/using-feature-queries-in-css.md)
> * 译者：[Cherry](https://github.com/sunshine940326)
> * 校对者：[LeviDing](https://github.com/leviding)、[H2O-2](https://github.com/H2O-2)

# 在 CSS 中使用特征查询

CSS 中有一个你可能还没有听说过的工具。它很强大。它已经存在一段时间了。并且它很可能会成为你最喜欢的 CSS 新功能之一。

这就是 `@supports` 规则，也被称为 [Feature Queries](http://www.w3.org/TR/css3-conditional/#at-supports)。

通过使用 `@supports`，你可以在 CSS 中编写一个小测试，以查看是否支持某个“特性”（CSS 属性或值），并根据其返回的结果决定是否调用代码块。例如：
```
    @supports (display: grid) {
       // 只有在浏览器支持 CSS 网格时才会运行代码
     }
```
如果浏览器支持 `display: grid`，那么括号内的所有样式都将被应用。否则将跳过所有样式。

现在，对于特征查询的用途，似乎还不是很清晰。这不是一种分析浏览器是否**正确地**实现了 CSS 属性的外部验证，如果你正在寻找这样的外部验证，[参考这里](http://testthewebforward.org)。特征查询要求浏览器对是否支持某个 CSS 属性/值进行自我报告，并根据其返回的结果决定是否调用代码块。如果浏览器不正确或不完整地实现了一个特性，`@supports` 不会对你有帮助。如果浏览器误报了 CSS 支持的情况，`@supports` 不会对你有帮助。这不是一个能使浏览器漏洞消失的魔法。

即便如此，我仍然觉得 `@supports` 非常有用。如果没有 `@supports` 规则的帮助，我对多个 CSS 新规则的使用就会被推迟很多。

多年来，开发者都用 [Modernizr](https://modernizr.com) 做特征查询，但是 Modernizr 需要 JavaScript。即使脚本很小，Modernizr 的构建的CSS 需要 JavaScript 文件的下载、执行并且要在应用 CSS 之前完成。涉及 JavaScript 总是比只使用 CSS 慢。如果 JavaScript 打开失败也就是说如果 JavaScript 不执行会发生什么？另外，Modernizr 需要一个复杂并且许多项目无法处理的附加层。特征查询速度更快、更健壮、使用起来更加简单。

你可能会注意到，特征查询的语法与媒体查询非常相似。我把他们看做堂兄弟。
```
    @supports (display: grid) {
      main {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      }
    }
```
现在大多数情况下，CSS 中不需要这样的测试。例如，你在写下面代码的时候不用测试其支持情况：
```
    aside {
      border: 1px solid black;
      border-radius: 1em;
    }
```
如果浏览器支持 `border-radius`，那么它将在 `aside` 上设置圆角。如果没有，它将跳过代码行并继续前进，使框的边缘为正方形。这里没有理由运行测试或使用特征查询。CSS 就是这样工作的。这是 [architecting solid, progressively-enhanced CSS](http://jensimmons.com/presentation/progressing-our-layouts) 中的一个基本原则。浏览器只跳过不支持的代码，不抛出错误。
 
![新旧浏览器中圆角效果截图](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/border-radius.png)大多数的浏览器显示 `border-radius: 1em` 如图片的右边所示。然而，Internet Explorer 6、7 和 8 不会设置圆角，显示效果如图片的左边所示。看看这个例子 [codepen.io/jensimmons/pen/EydmkK](http://codepen.io/jensimmons/pen/EydmkK?editors=1100) 
您不需要为此进行功能查询。

那么，你想什么时候使用 `@supports` ？特征查询是一种将 CSS 声明捆绑在一起的工具，以便在一定条件下作为一个组运行。当你想在新的 CSS 功能被支持的时候，将新的和旧的 CSS 混合使用，那么请使用特征查询。

让我们看一下使用 Initial Letter 属性的示例。这个新属性 `initial-letter` 告诉浏览器，使元素变得更大 —— 像段首大字。在这里，一个段落中第一个词的第一个字母被设置为四行文字的大小。非常好。但我还是想把那字母加粗，在右边留一点空白，让它变成一个漂亮的橙色。酷。
```
    p::first-letter {
         -webkit-initial-letter: 4;
         initial-letter: 4;
         color: #FE742F;
         font-weight: bold;
         margin-right: 0.5em;
      }
```

![`initial-letter`这个例子在 Safari 9 下面的截图](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/intial-letter-1.gif)
这是我们的 `initial-letter` 的例子在 Safari 9 下的显示。现在让我们看看其他浏览器会发生什么…

![`initial-letter` 这个例子在其他浏览器下面的截图](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/intial-letter-2.png)哦，不，这在其他浏览器看起来非常糟糕。这是不能接受的。我们不想改变字母的颜色，或者增加一个空白，或者让它加粗，除非它通过 `initial-letter` 属性被设置的更大了一些。我们需要一种方法来测试浏览器是否支持 `initial-letter`，并且只在颜色、粗细和空白处应用更改。进入特征查询。
```    
    @supports (initial-letter: 4) or (-webkit-initial-letter: 4) {
      p::first-letter {
         -webkit-initial-letter: 4;
         initial-letter: 4;
         color: #FE742F;
         font-weight: bold;
         margin-right: 0.5em;
      }
    }
```

注意，您需要测试具有属性和值的完整字符串。最初这是令我困惑的。为什么我要测试 `initial-letter: 4`？值为 4 重要吗？如果我传入的值是 17 呢？它是否需要与后续代码中的值相匹配？

`@supports` 规则测试一个包含属性和值的字符串，因为有时候需要测试的是属性，有时需要测试的是值。对于 `initial-letter` 的例子，你传入的是什么值并不重要。但是考虑 `@supports (display: grid)`，你会看到两者都是需要的。每个浏览器都支持 `display`。只有测试版浏览器支持 `display: grid`（目前来说）。

回到我们的示例：目前 `initial-letter` 仅在 Safari 9 中得到支持，并且它需要前缀。所以我写了这个前缀，为了确保包含无前缀的版本我写了这个测试。是的，可以在特征查询中使用 `or` 、`and` 和 `not` 语句。

这是新的结果。浏览器支持 `initial-letter` 的话就会将其展现为字体更大、加粗并且是橘色的段首字母。其它浏览器表现的像段首字母不存在一样，但如果这些浏览器支持了这个规则，那么视觉效果将会是一样的。（顺便说一下，目前 Firefox 正在尝试实现段首字母特性。）

![使用之前和之后的对比](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/intial-letter-with-and-without.gif)截屏的左边是来自 Safari 9。其它浏览器展现的结果显示为右边。你可以在 [codepen.io/jensimmons/pen/ONvdYL](http://codepen.io/jensimmons/pen/ONvdYL?editors=1100) 看到这个测试的代码。

## 组织你的代码

现在，您可能会尝试使用此工具将代码分成两个分支。“嘿，浏览器，如果你支持视口单位，执行这段代码，如果你不支持他们，执行另一段代码。”这感觉很好并且很整洁。
```
    @supports (height: 100vh) {
      // 使用 viewport height 的布局
    }
    @supports not (height: 100vh) {
      // 老式浏览器另一种布局
    }
    // 我们希望是这样，但这个代码不是很好
```
这不是一个好主意 —— 至少现在来说。你发现是什么问题了吗？

然而，不是所有浏览器都支持特征查询。并且浏览器不支持 `@supports` 将会跳过这部分的全部代码。这不是很好。

这是不是意味着，除非 100% 的浏览器都支持，否则我们就不能使用特征查询了？不是的，我们可以，并且当今我们应该使用特征查询。不要像最后一个例子那样编写代码。

那怎么做才是正确的呢？这和我们在 100% 支持媒体查询前有相同的方法。事实上，在这个过渡时期使用特征查询比使用媒体查询更容易。你只要聪明点就行了。

你希望构建你的代码，因为最古老的浏览器不支持特征查询或您正在测试的特性。我来教你怎么做。
（当然，在将来的某个时候，一旦 100% 的浏览器有特征查询，我们就可以更大程度地使用 `@supports not`，并以这种方式组织我们的代码。但我们还要等很多年。

## 支持特征查询

那么特征查询的支持情况如何呢？

自从 2013 年年中以来，在 Firefox、Chrome、和 Opera 就已经支持 `@supports` 了。它也适用于 Edge 的每一个版本。Safari 在 2015 年秋季将其在Safari 9 中支持。在任何版本的 Internet Explorer、Opera Mini、Blackberry Browser 或 UC 浏览器中都不支持特征查询。

[![Can I use 网站支持特征查询的截图](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/Can-I-Use-Feature-Queries.gif)](http://caniuse.com/#feat=css-featurequeries)特征查询的支持可以查看：[特征查询在 Can I Use 上的结果](http://caniuse.com/#feat=css-featurequeries)

您可能会认为 Internet Explore 不支持特征查询。实际是并不是。我马上告诉你原因。我认为最大的障碍是 Safari 8。我们需要密切关注这儿发生的事情。

让我们来看另一个例子。假设我们有一些想要应用的布局代码，为了使操作更加合理需要使用 `object-fit: cover`。对于不支持 `object-fit` 的浏览器，我们希望应用不同的布局 CSS。
[![Can I Use 网站中关于 Object-fit 支持的截图](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/Can-I-Use-Object-Fit.gif)](http://caniuse.com/#feat=object-fit)来看一下支持情况 [Object Fit 在 Can I Use 上的结果](http://caniuse.com/#feat=object-fit)

我们开始来编写代码：
```
    div {
      width: 300px;
      background: yellow;
      // 老布局的一些复杂代码
    }
    @supports (object-fit: cover) {
      img {
        object-fit: cover;
      }
      div {
        width: auto;
        background: green;
       // 新布局的一些其他复杂的代码
      }
    }
```

那么会发生什么呢？特征查询要么支持要么不支持，新的特性 `object-fit: cover` 要么支持要么不支持。结合这些，我们有 4 种可能性：

| 支持特征查询吗？ | 支持特性吗？ | 会发生什么？| 这是我们想要的吗？ |
| --- | --- | --- | --- |
| 支持特征查询 | 支持问题中的特性 |
| 支持特征查询 | 不支持问题中的特性 |
| 不支持特征查询 | 不支持问题中的特性 |
| 不支持特征查询 | 支持问题中的特性 |

### 情景 1：浏览器支持特征查询，并支持问题中的特性

Firefox、Chrome、Opera 和 Safari 9 都支持 `object-fit` 和 `@supports`，所以这个测试将运行得很好，并且这个块内的代码将被应用。我们的图像将通过 `object-fit: cover` 被裁剪，并且我们 `div` 的背景将是绿色的。

### 情景 2：浏览器支持特征查询，并且不支持问题中的特性

Edge 不支持 `object-fit`，但它支持 `@supports`，因此该测试将运行并失败，防止代码块被应用。该图像将不会有 `object-fit` 应用，并且 `div` 有黄色的背景。

这是我们想要的。

### 情景 3：浏览器不支持特征查询，并且也不支持问题中的特性

这就是我们的经典克星 Internet Explorer 出现的地方。IE 不支持 `@supports`，并且也不支持 `object-fit`。你可能认为这意味着我们不能使用特征查询 —— 并不是。

想一下我们想要的结果。我们想要 IE 跳过整个代码块。并且确实是这样的结果。为什么呢？因为当它执行到 `@supports` 时，它无法识别这个语法，并且会跳转到结尾。

它可能跳过代码“出于错误的原因” —— 它跳过代码是因为它不支持 `@supports`，而不是因为它不支持 `object-fit`，但是谁在乎呢？！我们仍然得到我们想要的结果。

同样的事情也发生在 Android 的黑莓浏览器和 UC 浏览器上。他们不支持 `object-fit` 和 `@supports`，所以我们都准备好了。很成功。

底线是 —— 当你在浏览器中使用一个不支的特征查询的特征查询时，只要让浏览器不支持你正在测试的功能就好了。

仔细思考代码的逻辑。问问自己，当浏览器跳过这个代码时会发生什么？如果那是你想要的，你都准备好了。

### 场景 4：浏览器不支持特征查询，但支持问题中的特性

问题是这第 4 个组合 —— 虽然特征查询所包含的测试没有运行，但是浏览器确实支持该特性时，并且应该运行该代码。

例如，`object-fit` 由 Safari 7.1（Mac）和 8（Mac和iOS）支持，但这两个浏览器都不支持功能查询。这同样适用于 Opera Mini —— 它将支持 `object-fit`，但不支持 `@supports`。

会发生什么呢？这些浏览器进入这个代码块，但并未使用代码，在图片上应用 `object-fit:cover`，并将这个 `div` 的背景设置为绿色，它跳过了整个代码块，留下黄色作为背景颜色。

并且这不是我们真正想要的。

| 支持特征查询吗？ | 支持特性吗？ | 会发生什么？| 这是我们想要的吗？ |
| --- | --- | --- | --- |
| 支持特征查询 | 支持问题中的特性 | CSS 被应用 | 是的 |
| 支持特征查询 | 不支持问题中的特性 | CSS 没有被应用 | 是的 |
| 不支持特征查询 | 不支持问题中的特性 | CSS 没有被应用 | 是的 |
| 不支持特征查询 | 支持问题中的特性 | CSS 没有被应用 | 不，可能不是 |

当然，这取决于特定的用例。也许这是我们可以忍受的一个结果。较老的浏览器获得了较老浏览器的体验。网页仍在工作。

但在大多数情况下，我们希望浏览器能够使用它支持的任何特性。这就是为什么在涉及特性查询时，Safari 8 可能是最大的问题，而不是 Internet Explorer。Safari 8 支持许多新的特性 —— 比如 Flexbox。您可能不想阻止 Safari 8 上的这些属性。这就是为什么我很少在 `@supports` 中使用 Flexbox，或者有时候，我在代码中至少写三个分支，一个使用 `not`。（这很快就变得复杂了，所以不在这里解释了）。

如果您使用的功能在旧版浏览器中比功能查询支持的更好的话，那么在编写代码时要仔细考虑所有的组合。确保不要把你希望这些浏览器实现的功能也排除在外了。

同时，可以很容易的在 `@supports` 中用最新的 CSS 特性 —— 例如 CSS Grid、首字母。没有哪个浏览器会在不支持特征查询时就支持 CSS Grid 的。我们不必担心那个包含新特性时问题多多的第四种组合，在以后这使得功能查询非常有用的。

所有这一切都意味着IE11 虽然仍会存在很多年，我们还是可以同时使用特征查询和 CSS 的最新特性。

## 最佳实践

现在我们明白了为什么我们不能像这样编写代码：
```
    @supports not (display: grid) {
        // 较老浏览器的代码 // 不要模仿这个例子
    }
    @supports (display: grid) {
        // 较新浏览器的代码 // 我说这真的很糟糕吗？
    }
```
如果我们这样做，我们将阻止旧的浏览器获取他们需要的代码。

取而代之的是，像这样组织你的代码：

```
    // 较老浏览器的回退代码

    @supports (display: grid) {
        // 较新浏览器的代码
        // 在需要时覆盖上面的代码
    }  
    
```

这正是我们在使用媒体查询的同时支持旧版本 IE 的策略。这个策略就是“移动优先”这个词的来源。

我预计 CSS Grid 将在 2017 在浏览器中被使用，我打赌在实现未来的布局时我们将使用大量的特征查询。与 JavaScript 相比，它的麻烦要小得多，而且速度要快得多。并且 `@supports` 能使支持 CSS Grid 的浏览器做有趣的和复杂的东西，同时对不支持的浏览器提供布局选项。

自 2013 年年中以来，功能查询一直存在。随着 Safari 10 即将发布，我相信我们已经到了将 `@supports` 添加到工具箱的时候了。

## 关于 [Jen Simmons](http://jensimmons.com)

Jen Simmons 是在 Mozilla 的一个设计师，并且是 [The Web Ahead](http://thewebahead.net) 的主持人。她正在研究网络上平面设计的未来，并在全球会议上四处教授 CSS 布局。 

- [jensimmons.com](http://jensimmons.com)
- [@jensimmons](http://twitter.com/jensimmons)

[Jen Simmons 的更多文章](https://hacks.mozilla.org/author/jsimmonsmozilla-com/)
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
