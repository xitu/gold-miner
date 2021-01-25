> * 原文地址：[Messengers-like ImageView](https://proandroiddev.com/messengers-like-imageview-90e9f1da19f4)
> * 原文作者：[Michael Spitsin](https://medium.com/@programmerr47)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/messengers-like-imageview.md](https://github.com/xitu/gold-miner/blob/master/article/2021/messengers-like-imageview.md)
> * 译者：
> * 校对者：

# Messengers-like ImageView

![](https://cdn-images-1.medium.com/max/2372/1*eUsCLT2MWPgMMc_7ltldOw.png)

In the previous story, I wrote about the [Uploading animation for sending image messages and how we have built it](https://proandroiddev.com/telegram-like-uploading-animation-e284f1404f63). Today I decided to write about the images themselves. How can we show them inside the message history?

Well … `ImageView`. The article is over!

But hold on for a while, I will try to show, that it is not so simple. Well, it is not hard, to be honest, but still, it is not just an `ImageView`, but also some small calculation around to look the size of it fits to what you are showing to the user.

## Measure it

So the first part is to understand what is needed to be done. The core of our solution. We want to draw the image based on the predefined size (width & height) of some picture/gif or any other showable media, but with respect to constraints of the container in which the picture will be showed (we will decrease the size of 1000x1000 picture to fit in 100x100 view container). And with respect to the aspect ratio, please. Well! Not always, but please in most situations.

So that means that our base process can be split into two parts:

1. Defining and providing the desired size with the respect of some absolute minimum. If the image will be too small it will be scaled until its smallest side will be equal to the respective absolute minimum
2. Giving it and the constraints of container view (say `maxSize`) measure the final size with respect to the aspect ratio, if that’s possible (will discuss less possible scenarios later)

#### Definition of Size

Let’s start with the definition of a simple class `Size`. It will contain information about `width` and `height` of the image and also will provide a bunch of useful methods:

```Kotlin
internal class Size(
    var width: Int,
    var height: Int
) {
    val area: Int get() = width * height
    val ratio: Float get() = height.toFloat() / width

    operator fun contains(other: Size) = width >= other.width && height >= other.height

    fun update(new: Size) {
        width = new.width
        height = new.height
    }

    //Don't want to make mutable class as data class
    fun copy(width: Int = this.width, height: Int = this.height) = Size(width, height)
}
```

A couple of clarifications here:

* We made this class mutable because it will be used inside the view and we want to optimize the instance’s creation since it not needed because we work in one thread.
* Instead of custom `copy` we could make `Size` as `data` class, but I didn’t want to mix mutability with `data` classes, that are supposed to be immutable

Now, having the definition of `Size` we can create a class `ImageSizeMeasurer` that will be responsible for size definition, adjustment, and measurement.

#### Setting up the desired size

The first part of the class will be setting up the desired size along with a minimal size. In this method, we will check if the desired size will be less than minimal, and if yes, then we will adjust it respectively:

```Kotlin
internal class ImageSizeMeasurer {
    private var minSize: Size = Size(0, 0)

    private var desiredSize = Size(0, 0)
    val desired get() = desiredSize.copy()

    //= (height/width)
    var fixRatio: Float = 1f
        private set

    //...

    fun setDesiredSize(desired: Size, min: Size) {
        minSize = min.copy()

        desiredSize = desired.copy()
        fixRatio = desired.ratio

        adjustDesiredHeight()
        adjustDesiredWidth()
    }

    private fun adjustDesiredHeight() {
        if (desiredSize.height < minSize.height) {
            desiredSize.height = minSize.height
            desiredSize.width = (minSize.height / fixRatio).toInt()
        }
    }

    private fun adjustDesiredWidth() {
        if (desiredSize.width < minSize.width) {
            desiredSize.width = minSize.width
            desiredSize.height = (minSize.width * fixRatio).toInt()
        }
    }
}
```

We use `copy` method for not allowing the clients to change the fields, that can be potentially shared between them (so we will have no surprises if your field will be changed from somewhere).

The key point here is that after setting the size and ratio, we need to adjust it. There is no harm to call both `adjustDesiredHeight` and `adjustDesiredWidth` without any smart checks, because either first method will increase the smallest height of `desiredSize` to `minSize` (if the height is less than width), or the second method will increase the smallest width of `desiredSize` to `minSize` (if the width is less than height)

#### Measure respective to the constraints

We prepared the desired size with respect to the minimum size. Now it's time to measure the real size with respect to maximum size. The method itself is not hard, we just need to remember that we should make all updates not changing the aspect ratio, except cases when decreasing the image height&width leads to having one of them less than `minSize`.

For example, that’s true for really narrow images.

![](https://cdn-images-1.medium.com/max/3148/1*Oc74IKgtG8h7docIWyka-Q.png)

* either will have a width which is fitted in max constraints but height is too small
* or you will have height fitted in min constraints but width is too big
* or you will have to fit width in max constraints, height in min constraints, and break the aspect ratio.

The last option is the most appropriate one in that case since we can not have image size more than constraints and we don’t want to have a too narrow image, because it is maybe hard to see what is showing and click on it. And we can use `scaleType = imageCrop` which will help here in case of breaking the aspect ratio.

```Kotlin
internal class ImageSizeMeasurer {
    private var minSize: Size = Size(0, 0)

    var desiredSize = Size(0, 0)
        get() = field.copy()
        private set

    //factor (height/width)
    var fixRatio: Float = 1f
        private set

    //...

    fun measure(max: Size, out: Size) {
        when {
            desiredSize in max -> out.update(desiredSize)
            fixRatio < max.ratio -> {
                out.width = max.width
                out.height = max((max.width * desiredSize.height) / desiredSize.width, minSize.height)
            }
            fixRatio > max.ratio -> {
                out.width = max((max.height * desiredSize.width) / desiredSize.height, minSize.width)
                out.height = max.height
            }
            else -> out.update(max)
        }
    }
    
    //... setting desired size here ;)
}
```

Let’s quickly analyze the `measure` method.

* When the desired size fits in max size, then everything okay. After `setDesiredSize` our size will be for sure not smaller than min size. And now we just make sure that it is not bigger than the max size. So we will just return it (the first predicate in `when`)
* If the above predicate is not correct, then either width will be bigger than `max.width` or height will be bigger than `max.height` or both. And if in that case, the aspect ratio of the image will be the same as the aspect ratio of the max size, then we can use just max size as output size, since it will be scaled down the result of the desired size. (the else-block in `when`)
* In another scenario, we need to look only at aspect ratios for comparison. Let me explain. We may have for instance `width` of the desired size be bigger than `width` of max size. But the aspect ratio of the desired size will be bigger than the aspect ratio of max size, too. Means, that when we will scale down the desired size (**so `width` of it will be equal to `width` of max size**) the `height` of the desired size will be still bigger than `height` of max size
* So in case, when the aspect ratio of the desired size is less than the max size’s aspect ratio, we just update `width` to be `max.width` and height will be updated respectively. But if it will be less than `minSize.height` we will break the resulting aspect ratio and assign `minSize.height` to the `out.height`
* Similarly, if the aspect ratio of the desired is more than max size’s aspect ratio, we just update `height` to be `max.height` and width will be updated respectively. But if it will be less than `minSize.width` we will break the resulting aspect ratio and assign `minSize.width` to the `out.width`

## A bit of magic in all calculations makes everything more natural and pretty

Now we prepare everything to be measured in view:

```Kotlin
private val measurer: ImageSizeMeasurer
private val measureResult = Size(0, 0)
private val maxSize = Size(0, 0)

//...

override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
    if (MeasureSpec.getMode(widthMeasureSpec) == MeasureSpec.UNSPECIFIED) {
        setMeasuredDimension(measurer.desired.width, measurer.desired.height)
    } else {
        measure(widthMeasureSpec, heightMeasureSpec)
    }
}

private fun measure(widthSpec: Int, heightSpec: Int) {
    maxSize.width = //you can define max size using both specs or having some predefined
    maxSize.height = //aspect ratio and using only one spec with it. Choice is yours ;)
    measurer.measure(maxSize, measureResult)
    setMeasuredDimension(measureResult.width, measureResult.height)
}
```

Here everything is simple enough. In case we have `unspecified` measure specs, we tell the view’s parent our desired size, which we would like to have in the ideal scenario. In the other case (`AT_MOST` or `EXACTLY`) we need to use the provided `width` and `height` to set up the `maxSize` and pass it into our `measurer`.

Now let’s look at the result:

![](https://cdn-images-1.medium.com/max/2000/1*lTedeH88K2J4Z8snpeSOfw.png)

Everything looks super but it seems like small images are too small. And our wish to make them a little bit bigger than right now. You can say “Just increase the minimum size”. Well, we can do that, but in that case, we will see no difference between the small and the smaller image, since they will use equally minimum size.

Instead of that, we can add a bit of magic

The magic concludes in the increasing small images by some magic constant or formula to be a bit bigger and keep the differences in the size between small and smaller images :)

```Kotlin
fun measure(max: Size, out: Size) {
    val desired = desiredSize.copy()
    magicallyStretchTooSmallSize(max, desired)

    //... 
}

private fun magicallyStretchTooSmallSize(max: ChatImageView.Size, desired: ChatImageView.Size) {
    if (desired in max) {
        //if image is smaller than max bounds we additionally stretch this image little bit
        //to those bounds. This is done intentionally because if you will send small image,
        //it will not be too small. So it just some adjusting magic to look image more pretty ;)
        val adjustedArea = desired.area + (max.area - desired.area) / 3f
        val outW = sqrt(adjustedArea / fixRatio)
        desired.height = (outW * fixRatio).toInt()
        desired.width = outW.toInt()
    }
}
```

The algorithm is short: increase the desired area by 1/3 of the difference between max and desired areas and then knowing the new desired area and ratio, find the new width and height.

Here is a comparison result.

![**Left:** without magic, **Right:** with magic](https://cdn-images-1.medium.com/max/2996/1*-pTHSTbjjPZlveMdtuTaeQ.gif)

I like that in the new result we have bigger pictures, so it is more convenient to observe them, but at the same time you still have the understanding that some pictures are bigger (more detailed) and some are smaller.

## What if I want to build sizes, knowing the ratio only

As an additional point let’s discuss the further improvement. Sometimes, you have not the final specs of the image (it’s final height and width), but specs for the thumbnails. So you can not use them as the desired size, since those specs are much smaller, but you can calculate the ratio which will be more or less the same, and then out `ImageSizeMeasurer` will calculate the final size by having the fixed ratio only and trying to fit the max constraints as much as possible.

So first, let’s add a new property to our `Size` class:

```
val isSpecified: Boolean get() = width > 0 && height > 0
```

Next, we need to add a possibility to set the desired ratio instead of the desired size:

```
fun setDesiredRatio(ratio: Float, min: Size) {
    minSize = min.copy()
    desiredSize = Size(0, 0)
    fixRatio = ratio
}
```

And then we will update the `measure` by adding an additional adjustment to the desired size:

```Kotlin
fun measure(max: ChatImageView.Size, out: ChatImageView.Size) {
    val desired = desiredSize.copy()
    fixUnspecifiedDesiredSize(max, desired)
    magicallyStretchTooSmallSize(max, desired)
    
    //...
}

//if the desired sizes not specified but factor is, then first stretch the image maximally
private fun fixUnspecifiedDesiredSize(max: ChatImageView.Size, desired: ChatImageView.Size) {
    if (!desired.isSpecified) {
        if (fixRatio > max.ratio) {
            desired.width = max.width
            desired.height = (max.width * fixRatio).toInt()
        } else {
            desired.width = (max.height / fixRatio).toInt()
            desired.height = max.height
        }
    }
}
```

And finally, let’s update `onMeasure`

```Kotlin
override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
    if (measurer.desired.isSpecified) {
        if (MeasureSpec.getMode(widthMeasureSpec) == MeasureSpec.UNSPECIFIED) {
            setMeasuredDimension(measurer.desired.width, measurer.desired.height)
        } else {
            measure(widthMeasureSpec)
        }
    } else if (measurer.fixRatio > 0) {
        if (MeasureSpec.getMode(widthMeasureSpec) == MeasureSpec.UNSPECIFIED) {
            super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        } else {
            measure(widthMeasureSpec)
        }
    } else {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
    }
}

private fun measure(widthSpec: Int) {
    maxSize.width = //you can define max size using both specs or having some predefined
    maxSize.height = //aspect ratio and using only one spec with it. Choice is yours ;)
    measurer.measure(maxSize, measureResult)
    setMeasuredDimension(measureResult.width, measureResult.height)
}
```

## Let’s talk about the view

So far so good. We have the special measurer that can rule the worlds and make new universes! We even have a rough understanding of how it will be integrated with the view. But we still got no view.

Let’s first describe, what we want. Actually, it is not hard to specify `minWidth` and `minHeight`. Those attributes are part of xml. Well, `maxWidth` and `maxHeight`, too. But I don’t want to hardcode any specific size here. Instead, I want to rely more on the device screen. Means, that would be nice to specify those max constraints by let’s say percentage. Since we have `ConstraintLayout` it should be not hard to specify max width like that (say **70%** of the screen width). But what about height?

I will quickly remind you that you can specify constraints whatever you like, I’m just giving my small thoughts to have a starting point. I decided to have a height depending on width, by some factor. So, let’s say if we will have `factor = 1`, it will be just a square. Just specify `width` and the height will be calculated automatically.

You will see, that implementation is very simple, but at the same time you have a screen size dependency, rather than having a lot of `dimens.xml` depending on different factors of devices, though the latter solution will be more **“androidish”**:

```Kotlin
open class FixRatioImageView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : AppCompatImageView(context, attrs, defStyleAttr) {
    var factor = DEFAULT_FACTOR
        set(value) {
            if (field != value) {
                field = value
                requestLayout()
            }
        }

    init {
        attrs?.parseAttrs(context, R.styleable.FixRatioImageView) {
            factor = getFloat(R.styleable.FixRatioImageView_factor, DEFAULT_FACTOR)
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        val width = View.getDefaultSize(suggestedMinimumWidth, widthMeasureSpec)
        setMeasuredDimension(width, ceil(width * factor).toInt())
    }

    companion object {
        private const val DEFAULT_FACTOR = .6f
    }
}
```

## Gather all up.

Now we can look at the final class:

```Kotlin
class ChatImageView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : FixRatioImageView(context, attrs, defStyleAttr) {

    private val measurer = ImageSizeMeasurer()
    private val measureResult = Size(0, 0)
    private val maxSize = Size(0, 0)

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        if (measurer.desired.isSpecified) {
            if (MeasureSpec.getMode(widthMeasureSpec) == MeasureSpec.UNSPECIFIED) {
                setMeasuredDimension(measurer.desired.width, measurer.desired.height)
            } else {
                measure(widthMeasureSpec)
            }
        } else if (measurer.fixRatio > 0) {
            if (MeasureSpec.getMode(widthMeasureSpec) == MeasureSpec.UNSPECIFIED) {
                super.onMeasure(widthMeasureSpec, heightMeasureSpec)
            } else {
                measure(widthMeasureSpec)
            }
        } else {
            super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        }
    }

    private fun measure(widthSpec: Int) {
        maxSize.width = MeasureSpec.getSize(widthSpec)
        maxSize.height = (maxSize.width * factor).toInt()
        measurer.measure(maxSize, measureResult)
        setMeasuredDimension(measureResult.width, measureResult.height)
    }

    fun setDesiredSize(width: Int, height: Int) {
        measurer.setDesiredSize(Size(width, height), Size(minimumWidth, minimumHeight))
        invalidate()
        requestLayout()
    }

    fun setDesiredRatio(ratio: Float) {
        measurer.setDesiredRatio(ratio, Size(minimumWidth, minimumHeight))
        invalidate()
        requestLayout()
    }

    internal class ImageSizeMeasurer {
        private var minSize: Size = Size(0, 0)

        private var desiredSize = Size(0, 0)
        val desired get() = desiredSize.copy()

        //factor (height/width)
        var fixRatio: Float = 1f
            private set

        init { reset() }

        //We relying that the client will use `MATCH_PARENT` for width
        //Using point as out size, to be able to not create new objects
        fun measure(max: Size, out: Size) {
            val desired = desiredSize.copy()
            fixUnspecifiedDesiredSize(max, desired)
            magicallyStretchTooSmallSize(max, desired)

            when {
                desired in max -> out.update(desired)
                fixRatio < max.ratio -> {
                    out.width = max.width
                    out.height = max((max.width * desired.height) / desired.width, minSize.height)
                }
                fixRatio > max.ratio -> {
                    out.width = max((max.height * desired.width) / desired.height, minSize.width)
                    out.height = max.height
                }
                else -> out.update(max)
            }
        }

        //if the desired sizes not specified but factor is, then first stretch the image maximally
        private fun fixUnspecifiedDesiredSize(max: Size, desired: Size) {
            if (!desired.isSpecified) {
                if (fixRatio > max.ratio) {
                    desired.width = max.width
                    desired.height = (max.width * fixRatio).toInt()
                } else {
                    desired.width = (max.height / fixRatio).toInt()
                    desired.height = max.height
                }
            }
        }

        @Suppress("MagicNumber")
        private fun magicallyStretchTooSmallSize(max: Size, desired: Size) {
            if (desired in max) {
                //if image is smaller than max bounds we additionally stretch this image little bit
                //to those bounds. This is done intentionally because if you will send small image,
                //it will not be too small. So it just some adjusting magic to look image more pretty ;)
                val adjustedArea = desired.area + (max.area - desired.area) / 3f
                val outW = sqrt(adjustedArea / fixRatio)
                desired.height = (outW * fixRatio).toInt()
                desired.width = outW.toInt()
            }
        }

        fun setDesiredRatio(ratio: Float, min: Size) {
            reset()
            minSize = min.copy()
            fixRatio = ratio
        }

        fun setDesiredSize(desired: Size, min: Size) {
            minSize = min.copy()

            if (!desired.isSpecified) {
                reset()
            } else {
                desiredSize = desired.copy()
                fixRatio = desired.ratio

                adjustDesiredHeight()
                adjustDesiredWidth()
            }
        }

        private fun adjustDesiredHeight() {
            if (desiredSize.height < minSize.height) {
                desiredSize.height = minSize.height
                desiredSize.width = (minSize.height / fixRatio).toInt()
            }
        }

        private fun adjustDesiredWidth() {
            if (desiredSize.width < minSize.width) {
                desiredSize.width = minSize.width
                desiredSize.height = (minSize.width * fixRatio).toInt()
            }
        }

        private fun reset() {
            desiredSize = Size(0, 0)
            fixRatio = 1f
        }
    }

    internal class Size(
        var width: Int,
        var height: Int
    ) {
        val area: Int get() = width * height
        val ratio: Float get() = height.toFloat() / width
        val isSpecified: Boolean get() = width > 0 && height > 0

        operator fun contains(other: Size) = width >= other.width && height >= other.height

        fun update(new: Size) {
            width = new.width
            height = new.height
        }

        //Don't want to make mutable class as data class
        fun copy(width: Int = this.width, height: Int = this.height) = Size(width, height)
    }
}
```

And the result of our work:

![](https://cdn-images-1.medium.com/max/2000/1*gSYcSTxF0jS3NbpbAR0MXQ.gif)

## Afterwords

If you liked that article, don’t forget to support me by clapping and if you have any questions, comment me and let’s have a discussion. Happy coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
