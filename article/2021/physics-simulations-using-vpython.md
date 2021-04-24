> * 原文地址：[Physics Simulations Using VPython](https://levelup.gitconnected.com/physics-simulations-using-vpython-a3d6ee69d121)
> * 原文作者：[Khelifi Ahmed Aziz](https://medium.com/@ahmedazizkhelifi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/physics-simulations-using-vpython.md](https://github.com/xitu/gold-miner/blob/master/article/2021/physics-simulations-using-vpython.md)
> * 译者：
> * 校对者：

# Physics Simulations Using VPython

![Photo by [Conor Luddy](https://unsplash.com/@opticonor?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*Fk0d8lVdHBnEvOLa)

## Introduction

Physical science is based on simplifications and approximations: orbits are always circular, projectiles fly without air resistance, pendulums swing only at small angles. These kinds of simplifications are necessary and appropriate when you’re first trying to understand the basic laws of nature, (those approximations are useful, we lose a little precision, contrariwise we save a lot of time (for example the approximation used in the [magnetic moment](https://en.wikipedia.org/wiki/Magnetic_dipole_moment)), but the real world is far more complex and interesting. Because the ultimate goal of physics is to **understand the real world**.

Fortunately, computers make it possible to perform extremely lengthy calculations in a negligible amount of time. **VPython** gives us a solution to simulate complex equations of physicals systems on graphs and generate navigable real-time 3D animations.

To install VPython, if you’re using Jupyter notebook, the 3D scene appears in the Jupyter notebook. Otherwise, If the code is launched outside a notebook (from the command line or the IDLE for example), a browser window will open displaying the scene (Internet Explorer is not supported). It is recommended to use the Chrome browser, as it provides the most useful error messages.

## How to get started?

The package has been published in Pypi and can be easily installed with pip.

```bash
pip install vpython
```

Once the installation has been completed you could try produces a [3D Cylinder](https://www.glowscript.org/docs/VPythonDocs/cylinder.html).

```Python
import vpython as vp
vp.cylinder()
```

To change the position, size, and color:

```Python
vp.cylinder(pos=vp.vector( 4, 0, 0), size=vp.vector(4,4,4), color = vp.color.red)
```

## Simulate the Solar System

### Process planning

The equation for the gravitational force is one of the biggest successes in physics. It tells us how fast the moon is traveling around the earth, shows us how to get a satellite into orbit, and helps us find dark matter and black holes.

![Illustrations by [Freepik](http://www.freepik.com)](https://cdn-images-1.medium.com/max/2000/1*1CzQmLm9fgP-5TSCiHL0Mw.png)

One of the best ways to study the gravitational force is by using the **Euler Cromer method** in a computer code. Suppose, we wanted to study the orbit of a planet around a star, programming the gravitational force between the planet and the star just requires a few mathematical steps.

* First, the negative sign out in front, it means that the gravitational force is always attractive.
* Second, the universal gravitation constant. This number is always the same, no matter where you are in the universe.
* Then, we multiply the mass of the star times the mass of the planet.
* Next, we need to think about the distance between the star and the planet. We can get a distance-vector that points from the star to the planet by subtracting their positions. The magnitude of this distance vector goes into the denominator of the gravitational force.
* Finally, we calculate a vector called **R hat**, which gives the direction of the gravitational force. We can calculate R hat by dividing the distance-vector by its magnitude.

### Coding

Bring your coffee and let’s start by creating a new python script, importing the module, and generating a scene:

First, import the module then generate a scene:

```Python
import vpython as vp
vp.scene.title = "Modeling the motion of planets with the gravitational force"
vp.scene.height = 600
vp.scene.width = 800
```

Then, let’s make a star and a planet (you can change mass to a real-world value):

```Python
planet = vp.sphere(pos=vp.vector(1,0,0), radius=0.05, color=vp.color.green,
               mass = 1, momentum=vp.vector(0,30,0), make_trail=True )

star = vp.sphere(pos=vp.vector(0,0,0), radius=0.2, color=vp.color.yellow,
               mass = 2.0*1000, momentum=vp.vector(0,0,0), make_trail=True)
```

Now, we need to create a function that calculates the gravitational force:

```Python
def gravitationalForce(p1,p2):
	G = 1 #real-world value is : G = 6.67e-11
	rVector = p1.pos - p2.pos
	rMagnitude = vp.mag(rVector)
	rHat = rVector / rMagnitude
	F = - rHat * G * p1.mass * p2.mass /rMagnitude**2
	return F
```

To create the animation, we’ll use the Euler Cromer method, so first, we need to generate a time variable and the step size:

```Python
t = 0
dt = 0.0001 #The step size. This should be a small number
```

Under an infinite loop, we’ve to calculate the force and update the position, the momentum, and the time variable `t` as follow:

> **Note**: we use the [`rate()`](https://python.developpez.com/cours/vpython/webdoc/visual/rate.php) to limit the animation rate, we can also use `sleep()`.

```Python
while True:
	vp.rate(500)
	#calculte the force using gravitationalForce function
	star.force = gravitationalForce(star,planet)
	planet.force = gravitationalForce(planet,star)
	#Update momentum, position and time
	star.momentum = star.momentum + star.force*dt
	planet.momentum = planet.momentum + planet.force*dt
	star.pos = star.pos + star.momentum/star.mass*dt
	planet.pos = planet.pos + planet.momentum/planet.mass*dt
	t+= dt
```

Now let’s try to add more planets.

> **Note**: we can use RGB to declare the color as follows:

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

then update position and momentum,

```Python
while (True):
    vp.rate(500)
    
    #Calculte the force using gravitationalForce function
    star.force = gravitationalForce(star,planet1)+gravitationalForce(star,planet2)+gravitationalForce(star,planet3)
    planet1.force = gravitationalForce(planet1,star)+gravitationalForce(planet1,planet2)+gravitationalForce(planet1,planet3)
    planet2.force = gravitationalForce(planet2,star)+gravitationalForce(planet2,planet1)+gravitationalForce(planet2,planet3)
    planet3.force = gravitationalForce(planet3,star)+gravitationalForce(planet3,planet1)+gravitationalForce(planet3,planet2)

    #Update momentum, position and time
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

![Output result](https://cdn-images-1.medium.com/max/2000/1*IumWizGbiMgBzSrbBfeKQA.png)

## In the end

VPython allows us to generate simple/complex 3D animations to describe physics phenom, or draw real-time plots …

**Thanks For Reading! 😄**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
