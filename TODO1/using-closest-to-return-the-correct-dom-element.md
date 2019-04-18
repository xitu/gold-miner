> * 原文地址：[Using closest() to return the correct DOM element](https://allthingssmitty.com/2019/03/25/using-closest-to-return-the-correct-dom-element/)
> * 原文作者：[Matt Smith](https://allthingssmitty.com/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-closest-to-return-the-correct-dom-element.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-closest-to-return-the-correct-dom-element.md)
> * 译者：[LucaslEliane](https://github.com/lucasleliane)
> * 校对者：[ZYuMing](https://github.com/ZYuMing)，[Moonliujk](https://github.com/Moonliujk)

# 使用 closest() 函数获取正确的 DOM 元素

最近我在使用垂直导航组件的时候遇到了一个问题：点击菜单项的时候，对应的 JavaScript 代码并没有触发。我对这个问题进行了比较深入的了解之后，分享下解决这个问题的过程以及在这过程中发现的技巧。

这个问题的场景是这样的，所有的菜单项都有两个子元素：一个图标，以及一个作为标签的 `<span>` 元素，这两个元素均嵌入到了链接中。

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

在 `<div>` 元素中还有二级菜单，我添加了一些 JavaScript 来控制二级菜单的开启/关闭状态。

```js
document.addEventListener('click', function (event) {

  // 保证点击的元素是可以切换开关状态的
  if (!event.target.classList.contains('toggle')) {
    return;
  }
  event.preventDefault();

  // 获取元素内容
  var content = document.querySelector(event.target.hash);
  if (!content) {
    return;
  }

  // 切换内容的开启/关闭状态
  toggle(content);

}, false);
```

`toggle` 方法会触发一个函数，这个函数会检查二级菜单是否有 `.is-visible` CSS 类。如果元素具有这个类，那么二级菜单将会被隐藏，否则会显示二级菜单：

```js
var toggle = function (elem, timing) {

  // 如果二级菜单是可见的，那么就隐藏它
  if (elem.classList.contains('is-visible')) {
    hide(elem);
    return;
  }

  // 否则，展示二级菜单
  show(elem);
};
```

我希望点击菜单项中的任何位置，都会触发 JavaScript 并且执行切换操作。但是如果我点击图标或者标签子元素，JavaScript 就不会执行。原因是 event.target 返回到的是实际点击到的 DOM 元素。点击图标或者标签只会返回图标或者标签元素。

## `closest()` 方法

我需要获取到触发了点击事件的目标，并且返回其父元素，而不是子元素。我采用了使用 `closest()` 方法的解决方案。这个方法会从当前元素开始，遍历 DOM 树，并且返回和给定参数匹配的最近的祖先：

```js
let closestElement = Element.closest(selector); 
```

这段代码让我醍醐灌顶。我可以通过 `closest()` 和 `event.target` 来找到并且返回父元素（菜单项链接），无论我点击的是哪个子元素（图标或者标签）：

```js
if (!event.target.closest('a').classList.contains('toggle')) {
  return;
}

var content = document.querySelector(event.target.closest('a').hash);
```

现在，点击菜单项的任何地方都会触发 JavaScript 并且切换二级菜单了。

[可以在 CODEPEN 上尝试一下，并且还有源码。](https://codepen.io/AllThingsSmitty/pen/WPMPaV)

希望这个小窍门可以帮助你定位特定的 DOM 元素。`closest()` 方法在大多数主流浏览器上都是支持的，但是在 IE11 上需要引入 polyfill。

如果你需要更加深入的了解本文相关的内容，我推荐 [Zell Liew 的关于遍历 DOM 元素的文章](https://zellwk.com/blog/dom-traversals/)。他介绍了本文使用的这种方法以及其他一些值得一试的技巧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
