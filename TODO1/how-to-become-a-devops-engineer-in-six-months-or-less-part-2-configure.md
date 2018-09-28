> * 原文地址：[How To Become a DevOps Engineer In Six Months or Less, Part 2: Configure](https://medium.com/@devfire/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure-a2dfc11f6f7d)
> * 原文作者：[Igor Kantor](https://medium.com/@devfire?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure.md)
> * 译者：
> * 校对者：

# 如何在六个月或更短的时间内成为 DevOps 工程师，第二部分：配置

![](https://cdn-images-1.medium.com/max/1000/0*CqfqPJ0kz66ZHKtt)

照片由 [Reto Simonet](https://unsplash.com/@reetoo?utm_source=medium&utm_medium=referral) 发布在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

**注意：这是《如何如何在六个月或更短的时间内成为 DevOps 工程师》系列的第二部分，第一部分请点击[这里](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less.md).**

让我们快速回顾一下上期内容。

在第一部分中，我认为 DevOps 工程师的工作是构建全自动的数字流水线，将代码从开发环境转到生产环境。

现在，要有效地完成这项工作需要对基本原理有充分的了解，请看下图所示：

![](https://cdn-images-1.medium.com/max/800/1*GNxucS4v93-XdnD5-vWB_w.png)

<div style="text-align:center">DevOps 基础介绍图</div>

以及基于这些基础知识的工具和技能的良好理解（见下图）。

提示：你的目标是先从左到右学习蓝色字体部分知识，然后从左到右学习紫色字体部分知识。

好的，回到我们的主题。在本文中，我们将介绍上图学习路线的**第一个**阶段：配置。

![](https://cdn-images-1.medium.com/max/1000/1*0S3C5EmK7p_iESafTNB4Ug.png)

<div style="text-align:center">配置阶段介绍图</div>

配置阶段会发生什么？

由于我们创建的代码需要运行在机器上，因此配置阶段实际上是在构建运行代码的基础结构。

在过去，配置基础设施是一项漫长的、劳动密集型、容易出错的考验。

现在，因为我们拥有令人敬畏的云服务，所以只需点击一下或者多点几下即可完成所有配置。 

然而，实践证明通过点击来完成这些任务是一个坏主意。

为什么这么说呢？

因为按钮点击：

1. 容易出错(人为犯错），
2. 没有版本化管理(点击不能存储在 git 中），
3. 不可重复(更多机器=更多点击），
4. 并且不可测试(不知道我的点击是否真的有效或出错）。

例如，想想在开发环境先配置所需的所有工作...然后是初始化环境...然后系统测试...然后进行分级...然后在美国部署生产环境...然后在欧盟部署生产环境...它很快就会变得非常乏味和烦人。

因此，需要一种新的方式。这种新的方式是**架构即代码**，这就是这个配置阶段的全部内容。

作为最佳实践，架构即代码要求无论需要哪些工作来配置计算资源，都必须通过代码完成。

注意：“计算资源”是指在产品中正确运行应用程序所需的一切：计算、存储、网络、数据库等。因此，名称为“架构即代码”。

此外，这意味着，我们将通过架构即代码部署而不是通过点击方式：

1. 在 [Terraform](https://www.terraform.io/) 中写出所需的基础设施状态，
2. 将其存储在我们的源代码控制中，
3. 通过正式 [Pull Request](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow) 流程征求反馈意见，
4. 测试一下，
5. 执行提供所需的所有容器资源。

现在，显而易见的问题是，“为何选择 Terraform？为什么不使用 Chef 或 Puppet 或 Ansible 或 CFEngine 或 Salt 或 CloudFormation 或其他的？”

好问题！ 

简而言之，我认为你应该学习 Terraform 因为如下：

1. 这很新潮，因此工作机会很多
2. 比其他人更容易学习
3. 这是跨平台的

现在，你能选择其中一个并成功吗？绝对能！

* * *

注意：这个领域正在迅速发展，非常混乱。我想用几分钟的时间来谈论一些最近的历史和我看到它的发展。像 Terraform 和 CloudFormation 之类的东西被用来提供基础设施，而像 Ansible 之类的东西被用来配置基础设施。

一般，像 Terraform 和 CloudFormation 这样的东西已被用来提供**基础设施**，而像 Ansible 这样的东西则被用来配置**基础设施**。

您可以将 Terraform 视为创建基础的工具， Ansible 将房子置于最顶层，然后根据您的需要部署应用程序（例如 Ansible ）。

![](https://cdn-images-1.medium.com/max/800/1*9kmJS9w9gNgqJMmmqb_NVg.png)

<div style="text-align:center">如何理解这些工具介绍图</div>

换句话说，您使用 Terraform 创建 VM ，然后使用 Ansible 配置服务器，以及可能用它部署您的应用程序。

通常这些工具在一起使用。

但是， Ansible 可以做的(如果不是全部），Terraform 也可以做。 反过来也是如此。

不要让那些困扰你。只要知道 Terraform 是基础架构代码空间中最具好的工具之一，所以我强烈建议你从这里开始。

事实上，Terraform + AWS 的专业知识是目前最炙手可热的技能之一！

但是，如果你想推迟 Ansible 支持 Terraform ，你仍然需要知道如何以编程方式批量配置服务器，对吧？

不必要！

* * *

实际上，我预测像 Ansible 这样的**配置管理**工具的重要性将会降低，而像 Terraform 或 CloudFormation 这样的**基础配置**工具的重要性将会提高。

为什么这样说呢？

因为所谓的“[不可变部署](https://blog.codeship.com/immutable-infrastructure/)”。

简而言之，就是是指不改变已部署的基础架构的做法。换句话说，您的部署单元是 VM 或 Docker 容器，而不是一段代码。

因此，您不会将代码部署到VM集群中，而是部署一整个已经编译了代码的 VM 。

您不会更改 VM 的配置方式，而是部署更改了配置的新 VM 。

您不会对生产环境机器打补丁，而是直接部署已经打补丁的新机器。

您不在开发环境和生产环境部署的 VM 集群配置不同，它们都是相同的。

你应该明白了我的意思。

如果使用得当，这是一个非常强大的模式，我强烈推荐！

注意：不可变部署要求将配置与您的代码分开。请阅读[12 Factor App](https://12factor.net/），其中详细介绍了这个(以及其他令人敬畏的想法！）。这是 DevOps 从业者必读的内容。

代码与配置的分离非常重要 —— 您不希望每次修改数据库密码时都重新部署整个应用程序。相反，请确保应用程序可以从外部配置存储( SSM/Consul/etc )中提取它。

此外，您可以很容易地看到，如果不可变部署的兴起，像 Ansible 这样的工具开始扮演的角色不那么突出。

原因您只需要配置**一台**服务器并将其作为自动扩展的集群一部分进行多次部署。

或者，如果您正在使用容器，您肯定希望几乎按要求进行不可变部署。你不**希望你的开发容器与你的 QA 容器不同，并且与生产环境不同。

您希望**在所有环境中使用完全相同的容器**。这可以避免配置偏差，并在出现问题时简化回滚。

除了容器之外，对于那些刚刚开始使用 Terraform 的人来说，使用 Terraform 配置 AWS 基础设施是一个教科书 DevOps 模式，你真正需要掌握它。

但是等等...如果我需要查看日志来解决问题怎么办？好吧，您将不再登录计算机来查看日志，而是查看所有日志的集中式日志记录基础结构。

事实上，一些聪明的家伙已经写了一篇关于如何在 AWS 中部署 ELK 集群的详细[文章](https://medium.com/@devfire/deploying-the-elk-stack-on-amazon-ecs-dd97d671df06)- 如果你想看看它在实践中是如何完成的，请点击上面链接查看。

此外，您可以完全禁用远程访问，这样比大多数没有禁用的人更安全！

![](https://cdn-images-1.medium.com/max/800/0*nX3CGWxtkMFh5P5N.jpg)

总而言之，我们的全自动“ DevOps ”之旅始于配置运行代码所需的计算资源 - 配置阶段。而实现这一目标的最佳方法是通过不可变部署。

最后，如果您对从何处开始感到好奇， Terraform + AWS 组合是您开始旅程的绝佳场所！

这就是“配置”阶段的全部内容。

第三部分的内容在[这里](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or -less-part-3-version.md）！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到[掘金翻译计划](https://github.com/xitu/gold-miner)对译文进行修改并 PR，也可获得相应奖励积分。文章开头的**本文永久链接**即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
