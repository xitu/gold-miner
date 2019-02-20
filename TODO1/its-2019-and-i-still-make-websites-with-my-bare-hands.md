> * 原文地址：[It’s 2019 and I Still Make Websites with my Bare Hands](https://medium.com/@mattholt/its-2019-and-i-still-make-websites-with-my-bare-hands-73d4eec6b7)
> * 原文作者：[Matt Holt](https://medium.com/@mattholt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/its-2019-and-i-still-make-websites-with-my-bare-hands.md](https://github.com/xitu/gold-miner/blob/master/TODO1/its-2019-and-i-still-make-websites-with-my-bare-hands.md)
> * 译者：
> * 校对者：

# It’s 2019 and I Still Make Websites with my Bare Hands

I have no idea how to make a website the way the cool kids do today.

All I know is that our frontend team spent about a day laying the foundation for our new website, and the next day my `git pull` landed this thing (after a post-merge hook):

![](https://cdn-images-1.medium.com/max/1200/1*9YY47IfhbjQnKxW0AgKqWw.png)

![](https://cdn-images-1.medium.com/max/1200/1*Ppd2YF0XThfea1HJV-Jt8Q.png)

(Had to kill the first size calculation since it was spinning my CPU.)

It literally says _Hello world_ but I’m told it has the **potential** to do so much more! I think they said it could even make me toast… [toasts](https://material.angularjs.org/latest/demo/toast).

The only things most web devs— even the not-computer-science ones — can talk about when it comes to their own websites are things that I imagine _must_ be frameworks or hosted services (because I don’t know what the words are but they weren’t in my CS classes) and frankly, they sound _amazing_. I compare what they’re describing to what I’m doing and I feel really, really, inadequate. They’re learning the hottest stuff at coding schools like DevMountain or the latest online courses.

![](https://cdn-images-1.medium.com/max/1200/1*jRlmvu9hgYO-uEIMmEyBag.png)

Anyway, I would just say I’m “old school” but I’ve only been doing web development for like 10 years.

**counts on fingers**

…Okay, 19 years. Like when the `<FONT>` tag [was still the right way](https://www.amazon.com/Teach-Yourself-HTML-VISUALLY-Visually/dp/0764534238). (← link to fun book that taught me HTML, when I was… 11?)

So then, get this: some of these same people ask me for help, because they found out I’ve been doing webdev for years. Next thing I know, I have no idea what is going on, so I’m googling two-way data binding in React, or dynamic variable workarounds in SCSS, or whatever else, and landing on the exact same pages that my friends _should_ be on instead, because _they_ would actually know the answer when they see it, and all I can do is “how about this?” and yet somehow they don’t find the same answers I did.

Sooner or later, because I’m totally clueless about this or that framework, I have to start asking them questions: “Well, wait — what does that do?” _pointing to something that I think is a function call. … erm, nope, it’s a type definition… okaaay awkward!_ And their answer is usually unsatisfactory (shallow), so I drill down more in an effort to help them debug their app:

> “But how does this part work? Like, what is it actually doing?” I ask.

> I usually get blank stares. They almost never know.

So here I am, it’s 2019, I’ve been writing code for almost 20 years, and I’m surrounded by people making 2–10 times as much money as I am (graduate student _lyfe_) and they can’t explain how their own craftsmanship works. I get it, though: it’s not their own craftsmanship. I can’t really explain how my car works, but I still use it every day.

I just… how… **how can you stand building applications without knowing how they work?**

Why are over 500 MB of files needed to write a web app that shows a few lists of things and makes some AJAX requests? (Yes I still call them that. I’ll call them XHR too, even though XML is way passé.)

Why do so many sites break my back button or my scrolling? Like, _you have to go out of your way_ to do that.

Why does it take 10x longer to compile a web app with 5 routes than it does to **_cross_**_-_**_compile_** my 25,000 LoC Go program?

### How Papa Parse got fat

Back in 2013, I wrote a CSV parser on a flight to Disneyland. I needed a fast, correct CSV parser for the browser, and none existed that met my needs. So I wrote what became [Papa Parse](https://www.papaparse.com/), now used by an impressive list of clients — from the United Nations to companies and organizations far and wide, even Wikipedia — I’m proud of it (not-so-humble brag: it’s arguably [the #1 CSV parser](https://mwholt.blogspot.com/2014/11/papa-parse-4-fastest-csv-parser.html) for JavaScript). In the beginning, it was a simple, happy library that worked great.

Then came requests to have it work on old browsers, so we added shims. Hm. Okay.

Then came the requests for using it with Node.

And then, not just requests — but _bug reports — _that it didn’t work with `<insert JavaScript framework here>`. It became maddening: adding support for one framework or toolchain broke another. Papa Parse grew from a few hundred lines of code to a few thousand. **That’s an order of magnitude.** From one file, to about a dozen. From no builds needed, to about 3 or 4 build systems and packaging distributions.

All for the luxury of `Papa.parse("csv,file")` in the browser.

I eventually gave up maintainership to others in the community. They’ve been doing a good job. It just got far beyond what I cared to support. Before that, I was happy in my own little world with my little library just the way it was. But now, although Papa Parse is still a great library, I just have no idea what it’s actually doing anymore.

(I still love and recommend Papa Parse, by the way, for all your JavaScript CSV parsing needs.)

### How I (still) make my websites

I don’t consider myself a web designer or even a web developer, but I’ll make a website if I have to (and I do quite often — enough so that I wrote an entire web server, [Caddy](https://caddyserver.com), to make this process faster).

I’m not even kidding, this is how I still make websites:

I open a text editor, and stub this out (by hand, it only takes like 30 seconds — I’ll even do it as I write this post to be authentic — except stinkin’ tab doesn’t work here):

```
<!DOCTYPE html>
<html>
  <head>
    <title>I code stuff with my bare hands</title>
    <meta charset="utf-8">
  </head>
  <body>
     Hi there
  </body>
</html>
```

Then I open a new tab and make a CSS file; something like this:

```
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
  font-size: 18px;
  color: #333;
}

p {
  line-height: 1.4em;
}
```

And what about JavaScript? I use it, of course. But… like… just the parts of it I understand. I have a lot to learn, especially when it comes to ES6 and new APIs like fetch, and… I still use jQuery for some things ([emphasis on _some_](http://youmightnotneedjquery.com/)) — it makes certain tasks, like manipulating multiple elements in the DOM, very straightforward, and it’s mostly boilerplate code I would just accrue and copy and paste from project to project anyway. No dependency hell here.

Anyway, I only put JS where it’s needed. I’ll pull in the occasional vanilla-JS-based library once in a while, for example, something like Papa Parse for [**advanced, high-performance CSV parsing needs**](https://www.youtube.com/watch?v=EX69fn2Wi9A). (← links to UtahJS video where I talk about the amazing quirks of pushing browsers to their limits.)

Most of the time, there’s nothing wrong with traditional form POSTs or page navigations. I do turn form POSTs into AJAX requests pretty often, but there’s hardly ever a need to change the URL (_any_ of it).

Then I save the files, run `caddy` in my project folder, and open my browser. I refresh every time I make changes. After 10+ years, I finally got a second monitor so I don’t have to keep switching windows.

JavaScript isn’t the only technology I’m stingy on: it’s CSS, SVG, Markdown, and static site generators, too. I almost never use CSS libraries. I only held out on a few hacks while we waited for CSS 3 and for new features like flexbox and grid. But that’s all here now. SVG is still a WIP as far as browser support goes, and Markdown… well… I’d almost rather write HTML/CSS because at least that’s the same pretty much everywhere.

I like the idea of static site generators, but they’re usually more complex than is necessary. Most of the time, all I need is a way to include snippets of code in my HTML document, and Caddy does that with a simple template action: `{{.Include "/includes/header.html"}}`. (I can even use [**git push**](https://caddyserver.com/docs/http.git) to deploy my site with Caddy, no static site generator needed! Although it does support those.)

### Benefits

Not using fancy, general-purpose or overly-featureful libraries, frameworks, and tooling makes:

*   the website code base smaller,
*   managing your dev environment easier,
*   debugging faster and more universally solvable
*   your web server configuration simpler (believe me, _I_ _know_)
*   your web sites load faster,

and it saves you GBs of hard drive space!

### Tradeoffs

Well, since I don’t know React, Angular, Polymer, Vue, Ember, Meteor, Electron, Bootstrap, Docker, Kubernetes, Node, Redux, Meteor, Babel, Bower, Firebase, Laravel, Grunt, etc., I can’t really help my friends or impress them with my answers, OR satisfy many of today’s web development job requirements.

Technically, though, there’s not a whole lot I **can’t** do — that’s the thing! I bring in tools when I _really_ need them, otherwise I opt to just write it myself or paste something small from Stack Overflow (if I’m being honest). (Pro tip: Unlike YouTube or HN, **_always read the comments on Stack Overflow_.**) (And definitely understand the code that you’re borrowing!)

Does my development productivity suffer?

Maybe. But… nah, I don’t really think so.

### Results

Here are a few sites that I’ve made using my bare hands — and believe me, if I had resources to hire professional front-end developers, I would rather just do that — but all these sites have no frameworks, no unnecessary or unwieldy dependencies.

I don’t even minify page assets (except image compression, which is just a drag-and-drop onto [tinypng.com](https://tinypng.com)), mostly because I’m lazy. But you know what? Page load times are still pretty fantastic.

All of these sample sites have features that could be considered “web application” but I think the most involved it gets in the code is some hairy jQuery (and that’s just because I was in a hurry).

![](https://cdn-images-1.medium.com/max/2000/1*zziUiqYBKpwkEYi8-gPM5w.png)

![](https://cdn-images-1.medium.com/max/1600/1*Ox4fKq-xvS9STRyuVUSHKg.png)

![](https://cdn-images-1.medium.com/max/800/1*mnhVan8aVQp2Rb1iM8OFhA.png)

![](https://cdn-images-1.medium.com/max/1200/1*V9M0Pmy_ZsyXQBM11i0o-w.png)

![](https://cdn-images-1.medium.com/max/1200/1*yckUvqs6ByWudzJ_rBGCcA.png)

Links to the sites:

*   [https://caddyserver.com](https://caddyserver.com)
*   [http://goconvey.co/](http://goconvey.co/)
*   [https://www.papaparse.com](https://www.papaparse.com)
*   [https://relicabackup.com](https://relicabackup.com) _(shameless plug: 50% off sale happening right now!)_

Each site probably took me anywhere from a day to about a week to flush out fully (depending on how many pages and how much financial incentive there was). The actual content, of course, can take longer, but that’s a given.

Here’s just some of the feedback I’ve received, which is a result of the “classic” approach:

*   I love the simplicity of your website design. Did you make it yourself, or use a template/theme?
*   Your website is an example of what good web design should look like. It’s fast, clean, doesn’t load extraneous crap and almost all of it works without JavaScript.
*   I’m curious what framework or tool you used to build your documentation site! It’s very nice and clean.

I’m not saying my sites are perfect — they’re far from it, and I cringe using them as case studies — but they get the job done.

Bonus: here’s a fun little API demo I did in vanilla HTML, CSS, and JS just a few years ago for my old job:

* Youtube 视频链接：https://youtu.be/7T97vf-lrXk

I understood what every single line of code did, and the whole thing probably weighed in at under 50 KB of code, including minified jQuery (uncompressed). Obviously, displaying the map tiles used another dependency (Leaflet), but things like that are reasonable when they are needed. For example, if you’re doing complex time-related computations and time rendering, it’s OK to import Moment.js. I just try to avoid _general-purpose_ frameworks, libraries, and tooling, unless I really need them and/or understand what they’re doing.

### My process

I’ve had several requests now to write up my process for making websites and this article is the best I could come up with. Maybe it’s more of a rant, **but my process is really quite simple and hard to explain, because… there _is_ no process.**

Except for the minimum requirements (a text editor and a local web server), my “process” doesn’t need any special tooling: no compiling, no installation steps, no package management. It’s just me, my text editor, my web server, and understanding the basics of how websites work.

### The point

I’m by no means an expert. Web development takes years and years of practice for true mastery, even without fancy tooling.

I believe that with time, one can acquire all the skills and knowledge needed to do the things the cool kids are doing at a comparable speed, but with the advantages of:

*   a vastly smaller code base;
*   fewer bugs;
*   better intuition;
*   shorter, more efficient, debugging sessions;
*   higher knowledge transfer;
*   and more flexible, future-proof software architecture;

all by consuming _only what you need_.

That is a cure for technical debt, right there.

(Hmm, maybe more like a vaccine.)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
