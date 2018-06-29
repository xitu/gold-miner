> * 原文地址：[Building a Cross-Platform Mobile Team: Adapting mobile for a world with React Native](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88)
> * 原文作者：[Gabriel Peal](https://medium.com/@gpeal?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-cross-platform-mobile-team.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-cross-platform-mobile-team.md)
> * 译者：
> * 校对者：

# Building a Cross-Platform Mobile Team

## Adapting mobile for a world with React Native

![](https://cdn-images-1.medium.com/max/2000/1*3WNSZyXGOWKJyPT9r8VY8Q.jpeg)

_This is the third in a_ [_series of blog posts_](https://medium.com/airbnb-engineering/react-native-at-airbnb-f95aa460be1c) _in which we outline our experience with React Native and what is next for mobile at Airbnb._

In addition to the countless technical pros and cons of React Native, we learned a ton about what React Native means for an engineering organization. Adopting it is much more complex than adding a new library or pattern to an existing platform. Doing so brought to light a number of organizational challenges. Unlike technical challenges which can often be solved or effectively worked around, organizational challenges can be harder to detect, correct for, and recover from. Thankfully, our mobile culture is healthy but there are a number of things to be aware of when considering React Native.

#### React Native is Polarizing

In our experience, engineers approached React Native with wildly different opinions varying from praising it as a silver bullet that united Android, iOS, and web to being wholly against any use of React Native on their team. The same situation occurred after using it as well. Some teams had an incredible experience while others regretted it and reverted back to native.

#### Root Cause Attribution

While working on React Native, there were inevitable bugs, polish, and performance issues. However, there were many moving pieces:

1.  React Native itself moves quickly.
2.  We were doing simultaneous infrastructure and feature development.
3.  Engineers were learning React Native together and it was relatively new for everybody.
4.  Our documentation and guidance for debugging in development and production was inconsistent at times and could be confusing.

As a result, it was often difficult to find the root cause of a problem. Sometimes, it wasn’t clear which team an issue should be attributed or whether the issue was inherent to React Native.

#### React Native is Still Native

A common misconception is that React Native allows you to move away from writing native code entirely. However, that is not the current state of the world. The native foundation of React Native still rears its head at times. For example, text is rendered slightly differently on each platform, keyboards are handled differently, and Activities are recreated on rotation by default on Android. A high-quality React Native experience requires a careful balance of both worlds. This, paired with the difficulty of having balanced expertise on all three platforms makes shipping a consistently high-quality experience difficult.

#### Debugging Across Platforms

Most engineers are proficient at one or two platforms. It is exceedingly rare for somebody to be highly competent in Android, iOS, and React. Even though the vast majority of work in a mature React Native environment is done with JavaScript and React, there are times when building or debugging something requires digging into native. These situations can lead to engineers getting stuck way out of their expertise trying to debug an issue on a platform they have never used. This is made worse when an engineer isn’t even sure where to look due to the difficulty of root cause attribution.

#### Hiring

Even though we were investing in React Native, our mobile ambitions and teams continued to accelerate in parallel. However, through word of mouth in the community, many people began to associate Airbnb with React Native and some even believed that our app was 100% React Native. Even though this was far from the truth, many Android and iOS engineers were hesitant to apply to Airbnb as a result. Just in case you are one of them, [we are still hiring](https://www.airbnb.com/careers/departments/engineering)!

#### Hybrid Apps Are Hard

The path of a world that is 100% native or 100% React Native is relatively straightforward. However, once you have a mix within your codebase, many new issues arise. How do you split up your teams? How do teams collaborate? How do you share state across your app? How do you ensure that things get tested? How do engineers effectively debug across three platforms? How do you decide what platform to use for a new feature? How do you hire and allocate resources across your organization? These are all problems with non-trivial solutions that will inevitably arise if you go down this path.

#### Three Development Environments

In order to be an effective React Native engineer, it is important to have a stable and up-to-date React Native, Android, and iOS environment. For an organization as large as Airbnb, each platform requires a significant amount of time to set up, learn, and keep up to date. Returning after just a few weeks often meant spending several hours getting everything back up to date.

#### Balancing Native vs React Native

There are many situations in which the optimal solution for a problem spans native and React Native. For example, our navigation implementation makes heavy use of Activities and ViewControllers and most of its code is native to each platform. Often times, it is not clear whether code should be written in native or React Native. Naturally, an engineer will often choose the platform that they are more comfortable which can lead to unideal code.

#### Cross-Platform Testing

We found that engineers would primarily develop on one platform over the other due to convenience or comfort. Often, they would assume that if it works on the platform they tested on, it would work perfectly on the other. Most of the time, this was true which is a testament to the power of React Native. However, it was untrue often enough that it ended up causing frequent issues late in QA cycles or in production.

#### Split Teams

Teams that worked in native as well as React Native often faced both technical and communication challenges. Once the codebase was split between native and React Native, the code became fragmented. Sharing business logic, models, state, etc. became more challenging and engineers no longer had the expertise to work across the entire flow. We knew that this would happen from the get-go but thought that this might be balanced by an increased collaboration with web. A few teams did start to share resources and code across web and mobile but most weren’t able to realize this potential benefit.

#### Perceived Iteration Speed

One of our qualitative goals with React Native was to increase development speed. Often, React Native features were written by a single engineer instead of one for each platform. From the perspective of a React Native engineer, if it takes them 50% longer to write their feature than it would on Android or iOS, it feels longer to them even if it takes fewer hours overall.

#### Public Resources and Documentation

Android and iOS have had ten years and millions of engineers contributing to learning resources, open source, and online help. We leverage many resources such as [CodePath](https://codepath.com/androidbootcamp) to help people learn Android and iOS. Even though React Native has one of the largest cross-platform communities and can leverage React resources, it is still much smaller than Android and iOS. That paired with the fact that we had to build most of our infrastructure in-house meant that our limited React Native resources were over-invested in education and training relative to native.

* * *

This is part three in a series of blog posts highlighting our experiences with React Native and what’s next for mobile at Airbnb.

*   [Part 1: React Native at Airbnb](https://medium.com/airbnb-engineering/react-native-at-airbnb-f95aa460be1c)
*   [Part 2: The Technology](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838)
*   [_Part 3: Building a Cross-Platform Mobile Team_](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88)
*   [Part 4: Making a Decision on React Native](https://medium.com/airbnb-engineering/sunsetting-react-native-1868ba28e30a)
*   [Part 5: What’s Next for Mobile](https://medium.com/airbnb-engineering/whats-next-for-mobile-at-airbnb-5e71618576ab)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
