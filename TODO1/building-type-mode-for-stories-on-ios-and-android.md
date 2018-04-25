> * 原文地址：[Building Type Mode for Stories on iOS and Android](https://instagram-engineering.com/building-type-mode-for-stories-on-ios-and-android-8804e927feba)
> * 原文作者：[Instagram Engineering](https://instagram-engineering.com/@InstagramEng?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-type-mode-for-stories-on-ios-and-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-type-mode-for-stories-on-ios-and-android.md)
> * 译者：
> * 校对者：

# Building Type Mode for Stories on iOS and Android

Instagram recently launched [Type Mode](https://instagram-press.com/blog/2018/02/01/introducing-type-mode-in-stories/), a new way to post creative, dynamic text styles and backgrounds to Stories. Type Mode was an interesting challenge for us because it is the first time we were going to create a way for people to post Stories without photo or video components — and we wanted to make sure Type Mode was still a fun, customizable and visually expressive experience.

Making Type Mode function seamlessly on both iOS and Android had its own set of challenges, including dynamically resizing text and custom background fills. In this post we’ll take a look at how we approached this work on both iOS and Android platforms.

![](https://cdn-images-1.medium.com/max/800/1*B_eL2GjOQGhd_OxC3nEXKA.jpeg)

#### Dynamically Resizing Text Input

With Type Mode, we wanted to create a text input experience that let people emphasize certain words or phrases. One way to do that was to build fully justified text styles that dynamically resize each line to fill the available width (used in Modern, Neon, and Strong).

**iOS**

The main challenge on iOS was to render dynamically resizing text in a native `UITextView,` which would let people enter text in a quick and familiar way.

**RESIZING PRE-TEXT STORAGE COMMIT**

While you input text on a line, the size of text on that line should scale down until it hits some minimum font size.

![](https://cdn-images-1.medium.com/max/800/1*Chw3Adea66Me49A2wPGR-g.gif)

To accomplish this, we use a combination of `UITextView.typingAttributes`, `NSAttributedString`, and `NSLayoutManager`.

First, we need to calculate what font size our text will be rendered as. We can grab the range of the line we are currently typing on using `[NSLayoutManager enumerateLineFragmentsForGlyphRange:usingBlock:]`. From that range we can create a sizing string to calculate a minimum font size.

```
CGFloat pointSize = 24.0; // arbitrary
NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:pointSize]}];
CGFloat textWidth = CGRectGetWidth([attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NULL context:nil]);
CGFloat scaleFactor = (textViewContainerWidth / textWidth);
CGFloat preferredFontSize = (pointSize * scaleFactor);
return CLAMP_MIN_MAX(preferredFontSize, minimumFontSize, maximumFontSize) // Clamps value between min and max
```

In order to actually draw the text at the correct size, we need to use our new font size in our `UITextView`'s `typingAttributes`. `UITextView.typingAttributes` are attributes that apply to new text being typed by the user. A good place for this is `[id<UITextViewDelegate> textView:shouldChangeTextInRange:replacementText:]`.

```
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableDictionary *typingAttributes = [textView.typingAttributes mutableCopy];
    typingAttributes[NSFontAttributeName] = [UIFont fontWithDescriptor:fontDescriptor size:calculatedFontSize];
    textView.typingAttributes = typingAttributes;
    return YES;
}
```

This means that as the user types, the font size will shrink until we hit some specified minimum. When this happens, the `UITextView` will wrap our text as it normally would.

**FINALIZE TEXT POST STORAGE COMMIT**

After our text has been committed to text storage, we may need to clean up some sizing attributes. Our text could have wrapped, or the user could have “emphasized” text by manually adding a line break to write larger text on a separate line.

![](https://cdn-images-1.medium.com/max/800/1*DNzHUA7Mo_yYSA4kCnk7TA.png)

A good place to put this logic is in `[id<UITextViewDelegate> textViewDidChange:]`. This happens after the text has been committed to text storage and initially laid out by the text engine.

To get a list of character ranges for each line, we can use `NSLayoutManager`:

```
NSMutableArray<NSValue *> *lineRanges = [NSMutableArray array];
[textView.layoutManager enumerateLineFragmentsForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs) usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRange, BOOL * _Nonnull stop) {
    NSRange characterRange = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
    [lineRanges addObject:[NSValue valueWithRange:characterRange]];
}];
```

We then need to manipulate the `NSTextStorage` by setting attributes on ranges that have the correct font size for each row.

There are three stages to editing `NSTextStorage`, which is itself a subclass of `NSMutableAttributedString`.

1. Call `[textStorage beginEditing]` to indicate we are making one or more changes to the text storage.
2. Send some editing messages to `NSTextStorage`. In our case, the `NSFontAttributeName` attribute should be set with the correct font size for that row. We can use a similar method for calculating the font size as we did earlier.

```
for (NSValue *lineRangeValue in lineRanges) {
    NSRange lineRange = lineRangeValue.rangeValue;
    const CGFloat fontSize = ... // Same font size calculation from earlier
    [textStorage setAttributes:@{NSFontAttributeName : [UIFont fontWithDescriptor:fontDescriptor size:fontSize]} range:lineRange];
}
```

3. Call `[textStorage endEditing]` to indicate we are done editing text storage. This invokes the `[NSTextStorage processEditing]` method which will fix attributes on the ranges we changed. This also invokes the correct `NSTextStorageDelegate` methods.

TextKit is a powerful and modern API that is tightly integrated with UIKit. Many text experiences can be designed with it, and new text APIs are being released in most new iOS versions. With TextKit, you can do anything from creating custom text containers to modifying the actual generation of glyphs. And since it is built on top of CoreText and integrated with APIs like UITextView, text input and editing continues to feel like a native iOS experience.

#### Android

Android doesn’t support full width justification out of the box, but the framework APIs give us all the tools we need to implement it ourselves.

The first step is to lay the text out at the minimum text size. We’ll scale things up later, but this will tell us how many lines we have and where the line breaks are:

```
TextPaint textPaint = new TextPaint();
textPaint.setTextSize(SIZE_MIN);
Layout layout =
    new StaticLayout(
        text,
        textPaint,
        availableWidth,
        Layout.Alignment.ALIGN_CENTER,
        1 /* spacingMult */,
        0 /* spacingAdd */,
        true /*includePad */);
int lineCount = layout.getLineCount();
```

![](https://cdn-images-1.medium.com/max/800/1*rKHCLpYSf-VZ_2yhyqzZCQ.png)

Next we need to go through the layout and resize each line individually. There’s no direct way to find the perfect text size for a particular line, but we can easily approximate it with a binary search for the largest text size that doesn’t force a line break:

```
int lowSize = SIZE_MIN;
int highSize = SIZE_MAX;
int currentSize = lowSize + (int) Math.floor((highSize - lowSize) / 2f);
while (low < current) {
  if (hasLineBreak(text, currentSize)) {
    highSize = currentSize;
  } else {
    lowSize = currentSize;
  }
  currentSize = lowSize + (int) Math.floor((highSize - lowSize) / 2f);
}
```

Once we’ve found the right size for each line, we apply it as a span. Spans let us use different text sizes for each line instead of a single text size for the entire string:

```
text.setSpan(
    new AbsoluteSizeSpan(textSize),
    layout.getLineStart(lineNumber),
    layout.getLineEnd(lineNumber),
    Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
```

Now each line of text fills the available width! We can repeat this process each time the text changes to get the dynamic resizing behavior we’re looking for.

![](https://cdn-images-1.medium.com/max/800/1*zVc-ioRas9b8TRmhrESIHg.png)

### Custom Backgrounds

We also wanted Type Mode to let people emphasize words and phrases with text backgrounds (used in Typewriter and Strong).

#### iOS

Another way we can leverage `NSLayoutManager` is for drawing custom background fills. `NSAttributedString` does have a `NSBackgroundColorAttributeName`, but it is not customizable nor extensible.

![](https://cdn-images-1.medium.com/max/800/1*0oPlID5rtrmqtHRUZdbIkQ.png)

For example, if we used `NSBackgroundColorAttributeName`, the background of the entire text view would be filled in. We could not exclude whitespace, have spaces between the lines, or draw the fill with a corner radius. Thankfully, `NSLayoutManager` lets us override drawing the background fill. We need to create a `NSLayoutManager` subclass and override `drawBackgroundForGlyphRange:atPoint:`

```
@interface IGSomeCustomLayoutManager : NSLayoutManager
@end 
@implementation IGSomeCustomLayoutManager
- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin {
    // Draw custom background fill
    [super drawBackgroundForGlyphRange:glyphsToShow atPoint:origin];
}
    
}];
@end
```

With our `drawBackgroundForGlyphRange:atPoint` method, we can once again leverage `[NSLayoutManager enumerateLineFragmentsForGlyphRange:usingBlock]` to grab the glyph ranges of each line fragment. We can then use `[NSLayoutManager boundingRectForGlyphRange:inTextContainer]` to get the bounding rectangle of each line.

```
- (void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin {
  [self enumerateLineFragmentsForGlyphRange:NSMakeRange(0, self.numberOfGlyphs) usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRange, BOOL * _Nonnull stop) {
       CGRect lineBoundingRect = [self boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
       CGRect adjustedLineRect = CGRectOffset(lineBoundingRect, origin.x + kSomePadding, origin.y + kSomePadding);
       UIBezierPath *fillColorPath = [UIBezierPath bezierPathWithRoundedRect:adjustedLineRect cornerRadius:kSomeCornerRadius];
       [[UIColor redColor] setFill];
       [fillColorPath fill];
  }];
}
```

This allows us to draw a background fill around any arbitrary text with our own specified shapes and padding. `NSLayoutManager` can also be utilized to draw other text attributes like strikethroughs and underlines.

**Android**

At first glance, it feels like this should be simple to implement on Android. We can add a span that modifies the text background color and be done:

```
new CharacterStyle() {
  @Override
  public void updateDrawState(TextPaint textPaint) {
    textPaint.bgColor = color;
  }
}
```

That’s a good first attempt (and was the first thing we built), but it comes with a few limitations:

1.  The background tightly wraps the text and there’s no way to adjust the padding.
2.  The background is rectangular and there’s no way to adjust the corner radius.

![](https://cdn-images-1.medium.com/max/800/1*o6uBmTEniyyrNh5qWgCv_Q.png)

To address those issues, we tried using `LineBackgroundSpan`. We were already using it to render the rounded bubble background on Classic text, so it seemed like a natural fit for the new text styles as well. Unfortunately our new use case uncovered a subtle bug in the framework `Layout` class. If your text has multiple `LineBackgroundSpan` instances on different lines, then `Layout` will not iterate through them properly and some of them may never be rendered.

Thankfully we can sidestep the framework bug by applying a single `LineBackgroundSpan` to the entire string and then delegating to individual background spans ourselves:

```
class BackgroundCoordinator implements LineBackgroundSpan {
  @Override
  public void drawBackground(
      Canvas canvas,
      Paint paint,
      int left,
      int right,
      int top,
      int baseline,
      int bottom,
      CharSequence text,
      int start,
      int end,
      int currentLine) {
    Spanned spanned = (Spanned) text;
    for (BackgroundSpan span : spanned.getSpans(start, end, BackgroundSpan.class)) {
      span.draw(canvas, spanned);
    }
  }
}

class BackgroundSpan {
  public void draw(Canvas canvas, Spanned spanned) {
    // Custom background rendering...
  }
}
```

![](https://cdn-images-1.medium.com/max/800/1*J3cTb7oZpyE4jukQi0_mfA.png)

#### Conclusion

Instagram has a very strong prototyping culture, and the design team’s Type Mode prototypes let us get a real feel for the user experience with each iteration along the way. For example, with the Neon style, we needed a way to take a single color from our palette and then generate an interior color and a glow color for the text. A designer on the project played around with some approaches in his prototype, and when he found one he liked we essentially just copied his logic on Android and iOS. This level of collaboration with the design team was a special part of this launch and made the development process really efficient.

If you’re interested in working with us on Stories, check out our [careers page](https://m.facebook.com/careers/teams/instagram/) for roles in Menlo Park, New York, and San Francisco.

Christopher Wendel and Patrick Theisen are iOS and Android engineers at Instagram, respectively.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
