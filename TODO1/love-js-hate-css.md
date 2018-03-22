> * 原文地址：[Love JavaScript, but hate CSS?](https://daveceddia.com/love-js-hate-css/)
> * 原文作者：[Dave Ceddia](https://daveceddia.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/love-js-hate-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/love-js-hate-css.md)
> * 译者：
> * 校对者：

# Love JavaScript, but hate CSS?

![Love JS, Hate CSS](https://daveceddia.com/images/love-js-hate-css.png)

A reader wrote in to say that he was having great fun with JS and React, but when it came to styling, he was at a loss.

> I love JavaScript but hate CSS. I just don’t have the patience to make something look good.

Writing code is fun. Solving problems is fun. That feeling of bliss when you finally get the computer to do what you want? Awesome.

But then: _oh crap, the CSS_. The app works fine but it looks terrible, and nobody will take it seriously because it doesn’t Look Like Apple(TM).

## You’re Not Alone

First, I want to get this out there: if you like everything about front end development _except CSS_, you are not alone. I have known real actual professional UI developers _with jobs_ that were either rubbish at styling, or could _do_ it but they held their nose and tried to get it over with as quickly as possible.

I was in that spot a few years ago. CSS was like a magical black box where I’d type things in and it would, at least 60% of the time, spit out something that looked worse than when I started. I solved most CSS problems with Google and StackOverflow and hoping like crazy that someone had encountered my exact problem before (somehow, they usually had).

But I’ve since emerged from that dark place, and I can say that CSS (and the process of applying styles to a page) is a learnable skill. Even _design_ is a learnable skill. And for the record, they are different skills.

## Styling is not Design

The process of taking an existing visual design and writing the CSS to transform a hunk of `div`s to match the visual design is called **styling**.

The process of taking a blank canvas and coming up with a beautiful looking web site is called **design**.

You can be good (even very good) at one of these while simultaneously being very bad at the other.

To be a front end developer, you need some styling (CSS) skills but not necessarily design skills.

## Can you avoid CSS?

I wish I could tell you that you could forget all about CSS and stay in JS land 100% of the time.

But in truth, I can’t do that. If you want to do front end development you’ll eventually need to get your hands dirty and learn you some CSS.

I can tell you from experience though that CSS sucks a lot less once you understand a little bit about it. It can even be fun! I find it satisfying when I can get a page laid out just right, and know just which parameters to tweak to make it look the way I want.

## What To Do

While you can’t avoid CSS entirely, there are a few things that can make styling less sucky.

### Frameworks

CSS frameworks can help you get projects started quickly, and even make up for a lack of design skills. They are usually available as installable libraries with npm/yarn, or from a CDN. Each one has its own visual style, so you’ll want to weigh the appearance of each when you make a choice. CSS frameworks help you build a nice-looking app without fussing over styles (much).

Here are some popular choices (I’m focusing on ones that work nicely with React):

*   [Bootstrap](https://getbootstrap.com/) - Extremely popular (read: lots of questions and answers on SO) and decent looking. The latest version (v4) is more modern looking, but the older ones can look a bit dated these days. You can customize it with some of your own CSS, or use free and [paid themes](https://themes.getbootstrap.com/) to change the look. If you’re using React, have a look at [react-bootstrap](https://react-bootstrap.github.io/getting-started/introduction) for a bunch of pre-made components like modal dialogs, popovers, forms, etc.

*   [Semantic UI](https://react.semantic-ui.com/introduction) - Another popular CSS framework with React components, it has a few more components available than Bootstrap, and (I think) a more modern look.

*   [Blueprint](http://blueprintjs.com/) - I think Blueprint looks great, and to my eyes, better than Bootstrap or Semantic UI. But I haven’t used it myself. One thing that stands out with Blueprint is that it is written in (and supports) TypeScript. It doesn’t _require_ TypeScript, but if you’re using TS it might be worth a look.

There are a _ton_ of CSS frameworks available. Here’s [a list](https://hackernoon.com/the-coolest-react-ui-frameworks-for-your-new-react-app-ad699fffd651) with more that work with React.

While frameworks might help you avoid touching much CSS at all, these next two things will let you work more easily with CSS directly.

### Flexbox

Flexbox layout is a modern way to lay out content using CSS, much easier to use than the `float`s of old (or the random stabbing in the dark you were doing 5 minutes ago). It has [good browser support](https://caniuse.com/#search=flexbox) and makes it dead-simple to do some things that have traditionally been a big pain with CSS, like **vertically centering things**.

Take a look at this:

Look how nicely centered that little red square is! The outer box with the gray border just needs these 3 lines of CSS to make that happen:

```
display: flex;           /* turn flexbox on */
justify-content: center; /* center horizontally */ 
align-items: center;     /* center vertically */
```

If you right-click it and Inspect Element, you’ll see that it has more than those 3 lines… but they’re not responsible for centering the red box. That additional stuff gives it the gray border, makes it a square, centers it horizontally within this blog post (`margin: 0 auto`), and the bottom margin gives it some breathing room from the text below.

CSS Tricks has a great [Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) if you’re interested in learning more. I suggest checking it out! Flexbox really helped me get a grip on CSS and it’s my go-to tool for solving most layout problems now.

### CSS Grid

Grid is an even more modern way to do layout, and more powerful than flexbox. It can handle 2 dimensions (rows and columns) whereas flexbox is better at doing one direction or the other. Browser support is [pretty good](https://caniuse.com/#feat=css-grid). Accoding to CSS Tricks:

> As of March 2017, most browsers shipped native, unprefixed support for CSS Grid: Chrome (including on Android), Firefox, Safari (including on iOS), and Opera. Internet Explorer 10 and 11 on the other hand support it, but it’s an old implementation with an outdated syntax. The time to build with grid is now!

As I write this, I have only barely fiddled around with CSS grid for layout. Being more powerful than flexbox, it’s a bit more complex, and I’ve found flexbox suits my needs well enough most of the time. It’s on my list to learn though!

You can read CSS Tricks’ [Complete Guide to CSS Grid](https://css-tricks.com/snippets/css/complete-guide-grid/) to learn more.

### A Logical Approach

This is sort of a bonus meta “strategy” for dealing with CSS. As much as you can, try to avoid the random stabbing in the dark and copying-and-pasting from StackOverflow to get your layouts looking right.

Try taking a more methodical approach.

*   get the item into position (flexbox, grid, or maybe absolutely positioned inside a relative container)
*   set its margins and padding
*   set the border
*   set a background color
*   then [draw the rest of the owl](http://knowyourmeme.com/memes/how-to-draw-an-owl) - add box shadows, set :hover/:active/:focus states, etc.

![Draw the rest of the owl](https://daveceddia.com/images/draw-an-owl.jpg)

In some ways, software engineering principles like [DRY (Don’t Repeat Yourself)](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) and the [Law of Demeter](https://en.wikipedia.org/wiki/Law_of_Demeter) can apply to styling elements on a page. As an example, consider this layout for a user’s message with their avatar:

![Layout for a message with user avatar](https://daveceddia.com/images/css-layout-dry-example.png)

Notice that everything is 20 pixels away from the edges of the box. One way to achieve this would be to set the `margin` of both elements in the box to `20px`.

But that has some downsides. First off, there’s repetition: what happens if that margin needs to change? Gotta change it in 2 places!

Secondly, shouldn’t it be the box’s “responsibility” to determine how far inset its elements are, rather than leaving it up to each element to decide its own distance from an edge?

A better way to do this layout would be to set the box’s `padding` to `20px`, so then the contents can be blissfully unaware of where they need to be. This also makes it easier to add new elements inside the box too – you don’t need to explicitly tell each element where to place itself.

This is a tiny example just to illustrate the point, which is that a bit of forethought and a logical approach can make styling go much more smoothly.

## Action Steps!

1.  Find 3 layouts to copy. These could be small elements of sites you use (a single tweet, a Pinterest card, etc) or they could be physical things like a credit card or a book cover.
2.  Read the [Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/).
3.  Use flexbox to create the layouts you picked in Step 1.

- [Follow @dceddia](https://twitter.com/intent/follow?screen_name=dceddia)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
