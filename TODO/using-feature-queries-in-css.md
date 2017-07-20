
> * 原文地址：[Using Feature Queries in CSS](https://hacks.mozilla.org/2016/08/using-feature-queries-in-css/)
> * 原文作者：[Jen Simmons](http://jensimmons.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/using-feature-queries-in-css.md](https://github.com/xitu/gold-miner/blob/master/TODO/using-feature-queries-in-css.md)
> * 译者：
> * 校对者：

# Using Feature Queries in CSS
# 在CSS中使用特征查询

There’s a tool in CSS that you might not have heard of yet. It’s powerful. It’s been there for a while. And it’ll likely become one of your favorite new things about CSS.
CSS中有一个你可能还没有听说过的工具。它很强大。它已经存在一段时间了。并且它很可能会成为你最喜欢的CSS新事物之一。


Behold, the `@supports` rule. Also known as [Feature Queries](http://www.w3.org/TR/css3-conditional/#at-supports).
这就是`@supports`规则，也被称为 [Feature Queries](http://www.w3.org/TR/css3-conditional/#at-supports)。

With `@supports`, you can write a small test in your CSS to see whether or not a particular “feature” (CSS property or value) is supported, and apply a block of code (or not) based on the answer. Like this:
使用`@supports`，你可以在你的CSS中编写一个小测试，以查看是否支持特定的“特性”（CSS属性或值），并根据其返回的结果决定是否调用代码块。例如：

    @supports (display: grid) {
       // code that will only run if CSS Grid is supported by the browser
       // 只有在浏览器支持CSS网格时才会运行代码
     }


If the browser understands `display: grid`, then all of the styling inside the brackets will be applied. Otherwise all of that styling will be skipped.
如果浏览器理解 `display: grid`，那么括号内的所有样式都将被应用。否则将跳过所有样式。

Now, there seems to be a bit of confusion about what Feature Queries are for. This is not some kind of external verification that analyzes whether or not a browser has *properly* implemented a CSS property. If you are looking for that, [look elsewhere](http://testthewebforward.org). Feature Queries ask the browser to self-report on whether or not a certain CSS property/value is supported, and use the answer to decide whether or not to apply a block of CSS. If a browser has implemented a feature improperly or incompletely, `@supports` won’t help you. If the browser is misreporting what CSS it supports, `@supports` won’t help you. It’s not a magic wand for making browser bugs disappear.

现在，对于特征查询是什么，似乎有点混乱。这不是一种分析浏览器是否**正确地**实现了CSS属性的外部验证，如果你正在寻找这样的外部验证，[参考这里](http://testthewebforward.org)。特性查询要求浏览器对是否支持某个 CSS 属性/值进行自我报告，并根据其返回的结果决定是否调用代码块。如果浏览器不正确或不完整地实现了一个特性，`@supports` 不会对你有帮助。如果浏览器是误报了 CSS 支持，`@supports` 不会对你有帮助。这不是一个能使使浏览器漏洞消失的魔法。

That said, I’ve found `@supports` to be incredibly helpful. The `@supports` rule has repeatedly let me use new CSS far earlier than I could without it.
也就是说，我发现 `@supports` 是非常有用的。`@supports` 规则多次让我使用新的CSS远远早于我能够没有它。

For years, developers have used [Modernizr](https://modernizr.com) to do what Feature Queries do — but Modernizr requires JavaScript. While the scripts might be tiny, CSS architected with Modernizr requires the JavaScript file to download, to execute, and to complete before the CSS is applied. Involving JavaScript will always be slower than only using CSS. Requiring JavaScript opens up the possibility of failure — what happens if the JavaScript doesn’t execute? Plus, Modernizr requires an additional layer of complexity that many projects just can’t handle. Feature Queries are faster, more robust, and much simpler to use.
多年来，开发商都用 [Modernizr](https://modernizr.com) 做特征查询，但是 Modernizr 需要 JavaScript。即使脚本可能是微小的，CSS 架构与 Modernizr 需要 JavaScript文件的下载、执行和在应用 CSS 之前完成。涉及 JavaScript 总是比只使用 CSS 慢。如果 JavaScript 打开失败也就是说如果JavaScript 不执行会发生什么？另外，Modernizr 需要一个复杂并且许多项目无法处理的附加层。特征查询速度更快，更健壮，使用起来更加简单。

You might notice the syntax of a Feature Query is a lot like a Media Query. I think of them as cousins.
你可能会注意到，特性查询的语法与媒体查询非常相似。我把他们看做堂兄弟。

    @supports (display: grid) {
      main {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      }
    }

现在大多数情况下，CSS 中不需要这样的测试。例如，你可以编写此代码而无需测试是否支持：
Now most of the time, you do not need such a test in your CSS. For example, you can write this code without testing for support:

    aside {
      border: 1px solid black;
      border-radius: 1em;
    }

如果浏览器理解 `border-radius`，那么它将在 `aside` 上设置圆角。如果没有，它将跳过代码行并继续前进，使框的边缘为正方形。这里没有理由运行测试或使用特性查询。css 就是这样工作的。这是 [architecting solid, progressively-enhanced CSS](http://jensimmons.com/presentation/progressing-our-layouts) 中的一个基本原则。浏览器只跳过不理解的代码，不抛出错误。
If a browser understands `border-radius`, then it will put rounded corners on the `aside` box. If it doesn’t, it will skip that line of code and move on, leaving the edges of the box to be square. There is no reason to run a test or use a Feature Query. This is just how CSS works. It’s a fundamental principle in [architecting solid, progressively-enhanced CSS](http://jensimmons.com/presentation/progressing-our-layouts). Browsers simply skip over code they don’t understand, without throwing an error.


![a screenshot of border radius effect in  old vs new browsers](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/border-radius.png)Most browsers will display `border-radius: 1em` as the result on the right. Internet Explorer 6, 7 and 8, however, will not round the corners, and you’ll see the result on the left. Check out this example at [codepen.io/jensimmons/pen/EydmkK](http://codepen.io/jensimmons/pen/EydmkK?editors=1100)
You do not need a Feature Query for this.
 

![新旧浏览器中圆角效果截图](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/border-radius.png)大多数的浏览器显示 `border-radius: 1em` 如右边所示。然而，Internet Explorer 6、7和8不会设置圆角，显示效果如左边所示。看看这个例子，在[codepen.io/jensimmons/pen/EydmkK](http://codepen.io/jensimmons/pen/EydmkK?editors=1100) 您不需要为此进行功能查询。

So when do you want to use `@supports`? A Feature Query is a tool for bundling together CSS declarations so that they’ll run as a group under certain conditions. Use a Feature Query when you want to apply a mix  of old and new CSS, but only when the new CSS is supported.
那么，你想什么时候使用 `@supports` ？特征查询是一种将CSS声明捆绑在一起的工具，以便在一定条件下作为一个组运行。当您想应用旧的和新的CSS混合时使用特性查询，但只有在支持新CSS时才使用。

Let’s look at an example using the Initial Letter property. This new property `initial-letter` tells the browser to make the element in question bigger — like for a drop cap. Here, the first letter of the first word in a paragraph is being told to be the size of four lines of text. Fabulous. Oh, but I would also like to make that letter bold, and put a bit of margin on its right side, and hey, let’s make it a nice orange color. Cool.
让我们看一下使用首字母属性的示例。这个新属性 `initial-letter` 告诉浏览器，使元素变得更大 —— 像首字母大写。在这里，一个段落中第一个词的第一个字母被设置为四行文字的大小。非常好。但我还是想把那字母加粗，在右边留一点空白，让它变成一个漂亮的橙色。酷。

    p::first-letter {
         -webkit-initial-letter: 4;
         initial-letter: 4;
         color: #FE742F;
         font-weight: bold;
         margin-right: 0.5em;
      }


![a screenshot of this example Initial Letter in Safari 9](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/intial-letter-1.gif)Here’s what our initial-letter example looks like in Safari 9.
Now let’s see what will happen in all the other browsers…
![首字母这个例子在 Safari 9 下面的截图](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/intial-letter-1.gif)这是我们的首字母的例子在 Safari 9 下的显示。现在让我们看看其他浏览器会发生什么…

![a screenshot of this Initial Letter example in other browsers](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/intial-letter-2.png)Oh, no. This looks terrible in all the other browsers.
Well, that’s not acceptable. We don’t want to change the color of the letter, or add a margin, or make it bold unless it’s also going to be made bigger by the Initial Letter property. We need a way to test and see whether or not the browser understands `initial-letter`, and only apply the change to color, weight, and margin if it does. Enter the Feature Query.
![首字母这个例子在其他浏览器下面的截图](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/intial-letter-2.png)哦，不，这在其他浏览器看起来非常糟糕。这是不能接受的。我们不想改变字母的颜色，或者增加一个空白，或者让它加粗，除非它通过首字母属性被设置的更大了一些。我们需要一种方法来测试浏览器是否理解 `initial-letter`，并且只在颜色、重量和空白处应用更改。进入特征查询。
    @supports (initial-letter: 4) or (-webkit-initial-letter: 4) {
      p::first-letter {
         -webkit-initial-letter: 4;
         initial-letter: 4;
         color: #FE742F;
         font-weight: bold;
         margin-right: 0.5em;
      }
    }


Notice, you do need to test a full string with both the property and value. This confused me at first. Why am I testing `initial-letter: 4` ? Is the value of 4 important? What if I put 17? Does it need to match the value that is further down in my code?
注意，您需要测试具有属性和值的完整字符串。最初这是令我困惑的。为什么我要测试 `initial-letter: 4`？值为 4 重要吗？如果我传入的值是 17 呢？它是否需要匹配我代码中较低的值？

The `@supports` rule tests a string that contains both the property and value because sometimes it’s the property that needs the test, and sometimes it’s the value. For the `initial-letter` example, it doesn’t really matter what you put for the value. But consider `@supports (display: grid)` and you’ll see the need for both. Every browser understands `display`. Only experimental browsers understand `display: grid` (at the moment).
`@supports` 规则测试一个包含属性和值的字符串，因为有时候需要测试的是属性，有时需要测试的是值。对于 `initial-letter` 的例子，你传入的值并不重要。但是考虑 `@supports (display: grid)`，你会看到两者都是需要的。每个浏览器都理解 `display`。只有测试浏览器理解 `display: grid`（目前来说）。

Back to our example: Currently `initial-letter` is only supported in Safari 9, and it requires a prefix. So I’ve written the prefix, making sure to also include the unprefixed version, and I’ve written the test to look for one or the other. Yes, you can have `or`, `and`, and `not` statements in your Feature Queries.
回到我们的示例：目前 `initial-letter` 仅在 Safari 9 中得到支持，并且它需要前缀。所以我写了这个前缀，为了确保包含无前缀的版本我写了这个测试。是的，可以在功能查询中使用 `or` 、`and` 和 `not` 语句。

Here’s the new result. The browsers that understand `initial-letter` show a giant bolded, orange drop-cap. The other browsers act like the drop cap doesn’t exist — the same way they would if I’d waited to use this feature until more browsers had support for it. (We are currently implementing Initial Letter in Firefox, by the way.)
这里有新的结果。浏览器理解 `initial-letter` 的话就会将其展现为字体更大、加粗并且是橘色的首字母。其他其它浏览器表现的像首字母不存在一样，使用这种方式，我会等待使用这个特征，直到更多的浏览器支持它。（顺便说一下，目前在 Firefox 中可以实现首字母的特性。）

![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/intial-letter-with-and-without.gif)The screenshot on the left is from Safari 9. All other browsers show the result on the right. You can see this code in action at [codepen.io/jensimmons/pen/ONvdYL](http://codepen.io/jensimmons/pen/ONvdYL?editors=1100)
![使用之前和之后的对比](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/intial-letter-with-and-without.gif)截屏的左边是来自 Safari 9。其它浏览器展现的结果显示为右边。你可以在codepen.io/jensimmons/pen/ONvdYL] (http://codepen.io/jensimmons/pen/ONvdYL?editors=1100) 看到这个测试的代码。
## Organizing Your Code
## 组织你的代码

Now you might be tempted to use this tool to cleanly fork your code into two branches. “Hey browser, if you understand Viewport Units, do this, and if you do not understand them, do this other thing.” That feels nice and tidy.
现在，您可能会尝试使用此工具将代码分成两个分支。“嘿，浏览器，如果你理解视口单位，执行这段代码，如果你不理解他们，执行另一段代码。”这感觉很好并且很整洁。

    @supports (height: 100vh) {
      // my layout that uses viewport height
    }
    @supports not (height: 100vh) {
      // the alternative layout for older browsers
    }
    // WE MIGHT WISH. BUT THIS IS BAD CODE.

This is not a good idea — at least not yet. Do you see the problem?
这不是一个好主意 —— 至少现在来说。你发现这个问题了吗？

Well, not all browsers support Feature Queries. And the browsers that do not understand `@supports` will skip over both blocks of code. That’s probably bad.
然而，不是所有浏览器都支持特征查询。并且浏览器不理解 `@supports` 将会跳过这部分的全部代码。这不是很好。

Does this mean we can’t use Feature Queries until 100% of browsers support them? Nope. We can, and we should use Feature Queries today. Simply do not write your code like the last example.
这就意味着我们不能使用特征查询了吗直到 100% 的浏览器都支持它们吗？不是的，我们可以，并且当今我们应该使用特征查询。不要像最后一个例子那样编写代码。

How do we do this right? Well, in much the same way we used Media Queries before they were 100% supported. And well, actually it’s easier to use Feature Queries in this transitional period than it was to use Media Queries. You just have to be smart about it.
那怎么做才是正确的呢？好的，这和我们

You want to structure your code knowing that the oldest browsers won’t support Feature Queries or the feature you are testing for. I’ll show you how.

(Of course, sometime in the far future, once 100% of the browsers have Feature Queries, we can make heavier use of `@supports not` and organize our code in that way. But it’ll be many years until we get there.)

## Support for Feature Queries

So how far back are Feature Queries supported?

Well `@supports` has worked in Firefox, Chrome, and Opera since mid–2013. It also works in every version of Edge. Safari shipped it in Fall 2015, in Safari 9. Feature Queries are not supported in any version of Internet Explorer, Opera Mini, Blackberry Browser, or UC Browser.
[![a screenshot from Can I Use showing support for Feature Queries](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/Can-I-Use-Feature-Queries.gif)](http://caniuse.com/#feat=css-featurequeries)Looking up support for [Feature Queries on Can I Use](http://caniuse.com/#feat=css-featurequeries)
You might think the fact Internet Explorer doesn’t have support for Feature Queries is a big problem. Actually, it’s usually not. I’ll show you why in a moment. I believe the biggest hurdle is Safari 8. We need to keep an eye out for what happens there.

Let’s look at another example. Say we have some layout code we want to apply that requires using `object-fit: cover` in order to work properly. For the browsers that don’t understand `object-fit`, we want to apply different layout CSS.
[![a screenshot from Can I Use showing support for Object-fit](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2016/08/Can-I-Use-Object-Fit.gif)](http://caniuse.com/#feat=object-fit)Looking up support for [Object Fit on Can I Use](http://caniuse.com/#feat=object-fit)
So let’s write:

    div {
      width: 300px;
      background: yellow;
      // some complex code for a fallback layout
    }
    @supports (object-fit: cover) {
      img {
        object-fit: cover;
      }
      div {
        width: auto;
        background: green;
       // some other complex code for the fancy new layout
      }
    }


So what happens? Feature Queries is either supported or not, and the new feature `object-fit: cover` is either supported or not. Combine those, and we get four possibilities:

| Feature Query Support? | Feature support? | What Happens? | Is This What We Want? |
| --- | --- | --- | --- |
| Supports Feature Queries | Supports the feature in question |
| Supports Feature Queries | Does not support the feature |
| Does not support Feature Queries | Does not support the feature |
| Does not support Feature Queries | Supports the feature in question |


### Situation 1: Browsers that support Feature Queries, and support the feature in question

Firefox, Chrome, Opera, and Safari 9 all support `object-fit` and support `@supports`, so this test will run just fine, and the code inside this block will be applied. Our image will be cropped using `object-fit: cover`, and our `div` background will be green.

### Situation 2: Browsers that support Feature Queries, and do not support the feature in question

Edge does not support `object-fit`, but it does support `@supports`, so this test will run and fail, preventing the code block from being applied. The image will not have `object-fit` applied, and the `div` will have a yellow background.

This is what we want.

### Situation 3: Browsers that do not support Feature Queries, and do not support the feature in question

This is where our classic nemesis Internet Explorer appears. IE does not understand `@supports` and it does not understand `object-fit`. You might think this means we can’t use a Feature Query — but that’s not true.

Think about the result we want. We want IE to skip over this entire block of code. And that’s exactly what will happen. Why? Because when it reaches `@supports`, it doesn’t recognize the syntax, and it skips to the end.

It might be skipping the code “for the wrong reasons” — it skips over the code because it doesn’t understand `@supports`, instead of because it doesn’t understand `object-fit` — but who cares! We still get exactly the result we want.

This same thing happens with the Blackberry Browser and UC Browser for Android. They don’t understand `object-fit`, nor `@supports`, so we are all set. It works out great.

The bottom line — anytime you use a Feature Query in a browser that does not support Feature Queries, it’s fine as long as that browser also does not support the feature you are testing.

Think through the logic of your code. Ask yourself, what happens when the browser skips over this code? If that’s what you want, you are all set.

### Situation 4: Browsers that support do not Feature Queries, yet do support the feature in question

The problem is this fourth combination — when the test proposed by a Feature Query doesn’t run, but the browser does support that feature and should run that code.

For example, `object-fit` is supported by Safari 7.1 (on Mac) and 8 (Mac and iOS) — but neither browser supports Feature Queries. The same is true for Opera Mini — it will support `object-fit` but not `@supports`.

What happens? Those browsers get to this block of code, and instead of using the code, applying `object-fit:cover` to the image and turning the background color of the `div` green, it skips the whole block of code, leaving yellow as the background color.

And this is not really what we want.

| Feature Query Support? | Feature support? | What Happens? | Is This What We Want? |
| --- | --- | --- | --- |
| Supports Feature Queries | Supports the feature in question | CSS is applied | Yes |
| Supports Feature Queries | Does not support the feature | CSS is not applied | Yes |
| Does not support Feature Queries | Does not support the feature | CSS is not applied | Yes |
| Does not support Feature Queries | Supports the feature in question | CSS is not applied | No, likely not. |

Of course, it depends on the particular use case. Perhaps this is a result we can live with. The older browser gets an experience planned for older browsers. The web page still works.

But much of the time, we will want that browser to be able to use any feature that it does support. This is why Safari 8 is likely the biggest problem when it comes to Feature Queries, not Internet Explorer. There are many newer properties that Safari 8 does support — like Flexbox. You probably don’t want to block Safari 8 from these properties. That’s why I rarely use `@supports` with Flexbox, or when I have, I’ve written at least three forks in my code, one with a `not`. (Which gets complicated fast, so I’m not even going to try to explain it here.)

If you are using a feature that has better support in older browsers than Feature Queries, then think through all of the combinations as you write your code. Be sure not to exclude browsers from getting something you want them to get.

Meanwhile, it’s easy to use `@supports` with the newest CSS features — CSS Grid for example, and Initial Letter. No browser will ever support CSS Grid without supporting Feature Queries. We don’t have to worry about our fourth, problematic combination with the newest features, which makes Feature Queries incredibly useful as we go forward.

All of this means that while IE11 will likely be around for many years to come, we can use Feature Queries liberally with the newest advances in CSS.

## Best Practices

So now we realize why we can’t write our code like this:

    @supports not (display: grid) {
        // code for older browsers// DO NOT COPY THIS EXAMPLE
    }
    @supports (display: grid) {
        // code for newer browsers// DID I SAY THIS IS REALLY BAD?
    }


If we do, we’ll stop the older browsers from getting the code they need.

Instead, structure your code like this:

    // fallback code for older browsers

    @supports (display: grid) {
        // code for newer browsers
        // including overrides of the code above, if needed
    }


This is exactly the strategy we applied to using Media Queries when supporting old versions of IE. This strategy is what gave rise to the phrase “mobile first”.

I expect CSS Grid to land in browsers in 2017, and I bet we will use Feature Queries quite a lot when implementing future layouts. It’s going to be much less of a hassle, and much faster, than involving JavaScript. And `@supports` will let us doing interesting and complex things for browsers that support CSS Grid, while providing layout options for the browser that don’t.

Feature Queries have been around since mid–2013. With the imminent release of Safari 10, I believe it’s past time for us to add `@supports` to our toolbox.

## About [Jen Simmons](http://jensimmons.com)

Jen Simmons is a  Designer Advocate at Mozilla, and the host of [The Web Ahead](http://thewebahead.net). She's researching the future of graphic design on the web, and teaching CSS Layout at conferences around the globe.

- [jensimmons.com](http://jensimmons.com)
- [@jensimmons](http://twitter.com/jensimmons)

[More articles by Jen Simmons…](https://hacks.mozilla.org/author/jsimmonsmozilla-com/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
