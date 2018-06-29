> * 原文地址：[Everything you need to know about CSS Variables](https://medium.freecodecamp.org/everything-you-need-to-know-about-css-variables-c74d922ea855)
> * 原文作者：[Ohans Emmanuel](https://medium.freecodecamp.org/@ohansemmanuel?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/everything-you-need-to-know-about-css-variables.md](https://github.com/xitu/gold-miner/blob/master/TODO/everything-you-need-to-know-about-css-variables.md)
> * 译者：[MechanicianW](https://github.com/MechanicianW)
> * 校对者：[xueshuai](https://github.com/xueshuai) [dazhi1011](https://github.com/dazhi1011)

# 关于 CSS 变量，你需要了解的一切

![](http://o7ts2uaks.bkt.clouddn.com/1%2AIm5WsB6Y7CubjWRx9hH7Gg.png)

本文是[我新写的电子书](https://gumroad.com/l/lwaUh)的第一章（电子书目前已支持 pdf 和 mobi 格式下载）。

大多数编程语言都支持变量。然而遗憾的是，CSS 从一开始就缺乏对原生变量的支持。

你写 CSS 吗？如果写的话你就知道是没法使用变量的。当然了，除非你使用像 Sass 这样的预处理器。

像 Sass 这样的预处理器是把变量的使用作为一大亮点。这是一个非常好的理由去尝试使用这类预处理器。当然了，这个理由已然足够好了。

Web 技术发展是非常快的，在此我很高兴地报告 **现在 CSS 支持变量了**。

然而预处理器还支持更多优秀特性，CSS 变量仅仅是其中之一。这些特性使得 Web 技术更加贴近未来。

这篇指南将向你展示变量是如何在原生 CSS 中工作的，以及怎样使用变量让你的编程工作更轻松。

### 你将学到

首先我将带你粗略过一遍 CSS 变量的基础知识。我相信任何理解 CSS 变量的尝试都必须从这里开始。

学习基础知识是一件非常酷的事。更酷的是使用基础知识来构建一个真正的应用。

因此，我将构建三个能够体现 CSS 变量的使用及其易用性的项目，用这种方式把两件事结合起来。下面是对这三个项目的快速预览。

#### 项目 1： 使用 CSS 变量创建一个有变化效果的组件

你可能已经构建过一个有变化效果的组件了。无论你是使用 React，Angular 还是 Vue，使用 CSS 变量都会让构建过程更简单。

![](http://o7ts2uaks.bkt.clouddn.com/1%2AqElS3I43_SdpdRA8-m2iew.gif)

使用 CSS 变量创建一个有变化效果的组件。

可以在 [Codepen](https://codepen.io/ohansemmanuel/full/PQYzvv/) 上查看这个项目。

#### 项目 2： 使用 CSS 变量实现主题定制

可能你已经看过这个项目了。我会向你展示使用 CSS 变量来定制全站主题有多么容易。

![](http://o7ts2uaks.bkt.clouddn.com/1%2Ar2TrlsC-gWRD5Hu6Tp2gjQ.gif)

使用 CSS 变量定制全站主题。

可以在 [Codepen](https://codepen.io/ohansemmanuel/full/xYKgwE/) 上查看这个项目。

#### 项目 3： 构建 CSS 变量展位

这是最后一个项目了，不要在意这个项目名，我想不出更好的名字了。

![](http://o7ts2uaks.bkt.clouddn.com/1%2AE6H-wT6a0BDR9OJK7Z0dTA.gif)

盒子的颜色是动态更新的。

请注意盒子的颜色是如何动态更新的，以及盒子容器是如何随着输入范围值的变化进行 3D 旋转的。

![](http://o7ts2uaks.bkt.clouddn.com/1%2Aiy_MjZVlp-H0KUQa7H7fUg.gif).

这个项目展示了使用 JavaScript 更新 CSS 变量的便利性，从中你还会尝到响应式编程的甜头。

#### 这会是非常好玩的！

花点时间在 [Codepen](https://codepen.io/ohansemmanuel/full/EoBLgd/) 上玩一玩。

注意：本文假定你对 CSS 已驾轻就熟。如果你对 CSS 掌握地不是很好，或者想学习如何创作出惊艳的 UI 效果，我建议你去学习我的 [CSS 进阶课程](https://bit.ly/learn_css)（共 85 课时的付费课程）。本文内容是该课程的一个节选。😉

### 为何变量如此重要

如果你对预处理器和原生 CSS 中的变量并不熟悉的话，以下几个原因可以为你解答为何变量如此重要。

#### **原因 #1：使得代码更可读**

无需多言，你就可以判断出，变量使得代码可读性更好，更易于维护。

#### **原因 #2：易于在大型文档中进行修改**

如果把所有的常量都维护在一个单独文件中，想改动某一变量时就无需在上千行代码间来回跳转进行修改。

这变得非常容易，仅仅在一个地方进行修改，就搞定了。

#### **原因 #3：定位打字错误更快**

在多行代码中定位错误非常痛苦，更痛苦的是错误是由打字错误造成的，它们非常难定位。善于使用变量可以免除这些麻烦。

至此，可读性和可维护性是主要优点。

感谢 CSS 变量，现在我们在原生 CSS 中也能享受到以上这些优点了。

### 定义 CSS 变量

先以你已经很熟悉的东西开始：JavaScript 中的变量。

JavaScript 中，一个简单的变量声明会像这样：

```
var amAwesome;
```

然后你像这样可以赋值给它：

```
amAwesome = "awesome string"
```

在 CSS 中，以两个横线开头的“属性”都是 CSS 变量。

```
/*你可以找到变量吗？ */
.block {
 color: #8cacea;
--color: blue
}
```

![](http://o7ts2uaks.bkt.clouddn.com/0%2A2Pl5qBF8DCTGL_np.png)

CSS 变量也被称为“自定义属性”。

### CSS 变量作用域

还有一点需要注意。

请记住 JavaScript 中变量是有作用域的，要么是`全局作用域`，要么就是`局部作用域`。

CSS 变量也是如此。

思考一下下面这个例子：

```
:root {
  --main-color: red
}
```

`:root` 选择器允许你定位到 DOM 中的最顶级元素或文档树。

所以，这种方式声明的变量就属于具有全局作用域的变量。

明白了吗？

![](http://o7ts2uaks.bkt.clouddn.com/0%2AGLjARI5CCGA3xJAx.png)

局部变量与全局变量。

### 示例 1

假设你想创建一个 CSS 变量来存储站点的主题颜色。

你会怎么做呢？

1. 创建一个作用域选择器。通过 `:root` 创建一个全局变量。

```
:root {

}
```

2. 定义变量

```
:root {
 --primary-color: red
}
```

请记住，在 CSS 中，以两个横线开头的“属性”都是 CSS 变量，比如 `--color`

就是这么简单。

### 使用 CSS 变量

变量一旦被定义并赋值，你就可以在属性值内使用它了。

但是有个小问题。

如果你用过预处理器的话，一定已经习惯通过引用变量名来使用该变量了。比如：

```
$font-size: 20px

.test {
  font-size: $font-size
}
```

原生 CSS 变量有些不同，你需要通过 `var()` 函数来引用变量。

在上面这个例子中，使用 CSS 变量就应该改成这样：

```
:root {
  --font-size: 20px
}

.test {
  font-size: var(--font-size)
}
```

两种写法大不一样。

![](http://o7ts2uaks.bkt.clouddn.com/0%2AGv8Nci9VTrJBxpBe.png)

请记得使用 var 函数。

一旦你习惯了这种方式，就会爱上 CSS 变量的。

另一个重要的注意事项是，在 Sass 这类预处理器中，你可以在任意地方使用变量，做各种计算，但是需要注意，在原生 CSS 中，你只能将变量设置为属性值。

```
/*这是错的*/
.margin {
--side: margin-top;
var(--side): 20px;
}
```

![](http://o7ts2uaks.bkt.clouddn.com/0_vtIhP9EGm_vTxeio.png)

由于属性名非法，这段声明会抛出语法错误

CSS 变量也不能做数学计算。如果需要的话，可以通过 CSS 的 `calc()` 函数进行计算。接下来我们会通过示例来阐述。

```
/*这是错的*/
.margin {
--space: 20px * 2;
font-size:  var(--space);  // 并非 40px
}
```

如果你必须要做数学计算的话，可以像这样使用 calc() 函数：

```
.margin {
--space: calc(20px * 2);
font-size:  var(--space);  /*等于 40px*/
}
```

### 关于属性的一些事

以下是几个需要阐述的属性行为：

#### 1. 自定义属性就是普通属性，可以在任意元素上声明自定义属性

在 p，section，aside，root 元素，甚至伪元素上声明自定义属性，都可以运行良好。

![](http://o7ts2uaks.bkt.clouddn.com/0_plpQVof3v3JrzC1P.png)

这些自定义属性工作时与普通属性无异。

#### 2. CSS 变量由普通的继承与级联规则解析

请思考以下代码：

```
div {
  --color: red;
}

div.test {
  color: var(--color)
}

div.ew {
  color: var(--color)
}
```

像普通变量一样，`--color` 的值会被 div 元素们继承。

![](http://o7ts2uaks.bkt.clouddn.com/0_GNSU5IDdk7dx3B8t.png)

#### 3. CSS 变量可以通过 `@media` 和其它条件规则变成条件式变量

和其它属性一样，你可以通过 `@media` 代码块或者其它条件规则改变 CSS 变量的值。

举个例子，以下代码会在大屏设备下改变变量 gutter 的值。

```
:root {
 --gutter: 10px
}

@media screen and (min-width: 768px) {
    --gutter: 30px
}
```

![](http://o7ts2uaks.bkt.clouddn.com/0_qmsVGjnWjLCKfyvt.png)

对于响应式设计很有用。

#### 4. HTML 的 style 属性中可以使用 CSS 变量。

你可以在行内样式中设置变量值，变量依然会如期运行。

```
<!--HTML-->
<html style="--color: red">

<!--CSS-->
body {
  color: var(--color)
}
```

![](http://o7ts2uaks.bkt.clouddn.com/0_EQiFgdDyNBQ1AfDk.png)

行内设置变量值。

要注意这一点，CSS 变量是区分大小写的。我为了减小压力，选择都采用小写形式，这件事见仁见智。

```
/*这是两个不同的变量*/
:root {
 --color: blue;
--COLOR: red;
}
```

### 解析多重声明

与其它属性相同，多重声明会按照标准的级联规则解析。

举个例子：

```
/*定义变量*/
:root { --color: blue; }
div { --color: green; }
#alert { --color: red; }

/*使用变量*/
* { color: var(--color); }
```

根据以上的变量声明，下列元素是什么颜色？

```
<p>What's my color?</p>
<div>and me?</div>
<div id='alert'>
  What's my color too?
  <p>color?</p>
</div>
```

你想出答案了吗？

第一个 p 元素颜色是 `蓝色`。`p` 选择器上并没有直接的颜色定义，所以它从 `:root` 上继承属性值

```
:root { --color: blue; }
```

第一个 `div` 元素颜色是 `绿色`。这个很简单，因为有变量直接定义在 `div` 元素上

```
div { --color: green; }
```

具有 ID 为 `alert` 的 `div` 元素颜色**不是**绿色，而是 `红色`

```
#alert { --color: red; }
```

由于有变量作用域直接是在这个 ID 上，变量所定义的值会覆盖掉其它值。`#alert` 选择器是一个更为特定的选择器。

最后，`#alert` 元素内的 `p` 元素颜色是 `红色`

这个 p 元素上并没有变量声明。由于 `:root` 声明的颜色属性是 `蓝色`，你可能会以为这个 p 元素的颜色也是 `蓝色`。

```
:root { --color: blue; }
```

如其它属性一样， CSS 变量是会继承的，因此 p 元素的颜色值继承自它的父元素 `#alert`

```
#alert { --color: red; }
```

![](http://o7ts2uaks.bkt.clouddn.com/1_lGioVJqkKo0N91R9eMvywQ.png)

小测验的答案。

### 解决循环依赖

循环依赖会出现在以下几个场景中：

1. 当一个变量依赖自己本身时，也就是说这个变量通过 `var()` 函数指向自己时。

```
:root {
  --m: var(--m)
}

body {
  margin: var(--m)
}
```

2. 两个以上的变量互相引用。

```
:root {
  --one: calc(var(--two) + 10px);
  --two: calc(var(--one) - 10px);
}
```

请注意不要在你的代码中引入循环依赖。

### 使用非法变量会怎样？

语法错误机制已被废弃，非法的 `var()` 会被默认替换成属性的初始值或继承的值。

思考一下下面这个例子：

```
:root { --color: 20px; }
p { background-color: red; }
p { background-color: var(--color); }
```

![](http://o7ts2uaks.bkt.clouddn.com/0_fa59XRLGKo5Rsqm4.png)

正如我们所料，`--color` 变量会在 `var()` 中被替换，但是替换后，属性值 `background-color: 20px` 是非法的。由于 `background-color` 不是可继承的属性，属性值将默认被替换成它的初始值即 `transparent`。

![](http://o7ts2uaks.bkt.clouddn.com/0_uVic7R1o96n-T1l5.png)

注意，如果你没有通过变量替换，而是直接写 `background-color: 20px` 的话，这个背景属性声明就是非法的，则使用之前的声明定义。

![](http://o7ts2uaks.bkt.clouddn.com/0_9HzCVQdyvqeo5dZq.png)

当你自己写声明时，情况就不一样了。

### 使用单独符号时要小心

当你用下面这种方式来设置属性值时，`20px` 则会按照单独符号来解析。

```
font-size: 20px
```

有一个简单的方法去理解，`20px` 这个值可以看作是一个单独的 “实体”。

在使用 CSS 变量构建单独符号时需要非常小心。

举个例子，思考以下代码：

```
:root {
 --size: 20
}

div {
  font-size: var(--size)px /*这是错的*/
}
```

可能你会以为 `font-size` 的值是 `20px`，那你就错了。

浏览器的解释结果是 `20 px`

请注意 `20` 后面的空格

因此，如果你必须创建单独符号的话，请用变量来代表整个符号。比如 `--size: 20px`，或者使用 `calc` 函数比如 `calc(var(--size) * 1px)` 中的 `--size` 就是等于 `20`

如果你没看懂的话也不用担心，在下个示例中我会解释地更详细。

### 一颗赛艇！

现在我们已经到了期待已久的章节了。

我将通过构建几个有用的小项目，在实际应用中引导你了解之前所学的理论。

让我们开始吧。

### 项目 1： 使用 CSS 变量创建一个有变化效果的组件

思考一下需要构建两个不同按钮的场景，两个按钮的基本样式相同，只有些许不同。

![](http://o7ts2uaks.bkt.clouddn.com/1_qElS3I43_SdpdRA8-m2iew%20%281%29.gif)

这个场景中，按钮的 `background-color` 和 `border-color` 属性不同。

那么你会怎么做呢？

这里有一个典型解决方案。

创建一个叫 `.btn` 的基础类，然后加上用于变化的类。举个例子：

```
<button class="btn">Hello</button>
<button class="btn red">Hello</button>
```

`.btn` 包括了按钮上的基础样式，如：

```
.btn {
  padding: 2rem 4rem;
  border: 2px solid black;
  background: transparent;
  font-size: 0.6em;
  border-radius: 2px;
}

/*hover 状态下*/
.btn:hover {
  cursor: pointer;
  background: black;
  color: white;
}
```

在哪里引入变化量呢？

这里：

```
/* 变化 */

.btn.red {
  border-color: red
}
.btn.red:hover {
  background: red
}
```

你看到我们将代码复制到好几处么？这还不错，但是我们可以用 CSS 变量来做的更好。

第一步是什么？

用 CSS 变量替代变化的颜色，别忘了给变量加上默认值。

```
.btn {
   padding: 2rem 4rem;
   border: 2px solid var(--color, black);
   background: transparent;
   font-size: 0.6em;
   border-radius: 2px;
 }

 /*hover 状态下*/
 .btn:hover {
  cursor: pointer;
   background: var(--color, black);
   color: white;
 }
```

当你写下 `background: **var(--color, black)**` 时，就是将背景色的值设置为变量 `--color` 的值，如果变量不存在的话则使用默认值 `**black**`

这就是设置变量默认值的方法，与在 JavaScript 和其它语言中的做法一样。

这是使用变量的好处。

使用了变化量，就可以用下面这种方法来应用变量的新值：

```
.btn.red {
   --color: red
 }
```

就是这么简单。现在当使用 `.red` 类时，浏览器注意到不同的 `--color` 变量值，就会立即更新按钮的样式了。

如果你要花很多时间来构建可复用组件的话，使用 CSS 变量是一个非常好的选择。

这是并排比较：

![](http://o7ts2uaks.bkt.clouddn.com/1_bdT9ITBx1wpXjLOYoWBI7w.png)

不用 CSS 变量 VS 使用 CSS 变量。

如果你有非常多的可变选项的话，使用 CSS 变量还会为你节省很多打字时间。

![](http://o7ts2uaks.bkt.clouddn.com/1_erZb3Z5FtTIR8EV9fl0QOA.png)

看出不同了吗？？

### 项目 2： 使用 CSS 变量实现主题定制

我很确定你之前一定遇到过主题定制的需求。支持主题定制的站点让用户有了自定义的体验，感觉站点在自己的掌控之中。

下面是我写的一个简单示例：

![](http://o7ts2uaks.bkt.clouddn.com/1%2Ar2TrlsC-gWRD5Hu6Tp2gjQ.gif)

使用 CSS 变量来实现有多么容易呢？

我们来看看。

在此之前，我想提醒你，这个示例非常重要。通过这个示例我将引导你理解使用 JavaScript 更新 CSS 变量的思想。

非常好玩！

你会爱上它的！

### 我们究竟想做什么。

CSS 变量的美在于其本质是响应式的。一旦 CSS 变量更新了，任意带有 CSS 变量的属性的值也都会随之更新。

从概念上讲，下面这张图解释了这个示例的流程。

![](http://o7ts2uaks.bkt.clouddn.com/1_ZONC-xXCXnGc8nr_QMv8rg.png)

流程。

因此，我们需要给点击事件监听器写一些 JavaScript 代码。

在这个简单的示例里，文本与页面的颜色和背景色都是基于 CSS 变量的。

当你点击页面上方的按钮时，JavaScript 会将 CSS 变量中的颜色切换成别的颜色，页面的背景色也就随之更新。

这就是全部了。

还有一件事。

当我说 CSS 变量切换成别的颜色时，是怎么做到的呢？

![](http://o7ts2uaks.bkt.clouddn.com/1_FeTfEPsJuDQNGDuZQQBIew.png)

行内设置变量。

即使是在行内设置，CSS 变量也会生效。在 JavaScript 中，我们控制了文档的根节点，然后就可以在行内给 CSS 变量设置新的值了。

明白了吗？

我们说了太多了，现在该干些实际的了。

### 结构初始化

初始化结构是这样的：

```
<div class="theme">
  <button value="dark">dark</button>
  <button value="calm">calm</button>
  <button value="light">light</button>
</div>

<article>
...
</article>
```

结构中有三个父元素为 `.theme` 的按钮元素。为了看起来尽可能简短，我将 `article` 元素内的内容截断了。`article` 元素内就是页面的内容。

### 设置页面样式

项目的成功始于页面的样式。这个技巧非常简单。

我们设置页面样式的 `background-color` 和 `color` 是基于变量的，而不是写死的属性值。

这就是我说的：

```
body {
  background-color: var(--bg, white);
  color: var(--bg-text, black)
}
```

这么做的原因显而易见。无论何时按钮被点击，我们都会改变文档中两个变量的值。

根据变量值的改变，页面的整体样式也就随之更新。小菜一碟。

![](http://o7ts2uaks.bkt.clouddn.com/1_HmDLDbOPHpEE2F8x4aSDYA.png)

让我们继续前进，解决在 JavaScript 中更新属性值的问题。

#### 进入 JavaScript

我将直接把这个项目所需的全部 JavaScript 展示出来。

```
const root = document.documentElement
const themeBtns = document.querySelectorAll('.theme > button')

themeBtns.forEach((btn) => {
  btn.addEventListener('click', handleThemeUpdate)
})

function handleThemeUpdate(e) {
  switch(e.target.value) {
    case 'dark':
      root.style.setProperty('--bg', 'black')
      root.style.setProperty('--bg-text', 'white')
      break
    case 'calm':
       root.style.setProperty('--bg', '#B3E5FC')
       root.style.setProperty('--bg-text', '#37474F')
      break
    case 'light':
      root.style.setProperty('--bg', 'white')
      root.style.setProperty('--bg-text', 'black')
      break
  }
}
```

不要被这段代码吓到，它比你想象的要简单。

首先，保存一份对根节点的引用， `const root = document.documentElement`

这里的根节点就是 `HTML` 元素。你很快就会明白为什么这很重要。如果你很好奇的话，我可以先告诉你一点，给 CSS 变量设置新值时需要根节点。

同样地，保存一份对按钮的引用， `const themeBtns = document.querySelectorAll('.theme > button')`

`querySelectorAll` 生成的数据是可以进行遍历的类数组结构。遍历按钮，然后给按钮设置点击事件监听。

这里是怎么做：

```
themeBtns.forEach((btn) => {
  btn.addEventListener('click', handleThemeUpdate)
})
```

`handleThemeUpdate` 函数去哪了？我们接下来就会讨论这个函数。

每个按钮被点击后，都会调用回调函数 `handleThemeUpdate`。因此知道是哪个按钮被点击以及后续该执行什么正确操作很重要。

鉴于此，我们使用了 switch `操作符`，基于被点击的按钮的值来执行不同的操作。

接下来再看一遍这段 JavaScript 代码，你会理解地更好一些。

### 项目 3： 构建 CSS 变量展位

避免你错过它，这是我们即将构建的项目：

![](http://o7ts2uaks.bkt.clouddn.com/1%2AE6H-wT6a0BDR9OJK7Z0dTA.gif)

请记住盒子的颜色是动态更新的，以及盒子容器是随着输入范围值的变化进行 3D 旋转的。

![](http://o7ts2uaks.bkt.clouddn.com/1%2Aiy_MjZVlp-H0KUQa7H7fUg.gif)

你可以直接在 [Codepen](https://codepen.io/ohansemmanuel/full/EoBLgd/) 上玩一下这个项目。

这是使用 JavaScript 更新 CSS 变量以及随之而来的响应式特性的绝佳示例。

让我们来看看如何来构建。

#### 结构

以下是所需的组件。

1.  一个范围输入框
2.  一个装载使用说明文字的容器
3.  一个装载盒子列表的 section，每个盒子包含输入框

![](http://o7ts2uaks.bkt.clouddn.com/1_39k9sbEsldtRtJ1-Woq0rQ.png)

结构变得很简单。

以下就是：

```
<main class="booth">
  <aside class="slider">
    <label>Move this 👇 </label>
    <input class="booth-slider" type="range" min="-50" max="50" value="-50" step="5"/>
  </aside>

  <section class="color-boxes">
    <div class="color-box" id="1"><input value="red"/></div>
    <div class="color-box" id="2"><input/></div>
    <div class="color-box" id="3"><input/></div>
    <div class="color-box" id="4"><input/></div>
    <div class="color-box" id="5"><input/></div>
    <div class="color-box" id="6"><input/></div>
  </section>

  <footer class="instructions">
    👉🏻 Move the slider<br/>
    👉🏻 Write any color in the red boxes
  </footer>
</main>
```

以下几件事需要注意。

1.  范围输入代表了从 `-50` 到 `50` 范围的值，step 值为 `5`。因此范围输入的最小值就是 `-50`
2.  如果你并不确定范围输入是否可以运行，可以在 [w3schools](https://www.w3schools.com/jsref/dom_obj_range.asp) 上检查以下
3.  注意类名为 `.color-boxes` 的 section 是如何包含其它 `.color-box` 容器的。这些容器中包含输入框。
4.  第一个输入框有默认值为 red。

理解了文档结构后，给它添加样式：

![](http://o7ts2uaks.bkt.clouddn.com/1_LbgNgLeTjACXCfDBExkqgg.png)

1.  把 `.slider` 和 `.instructions` 设置为脱离文档流，将它们的 position 设置为 absolute
2.  将 `body` 元素的背景色设置为日出的颜色，并在左下角用花朵作装饰
3.  将 `color-boxes` 容器定位到中间
4.  给 `color-boxes` 容器添加样式

让我们把这些任务都完成。

以下代码会完成第一步。

```
/* Slider */
.slider,
.instructions {
  position: absolute;
  background: rgba(0,0,0,0.4);
  padding: 1rem 2rem;
  border-radius: 5px
}
.slider {
  right: 10px;
  top: 10px;
}
.slider > * {
  display: block;
}


/* Instructions */
.instructions {
  text-align: center;
  bottom: 0;
  background: initial;
  color: black;
}
```

这段代码并不像你想的那般复杂。希望你能通读一遍并能读懂，如果没有的话，可以留下评论或者发个 twitter。

给 `body` 添加样式会涉及到更多内容，希望你足够了解 CSS。

既然我们想用背景颜色和背景图来设置元素的样式，那么使用 `background` 简写属性设置多个背景属性可能是最佳选择。

就是这样的：

```
body {
  margin: 0;
  color: rgba(255,255,255,0.9);
  background: url('http://bit.ly/2FiPrRA') 0 100%/340px no-repeat, var(--primary-color);
  font-family: 'Shadows Into Light Two', cursive;
}
```

`url` 是向日葵图片的链接。

接下来设置的 `0 100%` 代表图片在背景中的位置。

这个插图展示了 CSS 的 background position 属性是如何工作的：

![](http://o7ts2uaks.bkt.clouddn.com/1_uFlBKNdQ-FOcZ-XaACi4uA.png)

来自于： [CSS 进阶指南](http://bit.ly/learn_css)

![](http://o7ts2uaks.bkt.clouddn.com/1_NOPEnEV_H2RB8XYFxEcFpA.png)

来自于： [CSS 进阶指南](http://bit.ly/learn_css)

正斜杠后面的代表 `background-size` 被设置为 `340px`，如果将它设置得更小的话，图片也会变得更小。

`no-repeat`，你可能已经猜到它是做什么的。它避免背景图片自我复制，铺满背景。

最后，跟在逗号后面的是第二个背景属性声明。这一次，我们仅仅将 `background-color` 设置为 `var(primary-color)`

哇，这是个变量。

这意味着你必须定义变量。 就是这样：

```
:root {
  --primary-color: rgba(241,196,15 ,1)
}
```

这里讲主题色设置为日出黄。没什么大问题。马上，我们就会在这里设置更多的变量。

现在，我们将 `color-boxes` 定位到中间

```
main.booth {
  min-height: 100vh;

  display: flex;
  justify-content: center;
  align-items: center;
}
```

主容器充当 flex 容器，它的子元素会正确地被定位到页面中间。也就是说我们的 `color-box` 容器会被定位到页面中间。

我们把 color-boxes 以及它的子元素容器变得更好看一些。

首先，是子元素：

```
.color-box {
  padding: 1rem 3.5rem;
  margin-bottom: 0.5rem;
  border: 1px solid rgba(255,255,255,0.2);
  border-radius: 0.3rem;
  box-shadow: 10px 10px 30px rgba(0,0,0,0.4);
}
```

这就加上了好看的阴影，使得效果更酷炫了。

还没结束，我们给整体的 `container-boxes` 容器加上样式：

```
/* Color Boxes */
.color-boxes {
  background: var(--secondary-color);
  box-shadow: 10px 10px 30px rgba(0,0,0,0.4);
  border-radius: 0.3rem;

  transform: perspective(500px) rotateY( calc(var(--slider) * 1deg));
  transition: transform 0.3s
}
```

哇！

变得太复杂了。

去掉一些。

变得简单点：

```
.color-boxes {
   background: var(--secondary-color);
   box-shadow: 10px 10px 30px rgba(0,0,0,0.4);
   border-radius: 0.3rem;
}
```

你知道效果会变成什么样，对吧？

这里有个新变量，需要在根元素中声明添加进来。

```
:root {
  --primary-color: rgba(241,196,15 ,1);
  --secondary-color: red;
}
```

第二个颜色是红色，我们会给容器加上红色的背景。

接下来这部分可能会让你觉得难以理解：

```
/* Color Boxes */
.color-boxes {
  transform: perspective(500px) rotateY( calc(var(--slider) * 1deg));
  transition: transform 0.3s
}
```

又是我们会将 transform 的属性值简写成上面这样。

![](http://o7ts2uaks.bkt.clouddn.com/1_oNaNYDRDRZPSEga9Oo4bPw.png)

举个例子：

```
transform: perspective(500px) rotateY( 30deg);
```

这个 transform 简写用了两个不同的函数。一个是视角，另一个是沿着 Y 轴旋转。

那么 `perspective` 函数 和 `rotateY` 函数是做什么的呢？

perspective() 函数应用于 3D 空间内旋转的元素。它激活了三维空间，并沿 z 轴给出元素的深度。

可以在 [codrops](https://tympanus.net/codrops/css_reference/transform/#section_perspective) 上阅读更多有关 perspective 的知识。

`rotateY` 函数是干什么的？

激活三维空间后，元素具有了 x，y，z 轴。`rotateY` 就是元素围绕 `Y` 平面旋转。

下面这个 [codrops](https://tympanus.net/codrops/css_reference/transform/#section_rotate3d) 的图对于视觉化理解很有帮助。

![](http://o7ts2uaks.bkt.clouddn.com/1_kFdzSl4wwyPJt_Crmbtuow.png)

[Codrops](https://tympanus.net/codrops/css_reference/transform/#section_rotate3d)

我希望这能让你更明白一些。

回到之前的话题。

![](http://o7ts2uaks.bkt.clouddn.com/1_oNaNYDRDRZPSEga9Oo4bPw.png)

当你回到这里，你知道哪个函数影响 `.container-box` 的旋转了吗？

是 rotateY 函数使得盒子沿着 Y 周旋转。

由于传入 rotateY 函数的值将被 JavaScript 更新，这个值也将通过变量来传入。

![](http://o7ts2uaks.bkt.clouddn.com/1_oL_Ik1Xg_ByTc28g2B1ESg.png)

为什么要给变量乘上 1deg？

作为一般的经验法则，为了显式地更灵活，建议在构建单独符号时变量中储存没有单位的值。

通过 `calc` 函数，你可以用乘法将它们转化成任何单位。

![](http://o7ts2uaks.bkt.clouddn.com/1_jsB27oUUYY48n3s9wAmd_Q.png)

这意味着你可以为所欲为。将作为比例的 `deg` 转换为视窗单位 `vw` 也可以。

在这个场景中，我们通过 “数字” 乘上 1deg 将数字转换成角度

![](http://o7ts2uaks.bkt.clouddn.com/1_5j1qhUmE2pB99qw17Zp4iA.png)

由于 CSS 不懂数学，你需要将公式传入 calc 函数，这样 CSS 才能正确计算。

完成之后我们就可以继续了。我们可以在 JavaScript 中用各种方法来更新它。

现在，只剩下一点点的 CSS 代码需要写了。

就是这些：

```
/* 给每个盒子添加颜色 */
.color-box:nth-child(1) {
  background: var(--bg-1)
}
.color-box:nth-child(2) {
  background: var(--bg-2)
}
.color-box:nth-child(3) {
  background: var(--bg-3)
}
.color-box:nth-child(4) {
  background: var(--bg-4)
}
.color-box:nth-child(5) {
  background: var(--bg-5)
}
.color-box:nth-child(6) {
  background: var(--bg-6)
}
```

这些奇怪的东西是什么？

首先，nth-child 选择器用来选择子盒子。

![](http://o7ts2uaks.bkt.clouddn.com/1_T5oqa3Kh5ChIcgi5ldqXKg.png)

这里需要一些前瞻。我们知道，每个盒子的背景色都会更新。我们也知道背景色需要用变量表示，以在 JavaScript 中更新。对吧？

接下来：

```
.color-box:nth-child(1) {
  background: var(--bg-1)
}
```

简单吧。

这里有个问题。如果变量不存在的话怎么办？

我们一个回退方式。

这是可行的：

```
.color-box:nth-child(1) {
  background: var(--bg-1, red)
}
```

在这个特殊实例中，我选择**不提供**任何回退方式。

如果某个属性值中使用的变量非法，属性将使用其初始值。

因此，当 `--bg-1` 非法或者不可用时，背景色会默认切换成它的初始颜色或者透明。

初始值指向属性还未显式设置时的值。比如说，如果你没有给元素设置 `background-color` 属性的话，它的背景色会默认为 `transparent`

初始值是一种默认属性值。

### 写点 JavaScript

在 JavaScript 这一边需要做的事情很少。

首先要处理一下 slider。

仅仅五行代码就可以！

```
const root = document.documentElement
const range = document.querySelector('.booth-slider')

// 一旦 slider 的范围值发生变化，就执行回调
range.addEventListener('input', handleSlider)

function handleSlider (e) {
  let value = e.target.value
  root.style.setProperty('--slider', value)
}
```

这很简单，对吧？

我来解释一下。

首先，保存一份 slider 元素的引用，`const range = document.querySelector('.booth-slider')`

设置一个事件监听器，一旦范围输入值发生变化就会触发，`range.addEventListener('input', handleSlider)`

写一个回调函数， `handleSlider`

```
function handleSlider (e) {
  let value = e.target.value
  root.style.setProperty('--slider', value)
}
```

![](http://o7ts2uaks.bkt.clouddn.com/1_bQwZp0psRdiNn2harZW-HQ.png)

`root.style.setProperty('--slider', value)` 的意思是获取 `root` 元素（HTML），读取它的样式，并给它设置属性。

### 处理颜色变化

这与处理 slider 值的变化一样简单。

这么做就可以：

```
const inputs = document.querySelectorAll('.color-box > input')

// 一旦输入值发生变化，执行回调
inputs.forEach(input => {
  input.addEventListener('input', handleInputChange)
})

function handleInputChange (e) {
  let value = e.target.value
  let inputId = e.target.parentNode.id
  let inputBg = `--bg-${inputId}`
  root.style.setProperty(inputBg, value)
}
```

保存一份所有文本输入的引用， `const inputs = document.querySelectorAll('.color-box > input')`

给每个输入框加上事件监听：

```
inputs.forEach(input => {
   input.addEventListener('input', handleInputChange)
})
```

写 `handleInputChange` 函数：

```
function handleInputChange (e) {
  let value = e.target.value
  let inputId = e.target.parentNode.id
  let inputBg = `--bg-${inputId}`
  root.style.setProperty(inputBg, value)
}
```

![](http://o7ts2uaks.bkt.clouddn.com/1_A3e4duLT1V1-8_NqVF1DGg.png)

嗯……

就是这些！

项目完成了。

### 我遗漏了什么？

当我完成并修改了初稿后才发现我没有提到浏览器支持。那让我来处理这个烂摊子。

对于 CSS 变量的（又名自定义属性）浏览器支持并不差。 浏览器支持性非常好，基本所有的现代浏览器都支持良好（本文写作时已超过 87%）。

![](http://o7ts2uaks.bkt.clouddn.com/1_JdhBIufk2SvuY-8U2POD8g.png)

[caniuse](https://caniuse.com/#search=css%20var)

那么，你可以在生产环境使用 CSS 变量吗？当然可以！但是这多大程度上适用与你还需自己判断。

好的一面是，你可以使用像 [Myth](http://www.myth.io) 这样的预处理器来使用 CSS 变量。它将“未来的” CSS 预编译成现在你就可以使用的代码，是不是很赞？

如果你有使用 [postCSS](http://postcss.org) 的经验， 这也同样是一个好方法。这是 [postCSS 的 CSS 变量模块](https://www.npmjs.com/package/postcss-css-variables)。

就这些，我已全部写完。

### 不好，我遇到了问题！

![](http://o7ts2uaks.bkt.clouddn.com/1_Bb085Ip_NKnPDVY7g3lL3g.png)

[购买电子书](https://gum.co/lwaUh) 可以线上阅读, 还能获得 **私人的** slack 邀请，你可以向我咨询任何问题。

这是个公平交易，对吧？

稍后联系！ 💕


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
