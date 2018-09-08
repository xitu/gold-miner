> * 原文地址：[How to Build a Simple Chrome Extension in Vanilla JavaScript](https://medium.com/javascript-in-plain-english/https-medium-com-javascript-in-plain-english-how-to-build-a-simple-chrome-extension-in-vanilla-javascript-e52b2994aeeb)
> * 原文作者：[Sara Wegman](https://medium.com/@sarawegman?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-simple-chrome-extension-in-vanilla-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-simple-chrome-extension-in-vanilla-javascript.md)
> * 译者：[Shery](https://github.com/shery)
> * 校对者：

# 如何使用原生 JavaScript 构建简单的 Chrome 扩展程序

今天，我将向你展示如何使用原生 JavaScript 开发 Chrome 扩展程序 —— 也就是说，不使用诸如 React，Angular，Vue 之类框架的纯 JavaScript。

开发 Chrome 扩展程序非常简单 —— 在我开始编程生涯的头一年，我发布了两个扩展程序，这两个扩展程序都只用了 HTML，CSS 和纯 JavaScript 进行开发。在本文中，我将在几分钟内引导你完成相同的操作。

我将向你展示怎样开发简单的 dashboard 类型的 Chrome 扩展程序。但是，如果你有自己的想法，并且只想知道需要往现有项目中添加什么内容就可以让它在 Chrome 中运行，你可以跳转到自定义 `manifest.json` 文件和图标的部分。

![](https://cdn-images-1.medium.com/max/2000/1*BOYvlX903vKaY8TI2JJFQA.png)

### 关于 Chrome 扩展程序

Chrome 扩展程序本质上只是一组可以自定义 Google Chrome 浏览器体验的文件。Chrome 扩展程序有几种不同的类型；有些在满足某个特定条件时激活，例如当你来到商店的结账页面时；有些只在你点击图标时弹出；还有些每次打开新标签时都会出现。今年我发布的两个扩展程序都是“新标签”类型的；第一个是 [Compliment Dash](http://bit.ly/complimentdash)，这是一个用于保存待办事项列表并赞美用户的 dashboard，第二个是 [Liturgical.li](http://liturgical.li/)，一款针对牧师的工具。如果你知道如何开发简单的网页，那么你就可以毫不费力地开发这类扩展程序。

### 前提

我们要把事情简单化，因此在本教程中，我们将只使用 HTML，CSS 和一些基础的 JavaScript，以及如何自定义我将在下面添加的 `manifest.json` 文件。Chrome 扩展程序的复杂程度各不相同，因此构建 Chrome 扩展程序的复杂度取决于你想开发什么样的应用。在学习了基础知识之后，你可以使用自己的技术栈开发更复杂的扩展程序。

### 创建你的项目文件

在本教程中，我们将开发一个通过名字来欢迎用户的简单 dashboard。让我们称之为 Simple Greeting Dashboard。

首先，你需要创建三个文件：index.html，main.css 和 main.js。把它们放在单独的文件夹中。接下来，使用基础的 HTML 代码填充 HTML 文件，并引用 CSS 和 JS 文件：

```
<!-- =================================
Simple Greeting Dashboard
================================= //-->

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>Simple Greeting Dashboard</title>
  <link rel="stylesheet" type="text/css" media="screen" href="main.css" />
</head>
<body>
   <!-- 将在这里添加业务代码 -->
   <script src="main.js"></script>
</body>
</html>
```

### 自定义你的 manifest.json 文件

这些文件还不足以让你的项目作为 Chrome 扩展程序运行。为此，我们需要一个 `manifest.json` 文件，我们将使用一些基本的扩展程序信息进行自定义。你可以在 [Google 的开发人员网站](https://developer.chrome.com/extensions/getstarted) 上下载该文件，也可以直接将以下代码复制/粘贴到新文件中，并且以 `manifest.json` 的文件名保存在你的文件夹中：

```
{
  "name": "Getting Started Example",
  "version": "1.0",
  "description": "Build an Extension!",
  "manifest_version": 2
}
```

现在，让我们使用更多的扩展程序信息来更新示例文件。我们只想更改这段代码的前三个值：`name`，`version` 和 `description`。让我们来填写扩展程序名字和一行描述，因为这是我们的第一个版本，让我们保持版本值为 1.0。`manifest_version` 编号应该保持不变。

接下来，我们将添加几行代码来告诉 Chrome 如何处理这个扩展程序。

```
{
  "name": "Simple Greeting Dashboard",
  
  "version": "1.0",
  
  "description": "This Chrome extension greets the user each time they open a new tab",
  
  "manifest_version": 2
  "incognito": "split",
  
  "chrome_url_overrides": {
    "newtab": "index.html"
  },
  
  "permissions": [
     "activeTab"
   ],
"icons": {
    "128": "icon.png"
    }
}
```

`"incognito": "split"` 字段会告知 Chrome 在处于隐身模式时如何处理这个扩展程序。当浏览器处于隐身模式时，`"split"` 将允许扩展程序在其自己的进程中运行；有关其他选项，请参阅 [Chrome 开发者文档](https://developer.chrome.com/extensions/manifest/incognito)。

正如你可能看到的那样，`"chrome_url_overrides"` 告诉 Chrome 每次打开新标签时都会打开 `index.html`。`"permissions"` 的值会在用户试图安装这个扩展程序时，向用户提供一个弹框提示，让他们知道这个扩展程序将覆盖他们的新标签。

最后，我们告诉 Chrome 要显示什么作为我们的图标：一个名为 `icon.png` 的文件，尺寸为 128 x 128 像素。

### 创建一个图标

由于我们还没有图标文件，接下来，我们将为 Simple Greeting Dash 创建一个图标。请随意使用我下面制作的那个图标。如果你想自己制作一个，可以使用 Photoshop 或者 [Canva](http://canva.com) 这样的免费服务轻松完成。请确保尺寸为 128 x 128 像素，并将其作为 `icon.png` 保存在与 HTML，CSS，JS 和 JSON 文件相同的文件夹中。

![](https://cdn-images-1.medium.com/max/800/1*-dBIaX8IyG0PfHK-2vZ2dA.png)

我为 Simple Greeting Dash 制作的 128 x 128 图标 

### 上传文件（如果你正在开发自己的页面）

通过以上信息，你可以创建你自己的新标签 Chrome 扩展程序。在自定义 `manifest.json` 文件后，你可以通过 HTML，CSS 和 JavaScript 设计你想要的任意类型的新标签页，并像下面展示的那样将其上传。但是，如果你想了解我将如何制作这个简单的 dashboard，请跳转至“创建设置菜单”。

一旦你完成新标签页的样式设置后，你的 Chrome 扩展程序就算完成了，并准备好了上传到 Chrome。要自己上传已经完成的扩展程序，请在浏览器中访问 [**chrome://extensions/**](about:invalid#zSoyz) 并切换右上角的开发者模式。

![](https://cdn-images-1.medium.com/max/800/1*O2j2WS2RAPYE_NiOWqyWCw.png)

刷新页面并点击“加载已解压的扩展程序”。

![](https://cdn-images-1.medium.com/max/800/1*gb0c8qmG_MtinG9tOmjxuA.png)

接下来，选择存储 HTML，CSS，JS 和 `manifest.json`，以及你的 `icon.png` 文件的文件夹，并上传这些文件。扩展程序应该在每次打开新的标签页时都生效！

一旦你完成扩展程序开发并自行测试后，你可以获取一个开发者帐户并将其转到 Chrome 扩展程序商店。[这个有关发布扩展程序的指南](https://developer.chrome.com/webstore/publish)应该有所帮助。

如果你现在没有创建自己的扩展程序，只想查看 Chrome 扩展程序的功能，请继续阅读，了解如何制作一个非常简单的问候语 dashboard。

### 创建设置菜单

对于我的扩展程序，我要做的第一件事是创建一个输入框，我的用户可以添加他们的名字。由于我不希望这个输入框始终可见，我将把它放在一个名为 `settings` 的 div 中，只有在点击 Settings 按钮后我才会让它可见。

```
<button id="settings-button">Settings</button>
<div class="settings" id="settings">
   <form class="name-form" id="name-form" action="#">
      <input class="name-input" type="text"
        id="name-input" placeholder="Type your name here...">
      <button type="submit" class="name-button">Add</button>
   </form>
</div>
```

现在，我们的设置菜单如下所示：

![](https://cdn-images-1.medium.com/max/800/1*YXSHj-nYAotrbMCAulpJ0Q.png)

太美了！

... 所以我要在 CSS 文件中给他们添加一些基本的样式。我将给按钮和输入框添加一些内边距和轮廓（outline），然后在 settings 按钮和表单之间添加一些空间。

```
.settings {
   display: flex;
   flex-direction: row;
   align-content: center;
}

input {
   padding: 5px;
   font-size: 12px;
   width: 150px;
   height: 20px;
}

button {
   height: 30px;
   width: 70px;
   background: none; /* This removes the default background */
   color: #313131;
   border: 1px solid #313131;
   border-radius: 50px; /* This gives our button rounded edges */
   font-size: 12px;
   cursor: pointer;
}

form {
   padding-top: 20px;
}
```

现在我们的设置菜单看起来好看一点了：

![](https://cdn-images-1.medium.com/max/800/1*xk-CcvLMpxklx1MIvsD7xQ.png)

但是让我们在用户没有点击 Settings 按钮时隐藏它们。我将通过将以下样式添加到 `.settings` 表单来实现，这将导致名称输入框从屏幕的一侧消失：

```
transform: translateX(-100%);

transition: transform 1s;
```

现在让我们创建一个名为 `settings-open` 的样式类名，当用户单击 Settings 按钮时，我们将在 JavaScript 中对这个类名的添加和移除进行切换。当 `settings-open` 添加到 `settings` 表单时，它将不会应用任何变换；它只是在它本该出现的位置可见。

```
.settings-open.settings {
   transform: none;
}
```

让我们在 JavaScript 中使类名切换生效。我将创建一个名为 `openSettings()` 的函数，它将添加或移除类名 `settings-open`。为此，我将首先通过其 ID `"settings"` 获取元素，然后使用 `classList.toggle` 添加类名 `settings-open`。

```
function openSettings() {
   document.getElementById("settings").classList.toggle("settings-open");
}
```

现在我要添加一个事件监听器，只要点击 Settings 按钮，它就会触发该函数。

```
document.getElementById("settings-button").addEventListener('click', openSettings)
```

当你点击 Settings 按钮，这将使你的设置表单显示或消失。

### 创建个性化问候语

接下来，让我们创建问候消息。我们将在 HTML 中创建一个空的 `h2` 标签，然后在 JavaScript 中使用 innerHTML 填充它。我将给 `h2` 标签一个 ID，以便我后面能访问到它，并将它放在一个名为 `greeting-container` 的 `div` 中方便使其居中。

```
<div class="greeting-container">
   <h2 class="greeting" id="greeting"></h2>
</div>
```

现在，在 JavaScript 中，我将使用用户名称创建一个基本的问候语。首先，我将声明一个变量保存名称，现在它是空的，稍后添加。

```
var userName;
```

即使 `userName` 不为空，如果我只是将 `userName` 放入 HTML 中的问候语中，如果我在另一个会话中打开它，Chrome 也不会使用相同的名称。为了确保 Chrome 记住我是谁，我将不得不使用本地存储。所以我将创建一个名为 `saveName()` 的函数。

```
function saveName() {
    localStorage.setItem('receivedName', userName);
}
```

`localStorage.setItem()` 函数有两个参数：第一个是我稍后用来访问信息的关键字，第二个是它需要记住的信息；在这里，需要记住的信息是 `userName`。稍后我将通过 `localStorage.getItem` 获取保存的信息，我将用它来更新 `userName` 变量。

```
var userName = localStorage.getItem('receivedName');
```

在我们将其链接到表单中的事件监听器之前，如果我还没有告诉 Chrome 我的名字，我想告诉它如何称呼我。我将使用 if 语句执行此操作。

```
if (userName == null) {
   userName = "friend";
}
```

现在，让我们最终将 userName 变量关联到我们的表单。我想在函数内部执行此操作，以便每次更新名称时都可以调用该函数。我们将这个函数命名为 `changeName()`。

```
function changeName() {
   userName = document.getElementById("name-input").value;
   saveName();
}
```

我想在每次有人使用表单提交名称时调用此函数。我将使用一个事件监听器执行此操作，我将调用函数 `changeName()`，并在提交表单时阻止页面默认的刷新行为。

```
document.getElementById("name-form").addEventListener('submit', function(e) {
   e.preventDefault()
   changeName();
});
```

最后，让我们创建问候语。我也将它放在一个函数中，这样我就可以在刷新页面时和每当 `changeName()` 发生时调用它。这是函数内容：

```
function getGreeting() {
   document.getElementById("greeting").innerHTML  = `Hello, ${userName}. Enjoy your day!`;
}

getGreeting()
```

现在我将在 `changeName()` 函数中调用 `getGreeting()`，收工！

### 最后，设计你的页面

现在是时候添加最后的润色了。在 CSS 中，我将使用 flexbox 居中我的标题，为标题设置更大的字体，并为 body 添加渐变背景。为了使按钮和 `h2` 标签同渐变背景形成对比，我会让它们变白。

```
.greeting-container {
   display: flex;
   justify-content: center;
   align-content: center;
}

.greeting {
   font-family: sans-serif;
   font-size: 60px;
   color: #fff;
}

body {
   background-color: #c670ca;
   background-image: linear-gradient(45deg, #c670ca 0%, #25a5c8 52%, #20e275 90%);
}

html {
   height: 100%;
}
```

就是这样！你的页面将如下所示：

![](https://cdn-images-1.medium.com/max/2000/1*QMqFDrey8Ylut2XLen8JRA.png)

你自己的 Chrome 扩展程序！

它可能不是很多，但它是你创建和设计自己的 Chrome dashboards 的良好基础。如果你有任何疑问，请告诉我们，并随时在 Twitter 上与我联系，[@saralaughed](https://twitter.com/SaraLaughed)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
