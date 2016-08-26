> * 原文地址：[Writing Less Damn Code](http://www.heydonworks.com/article/on-writing-less-damn-code)
* 原文作者：[Heydon Pickering](http://www.heydonworks.com/about)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

I’m not the most talented coder in the world. No, it’s true. So I try to write as little code as possible. The less I write, the less there is to break, justify, or maintain.

I’m also lazy, so it’s all gravy. (_ed: maybe run with a food analogy?_)

But it turns out the only surefire way to make _performant_ Web Stuff is also to just write less. Minify? Okay. Compress? Well, yeah. Cache? Sounds technical. Flat out refuse to code something or include someone else’s code in the first place? **Now you’re talking.** What goes in one end has to come out the other in some form, whether it’s broken down and liquified in the gastric juices of your task runner or not. (_ed: I’ve changed my mind about the food analogy_)

And that’s not all. Unlike aiming for ‘perceived’ performance gains — where you still send the same quantity of code but you chew it up first (_ed: seriously_) — you can actually make your Web Stuff _cheaper_ to use. My data contract doesn’t care whether you send small chunks or one large chunk; it all adds up the same.

My _favorite_ thing about aiming to have less stuff is this: you finish up with only the stuff you really need — only the stuff your _user_ actually wants. Massive hero image of some dude drinking a latte? Lose it. Social media buttons which pull in a bunch of third-party code while simultaneously wrecking your page design? Give them the boot. That JavaScript thingy that hijacks the user’s right mouse button to reveal a custom modal? Ice moon prison.

It’s not just about what you pull in to destroy your UX or not, though. The _way_ you write your (own) code is also a big part of having less of it. Here are a few tips and ideas that might help. I’ve written about some of them before, but in terms of accessibility and responsive design. It just happens that a flexible, accessible Web is one we try to exert little of our own control over; one we do less to break.

## WAI-ARIA

First off, WAI-ARIA != web accessibility. It’s just a tool to enhance compatibility with certain assistive technologies, like screen readers, where it’s needed. Hence, the [first rule of ARIA use](https://www.w3.org/TR/aria-in-html/#first-rule-of-aria-use) is to _not_ use WAI-ARIA if you don’t have to.

LOL, no:

```

<div role="heading" aria-level="2">Subheading</div>

```

Yes:

```

<h2>Subheading</h2>

```

The benefit of using native elements is that you often don’t have to script your own behaviors either. Not only is the following checkbox implementation verbose HTML, but it needs a JavaScript dependency to control state changes and to [follyfill](https://twitter.com/heydonworks/status/765444886099288064) standard, basic behavior regarding the `name` attribute and `GET` method. It’s more code, and it’s less robust. Joy!

```

<div role="checkbox" aria-checked="false" tabindex="0" id="checkbox1" aria-labelledby="label-for-checkbox1"/>
<div class="label" id="label-for-checkbox1">My checkbox label</div>

```

[Styling? Don’t worry, you’re covered](http://wtfforms.com/). That’s if you really need custom styles, anyway.

```

<input type="checkbox" id="checkbox1" name="checkbox1">
<label for="checkbox1">My checkbox label</label>
</input>
```

## Grids

Do you remember ever enjoying using/reading a website with more than two columns? I don’t. Too much stuff all at once, begging for my attention. “I wonder which thing that looks like navigation is the navigation I want?” It’s a rhetorical question: my executive functioning has seized up and I’ve left the site.

Sometimes we want to put things next to things, sure. Like search results or whatever. But why pull in a whole tonne of grid framework boilerplate just for that? Flexbox can do it with no more than a couple of declaration blocks.

```

.grid {
  display: flex;
  flex-flow: row wrap;
}

.grid > * {
  flex-basis: 10em;
  flex-grow: 1;
}

```

Now everything ‘flexes’ to be approximately `10em` wide. The number of columns depends on how many approx’ `10em` cells you can fit into the viewport. Job done. Move on.

Oh and, while we’re here, we need to talk about this kind of thing:

```

width: 57.98363527356473782736464546373337373737%;

```

Did you know that precise measurement is calculated according to a mystical ratio? A ratio which purports to induce a state of calm and awe? No, I wasn’t aware and I’m not interested. Just make the porn button big enough that I can find it.

## Margins

[We’ve done this](http://alistapart.com/article/axiomatic-css-and-lobotomized-owls). Share your margin definition across elements using the universal selector. Add overrides only where you need them. You won’t need many.

```

body * + * {
  margin-top: 1.5rem;
}

```

No, the universal selector will not kill your performance. That’s bunkum.

## Views

You don’t need the whole of Angular or Meteor or whatever to divide a simple web page into ‘views’. Views are just bits of the page you see while other bits are unseen. CSS can do this:

```

.view {
  display: none;
}

.view:target {
  display: block;
}

```

“But single-page apps run stuff when they load views!” I hear you say. That’s what the `onhashchange` event is for. No library needed, and you’re using links in a standard, bookmark-able way. Which is nice. [There’s more on this technique, if you’re interested](https://www.smashingmagazine.com/2015/12/reimagining-single-page-applications-progressive-enhancement/).

## Font sizes

Tweaking font sizes can really bloat out your `@media` blocks. That’s why you should let CSS take care of it for you. With a single line of code.

```

font-size: calc(1em + 1vw);

```

Err… that’s it. You even have a minimum font size in place, so no tiny fonts on handsets. Thanks to [Vasilis](https://twitter.com/vasilis) for showing me this.

## [10k Apart](https://a-k-apart.com/)

Like I said, I’m not the best coder. I just know some tricks. But it is possible to do a hell of a lot, with only a little. That’s the premise of the [10k Apart competition](https://a-k-apart.com/) — to find out what can be made with just 10k or less. There are big prizes to be won and, as a judge, I look forward to kicking myself looking at all the amazing entries; ideas and implementations I wish I’d come up with myself. What will you make?

