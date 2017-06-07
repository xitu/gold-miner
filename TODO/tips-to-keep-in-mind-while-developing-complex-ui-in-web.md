> * 原文地址：[How to build complex user interfaces without going completely insane](https://medium.freecodecamp.com/3-tips-to-keep-in-mind-while-developing-complex-ui-in-web-b56312310390)
> * 原文作者：[Illia Kolodiazhnyi](https://medium.freecodecamp.com/@iktash88)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Changkun Ou](https://github.com/changkun/)
> * 校对者：[MuYunyun](https://github.com/MuYunyun), [noturnot](https://github.com/noturnot)

# 如何理智地构建复杂用户界面 #

![](https://cdn-images-1.medium.com/max/2000/1*jwBhYQ_c_HZ_OOCE4pwbwQ.jpeg)

我最近在构建一个复杂、动态的 Web 应用的用户界面（UI）。在这条路上，我学到了一些宝贵的经验教训。

下面的这些技巧是我希望有人在当我开始这样一个雄心勃勃的项目之前能告诉我的。这将为我节省大量时间和精力。

### 理智意见 #1: 使用组件的内部状态存储临时数据 ###

复杂的 UI 通常需要你维护某种应用程序状态。这将告诉 UI 显示什么内容以及如何显示它们。 一个选择是当用户触发页面里的某个行为的时候，立即访问这个状态。然而据我了解，推迟改变这个应用的状态，在当前组件的内部状态下临时保存此更改会更好。

举个例子，有一个对话框能够让用户编辑某些记录数据，比如他（她）的名字：

![](https://cdn-images-1.medium.com/max/800/1*bFb-8Zdzf1aGPJyWpD_hsg.jpeg)

这时，你可能想要让用户每次编辑这个对话框时触发修改。但是，我的建议是使用显示所有数据来维护此对话框的内部状态，直到用户按下保存按钮。 此时，您可以安全地更改保存这些记录数据的应用程序状态。

这样，如果用户决定放弃更改并关闭对话窗口，则可以直接删除组件，这时应用程序状态保持不变。 如果你需要将数据发送到后端，便可以在一个请求中进行。 如果这些数据对其他用户同时可用，那么当有人编辑这些数据时其他人不会看到这些临时值。

> 你的 UI 行为应该匹配用户的心理模型

当用户使用对话框时，他们通常会认为这些记录在完成编辑之前是不会被保存的。组件的功能也应该匹配这种行为。

**使用 React/Redux 的人请注意**：将一般数据保存在 Redux Store 并使用 React 组件状态来存储这些临时数据的行为是可行的。

### 理智意见 #2: 从 UI 状态中分离模型数据 ###

**下文中的术语「模型」指代 MVC 设计模式中的模型。**

Web 应用程序中的现代 UI 在结构和行为上可能很复杂。这通常会导致你将纯粹的与 UI 相关的数据存储在应用程序状态之中。我的建议是将 UI 相关数据和业务数据分离。

> 将 UI 状态中的业务数据和逻辑分别存储在不同模型之中

这种方法很容易遵循和理解，因为它想让你把业务逻辑与其他一切分离开来。这样你的模型可以同时保存这些数据和方法（函数）进而处理这些数据。 否则，你的应用程序可能最终会跨越多个地方穿插业务逻辑，其中最有可能是 **View** 组件。

例如，在应用程序中，你有一个待办事宜的列表，并实现一个页面来添加一个新的任务到该列表。 现在你需要在任务描述、任务日期的格式合法之前，禁用「保存」按钮：

![](https://cdn-images-1.medium.com/max/800/1*Cqmpew82Wo_znz_lCYz3xQ.jpeg)

普通的做法是是将需要的数据存储在应用程序状态的某处，并在 **View** 组件中编写这样的代码：`const saveButtonDisabled = !description && !date && !dateIsValid(date)`。 但问题就出在保存按钮被禁用了，因为**业务要求**必须输入所有的描述以及有效的日期。

因此，在这种情况下，禁用按钮的逻辑应该放在待执行任务的**模型**中。 该模型可以如下表示：

```
{
    description: 'Save Gotham',
    date: 'NOW',
    notes: 'Speak with deep voice',
    dateIsValid: () => this.date === 'NOW',
    isValid: () => this.description !== '' && this.dateIsValid()
}
```

现在，你可以在 **View** 组件中为你的 UI 逻辑使用 `const saveButtonDisabled = !task.isValid()` 了。

正如你所看到的，这个提示基本上是关于如何将你的**模型**与MVC模式中的**视图**进行分离。

### 理智意见 #3: 优先考虑集成测试而不是单元测试 ###

如果你在一个有足够的时间为每个功能编写多个测试的环境中工作，这将不是问题。但我相信，大多数人并非如此。通常，你必须决定使用哪种测试。**而我大多数时候会考虑集成测试，它比单元测试更有价值。**

![](https://cdn-images-1.medium.com/max/800/1*dsj6MNERxdJtcr5-I7W2vQ.jpeg)

依我的经验，我了解到：具有良好单元测试覆盖率的代码库通常比具有良好集成测试覆盖率的代码更容易出错。我注意到开发工作引入的大多数错误都是[软件回归错误 (regression bug)](https://en.wikipedia.org/wiki/Software_regression)。 单元测试通常不能很好地捕捉到这些问题。

当你在代码中修复问题时，我建议您按照以下简单步骤操作：

1. 写出由于现有问题而导致失败的测试。如果可以通过单元测试完成，这很好。否则，使测试根据需要接触许多代码模块。
2. 在代码库中解决问题。
3. 验证测试不会失败。

这个简单的做法确保问题是固定且不会再发生的，因为从此之后测试将验证它。

现代 Web 应用程序对开发人员提出了许多挑战，UI 开发也是其中之一。 我希望本文可以帮助你避免一些错误，或者给你提供一个很好的话题来进一步思考和讨论。

如果能在评论中看到你对此话题的想法和发现，我将非常感激。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
