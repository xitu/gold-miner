> * 原文地址：[An introduction to how JavaScript package managers work](https://medium.freecodecamp.com/javascript-package-managers-101-9afd926add0a#.746vwi3oh)
* 原文作者：[Shubheksha](https://medium.freecodecamp.com/@shubheksha)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[luoyaqifei](http://www.zengmingxia.com)
* 校对者：[cyseria](https://github.com/cyseria)，[wild-flame](https://github.com/wild-flame)

# JavaScript 包管理器工作原理简介


不久前，Node.js 社区的负责人之一 [ashley williams](https://medium.com/u/1978eb600702) 发了一条这样的推特：

>lockfiles = awesome for apps, bad for libs this is not a new thought, i'm confused why's everyone mad about this
锁文件 = 棒（对于应用而言），坏（对于库而言），这不是一个新想法，我只是很困惑，为什么所有的人都因为这个很崩溃

 >— @ag_dubs



我不是很懂她说的是什么，所以我决定去深入钻研下，学习一些包管理器的工作机制。

这是个对的选择，因为 JavaScript 管理器这个大组织中出现了一个新成员，叫做 [Yarn](https://yarnpkg.com/)，刚刚出现，就引发了很多讨论。

所以我利用这个机会，也来理解一下 [Yarn 是怎样和 npm 区分开来的，为什么要这样](https://code.facebook.com/posts/1840075619545360/yarn-a-new-package-manager-for-javascript/)。

我在研究这个的时候觉得很有意思，真希望很久以前就这么做了。所以我写了篇关于 npm 和 Yarn 的简单介绍，来分享我学到的一些东西。

让我们从一些定义开始：

#### 什么是包？

包是一段可以复用的代码，这段代码可以从全局注册表下载到开发者的本地环境。每个包可能会，也可能不会依赖于别的包。

#### **什么是包管理器？**

简单地说，包管理器是一段代码，它可以让你管理**依赖**（你或者他人写的外部代码），你的项目需要这些依赖来正确运行。

很多包管理器在处理你项目的以下部分：

#### **项目代码**

项目代码即你的项目中的代码，你需要为它管理不同的依赖。通常来说，所有的代码都被放入像 Git 这样的版本控制系统里。

#### **Manifest 资源配置文件（Manifest file）**

Manifest 资源配置文件指的是记录你的所有依赖（需要管理的包）的文件。它也保存了你项目的元数据（metadata）。在 JavaScript 的世界中，这个文件就是你的 `[package.json](https://docs.npmjs.com/files/package.json)`。

#### **依赖代码**

依赖代码指组成你的依赖的代码。在应用的生命周期里，这段代码不应被更改，在它被需要的时候，也应该能被在内存里的项目代码所访问。

#### **锁文件（Lock file）**

锁文件是由包管理器自动生成的。它包含了重现全部的依赖源码树需要的所有信息、你的项目依赖中的所有信息，以及它们各自的版本。

现在值得强调的是，Yarn 使用了锁文件，而 npm 没有。我们会谈到这种差别导致的一些后果。

既然我已经向你介绍了包管理器这部分，现在我们来讨论依赖本身。

### 扁平依赖（Flat Dependencies）VS 嵌套依赖（Nested Dependencies）

为了理解扁平依赖和嵌套依赖的区别，让我们试着可视化你项目中的依赖树。

记住，你项目中的依赖也可能依赖于它自己。这些依赖也可能会相应地有一些共同的依赖。

为了让这个更清楚，我们表达为，我们的应用依赖于依赖 A、B 和 C，C 依赖于 A。

#### **扁平依赖**









![](https://cdn-images-1.medium.com/max/1600/1*QFSdXpqBdeuJIJDzr0KfZg.png)



[扁平关系下的依赖关系图](http://maxogden.com/nested-dependencies.html)



正如图中展示的，应用（app）和 C 将 A 作为它们的依赖。为了在扁平依赖场景中解析依赖，你的包管理器只需要遍历一层依赖。

长的故事变短了——你只能拥有你的源码树里的特定包的一个版本，因为对于你的所有依赖，有一个公共的命名空间。

假设包 A 升级到版本 2.0，如果你的 app 与版本 2.0 兼容，但是包 C 不与其兼容的话，我们需要两个版本的包 A，用来让你的 app 正常工作。这就是传说中的 **依赖地狱（Dependency Hell）**。

#### **嵌套依赖**









![](https://cdn-images-1.medium.com/max/1600/1*GWq1l9Mxe0k7teuJCIOlYw.png)



[嵌套关系下的依赖关系图](http://maxogden.com/nested-dependencies.html)



曾经简单的处理依赖地狱的方法是有两个不同版本的包 A - 版本 1.0 和版本 2.0。

这个时候，自然需要嵌套依赖出场。在嵌套依赖的情况下，所有的依赖可以将它自身的依赖从其它依赖中独立出来，独立到另一个命名空间里。

为了解析依赖，包管理器需要遍历多层。

我们可以在这样的场景下拥有多份单个依赖的副本。

但是就像你可能已经猜到的那样，这个也会导致一些问题。如果我们将另一个包——也就是包 D——加入依赖，它也同样依赖于包 A 的版本 1.0 呢？

所以在这种场景下，我们可以用包 A 的版本 1.0 的**重复**来结束。这可能会导致一些混乱，并且占用一些不必要的磁盘空间。

一种解决以上问题的方法是拥有包 A 的两个版本，v1.0 和 v2.0，但只有一份 v1.0 的副本，这样我们就可以避免不必要的重复。这就是 [npm v3 中采取的做法](https://docs.npmjs.com/how-npm-works/npm3-dupe)，相当多地减少了遍历依赖树消耗的时间。

就像 [ashley williams](https://medium.com/u/1978eb600702) 阐述的那样，[npm v2 用一种嵌套的方式来安装依赖](https://docs.npmjs.com/how-npm-works/npm2)。这就是 npm v3 相较而言快多了的原因。

### **确定性 VS. 不确定性**

在包管理器里另一个重要概念是确定性。在 JavaScript 生态系统的大背景下，确定性意味着所有拥有同一个 `package.json` 文件的电脑都将在它们的 `node_modules` 文件夹里有一个完全相同的依赖源码树。

但是如果是一个具有不确定性的包管理器，那么就不能保证了。即使你在两台电脑上有一个完全一样的 `package.json` ，它们的 `node_modules` 也可能不一样。

确定性总是被喜爱的，它能够帮助你避免 **「工作在自己的机器上，但是当部署的时候总会坏掉」** 的问题，这种问题可能发生在不同电脑上有不同的 `node_modules` 时。









![](https://cdn-images-1.medium.com/max/1600/1*i4QK4sSGX7Q4RRgOytkSuw.jpeg)



最新潮的开发人员也会遇到不确定性的问题。



[npm v3 默认的是不确定的安装](https://docs.npmjs.com/how-npm-works/npm3-nondet)，但它提供了一个 [shrinkwrap 特性](https://docs.npmjs.com/cli/shrinkwrap) 来让安装变得有确定性的。这将所有在磁盘上的包以及它们各自的版本，写入一个锁文件。

Yarn 提供了具有确定性的安装，因为它使用了一个锁文件，在应用层递归地锁住所有的依赖。所以如果包 A 依赖于 包 C 的 v1.0，包 B 依赖于包 A 的 v2.0，这两个依赖都会被分别写入锁文件。

当你知道你工作时使用的依赖的确切版本，你可以轻松地重现构建，然后追踪并且隔离 bug。

> 为了使得它更清晰，你的 `package.json` 表达的是在项目中**「我想要的」**，而你的锁文件表达的是依赖中**「我有的」**。— [Dan Abramov](https://medium.com/u/a3a8af6addc1)

所以我们可以回到最初的问题，也就是使得我开始这段探索之路的问题：**为什么对于应用，锁文件是一个好的实践，但是对于库来说，不是呢？**

最主要的原因是你实际上要部署应用。所以你需要拥有具有确定性的依赖，从而在不同的环境中重现你的构建——测试、前进和生产。

但是对于库来说就不一样啦，库不是被部署的，它们是用来构建其它库，或者在自身的应用中使用的。库需要很灵活，所以它们可以最大化兼容性。

如果我们对于所有我们在应用中用到的依赖（库）都有个锁文件（lockfile），并且应用被强制遵循锁文件，将没有办法使得所有的地方靠近我们之前提到的扁平依赖结构，和 [语义化版本（semantic versioning）](http://semver.org/) 灵活性，这种灵活性是依赖解析最好的用例场景。

这就是原因：如果你的应用需要递归地遵守你的所有依赖的锁文件，所有的地方都将会有版本冲突——即使在相对小的项目中。由于 [语义化版本（semantic versioning）](https://docs.npmjs.com/getting-started/semantic-versioning)，这将导致大规模无法避免的重复。

这并不是说库不能拥有锁文件，它们当然可以。但是主要的重点是像 Yarn 和 npm 这样的包管理器，它们也是这些库的使用者，并且会无视它们的锁文件。
