> * 原文地址：[Building and Monitoring Your First Github Actions Workflow](https://blog.bitsrc.io/building-and-monitoring-your-first-github-actions-workflow-b9cad4a1014d)
> * 原文作者：[Meercode](https://medium.com/@meercode)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/building-and-monitoring-your-first-github-actions-workflow.md](https://github.com/xitu/gold-miner/blob/master/article/2020/building-and-monitoring-your-first-github-actions-workflow.md)
> * 译者：
> * 校对者：

# Building and Monitoring Your First Github Actions Workflow

![](https://cdn-images-1.medium.com/max/2400/1*BZ_jv-xjX_FfJR5fQH_6UQ.png)

**Github Actions** is Github’s native solution to CI/CD, which is available to the developer’s community since it was launched in 2019. **Action’s** simple, flexible, and affordable nature made many teams migrate from existing **CI/CD** solutions to unlock the endless possibilities of the new platform.

My team has been of the early adopters of **Github Actions**. As a group of highly **Javascript** focused developers, we were able to automate tens of pipelines for our frontend and backend projects. Thanks to **Javascript/Typescript** support of the platform, we created many **Actions** (like **plugins** in traditional build tools) to extend the functionality according to our needs.

After 1 year of experience with Github Actions, we discovered the following advantages of the tool in comparison to former CI/CD solutions we tested:

* Zero management costs (no need for any agents or master nodes)
* Easy to learn and master
* You can keep your workflows in your source code
* A rich **Action** (plugin) library. It’s easy to develop your custom **Actions**.
* Sensible pricing model: 3000 free minutes for premium users of private repositories. Public repositories are completely free!
* It has a rich action library and it is very easy to develop your actions.
* Supports **Linux**, **Windows**, and **macOS** platforms. (**macOS** support is a rare feature among competitors)
* With a self-hosted runner, it’s possible to run a free version on your own infrastructure.

A minor disadvantage of the platform was the lack of monitoring tools you can watch the status of your workflows. The problem got bigger with the increasing number of repositories and pipelines we had to manage. In the end, we decided to develop our own dashboarding solution.

It started as a **React** frontend and **NestJS** backend to consume relevant Github API’s and display it in a clean way. The tool was appreciated among our team members and we continued developing new features.

Recently we released our dashboarding tool as **SaaS** project and started a public beta program to share it with the developer’s community. If you are interested, you can read more about Meercode’s [story on this blog post ](https://dev.to/pankod/public-beta-meercode-a-beautiful-dashboard-and-monitoring-tool-for-github-actions-466g)or visit [meercode.io ](http://meercode.io)to try the product.

To demonstrate how you simply create your workflows on Github Actions, we want to go over a real-life example.

The task is simple. For one of our repositories on Github, we wanted an [AppCenter](https://appcenter.ms/) build to be triggered whenever a pull request is made. Fortunately, AppCenter has a public REST API we can use to start the builds.

The action we are going to create should be triggered when

1. A pull request is opened or re-opened,
2. Unit tests are passing.

If all conditions are met, we’ll start the build on the AppCenter. So let’s start creating our action.

From your repository on GitHub, create a new file in the .**github/workflows** directory named **app_center_pull_request.yml.**

![](https://cdn-images-1.medium.com/max/2684/0*iyCUtUXoh8MF11Rm)

We give our action the name “Pull Request Opened [App]” by using the **“name:”** attribute.

To get our action triggered on pull requests we are going to use native Github workflow events. You can configure workflows to run for one or more events using the **“on:”** syntax. A complete list of workflow events you can use in your actions is documented on this [reference page.](https://docs.github.com/en/free-pro-team@latest/actions/reference/events-that-trigger-workflows)

In the next step, we are going to tell our action what to do when the “**pull_request**” event is triggered.

![](https://cdn-images-1.medium.com/max/2684/0*upqVeOmReybteXcC)

Under the “**jobs:**” attribute, we can add an arbitrary number of jobs to run. We label our first job with **“build:”** attribute and configure it as seen above.

**“runs-on:”** and **“matrix:”** attributes specify the environment the action will run on. “**steps**:” will define the synchronous steps:

* The first step makes use of [another action](https://github.com/mdecoleman/pr-branch-name) from “Actions Marketplace”. It retrieves **“pull request name”** that we can use in the next steps.
* In the second step, we’ll init our app and run the tests. The action will proceed to the next step if the tests run successfully.
* Now, we’ll configure the build for the corresponding branch name by calling the **AppCenter API** with a curl command. We are using the branch name from the first step to build the **URI** of the relevant branch.

![](https://cdn-images-1.medium.com/max/2684/0*Pppq6J46U6HfxvIS)

* Finally, we trigger a build for both iOS and Android versions of the application:

![](https://cdn-images-1.medium.com/max/2684/0*jazO_rGHuFgFg4y0)

To run and test your workflow, just open a pull request. This will trigger and run the action automatically. To view the results, you can go to the **“Actions”** tab of the repository and select your workflow and the corresponding run.

If you go deeper with Github Actions and start to manage a lot of workflows in multiple repositories, you are always free to try the dashboarding solution [Meercode](https://meercode.io/) we mentioned before.

## Learn More
[**Publishing your Deno modules using GitHub**
**With Deno’s lack of package manager and intent of simply “linking to files anywhere on the internet”, a lot of people…**blog.bitsrc.io](https://blog.bitsrc.io/publishing-your-deno-modules-using-github-f2bd86173392)
[**What are GitHub Actions and How to Use Them**
**Intro to GitHub Actions**blog.bitsrc.io](https://blog.bitsrc.io/what-are-github-actions-and-how-to-use-them-e89904201a41)
[**Github Actions: How to deploy Angular App to Firebase Hosting**
**Cloud-Powered Apps with Angular & Firebase**blog.bitsrc.io](https://blog.bitsrc.io/github-actions-how-to-deploy-angular-app-to-firebase-hosting-89a93f9c4fe1)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
