> * 原文地址：[5 optimization tips for your mobile web app for higher user retention](https://levelup.gitconnected.com/5-optimization-tips-for-your-mobile-web-app-for-higher-user-retention-3d6d158aadb7)
> * 原文作者：[Axel Wittmann](https://medium.com/@axelcwittmann)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-optimization-tips-for-your-mobile-web-app-for-higher-user-retention.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-optimization-tips-for-your-mobile-web-app-for-higher-user-retention.md)
> * 译者：
> * 校对者：

# 5 optimization tips for your mobile web app for higher user retention

![Photo by [Jaelynn Castillo](https://unsplash.com/@jaelynnalexis?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9310/0*Cj9Dw7l2u-wSTCqK)

> Your mobile website can be more appealing to mobile users by going beyond css style optimization

As of 2020, internet traffic is around half mobile and half desktop. Google looks to your mobile website version to determine at what position to rank your pages when it indexes. A significant share of young users don’t even use desktop devices at all anymore.

These 3 facts show why optimizing your website for mobile usage is more important than ever. And even more importantly: Mobile users are way more picky and subconsciously irritated by UX issues on mobile devices than desktop users. If there are issues in how your website behaves on a mobile device, it’s highly likely your mobile user retention rate is suffering.

Here are a few tips to optimize your mobile website beyond just using different CSS styles for devices below 600px width.

## 1. Remove mobile ghost shadowing click effects

Native apps don’t have them, mobile browsers do. When you click on any button or anything clickable such as an icon, users on browsers such as Safari or Chrome will see a shadow click effect.

The `\<div>`, `\<button>` or other element that is clicked on will have a brief underlying shadow effect. This effect is supposed to give users feedback that something was clicked on and something should happen as a result. Which makes sense for a lot of interactions on websites.

But what if your website actually is responsive enough already and includes effects for loading data? Or you use Angular, React or Vue and a lot of the UX interaction is instantaneous? It is likely, that the shadow click effect gets in the way of your user experience.

You can use the following code in your style-sheet to get rid of this shadow click effect. Don’t worry, it won’t break anything else, even though you need to include it as a global style.

```css
* { 
  /*prevents tabing highlight issue in mobile */
    -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
    -moz-tap-highlight-color: rgba(0, 0, 0, 0);
}
```

## 2. Use the user-agent to detect whether the user accesses from a mobile device

I am not talking about abandoning style-sheet specific @media code for devices below 600px width. Quite on the contrary. You should always use your style-sheet to make your website mobile friendly.

However, what if there is an additional effect that you want to show based on whether the user is on a mobile device? And you want to include it in your JavaScript functions — and you don’t want this to change if a user changes its smartphone direction (which increases the width beyond 600px).

For these kind of situations, my advice is to use a globally accessible Helper-function that determines based on the user-agent of the browser if the user device is a mobile device or not.

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

## 3. Load mobile versions of larger images

If you use large images and want to make sure that the loading time on mobile is still adequate for your mobile users, always load different versions of images.

You don’t even need JavaScript for it (well, you can also do it with JavaScript too…). For a css version of this strategy, look at the following code.

```html
<!-- ===== LARGER VERSION OF FILE ========== -->
<div class="generalcontainer nomobile">
    <div class="aboutus-picture" id="blend-in-cover" v-bind:style="{ 'background-image': 'url(' + image1 + ')' }"></div>
</div>

<!-- ===== MOBILE VERSION OF FILE ========== -->
<div class="generalcontainer mobile-only">
    <div class="aboutus-picture" id="blend-in-cover" v-bind:style="{ 'background-image': 'url(' + image1-mobile + ')' }"></div>
</div>
```

And in your CSS file, define mobile-only and nomobile.

```css
.mobile-only {   display: none; }

@media (max-width: 599px) {
  ...
  .nomobile {display: none;}
  .mobile-only {display: initial;}
}
```

## 4. Try out endless scrolling and lazy loaded data

If you have large lists such as users or tasks that run into dozens or hundreds, you should consider lazy loading more users when a user scrolls down instead of showing a `load more` or `show more` button. Native apps typically include such a lazy loaded endless scrolling feature.

It is not hard to do so in a mobile web in Javascript frameworks.

You add a reference ($ref) to an element in your template or simply rely on the absolute scroll position of your window.

The following code shows how to implement this effect in a Vue-app. Similar code can be added in other frameworks such as Angular or React.

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

The onScroll function loads data if a user scrolls to a certain element or to the bottom of the page:

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

## 5. Make your modals and popups full width or full screen

Mobile screens have limited space. Sometimes developers forget that and use the same type of interface they use on their desktop version. Especially modal windows are a turn off for mobile users if not implemented correctly.

Modal windows are windows you overlay on top of other content on a page. For desktop users, they can work great. Users very often want to click on the background content to get out of the modal window again — typically when a user decides to not perform the action the modal window suggests.

![](https://cdn-images-1.medium.com/max/4816/1*J7cegVnnZMO7zl6uv357tA.png)

![](https://cdn-images-1.medium.com/max/3912/1*6tVjltC9faX0gnRT25xKaQ.png)

Mobile usage of a website and modals represent a different challenge. Due to the limited screen space, large companies with well designed mobile web apps such as Youtube or Instagram make modals full width or full screen with an ‘X’ on the top of the modal to close it.

This is particularly the case for sign-up modals, which in desktop versions are normal modals windows, while full screen on a mobile version.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
