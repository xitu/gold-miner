> * 原文地址：[When Does a Project Need React?](https://css-tricks.com/project-need-react/)
> * 原文作者：[CHRIS COYIER](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# When Does a Project Need React? #

# 项目什么时候需要 React 框架呢？ #

You know when a project needs HTML and CSS, because it's all of them. When you reach for JavaScript is fairly clear: when you need interactivity or some functionality that only JavaScript can provide. It used to be fairly clear when we reached for libraries. We reached for jQuery to help us simplify working with the DOM, Ajax, and handle cross-browser issues with JavaScript. We reached for underscore to give us helper functions that the JavaScript alone didn't have.

你知道什么时候项目需要 HTML 和 CSS，因为这是项目的基础。什么时候用 JavaScript 也很清楚：当你需要只有它能提供的交互功能的时候。过去我们什么时候应该用代码库也很清楚：我们需要 jQuery 来帮助我们简化 DOM 操作，调用 Ajax，处理浏览器兼容问题；我们需要 Underscore 提供 JavaScript 无法单独提供的函数式编程。

As the need for these libraries fades, and we see a massive rise in new frameworks, I'd argue it's not as clear **when to reach for them**. At what point do we need React?

但是随着对这些代码库的需求逐渐消失，我们看到很多新兴的框架的大幅增长。我认为就不那么容易确定**何时需要它们**了。比如说，我们什么情况下需要 React 框架？

I'm just going to use React as a placeholder here for kinda large JavaScript framework thingies. Vue, Ember, Svelte... whatever. I understand they aren't all the same, but when to reach for them I find equally nebulous.

在众多的 JavaScript 框架中 —— Vue、Ember、Svelte ... 不管哪一个，我想以 React 框架为例子来探讨它适合什么项目。我明白这些框架并不完全相同，但是使用它们的时机应该是有一些共性的。

Here's my take.

这是我的做法。

### ✅ Because there is lots of state. ###

### ✅ 当项目中有大量的状态的时候 ###

Even "state" is a bit of a nebulous word. Imagine things like this:

即便“状态（state）”这个词也无法完全准确的表达我的意思。想象一下这些情况：

- Which navigation item is active
- 导航栏的哪个栏目正处于激活状态
- Whether a button is disabled or not
- 一个按钮是否被禁用
- The value of an input
- 输入框的值
- Which accordion sections are expanded
- 哪一个下拉框是弹出的状态
- When an area is loading
- 何时加载某个区域
- The user that is logged in and the team they belong to
- 登陆的用户如何进行权限控制
- Whether the thing the user is working on is published, or a draft
- 用户编写的文章是已发布状态还是草稿状态

"Business logic"-type stuff that we regularly deal with. State can also be straight up content:

“业务逻辑” - 我们经常处理的这类东西。状态也可能和内容直接相关：

- All the comments on an article and the bits and bobs that make them up
- 一篇文章中所有的评论，以及零零碎碎的组成它们的东西。
- The currently viewed article and all its metadata
- 当前正在查看的文章，以及该文章的一些属性
- An array of related articles and the metadata for those
- 一系列相关的文章，以及这些文章的属性
- A list of authors
- 一份作者列表
- An an activity log of recent actions a user has taken
- 一份记录用户近期操作的活动日志

React doesn't help you *organize* that state, it just says: I know you need to *deal* with state, so let's just *call* it state and have programmatic ways to set and get that state.

React 框架并没有帮助你**组织**这些状态，它只是说：我知道你需要处理状态的问题，所以我们不如把它设为 state 属性，通过编程的方式进行读写。

Before React, we might have *thought* in terms of state, but, for the most part, didn't manage it as a direct concept.

在有 React 框架之前，我们也许**考虑过**状态的定义，但是大部分时候并没有把它当作一个直接的概念去管理。

Perhaps you've heard the phrase "single source of truth"? A lot of times we treated the DOM as our single source of truth. For example, say you need to know if a form on your website is able to be submitted. Maybe you'd check to see if `$(".form input[type='submit']).is(":disabled")` because all your business logic that dealt with whether or not the form could be submitted or not ultimately changed the disabled attribute of that button. So the button became this defacto source of truth for the state of your app. 

也许你听说过这个短语“单一数据源”？很多时候我们把 DOM 作为我们的单一数据源。比如说，你需要知道是否可以提交某个表单了。也许你会用 `$(".form input[type='submit']).is(":disabled")` 去检查一下，因为所有影响表单是否可提交的业务逻辑最终都会改变按钮的 disable 属性。所以按钮变成了你的 app 事实上的数据源。

Or say you needed to figure of the name of the first comment author on an article. Maybe you'd write `$(".comments > ul > li:first > h3.comment-author).text()` because the DOM is the only place that knows that information.

或者说，你需要知道某篇文章的第一个评论者的名字，也许你会这样写 `$(".comments > ul > li:first > h3.comment-author).text()`，因为 DOM 是你唯一可以获得这些信息的地方。

React kinda tells us: 

React 框架这样告诉我们：

1. Let's start thinking about all that stuff as state. 
    
    我们把这些所有的东西都想像成状态（state）。

2. I'll do ya one better: state is a chunk of JSON, so it's easy to work with and probably works nicely with your back end.

    我会为你做好一件事：把状态转换为一串 JSON 字符串，这样的话处理起来很容易，也许你的服务端可以处理的很漂亮。

3. And one more even better: You build your HTML using bits of that state, and you won't have to deal with the DOM directly at all, I'll handle all that for you (and likely do a better/faster job than you would have.)

    另外还有一个更好的地方是：你可以用这些状态（state）直接构建 HTML ，你根本不需要直接操作 DOM，我都替你处理了（也许比你亲自处理的要更快更好）。

### ✅ To Fight Spaghetti. ###

### ✅ 对抗面条式代码 （Spaghetti）###

This is highly related to the state stuff we were just talking about. 

这和我们刚才讨论过的状态非常有关系。

"Spaghetti" code is when code organization and structure has gotten away from you. Imagine, again, a form on your site. It has some business logic stuff that specifically deals with the inputs inside of it. Perhaps there is a number input that, when changed, display the result of some calculation beside it. The form can also be submitted and needs to be validated, so perhaps that code is in a validation library elsewhere. Perhaps you disable the form until you're sure all JavaScript has loaded elsewhere, and that logic is elsewhere. Perhaps when the form is submitted, you get data back and that needs logic and handling. Nothing terribly surprising here, but you can see how this can get confusing quickly. How does a new dev on the project, looking at that form, reason out everything that is going on?

“面条式”代码，指的是代码的组织结构已经脱离你的掌控。再想象一下，假设有这么一个表单，它有一些专门处理表单内输入框的业务逻辑。该表单内有这么一个数字输入框，当这个输入框的值改变的时候，在旁边显示根据该值进行某些计算后的结果。这个表单可以被提交至服务端，因此也需要合法性检查，而也许合法性检查的代码位于其他地方的验证库中。也许在确定某处的 JavaScript 代码全部加载完之前，你还需要禁用此表单，而这个逻辑也在别的地方。也许当表单提交后，你还需要处理一些返回值。没有什么特别让人意外的功能，但是凑在一起就很容易让人蒙圈。如果这个项目由一个新的开发人员接手后，当他看到这个表单时他如何能捋清这些逻辑呢？

React encourages the use of building things into modules. So this form would likely either be a module of its own or comprised of other smaller modules. Each of them would handle the logic that is directly relevant to it. 

React 框架鼓励把东西打包成组件。所以这个表单要么自己是一个组件，要么由其他的小组件组成。每一个组件只处理与自己直接相关的逻辑。

React says: *well, you aren't going to be watching the DOM directly for changes and stuff, because the DOM is mine and you don't get to work with it directly*. Why don't you start thinking of these things as part of the state, change state when you need to, and I'll deal with the rest, rerendering what needs to be rerendered.

React 框架说：**嗯，你不会直接看到 DOM 的变化，因为 DOM 是我的，你无法直接操作它**。为什么你不把这些东西想象成状态的一部分，当需要的时候就改变状态（state）。我会处理其他的事情，重新渲染需要被渲染的界面。

It should be said that React itself doesn't entirely solve spaghetti. You can still have state in all kinds of weird places, name things badly, and connect things in weird ways. 

应该说，只有 React 框架还不足以解决面条式代码。因为状态也可能出现在各个奇怪的地方，或者状态起的名字很糟糕，或者用莫名其妙的方式调用。

In my limited experience, it's Redux that is the thing that really kills spaghetti. Redux says: I'll handle *all* the important state, totally globally, not module-by-module. I am the absolute source of truth. If you need to change state, there is quite a *ceremony* involved (I've heard it called that, and I like it.) There are reducers and dispatched actions and such. All changes follow the ceremony.

在我有限的经验内，Redux 框架才能真正解决面条式代码的问题。Redux 框架说：我会处理**所有**重要的状态，都是全局的，不是组件依赖的。我才是唯一的数据源。如果你需要改变状态，就要采用特定的**仪式**（我听说它是这么叫的，而且我喜欢这么叫）。通过 reducers 和被分发的（dispatched） actions，所有的改变都会遵循这种仪式。

If you go the Redux road (and there are variations of it, of course), you end up with really solid code. It's much harder to break things and there are clear trails to follow for how everything is wired together.

如果你准备在项目中加入 Redux（当然也需要一点微小的改变），那么你就可以和硬编码说再见了。通过加入 Redux 框架，组件会变的高内聚，也很容易理清整个需求的逻辑走向了。

### ✅ Lots of DOM management. ###

### ✅ 要控制大量的DOM ###

Manually handling the DOM is probably the biggest cause of spaghetti code.

手动处理 DOM 可能是引起面条式代码的最大原因。

1. Inject HTML over here!

    在这里插入一段 HTML ！
    
2. Rip something out over here!

    在这里把某些东西扔出去！
    
3. Watch this area for this event!

    监听特定区域的特定事件（event）！
    
4. Bind a new event over here!

    在这里绑定一个新事件！

5. New incoming content! Inject again! Make sure it has the right event bindings!

    又来了新内容。再次插入到 HTML 里，确保它绑定了正确的事件！


All these things can happen any time from anywhere in an app that's gone spaghetti. Real organization has been given up and it's back to the DOM as the source of truth. It's hard to know exactly what's going on for any given element, so everybody just asks the DOM, does what they need to do, and crosses their fingers it doesn't mess with somebody else.

此类事情可以发生在一个 app 的任何地方、任何时间，这就造成了面条式代码。手动管理是不靠谱的，因为这么做的话又变成 DOM 数据源了。很难准确的知道任何给定的元素发生了什么，所以每个人只好直接查询 DOM ，做他们必须做的事情，顺便向上帝祈祷他们这么做没干扰到别人。

React says: you don't get to deal with the DOM directly. I have a virtual DOM and I deal with that. Events are bound directly to the elements, and if you need it to do something above and beyond something directly handle-able in this module, you can kind of ceremoniously call things in higher order modules, but that way, the breadcrumb trail can be followed.

React 框架说：你不需要直接操作 DOM 。我用虚拟 DOM 来处理真实的 DOM。事件直接绑定在组件内，如果你想在该组件之外做些什么的话，只需要按照规范在父组件里调用就可以了。通过这种方式，所有的逻辑就有迹可循了。

*Complicated* DOM management is another thing. Imagine a chat app. New chat messages might appear because a realtime database has new data from other chatters and some new messages have arrives. Or you've typed a new message yourself! Or the page is loading for the first time and old messages are being pulled from a local data store so you have something to see right away. Here's [a Twitter thread](https://twitter.com/mjackson/status/849636985740210177) that drives that home.

管理**复杂的** DOM 是另一件 适合 React 框架的事情。想象有一个聊天软件，当数据库接收到其他聊天者传递来的新聊天信息时，在聊天窗口里应该显示这些新的信息。否则你只能自己给自己聊天了！或者当聊天页面第一次被加载的时候，可以从本地数据库里找出几条旧信息显示出来，这样你立刻有东西可以看了。比如说这个[推特例子](https://twitter.com/mjackson/status/849636985740210177)。

### ❌ Just because. It's the new hotness. ###

### ❌ 只是因为，React 框架是目前最火的框架。 ###

Learning something for the sake of learning something is awesome. Do that. 

为了学习而学习，是非常酷的。坚持下去。

Building a project for clients and real human being users requires more careful consideration. 

为了满足用户的需求而构建项目则需要更谨慎一点。

A blog, for example, *probably* has none of the problems and fits none of the scenarios that would make React a good fit. And because it's not a good fit, it's probably a *bad* fit, because it introduces complicated technology and dependencies for something that doesn't call for it.

举个例子，一个博客**也许**没什么复杂的逻辑，一点也不符合应该使用 React 框架的情况。所以如果不是很适合的话，那么也许就是**很不**适合 React 框架。因为这么做引入了复杂的技术，依赖了很多根本没用到的东西。

And yet, gray area. If that blog is a SPA ("Single Page App", e.g. no browser refreshing) that is built from data from a headless CMS and had fancy server-side rendering... well maybe that is React territory again.

在完全适合和完全不适合之间，如果这个博客是一个 SPA （“单页面应用”，不需要浏览器刷新），通过 headless CMS 获取数据构建该博客，并且具有出色的服务端渲染...好吧，也许又是 React 框架的领域。

The web app CMS that makes that blog? Maybe a good choice for React, because of all the state.

网络 app 内容管理系统创建的这种博客？也许用 React 是一个好选择，因为也是一大堆的状态。

### ❌ I just like JavaScript and want to write everything in JavaScript. ###

### ❌ 我就是喜欢 JavaScript ，就是想用它来编写任何东西。 ###

People get told, heck, I've told people: learn JavaScript. It's huge. It powers all kinds of stuff. There are jobs in it. It's not going anyway.

我经常安利周围的人：学习 JavaScript。因为 JavaScript 的知识太丰富了。它能做很多很多的事情，所以好好学习 JavaScript 永远不会过时。

It's only in recent web history that it's become possible to never leave JavaScript. You got Node.js on the server side. There are loads of projects that yank CSS out of the mix and handle styles through JavaScript. And with React, your HTML is in JavaScript too.

只有在最近的网络发展中，Javascript 才变的不可或缺。你通过 Node.js 构建服务端，也有很多项目可以通过 JavaScript 处理 CSS。现在通过 React 框架，你还可以通过 JavaScript 来操作 HTML。

All JavaScript! All hail JavaScript!

万物归于 JavaScript！JavaScript 万岁！

That's cool and all, but again, just because you can doesn't mean you should. Not all projects call for this, and in fact, most probably don't. 

JavaScript 确实碉堡了，但是你可以这么做并不意味着你必须这么做。并不是所有的项目都必须使用 JavaScript ，而且事实上，有相当一部分有可能压根不需要。

### ☯️ That's what I know. ###

### ☯️ 这就是我所知道的。 ###

(There are decent emojis for YES and NO, but MAYBE is tougher!)

（**是**和**否**有体面的表情，但是**也许**更坚韧！）


You're learning. Awesome. Everybody is. Keep learning. The more you know the more informed decisions you can make about what tech to use. 

你在学习，太好了。每个人都在学习，所以坚持学习吧。你知道的越多，你越知道该应该用什么技术。

But sometimes you gotta build with what you know, so I ain't gonna ding ya for that.

但是很多时候你只能以现有的技术来构建项目，所以我也不会反复强调这一点。

### ☯️ That's where the jobs are. ###

### ☯️ 这就是工作。 ###

Not everybody has a direct say in what technology is used on any given project. Hopefully, over time, you have influence in that, but that takes time. Eden says she [spent 2 years with Ember](https://twitter.com/edenthecat/status/849640183360352257) because that's where the jobs were. No harm in that. Everybody's gotta get paid, and Ember might have been a perfect fit for those projects.

在给定的任何项目中，不是每个人都决定应该底用什么技术。希望随着时间的增长，你可以更大层度上的影响决策。Eden 说她[花了两年的时间研究 Ember](https://twitter.com/edenthecat/status/849640183360352257)，因为这就是她的工作。没有任何冒犯的意思，但是拿人钱财就得替人消灾。Ember 也许比较适合这些项目。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
