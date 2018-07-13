> * 原文地址：[Creating with a Design System in Sketch: Part One [Tutorial]](https://medium.com/sketch-app-sources/creating-with-a-design-system-in-sketch-part-one-tutorial-5116e36213f9)
> * 原文作者：[Marc Andrew](https://medium.com/@marcandrew?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-one-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-one-tutorial.md)
> * 译者：
> * 校对者：

# Creating with a Design System in Sketch: Part One [Tutorial]

## Building and Working with a Design System in Sketch

![](https://cdn-images-1.medium.com/max/1000/1*jwTJroljaX-67eahDjPGKw.png)

### 🎁 Want to dramatically improve your Workflow with my Premium Design System for Sketch? You can pick up a copy of Cabana right [here](https://kissmyui.com/cabana).

Use the offer code **MEDIUM25** to receive **25% OFF**.

![](https://cdn-images-1.medium.com/max/800/1*aEcIFESUCKiFVRpssVQTOA.jpeg)

* * *

**I’ve seen plenty of tutorials out there showing you the elements that go into building a Design System in Sketch, but not many, if any, that actually then show you that sparkling, fresh as a daisy System you just created in practice**.

That’s what I want to do with this Tutorial Series. Show you not only how to create the elements that build up a Design System, but also showing you how to design a multi-screen iOS application using the System that you’ve just created, and to also show you how I constructed my own System and the thought processes and decisions behind that.

### Series Navigation

*   **Part One**
*   [Part Two](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-two-tutorial.md)
*   [Part Three](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-three-tutorial.md)
*   [Part Four](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-four-tutorial.md)
*   [Part Five](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-five-tutorial.md)
*   [Part Six](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-six-tutorial.md)
*   [Part Seven](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-seven-tutorial.md)
*   [Part Eight](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-eight-tutorial.md)
*   [Part Nine](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-nine-tutorial.md)

* * *

![](https://cdn-images-1.medium.com/max/1000/1*a-kVsheThBDPzeyMSGDLjQ.jpeg)

### Taking a look over the Design System

Ok. Before we jump on head-first into designing our all-singing, all-dancing, Medium-styled iOS App (who said clone?), let me give you a quick overview of the Design System (Cabana-Lite) Sketch file that we’ll call upon in the later parts of this Tutorial Series.

Inside of the format (starter) file there’ll be 3 pages…

*   _Design System (Setup)_
*   _Symbols_
*   _Format_

Let’s take it from the top…

#### Design System (Setup)

![](https://cdn-images-1.medium.com/max/800/1*5K_jofmNF-5emgDSd7PejA.jpeg)

Here’s where the magic happens people! The starting point from where you can control at least 90% of the styling that will occur on the project you’re working on.

Adjust elements here, be it your Base Colors or Typography for example, and these changes will propagate throughout your design.

The changes you make here will be reflected inside of your Symbols pages (which we’ll touch on in a moment), as well as, of course, filtering down into the Artboards you’re currently working on.

Inside of this Page, are 2 Artboards…

*   _Colors + Overlays + Duotone_
*   _Typography (We’ll touch on this Artboard in Part Two)_

#### Colors + Overlays + Duotone

![](https://cdn-images-1.medium.com/max/800/1*9DjFvdT281n_nZb2sLgejA.jpeg)

With this Artboard you will be able to see that I’ve organised all Color related assets together, such as Base Colors, Overlays and Image Effects (in this case the Duotone Effect).

Now in my Cabana Design System I’ve done a little more separation, where the Colors Artboard contains just the Base Colors, and Color Overlays, and elements such as the Duotone are separated into another Artboard labelled Various which also includes elements such as Gradients, and Box Shadows. But for the purpose of this Tutorial I’m just trying to keep things a little more compact for you. All good?

#### Base Colors

![](https://cdn-images-1.medium.com/max/800/1*EEaKR_Kq0sLD54eRgFbLJQ.jpeg)

For this Tutorial Series you will see that there only 4 Base Colors that we’ll be needing when designing our iOS App. Of course if you’re building out your own System, and to cover all bases when working on a large project you would be wise to create Base Colors for (and these are just suggestions)…

*   _Primary_
*   _Secondary_
*   _Tertiary_
*   _Black_
*   _Grey_
*   _Light Grey_
*   _Success_
*   _Warning_
*   _Error_

You can adjust the aforementioned list to something of your own choosing. Remove the Tertiary, and add another shade of Grey for example, to have something that you think will be the right fit for the many projects you could apply your own System to.

Ok. Back to those Base Colors, and let me give you a few tips on how I set up the Base Colors, using _Layer Styles_, in my own System.

Focusing on the Primary Color first, and in particular the Border Style, I simply created a Rectangle (R) **200x200**, removed the Fill, gave it a **1px** Border with my chosen Hex value, with a Radius of **4**.

![](https://cdn-images-1.medium.com/max/800/1*Vn_ITS4EHqh7sxlvtjujRA.jpeg)

Then I simply created a new Layer Style…

![](https://cdn-images-1.medium.com/max/800/1*mK2HsJYdyNqsEJ6rgaytgg.jpeg)

…and labelled it _Border/Primary_…

![](https://cdn-images-1.medium.com/max/800/1*rz6lSqepDeLmbYjPreTwEQ.jpeg)

For the Primary Fill I once more created a Rectangle (R) **200x200**, applied my chosen Hex value, and gave it a Radius of **4**.

![](https://cdn-images-1.medium.com/max/800/1*Q0JRENrjTqBCSwpQHOrvqQ.jpeg)

Then created a new Layer Style and labelled it _Fill/Primary_.

![](https://cdn-images-1.medium.com/max/800/1*Xs9Crw81EXCXdh4MCwHiVA.jpeg)

I then aligned both of these elements (Rectangles) on top of each other. Why you may ask?

This allowed me, and yourself, when working with a Design System like this, to easily change both Border and Fill Color Layer Styles in one clean sweep.

It takes up less screen real estate, and allows you more than anything, to make changes even quicker than having _Element A_ here  and _Element B_ there.

After that, I then locked down the titles (ie; Primary, Black, Grey etc…) once I had all my Base Colors and their accompanying Layer Styles in place.

![](https://cdn-images-1.medium.com/max/800/1*zleRk-jDNjwSQM0rnyZXhw.jpeg)

I then know that I have my titles in place for easy reference, and can drag my cursor around, for example, the Primary color, select it, make my Layer Style adjustments if required, all without breaking a sweat, or in Sketch terms without the pain of going “No! No! No! I did not mean to select that element”. Yup, we’ve all been there right?

I’d then repeat the process that I just mentioned for all my other Base Colors (Black, Grey etc…) locking those _Border/Primary_ and _Fill/Primary_ Layer Styles into place.

#### Color Overlays

![](https://cdn-images-1.medium.com/max/800/1*_NEQy-MOpVB6kRL4PtdjIA.jpeg)

With the Color Overlay, and again for the purpose of this tutorial, I’ve just set up the one Overlay. Black to be exact.

This can be easily superimposed over any image to aid in contrast, and its Hex value is taken from the Black Base Color for uniformity.

Like I mentioned with the Base Colors, when building out a full-fat, don’t hold the Mayo, Design System you really want to aim for (again just a suggestion) Overlays to match against the following Base Colors…

*   _Primary_
*   _Secondary_
*   _Black_ (which we’re using in this Tutorial)

Let me give you a few pointers on how I set up the Color Overlays, once more using Layer Styles, in my own Design System.

I’ll focus on the Black Color Overlay that we’ll be using later in the tutorial.

So I simply created a Rectangle (R) **432x248** (now this can be any measurement you want, this is just what I randomly opted for), with a Radius of **4** (again personal preference, it just looked better aesthetically), pasted in the Hex value of the Black Base Color that I’d previously created, and dropped the Opacity down to 60%.

![](https://cdn-images-1.medium.com/max/800/1*OCNWm39eED210ruevgB85w.jpeg)

I then created a new Layer Style and labelled it _Overlay/Black_.

![](https://cdn-images-1.medium.com/max/800/1*kVA7DcMOm0NF1oaRrcno-A.jpeg)

Now I could have left it there. But I thought the sensible thing to do, and also considering that this Overlay would be, 99% of the time, appearing over an image, to add a little reference preview alongside the new Overlay Layer Style. This just meant I could have a better gauge of how the Overlay would work when, like I mentioned, it sat atop of an image in my design, and allow me to tweak maybe it’s Opacity until I was happy with the result.

Let me show you how I put that into place…

Firstly I drew out a Rectangle (R) with the same dimensions as Color Overlay I’d created previously, and then simply gave it an Image fill.

![](https://cdn-images-1.medium.com/max/800/1*U8AQvkA5u9n8KCw5loa8gQ.jpeg)

I then created a new Rectangle (R), exactly the same dimensions, placed it over the image, and then applied the _Overlay/Black_ Layer Style I’d created previously.

![](https://cdn-images-1.medium.com/max/800/1*khyh4RrFpHT1aH4jYjCC_w.jpeg)

Like I mentioned before, I now had a reasonably solid point of reference for how my Overlays would look when used against an image, and tweak accordingly until I was happy with the result.

#### Duotone

Finally, for the Duotone image, we’ll just be focusing on the one style for this tutorial, but in the Cabana Design System I created around 9 style variants.

Yes, something like Duotone or Gradients can be there purely for eye candy, and not really a required element of your own Design System, such as Base Colors or Box Shadows, but I popped them in because, well why not hey? You never know when a project may call upon them.

Ok. Before we finish up this part let me show you how I quickly created one of the Duotone images inside of both my own System and the format (starter) file. Let’s call this a bonus section of sorts :)

Like I’d done previously with the Overlay Image Reference, I created a Rectangle (R) and then applied an Image fill.

![](https://cdn-images-1.medium.com/max/800/1*BYB-1sB80cuCUX2ASs6u-g.jpeg)

Then it was just a case of adding a couple of extra Color Fills to the element, and tweaking the Blending modes until I had something which could pass as ‘Duotone’. Which in the case of the example included in the starter file went a little something like this (cue the music)…

*   _#041674_ & _Lighten_
*   _#1EDE81_ & _Multiply_

![](https://cdn-images-1.medium.com/max/800/1*H_XjH44nZrhzyKyCVev12Q.jpeg)

![](https://cdn-images-1.medium.com/max/800/1*N-Tpy9zVquh_XpAhoL7rew.jpeg)

I then simply dragged to rearrange the Fills in the Inspector until I had something like the following…

![](https://cdn-images-1.medium.com/max/800/1*dhaaEb1gIlKKkNXTcwMFvA.jpeg)

And then gave it a kerrr-aaazzyy name for reference (ie; Green Goblin). Yes my wit knows no bounds!

* * *

Ok. That wraps up Part One of this Tutorial Series. Please join me back here for Part Two, where I’ll be touching upon the Typography element of the Design System used later in the tutorial, as well as some invaluable hints & tips on how I put this section of my own Design System together.

**Jump across to Part Two right** [**here**](https://medium.com/sketch-app-sources/creating-with-a-design-system-in-sketch-part-two-tutorial-445e0264556a)**…**

### 🎁 Want to improve your Workflow with a fully-featured Design System? You can pick up a copy of Cabana right [here](https://kissmyui.com/cabana/).

Use the offer code **MEDIUM25** to receive **25% OFF**.

_Thanks for reading the article,_

**Marc**

_Designer, Author, Father and Lover of Hash Browns_

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
