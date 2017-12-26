> * 原文地址：[A Look Back at the State of JavaScript in 2017](https://medium.freecodecamp.org/a-look-back-at-the-state-of-javascript-in-2017-a5b7f562e977)
> * 原文作者：[Sacha Greif](https://medium.freecodecamp.org/@sachagreif?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-look-back-at-the-state-of-javascript-in-2017.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-look-back-at-the-state-of-javascript-in-2017.md)
> * 译者：
> * 校对者：

# A Look Back at the State of JavaScript in 2017

## In advance of the 2017 State of JS survey results, our panel of experts looks back on the past year

![](https://cdn-images-1.medium.com/max/1600/1*k7XARFeR0RqgZhY1p5w8uA.png)

One of the highlights of last year’s [State of JavaScript survey results](http://stateofjs.com/2016/introduction/) was the great panel of experts we assembled to analyze the results.

This year, we took a slightly different approach and decided to let the data speak for itself.

But I still wanted to know what our previous panelists (along with two new special guests) had been up to for the past 12 months, so I got in touch to ask them a few questions about their year in JavaScript.

### Meet the Panelists

![](https://cdn-images-1.medium.com/max/1000/1*Y54NpBPSXUyPr0p84xSVqg.jpeg)

* [Michael Shilman](https://medium.com/@shilman): [Testing](http://2016.stateofjs.com/2016/testing/)
* [Jennifer Wong](http://mochimachine.org): [Build Tools](http://2016.stateofjs.com/2016/buildtools/)
* [Tom Coleman](https://twitter.com/tmeasday): [State Management](http://2016.stateofjs.com/2016/statemanagement/)
* [Michael Rambeau](https://michaelrambeau.com/): [Full-Stack Frameworks](http://2016.stateofjs.com/2016/fullstack/)
* Extra Special Guest Panelist #1: [Wes Bos](http://wesbos.com/)
* Extra Special Guest Panelist #2: [Raphaël Benitte](https://twitter.com/benitteraphael) (creator of [Nivo](http://nivo.rocks/#/))

* * *

### Looking back at what you wrote last year, what are your thoughts on how that specific domain has evolved since?

#### Michael Shilman

Among the survey choices from last year, Jest has exploded and has surpassed Jasmine in [NPM downloads](https://npm-stat.com/charts.html?package=jest&package=jasmine&package=mocha&from=2016-11-10&to=2017-11-10).

Jest supports snapshot testing, I’ve seen lots of people using snapshotting as a cheaper alternative to unit tests for basic input/output behavior. This is especially popular in the UI space, with [Storyshots](https://github.com/storybooks/storybook/tree/master/addons/storyshots), as well a whole ecosystem of related tools such as [Loki](https://loki.js.org/), [Percy](https://percy.io/), [Screener](https://screener.io/), and [Chromatic](https://blog.hichroma.com/introducing-chromatic-ui-testing-for-react-c5cc01a79aaa).

#### Jennifer Wong

Last year’s survey has definitely predicted some of the trends of 2017. With the continued popularity of all things shiny and new, it’s no wonder Webpack’s still going strong. Yarn wasn’t even part of the survey last year, but has been picking up steam since its first full release in September. I’m curious to see what happens as Yarn and npm fight it out.

[![](https://cdn-images-1.medium.com/max/800/1*3sLM8_CMXFf7pdtPWI1YYw.png)](https://yarnpkg.com/)

Yarn

#### Tom Coleman

I’m not sure a real competitor to Redux has emerged, but perhaps in the community there has been a movement to what the creator Dan Abramov has always said: “not every app needs Redux, and in many cases it brings more complexity than it solves”.

With the increasing usage of server data management tools, especially for GraphQL data (see Apollo and Relay Modern), the need for complex client-side data tools has probably lessened somewhat. It’ll be interesting to see how the movements of those tools towards supporting local data also plays out.

* * *

### What cool new JavaScript tools/libraries/frameworks/etc. have you used in 2017?

#### Michael Shilman

My biggest testing discovery of 2017 was [Cypress](https://www.cypress.io/) as a very convenient OSS/commercial option for end-to-end testing, though I find it to be still rough around the edges.

Also, I’m maintaining [Storybook](https://storybook.js.org/), which is the most popular UI development tool for React, React Native, and Vue.

#### Jennifer Wong

We’re in the process of transitioning much of our frontend code at work to React, Redux, Webpack, and Yarn. It’s been an interesting and complicated transition, but many hands have made lighter work. This was in part prompted by the creation of a shared design system and component library.

#### Tom Coleman

[Prettier](https://github.com/prettier/prettier)! I can’t write code anymore I am so reliant on this tool. I’ve used [Jest](https://facebook.github.io/jest/) a lot more and have been really happy with it. I’ve really gotten into [Storybook](https://storybook.js.org/) and have made more and more use of it (and started helping maintain it!)

[![](https://cdn-images-1.medium.com/max/800/1*mjiXB1CfVNcS5QFJKlvDXw.png)](https://prettier.io/)

Prettier

Otherwise I’ve been heads down developing [Chromatic](https://blog.hichroma.com/introducing-chromatic-ui-testing-for-react-c5cc01a79aaa) a visual regression testing tool for Storybook. Really exciting to see some companies start finally getting their front end tested properly (ourselves included!)

#### Michael Rambeau

The favorite tool I found in 2017 was [Prettier](https://github.com/prettier/prettier). It makes me save a lot of time when I write code, since I don’t worry about “styling” my code anymore.

I don’t care about tabs or semi-columns anymore… Just Ctrl S in the IDE and everything is well formatted! Moreover, it reduces friction with other teams members when working on the same code base.

#### Wes Bos

All kinds of stuff! [date-fns](https://date-fns.org/) has replaced my [moment.js](https://momentjs.com/) usage. [Next.js](https://github.com/zeit/next.js/) has been big for me for building server rendered React apps. Been also learning Apollo for working with GraphQL.

#### Raphaël Benitte

Working both on several open-source projects and at work, it’s really important to be able to improve automation. Using Prettier, ESLint, Jest, [Validate-commit-msg](https://github.com/willsoto/validate-commit) with [Lint-staged](https://github.com/okonet/lint-staged) really helped in that.

I also built [Nivo](http://nivo.rocks/#/), a data visualization library for React.

[![](https://cdn-images-1.medium.com/freeze/max/30/1*Dwl7zseAHT2n6W63COQiUA.png?q=20)](http://nivo.rocks/#/)

[![](https://cdn-images-1.medium.com/max/800/1*Dwl7zseAHT2n6W63COQiUA.png)](http://nivo.rocks/#/)

Finally, with the rise of Async/Await and its now native support in Node.js I have also tried [Koa](http://koajs.com/). While its ecosystem is narrower than Express, I found it easy to get started with, and if you’re familiar with Express you won’t be lost.

* * *

### If someone wanted to learn JavaScript from scratch today, which 3 technologies would you recommend they focus on?

#### Michael Shilman

* React for UI.
* Webpack for build.
* Apollo for networking.

#### Jennifer Wong

Any framework, any build tool, and Node. Many of the concepts translate between frameworks and build tools, so hopefully learning one well can help map to others. If I had to choose one of each, perhaps React and Webpack because they’re trending — and trending technologies present well to people in the industry.

#### Tom Coleman

Certainly React, although the other frontends are interesting, the mindshare of React is getting pretty huge these days. A must have.

GraphQL, I think most experienced front-end devs recognize that the problems it solves are pretty universal, and it’s a pleasure to work with.

[![](https://cdn-images-1.medium.com/max/800/1*slDxUJmZvHd-wV4GsAJmAw.png)](http://graphql.org/)

GraphQL

Storybook, I think building from components their states up is the future of app development, and Storybook is the leading tool to do this with.

#### Michael Rambeau

* React, as the front-end layer
* Express, as the back-end server
* Jest, as the testing solution for both front-end and back-end code.

#### Wes Bos

If you are just learning, you need to have small wins to keep you excited about the language. So, I’d say along with the fundamentals, learn the DOM API, Learn Async + Await, and learn a new visual API like web animations.

#### Raphaël Benitte

* If you’re really new to JavaScript, start with the basics — and ES6, which is now part of the basics.
* Obviously, React for building UIs
* [GraphQL](http://graphql.org/), which is becoming mature and is now used by big companies Facebook, GitHub, Twitter and [many more](http://graphql.org/users/)…

* * *

### What’s your biggest JavaScript pain point today?

#### Michael Shilman

Hoping a best practice and library-of-choice emerges for CSS-in-JS. While there are lots of good choices, it still feels fragmented, and a lot of the world is still doing CSS-in-CSS, so lots of confusion unless that’s your focus.

#### Jennifer Wong

The constant changes. By the time I learn one new technology, we’re onto the next. Also, stop stealing my CSS, JavaScript!

#### Tom Coleman

Webpack. Extraordinarily powerful tool that lies way too far over on the “configuration over convention” spectrum.

It’s very hard to avoid having to learn its intricacies to work on JS apps, but often times they are details you shouldn’t really need to care about. I’m still hoping that Meteor can regain the throne as the best way to build a modern JS app.

#### Michael Rambeau

The lack of standard, the fact that you have a lot of things to consider when you pick your stack before starting a new project. But things are improving!

#### Wes Bos

`checking && checking.for && checking.for.nested && checking.for.nested.properties`. I know there are utility functions out there to do this, but it looks like we might get this in the language soon.

#### Raphaël Benitte

There are too many tools… It’s difficult to pick the right one, and we must be really careful about trends as they can move really fast in the JS ecosystem.

* * *

### What are you most looking forward to in 2018 in the JavaScript ecosystem?

#### Michael Shilman

Wishlist (no idea whether any of these will happen in 2018):

* GraphQL reaches Meteor’s level of convenience for data sync.
* Universal (web/mobile) stabilizes and takes off for React Native.
* Cypress or a competitor emerges for end-to-end testing.

#### Jennifer Wong

Stabilization. I’m crossing my fingers that the JavaScript “stack” and community will begin to settle down a bit, and we’ll get into a groove that causes less churn.

#### Tom Coleman

The end of Babel! I love Babel but with Node 8 I pretty much don’t need babel any more. It’s great to be working so close to the interpreter again.

Obviously the ES standards will keep moving forward but with modules and async/await a lot of the more frustrating corners of JS have been ironed out and many projects will probably be fine with the JS version shipped with node and **all** modern browsers pretty soon!

#### Michael Rambeau

I’m curious to see how GraphQL will grow. Will it become the new standard when releasing an API?

#### Wes Bos

Now that Node stable and all the browsers have Async+Await, I’m looking forward to native promises becoming common place in frameworks, utility libraries and the code that you write day to day.

#### Raphaël Benitte

Most languages have a dedicated/preferred build tool (eg. Maven for Java). Although we do have a lot of options when it comes to JavaScript, those solutions are too often dedicated to the front-end. I’d like to see npm (or Yarn) add support for basic features such as documentation, autocompletion, script dependencies, etc. Otherwise I’ll probably keep using GNU Make.

And this one is quite controversial, but we’ve seen that people are really interested in solutions like [TypeScript](https://www.typescriptlang.org/) (or [Flow](https://flow.org/)). Node.js and browsers have made a clear effort to move faster, but if you want static typing you’ll still have to add another transpilation phase for it. So how about native statically typed Javascript? You can find a discussion on the subject [here](https://esdiscuss.org/topic/es8-proposal-optional-static-typing).

* * *

### Conclusion

It seems like our panel agrees on at least a few things: React is a safe bet, Prettier is a great tool, and yes, the JavaScript ecosystem is still too complex…

Which is exactly what we were trying to address in the first place when we did that survey!

We’ll be launching our results site very soon. One week from now in fact, on December 12.

We’ll hold a [launch livestream + Q&A](https://medium.com/@sachagreif/announcing-the-stateofjs-2017-launch-livestream-14e4aeeeec3a) so you can ask us all the questions you want - or just hang out! And who knows, we might even have special guests drop in… ;)

If you want to know when the results are live and get a notification for the hangout, you can [leave us your email](http://stateofjs.com/) and we’ll let you know.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
