> * 原文地址：[Automation Testing: Everything You Should Know](https://blog.bitsrc.io/everything-you-need-to-know-about-automation-testing-c051e2e3444)
> * 原文作者：[Abhiraj Bhowmick](https://medium.com/@abhirajbhowmick)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/everything-you-need-to-know-about-automation-testing.md](https://github.com/xitu/gold-miner/blob/master/article/2022/everything-you-need-to-know-about-automation-testing.md)
> * 译者：
> * 校对者：

# Automation Testing: Everything You Should Know

We’ve long believed that automation testing is a wonderful formula for improving the quality of apps right from the start.

However, it is only when we begin automating that we grasp the true reality.

We frequently confront issues such as deciding when to start automating tests, what tests to automate, how to choose the correct technology, and how to write automation test scripts that follow the best practices.

![](https://cdn-images-1.medium.com/max/2000/1*5deSGTLdumw11ET2Mi5goA.png)

So let’s discuss all this in detail in this article.

### What is Automation Testing and How Does It Work?

It is a method in which automation tools run a test suite, perform predetermined actions on a software application, report on the results, compare them, and generate detailed test reports.

Test automation requires financial and human resources, long development cycles, and repeated executions. However, before we begin automating tests, we must first determine the best time for automation, the breadth of automation, and the best tool for automation. It might lead your project to unexpected additional costs if this process is not done properly from the beginning.

Automated tests can be done across several servers during off-peak hours (midnight) and consume a fraction of the time that manual testing takes. This implies that the developer and tester’s time is used in the most efficient way possible, and the team receives faster feedback on code quality.

## Criteria for Automation

To be automated, a test must match certain conditions; otherwise, it may wind up costing more than it saves. After all, saving time, effort, and money is a fundamental purpose of automation.

Here are some general test automation criteria. Keep in mind that these are only suggestions. Depending on your circumstances, your criteria may differ.

### Repeatable

The test must be able to be repeated. Automating a test that can only be run once makes no sense. The following three steps comprise a repeatable test:

* Configure the test, including the data and the environment.
* Execute the function and determine the outcome.
* Clean up the data as well as the surroundings.

We want to be able to make the environment consistent in the initial phase.

### Determinant

When a function is a determinant, the result is the same each time it is performed with the same input. The same may be said for automated tests.

Let’s imagine we wish to put an additional function to the test. We now know that 1+1=2, and that 394.19 + 5.81 = 400.00. The function of addition is determinant.

Software, on the other hand, may have such a large number of varied inputs that getting the same result over time is challenging. Some variables may be completely random, making it difficult to predict a specific outcome.

### Unopinionated

You cannot automate matters of opinion. This is where usability testing, beta testing, and so forth really shine. User feedback is important, but it just can’t be automated … sorry!

Most devs say software test automation demands considerable investments of money and resources.

## Testing at different levels

A strategy to decide the number of tests to automate is the test automation pyramid. This strategy suggests writing three types of tests with different levels of granularity. The higher the level, the fewer tests there are to write.

## Type of automation tests

Knowing what are the different forms of automated testing is critical when it comes to integrating test automation in your QA department. This will give you a good idea of how comprehensive a test automation program is, and if you can integrate it into your present quality assurance procedures or not. Furthermore, understanding the various sorts of tests allows you to make informed decisions about which types of testing would produce the best results for your organization.

There are many different types of test automation. The following is a comprehensive list of the most common ones:

### Code Analysis

Static and dynamic code analysis tools are just two of the numerous types of code analysis tools available. Some of these checks are for security issues, while others are for style and form.

When a developer checks in code, these tests are run. There isn’t much test writing to perform with these automated tests other than configuring rules and keeping the tools up to date.

### Unit Testing

Unit testing is doing tests on individual components in isolation to ensure that they function properly. It is commonly the first type of automated testing performed on an application because it is usually done during the development phase.

### Integration Testing

Integration testing entails testing the application’s various elements as a whole.

When it comes to automation, integration tests are a unique kind. Integration tests, often known as end-to-end tests, are more difficult to put up since they must interface with external dependencies.

When working with resources that aren’t under your control, it’s often beneficial to construct false external resources.

### Performance Testing

Performance testing is putting a piece of software through its paces, stability, and responsiveness while under load.

The fundamental goal of performance testing is to detect and eliminate any potential performance bottlenecks so that the program can offer the best results to the end-user.

Performance testing is an important part of assuring a product’s market success since it helps uncover potential issues that consumers may encounter, such as slow software functioning under a heavy workload.

### Regression Testing

Regression testing is a sort of maintenance testing. It entails running functional and non-functional tests again to see if the software behaves the same way it did previously after a code or program change.

The software is said to have regressed if the performance is no longer the same.

The primary goal of regression testing is to guarantee that existing functionality is not harmed as a result of code changes.

### Smoke Testing

Smoke testing, also known as “Build Verification Testing” and “Confidence Testing,” is a series of tests designed to evaluate the stability and viability of the software’s delivered build.

Smoke testing is used to determine whether an application should be shelved due to lack of functioning or moved on to the next stage of testing. Once the generated software functions have been merged with the software build, smoke testing is performed.

Any failures in testing at this stage will almost always result in the application being sent back to the development team for changes.

## Why use automated tests?

### Pocket-friendly

Contrary to popular belief, automated testing can be less expensive than manual testing. You can’t conduct repeating tests with manual testing. In reality, the cost of manually testing your application increases over time.

Automated testing, on the other hand, is less expensive in the long run since once you’ve built your test scripts, you can reuse them at any time without incurring additional costs. True, automation adoption is initially costly, but it will quickly pay for itself.

It’s important to remember that the amount of the automated testing ROI is determined by the extent of automation adoption. The bigger the return on investment is, the more automated test cases you create and use.

### Time-Saving

You can save time by automating your tests. Automated tests are quick to complete and can be repeated. To put it another way, you won’t have to wait weeks to do the tests again — only a few hours will be enough.

Automated testing accelerates development by taking advantage of their quick execution and repeatability. Transitioning from manual testing to automation will shorten your development time and increase your productivity.

### Better Accuracy

You’re more likely to have error-free releases if you use test automation. Automated testing is more accurate than manual testing because it requires less human intervention.

The problem is that a human tester can make mistakes at any stage of the review process.

The machine, on the other hand, will not cooperate. Because generated test cases are more precise than human testers, you can lower the likelihood of failure by removing human errors.

### Immediate Feedback

Another advantage of automated testing is that it provides immediate feedback.

Developers receive testing reports instantaneously with fast test execution, so they can react swiftly if a problem happens. Forget about deciphering the code that was written three weeks ago.

When your app is already on the market, immediate feedback is very useful. Manual testing can simply slow down the process if you need to fix some errors immediately.

Test automation, on the other hand, will allow you to make quick changes to your application.

As a result, automated testing leads to increased team responsiveness, improved user experience, and increased customer satisfaction.

### DevOps Implementation

Every commit to the source code must be tested as part of the CI/CD pipeline, and there’s no other way to accomplish it fast and efficiently than with test automation.

As a result, once you’ve deployed automated testing, transitioning to Continuous Testing and Delivery will be simple.

When the complexity of the code and the number of test cases increases, it becomes increasingly difficult to manage.

## When to use automated testing

If you’re running the same test again and again without altering it, it’s likely that automating it would save you a lot of time. That’s because having a manual task done on a frequent basis wastes your team’s time and is likely to result in additional errors due to inattention.

Human error is no longer a possibility thanks to automation. As a result, the adoption of automated testing can drastically increase quality in particular cases.

The bottom line is that if you can save money while still delivering a high-quality product, do so. This is where automation really shines. Most automation technologies aren’t cheap, so the project must be large enough to justify the investment.

## Common Misconceptions about Automation testing

It is both true and incorrect that test automation will allow you to have more free time. The majority of manual testing time is spent on exploratory and functional testing, which involves manually searching for faults.

Once that process is finished, the manual tester must perform the identical actions over and over again. That time is greatly reduced with automated testing. Instead of writing tests, automation testers spend their time coding them and improving them as needed.

However, after the test is completed, automated testing enables for the reuse of tests, eliminating the need to repeat the entire procedure.

Automated testing allows you to concentrate on more important topics like client needs, functionality, and enhancements.

Furthermore, the software tests can be run each time the source code is amended. Manually performing these tests is time-consuming and expensive, whereas automated tests can be done repeatedly at no additional cost.

Another prevalent misunderstanding concerning automated testing is that it eliminates the need for human involvement.

In all honesty, automated testing is more precise and faster than what people can accomplish without incurring significant human error, thus this misunderstanding is acceptable.

This does not replace the need for face-to-face communication in software development. Instead, it increases that aspect by giving an additional communication route.

## What to and what not to automate

Without necessarily automating tests end-to-end, testing tools can assist with tasks such as product installation, test data creation, GUI interaction, problem detection (think parsing or polling agents equipped with test oracles), defect tracking, and so on.

We shouldn’t try to automate negative or failover tests since they need testers to think analytically, and negative tests aren’t always easy to offer a pass or fail result that can help us.

## Who should be involved with test automation?

With short Agile iterations, testing frequently needs a “shift left” strategy. Because of the shift to the left in the agile development process, testing can begin considerably earlier in the application lifetime.

As a result of this strategy, developers with strong technical skills are increasingly being held responsible for testing, and they frequently collaborate with testers to design test automation frameworks.

When assessing a testing solution, it’s critical to find one that meets the requirements of all team members who will be involved in the testing process. Manual testers, automation engineers, and developers are among them.

## How to automate your tests?

If you are wondering how to start with automation testing, you can follow this easy 5 step process.

### 1. Select software or tools for testing

After you’ve decided which test to automate, you may look at the various testing tools accessible. Consider how a tool will operate with your present software platform before selecting one, as certain tools are better suited to a specific platform.

### 2. Determine which tests should be automated

Choose which test you wish to automate first. Manual and automated testing are used by many software engineers. Certain functionality may need to be manually tested. With UI-licious, you can get started with 0 coding knowledge.

### 3. Plans, Designs, and Scripts

After you have chosen your tools for automation, plan the design of the framework and its features. Then you can plan automation things that are in-scope and out-of-scope. Next, you can start scripting and execution of schedules and timelines

### 4. Execute your automated tests

During this phase, automation scripts are run. Before they may be set to run, some scripts require input test data. Once they’ve been run, they generate extensive test reports you can easily analyze and share with your team.

### 5. Maintain your test scripts

The Test Automation Maintenance Approach is a phase of automation testing that is used to see if the new features added to the software are working properly. When new automation scripts are added, they must be reviewed and maintained in order to improve the effectiveness of automation scripts with each release cycle.

## Conclusion

Test automation allows testers to devote more time to exploratory tests, which often uncover more flaws than any automated test. Because of these and other factors, test automation can make you save time and money on all your projects.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
