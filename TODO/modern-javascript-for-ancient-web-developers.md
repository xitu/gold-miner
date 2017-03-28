> * 原文地址：[Modern JavaScript for Ancient Web Developers](https://trackchanges.postlight.com/modern-javascript-for-ancient-web-developers-58e7cae050f9#.ibsx51ylz)
> * 原文作者：[Gina Trapani](https://trackchanges.postlight.com/@ginatrapani?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Modern JavaScript for Ancient Web Developers #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*_5XMNVNbpIDCDHU1YXZPyA.png">

Learn JavaScript using… JavaScript. Image via [learnyounode](https://github.com/workshopper/learnyounode).

There’s a certain kind of old-school, backend web developer who, a long time ago, mastered things like Perl or Python or PHP or Java Server Pages, maybe even Rails or Django. This person worked with giant relational databases and built APIs that serve up JSON and even (*gasp!*) XML.

This person is a *backend* developer, so for a long time, JavaScript was just a fun little toy that added a bit of frontend trickery that could make things on a web page change color. If JavaScript was being really useful, it would add form validation that helped prevent the wrong information from getting into the database. Eight years ago [jQuery blew this person’s mind](https://twitter.com/ginatrapani/status/3252157585). JavaScript itself was a language one merely tolerated, but never embraced.

Then JavaScript and its modern frameworks ate backend, frontend, and everything in between, and it was time to re-become a web developer in 2017 — who writes JavaScript.

Hi. I’m an ancient web developer who is learning modern JavaScript. I’ve just gotten started and I’m having a ball, but I’ve also got whiplash. There are a few things I wish I’d understood and accepted about the world of modern JavaScript before I got started.

Here are some of the changes I had to make to my own mindset and expectations around learning a new ecosystem based on an old language which has taken over my craft.

### Moving Target (dot JS)

The modern JS world is nothing if not young and rapidly changing, so it’s easy to choose the framework or templating engine or build tool or tutorial that’s out of date or teaching a technique that’s no longer best practice (when there even is a generally-accepted notion of what “best practice” is).

In those cases, it’s time to reach out to your Local Friendly Modern JavaScript Engineer, and have a little chat about the path you’re on. I’ve been lucky to get fantastic guidance from my fellow engineers here at Postlight (especially [Jeremy Mack](https://medium.com/@mutewinter)), and I thank them for putting up with my endless questions.

The point is, learning modern JavaScript requires human intervention. Things haven’t settled down long enough for curriculums and guides to gel and mature, and for best practices to become authoritative for more than a few months. If you don’t have a human expert at hand, at the very least, check the date on that Medium article or tutorial or the last commit in that GitHub repository. If it’s more than a year old, it’s almost certainly not the way to go.

### New Problems, Not-Yet-Established Solutions ###

Along these same lines: when you’re learning modern JavaScript, there’s a good chance that the solution to the problem you’re having is still getting worked out. In fact, it’s very possible it is only one code review away from getting merged into the package you’re using.

When you’re working with an ancient language like PHP, you Google a question or problem, and almost 100% of the time you will find a 5-year-old Stack Overflow answer that solves it, or a full discussion in the (thorough, heavily commented, and unparalleled) [documentation](http://docs.php.net/docs.php).

Not so much with modern JavaScript. I’ve found myself trawling through comments on GitHub issues and source code only to find information that contradicts out-of-date documentation more than once. Parsing GitHub repos is part of learning and using various JavaScript packages, and for an Old Person like me, working that close to the edge can be bewildering.

### Tooling Overload ###

The other difficult thing about learning JavaScript in 2017: getting set up will feel like it takes you as long as building the app will. The sheer number of tools and plugins and packages and dependencies and editor setup and build configurations required to do it “the right way” is enough to stall you before you even get started.

[![Markdown](http://i4.buimg.com/1949/adafb30475d3d36a.png)](https://twitter.com/capndesign/status/832638513048850433/photo/1)

*Do not let this stop you.* I had to let go of doing it The Right Way from the get-go, and allow myself to fumble through using suboptimal or just plain amateur setups just to get comfortable with individual tools. (Let me tell you about that time I used [nodemon](https://nodemon.io/) to do my linting…) Then I’d find out better ways and incorporate what I could, when I could, on each new project.

The JS world has a *lot* of work to do in this regard. Again, this area of modern JavaScript is a constantly moving target, but my Local Friendly Modern JS Engineers tell me that [this tutorial from Jonathan Verrecchia](https://github.com/verekia/js-stack-from-scratch) is currently the definitive guide to building a modern JavaScript stack. For now.

![Markdown](http://i1.piimg.com/1949/95cedaf271a8c352.png)
[**verekia/js-stack-from-scratch**](https://github.com/verekia/js-stack-from-scratch)

[*js-stack-from-scratch - 🎉 V2 release! 🎉 - Step-by-step tutorial to build a modern JavaScript stack.*github.com](https://github.com/verekia/js-stack-from-scratch)

### Tutorial / Project / Throw It Away / Repeat ###

When you’re learning any new language, you write code and then you throw it away, and then you write some more. My modern JavaScript education has been a stepladder of tutorials, then a small tractable project during which I compiled a list of questions and problems, then a check-in with my coworkers to get answers and explanations, then more tutorials, then a slightly bigger project, more questions, a check-in — wash, rinse, repeat.

Here’s an incomplete list of some of the workshops and tutorials I’ve run through in this process so far.

- [HOW-TO-NPM](https://github.com/workshopper/how-to-npm) — npm is the package manager for JavaScript. Even though I’d typed `npm install` thousands of times before I started this process, I didn’t know all the things npm does till I completed this interactive workshop. (On several projects I’ve since moved onto using [yarn](https://github.com/yarnpkg/yarn) instead of npm, but all the concepts translate.)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*0NydvP4xLtp13z_HE2Xqyw.png">

`npm i -g how-to-npm`

- [learnyounode](https://github.com/workshopper/learnyounode) — I decided to focus on server-side JavaScript first because that’s where I’m comfortable, so Node.js it is. Learnyounode is an interactive introduction to Node.js similar in structure to how-to-npm.
- [expressworks](https://github.com/azat-co/expressworks) — Similar to the previous two workshoppers, Expressworks is an introduction to Express.js, a web framework for Node.js. Express doesn’t get a whole lot of use here at Postlight these days, but it was worth learning as a beginner to get a taste of building a simple webapp.
- Now it was time to build something real. I found Tomomi Imura’s tutorial on [Creating a Slack Command Bot from Scratch with Node.js](http://www.girliemac.com/blog/2016/10/24/slack-command-bot-nodejs/) was just enough Node and Express to put my newfound skills to work. Since I was focusing on backend, building a slash command for Slack was a good place to start because there’s no frontend presentation (Slack does that for you).
- In the process of building this command, instead of using ngrok or Heroku as recommended in the walkthrough, I experimented with [Zeit Now](https://zeit.co/now), which is an invaluable tool for anyone building quick, one-off JS apps.
- Once I started writing Actual Code, I also started to fall down the tooling rabbit hole. Installing Sublime plugins, getting [Node versioning](https://github.com/postlight/lux/blob/master/CONTRIBUTING.md#nodejs-version-requirements) right, setting up ESLint using [Airbnb’s style guide (Postlight’s preference)](https://github.com/airbnb/javascript) — these things slowed me down, but also were worth the initial investment. I’m still in the thick of this; for example, Webpack is still pretty mysterious to me, but [this video is a pretty great introduction](https://www.youtube.com/watch?v=WQue1AN93YU)*.*
- At some point JS’s asynchronous execution (specifically, “[callback hell](http://callbackhell.com/)”) started to bite me. [Promise It Won’t Hurt](https://github.com/stevekane/promise-it-wont-hurt) is another workshopper that teaches you how to write “clean” asynchronous code using Promises, a relatively new JS abstraction for dealing with async execution. Truth be told, Promises almost broke me — they’re a mind-bendy paradigm shift. Thanks to [Mariko Kosaka](http://kosamari.com/notes/the-promise-of-a-burger-party), now I think about them whenever I order a burger.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*Gh5Pv0ujTuikxGZMeANfCg.png">

burger.resolve() — image via [The Promise of a Burger Party](http://kosamari.com/notes/the-promise-of-a-burger-party).

From here I knew enough to get myself into all sorts of trouble, like experiment with [Jest](https://facebook.github.io/jest/) for testing, [Botkit](https://github.com/howdyai/botkit) for more Slack bot fun, and [Serverless](https://serverless.com/) to really hammer home the value of functional programming. If you don’t know what any of that means, that’s okay. It’s a big world, and we all take our own paths through it.

### **“First do it, then do it right, then do it better**.” ###

Ultimately the most important thing I’ve had to remember is this: Doing is learning. Doing it badly? It’s still learning.

[Learning modern JavaScript these days](https://hackernoon.com/how-it-feels-to-learn-javascript-in-2016-d3a717dd577f#.kclvczou2) can feel like a futile exercise in WTF. For those moments you’re wondering if you missed your calling as a barista, Google’s [Addy Osmani has the right advice](https://medium.com/@addyosmani/totally-get-your-frustration-ea11adf237e3#.t599ja0j3):

> I encourage folks to adopt this approach to keeping up with the JavaScript ecosystem: **first do it, then do it right, then do it better**. […]

> It takes time, experimentation and skill to master the fundamentals of any new topic. Beginners shouldn’t feel like they’re failing if they’re not using the library-du-jour or reactive-pattern of the week. It took me weeks to get Babel and React right. Longer to get Isomorphic JS, WebPack and all of the other libraries around it right. **Start simple and build on that base.**

*Thanks to* [*NodeSchool*](https://nodeschool.io/)and[*Free Code Camp*](https://www.freecodecamp.com/), two fantastic resources for beginners learning JavaScript.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
