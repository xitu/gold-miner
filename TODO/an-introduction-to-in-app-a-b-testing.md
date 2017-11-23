> * 原文地址：[An introduction to in-app A/B testing: How A/B testing can help you get more out of your app](https://medium.com/googleplaydev/an-introduction-to-in-app-a-b-testing-c5a9a69a3791)
> * 原文作者：[Gavin Kinghall Were](https://medium.com/@gavink?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/an-introduction-to-in-app-a-b-testing.md](https://github.com/xitu/gold-miner/blob/master/TODO/an-introduction-to-in-app-a-b-testing.md)
> * 译者：
> * 校对者：

# An introduction to in-app A/B testing

## How A/B testing can help you get more out of your app

A/B testing is a controlled experimentation method that compares two or more variants so a hypothesis may be confirmed or refuted. The test isolates the specific test variants from the rest of the system to generate reliable results. A/B testing is most effective when performed in a live environment when the test population is unaware the test is running.

![](https://cdn-images-1.medium.com/max/600/1*Yy0xUTqhw0-VX7rxIDNNPw.png)

Leveraging a representative sample population for each variant, an A/B testing platform randomly exposes each user to variant A or variant B, or excludes them from the test. It then ensures each user sees a consistent experience (always A or always B) for the lifetime of the test and provides additional metadata to an analytics platform to determine the effect on metrics. Once the metrics are analysed and a variant chosen as the best performer, you can use the A/B testing platform to incrementally roll out the winning variant to all users.

For example, you may hypothesize that [bottom navigation](https://material.google.com/components/bottom-navigation.html) will drive more user engagement than [tabs](https://material.google.com/components/tabs.html) in your app. You can design an A/B test comparing your tabs (variant A) with a bottom navigation (variant B). Your A/B testing platform then generates a user-base sample that is randomly and representatively allocated to variant A or variant B, and each user continues to see the same variant for the duration of the test. When the test is over, variant A user engagement can be compared to that of variant B to see if there is a [statistically significant](https://en.wikipedia.org/wiki/Statistical_significance) improvement for variant B. If variant B is better, you have the data to back your decision to move to bottom navigation for all users.

![](https://cdn-images-1.medium.com/max/600/1*zQPA1R3det25wJDZ6zdWxw.png)

![](https://cdn-images-1.medium.com/max/600/1*sjA3GNa2KIsqHom-ubhebg.png)

Left — Variant A, Tabs; Right — Variant B, Bottom Navigation

> **_A note on store listing experiments in the Google Play Console_**

> The Google Play Console also supports a form of A/B testing on your store listing, which I’m not focusing on in this post. [Store listing experiments](https://developer.android.com/distribute/users/experiments.html), let you test different icons, feature graphics, promo videos, short descriptions and long descriptions on your store listing to see if you can increase your installs. Store listing experiments are focused on improving conversions whereas the remainder of my post discusses in-app A/B testing targeted at improving post-install metrics such as user retention, user engagement and in-app purchase revenue.

In my post, I’ll take your through the five key steps of in-app A/B testing:

1.  Construct your hypothesis
2.  Integrate an A/B testing platform
3.  Test your hypothesis
4.  Analyse and draw conclusions
5.  Take action

Then, I’ll also touch on more advanced techniques you can explore.

### Step 1. Construct your hypothesis

A hypothesis is a proposed explanation for a phenomenon, and A/B testing is a method for determining whether or not the hypothesis is true. The hypothesis may arise by examining existing data, it may be more speculative, or it may be ‘just a hunch.’ (The ‘hunch’ hypothesis is particularly common for new features that enable new metrics.) In the navigation example, the hypothesis could be articulated in this way: ‘Switching to bottom navigation instead of tabs will increase user engagement’. You can then use this hypothesis to inform your decision about what, if any, change to make in the navigation style of your app, and what effect that change will have on user engagement. The important thing to remember is that the only purpose of the test is to prove that bottom navigation has a direct, positive impact on average revenue per user (or ARPU).

#### What to test (What is A? What is B? Etc.)

The following table outlines broad scenarios that can help you determine how to choose what variants to test. I’ll use our hypothetical navigation experiment as an example.

![](https://cdn-images-1.medium.com/max/1000/1*fY2cSb5ZzM0xmWy0J3SbRA.png)

1 The ‘Excluded from test’ column represents the users who aren’t included in the test; their behaviour will not contribute to the test outcome. See Who to test on.

The choice between scenarios 2 and 3 is based on what the hypothesis is trying to measure. If it’s something only relevant to the new feature (e.g., if the new feature is in-app purchases, then in-app purchase revenue as a measure is only relevant if that feature is implemented), then choose scenario 2\. If the hypothesis relates to something that’s relevant (and measurable) before the new feature is implemented (e.g., if the new feature is a ‘favourites’ mechanism and the measure is user engagement), then choose scenario 3.

> **Note:** In the following sections up to Take Action, I’ll use Scenario 1 for the sake of brevity. The same method is equally applicable to Scenarios 2 and 3 with the ‘existing’ and ‘new’ variants replacing the ‘new 1’ and the ‘new 2’ variants.

#### Who to test on

If the observed behaviour is known to vary by some factor outside of the hypothesis — for example, the behaviour is known to vary by country of residence when the hypothesis is only looking at the global effect on revenue — target a single value for that factor (a single country) or use a representative sample of the whole population (all countries).

The size of the controlled, representative sample can also be defined as a percentage of the total population. For example, 10% of the total population is included in the test — with 5% receiving variant A and 5% getting variant B, and the remaining 90% excluded from the test. The 90% sees either the existing feature implementation or no new features at all, and their behaviour is excluded from the test metrics.

#### How long to test for

**Maximum time:** User behaviour often varies by time of day, day of week, month, season, etc. To capture enough of this variance, you’ll want to balance the need for statistical significance and the business need. (Your business may not be able to wait for statistical completeness.) If it’s known that a specific metric varies over a shorter period — such as time of day or day of week — then try to cover the entirety of that period. For longer periods, it may be more beneficial to run a test for only a couple of weeks and extrapolate based on the known variation in the metric over time.

**Minimum time:** The test should run long enough to capture enough data to provide a statistically significant result. This typically means a test population of 1,000 users (at a minimum). But reaching a significant result depends on the typical distribution of the metric derived from the hypothesis. You can do this in a reasonable amount of time by estimating how many users are eligible for testing in the desired time period, and then choosing a percentage of that population to include so your test achieves statistical significance within that time. Some A/B testing platforms manage this automatically and may also allow you to increase the test sample rate to reach statistical significance sooner.

### Step 2. Integrate an A/B testing platform

![](https://cdn-images-1.medium.com/max/600/1*8iHKjuY5xYGOaQTM6BEqGg.png)

Several A/B testing platforms already exist, either as standalone products or as components of broader analytics platforms, such as [Firebase Remote Config with Analytics](https://firebase.google.com/docs/remote-config/config-analytics). Via a client-side library, the platforms send the app a set of configuration instructions. The app doesn’t know _why_ a certain parameter value was returned and, therefore, has no knowledge about what test it is a part of or even whether it is part of a test at all. The client should just configure itself as it is told. On the other hand, the platform doesn’t concern itself with the meaning of each parameter value it returns to the client; it’s up to the client to interpret that value. In the simplest of cases, the returned parameter could be simple key-value pairs that control whether a given feature is enabled and, if so, which variant should be activated.

In more advanced cases, where extensive remote app configuration is needed, the app may send parameters to the A/B testing platform that may be used to decide more finely-grained test eligibility. For example, if a hypothesis relates only to devices with xxxhdpi screen density, then the app will need to send its screen density to the A/B testing platform.

#### Don’t re-invent the wheel

Pick an existing platform that will scale with your A/B testing needs. Beware: A/B testing and the data-driven decision-making it enables is habit-forming.

> **Note:** Managing consistent test state and fairly allocating test participants for many users and many tests is **hard**. There’s no need to write it from scratch.

It is, of course, necessary to write the code for each variant you want to test. However, it should not be up to the app or some custom service to decide which variant to use at any given time. This should always be left to the A/B testing platform so a standard methodology can be applied and multiple, simultaneous tests on the same population can be managed centrally. Writing a simple A/B test mechanism manually only makes sense if you know for a fact you’re only going to perform one test. For the cost of hard coding two tests, you could integrate an off-the-shelf A/B testing platform.

#### Integration with analytics

So you can automatically segment the population under test, pick an analytics platform that can provide detailed, test-state information directly to your existing analytics platform. The tightest integration mechanism relies on the specific configurations for each test and the variants being passed directly between the A/B testing and analytics platforms. A globally unique reference is assigned to each variant and passed by the A/B testing platform to both the client and the analytics platform. Then, this allows the client to only need to pass that reference to the analytics platform, rather than the entire configuration of the variant.

#### Remote configuration

Apps that have a remote configuration capability already have most of the code needed to implement A/B testing. Essentially, the A/B test adds some server-side rules that determine what configuration is sent to the app. For apps that don’t have a remote configuration capability, an A/B testing platform is a great way to introduce one.

### Step 3. Test the hypothesis

Once your hypothesis is identified, your test designed, and your A/B testing platform integrated, implementing your test variants is the easiest step. Next, run your test. The A/B testing platform allocates a sample set of users to the test population and then to each variant within the test. The platform then continues to allocate populations for the desired test period. For more advanced platforms, the platform will run your test until it has reached statistical significance.

#### Monitor the test

During the course of the test, I recommend monitoring the impact of new variants, including metrics not mentioned in the test hypothesis. If you observe a detrimental effect, it may be necessary to stop the test early so your users are reverted back to the existing variant as quickly as possible — and you minimise a poor user experience. Some A/B testing platforms are capable of monitoring and alerting automatically if a test is having an unexpectedly negative impact. Otherwise, any impact seen in your pre-existing monitoring systems will need to be cross-referenced with existing tests so that the ‘bad’ variant can be identified.

> **Note:** If the test does need to be stopped early, the data you gather should be treated with extreme caution as there’s no guarantee that the test population sample is representative.

### Step 4. Analyse and draw conclusions

Once the test has ended normally, the data gathered by your analytics platform can be used to determine the outcome of the test. If the hypothesis is verified by the resulting metrics, then you can conclude the hypothesis is correct. Otherwise, it is not. Determining whether the observed result is [statistically significant](https://en.wikipedia.org/wiki/Statistical_significance) depends upon the nature and distribution of the metric.

If the hypothesis is false — because there’s no effect or a negative effect on the relevant metric(s) — then there’s no reason to keep the new variant. It may be the case, however, that the new variant had a positive effect on a related, but unexpected metric. This may be a valid reason to choose the new variant, although it’s often useful to run an additional test specifically targeting the secondary metric to confirm the effect. In fact, the result of one experiment often gives rise to additional questions and hypotheses.

### Step 5. Take action

If the hypothesis is true, and the new variant is preferred to the old, the ‘default’ configuration parameters being passed back to the app can be updated to instruct it to use the new variant. Once the new variant has become the default for a sufficient amount of time, the code and resources for the old variant can be removed from the app in your next release.

#### Incremental rollout

A common use case for A/B testing platforms is to re-purpose them as an incremental rollout mechanism, where the winning variant of the A/B test gradually replaces the old variant for all users. This can be viewed as an A/B design test, whereas the incremental rollout is a Vcurr/Vnext test to confirm that the chosen variant causes no adverse effects on a larger segment of your user base. Incremental rollout can be performed by stepping up the percentage of users (for example, you can go from 0.01%, 0.1%, 1%, 3%, 7.5%, 25%, 50%, 100%) receiving the new variant and checking that no adverse results are observed before advancing to the next step. Other segments can be used as well, including country, device type, user segment, etc. You can also choose to roll out the new variant to specific user groups (e.g., internal users).

### Advanced experimentation

You can build on simple A/B testing to, for example, support a deeper understanding of the range of user behaviour. You can also gain more efficiency by running multiple tests in parallel and by comparing many variants in a single test.

#### Deep segmentation and targeting

A/B test results can be examined for changes in outcome across different segments as well as analysed for targeting methodology. In both cases, it may be necessary to increase the sample rate or duration of the test to achieve statistical significance for each unique segment. For example, the results of testing the [tabs versus bottom navigation hypothesis](https://uxplanet.org/perfect-bottom-navigation-for-mobile-app-effabbb98c0f) may show a different effect on a country-by-country basis; in other cases, some countries may show a big user engagement increase, some show no change, and some show a slight decrease. In these scenarios, the A/B testing platform could set a different ‘default’ variant on a country-by-country basis to maximise total user engagement.

The same segmentation data may be used to target a test at only a specific segment. For example, you could test for users who live in the USA and who previously used a particular feature found in the tab navigation style.

#### A/n testing

An A/n test is shorthand for a test with more than two variants. This may be several new variants to replace an existing variant or several variants of an entirely new feature, plus the absence of any new feature. When combined with deep segmentation, you may find different variants perform best with different segments.

#### Multi-variate testing

A multi-variate test is a single test that varies many aspects of an app at once. It then treats each unique set of values as a separate variant in an A/n test. For example:

![](https://cdn-images-1.medium.com/max/800/1*DbBtyfDwZwCLPbFD2eIMVg.png)

Multi-variate tests are appropriate when there are several related aspects that could affect the overall performance of a metric, but the effect of specific aspects isn’t distinguishable.

#### Testing at scale

Multiple tests running in parallel on the same population must be managed by the same platform. Some platforms are capable of scaling to thousands of tests running in parallel, some completely in isolation (so a user is only in that one test at a time), and some on a shared population (so a user is in multiple tests simultaneously). The former case is easier to manage but will quickly exhaust the test population and lead to an upper bound on the number of statistically significant parallel tests. The latter case is harder for the A/B testing platform to manage, but removes the upper bound on the number of parallel tests. The platform does this by fundamentally treating each test as additional segmentation outside of each other test.

#### Self opt-in

Self opt-in allows a user to knowingly be exposed to a specific variant of a specific test. The user could self-select the variant or be allocated it by the A/B testing platform. In either case, the user should be excluded from the metrics analysis as they are not a blind participant in the test — they know it’s a test, so they could show a biased response.

### Conclusion

In-app A/B testing is an extremely flexible tool for making data-driven decisions about your app and, as I’ve highlighted in this article, can help you make informed choices about new features. A/B testing allows you to test variants of any aspect of your app with real users in the real world. To simplify in-app A/B testing design, integration, execution and analysis, Google offers a suite of tools, including:

*   [Firebase Remote Config](https://firebase.google.com/docs/remote-config/) (FRC) offers a client library that allows apps to request and receive a configuration from Firebase, plus a cloud-side, rule-based mechanism to define user configuration. Remote configuration can help you update (and upgrade) your app without the need to release a new version.
*   [Firebase Remote Config with Analytics](https://firebase.google.com/docs/remote-config/config-analytics) enables the formal use of A/B testing methods for deciding and tracking variant deployment.
*   [Firebase Analytics](https://firebase.google.com/docs/analytics/) give you a metrics breakdown by variant and connects directly into FRC.

* * *

#### What do you think?

Do you have questions or thoughts on using A/B testing? Continue the discussion in the comments below or tweet using the hashtag #AskPlayDev and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.

* * *

**Remember:** Analysis is crucial when it comes to A/B testing. Together, A/B testing and analysis can give you the insight you need to drive your app’s future design and development and maximise its performance.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
