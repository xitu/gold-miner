> * 原文地址：[Project Worlds — Achieving God Mode in Digital Design](https://uxdesign.cc/project-worlds-achieving-god-mode-in-digital-design-b7242dbe5770)
> * 原文作者：[Marek Minor](https://medium.com/@tristanminor)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/project-worlds-achieving-god-mode-in-digital-design.md](https://github.com/xitu/gold-miner/blob/master/TODO1/project-worlds-achieving-god-mode-in-digital-design.md)
> * 译者：
> * 校对者：

# Project Worlds — Achieving God Mode in Digital Design

> An abstract, simple but powerful way of thinking about systems based on how we perceive the world around us.

![](https://cdn-images-1.medium.com/max/6400/1*-VcoMexO96JKZvvujUxPUg.png)

Through this article I would like to share my findings from my ongoing 2 years of research into design systems and design tools called project **Worlds**.

Having said this, I realise I didn’t reinvent the wheel. I am aware that there are similar ideas, concepts and products floating around like [React](https://reactjs.org/), [Figma](https://www.figma.com), [Sketch](https://www.sketch.com/), [Modulz](https://www.modulz.app/) or [Framer X](https://www.framer.com). All of this might be nothing new for game developers either.

However, I think there’s much to be gained when looking at design systems from a (literally) different perspective. I want to look at these systems in such a way that, 100 years from now, it’ll still feel relevant and will put no cap on what’s possible.

Let’s dive in.

## Patterns Rule The World

Life is fluid and ever-changing. Everything around us is in a constant motion — planets orbiting around the sun, the constant weather changes, the way your body changes… Every moment, every situation is unique.

In order for our human brains to survive in such an overwhelming, ever-changing universe, we had to cut down on complexity and start simplifying. We became pretty good at recognising patterns, since they allow our brains to make shortcuts and make life easier (and actually liveable) without us getting overwhelmed.

Therefore, using patterns when designing is essential. You could say that **a design system is a system with a very high frequency of patterns** — colours, sizes, shapes, numbers, percentages... Any design can have some form of a design system in it. It’s just that what we usually call **design systems** are designs that have a much higher level of organisation than others. But before we continue, let’s get familiar with a few key concepts.

### Emergence

[Emergence](https://en.wikipedia.org/wiki/Emergence) is when more complicated stuff is **emerging** out of simpler stuff on a higher level. It’s like when a family is emerging out of its individual members, a picture is emerging out of individual pixels, or the way your body is emerging out of its individual parts. This means that **in order to build complex stuff, you need to start with smaller (dumber) parts**. How you set up your basic building blocks is really important.

This got me thinking — in order to make design tools more powerful, we may need to rebuild them **from the bottom**. I started asking myself if there‘s a complete set of basic particles or rules in design systems that, when set right, could give rise to complexity on a higher level, without really directing it from one central authority above.

[Emergence – How Stupid Things Become Smart Together](https://www.youtube.com/embed/16W7c0mb-rE?wmode=opaque&widget_referrer=https%3A%2F%2Fuxdesign.cc%2Fmedia%2Fa36a89cab939e54dfc586d0093b67301%3FpostId%3Db7242dbe5770&enablejsapi=1&origin=https%3A%2F%2Fcdn.embedly.com&widgetid=1):A highly recommended video about the concept of emergence. No seriously, go ahead and watch it!

### Chaos Theory

[Chaos theory](https://fractalfoundation.org/resources/what-is-chaos-theory/) is a branch of mathematics focusing on the behaviour of dynamical systems that are highly sensitive to initial conditions. What may look chaotic at first sight can in fact be very easily described. This means that you can **create really complicated stuff with immense variations out of just a handful of simple rules**. Usually the same pattern is being repeated on and on in different scales.

![](https://cdn-images-1.medium.com/max/2000/1*sOUyfU6wbCMTgWqis-oOgw.jpeg)

![](https://cdn-images-1.medium.com/max/4000/1*SZwqyABoXmimD5LfH3lETg.jpeg)

![](https://cdn-images-1.medium.com/max/2048/1*7cxFI9Tt1pw6iT1rGJIKoA.jpeg)

![](https://cdn-images-1.medium.com/max/2000/1*5E5GV8s8PGJCDbWHTvJPHg.jpeg)

### Information Theory

[Information theory](https://en.wikipedia.org/wiki/Information_theory) is the mathematical study of information coding through various different ways like sequences of symbols or impulses and of how rapidly this information can be transmitted. For me the main takeaway from this theory were the musings about what information really is, how meaning can be encoded and stored in basic building blocks, that in order to define something you have to explain the procedure of **how** to make it using these blocks, and this concept of an abstract world of metadata describing the world around us.

### Relativity

Relativity is the absence of standards of absolute and universal application. This means there is no universal truth to be said about anything. What you observe is different depending on where you observe it from — or who you are.

## Introducing: Worlds

Everything around us is a world of its own. A tree, a glass of water, a city, an app, a button, a colour, a typeface… Anything. We designers and developers use variables, functions, (React/Vue) components, classes, symbols or systems to encapsulate these concepts into reusable chunks. I would like to just call them **worlds**. It sounds simple and relatable, but encompassing, imaginative and powerful at the same time.

A world is like a reusable function. A box that will take input (or what’s called **props** in React), perform a manipulation on it and render the output. A simple world (**grey-500**) could take a colour (`#ccc`) and output the same value, acting as a swatch. A more complex world could take many inputs (size, type, state, layout, etc.) and output a button.

![](https://cdn-images-1.medium.com/max/2800/1*-AOTKkYq25BBoG7CkppIhQ.png)

A popular methodology for creating design systems is [Atomic Design](http://bradfrost.com/blog/post/atomic-web-design/). While I’m not entirely **against** the methodology — which consists of atoms, molecules, organisms, templates and pages — I do think it’s limiting. By using this strict division of levels, you limit yourself to a box. Everything you do will eventually pose the same structure.

The simpler the foundation, the bigger the playground.

Some worlds might be static and never change like the original **Mona Lisa** painting (at least the **idea** of it). You will always get the same thing. But most of the worlds can have their state changed. Imagine you have some controls which enable you to manipulate the output. Sometimes I imagine it’s like having a custom dashboard full of buttons and sliders and knobs, but it can be just as simple as tweaking the colour and size of a rectangle.

![](https://cdn-images-1.medium.com/max/2800/1*AJJLD_UVPHYALjj2ZeZXkQ.png)

By tweaking these controls you are changing the state what the world is in by adjusting its properties, or what I call **dimensions.**

## Dimensions and States of a World

**Dimensions**, or what is usually called **properties**, are lists of possibilities which combined together define what state the world is in. They are what makes worlds dynamic. The more dimensions (ie. size, colour, weight, etc.) — or dimension values (ie. `8px`, `20px`, `8%`, `20%`, `#000000`, `#efefef,` etc.) — the more possible states the world can be in.

![](https://cdn-images-1.medium.com/max/2800/1*AA0dQhoMx7rVUzSm358UXg.png)

A **static** world has no dimension. This means you have no control over the result and therefore you will always get the same result. An example of such a static world could be an image, if it always stays the same and you can’t perform any edits.

**Dynamic** worlds — the worlds you can manipulate — can have one or multiple dimensions. By combining these dimensions together, you can generate various versions of the same world for different occasions — for instance an icon,

![](https://cdn-images-1.medium.com/max/2800/1*nvCpBXDQlsBbxzty2jkaHQ.png)

a button,

![](https://cdn-images-1.medium.com/max/2800/1*PIsjKKFu3FsL8Mr1qz2t1g.png)

or a colour.

![](https://cdn-images-1.medium.com/max/2800/1*76-l2N0QuwF7dWosugCYYQ.png)

Let’s say you want to see all the possible states of a world. For instance seeing all possible states of a button. In order for you to see it, you need to calculate it first. You would count them by multiplying all the possible values of every dimension. If **S** is the number of all possible states and **Vₐ** is the number of all possible values in dimension A, then it would go like this:

S **=** Vₐ **\*** Vₐ * Vₐ * …

Or visually: one dimension with two possible states makes 2 possible states,

![](https://cdn-images-1.medium.com/max/2800/1*S2HtL3rxXhdUyVcgy1dhwg.png)

this makes 8 possible states (2*4),

![](https://cdn-images-1.medium.com/max/2800/1*wA2uQ793KoBT-IqDaUSjyw.png)

and this makes 16 possible states (2*4*2). Pretty straightforward stuff.

![](https://cdn-images-1.medium.com/max/2800/1*0-JFRJMpqrwx3YgoaeFWsA.png)

But usually, in complex worlds, there are so many states that it’s almost impossible to count them, for example a cup of water. To make things simple (and it still will be a system with a huge amount of possible states) let’s define it with just these 2 following dimensions:

* the material of the cup (glass or plastic)

* the amount of water (0–100ml)

![](https://cdn-images-1.medium.com/max/2800/1*930RzEm4ezNnBoVtJFihQw.png)

How would you count all the possible states of this world? The number of all possible materials is 2, so that’s simple. But there are too many possible states between 0 ml and 100 ml. There is an infinite amount of states.

For us to get to the state we want it to, it makes no sense of keeping track of all the possible states. You would just like to keep track of some of them, like with a button. All you need is to know is what those dimensions are, what they define and you will generate the world out of those combinations depending on your needs.

Now that we have defined worlds and their dimensions and states, let’s talk about the worlds’ trait that makes them so powerful — treating all worlds as **unique**.

## Every World Is Unique

There is a saying in programming: “**Don’t repeat yourself”**. That means everything you end up doing manually in a repetitive fashion should be automated. For me this also means there should be no doubles. **Everything should exist just once.** If you are referencing two entities and there is no difference between them, it’s the same individual entity. Every world, every dimension and every state of a world should be unique. A design system is in a way a network of relationships where every node exists just once.

For instance, if a colour `#1cc55f` is used in a Rectangle fill and Text fill, it should be pointing to the one and only colour. And I don’t mean a **colour** **style** or a **variable** — this colour exists just once, because it’s the one and same.

![](https://cdn-images-1.medium.com/max/2800/1*jdm9tJ7H-0eMyIC23DUHzw.png)

The same goes to dimensions — or what we usually call **properties**. If you are using a border radius in two objects, you are referencing it.

![](https://cdn-images-1.medium.com/max/2800/1*HWIMnJVmiivfezdwvvxDIQ.png)

So every time you use a value — a colour, a number, a corner radius — to create something new out of it (i. e. a button, a switch), you are referencing it. You could look at those values you use in your worlds as worlds as well. So in a way, we are building worlds from other worlds, which are made of other worlds, all the way **inside**.

## Complex Worlds Emerging out of Simple Ones

If you look at any design close enough, even at a microscopic level, all the way inside, it’s all made out of small, simpler worlds:

![](https://cdn-images-1.medium.com/max/2800/1*EhC8Yjxk0y6VGIAR9ARO8w.png)

If you look even closer, all the values are made out of numbers:

![](https://cdn-images-1.medium.com/max/2800/1*UKkedP_SD2UENNiIeukLtQ.png)

…if not pure 0’s and 1’s (but that’s not really important for us, since it’s too granular).

## Creating Your Own Worlds

Let’s zoom out a little bit and talk about worlds we regularly use when designing and building digital environments. On a smaller, more basic, a more “inner” level, you use simpler worlds, like Shape, Text or Image:

![](https://cdn-images-1.medium.com/max/2800/1*ayRDig-GT8j1Txomu8KxSQ.png)

You would use these smaller worlds to create larger worlds with some intention, like Button, Icon, Avatar,

![](https://cdn-images-1.medium.com/max/2800/1*zE4efCJdGen1QBZjPTNdkw.png)

or even larger and more complex, emerging out of more simple worlds, like List Items, Top Bars or Pages:

![](https://cdn-images-1.medium.com/max/2800/1*Sv8dv2S43k7csNB0eCOrng.png)

Just like you would tweak the dimensions of Shapes, Texts or Images,

![](https://cdn-images-1.medium.com/max/2800/1*xVUmYKf2vit2yzx4OUkr0g.png)

our tools should give us the means to create and tweak dimensions of our own worlds, whether they are small and relatively simple like Buttons, Icons or Avatars,

![](https://cdn-images-1.medium.com/max/2800/1*iDxf7nekKucg1blESDCgCQ.png)

Progress Bars, custom Text or Colour,

![](https://cdn-images-1.medium.com/max/2800/1*a0bcRffJBmGs_hbpYroFwg.png)

or more complex like List Items, Bars or Pages:

![](https://cdn-images-1.medium.com/max/2800/1*sXnq6MYHmFRdAn0KVRLL5w.png)

Our tools should enable us to create anything out of basic already existing elementary worlds, so the complex will emerge out of just a few basic building blocks.

## There’s No Hierarchy — Just a List of Possibilities

So, how does this “world-in-worlds-in-worlds” structure look like? If you’re familiar with the way HTML objects are rendered in [DOM](https://en.wikipedia.org/wiki/Document_Object_Model) (Document Object Model), or with React components, you would say it resembles a tree.

![](https://cdn-images-1.medium.com/max/2800/1*r40twjR3-Ma5MUniMsdnEg.png)

![Examples of structure in HTML and React components](https://cdn-images-1.medium.com/max/2800/1*kkMKItZe6idW0JnhYd_-vA.png)

But once you take this **everything is unique** philosophy really seriously into consideration, it starts getting a bit more complex and not really tree-like. A tree-like structure is looking at everything from only one perspective but with design systems there could be millions of them.

![](https://cdn-images-1.medium.com/max/2800/1*sQltac7lMa7NaLyF4rUJ0g.png)

In an environment where everything is unique and where basically any world can use almost any world, you need to have all of them ready and accessible from any position. You need to have a list of all the worlds and what you end up using will be based on your perspective.

To describe any design system (or system in general) you need a list of **all possible unique worlds, heavily referencing each other**.

![](https://cdn-images-1.medium.com/max/2800/1*sGCpuG5Em2duVHM-Vn1tDg.png)

You also can’t really remove a world that’s being referenced to by another world — otherwise things might break. You can’t remove a `#ccc` colour if you are using it in Rectangle, or remove Button if you are using it in Frame. You need to replace it with another world — this is what you usually do when you remove a Colour Style from an object in Figma.

## Perspective Matters

There is no hierarchy, unless you decide to observe one of the worlds. Since the list of all possible worlds in not a renderable tree, to actually render or show **something**, you need to pick one of the worlds — app, colour, size, number, button, anything. This world becomes an **observer** and you can render the view from the perspective of this world — either looking in or out.

![](https://cdn-images-1.medium.com/max/2800/1*RMkOF2VHC6UMECOpGwvDZQ.png)

This world will become the centre of your perspective. In a way, **you** and your observer are one. This means you could observe and control the view from the point of any of those worlds (colour, number, opacity, etc.) and **achieve almost impossible level of overview in your design**.

## The God Mode

A design system (or any system in general) could be described as a network of relationships where every node exists just once. Every world, every world’s dimension and every world’s state is unique.

Now, if you kept track of every world as an unique document, you could change any rule just once by either changing any unique document or changing any relationship between them. No more manually adjusting of 1000+ screens after the font of list item size has been changed.

This will allow you to look at your design system from a perspective of anything: all the colours,

![](https://cdn-images-1.medium.com/max/2800/1*pixyXcPc7PfeIs7rCqmjlw.png)

a specific colour,

![](https://cdn-images-1.medium.com/max/2800/1*vKAECrqowtMy0vFMa8GWvQ.png)

or a colour swatch/style,

![](https://cdn-images-1.medium.com/max/2800/1*VAPIKLi9HWkdXcEgCdshww.png)

and change any one of those things just once. Boom. You can create your own world structure to create whatever kind of structure and dependency you need — worlds will act as relayers, effectively changing the traffic of information and allowing you to change any kind of rule just once everywhere at the same time.

Additionally to some elementary worlds like a Frame, Text or Image, you should be able to create your own worlds, pointing to other worlds — something like what we call **variables** in code or **Colour Styles** in Figma. But this should be applied to any rule, not only colour or text styles. You should be able to sync anything, for instance strings,

![](https://cdn-images-1.medium.com/max/2800/1*1RcivOg9mtLmJU7EZ5UxpQ.png)

percentages,

![](https://cdn-images-1.medium.com/max/2800/1*17mLJo-s9DkeAUQOmaGhaA.png)

or sizes,

![](https://cdn-images-1.medium.com/max/2800/1*W61O5gfqs1vxzCFSUCQTRQ.png)

and do all of this manipulation in a highly visual way, with no coding required.

## Exploring vs. Consistency

Just like in Figma, Framer X or Sketch, with this approach you can either explore with no rules set or set a strict set of rules in the form of symbols, components, variables or styles to build your stuff with.

But what is really nice about this approach is that you could start exploring freely with no strings attached and then, at any given point, you can make it more strict and organised by finding the emerging patterns and encapsulating them as single individual rules. Go crazy, use any font sizes, colours or naming conventions you wish, you can always clean it up and organise at any given point. You could also do it vice versa: sprinkle a little bit of chaos into your strict design system rules.

This could be the answer for the everlasting conflict between free exploration and strict non-allowing rules of a design system — **an ability to find emerging patterns and pin them down** at any given point of the process.

## Design Assistant

I don’t think we need to build robots that will do all of our work for us. I think that what we need more are **assistants, that will help us being better at what we do** — all of us, including people with limited knowledge of design principles. And keeping track of every node, every rule and relationship in a design system would allow to make amazing assistive algorithms.

You could make algorithms that will analyse your design system and suggest to you what the program predicts that you will use. It would nudge you to use the stuff that’s already been used to create more consistency. In the most simple way, it could suggest a colour or a size based on how many times it was already used:

![](https://cdn-images-1.medium.com/max/2800/1*pMnAa0-uIC9N9SD8LaSsww.png)

As a more complex example, it might suggest a colour based on much more contextual metadata than how many times it is used — i. e. an object the colour is usually used on, the overall hue of all the colours, fill vs. stroke colour usage…

![](https://cdn-images-1.medium.com/max/2800/1*M9NDH_DpKQ6cTiDxL1zeHQ.png)

Or — when properly trained with metadata — give even more sophisticated suggestions based on various attributes:

![](https://cdn-images-1.medium.com/max/2800/1*8El4Bmy2JmvbouOUxu6fPA.png)

You might be able to analyse any design system (like Google’s Material Design) or a personal designer’s style and nudge the user to make choices that align with the defined “style”. This could help people that have no knowledge of design principles to learn by doing.

Our tools should nudge us into making not only more consistent choices, but also choices that contribute to accessibility and legibility. Imagine a design tool not allowing you to use an ineligible font colour — an accessibility baked right into the core of the design tool.

![](https://cdn-images-1.medium.com/max/2800/1*ucD9XP00wym2U087n7WvSg.png)

## ABC… Testing

Testing different versions and picking the best one is another part of the design process that could benefit from systematisation. Imagine having an option to literally split the whole design system in two or more parallel universes so that you can see the difference between those and test which one is better. Something like git, built right into the core of our design tools, but better.

![Splitting design system into multiverses based on choices to be made](https://cdn-images-1.medium.com/max/2800/1*FT-a96s9BTh1D8d3yXhSsQ.png)

This would be all possible thanks to us keeping track of every building block, every rule in the design system. You could continue making changes to any of the multiverses and they would all update, just because this difference is also an unique rule (or a collection of rules) acting independently of others. For instance, you could test as many different visual themes of an app totally independent from the whole UX process of setting up screen flows.

![](https://cdn-images-1.medium.com/max/2800/1*DPKVByhwS_2QKKtCgk7F9A.png)

## What Are Screens?

There is this clash between designers and programmers. When talking about flows, designers talk about **screens** or **pages** but programmers talk about **views** or **routes.** But we’re all just trying to do the same thing, right? So it should be probably one and the same. Or something in the middle. I do think there is a place in between where they meet and can coexist. I am convinced that **screens are snapshots of states of observed worlds,** created with intention — for instance to tell a story or to show an overview.

![](https://cdn-images-1.medium.com/max/2800/1*Z6HgBLYSWbK2CdOa8c8RBw.png)

By snapshot of **a state** of the whole environment I mean that there could be as many screens as there are possible states of the app. It’s just that some of those states are more “interesting” and “main” than the others — you don’t show every possible combination of a calendar picker in a booking screen, you just show the default one, or another one that you want to communicate something with.

A snapshot means that they are generated with intent. They are picked from all possible combinations to communicate a particular story. This means **you are not designing screens — you are designing dynamic worlds** and from those worlds you can generate stories or overviews by arranging a few selected snapshots next to each other. Screens are secondary, they are a byproduct of dynamic systems.

## A Small Note On Interactivity

Maybe you’ve already noticed I didn’t mention interactivity yet. So far all that I have described is a world of possibilities, where an observer can see an overview from any point of perspective but can’t really interact with it. This whole article is about **defining** design systems, not using them.

I have chosen not to talk about this because: a) I haven’t got my thoughts on interactivity sorted out yet, and b) it would be a huge and long undertaking to talk about it so it’s for another article. Stay tuned.

But what I am sure about — and this may seem like a “really?” moment — is that interactivity is emerging on a higher level out of all these discrete building blocks of design systems by adding time as another dimension. I would dare to define interaction as **being an observer that can travel through these allowed states in time-flows —** for example interacting with an app instance, testing how a particular button works, or just inspecting the blue colour swatch:

![](https://cdn-images-1.medium.com/max/2800/1*CFHHcYr2VIV3a0pgC5Wv-g.png)

Just like when 2D games were morphing into a 3D world, game developers initially thought it would be fairly easy to make games, given it’s just one more dimension added. This proved to be untrue, as making games in 3 dimensions brought so many new nuances into it, that it became much, much more difficult.

## How to Actually Build This Different Kind of a Design Tool

I have spent a huge amount of time trying to put this theory into practice and I made countless number of prototypes. This work-in-progress version I am going to show you is the closest I came to my vision. It doesn’t really matter what programming language is used to make this tool real. Or if this is a plugin for an already existing design tool. These ideas should be universal and applicable for use in any programming language or a design tool. This is my version of it.

### The Architecture

In order to build a design tool based on these ideas, I started thinking about what systems I need to have in place. This is what I came up with:

![](https://cdn-images-1.medium.com/max/2800/1*oUBMNX83EI5tJ83lmR2cGA.png)

* **Possibilities** — a place where you will set up **what** can exist and **how**. A place where all the masters and rules are. Think of this as a place where you **create** your design system — pick colours, font sizes, make buttons or switches, etc.

* **Instances —** a place where you manage **what really** exists. A place where you can create instances out of masters based on rules allowed in the Design System. Think of this as a place where you actually **use** the design system you are creating — for instance by making an app or a website, just like in any other design tool out there.

* **Renderer —** algorithms that render what exists into a dynamic result in a real time.

* **(Dynamic) Result —** a place where you can interact with what you have made out of any perspective — see/manage a Button, a specific colour or the whole App.

Alternatively, Possibilities and Instances are mixed together in the tool’s interface so you can manage your design system by using it — just like you add a colour style straight in Figma’s toolbar without going into a separate screen. But what interface is this having is not really important — all I am saying is you need to have these systems in place. How will these systems manifest in UI is a thing of an opinion.

### Storing The Truth in Unique Documents

Another thing you need is a database with a list of documents for every world, dimension or state. It’s quite easy: all you need is lots and lots of documents with keys and values, where most of the keys and values are just references to other documents. In a way, **any design system (or system in general) could be seen as metadata about metadata**.

![](https://cdn-images-1.medium.com/max/2800/1*XRHKmKwo0MFJH-ISK-SfCw.png)

You don’t really want to design things from scratch. You need some elementary documents to build your own worlds from, for instance:

![](https://cdn-images-1.medium.com/max/2800/1*3zj0XuoGbMbWHw2jZFGY2A.png)

The same goes for dimensions, for instance:

![](https://cdn-images-1.medium.com/max/2800/1*wm1LMTkWr7L1C85z5-MUCw.png)

And these elementary worlds will become documents :

![](https://cdn-images-1.medium.com/max/2800/1*VP1REi3d6DkVOUVwgIY08w.png)

Here’s a more detailed example for those who want to look closer:

![](https://cdn-images-1.medium.com/max/10928/1*IxhWaifBfZf6CnQMtTBP3Q.png)

## Summary

In conclusion:

1. Every unique reusable building block in design system is a **world**.

2. A world takes input, performs a manipulation on it and gives an output.

3. Worlds are defined by their manipulable inputs called **dimensions.** All the values of these dimensions together define its **state**.

4. By keeping track of all these unique worlds, some really powerful stuff happens. You could change anything (rule, colour, shape, image, name, opacity) just once, and apply it to all the other things.

5. Interaction is emerging out of these building blocks by adding an observer in a dimension of time. It’s a huge topic for another time.

![It’s all worlds in worlds in worlds in worlds…](https://cdn-images-1.medium.com/max/2800/1*GwzN3f_DAige-7OPwQRNRw.png)

Design tools nowadays try to get from this place (A) where everything is being drawn, painted and static into an interactive place (B) where things are being programmed, dynamic and interactive. I am convinced that there is another, better way. With project Worlds I started in the abstract state of mind (C), where pure information is being represented and manipulated.

![](https://cdn-images-1.medium.com/max/2800/1*7Sw-OAbtvFyKy5Dg-9bZ8Q.png)

I believe that if we really get to understand how we perceive the world around us in an extremely organised way and use this effectively to our advantage, nothing is out of reach.

—

So what do you think about this? Let me know in the comments below or follow me on [Twitter](https://twitter.com/TristanMinor).

––

**Big thank you to [Daniël van der Winden](https://twitter.com/dvdwinden) and [Ivana Žišková](https://twitter.com/fluidpills) for helping out with the article.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
