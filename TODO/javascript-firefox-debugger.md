> * 原文地址：[Debugging JavaScript With A Real Debugger You Did Not Know You Already Have](https://www.smashingmagazine.com/2018/02/javascript-firefox-debugger/)
> * 原文作者：[Dustin Driver](https://www.smashingmagazine.com/author/dustindriver-jasonlaster)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/javascript-firefox-debugger.md](https://github.com/xitu/gold-miner/blob/master/TODO/javascript-firefox-debugger.md)
> * 译者：[Serendipity96](https://github.com/Serendipity96)
> * 校对者：[ZhiyuanSun](https://github.com/ZhiyuanSun)，[noahziheng](https://github.com/noahziheng)

# 来试试这个真正的 JavaScript 调试器吧！

`console.log` 可以告诉你很多关于应用程序的信息，但它不能真正调试你的代码。因此，你需要一个完整的 JavaScript 调试器。新的 Firefox JavaScript 调试器能够帮你写快速且无缺陷的代码。下面来介绍它的用法。

在这个例子中，我们将用 Debugger 打开一个非常简单的应用程序。此[应用程序](https://mozilladevelopers.github.io/sample-todo/01-variables/)是基于一个基础的 JavaScript 开源框架开发的。在最新版本的[Firefox Developer Edition](https://www.mozilla.org/firefox/developer/)中打开此程序，Mac系统按 `Option` + `Cmd` + `S` 或者 Windows系统按 `Shift` + `Ctrl` + `S` 启动 `debugger.html`。调试器共分为三个窗格：源列表窗格，源代码窗格和工具窗格。

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_2000/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dd605d5c-e94d-43e3-a7ef-94eea52cff9e/image2.png)

[大图预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dd605d5c-e94d-43e3-a7ef-94eea52cff9e/image2.png)

工具窗格进一步分为工具栏，监视表达式，断点，调用堆栈和范围。

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2b99b781-28e8-4bff-a5ff-d1ee43c2d432/image3.png)

[大图预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2b99b781-28e8-4bff-a5ff-d1ee43c2d432/image3.png)

### 停止使用 `console.log`

使用 `console.log` 来调试代码是很诱人的。你只需在代码中添加一句 `console.log` ，然后执行即可找到变量的值，对不对？这确实可以奏效，它可能是麻烦且费时的。在这个例子中，我们将使用 `debugger.html` 单步执行这个待办事项应用的代码来查找变量的值。

我们在 `debugger.html` 的一行代码中添加一个断点，来深入了解待办事项应用程序。断点告诉调试器在这一行上暂停，这样你可以点击代码来看看发生了什么。在这个例子中，我们在 app.js 文件的第 13 行添加一个断点。

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a3633871-65f2-4815-9270-2b5e19b316f4/image5.gif)

[大图预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a3633871-65f2-4815-9270-2b5e19b316f4/image5.gif)

现在添加一个任务到列表中。代码将会暂停到 addTodo 函数，我们可以深入代码来查看输入的值等。将鼠标悬停在变量上可以看到更多信息。你可以看到锚点和子程序等各种信息：

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5f23c4d0-5b4d-41ff-9367-e534d0f96168/image4.png)

[大图预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5f23c4d0-5b4d-41ff-9367-e534d0f96168/image4.png)

你也可以进入 Scopes 面板获取相同的信息。

现在脚本已经暂停，我们可以使用工具栏来逐步调试。开始/暂停按钮正如工具栏上所显示的含义，" Step Over " 跨越当前代码行，" Step In " 步入函数调用，" Step Out " 运行脚本，直到当前函数退出。

![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2c04dd57-b4b4-42c7-be87-685a71c8df56/image1.png)

[大图预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2c04dd57-b4b4-42c7-be87-685a71c8df56/image1.png)

我们也可以使用监视表达式来跟踪变量的值。只需在监视表达式字段中输入一个表达式，调试器将在你逐步执行代码时进行跟踪。在上面的例子中，你可以添加表达式 " title "和 " to-do "，当它们被调用时，调试器会显示它们的值。以下情况特别有用：

* 你正单步执行并想看变量值的变化；
* 你正多次调试同样的东西，并希望看到相同的变量值；
* 你想弄清楚为什么那个该死的按钮不起作用。

你也可以用 `debugger.html` 去调试 React / Redux 应用程序。以下是使用步骤：

* 跳转到你要调试的组件。
* 参阅左侧的组件大纲（类中的函数）。
* 添加断点到相关的函数中。
* 暂停并查看组件 props 和 state。
* 调用堆栈是已经被简化的，这便于你查看应用程序代码和框架的交集。

最后，`debugger.html` 让你看到可能引起错误的混淆或压缩的代码，这在处理像 React / Redux 这样的通用框架时特别有用。调试器知道你已暂停的组件，并显示简化的堆栈调用，组件大纲和属性。以下是开发人员 Amit Zur 在 [JS Kongress](https://2017.js-kongress.de/) 上描述他是如何使用 Firefox 调试器调试代码的：

<iframe width="841" height="400" src="https://www.youtube.com/embed/Rop3EgPvBMw" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

如果你在新的 `debugger.html` 中对深入代码走查感兴趣，请转到[Mozilla Developer Playground](https://mozilladevelopers.github.io/playground/debugger)。我们构建了一个系列教程，帮助开发人员学习如何有效地使用该工具来调试代码。

### 开源的开发工具

[`debugger.html` project](https://github.com/devtools-html/debugger.html)大约于两年前推出，同时对所有 Firefox DevTools 进行了全面改进。我们希望使用现代网络技术重建 DevTools，并对全世界的开发者开放。当一项技术开放的时候，能够自由扩展到我们 Mozilla 小团队所能想象的范围之外的任何地方。

JavaScript对于任何高级 Web 应用程序都是必不可少的，所以强大的调试器是工具集的关键部分。我们希望构建一些快速，易于使用且适应性强 —— 能够调试未来可能出现的任何新 JavaScript 框架的产品。我们决定使用流行的网络技术，因为我们想与社区紧密合作。这种方法也将改善调试器本身 —— 如果我们采用了 WebPack 并开始在内部使用构建工具和 Source Map，我们希望改进 Source Map 生成和热加载。

`debugger.html` 是用 React，Redux 和 Babel 构建的。React 组件轻量，可测试又易于设计。我们使用 React Storybook 进行快速的 UI 原型设计和记录共享组件。我们的组件使用 Jest 和 Enzyme 进行测试，这使得在 UI 上迭代更容易。这让使用各种 JavaScript 框架（如 React ）更容易。Babel 前端能让我们做一些像显示左侧边栏中 Component 类和它功能的事情。我们也可以做一些很酷的事情，例如把断点固定到函数中，当你改变你的代码时，它们不会移动。

Redux Action 对于 UI 来说是一个简单的 API，但它也可以很容易地构建一个独立的 CLI JS 调试器。Redux Store 有查询当前调试状态的选择器。我们的 Reduce 单元测试激发了 Redux Action 并模拟浏览器响应。我们的集成测试使用调试器 Redux Action 来驱动浏览器。功能架构本身被设计为可测试的。

我们每一步都依靠 Mozilla 开发人员社区。该项目在 [GitHub](https://github.com/devtools-html/debugger.html)  上发布，我们的团队联系世界各地的开发人员向他们寻求帮助。当我们开始时，自动化测试是社区发展的重要组成部分，测试可以预防性能退化，也能很好地记录容易遗漏的行为。这就是为什么我们采取的第一步是为 Redux Store 添加 Redux Action 和 Flow 类型的单元测试。事实上，社区确保我们的 Flow 和 Jest 覆盖率有助于确保每个文件都被打印和测试。

作为开发者，我们相信工具越强，参与的人越多。我们的核心团队一直很小（2 人），但我们平均每周有 15 个贡献者。社区带来了多样的视角，帮助我们预测挑战并创造了我们从未想到的功能。我们现在整理了 24 个不同库的调用堆栈，其中有许多我们从未听说过。我们还在源代码树中显示 WebPack 和 Angular 映射。

我们计划将所有的 Firefox DevTools 移到 GitHub 上，以便更广泛的受众使用和改进它们。我们很乐意为您做出贡献。转到 [`debugger.html`](https://github.com/devtools-html/debugger.html) 的 GitHub 项目页面。我们已经创建了一个关于如何在自己的机器上运行调试器的完整的指令列表，在列表里你可以修改使它做任何你想做的事。使用它来调试任何 JavaScript 代码 —— 浏览器，终端，服务器，手机，机器人。如果您有改进的方法，请通过 GitHub 告诉我们。

**您可以在[这里](https://www.mozilla.org/firefox)下载最新版本的 Firefox（和 DevTools）。**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
