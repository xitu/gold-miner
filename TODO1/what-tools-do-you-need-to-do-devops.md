> * 原文地址：[Moving to DevOps: what tools do you really need?](https://circleci.com/blog/what-tools-do-you-need-to-do-devops/)
> * 原文作者：[June Jung](https://circleci.com/blog/what-tools-do-you-need-to-do-devops/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-tools-do-you-need-to-do-devops.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-tools-do-you-need-to-do-devops.md)
> * 译者：
> * 校对者：

# Moving to DevOps: what tools do you really need?

![](https://circleci.com/blog/media/tools.png)

DevOps has been the latest in a long succession of problem-solving processes that each come with a digital garage full of tools: CI/CD systems, testing frameworks, monitoring tools, and security audit tools to name a few. Which of these tools do you need? Which will solve the problems, pains, and slowdowns your organization faces? In my time helping teams of all sizes, I kept hearing the same two questions: “What organizational structure do we need to have? What tools should we implement?”

Neither of these are bad questions, but asked in isolation they miss the point. When you go straight to these questions, you are thinking about solutions before you’ve really assessed the problem that you are trying to solve in your organization.

Organizations often think that the top-down model (“Use this! Do this!”) will get their teams innovating faster. Eager team leads will bring in a new CI/CD tool and get everyone up and running on it. Providing proper tooling for individual contributors to follow an adopted practice is important, but the problem comes when team leads will bring in tools without fully understanding its value or why they are doing it. Often even the people who ordered the change will forget why they put it in place to begin with, or what they wanted to get out of it. The sad truth is how easy it is to start misusing tools once the original reasoning is obscured, creating lost or even negative value.

### We want DevOps!

I’ve been brought into countless organizations who were convinced that DevOps was the solution to all their problems, if only they could get it up and running quickly.

If you find yourself in this position, ask yourself, “Why do we want DevOps in our organization? What value do we think it will bring?”

At this point, let’s briefly talk about what DevOps is, and isn’t.

DevOps is a very specific collaboration between developers and operations teams. In essence, it indicates that you’ve culturally adopted development practices into your infrastructure, and operational practices into your development cycle. What does this look like in practice? It can mean maintaining infrastructure as code, or creating immutable infrastructure by building reusable components so you can tear down or up whenever you want, giving you version control and a history of changes you’ve made. It also means getting all product contributors to care more about the end result of what they’re working on - how does it function in the world? How are users interacting with it? Getting people to truly care about quality means caring about both business value and usability. When everyone who is building a product cares about both aspects of quality, cares about what happens when it gets deployed and gets exposed to the end user. That’s the result of true DevOps adoption.

In my experience, this kind of widespread buy-in has been particularly difficult for software teams to achieve because it requires a lot of cooperation from people with different skills and domain expertise. Pulling this off requires both cross-functional team structure and thoughtful communication skills. For example, if an engineer needs to talk to someone on the business side about a database problem, she needs to not just show the data she’s working from, but give necessary context and focus that person’s attention on what they should care about and why.

So, should you bring in that new tool? The answer is: maybe. Tools can sometimes seem like a quick fix, but they are not a one-size-fits-all solution. In my experience, keeping these considerations in mind **before** you bring in a new DevOps tool will increase your chances of success.

### Before beginning your transformation:

**1. Make sure everyone is on the same page** with respect to what you’re trying to achieve with this transformation. Everyone should agree on the problem you’re trying to solve, and that you are aligned on the pain points.

**2. Always start small.** Don’t try to make entire organization into a model DevOps model team overnight. Instead, start with one team, and see if the process changes works within your organization. If you see improvements, keep moving incrementally.

**3. Do what works for you.** Know that DevOps might not be the right solution for your organization. Some companies have been successful for a long time without DevOps, and it might not be right for them, given their culture or their product needs. I’ve personally seen waterfall work really well for some very successful organizations. For example, if confidentiality is a big part of your company’s product strategy, then shipping incrementally to get feedback would not work for you, as you’d need to keep all product details under lock and key up until a big launch. In that environment, it would be very difficult to build a DevOps culture.

**4. Always measure.** Before you start any improvement plan, get accurate metrics for where you’re currently at (i.e. our dev cycle takes X time). Do this before you’ve invited an SRE onto the development team. Then after a small amount of time, you’ll be able to see whether it’s been effective. Measure before and after you make a change, and consistently measure to see if you’ve improved. As an example: When a lot of Agile transformation was happening, a lot of companies adopted standups, without really understanding why, or measuring whether it had a positive effect on their team. This likely wasted more time than it saved.

**5. Do not try to automate everything.** At least not all at once. One misconception about DevOps is that all the infrastructure provisioning and the configuration management must be done automatically. This is referred to as “infrastructure as code.” But some things work better when they are manual; automation is not the solution for everything. Also, think about how many times you’re going to run that automation script and how much time it would take you to automate it. Will you use it thousands of times or only three ? Additionally, sometimes you have to start the manual way to even figure out what would be the best solution for automation. Still itching to automate? Dockerizing your application is a great way to automate because the work you put in is likely to be re-used. Automating pre-production environment creation is another great way to implement automation. For another example: are you trying to automate firewall setup? That might not be worth it given the lack of API support on a lot of current firewall software. While it’s good that you are preparing for disaster, you’d probably be putting so much more value into it than you’ll ever get out of it.

### What’s next?

If your org is thinking about DevOps transformation, start thinking about your speed of delivery and quality of product. What’s getting in your way today? Knowing the answers to these questions will help everyone in your organization understand what your pain points are, so you’ll be in the best position to start improving on them.

In future posts, I’ll walk through some exercises to help you [pinpoint where your organization’s problem areas are](https://github.com/xitu/gold-miner/blob/master/TODO1/path-to-production-how-and-where-to-segregate-test-environments.md), and give you the confidence to assess which tools or processes will be of the most value in solving those problems.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
