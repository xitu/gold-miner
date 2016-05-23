>* 原文链接 : [HOW TO BUILD A MATERIAL DESIGN PROTOTYPE USING SKETCH AND PIXATE - PART TWO](http://createdineden.com/blog/post/how-to-build-a-material-design-prototype-using-sketch-and-pixate-part-two/)
* 原文作者 : Mike Scamell
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

在教程的 [第一部分](http://createdineden.com/blog/post/material-design-prototype-tutorial-part-1/ "如何使用 Sketch 和 Pixate 来构建一个材料设计原型 —— 第一部分") 我们制作了一个登录界面并导出了所有资源。

在第二部分，我们打算继续在 Pixate 里创建一个原型。对于这一部分，你可能需要：


*   <span> Android 或者 IOS 设备（最好是 Android ）。如果你能弄到屏幕尺寸是 1080 x 1920 的设备那更好了，不过没有也没关系， Pixate 将为你按比例缩放这个原型。</span>
*   [<span>Pixate Studio</span>](http://www.pixate.com/getstarted/ "Pixate Studio")
*   <span><span>下载 Pixate app 到你的</span> [Android](http://bit.ly/1Wp5wuG "Pixate Android App") <span>或者</span> [iOS](http://apple.co/1qdImcZ "Pixate App iOS") <span>设备。 </span></span>
*   <span>WiFi</span>

## 在 Pixate 上创建原型

<span>打开 Pixate 时点击 “ Create new prototype ” 来创建一个原型，或者从“ File ”菜单创建一个。我们给它命名为“ Material Design Prototype ” 并保存起来。接下来选择“ Nexus 5 ”作为你的 “ Target Device ”（译者注：适配设备），然后点击“ Add Prototype ”完成创建。这里要说明的是如果你的设备屏幕分辨率大于 1080x1920 的话，当原型被加载到你的设备上时会显得有些模糊。这也确实说明 Pixate 为你的设备进行了比例缩放。同样，对于分辨率较小的设备， Pixate 也能把比例缩小。</span>

<span>在创建之后，你应该能看到一个空白的矩形画布，上面只有“ Getting Started ”几个字（译者注：在译者使用的 2.0.1 版本下，除了 Getting Started 几个大字外，下面还有一些说明性的小字），这看起来和 _Login Screen_ 有些神秘的相似。它们有着相同的尺寸，因此我们的设计可以且按照正确的比例简单地移植过去。</span><span>  
![空 Pixate 项目](http://createdineden.com/media/1527/screen-shot-2016-03-10-at-142718.png?width=726&height=540)</span>

<span>在 Pixate Studio 的左边是一个小图标菜单（译者注：最左边纵向排列的三个图标）。选择纵向第二个的“ Assets ”图标。导航到你放置所有 Sketch 导出资源的文件夹，全选并且点击“ Open ”。然后所有的图片就都被导入 Pixate 了：</span>

![](http://ww3.sinaimg.cn/large/a490147fgw1f41tri3lmej20ke0egq3u.jpg)

<span>再回到“ Layers ”菜单（小图标菜单的最上面那个）然后让我们开始引用我们的资源吧！！。</span>

<span>在“ Layers ”菜单，点击“ + ”小按钮来创建一个新的层。这时在你的空白的矩形画布上方会出现一个灰色的小格子。重命名这个层为“ Login Screen ”好让我们知道这是什么。然后扩展这个格子让它填充满整个白色背景矩形。</span>

<span>这个灰色矩形将要成为登录页面的载体。在选中左边菜单栏中的 _Login Screen_ 前提下，查看右边的“ Properties ”菜单。关注一下“ Appearance ”栏，点击这个栏目右边的“ + ”小图标来选择我们刚刚从 Sketch 导出的 _Login Screen_ 图片。</span>

![](http://ww4.sinaimg.cn/large/a490147fgw1f41trxrhhpj20ke0egjsu.jpg)

## Can you field the pain?!

<span>现在我们要加入文字框了，再一次点击“ Add a layer ”，然后我们能得到一个相同的灰色格子。这个格子的尺寸要和我们从 Sketch 项目中导出的 _email text field_ 的尺寸相同，对我来说尺寸是 328 x 48 。使用右侧的“ Properties ”菜单的“ Size ”栏来调整尺寸大小。同样，我们也使用 Sketch 中的定位，我的 _email text field_ 的x坐标为16，y坐标为296。然后把这些输入 Pixate 右边菜单中的 “ Position ”栏中。最后，我们像刚才对 _Login Screen_ 那样加载从 Sketch 导出的 _email text field_  图片。</span>

<span>我们需要移动 _email text field_ 使它成为 _Login Screen_ 的一部分。在左边“ Layers ”菜单中点击并且拖动 _email text field_ 放置到  _Login Screen_ 上面，然后 _email text field_ 就成为了 _Login Screen_ 的一部分并且能被看到了。</span>  
![](http://ww2.sinaimg.cn/large/a490147fgw1f41tsa8p9tj20ke0eg75g.jpg)

<span>但是！球多麻袋！EMAIL 输入框中那个丑陋的灰色线条是干嘛的？</span>

<span>好吧，当我们选择从 Sketch 中导出的 _email input field_ 资源时，我们没有从我们的层上去掉灰色背景。让我们选中 _email input field_ ，看一下右边“ Properties ”菜单中的“ Appearance ”栏。在靠近你导出的 _email input field_ 名字旁边有一个灰色小格子（译者注：_email input field_ 名字左边那个），点击一下然后弹出一个颜色调色板，我们需要选择透明色，就是左上角中间有个红色对角线的那个。嗒哒！然后灰色线条就被去掉了。要记得每次导入图片都要做这些噢。</span>

<span>我假定聪明的你已经意识到我们要对 _Login Screen_ 的其余组件都这样操作，包括 _login button_ ， _raised login button_ ， _email text field with input_ 和 _password text field_。 </span>

<span>在你昨晚这些应该做的事情之后，你会看到如下的界面：</span>

![](http://ww3.sinaimg.cn/large/a490147fgw1f41tsocpvfj20ke0egdh2.jpg)

<span>你可以看到我加入的每样东西都属于 _Login Screen_ 层。</span>

<span>接下来你需要把已经填充好的栏目加进来。最简单的方法就是点击我们想要加入填充状态的输入框所属的层。然后点击“ Layers ”菜单顶部的“ Duplicate layer ”按钮。这将给你选择的东西创建一个拷贝。所以让我们对 _email text field with input_ 执行上述操作。在拷贝好之后,你需要点击并且拖动它确保它位于 _email text field_ 下面。然后你可能需要翻看你的 Sketch 项目找出正确的大小和位置，从而修改它的尺寸确保它不会超出规模，然后还要把它移动到合适的位置。</span>

<span>一旦你已经把这些层放置到它们空白的相对应处，那就应该点击眼睛图标来隐藏它们，就像我们在 Sketch 做的那样。最后一件你应该做的事情是用右边属性菜单中的“ Opacity ”给 _email text field with input_ 和 _password text field with input_ 设置透明度为 0%。这样做的原因是当我们最终使用 Pixate 应用加载这个项目的时候它们是不可见的，所以在 Pixate Studio中没有必要花费注意力在这些层的可见性设置上。</span>

![](http://ww2.sinaimg.cn/large/a490147fgw1f41tt3hbjvj20ke0eggmv.jpg)

<span>正如上面的截图，我加入了一些带有输入的栏目但是它们被隐藏了。现在我们搞点有趣的事情 —— 动画 :D 。</span>

## 让输入框动起来 (我想不出有趣的题目了)

<span>现在让我们给登录界面加入一些动画。我们从文本框开始，然后再弄按钮。</span>

<span>在左边“ Layers ”菜单下面是两个格子 —— “Interactions” 和 “Animations”。这两个格子各自包含了不同的互动和动画。互动有类似“ Tap ”（打开）和“ Drag ”（拖动）。动画有类似“ Scale ”（缩放）和“ Move ”（移动）。为了使用它们，我们需要把它们拖动到我们想要互动和动画发生的层上面，真是简单好用。</span>

<span>让我们从 _email text field_ 开始吧。 在左边选中它，然后从“ Interactions ”（互动）格子中点击并拖动“ Tap ”（打开），并且把它丢到 _email text field_ 层上面。接下来我们需要 “ Animations ”（动画）格子里面的“ Fade ”（渐隐），像对_email text field_操作那样点击并拖动它。你应该能在右边“ Properties ”（属性）菜单中的“ Interactions ”（互动）下面能看到一个小的 Tap （打开）按钮，在Animations ”（动画）下面看到“ Fade ”（渐隐）。</span>

<span>我们现在想要设置当我们点击 _email text field_ 时使其渐隐。在右边菜单“ Fade ”（渐隐）下点击“ Based On ” （基于）并且选择 _email text field_ 。这时会弹出更多的选项，你可以研究一下，不过我们这里只关心“ Fade to ”（渐隐），点击格子并输入 “ 0 ”。</span>  

![](http://ww3.sinaimg.cn/large/a490147fgw1f41ttixjxnj20ke0egjt2.jpg)

<span>你快要能够见证你的第一个动画了，现在你仅仅需要在你的设备上运行 Pixate 应用。</span>  

## 在你的设备上设置 Pixate 

<span>确认你已经下载 Pixate 应用到你的 [Android](http://bit.ly/1Wp5wuG "Pixate Android App") 或者 [iOS](http://apple.co/1qdImcZ "Pixate App iOS") 手机上了。</span>

<span>打开 Pixate 应用。这个应用会从网络上查找你的 Pixate Studio ，所以稍等一下并且确保你已经连接 WiFi 了。 Pixate 应用有时对我不太友好，所以你可能需要退出并且从新进入它。你也可以通过 IP 地址连接。</span>

<span>当你的电脑有东西出现的时候，点击它。在 Pixate Studio 的右上角点击“ Devices ”。你能看到你的手机被列出在这里，你需要允许连接所以点击一下然后你的设备就被连接了。检查一下你的设备，你的电脑应该在顶部被列出了。点击它，然后你就能看到你的这些原型了。你应该看到“ Material Design Prototype ”（这取决于你给它的命名），点击它。现在你将被展示一些关于当你使用你的原型时如何与你的设备进行互动的指示。点击“ Get Started ”，然后你现在应该能看到登录页面了！更棒的是如果你现在点击 _email text field_，它将会渐隐然后从你的眼前消失了。</span>

## 创建更多的动画

<span>好的，现在我们要结束这些的动画了。当我点击  _email text field_ 时变得空白并不好。点击 _email text field_ _with input_ ，并且从动画格子中点击并拖动“ Fade ”然后丢到它上面。当你在“ Fade ”下面的“ Based on ”点击第一个下拉格子时，确保你选择了 _email text field_。我们想要展现的效果是当 _email text field_ 渐隐时， _email text field with input_ 出现。在“ Fade to ”里面输入100。</span>  
![](http://ww1.sinaimg.cn/large/a490147fgw1f41wtvuc3qj20jp0ci75p.jpg)

<span>我们实际上是在说，当 _email text field_ 被点击时，它渐变到0，并且 _email text field with input_ 渐变到100。这有点像“如果这样，然后那样”。/span>

<span>现在，如果你回到你的设备，Pixate 应用应该已经刷新了，因为它会自更新。现在如果每样事情都被设置正确了，那么当你点击 _email text field_ 时，它应该能渐隐然后 _email text field with input_ 应该会出现。</span>

![](http://ww4.sinaimg.cn/large/a490147fgw1f41wt2s6lmg20ba0k0tca.gif)

<span>现在你需要对 _password text field_ 和 _password text field with input_ 重复这些过程。/span>

## 点击按钮！让登录按钮动起来！

<span>接下来我们要给登录按钮做动画。我们想要的效果是，当你点击按钮时，它抬起然后跌落，就像在真实设备上那样。这给原型添加了一个不错的现实主义的层（译者注：即仿真程度高），如果你想要做一个快速原型，你大可不必做这些，仅仅让这个按钮打开下个界面即可。不过我们这里是在研究 Pixate，所以让我们继续做吧。</span>

<span>首先你需要把 _login button_ 和 _login button raised_ 加到项目里面。这两个在左侧菜单的层级关系里都隶属于 _disabled login button_ ，并且确保它们俩透明度都为0。 </span>

<span>当你添加 _login button_ 和 _raised login button_ 时，你可能发现它们有些破碎的感觉。你需要注意的是阴影。不像 Sketch 那样忽视了阴影，Pixate 把阴影算做了图像的一部分。</span>

<span>这里是我关于登录按钮的设置</span>

*   <span>x = 14pt</span>
*   <span>y = 471pt</span>
*   <span>width = 332pt</span>
*   <span>height = 40pt</span>

<span>还有抬起状态的按钮:</span>

*   <span>x = 8pt</span>
*   <span>y = 465pt</span>
*   <span>width = 344pt</span>
*   <span>height = 58pt</span>

这些按钮相互直接应该可以直接替换并且还要给阴影留出空间。

<span>我们需要设置一些条件使 _disabled login button_ 消失。我们想要使它在 _email_text_field_ 和 _password_text_field_ 都被点击并且 _email_text field with input_ 和 _password text field with input_ 都出现的时候消失。如何做呢？好的，当你在 Pixate 中加入一个动画时，你可以指定这个动画发生的条件。条件的编写就像写代码，所以程序员可能会用到这个，但是对于其他人就容忍我吧，并且我们将完成它 :) 。/span>

<span>点击并且拖动“ Fade ”动画到 _disabled login button_ 上。现在给 _email text field_ 设置“ Based on ”。当你完成这些弹出的额外选项时，我们来关注一下“ If ”栏目，如果你点击它旁边的问题标志图标，你会得到一个通篇解释，关于这是做什么的和你想要知道的关于层的所有属性。</span>

<span>我们的条件是什么？我们想要去检查，如果 _password text field_ 不再可见，就使 _disabled login button_ 渐隐。正如我们所知道的，如果 _password text field_ 不再可见，那么 _password text field with input_ 就必须可见。</span>

<span>你需要在“ If ”格子里输入这个条件声明：</span>

<span>    password_text_field.opacity == 0</span>

<span>我们加了下划线，因为如果你的层名带空格的话， Pixate 会自动给我们的" Layer ID "加下划线。</span>

<span>We check for the visibility using the opacity property on the _password text field_ layer and checking it’s set to 0.</span>

<span>Now if you go back to your prototype on your device and press the _password text field_ and then the _email text field_, the disabled button should disappear!</span>

<span>We have to add another fade out animation now. This is check in case the _email text field_ is faded out when the _password text field_ has been pressed. This is typically how the prototype would operate normally.</span>

<span>You’ll need to do what we did before, but with the opposite settings. I’ll get you started, you need to click and drag ANOTHER “Fade” animation to the _disabled login button_. I’ll let you figure the rest out ;)</span>

<span>Right if all goes well, then your _disabled login button_ should now disappear when both the _email text field_ and _password text field_ are no longer visible. Now we need to make the _login button_ visible. This will be just another simple fade in animation.</span>

<span>We basically need to do the same as we did for the _disabled login button_, but we want the opacity to be 100 instead of 0 for both fade animations. I’m sure you can do this by now, but once again I’ll get you started. You need to drag a “Fade” animation to the _login button_. And remember to add the conditions in!</span>

<span>Ok, so you should now have something that looks like this:</span>

![](http://ww1.sinaimg.cn/large/a490147fjw1f41vs6l528g20ba0k0q89.gif)

## ARISE SER BUTTON!

<span>The very last thing we need to do is make our _login button_ 'raise' when pressed; just like what happens normally with a button in Lollipop onwards. As you can see in the example of the Fantasy Football Fix login screen, the “Upload Squad” button seem’s to magnetise to your finger as you press the button, with the shadows increasing.</span>

![](http://ww2.sinaimg.cn/large/a490147fjw1f41vufzbuyg20ba0k0gtk.gif)

<span>We're going to be making use of the _raised login button_ obviously. Firstly, drag a “Tap” interaction to the _login button_ as we need to know when it’s been pressed. Then we’re going to need two fades again for this so drag two over to the _raised login button_.</span>

<span>The first fade needs to be triggered when the _login button_ is tapped, so make sure the _login button_ is selected in your “Based on” field. We want this first fade to make our raised button appear so set the opacity to 100\. We should probably name our fade as well, so we know what they are doing. Name it “Fade in on Login Button tap”.</span>

That should make our button appear and seemingly rise, but if you click the _login button_ now, the _raised login button_ will appear and will stay there. We need it to disappear again to go back to our original _login button_, so we’re back in our resting state.

<span>For this we need another “Fade” animation. Name this new one “Fade out after Rise”. This too needs to be based on the _login button_ tap. This one though we want to fade to 0%. Lastly. we need to set the “Delay” to “0.2”. This is so that we wait to fade the button back out, otherwise you won’t even see the button, as we’d be fading in and fading out at the same time.</span>

<span>Now if you tap your _login button_ you should get the nice raised effect!</span>

<span>![](http://ww1.sinaimg.cn/large/a490147fgw1f41web91qbg20ba0k0dlb.gif)</span>

<span>If you want to get a bit more fancy you can fade the _login button_ in and out too when it’s tapped but I’ll leave that to you as an extra task ;) A by product of this will be a slight flash so it looks like the button’s been tapped. Also note this will not look that great if you do not have the _login button_ and _raised login button_ both lined up correctly in Pixate so make sure you have that sorted.</span>

## We got there, eventually!

<span>So that concludes this second meaty part of this series. I understand this was a lengthy process, but that’s just because of the sheer amount of instructions I had to write. Once you’ve done this once then you’ll always have it for reference. My advice would be to make loads of little sample projects, so that say if you need to remember how to do a raised button you can just open that project and see everything laid out nice and simply. As you get further into the prototype process things can start to get a bit busy in the project and you may not be able to easily locate the specific action/sequence of events.</span>

