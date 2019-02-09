> * 原文地址：[Designing for the web ought to mean making HTML and CSS](https://m.signalvnoise.com/designing-for-the-web-ought-to-mean-making-html-and-css/)
> * 原文作者：[DHH](https://m.signalvnoise.com/author/dhh/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/designing-for-the-web-ought-to-mean-making-html-and-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/designing-for-the-web-ought-to-mean-making-html-and-css.md)
> * 译者：
> * 校对者：

# Designing for the web ought to mean making HTML and CSS

During the dotcom boom back in the late 90s, I did a bunch of Photoshop-cut jobs. You know, where a designer throws a PSD file over the wall to an HTML monkey to slice and dice. It was miserable.

These mock designs almost always focused on pixel perfectness, which meant trying to bend and twist the web to make it so. Spacer pixels, remember those? We were trying to make the raw materials of the web, particularly HTML, then latter CSS, do things they didn’t want to do. Things they weren’t meant to do.

Then I got the pleasure of working with designers who actually knew HTML and CSS. It was a revelation. Not only would the designs feel like they were _of the web_, not merely _put on the web_, but they’d always be better. Less about what it looked like, more about what it worked like.

I attribute this in no small part to the fact that it was real. The feedback loop of working with the actual HTML/CSS, as it was destined to be deployed, gave designers the feedback from the real world to make it better. And the fact that designers had the power to do the work themselves meant that the feedback loop was shorter. It wasn’t make a change, ask someone else to implement the change, ponder its effectiveness, and then repeat. It was change, check, change, repeat.

For a while that felt like it was almost the norm. That web designers confined to the illusions of Photoshop mocks were becoming more rare. And that web designers were getting better at working with their materials.

But as [The Great Divide](https://css-tricks.com/the-great-divide/) points out, regression is lurking, because the industry is making it too hard to work directly with the web. The towering demands inherent in certain ways of working with JavaScript are rightfully scaring some designers off from implementing their ideas at all. That’s a travesty.

At Basecamp, web designers all do HTML, CSS, and frequently the first-pass implementations of the necessary JavaScript and Rails code as well! It means they get to iterate on their design ideas with full independence. In the real app! Quite often, the JavaScript and Rails code is even plenty good enough to ship, and we do, after a brief consultation with a programmer.

Other times the programming work is more involved, and a dedicated programmer will pair up to ship a feature. But I cannot tell you how much nicer it is to work with designers who know the constraints of the web, and can do the work of the web, than the alternative. When you overlap on the fundamentals, you’re on the same page more frequently than not. (Though we still trade concessions!)

Did we just happen to find impossible unicorn designers? Maybe, I guess? Likely? No. Scott, JZ, Conor, Jonas, Ryan, and Jason all grew into the designers they are today by putting in the work to get there. By not facing the damnation of low expectations or this-is-too-hard-for-them bullshit.

Now some of that is also tied to how _we_ work with the web. Basecamp is famously – or infamously, depending on who you ask – not following the industry path down the complexity rabbit hole of heavy SPAs. We build using [server-side rendering](https://rubyonrails.org/), [Turbolinks](https://github.com/turbolinks/turbolinks), and [Stimulus](https://stimulusjs.org). All tools that are approachable and realistic for designers to adopt, since the major focus is just on HTML and CSS, with a few sprinkles of JavaScript for interactivity.

And it’s not like it’s some well kept secret! In fact, every single framework we’ve created at Basecamp that allows designers to work this way has been open sourced. The calamity of complexity that the current industry direction on JavaScript is unleashing upon designers is of human choice and design. It’s possible to make different choices and arrive at different designs.

One thing is for sure: I’m not going back! Not going back to the dark ages of designers incapable of making their designs work on their own, incapable of making direct changes, and shipping them too!

Also not interested in retreating into the idea that you need a whole team of narrow specialists to make anything work. That “full-stack” is somehow a point of derision rather than self-sufficiency. That designers are so overburdened with conceptual demands on their creativity that they shouldn’t be bordered or encouraged to learn how to express those in the native materials of the web. Nope. No thanks!

Designing for the modern web in a way that pleases users with great, fast designs needn’t be this maze of impenetrable complexity. We’re making it that! It’s possible not to.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
