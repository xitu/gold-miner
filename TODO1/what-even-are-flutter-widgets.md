> * 原文地址：[What even are Flutter widgets?](https://medium.com/fluttery/what-even-are-flutter-widgets-ce537a048a7d)
> * 原文作者：[Matt Carroll](https://medium.com/@mattcarroll?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-even-are-flutter-widgets.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-even-are-flutter-widgets.md)
> * 译者：
> * 校对者：

# What even are Flutter widgets?

![](https://cdn-images-1.medium.com/max/2000/1*y0VtCCdwj9zhk9dGu7wlog.png)

_The following explanation of Flutter widgets is my own personal perspective and does not constitute an official explanation of widgets or related areas of the Flutter framework. Please refer to official Flutter documentation for information about how the Flutter team thinks about Flutter._

Flutter is a mobile UI framework that makes UI development fun, quick, and easy. But it feels really weird to go from traditional Android and iOS to Flutter. The reason it feels weird is because we go from mutable, long-lived `View`s and `UIView`s to these immutable, short-lived `Widget` things. What are they, and why do they work?

Recently a Medium article was written about how [Widgets relate to Elements and RenderObjects](https://medium.com/flutter-community/flutter-what-are-widgets-renderobjects-and-elements-630a57d05208). I recommend that article and I recommend that you keep researching until you fully understand the content in that article. But for those of you already lost at the `Widget` level, allow me to offer an explanation that might help.

### Traditional Views and view models

I have long been a proponent of using view models in mobile UI development.

Whether you’re working on Android or iOS, consider a custom `View`, or `UIView`, called `ListItemView`. This `ListItemView` displays an icon on the left, then a title above a subtitle directly to the right of the icon, and finally an optional accessory on the right side:

![](https://cdn-images-1.medium.com/max/1600/1*a5OR1jqUJrjEsW1XtNrijg.png)

When defining this custom `View`, you could make each presentation option an independent property:

```
myListItemView.icon = blah;  
myListItemView.title = “blah”;  
myListItemView.subtitle = “blah”;  
myListItemView.accessory = blah;
```

This technically works, but it comes with an architectural cost. By defining each of these configurations independently, your presentation `Object` requires a reference to your `View` so that it can configure each of these properties. However, if you use a view model then your presentation `Object` can operate without any reference to a `View` which means your presentation `Object` can be unit tested and it avoids a compile-time dependency on your concrete `View`:

```
class ListItem {  
  final Icon icon;  
  final String title;  
  final String subtitle;  
  final Icon accessory;  
  ...  
}

// Use a Presenter to create a new view model.  
myListItem = myPresenter.present();

// Pass the view model into the View to render the new presentation.  
myListItemView.update(myListItem);
```

This rationale for using view models has nothing to do with Flutter, but it’s important that you understand what a view model is, as compared to a traditional `View`. The view model is an immutable configuration that needs to be applied to a long-lived, mutable `View`.

The dependency relationship in traditional Android and iOS is as follows:

```
MyAndroidView -> MyAndroidViewModel

MyiOSUIView -> MyiOSViewModel
```

In other words, in traditional Android and iOS we work primarily with the mutable, long-lived `View`s (and `UIView`s). We define layout XML, storyboards, and programmatic layouts by working with those long-lived `View` (and `UIView`) `Object`s. Then, we occasionally pass in new view models to change their appearance.

Now let’s talk Flutter.

### Flutter reverses the relationship

Instead of working with mutable, long-lived `View`s that occasionally receive new view models, how about we work almost exclusively with immutable view models that occasionally configure mutable, long-lived views?

Instead of:

```
MyView -> MyViewModel
```

Let’s do:

```
MyViewModel -> MyView
```

And just like that, in a very high-level nutshell, we just invented Flutter’s widget system:

```
MyWidget -> MyElement  
MyWidget -> MyRenderObject
```

Widgets are immutable and they contain a bunch of properties that are used to configure how something is rendered:

```
// This Widget sure looks a lot like a view model, doesn't it?  
new Container(  
  width: 50.0,  
  height: 50.0,  
  padding: EdgeInsets.all(16.0),  
  color: Colors.black,  
);

// The one difference between a Flutter Widget and a traditional  
// view model is that Widgets also carry a responsibility to  
// instantiate their long-lived view:  
final mutableSubtree = myContainer.createElement();  
final mutableRender = myContainer.createRenderObject();
```

But why does the Widget create 2 things? I thought the Widget just created a single, long-lived view?

Well, in Flutter the concept of parent/children exists independently of rendering. In iOS and Android the parent/children relationship is one-and-the-same with the concept of drawing to the screen.

For example, in Android a ViewGroup is responsible for:

```
// Parent/Children relationships:  
myViewGroup.addView(...);  
myViewGroup.removeView(...);

// ...and...

// Layout and painting:  
myViewGroup.measure(...);  
myViewGroup.layout(...);  
myViewGroup.draw(...);
```

In Flutter, we have:

```
// Elements for parent/children relationships:  
myElement.mount(); // This creates and adds children  
myElement.forgetChild(...); // Removes a child

// RenderObjects for layout and painting:  
myRenderObject.layout();  
myRenderObject.paint();
```

So even though a Widget in Flutter is responsible for creating an `Element` and a `RenderObject`, those 2 `Object`s combined represent the same set of responsibilities as a single `ViewGroup` in Android.

Thus, in Flutter we work with view models that configure their views, instead of working with `View`s that are configured with their view models. The relationship is inverted.

### Why the inversion is a big deal

It might feel strange to invert the view model relationship. It might especially feel strange that a view model knows how to instantiate the equivalent of a long-lived view. But what Flutter shows us is that by inverting this relationship we achieve the ability to compose user interfaces declaratively.

In my opinion, what Flutter is doing, fundamentally, is approaching a domain-specific language for painting pixels.

Domain-specific languages are the philosophical goal of pretty much any developer. If you’re working on an app for the airline industry then you’re spending a lot of your time constructing implementations of industry-specific terminology like flight manifest, boarding pass, seat assignment, and membership status. You’re utilizing lower level language semantics to compose a representation of what these terms mean in your industry. Then, ideally, at some point developers will stop using low level constructs and they’ll start implementing entire applications using `Object`s like `FlightManifest`, `BoardingPass`, and `SeatAssignment`.

But not every problem is a business problem. Some problems are technical problems, e.g., rendering. Rendering user interfaces is a problem domain within itself. Flutter is solving this problem by engineering a domain-specific language for rendering user interfaces. Just like SQL is a declarative domain-specific language for searching information, Flutter’s widget system is becoming a declarative domain-specific language for composing user interfaces. This is made possible by placing immutable view models on the outside, while confining mutable views to the inside.

Hopefully this perspective will help you understand and appreciate widgets in Flutter. But if not, just keep playing with the Flutter API and eventually it will sink in.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
