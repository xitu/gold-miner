> * 原文地址：[Start your open-source career](https://blog.algolia.com/start-your-open-source-career/)
> * 原文作者：[Vincent Voyer](https://github.com/vvo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/start-your-open-source-career.md](https://github.com/xitu/gold-miner/blob/master/TODO/start-your-open-source-career.md)
> * 译者：
> * 校对者：

# Start your open-source career

This year I gave a talk about how to make open-source projects successful by ensuring everything is in place to attract all kinds of contributions: issues, documentation or code updates. After the talk, the feedback I got was “It’s nice, you showed how to make projects successful, but **how do I even start** **doing open-source?**“. This blog post is an answer to that question; it explains how and where to start contributing to projects and then how to create your own projects.

The knowledge shared here is based on our experience: at Algolia, [we have released](https://github.com/algolia) and maintained multiple open-source projects that proved to be successful over time, and I have spent a good amount of time practicing and creating [open-source projects](https://github.com/vvo) too.

## Getting your feet wet

![](https://blog.algolia.com/wp-content/uploads/2017/12/Pastebot-Dragged-Image-21-12-2017-140501-2.png)

A key moment for my career was six years ago at [Fasterize](https://www.fasterize.com/en/) (a website performance accelerator). We faced an important [memory leak](https://en.wikipedia.org/wiki/Memory_leak) on our [Node.js](https://nodejs.org/en/) workers. After searching everywhere except inside the actual Node.js codebase, we found nothing that could cause it. Our workaround was to restart the workers every day (this reset the memory usage to zero) and just live with it, but we knew this was not a very elegant solution and so **I wanted to understand the problem** **as a whole**.

When my co-founder [Stéphane](https://www.linkedin.com/in/stephanerios/) suggested I have a look at the Node.js codebase, I almost laughed. I thought to myself: “If there’s a bug, it’s most probably our code, not the code from the developers who created a revolutionary server-side framework. But, OK, I’ll have a look”. Two days later [my two character fix](https://github.com/nodejs/node-v0.x-archive/pull/3181#issue-4313777) to the http layer of Node.js was merged, and solved our own memory leak.

Doing this was a major confidence boost for me. Amongst the thirty other people who had contributed to the http.js file were folks I admired, like [isaacs](https://github.com/isaacs/) (npm creator)— making me realize that code is just… code, regardless of who wrote it.

Are you experiencing a bug with an open-source project? Dig in and don’t stop at your local workaround. Your solution can benefit others and lead you to more open-source contributions. **Read other people’s code**. You might not fix your issue right away, it might take some time to understand the code base, but you will learn new modules, new syntax and different ways to code that will make you grow as a developer.

## Opportunistic contributions

[![First contributions labels on the the Node.js repository](https://blog.algolia.com/wp-content/uploads/2017/12/image6.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image6.png)_First contributions labels on the the [Node.js repository](https://github.com/nodejs/node/labels/good%20first%20issue)_

“I don’t have an idea” is a common complaint by developers who want to contribute to open-source but think they don’t have any good ideas or good projects to share. Well, to that I say: that’s OK. There are **opportunistic ways to contribute to open-source**. Many projects have started to list good contributions for first-timers via labels or tags.

You can find contribution ideas by going through these websites: [Open Source Friday](https://opensourcefriday.com/), [First Timers Only](http://www.firsttimersonly.com/), [Your First PR](https://yourfirstpr.github.io/), [CodeTriage](https://www.codetriage.com/), [24 Pull Requests](https://24pullrequests.com/), [Up For Grabs](http://up-for-grabs.net/) and [Contributor-ninja](https://contributor.ninja/) (the list comes from [opensource.guide](https://opensource.guide/how-to-contribute/#finding-a-project-to-contribute-to)).

## Build some tooling

Tooling is a nice way to publish something useful to others without having to think too much about complex problems or API design. You could publish a boilerplate for your favorite framework or platform that would gather the knowledge of many blog posts and tools into a nicely explained project, ready with live reload and publishing features. [create-react-app](https://github.com/facebookincubator/create-react-app) is one good example of such tooling.

[![Screenshot of GitHub's search for 58K boilerplate repositories ](https://blog.algolia.com/wp-content/uploads/2017/12/image5-2.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image5-2.png)_There are [58K boilerplate](https://github.com/search?utf8=%E2%9C%93&q=boilerplate&type=) repositories on GitHub, it’s easy and rewarding to publish one_

Today you can also build pure JavaScript plugins for [Atom](https://github.com/blog/2231-building-your-first-atom-plugin) and [Visual Studio Code](https://code.visualstudio.com/docs/extensions/overview) like we did with [our Atom autocomplete module import plugin](https://blog.algolia.com/atom-plugin-install-npm-module/). Is there a very good plugin for Atom or Sublime Text that does not yet exist in your favourite editor? **Go build it**.

Finally, you could also create plugins for [webpack](https://webpack.js.org/contribute/writing-a-plugin/) or [babel](https://github.com/thejameskyle/babel-handbook) that are solving a particular use case of your JavaScript stack.

The good thing is that most platforms will explain **how to create and publish plugins** so you won’t have to think too much about how to do it.

## Be the new maintainer

When browsing through projects on GitHub, you might sometimes find and use **projects that are abandoned by their creator**. They are still valuable, but many issues and pull requests are sitting in the repository without any answer from the maintainer. **What are your options?**

* Publish a fork under a new name
* Be the new maintainer

I recommend you do both at the same time. The former will help you move forward with your project while the latter will benefit you and the community.

How to become the new maintainer, you ask? Drop an email or a tweet to the maintainer and say “Hey, I want to maintain this project, what do you think?”. This usually works well and is a great way to start your open-source career with a project that is already known and useful to others.

[![Example message sent to maintain an abandoned repository](https://blog.algolia.com/wp-content/uploads/2017/12/image2-2.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image2-2.png)

_[Example tweet](https://twitter.com/vvoyer/status/744986995630424064) sent to revive an abandoned project_

## Creating your own projects

The best way to find your own project is to **look at problems that today have no good solutions**. If you find yourself browsing the web for a particular library solving one of your problems and you don’t find it, then that’s the right time to create an open-source library.

Here’s another **key moment** for my own career. At Fasterize we needed a fast and lightweight image lazy loader for our website performance accelerator —not a jQuery plugin but a standalone project that would be injected and must work on any website, on every browser. I spent hours searching the whole web for the perfect already-existing library and I failed at it. So I said: “We’re doomed. I can’t find a good project, we can’t do our startup”.

To this, Stéphane replied: “Well, just create it”. Hmm.. ok then! I started by copy pasting a [StackOverflow answer](https://stackoverflow.com/questions/3228521/stand-alone-lazy-loading-images-no-framework-based) in a JavaScript file and ultimately [built an image lazy loader](https://github.com/vvo/lazyload) that ended up being used on websites like [Flipkart.com](https://en.wikipedia.org/wiki/Flipkart) (~200M visits per month, #9 website in India). After this success, my mind was wired to open-source. I suddenly understood that open-source could be just another part of my developer career, instead of a field that only legends and [mythical 10x programmers](http://antirez.com/news/112) fit into.

[![Stack Overflow screenshot ](https://blog.algolia.com/wp-content/uploads/2017/12/image1-3.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image1-3.png)

_A problem without any good solution: solve it in a reusable way!_

**Timing is important**. If you decide not to build a reusable library but rather inline some workaround code in your own application, then that’s a missed opportunity. At some point, someone will create the project you might have created. Instead, extract and publish reusable modules from your application as soon as possible.

## Publish it, market it and share it

To be sure anyone willing to find your module will indeed find it, you must:

* Create a good [README](https://opensource.guide/starting-a-project/#writing-a-readme) with [badges](https://shields.io/) and vanity metrics
* Create a dedicated website with a nice design and online playground. Want some inspiration? Have a look at [Prettier](https://github.com/prettier/prettier).
* Post your project as answers to StackOverflow and GitHub issues related to the problem you are solving
* Post your project on [HackerNews](https://news.ycombinator.com/submit), [reddit](https://www.reddit.com/r/programming/), [ProductHunt](https://www.producthunt.com/posts/new), [Hashnode](https://hashnode.com/) and any other community-specific aggregation website
* Propose your new project to the newsletters about your platform
* Go to meetups or give talks about your project

[![Screenshot of Hacker News post](https://blog.algolia.com/wp-content/uploads/2017/12/image4-2.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image4-2.png)

_Show your new project to the world_

**Don’t fear posting to many websites**; as long as you truly believe what you have made will be valuable, there is no such thing as too much information. In general, communities are really happy to have something to share!

## Be patient and iterate

In term of “vanity metrics” (number of stars or downloads), some projects will skyrocket on day one but then have their growth stopped very early. Others will wait one year before being ready for HN frontpage. Trust that your project will be at some point noticed by other users, and if it never does, then you have learned something: it’s probably no use to anyone but you — and that is one more learning for your next project.

**I have many projects that have 0 stars** (like [mocha-browse](https://github.com/vvo/mocha-browse)), but I am never disappointed because I don’t have high expectations. That’s how I always think at the beginning of a project: I found a good problem, I solved it the best way I could, maybe some people will use it, maybe not. Not a big deal.

## Two projects for a single solution

This is my favourite part of doing open-source. At Algolia in 2015 we were looking at solutions to unit test and freeze the html output of our [JSX](https://reactjs.org/docs/jsx-in-depth.html) written React components for [InstantSearch.js](https://community.algolia.com/instantsearch.js/), our React UI library.

Since JSX is translated to function calls, our solution at that time was to write expect(<Component />).toDeepEqual(<div><span/></div). That’s just comparing two function calls output.But the output of those calls are complex object trees: when run, it would show “Expected {-type: ‘span’, …}”. The input and output comparison was impossible and developers were getting mad when writing tests.

To solve this problem, we created [algolia/expect-jsx](https://github.com/algolia/expect-jsx) that allowed us to have JSX string diffs in our unit tests output instead of unreadable object trees. Input and output of the test would be using the same semantics. We did not stop there. Instead of publishing one library, we extracted another one out of it and published two libraries:

* [algolia/react-element-to-jsx-string](https://github.com/algolia/react-element-to-jsx-string) transforms JSX function calls back to JSX strings
* [algolia/expect-jsx](https://github.com/algolia/expect-jsx) does the linking between react-element-to-jsx-string and [mjackson/expect](https://github.com/mjackson/expect), the expectation library

By publishing two modules that are tackling one problem together, you can make the community benefit from your low-level solutions that can be reused on a lot of different projects, even in ways you never thought your module would be used.

For example, react-element-to-jsx-string is used in a lot of other [test expectations frameworks](https://www.npmjs.com/browse/depended/react-element-to-jsx-string) along with being used on documentation plugins like [storybooks/addon-jsx](https://github.com/storybooks/addon-jsx).Today, to test the output of your React components, use [Jest and snapshots testing](http://facebook.github.io/jest/docs/en/snapshot-testing.html#snapshot-testing-with-jest), there’s no more the need for expect-jsx in those situations.

## Feedback and contributions

[![A fake issue screenshot](https://blog.algolia.com/wp-content/uploads/2017/12/image3-2.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image3-2.png)

_That’s a lot of issues. Also, it’s faked just to have a nice picture 🙂_

Once you start getting feedback and contributions, be prepared to be open-minded and optimistic. You will get enthusiastic feedback, but also negative comments. Remember that any interaction with a user is a contribution, even when it seems like just complaining.

For one thing, it is never easy to convey intentions/tone in written conversations. You could be interpreting “This is strange…” as: it’s awesome/it’s really bad/I don’t understand/I am happy/I am sad. Ask for more details and try to rephrase the issue to better understand where it’s coming from.

A few tips to avoid genuine complaints:

* To better guide users giving feedback, provide them with an [ISSUE_TEMPLATE](https://github.com/blog/2111-issue-and-pull-request-templates) that is displayed when they create a new issue.
* Try to reduce the friction for new contributors to a minimum.Keep in mind that they may not yet be into testing and would gladly learn from you. Don’t hold Pull Requests for new contributors because there’s a missing semicolon;, help them feel safe. You can gently ask them to add them, and if that doesn’t work, you can also merge as-is and then write the tests and documentation yourself.
* Provide a good developer experience environment in terms of automated tests, [linting](https://stackoverflow.com/questions/8503559/what-is-linting) and formatting code or livereload examples.

## That’s it

Thanks for reading, I hope you liked this article to the point where you want to help or build projects. Contributing to open-source is a great way to expand your skillset, it’s not a mandatory experience for every developer, but a good opportunity to get out of your comfort zone.

I am now looking forward to your first or next open-source project, tweet it to me [@vvoyer](https://twitter.com/vvoyer) and I’ll be happy to give you advice.

If you love open-source and would like to practice it in a company instead than doing it on your free time, Algolia has open positions for [open-source JavaScript developers.](https://www.algolia.com/careers#60c7c780-1009-4030-8e44-f653fa2ebd36)

Other resources you might like:

* [opensource.guide](https://opensource.guide/), Learn how to launch and grow your project.
* [Octobox](https://octobox.io/), your GitHub notifications as an email. Awesome way to avoid the “too many issues” effect by focusing on the ones that matter
* [Probot](https://probot.github.io/), GitHub Apps to automate and improve your workflow like closing very old issues
* [Refined GitHub](https://github.com/sindresorhus/refined-github) provides an awesome maintainer experience for GitHub UI at many levels
* [OctoLinker](http://octolinker.github.io/) makes browsing other people’s code on GitHub a great experience

Thanks to [Ivana](https://twitter.com/voiceofivana), [Tiphaine](https://www.linkedin.com/in/tiphaine-gillet-01a3735b/), [Adrien](https://twitter.com/adrienjoly), [Josh](https://twitter.com/dzello), [Peter](https://twitter.com/codeharmonics) and [Raymond](https://twitter.com/rayrutjes) for their help, review and contributions on this blog post.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
