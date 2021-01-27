> * 原文地址：[Messengers-like ImageView](https://proandroiddev.com/messengers-like-imageview-90e9f1da19f4)
> * 原文作者：[Michael Spitsin](https://medium.com/@programmerr47)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/messengers-like-imageview.md](https://github.com/xitu/gold-miner/blob/master/article/2021/messengers-like-imageview.md)
> * 译者：苏苏的 [霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 构建和 `Messenger` 一样的 ImageView

![](https://cdn-images-1.medium.com/max/2372/1*eUsCLT2MWPgMMc_7ltldOw.png)

在上一个故事中，我们提及了[发送图片消息的上传动画以及我们如何构建它](https://proandroiddev.com/telegram-like-uploading-animation-e284f1404f63)
。今天，我决定写有关图片本身的文章，我们应该如何在消息历史记录中显示它们？

当然是使用 `ImageView` 啦！好的这篇文章到此结束啦！

喔但是请稍等一下，我将尝试向你证明，使用它像 Messenger 应用那样显示图片并不是那么简单。说实话，这并不难，但是，我们所需要的不仅是一个 `ImageView`，还要附带一些计算来确定它的大小适合您向用户显示的内容。

## 测量

因此，第一部分是了解需要做什么。我们解决方案的核心是，我们要基于某些图片或动图，或任何其他可显示媒体的预定义大小（宽度和高度）来绘制图像，但要考虑到要显示图片的容器的限制（例如需要缩小尺寸为 1000x1000 的图片以适合只有
100x100 大小的容器），而且应该在大多数情况下保持长宽比。

因此，这意味着我们的基本流程可以分为两部分：

1. 依据容器尺寸定义并提供所需的尺寸。如果图像太小，我们需要将其缩放直到其最短的边的长度等于容器各边的最短的长度
2. 给它和容器一些约束（例如使用 `maxSize` 控制大小）。并且如果可能的话，我们应该就长宽比来计算得出最终的大小（稍后我们将讨论所有可能的情况）

### 定义尺寸

让我们从一个简单的 `Size` 类的定义开始。它将包含图像的 `width` 和 `height`，而且它还会给我们提供大量有用的方法：

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

    // 不要想要去将 mutable class 变成 data class
    fun copy(width: Int = this.width, height: Int = this.height) = Size(width, height)
}
```

这里有几点说明：

1. 我们需要确保这一个 class 是可变的，因为它将在视图内使用，并且我们希望优化实例的创建 —— 因为我们的程序是在一个线程中工作的，我们不希望也不需要它的实例的创建变得浪费资源。
2. 除了可以定制 `copy` 函数以外，我们还可以将其 `Size` 作为 data 类，但是我不想将 mutable 与 data （应该是非可变的）类混用。

现在，有了我们自己的 `Size` 的定义，我们可以创建一个 `ImageSizeMeasurer` 类，负责尺寸的定义、调整和测量。

### 设置所需的尺寸

首先我们将设置图片所需的尺寸以及最小尺寸。在这个方法中，我们将检查所需大小是否小于最小大小，如果是，则对其进行单独的调整：

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

我们使用 `copy` 函数以让不会修改客户端的数据，让这些字段可以在客户端之间共享（所以不管你的字段从某个地方更改都不会有让我们惊讶的变化发生）。

这里的关键是在设置大小和比例后，我们需要对其进行调整。我们需要执行 `adjustDesiredHeight` 和 `adjustDesiredWidth` 函数以进行任何智能检查，而这是百利无一害的。第一个函数在 `height`
小于 `width` 的情况下会增加 `desiredSize` 的最小高度到 `minSize`，第二个函数在 `width` 小于 height 的情况下会增加 `desiredSize` 的最小宽度到 `minSize`。

#### 分别对他们测量约束尺寸

我们准备了相对于最小尺寸的所需尺寸，现在该测量相对于最大尺寸的实际尺寸了。该方法本身并不难，我们只需要记住，应该进行所有尺寸都同时更新并且不改变宽高比，除非降低图像的高度和宽度会导致其中之一小于 `minSize`。

比如说应用于非常小的图片。

![](https://cdn-images-1.medium.com/max/3148/1*Oc74IKgtG8h7docIWyka-Q.png)
[//]: # TODO: translate the image

* 两者都将具有适合最大约束的宽度，但高度太小
* 否则您将在最小约束中设置高度，但宽度太大
* 否则您必须将宽度设置为最大限制，高度设置为最小限制，并破坏宽高比。

在这种情况下，最后一个选项是最合适的选择，因为我们不能将图像大小超过约束，并且我们也不希望图像太窄，因为可能很难看到显示的内容并单击它。而且我们可以使用 `scaleType = imageCrop`：它在打破宽高比的情况下对您有所帮助。

```Kotlin
internal class ImageSizeMeasurer {
    private var minSize: Size = Size(0, 0)

    var desiredSize = Size(0, 0)
        get() = field.copy()
        private set

    // 分数： `height` : `width`
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

当所需大小适合最大大小时，一切正常。`setDesiredSize` 确定尺寸之后，我们将确保尺寸不小于最小尺寸。现在，我们只是确保它不大于最大大小。因此，我们将返回它（中的第一个谓词when）
如果上述谓词不正确，则宽度将大于 `max.width` 或高度将大于 `max.height`
或两者都大于。如果在这种情况下，图像的长宽比将与最大尺寸的长宽比相同，则我们可以仅使用最大尺寸作为输出尺寸，因为它将缩小为所需尺寸的结果。（中的else块when）
在另一种情况下，我们只需要查看纵横比即可进行比较。让我解释。例如 `width`，我们可能需要的大小大于 `width` 最大大小。但是所需大小的长宽比也将大于最大大小的长宽比。就是说，当我们缩小所需尺寸时（因此 `width`
它将等于 `width` 最大尺寸）`height`，所需尺寸仍将大于 `height` 最大尺寸 因此，当所需尺寸的长宽比小于最大尺寸的长宽比时，我们只需更新 `width` 为 `max.width`
，高度将分别更新。但是，如果小于此值，`minSize.height` 我们将打破结果的宽高比并将其分配 `minSize.height` 给 `out.height`
类似地，如果所期望的纵横比大于最大大小的纵横比，我们只是更新 `height` 为 `max.height` 和宽度将分别被更新。但是，如果小于此值，`minSize.width`
我们将打破结果的宽高比并将其分配 `minSize.width` 给 `out.width`

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

这里的一切都很简单。如果我们有 `unspecified` 尺寸，我们会告诉视图的父控件我们想要的大小，我们希望在理想情况下具有该大小。在另一种情况下（`AT_MOST` 或 `EXACTLY`），我们需要使用提供的 `width`
并 `height` 设置 `maxSize` 并将其传递到我们的中 `measurer`。

现在让我们看一下结果：

![](https://cdn-images-1.medium.com/max/2000/1*lTedeH88K2J4Z8snpeSOfw.png)

一切看起来都很棒，但是小图像似乎太小了。我们希望使它们比现在大一些。您可以说“只增加最小尺寸”。好吧，我们可以这样做，但是在那种情况下，小图像和小图像之间不会有任何区别，因为它们将使用相同的最小尺寸。

除此之外，我们可以添加一些魔术

魔术的结论是通过增加一些魔术常数或公式使小图像变大，并保持小图像和小图像之间的大小差异：）

```Kotlin
fun measure(max: Size, out: Size) {
    val desired = desiredSize.copy()
    magicallyStretchTooSmallSize(max, desired)

    // ... 
}

private fun magicallyStretchTooSmallSize(max: ChatImageView.Size, desired: ChatImageView.Size) {
    if (desired in max) {
        // 如果图像比最大界限我们另外这个形象有点舒展小
        // 这些界限。这是有意完成的，因为如果您要发送小图像，
        // 它不会太小。因此，它只是一些调整魔力外观形象更靓;）
        val adjustedArea = desired.area + (max.area - desired.area) / 3f
        val outW = sqrt(adjustedArea / fixRatio)
        desired.height = (outW * fixRatio).toInt()
        desired.width = outW.toInt()
    }
}
```

该算法很简短：将所需的面积增加最大和所需面积之差的1/3，然后知道新的所需面积和比率，找到新的宽度和高度。

这是一个比较结果。

![**Left:** without magic, **Right:** with magic](https://cdn-images-1.medium.com/max/2996/1*-pTHSTbjjPZlveMdtuTaeQ.gif)

我喜欢在新结果中我们拥有更大的图片，因此更方便地观察它们，但是与此同时，您仍然可以理解，有些图片更大（更详细），有些更小。

如果我只知道比例就想要建造尺寸怎么办
另外，让我们讨论进一步的改进。有时，您没有图像的最终规格（最终的高度和宽度），而是缩略图的规格。因此，您不能将它们用作所需的尺寸，因为这些规格要小得多，但是您可以计算出大致相同的比例，然后 `ImageSizeMeasurer`
通过仅具有固定比例并尝试计算最终尺寸来计算最终尺寸尽可能满足最大约束。

因此，首先，我们向 `Size` 类添加一个新属性：

```
val isSpecified: Boolean get() = width > 0 && height > 0
```

接下来，我们需要添加一种可能性来设置所需的比率，而不是所需的大小：

```
fun setDesiredRatio(ratio: Float, min: Size) {
    minSize = min.copy()
    desiredSize = Size(0, 0)
    fixRatio = ratio
}
```

然后，我们将 `measure` 通过添加其他调整到所需的大小来更新：

```Kotlin
fun measure(max: ChatImageView.Size, out: ChatImageView.Size) {
    val desired = desiredSize.copy()
    fixUnspecifiedDesiredSize(max, desired)
    magicallyStretchTooSmallSize(max, desired)
    
    // ...
}

// 如果没有指定所需的大小，但系数，然后先伸展最大图像
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

最后，让我们更新 `onMeasure`

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
    maxSize.width = // 您可以同时使用两个规格或具有一些预定义的
    maxSize.height = // 宽高比并仅使用一个规格来定义最大尺寸。选择是你的；）
    measurer.measure(maxSize, measureResult)
    setMeasuredDimension(measureResult.width, measureResult.height)
}
```

让我们谈谈观点 到现在为止还挺好。我们拥有可以统治世界并创造新宇宙的特殊测量器！我们甚至对如何将其与视图整合都有一个粗略的了解。但是我们仍然没有观点。

让我们首先描述一下，我们想要什么。实际上，指定 `minWidth` 和并不难 `minHeight`。这些属性是xml的一部分。好了，`maxWidth` 和 `maxHeight`
也。但是我不想在这里硬编码任何特定的大小。相反，我想更多地依靠设备屏幕。意思是，最好用百分比来指定这些最大约束。既然我们有了，`ConstraintLayout` 就不难指定这样的最大宽度（例如，屏幕宽度的 70％）。但是身高呢？

我会很快提醒您，您可以随意指定约束，我只是出于一点想法。由于某种原因，我决定根据宽度决定高度。因此，假设我们要拥有 `factor = 1`，那将只是一个正方形。只需指定width，高度将自动计算。

您将看到，该实现非常简单，但是与此同时，您具有屏幕大小依赖性，而不是 dimens.xml 取决于设备的不同因素，尽管后者的解决方案将更加“机器人化”：

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

## 聚集起来。

现在我们来看看最后一堂课：

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

        // 分数 height : width
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

        // 如果没有指定所需的大小，但因素是，那么先伸展图像最大
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
                // 如果图像比最大界限我们另外这个形象有点舒展小
                // 这些界限。这是有意完成的，因为如果您要发送小图像，
                // 它不会太小。因此，它只是一些调整魔力外观形象更靓;）
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

        // 不想使可变类成为数据类的
        fun copy(width: Int = this.width, height: Int = this.height) = Size(width, height)
    }
}
```

我们工作的结果：

![](https://cdn-images-1.medium.com/max/2000/1*gSYcSTxF0jS3NbpbAR0MXQ.gif)

## 后记

如果您喜欢那篇文章，请别忘了鼓掌支持我，如果有任何疑问，请给我评论，让我们进行讨论。编码愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
