
> * 原文地址：[Atomic design: how to design systems of components](https://uxdesign.cc/atomic-design-how-to-design-systems-of-components-ab41f24f260e)
> * 原文作者：[Audrey Hacq](https://uxdesign.cc/@audreyhacq)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/atomic-design-how-to-design-systems-of-components.md](https://github.com/xitu/gold-miner/blob/master/TODO/atomic-design-how-to-design-systems-of-components.md)
> * 译者：
> * 校对者：

# Atomic design: how to design systems of components

Nowadays, digital products must be able to exist across any and all devices, screen sizes, and mediums at the same time:

![](https://cdn-images-1.medium.com/max/800/1*q-qsAsIFizbZkalv7TwEOw.jpeg)

Every type of medium can now display our interfaces elements
> *So why the hell are we still designing our products by “page” or by screen?!*

Instead, we should be creating beautiful and easy access to content, regardless of device, screen size or context.

By keeping this in mind and by being inspired by Modular Design, Brad Frost formulated the method of Atomic Design, in which everything begins with the smallest element of the interface: the atom. This metaphor allows us to understand what we are creating and especially how we are going to create it.

I was convinced by this approach which finally allowed us to think about the part and the whole at the same time, have a global vision of a product or a brand, and also get closer to the way developers are working.

So I thought to myself:
*“Of course, that’s it! We need to work like this!”
*But honestly, I didn’t have a clue about how to do this…

It took me several months and some concrete projects before gaining an idea of what “designing in atomic” really meant and what that was going to change in my everyday life as a designer.

In this article, I’ll go over a bit of what I’ve learned and what to keep in mind when designing systems of components with Atomic Design.

### For what kind of project ?

For me, every project, big or small can be designed with atomic in mind.

It gathers teams around a shared vision. The components are easy to reuse, edit and combine together so that the evolutions of the product will be simpler. And as for smaller projects… Well, every small project could one day become a big project, no?

I also think that, contrary to popular belief, the Atomic Design methodology is not just for web projects … Quite the opposite in fact! I was able to introduce Atomic Design into a personal project (an iOS app for cleaning your address book named [TouchUp](https://itunes.apple.com/fr/app/touchup/id1128944336?mt=8)) and the developer with whom I worked really appreciated this approach. It saved us a lot of time when we wanted to quickly develop and iterate the product.

And for those who wonder if it’s possible to build a system of components while still remaining creative, I recommend reading this article:“[Atomic Design & creativity](https://medium.com/@audreyhacq/atomic-design-creativity-28ef74d71bc6)”

### **How is this different than before?**

People often ask me:
*“But how is this different than the way we worked before?”*

I see Atomic Design as a slightly different approach to interface design but one which can make a great impact in the end.

> *The part shapes the whole and the whole shapes the part*

Until recently, we designed all the screens of a product, and then we cut it into small components to make specifications or UI Kits:

![](https://cdn-images-1.medium.com/max/800/1*3OFaoY-yLYdgPmO8AhejmQ.jpeg)

Before : we deconstructed screens to make components
One of the problem was that the components created in this way were not generic and they weren’t dependent on each other. The reuse of components was thus very limited: our design system was restrictive.

---

Today, the idea of Atomic Design is to begin with common raw material (atoms) with which we can build the rest of the project:

![](https://cdn-images-1.medium.com/max/800/1*yyN6Ki0646UcFLsDabUShw.jpeg)

Today: we start from atoms and we build the rest from there
We have thus not only an “air de famille” between all the screens, but also a system which offers infinite design possibilities!

### Everything start with brand identity

Now you might be wondering:
*“Where do we begin if we want to design in an atomic way?”*

To which I answer, rather logically: with atoms ;)

Thus the first thing which we are going to do is to create a unique visual language for our product that will be our starting point. This is what is going to define our atoms, our raw material and it is obviously very close from the brand identity.

This visual language must be strong, easy to build upon, and free itself from the medium on which it is going to be displayed; it has to be able to work everywhere!

The [Gretel agency](http://gretelny.com/work/netflix/), for example, made some remarkable work on the Netflix identity:

![](https://cdn-images-1.medium.com/max/800/1*Piomy-9oNTP0yT3VcmKH4w.png)

Netflix visual language: strong, recognizable and easy to build upon
And thanks to a strong identity, we feel that we have all the material to release our first atoms: colors, typographic choices, forms, shadows, spaces, rhythms, animations principles…

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
