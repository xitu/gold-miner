> * 原文地址：[8 SCSS Best Practices to Keep in Mind](https://dev.to/liaowow/8-css-best-practices-to-keep-in-mind-4n5h)
> * 原文作者：[Annie Liao](https://github.com/liaowow)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/8-scss-best-practices-to-keep-in-mind.md](https://github.com/xitu/gold-miner/blob/master/article/2020/8-scss-best-practices-to-keep-in-mind.md)
> * 译者：[snowyYU](https://github.com/snowyYU)
> * 校对者：[onlinelei](https://github.com/onlinelei)，[acev](https://github.com/acev-online)

# 8 个有用的 SCSS 最佳实践

上周我看了一家公司的代码规范，我发现其中一些规则同样适用于个人项目的开发。

我觉得以下的 8 个最佳实践特别棒：

## 1. 移动端优先

做响应式项目的时候，一般会先写 PC 版本的样式，但这会使移动端样式的书写变得特别痛苦。因此，我们应该先进行移动端样式的书写，在移动端样式的基础上向 PC 端的样式拓展。

不要这样做:

```scss
.bad {
  // Desktop code

  @media (max-width: 768px) {
    // Mobile code
  }
}
```

应该这样做:

```scss
.good {
  // Mobile code

  @media (min-width: 768px) {
    // Desktop code
  }
}
```

## 2. 提前定义好变量

初始化项目中，要先定义 CSS 变量和 mixins，这样可以提升项目的可维护性。

规范中提到，以下这些属性会经常读取 CSS 变量：

- `border-radius`
- `color`
- `font-family`
- `font-weight`
- `margin` (间隔, 常见网格布局的间隔)
- `transition` (持续时间, easing) -- 建议用 mixin

## 3. 不要使用 `#id` 和 `!important`

`!important` 和 `#id` 这俩太霸道啦，经常会搞乱 CSS 渲染的顺序和展示的优先级，在团队开发中尤甚。

不要这样做：

```scss
#bad {
  #worse {
     background-color: #000;
  }
}
```

应该这样做：

```scss
.good {
  .better {
     background-color: rgb(0, 0, 0);
  }
}
```

## 4. 不要写具体的数值

写样式的时候尽量不要给属性设置具体的数值，从页面渲染的结果上来看，它可能 “恰好合适”；但是其他开发人员可能不理解为什么必须将属性设置为这种特定的数字。因此，尽量写一些有含义的表达式或者计算式来使此处的可读性更高。

有兴趣的话， 在 CSS Tricks 上有一个 [说明](https://css-tricks.com/magic-numbers-in-css/) 指出了使用具体数值的坏处。

不要这样做：

```scss
.bad {
  left: 20px;
}
```

应该这样做：

```scss
.good {
  // 20px because of font height
  left: ($GUTTER - 20px - ($NAV_HEIGHT / 2));
}
```

## 5. 描述性良好的命名

很多人都是根据样式的显示结果来命名 CSS。 其实根据结构来命名更好。

不要这样做：

```scss
.huge-font {
  font-family: 'Impact', sans-serif;
}

.blue {
  color: $COLOR_BLUE;
}
```

应该这样做：

```scss
.brand__title {
  font-family: 'Impact', serif;
}

.u-highlight {
  color: $COLOR_BLUE;
}
```

## 6. 值为 0 时的单位

可能根据别的规范和个人习惯的原因对本条有意见，不过为了说明规范对一个项目的重要性。下面这条规则要求你在持续时间为 0 时加上单位（这种情况常见于编写 CSS 动效时，如过渡效果 transition-duration，规定完成过渡效果需要花费的时间（以秒或毫秒计） ），不要为长度为 0 的值指定单位（这里指 width、height、top、margin、padding 等可度量尺寸、位置的属性）。此外，为小数位添加前导零，注意啊，小数位别太长啦，最好别超过三位。

不要这样做:

```scss
.not-so-good {
  animation-delay: 0;
  margin: 0px;
  opacity: .4567;
}
```

应该这样做:

```scss
.better {
  animation-delay: 0s;
  margin: 0;
  opacity: 0.4;
}
```

## 7. 单行注释

这里建议在所要描述属性的上一行添加注释。使用块级注释符 (`/* */`) 不利于注释的删除和取消，所以使用单行注释符 (`//`) 来替代它。

不要这样做：

```scss
.bad {
  background-color: red; // 没在属性的上方写注释
  /* padding-top: 30px;
  width: 100% */
}
```

应该这样做：

```scss
.good {
  // 在属性的上方写注释
  background-color: red;
  // padding-top: 30px;
  // width: 100%;
}
```

## 8. 嵌套媒体查询

为了方便的定位媒体查询的声明，不要将它们嵌套在每个选择器中，而是将它们放在本页最顶级 scss 选择器中。

不要这样做：

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

应该这样做：

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

这里虽然只有寥寥几条不尽详细的规范，但是它们在项目中可是相当重要的。如果你见到了觉得很棒棒的 CSS 规范准则，还请在评论区中分享出来！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
