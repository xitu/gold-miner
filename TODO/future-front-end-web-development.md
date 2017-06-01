> * 原文地址：[What is the Future of Front End Web Development?](https://css-tricks.com/future-front-end-web-development/)
> * 原文作者：本文已获 [Chris Coyier](https://css-tricks.com/author/chriscoyier/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# What is the Future of Front End Web Development?

I was asked to do a little session on this the other day. I'd say I'm
underqualified to answer the question, as is any single person. If you really
needed hard answers to this question, you'd probably look to aggregate data of
survey results from lots of developers.

I am a _little_ qualified though. Aside from running this site which requires
me to think about front end development every day and exposes me to lots of
conversations about front end development, I am an active developer myself. I
work on CodePen, which is quite a hive of front end developers. I also talk
about it every week on ShopTalk Show with a wide variety of guests, and I get
to travel all around going to conferences largely focused on front end
development.

So let me take a stab at it.

Again, disclaimers:

  1. This is non-comprehensive
  2. These are just loose guesses
  3. I'm just one dude

### User expectations on the rise.

This sets the stage:

What websites are being asked to do is rising. Developers are being asked to
build very complicated things very quickly and have them work very well and
very fast.

### New JavaScript is here.

As fabulous as jQuery was for us, it's over for new development. And I don't
just mean ES6+ has us covered now, but that's true. We got ourselves into
trouble by working with the DOM too directly and treating it like like a state
store. As I opened with, user expectations, and thus complexity, are on the
rise. We need to manage that complexity.

**State** is the big concept, as [we talked about](https://css-tricks.com/project-need-react/). Websites will be built by thinking of what state needs to be managed, then building the right stores for that state.

The new frameworks are here. Ember, React, Vue, Angular, Svelte, whatever.
They accommodate the idea of working with state, components, and handling the
DOM for us.

Now they can compete on speed, features, and API niceity.

TypeScript also seems like a long-term winner because it can work with
whatever and brings stability and a better editor experience for developers.

### We're not building pages, we're building systems.

Style guides. Design systems. Pattern libraries. These things are becoming a
standard part of the process for web projects. They will probably become the
main deliverable. A system can build whatever is needed. The concept of
"pages" is going away. Components are pieced together to build what users see.
That piecing together can be done by UX folks, interaction designers, even
marketing.

New JavaScript accommodates this very well.

### The line between native and web is blurring.

Which is better, Sketch or Figma? We judge them by their features, not by the
fact that one is a native app and one is a web app. Should I use the Slack or
TweetDeck native app, or just open a tab? It's identical either way. Sometimes
a web app is so good, I wish it was native just so it could be an icon in my
dock and have persistent login, so I use things like Mailplane for Gmail and
Paws for Trello.

I regularly use apps that seem like they would _need_ to be native apps, but
turn to be just as good or better on the web. Just looking at audio/video
apps, Skype has a full-featured app, Lightstream is a full-on livestreaming
studio, and Zencaster can record multi-track high-quality audio. All of those
are right in the browser.

Those are just examples of _doing a good job_ on the web. Web technology
itself is stepping up hugely here as well. Service workers give us important
things like offline ability and push notifications. Web Audio API. Web
Payments API. The web should become the dominant platform for building apps.

Users will use things that are good, and not consider or care how it was
built.

### URLs are still a killer feature.

The web really got this one right. Having a universal way to jump right to
looking at a specific thing is incredible. URLs make search engines possible,
potentially one of the most important human innovations ever. URLs makes
sharing and bookmarking possible. URLs are a level playing field for
marketing. Anybody can visit a URL, there is no gatekeeper.

### Performance is a key player.

Tolerance for poorly performing websites is going to go down. Everyone will
expect everything to be near-instant. Sites that aren't will be embarrassing.

### CSS will get much more modular.

When we write styles, we will always make a choice. Is this a global style? Am
I, on purpose, leaking this style across the entire site? Or, am I writing CSS
that is specific to this component? CSS will be split in half between these
two. Component-specific styles will be scoped and bundled with the component
and used as needed.

### CSS preprocessing will slowly fade away.

Many of the killer features of preprocessors have already made it into CSS
(variables), or can be handled better by more advanced build processes
(imports). The tools that we'll ultimately use to modularize and scope our CSS
are still, in a sense, CSS preprocessors, so they may take over the job of
whatever is left of preprocessing necessity. Of the standard set of current
preprocessors, I would think the main one we will miss is mixins. If native
CSS stepped up to implement mixins (maybe @apply) and extends (maybe @extend),
that would quicken the deprecation of today's crop of preprocessors.

### Being good at HTML and CSS remains vital.

The way HTML is constructed and how it ends up in the DOM will continue to
change. But you'll still need to know what good HTML looks like. You'll need
to know how to structure HTML in such a way that is useful for you, accessible
for users, and accomodating to styling.

The way CSS lands in the browser and how it is applied will continue to
change, but you'll still need to how to use it. You'll need to know how to
accomplish layouts, manage spacing, adjust typography, and be tasteful, as we
always have.

### Build processes will get competitive.

Because performance matters so much and there is so much opportunity to get
clever with performance, we'll see innovation in getting our code bases to
production. Tools like webpack (tree shaking, code splitting) are already
doing a lot here, but there is plenty of room to let automated tools work
magic on how our code ultimately gets shipped to browsers. Optimizing first
payloads. Shipping assets in order of how critical they are. Deciding what
gets sent where and how. Shipping nothing whatsoever that isn't used.

As the web platform evolves (e.g. Client Hints), build processes will adjust
and best practices will evolve with it, like they always have.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
