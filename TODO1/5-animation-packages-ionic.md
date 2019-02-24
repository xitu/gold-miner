> * 原文地址：[5 Animation Packages You Can Immediately Use Inside Your Ionic App](https://devdactic.com/5-animation-packages-ionic/?utm_source=mobiledevweekly&utm_medium=email)
> * 原文作者：[devdactic.com](https://devdactic.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-animation-packages-ionic.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-animation-packages-ionic.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[Mcskiller](https://github.com/Mcskiller)

# 5 个可以立刻在你的 Ionic App 中用上的动画包

![](https://i1.wp.com/devdactic.com/wp-content/uploads/2019/01/ionic-5-animation-packages.png?resize=720%2C400&ssl=1)

使用 Ionic 与 Angular 有许多方法可以让你在你的 app 中制作动画。你可以直接使用 Angular Animations，也可以使用其它的包（仅需几分钟就能装好）来实现动画。

在本文中我们将介绍 **5 个不同的动画包**，可以轻松地将它们引入你的 APP，使用它们预设的动画或者利用这几个框架轻松自定义动画效果。

![ionic-animation-packages-example](https://i1.wp.com/devdactic.com/wp-content/uploads/2019/01/ionic-animation-packages-example-526x1024.gif?resize=526%2C1024&ssl=1)

你可以使用以下代码初始化一个空白的 Ionic 4 App：

```
ionic start animationPackages blank --type=angular
```

我们不会完整地摘录这些包的文档，只会展示如何将它们整合进你的 App 这一重要部分。

## 1. [Anime.js](https://github.com/juliangarnier/anime)

只要安装好这个包，不需要任何别的操作就能将它引入你的 App 中了。你只需要简单地按照下列代码即可：

```
npm install animejs
```

通过它你可以让你**在你的 Javascript 代码中**创建动画。这也是它与绝大多数包不同的地方：别的包大多是通过添加 CSS class，或者在你的 class 中用特定的语法来创建动画的。

通过 Anime.js，你能轻松地为屏幕中的元素设定动画并移动它们。下面是创建一个小方块，并用一个函数来创建动画效果的代码（我们给小方块加了一些 CSS 样式，这样它才能在屏幕上有一定的大小）：

```
// HTML
<div class="animate-me" #box></div>
  
// SCSS
 
.animate-me {
    width: 50px;
    height: 50px;
    padding: 20px;
    background: #0000ff;
}
 
// TS
import * as anime from 'animejs';
 
callAnime() {
    anime({
      targets: '.animate-me',
      translateX: [
        { value: 100, duration: 1200 },
        { value: 0, duration: 800 }
      ],
      rotate: '1turn',
      backgroundColor: '#ff00ff',
      duration: 2000
    });
}
```

我们可以用元素的 CSS class 来轻松指定应用动画效果的目标（即 target 参数），其它的参数都不言自明。这也是这个包的强大之处：

你可以轻松理解这个包的一些基本命令，**快速上手并创建强大的动画效果**。如果选择用这个包来创建动画，你不需要学习又臭又长的 API。

## 2. [Magic CSS](https://github.com/miniMAC/magic)

这个包依赖于预设好的 CSS 动画，你可以将这些动画加入到元素中。安装方式与前文相同：

```
npm install magic.css
```

不过此时你需要从 node module 将实际的 CSS 文件导入进来，因此你得用类似下面的方法来修改你的 **src/global.scss**：

```
@import '~magic.css/magic.min.css';
```

现在可以在你的 app 中用 Magic CSS 了。你可以直接在元素上添加动画的 class，或者用下面这种方式通过 `@ViewChild()` 标注将动画 class 加入到元素的 `classList` 中去，这样就能在特定的时间来创建动画了：

```
// HTML
<div class="animate-me" #box></div>
 
// TS
@ViewChild('box') box: ElementRef;
 
doMagic() {
    this.box.nativeElement.classList.add('magictime');
    this.box.nativeElement.classList.add('foolishIn');
}
```

每次你都要先加入 **magictime** class，然后加入你要用的动画的 class 名。

这个包没有提供那么多的自定义选项，不过如果你只需要**简单且快速的 CSS 动画**，试试它准没错！

## 3. [Number Flip](https://github.com/gaoryrt/number-flip)

这是一个小巧的包。我最近才发现它，非常喜欢它的动画。不过只有在一种特定的情景下，你才会需要将它加入你的 app（你可以看看它的 Github page，那里面的效果就是它唯一的效果）。安装方式很简单，依然是：

```
npm install number-flip
```

假设你的 Ionic app 的顶栏上有一些计数器，现在你希望通过动画效果来修改它的数字。

这个情景中，number flip 包就非常好用，你可以用帅帅的动画效果让一个元素翻转，并在翻转时修改元素里面的数字。我用一些代码创建了对该元素的引用，当触发 `flip()` 函数的时候会直接调用动画包里面的 `flipTo()` 函数：

```
// HTML
<ion-header>
  <ion-toolbar>
    <ion-title>
      Ionic Animations
    </ion-title>
    <ion-buttons slot="end">
      <div #numberbtn></div>
    </ion-buttons>
  </ion-toolbar>
</ion-header>
 
// TS
import { Flip } from 'number-flip';
 
@ViewChild('numberbtn', { read: ElementRef }) private btn: ElementRef;
 
flip() {
  if (!this.flipAnim) {
    this.flipAnim = new Flip({
      node: this.btn.nativeElement,
      from: '9999',
    });
  }
 
  this.flipAnim.flipTo({
    to: Math.floor((Math.random() * 1000) + 1)
  });
}
```

当然这个包没有任何别的高级动画效果，它**仅仅在这种特殊情景下特别好用**。如果你要使用计时器或者创建数字动画，考虑考虑它吧！

## 4. [Animate CSS](https://github.com/daneden/animate.css)

它可是一位重磅玩家，在这几个包中就属它的 Github star 最多。它的口号是“像倒水一样添加 CSS 动画”，事实上它的用法确特别简单。安装方法和前文一样：

```
npm install animate.css
```

由于这个包依赖于 CSS，因此使用它前我们也要通过下面的方式将 CSS 文件导入 **src/global.scss** 中：

```
@import '~animate.css/animate.min.css';
```

现在，我们就可以享受这个包各种预设好的超帅的 CSS 动画了（每个用例都对应着一种动画）。我们还可以添加一些其它的 class，比如说 `infinite` 让动画循环播放，或者让动画延迟一段时间播放。

在下面的例子中，我们 ngFor 和它的 index 来定义不同的动画延迟（当然在真实的 app 中不会有这么慢的动画），然后用 `ViewChildren` 列表来为需要飞出来的元素增加相应的动画 class：

```
// HTML
<h1 text-center class="animated infinite rubberBand delay-1s">Example</h1>
 
<ion-list>
    <ion-item *ngFor="let val of ['First', 'Second', 'Third']; let i = index;" 
    class="animated fadeInLeft delay-{{ i }}s" #itemlist>
      {{ val }} Item
    </ion-item>
</ion-list>
 
// TS
@ViewChildren('itemlist', { read: ElementRef }) items: QueryList<ElementRef>;
 
animateItems() {
  let elements = this.items.toArray();
  elements.map(elem => {
    return elem.nativeElement.classList.add('zoomOutRight')
  })
}
```

如果你想要个**预设好大量 CSS 动画的武器库**，你一定要试试它。虽然它已经预设好了很多东西，但你也可以根据你的需要来进行组合！

## 5. [Bounce.js](https://github.com/tictail/bounce.js)

最后，我想测试这个特别灵活的包。它也可以用 Javascript 来编写动画。这个包的安装方法和其它几个包一样：

```
npm install bounce.js
```

这个包的文档非常完整，你可能要多花一点时间来探索所有的配置，比如下面是他们页面广告中的一个片段：

```
// HTML
<ion-button expand="block" (click)="bounce()" #bouncebtn>Bounce</ion-button>
 
// TS
import * as Bounce from 'bounce.js';
 
@ViewChild('bouncebtn', { read: ElementRef })bouncebtn: ElementRef;
 
bounce() {
  var bounce = new Bounce();
  bounce
    .translate({
      from: { x: -300, y: 0 },
      to: { x: 0, y: 0 },
      duration: 600,
      stiffness: 4
    })
    .scale({
      from: { x: 1, y: 1 },
      to: { x: 0.1, y: 2.3 },
      easing: "sway",
      duration: 800,
      delay: 65,
      stiffness: 2
    })
    .scale({
      from: { x: 1, y: 1 },
      to: { x: 5, y: 1 },
      easing: "sway",
      duration: 300,
      delay: 30,
    })
    .applyTo(this.bouncebtn.nativeElement);
}
```

如你所见，所有步骤都在你的 Javascript 代码中。你可以用这个包在任何粒度上**创建复杂的关键帧动画**。

不过这种灵活性是要付出代价的，你需要深入地研究它的文档，因此比起其它的包你需要更多的时间才能入门。不过，如果你付出了时间，它也会回报你的付出：你可以用它在 app 中创建任何你想要的动画！

## 总结

在推荐的这几个包中，有一些包可以让你快速做出产品，有些包则需要你学习它们的语法；有些包已经预设好了一切动画，而有些包则可以让你创建更灵活的动画；有些包是纯 CSS，还有一些是纯 JS。

没有哪个是真正“最好的”，因为它们在不同的场景下有着各自的优势。另外，注意这些包的大小也是一件重要的事，你也不希望加太多的东西影响 app 的下载时间吧。

最后打个广告，除了这些包之外你也可以使用标准的 **Angular animations** 来制作动画。[Ionic Academy](https://ionicacademy.com/) 有一个特别课程专门介绍这块内容哦！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
