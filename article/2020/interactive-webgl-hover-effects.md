> * 原文地址：[Interactive WebGL Hover Effects](https://tympanus.net/codrops/2020/04/14/interactive-webgl-hover-effects/)
> * 原文作者：[Yuriy Artyukh](https://tympanus.net/codrops/author/akella/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/interactive-webgl-hover-effects.md](https://github.com/xitu/gold-miner/blob/master/article/2020/interactive-webgl-hover-effects.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[jacob-lcs](https://github.com/jacob-lcs)、[whatwewant](https://github.com/whatwewant)、[rachelcdev](https://github.com/rachelcdev)

# 如何实现交互式 WebGL 悬停效果

> 本文主要内容是介绍如何通过一些简单的步骤，在图像上实现交互式鼠标悬停效果。

[查看 Demo](https://tympanus.net/Tutorials/webgl-mouseover-effects/step3.html) \& [下载源码](https://github.com/akella/webgl-mouseover-effects/archive/master.zip)

我很喜欢 WebGL，在本文中，我将介绍如何在掌握着色器基础上做出炫酷效果。我想要重现的这个效果，源自 [Jesper Landberg](https://jesperlandberg.dev/) 的网站，他是一个非常酷的家伙，请务必查看一下他网站上的东西。

![](https://user-images.githubusercontent.com/5164225/90354320-8d090800-e07b-11ea-8a3c-6b35ea7de050.gif)

让我们开始吧！让我们从编写简单的 HTML 开始：

```html
<div class="item">
    <img src="img.jpg" class="js-image" alt="">
    <h2>Some title</h2>
    <p>Lorem ipsum.</p>
</div>
<script src="app.js"></script>
```

这个例子再简单不过了！接下来，让我们来添加些样式，以使其它起来更漂亮：

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2020/04/webglhover.jpg)

所有动画效果将在 Canvas 元素中呈现，同时我们还需要添加部分 JavaScript 代码。我在这里使用 [Parcel](https://parceljs.org/)，因为学习起来非常简单，我还将在 WebGL 部分中使用 [Three.js](https://threejs.org/)。

到这里，我们开始编写 JavaScript 代码，并按照官方文档着手进行基本的 Three.js 设置：

```js
import * as THREE from "three";

var scene = new THREE.Scene();
var camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 );

var renderer = new THREE.WebGLRenderer();
renderer.setSize( window.innerWidth, window.innerHeight );
document.body.appendChild( renderer.domElement );


camera.position.z = 5;

var animate = function () {
	requestAnimationFrame( animate );

	cube.rotation.x += 0.01;
	cube.rotation.y += 0.01;

	renderer.render( scene, camera );
};

animate();
```

让我们设置 Canvas 元素的样式：

```css
body { margin: 0; }

canvas { 
	display: block; 
	position: fixed;
	z-index: -1; // 将其设置为背景
	left: 0; // 铺满整个屏幕
	top: 0; // 铺满整个屏幕
}
```

当你完成所有这些操作，就可以使用 `parcel index.html` 运行它。现在，您不会看到太多，到目前为止，它是一个空的 3D 场景。让我们暂时搁置 HTML，专注于 3D 场景操作。

让我们创建一个带有图像的简单 [PlaneBufferGeometry](https://threejs.org/docs/#api/en/geometries/PlaneBufferGeometry) 对象。像这样：

```js
let TEXTURE = new TextureLoader().load('supaAmazingImage.jpg'); 
let mesh = new Mesh(
	new PlaneBufferGeometry(), 
	new MeshBasicMaterial({map: TEXTURE})
)
```

现在，我们将看到以下内容：

![](https://user-images.githubusercontent.com/5164225/90354323-909c8f00-e07b-11ea-9a1c-be5642528f2a.gif)

显然我们还没有实现效果，我们需要追踪鼠标的颜色轨迹。当然，我们还需要着色器。如果您对着色器感兴趣，或者您可能已经学过一些有关如何放置图像的教程，例如[如何将鼠标放在悬停位置上？](https://tympanus.net/codrops/2018/04/10/webgl-distortion-hover-effects/)[液体变形效果？](https://tympanus.net/codrops/2017/10/10/liquid-distortion-effects/)

但是我们有一个问题：我们只能在上面的示例中在该图像上（和内部）使用着色器。但是效果并不局限于任何图像边界，而是流动的，覆盖整个区域，就像整个屏幕一样。

## 后期处理进行渲染

事实证明 Three.js 渲染器的输出只是另一幅图像。我们可以利用它，并在该输出上应用着色器位移！

这是代码的补充部分：

```js
// 设置后期处理
let composer = new EffectComposer(renderer);
let renderPass = new RenderPass(scene, camera);
// 用图像渲染场景
composer.addPass(renderPass);

// 我们的自定义着色器传递整个屏幕，以替换以前的渲染
let customPass = new ShaderPass({vertexShader,fragmentShader});
// 确保我们正在渲染它
customPass.renderToScreen = true;
composer.addPass(customPass);

// 最后真正使用我们的着色器渲染场景
composer.render()
// 而不是以前的 render()
// renderer.render(scene, camera);
```

但整个过程用一句话概括就是，着色器被应用到了整个屏幕上。

接下来，让我们完成具有炫酷效果的最终着色器：

```js
// 在鼠标周围留一个小圆圈，并保持一定距离
float c = circle(uv, mouse, 0.0, 0.2);
// 获取 3 次纹理，每次具有不同的偏移量，具体取决于鼠标速度：
float r = texture2D(tDiffuse, uv.xy += (mouseVelocity * .5)).x;
float g = texture2D(tDiffuse, uv.xy += (mouseVelocity * .525)).y;
float b = texture2D(tDiffuse, uv.xy += (mouseVelocity * .55)).z;
// 将所有内容合并到最终输出
color = vec4(r, g, b, 1.);
```

您可以在[第一个演示](https://tympanus.net/Tutorials/webgl-mouseover-effects/step1.html)中看到此结果。

## 将效果应用于多张图像

屏幕具有不同尺寸，3D 图像也各自具有尺寸。因此，我们现在要做的是计算这两者之间的某种关系。

就像我一样吗？在[上一篇文章](https://tympanus.net/codrops/2019/11/05/creative-webgl-image-transitions/)中，我们可以制作一个宽度为 1 的平面，并将其完全适配屏幕宽度。所以实际上，我们使用了： `WidthOfPlane=ScreenSize`。

对于我们的 Three.js 场景，这意味着如果要在屏幕上显示 100px 宽的图像，我们将创建一个 Three.js 对象，其宽度为 `100*(WidthOfPlane/ScreenSize)`。通过这种数学运算，我们还可以轻松设置一些边距和位置。

页面加载后，我将遍历所有图像，获取它们的尺寸，并将它们添加到我的 3D 世界中：

```js
let images = [...document.querySelectorAll('.js-image')];
images.forEach(image=>{
	// 现在，我们有了图像的大小和左边、上边的位置
	let dimensions = image.getBoundingClientRect();
	// 隐藏原始图像
	image.style.visibility = hidden;
	// 根据其 HTML 将 3D 对象添加到场景中
	createMesh(dimensions);
})
```

现在，制作[这个](https://tympanus.net/Tutorials/webgl-mouseover-effects/step1.html)[HTML-3D混合结构](https://tympanus.net/Tutorials/webgl-mouseover-effects/step2.html)非常简单。

关于 `mouseVelocity` 我想补充的是，我用它来改变效果的半径，鼠标移动得越快，半径越大。

要使其可滚动，我们只需要移动整个场景即可，与滚动屏幕的数量相同。使用我之前提到的相同公式：`NumberOfPixels*(WidthOfPlane/ScreenSize)`。

有时，`WidthOfPlane` 等于甚至更容易 `ScreenSize`。这样，您最终在两个世界中得到的数字完全相同！

## 探索不同的效果

使用不同的着色器，您可以使用此方法产生任何效果。因此，我决定使用一些参数。

无需将图像分为三个颜色层，我们可以根据与鼠标的距离来简单地移动图像：

```js
vec2 newUV = mix(uv, mouse, circle); 
color = texture2D(tDiffuse,newUV);
```

对于最后一个效果，我使用了一些随机性，以在鼠标光标周围获得像素化效果。

在[最后一个演示](https://tympanus.net/Tutorials/webgl-mouseover-effects/step3.html)中，您可以在效果之间切换以查看可以进行的一些修改。有了“缩放”效果，我只使用了一个位移，但是在最后一个中，我还对像素进行了随机化，这对我来说看起来很酷！

很高兴看到您对此动画的想法。您将用这种技术产生什么样的效果？

在 [GitHub](https://github.com/akella/webgl-mouseover-effects/) 上找到这个项目。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
