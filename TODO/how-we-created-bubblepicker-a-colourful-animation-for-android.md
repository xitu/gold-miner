> * 原文地址：[How We Created BubblePicker – a Colorful Menu Animation for Android](https://yalantis.com/blog/how-we-created-bubblepicker-a-colourful-animation-for-android/)
> * 原文作者：[Irina Galata](https://yalantis.com/blog/how-we-created-bubblepicker-a-colourful-animation-for-android/), [Yuliya Serbenenko](https://yalantis.com/blog/how-we-created-bubblepicker-a-colourful-animation-for-android/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# How We Created BubblePicker – a Colorful Menu Animation for Android #

We’re used to mobile applications supporting various types of interactions such as sliding gestures to select, or to drag and drop. What we tend to forget is that there is a growing trend toward unifying the user experience across platforms. 

In the early days, iOS and Android each had their own unique feel, but recently they have been growing closer together in terms of the way applications are designed and interactions happen. With [bottom navigation](https://material.io/guidelines/components/bottom-navigation.html#) and split screen features now available in Android Nougat, Android has a lot in common with iOS these days.

For designers, this coalescing of design languages means that we can often adjust popular features that were once associated with one platform for apps designed for the other.

Recently, to keep up with the trend of merging design styles across platforms, we worked on an Android animation that is inspired by the popular bubble animation in Apple music. Our task was to develop an interface that was easy enough for novice users but that still felt interesting for more experienced users.

Our vibrant [BubblePicker](https://github.com/igalata/Bubble-Picker) is a great way to make an app more content-focused, original, and fun. Google is rolling out their “Material Design” language across all their products, but nevertheless, we decided to experiment with bold colors and gradients this time around to add more depth and volume to the image. Gradients might be the major visual in the display and might attract the attention of new visitors.

![](http://images.yalantis.com/w736/uploads/ckeditor/pictures/2328/content_1_gradients.jpg)

Our component has a white background with lots of bright colors and graphics against it. 

This high contrast is very helpful for apps rich in content, where users have to choose from a list of options. For example, in our concept we used bubbles to hold the names of potential destinations within a travel app. Bubbles float freely, and when a user taps on one of them, the tapped bubble grows in size.

![](https://yalantis-com-dev-06-09.s3.amazonaws.com/uploads/ckeditor/pictures/2329/content_discover_animation.gif)

Moreover, we provide developers with the opportunity to customize the elements of the screen to make the animation suit any app.  

While working on this animation we had to deal with the following five challenges:

### **1. Choosing the optimal development tools** ###

It became clear to us that rendering such a fast animation on Canvas wouldn’t be efficient enough, so we decided to use OpenGL (Open Graphics Library). OpenGL is a cross-platform application programming interface for 2D and 3D graphics rendering. Fortunately, Android supports some versions of OpenGL.

We needed to make our circles move naturally, just as gas bubbles do in a fizzy drink. There are plenty of physics engines available for Android, but we had specific requirements that made it significantly more difficult to make a choice: the engine needed to be lightweight and easy to embed in the Android library. Most engines are developed for games and require you to adapt the project structure to them. After some research we found JBox2D (a Java port of the Box2D engine written in C++); and since our animation isn’t supposed to be used with a great number of physical bodies (in other words it’s not designed for 200 or more objects) we could get away with using a Java port instead of the original engine.

Also, later in this article we’ll explain our choice of programming language (Kotlin) and talk about the advantages of this new language.To find out more about the difference between Java and Kotlin you can read our review in [our previous article](https://yalantis.com/blog/kotlin-vs-java-syntax/).

### **2. Creating shaders** ###

To begin with, it’s important to understand that the building block in OpenGL is a triangle since it’s the simplest shape that can approximate other shapes. Any shape that you create in OpenGL will consist of one or more triangles. To implement our animation we used two combined triangles for every body, so it looks like a square, where I can draw the circle.

To render a shape you need to write at least two shaders – a vertex shader and a fragment shader. The difference between these two is evident by their names. A vertex shader is executed for each vertex of each triangle, while a fragment shader is executed for every pixel-sized part of the triangles. 

![](http://images.yalantis.com/w736/uploads/ckeditor/pictures/2330/content_3.jpg)

Vertex shaders are used to control transformations of the shape (e.g scaling, position, rotation), while fragment shaders are responsible for the color of the sample. 

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

Shaders are written in GLSL (OpenGL Shading Language) and must be compiled at runtime. If you code in Java, the most convenient way to do that is to write your shaders in a separate file and retrieve them using an input stream. As you can see, Kotlin lets developers create shaders in classes more conveniently by putting any multiline code in triple quotes (""").

In GLSL there are several types of variables: 

- Uniform variables hold the same value for all vertices and fragments

- Attribute variables are different for each vertex

- Varying variables are used to pass data from a vertex shader to a fragment shader, and their values are linearly interpolated for each fragment  

The `u_Move` variable contains x and y values that should be added to the current position of the vertex. Obviously, these values should be equal for all vertices of the shape and the type of this variable is uniform, while the position of the vertices will differ. So the `a_Position` variable is an attribute variable. The` a_UV` variable is needed for two purposes:

1. To find out the distance between the current fragment and the center of the square; depending on this distance, we can change the color of the fragment to draw a circle.

2. To properly place the texture (the photo and the name of the country) in the center of a shape.

![](http://images.yalantis.com/w736/uploads/ckeditor/pictures/2331/content_4.jpg)

The `a_UV` variable contains x and y values that are different for each vertex and which lie between 0 and 1. In the vertex shader, we just pass the value of the `a_UV` variable to the `v_UV` variable, so the `v_UV` variable can be interpolated for every fragment. As a result, the `v_UV` variable for a fragment in the center of a shape will contain the value [0.5, 0.5]. To figure out the distance between the picked fragment and the center we use the distance() method. This method uses two points as a parameter.

### **3. Using smoothstep to draw antialiased circles** ###

Initially my fragment shader looked a bit different:

```
    gl_FragColor = distance < 0.5 ? texture2D(u_Text, v_UV) : u_BgColor;
```    

I changed the fragment color depending on the distance from the center without any antialiasing. And the result was not so impressive — the edges of the circles were notched.

![](http://images.yalantis.com/w736/uploads/ckeditor/pictures/2332/content_6.jpg)

So the smoothstep function was the solution. It smoothly interpolates from 0 to 1 based on distance compared to the start and end point of the transition between the texture and the background. Thus the alpha of the texture on the distance from 0 to 0.49 is 1, on the 0.5 and above it is 0, and between the 0.49 and 0.5 it is interpolated, so the edges of the circles would be antialiased.

![](http://images.yalantis.com/w736/uploads/ckeditor/pictures/2333/content_7.jpg)

### **4. Using textures to display images and text in OpenGL** ###

Every circle in this animation has two states – normal and selected. In the normal state, the texture of a circle contains text and color; in the selected state, the texture also contains an image. So for every circle we needed to create two different textures. 

To create the texture we use a Bitmap instance where we draw all the elements and bind the texture:

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

After doing this, we pass the texture unit to the `u_Text` variable. To get the actual color of a fragment we use the `texture2D()` method, which receives the texture unit and the position of the fragment respective to its vertices. 

### **5. Using JBox2D to make the bubbles move** ###

The animation is pretty simple in terms of the physics. The main object is a World instance, and all the bodies must be created using this world: 

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

As we can see, it’s easy to create the body: we simply need to specify the body type (e.g dynamic, static, kinematic), and its position, radius, shape, density, and fixture. 

Every time the surface is being drawn, it’s necessary to call the `step()` method of the World instance to move all the bodies. After that we can draw all shapes at their new positions. 

The issue we faced is that `JBox2D` doesn’t support orbital gravity. As a result, we couldn’t move the circles to the center of the screen. So we had to implement this feature ourselves:

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

Every time the world moves, we calculate the appropriate force and apply it to each body, making it look like the circles are affected by a gravitation force. 

### **6. Detecting user touch in GlSurfaceView** ###

`GLSurfaceView`, like any other Android view, can react to a user’s touch:

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

The `GLSurfaceView` intercepts all touches and its renderer handles all of them:

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

When a user swipes the screen, we increase the gravity and change its center, so for the user it looks like they are controlling the movements of the bubbles. When the user stops swiping, we return the bubbles to their initial state. 

### **7. Finding a bubble by the coordinates of a user’s touches** ###

When a user clicks on a circle, we receive the touch position on the screen in the `onTouchEvent() `method. But we also need to find the clicked circle in OpenGL’s coordinate system. By default, the center of the `GLSurfaceView` has the position [0, 0], and the x and y values lie between -1 and 1. So we also have to consider the ratio of the screen:

```
    private fun getItem(position: Vec2)= position.let {
            val x = it.x.convert(glView.width, scaleX)
            val y = it.y.convert(glView.height, scaleY)
            circles.find { Math.sqrt(((x - it.x).sqr() + (y - it.y).sqr()).toDouble()) <= it.radius }
    }
```   

When we find the selected circle, we change its radius, density, and texture.

This is the first version of our Bubble Picker, and we surely plan to develop it further. We'd like to give other developers the possibility to customize the physical behavior of bubbles and specify urls to add images to the animation. We also want to add some new features such as the ability to remove bubbles.

Don’t hesitate to send us your experiments, we are curious to see how you use our Bubble Picker. And do let us know if you have any questions or suggestion regarding the animation.

We are going to publish more awesome things soon. Stay tuned!

Check out our [BubblePicker animation on GitHub](https://github.com/igalata/Bubble-Picker) and [BubblePicker on Dribbble](https://dribbble.com/shots/3349372-Bubble-Picker-Open-Source-Component).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
