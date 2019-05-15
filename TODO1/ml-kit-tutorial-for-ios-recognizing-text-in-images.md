> * 原文地址：[ML Kit Tutorial for iOS: Recognizing Text in Images](https://www.raywenderlich.com/6565-ml-kit-tutorial-for-ios-recognizing-text-in-images)
> * 原文作者：[By David East](https://www.raywenderlich.com/u/deast)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ml-kit-tutorial-for-ios-recognizing-text-in-images.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ml-kit-tutorial-for-ios-recognizing-text-in-images.md)
> * 译者：
> * 校对者：

# ML Kit Tutorial for iOS: Recognizing Text in Images

In this ML Kit tutorial, you’ll learn how to leverage Google’s ML Kit to detect and recognize text.

A few years ago, there were two types of machine learning (ML) developers: the advanced developers and everyone else. The lower levels of ML can be hard; it’s a lot of math, and it uses big words like **logistic regression**, **sparsity** and **neural nets**. But it doesn’t have to be that hard.

You can also be an ML developer! At its core, ML is simple. With it, you solve a problem by teaching a software model to recognize patterns instead of hard coding each situation and corner case you can think of. However, it can be daunting to get started, and this is where you can rely on existing tools.

#### Machine Learning and Tooling

Just like iOS development, ML is about tooling. You wouldn’t build your own UITableView, or at least you shouldn’t; you would use a framework instead, like UIKit.

It’s the same way with ML. ML has a booming ecosystem of tooling. **Tensorflow**, for example, simplifies training and running models. **TensorFlow Lite** brings model support to iOS and Android devices.

Each of these tools requires some experience with ML. What if you’re not an ML expert but want to solve a specific problem? For these situations, there’s **ML Kit**.

### ML Kit

ML Kit is a mobile SDK that brings Google’s ML expertise to your app. There are two main parts of ML Kit’s APIs for common use cases and custom models that are easy to use regardless of experience.

[![ML Kit](https://koenig-media.raywenderlich.com/uploads/2018/08/ML-Kit-for-Firebase-badge-light.png)](https://koenig-media.raywenderlich.com/uploads/2018/08/ML-Kit-for-Firebase-badge-light.png)

The existing APIs currently support:

*   [Recognizing text](https://firebase.google.com/docs/ml-kit/ios/recognize-text)
*   [Detecting faces](https://firebase.google.com/docs/ml-kit/ios/detect-faces)
*   [Identifying landmarks](https://firebase.google.com/docs/ml-kit/ios/recognize-landmarks)
*   [Scanning barcodes](https://firebase.google.com/docs/ml-kit/ios/read-barcodes)
*   [Labeling images](https://firebase.google.com/docs/ml-kit/ios/label-images)

Each of these use cases comes with a pre-trained model wrapped in an easy-to-use API. Time to start building something!

### Getting Started

In this tutorial, you’re going to build an app called **Extractor**. Have you ever snapped a picture of a sign or a poster just to write down the text content? It would be great if an app could just peel the text off the sign and save it for you, ready to use. You could, for example, take a picture of an addressed envelope and save the address. That’s exactly what you’ll do with this project! Get ready!

Start by downloading the project materials for this tutorial using the **Download Materials** button at the top or bottom of this tutorial.

This project uses CocoaPods to manage dependencies.

### Setting Up ML Kit

Each ML Kit API has a different set of CocoaPods dependencies. This is useful because you only need to bundle the dependencies required by your app. For instance, if you’re not identifying landmarks, you don’t need that model in your app. In Extractor, you’ll use the **Text Recognition API**.

If you were adding the Text Recognition API to your app, then you would need to add the following lines to your Podfile, but you don’t have to do this for the starter project since the lines are there in the Podfile – you can check.

```
pod 'Firebase/Core' => '5.5.0'
pod 'Firebase/MLVision' => '5.5.0'
pod 'Firebase/MLVisionTextModel' => '5.5.0'
```

You do have to open the Terminal app, switch over to the project folder and run the following command to install the CocoaPods used in the project though:

```
pod install
```

Once the CocoaPods are installed, open **Extractor.xcworkspace** in Xcode.

> **Note**: You may notice that the project folder contains a project file named **Extractor.xcodeproj** and a workspace file named **Extractor.xcworkspace**, which is the file you’re opening in Xcode. Don’t open the project file, because it doesn’t contain the additional CocoaPods project which is required to compile the app.
>
> If you’re unfamiliar with CocoaPods, our [CocoaPods Tutorial](https://www.raywenderlich.com/626-cocoapods-tutorial-for-swift-getting-started) will help you get started.

This project contains the following important files:

1.  **ViewController.swift**: The only controller in this project.
2.  **+UIImage.swift**: A `UIImage` extension to fix the orientation of images.

### Setting Up a Firebase Account

To set up a Firebase account, follow the account setup section in this [Getting Started With Firebase Tutorial](https://www.raywenderlich.com/187417/firebase-tutorial-getting-started-3). While the Firebase products are different, the account creation and setup is exactly the same.

The general idea is that you:

1.  Create an account.
2.  Create a project.
3.  Add an iOS app to a project.
4.  Drag the **GoogleService-Info.plist** to your project.
5.  Initialize Firebase in the AppDelegate.

It’s simple process but, if you hit any snags, the guide above can help.

> **Note**: You need to set up Firebase and create your own **GoogleService-Info.plist** for both the final and starter projects.

Build and run the app, and you’ll see that it looks like this:

[![Starter app](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-starter-nobezel-650x376.png)](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-starter-nobezel.png)

It doesn’t do anything yet except allow you to share the hard-coded text via the action button on the top right. You’ll use ML Kit to bring this app to life.

### Detecting Basic Text

Get ready for your first text detection! You can begin by demonstrating to the user how to use the app.

A nice demonstration is to scan an example image when the app first boots up. There’s an image bundled in the assets folder named **scanned-text**, which is currently the default image displayed in the `UIImageView` of the view controller. You’ll use that as the example image.

But first, you need a text detector to detect the text in the image.

#### Creating a Text Detector

Create a file named **ScaledElementProcessor.swift** and add the following code:

```
import Firebase

class ScaledElementProcessor {

}
```

Great! You’re all done! Just kidding. Create a text-detector property inside the class:

```
let vision = Vision.vision()
var textRecognizer: VisionTextRecognizer!
  
init() {
  textRecognizer = vision.onDeviceTextRecognizer()
}
```

This `textRecognizer` is the main object you can use to detect text in images. You’ll use it to recognize the text contained in the image currently displayed by the `UIImageView`. Add the following detection method to the class:

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

Take a second to understand this chunk of code:

1.  Here, you check if the `imageView` actually contains an image. If not, simply return. Ideally, however, you would either throw or provide a graceful failure.
2.  ML Kit uses a special `VisionImage` type. It’s useful because it can contain specific metadata for ML Kit to process the image, such as the image’s orientation.
3.  The `textRecognizer` has a `process` method that takes in the `VisionImage`, and it returns an array of text results in the form of a parameter passed to a closure.
4.  The result could be `nil`, and, in that case, you’ll want to return an empty string for the callback.
5.  Lastly, the callback is triggered to relay the recognized text.

#### Using the Text Detector

Open **ViewController.swift** and, after the outlets at the top of the class body, add an instance of `ScaledElementProcessor` as a property:

```
let processor = ScaledElementProcessor()
```

Then, add the following code at the bottom of `viewDidLoad()` to display the detected text in the **UITextView**:

```
processor.process(in: imageView) { text in
  self.scannedText = text
}
```

This small block calls `process(in:)`, passing the main `imageView` and assigning the recognized text to the `scannedText` property in the callback.

Run the app, and you should see the following text right below the image:

```
Your
SCanned
text
will
appear
here 
```

You might need to scroll the text view to reveal the last couple of lines.

Notice how the “S” and “C” of **scanned** are uppercase. Sometimes, with specific fonts, the wrong casing can appear. This is the reason why the text is displayed in a `UITextView`, so the user can manually edit to fix detection mistakes.

[![Detected text from image](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-basic-no-bezel-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-basic-no-bezel.png)

#### Understanding the Classes

> **Note**: You don’t have to copy the code in this section; it just helps to explain concepts. You’ll add code to the app in the next section.

**VisionText**

Did you notice that the callback of `textRecognizer.process(in:)` in `ScaledElementProcessor` returned an object in the `result` parameter instead of plain old text? This is an instance of [`VisionText`](https://firebase.google.com/docs/reference/swift/firebasemlvision/api/reference/Classes/VisionText), a class that contains lots of useful information, such as the recognized text. But you want to do more than just get the text. **Wouldn’t it be cool to outline each frame of each recognized text element?**

ML Kit provides the result in a structure similar to a tree. You need to traverse to the leaf element in order to obtain the position and size of the frame containing the recognized text. If the reference to tree structures did not make a lot of sense to you, don’t worry too much. The sections below should clarify what’s going on.

However, if you are interested in learning more about tree data structures, you can always check out this tutorial on [Swift Tree Data Structures](https://www.raywenderlich.com/1053-swift-algorithm-club-swift-tree-data-structure).

**VisionTextBlock**

When working with recognized text, you start with a `VisionText` object — this is an object (call it the tree) that can contain multiple blocks of text (like branches in a tree). You iterate over each branch, which is a `VisionTextBlock` object in the **blocks** array, like this:

```
for block in result.blocks {

}
```

**VisionTextElement**

A `VisionTextBlock` is simply an object containing a collection of lines of text (like leaves on a branch) each represented by a `VisionTextElement` instance. This nesting doll of objects allows you to see the hierarchy of the identified text.

[![](https://koenig-media.raywenderlich.com/uploads/2018/07/vision-hierarchy-2x-1-573x500.png)](https://koenig-media.raywenderlich.com/uploads/2018/07/vision-hierarchy-2x-1.png)

Looping through each object looks like this:

```
for block in result.blocks {
  for line in block.lines {
    for element in line.elements {

    }
  }
}
```

All objects in this hierarchy contain the frame in which the text is located. However, each object contains a different level of granularity. A block may contain multiple lines, a line may contain multiple elements, and an element may contain multiple symbols.

For this tutorial, you’ll use elements as the level of granularity. Elements will typically correspond to a word. This will allow you to draw over each word and show the user where each word is located in the image.

The last loop iterates over the elements in each line of the text block. These elements contain the `frame`, a simple `CGRect`. Using this frame, you can draw borders around the words on the image.

### Highlighting the Text Frames

#### Detecting Frames

To draw on the image, you’ll need to create a `CAShapeLayer` with the `frame` of the text element. Open **ScaledElementProcessor.swift** and add the following `struct` to the top of the file:

```
struct ScaledElement {
  let frame: CGRect
  let shapeLayer: CALayer
}
```

This `struct` is a convenience. It makes it easier to group the frame and `CAShapeLayer` to the controller. Now, you need a helper method to create a `CAShapeLayer` from the element’s frame.

Add the following code to the end of `ScaledElementProcessor`:

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

Here’s what the code does:

1.  A `CAShapeLayer` does not have an initializer that takes in a `CGRect`. So, you construct a `UIBezierPath` with the `CGRect` and set the shape layer’s `path` to the `UIBezierPath`.
2.  The visual properties for colors and widths are set via a `Constants` enum.
3.  This enum helps keep the coloring and widths consistent.

Now, replace `process(in:callback:)` with the following:

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

Here’s what changed:

1.  The callback now takes an array of `ScaledElement` instances in addition to the recognized text.
2.  `scaledElements` serves as a collection for frames and shape layers.
3.  Exactly as outlined above, the code uses a `for` loop to get the frame of each element.
4.  The innermost `for` loop creates the shape layer from the element’s frame, which is then used to construct a new `ScaledElement` instance.
5.  Add the newly created instance to `scaledElements`.

#### Drawing

The code above was getting your pencils together. Now, it’s time to draw! Open **ViewController.swift** and, in `viewDidLoad()`, replace the call to `process(in:)` with the following:

```
processor.process(in: imageView) { text, elements in
  self.scannedText = text
  elements.forEach() { feature in
    self.frameSublayer.addSublayer(feature.shapeLayer)
  }
}
```

`ViewController` has a `frameSublayer` property that is attached to the `imageView`. Here, you add each element’s shape layer to the sublayer, so that iOS will automatically draw the shape on the image.

Build and run. See your work of art!

[![Frames that are not scaled to the image](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-picasso-no-bezel-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-picasso-no-bezel.png)

Oh. What is that? It looks like you’re more of a Picasso than a Monet. What’s going on, here? Well, it’s probably time to talk about scale.

### Understanding Image Scaling

The default **scanned-text.png** image is 654×999 (width x height); however, the `UIImageView` has a “Content Mode” of “Aspect Fit,” which scales the image to 375×369 in the view. ML Kit receives the actual size of the image and returns the element frames based on that size. The frames from the actual size are then drawn on the scaled size, which produces a confusing result.

[![Compare actual size vs scaled size](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-picasso-explainer-no-bezel-650x491.png)](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-picasso-explainer-no-bezel.png)

In the picture above, notice the differences between the scaled size and the actual size. You can see that the frames match up on the actual size. To get the frames in the right place, you need to calculate the scale of the image versus the view.

The formula is fairly simple (👀…fairly):

1.  Calculate the resolutions of the view and image.
2.  Determine the scale by comparing resolutions.
3.  Calculate height, width, and origin points x and y, by multiplying them by the scale.
4.  Use those data points to create a new CGRect.

If that sounds confusing, it’s OK! You’ll understand when you see the code.

### Calculating the Scale

Open **ScaledElementProcessor.swift** and add the following method:

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

Here’s what’s going on in the code:

1.  This method takes in `CGRect`s for the original size of the image, the displayed image size and the frame of the `UIImageView`.
2.  The resolutions of the image and view are calculated by dividing their heights and widths respectively.
3.  The scale is determined by which resolution is larger. If the view is larger, you scale by the height; otherwise, you scale by the width.
4.  This method calculates width and height. The width and height of the frame are multiplied by the scale to calculate the scaled width and height.
5.  The origin of the frame must be scaled as well; otherwise, even if the size is correct, it would be way off center in the wrong position.
6.  The new origin is calculated by adding the x and y point scales to the unscaled origin multiplied by the scale.
7.  A scaled `CGRect` is returned, configured with calculated origin and size.

Now that you have a scaled `CGRect`, you can go from scribbles to sgraffito. Yes, that’s a thing. [Look it up](https://www.google.com/search?q=sgraffito) and thank me in your next Scrabble game.

Go to `process(in:callback:)` in **ScaledElementProcessor.swift** and modify the innermost `for` loop to use the following code:

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

The newly added line creates a scaled frame, which the code uses to create the correctly position shape layer.

Build and run. You should see the frames drawn in the right places. What a master painter you are!

[![Frames that are scaled to the image](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-fixed-picasso-no-bezel-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2018/12/rw-fixed-picasso-no-bezel.png)

Enough with default photos; time to capture something from the wild!

### Taking Photos with the Camera

The project has the camera and library picker code already set up in an extension at the bottom of **ViewController.swift**. If you try to use it right now, you’ll notice that none of the frames match up. That’s because it’s still using the old frames from the preloaded image! You need to remove those and draw new ones when you take or select a photo.

Add the following method to `ViewController`:

```
private func removeFrames() {
  guard let sublayers = frameSublayer.sublayers else { return }
  for sublayer in sublayers {
    sublayer.removeFromSuperlayer()
  }
}
```

This method removes all sublayers from the frame sublayer using a `for` loop. This gives you a clean canvas for the next photo.

To consolidate the detection code, add the following new method to `ViewController`:

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

Here’s what changed:

1.  This methods takes in the `UIImageView` and a callback so that you know when it’s done.
2.  Frames are automatically removed before processing a new image.
3.  Trigger the completion callback once everything is done.

Now, replace the call to `processor.process(in:callback:)` in `viewDidLoad()` with the following:

```
drawFeatures(in: imageView)
```

Scroll down to the class extension and locate `imagePickerController(_:didFinishPickingMediaWithInfo:)`; add this line of code to the end of the `if` block, after `imageView.image = pickedImage`:

```
drawFeatures(in: imageView)
```

When you shoot or select a new photo, this code ensures that the old frames are removed and replaced by the ones from the new photo.

Build and run. If you’re on a real device (not a simulator), take a picture of printed text. You might see something strange:

[![Gibberish text detection](https://koenig-media.raywenderlich.com/uploads/2018/07/gibberish.png)](https://koenig-media.raywenderlich.com/uploads/2018/07/gibberish.png)

What’s going on here?

You’ll cover image orientation in a second, because the above is an orientation issue.

### Dealing With Image Orientations

This app is locked in portrait orientation. It’s tricky to redraw the frames when the device rotates, so it’s easier to restrict the user for now.

This restriction requires the user to take portrait photos. The `UICameraPicker` rotates portrait photos 90 degrees behind the scenes. You don’t see the rotation because the `UIImageView` rotates it back for you. However, what the detector gets is the rotated `UIImage`.

[![The rotated photo](https://koenig-media.raywenderlich.com/uploads/2018/07/rotated-raw.jpg)](https://koenig-media.raywenderlich.com/uploads/2018/07/rotated-raw.jpg)

This leads to some confusing results. ML Kit allows you to specify the orientation of the photo in the `VisionMetadata` object. Setting the proper orientation will return the correct text, but the frames will be drawn for the rotated photo.

[![This is how ML Kit sees the photo, so the frames are drawn incorrectly.](https://koenig-media.raywenderlich.com/uploads/2018/07/rotated-placed-image.jpg)](https://koenig-media.raywenderlich.com/uploads/2018/07/rotated-placed-image.jpg)

Therefore, you need to fix the photo orientation to always be in the “up” position. The project contains an extension named **+UIImage.swift**. This extension adds a method to `UIImage` that changes the orientation of any photo to the up position. Once the photo is in the correct orientation, everything will run smoothly!

Open **ViewController.swift** and, in `imagePickerController(_:didFinishPickingMediaWithInfo:)`, replace `imageView.image = pickedImage` with the following:

```
// 1
let fixedImage = pickedImage.fixOrientation()
// 2
imageView.image = fixedImage
```

Here’s what changed:

1.  The newly selected image, `pickedImage`, is rotated back to the up position.
2.  Then, you assign the rotated image to the `imageView`.

Build and run. Take that photo again. You should see everything in the right place.

[![Working ML Kit frames](https://koenig-media.raywenderlich.com/uploads/2018/07/final-version.jpg)](https://koenig-media.raywenderlich.com/uploads/2018/07/final-version.jpg)

### Sharing the Text

This last step requires no action from you. Aren’t those the best? The app is integrated with the `UIActivityViewController`. Look at `shareDidTouch()`:

```
@IBAction func shareDidTouch(_ sender: UIBarButtonItem) {
  let vc = UIActivityViewController(
    activityItems: [textView.text, imageView.image!], 
    applicationActivities: [])

  present(vc, animated: true, completion: nil)
}
```

It’s a simple two-step process. Create a `UIActivityViewController` that contains the scanned text and image. Then call `present()` and let the user do the rest.

### Where to Go From Here?

Congratulations! You are now an ML developer! You can get the completed version of Extractor using the **Download Materials** button at the top or bottom of this tutorial. But do note that, as mentioned at the beginning, you still have to add your own **GoogleService-Info.plist** after downloading the final project. You’ll also need to update the bundle ID to match what you configured in the Firebase console.

In this tutorial, you learned:

*   The basics of ML Kit by building a text detection photo app.
*   The ML Kit text recognition API, image scale and orientation.

And you did all this without having an ML Ph.D. :\]

To learn more about Firebase and ML Kit, please check out the [official documentation](https://developers.google.com/ml-kit/).

If you have any comments or questions about this Firebase tutorial, Firebase, ML Kit or the sample app, please join the forum discussion below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
