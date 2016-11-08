> * 原文地址：[5 things you can do with Yarn](https://auth0.com/blog/five-things-you-can-do-with-yarn/)
* 原文作者：[Prosper Otemuyiwa](https://twitter.com/unicodeveloper?lang=en)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[jiakeqi](http://jiakeqi.cn)
* 校对者：[bobmayuze](https://github.com/bobmayuze) [luoyaqifei](https://github.com/luoyaqifei)

# 用 Yarn 你还能做这 5 件事 

在 JavaScript 领域中有几个包管理器: **npm**，**bower**，**component**，和 **volo**，举个🌰。到本文为止，最受欢迎的包管理器是 **npm**。npm 客户端提供了对 npm 注册库中成千上万代码的访问。不久之前，Facebook 推出了一款名叫 **Yarn** 的包管理器，声称比现有的 npm 客户端更快，更可靠，更安全。在本文中，你将学会可以用 Yarn 做的五件事情。

**Yarn** 是 一个由 Facebook 创建的新 JavaScript 包管理器。为开发者使用 JavaScript 开发 app 时提供了快速，高可用，并且安全的依赖管理。下面有可以用 Yarn 做的五件事情哦~

## 1. 离线工作

Yarn 为你提供在离线模式下工作的能力。如果你在之前安装过一个包，你可以不依赖网络连接再次安装。下面是一个示例:

当连接到网络时，我用Yarn 安装了两个包，如下:

![Yarn init](https://cdn.auth0.com/blog/blog/yarn-int.png) <b>使用 yarn init 创建一个 package.json</b>

![用 yarn 安装 express 和 jsonwebtoken 包](https://cdn.auth0.com/blog/blog/yarn-add-packages.png) <b>用 yarn 安装 express 和 jsonwebtoken 包</b>

![安装完毕](https://cdn.auth0.com/blog/blog/yarn-completed-install.png) <b>安装完毕</b>

安装完毕后。我会删除 <b>orijin</b> 目录下的 <b>node_modules</b> ，并断开网络连接，重新执行 Yarn。如下:

![Yarn 离线安装了包](https://cdn.auth0.com/blog/blog/yarn-install-offline.png) <b>Yarn 离线安装了包</b>

这就是 Yarn! 所有包都在不到两秒钟内重新安装。显然，Yarn 缓存了下载的每个包，所以不需要重复下载。它还通过并行化操作来最大化资源利用率，使安装时间比之前更快。

## 2. 从多个注册表安装

Yarn 为你提供了从多个注册表安装 JavaScript 包的能力，如 [npm](https://www.npmjs.com/)，[bower](https://bower.io/)，你的 git 仓库，还有你的本地文件系统。

默认情况下，它将为你的安装包扫描 npm 注册表，如下:

    yarn add <pkg-name>

从远程 gzip 压缩文件安装包，如下:

    yarn add <https://thatproject.code/package.tgz>

从你的本地文件系统安装包，如下:

    yarn add file:/path/to/local/folder

这对于不断发布 JavaScript 包的者格外有用。你可以利用这个特性，在发布到注册表之前测试这个包.

从远程 git 仓库安装包，如下:

    yarn add <git remote-url>

![从一个 Github 仓库 安装 Yarn](https://cdn.auth0.com/blog/blog/yarn-add-gitrepo.png) <b>从一个 Github 仓库 安装 Yarn</b>

![Yarn 检测 git 仓库作为软件包存在于 bower 注册表中](https://cdn.auth0.com/blog/blog/yarn-add-bowercomp.png) <b>Yarn 还自动检测到 git 仓库作为软件包存在于 bower 注册表中，并将其视为包</b>

## 3. 快速获取安装包

如果你使用 **npm** 有段时间了，肯定有这样的经历，当你去运行 `npm install` 时，然后去看电影，回来后检查你需要的所有包是否安装完毕。好吧，可能不是很久，但是它花了大量时间来遍历依赖关系树并拉入依赖关系。使用 Yarn，从以前的等待几分钟到在几秒钟内安装包，安装时间确实减少了。

Yarn 有效地对请求进行排队，并避免请求集中以最大化网络利用率。开始创建一个请求到注册表，并递归查找每个依赖，接下来，在全局缓存目录查看是否下载过这些包。如果没有，Yarn 会获取原始包，并将其放入全局缓存，以保证可以离线工作和无需重复安装。

在安装过程中，Yarn 并行化操作，使安装过程更快速。我初次安装三个包，**jsonwebtoken**，**express** 和 **lodash**，使用 **npm** 和 **yarn**。<b>Yarn</b> 已经安装完毕了，<b>npm</b> 仍然在安装。

![Yarn 和 Npm 的 对比](https://cdn.auth0.com/blog/blog/yarn-npm-compare.png)

## 4. 自动锁定安装包版本

Npm 有一个名为 **shrinkwrap** 的特性，其目的是在生产环境中使用时锁定包依赖。**shrinkwrap** 的挑战是每个开发者都必须手动运行 `npm shrinkwrap` 生成 `npm-shrinkwrap.json` 文件。人非圣贤，孰能无忘? 

使用 Yarn，则截然不同。在安装过程中，会自动生成一个 `yarn.lock` 文件。有点类似 PHP 开发者们所熟悉的 `composer.lock`。`yarn.lock` 锁定了安装包的精确版本以及所有依赖项。有了这个文件，你可以确定项目团队的每个成员都安装了精确的软件包版本，部署可以轻松地重现，且没有意外的 bug。

## 5. 在不同的机器上以同样的方式安装依赖

**npm client** 安装依赖的方式可能会导致 <b>开发者 A</b> `node_modules` 目录和 <b>开发者 B</b> 不同。它使用非确定性手段来安装这些包依赖。这种方式由于 <b>在个别的系统下</b> 可以工作，而不容易复现问题。

Yarn 锁定文件的和安装算法的存在，确保了将应用程序部署到生产环境时，安装的依赖在开发机器之间，产生的文件和文件夹结构完全相同。

**注:** 还有一件事，我知道我讲了五件事，但是我几乎不能描述 **Yarn** 给我带来的感觉。企业环境需要能够列出依赖项的许可证类型。Yarn 提供了列出给定依赖关系的许可证类型的能力，在根目录中运行 `yarn licences ls`，如下:

![Yarn Licenses](https://cdn.auth0.com/blog/licenses.png)

## 总结

Yarn 在初期就已经带来了将 JavaScript 包从全局注册表提取到本地环境中显著的改进方式，特别是在速度和安全性方面。它会成为 JavaScript 开发者中最受欢迎的选择吗？你切换到 Yarn 了吗？你对 Yarn 有什么想法？欢迎在评论区讨论! 😹
