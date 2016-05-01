>* 原文链接 : [How we use BEM to modularise our CSS](https://m.alphasights.com/how-we-use-bem-to-modularise-our-css-82a0c39463b0#.qjqyfixfr)
* 原文作者 : [Andrei Popa](https://medium.com/@deioo)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



### How we use BEM to modularise our CSS

If you’re not familiar with BEM, it’s a naming methodology that provides a rather strict way to arrange CSS classes into independent components. It stands for _Block Element Modifier_ and a common one looks like this:

    .block {}
    .block__element {}
    .block--modifier {}
    .block__element--modifier {}

The principles are simple — a **Block** represents an object _(a person, a login form, a menu)_, an **Element** is a component within the block that performs a particular function _(a hand, a login button, a menu item)_ and a **Modifier** is how we represent the variations of a block or an element _(a female person, a condensed login form with hidden labels, a menu modified to look differently in the context of a footer)_.

There are plenty of resources online that explain the methodology in more detail ([https://css-tricks.com/bem-101/](https://css-tricks.com/bem-101/), [http://getbem.com/naming/](http://getbem.com/naming/)). In this article we’ll be focusing on describing the challenges we had implementing it in our projects.

![](https://cdn-images-1.medium.com/max/2000/1*SKT3ZS6CRReXfuYORkr53g.jpeg)

Before we decided to port our styles and use the Block-Element-Modifier methodology, it all started with a bit of research. Looking around, we found tens of articles and resources, mixins and documentation that seemed to answer all possible questions. It was pretty clear we found our new BFF.

But once you go deeply into building something to scale, it gets pretty confusing. And the more you try to battle it and make it work, the worse it gets — unless you don’t see it and treat it as your friend. Our story starts a couple of months ago when we met BEM. We went out, introduced ourselves, then lured it into working with us on a little corner side project. We connected well, so it was decided — we like it and we want to take this friendship to another level.

The process we followed was relatively simple and somehow natural. We’ve experimented with _naming conventions_ and _manually created stylesheet classes_. After deciding on a s_et of guidelines_, we’ve created basic mixins to _generate the class names_, without having to pass the block name every time we add a new modifier or an element.

So our journey started with something like this:

![](http://ww1.sinaimg.cn/large/005SiNxygw1f3djsb5400j30je06odfx.jpg)

Then using a set of custom mixins we’ve converted the above to:

![](http://ww3.sinaimg.cn/large/005SiNxygw1f3dju9380fj30je04xq3a.jpg)

And then slowly, when more and more edge cases started to emerge, we’ve improved the mixins without having to change any of the existing code. Pretty neat.

So if for example we want to define the list element in the context of the full-size modifier, we would do this:

![](http://ww3.sinaimg.cn/large/005SiNxygw1f3djvc8f5rj30jd08ewf6.jpg)

### How we do BEM in our backyard

We didn’t jump in and convert everything to follow this methodology. We took it gradually and started with scattered pieces until we saw a pattern.

Like any relationship, there must be understanding from both sides in order to make things work. Some of the guidelines we follow are part of the methodology and we don’t question, and some we’ve added on our own down the road.

The **ground rule** for us is that we **never nest blocks inside blocks and elements inside elements**. This is the one rule that we set to never to break.

The very deepest level of nesting for a single block is:

![](http://ww4.sinaimg.cn/large/005SiNxygw1f3djwmz8w8j30je03xwei.jpg)

If there’s need for more nesting, it means there’s too much complexity and the elements should be stripped down into smaller blocks.

Another rule here is in the way we convert elements into blocks. Following rule#1, we **split everything into smaller concerns.**

So let’s say we have this structure for a correspondence component:

![](http://ww4.sinaimg.cn/large/005SiNxygw1f3djwmz8w8j30je03xwei.jpg)

First we create the structure for the higher-level block:

![](http://ww3.sinaimg.cn/large/005SiNxygw1f3djzbvfl8j30jj02wjrg.jpg)

Then we repeat the process for the smaller, inner structures:

![](http://ww3.sinaimg.cn/large/005SiNxyjw1f3dk19r5m5j30jg03fdg4.jpg)

If the title becomes more complex, we just extract that into yet another smaller concern:

![](http://ww4.sinaimg.cn/large/005SiNxygw1f3dk2w9mdej30jf03cdg4.jpg)

And then add more complexity — let’s say we want the actions to be displayed on hover:

![](http://ww1.sinaimg.cn/large/005SiNxyjw1f3dk3szxamj30jf079t9b.jpg)

After everything is done, if we follow the code back to our stylesheet, it’s going to be laid out nicely, like this:

![](http://ww2.sinaimg.cn/large/005SiNxyjw1f3dk4eqsjaj30jg053js2.jpg)

And there’s nothing stopping us to clean some of the semantics that are not necessary. Since our item is clearly part of a list and there is no other item in the context of the correspondence, we can rename it to **_correspondence-item_**:

![](http://ww4.sinaimg.cn/large/005SiNxygw1f3dk6qvkodj30jf02wmxf.jpg)

This is another guideline we use — **simplify the naming** of BEM blocks for nested components if it doesn’t conflict with other blocks.

_For example, we don’t do it for the item-title, since we could actually have a correspondence-title on the main block or a title inside the preview. It’s just too generic._

### The Mixins

The mixins that we’re using above are part of Paint, our internal styles library.

They can be found here:[  
https://github.com/alphasights/paint/blob/develop/globals/functions/_bem.scss](https://github.com/alphasights/paint/blob/develop/globals/functions/_bem.scss)

_Paint is available as a bower/NPM package and it’s undergoing a core redesign. The BEM mixins are still usable and maintained regularly._

#### Why do we need mixins in the first place?

Our aim was to make the CSS class generation system extremely simple, as we knew front-end and back-end developers don’t need to spend much time building stylesheets. So we’ve automated the process as much as possible.

At the moment we’re developing a set of helper components that would do the same thing for the templates — provide a way to define blocks, elements and modifiers, then generate the markup classes automatically, as we do in CSS_._

#### How things work

We have a function **__bem-selector-to-string_** that turns a selector into a string for easy processing. Sass _(rails)_ and LibSass _(node)_ seem to handle selector strings differently. Sometimes the class name dot is added to the string, so we make sure we strip that before any further processing, as a matter of precaution.

The function that we use to check if a selector has a modifier is **__bem-selector-has-modifier_**. It returns _true_ if the modifier separator is found or if the selector contains a pseudo-selector _(:hover, :first-child etc.)._

The last function fetches the block name from a string that contains a modifier or pseudo-selector. The **__bem-get-block-name_** would return **_correspondence_** if **_correspondence — full-size_** is passed. We need the block name when we work with elements inside modifiers, otherwise we would have a hard time generating the proper class names.

The **_bem-block_** mixin generates a basic class with the block name and the passed properties.

The **_bem-modifier_** mixin creates a **_.block — modifier_** class name.

The **_bem-element_** mixin does a bit more. It checks if the parent selector is a modifier _(or contains a pseudo-selector)._ If it does, then it generates a nested structure containing the **_block — modifier_** with the **_block__element_** inside. Otherwise it creates a **_block__element_** directly.

_For elements and modifiers we currently use an_ **@each <script type="math/tex" id="MathJax-Element-2">element in</script> elements** _but we would optimise this in the next versions to allow sharing the same properties instead of duplicating them on each element._

### What we enjoy about BEM

#### Modularity

It’s very hard to restrain from adding too much logic to a component. With BEM, there’s not much choice, which most of the time is a good thing.

#### Clarity

When looking at the DOM, you can easily spot where’s the block, what’s the element and if any modifiers are applied. Similarly, when looking at a component stylesheet, you can easily get to where you need to make a change or add more complexity.

![](https://cdn-images-1.medium.com/max/800/1*rF5RDVUI-gNxZVdmkzZ-uA.png)

Sample blocks structure of an interaction participants component

![](http://ww1.sinaimg.cn/large/005SiNxygw1f3dko8pufuj30m80i0tbh.jpg)

A block with elements and modifiers

#### Team Work

Working on the same stylesheet makes it quite hard to avoid conflicts. But when using BEM, everyone can work on their own set of blocks-elements, so there’s really no getting in the way of another.

#### Principles

When writing CSS, we have a set of principles / rules that we like to follow. BEM enforces some of those by default, which makes writing code even easier.

**1\. The Separation of Concerns**

BEM forces us to separate styles into smaller, maintainable block components that contain elements and modifiers. If the logic gets too complicated, it should be split into smaller concerns. Rule #2.

**2\. The Single Responsibility Principle**

Each of the blocks has a single responsibility and that responsibility is encapsulated in the content of the component.

For the initial example, the correspondence is in charge of setting the grid for the list and preview elements. We don’t share that responsibility with outer concerns or inner concerns.

Following this approach, if the grid changes, we only change it in the context of the correspondence. Every other module would still work.

**3\. DRY**

Every time we stumble upon code duplication, we extract things into placeholders and mixins. If it’s something we DRY within the current scope _(things reused in the context of a component)_ the pattern is to define mixins and classes prefixed with underscore.

Remember not to over engineer your code and separate coincidental occurrence of properties from actual code duplication.

**4\. The Open/Close Principle**

This principle is quite hard to break when working with BEM. It states that everything should be open for extension and closed for modification. We avoid changing properties of a block directly, in the context of other blocks. We instead create modifiers to serve that purpose.

* * *

BEM is a powerful methodology, but I think the secret is to make it your own. If something doesn’t work out of the box, find out what does work and try to bend the rules. As long as it brings structure and improves productivity, there’s definitely value in implementing it.

* * *

We would love to hear from anyone using BEM to see what challenges you’re faced with.

