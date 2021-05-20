> * 原文地址：[Physics Simulations Using VPython](https://levelup.gitconnected.com/physics-simulations-using-vpython-a3d6ee69d121)
> * 原文作者：[Khelifi Ahmed Aziz](https://medium.com/@ahmedazizkhelifi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/physics-simulations-using-vpython.md](https://github.com/xitu/gold-miner/blob/master/article/2021/physics-simulations-using-vpython.md)
> * 译者：[tmpbook](https://github.com/tmpbook)
> * 校对者：[Kimhooo](https://github.com/Kimhooo), [greycodee](https://github.com/greycodee)

# 使用 VPython 进行物理模拟

![图片由 [Conor Luddy](https://unsplash.com/@opticonor?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*Fk0d8lVdHBnEvOLa)

## 简介

物理科学是建立在简化和估算的基础上的，如：轨道总是圆形的，弹丸飞行时不会有空气阻力，钟摆只会以小角度摆动。当你第一次试图理解自然的基本规律时，简化是必要且恰当的，（这些估算是有用的，虽然我们失去了一点精度，但是我们节省了很多时间，例如在[磁矩](https://en.wikipedia.org/wiki/Magnetic_dipole_moment)中使用估算)，但是现实世界要复杂有趣得多。因为物理学的最终目标是**理解现实世界**。

幸运的是，计算机可以在可忽略不计的时间内进行极其冗长的计算。**VPython** 为我们提供了一种在图形上模拟物理系统的复杂方程并生成可交互的实时三维动画的解决方案。

安装 VPython 后，如果您使用的是 Jupyter notebook 运行代码，那么 3D 场景将显示在 Jupyter notebook 中。否则，如果代码在 notebook 外启动（例如从命令行或集成开发环境），则会打开一个显示场景的浏览器窗口（不支持 Internet Explorer）。建议使用 Chrome 浏览器，因为它可以提供最有用的错误消息。

## 如何开始？

该软件包已经在 Pypi 中发布，可以很容易地用 pip 安装。

```bash
pip install vpython
```

安装完成后，您可以尝试生成一个 [3D 圆柱体](https://www.glowscript.org/docs/VPythonDocs/cylinder.html)。

```Python
import vpython as vp
vp.cylinder()
```

要更改位置、大小和颜色，请执行以下操作：

```Python
vp.cylinder(pos=vp.vector( 4, 0, 0), size=vp.vector(4,4,4), color = vp.color.red)
```

## 模拟太阳系

### 过程设计

引力方程是物理学中最大的成功之一。它告诉我们月球绕地球运行的速度，告诉我们如何将卫星送入轨道，并帮助我们找到暗物质和黑洞。

![插图来自 [Freepik](http://www.freepik.com)](https://cdn-images-1.medium.com/max/2000/1*1CzQmLm9fgP-5TSCiHL0Mw.png)

研究引力的最佳方法之一是在计算机代码中使用**欧拉克罗姆方法**。假设我们想研究行星绕恒星的轨道或计算行星和恒星之间的引力只需要几个数学步骤。

* 首先，前面的负号，意味着引力是始终存在的。
* 其次，不管你在宇宙的哪个角落，万有引力常数这个数字都是一样的。
* 然后，我们将恒星的质量乘以行星的质量。
* 接下来，我们需要考虑恒星和行星之间的距离。我们可以通过减去它们的位置得到一个从恒星指向行星的距离向量。然后将这个距离向量的大小放入重力的分母中。
* 最后，我们计算一个向量 **R hat**，它给出了引力的方向。我们可以用距离向量除以它的大小来计算 **R hat**。

### 编码

带上你的咖啡一起，让我们从创建新的 Python 脚本、导入模块和生成场景开始：

首先，导入 vpython 模块，然后生成场景：

```Python
import vpython as vp
vp.scene.title = "Modeling the motion of planets with the gravitational force"
vp.scene.height = 600
vp.scene.width = 800
```

然后，让我们定义一颗恒星和一颗行星（你可以把质量变成真实世界的值）：

```Python
planet = vp.sphere(pos=vp.vector(1,0,0), radius=0.05, color=vp.color.green,
               mass = 1, momentum=vp.vector(0,30,0), make_trail=True )

star = vp.sphere(pos=vp.vector(0,0,0), radius=0.2, color=vp.color.yellow,
               mass = 2.0*1000, momentum=vp.vector(0,0,0), make_trail=True)
```

现在，我们需要创建一个函数来计算重力：

```Python
def gravitationalForce(p1,p2):
	G = 1 # 真实世界的值是：G = 6.67e-11
	rVector = p1.pos - p2.pos
	rMagnitude = vp.mag(rVector)
	rHat = rVector / rMagnitude
	F = - rHat * G * p1.mass * p2.mass /rMagnitude**2
	return F
```

要创建动画，我们将使用欧拉克罗姆方法，因此首先，我们需要定义一个时间变量和步长：

```Python
t = 0
dt = 0.0001 # 步长，它应该是一个很小的数字
```

在无限循环下，我们要计算力，然后更新位置，动量和时间变量 `t`，如下所示：

> **注意**: 我们使用 [`rate()`](https://python.developpez.com/cours/vpython/webdoc/visual/rate.php) 来限制动画速率，我们也可以使用 `sleep()`。

```Python
while True:
	vp.rate(500)
	# 用 gravitationalForce 函数计算力
	star.force = gravitationalForce(star,planet)
	planet.force = gravitationalForce(planet,star)
	# 更新动量、位置和时间
	star.momentum = star.momentum + star.force*dt
	planet.momentum = planet.momentum + planet.force*dt
	star.pos = star.pos + star.momentum/star.mass*dt
	planet.pos = planet.pos + planet.momentum/planet.mass*dt
	t+= dt
```

现在让我们尝试添加更多的行星。

> **注意**: 我们可以使用 RGB 来声明颜色，如下所示：

```Python
star = vp.sphere(pos=vp.vector(0,0,0), radius=0.2, color=vp.color.yellow,
               mass = 1000, momentum=vp.vector(0,0,0), make_trail=True)

planet1 = vp.sphere(pos=vp.vector(1,0,0), radius=0.05, color=vp.color.green,
               mass = 1, momentum=vp.vector(0,30,0), make_trail=True)

planet2 = vp.sphere(pos=vp.vector(0,3,0), radius=0.075, color=vp.vector(0.0,0.82,0.33),#RGB color
                  mass = 2, momentum=vp.vector(-35,0,0), make_trail=True)
                  
planet3  = vp.sphere(pos=vp.vector(0,-4,0), radius=0.1, color=vp.vector(0.58,0.153,0.68),
                  mass = 10, momentum=vp.vector(160,0,0), make_trail=True)
```

然后更新位置和动量，

```Python
while (True):
    vp.rate(500)
    
    # 用 gravitationalForce 函数计算力
    star.force = gravitationalForce(star,planet1)+gravitationalForce(star,planet2)+gravitationalForce(star,planet3)
    planet1.force = gravitationalForce(planet1,star)+gravitationalForce(planet1,planet2)+gravitationalForce(planet1,planet3)
    planet2.force = gravitationalForce(planet2,star)+gravitationalForce(planet2,planet1)+gravitationalForce(planet2,planet3)
    planet3.force = gravitationalForce(planet3,star)+gravitationalForce(planet3,planet1)+gravitationalForce(planet3,planet2)

    # 更新动量、位置和时间
    star.momentum = star.momentum + star.force*dt
    planet1.momentum = planet1.momentum + planet1.force*dt
    planet2.momentum = planet2.momentum + planet2.force*dt
    planet3.momentum = planet3.momentum + planet3.force*dt

    star.pos = star.pos + star.momentum/star.mass*dt
    planet1.pos = planet1.pos + planet1.momentum/planet1.mass*dt
    planet2.pos = planet2.pos + planet2.momentum/planet2.mass*dt
    planet3.pos = planet3.pos + planet3.momentum/planet3.mass*dt
    
    t += dt
```

![输出的结果](https://cdn-images-1.medium.com/max/2000/1*IumWizGbiMgBzSrbBfeKQA.png)

## 最后

VPython 允许我们生成或简单或复杂的 3D 动画来描述物理现象，同时你也可以使用它进行实时绘图等。

**感谢阅读！😄**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
