> * 原文地址：[CSS Inheritance, The Cascade And Global Scope: Your New Old Worst Best Friends](https://www.smashingmagazine.com/2016/11/css-inheritance-cascade-global-scope-new-old-worst-best-friends)
* 原文作者：[Heydon Pickering](https://www.smashingmagazine.com/author/heydon-pickering)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[linpu.li](https://llp0574.github.io/)
* 校对者：[xekri](https://github.com/xekri)、[Tina92](https://github.com/Tina92)

# CSS 继承深度解析

**我酷爱[模块化设计](https://www.smashingmagazine.com/2016/06/designing-modular-ui-systems-via-style-guide-driven-development/)。长期以来我都热衷于将网站分离成组件，而不是页面，并且动态地将那些组件合并到界面上。这种做法灵活，高效并且易维护。**

但是我不想我的设计**看上去**是由一些不相关的东西组成的。我是在创造一个界面，而不是一张超现实主义的照片。

很幸运的是，已经有一项叫做 CSS 的技术，就是特意设计用来解决这个问题的。使用 CSS，我就可以在 HTML 组件之间到处传递样式，**从而以最小的代价来保证一致性的设计**。这很大程度上要感谢两个 CSS 特性：

- 继承，
- 层叠 (CSS 当中的 C，cascade)。

尽管这些特性让我们能够以一种 [DRY](https://en.wikipedia.org/wiki/Don't_repeat_yourself) 且有效率的方式来给 Web 文档添加样式，同时也是 CSS 存在的原因，但很明显，它们已经不再受到青睐。在一些 CSS 方法论里，如 BEM 和 Atomic CSS 这些通过程序化封装 CSS 模块的方法，许多都尽力去规避或者抑制这些特性。这也让开发者有了更多机会去控制他们的 CSS，但这仅仅是一种基于频繁干预的专项控制。

我准备带着对模块化界面设计的尊敬在此重新审视继承、层叠和作用域。我想要的告诉你的是如何利用这些特性让你的 CSS 代码更简洁，实现更好的自适应，并且提高页面的可扩展性。

### 继承和 `font-family`

尽管许多人在抱怨 CSS 为什么不单单提供一个全局作用域，但如果它这么做的话，那么就会有很多重复样式了。反之，CSS 有全局作用域和局部作用域。就像在 JavaScript 里，局部作用域有权限访问父级和全局作用域，而在 CSS 里，局部作用域则帮助了**继承**。

例如，如果给根部（也作：全局）的 `html` 元素定义一个 `font-family` 属性，那么可以确定这条规则会在文档里应用到所有祖先元素（有一些例外情况，将在下个部分讨论）。

```
html {
    font-family: sans-serif;
}

/*
This rule is not needed ↷
p {
    font-family: sans-serif;
}
*/
```

就像在 JavaScript 里那样，如果我在局部作用域里定义了某些规则，那么它们在全局，或者说在任意祖先级的作用域中都是无效的，只有在它们自己的子作用域里是有效的（就像在上面代码中的 `p` 元素里）。在下个例子当中，`1.5` 的 `line-height` 并没有被 `html` 元素用上。但是，`p` 里的 `a` 元素则运用上了 `line-height` 的值。

```
    html {
      font-family: sans-serif;
    }

    p {
      line-height: 1.5;
    }

    /*
    This rule is not needed ↷
    p a {
      line-height: 1.5;
    }
    */
```

继承最大的好处就是你可以用很少量的代码为一致性的可视化设计建立一个基础。而且这些样式甚至将作用到你还没写的 HTML 上。我们在讨论不会过时的代码！

#### 替代方法

当然有另外一种方式提供公用样式。比如，我可以创建一个 `.sans-serif` 类...

```
    .sans-serif {
      font-family: sans-serif;
    }
```

...并将它应用到任意我想要它有这个样式的元素上去：

```
    <p class="sans-serif">Lorem ipsum.</p>
```

这种方法提供了一些控制上的权利：我可以准确地挑选决定哪些元素应用这个样式，哪些元素不用。

任何能够控制的机会都是很吸引人的，但有一些明显的问题。我不仅需要手动地给需要应用样式的元素添加类名（这也意味着我要首先确定这个样式类是什么效果），而且在这种情况下也已经有效地放弃了支持动态内容的可能性：不管是富文本编辑器还是 Markdown 解析器都没办法给任意的 p 元素提供 `sans-serif` 类。

`class="sans-serif"` 和 `style="font-family: sans-serif"` 的用法差不多 - 除了前者意味着要同时在样式表**和** HTML 当中添加代码。使用继承，我们就可以在其中一个少写点，而另外一个则不用再写了。相比给每个字体样式写一个类，我们可以只在一个声明里，给 `html` 元素添加想要的规则。

```
    html {
      font-size: 125%;
      font-family: sans-serif;
      line-height: 1.5;
      color: #222;
    }
```

### `inherit` 关键字

某些类型的属性是不会默认继承的，而某些元素则不会继承某些属性。但是在某些情况下，可以使用 `[property name]: inherit` 来强制继承。

举个例子，`input` 元素在之前的例子中不会继承任何字体的属性，`textarea` 也一样不会继承。为了确保所有元素都可以从全局作用域中继承这些属性，可以使用通配选择符和 `inherit` 关键字。这样，就可以最大程度地使用继承了。

```
    * {
      font-family: inherit;
      line-height: inherit;
      color: inherit;
    }

    html {
      font-size: 125%;
      font-family: sans-serif;
      line-height: 1.5;
      color: #222;
    }
```

注意到我忽略了 `font-size`。我不想直接继承 `font-size` 的原因是，它会将 heading 元素（译者注：如 `h1`）、`small` 元素以及其他一些元素的默认 user-agent 样式给覆盖掉。这么做我就可以节省一行代码，并且让 user-agent 决定想要什么样式。

另外一个我不想继承的属性是 `font-style`：我不想重设 `em` 的斜体，然后再次添加上它。这将成为无谓的工作并会产生多余的代码。

现在，所有不管是可以继承或者是**强制**继承的字体样式都是我所期望的。我们已经花了很长时间只用两个声明区块来传递一个一致性的理念和作用域。从现在开始，除开一些例外情况，没有人会在构造组件的时候还需要去考虑 `font-family`、`line-height` 或者 `color` 了。这就是层叠的由来。

### 基于例外的样式

我可能想要主要的 heading 元素（`h1`）采用相同的 `font-family`、`color` 和 `line-height`。使用继承就是很好的解决方案，但是我又想要它的 `font-size` 不一样。因为默认的 user-agent 样式已经给 `h1` 元素提供了一个大号的 `font-size`（但这时它就会被我设置的相对基础字体大小为 125% 的样式覆盖掉），可能的话我不需要这里发生覆盖。

然而，难道我需要调整所有元素的字体大小吗？这时我就利用了全局作用域的优势，在局部作用域里只调整我需要调整的地方。

```
    * {
      font-family: inherit;
      line-height: inherit;
      color: inherit;
    }

    html {
      font-size: 125%;
      font-family: sans-serif;
      line-height: 1.5;
      color: #222;
    }

    h1 {
      font-size: 3rem;
    }
```

如果 CSS 元素的样式默认被封装，那么下面的情况就不可能了：需要明确地给 `h1` 添加**所有**字体样式。反而，我可以将样式分为几个单独的样式类，然后通过空格分隔来逐一给 `h1` 添加样式：

```
    <h1 class="Ff(sans) Fs(3) Lh(1point5) C(darkGrey)">Hello World</h1>
```

不管哪种方式，都需要更多的工作，而且最终目的都是一个具备样式的 `h1`。使用层叠，我已经给**大部分**元素赋上了想要的样式，并且只在一个方面使得 `h1` 成为一个例外。层叠作为一个过滤器，意味着样式只在添加新样式覆盖的时候才会发生改变。

### 元素样式

我们已经开了个好头，但想要真正地掌握层叠，还需要尽可能多地给公共元素添加样式。为什么？因为我们的混合组件是由独立的 HTML 元素构成，并且一个屏幕阅读器友好的界面充分利用了语义化结构标记。

换句话说，让你的界面“分子化”（使用了 [atomic 设计术语](http://bradfrost.com/blog/post/atomic-web-design/#molecules)）的 “atoms” 样式应该在很大程度上可定位并且使用元素选择符。元素选择符的[优先级](https://www.smashingmagazine.com/2007/07/css-specificity-things-you-should-know/)很低，所以它们不会覆盖你之后可能加进来的基于类的样式。

首先应该做的事情就是给所有你即将需要使用的元素添加样式：

```
    a { … }
    p { … }
    h1, h2, h3 { … }
    input, textarea { … }
    /* etc */
```

如果你想在无冗余的情况下有个一致性界面的话，那么下一步非常重要：每当你创建一个新组件的时候，**如果它采用了一些新元素，那么就用元素选择符来给它们添加样式**。现在不是时候去使用限制性、高优先级的选择符，也没有任何需要去编写一个样式类。语义化元素就使用其本身。

举个例子，如果我还没有给 `button` 元素 （就像前一个例子）添加样式，并且新组件加入了一个 `button` 元素，那么这就是一个给**整个界面**的 `button` 元素添加样式的好机会。

```
    button {
      padding: 0.75em;
      background: #008;
      color: #fff;
    }

    button:focus {
      outline: 0.25em solid #dd0;
    }
```

现在，当你想要再写一个新组件并且同样加入按钮的时候，就少了一件需要操心的事情了。在不同的命名空间下，不要去重写相同的 CSS，并且也没有类名需要记住或编写。CSS 本就应该总是致力于让事情变得简单和高效 - 它本身就是为此而设计的。

使用元素选择符有三个主要的优势：

- 生成的 HTML 更加简洁（没有多余的各种样式类）。
- 生成的样式表更加简洁（样式在组件间共享，不需要在每个组件里重写）。
- 生成的添加好样式的界面基于语义化 HTML。

使用类来专门提供样式常常被定义为“关注点分离”。这是对 W3C 的[关注点分离](https://www.w3.org/TR/html-design-principles/#separation-of-concerns)原则的误解。它的目的是用 HTML 和 CSS 样式来描述整个结构。因为类专门是为了样式目的而制定，而且是在结构标记里出现，所以无论它们在哪里使用，技术上都是在**打破**分离，你不得不改变实质结构来得到样式。

不管在哪里都不要依赖表面的结构标记（样式类，内联样式），你的 CSS 应该兼容通用的结构和语义化的约定。这就可以简单地扩展内容和功能而无需它也变成一个样式的任务。同样在不同传统语义化结构的项目里，也可以让你的 CSS 变得更加可复用（但是这一点 CSS 的“方法论”可能会有所不同）。

#### 特殊情况

在有人指责我过分简单化之前，我意识到界面上不是所有的按钮都做同样的事情，我还意识到做不同事情的按钮在某种程度上可能应该看起来不一样。

但这并不是说我们就需要用样式类、继承**或者**层叠来处理了。让一个界面上的按钮看起来完全不一样是在混淆你的用户。为了可访问性**和**一致性，大多数按钮在外观上只需要通过标签来进行区分。

```
    <button>create</button>

    <button>edit</button>

    <button>delete</button>
```

记住样式并不是视觉上唯一的区分方法。内容同样可以在视觉上区分，而且在一定程度上它更加明确一些，因为你可是在文字上告诉了用户不同的地方。

大多数情况下，单独使用样式来区分内容都不是必要或者正确的。通常，样式区分应该是附加条件，比如一个红色背景或者一个带图标的文本标签。文本标签对那些使用声音激活的软件有着特定的效果：当说出 “red button” 或者 “button with cross icon” 的时候并没有引起软件的识别时。

我将在“工具类”部分探讨关于添加细微差别到看起来相似的元素上的话题。

### 标签属性

语义化 HTML 并不仅仅关于元素。标签属性定义类型、样式属性和状态。这些对可访问性来说也很重要，所以它们需要写在 HTML 里合适的地方。而且因为都在 HTML 里，所以它们还提供了做样式钩子的机会。

举个例子，`input` 元素有一个 `type` 属性，那么你应该想要利用它的好处，还有[像 `aria-invalid` 属性](https://www.w3.org/TR/wai-aria/states_and_properties#aria-invalid)是用来描述状态的。

```
    input, textarea {
      border: 2px solid;
      padding: 0.5rem;
    }

    [aria-invalid] {
      border-color: #c00;
      padding-right: 1.5rem;
      background: url(images/cross.svg) no-repeat center 0.5em;
    }
```

这里有几点需要注意一下：

- 这里我不需要设置 `color`、`font-family` 或者 `line-height`，因为这些都从 `html` 上继承了，得益于上面使用的 `inherit` 关键字。如果我想在整个应用的层面上改变 `font-family`，只需要在 `html` 那一块对其中一个声明进行编辑就可以了。
- border 的颜色关联到 `color`，所以它同样是从全局 `color` 中继承。我只需声明 border 的宽度和风格。
- `[aria-invalid]` 属性选择符是没有限制的。这意味着它有着更好的应用（它可以同时作用在 `input` 和 `textarea` 选择符）以及最低的优先级。简单的属性选择符和类选择符有着同样的优先级。无限制使用它们意味着之后任何写在层叠下的样式类都可以覆盖它们。

BEM 方法论通过一个修饰符类来解决这个问题，比如 `input--invalid`。但是考虑到无效的状态应该只在可通信的时候起作用，`input--invalid` 还是一定的冗余。换句话说，`aria-invalid` 属性**不得不**写在那里，所以这个样式类的目的在哪里？

#### 只写 HTML

在层叠方面关于大多数元素和属性选择符我绝对喜欢的事情是：组件的构造变成**更少地了解公司或组织的命名约定，更多地关注 HTML**。任何精通写出像样 HTML 的开发者被分配到项目中时，都会从已经写到位的继承样式当中获益。这些样式显著地减少了读文档和写新 CSS 的需要。大多数情况下，他们可以只写一些死记硬背应该知道的（meta）语言。Tim Baxter 同样为此在 [Meaningful CSS: Style It Like You Mean It](http://alistapart.com/article/meaningful-css-style-like-you-mean-it) 里写了一个案例。

### 布局

目前为止，我们还没有写任何指定组件的 CSS，但这并不是说我们还没有添加任何相关样式。所有组件都是 HTML 元素的组合。形成更复杂的组件主要是靠这些元素的组合顺序和排列。

这就给我们引出了布局这个概念。

主要我们需要处理流式布局 - 连续块元素之间的间距。你可能已经注意到目前为止我没有给任何元素设置任何的外边距。那是因为外边距不应该考虑成一个元素的属性，而应该是元素上下文的属性。也就是说，它们应该只在遇到元素的时候才起作用。

幸运的是，[直接相邻选择符](https://developer.mozilla.org/en/docs/Web/CSS/Adjacent_sibling_selectors)可以准确地描述这种关系。利用层叠，我们可以使用一个统一默认贯穿**所有**连续块级元素的选择符，只有少数例外情况。

```
    * {
      margin: 0;
    }

    * + * {
      margin-top: 1.5em;
    }

    body, br, li, dt, dd, th, td, option {
      margin-top: 0;
    }
```

使用优先级极低的[猫头鹰选择符](http://alistapart.com/article/axiomatic-css-and-lobotomized-owls)确保了**任意**元素（除了那些公共的例外情况）都通过一行来间隔。这意味着在所有情况下都会有一个默认的白色间隔，所有编写组件流内容的开发者都将有一个合理的起点。

在大多数情况下，外边距只会关心它们自己。不过因为低优先级，很轻易就可以在需要的时候覆盖掉那基础的一行间隔。举个例子，我可能想要去掉标签和其相关元素之间的间隔，好表示它们是一对的。在下面的示例里，任意在标签之后的元素（`input`、`textarea`、`select` 等等）都不会有间隔。

```
    label {
      display: block
    }

    label + * {
      margin-top: 0.5rem;
    }
```

再次，使用层叠意味着只需要在需要的时候写一些特定的样式就可以了，而其他的元素都符合一个合理的基准。

需要注意的是，因为外边距只在元素之间出现，所以它们不会和可能包括在容器内的内边距重叠。这也是一件不需要担心或者预防的事情。

还注意到不管你是否决定引入包装元素都得到了同样的间隔。就是说，你可以像下面这样做并实现相同的布局 - 外边距在 `div` 之间出现比在标签和输入框之间出现要好得多。

```
    <form>
      <div>
        <label for="one">Label one</label>
        <input id="one" name="one" type="text">
      </div>
      <div>
        <label for="two">Label two</label>
        <input id="two" name="two" type="text">
      </div>
      <button type="submit">Submit</button>
    </form>
```
用像 [atomic CSS](http://acss.io/) 这样的方法能实现同样的效果，只需组合各种外边距相关的样式类并在各种情况下手动添加它们，包括被 `* + *` 隐式控制的 `first-child` 这种例外情况：

```
    <form class="Mtop(1point5)">
      <div class="Mtop(0)">
        <label for="one" class="Mtop(0)">Label one</label>
        <input id="one" name="one" type="text" class="Mtop(0point75)">
      </div>
      <div class="Mtop(1point5)">
        <label for="two" class="Mtop(0)">Label two</label>
        <input id="two" name="two" type="text" class="Mtop(0point75)">
      </div>
      <button type="submit" class="Mtop(1point5)">Submit</button>
    </form>
```

记住如果坚持使用 atomic CSS 的话，像上面那么写只会覆盖到顶部外边距的情况。你必须还要为 `color`、`background-color` 以及其他属性建立独立的样式类，因为 atomic CSS 不会控制继承或者元素选择符。

```
    <form class="Mtop(1point5) Bdc(#ccc) P(1point5)">
      <div class="Mtop(0)">
        <label for="one" class="Mtop(0) C(brandColor) Fs(bold)">Label one</label>
        <input id="one" name="one" type="text" class="Mtop(0point75) C(brandColor) Bdc(#fff) B(2) P(1)">
      </div>
      <div class="Mtop(1point5)">
        <label for="two" class="Mtop(0) C(brandColor) Fs(bold)">Label two</label>
        <input id="two" name="two" type="text" class="Mtop(0point75) C(brandColor) Bdc(#fff) B(2) P(1)">
      </div>
      <button type="submit" class="Mtop(1point5) C(#fff) Bdc(blue) P(1)">Submit</button>
    </form>
```

Atomic CSS 使开发者可以直接控制样式而不再使用内联样式，内联样式不像样式类一样可以复用。通过为各种独立的属性提供样式类，减少了样式表中的重复声明。

但是，它需要直接介入标记从而实现这些目的。这就要求学习并投入它那冗长的 API，同样还需要编写大量额外的 HTML 代码。

相反，如果只用来对任意 HTML 元素及其空间关系设计样式的话，那么 CSS “方法论”就要被大范围弃用了。使用一致性设计的系统有着很大的优势，相比一个叠加样式的 HTML 系统更方便考虑和分开管理。

无论如何，下面是我们的 CSS 架构和流式布局内容解决方案应该具备的特征：

1. 全局（`html`）样式并强制继承，
2. 流式布局方法及部分例外（使用猫头鹰选择符），
3. 元素及属性样式。

我们还没有编写一个特定组件或者构思一个 CSS 样式类，但我们大部分的样式都已经写好了，前提是如果我们能够将样式类写得合理且可复用。

### 工具类

关于样式类它们有一个全局作用域：在 HTML 里任何地方使用，它们都会被关联的 CSS 所影响。对大多数人来说，这都被看做一个弊端，因为两个独立的开发者有可能以同样的命名来编写一个样式类，从而互相影响工作。

[CSS modules](https://css-tricks.com/css-modules-part-1-need/) 最近被用来解决这种情况，通过以程序来生成唯一的样式类名，绑定到它们的局部或组件作用域当中。

```
    <!-- my module's button -->
    <button class="button_dysuhe027653">Press me</button>

    <!-- their module's button -->
    <button class="button_hydsth971283">Hit me</button>
```

忽略掉生成代码的丑陋，你应该能够看到两个独立组件之间的不同，并且可以轻易地放在一起：唯一的标识符被用来区分同类的样式。在这么多更好的努力和冗余代码下，结果界面将要么不一致，要么一致。

没有理由对公共元素来进行唯一性区分。你应该对元素类型添加样式，而不是元素实例。谨记 “class” 意味着“某种可能存在很多的东西的类型”。换句话说，所有的样式类都应该是工具类：全局可复用。

当然，在这个示例里，总之 `.button` 类是冗余的：我们可以用 `button` 元素选择符来替代。但是如果有一种特殊类型的按钮呢？比如，我们可能编写一个 `.danger` 类来指明这个按钮是做危险性操作，比如删除数据：

```
    .danger {
      background: #c00;
      color: #fff;
    }
```

因为类选择符的优先级比元素选择符的优先级高，而和属性选择符优先级相同，所以这种方式添加在样式表后面的样式规则会覆盖前面元素和属性选择符的规则。所以，危险按钮会以红色背景配白色文本出现，但它其他的属性，比如内边距，聚焦轮廓以及外边距都会通过之前的流式布局方法添加，保持不变。

```
    <button class="danger">delete</button>
```

如果多位开发人员长时间在同样的代码基础上工作，那么偶尔就会发生命名冲突。但是有几种避免这种情况的方法，比如，噢，我不太知道，但对于你想要采用的名称我建议首先做一个文本搜索，看看是否已经存在了。因为你不知道，可能已经有人解决了你正在定位的问题。

#### 局部作用域的各种工具类

对于工具类来说，我最喜欢做的事情就是把它们设置在容器上，然后用这个钩子去影响内部子元素的布局。举个例子，我可以快速对任意元素设置一个等间隔、响应式以及居中的布局。

```
    .centered {
      text-align: center;
      margin-bottom: -1rem; /* adjusts for leftover bottom margin of children */
    }

    .centered > * {
      display: inline-block;
      margin: 0 0.5rem 1rem;
    }
```

使用这个方法，我可以把列表项、按钮、按钮组合以及链接等随便什么元素居中展示。全靠 `> *` 的使用，在这个作用域中，它意味着带有 `.centered` 样式的元素下最近的子元素将会采用这些样式，并且还继承全局和父元素的样式。

而且我调整了外边距，好让元素可以自由进行包裹，而且不会破坏使用 `* + *` 选择符设置的垂直设定。这少量的代码通过对不同元素设置一个局部作用域，就提供了一个通用、响应式的布局解决方案。

我的一个小型（压缩后 93B）的[基于 flexbox 网格布局系统](https://github.com/Heydon/fukol-grids) 就是一个类似这种方法的工具类。它高度可复用，而且因为它使用了 `flex-basis`，所以不需要断点干预。我只是用了 flexbox 布局的方法。

```
    .fukol-grid {
      display: flex;
      flex-wrap: wrap;
      margin: -0.5em; /* adjusting for gutters */
    }

    .fukol-grid > * {
      flex: 1 0 5em; /* The 5em part is the basis (ideal width) */
      margin: 0.5em; /* Half the gutter value */
    }
```

![logo with sea anemone (penis) motif](https://www.smashingmagazine.com/wp-content/uploads/2016/11/logo-fukol.png)

使用 BEM 的方法，你会被鼓励在每个网格项上放置一个明确的“元素”样式类：

```
    <div class="fukol"> <!-- the outer container, needed for vertical rhythm -->
      <ul class="fukol-grid">
        <li class="fukol-grid__item"></li>
        <li class="fukol-grid__item"></li>
        <li class="fukol-grid__item"></li>
        <li class="fukol-grid__item"></li>
      </ul>
    </div>
```

但这不是必要的。只需一个标识符去实例化本地作用域。这里的列表项相比起我版本当中的列表项，不再受外部影响的保护，**也不应该**被 `> *` 所影响。仅有的区别就是充斥了大量样式类的标记。

所以，现在我们已经开始合并样式类，但只在通用性上合并，和它们所预期的效果一样。我们仍然还没有独立地给复杂组件添加样式。反而，我们在以一种可复用的方式解决一些系统性的问题。当然，你将需要在注释里写清楚这些样式类是如何使用的。

像这些的工具类同时采用了 CSS 的全局作用域、局部作用域、继承以及层叠的优点。这些样式类可以在各个地方使用，它们实例化局部作用域从而只影响它们的子元素，它们从父级或全局作用域中继承**没有**设置在自身的样式，**而且**我们没有过度使用元素或类选择符。

下面是现在我们的层叠看上去的样子：

1. 全局（`html`）样式和强制性继承，
2. 流式布局方法和一些例外（使用猫头鹰选择符），
3. 元素和属性样式，
4. 通用的工具类。

当然，可能没有必要去编写所有这些示例工具类。重点是，如果在使用组件的时候出现了需求，那么解决方案应该对所有组件都有效才行。一定要总是站在系统层面去思考。

#### 特定组件样式

我们从一开始就已经给组件添加了样式，并且学习样式结合组件的方法，所以很多人有可能会忽略掉马上要讲到这个部分。但值得说明的是，任何不是从其他组件中创建的组件（甚至包括单个 HTML 元素）都是有必要存在的。它们是使用 ID 选择符的组件，以及有可能成为系统问题的风险。

事实上，一个好的实践是只使用 ID 来给复杂组件标识（“molecules”、“organisms”），并且不在 CSS 里使用这些 ID。比如，你可以在登录表单组件上写一个 `#login`，那么你就不应该在 CSS 里以元素、属性或者流式布局方法的样式来使用 `#login`，即使你可能会发现你在创造一个或两个可以在其他表单组件里使用的通用工具类。

如果你**确实**使用了 `#login`，那么它只会影响那个组件。值得提醒的是如果这么做，那么你就已经偏离了开发一个设计系统方向，并且朝着只有不停纠结像素的冗长代码前进。

### 结论

当我告诉人们我不使用诸如 BEM 这样的方法论或者 CSS 模块这样的工具时，多数人会认为我会编写下面这样的 CSS：

```
    header nav ul li {
      display: inline-block;
    }

    header nav ul li a {
      background: #008;
    }
```

我没有这样做。一份清晰的陈述已经在这儿了，还有我们需要小心去避免的事情也已经阐述了。只是想说明 BEM（还有 OOCSS、SMACSS、atomic CSS 等）并不是避免复杂、不可能管理的 CSS 的唯一方法。

为了解决优先级问题，许多方法论几乎都选择了使用类选择符。问题在于这产生了大量的样式类：让 HTML 标记变得臃肿的各种神奇代码，以及失去了对文档的注意力，这些都会让新来的开发者对他们所处的系统感到困扰和迷惑。

通过大量地使用样式类，你还需要管理一个样式系统，而且这个系统很大程度上是和 HTML 系统分离的。这种不太合适的所谓“关注点分离”可以造成冗余，甚至更糟糕，导致不可访问性：有可能会在可访问的状态下影响一个视觉上的样式：

```
    <input id="my-text" aria-invalid="false" class="text-input--invalid" />
```

为了替换掉大量的编写和各种样式类，我找到了其他一些方法：

- 为了一致性掌握继承去设置一个前置条件；
- 充分使用元素和属性选择符去支持透明度和基于标准的组合样式；
- 使用简便的的流式布局系统；
- 合并一些高度通用的工具类，解决影响多元素的共同布局问题。

所有这些方法都是为了创建一个设计**系统**，使编写一个新组件变得更简单，以及当项目成熟的时候，减少添加新的 CSS 代码的依赖。并且这并不是获益于严格的命名和合并，反而是因为缺少了它们。

可能你会对我在这里推荐的特殊技巧并不感冒，但我还是希望这篇文章至少可以让你重新思考一下组件是什么。它们不是你独立创建的东西。有的时候，在标准 HTML 元素的情况下，它们甚至不是你所创建的东西。你的组件**从**其他组件拿来的东西越多，那么界面的可访问性和视觉上的一致性就会变得更好，并且最后会用更少的 CSS 去实现它们。

（这些问题）CSS 并没有太多过错。事实上，让你做很多事情是非常好的，我们只是没有利用罢了。
