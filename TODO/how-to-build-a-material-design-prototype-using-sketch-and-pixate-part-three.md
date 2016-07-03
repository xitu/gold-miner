>* 原文链接 : [HOW TO BUILD A MATERIAL DESIGN PROTOTYPE USING SKETCH AND PIXATE - PART THREE](http://createdineden.com/blog/post/how-to-build-a-material-design-prototype-using-sketch-and-pixate-part-three/?utm_source=androiddevdigest)
* 原文作者 : Mike Scamell
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Hugo](https://github.com/xcc3641)
* 校对者: [Zheaoli](https://github.com/Zheaoli),[阿宅](https://github.com/rockzhai)


<span>在本系列的 [Part 2](https://gold.xitu.io/entry/574eb491d342d300434cec1c) 我们已经将在 Sketch 中完成的作品导入到了 Pixate ，并且新建了一个简单的登陆原型。 </span>

<span>最后在这个总结性的第三部分,我们将进一步深入，同时将会作出一个更细致的原型。 开始之前，你应该已经完成了 [Part 1](https://gold.xitu.io/entry/574d062b2e958a0069335d8e) and [Part 2](https://gold.xitu.io/entry/574eb491d342d300434cec1c) , 如果没有的话，先去看看这两篇内容吧.</span>

我已经上传了你在 Part 3 里所有需要的 [Sketch 资源](https://www.dropbox.com/s/6ykfx9gukoacgp0/Material%20Design%20Prototype%20Assets.sketch?dl=0 "Material Design Prototype Sketch Assets") , 你要做的就是将它们导出来。记住，一定要按照 3x 方式导出，这样在手机上显示效果不错。 随意按照你喜欢的方式去修改它们，只要尽力保证大小相同，这样在这次教程中所用到的尺寸才能是正确的。

## 让我们 drawer 点灵感

首先，往我们的原型加入一个 navigation drawer 。 [navigation drawer](https://www.google.com/design/spec/patterns/navigation-drawer.html "Navigation Drawer") 是如今常见的设计样式，虽然某些时候开发者在利用它的时候会出现一些错误，但是它依旧被广泛的使用。

通过点一下显示在菜单层的眼睛来隐藏登陆界面。新建一个新的画布，取名为“ Navigation Drawer ”。就像在 Sketch 里一样的尺寸 340x640。与登陆界面有 36 像素的 padding 值。这样我们才可以将 drawer 滑出。_Navigation Drawer_ 会占据 _Login Screen_ 左边页面空间，所以我们才可以将它滑出和滑进。_Navigation Drawer_ 画布的 X 轴应该是 -304。这样才能保证我们操作的区域可以被滑动。当然，一定改变这个画布的 “ Appearance ” 为透明的或者让_Navigation Drawer_ 的右端有一个灰色横条。最后，将 " Nav Drawer with 36dp drag area " 图片导入这个画布。

现在有 drawer 在面板上了，我们可以加上 “Drag” 交互，让它可以被滑动或者拖动。点击并且拖出 “Drag” 交互作用在 _Navigation Drawer_ 画布（译者注：联想下 Android Studio XML 那里的 Design 拖拽添加布局），你会看到“ Drag ” 在右侧菜单的 “ Interactions ” 属性里。

现在让我们配置一下“ Drag ”交互。我们仅仅想要 _Navigation Drawer_ 水平移动，所以我们得在“ Move w/Drag ”菜单选择“ Horizontal ”，然后我们再设置一个 _Navigation Drawer_  向右移动的最大值。如果我们不这样做，就可以将 drawer 一直拖出屏幕。在第一个参考建议里，我们应该确保已经选择了 “ Left ” 并且输入了 “-304” 在 “ Min position ” 输入框里。这样才可以保证 drawer 不会移到屏幕我们无法拖动的位置。第二个参考建议里，首先选择 " Right " 然后输入 "340" 到 " Max Position "。当我们拖动的时候，_Navigation Drawer_ 的 X 轴达到 340 时就会停住。如果以上都做好了，你应该会看到这样的画面：

![Prototype with Navigation Drawer](http://createdineden.com/media/1771/part-3-image-2.png?width=750&height=497)

## 画出来

我们将会加更多的特性给 _Navigation Drawer_ 。它会自动的离开屏幕，意味着我不需要一直拖着它到左侧。

![Put back in place properties](http://createdineden.com/media/1760/part-3-image-13.png?width=306&height=416)  
我们需要一个 “ Move ” 动画，将它拖拽放到 _Navigation Drawer_ 上。我们再给这个交互取个名字，让我们更清晰地知道这个是做什么的。取个 “ Put back in place ”。这个 “ Move ” 需要在 _Navigation Drawer_  “ Drag Release ”基础上。当用户停止拖拽的时候，就会触发该动作。我们的动画得设置为 “ With duration to final value ”。现在看看我们的 “ IF ”条件，如果 drawer 小于 340 我们就希望 drawer 开始动画移出屏幕。接下来，我们需要设置好在哪里我们希望 drawer 开始 “ Move ” 动画。选择 “ Left ” 然后在参数输入框里输入 "-304"。最后，为 “ Easing Curve ” 选择 " ease out " 并且选择默认类型为 “ quadratic ”，这会让我们的 drawer 移动更加自然。

好，让我们来测试一下。

![](http://ww4.sinaimg.cn/large/a490147fgw1f4i39fizqwg205m0a0gre.gif)

当我们往右拖 drawer ，最终会留出一定距离（之前设置的 padding），当我们往左拖一点点就可以让它移除屏幕。使它像一个真实的 navigation drawer 你还有很多可以做的，你就下去自己实践吧。

## 首页

好，让我们来创建 _Home Screen_ ，它包含了两个 tabs，_Versions_ 和 _In Words_。_Versions_ 页里有一个可滑动的列表页，_In Words_ 页里会有一个关于甜点的文章。

首要任务先从 Sketch 中导出 _Home Screen_ 的资源，同样需要 3x 格式。如果你没有的话，你需要这些：

*   <span>app and status bar</span>
*   <span>versions tab selected</span>
*   <span>in words tab selected</span>
*   <span>tab indicator</span>
*   <span>Version List</span>
*   <span>In Words Content</span>

回到 Pixate 然后导入这些资源。

现在我们需要新建一个画布，命名为 “ Home Screen ”，将它的大小改成与 _Login Screen_ 一样，360x640。确保新的画布包含整个 _Login Screen_ 画布，不然待会出现问题。

现在我们新建一个名为“ App and Status Bar ”的画布，这个为 _Home Screen_ 画布的一部分，添加“ app and status bar “ 从 Sketch 导出的图片作为 properties menu ，设置它的尺寸为 360x136 并且与顶部对齐。为什么作为 Sketch 文件高度是 136 而不是 128？现在我们需要对 Sketch 缺少的阴影做点解释，将颜色设置为透明，这样我可以避开任何背景，将灰色阴影渗出。然后你会得到一个这样的：
![Prototype with newly added Home Screen](http://createdineden.com/media/1770/part-3-image-3.png?width=750&height=476)

## 加入 Tab

现在我们得到了 tabs ，并且实现了在它们之间切换的功能。

我们需要两个画布，尺寸都是180x48，一个取名为“ Versions Tab Selected ” ，另一个为“ Background Tab Selected ”。确保它们都是 _Home Screen_ 画布的子集。_Versions Tab Selected_  放在 (0，80) 的位置，_Background Selected Tab_ 放在 (180，80)。

![Prototype with tabs added](http://createdineden.com/media/1769/part-3-image-4.png?width=751&height=477)

我们忘记了一件事情，tab 的焦点。新建一个画布，取名为 “ Tab Indicator ” ，尺寸设为 180x2 并且保证是_Home Screen_的子集，_Home Screen_ 这层应该是所有层的最外层，在 _Versions Tab_ 和 _Background Tab_ 之上。这样它才可以在顶部绘制，我们才可以看到它。然后你需要导入“ tab indicator ” 图片，放在(126,0)位置。
![Prototype with tab indicator](http://createdineden.com/media/1768/part-3-image-5.png?width=735&height=462)

## 焦点的动画

好，现在我们设置好了像一个真实 app tabs 运作需要的里所有部件。现在我们想做的事是当点击 tab 后，焦点能够移动到对应的 tab 下。现在我们从 _Background Tab_ 开始。

给 _Background Tab_ 添加一个 “ Tap ” 交互，我们将会基于这个 “ Tap ” 交互配置 _Tab Indicator_ ，为 _Tab Indicator_ 添加 “ Move ” 动画，命名为“ Move on Background tap ”，这样可以让我们清楚这个是做什么，在“ Based On ”下拉框里选择“ Background Tab ”，下面的“ Move To ”设置里，我们选择为“ Right ”并且输入参数 “360”，这个会移动 _Background Tab_ 下的焦点。接下来，为了让 tab 的运动更加自然，我们在 “ Easing Curve ” 设置里选择“ ease out ”，离开设置为“ quadratic ”。最后的一件事情，我们需要更改“ Duration ” 的参数为 “0.1”，像一个真实的 tab 焦点一样移动快速。这里就是你需要设置成的样子：

![Tab Indicator movement settings](http://createdineden.com/media/1767/part-3-image-6.png?width=306&height=451)

这样设置后，我们会看到：

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i3eljw7yg205m0a0dg4.gif)

现在我们需要为 _Versions Tab_ 被点击后让 _Tab Indicator_ 移动回去。只需要用 _Versions Tab_ 重复之前的过程。这个将留给你们作为练习，一定要记住，给 _Versions Tab_ 添加 “ Tap ” 交互效果，否则你将看不到“ Based On ”的下拉选择框。完成后，你将会得到一个响应你每次点击 tab 的 tab 焦点。

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i3h4kcv9g205m0a074x.gif)

## 看我上下滚动

现在让我继续添加一个可滚动的列表给我的 app。我们已经得到了导出的 “ Version List ”  资源，所以让我们马上开始吧。

新建一个“ Version List ”画布，放在 _Home Screen_ 画布下，尺寸设置为 360x1232。这会导致它比屏幕要长，但是别担心这个， Pixate 会帮我们解决。将 _Version List_ 放在 toolbar 下面， 滑出内容会被 toolbar 遮盖。
![Prototype with Version List added](http://createdineden.com/media/1766/part-3-image-7.png?width=750&height=500)  

现在我们赋予 list 滚动的能力。你可能会想我们只需要给 _Version List_ 添加一个“ Scroll ” 交互就可以了，但是我们其实要做的事情是去指定一个可以滚动的区域。

首先让我简单的隐藏 _Version List_，先新建一个画布 “ Scroll ” 处于 _Home Screen_ 画布下。该画布从 app bar 和 tabs 下开始并且充满直到底部。它的尺寸为 360x512，x=0，y=128。你将会看到屏幕上有一个灰色的框，现在将 _Version List_ 放进 _Scroll Content_ 画布里。还原 _Version List_ 回到之前的样子。现在如果你运行这个原型，你可以上下滚动 _Version List_ 。

![](http://ww3.sinaimg.cn/large/a490147fgw1f4i3o07r4rg205m0a0qb9.gif)

## 切换 Tabs

到目前为止，我们已经得到一个功能上还行的原型，但是我们还忘了给 tabs 添加切换能力。现在我们来做。

我们在 _Home Screen_ 画布下新建一个“ In Words ”画布，将它放在 _Home Screen_ 的右边并且设置尺寸为360x512。将“ In Words Content ”图片添加进当前画布，然后你会得到：

![Prototype with In Words content](http://createdineden.com/media/1765/part-3-image-8.png?width=750&height=495)

我们现在需要新建一个画布作为我们的 ViewPager。它可以通过一个简单的滑动像一个真实 app 一样，从屏幕边缘实现一个 tab 移动到 另一个 tab。该画布应该是在整个画布系统中的最底端。它同样需要被 _In Words_ 和 _Scroll Content_ 添加，这样它才知道哪些内容是可以被移动的。
![Layer hierarchy](http://createdineden.com/media/1773/screen-shot-2016-05-24-at-113710.png?width=280&height=248)  


给 _View Pager_ 画布添加“ Scroll ”交互，这“ Scroll ”菜单中有一个“ Paging Mode ”属性，确保你在下拉框中选择了“ paging ”。如果这些都是设置好了，现在就可以滑动屏幕啦！

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i3qpkr60g205m0a0gsi.gif)

## 滑动中移动 tab 焦点

我们忘记了一件事情，我们还需要在滑动屏幕时，同时移动 tab 焦点，这样才能完成 _Home Screen_ 。

给 _Tab Indicator_  添加 “ Move ” 动画，取名为” Move on Swipe Left “。按照下面图片进行设置：

![Tab Indicator left movement settings](http://createdineden.com/media/1764/part-3-image-9.png?width=306&height=447)

好，我们将该运动建立在当前 _View Pager_ 下的 tab上，并且当滚动停止的时候，我们才活动。在我们的“ IF ” 部分我们会检测如果我们已经与开始的 X 轴坐标移动了 360 ，这样我们会切换到浏览下一个 tab。当生效后，我们希望往左移动到 180 ，将焦点放在 _In Words_ tab 下。接下来，为了像之前一样得到一个自然的运动，我们会改变“ Easing Curve ” 为“ ease out ”。最后，我们将改变 duration 为 0.1，尽可能地让 tab 快速移动。

现在如果你滑动屏幕，tab 也会跟着移动了。

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i3xx41irg205m0a0q8k.gif)

现在你需要做的就是颠倒下这个过程，当你右滑时，tab 返回。这个会留给你们进行练习，我会给你们 "IF" 条件的提示：

<span>    view_pager.contentX == 0</span>

当你搞定了后，你的 _Tab Indicator_ 应该跟随着你滑动。

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i3zyhs8lg205m0a0guf.gif)

## Finishing Touches

现在我们来给 _Login Screen_ 切换到 _Home Screen_ 提供一个透明切换效果。你应该把它放在 _Home Screen_ 画布的上方，使 _Login Screen_ 在 Pixate 中可见。

![Prototype with Login Screen back in](http://createdineden.com/media/1763/part-3-image-10.png?width=749&height=499)</span>

当用户摁下登陆按钮时，我们添加一个简单的 scale 动画。为 _Login Screen_ 画布添加一个 “ Scale ” 动画，确保它作用于整个 _Login Screen_ 画布，并不是某个部分。按照以下要求设置动画：
![Login Screen scale settings](http://createdineden.com/media/1762/part-3-image-11.png?width=305&height=452)</span>

只有当用户已经完成了两个输入框的操作后，点击登陆按钮才会触发这个动画。我们通过因素和相连的X和Y进行缩放（因为我们想要均匀的缩放效果）。我们设置 “ Scale ” 到“0x”，意味着 _Login Screen_ 将会消失，然后我们设置“ ease out ” 和  “ Duration ” “0.3”，防止动画执行过快。

现在我们可以看到:

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i41gcndwg205m0a0wi2.gif)

最后，确保 _Navigation Drawer_ 不能在 _Login Screen_ 页面被滑出。我们需要这样设置:
![Navigation Drawer fade in settings](http://createdineden.com/media/1761/part-3-image-12.png?width=305&height=411)</span>


在 _Navigation Drawer_  的 “ Properties ”菜单减少它的“ Opacity ” 到 “0%”。这样将不会在 _Login Screen_ 被滑出了。接下来，给 _Navigation Drawer_ 画布添加一个 “ Fade ” 动画，就像之前给 _Login Screen_ 设置的缩放动画一样，我们想要这个 fade 动画同样在摁下登陆按钮后触发，同时设置为100%，这样才可以完整的看到 _Navigation Drawer_。我们延后0.3秒执行这个动画，这样 _Login Screen_ 可以完整执行缩放动画。

最后一步！如果之前所有都没有问题，你将可以展示一个简易的 material design 的原型 app。
![](http://ww4.sinaimg.cn/large/a490147fgw1f4i43y44jwg205m0a0tcd.gif)

## 最后

我希望你喜欢这个教程系列，你还可以在 Sketch 和 Pixate 上做很多事情来提示你的水平。如果你真的特别喜欢使用这些工具，我特别希望你可以去找更多的关于它们的教程。你可以做以下事情去完善这个原型：

*   <span>在 Navigation drawer 里实现多页面，比如退出按钮。</span>
*   <span>多屏幕适配</span>
*   <span>完善登录页的消失动画</span>
*   <span>完善 Navigation Drawer 移动，比如拖到一半的时候就打开</span>
*   <span>利用在 Sketch 资源文件中的未被选择的 tabs 显示在当 tab 没有被选择时</span>

如果你完善了原型或者对该教程想到了更好的点子，务必联系我，让我知道。我会特别高兴知道你想到的东西，在 twitter 上找 [Eden](https://twitter.com/CreatedInEden "Eden") 。

感谢花时间学习这个教程系列。
Good luck with Sketch and Pixate!
