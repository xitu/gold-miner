> * 原文地址：[Code Smells in CSS Revisited](https://csswizardry.com/2017/02/code-smells-in-css-revisited/)
* 原文作者：[Harry](https://csswizardry.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[IridescentMia](https://github.com/IridescentMia)
* 校对者：

# Code Smells in CSS Revisited #
# 再谈 CSS 中的代码味道 #

Way back in 2012, I wrote a post about potential CSS anti-patterns called
[Code Smells in CSS](/2012/11/code-smells-in-css/). Looking back on
that piece, I still agree with all of it even four years later, but I do have
some new things to add to the list. Again, these aren’t necessarily always bad
things, hence referring to them as code smells: they might be perfectly
acceptable in your use case, but they still smell kinda funny.
回到2012年，我写了一篇关于可能存在的 CSS 反面教材的帖子 [CSS中的代码味道](/2012/11/code-smells-in-css/)。回看那篇文章，尽管四年过去了，我依然认同里面的全部内容，但是我有一些新的东西加到列表中。再次说明，这些内容并不一定总是坏的东西，因此把它们称为代码味道：在你的使用案例中它们也许可以很好的被接受，但是它们仍然让人觉得有一点奇怪。

Before we start, then, let’s remind ourselves what a Code Smell actually is.
From [Wikipedia](https://en.m.wikipedia.org/wiki/Code_smell) (emphasis mine):
在我们开始前，让我们回想一下什么是代码味道，摘自 [维基百科](https://en.m.wikipedia.org/wiki/Code_smell) (emphasis mine)：

> Code smell, also known as bad smell, in computer programming code, refers to
> any symptom in the source code of a program that **possibly indicates a deeper
> problem**. According to Martin Fowler, ‘a code smell is a surface indication
> that usually corresponds to a deeper problem in the system’. Another way to
> look at smells is with respect to principles and quality: ‘smells are certain
> structures in the code that indicate **violation of fundamental design
> principles** and negatively impact design quality’. Code smells are usually
> not bugs—**they are not technically incorrect**  and do not currently prevent
> the program from functioning. Instead, **they indicate weaknesses in design
> that may be slowing down development** or increasing the risk of bugs or
> failures in the future. Bad code smells can be an indicator of factors that
> contribute to technical debt. Robert C. Martin calls a list of code smells a
> ‘value system’ for software craftsmanship.

> 代码味道，也被称作代码异味，在计算机编程领域，指程序源代码中的任何 **有可能预示着更深层次问题** 的征兆。按照 Martin Fowler 所说的，“代码味道是一种表面迹象，通常对应着系统中的深层次问题”。另外一种看待代码味道方式是关于准则和质量：“代码味道是代码中某种特定的结构表明了 **违反了基本的设计准则** 并且对设计质量产生负面影响”，代码味道通常不是 bug -**它们不是技术性的错误** 并且不会当时就对程序的功能产生阻碍。相反的，**它们预示着可能拖慢开发的设计上的缺陷** 或者增大未来出现 bug 或者故障的风险。代码异味是促成技术债的因素的指示器。Robert C. Martin 将一系列代码味道称作软件技艺的“价值体系”
。

So they’re not technically, always wrong, they’re just a good litmus test.
因此它们不是技术上多大的问题，并不总是错的，它们只是很不错的检验办法。

## `@extend` ##

Hopefully I can keep this first one nice and brief: I have long been vocal about
the side effects and pitfalls of `@extend`, and now I would actively consider it
a code smell. It’s not absolutely, always, definitely bad, but it usually is.
Treat it with suspicion.
希望我可以把这第一条讲的细致又简洁：我早就被告知 `@extend` 的副作用和陷阱，我也会积极地认为它是代码味道。它也并不绝对的总是不好的，但是通常它是。对它持有一种怀疑的态度。

The problems with `@extend` are manifold, but to summarise:
`@extend`的问题是多方面的，可以概括如下：

- **It’s actually worse for performance than mixins are.** Gzip favours
repetition, so CSS files with greater repetition (i.e. mixins) achieve a
greater compression delta.
- **它对性能的影响事实上比 mixins 更严重。** Gzip 偏爱重复性的内容，所以具有更高重复性 CSS 文件 (如mixins) 取得更好的压缩 delta。
 
- **It’s greedy.** Sass’ `@extend` will `@extend` every instance of a class that
it finds, giving us crazy-long selector chains [that look like
this](https://twitter.com/gaelmetais/status/564109775995437057).
- **它是贪婪的。** Sass的 `@extend` 将会 `@extend` 它找到的每个 class 的实例，返回给我们一个相当长的选择器链 [看起来像这样](https://twitter.com/gaelmetais/status/564109775995437057)

- **It moves things around your codebase.** Source order is vital in CSS, so
moving selectors around your project should always be avoided.
- **它移动你的代码库的顺序。** 在 CSS 中原始的顺序至关重要，所以应该总是避免在你的项目中移动选择器的位置。

- **It obscures the paper-trail.**`@extend` hides a lot of complexity in your
Sass that you need to unpick more gradually, whereas the multiple class
approach puts all of the information front-and-center in your markup.
- **它使文件晦涩难懂。** `@extend` 在你的 Sass 中隐藏了很多复杂的东西，你需要逐步的拆开，然而在你审阅文件的过程中，这个复杂的 class 方法将所有的信息置于焦点。

For further reading:
扩展阅读：

- [Mixins Better for
Performance](/2016/02/mixins-better-for-performance/)
- [When to Use `@extend`; When to Use a
Mixin](/2014/11/when-to-use-extend-when-to-use-a-mixin/)
- [Extending Silent Classes in
Sass](/2014/01/extending-silent-classes-in-sass/)

## String Concatenation for Classes ##
## 为类使用连接字符串 ##

Another Sass-based gripe is the use of the `&` to concatenate strings in your
classes, e.g.:
另外一个 Sass 让人恼火的地方就是在你的类上使用 `&` 连接字符串，例如：

```
.foo {
  color: red;

  &-bar {
    font-weight: bold;
  }

}

```

Which yields:
编译成：

```
.foo {
  color: red;
}

.foo-bar {
  font-weight: bold;
}

```

The obvious benefit of this is its terseness: the fact that we have to write our
`foo` namespace only once is certainly very DRY.
显而易见的好处是简洁：事实上我们只用写一次命名空间 `foo` 确实是很 DRY （Don't repeat yourself）。

One less obvious downside, however, is the fact that the string `foo-bar` now no
longer exists in my source code. Searching my codebase for `foo-bar` will
return only results in HTML (or compiled CSS if we’ve checked that into our
project). It suddenly became a lot more difficult to locate the source of
`.foo-bar`’s styles.
一个不那么明显的缺点是，字符串 `foo-bar` 现在在源代码中不存在。搜索代码库查找 `foo-bar` 只会返回 HTML 中的结果（或者是编译过的 CSS 文件，如果你已经把它纳入到你的项目中）。想要在源代码中定位 `.foo-bar` 的样式变得非常困难。

I am much more a fan of writing my CSS longhand: on balance, I am far more
likely to look for a class than I am to rename it, so findability wins for me.
If I join a project making heavy use of Sass’ string concatenation, I’m usually
expecting to have a hard time tracking things down.
我不仅仅是 CSS 全称写法的爱好者：总的来说，相比于重新为元素命名一个类，我更喜欢查找到它原有的类名，所以可查找性对我来说很重要。如果我加入一个项目大量使用 Sass 的字符串连接，追踪查找通常都会是非常艰难的。

Of course you could argue that sourcemaps will help us out, or that if I’m
looking for a class of `.nav__item` then I simply need to open the `nav.scss`
file, but unfortunately that’s not always going to help. For a little more
detail, I made [a screencast](https://www.youtube.com/watch?v=MGzoRM3Al40) about
it.
当然你也可以说 sourcemaps 将会帮助我们，或者如果我正在查找 `.nav__item` 这个类，我可以简单的打开 `nav.scss` 这个文件，但是不幸的是这并不总是能奏效。获得更多的信息，可以看我做的关于它的 [录屏](https://www.youtube.com/watch?v=MGzoRM3Al40)。

## Background Shorthand ##
## Background 简写 ##

Something else I discussed only recently is the use of `background` shorthand
syntax. For full details, please refer to [the relevant
article](/2016/12/css-shorthand-syntax-considered-an-anti-pattern/), but the
summary here is that using something like:
我最近讨论的另外一个主题就是使用 `background` 简写语法。想了解更多细节，请参考 [the relevant article](/2016/12/css-shorthand-syntax-considered-an-anti-pattern/)，但是在这里做一个总结如下：

```
.btn {
  background: #f43059;
}

```

…when you probably meant:
…当你可能想要表达的意思是：

```
.btn {
  background-color: #f43059;
}

```

…is another practice I would consider a code smell. When I see the former being
used, it is seldom what the developer actually intended: nearly every time they
really meant the latter. Where the latter *only* sets or modifies a background
colour, the former will also reset/unset background images, positions,
attachments, etc.
…这是另一种代码味道的实践。当我看到前者被使用的时候，很少是开发者实际上想要的：几乎任何时候他们真正的意思是后者。后者 *仅仅* 设置或者改变背景色，而前者将会也重置或者复原背景图，背景位置，背景链接等。

Seeing this in CSS projects immediately warns me that we could end up having
problems with it.
在 CSS 项目中看到这样的形式立即提醒我，我们终究会因为它遇到问题。

## Key Selector Appearing More Than Once ##
## 关键选择器多次出现 ##

The key selector is the selector that actually gets targeted/styled. It is
often, though not always, the selector just before your opening curly brace
(`{`). In the following CSS:
关键选择器是获得目标或者是被赋予样式的选择器。它通常在左花括号 (`{`) 前面的内容，但也并不总是。在下面的 CSS 中：

```
.foo {}

nav li .bar {}

.promo a,
.promo .btn {}

```

…the key selectors are:
…关键选择器是：

- `.foo`,
- `.bar`,
- `a`, and
- `.btn` respectively.

If I were to take a codebase and [ack for
`.btn`](/2017/01/ack-for-css-developers/), I might see some output like this:
如果我负责一个代码库并且 [ack for `.btn`](/2017/01/ack-for-css-developers/)，我可能看到如下输出：

```
.btn {}

.header .btn,
.header .btn:hover {}

.sidebar .btn {}

.modal .btn {}

.page aside .btn {}

nav .btn {}

```

Aside from the fact that a lot of that is just generally pretty poor CSS, the
problem I’m spotting here is that `.btn` is defined many times. This tells me
that:
除了很多普遍存在的相当糟糕的 CSS，我在这里向指出的问题是 `.btn` 被定义的很多次，这告诉我：

1. **there is no Single Source of Truth** telling me what buttons look like;
2. **there has been a lot of mutation** meaning that the class `.btn` has many
different potential outcomes, all via mutable CSS.

1. **没有遵循 Single Source of Truth** 告诉我按钮看起来是什么样的；
2. **有很多变化** 意思是 `.btn` 类有很多潜在的不同的样式，所有的这些都是通过 CSS 的可变性造成的。

As soon as I see CSS like this, I’m aware of the fact that doing any work on
buttons will have a large surface area, tracking down exactly where buttons’
styles come from will be a lot more difficult, and that changing anything will
likely have huge knock-on effects elsewhere. This is one of the key problems
with mutable CSS.
一看到像这样的 CSS，我就意识到在按钮上做任何工作都将会有很大的影响面，追踪按钮样式到底来自哪里将会非常困难，并且任何位置的改动都有可能对其他地方造成影响。这就是 CSS 可变性的关键性问题之一。

Make use of something like BEM in order to create completely brand new classes
that carry those changes, e.g.:
使用 BEM 的命名形式以便创建全新的类名称以应对这些改变，例如：

```
.btn {}

.btn--large {}

.btn--primary {}

.btn--ghost {}

```

Just one key selector each.
每个只有一个关键选择器

## A Class Appearing in Another Component’s File ##
## 一个类名出现在另一个组件文件中 ##

On a similar but subtly different theme as above, the appearance of classes in
other components’ files is indicative of a code smell.
在一个和上面相似但是稍微不同的场景里，类名出现在另一个组件文件中预示着代码味道。

Where the previous code smell deals with the question of there being more than
one instance of the same key selector, this code smell deals with where those
selectors might live. Take this question from [Dave
Rupert](https://twitter.com/davatron5000):
上一个代码味道处理同一个关键选择器有超过一个的实例的问题，这个代码味道处理这些选择器应该放在哪。这个问题来自于 [Dave Rupert](https://twitter.com/davatron5000)：

If we need to style something differently because of its context, where should
we put that additional CSS?
如果我们需要给某些因为它们的上下文的不同而加样式，我们应该把这些额外的样式加到哪呢？

1. In the file that styles the thing?
2. In the file that controls that context?

1. 要加样式的对象所在的文件里？
2. 控制该对象上下文的文件里？

Let’s say we have the following CSS:
让我们假设我们有如下 CSS：

```
.btn {
  [styles]
}

.modal .btn {
  font-size: 0.75em;
}

```

Where should `.modal .btn {}` live?
`.modal .btn {}` 应该放在哪？

It should live **in the `.btn` file.**
它应该 **在 `.btn` 所在的文件中。**

We should do our best to group our styles based on the subject (i.e. the key
selector). In this example, the subject is `.btn`: that’s the thing we actually
care about. `.modal` is purely a context for `.btn`, so we aren’t styling it at
all. To this end, we shouldn’t move `.btn` styling out into another file.
我们应该尽量将我们的样式基于主题（例如：关键选择器）分组。在这个例子中，主题是 `.btn`：这才是我们真正关心的。`.modal` 只不过是 `.btn` 的上下文，所以我们根本没给它添加样式。为此，我们不应该将 `.btn` 的样式移出到另外的文件中。

The reason we shouldn’t do this is simply down to collocation: it’s much more
convenient to have the context of all of our buttons in one place. If I want to
get a good overview of all of the button styles in my project, I should expect
to only have to open `_components.buttons.scss`, and not a dozen other files.
我们不这样做简单的因为它们是并列的：将所有按钮的上下文放在一处更方便。如果我想得到项目中所有按钮样式的概观，我仅仅需要打开 `_components.buttons.scss`，而不是一堆其他的文件。

This makes it much easier to move all of the button styles onto a new project,
but more importantly it eases cognitive overhead. I’m sure you’re all familiar
with the feeling of having ten files open in your text editor whilst just trying
to change one small piece of styling. This is something we can avoid.
这样做使得将所有按钮的样式移入另外一个新项目变得更容易，更重要的是这样做提前读懂变得容易。我相信你们都对这种感觉相当熟悉，就是文本编辑器中打开十余个文件，而仅仅试图修改很小的一处样式。这是我们能够避免的。

Group your styles into files based on the subject: if it styles a button, no
matter how it goes about it, we should see it in `_components.buttons.scss`.
将你的样式基于主题的分组到文件中：如果是给按钮的样式，无论它是什么样的，我们应该让它在 `_components.buttons.scss` 文件中。

As a simple rule of thumb, ask yourself the question am I styling
x or am I styling y? If the answer is x,
then your CSS should live in `x.css`; if the answer is y, it should
live in `y.css`.
一个简单的经验法则就是，问问你自己这样的问题，我是在给 x 添加样式还是 y？如果答案是 x，那么你的 CSS 应该在 `x.css` 文件中；如果答案是 y，它应该在  `y.css` 中。 

### BEM Mixes ###

Actually, interestingly, I wouldn’t write this CSS at all—I’d use a BEM mix—but
that’s an answer to a different question. Instead of this:
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

We’d have this:
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

This third, brand new class would get applied to the HTML like this:
第三，新的类名称将会应用于 HTML 上，像这样

```
<div class="modal">
  <button class="btn  modal__btn">Dismiss</button>
</div>

```

This is called a BEM mix, in which we introduce a third brand new class to refer
to a button belonging to a modal. This avoids the question of where things live,
it reduces the specificity by avoiding nesting, and also prevents mutation by
avoiding repeating the `.btn` class again. Magical.
这被叫做 BEM mix，我们介绍第三种新的类名称来指向属于 modal 的按钮。这样避免了它在哪里的问题，它通过避免嵌套，减少了名称唯一性的问题，同时通过重复 `.btn` 类避免可变性带来的问题。真神奇。

## CSS `@import` ##

I would go as far as saying that CSS `@import` is not just a code smell, it’s an
active bad practice. It poses a huge performance penalty in that it delays the
downloading of CSS (which is a critical asset) until later than necessary. The
(simplified) workflow involved in downloading `@import`ed CSS looks a little
like:
我会说 CSS `@import` 不仅仅是代码味道，它的的确确的坏的实践。它推迟 CSS 文件的加载（性能的决定性因素），比实际的需要加载的更晚，造成严重的性能下降。下载具有 `@import` 的 CSS 文件的（简化的）工作流程看起来有点像：

1. Get the HTML file, which asks for a CSS file;
2. Get the CSS file, which asks for another CSS file;
3. Get the last CSS file;
4. Begin rendering the page.

1. 获取 HTML 文件，这个 HTML 文件中请求 CSS 文件;
2. 获取 CSS 文件，这个 CSS 文件请求另外一个 CSS 文件；
3. 获取最后一个 CSS 文件；
4. 开始渲染页面。

If we’d got that `@import` flattened into one single file, the workflow would
look more like this:
如果我们得到 `@import` 的内容，将其压入一个单独的文件，工作流程看起来将会是这样：

1. Get the HTML file, which asks for a CSS file;
2. Get the CSS file;
3. Begin rendering the page.

1. 获取 HTML 文件，这个 HTML 文件中请求 CSS 文件;
2. 获取 CSS 文件;
3. 开始渲染页面。

If we can’t manage to smush all of our CSS into one file (e.g. we’re linking to
Google Fonts), then we should use two `<link />` elements in our HTML instead of
`@import`. While this might feel a little less encapsulated (it would be nicer
to handle all of these dependencies in our CSS files), it’s still much better
for performance:
如果我们不能将所有的 CSS 放入一个文件（例如我们链接了谷歌字体），那么我们应该在 HTML 中使用两个 `<link />` 元素，而不是使用 `@import`。这可能让人感觉有点不那么压缩（但也是更好的方式处理所有 CSS 文件的依赖），它对于性能仍然是比较友好的：

1. Get the HTML file, which asks for two CSS files;
2. Get both CSS files;
3. Begin rendering the page.

1. 获取 HTML 文件，这个 HTML 文件中请求 CSS 文件;
2. 获取所有的 CSS 文件;
3. 开始渲染页面。
---

So there we have a few additions to my previous piece on Code Smells. These are
usually all things I have seen and suffered in the wild: hopefully now you can
avoid them as well.
所以我们在这里对我先前那篇关于代码味道的文章做了几点添加。这些是我已经看到的并且忍受着的几点：希望现在你也可以避开他们。
