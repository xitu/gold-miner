> * 原文地址：[5 optimization tips for your mobile web app for higher user retention](https://levelup.gitconnected.com/5-optimization-tips-for-your-mobile-web-app-for-higher-user-retention-3d6d158aadb7)
> * 原文作者：[Axel Wittmann](https://medium.com/@axelcwittmann)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-optimization-tips-for-your-mobile-web-app-for-higher-user-retention.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-optimization-tips-for-your-mobile-web-app-for-higher-user-retention.md)
> * 译者：[Roc](https://github.com/QinRoc)
> * 校对者：[niayyy](https://github.com/niayyy-S)，[Freya Yu](https://github.com/ZiXYu)

# 5 个优化技巧助你提高移动 Web 应用的用户留存率

![Photo by [Jaelynn Castillo](https://unsplash.com/@jaelynnalexis?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9310/0*Cj9Dw7l2u-wSTCqK)

> 除了 CSS 样式优化，还可以使用其它的优化方式来增大你的移动网站对移动用户的吸引力。

在 2020 年的互联网流量中，移动端和桌面端各占半壁江山。Google 在索引页面时，会根据网站的移动版本来确定网站排名。相当多的年轻用户甚至不再使用桌面设备。

上述三个事实说明了为什么现在针对移动端访问来优化网站比以往任何时候都重要。更重要的是：移动用户更挑剔，而且潜意识里更容易被移动设备上的 UX（用户体验）问题惹恼。如果你的网站在移动设备上的展示存在问题，那么很可能会影响到移动用户的留存率。

除了为 600 px 宽度以下的设备使用不同的 CSS 样式外，这里还有一些技巧可以优化你的移动网站。

## 1. 去除移动端的阴影点击效果

原生应用没有这些效果，移动浏览器却有。使用 Safari 或 Chrome 等浏览器的用户在点击任何按钮或任何可点击的对象（例如图标）时，会看到阴影点击效果。

`\<div>`， `\<button>` 或其它元素在被点击时，在它的下面会出现一个短暂的阴影效果。这种效果会为用户提供这样的反馈：点击了某些东西后，某个事件应该发生。对于网站上的大量交互而言，这很有意义。

但是，如果你的网站已经做了充分的响应并包含了加载数据的效果呢？或者你使用了 Angular，React 或 Vue，并且很多 UX 交互是瞬时的呢？这些情况下，这种阴影点击效果可能会妨碍用户体验。

你可以在样式表中使用以下代码来移除这种阴影点击效果。请放心，即使你将其添加到全局样式中，它也不会破坏其它任何内容。

```css
* {
  /*阻止移动端标签突出显示点击的问题*/
    -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
    -moz-tap-highlight-color: rgba(0, 0, 0, 0);
}
```

## 2. 使用 user-agent 来检测用户是否来自移动设备

我不是说要在宽度小于 600 px 的设备上放弃样式表中特定的 `@media` 代码。恰恰相反。你应该经常使用样式表来让你的网页对移动端更友好。

然而，当你想要根据用户是否在移动设备上来显示额外的效果呢？你想把这个放到你的 JavaScript 函数中，同时不想它随着用户横向使用手机（这会使宽度增加到超过 600 px）而改变。

对于这些场景，我的建议是使用一个全局访问的辅助函数，基于浏览器的 user-agent 来确定用户的设备是否是一个移动设备。

```js
$_HelperFunctions_deviceIsMobile: function() {
  if (/Mobi/i.test(navigator.userAgent)) {
     return true;
  } else
     {return false;
  }
}
```

![Photo by [Holger Link](https://unsplash.com/@photoholgic?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6716/0*qYl5LnaPjGjQqXfp)

## 3. 加载较大图片的移动版本

如果你在项目中使用了大图片，并且想要确保移动用户仍然可以接受图片的加载时间，那么需要根据设备的不同来加载图片的不同版本。

这个功能甚至不需要使用 JavaScript（当然你也可以用 JavaScript）。这种策略的 CSS 版本实现代码如下所示。

```html
<!-- ===== 文件的较大版本 ========== -->
<div class="generalcontainer nomobile">
    <div class="aboutus-picture" id="blend-in-cover" v-bind:style="{ 'background-image': 'url(' + image1 + ')' }"></div>
</div>

<!-- ===== 文件的移动版本 ========== -->
<div class="generalcontainer mobile-only">
    <div class="aboutus-picture" id="blend-in-cover" v-bind:style="{ 'background-image': 'url(' + image1-mobile + ')' }"></div>
</div>
```

在你的 CSS 文件中定义 `mobile-only` 和 `nomobile` 类选择器。

```css
.mobile-only {   display: none; }

@media (max-width: 599px) {
  ...
  .nomobile {display: none;}
  .mobile-only {display: initial;}
}
```

## 4. 尝试无限滚动和懒加载数据

如果你有一些长列表，比如包含几十或数百的用户或者任务，那么当用户向下滚动的时候，你应该考虑懒加载更多信息，而不是展示一个`加载更多`或者`展示更多`的按钮。原生应用通常包括了这样的懒加载的无限滚动功能。

在移动网页中，使用 JavaScript 框架不难实现这个功能。

你可以把一个参照（$ref）添加到网页模板的一个元素上，或者简单地绑定到窗口的绝对滚动位置。

下面的代码演示了如何在一个 Vue 应用中实现这个效果。相似的代码可以添加到其它的框架中，比如 Angular 或者 React。

```js
mounted() {
  this.$nextTick(function() {
     window.addEventListener('scroll', this.onScroll);
     this.onScroll(); // needed for initial loading on page
  });
},
beforeDestroy() {
   window.removeEventListener('scroll', this.onScroll);
}
```

onScroll 函数会在用户滚动到某个元素或者页面底部时加载数据。

```js
onScroll() {
   var users = this.$refs["users"];
   if (users) {
      var marginTopUsers = usersHeading.getBoundingClientRect().top;
      var innerHeight = window.innerHeight;
      if ((marginTopUsers - innerHeight) < 0) {
          this.loadMoreUsersFromAPI();
      }
   }
}
```

## 5. 用全屏宽度或者全屏幕展示弹出框和弹出窗口

移动端的屏幕空间有限。有时开发者会忘记这种限制，使用和桌面版一样的交互界面。特别是当弹出窗口未能正确实现时，移动用户会不喜欢。

弹出窗口是一个放置在页面中其它内容的顶层的窗口。对于桌面用户来说，它们可以很好地工作。在用户决定不执行弹窗所建议的操作时，常常想要点击背景内容来离开这个弹窗。

![](https://cdn-images-1.medium.com/max/4816/1*J7cegVnnZMO7zl6uv357tA.png)

![](https://cdn-images-1.medium.com/max/3912/1*6tVjltC9faX0gnRT25xKaQ.png)

网站和弹窗在移动端的使用是一个不同的挑战。受限于有限的屏幕空间，具有优秀设计的移动端 Web 应用程序的大公司，比如 YouTube 或者 Instagram，会把弹窗进行全屏宽度或者全屏幕展示，并在弹窗的顶部放置一个“X”来关闭它。

这是注册弹窗的一个典型案例，它的桌面版本是一个普通的弹窗，而移动版本则全屏幕展示。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
