> * 原文地址：[Sunsetting React Native](https://medium.com/airbnb-engineering/sunsetting-react-native-1868ba28e30a)
> * 原文作者：[Gabriel Peal](https://medium.com/@gpeal?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/sunsetting-react-native.md](https://github.com/xitu/gold-miner/blob/master/TODO1/sunsetting-react-native.md)
> * 译者：
> * 校对者：

# Sunsetting React Native

## Due to a variety of technical and organizational issues, we will be sunsetting React Native and putting all of our efforts into making native amazing.

![](https://cdn-images-1.medium.com/max/2000/1*8c-9hgBkRGcllO9CHcTzbQ.jpeg)

_This is the fourth in a_ [_series of blog posts_](https://medium.com/airbnb-engineering/react-native-at-airbnb-f95aa460be1c) _in which we outline our experience with React Native and what is next for mobile at Airbnb._Where are we today?

Although many teams relied on React Native and had planned on using it for the foreseeable future, we were ultimately unable to meet our original goals. In addition, there were a number of [technical](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838) and [organizational](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88) challenges that we were unable to overcome that would have made continuing to invest in React Native a challenge.

As a result, moving forward, we are **sunsetting React Native at Airbnb** and reinvesting all of our efforts back into native.

### Failing to Reach Our Goals

#### Move Faster

When React Native worked as intended, engineers were able to move at an unparalleled speed. However, the numerous [technical](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838) and [organizational](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88) issues that we outlined in this series added frustrations and unexpected delays to many projects.

#### Maintain the Quality Bar

Recently, as React Native matured and we accumulated more expertise, we were able to accomplish a number of things that we weren’t sure were possible. We built shared element transitions, parallax, and were able to dramatically improve the performance of some screens that used to frequently drop frames. However, some [technical challenges](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838) such as initialization and the async first render made meeting certain goals challenging. The lack of resources internally and externally made this even more difficult.

#### Write Code Once Instead of Twice

Even though code in React Native features was almost entirely shared across platforms, only a small percentage of our app was React Native. In addition, large amounts of bridging infrastructure were required to enable product engineers to work effectively. As a result, we wound up supporting code on three platforms instead of two. We saw the potential for code sharing between mobile and web and were able to share a few npm packages but beyond that, it never materialized in a meaningful way.

#### Improve the Developer Experience

The developer experience with React Native was a mixed bag. In some ways, such as build times, things were dramatically better. However, in others, such as debugging, things were much worse. The details are enumerated in [part 2](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838) in this series.

### Sunset Plan

Because we weren’t able to achieve our specific goals, we have decided that React Native isn’t right for us anymore. We are currently in the process of working with teams to create a healthy transition plan. We have halted all new React Native features and have plans to transition the majority of the highest-trafficked screens to native by the end of the year. This was aided by some scheduled redesigns that were going to happen regardless. Our native infrastructure team will support React Native through 2018. In 2019, we will begin to ramp down support and reduce some of the React Native overhead such as initializing the runtime on launch.

At Airbnb, we are strong believers in open source. We actively use and contribute to many open source projects around the world and have open sourced some of our React Native work as well. As we have moved away from React Native, we haven’t been able to maintain our React Native repos as well as the community deserves. To do what’s best for the community, we will be migrating some of our React Native open source work to [react-native-community](https://github.com/react-native-community) which we have already begun to do with [react-native-maps](https://github.com/react-community/react-native-maps) and will do with [native-navigation](https://github.com/airbnb/native-navigation) and [lottie-react-native](https://github.com/airbnb/lottie-react-native/).

### It is not all bad

Although we weren’t able to achieve our goals with React Native, engineers who used React Native generally had a positive experience. Of these engineers:

*   60% would describe their experience as amazing.
*   20% were slightly positive.
*   15% were slightly negative.
*   5% were strongly negative.

63% of engineers would have chosen React Native again given the chance and 74% would consider React Native for a new project. It is worth noting that there is inherent selection bias in these results since it only surveys people who chose to use React Native.

These engineers wrote 80,000 lines of product code across 220 screens as well as 40,000 lines of javascript infrastructure. For reference, we have about 10x the amount of code and 4x the number of screens on each native platform.

### React Native is Maturing

This series of posts reflects our experiences with React Native as of today. However, Facebook and the broader React Native community are dedicated to making React Native work for hybrid apps at scale. React Native is progressing faster than ever. There have been over 2500 commits in the last year and Facebook [just announced](https://facebook.github.io/react-native/blog/2018/06/14/state-of-react-native-2018) that they are addressing some of the technical challenges we faced head-on**.** Even if we will no longer be investing in React Native, we’re excited to continue following these developments because technical wins in React native translate to real-world wins for the people around the world who use our products.

### Takeaways

We integrated React Native into large existing apps that continued to move at a very fast pace. Many of the difficulties we encountered were due to the hybrid model approach we took. However, our scale allowed us to take on and solve some difficult problems that smaller companies may not have had time to solve. Making React Native work seamlessly with native is possible but challenging. Every company that uses React Native will have an experience that is a unique function of their team composition, existing app, product requirements, and maturity of React Native.

When everything came together, which it did for many features, the iteration speed, quality, and developer experience matched or surpassed all of our goals and expectations. At times, it really felt like we were on the verge of changing the game for mobile development. Even though these experiences were highly encouraging, when we balanced the positives against the pain points plus the current needs and resources of our Engineering organization, we decided that it wasn’t right for us anymore.

Deciding whether to use a new platform is a major decision and depends entirely on factors unique to your team. Our experiences and reasons for moving away may not apply to your team. In fact, [many](https://medium.com/@Pinterest_Engineering/supporting-react-native-at-pinterest-f8c2233f90e6) [companies](https://instagram-engineering.com/react-native-at-instagram-dd828a9a90c7) are continuing to successfully use it today and it may still be the best choice for many others.

Although we have never stopped investing in native, sunsetting React Native frees up even more resources to make native better than ever. Follow along in the [next part](https://medium.com/airbnb-engineering/whats-next-for-mobile-at-airbnb-5e71618576ab) of this series to learn what’s new in native for us.

* * *

This is part four in a series of blog posts highlighting our experiences with React Native and what’s next for mobile at Airbnb.

*   [Part 1: React Native at Airbnb](https://medium.com/airbnb-engineering/react-native-at-airbnb-f95aa460be1c)
*   [Part 2: The Technology](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838)
*   [Part 3: Building a Cross-Platform Mobile Team](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88)
*   [_Part 4: Making a Decision on React Native_](https://medium.com/airbnb-engineering/sunsetting-react-native-1868ba28e30a)
*   [Part 5: What’s Next for Mobile](https://medium.com/airbnb-engineering/whats-next-for-mobile-at-airbnb-5e71618576ab)

Thanks to [Laura Kelly](https://medium.com/@laura.kelly_61928?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
