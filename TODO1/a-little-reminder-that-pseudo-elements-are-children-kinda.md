> * 原文地址：[A Little Reminder That Pseudo Elements are Children, Kinda.](https://css-tricks.com/a-little-reminder-that-pseudo-elements-are-children-kinda/)
> * 原文作者：[Chris Coyier](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-little-reminder-that-pseudo-elements-are-children-kinda.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-little-reminder-that-pseudo-elements-are-children-kinda.md)
> * 译者：
> * 校对者：

# A Little Reminder That Pseudo Elements are Children, Kinda.

![](https://res.cloudinary.com/css-tricks/image/fetch/w_1200,q_auto,f_auto/https://css-tricks.com/wp-content/uploads/2019/06/pseudo-child.png)

Here's a container with some child elements:

```html
<div class="container">
  <div>item</div>
  <div>item</div>
  <div>item</div>
</div>
```

If I do:

```css
.container::before {
  content: "x"
}
```

I'm essentially doing:

```html
<div class="container">
  [[[ ::before psuedo-element here ]]]
  <div>item</div>
  <div>item</div>
  <div>item</div>
</div>
```

Which will behave just like a child element **mostly**. One tricky thing is that no selector selects it other than the one you used to create it (or a similar selector that is literally a `::before` or `::after` that ends up in the same place).

To illustrate, say I set up that container to be a 2x3 grid and make each item a kind of pillbox design:

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

Without the pseudo-element, that would be like this:

![Six items in a clean two-by-two grid](https://css-tricks.com/wp-content/uploads/2019/06/grid.png)

If I add that pseudo-element selector as above, I'd get this:

![Six items in a two-by-two grid, but with a seventh item at the beginning, pushing elements over by one](https://css-tricks.com/wp-content/uploads/2019/06/pushed-grid.png)

It makes sense, but it can also come as a surprise. Pseudo-elements are often decorative (they should pretty much **only** be decorative), so having it participate in a content grid just feels weird.

Notice that the `.container > *` selector didn't pick it up and make it `darkgray` because you can't select a pseudo-element that way. That's another minor gotcha.

In my day-to-day, I find pseudo-elements are typically absolutely-positioned to do something decorative — so, if you had:

```css
.container::before {
  content: "";
  position: absolute;
  /* Do something decorative */
}
```

...you probably wouldn't even notice. Technically, the pseudo-element is still a child, so it's still in there doing its thing, but isn't participating in the grid. This isn't unique to CSS Grid either. For instance, you'll find by using flexbox that your pseudo-element becomes a flex item. You're free to float your pseudo-element or do any other sort of layout with it as well.

DevTools makes it fairly clear that it is in the DOM like a child element:

![DevTools with a ::before element selected](https://css-tricks.com/wp-content/uploads/2019/06/devtools.png)

There are a couple more gotchas!

One is `:nth-child()`. You'd think that if pseduo-elements are actually children, they would effect [`:nth-child()` calculations](https://css-tricks.com/almanac/selectors/n/nth-child/), but they don't. That means doing something like this:

```css
.container > :nth-child(2) {
  background: red;
}
```

...is going to select the same element whether or not there is a `::before` pseudo-element or not. The same is true for `::after` and `:nth-last-child` and friends. That's why I put "kinda" in the title. If pseudo-elements were exactly like child elements, they would affect these selectors.

Another gotcha is that you can't select a pseudo-element in JavaScript like you could a regular child element. `document.querySelector(".container::before");` is going to return `null`. If the reason you are trying to get your hands on the pseudo-element in JavaScript is to see its styles, you can do that [with a little CSSOM magic](https://css-tricks.com/an-introduction-and-guide-to-the-css-object-model-cssom/):

```javascript
const styles = window.getComputedStyle(
  document.querySelector('.container'),
  '::before'
);
console.log(styles.content); // "x"
console.log(styles.color); // rgb(255, 0, 0)
console.log(styles.getPropertyValue('color'); // rgb(255, 0, 0)
```

Have you run into any gotchas with pseudo-elements?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
