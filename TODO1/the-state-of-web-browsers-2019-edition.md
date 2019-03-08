> * 原文地址：[The State of Web Browsers 2019 edition](https://ferdychristant.com/the-state-of-web-browsers-88224d55b4e6)
> * 原文作者：[Ferdy Christant](https://ferdychristant.com/@ferdychristant)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-web-browsers-2019-edition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-web-browsers-2019-edition.md)
> * 译者：
> * 校对者：

# The State of Web Browsers 2019 edition
# 浏览器的状态 - 2019年编辑
![](https://cdn-images-1.medium.com/max/800/1*mkxbYIvO9oe1xsjjezUELA.png)

Two days ago, I published a bitter sweet article on the [state of web browsers](https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-web-browsers.md), triggered by the news that Microsoft would abandon their EdgeHTML engine, replacing it with Chromium. Which was the final nail in the coffin, effectively establishing Chromium as the web’s engine, combined with Safari’s webkit. The only resistance to this monopoly, Mozilla, finds itself without any significant allies or traction to counter this development.

两天前，有感于微软放弃 Edgehtml 引擎，使用 Chromiun 取而代之的事件，我发表了一片关于[浏览器兴衰](https://ferdychristant.com/the-state-of-web-browsers-f5a83a41c1cb)的文章。微软的此番作为被视为将 Chromium 与 Safari 的 webkit 结合建立搜索引擎的最后一步。而此时，唯一能对微软的垄断行为产生威胁的对手 —— Mozilla，发现自己已经没有盟友和动力来应对微软的这一举措。

The article got some readership and a fair amount of feedback. The general consensus seems to be that the article is truthful but depressing.

这篇文章获得了大量读者的反馈，大家普遍肯定了文章的真实性，但也对文章揭露的事实感到沮丧。

Critical notes suggest that some statements are true-ish but too broad, lacking finer details and nuance. I agree. Some statements could be more polished, but it would make the article twice as long, and not all of those details matter for the larger conclusions I was going for. To illustrate, the article got tens of thousands of views, only 25% bothered to actually read it. Which surely has to do with length, and I suppose some were so disgusted halfway-in, they gave up, saving both time and the chance of a clinical depression.

一些批判性的评论则认为文章的一些观点是真实可信的，但过于宽泛，缺乏细节。我肯定有些观点可以更加精辟，但这会使文章的篇幅增加一倍，并且增加的内容对我所要阐述的核心观点没有太大用处。比如说，该篇文章获得了数万读者的浏览，实际上仅仅有 25% 左右的读者真正通读了，可能是因为文章的长度，有些读者感到厌烦，在阅读中途就放弃了，既节省了时间又免得内心沮丧。

Only a few critiqued the delivery style of brutal honesty, most seemed to appreciate it. And some don’t, it comes with the territory. All I can say is that I won’t tone it down, I was actually in a mild mood that day. I don’t apply brutal honesty for shock value or attention, I genuinely believe that in a world ruled by tech, we need no nonsense critique, not sugar coated suggestions. Plus, I’m dutch, this is our default tone of voice.

只有少数人批评我近似残酷的诚实，更多读者则偏向欣赏我的做法。这等同于领土问题。我所能说的是，尽管那天我的情绪很平和，但我并不会降低语气。我也不会用我的诚实获取价值和关注，我坚信在一个由科技主导的世界里不需要毫无意义的批评，更不需要高谈阔论的建议。另外，我是一个荷兰人，我们惯有的语调就是如此。

Back on point, why a second article? I want to address the depressing part of the original article. If you were brave enough to read it to the end, you’d notice the lack of a happy ending. You could be under the impression that the web is a lost cause, the open web in great danger, and that we’ve returned to medieval IE times. It would take the greatest of optimists to wade through that article without it ruining your day, if you care about the web.

回到主题上，为什么要发布第二篇文章？我想要谈谈原文中令人沮丧的那部分内容。如果你有足够的时间读到最后，你会在末尾发现这将是一个缺少快乐的结局。你可能会认为 web 是一个失败的东西，开放的 web 处于极大的危险中，我们已经回到了中世纪的 IE 时代。如果你关心 web 的话，即使是最乐观的人也会在读完这篇文章之后整天沮丧难受。

I cannot change the fact that the road to Chromium/Webkit dominance was messy or even abusive. It is a questionable history that will not be undone. We’re going to leave this one to the lawyers, but sure enough, those browsers aren’t going to be uninstalled. It’s a done deal.

我不能改变的事实是： Chromium/Webkit 的统治之路是混乱的，甚至是滥用的。这是一段不可抹去的、值得怀疑的历史。我们将把这个留给律师，但足够肯定的是，这些浏览器仍不会被卸载。咱们走着瞧。

In this article, we’re going to accept the new state, where Chromium dominates the web, and look **ahead**. To see what Chromium dominance means for users, developers and the open web. The spoiler is of course that there’s plenty of reasons to be happy, optimistic, and even excited about this new state, even if the new state came into existence in unfair ways.

在本文中，我们将接受 Chrome 主导 web 的新态势，并展望未来。看看 Chromium 的优势对用户、开发者和开放 web 意味着什么。剧透一下，我们将有很多理由对这个态势感到高兴、乐观，甚至兴奋，即使这个新态势是以一种不公平的方式出现的。


### Chromium for users: the web works
### Chromium 之于用户：Web
By a rough estimation of global market share, Chromium/Chrome browsers would make up for at least 70% of users. Then there’s 15% of Webkit, mostly mobile Safari.

根据对全球市场份额的粗略估计，Chromium/Chrome 浏览器将占有至少70%的用户。还有15%的Webkit，主要是移动端的Safari 。  

No sane developer would ignore mobile Safari, and Webkit is in many ways similar to Chromium (although growing apart), therefore, a base starting point is that 85% of users will experience a website exactly as it was intended. **At least**. That’s pretty awesome.

任何明智的开发人员都不会忽视移动端的 Safari，而 Webkit 在许多方面与 Chromium 相似(尽管有所不同)，因此，一个基本的出发点是85%的用户将完全按照预期体验浏览一个网站。至少算是 Chromium 的一个优势。 

It gets even better. Most websites do not use bleeding edge features or Chromium-only features, therefore Chromium dominance does not mean the same website would not work just as well in Firefox. Firefox is close to on par with Chromium regarding web standards. Even if slightly lagging behind, it doesn’t mean websites will break in Firefox at scale. And if there’s any issues, surely Mozilla will be eager to achieve compatibility asap.

其次，大多数网站不会使用前沿功能或只使用 Chromium 的功能，因此 Chromium 的优势并不意味着相同的网站不能像Firefox那样工作。Firefox 在 web 标准方面与 Chromium 接近。即使略微落后，这并不意味着网站将在 Firefox 中大规模突破。如果有任何问题，Mozilla 肯定会尽快实现兼容性。

Therefore, my very rough assessment is that for 90% of users, pretty much all of the web will work correctly and as intended by the creator. The exception would be parts of the web that are bleeding edge or experimental.

因此，我的粗略评估是，对于90%的用户来说，几乎所有的 web 都将按照创建者的意图正常工作。唯一的例外是 web 的前沿性或实验性部分。

As strange as it sounds, in a competitive browser landscape where 3 engines would have an equal share, the above would not be as true. There would be far more compatibility issues. With our user hat on, the web works quite well in a Chromium world, where mobile Safari and Firefox combined are large enough to still keep the dominant engine in check.

很奇怪的是，假设在一个浏览器竞争环境中，3个搜索引擎占据相同的份额，上面所说就不成立了。这种假设下将会出现很多兼容性问题，具体应用时，web 在 chrome 的世界中运行得非常好，移动端的 Safari 和 Firefo 结合起来也足够大到可以占据主导地位。

The other 10% is stuff like old IE, slow as its death will be, it will shrink eventually, boosting our 90% even further.

另外10%的浏览器是像旧版IE一样的东西，虽然它的消亡速度很慢，但它最终会缩小，进一步提高我们的90%。

And there’s more good news for users. With the exception of mobile Safari, all these browsers auto update on a frequent basis. Almost all web users will have up-to-date browsers to use an ever-improving web experience.

对于用户的好消息是，出了移动端的 Safari，其余浏览器都会经常自动更新。这导致几乎所有的 web 用户都将使用最新的浏览器来使用不断改进的 web。

### Chromium for developers: life could get easier
### Chromium 之于开发者：生活可以变得更简单
A negative spin on the statement “The web runs on a single engine, Chromium” could be:

*   Developers build Chromium-only websites instead of standards-based websites, and they do this at scale.
*   Chromium is full of non-standard features and actively sabotages an open web or web standards

“web 运行在 Chromium 这一个搜索引擎上”这句话的负面含义可能是:

*   开发人员构建的是基于 Chromium 的网站，而不是基于标准的网站，并且大部分开发者都将是如此。
*   Chromium 充满了非标准的特性，并且破坏了开放式 web ，或者说是破坏了 web 标准

Both are overly dramatic conclusions that I don’t believe to be accurate.

上述两个观点都过于夸张，我认为均不正确。

First, yes, there was a low period a few years ago when the mobile revolution was in full swing where developers could not wait for web standards and massively used vendor-prefixed or Chrome/Webkit-only features to maximize what they could do on mobile, this whole new exciting category of the web. This practice got so far out of hand that competing browsers had to implement vendor prefixed features **of their competitors** just to stay in the game.

首先，当移动端如火如荼发展的时候，Web 端的确经历了一段低谷期，在那期间，Web 开发者们不得不一边等待 Web 标准的发布，一边大量使用与厂商相关的前缀或 Chrome/Webkit-only 等特征去最大化他们能在移动设备这种全新 Web 载体上实现的功能。

This period is largely behind us now. Every major browser vendor has agreed that vendor prefixes were a bad idea. New features are now behind a flag, which means developers cannot deploy them to users before they mature. Existing problematic prefixes that we cannot undo from the wild are now built into each browser to ensure compatibility.

那段低谷期已经距离我们很久了。所有的浏览器厂商也都认为使用厂商前缀是一个坏的解决方法。新的特性隐藏在一个标志后面，这意味着开发人员无法在用户成熟之前将它们部署到用户身上。那些我们无法直接撤销的现有的前缀问题，现在已经内置到每个浏览器中，以确保兼容性。

So, no, developers using non-standard Chromium features does not seem like a huge problem to me these days.

所以，这些天开发人员使用非标准的 Chromium 特性对我来说似乎不是一个大问题。

What about Chromium-only standards-based features? Here we have the situation where Chromium shipped a new standards-based feature not yet available in other engines.

那么那些仅仅基于 Chromium 的标准特征呢？在这里，会出现这样一种情况：Chromium 发布了一种新的基于标准的功能，但在其他搜索引擎中却不可用。

A short-sighted developer could conclude that they can just use it without fallback since the world runs Chromium anyway. Well, no. Good old lagging mobile Safari comes to the rescue. Very likely, mobile Safari will not have that new feature and it may not have it for years to come.

一个目光短浅的开发人员可以得出这样的结论：他们可以仅仅使用 Chromium 而不需要其它的备用引擎，因为世界上无论如何都有 Chromium 的存在。呵呵！这也是不正确的。落在后面的移动端 Safari 来拯救我们了。很有可能的是，移动端 Safari 不会有 Chromium 发布的新功能，而且在未来几年也不会有。


You cannot afford to ship a web experience that breaks in mobile Safari. Mobile Safari has 15% market share across devices. On mobile it’s 25%. In some major markets, it may even be as high as 40% on mobile.

在移动端 Safari 中，你不能提供中断的 web 体验。移动端 Safari 在不同设备上拥有 15% 的市场份额。在移动设备上，这个比例是25%。而一些主要市场，在手机用户的这一比例甚至可能高达40%。


**The fallback is a must in almost any case** and by developing the fallback, you are quite likely to support that other browser as well: Firefox.

几乎在任何情况下，备用技术都是必须的，通过发展其它备用技术，你才很可能还会使用到其他浏览器:比如 Firefox。

As for Chromium and the relation to web standards, I’ll discuss it in a separate chapter. Let’s first now consider what the new state of browsers means for developers.

至于 Chromium 及其与 web 标准的关系，我将在另一章中讨论。现在让我们首先考虑浏览器的新状态对开发人员意味着什么。

There is news, and there is no news. A first and clear positive workflow improvement is that you no longer have to test for EdgeHTML compatibility.

似乎也没有什么。第一个明显且正面的工作流改进是你不需要再测试 EdgeHTM 的L兼容性。

You’ll have to keep testing for Firefox, but here I expect improvements too. Mozilla will now be in survival mode and I expect them to prioritize compatibility with Chromium in an effort not decline any further.

可你将不得不继续测试 Firefox ，但是在这里我也希望能得到改进。Mozilla 现在处于寻求生存模式，我希望他们会优先考虑与 Chromium 的兼容性，而不会进一步降低其兼容性。

The lack of bigger workflow improvements is in Safari lagging behind, forcing us into fallbacks, polyfills, transpilations, the like.

Safari缺乏更大的工作流改进，这使得它落后于其他浏览器，迫使我们使用向下兼容、polyfills、transpilations等技术。

Rather than to keep bashing mobile Safari, I’m going to deliver a new take on it. Let’s make the rough assessment that Safari lags behind in supporting major new web standards by about 1–2 years in general.

与其继续抨击移动端 Safari，我还不如换一个视角。让我们粗略估计一下，Safari 在支持主流新 web 标准上总体落后了大约1-2年。

Now be very serious when you ask yourself this question: given your audience and product, can you create the web experience you want your users to enjoy using web standards generally available 1–2 years ago?

现在，问你自己一个严肃的问题: 考虑到你的受众和产品，你能开发出你的用户喜欢使用1-2年前普遍可用的 web 标准的 web 体验吗?

If the answer to that question is YES, and I believe it very often can be, you may simplify your workflow significantly. Possibly, you can say goodbye to polyfills, transpilation and auto prefixing altogether. Because the web of 1–2 years ago really is no joke.

如果这个问题的答案是肯定的，其实我相信通常情况下会得到肯定的答案，那么你可以大大简化你的工作流程。也许，你可以跟polyfills, transpilation和自动补齐前缀说再见。因为1-2年前的 web 真的不是开玩笑。

There are examples of emerging web standards where you do need the latest and greatest, for example Web Components. Still here you could ask the question if your users really need Web Components. Be honest, it’s you that wants Web Components, not your users. I won’t judge, I love web tech too.

你确实需要最新的和最好的标准，例如 web 组件。在这里，你仍可以问自己一个问题，用户是否真的需要 Web 组件。老实说，需要 Web 组件的是开发者你自己，而不是你的用户。我不做评判，因为我也喜欢 web 技术。

I would welcome a simpler development workflow, I think the current one is rather shit. Absurdly complex, slow, constantly breaking, and obsolete by the time you have it working. I would welcome a return to just entering code and running it, without a 100,000 node modules processing my input. Maybe web development could once again become accessible and fun to those who are not hardcore engineers. Because the web belongs to all of us, and they are just as entitled as the rest of us to work on it. Even as an experienced developer you must admit the current state of affairs is rather involved and messy, even if you learned to cope with it.

我希望有一个更简单的开发工作流，我认为当前的工作流相当糟糕。异常复杂、缓慢、反复中断，当你让它工作的时候，它已经过时了。我希望回到只输入代码并运行它，而不是需要 10 万个节点模块处理我的输入。也许 web 开发可以再次为那些不是铁杆工程师的人提供方便和乐趣。因为 web 属于我们所有人，那些人和我们其他人一样有权利为之工作。即使你是一个有经验的开发人员，你也必须承认当前的状态是相当复杂和混乱的，即使你已经学会了如何处理它。

### Chromium and web standards

### Chromium 以及 web 标准
We’ve established that we live in a Chromium monopoly which triggers deep concerns on the future of web standards, the standardization process itself, and the enormous control one party has over the future direction of the web. In this section, we’re going to explore how bad, or not so bad things are at a practical level.

可以确定的是，我们正处在 Chromium 的垄断环境中，Chromium 的垄断引发了对 web 标准、Chromium 自身标准建立过程、两者对 web 未来发展方向的关注。在这一部分，我们将从实践层面讨论 Chromium 的垄断所带来的坏的一面，以及其有利的一面。 

Let us make the assumption that Google is at the steering wheel of both standards creation and standards implementation. It isn’t an absolute 100% power, yet a decisive power. Let’s explore how such a dominant position could potentially be abused, and whether it is likely to occur.

我们假设 Google 不仅担任着标准实现的角色，还是标准的践行者。虽然这种假设不是百分百的可能，但很大程度上是可能发生的。接着让我们看看在背地里 Google 可以如何滥用这种优势，并分析这种滥用是否会发生。

#### Incentive

#### 动机

First, we should take away one major concern, or even the biggest concern. Unlike old Microsoft or current Apple, Google has no business incentive to hurt or hold back the web or web technology in any serious ways. It is a company born on the web with an incentive for the web and web technology to thrive. Stagnation or intentionally introducing incompatibilities makes no logical sense, and no financial sense. In many or most cases, Google’s direction of the web benefits users, developers and themselves all at once. Interests align. Not perfectly, and not at all times, but most of the time they do.

首先，我们应该消除一个主要担忧，甚至是最大的担忧。与微软和苹果不同的是，Google 是没有商业动机去以任何方式伤害或阻碍 web 或 web 技术发展的。因为 Google 是一家诞生在 web 上的公司，其致力于 web 和 web 技术的蓬勃发展。两者的停滞不前或故意引入不兼容性，逻辑上不成立，经济上也没有意义。在多数甚至是大多数情况下，Google 的 web 发展方向对用户、开发人员和他们自己都有好处。三者的利益是一致的。这种互利状态虽然不是很完美，也不是每时每刻都存在，但大多数时候都是这样。


Therefore at a very fundamental level, surely the web or web technology isn’t doomed at all. It is in the hands of a party that has just as much interest as us in preserving and improving it.

因此，从一个非常基本的层面来讲，web 或 web 技术注定不会失败。两者的命运掌握在像我们一样致力于维护和改进它们的人手里。

The devil is in the details, therefore let’s explore a few risks in detail:

细节决定成败，下面让我们来详细探讨几个存在的风险:

#### Google just making stuff up in Chromium

#### Google 用 Chromium 仅仅是为了提高 web 质量

With Chromium so dominant, Google could in theory bypass standards creation entirely and just go all rogue in pushing new features that fit their agenda. After all, if it’s implemented in Chromium, it has basically become a standard, right?

由于 Chromium 的主导地位，Google 在理论上完全可以绕过标准的建立，并在推行符合自己规划的新特征时肆无忌惮。毕竟，如果新的特征在 Chromium 中实现了，那它基本上已经成为了一个标准，对不对?

They can, occasionally, but they can’t go too far. Truly bullshit features will never make it to webkit or Firefox, which is a problem, as Google surely doesn’t want the web to be incompatible for hundreds of millions of users given their widely spread web properties.

他们偶尔可以这样做，但是从长远来看是行不通的。非常糟糕的特征永远不会在 webkit 和 Firefox 身上出现，这是因为 Google 鉴于其 web 属性非常广泛，他们也不希望 web 对数以亿计的用户不兼容。

Plus, if the feature is truly insane and openly against general interests, there will be push-back from other stakeholders, and subsequently, bad PR.

此外，如果推行的特征真的很过分，公然违背了大众的利益，那么其他利益相关者就会予以抵制，从而导致糟糕的公关。

Finally, as said, “fit their agenda” very often aligns with the agenda of users and developers. So all in all, I’m not too worried about this one.

最后，如前所述，“符合他们的规划” 通常与用户和开发人员的规划一致。总之，我不太担心这个。

#### Google dictating priorities of implementation

#### Google 决定实现的优先顺序


In this scenario, Google would influence the logical order of implementation regarding web standards in a way that puts their interests first.

在该场景下，Google 会以一种将他们的利益放在首位的方式影响 web 标准实施的逻辑顺序。

For example, imagine we’re all waiting for subgrids to be implemented, a feature that will widely benefit all of us. Meanwhile, Google prioritizes the implementation of KeyboardSynthesizerVoiceMachineLearningCloudWorklet instead, an essential API for their new chat client #735, code-named “Hola!”, to be announced at I/O 2019 and to be sunset 6 weeks later, for it had a disappointing 300 million users only.

比如，想象一下，我们正在等待 subgrids 的应用，这是对大家都有益处的一个特征。与此同时，Google 则优先实现机器学习云工具下的语音合成器，该语音合成器是其代号为 “Hola” 的新型聊天客户端 #735 中的一个必要 API, Hola 客户端在 2019 I/O 大会上发布，仅仅 6 周后就废止，因为其仅仅获得了3亿用户。

Yes, this could happen and I think it does happen. Following Chrome release notes closely for a long time (which I realize is not the same as Chromium but close enough), I do find myself occasionally surprised at updates to APIs I never heard of or can’t imagine being widely needed, whilst there would be candidate features with a far wider use case not being delivered (yet).

诚然，这种情况有可能发生，我认为确实发生了。密切关注 Chrome 的版本说明很长一段时间(我意识到了 Chromium 的变化，但这种变化却不是很大),我自己偶尔也会惊讶于一些我从未听说过或无法想象会有广泛需求的 api 更新出来,同时一些具有广泛用例的补充特征还没有发布。

It’s not as bad as it sounds. It doesn’t mean the more important feature does not get delivered. The web moves pretty fast these days. Also, there isn’t always some evil plan behind a more important feature not getting delivered first. It could simply be more complex or have more dependencies. With many people working on many things in parallel, there’s no guarantee that the most important feature gets delivered first.

其实也没有那么糟糕。这并不意味着一些更重要的特征没有得到发布。况且现在 web 发展得如此之快。此外，不发布那些重要特征并不是一件坏事情。特征可以变得更复杂，或者会有更多的依赖项。由于许多人同时完成发布工作，所以不能保证首先交付的就是最重要的特性。

So whilst Google may incidentally prioritize self-serving features, in practice I’m not seeing a huge risk. Once again, remember that the world is watching.

因此，虽然 Google 可能会偶尔优先考虑利己的特征，但在实践过程中，我并没有看到 Google 顶风作案。请再次记住，全世界都在关注 Google。

#### Google says NO

#### Google 说：“不”

The opposite of prioritizing self-serving features is to de-prioritize or downright block ideas of others. Let’s assume the idea or proposal is serious and has consensus from many stakeholders. Yet for whichever reason, Google doesn’t like it, and blocks implementation.

优先考虑为自己服务的特性的反面是降低其他厂商特征的优先级或完全阻止其想法实施。我们认定有些想法或提议是真正有益的，并且得到了很多其他利益相关者的一致肯定。但不知道是什么原因 Google 就是不接受它们，并且阻碍其实现。

This is a tricky one, where all we can do is look at track records and incentives. I’ll admit that I don’t follow Chromium discussions in detail, because I chose life. Possible there’s tons of examples where this happens, if so, let me know.

这是一个棘手的问题，我们所能做的就是关注 Google 的历史纪律和动机。 我承认我不会密切关注 Chromium ，因为我还有我的生活。 可能有大量这样的例子在发生，如果有的话请大家分享出来让我知道。

A memorable example I have of this happening is CSS Regions. It’s a giant spec and enormous code commit by Adobe that was blocked. Whether it was blocked for good reasons or bad, I’m unable to answer, given the enormous complexity of the discussion. You could cancel your Netflix subscription and be entertained for two months just soaking up this epic mud fight.

我一个印象深刻的例子是发生在 CSS 领域。Adobe 提交的一个很重要的规范和大量代码被 Google 拒绝了。尽管关于此事件有很多讨论，我仍无法回答是出于什么原因 Adobe 的提交就这样被否定。与其深究，还不如享受生活、坐山观虎斗。

A more recent example is dropping HTML Imports, but here too it’s not clear at all whether it was a wrong move, given other browsers’ reluctance to implement it. It was blocked for technical reasons, not corporate reasons.

最近的一个例子是 Google 放弃使用 HTML Imports，其它浏览器厂商虽然照做，但表现得极不情愿，所以我也肯定 Google的这一举措是不是错误。 封锁 HTML Imports 实际上是技术的原因，而 Google 的原因。


I’d say Google is unlikely to say no to ideas that help the web forward as its in their interest to help the web forward too. This will apply to any idea, for as long as those ideas do not threaten their business.

我认为 Google 不太可能拒绝那些帮助 web 向前发展的方法，因为他们也有兴趣帮助 web 向前发展。只要这些想法不会威胁到他们的业务。

It’s easy to think of a web standards idea that is threatening: pretty much anything related to privacy. If the world agrees that 3rd party tracking should become impossible at a technical level via a web standard, you can be sure that there will be resistance from a company earning money from personal data. Yet here too the world is watching, and if Google protects their business too obscenely, they’re leaving open major opportunities for competing browsers to thrive. To fork Chromium. For Firefox to make a comeback. For Apple’s Safari to exploit their strength in privacy protection. It’s a careful balancing act.

web 标准具有威胁性的一点是：几乎所有 web 事务均与隐私有关。 如果全世界都同意在 web 标准技术层面上无法进行第三方跟踪，那么可以确定有些公司会从个人数据中谋利。 然而，全世界也在时刻关注着这一问题，如果 Google 过于在暗地里保护他们的业务，就会为竞争对手留下难得的机会。Firefox 的卷土重来，Apple Safari 的隐私保护力量足以瓜分 Chromium。 隐私对于 Google 确是值得权衡的。

So bottom line: Google generally has no incentive or track record of saying no to good ideas, and in cases where they do, the damage will not be disastrous nor can they go overboard.

所以底线是: Google 通常没有对好主意说不的动机或历史记录，而且在他们说不的情况下，对自身的损害既不是灾难性的，也不会太过火。

#### Google outside Chromium

In the above sections I have illustrated how I believe Google at the steering wheel of the world’s web engine isn’t as bad for the web as it sounds. Just because they have the position, does not mean it will be abused. And I don’t believe it will be abused frequently or in major ways, minus a few incidental cases. There is no track record to assume that nor is there incentive. We can further strengthen that conclusion by knowing that despite a dominant position, there’s still checks and balances in place. For example, Microsoft and hopefully others are donating resources into the engine.

在上面的章节中，我已经说明了我如何相信 Google 在全球 web 发展道路上并不像听起来的那样对 web 有害。很多人这样认为仅仅因为他们有能力那样做，但这也不意味着 Google 会滥用他们的主导地位。我不认为它会经常被滥用或当作主要竞争手段，当然要除去一些偶然的案例。没有历史记录，也没有动机证明 Google 的滥用行为。我们可以进一步加强这一结论，因为我们知道，尽管处于主导地位，但仍然存在着制衡。例如，微软和其他有前途的公司也在向搜索引擎贡献力量。

Indeed, at a practical level I have no immediate existential concern for the future of the web, web technology or web standards. If I was to be in an overly optimistic mood, I could be even be excited about it, given Google’s track record in improving the web. The web will continue to improve, in rapid pace, and those improvements will be deployed instantly to the vast majority of web users. It’s hard to see that as a negative. Even more so if you’re as old as me, having lived through times where pretty much nothing happened.


实际上，在实践层面上，我对 web 、web 技术和 web 标准的未来没有直接的关注。如果我是在一个极其乐观的人，鉴于 Google 在改善 web 方面的历史记录，我甚至可以为 web 感到兴奋。web 将继续快速改进，这些改进将立即部署到绝大多数网络用户身上。很难将 Google 视为对 web产生负面影响的公司。更重要的是，如果你和我一样老，我们所经历的 web 时代一直一帆风顺。

And this is where you watch a movie and the main characters seem to be happy for about 10 minutes. You know something bad is coming.

这就像你看的电影一样，主角们似乎高兴了大约10分钟。但你知道将会有不好的事情会发生。

I can’t skip over the thought that if there is any threat to the web and its users, it isn’t in Chromium, it’s outside of it. Most questionable moves by Google take place outside of Chromium, and I’ll hereby discuss a few examples:

我不能忽略这样一个想法:如果对 web 及其用户产生的威胁不是在 Chromium 中，而是在 Chromium 以外的其它部分。Google 最可疑的举动就发生在 Chromium 之外，下面我将讨论几个例子:

By far the most prominent example I can think of is AMP. I consider it a violent attack on open web principles. If you want to know why, I have a separate [article](https://ferdychristant.com/amp-the-missing-controversy-3b424031047) for that. Despite a storm of criticism from the web community, Google hasn’t changed its course, instead they’re doubling down on AMP.

到目前为止，我能想到的最突出的例子是 AMP。我认为这是对开放 web 原则的暴力攻击。如果你想知道原因，我另有有一篇[文章](https://ferdychristant.com/amp-the-missing-controversy-3b424031047)有分析。尽管有来自 web 社区的批评，Google
并没有改变它的路线，相反，他们正在加倍部署 AMP。

Another recent controversy is in Chrome, which is not pure Chromium, therefore outside of Chromium. Google decided to secretly log you into the browser itself whenever logging into a Google service. It actively held back information about this change (unlike normal release notes) which is super shady, it proves that they know it to be a shitty move. When exposed, suddenly there’s “reasons” and “listening to feedback”.

另一个最近的争议是 Chrome，它包装在 Chromium 之外 。Google 让你无论何时登录到 Google 服务，都会秘密地将你登录到浏览器本身。它积极地隐瞒这个变化(不像普通的发布说明)，这是非常可疑的，这证明他们知道这是一个糟糕的做法。一旦暴露出来，就会突然出现“reasons”和“listening to feedback”。
 
A third concern is Google’s aggressive deprecation policy that lacks empathy. This is an area I have experience with. Because of some of my other hobbies (wildlife photography) I spent a lot of time on websites that deal with zoology: describing species. These websites are often made by amateurs, hobbyists, people that are not professional web developers. Also, some of these websites haven’t been touched (in terms of code) for years. Let’s call all of this the “old web”.



How big is this old web? I don’t know, but I’m willing to bet that most of the world’s web pages aren’t under active maintenance. The thing is, many of these websites are breaking. Partly, or as a whole. They’re falling apart, bit by bit. Because of deprecations, new expectations (for example HTTPS), but even more so by breaking API changes of 3rd party services, like Maps. Or, they are massively de-ranked for not complying with new expectations and therefore wiped from existence.

Yet these websites still have value. Tech companies owe it to these website owners for their site that once worked, to keep working years after. It’s part of the promise of the web: backwards compatibility. The gut reaction that these website owners should update their shit and get with the times is arrogant and lacks empathy. It is based on the faulty assumption that behind every website, there’s some team of developers maintaining it throughout its entire life cycle.

Even if you believe its their problem, consider this analogy. Say you have a computer illiterate mother (I do). She struggles with basic computing and needs constant help. You could now be all smug and tell her to brush up her computing skills, to “get with the times”. You could technically be right, but I sure hope she kicks your arrogant ass. Even if right, the problem isn’t going to be solved, and therefore empathy is the answer. And that’s how I feel about the old web: it must be preserved with empathy. Google has a very poor track record in this area.

I’m getting side tracked here, and breaking my promise of making this an optimistic article. I could make the above list a lot longer but my main point here is that most of Google’s questionable moves regarding the web and its users do not take place in Chromium, instead outside of it.

I don’t have a solution for it, it’s just an observation.

### The downsides of power

On to more positive thoughts. For us that is, not for Google. Sorry, Googlers. This one isn’t personal though, I promise. It may scare the shit out of you though. I want to talk about the downsides of power, of which there are many.

Whenever I see the CEO of a big company, my immediate thought is pity, not admiration. At the top of the food chain, it’s all eyes on you. There’s nobody to hide behind. Expectations are sky high, relentless, and constant. Mistakes, made by any human being, can have disastrous consequences which will forever be linked to you. Even the upsides aren’t that great. Fame has downsides. Money is not that great if you don’t have the time to enjoy it. There’s even personal security risks and legal risks. You don’t even know if your friends are really your friends.

No, I wouldn’t want to trade with a CEO, world leader, or anybody else at the top of a giant food chain. I prefer being a nobody in the shadows.

A fitting example of this I saw a few years ago in a nature documentary. It was documenting a group of monkeys. The monkey society was organized by dominant males ruling a harem of about 20 females. One dominant male was followed for years in its day-to-day activities which pretty much consisted of keeping the females happy and fighting of any challengers to its rule.

Until the day when the male got too old to do so, and a young male kicked his ass, ending his rule. From absolute power to zero, in one minute. And you know what happened? Rather than depressed by its defeat, the old male seemed to be celebrating, visibly relieved. Because dominance is stressful, tiring, relentless and not at all as awesome as you may think it to be. I believe I even saw the old male laughing at the young new ruler: oh boy, if only you’d know. Well no, I made that part up.

The point? Google is the red ass monkey. Being at the top of this giant food chain has all the downsides discussed. Rather than a comfortable stronghold, it’s a position of stress, risk, high stakes and volatility. An abuse of power can lead to competitors stepping in the gap, massive revolts of users, billions lost, enormous legal claims, and more. A single technical innovation can wipe out enormous parts of your business. It is an inevitability that no power lasts forever, it has never done so, ever.

Rather than being afraid of Google for its dominance, it is in fact Google that should be afraid. Because once you win, you can’t go up, and everybody wants you to go down. We’re just waiting, whilst you face all the downsides of being a winner.

If I were more intelligent and qualified to be a browser engineer, I’d be absolutely terrified to work on Chromium, the “winner”. I’d be totally relaxed, optimistic and laughing when working on Firefox, the “loser”. It’s the difference between having everything to lose with the whole world watching, and having nothing to lose and everything to win, with nobody watching. It is the difference between the highly stressful task of trying to keep a container ship running on which everything depends and having the freedom of thought to invent a wildly cool new speed boat.

How is this good for us? Google comes across as a rational and intelligent company and I expect them to realize how fragile their position really is. If so, it is a powerful safeguard against actions that are too hostile to the web. They simply can’t afford to. The previous one that tried, Microsoft, has been decimated. It only takes time. A mistake. Being too arrogant. Doing too many wrongs. One lawsuit. Power never lasts, and that is a good thing.

So instead of freaking out about this dominance, let’s instead sit back, relax and grab some popcorn. The pressure isn’t on us. The web cannot be killed or uninstalled and in the long term, truly isn’t owned by anybody, it’s a temporary illusion at best.

### The opposition is down, but alive

The biggest victim of this round of browser wars is Firefox. As discussed in the previous article, they’re in deep trouble. Near-zero presence on mobile, and a declining market share on desktop that without intervention is heading towards dangerous territories.

What message of hope can be distilled from this disaster? There’s a few I can think of:

*   Whereas part of the desktop loss is due to Chrome being aggressively pushed (combined with Chrome being a great browser), another part of the loss may be due to Mozilla’s neglect of the desktop browser during the Firefox OS years. Another reason could be a series of painful changes to the UI and web extensions. The point here is that there is a sizable audience that can be regained, and isn’t lost forever. I’m talking a few percentage points here. Which doesn’t mean dominance, it still means dozens of millions of users.
*   Maybe WebRenderer really is as unique and awesome as I dream it to be. And maybe some major player builds a game or other killer app which will let it shine, whilst Chromium can’t run it ever. Maybe a technically superior browser does matter, if only the right application exists for it that people love or find important.
*   We live in privacy aware times. The party of unlimited data harvesting is largely over or past its peak. Whilst the general public doesn’t seem to care that much yet in terms of which technology they use, it doesn’t mean this state of indifference is forever. It just takes the right push of buttons to set big things in motion, like the butterfly causing a hurricane. Beneficiaries would be Firefox and mobile Safari.
*   Maybe some major Android manufacturer is tired of Google’s abusive shit and says to hell with it: I’m shipping Firefox to the home screen. Could happen any day, as the relation between Google and Android manufacturers is dual: allies as well as competitors. Firefox mobile can’t go down much, but it can go up a lot.

I’m making up all of these scenarios. Each one may be highly unlikely to happen but for **any** unlikely event to happen, is highly likely. Unlikely things happen all the time, we don’t know which or when, but they will happen.

The young monkeys are waiting, and they are patient. Their time will come.

### Wrapping up

I’m thinking I’m not that good in writing positive articles after all, but let me try to wrap up why I believe the situation of Chromium as the dominant engine to run the web isn’t as bad or depressing as my previous article suggested:

*   To users, the web will work. Almost every user will experience websites the way they were intended to be experienced. Users will experience a rapidly improving web by means of their engine constantly updated, instead of being tied in to some OS (except for iOS users, who are on a slower pace)
*   To developers, one engine less means a simpler workflow. The dominant engine, Chromium, is also a really great if not the best engine. With almost every web user on a great engine and by targeting web features smartly, you can even drastically simplify your workflow.
*   As for standards, Chromium incompatibilities or vendor prefixes are largely a thing of the past and there is a strong disincentive to introduce new incompatibilities (because of mobile Safari). Furthermore, Google has no track record or incentive to sabotage web standards from moving forward, the opposite is true. The open web and web standards are not dead, they could even thrive. Chromium moves fast and it being the leading engine deployed to almost every user, means the web as a whole moves fast.
*   Google may incidentally put its own interests overall general interests, yet it is unlikely to do so at Chromium level. As discussed, this is more likely to happen outside of Chromium, at other properties they own.
*   Power is temporary, even more so in the tech industry. The competition is down but never asleep, and this provides a strong incentive for our overlord to behave, if not for the army of people caring about the web with powerful ways to speak up.

In 2019, there’s no reason to be depressed about the state of the web, even if it’s not in an ideal state.

Web technology is more capable than ever, and will continue to evolve rapidly. There is no sign of anything slowing down. Web technology will be more compatible than before, and users will experience a compatible web no matter their browser.

The ever improving web will inevitably lead to a sustainable web app platform that once robust enough, will break the chains of walled native app gardens. It’s an inevitable path forward that can be slowed down, but not stopped. Rather than reduced, the web’s role in computing will grow again at the cost of proprietary solutions.

The web will continue to evolve based on web standards, discussed in the open. The latest, standards-based web tech instantly deployed to almost every user, may ultimately make web development a whole lot simpler, bringing in new creators.

Is it perfect? No. But there’s lots to be excited about. Look past the mono-culture to see that compared to multiple incompatible engines with heavy feature disparity, we may be in for quite a ride of web awesomeness.

With that, I wish you happy holidays.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
