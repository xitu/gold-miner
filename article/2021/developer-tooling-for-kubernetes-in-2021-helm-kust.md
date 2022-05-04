> * 原文地址：[Developer Tooling for Kubernetes in 2021: Helm, Kustomize, and Skaffold](https://dzone.com/articles/developer-tooling-for-kubernetes-in-2021-helm-kust)
> * 原文作者：Liran Haimovitch
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/developer-tooling-for-kubernetes-in-2021-helm-kust.md](https://github.com/xitu/gold-miner/blob/master/article/2021/developer-tooling-for-kubernetes-in-2021-helm-kust.md)
> * 译者：[kamly](https://githuc.com/kamly)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin), [greycodee](https://github.com/greycodee), [lsvih](https://github.com/lsvih)

# 2021 年 Kubernetes 的开发者工具：Helm、Kustomize 和 Skaffold

在过去的几年里，我们已经看到在 Kubernetes 生态中出现了大量工具实现更简单的软件开发（这是非常难得的）。正如经常发生在不断发展的生态系统中的那样，一些工具会不断发展并适应，而另一些工具则会被抛弃，或者也至少会被合并到新的产品中。与对我们现有的选择进行最新审视相比，还有什么更好的方式来开启 2021 年呢？

在这个系列博客中，我将介绍目前 Kubernetes 的各种开发者工具和它们在开发工作流中的功能，以及最主要的，我还会介绍每一个工具的重要新闻。在这篇文章中，我将重点介绍用于定义我们的 Kubernetes 应用的工具。他们分别是 [Helm](https://helm.sh/docs/helm/helm_lint/)、[Kustomize](https://kustomize.io/) 和 [Skaffold](https://skaffold.dev/)。

## Kubernetes 清单（YAMLs）

如果你是 Kubernetes 的新手，我推荐你看[这篇介绍](https://www.jeremyjordan.me/kubernetes/)，因为我发现这篇介绍相当的深入。就我们目的而言，你要知道最重要的事情是 Kubernetes 有一个 [声明式](https://www.leverege.com/iot-ebook/kubernetes-object-management-model) 的方法来编排服务。 你把你的服务所需的状态用 YAML 格式写在一些配置文件中，称为「清单」 ，并将其发送给 Kubernetes 以实现该状态。

## Helm

[Helm](https://helm.sh/) 是当之无愧的王者！它是打包，共享，部署 k8s 服务的标准。我们可以将 Helm 看做一个包管理器 —— 它允许你把多个 YAML 配置片段用一致性和结构化的方式组合成一个称为 `chart` 的安装包。 

作为安装包的作者，[创建 Helm chart](https://opensource.com/article/20/5/helm-charts) 可为你带来显著好处：

1. 你可以使用自定义参数让你的服务在部署时候可配置。要做到这一点，你需要使用 [模板](https://helm.sh/docs/chart_template_guide/) 。
2. 你可以用版本化和可跟踪的方式将服务发布到私有或公有仓库中。
3. 你可以让你的服务依赖于其他的 Helm chart。
4. 总的来说，Helm 为你提供了强大的封装能力，以确保你的服务按预期部署。

作为安装包的使用者，[安装 Helm chart](https://helm.sh/docs/helm/helm_install/) 可以为你提供更多：

1. 你可以使用开源可用的 charts 和自己组织私有的 charts。
2. 你可以根据安装包作者提供的设置自定义服务。
3. 你有真实的版本来源来部署安装包。
4. 你不必担心 Kubernetes 规范语言的复杂性。
5. Helm 支持原子操作将服务和集群面临的风险降至最低。
6. 总的来说，你能获取一个易于 [理解](https://www.rookout.com/blog/using-helm-to-improve-software-understandability) 且随时可以使用的服务安装包。

## Helm 有什么新变化？

在 2019 年底，我们看到了 Helm 发布 v3 版本，涉及删除集群端组件（ Tiller ）和大量其他特性。到 2020 年底，Helm v2 已经被废弃，大多数公共 chart 已经迁移到 v3 格式。如果你还在使用 Helm v2，请确保分配时间升级你近期路线图（当你在升级的时候，看看这个 [插件](https://github.com/helm/helm-2to3) 可能会有帮助）。

在过去的几个版本中，Helm 团队一直忙于解决 Helm 用户最抱怨的问题之一 —— 不容易使用 YAML 模板。 Helm 现在拥有一个强大的 [linting](https://helm.sh/docs/helm/helm_lint/) 命令，在调试令人讨厌的 YAML 问题时，它应该是你的新选择。

Helm 新增的另一个很好的功能是 [后期渲染](https://helm.sh/docs/topics/advanced/) 功能，允许你使用 Kustomize 等工具自定义 Helm chart。

最后但并非最不重要的是，2020 年还转向更分散的 chart 管理方式，并推出两个共享 chart 的中央存储库：

1. CNCF 的 [ArtifactHub](https://artifacthub.io/)。
2. JFrog 的 [ChartCenter](https://chartcenter.io/)（查看 Rookout 团队成员 Josh 的 [网络研讨会](https://lp.rookout.com/webinar-modernized-developer-workflow) ，了解更多信息）。

## Kustomize

Helm 最大的缺点是服务的定制仅限于预先存在的配置选项。不仅如此，chart 作者还必须用有点麻烦的模板化方式实现这些定制选项。为了解决这个问题，就有了 [Kustomize](https://kustomize.io/) 的用武之地。

Kustomize 允许你将 Kubernetes 服务构建为一系列层和补丁，从而支持无限定制。 Kustomize 使用基于 YAML 的 Kubernetes-aware 补丁格式来添加/删除/更新服务清单的任何部分。Kustomize 在 [1.14 版本](https://kubernetes.io/blog/2019/03/25/kubernetes-1-14-release-announcement/) 成为了 [kubectl](https://dockerlabs.collabnix.com/kubernetes/beginners/what-is-kubect.html) 不可或缺的一个组成部分，你所要做的就是执行 `kubectl -k` 来调用它。文档不太全，但看官方的 [列子](https://github.com/kubernetes-sigs/kustomize/tree/master/examples) 和这篇 [博客文章](https://www.digitalocean.com/community/tutorials/how-to-manage-your-kubernetes-configurations-with-kustomize) 就会有一些了解。

Kustomize 是一个强大的工具，让你能够以任何方式修改 Kubernetes 中的服务。不幸的是，这也意味着学习曲线可能相当陡峭。任意定制也意味着错误配置服务的可能性增加。Kustomize 的一个高级用例是使用 Helm 的后期渲染功能来 [修补](https://github.com/thomastaylor312/advanced-helm-demos/tree/master/post-render) 现有的 Helm chart，而不需要分叉，希望能让版本升级变得无缝。

## Kustomize 有什么新变化？

Kubernetes 生态系统内的许多工具都嵌入了 Kustomize ，将其功能添加到自己的工具中。最突出的例子是编排和持续部署工具，如 [ArgoCD](https://argoproj.github.io/argo-cd/)、[Flux](https://fluxcd.io/) 和 [Kubestack](https://www.kubestack.com/) 。如果你搜索类似 Kustomize 的补丁功能，请查看你的 CD（持续部署）工具，你可能会在那里找到它。

如果你和我一样不熟悉 Kubernetes 构建过程，那么你可能不知道在初始集成期间，维护者已经将 [kubectl 中嵌入的](https://github.com/kubernetes/kubectl/issues/818) Kustomize 版本冻结在了 2.0.3 。除了让文档更加混乱之外，这意味着 kubectl 内的版本缺少了过去两年中的一系列增强功能。团队在重新集成方面取得了重大进展，希望他们能尽快解决这个问题。同时，如果你需要最新的版本，可以考虑将 Kustomize 作为一个 [独立](https://kubectl.docs.kubernetes.io/installation/kustomize/) 的 CLI 工具。

## Skaffold

[Skaffold](https://skaffold.dev/) 采用了一种不同的方法，遵循 DevOps 的最佳实践，在整个 SDLC 中保持开发环境和工作流的一致性。Skaffold 为开发工作流程、持续集成（CI）和持续部署（CD）构建和部署 Kubernetes 服务。

针对构建，Skaffold 可以使用 Dockerfile、[Buildpacks](https://buildpacks.io/)、 Bazel，甚至是定制脚本(在即将发布的博客文章中有更多关于构建容器映像的内容！)！而针对部署，Skaffold 包含其有限的模板引擎，并且可以调用 kubectl、 Helm 或 Kustomize 。

Skaffold 有三种主要操作模式：

1. **skaffold dev** —— 这将在一个监视、构建、部署循环中运行 Skaffold 。在此模式下，你可以在本地编辑源文件，Skaffold 会将它们部署到你选择的集群中。Skaffold 支持端口转发和日志跟踪，在此模式下工作时可以提供更流畅的开发体验。
2. **skaffold build** —— 这将单次运行 Skaffold 来构建你的工件，并将它们推送到你选择的存储库。
3. **skaffold deploy** —— 这将把你构建的服务部署到你选择的集群中，可能会使用 Helm 或 Kustomize 来执行此操作。如果要使用单个命令构建和部署，你可以选择 **skaffold run**。

## Skaffold 有什么新变化？

2020 年，Skaffold 团队致力于让项目更容易适配各种工作流程，并与其他工具更具互操作性。其中一些改进包括更灵活地集成 CI/CD 和 GitOps ，以及更好地支持 Python 和 Java 。

此外，Skaffold 现在有了一个新的测试版操作模式 - [skaffold debug](https://skaffold.dev/docs/workflows/debug/)。在该模式下，Skaffold 会尝试自动为远程调试配置好服务运行时。虽然这是一个很好的特性，但在微服务环境中使用传统调试器充其量也是棘手的，特别是在使用远程集群时。如果你在这方面有问题，我们强烈建议你查看 Rookout 的[非中断](https://www.rookout.com/blog/making-rookouts-breakpoints-even-more-non-breaking) 调试器。

## 总结

当涉及到打包，部署和共享令人烦恼的 Kubernetes 服务清单时，我们已经看到了显著的市场集成。CNCF（云原生共享基金会）现在是主要工具的发源地，其中 Helm 是一个官方的 CNCF 项目，Kustomize 集成到 kubectl 和许多其他工具中。与 Kubernetes 生态系统的许多其他部分一样，这里的工具已经非常成熟，每个工具都有明确的用途。

我们可以使用 Helm 来打包、共享和安装定义好的 Kubernetes 服务；使用 Kustomize 通过补丁的方式来修改现有的 Kubernetes 服务。至于 Skaffold？它是一个有用的工具（而且它还很流行！），但是配置 Kubernetes 服务并不是它的主要目的。

我希望你会觉得这篇简短的指南很有用 —— 请不要犹豫，与我分享你的反馈，并让我知道你想要我涵盖的任何其他主题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
