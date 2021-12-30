> * 原文地址：[Simulate Interplanetary Space Travel in Python](https://python.plainenglish.io/simulating-interplanetary-space-travel-in-python-95116b14b6a9)
> * 原文作者：[Phillip Heita](https://medium.com/@phillipheita)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/simulating-interplanetary-space-travel-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2021/simulating-interplanetary-space-travel-in-python.md)
> * 译者：[Z招锦](https://github.com/zenblofe)
> * 校对者：[jaredliw](https://github.com/jaredliw)、[Chor](https://github.com/Chorer)

# 使用 Python 模拟实现星际太空旅行

> 使用 Python 模拟一个虚拟航天器从地球到火星的转移。

在过去的几十年里，霍曼转移一直是所有月球和星际太空旅行的首选方法。本文将使用 Python 模拟一个虚拟航天器从地球到火星的转移。

![](https://cdn-images-1.medium.com/max/2000/1*fEruasybf-VS0KZEkasYcw.gif)

本文将讨论一种星际太空旅行的方法，以及使用 Python 的模拟实现。

## 什么是霍曼转移轨道

[霍曼转移轨道](https://www.jpl.nasa.gov/edu/teach/activity/lets-go-to-mars-calculating-launch-windows/)是航天器如何在两个轨道（例如地球和火星）之间使用最少的能量移动，也被认为是最有效的转移轨道。霍曼转移轨道涉及到将宇宙飞船加速到一个椭圆轨道上，它的近日点（霍曼轨道上最接近太阳的点）位于内行星，而远日点（霍曼轨道上离太阳最远的点）位于外行星的轨道上。

![霍曼转移轨道至火星。来源：[Quora](https://www.quora.com/The-distance-to-Mars-is-115-71M-miles-Therefore-to-reach-Mars-in-9-months-you-would-have-to-travel-at-approximately-Mach-46-Is-this-what-NASA-did-or-is-travel-to-Mars-actually-impossible), 由 [Robert Frost](https://www.quora.com/profile/Robert-Frost-1) 提供](https://cdn-images-1.medium.com/max/2000/0*aVinhR35nL8d9RJr)

霍曼转移的一个相对较新的应用是[火星科学实验室](https://mars.nasa.gov/msl/home/)（MSL）前往火星的任务，该任务耗时约九个月。霍曼转移轨道的一个重要考虑因素是确定发射时间，使得航天器到达火星时，火星将处于该确切位置。

霍曼转移轨道的关键步骤包括计算航天器的轨道周期。在地球到火星的情况下，这需要大约 520 天。航天器要走一半的轨道，所以一次旅行将是大约 260 天。利用航天器行驶的距离和火星的轨道周期（约 687 天），我们发现发射航天器的最佳时间是火星在其轨道上领先地球 44 度的时候，如上图所示。了解上述情况的一个极好方法是查看[行星转移计算器](https://transfercalculator.com/)，这是一个太阳系模拟器，可以计算行星、卫星和恒星之间的转移。

## 使用 Python 模拟实现

本节将介绍模拟霍曼转移的代码。首先，导入一些用于数值计算和绘图的基本库。

```python
import numpy as np
import matplotlib as mpl
mpl.use(‘pdf’)
import matplotlib.pyplot as plt
from matplotlib import animation
```

下面的代码定义了火星在其轨道上应该领先的临界角，即 44 度。地球距离太阳平均为 [1.5 亿公里](https://solarsystem.nasa.gov/news/1164/how-big-is-the-solar-system/)，这个距离我们称之为 1 天文单位（AU），而火星距离太阳约为 1.52 AU。为了绘制地球和火星的轨道，我们使用 matplotlib 的 `Circle()` 函数，并分别赋予它们 1 和 1.52 的半径。

```python
# 绘制地球和火星的轨道图
alpha = 44 # 度（应领先的角度）
Earth = plt.Circle((0,0), radius= 1.0,fill=False,color=’blue’)
Mars = plt.Circle((0,0), radius= 1.52,fill=False,color=’brown’)
```

移动部件，即蓝色的地球、棕色的火星和红色的航天器，是通过以下方式定义的：

```python
# 移动地球、火星和航天器
patch_E = plt.Circle((0.0, 0.0),radius=0.04,fill=True,color=’blue’)
patch_M = plt.Circle((0.0, 0.0),radius=0.03,fill=True,color=’brown’)
patch_H = plt.Circle((0.0, 0.0),radius=0.01,fill=True,color=’red’)
```

然后定义两个基本函数。第一个函数创建了动画的基础帧，即所有运动部件的初始位置，而该函数只需要一个参数，即帧数 `i`。`animate` 函数包括所有描述各种运动的必要[轨道方程](https://www.youtube.com/watch?v=LzsMjEMDpD4)。要进一步了解这两个函数，可以考虑看看这个[教程](https://jakevdp.github.io/blog/2012/08/18/matplotlib-animation-tutorial/)。

```python
def init():
 patch_E.center = (0.0,0.0)
 ax.add_patch(patch_E)
 patch_M.center = (0.0,0.0)
 ax.add_patch(patch_M)
 patch_H.center = (0.0,0.0)
 ax.add_patch(patch_H)
 return patch_E,patch_M,patch_H

def animate(i):
 # 地球
 x_E, y_E = patch_E.center
 x_E = np.cos((2*np.pi/365.2)*i)
 y_E = np.sin((2*np.pi/365.2)*i)
 patch_E.center = (x_E, y_E)

# 火星
 x_M, y_M = patch_M.center
 x_M = 1.52*np.cos((2*np.pi/686.98)*i+(np.pi*alpha/180.))
 y_M = 1.52*np.sin((2*np.pi/686.98)*i+(np.pi*alpha/180.))
 patch_M.center = (x_M,y_M)

# 航天器
 Period = 516.0
 x_H = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period)*i))*np.cos((2*np.pi/Period)*i)
 y_H = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period)*i))*np.sin((2*np.pi/Period)*i)
 patch_H.center = (x_H,y_H)
 return patch_E,patch_M,patch_H
```

为了创建动画，需要使用 `Writer()` [函数](https://matplotlib.org/3.1.1/api/_as_gen/matplotlib.animation.FFMpegWriter.html)设置影片文件格式，它能够控制每秒的帧数（fps）和比特率。在下面的代码中，我们还设置了绘图布局，即字体和标签大小。为了更好地引导视线，我们沿着航天器的路径绘标记了灰色的记号。

```python
# 设置影片的文件格式
# plt.rcParams[‘savefig.bbox’] = ‘tight’ # 严重乱码的视频！！！
Writer = animation.writers[‘ffmpeg’]
writer = Writer(fps=60, metadata=dict(artist=’Me’), bitrate=1800)

plt.rc(‘font’, family=’serif’, serif=’Times’)
plt.rc(‘text’, usetex=True)
plt.rc(‘xtick’, labelsize=8)
plt.rc(‘ytick’, labelsize=8)
plt.rc(‘axes’, labelsize=8)

# 设置路径，引导视线
Period = 516.
x_H_B = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period*75)))*np.cos((2*np.pi/Period*75))
y_H_B = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period*75)))*np.sin((2*np.pi/Period*75))
x_H_C = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period*150)))*np.cos((2*np.pi/Period*150))
y_H_C = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period*150)))*np.sin((2*np.pi/Period*150))
x_H_D = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period*200)))*np.cos((2*np.pi/Period*200))
y_H_D = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period*200)))*np.sin((2*np.pi/Period*200))
x_H_M = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period*250)))*np.cos((2*np.pi/Period*250))
y_H_M = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period*250)))*np.sin((2*np.pi/Period*250))
```

最后，使用下面的代码把完整动画放在一起。这段代码的主要内容是设置图表、各种坐标轴和前面定义的星球。关键的几行是调用 `animation.FuncAnimation()`，以及保存动画。

```python
fig, ax = plt.subplots(figsize=(10,8))
# fig.subplots_adjust(left=.15, bottom=.16, right=.99, top=.97)

ax.plot(0,0,color=’orange’,marker=’o’,linestyle=’’,markersize=16,markerfacecolor=’yellow’,label=’Sun’)
ax.plot([],[],color=’blue’,linestyle=’’,marker=’o’,label=’Earth’)
ax.plot([],[],color=’brown’,linestyle=’’,marker=’o’,label=’Mars’)
ax.plot([],[],color=’red’,linestyle=’’,marker=’o’,label=’spacecraft’)
ax.plot(x_H_B,y_H_B,color=’dimgray’,marker =’p’,markerfacecolor=’dimgray’,linestyle=’’,label=’path’)
ax.plot(x_H_C,y_H_C,color=’dimgray’,marker =’p’,markerfacecolor=’dimgray’)
ax.plot(x_H_D,y_H_D,color=’dimgray’,marker =’p’,markerfacecolor=’dimgray’)
ax.plot(x_H_M,y_H_M,color=’dimgray’,marker =’p’,markerfacecolor=’dimgray’)
ax.add_patch(Earth)
ax.add_patch(Mars)
ax.set_xlabel(‘X [AU]’,fontsize=12)
ax.set_ylabel(‘Y [AU]’,fontsize=12)
ax.legend(loc=’best’,fontsize=12)
anim = animation.FuncAnimation(fig, animate,init_func=init,frames=260,interval=40,blit=True)
plt.axis(‘scaled’) # 实时缩放绘图
plt.savefig(‘Hohmann.pdf’)
anim.save(‘Hohmann.mp4’, writer=writer)
plt.show()
```

## 假如发射偏离 10 度会怎样

![](https://cdn-images-1.medium.com/max/2000/1*EbfP6sYJ8PPzomf5qmvI5A.gif)

正如预期的那样，将发射角度从 44 度改为 54 度，导致航天器与火星的拦截点偏差相当大。

---

以上就是本文全部内容，我希望你觉得它很有趣！如果你也在 Python 中创建了任何很酷的动画，欢迎与我分享。

谢谢您的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
