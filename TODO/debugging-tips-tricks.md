> * 原文地址：[Debugging Tips and Tricks](https://css-tricks.com/debugging-tips-tricks/)
> * 原文作者：[SARAH DRASNER](https://css-tricks.com/author/sdrasner/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Debugging Tips and Tricks #

Writing code is only one small piece of being a developer. In order to be efficient and capable at our jobs, we must also excel at debugging. When I dedicate some time to learning new debugging skills, I often find I can move much quicker, and add more value to the teams I work on. I have a few tips and tricks I rely on pretty heavily and found that I give the same advice again and again during workshops, so here’s a compilation of some of them, as well as some from the community. We'll start with some core tenants and then drill down to more specific examples.

### # Main Concepts ###

#### # Isolate the Problem ####

Isolation is possibly the strongest core tenant in all of debugging. Our codebases can be sprawling, with different libraries, frameworks, and they can include many contributors, even people who aren't working on the project anymore. Isolating the problem helps us slowly whittle away non-essential parts of the problem so that we can singularly focus on a solution.

Some of the benefits of isolation include, but are not limited to:

- Figuring out if it’s actually the root cause we think it is or some sort of conflict
- For time-based tasks, understanding whether or not there is a race condition
- Taking a hard look at whether or not our code can be simplified, which can help with both writing it and maintaining it
- Untangling it and seeing if it’s one issue or perhaps more

It's very important to make the issue reproducible. Without being able to discern exactly what the issue is in a way where you can reproduce it, it’s very difficult to solve for it. This also allows you to compare it to working model that is similar so that you can see what changed or what is different between the two.

I have a lot of different methods of isolation in practice. One is to create a reduced test case on a local instance, or a private CodePen, or a JSBin. Another is to create breakpoints in the code so that I can see it execute bit by bit. There are a few ways to define breakpoints:

You can literally write `debugger;` inline in your code. You can see how this will fire small pieces at a time.

You can take this one step further in Chrome DevTools and even walk through the next events that are fired or choose specific event listeners:

![Step into the next function call](https://cdn.css-tricks.com/wp-content/uploads/2017/04/stepintonextfunctioncall.gif)

Good 'ol `console.log` is a form of isolation. (Or `echo` in PHP, or `print` in python, etc…). You are taking one tiny piece of execution and testing your assumptions, or checking to see if something is altering. This is probably the most time-tested form of debugging, that no matter how advanced you become, still has it's uses. Arrow functions in ES6 have allowed us to step up our console debugging game as well, as it’s now a lot easier to write useful one-liners in the console.

The `console.table` function is also a favorite tool of mine, especially great for when you have a lot of data you need to represent- large arrays, large objects and the like. The `console.dir` function is also a nice alternative. It will log an interactive listing of an object's properties.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/04/dir.png)

console.dir gives an interactive listing

#### #Be Methodical ####

When I teach workshops and help students in my class, the number one thing that I find holds them back as they try to debug a problem is not being methodical enough. This is truly a tortoise-and-the-hare kind of situation. They understandably want to move quickly, so they change a ton of things at once, and then when something stops working, they don’t know which thing they changed is causing the error. Then, to debug, they change many things at once and get a little lost trying to figure out what is working and what isn't.

We all do this to some extent. As we become more proficient with a tool, we can write more and more code without testing an assumption. But if you’re new to a syntax or technology, being slow and careful behooves you. You have a much better shot at backing out of an issue you might have inadvertently created for yourself. And indeed, once you have created an issue, debugging one thing at a time might seem slower, but exposes exactly what changes have happened and where the error lies in a way that a *seemingly* faster pace doesn’t allow. I say seemingly because the time isn’t actually recovered working this way.

**Do you remember when you were a kid and your parents said, "if you get lost, stay where you are?"** My parents did, at least. It's because if they were moving around to find me and I was also moving around to find them, we'd have fewer chances of bumping into one another. Code works the same way. The less moving pieces you have, the better- the more you are returning consistent results, the easier it will be to track things down. So while you’re debugging, try not to also install anything, or put in new dependencies. If you see a different error every time you should be returning a static result, that’s a big red flag you should be headed right for with your sleuth hat on.

### # Choose Good Tools ###

There are a million different tools for solving a variety of problems. I’m going to work through some of the tools I find the most useful and then we’ll link off to a bevy of resources.

#### # Syntax Highlighting ####

Sure, it’s damn fun to pick out the new hotness in colors and flavors for your syntax highlighting theme, but spending some time thinking about clarity here matters. I often pick dark themes where a skip in syntax will turn all of my code a lighter color, I find errors are really easy to see right away. I tend to like Oceanic Next or Panda, but really, to each their own on this one. It’s important to keep in mind that when looking for a good syntax highlighter, awesome-looking is great, but functional for calling out your mistakes is most important, and it's totally possible to do both.

#### # Linting ####

Linting helps flag suspicious code and calls out errors we might have overlooked. Linting is incredibly important, but which linter you choose has so much to do with what language/framework you’re writing in, and then on top of that, what your agreed-upon code style is.

Different companies have different code styles and rules. Personally, I like [AirBnB's](https://github.com/airbnb/javascript), but take care and don't just use any old linter. Your linter enforces patterns that, if you yourself don’t want to enforce, can stall your build process. I had a CSS linter that complained whenever I wrote a browser hack, and ended up having to circumvent it so often that it stopped being useful. But a good linter can shine light on small errors you might have missed that are lurking.

Here are some resources:

- I recently found [this responsive images linter](https://github.com/ausi/respimagelint), that tells you what opportunities you might have to use picture, srcset, or sizes.
- Here’s a [pretty good breakdown](https://www.sitepoint.com/comparison-javascript-linting-tools/) of some JS linters

#### # Browser Extensions ####

Extensions can be really awesome because they can be enabled and disabled so readily, and they can work with really specific requirements. If you’re working with a particular library or framework, chances are, having their extension for DevTools enabled is going to give you all sorts of clarity that you can’t find otherwise. Take care though- not only can extensions bog a browser down, but they have permissions to execute scripts, so do a little homework into the extension author, ratings, and background. All that said, here are some of my favorites:

- [Accessibility extension](https://chrome.google.com/webstore/detail/axe/lhdoppojpmngadmnindnejefpokejbdd) from Dequeue Systems
- [React DevTools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi) really vital, in my opinion, if you're working with React, to see their virtual DOM
- [Vue DevTools](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd) same endorsement as above.
- [Codopen](https://chrome.google.com/webstore/detail/codopen/agnkphdgffianchpipdbkeaclfbobaak): pops you out of the editor mode into a debug window for CodePen. Full disclosure: my husband made this for me as a present because he was sick of watching me manually opening the debug window (best gift ever!)
- [Pageruler](https://chrome.google.com/webstore/detail/page-ruler/jlpkojjdgbllmedoapgfodplfhcbnbpn): get pixel dimensions and measure anything on a page. I like this one because I’m super duper anal about my layout. This helps me feed the beast.

### # DevTools ###

This is probably the most obvious of debugging tools, and there are so many things you can do with them. They can have so many packed-in features that can be easy to miss, so in the next section of specific tips, we'll go into a deep dive of some favorites.

Umar Hansa has great materials for learning what the DevTools can do. He has [a weekly newsletter and GIFs](https://umaar.com/dev-tips/), a new course linked in the last section, and [an article on our site](https://css-tricks.com/six-tips-for-chrome-devtools/).

One of my favorite recent ones is this [CSS Tracker Enhancement](https://umaar.com/dev-tips/126-css-tracker/), shown here with permission from Umar. This shows all of the unused CSS so that you can understand the performance impact.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/04/Screen-Shot-2017-04-10-at-10.20.11-AM.png)

The CSS tracker shows color-coded rules for used and unused sets.

#### # Misc Tools ####

- [What input](https://ten1seven.github.io/what-input/) is a global utility for tracking the current input method (mouse, keyboard or touch), as well as the current intent- this can be really good for tracking down accessiblity leaks (hat tip to Marcy Sutton, accessibility expert for this tipoff)
- [Ghostlabapp](https://www.vanamco.com/ghostlab/) is a pretty snazzy tool if you’re doing responsive development or checking anything deployed across a ton of devices. It offers synchronized web development, testing, and inspection.
- [Eruda is an awesome tool](http://eruda.liriliri.io/) that helps debug on mobile devices. I really like it because it takes a simulator a step further, gives a console and real devtools to help you gain understanding.

![eruda gives you a mobile console](https://cdn.css-tricks.com/wp-content/uploads/2017/04/Screen-Shot-2017-04-10-at-10.38.57-AM.png)

### # Specific Tips ###

I am always interested in what other people do to debug, so I asked the community through the CSS-Tricks account and my own what they were really into. This list is a mixture of tips I like as well as a roundup of tips from the community.

#### # Accessibility ####

```
$('body').on('focusin',function(){
  console.log(document.activeElement);});
```

> This logs the currently focused element, useful because opening the Devtools blurs the activeElement

-[Marcy Sutton](https://twitter.com/marcysutton)

#### # Debugging CSS ####

We got quite a lot of responses saying that people put red borders on elements to see what they’re doing

> [@sarah_edo](https://twitter.com/sarah_edo) for CSS, I'll usually have a .debug class with a red border that I slap on troublesome elements.
>
> — Jeremy Wagner (@malchata) [March 15, 2017](https://twitter.com/malchata/status/842029469246324736)

I do this too, I even have a little CSS file that drops in some classes I can access for different colors easily.

#### # Checking State in React ####

> [@sarah_edo](https://twitter.com/sarah_edo) <pre>{JSON.stringify(this.state, null, 2)}</pre>
>
> — MICHAEL JACKSON (@mjackson) [March 15, 2017](https://twitter.com/mjackson/status/842041642760646657)

Props to Michael, this is one of the most useful debugging tools I know of. That snippet "pretty prints" the state of the component you're working with onto the component so that you can see what’s going on. You can validate that the state is working the way that you think it should be, and it helps track down any errors between the state and how you're using it.

#### # Animation ####

We got a lot of responses that said they slow the animation way down:

> [@sarah_edo](https://twitter.com/sarah_edo)[@Real_CSS_Tricks](https://twitter.com/Real_CSS_Tricks) * { animation-duration: 10s !important; }
>
> — Thomas Fuchs (@thomasfuchs) [March 15, 2017](https://twitter.com/thomasfuchs/status/842029720820695040)

I mentioned this on a post I wrote right here on CSS Tricks about [debugging CSS Keyframe animations](https://css-tricks.com/debugging-css-keyframe-animations/), there are more tips too, like how to hardware accelerate, or work with multiple transforms in different percentages.

I also slow down my animations in JavaScript- in GreenSock that would look like: `timeline.timeScale(0.5)` (you can slow down the whole timeline, not just one thing at a time, which is super useful), in mo.js that would look like `{speed: 0.5}`.

[Val Head has a great screencast](https://www.youtube.com/watch?v=MjRipmP7ffM&amp;feature=youtu.be) going through both chrome and firefox devtools offering on animation.

If you want to use the Chrome Devtools timeline to do performance audits, it's worth mentioning that painting is the most expense of the tasks, so all things being equal, pay a little more attention to a high percentage of that green.

#### # Checking different connection speeds and loads ####

I tend to work on fast connections, so I will throttle my connection to check and see what the performance would look like for people who don’t have my internet speed.

![throttle connection in devtools](https://cdn.css-tricks.com/wp-content/uploads/2017/04/Screen-Shot-2017-04-10-at-9.29.00-AM.png)

This is also useful in conjunction with a hard reload, or with the cache empty

> [@sarah_edo](https://twitter.com/sarah_edo) Not so secret trick. But still many people are unaware. You need DevTools open, and then right click over the refresh button. [pic.twitter.com/FdAfF9Xtxm](https://t.co/FdAfF9Xtxm)
>
> — David Corbacho (@dcorbacho) [March 15, 2017](https://twitter.com/dcorbacho/status/842033259664035840)

#### # Set a Timed Debugger ####

This one came from Chris. We have a whole writeup on it [right here](https://css-tricks.com/set-timed-debugger-web-inspect-hard-grab-elements/):

```
setTimeout(function() {
  debugger;
}, 3000);
```

It’s similar to the debugger; tool I mentioned earlier, except you can put it in a setTimeout function and get even more fine-tuned information

#### # Simulators ####

> [@Real_CSS_Tricks](https://twitter.com/Real_CSS_Tricks) And just in case any Mac users didn't know this, iOS simulator + Safari is sweet. [pic.twitter.com/Uz4XO3e6uD](https://t.co/Uz4XO3e6uD)
>
> — Chris Coyier (@chriscoyier) [March 15, 2017](https://twitter.com/chriscoyier/status/842034009060302848)

I mentioned simulators with Eruda before. iOS users also get a pretty sweet simulator. I was going to tell you you have to install XCode first, but this tweet showed another way:

> [@chriscoyier](https://twitter.com/chriscoyier)[@Real_CSS_Tricks](https://twitter.com/Real_CSS_Tricks) Or, you can use this approach if you didn't want to bother with installing xCode:  [https://t.co/WtAnZNo718](https://t.co/WtAnZNo718)
>
> — Chris Harrison (@cdharrison) [March 15, 2017](https://twitter.com/cdharrison/status/842038887904088065)

Chrome also has a device toggle which is helpful.

#### # Remote Debuggers ####

> [@chriscoyier](https://twitter.com/chriscoyier)[@Real_CSS_Tricks](https://twitter.com/Real_CSS_Tricks)[https://t.co/q3OfWKNlUo](https://t.co/q3OfWKNlUo) is a good tool.
>
> — Gilles 💾⚽ (@gfra54) [March 15, 2017](https://twitter.com/gfra54/status/842035375304523777)

I actually didn't know about this tool until seeing this tweet. Pretty useful!

#### # CSS Grid Debugging #### (#article-header-id-18 .has-header-link)

Rachel Andrew gave a presentation at Smashing and mentioned a little waffle thing you can click on in Firefox that will illuminate the gutters in the grid. [Her video](http://gridbyexample.com/learn/2016/12/17/learning-grid-day17/) explains it really eloquently.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/04/Screen-Shot-2017-04-10-at-9.58.14-AM.png)

Rachel Andrew shows how to highlight gutters in Firefox DevTools.

#### # Array Debugging ####

Wes Bos with a really useful tip for searching for a single item in an array:

> If you are just looking for a single item array.find() is 🔥 [https://t.co/AuRtyFwnq7](https://t.co/AuRtyFwnq7)
>
> — Wes Bos (@wesbos) [March 15, 2017](https://twitter.com/wesbos/status/842069915158884354)

### # Further Debugging Resources ###

Jon Kuperman has a [Frontend Masters course](https://frontendmasters.com/courses/chrome-dev-tools/) that can help you master devtools it goes along [with this app](https://github.com/jkup/mastering-chrome-devtools).

There’s a small course on code school called [discover devtools](https://www.codeschool.com/courses/discover-devtools).

Umar Hansa has a new online course called [Modern DevTools](https://moderndevtools.com/).

Julia Evans has a great article [about debugging here](http://jvns.ca/blog/2015/11/22/how-i-got-better-at-debugging/), hat tip to Jamison Dance for showing it to me.

Paul Irish does some [advanced performance audits with devtools](https://docs.google.com/document/d/1K-mKOqiUiSjgZTEscBLjtjd6E67oiK8H2ztOiq5tigk/pub) if you're super nerdy like me and want to dig into the timeline.

Finally, I'll put in a bittersweet resource. My friend James Golick who was an excellent programmer and even more excellent human gave this great conference talk about debugging anything many years ago. Sadly James has passed, but we can still honor his memory and learn from him:

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
