> * 原文地址：[5 Animation Packages You Can Immediately Use Inside Your Ionic App](https://devdactic.com/5-animation-packages-ionic/?utm_source=mobiledevweekly&utm_medium=email)
> * 原文作者：[devdactic.com](https://devdactic.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-animation-packages-ionic.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-animation-packages-ionic.md)
> * 译者：
> * 校对者：

# 5 Animation Packages You Can Immediately Use Inside Your Ionic App

![](https://i1.wp.com/devdactic.com/wp-content/uploads/2019/01/ionic-5-animation-packages.png?resize=720%2C400&ssl=1)

With Ionic and Angular you have a lot of options when it comes to animations inside your app. You can actually get started with Angular Animations or any other package that you can install in a matter of minutes!  

In this post we will inspect **5 different animation packages** that we can plug into our app to create and use predefined animations or to have a framework where we can easily define animations.

![ionic-animation-packages-example](https://i1.wp.com/devdactic.com/wp-content/uploads/2019/01/ionic-animation-packages-example-526x1024.gif?resize=526%2C1024&ssl=1)

You can start a blank Ionic 4 app like this to better follow some of the snippets:

```
ionic start animationPackages blank --type=angular
```

We’ll not have the full excerpt but only show the important parts of how to integrate each package.

## 1. [Anime.js](https://github.com/juliangarnier/anime)

This package can be installed and used immediately inside our app without anything further to include. Simply run the install like this and you are ready:

```
npm install animejs
```

With this package you can create great **animations within your Javascript code**. This is the area where most packages differ: They either allow to add CSS classes or they allow to create special animations using a specific syntax within your class.

With Anime.js you can easily animate elements on the screen and move them around, so this is the code for creating a little box (plus some CSS so the box actually has a size on the screen) and then a function to create the animation.

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

For the target we can simply use the CSS class of the element we want to animate. The other parameters are pretty much self-explanatory and that’s great about this package:

You can **get started quickly and create powerful animations** with basic commands that you’ll understand fast. You won’t have to study a long API to create your first animations with this package.

## 2. [Magic CSS](https://github.com/miniMAC/magic)

The next package relies on pre defined CSS animations that can be added to your elements. You can install the package just like before:

```
npm install magic.css
```

But this time you also need to import the actual CSS file from the node module, and in order to do so you’ll have to change your **src/global.scss** and add another import like this:

[![](https://i1.wp.com/devdactic.com/wp-content/uploads/2017/07/academy-ad.png?ssl=1)](http://ionicacademy.com/?utm_source=devtut&utm_medium=ad3)

Import CSS from node modules

```
@import '~magic.css/magic.min.css';
```

Now the animations of Magic CSS are available within your app and you can either directly add them as classes on your element or, if you want to use them at a specific time, add them to the `classList` of an element that you can get by using the `@ViewChild()` annotation like this:

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

You’ll always add the **magictime** class and then the actual name of the animation you want to use.

This package doesn’t offer so many customisation options but if you want **simple and fast CSS animations** you can give it a try!

## 3. [Number Flip](https://github.com/gaoryrt/number-flip)

This is not a huge animation package but I discovered it recently and really enjoyed the animation. It’s only useful if you want to have one specific effect inside your app like you can see on the Github page, but the integration works easy again like:

```
npm install number-flip
```

Now let’s say you have some sort of counter inside the top bar of your Ionic app and want to change numbers and do it with style.

In this case the number flip package is awesome as you can flip an element from one number to another with a cool animation. I’ve added some code that creates the reference to the element once and when you later trigger the `flip()` function again it will simply call `flipTo()` of the animation package:

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

Of course this package doesn’t replace more advanced animations but **it handles one specific case really great** so keep it in mind if you work with timers or numbers that you need to animate!

## 4. [Animate CSS](https://github.com/daneden/animate.css)

This is most likely the biggest player of all and the one with most Github stars. This package advertises with “Just-add-water CSS animation” and it’s really that simple. The installation works like before:

```
npm install animate.css
```

Because this package relies on its CSS again we have to add an import to the **src/global.scss** again if we want to use it:

Import CSS from node modules

```
@import '~animate.css/animate.min.css';
```

Now we can enjoy all the awesome predefined animations of this package (there’s really an animation for every use case) and we can even add additional classes like `infinite` so the animation repeats all the time or directly add a delay to the start of the animation.

In one example I animated an ngFor using the index for the delay (ok, might be a bit long in a real world app though) and also used the `ViewChildren` list to add a class if we want to fly out the elements of the list.

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

If you want a **great arsenal of predefined CSS animations** this package is definitely the one you should give a try. While it has a lot of pre defined stuff you can still compose the things to fit your needs!

## 5. [Bounce.js](https://github.com/tictail/bounce.js)

Finally I wanted to test another more flexible package where we can compose our animations from Javascript again. The package can be installed just like the others:

```
npm install bounce.js
```

This package has a big documentation so you’ll likely spend some time exploring all the options, for one example I just picked one of the advertised snippets on their page:

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

As you can see, everything happens inside your Javascript code! You can **create huge keyframe animations** with this package and define all steps very granular.

This flexibility comes at a price, you have to dig into the docs and it’ll take more time to get started then with the other packages. Still, if you can invest the time it will pay off as you’ll be able to create exactly the animations your app needs!

## Conclusion

Some of these packages give you fast results, others come with their own syntax that you have to learn. Some have everything pre defined while others allow more flexibility when it comes to creating animations. Some are just CSS, some just JS.

There’s not really “the best” as all of them have their strengths in different areas. Also, it’s always a good idea to keep an eye on the package size of your app and don&##8217;t add anything that hurts your download rate in the end.

Finally, besides all these packages you can of course as well use the standard **Angular animations** and there’s a special course dedicated to that topic inside [the Ionic Academy](https://ionicacademy.com/) as well!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
