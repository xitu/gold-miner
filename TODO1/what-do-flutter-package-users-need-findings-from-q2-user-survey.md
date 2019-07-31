> * 原文地址：[What do Flutter package users need? Findings from Q2 user survey](https://medium.com/flutter/what-do-flutter-package-users-need-6ecba57ed1d6)
> * 原文作者：[Ja Young Lee](https://medium.com/@jayoung.lee)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-do-flutter-package-users-need-findings-from-q2-user-survey.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-do-flutter-package-users-need-findings-from-q2-user-survey.md)
> * 译者：
> * 校对者：

# What do Flutter package users need? Findings from Q2 user survey

![A word cloud made with the Q2 survey comments](https://cdn-images-1.medium.com/max/3200/0*JGPtcSX7QYbN8Dvn)

> A word cloud made with the Q2 survey comments ☁️ (link to the original [image](https://raw.githubusercontent.com/timsneath/wordcloud_flutter/master/flutter_wordcloud.png), [code](https://github.com/timsneath/wordcloud_flutter))

We recently ran our sixth quarterly user survey and collected responses from over 7,000 Flutter users. We found that 92.5% of the respondents are satisfied or very satisfied, which is slightly higher than the [last quarter](https://medium.com/flutter/insights-from-flutters-first-user-survey-of-2019-3659b02303a5)! We are thrilled to see a consistent level of satisfaction with Flutter. In this article, we cover some deep-dive questions around Flutter’s ecosystem, because we recognize that helping the Flutter community grow the ecosystem is important.

---

As of July, 2019, you can find over 2,800 Flutter-dependent packages published on [pub.dev](https://pub.dev). At the same time last year, there were about 350 Flutter-dependent packages available, showing tremendous growth! And this does not include the thousands of additional Dart packages that are compatible with Flutter apps.

Even though the ecosystem has been exploding, we recognize that there is still plenty of work remaining to build an excellent ecosystem around the Flutter project. To better understand the needs and struggles of our users, we asked a number of questions related to Flutter’s ecosystem in this quarter’s survey. We’re sharing the results in this article to help package authors build more useful packages that serve the needs of more users.

Overall, 80.6% of 5,250 respondents were either **very satisfied** or **somewhat satisfied** with the Flutter ecosystem. This is not bad, but at the same time, it is one of the lower-scoring parts of the survey.

![Satisfaction with ecosystem](https://cdn-images-1.medium.com/max/2400/0*MjrAD-ZGebXA-xaX)

![Overall satisfaction with Flutter](https://cdn-images-1.medium.com/max/2400/0*LDgXRVH9t_ZteWDV)

When asked about the dissatisfaction with Flutter’s ecosystem, the reason selected by the most respondents was that “critical packages I need **do not exist** yet” (18%), which is perhaps to be expected for a relatively new technology.

However, we are happy to find that our community is actively adding to the Flutter package ecosystem. 15% of respondents had experience developing packages for Flutter, and 59% had published their packages to pub.dev, the site for sharing packages written for Flutter and Dart apps. If you’ve written a package but have not published yet, you can read [Developing packages & plugins](https://flutter.dev/docs/development/packages-and-plugins/developing-packages) on [flutter.dev](http://flutter.dev), and contribute back to the Flutter community by publishing your package. It is not difficult — of those who had published to [pub.dev](http://pub.dev), 81% thought that it was **very easy** or **somewhat easy**.

If you can’t decide which package to share with the Flutter community, visit the Flutter repository on GitHub and search for [issues labeled with “would be a good package”](https://github.com/flutter/flutter/issues?q=is%3Aopen+is%3Aissue+label%3A%22would+be+a+good+package%22+sort%3Areactions-%2B1-desc) to see what has been requested. You can upvote your favorite requests to increase their visibility.

![Reasons for dissatisfaction with Flutter’s ecosystem (a multiple choice question)](https://cdn-images-1.medium.com/max/3200/0*UdtJOiVqBwXOmDl_)

However, there is an even better way to contribute to the ecosystem, if you’re interested in helping out. Note that all other reasons start with “critical packages I need do exist…”, meaning that package users were facing challenges even when packages exist. This tells us that we can improve the ecosystem by improving what is already there — by filing bugs, improving documentation, adding missing features, implementing support for the ‘other’ platform, adding tests, and so on. Consider finding a package that has potential but has not been loved enough and contribute towards it — with tests, bug reports, feature contributions, or examples!

The most common reason for dissatisfaction with existing packages is that “they are not well **documented**” (17%). This is another area where the community can help. The survey question “What would you like done to improve your overall experience with the package ecosystem?” resulted in the following suggestions:

* Include more diverse code usage examples
* Include screenshots, animated gifs, or videos
* Include a link to the corresponding code repository

Here are some relevant quotes from the comment section:

> “There are still some packages that do not have code samples on the very first page. It should be mandatory to have at least a single simple example.”
>
> “Emphasize to package developers to give more thorough examples of how to use their package.”
>
> “Force all packages to have an animated gif or video demoing it (preferred) or a screenshot, and have an example Dart file.”
>
> “A graphic display of an example package would be helpful. Many times it’s easier to see what a package is referring to than to run the example.“
>
> “Would like to see the Example section filled out more often. Some packages don’t have any examples. Maybe have a clearer link on this page to the corresponding GitHub repo?”

Also, as shown in the graph above, difficulties associated with the actual use of packages (such as dependency issues, bugginess of packages, setup of packages) are relatively less concerning to users as compared to activities associated with selecting suitable packages (such as missing features, trustworthiness of publishers, guidance for choice, adequate platform support).

---

The Flutter/Dart team at Google is also investigating ways to improve your experience with using, and contributing to, the ecosystem. Some of the options being considered include, but are not limited to:

* Provide a better pub.dev search experience
* Make it easy to tell which platform(s) a package supports
* Offer more reliable quality metrics
* Improve testability

In the meantime, it might be worth pointing out that each package on pub.dev already receives scores for popularity, health, and maintenance; these scores help users gauge the quality of a package. You can find details of the scoring system on [pub.dev/help#scoring](https://pub.dev/help#scoring).

![Scoring example](https://cdn-images-1.medium.com/max/2000/0*DSPe0z8OcY1Dzlet)

![Maintenance suggestions](https://cdn-images-1.medium.com/max/2000/0*Kxtw9kjb1h_6DTAK)

With the scoring system, package authors can understand what they can do to improve the quality of the package, and package users can estimate the quality (for example, the outdatedness) of a package.

We expect the scoring system to expand over time to help users make more informed decisions. More specifically, we’d like to see test coverage added, and we’d like to expose better information about platform coverage, especially as the list of platforms that Flutter supports expands. We’d also like to provide a mark of whether a particular package is “recommended” so that users has a clear idea of what the Flutter community thinks is worth considering. As these scoring changes come about, we’ll communicate with our package authors to make sure that they have all of the information they need to meet the rising quality bar.

---

We want to convey a huge thank you to the more than 7,000 Flutter users who filled out the long survey. We learned a lot — some other highlights are listed below.

* Some Flutter users are not completely satisfied with the animation framework, not because it’s hard to achieve intended effects, but because it’s hard to get started. Respondents, especially new users, did not know where to begin, and it’s hard for them to understand how various concepts link together. Therefore, we are investing more into the learning materials for the animation framework.
* For the API documentation on [api.flutter.dev](http://api.flutter.dev), sample code in the class doc was rated as the most useful resource. We have added full code samples to some of the classes in the API docs with the 1.7 release, but will continue expanding this feature to more classes. (We also accept PRs against the API docs on the [flutter/flutter repo](https://github.com/flutter/flutter/labels/d%3A%20api%20docs)!)

![](https://cdn-images-1.medium.com/max/3200/0*PceEjhOlGlSQw1oK)

* Lastly, many of you noticed that the number of unresolved issues in the GitHub repo is growing, which is an unfortunate side-effect of the exploding popularity of Flutter. While we closed over 1,250 issues in the last release, we have more work to do here. As mentioned in the Flutter 1.7 blog post, we’re working to increase staffing in this area, which will help with faster triaging of new bugs, faster attention to critical/crashing issues, closing and merging duplicate issues, and redirecting support requests to [StackOverflow](https://stackoverflow.com/questions/tagged/flutter).

We value your responses to the survey and will use this information when determining work priorities. Please participate in our Q3 survey, which will be launched in August, and will explore new topic areas.

---

Flutter’s UX research team performs a variety of user experience studies so that we can learn how to make your experience with Flutter more pleasant. If you are interested in participating, please [sign up](http://flutter.dev/research-signup) for future studies.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
