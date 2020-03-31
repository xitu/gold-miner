> * 原文地址：[How to Keep Your Dependencies Secure and Up to Date](https://medium.com/better-programming/how-to-keep-your-dependencies-secure-and-up-to-date-92578c7f3c9c)
> * 原文作者：[Patrick Kalkman](https://medium.com/@pkalkman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-keep-your-dependencies-secure-and-up-to-date.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-keep-your-dependencies-secure-and-up-to-date.md)
> * 译者：
> * 校对者：

# How to Keep Your Dependencies Secure and Up to Date

#### Automatically update your dependencies using Dependabot

![Photo by [Lenin Estrada](https://unsplash.com/@lenin33?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/robot?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/4320/1*dJ1mhPOPA1MVEnUfpaCGjA.jpeg)

A couple of weeks ago, I was searching for examples on GitHub for my latest article about the [open-closed principle](https://medium.com/better-programming/do-you-use-the-most-crucial-principle-of-object-oriented-design-9045dbd1321e). When I browsed through the [.NET Core repository](https://github.com/dotnet/core), I saw a folder that I did not recognize.

This folder, `.dependabot`, contained a single file, `config.yml`. I found out that this was a configuration file for a new service from GitHub called [Dependabot](https://dependabot.com/blog/hello-github/).

I did not know this service.

After a little investigation, I found that Dependabot is a service that scans the dependencies of your repositories. After the scan, Dependabot validates if your external dependencies are up to date.

And the real beauty of this service is:

**Dependabot automatically creates a pull request to update the dependency.**

I started using Dependabot for most of my repositories. In this article, I will show you how to use and configure Dependabot.

---

## Using Dependabot

If you have a public repository on GitHub, you probably have seen the following security warning. GitHub automatically scans all public repositories and sends an alert if it detects a security vulnerability.

![A security alert from Github.com](https://cdn-images-1.medium.com/max/3928/1*0JG50XF4d8nYeLImgp3eoQ.png)

If you want GitHub to scan your private repositories, you have to opt-in by enabling security notifications. The vulnerabilities that GitHub can detect come from the [GitHub Advisory Database](https://github.com/advisories) and [WhiteSource](https://www.whitesourcesoftware.com/whitesource-for-developers/).

Together with the alert, GitHub also describes how to remediate it.

Dependabot takes this process even further and automatically creates a Pull Request (PR) for your repository. This PR solves the security vulnerability.

#### Starting with Dependabot

If you want to use Dependabot, first, you need to [sign up](https://app.dependabot.com/auth/sign-up). Since GitHub acquired Dependabot, it is free of charge.

After sign up, you have to give Dependabot access to your repository. You can do this via the Dependabot user interface or by adding a `config.yml` file to your repository.

![Give Dependabot access to your repositories](https://cdn-images-1.medium.com/max/3364/1*d3x8R3Zqgrj2LlvJYuzZXQ.png)

#### Configure Dependabot

You can configure Dependabot by storing a `config.yml` file in the folder `.dependabot` in the root of your repository.

#### Required options

The following configuration file is from one of my repositories. It only contains the required options.

```YAML
version: 1
update_configs:
  - package_manager: "javascript"
    directory: "/WorkflowEngine"
    update_schedule: "live"
  - package_manager: "javascript"
    directory: "/WorkflowEncoder"
    update_schedule: "live"
```

This configuration file only uses the necessary Dependabot options. Because I have many projects in this repository, I specify two update configs.

* The `package_manager` specifies which package manager you use. Dependabot supports a lot of different package managers such as JavaScript, [Bundler](https://bundler.io/), [Composer](https://getcomposer.org/), Python, [Maven](https://maven.apache.org/), etc. For a complete list, see the [documentation](https://dependabot.com/docs/config-file/).
* The `directory` specifies the location of your package configuration. Usually, this is the root of your repository. If you have many projects in a repository, as I have in the example above, you can specify a subfolder.
* In `update_schedule`, you can specify how often Dependabot should check for updates. Live means as soon as possible. Other options are daily, weekly, and monthly.

Dependabot **always** creates security updates as soon as possible.

#### Optional options

Dependabot has some extra options for changing things such as the branch, the commit message, and assignees for the pull request. See below for the full list.

* `target_branch `— Branch to create the pull request against.
* `default_reviewers `— Reviewers to set on the pull requests.
* `default_assignees` — Assignees to place on the pull requests.
* `default_labels` — Labels to put on the pull requests.
* `default_milestone` — Milestone to set on pull requests.
* `allowed_updates` — Limit which updates are allowed.
* `ignored_updates` — Ignore specific dependencies or versions.
* `automerged_updates` — Updates that Dependabot should merge automatically.
* `version_requirement_updates` — How to update the version of your app.
* `commit_message` — Things to add to your commit message.

#### Validate configuration file

There is a [page](https://dependabot.com/docs/config-file/validator/) on the Dependabot website that validates your configuration file. Make sure that your configuration file is correct.

---

## Conclusion

I have been using Dependabot for a couple of weeks now. I started with the “live” update schedule but switched to “weekly” as “live” created too many alerts.

I now merge the pull requests from Dependabot once a week.

You must keep your dependencies up to date. If you don’t, the delta between the version you use and the latest version increases. This increasing difference makes it more challenging to update the dependencies.

Thank you for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
