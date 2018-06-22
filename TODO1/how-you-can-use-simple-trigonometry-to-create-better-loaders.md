> * 原文地址：[How you can use simple Trigonometry to create better loaders](https://uxdesign.cc/how-you-can-use-simple-trigonometry-to-create-better-loaders-32a573577eb4)
> * 原文作者：[Nash Vail](https://uxdesign.cc/@nashvail?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-you-can-use-simple-trigonometry-to-create-better-loaders.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-you-can-use-simple-trigonometry-to-create-better-loaders.md)
> * 译者：[DM.Zhong](https://github.com/zhongdeming428)
> * 校对者：

# 怎样使用简单的三角函数来创建更好的加载动画

最近在研究登录页面的时候，我偶然进入了一个网站。对于使用这个网站的人而言非常棒也非常有用。这个网站上的一个小细节虽然吸引了我的注意力，但是我却不那么轻松。

![](https://cdn-images-1.medium.com/max/800/1*i-AvsEyZqhaQ9aK5huIv6A.gif)

Nooooo！

注意这个，圆圈们不太自然的抖动以及不那么流畅的运动让我有了写这篇文章的想法。

这篇文章所要做的一件事就是使用基础三角函数的概念重新创建一个上方加载动画的更加流畅的版本。我知道这听起来可能很奇怪，但是相信我，这将会非常有趣。你会被加载器工作起来所需要的代码量之小所惊讶到。而且，弄懂这篇文章根本不需要你是一个数学天才，甚至不需要你懂三角函数，我会解释所有的一切。

下面是我们要做的事情！

![](https://cdn-images-1.medium.com/max/800/1*DPzqs50u_Pl09acuSu1jpQ.gif)

很流畅！

### 让我们开始吧

我们所要实现的加载器实际上是由三个小圆周期性的上下运动所组成的，每一个的运动都与其它两个不同步。

让我们把它分解成多个部分，首先，我们会得到一个小圆流畅地周期性地上下运动。我们稍对剩余的部分进行分析。

欢迎你随时进行编码。

#### 1. 给小圆定位

![](https://cdn-images-1.medium.com/max/1000/1*78yw0Ivdxm-bcrmSvbTYkg.png)

上面的代码在 `<svg>` 元素的中间画了一个小圆。

![](https://cdn-images-1.medium.com/max/800/1*lcafSsoXqgg7mmAhB6jG9g.png)

图1：SVG 输出的非实际示意图

让我们理解一下它是怎么实现的。

`width` 和 `height` 属性使我们想要的实际尺寸。简单起见，就是我们的 `SVG` 元素或者是盒子的宽度和高度。

![](https://cdn-images-1.medium.com/max/800/1*kHROytMDZzes7dvxRkPcfQ.png)

图二：SVG 盒子的宽度和高度

默认情况下，`SVG` 盒子具有传统坐标系，它的原点在左上角， `x, y` 的值分别向右和向下递增。同样在默认情况下，每一个单位都对应一个像素，这样盒子的四个角落根据给定的 `width` 和 `height` 具有适当的坐标。

![](https://cdn-images-1.medium.com/max/800/1*_09TMPUcoWWmpJcMjvbqiA.png)

图三：SVG 盒子的四个角以及它们的坐标

下一步非常简单地小学数学知识的运用。盒子中心点的坐标可以通过 `(width/2, height/2)` 计算出来为 `(150, 75)`。我们把这两个值分别赋给 `cx` 和 `cy` 以便于把小圆圈定位于盒子的中心。

![](https://cdn-images-1.medium.com/max/800/1*8PUOQSHkAnVtBB49TjM_Yw.png)

图四：计算盒子的中心点

#### 2. 让小圆圈动起来

我们这一节的目的就是使小圆圈动起来。但是不仅仅是无规律的简单形式的任何运动。我们需要小圆圈做**周期性的上下运动**。

![](https://cdn-images-1.medium.com/max/800/1*UOk_1DHKmvN2CnbFryNmSg.png)

图五：预期的运动

#### 2.1 周期性运动中的数学知识

周期性是指事情发生在有规律的时间间隔内。最简单的例子就是每天的日出和日落。不管现在是什么时候，比如下午 6:30，24 小时后还是下午 6:30，而且在那个时候的 24 小时之后仍然是下午 6:30。它很有规律，它恰好在 24 小时的时间间隔内发生。

假设现在是中午，太阳位于天空中它一天中的最高点，24 小时候它仍然在那里。或者假如现在是晚上并且夕阳处在地平线，随时都会落下去，24 小时之后，它又在做着相同的事情。你明白我举这些例子是为了说明什么了吗？

![](https://cdn-images-1.medium.com/max/800/1*PsqRzgZxHJjN5ApMPx_hrA.png)

图六：日出和日落的循环

这是一个非常简单的示意图，有些人可能会说在某些层面（科学）上是不准确的，但我认为它仍然表示出了太阳重复位置的点，相当好。

如果我们画出来一天中太阳在天空中的垂直位置，我们可能会发现其周期性愈发明显。

为了画出来一条二维曲线，我们需要两个值，`x` 和 `y`。在我们的例子中是 `time` [一天中的] 和 `positionOfTheSun`（译者注：太阳的位置）。我们收集到了一系列的这样的值，把它们画在一张图上就得到了我们想要的。

![](https://cdn-images-1.medium.com/max/2000/1*HEtKZZzLExSGpcOosYov8w.png)

图七：把日出和日落的循环画在一张图上

垂直坐标轴或者说是 `y 轴`就是太阳在天空中的垂直位置；水平坐标轴或者说是 `x 轴`代表时间。随着时间的变化，太阳的位置也会发生变化，并且这样的值在 24 小时之后会重复出现。

现在我们已经得到了有关太阳位置的知识图谱，这样即使我们处在黑暗的洞穴里，我们也可以知道此时此刻太阳在天空中的位置。要想知道我们是如何做到这点的，首先让我们继续，给我们的图表命名为 `sunsVerticalPositionAt`。

一旦我们得到了有关太阳位置的知识图表，我们可以得到以下公式……

`verticalPositionInTheSky = sunsVerticalPositionAt( [time] )`

我们只需要把我们的时间代入图表（或者从数学的角度说，是函数），然后我们就可以得到太阳在天空中的位置。这就是怎样得到太阳位置的方法。

![](https://cdn-images-1.medium.com/max/1000/1*MESaCB0KXypWR1A0CY4l6w.png)

图八：根据图表计算太阳的位置

我们选一个想要知道太阳位置的时间（假设是 t1），画一条垂直的线，它会与图表中的曲线相交，经过这个交点我们再画一条水平的直线让它与 `y` 轴相交。水平直线与 `y` 轴的交点所代表的数值即为 t1 时刻太阳在天空中的位置。这样看来我们并不需要离开我们的洞穴就可以知道太阳在天空中的位置了。

我想我已经用了足够多的比喻来进行解释，接下来我们讲一些数学知识。把图表中的太阳和其它装饰都删除掉，就得到了我们所想要的。

![](https://cdn-images-1.medium.com/max/800/1*62AF8P78hlEWuGuimpIBPA.png)

图九：周期曲线

这张图表很直观地表示了周期性。一个对象（在我们的例子中是 Sun 的垂直位置）重复其作为另一个对象的值（在我们的例子中是时间）。

数学当中有许许多多周期性函数，但是我们仍然坚持周期函数最基本的特征，我们打算使用 `y = sin(x)` 函数作为创建最完美的加载器的公式，也就是著名的正弦公式。

下面是 `y = sin(x)` 的曲线图。

![](https://cdn-images-1.medium.com/max/800/1*vLZmqxh-hC_ouYa5VfxipA.png)

图十：正弦曲线

你是不是突然发现了什么？你有没有发现正弦公式和计算太阳在天空中位置的公式的相似之处？

我们可以传入一个 `x` 值然后得到 `y` 的值。就像我们可以传入 `time` 然后计算出太阳在天空中的位置一样……不用离开我们的洞穴，好吧我再也不开这个洞穴的玩笑了。

如果你在思考什么是[正弦公式](https://en.wikipedia.org/wiki/Sine)？好吧，那就是一个函数的名字，就像我们给我们的图表（或者函数）命名为 `sunsVerticalPositionAt`。

这里需要注意的是 `y` 和 `x`。看一下 `y` 是怎样随 `x` 的变化而变化的。（你可以把它和我们太阳在天空中垂直位置随时间变化的例子联系起来吗？）

同样的可以注意到 `y` 的最大值是 1，最小值是 -1。这只是正弦函数的一个特征。`y = sin(x)` 的值域为 -1 到 +1。

但是这个值域是可以改变的，我们将一点一点的做。但在这之前，让我们把目前所学的所有知识都运用起来，实现小圆圈的运动。

#### 2.2 从数学知识到代码

现在我们已经在 `<svg>...</svg>` 中画了一个圆圈，并且这个圆圈的 ID 是 `c`。让我们继续，然后通过 JavaScript 让它舞动起来！

```
let c = document.getElementbyId('c');

animate();
function animate() {
  requestAnimationFrame(animate);
}
```

上面代码所做的事情很简单，一开始我们获取到了圆圈并且把它存到了一个叫做 `c` 的变量中。

接下来，我们使用了 `requestAnimationFrame` 函数和一个叫做 `animate` 的函数。`animate`通过 `requestAnimationFrame` 函数递归的调用它自己，以 60 FPS 的速度运行其中的任何动画代码（尽可能）。在[这里](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame)获取更多有关 `requestAnimationFrame` 的知识。

你所需要知道的是每次 `animate` 被调用时，其内部的代码描述了动画中的单个帧。当它下一次被递归地调用的时候，这一帧就发生了一点点的变化。这一变化在高速下（60 FPS）不断的重复，然后就出现了我们所要的动画效果。

看一下代码作用更大一点。

```
let c = document.getElementById('c');

let currentAnimationTime = 0;
const centreY = 75;

animate();
function animate() {
  c.setAttribute('cy', centreY + (Math.sin(currentAnimationTime)));
  
  currentAnimationTime += 0.15;
  requestAnimationFrame(animate);
}
```

我们添加了四行代码。如果你运行这些代码，你就会看到圆圈会在中心点附近缓慢地移动，就像下面这样。

![](https://cdn-images-1.medium.com/max/800/1*wI9UjHHitmJ7BLOV0o_OUg.gif)

下面是代码的解释。

一旦我们知道了圆圈中心点的坐标， `cx` 和 `cy`，这里是盒子宽度和高度的一半。首先，我们把 `cx` 放在一边，因为我们不想改变小圆圈的水平位置。我们需要定期从 `cy` 添加或减去相同的数字以使得小圆圈上下移动。这也正是我们在代码中所做的。

![](https://cdn-images-1.medium.com/max/800/1*NAyM8tc_MbFvaYXBdrFi_g.png)

图十一：改变小圆圈中心点的 y 坐标

`centreY` 存储着小圆圈中心点的 Y 坐标的值（75），这样就可以从 `centreY` 增加或者减去一定的值 —— 就像已经提到的那样 —— 改变小圆圈的垂直位置。

`currentAnimationTime` 是一个被初始化为 0 的值，它决定了动画变化的快慢，我们在每次调用中给它增加的值越多，动画变化得越快。我通过尝试和错误选择了 `0.15` 这个值，因为它看起来像是一个足够好的动画速度。

`currentAnimationTime` 是正弦函数的 `x` 值。当 `currentAnimationTime` 的值增加以后，我们把它传给 `Math.sin` 函数（一个内置的用于计算正弦值的 JavaScript 函数），然后把它经过 `Math.sin` 函数计算出来的值添加到 `centreY` 上……

![](https://cdn-images-1.medium.com/max/1000/1*dgAeM9JtvnYedY2AKBjMMg.png)

……然后使用 [setAttribute](https://developer.mozilla.org/en/docs/Web/API/Element/setAttribute) 把最后的结果赋值给 `cy`。

![](https://cdn-images-1.medium.com/max/1000/1*YtD5kKXiSLrlIBmfzqbjzg.png)

就像我们知道的那样，对于任意一个 `x` 值，都可以使用正弦函数产生一个 `-1` 到 `1` 之间的值。因此，`cy` 的值最小为 `centreY — 1`，最大为 `centreY + 1`。这就导致小圆圈在垂直方向上的抖动距离为 1 像素。

![](https://cdn-images-1.medium.com/max/800/1*Nm51v_IikurNFWH_NG_iBg.png)

图十二

我们想要增加这个抖动的间距。这就意味着我们需要一个比 1 更大的数字。我们该怎么做呢？我们需要一个新的函数吗？No！

还记得我们要在 2.2 节开始之前进行一个操作吗？ 这非常简单，我们需要做的就是将正弦乘以我们想要的边距。

将函数乘以常数的操作称为缩放。请注意图形如何改变其形状，还有乘法对正弦的最大值和最小值的影响。

![](https://cdn-images-1.medium.com/max/1000/1*refKM0MJrZ8yPsPruGuTWw.png)

图十三：图形缩放

现在我们知道该怎么做了，让我修改一下代码。

```
let c = document.getElementById('c');

let currentAnimationTime = 0;
const centreY = 75;

animate();
function animate() {
  c.setAttribute('cy', 
  centreY + (20 *(Math.sin(currentAnimationTime))));
  
  currentAnimationTime += 0.15;
  requestAnimationFrame(animate);
}
```

![](https://cdn-images-1.medium.com/max/800/1*fZ1VREG9A02CeGdS1-q_ng.gif)

这产生了一个非常流畅的小圆圈上下运动的动画。很可爱吧？

What we just did is increased the **_amplitude_** of the Sine function by multiplying a number to it.

我们所做的只是通过将函数乘以一个固定数字，增加了正弦函数的**振幅**。

下一步我们要做的是添加两个小圆圈到原来小圆圈的两边，然后让它们以同样的方式动起来。

```
<svg width="300" height="150">
  <circle id="cLeft" cx="120" cy="75" r="10" />
  <circle id="cCentre" cx="150" cy="75" r="10" />
  <circle id="cRight" cx="180" cy="75" r="10" />
</svg>
```

我们已经做了一点改变，这里的代码也已经被重构了。首先，请注意到两行新的粗体代码。它们是两个新的小圆圈，一个在原来小圆圈左边的 30 像素处（150 - 30 = 120），一个在原来小圆圈右边的 30 像素点处（150 + 30 = 180）

之前，我们给了唯一的那个小圆圈一个 ID 为 `c`，它能够正常运动因为只有一个小圆圈。但是现在我们已经有了三个小圆圈，最好给它们都取一个描述性很强的 ID。我们已经完成了这个工作，这些小圆圈从左到右 —— ID 为 `cLeft`，`cCentre` 和 `cRight`。原来的小圆圈的 ID 已经由 `c` 变成了 `cCentre`。

运行以上代码，下面就是我们得到的效果。

![](https://cdn-images-1.medium.com/max/800/1*TToQCA0u__qkKLWoWlxa8A.gif)

很好，但是新添加的小圆圈都没有动起来！好吧，现在要让它们动起来了。

```
let cLeft= document.getElementById('cLeft'),
  cCenter = document.getElementById('cCenter'),
  cRight = document.getElementById('cRight');

let currentAnimationTime = 0;
const centreY = 75;
const amplitude = 20;

animate();
function animate() {

  cLeft.setAttribute('cy', 
  centreY + (amplitude *(Math.sin(currentAnimationTime))));

  cCenter.setAttribute('cy', 
  centreY + (amplitude * (Math.sin(currentAnimationTime))));

  cRight.setAttribute('cy', 
  centreY + (amplitude * (Math.sin(currentAnimationTime))));  

  currentAnimationTime += 0.15;
  requestAnimationFrame(animate);
}
```

只添加了寥寥几行代码就达到了我们的目标，给新的小圆圈都添加了和 ID 为 `cCentre` 的小圆圈一样的动画代码，下面是我们得到的效果。

![](https://cdn-images-1.medium.com/max/800/1*TWnBExRuU-h2V_2RY1f2Qg.gif)

哇哦！新的小圆圈也动了起来！但是，我们现在得到的效果，根本不像是一个我们想要做出来的加载器。

尽管小圆圈们周期性的动了起来，现在还是有问题，因为它们的动作是同步的。这不是我们想要的。我们希望每个连续的小圆圈在运动时都有一些延迟。所以看起来，除了第一个小圆圈之外，后面的小圆圈看起来像循环之前的小圆圈的运动。就像下面这样。

![](https://cdn-images-1.medium.com/max/800/1*zu3l5_VPcIk9nx1WyRUkTA.gif)

你注意到了吗？每个小圆圈的运动都比它左边的小圆圈慢一步。如果你用手遮掉两个小圆圈，你会发现你看到的那个小圆圈的上下运动仍然跟我们在 2.2 节中实现的动画一样。

现在为了让小圆圈不同步，对其进行干扰，我们只需要对我们的代码做一个微小的改变。但了解这种微小变化如何起作用很重要。让我们来看看。

如果我们用之前的时间 - 位置曲线图绘制每个圆圈的运动，如下图所示，这就是图形的样子。

![](https://cdn-images-1.medium.com/max/800/1*XSv5fY5aRYY0fdOsPK-9BQ.png)

图十四：三个小圆圈的运动图

这里没有惊喜，因为我们知道每个小圆圈都以相同的方式运动。理解一下它，因为我们使用正弦函数来实现这个动画，所以上面的所有曲线都只是正弦函数的图形。现在为了让这些图不同步，我们需要了解图象平移/图象变换的数学概念。

平移是一种严格的变换，因为它不会改变函数曲线的形状或大小。所有这些转变将会改变曲线的位置。平移可以是水平或垂直的。对于我们的目的而言，我们对水平平移感兴趣（如您所见）。

注意一下 Gif 中 `a` 值发生变化时，`y=sin(x)` 的曲线图是怎么水平移动的。

![](https://cdn-images-1.medium.com/max/800/1*XhmFUvhr_BEmEUhRJP9MvQ.gif)

图十五：图象变换（示例）

为了理解其中的原理，让我重新回到日出和日落的比喻当中。

我们的函数又是哪个？`sunsVerticalPositionAt（t）`。那就对了！好的，所以我们可以给函数传入时间参数，并在特定的时间获得太阳在天空中的垂直位置。因此，为了在上午9点得到太阳的位置，我们可以写 `sunsVerticalPositionAt（9）`。

现在看一下 `sunsVerticalPositionAt(t — 3)`。认真注意一下，不管我们传入了什么时间（t）到函数中（这里使用 t - 3 代替 t），我们都会得到比 t 时刻早三个小时的时候，太阳在天空中的位置。

![](https://cdn-images-1.medium.com/max/800/1*83lHHMKTJHaq7cV9FjNAGQ.png)

图十六

这意味着 t = 9 的时候，我们得到的是 6 时刻的结果，而在 t = 12 的时候，我们得到的也是 9 时刻的结果。我们用这种方式连接函数，换句话说，函数返回的值比 `t` 传递的时刻更早。

我们也可以说，我们将函数的图象在 x 轴向右进行了平移。注意到下面图象中，变换之前的图象在 `t = 6` 时刻的值为 `B`。当图象被平移后，`B` 会作为 `t = 9` 时刻的结果返回。

![](https://cdn-images-1.medium.com/max/1000/1*0KgfprzfADpVVAv_whQfNQ.png)

图十七：变换之后的图象

同样的，如果我们给参数**加 3 **而不是减三，`sunsVerticalPosition(t + 3)` 的图象会向左平移，或者换句话说，函数返回的值会比原来传入的时刻晚 3 小时。你明白这是为什么吗？

随着这个知识的概念在我们头脑中的形成，我们现在可以做的就是进行图象变换以使得决定最后两个小圆圈动画的图形像下面这样。

![](https://cdn-images-1.medium.com/max/1000/1*hQc9dC3z1XZnWcTHLbBxYg.png)

图十八

为了完成这个效果，我们需要小小地修改一下代码。

```
let cLeft= document.getElementById('cLeft'),
  cCenter = document.getElementById('cCenter'),
  cRight = document.getElementById('cRight');

let currentAnimationTime = 0;
const centreY = 75;
const amplitude = 20;

animate();
function animate() {

cLeft.setAttribute('cy', 
  centreY + (amplitude *(Math.sin(currentAnimationTime))));

cCenter.setAttribute('cy', 
  centreY + (amplitude * (Math.sin(currentAnimationTime - 1))));

cRight.setAttribute('cy', 
  centreY + (amplitude * (Math.sin(currentAnimationTime - 2))));

currentAnimationTime += 0.15;
  requestAnimationFrame(animate);
}
```

现在就对了，我们平移了图象，使得 `cCenter` 和 `cRight` 代表的小圆圈符合要求地动了起来。

![](https://cdn-images-1.medium.com/max/800/1*xfAZYoKogskpdY16yPF2Hw.gif)

上图就是！我们加载器的小圆圈按照绝对的数学精度运动。值得庆祝一下！你可以随时使用不同的值，例如增加 `currentAnimationFrame` 的值以控制动画速度或`幅度`来控制偏移量，并使加载器按照您希望的方式进行动画运动。

纳什，你写这么长的文章解释一个简单的加载器的错综复杂，你疯了吗？不！你为了阅读它而疯狂。[让我们成为朋友！](http://twitter.com/NashVail)在你点击之前，我还有几个更新共享:)

* * *

我有个**我的第一个在线课程**用于讲授 Git 和 GitHub 的使用技巧！你可以使用[这个链接获得免费的2个月Skillshare会员资格](https://skl.sh/2riYNbD)（需要信用卡支付来支持一下我😸），或者使用[这个链接来查看免费课程](https://skl.sh/2HPQVIR)。

* * *

你使用过 Sketch 吗？如果是的话那么你可能会发现我创建的这个库对 wire-framing 有帮助！

![](https://cdn-images-1.medium.com/max/800/1*BJw94iuZPiGlf10DVaaF4A.png)

[签出 Wireframe.sketch.](https://github.com/nashvail/Wireframe.sketch)

* * *

最后，当我创作/写作/教授某些我认为可能对你有帮助的东西时，我可以向你发送一封电子邮件吗？让我知道你的电子邮件地址。没有垃圾邮件，这是我的承诺。

**再次感谢您的阅读！祝您每天愉快！**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
