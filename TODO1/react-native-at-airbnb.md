> * 原文地址：[React Native at Airbnb](https://medium.com/airbnb-engineering/react-native-at-airbnb-f95aa460be1c)
> * 原文作者：[Gabriel Peal](https://medium.com/@gpeal?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-at-airbnb.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-at-airbnb.md)
> * 译者：
> * 校对者：

# React Native at Airbnb

##In 2016, we took a big bet on React Native. Two years later, we’re ready to share our experience with the world and show what’s next.

![](https://cdn-images-1.medium.com/max/2000/1*P9Kc_EWojKpqfc1-_AhnSg.jpeg)

Years later, it’s still possible to book a meeting in our Airstream

_This is the first in a series of blog posts in which we outline our experience with React Native and what is next for mobile at Airbnb._

When Airbnb launched 10 years ago, smartphones were in their infancy. Since then, smartphones have become an essential tool to navigate our everyday lives, especially as more and more people travel around the globe. As a community that enables new forms of travel for millions of people, having a world-class app is crucial. Mobile devices are oftentimes their primary or only form of communication while away from home.

Since our first three guests stayed in Rausch Street in 2008, mobile usage has increased from zero to millions of bookings per year. Our apps give hosts the ability to manage their listings on the go and provide travelers with inspiration to discover new places and experiences right at their fingertips.

To keep up with the accelerated pace of mobile usage, we’ve grown our team to more than 100 mobile engineers to enable new experiences and improve existing ones.

### Placing a Bet on React Native

We are continually evaluating new technologies to enable us to improve the experience of using Airbnb for guests and hosts, move quickly, and maintain a great developer experience. In 2016, one of those technologies was React Native. Back then, we recognized how important mobile was becoming to our business but simply didn’t have enough mobile engineers to reach our goals. As a result, we began to explore alternative options. Our website is built primarily with React. It has been a highly effective and universally liked web framework within Airbnb. Because of this, we saw React Native as an opportunity to open up mobile development to more engineers as well as ship code more quickly by leveraging its cross-platform nature.

When we began investing in React Native, we knew that there were risks. We were adding a new, fast-moving and unproven platform to our codebase that had the potential to fragment it instead of unifying it. We also knew that if we were going to invest in React Native, we wanted to do it right. Our goals with React Native were:

1.  Allow us to **move faster** as an organization.
2.  Maintain the **quality bar** set by native.
3.  Write product code **once** for mobile instead of **twice**.
4.  Improve upon the **developer experience**.

### Our Experience

Over the past two years, that experiment turned into a serious effort. We have built an incredibly strong integration into our apps to enable complex native features such as shared element transitions, parallax, and geofencing as well as bridges to our existing native infrastructure such as networking, experimentation, and internationalization.

We have launched a number of critical products for Airbnb using React Native. React Native enabled us to launch [Experiences](https://www.airbnb.com/s/experiences), an entirely new business for Airbnb, as well as dozens of other features from reviews to gift cards. Many of these features were built at a time where we simply did not have enough native engineers to achieve our goals.

Different teams had a wide range of experiences with React Native. React Native proved to be an incredible tool at times while posing technical and organizational challenges in others. In this series, we provide a detailed account of our experiences with it and what we’re doing next.

[In part two](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838), we enumerate what worked and what didn’t with React Native as a technology.

[In part three](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88), we enumerate some of the organizational challenges associated with building a cross-platform mobile team.

[In part four](https://medium.com/airbnb-engineering/sunsetting-react-native-1868ba28e30a), we highlight where we stand with React Native today and what its future at Airbnb looks like.

[In part five](https://medium.com/airbnb-engineering/whats-next-for-mobile-at-airbnb-5e71618576ab), we take our top learnings from React Native and use them to make native even better.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
