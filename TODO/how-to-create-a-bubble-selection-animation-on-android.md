> * 原文地址：[How to Create a Bubble Selection Animation on Android](https://medium.com/@igalata13/how-to-create-a-bubble-selection-animation-on-android-627044da4854#.7iwkfupy7)
> * 原文作者：[Irina Galata](https://medium.com/@igalata13?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[skyar2009](https://github.com/skyar2009)
> * 校对者：[zhaochuanxing](https://github.com/zhaochuanxing), [ylq167](https://github.com/ylq167)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*i1B2ZqmzIJDI3eZrKhFhhw.png">

# Android 如何实现气泡选择动画 #

**作者：[Irina Galata](https://github.com/igalata) Android 开发者；[Yulia Serbenenko](https://dribbble.com/yuyonder) UI/UX 设计师**

跨平台用户体验统一正处于增长趋势：早些时候 iOS 和安卓有着不同的体验，但是最近在应用设计以及交互方面变得越来越接近。

从安卓 Nougat 的[底部导航](https://material.io/guidelines/components/bottom-navigation.html#)到分屏特性，两个平台间有了许多相同之处。对设计师而言，我们可以将主流功能设计成两个平台一致（过去需要单独设计）。对开发者而言，这是一个提高、改进开发技巧的好机会。

所以我们决定开发一个安卓气泡选择的组件库 —— 灵感来自于[苹果音乐](http://www.apple.com/lae/apple-music/)的气泡选择。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*CNJ0D-EBz0l_JAyRzqo4Uw.gif">


### **先说设计** ###

我们的气泡选择动画是一个好的范例，它对不同的用户群体有着同样的吸引力。气泡以方便的 UI 元素汇总信息，通俗易懂并且视觉一致。它让界面对新手足够简单的同时还能吸引老司机的兴趣。

这种动画类型对丰富应用的内容由很大帮助，主要使用场景是：用户要从一系列选项中进行选择时的页面。例如，我们使用气泡来选择旅游应用中潜在目的地名字。气泡自由的浮动，当用户点击一个气泡时，选中的气泡会变大。这给用户很深刻的反馈并增强操作的直观感受。

组件使用白色主题，明亮的颜色和图片贯穿始终。此外，我决定试验渐变来增加深度和体积。渐变可能是主要的显示特征，会吸引新用户的注意。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*IUb8sRFq9huEwVB2gUXtOw.png">

气泡选择的渐变

我们允许开发者自定义所有的 UI 元素，所以我们的组件适合任意的应用。


### **再看开发者的挑战** ###

当我决定实现这个动画时，我面临的第一个问题就是使用什么工具开发。我清楚知道绘制如此快速的动画在 Canvas 上绘制的效率是不够的，所以决定使用 OpenGL (Open Graphics Library)。OpenGL 是一个跨平台的 2D 和 3D 图形绘制应用开发接口。幸运地是，Android 支持部分版本的 OpenGL。

我需要圆自然地运动，就像碳酸饮料中的气泡那样。对 Android 来说有许多可用的物理引擎，同时我又有一些特定需要，使得选择变得更加困难。我的需求是：引擎要轻量级并且方便嵌入 Android 库。多数的引擎是为游戏开发的，并且它们需要调整工程结构来适应它们。功夫不负有心人，我最终找到了 JBox2D（C++ 引擎 Box2D 的 Java 版），因为我们的动画不需要支持大量的物理实体（例如 200+），使用非原版的 Java 版引擎已经足够了。

此外，本文后面我会解释我为什么选择 Kotlin 语言开发，以及这样做的好处。需要了解 Java 和 Kotlin 更多不同之处可以阅读我之前的[文章](https://yalantis.com/blog/kotlin-vs-java-syntax/)。

**如何创建着色器？**

首先，我们需要理解 OpenGL 中的基础构件三角形，因为它是和其它形状类似且最简单的形状。所以你绘制的任意图形都是由一个或多个三角形组成。在动画实现中，我使用两个关联的三角形代表一个实体，所以我画圆的地方像一个正方形。

绘制一个形状至少需要两个着色器 —— 顶点着色器和片段着色器。通过名字就可以区分他们的用途。顶点着色器负责绘制每个三角形的顶点，片段着色器负责绘制三角形中每个像素。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*4A0mOfyap101S8jYFuakjA.png">

三角形的片段和顶点

顶点着色器负责控制图形的变化（例如：大小、位置、旋转），片段着色器负责形状的颜色。

```
// language=GLSL
val vertexShader = """
    uniform mat4 u_Matrix;
    attribute vec4 a_Position;
    attribute vec2 a_UV;
    varying vec2 v_UV;
    void main()
    {
        gl_Position = u_Matrix * a_Position;
        v_UV = a_UV;
    }
"""
```


顶点着色器

```
// language=GLSL
val fragmentShader = """
    precision mediump float;
    uniform vec4 u_Background;
    uniform sampler2D u_Texture;
    varying vec2 v_UV;
    void main()
    {
        float distance = distance(vec2(0.5, 0.5), v_UV);
        gl_FragColor = mix(texture2D(u_Texture, v_UV), u_Background, smoothstep(0.49, 0.5, distance));
    }
"""
```


片段着色器

着色器使用 GLSL（OpenGL 着色语言） 编写，需要运行时编译。如果项目使用的是 Java，那么最方便的方式是在另一个文件编写你的着色器，然后使用输入流读取。如上述示例代码所示，Kotlin 可以简单地在类中创建着色器。你可以在 `"""` 中间添加任意的 GLSL 代码。

GLSL 中有许多类型的变量：

- 顶点和片段的 `uniform` 变量的值是相同的
- 每个顶点的 `attribute` 变量是不同的
- `varying` 变量负责从顶点着色器向片段着色器传递数据，它的值由片段线性地插入。

`u_Matrix` 变量包含由圆初始化位置的 `x` 和 `y` 构成的变化矩阵，显然它的值对图形的所有顶点拉说都是相同的，类型为 `uniform`，然而顶点的位置是不同的，所以 `a_Position` 变量是 `attribute` 类型。`a_UV` 变量有两个用途：

1. 确定当前片段和正方形中心位置的距离。根据这个距离，我可以调整片段的颜色而实现画圆。
2. 正确地将 texture（照片和国家的名字）置于图形的中心位置。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*mCT2yR5xj0Pdg18txA4eWg.png">

圆的中心

`a_UV` 包含 `x` 和 `y`，它们的值每个顶点都不同，取值范围是 0 ~ 1。我只给顶点着色器 `a_UV` 和 `v_UV` 两个入参，因此每个片段都可以插入 `v_UV`。并且对于片段中心点的 `v_UV` 值为 [0.5, 0.5]。我使用 `distance()` 方法计算两个点的距离。

**使用** `smoothstep` **绘制平滑的圆**

起初片段着色器看上去不太一样：

`gl_FragColor = distance < 0.5 ? texture2D(u_Text, v_UV) : u_BgColor;`

我根据点到中心的距离调整片段的颜色，没有采取抗锯齿手段。当然结果差强人意 —— 圆的边是凹凸不平的。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3_sJicaMDl7Y36TA2Sg23g.png">

有锯齿的圆

解决方案是 `smoothstep`。它根据到 texture 与背景的变换起始点的距离平滑的从0到1变化。因此距离 0 到 0.49 时 texture 的透明度为 1，大于等于 0.5 时为 0，0.49 和 0.5 之间时平滑变化，如此圆的边就平滑了。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*QK7o0G1iA6vKe_nNYad4FA.png">

无锯齿圆


**OpenGL 中如何使用 texture 显示图像和文本？**

在动画中圆有两种状态 —— 普通和选中。在普通状态下圆的 texture 包含文字和颜色，在选中状态下同时包含图像。因此我需要为每个圆创建两个不同的 texture。

我使用 Bitmap 实例来创建 texture，绘制所有元素。

```
fun bindTextures(textureIds: IntArray, index: Int) {
        texture = bindTexture(textureIds, index * 2, false)
        imageTexture = bindTexture(textureIds, index * 2 + 1, true)
    }

    private fun bindTexture(textureIds: IntArray, index: Int, withImage: Boolean): Int {
        glGenTextures(1, textureIds, index)
        createBitmap(withImage).toTexture(textureIds[index])
        return textureIds[index]
    }

    private fun createBitmap(withImage: Boolean): Bitmap {
        var bitmap = Bitmap.createBitmap(bitmapSize.toInt(), bitmapSize.toInt(), Bitmap.Config.ARGB_4444)
        val bitmapConfig: Bitmap.Config = bitmap.config ?: Bitmap.Config.ARGB_8888
        bitmap = bitmap.copy(bitmapConfig, true)

        val canvas = Canvas(bitmap)

        if (withImage) drawImage(canvas)
        drawBackground(canvas, withImage)
        drawText(canvas)

        return bitmap
    }

    private fun drawBackground(canvas: Canvas, withImage: Boolean) {
        ...
    }

    private fun drawText(canvas: Canvas) {
        ...
    }


    private fun drawImage(canvas: Canvas) {
        ...
    }
```

之后我将 texture 单元赋值给 `u_Text` 变量。我使用 `texture2()` 方法获取片段的真实颜色，`texture2()` 接收 texture 单元和片段顶点的位置两个参数。

**使用 JBox2D 让气泡动起来**

关于动画的物理特性十分的简单。主要的对象是 `World` 实例，所有的实体创建都需要它。

```
class CircleBody(world: World, var position: Vec2, var radius: Float, var increasedRadius: Float) {

    val decreasedRadius: Float = radius
    val increasedDensity = 0.035f
    val decreasedDensity = 0.045f
    var isIncreasing = false
    var isDecreasing = false
    var physicalBody: Body
    var increased = false

    private val shape: CircleShape
        get() = CircleShape().apply {
            m_radius = radius + 0.01f
            m_p.set(Vec2(0f, 0f))
        }

    private val fixture: FixtureDef
        get() = FixtureDef().apply {
            this.shape = this@CircleBody.shape
            density = if (radius > decreasedRadius) decreasedDensity else increasedDensity
        }

    private val bodyDef: BodyDef
        get() = BodyDef().apply {
            type = BodyType.DYNAMIC
            this.position = this@CircleBody.position
        }

    init {
        physicalBody = world.createBody(bodyDef)
        physicalBody.createFixture(fixture)
    }

}
```


如你所见创建实体很简单：需要指定实体的类型（例如：动态、静态、运动学）、位置、半径、形状、密度以及运动。

每次画面绘制，都需要调用 `World` 的 `step()` 方法移动所有的实体。之后你可以在图形的新位置进行绘制。

我遇到的问题是 `World` 的重力只能是一个方向，而不能是一个点。JBox2D 不支持轨道重力。因此将圆移动到屏幕中心是无法实现的，所以我只能自己来实现引力。

```
private val currentGravity: Float
        get() = if (touch) increasedGravity else gravity

private fun move(body: CircleBody) {
        body.physicalBody.apply {
            val direction = gravityCenter.sub(position)
            val distance = direction.length()
            val gravity = if (body.increased) 1.3f * currentGravity else currentGravity
            if (distance > step * 200) {
                applyForce(direction.mul(gravity / distance.sqr()), position)
            }
        }
}
```



引擎

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*UDW4eHZzF9VHQjDUQkbQCQ.png">

引力挑战

每次发生移动时，我计算出力的大小并作用于每个实体，看上去就像圆受引力作用在移动。


**GlSurfaceView 中检测用户触摸事件**

`GLSurfaceView` 和其它的 Android view 一样可以响应用户的点击事件。

```
override fun onTouchEvent(event: MotionEvent): Boolean {
        when (event.action) {
            MotionEvent.ACTION_DOWN -> {
                startX = event.x
                startY = event.y
                previousX = event.x
                previousY = event.y
            }
            MotionEvent.ACTION_UP -> {
                if (isClick(event)) renderer.resize(event.x, event.y)
                renderer.release()
            }
            MotionEvent.ACTION_MOVE -> {
                if (isSwipe(event)) {
                    renderer.swipe(event.x, event.y)
                    previousX = event.x
                    previousY = event.y
                } else {
                    release()
                }
            }
            else -> release()
        }

        return true
}

private fun release() = postDelayed({ renderer.release() }, 1000)

private fun isClick(event: MotionEvent) = Math.abs(event.x - startX) < 20 && Math.abs(event.y - startY) < 20

private fun isSwipe(event: MotionEvent) = Math.abs(event.x - previousX) > 20 && Math.abs(event.y - previousY) > 20

```



`GLSurfaceView` 拦截所有的点击，并用渲染器进行处理。

```
fun swipe(x: Float, y: Float) = Engine.swipe(x.convert(glView.width, scaleX),
            y.convert(glView.height, scaleY))

fun release() = Engine.release()

fun Float.convert(size: Int, scale: Float) = (2f * (this / size.toFloat()) - 1f) / scale

```

渲染器

```
fun swipe(x: Float, y: Float) {
        gravityCenter.set(x * 2, -y * 2)
        touch = true
}

fun release() {
        gravityCenter.setZero()
        touch = false
}
```

引擎

用户点击屏幕时，我将重力中心设为用户点击点，这样看起来就像用户在控制气泡的移动。用户停止移动后我会将气泡恢复到初始位置。

**根据用户点击坐标查找气泡**

当用户点击圆时，我从 `onTouchEvent()` 方法获取屏幕点击点。但是我也需要找到 OpenGL 坐标系中点击的圆。`GLSurfaceView` 的默认中心位置坐标为 [0, 0]，`x` `y` 取值范围为 -1 到 1。所以我需要考虑屏幕的比例。

```
private fun getItem(position: Vec2) = position.let {
        val x = it.x.convert(glView.width, scaleX)
        val y = it.y.convert(glView.height, scaleY)
        circles.find { Math.sqrt(((x - it.x).sqr() + (y - it.y).sqr()).toDouble()) <= it.radius }
}
```

渲染器

当找到选择的圆后，我会修改它的半径和 texture。


### 你可以随机的使用本组件! ###

我们的组件可以让应用更聚焦内容、原始以及充满乐趣。

**以下途径可以获取 Bubble Picker ：** [**GitHub**](https://github.com/igalata/Bubble-Picker) , [**Google Play**](https://play.google.com/store/apps/details?id=com.igalata.bubblepickerdemo) **以及** [**Dribbble**](https://dribbble.com/shots/3349372-Bubble-Picker-Open-Source-Component) **。**

这只是组件的第一个版本，但我们肯定会有后续的迭代。我们将支持自定义气泡的物理特性和通过 url 添加动画的图像。此外，我们还计划添加一些新特性（例如：移除气泡）。

不要犹豫把您的实验发给我们，我们非常想知道您是怎样使用 Bublle Picker 的。如果您有任何问题或者建议，欢迎随时联系我们。

我们将会继续发布一些炫酷的东西。敬请期待！