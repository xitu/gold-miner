> * 原文地址：[How We Created BubblePicker – a Colorful Menu Animation for Android](https://yalantis.com/blog/how-we-created-bubblepicker-a-colourful-animation-for-android/)
> * 原文作者：[Irina Galata](https://yalantis.com/blog/how-we-created-bubblepicker-a-colourful-animation-for-android/), [Yuliya Serbenenko](https://yalantis.com/blog/how-we-created-bubblepicker-a-colourful-animation-for-android/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[hackerkevin](https://github.com/hackerkevin)
> * 校对者：[luoqiuyu](https://github.com/luoqiuyu) [phxnirvana](https://github.com/phxnirvana)

# 如何创建 BubblePicker – Android 多彩菜单动画 #

我们已经习惯了移动应用丰富的交互方式，如滑动手势去选择、拖拽。但是我们没有察觉到，统一用户的跨平台体验是一个正在发生的趋势。

早期时候，iOS 和 Android 都有其独特的体验，但是在近期，这两个平台上的应用体验和交互在逐渐的靠拢。[底部导航](https://material.io/guidelines/components/bottom-navigation.html#)和分屏的特性已经成为Android Nougat版本的特性，Android 和 iOS 已经有了很多相同的地方了。

对于设计者而言，设计语言的融合意味着在一个平台上流行的特性可以适配到另一个平台。

最近，为了跟上跨平台风格的步伐，我们受 Apple music 上气泡动画的启发，用 Android 动画实现了一份。我们设计了一个接口，使得初学者也可以方便的使用，而且也让有经验的开发者觉得有趣。

使用 [BubblePicker](https://github.com/igalata/Bubble-Picker) 能让一个应用更加的聚焦内容、原汁原味和有趣。尽管 Google 已经对它所有的产品推出了材料设计语言，但是我们依然决定在此时尝试大胆的颜色和渐变的效果，使得图像增加更多的深度和体积。渐变可能是界面显示最主要的视觉效果，也可能会吸引到更多的人使用。

![](http://images.yalantis.com/w736/uploads/ckeditor/pictures/2328/content_1_gradients.jpg)

我们的组件是白色背景，上面包含了很多明亮的颜色和图形。

这种高反差对丰富应用的内容很有帮助，在这里用户不得不从一系列选项列表中做出选择。比如，在我们的概念中，我们在旅行应用中使用气泡来持有潜在的目的地名称。气泡在自由的漂浮，当用户点击其中一个时，那个气泡就会变大。

![](https://yalantis-com-dev-06-09.s3.amazonaws.com/uploads/ckeditor/pictures/2329/content_discover_animation.gif)

此外，开发者可以通过自定义屏幕中的元素使得动画适配任何应用。

当我们在制作这个动画的同时，我们要面对下面五个挑战：

### **1. 选择最佳开发工具** ###

很明显，在 Canvas 上渲染这样一个快速的动画效果不够高效，所以我们决定使用OpenGL (Open Graphics Library)。 OpenGL 是一个提供 2D 或 3D 图形渲染的、跨平台的应用程序接口。幸运的是，Android 支持一些 OpenGL 的版本。

我们需要让圆更加的自然，就像是汽水中的气泡。有很多物理引擎可用于 Android，但我们的特殊需求使得做出选择格外困难：这个引擎必须轻量而且方便嵌入 Android 库中。大多数引擎都是为游戏开发的，你必须使项目结构适应它们。经过一些研究，我们发现了 JBox2D (一个使用 C++ 开发的、 Java 端口的 Box2D 引擎)；因为我们的动画并不支持很多数量的 body（换句话说，它不是为了200个或更多的对象设计的），我们可以使用 Java 端口而不是原生引擎。

另外，在本文的后面我们会解释为何选择了 Kotlin 语言编写，并且谈到这种新语言的优点。想要了解 Java 与 Kotlin 更多的区别，请访问[之前的文章](https://yalantis.com/blog/kotlin-vs-java-syntax/)。

### **2. 创建着色器** ###

在开始的时候，我们需要先理解 OpenGL 中的构建块是三角形，因为三角形是能够模拟成其他形状中最简单的形状。你在 OpenGL 中创建出的任何形状，都包含了一个或多个三角形。为了实现动画，我们为每个 body 使用了两个组合三角形，所以看起来像个正方形，我们可以在里面画圆。

渲染一个形状至少需要写两个着色器 - 一个顶点着色器和一个片段着色器。它们的名称已经体现了各自的不同。对每个三角形的每个顶点执行一个顶点着色器，而对三角形中的每个像素大小的部分则执行片段着色器。

![](http://images.yalantis.com/w736/uploads/ckeditor/pictures/2330/content_3.jpg)

顶点着色器通常被用于控制形状（如缩放、位置、旋转），而片段着色器负责控制其颜色。

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
    """// language=GLSL
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

着色器是使用 GLSL (OpenGL Shading Language) 编写的，必须在运行时编译。如果你用的是 Java 代码，最方便的方法是将你的着色器写到一个单独的文件中，然后使用输入流取回。如你所见，Kotlin 开发人员通过将任何多行代码放到三重引号（"""）中，更方便的在类中创建着色器。

GLSL 有几种不同类型的变量：

- 统一变量对所有顶点和片段持有相同的值

- 属性变量对每个顶点都不同

- 变化中变量将数据从顶点着色器传递到片段着色器，对于每个片段都是用线性内插法赋值

u_Move 变量包含了 x 和 y 两个值，用于表示顶点当前位置的移动增量。很明显，他们的值应该与一个形状中的所有顶点的该变量的值相同，类型也应该是相同的，虽然这些顶点各自的位置不同。a_Position 变量是属性变量，a_UV 变量用于以下两个目的：

1. 得到当前片段与正方形中心的距离；根据这个距离，我们能够改变片段的颜色来画圆。

2. 将纹理（照片和国家名称）放在图形的中心。

![](http://images.yalantis.com/w736/uploads/ckeditor/pictures/2331/content_4.jpg)

a_UV 变量包含了 x 和 y 两个变量，这两个值对每个顶点都不同但都在 0 和 1 之间。在顶点着色器中，我们将值从 a_UV 变量传递给 v_UV 变量，这样每个片段都会被插入 v_UV 变量。结果，形状中心片段的 v_UV 变量的值就是 [0.5, 0.5]。我们使用 distance() 方法来计算一个选中的片段到中心的距离。这个方法使用两点作为参数。

### **3. 使用 smoothstep 方法画抗锯齿圆** ###

起初，我的片段着色器看起来有些不一样：

```
    gl_FragColor = distance < 0.5 ? texture2D(u_Text, v_UV) : u_BgColor;
```    

我根据到中心的距离改变了片段颜色，没有使用抗锯齿。结果并不理想，圆的边缘被切开了。

![](http://images.yalantis.com/w736/uploads/ckeditor/pictures/2332/content_6.jpg)

smoothstep 方法可以解决这个问题。在纹理和背景间平滑插入由起点和终点决定的值，取值范围在 0 到 1 之间。。纹理的透明度在 0 到 0.49 之间值设为1，0.5 以上的为0，并且0.49 到 0.5 之间会被插入，所以圆的边缘会被抗锯齿。

![](http://images.yalantis.com/w736/uploads/ckeditor/pictures/2333/content_7.jpg)

### **4. 使用纹理在 OpenGL 中显示图片和文本** ###

动画中的每个圆都有两个状态 - 正常状态和选中状态。在正常状态中，圆中的纹理包含了文字和颜色；在选中的状态，纹理则还会包含了一个图片。所以，对每个圆我们都应该创建两个不同的纹理。

为了创建纹理，我们使用一个 Bitmap 的实例，在实例里我们画出所有的元素并绑定纹理：

```
    fun bindTextures(textureIds: IntArray, index: Int){
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
    
        private fun drawBackground(canvas: Canvas, withImage: Boolean){
            ...
        }
    
        private fun drawText(canvas: Canvas){
            ...
        }
    
        private fun drawImage(canvas: Canvas){
            ...
        }
    
```

做完这些之后，我们将这个纹理传递给 u_Text 变量。我们通过 texture2D() 方法来获取一个片段的真实颜色，我们还能获得纹理单元和片段相对于其顶点的位置。

### **5. 使用 JBox2D 让气泡移动** ###

从物理的角度，这个动画非常简单。主对象是一个 World 实例，所有的 body 都需要在这个 World 里创建：

```
    classCircleBody(world: World, varposition: Vec2, varradius: Float, varincreasedRadius: Float) {
    
        val decreasedRadius: Float = radius
        val increasedDensity = 0.035f
        val decreasedDensity = 0.045f
        var isIncreasing = false
        var isDecreasing = false
        var physicalBody: Body
        var increased = falseprivate val shape: CircleShape
            get()= CircleShape().apply {
                m_radius = radius + 0.01f
                m_p.set(Vec2(0f, 0f))
            }
    
        private val fixture: FixtureDef
            get()= FixtureDef().apply {
                this.shape = this@CircleBody.shape
                density = if (radius > decreasedRadius) decreasedDensity else increasedDensity
            }
    
        private val bodyDef: BodyDef
            get()= BodyDef().apply {
                type = BodyType.DYNAMIC
                this.position = this@CircleBody.position
            }
    
        init {
            physicalBody = world.createBody(bodyDef)
            physicalBody.createFixture(fixture)
        }
    
    }
```    

正如我们所见，body 容易创建：我们需要简单的制定 body 类型（如：dynamic, static, kinematic），position，radius，shape，density 和 fixture 属性。

当这个面被画出来，我们需要调用 World 的 step() 方法来移动所有的 body。然后，我们就可以在新的位置画出所有的形状了。

我们遇到一个问题，JBox2D 不能支持轨道重力。这样，我们就不能将圆移动到屏幕中间了。所以我们只能自己实现这个特性：

```
    private val currentGravity: Float
            get()= if (touch) increasedGravity else gravity
    
    private fun move(body: CircleBody){
            body.physicalBody.apply {
                val direction = gravityCenter.sub(position)
                val distance = direction.length()
                val gravity = if (body.increased) 1.3f * currentGravity else currentGravity
                if(distance > step * 200){
                    applyForce(direction.mul(gravity / distance.sqr()), position)
                }
            }
    }
```    

![](http://images.yalantis.com/w736/uploads/ckeditor/pictures/2334/content_8.jpg)

每当 World 移动时，我们计算一个合适的力度作用于每个 body，使得看起来像是受到了重力的影响。

### **6. 在 GlSurfaceView 中检测用户触摸事件** ###

GLSurfaceView 和其他的 Android view 一样可以对用户触碰反应：

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
    
            returntrue
    }
    
    private fun release()= postDelayed({ renderer.release() }, 1000)
    
    private fun isClick(event: MotionEvent)= Math.abs(event.x - startX) < 20 && Math.abs(event.y - startY) < 20private fun isSwipe(event: MotionEvent)= Math.abs(event.x - previousX) > 20 && Math.abs(event.y - previousY) > 20
```

GLSurfaceView 拦截所有的触摸事件，渲染器处理它们：

```
    //Rendererfun swipe(x: Float, y: Float)= Engine.swipe(x.convert(glView.width, scaleX),
                y.convert(glView.height, scaleY))
    
    fun release()= Engine.release()
    
    fun Float.convert(size: Int, scale: Float) = (2f * (this / size.toFloat()) - 1f) / scale
    
    //Enginefun swipe(x: Float, y: Float){
            gravityCenter.set(x * 2, -y * 2)
            touch = true
    }
    
    fun release(){
            gravityCenter.setZero()
            touch = false
    }
```    

当用户滑动屏幕，我们增加重力并改变中心，在用户看来就像是控制了气泡的移动。当用户停止了滑动，我们将气泡恢复到初始状态。

### **7. 通过用户触碰的坐标找到气泡** ###

当用户点击了一个圆，我们通过 onTouchEvent() 方法接收到了触碰点在屏幕上的坐标。但是，我们还需要找到被点击的圆在 OpenGL 坐标体系中的位置。默认情况下，GLSerfaceView 中心的坐标是 [0, 0]，x 和 y 变量在 -1 到 1 之间。所以，我们还需要考虑到屏幕的比例：

```
    private fun getItem(position: Vec2)= position.let {
            val x = it.x.convert(glView.width, scaleX)
            val y = it.y.convert(glView.height, scaleY)
            circles.find { Math.sqrt(((x - it.x).sqr() + (y - it.y).sqr()).toDouble()) <= it.radius }
    }
```   

当我们找到了选中的圆就改变它的半径、密度和纹理。

这是我们第一版 Bubble Picker，而且还将进一步完善。其他开发者可以自定义泡泡的物理行为，并指定 url 将图片添加到动画中。而且我们还将添加一些新的特性，比如移除泡泡。

请将你们的实验发给我们，让我们看到你是如何使用 Bubble Picker 的。如果对动画有任何问题或建议，请告诉我们。

我们会尽快发布更多干货。 敬请关注！

戳这里进一步查看 [BubblePicker animation on GitHub](https://github.com/igalata/Bubble-Picker) 和 [BubblePicker on Dribbble](https://dribbble.com/shots/3349372-Bubble-Picker-Open-Source-Component)。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
