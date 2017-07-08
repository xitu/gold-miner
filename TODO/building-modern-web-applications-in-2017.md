
> * 原文地址：[Choosing a frontend framework in 2017](https://medium.com/this-dot-labs/building-modern-web-applications-in-2017-791d2ef2e341)
> * 原文作者：[Taras Mankovski](https://medium.com/@tarasm)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/building-modern-web-applications-in-2017.md](https://github.com/xitu/gold-miner/blob/master/TODO/building-modern-web-applications-in-2017.md)
> * 译者：
> * 校对者：

# Choosing a frontend framework in 2017

![](https://cdn-images-1.medium.com/max/800/1*T551HACMn9A95dnwpPK-eQ.png)

Credit: [Ember.js: An Antidote To Your Hype Fatigue by Godfrey Chan](http://brewhouse.io/blog/2015/05/13/emberjs-an-antidote-to-your-hype-fatigue.html)

There’s been a lot of development in the frontend frameworks ecosystem over the last seven years. We’ve learned a lot about what it takes to build and maintain large applications. We’ve seen many new ideas emerge. Some of these new ideas changed how we build web applications, and others we discarded because they did not work.

In the process, we saw a lot of hype and conflicting opinions that made it difficult to choose a framework. This choice is especially difficult when you’re picking a framework for an organization that will be responsible for maintaining this application for a long time.

In this article, I would like to describe the evolution of our understanding of how to build modern web applications and suggest a way of thinking about which technology to choose.

To start, I would like to walk down memory lane, back to the first library that made building web applications feel more like programming. Backbone.js was released in October of 2010 and reached 1.0 in March of 2013. It was one of the first widely used JavaScript libraries to introduce the separation between Model and View.

![](https://cdn-images-1.medium.com/max/800/1*vqOV_K_r66lUwdFeABCWEQ@2x.png)

Relationship between Model and View in Angular — credit [http://backbonejs.org](http://backbonejs.org)
Backbone’s Models represented data and business logic. They emitted change to Views. When a change event was triggered, the view was responsible for applying that change to the DOM. Backbone was template agnostic. It left it to the developer to manually update the DOM.

Around the time that Backbone 1.0 landed, Angular.js was released and started to grow in popularity. Instead of focusing on the Model like Backbone, it focused on making the view better.

Angular.js introduced the idea of compiling templates to make HTML dynamic. It allowed injecting behavior into HTML elements using Directives. You could bind a model to a view and the view would automatically update when the model changed.

The popularity of Angular.js grew because it was easy to add Angular.js to any project and easy to get started with. Many developers were attracted to Angular.js because it was built by Google which gave Angular.js automatic credibility.

At about the same time, Web Components specification promised to make it possible for developers to create reusable widgets that were isolated from their context and were easy to compose with other widgets.

The [Web Components specification](https://www.w3.org/standards/history/components-intro) was four separate specifications that worked together.

- HTML Template — provides HTML markup for the component
- Custom Element — provides a mechanism to create a custom HTML element
- Shadow DOM — isolates the internals of the component from the context that rendered it
- HTML Import — makes it possible to load the Web Component into a page

A team at Google created a polyfill library that provided Web Components for all browsers at the time. This library was called Polymer and was open-sourced in November of 2013.

Polymer was the first library to make it possible to build an interactive application by composing components. Early adopters benefited from composability but found performance issues that needed to be addressed by the framework.

Simultaneously, a small group of developers were inspired by the ideology of Ruby on Rails and wanted to create a convention-based, community-driven, open-source framework for building large web applications.

They started with a fork of SproutCore 2.0, which was an MVC-based framework with clear separation between Model, Controllers, and the View. This new framework was called Ember.js.

The first challenge of creating a convention-based framework was finding the patterns that were common to large web applications. The Ember.js team looked at large Backbone applications to find similarities.

They identified the need to render nested views where some parts of the application where consistent while other parts changed from one part of the app to another.

They also saw the URL as a key player in the architecture of web applications. They married the idea of nested views and the significance of the URL to create a routing system that served as the entry point into an application and controlled the initial view rendering.

![](https://cdn-images-1.medium.com/max/800/1*rx9bWvoWTaEJSY8qAuuh4A.png)

Elements of Ember.js — source [Ember JS — An In-Depth Introduction](https://www.smashingmagazine.com/2013/11/an-in-depth-introduction-to-ember-js/)

The Ember community, under the leadership of the Ember.js core team, released Ember.js 1.0 in August of 2013. It featured an MVC architecture, robust routing system, and components with compilable templates. Like Angular.js and Polymer, Ember.js relied heavily on two-way bindings to keep the view in sync with the state.

Around the middle of 2014, a new library began to captivate developer’s attention. Facebook created a framework for their platform and released it under the name React.

At the time when all other frameworks relied on object mutation and property bindings, React introduced the idea of treating components like pure functions and component parameters as function arguments.

![](https://cdn-images-1.medium.com/max/800/1*sUeInQGMBhFVqW-rHj1JZg.png)

Component is a function that returns DOM — source [https://facebook.github.io/react/docs/components-and-props.html#functional-and-class-components](https://facebook.github.io/react/docs/components-and-props.html#functional-and-class-components)

When the value of a parameter changed, the component’s render function was invoked and returned a new component tree. React compared the returned component tree against a virtual DOM tree to determine how to update the real DOM. This technique of re-rendering everything and comparing the result to a Virtual DOM proved to be very performant.

![](https://cdn-images-1.medium.com/max/800/1*cV-klTo3DKl0Uo2Znk3V6g.png)

Source: [React.js Reconciliation](https://www.infoq.com/presentations/react-reconciliation)

Angular.js developers were encountering performance problems caused by Angular.js’ change detection mechanism. The Ember community was learning first hand the challenges of maintaining large applications that relied on two-way bindings and observers.

React did what Polymer failed to accomplish at that time. React showed how component architecture could be made performant. React was killing Ember and Angular.js in benchmarks. Some brave Backbone developers were adding React as views to their applications to fix performance problems that they were encountering.

In response to the threat posed by React, the Ember core team created a plan to adopt ideas introduced by React into the Ember framework. They recognized the need for backward compatibility and created an upgrade path that allowed existing applications to upgrade to a version of Ember that included a new React-inspired rendering engine.

Over the course of 4 minor releases Ember.js deprecated Views, moved the community to a CLI-based build process and made component-based architecture the foundation of Ember application development. This process of gradually making significant architectural changes to the framework was named “Stability without Stagnation” and became a fundamental tenet of the Ember community.

While Ember was learning from React, the React community was adopting routing that was popularized by Ember. Large React applications are written today using [React Router](https://github.com/ReactTraining/react-router) which evolved from a fork of [router.js](https://github.com/tildeio/router.js/) which powers Ember’s routing.

One of Ember’s biggest contributions to how we build modern web applications was their leadership and popularization of using a command line tool as a default interface for building and deploying a web application. This tool is called EmberCLI. It inspired React’s [create-react-app](https://github.com/facebookincubator/create-react-app) and [AngularCLI](https://github.com/angular/angular-cli). Every web framework today provides a command line tool to ease development of web applications.

Around the middle of 2015, the Angular.js core team was coming to the conclusion that their framework was reaching an evolutionary dead-end. Google needed a tool that their developers could use to build robust applications, and Angular.js could not become this tool. They started working on a new framework that would be a spiritual successor to Angular.js. Unlike Angular.js, which became popular with very little support from Google, the new framework is fully backed by Google. Google dedicated over 30+ developers to work on the successor they are calling Angular.

The scope of the new framework is much broader than Angular.js. The Angular team calls the new framework a platform because they plan to provide everything that a professional developer needs to build web applications. Like Ember and React, Angular uses component-based architecture, but it’s the first framework to make TypeScript their default programming language.

![](https://cdn-images-1.medium.com/max/800/1*c4T4WMmvhkQ4yc24dfzgMA.png)

Angular Component with TypeScript — [https://github.com/johnpapa/angular-tour-of-heroes/blob/master/src/app/heroes.component.ts](https://github.com/johnpapa/angular-tour-of-heroes/blob/master/src/app/heroes.component.ts)
TypeScript offers classes, modules, and interfaces. It supports optional static type checking and is a perfect language for developers who are coming from Java and C#. TypeScript with Visual Studio Code provides excellent Intellisense support.

![](https://cdn-images-1.medium.com/max/800/1*m6CUCh3LRpJNHV2axqtkAQ.png)

Intellisense in Angular Apps — Source [http://rafaelaudy.github.io/simple-angular-2-app/](http://rafaelaudy.github.io/simple-angular-2-app/)

Angular is highly structured and conventions-based, while still exposing mechanisms for configuration. It has a powerful router. The Angular team is working hard to make their new framework everything that Google developers would expect from a professional development environment. This focus on completeness will benefit the entire Angular community.

In May of 2017, Polymer 2.0 landed with improvements to their bindings system, reduced dependency on heavy polyfills and alignment with the latest JavaScript standards. The new version introduced a few breaking changes with a detailed plan for users to upgrade to the new version. The new Polymer comes with a command line tool to help build and deploy Polymer projects.

As of June 2017, all top frameworks aligned on component architecture as the development paradigm. Every framework provides routing as a means of breaking up an application into logical chunks. State management techniques like Redux are available for all frameworks. React, Ember and Angular all allow server-side rendering for SEO and fast initial boot.

So how do you know what tool to use to build a modern web application? I would recommend that you look at the demographics of your organization to figure out which framework will suit best.

React is a library that’s designed to be one piece of the puzzle. React provides a thin view layer and leaves it to the developer to choose the remaining pieces of the architecture. Nothing comes in the box, so your team has full control over everything that you use. Choose-your-adventure works well if you have a team of experienced JavaScript developers who are comfortable with functional programming and immutable data structures. The React community is on the cutting edge of innovation in the use of web technologies. If your organization needs to target many platforms with the same codebase, knowing React will allow you to write for the web, for native with React Native, and for VR devices with ReactVR.

Angular is a platform that’s very well suited to enterprise developers who are coming from Java or C# background. TypeScript and Intellisense support will make these developers feel right at home. Even though Angular is new, it already has many 3rd party component libraries that companies can purchase and start using right away. The Angular team promised to quickly iterate on the framework to make it better without again breaking backward compatibility. Angular can be used to build performant native applications using NativeScript.

Ember.js is a framework that optimizes the productivity of small teams and highly skilled individual developers. The focus on conventions over configuration provides an excellent starting point for new developers and organizations that maintain large projects over a long time. Commitment to “Stability without Stagnation” has proven to be an effective way to maintain large applications without requiring a rewrite when best practices change. Stability, maturity, and dedication to the creation of shared primitives produced an ecosystem where most development is surprisingly easy. If you’re looking for a reliable framework for a long-term project, Ember is an excellent choice.

Polymer is a framework that is particularly well positioned for large organizations that wish to create a single style guide and a collection of components to be used across the entire organization. The framework provides comparable development tooling. If you’re looking to sprinkle your applications with modern features without writing a lot of JavaScript, then Polymer is the right tool for your organization.

We are learning about what it takes to build applications for the browser and converging on good ideas. The makers of all frameworks care deeply about the people who use their libraries. The question is which community and ecosystem are the best matches for your organization and your use case.

I hope this article helped to shed light on the developments in the modern web ecosystem and will help you build your next modern web application.

Please let me know what you think in the comments.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
