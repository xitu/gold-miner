> * 原文地址：[Creating with a Design System in Sketch: Part Two [Tutorial]](https://medium.com/sketch-app-sources/creating-with-a-design-system-in-sketch-part-two-tutorial-445e0264556a)
> * 原文作者：[Marc Andrew](https://medium.com/@marcandrew?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-two-tutoria.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-two-tutoria.md)
> * 译者：
> * 校对者：

# Creating with a Design System in Sketch: Part Two [Tutorial]

## Building and Working with a Design System in Sketch

* * *

### 🎁 Want to dramatically improve your Workflow with my Premium Design System for Sketch? You can pick up a copy of Cabana right [here](https://kissmyui.com/cabana).

Use the offer code **MEDIUM25** to receive **25% OFF**.

![](https://cdn-images-1.medium.com/max/800/1*aEcIFESUCKiFVRpssVQTOA.jpeg)

* * *

In this fully-featured Tutorial Series I’ll be giving you valuable insights on how to build your own Design System (and how I constructed my own), as well as putting all those elements into practice as we build out the design for an Medium styled App called _format_.

### Series Navigation

*   [Part One](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-one-tutorial.md)
*   **Part Two**
*   [Part Three](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-three-tutorial.md)
*   [Part Four](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-four-tutorial.md)
*   [Part Five](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-five-tutorial.md)
*   [Part Six](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-six-tutorial.md)
*   [Part Seven](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-seven-tutorial.md)
*   [Part Eight](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-eight-tutorial.md)
*   [Part Nine](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-nine-tutorial.md)


* * *

### Typography

![](https://cdn-images-1.medium.com/max/800/1*HkYiqCoiWKrqrD_k-FLLQw.jpeg)

Ah. The Typography (Text Styles) aspect of the Design System. Now the one inside of the format Starter Package (that you will get chance to play with once we start designing our iOS App) is a stripped down version of the one that I created for Cabana, just to keep things lean for the purpose of this Tutorial Series.

This is the one element (or bunch of elements) that was one of the most time consuming when I was building out the Cabana Design System. It was a chore to create, but I saw its benefits once I started putting those Text Styles into practice, but yes, it was still a long slog to piece them all together nonetheless.

![](https://cdn-images-1.medium.com/max/800/1*AJ1Kize1DQ0RLs3cLSiPQA.jpeg)

Like I mentioned, for this Tutorial Series I’ve stripped the Text Styles right back to include just 4 color variants that we’ll need…

- Black
- Grey
- White
- Primary

Of course, and like I mentioned in Part One, if you’re creating a fully fleshed-out Design System then you’d want to also create Text Styles with the following color choices…

- Black
- Grey
- Light Grey
- White
- Primary
- Red
- Green
- …Or anything else you may have created for your Base Colors

This is what I did with my own Design System, and pretty much matched the color choices to the Base Colors I’d created previously.

### Why did you go to all the trouble?

Somebody asked me the other day why I’d gone to the trouble of creating such a variety of weight and size styles for both sets of font families (Font Family 1 and Font Family 2)?

Well I’ve seen other Design Systems out there have one Font Family set specifically for headings and the other for for Body, Lead etc…

Me personally I found this to be cumbersome and causes potential issues later down the line.

In doing it the way I did, yes, it may be more work in the creation stage of the Design System (and oh boy did it take some time), but once you have all the different weights and sizes for both Font Families at your disposal it’s easier for you when working with the System to go “Hey you know what I’m just sticking with Proxima Nova (Font Family #1) all the way through this project, and know that you have H1, H2, Body, Lead and all the other varieties to hand, instead of realising half way through a project that you don’t have Body in Font Family #1, and you don’t have H1 in Font Family #2 so you’re going to have go back into the System and create those. Not cool, and a complete pain in the derriere!

### Why such weird naming for your Typography options?

Another thing someone mentioned was why were my Typography options called…

- Font Family #1
- Font Family #2

Again, I’ve seen other Design Systems out there labelling the Text Styles up using the Font Family names, such as — _Lato_, _Open Sans_, _Proxima Nova_ etc…

So you have something like the following…

**_H1 > Proxima Nova > Left > Black_**

Now I’m not totally against this, and if that works for you cool. But again it’s, in my personal opinion, just another element that slows down the process when you decide to maybe swap out _Proxima Nova_ for _Helvetica_. Ok. There’s Sketch plugins available that can swap out Text Style names, if you do decide to change them, but again it’s just another hoop you need to jump through when you don’t really need to be jumping through hoops?!?!

If you get into your mindset that **90%** of the time _Font Family #1_ you’ll be using for Headings, and _Font Family #2_ for Body, Lead etc… it will just seem like second nature to you, and avoid having to fire up a plugin to change Text Style namings because you decided to swap out Proxima Nova for Comic Sans.

### Hold up just a second folks!!

**If you want a more detailed insight into how I constructed the Typography elements inside of my own Design System please check out one of my previous articles** [**here**](https://medium.com/sketch-app-sources/how-to-create-a-design-system-in-sketch-part-one-fd450dccab10) **(Just jump to the Typography section there), and then I’ll see you back here soon.**

_Did you check out the_ [_article_](https://medium.com/sketch-app-sources/how-to-create-a-design-system-in-sketch-part-one-fd450dccab10)_? Cool. We’re both on the same page. Awesome!_

Like I’d done with the Base Color elements that I touched on in Part One, and once I had both Font Families in place, I then added Titles for reference for each of those (ie; Font Family #1 (Black), Font Family #2 (Grey) etc…) grouped these together and then locked them down.

I did something similar for the Font Family #1 and #2 (White) where I simply created a Black background layer (for obvious contrast reasons) and then locked this down also.

Now I could simply jump into this section, drag my cursor to select a whole block of text…

![](https://cdn-images-1.medium.com/max/800/1*RTccjxnSeMvzpOFHk0UxwQ.jpeg)

…and update the Font Family from the Inspector, without the worries of accidentally selecting a reference title or dragging the background layer around the screen.

![](https://cdn-images-1.medium.com/max/800/1*72TdwduU1t-2nIrLbO9SMQ.jpeg)

_How very frustrating that would be by the twentieth time you’d done it?_

Hopefully with the handy insights I’ve given you here, and the informative [article](https://medium.com/sketch-app-sources/how-to-create-a-design-system-in-sketch-part-one-fd450dccab10) I pointed to earlier, you now have a better insight into how you can create the Typography aspect of your own Design System in the very best way possible .

* * *

Ok. That wraps up Part Two of this Tutorial Series. Please join me back here for Part Three, where I’ll be touching upon the Symbols used in the Design System and subsequent parts of this tutorial series, as well as some fine and dandy hints, tips and insights on how I put this section of my own Design System together.

**Jump across to Part Three right** [**here**](https://medium.com/sketch-app-sources/creating-with-a-design-system-in-sketch-part-three-tutorial-105b12a0944a)**…**

### 🎁 Want to improve your Workflow with a fully-featured Design System for Sketch? You can pick up a copy of Cabana right [here](https://kissmyui.com/cabana/).

Use the offer code **MEDIUM25** to receive **25% OFF**.

_Thanks for reading the article,_

**Marc**

_Designer, Author, Father and Lover of the odd Gradient or two_

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
