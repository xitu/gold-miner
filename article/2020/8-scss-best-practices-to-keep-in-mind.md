> * 原文地址：[8 SCSS Best Practices to Keep in Mind](https://dev.to/liaowow/8-css-best-practices-to-keep-in-mind-4n5h)
> * 原文作者：[Annie Liao](https://github.com/liaowow)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/8-scss-best-practices-to-keep-in-mind.md](https://github.com/xitu/gold-miner/blob/master/article/2020/8-scss-best-practices-to-keep-in-mind.md)
> * 译者：
> * 校对者：

# 8 SCSS Best Practices to Keep in Mind

This past week I had an opportunity to browse through a company's coding guideline, some of which I found very useful not only in collaborative settings but also in developing personal projects.

Here are eight of SCSS best practices from the guideline that made me rethink the way I structure my CSS code:

## 1. Mobile First

When it comes to responsive design, it's common to prioritize the desktop version, which can make customizing for mobile a painful process. Instead, we should design to expand, not cram things to fit mobile.

Don't:

```scss
.bad {
  // Desktop code

  @media (max-width: 768px) {
    // Mobile code
  }
}
```

Do:

```scss
.good {
  // Mobile code

  @media (min-width: 768px) {
    // Desktop code
  }
}
```

## 2. Set Variables

Defining CSS variables and mixins should be part of the initial setup, which can make the project much more maintainable.

According to the guideline, here are some common properties that will benefit from variables:

- `border-radius`
- `color`
- `font-family`
- `font-weight`
- `margin` (gutters, grid gutters)
- `transition` (duration, easing) -- consider a mixin

## 3. Avoid `#id` and `!important`

Both `!important` and `#id`s are considered overly specific and can mess with the order of CSS rendering especially when developing collaboratively.

Don't:

```scss
#bad {
  #worse {
     background-color: #000;
  }
}
```

Do:

```scss
.good {
  .better {
     background-color: rgb(0, 0, 0);
  }
}
```

## 4. Avoid Magic Numbers

Try not to set arbitrary numbers because they "just work"; other developers might not understand why the property has to be set in such particular numbers. Instead, create relative values whenever possible.

If you're interested, CSS Tricks have a [clear explainer](https://css-tricks.com/magic-numbers-in-css/) of why Magic Numbers are bad.

Don't:

```scss
.bad {
  left: 20px;
}
```

Do:

```scss
.good {
  // 20px because of font height
  left: ($GUTTER - 20px - ($NAV_HEIGHT / 2));
}
```

## 5. Descriptive Naming

It's easy to define CSS selectors according to the looks. It's better to describe the hierarchy.

Don't:

```scss
.huge-font {
  font-family: 'Impact', sans-serif;
}

.blue {
  color: $COLOR_BLUE;
}
```

Do:

```scss
.brand__title {
  font-family: 'Impact', serif;
}

.u-highlight {
  color: $COLOR_BLUE;
}
```

## 6. Zero Values and Units

This one might be up to personal choice or specific project style guide, but consistency is key. The rule below asks that you specify units on zero-duration times, but not on zero-length values. Also, add a leading zero for decimal places, but don't go crazy (more than three) on decimal places.

Don't:

```scss
.not-so-good {
  animation-delay: 0;
  margin: 0px;
  opacity: .4567;
}
```

Do:

```scss
.better {
  animation-delay: 0s;
  margin: 0;
  opacity: 0.4;
}
```

## 7. Inline Commenting

The best practice here is to comment on top of the property you're describing. Also, use inline commenting (`//`) instead of block-level comments (`/* */`), which is harder to uncomment.

Don't:

```scss
.bad {
  background-color: red; // Not commenting on top of property
  /* padding-top: 30px;
  width: 100% */
}
```

Do:

```scss
.good {
  // Commenting on top of property
  background-color: red;
  // padding-top: 30px;
  // width: 100%;
}
```

## 8. Nesting Media Queries

In order to easily locate media queries, it is recommended that you keep the media queries at the root of the declaration instead of nesting them inside each selector.

Don't:

```scss
.bad {

  &__area {
    // Code

    @media (min-width: 568px) {
      // Code
    }
  }

  &__section {
    // Code

    @media (min-width: 568px) {
      // Code
    }
  }
}
```

Do:

```scss
.good {

  &__area {
    // Code
  }

  &__section {
    // Code
  }

  @media (min-width: 568px) {
    &__area {
      // Code
    }

    &__section {
      // Code
    }
  }
}
```

These are by no means an exhaustive list of best coding practices, but they certainly play a vital role in designing readable, scalable web apps. Is there any CSS guideline that you follow as your north star? Let me know in the comments!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
