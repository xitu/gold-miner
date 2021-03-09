> * 原文地址：[10 Years of Open-Source Visualization](https://observablehq.com/@mbostock/10-years-of-open-source-visualization)
> * 原文作者：[Mike Bostock](https://observablehq.com/@mbostock)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/10-years-of-open-source-visualization.md](https://github.com/xitu/gold-miner/blob/master/article/2021/10-years-of-open-source-visualization.md)
> * 译者：
> * 校对者：

# 10 Years of Open-Source Visualization

> Did I learn anything from D3.js? Let's see...

In honor of [D3 1.0](https://github.com/d3/d3/releases/tag/v1.0.0)'s tin anniversary, I thought I'd reflect on lessons learned. This isn't intended to be too comprehensive or serious --- just a handful of observations as I look ahead to the *next* ten years. But I hope a nugget or two will interest you, too.

## 1. Teaching is the most impactful aspect of tool building.

When building a tool, it's easy to forget how much you've internalized: how much knowledge and context you've assumed. Your tool can feel familiar or even obvious to you while being utterly foreign to everyone else. If your goal is for other people to use the darn thing --- meaning you're not just building for yourself, or tinkering for its own sake (which are totally valid reasons) --- you gotta help people use it! It doesn't matter what's possible or what you intended; all that matters is whether people actually succeed in practice.

To maximize your impact, then, teaching must be central to your strategy. This means documentation, tutorials, examples, videos, tweets, and more. Teaching one-on-one or in workshops is a great way to force your internalized knowledge to the surface, to find common ground with your audience, to be inspired by their work, and to learn how to teach more effectively (see #2), but a library of material that teaches without requiring your time is the only way to scale as your audience grows. You need the pedagogical equivalent of passive income, if you will. A one-day workshop can help a hundred people; a tutorial can help tens of thousands or more. I'm frequently inspired by (and occasionally envious of) the brilliant teaching styles of [Rich Harris](https://twitter.com/Rich_Harris) and [Dan Abramov](https://overreacted.io/).

Of all forms of documentation, examples seem to be the most effective. I've long espoused [the merits of examples](https://bost.ocks.org/mike/example/), and both Observable and its predecessor bl.ocks.org aim to help people produce and consume examples to accelerate learning. Examples inspire by showing what's possible; examples demonstrate specific techniques; and examples are building blocks which help people get started. Given how humans excel at pattern-matching and extrapolating from observation, it seems only natural that examples are the preferred form of learning material.

Yet perhaps examples are *too* powerful: they can compensate for a hard-to-use API and foster a dependency on copy-paste. Was D3 successful not because it was a great tool, but because it came with so many examples? 🤷‍♂️ Even though I'm the author, I can't remember how to use d3.stack and copy-paste the [stacked area example](https://observablehq.com/@d3/tidy-stacked-area-chart) like everyone else. Examples may help people succeed regardless of a tool's flaws, but it's better to strive for fluency: when people internalize how a tool works and create from scratch. Working backwards from an example rather than forwards from data can also be a mistake for visualization (see #5). And examples have limitations: an example teaching a specific technique may not be broadly representative of "real-world" usage.

## 2. Support is a powerful means of research.

The only way to recognize --- and then bridge --- the gulf of understanding between you and people using your tool is to observe their struggles and talk to them. It's amazing how quickly glaring flaws are revealed this way. Answering questions on Stack Overflow (or GitHub, Twitter, Slack, or wherever else) is not a selfless act of altruism; it's a chance to learn, to find where people struggle and hear their perspective. Each question is an opportunity to help one individual, but that question can also inspire a tutorial, an example, or even a feature that prevents others from hitting the same issue. That's the hidden advantage that allows successful tools to compound their success: the countless ideas and criticisms from users that can be channeled into improvements and documentation by maintainers. Ideas aren't formed in a vacuum.

But there's also a limit. As one person, you can't help everyone. And you can't make everyone happy because your tool is only a tiny part of their life. Don't make that your goal: focus on learning and broadening your perspective. If it stops being constructive *for you*, then stop. Period. And don't feel bad! I have deep reservations about the way GitHub and other platforms enable issues by default, establishing the unreasonable expectation that unpaid maintainers must immediately, politely, and substantively respond to any and all requests for help. Yes, I can turn off issues, but as a community we need to rethink our norms if we are serious about addressing maintainer burnout.

## 3. Beware bells and whistles: interaction, animation, and other technical whizbangery have a cost. 🧙‍♂️

There *is* a place for these things, but hear me out. Interaction and animation have a huge wow factor, especially for audiences who encounter them infrequently. Knowing this, you may be tempted to add these features to visualizations without fully appreciating the downsides, such as added complexity and hiding valuable information behind interactive controls. And worse, because these features are often challenging to implement, they may distract from the far more important yet "boring" task of finding and communicating insight!

This is not a moral judgment. I'm not saying you're bad for doing this. I'm guilty of this myself. But the pitfall is real. Focus on the static form first and foremost. This may be the only thing some readers see. Don't allow technical matters (*i.e.*, web development) to eat too much of your attention. And don't fear plain visualizations: it's the insight that matters, not whether it's gussied up.

So where *should* interaction be used? Primarily exploratory visualization (see #4). Gregor Aisch's ["In Defense of Interactive Graphics"](https://www.vis4.net/blog/2017/03/in-defense-of-interactive-graphics/) is a good post on the subject.

## 4. Visualization is a spectrum: from exploratory to explanatory.

Not all visualizations serve the same purpose. *Exploratory* graphics you make for yourself to find new insights in data. *Explanatory* graphics in contrast communicate some already-known insight to an audience. When designing, know where you are on the spectrum.

The goal of exploratory visualization is primarily speed: how quickly can you construct a view that answers your question? You can afford to cut corners when you're the intended reader as you already have context. Whereas you must provide explicit context for an explanatory graphic. A good explanatory graphic should know what it's trying to say *and say it*. Explanatory graphics can include exploratory elements, for example allowing the reader to "see themselves" in the data, but ideally these shouldn't detract from the primary message. Don't make the reader work for insight; that's your job as editor.

## 5. In most cases, working with data should be 80% of the work of visualization.

Visualization is the end result of analysis --- the visible manifestation of data, to be seen, shared, and appreciated by experts and non-experts alike --- and as such it sometimes gets too much credit. To produce a visualization, one must first find data, clean it, transform, join, model, *etc.* Working with data is sometimes needlessly denigrated as ["janitorial"](https://www.nytimes.com/2014/08/18/technology/for-big-data-scientists-hurdle-to-insights-is-janitor-work.html) when it represents the critical step of understanding the data as it is, warts and all. (See [Leigh Dodds' post](https://blog.ldodds.com/2020/01/31/do-data-scientists-spend-80-of-their-time-cleaning-data-turns-out-no/) on the subject.) With data in the right form, the process of applying visual encodings may be comparatively straightforward (assuming you heed #3). Hence the D3 modules that I reach for most are [d3-array](https://github.com/d3/d3-array) and [d3-dsv](https://github.com/d3/d3-dsv). And I'm delighted to see new JavaScript tools for data such as [tidy.js](https://pbeshai.github.io/tidy/) and [Arquero](https://uwdata.github.io/arquero/). Hadley Wickham's ["tidy data"](https://vita.had.co.nz/papers/tidy-data.pdf) paradigm is invaluable.

## 6. Don't commit to a specific visual form before seeing your data in it.

A given visual form --- say the pie chart or treemap --- isn't "good" or "bad" in an absolute sense, but it may or may not be appropriate to your data and the specific question you want answered. The only way to know whether a form is effective is if it communicates: you must put your data in it and see. So don't set out to use a specific form; instead set out to answer a specific question of your data.

If it's hard to get your data into an example (see #1), you are incented to commit to a specific form before you can confirm its effectiveness. The less effort it takes to sketch a visualization, the more variations you can afford to try and the better the final result. This is why Observable tries to help you get your data in quickly, say replacing a file with one click, or letting you edit code without forking it. Yet if your data has an incompatible structure, it might still be a lot of work (see #5). And D3, being designed for bespoke explanatory graphics, requires more effort than something like [Vega-Lite](https://vega.github.io/vega-lite/) which is intended for exploratory graphics; you want low [notational viscosity](https://en.wikipedia.org/wiki/Cognitive_dimensions_of_notations) to try multiple forms quickly and see what works. We're working on making it easier to sketch visualizations in Observable, and I hope to share something soon. Stay tuned.

## 7. 10% of code causes 90% of bugs.

I made up these numbers, but it feels right: some code is far more bug-prone than other code. That's not because the buggy code is somehow lower quality but because it's trying to do something inherently harder or underspecified. For D3, the interactive behaviors are the big losers (winners?) in the bug contest: d3-zoom, d3-drag, and d3-brush. It's hard to reason through, let alone test, all possible sequences of asynchronous events. And interaction is ambiguous: are you clicking? dragging? panning? selecting? about to double-click? Compounding the challenge, browsers change and unilaterally "break the web" as Chrome did with [passive event listeners](https://developers.google.com/web/updates/2017/01/scrolling-intervention).

This suggests you may be able to save yourself some trouble by chosing carefully which problems you try to solve and which you don't. For example, if you can build your interface using Observable's [inputs](https://observablehq.com/@observablehq/inputs) and [dataflow](https://observablehq.com/@observablehq/how-observable-runs) rather than low-level event listeners, you'll have less to worry about.

## 8. The internet will make you feel bad.

No matter how good your work is, if you put yourself out there someone on the internet *will* say something hurtful and make you feel bad. It's often not intentional, not that it matters. I am very proud of D3 but I maintain a collection of mean tweets people have shared about it. This is my process; don't judge me. (And no, I'm not sharing the list.)

I hold no ill will against people for getting frustrated. I completely understand the feeling of helplessness a tool may inflict --- you just wanted a little chart, but now you're being asked to learn a million other things. A tool's design can appear so arbitrary and backwards. The problem is the internet. In the past you'd complain to friends or coworkers about how bad D3 is, and maybe they'd help you get over the hump or they'd know you were venting. But with the internet I hear it, now, too. And I don't know you. And it's discouraging. If my motivation for building a tool is to share the joy of people succeeding with it, and now I'm seeing pain and frustration, why would I keep building? Why would I subject myself to beratement and negativity when I could just watch YouTube?

So if you find yourself complaining on the internet, please think about the practical impact of your words. If it'll only discourage and contribute to burnout, maybe vent offline? Or better: think about how you can personally contribute to make the tool better, either through pull requests or documentation or support. That, after all, is the beauty of open source.

## 9. Don't go it alone.

To avoid entrusting your emotional wellbeing to internet randos (see #8), you must develop relationships with a small, stable group of people that you respect. In other words, find a team (or community) that can provide validation, feedback, support, and mentorship. Maybe this is obvious to everyone but me --- *yes, Mike, friends are good* --- but I feel like it's worth repeating today when so much human interaction happens at a distance. I'm also excited about the potential for Observable to create shared virtual spaces for collaboration, where it's not about showing off (as on Twitter) but about working together with peers in realtime to find insight and solve problems.

## 10. Try to have a good time.

I originally wrote "take it easy" but that feels disingenuous. I'm probably the last person to take it easy. I *wish* I could take it easy. This is personal, but I try to reflect on which parts of my life and work I enjoy and spend more time doing that. It sounds simple and trite but it's hard to do in practice! If you know what you enjoy then you will have fewer regrets when and if you do fail (always an option). And paradoxically, rather than detracting from your goals it may help you succeed as you are better able to persevere: work you enjoy is more easily sustained. I love building tools. I can't predict if they will succeed, but I love solving puzzles and developing abstractions, and I love seeing what people do with my creations. On the other hand I find public speaking anxiety-inducing, even knowing the positive impact talks can have and how good I'll feel *after* the talk. So if you're disappointed I'm not giving more talks, hopefully it's because I'm heads-down building something new. 😅

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
