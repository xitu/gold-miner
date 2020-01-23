> * 原文地址：[Edge Detection in Python](https://towardsdatascience.com/edge-detection-in-python-a3c263a13e03)
> * 原文作者：[Ritvik Kharkar](https://medium.com/@ritvikmathematics)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/edge-detection-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/edge-detection-in-python.md)
> * 译者：
> * 校对者：

# Edge Detection in Python

![](https://cdn-images-1.medium.com/max/2298/1*I_GeYmEhSEBWTbf_kgzrgQ.png)

Last quarter, I was helping teach a Python course at my university, and learned a lot about image processing as a result. I wanted to continue sharing that knowledge in this article as we talk about the **theory and execution** of edge detection using Python!

---

### Why Detect Edges?

The first question we should really ask is **“why bother with edge detection?”**. Besides being something cool, why is it a useful technique? To motivate that point, consider the following image of a pinwheel and its “edges-only” counterpart:

![Image of pinwheel (left) and its edges (right)](https://cdn-images-1.medium.com/max/2298/1*I_GeYmEhSEBWTbf_kgzrgQ.png)

We can see that the original image on the left has various colors and shades, while the “edges-only” representation on the right is black and white. If asked which image requires more data storage, I bet you would say the original image. And this makes sense; by detecting the edges of an image, we are doing away with much of the detail, thereby making the image “more lightweight”.

Thus, edge detection can be incredibly useful in cases where we don’t need to maintain all the intricate details of an image, but rather **only care about the overall shape**.

---

### How to Perform Edge Detection — The Math

Before talking about the code, let’s take a quick look at the math behind edge detection. We, as humans, are pretty good at identifying the “edges” of an image, but how do we teach a computer to do the same thing?

First, consider a rather boring image of a black square amidst a white background:

![Our working image](https://cdn-images-1.medium.com/max/2000/1*jVZqFGP3peOrhZ6rnhz0og.png)

In this example, we consider each pixel to have a value between **0 (black)** and **1 (white)**, thus dealing with only black and white images for right now. The exact same theory will apply to color images.

Now, let us say we are trying to determine whether or not the green highlighted pixel is part of the edge of this image. As humans, we would say **yes**, but how can we use neighboring pixels to help the computer reach the same conclusion?

Let’s take a small 3 x 3 box of local pixels centered at the green pixel in question. This box is shown in red. Then, let’s “apply” a filter to this little box:

![Apply the vertical filter to the local box of pixels](https://cdn-images-1.medium.com/max/3124/1*61U9atgGnhaPinVUHKe1rA.png)

The filter we will “apply” is shown above, and looks rather mysterious at first glance, but let us see how it behaves. Now, when we say **“apply the filter to the little local box of pixels”** we mean multiply each pixel in the red local box by each pixel in the filter element-wise. So, the top left pixel in the red box is 1 whereas the top left pixel in the filter is -1, so multiplying these gives -1, which is what we see in top left pixel of the result. Each pixel in the result is achieved in exactly the same way.

The next step is to sum up the pixels in the result, giving us -4. Note that -4 is actually the **smallest** value we can get by applying this filter (since the pixels in the original image can be only be between 0 and 1). Thus, we know the pixel in question is part of a **top vertical edge** because we achieve the minimum value of -4.

To get the hang of this transformation, let’s see what happens if we apply the filter on a pixel at the bottom of the square:

![](https://cdn-images-1.medium.com/max/3106/1*wIm2uGrxSjYfscQ8ACap9Q.png)

We see that we get a similar result, except that the sum of the values in the result is 4, which is the **highest** value we can get by applying this filter. Thus, we know we found a pixel in a **bottom vertical edge** of our image because we got the highest value of 4.

To map these values back to the 0–1 range, we simply add 4 and then divide by 8, mapping the -4 to a 0 (**black**) and mapping the 4 to a 1 (**white**). Thus, using this filter, called the **vertical Sobel filter**, we are able to very simply detect the vertical edges in our image.

What about the horizontal edges? We simply take the **transpose of the vertical filter** (flip it about its diagonal), and apply this new filter to the image to detect the horizontal edges.

Now, if we want to detect horizontal edges, vertical edges, and edges that fall somewhere in between, we can **combine the vertical and horizontal scores**, as shown in the following code.

Hopefully the theory is clear! Now let’s finish up by looking at the code.

---

### How to Perform Edge Detection — The Code

First some setup:

* Replace “pinwheel.jpg” with whatever fun image you want to find the edges of! Make sure it’s in the same working directory.

And the edge detection code itself:

A few things to note:

* There will be a small border around the image since we are unable to fully create the local 3 x 3 box on the border pixels.
* Since we are doing detection on both horizontal and vertical edges, we just divide the raw scores by 4 (rather than adding 4 and then dividing by 8). It is not a major change but one which will better highlight the edges of our image.
* Combining the horizontal and vertical scores might cause the final edge score to go out of the 0–1 range, so we finish by re-normalizing the scores.

Running the above code on a more complicated image:

![](https://cdn-images-1.medium.com/max/3032/1*QnVu-wTPcpcHJ1Gixu-k2g.png)

results in the edge detection:

![](https://cdn-images-1.medium.com/max/3032/1*v4JxLC5XMqlO9kEgjwsV9Q.jpeg)

---

And that’s all! Hope you learned something and stay tuned for more data science articles ~

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
