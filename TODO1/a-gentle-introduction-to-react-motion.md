> * 原文地址：[A gentle introduction to React Motion](https://medium.com/@nashvail/a-gentle-introduction-to-react-motion-dc50dd9f2459)
> * 原文作者：[Nash Vail](https://medium.com/@nashvail?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-gentle-introduction-to-react-motion.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-gentle-introduction-to-react-motion.md)
> * 译者：
> * 校对者：

# A gentle introduction to React Motion

React is great, I am having a lot of fun playing around with it for the past few weeks. I decided to take a shot and try out [React Motion](https://github.com/chenglou/react-motion). It was a little tricky in the beginning to wrap my head around the API, but eventually it all started to make sense, it took time though. Sadly there are no proper React Motion tutorials I could find online, so I decided to write this one up, as a resource for fellow devs and as a reference for myself.

React Motion exports 3 main components, Motion, StaggeredMotion and TransitionMotion. In this tutorial we’ll be taking a look at the Motion component, the one you will find yourself using most of the time.

Since this is a React Motion tutorial, I assume that you are somewhat acquainted with React as well as ES2015.

We’ll explore the API while recreating [this Framerjs example](http://framerjs.com/examples/preview/#new-tweet.framer) using React Motion. You can find the final version of code [here](https://github.com/nashvail/ReactPathMenu/).

![](https://cdn-images-1.medium.com/max/1600/1*kyWa60lJ2P1nGrQOSFwDag.gif)

Final Result

We’ll be doing a little bit of Math first, don’t fret though, I’ll try to explain every single one of the steps in as much detail as possible. You can skip directly to the React.start(); part if you want to :-).

Ready? Let’s do this…

### Math.start();

Let’s call the Big Blue Button - _main button_, and the buttons that fly out from it the _child buttons_.

![](https://cdn-images-1.medium.com/max/2000/1*qllWMqjzSS-WNxJicsTg7A.png)

Fig. 1

Child buttons have two states of position, 1) where they are all hidden behind the main button, 2) where the child buttons arrange themselves in a circle around the main button.

That is where the math comes in, we will have to come up with a way to evenly arrange the child buttons around the main button in a perfect circle. You could hard code those values by trial and error, but seriously, who does that? Plus once you get the math right, you can have any number of child buttons you like and they all will automagically arrange themselves.

First of all let us get acquainted with a few terms.

#### M_X, M_Y

![](https://cdn-images-1.medium.com/max/1200/1*QILlqlCX5YemXpc2L301Ig.png)

Fig. 2

M_X, M_Y represents the x and y coordinates respectively of the center of the main button. This point (M_X, M_Y) will be used as a reference from where the distances and directions of each child button will be calculated.

Each child button initially hides behind the main button with their centers at M_X, M_Y.

#### Separation angle, Fan angle, Fly out radius

![](https://cdn-images-1.medium.com/max/1600/1*H7S3us4GgfZ2-lVU7gyo2A.png)

Fig. 3

Fly out radius is the distance away from the main button the child buttons fly out to. Everything else looks pretty self explanatory.

Also notice that,

> Fan angle = (number of child buttons-1) * Separation angle

Now, we need to devise a function that takes in the index of a child button (0, 1, 2, 3 …) and returns the x and y coordinates of the new position (after flying out) of the child button.

#### Base angle, Index

![](https://cdn-images-1.medium.com/max/1200/1*HM9Pysix_eOJjbPQ_YNPxQ.png)

Fig. 4

Since in general trigonometry angles are measured from the positive x axis, we will start numbering our child buttons from the opposite (right to left) direction. This way, later we won’t have to deal with multiplying a negative 1 each time we need to find the final position of a child button.

While we’re at it, notice that (refer Fig. 3)

> Base angle = (180 — Fan angle)/2

(In degrees of course).

#### Angle

![](https://cdn-images-1.medium.com/max/1200/1*HV4NgkZc3HRsvSLVyPf_iA.png)

Fig. 5

Each child button will have its very own angle, which I will call Angle, yes just Angle. This angle is the final piece of information we need to calculate the final position of the child buttons.

Notice that, (refer Fig. 3, Fig. 4)

> Angle of child button with index i = Base angle + ( i * Separation angle)

Now, once we have the angle for each child button,

![](https://cdn-images-1.medium.com/max/1600/1*4WLefRuCXNDKa4Zb2g6A7A.png)

Fig. 6

We will be able calculate _deltaX_ and _deltaY_ for that child button.

Notice that (refer Fig. 2),

> Final X position of child button = M_X + deltaX

> Final Y position of child button = M_Y-deltaY

(We subtract deltaY from M_Y because unlike general coordinate system where the origin is in the lower left corner, browsers have origin at the top left, so to move something up you decrease the value of their y coordinate.)

That is it, that’s all the math needed, now we have two things the initial position of each of the child buttons (M\_X, M\_Y) and the final positions of the child buttons. Let’s let React do rest of the magic.

### React.start();

In the following gist you’ll see what happens is, on clicking the main button we set the state variable of isOpen to true ( line 85 ). Once isOpen is true a different set of styles for the child buttons is passed ( line 97, line 66, line 75).

The result :

![](https://cdn-images-1.medium.com/max/1600/1*feVyc2Uue0mq4h0jVGW1uw.gif)

Fig. 7

Alright, we’re pretty much done here, we’re setting the initial and final positions of the child buttons on click, all we need to do now is add React Motion to the mix to animate the child buttons between their initial and final positions.

### React-Motion.start();

<Motion> takes in [several parameters](https://github.com/chenglou/react-motion#motion-) one of which is optional, we don’t really care about the optional parameter here since we’re not doing anything that this parameter is concerned with.

One of the parameter <Motion> takes in is _style_, this style is then passed down as parameter into the callback function, which takes in _interpolated values_ and does whatever magic it does.

(line 8 : Since we’re iterating React requires you to pass in a _key_ parameter to the child components)

Something like this,

Even after doing this the result won’t be any different from Fig. 7. Why so you ask? Well, we need to perform one last step, _spring._

As mentioned earlier, the callback function takes in interpolated values, that is what _spring_ does it helps interpolate the style values.

We will need to edit the _initialChildButtonStyles_ and the _finalChildButtonStyles_ to

notice the _top_ and _left_ values wrapped around _spring_. Those are the only changes, and now,

![](https://cdn-images-1.medium.com/max/1600/1*vJVGoGiTF0_WWOjF4nX5yw.gif)

Fig. 8

optionally spring takes a second parameter, which is an array containing two numbers [Stiffness, damping], this defaults to [170, 26] resulting in what you see above in Fig. 8.

See Stiffness as the speed at which the animation occurs, not a very accurate assumption, but larger the value greater the speed. And dampness is like wobbliness but opposite, smaller the value more wobbly the animation.

Take a look at these

![](https://cdn-images-1.medium.com/max/1600/1*fmPrwf2E-gy8FJ9t-c0TvQ.gif)

[320, 8] — Fig. 9

![](https://cdn-images-1.medium.com/max/1600/1*cyNkSaIKitdbfkWQ5BjZkA.gif)

[320, 17] — Fig. 10

We’re close, but not there yet. What if we added delay each time before the next child button starts to animate? That’s exactly what we need to do, to achieve the final effect. Doing so wasn’t so straightforward though, I had to store each motion component as an array in a state variable. Then change the state one by one for each of the child button to achieve the desired effect, the code goes something like this

> this.state = {  
> isOpen: false,  
> childButtons: []  
> };

Then on componentDidMount fill the _childButtons_

> componentDidMount() {  
> let childButtons = [];  
> range(NUM_CHILDREN).forEach(index => {  
> childButtons.push(this.renderChildButton(index));  
> });

> this.setState({childButtons: childButtons.slice(0)});  
> }

and openMenu function becomes :

![](https://cdn-images-1.medium.com/max/1600/1*OAwTtEZ77MFmYc5J93UWIA.gif)

There we are. After doing some aesthetic tweakings like adding icons and a little rotation, we get the following.

![](https://cdn-images-1.medium.com/max/1600/1*kyWa60lJ2P1nGrQOSFwDag.gif)

You can have any number* of child buttons you want, math has you covered

![](https://cdn-images-1.medium.com/max/1600/1*CZs6nzP2gA4wYo7-7W14RQ.gif)

NUM_CHILDREN = 1

![](https://cdn-images-1.medium.com/max/1600/1*ZYBIda9cB4qswqsiARS9-g.gif)

NUM_CHILDREN = 3

![](https://cdn-images-1.medium.com/max/1600/1*LAGfzXC-DrjFOYJDmWAyGg.gif)

NUM_CHILDREN = 8

Pretty cool huh? Again, you can find the code [here](https://github.com/nashvail/ReactPathMenu/blob/staggered-motion/Components/APP.js), feel free to contribute/improve. Do hit the Recommend button below if you found the article helpful.

Got any questions, comments, suggestions or just wanna chat? Find me on Twitter [@NashVail](http://twitter.com/NashVail) or shoot me an email at [hello@nashvail.me](mailto:hello@nashvail.me).

* * *

You might also like

1.  [Let’s settle ‘this’ — Part One](https://medium.com/p/lets-settle-this-part-one-ef36471c7d97)
2.  [Let’s settle ‘this’ — Part Two](https://medium.com/p/lets-settle-this-part-two-2d68e6cb7dba)
3.  [Designing the perfect wallpaper app](https://medium.com/@nashvail/designing-the-perfect-wallpaper-app-36b8c9c226bb)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
