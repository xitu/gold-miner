>* 原文链接 : [HOW TO BUILD A MATERIAL DESIGN PROTOTYPE USING SKETCH AND PIXATE - PART TWO](http://createdineden.com/blog/post/how-to-build-a-material-design-prototype-using-sketch-and-pixate-part-two/)
* 原文作者 : Mike Scamell
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [zhangzhaoqi](https://github.com/joddiy)
* 校对者: [Velacielad](https://github.com/Velacielad)，[Zheaoli](https://github.com/Zheaoli)

在教程的 [第一部分](http://gold.xitu.io/entry/574d062b2e958a0069335d8e "如何使用 Sketch 和 Pixate 来构建一个 Material Design 原型 —— 第一部分") 我们制作了一个简单的登录界面并导出了所有资源。

在第二部分，我们打算继续在 Pixate 里创建一个原型。对于这一部分，你需要：


*   <span> Android 或者 IOS 设备（最好是 Android ）。如果你能弄到屏幕尺寸是 1080 x 1920 的设备那更好了，但那不是必须的， Pixate 将为你缩放原型。</span>
*   [<span>Pixate Studio</span>](http://www.pixate.com/getstarted/ "Pixate Studio")
*   <span><span>下载 Pixate app 到你的</span> [Android](http://bit.ly/1Wp5wuG "Pixate Android App") <span>或者</span> [iOS](http://apple.co/1qdImcZ "Pixate App iOS") <span>手机上。 </span></span>
*   <span>WiFi</span>

## 在 Pixate 上创建原型

<span>打开 Pixate 并且点击 “ Create new prototype ” 来创建一个原型，或者从“ File ”菜单新建一个。我们给它命名为“ Material Design Prototype ” 并保存到某个地方。在下一个界面选择“ Nexus 5 ”作为你的 “ Target Device ”（适配设备），然后点击“ Add Prototype ”完成创建。这里要说明的是如果你的设备屏幕分辨率大于 1080x1920 的话，当原型加载到你的手机上时会显得有些模糊。这也确实说明 Pixate 为你的设备进行了缩放。对于分辨率更小的设备， Pixate 也会把比例缩小。</span>

<span>现在你应该能看到一个空白的矩形，上面只有“ Getting Started ”几个字（译者注：在译者使用的 2.0.1 版本下，除了 Getting Started 几个大字外，下面还有一些说明性的小字），这看起来和 _Login Screen_ 有些 迷之相似。它们有着相同的尺寸，因此我们的设计可以且按照正确的比例很好地、简单地移植过去。</span><span>
![空 Pixate 项目](http://createdineden.com/media/1527/screen-shot-2016-03-10-at-142718.png?width=726&height=540)</span>

<span>在 Pixate Studio 的左手边是一个小图标菜单（译者注：最左边纵向排列的三个图标）。选择纵向第二个的“ Assets ”图标。导航到你放置 Sketch 所有导出资源的文件夹，全选并且点击“ Open ”。现在所有的图片就都被导入 Pixate 了：</span>

![](http://ww3.sinaimg.cn/large/a490147fgw1f41tri3lmej20ke0egq3u.jpg)

<span>再导航回“ Layers ”菜单（左边小图标菜单的最上面那个）然后让我们尽情利用我们的资源吧！！</span>

<span>在“ Layers ”菜单，点击“ + ”小按钮来创建一个新的层。这时在你的空白矩形上方会出现一个灰色的小格子。重命名这个层为“ Login Screen ”，好让我们知道这是什么。然后扩展这个格子让它填充满整个白色矩形背景。</span>

<span>这个灰色矩形将要成为 Login Screen （登录页面）的载体。在选中左手边菜单栏中的 _Login Screen_ 前提下，查看右边的“ Properties ”菜单。这个时候我们通过点击Appearance一栏右侧的“ + ”小图标（译者注：在这个栏的右边）来选择我们从 Sketch 导出的 _Login Screen_ 图片。</span>

![](http://ww4.sinaimg.cn/large/a490147fgw1f41trxrhhpj20ke0egjsu.jpg)

## 你能框住疼痛吗（译者注：关于介绍文本框的有趣说法）?!

<span>现在我们要加入文本框了，再一次点击“ Add a layer ”，再一次的，我们得到了一个相似的灰色格子。这个格子的尺寸要和我们从 Sketch 项目中导出的 _email text field_ 的尺寸相同，对我（译者注：本文原作者的设备）来说是 328 x 48 。使用右手边的“ Properties ”菜单的“ Size ”属性来调整尺寸大小。我们也将使用 Sketch 中的定位，我的 _email text field_ 的x坐标为16，y坐标为296。然后把这些输入 Pixate 右边菜单中的 “ Position ”栏中。最后，我们通过之前导出 _Login Screen_ 图片一样的操作来从 Sketch 导出 _email text field_  图片。</span>

<span>我们需要移动 _email text field_ 使它成为 _Login Screen_ 的一部分。在左边“ Layers ”菜单中点击并且拖动 _email text field_ 放置到  _Login Screen_ 上面，我们就能看到 _email text field_ 已经成为 _Login Screen_ 的一部分了。</span>  
![](http://ww2.sinaimg.cn/large/a490147fgw1f41tsa8p9tj20ke0eg75g.jpg)

<span>但是！等等等下！EMAIL 输入框中那个丑陋的灰色线条是干嘛的？</span>

<span>好吧，当我们从 Sketch 中选择我们导出的 _email input field_ 资源时，我们没有从我们的层上去掉灰色背景。让我们选中 _email input field_ ，看一下右边“ Properties ”菜单中的“ Appearance ”栏。在靠近你导出的 _email input field_ 名字旁边有一个灰色小格子（译者注：_email input field_ 名字左边那个），点击一下然后弹出一个颜色调色板，我们需要选择透明色，就是左上角中间有个红色对角线的那个。嗒哒！然后灰色线条就被去掉了。要记得每次导入图片都要做这些。</span>

<span>我假定你已经足够聪明去意识到我们要对 _Login Screen_ 的其余组件都这样操作，包括 _login button_ ， _raised login button_ ， _email text field with input_ 和 _password text field_。 </span>

<span>在你做完这些应该做的事情之后，你会看到下面的这样：</span>

![](http://ww3.sinaimg.cn/large/a490147fgw1f41tsocpvfj20ke0egdh2.jpg)

<span>你可以看到我加入的每样东西都属于 _Login Screen_ 层。</span>

<span>接下来你需要把已经填充好的栏目加进来。最简单的方法就是点击我们想要加入填充状态的输入框所属的层。然后点击“ Layers ”菜单顶部的“ Duplicate layer ”按钮。这将给你选择的东西创建一个拷贝。所以让我们对 _email text field with input_ 执行上述操作。在拷贝好之后,你需要点击并且拖动它，确保它位于 _email text field_ 下面。然后你可能需要翻看你的 Sketch 项目找出正确的大小和位置，从而修改它的尺寸确保它不会超出规模，然后还要把它移动到合适的位置。</span>

<span>一旦你已经把这些层放置到它们空白的相对应处，那就应该点击眼睛图标来隐藏它们，就像我们在 Sketch 做的那样。最后一件你应该做的事情是用右边属性菜单中的“ Opacity ”给 _email text field with input_ 和 _password text field with input_ 设置为 0%。这样做的原因是当我们最终使用 Pixate 应用加载这个项目的时候它们是不可见的，所以在 Pixate Studio中没有必要花费注意力在这些层的可见性设置上。</span>

![](http://ww2.sinaimg.cn/large/a490147fgw1f41tt3hbjvj20ke0eggmv.jpg)

<span>正如上面的截图，我加入了一些带有输入的框但是它们被隐藏了。现在我们搞点有趣的事情 —— 动画 :D 。</span>

## 让框的输入动起来 (我想不出有趣的题目了)

<span>现在让我们给登录界面加入一些动画。我们从文本框开始，然后再弄按钮。</span>

<span>在左边“ Layers ”菜单下面是两个格子 —— “Interactions”和 “Animations”，这两个格子各自包含了不同的互动和动画。互动有类似“ Tap ”（类似“点击打开”的意思）和“ Drag ”（拖动）。动画有类似“ Scale ”（缩放）和“ Move ”（移动）。为了使用它们，我们需要把它们拖动到我们想要互动和动画发生的层上面，真是简单好用。</span>

<span>让我们从 _email text field_ 开始吧。 在左边选中它，然后从“ Interactions ”格子中点击并拖动“ Tap ”，并且把它丢到 _email text field_ 层上面。接下来我们需要 “ Animations ”（动画）格子里面的“ Fade ”（渐变），像对 _email text field_ 操作那样点击并拖动它。你应该能在右边“ Properties ”（属性）菜单中的“ Interactions ”下面能看到一个小的 Tap 图标，在Animations ”下面看到“ Fade ”。</span>

<span>我们现在想要设置当我们点击 _email text field_ 时使其渐出。在右边菜单的“ Fade ”下点击“ Based On ”（基于）并且选择 _email text field_ 。这时会弹出更多的选项，你可以研究一下，不过我们这里只关心“ Fade to ”，点击格子并输入 “ 0 ”。</span>

![](http://ww3.sinaimg.cn/large/a490147fgw1f41ttixjxnj20ke0egjt2.jpg)

<span>你快要能够见证你的第一个动画了，现在你仅仅需要在你的设备上运行 Pixate 应用。</span>  

## 在你的设备上设置 Pixate 

<span>确认你已经下载 Pixate 应用到你的 [Android](http://bit.ly/1Wp5wuG "Pixate Android App") 或者 [iOS](http://apple.co/1qdImcZ "Pixate App iOS") 手机上了。</span>

<span>打开 Pixate 应用。这个应用会从网络上查找你的 Pixate Studio ，所以稍等一下并且确保你已经连接 WiFi 了。 Pixate 应用有时对我不太友好，所以你有可能需要退出并且重新进入。你也可以通过 IP 地址连接。</span>

<span>当你的电脑出现的时候，点击它。在 Pixate Studio 的右上角点击“ Devices ”。你能看到你的手机被列在这里，你需要允许连接所以点击勾选然后你的设备就被连接了。检查一下你的设备，你的电脑应该在顶部被列出了。点击它，然后你就能看到你的这些原型了。你应该看到“ Material Design Prototype ”（这取决于你给它的命名），点击它。现在你将被展示一些关于当你使用你的原型时如何与你的设备进行互动的指示。点击“ Get Started ”，然后你现在应该能看到登录页面了！更棒的是如果你现在点击 _email text field_，它将会渐变然后从你的眼前消失了。</span>

## 创建更多的动画

<span>好的，现在我们要完成这些的动画了。当我点击  _email text field_ 时变得空白并不好。点击 _email text field_ _with input_ ，并且从动画格子中点击并拖动“ Fade ”然后丢到它上面。当你在“ Fade ”下面的“ Based on ”点击第一个下拉格子时，确保你选择了 _email text field_。我们想要展现的效果是当 _email text field_ 渐出时， _email text field with input_ 出现。在“ Fade to ”里面输入“ 100 ”。</span>
![](http://ww1.sinaimg.cn/large/a490147fgw1f41wtvuc3qj20jp0ci75p.jpg)

<span>我们实际上是在说，当 _email text field_ 被点击时，它渐变到 0 ，并且 _email text field with input_ 渐变到 100 。这有点像“如果这样，就那样”。/span>

<span>现在，如果你回到你的设备，Pixate 应用应该已经刷新了，因为它会自更新。现在如果每样事情都被设置正确了，那么当你点击 _email text field_ 时，它应该能渐出然后 _email text field with input_ 应该会出现。</span>

![](http://ww4.sinaimg.cn/large/a490147fgw1f41wt2s6lmg20ba0k0tca.gif)

<span>现在你需要对 _password text field_ 和 _password text field with input_ 重复之前的那些操作。/span>

## 点击按钮！让登录按钮动起来！

<span>接下来我们要给登录按钮做动画。我们想要的效果是，当你点击按钮时，它抬起然后跌落，就像在真实设备上那样。这给原型添加了一个不错的现实主义的层（译者注：即仿真程度高），如果你想要做一个快速原型，你大可不必做这些，仅仅让这个按钮打开下个界面即可。不过我们这里是在研究 Pixate，所以让我们继续做吧。</span>

<span>首先你需要把 _login button_ 和 _login button raised_ 加到项目里面。这两个在左侧菜单的层级关系里都隶属于 _disabled login button_ ，并且确保它们俩透明度都为 0 。 </span>

<span>当你添加 _login button_ 和 _raised login button_ 时，你可能发现它们有些破碎的感觉。你需要注意的是阴影。不要像使用 Sketch 那样忽视了阴影，Pixate 把阴影算做了图像的一部分。</span>

<span>这里是我对于登录按钮的设置</span>

*   <span>x = 14pt</span>
*   <span>y = 471pt</span>
*   <span>width = 332pt</span>
*   <span>height = 40pt</span>

<span>还有抬起状态的按钮:</span>

*   <span>x = 8pt</span>
*   <span>y = 465pt</span>
*   <span>width = 344pt</span>
*   <span>height = 58pt</span>

这些按钮相互之间应该可以直接替换并且还要给阴影留出空间。

<span>我们需要设置一些条件使 _disabled login button_ 消失。我们想要使它在 _email_text_field_ 和 _password_text_field_ 都被点击并且 _email_text field with input_ 和 _password text field with input_ 都出现的时候消失。如何做呢？好的，当你在 Pixate 中加入一个动画时，你可以指定这个动画发生的条件。条件的编写就像写代码，所以程序员可能会用到这个，但是对于其他人就容忍我吧，并且我们将完成它 :) 。/span>

<span>点击并且拖动“ Fade ”动画到 _disabled login button_ 上。现在给 _email text field_ 设置“ Based on ”。当你完成这些弹出的额外选项时，我们来关注一下“ If ”栏，如果你点击它旁边的问题标志图标，你会得到一个通篇解释，关于这是做什么的和你想要知道的关于层的所有属性。</span>

<span>我们的条件是什么？我们想要去检查：如果 _password text field_ 不再可见，就使 _disabled login button_ 渐出。我们这样做是因为我们知道，如果 _password text field_ 不再可见，那么 _password text field with input_ 就必须可见。</span>

<span>你需要在“ If ”格子里输入这个条件声明：</span>

<span>    password_text_field.opacity == 0</span>

<span>我们加了下划线，因为如果你的层名带空格的话， Pixate 会自动给我们的" Layer ID "加下划线。</span>

<span>我们在 _password text field_ 层上通过可见性属性来检查它的可见性，并且确保设置为 0 。</span>

<span>现在如果你回到你的设备上的原型，并且触压 _password text field_ ，然后触压 _email text field_ ，使否状态的按钮应该就消失了。</span>

<span>我们现在需要添加另一个渐出动画。这个动画是在 _password text field_ 被触压时，_email text field_ 渐出。这也是典型的原型是如何正常操作的。</span>

<span>你需要去做的我们之前做一样，只不过采用相反的设置。我将教你如何开始，你需要点击并且拖动另外一个“ Fade ”动画到 _disabled login button_ 上。我把其他的留给你做 ;)。</span>

<span>如果一切就绪，然后当 _email text field_ 和 _password text field_ 不再可见时，你的 _disabled login button_ 按钮应该也消失了。现在我们要使 _login button_ 可见。这将是另外一个简单的渐入动画。</span>

<span>我们基本上需要像对 _disabled login button_ 那样做相同的事情，但是对于两个动画来说，我们想要透明度变为 100 而不是 0 。我确认你现在已经可以做到了，但是我还是会教你如何开始。你需要拖动“ Fade ”动画到 _login button_ 。并且记得添加条件。</span>

<span>好的，现在你应该能看到类似这样的一些东西了：</span>

![](http://ww1.sinaimg.cn/large/a490147fjw1f41vs6l528g20ba0k0q89.gif)

## 抬起你的按钮!

<span>最后我们需要做的是使 _login button_ 被触压的时候抬起；就像 Android 5.0 版本上一个按钮通常的那样。正如你在“ Fantasy Football Fix ”例子的登录页面看到的那样，当你触压“ Upload Squad ”按钮时，它的阴影变大，看起来好像吸住了你的手指一样。</span>

![](http://ww2.sinaimg.cn/large/a490147fjw1f41vufzbuyg20ba0k0gtk.gif)

<span>显然，我们打算使用 _raised login button_ 。首先，拖动“ Tap ”互动到 _login button_ 上，因为我们需要知道它何时被触压了。然后再一次我们需要两个渐变效果所以拖动它们到 _raised login button_ 上。</span>

<span>第一个渐变需要在点击 _login button_ 时触发，所以确保 _login button_ 在“ Based on ”栏中被选中。我们想要第一个渐变使我们抬起的按钮出现，因此设置它的透明度为 100 。我们还应该给渐变命名，这样我们就知道它们是做什么的了。那么把这个渐变叫做“ Fade in on Login Button tap ”（当登陆按钮点击时渐入）吧。</span>

这将使我们的按钮出现并且看起来抬起了，但是如果你现在点击 _login button_ ， _raised login button_ 将出现并且保持在那里。而我们需要的是再次消失回原始的 _login button_ ，所以我们将完成剩余的状态。

<span>这里我们需要另外一个“ Fade ”动画。把这个动画命名为“ Fade out after Rise ”（在抬起后渐出）。同样它也是在 _login button_ 点击时触发。这个动画虽然我们想渐变为 0% ，但是我们需要设置“ Delay ”（延迟）为“ 0.2 ”。这是为了让我们等待 button 渐出，否则你甚至看不到这个按钮了，因为渐入和渐出会在同时发生。</span>

<span>现在如果你点击 _login button_ 你应该得到一个不错的抬起效果了。</span>

<span>![](http://ww1.sinaimg.cn/large/a490147fgw1f41web91qbg20ba0k0dlb.gif)</span>

<span>如果你想要得到更多的乐趣，你也可以让 _login button_ 在被点击时渐入和渐出，但是我把这留给你当作额外的任务 ;) 。这样做的副作用是会产生轻微的闪光，所以看起来按钮好像被点击了。要注意的是，如果 _login button_ 和 _raised login button_ 没有在 Pixate 中被排列好的话，效果看起也不好，所以确保你已经排列好了。</span>

## 最终！我们做好了!

<span>所以总结下这个系列的第二个充实的部分吧。我知道这是一个冗长的过程，但是这是因为我必须把绝对数量的指导都写出来。一旦你做过一次之后，你就可以把它作为参考了。我的建议都依附于小的样本项目，所以如果你需要知道如何制作一个抬起的按钮，你仅仅需要打开这个项目然后简洁明了地看到列出的所有东西。当你给原型加入更多的流程性的东西时，就会使得项目变得忙乱，然后你可能就不能简单地定位指定事件的动作或序列了。</span>

