> * 原文地址：[Messengers-like ImageView](https://proandroiddev.com/messengers-like-imageview-90e9f1da19f4)
> * 原文作者：[Michael Spitsin](https://medium.com/@programmerr47)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/messengers-like-imageview.md](https://github.com/xitu/gold-miner/blob/master/article/2021/messengers-like-imageview.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[HumanBeing](https://github.com/HumanBeingXenon)、[keepmovingljzy](https://github.com/keepmovingljzy)

# 构建像 `Messenger` 短信软件那样的 ImageView

![](https://cdn-images-1.medium.com/max/2372/1*eUsCLT2MWPgMMc_7ltldOw.png)

在上一篇论述中，我们讨论了[发送图片消息时候的上传动画以及构建这个动画的方法](https://proandroiddev.com/telegram-like-uploading-animation-e284f1404f63)。今天我决定写一篇与图片的显示有关的文章。先来提个问题，在消息历史记录中，我们应该如何显示图片？

当然是使用 `ImageView` 啦！好的这篇文章到此结束啦！

嘿，别走！虽说我们可以使用 ImageView 简简单单就能呈现图片信息，但要做到像 Messenger 应用那样显示图片并非像我们想象中那么简单。虽说本质上难度并不大，但是，我们所需要的不仅是一个 `ImageView`，还要一些小计算，以查看尺寸是否适合我们要向用户展示的内容。 

## 测量

首先我们需要了解我们应该要做什么。我们解决方案的核心是，我们要基于某些图片或动图，或任何其他可显示媒体的预定义大小（宽度和高度），在考虑显示图片的容器的尺寸限制（例如我们可能需要把尺寸为 1000x1000 的图片缩小以适合尺寸只有 100x100 的容器），而且应该在大多数情况下保持长宽比的情况下绘制图片。

也就是说基本步骤可以分为两部分：

1. 依据容器尺寸界定最佳的尺寸并将其提供给程序程序。如果图像太小，我们需要将其调整直到其最短的边的长度等于容器最短的边长。
2. 给予其与容器一些约束条件（例如使用 `maxSize` 控制大小）。并且如果可能的话，我们应该就长宽比来计算得出最终的大小（稍后我们将讨论其他可能的情况）

### 定义尺寸

让我们从一个简单的 `Size` 类的定义开始。它将包含图像的 `width` 和 `height`，并且向它添加对我们计算有帮助的方法：

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

    // 这里不希望让 mutable class 变成 data class
    fun copy(width: Int = this.width, height: Int = this.height) = Size(width, height)
}
```

这里有几点说明：

1. 我们之所以把这个类定义为可变类，是因为它将在视图内使用，并且我们希望优化实例的创建 —— 因为我们的程序是在一个线程中工作的，我们不希望也不需要因为创造它而浪费大量资源。
2.  我们其实可以将 `Size` 类本身视作数据类而不是自定义一个 `copy` 函数，但是我不想将可变性与数据类搭上边，因为数据类本应是不可变的。

我们现在定义好了 `Size` 类，可以接着创建一个 `ImageSizeMeasurer` 类，负责尺寸的定义、调整和测量。

### 设置所需的尺寸

首先我们将设置图片所需的尺寸以及最小尺寸。在这个方法中，我们将检查所需大小是否小于最小值，如果是则对其进行依次调整：

```Kotlin
internal class ImageSizeMeasurer {
    private var minSize: Size = Size(0, 0)

    private var desiredSize = Size(0, 0)
    val desired get() = desiredSize.copy()

    // = (height/width)
    var fixRatio: Float = 1f
        private set

    // ...

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

此处我们使用了 `copy` 方法以避免数据被客户端操作修改的时候影响到。`copy` 方法让这些数据可以暗地里在不同地方之间共享（因此我们就不会因为字段不知道什么时候被更改而震惊）。

这里的关键点在于设置大小和比例后，我们需要对其进行调整。不必担忧调用 `adjustDesiredHeight` 和 `adjustDesiredWidth` 方法时没有进行任何智能检查会造成任何严重后果。因为第一个方法在 `height` 小于 `width` 的情况下会把 `desiredSize` 中处于最小值的高度增加到 `minSize`，第二个函数在 `width` 小于 `height` 的情况下会把 `desiredSize` 处在最小值的宽度增加到 `minSize`。

#### 分别测量约束条件

我们调整好了期望尺寸的最小尺寸，现在该测量实际尺寸的最大尺寸的了。该方法本身并不难，我们只需要记住，应该保证所有的更新不改变高宽比，除非降低图像的高度和宽度会导致两者之一小于 `minSize`。

比如说，应用于非常窄的图片。

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/messengers-like-imageview-example.png?raw=true)

* 要么宽度符合最大限值，但高度太小
* 要么高度达到最小限值，但宽度过大
* 要么将宽度设置为最大限值，高度设置为最小限值，但这个做法破坏了宽高比。

在那种情况下，最后一个选项是最合适的选择，因为我们不能让图像大小超过约束尺寸，并且我们也不希望图像太窄，因为过于小的图片可能会让我们很难看清图片的内容，或与之交互。在这里我们可以使用 `scaleType = imageCrop`：它能帮助你在打破图片显示的宽高比的情况下正确地显示图片。

```Kotlin
internal class ImageSizeMeasurer {
    private var minSize: Size = Size(0, 0)

    var desiredSize = Size(0, 0)
        get() = field.copy()
        private set

    // 放缩因子： `height` : `width`
    var fixRatio: Float = 1f
        private set

    // ...

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
    
    // ... 或者在这里设置需要的尺寸
}
```

让我们快速分析该 `measure` 方法。

* 当所需大小适合最大大小时，一切正常。`setDesiredSize` 确定尺寸之后，我们将确保尺寸不小于最小尺寸。现在，我们只需要确保它不大于最大大小。因此，我们将返回它本身（`when` 代码块中的第一个条件句）
* 如果以上预测错误，则说明要么宽度大于 `max.width` ，要么高度大于 `max.height` ，要么两者都超了。在这种情况下，图片的长宽比将与最大尺寸的长宽比相同，则我们可以输出最大尺寸，因为它将缩小为所需尺寸的结果。（`when` 代码块中的 `else` 语句）
* 在另一种情况下，我们只需要比较宽高比。例如 `width` 的期望尺寸大于最大尺寸。但是期望尺寸的宽高比也大于最大尺寸的长宽比。意味着，当我们缩小期望尺寸时（因此当前尺寸的 `width` 将会和最大尺寸的相等），期望尺寸的 `height` 仍然大于最大尺寸的 `height`。
因此，当期望尺寸的宽高比小于最大尺寸的长宽比时，我们只需将 `width` 更新为 `max.width`，然后高度也会相应地更新。但是如果小于 `minSize.height` ，我们将打破结果的宽高比，并把 `out.height` 设置为 `minSize.height`。
* 类似地，如果期望尺寸的宽高比大于最大尺寸的宽高比，我们只需要将 `height` 更新为 `max.height`，宽度也相应地更新。但是，如果小于 `minSize.width` 我们将打破结果的宽高比，并且将 `out.width` 设置为 `minSize.width`。

## 所有计算中都带有一点魔术，使一切变得更自然，更漂亮

现在，我们准备好要衡量的所有内容：

```Kotlin
private val measurer: ImageSizeMeasurer
private val measureResult = Size(0, 0)
private val maxSize = Size(0, 0)

// ...

override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
    if (MeasureSpec.getMode(widthMeasureSpec) == MeasureSpec.UNSPECIFIED) {
        setMeasuredDimension(measurer.desired.width, measurer.desired.height)
    } else {
        measure(widthMeasureSpec, heightMeasureSpec)
    }
}

private fun measure(widthSpec: Int, heightSpec: Int) {
    maxSize.width = // 你可以在这里定义最大的尺寸：可以使用两个输入的尺寸，也可以使用硬编码的
    maxSize.height = // 宽高比并且只使用其中一个输入的尺寸，随你选择 :)
    measurer.measure(maxSize, measureResult)
    setMeasuredDimension(measureResult.width, measureResult.height)
}
```

这里的一切都足够简单。如果我们有未指明的尺寸，我们会告诉视图的父控件在理想状况下的期望尺寸。在另一种情况下（大多数情况下），我们需要提供 `width` 与 `height` 来设置 `maxSize`，并将它们传递进入我们的 `measurer`。

现在让我们看一下结果：

![](https://cdn-images-1.medium.com/max/2000/1*lTedeH88K2J4Z8snpeSOfw.png)

一切看起来都很棒，<span class="x x-first x-last">但是那些比较小图片似乎显示得太小了。我们希望让它们比现在的更大一些。你可能会说，“那就增大最小尺寸呗。”</span>我们当然可以这样做，但是在那种情况下，<span class="x x-first x-last">小图和更小尺寸的图片之间的显示上的大小不会有任何区别，因为它们将使用一个相同的最小尺寸定义</span>。

除此之外，我们可以施加点魔法！

而魔法的主要目的是通过增加一些幻数或公式使小图变大，并保持小图和更微小的图之间的大小差异：）

```Kotlin
fun measure(max: Size, out: Size) {
    val desired = desiredSize.copy()
    magicallyStretchTooSmallSize(max, desired)

    // ... 
}

private fun magicallyStretchTooSmallSize(max: ChatImageView.Size, desired: ChatImageView.Size) {
    if (desired in max) {
        // 如果图像小于最大尺寸，我们可以将图片尽可能往容器的边缘靠拢
        // 这是有意而为，目的是告诉用户他正在发送小图，
        // 调整后的图片不会变得太小，我们仅仅只需要用魔法调整一下就可以让图片变得更加漂亮了。
        val adjustedArea = desired.area + (max.area - desired.area) / 3f
        val outW = sqrt(adjustedArea / fixRatio)
        desired.height = (outW * fixRatio).toInt()
        desired.width = outW.toInt()
    }
}
```

这个算法思路很简短：将期望面积增加到最大和期望面积之差的 1/3，然后通过新的面积和宽高比计算得出新的宽度和高度。


这是一个比较结果。

![**Left:** without magic, **Right:** with magic](https://cdn-images-1.medium.com/max/2996/1*-pTHSTbjjPZlveMdtuTaeQ.gif)

我更喜欢新的结果：我们能够拥有更大的图片，能更方便地看清图片内容。但在同时，我们又能够理解图片的尺寸有所差异，有的图片比较大有的比较小。

## 如果我只知道比例就想要获取尺寸，该怎么办

让我们再进一步讨论一下能否有更多的改进吧。有时，我们并没有所要展示的图片的真实尺寸，而只获得了缩略图的尺寸。在这种情况下，我们不能缩略图的尺寸当作是所需的尺寸，因为这些规格要小得多，但是我们可以计算出比例是大了，小了还是完全相等，然后使用 `ImageSizeMeasurer` 对象，在只有固定宽高比得情况下，尝试计算得出所需尺寸并让这个尺寸尽可能满足最大约束。

因此，首先，我们向 `Size` 类添加一个新属性：

```
val isSpecified: Boolean get() = width > 0 && height > 0
```

接下来，我们需要添加方法以设置所需的比率而不是所需的大小：

```
fun setDesiredRatio(ratio: Float, min: Size) {
    minSize = min.copy()
    desiredSize = Size(0, 0)
    fixRatio = ratio
}
```

然后，我们需要通过添加其他调整到所需的大小来更新 `measure` 方法：

```Kotlin
fun measure(max: ChatImageView.Size, out: ChatImageView.Size) {
    val desired = desiredSize.copy()
    fixUnspecifiedDesiredSize(max, desired)
    magicallyStretchTooSmallSize(max, desired)
    
    // ...
}

// 没有指定所需的大小，但指定了宽高比，那么先将图片最大化伸展。
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

最后，让我们更新 `onMeasure` 方法：

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
    maxSize.width = // 我们可以同时使用两个规格或具有一些预定义的
    maxSize.height = // 同时使用宽高或仅使用其中之一来定义最大尺寸，任君挑选；）
    measurer.measure(maxSize, measureResult)
    setMeasuredDimension(measureResult.width, measureResult.height)
}
```

## 让我们一起讨论一下视图

到现在为止一切表现得还挺好。我们拥有了一个绝妙的图片尺寸计算工具！我们甚至对如何将其与视图整合都有一个粗略的了解，但是我们仍然没有思路如何表现。

让我们首先描述一下我们想要什么。实际上，指定 `minWidth` 和 `minHeight` 并不难。这些属性是 xml 的一部分，`maxWidth` 和 `maxHeight` 也如此。但是我不想在这里硬编码任何特定的大小。相反，我想更多地依靠设备屏幕。意思是，最好用百分比来指定这些最大约束。我们现在已经拥有了 `ConstraintLayout` 控件，按理说像这样指定最大宽度（例如屏幕宽度的 70%）并不难...但是高度应该怎么办？

其实你可以任意指定约束比例，毕竟这只是我的一点想法罢了。出于某些原因，我决定根据宽度决定高度，乘以缩放因子。因此，假设我们的 `factor` 值为 `1`，那便就是一个正方形。也就是说，只需指定 `width`（以及比例），程序就能计算对应的高度。

如你所见，做法极其简单，但也极度依赖屏幕尺寸，而不是取决于设备的不同因素的 dimens.xml 中的各种定义，尽管后者的解决方案是安卓化的：

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

## 合并所有代码！

让我们看看最终的代码：

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

        // 缩放因子 height : width
        var fixRatio: Float = 1f
            private set

        init { reset() }

        // 我们依赖客户端的 MATCH_PARENT 的设置以获取宽度
        // 并且不创建新的 Size
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

        // 如果没有指定期望尺寸，但指定了缩放因数，那么先将图像最大程度地伸展
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
                // 如果图像比最大界限小，我们就把这张图额外拉伸一点儿至边界值
                // 这是有意这么做的，因为如果我们要发送小图像，图像不应该太小。
                // 因此，它只是某种调整魔法，让图片看起来更靓 ;)
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

        // 不想使可变类成为数据类
        fun copy(width: Int = this.width, height: Int = this.height) = Size(width, height)
    }
}
```

我们的努力所换来的完美的运行结果：

![](https://cdn-images-1.medium.com/max/2000/1*gSYcSTxF0jS3NbpbAR0MXQ.gif)

## 后记

如果你喜欢这篇文章，别忘记点赞或一键三连来支持我们。如果你有任何的疑问，请在评论区留言，让我们可以一起讨论！祝你编程快乐！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
