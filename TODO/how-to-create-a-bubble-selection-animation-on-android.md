> * 原文地址：[How to Create a Bubble Selection Animation on Android](https://medium.com/@igalata13/how-to-create-a-bubble-selection-animation-on-android-627044da4854#.7iwkfupy7)
> * 原文作者：[Irina Galata](https://medium.com/@igalata13?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*i1B2ZqmzIJDI3eZrKhFhhw.png">

# How to Create a Bubble Selection Animation on Android #

*Authors:* [*Irina Galata*](https://github.com/igalata) *, Android Developer;* [*Yulia Serbenenko*](https://dribbble.com/yuyonder) *, UI/UX designer.*

There is a growing trend for unifying user experience across platforms: in early days iOS and Android had their own unique feel, but recently they have been growing closer together in the way applications are designed and interactions happen.

From [bottom navigation](https://material.io/guidelines/components/bottom-navigation.html#)  to split screen feature available in Nougat Android, there is a lot of common between two platforms these days. For designers it means that often we can adjust popular features that were once associated with one platform to apps designed for another one. As for developers, it is a great chance to improve and refine their technical skills.

So we decided to create the component with the bubble based interface for Android, drawing our inspiration from selection bubbles in [Apple music](http://www.apple.com/lae/apple-music/) .

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*CNJ0D-EBz0l_JAyRzqo4Uw.gif">


### ***Put design first*** ###

Our Bubble Picker is an example of the animation that is equally appealing to different groups of users. Bubbles summarize information into convenient UI elements that are easy to understand and also visually consistent. It makes the interface simple enough for novice users and still feels interesting for experienced ones.

This type of animation is very helpful for apps rich in content, where users have to make a choice from a list of options. For example, in our component we used bubbles to hold names of potential destinations for a travel app. Bubbles float freely, and when a user taps on one of them, the chosen bubble grows in size. It gives users a meaningful feedback on their actions and enhances the sense of direct manipulation.

The component is pretty with a white theme, lots of bright colors and photographs throughout. Moreover, I decided to experiment with gradients in order to add more depth and volume. Gradients might be the major visual in the display and might attract the attention of new visitors.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*IUb8sRFq9huEwVB2gUXtOw.png">

Bubble Picker’s gradients

We provide developers with an opportunity to customize all UI elements, therefore our component will suit any app.


### **Review developer’s challenges** ###

The first issue I’ve faced when I decided to implement this animation was to choose tools for the development. It was clear for me that rendering of such a fast animation on Canvas wouldn’t be efficient enough, so decided to use OpenGL (Open Graphics Library). It’s a cross-platform application programming interface for 2D and 3D graphics rendering. Fortunately, Android supports some versions of the OpenGL.

I needed to make circles move in a natural way, just like gas bubbles do in a glass of fizzy drink. There are plenty of physics engines available for Android, but I had some requirements for them and this fact made it significantly more difficult to make a choice. My requirements were the following: the engine should be lightweight and easily embeddable in the Android library. Most engines are developed for games and they required adapting the project structure to them. After some research I found JBox2D (Java port of the Box2D engine written in C++), and since our animation isn’t supposed to be used with a great number of physical bodies (e.g 200 or more), it was enough to use a Java port but not the original engine.

Also further in this article I’ll explain my choice of the programming language (Kotlin) and what advantages it has in my opinion. To find out more about the difference between Java and Kotlin review my previous [article](https://yalantis.com/blog/kotlin-vs-java-syntax/) 

**How to create shaders?**

Firstly, it’s important to understand that the building block in OpenGL is a triangle, since it’s the simplest shape that can approximate other shapes. So any shape that you create will consist of 1 or more triangles. To implement our animation I used two combined triangles for every body, so it looks like a square, where I can draw the circle.

To render created shape you need to write at least two shaders — vertex shader and fragment shader. Their difference is described by their names. Vertex shader will be executed for each vertex of each triangle, and fragment shader will be executed for every pixel-sized part of the triangles.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*4A0mOfyap101S8jYFuakjA.png">

Fragments and vertices of the triangle
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
"""
```


Vertex shader

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


Fragment shader
Shaders are written in GLSL (OpenGL Shading Language) and are required to be compiled at runtime. If you code in Java the most convenient way is to write your shaders in separate file and retrieve them using input stream. As you see Kotlin lets developers create shaders in classes in easier way. You can put any multiline code in triple quotes `"""`.

In GLSL there are several types of variables:

- value of the `uniform` variableisthe same for all vertices and fragments
- `attribute` variable is different for each vertex
- the `varying` variable is used to pass data from vertex shader to fragment shader and its value will be linearly interpolated for each fragment

`u_Matrix` variable contains the translation matrix with `x` and `y`, which should be added to the initial position of the circle, and obviously its value should be equal for all vertices of the shape and the type of this variable is `uniform`, while the position of the vertices will differ, so `a_Position` variable is `attribute` *.* `a_UV`variable is needed for two purposes:

1. To find out the distance between current fragment and the center of the square. Depending on this distance I can change the color of the fragment to draw a circle.
2. To properly place the texture(the photo and the name of the country) in the center of a shape.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*mCT2yR5xj0Pdg18txA4eWg.png">

The center of the circle

`a_UV` contains `x` and `y` values which are different for each vertex and lie between 0 and 1. In the vertex shader I just pass the value of the `a_UV` to `v_UV` variable, so the second one could be interpolated for every fragment. And as a result the `v_UV` variable of a fragment in the center of a shape will contain the [0.5, 0.5] value. To find out the distance I used `distance()` method, which receives two points.

**Using** `smoothstep` **to draw antialiased circles**

Initially my fragment shader looked a bit different:

`gl_FragColor = distance < 0.5 ? texture2D(u_Text, v_UV) : u_BgColor;`

I changed the fragment color depending on the distance from the center without any antialiasing. And the result was not so impressive — the edges of the circles were notched.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3_sJicaMDl7Y36TA2Sg23g.png">

Not antialiased circles
So the `smoothstep` function was the solution. It smoothly interpolates from 0 to 1 based on `distance` compared to the start and end point of the transition between the texture and the background. Thus the alpha of the texture on the distance from 0 to 0.49 is 1, on the 0.5 and above it is 0, and between the 0.49 and 0.5 it is interpolated, so the edges of the circles would be antialiased.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*QK7o0G1iA6vKe_nNYad4FA.png">

Antialiased circles


**How to use textures to display the images and text in OpenGL?**

Every circle in this animation can have two states — normal and selected. In the normal state the texture of a circle contains text and color, in the selected state it also contains an image. So for every circle I needed to create two different textures.

To create the texture I use a Bitmap instance where I draw all the elements and bind the texture.

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

And after that I pass the texture unit to the `u_Text` variable. And to get the actual color of a fragment I use `texture2D()` method which receives the texture unit and the position of the fragment respective to its vertices.

**Using JBox2D to make the bubbles move**

The animation is pretty simple when talking about the physics. The main object is a `World` instance. All the bodies must be created using the world.

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


As you see it’s easy to create the body: you need to specify the body type (e.g dynamic, static, kinematic), its position, radius, shape, density and fixture.

Every time the surface is drawing, it’s necessary to call `step()` method of the `World` instance to move all the bodies. After that you can draw all shapes at their new positions.

The issue I’ve faced is that world can have a gravity only as a direction, but not a point. JBox2D doesn’t support orbital gravity. As a result I couldn’t move the circles to the center of the screen. So I had to implement gravitation by myself.

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



Engine

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*UDW4eHZzF9VHQjDUQkbQCQ.png">

Gravitation challenge

So every time the world moves I calculate the appropriate force and apply it to each body and it looks like the circles are affected by gravitation.


**Detecting user’s touches in GlSurfaceView**

`GLSurfaceView` like any other Android view can react to user’s touch.

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



So the `GLSurfaceView` intercepts all the touches, and its renderer handles all of them.

```
fun swipe(x: Float, y: Float) = Engine.swipe(x.convert(glView.width, scaleX),
            y.convert(glView.height, scaleY))

fun release() = Engine.release()

fun Float.convert(size: Int, scale: Float) = (2f * (this / size.toFloat()) - 1f) / scale

```

Renderer

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

Engine

When a user swipes the screen, I change the gravity center to the position of the user’s touch, so for the users it looks like they control the movements of the bubbles. And when users stop swiping I return the bubbles to their initial state.

**Finding the bubble by the coordinates of the user’s touches**

When user clicks on the circle, I receive the touch position on the screen in `onTouchEvent()` method. But I also need to find the clicked circle in the coordinate system of the OpenGL. By default the center of the `GLSurfaceView` has [0, 0] position, and the `x` and `y` values lie between -1 and 1. So I also have to consider the ratio of the screen sides.

```
private fun getItem(position: Vec2) = position.let {
        val x = it.x.convert(glView.width, scaleX)
        val y = it.y.convert(glView.height, scaleY)
        circles.find { Math.sqrt(((x - it.x).sqr() + (y - it.y).sqr()).toDouble()) <= it.radius }
}
```

Renderer

And when I find the selected circle, I change its radius and texture.


### Feel free to use it in your projects! ###

Our vibrant component is a great way to make an app more content-focused, original and fun.

**Check Bubble Picker on** [**GitHub**](https://github.com/igalata/Bubble-Picker) , [**Google Play**](https://play.google.com/store/apps/details?id=com.igalata.bubblepickerdemo) **and** [**Dribbble**](https://dribbble.com/shots/3349372-Bubble-Picker-Open-Source-Component) **.**

It is just the first version of the component, but we surely plan to develop it further. We would like to give developers a possibility to customize physical behavior of the bubbles and specify url to add the image to the animation. In addition, we plan to add some new features (e.g removing of bubbles).

Don’t hesitate to send us your experiments, we are curious to see how you use our Bubble Picker. And do let us know if you have any questions or suggestion regarding the animation.

We are going to publish more awesome things soon. Stay tuned!
