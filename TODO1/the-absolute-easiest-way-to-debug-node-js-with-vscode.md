> * 原文地址：[The Absolute Easiest Way to Debug Node.js — with VSCode](https://itnext.io/the-absolute-easiest-way-to-debug-node-js-with-vscode-2e02ef5b1bad)
> * 原文作者：[Paige Niedringhaus](https://medium.com/@paigen11)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-absolute-easiest-way-to-debug-node-js-with-vscode.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-absolute-easiest-way-to-debug-node-js-with-vscode.md)
> * 译者：
> * 校对者：

# 使用 VS Code 调试 Node.js 的超简单方法

> 让我们面对现实吧……调试 Node.js 一直是我们心中的痛。

![](https://cdn-images-1.medium.com/max/2000/1*9bDq6pyYoXa39QxldAkf-g.jpeg)

### 触达调试 Node.js 的痛点

如果你曾经有幸为 Node.js 项目编写代码，那么当我说调试它以找到出错的地方并不是最简单的事情时，你就知道我在谈论什么。

不像浏览器中的 JavaScript，也不像有类似 IntellJ 这样强大的 IDE 的 Java，你无法到处设置断点，刷新页面或者重启编译器，也无法慢慢审阅代码、检查对象、评估函数、查找变异或者遗漏的变量等。你无法那样去做，这真的很臭（译者注：这里实在无力翻译，自己领会吧😂）。

但 Node.js 也是可以被调试的，只是需要多花费一些肘部的油脂（译者注：这里指会多费些体力）。让我们跳过这些可选项，我会展示给你在我开发经历中遇到的最简单调试方法。

### Options to Debug in Node.js

There’s a number of ways to debug your misbehaving Node.js program, I’ve listed them out below with links to learn more if you so desire.

* **`Console.log()`** — the tried and true standby, this one really needs no further explanation if you’ve ever written a line of JavaScript. It’s built in to Node.js and prints in the terminal just like it’s built into JavaScript and prints in the browser’s console.

In Java, it’s `System.out.println()` in Python, it’s `print()`, you get the idea. This is the easiest one to implement, and it’s the fastest way to litter your clean code with extra lines of info — but it can also (sometimes) help you find and fix the error.

* **Node.js documentation `—-inspect`** — The Node.js docs themselves understand debugging isn’t the easiest, so they’ve made a [handy reference](https://nodejs.org/en/docs/guides/debugging-getting-started/) to help get people started.

It’s useful, but honestly, unless you’ve been programming for a while, it’s not exactly the easiest thing to decipher. They pretty quickly go down the rabbit hole of UUIDs, WebSockets, and security implications and I start to feel in over my head. And thinking to myself: there’s got to be a less complex way to do this.

* **Chrome DevTools** — [Paul Irish](undefined) wrote a great [blog post](https://medium.com/@paul_irish/debugging-node-js-nightlies-with-chrome-devtools-7c4a1b95ae27) back in 2016 (updated in 2018) about debugging Node.js using Chrome DevTools, and from the looks of things it sounded pretty simple, and like a great step forward for debugging.

Fast forward half an hour, and I still hadn’t managed to connect a DevTools window to my simple Node program and I wasn’t so sure anymore. Maybe I just can’t follow directions, but Chrome DevTools seems to make it more complicated to debug than it should be.

* **JetBrains** — one of my very favorite software development companies and makers of IntelliJ and WebStorm to name just a few IDEs, JetBrains is great. They’ve got a fantastic ecosystem of plugins for their tools and until recently, they were my go-to IDE without question.

With such a dedicated user base came lots of helpful articles like [this](https://www.jetbrains.com/help/webstorm/running-and-debugging-node-js.html), which walk through debugging Node, but similar to the Node documentation and the Chrome DevTools options, it’s not easy. You have to create a debugging configuration, attach running processes and do a good bit of configuration in the preferences before WebStorm is ready to go.

* **Visual Studio Code** — this is my new gold standard for Node debugging. I never thought I’d say it, but I am all in on [VS Code](https://code.visualstudio.com/download), and every new feature release the team does, makes me love this IDE more.

VS Code does what every other option for [debugging Node.js](https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_attaching-to-nodejs) fails to do, it makes it stupid simple. If you want to get fancier with your debugging you absolutely can, but they break it down to make it simple enough anyone can get up and running quickly, regardless of how familiar you are with IDEs, Node, programming, etc. And it’s awesome.

### Setting up VS Code To Debug in Node.js

![](https://cdn-images-1.medium.com/max/2000/1*8YEmou3F1ymiHrlNgVqHgQ.jpeg)

Sorry, I couldn’t resist this meme — it’s just so appropriate. Ok, so let’s walk through setting up VS Code to debug Node. I’ll assume you’ve already downloaded VS Code from the [link](https://code.visualstudio.com/download) I posted above, so we’re ready to start setting it up.

Open up **Preferences > Settings** and in the search box type in “node debug”. Under the Extensions tab there should be one extension titled “Node debug”. From here, click the first box: **Debug > Node: Auto Attach** and set the drop down to “on”. You’re almost ready to go now. Yes, it really is that easy.

![Here’s what you should see under the Settings tab. Set the first drop down ‘Debug > Node: Auto Attach’ to ‘on’.](https://cdn-images-1.medium.com/max/4584/1*rUzpJjNxAsLTZUMfvrVh1A.png)

Now, go to your Node.js project file, and set some breakpoints by clicking on the left hand side of the file wherever you’d like to see your code stop, and in the terminal type `node --inspect <FILE NAME>`. Now watch the magic happen…

![See the red breakpoints? See the `node — inspect readFileStream.js` in the terminal? That’s it.](https://cdn-images-1.medium.com/max/4276/1*ogcXellTrcU3SIv5ALLUHA.png)

**VS Code Debugging in Action**

If you need a Node.js project to test this out with, you can download my repo [here](https://github.com/paigen11/file-read-challenge). It was made to test different forms of streaming large amounts of data with Node, but it works really well for this demo. If you’d like to see more about streaming data with Node and performance optimization, you can see my posts [here](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33) and [here](https://itnext.io/streams-for-the-win-a-performance-comparison-of-nodejs-methods-for-reading-large-datasets-pt-2-bcfa732fa40e).

Once you hit `Enter`, your VS Code terminal should turn orange at the bottom to indicate you’re in debug mode and your console will print some message along the lines of `‘Debugger Attached’`.

![The orange toolbar and `Debugger attached’ message will tell you VS Code is running correctly in debug mode.](https://cdn-images-1.medium.com/max/4944/1*aNFXCnEf2j5lCp5ZAPC8DQ.png)

当你看到这一幕发生时，恭喜你，你已经让 Node.js 运行在调试模式下啦！

至此，你可以在屏幕的左下角看到你设置的断点（而且你可以通过复选框切换这些断点的启用状态），
Now, you can see your breakpoints in the bottom left corner of the screen (and can toggle them on and off with the checkboxes), and you can step through the code just like you would in a browser with the little play, step over, step in, restart, etc. buttons at the top center of the IDE. VS Code even highlights the breakpoint and line you’ve stopped on with yellow, making it easier to follow along.

![Hit the play button at the top to step from one break point to the next one in your code.](https://cdn-images-1.medium.com/max/4976/1*_rTrxs5eBDQXy-ajquNVRQ.png)

As you step from breakpoint to breakpoint, you can see the program printing out the `console.log`s in the debug console at the bottom of the VS Code IDE and the yellow highlighting will travel with you, as well.
![如你所见，当我们暂停在断点上时，我们可以在 VS Code 的左上角看到可以在控制台中探索到的所有局部作用域信息。](https://cdn-images-1.medium.com/max/4580/1*JFrOtthKOstqNFgT75PaCw.png)

As you can see, as I progress through the program, more prints out to the debug console the further through the breakpoints I go, and along the way, I can explore the objects and functions in the local scope using the tools in the upper left hand corner of VS Code, just like I can explore scope and objects in the browser. Nice!

这很简单，对吧？

### 总结

Node.js debugging doesn’t have to be the headache it was in the past, and it doesn’t need to involve 500 `console.log()`s in the codebase to figure out where the bug is.

Visual Studio Code’s Debug > Node: Auto Attach setting makes that a thing of the past, and I, for one, am so thankful.

Check back in a few weeks, I’ll be writing about end-to-end testing with Puppeteer and headless Chrome or using Nodemailer to reset passwords in a MERN application, so please follow me so you don’t miss out.

Thanks for reading, I hope this gives you an idea of how to more easily and effectively debug your Node.js programs with a little assistance from VS Code. Claps and shares are very much appreciated!

**If you enjoyed reading this, you may also enjoy some of my other blogs:**

* [使用 Node.js 读取超大数据集和文件（第一部分）](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33)
* [Sequelize: The ORM for Sequel Databases with Node.js](https://medium.com/@paigen11/sequelize-the-orm-for-sql-databases-with-nodejs-daa7c6d5aca3)
* [Streams For the Win: A Performance Comparison of Node.js Methods for Reading Large Datasets (Pt 2)](https://itnext.io/streams-for-the-win-a-performance-comparison-of-nodejs-methods-for-reading-large-datasets-pt-2-bcfa732fa40e)

***

**参考资料和进阶资源：**

* Github, Node Read File Repo: [https://github.com/paigen11/file-read-challenge](https://github.com/paigen11/file-read-challenge)
* Node.js documentation — inspector: [https://nodejs.org/en/docs/guides/debugging-getting-started/](https://nodejs.org/en/docs/guides/debugging-getting-started/)
* Paul Irish’s Blog on Using Chrome DevTools to Debug Node.js: [https://medium.com/@paul_irish/debugging-node-js-nightlies-with-chrome-devtools-7c4a1b95ae27](https://medium.com/@paul_irish/debugging-node-js-nightlies-with-chrome-devtools-7c4a1b95ae27)
* JetBrains 提供的文档 — 《运行和调试 Node.js》 — [https://www.jetbrains.com/help/webstorm/running-and-debugging-node-js.html](https://www.jetbrains.com/help/webstorm/running-and-debugging-node-js.html)
* Visual Studio Code 下载链接：[https://code.visualstudio.com/download](https://code.visualstudio.com/download)
* VS Code 调试 Node.js 文档：[https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_attaching-to-nodejs](https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_attaching-to-nodejs)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
