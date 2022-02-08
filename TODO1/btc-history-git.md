> * 原文地址：[The History of Git: The Road to Domination in Software Version Control](https://www.welcometothejungle.com/en/articles/btc-history-git)
> * 原文作者：[Andy Favell](https://twitter.com/andy_favell)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/btc-history-git.md](https://github.com/xitu/gold-miner/blob/master/TODO1/btc-history-git.md)
> * 译者：[fireairforce](https://github.com/fireairforce)
> * 校对者：[Long Xiong](https://github.com/xionglong58), [司徒公子](http://github.com/stuchilde) 

# Git 的历史: 软件版本控制的统治之路

![Coder stories](https://cdn.welcometothejungle.co/uploads/article/image/6172/158080/git-history-linus-torvalds.png)

**在 2005 年，Linus Torvalds 迫切需要一个新的版本控制系统来维护 Linux 内核的开发。于是他花了一个星期的时间，从头开始编写了一个革命性的新系统，并将其命名为 Git。十五年之后，该平台成为了[这个竞争激烈领域里面当之无愧的领导者](https://en.wikipedia.org/wiki/List_of_version-control_software)。**

在全球范围内，大量的初创企业、集体企业和跨国公司，包括谷歌和微软，使用 Git 来维护它们软件项目的源代码。它们中有些公司拥有自己的 Git 项目，有些公司则通过商业托管公司使用 Git，比如 GitHub（成立于 2007 年），Bitbucket（成立于 2010 年）和 GitLab（成立于 2011 年）。其中最大的 GitHub 拥有 [4000 万注册开发者](https://octoverse.github.com/) 并在 2018 年[被微软](https://news.microsoft.com/2018/06/04/microsoft-to-acquire-github-for-7-5-billion/)以 75 亿美元的天价收购。

Git（及其竞争对手）有时被分类为版本控制系统（VCS），有时是源码管理系统（SCM），还有时是修订控制系统（RCS）。Torvalds 认为生命太短暂而不必去区分这些定义，因此我们不必纠结于此。

Git 的吸引力之一在于它是开源的（就像 Linux 和 Android 那样）。但是，还有其它开源的 VSC，其中包括协作版本系统（CVS）、SVN、Mercurial 和 Monotone，因此单凭这一点并不足以解释它的优点。

关于 Git 市场主导地位的最好体现是 [Stack Overflow 对开发人员的调查](https://insights.stackoverflow.com/survey/)。调查结果显示，2018 年 74289 名受访者中有 88.4% 使用了 Git（高于 2015 年的 69.3%）。最接近的竞争对手是 Subversion，普及率为 16.6%（低于 36.9%）；Team Foundation 版本控制，从 2015 年的 12.2% 降为 11.3%；Mercurial 普及率为 3.7%（低于 7.9%）。事实上，Git 的优势如此之大，以至于 Stack Overflow 的数据科学家都懒得在 2019 的调查中提出这个问题。

```
开源人员使用什么来进行源码控制？

|           2018         |          2015          |
| ---------------------- | ---------------------- |
| Git: 88.4%             | Git: 69.3%             |
| Subversion: 16.6%      | Subversion: 36.9%      |
| Team Foundation: 11.3% | Team Foundation: 12.2% |
| Mercurial: 3.7%        | Mercurial: 7.9%        |
|                        | CVS: 4.2%              |
|                        | Perforce: 3.3%         |

| 74,298 受访者       | 16,694 受访者       |

数据来源：Stack Overflow 2018/2015 开发者调查报告
```

## 开始

直到 2005 年 4 月，Torvalds 一直使用 [BitKeeper](http://www.bitkeeper.org/)（BK）管理着一个庞大的 Linux 内核源码，这些源码来自于完全不同的志愿者开发团队，Linux 是一个越来越受欢迎的类 UNIX 开源操作系统。BK 在当时是一个私有的付费工具，但是 Linux 的开发者可以免费使用它，直到 BK 的创始人 Larry McVoy 与一个 Linux 开发人员就不恰当地使用 BK 发生了争执。

从 [Torvalds 的声明](https://marc.info/?l=linux-kernel&m=111280216717070&w=2) 到 Linux 邮件列表，都是关于他计划利用一个工作“假期”来决定如何为 Linux 找到新的 VCS，很明显，他喜欢 BK，并对 Linux 不能再使用它而感到沮丧，而且他对竞争并不敢兴趣。如之前提到的，这次假期诞生了 Git。Torvalds 将它命为 Git 的原因有很多种说法，但实际上他只是喜欢这个词，这是他从披头士的歌曲[《I’m So Tired》](https://genius.com/The-beatles-im-so-tired-lyrics)（第二节）中获得灵感。

**“搞笑的是，我所有的项目都是以我自己的名字命名，而这个项目的名字是‘Git’。Git 在[英国俚语](https://dictionary.cambridge.org/dictionary/english/git)里是‘愚蠢的人’的意思，”** Torvalds 告诉我们。**“它也有一个虚构的首字母缩写 —— Global Information Tracker。但这实际上是一个 ‘backronym’, \[事后\]补上的。”**

那么，Torvalds 对 Git 的巨大成功感到惊讶吗？**“如果我说我能看到它即将成功，那绝对是在撒谎。我当然没有。但是 Git 确实把所有的基础都做对了。有什么事情可以做得更好吗？当然。但总的来说，Git 确实解决了一些与 VCS 有关的真正困难的问题。”** 他说。

## 定义 Git 的目标

传统上，版本控制是客户端服务器，因此代码位于单个存储库中，或者中央服务器的仓库中。协作版本系统（CVS），[Subversion](https://en.wikipedia.org/wiki/Apache_Subversion) 和 Team Foundation 版本控制（TFVC）都是客户端/服务器系统的例子。

客户机-服务器 VCS 在企业环境中运行良好，在企业环境中，开发受到严格控制，由具有良好网络连接的内部开发团队进行。如果有成百上千的开发人员进行协作，自愿、独立、远程地工作，所有人都想要往代码里面添加新的东西，这对 Linux 等开源软件（OSS）项目来说都很常见的，那么这种协作就不太好用了。

BK 首创的分布式 VCS 打破了这种模式。Git、Mercurial 和 Monotone 都遵循这个示例。对于分布式 VCS 来说，最新版本的代码副本在每个开发人员的设备上，从而使开发人员可以更轻松地独立修改代码。**“BK 对使用模式的概念影响很大，确实应该得到所有的赞誉。但由于各种原因，我想让 Git 的实现逻辑与 BK 完全不同，但‘分布式 VCS’ 的概念确实是首要目标，BK 教会了我这一点的重要性，”** Torvalds 说。**“真正的分布式意味着 fork 不是问题，任何人都可以 fork 一个项目并进行自己的开发，然后一个月或一年后回来说，‘看看我做的这件伟大的事情。’”**

客户机-服务器 VCS 的另一个主要缺点，特别是对于开源项目，是在服务器上托管中央存储库的人“掌握”了源代码。然而，在分布式 VCS 中，没有中央存储库，只有许多拷贝复制，因此没有人掌握或控制代码。

**“\[这使得\] 像 GitHub 这样的网站成为可能。当没有包含源代码的中心“主”位置时，你可以突然托管一些东西，而不需要遵循“一个仓库来统治所有人”的策略。”** Torvalds 说。

另一个核心目标是减少将新分支合并到主分支代码或者 “tree”（组成源代码层次结构的目录）的痛苦。关键是为每个对象分配一个加密哈希索引（唯一且安全的数字）。Git 并不是唯一使用哈希的版本控制器，将它提升到了一个新的高度，不仅将它们应用于每个新版本的文件内容，而且还使用它来确定它们之间的关系，包括 tree 和 commit 。这意味着，通过使用 “git diff” 指令，git 可以通过比较哈希的两个索引，非常快速地识别出分支新的/待提交版本与源代码之间的所有更改，甚至是整个 tree。**“Git 索引的真正目的是作为合并的中间步骤，这样你就可以增量地修复冲突，”** Torvalds 说。

在进行完全合并之前，这种中间步骤或暂存区的概念可进行版本之间的比较，并解决主要源代码和附加内容之间的任何问题，这个概念是革命性的。然而，这并没有得到那些习惯于其他 VCS 人的普遍认可。

## 指定一名维护人员

在编写了 Git 之后，Torvalds 将其开放给开源社区进行审查和贡献。在那些参与者中，有一位开发人员特别引人注目：Junio Hamano。因此，仅仅几个月后，Torvalds 就可以[抽出身来](https://marc.info/?l=git&m=112243466603239)，专注于Linux，把维护 Git 的责任移交给 Hamano。**“当涉及到代码和功能时，他有明显的、非常重要但难以具体描述的‘好品味’。”**Torvalds 说，**“Junio 确实应该接受所有的荣誉，作为发起人，我理应获得设计 Git 的荣誉。但作为一个项目，Junio 是维护它的人，让它成为一个非常好用的工具。”** 

显然，Junio 是一个不错的选择，因为 15 年后，他仍然作为一个[仁慈的独裁者]((http://oss-watch.ac.uk/resources/benevolentdictatorgovernancemodel))来主导并维护 Git，这意味着他控制着 Git 未来发展的方向，对代码的修改拥有最终的决定权，并且他保持着最多提交的记录。

## 扩大 Git 的吸引力

早期支持 Hamano 的一些志愿贡献者到现在仍然在贡献力量，尽管他们现在经常被一些依赖 Git 的公司全职雇用，并希望对其进行维护和改进。

其中一名志愿者是 Jeff King，人们叫他 Peff，他在学生时代就开始参与贡献了。他的第一次代码提交是在 2006 年，在将他的代码仓库从 CVS 迁移到 Git 时发现并修复了 [git-cvsimport](https://git-scm.com/docs/git-cvsimport) 中的一个错误。**“当时我是计算机科学与技术专业的研究生，”**他说，**“所以我花了很多时间在 Git 的邮件列表上，回答问题、修复 bug —— 有时是一些困扰我的问题，有时是对其他人报告的回复。到 2008 年左右，我意外地成为了主要贡献者之一。** King 从 2011 年开始受雇于 Guthub 公司，在工作的同时，也为 Git 贡献自己的一份力量。

King 特别提到了 Git 的两位贡献者的杰出工作，他们都始于 2006 年，并帮助将 Git 的影响扩展到 Linux 社区之外：感谢 Shawn Pearce 为 [JGit](https://gerrit.googlesource.com/jgit/) 所做的工作，为 Java 和 Android 生态系统打开了 Git 的大门；感谢 Johannes Schindelin 为 Git for Windows 所做的工作，向 Windows 社区开放了 Git。他们随后分别在谷歌和微软工作。

**“\[Shawn Pearce\] 是 Git 的早期贡献者并且实现了 [git-gui](https://git-scm.com/docs/git-gui)，这是 Git 的第一个图形化界面。但更重要的是他在 JGit 上的工作，JGit 是 Git 的纯 Java 实现”** King 说。**“这使得 Git 用户的整个其他生态系统得以实现，并允许 Eclipse 插件，这是 Android 项目选择 Git 作为其版本控制系统的关键部分。他还写了 [Gerrit](https://www.gerritcodereview.com/) \[在 Google 工作时\]，一个基于 Git 的代码审查系统，用于 Android 和许多其它项目。不幸的是，[Shawn 在 2018 年去世](https://sfconservancy.org/blog/2018/jan/30/shawn-pearce/)。”**

Schindelin 现在仍然是 Git for Windows 发行版的维护者。**“由于 Git 是从内核社区中发展而来的，所以对 Windows 支持基本上是后来才想起的，”。**King 说 **“Git 已经被移植到很多平台上，但大多数平台都是类似于 Unix 风格。到目前为止，Windows 是最大的挑战。在 C 代码中不仅存在可移植性问题，而且还存在使用 Bourne shell、Perl 等编写的部分来发布应用程序的挑战。Git for Windows 将所有这些复杂性整合到一个单一的二进制包中，对 Windows 开发人员使用 Git 的增长产生了重大影响。”**

根据 [somsubhra.com](https://www.somsubhra.com/github-release-stats/?username=git-for-windows&repository=git) 统计，Git for Windows 迄今已被下载超过 1800 万次。

## 建立 GitHub

Tom Preston-Werner 是由同事 Dave Fayram 介绍给 Git的，当时他在为一家名为 [Powerset](https://en.wikipedia.org/wiki/Powerset_(company)) 的初创公司做辅助项目。**“\[用 Git \]创建分支、对其进行操作并轻松地将其合并回主分支的能力是革命性的。在这方面 Git 是惊人的。命令行界面需要适应，特别是有一个缓冲区的概念，”** Preston Werner 说。提供基于 Git 的源代码托管服务的机会是显而易见的。**“托管 Git 仓库没有任何好的选择，因此，这对易用性来说是一个大障碍。还缺少一个现代的 web 界面。作为一名 web 开发人员，我认为我可以通过轻松托管 Git 仓库和促进协作来改善这种情况，这是 Git 可以做到的，但并不容易，”**他补充道。

Preston-Werner 与 Chris Wanstrath、Scott Chacon 和 P.J. Hyett 合作，于 2007 年底开始开发 GitHub 项目。GitHub 帮助 Git 成为主流，不仅使它更易于使用，还将其传播到 Linux 社区之外。由于 GitHub 的创始人是 Ruby 开发人员，而且 GitHub 是用 Ruby 编写的，所以这个词很快就在这个社区中传开了，并在被 [Ruby on Rails](https://github.com/rails/rails) 开发框架采用时大获成功。

**“到 2008 年年中，Ruby on Rails 转向了 GitHub，整个 Ruby 社区似乎都很快跟进。我认为，这种背书，加上 Ruby 开发人员愿意接受更新、更好的技术，这些对我们的成功都至关重要。”**Preston-Werner 说。**“其他项目，如 [Node.js](https://github.com/nodejs) 和 [Homebrew](https://github.com/Homebrew)，都是从 GitHub 开始的，帮助将 Git 引入了新的社区。”**

Preston-Werner 在 2014 年[辞去了 GitHub CEO 一职](https://github.blog/2014-04-28-follow-up-to-the-investigation-results/)，当时有人指控该公司存在欺凌行为和不适当的投诉程序，这些问题或许是该公司发展过快的征兆。

今天，根据 GitHub [自己的数据](https://octoverse.github.com/)，GitHub 有超过 4000 万注册开发者。这使得它比竞争对手 —— [Bitbucket 拥有1000万用户](https://bitbucket.org/blog/celebrating-10-million-bitbucket-cloud-registered-users)的规模要大得多，而 GitLab 则表示，它拥有“数百万”用户。

## 被 Android 采用

许多公司使用 [GitHub 企业版](https://github.com/customer-stories?type=enterprise)、[GitLab](https://about.gitlab.com/customers/) 或 Bitbucket 来托管软件项目。但是，最大的 Git 安装往往是内部托管的 —— 因此是在公共视野之外 —— 通常进行定制的修改。

Google 是第一个 Git 的主要采用者（因此也提供了大量的支持），谷歌在 2009 年 3 月决定将 Git 用于 Android 项目，Android 是一个基于 Linux 的手机操作系统。作为开源项目，Android 需要一个允许大量开发人员克隆、使用和贡献代码的平台，并且无需购买特定的工具许可证书。

当时，Git 被认为不足以管理如此庞大的项目，因此团队构建了一个超级仓库，可以委托给子 Git 仓库。然而，谷歌表示：**“超级仓库并不是要取代 Git，只是为了让 Git 更容易使用。**为了帮助查看仓库和管理、审查对源代码的更改，Pearce 领导的团队 —— 创建了 [Gerrit](https://gerrit.googlesource.com/gerrit/)。

## Microsoft 改变态度

考虑到开源社区和微软之间相互仇恨的历史，这个软件巨头肯定是 Git 最不可能的支持者。2001 年，当时的微软首席执行 Steve Ballmer 甚至[称 Linux 为癌症](https://www.theregister.co.uk/2001/06/02/ballmer_linux_is_a_cancer/)，微软也有自己的竞争对手 VCS TFVC。

Schindelin 在 Git for Windows 上工作了多年，而微软没有任何人注意到他的努力。但是，到 2015 年，当他在微软工作时，文化发生了巨大的转变。他开玩笑说：**“如果你在 2007 年问我，或者在 2011 年问过我，我是否会拥有一台 Windows 机器，甚至在微软工作，我都会笑死的。**

这一文化转变的第一个证据出现在 2012 年，当时微软开始（实际上）为 Git 开发资源库 [libgit2](https://libgit2.org/)（一个 Git 开发资源库）做出贡献，以帮助加快 Git 应用程序的速度，然后将其嵌入到开发工具中。Edward Thomson，微软团队的一员，仍然是 libgit2 的维护者。

2013 年，微软宣布对其开发工具 Visual Studio（VS）提供 Git 支持，并通过 Azure DevOps（当时称为 Team Foundation Service）的云计算工具和服务套件提供 Git 托管，作为其自身 TFVC 的替代方案，这一消息震惊了科技界。

更值得注意的是，从 2014 年开始，在新的开源友好型 CEO Satya Nadella 的领导下，微软通过 One Engineering System（1ES）计划，在 Git 上逐步实现了内部软件开发的标准化。Azure DevOps 团队在 2015 年开始使用自己的 Git 服务作为自己源码的存储库，这是一个先例。

2017年，微软 Windows 产品套件的整个开发工作转移到了由 Azure 托管的 Git 上，创建了[世界上最大的 Git 存储库](https://devblogs.microsoft.com/bharry/the-largest-git-repo-on-the-planet/)。这包括相当大的调整以帮助 Git 扩展。Git 的[虚拟文件系统](https://vfsforgit.org/)（它是开源的）并没有将整个 300GB 的 Windows 存储库下载到每个客户端设备，而是确保只将适当的文件下载到每个工程师的计算机上。

正如 Schindelin 所指出的：**“当像微软这样历史悠久的大公司决定 Git 可以投入企业级使用时，商业界会非常仔细地倾听。我认为这就是为什么 Git 至少在目前为止是‘赢家’的原因。**

## 收购！

2018 年 6 月，微软[宣布](https://news.microsoft.com/2018/06/04/microsoft-to-acquire-github-for-7-5-billion/)将以 75 亿美元的价格收购 GitHub，这让人大吃一惊。但当你看事实的时候，也许会觉得这次收购并不是那么出乎意料。

微软从 2014 年开始参与 GitHub，当时。.Net 开发者平台是[开源的](https://devblogs.microsoft.com/dotnet/net-core-is-open-source/)。据 [GitHub Octoverse 2019](https://octoverse.github.com/) 调查显示，目前 GitHub 上贡献最多的两个项目都是微软的产品 —— [Visual Studio code](https://github.com/microsoft/vscode) 和 [Microsoft Azure](https://github.com/Azure)，而 [OSCI/EPAM 在 2019 年的研究](https://solutionshub.epam.com/OSCI/)显示，微软是 GitHub 上最大的企业贡献者。并且，如前所述，微软已经在 Git 上标准化了内部开发。

```
开源项目的贡献者数量

|                项目                    |  贡献人数     |
| -------------------------------------- | ------------- |
| Microsoft/vscode                       | 19.1k         |
| MicrosoftDocs/azure-docs               | 14k           |
| flutter/flutter                        | 13k           |
| firstcontributions/first-contributions | 11.6k         |
| tensorflow/tensorflow                  | 9.9k          |
| facebook/react-native                  | 9.1k          |
| kubernetes/kubernetes                  | 6.9k          |
| DefinitelyTyped/DefinitelyTyped        | 6.9k          |
| ansible/ansible                        | 6.8k          |
| home-assistant/home-assistant          | 6.3k          |

来源：GitHub Octoverse 2019 
```

```
在 GitHub 上的开源项目的公司中活跃的贡献者的数量

|  公司        |     活跃贡献者        |
| -------------| -------------------- |
| Microsoft    | 4,859                |
| Google       | 4,457                |
| Red Hat      | 2,766                |
| IBM          | 2,108                |
| Intel        | 2,079                |
| Facebook     | 1,114                |
| Amazon       | 850                  |
| Pivotal      | 767                  |
| SAP          | 732                  |
| GitHub       | 663                  |

来源: OSCI/EPAM research January 2020 
```

尽管如此，这次收购还是引起了一些 GitHub 用户的担忧，他们还记得在开源社区的眼中刺 Ballmer 领导下的老微软。Bitbucket 和 GitLab 都声称看到了从 GitHub 迁移到他们平台的项目激增。

不过，Torvalds 并不这么认为。**“我对微软的收购没有任何保留意见，部分原因是 Git 的基本分布式特性 —— 它避免了政治问题，另一方面也避免了可怕的‘托管公司控制项目’。我不担心的另一个原因是，我认为微软现在是一家不同的公司...微软根本不是开源的敌人。”**他说，**“在纯粹个人层面上，当我听说微软在 GitHub 上花了很多钱时，我只是说，‘现在我开始的两个项目已经变成了价值数十亿美元的产业’，没有多少人能这么说。我也不只是一个“昙花一现的人”。**
**“这是‘生活幸福’的一部分。我很高兴我对世界产生了积极而有意义的影响。我个人可能没有直接从 Git 上赚到任何钱，但它给了我能够做我真正的工作和激情，[Linux]。我不再是一个饥肠辘辘的学生了，我作为一个受人尊敬的程序员做得很好。所以其他人在 Git 上获得的成功绝不会让我感到沮丧。”**

**贡献者。感谢：Linus Torvalds，Git 和 Linux 的创始人；Johannes Schindelin，微软软件工程师，Git for Windows 的维护者；Jeff King， GitHub 的 OSS 开发人员；Tom Preston Werner，Chatterbug 的联合创始人，GitHub 的联合创始人；Edward Thomson，GitHub 的产品经理，以及 libgit2 的维护者；Ben Straub，Pro Git 的作者；Evan Phoenix，Rubinius 的创建者；GitLab 高级后端工程师 Christian Couder；GitLab首席营销官 Todd Barr；EPAM 交付管理总监 Patrick Stephens。**

**本文出自 Behind the Code —— 由开发者创建的服务于开发者的媒体平台。通过访问 [Behind the Code](https://www.welcometothejungle.com/collections/behind-the-code)，可以发现更多的文章和视频！**

**想要参与贡献？[出版！](https://docs.google.com/forms/d/e/1FAIpQLSeelH8Eh0HohNrrDWnmKJGBRsFijXfMsMw1fPxOSGdMVypCyg/viewform?usp=sf_link)**

**在 [Twitter](https://twitter.com/behind_thecode) 上关注我们吧，保持关注！**

**[Blok](https://fr.creasenso.com/portfolio/blok) 声明**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
