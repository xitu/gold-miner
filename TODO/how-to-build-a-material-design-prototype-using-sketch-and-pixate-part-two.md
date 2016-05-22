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

<span>
Once you’ve got these layers below their empty counterparts you should click the eye icon to hide them, just like we did in Sketch. The last thing you should do is set the “Opacity” in the right hand properties menu for the _email text field with input_ and _password text field with input_ to 0%. The reason for this is so that they are not visible when we finally load the project using the Pixate app, as it doesn’t pay attention to the visibility set for the layer in Pixate Studio.</span>

![](http://ww2.sinaimg.cn/large/a490147fgw1f41tt3hbjvj20ke0eggmv.jpg)

<span>As you can see in the screen shot above i’ve added the fields with with input but they are hidden. Now let’s get to the good stuff. Animating :D</span>

## Animating the field inputs (because I couldn't think of a funny title)

<span>Now lets add in some animations for our login screen. We’ll start with the text fields and come to the button later.</span>

<span>Below the “Layers” menu on the left hand side are two boxes, “Interactions” and “Animations”. Each contain different Interactions and Animations. Interactions has things like “Tap” and “Drag”. Animations has things like “Scale” and “Move’. To use them, we need to drag them to layer upon which we want the interaction or animation to happen. Nice and simple.</span>

<span>Lets start with the _email text field_. Select it from the left hand side, and then click and drag the “Tap” from the “Interactions” box and drop it onto the _email text field_ layer. Next we need “Fade” from the “Animations” box. Click and drag this as well to the _email text field_. You should see a little Tap icon on the right in the “Properties” menu under the field “Interactions” and “Fade” under the heading “Animations”.</span>

<span>We’re now going to get the _email text field_ to fade out when it’s been clicked on. Under the “Fade” on the right hand menu click “Based On” and choose _email text field_. More options should open up below that you can explore but we’re only interested in one, the “Fade to”. Click on the box and enter “0”.</span><span>  
![](http://ww3.sinaimg.cn/large/a490147fgw1f41ttixjxnj20ke0egjt2.jpg)

<span>We’re nearly there where you can witness your first animation! Now we just need to get the Pixate app setup on your device….</span>  

## Setting Up Pixate on your Device

<span>Make sure you have the Pixate app downloaded on to your [Android](http://bit.ly/1Wp5wuG "Pixate Android App") or [iOS](http://apple.co/1qdImcZ "Pixate App iOS") phone. </span>

<span>Open up the Pixate app. The app will start looking for you Pixate Studio on the network so give it a sec and make sure you're connected via WiFi. The Pixate app is sometimes a bit flippant for me and you may possibly need to exit it and re-enter. You can also connect via IP address.</span>

<span>When your computer appears, click on it. In Pixate Studio in the top right hand corner click on “Devices”. You should see your phone listed here and you have to approve the connection so click the tick and your device should be connected. Check your device and listed at the top should be your computer. Click it and you should be shown your prototypes. You should see “Material Design Prototype” (depending on what you've called it), click it. You’ll now be presented with some instructions of how to interact with the device when your using your prototype. Click “Get Started” and you should now see your Login Screen! What’s even better is if you now click on the _email text field_ it should now fade and disappear before your very eyes…</span>

## Creating more animations

<span>Right, so now we have to finish this animation off. Empty space when we click the _email text field_ is no good. Click on the _email text field_ _with input_, and then click and drag “Fade” from the animations box and drop it on it. When you click on the first drop down box for “Based on” under “Fade” make sure you select _email text field_. What we’re going to do is make the _email text field with input_ appear as the _email text field_ fades out. Under “Fade to” enter “100”.</span><span>  
![](http://ww1.sinaimg.cn/large/a490147fgw1f41wtvuc3qj20jp0ci75p.jpg)

<span>What we’re effectively saying is, when the _email text field_ has been tapped, then fade it to 0 and fade the _email text field with input_ to 100\. It’s a bit, "if this, then that".</span>

<span>Now if you go back to your device, then the Pixate app should flash as it updates itself. Now if everything is setup correctly, when you click the _email text field_, it should fade out and the _email text field with input_ should appear.</span>

![](http://ww4.sinaimg.cn/large/a490147fgw1f41wt2s6lmg20ba0k0tca.gif)

<span>You now need to reproduce these steps to do the _password text field_ and _password text field with input_.</span>

## Push the button! Animating the Login Button

<span>So the last thing we need to animate is the login button. What we want to happen is that when you click on the button, it raises and then lowers, just like it would on a real device. This adds a nice layer of realism to the prototype. If you’re trying to do a really quick prototype, then maybe you’d leave this out and just have a button that activates the next screen. But we’re exploring Pixate so we’re going to do it.</span>

<span>First you need to add the _login button_ and _login button raised_ to the project. These should both be below the _disabled login button_ in the left hand menu hierarchy and make sure that both opacities are set to “0”.</span>

<span>You may notice when you add the _login button_ and _raised login button_ that they may look a bit squashed. What you need to account for is the shadow. Unlike Sketch, which ignores the shadow, Pixate counts it as part of the image.</span>

<span>Here’s my settings for the login button:</span>

*   <span>x = 14pt</span>
*   <span>y = 471pt</span>
*   <span>width = 332pt</span>
*   <span>height = 40pt</span>

<span>And raised login button:</span>

*   <span>x = 8pt</span>
*   <span>y = 465pt</span>
*   <span>width = 344pt</span>
*   <span>height = 58pt</span>

This should place the buttons all directly above each other and have room for the shadow.

<span>We need some condition for the _disabled login button_ to disappear on. We want it to disappear when both our _email_text_field_ and _password_text_field_ have both been tapped and the _email_text field with input_ and _password text field with input_ have both appeared. How do we do that? Well when you add an animation in Pixate you can also specify a condition upon which that animation can happen. The condition is written just like in code, so coders out there will be used to this but for the rest bear with me and we’ll get through it :)</span>

<span>Click and drag the “Fade” animation to the _disabled login button_. Now set the “Based on” to _email text field_. When you’ve done this the extra options should pop up. We’re interested in the “If” field. If you click the question mark icon next to it then you’ll get a through explanation of what this does as well as all the properties that you can check for on each of your layers.</span>

<span>What’s our condition? Well we want to check that if the _password text field_ is no longer visible thenfade out the _disabled login button_. We do this as we know that if the _password text field_ is no longer visible, then the _password text field with input_ must be showing.</span>

<span>You’ll need to enter this conditional statement in the “If” box:</span>

<span>    password_text_field.opacity == 0</span>

<span>We add the underscores as Pixate automatically add's them to our "Layer ID" when you name you layers with spaces.</span>

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

