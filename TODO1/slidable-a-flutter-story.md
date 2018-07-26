> * 原文地址：[Slidable: A Flutter story](https://medium.com/flutter-community/slidable-a-flutter-story-f4a5f55f6a96)
> * 原文作者：[Romain Rastel](https://medium.com/@lets4r?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/slidable-a-flutter-story.md](https://github.com/xitu/gold-miner/blob/master/TODO1/slidable-a-flutter-story.md)
> * 译者：
> * 校对者：

# Slidable: A Flutter story

![](https://cdn-images-1.medium.com/max/800/1*BBp8dGLaZ8v8IHvXUYoZng.png)

### Synopsis

This is the story behind the creation of the **Slidable** widget (available [here](https://pub.dartlang.org/packages/flutter_slidable)). A widget that let you add contextual actions on your list items when you are sliding it to the left or to the right.

### How everything started

I’m a passionate developer. This is what I do for living, but it’s mostly my main hobby ❤️. Some express themselves through words, drawings, music, I express myself through code. I’m more comfortable with variables and functions than with a ball or a racket. This is who I am.

We are in July 2018. It’s sunny ☀️ and kinda hot here in Brittany, France, but instead of enjoying the sun and going to the beach, I’m craving to learn something new and to code.

I’m a huge fan of Flutter and I already published some packages ([flutter_staggered_grid_view](https://github.com/letsar/flutter_staggered_grid_view), [flutter_parallax](https://github.com/letsar/flutter_parallax), [flutter_sticky_header](https://github.com/letsar/flutter_sticky_header)). All of them have something in common: **Slivers**.  
I want to learn something new, remember? So I picked a new subject: animations!

Now that I have something to learn, I need an idea to create something with this knowledge. I remember then, when I discovered Flutter, I thought about 3 widgets that didn’t exist at the moment: A staggered grid view, sticky headers, and a widget allowing the user to reveal contextual menus on the sides of a list item while sliding it to the left or to the right. I didn’t work on the last one, so the idea was found 💡.

### Where to start

It’s always easier to have an example to build on. That’s why every time I want to create something, I start by researching if there is something similar I can tweak.

I started by searching on Pub Dart to see if someone had not already published exactly that, if it had been the case I would have stopped here and I would have looked for a new idea.

I didn’t find what I looked for, so I searched on StackOverflow and find this [question](https://stackoverflow.com/questions/46651974/swipe-list-item-for-more-options-flutter/46662914). Remi Rousselet, a top user, gave this really good [answer](https://stackoverflow.com/a/46662914/3241871).  
I read his code, understand it, and it helped me to build a first prototype. So Remi, if you are reading me, thanks a lot 👏.

### From prototype to first release

After I developed a prototype working with one animation, I immediately thought of letting the developer create it’s own. I remembered of [SliverDelegate,](https://docs.flutter.io/flutter/rendering/SliverGridDelegate-class.html) which let the developer controls the layout of tiles in a grid, and decided to create something similar.

Let the developer customize the animation it’s great, but I have to provide some built-in animations so that any developer could use them, or tweak my animations to create theirs.

That’s why I firstly created 3 delegates:

#### SlidableBehindDelegate

With this delegate, the slide actions stay behind the list item.

![](https://cdn-images-1.medium.com/max/800/1*-lxI0VkO5MCC3PW74VaLWA.gif)

Example of SlidableBehindDelegate

#### SlidableScrollDelegate

With this one, the slide actions scroll in the same direction as the list item.

![](https://cdn-images-1.medium.com/max/800/1*KW9wXmgPGHbCV24gGIl8ZA.gif)

Example of SlidableScrollDelegate

#### SlidableStrechDelegate

With this delegate, the slide actions are growing while the list item is sliding.

![](https://cdn-images-1.medium.com/max/800/1*lwGjFSE0--Ij7U5YbvOiSQ.gif)

Example of SlidableStrechDelegate

#### SlidableDrawerDelegate

And with this one, the slide actions are showing with a sort of parallax effect, like in iOS.

![](https://cdn-images-1.medium.com/max/800/1*OlubJ7rmOK5QgvsC3aVY8Q.gif)

Example of SlidableDrawerDelegate

For the story, when I showed the first 3 delegates to my colleague, [Clovis Nicolas](https://github.com/clovisnicolas), he told me that it would be great to have one like in iOS. As I am not an iOS user, I thought it was more like SlidableStrechDelegate, but no.  
This is how the SlidableDrawerDelegate was born.

### Animations in Flutter

I didn’t wrote about what I learned about animations in Flutter, because there are other contents which explain it well, like [this one](https://proandroiddev.com/animations-in-flutter-6e02ee91a0b2).

But I can share my feeling about animations in Flutter: they are so great and easy to deal with 😍!

I just regret not having played with them before 😃.

### The end

After finishing these built-in delegates, I thought it would be a good initial release. So I made my [GitHub repository](https://github.com/letsar/flutter_slidable) public, and I published it on [Dart Pub](https://pub.dartlang.org/packages/flutter_slidable).

![](https://cdn-images-1.medium.com/max/800/1*FXzo-qRHkPFTZ-hiQwb_gQ.gif)

Slidable widget overview

This is how the **Slidable** widget was born. Now it has to grow. If you want some new feature, you are welcome to create an [issue on GitHub](https://github.com/letsar/flutter_slidable/issues) and explain what you want. If it’s align with my vision of this package, I will be happy to implement it!

You can find some documentation in the [repository](https://github.com/letsar/flutter_slidable), and the above example [here](https://github.com/letsar/flutter_slidable/blob/master/example/lib/main.dart).

If this package is helping you, you can support me by ⭐️the [repo](https://github.com/letsar/flutter_slidable), or 👏 this story.  
You can also follow me on [Twitter](https://twitter.com/lets4r).

Let me know if you build an app with this package 😃.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
