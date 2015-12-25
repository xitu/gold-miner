> * 原文链接 : [Animated SVG vs GIF [CAGEMATCH]](https://sarasoueidan.com/blog/svg-vs-gif/)
* 原文作者 : [Sara Soueidan](https://twitter.com/SaraSoueidan)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

SVG can do much more than display static images. Its animation capabilities are one of its most powerful features, giving it a distinctive advantage over all other image formats. They are one of many reasons that make SVG images better than raster images, including GIFs. But this, of course, only applies to images that are good candidates for SVG, such as:

*   Logos,
*   non-complex, vector-based illustrations,
*   user interface controls,
*   infographics,
*   and icons.

Of course, if you have an image that is better suited for the raster format—such as a photograph or a very complex vector illustration (that would normally have a very big size as an SVG), then you should use a raster image format instead. Not only should the image be a good candidate for SVG, but SVG should also be a good candidate for the image. If the image size is much less as a PNG, for example, then you should use PNG, and serve different versions/resolutions of that image using `srcset`, or , depending on what you’re working on and trying to achieve.

> Not only should the image be a good candidate for SVG, but SVG should also be a good candidate for the image.

Generally speaking, the images listed above are usually perfect candidates for SVG. And if you're going to animate any of those, creating your animations by animating the SVG code is the sensible way to go.

However, last week, a link popped up in my Twitter timeline that linked to a set of icons that are animated as GIFs.

The first thing that crossed my mind when I saw them was that they were perfect candidates for SVG and should be created as SVG images, not GIFs.

SVGs can indeed replace GIFs in many places, just like they can replace other raster image formats for candidates like those mentioned above. The ability to animate SVG images is what gives it this advantage and ability. And this applies to more than just animated icons.

So, here is why I think you should use SVG instead of GIFs whenever you can.

## Image Quality

The first advantage to using SVG over GIFs—or any image format, for that matter—is, unsurprisingly, SVG’s number one feature: resolution-independence. An SVG image will look super crisp on any screen resolution, no matter how much you scale it up. Whereas GIFs—a raster image format—do not. Try zooming in a page that contains a GIF image and watch the GIF become pixelated and its contents blurred.

For example, the following GIF recording of an SVG animation looks fine at this small size:

![](https://sarasoueidan.com/images/svg-vs-gif--animation-example.gif)

A GIF recording of the [SVG Motion Trails demo](http://codepen.io/chrisgannon/pen/myZzJv) by Chris Gannon.



Zooming into the page a few times will cause the image to be pixelated and the edges and curves of the elements inside to become jagged, as you can see in the image below:

![](https://sarasoueidan.com/images/svg-vs-gif--animation-example-zoomed-in.png)

Whereas if you [check the SVG demo out](http://codepen.io/chrisgannon/pen/myZzJv) and zoom into the page, the SVG content will remain crisp and clear no matter how much you zoom in.

To provide crisp images for high-resolution displays when you’re using a bitmap image format like GIF, you need to use or `srcset` and switch the images up for different contexts.

Of course, the higher the image resolution, the bigger the file size will be. With GIFs, the file size will end up ridiculously large; but we'll get to that in a minute. Also, using a high-resolution GIF and serving it at a smaller size for mobiles is bad for performance. **Don’t do it.**

When you create GIF-animated icons or images, their dimensions are fixed. Change the dimensions or zoom in and out of the page, and they’ll get pixelated. With SVG, size is free, and clarity is a constant. You can create a small SVG and have it scale up as much as needed without sacrificing image clarity.

**Conclusion**:

<table>

<tbody>

<tr>

<td>GIF</td>

<td>Animated SVG</td>

</tr>

<tr>

<td>GIF, just like other image formats, are not resolution-independent, and will therefore look pixelated when scaled up or viewed on higher resolutions.</td>

<td>SVG is scalable and resolution-independent, and will look crisp clear on any screen resolution.</td>

</tr>

</tbody>

</table>

## Colors and Transparency

Perhaps the number one deal-breaker with GIFs is the way transparency is handled, especially when the image is displayed on a background other than a white background.

This is an issue that is most likely to emerge when using GIF icons (whether animated or not), since icons are usually created with transparent backgrounds.

For example, take the following circle with a stroke, created as both an SVG image (left) and a GIF with a transparent background (right). The problem is evident as soon as you look at the two images: the GIF circle has grey fringes around its stroke.

<figure style="background-color: #003366;">![](https://sarasoueidan.com/images/svg-vs-gif--circle-on-transparent-background.svg) ![](https://sarasoueidan.com/images/svg-vs-gif--circle-on-transparent-background.gif)

If you’re not reading this in the browser, the effect might not be visible to you because the figure styles might not be applied. Here is a screenshot showing the problem (on the right):

![](https://sarasoueidan.com/images/svg-vs-gif--artefact.png)

This happens because transparency in GIF images is binary. This means that each pixel is either _on_ or _off_; a pixel is either transparent or fully opaque. This, in turn, means that the transition between the foreground color and the background color is not as smooth, and results in artefacts caused by inadequate sampling frequency, commonly known as _aliasing_.

When a line is not completely straight, it causes some pixels (around the edges) to be partially transparent and partially opaque, so the software needs to figure out what color to use for those pixels. The halo effect “is caused by all the pixels which would have been > 50% opaque being fully opaque and carrying the bg color against which they were rasterized” ([Chris Lilley](http://twitter.com/svgeesus/)). So this effect is usually a result of pixel contamination from the color of the background against which the image was composited against upon creation/saving in a graphics editor.

Aliasing is usually countered with _anti-aliasing_, but that is not as simple when transparency is binary:

> There is a **severe interaction between anti-aliasing and binary transparency**. Because the background colour of the image is mixed in with the foreground colours, simply replacing a single background colour with another is not enough to simulate transparency. There will be a whole host of shades which are _mixtures_ of background and foreground colours [...]. The effect in this case is a white halo around objects, because the original image was anti-aliased to a white background colour.
> 
> <cite>— [Chris Lilley](http://twitter.com/svgeesus/) ([Source](http://www.w3.org/Conferences/WWW4/Papers/53/gq-trans.html))</cite>

The solution to this problem is variable transparency, commonly known as the alpha channel, which allows for varying degrees of transparency and hence a smoother transition between the foreground and background color, which is not what is available in GIF; thus, the halo effect problem. Images with the halo effect usually look best when used with white backgrounds; any other high-contrast background color will make the artefact visible.

I’m not quite sure if there is a way to work around this issue, but I’ve not yet come across a GIF with a transparent background and curved edges that did not have this problem. I’ve even seen rectangular shapes suffer from it as well.

If you want to use your image/icon on a non-white background—say, on a dark footer background, this alone could be a deal-breaker. But there are other reasons SVG is better than GIFs too, that we’ll cover in the next sections.

**Note:** if you're reading this article in a browser but still don't see the fringes in the first image on a smaller screen, try zooming the page in to see the effect.

Why might you not be able to see the fringes on smaller sizes? The answer is: the browser smoothes the edges as a part of the image resize process. Does this mean that you can utilize this to get rid of the fringes and still use a GIF? Yes, you can. But to do that, you have to use a GIF that is much bigger than the size you want to render it at, and then resize it. This also means that you will be serving your users images that are much bigger than they need, therefore taking up more of their bandwidth on mobile, as well as hurting the overall page size and performance. Please don't do that.

**Conclusion**:

<table>

<tbody>

<tr>

<td>GIF</td>

<td>Animated SVG</td>

</tr>

<tr>

<td>GIF images are capable of only binary transparency. This causes artefacts, known as the _halo effect_ to show up whenever the image or icon is used on a non-white background. The higher the background color contrast with the image, the more visible the halo effect, which makes the icons practically unusable.</td>

<td>SVG images come with an alpha channel and do not suffer from any problems when they are used on different background colors.</td>

</tr>

</tbody>

</table>

## Animation Techniques & Animation Performance

**You can animate SVGs using CSS, javaScript or SMIL**, and each of them gives you a different level of control that you can take advantage of to create all kinds of animations on SVG elements.

There are no "techniques" to animate GIF images. They are animated by showing a series of images—one for each frame—sequentially, in a fixed manner, at a fixed pace. You know, the way GIFs just work. Granted, you can get creative with your icons before you turn them into GIFs and then “record” the animation and convert it into a GIF, but how good will it look? And how much control over the animation timing will you get afterwards? None.

Unless you make sure you have at least 60 frames—that is, 60 images—_**per second**_ to create your GIF, the animation will not look smooth. Whereas with SVG, achieving smooth animations is much easier and simpler by taking advantage of browser optimizations.

A GIF has a bigger file size than PNG or JPEGs, and the longer the animation duration, the bigger the size will be. Now, what if your animation plays for at least 5 ot 6 seconds? What if it plays for much longer?

You get the picture.

Let's look at a more specific yet minimal example. Below are two images: an animated SVG on the left, and an animated GIF on the right. The rectangle in both images changes color over the course of six seconds.

<svg width="300" height="150" viewBox="0 0 300 150" xmlns="http://www.w3.org/2000/svg"><style>svg{width:48%;}path{animation:loop 6s linear infinite;}@keyframes loop{to{fill:#009966;}}</style></svg> ![](https://sarasoueidan.com/images/svg-vs-gif--rectangle-animation.gif)

The SVG image on the left and the GIF on the right.



There are a couple of things to note here:

*   The GIF animation looks smooth but if you look closely you will notice that the SVG rectangle is going through a wider range of colors as it transitions from the initial to the final color. **The number of colors the GIF goes through is limited by its number of frames.** In the above image, the GIF goes through 60 frames, i.e. 60 colors, whereas the SVG goes through the entire spectrum between the shade of pink used and the final green color.
*   For looping animations like this one, it is generally best to avoid the color jump shown in the above animation, and create the animation so that it reverses once it reaches the green color; that way, it will transition smoothly back to pink and then start the second round of animation from there too, avoiding that unsightly color jump.

    With CSS, you can reverse the animation using the `alternate` animation direction value. But with GIF, you will need to work on your number of frames and probably end up doubling it to make this happen; this will, of course, also increase the size of the image as well.

The sizes of the two images shown above are:

*   GIF image size: **21.23KB**
*   SVG image size: **0.355KB**

This is no trivial difference. But we all know we can optimize our images. So let’s do that.

Optimizing the SVG using the SVGO Drag-and-Drop GUI brings the SVG’s file size down to **0.249KB**.

To optimize the GIF, you can use one of the several GIF optimization tools online. I used [ezgif.com](http://ezgif.com/) to optimize the above image. (Other tools also exist; [gifsicle](http://www.lcdf.org/gifsicle/) is one of them.) The file size dropped down to **19.91KB**.

There are many options you can choose from when optimizing GIF images. I optimized the above image so that the number of frames remains intact, using Lossy GIF compression, which <q>can reduce animated GIF file size by 30%—50% at a cost of some dithering/noise.</q>

You can also optimize it by removing every nth frame; that can reduce the file size even further, but at the cost of the animation not being smooth anymore. And in the case of an animation like the case at hand, removing frames will make the change in color be "jumpy" and noticeable.

Other optimization options are also available such as color reduction (which wouldn't be suitable for our color-dependent animation here) and transparency reduction. You can learn more about these options on the [ezgif.com](http://ezgif.com/) optimization page.

To recap: If you want your GIF animation to be smooth, you’re going to need more frames per second, and that will consequently increase the file size by a lot. Whereas with SVG, you’re likely to maintain a much smaller file size. The above example is minimal, and I’m sure there are better ones out there, but I wanted the most minimal example to show the difference between the two formats.

Even if you were animating the above rectangle using JavaScript or even a JavaScript framework—since animations on SVG don’t work in IE, for example, the file size of that framework combined with that of the SVG is still likely to be smaller or at least equal to the size of the GIF image size. For example, using [GreenSock](http://greensock.com)’s TweenLite, the size of the SVG with the library combined would be less than 13KB (which is still less than the size of the GIF), since TweenLite is 12KB minified. If you do end up with a size equal to that of the GIF, the other benefits of SVG will tip the scale and you will be getting more out of it.

Some other JavaScript libraries exist that focus on certain animation tasks at a time, and come in impressivly small file sizes (<5KB), such as [Segment](https://github.com/lmgonzalves/segment/blob/gh-pages/dist/segment.min.js) which is used to animate SVG paths to create line drawing effects. Segment is 2.72KB minified. That’s not too shabby, is it?

There can be exceptions, so you should always test. But given the nature of GIFs and how they work, you will likely find that SVG is a better option in most cases.

Note: SVG Performance is not at its absolute best today, but this will hopefully change in the future. IE/MS Edge offer the best SVG rendering performance among all browsers today. Despite that, SVG animations will still look better than GIF animations, especially when you're tackling long animations, because the file size of the GIF—assuming it’s recorded at 60fps—will have a negative impact on the overall page performance. Libraries like GreenSock also offer impressive performance as well.

**Conclusion**:

<table>

<tbody>

<tr>

<td>GIF</td>

<td>Animated SVG</td>

</tr>

<tr>

<td>

1.  GIF images are generally larger than SVG images. The more complex and longer the animation, the more frames are required to create it and therefore the bigger the file size and the more the negative impact on performance.
2.  Unless GIF animation plays at 60fps, the animation is going to be jagged and not smooth. Also, the more the number of frames per second, the bigger the file size, especially for longer animations.

**Result:** There will be a compromise that needs to be made. Either the GIF animation is smooth and the overall file and page size and performance is negatively affected, or the GIF animation will suffer with less frames. One form of performance is risked in both scenarios.

</td>

<td>

SVG images take advantage of the browser optimizations when animating elements. Even though browser performance on SVG elements is still not at its best, animation will still perform better without having to make page performance compromises.

SVG file size is still very reasonable, if not very small, compared to GIFs, even when certain animation libraries might be required to create cross-browser animations.

</td>

</tr>

</tbody>

</table>

### Maintaining & Modifying Animations

..is a pain if you are using GIFs. You will need to use a graphics editor such as Photoshop or Illustrator or After Effects, to name a few. And if you're like me, then graphics editors are not where your skills shine, and you feel more at home when you make modifications in code, not in graphics editors.

![](https://sarasoueidan.com/images/svg-vs-gif--photoshop-frames.png)

Screenshot of the animation timeline as created in Photoshop. The lower part shows a fraction of the frames created for the animation. Fore more complex animations, more frames are required. Also notice the layers panel.

<small>Thanks to my designer friend [Stephanie Walter](http://twitter.com/WalterStephanie) for the PS animation tips.</small>





What happens if you want to change your animation timing? or if you want to change the timing functions for one or multiple elements inside your image? or if you want to change the direction in which an element moves? What if you want to change the entire effect and have the elements in your image do something completely different?

You will need to recreate the image or icon all over again. Any change requires you to jump into the graphics editor and work with frames and a frame-based UI. That would be like torture to developers, and a Mission Impossible for those of us who don’t know our way around those editors enough to make these changes.

With SVG, making any kind of change to the animation(s) is only a few lines of code away.

**Conclusion (developer’s perspective)**:

<table>

<tbody>

<tr>

<td>GIF</td>

<td>Animated SVG</td>

</tr>

<tr>

<td>Maintaining and modifying GIF animations requires re-creating the image or resorting to a frame-based graphics editor’s UI to do so, which is a problem for design-challenged developers.</td>

<td>SVG animations can be changed and controlled right inside the SVG code—or anywhere the animations are defined, usually using a few lines of code.</td>

</tr>

</tbody>

</table>

## File Size, Page Load Time & Performance

In the previous section, we focused on the performance of the animation itself. In this one, I want to shed some light on the page performance as a whole and how it is affected by the image format choice you make.

Fact: The bigger the file size, the more the negative impact on page load time and performance. With that in mind, let's see how using SVG instead of GIFs can help improve the overall page load time by looking at a more practical, real-world example.

At my first SVG talk, 18 months ago, I mentioned how SVG can be used to replace animated GIFs and result in overall better page performance. In that talk, I provided a real-world example of a real-world web page that took advantage of what SVG has to offer and reaped the benefits: the [Sprout](http://sprout.is/) homepage.

The Sprout homepage has two animated images that were initially created and displayed as GIFs. Two years ago, [Mike Fortress](https://twitter.com/mfortress) wrote [an article on the Oak blog](http://oak.is/thinking/animated-svgs/), in which he explains how they recreated the animated GIFs, particularly the chart GIF (see image below) as an animated SVG image.

![](https://sarasoueidan.com/images/svg-vs-gif--sprout-chart.svg)

The SVG version of the chart used on the Sprout homepage and written about on the Oak article. <small>(All rights reserved by their owners.)</small>

Note that the animation is created using SMIL so it will not be animating if you’re viewing it in Internet Explorer.





In his article, Mike shares some interesting insights on their new page performance as a result of making the switch to SVG:

> This chart, and one other animation on Sprout, were initially GIFs. By using animated SVGs instead of GIFs we were able to reduce our page size **from 1.6 mb to 389 kb**, and reduce our page load time **from 8.75 s to 412 ms**. That’s a huge difference.
> 
> <cite>—Mike Fortress, [“Animated SVGs: Custom Easing and Timing”](http://oak.is/thinking/animated-svgs/)</cite>

A huge difference indeed.

The Sprout chart is a perfect candidate for SVG. There is no reason to animate it by converting the animation into a GIF recording, when SVG can bring so much more benefits.

[Jake Archibald](https://jakearchibald.com/) realizes the power of SVG animations too, and uses them to create and animate interactive illustrations to complement his articles. His [Offline Cookbook](https://jakearchibald.com/2014/offline-cookbook/) article is an excellent example (and an excellent article, by the way). Could he have used GIFs to do that? Of course. But given the number of images he used, the GIFs could have easily increased the overall page size to a couple or few megabytes, with each GIF being at least hundreds of kilobytes in size; whereas **the entire web page currently weighs at 128KB only with _all_ the SVG images embedded inline**, because [you can reuse elements in SVG](https://sarasoueidan.com/blog/structuring-grouping-referencing-in-svg), so any repetitive elements will not only cause the entire page to [gzip much, much better](http://calendar.perfplanet.com/2014/tips-for-optimising-svg-delivery-for-the-web/), but for each page, the overall size of the SVGs becomes smaller.

Now _that_ is impressive.

I will rest my case about page load and performance here. But it is still important to note that there _can_ be exceptions. Again, in most cases, you’re likely going to find that SVG is better than a GIF, but you’ll always need to test anyway.

**Conclusion**:

<table>

<tbody>

<tr>

<td>GIF</td>

<td>Animated SVG</td>

</tr>

<tr>

<td>GIF images are generally bigger in size than SVG images are with animations added to them. This negatively affects the overall page size, load times and performance.</td>

<td>SVG images can be used and reused, as well as gzipped better, making their file sizes generally smaller than those of GIFs, thus improving page load times and performance.</td>

</tr>

</tbody>

</table>

## Browser Support

Probably the only absolute advantage to GIFs over SVGs is browser support. GIFs work pretty much everywhere, while SVG support is less global. Even though we have many [ways to provide fallback for non-supporting browsers](https://css-tricks.com/a-complete-guide-to-svg-fallbacks/)—and current browser support should not be hindering anyone from using SVG, the fallback images, if provided as PNG or JPG, are going to be static, animation-less.

Of course, you can always provide a GIF as a fallback to SVG, but the previously-mentioned considerations and disadvantages should be kept in mind.

**Conclusion**:

<table>

<tbody>

<tr>

<td>GIF</td>

<td>Animated SVG</td>

</tr>

<tr>

<td>GIF images work pretty much everywhere.</td>

<td>SVG images have less global browser support, but they come with a lot of ways to provide fallback for non-supporting browsers.</td>

</tr>

</tbody>

</table>

## Accessibility Concerns (#a11y)

Move something on a page, or anywhere, for that matter, and you've instantly added a distraction—something that is sure to grab a user’s attention as soon as it starts moving. This is simply how the human brain works. This is also one of the reasons ad banners are so focused on—and built with—a strong focus on animation. This is also why animated ad banners are **extremely annoying**. They are distracting, especially when you're trying to perform a task on a page that requires your entire attention, such as reading an article.

Now imagine a page with a set of animated icons (or images) that just won't stop animating no matter what you do. We’re no longer talking about one or two images on a homepage or within an article here; we’re talking about UI elements and controls, and smaller icons that are likely to be present in multiple places on a page, and on multiple pages. Unless your icon is _supposed_ to be inifnitely animation—for example, if it is a spinner animating during a user-inactive waiting phase, then it is likely to introduce a problem, and become more of an annoyance, than a “nice thing”.

As a matter of fact, for some people it can become more of an annoyance, as continuous motion can literally make some people feel ill.

In her article [“Designing Safer Web Animation For Motion Sensitivity”](http://alistapart.com/article/designing-safer-web-animation-for-motion-sensitivity), designer and web animation consultant Val Head discusses the effects of overused animation on the web on people with visually-triggered vestibular disorders (emphasis mine):

> It’s no secret that a lot of people consider scrolljacking and parallax effects annoying and overused. But what if motion does more than just annoy you? What if it also makes you ill?
> 
> That’s a reality that people with visually-triggered vestibular disorders have to deal with. As animated interfaces increasingly become the norm, more people have begun to notice that **large-scale motion on screen can cause them dizziness, nausea, headaches, or worse. For some, the symptoms can last long after the animation is over.** Yikes.

Now imagine if the animation does _not_ end... Double Yikes.

Val’s article explains the problem in more detail, as she gathers feedback from two people who actually have these problems and share their experience with animation in different examples.

One of the solutions that can help avoid these problems is to [provide the user with the ability to control the animation](http://alistapart.com/article/designing-safer-web-animation-for-motion-sensitivity#section10) so that they can stop it when it gets disturbing.

With SVG, you can do that. You can fully control the animation and play it once or twice on page load—if you really need to have it play as soon as the user “enters” your page, and then fire it on hover for subsequent tweens, using nothing but a few lines of CSS or JavaScript. **You do not need hundreds or thousands of lines of CSS or JavaScript to create an icon animation**, unless your icon is a really complex scene with a lot of components that are animated inside of it. But I think that in that case, it does not count as an “icon” anymore, but more of a regular image.

You can go even as far as control playback, speed for each consequent tween, and much more, assuming, of course, you are using JavaScript to gain this level of control.

Or you can add a toggle to give the user the ability to stop an infinitely playing animation. You can’t do that with GIFs... unless you opt for replacing the GIF with a static image upon a certain toggle action.

Some might even argue that you could display a static version of the image—as a PNG for example, and then provide the GIF version on hover. But this comes with a few problems of its own:

*   If the images are inline, you’ll need to replace these images using JavaScript. That action does not require any JavaScript if you are using SVG.
*   If the images are foreground images (embedded in the HTML using ), and you need to replace these images, you will end up with double the amount of HTTP requests for every image. And if they are background images inlined in the style sheet (which is not recommended), the images (especially the GIFs) will add to the size of the style sheet and therefore to the overall render-blocking time of the page.
*   If/when you switch image sources on hover, there is a noticable flash between the first and the second image on slower connections. My connection is slow; sometimes 3G-slow, and I have yet to remember a time when an image was replaced with another one on hover, viewport resize, or whatever, and not have seen that flash. This situation gets even worse when the second image (GIF loaded on hover) is fairly big in size—there will be a flash, followed by a slow, janky animation of the GIF while it loads completely. That’s never attractive.

So, yes, you can switch image sources to control if or when the GIF animation plays, but you’re losing the finer control over the GIF and affecting the user’s experience with the UI.

You are also able to control how many times the animation plays in the GIF—which is pretty cool, but that means that the animation will play only **_n_** number of times. And then to re-fire the animation upon a user interaction, you will need to resort to the above technique with multiple images.

Multiple images to maintain, multiple HTTP requests, and an overall hacky, non-optimal solution to what could have been easily achieved with one SVG image.

*   Embed the **one** SVG image on the page.
*   Create the animation any way you want/need. (Or create the animation before you embed the image.)
*   Play, pause, control the animation; and give the user the ability to control it as well.

No extra HTTP requests for every image, no complicated animation timeline maintenance in graphics editors, and no accessibility concerns or woes that cannot be avoided with a few lines of code.

**Conclusion**:

<table>

<tbody>

<tr>

<td>GIF</td>

<td>Animated SVG</td>

</tr>

<tr>

<td>GIF images cannot be stopped by the user without requiring extra images and extra HTTP requests. Even then, the control is not full.</td>

<td>SVG animations can be fully customized so that they are enabled, disabled and controlled by the user without requiring any hacky approaches.</td>

</tr>

</tbody>

</table>

### Content Accessibility

<table>

<tbody>

<tr>

<td>GIF</td>

<td>Animated SVG</td>

</tr>

<tr>

<td>GIF images are only as accessible as PNG and JPEG images are—using an appropriate `alt` attribue value to describe them.

The content inside the image cannot be discerned or made directly accessible to screen readers beyond what the overall image description does.

</td>

<td>SVG images are accessible as well as semantic. The content inside the image that is being animated can also be described and made accessible to screen readers using SVG’s built-in accessibility elements, and enhanced using ARIA roles and attributes as well. (You can read all about making SVGs accessible [here](http://www.sitepoint.com/tips-accessible-svg/).)</td>

</tr>

</tbody>

</table>

## Interactivity

There’s not much to add here but the fact that you can interact with individual elements inside an SVG, during, before or after an animation, but that is not possible with a GIF. So, if you use a GIF, you will lose the ability to do anything beyond triggering or stopping the animation, and even those are not really done inside the SVG, as we’ve seen, but are achieved by swapping the GIF out with a static replacement. Even changing the colors of elements inside the GIF would require additional images to do so. That is yet another advantage to using SVG over GIFs.

**Conclusion**:

<table>

<tbody>

<tr>

<td>GIF</td>

<td>Animated SVG</td>

</tr>

<tr>

<td>Animations defined in GIF images cannot be interactive. You cannot interact with individual elements inside a GIF element, nor create links out of individual elements either.</td>

<td>SVG content is fully interactive. You can create hover and click interactions (and more) to which individual elements inside the SVG image can respond.</td>

</tr>

</tbody>

</table>

## Responsive & Adaptive Animations

The ability to animate SVG directly from the code, as well as manipulate its many, many attributes, results in and adds yet another advantage over GIF-based animations: the ability to create responsive, adaptive and performant animations, without adding any extra HTTP requests, using a few lines of code, and with quite smaller file sizes.

Sarah Drasner wrote [an article on Smashing Magazine](http://www.smashingmagazine.com/2015/03/different-ways-to-use-svg-sprites-in-animation/) showing different ways to animate SVG sprites. One of these ways is having multiple "scenes" inside an SVG, animating them with CSS, and then changing the SVG "view"—by changing the value of [the `viewBox` attribute](https://sarasoueidan.com/blog/svg-coordinate-systems)—to show one scene at a time, depending on the current viewport size and available screen estate.

If you wanted to create the same animation using GIF images, you would lose the animation control capabilities as well as require multiple images which are probably going to be bigger (in file size) than the one SVG image.

But if you don't want to go with animating SVG code, you could always create an SVG sprite and animate it the way you would animate any other image format—using `steps()` and a few lines of CSS. Sarah also talks about this technique in her article. Animating SVG images does not need to be complicated, and is generally performant.

**Conclusion**:

<table>

<tbody>

<tr>

<td>GIF</td>

<td>Animated SVG</td>

</tr>

<tr>

<td>Given that content inside a GIF cannot be controlled with code, it is not possible to make the animations adapt or respond to viewport or context changes without resorting to seperate images.</td>

<td>Given that SVG content is directly animatable using code, the content as well as its animations can be modified so that they respond and/or adapt to different viewport sizes and contexts, without having to resort to any additional assets.</td>

</tr>

</tbody>

</table>

## Final Words

GIFs have pretty good browser support, yes, but the advantages of SVGs outweigh theirs in almost every aspect. There might be exceptions, and in those cases do, by all means, use GIFs or any other image format that does a better job than SVG would. You might even use Video or HTML5 Canvas or whatever.

SVG can bring a lot of performance benefits to the table when compared to other image formats, especially GIFs.

Thus, given all of the above, I recommend that anywhere SVG could be used for animation, GIFs should be avoided. You’re free to ignore my recommendation, of course, but you’d be giving up on the many benefits that SVG animations offer.

Unless GIFs show a lot of advantages over SVGs that go beyond browser support for IE8 and below, then I believe SVGs should be the way to go.

A few resources to help you get started with SVG animations:

*   [The State of SVG Animation](http://blogs.adobe.com/dreamweaver/2015/06/the-state-of-svg-animation.html)
*   [A Few Different Ways to Use SVG Sprites in Animation](http://www.smashingmagazine.com/2015/03/different-ways-to-use-svg-sprites-in-animation/)
*   [Creating Cel Animations with SVG](http://www.smashingmagazine.com/2015/09/creating-cel-animations-with-svg/)
*   [GreenSock](http://greensock.com) has a bunch of very useful articles on animating SVGs
*   [Snap.svg](http://snapsvg.io/start/), also known as “The jQuery of SVG”
*   [SVG Animations Using CSS and Snap.SVG](https://davidwalsh.name/svg-animations-snap)
*   [Styling and Animating SVGs with CSS](http://www.smashingmagazine.com/2014/11/styling-and-animating-svgs-with-css/)
*   [Animated Line Drawing in SVG](https://jakearchibald.com/2013/animated-line-drawing-svg/)

* * *

I hope you found this article useful.

Thank you for reading.

Many thanks to Jake Archibald for reviewing and giving feedback to the article, and to Chris Lilley for his feedback re transparency in GIF images. It wouldn’t have been so comprehensive (read: ridiculously long) without their feedback. ^^
