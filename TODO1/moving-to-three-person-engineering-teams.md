> * 原文地址：[Moving to three-person engineering teams](https://medium.com/do-not-erase/moving-to-three-person-engineering-teams-bcf599670c2a)
> * 原文作者：[Phil Sarin](https://medium.com/@philsarin?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/moving-to-three-person-engineering-teams.md](https://github.com/xitu/gold-miner/blob/master/TODO1/moving-to-three-person-engineering-teams.md)
> * 译者：
> * 校对者：

# Moving to three-person engineering teams

Three-person engineering teams just work better. Everyone on a three-person team is more motivated because they feel like they **own** their work. They also deal with less overhead and nonsense. Yet three-person teams aren’t too small. They have just enough people to handle vacations or to swarm on complicated problems.

But three-person teams aren’t as frequent as they should be because they can be hard to pull off. It can be hard to find enough team leaders. It’s also tempting to build larger teams to handle bigger mandates. At Managed by Q, three-person teams were commonplace when we had fewer than ten engineers who were cranking out the foundation of our technology platform. But as we grew to close to 25 people, our teams swelled in size to five or six people. Everyone gradually became a little less motivated. And everything slowed down.

A few months ago we decided to break up our larger teams and to return to three-person teams as our default size. As we’d hoped, the three-person teams were more motivated and they delivered more. In our post-reorg survey, team members praised higher speed and greater ownership:

> Small size = very fast development. Able to have total mental model of the code we’re working on. Nobody is able to be left out or lag behind in understanding.

> Smaller teams make it easier to plan and sequence work. This has enabled us to move quickly on a number of projects.

> There’s much more ownership, opportunities to lead, and flexibility.

> It’s easier to feel proud of the work we are doing since there is more accountability and each person has a more direct impact on the successes of the team.

But the switch to three-person teams forced us to make several changes to how we operated.

#### We needed to learn to trust more easily

We decided to move to three-person teams after one of our long-time engineers told me that I was holding us back by not giving new people leadership responsibility. Other engineers believed that only a small number of favored people would ever get to lead anything.

This engineer forced me to confront a bias that was holding me back. I leaned on trusting people who had repeatedly proven that they could deliver. But everyone on the team wanted to prove they could do something they hadn’t done before. I wouldn’t get my team’s best work without learning to trust more.

The larger team size was also a bad fit for the people we’d hired. We pride ourselves on hiring engineers who handle ambiguity well and who focus on solving problems rather than simply churning through tasks.

To become more trusting we redefined what leads were responsible for. Our new leads would only need to be able to coordinate the work of two other people, and not four or five. Our leads would not need to manage people. Their roles were also explicitly temporary. That made it easy for our leads to return to non-lead roles for any reason.

#### We needed to train our leads

When we added several leads we decided to train them in their new roles. John Lucas, one of our managers, developed an orientation for leads. He asked new leads to assess themselves along several dimensions including setting goals, recognizing problems, managing projects, managing risk, giving feedback, and creating psychological safety.

John’s orientation asked each lead to write a self assessment along these dimensions. He wrote his own assessment of each lead. They discussed the differences during their 1–1s. Our new leads were introspective and candid in their self-assessments. For example:

> I often feel hypocritical about feedback. I seek out and crave feedback from everyone around me, but often times have trouble giving high quality feedback back. Kim Scott would diagnose me with ruinous empathy. I care deeply about those I work with, but try to avoid confrontation and hurting others feelings. I do this despite knowing that it is best for everyone if I am direct and honest. This is the competency I want to improve in most.

The best thing about the orientation is that it helped our new leads understand what new responsibilities they’d face day to day. When many of our experienced leads first stepped into leadership positions, they were surprised by how much they were suddenly responsible for. Talking openly about the challenges of leadership positions helped our leads know what to expect and to feel comfortable asking for help.

#### The role of our managers changed

Because our leads handled more responsibilities we needed fewer managers. Some managers moved into different roles. Those that remained had new responsibilities.

Our managers evolved into rovers. Each manager now had multiple three-person teams reporting to them and had a larger number of direct reports. Managers were no longer responsible for directly managing projects. They had to learn how to stay in touch with the detailed goings on of each of their three-person teams and to offer managerial or technical support when they were needed.

#### Technical ownership was less stable

Though we’d love to say that every three-person team fully owns small systems that are fully decoupled from those of other teams, there are plenty of shared systems today. Multiple three-person teams share on-call rotations. As a disciple of Amazon’s two-pizza teams, where each team exclusively owns a mandate and the systems that deliver the mandate, I was uncomfortable with the idea of shared ownership. I worried that our teams would have a diminished sense of ownership and wouldn’t invest in making their systems better.

In truth we’ve never been better at investing in technical improvements. I think the reason is that ownership is psychologically complex. Though sharing systems may create a diminished sense of ownership, the narrower and deeper mandates of the three-person teams hugely increased the sense of ownership that our engineers felt.

I owe credit to Kris Gale and Kellan Elliott-McCrea, who encouraged me to think of different ways of designing team responsibilities and ownership.

#### Our engineers were less connected to each other’s work

Though our team was happy with three-person teams, they started to report that they wanted to know more about what their colleagues were working on. Our teams would sometimes discover overlapping or complementary work. We haven’t totally solved this problem, but are experimenting with having each team send a very short (paragraph-length) summary of what they did each week.

#### We created more work for product managers and designers

In one sense our three-person teams weren’t really three people. Each team also had an associated product manager and a designer. They had to juggle more teams. Our product management team is well-staffed and could handle the larger number of teams. Increased output and increased parallelism sometimes put a strain on our design team.

* * *

Our experience with three-person teams has been positive. We’ve delivered faster, we’ve had more fun, and we’ve improved at developing talent. Scaling the number of three-person teams will be a challenge. We’ll have to identify and train more project leads, and we’ll have to scale engineering management, design, and product management to keep pace with the number of teams.

Thanks to [Yann Gregoire](https://medium.com/@yann.gregoire?source=post_page), [Beccah Erickson](https://medium.com/@beccaherickson?source=post_page), and [Sam Herbert](https://medium.com/@sherb?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
