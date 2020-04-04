> - 原文地址：[A RealWorld Comparison of Front-End Frameworks 2020](https://medium.com/dailyjs/a-realworld-comparison-of-front-end-frameworks-2020-4e50655fe4c1)
> - 原文作者：[Jacek Schae](https://medium.com/@jacekschae)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-realworld-comparison-of-front-end-frameworks-2020.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-realworld-comparison-of-front-end-frameworks-2020.md)
> - 译者：[snowyYU](https://github.com/snowyYU)
> - 校对者：[Baddyo](https://github.com/Baddyo)、[IAMSHENSH](https://github.com/IAMSHENSH)

# 2020 年用各大前端框架构建的 RealWorld 应用对比

![](https://cdn-images-1.medium.com/max/8556/1*EM48X61Wygrlqq1BR0kU6Q.png)

来了来了，本篇写于 2020 年，往年的版本请看这里：[2019](https://medium.com/free-code-camp/a-realworld-comparison-of-front-end-frameworks-with-benchmarks-2019-update-4be0d3c78075)、[2018](https://medium.com/free-code-camp/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-2018-update-e5760fb4a962) 和 [2017](https://medium.com/free-code-camp/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-e1cb62fd526c)。

**首先，请务必明白 —— 本篇不是告诉你应该选择哪种作为你未来的前端框架，在此只简短浅显的对比三个方面：各 RealWorld 应用的性能，大小、代码行数。**

请记住哦，好了，让我们开始吧：

**我们对比 RealWorld 应用** —— 相较“to do”类型的应用，它的功能更加强大。通常来说，“to-dos”并不能说明各框架在实际应用中的表现情况。

**项目有一定的规范** —— 一个符合特定规则的项目 —— [相关规范在此](https://github.com/gothinkster/realworld/tree/master/spec)。提供了后端 API，静态 html 模版和样式。

**项目的构建和检查都是由相关技术的大牛完成的** —— 一般来说，相关框架的技术大牛会构建并检查自己 real-world 项目，确保其和别的项目的一致性。

## 我们正在比较哪些库 / 框架？

截至撰写本文时，[RealWorld 仓库](https://github.com/gothinkster/realworld) 中已有 24 个相关实现。也许有受众更多的框架没有出现在这里。但进行对比的前提只有一个 —— 它必须出现在 [RealWorld 仓库](https://github.com/gothinkster/realworld) 页面里。

![](https://cdn-images-1.medium.com/max/5892/1*hztR7Zs5pFMvAaaqnGGBAA.png)

## 我们关注什么指标？

**性能** —— 此应用需要多长时间才能显示内容并变得可用。

**大小** —— 应用有多大的体积？我们只会比较编译后的 JavaScript 文件大小。HTML 和 CSS 对所有的 RealWorld 应用都是通用的，并且都可从 CDN 下载。此外，所有技术均可编译或转换为 JavaScript，综上，我们只比较编译后的 JavaScript 文件大小。

**代码行数** —— 开发者需要多少行代码才能根据规范创建 RealWorld 应用？公平来说，有些应用有更多的功能，但这应该没啥大的影响。我们只看 `src/` 文件夹中各文件的代码行数。即使它是自动生成的也可以 —— 你仍需要持续维护它。

---

## 指标 #1：性能

我们使用 Chrome 的拓展插件 [Lighthouse Audit](https://developers.google.com/web/tools/lighthouse/) 来给各个项目的性能评分。Lighthouse 会给出一个范围在 0 到 100 的分数。0 是最低分。想了解更多，请戳 [Lighthouse 评分指南](https://developers.google.com/web/tools/lighthouse/v3/scoring)。

#### 插件相关的配置

![适用所有测试应用的 Lighthouse Audit 设置](https://cdn-images-1.medium.com/max/5440/1*0B_8wqM-vS597MOtGaDWvQ.png)

#### 基本原则

渲染的越快，用户就能越早地使用该应用，同样，用户的体验就越好。

![性能（分数 0–100）—— 分数越高越好。](https://cdn-images-1.medium.com/max/11192/1*-adYkKBH0YgvRYPp2gbs5Q.png)

#### 备注

**注意：由于缺少 demo 应用，这里忽略 PureScript。**

#### 总结

Lighthouse Audit 可没闲着。您可以看到未维护/未更新的应用程序跌破了 90 分。得分超过 90 分的应用在性能上差别不大。不得不说，AppRun、Elm 和 Svelte 表现的非常出色。

---

## 指标 #2：大小

需要加载的资源的大小可以从 Chrome 中开发者工具的 Network 标签中得出。服务器提供的 GZIP 响应头和响应主体。

这取决于框架的大小以及所添加的其他依赖包。同样，构建合适的打包工具可以忽略未使用的依赖。

#### 基本原则

文件越小，下载速度越快，并且需要解析的内容越少。

![加载资源的大小以 KB 为单位计算 —— 越小越好](https://cdn-images-1.medium.com/max/11176/1*6HK361f-UDqNpWuTA68jHw.png)

#### 备注

**注意：由于缺少 demo 应用，这里再次忽略 PureScript。**

**Angular + ngrx + nx 方案的支持者可别打我哟 —— 看一下 Chrome 开发者工具中的 Network 标签里的加载情况，如果我算错了 — 还请告知。**

**Rust + Yew + WebAssembly 方案的大小计算，包括了以 .wasm 结尾的文件。**

#### 总结

Svelte 和 Stencil 社区完成的 RealWorld 应用太棒了，把需要加载的文件控制在了 20KB 以内，可以说是前无古人了。

---

## 指标 #3：代码行数

我们使用 [cloc](https://github.com/AlDanial/cloc) 计算每个库的 src 文件夹中的代码行数。**不包含**空白行和注释。考量这个指标的意义何在呢？

> **如果说调试是消灭 bug 的过程, 那么编码则是产生它的过程 —— Edsger Dijkstra**

#### 基本原则

下面这张图展示了各个库/框架/语言实现的 RealWorld 应用的简洁程度。根据规范，他们各自写了多少行实现了几乎相同的应用程序（其中一些应用具有更多的功能）。

![# 代码行数 — 越少越好](https://cdn-images-1.medium.com/max/8752/1*RLnW6UBEFki9D_AjpDqb6g.png)

#### 备注

**由于 [cloc](https://github.com/AlDanial/cloc) 无法统计以 `.svelte` 为后缀的文件，因此 Svelte 在此不做对比。**

**由于 [cloc](https://github.com/AlDanial/cloc) 无法统计以 `.riot` 为后缀文件，因此 riotjs-effector-universal-hot 在此也不做对比。**

**Angular + ngrx: 以`/libs`文件夹为基础完成的代码行数统计仅包括以 `.ts` 和 `.html` 为后缀文件。如果你觉得不应该这样统计, 还望告知正确的代码行数以及你是如何统计它的。**

#### 总结

只有 Imba 和 [ClojureScript + re-frame](https://www.learnreframe.com/) 能在 1000 行代码以内实现 RealWorld 应用。Clojure 以独特的表现力而著称。Imba 第一次出现在这里（去年是因为 cloc 还不能识别以 .imba 为后缀的文件），看起来之后会一直出现在这里。如果你关心自己项目的代码行数，那么你现在知道该怎么做啦。

---

## 最后

请记住，这并不是一个公平、合理的比较。有些在应用的实现上使用了代码拆分，有些则没有。其中有些托管在 GitHub 上，有些托管在 Now 上，有些托管在 Netlify 上。你是否仍然想知道哪一个最好？这我可回答不了。

---

## 常见问题

#### #1 为什么在本篇对比中不包含框架 X，Y 和 Z 呢？

因为以该框架为基础构建的 RealWorld 应用尚未在 [RealWorld 仓库](https://github.com/gothinkster/realworld)上出现或按照规范构建完成。考虑做出你的贡献吧！选择你喜欢的库/框架然后来构建 RealWorld 应用吧，我们下次对比将包括它！

#### #2 为什么你们称其为 real world？

因为它不只是一个 To-Do 应用程序。通过 RealWorld 应用，我们并不是要比较相关技术能拿到的薪水，可维护性，生产力，学习曲线等方面。这有[其他调查](https://insights.stackoverflow.com/survey/2018/)回答了其中一些问题。我们所说的 RealWorld 是指连接到服务器，进行身份验证并允许用户进行 CRUD 操作的应用程序 —— 就像现实世界中的应用程序一样。

#### #3 你为什么不比较我最喜欢的框架？

请参见问题 1，但以防万一，这里还是想强调下：因为以该框架为基础构建的 RealWorld 应用尚未在 [RealWorld 仓库](https://github.com/gothinkster/realworld)上出现或按照规范构建完成。以上所有的 Real World 应用又不是我自己搞出来的-这是整个社区的努力结晶。如果你想在下次对比中看到你喜欢的框架，请考虑为本项目做出贡献吧。

#### #4 包括了哪个版本的库/框架？

所涉及的库/框架在撰写本文时（2020 年 3 月）均可用。该信息来自 [RealWorld 仓库](https://github.com/gothinkster/realworld)。我确定你可以在 [GitHub 仓库](https://github.com/gothinkster/realworld) 中找到相关信息。

#### #5 有比本文中出现的更流行的框架，你怎么忘记比较啦？

同样，请参阅问题 1 和问题 3。以该框架为基础构建的 RealWorld 应用尚未在 [RealWorld 仓库](https://github.com/gothinkster/realworld) 上出现或按照规范构建完成；原因就是这么简单。

> 如果你喜欢这篇文章，请 [在Twitter上关注我](https://twitter.com/JacekSchae)。我只写/推有关编程和技术的文章。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
