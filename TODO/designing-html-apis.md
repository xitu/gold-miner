> * 原文地址：[HTML APIs: What They Are And How To Design A Good One](https://www.smashingmagazine.com/2017/02/designing-html-apis/)
> * 原文作者：[Lea Verou](https://www.smashingmagazine.com/author/lea-verou/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[王子建](https://github.com/Romeo0906)
> * 校对者：[薛定谔的猫](https://github.com/Aladdin-ADD)、[zhangqippp](https://github.com/zhangqippp)

# 如何设计优秀的 HTML API #

作为 JavaScript 开发者，我们经常忘记并不是所有人都像我们一样了解 JavaScript，这被称为[知识的诅咒](https://en.wikipedia.org/wiki/Curse_of_knowledge)：当我们精通某个内容的时候，我们就不记得自己作为新人的时候有多么困惑。我们总是对其他人的能力估计过高，因此我们觉得，自己写的类库需要一些 JavaScript 代码去初始化和配置也很 OK。然而，一些用户却在使用过程中大费周折，他们疯狂地从文档中复制粘贴例子并随机组合这些代码，直到它们生效。

你或许会想，“但是所有写 HTML 和 CSS 的人都会 JavaScript，对吧？”你错了。来看看我的[调查结果](https://twitter.com/LeaVerou/status/690583334414635009)吧，这是我所知道的唯一的相关数据了。（如果你知道任何适用于这个话题的调查，请在评论中说明！）

![](https://www.smashingmagazine.com/wp-content/uploads/2017/02/lea-verou-poll-tweet-opt.png)

测试：“你对 JavaScript 好感如何？”（[2016 年 1 月 22 日](https://twitter.com/LeaVerou/status/690583334414635009)）

每两个写 HTML 和 CSS 的人中就有一个**对 JavaScript 没有好感**。1/2，让我们感受一下这个比例。

举个例子，来看以下的代码，该代码用来初始化一个 jQuery UI 自动完成库，摘自[其文档](https://jqueryui.com/autocomplete/)。

```
<div class="ui-widget">
    <label for="tags">Tags: </label>
    <input id="tags">
</div>
```

```
$( function() {
    var availableTags = [
        "ActionScript",
        "AppleScript",
        "Asp",
        "BASIC",
        "C"
    ];
    $( "#tags" ).autocomplete({
        source: availableTags
    });
} );
```

这很简单，即使对那些根本不会 JavaScript 的人来说也很简单，对吧？错。一个非程序员在文档中看到这个例子的时候，脑子里会闪过各种问题：“我该把这段代码放哪儿呢？”“这些花括号、冒号和方括号是些什么鬼？”“我要用这些吗？”“如果我的元素没有 ID 怎么办？”等等。即使这段极其简短的代码也要求人们了解对象字面量、数组、变量、字符串、如何获取 DOM 元素的引用、事件、 DOM 树何时构建完毕等等更多知识。这些对于程序员来说微不足道的事情，对不会 JavaScript 的只会写 HTML 的人来说都是一场攻坚战。

现在来看一下 [HTML5](https://www.w3.org/TR/html5/forms.html#the-datalist-element) 中的等效声明性代码：

```
<div class="ui-widget">
    <label for="tags">Tags: </label>
    <input id="tags" list="languages">
    <datalist id="languages">
        <option>ActionScript</option>
        <option>AppleScript</option>
        <option>Asp</option>
        <option>BASIC</option>
        <option>C</option>
    </datalist>
</div>
```

这会让写 HTML 的人看得更清楚更明白，在程序员看来更为简单。我们看到所有的内容都同时被设置好，不必关心什么时候初始化，如何获取元素的引用和如何设置每个内容，无需知道哪个函数是用来初始化或者它需要什么参数。在更高级的使用情况中，还会添加一个 JavaScript API 来允许动态创建属性和元素。这遵循了一条最基本的 API 设计原则：让简单的内容变得更简单，让复杂的内容得以实现。

这给我们上了一堂**关于 HTML API 的重要课程**：HTML API 不光要给那些了解 JavaScript 但水平有限的人带来福音，还要让我们 —— 程序员 —— 在普通的工作中也要不惜牺牲程序的灵活性来换取更高的表述性。然而不知怎的，我们在写自己的类库的时却总忘记这些。

那么什么是 HTML API 呢？根据[维基百科](https://en.wikipedia.org/wiki/Application_programming_interface)的定义，API（也就是应用程序接口）是“用于构建应用程序软件的一组子程序定义、协议和工具”。在 HTML API 中，定义和协议就是 HTML ，工具在 HTML 中配置。HTML API 通常由可用于现有 HTML 内容的类和属性模式组成。通过 Web 组件，甚至可以像玩游戏一般[自定义元素名称](https://www.w3.org/TR/custom-elements/)和 [Shadow DOM](https://dom.spec.whatwg.org/#shadow-trees)，HTML API 甚至能拥有完整的内部结构，并且对页面其余部分隐藏实现细节。但是这并不是一篇关于 Web 组件的文章，Web 组件给予了 HTML API 设计者更多的能力和选择，但是良好的（HTML）API 设计原则都是可以举一反三的。

HTML API 加强了设计师和工程师之间的合作，减轻工程师肩上的工作负担，还能让设计师创造更具还原度的原型。在类库中引入 HTML API 不仅让社区更具包容性，最终还能造福程序员。

**并不是每个类库都需要  HTML API。** HTML API 在使用了 UI 元素的类库中非常有用，比如 galleries、drag-and-drop、accordions、tabs、carousels 等等。经验表明，如果一个非程序员不能理解该类库的功能，它就不需要 HTML API。比如，那些简化代码或者帮助管理代码的库就不需要 HTML API。那 MVC 框架或者 DOM 助手之类的库又怎会需要 HTML API 呢？

目前为止，我们只讨论了 HTML API 的定义、功能和用处，文章剩下的部分是关于如何设计一个好的 HTML API。

### 初始化选择器 ###

在 JavaScript API 中，初始化是被类库的用户严格控制的：因为他们必须手动调用函数或者创建对象，他们精确地控制着其运行的时间和基础。在 HTML API 中，我们要帮用户选择，同时也要确保不会妨碍那些仍然使用 JavaScript 的用户，因为他们可能希望得到完全控制。

最常见的兼容两种使用场景的办法就是，只有匹配到给定的选择器（通常是一个特定的类）时才会自动初始化。[Awesomplete](http://leaverou.github.io/awesomplete) 就是采用的这种方法，只选取具有 `class="awesomplete"` 的 input 元素进行初始化。

有时候，简化自动初始化比做显式选择初始化更重要。这很常见，当你的类库需要运行在众多元素之上时，避免手动给每个元素单独添加类比显式选择初始化更加重要。比如，[Prism](http://prismjs.com/) 自动高亮任何包含 `language-xxx` 类的 `<code>` 元素（HTML5 的说明中[建议指定代码段的语言](https://www.w3.org/TR/html51/textlevel-semantics.html#the-code-element)）及其包含 `languate-xxx` 类的元素内部的 `<code>` 元素。这是因为 Prism 可能会用在一个有着成千上万代码段的博客系统中，回过头去给每一个元素添加类将会是一项非常巨大的工程。

在可以自由地使用 `init` 选择器的情况下，允许选择是否自动化将会是一个良好的实践。比如，[Stretchy](https://leaverou.github.io/stretchy) 默认自动调整**每个** `<input>`、`<select>` 和 `<textarea>` 的尺寸，但是也允许通过 `data-stretchy-filter` 属性自定义指定其他元素为 `init` 选择器。Prism 支持 `<script>` 元素的 `data-manual` 属性来完全取消自动初始化。良好的实践应该允许 HTML 和 JavaScript 都能设置这个选项，来适应 HTML 和 JavaScript 两种类库的用户。

### 最小化初始标记 ###

那么，对于 `init` 选择器的每个元素来说，你的类库都需要其有一个封包、三个内部的 button 和两个相邻的 div 该怎么办呢？没问题，自己生成就好了。但是这种磨磨唧唧的工作更适合机器，而不是人。**不要期望每个使用类库的人都同时使用了一些模板系统**：许多人还在使用手动添加标记，他们会发现这样建造系统太过复杂。因此，我们有义务让他们活的轻松一点。

这种做法也最小化了错误风险：如果一个用户仅仅引入了用来初始化的类却没有引入所有需要的标记怎么办？如果不需要添加额外的标记，就不会产生错误。

这条规则中有一个例外：优雅地退化并渐进地增强。比如，即使单个具有“ data- * ”属性的元素并在“ data-* ”中添加所有选项就可以实现，在嵌入推文的时候也还是会涉及很多标记。这样做是为了在 JavaScript 加载和运行之前就使得推文可读。一个良好的经验法则就是扪心自问，即使在没有 JavaScript ，多余的标记能否给终端用户带来好处？如果是，那么就引入；如果不是，那就要用类库生成。

便于用户使用还是让用户自定义也是一组经典的矛盾：自动生成所有的标记会易于用户使用，让用户自定义又显得更加灵活。**在你需要的时候，灵活性如雪中送炭，在不需要的时候却适得其反**，因为你不得不手动设置所有的参数。为了平衡这两种需要，你可以生成那些需要但不存在的标记。比如，假设你需要给所有的 `.foo` 元素外层添加一个 `.foo-container` 元素。首先，通过 `element.closest(".foo-container")` 检查 `.foo` 元素的父元素或者任何的祖先元素（这样最好了）是否含有 `foo-container` 类，如果有的话，你就不用生成新的元素，直接使用就可以了。

### 设置 ###

典型地，设置应该通过在恰当的元素上使用 `data-*` 属性来实现。如果你的类库中添加了成千上万的属性，然后你希望给它们添加命名空间来避免和其他类库混淆，比如这样 `data-foo-*`（foo 是基于类库名字的一到三个字母长度的前缀）。如果名字显得太长，你可以使用 `foo-*`，但是要有心理准备，这种方式会打破 HTML 验证并且会使得一些勤劳的 HTML 作者因此而弃用你的类库（因为他们宁愿费点力气，也不愿意使用这种命名。译者注。）。理想情况下，只要代码不会太臃肿，以上两种情况都应该支持。目前还没有完美的解决办法，因此在 WHATWG 中展开了一场如火如荼的[讨论](https://github.com/whatwg/html/issues/2271)：是否应该让自定义的属性前缀合法化。

**尽可能地遵从 HTML 的惯例**。比如，你使用了一个属性来做布尔类型的设置，当该属性出现时无论其值如何都被视为 `true`，若不出现则被视为 `false`，不要期望可以用 `data-foo="true"` 或者 `data-foo="false"` 来代替。当然 ARIA 是这样做的，但是如果 ARIA 哪天突然死翘翘了，你也想那样吗？

你也可以使用类进行**布尔值**设置。典型地，类的语法和布尔属性值类似：类存在的时候是 `true` 不出现的时候就是 `false`。如果你想反过来设置，那就用一个 `no-` 前缀（比如，`no-line-number`）。但是要记住，类名可不像属性一样只有 `data-*`，因此这种方式很可能会和用户现存的类名冲突，因此你可以考虑一下在类名中使用 `foo-` 这样的前缀来避免冲突。但也有可能在后期的维护中发现这些类并未被 CSS 使用所以误删，这又是另一个隐患。

当你需要设置一组相关的布尔值时，使用空格区分会比使用多个分隔符的方式好很多。比如，`<div data-permissions="read add edit delete save logout">` 就比 `<div data-read data-add data-edit data-delete data-save data-logout">`，和 `<div class="read add edit delete save logout">` 好得多，因为后者可能会造成很多的冲突。你还可以使用 `~=` 属性选择器来定位单个元素，比如 `element.matches("[data-permissions~=read]")` 可以检查该元素是否有 `read` 权限。

如果设置内容的类型是**数组或者对象**，那么你就可以使用 `data-*` 属性来关联到另一个元素。比如， HTML5 中的自动完成：因为自动完成需要一个建议列表，你可以使用 `data-*` 属性并通过 ID 联系到包含建议内容的 `<datalist>` 元素。

HTML 有一个惯例很让人头痛：在 HTML 中，用属性联系到另一个元素通常是靠引用其 ID 实现的（试想一下 `<label for="...">`）。然而，这种方法相当受限制：如果能够允许使用选择器或者甚至允许嵌套将更为方便，其效果将会极大地依赖于你的使用情况。要记住，稳定性重要，但实用性更加重要。

**即使有些设置内容不能在 HTML 中指定也没关系**。在 JavaScript 中以函数为设置值的部分被称作“高级自定义”。试想一下 [Awesomplete](http://leaverou.github.io/awesomplete/#customization)：所有数字、布尔值、字符串和对象都可以通过 `data-*` 属性（`list`、`minChars`、`maxItems`、`autoFirst`）设置，所有的函数设置只能通过 JavaScript 使用（`filter`、`sort`、`item`、`replace`、`data`），这样会写 JavaScript 函数来配置类库的人就可以使用 JavaScript API 了。

正则表达式（regex）处在灰色地带：典型的，只有程序员才知道正则表达式（甚至程序员在使用的时候也会有问题！）；那么，乍看之下，在 HTML API 中引入正则表达式类型的设置并没有意义。然而，HTML5 确实引入了这样的设置（`<input pattern="regex">`），并且我相信那很成功，因为非程序员能在[正则词典](http://www.html5pattern.com/)中找到他们的用例并复制粘贴。

### 继承 ###

如果你的 UI 库在每个页面只会调用一两次，继承将不会很重要。然而，如果要应用于多个元素，通过类或者属性给每个元素做相同的配置将会非常令人头痛。记住**并不是每个人都用了构建系统**，尤其是非程序员。在这些情况下，定义能够从祖先元素继承设置将会变得非常有用，那样多个实例就可以被批量设置了。

还拿 Smashing Magazine 中使用的时下流行的语法高亮类库 —— [Prism](http://prismjs.com/) 来举例。高亮语句是通过 `language-xxx` 形式的类来配置的。是的，这违反了我们在前文中谈过的规则，但这只是一种主观决策，因为 [HTML5 手册中建议如此](https://www.w3.org/TR/html51/textlevel-semantics.html#the-code-element)。在有许多代码段的页面上（想象一下，在博客文章中使用内联 `<code>` 元素的频率！），在每个 `<code>` 元素中指定代码语句将会非常烦人。为了缓解这种痛苦，Prism 支持继承这些类：如果一个 `<code>` 元素自己没有 `language-xxx` 类，那么将会使用其最近的祖先元素的 `language-xxx` 类。这使得用户可以设置全局的代码语句（通过在 `<body>` 或者 `<html>` 元素上设置类）或者设置区块的代码语句，并且可以在拥有不同语句的元素或者区块上重写设置。

现在 [CSS 变量](https://www.w3.org/TR/css-variables/)已经被[所有的浏览器支持](http://caniuse.com/#feat=css-variables)，它们可以用于以下设置：他们默认可以被继承，并且可以以内联的方式通过 `style` 属性设置，也可以通过 CSS 或者 JavaScript 设置。在代码中，你可以通过 `getComputedStyle(element).getPropertyValue("--variablename")` 获取它们。除了浏览器支持，其主要的劣势就是开发者们还没习惯使用它们，但是那已经发生改变了。并且，你不能像监视元素和属性的一般通过 `MutationObserver` 来监视其改变。

### 全局设置 ###

大多数 UI 类库都有两组设置：定义每个组件表现形式的设置和定义**整个类库表现形式**的全局设置。目前为止，我们主要讨论了前者，你现在可能在好奇全局设置该在设置在哪里。

进行全局设置的一个好地方就引入类库的 `<script>` 元素。你可以通过 [`document.currentScript`](http://www.2ality.com/2014/05/current-script.html) 获取该元素，这有着非常好的[浏览器支持](http://caniuse.com/#feat=document-currentscript)。好处就是，这对于设置的作用域非常清楚，因此它们的名字可以起的更短（比如 `data-filter` 而不是 `data-stretchy-filter`）。

然而，你不能只在 `<script>` 元素中进行设置，因为一些用户可能会在 CMS 中使用你的类库，而 CMS 中不允许用户自定义 `<script>` 元素。你也可以在 `<html>` 和 `<body>` 元素或者甚至任何地方设置，只要你清楚地声明了属性值重复的时候哪个会生效。（第一个？最后一个？还是其他的？）

### 文档 ###

那么，你已经掌握了如何在类库中设置一个漂亮的声明性的 API。棒极了！然而，如果你所有的文档都写得只有会 JavaScript 的用户才看得懂，那么就只有很少人能使用了。我记得曾经看过一个很酷的类库，基于 URL 并通过切换元素的 HTML 属性来切换元素的表现形式。然而，这漂亮的 HTML API 并不能被其目标人群所使用，因为整篇文档中都充满了 JavaScript 引用。最开始的例子是这样开始的“这和 `location.href.match(/foo/)` 等价。”非程序员哪能看懂这个呢？

同时要记得许多人并不会任何编程语言，不光是 JavaScript。你期望用户能够读懂并理解的文中的模型、视图、控制器或者其他软件工程观念，结果无非是让他们摸不着头脑并且放弃。

当然，你应该在文档中写 API 里 JavaScript 的内容，你可以写在“高级使用”部分。然而，如果你在文档一开头就引用 JavaScript 对象和函数或者软件工程的观念，那么你实质上就是在告诉非程序员这个类库不是给他们用的，因此你就排除了一大批潜在用户。不幸的是，大部分的 HTML API 类库文档都受这些问题困扰着，因为 HTML API 经常被视为是程序员的捷径，而并不是给非程序员使用的。庆幸的是，这种状况在未来可以有改变。

### 那么 Web 组件呢？ ###

在不远的未来，Web 组件百分之百将会彻底改变 HTML API。`<template>` 元素将会允许作者提供惰性加载的脚本。自定义元素将使得用户可以像原生的 HTML 一样使用更多优雅的 `init` 标记。引入 HTML 也将使得作者能够仅引入一个文件来替代三个样式表、五个脚本和十个模板（如果浏览器能够同时获取并且[不再认为 ES6 模块是一种竞争技术](https://hacks.mozilla.org/2014/12/mozilla-and-web-components)）。Shadow DOM 使得类库可以将复杂的 DOM 结构适当压缩并且不会影响用户自己的标记。

然而除了 `<template>`，浏览器对其他三个特征的支持[目前受限](http://caniuse.com/#search=web%20components)。因此他们需要更高的聚合度，以此来减少对类库的影响。然而，这将会是你在未来一段时间里需要不断关注的东西。

### MarkApp：一个 HTML API 类库的列表

如果你已经听取了这篇文章中的建议，那么恭喜你已经能够把网站做得更好，更有包容性和更有创造性了！我在 [MarkApp](http://markapp.io/) 上维护着一些使用 HTML API 类库的列表。请发 Pull Request 给我来添加你自己的内容！
