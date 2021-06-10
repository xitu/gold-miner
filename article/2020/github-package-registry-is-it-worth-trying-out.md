> * 原文地址：[GitHub Package Registry: Is it Worth Trying Out?](https://blog.bitsrc.io/github-package-registry-is-it-worth-trying-out-62163aa3d518)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/github-package-registry-is-it-worth-trying-out.md](https://github.com/xitu/gold-miner/blob/master/article/2020/github-package-registry-is-it-worth-trying-out.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)

# GitHub Package Registry 值得尝试吗

![Photo by [Nana Smirnova](https://unsplash.com/@nananadolgo?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10392/0*5jrNYn-hF3R_LkQi)

GitHub Package Registry 是由微软于 2019 年年中开发并推出的。随着完成对 GitHub 和 NPM 的收购，这一功能似乎是微软扩展 GitHub 生态系统的绝佳举措。同时，GitHub 使用以下标语来强调这一事实：

> GitHub Package Registry 能够更好地管理代码。 — GitHub

但是仅凭这一点就值得去尝试吗？我们首先考虑是否真的需要另一个包管理器吗？

让我们来了解更多内容。

## 是否值得尝试

如果你是 GitHub 的 4000 万用户中的一员，只需点击你的 `GitHub profile` 或 `GitHub Organization` 下的一个标签就可以访问 GitHub Package Registry。

![Screenshot of GitHub Package Registry under my profile](https://cdn-images-1.medium.com/max/2538/1*PowgC6YYeQ7J7oN1edD9Vw.png)

> 当我第一次尝试使用 GitHub Package Registry 时，我发现它直观且容易上手。我是从免费版开始，这对于一个几乎没有私有软件包的小型项目来说似乎已经足够使用。

然而，你可能想知道 GitHub 包管理器是否会作为一个核心特性脱颖而出？到目前为止，GitHub 已经巧妙地将它放在其核心产品组合中。此外，GitHub 已经实现了一套具有较高影响力的功能体系让我们尝试使用。

让我们来看一下它的一些特性，这些特性将它推向了一个新的高度。

### 1. 支持 5 种语言和客户端

与专注于 NodeJS 包的 NPM 不同，GitHub 包注册中心支持一系列包类型和客户端，如下所示：

![Support for package registries, Source: [GitHub](http://Support for package registries)](https://cdn-images-1.medium.com/max/3056/1*CNuP0W1N0Uebuajvx46A1w.png)

在即将到来的版本更新中，我们可以期待它会支持更多的开发工具和客户端。

> [对 Swift 的支持](https://github.blog/2019-06-03-github-package-registry-will-support-swift-packages/)已经处于测试阶段，我们能预期它会在几个月后上线。

由于 GitHub Package Registry 支持多种包格式，从而为托管不同的软件包带来了方便，在有不同技术栈的微服务项目中也能很好地使用。

### 2. 集成工作流与 GitHub Actions

结合 GitHub API、GitHub Actions 和 WebHooks，可以开发实现端到端 DevOps 工作流集成，包括 CI/CD 管道。你还可以使用 GraphQL 和 WebHooks 自定义发布前和发布后的工作流。

![GitHub Package Management Tasks in GitHub Actions Marketplace](https://cdn-images-1.medium.com/max/2000/1*PECyA1fWltGS1dZo9g7f-w.png)

> 你已经可以在 GitHub Actions 中找到预先构建的任务，以简化 GitHub Package Management 流程。

简而言之，通过与 GitHub Actions 本地集成，你可以在一个地方自动化整个包生命周期及操作。

### 3. 用户和工具的访问控制

这允许在一个位置管理代码仓库和包。它还简化了 CI/CD 管道的访问控制。此外，GitHub 认证可以用来访问源代码和私有包。

> 因为 GitHub 包继承了与代码仓库相关联的权限，你不需要维护单独的包注册表权限。

你还可以根据需求选择将包托管为公共或私有。

### 4. 在一个地方监管项目代码和包

与其他包管理器类似，Github Package Registry 允许在下载之前查看包内容、下载统计数据和历史版本，以便在下载前有更好地了解。

> 因为我们可以通过查看 GitHub 项目的 stars 和 forks 来了解它的活跃度，所以有助于找到合适的包以便我们在代码中使用。

即使有了 NPM 包，我还是习惯去 GitHub 看项目的 star 数量、贡献者数量，并查看最近提交的日期记录，现在你可以在一个地方找到这些内容。

## 已在其他地方托管包的情况处理

好消息是你不必这样担心，特别是对于公共软件包。假设你的私有软件包依赖于任何其他公共软件包注册中心，例如 NPM。一旦将根软件包移至 GitHub Package Registry，这些依赖关系仍将完好保持运行。实际上，将 NPM 软件包移至 GitHub Package Registry 后，只需更改注册表 URL 地址和访问控制机制。

让我们来看一个简单的示例，以便了解如何使用 GitHub Package Registry 发布 NPM 软件包并逐步使用它。

### Step 1：验证 GitHub Package Registry

首先，你需要有一个 GitHub 访问令牌才能向 GitHub 注册表验证你的身份。你既可以使用现有的令牌，也可以使用 [https://github.com/settings/tokens/new](https://github.com/settings/tokens/new) 创建一个令牌。在这里，我将令牌命名为 **githubReg**。

![Screenshot by Author: Creating a new access token](https://cdn-images-1.medium.com/max/4046/1*mBJOGUKYRHObEQvd4c4iZA.png)

你需要设置 .npmrc 文件，该文件是有关 NPM 客户端如何与 NPM 注册表本身进行通信的配置。打开终端并运行 `code .npmr`。它将打开一个空白文件，并用你的 access_token 替换以下对应内容。

```
//npm.pkg.github.com/:_authToken=TOKEN
```

然后初始化一个新的 NPM 项目，打开 VSCode 并运行 `npm init` 命令。

### Step 2：进行打包发布

在项目的根目录中创建一个本地 .nmprc 文件，并添加以下内容。在这里，将 OWNER 替换为你的用户名或组织名。

```
@OWNER:registry=https://npm.pkg.github.com/
```

创建 JavaScript 主程序文件并编写一个简单函数。在这里，我在根目录中创建了一个名为 index.js 的文件来测试该软件包。

```
module.export = () => {
   console.log("hello new one");
}
```

接着，你需要验证软件包的名称，并将项目仓库添加到项目 package.json 文件中，然后将所有更改推送到 git。

**注意：** 这里你需要创建自己的项目仓库，并将其细节添加到下面的文件中。

```json
{
   "name": "@ChameeraD/pkg-git-demo",
   "version": "1.0.0",
   "description": "",
   "main": "index.js",
   "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1"
   },
   "repository": {
      "url": "git://github.com/ChameeraD/pkg-git-demo.git."
   },
   "publishConfig": {
      "registry":"https://npm.pkg.github.com/"
   },   
   "author": "",
   "license": "ISC"
}
```

最后，使用 `npm publish` 发布包。

> **注意：** 可以创建使用其他 npm 包依赖的 GitHub 软件包。 [eDEX-UI](https://github.com/GitSquared/edex-ui) 是一个跨平台的终端仿真器和系统监视器，外观和给人感觉就像是科幻计算机界面，它是一个托管在 GitHub 注册表中的软件包。但是，如果深入研究软件包的实现，会发现它们使用 npm 依赖，像 **`electron`、`electron-rebuild`、`node-abi` 和 `node-json-minify`**。

### Step 03：将包作为依赖项使用

你可以将包添加到任何项目中。

1. 在项目根目录创建一个本地 .npmrc 文件，并添加 `@OWNER:registry=https://npm.pkg.github.com/`，这与我们在创建软件包时的操作类似。
2. 使用 Yarn 或 NPM 将包添加到项目中。例如使用 Yarn：`yarn add @ChameeraD/pkg-git-demo`。
3. 最后，可以将包导入到代码中并使用：
`import demoPkg from ‘@ChameeraD/pkg-git-demo’;`
`demoPkg();`

![Screenshot by Author: Output log by of the package](https://cdn-images-1.medium.com/max/2196/1*_xmY-6FUmxr8zJG6Znlh0w.png)

尽管 GitHub 包管理器具有很多功能特性，但它也有局限性。

## GitHub 包管理器局限性

为了保持内容简短集中，我将只列举那些影响大多数开发人员的内容。

### 仅支持特定范围的 NPM 包

将非作用域的软件包从 npm 迁移到 GitHub package registry 可能会很麻烦，因为 GitHub 仅支持 npm 作用域软件包（例如 `npm install @source/my-package`）。

如果你想移动任何没有作用域的现存软件包，则需要添加作用域并修改代码的导入才能正常使用。

### 软件包迁移较困难

由于不同技术（[Docker](https://docs.github.com/en/free-pro-team@latest/packages/using-github-packages-with-your-projects-ecosystem/configuring-docker-for-use-with-github-packages)、[.NET](https://docs.github.com/en/free-pro-team@latest/packages/using-github-packages-with-your-projects-ecosystem/configuring-docker-for-use-with-github-packages)）之间存在差异，从多个软件包注册中心进行迁移可能很困难。

如果你已经使用了任何其他包注册表，可能会由于包更新而出现版本问题。例如，如果你在 npm 和 GitHub 注册表中都维护一个包，那么你也需要维护它的版本。因此，最好在知道依赖关系的情况下规划迁移，并使用单个包注册表。

### 较差的自定义性

它的自定义性较差，用户无法使用自定义身份验证机制，不能使用自托管注册表。缺少这些功能将限制开发人员离线和在较差网络条件下工作。

## 结论

将软件包发布到 GitHub Package Registry 是一种全新的体验，它具有将源代码和软件包保存在一个地方的简单性。

当前重点是支持多种类型的软件包（已经支持多种类型），而且 GitHub Package Registry 逐渐完善对所有软件包类型的支持。此外，如果你已经将 GitHub 作为项目仓库，那么使用 GitHub Package Registry 就更方便。

感谢你的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
