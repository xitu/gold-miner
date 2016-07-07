> * 原文链接 : [Your Timeline for Learning React](https://daveceddia.com/timeline-for-learning-react/)
* 原文作者 : [DAVE CEDDIA](https://daveceddia.com/timeline-for-learning-react/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [aleen42](http://aleen42.github.io/)
* 校对者:

为你定制的 React 学习路线

This is your timeline for learning React.

为了能稳固基础，我们一定要逐步地来学习。

Think of these steps as layers in a foundation.

倘若你正在建造一间房子，那么为了能快点完成，你是否会跳过建造过程中的部分步骤？如在具体建设前先铺设部分石头？或直接在一块裸露的土地上先建立起墙面？

If you were building a house, would you skip some steps to get it done faster? Maybe jump right to the concrete before laying some rocks down? Start building the walls on bare earth?

又假设是在堆砌一个结婚蛋糕：我们是否能因为上半部分装饰起来更有趣，而直接忽略了下班部分？

Or how about making a wedding cake: the top part looks the most fun to decorate, so why not start there! Just figure out the bottom part later.

不行吗？

No?

当然不行。你们肯定知道，这样做将只能带来失败的结果。

Of course not. You know those things would lead to failure.

因此，不要试想着通过接触 React，就能一次性学习好 ES6 + Webpack + Babel + React + Routing + AJAX。不然，带给你们的将只有失败打结果。

So why would you approach React by trying to learn ES6 + Webpack + Babel + React + Redux + Routing + AJAX _all at once_? Doesn’t that sound like setting yourself up for failure?

既然我把该文章称作是学习的路线，那么每一次都应该走好每一步。既不要尝试去跨越，也不要贪步。

So I’ve laid out a timeline. Take these one step at a time. Do not skip ahead. Do not learn 2 steps at the same time.

一步一脚印。若把其置身于每一天，也许也就一周的学习时间而已。

One foot in front of the other. Setting aside a bit of time each day, this is probably a few weeks of learning.

该路线，其制定的主要目的在于：使你在学习过程中避免头脑不堪重负。因此，脚踏实地地去学习 React 吧。

The theme of this post is: avoid getting overwhelemed. Slow and steady, uh, learns the React.

当然，你也可以为该学习过程[制定一个可打印的 PDF 文件](https://daveceddia.com/timeline-for-learning-react/#signup-modal)，以便在学习过程中能够查阅。

You can also [snag a printable PDF](https://daveceddia.com/timeline-for-learning-react/#signup-modal)<a></a> of this timeline and check it off as you go!

## 第零步：JavaScript


在此，我假设你已经了解过 JavaScript，或至少了解过 ES5。而如果你并不了解 JS，那么你就应该停下手中的工作，学习好该[基础部分](https://developer.mozilla.org/en-US/Learn/Getting_started_with_the_web/JavaScript_basics)后，*才可*迈步前行。

I assume you already know JavaScript, at least ES5\. If you don’t yet know JS, you should stop what you’re doing, learn the [basics](https://developer.mozilla.org/en-US/Learn/Getting_started_with_the_web/JavaScript_basics), and _only then_ continue onward.

但倘若，你早已熟知 ES6 所带来的新特性，那么请继续。众所周知，这是因为 React 的 API 接口在 ES5 和 ES6 两标准间存在着较大的差异性。两种“口味”的熟悉，对于你来说是非常有用的。当有异常发生的时候，你就可以通过两种标准之间的转换，寻找出大范围的有效答案。

If you already know ES6, go ahead and use it. Just so you know, React’s API has some differences between ES5 and ES6\. It’s useful to know both flavors – when something goes wrong, you’ll find a wider range of usable answers if you can mentally translate between both styles.

## 第半步：NPM

NPM 是 JavaScript 世界中，软件包第三方管理者中的王者。在这里的它，本身并没有太多的东西需要学习。在你安装好它后[（连同 Node.js）](https://nodejs.org)，你只需要懂得如何使用其安装软件包即可。（`npm install <package name>`）

NPM is the reigning package manager of the JavaScript world. There isn’t too much to learn here. After you [install it (with Node.js)](https://nodejs.org), all you really need to know is how to install packages (`npm install <package name>`).

## 第一步：React

学习一个新的编程技术，我们往往会从熟悉的 [Hello World](https://daveceddia.com/test-drive-react) 开始。首先，我们可以通过使用 React 官方教程所展示的原生 HTML 文件来实现，而该文件包含有一些 `script` 标签。其次，我们还可以通过使用像 React Heatpack 这样的工具来快速上手。

Start with [Hello World](https://daveceddia.com/test-drive-react). Use either a plain HTML file with some `script` tags ala the [official tutorial](https://facebook.github.io/react/docs/tutorial.html) or use a tool like React Heatpack to get you up and running quickly.

在这里，请不妨尝试一下该仅需[三分钟就能上手的 Hello World 教程](https://daveceddia.com/test-drive-react)。

Try out the [Hello World in 3 minutes](https://daveceddia.com/test-drive-react) tutorial!

## 第二步：构建后摒弃

这是一个棘手的中间过程，可往往会有大量的人忽略了该步。

This is the awkward middle step that a lot of people skip.

谨记请勿犯这样的错误。若对 React 的概念没有一个稳固的掌握而擅自前行，那么只会直接导致自己头脑的不堪重负。

Don’t make that mistake. Moving forward without having a firm grasp of React’s concepts will lead straight back to overwhelmsville.

当然，该步需要一定的斟酌：你该构建什么呢？是一个工作中的原型项目？还是一些能贴合于整个框架的 Facebook 克隆项目？

But this step isn’t very well-defined: what should you build? A prototype for work? Maybe a fancy Facebook clone, something meaty to really get used to the whole stack?

其实，我们应该构建的都不是这些东西。它们要不是包裹过甚，以致无甚可学；要不是过于庞大，以致成本过高。

Well, no, not those things. They’re either loaded with baggage or too large for a learning project.

尤其是所谓工作中的“原型项目”，更为糟糕。因为在你心目中，*你绝对会认为*这些项目并不会占有一席之地。况且，该类项目往往会长期停留在原型阶段，或变成线上软件。最终，你将无法摒弃或重写。

“Prototypes” for work are especially terrible, because _you absolutely know_ in your heart that a “prototype” will be nothing of the sort. It will live long beyond the prototype phase, morph into shipping software, and never be thrown away or rewritten.

此外，把原型项目当作学习的项目将会为你带来许多的烦恼。因为，对于你来说，你可能会就*未来的因素*考虑一切。当你*清楚*这不仅仅是一个原型的时候，你就会产生疑惑 —— 该不该进行测试？我应该保证架构能延伸扩展……我需要延后重构的工作吗？还是不进行测试呢？

Using a work “prototype” as a learning project is problematic because you’re likely to get all worked up about the _future_. Because you _know_ it’ll be more than just a prototype, you start to worry – shouldn’t it have tests? I should make sure the architecture will scale… Am I going to have to refactor this mess later? And shouldn’t it have tests?

这问题我希望能用我的一篇指引《[为 Augular 开发者所准备的 React](https://daveceddia.com/react-for-angular-developers)》去应对：一旦你完成了 “Hello World” 的基础课程，你将如何去学习 ”think in React” 的课程。

This specific problem is what I’m aiming to tackle with my [React for Angular Developers](https://daveceddia.com/react-for-angular-developers) guide: once you get past “Hello World,” how do you learn to “think in React?”

在这里，我有一些个人的提议：理想的项目介乎于 “Hello World” 和 ”All of Twitter“ 两项目之间。

I’ll give you some idea: the ideal projects are somewhere between “Hello World” and “All of Twitter.”

另外，尝试去构建一些列表中的项目（TODOs、beers、movies），并学会数据流（data flow）的工作原理。

Build some lists of things (TODOs, beers, movies). Learn how the data flow works.

当然，你也可以把一些已有的大型 UI 项目（Twitter、Reddit、Hacker News等）分割成一小块来构建 —— 把其瓜分成组件（components），并使用静态的数据去提供构建。

Take some existing large UIs (Twitter, Reddit, Hacker News, etc) and break off a small chunk to build – carve it up into components, build the pieces, and render it with static data.

总结来说，就是构建一些小型且可摒弃的应用程序项目。这些项目*必须是*可摒弃的，否则，你将深陷于一些并不重要的东西，如可维护性和代码结构等。

You get the idea: small, throwaway apps. They _must be throwaways_ otherwise you’ll get hung up on maintainability and architecture and other crap that just doesn’t matter yet.

如果你曾经[订阅于](https://daveceddia.com/timeline-for-learning-react/#signup-modal)我，那么当《[为 Angular 开发者准备的 React](https://daveceddia.com/react-for-angular-developers)》发布时，你将会第一时间收到通知。

I’ll let you know when [React for Angular Developers](https://daveceddia.com/react-for-angular-developers) is ready if you’re [on my subscriber list](https://daveceddia.com/timeline-for-learning-react/#signup-modal).

## 第三步：Webpack

构建工具是学习过程中的一个主要的绊脚石。搭建 Webpack 的环境是一件*繁杂的工作*，且完全不同于书写 UI 代码。这就是为什么 Webpack 放在了第三步，而不是第零步。

Build tools are a major stumbling block. Setting up Webpack feels like _grunt work_, and it’s a whole different mindset from writing UI code. This is why Webpack is down at Step 3, instead of Step 0.

在这里，作为对 Webpack 的简介，我推荐一篇名为《[Webpack —— 令人疑惑的地方](https://medium.com/@rajaraodv/webpack-the-confusing-parts-58712f8fcad9)》的文章。该文章还讲述了 Webpack 本身的思想方式。

I recommend [Webpack – The Confusing Parts](https://medium.com/@rajaraodv/webpack-the-confusing-parts-58712f8fcad9) as an introduction to Webpack and its way of thinking.

一旦你清楚 Webpack 所负责的工作（捆绑*各种的文件*，而不仅仅是 JS 文件） —— 以及其中的工作原理（用于各种文件类型的加载器），那么 Webpack 对于你来说将会是一个更为欣喜的部分。

Once you understand what it does (bundles _every kind of file_, not just JS) – and how it works (loaders for each file type), the Webpack part of your life will be much happier.

## 第四步：ES6

如今进入第四步，上述的所有将会作为下面的*铺设*。之前 ES6 所学到的部分将会使你写出更为利落简洁的代码 —— 以及效率高的代码。当回想起一开始那时候，它本不应该卡住在那 —— 但现在，你已然清楚知道为啥 ES6 能完美地融合在其中。

Now that you’re in Step 4, you have all those steps above as _context_. The bits of ES6 you learn now will help you write cleaner, better code – and faster. If you tried to memorize it all in the beginning, it wouldn’t have stuck – but now, you know how it all fits in.

在 ES6 中，你应该学习一些常用的部分：箭头函数（arrow functions）、let/const、类（classes）、析构（destructuring）和 `import`

Learn the parts you’ll use most: arrow functions, let/const, classes, destructuring, and `import`.

## 第五步：Routing

有些人会合并 React Router 和 Redux 的概念 —— 它们之间并没有任何的关系或依赖。因此，你可以（也理应）在深入 Redux 之前学习如何去使用 React Router。

Some people conflate React Router and Redux in their head – they’re not related or dependent on each other. You can (and should!) learn to use React Router before diving into Redux.

由于在之前“think in React”中，积累有坚实的基础。因此，相比于第一天学习 React Router，基于组件（component-based）的构建方式在此步的学习过程中，将会使我们领悟更多。

By this point you’ll have a solid foundation in “thinking in React,” and React Router’s component-based approach will make more sense than if you’d tackled it on Day 1.

## 第六步：Redux

Dan Abramov，作为 Redux 的创造人，[会告诉你们](https://github.com/gaearon/react-makes-you-sad)不要过早地接触 Redux。其实，这是有缘由的 —— 其复杂度在早期的学习过程中，将会带来灾难性的影响。

Dan Abramov, the creator of Redux, [will tell you](https://github.com/gaearon/react-makes-you-sad) not to add Redux too early, and for good reason – it’s a dose of complexity that can be disastrous early on.

虽然，在 Redux 背后所隐藏着的原理相当简单，但想要从理解跃至实践，却是一个很大的跨度。

The concepts behind Redux are fairly simple. But there is a mental leap from understanding the pieces to knowing how to use them in an app.

因此，重复第二步所做的：构建一次性的应用程序。通过些许的 Redux 经验，潜移默化地去理解其工作原理。

So, repeat what you did in Step 2: build disposable apps. Build a bunch of little Redux experiements to really internalize how it works.

## 非步骤

在前面列出的步骤中，你曾看见过”选择一个模板项目“的字眼吗？并没有。

Did you see “choose a boilerplate project” anywhere in the list? Nope.

仅通过挑选大量模板项目中的其中一个去深入学习 React，将只会带来大量的疑惑。虽然它们含有一切可能的库，并强迫定制有一些目录结构 —— 但对于小型的应用程序，或开始入门时来说，你并不需要。

Diving into React by picking one of the bajillion boilerplate projects out there will only confuse you. They include every possible library, and force a directory structure upon you – and neither of these are required for smaller apps, or when you’re getting started.

也许你会说，”但 Dave，我并不是构建一个小应用。而是，构建一个服务于上万用户级别的复杂应用！“……那么，请你重新阅读一下关于原型的理解

And if you’re thinking “But Dave I’m not building a small app, I’m building a complex app that will serve millions of users!”… go re-read that bit about prototypes.

## 该如何应对

虽然有大量的计划需要采取；有大量的东西需要学习 —— 但一切需要循规蹈矩，一步一脚印。

This is a lot to take in. It’s a lot to learn – but there’s a logical progression. One foot in front of the other.

虽说我已提供一系列的步骤，但若你会忘记了顺序或者跳过了前头？

There are a bunch of steps though, and what if you forget the order and skip ahead?

要是有一个能监督的方式就最好了……

If only there were a way to keep your eyes on the prize…

的确是有：我已经把上述的学习路线整理成一个可打印的 PDF 文件，以供注册获取！

Well, there is: I’ve put together a printable PDF of this timeline, and you can sign up to get it below!
