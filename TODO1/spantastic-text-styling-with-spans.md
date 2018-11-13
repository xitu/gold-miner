> * 原文地址：[Spantastic text styling with Spans](https://medium.com/google-developers/spantastic-text-styling-with-spans-17b0c16b4568)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/spantastic-text-styling-with-spans.md](https://github.com/xitu/gold-miner/blob/master/TODO1/spantastic-text-styling-with-spans.md)
> * 译者：[wzasd](https://github.com/wzasd)
> * 校对者：[luochen1992](https://github.com/luochen1992)

# 使用 Span 来修改文本样式的优质体验

![](https://cdn-images-1.medium.com/max/2000/1*_91P4pyi4_V0xUX89YXMyg.png)

插图来自 [Virginia Poltrack](https://twitter.com/VPoltrack)

如果要在 Android 中设置文字的样式，请使用 spans！使用 span 改变一些字符的颜色，使它们可以被点击、缩放文本的大小、甚至是绘制自定义的 bullet points。Spans 可以改变 `TextPaint` 属性、在 `Canvas` 上绘制，甚至改变文本布局并影响线高等元素。Span 是可以附加到文本和从文本分离的标记对象，它们可以应用于整个段落或部分文本。

让我们来学习如何使用 spans，有哪些 spans 供我们选择，如何简单创建属于你的 spans 以及如何测试它们。

### 在 Android 中设置文字样式

Android 提供了几种方法用于文本样式的设置：

*   **单一样式** —— 样式是用于由 TextView 显示的整个文本
*   **多样式** —— 可以将多种不同的样式分别应用于文字、字符或者段落

**单一样式** 意味着使用 XML 属性或者[样式和主题](https://developer.android.com/guide/topics/ui/look-and-feel/themes.html)对 TextView 的整个内容进行样式的修改。使用 XML 的方法是一种比较简单的解决方案，但是这种方法无法修改文本中间的样式。例如，通过设置 `textStyle=”bold”`，整个文本将变成粗体，您不能只将特定字符定义为粗体。

```
<TextView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:textSize="32sp"
    android:textStyle="bold"/>
```

**多样式**意味着在同一文本中添加多种样式。例如，将一个单词设置为斜体，另一个单词设置为粗体。多样式模式可以使用 HTML 标签，在画布上使用 spans 或者通过处理自定义文本绘制来进行文本样式的应用。

![](https://cdn-images-1.medium.com/max/800/0*3hnVPTJP5Hv4Jduo.)

左图：单一样式的文本。TextView 设置 `textSize=”32sp”` 和 `textStyle=”bold”`。右图：多样式的文本。文本设置 `ForegroundColorSpan`、`StyleSpan(ITALIC)`、`ScaleXSpan(1.5f)` 和 `StrikethroughSpan`。

**HTML 标签**是一种处理简单样式问题的解决方案，如使文字变粗体、斜体甚至是标识 bullet points。要设置包含 HTML 标签的文本，请调用 [`Html.fromHtml`](https://developer.android.com/reference/android/text/Html.html#fromHtml%28java.lang.String,%20int%29) 方法。在 HTML 引擎中，HTML 格式被转换成 spans。请注意，`Html` 类并不支持所有 HTML 标签和 css 样式，例如使 bullet points 变成另一种颜色。

```
val text = "My text <ul><li>bullet one</li><li>bullet two</li></ul>"
myTextView.text = Html.fromHtml(text)
```

当您发现有平台不支持的样式需求时，您可以手动**在画布上绘制文本**，例如需要写一个弯曲的文本。

**Spans** 允许您使用更精细的方法来自定义实现多样式文本。例如，您可以通过使用 [`BulletSpan`](https://developer.android.com/reference/android/text/style/BulletSpan.html) 来定义 bullet point。您也可以自定义目标文本边距和颜色。从 Android P 开始，您甚至可以[设置 bullet point 的半径](https://developer.android.com/reference/android/text/style/BulletSpan.html#BulletSpan%28int,%20int,%20int%29)。

``` Java
val spannable = SpannableString("My text \nbullet one\nbullet two")

spannable.setSpan(
    BulletPointSpan(gapWidthPx, accentColor),
    /* start index */ 9, /* end index */ 18,
    Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)

spannable.setSpan(
     BulletPointSpan(gapWidthPx, accentColor),
     /* start index */ 20, /* end index */ spannable.length,
     Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)

myTextView.text = spannable
```

![](https://cdn-images-1.medium.com/max/800/0*z7VsMx891rPMRhiY.)

左图：使用 HTML 标签。中图：使用 `BulletSpan` 设置默认 bullet 大小。右图：使用 `BulletSpan` 在 Android P 或者自定义实现。

您可以结合单一样式和多样式。您可以将您设置 TextView 的样式视为“基础”样式。spans 的文本样式应用于基础样式的“顶部”，并且会覆盖基础样式。例如，当将 `textColor=”@color.blue”` 属性设置为 TextView 并对文本的前4个字符设置 `ForegroundColorSpan(Color.PINK)` 时，前 4 个字符将使用粉红色，是由 span 来进行控制，剩下的部分有 TextView 属性来进行设置。

``` Java
<TextView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:textColor="@color/blue"/>

val spannable = SpannableString(“Text styling”)
spannable.setSpan(
    ForegroundColorSpan(Color.PINK), 
    0, 4, 
    Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)

myTextView.text = spannable
```

![](https://cdn-images-1.medium.com/max/800/1*JIWZ3OBz2PHdo9Grt0lBnw.png)

将 TextView 使用 XML 和文本结合的方式来使用 spans。

### 应用中的 Spans

当使用 spans 时，您将使用以下类之一：[`SpannedString`](https://developer.android.com/reference/android/text/SpannedString.html)、[`SpannableString`](https://developer.android.com/reference/android/text/SpannableString.html) 或者 [`SpannableStringBuilder`](https://developer.android.com/reference/android/text/SpannableStringBuilder.html)。他们之间的区别在于文本或者标记的对象是否可变以及他们使用内部结构：`SpannedString` 和 `SpannableString` 是使用线性的方式来保存添加 spans 的记录。而 `SpannableStringBuilder` 使用[区间树](https://en.wikipedia.org/wiki/Interval_tree)来实现。

以下是怎么确定要使用哪一个 Spans：

*   仅仅**读取而不是设置**文本或者 spans？ -> `SpannableString`
*   **设置文本和 spans** ？-> `SpannableStringBuilder`
*   设置一个 **spans 很少数量的文本**(<~10)？ -> `SpannableString`
*   设置一个 **spans 很大数量的文本**(>~10)？ -> `SpannableStringBuilder`

例如，如果您使用的文本不会改变，但要将其附加到 spans 的文本中，应该使用 `SpannableString`。

```
╔════════════════════════╦══════════════════╦════════════════════╗
║ **Class**              ║ **Mutable Text** ║ **Mutable Markup** ║
╠════════════════════════╬══════════════════╬════════════════════╣
║ SpannedString          ║       no         ║       no           ║
║ SpannableString        ║       no         ║       yes          ║
║ SpannableStringBuilder ║       yes        ║       yes          ║
╚════════════════════════╩══════════════════╩════════════════════╝
```

所有这些类都继承 [`Spanned`](https://developer.android.com/reference/android/text/Spanned.html) 的接口，但是具有可变标记（`SpannableString` 和 `SpannableStringBuilder`）也是继承与[`Spannable`](https://developer.android.com/reference/android/text/Spannable.html)。

[Spanned](https://developer.android.com/reference/android/text/Spanned.html) -> 带有不可变标记的不可变文本

[Spannable](https://developer.android.com/reference/android/text/Spannable.html)（继承 `Spanned`）-> 具有可变标记的不可变文本

通过 `Spannable` 对象调用 [`setSpan(Object what, int start, int end, int flags)`](https://developer.android.com/reference/android/text/Spannable.html#setSpan%28java.lang.Object,%20int,%20int,%20int%29) 。`what`对象是将从文本中的开始到结束索引的标记。这个标志代表了这个 span 是否应在其扩展到包含起点或者终点的位置处插入文本。无论在那个位置进行标记，只要文本插入的位置大于起点小于终点位置，span 将自动扩大。

举个例子，设置一个 `ForegroundColorSpan` 可以像这么做：

``` Java
val spannable = SpannableStringBuilder(“Text is spantastic!”)

spannable.setSpan(
     ForegroundColorSpan(Color.RED), 
     8, 12, 
     Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
```

由于 span 是使用 [`SPAN_EXCLUSIVE_INCLUSIVE`](https://developer.android.com/reference/android/text/Spanned.html#SPAN_EXCLUSIVE_EXCLUSIVE) 标志，因此在文本末插入文本时，它将会扩展到包含新的文本。

``` Java
val spannable = SpannableStringBuilder(“Text is spantastic!”)

spannable.setSpan(
     ForegroundColorSpan(Color.RED), 
     /* start index */ 8, /* end index */ 12, 
     Spannable.SPAN_EXCLUSIVE_INCLUSIVE)

spannable.insert(12, “(& fon)”)
```

![](https://cdn-images-1.medium.com/max/800/0*Bq7PnfvDBcm1CjK7.)

左图：文本使用 `ForegroundColorSpan`。右图：文本使用 `ForegroundColorSpan` 和 `Spannable.SPAN_EXCLUSIVE_INCLUSIVE`。

如果 span 设置为 `Spannable.SPAN_EXCLUSIVE_EXCLUSIVE` 标志，则在 span 末尾插入的文本将不会修改 span 的结束标记。

多 spans 可以组成并且附加到相同的文本段。举个例子，粗体和红色的文字都可以这样构造：

``` Java
val spannable = SpannableString(“Text is spantastic!”)

spannable.setSpan(
     ForegroundColorSpan(Color.RED), 
     8, 12, 
     Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)

spannable.setSpan(
     StyleSpan(BOLD), 
     8, spannable.length, 
     Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
```

![](https://cdn-images-1.medium.com/max/800/1*8PXOuMO_daAGDsnIlADruw.png)

文本使用多 spans：`ForegroundColorSpan(Color.RED)` 和 `StyleSpan(BOLD)`。

### spans 的框架

Android 框架定义了在度量和渲染图形时检查的几个接口和抽象类。这些类具有允许 span 访问 `TextPaint` 或者 `Canvas` 对象的方法。

Android 框架在 [`android.text.style`](https://developer.android.com/reference/android/text/style/package-summary.html) 包中提供了20多个 span，对主要的接口和抽象类进行了子类化。我们可以用几种方法进行分类：

*   根据 span 是仅仅更改外观还是更改文字的度量/布局
*   根据它们是否影响文字在字符或者段落中的级别

![](https://cdn-images-1.medium.com/max/1000/0*3qvv1i8lbceOxq0P.)

Span 类型：字符与段落，外观与度量。

#### **外观与度量分别对 span 的影响**

第一组分类影响字符级文本可以修改它们的外观：文本或背景颜色、下划线、删除线等，会重新绘制而不会导致文本重新布局。这些 span 实现了 [`UpdateAppearance`](https://developer.android.com/reference/android/text/style/UpdateAppearance.html) 并且继承 [`CharacterStyle`](https://developer.android.com/reference/android/text/style/CharacterStyle.html)。`CharacterStyle` 子类定义了如何通过提供更新 `TextPaint` 来访问文本。

![](https://cdn-images-1.medium.com/max/1000/0*gwmWCXpJfDVV5Kcn.)

影响外观的 span。

**度量影响** spans 修改文本度量和布局，因此观察 span 的对象将会从新测量文本以便于正确的布局和渲染。

举个例子，影响文本大小的 span 将需要从新测量、布局以及绘制。这些 spans 通常会去继承 [`MetricAffectingSpan`](https://developer.android.com/reference/android/text/style/MetricAffectingSpan.html) 类。这个抽象类允许子类通过对 `TextPaint` 的访问来决定如何去测量文本。由于 `MetricAffectingSpan` 继承 `CharacterSpan`，因此子类会影响字符级别的文本外观。

![](https://cdn-images-1.medium.com/max/1000/0*Eq0RoZ20n7bWk_eu.)

影响度量的 span。

您可能总是想去重新创建带有文本和标记的 `CharSequence`，并调用 [`TextView.setText(CharSequence)`](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence%29)。 但是这将会导致每次重新测量、重新绘制布局以及创建额外对象。为了降低性能消耗，请使用 [`TextView.setText(Spannable, BufferType.SPANNABLE)`](https://developer.android.com/reference/android/widget/TextView.html#setText%28int,%20android.widget.TextView.BufferType%29) 然后，当你需要修改 span 时，通过将 `TextView.getText()` 强制转换成 `Spannable` 来从 `TextView` 中检索 `Spannable` 对象。我们将在后面详细介绍 `TextView.setText` 背后的原理，以及不同的性能优化

举个例子，思考以下 `Spannable` 对象并像这样检索：

``` Java
val spannableString = SpannableString(“Spantastic text”)

// setting the text as a Spannable
textView.setText(spannableString, BufferType.SPANNABLE)

// later getting the instance of the text object held 
// by the TextView
// this can can be cast to Spannable only because we set it as a
// BufferType.SPANNABLE before
val spannableText = textView.text as Spannable
```

现在，当我们在 `spannableText` 中设置 span 时，我们不需要再次调用 `textView.setText`，因为我们直接修改由 `TextView` 持有的 `CharSequence` 对象实例。

以下是我们设置不同 span 时发生的情况：

**情况 1：影响外观的 span**

``` Java
spannableText.setSpan(
     ForegroundColorSpan(colorAccent), 
     0, 4, 
     Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
```

由于我们附加了一种影响外观的 span，因此调用了 `TextView.onDraw`，而不是 `TextView.onLayout`。文本进行重绘，但宽度和高度将会相同。

**情况 2：影响度量的 span**

``` Java
spannableText.setSpan(
     RelativeSizeSpan(2f), 
     0, 4, 
     Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
```

因为 [`RelativeSizeSpan`](https://developer.android.com/reference/android/text/style/RelativeSizeSpan.html) 可以改变文本的大小、宽度和高度（举个例子，一个特定的单词可能会出现在下一行，但是 TextView 的大小不会被修改）。`TextView` 需要计算新的大小，所以 `onMeasure` 和 `onLayout` 会被调用。

![](https://cdn-images-1.medium.com/max/800/0*Li86sQd6bpmNDWu9.)

左图：ForegroundColorSpan — 影响外观的 span。右图：RelativeSizeSpan — 影响度量的 span。

#### **影响字符和段落的 spans**

span 不但可以改变字符级别的文本，更新元素如背景颜色、样式或者大小，而且可以改变段落级别的文本，更改整个文本块的对齐或者边距。根据所需的样式，spans 继承 [`CharacterStyle`](https://developer.android.com/reference/android/text/style/CharacterStyle.html) 或者实现 [`ParagraphStyle`](https://developer.android.com/reference/android/text/style/ParagraphStyle.html)。继承 `ParagraphStyle` 的 Spans 必须从第一个字符附加到单个段落的最后一个字符，否则 span 将不会被显示出来。在 Android 上，段落是根据（`\n`）字符定义的。

![](https://cdn-images-1.medium.com/max/800/0*iK2M43udyG0m5Ic5.)

在 Android 上，段落是根据（`\n`）字符定义的。

![](https://cdn-images-1.medium.com/max/1000/0*CLKvPQz5xETA6Y84.)

影响段落的 spans。

举个例子，像是 [`BackgroundColorSpan`](https://developer.android.com/reference/android/text/style/BackgroundColorSpan.html) 的 `CharacterStyle` span，可以附加到文本中的任何字符。这里我们将其添加至第5到第8个字符中：

```
val spannable = SpannableString(“Text is\nspantastic”)

spannable.setSpan(
    BackgroundColorSpan(color),
    5, 8,
    Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
```

像 [`QuoteSpan`](https://developer.android.com/reference/android/text/style/QuoteSpan.html) 一样的 `ParagraphStyle` span 只能从段落开头附加，否则文字的边距并不会生效。举个例子，“_Text is_**_\n_**_spantastic_” 在文本的第8个字符中包含了换行，因此我们可以将 `QuoteSpan` 附加到它上面，并且只是从那里开始的段落将被格式化。如果我们将 span 附加到除了 0 或 8 以外的其他任何位置，则文本不会被设置目标样式。

```
spannable.setSpan(
    QuoteSpan(color), 
    8, text.length, 
    Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)
```

![](https://cdn-images-1.medium.com/max/800/0*J_YIdoh9-gXTQB5X.)

左图：BackgroundColorSpan — 影响外观的 span。右图：QuoteSpan — 影响段落的 span。

### 创建自定义的 spans

当需要实现自己的 span 时，您需要确定 span 是否需要影响字符或者段落文本，以及它是否影响布局或者文本的外观。但是从头开始编写自己的实现之前，请检查您是否可以使用 span 框架中提供的功能。

TL;DR:

*   在**字符级别**修改文本 -> `CharacterStyle`
*   在**段落级别**修改文本 -> `ParagraphStyle`
*   修改**文本外观** -> `UpdateAppearance`
*   修改**文本度量** -> `UpdateLayout`

假如我们需要实现一个 span，允许一定比例的增加文本的大小，就像是 `RelativeSizeSpan`，并设置文本的颜色，像是 `ForegroundColorSpan`。为此，我们可以继承 `RelativeSizeSpan`，并且由于它提供了 `updateDrawState` 和 `updateMeasureState` 回调函数，我们可以重写绘制状态的回调并且设置 `TextPaint` 的颜色。

```
class RelativeSizeColorSpan(
    @ColorInt private val color: Int,
    size: Float
) : RelativeSizeSpan(size) {

    override fun updateDrawState(textPaint: TextPaint?) {
         super.updateDrawState(ds)
         textPaint?.color = color
    }
}
```

提示：通过将 `RelativeSizeSpan` 和 `ForegroundColorSpan` 设置在相同的文本可以获得同样的效果。

### 测试您实现自定义的 spans

测试 spans 意味着检查是否确实对 TextPaint 进行了预期的修改或者 Canvas 上绘制了正确的元素。举个例子，考虑 span 的自定义实现，该 span 向段落中添加具有大小和颜色的 bullet point 以及左边距和 bullet point 之间的间隙。请参考 [android-text sample](https://github.com/googlesamples/android-text/blob/master/TextStyling-Kotlin/app/src/main/java/com/android/example/text/styling/renderer/spans/BulletPointSpan.kt)。为了测试这个类而实现了一个 AndroidJUnit 测试类来检查是否满足预期效果：

*   在画布上绘制一个特定尺寸的圆
*   如果 span 未附加到文本，则不绘制任何内容
*   根据构造函数的参数值设置正确的页边距

测试 Canvas 交互可以通过模拟一个画布，将模拟出来的对象传递给 `drawLeadingMargin` 方法，并验证调用的含有正确参数的方法。

```
val canvas = mock(Canvas::class.java)
val paint = mock(Paint::class.java)
val text = SpannableString("text")

@Test fun drawLeadingMargin() {
    val x = 10
    val dir = 15
    val top = 5
    val bottom = 7
    val color = Color.RED

    // Given a span that is set on a text
    val span = BulletPointSpan(GAP_WIDTH, color)
    text.setSpan(span, 0, 2, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)

    // When the leading margin is drawn
    span.drawLeadingMargin(canvas, paint, x, dir, top, 0, bottom,
            text, 0, 0, true, mock(Layout::class.java))

    // Check that the correct canvas and paint methods are called, 
    //in the correct order
    val inOrder = inOrder(canvas, paint)

    // bullet point paint color is the one we set
    inOrder.verify(paint).color = color
    inOrder.verify(paint).style = eq<Paint.Style>(Paint.Style.FILL)

    // a circle with the correct size is drawn 
    // at the correct location
    val xCoordinate = GAP_WIDTH.toFloat() + x.toFloat()
    +dir * BulletPointSpan.DEFAULT_BULLET_RADIUS
    val yCoord = (top + bottom) / 2f

    inOrder.verify(canvas)
           .drawCircle(
                eq(xCoordinate),
                eq(yCoord), 
                eq(BulletPointSpan.DEFAULT_BULLET_RADIUS), 
                eq(paint))
    verify(canvas, never()).save()
    verify(canvas, never()).translate(
               eq(xCoordinate), 
               eq(yCoordinate))
}
```

查看其余的测试在 [`BulletPointSpanTest`](https://github.com/googlesamples/android-text/blob/master/TextStyling-Kotlin/app/src/androidTest/java/com/android/example/text/styling/renderer/spans/BulletPointSpanTest.kt)。

### 测试 spans 的用法

[`Spanned`](https://developer.android.com/reference/android/text/Spanned.html) 接口允许从文本中设置和检索 span。通过实现 Android JUnit 测试，来检查是否在正确的位置添加了正确的 span。在 [android-text sample](https://github.com/googlesamples/android-text) 中，我们 bullet point 标记标签转换成 bullet points。这是通过 在正确的位置附加 `BulletPointSpans` 来完成的。以下是可以被测试的方式：
```
@Test fun textWithBulletPoints() {
val result = builder.markdownToSpans(“Points\n* one\n+ two”)

// check that the markup tags are removed
assertEquals(“Points\none\ntwo”, result.toString())

// get all the spans attached to the SpannedString
val spans = result.getSpans<Any>(0, result.length, Any::class.java)assertEquals(2, spans.size.toLong())

// check that the span is indeed a BulletPointSpan
val bulletSpan = spans[0] as BulletPointSpan

// check that the start and end indexes are the expected ones
assertEquals(7, result.getSpanStart(bulletSpan).toLong())
assertEquals(11, result.getSpanEnd(bulletSpan).toLong())

val bulletSpan2 = spans[1] as BulletPointSpan
assertEquals(11, result.getSpanStart(bulletSpan2).toLong())
assertEquals(14, result.getSpanEnd(bulletSpan2).toLong())
}
```

查看 [`MarkdownBuilderTest`](https://github.com/googlesamples/android-text/blob/master/TextStyling-Kotlin/app/src/androidTest/java/com/android/example/text/styling/renderer/MarkdownBuilderTest.kt) 以获得更多测试示例。

> 提示：如果你需要遍历测试外的 spans，使用 [`Spanned#nextSpanTransition`](https://developer.android.com/reference/android/text/Spanned.html#nextSpanTransition%28int,%20int,%20java.lang.Class%29) 而不是 [`Spanned#getSpans`](https://developer.android.com/reference/android/text/Spanned.html#getSpans%28int,%20int,%20java.lang.Class%3CT%3E%29)，因为它更高效。

* * *

Spans 是一个很强大的概念，文本渲染功能中有强大的功能。他们允许访问像 `TextPaint` 和 `Canvas` 这样的组件，这些组件可以在 Android 上进行高度可定制的样式文本。在 Android P 中，我们为 [spans 框架](https://developer.android.com/reference/android/text/style/package-summary.html)添加了大量文档，因此在您需要实现自己的 span 的时候，请先查看是否有您需要的功能。

在以后的文章中，我们将更详细地介绍 span 如何在引擎下以高效的方式使用它们。例如，您需要使用 [`textView.setText(CharSequence, BufferType)`](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence,%20android.widget.TextView.BufferType%29)。有关详情，敬请关注！

> 非常感谢 [Siyamed Sinir](https://twitter.com/siyamed), Clara Bayarri 和 [Nick Butcher](https://medium.com/@crafty)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
