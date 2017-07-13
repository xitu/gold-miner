
> * 原文地址：[CSS Isn’t Black Magic](https://medium.freecodecamp.org/its-not-dark-magic-pulling-back-the-curtains-from-your-stylesheets-c8d677fa21b2)
> * 原文作者：[aimeemarieknight](https://medium.freecodecamp.org/@aimeemarieknight)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/its-not-dark-magic-pulling-back-the-curtains-from-your-stylesheets.md](https://github.com/xitu/gold-miner/blob/master/TODO/its-not-dark-magic-pulling-back-the-curtains-from-your-stylesheets.md)
> * 译者：
> * 校对者：

# CSS Isn’t Black Magic

## Pulling Back The Curtains on Your Stylesheets

![](https://cdn-images-1.medium.com/max/1600/1*TqpR80LFFl09NnOpISdXJg.jpeg)

If you’re a web developer, chances are you’re going to have to write some CSS from time to time.

When you first looked at CSS, it probably seemed like a breeze. You added some borders here, changed some colors there. JavaScript is the hard part of front end development, right?

Somewhere during your progression as a web developer, that changed though! What’s worse is that many developers in the front end community have come to dismiss CSS as a toy language.

The truth however is that when we hit a wall, many of us don’t actually understand what our CSS is doing under the hood.

For the first two years after my bootcamp, I did full stack JavaScript and sprinkled in some CSS here and there. As a panelist on [JavaScript Jabber](https://devchat.tv/js-jabber/my-js-story-aimee-knight), I always felt like JavaScript was my bread and butter, so it’s what I spent the most time on.

Last year however, I decided to focus on the front end and I realized that I just wasn’t able to debug my stylesheets in the same way I did my JavaScript!

We all like to make jokes about it, but how many of us have actually taken the time to try and understand the CSS we’re writing or reading. How many of us have actually reasonably debugged an issue to the next lowest abstraction layer when we hit a wall? Instead, we settle for the first StackOverflow answer, hacks, or we just let the issue go entirely.

All too often developers are left completely puzzled when the browser renders CSS in ways they didn’t expect. It’s not dark magic though and as developers we know that computers are just parsing our instructions.

Knowledge of internals can also be useful for advanced debugging and performance tuning. While many conference talks discuss how to fix common bugs, my talk (and this post) will focus on the why by taking a deep dive into browser internals to see how our styles are parsed and rendered.

### The DOM and CSSOM

First, it’s important to understand that browsers contain a JavaScript engine and a rendering engine. We will focus on the latter. For example, we’ll be discussing details that pertain to WebKit (Safari), Blink (Chrome), Gecko (Firefox), and Trident/EdgeHTML (IE/Edge). The browser will undergo a process that includes conversion, tokenization, lexing, and parsing which ultimately constructs the DOM and CSSOM.

At a high level you can think of them as the following:

- **Conversion**: Reading raw bytes of HTML and CSS off the disk or network.
- **Tokenization**: Breaking input into chunks (ex: start tags, end tags, attribute names, attribute values), striping irrelevant characters such as whitespace and line breaks.
- **Lexing**: Like the tokenizer, but it also identifies the type of each token (this token is a number, that token is a string literal, this other token is an equality operator).
- **Parsing**: Takes the stream of tokens from the lexer, interprets the tokens using a specific grammar, and turns it into an abstract syntax tree.

Once both tree structures are created, the rendering engine then attaches the data structures into what’s called a render tree as part of the layout process.

The render tree is a visual representation of the document which enable painting the contents of the page in their correct order. Render tree construction follows the following order:

- Starting at the root of the DOM tree, traverse each visible node.
- Omit non visible nodes.
- For each visible node find the appropriate matching CSSOM rules and apply them.
- Emit visible nodes with content and their computed styles.
- Finally, output a render tree that contains both the content and style information of all visible content on the screen.

The CSSOM can have drastic effects on the render tree but none on the DOM tree.

### Rendering

Following layout and render tree construction, the browser can finally proceed to actual painting of the screen and compositing. Let’s take a brief moment to distinguish between some terminology here.

- **Layout**: Includes calculating how much space an element will take up and where it is on screen. Parent elements can affect child elements and sometimes vice versa.
- **Painting**: The process of converting each node in the render tree to actual pixels on the screen. It involves drawing out text, colors, images, borders, and shadows. The drawing is typically done onto multiple layers and multiple rounds of painting can be caused by JavaScript being loaded that changes the DOM.
- **Compositing**: The action of flattening all layers into the final image that is visible on the screen. Since parts of the page can be drawn into multiple layers they need to be drawn to the screen in the correct order.

Painting time varies based on render tree construction and the bigger the width and height of the element, the longer the painting time will be.

Adding different effects can also increase painting time. Painting follows the order that elements are stacked in their stacking contexts (back to front) which we’ll get into when we talk about z-index later on. If you’re a visual learner, there’s a great painting [demo](https://www.youtube.com/watch?v=ZTnIxIA5KGw).

When people speak of hardware acceleration in browsers, they’re almost always referring to accelerated compositing which just means using the GPU to composite contents of a web page.

Compositing allows for pretty large speed increases versus the old way which used the computer’s CPU. The will-change property is one property that you can add that will take advantage of this.

For example, when using CSS transforms, the will-change property allows for hinting to the browser that a DOM element will be transformed in the near future. This enables offloading some drawing and compositing operations onto the GPU, which can greatly improve performance for pages with a lot of animations. It has similar gains for scroll position, contents, opacity, and top or left positioning.

It’s important to understand that certain properties will cause a relayout, while other properties only cause a repaint. Of course, performance wise it’s best if you can only trigger a repaint.

For example, changes to an element’s color will only repaint that element while changes to the element’s’ position will cause layout and repaint of that element, its children and possibly siblings. Adding a DOM node will cause layout and repaint of the node. Major changes, like increasing font size of an html element will cause a relayout and repaint of the entire tree.

If you’re like me you’re probably more familiar with the DOM than the CSSOM so let’s dive into that a bit. It’s important to note that by default CSS is treated as a render blocking resource. This means that the browser will hold rendering of any other process until the CSSOM is constructed.

The CSSOM is also not 1 to 1 with the DOM. Display none, script tags, meta tags, head element, etc. are omitted since they’re not reflected in the rendered output.

Another difference between the CSSOM and the DOM is that CSS parsing uses a context free grammar. In other words, the rendering engine does not have code that will fill in missing syntax for CSS like it will when parsing HTML to create the DOM.

When parsing HTML, the browser has to take into account surrounding characters and it needs more than just the spec since the markup could contain missing information but will still need to be rendered no matter what.

With all that said, let’s recap.

- Browser sends an HTTP request for page
- Web server sends a response
- Browser converts response data (bytes) into tokens, via tokenization
- Browser turns tokens into nodes
- Browser turns nodes into the DOM tree
- Awaits CSSOM tree construction

### Specificity

Now that we have a better understanding of how the browser is working under the hood, let’s take a look at some of the more common areas of confusion for developers. First up, specificity.

At a very basic level we know specificity just means applying rules in the correct cascade order. There are many ways to target a specific tag using CSS selectors though, and the browser needs a way to negotiate which styles to give to a specific tag. Browsers make this decision by first calculating each selectors specificity value.

Unfortunately specificity calculation has baffled many JavaScript developers, so let’s take a deeper dive into how this calculation is made. We’ll use an example of a div with a class of “container”. Nested inside that div we’ll have another div with an id of “main”. Inside that we’ll have a p tag that contains an anchor tag. Without peeking ahead, do you know what color the anchor tag will be?

    #main a {
      color: green;
    }

    p a {
      color: yellow;
    }

    .container #main a {
      color: pink;
    }

    div #main p a {
      color: orange;
    }

    a {
      color: red;
    }

The answer is pink, with a value of 1,1,1. Here are the remaining results:

- `div #main p a: 1,0,3`
- `#main a: 1,0,1`
- `p a: 2`
- `a: 1`

To determine the number, you need to calculate the following:

- **First number**: The number of ID selectors.
- **Second number**: The number of class selectors, attribute selectors (ex: `[type="text"]`, `[rel="nofollow"]`), and pseudo-classes (ex: `:hover`, `:visited`).
- **Third number**: The number of type selectors and pseudo-elements (ex: `::before`, `::after`).

So, for a selector that looks like this:

    #header .navbar li a:visited

The value will be 1,2,2 because we have one ID, one class, one pseudo-class, and two type selectors (`li`, `a`). You can read the values as if they were just a number, like 1,2,2 is 122. The commas are there to remind you that this isn’t a base 10 system. You could technically have a specificity value of 0,1,13,4 and 13 wouldn’t spill over like a base 10 system would.

### Positioning

Second, I want to take a moment to discuss positioning. Positioning and layout go hand in hand as we saw earlier in this post.

Layout is a recursive process that can be triggered on the entire render tree as a result of a global style change, or incrementally where only dirty parts of the page will be laid out over. One interesting thing to note if we think back to the render tree is that with absolute positioning, the object being laid out is put in the render tree in a different place than in the DOM tree.

I’m also asked frequently about using flexbox versus floats. Of course, flexbox is great from a usability standpoint, but when applied to the same element, a flexbox layout will render in roughly 3.5ms whereas a floated layout can take around 14ms. So, it pays to keep up with your CSS skills just as much as you do your JavaScript skills.

### Z-Index

Finally, I want to discuss z-index. At first, it sounds simple. Every element in an HTML document can be either in front of or behind every other element in the document. It also only works on positioned elements. If you try to set a z-index on an element with no position specified, it won’t do anything.

The key to debugging z-index issues is understanding stacking contexts, and to always start at the stacking contexts root element. A stacking context is just a three-dimensional conceptualization of HTML elements along an imaginary z-axis relative to the user facing the viewport. In other words, it’s groups of elements with a common parent that move forward or backward together.

Every stacking context has a single HTML element as its root element and when z-index and position properties aren’t involved, the rules are simple. The stacking order is the same as the order of appearance in the HTML.

You can however, create new stacking contexts with properties other than z-index and this is where things get complicated. Opacity, when it’s value is less than one, filter when its value is something other than none, and mix-blend-mode when its value is something other than normal will actually create new stacking contexts.

Just a reminder, blend mode determines how the pixels on a specific layer interact with the visible pixels on the layers below it.

The transform property also triggers a new stacking context when its value isn’t none. For example, `scale(1)` and `translate3d(0,0,0)`. Again, as a reminder the scale property is used to adjust size, and translate3d triggers the GPU into action for CSS transitions making them smoother.

So, you may still not have an eye for design, but hopefully now you’re walking away a CSS guru! If you’re interested in going even further, I’ve compiled additional resources which I also used [here](https://gist.github.com/AimeeKnight/77b36738ec876965c6db5c6d39f4ef4f).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
