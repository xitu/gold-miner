
> * 原文地址：[Angular vs. React vs. Vue: A 2017 comparison](https://medium.com/unicorn-supplies/angular-vs-react-vs-vue-a-2017-comparison-c5c52d620176)
> * 原文作者：[Jens Neuhaus](https://medium.com/@jensneuhaus?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/angular-vs-react-vs-vue-a-2017-comparison.md](https://github.com/xitu/gold-miner/blob/master/TODO/angular-vs-react-vs-vue-a-2017-comparison.md)
> * 译者：
> * 校对者：

# Angular vs. React vs. Vue: A 2017 comparison

Deciding on a JavaScript framework for your web application can be overwhelming. [Angular](https://angular.io/) and [React](https://facebook.github.io/react/) are very popular these days, and there is an upstart which has been getting a lot of traction lately: [VueJS](https://vuejs.org/). What’s more, these are just a few of the new [kids on the block](https://hackernoon.com/top-7-javascript-frameworks-c8db6b85f1d0).

![Javascripts in 2017 — things aren’t easy these days!](https://cdn-images-1.medium.com/max/800/1*xRhs4h2a_rGpXNpoSNlA9w.png)

So, how are we supposed to decide? A pros-and-cons list never hurts. We’ll do this in the style of my previous article, “[9 Steps: Choosing a tech stack for your web application](https://medium.com/unicorn-supplies/9-steps-how-to-choose-a-technology-stack-for-your-web-application-a6e302398e55)”.

## Before we start — SPA or not?

You should first make a clear decision as to whether you need a single-page-application (SPA) or if you’d rather take a multi-page approach. Read more on this in my blog post, “[Single-page-application (SPA) vs. Multi-page web applications (MPA)](https://medium.com/unicorn-supplies/angular-vs-react-vs-vue-a-2017-comparison-c5c52d620176#)” (coming soon, follow me [on Twitter](http://www.twitter.com/jensneuhaus/) for updates).

## The starters today: Angular, React and Vue

First, I’d like to discuss **lifecycle & strategic considerations**. Then, we’ll move to the **features & concepts** of the three javascript frameworks. Finally, we’ll come to a **conclusion**.

Here are the questions we’ll address today:

- How **mature are the frameworks / libraries**?
- Are the frameworks likely to **be around for a while**?
- How **extensive and helpful are their corresponding communities**?
- How **easy is it to find developers** for each of the frameworks?
- What are the **basic programming concepts** of the frameworks?
- How easy is it to use the frameworks **for small or large applications**?
- What does the **learning curve** look like for each framework?
- What kind of **performance** can you expect from the frameworks?
- Where can you have **a closer look under the hood**?
- How **can you start developing** with the chosen framework?

Ready, set, GO!

## Lifecycle & strategic considerations

![React vs. Angular vs. Vuettps://cdn-images-1.medium.com/max/800/1*aPijhbTjT0VOxPYq2RkVUw.png)

### Some history

**Angular** is a TypeScript-based Javascript framework. Developed and maintained by Google, it’s described as a “Superheroic JavaScript [MVW](https://plus.google.com/+AngularJS/posts/aZNVhj355G2) Framework”. Angular (also “Angular 2+”, “Angular 2” or “ng2”) is the rewritten, mostly incompatible successor to AngularJS (also “Angular.js” or “AngularJS 1.x”). While AngularJS (the old one) was initially released in October 2010, it is still getting [bug-fixes](https://github.com/angular/angular.js), etc. — the new Angular (sans JS) was introduced in September 2016 as version 2. The newest major release is version 4, [as version 3 was skipped](http://www.infoworld.com/article/3150716/application-development/forget-angular-3-google-skips-straight-to-angular-4.html). Angular is used by Google, Vine, Wix, Udemy, weather.com, healthcare.gov and Forbes (according to [madewithangular](https://www.madewithangular.com/), [stackshare](https://stackshare.io/angular-2) and [libscore.com](http://libscore.com/#angular)).

**React** is described as “a JavaScript library for building user interfaces”. Initially released in March 2013, React was developed and is maintained by Facebook, which uses React components on several pages (not as a single-page application, however). According [to this article](https://medium.com/@chriscordle/why-angular-2-4-is-too-little-too-late-ea86d7fa0bae) by [Chris Cordle](https://medium.com/@chriscordle), React is used far more at Facebook than Angular is at Google. React is also used by Airbnb, Uber, Netflix, Twitter, Pinterest, Reddit, Udemy, Wix, Paypal, Imgur, Feedly, Stripe, Tumblr, Walmart and others (according to [Facebook](https://github.com/facebook/react/wiki/Sites-Using-React), [stackshare](https://stackshare.io/react) and [libscore.com](http://libscore.com/#React)).

Facebook is working on the release of **React Fiber**. It will change React under the hood — rendering is supposed to be much faster as a result — but things will be backward-compatible after the changes. Facebook [talked about](https://developers.facebook.com/videos/f8-2017/the-evolution-of-react-and-graphql-at-facebook-and-beyond/) the changes at its developer conference in April 2017, and an unofficial [article about the new architecture](https://github.com/acdlite/react-fiber-architecture) was released. React Fiber will be probably be released with React 16.

**Vue** is one of the most rapidly growing JS frameworks in 2016. Vue describes itself as a “Intuitive, Fast and Composable [MVVM](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel) for building interactive interfaces.” It was first released in February 2014 by ex-Google-employee [Evan You](https://github.com/yyx990803) (BTW: Evan wrote an interesting blog post about the [marketing activities and numbers in the first week](http://blog.evanyou.me/2014/02/11/first-week-of-launching-an-oss-project/) back then). It’s been quite a success, especially given that Vue is getting so much traction as a one-man show without the backing of a big company. Evan currently has a team of dozen core developers. In 2016, version 2 was released. Vue is used by Alibaba, Baidu, Expedia, Nintendo, GitLab — a list of smaller projects can be found on [madewithvuejs.com](https://madewithvuejs.com/).

Angular and Vue are both available under the **MIT license**, while React comes with the **[BSD3-license](https://en.wikipedia.org/wiki/BSD_licenses#3-clause_license_.28.22BSD_License_2.0.22.2C_.22Revised_BSD_License.22.2C_.22New_BSD_License.22.2C_or_.22Modified_BSD_License.22.29)**. There are a lot of discussions on the patent file. [James Ide](https://medium.com/@ji) (Ex-Facebook engineer) explains [the reasons and the history behind](https://medium.com/@ji/the-react-license-for-founders-and-ctos-b38d2538f3e5) the file: Facebook’s patent grant is about sharing its code while preserving its ability to defend itself against patent lawsuits. The patent file was updated once and some people claim, that it is okay to use React, if your company is not going to sue Facebook. You can check the discussion [in this Github issue](https://github.com/facebook/react/issues/7293). I am not a lawyer, so you should decide yourself, if the React license is problematic for you or your company. There are still a lot of articles on this topic: [Dennis Walsh](https://medium.com/@dwalsh.sdlr) writes, [why you should not be scared](https://medium.com/@dwalsh.sdlr/react-facebook-and-the-revokable-patent-license-why-its-a-paper-25c40c50b562). [Raúl Kripalani](https://medium.com/@raulk) is warning [against the use for startups](https://medium.com/@raulk/if-youre-a-startup-you-should-not-use-react-reflecting-on-the-bsd-patents-license-b049d4a67dd2), he is also having an [brain dump overview](https://medium.com/@raulk/further-notes-and-questions-arising-from-facebooks-bsd-3-strong-patent-retaliation-license-c6386e8e1d60). Also there is an lately original statement from Facebook on this topic: [Explaining React’s license](https://code.facebook.com/posts/112130496157735/explaining-react-s-license/).

### Core development

As already noted, Angular and React are supported and used by big companies. Facebook, Instagram and Whatsapp are using it for their pages. Google uses it in a lot of projects: for example, the new Adwords UI was implemented using [Angular & Dart](http://news.dartlang.org/2016/03/the-new-adwords-ui-uses-dart-we-asked.html?m=1). Again, Vue is realized by a group of individuals whose work is supported via Patreon and other means of sponsorship. You can decide for yourself whether this is a positive or negative. [Matthias Götzke](https://medium.com/@mgoetzke) thinks that Vue’s small team is a benefit because it [leads to cleaner and less over-engineered code / API](https://medium.com/@mgoetzke/some-people-have-been-asking-about-the-dependability-of-vue-jss-9dc2842b3709).

Let’s have a look at some statistics: Angular [lists 36 people](https://angular.io/about?group=Angular) on their team page, Vue [lists 16 people](https://vuejs.org/v2/guide/team.html), and React doesn’t have a team page. **On Github**, Angular has > 25,000 stars and 463 contributors, React has > 70,000 stars and > 1,000 contributors, and Vue has almost 60,000 stars and only 120 contributors. You can also check the [Github Stars History for Angular, React and Vue](http://www.timqian.com/star-history/#facebook/react&angular/angular&vuejs/vue). Once again, Vue seems to be trending very well. According to [bestof.js](https://bestof.js.org/tags/framework/trending/last-3-months), over the last three months Angular 2 has been getting an average of 31 stars per day, React 74 stars, and Vue.JS 107 stars.

![A Github Stars History for Angular, React & Due (Source)](https://cdn-images-1.medium.com/max/800/1*vvRdTNyQNrDeAxBXzBbqQw.png)

[Source](http://www.timqian.com/star-history/#facebook/react&angular/angular&vuejs/vue)

**Update**: Thanks to [Paul Henschel](https://medium.com/@drcmda) for pointing out the [npm trends](http://www.npmtrends.com/angular-vs-react-vs-vue-vs-@angular/core). They show the number of downloads for the given npm packages and are even more helpful as a pure look at the Github stars:

![The npm download numbers for the given npm packages in the last 2 years.](https://cdn-images-1.medium.com/max/800/1*JKPQhZwOGAAlViSYsUf--w.png)

### Market lifecycle

It’s hard to compare Angular, React and Vue in Google Trends because of the various names and versions. One way to approximate could be to the search in the category “Internet & technologies”. Here is the result:

![](https://cdn-images-1.medium.com/max/600/1*gTNdON6wlXXiDJONUUtioQ.png)

Oh, well. Vue was not created before 2014 — so something is amiss here. La Vue is French for“view”, “sight” or “opinion”. Maybe it’s that. A comparison of “VueJS” and “Angular” or “React” is not fair either, as VueJS has hardly any results compared to the others.

Let’s try something else, then. The [Technology Radar](https://www.thoughtworks.com/de/radar#) from ThoughtWorks gives a good impression of how technologies evolve over time. Redux is [in the adoption stage](https://www.thoughtworks.com/de/radar/languages-and-frameworks/redux) (to be adopted in projects!), and it has been invaluable in a number of ThoughtWorks projects. Vue.js is [in the trial stage](https://www.thoughtworks.com/de/radar/languages-and-frameworks/vue-js) (try it out!). It is described as a lightweight and flexible alternative to Angular with a lower learning curve. Angular 2 [is in the assessment stage](https://www.thoughtworks.com/de/radar/languages-and-frameworks/angular-2) — it is used successfully by ThoughtWork teams, but not a strong recommendation yet.

According to [the last Stackoverflow 2017 survey](https://insights.stackoverflow.com/survey/2017#most-loved-dreaded-and-wanted), React is loved by 67% of surveyed developers and AngularJS by 52%. “No interest to continue developing” registers higher numbers for AngularJS (48%) vs. React (33%). Vue is not in the Top 10 in either case. Then there’s the statejs.com survey comparing “[front-end frameworks](http://stateofjs.com/2016/frontend/)”. The most interesting facts: React and Angular have 100% awareness, and Vue is unknown to 23% of the people surveyed. Regarding satisfaction, React scored 92% for “would use again”, Vue 89% and Angular 2 only 65%.

What about another customer satisfaction poll? [Eric Elliott](https://medium.com/@_ericelliott) started one in October 2016 to evaluate Angular 2 and React. Only 38% of the people surveyed would use Angular 2 again, while 84% would use React again.

### Long-term support & migrations

React APIs are quite stable, as Facebook [states in their design principles](https://facebook.github.io/react/contributing/design-principles.html#stability). There are also some scripts to help you move from your current API to a newer one: check out [react-codemod](https://github.com/reactjs/react-codemod). Migrations are quite easy and there is no such thing (needed) as a long-term-support version. In this Reddit post, people note that the upgrades [never really were a problem](https://www.reddit.com/r/reactjs/comments/5a45ai/is_react_a_good_choice_for_a_stable_longterm_app/). The React team wrote a blog post about their [versioning scheme](https://facebook.github.io/react/blog/2016/02/19/new-versioning-scheme.html). When they add a deprecation warning, they keep it for the rest of the current release version before the behavior is changed in the next major version. There is no planned change to a new major version — v14 was released in October 2015, v15 was published in April 2016, and v16 does not have a release date yet. The upgrade should not be a problem, as recently [noted by a React core developer](https://github.com/facebook/react/issues/8854#issuecomment-312527769).

Regarding Angular, there is a blog post [about versioning and releasing](http://angularjs.blogspot.de/2016/10/versioning-and-releasing-angular.html) Angular starting with the v2 release. There will be one major update every six months, and there will be a deprecation period of at least six months (two major releases). There are some experimental APIs marked in the documentation with shorter deprecation periods. There is no official announcement yet, but according [to this article](https://www.infoq.com/news/2017/04/ng-conf-2017-keynote), the Angular team has announced **long-term-support versions starting with Angular 4**. Those will be supported for at least one year beyond the next major version release. This means Angular 4 will be supported until at least **September 2018** with bug-fixes and important patches. In most cases, updating Angular from v2 to v4 is as easy as updating the Angular dependencies. Angular also [offers a guide](https://angular-update-guide.firebaseapp.com/) with information as to whether further changes are needed.

The update process for Vue 1.x to 2.0 should be easy for a small app — the developer team has asserted [that 90% of the APIs](https://vuejs.org/v2/guide/migration.html) stayed the same. There is a [nice upgrade-diagnostic migration-helper](https://github.com/vuejs/vue-migration-helper) tool working on the console. One developer [noted](https://news.ycombinator.com/item?id=13151966) that the update from v1 to v2 was still no fun in a big app. Unfortunately, there is no clear (public) roadmap about the next major version or information on plans for LTS versions.

One more thing: Angular is a full framework and offers a lot of things bundled together. React is more flexible than Angular, and you will probably wind up using more independent, unsettled, fast-moving libraries — this means that you need to take care of the corresponding updates and migrations on your own. It could also be a detriment if certain packages are no longer maintained or some other package becomes the de facto standard at some point.


### Human resources & recruiting

If you have in-house HTML developers who do not want to learn more Javascript, you are better off choosing Angular or Vue. React entails more Javascript (we talk about this later).

Do you have designers working close to the code? The user “pier25” notes on Reddit [that React makes sense if you are working for Facebook, where everyone is a superhero developer](https://www.reddit.com/r/webdev/comments/5ho71i/why_we_chose_vuejs_over_react/deuynwc/). In the real world, you won’t always find a designer who can modify JSX — as such, working with HTML templates will be much easier.

The good thing about the Angular framework is that a new Angular 2 developer from another company will quickly familiarize themselves with all the requisite conventions. React projects are each different in terms of architectural decisions, and developers need to get familiar with the particular project setup.

Angular is also good if you have developers with an object-oriented background or who don’t like Javascript. To drive that point home, here is [a quote from Mahesh Chand](http://www.c-sharpcorner.com/article/angular-2-or-react-for-decision-makers/):

> I am not a JavaScript developer. My background is building large-scale enterprise systems using “real” software platforms. I started in 1997 building applications using C, C++, Pascal, Ada, and Fortran. (…) I can clearly say that JavaScript is just gibberish to me. Being a Microsoft MVP and expert, I have a good understanding of TypeScript. I also don’t see Facebook as a software development company. However, Google and Microsoft are already the largest software innovators. I feel more comfortable working with a product that has strong backing from Google and Microsoft. Also (…) with my background, I know Microsoft has even bigger plans for TypeScript.

Well, then… I should probably mention that Mahesh is a Regional Director at Microsoft.

## Comparison of React, Angular & Vue

### Components

The frameworks in question are all component-based. A component gets an input, and after some internal behavior / computing, it returns a rendered UI template (a sign in / sign out area or a to-do list item) as output. The defined components should be easy to reuse on the webpage or within other components. For example, you could have a grid component (consisting of a header component and several row components) with various properties (columns, header information, data rows, etc.) and be able to reuse the component with different data sets on another page. Here is [a comprehensive article about components](https://derickbailey.com/2015/08/26/building-a-component-based-web-ui-with-modern-javascript-frameworks/), in case you’d like to learn more about this.

React and Vue both excel at handling dumb components: small, stateless functions that receive an input and return elements as output.

### Typescript vs. ES6 vs. ES5

React focuses on the use of Javascript ES6. Vue uses Javascript ES5 or ES6.

Angular relies on **TypeScript**. This offers more consistency in related examples and open source projects (React examples can be found in either ES5 or ES6). This also introduces concepts like decorators and static types. Static types are useful for code intelligence tools, like automatic refactoring, jump to definitions, etc. — they are also supposed to reduce the number of bugs in an application., though there certainly isn’t consensus on this topic. [Eric Elliott](https://medium.com/@_ericelliott) disagrees in his article “[The shocking secret about static types](https://medium.com/javascript-scene/the-shocking-secret-about-static-types-514d39bf30a3)”. Daniel C Wang says that the [cost of using static types does no harm](https://medium.com/@danwang74/the-economics-between-testing-and-types-4a3f8c8a86eb) and that it’s good to have both test-driven development (TDD) and static typing.

You should also probably know that you [can use Flow to enable type-checking within React](https://www.sitepoint.com/writing-better-javascript-with-flow/). It’s a static type-checker developed by Facebook for JavaScript. Flow can [also be integrated into VueJS](https://alligator.io/vuejs/components-flow/).

If you are writing your code in TypeScript, you are not writing standard JavaScript anymore. Even though it’s growing, TypeScript still has a tiny user base compared to that of the whole JavaScript language. One risk could be that you’re moving in the wrong direction because TypeScript may — however unlikely it is — also disappear over time. Additionally, TypeScript adds a lot of (learning) overhead to projects — you can read more about this in the [Angular 2 vs. React comparison](https://medium.com/javascript-scene/angular-2-vs-react-the-ultimate-dance-off-60e7dfbc379c) by [Eric Elliott](https://medium.com/@_ericelliott).

**Update**: [James Ravenscroft](https://medium.com/@jrwebdev) wrote in a comment to this article, that [TypeScript has first-class support for JSX](https://medium.com/@jrwebdev/id-argue-that-if-you-love-typescript-then-react-may-be-a-better-choice-ceec950ee543) — components can be type-checked seamlessly. So if you like TypeScript and you want to use React, this should not be a problem.

### Templates — JSX or HTML

React breaks with long-standing best practices. For decades, developers were trying to separate UI templates and inline Javascript logic, but with JSX, these are intermixed again. This might sound terrible, but you should listen to Peter Hunt’s talk “[React: Rethinking best practices](https://www.youtube.com/watch?v=x7cQ3mrcKaY)” (from October 2013). He points out that separating templates and logic is merely a separation of technologies, not concerns. You should build components instead of templates. Components are reusable, composable and unit-testable.

JSX is an optional preprocessor for HTML-like syntax which will be compiled in Javascript later. It has some quirks — for example, you need to use className instead of class, because the latter is a protected name in Javascript. JSX is a big advantage for development, because you have everything in one place, and code completion and compile-time checks work better. When you make a typo in JSX, React won’t compile, and it prints out the line number where the typo occurred. Angular 2 fails quietly at run time (this is argument is probably invalid if you use AOT with Angular).

JSX implies that everything in React is Javascript — it is used for both the JSX templates and the logic. [C]ory House](https://medium.com/@housecor) points this out in [his article](https://medium.freecodecamp.org/angular-2-versus-react-there-will-be-blood-66595faafd51) from January 2016: “Angular 2 continues to put ‘JS’ into HTML. React puts ‘HTML’ into JS.”. This is a good thing, because Javascript is more powerful than HTML.

The Angular templates are enhanced HTML with special Angular language (Things like ngIf or ngFor). While React requires knowledge of JavaScript, Angular forces you to learn [Angular-specific syntax](https://angular.io/guide/cheatsheet).

Vue features “[single-file components](https://vuejs.org/v2/guide/single-file-components.html)”. This seems like a trade-off with regard to the separation of concerns — templates, scripts and styles are in one file but in three different, ordered sections. This means you get syntax highlighting, CSS support and easier use of preprocessors like Jade or SCSS. I have read in other articles, that JSX is easier for debugging because Vue will not show bad HTML syntax errors. This is not true because Vue [converts HTML to render functions](https://vuejs.org/v2/guide/render-function.html) — so errors are shown without problems (Thanks to [Vinicius Reis](https://medium.com/@luizvinicius73) for commenting and the correction!).

Side note: If you like the idea of JSX and want to use it in Vue, you can use [babel-plugin-transform-vue-jsx](https://github.com/vuejs/babel-plugin-transform-vue-jsx).

### Framework vs. library

Angular is a framework rather than a library because it provides strong opinions as to how your application should be structured and also has more functionality out of the box. Angular is a “complete solution” — batteries included and ready to provide you with a pleasant start. You don’t need to analyze libraries, routing solutions or the like — you can just start working.

React and Vue, on the other hand, are universally flexible. Their libraries can be paired to all kinds of packages (there are quite a lot for React on [npm](https://www.npmjs.com/search?q=react&page=1&ranking=popularity), but Vue has fewer packages because it’s still quite young). With React, you can even exchange the library itself for API-compatible alternatives like [Inferno](https://infernojs.org/). However, with great flexibility comes great responsibility — there are no rules and limited guidance with React. Every project requires a decision regarding its architecture, and things can go wrong more easily.

Angular, on the other hand, comes with a confusing nest of build tools, boilerplate, linters & time-sinks to deal with. This is also true of React if starter kits or boilerplates are used. They’re naturally very helpful, but React works out of the box, and that’s probably the way you should learn it. Sometimes the variety of tools needed for a working in a Javascript environment is referred to as “Javascript fatigue”. There is an [article](https://medium.com/@ericclemmons/javascript-fatigue-48d4011b6fc4) about it by [Eric Clemmons](https://medium.com/@ericclemmons), who has this to say:

> There are still a bunch of installed tools, you are not used to, when starting with the framework. These are generated but probably a lot of developers do not understand, what is happening under the hood — or it takes a lot of time for them to do.

Vue seems to be the cleanest and lightest of the three frameworks. GitLab has a [blog post about its decision regarding Vue.js](https://about.gitlab.com/2016/10/20/why-we-chose-vue/) (October 2016):

> Vue.js comes with the perfect balance of what it will do for you and what you need to do yourself.(…) Vue.js is always within reach, a sturdy, but flexible safety net ready to help you keep your programming efficient and your DOM-inflicted suffering to a minimum.

They like the simplicity and ease of use — the source code is very readable, and no documentation or external libraries are needed. Everything is very straightforward. Vue.js “does not make large assumptions about much of anything either”. There’s also a [podcast about GitLab’s decision](https://www.youtube.com/watch?v=ioogrvs2Ejc#action=share).

Another blogpost [about a shift towards](http://pixeljets.com/blog/why-we-chose-vuejs-over-react/) Vue comes from Pixeljets. React “was a great step forward for JS world in terms of [state-awareness](https://en.wikipedia.org/wiki/Single_source_of_truth), and it showed lots of people the real functional programming in a good, practical way”. One of the big cons of React vs. Vue is the problem of splitting components into smaller components because of the JSX restrictions. Here is a quote of the article:

> For me and my team the readability of code is important, but it is still very important that writing code is fun. It is not funny to create 6 components when you are implementing really simple calculator widget. In a lot of cases, it is also bad in terms of maintenance, modifications, or applying visual overhaul to some widget, because you need to jump around multiple files/functions and check each small chunk of HTML separately. Again, I am not suggesting to write monoliths — I suggest to use components instead of microcomponents for day-to-day development.

There are interesting discussions about the blog post on [Hacker news](https://news.ycombinator.com/item?id=13151317) and [Reddit](https://www.reddit.com/r/webdev/comments/5ho71i/why_we_chose_vuejs_over_react/) — there are arguments from dissenters and further supporters of Vue alike.

### State management & data binding

Building UIs is hard, because there are states everywhere — data changing over time entails complexity. Defined state workflows are a big help when apps grow and get more complex. For limited applications, this is probably overkill and something like Vanilla JS would be sufficient.

How does it work? Components describe the UI at any point in time. When data changes, the framework re-renders the entire UI component — displayed data is always up-to-date. We can call this concept “UI as function”.

React often works bundled with Redux. **Redux** describes itself in three [fundamental principles](http://redux.js.org/docs/introduction/ThreePrinciples.html):

- Single source of truth
- State is read-only
- Changes are made with pure functions

In other words: the status of the complete application is stored in an object tree within a single store. This helps with debugging the application, and some functionalities are easier to implement. The state is read-only and can only be changed via actions to avoid race conditions (it also helps with debugging). Reducers are written to specify how the states can be transformed by actions.

Most of the tutorials and boilerplates have Redux already integrated, but you can use React without it (and you might not need Redux in your project at all). Redux introduces complexity and pretty strong constraints into your code. If you are learning React, you should think about learning plain React before you head over to Redux. You should definitely read “[You might not need Redux](https://medium.com/@dan_abramov/you-might-not-need-redux-be46360cf367)” by [Dan Abramov](https://medium.com/@dan_abramov).

[Some developers](https://news.ycombinator.com/item?id=13151577) suggest the use of **[Mobx](https://github.com/mobxjs/mobx) instead of Redux**. You can think of it as an “automatic Redux”, which makes things much easier to use and understand at the outset. If you want to have a look, you should start with the [introduction](https://mobxjs.github.io/mobx/getting-started.html). You can also read this [useful comparison between Redux & MobX](https://www.robinwieruch.de/redux-mobx-confusion/) by Robin. The same author also offers information on [moving from Redux to MobX](https://www.robinwieruch.de/mobx-react/). [This list](https://github.com/voronianski/flux-comparison) is useful if you want to check on other Flux libraries. And if you are coming from an MVC-world, you’ll want to read the article “[Thinking in Redux (when all you’ve known is MVC)](https://medium.com/p/thinking-in-redux-when-all-youve-known-is-mvc-c78a74d35133?source=user_popover)” by [Mikhail Levkovsky](https://medium.com/@mlovekovsky).

Vue can make use of Redux — but it offers [Vuex](https://github.com/vuejs/vuex) as its own solution.

A big difference between React and Angular is **one-way vs. two-way binding**. Angular’s two-way-binding changes the model state when the UI element (e.g. a user input) is updated. React only goes one way: it updates the model first and then it renders the UI element. Angular’s method is cleaner in the code and easier for the developer to implement. React’s way results in a better data overview, because the data only flows in one direction (this makes debugging easier).

Both concepts have there pros and cons. You need to understand the concepts and determine if this influences your framework decision. The article “[Two-way-data binding: Angular 2 and React](https://www.accelebrate.com/blog/two-way-data-binding-angular-2-and-react/)” and [this Stackoverflow question](https://stackoverflow.com/questions/34519889/can-anyone-explain-the-difference-between-reacts-one-way-data-binding-and-angula) both offer a good explanation. [Here](http://n12v.com/2-way-data-binding/) you can find some interactive code examples (3 years old, for Angular 1 & React only). Last but not least, Vue supports both [one-way-binding and two-way-binding](https://medium.com/js-dojo/exploring-vue-js-reactive-two-way-data-binding-da533d0c4554) (one-way by default).

There is a long article about different types of states and the [state management in Angular applications](https://blog.nrwl.io/managing-state-in-angular-applications-22b75ef5625f) (by [Victor Savkin](https://medium.com/@vsavkin)) if you want to read further.

### Other programming concepts

Angular includes dependency injection, a pattern in which one object supplies the dependencies (a service) to another object (a client). This leads to more flexibility and cleaner code. The article “[Understanding dependency injection](https://github.com/angular/angular.js/wiki/Understanding-Dependency-Injection)” explains this concept in more detail.

The [model-view-controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) pattern (MVC) splits a project into three components: model, view and controller. Angular as an MVC-framework has MVC out of the box. React only has the V — you need to solve the M and C on your own.

### Flexibility & downsizing to microservices

You can work with React or Vue by simply adding the Javascript library to the source code. This is not possible with Angular because of its use of TypeScript.

We’re now moving more towards microservices and microapps. React and Vue give you more control to size an application by selecting only the things which are really necessary. They offer more flexibility to shift from an SPA to microservices using parts of a former application. Angular work best for SPA, as it is probably too bloated to be used for microservices.

As [Cory House](https://medium.com/@housecor) notes:

> JavaScript moves fast, and React allows you to swap out small pieces of your application for better libraries instead of waiting around and hoping your framework will innovate. **The philosophy of small, composable, single-purpose tools never goes out of style**.

Some people use React for non-SPA websites as well (e.g. for complex forms or wizards). Even Facebook uses React — not for the main page, but rather for specific pages and features.

### Size & performance

There is a flip-side to all the functionality: the Angular framework is quite bloated. The gzipped file size is 143k, compared to 23K for Vue and 43k for React.

React and Vue both have a Virtual DOM , which is supposed to improve performance. If you’re interested in this, you can read about the [differences between the Virtual DOM & DOM](http://reactkungfu.com/2015/10/the-difference-between-virtual-dom-and-dom/), as well as [the real benefits of the Virtual DOM in react.js](https://www.accelebrate.com/blog/the-real-benefits-of-the-virtual-dom-in-react-js/). Also, one of the authors of the Virtual-DOM itself [answers a performance-related question](https://stackoverflow.com/questions/21109361/why-is-reacts-concept-of-virtual-dom-said-to-be-more-performant-than-dirty-mode) on Stackoverflow.

To check the performance, I had a look at the great [js-framework-benchmark](https://github.com/krausest/js-framework-benchmark). You can download and run it yourself, or have a look at the [interactive result table](http://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html).

![](https://cdn-images-1.medium.com/max/800/1*YpbalqSUMYIYjXCduq7dcA.png)

The Performance of Angular, React and Vue ([Source](http://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html))

![](https://cdn-images-1.medium.com/max/800/1*gpq0Y-rRczJ5C3DI5_EUlw.png)

Memory allocation in MB ([Source](http://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html))

To summarize: Vue has great performance and the deepest memory allocation, but all these frameworks are really pretty close to each other when compared to particularly slow or fast frameworks (like [Inferno](http://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html)). Keep in mind that performance benchmarks should only be considered as side note, not as a verdict.

### Testing

Facebook [uses Jest](http://facebook.github.io/jest/) to tests its React code. Here is a [comparison between Jest and Mocha](https://spin.atomicobject.com/2017/05/02/react-testing-jest-vs-mocha/) — and there is an article on [how to use Enzyme with Mocha](https://semaphoreci.com/community/tutorials/testing-react-components-with-enzyme-and-mocha). [Enzyme](https://github.com/airbnb/enzyme) is a JavaScript testing utility used at Airbnb (in conjunction with Jest, Karma and other test runners). If you want to read more, there are some older articles on testing in React ([here](https://medium.com/@bruderstein/the-missing-piece-to-the-react-testing-puzzle-c51cd30df7a0) and [here](http://reactkungfu.com/2015/07/approaches-to-testing-react-components-an-overview/)).

Then there is **Jasmine** as a testing framework in Angular 2. There’s rant in an article by [Eric Elliott](https://medium.com/@_ericelliott) that says Jasmine “results in millions of ways to write tests and assertions, needing to carefully read each one to understand what it´s doing”. The output is also very bloated and laborious to read. There are some informative articles on the integration of Angular 2 [with Karma](https://medium.com/@laco0416/setting-up-angular-2-testing-environment-with-karma-and-webpack-e9b833befd99) and [Mocha](https://medium.com/@PeterNagyJob/angular2-configuration-and-unit-testing-with-mocha-and-chai-4ada9484e569). Here is an old video (from 2015) about [the testing strategies with Angular 2](https://www.youtube.com/watch?v=C0F2E-PRm44).

Vue lacks testing guidance, but Evan wrote in his 2017 preview that [the team plans to work on this](https://medium.com/the-vue-point/vue-in-2016-8df71d98bfb3). They recommend using [Karma](http://karma-runner.github.io/1.0/index.html). Vue works [together with Jest](https://github.com/locoslab/vue-jest-utils), and there’s also [avoriaz as a test utility](https://github.com/eddyerburgh/avoriaz).

### Universal & native apps

Universal apps are introducing apps into the web, onto the desktop and into the world of native apps, as well.

React and Angular both support native development. Angular has [NativeScript](https://docs.nativescript.org/tutorial/ng-chapter-0) (backed by Telerik) for native apps and Ionic Framework for hybrid apps. With React, you can check out [react-native-renderer](http://angularjs.blogspot.de/2016/04/angular-2-react-native.html) to build cross-plattform iOS and Android apps, or [react-native](https://facebook.github.io/react-native/) for native apps. A lot of apps (including Facebook; check the [Showcase](https://facebook.github.io/react-native/showcase.html) for more) are built with react-native.

Javascript frameworks render pages on the client. This is bad for perceived performance, overall user experience and SEO. Server-side pre-rendering is a plus. All three frameworks have libraries to find help with that. For React there is [next.js](https://github.com/zeit/next.js) , Vue has [nuxt.js](https://nuxtjs.org/), and Angular has….[Angular Universal](https://universal.angular.io/).

### Learning curve

There is definitely a steep learning curve for Angular. It has comprehensive documentation, but sometimes you might feel frustrated with it because things are [more difficult than they sound](https://www.reddit.com/r/webdev/comments/5ho71i/why_we_chose_vuejs_over_react/db1vppj/). Even when you have a deep understanding of Javascript, you need to learn what’s going on under the hood of the framework. Setup is magical in the beginning, and it offers a lot of included packages and code. This can be seen as a negative because there is a big, pre-existing ecosystem you need to learn over time. On the other hand, it could be good in a given situation because a lot of decisions have already made. With React, you’ll probably need to make a lot of imposing decisions with regard to third party libraries. There are 16 [different flux packages for state management](https://github.com/voronianski/flux-comparison) to choose from in React alone.

Vue is pretty easy to learn. Companies switch to Vue because its seems to be much easier for junior developers. Here you can read about somebody describing his team’s move [from Angular to Vue](https://medium.com/@Hemantisme/moving-from-angular-to-vue-a-vuetiful-journey-c29842ab2039). According to [another user](https://news.ycombinator.com/item?id=13151716), the React app at his company was so complex that a new developer couldn’t keep up with the code. With Vue, the gap between junior and senior developers shrinks, and they can collaborate more easily and with fewer bugs, problems and time to develop.

Some people claim that things they have done in React would have been better written in Vue. If you are an unexperienced Javascript developer — or if you worked mainly with jQuery in the last decade — you should think about using Vue. The paradigm shift is more pronounced when moving to React. Vue looks more like plain Javascript while also introducing some new ideas: components, an event-driven-model, and one-way data flow. It also has a small footprint.

Meanwhile, Angular and React have their own way of doing things. They may get in your way, because you need to adjust your practices to make things work their way. That can be a detriment because you are less flexible, and there is a steeper learning curve. It could also be a benefit because you are forced to learn the right concepts while learning the technology. With Vue, you can do the things the old-Javascript-fashioned way. This can be easier in the beginning, but could become a problem in the long-run if things are not done properly.

When it comes to debugging, it’s a plus that React and Vue have less magic. The hunt for bugs is easier because there are fewer places to look and the stack traces have better distinctions between their own code and that of the libraries. People working with React report that they never have to read the source code of the library. However, when debugging your Angular application, you often need to debug the internals of Angular to understand the underlying model. On the bright side, the error messages are supposed to be clearer and more informative starting with Angular 4.

### Angular, React and Vue under the hood

Do you want to check the source code yourself? Do you want to see how things feel?
You’ll probably want to check out the Github repositories first: React ([github.com/facebook/react](https://github.com/facebook/react)), Angular ([github.com/angular/angular](https://github.com/angular/angular)), and Vue ([github.com/vuejs/vue](https://github.com/vuejs/vue))

How does the syntax look? ValueCoders [compares the syntax for Angular, React and Vue](http://www.valuecoders.com/blog/technology-and-apps/vue-js-comparison-angular-react/).

It is also good to see things in production — in conjunction with the underlying source code. [TodoMVC](http://todomvc.com/) lists dozens of the same Todo app, written with different Javascript frameworks — you can compare the [Angular](http://todomvc.com/examples/angularjs), [React](http://todomvc.com/examples/react/#/) and [Vue](http://todomvc.com/examples/vue/) solutions. [RealWorld](https://realworld.io/#) creates a real-world-application (a Medium-clone), and they have solutions for [Angular](https://github.com/gothinkster/angular-realworld-example-app) (4+) and [React](https://github.com/gothinkster/react-redux-realworld-example-app) (with Redux) ready. [Vue](https://github.com/mchandleraz/realworld-vue) is a work-in-progress.

There are also some real-world apps you could have a look at. Here are solutions for React:

- [Do](https://github.com/1ven/do) (a nice real-world notes management application built with **React & Redux**)
- [sound-redux](https://github.com/andrewngu/sound-redux) (a Soundcloud client built with React & Redux)
- [Brainfock](https://github.com/Brainfock/Brainfock) (a project & team management solution built with React)
- [react-hn](https://github.com/insin/react-hn) & [react-news](https://github.com/echenley/react-news) (Hacker news clones)
- [react-native-whatsapp-ui](https://github.com/himanshuchauhan/react-native-whatsapp-ui) + a [tutorial](https://www.codementor.io/codementorteam/build-a-whatsapp-messenger-clone-in-react-part-1-4l2o0waav) (Whatsapp clone with react-native)
- [phoenix-trello](https://github.com/bigardone/phoenix-trello/blob/master/README.md) (Trello clone)
- [slack-clone](https://github.com/avrj/slack-clone) + [another tutorial](https://medium.com/@benhansen/lets-build-a-slack-clone-with-elixir-phoenix-and-react-part-1-project-setup-3252ae780a1) (Slack clones)

There are some apps for Angular:

- [angular2-hn](https://github.com/housseindjirdeh/angular2-hn) & [hn-ng2](https://github.com/hswolff/hn-ng2) (Hacker News clones + [a nice tutorial about creating another one by Ashwin Sureshkumar)
- Redux-and-angular-2](https://medium.com/@Sureshkumar_Ash/angular-2-hackernews-clone-dynamic-components-routing-params-and-refactor-340773d82e6f) (a Twitter clone)

There are also solutions for Vue:

- [vue-hackernews-2.0](https://github.com/vuejs/vue-hackernews-2.0) & [Loopa news](https://github.com/Angarsk8/loopa-news) (Hacker News clones)
- [vue-soundcloud](https://github.com/mul14/vue-soundcloud) (a Soundcloud demo)

## Conclusion

### Decide on a framework now

React, Angular and Vue are all pretty cool, and none of them stands clearly above the others. Trust your gut feeling. This [last bit of entertaining cynicism](https://wildermuth.com/2017/02/12/Why-I-Moved-to-Vue-js-from-Angular-2#comment-3153455874) might help your decision:

> The dirty little secret is that most “modern JavaScript development” is nothing to do with actually building websites — it’s building packages that can be used by people who build libraries that can be used by people who build frameworks that people who write tutorials and teach courses can teach.I’m not sure anyone is actually building anything for actual users to interact with.

This is an exaggeration, of course, but there is probably a grain of truth to it. Yes, there is a lot of buzzing in the Javascript ecosystem. You’ll probably find a lot of other attractive alternatives during your search — try not to be blinded by the newest, shiniest framework.

### What should I choose?

If you work at Google: **Angular**

If you love TypeScript: **Angular ([or React](https://medium.com/@jrwebdev/id-argue-that-if-you-love-typescript-then-react-may-be-a-better-choice-ceec950ee543))**

If you love object-orientated-programming (OOP): **Angular**

If you need guidance, structure and a helping hand: **Angular**

If you work at Facebook: **React**

If you like flexibility: **React**

If you love big ecosystems: **React**

If you like choosing among dozens of packages: **React**

If you love JS & the “everything-is-Javascript-approach”: **React**

If you like really clean code: **Vue**

If you want the easiest learning curve: **Vue**

If you want the most lightweight framework: **Vue**

If you want separation of concerns in one file: **Vue**

If you are working alone or have a small team: **Vue (or React)**

If your app tends to get really large: **Angular (or React)**

If you want to build an app with react-native: **React**

If you want to have a lot of developers in the pool: **Angular or React**

If you work with designers and need clean HTML files: **Angular or Vue**

If you like Vue but are afraid of the limited ecosystem: **React**

If you can’t decide, first learn **React**, then **Vue**, then **Angular**.

**So, have you made your decision?**

![Yeeesss, you did it!](https://cdn-images-1.medium.com/max/800/1*Eq7k6tq-LbMpCJKNN5SZ3Q.png)

Well done! Read about how to **start developing in either Angular, React or Vue** (coming soon, follow me [on Twitter](http://www.twitter.com/jensneuhaus/) for updates).

### More resources

- [React JS, Angular & Vue JS — Quickstart & Comparison](https://www.udemy.com/angular-reactjs-vuejs-quickstart-comparison/) (an 8-hour long introduction and comparison of the three frameworks)
- [Angular vs. React (vs. Vue) — the DEAL breaker](https://hackernoon.com/angular-vs-react-the-deal-breaker-7d76c04496bc) (a short but excellent comparison by [Dominik T](https://medium.com/@dominik.t))
- [Angular 2 vs. React — the ultimate dance off](https://medium.com/javascript-scene/angular-2-vs-react-the-ultimate-dance-off-60e7dfbc379c) (a nice comparison by [Eric Elliott](https://medium.com/@_ericelliott))
- [React vs. Angular vs. Ember vs. Vue.js](https://medium.com/@gsari/react-vs-angular-vs-ember-vs-vue-js-e186c0afc1be) (a comparison of the three frameworks in note form by [Gökhan Sari](https://medium.com/@gsari))
- [React vs. Angular](https://www.sitepoint.com/react-vs-angular/) (a clear comparison of the two frameworks)
- [Can Vue fight for the Throne with React?](https://rubygarage.org/blog/vuejs-vs-react-battle) (a nice comparison with a lot of code examples)
- [10 reasons, why I moved from Angular to React](https://www.robinwieruch.de/reasons-why-i-moved-from-angular-to-react/) (another nice comparison by Robin Wieruch)
- [All JavaScript frameworks are terrible](https://medium.com/@mattburgess/all-javascript-frameworks-are-terrible-e68d8865183e) (a great rant about all major frameworks by [Matt Burgess](https://medium.com/@mattburgess))

**Thanks for your interest. Did I forget something important? Do you have a different opinion? I’m always glad to get feedback.**

**Follow me on Twitter for updates & more: [@jensneuhaus](http://www.twitter.com/jensneuhaus/) — **🙌


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
