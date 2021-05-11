> * 原文地址：[What Is Mobile DevOps, and Why Should You Care?](https://betterprogramming.pub/what-is-mobile-devops-and-why-should-you-care-7e9094c8b034)
> * 原文作者：[Lew C](https://medium.com/@lewwybogus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/what-is-mobile-devops-and-why-should-you-care.md](https://github.com/xitu/gold-miner/blob/master/article/2021/what-is-mobile-devops-and-why-should-you-care.md)
> * 译者：[Kimhooo](https://github.com/Kimhooo)
> * 校对者：

# 移动 DevOps 是什么和你值得关注的？

![Photo by [panumas nikhomkhai](https://www.pexels.com/@cookiecutter?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/black-and-gray-mining-rig-1148820/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/2248/0*zjF_VbIhCWVGgLkz.jpeg)

最近，似乎有越来越多的术语提到了开发软件的新方法。我们很难跟上和理解这些新术语的含义，或者理解它们的对我们的具体含义。作为一个几年来一直浸淫在自动化应用程序构建和测试的人，当我听到术语 **mobile DevOps** 时，我很想知道是什么让它不同于普通的 DevOps（也就是说，我已经在我的应用程序中使用了 DevOps 流程，并且我的团队也有了经验）。

不幸的是，DevOps 本身已经成为了一个流行词。更糟糕的是，许多在线服务很适合 DevOps 流水线。这可能是一件坏事，因为当你在网上搜索 DevOps 甚至是移动 DevOps 的时候，你在网上看到的很多信息都是来源那些试图向你推销他们自己的解决方案的网站上。所以，如果你需要在 5 分钟内参加一个会议，然后你在 Google 上搜索了“什么是 mobile DevOps？”并打开了本文，那么让我为你简化一下:这只是应用于手机应用程序的 DevOps 方法。就这样,它不是可以移动的,它哪儿也去不了。这确实是你对 DevOps 所有的认知和喜爱，它只是应用到手机应用程序的环境中。

但是很长一段时间以来，软件开发商在没有任何与 DevOps 相关的东西的情况下完成了软件的开发并将其推出市场。如果你是从更传统的瀑布开发模式来开发软件，那么反思一下 DevOps 能为你提供什么，更准确地说，移动 DevOps 能为你的开发团队提供什么，是很有好处的。

所以，让我们用一个简单的方法来理解什么是 mobile DevOps，以及它如何适合您的流水线。为此，让我们回忆一下这些年来软件开发实践是如何变化的。

## 万物始于瀑布流模型

长期以来，软件开发项目在其软件开发生命周期（SDLC）中使用瀑布模型。瀑布模型如下所示：

![(Peter Kemp / Paul Smith — [Wikimedia Commons](https://en.wikipedia.org/wiki/Waterfall_model#/media/File:Waterfall_model.svg))](https://cdn-images-1.medium.com/max/2560/0*pL2-XY8eOsplMMRQ.png)

瀑布模型的不同阶段如下：

* **需求来临** - 明确定义应用程序的需求。在这个阶段，获取系统的所有可能需求是很重要的。
* **设计** - 使用上一步确定的需求来制定系统设计。在这一部分中，我们通常还会定义软件工作所需的硬件和软件。
* **实现** - 使用设计文档（定义应用程序的体系结构），我们在程序雏形中实现了预期的功能。我们创建的每个单元都是针对其功能进行开发和测试的。
* **集成和测试** - 已开发的单元在单独测试后集成到系统中。在完成系统集成之后，整个系统将被测试是否存在任何未解决的 bug 或问题。
* **系统部署** — 我们的辛勤工作即将结束！测试已经完成，现在我们可以将我们的应用上架到应用市场。
* **后期维护** — 上架完成后，未来可能会出现问题。随着时间的推移，开发者会发布修补程序来解决在初始开发或实现过程中没有遇到的问题。

当然，这种开发方式没有问题。很多开发团队使用这种开发方式很多年了，没有人因此而受折磨。如果坚持这种开发方式，得到的就是高质量的软件。其中一个原因是，这些步骤只是以从左到右的顺序进行的 —— 例如，设计阶段只能在获取需求阶段完成后开始，实现功能阶段只能在设计阶段完成后开始，等等。

表面上看,这种方法似乎十分普遍。在需求定义良好的系统中,它工作得非常好。但是近来，我们看到采用这种方法的软件项目越来越少，相反，我们看到了 DevOps 作为一种更新颖、更灵活的开发框架的流行。但这是为什么呢？

### 瀑布流模型有什么缺点?

在一个完美的世界里，瀑布模型可能总是工作得很好。但不幸的是，作为开发者，我们知道我们并不是生活在一个完美的世界里。这会给瀑布模型带来一些困难。例如，人们的需求可能会发生变化，而这种变化可能会发生在不合适的时候。

举个例子，假设您的客户要求开发一个应用程序，可以让用户预订一辆汽车进行共享。您正处于开发阶段，突然，一个新的竞争对手来到市场，推出了一款产品，让人们可以从附近的快餐店将食物送到家中。

如果这是一个你也希望你的应用程序参与竞争的领域，你就不能脱离实现阶段，突然回到设计阶段来实现你的功能。如果我们违背这一点，返回到设计阶段，然后试图从那里重新开始，那么从技术上讲，我们就没有遵循瀑布模型，遵循软件开发生命周期所产生的好处将在很大程度上丧失。软件生命周期应该确保一定的质量水平，所以如果你只是无视它们，做你自己的事情，你这样做是在自负风险。

![Photo by [Tima Miroshnichenko](https://www.pexels.com/@tima-miroshnichenko?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/people-working-in-a-call-center-5453837/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/2250/0*LCN7rmJbT7y7F8rB.jpeg)

### Everyone’s in their own silo

In a pre-DevOps world, the people involved in the deployment and support of applications were largely siloed. Your developers would work in one space, your quality assurance (QA) team in another, and the support staff for your app in yet another. That’s not including the people who are required to actually host your app, plus everyone else who is involved in the reliable hosting of your app.

This can lead to some communication problems, as developers produce new releases, give them to the QA team, deploy them to a test environment, and then repeat this until a release is finalized. For example, because the hosting team is so far removed from the development side of things, it is possible (and has happened) that the developers could make something only for the hosting team to rebuff their work because it won’t work in the hosting environment.

## The Rise of DevOps

As time went on, people began to shift to DevOps methodologies for their software development. The boundaries between these separate, discrete teams were removed, and people were encouraged to work together. The people who created the apps (developers) were put closer to the people who were responsible for supporting customers who were using the app, as well as the people who hosted the website and database (operations). DevOps was a huge change for any existing software development shop and required a significant cultural shift to be fully implemented.

Another significant component of DevOps was the rise of continuous integration/continuous development (CI/CD). Instead of development following a single linear progression as in the waterfall method, smaller changes were implemented over time into smaller releases. The features in these smaller releases were tested by automated testing systems, and the test suites grew in size as the apps grew in functionality. Over time, more of the pipeline was automated, with releases being tested by automated testing tools, and releasing into production was not as big of a hurdle as it once was.

DevOps is a huge topic in itself, and you’re currently on a site that plays a big part in this process (namely the CI/CD part of it), so you probably already know a lot about this. That said, how does it relate to mobile DevOps?

![Image source: [Twenty20 Photos](https://www.twenty20.com/)](https://cdn-images-1.medium.com/max/4196/0*sT-ZTxnoQ2p11xzy.png)

## Mobile DevOps

One of the core tenets of DevOps is to automate as much as you possibly can. It’s essentially a methodology that you can apply to various work processes. And it basically comes down to two things: speed and quality. You want to increase the speed of your releases to the app stores without sacrificing the quality of your app. More frequent updates mean that bug fixes and features are released sooner and users typically have a better experience with your app.

In a typical update cycle for an app that has already been released to the store, there is a requirement to release updates and fixes for issues that affect the application. You may know how to fix an issue, but after you have done so, you then need to spin up your test environment (with test endpoints for your app), complete the application testing, and then manually submit it to the various stores to get your update released. The time involved in this kind of effort is significant. And to make matters worse, every time you push an update to your app, you have to go through this kind of process.

In times of real distress, like when you are chasing a bug in your app and don’t really know where it is or how to fix it, you can wind up pushing a few updates within a short time frame. As the release steps (testing and then deployment) are repetitive, the person doing this could become fatigued and end up causing more issues in the long run. It’s not hard to see how a situation could quickly unravel, given the stress and anxiety that usually occur in times like this.

Unfortunately, companies usually don’t invest enough time in trying to better their processes or optimize release pipelines. The common thought is that these kinds of adjustments take a lot of time and if what we have now works well, why change it? Well, there are some fairly compelling reasons to learn about mobile DevOps and use as many of its components as possible.

## Switching to Mobile DevOps

To visualize what the change to mobile DevOps would look like, let’s imagine a team tasked with creating an app for a grocery store. The app is released, and the team is in their business-as-usual (BAU) phase of support, resolving new issues with the app as they crop up and then implementing new features as time goes on.

Once they have implemented a new feature or fix, they need to create the test environment with a database and fake data to test against. Of course, it wasn’t so long ago that the only way people could create these “test environments” for their app was to set up physical servers in a physical server room (or something equivalent) and then configure these servers to host the test environment.

Traditionally, this would be accomplished by following documentation or something that explained how to set these environments up. These environments were oftentimes referred to as being “lovingly crafted,” as it took hours of painstaking work to create these environments in a very specific way. Because doing this is a very manual process, sometimes each iteration of the test environment would have minor differences. This means that for our development team, bugs are sometimes raised for the app as a result of slight variations within the test environment and not actually because of an issue with the app itself. As you can imagine, this wastes time as developers try to chase issues that don’t actually exist.

### Making it easier to create the environment

The first thing this team could do is try to automate some of these aspects. Automating the process of creating the test environment would have many benefits, such as giving the developers a guaranteed environment that is unaffected by environment drift (as it can be deleted and re-created at a moment’s notice).

Unfortunately, many people believe that their app or service is too complicated to successfully automate the creation of an environment. But at bigger companies, like Google or Facebook, the environments are far too complex to depend on someone to create them manually every time, so they have no choice but to automate these processes. The moral of the story is if bigger companies can automate the creation of environments for their complicated apps, you can certainly automate the creation of your app’s environment.

Back to our development team — they’ve managed to successfully automate the creation of their testing environment by using [Docker](https://www.docker.com/) (or something else, like [Kubernetes](https://kubernetes.io/)). Now they can begin to write test suites for their entire application. Unfortunately, too many apps out there today are written without any supporting automated tests for the app itself.

When a developer fixes an issue for a certain bug, they just test in the emulator or on a physical device to see if the issue still happens or not. If it doesn’t, then the issue is thought to be resolved, and the app is released to the testers to validate the full test suite on the app itself. Within very small development teams (or even one-person development teams) where there is a real lack of time, this manual test step is sometimes skipped, as the bug is thought to be fixed. When this happens, we can be reasonably sure that the original issue is resolved, as the developer has tested for that, but we have no way of being sure that this fix hasn’t introduced new issues. And that’s where the problems begin.

### Making it easier to run the test suite

At the moment, our team in this example is relying on a manual test suite that is run by the developers or testers. The whole test suite takes about a day or two to run and has to be done manually. So the tester has to open the app and follow a series of steps to complete the test for the app to check whether it is working as intended or not.

Unfortunately, this is quite slow, so the reality is that the full test suite doesn’t get run as often as it should, and the results are also quite inconsistent. Even though we’ve shored up the environment and it is now in a known state when it is deployed, the user running the tests becomes fatigued as they repeat the same boring steps over and over again. The reality is that our user isn’t a machine — they will stop for coffee breaks, chat with co-workers, and watch the occasional cat video to make this boring task more palatable. In doing so, they might lose their place or skip a step, rendering the test suite less effective without them even knowing that this is the case.

Instead of relying on manual tests, in order to fully adopt mobile DevOps, our team should try to automate the tests for our phone app. After all, a user is following a set of steps by tapping on the phone screen, observing its results, and then writing about how it went. These tasks can also be performed by a unit testing framework, like [Espresso](https://developer.android.com/training/testing/espresso) tests, for Android, or the equivalent test runner for the platform in question. As the number of tests increases, more areas of the app can be tested, which increases the likelihood that the app is functioning as expected.

We start to save more time while increasing the quality of our app when we incorporate these tests into our application build pipeline. For our team, that means that every time a new commit is pushed into the main code branch, the full suite of automated tests is run. The benefits of this are simply enormous. If new issues are introduced by fixing another problem, these defects are caught by the automated tests before any new app versions are pushed out. This means they’re not finding bugs two months down the track and not knowing when they were introduced.

### Making it easier to get the releases done

Because our team now has the ability to create a test environment at the drop of a hat and now has an automated test suite (which automatically runs when new code is committed), they are more sure of the quality of the codebase. Over time, as the test suite becomes more comprehensive, a successful test run means that the app definitely works. In fact, the test suite has become so comprehensive that it tests 100% of the app. This means that when the test suite completes for the app in question, the app is essentially production-ready. So what else do you do with a production-ready app, apart from release it to production?

That’s the final step of the release pipeline, to automate the deployment of the app to the relevant stores. Obviously, this final step is the most dangerous, as deploying a broken app is really bad for everyone involved, and it can create a lot of issues. But it may surprise you how many companies around the world have automated their entire development and release pipeline.

Did you notice a common theme between the three points above? The theme is making it easier. Ultimately, mobile DevOps can make it easier for you to develop and release quality software. If a process didn’t help you to do this, there would obviously be no point in learning about it.

## How Can I Get Started With Mobile DevOps?

As we’ve seen, mobile DevOps is a huge change for many software development shops, and we’ve largely covered the technical aspects within this article (such as automating as much of the processes as we can). Fully adopting DevOps can cause organizational change, even the merging of teams and reassigning of people’s actual job roles. Not everybody enjoys that type of change, and it is definitely a drastic course of action.

So the best way to get started down this path is to begin to take steps to automate the parts of the task that you can and the parts that will yield the biggest benefit for the time you invest. One of the easiest tasks to start with is to try to get your app to build anywhere so that it doesn’t build just on that one computer in the corner in the office.

After this, you can move on to automated tests and gradually pick and choose the best parts of mobile DevOps until you have a fully automated pipeline. And once you have that, there’s no going back.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
