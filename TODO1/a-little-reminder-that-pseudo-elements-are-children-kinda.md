> * 原文地址：[A Little Reminder That Pseudo Elements are Children, Kinda.](https://css-tricks.com/a-little-reminder-that-pseudo-elements-are-children-kinda/)
> * 原文作者：[Chris Coyier](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-little-reminder-that-pseudo-elements-are-children-kinda.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-little-reminder-that-pseudo-elements-are-children-kinda.md)
> * 译者：[Badd](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[lgh757079506](https://github.com/lgh757079506), [Moonliujk](https://github.com/Moonliujk)

# 小提示：伪元素是子元素，吧。

![](https://res.cloudinary.com/css-tricks/image/fetch/w_1200,q_auto,f_auto/https://css-tricks.com/wp-content/uploads/2019/06/pseudo-child.png)

请看下列代码，一个有若干子元素的容器：

```html
<div class="container">
  <div>item</div>
  <div>item</div>
  <div>item</div>
</div>
```

如果我这样写：

```css
.container::before {
  content: "x"
}
```

实质上等效于：

```html
<div class="container">
  [[[ 在此插入 ::before 伪元素 ]]]
  <div>item</div>
  <div>item</div>
  <div>item</div>
</div>
```

该伪元素大体上像是一个子元素。棘手的是，除了 `::before` 这个创造了该伪元素的选择器（或者一个类似的在相同位置以一个 `::before` 或者 `::after` 结尾的选择器），再无其他选择器能够选中它。

举例来说，假设我将容器设置为一个 2×3 的网格，并将每个子元素都设置成药片格子风格：

```css
.container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-gap: 0.5rem;
}

.container > * {
  background: darkgray;
  border-radius: 4px;
  padding: 0.5rem;
}
```

不使用伪元素时，效果如下：

![六个子元素两两排列，形成整齐网格](https://css-tricks.com/wp-content/uploads/2019/06/grid.png)

如果我把上述伪元素选择器加上，将会得到如下效果：

![六个子元素两两排列，但开头多出了一个子元素，把整体子元素向后挤开了一格](https://css-tricks.com/wp-content/uploads/2019/06/pushed-grid.png)

这合情合理，但也可能会是一个坑。伪元素常常作为装饰元素出现（它们差不多也**只**应该用作装饰），因此，把它们规划到网格布局之中就会显得很怪异。

注意，选择器 `.container > *` 并未选中伪元素，未能使其背景色变为 `darkgray`，因为用这把枪射不中伪元素。这是伪元素的另一个小圈套。

在日常开发中，我发现伪元素的用途通常是通过绝对定位来实现某些装饰效果 —— 因此，如果你写过这样的代码：

```css
.container::before {
  content: "";
  position: absolute;
  /* 一些装饰效果 */
}
```

你甚至可能不会注意到你添加了一个元素。技术上来讲，伪元素归根到底是一个子元素，所以它会尽到一个子元素应尽的义务，但参与网格布局可不在其义务之内。并不是只有 CSS 网格布局如此。例如，你会发现在应用 Flex 布局时，伪元素就会成为 Flex 布局中的子项。你也可以对伪元素任意设置浮动，或其他形式的布局。

在调试工具中可以很清楚地看到，伪元素在 DOM 中的表现恰如一个子元素：

![在调试工具中选中一个 ::before 元素](https://css-tricks.com/wp-content/uploads/2019/06/devtools.png)

还有更多的机关暗道呢！

其中之一就是 `:nth-child()`。你会觉得既然伪元素是实实在在的子元素，那么它们就应该会被 [`:nth-child()`](https://css-tricks.com/almanac/selectors/n/nth-child/) 计算到，实际上并非如此。也就是说像这样的操作：

```css
.container > :nth-child(2) {
  background: red;
}
```

将会选中同一个元素，无论是否存在伪元素 `::before`。对 `::after` 和 `:nth-last-child` 亦是同理。这就是我在文字标题中加了“吧”的原因。如果伪元素是货真价实的子元素，那么它们理应能够干预选择器的命中。

还有一个机巧之处，在 JavaScript 中，你无法像选中常规子元素那样选中伪元素。`document.querySelector(".container::before");` 将会返回 `null`。如果你想用 JavaScript 获取到伪元素是因为想获取其样式，你可以使用一点 [CSSOM 魔法](https://css-tricks.com/an-introduction-and-guide-to-the-css-object-model-cssom/)来实现：

```javascript
const styles = window.getComputedStyle(
  document.querySelector('.container'),
  '::before'
);
console.log(styles.content); // "x"
console.log(styles.color); // rgb(255, 0, 0)
console.log(styles.getPropertyValue('color'); // rgb(255, 0, 0)
```

你是否中过伪元素的那些小圈套？

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
