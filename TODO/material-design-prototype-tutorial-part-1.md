>* 原文链接 : [HOW TO BUILD A MATERIAL DESIGN PROTOTYPE USING SKETCH AND PIXATE - PART ONE](http://createdineden.com/blog/post/material-design-prototype-tutorial-part-1/)
* 原文作者 : Mike Scamell
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Sausure](https://github.com/Sausure)
* 校对者:[Ruixi](https://github.com/Ruixi) , [wild-flame](https://github.com/wild-flame)

# 使用 Sketch 和 Pixate 构建 Material Design 原型 - 第一部分

你是否曾经对某一款应用有过很棒的想法或者想向别人展示你的想法会带来改变？可是否又有以下限制令你止步？

*   没时间去开发款概念产品来证明自己
*   你对色调、布局和动画等等该如何展示没有把握
*   你是位应用开发者，想尝试但不知该如何设计
*   你是位应用设计师，想了解 Sketch 和 Pixate 在设计和构建原型的优势
*   你对 Material Design 能否提升你的应用没有把握但又想知道到底会变成怎样（希望这不是你的情况）

如果上面有你关注的问题又或者你仅仅是想学习 Sketch 或 Pixate，那么我希望你能继续看下去。

我非常喜欢用这两款工具 [Sketch](http://bit.ly/22RgdKX "Sketch design tool") 和 [Pixate](http://bit.ly/1M2DyBP "Pixate prototyping tool") 来设计与构建原型。作为一位职业的 Android 开发者，我对艰涩难学的 Adobe Illustrator 或者类似的软件不太感兴趣。几个月前在开始设计一款应用 [Fantasy Football Fix app](http://bit.ly/1Tb18sZ "Fantasy Football Fix") 时，我早已听闻用户对 Sketch 的称赞并刚好在 [Tech Crunch article](http://tcrn.ch/1OkuP9R "Tech Crunch article") 上看到 Google 收购 Pixate 的文章，便决定同时尝试下这两款工具。

Sketch 是一款简单易用的设计软件。它将设计拆分到 `Page` 和 `Artboard` 上以便让你自行组织。举个例子，一个应用的某一特征可以展现在某一张 `Page` 的全部 `Artboard` 当中，比如登录。或者用一张 `Page` 来包含所有测试/原型的而另开一张 `Page` 放实际发布的设计。不管你怎么做，它对组织你的设计都很有帮助。这里还有增强功能的插件 [plugins for added functionality](http://bit.ly/1V9jYVN "Sketch plugins")。 下面列出一些我使用的插件：

*   [Sketch Artboard Tricks](http://bit.ly/1RPufrh "Sketch Art board Tricks plugin") 可以帮你重新整理杂乱的 `Artboard`
*   [Sketch Export Assets](http://bit.ly/1UEwVIU "Sketch Export Assets plugin") 可以帮助你根据 IOS、Android 和 Window Phone 的不同尺寸分别导出设计

Google 旗下的 Pixate 是一款原型设计软件。它包含一些预设的动画以及交互，同时配套的手机应用可以让你在 Android 或 IOS 设备上与原型进行交互。它还有云服务，起步价是 $5 每月，这样你就能将原型共享到云端以便让客户们与同事们访问。我十分享受使用 Pixate 的过程因为它有点像在敲代码，例如在进行条件判断以及布局动画时。我们现在用的是免费版，它能通过 Wifi 共享原型到你的设备上。

Pixate 另一项很好的特性是你可以创建自己的 Action。你可以用 Javascript 的子集写个脚本帮忙进行重复的工作或者创建一个公共的模板。例如你可以写个 Action 代表一个按钮先向左移动 48px 后再逐渐消失，而不是每次都分两步实现。虽然至今我还没用过但它们似乎挺便利的样子。目前 ['Actions' feature](http://bit.ly/1ZMSPZK "Beta actions feature") 只是测试阶段。

在第一部分，我先教你在 Sketch 中导入资源并使用它们创建一个登录界面，它将会在第二部分中被 Pixate 用来创建原型。在第三部分，我将给你们提供所有用于构建下一阶段原型的资源。这样能帮助我们稍微加快学习的速度同时又能学到更有意义的内容，我相信 Sketch 足够简单到让你理解。

## 在构建超棒的原型前你先需要准备的东西

*   Sketch - 完整版需要 $99,当然也有免费试用版
*   Pixate - 免费但云服务功能需要每月 $5 （将会在第二三部分用到）
*   [Assets Sticker Sheet](https://www.dropbox.com/s/6ykfx9gukoacgp0/Material%20Design%20Prototype%20Assets.sketch?dl=0 "Assets Sticker Sheet")
*   Android 设备 - 你可以使用 iPhone，但 Android 设备更加合适。如果你使用 IOS 设备的话我无法保证它能正常显示（将会在第二三部分用到）

本教程中使用到以下色调：

*   主色 - #4CAF50
*   主暗色 - #388E3C
*   强调色 - #D500F9
*   登录界面背景色 - #E8F5E9

上面全部颜色都在 Sketch Assets 里，尽请使用吧！

注意：我假定你在接下来的构建过程中是有一定鉴赏能力。若在下文中略过一些内容，是因为我认为按常理来说你们完全可以独自做到！本文并没有完整深入地描述，而关注于如何引导你去使用 Sketch 和 Pixate。但如果你觉得我确实遗漏了些重要的知识，请务必告知。

## 那我们开始构建登录界面吧！

添加邮箱以及密码文本域

首先打开提供的 Sketch Assets，里面所有东西我们都可以用来构建原型。在本教程中你所有需要用来构建登录界面的资源在 Login Screen Assets `Artboard` 中都能找到。

打开新的 Sketch 文件然后将其保存文件名为 “Material Design Prototype”，接着使用工具栏的 “Insert” 菜单插入一张新的 `Artboard`，然后在右侧栏中单击 “Material Design” 下拉框并选择 “Mobile Portrait”。经过这些步骤后会在你的屏幕上生成一张白色矩形。

![](http://ww2.sinaimg.cn/large/a490147fgw1f41t1ndhcpj20i50ef74u.jpg)  

我们先对 `Artboard` 重命名。在左侧栏中右击 “Mobile Portrait” 然后选择 "Rename"，重命名为 “Login Screen”。虽然这听起来很简单但你要确保为所有东西命名以避免混淆，否则在构建登录界面时很容易不知所措。

然后我们开始给当前的界面添加背景色。首先在左侧栏选中 “Login Screen”，右侧栏会自动弹出，接着选中 “Background Color” 然后选择旁边的色板框，将我们的背景色即 “E8F5E9” 粘贴到 “Hex” 框中后单击确认。你看，浅绿色背景多漂亮，以前我提到过我特别喜欢绿色吧？

你注意到 `Artboard` 的尺寸是 360 x 640 了没？这样可以方便导出适应不同 Android 设备的分辨率例如 hdpi 和 xxhdpi 等等。这些稍候还有介绍。

接下来我们通过分别拖放 Sketch 的资源就能很容易地构建出 Material Design 原型。首先选中 “Login Screen” 然后在 Sketch Assets 中找到文本域，将其复制到我们的登录界面，并将 “Hint Text” 改为 “Email”，接着我将其移到屏幕的中间，尺寸改为 328 像素，这样它左右两边能保持 16 像素的边距，正好遵循了 [Google Material Design guidelines](http://bit.ly/23YKwj9 "Google Material Design guidelines") 中的布局规范。再次复制粘贴该文本域并在将其移到距离邮箱文本域下 16 像素处。Sketch 会通过红线和数字的方式提示你上面两者之间的距离。

![](http://ww1.sinaimg.cn/large/a490147fgw1f41t28fkj4j20hl0cnt9c.jpg)  

## 添加一个 LOGO

现在我们打算将我们的 LOGO 添加到顶部，原因你也懂，品牌效应嘛...拖拽 LOGO 并放置在邮箱、密码文本域之上。

我们还需要一个被禁用的按钮以便在以后的登录操作中改变它的状态。从 Sketch Assets 中复制并添加到我们的登录界面。如果以上你的操作正确，你应该能获得类似下面这张图片的界面：

![](http://ww4.sinaimg.cn/large/a490147fgw1f41t2lrc8hj20hv0cxgmh.jpg)  

好的，我们最终做好了登录界面！年轻人，别着急，这还只是刚刚开始，我们还需要创建一些组件填充到界面中。

## 填写邮箱和密码

我们需要复制输入组件并填充到邮箱文本域里。首先将其拖拽覆盖到邮箱文本域的上方，它会自动填充进去，这里要确保它们的下边沿重合。现在在左侧栏中选中邮箱文本域然后单击显示在一旁的小眼睛，邮箱文本域会被隐藏。现在你应该只能看到邮箱文本域的输入框了，这样你就可以直接在上面填写一些相关的文本。

![](http://ww4.sinaimg.cn/large/a490147fgw1f41t2ynw6ej20hv0cxmy3.jpg)  

接下来我们对密码文本域重复刚刚的动作。记得在复制输入组件后要在左侧栏中对其重命名。这里我使用星星代表输入的密码。

现在你的界面应该像这样子：

![](http://ww2.sinaimg.cn/large/a490147fgw1f41t4vfxw7j20i00d1wfm.jpg)

接下来就是添加其它状态的登录按钮。这过程和上面十分类似：复制、粘贴、拖拽到组件上方并隐藏原本的组件。

![](http://ww3.sinaimg.cn/large/a490147fgw1f41t584f7fj20i60d5q40.jpg)

## 添加状态栏

我们忽略了一个小细节，那就是状态栏。若假设原型是在在全屏状态下，不显示状态栏也是可以的，那样的话可以忽略它。但我觉得添加状态栏能让你感觉自己正在使用一款真正的应用。

首先从 Sketch Assets 中找到状态栏，复制并放到界面的顶部居中位置。我们最后进行这项步骤是因为我们需要确保状态栏是处于最上方，而不会被挡住。

![](http://ww3.sinaimg.cn/large/a490147fgw1f41t5mjphxj20k60eft9w.jpg)

## 导出到 Pixate

最后，我们需要导出所有 Pixate 将会用到的资源。因为到时我们想让我们的原型有些移动的效果，所以先将界面恢复到基础状态。隐藏所有我们之后添加到登录界面的东西，除了 LOGO 以及状态栏。

![](http://ww3.sinaimg.cn/large/a490147fgw1f41t60k3ysj20k60ef3zn.jpg)  

在左侧栏中点击 “Login Screen”，这样它就能帮你选中整个 `Artboard`。此时在右下角处会出现一行文字：“Make Exportable”，点击它确保登录界面可导出，之后会弹出一个菜单。菜单十分方便，它允许你根据不同的缩放尺寸导出，当你需要适配不同规格的设备时这个功能十分有用。但现在 Android 推出了 [VectorDrawableCompat](http://bit.ly/1P3A6RH "VectorDrawableCompat documentation")，所以我们并不需要这功能。我们先在 “Size” 下拉框中设置属性为 3x，然后清除后缀，这是个能帮你给不同分辨率的图片设置不同的名字的小特性，例如：login_screen_mdpi、 login_screen_xxhdpi，但现在我们并不需要。最后，记住要选中 “Background Color” 下面的 “Include in Export” 选项，否则导出的文件将不会包含我们设置的背景色，我们可不想那样！单击 “Export Login Screen” 然后将其保存到合适的位置。我将其保存到 “Login Screen Assets” 文件夹中。

剩下的组件也需要分别导出。从邮箱文本域开始吧。记得先让文本域可见否则导出的文件是没有任何东西的！首先在左侧栏中选中邮箱文本域，单击 “Make Exportable”，设置 “Size” 为 3x 然后清除后缀，最后就是单击 “Export email text field” 并保存到你已选中的位置。

![](http://ww4.sinaimg.cn/large/a490147fgw1f41t6cn2ehj20k60ef3zv.jpg)  

剩下我们还需要保存的东西：

*   邮箱文本域的输入组件
*   密码文本域
*   密码文本域的输入组件
*   登录按钮
*   可用状态的登录按钮
*   被禁用状态的登录按钮

一定要记得在导出前先让它们可见哟！
