> * 原文地址：[How To Learn CSS](https://www.smashingmagazine.com/2019/01/how-to-learn-css/)
> * 原文作者：[Rachel Andrew](https://www.smashingmagazine.com/author/rachel-andrew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-learn-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-learn-css.md)
> * 译者：
> * 校对者：

# How To Learn CSS

Quick Summary: You don’t need to commit to memorizing every CSS Property and Value, as there are good places to look them up. There are some fundamental things, however, which will make CSS much easier for you to use. This article aims to guide you along your path of learning CSS.

I get a lot of people asking me to recommend to them tutorials on various parts of CSS, or asking how to learn CSS. I also see a lot of people who are confused about bits of CSS, in part because of outdated ideas about the language. Given that CSS has changed quite substantially in the last few years, this is a really good time to refresh your knowledge. Even if CSS is a small part of what you do (because you work elsewhere in the stack), CSS is how things end up looking as you want them on screen, so it is worth being reasonably up to date.

Therefore, this article aims to outline the key fundamentals of CSS and resources for further reading on key areas of modern CSS development. Many of those are things right here on Smashing Magazine, but I’ve also selected some other resources and also people to follow in key areas of CSS. It’s not a complete beginner guide or intended to cover absolutely everything. My aim is to cover the breadth of modern CSS with a focus on a few key areas, that will help to unlock the rest of the language for you.

### Language Fundamentals

For much of CSS, you don’t need to worry about learning properties and values by heart. You can look them up when you need them. However, there are some key underpinnings of the language, without which you will struggle to make sense of it. It really is worth dedicating some time to making sure you understand these things, as it will save you a lot of time and frustration in the long run.

#### Selectors, More Than Just Class

A selector does what it says on the tin, it _selects_ some part of your document in order that you can apply CSS rules to it. While most people are familiar with using a class, or styling an HTML element such as `body` directly, there are a large number of more advanced selectors which can select elements based on their location in the document, perhaps because they come directly after an element, or are the odd rows in a table.

The selectors that are part of the Level 3 specification (you may have heard them referred to as Level 3 selectors) have [excellent browser support](https://caniuse.com/#feat=css-sel3). For a detailed look at the various selectors you can use, [see the MDN Reference](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors).

Some selectors act as if you had applied a class to something in the document. For example `p:first-child` behaves as if you added a class to the first `p` element, these are known as _pseudo-class_ selectors. The _pseudo-element_ selectors act as if an element was dynamically inserted, for example `::first-line` acts in a similar way to you wrapping a `span` around the first line of text. However it will reapply if the length of that line changes, which wouldn’t be the case if you inserted the element. You can get fairly complex with these selectors. In the below CodePen is an example of a pseudo-element chained with a pseudo-class. We target the first `p` element with a `:first-child` psuedo-class, then the `::first-line` selector selects the first line of that element, acting as if a span was added around that first line in order to make it bold and change the color.

See the Pen [first-line](https://codepen.io/rachelandrew/pen/wRdJdQ) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

#### Inheritance And The Cascade

The cascade defines which rule wins when a number of rules could apply to one element. If you have ever been in a situation where you can’t understand why some CSS doesn’t seem to be applying, it’s likely the cascade is tripping you up. The cascade is closely linked to inheritance, which defines which properties are inherited by the child elements of the element they are applied to. It is also linked to specificity; different selectors have different specificity which controls which wins when there are several selectors which could apply to one element.

**Note**: _To get an understanding of all of these things, I would suggest reading [The Cascade and Inheritance](https://developer.mozilla.org/en-US/docs/Learn/CSS/Introduction_to_CSS/Cascade_and_inheritance), in the MDN Introduction to CSS._

If you are struggling with getting some CSS to apply to an element then your browser DevTools are the best place to start, take a look at the example below in which I have an `h1` element targeted by the element selector `h1` and making the heading orange. I am also using a class, which sets the `h1` to rebeccapurple. The class is more specific and so the `h1` is purple. In DevTools, you can see that the element selector is crossed out as it does not apply. Once you can see that the browser is getting your CSS (but something else has overruled it), then you can start to work out why.

See the Pen [specificity](https://codepen.io/rachelandrew/pen/yGbMoL) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

[![The DevTools in Firefox showing rules for the h1 selector crossed out](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2720c905-e734-4d57-9ae8-fb4bab1de633/smashing-css-specificity.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2720c905-e734-4d57-9ae8-fb4bab1de633/smashing-css-specificity.png) 

DevTools can help you see why some CSS is not applying to an element ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2720c905-e734-4d57-9ae8-fb4bab1de633/smashing-css-specificity.png))

#### The Box Model

CSS is all about boxes. Everything that is displayed on the screen has a box, and the Box Model describes how the size of that box is worked out — taking into account margins, padding, and borders. The standard CSS Box Model takes the width that you have given an element, then adds onto that width the padding and border — meaning that the space taken up by the element is larger than the width you gave it.

More recently, we have been able to choose to use an alternate box model which uses the given width on the element as the width of the visible element on screen. Any padding or border will inset the content of the box from the edges. This makes a lot more sense for many layouts.

In the demo below, I have two boxes. Both have a width of 200 pixels, with a border of 5 pixels and padding of 20 pixels. The first box uses the standard box model, so takes up a total width of 250 pixels. The second uses the alternate box model, so is actually 200 pixels wide.

See the Pen [box models](https://codepen.io/rachelandrew/pen/xmdqjd) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

Browser DevTools can once again help you with understanding the box model in use. In the below image, I use Firefox DevTools to inspect a box using the default `content-box` box model. The tools tell me this is the Box Model in use, and I can see the sizing and how the border and padding is added to the width I assigned.

[![The Box Model Panel in Firefox DevTools](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52f5291d-fb2e-4418-99a7-002f898053aa/smashing-css-box-model.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52f5291d-fb2e-4418-99a7-002f898053aa/smashing-css-box-model.png) 

DevTools help you see why a box is a certain size, and the box model in use ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52f5291d-fb2e-4418-99a7-002f898053aa/smashing-css-box-model.png))

**Note**: _Prior to IE6, [Internet Explorer used the alternate Box Model](https://en.wikipedia.org/wiki/Internet_Explorer_box_model_bug), with padding and borders insetting content away from the given width. So for a while browsers used different Box Models! When frustrated by interoperability issues today, be glad that things have improved so we aren’t dealing with browsers calculating the width of things differently._

There is a good explanation of the [Box Model and Box Sizing](https://css-tricks.com/box-sizing/) on CSS Tricks, plus an explanation of the best way to [globally use the alternate box model](https://css-tricks.com/inheriting-box-sizing-probably-slightly-better-best-practice/) in your site.

#### Normal Flow

If you have a document with some HTML marking up the content and view it in a browser, it will hopefully be readable. Headings and paragraphs will start on a new line, words display as a sentence with a single white space between them. Tags for formatting, such as em, do not break up the sentence flow. This content is being displayed in [Normal Flow](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flow_Layout), or Block Flow Layout. Each part of the content is described as “in flow”; it knows about the rest of the content and so doesn’t overlap.

If you work with rather than against this behavior, your life is made much easier. It is one of the reasons why [starting with a correctly marked up HTML document](https://www.brucelawson.co.uk/2018/the-practical-value-of-semantic-html/) makes a lot of sense, as due to normal flow and the inbuilt stylesheets that browsers have which respect it, your content starts from a readable place.

#### Formatting Contexts

Once you have a document with content in normal flow, you may want to change how some of that content looks. You do this by changing the formatting context of the element. As a very simple example, if you wanted all of your paragraphs to run together and not start on a new line, you could change the `p` element to `display: inline` changing it from a block to an inline formatting context.

Formatting contexts essentially define an outer and an inner type. The outer controls how the element behaves alongside other elements on the page, the inner controls how the children should look. So, for example, when you say `display: flex` you are setting the outer to be a block formatting context, and the children to have a flex formatting context.

**Note** : _The latest version of the Display Specification changes the values of `display` to explicitly declare the inner and outer value. Therefore, in the future you might say `display: block flex;` (`block` being the outer and `flex` being the inner)._

Read more about `display` [over at MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/display).

#### Being In Or Out Of Flow

Elements in CSS are described as being ‘in flow’ or ‘out of flow.’ Elements in flow are given space and that space is respected by the other elements in flow. If you take an element out of flow, by floating or positioning it, then the space for that element will no longer be respected by other in flow items.

This is most noticeable with absolutely positioned items. If you give an item `position: absolute` it is removed from flow, then you will need to ensure that you do not have a situation in which the out of flow element overlaps and makes unreadable some other part of your layout.

See the Pen [Out of Flow: absolute positioning](https://codepen.io/rachelandrew/pen/Ormgzj) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

However, floated items also are removed from flow, and while following content will wrap around the shortened line boxes of a floated element, you can see by placing a background color on the box of the following elements that they have risen up and are ignoring the space used by the floated item.

See the Pen [Out of flow: float](https://codepen.io/rachelandrew/pen/BvRZYw) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

You can read more about [in flow and out of flow elements on MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flow_Layout/In_Flow_and_Out_of_Flow). The important thing to remember is that if you take an element out of flow, you need to manage overlap yourself as the regular rules of block flow layout no longer apply.

### Layout

For over fifteen years we have been doing layout in CSS without a designed for the job layout system. This has changed. We now have a perfectly capable layout system which includes Grid and Flexbox, but also Multiple-column Layout and the older layout methods used for their real purpose. If CSS Layout is a mystery to you, head on over to the MDN [Learn Layout](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout) tutorial, or read my article [Getting Started With CSS Layout](https://www.smashingmagazine.com/2018/05/guide-css-layout/) here on Smashing Magazine.

**Do not imagine that methods such as grid and flexbox are somehow competing**. In order to use Layout well, you will sometimes find a component is best as a flex component and sometimes as Grid. On occasion, you will want the column flowing behavior of multicol. All of these are valid choices. If you feel you are fighting against the way something behaves, that is, in general, a very good sign that it might be worth taking a step back and trying a different approach. We are so used to hacking at CSS to make it do what we want that we are likely to forget that we have a number of other options to try.

Layout is my main area of expertise and I’ve written a number of articles here on Smashing Magazine and elsewhere to try and help tame the new Layout landscape. In addition to the Layout article mentioned above, I have a whole series on Flexbox — start with [What Happens When You Create a Flexbox Flex Container](https://www.smashingmagazine.com/2018/08/flexbox-display-flex-container/). On [Grid By Example](https://gridbyexample.com), I have a whole bunch of small examples of CSS Grid — plus a video screencast tutorial.

In addition — and especially for designers — check out [Jen Simmons](https://twitter.com/jensimmons) and her [Layout Land video series](https://www.youtube.com/channel/UC7TizprGknbDalbHplROtag).

#### Alignment

I’ve separated Alignment out from Layout in general because while most of us were introduced to Alignment as part of Flexbox, these properties apply to all layout methods, and it is worth understanding them in that context rather than thinking about “Flexbox Alignment” or “CSS Grid alignment.” We have a set of Alignment properties which work in a common way where possible; they then have some differences due to the way different layout methods behave.

On MDN, you can dig into [Box Alignment](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Box_Alignment) and how it is implemented for Grid, Flexbox, Multicol, and Block Layout. Here on Smashing Magazine, I have an article specifically covering alignment in Flexbox: [Everything You Need To Know About Alignment In Flexbox](https://www.smashingmagazine.com/2018/08/flexbox-alignment/).

#### Sizing

I spent much of 2018 speaking about the Intrinsic and Extrinsic Sizing specification, and how it relates to Grid and Flexbox in particular. On the web, we are used to setting sizing in lengths or percentages, as this is how we have been able to make Grid-type layouts using floats. However, modern layout methods can do a lot of the space distribution for us — if we let them. Understanding how Flexbox assigns space (or the Grid `fr` unit works), is worth your time.

Here on Smashing Magazine, I’ve written about [Sizing in Layout](https://www.smashingmagazine.com/2018/01/understanding-sizing-css-layout/) in general and also for Flexbox in [How Big Is That Flexible Box?](https://www.smashingmagazine.com/2018/09/flexbox-sizing-flexible-box/).

### Responsive Design

Our new layout methods of Grid and Flexbox often mean that we can get away with fewer media queries than we needed with our older methods, due to the fact that they are flexible and respond to changes in viewport or component size without us needing to change the widths of elements. However, there will be places where you will want to add in some breakpoints to further enhance your designs.

Here are some simple guides to [Responsive Design](https://responsivedesign.is/), and for media queries, in general, check out my article [Using Media Queries for Responsive Design in 2018](https://www.smashingmagazine.com/2018/02/media-queries-responsive-design-2018/). I take a look at what Media Queries are useful for, and also show the new features coming to Media Queries in Level 4 of the spec.

### Fonts And Typography

Along with Layout, the use of fonts on the web has undergone huge change in the last year. Variable Fonts, enabling a single font file to have unlimited variations, are here. To get an overview of what they are and how they work, watch this excellent short talk from [Mandy Michael](https://twitter.com/mandy_kerr): [Variable Fonts and the Future of Web Design](https://www.youtube.com/watch?v=luAqYCd_TC8). Also, I would recommend [Dynamic Typography With Modern CSS and Variable Fonts](https://noti.st/jpamental/WNNxqQ/dynamic-typography-with-modern-css-variable-fonts) by [Jason Pamental](https://twitter.com/jpamental).

To explore Variable Fonts and their capabilities, there is [a fun demo from Microsoft](https://developer.microsoft.com/en-us/microsoft-edge/testdrive/demos/variable-fonts/) plus a number of playgrounds to try out Variable Fonts — [Axis Praxis](https://www.axis-praxis.org/) being the most well known (I also like the [Font Playground](https://play.typedetail.com/)).

Once you start working with Variable Fonts, then [this guide on MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Fonts/Variable_Fonts_Guide) will prove incredibly useful. To learn how to implement a fallback solution for browsers which does not support Variable Fonts read [Implementing a Variable Font With Fallback Web Fonts](https://www.zeichenschatz.net/typografie/implementing-a-variable-font-with-fallback-web-fonts.html) by Oliver Schöndorfer. The [Firefox DevTools Font Editor](https://developer.mozilla.org/en-US/docs/Tools/Page_Inspector/How_to/Edit_fonts) also has support for working with Variable Fonts.

### Transforms And Animation

CSS Transforms and Animation are definitely something I look up on a need-to-know basis. I don’t often need to use them, and the syntax seems to hop right out of my head between uses. Thankfully, the reference on MDN helps me out and I would suggest starting with the guides on [Using CSS Transforms](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Transforms/Using_CSS_transforms) and [Using CSS Animations](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Animations/Using_CSS_animations). [Zell Liew](https://twitter.com/zellwk) also has a nice article that provides a great [explanation to CSS transitions](https://zellwk.com/blog/css-transitions/).

To discover some of the things that are possible, take a look at the [Animista](http://animista.net/) site.

One of the things that can be confusing about animations, is which approach to take. In addition to what is supported in CSS, you might need to involve JavaScript, SVG, or the Web Animation API, and these things all tend to get lumped together. In her talk, [Choose Your Animation Adventure](https://aneventapart.com/news/post/choose-your-animation-adventure-by-val-head-aea-video) recorded at An Event Apart, [Val Head](https://twitter.com/vlh) explains the options.

### Use Cheatsheets As A Reminder, Not A Learning Tool

When I mention Grid or Flexbox resources, I often see replies saying that they _can’t_ do Flexbox without a certain cheatsheet. I have no problem with cheatsheets as a memory helper to look up syntax, and I’ve published some of my own. The problem with entirely relying on those is that you can miss why things work as you copy syntax. Then, when you hit a case where that property seems to behave differently, that apparent inconsistency seems baffling, or a fault of the language.

If you find yourself in a situation where CSS seems to be doing something very strange, ask _why_. Create a reduced test case that highlights the issue, ask someone who is more familiar with the spec. Many of the CSS problems I am asked about are because that person believes a property works in a different way to the way it works in reality. It’s why I talk a lot about things like alignment and sizing, as these are places where this confusion often lives.

Yes, there are strange things in CSS. It is a language that has evolved over the years, and there are things about it that we can’t change — [until we invent a timemachine](https://wiki.csswg.org/ideas/mistakes). However, once you have some basics down, and understand why things behave as they do, you will have a much easier time with the trickier places.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
