> * 原文地址：[Why the first ten minutes are crucial if you want to keep players coming back](https://medium.com/googleplaydev/why-the-first-ten-minutes-is-crucial-if-you-want-to-keep-players-coming-back-to-your-mobile-game-4a89031b6308)
> * 原文作者：[Adam Carpenter](https://medium.com/@Adam_Carpenter?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/why-the-first-ten-minutes-is-crucial-if-you-want-to-keep-players-coming-back-to-your-mobile-game.md](https://github.com/xitu/gold-miner/blob/master/TODO/why-the-first-ten-minutes-is-crucial-if-you-want-to-keep-players-coming-back-to-your-mobile-game.md)
> * 译者：
> * 校对者：

# Why the first ten minutes are crucial if you want to keep players coming back

## Post 1 of 3: How to analyze your mobile game’s retention data

![](https://cdn-images-1.medium.com/max/800/0*BwtoKf5kjO7zc98V.)

As a mobile developer, one of the most powerful tools you have is **data**. Leveraging game data in the right way provides an incredible opportunity to identify problems, optimize performance, provide value to players, and ultimately grow your businesses.

In this post I’ll discuss the signals in your new installers’ first day performance which can help identify where you might be losing players in your game. I’ll also share a number of meaningful benchmarks from Google Play for you to better understand your game’s performance and identify opportunities for improvement.

### Average player retention for games on Google Play

Retention is one of the key installs performance metrics, along with buyer conversion and average revenue per install. In many ways, retention is the primary metric, sinceif you can retain your new players, you can always figure out how to make money**.** If you can’t retain any players, you have no ability to make money.

The retention equation itself is very simple, it’s the **number of users active on a given retention day divided by the number of installs in your cohort**. For top grossing free to download games on Google Play, the median day 2 retention is 38%. Exceeding 46% day 2 retention places your game in the top quartile, which means you would be doing better than 75% of titles in the top charts.

![](https://cdn-images-1.medium.com/max/800/0*USxPiUCAW1yHihsl.)

_Day 2 retention rates (where day 2 is the day after the first player session)_

However, it’s also important to think about what this means. A Day 2 retention of 22% to 52% actually means that 48% to 78% of all users who play a game for the first time today won’t come back tomorrow. Considering all the time and effort you devote to building and promoting games, you should do everything you can to improve this.

### What to focus on to improve retention

Many developers focus on metrics like the level players reached on their first day, or the tutorial checkpoint their users passed. However, such metrics are game specific and do not help you understand how you compare to your peers.

One key metric compares ‘Day 1 minutes played’ to the ‘Day 2 retention’. This metric, **D1 minutes played vs. D2 retention**, is much more of an apples to apples comparison, and is used at Google to help partners identify early deficiencies and increase their new installers’ performance.

![](https://cdn-images-1.medium.com/max/800/0*LTwqY-WB_Pq90xHk.)

_Day 1 is the date of the first player session_

This graph shows the length of time a new player plays on their very first day, versus the percentage of users who return the next day. The trend shows that **the longer people spend in a game on their first day, the more likely they are to return**.

This make instinctive sense. It’s reasonable to assume that the more time someone plays on their first day, they more they are enjoying themselves, and the greater the chance they’ll want to return to keep having fun.

However, where it gets really interesting is when we split the top performing games into quartiles based on their Day 2 retention. The first quartile, the top performers, have an average Day 2 retention of 52%. Their retention starts off strong at about 22% and steadily rises with each successive minute played. The second quartile, comes in with a Day 2 retention of 42% average, and the third quartile has an average of 32% on Day 2.

![](https://cdn-images-1.medium.com/max/800/0*vYdHUUVA2Ly99q2g.)

We can see that most quartiles exhibit a very similar trend after the first 10 minutes; they all curve up and to the right with a steadily diminishing slope. However, it’s the **first ten minutes where the most interesting patterns are visible**.

### The first ten minutes is crucial

This chart zooms into those first 10 minutes, and this is where we can see very distinct patterns emerge.

![](https://cdn-images-1.medium.com/max/800/0*YrkjzozmTK6OOgt5.)

For the **top performers** (green line), their retention starts out strong and steadily rises. The **second quartile** (blue line) shows a different pattern, whereby we can see retention is largely flat across the first minute and a half, and only then does it begin to increase steadily. For the third quartile (orange), retention is predominantly flat until minute four, following which it then begins to increase but at a slower rate than higher performing apps. Finally in the fourth quartile (red line), retention actually declines in the first 2 minutes, and it isn’t until minute five that the games show a higher retention compared to those who played for less than a minute on their first day.

Now, let’s take a look at how the **early patterns impact our users**. The chart below compares the cumulative players lost by minute for the top quartile (green line), versus the bottom quartile (red line).

![](https://cdn-images-1.medium.com/max/800/0*6l_OD0QngrUKGuvX.)

The worst performers lose 46% of their new installs by the fifth minute. By the 10th minute, they’ve lost 58% of their new installs. Basically, over half their new installs don’t even last 10 minutes in the game. In contrast, top performers only lose 17% of players by the fifth minute, and only 24% by minute 10.

> **_The first 5 to 10 minutes are critical and they will make or break your day 2 retention._**

These top performing games have managed to retain over twice as many players as the lowest performing peers. There is however still a key question: if you could retain twice as many users on Day 2 and all following retention days, how would that help your daily active users (DAU)? How much would that improve your revenue? By leveraging Google Play data, we have identified two key patterns.

### Avoid the retention ‘flats’ and the ‘gorge’

The first pattern is called the “**Flats**”. This anti-pattern shows largely flat retention for up to 10 minutes, with the percentages only rising meaningfully after the 5th to 10th minute. The second is the “**Gorge**”, whereby retention appears to drop minute by minute for the first five minutes or so, and then begins to rise again.

![](https://cdn-images-1.medium.com/max/800/0*P7z6AeRbUS0z7QOQ.)

As a broad estimate, it’s likely that between 25% and 50% of games exhibit one of these anti-patterns. Leveraging the data in your own data warehouses, you can generate these plots and see what patterns emerge in your games. If you see the **‘Flats’** or the ‘**Gorge**’ in your own data, here’s a few things to examine:

* Does your game have a very large secondary download? This can cause players to quit if they are not on a good wireless connection.
* Are your tutorials fun? Do they give players a good sense of what the game is like?
* What are your loading times like? New players are especially susceptible to long loading times as they aren’t yet invested in the game.
* Does your lobby make instinctive sense to new players? Does someone coming out of the tutorial know how to get back into the action, how to build their base, and how to start having fun again? All of these considerations are important in ensuring users stick with your game.
* Are you running a large number of discount sales or offers on the first day? This tactic might earn some short term revenue at the expense of lower overall retention. Consider running tests which eliminate offers on the first day, but instead makes players feel rich to maximize their fun.

A great benefit of optimizing the first 10 minutes of gameplay is that you can iterate quickly on experimental changes, and get results back from A/B tests in a couple days.

### Start an upwards trend in your player retention

The first few minutes in a game are a critical time in a player’s life cycle. At this point, their only investment in your game has been the time and effort spent downloading it. Any negative experiences may lead players to quit, or switch to another game.

If you find either “Flats” or “Gorge” anti-patterns in your game, or that your retention by minute starts out too low, then look even further to identify what might be causing it. Consider whether secondary downloads, long load times, or any other factors may be having a negative impact. If you can correlate adverse retention in the first 10 minutes to any particular factor, test changes to moderate or eliminate the cause, and you should see improvements in your game’s retention, daily active users, and ultimately revenue.

* * *

### What do you think?

Do you have any comments on anti-patterns in game data and player retention? Continue the discussion in the comments below or tweet using the hashtag #AskPlayDev and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.

* * *

_This is the first post of a 3 part series; look out for my second post in the next month, where I will be further discussing how to use data to understand and improve player engagement. Then in my third and final post, I will be exploring whether players and ‘payers’ are happy, and how to use these insights to drive conversions._


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
