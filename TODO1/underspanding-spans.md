> * 原文地址：[Underspanding spans](https://medium.com/google-developers/underspanding-spans-1b91008b97e4)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/underspanding-spans.md](https://github.com/xitu/gold-miner/blob/master/TODO1/underspanding-spans.md)
> * 译者：[tanglie1993](https://github.com/tanglie1993)
> * 校对者：[dandyxu](https://github.com/dandyxu), [ALVINYEH](https://github.com/ALVINYEH)

# 理解 span

![](https://cdn-images-1.medium.com/max/2000/1*Te49GZFBFW3PP8fiWv9oQA.png)

插图来自 [Virginia Poltrack](https://twitter.com/VPoltrack)

Span 够为文字和段落设置样式，它是通过让用户使用 TextPaint 和 Canvas 等组件来实现这些功能的。在上一篇文章中，我们讨论了如何使用 Span、Span 是什么、Span 本身自带的功能，以及如何实现并测试自己的 span。

* [**用 Span 设置一颗赛艇的文字样式**: 在 Android 中设置文字样式，请用 Span! 改变一些文字的颜色，使它们可以点击，并且缩放](https://medium.com/google-developers/spantastic-text-styling-with-spans-17b0c16b4568)

我们看看在特定的用例中，可以使用什么 API 来确保最佳性能。我们将探索 span 的原理，以及 framework 是如何使用它们的。最后，我们将了解如何在进程中或跨进程传递 span，以及基于这些，你在创建自定义 span 时需要警惕哪些陷阱。

### 原理：span 是怎样工作的

Android 框架在数个类中涉及了文字样式处理以及 span：[`TextView`](https://developer.android.com/reference/android/widget/TextView.html)、[`EditText`](https://developer.android.com/reference/android/widget/EditText.html)、layout 类 ([`Layout`](https://developer.android.com/reference/android/text/Layout.html)、[`StaticLayout`](https://developer.android.com/reference/android/text/StaticLayout.html)、[`DynamicLayout`](https://developer.android.com/reference/android/text/DynamicLayout.html)) 以及 `TextLine` (一个 `Layout` 中的包私有类) 而且它取决于数个参数：

*  文字类型：可选择，可编辑或不可选择。
*  [`BufferType`](https://developer.android.com/reference/android/widget/TextView.BufferType.html)
*  `TextView` 的 `LayoutParams` 类型
*  等等

框架会检查这些 `Spanned` 对象是否包含框架中不同类型的 span，并触发相应的行为。

文本布局和绘制背后的逻辑是很复杂的，并且遍布不同的类；在这一节中，我们只能针对几种情况，简单地说明一下文本是如何被处理的。

每当一个 span 改变时，[`TextView`](https://github.com/aosp-mirror/platform_frameworks_base/blob/master/core/java/android/widget/TextView.java) `spanChange` 检查 span 是否是 [`UpdateAppearance`](https://developer.android.com/reference/android/text/style/UpdateAppearance.html)、[`ParagraphStyle`](https://developer.android.com/reference/android/text/style/ParagraphStyle.html) 或 [`CharacterStyle`](https://developer.android.com/reference/android/text/style/CharacterStyle.html) 的实例，而且，如果是的话，对自己调用 invalidate 方法，触发视图重绘。

 [`TextLine`](https://github.com/aosp-mirror/platform_frameworks_base/blob/master/core/java/android/text/TextLine.java) 类表示一行具有样式的文字，并且它只接受 `CharacterStyle`， [`MetricAffectingSpan`](https://developer.android.com/reference/android/text/style/MetricAffectingSpan.html) 和 [`ReplacementSpan`](https://developer.android.com/reference/android/text/style/ReplacementSpan.html)的子类。这是触发 [`MetricAffectingSpan.updateMeasureState`](https://developer.android.com/reference/android/text/style/MetricAffectingSpan.html#updateMeasureState%28android.text.TextPaint%29) 和 [`CharacterStyle.updateDrawState`](https://developer.android.com/reference/android/text/style/CharacterStyle.html#updateDrawState%28android.text.TextPaint%29) 的类。

管理文字布局的基类是 [`android.text.Layout`](https://developer.android.com/reference/android/text/Layout.html)。 `Layout` 和两个子类，[`StaticLayout`](https://developer.android.com/reference/android/text/StaticLayout.html) 和 [`DynamicLayout`](https://developer.android.com/reference/android/text/DynamicLayout.html), 检查设置给文字的 span 并计算行高和布局 margin。除此以外，当一个 span 在 [`DynamicLayout`](https://developer.android.com/reference/android/text/DynamicLayout.html) 中展示并被更新时，layout 检查 span 是否是一个 `UpdateLayout`，并为被影响的文字生成一个新的 layout。

### 设置文字时确保最佳性能

有若干种办法可以在设置 `TextView` 的文字时有效节约内存，这取决于你的需要。

### 1. 为一个永不改变的 `TextView` 设置文字

如果你只需要设置 TextView 的文字一次，并永远不需要更新它，你可以创建一个新的 `SpannableString` 或 `SpannableStringBuilder` 实例，设置所需的 span 并调用 [`textView.setText(spannable)`](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence%29)。由于你不再修改这些文字，性能没有提升的空间。

### 2. 通过增加/删除 span 改变文字样式

考虑文字本身不改变，但附着于它的 span 会改变的情况。例如，当一个按钮被点击时，你希望文字中的一个词变成灰色。所以，我们需要给文字添加一个新的 span。为此，你很有可能会调用 [`textView.setText(CharSequence)`](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence%29) 两次：第一次设置初始文字，第二次在按钮被点击时重新设置。一个更好的选择是调用 [`textView.setText(CharSequence, BufferType)`](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence,%20android.widget.TextView.BufferType%29) 并在按钮被点击时只更新 `Spannable` 对象的 span。

下面是这些情况下底层发生的事情：

**选项 1: 调用** [**textView.setText(CharSequence)**](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence%29) **多次 — 并非最佳选择**

在调用 [`textView.setText(CharSequence)`](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence%29)时，`TextView` 悄悄复制了一份你的 `Spannable`，把它作为 `SpannedString`，并把它作为 `CharSequence` 存储在内存中。这样做的后果是你的 **文字和 span 是不可变的**。所以，当你需要更新文字样式时，你将需要使用文字和 span 创建一个新的 `Spannable`，并再次调用 `textView.setText`。这将会把整个对象再复制一次。

**选项 2: 调用** [**textView.setText(CharSequence, BufferType)**](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence,%20android.widget.TextView.BufferType%29) **一次并更新 spannable 对象 — 最佳选择**

在调用 [`textView.setText(CharSequence, BufferType)`](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence,%20android.widget.TextView.BufferType%29)时， `BufferType` 参数通知 `TextView` 什么类型的文字被设置了：静态（调用 `textView.setText(CharSequence)` 时的默认选项）、styleable / spannable 文字或 editable（被 `EditText` 使用）。

由于我们正在使用样式化的文字，我们可以调用：

```
textView.setText(spannableObject, BufferType.SPANNABLE)
```

在这种情况下， `TextView` 不再创建一个 `SpannedString` ，但它将在 [`Spannable.Factory`](https://developer.android.com/reference/android/text/Spannable.Factory.html) 成员对象的帮助下创建一个 `SpannableString`。所以，现在  `TextView` 持有的 `CharSequence` 副本有 **可变的标记和不可变的文字**。

为了更新 span，我们首先获取作为 `Spannable` 的文字，然后根据需要更新 span。

```
// 如果 setText 被以 BufferType.SPANNABLE 方式调用
textView.setText(spannable, BufferType.SPANNABLE)

// 文字可被转为 Spannable
val spannableText = textView.text as Spannable

// 现在我们可以设置或删除 span
spannableText.setSpan(
     ForegroundColorSpan(color), 
     8, spannableText.length, 
     SPAN_INCLUSIVE_INCLUSIVE)
```

通过这个选项，我们创建了初始的 `Spannable` 对象。`TextView` 将会持有它的一个副本，但当我们需要调整它时，我们不需要创建任何其它的对象，因为我们将直接操作 `TextView` 持有的 `Spannable` 文字实例。但是，`TextView` 将只会被通知 span 的 添加/删除/重排操作。如果你改变 span 的一个内部属性，你将需要调用 `invalidate()` 或 `requestLayout()`，这取决于改变的类型。你可以在下面的 “_额外的性能建议_” 中看到其中的细节。

### 3. 文字改变（复用 TextView）

假设我们想要复用 `TextView` 并且多次设置文本，就像在 `RecyclerView.ViewHolder` 中一样。默认情况下，和 `BufferType` 无关，`TextView` 创建一个`CharSequence` 对象的副本并将其储存在内存中。这确保所有 `TextView` 更新都是故意触发的，而不是用户由于其它原因修改 `CharSequence` 的值时不小心触发的。

在上面的选项 2 中，我们看到在通过 `textView.setText(spannableObject, BufferType.SPANNABLE)` 设置文字时，[`TextView.Spannable.Factory`](https://developer.android.com/reference/android/text/Spannable.Factory.html) 实例创建一个新的 `SpannableString`，从而复制 `CharSequence`。所以每当我们设置一个新的文本时，它就会创建一个新的对象。如果你想要更多地控制这个过程并避免额外的对象创建，就要实现你自己的 `Spannable.Factory`，重写 [newSpannable(CharSequence)](https://developer.android.com/reference/android/text/Spannable.Factory.html#newSpannable%28java.lang.CharSequence%29)，并把它设置给 `TextView`。

在我们自己的实现中，我们想要避免创建新的对象，所以我们只需要返回 `CharSequence` 并将其转为 `Spannable`。记住，为了实现这一点，你需要调用 `textView.setText(spannableObject, BufferType.SPANNABLE)`。否则，源 `CharSequence`将会是一个 `Spanned` 的实例，它不能被转为 `Spannable`，从而造成 `ClassCastException`。

```
val spannableFactory = object : Spannable.Factory() {
    override fun newSpannable(source: CharSequence?): Spannable {
        return source as Spannable
    }
}
```

在你获取 `TextView` 的引用之后，立即设置  **Spannable.Factory** 对象。如果你在使用 `RecyclerView`，在你首次创建你的 view 时这样做。

[textView.setSpannableFactory](https://developer.android.com/reference/android/widget/TextView.html#setSpannableFactory%28android.text.Spannable.Factory%29)(spannableFactory)

这样，你就可以防止每次 `RecyclerView` 把新的条目绑定到你的 `ViewHolder` 时创建额外的对象。

当你在使用文字和 `RecyclerViews` 时，为了获取更好的性能，不要根据 `ViewHolder` 中的 `String` 创建你的 `Spannable` 对象，要在 **你把列表传给 `Adapter` 之前**这样做。这允许你在后台线程中创建 `Spannable` 对象，并做完需要对列表元素做的所有操作。你的`Adapter` 可以持有对 `List<Spannable>` 的一个引用。

### 额外的性能建议

如果你只需要改变一个 span 的内部属性，在自定义的着重号 span 中改变其颜色），你不需要再次调用 `TextView.setText` ，而只需要调用 `invalidate()` 或 `requestLayout()` 即可。再次调用 `setText` 将会在只需要重新 draw 或 measure 时触发不必要的业务逻辑并创建不必要的对象。

你需要做的只是持有对可变 span 的一个引用，并且，取决于你改变了 view 的什么属性，调用：

*   `TextView.invalidate()` （如果你只是改变**文字外观**），以触发一次 **redraw** 并跳过 layout 过程。
*   `TextView.requestLayout()` （如果你改变**文字大小**），那么这个 view 就可以处理 **measure, layout 和 draw**。

假如你实现了自定义的着重号，其默认的颜色为红色。当你按下一个按钮时，你希望着重号的颜色变成灰色。你的实现如下所示：

```
class MainActivity : AppCompatActivity() {
    // keeping the span as a field
    val bulletSpan = BulletPointSpan(color = Color.RED)
    override fun onCreate(savedInstanceState: Bundle?) {
        …
        val spannable = SpannableString(“Text is spantastic”)
        // setting the span to the bulletSpan field
        spannable.setSpan(
            bulletSpan, 
            0, 4, 
            Spanned.SPAN_INCLUSIVE_INCLUSIVE)
        styledText.setText(spannable)
        button.setOnClickListener( {
            // change the color of our mutable span
            bulletSpan.color = Color.GRAY
            // color won’t be changed until invalidate is called
            styledText.invalidate()
        }
    }
```

### 底层：进程内和跨进程的 span 传递

**太长不看版**

在进程内和跨进程的 span 传递中，自定义 span 特性将不会被使用。如果想要的样式可以通过框架自带的 span 实现，**尽可能使用多个框架中的 span** 取代你自己的 span。否则，尽量在自定义 span 时实现一些基础的接口或抽象类。

在  Android 中，文字可以在进程内部（或跨进程）传递，例如在 Activity 间通过 Intent 传递，或当文字在 app 间传递时跨进程传递。

自定义 span 实现不能在进程之间传递，因为其它进程不了解它们，也不知道如何处理它们。Android 框架中的 span 是全局对象，但**只有继承了 `ParcelableSpan` 的才可以在进程内或跨进程传递**。这个功能允许框架定义的 span 的所有属性实现 parcel 和 unparcel。[`TextUtils.writeToParcel`](https://developer.android.com/reference/android/text/TextUtils.html#writeToParcel%28java.lang.CharSequence,%20android.os.Parcel,%20int%29) 方法负责把 span 信息保存在 `Parcel` 中。

例如，你可以在同进程中传递 span，或通过 intent 在 `Activity` 间传递：

```
// 使用文字和 span 启动 Activity
val intent = Intent(this, MainActivity::class.java)
intent.putExtra(TEXT_EXTRA, mySpannableString)
startActivity(intent)

// 读取带有 Span 的文字
val intentCharSequence = intent.getCharSequenceExtra(TEXT_EXTRA)
```

> 所以，哪怕你在同一个进程中传递 span，只有框架中的 `ParcelableSpan` 通过 Intent 传递之后还能存活。

`ParcelableSpan` 也允许你把文字和 span 一起跨进程传递。复制/粘贴文字通过 `ClipboardService` 实现，而它在底层使用同样的 `TextUtil.writeToParcel` 方法。所以，如果你在同一个 app 内部复制/粘贴 span，这将是一个跨进程行为，需要进行 parcel，因为文字需要经过 `ClipboardService`。

默认情况下，任何实现了 `Parcelable` 的类可以被写入 `Parcel` 和从 `Parcel` 中恢复。当跨进程传递 `Parcelable` 对象时，只有框架类可以保证被正确存取。 如果数据类型在不同 app 中定义，导致试图恢复数据的进程不能创建这个对象，进程将会崩溃。

有两个重要的警告：

1. 当带有 span 的文字被传递时，无论是在进程中还是跨进程，**只有 framework 的 `ParcelableSpan` 引用被保留**。这导致自定义 span 样式不能被传递。
2.  **你不能创建自己的** `ParcelableSpan`**。** 为了防止未知数据类型导致的崩溃，框架不允许实现自定义 `ParcelableSpan`。这是通过把[`getSpanTypeIdInternal`](https://github.com/aosp-mirror/platform_frameworks_base/blob/master/core/java/android/text/ParcelableSpan.java#L39) 和 [`writeToParcelInternal`](https://github.com/aosp-mirror/platform_frameworks_base/blob/master/core/java/android/text/ParcelableSpan.java#L47) 设置为隐藏方法实现的。它们都被 `TextUtils.writeToParcel` 使用。

假如你需要定义一个着重号 span，它可以自定义着重号的大小，因为现有的 `BulletSpan` 将半径规定为 4px。以下是实现它的方式，以及各种方式的后果：

1.  **创建一个继承了** `CustomBulletSpan` **的** `BulletSpan`，它允许为着重号设置大小。当 span 通过复制文字或在 Activity 间跳转而传递时，附着于文字的 span 将会是 `BulletSpan`。这意味着如果文字被绘制，它将具有框架的默认文字半径，而不是在 `CustomBulletSpan` 中设置的半径。

2.  **创建一个继承了** `LeadingMarginSpan` **的** `CustomBulletSpan` 并重新实现着重号功能。当 span 通过复制文字或在 Activity 间跳转而传递时，附着于文字的 span 将会是 `LeadingMarginSpan`。 这意味着如果文字被绘制，它将失去所有的样式。

如果想要的样式可以通过框架自带的 span 实现， 尽可能使用多个框架中的 span取代你自己的 span。否则，尽量在自定义 span 时实现一些基础的接口或抽象类。这样，你可以防止在进程内或跨进程传递时，框架的实现被应用到 spannable。

* * *

通过理解 Android 如何渲染带有 span 的文字，你将很有希望在你的 app 中高效地使用它。下次你需要给文字设置样式时，根据你将来需要怎样使用这些文字来决定是使用多个框架 span，还是实现自定义 span。

使用 Android 中的文本是一个常见的操作，调用正确的 `TextView.setText` 方法将有助于使你降低 app 的内存消耗，并提高其性能。

> **感谢** [Siyamed Sinir](https://twitter.com/siyamed)，Clara Bayarri 以及 [Nick Butcher](https://medium.com/@crafty)。

感谢 [Daniel Galpin](https://medium.com/@dagalpin?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
