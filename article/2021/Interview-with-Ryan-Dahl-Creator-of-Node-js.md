> * 原文地址：[Interview with Ryan Dahl, Creator of Node.js](https://evrone.com/ryan-dahl-interview)
> * 原文作者：[Ryan Dahl](https://evrone.com/ryan-dahl-interview)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Interview-with-Ryan-Dahl-Creator-of-Node-js.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Interview-with-Ryan-Dahl-Creator-of-Node-js.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Chorer](https://github.com/Chorer)、[zenblo](https://github.com/zenblo)、[lsvih](https://github.com/lsvih)

# 和 Node.js 创始人 Ryan Dahl 的对话

## 导言

Ryan Dahl 是 Node.js 的创始人以及 Deno JavaScript 和 TypeScript 运行时的早期开发者。我们很高兴有机会与 Ryan 探讨他开发的一些别的项目以及 Deno 面临的主要挑战，了解他对 JavaScript 和 TypeScript 的未来的想法，寻找更多第三方的 Deno 生态系统项目的更多信息，并讨论如果他能时光倒流，他会如何改变 Node.js 的开发！

## 采访正文

**Evrone：** 你的新项目 Deno 对开发者们产生了很大影响。请问你现在大部分时间都在做些什么？

**Ryan：** 我大部分时间都在研究 Deno！实际上 Deno 是一个相当大的软件集合，我们把它放到可执行文件中。我们现在正在提升 Deno 运行时，同时也在努力将基础架构应用到商业项目中。

**Evrone：** 你具有使用多种编程语言的实践经验，例如 C、Rust、Ruby、JavaScript 和 TypeScript。你最喜欢使用哪一种语言进行开发？

**Ryan：** 这些天我发现编写 Rust 代码最是有趣。它的学习曲线很是陡峭，并且不适合许多情景，但对于我现在正在研究的东西来说，它真的是完美的，比 C++ 好多了 —— 我坚信我将永远不会再开始一个新的 C++ 项目。Rust 具有如此简单的表达低级机械语言的能力，真的太棒了！

JavaScript 从来不是我最喜欢的语言，它只是最常见的语言，也因此，它能被我们用来表达许多想法。我不认为 TypeScript 是一种独立的语言，毕竟它的优点只在于它拓展了 JavaScript。TypeScript 允许人们使用 JavaScript 构建更大，更强壮健康的系统，而我想，这会是我日常工作的首选语言。

在 Deno 中，我们正试图降低将 TypeScript 代码转换为 JavaScript 所固有的复杂性，希望这将使更多开发者能够使用 TypeScript。

**Evrone：** 渐近类型（Gradual typing）已成功添加到 Python 核心库、PHP 和 Ruby 语言中。你认为将类型添加到 JavaScript 的主要作用是什么？

**Ryan：** 将类型（像 TypeScript 那样）添加到 JavaScript 的成功远远超过了在 Python、PHP 或 Ruby 中所完成的那样。TypeScript 是具有类型的 JavaScript 语言。更好的问题是：是什么在阻止 JavaScript 标准化组织（TC39）采用 TypeScript？通过设计，标准化会缓慢而谨慎地进行。他们首先正在研究提出 Types-As-Comments 的提议，该提议将允许 JavaScript 运行时通过忽略类型来执行 TypeScript 语法。我认为最终 TypeScript（或类似的东西）将作为 JavaScript 标准的一部分被提出，但这需要时间。

**Evrone：** 作为受人尊敬的 VIM 用户，你如何看待像 VS Code 这样的现代化代码编辑器？他们对老一代开发者友善吗？

**Ryan：** 与我一起工作的每个人都使用 VS Code。他们喜欢它，而且我想多数人都应该去使用它。

我继续使用 VIM 的原因有两个。

1. 我对它非常熟悉，并且可以用它快速编码。我喜欢在 ssh 和 tmux 上的工作体验，并且享受全屏终端的宁静。
2. 对于软件基础结构来说，基于文本并可以通过简单工具进行访问非常重要。在 Java 世界中，开发者们犯了将 IDE 过多地与该语言的世界联系在一起的错误，从而造成一种情况，即实际上人们被迫使用 IDE 去编写 Java 代码。而通过使用简单的工具，我可以确保我开发的软件不会不必要地依赖 IDE。如果你去尝试使用 grep 而不是跳转到定义（jump-to-definition），那么你会发现，跳转到定义这种太多的间接寻址实在是令人无法忍受。对于我所做的事情，我认为这会带来更好的软件。

**Evrone：** Deno 运行时展示了修复依赖项管理、安全性等长期存在的问题的可能方法。你是否希望它像是进行实验的 Haskell 那样的场所，还是你想将它作为最佳实践选择，用在一些什么用途上？

**Ryan：** 千万不要将新颖性误认为是实验性的，Deno 绝对是实用的，它建立在服务器端 JavaScript 已有多年经验的基础上。我和我的同事们致力于构建实用的动态语言运行时。我们围绕依赖项管理和安全性所做的设计选择非常保守。我们可以很容易地引入另一个类似于 NPM 的集中式系统，但是选择了基于 Web 标准 URL 的链接系统。我们当然可以更容易地打开文件系统和网络中的各种安全漏洞，但相反，我们选择像浏览器一样仔细管理访问。

Deno 是新软件 —— 这使得它天生就不适合很多用例。但是 Deno 还是一个大型 Rust 代码库，拥有着强大的速度，稳定可靠且成功率高的 CI 管理以及定期的计划发布。你说这是实验性的，这可不是实验！

**Evrone：** 在 2020 年，大多数软件开发人员大会都变成了“在线”和“虚拟”会议。你是否尝试参加过这种新形式的会议？你对此又有何看法？

**Ryan：** 我参加过，但我现在正避免参加线上会议。对我而言，会议最好的部分是“走廊”（指去交际），这恰恰是在线会议所缺失的一个关键方面。我更喜欢在空闲时间以 2 倍的速度观看 YouTube 上的演讲。希望我能在 2021 年晚些时候参加一些非虚拟的会议。

**Evrone：** 将依赖关系图从一个文件分散到单个源代码文件的想法受到了 Webpack 的拥护，也受到许多开发人员的赞扬。但是依赖性管理具有挑战性，Node.js 从 Common.js 迁移到 ESM 花费了多年的时间。请问你要使用 Deno 解决的主要依赖管理问题是什么？

**Ryan：** 浏览器没有借助任何一个 CDN 来分发 JavaScript。网络的分散性是其最大的优势，我不明白为什么这也不能用于服务器端的 JavaScript。因此，我希望 Deno 不依赖于任何中心化的代码数据库。

**Evrone：** Python 和 JavaScript 正在竞争，PK 究竟谁才是最佳的供新人开发者学习的通用编程语言。你对此有何看法？

**Ryan：** 脚本语言非常适合初学者。本质上，Python 和 JavaScript 的语言系统非常相似，只不过语法各异，在语义上也稍微不同。JavaScript 是由国际标准委员会管理的，可以在所有地方运行，并且速度要快一个数量级（将 V8 与 cpython 进行比较时），而且还拥有着更大的用户群。而对于某些领域来说，可用的 Python 库则更多，尤其是在科学计算中。新手程序员想开发的东西因人而异，Python 可能是合适的。但总的来说，我认为 JavaScript 是一种更好的入门语言。

**Evrone：** 具有一个主线程和小的 `handler` 可调用对象的异步并发范例是 Node.js 的基石之一。现在，这种想法通过新的 `Async / Await` 语法和协程的概念得到了进一步提升。作为平台作者，你如何看待它们及其可用的替代方案，例如 Go Goroutines 或基于 Ruby 线程的并发？

**Ryan：** OS 线程无法很好地扩展到高并发应用程序。如果你有许多并发连接，请不要使用 Ruby。

Goroutines 非常易于使用，并能够达到最佳性能。与 Go 一样，Node 和 Deno 都是基于非阻塞 IO 和 OS 事件通知系统（`epoll`，`kqueue`）构建的。JavaScript 本质上是一个单线程系统，因此 Node 或 Deno 的单个实例通常无法在不开始创建新实例的情况下利用系统上的所有 CPU 内核。Node / Deno 是 JavaScript 的最佳选择，但在没有其他可能偏向 JavaScript 的其他要求的情况下，Go 最终是高并发系统的更好选择。

**Evrone：** 在如此激烈的竞争中，你如何看待 JavaScript 和 TypeScript 的未来，尤其是与后端、嵌入式和机器学习（ML）领域有关的未来？

**Ryan：** 动态（或“脚本”）语言**非常有用。程序员要解决的问题通常不受 CPU 限制。问题更多是受工程时间限制。能够快速开发和部署更为重要。在动态语言中，JavaScript（纯 JavaScript 或带类型的 JavaScript）是最受欢迎的，也是迄今为止最快的。未来，我相信我们所追求的唯一动态语言将是这种奇怪的、从网络浏览器中衍生出来的进化语言。借助 Deno，我们正在努力消除障碍，在某些很少使用 JS 的地方应用 JS，像是机器学习领域。例如，我们可能会在 Deno 中添加 WebGPU 支持，从而允许简单的开箱即用的 GPU 编程，最终将使 TensorFlow.js 之类的系统能够在 Deno 上运行。

如前所述，动态语言有其局限性，并不适合所有问题领域。如果你正在对数据库进行编程，则最好使用一种使你对计算机具有最大控制权的语言（例如 Rust 或 C++）进行编写。如果你正在编写高并发性 API 服务器，很难想象有比 Go 更好的选择。

**Evrone：** 现代操作系统和新的 Deno 运行时引入了精细的权限，以抵消第三方软件和依赖项的安全风险。但是，使用依赖关系的最终用户和开发人员是否有可能在“允许”和“拒绝”应用程序安全性请求时做出正确的决定？你如何看待几年后像我们大多数人一样自动单击“允许一切”的风险，就像我们大多数人现在对网站 Cookie “安全确认”所做的那样？

**Ryan：** 网站 Cookie 弹出窗口不是个最好的类比 —— 它们是相当无用的法律副产品。更好的是内置一个对话框，上面写着“允许该网站访问你的相机”或“允许桌面通知”或“允许该网站查看你的位置”。这些并不是没有用的，这些是相当重要的安全功能。

程序员在计算机上运行许多不同的自动化程序，没有人有时间审核他们将要运行的所有代码，也不足以在 Docker 容器中运行所有代码：当你运行 lint 时，是被隔离的吗？不，答案是你必须相信 lint 脚本不会破坏你的系统。我认为允许用户查看并拒绝不必要的系统访问非常合适。

**Evrone：** 全新的“全栈”概念促使开发人员同时编写前端代码和后端代码，而使用相同的语言和诸如 TypeScript 之类的共享技术栈在现在变得非常容易。你认为对于许多开发人员来说，将如此多的不同事物纳入他们的日常工作范围是一个好主意吗？

**Ryan：** 降低复杂性总是有益的。程序员必须与之交互的语言、VM、框架和概念越少越好。

**Evrone：** 你打算如何处理 TypeScript 语言本身的版本更新？在 Node.js 生态系统内，使用 V8 引擎进行 JavaScript 语法更新通常会导致某些程序包无法正常工作。

**Ryan：** TypeScript 语言几乎具有完整的功能。依赖于最先进的语言功能的用户可能会遇到不稳定的情况，请不要这样做。

**Evrone：** 你如何看待软件开发人员的良好教育？我们是否需要具有所有数学，算法和数据结构的“科学”（如“计算机科学”），还是需要其他东西？

**Ryan：** 想要从事编程职业的人应该去大学学习计算机科学。当然，可以获得相关领域的学位（例如电气工程，物理学，数学）；有许多非常有能力的工程师根本没有学位。但是，通过花几年的时间学习基础知识并进行许多非常困难的实验，确实可以得到一些好处。

**Evrone：** 你是否有非常喜欢的已经实施了的第三方 Deno 生态系统项目？

**Ryan：** 是的，当然有：

- 一个 React 框架
- 网络框架（如 Express）
- 用于桌面应用程序的基于 Web 的 GUI
- Puppeteer（与 Node 中的操纵符相同）
- 可视化模块图
- 最小但灵活的静态站点生成器

**Evrone：** 随着 GitHub 之类的社交平台的推出，个体开发者和大公司现在都可以轻松地使用开源并做出贡献。你认为现在是“开源的黄金时代”，还是认为仍存在着一些潜在的问题？

**Ryan：** 现在肯定是开源的，许可情况已广为人知并得到了解决。关于维护的激励模型仍然存在未解决的问题，也许 GitHub 赞助商正在朝着这个方向提供帮助。它比以前要好，但是我希望我们能找到一种方法，使维护软件重要部分的人员可以为他们的工作得到独立的报酬。

**Evrone：** Deno 已经面世有一段时间了，目前该项目的主要技术挑战是什么？

**Ryan：** 正在进行中的很多事情：我们正在构建与 Hyper Web 服务器的绑定，它将提供 HTTP 2，并且可能比当前的 Web 服务器要快得多。我们正在构建 `deno lsp`，它提供了语言服务器协议，以便 VS Code（和其他 IDE）可以直接与 Deno 进行交互，以突出显示语法，进行类型检查，格式化等 —— 期望下一次的编辑体验会大大改善几个月。我们正在努力通过尽可能多的 Web 平台测试 —— 因此，随着时间的推移，Deno 会变得与 Web 更加兼容。请查看 Q1 路线图，以了解更多详细信息。

**Evrone：** 我们的经典时空旅行问题：如果时光可以倒流，让你给刚开始开发 Node.js 的年轻的自己一个建议，那将是什么建议？

**Ryan：** 在 Node 的早期，我不太确定异步 IO 是否可以由新手程序员轻松地用于大型项目中。我四处演讲，提出了这一主张，但我不确定如何解决。如果我能回到过去，我会向自己保证它将起作用。我也会告诉自己，Node 将成为软件的关键部分，大型软件项目与小型项目相比需要不同的关注点：预算、沟通、组织。我会告诉自己要花更多的时间在这些元问题上。

**Evrone：** 对于想要通过 npm 软件包支持 Deno 的开发人员有何建议？

**Ryan：** 使用 ES 模块，并查看我们的 Node 兼容性层。

## 小结

我们很高兴能与 Ryan 对话，进一步地了解他的生活、想法和计划。在 Evrone，我们经常使用 Node.js 为客户构建自定义解决方案。感谢你的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
