> * 原文地址：[The Absolute Easiest Way to Debug Node.js — with VSCode](https://itnext.io/the-absolute-easiest-way-to-debug-node-js-with-vscode-2e02ef5b1bad)
> * 原文作者：[Paige Niedringhaus](https://medium.com/@paigen11)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-absolute-easiest-way-to-debug-node-js-with-vscode.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-absolute-easiest-way-to-debug-node-js-with-vscode.md)
> * 译者：
> * 校对者：

# The Absolute Easiest Way to Debug Node.js — with VSCode

> Let’s face it…debugging Node.js is (and always has been) kind of a pain.

![](https://cdn-images-1.medium.com/max/2000/1*9bDq6pyYoXa39QxldAkf-g.jpeg)

### Enter the Pain of Debugging in Node.js

If you’ve ever had the pleasure of writing code for a Node.js project, you know what I’m talking about when I say debugging it to figure out what’s going wrong isn’t the easiest thing.

Unlike JavaScript in the browser, or Java with a powerful IDE like IntelliJ, you can’t just set breakpoints everywhere, refresh the page or restart the compiler and slowly walk through the code examining objects, evaluating functions and finding the mutation or missing variable, etc. You just can’t, and it stinks.

But it is possible to debug, it just takes a little more elbow grease. Let’s go over the options and then I’ll show you the easiest way I’ve come across in my own development.

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

Once you see this happening, congrats, you’re running in debug mode in Node.js!

Now, you can see your breakpoints in the bottom left corner of the screen (and can toggle them on and off with the checkboxes), and you can step through the code just like you would in a browser with the little play, step over, step in, restart, etc. buttons at the top center of the IDE. VS Code even highlights the breakpoint and line you’ve stopped on with yellow, making it easier to follow along.

![Hit the play button at the top to step from one break point to the next one in your code.](https://cdn-images-1.medium.com/max/4976/1*_rTrxs5eBDQXy-ajquNVRQ.png)

As you step from breakpoint to breakpoint, you can see the program printing out the `console.log`s in the debug console at the bottom of the VS Code IDE and the yellow highlighting will travel with you, as well.

![As you can see, when we stop on breakpoints, we can see all the local scope info we could explore in the console in the upper left corner of VS Code.](https://cdn-images-1.medium.com/max/4580/1*JFrOtthKOstqNFgT75PaCw.png)

As you can see, as I progress through the program, more prints out to the debug console the further through the breakpoints I go, and along the way, I can explore the objects and functions in the local scope using the tools in the upper left hand corner of VS Code, just like I can explore scope and objects in the browser. Nice!

That was pretty easy, huh?

### Conclusion

Node.js debugging doesn’t have to be the headache it was in the past, and it doesn’t need to involve 500 `console.log()`s in the codebase to figure out where the bug is.

Visual Studio Code’s Debug > Node: Auto Attach setting makes that a thing of the past, and I, for one, am so thankful.

Check back in a few weeks, I’ll be writing about end-to-end testing with Puppeteer and headless Chrome or using Nodemailer to reset passwords in a MERN application, so please follow me so you don’t miss out.

Thanks for reading, I hope this gives you an idea of how to more easily and effectively debug your Node.js programs with a little assistance from VS Code. Claps and shares are very much appreciated!

**If you enjoyed reading this, you may also enjoy some of my other blogs:**

* [Using Node.js to Read Really, Really Large Datasets & Files (Pt 1)](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33)
* [Sequelize: The ORM for Sequel Databases with Node.js](https://medium.com/@paigen11/sequelize-the-orm-for-sql-databases-with-nodejs-daa7c6d5aca3)
* [Streams For the Win: A Performance Comparison of Node.js Methods for Reading Large Datasets (Pt 2)](https://itnext.io/streams-for-the-win-a-performance-comparison-of-nodejs-methods-for-reading-large-datasets-pt-2-bcfa732fa40e)

***

**References and Further Resources:**

* Github, Node Read File Repo: [https://github.com/paigen11/file-read-challenge](https://github.com/paigen11/file-read-challenge)
* Node.js documentation — inspector: [https://nodejs.org/en/docs/guides/debugging-getting-started/](https://nodejs.org/en/docs/guides/debugging-getting-started/)
* Paul Irish’s Blog on Using Chrome DevTools to Debug Node.js: [https://medium.com/@paul_irish/debugging-node-js-nightlies-with-chrome-devtools-7c4a1b95ae27](https://medium.com/@paul_irish/debugging-node-js-nightlies-with-chrome-devtools-7c4a1b95ae27)
* JetBrains documentation, Running and Debugging Node.js — [https://www.jetbrains.com/help/webstorm/running-and-debugging-node-js.html](https://www.jetbrains.com/help/webstorm/running-and-debugging-node-js.html)
* Visual Studio Code download: [https://code.visualstudio.com/download](https://code.visualstudio.com/download)
* VS Code Debugging Node.js docs: [https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_attaching-to-nodejs](https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_attaching-to-nodejs)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
