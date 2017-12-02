> * 原文地址：[11 things I learned reading the flexbox spec](https://hackernoon.com/11-things-i-learned-reading-the-flexbox-spec-5f0c799c776b)
> * 原文作者：本文已获原作者 [David Gilbertson](https://hackernoon.com/@david.gilbertson) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[XatMassacrE](https://github.com/XatMassacrE)
> * 校对者：[zaraguo](https://github.com/zaraguo)，[reid3290](https://github.com/reid3290)

# 读完 flexbox 细则之后学到的 11 件事

在经历了多年的浮动布局和清除浮动的折磨之后，flexbox 就像新鲜空气一般，使用起来是如此的简单方便。

然而最近我发现了一些问题。当我认为它不应该是弹性的时候它却是弹性的。修复了之后，别的地方又出问题了。再次修复之后，一些元素又被推到了屏幕的最右边。这到底是什么情况？

当然了，最后我把它们都解决了，但是黄花菜都凉了而且我的处理方式也基本上没什么规范，就好像那个砸地鼠的游戏，当你砸一个地鼠的时候，另一个地鼠又冒出来，很烦。

不管怎么说，我发现要成为一个成熟的开发者并且真正地学会 flexbox 是需要花时间的。但是不是再去翻阅另外的 10 篇博客，而是决定直接去追寻它的源头，那就是阅读 [The CSS Flexible Box Layout Module Level 1 Spec](https://www.w3.org/TR/css-flexbox-1/)。

下面这些就是我的收获。

### 1. Margins 有特别的功能

我过去常常想，如果你想要一个 logo 和 title 在左边，sign in 按钮在右边的 header ...

![](https://cdn-images-1.medium.com/max/800/1*Y1xY5s_DFPRaZzTwpfb_WQ.png)

点线为了更清晰

... 那么你应该给 title 的 flex 属性设置为 1 就可以把其他的条目推到两头了。

```
.header {
  display: flex;
}
.header .logo {
  /* nothing needed! */
}
.header .title {
  flex: 1;
}
.header .sign-in {
  /* nothing needed! */
}
```

这就是为什么说 flexbox 是个好东西了。看看代码，多简单啊。

但是，从某种角度讲，你并不想仅仅为了把一个元素推到右边就拉伸其他的元素。它有可能是一个有下划线的盒子，一张图片或者是因为其他的什么元素需要这样做。

好消息！你可以不用说“把这么条目推到右边去”而是更直接地给那个条目定义 `margin-left: auto`，就像 `float: right`。

举个例子，如果左边的条目是一张图片：

![](https://cdn-images-1.medium.com/max/800/1*hFLefXP4fsgnFDIjPIcrTQ.png)

我不需要给图片使用任何的 flex，也不需要给 flex 容器设置 `space-between`，只需要给 'Sign in' 按钮设置 `margin-left: auto` 就可以了。

```
.header {
  display: flex;
}
.header .logo {
  /* nothing needed! */
}
.header .sign-in {
  margin-left: auto;
}
```

你或许会想这有一点钻空子，但是并不是，在 [概述](https://www.w3.org/TR/css-flexbox-1/#overview) 里面**这个**方法就是用来将一个 flex 条目推到 flexbox 的末端的。它甚至还有自己单独的章节，[使用 auto margins 对齐](https://www.w3.org/TR/css-flexbox-1/#auto-margins)。

哦对了，我应该在这里添加一个说明，在这篇博客中我会假设所有的地方都设置了 `flex-direction: row`。但是对于 `row-reverse`，`column` 和 `column-reverse` 也都是适用的。

### 2. min-width 问题

你或许会想一定有一个直截了当的方法确保在一个容器中所有的 flex 条目都适应地收缩。当然了，如果你给所有的条目设置 `flex-shrink: 1`，这不就是它的作用吗？

还是举例说吧。

假设你有很多的 DOM 元素来显示出售的书籍并且有个按钮来购买它。

![](https://cdn-images-1.medium.com/max/800/1*kx1Xl4o5at3whroR9gB0Dw.png)

(剧透：蝴蝶最后死了)

你已经用 flexbox 安排地很好了。

```
.book {
  display: flex;
}
.book .description {
  font-size: 30px;
}
.book .buy {
  margin-left: auto;
  width: 80px;
  text-align: center;
  align-self: center;
}
```

(你想让 'Buy now' 按钮在右边，即使是很短的标题的时候，那么你就要给他设置 `margin-left: auto`。)

这个标题太长了，所以他占用了尽可能多的空间，然后换到了下一行。你很开心，生活真美好。你洋洋得意地将代码发布到生产环境并且自信地认为没有任何问题。

然后你就会得到一个惊喜，但不是好的那种。

一些自命不凡的作者在标题中用了一个很长的单词。

![](https://cdn-images-1.medium.com/max/800/1*skXsBLXnoul3J64xKb1HmA.png)

那就完了！

如果那个红色的边框代表手机的宽度，并且你隐藏了溢出，那么你就失去你的 'Buy now' 按钮。你的转换率，可怜的作者的自我感觉都会遭殃。

(注：幸运的是我工作的地方有一个很棒的 QA 团队，他们维护了一个拥有各种类似于这样的令人不爽的文本的数据库。也正是这个问题特别的促使我去阅读这些细则。)

就像图片展示的那样，这样的表现是因为描述条目的 `min-width` 初始被设置为 `auto`，在这种情况下就相当于 **Electroencephalographically** 这个单词的宽度。这个 flex 条目就如它的字面意思一样不允许被任何的压缩。

那么解决办法是什么呢？重写这个有问题的属性，将 `min-width: auto` 改为 `min-width: 0`，给 flexbox 指明了对于这个条目可以比它里面的内容更窄。

这样就可以在条目里面处理文本了。我建议包裹单词。那么你的 CSS 代码就会是下面这个样子：

```
.book {
  display: flex;
}
.book .description {
  font-size: 30px;
  min-width: 0;
  word-wrap: break-word;
}
.book .buy {
  margin-left: auto;
  width: 80px;
  text-align: center;
  align-self: center;
}
```

这样的结果就是这个样子：

![](https://cdn-images-1.medium.com/max/800/1*lM96U8XNZJEGPrVwqJk91w.png)

重申一下，`min-width: 0` 不是什么为了特定结果取巧的技术，它是[细则中建议的行为 ](https://www.w3.org/TR/css-flexbox-1/#min-size-auto)。

下个章节我会处理尽管我明确写明了但是 ‘Buy now’ 按钮仍然不总是 80px 宽的问题。

### 3. flexbox 作者的水晶球

就像你知道的，`flex` 属性其实是 `flex-grow`，`flex-shrink` 和 `flex-basis` 的简写。

我必须承认为了达到我想要的效果，我在不停地尝试和验证这三个属性上面花费了很多时间。

但是直到现在我才明白，我其实只是需要这三者的一个组合。

- 如果我想当空间不够的时候条目可以被压缩，但是不要伸展，那么我们需要：`flex: 0 1 auto`
- 如果我的条目需要尽可能地填满空间，并且空间不够时也可以被压缩，那么我们需要：`flex: 1 1 auto`
- 如果我们要求条目既不伸展也不压缩，那么我们需要：`flex: 0 0 auto`

我希望你还不是很惊奇，因为还有让你更惊奇的。

你看，Flexbox Crew (我通常认为 flexbox 团队的皮衣是男女都能穿的尺寸)。对，Flexbox Crew 知道我用得最多的就是这三个属性的组合，所以他们给予了这些组合 [对应的关键字](https://www.w3.org/TR/css-flexbox-1/#flex-common)。

第一个场景是 `initial` 的值，所以并不需要关键字。`flex: auto` 适用于第二种场景，`flex: none` 是条目不伸缩的最简单的解决办法。

早就该想到它了。

它就好像用 `box-shadow: garish` 来默认表示 `2px 2px 4px hotpink`，因为它被认为是一个 ‘有用的默认值’。

让我们再回到之前那个丑陋的图书的例子。让我们的 'Buy now' 按钮更胖一点...

![](https://cdn-images-1.medium.com/max/800/1*oaBk_GjcSHAvSkdhJhwkSA.png)

... 我只要设置 `flex: none`：

```
.book {
  display: flex;
}
.book .description {
  font-size: 30px;
  min-width: 0;
  word-wrap: break-word;
}
.book .buy {
  margin-left: auto;
  flex: none;
  width: 80px;
  text-align: center;
  align-self: center;
}
```

(是的，我可以设置 `flex: 0 0 80px;` 来节省一行 CSS。但是设置为 `flex: none`可以更清楚地表示代码的语义。这对于那些忘记这些代码是如何工作的人来说就友好多了。 )

### 4. inline-flex

坦白讲，几个月前我才知道 `display: inline-flex` 这个属性。它会代替块容器创建一个内联的 flex 容器。

但是我估计有 28% 的人还不知道这件事，所以现在你就不是那 28% 了。

### 5. vertical-align 不会对 flex 条目起作用

或者这件事我并不是完全的懂，但是从某种意义上我可以确定，当使用 `vertical-align: middle` 来尝试对齐的时候，它并不会起作用。

现在我知道了，细则里面直接写了，[vertical-align 在 flex 条目上不起作用](https://www.w3.org/TR/css-flexbox-1/#flex-containers)” (注意：就好像 `float` 一样)。

### 6. margins 和 padding 不要使用 %

这并不仅仅是一个最佳实践，它类似于外婆说的话，去遵守就好了，不要问为什么。

"开发者们在 flex 条目上使用 paddings 和 margins 时，应该避免使用百分比" — 爱你的，flexbox 细则。

下面是我在细则里面看到的最喜欢的一段话。

> 注解：这个变化糟透了，但是它精准地抓住了世界的当前状态(实现无定法，CSS 无定则)

> 当心，糖衣炮弹进行中。

### 7. 相邻的 flex 条目的边缘不会塌陷

你或许知道有时候会出现相邻条目的边缘塌陷。你或许也知道其他的时候**不会**出现边缘塌陷。

现在我们都知道相邻的 flex 条目是不会发生边缘塌陷的。

### 8. 即使 position: static，z-index 也会有效

我不确定我是否真的在乎这一点。但是我想到或许有一天，它就会真地有用。就好像我冰箱里有一瓶柠檬汁。

某一天我家来了其他人，然后他会问："嗨，你这里有柠檬汁吗？"，我这时就会告诉他："有的，就在冰箱里"，他会接着说："谢谢，大兄弟。那么如果我想给一个 flex 条目设置 z-index，我需要指定 position 吗？"，我会说："兄弟，不需要，flex 条目不需要这样。"

### 9. Flex-basis 是精细且重要的

一旦 `initial`，`auto` 和 `none` 都不能满足你的需求时，事情就有点复杂了，但是我们**有** `flex-basis`，有趣的是，你知道的，我不知道怎么结束这句话。如果你们有好的建议的话，欢迎留言。

如果你有 3 个 flex 条目，它们的 flex 值分别为 3，3 和 4。那么当 `flex-basis` 为 `0` 的话它们就会忽略他们的内容，占据可用空间的 30%，30%，40%。

然而，如果你想要 flex 更友好但是有点不太可预测的话，使用 `flex-basis: auto`。这个会将你的 flex 的值设置得更合理，同时也会考虑到一些其他因素，然后为你给出相对合理的宽度。

看看这个很棒的示意图。

![](https://cdn-images-1.medium.com/max/800/1*eiAn12jGzun4F7U3mfqUtQ.png)

我十分确定我读到的关于 flex 的博客中至少有一篇提到了这一点，但是我也不知道为什么，直到我看到上面这张图才想起来。

### 10. align-items: baseline

如果我想让我的 flex 条目垂直对齐，我总是使用 `align-items: center`。但是就像 `vertical-align`一样，这样当你的条目有不同的字体大小并且你希望它们基于 baselines 对齐的时，你需要设置 `baseline` 才能对齐的更完美。

`align-self: baseline` 也可以，或许更直观。

### 11. 我很蠢

下面这段话不论我读几遍，都无法理解它的含义...

> 在主轴上内容大小是最小内容大小的尺寸，并且是加紧的，如果它有一个宽高比，那么任何定义的 min 和 max 的大小属性都会通过宽高比转换，并且如果主轴的 max 尺寸是确定的话会进一步加紧。

这些单词通过我的眼睛被转化成电信号穿过我的视神经，刚刚抵达的时候就看到我的大脑打开后门一溜烟跑了。

就像米老鼠和疯狂麦克斯 7 年前生了个孩子，现在和薄荷酒喝醉了，使用他从爸爸妈妈吵架时学到的语言肆意的辱骂周围的人。

女士们，先生们，我已经放弃了体面开始胡言乱语了，这意味着你可以关闭这篇文章了(如果你看这个是为了学习的话你可以在这里停止了)。


读这篇细则我学到的最有趣的事情是，尽管我看过大量的博文，以及 flexbox 也算是相对简单的知识点，但是我对其的了解曾是那么的不彻底。事实证明 '经验' 不总是起作用的。

我可以很开心的说花时间来阅读这些细则已经得到了回报。我已经优化的我的代码，设置了 auto margins，flex 的值也设置成了 auto 或者 none，并在需要的地方定义了 min-width 为 0。

现在这些代码看起来好多了，因为我知道这样做是正确的。

我的另外一个收获就是，尽管这些细则在某些方面正如我所想的基于编者视角并有些庞杂，但是仍然有有很多友好的说明和例子。甚至还高亮了那些初级开发者容易忽略的部分。

然而，这个是多余的，因为我已经告诉了你所有有用知识点，你就不用再自己去阅读了。

现在，如果你们要求，那么我会再去阅读所有其他的 CSS 细则。

PS：我强烈建议读读这个，一个浏览器 flexbox bugs 的清单：[https://github.com/philipwalton/flexbugs](https://github.com/philipwalton/flexbugs).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
