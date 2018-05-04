> * 原文地址：[Underspanding spans](https://medium.com/google-developers/underspanding-spans-1b91008b97e4)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/underspanding-spans.md](https://github.com/xitu/gold-miner/blob/master/TODO1/underspanding-spans.md)
> * 译者：
> * 校对者：

# Underspanding spans

![](https://cdn-images-1.medium.com/max/2000/1*Te49GZFBFW3PP8fiWv9oQA.png)

Illustration by [Virginia Poltrack](https://twitter.com/VPoltrack)

Spans are powerful concepts that allow styling text at character or paragraph levels by providing access to components like TextPaint and Canvas. We talked about how to use Spans, what Spans are provided out of the box, how to easily create your own, and how to test them in a previous article.

* [**Spantastic text styling with Spans**: To style text in Android, use spans! Change the color of a few characters, make them clickable, scale the size of the… medium.com](https://medium.com/google-developers/spantastic-text-styling-with-spans-17b0c16b4568)

Let’s see what APIs can be used to ensure maximum performance for specific use cases when working with text. We’re going to explore more of what’s going on under the hood with spans and how the framework uses them. In the end, we’ll see how we can pass spans in the same process or in-between processes and, based on that, what kind of caveats you need to be aware of when deciding to create your own custom spans.

### Under the hood: how spans work

The Android framework handles text styling and work with spans in several classes: `[TextView](https://developer.android.com/reference/android/widget/TextView.html)`, `[EditText](https://developer.android.com/reference/android/widget/EditText.html)`, the layout classes (`[Layout](https://developer.android.com/reference/android/text/Layout.html)`, `[StaticLayout](https://developer.android.com/reference/android/text/StaticLayout.html)` , `[DynamicLayout](https://developer.android.com/reference/android/text/DynamicLayout.html)`) and `TextLine` (a package private class used in `Layout`) and it depends on several parameters:

*   Type of text: selectable, editable or non-selectable
*   `[BufferType](https://developer.android.com/reference/android/widget/TextView.BufferType.html)`
*   `TextView`’s `LayoutParams` type
*   etc

The framework checks whether the `Spanned` objects contain instances of different framework spans and triggers different actions.

The logic behind text layout and draw is complicated and spread throughout different classes; in this section we can present only a simplistic view of how text is handled and only for some cases.

Every time a span is changed, the `[TextView](https://github.com/aosp-mirror/platform_frameworks_base/blob/master/core/java/android/widget/TextView.java).spanChange` checks whether the span is an instance of `[UpdateAppearance](https://developer.android.com/reference/android/text/style/UpdateAppearance.html)`, `[ParagraphStyle](https://developer.android.com/reference/android/text/style/ParagraphStyle.html)` or `[CharacterStyle](https://developer.android.com/reference/android/text/style/CharacterStyle.html)` and, if yes, invalidates itself, triggering a new drawing of the view.

The `[TextLine](https://github.com/aosp-mirror/platform_frameworks_base/blob/master/core/java/android/text/TextLine.java)` class represents a line of styled text and it works specifically with spans that extend `CharacterStyle`, `[MetricAffectingSpan](https://developer.android.com/reference/android/text/style/MetricAffectingSpan.html)` and `[ReplacementSpan](https://developer.android.com/reference/android/text/style/ReplacementSpan.html)`. This is the class that triggers `[MetricAffectingSpan.updateMeasureState](https://developer.android.com/reference/android/text/style/MetricAffectingSpan.html#updateMeasureState%28android.text.TextPaint%29)` and `[CharacterStyle.updateDrawState](https://developer.android.com/reference/android/text/style/CharacterStyle.html#updateDrawState%28android.text.TextPaint%29)`.

The base class that manages text layout in visual elements on the screen is `[android.text.Layout](https://developer.android.com/reference/android/text/Layout.html)`. `Layout`, along with two of its subclasses, `[StaticLayout](https://developer.android.com/reference/android/text/StaticLayout.html)` and `[DynamicLayout](https://developer.android.com/reference/android/text/DynamicLayout.html)`, check the spans set on text to compute the line height and the layout margin. Apart from this, whenever a span displayed in a `[DynamicLayout](https://developer.android.com/reference/android/text/DynamicLayout.html)` is updated, the layout checks whether the span is a `UpdateLayout` span and generates a new layout for the affected text.

### Setting text for maximum performance

There are several memory-efficient ways of setting text in a `TextView`, depending on your needs.

### 1. Text set on a `TextView` never changes

If you just set the text on a TextView once and never update it, you can just create a new instance of `SpannableString` or `SpannableStringBuilder`, set the needed spans and then call `[textView.setText(spannable)](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence%29)`. Since you’re not working with the text anymore, there’s no more performance to be improved.

### 2. Text style changes by adding/removing spans

Let’s consider the case where the text doesn’t change, but the spans attached to it do. For example, let’s say that whenever a button is clicked, you want a word from the text to become grey. So, we need to add a new span to the text. To do this, most likely you’ll be tempted to call `[textView.setText(CharSequence)](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence%29)` two times: first to set the initial text and then again when the button is clicked. A more optimal solution would be to call `[textView.setText(CharSequence, BufferType)](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence,%20android.widget.TextView.BufferType%29)` and just update the spans of a `Spannable` object when the button is clicked.

Here’s what’s going on under the hood with each of these options:

**Option 1: Calling** [**textView.setText(CharSequence)**](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence%29) **multiple times — suboptimal**

When calling `[textView.setText(CharSequence)](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence%29)`, under the hood `TextView` creates a copy of your `Spannable` as a `SpannedString` and keeps it in memory as a`CharSequence`. The consequence of this is that your **text and the spans are immutable**. So, when you need to update the text style, you will have to create a new `Spannable`, with text and spans, call `textView.setText` again, which, in turn, will create a new copy of the object.

**Option 2: Calling** [**textView.setText(CharSequence, BufferType)**](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence,%20android.widget.TextView.BufferType%29) **once and updating a Spannable object — optimal**

When calling `[textView.setText(CharSequence, BufferType)](https://developer.android.com/reference/android/widget/TextView.html#setText%28java.lang.CharSequence,%20android.widget.TextView.BufferType%29)`, the `BufferType` parameter tells the `TextView` what type of text is set: static (the default type when calling `textView.setText(CharSequence)`), styleable / spannable text or editable (which would be used by `EditText`).

Since we’re working with text that can be styled, we can call:

```
textView.setText(spannableObject, BufferType.SPANNABLE)
```

In this case, `TextView` doesn’t create a `SpannedString` anymore, but it will create a `SpannableString`, with the help of a member object of type `[Spannable.Factory](https://developer.android.com/reference/android/text/Spannable.Factory.html)`. Therefore now, the `CharSequence` copy kept by the `TextView` has **mutable markup and immutable text**.

To update the span we first get the text as `Spannable` and then update the spans as needed.

```
// if setText was called with BufferType.SPANNABLE
textView.setText(spannable, BufferType.SPANNABLE)

// the text can be cast to Spannable
val spannableText = textView.text as Spannable

// now we can set or remove spans
spannableText.setSpan(
     ForegroundColorSpan(color), 
     8, spannableText.length, 
     SPAN_INCLUSIVE_INCLUSIVE)
```

With this option, we only create the initial `Spannable` object. `TextView` will hold a copy of it, but when we need to modify it, we don’t need to create any other objects because we will be working directly with the instance of the `Spannable` text kept by `TextView`. However, `TextView` will be informed only about the adding/removing/repositioning of the spans. If you change an internal attribute of the span, you’ll have to call either `invalidate()` or `requestLayout()`, depending on the type of the change. See details in the “_Bonus performance tip_” below.

### 3. Text changes (reusing TextView)

Let’s say that we want to reuse a `TextView` and set the text multiple times, like in a `RecyclerView.ViewHolder`. By default, independent of the `BufferType` set, `TextView` creates a copy of the `CharSequence` object and holds it in memory. This ensures that all `TextView` updates are deliberate, and not by accident, when the developer changes the `CharSequence` value for other reasons.

In the Option 2 above, we saw that when setting the text via `textView.setText(spannableObject, BufferType.SPANNABLE)`, the `TextView` copies the `CharSequence` by creating a new `SpannableString` using a `[Spannable.Factory](https://developer.android.com/reference/android/text/Spannable.Factory.html)` instance. So every time we set a new text, it will create a new object. If you’d like to take more control over this process and avoid the extra object creation implement your own `Spannable.Factory`, override [newSpannable(CharSequence)](https://developer.android.com/reference/android/text/Spannable.Factory.html#newSpannable%28java.lang.CharSequence%29), and set the factory to the `TextView`.

In our own implementation, we want to avoid that new object creation, so we can just return the `CharSequence` cast as a `Spannable`. Keep in mind that in order to do this, you have to call `textView.setText(spannableObject, BufferType.SPANNABLE)` otherwise, the source `CharSequence` will be an instance of `Spanned` which cannot be cast to `Spannable`, resulting in a `ClassCastException`.

```
val spannableFactory = object : Spannable.Factory() {
    override fun newSpannable(source: CharSequence?): Spannable {
        return source as Spannable
    }
}
```

Set the **Spannable.Factory** object once right after you get a reference to your `TextView`. If you’re using a `RecyclerView`, do this when you first inflate your views.

```
[textView.setSpannableFactory](https://developer.android.com/reference/android/widget/TextView.html#setSpannableFactory%28android.text.Spannable.Factory%29)(spannableFactory)
```

With this, you’re avoiding extra object creation every time your `RecyclerView` binds a new item to your `ViewHolder`.

To get even more performance when working with text and `RecyclerViews`, instead of creating your `Spannable` object from the `String` in the `ViewHolder`, do that **before you pass your list to the** `**Adapter**`. This allows you to construct the `Spannable` objects on a background thread, together with any other work you do with your list elements. Your `Adapter` can then keep a reference to a `List<Spannable>`.

### Bonus performance tip

If you only need to change an internal attribute of a span (for example, the bullet color for a custom bullet span), you don’t need to call `TextView.setText` again, but just `invalidate()` or `requestLayout()`. Calling `setText` again would lead to unnecessary logic being triggered and objects being created, when the view needs to just either redraw or remeasure.

What you need to do is keep a reference to your mutable span and, depending on what kind of property you changed in the view, call:

*   `**TextView.invalidate()**` if you’re just changing **text appearance**, to trigger a **redraw** and skip redoing layout.
*   `**TextView.requestLayout()**` if you made a change that **affects the size** of the text, so the view can can take care of **measuring, laying out and drawing**.

Let’s say that you have your custom bullet point implementation, where the default bullet point color is red. Whenever you press a button, you want to change the color of the bullet point to grey. The implementation would look like this:

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

### Under the hood: passing text with spans intra and inter-process

_TL;DR:_

_Custom span attributes will not be used when Spanned objects are passed intra or inter-process. If the desired styling can be achieved just with the framework spans,_ **_prefer applying multiple framework spans_** _to implementing your own spans. Otherwise, prefer implementing custom spans that extend some of the base interfaces or abstract classes._

In Android, text can be passed in the same process (intra-process), for example from one Activity to another via Intents, and between processes (inter-process) when text is copied from one app to another.

Custom span implementations can’t pass across process boundaries, since other processes don’t know about them and wouldn’t know how to handle them. Android framework spans are global objects but **only the spans that extend from** `**ParcelableSpan**` **can be passed intra and inter process.** This functionality allows parceling and un-parcelling of all the properties of the span defined in the framework. `[TextUtils.writeToParcel](https://developer.android.com/reference/android/text/TextUtils.html#writeToParcel%28java.lang.CharSequence,%20android.os.Parcel,%20int%29)` method is in charge of saving the spans information in the `Parcel`.

For example, you can pass Spans in the same process, between `Activities` via an intent:

```
// start Activity with text with spans
val intent = Intent(this, MainActivity::class.java)
intent.putExtra(TEXT_EXTRA, mySpannableString)
startActivity(intent)

// read text with Spans
val intentCharSequence = intent.getCharSequenceExtra(TEXT_EXTRA)
```

> So, even if you’re passing spans in the same process, only framework `ParcelableSpans` survive passing via the Intent.

`ParcelableSpans` also allow copying text together with spans from one process to another. The process of copying and pasting text goes through the `ClipboardService` which, under the hood, uses the same `TextUtil.writeToParcel` method. So, even if you’re copying spans from your app and pasting them in the same app, this is an inter-process action and requires parceling because the text goes through `ClipboardService`.

By default, any class that implements `Parcelable` can be written and restored from a `Parcel`. When passing an `Parcelable` object between processes, the only classes that are guaranteed to be restored correctly are framework classes. If the process that tries to restore the data from a `Parcel` can’t construct the object because the data type is defined in a different app, then the process will crash.

There are two big caveats here:

1.  When text with span is passed, either in the same process or between processes, **only framework’s** `**ParcelableSpans**` **references are kept**. As a consequence, custom spans styling is not propagated.
2.  **You can’t create your own** `**ParcelableSpan**`**.** To avoid crashes due to unknown data types, the framework doesn’t allow implementing custom `ParcelableSpan`, by defining two methods, `[getSpanTypeIdInternal](https://github.com/aosp-mirror/platform_frameworks_base/blob/master/core/java/android/text/ParcelableSpan.java#L39)` and `[writeToParcelInternal](https://github.com/aosp-mirror/platform_frameworks_base/blob/master/core/java/android/text/ParcelableSpan.java#L47)`, as hidden. Both of them are used by `TextUtils.writeToParcel`.

Let’s say that you want to define a bullet point span that allows custom size for the bullet since the existing `BulletSpan` defines a fixed radius size of 4px. Here’s how you can implement it and what the consequences of each way are:

1.  **Create a** `**CustomBulletSpan**` **that extends** `**BulletSpan**` but also allows setting a parameter for the bullet size. When the span is passed either from one Activity to the other or by copying the text, the span attached to the text will be `**BulletSpan**`. This means that when the text is drawn, it will have the framework’s default bullet radius, not the one set in `CustomBulletSpan`.
2.  **Create a** `**CustomBulletSpan**` **that just extends from** `**LeadingMarginSpan**` and re-implements the bullet point functionality. When the span is passed either from one `Activity` to the other or by copying the text, the span attached to the text will be `LeadingMarginSpan`. This means that when the text is drawn, it will lose all styling.

If the desired styling can be achieved just with the framework spans, prefer applying multiple framework spans to implementing your own. Otherwise, prefer implementing custom spans that extend some of the base interfaces or abstract classes. Like this, you can avoid the framework’s implementation being applied to the spannable, when the object is passed intra- or inter-process.

* * *

By understanding how Android renders text with spans, hopefully you can use it effectively and efficiently in your app. Next time you need to style text, decide whether you should apply multiple framework spans or create your own custom span, depending on the further work you’re doing with that text.

Working with text in Android is such a common task that calling the right `TextView.setText` method can help you decrease the memory usage of your app and increase its performance.

> _Lots of thanks to_ [_Siyamed Sinir_](https://twitter.com/siyamed)_, Clara Bayarri and_ [_Nick Butcher_](https://medium.com/@crafty)_._

Thanks to [Daniel Galpin](https://medium.com/@dagalpin?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
