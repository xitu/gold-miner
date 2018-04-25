> * 原文地址：[Building Type Mode for Stories on iOS and Android](https://instagram-engineering.com/building-type-mode-for-stories-on-ios-and-android-8804e927feba)
> * 原文作者：[Instagram Engineering](https://instagram-engineering.com/@InstagramEng?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-type-mode-for-stories-on-ios-and-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-type-mode-for-stories-on-ios-and-android.md)
> * 译者：[金西西](https://github.com/melon8)
> * 校对者：

# 快拍中 Type Mode 在 iOS 和 Android 上的实现

Instagram 最近推出了 [Type Mode](https://instagram-press.com/blog/2018/02/01/introducing-type-mode-in-stories/)，这是一种在快拍上发布有创意的、动态的文本样式和背景的帖子的新方式。 Type Mode 对我们来说是一个有趣的挑战，因为这是我们的一次创新：让人们在在没有照片或视频辅助的情况下在快拍上分享 —— 我们希望确保 Type Mode 仍然是一种有趣、可定制且具有视觉表现力的体验。

在 iOS 和 Android 上无缝地实现 Type Mode 功能有各自相应的一系列挑战，包括动态调整文本大小和自定义填充背景。在这篇文章中，将看到我们如何在 iOS 和 Android 平台上实现这项工作。

![](https://cdn-images-1.medium.com/max/800/1*B_eL2GjOQGhd_OxC3nEXKA.jpeg)

#### 动态调整文本输入的大小

在 Type Mode 下，我们想要创建一个让人们可以强调特定的单词或短语的文本输入体验。一种方法是构建两端对齐的文本样式，动态调整每一行的大小，以填充既定的宽度（在 Instgram 的现代、霓虹和粗体中使用)。

**iOS**

iOS 的主要挑战是在原生的 `UITextView` 中渲染可以动态改变大小的文本，这让用户得以快速熟悉的方式输入文本。

**在存储文本前调整文字大小**

当你输入一行文本的时候，文字大小应该随着输入而相应缩小，直到达到最小字体。

![](https://cdn-images-1.medium.com/max/800/1*Chw3Adea66Me49A2wPGR-g.gif)

为了实现这个需求，我们结合了 `UITextView.typingAttributes`, `NSAttributedString`, 和  `NSLayoutManager`。

首先，我们需要计算我们的文本将呈现什么样的字体和大小。我们可以使用  `[NSLayoutManager enumerateLineFragmentsForGlyphRange:usingBlock:]` 来抓取当前输入的那行文字的范围。根据这个范围，我们可以创建一个带有尺寸的字符串来计算最小字体大小。

```objc
CGFloat pointSize = 24.0; // 随意
NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:pointSize]}];
CGFloat textWidth = CGRectGetWidth([attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NULL context:nil]);
CGFloat scaleFactor = (textViewContainerWidth / textWidth);
CGFloat preferredFontSize = (pointSize * scaleFactor);
return CLAMP_MIN_MAX(preferredFontSize, minimumFontSize, maximumFontSize) // 将字体固定住，在最大值最小值之间
```

为了能以正确的大小绘制文本，我们需要在我们的 `UITextView` 的 `typingAttributes` 中使用我们新的字体大小。  `UITextView.typingAttributes` 是适用于用户正在输入的新文本的属性。一个合适的位置是 `[id <UITextViewDelegate> textView：shouldChangeTextInRange：replacementText：]` 方法。

```
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableDictionary *typingAttributes = [textView.typingAttributes mutableCopy];
    typingAttributes[NSFontAttributeName] = [UIFont fontWithDescriptor:fontDescriptor size:calculatedFontSize];
    textView.typingAttributes = typingAttributes;
    return YES;
}
```

这意味着，随着用户输入，字体大小将缩小，直到达到某个指定的最小值。这时 `UITextView` 会像通常那样包着我们的文本。

**在存储文本后整理文字**

在我们的文本被提交到文本存储后，我们可能需要清理一些尺寸属性。我们的文本可能已经换行，或者用户可以通过手动添加换行符，在单独的行上写入更大的文字来「强调」。

![](https://cdn-images-1.medium.com/max/800/1*DNzHUA7Mo_yYSA4kCnk7TA.png)

放置这个逻辑的好地方是 `[id <UITextViewDelegate> textViewDidChange：]` 方法。这发生在文本被提交到文本存储，并且最初由文本引擎排版之后。

要获得每行的字符范围的列表，我们可以使用 `NSLayoutManager`：

```objc
NSMutableArray<NSValue *> *lineRanges = [NSMutableArray array];
[textView.layoutManager enumerateLineFragmentsForGlyphRange:NSMakeRange(0, layoutManager.numberOfGlyphs) usingBlock:^(CGRect rect, CGRect usedRect, NSTextContainer * _Nonnull textContainer, NSRange glyphRange, BOOL * _Nonnull stop) {
    NSRange characterRange = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
    [lineRanges addObject:[NSValue valueWithRange:characterRange]];
}];
```

然后，我们需要通过在每行具有正确字体大小的范围上设置属性来操作 `NSTextStorage`。

编辑 `NSTextStorage` 有三个步骤，它本身就是 `NSMutableAttributedString` 的子类。

1. 调用 `[textStorage beginEditing]` 来表示我们正在对文本存储进行一次或多次更改。
2. 发送一些编辑信息到 `NSTextStorage`。在我们的例子中，`NSFontAttributeName` 属性应该设置为对应行的正确字体大小。我们可以使用类似的方法来计算字体大小，就像我们之前做的那样。

```objc
for (NSValue *lineRangeValue in lineRanges) {
    NSRange lineRange = lineRangeValue.rangeValue;
    const CGFloat fontSize = ... // 与上文相同的字体大小计算方法
    [textStorage setAttributes:@{NSFontAttributeName : [UIFont fontWithDescriptor:fontDescriptor size:fontSize]} range:lineRange];
}
```

3.调用 `[textStorage endEditing]` 来表示我们结束编辑文本存储。这会调用 `[NSTextStorage processEditing]` 方法，该方法将修复我们改变的范围内文本的属性。这也会调用正确的 `NSTextStorageDelegate` 方法。

TextKit 是一个功能强大且现代化的 API，与 UIKit 紧密集成。许多文字体验都可以用它来设计，并且几乎每次 iOS 新版本也会发布一些新的文本 API。使用 TextKit 你可以做任何事情，从创建自定义文本容器到修改实际生成的字形。而且由于它是建立在 CoreText 之上的，并且与 UITextView 等 API 集成，所以文本输入和编辑仍然感觉像 iOS 原生体验。

#### Android

Android 没有开箱即用的两端对齐的方法，但框架的 API 为我们提供了自己实现所需的全部工具。

第一步是将文本用最小文本大小布局出来。稍后我们会扩展它，但是这会告诉我们有多少行和断行的位置：

```java
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

接下来，我们需要浏览布局并分别调整每行文字的大小。没有直接的方法可以完美地得到某行文字的大小，但是我们可以通过二进制搜索来轻松估算出最大文字大小，而不会造成强制换行：

```java
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

一旦我们为每行文字找到合适的尺寸，我们将它应用到一个 span 上（😱？？？？）。span 让我们为每行使用不同的文本大小，而不是整个字符串的单个文本大小：

```java
text.setSpan(
    new AbsoluteSizeSpan(textSize),
    layout.getLineStart(lineNumber),
    layout.getLineEnd(lineNumber),
    Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
```

现在，每行文本都会填充可用宽度！每次文本更改的时候，我们都可以重复此过程来得到我们正在寻找的动态调整大小行为（😱？？）。

![](https://cdn-images-1.medium.com/max/800/1*zVc-ioRas9b8TRmhrESIHg.png)

### 自定义背景

我们还希望使用 Type Mode 让人们带通过文字的背景来强调单词和短语（用于打字机字体和 Strong 字体）。

#### iOS

我们可以利用 `NSLayoutManager` 的另一种方式是绘制自定义背景填充。`NSAttributedString` 虽然可以用 `NSBackgroundColorAttributeName` 属性设置背景颜色，但它不可自定义，也不可扩展。

![](https://cdn-images-1.medium.com/max/800/1*0oPlID5rtrmqtHRUZdbIkQ.png)

例如如果我们使用了 `NSBackgroundColorAttributeName`，整个文本视图的背景将被填充。我们不能排除空格、让行之间留有空隙，或者让填充的背景是圆角。 谢天谢地，`NSLayoutManager` 给了我们重写绘制背景填充的方法。 我们需要创建一个 `NSLayoutManager` 子类并重写`drawBackgroundForGlyphRange:atPoint:`

```objc
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

通过 `drawBackgroundForGlyphRange：atPoint` 方法，我们可以再次利用 `[NSLayoutManager enumerateLineFragmentsForGlyphRange：usingBlock]` 来获取每一行片段的字形范围。 然后我们可以使用 `[NSLayoutManager boundingRectForGlyphRange:inTextContainer]` 来获得每一行的边界矩形。

```objc
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

这让我们可以用我们指定的形状和间距在任意文本绘制背景填充。`NSLayoutManager` 也可以用来绘制其他文本属性，如删除线和下划线。

**Android**

乍看之下，感觉这在 Android 上 应该很容易实现。 我们可以添加一个 span 来修改文本背景颜色：

```java
new CharacterStyle() {
  @Override
  public void updateDrawState(TextPaint textPaint) {
    textPaint.bgColor = color;
  }
}
```

这是一个很好的第一次尝试（也是我们构建的第一件事），但它有一些限制：

1.背景紧紧包裹着文字，无法调整间距。
2.背景是矩形的，无法调整圆角。

![](https://cdn-images-1.medium.com/max/800/1*o6uBmTEniyyrNh5qWgCv_Q.png)

为了解决这些问题，我们尝试使用 `LineBackgroundSpan`。 我们已经使用它在来在经典字体中渲染圆形的气泡背景，所以它自然也应该适用于新的文本样式。 不幸的是，我们的新用例在 `Layout` 框架类中发现了一个微妙的 bug。 如果你的文本在不同的行上有多个 `LineBackgroundSpan` 实例，那么 `Layout` 不会正确地遍历它们，其中一些可能永远不会被渲染。

庆幸的是，我们可以通过对整个字符串应用单个 `LineBackgroundSpan` 来回避框架错误，然后我们自己代理给每一个背景 span：

```java
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

#### 结论

Instagram 拥有非常强大的原型设计文化，而设计团队的 Type Mode 原型让我们在每次迭代中都能感受到真实的用户体验。 例如，对于霓虹灯样式，我们需要一种方法从调色板中获取单一颜色，然后为文本生成内部颜色和发光颜色。 这个项目的设计师在他的原型中使用了一些方法，当他找到一个他喜欢的东西时，我们基本上只是在 Android 和 iOS 上复制他的逻辑。 与设计团队的这种级别的合作是此次推出的一个特殊部分，并使开发流程非常高效。

如果你有兴趣与我们在 Story 中合作，请查看我们的[职业页面](https://m.facebook.com/careers/teams/instagram/)，了解位于 Menlo Park，纽约和旧金山的职位。

Christopher Wendel 和 Patrick Theisen 分别是 Instagram 的 iOS 和 Android 工程师。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
