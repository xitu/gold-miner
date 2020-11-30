> * 原文地址：[Building a design system and a component library](https://medium.com/javascript-in-plain-english/building-a-design-system-and-a-component-library-3f4e01a7b0b4)
> * 原文作者：[Bruno Sampaio](https://medium.com/@bensampaio)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/building-a-design-system-and-a-component-library.md](https://github.com/xitu/gold-miner/blob/master/article/2020/building-a-design-system-and-a-component-library.md)
> * 译者：
> * 校对者：

# Building a design system and a component library

![](https://cdn-images-1.medium.com/max/3200/0*d_TQ28ARHmOchSvG)

This post is based on the series of posts: **Modernizing a jQuery frontend with React**. If you want to get a better overview of the motivation for this post we recommend you first read our [initial post](https://medium.com/@bensampaio/8598b252ceb3).

When we started rebuilding our frontend in React it wasn’t yet part of our design and development workflow to think about reusable UI components. Our jQuery frontend was built mainly out of Twitter bootstrap components, which were adapted for specific use cases or extended with additional functionality. New designs were created for each new feature by copying some design elements from older designs and improving or adapting them there. As the team and the application kept growing, our components evolved in multiple directions. This resulted in multiple variants of text sizes, colors, buttons and links which led to a disjointed user experience across our application.

Rebuilding our frontend in React was an opportunity for us to rethink our design and development workflow and focus on a more cohesive experience for the user. This was especially important since we knew we needed to make our app more accessible and responsive. This led to the creation of a component library which motivated the need for a design system. That process was difficult and slow at first but became exciting and useful over time.

## What is a design system?

A design system is a comprehensive guide on how to create, document and use UI components. It defines a collection of rules, constraints, principles and best practices that apply to all designs. The core element of a design system is a collection of UI components, such as buttons, links and tables. For each designed component you can have usage guidelines that document choices made during design, the rules that define the component, behavior and constraints, use cases and any other details that are easy to communicate through words.

## What is a component library?

A component library is a collection of reusable UI components implemented in a programming language. When supported by a design system it can also be seen as an interactive implementation of the designs and their guidelines.

## Why should you care?

As [Airbnb’s Karri Saarinen](https://medium.com/airbnb-design/224748775e4e) stated: “A unified design system is essential to building better and faster; better because a cohesive experience is more easily understood by our users, and faster because it gives us a common language to work with”.

At Karify, it helps us to create and follow our own constraints. It helps us to create a cohesive user experience on a multitude of platforms and devices. And finally, it helps our team work smarter, faster and closer together. These are some of the advantages we found in more detail:

* **Communication**: designers understand developers and vice-versa. Concepts that were previously difficult to understand for both sides are now much clearer. Talking about components and using the rules we defined in communication make the process of designing and developing much easier.
* **Consistency**: the look and feel of the application’s pages became the same. We know exactly what text size we should use for a heading or for normal text, what type of button we should use for a primary action, what colors to use to communicate the type of a certain action or piece of information, and how much spacing there should be between each type of element. If we decide to change any of those, then they can easily be changed across the entire design system, component library and application.
* **Collaboration**: designers and developers work closer together and are able to share ideas and insights more easily. Since it is easier to communicate it becomes easier to talk about functional constraints and to incorporate those in designs at an earlier phase. The use of a tool like [Zeplin](https://zeplin.io/) makes this process especially faster because it allows you to start a discussion in the context of any kind of detail in a design.
* **Documentation**: component guidelines provide clear information on how a component should look, be used, behave and why that is. If in the future a component design or implementation raises questions, it becomes easier to find the reasoning behind it and to prevent rethinking what has already been thought through before (unless it no longer makes sense).
* **Modularity**: all components represent small pieces of design and code with their limited set of rules and concerns. This enforces separation of concerns in both design and code.
* **Maintainability**: it becomes easier to keep designs and code up to date because when a component is touched all other components that use it are updated. This can also lead to extra work on older components but gives you visibility of the impact of your change.

As with any other approach we also found some disadvantages to the process of working with a design system:

* **Time consuming**: this was especially true in the beginning. Defining all the rules, constraints and base components like text, color and spacing can take quite a lot of discussion. Over time it becomes faster. It depends on how many new components you need to create before designing a new feature. But once you have a few it becomes super fast to reuse them in existing or new designs. The same applies to the development of the application.
* **Less creativity**: due to all the rules and constraints there is less space to be creative. However, this could also be seen as an advantage since that often leads to consistency.
* **Steep learning curve**: this applies mainly to new people joining the team because they will need to get acquainted with a lot of rules before being able to apply them consistently. On the other hand, it also makes it easier for them since the design system communicates the rules.
* **Complexity**: if there are components with too many dependencies on other components it can also become complex to maintain and reuse them.

Don’t let these disadvantages scare you, though. It is part of the process to learn to minimize them. Over time, the advantages become more apparent than the disadvantages.

## How can you get started?

First of all, we recommend you get acquainted with the concept of [Atomic Design](https://bradfrost.com/blog/post/atomic-web-design/) alongside with [design system best practices](https://airbnb.design/systems-thinking-unlocked/) and examples of design systems like [the one of Airbnb](https://airbnb.design/building-a-visual-language). Additionally, you should also choose a tool where to build your design system. We chose [Sketch](https://www.sketch.com/) but there are other alternatives like [Figma](https://www.figma.com/).

From there you can start defining your set of colors, typography styles and spacing sizes which will be your first atoms. This will allow you to start defining your first molecules like buttons, links, surfaces and so on. It’s likely that you will miss some use cases in this first iteration which will lead to a few more iterations until it all feels right and future proof.

If you already have an application in place and can’t change it all at once then we recommend you base your design system on what you have. For each component, analyze what you have, pick the parts you like and work on improving the ones you don’t. When even this is too much work, split the future components from the legacy components. This way, you can stop yourself from using the legacy components in new components. Slowly, this will allow you to reach your goals.

## How did we do it?

Our team was composed of two designers and one frontend developer. Later on, one more developer joined the team. This team size was and still is enough to get things done with enough time to care about details. However, we would say the team size depends on the size of the project and the pace of the company.

The opportunity to rebuild our frontend from scratch also had the benefit that we could learn from past mistakes. Therefore, we based the design of our new components on the feedback from our users, who frequently mentioned accessibility and responsiveness issues. To tackle those issues we concluded that we needed to redesign our navigation system first and then redesign every page in the application.

We started by designing our new navigation system as a whole and as it became more solid we started breaking it down into smaller components. This resulted in the intended Atomic Design division between atoms, molecules and organisms. Ideally you should start with the atoms but that was difficult without first knowing exactly which direction we wanted to take. Nowadays, since we already defined several atoms and molecules, it is easier to start composing them into new organisms or pages.

While creating components, we define them as `symbols` and split them in Sketch library files for `Atoms`, `Molecules` and `Organisms`. Sketch facilitates the reuse of our `Atom` components as a symbol in other `Molecule` or `Organism` components. In Sketch they are then called `nested symbols`. We make sure we use our components in a cascading order, so updates are propagated in one direction only.

![](https://cdn-images-1.medium.com/max/3200/0*oXhrNGXE1iLKgoBL)

**Our Sketch `Molecules` library: the icon component inside the button component is reused from the `Atoms` Sketch library.**

To document our choices we create guidelines for each component (regardless of whether it’s an atom, molecule or organism) inspired in the Material UI component guidelines. Next to the component guidelines, we also have some generic guidelines which apply to all components because some guidelines are transcending, like accessibility and tone of voice. These guidelines work as our single source of truth. They ensure that nothing can be left to the imagination. To give an impression, they are a simple document with the following sections:

* Usage
* Anatomy
* Placement on different viewports
* Behavior
* Accessibility

We use our components in `Template` or `Page` files which we create per feature/project we work on. When a component or a page is ready, we share its designs with developers and other stakeholders via [Zeplin](https://zeplin.io/). This tool allows them to extract information from designs like colors, sizes and assets. It also allows for communication per component, which can drastically improve collaboration since it becomes very easy to discuss details for which normally a meeting would be necessary.

![](https://cdn-images-1.medium.com/max/3200/0*rp1keWbCPclqMTwx)

**Collaborating on developing button components in Zeplin**

From this point onwards, developers can use the information in Zeplin to start building the corresponding React components. Ideally there should be one React component per design component so that the relation between design and code is as close as possible. For inspiration we often look at how other component libraries did it like [Material-UI](https://material-ui.com/), for instance.

To ease in this process we use [Storybook](https://storybook.js.org/), which facilitates the development of components in isolation. It also offers a way of visualizing and interacting with all components in our library which can then be used by designers to validate the final implementations.

![](https://cdn-images-1.medium.com/max/3200/0*QII0QzNhlLMhXNCX)

**The same buttons in Storybook: ready to be reviewed**

In both our design system and our component library we group components by categories like buttons, color, form elements, layout, links, typography and so on. This helps with grouping different atoms, molecules and organisms but also helps, once more, with the communication between designers and developers.

In essence these tools helped us develop feedback loops in our work process, which improved communication and collaboration: designers can easily give feedback on the component library through looking at Storybook and developers can easily comment on designs or download assets from Zeplin.

## What could we have done better?

In general, we feel that we did quite well in this process but we know that there are some things we could have done differently. Below are some of the pain points we came across along the way:

* **Accessibility guidelines**: we completely underestimated accessibility. There are lots of [WCAG guidelines](https://www.w3.org/TR/WCAG21/) and there’s no way you can implement them all with such a small team. We had to choose which ones were the most important for our users. However, we made this choice very late in the process because it had an impact in our atom components, mainly typography and color, which forced us to rethink several molecules and organisms.
* **Complex components**: we tried too often to create components with too many responsibilities or too many dependencies on other components. It is better to break them down into smaller components than to try to make them too customizable. It might require some repetition both in design and code but it is easier to understand.
* **Lack of planning and limitless scope**: for a while the scope of the project only kept on growing. Some things were very important but others not so much. It was difficult to draw a line since there was no end date for the project. Eventually, we started discussing these issues more often in order to prioritize what was really important.

In the end, we managed to learn and improve upon these issues after finishing redesigning our navigation system. We still come across some complex components now and then but I think it is part of the process to make that mistake and identify it before it’s too late.

## Conclusion

In our opinion, building a design system and a component library was worth the effort. It brought the consistency in design that we were looking for from the beginning. This doesn’t mean we would recommend it for everyone. Before you get started we truly recommend you make sure this is the right solution for your project. We would say you only need to do it if you know or expect the product to require a lot of different pages with complex interactions that reuse the same components. This is especially relevant to evaluate when you are still a startup or small company and you expect to scale up in the coming years. However, if you expect your product to be a simple website that won’t change much over the years then this would probably be overkill.

I hope this article helps you in the process of making better design decisions. If you have questions, feedback, or suggestions regarding what you read here I would be happy to hear from you in the comment section below.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
