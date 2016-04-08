>* 原文链接 : [Design Systems Ops](https://medium.com/salesforce-ux/introducing-design-systems-ops-7f34c4561ba7#.iumcuwu3v)
* 原文作者 : [Kaelig](https://medium.com/@kaelig)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :
* 校对者:


![](https://cdn-images-1.medium.com/max/2000/1*RbwXg-OMlJTG7iiHs4NMQg.jpeg)

<figcaption>Design Systems Ops: shipping (design) at scale.</figcaption>

The best products are built by teams with great communication bridges between designers and engineers. Whether you’re one or the other, at the end of the day… we’re all shipping software. When a design system is invited to the party, communication is even better.

But who will bridge the gap between the design systems team and the engineering team?

I call these enablers _Design Systems Ops._

A Design Systems Ops is a person who is part of a design systems team, who needs to get into the designers’ shoes, and have a feel what their are trying to conceptualize. At the same time, Design Systems Ops need to understand the engineering requirements and define methods that will help shipping and scaling the Design System. In a way, a Design Systems Ops is the translator between these two worlds.

### The problem with most companies

In most structures, the story from the concept to the user is so disjointed that the products ends up being something that doesn’t feel at all like what the designers had first intended.

![](https://cdn-images-1.medium.com/max/800/1*NJbl6JkUcbGPLU1bxVW7kw.png)

<figcaption>A typical flow of the distance between a concept and the user: fidelity fades away as it gets closer to the user.</figcaption>

The signal (the concept) fades as it goes through perturbations (inefficiencies), and ends up into the product in a much lower fidelity. That delivery failure has a massive impact on the company’s ability to ship high quality products, which has a huge business opportunity cost.

### Where Design Systems help

Style guides, pattern libraries, design systems… all help normalizing practices and design patterns around a common language. That language barrier is actually where originate most of the inefficiencies.

It starts with: naming colors, objects, conventions, components… down to documenting the finest details of the experience, such as animation timings or the roundness of corners on form elements.

A good design system helps making design decisions much faster (e.g. “what color should a call-to-action be”). Designers can then spend more time on user flows, and exploring multiple concepts in the same amount of time.

A good design system also helps engineering teams refer to a single source of truth at the implementation phase. This is good for consistency, as all the call-to-actions will look the same across screens.

![](https://cdn-images-1.medium.com/max/800/1*lIa0DiwLnfc1y14t3KTWpA.png)

<figcaption>Design Systems reduce inefficiencies along the way: fidelity keeps a lot steadier along the way.</figcaption>

Some design systems also ship patterns using code. These design systems can prove to be valuable from the beginning of the concept phase, to the prototyping phase, down to the implementation phase. It’s a good sign for both productivity and fidelity when a company follows that path.

> A Design System isn’t a Project. It’s a Product, Serving Products — Nathan Curtis

Yet, some design systems don’t get the love they deserve and end up being glorified lists of patterns, afar from production code. That’s because a partial investment from a few designers and developers [is not enough](https://medium.com/@marcelosomers/a-maturity-model-for-design-systems-93fff522c3ba): a design system isn’t simply a project, it is a product (or as Nathan Curtis [puts it](https://medium.com/eightshapes-llc/a-design-system-isn-t-a-project-it-s-a-product-serving-products-74dcfffef935): “_A Design System isn’t a Project. It’s a Product, Serving Products_.”). For a design system to show sustainable value at scale and at all phases of the delivery process, it needs proper planning, user research, and methods (and lots of love!). We’ll call these optimal design systems, powered by a team who is given goals: _living design systems_.

### Introducing Design Systems Ops

The remaining inefficiencies between the living design system and the rest of the world are numerous. Mostly because of a lack of good communication between design and engineering teams. At the end of the day, the product is shipping in the form of code, and anything that makes that process less efficient should be reviewed. Introducing a role of Design Systems Ops (freely inspired by the [DevOps](https://en.wikipedia.org/wiki/DevOps) movement), can help mitigate these inefficiencies:

![](https://cdn-images-1.medium.com/max/800/1*Bp4eHmFtS5pfdPHv4pEwdQ.png)

<figcaption>Reducing inefficiencies further, by introducing an intermediary to help communication between both Design and Engineering, increasing fidelity of software delivery.</figcaption>

Many questions arise from both sides of the Design Systems:

*   Where do I find markup, colors swatches, values, icons, patterns, breakpoints?
*   How do I load the CSS if I’m prototyping, in production, in a web view?
*   What’s the best way to load fonts, to display icons?
*   What is their impact on performance?
*   Where should I file bugs and find where other people found a solution to their problems (issue tracking, knowledge base)?
*   How do I contribute to the Design System (fix a bug, add an icon)?
*   I’m a contributor, how do I test my code in multiple environments and make sure I didn’t break something?
*   I’m a developer, what should I know about the design system?
*   I’m a designer, how can I iterate in the browser on an existing pattern?
*   What is the upgrade path from v1.0 to v2.0?
*   Where is the documentation of version 0.5.0?

I’ve learned a lot watching open source projects such as [Bootstrap](http://getbootstrap.com/) and [Material Design Lite](http://getmdl.io/). At the Guardian, [I started bridging the gap between designers and developers](https://www.youtube.com/watch?v=ciG-A_1FyVg), mostly using Sass. Working on [Origami](http://origami.ft.com) at the Financial Times then helped me discover new ways of thinking about scaling design. Where I work today, [Salesforce](https://www.lightningdesignsystem.com), there is a team of engineers who fill the roles of Design Systems Ops, all passionate about shipping faster and better code to the users.

After looking at how the scaling design worked in my previous experiences, here are some things that could fall under Design System Ops’s umbrellas:

*   Local development environment (sourcemaps, live reload, speed)
*   Hosting (for design showcases and documentation)
*   Coding playgrounds (e.g. CodePen, JS Bin)
*   Technical documentation (installation, troubleshooting)
*   Front-end automated testing (accessibility, integration)
*   Cross-browser tests automation
*   Visual regression testing
*   Code style linting ([I wrote about it before](https://www.theguardian.com/info/developer-blog/2014/may/13/improving-sass-code-quality-on-theguardiancom))

The above set of responsibilities is pretty front-end centric, but here are a few more that are closer to the metal:

*   Build systems
*   Asset storage and distribution (CDN, minification)
*   Measuring performance (assets sizes, server load, CDN response times…)
*   Versioning flow (e.g. git, SemVer)
*   Release process (e.g. [continuous deployment](http://radar.oreilly.com/2009/03/continuous-deployment-5-eas.html), [continuous integration](http://guide.agilealliance.org/guide/ci.html))
*   Testing/staging environments
*   Surfacing test results and performance results (e.g. dashboards, emails)

Or, closer to the marketing side of things (developer advocacy):

*   Building demos
*   Helping developers implement the Design System
*   Evangelizing the Design System to the developer community

As mentioned previously, having solid solutions in these areas can massively help design systems teams improve the quality of deliverable, the speed and confidence at which they operate. **That’s why I believe having good Ops as part of a Design Systems team will strongly set the project up for success.**

### Epilogue

As more and more companies build their own design systems, they are showing interest in adding technical people to support design efforts and tooling. As it is only the beginning for this type of roles, our community will have many questions. The ones that keep me up at night are:

*   **What other areas should Design Systems Ops help with?**
*   **What tools can help smaller teams follow that path at a small cost?**
*   **Aside from development speed, what other metrics should a Design Systems Ops be judged on?**

I’d love to read your thoughts, and if you’re in San Francisco, why not [have a coffee](https://twitter.com/kaelig) and talk about it.

I did not come up with all of this Design Systems Ops thing from nothing, and to understand better where I come from, you can read [Ian Feather’s awesome presentation about Front End Ops](http://ianfeather.co.uk/presentations/front-end-ops/).

Also, definitely listen to the [Design Details](http://spec.fm/) podcast, where some of the very best designers in the world are bringing up their experience creating design systems and style guides.

Finally, if you like talking design systems in general or want to learn more about them, don’t miss [Clarity Conference](http://clarityconf.com/), March 31st–April 1st, 2016 in San Francisco (organized by the design systems queen herself: [jina ₍˄ุ.͡˳̫.˄ุ₎](https://medium.com/u/f5d1807b4e38)).

