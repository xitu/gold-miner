> * 原文地址：[Code Smells in CSS Revisited](https://csswizardry.com/2017/02/code-smells-in-css-revisited/)
* 原文作者：[Harry](https://csswizardry.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[IridescentMia](https://github.com/IridescentMia)
* 校对者：[rccoder](https://github.com/rccoder), [Germxu](https://github.com/Germxu)

# 再谈 CSS 中的代码味道 #

回到 2012 年，我写了一篇关于潜在 CSS 反模式的文章 [CSS中的代码味道](https://csswizardry.com/2012/11/code-smells-in-css/)。回看那篇文章，尽管四年过去了，我依然认同里面的全部内容，但是我有一些新的东西加到列表中。再次说明，这些内容并不一定总是坏的东西，因此把它们称为代码味道：在你的使用案例中它们也许可以很好的被接受，但是它们仍然让人觉得有一点奇怪。

在我们开始前，让我们回想一下什么是代码味道，摘自 [维基百科](https://en.m.wikipedia.org/wiki/Code_smell) (emphasis mine)：

> 代码味道，也被称作代码异味，在计算机编程领域，指程序源代码中的任何 **有可能预示着更深层次问题** 的征兆。按照 Martin Fowler 所说的，「代码味道是一种表面迹象，通常对应着系统中的深层次问题」。另外一种看待代码味道方式是关于准则和质量：「代码味道是代码中某种特定的结构表明了 **违反了基本的设计准则** 并且对设计质量产生负面影响」，代码味道通常不是 bug —— **它们不是技术性的错误** 并且不会当时就对程序的功能产生阻碍。相反的，**它们预示着可能拖慢开发的设计缺陷** 或者增大未来出现 bug 或者故障的风险。代码异味是导致技术债的因素的指示器。Robert C. Martin 将一系列代码味道称作软件技艺的「价值体系」
。

因此, 它们并不总是技术上的错误, (不过)它们可作为一个不错的检验方法。

## `@extend` ##

希望我可以把这第一条讲得细致又简洁：我早就被告知 `@extend` 的副作用和陷阱，我也会积极地认为它是代码味道。它也并不绝对的不好，虽然通常是的。对它应该持怀疑态度。

`@extend`的问题是多方面的，可以概括如下：

- **它对性能的影响事实上比 mixins 更严重。** Gzip 偏爱重复性的内容，所以具有更高重复性 CSS 文件 (如 mixins) 取得更高的压缩量。
 
- **它是贪婪的。** Sass 的 `@extend` 将会 `@extend` 它找到的每个 class 的实例，返回给我们一个相当长的选择器链 [看起来像这样](https://twitter.com/gaelmetais/status/564109775995437057)。

- **它移动你的代码库的顺序。** 在 CSS 中原始的顺序至关重要，所以应该总是避免在你的项目中移动选择器的位置。

- **它使文件晦涩难懂。** `@extend` 在你的 Sass 中隐藏了很多复杂的东西，你需要逐步的拆开，然而在你审阅文件的过程中，这个复杂的 class 方法将所有的信息置于焦点。

扩展阅读：

- [Mixins Better for
Performance](https://csswizardry.com/2016/02/mixins-better-for-performance/)
- [When to Use `@extend`; When to Use a
Mixin](https://csswizardry.com/2014/11/when-to-use-extend-when-to-use-a-mixin/)
- [Extending Silent Classes in
Sass](https://csswizardry.com/2014/01/extending-silent-classes-in-sass/)

## 为类使用连接字符串 ##

另外一个 Sass 让人恼火的地方就是在你的类上使用 `&` 连接字符串，例如：

```
.foo {
  color: red;

  &-bar {
    font-weight: bold;
  }

}

```

编译成：

```
.foo {
  color: red;
}

.foo-bar {
  font-weight: bold;
}

```

显而易见的好处是简洁：事实上我们只用写一次命名空间 `foo` 确实是很 DRY （Don't repeat yourself）。

一个不那么明显的缺点是，字符串 `foo-bar` 现在在源代码中不存在。搜索代码库查找 `foo-bar` 只会返回 HTML 中的结果（或者是编译过的 CSS 文件，如果你已经把它纳入到你的项目中）。想要在源代码中定位 `.foo-bar` 的样式变得非常困难。

我不仅仅是 CSS 全称写法的爱好者：总的来说，相比于重新为元素命名一个类，我更喜欢查找到它原有的类名，所以可查找性对我来说很重要。如果我加入一个项目大量使用 Sass 的字符串连接，追踪查找通常都会是非常艰难的。

当然你也可以说 sourcemaps 将会帮助我们，或者如果我正在查找 `.nav__item` 这个类，我可以简单的打开 `nav.scss` 这个文件，但是不幸的是这并不总是奏效。获得更多的信息，可以看我做的关于它的 [录屏](https://www.youtube.com/watch?v=MGzoRM3Al40)。

## Background 简写 ##

我最近讨论的另外一个主题就是使用 `background` 简写语法。想了解更多细节，请参考 [the relevant article](https://csswizardry.com/2016/12/css-shorthand-syntax-considered-an-anti-pattern/)，但是在这里做一个总结如下：

```
.btn {
  background: #f43059;
}

```

…当你可能想要表达的意思是：

```
.btn {
  background-color: #f43059;
}

```

…这是另一种代码味道的实践。当我看到前者被使用的时候，很少是开发者实际上想要的：几乎任何时候他们真正的意思是后者。后者 *仅仅* 设置或者改变背景色，而前者将会也重置或者复原背景图、背景位置、背景链接等。

在 CSS 项目中看到这样的形式立即提醒我，我们终究会因为它遇到问题。

## 关键选择器多次出现 ##

关键选择器是获得目标或者是被赋予样式的选择器。它通常在左花括号 (`{`) 前面的内容，但也并不总是。在下面的 CSS 中：

```
.foo {}

nav li .bar {}

.promo a,
.promo .btn {}

```

…关键选择器是：

- `.foo`,
- `.bar`,
- `a`,
- `.btn`.

如果我负责一个代码库并且 [ack for `.btn`](https://csswizardry.com/2017/01/ack-for-css-developers/)，我可能看到如下输出：

```
.btn {}

.header .btn,
.header .btn:hover {}

.sidebar .btn {}

.modal .btn {}

.page aside .btn {}

nav .btn {}

```

除了很多普遍存在的相当糟糕的 CSS，我在这里想指出的问题是 `.btn` 被定义了很多次，这告诉我：

1. **没有遵循 Single Source of Truth** 告诉我按钮看起来是什么样的；
2. **有很多变化** 意思是 `.btn` 类有很多潜在的不同的样式，所有的这些都是通过 CSS 的可变性造成的。

一看到像这样的 CSS，我就意识到在按钮上做任何工作都将会有很大的影响，追踪按钮样式到底来自哪里将会非常困难，并且任何位置的改动都有可能对其他地方造成影响。这就是 CSS 可变性的关键性问题之一。

使用 BEM 的命名形式以便创建全新的类名称以应对这些改变，例如：

```
.btn {}

.btn--large {}

.btn--primary {}

.btn--ghost {}

```

每个只有一个关键选择器

## 一个类名出现在另一个组件的文件中 ##

在一个和上面相似但是稍微不同的场景里，类名出现在另一个组件的文件中预示着代码味道。

上一个代码味道处理同一个关键选择器有多于一个实例的问题，这个代码味道处理这些选择器应该放在哪。这个问题来自于 [Dave Rupert](https://twitter.com/davatron5000)：

如果我们需要给某些因为它们的上下文的不同而加样式，我们应该把这些额外的样式加到哪呢？

1. 要加样式的对象所在的文件里？
2. 控制该对象上下文的文件里？

让我们假设我们有如下 CSS：

```
.btn {
  [styles]
}

.modal .btn {
  font-size: 0.75em;
}

```

`.modal .btn {}` 应该放在哪？

它应该 **在 `.btn` 所在的文件中。**

我们应该尽量将我们的样式基于主题（例如：关键选择器）分组。在这个例子中，主题是 `.btn`：这才是我们真正关心的。`.modal` 只不过是 `.btn` 的上下文，所以我们根本没给它添加样式。为此，我们不应该将 `.btn` 的样式移出到另外的文件中。

我们不这样做简单的因为它们是并列的：将所有按钮的上下文放在一处更方便。如果我想得到项目中所有按钮样式的概观，我仅仅需要打开 `_components.buttons.scss`，而不是一堆其他的文件。

这样做使得将所有按钮的样式移入另外一个新项目变得更容易，更重要的是这样做提前读懂变得容易。我相信你们都对这种感觉相当熟悉，就是文本编辑器中打开十余个文件，而仅仅试图修改很小的一处样式。这是我们能够避免的。

将你的样式基于主题的分组到文件中：如果是给按钮的样式，无论它是什么样的，我们应该让它在 `_components.buttons.scss` 文件中。

一个简单的经验法则就是，问问你自己这样的问题，我是在给 x 添加样式还是 y？如果答案是 x，那么你的 CSS 应该在 `x.css` 文件中；如果答案是 y，它应该在  `y.css` 中。 

### BEM Mixes ###

事实上很有趣的，我根本不会这样写 CSS —— 我使用 BEM mix —— 但是这是另一个不同问题的答案。不是像下面这样：

```
// _components.buttons.scss

.btn {
  [styles]
}

.modal .btn {
  [styles]
}

// _components.modal.scss

.modal {
  [styles]
}

```

而是像这样：

```
// _components.buttons.scss

.btn {
  [styles]
}

// _components.modal.scss

.modal {
  [styles]
}

  .modal__btn {
    [styles]
  }

```

第三，新的类名称将会应用于 HTML 上，像这样

```
<div class="modal">
  <button class="btn  modal__btn">Dismiss</button>
</div>

```

这被叫做 BEM mix，我们介绍第三种新的类名称来指向属于 modal 的按钮。这样避免了它在哪里的问题，它通过避免嵌套，减少了名称唯一性的问题，同时通过重复 `.btn` 类避免可变性带来的问题。完美！

## CSS `@import` ##

我会说 CSS `@import` 不仅仅是代码味道，它的的确确是坏的实践。它推迟 CSS 文件的加载（性能的决定性因素），比实际的需要加载的更晚，造成严重的性能下降。下载具有 `@import` 的 CSS 文件的（简化的）工作流程看起来有点像：

1. 获取 HTML 文件，这个 HTML 文件中请求 CSS 文件;
2. 获取 CSS 文件，这个 CSS 文件请求另外一个 CSS 文件；
3. 获取最后一个 CSS 文件；
4. 开始渲染页面。

如果我们得到 `@import` 的内容，将其压入一个单独的文件，工作流程看起来将会是这样：

1. 获取 HTML 文件，这个 HTML 文件中请求 CSS 文件;
2. 获取 CSS 文件;
3. 开始渲染页面。

如果我们不能将所有的 CSS 放入一个文件（例如我们链接了谷歌字体），那么我们应该在 HTML 中使用两个 `<link />` 元素，而不是使用 `@import`。这可能让人感觉有点不那么压缩（但也是更好的方式处理所有 CSS 文件的依赖），它对于性能仍然是比较友好的：

1. 获取 HTML 文件，这个 HTML 文件中请求 CSS 文件;
2. 获取所有的 CSS 文件;
3. 开始渲染页面。

---

所以我们在这里对我先前那篇关于代码味道的文章做了几点添加。这些是我已经看到的并且忍受着的几点：希望现在你也可以避开他们。
