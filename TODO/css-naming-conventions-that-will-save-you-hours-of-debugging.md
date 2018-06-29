> * 原文地址：[CSS Naming Conventions that Will Save You Hours of Debugging](https://medium.freecodecamp.org/css-naming-conventions-that-will-save-you-hours-of-debugging-35cea737d849)
> * 原文作者：[Ohans Emmanuel](https://medium.freecodecamp.org/@ohansemmanuel?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/css-naming-conventions-that-will-save-you-hours-of-debugging.md](https://github.com/xitu/gold-miner/blob/master/TODO/css-naming-conventions-that-will-save-you-hours-of-debugging.md)
> * 译者：[unicar](https://github.com/unicar9)
> * 校对者：[dazhi1011](https://github.com/dazhi1011)，[swants](https://github.com/swants)

# 这些 CSS 命名规范将省下你大把调试时间

![](https://cdn-images-1.medium.com/max/1000/1*YunI3ChUVMlpmFzo75FczQ.png)

我听说很多开发者厌恶 CSS。而在我的经验中，这往往是由于他们并没有花时间来学习 CSS。

CSS 算不上是最优美的『语言』，但迄今二十多年来，它都是美化 web 举足轻重的工具。从这点来说，也还算不错吧？

尽管如此，CSS 写得越多，你越容易发现一个巨大的弊端。

因为维护 CSS 真是老大难。

特别是那些写得差劲的 CSS 会很快变成程序员的噩梦。

这里向大家介绍一些命名规范，遵照这些规范可以省时省力，少走弯路。

![](https://cdn-images-1.medium.com/max/800/1*fe0MIB3iqSruW1pgZW9rKw.jpeg)

对此你一定深有体会吧？

### 使用连字符分隔的字符串

如果你常写 JavaScript，那么你知道对变量使用驼峰式命名法（camel case）是一种惯例。

```
var redBox = document.getElementById('...')
```

这样很好，对吧？

但问题是这种命名法并不适用于 CSS。

请切忌以如下方式命名：

```
.redBox {
  border: 1px solid red;
}
```

相应的，你可以这样写：

```
.red-box {
   border: 1px solid red;
}
```

这是一种非常标准的 CSS 命名规范。也可以说更易读。

同时，这也和 CSS 属性名称保持了一致。

```
// Correct
.some-class {
   font-weight: 10em
}
// Wrong
.some-class {
   fontWeight: 10em
}
```

### BEM 命名规范

不一样的团队在写 CSS 选择器（CSS selectors）有不一样的方法。有些团队使用的是连字符分隔（hyphen delimiters）法，还有一些倾向于使用一种叫 BEM 的命名法，这种方法更加有条理。

总的来说，这些 CSS 命名规范试图解决 3 类问题：

1. 仅从名字就能知道一个 CSS 选择器具体做什么
2. 从名字能大致清楚一个选择器可以在哪里使用
3. 从 CSS 类的名称可以看出它们之间的联系

不知你是否见过这样的类名：

```
.nav--secondary {
  ...
}
.nav__header {
  ...
}
```

这就是 BEM 命名规范。

### 向 5 岁小孩解释 BEM 规范

BEM 规范试图将整个用户界面分解成一个个小的可重复使用的组件。

让我们来看看下图：

![](https://cdn-images-1.medium.com/max/800/1*qFy4XIpxbWx4oaOA3TYqpQ.png)

这可是个足以得奖的火柴人呢 :)

哎，可惜并不是 :(

这个火柴人代表了一个组件，比如说一个设计区块。

或许你已经猜到了 BEM 这里的 B 意为『区块』（‘Block’）。

在实际中，这里『区块』可以表示一个网站导航、页眉、页脚或者其他一些设计区块。

根据上述解释，那么这个组件的理想类名称即是 `stick-man`。

组件的样式应写成这样：

```
.stick-man {
  
 }
```

在这里我们使用了连字符分隔法，很好！

![](https://cdn-images-1.medium.com/max/800/1*US1EoM_lvYOeJabGDhV2Eg.png)

### E 代表元素（Elements）

BEM 中的 E 代表着元素。

整体的区块设计往往并不是孤立的。

比方说，这个火柴人有一个头部（`head`），两只漂亮的手臂（`arms`）和双脚（`feet`）。

![](https://cdn-images-1.medium.com/max/800/1*MJO2vhGLlkQhTxGPO53YhQ.png)

The `head` , `feet`, and `arms` are all elements within the component. They may be seen as child components, i.e. children of the overall parent component.
这些 `head`、 `feet` 和 `arms` 都是组件中的元素。它们可视作子组件（child components），也就是父组件的组成部分。
如果使用 BEM 命名规范的话，这些元素的类名都可以通过在**两条下划线**后加上元素名称来产生。

比如说：

```
.stick-man__head {
}
.stick-man__arms {
}
.stick-man__feet {
}
```

### M 代表修饰符（Modifiers）

M 在 BEM 命名法中代表修饰符。

如果说这个火柴人有个 `blue` 或者 `red` 这样的修饰符怎么办呢？

![](https://cdn-images-1.medium.com/max/800/1*Uj4IOaEtYynnUUJm_hAdwQ.png)

在现实场景里，这可能是一个 `red` 或者 `blue` 的按钮。这就是之前在讲的组件当中的限定修饰。

如果使用 BEM 的话，这些修饰符的类名都可以通过在两条**连字符**后加上元素名来产生。

比如说：

```
.stick-man--blue {
}
.stick-man--red {
}
```

最后这个例子展示的是父组件加修饰符。不过这种情况并不经常出现。

假如我们这个火柴人拥有另一个不一样的头部大小呢？

![](https://cdn-images-1.medium.com/max/800/1*qTM1TfotfLSRNjZ_PnWtAg.png)

这一次元素被加上了修饰符。记住，元素指一个整体封装区块中的一个子组件。

`.stick-man` 表示区块（`Block`）， `.stick-man__head` 表示元素（the element）。

从上例可以看出，双连字符也可以这样使用：

```
.stick-man__head--small {
}
.stick-man__head--big {
}
```

重申一次，上例中使用的双连字符是用来指代修饰符的。

这样你都明白了吧。

这就是 BEM 的基本用法。

个人来说，我在小项目中一般只用连字符分割法来写类名，在用户界面更复杂的项目中使用 BEM 方法。

关于 BEM，从这里了解[更多](http://getbem.com/naming/)

[**BEM - Block Element Modifier**: _BEM - Block Element Modifier is a methodology, that helps you to achieve reusable components and code sharing in the…_getbem.com](http://getbem.com/naming/)

### 为何要使用命名规范？

> 在计算机科学当中只有两类难题：缓存失效和命名 - _Phil Karlton_

命名的确很难。所以我们要尽量把它变得容易点，也为以后维护代码省点时间。

能正确命名 CSS 中的类名可以让你的代码变得更易理解和维护。

如果你选择 BEM 命名规范，在看标记语言（markup）时就更容易看清各个设计组件/区块之间的关系。

感觉不错吧？

### 和 JavaScript 关联的 CSS 名称

今天是 John 上班第一天。

他拿到了如下一段 `HTML` 代码：

```
<div class="siteNavigation">
</div>
```

因为刚好读了这篇文章，John 意识到这种命名方法在 CSS 中不是最好的方法。于是他讲代码修改成下面这样：

```
<div class="site-navigation">
</div>
```

看上去不错吧？

不过 John 没想到的是，他把整个代码库搞砸了 😩😩😩

为什么会这样？

在 JavaScript 代码中，有一段是和之前的类名 `siteNavigation` 有关联的：

```
// Javasript 代码
const nav = document.querySelector('.siteNavigation')
```

由于类名的改变，`nav` 变量现在变成了 `null`。

好忧桑。😔😔

为了防止这种情况发生，开发者们想了很多不同的策略。

#### 1. 使用 js- 类名

一种减少这类 bug 的方法是使用 `**js-***` 的类名命名方法。用这种方法来表明这个 DOM 元素和 JavaScript 代码的关联。

例如：

```
<div class="site-navigation js-site-navigation">
</div>
```

同样的在 JavaScript 代码中：

```
//the Javasript code
const nav = document.querySelector('.js-site-navigation')
```

依照命名规范，任何人看到 `**js-**site-navigation` 这个类名称，就会知道 JavaScript 代码中有一段和这个 DOM 元素有关联的代码。

#### 2. 使用 Rel 属性

我自己没用过这种方法，不过我看到其他人用过。

你是否熟悉这样的代码？

```
<link rel="stylesheet" type="text/css" href="main.css">
```

一般来说，**rel 属性** 定义着链接资源和引用它的文件之间的关系。

回头看 John 的例子，这种方法建议我们写成如下的形式：

```
<div class="site-navigation" rel="js-site-navigation">
</div>
```

同时在 JavaScript 中：

```
const nav = document.querySelector("[rel='js-site-navigation']")
```

我对这种方法持保留态度。不过你很可能在某些代码库中看到它们。这种方法就好像在说：**“好吧，这里和 Javascript 有个关联，那么我就用 rel 属性来表示这种关联。”**

互联网这个地方，解决同一个问题常常有无数种『方法』。

#### 3. 别用数据属性（data attributes）

有些开发者用数据属性（data attributes）作为 JavaScript 钩子。这是不对的。根据定义，data 属性（data attributes）是用来 **储存自定义数据（to store custom data）** 的。

![](https://cdn-images-1.medium.com/max/800/1*wYSuEHKyr4gikmoEaq-9jw.png)

这里数据属性（data attributes）用得很妙。正如这条 Twitter 上所说的。

### 附加提议：写更多的 CSS 注释

这跟命名规范毫无关系，但也能帮你节省时间。

尽管很多 web 开发者尽量不写 Javascript 评论或者只针对某些情况才写，但我认为你应该写更多的 CSS 注释。

这是因为 CSS 不是最简洁优雅的『语言』，有条理的注释可以让你花更少时间来理解自己的代码。

有益无弊，何乐不为。

你可以看看 Bootstrap 的注释写得有多好。[source code](https://github.com/twbs/bootstrap/blob/v4-dev/scss/_carousel.scss)

你倒不需要写一个 `color: red` 的注释告诉自己这是把颜色定为红色。但如果你用了一个不太简单明了的 CSS 小技巧，这时候大可以写写注释说明一下。

### 准备好成为 CSS 大牛了么？

我创建了一本可以让你 CSS 技能飙升的指南。[这里领取免费电子书](http://eepurl.com/dgDVRb)

![](https://cdn-images-1.medium.com/max/800/1*fJabzNuhWcJVUXa3O5OlSQ.png)

你不知道的七种 CSS 秘籍。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
