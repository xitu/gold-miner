> * 原文地址：[]()
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/.md](https://github.com/xitu/gold-miner/blob/master/TODO1/.md)
> * 译者：
> * 校对者：

## [André Staltz](/)

## Software below the poverty line

### 13 Jun 2019

Most people believe that [open source sustainability is a difficult problem](https://www.fordfoundation.org/about/library/reports-and-studies/roads-and-bridges-the-unseen-labor-behind-our-digital-infrastructure/) to solve. As an open source developer myself, my own perspective to this problem was more optimistic: I believe in the donation model, for its simplicity and possibility to scale.

However, I recently met other open source developers that make a living from donations, and they helped widen my perspective. At Amsterdam.js, I heard [Henry Zhu speak about sustainability](https://github.com/hzoo/open-source-charity-or-business/) in the Babel project and beyond, and it was a pretty dire picture. Later, over breakfast, Henry and I had a deeper conversation on this topic. In Amsterdam I also met up with [Titus](https://github.com/wooorm), who maintains the [Unified](https://unified.js.org/) project full-time. Meeting with these people I confirmed my belief in the donation model for sustainability. It works. But, what really stood out to me was the question: is it fair?

I decided to collect data from OpenCollective and GitHub, and take a more scientific sample of the situation. The results I found were shocking: there were two clearly sustainable open source projects, but the majority (more than 80%) of projects that we usually consider sustainable are actually receiving income below industry standards or even below the poverty threshold.

## What the data says

I picked [popular open source projects](https://opencollective.com/discover) from OpenCollective, and selected the yearly income data from each. Then I looked up their GitHub repositories, to measure the count of stars, and how many “full-time” contributors they have had in the past 12 months. Sometimes I also looked up the Patreon pages for those few maintainers that had one, and added that data to the yearly income for the project. For instance, it is obvious that Evan You gets money on [Patreon to work on Vue.js](https://www.patreon.com/evanyou). These data points allowed me to measure: project **popularity** (a proportional indicator of the number of users), **yearly revenue** for the whole team, and **team size**.

It is difficult to derive exactly how many users there are for each project, specially because they may be transitive users, not aware that they are using the project. This is why I went with GitHub stars as a good enough measurement for user count, because it counts **persons** (unlike download count which can include CI computers) that are **conscious** about the project’s worth.

I scanned 58 projects in total, which may seem like a small number, but this was done from the most popular to the least. Popularity is very important to scale the donations, and it turns out that very few projects have enough popularity to achieve fair compensation. In other words, among these fifty most popular projects, the majority of them are below sustainability thresholds. I believe that if I would cover more data points, those would be likely less popular than these ones. This data set might be biased towards JavaScript projects on OpenCollective, but the choice for sampling OpenCollective is because it provides easy transparent data on the finances of various projects. I want to remind the reader of the existence of other popular open source projects such as Linux, nginx, VideoLAN, and others. It would be good to incorporate the financial data from those projects in this data set.

From GitHub data and OpenCollective, I was able to calculate how much yearly revenue for a project goes to each “full-time equivalent” contributor. This is essentially their salary. Or, said better, this is how much their salary via donations would be if they were working exclusively on the open source project, without any complementary income. It is likely that a sizable amount of creators and maintainers work only part-time on their projects. Those that work full-time sometimes complement their income with savings or by living in a country with lower costs of living, [or both (Sindre Sorhus)](https://twitter.com/sindresorhus/status/902954660285128704).

Then, based on the [latest StackOverflow developer survey](https://insights.stackoverflow.com/survey/2019#work-_-salary-by-developer-type), we know that the low end of developer salaries is around $40k, while the high end of developer salaries is above $100k. That range depicts the industry standard for developers, given their status as knowledge workers, many of which are living in OECD countries. This allowed me to classify the results into four categories:

* BLUE: 6-figure salary
* GREEN: 5-figure salary within industry standards
* ORANGE: 5-figure salary below our industry standards
* RED: salary below the [official US poverty threshold](https://poverty.ucdavis.edu/faq/what-are-poverty-thresholds-today)

The first chart, below, shows team size and “price” for each GitHub star.

[![Open source projects, income-per-star versus team size](/img/poverty-teamsize.png)](/img/poverty-teamsize.png)

**More than 50% of projects are red**: they cannot sustain their maintainers above the poverty line. 31% of the projects are orange, consisting of developers willing to work for a salary that would be considered unacceptable in our industry. 12% are green, and only 3% are blue: Webpack and Vue.js. Income per GitHub star is important: sustainable projects generally have above $2/star. The median value, however, is $1.22/star. Team size is also important for sustainability: the smaller the team, the more likely it can sustain its maintainers.

The median donation per year is $217, which is substantial when understood on an individual level, but in reality includes sponsorship from companies that are doing this also for their own marketing purposes.

The next chart shows how revenue scales with popularity.

[![Open source projects, yearly revenue versus GitHub stars](/img/poverty-popularity.png)](/img/poverty-popularity.png)

You can browse the data yourself by accessing this [Dat archive](https://datproject.org/) with a LibreOffice Calc spreadsheet:

```
dat://bf7b912fff1e64a52b803444d871433c5946c990ae51f2044056bf6f9655ecbf

```

## Popularity versus fairness

While popularity is key to green and blue sustainability, there are popular products in red, such as [Prettier](https://github.com/prettier/prettier), [Curl](https://github.com/curl/curl), [Jekyll](https://github.com/jekyll/jekyll), [Electron](https://github.com/electron/electron) (update:) [AVA](https://github.com/avajs/). This doesn’t mean the people working on those projects are poor, because in several cases the maintainers have jobs at companies that allow open source contributions. What it does mean, however, is that unless companies take an active role in supporting open source with significant funding, what’s left is a situation where most open source maintainers are severely underfunded. On donations alone, open source is sustainable (fairly within industry standards) in a sweet spot: when a popular project, with a sufficiently small team, knows how to gather significant funding from a crowd of donators or sponsor organizations. Fair sustainability is sensitive to these parameters.

Because visibility is fundamental for donation-driven sustainability, the “invisible infrastructure” projects are often in a much worse situation that the visible ones. For instance, [Core-js](https://github.com/zloirock/core-js) is less popular than [Babel](https://github.com/babel/babel), although [it is a dependency in Babel](https://babeljs.io/docs/en/next/babel-polyfill.html).

Library

Used by

Stars

'Salary'

Babel

350284

33412٭

$70016

Core-js

2442712

8702٭

$16204

Some proposed solutions have been to “trickle down” donations from the well-known projects to the least, guided by tools such as [BackYourStack](https://backyourstack.com/) and [GitHub’s new Contributor overview](https://github.blog/2019-05-23-announcing-github-sponsors-a-new-way-to-contribute-to-open-source/#native-to-your-github-workflow). This would work if the well-known projects had a huge surplus to share with transitive dependencies. That is hardly possible, only Vue.js has enough surplus to share, and it could only do that with 3 or 4 other developers. Vue.js is the exception, other projects cannot afford sharing their income, because that would cause everyone involved to receive poorly.

In the case of Babel and Core-js, there isn’t a lot of surplus to share forwards. One of Henry Zhu’s points in his talk was precisely that the money received is already too limited. It might seem like Babel is **the** visible project in this situation, but it surprised me to hear from Henry that many people are not aware of Babel although they use it, because they might be using it as a transitive dependency.

From the other side of the coin, the maintainers of lower level libraries recognize the need to partner with more visible projects or [even merge projects](https://twitter.com/wooorm/status/1062404997240012800) in order to increase overall visibility, popularity, and thus funding. This is the case of Unified by Titus, which is a project you might not have heard of, but Unified and its many packages are used in [MDX](https://github.com/mdx-js/mdx/blob/deff36bebfedb3a9de0a0575ee9a1b55b9b8aa18/package.json#L20), [Gatsby](https://github.com/gatsbyjs/gatsby/blob/25d4a4dab66e04717fb09dc5edb1f7b856fc41ff/packages/gatsby-transformer-remark/package.json#L26), [Prettier](https://github.com/prettier/prettier/blob/24f161db565c1a6692ee98191193d9cf9ff31d6f/package.json#L66), [Storybook](https://github.com/storybookjs/storybook/blob/fed2ffa5e2919220f0508e540b2eae848523fee5/package.json#L214) and many others.

It is also not true that popular projects are financially better off than their less popular dependencies. Prettier (32k stars) uses Unified (1k stars) as a dependency, but Unified has more yearly revenue than Prettier. In fact, many of the popular projects that depend on Unified are receiving less funding per team member. But Unified itself is still receiving below industry standards, not in a situation of trickling down (or up?) that funding.

Other times, it’s not easy to say that when a project A is using project B, it should necessarily donate to B, because it might be that B also uses A! For instance, [Babel is a dependency in Prettier](https://github.com/prettier/prettier/blob/24f161db565c1a6692ee98191193d9cf9ff31d6f/package.json#L19), and [Prettier is a dependency in Babel](https://github.com/babel/babel/blob/f92c2ae830dbb32013a36fa74facd2ef95b9947d/package.json#L59). Probably many of the projects covered in this study have a complex web of dependencies **between** each other, that it becomes difficult to say how should money flow within these projects.

## Exploitation

The total amount of money being put into open source is not enough for all the maintainers. If we add up all of the yearly revenue from those projects in this data set, it’s $2.5 million. The median salary is approximately $9k, which is below the poverty line. If split up that money evenly, that’s roughly $22k, which is still below industry standards.

The core problem is not that open source projects are not sharing the money received. The problem is that, in total numbers, open source is not getting enough money. $2.5 million is not enough. To put this number into perspective, startups get typically much more than that.

[Tidelift has received $40 million](https://www.crunchbase.com/organization/tidelift) in funding, to “help open source creators and maintainers get fairly compensated for their work” [(quote)](https://tidelift.com/docs/lifting/paying). They have a [team of 27 people](https://tidelift.com/about), some of them ex-employees from large companies (such as Google and GitHub). They probably don’t receive the lower tier of salaries. Yet, many of the [open source projects they showcase](https://tidelift.com/subscription) on their website are below poverty line regarding income from donations. We actually do not know how much Tidelift is giving to the maintainers of these projects, but their [subscription pricing](https://tidelift.com/subscription/pricing) is very high. Opaqueness of price and cost structure has historically helped companies hide inequality.

GitHub was [bought by Microsoft for $7.5 billion](https://venturebeat.com/2018/06/04/microsoft-confirms-it-will-acquire-github-for-7-5-billion/). To make that quantity easier to grok, the amount of money Microsoft paid to acquire GitHub – the company – is more than **3000x** what the open source community is getting yearly. In other words, if the open source community saved up every penny of the money they ever received, after a couple thousand years they could perhaps have enough money to buy GitHub jointly. And now GitHub itself has its own [Open Source Economy team](https://www.youtube.com/watch?v=n47rCa9dxf8) (how big is this team and what are their salaries?), but the new GitHub sponsors feature is far less transparent than OpenCollective. Against GitHub’s traditional culture of open data (such as the commits calendar or the contributors chart), when it comes to donations, a user cannot know how much each open source maintainer is getting. It’s opaque.

If Microsoft GitHub is serious about helping fund open source, they should put their money where their mouth is: donate at least $1 billion to open source projects. Even a mere $1.5 million per year would be enough to make all the projects in this study become green. The [Matching Fund](https://help.github.com/en/articles/about-github-sponsors#about-the-github-sponsors-matching-fund) in GitHub Sponsors is not enough, it gives a maintainer at most just $5k in a year, which is not sufficient to raise the maintainer from the poverty threshold up to industry standard.

We now have data to say that open source creators and maintainers are receiving low income, and we have data to say that companies “helping” open source are receiving millions, and most likely top salaries. Other millionaire and billionaire companies are making profits by combining open source libraries and components to build proprietary software. I understand [DHH’s stance on **‘There is no tragedy’**](https://youtu.be/VBwWbFpkltg?list=PLE7tQUdRKcyaOq3HlRm9h_Q_WhWKqm5xc&t=1362) in open source sustainability, and in fact when I watched his talk I was inclined to agree. However, the recent data I compiled – out of curiosity – showed me the default reality of open source finances, indicating a severe imbalance between work quality and compensation. Full-time maintainers are technically talented people responsible for issue management, security, navigating toxic complaints, while often receiving below the industry standards.

The struggle of open source sustainability is the millennium-old struggle of humanity to free itself from slavery, colonization, and exploitation. This is not the first time hard-working honest people are giving their all, for unfair compensation.

This is therefore not a new problem, and it does not require complicated new solutions. It is simply a version of injustice. To fix it is not a matter of receiving compassion and moral behavior from companies, for companies are fundamentally built to do something else than that. Companies simply follow some basic financial rules of society while trying to optimize for profit and/or domination.

Open source infrastructure is a commons, much like our ecological systems. Because our societies did not have rules to prevent the ecological systems from being exploited, companies have [engaged in industrialized resource extraction](https://ourworldindata.org/fossil-fuels). Over many decades this is [depleting the environment](https://ourworldindata.org/forests), and now we are facing a [climate crisis](https://www.theguardian.com/environment/2019/may/17/why-the-guardian-is-changing-the-language-it-uses-about-the-environment), [proven](https://climate.nasa.gov/) [through scientifical consensus](https://archive.ipcc.ch/pdf/assessment-report/ar5/syr/SYR_AR5_FINAL_full_wcover.pdf) to be a [substantial threat to humanity](https://news.un.org/en/story/2018/05/1009782) and [all life on the planet](https://www.ipbes.net/news/Media-Release-Global-Assessment). Open source misappropriation is simply a small version of that, with less dramatic consequences.

If you want to help open source become sustainable, rise up and help humanity write new rules for society, that keep power and capitalist thirst accountable for abuse. If you are wondering what that looks like, here are some initial suggestions of concrete actions to take:

* Only accept jobs at companies that donate a significant portion of their profit (at least 0,5%) to open source, or companies which don’t fundamentally depend on open source for their products
* Donate to open source if you have a decent enough salary
* Don’t discard unionizing (I am writing this in Finland, where 65% of all workers are in unions)
* Don’t discard [alternative licenses](https://licensezero.com/) for new projects
* Pressure Microsoft to donate millions to open source projects
* Expose the truth on how companies are behaving by publishing data studies like this one

If you liked this article, consider sharing [(tweeting)](https://twitter.com/intent/tweet?original_referer=https%3A%2F%2Fstaltz.com%2Fsoftware-below-the-poverty-line.html&text=Software%20below%20the%20poverty%20line&tw_p=tweetbutton&url=https%3A%2F%2Fstaltz.com%2Fsoftware-below-the-poverty-line.html&via=andrestaltz "tweeting") it to your followers.

[Become a Patron!](https://www.patreon.com/bePatron?u=8666785)

Copyright (C) 2019 Andre 'Staltz' Medeiros, licensed under [Creative Commons BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/), translations to other languages allowed. You can make sure that the author wrote this post by copy-pasting [this signature](https://raw.githubusercontent.com/staltz/staltz.com/master/signed_posts/2019-06-13-software-below-the-poverty-line.md.asc) into [this Keybase page](https://keybase.io/verify).

[Back home](/)

[Source code](https://github.com/staltz/staltz.github.io)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
