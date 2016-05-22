>* 原文链接 : [HOW TO BUILD A MATERIAL DESIGN PROTOTYPE USING SKETCH AND PIXATE - PART ONE](http://createdineden.com/blog/post/material-design-prototype-tutorial-part-1/)
* 原文作者 : Mike Scamell
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Sausure](https://github.com/Sausure)
* 校对者:

你是否曾经对款应用有过很棒的想法或者想向别人展示你的想法是如何工作的？可是否又有以下限制令你止步呢？

*   没时间去开发款概念产品来证明自己
*   你对色调、布局和动画等等该如何展示没有把握
*   你是位应用开发者，想尝试但不知该如何设计
*   你是位应用设计师，同时想了解在设计和构建原型时 Sketch 和 Pixate 的优势
*   你对 Material Design 是否会提升你的应用没有把握但又想知道到底会变成怎样（希望这项并不是你最关注的）

如果上面有你关注的问题或者你仅仅是想学习 Sketch 或 Pixate，那么我希望你能继续看下去。

[Sketch](http://bit.ly/22RgdKX "Sketch design tool") 和 [Pixate](http://bit.ly/1M2DyBP "Pixate prototyping tool") 这两款工具我非常喜欢用来设计和构建原型。我是位贸易行业的 Android 开发者同时我对学习路线过于曲折的 Adobe Illustrator 或者类似的软件并不感兴趣。几个月前我开始设计一款应用 [Fantasy Football Fix app](http://bit.ly/1Tb18sZ "Fantasy Football Fix")，而当时听到一些对 Sketch 的称赞同时看到有关 Google 收购 Pixate 的文章 [Tech Crunch article](http://tcrn.ch/1OkuP9R "Tech Crunch article")，便决定同时使用这两款工具工作。

Sketch 是一款简易、便捷的设计软件。它被设计成页面 和画板分离以便组合你的设计。例如专门用一个版面来包含所有针对应用某一特性的画板,起名叫 “the login for instance”。或者用一页来包含所有测试/原型的而另开一页放实际发布的设计。不管你会怎么做，它对组织你的设计都很有帮助。这里还有大量的配置指南 [plugins for added functionality](http://bit.ly/1V9jYVN "Sketch plugins")。 下面列出一些我的配置：

*   [Sketch Artboard Tricks](http://bit.ly/1RPufrh "Sketch Art board Tricks plugin") 可以帮你重新排列零散的画板
*   [Sketch Export Assets](http://bit.ly/1UEwVIU "Sketch Export Assets plugin")可以帮助你分别根据 IOS、Android 和 Window Phone 的大小导出设计

Pixate 是一款 Google 的原型设计软件。它包含一些预定义的动画以及交互，和配套的手机应用让你可以在 Android 或 IOS 设备上与原型交互。它还有云服务，起步价是 $5 每月，这样你就能将原型分享到云端方便你用客户端和同事们访问。我十分享受 Pixate 因为我发现在条件判断以及布局动画时有点像敲代码。我们现在用的是免费版，它能通过 Wifi 分享原型到你的设备上。  

Pixate 另一项很好的方面是你可以创建自己的动作。你可以用 Javascript 的子集写个脚本帮忙自动进行重复的工作或者创建一个公共的模板。例如你可以写个动作 代表一个按钮先向左移动 48px 后再逐渐消失，而不是每次都用两个步骤来实现。虽然我至今还没用过但他们似乎挺便利的样子。目前 ['Actions' feature](http://bit.ly/1ZMSPZK "Beta actions feature") 只是测试阶段。

在第一部分，我先教你在 Sketch 中导入资源并使用它们创建一个登录界面，它将会在第二部分中在 Pixate 上被用来进行原型的创建。在第三部分，我将给你们提供所有用于构建下一阶段原型的资源。这样能帮助我们稍微加快学习的速度同时享受有趣的过程，我相信 Sketch 足够简单让你理解。

## 在构建超棒的原型前你先需要准备的东西

*   Sketch - 完整版需要 $99,当然也有试用版
*   Pixate - 免费但云服务功能需要 $5 每月（将会在第二三部分用到）
*   [Assets Sticker Sheet](https://www.dropbox.com/s/6ykfx9gukoacgp0/Material%20Design%20Prototype%20Assets.sketch?dl=0 "Assets Sticker Sheet")
*   Android 设备 - 你可以使用 iPhone，但 Android 设备更加合适。如果你使用 IOS 设备的话我无法保证它能正常显示（将会在第二三部分用到）

本教程中使用到以下色调：

*   主色 - #4CAF50
*   主暗色 - #388E3C
*   强调色 - #D500F9
*   登录界面背景色 - #E8F5E9

 Sketch 资源库的所有资源都是可以免费使用的！

注意：在这里我假定你在接下来的构建过程中是有一定动手能力。若在下文中我略过一些内容，是因为我认为根据逻辑你们完全可以独自做到！我并没有将整个步骤完整记录下来，更深层次来说，下文应该是如何引导你去使用 Sketch 或 Pixate。但如果你觉得我确实遗漏了些重要的知识，请告知我。

## 那我们开始构建登录界面吧！

添加邮箱以及密码的文本框

首先打开系统提供的 Sketch 资源库，里面所有东西我们都可以用来构建原型。在本教程中你所有需要用来构建登录界面的资源在这里都能找到。

打开新的 Sketch 文件然后将其保存文件名为 “Material Design Prototype”。接着使用工具栏的 “Insert” 菜单插入一张新的画板。然后在右侧栏中单击 “Material Design” 下拉框并选择 “Mobile Portrait”。经过这些步骤后会在你的屏幕上生成一张白色矩形。

![](http://ww2.sinaimg.cn/large/a490147fgw1f41t1ndhcpj20i50ef74u.jpg)  

我们先进行重命名，在左侧栏中右击 “Mobile Portrait” 然后选择 "Rename"，重命名为 “Login Screen”。虽然这步骤看起来简单但你要记住给所有东西命名可以避免混淆，否则在构建登录界面时很容易不知所措。

然后我们开始给当前的界面添加背景色。首先在左侧栏选中 “Login Screen”，接着右侧栏会自动弹出。选中 “Background Color” 然后选择旁边的色板框。粘贴我们的背景色即 “E8F5E9” 到 “Hex” 框中后单击确认。你看，浅绿色背景多漂亮。我以前提到过我特别喜欢绿色吧？

你注意到画板的大小是 360 x 640 了没？这样可以方便导出不同的适应 Android 设备的分辨率例如 hdpi 和 xxhdpi 等等。这些稍候还有介绍。

接下来我们通过分别拖放 Sketch 的资源很容易就能构建出 Material Design 原型。首先选中 “Login Screen” 然后在资源库中找到文本框并将其复制到我们的登录界面，接着将 “Hint Text” 改为 “Email”。接着我将其移到屏幕的中间并改变其大小为 328 像素，这样它左右两边能保持 16 像素的边距，正好遵循了 [Google Material Design guidelines](http://bit.ly/23YKwj9 "Google Material Design guidelines") 中的布局限制。再次复制粘贴该文本框并在将其移到距离邮箱文本框下 16 像素处。Sketch 会通过红线和数字的方式提示你上面两者之间的距离。

![](http://ww1.sinaimg.cn/large/a490147fgw1f41t28fkj4j20hl0cnt9c.jpg)  

## 添加一个 LOGO

现在我们打算将我们的 LOGO 添加到顶部，原因你也懂，品牌效应嘛...抓取 LOGO 并将其放置在邮箱、密码文本框之上。

接着从资源库中复制登录按钮到我们的登录界面，记得需要先将其设置为不可用状态方便我们在接下来的登录操作时可以改变它的状态。如果以上你的操作正确，你应该能获得类似下面这张图片的界面：

![](http://ww4.sinaimg.cn/large/a490147fgw1f41t2lrc8hj20hv0cxgmh.jpg)  

好的，我们最终做好了登录界面！年轻人，别着急，这还只是刚刚开始呢，我们还需要创建一些组件填充到界面中。

## 填充邮箱和密码文本框

我们需要复制并粘贴输入组件填充到邮箱文本框里。首先将其拖到邮箱文本框的上方，它会自动填充进去，并需要确保它们的下边沿重合。现在在左侧栏中选中邮箱文本框然后点击显示在一旁的小眼睛，邮箱文本框会被隐藏。你应该只能看到邮箱文本框的输入框，这样你就可以直接在上面填写一些相关的文本。

![](http://ww4.sinaimg.cn/large/a490147fgw1f41t2ynw6ej20hv0cxmy3.jpg)  

接下来我们对密码文本框重复刚刚的动作。在我们复制输入组件后必须确保在左侧栏中对其重命名。这里我使用星星代表我输入的密码。

现在你的界面应该像这样子：

![](http://ww2.sinaimg.cn/large/a490147fgw1f41t4vfxw7j20i00d1wfm.jpg)

接下来就是处理登录按钮。这过程和上面十分类似：复制、粘贴、拖动组件上方并隐藏原本的组件。

![](http://ww3.sinaimg.cn/large/a490147fgw1f41t584f7fj20i60d5q40.jpg)

## 添加状态栏

我们忽略了一个小细节，那就是状态栏。若是假设原型是在在全屏状态下不显示状态栏也是可以的，那样的话可以忽略它，但我想让原型更像一款真正的应用，所以决定添加上它。

首先从资源库中找到状态栏，复制并放到界面的顶部居中位置。我们最后进行这一步骤是因为我们需要确保状态栏是处于最上方的，否则它会被覆盖掉。

![](http://ww3.sinaimg.cn/large/a490147fgw1f41t5mjphxj20k60eft9w.jpg)

## 导出资源给 Pixate

最后，我们需要导出所有 Pixate 将会用到的资源。因为到时我们想让我们的原型有些移动的效果，所以先将界面恢复到基本状态。隐藏所有我们添加到登录界面的东西除了 LOGO 以及状态栏。

![](http://ww3.sinaimg.cn/large/a490147fgw1f41t60k3ysj20k60ef3zn.jpg)  

在左侧栏中点击 “Login Screen”，这样它就能帮你选中整个画板。此时在右下角处会出现一行文字：“Make Exportable”，点击它确保登录界面可导出，之后会弹出一个菜单。菜单十分简便，它允许你根据不同的缩放尺寸导出，当你需要适配不同规格的设备时这个功能十分有帮助。但现在 Android 推出了 [VectorDrawableCompat](http://bit.ly/1P3A6RH "VectorDrawableCompat documentation")，所以我们并不需要这功能。我们先在 “Size” 下拉框中设置属性为 3x，然后清除后缀。这里也有个小功能能帮你给不同分辨率的图片设置不同的名字。例如：login_screen_mdpi、 login_screen_xxhdpi，但现在我们并不需要。最后，记住要选中 “Background Color” 下面的 “Include in Export” 框，否则导出的文件将不会包含我们设置的背景色，我们可不想那样！单击 “Export Login Screen” 然后将其保存到合适的位置。我将其保存到 “Login Screen Assets” 文件夹中。

剩下的组件也需要分别导出。从邮箱文本框开始吧。记得先让文本框可见否则导出的文件是没有任何东西的！ 首先在左侧栏中选中邮箱文本框，单击 “Make Exportable”，设置 “Size” 为 3x 然后清除后缀，最后就是单击 “Export email text field” 并保存到你已选中的位置。

![](http://ww4.sinaimg.cn/large/a490147fgw1f41t6cn2ehj20k60ef3zv.jpg)  

剩下我们还需要保存的东西：

*   邮箱文本框的输入组件
*   密码文本框
*   密码文本框的输入组件
*   登录按钮
*   激活状态的登录按钮
*   不可用状态的登录按钮

一定要记得在导出前先让它们可见哟！
