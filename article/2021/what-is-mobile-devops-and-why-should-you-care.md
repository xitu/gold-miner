> * 原文地址：[What Is Mobile DevOps, and Why Should You Care?](https://betterprogramming.pub/what-is-mobile-devops-and-why-should-you-care-7e9094c8b034)
> * 原文作者：[Lew C](https://medium.com/@lewwybogus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/what-is-mobile-devops-and-why-should-you-care.md](https://github.com/xitu/gold-miner/blob/master/article/2021/what-is-mobile-devops-and-why-should-you-care.md)
> * 译者：
> * 校对者：

# What Is Mobile DevOps, and Why Should You Care?

![Photo by [panumas nikhomkhai](https://www.pexels.com/@cookiecutter?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/black-and-gray-mining-rig-1148820/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/2248/0*zjF_VbIhCWVGgLkz.jpeg)

Lately, it feels like there is an ever-increasing number of terms and phrases that refer to newer ways to develop software. It can be hard to keep up and understand what all these new terms mean or what they specifically mean to you. As someone who has been automating application builds and tests for a few years now, when I heard of the term **mobile DevOps**, even I wondered what made it different from normal DevOps (that is, the DevOps processes that I already used in my applications and experienced in my teams).

Unfortunately, DevOps in itself has become something of a buzzword. Worse still, many online services fit well into a DevOps pipeline. This can be a bad thing because when you search online for DevOps or even mobile DevOps, a lot of the information you read online is on sites that are trying to sell you their very own solutions that fit into that pipeline. So if you need to be in a meeting in five minutes and you’ve searched “what is mobile DevOps?” on Google and landed on this article, let me make it simple for you. It’s just the DevOps methodology applied to phone apps. That’s it. It’s not mobile. It doesn’t go anywhere. It’s literally everything you know and love about DevOps, just applied to the context of phone apps.

But for a long time, software development agencies got software completed and out the door without anything DevOps related. And if you’re coming from a more traditional waterfall approach to software development, it can be beneficial to reflect on what DevOps can offer you and, more precisely, what mobile DevOps can offer your development team.

So let’s take a simple approach to understanding what mobile DevOps is and how it can fit into your pipeline. To do so, let’s consider how software development practices have changed over the years.

## In the Beginning, There Was the Waterfall

For a long time, software development projects used the waterfall model for their software development lifecycle (SDLC). The waterfall approach looked like this:

![(Peter Kemp / Paul Smith — [Wikimedia Commons](https://en.wikipedia.org/wiki/Waterfall_model#/media/File:Waterfall_model.svg))](https://cdn-images-1.medium.com/max/2560/0*pL2-XY8eOsplMMRQ.png)

The stages of the waterfall model were as follows:

* **Requirements** — Clearly define the requirements of the application. In this phase, it’s important to capture all of the possible requirements for the system.
* **Design** — Use the requirements determined in the previous step to work out a system design. This is the part where we would normally also define what hardware and software we need for our software to work.
* **Implementation** — Using the design document (which defines the architecture for our app) we implement the expected functionality in small programs. Every unit that we create is developed and tested against its functionality.
* **Integration and testing** — The units that have been developed are integrated into a system after being tested individually. After the system has been integrated, the entire system is then tested for any outstanding bugs or issues.
* **Deployment of system** — Our hard work is coming to an end! The testing is completed, and now we can deploy our app to the stores.
* **Maintenance** — After the deployment has been completed, it’s possible that issues can crop up in the future. Over time, patches are released to resolve problems that were not encountered during the initial development or implementation.

Of course, there is nothing wrong with this approach. Development teams used it for years, and nobody suffered because of it. When the method was adhered to, the result was high-quality software. One reason for this was that the steps only progressed in a linear motion from left to right — for example, the design phase could only begin once the requirements phase was complete, implementation could only be started when the design was finished, and so on and so forth.

On the surface, this approach seems ubiquitous. In systems where the requirements were well defined, it worked quite well. But more recently, we’ve seen fewer software projects adopt this methodology, and instead, we’ve seen the rise of DevOps as a more modern, flexible development framework. But why is that?

### What’s wrong with the waterfall?

In a perfect world, the waterfall model would probably always work fine. Unfortunately, as developers, we know that we don’t live in a perfect world. And this can introduce some difficulties. For example, people’s requirements can change, and this change can occur at an inopportune time.

To illustrate, imagine that your customer has requested an app that can let users book a car to rideshare. You’re at the implementation stage, and suddenly, a new competitor comes to the market with a product that lets people get food delivered to their house from nearby fast-food stores.

If this is an area you’d also like your app to compete in, you can’t break out of the implementation stage and suddenly revert back to the design phase to put your function in. If we went against this and reverted back to the design phase anyway and then tried to resume from there, then we wouldn’t technically be following the waterfall model anyway, and the benefits yielded from following a software development lifecycle would be largely lost. Software lifecycles are supposed to ensure a certain level of quality, so if you just disregard them and do your own thing, you do so at your own risk.

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
