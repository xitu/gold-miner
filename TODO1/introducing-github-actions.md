> * 原文地址：[Introducing GitHub Actions](https://css-tricks.com/introducing-github-actions/)
> * 原文作者：[SARAH DRASNER](https://css-tricks.com/author/sdrasner/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-github-actions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-github-actions.md)
> * 译者：[子非](https://www.github.com/CoolRice)
> * 校对者：

# GitHub Actions 介绍，了解一下？

有一种常见的情况：你创建了一个网站并且已经准备运行了。这一切都在 GitHub 上。但是你还没**真正完成**。你需要准备部署。你需要准备一个处理程序来为你运行测试，你不用总是手动运行命令。理想情况下，每一次你推送到 master 分支，所有东西都会在某个地方为你自动运行：测试，部署……

以前，只有很少的选项可以帮助解决这个问题。你可能需要把其他服务集中，设置，并和 GitHub 整合。你也可以写 post-commit hooks，这也会有帮助。

但是现在，**[GitHub Actions](https://github.com/features/actions) 已经到来**。

![](https://css-tricks.com/wp-content/uploads/2018/10/github-actions.png)

Actions 是一小段代码片段，可以运行很多 GitHub 事件，最普遍的是推送到 master 分支。但它并非仅限于此。它们都已经直接和 GitHub 整合，这意味着你不在需要中间服务或者需要你自己来写方案。并且它们已经有很多选项可供你选择。例如，你可以发布到 NPM 并且部署到各种云服务，举一些例子（Azure，AWS，Google Cloud，Zeit……凡是你说得出的）。

**但是 actions 不止部署和发布。** 这就是它们酷炫的地方。它们都是容器，毫不夸张地说你可以做**任何事情** —— 有着无尽的可能性！你可以用它们压缩合并 CSS 和 JavaScript，在人们在你的项目仓库里在你的仓库创建 issue 的时候向你发送信息，以及更多……没有任何限制。

你也可以不需要自己来配置或创建容器。Actions 允许你指向别的项目仓库，一个已存在的 Dockerfile，或者路径，操作将相应地运行。对于开源可能性和生态系统而言，这是一种全新的蠕虫病毒。

### 建立你的第一个 action

有两种方法建立 action：通过流程 GUI 或者手动写提交文件。我们将以 GUI 开始，因为它简单易懂，然后学习手写方式，因为它能提供最大化的控制。

首先，我们通过[此处蓝色的大按钮](https://github.com/features/actions?WT.mc_id=actions-csstricks-sdras)登录 beta 版。进入 beta 版可能会花费一点点时间，稍等一下。

![GitHub Actions beta 版站点的截图，其中有一个巨大的蓝色按钮来点击加入 beta 测试。](https://css-tricks.com/wp-content/uploads/2018/10/github-actions-beta.png)

GitHub Actions beta 版站点。

现在我们来创建一个仓库。我使用一个小的 Node.js 演示站点建了一个[小型演示仓库](https://github.com/actions/azure?WT.mc_id=actions-csstricks-sdras)。我可以发现在我的仓库上已经有一个新选项卡，叫做 Actions：

![在演示仓库的截图中显示菜单中的 Actions 选项卡](https://css-tricks.com/wp-content/uploads/2018/10/action1.jpg)

如果我点击 Actions 选项卡，屏幕会显示：

![屏幕显示](https://css-tricks.com/wp-content/uploads/2018/10/Screen-Shot-2018-10-16-at-4.21.15-PM.png)

我点击“Create a New Workflow”，然后我能看到下面的界面。这告诉我一些东西。首先，我创建了一个叫 `.github` 的隐藏文件夹，在它里面，我创建了一个叫 `main.workflow` 的隐藏文件。如果你要从 scratch（我们将详细讲解）创建工作流，你需要执行相同的操作。

![新工作流](https://css-tricks.com/wp-content/uploads/2018/10/connect0.jpg)

现在，我们能看到在这个 GUI 中我们启动了一个新的工作流。如果从我们的第一个 action 画一条线，会出现一个拥有大量选项的边侧栏。

![显示边侧栏中所有 action 选项](https://css-tricks.com/wp-content/uploads/2018/10/action-options.jpg)

这里有很多关于 npm、Filters、Google Cloud、Azure、Zeit、AWS、Docker Tags、Docker Registry 和 Heroku 的 action。如前所述，你没有任何关于这些选项的限制 —— 它能够做的非常多！

我在 Azure 工作，所以我将以此为例，但是每一个 action 都提供给你相同选项，我们可以一起使用。

![在边侧栏显示 Azure 选项](https://css-tricks.com/wp-content/uploads/2018/10/options-azure.jpg)

在顶部，你可以看到“GitHub Action for Azure”标题，其中包含“View source”链接。这将直接带你到用于运行此操作的[仓库](https://github.com/actions/azure?WT.mc_id=actions-csstricks-sdras)。这非常好，因为你还可以提交拉取请求以改进其中任何一项，并且可以根据 Actions 面板中的“uses”选项灵活地更改你正在使用的 action。

以下是我们提供的选项的简要说明：

*   **Label**：这是 Action 的名称，正如你所假设的那样。此名称由 resolves 数组中的工作流引用 —— 这就是在它们之间创建连接的原因。这篇文章是在 GUI 中为你抽象出来的，但你会在下一节中看到，如果你在代码中工作，你需要保持引用相同才能进行链接工作。
*   **Runs**：允许你覆盖入口点。这很好，因为如果你想 git 在容器中运行，可以做到！
*   **Args**：这是你所期望的 —— 它允许你将参数传递给容器。
*   **secrets**和**env**：这些都是非常重要的，因为这是你将如何使用密码，保护数据，而无需直接提交他们到仓库。如果你正在使用需要令牌来部署的东西，你可能会在这里使用 secret 来传递它。

[其中许多操作都有自述文件](https://github.com/actions/?WT.mc_id=actions-csstricks-sdras)，可以告诉您需要什么。“secrets”和“env”的设置通常如下所示：

```
action "deploy" {
  uses = ...
  secrets = [
    "THIS_IS_WHAT_YOU_NEED_TO_NAME_THE_SECRET",
  ]
}
```

您还可以在 GUI 中将多个 action 串联起来。很容易让 action 顺序执行或并行执行。这意味着只需在界面中将东西链接在一起就可以很好地运行异步代码。

### 用代码写 action

如果这里显示的并没有我们需要的怎么办？幸运的是写 action 其实非常有趣！我写过一个 action 来部署 Node.js 的 Web 应用到 Azure，因为它允许我在每次推送到仓库的主分支时随时部署。这个超级有趣，因为我现在可以复用它到我的其它 Web 应用。

#### 创建应用服务账户

如果你要使用其它服务，这部分会发生变化，但是你需要在你要在你使用的地方创建一个已存在的服务来部署。

首先你需要获取你的[免费 Azure 账户](https://azure.microsoft.com/en-us/free/?WT.mc_id=actions-csstricks-sdras)。我喜欢用 [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest&WT.mc_id=actions-csstricks-sdras)，如果你没有安装过，你可以运行：

```
brew update && brew install azure-cli
```

然后，我们运行下面代码来登录：

```
az login
```

现在，我们会创建 [Service Principle](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest&WT.mc_id=actions-csstricks-sdras)，通过运行：

```
az ad sp create-for-rbac --name ServicePrincipalName --password PASSWORD
```

它会输出如下内容，会在创建我们的 action 时用到：

```
{
  "appId": "APP_ID",
  "displayName": "ServicePrincipalName",
  "name": "http://ServicePrincipalName",
  "password": ...,
  "tenant": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
}
```

#### action 里面有什么？

这里有一个基本的流程示例和一个 action，你可以看到它的架构：

```
workflow "Name of Workflow" {
  on = "push"
  resolves = ["deploy"]
}

action "deploy" {
  uses = "actions/someaction"
  secrets = [
    "TOKEN",
  ]
}
```

可以看到我们启动了流程，并明确我们想它在 **on push**(`on = "push"`)运行。还有很多其它你可以用的选项，[这里是完整的清单列表](https://developer.github.com/actions/creating-workflows/workflow-configuration-options/?WT.mc_id=actions-csstricks-sdras#events-supported-in-workflow-files)。

下方的**resolves**行 `resolves = ["deploy"]` 是一个 action 数组，它会串联随后的工作流。不用指定顺序，只是一个完全列表。你可以看到我们调用 “deploy” 后面的 action —— 只需要匹配这些字符串，这就是它们之间如何引用的。

下面，我们看一看 **action** 部分。第一行 **uses** 十分有趣：立刻你可以使用我们之前讨论的任何预定义 action([这是完全清单](https://github.com/actions/?WT.mc_id=actions-csstricks-sdras))。但你也可以使用其它人的仓库，甚至是托管在 Docker 站点的文件。例如，如果我们想在容器中执行 git，[让我们使用这个](https://hub.docker.com/r/alpine/git/~/dockerfile/)。我可以这样做 `uses = "docker://alpine/git:latest"`。（感谢 [Matt Colyer](https://twitter.com/mcolyer) 为我指出 URL 的正确方法）

我们可能需要在这里定义一些机密的配置或环境变量，并且这样使用它们：

```
action "Deploy Webapp" {
  uses = ...
  args = "run some code here and use a $ENV_VARIABLE_NAME"
  secrets = ["SECRET_NAME"]
  env = {
    ENV_VARIABLE_NAME = "myEnvVariable"
  }
}
```

### 创建一个自定义 action

自定义 action 会采用我们[运行部署 Web App 到 Azure](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-get-started-nodejs?WT.mc_id=actions-csstricks-sdras) 经常用的命令，并把它们写成以只传几个值的方式，这样 action 就会为我们全部执行。文件看起来要比你在 GUI 上创建的 [第一个基础 Azure action](https://github.com/actions/azure?WT.mc_id=actions-csstricks-sdras) 更复杂并且是建立在它之上的。

在 entrypoint.sh：

```
#!/bin/sh

set -e

echo "Login"
az login --service-principal --username "${SERVICE_PRINCIPAL}" --password "${SERVICE_PASS}" --tenant "${TENANT_ID}"

echo "Creating resource group ${APPID}-group"
az group create -n ${APPID}-group -l westcentralus

echo "Creating app service plan ${APPID}-plan"
az appservice plan create -g ${APPID}-group -n ${APPID}-plan --sku FREE

echo "Creating webapp ${APPID}"
az webapp create -g ${APPID}-group -p ${APPID}-plan -n ${APPID} --deployment-local-git

echo "Getting username/password for deployment"
DEPLOYUSER=`az webapp deployment list-publishing-profiles -n ${APPID} -g ${APPID}-group --query '[0].userName' -o tsv`
DEPLOYPASS=`az webapp deployment list-publishing-profiles -n ${APPID} -g ${APPID}-group --query '[0].userPWD' -o tsv`

git remote add azure https://${DEPLOYUSER}:${DEPLOYPASS}@${APPID}.scm.azurewebsites.net/${APPID}.git

git push azure master
```

这个文件有几点有趣的东西要注意：

*   shell 脚本中的 `set -e` 确保如果有任何事情发生异常，文件其余部分则不会运行。
*   随后的“Getting username/password”行看起来有点棘手 —— 实际上他们做的是从 [Azure 的发布文档 ](https://docs.microsoft.com/en-us/cli/azure/webapp/deployment?view=azure-cli-latest&WT.mc_id=actions-csstricks-sdras#az-webapp-deployment-list-publishing-profiles)中抽取用户名和密码。我们可以在随后要使用 remote add 的行中使用它。
*   你也许会注意到有些行我们传入了 `-o tsv`，这是[格式化代码](https://docs.microsoft.com/en-us/cli/azure/format-output-azure-cli?view=azure-cli-latest&WT.mc_id=actions-csstricks-sdras)，所以我们可以把它直接传进环境变量，如 tsv 脚本剔除多余的头部信息等等。

现在我们开始着手 `main.workflow` 文件！

```
workflow "New workflow" {
  on = "push"
  resolves = ["Deploy to Azure"]
}

action "Deploy to Azure" {
  uses = "./.github/azdeploy"
  secrets = ["SERVICE_PASS"]
  env = {
    SERVICE_PRINCIPAL="http://sdrasApp",
    TENANT_ID="72f988bf-86f1-41af-91ab-2d7cd011db47",
    APPID="sdrasMoonshine"
  }
}
```

这段流程代码对你来说应该很熟悉 —— 它在 on push 时启动并且执行叫“Deploy to Azure”的 action。

[`uses` 指向内部的目录](https://developer.github.com/actions/creating-workflows/workflow-configuration-options/#using-a-dockerfile-image-in-an-action)，在这个目录我们存放其他文件。我们需要添加一个秘钥，来让我们在 App 里存放密码。我们把这个叫服务密码，并且我们会在设置里添加配置它：

![在设置中添加秘钥](https://css-tricks.com/wp-content/uploads/2018/10/Screen-Shot-2018-10-16-at-10.20.35-PM.png)

最终，我们有了需要运行命令的所有环境变量。我们可以从之前[创建 App 服务账户](#article-header-id-2)获得它们。先前的 `tenant` 变成了 `TENANT_ID`，`name` 变成了 `SERVICE_PRINCIPAL`，并且 `APPID` 由你来命名:)

现在你也可以使用这个 action 工具！所有的代码在[这个仓库中开源](https://github.com/sdras/example-azure-node/)。只要记住由于我们手动创建 `main.workflow`，你将必须同时手动编辑 main.workflow 文件里的环境变量 —— 一旦你停止使用 GUI，它的工作方式将和之前不再一样。

这里你可以看到项目部署的非常好并且状态良好，每当推送到 master 时我们的 “Hello World” App 都可以重新部署啦 🎉

![工作流运行成功](https://css-tricks.com/wp-content/uploads/2018/10/Screen-Shot-2018-10-16-at-10.55.35-PM.png)

![Hello Word App 的截图](https://css-tricks.com/wp-content/uploads/2018/10/Screen-Shot-2018-10-16-at-10.56.03-PM.png)

### 改变游戏规则

GitHub Actions 并不仅仅只是关于网站，尽管你可以看到它们对它们有多么方便。这是一种全新的思考方式，关于我们怎样处理基础设施，事件甚至托管的方式。在这个模型中需要考虑 Docker。

通常，当你创建 Dockerfile 时，你必须编写 Dockerfile，使用 Docker 创建镜像，然后将映像推送到某处，以便托管供其他人下载。在这个范例中，你可以将它指向一个包含现有 Docker 文件的 git 仓库，或者直接托管在 Docker 上的东西。

你也不需要在任何地方托管镜像，因为 GitHub 会为你即时构建。这使得 GitHub 生态系统中的所有内容都保持开放，这对于开源来说是巨大的，并且可以更容易地 fork 和共享。你还可以将 Dockerfile 直接放在你的操作中，这意味着你不必为这些 Dockerfiles 维护单独的仓库。

总而言之，这非常令人兴奋。部分原因在于灵活性：一方面，你可以选择使用大量抽象并使用 GUI 和现有操作创建所需的工作流，另一方面，你可以在容器内自己编写代码，构建和微调任何想要的内容，甚至将多个可重用的自定义 action 链接在一起。全部在一个地方托管你的代码。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
