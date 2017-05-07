> * 原文地址：[Why TypeScript Is Growing More Popular](https://thenewstack.io/typescript-getting-popular/)
> * 原文作者：[Mary Branscombe](https://thenewstack.io/author/marybranscombe/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[loveky](https://github.com/loveky)
> * 校对者：

# 为何 TypeScript 变得更加流行了？ #

![](https://cdn.thenewstack.io/media/2017/04/2fd01361-unnamed-1024x876.jpg)

为何 [TypeScript](https://www.typescriptlang.org/) 这么流行呢？主要的开发框架依赖于它，它还可以提高开发人员在不断变化的 JavaScript 世界中的生产力。

在最近的 [Stack Overflow 开发者问卷](https://stackoverflow.com/insights/survey/2017#technology)以及年度[RedMonk](http://redmonk.com)编程[语言排名](https://redmonk.com/sogrady/2017/03/17/language-rankings-1-17/)中都显示 [TypeScript](https://www.thenewstack.io/tag/TypeScript) —— 由微软发起的结合了编译高级 JavaScript 特性与静态类型检查及工具的开源项目 —— 正在达到新的人气高度。通过为 JavaScript 提供[最基本的检查语法](https://medium.com/@tomdale/glimmer-js-whats-the-deal-with-typescript-f666d1a3aad0)，TypeScript 允许开发人员对他们的代码进行类型检查，这可以暴露 bug 并改善大型 JavaScript 代码库的结构和文档。

参与了 Stack Overflow 问卷的开发人员中有9.5% 的人正在使用 TypeScript，这使得 TypeScript 成为了第九流行的编程语言。排名在 Ruby 之前，用户量是 Perl 的两倍。此次 Stack Overflow 问卷中的受访者来自不同领域；使用最广泛的两种语言是 JavaScript 和 SQL，这说明此次问卷并非只针对前端开发领域。事实上，TypeScript 程序员出现在了参与 Stack Overflow 问卷的所有4种工作角色中；web 开发人员、桌面开发人员、系统管理员与 DevOps 以及数据科学家。

RedMonk 的排名将 Stack Overflow 的数据与 Github 上的 pull request 结合起来试图理解开发人员的想法以及他们正在使用什么。TypeScript 同样受到了开发者的欢迎，排名从26位上升到了17位。其中一部分原因是 Stack Overflow 上关注度的提升，但主要还是因为在 GitHub 上参与的开发者在不断增多。

的确，GitHub 在自己的2016[年度八卦](https://octoverse.github.com/)中把 TypeScript 列为在 GitHub 上用于项目开发的316中编程语言中最受欢迎榜单的第15位（基于 pull request 的数量以及相较与前一年 pull request 250%的增长率）。

在另一个针对开发者的调查中，TypeScript 在众多 JavaScript 的『替代』[风格](http://stateofjs.com/2016/flavors/)中拥有最高的使用率（21%）以及尚未的用户中最高的关注度（39%）。这项调查的方式不同寻常 —— 它很奇怪的将转译器和包管理器（如 [npm](https://www.npmjs.com/) 和 [Bower](https://bower.io/)）混合在一起 —— 但参与了这项调查且经常使用 TypeScript 的开发者也经常使用 [ECMAScript 2015](http://www.ecma-international.org/ecma-262/6.0/)、[NativeScript](https://www.nativescript.org/)、[Angular](https://angular.io/)，尤其是 Angular2。

来自 RedMonk 的 [Stephen O’Grady](http://redmonk.com/team/stephen-ogrady/) 指出『似乎有理由相信 Angular』在 TypeScript 的日益普及中发挥了作用。Angular2 只是众多使用了 TypeScript 的项目中的一个（Asana 和 Dojo 已经在使用了，Adobe、Google、Palantir、SitePen 以及 eBay 的一些内部项目也是一样）。但最为人们所熟知的，恐怕还是像 [Rob Wormald](https://twitter.com/robwormald) 这样的 Google 员工在宣传 Angular 时顺带推广了 TypeScript。

## 不止是 Angular2 ##

“There’s no doubt the partnership that we have with the Angular team has helped drive the numbers,” core TypeScript developer [Anders Hejlsberg ](https://twitter.com/ahejlsberg?lang=en)told The New Stack. “That goes without saying; but even so, I think the real point is that it was a massive vote of confidence on the part of an important industry force.”

That vote of confidence is broader than just Angular, he pointed out. “Lots of other frameworks are using TypeScript at this point. [Aurelia](http://aurelia.io/), [Ionic](https://ionicframework.com/), NativeScript are all, in one way or another, involved in TypeScript. The [Ember ](https://www.emberjs.com/)framework, the [Glimmer ](https://github.com/glimmerjs)framework that was just released is written in TypeScript.”

> “We’re seeing a pretty large vote of confidence by a lot of people who have a lot of experience in this industry and I think that’s probably what everyone at large is noticing,” — Anders Hejlsberg

That vote of confidence brings framework users on board too. “We’ve done a lot of work to be a really great citizen in the[ React ecosystem](https://facebook.github.io/react/). We support [JSX](https://jsx.github.io/), we support all the advanced type system features that you want like refactoring and code navigation on JSX markup. We’re also now working with the [Vue.js](https://vuejs.org/) community to provide better support for the patterns used in the framework,” Hejlsberg said.

Adding support for new frameworks is an important part of staying popular with developers. “We’re always on the lookout when it comes to frameworks. We understand that this a very dynamic ecosystem. It changes a lot; you’ve got to stay on your toes and work well with everything.”

The same is true for the tooling pipeline, especially as ECMAScript modules become more popular. “A lot of people writing modern style JavaScript apps use modules, and when you’re using ECMAScript 6 modules you need a bundler to bundle up your code so it can run in a browser, like [Webpack](https://webpack.github.io/) or [Rollup.js](https://rollupjs.org/). We make sure to work well with those tools so we fit into the whole pipeline,” Hejlsberg said.

[![](https://cdn.thenewstack.io/media/2017/04/940acc19-stateofthenation.png)](http://vmob.me/DE1Q17)

React is a library with Facebook roots. Angular is a Google-spawned framework. There is abundant analysis comparing them, and in general, it shows that Angular trails, with Vue.js getting significant buzz. Angular has seen a lot of uptake among TypeScript fans, with 41 percent prioritizing 2.x and another 18 percent favoring the older version. With the recent release of Angular 4 and TypeScript’s growing popularity, we expect the JavaScript wars to continue (Lawrence Hecht).

There’s also been the same steady growth in the number of libraries with TypeScript definitions. [DefinitelyTyped](http://definitelytyped.org/), a  repository for TypeScript typed definitions, now has over 3,000 frameworks and libraries. That’s accelerated by automatically scraping and publishing declaration files as npm packages under the @type namespace.

“That means there’s now a very predictable way of discovering what framework have types – and we can auto provision the types. When we see you’re importing a particular framework we can go find types for you so you don’t have to do it anymore.” In fact, Hejlsberg claimed, “for some developers, that’s becoming a decision factor when they pick a framework; whether they can work with a framework and get types.”

> “Often the way TypeScript ends up being adopted — in enterprises and start-ups and individual developers — is that you try it on one project and you say ‘wow, this is great!’ and then you start evangelizing and it grows locally in your sphere of influence.”— Anders Hejlsberg

The general rise in interest seems to be one of organic growth. “We don’t do any advertising whatsoever, this is all driven by the community. It’s actually steady growth and we’re just starting to notice the larger numbers now,” Hejlsberg said.

Hejlsberg notes that TypeScript is also the third most loved language in the Stack Overflow survey after Rust and Smalltalk (and just ahead of Swift and go) and the sixth most wanted language, head of both C# and Swift. “I think that speaks a lot to the fact that we’re actually solving real problems,” Hejlsberg said.

## Microsoft’s Sphere of Influence ##

It’s easy to view the success of TypeScript as Microsoft bringing enterprise developers who are already in the Microsoft world to JavaScript via familiar tools.

“We obviously have a large developer ecosystem already with C# and C++ and Visual Basic. Lots of enterprises use Microsoft tooling and they also have front ends, and when we start improving the world on the front end side, they sit up and take notice and start using that,” Hejlsberg admitted.

But while a lot of TypeScript development is done in [Visual Studio](https://www.visualstudio.com/), just as much is done in[ Visual Studio Code](https://code.visualstudio.com/), Microsoft’s open source, cross-platform IDE. “That’s a community we increasingly did not have all that much of a connection to. For Visual Studio Code, half of our users are not on Windows, so all of a sudden we’re having a conversation with a developer community that we did not really converse much with previously.”

## Open Source and on the Fast Track ##

The TypeScript team recently announced that releases will now happen every two months rather than quarterly, which Heljsberg called an attempt to make release dates more predictable, rather than holding up a new release to get a particular feature in. That’s the same approach that the ECMAScript committee is taking.

The new release cadence for TypeScript is also aligned with the Visual Studio Code schedule; partly because Visual Studio Code is actually written in TypeScript, but also because tooling is a key part of the appeal of TypeScript.

While it’s important that TypeScript supports multiple editors and IDEs, Hejlsberg noted that Visual Studio Code is another factor helping with the popularity of the language.

In fact, you get better coding features because of TypeScript, even if you only write in JavaScript, he explained. “Visual Studio Code and Visual Studio both use the TypeScript language service as their language service for JavaScript. Since TypeScript a superset of JavaScript, that means JavaScript is a subset of TypeScript it’s really just TypeScript without type annotations,” he noted.

In Visual Studio Code, opening a JavaScript file will trigger a TypeScript parser, scanner, lexer and type analyzer to provide statement completion and code navigation in the JavaScript code. “Even though there are no type annotations, we can infer an awful lot about a project structure just from the modules you’re using and the classes you’re declaring,” Hejlsberg said. “We can go and auto-provision type information for the framework you’re importing then we can give you excellent statement completion in JavaScript, which actually surprises the heck out of people.”

What makes this fast cadence possible are the tests required for pull requests to be accepted, guaranteeing the quality of the master branch, and the popularity of TypeScript, which means any problems are found quickly.

“We’re an open source project, we do a lot of work on GitHub. And we never take pull requests unless they pass all the 55,000 tests that we have, and unless they come with new tests if you’re implementing a new feature, or regressions test if it is fixing a bug. That means our master branch is always in very good shape,” he said.

## JavaScript: Powerful but Complex ##

More than any single factor, what might really be behind the increasing popularity of TypeScript is how complex JavaScript development has become, and also how powerful it can be.

“Our industry and our usage of JavaScript has changed dramatically,” Hejlsberg pointed out. “It used to be that we lived in a homogenous world where everyone was running Windows and using a browser, and that was how you got JavaScript. Now the world has become very heterogeneous. There are all sorts of different devices — phones and tablets, and running JavaScript on the backend with node, and JavaScript has jumped out of the browser using things like NativeScript or React Native or Cordova that allows you to build native apps using JavaScript.”

“Yes it’s more complicated but it’s also infinitely more capable,” Hejlsberg said of JavaScript. “You can reach so many different application profiles with JavaScript, with a single language and toolset. To me, that’s what is fueling all of this: The incredible breadth of the kinds of apps you can build, and the kinds of reusability and leverage you can get in this evolving ecosystem. It’s not just got more complex; it’s also gotten way more capable.”

*TNS analyst [Lawrence Hecht](https://thenewstack.io/author/lawrence-hecht/) contributed to this report.*



---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
