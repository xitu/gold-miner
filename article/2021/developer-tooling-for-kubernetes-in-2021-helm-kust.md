> * 原文地址：[Developer Tooling for Kubernetes in 2021: Helm, Kustomize, and Skaffold](https://dzone.com/articles/developer-tooling-for-kubernetes-in-2021-helm-kust)
> * 原文作者：Liran Haimovitch
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/developer-tooling-for-kubernetes-in-2021-helm-kust.md](https://github.com/xitu/gold-miner/blob/master/article/2021/developer-tooling-for-kubernetes-in-2021-helm-kust.md)
> * 译者：
> * 校对者：

# Developer Tooling for Kubernetes in 2021: Helm, Kustomize, and Skaffold

Over the last few years, we have seen an avalanche of tools to enable easier software development on Kubernetes (let’s face it, it is quite hard out of the box). As often happens in growing ecosystems, some tools grow and adapt, while others get left behind, or, at the very least, are merged into new offerings. What’s a better way to open 2021 than with an up-to-date review of the options we have?

In this blog series, I’ll go over the various developer tools for Kubernetes out there, their function within the development workflow, and, mostly, cover important news for each of them. For this post, I’ll focus on tools used to define our Kubernetes applications, namely: [Helm](https://helm.sh/docs/helm/helm_lint/), [Kustomize](https://kustomize.io/), and [Skaffold](https://skaffold.dev/).

## Kubernetes Manifests (YAMLs)

If you are new to Kubernetes, I recommend this [introduction](https://www.jeremyjordan.me/kubernetes/), which I found quite in-depth. For our purposes, the most important thing for you to know is that Kubernetes has a [Declarative](https://www.leverege.com/iot-ebook/kubernetes-object-management-model) approach for orchestrating applications. You write your application’s desired state in a configuration file(s), known as a “manifest,” in a YAML format, and send it over to Kubernetes to make it happen.

## Helm

[Helm](https://helm.sh/) is the reigning king, the de-facto standard for packaging, sharing, and deploying k8s applications. Think of Helm as a package manager – it allows you to group multiple YAML configuration snippets into a logical package known as a “chart” in a consistent and structured way.

As a package author, [creating](https://opensource.com/article/20/5/helm-charts) a Helm chart provides you with significant benefits:

1. You can make your application configurable at deploy time using custom arguments. To do so, you use [templates](https://helm.sh/docs/chart_template_guide/).
2. You can publish your application into a private or public repository in a versioned and trackable way.
3. You can make your application dependent on other Helm charts.
4. Overall, Helm provides you with strong encapsulation mechanics to ensure your application deploys as intended.

As a package user, [installing](https://helm.sh/docs/helm/helm_install/) a Helm chart provides you even more:

1. You gain access to an extensive repository of publicly available charts and any private charts made available by your organization.
2. You can customize applications based on the settings provided by the package author.
3. You have a versioned source of truth from where to deploy packages.
4. You don’t have to worry about the intricacies of the Kubernetes specification language.
5. Helm supports Atomic operations to minimize risks to your applications and clusters.
6. Overall, you get an easy to [understand](https://www.rookout.com/blog/using-helm-to-improve-software-understandability) and ready to use application package.

## What’s New With Helm?

In late 2019 we saw the release of Helm v3, with the removal of the cluster-side component (Tiller) and a slew of other features. At the end of 2020, Helm v2 was deprecated and most public charts have been migrated to the v3 format. If you are still using Helm v2, make sure to allocate time to upgrade your near-term roadmap (while you are at it, check out this [plugin](https://github.com/helm/helm-2to3) that may help).

Over the last few releases, the Helm team has been busy addressing one of the biggest complaints by Helm users – the difficulty of working with YAML templates. Helm now includes a powerful linting [command](https://helm.sh/docs/helm/helm_lint/) that should be your new go-to when debugging issues with those pesky YAMLs.

Another neat feature added to Helm is the [post-render](https://helm.sh/docs/topics/advanced/) feature, allowing you to customize Helm charts with tools such as Kustomize.

Last but not least, 2020 also saw the move to a more decentralized way of managing charts and the launch of two central repositories for sharing them:

1. [ArtifactHub](https://artifacthub.io/) by CNCF.
2. [ChartCenter](https://chartcenter.io/) by JFrog (check out this [webinar](https://lp.rookout.com/webinar-modernized-developer-workflow) by Josh, a member of the Rookout team, to learn more about it).

## Kustomize

Helm’s biggest drawback is that the customization of applications is limited to pre-existing configuration options. Not only that, the chart author has to implement those customization options in the somewhat cumbersome manner of templating. Well, that’s where [Kustomize](https://kustomize.io/) comes in.

Kustomize allows you to build a Kubernetes application as a series of layers and patches, empowering limitless customizations. Kustomize uses a YAML-based Kubernetes-aware patch format to add/remove/update any part of the application manifest. Kustomize became an integral part of [kubectl](https://dockerlabs.collabnix.com/kubernetes/beginners/what-is-kubect.html) on [version 1.14](https://kubernetes.io/blog/2019/03/25/kubernetes-1-14-release-announcement/), and all you have to do to invoke it is to execute `kubectl -k`. The docs are a bit sparse but check out the official [examples page](https://github.com/kubernetes-sigs/kustomize/tree/master/examples) and this [blog post](https://www.digitalocean.com/community/tutorials/how-to-manage-your-kubernetes-configurations-with-kustomize) to get some sense of things.

Kustomize is a powerful tool that empowers you to modify Kubernetes applications in any way you want. Unfortunately, this means the learning curve can be quite steep. Arbitrary customization also means the potential for misconfiguring an app increases. One of Kustomize’s advanced use-cases uses Helm’s post-render feature to [patch](https://github.com/thomastaylor312/advanced-helm-demos/tree/master/post-render) an existing Helm chart without requiring forking, hopefully making version upgrades seamless.

## What’s new with Kustomize?

Many tools within the Kubernetes ecosystem have embedded Kustomize to add its functionality to theirs. The most prominent examples are orchestration and continuous deployment tools such as  [ArgoCD](https://argoproj.github.io/argo-cd/), [Flux](https://fluxcd.io/), and [Kubestack](https://www.kubestack.com/). If you search for Kustomize-like patch functionality, check out your CD tool, and you just may find it there.

If, like me, you are not familiar with the Kubernetes build process, you might not know that the maintainers had frozen the Kustomize version [embedded in kubectl](https://github.com/kubernetes/kubectl/issues/818) at 2.0.3 during the initial integration. Besides making the docs even more confusing, this means the version inside kubectl is missing a slew of enhancements that made their way in over the last two years. The team is making significant progress on reintegration, and hopefully they will resolve it soon. In the meantime, consider using Kustomize as a [standalone](https://kubectl.docs.kubernetes.io/installation/kustomize/) CLI tool if you need the latest version.

## Skaffold

[Skaffold](https://skaffold.dev/) takes a bit of a different approach, following the DevOps best practice of keeping the development environments and workflows consistent across the SDLC. Skaffold builds and deploys Kubernetes applications for dev workflows and continuous integration (CI) and continuous deployment (CD).

For the building, Skaffold can utilize Dockerfiles, [Buildpacks](https://buildpacks.io/), Bazel, and even custom scripts (more on building container images in an upcoming blog post!). For deploying, Skaffold contains its limited templating engine and can invoke kubectl, Helm, or Kustomize.

Skaffold has three main modes of operation:

1. **skaffold dev** - this will run Skaffold in a watch, build, deploy loop. In this mode, you can edit your source files locally, and Skaffold will deploy them to a cluster of your choice. Skaffold supports port forwarding and log tailing to enable a smoother development experience when working in this mode.
2. **skaffold build** - this will run Skaffold to build your artifacts once and push them to a repository of your choice.
3. **skaffold deploy** - this will deploy your built application into a cluster of your choice, potentially utilizing Helm or Kustomize to do so. If you want to build and deploy using a single command, you can use **skaffold run**.

## What’s New With Skaffold?

In 2020, the Skaffold team focused on making the project easier to adapt to various workflows and more interoperable with other tools. Some of the improvements included more flexible integrations with CI/CD and GitOps and better support for Python and Java.

Additionally, Skaffold now has a new operating model in beta - [skaffold debug](https://skaffold.dev/docs/workflows/debug/). In this mode, Skaffold attempts to configure the application runtime for remote debugging automatically. While this is a neat feature, using traditional debuggers in a microservices environment is tricky at best, especially when working with remote clusters. If you are having trouble with that, we highly recommend you check out [non-breaking](https://www.rookout.com/blog/making-rookouts-breakpoints-even-more-non-breaking) debuggers such as Rookout.

## Summary

When it comes to packaging, deploying, and sharing the notorious Kubernetes application manifests, we have seen significant market consolidation. The CNCF is now the home of the leading tools with Helm, an official CNCF project, and Kustomize integrated into kubectl and many other tools. Like in many other parts of the Kubernetes ecosystem, the tools here have significantly matured, and each has a clear purpose.

Use Helm to package, share, and install well-defined Kubernetes applications. Use Kustomize to modify existing Kubernetes applications using patches. Skaffold is a useful tool (and popular!), but configuring Kubernetes applications is not its primary purpose.

I hope you found this short guide useful – please don’t hesitate to reach out to share your feedback and let me know of any other topics you would like me to cover.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。