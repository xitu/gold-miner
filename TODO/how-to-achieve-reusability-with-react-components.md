> * 原文地址：[How to Achieve Reusability with React Components](https://medium.com/walmartlabs/how-to-achieve-reusability-with-react-components-81edeb7fb0e0#.czocsk5l0)
* 原文作者：[Alex Grigoryan](https://medium.com/@lexgrigoryan?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# How to Achieve Reusability with React Components #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*5jIE1tOzVSuz5NPHsfeQ8w.png">

Reusability is one of the most common buzzwords in software engineering today. It’s promised by a wide variety of frameworks, tools, and paradigms, each of which seems to have not only its own approach to achieving reusability, but its own definition of the word itself.

### So what do we mean by reusability? ###

True reusability is not an ad hoc process, but a development strategy. Reusable components must be built from the ground up with reusability in mind, which involves careful planning and empathetic API design. Furthermore, while modern development tools and frameworks can support and encourage code reuse, reusability cannot be achieved through technology alone — it requires processes implemented consistently across teams, and commitment at all levels of an organization.

So when we discuss reusability, it’s not just a technical discussion. It also incorporates corporate culture, training, and a host of other considerations. We’ll touch on a few of those here, but the point is that **reusability is a process that touches every stage of development and every level of an organization**.

Walmart consists of several brands, including Sam’s Club, Asda, and regional branches like Walmart Canada and Walmart Brazil. Across these brands we have dozens of front-end applications built and maintained by hundreds of developers.

Because each of these brands has its own online presence, each has developers working on components that are common to all of Walmart’s brands — an image carousel, navigational elements like bread crumbs, flyouts, credit card form components, for example. Duplication of work that’s already been completed by another team is a waste of time and money, and also creates more surface area for bugs. Eliminating that duplication enables developers to spend more time on projects that bring new value to the customer experience.

On the backend, sharing code across brands is more intuitive: a single service can take requests from multiple different brands and return the appropriate data for that brand (and there are a few ways to handle that based on the shape of the data). On the front end, the situation is more complex because it involves taking the data provided by the backend and applying themes and other transformations appropriate to a specific brand and view. Doing this in a way that fosters reuse is not a completely solved problem.

### React Component Reuse at @WalmartLabs ###

For Walmart.com, we picked React for our front end framework, and one of the reasons we picked it was that its component model provides a good starting point for code reuse — especially when paired with Redux for state management. Still, there are significant challenges to frontend code reuse in an organization the size of Walmart.

### Technical Capability to Share Code ###

The first challenge involves the technical means of sharing code — components need to be versioned, easy to install, and upgradeable. We put all of our React components into a separate GitHub organization. Currently, components are bundled into repos based on the teams that created them, but we’re in the process of moving toward functional repos, such as a “Navigation” repo containing breadcrumb, tabs, and sidenav link components. Components are then published in our private npm registry, meaning that developers can easily install a specific component version, ensuring that their apps won’t suddenly break on upgrade.

At this point, since code is being shared across teams, we needed to ensure consistent structure and coding standards across hundreds of components, even as dependencies are upgraded and needs change. That’s why we created [Electrode Archetypes](http://www.electrode.io/docs/what_are_archetypes.html) for [components](https://github.com/electrode-io/electrode/tree/master/packages/electrode-archetype-react-component) and [applications](https://github.com/electrode-io/electrode/tree/master/packages/electrode-archetype-react-app). The archetypes include configuration files for linting, transpilation, and bundling, and provide a central point from which we can manage core dependencies & tasks/scripts. Starting from a common structure and establishing consistent coding standards across all projects enables us to maintain modern best practices throughout the organization and increases the confidence developers have in each other’s code, improving the chances that reusable components will actually be reused. This confidence is further improved by a rigorous Continuous Integration/Continuous Deployment system, including rules to lint code, gauge performance, and test across multiple devices, browsers, and screen resolutions. The CI system can include rules to publish a beta version of a component when a PR is submitted and run functional tests of all applications using that component, to ensure that the PR doesn’t break anything.

### The Meta Team ###

In the early days of this project, the majority of shared components were contributed by just a few teams, and those components tended to change very quickly. Eventually, we selected a few developers with a particularly deep understanding of the Electrode framework and Walmart internals and created a group we call our meta team. These individuals would devote a few hours or a day every few weeks to review the code going into the component organization, ensure that all best practices are followed, and generally help out in any way they could. This team also developed an overall knowledge of what’s being built across the organization, and served as ambassadors for the [Electrode](http://www.electrode.io/) project in their own teams. Meta team members also took information about pending archetype changes to their teams, and collected feedback to share with the Electrode core team.

These steps were a great start, but we still saw further opportunities to improve code reuse as an organization.

### Discoverability Problem of Hundreds of Components ###

We started noticing a lot of messages in our Slack channels along a shared theme. Developers wanted to know whether or not a component had already been created for a certain task. UX teams wanted to be able to see what components were available. Project managers wanted to see what components were being built by other teams. The common thread among all these messages was discoverability. We needed a fast, simple way to discover what components were available, to see them in use and interact with them, and to learn about their implementation, configuration, and dependencies.

Our answer to this problem is [Electrode Explorer, which I discussed in a previous post](https://medium.com/walmartlabs/spotlight-on-electrode-explorer-react-component-reuse-without-the-hassle-6447763365b2#.etp9o5wr0). Explorer enables our developers to browse through the hundreds of components available within @WalmartLabs, read their documentation and see what they look like, and even step through their version histories to see how they’ve changed over time. Because Electrode Explorer provides a web interface to all of the React components in an organization, developers don’t need to `npm install` a component to see it and interact with it.

### Duplication Spilling Through The Cracks ###

But even with all these tool and processes to facilitate code reuse, we still saw problems. One issue was that teams often developed new components without recognizing that they could be useful to other teams. Components can’t be reused if they’re not included in the reusable ecosystem. Even within the shared component system, we saw a lot of duplication, or components that took slightly different approaches to very similar problems. What we realized is that technological solutions aren’t enough — there needs to be a company-wide change in thinking, wherein stakeholders at all levels take a reusability-first approach. This includes taking the time to generalize components so that reuse is easier, expanding existing components rather than starting from scratch, and consciously seeking out opportunities to share code whenever possible.

To assist this change in thinking, we created a component proposal process. Under this system, developers discuss new components before starting work on them. This provides an opportunity for developers on other teams to suggest existing solutions or alternative approaches, and lets others in the organization know what’s happening.

> *The proposal system along with the meta process helps not having duplication get through the cracks.*

### Importance of CI/CD ###

A big issue we ran into was that one team would work on a component and break another team’s application. If you didn’t lock down your component version, your CI/CD might fail due to a component being modified by another team — it’s a terrible feeling, and it leads to a lot of teams locking down components to a very specific version, where they might not even take new patch versions.

This is where the CI/CD comes into play. When a component version is updated, automation should check if it breaks any consuming applications on that major version — it should check this even if the application locks its component versions. If there is no break, we want the CI/CD system to send a PR request that updates the locked version to the new one which didn’t break the application. If there is a break, both teams should be notified to talk out what the problem is.

### Innersource ###

The foundation of our approach to reusability is our embrace of the open source/inner source philosophy, as described by [Laurent Desegur](https://twitter.com/ldesegur) in a previous [post](https://medium.com/walmartlabs/beyond-open-source-walmartlabs-e690c934fe35#.lqc0e6x3b) . @WalmartLabs has been a user of and contributor to open source for years, as demonstrated by projects like Hapi, [OneOps](https://github.com/oneops) , and [Electrode](https://github.com/electrode-io) . Less obvious from outside the company is our commitment to inner source, which is the internal application of the open source model. In the inner source approach, no team or developer “owns” a component — all components are shared throughout the organization. This eliminates bottlenecks and empowers developers to improve existing components.

These policies greatly increase opportunities for reuse — but more importantly, they signal to developers our commitment, as a company, to a philosophy of cooperation and collaboration. They empower developers to use their time and expertise where it’s most needed, rather than waiting for bottlenecks to clear, and they benefit the company in real, measurable ways.

### Conclusion ###

Reusability is not just a technical decision, but also a philosophical one that requires organizational commitment and has far-reaching implications. At @WalmartLabs, we’ve seen the benefits it can bring — right now we’re moving SamsClub.com to the [Electrode platform](https://github.com/electrode-io) , and our developers are reusing hundreds of components from Walmart.com with theming to match the Sam’s Club brand.

Tell us your reusability story — what obstacles have you encountered? How have you solved them? What opportunities for further improvement do you see?
