> * 原文地址：[How To Prioritize Your Team’s Work](https://medium.com/better-programming/how-to-prioritize-your-teams-work-9e68f5e571c)
> * 原文作者：[Maria Valcam](https://medium.com/@mariavalerocam)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-prioritize-your-teams-work.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-prioritize-your-teams-work.md)
> * 译者：
> * 校对者：

# How To Prioritize Your Team’s Work

> Start by knowing your company’s objectives and your team’s goals

![Photo by [Alice Achterhof](https://unsplash.com/@alicegrace?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7874/0*xdFRj5HXvQt0uehy)

---

## Day-To-Day Work

In every company, we can categorize work into three types*:

* **Product work** — This is what the customer sees. It’s typically defined by the product owner. It consists of features and bugs.
* **Internal IT work** —Improvements to the infrastructure or day-to-day operations. It includes creating new environments, writing automation, improving CI/CD, updating a dependency, etc.
* **Unplanned work or recovery tickets** — Incidents and problems. This cannot be planned, so I will ignore it for the rest of this piece.

* Note: I took the four types of work from the [DevOps Handbook](https://itrevolution.com/book/the-devops-handbook/) and changed them a bit: renamed **business projects** to **product work** (all projects are business projects) and merged internal IT projects and updates into one.

But how do we prioritize our work? To answer this question, we need to know what the company’s objectives are and what the goals of my team are.

And more importantly:

Why do you go to work every day?

---

## Getting the Bigger Picture

To get the bigger picture, the objectives of the company and the team need to be communicated to the team. **OKR** is a framework that helps to cascade objectives up and down through the organization.**

**Note: OKRs are widely used in tech companies: Google, Intuit, Microsoft, Amazon, Intel, Facebook, Netflix, Samsung, Spotify, Slack, Twitter, Salesforce.com, Deloitte, Dropbox, etc.

#### What are OKRs (objectives + key results)?

OKRs have two parts:

* **Objectives** — What needs to be achieved. They must be significant, concrete, action-oriented, and (ideally) inspirational.
* **Key Results** — How we achieve it. They must be [SMART](https://corporatefinanceinstitute.com/resources/knowledge/other/smart-goal/) (Specific, Measurable, Achievable, Realistic, and Timely).

John Doerr defines them in his book [Measure What Matters](https://www.whatmatters.com/). Check out this video for a quick sum-up:

[![](https://i.ytimg.com/vi/L4N1q4RNi9I/maxresdefault.jpg)](https://youtu.be/L4N1q4RNi9I)

---

## Set Your Team’s OKRs

The first step for getting our OKRs is to set your company’s objectives and then set your team’s objectives. Company objectives (and the strategy of the company) are defined by directors.

1. Know the OKRs for your company

2. Set specific OKRs for your team.

Normally, the objectives of a team are set only by product owners. With this, they create their product backlog. It’s easier for them because they know the business side, but this approach has many problems:

* Internal IT OKRs, critical for growing the business, are missing. The speed, quality, and stability of the services will get punished if just product work is our objective.
* Developers will not understand the meaning of their work. Everyone in the team should participate in setting objectives so they know the big picture and can make trade-offs in their day-to-day work. Developers need to see that metrics are proxies of the real objective, as noted in the Harvard Business Review article “[Don’t Let Metrics Undermine Your Business](https://hbr.org/2019/09/dont-let-metrics-undermine-your-business).”

The solution? Everyone in the team should participate in defining the team’s OKRs.

After everyone knows the business objectives, they can sit together and theorize about what the team should focus on to help with this. Finally, they should define key results to keep this objective on track.

---

## Technical OKRs

Do you find it difficult to get the buy-in from PMs? Remind them that internal work also brings value to the customer, so missing them will be fatal for the company.

![Photo by [James Pond](https://unsplash.com/@jamesponddotco?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9750/0*3nZw2VXlQXFxWK7P)

Here are some objectives that you could add:

* **Improve Delivery** — [The State Of DevOps Report](https://services.google.com/fh/files/misc/state-of-devops-2019.pdf) shows the results of 31,000 survey responses from working professionals. It always points to the same four metrics that show the effectiveness of the development and delivery process: Lead Time, Deployment Frequency, Change Fail, Availability and Time to Restore. These metrics differentiate high performers from low performers.
* **Reduce Risk Factors** — First, you should identify your risks (do it with your team using Post-its), sort them according to its relevance, and set their probability to occur (Low, Medium, High). Then, your team should write its OKRs having this on the table.

Note: You should review your risk factors once per year.

* **Reduce Cost** — Are you paying too much for an application? Is a new project showing no results? That money could be spent somewhere else in your business. We need to consider this opportunity cost by reducing the expenses that are not needed.

Note: For some low-cost companies, reducing cost work could be vital.

---

## Putting It All Together

Once your team has their objectives, each new project should be associated with an OKR. If a project does not contribute to the OKRs, then it is wasting the time of the team.

Tips:

* **Projects should be seen as hypotheses** that could or could not bring you closer to your goal. Example 1: If we allow the customers to pay using PayPal, we will get more users. Example 2: If we use micro-services, we will reduce lead time. So you need to **verify that your Key Results are improving.** If they aren’t, drop the project a create new hypotheses.
* Objectives can live over a year or longer, but key results evolve as the work progresses. So you should **review if your objectives still make sense** at least once per year and your key results at least once per month or per quarter.
* **OKRs should be transparent** within the whole organization. This motivates interdepartmental communications and avoids duplication of work so teams that are working to improve the same objectives can work together.
* At Google, **each employee has their own OKRs**. Six to eight of them will come from the team, and two will be set by themselves (20% time). They do this to improve innovation and promote people to add their vision to the company (Gmail was a 20% project within Google).
* There are two types of OKRs: committed and aspirational. Where committed OKRs must goals for the team, aspirational OKRs are set to guide the team in the same direction but are not expected to be achieved. In fact, **achieving all OKRs is a signal that they were not ambitious enough** (Wired “[Google’s Larry Page on Why Moon Shots Matter](https://www.wired.com/2013/01/ff-qa-larry-page/)”).

---

## Thanks for Reading!

I hope these tips make the prioritizing work a bit easy for you.

Do you set priorities differently? Let me know in the comments!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
