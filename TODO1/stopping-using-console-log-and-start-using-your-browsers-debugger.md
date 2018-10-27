> * 原文地址：[How to stop using console.log() and start using your browser’s debugger](https://medium.com/datadriveninvestor/stopping-using-console-log-and-start-using-your-browsers-debugger-62bc893d93ff)
> * 原文作者：[Parag Zaveri](https://medium.com/@parag.g.zaveri?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/stopping-using-console-log-and-start-using-your-browsers-debugger.md](https://github.com/xitu/gold-miner/blob/master/TODO1/stopping-using-console-log-and-start-using-your-browsers-debugger.md)
> * 译者：
> * 校对者：

# 如何停止使用 console.log() 并开始使用浏览器调试代码

在我开始软件开发者之旅时，我在这条路上遇到了很多颠簸。大多数新人要面对的最常见的困难之一就是调试代码。 起初， 当我意识到我可以打开 Chrome 浏览器的控制台，并且通过使用 console.log() 输出变量值找到 bug 在哪的时候，我觉得我发现了圣杯。但是使用这个方法调试代码结果是非常地无效率。出于幽默, 这里列举了一些我喜欢使用的例子：

console.log(‘Total Price:’, total) //为了看值是否已经被变量存储了 

console.log(‘Here’) //程序是否执行到某一个确切的函数

我认为大多数开发者开始意识到用这个办法去调试你的程序是不大行得通。这儿有更好的方法去调试你的程序！

令人万分感谢的方法是使用你的浏览器调试工具。我将会在下文单独详细介绍 Chrome 的开发者工具。

在本篇文章中，我会提到以下内容：在 Chrome 开发者工具中使用断点、跟踪代码、设置监测表达式和应用修复程序。

> **为了能够跟上我的对  Chrome 开发者工具的介绍，你需要使用我创建的一个简单的例子。** [**点击链接**](https://chromedevtoolsdemo.herokuapp.com/)**(可能会花一点时间加载它)**

### Step 1: 重现 Bug

我们通过执行一系列的操作开始重现 bug。

1.  在这个案例中，我们将使用一个轻便的小费计算器重现 bug。如果你还没有打开这个例子的链接。 请点击[**这里。**](https://chromedevtoolsdemo.herokuapp.com/)
2.  在‘Entree 1’中输入 12
3.  在‘Entree 2’中输入 8
4.  在‘Entree 3’中输入10
5.  在‘Tax’中输入 10
6.  ‘Tip’选择 20%
7.  点击 `Calculate Bill`。计算得到的 Total Plus Tip 应该是 36.3（译者注：此处我去看过作者原博客了，这篇博客之前计算结果有问题，后来作者修改了代码，真正的结果是36.3，所以结果和图片的结果是不一样的），然而我们得到了一个差别很大的结果。呀！结果居然显示的是 15500.1。

![](https://cdn-images-1.medium.com/max/800/1*r-TVPOq2bvKB1clw9vgCHg.png)

### Step 2: 学习使用 Sources 面板

为了在 Chrome 浏览器中调试代码，你需要习惯使用开发者工具。你可以按快捷键 Command+Option+I（Mac）和 Control+Shift+I（Linux）打开 Chrome 开发者工具。

![](https://cdn-images-1.medium.com/max/800/1*t3SETtaOVas1trQfjRO4gw.png)

在点击开发者工具顶部的 sources 面板之后，你应该使用出现的这三个面板来调试代码：文件导航栏、源码编辑器和调试窗口。你可以在开始 Step 3 之前任意点击这些面板。

### Step 3: 设置你的第一个断点

在向你展示如何设置你的第一个断点之前，让我先展示我说的使用 console.log() 函数调试代码是什么意思。很清楚的是，当我们的程序在运行的时候，在计算 subtotal 的时候做了一些事情。其中我们可以按如下操作调试程序：

![](https://cdn-images-1.medium.com/max/800/1*ZLrHNgLfA0_ImUT-bjiN-w.png)

幸运的是用这个方法不再需要使用浏览器开发者工具。但我们能通过简单地设置一个断点并且跟踪代码而用浏览器发现设置的所有值。

让我们谈论如何设置一个断点吧！断点是为了让浏览器知道什么时候暂停运行并且可以让你有机会去调试代码。

为了我们能够调试代码，我们在程序运行开始之前通过设置一个鼠标事件来设置断点。

> 在调试窗口的最下面有个“Event Listener Breakpoints”。打开它，并且在展开的列表中打开“Mouse”列表，选择'click'。

现在当你点击 `Calculate Bill` 按钮后，调试器将在第一个绑定了“onClick()”的函数的第一行代码的位置暂停执行。如果调试器在任何其他地方，点击 Calculate Bill 按钮后调试器都会跳到该位置。

### Step 4:跟踪你的代码

在所有的调试工具中，用户可以使用导航栏的两个选项通过运行中的代码。用户可以选择“进入”或者“跳过”下一个函数回调。

进入，意味着能够依次进入每一行代码调用的每一个函数。

![](https://cdn-images-1.medium.com/max/800/1*HaePgs1Jyqw1L-wcCiQk0A.png)

图示为进入下一个函数回调的按钮。

跳过，意味着跳出已知正在运行的整个的函数。

![](https://cdn-images-1.medium.com/max/800/1*07byHc3enj1vgrapehg4Bg.png)

图示为跳过下一个函数回调的按钮。

这儿有一个跟踪代码的例子。在调试窗口的 Scope 标签下，我起初设置的三个 entree 的值都被列出来了。 

![](https://cdn-images-1.medium.com/max/800/1*EfVOw-IfVMScANFDGn92mw.png)

### Step 5:设置代码行的断点 

哇哦！能够跟踪你的代码真是令人大吃一惊，但是有一点麻烦对吧？一般情况下，我只想知道在确切的地方的变量值是多少。解决这个问题的更好的办法就是设置代码行的断点。

> **作者注**: 设置代码行的断点就是我为什么用 Chrome 开发者工具取代使用 console.log() 函数调试代码的原因。

为了设置代码行的断点，只需要简单地点击代码的行数，然后你就可以看到更多关于该行代码的信息。之后你可以像往常一样跑起你的代码，调试器将会在你设置代码行断点的地方停下来跟踪或者跳过每一个函数。

**标注:如果你遇到了麻烦，请确认你已经取消了在前面已经选择的鼠标的  click 事件**

![](https://cdn-images-1.medium.com/max/800/1*boS5jNmWpJQMc4o5VHReWA.png)

正如你看见的那样，显示得到 subtotal 的值是“10812”。在代码被执行到所有 entree 变量的时候，设置的 entree 的值也在 scope 标签下被列了出来 。

嗯······我认为我已经向你指出了 bug。字符串连接了所有的变量?

让我们设置监测表达式来确认这个想法吧！

### Step 6: 创建监测表达式

到目前我们已经很明确地知道了这些 entree 变量并没有被正确地加起来，让我们在每一个 entree 变量上都设置监测表达式。

一个监测表达式能提供更多关于代码中的变量或者表达式的信息。

> 为了’监测‘被声明的值， 请点击在调试窗口顶部的 watch 标签，然后在打开的面板中点击 + 号。你可以在这里写下变量名或者其他的表达式。

通过下面这个 demo，我将监测第一个 entree 的值并且使用 type of 来发现 entree 变量的类型。

![](https://cdn-images-1.medium.com/max/800/1*kQDNWSdmUhXrpFyOaY9vHA.png)

啊哈！我觉得我已经发现了问题。问题出在了我定义的第一个 entree 变量存储了 string 类型的值。这个问题似乎来自于我是如何得到这个值的。querySelector() 或许是罪魁祸首。其他的几个变量值可能也收到了影响。让我们移步到在开发者工具中修改代码进一步调试吧！

### Step 7: Fix Your Code

让我们回到代码中， querySelector() 一定是罪魁祸首!

![](https://cdn-images-1.medium.com/max/800/1*Bg6oJPpIZKnBywUG3U_l1w.png)

所以我们应该如何修改它呢？我们可以强制将 string 转换成 number 类型。例如，在74行将代码改成Number(getEntree1())。

> 为了能够实际编辑代码，你将需要到’sources‘面板左边的’elements‘面板下。如果你不能看到 javascript 代码，你需要展开 script 标签。在这里点击鼠标右键并选择’edit as html‘。

![](https://cdn-images-1.medium.com/max/800/1*NPHg0e_aRlVkNYEbQQCITw.png)

你过你正在使用 workspace，可以很方便地保存代码并马上看到效果。如果不是的话，你需要使用 command+s (mac) 或者 control+s (linux) 保存这个 web 页面的本地副本。

至此，你可以打开本地副本并查看修改后的变化。

![](https://cdn-images-1.medium.com/max/800/1*WPiRbg5uZXh11NCxr1U_2A.png)

瞧！

* * *

> 这个由 Kayce Basques 在 [Get Started with Debugging Javascript in Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools/javascript/) 描述的调试方法已经被收录在 developers.google.com 了。
>
> Demo Code: [https://github.com/paragzaveri/chromeDevTools](https://github.com/paragzaveri/chromeDevTools)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
