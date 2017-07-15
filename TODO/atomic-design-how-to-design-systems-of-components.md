
> * 原文地址：[Atomic design: how to design systems of components](https://uxdesign.cc/atomic-design-how-to-design-systems-of-components-ab41f24f260e)
> * 原文作者：[Audrey Hacq](https://uxdesign.cc/@audreyhacq)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/atomic-design-how-to-design-systems-of-components.md](https://github.com/xitu/gold-miner/blob/master/TODO/atomic-design-how-to-design-systems-of-components.md)
> * 译者：[H2O-2](https://github.com/H2O-2)
> * 校对者：

# 原子设计：如何设计组件系统

Nowadays, digital products must be able to exist across any and all devices, screen sizes, and mediums at the same time:
现在的数字产品需要同时存在于任何的设备，屏幕尺寸和媒介上：

![](https://cdn-images-1.medium.com/max/800/1*q-qsAsIFizbZkalv7TwEOw.jpeg)

Every type of medium can now display our interfaces elements
> *So why the hell are we still designing our products by “page” or by screen?!*

所有媒介现在都可以显示我们的界面元素
> **所以我们为啥还在依据「页面」或者屏幕设计自己的产品？！**

Instead, we should be creating beautiful and easy access to content, regardless of device, screen size or context.
我们应该通过设计优美、简洁且兼容一切设备、屏幕尺寸或内容的访问方式取而代之。

By keeping this in mind and by being inspired by Modular Design, Brad Frost formulated the method of Atomic Design, in which everything begins with the smallest element of the interface: the atom. This metaphor allows us to understand what we are creating and especially how we are going to create it.
依据以上原则以及模块化设计的启发，Brad Frost 构想出了从最小的界面元素：原子，着手的原子设计方法。这个巧妙的比喻让我们理解了我们到底在创作什么，以及应该如何创作它。

I was convinced by this approach which finally allowed us to think about the part and the whole at the same time, have a global vision of a product or a brand, and also get closer to the way developers are working.
我对这个方法深信不疑：它终于可以让我们同时考虑部分和整体，拥有对产品或品牌的全局视野，并且能够以更接近开发者的工作方式工作。

So I thought to myself:
*“Of course, that’s it! We need to work like this!”
*But honestly, I didn’t have a clue about how to do this…
因此我自忖道：
**「没错儿了，就是这样！我们就需要像这样工作！」**
**但是说实话，我完全不知道该怎么做...**

It took me several months and some concrete projects before gaining an idea of what “designing in atomic” really meant and what that was going to change in my everyday life as a designer.
在花了几个月的时间并且做了几个实打实的项目之后，我才终于对「原子设计方式」的内在含义，以及它将会如何改变我的设计师之路，有了些许了解。

In this article, I’ll go over a bit of what I’ve learned and what to keep in mind when designing systems of components with Atomic Design.
在这篇文章里，我将会简要介绍一下我学到的知识，以及在通过原子设计方式设计组件系统时需要注意什么。

### For what kind of project ?
### 针对何种项目？

For me, every project, big or small can be designed with atomic in mind.
对于我来说，每一个项目，无论大小都可以使用原子设计的理念。

It gathers teams around a shared vision. The components are easy to reuse, edit and combine together so that the evolutions of the product will be simpler. And as for smaller projects… Well, every small project could one day become a big project, no?
这种方式可以统一团队的视野。组件易于重复使用、编辑和组合，使得项目的成长变得简单。至于小的项目嘛... 每个小项目总有一天都可能成为大项目，不是吗？

I also think that, contrary to popular belief, the Atomic Design methodology is not just for web projects … Quite the opposite in fact! I was able to introduce Atomic Design into a personal project (an iOS app for cleaning your address book named [TouchUp](https://itunes.apple.com/fr/app/touchup/id1128944336?mt=8)) and the developer with whom I worked really appreciated this approach. It saved us a lot of time when we wanted to quickly develop and iterate the product.
和大部分人的认知相左的是，我认为原子设计方法并不只适用于网络相关的项目 ... 事实上截然相反！我成功地在一个个人项目中（一个叫做[TouchUp](https://itunes.apple.com/fr/app/touchup/id1128944336?mt=8))的 iOS 应用，可以清理你的地址簿）引入了原子设计，而且与我合作的开发者非常欣赏这种方式。当我们想快速开发并迭代产品的时候，它帮了大忙。

And for those who wonder if it’s possible to build a system of components while still remaining creative, I recommend reading this article:“[Atomic Design & creativity](https://medium.com/@audreyhacq/atomic-design-creativity-28ef74d71bc6)”
同时我推荐那些担忧创造性与构建组件系统是否可能共存的人读读这篇文章：「[原子设计与创造性](https://medium.com/@audreyhacq/atomic-design-creativity-28ef74d71bc6)」

### **How is this different than before?**
### **这和过去有什么不同呢？**

People often ask me:
*“But how is this different than the way we worked before?”*
经常有人问我：
**「但是这和我们过去的工作方式有什么不同呢？」**

I see Atomic Design as a slightly different approach to interface design but one which can make a great impact in the end.
我把原子设计看作一种尽管只是略有不同却最终可以带来巨大影响的界面设计方式。

> *The part shapes the whole and the whole shapes the part*
> **部分塑造整体且整体塑造部分**

Until recently, we designed all the screens of a product, and then we cut it into small components to make specifications or UI Kits:
直到最近，我们仍会单独设计产品的每一个界面，然后把它们裁剪成小组件，以此来创建设计规格或UI套件（UI Kits）：

![](https://cdn-images-1.medium.com/max/800/1*3OFaoY-yLYdgPmO8AhejmQ.jpeg)

Before : we deconstructed screens to make components
之前：我们解构界面来制作组件

One of the problem was that the components created in this way were not generic and they weren’t dependent on each other. The reuse of components was thus very limited: our design system was restrictive.
这样制作出来的组件有一个问题，它们并不通用，且互不关联。因此组件的重复利用是非常有限的：我们的设计系统具有局限性。

---

Today, the idea of Atomic Design is to begin with common raw material (atoms) with which we can build the rest of the project:
现如今，原子设计的理念是从可以最终构建出整个项目常用的原材料（原子）入手。

![](https://cdn-images-1.medium.com/max/800/1*yyN6Ki0646UcFLsDabUShw.jpeg)

Today: we start from atoms and we build the rest from there
We have thus not only an “air de famille” between all the screens, but also a system which offers infinite design possibilities!
现如今：我们从原子开始并且用原子构建
因此我们不仅拥有了充斥在所有界面之间的「家庭气氛」（译者注：「家庭气氛」是一部法国的喜剧电影），更拥有了一个带来无限设计可能性的系统！

### Everything start with brand identity
### 一切始于品牌识别

Now you might be wondering:
*“Where do we begin if we want to design in an atomic way?”*
现在你也许在想：
**「如果我们想以原子的方式设计，该从哪开始呢？」**

To which I answer, rather logically: with atoms ;)
对这个问题我给出了一个极富逻辑性的回答：从原子开始 ;)
 
Thus the first thing which we are going to do is to create a unique visual language for our product that will be our starting point. This is what is going to define our atoms, our raw material and it is obviously very close from the brand identity.
因此我们首先要为产品设计出一个独特的视觉语言作为起点。它将描绘出我们的原子和原材料，而且显然它应与品牌识别紧密相连。

This visual language must be strong, easy to build upon, and free itself from the medium on which it is going to be displayed; it has to be able to work everywhere!
这个视觉语言一定要有力度、易于扩展、并且能够从其展示媒体中解放自我；它必须能在所有地方奏效！

The [Gretel agency](http://gretelny.com/work/netflix/), for example, made some remarkable work on the Netflix identity:
比如 [Gretel agency](http://gretelny.com/work/netflix/) 为 Netflix 的品牌识别做了些出色的工作。

![](https://cdn-images-1.medium.com/max/800/1*Piomy-9oNTP0yT3VcmKH4w.png)

Netflix visual language: strong, recognizable and easy to build upon
And thanks to a strong identity, we feel that we have all the material to release our first atoms: colors, typographic choices, forms, shadows, spaces, rhythms, animations principles…
Netflix 的视觉语言：有力度、辨识度高且易于扩展
多亏了强有力的品牌识别，我们会感觉已经

It is thus essential to spend time designing this identity, thinking about what makes the difference, the uniqueness of a brand or a product.

### Let’s continue with the components

Now that we have this raw material (still very abstract for the moment), we can now create our first components according to the objectives of the product and the initial user flow which we’ll have already identified.

#### Begin with key features

What really frightens designers who begin creating a system of components is to have to make components which are connected to nothing … Obviously, we aren’t going to create a shopping basket component if there is no purchase element in our product! That wouldn’t make any sense!

The first components are going to be closely linked to the product or the brand objectives.

And once more, to get rid of this notion of “page”, I insist on the fact that we are going to focus on features or user flow, not screens…

![](https://cdn-images-1.medium.com/max/800/1*bn-X_RyQCiW375OBOtnZxw.gif)

We want to focus on an action, not a specific screen
We are going to focus on the action which we want our user to do and on the components that are needed to accomplish this action. The number of screens will then vary, according to the context: maybe we’ll need half of the screen on desktop to display this component versus 3 consecutive screens on smartphone…

#### Enrich the system

Next, in order to enrich the system, we are going to make round trips between the already existing components and new features:

![](https://cdn-images-1.medium.com/max/800/1*35_KbPOTixmDVgUnShvitQ.jpeg)

Enrich the system by making round trips between the already existing components and new features
The first components will help to create the first screens, and the first screens will help to create new components in the system or to change the existing ones.

#### Think generic

![](https://cdn-images-1.medium.com/max/800/1*pMfHPwQ0dH_ITybJ9mVIGg.png)

When we design with atomic, we always have to keep in mind that the same component is going to be declined and reused in very different contexts.

> *We are thus going to make a real distinction between the structure of an element and its contents.*

For example, if I create a specific component that is a “contacts list,” I’m very quickly going to transform it into a generic component that will simply be a “list” item.

And I am then going to think about some possible variations of this component: What if I add or remove an element? And if the text runs onto 2 lines? What will be the responsive behavior of this component?

![](https://cdn-images-1.medium.com/max/800/1*zpLDZgMO0s6R0OsTX0g5NQ.png)

Transforming a specific component into a generic one
Having anticipated these variations is going to allow me then to use this component to create other ones:

![](https://cdn-images-1.medium.com/max/800/1*nn-NcMuzv6VdV3hpgvc7AQ.png)

Possible variations of a generic component
This work is necessary if we want our system to be both reusable and rich at the same time.

#### Think fluid

We still tend to think of responsive design as a reorganization of blocks on specific breakpoints.

Yet it’s the components themselves which have to have their own breakpoints and their own fluid behavior.

And thanks to software like Sketch, we can finally test the various responsive behavior of our components and define what we want to be fluid or what has to remain fixed:

![](https://cdn-images-1.medium.com/max/800/1*LXu8lJ-poM3d6TD3g6y2uw.gif)

We have to anticipate the fluid behavior of our components
We can also imagine that a component can be totally different in a context or in another.

For example, a button with round corner on desktop may become a simple circle with an icon on a smartwatch.

#### The part and the whole

One of the really interesting things building a system of components with Atomic Design is that we are conscious of creating a set of elements that depend on each other.

![](https://cdn-images-1.medium.com/max/800/1*7xilIVazxs1V6rGCY9VuDA.jpeg)

Working out the details before taking a step back to verify the results in the greater scheme of things
We then constantly zoom-in and zoom-out of our work. We are going to spend time on a detail, a micro-interaction, or the refining of a component, before we take a step back to verify what it looks like in context, before taking yet another step back to see what that makes as a whole.

This is the way we’ll refine the brand identity, develop components and verify that the system works.

### Mutualize the work

![](https://cdn-images-1.medium.com/max/800/1*gczpHM7chfldsdtvr7Umtw.png)

All of our components are linked to our atoms. And as everything is connected, we are going to be able to easily make modifications on a part of the system and verify the repercussion on the rest of the system!

> *We’re so lucky today as designers: we finally have tools which are adapted to create lively and evolving systems.*

Of course, there are programs like Sketch or Figma which allow us to create shared styles and to mutualize the similar components but I’m sure that we are going to see a lot more in the next few years.

We can at last, just like developers, have our own style guides and build entire systems around these style guides. A modification to an atom of our system will automatically reverberate across all the components which use this atom:

![](https://cdn-images-1.medium.com/max/800/1*xAMdhevJ8lLRMxO_yLljZg.gif)

All components are linked to the atoms
We realize very quickly how the modification of a component can affect the whole system.

By interlinking all of our components to each other, we also realize that if we create a new component, it’s the heart of the system that is going to be impacted, not just an isolated screen.

### Share the system

Sharing of the system is essential to keeping consistency between various products.

We all know that we can very quickly lose this consistency, when we work alone on a project, but it’s even more difficult when we work with other designers, which is happening more and more often.

Here again, we now have tools which allow us to really work in a team around a common system.

There are [shared libraries](https://uxdesign.cc/how-to-use-adobe-cc-shared-libraries-and-make-the-most-of-it-d5e114014170) like Craft for Sketch or those of Adobe for example, which allow us to have a single source of truth, accessible by all and always up to date:

![](https://cdn-images-1.medium.com/max/800/1*ses_KEaaren8CHX6KHoxXg.jpeg)

Shared libraries: always up to date and synchronized
Shared libraries allow several designers to start with the same base to begin their designs.

They also allow us to streamline the work because if we update a component in the shared library, the modification will automatically take place across all the files of all the designers which used this component:

![](https://cdn-images-1.medium.com/max/800/1*jIV9_u7tWnNsmEwzlvYB9w.gif)

One change in the library automatically changes linked elements everywhere
I have to admit that for the moment, of the various shared libraries I’ve tested, I have not yet found one which is totally adapted to work with Atomic Design… Still missing is this strong interdependence between atoms and components which allows us to create a lively and evolving system.

Another issue is that we still have two different libraries: the designers’ library and the developers’ library… It is thus necessary to maintain both in parallel, which causes errors and requires a lot of additional work.

My vision of the perfect shared library would be the following; a single library which would feed the designers and the developers at the same time:

![](https://cdn-images-1.medium.com/max/800/1*E8xw35qc9Iznt_3JB6o1Yg.jpeg)

My vision for the future: a single library which would feed both designers & developers
It’s when I see a plugin like [React Sketch app](https://github.com/airbnb/react-sketchapp) (recently launched by Airbnb) which promises coded components directly usable in our Sketch files, that I tell myself that maybe this future isn’t so distant after all…

![](https://cdn-images-1.medium.com/max/800/1*lOm8j3gpZHjxoAei2g9F1Q.png)

React Sketch app plugin: coded components directly usable in Sketch

### Last words

I think you get it: I’m convinced that we need to design our interfaces using components, thinking about lively and evolving systems, and I think that the Atomic Design methodology will help us do it effectively.

*If you too have feedback on the implementation of systems of components for small or big projects, do not hesitate to share your experience in the comments!*

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)

*Audrey wrote this story to share knowledge and to help nurture the design community. All articles published on uxdesign.cc follow that same *[*philosophy*](https://uxdesign.cc/the-design-community-we-believe-in-369d35626f2f)*.*

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
