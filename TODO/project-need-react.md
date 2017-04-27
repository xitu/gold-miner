> * 原文地址：[When Does a Project Need React?](https://css-tricks.com/project-need-react/)
> * 原文作者：[CHRIS COYIER](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# When Does a Project Need React? #

You know when a project needs HTML and CSS, because it's all of them. When you reach for JavaScript is fairly clear: when you need interactivity or some functionality that only JavaScript can provide. It used to be fairly clear when we reached for libraries. We reached for jQuery to help us simplify working with the DOM, Ajax, and handle cross-browser issues with JavaScript. We reached for underscore to give us helper functions that the JavaScript alone didn't have.

As the need for these libraries fades, and we see a massive rise in new frameworks, I'd argue it's not as clear **when to reach for them**. At what point do we need React?

I'm just going to use React as a placeholder here for kinda large JavaScript framework thingies. Vue, Ember, Svelte... whatever. I understand they aren't all the same, but when to reach for them I find equally nebulous.

Here's my take.

### ✅ Because there is lots of state. ###

Even "state" is a bit of a nebulous word. Imagine things like this:

- Which navigation item is active
- Whether a button is disabled or not
- The value of an input
- Which accordion sections are expanded
- When an area is loading
- The user that is logged in and the team they belong to
- Whether the thing the user is working on is published, or a draft

"Business logic"-type stuff that we regularly deal with. State can also be straight up content:

- All the comments on an article and the bits and bobs that make them up
- The currently viewed article and all its metadata
- An array of related articles and the metadata for those
- A list of authors
- An an activity log of recent actions a user has taken

React doesn't help you *organize* that state, it just says: I know you need to *deal* with state, so let's just *call* it state and have programmatic ways to set and get that state.

Before React, we might have *thought* in terms of state, but, for the most part, didn't manage it as a direct concept.

Perhaps you've heard the phrase "single source of truth"? A lot of times we treated the DOM as our single source of truth. For example, say you need to know if a form on your website is able to be submitted. Maybe you'd check to see if `$(".form input[type='submit']).is(":disabled")` because all your business logic that dealt with whether or not the form could be submitted or not ultimately changed the disabled attribute of that button. So the button became this defacto source of truth for the state of your app. 

Or say you needed to figure of the name of the first comment author on an article. Maybe you'd write `$(".comments > ul > li:first > h3.comment-author).text()` because the DOM is the only place that knows that information.

React kinda tells us: 

1. Let's start thinking about all that stuff as state. 
2. I'll do ya one better: state is a chunk of JSON, so it's easy to work with and probably works nicely with your back end.
3. And one more even better: You build your HTML using bits of that state, and you won't have to deal with the DOM directly at all, I'll handle all that for you (and likely do a better/faster job than you would have.)

### ✅ To Fight Spaghetti. ###

This is highly related to the state stuff we were just talking about. 

"Spaghetti" code is when code organization and structure has gotten away from you. Imagine, again, a form on your site. It has some business logic stuff that specifically deals with the inputs inside of it. Perhaps there is a number input that, when changed, display the result of some calculation beside it. The form can also be submitted and needs to be validated, so perhaps that code is in a validation library elsewhere. Perhaps you disable the form until you're sure all JavaScript has loaded elsewhere, and that logic is elsewhere. Perhaps when the form is submitted, you get data back and that needs logic and handling. Nothing terribly surprising here, but you can see how this can get confusing quickly. How does a new dev on the project, looking at that form, reason out everything that is going on?

React encourages the use of building things into modules. So this form would likely either be a module of its own or comprised of other smaller modules. Each of them would handle the logic that is directly relevant to it. 

React says: *well, you aren't going to be watching the DOM directly for changes and stuff, because the DOM is mine and you don't get to work with it directly*. Why don't you start thinking of these things as part of the state, change state when you need to, and I'll deal with the rest, rerendering what needs to be rerendered.

It should be said that React itself doesn't entirely solve spaghetti. You can still have state in all kinds of weird places, name things badly, and connect things in weird ways. 

In my limited experience, it's Redux that is the thing that really kills spaghetti. Redux says: I'll handle *all* the important state, totally globally, not module-by-module. I am the absolute source of truth. If you need to change state, there is quite a *ceremony* involved (I've heard it called that, and I like it.) There are reducers and dispatched actions and such. All changes follow the ceremony.

If you go the Redux road (and there are variations of it, of course), you end up with really solid code. It's much harder to break things and there are clear trails to follow for how everything is wired together.

### ✅ Lots of DOM management. ###

Manually handling the DOM is probably the biggest cause of spaghetti code.

1. Inject HTML over here!
2. Rip something out over here!
3. Watch this area for this event!
4. Bind a new event over here!
5. New incoming content! Inject again! Make sure it has the right event bindings!

All these things can happen any time from anywhere in an app that's gone spaghetti. Real organization has been given up and it's back to the DOM as the source of truth. It's hard to know exactly what's going on for any given element, so everybody just asks the DOM, does what they need to do, and crosses their fingers it doesn't mess with somebody else.

React says: you don't get to deal with the DOM directly. I have a virtual DOM and I deal with that. Events are bound directly to the elements, and if you need it to do something above and beyond something directly handle-able in this module, you can kind of ceremoniously call things in higher order modules, but that way, the breadcrumb trail can be followed.

*Complicated* DOM management is another thing. Imagine a chat app. New chat messages might appear because a realtime database has new data from other chatters and some new messages have arrives. Or you've typed a new message yourself! Or the page is loading for the first time and old messages are being pulled from a local data store so you have something to see right away. Here's [a Twitter thread](https://twitter.com/mjackson/status/849636985740210177) that drives that home.

### ❌ Just because. It's the new hotness. ###

Learning something for the sake of learning something is awesome. Do that. 

Building a project for clients and real human being users requires more careful consideration. 

A blog, for example, *probably* has none of the problems and fits none of the scenarios that would make React a good fit. And because it's not a good fit, it's probably a *bad* fit, because it introduces complicated technology and dependencies for something that doesn't call for it.

And yet, gray area. If that blog is a SPA ("Single Page App", e.g. no browser refreshing) that is built from data from a headless CMS and had fancy server-side rendering... well maybe that is React territory again.

The web app CMS that makes that blog? Maybe a good choice for React, because of all the state.

### ❌ I just like JavaScript and want to write everything in JavaScript. ###

People get told, heck, I've told people: learn JavaScript. It's huge. It powers all kinds of stuff. There are jobs in it. It's not going anyway.

It's only in recent web history that it's become possible to never leave JavaScript. You got Node.js on the server side. There are loads of projects that yank CSS out of the mix and handle styles through JavaScript. And with React, your HTML is in JavaScript too.

All JavaScript! All hail JavaScript!

That's cool and all, but again, just because you can doesn't mean you should. Not all projects call for this, and in fact, most probably don't. 

### ☯️ That's what I know. ###

(There are decent emojis for YES and NO, but MAYBE is tougher!)

You're learning. Awesome. Everybody is. Keep learning. The more you know the more informed decisions you can make about what tech to use. 

But sometimes you gotta build with what you know, so I ain't gonna ding ya for that.

### ☯️ That's where the jobs are. ###

Not everybody has a direct say in what technology is used on any given project. Hopefully, over time, you have influence in that, but that takes time. Eden says she [spent 2 years with Ember](https://twitter.com/edenthecat/status/849640183360352257) because that's where the jobs were. No harm in that. Everybody's gotta get paid, and Ember might have been a perfect fit for those projects.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
