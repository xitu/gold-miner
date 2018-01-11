> * 原文地址：[On the Growing Popularity of Atomic CSS](https://css-tricks.com/growing-popularity-atomic-css/?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[OLLIE WILLIAMS](https://css-tricks.com/author/olliew/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/growing-popularity-atomic-css.md](https://github.com/xitu/gold-miner/blob/master/TODO/growing-popularity-atomic-css.md)
> * 译者：[Cherry](https://github.com/sunshine940326)
> * 校对者：[Tina92](https://github.com/Tina92)、[ClarenceC](https://github.com/ClarenceC)

# 论原子 CSS 的日益普及

即使你自认为是 CSS 方面的专家，也很可能在某一大型项目中，处理一个错综复杂并且越来越庞大的样式表，它们中一些样式表看起来就像一张相互继承并且混乱缠绕的网。

![意大利面怪物](https://cdn.css-tricks.com/wp-content/uploads/2017/11/spaghetti-monster.jpg)

级联的作用非常强大。微小的改变可能会引起很大的改变，这就导致了很难知道下一秒会发生什么。重构、更改和移除 CSS 都是高危动作，因为很难知道这个 CSS 在哪里被引用。

> **你什么时候可以做到改变 CSS 不引起不必要的改动？** 答案是无论在何种情况下，你都很少有这种想法。
>
> 在我有限的经验中，其中的一种情况是，在大型团队的大型代码库中，**给人的感觉是 CSS 太大了以至于团队的成员开始对 CSS 很敏感并且对 CSS 感到害怕，但是实际上只是让你增加 CSS。**
> 
> 由此产生一个工具，它能做的事情远远少于 CSS，但是在某种程度上（在你学会之后），没有人在对其感到害怕，我认为这非常棒。
> - [Chris Coyier](https://css-tricks.com/lets-define-exactly-atomic-css/#comment-1607914)

### 原子 CSS 让事情变得简单

> 我不在需要去考虑如何组织我的 CSS。我也不需要考虑如何给我的组件起名，也不需要考虑将一个组件和另一个组件完全分离，应该将其放在哪里，最重要的，当有新的需求是怎么进行重构。
> 
> - [Callum Jefferies 在尝试通过 BEM 命名方式使用超分子 CSS 之后发表的言论](https://madebymany.com/stories/takeaways-from-trying-out-tachyons-css-after-ages-using-bem)

[原子 CSS](https://css-tricks.com/lets-define-exactly-atomic-css/) 提供了一套直接、明显并且简单的方法论。类是不可变的，你不可以改变类名。这使得s使用 CSS 是可预见的和可靠的，因为类总是做**完全**相同的事情。在 HTML 文件中添加或者移除一个有作用域范围的公用类是明确的，它让你确信你不会破坏其他任何东西。这可以减少认知负荷和精神负担。

给组件命名是出了的困难。想出一个既有意义又足够通用的类名费时又费力。

> 计算机科学中只有两个难题：缓存失效和命名问题。
> 
> – Phil Karlton

提出适当的抽象是困难的。相比之下，命名工具类就简单直接一些。

```
/* 工具类命名 */
.relative {
  position: relative;
}
.mt10 {
  margin-top: 10px;
}
.pb10 {
  padding-bottom: 10px;
}
```
原子的类从名字就可以知道它们的功能。意图和效果显而易见。而包含无数类名的 HTML 会显得很乱，HTML 比一个庞大并且错综复杂的样式要容易一些。

在一个前后端混合的团队中，可能参与开发的后台人员对 CSS 知识有限，很少有人将样式表搞乱。

![来自 ryanair.com —— 整个 CSS 都在完成一个效果](https://cdn.css-tricks.com/wp-content/uploads/2017/11/s_936DE68CA3D578D4EBA9574821004F0B168A1400AEE2F968AAEBC3372F36B63D_1510608565787_ScreenShot2017-11-13at21.27.52.png)


### 样式差异处理
[工具类](https://css-tricks.com/need-css-utility-library/) 非常适合处理小的样式差异。虽然设计系统和模式库现在可能风靡一时，但是你要意识到将会有不断的新需求和变化。所有组件的可重用性往往不是体现在设计模拟。虽然实现和设计稿一致是最好的，但是一个大型网站繁多的上下环境一定会有很多的不可避免的不同。

![](https://cdn.css-tricks.com/wp-content/uploads/2017/11/bem-modifiers.png)

Medium 的开发团队已经不使用 BEM 了，在 [他们的博文中](https://medium.engineering/simple-style-sheets-c3b588867899) 有提到。

如果我们希望组件通过简单的方式和另一个组件只有细微的差别，该怎么去做呢？如果你使用的 BEM 的命名方式，修饰符类很可能会不起作用。无数的修饰符往往只有一个效果。我们以边距（`margin`）为例。不同组件的边框大部分都不相同，让所有组件的边框保持一致也不太可能。这个距离不仅取决于组件，还取决于组件在页面中的位置和它相对于其他元素的相对位置。大部分的设计都包含相似但是**不完全相同**的 UI 元素，使用传统的 CSS 很难处理。

### 很多人都不喜欢它

![Aaron Gustafson，《A List Apart》的总编辑，Web Standards Project 的前任项目经理，微软员工](https://cdn.css-tricks.com/wp-content/uploads/2017/11/twitter.com_AaronGustafson_status_743073596789133312_ref_srctwsrc5Etfwref_urlhttp3A2F2Fcssmojo.com2Fopinions_of_leaders_considered_harmful2F.png)


![Soledad Penades，来自 Mozilla 的工程师](https://cdn.css-tricks.com/wp-content/uploads/2017/11/soledad.png)


![CSS 禅意花园的创办者](https://cdn.css-tricks.com/wp-content/uploads/2017/11/cssmojo.com2Fopinions_of_leaders_considered_harmful2F.png)


### 原子 CSS 和行内样式有什么不同？
这是质疑原子 CSS 的人经常会问到的问题。长期以来大家都认为行内样式不利于实践，自 Web 时代初期就很少有人使用了。**那些批评者将原子 CSS 与行内样式等同也是有道理的，因为行内元素和原子 CSS 有相同的弊端。**举个例子，如果我们想要将所有的 `.block` 类中的 `color` 改变为 `navy` 会怎样？如果这样做：

```
.black {
  color: navy;
}
```

很明显，这是**不对**的。

现在的编辑器很复杂。使用查找和替换将所有的 `.black` 类换成一个新的 `.navy` 类十分的简单，但是却是很危险的。问题是，你只是想将 **某些** `.block` 类变为 `.naby` 类。

在传统的 CSS 方法中，调整组件的样式和在一个 CSS 文件中更新一个类的一个值一样简单。使用原子 CSS，这就变成了一项单调乏味的任务，它通过搜索每一块 HTML 来更新所述组件的每一个实例。然而所有的高级编辑器都是这样。即使你将标记分离为可重用的模板，这仍然是一个主要缺点。**也许这种手动操作对于这种简单的方法是值得的。用不同的类更新 HTML 文件可能很乏味，但并不困难。**（虽然有一些时候我在手动更新时遗漏了相关组件的某些实例，暂时引入了风格不一致）。如果改变了设计，你可能需要从 HTML 中手动编辑类。

虽然原子 CSS 和内联样式一样有很大的缺陷，但是这不是一种退后。工具类以各种方式优于内联样式。

### 原子 CSS vs. 行内样式

#### 原子类允许抽象，内联样式不允许

原子类可以创建抽象类，内联样式不行。
```
<p style="font-family: helvetica; color: rgb(20, 20, 20)">
  Inline styles suck.
</p>
<p class="helvetica rgb202020">
  Badly written CSS isn't very different.
</p>
<p class="sans-serif color-dark">
  Utility classes allow for abstraction.
</p>
```

当改变设计的时候，上面例子的前两个需要手动的修改和替换。第三个例子可以只调整一处样式表。

#### 工具

CSS 社区已经创建了很多用于行内样式的无用的工具例如：Sass， Less， PostCSS， Autoprefixer 等。

#### 更加简洁

与其写出冗余的行内样式，倒不如像原子 CSS 一样写出简洁的声明缩写。相比之下少打了一些字符：`mt0` 和 `margin-top: 0`，`flex` 和 `display: flex`，等等。

#### 差异性

这是一个有争议的话题。如果一个类或者行内样式仅仅只做一件事情，**那么你是否希望它只做一件事情**，很多人提倡使用 `!importent` 来保证不被其他的除了 `!important` 的样式重写，这也就意味着这个样式肯定会被应用。但是，一个类本身是足够具体的，可以覆盖其他的基本类。和行内样式相比，原子类特异性较低是一件好事。它允许更多的通用性。都可以使用 JavaScript 来改变样式。如果是行内样式的话就比较困难。

#### 样式表的类比行内样式能做的更多
行内样式不支持媒体查询、伪选择器、`@supports` 和 CSS 动画。也许你有一个单独的悬停效果你想要应用在不同的元素而不是一个组件。

```
.circle {
  border-radius: 50%;
}

.hover-radius0:hover {
  border-radius: 0;
}
```

简单的可重用媒体查询规则也可以转换成实用的工具类，其常用的类名前缀表示小型、中型和大型的屏幕尺寸。下面有一个 flexbox 类的实例，只能对中型和大型屏幕尺寸有效：

```
@media (min-width: 600px) {
  .md-flex {
    display: flex;
  }
}
```

这在内联样式中是不可能的。

你是不是想要一个可重用的有伪内容的图标或标签？

```
.with-icon::after {
  content: 'some icon goes here!';
}
```

#### 有限的选择可能会更好

行内样式可以做**任何事情**。这过于自由以至于很容易导致显示效果混乱和不一致。通过每一个预定类，原子 CSS 可以保证一定程度的风格一致。而不是杂乱的颜色值和不确定的颜色值，工具类提供了一个预定义设置选项。开发者从有限的设置中选择单一功能的工具类，这种约束既可以消除日益增加的样式问题，保持视觉的一致性。

我们来看一个 `box-shadow` 的例子。一个行内样式可以随意使用偏移量、范围、颜色、透明度和模糊半径。

```
<div style="box-shadow: 2px 2px 2px rgba(10, 10, 250, .4)">stuff</div>
```

使用原子方法，CSS 作者可以定义首选样式，然后简单应用，不可能出现风格不一致。

```
<div class="box-shadow">stuff</div>
```

### 原子 CSS 既不是全能也不是一无是处

毫无疑问，像 Tachyons 这样的原子类框架越来越受欢迎。然而，CSS 方法并不是互斥的。很多情况下，工具类并不是最好的选择：

* 如果你需要在媒体查询中改变特定组件里面大量的样式。
* 如果你想要使用 JavaScript 改变很多样式，将其抽象为一个单独的类是非常容易的。

原子类可以和其他样式方法共存。我们应该将设置一些基础类和稳健的全局样式。如果你继续复制工具类的相似字符串，这些样式很可能被抽象为一个类。你可以在组件类中将其合并，但是你只能在知道它们不会被重用时才可以这样。


> 以组件为先的方法去写 CSS 意味着你创建一个组件事物即使他们不会再被重用。这种过早的抽象就是使样式表变得冗余和复杂的原因。 
> - [Adam Wathan](https://adamwathan.me/css-utility-classes-and-separation-of-concerns/)

> 单位越小，它的可重用性就越强。 
> - [Thierry Koblentz](http://www.smashingmagazine.com/2013/10/challenging-css-best-practices-atomic-approach)

看一下 Bootstrap 的最新版本，现在提供了一整套的工具类，仍然包括其传统的组件。未来，越来越多的流行框架采用这种混合方法。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
