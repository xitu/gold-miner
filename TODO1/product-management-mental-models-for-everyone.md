> * 原文地址：[Product Management Mental Models for Everyone](https://blackboxofpm.com/product-management-mental-models-for-everyone-31e7828cb50b)
> * 原文作者：[Brandon Chu](https://blackboxofpm.com/@brandonmchu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/product-management-mental-models-for-everyone.md](https://github.com/xitu/gold-miner/blob/master/TODO1/product-management-mental-models-for-everyone.md)
> * 译者：
> * 校对者：

# Product Management Mental Models for Everyone

![](https://cdn-images-1.medium.com/max/1600/1*b61UVOBxXM0yEyzLME0tuw.gif)

Mental models are simple expressions of complex processes or relationships. These models are accumulated over time by an individual and used to make faster and better decisions.

Here’s an example: _the_ **_Pareto Principle_** _states that roughly 80% of all outputs comes from 20% of the effort._

In the context of product management, the model suggests that instead of trying to create 100% of the customer opportunity, you may want to look for how to do 20% of the effort and solve 80% of the opportunity. Product teams make this trade off all the time, and the results often looks like feature launches where 20% of customers with more complicated use cases aren’t supported.

Mental models are powerful, but their utility is limited to the contexts they were extrapolated from. To combat this, you shouldn’t rely on one or even a few mental models, you should instead be continuously building a _latticework_ of mental models that you can draw from to make better decisions.

This concept was popularized by Charlie Munger, the famed Berkshire Hathaway vice chairman, in a [speech](https://old.ycombinator.com/munger.html) where he reflected on how to gain wisdom:

> What is elementary, worldly wisdom? Well, the first rule is that you can’t really know anything if you just remember isolated facts and try and bang ’em back. If the facts don’t hang together on a latticework of theory, you don’t have them in a usable form.

> You’ve got to have models in your head. And you’ve got to array your experience — both vicarious and direct — on this latticework of models. You may have noticed students who just try to remember and pound back what is remembered. Well, they fail in school and in life. You’ve got to hang experience on a latticework of models in your head.
>
> What are the models? Well, the first rule is that you’ve got to have multiple models — because if you just have one or two that you’re using, the nature of human psychology is such that you’ll torture reality so that it fits your models, or at least you’ll think it does. You become the equivalent of a chiropractor who, of course, is the great boob in medicine.
>
> It’s like the old saying, “To the man with only a hammer, every problem looks like a nail.” And of course, that’s the way the chiropractor goes about practicing medicine. But that’s a perfectly disastrous way to think and a perfectly disastrous way to operate in the world. So you’ve got to have multiple models.

**This post outlines some of the most useful mental models that I’ve accumulated in my career in Product Management.** As I learn new models, I’ll continually update the post.

This is also **not** a post for just product managers, it’s for everyone that works on products.  Product thinking is not sacred to the role of a PM, in fact, it’s even _more useful_ in the hands of the builders than PMs.

#### The mental models we’ll cover are structured into the following categories:

1.  Figuring out Where to Invest
2.  Designing and Scoping
3.  Shipping and Iterating

* * *

**_Figuring out Where to Invest_ — **the next set of mental models are useful for deciding what your team should build, or “invest in”, next.

### 1. Return on Investment

A finance concept: for every dollar you invest, how much are you getting back? In product, think of the resources you have (time, money, people) as what you’re “investing”, and the return as impact to customers.

![](https://cdn-images-1.medium.com/max/800/1*WzqwU7lp6E5nRgART7XJxw.png)

#### How it’s useful

The resources available to a product team are time, money, and [the number and skill of] people. When you’re comparing possible projects you could take on, you should always choose the one that _maximizes impact to customers for every unit of resources you have._

### 2. Time value of shipping

Product shipped earlier is worth more to customers than product shipped at a later time.

![](https://cdn-images-1.medium.com/max/800/1*JVAnPRwoPhnVSKWN2oQRDw.png)

#### How it’s useful

When deciding between problems/opportunities to invest in, you can’t just compare the benefits of different features you could build (if you did, you would always choose the biggest feature).

Instead, to make good investment decisions, you also have to consider how quickly those features will ship, and place more value on features that will ship faster.

### 3. Time Horizon

Related to the _Time Value of Shipping,_ the  right investment decision changes based on the time period you are optimizing for.

![](https://cdn-images-1.medium.com/max/800/1*lD889xYiJSidoYfrzDO5SA.gif)

Given a long enough time horizon, the cost of a 3 month vs. 9 month build is insignificant.

#### **How it’s useful**

Choosing to ask _“How can we create the most impact in the next 3 months?”_ or _“How can we create the most impact in the next 3 years?”_ will  result  in dramatically different decisions for your team.

It follows then that aligning with your team and stakeholders about what time horizon to optimize for is often the first discussion to have.

### 4. Expected Value

Predicting the future is imperfect. Instead, all decisions create probabilities of multiple future outcomes. The probability-weighted sum of these outcomes is the _expected value_ of a decision.

![](https://cdn-images-1.medium.com/max/800/1*_QclBIKqkgEehi61jVu7xQ.png)

#### How it’s useful

When considering impact of a project, map out all possible outcomes and assign probabilities. Outcome variability typically includes the probability it takes longer than expected and the probability that it fails to solve the customer problem.

Once you lay out all the outcomes, do a probability-weighted sum of the value of the outcomes and you’ll have a better picture on the return you will get on the investment.

* * *

**_Designing and Scoping _— **the next set of mental models are useful for scoping and designing a product after you’ve chosen where to invest.

### 5. Working Backwards (Inversion)

Instead of starting at a problem and then exploring towards a solution, start at a perfect solution and work backwards to today in order to figure out where to start.

![](https://cdn-images-1.medium.com/max/800/1*v-dFL3r4rPFo6xPjr0VQ8w.png)

Note that working backwards isn’t universally better, it just creates a different perspective.

#### How it’s useful

Most teams tend to _work_ _forwards,_ which optimizes for what is practical at the cost of what’s ultimately impactful.

Working backwards helps you ensure that you focus on the most impactful, long term work for the customer because you’re always reverse-engineering from a perfect solution for them.

Note that working backwards isn’t universally better, it just creates a different perspective. It’s healthy to plan using both perspectives.

### 6. Confidence determines Speed vs. Quality

The confidence you have in i) the importance of the problem your solving, and ii) the correctness of the solution you’re building, should determine how much you’re willing to trade off speed and quality in a product build.

![](https://cdn-images-1.medium.com/max/800/1*rqE-5eVKXLmkVLFux92d0g.png)

#### How it’s useful

This mental model helps you to build a barometer to smartly trade off speed and quality. It’s easiest to explain this by looking at the extreme ends of the spectrum above.

**On the right side:** you have confidence (validated through customers) that the problem you’re focused on is really important to customers, _and_ you know exactly what to build to solve it. In that case, you shouldn’t take any shortcuts because you know customers will need this important feature forever, so it better be really high quality (e.g. scalable, delightful).

**Now let’s look at the left side:** you haven’t even validated that the problem is important to customers. In this scenario, the longer you invest in building, the more you risk creating something for a problem that doesn’t even exist. Therefore, you should err on launching something _fast_ and getting customer validation that it’s worth actually building out well. For example, these are the types of situations where you may put up a landing page for a feature that doesn’t even exist to gauge customer interest.

### 7. Solve the Whole Customer Experience

Customer experiences don’t end at the interface. What happens before and after using the product are just as important to design for.

![](https://cdn-images-1.medium.com/max/800/1*D_JfpzBPTU906raJzZVNPA.png)

#### How it’s useful

When designing a product, we tend to over focus on the in-product experience (e.g. the user interface, in software).

It’s just as important to design the marketing experience (how you acquire customers and set their expectations for the product before they use it), and the support/distress experience (how your company handles the product failing).

Creating great distress experiences, in particular, are amazing opportunities to earn long term customer trust. For example, Amazon earns the most trust from you as a customer _when you have to return something._

### 8. Experiment, Feature, Platform

There are three types of product development: Experiments, Features, and Platforms. Each have their own goal and optimal way to trade-off speed and quality.

![](https://cdn-images-1.medium.com/max/800/1*ilzmNU-5V1n8w4FLen4nVA.png)

#### How it’s useful

By recognizing the type of product development your project is, you will define more appropriate goals for each type, and you will right-size the speed and quality trade off that you make.

Experiments are meant to output _learning_, so that you can invest in new features or platforms with customer validation. If you optimize for learning, you will consider doing things that otherwise wouldn’t be palatable: for example using hacky code that you intend to throw away, and faking sophisticated software when it’s just humans doing it behind the scenes.

In contrast to experiments, platforms are forever. Other people will build features on top of them, and as such making changes to the platform after it’s live is extremely disruptive.

Therefore, platform projects need to be very high quality (stability, performance, scalability, etc.) and they need to actually enable useful features to be built. A good rule of thumb when building platform is to build it with your first consumer, i.e. have another team simultaneously building a feature on your platform while you’re developing it — this way, you guarantee the platform actually enables useful features.

### 9. Feedback Loops

Cause and effect in products are the result of systems connected by positive and negative feedback loops.

![](https://cdn-images-1.medium.com/max/800/1*eIrnHqDy24SmYTM5VT9uBw.png)

#### How it’s useful

Feedback loops help us remember that some of the biggest drivers of growth or decline for a product may be from other parts of the system.

For example, say you’re the payments team and your KPI is to grow total credit card payments processed. You have a positive feedback loop with the user acquisition team because as they grow users, you have more potential users that will pay with credit cards. However, you have a negative feedback loop with the cash payments team, who are trying to help users more easily to transact through cash.

Knowing these feedback loops can help you change strategy (e.g. you may choose to work on general user acquisition as the best way to grow payment volume), or understand negative changes in your metrics (e.g. credit card payment volume is down, but it’s because the cash payments team is doing really well, not because the credit card products suck).

### 10. Flywheel (recursive feedback loop)

A state where a positive or negative feedback loop is feeding on itself and accelerating from it’s own momentum.

![](https://cdn-images-1.medium.com/max/800/1*dQZTwGbDzYxyehti9NdUNg.png)

#### How it’s useful

Flywheels are a related concept to feedback loops, but are important for managing platforms and marketplaces. For example, imagine you run Apple’s iOS app platform. You have two users: app developers, and app users.

The flywheel is the phenomenon where more app users attract more app developers (because there is more opportunity to sell), which in turn attract more app users (because there are more apps to buy), which in turn attract more app developers, and so on. As long as you nurture the flywheel, not only will you grow, but you’ll grow at an accelerating rate.

If you’re managing a flywheel, you have to do everything you can to keep it spinning in the positive direction, because it’s just as powerful the other way. For example, if there are so many apps on the platform that new apps can’t get discovered anymore, app developer growth will slow and break the flywheel — you need to solve that.

* * *

**_Building & Iterating _— **the next set of mental models are useful for when you’re building, operating, and iterating an existing product.

### 11. Diminishing Returns

When you focus on improving the same product area, the amount of customer value created over time will diminish for every unit of effort.

![](https://cdn-images-1.medium.com/max/800/1*4Mk9GlI3Wze0M80vwdIpqA.png)

#### How it’s useful

Assuming you are effectively iterating the product based on customer feedback and research, you will eventually hit a point where there’s just not that much you can do to make it better. It’s time for your team to move on and invest in something new.

### 12. Local Maxima

Related to _diminishing returns_, the local maxima is the point where incremental improvements creates no customer value at all, forcing you to make a step change in product capabilities.

![](https://cdn-images-1.medium.com/max/800/1*G5jRnVstTrkTKcFVLozunw.png)

#### How it’s useful

This mental model is tightly related to diminishing returns, with the addition of hitting a limit where it literally makes no material difference to keep improving something. _Iteration_ now serves no purpose, and and the only way to progress is to _innovate._

This concept was recently popularized by Eugene Wei’s viral post [Invisible Asymptotes](http://www.eugenewei.com/blog/2018/5/21/invisible-asymptotes), which covers an example like this that Amazon foresaw which led them to create Prime.

### 13. Version two is a lie

When building a product, don’t bank on a second version ever shipping. Make sure the first version is a complete product because it may be out there forever.

![](https://cdn-images-1.medium.com/max/800/1*m2032S9-aWtyxgLnKwBCdg.png)

When software was sold on shelves, teams had to live with version 1 forever.

#### How it’s useful

When you’re defining the first version of your product, you will accumulate all sorts of amazing features that you dream of adding on later in future versions. Recognize that these may never ship, because you never know what can happen: company strategy changes, your lead engineer quits, or the whole team gets reallocated to other projects.

To hedge against these scenarios, make sure that whatever you ship is a “complete product” which, if it was never improved again, would still be useful to customers for the foreseeable future. Don’t ship a feature that relies on future improvements in order to actually solve the problem well.

### 14. Freeroll

A situation where there is little to lose and lots of gain by shipping something fast.

![](https://cdn-images-1.medium.com/max/800/1*eSuVg7xMVDoUCXtCEmrsrA.jpeg)

#### How it’s useful

_Freerolls_ typically emerge in product when the current user experience is so bad that by making any reasonable change based on intuition is likely to make it much better. They are different than fixing bugs because bugs refer to something that’s not working as designed.

If you’re in a situation where your team is thinking, _“Let’s just do something… we can’t really make it any worse”_, you likely have a freeroll in front of you.

([r/CrappyDesign](https://www.reddit.com/r/CrappyDesign/) on Reddit is a treasure trove of such situations)

### 15. Most value is created after version one

You will learn the most about the customer after you launch the product, don’t waste the opportunity to build on those learnings.

![](https://cdn-images-1.medium.com/max/800/1*20d6A7nktJGqINckdVSelQ.png)

#### How it’s useful

Everything is a hypothesis until customers are using the product at scale. While what your team invests in “pre-launch learning” — the customer interviews, prototype testing, quantitative analysis, beta testing, etc. — can give you a massive leg up on the probability of being right, there are always behaviours and edge cases that emerge once you ship the feature to 100% of customers.

As a percentage of customer insight learned, you will gain the majority of learning _after_ launch. To not investing accordingly by iterating the product (sometimes drastically), doesn’t make sense with that in mind.

### 16. Key Failure Indicator (KFI)

Pairing your Key Performance Indicators (KPIs) with metrics you _don’t_ want to see go in a certain direction, to ensure you’re focused on healthy growth.

![](https://cdn-images-1.medium.com/max/800/1*ks8KCX4L9LVP88fiJzb_xQ.png)

#### How it’s useful

Teams often choose KPIs that directly reflect the positive outcomes they’re looking for, without considering the negative ways that those outcomes could be achieved. Once they start optimizing for those KPIs, they actually create output that is net bad for the company.

A classic example is a team thinking they’re successful when doubling sign-up conversion on the landing page, only to observe (far too late) that the number of total customers isn’t growing because the conversion rate dropped by 60% due to the same change.

KFIs keep your team’s performance in check, and make sure that you only create net-healthy outputs for the company.

**Examples of popular KPI <> KFI pairings are:**

1.  Grow revenue while maintaining gross margin
2.  Grow adoption of feature A without taking away adoption of feature B
3.  Grow adoption of feature A without increasing support load

* * *

### A latticework, not a checklist

It may be unsatisfactory to many readers, but as far as I can tell there is no methodology for using these mental models. If you try and use them as a checklist — going through each and seeing if they apply them — you will end up doing to mental gymnastics that will confuse and frustrate you and those around you.

Instead, they simply become part of your latticework, helping you make better decisions about product, and giving you the language to communicate the why behind complex decisions to your team.

As you accumulate more models, ideally through experience, the better you will get.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
