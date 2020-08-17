> * 原文地址：[Interactive WebGL Hover Effects](https://tympanus.net/codrops/2020/04/14/interactive-webgl-hover-effects/)
> * 原文作者：[Yuriy Artyukh](https://tympanus.net/codrops/author/akella/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/interactive-webgl-hover-effects.md](https://github.com/xitu/gold-miner/blob/master/article/2020/interactive-webgl-hover-effects.md)
> * 译者：
> * 校对者：

# Interactive WebGL Hover Effects

> A simple tutorial on how to achieve an interactive mouseover/hover effect on images in some easy steps.

[View demo](https://tympanus.net/Tutorials/webgl-mouseover-effects/step3.html)\& [Download Source](https://github.com/akella/webgl-mouseover-effects/archive/master.zip)

I love WebGL, and in this article I will explain one of the cool effects you can make if you master shaders. The effect I want to recreate is originally from [Jesper Landberg’s website](https://jesperlandberg.dev/). He’s a really cool dude, make sure to check out his stuff:

![](https://user-images.githubusercontent.com/5164225/90354320-8d090800-e07b-11ea-8a3c-6b35ea7de050.gif)

So let’s get to business! Let’s start with this simple HTML:

```html
<div class="item">
    <img src="img.jpg" class="js-image" alt="">
    <h2>Some title</h2>
    <p>Lorem ipsum.</p>
</div>
<script src="app.js"></script>
```

Couldn’t be any easier! Let’s style it a bit to look prettier:

![](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2020/04/webglhover.jpg)

All the animations will happen in a Canvas element. So now we need to add a bit of JavaScript. I’m using [Parcel](https://parceljs.org/) here, as it’s quite simple to get started with. I’ll use [Three.js](https://threejs.org/) for the WebGL part.

So let’s add some JavaScript and start with a basic Three.js setup from the official documentation:

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

Let’s style the Canvas element:

```
body { margin: 0; }

canvas { 
	display: block; 
	position: fixed;
	z-index: -1; // put it to background
	left: 0; // position it to fill the whole screen
	top: 0; // position it to fill the whole screen
}
```

Once you have all this in place, you can just run it with \`parcel index.html\`. Now, you wouldn’t see much, its an empty 3D scene so far. Let’s leave the HTML for a moment, and concentrate on the 3D scene for now.

Let’s create a simple [PlaneBufferGeometry](https://threejs.org/docs/#api/en/geometries/PlaneBufferGeometry) object with an image on it. Just like this:

```js
let TEXTURE = new TextureLoader().load('supaAmazingImage.jpg'); 
let mesh = new Mesh(
	new PlaneBufferGeometry(), 
	new MeshBasicMaterial({map: TEXTURE})
)
```

And now we’ll see the following:

![](https://user-images.githubusercontent.com/5164225/90354323-909c8f00-e07b-11ea-9a1c-be5642528f2a.gif)

Obviously we are not there yet, we need that color trail following our mouse. And of course, we need shaders for that. If you are interested in shaders, you’ve probably come across some tutorials on how to displace images, like [displacing on hover](https://tympanus.net/codrops/2018/04/10/webgl-distortion-hover-effects/)?or?[liquid distortion effects](https://tympanus.net/codrops/2017/10/10/liquid-distortion-effects/).

But we have a problem: we can only use shaders on (and inside) that image from the example above. But the effect is not constrained to any image borders, but rather, it’s fluid, covering more area, like the whole screen.

## Postprocessing to the rescue

It turns out that the output of the Three.js renderer is just another image. We can make use of that and apply the shader displacement on that output!

Here is the missing part of the code:

```js
// set up post processing
let composer = new EffectComposer(renderer);
let renderPass = new RenderPass(scene, camera);
// rendering our scene with an image
composer.addPass(renderPass);

// our custom shader pass for the whole screen, to displace previous render
let customPass = new ShaderPass({vertexShader,fragmentShader});
// making sure we are rendering it.
customPass.renderToScreen = true;
composer.addPass(customPass);

// actually render scene with our shader pass
composer.render()
// instead of previous
// renderer.render(scene, camera);
```

There are a bunch of things happening here, but it’s pretty straightforward: you apply your shader to the whole screen.

So let’s do that final shader with the effect:

```js
// get small circle around mouse, with distances to it
float c = circle(uv, mouse, 0.0, 0.2);
// get texture 3 times, each time with a different offset, depending on mouse speed:
float r = texture2D(tDiffuse, uv.xy += (mouseVelocity * .5)).x;
float g = texture2D(tDiffuse, uv.xy += (mouseVelocity * .525)).y;
float b = texture2D(tDiffuse, uv.xy += (mouseVelocity * .55)).z;
// combine it all to final output
color = vec4(r, g, b, 1.);
```

You can see the result of this in the [first demo](https://tympanus.net/Tutorials/webgl-mouseover-effects/step1.html).

## Applying the effect to several images

A screen has its size, and so do images in 3D. So what we need to do now is to calculate some kind of relation of those two.

Just like I did in?[my previous article](https://tympanus.net/codrops/2019/11/05/creative-webgl-image-transitions/), we can make a plane with a width of 1, and fit it exactly to the screen width. So practically, we have `WidthOfPlane=ScreenSize`.

For our Three.js scene, this means that if want an image with a width of 100px on the screen, we will make a Three.js object with width of `100*(WidthOfPlane/ScreenSize)`. That’s it! With this kind of math we can also set some margins and positions easily.

When the page loads, I will loop through all the images, get their dimensions, and add them to my 3D world:

```js
let images = [...document.querySelectorAll('.js-image')];
images.forEach(image=>{
	// and we have the width, height and left, top position of the image now!
	let dimensions = image.getBoundingClientRect();
	// hide original image
	image.style.visibility = hidden;
	// add 3D object to your scene, according to its HTML brother dimensions
	createMesh(dimensions);
})
```

Now it’s quite straightforward to make [this](https://tympanus.net/Tutorials/webgl-mouseover-effects/step1.html) [HTML-3D hybrid](https://tympanus.net/Tutorials/webgl-mouseover-effects/step2.html).

Another thing that I added here is `mouseVelocity`. I used it to change the radius of the effect. The faster the mouse moves, the bigger the radius.

To make it scrollable, we would just need to move the whole scene, the same amount that the screen was scrolled. Using that same formula I mentioned before: `NumberOfPixels*(WidthOfPlane/ScreenSize)`.

Sometimes it’s even easier to make `WidthOfPlane` equal to `ScreenSize`. That way, you end up with exactly the same numbers in both worlds!

## Exploring different effects

With different shaders you can come up with any kind of effect with this approach. So I decided to play a little bit with the parameters.

Instead of separating the image in three color layers, we could simply displace it depending on the distance to the mouse:

```js
vec2 newUV = mix(uv, mouse, circle); 
color = texture2D(tDiffuse,newUV);
```

And for the last effect I used some randomness, to get a pixelated effect around the mouse cursor.

In [this last demo](https://tympanus.net/Tutorials/webgl-mouseover-effects/step3.html) you can switch between effects to see some modifications you can make. With the “zoom” effect, I just use a displacement, but in the last one, I also randomize the pixels, which looks kinda cool to me!

I’d be happy to see your ideas for this animation. What kind of effect would you do with this technique?

[Find this project on Github](https://github.com/akella/webgl-mouseover-effects/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
