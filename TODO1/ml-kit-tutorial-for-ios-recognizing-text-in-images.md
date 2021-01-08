> * 原文地址：[ML Kit Tutorial for iOS: Recognizing Text in Images](https://www.raywenderlich.com/6565-ml-kit-tutorial-for-ios-recognizing-text-in-images)
> * 原文作者：[By David East](https://www.raywenderlich.com/u/deast)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ml-kit-tutorial-for-ios-recognizing-text-in-images.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ml-kit-tutorial-for-ios-recognizing-text-in-images.md)
> * 译者：[portandbridge](https://github.com/portandbridge)
> * 校对者：[Lobster-King](https://github.com/Lobster-King)，[iWeslie](https://github.com/iWeslie)

# 用于 iOS 的 ML Kit 教程：识别图像中的文字

在这篇 ML Kit 教程里面，你会学习如何使用 Google 的 ML Kit 进行文字检测和识别。

几年前，机器学习开发者分成两类：高级开发者是一类，其余的人则是另一类。机器学习的底层部分有可能很难，因为它涉及很多数学知识，还用到**逻辑回归（logistic regression）、稀疏性（sparsity）和神经网络（neural nets）**这样的艰深字眼。不过，也不是一定要搞得那么难的。

你也可以成为机器学习开发者的！就其核心而言，机器学习并不难。应用机器学习时，你是通过教软件模型发现规律来解决问题，而不是将你能想到的每种情况都硬编码到模型里面。然而，一开始做的时候有可能会让人却步，而这正是你可以运用现有工具的时机。

#### 机器学习与工具配套（Tooling）

和 iOS 开发一样，机器学习与工具配套息息相关。你不会自己搭建一个 UITableView，或者说，至少你不应该那么做；你会用一个框架，比如 UIKit。

机器学习也是一样的道理。机器学习有一个正蓬勃发展的工具配套生态系统。举个例子，**Tensorflow** 可以简化训练及运行模型的过程。**TensorFlow Lite** 则可以给 iOS 和 Android 设备带来对模型的支持。

这些工具用起来全都需要一定的机器学习方面的经验。假如你不是机器学习的专家，但又想解决某个具体问题，该怎么办呢？这时候你就可以用 **ML Kit**。

### ML Kit

ML Kit 是个移动端的 SDK，可以将 Google 强大的机器学习技术带到你的 App 中。ML Kit 的 API 有两大部分，可以用于普通使用场景和自定义模型；而不管使用者的经验如何，它们用起来都不难。

[![ML Kit](https://koenig-media.raywenderlich.com/uploads/2018/08/ML-Kit-for-Firebase-badge-light.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/ML-Kit-for-Firebase-badge-light.png)

现有的 API 目前支持：

*   [识别文字](https://firebase.google.com/docs/ml-kit/ios/recognize-text)
*   [人脸检测](https://firebase.google.com/docs/ml-kit/ios/detect-faces)
*   [识别地标建筑](https://firebase.google.com/docs/ml-kit/ios/recognize-landmarks)
*   [扫描条形码](https://firebase.google.com/docs/ml-kit/ios/read-barcodes)
*   [为图像加标签](https://firebase.google.com/docs/ml-kit/ios/label-images)

以上的每种使用场景都附带一个预先训练过的模型，而模型则包装在易用的 API 中。现在是时候动手做点东西啦！

### 预备工作

在本教程中，你会编写一个名为 **Extractor** 的 App。你有没有试过，只是为了把文字内容写下来，就去给标志或者海报拍照呢？如果有个 App 能够把图片上的文字抠下来并转换成真正的文字格式，那就太好了！比方说，你只需要给带有地址的一个信封拍照，就可以提取上面的地址信息。接下来你要在这个项目里面做的，正就是这样的 App！快做好准备吧！

你首先要做的，是下载本教程要用到的项目材料。点击教程最上方或者底部的“Download Materials”按钮就可以下载啦。

本项目使用 CocoaPods 对依赖进行管理。

### 配置 ML Kit 环境

每个 ML Kit API 都有一套不同的 CocoaPods 依赖。这蛮有用的，因为你只需要打包你的 App 所需的依赖。比方说，如果你不打算识别地标建筑，你的 App 就不需要有那个模型。在 Extractor 里，你要用到的是**文字识别 API**。

假如要在你的 App 里面加入文字识别 API，你需要在 Podfile 里面加入以下几行。不过做这个初始项目的时候就不用了，因为 Podfile 里面已经写好啦，你可以自己打开看看。

```
pod 'Firebase/Core' => '5.5.0'
pod 'Firebase/MLVision' => '5.5.0'
pod 'Firebase/MLVisionTextModel' => '5.5.0'
```

需要你做的呢，是打开终端，进入项目的文件夹，运行下面的命令，从而安装项目要用到的 CocoaPods：

```
pod install
```

安装好 CocoaPods 之后，在 Xcode 中打开 **Extractor.xcworkspace**。

> **注意**：你可能会发现，项目的文件夹里有一个名为 **Extractor.xcodeproj** 的项目文件，和一个名为 **Extractor.xcworkspace** 的 workspace 文件。你需要在 Xcode 打开后者，因为前者没有包含编译时所需的 CocoaPods 依赖库。
>
> 如果你不熟悉 CocoaPods，我们的 [CocoaPods 教程](https://www.raywenderlich.com/626-cocoapods-tutorial-for-swift-getting-started) 可以带你初步了解下。

本项目包含以下的重要文件：

1.  **ViewController.swift**：本项目唯一的控制器。
2.  **+UIImage.swift**：用于修正图像方向的 `UIImage` 扩展。

### 开设一个 Firebase 账号

按照 [初步学习 Firebase 的教程](https://www.raywenderlich.com/187417/firebase-tutorial-getting-started-3) 这篇文章里面有关开设账号的部分去做，就可以开设一个 Firebase 账号。虽然涉及的 Firebase 产品不同，新建账号和设置的过程是完全一样的。

大概的意思是让你：

1.  注册账号。
2.  创建项目。
3.  在项目中添加一个 iOS app。
4.  将 **GoogleService-Info.plist** 拖动到项目中。
5.  在 AppDelegate 中初始化 Firebase。

这个流程做起来不难，不过要是真的有什么搞不定，上面提到的指南可以帮你解决问题。

> **注意**：你需要设置好 Firebase，为最终项目和初始项目创建自己的 **GoogleService-Info.plist** 文件。

编译 App 再运行，你会看到它长这个样子：

[![初始项目](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-starter-nobezel-650x376.png)](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-starter-nobezel.png)

它暂时还做不了什么，只能让你用右上方的动作按钮分享已经写死的文字。你要用 ML Kit 把它做成一个真正有用的 App。

### 检测基本文本

准备好进行第一次文本检测啦！你一开始可以做的，是向用户展示这个 App 的用法。

一个不错的展示方法，就是在 App 第一次启动的时候，扫描一幅示例图片。资源文件夹里附带了一幅叫做 **scanned-text** 的图片，它现在是视图控制器的 `UIImageView` 所显示的默认图片，你会用它来做示例图片。

不过一开始呢，你需要有一个可以检测图片内文字的文本检测器。

#### 创建文本检测器

新建一个名为 **ScaledElementProcessor.swift** 的文件，填入以下代码：

```
import Firebase

class ScaledElementProcessor {

}
```

好啦，搞定啦！……才怪。你要在这个类里面添加一个 text-detector 属性：

```
let vision = Vision.vision()
var textRecognizer: VisionTextRecognizer!
  
init() {
  textRecognizer = vision.onDeviceTextRecognizer()
}
```

这个 `textRecognizer` 就是你用来检测图像内文本的主要对象。你要用它来识别 `UIImageView` 所显示的图片里面的文字。向刚才的类添加下面的检测方法：

```
func process(in imageView: UIImageView, 
  callback: @escaping (_ text: String) -> Void) {
  // 1
  guard let image = imageView.image else { return }
  // 2
  let visionImage = VisionImage(image: image)
  // 3
  textRecognizer.process(visionImage) { result, error in
    // 4
    guard 
      error == nil, 
      let result = result, 
      !result.text.isEmpty 
      else {
        callback("")
        return
    }
    // 5
    callback(result.text)
  }
}
```

我们花一点点时间搞懂上面这串代码：

1.  检查 `imageView` 当中是否真的包含图片。没有的话，直接返回就可以了。不过理想的做法还是，显示或者自己编写一段得体的错误信息。
2.  ML Kit 使用一个特别的 `VisionImage` 类型。它很好用，因为可以包含像是图片方向之类的具体元数据，让 ML Kit 用来处理图像。
3.  `textRecognizer` 带有一个 `process` 方法， 这个方法会输入 `VisionImage`，然后返回文本结果的阵列，将其作为参数传递给闭包。
4.  结果可以是 `nil`；那样的话，你最好为回调返回一个空字串。
5.  最后，触发回调，从而传递识别出的文字。

#### 使用文字识别器

打开 **ViewController.swift**，然后在类本体代码顶端的 outlet 后面，将 `ScaledElementProcessor` 的一个实例作为属性添加进去：

```
let processor = ScaledElementProcessor()
```

然后在 `viewDidLoad()` 的底部添加以下的代码，作用是在 **UITextView** 中显示出检测到的文字：

```
processor.process(in: imageView) { text in
  self.scannedText = text
}
```

这一小段代码会调用 `process(in:)`，传递主要的 `imageView`，然后在回调当中将识别出的文字分配给 `scannedText` 属性。

运行 app，你应该会在图像的下方看到下面的文字：

```
Your
SCanned
text
will
appear
here 
```

你可能要拖动文本视图才能看到最下面的几行。

留意一下，**scanned** 里面的 S 和 C 字母都是大写的。有时对某些字体进行识别的时候，文字的大小写会出错。这就是要在 `UITextView` 显示文字的原因；要是检测出错，用户可以手动编辑文字进行改正。

[![从图像中检测出的文字](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-basic-no-bezel-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-basic-no-bezel.png)

#### 理解这些类

> **注意**：你不需要复制这一节里面的代码，这些代码只是用来帮忙解释概念的。到了下一节，你才需要往 App 里面添加代码。

**VisionText**

你有没有发现，`ScaledElementProcessor` 中 `textRecognizer.process(in:)` 的回调函数返回的，是 `result` 参数里面的一个对象，而不是纯粹的文字。这是 [`VisionText`](https://firebase.google.com/docs/reference/swift/firebasemlvision/api/reference/Classes/VisionText) 的一个实例；它是一种包含很多有用信息的类，比如是识别到的文字。不过，你要做的不仅仅是取得文字。**如果我们可以帮每个识别出的文本元素都画出一个外框，那不是更酷炫吗？**

ML Kit 所提供的结果，具有像树一样的结构。你需要到达叶元素，才能取得包含已识别文字的 frame 的位置和尺寸。如果听完树形结构这个类比你还不是很懂的话，不用担心。下面的几节会讲清楚到底发生了什么。

不过，如果你有兴趣多了解树形数据结构的话，可以随时去看看这篇教程 — [Swift 树形数据结构](https://www.raywenderlich.com/1053-swift-algorithm-club-swift-tree-data-structure)。

**VisionTextBlock**

处理识别出的文字时，你首先要用到 `VisionText` 对象 — 这个对象（我所说的树）包含多个文字区块（就像树上的枝条）。每个分支都是 **blocks** 阵列里面的 `VisionTextBlock` 对象；而你需要迭代每个分支，做法如下:

```
for block in result.blocks {

}
```

**VisionTextElement**

`VisionTextBlock` 纯粹是个包含一系列分行文字（文字就像是树枝上的叶子）的对象，它们每一个都由 `VisionTextElement` 实例进行代表。你可以在这幅由各对象组成的嵌套图里，看清已识别文字的层级结构。

[![](https://koenig-media.raywenderlich.com/uploads/2018/07/vision-hierarchy-2x-1-573x500.png)](https://koenig-media.raywenderlich.com/uploads/2018/07/vision-hierarchy-2x-1.png)

循环遍历每个对象的时候，大概是这样：

```
for block in result.blocks {
  for line in block.lines {
    for element in line.elements {

    }
  }
}
```

这个层级结构里面的每个对象都包涵文本所在的 frame。然而，每个对象都具有不同层次的粒度。一个块（block）里面或许包括几个行。每行可能包括多个元素。而每个元素则可能包括多个符号。

就这篇教程而言，你要用到的是元素这一粒度层次。元素通常对应的是一个单词。这样一来，你就可以在每个单词上方进行绘制，向用户展示出图像中每个单词的位置。

最后一个循环会对文本块中每一行的元素进行迭代。这些元素包含 `frame`，它是个简单的 `CGRect`。运用这个 frame，你就可以在图像的文字周围绘制外框。

### 突出显示文本的 frame

#### frame 检测

要在图像上绘制，你需要建立一个具有文字元素的 `frame` 的 `CAShapeLayer`。打开 **ScaledElementProcessor.swift**，将下面的 `struct` 插入到文件的最上方：

```
struct ScaledElement {
  let frame: CGRect
  let shapeLayer: CALayer
}
```

这个 `struct` 很方便好用。有了 `struct`，就可以更容易地把 frame 和 `CAShapeLayer` 与控制器组合到一起。现在，你需要一个辅助方法，利用它从元素的 frame 建立 `CAShapeLayer`。

在 `ScaledElementProcessor` 的底部加入以下代码：

```
private func createShapeLayer(frame: CGRect) -> CAShapeLayer {
  // 1
  let bpath = UIBezierPath(rect: frame)
  let shapeLayer = CAShapeLayer()
  shapeLayer.path = bpath.cgPath
  // 2
  shapeLayer.strokeColor = Constants.lineColor
  shapeLayer.fillColor = Constants.fillColor
  shapeLayer.lineWidth = Constants.lineWidth
  return shapeLayer
}

// MARK: - private
  
// 3
private enum Constants {
  static let lineWidth: CGFloat = 3.0
  static let lineColor = UIColor.yellow.cgColor
  static let fillColor = UIColor.clear.cgColor
}
```

这段代码的作用是：

1.  `CAShapeLayer` 并没有可以输入 `CGRect` 的初始化器。所以，你要建立一个包含 `CGRect` 的 `UIBezierPath`，然后将形状图层的 `path` 设置为这个 `UIBezierPath`。
2.  通过 `Constants` 枚举类型，设置颜色和宽度方面的图像属性。
3.  这一枚举类型可以让颜色和宽度保持不变。

现在，用下面的代码替换掉 `process(in:callback:)`：

```
// 1
func process(
  in imageView: UIImageView, 
  callback: @escaping (_ text: String, _ scaledElements: [ScaledElement]) -> Void
  ) {
  guard let image = imageView.image else { return }
  let visionImage = VisionImage(image: image)
    
  textRecognizer.process(visionImage) { result, error in
    guard 
      error == nil, 
      let result = result, 
      !result.text.isEmpty 
      else {
        callback("", [])
        return
    }
  
    // 2
    var scaledElements: [ScaledElement] = []
    // 3
    for block in result.blocks {
      for line in block.lines {
        for element in line.elements {
          // 4
          let shapeLayer = self.createShapeLayer(frame: element.frame)
          let scaledElement = 
            ScaledElement(frame: element.frame, shapeLayer: shapeLayer)

          // 5
          scaledElements.append(scaledElement)
        }
      }
    }
      
    callback(result.text, scaledElements)
  }
}
```

代码有以下的改动：

1.  这里的回调函数现在不但可以接受已识别的文本，也可以接受 `ScaledElement` 实例组成的阵列。
2.  `scaledElements` 的作用是收集存放 frame 和形状图层。
3.  和上文的简介完全一致，这段代码使用 `for` 循环取得每个元素的 frame。
4.  最内层的 `for` 循环用元素的 frame 建立形状图层，然后又用图层来建立一个新的 `ScaledElement` 实例。
5.  将刚刚建立的实例添加到 `scaledElements` 之中。

#### 绘制

上面这些代码的作用，是帮你预备好纸和笔。现在是时候开始画画啦。打开 **ViewController.swift**，然后把 `viewDidLoad()` 有关 `process(in:)` 的调用替换为下面的代码：

```
processor.process(in: imageView) { text, elements in
  self.scannedText = text
  elements.forEach() { feature in
    self.frameSublayer.addSublayer(feature.shapeLayer)
  }
}
```

`ViewController` 具有一个附着于 `imageView` 的 `frameSublayer` 属性。你要在这里将每个元素的形状图层添加到子图层中，这样一来，iOS 就会自动在图像上绘制形状。

编译 App，然后运行。欣赏下自己的大作吧。

[![与图像的比例不一致的外框](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-picasso-no-bezel-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-picasso-no-bezel.png)

哟……这是啥？同学你这说不上是莫奈风格，倒有点毕加索的味道呀。（译者注：毕加索的绘画风格是将物体不同角度的样貌缩放拼合，使其显得支离破碎）这是哪里出错了呢？呃，或许是时候讲讲缩放比例这个问题了。

### 理解图像的缩放

默认的 **scanned-text.png**，其大小为 654×999 (宽乘高)；但是呢，`UIImageView` 的“Content Mode”是“Aspect Fit”，这一设定会将视图中的图像缩放成 375×369。ML Kit 所获得的是图像的实际大小，它也是按照实际大小返回元素的 frame。然后，由实际尺寸得出的 frame 会绘制在缩放后的尺寸上。这样得出的结果就让人搞不懂状况。

[![Compare actual size vs scaled size](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-picasso-explainer-no-bezel-650x491.png)](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-picasso-explainer-no-bezel.png)

注意上图里面缩放尺寸与实际尺寸之间的差异。你可以看到，图中的 frame 是与实际尺寸一致的。要把 frame 的位置放对，你就要计算出图像相对于视图的缩放比例。

公式挺简单的（👀…大概吧）：

1.  计算出视图和图像的分辨率。
2.  比较两个分辨率，定出缩放比例。
3.  通过与缩放比例相乘，计算出高度、宽度、原点 x 和原点 y。
4.  运用有关数据点，创建一个新的 CGRect。

要是听糊涂了也不要紧！你看到代码就会懂的。

### 计算缩放比例

打开 **ScaledElementProcessor.swift**，添加以下方法：

```
// 1
private func createScaledFrame(
  featureFrame: CGRect, 
  imageSize: CGSize, viewFrame: CGRect) 
  -> CGRect {
  let viewSize = viewFrame.size
    
  // 2
  let resolutionView = viewSize.width / viewSize.height
  let resolutionImage = imageSize.width / imageSize.height
    
  // 3
  var scale: CGFloat
  if resolutionView > resolutionImage {
    scale = viewSize.height / imageSize.height
  } else {
    scale = viewSize.width / imageSize.width
  }
    
  // 4
  let featureWidthScaled = featureFrame.size.width * scale
  let featureHeightScaled = featureFrame.size.height * scale
    
  // 5
  let imageWidthScaled = imageSize.width * scale
  let imageHeightScaled = imageSize.height * scale
  let imagePointXScaled = (viewSize.width - imageWidthScaled) / 2
  let imagePointYScaled = (viewSize.height - imageHeightScaled) / 2
    
  // 6
  let featurePointXScaled = imagePointXScaled + featureFrame.origin.x * scale
  let featurePointYScaled = imagePointYScaled + featureFrame.origin.y * scale
    
  // 7
  return CGRect(x: featurePointXScaled,
                y: featurePointYScaled,
                width: featureWidthScaled,
                height: featureHeightScaled)
  }
```

代码所做的东西包括：

1.  这个方法会输入 `CGRect`，从而获取图像的原本尺寸、显示尺寸，以及 `UIImageView` 的 frame。
2.  计算视图和图像的分辨率时，分别用它们各自的宽度除以自身的高度。
3.  根据两个分辨率之中较大的一个来决定缩放比例。如果视图比较大，就根据高度进行缩放；反之，则根据宽度进行缩放。
4.  这个方法会计算宽度和高度。frame 的宽和高会乘以缩放比例，从而算出缩放后的宽和高。
5.  frame 的原点也必须进行缩放。不然的话，就算外框的尺寸搞对了，它也会位于偏离（文本）中心的错误位置。
6.  新原点的计算方法是，用缩放比例乘以未缩放的原点，再加上 X 和 Y 点的缩放值。
7.  返回经过缩放、依照计算出的原点和尺寸配置好的 `CGRect`。

有了缩放好的 `CGRect`，就可以大大提升你的绘制技能，达到 sgraffito 的水平啦。[对的，我就是要教你个新单词](https://www.britannica.com/art/sgraffito)，下次玩 Scrabble 填字游戏的时候可要谢谢我呀。

前往 **ScaledElementProcessor.swift** 中的 `process(in:callback:)`，修改最内层的 `for` 循环，让它使用下面的代码：

```
for element in line.elements {
  let frame = self.createScaledFrame(
    featureFrame: element.frame,
    imageSize: image.size, 
    viewFrame: imageView.frame)
  
  let shapeLayer = self.createShapeLayer(frame: frame)
  let scaledElement = ScaledElement(frame: frame, shapeLayer: shapeLayer)
  scaledElements.append(scaledElement)
}
```

刚刚加入的线条会建立一个缩放好的 frame，而代码会使用外框建立位置正确的形状图层。

编译 App，然后运行。frame 应该出现在正确的地方啦。你真是个绘框大师呢。

[![与图像缩放一致的外框](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-fixed-picasso-no-bezel-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-fixed-picasso-no-bezel.png)

默认图片我们已经玩够了，是时候出门找点实物练手啦！

### 用照相机拍照

项目已经包含设置好的相机及图库选图代码，它们位于 **ViewController.swift** 底部的一个扩展里。如果你现在就用用看，你会发现 frame 全都会错位。这是因为 App 还在使用预载图像中的 frame。你要移除这些旧 frame，然后在拍摄或者选取照片的时候绘制新的 frame。

把下面的方法添加到 `ViewController`：

```
private func removeFrames() {
  guard let sublayers = frameSublayer.sublayers else { return }
  for sublayer in sublayers {
    sublayer.removeFromSuperlayer()
  }
}
```

这个方法使用 `for` 循环移除 frame 子图层中的所有子图层。这样你在处理接下来的照片时，才会有一张干净的画布。

为了完善检测代码，我们在 `ViewController` 中加入下面的新方法：

```
// 1
private func drawFeatures(
  in imageView: UIImageView, 
  completion: (() -> Void)? = nil
  ) {
  // 2
  removeFrames()
  processor.process(in: imageView) { text, elements in
    elements.forEach() { element in
      self.frameSublayer.addSublayer(element.shapeLayer)
    }
    self.scannedText = text
    // 3
    completion?()
  }
}
```

代码有以下改动：

1.  这个方法会接收 `UIImageView` 和回调，这样你就能知道什么时候完成了。
2.  frame 会在处理新图像之前自动被移除。
3.  所有工作都完成后，触发完成回调。

现在，用下面的代码，替换掉 `viewDidLoad()` 中对 `processor.process(in:callback:)` 的调用：

```
drawFeatures(in: imageView)
```

向下滚动到类扩展的位置，找出 `imagePickerController(_:didFinishPickingMediaWithInfo:)`。在 if 段落的底部，`imageView.image = pickedImage` 的后面加入这一行代码：

```
drawFeatures(in: imageView)
```

拍摄或者选取新照片的时候，这段代码可以确保将之前绘制的 frame 移除，再用新照片的 frame 进行替换。

编译 App，然后运行。如果你是用真实设备运行（而不是模拟器的话），拍一副带文字的照片吧。这时或许会出现奇怪的结果：

[![检测出乱码](https://koenig-media.raywenderlich.com/uploads/2018/07/gibberish.png)](https://koenig-media.raywenderlich.com/uploads/2018/07/gibberish.png)

这是怎么啦？

上面是图像朝向出问题了，所以我们马上就来讲讲图像朝向。

### 处理图像的朝向

这个 App 是锁定于竖向模式的。在设备旋转方向的时候重绘 frame 很麻烦。目前的话，还是给用户设定一些限制，这样做起来比较简单。

有这条限制，用户就必须拍摄纵向照片。`UICameraPicker` 会在幕后将纵向照片旋转 90 度。你不会看见旋转过程，因为 `UIImageView` 会帮你旋转成原来的样子。但是，文字检测器所获取的，则是旋转后的 `UIImage`。

[![旋转后的图片](https://koenig-media.raywenderlich.com/uploads/2018/07/rotated-raw.jpg)](https://koenig-media.raywenderlich.com/uploads/2018/07/rotated-raw.jpg)

这样就会出现让人困惑的结果。ML Kit 可以让你在 `VisionMetadata` 对象中设置照片的朝向。设置正确的朝向，App 就会返回正确的文本，但是 frame 还是依照旋转后的图片绘制的。

[![ML Kit 看到的照片是这样的，所以绘制的外框都是错的](https://koenig-media.raywenderlich.com/uploads/2018/07/rotated-placed-image.jpg)](https://koenig-media.raywenderlich.com/uploads/2018/07/rotated-placed-image.jpg)

所以呢，你需要处理照片朝向的问题，让它总是“朝上”。本项目包含一个名为 **+UIImage.swift** 的扩展。这个扩展会在 `UIImage` 加入一个方法，它可以将任何照片的朝向更改为纵向。图像的朝向摆正之后，整个 App 就可以顺畅运行啦。

打开 **ViewController.swift**，在 `imagePickerController(_:didFinishPickingMediaWithInfo:)` 之中，用下面的代码替换掉 `imageView.image = pickedImage`：

```
// 1
let fixedImage = pickedImage.fixOrientation()
// 2
imageView.image = fixedImage
```

改动有两点：

1.  把刚刚选中的图像 `pickedImage` 旋转到朝上的位置。
2.  然后，将旋转好的图像分配到 `imageView`。

编译 App，然后运行。再拍一次照。这次所有东西的位置应该都没问题了。

[![Working ML Kit frames](https://koenig-media.raywenderlich.com/uploads/2018/07/final-version.jpg)](https://koenig-media.raywenderlich.com/uploads/2018/07/final-version.jpg)

### 分享文本

最后一步你什么都不用做。是不是棒棒哒？这个 App 已经整合了 `UIActivityViewController`。去看看 `shareDidTouch()`：

```
@IBAction func shareDidTouch(_ sender: UIBarButtonItem) {
  let vc = UIActivityViewController(
    activityItems: [textView.text, imageView.image!], 
    applicationActivities: [])

  present(vc, animated: true, completion: nil)
}
```

这里所做的只有两步，很简单。创建一个包含扫描所得文本及图像的 `UIActivityViewController`。然后调用 `present()`，剩下的让用户搞定就可以了。

### 之后可以干点啥？

恭喜！你已经是一名机器学习开发者啦！点击本文页首或者文末的 **Download Materials** 按钮，可以取得完整版本的 Extractor。不过要注意的是，下载最终版本的项目文件之后，还需要添加你自己的 **GoogleService-Info.plist**；这点我在上文也说过啦。你也需要依据你在 Firebase 控制台中的设置，将 bundle ID 更改为合适的值。

在这个教程里，你做到了：

*   开发具有文字检测功能的照相 app，从中学习 ML Kit 的基础知识。
*   搞懂 ML Kit 的文字识别 API、图像缩放和图像方向。

而且你不需要拿到机器学习的博士学位就做到啦 :\]

如果你想再多多了解 Firebase 和 ML Kit，请查阅 [官方文档](https://developers.google.com/ml-kit/)。

如果你对这份 Firebase 教程、Firebase、ML Kit 或者示例 App 有任何意见或疑问，欢迎你加入到下面的讨论中！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
