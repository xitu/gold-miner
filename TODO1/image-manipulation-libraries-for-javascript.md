> * 原文地址：[10 JavaScript Image Manipulation Libraries for 2020](https://blog.bitsrc.io/image-manipulation-libraries-for-javascript-187fde1ad5af)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/image-manipulation-libraries-for-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/image-manipulation-libraries-for-javascript.md)
> * 译者：
> * 校对者：

# 10 JavaScript Image Manipulation Libraries for 2020

![](https://cdn-images-1.medium.com/max/2560/1*lXwMUm79vvrK_ZjazwqcbA.jpeg)

Working with images in JavaScript can be quite difficult and cumbersome. Thankfully, there are a number of libraries that can make things a lot easier. Below are my favorite ones in different categories.

If you’ve found something useful, try to wrap it as a component of your framework of choice. This way, you’d have a reusable component with a declarative API, always ready to be used.

## 1. Pica

This plugin helps you reduce upload size for large images thereby saving upload time. It allows you to resize images in your browser without pixelation and reasonably fast. It autoselects the best of available technologies out of web-workers, web assembly, createImageBitmap and pure JS.

[Demo](http://nodeca.github.io/pica/demo/)
[Github](https://github.com/nodeca/pica)

![](https://cdn-images-1.medium.com/max/2086/1*01gc8wM7mYZxRvzM592r-A.png)

---

## 2. Lena.js

This cool image library is very tiny in size but has around 22 image filters that are pretty cool to play around with. You can also create and add new filters to the Github repo as well.

[Demo](https://fellipe.com/demos/lena-js/)
[Tutorial](https://ourcodeworld.com/articles/read/515/how-to-add-image-filters-photo-effects-to-images-in-the-browser-with-javascript-using-lena-js)
[Github](https://github.com/davidsonfellipe/lena.js)

![](https://cdn-images-1.medium.com/max/2718/1*rLKUyfeo_LUvvcRr7cYN0Q.png)

---

## 3. Compressor.js

This is a simple JS image compressor that uses the Browser’s native [canvas.toBlob](https://developer.mozilla.org/en-US/docs/Web/API/HTMLCanvasElement/toBlob) API to handle the image compression. This allows you to set the compression output quality ranging from 0 to 1.

[Demo](https://fengyuanchen.github.io/compressorjs/)
[Github](https://github.com/fengyuanchen/compressorjs)

![](https://cdn-images-1.medium.com/max/2334/1*hp85KWNmfPftt0MFj_qtEA.png)

---

## 4. Fabric.js

Fabric.js allows you to easily create simple shapes like rectangles, circles, triangles and other polygons or more complex shapes made up of many paths, onto the HTML `\<canvas>` element on a webpage using JavaScript. Fabric.js will then allow you to manipulate the size, position and rotation of these objects with a mouse.

It’s also possible to change some of the attributes of these objects such as their colour, transparency, depth position on the webpage or selecting groups of these objects using the Fabric.js library. Fabric.js will also allow you to convert an SVG image into JavaScript data that can be used for putting it onto the `\<canvas>` element.

[Demo](http://fabricjs.com/) 
[Tutorials](http://fabricjs.com/articles/)
[Github](https://github.com/fabricjs/fabric.js)

![](https://cdn-images-1.medium.com/max/2000/1*XRnIeG6-8cZe9BGjt5Hf-w.png)

---

## 5. Blurify

This is a tiny(~2kb) library to blur pictures, with graceful downgrade support from `css` mode to `canvas` mode. This plugin works under three modes:

* `css`: use `filter` property(`default`)
* `canvas`: use `canvas` export base64
* `auto`: use `css` mode firstly, otherwise switch to `canvas` mode by automatically

You are simply required to pass the images, blur value and mode to the function to get the blurred image-simple and efficient.

[Demo](https://justclear.github.io/blurify/)
[Github](https://github.com/JustClear/blurify)

![](https://cdn-images-1.medium.com/max/2590/1*9qSBhOXTK3ao_69WZDp0Cw.png)

---

## 6. Merge Images

This library allows you to easily compose images together without messing around with canvas. Canvas can be kind of a pain to work with sometimes, especially if you just need a canvas context to do something relatively simple like merge some images together. `merge-images` abstracts away all the repetitive tasks into one simple function call.

Images can be overlaid on top of each other and repositioned. The function returns a Promise which resolves to a base64 data URI. Supports both the browser and Node.js.

[Github](https://github.com/lukechilds/merge-images)

![](https://cdn-images-1.medium.com/max/2000/1*xJZYntWFYwkMJ-ljBuB47g.png)

---

## 7. Cropper.js

This plugin is a simple JavaScript image cropper that allows you to crop, rotate, scale, zoom around your images in an interactive environment. It also allows the aspect ratios to be set as well.

[Demo](https://fengyuanchen.github.io/cropperjs/)
[Github](https://github.com/fengyuanchen/cropperjs)

![](https://cdn-images-1.medium.com/max/2000/1*zrOLnVUpw-97XRCZ2mFuaw.png)

---

## 8. CamanJS

It is a canvas manipulation library for Javascript. It’s a combination of a simple-to-use interface with advanced and efficient image/canvas editing techniques. It is very easy to extend with new filters and plugins, and it comes with a wide array of image editing functionality, which continues to grow. It’s complete library independent and works both in NodeJS and the browser.

You can choose a set of preset filters or change properties such as brightness, contrast, saturation manually to get the desired output.

[Demo](http://camanjs.com/examples/)
[Website](http://camanjs.com/)
[Github](https://github.com/meltingice/CamanJS/)

![](https://cdn-images-1.medium.com/max/2000/1*ORO_SftbsqsTRQudlvfn2A.png)

---

## 9. MarvinJ

MarvinJ is a pure javascript image processing framework derived from Marvin Framework. MarvinJ is easy and powerful for many different image processing applications.

Marvin provides many algorithms to manipulate colour and appearance. Marvin also detects features automatically. The ability to work with basic image features like edges, corners and shapes are fundamental to image processing. The plugin helps to detect and analyze the corners of objects in order to determine the position of the main object in the scene. Due to these points, it is possible to automatically crop out the object.

[Website](https://www.marvinj.org/en/index.html)
[Github](https://github.com/gabrielarchanjo/marvinj)

![](https://cdn-images-1.medium.com/max/2462/1*oC9aNZECOL97bXRZSdjp_Q.png)

---

## 10. Grade

This JS library produces complementary gradients generated from the top 2 dominant colours in supplied images. This allows your website to fill your div with a matching gradient derived from your image. This is an easy to use plugin that helps you keep your website visually pleasing.

This plugin would be my personal pick out of this list as I have gone through so much trouble to achieve a similar output given by this plugin.

**The HTML file**

```html
<!--the gradients will be applied to these outer divs, as background-images-->
<div class="gradient-wrap">
    <img src="./samples/finding-dory.jpg" alt="" />
</div>
<div class="gradient-wrap">
    <img src="./samples/good-dinosaur.jpg" alt="" />
</div>
```

**The JS script**

```html
<script src="path/to/grade.js"></script>
<script type="text/javascript">
    window.addEventListener('load', function(){
        /*
            A NodeList of all your image containers (Or a single Node).
            The library will locate an <img /> within each
            container to create the gradient from.
         */
        Grade(document.querySelectorAll('.gradient-wrap'))
    })
</script>
```

[Demo](https://benhowdle89.github.io/grade/)
[Github](https://github.com/benhowdle89/grade)

![](https://cdn-images-1.medium.com/max/2326/1*-SqADlYfholv_yjT9YY75Q.png)

---

Hope you liked this article. If you think something deserves to be on this, feel free to comment your pick.

Happy Coding!


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
