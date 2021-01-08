> * 原文地址：[10 JavaScript Image Manipulation Libraries for 2020](https://blog.bitsrc.io/image-manipulation-libraries-for-javascript-187fde1ad5af)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/image-manipulation-libraries-for-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/image-manipulation-libraries-for-javascript.md)
> * 译者：[IAMSHENSH](https://github.com/IAMSHENSH)
> * 校对者：[niayyy-S](https://github.com/niayyy-S)

# 2020 十大 JavaScript 图像处理库

![](https://cdn-images-1.medium.com/max/2560/1*lXwMUm79vvrK_ZjazwqcbA.jpeg)

用 JavaScript 处理图像可能非常困难且繁琐。幸运的是，有许多库可以使这事变得非常简单。以下是我最喜欢的不同类别的库。

如果你发现有用的东西，尝试将其封装成所选框架的组件。通过这种方式，你将拥有一个具备声明式 API 的可复用组件，并随时可用。

## 1. Pica

此插件可助你减小大图的上传大小，从而节省上传时间。它允许你在浏览器中调整图像大小，响应迅速并且不会出现像素化，因为它会从 Web Workers、WebAssembly、createImageBitmap 方法以及纯 JavaScript 中自动选择最佳的可用技术。

[演示](http://nodeca.github.io/pica/demo/)
[Github](https://github.com/nodeca/pica)

![](https://cdn-images-1.medium.com/max/2086/1*01gc8wM7mYZxRvzM592r-A.png)

---

## 2. Lena.js

这个炫酷的图像库虽然非常小，但其大约有 22 个图像滤镜，非常好玩。你还可以向 GitHub 仓库中创建并添加新滤镜。

[演示](https://fellipe.com/demos/lena-js/)
[教程](https://ourcodeworld.com/articles/read/515/how-to-add-image-filters-photo-effects-to-images-in-the-browser-with-javascript-using-lena-js)
[Github](https://github.com/davidsonfellipe/lena.js)

![](https://cdn-images-1.medium.com/max/2718/1*rLKUyfeo_LUvvcRr7cYN0Q.png)

---

## 3. Compressor.js

这是一个简单的 JavaScript 图像压缩器，它使用浏览器原生的 [canvas.toBlob](https://developer.mozilla.org/en-US/docs/Web/API/HTMLCanvasElement/toBlob) API 来处理图像压缩。这使你可以在 0 到 1 之间设置压缩输出质量。

[演示](https://fengyuanchen.github.io/compressorjs/)
[Github](https://github.com/fengyuanchen/compressorjs)

![](https://cdn-images-1.medium.com/max/2334/1*hp85KWNmfPftt0MFj_qtEA.png)

---

## 4. Fabric.js

Fabric.js 允许你使用 JavaScript 在网页上的 HTML `\ <canvas>` 元素上轻松创建简单的形状，例如矩形、圆形、三角形和其他多边形，或者由许多路径组成的更复杂的形状。Fabric.js 还允许你使用鼠标来操纵这些对象的大小，位置和旋转。

也可以使用 Fabric.js 库更改这些对象的属性，例如它们的颜色，透明度，网页上的深度位置，或选择这些对象的组。Fabric.js 还允许你将 SVG 图像转换为 JavaScript 数据，并直接在 `\ <canvas>` 元素中使用。

[演示](http://fabricjs.com/)
[教程](http://fabricjs.com/articles/)
[Github](https://github.com/fabricjs/fabric.js)

![](https://cdn-images-1.medium.com/max/2000/1*XRnIeG6-8cZe9BGjt5Hf-w.png)

---

## 5. Blurify

这是一个很小的（约 2kb）库，用于模糊图片，并具有从 `css` 模式到 `canvas` 模式的优秀降级支持。该插件在以下三种模式下工作：

* `css`：使用 `filter` 属性（默认）
* `canvas`：使用 `canvas` 导出 base64 格式
* `auto`：优先使用 `css` 模式，不支持则自动转换为 `canvas` 模式

你只需要将图像，模糊值和模式传递给函数，即可简单有效地获得模糊图像。

[演示](https://justclear.github.io/blurify/)
[Github](https://github.com/JustClear/blurify)

![](https://cdn-images-1.medium.com/max/2590/1*9qSBhOXTK3ao_69WZDp0Cw.png)

---

## 6. Merge Images

该库让你可以轻松地合成图像，而不会弄乱画布。有时，使用画布可能会有些痛苦，尤其是在你只需要一个画布上下文来执行相对简单的操作时（例如合并图像）。`merge-images` 将所有重复性任务抽象为一个简单的函数。

图像可以彼此重叠和调换位置。该函数返回一个 `Promise`，并 `resolve` 一个 base64 数据类型的 URI。同时支持浏览器和 Node.js。

[Github](https://github.com/lukechilds/merge-images)

![](https://cdn-images-1.medium.com/max/2000/1*xJZYntWFYwkMJ-ljBuB47g.png)

---

## 7. Cropper.js

该插件是一个简单的 JavaScript 图像裁剪器，允许在可交互的环境中裁剪、旋转和缩放图像。它还允许设置纵横比。

[演示](https://fengyuanchen.github.io/cropperjs/)
[Github](https://github.com/fengyuanchen/cropperjs)

![](https://cdn-images-1.medium.com/max/2000/1*zrOLnVUpw-97XRCZ2mFuaw.png)

---

## 8. CamanJS

这是 JavaScript 的画布操作库。其具有简单易用的接口与先进高效的图像/画布编辑技术。通过新滤镜和插件很容易进行扩展，并且它具有一系列的图像编辑功能，而这种功能还在不断增加。它完全无依赖，并可以同时在 Node.js 和浏览器中使用。

你可以选择一组预设滤镜或手动更改属性（例如亮度，对比度，饱和度）以获得所需的结果。

[演示](http://camanjs.com/examples/)
[官网](http://camanjs.com/)
[Github](https://github.com/meltingice/CamanJS/)

![](https://cdn-images-1.medium.com/max/2000/1*ORO_SftbsqsTRQudlvfn2A.png)

---

## 9. MarvinJ

MarvinJ 是派生自 Marvin 框架的纯 JavaScript 图像处理框架。MarvinJ 对于许多不同的图像处理应用程序而言，既简单又强大。

Marvin 除了提供许多算法来控制颜色和外观，还具有自动检测特征的能力。其图像处理能力是基于图像的基础特征（例如边缘、拐角与形状）来实现的。此插件通过检测与分析对象的角点，从而定位场景中主要对象。基于这些功能，让它可以自动裁剪出对象。

[官网](https://www.marvinj.org/en/index.html)
[Github](https://github.com/gabrielarchanjo/marvinj)

![](https://cdn-images-1.medium.com/max/2462/1*oC9aNZECOL97bXRZSdjp_Q.png)

---

## 10. Grade

此 JavaScript 库从图像中的前 2 种主要颜色生成互补的渐变。这样，你就可以从图像中提取出渐变效果，来填充网站上的 `div`。这是一个易用的插件，可帮助你保持网站视觉上的优美。

该插件是我个人从此列表中挑选出来的，我经历了许多困难才通过此插件获得类似的输出。

**HTML 文件**

```html
<!--渐变将应用于这些外部 div，作为背景图像-->
<div class="gradient-wrap">
    <img src="./samples/finding-dory.jpg" alt="" />
</div>
<div class="gradient-wrap">
    <img src="./samples/good-dinosaur.jpg" alt="" />
</div>
```

**JavaScript 脚本**

```html
<script src="path/to/grade.js"></script>
<script type="text/javascript">
    window.addEventListener('load', function(){
        /*
            你所有图像容器的节点列表（或单个节点）。
            该库将在每个容器中找到一个 <img /> 来创建渐变。
         */
        Grade(document.querySelectorAll('.gradient-wrap'))
    })
</script>
```

[演示](https://benhowdle89.github.io/grade/)
[Github](https://github.com/benhowdle89/grade)

![](https://cdn-images-1.medium.com/max/2326/1*-SqADlYfholv_yjT9YY75Q.png)

---

希望你喜欢本文。如果你觉得有什么需要补充，请随时评论。

编码愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
