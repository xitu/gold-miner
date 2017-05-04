> * 原文地址：[Why TypeScript Is Growing More Popular](https://thenewstack.io/typescript-getting-popular/)
> * 原文作者：[Mary Branscombe](https://thenewstack.io/author/marybranscombe/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Why TypeScript Is Growing More Popular #

![](https://cdn.thenewstack.io/media/2017/04/2fd01361-unnamed-1024x876.jpg)

Why is [TypeScript](https://www.typescriptlang.org/) getting so popular? Key development frameworks depend on it and it improves developer productivity in the ever-changing JavaScript world.

The recent [Stack Overflow Developer Survey](https://stackoverflow.com/insights/survey/2017#technology) and the annual [RedMonk](http://redmonk.com) programming [language rankings](https://redmonk.com/sogrady/2017/03/17/language-rankings-1-17/) both showed that [TypeScript](https://www.thenewstack.io/tag/TypeScript) — the open source project started by Microsoft to combine transpiling for advanced JavaScript features with static type checking and tooling — is reaching new heights of popularity. By providing[ minimal checking syntax on top of JavaScript](https://medium.com/@tomdale/glimmer-js-whats-the-deal-with-typescript-f666d1a3aad0), TypeScript allows developers to type check their code, which can [reveal bugs and generally improve the organization and documentation](https://slack.engineering/typescript-at-slack-a81307fa288d) of large JavaScript code bases.

Nine and a half percent of the developers Stack Overflow surveyed are using TypeScript, making it the ninth most popular language, just ahead of Ruby and twice as popular with that audience as Perl. Stack Overflow reaches a diverse audience in this survey; the top two languages used are JavaScript and SQL, so this survey isn’t just querying front end development. In fact, TypeScript coders show up in all four of the job roles Stack Overflow asks about; web developers, desktop developers, admins and DevOps, and data scientists.

RedMonk’s rankings combine the Stack Overflow numbers with GitHub pull requests to find out what developers are thinking about, as well as what they’re using. TypeScript has also gained popularity with this audience of developers, moving from 26 to 17 in the rankings. Some of that is down to interest on Stack Overflow, but mostly it’s because of the increased developer involvement on GitHub.

Indeed, GitHub’s own 2016 [State of the Octoverse](https://octoverse.github.com/) puts TypeScript as the 15th most popular of the 316 programming languages developers use for projects on GitHub (based on both the number of pull requests and the 250 percent increase in pull requests for TypeScript over the previous year).

TypeScript also has both the highest usage (21 percent) and the highest interest among those not yet using it (39 percent) among the various “alternative” JavaScript [flavors](http://stateofjs.com/2016/flavors/) in another survey of developers. The methodology of this survey is unusual — it rather strangely conflates transpilers with package managers like [npm](https://www.npmjs.com/) and [Bower](https://bower.io/) — but the developers who responded to the survey and use TypeScript also commonly use [ECMAScript 2015](http://www.ecma-international.org/ecma-262/6.0/), [NativeScript](https://www.nativescript.org/), [Angular](https://angular.io/), and especially Angular2.

RedMonk’s [Stephen O’Grady ](http://redmonk.com/team/stephen-ogrady/)notes that “it seems reasonable to suspect that Angular is playing a role” in the increasing popularity of TypeScript. Angular2 is just one of the projects that has adopted TypeScript though (Asana and Dojo already used it, as do internal projects at Adobe, Google, Palantir, SitePen and eBay). But it might be the best known — with Google employees like Rob Wormald [@robwormald] evangelizing TypeScript alongside Angular.

## Not Just Angular2 ##

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
