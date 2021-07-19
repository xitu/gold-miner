> * 原文地址：[CSS is magic, its time you try 3D](https://levelup.gitconnected.com/css-is-magic-its-time-you-try-3d-91a2dd49c781)
> * 原文作者：[Ankita Chakraborty](https://medium.com/@ankitachakraborty)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/css-is-magic-its-time-you-try-3d.md](https://github.com/xitu/gold-miner/blob/master/article/2021/css-is-magic-its-time-you-try-3d.md)
> * 译者：
> * 校对者：

# CSS is magic, its time you try 3D

![Dog Illustration: [subpng](https://www.subpng.com/), Eyes: [pngegg](https://www.pngegg.com)](https://cdn-images-1.medium.com/max/5440/1*WKVcqB1XHjA5Fbdm-AQU-g.png)

**CSS transform** is the one of the most versatile and magical properties of CSS. Not only is it the best way to implement smooth animations on your website, but also you can do wonders with **CSS 3D transforms.**
Like this one 🙀 —

![CSS 3D Cube!](https://cdn-images-1.medium.com/max/2000/1*dFJEMRBc7vlHnLf_MYI0Iw.gif)

> I apologize in advance for the several GIFs coming your way to eat your internet bandwidth, but I hope it’s worth it! 🤜🤛

But wait, two of the cube’s sides are missing!!!
I did that deliberately so that it would be easier to understand and visualize. I will add a link to the complete code for getting the above result at the end of the article!

### First Things First — How does Translate Work?

The `translate` method basically moves an HTML element from its actual position without messing with any other sibling/parent element on the layout tree. To summarize, the `translateX` method moves the element left and right, whereas the `translateY` method moves it up and down.

![How translate works in X and Y axis](https://cdn-images-1.medium.com/max/3688/1*cq8Q9DGLScj3v038DnxjhQ.png)

### But What the Heck is the Z Axis?

To visualize how `translate` works along the Z-axis, imagine your div moving towards and away from you instead of top-bottom or left-right in the screen —

![Translate along the Z axis](https://cdn-images-1.medium.com/max/4328/1*qXx6HIGzXvPZY4oO_4gEFQ.png)

How is that possible? An website is viewed like a page of a book right? How can anything possibly come out of the screen towards you (or, go away from you)?

Your `div` obviously does not come out in real, it gives you a feeling that it does. Let’s check side by side how altering `translate` values look along different axes:

![](https://cdn-images-1.medium.com/max/2000/1*lNQdNBsRYNzWduwKFCdR5w.gif)

I don’t know about you, but the green box does not look like coming towards or going away from me. 👺

How do we solve this? We need to change our **perspective** a bit. 😉

### The CSS perspective property

You will not be able to visually detect changes in Z-axis without setting the right `perspective` value.

> The `perspective` property defines how far the object is away from the user. So, a lower value will result in a more intensive 3D effect than a higher value.
>
> Source — [W3 Schools](https://www.w3schools.com/cssref/css3_pr_perspective.asp)

Let’s add the following CSS to the parent element of the three boxes —

![](https://cdn-images-1.medium.com/max/2724/1*ijVRelbthN6Ivuf5xDs7Iw.png)

And, **voila:**

![](https://cdn-images-1.medium.com/max/2000/1*5Go0arpobwsP4NtVYPRH4A.gif)

### The Rotate Method

As the name suggests, `rotate` works by rotating the element along one of the three axes, given a degree. However, we will need a little visualization on how rotate works along different axes.

![Rotation in different axes without perspective](https://cdn-images-1.medium.com/max/2000/1*L06oWqkChV9deUNUVKrITw.gif)

![Rotation in different axes with perspective](https://cdn-images-1.medium.com/max/2000/1*nu1bM-wUxugvSsDj2H1ZSg.gif)

### The Cube

Let us finally start with the cube sides! We will have four faces — bottom, front, back and left:

![](https://cdn-images-1.medium.com/max/2388/1*q69vRRksjkM4M2xY0Meycg.png)

I have added some CSS to the main wrapper of the cube as well.

![](https://cdn-images-1.medium.com/max/2000/1*gSM7KPGdGmzmo5D-Jpr_UA.png)

Note that I have added `transform-style: preserve-3d;` to the container. This is a crucial step for rendering 3D children. The size of each face is `200px`in width and height and we need to keep this value in mind as we will have to add `translate` values with respect to the dimensions of the sides.

For our cube, each face is going to be an absolute division and I have added text indicating which face it is. I have added `opacity: 0.5` for each face so that the overlap is clear:

![](https://cdn-images-1.medium.com/max/2236/1*iygD8k6WIHvobgQKUAc9Ww.png)

To bring the front face to the front, we add `translateZ(100px)` to it.

![](https://cdn-images-1.medium.com/max/2768/1*-URkuoY7VunPTDHgQzSqsA.png)

Well, this is how it looks. 🙁

So how can we make this 3D-**ish**? Our knowledge of `perspective` comes handy here.

Adding this CSS to our outer:

![](https://cdn-images-1.medium.com/max/2000/1*pB8EdPyeKJywcoUVkdNszw.png)

Also, let us make our back-face go backwards. Hence, we will add the opposite of what we added to the front face.

![](https://cdn-images-1.medium.com/max/2000/1*r1-jRUGjUW-8a0-ckLay_Q.png)

**THE RESULT —**

![](https://cdn-images-1.medium.com/max/2608/1*q6x7s9gLwwVf3WtIMaQYvg.png)

Are you able to visualize the front face coming towards you and the back face (yellow one) going away? If it is still not visual enough, let us try rotating the cube wrapper a bit:

![](https://cdn-images-1.medium.com/max/2000/1*jaSlx71f9SunHXIOxGdthg.gif)

Amazing isn’t it?

Next up, we need to fix the bottom face 💁‍♀️. To put the bottom face in place, we are going to rotate it by **90-degrees** along the X-axis:

![](https://cdn-images-1.medium.com/max/2000/1*icrwzzydWhtOKhj85QnO1A.gif)

We have to move its position as well so that it sits just between the front and back face of the cube. What we can do is, move the bottom face in line with the front face and then rotate it. Sounds confusing?

**Step — 1: Aligning the bottom face with the front face**

**CSS:**

![Aligning the bottom face with front face](https://cdn-images-1.medium.com/max/2000/1*CBL0oCueX-bgBbVRJXC0dA.png)

**Result:**

![Aligning the bottom face with front face](https://cdn-images-1.medium.com/max/2000/1*xLD_mS8WsK3nzScd6tbwKw.gif)

**Step — 2: Rotating bottom face by 90 degrees**

**CSS:**

![Combining both rotate and translate for bottom face](https://cdn-images-1.medium.com/max/2152/1*LVmwdMV9BtJEZYP9u37pmw.png)

**Result:**

![Combining both rotate and translate for bottom face](https://cdn-images-1.medium.com/max/2000/1*qsGQ7VjZngLZm9SoU8LuxA.gif)

The bottom face is now safe and sound in its place. But the left face is kinda stuck in the middle. 🙍‍♀️ First, we need to move it to the side and then rotate it. Let’s move it by **-100px** on the X axis and then rotate it on the Y axis.

**CSS:**

![](https://cdn-images-1.medium.com/max/2180/1*5RJvq7AM6mGD5zVVGoXM7w.png)

**Result:**

![](https://cdn-images-1.medium.com/max/2000/1*WnnTtpzcd691KA2qO0b16w.gif)

And **voila**! Our **almost cub**e is almost done. I would suggest you to play around with various values of translate and rotate in every axis and try adding the top and right axis to make a full cube.

Now, last but not the least, lets rotate our cube 😍

**CSS:**

![](https://cdn-images-1.medium.com/max/2000/1*VhF0Ltn-I8vLPhTc6xaj9A.png)

Adding the above animation to our `box-wrapper` —

![](https://cdn-images-1.medium.com/max/2336/1*RbHF6_VStIc1nYnx5g_pog.png)

And the result 🤜🤛:

![](https://cdn-images-1.medium.com/max/2000/1*OZ9tJyqDlJZ5NZhuRT1-wA.gif)

Refer to [this repository](https://github.com/ankita1010/css-cube) for a working code of the same and play around because **CSS 3D** is a pool of magic. 💫

> **Please note** — I have tweaked the perspective value and added animations to achieve final position of the side to illustrate the changes with more clarity. Also, I had rotated the `box-wrapper` a little so that the changes are most visible from the right angle.

Cheers!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
