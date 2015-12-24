> * 原文链接: [Must See JavaScript Dev Tools That Put Other Dev Tools to Shame](https://medium.com/javascript-scene/must-see-javascript-dev-tools-that-put-other-dev-tools-to-shame-aca6d3e3d925#.wm0lbpiko)
* 原文作者 : [Eric Elliott](https://medium.com/@_ericelliott)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 :
* 状态 : 待定


>"JavaScript sucks for large apps because it can't even identify the type of a variable, and it sucks for refactoring." ~ lots of very confused people

When I got into JavaScript, there was only one browser that mattered: NetScape. It dominated completely until Microsoft started shipping IE with the OS. In those days, the argument that JavaScript's developer tools were weak was actually true.

But it hasn't been true for a really long time, and today, JavaScript has the best dev tool ecosystem I've ever seen for any language.

Note that I didn't say "the best IDE". If you're looking for a central IDE that unifies your entire dev tool experience, check out Microsoft's Visual Studio for C#. Pair it with Unity for a good time. I don't use it myself, but I have heard from people I trust that it's pretty solid.

I have used C++ and the Unreal Game Engine. The first time I tried that, I realized that the web platform dev tools still had a long way to go.

But we've come a long way since then, and the tools we use now in JS make fancy IDE autocomplete look like a baby chew toy. In particular, JavaScript's runtime tooling has no match that I'm aware of in any other language.

>"JavaScript has the best dev tool ecosystem I've ever seen for any language."


#### What Are Dev Tools?

Developer tools are a collection of software that makes life easier for developers. Traditionally, we've thought of them primarily as the IDE, linter, compiler, debugger, and profiler.

But JavaScript is a dynamic language, and along with its dynamic nature comes a need for more runtime developer tooling. JavaScript has this in spades.

For the purposes of this article, I'm going to include runtime tooling, and even a couple libraries that enhance runtime developer visibility and debugging. The line between dev tools and libraries is starting to blur. With mind-blowing results.


#### TL;DR quick list:

*   [Atom](https://atom.io/) & [atom-ternjs](https://atom.io/packages/atom-ternjs)
*   [Chrome Dev Tools](https://developer.chrome.com/devtools)
*   [PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/)
*   [FireFox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/)
*   [BrowserSync](http://www.browsersync.io/)
*   [TraceGL](https://github.com/traceglMPL/tracegl)
*   [ironNode](http://s-a.github.io/iron-node/)
*   [ESLint](http://eslint.org/)
*   [rtype](https://github.com/ericelliott/rtype) (the spec) & [rfx](https://github.com/ericelliott/rfx) (the library) **Warning:** These are unfinished developer previews.
*   [Babel](http://babeljs.io)
*   [Greenkeeper.io](http://greenkeeper.io/) & [updtr](https://github.com/peerigon/updtr)
*   [React](https://facebook.github.io/react/)
*   [Webpack](https://webpack.github.io/) + [Hot module replacement](https://github.com/webpack/docs/wiki/list-of-plugins)
*   [Redux](http://redux.js.org/) + [Redux DevTools](https://github.com/gaearon/redux-devtools)


#### About the Tools

Your dev life is going to center around two things: The **editor**, and your **runtime environment** (e.g., the browsers, platforms, and devices you're coding for).

**The Editor:** I started my dev career using big, massively integrated IDEs like Borland IDE, Microsoft Visual Studio, Eclipse, and WebStorm. In my opinion, the best of these are **WebStorm** and **Visual Studio**.

But I got tired of the bloat that comes with many of those IDEs, so for the last several years, I've done most of my coding in more stripped-down editors. Primarily Sublime Text, but I recently switched to [**Atom**<sup>[1]</sup>](https://atom.io/). You'll also want [atom-ternjs<sup>[2]</sup>](https://atom.io/packages/atom-ternjs) to enable JavaScript intellisense features. You may also want to look at Visual Studio Code. A slimmer Visual Studio for people who like minimal pluggable editors like Sublime Text and Atom.

I also use vim for quickie edits from the terminal.

**Debuggers:** I missed the integrated debugger when I started programming for the web, but the Chrome and FireFox teams have elevated runtime debugging to a whole new level. Everybody today seems to know about Chrome's DevTools and how to step through code, but did you know it has great features for advanced performance & memory profiling and auditing? Have you used the flame charts or the dominators view?

Speaking of performance auditing, you also need to get to know [PageSpeed Insights<sup>[3]</sup>](https://developers.google.com/speed/pagespeed/insights/):

<iframe width="854" height="480" src="https://www.youtube.com/embed/bDUDuQy3R7Y?list=PLOU2XLYxmsILKwwASNS0xgfcmakbK_8JZ" frameborder="0" allowfullscreen=""></iframe>

On top of all that goodness, there are also some cool features for live editing CSS, & very cool features to help you edit animations. Get to know your Chrome DevTools. You won't regret it.

<iframe width="700" height="393" src="https://www.youtube.com/embed/hJdqtBeAUNI" frameborder="0" allowfullscreen=""></iframe>

Not to be outdone, FireFox has a dedicated browser just for developers. [FireFox Developer Edition<sup>[4]</sup>](https://www.mozilla.org/en-US/firefox/developer/):

<iframe width="700" height="393" src="https://www.youtube.com/embed/g9k4IrtaPMs?list=PLo3w8EB99pqLRJBWRCoyGTIrkctoUgB9W" frameborder="0" allowfullscreen=""></iframe>

**BrowserSync:** [BrowserSync<sup>[5]</sup>](http://www.browsersync.io/) is a great way to test your responsive layouts by controlling several browsers at once. In other words, you can use the BrowserSync CLI to open your app on your desktop, tablet, and phone.

You can tell it to watch files and automatically reload the synchronized browsers on file changes. Actions such as scrolling, clicks, and form interactions will also be synchronized across devices so you can easily test your app workflows and be sure that everything appears correctly everywhere.

<iframe width="640" height="480" src="https://www.youtube.com/embed/heNWfzc7ufQ" frameborder="0" allowfullscreen=""></iframe>

**TraceGL:** [TraceGL<sup>[6]</sup>](https://github.com/traceglMPL/tracegl) is a runtime debugging tool that lets you observe all of the function calls in your software as they're happening in realtime, rather than stepping through your code manually, one step at a time. It's super powerful and extremely useful.

<iframe width="700" height="393" src="https://www.youtube.com/embed/TW6uMJtbVrk" frameborder="0" allowfullscreen=""></iframe>

**ironNode:** [ironNode<sup>[7]</sup>](http://s-a.github.io/iron-node/) is a desktop debugging app for Node built on Electron, the same cross-platform desktop runtime that powers the Atom editor. Like node-inspector, it allows you to trace through your code using features similar to Chrome's DevTools.

<iframe width="640" height="480" src="https://www.youtube.com/embed/pxq6zdfJeNI" frameborder="0" allowfullscreen=""></iframe>

To use it with Babel, I use the following _`debug.js`_ script:

<pre>require('babel-core/register');  
require('./index');
</pre>

To launch the debugger:

<pre>iron-node source/debug.js
</pre>

Works like a charm.

**Linting:** [ESLint<sup>[8]</sup>](http://eslint.org/) is by far the best linter I've used for any language. I like it better than JSHint, and much better than JSLint. If you're not sure what to use, stop worrying and use ESLint. Why is it so cool?

*   Very configurable — every option can be enabled and disabled. They can even take parameters.
*   Create your own rules. Do you have your own style conventions you want to enforce on your teams? There's probably a rule for that, but if there isn't, you can write your own.
*   Supports plugins — Using some special syntax? ES6+ or experimental features for future versions of JavaScript? No problem. React's JSX syntax for compact UI components? No problem. Your own experimental JavaScript syntax extensions? No problem.

**Type support:** JavaScript has loose types, which means that you don't have to annotate all your types. After annotating everything for years in languages like C++ and Java, I immediately felt a cognitive load weight lifted off my shoulders when I started using JavaScript. Type annotation creates noise in your source files. Functions are often easier to understand without them.

Contrary to common belief, **JavaScript does have types**, but instead of typing variables, JavaScript types **values**. Variable types can be identified and predicted using type inference (that's what that Atom TernJS plugin is for).

That said, type annotation and signature declarations do serve a purpose: They make great documentation for developers. They can also enable some important perf optimizations for JavaScript engine and compiler creators. As a JavaScript programmer building apps, you shouldn't worry about the perf gains. Leave that to the engine and spec teams.

But the thing I like best about type annotations is runtime type reflection, and the runtime developer tools that can be enabled using it. For an idea of what those tools could be like, read ["The Future of Programming: WebAssembly and Life After JavaScript"<sup>[9]</sup>](http://www.sitepoint.com/future-programming-webassembly-life-after-javascript/).

For years, I used JSDoc for annotation, documentation, and type inferrence. But I got sick of its awkward limitations. It feels like it was written for a different language and squeezed into JavaScript later (which is true).

I was also really impressed by TypeScript's structural type solution.

TypeScript has issues though:

*   It's not standard JavaScript — opting into TypeScript means opting into the TypeScript compiler and tool ecosystem — often opting out of solutions made to work with the JavaScript standard.
*   It's heavily class-based. An awkward fit for JavaScript's prototypes and object composition.
*   It doesn't provide a runtime solution… yet — they're working on it using experimental features of the new JavaScript **Reflect** API, but then you're depending on very experimental spec features that may or may not land in the spec.

For those reasons, I started the (currently unfinished) [rtype<sup>[10]</sup>](https://github.com/ericelliott/rtype) and [rfx<sup>[11]</sup>](https://github.com/ericelliott/rfx) projects. **rtype** is a specification for function and interface signatures designed to be self documenting for readers who already know JavaScript. **rfx** is a library built to wrap your live JS functions and objects in order to add type metadata. It optionally adds automated runtime type checking, as well. I'm actively collaborating with people to improve both rtype and rfx. Your contributions are welcome.

Keep in mind that they're very young, and there will almost certainly be breaking changes in the short-term.

**Babel:** [Babel<sup>[12]</sup>](http://babeljs.io/) is a compiler that lets you use not-yet-supported features of ES6+, JSX and more in your JavaScript code today. It works by transpiling your code into equivalent ES5\. Once you start using it, I predict you'll get addicted to the new syntax quickly, because ES6 offers some truly valuable syntax additions to the language, such as destructuring assignment, default parameter values, rest parameters and spread, concise object literals, and so on… Check out ["How to Use ES6 for Universal JavaScript Apps"<sup>[13]</sup>](https://medium.com/javascript-scene/how-to-use-es6-for-isomorphic-javascript-apps-2a9c3abe5ea2) for details.

**Greenkeeper.io:** [Greenkeeper<sup>[14]</sup>](http://greenkeeper.io/) monitors your project dependencies and automatically opens a pull request on your project. Make sure you've hooked up a CI solution to automatically test pull requests. If the tests pass, just click "merge", and you're done. If they fail, you can dig in manually and figure out what needs fixing, or just close the PR.

If you prefer a hands-on approach, check out [**updtr**<sup>[15]</sup>](https://github.com/peerigon/updtr). I recommend that you run updtr on your repo before you enable Greenkeeper for the first time.

**Webpack:** [Webpack<sup>[16]</sup>](https://webpack.github.io/) bundles modules and dependencies into static assets for browsers. It enables a lot of really interesting features such as hot module replacement, which lets your live code in the browser update automatically as you change files without a page reload. Hot module replacement is the first step towards a truly continuous realtime developer feedback loop. If you're not using it, you should be. To get started fast, check out the webpack config in the [**Universal React Boilerplate**<sup>[17]</sup>](https://github.com/cloverfield-tools/universal-react-boilerplate) project.

**React:** This one is a bit of a stretch, because [React<sup>[18]</sup>](https://facebook.github.io/react/) isn't strictly a developer tool. It has more in common with a UI library. Think of React as the modern jQuery: A simple way to address the DOM. But React is more than that. It is really a UI abstraction layer that abstracts you away from the DOM. In fact, you can target a lot more than the DOM with React, including native mobile UI APIs (iOS & Android), WebGL, canvas, and so on. Netflix uses it to target their own Gibbon rendering API for TV devices.

So why am I listing it among developer tools? Because React's abstraction layer is used by some great developer tools to enable the amazing developer tools of the future, featuring hot loading (updates to your live running code without page refreshes), time travel, and more… read on!

**Redux + Redux DevTools:** Redux is an application state management library inspired by the React/Flux architecture and the concept of pure functions from functional programming. Another library in a list of developer tools? Yep. Here's why:

<iframe width="700" height="393" src="https://www.youtube.com/embed/xsSnOQynTHs" frameborder="0" allowfullscreen=""></iframe>

Redux and Redux DevTools enable some truly next-level debugging interactions against your live running code. It allows you to get really great, understandable insights about the actions that have been performed in your app:

![](https://cdn-images-1.medium.com/max/1600/1*lAp8ZAk5uNFTuxjhx4GTdw.gif)

It even allows you to shuttle back and forth in time using the time travel debugging features. Here's what it looks like with the slider view:

![](https://cdn-images-1.medium.com/max/1600/1*BTRxlHu8WuCF4Iep4R44lA.gif)


#### Conclusion

JavaScript has the richest array of developer tools I've ever seen for any language. As you can see, it's more of a patchwork than a cohesive IDE environment, but we're in a cambrian explosion period of JavaScript development. In the future, we may see more cohesive integrated developer tool offerings. In the meantime, we're getting a peek at the future of programming.

I predict we'll see more live programming features come online as the JavaScript moves deeper into unified application state and immutability (which are the features that enable time travel debugging in Redux DevTools).

I also believe that the line between the application we're building, and the development environments we use to build it will blur over time. For example, the Unreal game engine integrates blueprint editing into the game engine itself, allowing developers and designers to build complex behaviors from inside the running game. I think over time, we'll start to see those features in web and native mobile applications as well.

JavaScript's linting, runtime monitoring and time travel debugging features have no equal that I'm aware of in any language, but there is more we can do to bring us into parity with tools such as the Blueprint system from Unreal Engine 4\. I can't wait to see what's coming next.

<iframe width="700" height="393" src="https://www.youtube.com/embed/9hwhH7upYFE" frameborder="0" allowfullscreen=""></iframe>

### [Learn JavaScript with Eric Elliott](https://ericelliottjs.com/)

*   Online courses + regular webcasts
*   Software testing
*   The Two Pillars of JavaScript (prototypal OO + functional programming)
*   Universal JavaScript
*   Node
*   React

**_Eric Elliott_** _is the author of_ [_"Programming JavaScript Applications"_](http://pjabook.com) _(O'Reilly), and_ [_"Learn JavaScript Universal App Development with Node, ES6, & React"_](https://leanpub.com/learn-javascript-react-nodejs-es6/)_. He has contributed to software experiences for_ **_Adobe Systems_**_,_ **_Zumba Fitness_**_,_ **_The Wall Street Journal_**_,_ **_ESPN_**_,_ **_BBC_**_, and top recording artists including_ **_Usher_**_,_ **_Frank Ocean_**_,_ **_Metallica_**_, and many more._

_He spends most of his time in the San Francisco Bay Area with the most beautiful woman in the world._
