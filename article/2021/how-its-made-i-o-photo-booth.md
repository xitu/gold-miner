> * 原文地址：[How It’s Made: I/O Photo Booth](https://medium.com/flutter/how-its-made-i-o-photo-booth-3b8355d35883)
> * 原文作者：[Very Good Ventures Team](https://medium.com/@vgv_team?source=post_page-----3b8355d35883--------------------------------)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-its-made-i-o-photo-booth.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-its-made-i-o-photo-booth.md)
> * 译者：
> * 校对者：

# How It’s Made: I/O Photo Booth

![](https://miro.medium.com/max/2800/0*diM5YKjX2b2OgNvD)

We (the folks at Very Good Ventures) teamed up with Google to bring an interactive experience to this year’s Google I/O: a [photo booth](https://photobooth.flutter.dev/)! You can take pictures with well-known Google mascots: [Flutter’s Dash](https://flutter.dev/dash), Android Jetpack, Chrome’s Dino, and Firebase’s Sparky, and decorate photos with stickers, including party hats, pizza, funky glasses, and more. Finally, you can share photos on social media and download them to update your profile picture for the event!

![](https://miro.medium.com/max/2800/0*OQnK58irOAv-Pjzq)

<small>Flutter’s Dash, Firebase’s Sparky, Android Jetpack, and Chrome’s Dino</small>

We built the I/O Photo Booth using [Flutter on the web](https://flutter.dev/web) and [Firebase](https://firebase.google.com/). Because [Flutter now offers support for web apps](/flutter/whats-new-in-flutter-2-0-fe8e95ecc65), we thought it would be a great way to make this app easily accessible to attendees all over the world for this year’s virtual Google I/O. Flutter’s web support eliminates the barrier of having to install an app from an app store and also gives you the flexibility to run it on your device of choice: mobile, desktop, or tablet. That opens up the I/O Photo Booth experience to anyone with access to any browser and device without requiring a download.

Even though I/O Photo Booth was designed to be a web experience, all of the code is written with a platform-agnostic architecture. When native support for elements like the camera plugin are available for their respective platforms, the same code works across all platforms (desktop, web, and mobile).

## Making a virtual photo booth with Flutter

### Building a Flutter camera plugin for the web

The first challenge came with building a camera plugin for Flutter on the web. Initially, we reached out to the team at [Baseflow](https://www.baseflow.com/), because they maintain the existing open source [Flutter camera plugin](https://github.com/Baseflow/flutter-plugins). While Baseflow works on building top-notch camera plugin support for iOS and Android, we were happy to work in parallel on web support for the plugin using the [federated plugin approach](https://flutter.dev/docs/development/packages-and-plugins/developing-packages#federated-plugins). We stuck as closely as possible to the official plugin interface so that we could merge it back into the official plugin when it was ready.

We identified two APIs that would be critical for building the I/O Photo Booth camera experience in Flutter.

1. **Initializing the camera:** The app first needs access to your device camera. On desktop, this is likely the webcam, and on mobile, we chose the front-facing camera. We also provide a desired resolution of 1080p to maximize the camera quality based on your device.
2. **Taking the photo:** We used the built-in [`HtmlElementView`](https://api.flutter.dev/flutter/widgets/HtmlElementView-class.html) that uses platform views to render native web elements as Flutter widgets. In this project, we render a [`VideoElement`](https://api.flutter.dev/flutter/dart-html/VideoElement-class.html) as a native HTML element, which is what you see on the screen before you take your photo. We use a [`CanvasElement`](https://api.flutter.dev/flutter/dart-html/CanvasElement-class.html) that is rendered as another HTML element. This allows us to capture the image from the media stream when you click the take photo button.

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

### Camera permissions

After we got the Flutter Camera plugin working on the web, we created an abstraction to display different UIs depending on the camera permissions. For example, while waiting for you to allow or deny browser camera use, or if there are no available cameras to access, we can display an instructional message.

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

In this abstraction, the placeholder returns the initial UI as the app waits for you to grant permission to the camera. Preview returns the UI after you grant permission and provides the real-time video stream of the camera. The error builder allows us to capture an error if it occurs and renders a corresponding error message.

### Mirroring the photo

Our next challenge was mirroring the photo. If we took the photo using the camera as is, what you’d see isn’t what you’re used to seeing when looking in the mirror. [Some devices have a setting to handle exactly this](https://9to5mac.com/2020/07/09/iphone-mirror-selfie-photos/), so that if you take a photo with the front-facing camera, you’ll see the mirrored version when capturing the photo.

In our first approach, we tried capturing the default camera view, and then applying a 180-degree transform around the y-axis. This appeared to work, but then we ran into [an issue](https://github.com/flutter/flutter/issues/79519) where Flutter would occasionally override the transform, causing the video to revert to the un-mirrored version.

With the help of the Flutter team, we addressed this issue by wrapping the `VideoElement` in a [`DivElement`](https://api.flutter.dev/flutter/dart-html/DivElement-class.html) and updating the `VideoElement` to fill the `DivElement`’s width and height. This allowed us to apply the mirror to the video element without Flutter overriding the transform effect, because the parent element is a `div`. This approach gave us the desired mirrored camera view!

![](https://miro.medium.com/max/2800/0*Zd9s-7LFN9u17Ouo)

<samll>Un-mirrored view</small>

![](https://miro.medium.com/max/2800/0*kkxXNd0m-t4sjCAo)

<small>Mirrored view</small>

### Sticking to a strict aspect ratio

Enforcing a strict aspect ratio of 4:3 for large screens and 3:4 for small screens is harder than it seems! It was important to enforce this ratio both to adhere to the overall design for the web app as well as to ensure that the photo looks pixel perfect when you share it on social media. This was a challenging task, because the aspect ratio of the built-in camera on devices varies widely.

To enforce a strict aspect ratio, the app first requests the maximum resolution possible from the device camera using the JavaScript [`getUserMedia`](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia) [API](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia). We then feed this API into the `VideoElement` stream, which is what you see in the camera view (mirrored, of course). We also applied an [`object-fit`](https://developer.mozilla.org/en-US/docs/Web/CSS/object-fit) CSS property to ensure that the video element covers its parent container. This sets the aspect ratio using the built-in `AspectRatio` widget from Flutter. As a result, the camera doesn’t make any assumptions about the aspect ratio being displayed; it always returns the maximum resolution supported, and then conforms to the constraints provided by Flutter (in this case 4:3 or 3:4).

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

### Adding friends and stickers with drag and drop

A huge part of the I/O Photo Booth experience is taking a photo with your favorite Google friends and adding props. You are able to drag and drop the friends and props within the photo, as well as resize and rotate them until you get an image that you like. You’ll notice that, when adding a friend to the screen, you can drag and resize them. The friends are also animated — sprite sheets to achieve this effect.

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

To resize the objects, we created a draggable, resizable widget that can be wrapped around any Flutter widget, in this case, the friends and props. This widget uses a [`LayoutBuilder`](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html) to handle scaling the widgets based on the constraints of the viewport. Internally, we used [`GestureDetectors`](https://api.flutter.dev/flutter/widgets/GestureDetector-class.html) to hook into `onScaleStart`, `onScaleUpdate`, and `onScaleEnd`. These callbacks provide details about the gesture needed to reflect the changes you make to the friends and props.

The [`Transform`](https://api.flutter.dev/flutter/widgets/Transform-class.html) widget and 4D Matrix transformations handle scaling and rotating the friends and props based on the various gestures that you made, as reported by multiple `GestureDetector`s.

```dart
Transform(  
 alignment: Alignment.center,  
 transform: Matrix4.identity()  
   ..scale(scale)  
   ..rotateZ(angle),  
 child: _DraggablePoint(...),  
)
```

Finally, we created a separate package to determine whether your device supports touch input. The draggable, resizable widget adapts, based on touch capabilities. On devices with touch input, resizable anchors and a rotation icon aren’t visible, because you can pinch and pan to manipulate the image directly, whereas on devices without touch input (such as your desktop device), the anchors and rotation icon are added to accommodate clicking and dragging.

![](https://miro.medium.com/max/3200/0*MVI3wAXUfJdGls5X)

## Prioritizing Flutter on the web

### Web-first development with Flutter

This was one of the first web-only projects that we’ve built with Flutter, and it has different characteristics to a mobile app.

We needed to ensure that the app was both [responsive and adaptive](https://flutter.dev/docs/development/ui/layout/adaptive-responsive) for any browser on any device. That is, we had to make sure that I/O Photo Booth would scale according to browser size and be able to handle both mobile and web inputs. We did this in a few ways:

* **Responsive resize:** You should be able to resize your browser to a desired size, and the UI should respond accordingly. If your browser window is in a portrait orientation, the camera flips from a landscape view with the 4:3 aspect ratio to a portrait view with a 3:4 aspect ratio.
* **Responsive design:** The design for desktop browsers displays Dash, the Android Jetpack, Dino, and Sparky on the right, and for mobile, they appear at the top. The desktop design also uses a drawer on the right side of the camera, and mobile uses the BottomSheet class.
* **Adaptive input:** If you access the I/O Photo Booth from a desktop, then mouse clicks are considered inputs, and if you are on a tablet or phone, touch input is used. This is especially important when it comes to resizing stickers and placing them within the photo. Mobile devices support pinching and panning, and desktop supports click and drag.

### Scalable architecture

We also used our approach to building scalable mobile apps for this application. We started I/O Photo Booth with a strong foundation, including sound null safety, internationalization, and 100% unit and widget test coverage from the first commit. We used [flutter_bloc](https://pub.dev/packages/flutter_bloc) for state management, because it allowed for easily testing business logic and observes all state changes in the app. This is particularly useful for developer logs and traceability, because we could see exactly what changed from state to state and isolate issues more quickly.

We also implemented a feature-driven monorepo structure. For example, stickers, share, and the live camera preview are implemented in their own folders, where each folder contains its respective UI components and business logic. These integrate with external dependencies, such as the camera plugin, which live within the packages subdirectory. This architecture allowed our team to work on multiple features in parallel without disrupting the work of others, minimized merge conflicts, and enabled us to reuse code effectively. For example, the UI component library is a separate package called [`photobooth_ui`](https://github.com/flutter/photobooth/tree/main/packages/photobooth_ui), and the camera plugin is separate as well.

By separating the components into independent packages, we can extract and open source the individual components that aren’t tied to this specific project. Even the UI component library package can be open sourced for the Flutter community, similar to the [Material](https://flutter.dev/docs/development/ui/widgets/material) and [Cupertino](https://flutter.dev/docs/development/ui/widgets/cupertino) component libraries.

## Firebase + Flutter = A perfect match

### Firebase Auth, storage, hosting, and more

Photo Booth leverages the Firebase ecosystem for various backend integrations. The [`firebase_auth`](https://pub.dev/packages/firebase_auth) [package](https://pub.dev/packages/firebase_auth) supports anonymously signing the user in as soon as the app launches. Each session uses Firebase Auth to create an anonymous user with a unique ID.

This comes into play when you arrive at the share page. You can either download your photo to save as your profile picture, or you can share directly to social media. If you download the photo, it’s stored locally on your device. If you share the photo, we store the photo in Firebase using the [`firebase_storage`](https://pub.dev/packages/firebase_storage) [package](https://pub.dev/packages/firebase_storage) so that we can retrieve it later, to populate the social post.

We defined [Firebase Security Rules](https://firebase.google.com/docs/rules) on the Firebase storage bucket to make photos immutable after creation. This prevents other users from modifying or deleting photos in the storage bucket. In addition, we use [Object Lifecycle Management](https://cloud.google.com/storage/docs/lifecycle) provided by Google Cloud to define a rule that deletes all objects that are 30 days old, but you can request to have your photos deleted sooner by following the instructions outlined in the app.

This application also uses [Firebase Hosting](https://firebase.google.com/docs/hosting) for fast and secure hosting of the web app. The [action-hosting-deploy](https://github.com/FirebaseExtended/action-hosting-deploy) GitHub Action allowed us to automate deployments to Firebase Hosting based on the target branch. When we merge changes into the main branch, the action triggers a workflow that builds and deploys the development flavor of the application to Firebase Hosting. Similarly, when we merge changes into the release branch, the action triggers a production deployment. The combination of the GitHub Action with Firebase Hosting allowed our team to iterate quickly and always have a preview of the latest build.

Finally, we used [Firebase Performance Monitoring](https://firebase.google.com/products/performance) to monitor key web performance metrics.

### Getting social with Cloud Functions

Before generating your social post, we first make sure that the photo looks pixel perfect. The final image includes a nice frame to commemorate the I/O Photo Booth and is cropped to the 4:3 or 3:4 aspect ratio so that it looks great on the social post.

We use the [`OffscreenCanvas`](https://developer.mozilla.org/en-US/docs/Web/API/OffscreenCanvas) API or a [`CanvasElement`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/canvas) as a polyfill to composite the original photo, along with the layers, that contain your friends and props, and generate a single image that you can download. The [`image_compositor`](https://github.com/flutter/photobooth/tree/main/packages/image_compositor) [package](https://github.com/flutter/photobooth/tree/main/packages/image_compositor) handles this processing step.

We then tap into Firebase’s powerful [Cloud Functions](https://firebase.google.com/docs/functions) to assist with sharing the photo to social media. When you click the share button, you are taken to a new tab on the selected platform with a pre-populated post. The post has a URL that redirects to the cloud function that we wrote. When the browser analyzes the URL, it detects the dynamic meta information that the cloud function generated. This information allows the browser to display a nice preview image of your photo in your social post and a link to a share page where your followers can view the photo and navigate back to the I/O Photo Booth app to take their own.

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

The final product looks something like this:

![](https://miro.medium.com/max/2800/0*tXpB_n44hmjGxHXf)

For more information about how to use Firebase in your Flutter projects, check out this [codelab](https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0).

## Final product

This project was a good example of a web-first approach to building apps. We were pleasantly surprised by how similar our workflow for building this web application was, compared to our experience building mobile applications with Flutter. We had to consider elements like viewport sizes, responsiveness, touch versus mouse input, image load times, browser compatibility, and all the other considerations that come with building for the web. However, we were still writing Flutter code using the same patterns, architecture, and coding standards. We felt at home while building for the web. The tooling and growing ecosystem of Flutter packages, including the Firebase suite of tools, made I/O Photo Booth possible.

![](https://miro.medium.com/max/3200/0*CN8nNM1HaOjg9SfQ)

<small>Very Good Ventures team who worked on I/O Photo Booth</small>

We’ve open sourced all the code. Check out the [photo_booth](https://github.com/flutter/photobooth) project on GitHub!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
