> * 原文地址：[How to gain widespread adoption of your design system](https://medium.com/hubspot-product/how-to-gain-widespread-adoption-of-your-design-system-29d1b142b158)
> * 原文作者：[Julie Nergararian](https://medium.com/@julienerg?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-gain-widespread-adoption-of-your-design-system.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-gain-widespread-adoption-of-your-design-system.md)
> * 译者：
> * 校对者：

# How to gain widespread adoption of your design system

## Using documentation to cultivate co-ownership between design and development

_This post is the second in a series about_ [_HubSpot Canvas_](https://canvas.hubspot.com/)_, our new Design Language. Read the first_ [_here_](https://github.com/xitu/gold-miner/blob/master/TODO1/how-building-a-design-system-empowers-your-team-to-focus-on-people-not-pixels.md)_._

![](https://cdn-images-1.medium.com/max/1000/1*wCQVZ3pzhC6wPZEVa54r8A.png)

I came to HubSpot as a software engineering co-op just as a movement was growing. The design team had, over the previous months, created a gorgeous set of new typography, colors, and basic components that would become the cornerstone of a major redesign of our entire platform.

But because there had previously been no single style guide — no single source of truth — that meant, in reality, that we needed to do a complete rewrite of our product’s front end. It meant that we’d need to disrupt the work of more than 40 teams and rebuild hundreds of pages with a completely new set of components in order to bring the redesign to life.

I joined HubSpot’s front-end infrastructure team, the team responsible for crafting our internal build system and for supporting HubSpot’s developers in everything from testing to third-party dependencies. They were the natural choice to spearhead the redesign, so five developers, including myself, were dedicated to helping every team upgrade to our new design system, HubSpot Canvas. When I got my assignment, my first thought was: _Best. Job. Ever._ followed shortly by: _Wow. This seems like a lot of work._

And it has been a lot of work. But it would have been a lot _more_ work if we hadn’t learned a key lesson along the way:

> Redesigns only work when co-owned by designers and developers.

We cultivated this co-ownership, in large part, by building good tools and documentation. Our documentation acts as a source of truth for everyone on the team, and the tools that our designers and developers use mirror each other, giving everyone a shared language and making them partners in the stewardship of our design system.

This is the story of how documentation not only helped us pull off a massive redesign, but grow better as a team.

![](https://cdn-images-1.medium.com/max/1000/1*CD9fkMcNzSmnqzfyRO1syw.png)

### The Headwinds and the Tailwinds

With any huge project, there are forces working in your favor (the tailwinds), and forces working against you (the headwinds). In our case, they were:

### The Tailwinds

**Our entire product was on a pretty similar tech stack.** The JavaScript ecosystem can change in the blink of an eye, and I would never have expected a company of HubSpot’s size to be on the same stack. But a homegrown, developer-driven movement towards React and away from Backbone had been widely successful. This meant that teams could redesign their apps without moving to a new stack and that my team would be able to maintain consistency relatively easily.

**We already had the makings of a reusable component library and corresponding documentation tool.** As teams started to move to React, one of our engineers had spun up a reusable React component library with easily maintained, coded examples that could be edited inline, which meant we didn’t have to start our documentation from scratch.

### The Headwinds

**Unlike our apps, our libraries don’t have a dedicated QA period.** I had come from a financial software company, and I probably asked my tech lead where the QA engineers were 5 times in my first week before it really sunk in. Not only were we on the hook for doing our own quality assurance, but every change we made would be picked up by all future builds — and because our teams deploy more than a thousand times a day, this meant any changes to the components would go out to every app, immediately.

We’d need a coordinated effort between the front-end infrastructure team and the product teams to ensure that every screen was ready when we launched, while also taking care not to unintentionally cause any bugs in the product. But as long as we moved quickly and kept it easy to revert any bad changes, we could minimize the damage.

**HubSpot Product is made up of small, autonomous teams.** Teams at HubSpot have complete ownership over a piece of the product, with the freedom and power to research, iterate, and find solutions. We were worried that it would be tricky to implement a new design system aimed at eventual consistency with teams who had such a strong culture and history around autonomy.

During the transition, they’d have to completely stop working on new features, and we’d also be developing the processes and standards that the whole team would need to adhere to going forward. There’s a delicate balance between supporting your coworkers with a system and taking away their creativity with it. But we were also confident that by removing low-level, repetitive problems from our coworkers’ plates, we could free them to channel that creative energy into solving bigger problems.

Our worries were mostly unfounded. The teams, too, were ready for a system-wide redesign, because:

1.  No one had to change their stack or business logic.
2.  Inconsistency was dragging us down. Product managers saw it in user feedback. Designers saw it in the numerous shades of gray across our product. Developers saw it in _way_ too many date picker libraries. A reliable, reusable component library built and maintained by another team sounded like a pretty sweet deal.
3.  Our new design system, HubSpot Canvas, looked good. Like, [really good](https://medium.com/hubspot-product/people-over-pixels-b962c359a14d).

### From Project to Process

When other companies do big redesigns, they’ll often unveil them with great fanfare, like pulling a sheet off a car — yesterday you had the old, and today you have the brand new.

> That wasn’t going to work for us.

Our product and our product team were just too massive to do it all in one go. We decided instead to tackle parts of the product one by one, starting with those that had fewer users and moving progressively toward the core of the software. This process would be _way_ less disruptive, and meant that we’d get to make improvements to the design system before it was widely adopted.

We wanted to move fast, so we laid down some rules. We stressed that the first pass would only be a visual refresh — no new functionality. We wanted to repaint our house, not build an addition. If teams were adding new features while rebuilding their products, we’d drag out the timeline indefinitely.

![](https://cdn-images-1.medium.com/max/1000/1*7oIds6pKssXqqh0iWfqgMQ.png)

Using each design team’s initial work as a guide, we transformed a handful of existing components into a basic collection of responsive, accessible, browser-compatible React components. In order to get the work done quickly, we’d work inside teams’ apps and change over the components ourselves.

But.

It wasn’t quick. We only had five engineers on our team and were working in unfamiliar codebases, so work moved slowly. And worse, because _we_ were implementing the design system, the app team didn’t get the chance to master the design language themselves, leaving them with an app full of pieces of code they knew and pieces that were totally foreign to them. We realized this redesign needed to transform from a hands-on project to a real _process_ that teams could tackle on their own.

So we started facilitating that process by providing support and by building out and maintaining the component library. We worked with the design team to have each product designer redesign their part of the product using a [Sketch kit](https://medium.com/hubspot-product/people-over-pixels-b962c359a14d) that contained all the elements of our design system. We then did a component review with each team as they started their redesign to look for potential new components, new variations, or new functionality for components that already existed.

Then, my team created issues in GitHub so we could continue to collaborate across development and design as we built components, and so that each team could track the progress of the components they needed. We staggered each app’s timing so we could ensure that our team’s backlog didn’t slow down the progress of other teams’ redesigns.

For a while, it was smooth sailing. As teams completed their redesigns, they went back to feature work, their apps full of shiny, new components.

But sometimes, teams didn’t know how or when to use a component correctly, or whether a component’s behavior was intended or not. As they brought their questions to us, we were bombarded with queries and requests for clarification. We fell further and further behind as we tried to support the teams that were finished while also supporting teams in the midst of their own redesigns.

The solution was pretty obvious, but it wouldn’t be easy.

#### We needed better documentation.

* * *

### Creating a living style guide

Good documentation is an easy sell. Every second spent writing a line of clear documentation saves you an incalculable amount of time in the future — time spent, for example, trying to remember that brilliant thing that was on your mind before you stopped to dig up a link to explain to your coworker, again, the difference between a tooltip and a popover. You should be spending that time on _new_ problems, not problems that have already been discussed, solved, and settled.

We knew we wanted our documentation to be:

*   **Easily discoverable.** We didn’t want anyone to spend time creating a component or variation that already existed, or have to ask a gatekeeper where it lived.
*   **Relevant and helpful.** It should be the definitive resource on design system, and everyone should be confident that they can find answers to their questions.
*   **Self-maintaining and automated** so that nothing would become outdated.

### Planting the seed

In order to get our documentation tool right, we decided to build it the same way we build products for our customers. We started by interviewing a variety of people on the product team, both designers and developers, from those who had been at HubSpot for years to those who had just joined. We created a card sorting exercise where we printed out screenshots of existing components and asked HubSpotters to name the component, then sort the components categorically and name that category.

![](https://cdn-images-1.medium.com/max/800/1*ZihMIjp4j6ERZkSTVJ4EWw.jpeg)

Surprisingly, we discovered a big discrepancy between the language that developers and designers used to talk about our components. Developers would often refer to objects by their names in other front-end libraries and frameworks (like [jQuery](https://jquery.com/) and [Bootstrap](https://getbootstrap.com/)). Designers would usually refer to components by the names of their sister components in Google’s [Material Design System](http://www.material-ui.com/). We found people using the same word for two very different components, or different names for the exact same component.

![](https://cdn-images-1.medium.com/max/1000/1*iMdDJWb8GJ0a9jBmhS01NQ.png)

Without fail, every designer or developer wanted fewer opportunities for design decisions to fall through the cracks between the intended user experience (the designer’s mockup) and the actual one (the developer’s implementation). And they knew ensuring that wasn’t the duty of design or development alone — it was everyone’s responsibility.

![](https://cdn-images-1.medium.com/max/1000/1*ak_ooSUtwtfOnEzIkrolRQ.png)

Instead of building another component library focused solely on developers, we realized that we needed to build a resource that would become the hub for everyone on the team. That set of documentation and tools would forge shared ownership of the design system between designers and developers.

We started by renaming a few components, adding tags to some components for easier discoverability when searching, and asking for suggested component names at the beginning of the component design process so that designers and developers could decide on the right name collectively. We also grouped families of components together based on their similarities — so now, for example, all components used for alerts and messaging can be found on the same page.

In order to help designers seamlessly move between Sketch and the component documentation, we decided to mirror the navigation, structure, and terminology in the Sketch kit and UI Library, and developed a system for keeping updates to the Sketch kit and the UI Library in lockstep.

### Full bloom

With the basics down, we then got to work making designers’ and developers’ day-to-day work much easier and more efficient by bringing the rest of the insights from our research to life.

Developers mentioned often having trouble knowing which React component matched the one they saw in their designer’s mockup, so we added a layer of visual search, with real, automatically generated screenshots, to make it easier to find what they were looking for. They also needed a place where they could see all the options each component contained, and a place where they could find information about the component’s API, so we brought those front and center in the component description.

![](https://cdn-images-1.medium.com/max/800/0*g_pMS8mB5qVbV7Cs.png)

Developers also needed a sandbox where they could quickly test components, so we improved the real-time editing experience for components in the library by including a React code editor with all of our components in scope (complete with syntax highlighting and [Prettier](https://prettier.io/) capabilities). We also made it simple to move those examples into a distraction-free editor that also renders components instantly, so developers could use it as a space to build out the beginnings of a design or to test out a particular combination of components. Then, they could then easily share it with other HubSpotters, letting them quickly iterate, debug, and conveniently share ideas and proposed solutions.

Designers needed a place to reference and share assets, so we created browsing pages for our colors, typography, illustrations, icons, and product copy guidelines, with a link to download the most up-to-date version of the Sketch kit. We also documented our full design process inside the UI Library to help new designers get up to speed.

Neither designers nor developers were always sure which components would allow the user to complete a particular interaction pattern (like copying a URL, or progressing through a step-by-step flow), so we built pattern pages to explain which components and copy should be used in common user scenarios.

We wanted to get more developers involved with the design language, so we shared guidelines for how they could create components, and started building on top of our basic components by combining them with our favorite open-source libraries. This provided the freedom to experiment with new tools from the OSS community, to add more functionality and productivity to our stack, and, frankly, to let all developers at HubSpot who wanted to create, create. Because we were aiming to make our components the _visual foundation_ for all our front-end apps, that left a lot of room for (and need for) additional layers on top of them. These made the choice towards consistency trivial for our developers.

![](https://cdn-images-1.medium.com/max/800/1*T84-hO6EzGz_PXzkCyMRPw.png)

To encourage people to interact with that documentation on a daily basis, we added buttons to propose a new component, suggest a change to an existing component, report a bug, or request an illustration, right from inside of the library. Those buttons pre-populate GitHub issues with the necessary labels and pertinent questions so that it gets queued up in our process. This gives new designers and developers a single point of reference for learning how to use the entire HubSpot Canvas ecosystem from their very first day.

![](https://cdn-images-1.medium.com/max/1000/1*H81q1SJECA9bglCiOKte6Q.png)

### The Effect

Now both our designers and developers share a source of truth for our design system and mutual understanding has increased. Greater trust in the documentation has shown stronger trust in the system as a whole. I was so proud to see this tweet by one of our front-end tech leads just a few weeks ago:

![](https://i.loli.net/2018/09/15/5b9cc23122666.png)

We do a platform infrastructure survey for all our engineers twice a year, and since we started including questions about our UI Library, we’ve repeatedly gotten responses like this:

> _100,000/10
> Oh god the frontend UI framework is gorgeous and light years ahead of any open source react ui framework_

Our work to make our documentation a thorough, living document will never be over, but feedback like this helps us know that we’re on the right track.

### See it for yourself

Here’s a peek at how quickly you can start from a pre-made template, then build out a page using the sandbox editor in our UI Library.

* YouTube 视频链接：https://youtu.be/Jw__JImMhXE

See how our developers can [build the exact same mockup](https://medium.com/hubspot-product/people-over-pixels-b962c359a14d) using the UI Library editor and our reusable React components.

We’ve made a version of our [HubSpot Canvas UI Library](https://canvas.hubspot.com/) public. In it, you’ll find a subset of our components and styles, pulled straight from our production code. It’s a window into how we build our products here at HubSpot, and we’re sharing it because we’re proud of the time and effort we’ve put into creating our design system and optimizing it for developers and designers so that it stays evergreen. We invite you to take a look and share your thoughts — we can’t wait to hear them.

**Credits:  
**Illustrations by [Sue Yee](https://dribbble.com/suechews)

_Originally published on the_ [_HubSpot Product Blog_](https://product.hubspot.com/blog/how-to-gain-widespread-adoption-of-your-design-system)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
