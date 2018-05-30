> * 原文地址：[Why is Front-End Development So Unstable?](http://www.breck-mckye.com/blog/2018/05/why-is-front-end-development-so-unstable/)
> * 原文作者：[Jimmy Breck-McKye](http://www.breck-mckye.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-is-front-end-development-so-unstable.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-is-front-end-development-so-unstable.md)
> * 译者：
> * 校对者：

# Why is Front-End Development So Unstable?

We all know the meme: by the time you’ve learned one front-end technology, another three have just been released. Also, that one you just learned? It’s deprecated.

What we don’t often see is an examination why.

The typical explanation (a la `r/programming`) seems to be something or other about webdevs being naturally impatient, faddish and incompetent, which may constitute a more general fallacy: assuming behaviour you cannot understand is caused by an entire group being foolish, wicked or greedy (whereas your own unwise behaviour is due exclusively to factors beyond your control).

Still, fallacy or no, we do have a problem - don’t we?

### Quantifying the issue

Before we get carried away, it’s worth validating whether the meme really has basis in reality. Do front end technologies actually change that quickly?

In the sense of major view technologies, probably not. Consider this list of the highest ‘starred’ JavaScript front-end technologies on [Github](https://github.com/collections/front-end-javascript-frameworks):

```
+------------------------------------------------------------+
| Library          | Stars   | Released       | Age          |
|------------------------------------------------------------+
| React            | 96986   | March 2015     | 3 years      |
| Vue              | 95727   | October 2015   | 2.5 years    |
| Angular (1)      | 58531   | October 2010   | 7.5 years    |
| jQuery           | 49061   | August 2006    | 11 years     |
| Angular (2+)     | 36665   | December 2015  | 2.5 years    |
| Backbone         | 27194   | October 2010   | 7.5 years    |
| Polymer          | 19668   | May 2015       | 3 years      |
| Ember            | 19003   | December 2011  | 6.5 years    |
| Aurelia          | 10506   | June 2016      | 2 years      |
| Knockout         | 8894    | July 2010      | 8 years      |
+------------------------------------------------------------+
```

2.5 years for the youngest isn’t _that_ old in the scheme of things - it’s less than half the support lifespan of your typical desktop OS, for example - but it’s still a ways off our caricature. So what is causing this perception of rapid, even unsustainable change?

### React and friends

It might be React. As powerful a tool as it is, it requires an army of helper modules and support libraries to be used seriously, and this is where the problem sets in. The React community is very big on what I would call the ‘microlibrary architecture’, where applications are composed of a myriad discrete, single-purpose JavaScript libraries, in homage to the [Unix philosophy](https://homepage.cs.uri.edu/~thenry/resources/unix_art/ch01s06.html).

The advantage of this architecture is that you can easily adapt as new practices emerge, which makes sense at a time of rapid innovation (like the past few years). The disadvantage is that it increases your surface area for breaking changes and demands a great deal (often too much) vetting and selection of said microlibs.

And this is the thrust of my argument: what’s wrong with JavaScript isn’t the language [1], the web, or any technology in particular, but a poor ‘choice architecture’ that makes developers slaves to fads and trends.

### The NPM problem

Modern JavaScript’s greatest asset - and liability - is NPM. It provides an enormous wealth of modules, catering to just about any specific purpose one can conceive, but very difficult to filter and curate. Which ones are really being supported? Which ones are actually functionally correct? Which ones aren’t really just vectors for evil malware? The only heuristic a JavaScript developer can really use is popularity - number of downloads and Github stars - which exacerbates faddishness.

There are other ways to validate a library, of course: you can read through Github issues and search for StackOverflow questions. You can do some testing or even examine the sourcecode for yourself (in most cases). But this takes time, which isn’t really warranted when choosing e.g. a date parsing doodad.

I will concede that this is something of a cultural weakness of JavaScript developers. As an interviewer I often like to ask candidates how they choose technologies, and it depresses me somewhat that popularity is the almost always the only marker they know. Software engineering is at least partly a research job and we need to train junior programmers research skills. But even if we did, the odds would still be stacked against them.

### Imagine being a junior developer

Put yourself in the shoes of a junior-to-mid-level JavaScript developer, writing a new application for the first time.

It starts innocently enough. You have a completely clean slate and want to keep things simple. You are a devout Agilist and YAGNI is your watchword. So you begin with a ‘simple, barbones framework’. That sounds good, doesn’t it? (Even if it did not, that’s often the only choice you’ve got).

Being barebones it does little, so the task falls on your shoulders to choose some helper libraries. If you are doing frontend work, it might be helpers for Redux for forms and API requests. If backend, it might be middlewares for Express [2].

So you do a Google search, which reveals a Medium post that heartily recommends _X.js_. It later transpires the post was written by _X’s_ author, though she never announces that particular conflict of interest (she does, however, provide a GitTip jar). Not that you could tell - all Medium articles look the same, so you can never rely on a ‘brand’ to identify reputable material.

You miss the replies pointing out some critical inadequacies in _X.js_, because Medium deliberately suppresses them, and move on to finding a _Y_.

This time you find a link on Twitter - with over a hundred hearts! You guess that’s a pretty good signal it’s been “curated” by a community more knowledgeable than yourself. You add a heart of your own in gratitude (like the hundred before) and follow the link to Github.

But not so fast. That link was old - the library is now deprecated. You can tell because the word `DEPRECATED` is slapped everywhere like `CONDEMNED` signs on a Scooby Doo themepark.

You see, _Y.js_ was “object oriented”. You thought this was a good thing, vaguely recalling something from first year ComSci about Smalltalk and message passing. But apparently it is Very Bad.

Another Medium article tries to explain why, though its reasoning is hazy and packed in dense terminology you don’t recognise. It later turns out the terminology was invented by the post’s author, as were the neutral-looking external blog posts he cited as authorities to his argument.

It gets worse. The post claims that even mentioning OOP in a JavaScript interview will render you utterly unemployable! You are seriously disoriented now. Thankfully help is at hand - in the form of his $50 dollar JavaScript webdev course. You take a note of the link, thinking how lucky you are to have found it, and give another clap in gratitude. (Nineteen thousand and one).

So you move onto _Z.js_, which seems to have a lot more Github stars, though the documentation seems less useful. Lots of methods are listed, but how do I practically use it? You are heartened at least to see it uses something called ‘Standard JS’, which you assume has something to do with the ECMA Standards Committee. It doesn’t.

But how could you do better, Junior Developer? Who was there to guide you? The Senior Developers, too, are learning as they go. We’re caught in this avalanche too, just trying to keep up to date and remain employable.

So. You take the path of least resistance: you choose the Github project with the most votes, the most stars. And **that** is why JavaScript dev is driven by fads and hype.

### What is to be done?

Like most natural complainers I am generally better at moaning about problems than, y’know, SOLVING them. But I have a few ideas:

### Be wary of Medium

Medium incentivises clickbait somewhat and makes it harder to distinguish authoritative content. Classical blogging allows good authors to establish a distinct visual theme, which helps visitors recognise a source that’s helped them before.

### Be wary of self-promotion

Over the last few years I’ve seen much more aggressive self-marketing in the JavaScript world, possibly due to the rise of paid online training materials and the employment/consulting advantage of being a Github ‘celebrity’. I’ve no problem with people being incentivised for good content, but increasingly I feel I see dishonest tactics: self-citation; invented, proprietary terminology (so searching takes you back to the author’s materials), and name-squatting (e.g. ‘Standard.js’)

### Consider non-microlib architectures

Try to start your projects in frameworks that provide a large surface area of features and don’t require many plugins to get productive - this will immediately reduce the number of moving parts and exposure to unexpected, breaking change. It’s one reason I’m very interested in [Vue.js](https://vuejs.org/). You could also use React as part of a starter kit or larger framework, like [Next](https://github.com/zeit/next.js/).

### Don’t over-sweat the employablity thing

The only people who need to know a company’s whole stack inside and out on day zero are freelance contractors, who are paid a handsome wage to parachute in and get a project out the door. Otherwise, most employers are absolutely fine with you not knowing the ins and outs of the latest React helper library. So avoid the call to learn absolutely everything: most of it noise.

### Notes[]

[1] Though it has many, many faults.

[2] Can you believe Express requires a middleware just to parse JSON POST bodies? Sorry, but that is utterly bananas.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
