> * 原文地址：[Using closest() to return the correct DOM element](https://allthingssmitty.com/2019/03/25/using-closest-to-return-the-correct-dom-element/)
> * 原文作者：[Matt Smith](https://allthingssmitty.com/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-closest-to-return-the-correct-dom-element.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-closest-to-return-the-correct-dom-element.md)
> * 译者：
> * 校对者

# Using closest() to return the correct DOM element

I was recently working with a vertical navigation component and ran into a hiccup where the JavaScript code wouldn’t fire depending on where I clicked on the menu item link. I did some digging and thought I’d share a little about what I discovered and how I was able to resolve the problem.

For context, all menu items have two child elements: an icon embedded within the link, as well as a `<span>` element for the label.

```html
<li>
  <a href="#example" class="toggle">
    <img src="/img/billing.svg" width="20" height="20" alt="">
    <span>Billing</span>
  </a>
  <div id="example">
    <ul>
      <li><a href="/statment/">My Statement</a></li>
      <li><a href="/history/">Pay History</a></li>
    </ul>
  </div>
</li>
```

Here I also have a submenu in a `<div>` element and added a touch of JavaScript to give it an open/close toggle:

```js
document.addEventListener('click', function (event) {

  // Make sure clicked element is our toggle
  if (!event.target.classList.contains('toggle')) {
    return;
  }
  event.preventDefault();

  // Get the content
  var content = document.querySelector(event.target.hash);
  if (!content) {
    return;
  }

  // Toggle the content
  toggle(content);

}, false);
```

The `toggle()` method executes a function to check if the submenu has the `.is-visible` CSS class. If the element has that class, the submenu will be hidden; otherwise, the submenu is displayed:

```js
var toggle = function (elem, timing) {

  // If the element is visible, hide it
  if (elem.classList.contains('is-visible')) {
    hide(elem);
    return;
  }

  // Otherwise, show it
  show(elem);
};
```

I expected that clicking anywhere within the menu item would fire the JavaScript and perform the toggle. But if I clicked on either the icon or the label child elements, the JavaScript wouldn’t execute. The reason is that event.target returns the exact DOM element. Clicking on the icon or the label returned only the image or span elements.

## The `closest()` method

This was something I had to look up. I needed the target and return the parent element, not the child elements. I found the solution using the `closest()` method. This method travels up the DOM tree from the current element and returns the closest ancestor that matches the given parameter:

```js
let closestElement = Element.closest(selector); 
```

This was my “ah-ha!” moment. I could chain `closest()` to `event.target` to find and return the parent element (menu item link), regardless if I ended up clicking on the child elements (icon or label):

```js
if (!event.target.closest('a').classList.contains('toggle')) {
  return;
}

var content = document.querySelector(event.target.closest('a').hash);
```

Now clicking anywhere in the menu item link fires the JavaScript to toggle the submenu.

[Play with DEMO and get source code in CODEPEN](https://codepen.io/AllThingsSmitty/pen/WPMPaV)

Hopefully this tip will help you if you need to target specific elements in the DOM. The `closest()` method is supported in most major browsers but requires a polyfill with IE11.

If you’re looking for more in-depth reading on this, I’d recommend Zell Liew’s post on traversing the DOM. He covers this method and a few other tricks that are worth checking out.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
