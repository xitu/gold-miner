> * 原文地址：[How to Optimize Enterprise-Scale Node.js Applications](https://www.javacodegeeks.com/2018/08/optimize-enterprise-scale-node-js.html)
> * 原文作者：[AppDynamics](https://www.javacodegeeks.com/author/appdynamics)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/optimize-enterprise-scale-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/optimize-enterprise-scale-node-js.md)
> * 译者：
> * 校对者：

# How to Optimize Enterprise-Scale Node.js Applications

![](https://www.javacodegeeks.com/wp-content/uploads/2018/07/advanced-node-js-success.jpg)

**Summary**

Cisco (AppDynamics) is ranked the highest in this year APM Report. [Download Gartner’s 2018 Magic Quadrant for APM to learn more!](https://www.appdynamics.com/gartner-magic-quadrant-application-performance-monitoring-2018/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=sponsored%20post%20cta%20sponsorship&utm_content=gartner%E2%80%99s%202018%20magic%20quadrant&utm_term=sponsored%20post%20cta%20sponsorship&utm_budget=digital)

**Get the Advanced Node.js Success Guide to discover expert techniques for optimizing, deploying, and maintaining enterprise-scale Node.js applications.**

Node.js is rapidly becoming one of the most popular platforms for building fast, scalable web and mobile applications. In fact, the [2017 Node.js User Survey](https://foundation.nodejs.org/wp-content/uploads/sites/50/2017/11/Nodejs_2017_User_Survey_Exec_Sum.pdf) reveals that there are currently over 7 million Node.js instances online, with three in four users planning to increase their use of Node.js in the next 12 months. And it’s easy to see why: 68 percent of those users say Node.js improves developer productivity, 58 report it reduces development costs, and 50 percent say it increases application performance.

As Node.js increasingly becomes the preferred technology for application development, the demand for expert Node.js developers will also continue to increase. But while plenty has been written about what Node.js can do, how developers can get started using it, and why it has become a core server-side technology with some of the world’s biggest corporations—there’s _not_ much that’s been written to help beginner or intermediate Node.js developers take their skills to the next level. _Until now._

In our latest eBook, [Advanced Node.js: Optimize, Deploy, and Maintain an Enterprise-Scale Node.js Application](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital), we share advanced techniques for launching and running an enterprise-scale product, service, or brand built on Node.js.

This is a topic that has not, in our opinion, gotten the attention and expert insights it deserves. In most cases, the post-launch journey is far longer and has a bigger impact than the development process itself. This stage also determines whether a Node.js application will succeed or fail at delivering on the business value the technology promises.

[The eBook](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital) provides a practical foundation for success during the critical first three months or so of a successful Node.js journey—the time span that covers the period from pre-production planning to continuous deployment and testing.

Specifically, the eBook offers tips, tricks and best practices for each of the following critical points:

## 1. Preparing for Production Launch

Preparing for a release is always a critical point in any application development journey, and that’s certainly the case for Node.js projects. It’s your team’s final opportunity to find and fix issues before they impact your deployment process, your end users, or the business itself.

The eBook walks users through a pre-release process with the following areas of emphasis:

*   Optimizing Your Code
*   Best Practices for Error Handling
*   Confirming Your Code Meets Security Requirements
*   Configuring for a Production Environment
*   Deployment Considerations

When it comes to code optimization, one of the many [pre-production best practices detailed in the eBook](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital) is a process called “linting.” This entails running an automated code quality tool—such as ESLint or JShint—through your codebase. It usually covers only very basic quality issues, but that’s the point: It catches avoidable—and usually very easy-to-fix—errors before they put a production application at risk.

## 2. The First 24 Hours of Your Node.js Deployment

After covering the fundamentals of an effective pre-production workflow, we next look at what to expect and how to respond during the critical first 24 hours after deployment.

Deploying an enterprise application can be harrowing. After all, [XebiaLabs’ Application Release Automation Trends survey](https://www.wired.com/insights/2013/04/why-30-of-app-deployments-fail/) revealed that up to 30 percent of all application deployments fail. Meanwhile, the [Trends in DevOps, Continuous Delivery & Application Release Automation survey](https://techbeacon.com/survey-paints-discouraging-scenario-enterprise-it-software-delivery-development) revealed that 77 percent of organizations have software production release problems. Clearly, anyone tasked with deploying an application should be ready for things to go wrong—perhaps very wrong.

While a robust pre-production process can help minimize the impact of bugs, configuration failures, and other avoidable problems, expert Node.js developers must know how to address common “Day One” deployment problems—particularly those that result in crashes or other high-impact issues.

Typical problems that may arise within the first 24 hours include:

*   Crashing Node.js Processes
*   Exceeding API Rate Limits
*   Troubleshooting WebSocket Issues
*   Dependency Issues
*   File Upload Issues
*   DDoS Attacks

The good news about these Day One surprises (and there will be surprises) is that you’re going to learn a lot about building better Node.js applications and about deploying your applications with fewer post-deployment issues. While problems can and will continue to happen in the future, truly serious problems will probably be fewer and farther between.

Even better news is that once you effectively troubleshoot these Day One issues, you’ll be dealing with a more stable and reliable application. That, in turn, frees you to focus on ways to improve your application’s performance and to upgrade your own process for building, testing, and deploying Node.js applications.

## 3. Ongoing Management

Having successfully deployed, the final chapter of [the eBook](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital) looks at the ongoing management of your Node.js application. While this isn’t too different from any other application rollout, there are a couple of specifics you should watch out for:

*   Memory Leaks
*   Managing Node.js Concurrency
*   Monitoring

As we discuss in the eBook, application performance monitoring (APM) is vital to maintain the stability of your application deployment and to detect subtle regressions that may result in application slow-down or outright failure if left unchecked. An [APM solution like AppDynamics](https://www.appdynamics.com/solutions/nodejs-monitoring/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital) can offer end-to-end insight into application behavior and provide specific monitoring capabilities for the Node.js stack.

[Get the Guide](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital)

Read all the best practices for deploying and managing your Node.js applications in our latest eBook, [Advanced Node.js: Optimize, Deploy, and Maintain an Enterprise-Scale Node.js Application](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital).

[Download this Forrester report](https://blog.appdynamics.com/news/forrester-reveals-roi-of-appdynamics-with-cisco/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=sponsored%20post%20cta%20sponsorship&utm_content=forrester%20report%20&utm_term=sponsored%20post%20cta%20sponsorship&utm_budget=digital) to gain insights into the cost savings and business benefits you can expect from AppDynamics APM and its integration with Cisco technology.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
