> * 原文地址：[5 CSS Practices To Avoid as a Web Developer](https://betterprogramming.pub/5-css-practices-to-avoid-as-a-web-developer-1b7553c05131)
> * 原文作者：[Alexey Shepelev](https://medium.com/@alexey-shepelev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-css-practices-to-avoid-as-a-web-developer.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-css-practices-to-avoid-as-a-web-developer.md)
> * 译者：
> * 校对者：

# 5 CSS Practices To Avoid as a Web Developer

#### Some bad habits and how to fix them

![Photo by [Pankaj Patel](https://unsplash.com/@pankajpatel) on [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/9874/1*0Ca38BL7C5MRI0qsdAQT3Q.jpeg)

Some people think that CSS is difficult to learn. There are lots of crutches and even some magic, which makes it easy to shoot yourself in the foot. I feel sad about this since I don’t think so.

After some thought about what can be done, I’ve come up with five developer habits that I don’t like and will show you how to avoid them.

---

## 1. Set Margins or Padding and Then Reset Them

I often see people set margins or padding for all elements and then reset them for the first or last element. I don’t know why they use two rules when you can get by with one. It’s much easier to set margins and padding for all the required elements at once.

Use one of the following for simpler and more concise CSS: `nth-child`/`nth-of-type` selectors, the `:not()` pseudo-class, or the adjacent sibling combinator better known as `+`.

Do not do this:

```CSS
.item {
  margin-right: 1.6rem;
}

.item:last-child {
  margin-right: 0;
}
```

You can use:

```CSS
.item:not(:last-child) {
  margin-right: 1.6rem;
}
```

Or:

```CSS
.item:nth-child(n+2) {
  margin-left: 1.6rem;
}
```

Or:

```CSS
.item + .item {
  margin-left: 1.6rem;
}
```

---

## 2. Add display: block for Elements With position: absolute or position: fixed

Did you know that you don’t need to add `display: block` for elements with `position: absolute` or `position: fixed` since it happens by default?

Also, if you use `inline-*` values, they will change as follows: `inline` or `inline-block` will change to `block`, `inline-flex` -> `flex`, `inline-grid` -> `grid`, and `inline-table` -> `table`.

So, just write `position: absolute` or `position: fixed` and add `display` only when you need `flex` or `grid` values.

Do not do this:

```CSS
.button::before {
  content: "";
  position: absolute;
  display: block;
}
```

Or:

```CSS
.button::before {
  content: "";
  position: fixed;
  display: block;
}
```

You can use:

```CSS
.button::before {
  content: "";
  position: absolute;
}
```

Or:

```CSS
.button::before {
  content: "";
  position: fixed;
}
```

---

## 3. Use transform: translate (-50%, -50%) To Center

There was a popular problem that used to cause a lot of trouble. This lasted until 2015, and all its solutions led to some kind of difficulties. I’m talking about centering an element with an arbitrary height along two axes.

In particular, one solution was to use a combination of absolute positioning and the `transform` property. This technique caused blurry text issues in Chromium-based browsers.

But after the introduction of flexbox, this technique, in my opinion, is no longer relevant. The thing is that it cannot solve the problem of blurry text. What’s more, it makes you use five properties. So, I would like to share a trick that can reduce the code to two properties.

We can use `margin: auto` inside a `flex` container and the browser will center the element. Just two properties and that’s it.

Do not do this:

```CSS
.parent {
  position: relative;
}

.child {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
```

You can use:

```CSS
.parent {
  display: flex;
}

.child {
  margin: auto;
}
```

---

## 4. Use width: 100% for Block Elements

We often use flexbox to create a multi-column grid that gradually converts to a single column.

And to convert the grid to one column, developers use `width: 100%`. I don’t understand why they do it. The grid elements are block elements that can do this by default without using additional properties.

So we don’t need to use `width: 100%`, but rather we should write the media query so that flexbox is only used to create a multi-column grid.

Do not do this:

```HTML
<div class="parent">
  <div class="child">Item 1</div>
  <div class="child">Item 2</div>
  <div class="child">Item 3</div>
  <div class="child">Item 4</div>
</div>
```

```CSS
.parent {
  display: flex;
  flex-wrap: wrap;
}

.child {
  width: 100%;
}

@media (min-width: 1024px) {
  .child {
    width: 25%;
  }
}
```

You can use:

```HTML
<div class="parent">
  <div class="child">Item 1</div>
  <div class="child">Item 2</div>
  <div class="child">Item 3</div>
  <div class="child">Item 4</div>
</div>
```

```CSS
@media (min-width: 1024px) {
  .parent {
    display: flex;
    flex-wrap: wrap;
  }

  .child {
    width: 25%;
  }
}
```

---

## 5. Set display: block for Flex Items

When using flexbox, it is important to remember that when you create a flex container (add `display: flex`), all children (`flex` items) become blockified.

This means that the elements are set to `display` and can only have block values. Accordingly, if you set `inline` or `inline-block`, it will change to `block`, `inline-flex` -> `flex`, `inline-grid` -> `grid`, and `inline-table` -> `table`.

So, don’t add `display: block` to `flex` items. The browser will do it for you.

Do not do this:

```CSS
.parent {
  display: flex;
}

.child {
  display: block;
}
```

You can use:

```CSS
.parent {
  display: flex;
}
```

---

## Conclusion

I hope I’ve managed to show you how to avoid simple mistakes and you will take my advice. Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
