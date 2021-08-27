> * 原文地址：[How It’s Made: I/O Photo Booth](https://medium.com/flutter/how-its-made-i-o-photo-booth-3b8355d35883)
> * 原文作者：[Very Good Ventures Team](https://medium.com/@vgv_team)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-its-made-i-o-photo-booth.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-its-made-i-o-photo-booth.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Chorer](https://github.com/Chorer)

# 我们是怎么做到的：Google I/O Photo Booth

![](https://miro.medium.com/max/2800/0*diM5YKjX2b2OgNvD)

我们（Very Good Ventures 开发者们）与 Google 合作，为今年的 Google I/O 带来了互动体验：[Photo Booth](https://photobooth.flutter.dev/)！你现在可以与知名的谷歌吉祥物 [Flutter's Dash](https://flutter.dev/dash)、Android Jetpack、Chrome 的 Dino 和 Firebase 的 Sparky 合影，并用诸如派对帽、披萨、时髦眼镜等等的贴纸装饰照片！最后，你还可以在社交媒体上分享照片，或者选择下载照片以更新你的个人资料照片！

![](https://miro.medium.com/max/2800/0*OQnK58irOAv-Pjzq)

<small>Flutter Dash、Firebase Sparky、Android Jetpack 和 Chrome Dino</small>

我们使用 [Flutter Web](https://flutter.dev/web) 和 [Firebase](https://firebase.google.com/) 构建了 I/O Photo Booth 这个软件，因为 [Flutter 现在提供了对 Web 应用程序的支持](https://medium.com/flutter/whats-new-in-flutter-2-0-fe8e95ecc65)，我们认为这将是让今年虚拟 Google I/O 的来自全球各地的与会者轻松访问此应用程序的好方法。Flutter 的网络支持消除了我们必须从应用程序商店安装应用程序的限制，还使我们可以灵活地在指定的设备上运行它：移动端、桌面端或平板电脑端。这让我们可以无需下载，只需使用任何设备上的任何适当的浏览器，浏览我们给出的页面即可体验 I/O Photo Booth！

尽管 I/O Photo Booth 旨在提供 Web 体验，但所有代码都是使用与平台无关的架构编写的。当对相机插件等元素的原生支持可用于各自的平台时，相同的代码适用于所有平台（桌面端、网络端和移动端）。

## 使用 Flutter 制作虚拟照相亭

### 为 Web 构建 Flutter 相机插件

第一个挑战是在 Web 上为 Flutter 构建一个相机插件。最初，我们联系了 [Baseflow](https://www.baseflow.com/) 团队，因为他们维护着现有的开源 [Flutter 相机插件](https://github.com/Baseflow/flutter-plugins)。虽然 Baseflow 致力于为 iOS 和 Android 构建一流的相机插件支持，但我们很高兴使用 [联合插件](https://flutter.dev/docs/development/packages-and-plugins/developing-packages#federated-plugins)。我们尽可能贴近官方插件界面，以便我们可以在准备好时将其合并回官方插件。

我们确定了两个对于在 Flutter 中构建 I/O Photo Booth 相机体验至关重要的 API。

1. **初始化相机：** 该应用程序首先需要访问我们设备上的相机。在台式机上，这可能是网络摄像头，而在移动设备上，我们选择了前置摄像头。我们还指定分辨率为 1080p，以根据我们的设备最大限度地提高相机质量。
2. **拍照：** 我们使用了内置的 [`HtmlElementView`](https://api.flutter.dev/flutter/widgets/HtmlElementView-class.html)。它可以使用平台视图来渲染原生 Web 元素作为 Flutter 小部件。在这个项目中，我们渲染了一个 [`VideoElement`](https://api.flutter.dev/flutter/dart-html/VideoElement-class.html) 作为原生 HTML 元素 —— 也就是我们之前在屏幕上看到的你拍你的照片。我们还使用了 [`CanvasElement`](https://api.flutter.dev/flutter/dart-html/CanvasElement-class.html) 作为另一个 HTML 元素呈现方式，让我们可以在单击拍照按钮时从媒体流中捕获图像。

```dart
Future<CameraImage> takePicture() async {  
 final videoWidth = videoElement.videoWidth;  
 final videoHeight = videoElement.videoHeight;  
 final canvas = html.CanvasElement(  
   width: videoWidth,  
   height: videoHeight,  
 );  
 canvas.context2D  
   ..translate(videoWidth, 0)  
   ..scale(-1, 1)  
   ..drawImageScaled(videoElement, 0, 0, videoWidth, videoHeight);  
 final blob = await canvas.toBlob();  
 return CameraImage(  
   data: html.Url.createObjectUrl(blob),  
   width: videoWidth,  
   height: videoHeight,  
 );  
}
```

### 相机权限

在我们让 Flutter Camera 插件可以在 Web 上运行后，我们创建了一个抽象来根据相机权限显示不同的 UI。例如，在等待选择是否允许使用浏览器摄像头时，或者如果没有可用的摄像头可供访问，我们可以显示一条说明性消息。

```dart
Camera(  
 controller: _controller,  
 placeholder: (_) => const SizedBox(),  
 preview: (context, preview) => PhotoboothPreview(  
   preview: preview,  
   onSnapPressed: _onSnapPressed,  
 ),  
 error: (context, error) => PhotoboothError(error: error), 
)
```

在此抽象中，`placeholder` 在应用程序等待我们授予相机权限时返回初始 UI（`const SizedBox()`）。`preview` 授予权限后返回 UI，并提供摄像机的实时视频流。错误构建器允许我们在发生错误时捕获错误并呈现相应的错误消息。

### 镜像照片

我们的下一个挑战是镜像照片。如果我们保留原样使用相机拍摄照片，那么我们看到的将不是平时在照镜子时所看到的那样，而[有些设备开放了接口如反转按钮来处理这个](https://9to5mac.com/2020/07/09/iphone-mirror-selfie-photos/)。所以如果你用前置摄像头拍照，拍摄照片时，我们会看到镜像版本。

在我们的第一种方法中，我们尝试捕捉默认的相机视图，然后围绕 y 轴应用 180 度变换。这似乎有效，但后来我们遇到了[一个问题](https://github.com/flutter/flutter/issues/79519)，即 Flutter 偶尔会覆盖转换，导致视频恢复到未镜像的版本.

在 Flutter 团队的帮助下，我们通过将 `VideoElement` 包装在 [`DivElement`](https://api.flutter.dev/flutter/dart-html/DivElement-class.html) 中并更新 `VideoElement` 元素，让 `VideoElement` 填满 `DivElement` 的宽度和高度，解决了这个问题。这允许我们将镜像应用到视频元素，而无需 Flutter 覆盖变换效果，因为父元素是一个 `div`。这种方法为我们提供了所需的镜像相机视图！

![](https://miro.medium.com/max/2800/0*Zd9s-7LFN9u17Ouo)

<small>非镜像视图</small>

![](https://miro.medium.com/max/2800/0*kkxXNd0m-t4sjCAo)

<small>镜像视图</small>

### 坚持严格的纵横比

对大屏幕执行严格的 4:3 宽高比，对小屏幕执行严格的 3:4 宽高比，这比看起来更难！强制执行此比例非常重要，既要遵守 Web 应用程序的整体设计，又要确保照片在社交媒体上分享时看起来像素完美。这是一项具有挑战性的任务，因为设备上内置摄像头的纵横比差异很大。

为了强制执行严格的纵横比，应用程序首先使用 JavaScript [`getUserMedia` API](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia)。我们使用这个 API，提供给 `VideoElement` 流，也就是我们在相机视图中看到的（当然是镜像的）。我们还应用了 [`object-fit`](https://developer.mozilla.org/en-US/docs/Web/CSS/object-fit) CSS 属性来确保视频元素覆盖其父容器。我们使用 Flutter 的内置 `AspectRatio` 小部件设置纵横比。因此，相机不会对显示的纵横比做出任何假设；它始终返回支持的最大分辨率，然后符合 Flutter 提供的约束（在本例中为 4:3 或 3:4）。

```dart
final orientation = MediaQuery.of(context).orientation;  
final aspectRatio = orientation == Orientation.portrait  
   ? PhotoboothAspectRatio.portrait  
   : PhotoboothAspectRatio.landscape;  
return Scaffold(  
 body: _PhotoboothBackground(  
   aspectRatio: aspectRatio,  
   child: Camera(  
     controller: _controller,  
     placeholder: (_) => const SizedBox(),  
     preview: (context, preview) => PhotoboothPreview(  
       preview: preview,  
       onSnapPressed: () => _onSnapPressed(  
         aspectRatio: aspectRatio,  
       ),  
     ),  
     error: (context, error) => PhotoboothError(error: error),  
   ),  
 ),  
);
```

### 通过拖放添加朋友和贴纸

I/O Photo Booth 体验的很大一部分是与我们最喜欢的 Google 朋友合影并添加道具。我们可以在照片中拖放好友和道具，也可以调整大小和旋转它们，直到获得我们喜欢的图像。不难注意到，将朋友添加到屏幕时，我们可以拖动它们并调整其大小。朋友们也有动画 —— 我们使用了雪碧图来实现这种效果。

```dart
for (final character in state.characters)  
 DraggableResizable(     
   canTransform: character.id == state.selectedAssetId,  
   onUpdate: (update) {  
     context.read<PhotoboothBloc>().add(  
       PhotoCharacterDragged(  
         character: character,   
         update: update,  
       ),  
     );  
   },  
   child: _AnimatedCharacter(name: character.asset.name),  
 ),
```

为了调整对象的大小，我们创建了一个可拖动、可调整大小的小部件，它可以包裹在任何 Flutter 小部件上，在本例中，这是朋友和道具。这个小部件使用了 [`LayoutBuilder`](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html) 根据视口的约束来处理小部件的缩放。在其中，我们使用 [`GestureDetectors`](https://api.flutter.dev/flutter/widgets/GestureDetector-class.html) 连接到 `onScaleStart`、`onScaleUpdate` 和 `onScaleEnd` 回调。这些回调提供有关反映我们对朋友和道具所做更改所需的手势的详细信息。

[`Transform`](https://api.flutter.dev/flutter/widgets/Transform-class.html) 小部件和 4D 矩阵转换将根据我们所做的各种手势处理缩放和旋转朋友和道具，如由多个 `GestureDetector` 报告。

```dart
Transform(  
 alignment: Alignment.center,  
 transform: Matrix4.identity()  
   ..scale(scale)  
   ..rotateZ(angle),  
 child: _DraggablePoint(...),  
)
```

最后，我们创建了一个单独的包来确定我们的设备是否支持触摸输入。可拖动、可调整大小的小部件会根据触摸功能进行调整。在具有触摸输入的设备上，可调整大小的锚点和旋转图标不可见，因为我们可以通过捏和平移来直接操纵图像，而在没有触摸输入的设备（例如我们的桌面设备）上，添加了锚点和旋转图标以适应单击和拖动。

![](https://miro.medium.com/max/3200/0*MVI3wAXUfJdGls5X)

## 优先考虑网络上的 Flutter

### 使用 Flutter 进行 Web 优先开发

这是我们使用 Flutter 构建的首批纯 Web 项目之一，它与移动应用程序具有不同的特性。

我们需要确保该应用程序对任何设备上的任何浏览器都具有[响应性和自适应性](https://flutter.dev/docs/development/ui/layout/adaptive-responsive)。也就是说，我们必须确保 I/O Photo Booth 可以根据浏览器大小进行缩放，并且能够处理移动和 Web 输入。我们通过几种方式做到了这一点：

* **响应式调整大小：** 我们应该能够将浏览器的大小调整为所需的大小，并且 UI 应相应地做出响应。如果我们的浏览器窗口为纵向，则相机将从具有 4:3 纵横比的横向视图翻转为具有 3:4 纵横比的纵向视图。
* **响应式设计：** 桌面浏览器的设计在右侧显示 Dash、Android Jetpack、Dino 和 Sparky，对于移动设备，它们显示在顶部。桌面设计也使用了摄像头右侧的抽屉，移动端使用了 BottomSheet 类。
* **自适应输入：** 如果从桌面访问 I/O Photo Booth，则鼠标点击被视为输入设备。而如果使用的是平板电脑或手机，则使用触摸作为输入。在调整贴纸大小并将其放置在照片中时，这一点尤其重要。移动设备端支持捏合和平移，桌面端支持单击和拖动。

### 可扩展架构

我们还使用了自己的方法为此应用程序构建可扩展的移动应用程序。我们以强大的基础开始 I/O Photo Booth，包括声音空值安全性、国际化以及从第一次提交开始的 100% 单元和小部件测试覆盖率。我们使用了 [flutter_bloc](https://pub.dev/packages/flutter_bloc) 进行状态管理，因为它允许轻松测试业务逻辑并观察应用程序中的所有状态变化。这对于开发人员日志和可追溯性特别有用，因为我们可以准确地看到状态之间的变化并更快地隔离问题。

我们还实现了一个功能驱动的 monorepo 结构。例如，贴纸、分享和实时相机预览都在它们自己的文件夹中实现，其中每个文件夹包含其各自的 UI 组件和业务逻辑。这些与外部依赖项集成，例如位于包子目录中的相机插件。这种架构允许我们的团队并行处理多个功能，而不会中断其他人的工作，最大限度地减少合并冲突，并使我们能够有效地重用代码。例如，UI 组件库是一个单独的包，名为 [`photobooth_ui`](https://github.com/flutter/photobooth/tree/main/packages/photobooth_ui)，相机插件也是单独的。

通过将组件分成独立的包，我们可以提取和开源与此特定项目无关的各个组件。甚至 UI 组件库包也可以为 Flutter 社区开源，类似于 [Material](https://flutter.dev/docs/development/ui/widgets/material) 和 [Cupertino](https://flutter.dev/docs/development/ui/widgets/cupertino) 组件库。

## Firebase + Flutter = 完美匹配

### Firebase 身份验证、存储、托管等

Photo Booth 利用 Firebase 生态系统进行各种后端集成。[`firebase_auth` 包](https://pub.dev/packages/firebase_auth) 支持在应用启动后立即匿名登录用户。每个会话都使用 Firebase 身份验证来创建一个具有唯一 ID 的匿名用户。

当我们打开共享页面时，Firebase 就能够起作用了。我们可以下载照片以保存为个人资料图片，也可以直接分享到社交媒体。如果我们选择下载照片，它会本地存储在我们的设备上。如果选择分享照片，应用会使用 [`firebase_storage`](https://pub.dev/packages/firebase_storage) [package](https://pub.dev/packages/firebase_storage) 将照片存储在 Firebase 中，以便我们可以稍后检索它，以填充社交帖子。

我们在 Firebase 存储桶上定义了 [Firebase 安全规则](https://firebase.google.com/docs/rules) 以使照片在创建后不可变。这可以防止其他用户修改或删除存储桶中的照片。此外，我们使用 Google Cloud 提供的 [对象生命周期管理](https://cloud.google.com/storage/docs/lifecycle) 来定义删除所有 30 天前的对象的规则，但我们也可以请求按照应用程序中列出的说明尽快删除自己的照片。

此应用程序还使用了 [Firebase Hosting](https://firebase.google.com/docs/hosting) 来快速安全地托管网络应用程序。[action-hosting-deploy](https://github.com/FirebaseExtended/action-hosting-deploy) GitHub Action 允许我们根据目标分支自动部署到 Firebase 托管。当我们将更改合并到主分支时，该操作会触发一个工作流，该工作流构建应用程序的开发风格并将其部署到 Firebase 托管。类似地，当我们将更改合并到发布分支时，该操作会触发生产部署。GitHub Action 与 Firebase Hosting 的结合使我们的团队能够快速迭代并始终预览最新版本。

最后，我们使用 [Firebase Performance Monitoring](https://firebase.google.com/products/performance) 来监控关键的 Web 性能指标。

### 使用 Cloud Functions 进行社交

在生成自己的社交帖子之前，我们首先需要确保照片每一个像素都看起来足够完美。最终图像包括一个漂亮的框架以纪念 I/O Photo Booth，并被裁剪为 4:3 或 3:4 的纵横比，以便在社交帖子上看起来很棒。

我们使用 [`OffscreenCanvas`](https://developer.mozilla.org/en-US/docs/Web/API/OffscreenCanvas) API 或 [`CanvasElement`](https://developer.mozilla.org/ en-US/docs/Web/HTML/Element/canvas) 作为 polyfill 合成原始照片以及包含我们的朋友和道具的图层，并生成可以下载的单个图像。[`image_compositor`](https://github.com/flutter/photobooth/tree/main/packages/image_compositor) [包](https://github.com/flutter/photobooth/tree/main/packages/image_compositor ) 处理此处理步骤。

然后，我们利用 Firebase 强大的 [Cloud Functions](https://firebase.google.com/docs/functions) 来协助将照片分享到社交媒体。当我们单击共享按钮时，我们将被带到所选平台上的一个新选项卡，其中包含一个预先填充的帖子。该帖子有一个重定向到我们编写的云函数的 URL。浏览器在分析 URL 时，会检测到云函数生成的动态元信息。此信息允许浏览器在我们的社交帖子中显示照片的精美预览图像以及指向共享页面的链接，我们的关注者可以在其中查看照片并导航回 I/O Photo Booth 应用程序以获取他们自己的照片。

```dart
function renderSharePage(imageFileName: string, baseUrl: string): string {  
 const context = Object.assign({}, BaseHTMLContext, {  
   appUrl: baseUrl,  
   shareUrl: `${baseUrl}/share/${imageFileName}`,  
   shareImageUrl: bucketPathForFile(`${UPLOAD_PATH}/${imageFileName}`),  
 });  
 return renderTemplate(shareTmpl, context);  
}
```

最终产品看起来像这样：

![](https://miro.medium.com/max/2800/0*tXpB_n44hmjGxHXf)

有关如何在 Flutter 项目中使用 Firebase 的更多信息，请查看此 [codelab](https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0)。

## 成品效果

这个项目是构建应用程序的网络优先方法的一个很好的例子。与我们使用 Flutter 构建移动应用程序的经验相比，我们构建这个 Web 应用程序的工作流程是如此相似，这让我们感到惊喜。我们必须考虑诸如视口大小、响应能力、触摸与鼠标输入、图像加载时间、浏览器兼容性以及为 Web 构建所带来的所有其他考虑因素等元素。但是，我们仍然使用相同的模式、架构和编码标准编写 Flutter 代码。我们在为 Web 构建时感到宾至如归。Flutter 软件包的工具和不断发展的生态系统，包括 Firebase 工具套件，使 I/O Photo Booth 成为可能。

![](https://miro.medium.com/max/3200/0*CN8nNM1HaOjg9SfQ)

<small>在 I/O Photo Booth 工作的非常好的 Ventures 团队</small>

我们已经开源了所有代码。查看 GitHub 上的 [photo_booth](https://github.com/flutter/photobooth) 项目！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
