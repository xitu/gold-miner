> * 原文地址：[Simulate Interplanetary Space Travel in Python](https://python.plainenglish.io/simulating-interplanetary-space-travel-in-python-95116b14b6a9)
> * 原文作者：[Phillip Heita](https://medium.com/@phillipheita)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/simulating-interplanetary-space-travel-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2021/simulating-interplanetary-space-travel-in-python.md)
> * 译者：
> * 校对者：

# Simulate Interplanetary Space Travel in Python

> A simulation of the transfer of a virtual spacecraft from Earth to Mars using Python.

The Hohmann transfer has been the go-to method for all lunar and interplanetary space travel for the past few decades. This article will simulate the transfer of a virtual spacecraft from Earth to Mars using Python.

![](https://cdn-images-1.medium.com/max/2000/1*fEruasybf-VS0KZEkasYcw.gif)

This article will discuss an approach to interplanetary space travel, along with a Python implementation.

## What is the Hohmann Transfer Orbit?

The [Hohmann transfer orbit](https://www.jpl.nasa.gov/edu/teach/activity/lets-go-to-mars-calculating-launch-windows/) is how spacecraft can move between two orbits, say Earth and Mars, using the least energy, and thus considered the most efficient. It involves accelerating a spaceship onto an elliptical orbit. Its perihelion (the point of the Hohmann orbit closest to the Sun) is at the inner planet, and the aphelion (the point of the Hohmann orbit that is farthest from the Sun) is at the outer planet’s orbit.

![Hohmann Transfer Orbit to Mars. Source: [Quora](https://www.quora.com/The-distance-to-Mars-is-115-71M-miles-Therefore-to-reach-Mars-in-9-months-you-would-have-to-travel-at-approximately-Mach-46-Is-this-what-NASA-did-or-is-travel-to-Mars-actually-impossible), provided by [Robert Frost](https://www.quora.com/profile/Robert-Frost-1)](https://cdn-images-1.medium.com/max/2000/0*aVinhR35nL8d9RJr)

A relatively recent application of the Hohmann transfer is the [Mars Science Laboratory](https://mars.nasa.gov/msl/home/) (MSL) mission to Mars, which took approximately nine months. A vital consideration of the Hohmann transfer orbit is to time the launch such that Mars will be at that exact location when the spacecraft gets there.

The critical steps of the Hohmann transfer orbit include calculating the orbit period of our spacecraft. In the Earth to Mars case, this turns to be around 520 days. Our spacecraft travels half of an orbit, so a trip will be about 260 days. Using the distance our spacecraft travels and the orbital period of Mars (around 687 days), we find that the optimal time to launch the spacecraft is when Mars is 44 degrees ahead of Earth in its orbit, as shown in the image above. An excellent way to get a sense of the above is to check out the [Planetary Transfer Calculator](https://transfercalculator.com/), a solar system simulator that calculates transfers between planets, moons, and stars.

## Python Implementation

This section will go through the code that simulates the Hohmann transfer. We start by importing some essential libraries for numerical calculations and plotting.

```python
import numpy as np
import matplotlib as mpl
mpl.use(‘pdf’)
import matplotlib.pyplot as plt
from matplotlib import animation
```

The code below defines the critical angle by which Mars should be ahead in its orbit, i.e. 44 degrees. The Earth is on average [150 million kilometers](https://solarsystem.nasa.gov/news/1164/how-big-is-the-solar-system/) from the Sun, a distance we call 1 Astronomical Unit (AU), and Mars is at around 1.52 AU from the Sun. To plot the Earth and Mars orbits, we use the matplotlib `Circle()` function and give them radiuses of 1 and 1.52, respectively.

```python
#Plotting the Earth and Mars orbits
alpha = 44 #degrees (Angle by which should be ahead by)
Earth = plt.Circle((0,0), radius= 1.0,fill=False,color=’blue’)
Mars = plt.Circle((0,0), radius= 1.52,fill=False,color=’brown’)
```

The moving components, i.e. the blue Earth, brown Mars, and red spacecraft, are defined via:

```python
#Moving Earth, Mars, and Spacecraft
patch_E = plt.Circle((0.0, 0.0),radius=0.04,fill=True,color=’blue’)
patch_M = plt.Circle((0.0, 0.0),radius=0.03,fill=True,color=’brown’)
patch_H = plt.Circle((0.0, 0.0),radius=0.01,fill=True,color=’red’)
```

We then define two essential functions. The first function allows us to create the base frame for the animation, i.e., the initial position of all the moving parts, whereas the animation function takes a single parameter, the frame number `i`. The animate function includes all the necessary [orbital equations](https://www.youtube.com/watch?v=LzsMjEMDpD4) describing the various motions. To learn more about these two functions, consider looking at this [tutorial](https://jakevdp.github.io/blog/2012/08/18/matplotlib-animation-tutorial/).

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
 #Earth
 x_E, y_E = patch_E.center
 x_E = np.cos((2*np.pi/365.2)*i)
 y_E = np.sin((2*np.pi/365.2)*i)
 patch_E.center = (x_E, y_E)

#Mars
 x_M, y_M = patch_M.center
 x_M = 1.52*np.cos((2*np.pi/686.98)*i+(np.pi*alpha/180.))
 y_M = 1.52*np.sin((2*np.pi/686.98)*i+(np.pi*alpha/180.))
 patch_M.center = (x_M,y_M)

#Hohmann
 Period = 516.0
 x_H = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period)*i))*np.cos((2*np.pi/Period)*i)
 y_H = 1.26*(1. — 0.21**2)/(1. + 0.21*np.cos((2*np.pi/Period)*i))*np.sin((2*np.pi/Period)*i)
 patch_H.center = (x_H,y_H)
 return patch_E,patch_M,patch_H
```

To create the animation, we set up the movie files using the `Writer()` [function](https://matplotlib.org/3.1.1/api/_as_gen/matplotlib.animation.FFMpegWriter.html), which gives us control over the frames per second (fps) and bitrate. In the code below, we also set the layout of our plot, i.e., font and label sizes. To better guide the eye, we define arbitrarily chosen grey markers along the path of our spacecraft.

```python
# Set up formatting for the movie files
#plt.rcParams[‘savefig.bbox’] = ‘tight’ # tight garbles the video!!!
Writer = animation.writers[‘ffmpeg’]
writer = Writer(fps=60, metadata=dict(artist=’Me’), bitrate=1800)

plt.rc(‘font’, family=’serif’, serif=’Times’)
plt.rc(‘text’, usetex=True)
plt.rc(‘xtick’, labelsize=8)
plt.rc(‘ytick’, labelsize=8)
plt.rc(‘axes’, labelsize=8)

# Set up path, to guide eye
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

Finally, we put our full animation together using the code below. The bulk of this code sets up our plot, various axes, and the planet patches defined earlier. A critical line is where we call the `animation.FuncAnimation()`, along with saving the animation.

```python
fig, ax = plt.subplots(figsize=(10,8))
#fig.subplots_adjust(left=.15, bottom=.16, right=.99, top=.97)

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
plt.axis(‘scaled’) #Scale the plot in real time
plt.savefig(‘Hohmann.pdf’)
anim.save(‘Hohmann.mp4’, writer=writer)
plt.show()
```

## What happens if our launch is off by 10 degrees?

![](https://cdn-images-1.medium.com/max/2000/1*EbfP6sYJ8PPzomf5qmvI5A.gif)

As expected, changing the launch angle from 44 to 54 degrees makes our spacecraft miss the intercept point with Mars by “quite a bit”.

---

That’s all for this article, and I hope you found it interesting! Let me know if you created any cool animations in Python.

Thank you for Reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
