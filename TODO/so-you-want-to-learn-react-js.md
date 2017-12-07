> * 原文地址：[So you want to learn React.js?](https://edgecoders.com/so-you-want-to-learn-react-js-a78801d3cd4d)
> * 原文作者：[Samer Buna](https://edgecoders.com/@samerbuna?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-learn-react-js.md](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-learn-react-js.md)
> * 译者：
> * 校对者：

# So you want to learn React.js?

![](https://cdn-images-1.medium.com/max/2000/1*Wz7GxmF1-xFe5zvNTHETxQ.png)

First, make peace with the fact that you need to learn more than just React to work with React. This is a good thing, React is a library that _does one thing really well_, but it’s not the answer to everything.

However, identify whether what you’re currently learning is React or not, mainly so that you don’t get confused about your effort to learn React itself. A programmer who is comfortable with HTML and one other programming language will be able to pick 100% of React in 1 day or less. A beginner programmer should be good enough with React in a about a week. This is not counting the tools and other libraries that complete React like for example, Redux or Relay.

There is an important question about the order with which you need to learn things. This order would vary based on what skills you have. It goes without saying that you need a solid understanding of JavaScript itself first, and of course, HTML as well. I like to be specific about this here, so if you don’t know how to map or reduce an array, or if you don’t understand the concept of closures and [callbacks](https://edgecoders.com/asynchronous-programming-as-seen-at-starbucks-fc242cf16aa#.wb5c6opp7), or if seeing “this” in JavaScript code confuses you, you’re not ready for React and you still have a lot to do in JavaScript land.

Refreshing your knowledge on JavaScript first would not hurt, specially because you need to learn ES2015, not because React depends on it (it does not), but because it’s a much better language, and most of the examples, courses, and tutorials you’ll find use the modern JavaScript syntax. Specifically, you need to learn the following:

* The new features of the object literal and template strings
* Block scopes and let/const vs var
* Arrow functions
* Destructuring and default/rest/spread.
* Classes and inheritance (used slightly in defining component, but to be avoided otherwise)
* Class field syntax to define methods with arrow functions
* Promise objects and and how to use them with async/await.
* Imports and exports of modules (most important of all)

You don’t have to start with ES2015, but you do need to eventually learn it (and not because you’re learning React).

So other than ES2015 stuff, you need to learn the following to be a productive React developer.

* The APIs of [React](https://facebook.github.io/react/docs/react-api.html), [ReactDOM](https://facebook.github.io/react/docs/react-dom.html), [ReactDOMServer](https://facebook.github.io/react/docs/react-dom-server.html): These are not big APIs really, we’re talking about maybe 25 different things and you would rarely use them all. The [official React documentation](https://facebook.github.io/react/docs/hello-world.html) is actually a very good starting point (it has gotten a lot better recently), but if it still confuses you, watch an [online course](https://www.pluralsight.com/search?q=buna&categories=all), [read a book](https://www.syncfusion.com/resources/techportal/details/ebooks/Reactjs_Succinctly), or join [a focused workshop](https://jscomplete.com/). Your options are endless here, but be careful what you pick and make sure it has a focus on React itself and not its tools and ecosystem.

![](https://ws1.sinaimg.cn/large/006LnBnPgy1fm8n5p37jwj30lc0ozn3w.jpg)

* [node and npm](https://www.pluralsight.com/courses/nodejs-advanced): the reason you need to learn those (for React), is because there are a ton of tools that are hosted at [npmjs.org](http://npmjs.org/) that would make your life easy. Also, since Node allows you to execute JavaScript on your servers, you can re-use your front-end React code on the server (Isomorphic/Universal applications). Mostly, what you’ll find valuable with node and npm is working with module bundlers like webpack. This is much more important when you’re writing a big application, but you will need at least one tool to work with JSX (ignore the advice that JSX is optional.) Learn JSX and use it. The recommended tool is Babel.js
* React ecosystem libraries: Since React is just the UI language, you’ll need tools to complete the picture and go beyond even MVC. Don’t start here until you’re very comfortable with React itself. I’ll give you two things to focus on, just forget everything else you encounter and learn these two first once you’re done with React itself: react-router and redux.
* Right after getting comfortable with the raw concepts of React itself, build a [React Native](https://facebook.github.io/react-native/) app. You’ll only truly appreciate the beauty of React once you do that. Trust me.

![](https://ws1.sinaimg.cn/large/006LnBnPgy1fm8n5op3eqj30lf088t9l.jpg)

During your learning process, the best thing you can possibly do is build stuff with your own hands. don’t copy paste examples, don’t follow instructions blindly, but rather, mirror the instructions to build something else (ideally, something you care more about). Whatever you do, just do not build a [TODOs app](https://hackernoon.com/a-react-todos-example-explained-6df53cdebed1).

I find building simple games to demonstrate the ideas of React much better than starting with data-driven serious web applications. That’s why in my [**Getting started with React.js**](https://www.pluralsight.com/courses/react-js-getting-started) **course**, I focus on building a simple game. I’ve also build a [different game](http://jscomplete.com/react-examples/memory-grid-game/) in my [**React.js Succinctly**](https://www.syncfusion.com/resources/techportal/details/ebooks/Reactjs_Succinctly) book which you can read for free. Try to implement other similar games in a [JavaScript playground](https://jscomplete.com/repl) like that, it’s a good start, you don’t need a server, and you don’t need to manage a crazy state.

[**JavaScript REPL and Playground for React.js**
_Learn JavaScript and React.js with jsComplete interactive labs_jscomplete.com](https://jscomplete.com/repl)

Recently, I’ve created an interactive learning tool with audio instructions for jsComplete. The first lab I tested the tool with was [a React.js example](http://jscomplete.com/interactive-learning-demo/). If you take the lab, please make sure to leave me your feedback.

Good luck and have fun! If you ask nicely, I’ll be happy to review your first React application and give you some pointers.

_Thanks for reading. If you found this article helpful, please click the💚 below. Follow me for more articles on React.js and JavaScript._


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
