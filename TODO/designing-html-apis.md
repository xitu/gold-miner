> * 原文地址：[HTML APIs: What They Are And How To Design A Good One](https://www.smashingmagazine.com/2017/02/designing-html-apis/)
* 原文作者：[Lea Verou](https://www.smashingmagazine.com/author/lea-verou/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# HTML APIs: What They Are And How To Design A Good One #

#何为 HTML API，如何设计之？#

As JavaScript developers, we often forget that not everyone has the same knowledge as us. It’s called the [curse of knowledge](https://en.wikipedia.org/wiki/Curse_of_knowledge): When we’re an expert on something, we cannot remember how confused we felt as newbies. We overestimate what people will find easy. Therefore, we think that requiring a bunch of JavaScript to initialize or configure the libraries we write is OK. Meanwhile, some of our users struggle to use them, frantically copying and pasting examples from the documentation, tweaking them at random until they work.

作为 JavaScript 开发者，我们经常忘记并不是所有人都拥有像我们一样的学识。这被称为[知识的诅咒](https://en.wikipedia.org/wiki/Curse_of_knowledge)：当我们精通某个内容的时候，我们就不记得自己作为新人的时候有多么困惑。我们总是对人们的能力估计过高。因此，我们认为自己写的那些需要一些 JavaScript 代码去初始化或者配置的类库是完全没问题的。然而，一些用户却在使用中费劲力气，他们疯狂地从文档中复制粘贴例子并随机组合这些代码，直到它们生效。

You might be wondering, “But all HTML and CSS authors know JavaScript, right?” Wrong. Take a look at the results of [my poll](https://twitter.com/LeaVerou/status/690583334414635009), which is the only data on this I’m aware of. (If you know of any proper studies on this, please mention them in the comments!)

你或许会想，“但是所有写 HTML 和 CSS 的人都懂 JavaScript，对吧？”你错了。来看看我的[测验结果](https://twitter.com/LeaVerou/status/690583334414635009)吧，这是我所知道的唯一数据了。（如果你知道任何适用于这个主题的研究，请在评论中说明！）

![](https://www.smashingmagazine.com/wp-content/uploads/2017/02/lea-verou-poll-tweet-opt.png) 

Poll: “How comfortable are you with JavaScript?” ([22 January 2016](https://twitter.com/LeaVerou/status/690583334414635009)

测试：“你对 JavaScript 好感如何？”（[2016 年 1 月 22 日](https://twitter.com/LeaVerou/status/690583334414635009)）

One in two people who write HTML and CSS is **not comfortable with JavaScript**. One in two. Let that sink in for a moment.

每两个写 HTML 和 CSS 的人中就有一个**对 JavaScript 并无好感**。每两个中就有一个，让我们感受一下。

As an example, look at the following code to initialize a jQuery UI autocomplete, taken from [its documentation](https://jqueryui.com/autocomplete/):

举个例子，看一下以下用来初始化一个 jQuery UI 自动完成库的代码，摘自[文档](https://jqueryui.com/autocomplete/)。

```
<div class="ui-widget">
    <label for="tags">Tags: </label>
    <input id="tags">
</div>
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

This is easy, even for people who don’t know any JavaScript, right? Wrong. A non-programmer would have all sorts of questions going through their head after seeing this example in the documentation. “Where do I put this code?” “What are these braces, colons and brackets?” “Do I need them?” “What do I do if my element does not have an ID?” And so on. Even this tiny snippet of code requires people to understand object literals, arrays, variables, strings, how to get a reference to a DOM element, events, when the DOM is ready and much more. Things that seem trivial to programmers can be an uphill battle to HTML authors with no JavaScript knowledge.

这很简单，即使对根本不了解 JavaScript 的人来说也是这样，对吧？错。一个非程序员在文档中看到这个例子的时候，脑子里会闪过各种各样的问题。“我该把这段代码放哪儿呢？”“这些花括号、冒号和方括号是些什么鬼？”“我用得着这些吗？”“如果我的元素没有 ID 我该怎么办呢？”等等。即使这个微乎其微的代码段也要求人们了解对象字面量、数组、变量、字符串、如何获取 DOM 元素的引用、事件、 DOM 数何时构建完毕等等更多知识。对于程序员来说微不足道的事情，对没有 JavaScript 知识的 HTML 作者来说都是一场攻坚战。

Now consider the equivalent declarative code [from HTML5](https://www.w3.org/TR/html5/forms.html#the-datalist-element):

现在来考虑一下 [HTML5](https://www.w3.org/TR/html5/forms.html#the-datalist-element) 中的等效声明性代码：

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

Not only is this much clearer to anyone who can write HTML, it is even easier for programmers. We see that everything is set in one place, no need to care about when to initialize, how to get a reference to the element and how to set stuff on it. No need to know which function to call to initialize or which arguments it accepts. And for more advanced use cases, there is also a JavaScript API in place that allows all of these attributes and elements to be created dynamically. It follows one of the most basic API design principles: It makes the simple easy and the complex possible.

这不光对于那些能够写 HTML 的人来说简单了不少，甚至对程序员来说更为简单。我们看到所有的东西都被写在一个地方，不必关心什么时候初始化，如何获取元素的引用和如何设置，无需知道哪个函数是用来初始化或者它需要什么参数。在更高级的使用中，还会在允许动态创建属性和元素的地方添加一个 JavaScript API。这遵循了一条最基本的 API 设计原则：它是的简单的事物变得容易，让复杂的事物变得可能。

This brings us to **an important lesson about HTML APIs**: They would benefit not only people with limited JavaScript skill. For common tasks, even we, programmers, are often eager to sacrifice the flexibility of programming for the convenience of declarative markup. However, we somehow forget this when writing a library of our own.

这给我们上了一堂**关于 HTML API 的重要课程**：这不光使那些拥有有限的 JavaScript 技能的人受益。对于普通的任务，甚至我们，程序员，也会渴望牺牲程序的灵活性来换取更高的表述性。然而不知怎的，我们在写自己用的类库的时候却总是忘记这些。

So, what is an HTML API? [According to Wikipedia](https://en.wikipedia.org/wiki/Application_programming_interface), an API (or application programming interface) is “is a set of subroutine definitions, protocols, and tools for building application software.” In an HTML API, the definitions and protocols are in the HTML itself, and the tools look in HTML for the configuration. HTML APIs usually consist of certain class and attribute patterns that can be used on existing HTML. With Web Components, even [custom element names](https://www.w3.org/TR/custom-elements/)are game, and with the [Shadow DOM](https://dom.spec.whatwg.org/#shadow-trees), those can even have an entire internal structure that is hidden from the rest of the page’s JavaScript or CSS. But this is not an article about Web Components; Web Components give more power and options to HTML API designers; but the principles of good (HTML) API design are the same.

那么什么是 HTML API 呢？根据[维基百科](https://en.wikipedia.org/wiki/Application_programming_interface)的定义,API（也就是应用程序接口）是“子程序定义、协议和构建应用软件的工具的合集”。在 HTML API 中，定义和协议都在 HTML 中实现，工具也在 HTML 中配置。HTML API 通常由特定的类和可用于先有的 HTML 的属性模式组成。通过 Web 组件（甚至[自定义元素名称](https://www.w3.org/TR/custom-elements/)都是游戏）和[Shadow DOM](https://dom.spec.whatwg.org/#shadow-trees)，HTML API 甚至能拥有完整的内部结构，隐藏在页面其余的 JavaScript 或者 CSS 中。但是这并不是一篇关于 Web 组件的文章，Web 组件给予了 HTML API 设计者更多的能力和选择，但是良好的（HTML）API 设计原则都是相同的。

HTML APIs improve collaboration between designers and developers, lift some work from the shoulders of the latter, and enable designers to create much higher-fidelity mockups. Including an HTML API in your library does not just make the community more inclusive, it also ultimately comes back to benefit you, the programmer.

HTML API 加强了设计师和工程师之间的合作，减轻工程师肩上的工作负担，还能让设计师创造更具有忠诚度的原型。在类库中引入 HTML API 不仅让社区更具包容性，最终还能反过来让程序员受益。

**Not every library needs an HTML API.** HTML APIs are mostly useful in libraries that enable UI elements such as galleries, drag-and-drop, accordions, tabs, carousels, etc. As a rule of thumb, if a non-programmer cannot understand what your library does, then your library doesn’t need an HTML API. For example, libraries that simplify or help to organize code do not need an HTML API. What kind of HTML API would an MVC framework or a DOM helper library even have?

**并不是每个类库都需要  HTML API。**HTML API 在使用了 UI 元素的类库中非常有用，比如 galleries、drag-and-drop、accordions、tabs、carousels 等等。第一要务便是，如果一个非程序员不能理解你的类库是干什么的，那么它就不需要 HTML API。比如，那些简化代码或者帮助管理代码的类库就不需要 HTML API。那么 MVC 框架或者 DOM 助手类库应该用什么样的 HTML API 呢？

So far, we have discussed what an HTML API is, why it is useful and when it is needed. The rest of this article is about how to design a good one.

目前为止，我们只讨论了 HTML API 的定义、功能和用处，文章剩下的部分是关于如何设计一个好的 HTML API。

### Init Selector ###

### 初始化选择器 ###

With a JavaScript API, initialization is strictly controlled by the library’s user: Because they have to manually call a function or create an object, they control precisely when it runs and on what. With an HTML API, we have to make that choice for them, and make sure not to get in the way of the power users who will still use JavaScript and want full control.

在 JavaScript API 中，初始化是被类库的用户严格控制的：因为他们必须手动调用函数或者创建对象，他们精确地控制着运行的时间和基础。在 HTML API 中，我们必须帮用户做选择并且还要确保不会妨碍那些强势的仍然使用 JacaScript 并且想要得到完全控制权的用户。

The common way to resolve the tension between these two use cases is to only auto-initialize elements that match a given selector, usually a specific class. [Awesomplete](http://leaverou.github.io/awesomplete) follows this approach, only picking up input elements with `class="awesomplete"`.

最常见的解决两种使用场景的办法就是只有匹配到一个给定的选择器，通常是一个特定的类，的时候才会自动初始化。[Awesomplete](http://leaverou.github.io/awesomplete) 就是采用的这种方法，只选取输入的具有 `class="awesomplete"` 的元素。

In some cases, making auto-initialization easy is more important than making opt-in explicit. This is common when your library needs to run on a lot of elements, and when avoiding having to manually add a class to every single one is more important than making opt-in explicit. For example, [Prism](http://prismjs.com/) automatically highlights any `<code>` element that contains a `language-xxx` class (which is what the HTML5 specification [recommends for specifying the language of a code snippet](https://www.w3.org/TR/html51/textlevel-semantics.html#the-code-element)) or that is inside an element that does. This is because it could be included in a blog with a ton of code snippets, and having to go back and add a class to every single one of them would be a huge hassle.

有些时候，把自动初始化变得简单比做详尽的选项说明更重要。这是一个很常见的现象，当你的类库需要在非常多的元素上运行的时候，避免手动给每个单独元素添加类比详细的选项说明更加重要。比如，[Prism](http://prismjs.com/) 自动高亮任何包含 `language-xxx` 类的 `<code>` 元素（HTML5 的说明中[建议指定代码段的语言](https://www.w3.org/TR/html51/textlevel-semantics.html#the-code-element)）以及其内部的元素。这是因为 Prism 可能会用在一个有着成千上万的代码段的博客系统中，回过头去给每一个元素添加类会是一项非常巨大的工程。

In cases where the `init` selector is used very liberally, a good practice is to allow customization of it or allow opting-out of auto-initialization altogether. For example, [Stretchy](https://leaverou.github.io/stretchy)[13](#13) autosizes *every*`<input>`, `<select>` and `<textarea>` by default, but allows customization of its `init` selector to something more specific via a `data-stretchy-filter` attribute. Prism supports a `data-manual` attribute on its `<script>` element to completely disable automatic initialization. A good practice is to allow this option to be set via either HTML or JavaScript, to accommodate both types of library users.

在非常自由地使用 `init` 选择器的情况下，允许自定义或者完全不自动化会是一个良好的实践。比如，[Stretchy](https://leaverou.github.io/stretchy)<sup>[\[1\]](#note1)</sup> 默认地设置**每个** `<input>`、`<select>` 和 `<textarea>` 的大小，但是也允许通过 `data-stretchy-filter` 属性自定义设置其他特定的元素为 `init` 选择器。Prism 支持 `<script>` 元素的 `data-manual` 属性来完全取消自动初始化。良好的实践应该使得 HTML 和 JacaScript 都能设置这个选项，来适应 HTML 和 JavaScript 两种类库的用户。

### Minimize Init Markup  ###

###最小化初始标记###

So, for every element the `init` selector matches, your library needs a wrapper around it, three buttons inside it and two adjacent divs? No problem, but generate them yourself. This kind of grunt work is better suited to machines, not humans. **Do not expect that everyone using your library is also using some sort of templating system**: Many people are still hand-crafting markup and find build systems too complicated. Make their lives easier.

那么，对于每个符合 `init` 选择器的元素来说，你的类库需要它的外层元素，三个内部的 button 和两个相邻的 div 该怎么办呢？没问题，但是你需要自己生成。这种墨迹的工作更适合机器，而不是人。**不要期望每个使用类库的人都在同时使用一些模板系统**：许多人还在使用手动标记并且发现在某些类库中建造系统太过于复杂。因此，让他们活的轻松点不好吗？

This also minimizes error conditions: What if a user includes the class that you expect for initialization but not all of the markup you need? When there is no extra markup to add, no such errors are possible.

这也最小化了错误风险：如果一个用户仅仅引入了用来初始化的类却没有引入所有需要的标记呢？如果不需要添加额外的标记，就不会有这样的错误。

There is one exception to this rule: graceful degradation and progressive enhancement. For example, embedding a tweet involves a lot of markup, even though a single element with `data-*` attributes for all the options would suffice. This is done so that the tweet is readable even before the JavaScript loads or runs. A good rule of thumb is to ask yourself, does the extra markup offer a benefit to the end user even without JavaScript? If so, then requiring it is OK. If not, then generate it with your library.

但是这条规则中有这样个例外：优雅地退化并且渐进式增强。比如，要嵌入一个有很多标记的推文，即使单独的具有 `data-*` 属性的一个元素就足够实现所有的内容。在 JavaScript 加载和运行之前就使得推文可读，这样才算实现内容。良好的设计规则里的首条内容就是扪心自问，即使在没有 JavaScript 的时候，多余的标记是否也能让终端用户受益？如果是，那么就引入。如果不是，那就先用你的类库生成。

There is also the classic tension between ease of use and customization: Generating all of the markup for the library’s user is easier for them, but leaving them to write it gives them more flexibility. **Flexibility is great when you need it, but annoying when you don’t**, and you still have to set everything manually. To balance these two needs, you can generate the markup you need if it doesn’t already exist. For example, suppose you wrap all `.foo` elements with a `.foo-container` element? First, check whether the parent — or, better yet, any ancestor, via `element.closest(".foo-container")` — of your `.foo` element already has the `foo-container` class, and if so, use that instead of creating a new element.

还有一个经典的矛盾，便于用户使用还是让用户自定义：自动生成所有的标记会让用户易于使用，让他们自己去定义又显得更加灵活。**在你需要的时候，灵活性便如雪中送炭，在不需要的时候反而会适得其反，**因为你不得不手动设置所有的参数。为了平衡这两种需要，你可以生成那些需要但不存在的标记。比如，假设你需要给所有的 `.foo` 元素外层添加一个 `.foo-container` 元素。首先，通过 `element.closest(".foo-container")` 检查 `.foo` 元素的父元素或者任何的上级元素是否含有 `foo-container` 类，如果有的话，你就不用生成新的元素，直接使用就可以了。

### Settings ###

###设置###

Typically, settings should be provided via `data-*` attributes on the relevant element. If your library adds a ton of attributes, then you might want to namespace them to prevent collisions with other libraries, like `data-foo-*` (where foo is a one-to-three letter prefix based on your library’s name). If that’s too long, you could use `foo-*`, but bear in mind that this will break HTML validation and might put some of the more diligent HTML authors off your library because of it. Ideally, you should support both, if it won’t bloat your code too much. None of the options here are ideal, so there is an ongoing [discussion](https://github.com/whatwg/html/issues/2271) in the WHATWG about whether to legalize such prefixes for custom attributes.

典型的方法应该是在恰当的元素上使用 `data-*` 属性来进行设置。如果你的类库中添加了成千上万的属性，然后你希望给它们添加明明空间来避免和其他类库混淆，比如这样 `data-foo-*`（foo 是基于类库名字的一到三个字母长度的前缀）。如果那样名字显得太长，你可以使用 `foo-*`，但是要有心理准备，这种方式会打破 HTML 验证并且会影响一些勤勉的 HTML 作者因此而弃用你的类库。理想情况下，只要代码不会太臃肿，以上两种情况都应该支持。目前还没有完美的解决办法，因此在 WHATWG 中展开了一场如火如荼的[讨论](https://github.com/whatwg/html/issues/2271)，论题即是否应该合法化这些自定义属性的前缀。

**Follow the conventions of HTML as much as possible.** For example, if you use an attribute for a boolean setting, its presence means `true` regardless of the value, and its absence means `false`. Do not expect things like `data-foo="true"` or `data-foo="false"` instead. Sure, ARIA does that, but if ARIA jumped off a cliff, would you do it, too?

**尽可能地遵守 HTML 的规定。**比如，你使用了一个属性来做布尔类型的设置，当该属性出现时无论任何的值都被视为 `true`，若不出现则被视为 `false`。不要期望者可以用 `data-foo="true"` 或者 `data-foo="false"` 来代替。当然 ARIA 是这样做的，但是如果 ARIA 突然跳崖了，你也想跳吗？

When the setting is a **boolean**, you could also use classes. Typically, their semantics are similar to boolean attributes: The presence of the class means `true`, and the absence means `false`. If you want the opposite, you can use a `no-` prefix (for example, `no-line-numbers`). Keep in mind that class names are used more than `data-*` attributes, so there is a greater possibility of collision with the user’s existing class names. You could consider prefixing your classes with a prefix like `foo-` to prevent that. Another danger with class names is that a future maintainer might notice that they are not used in the CSS and remove them.

在进行**布尔类型**的设置时，你也可以使用类。典型的，其语义和布尔属性值类似：类出现的时候是 `true` 不出现的时候就是 `false`。如果你想反过来设置，那就用一个 `no-` 前缀（比如，`no-line-number`）。但是要记住，类名可不仅仅只有 `data-*` 属性，因此这种方式很可能会和用户现存的类名冲突。你可以考虑一下在类名中使用 `foo-` 这样的前缀来避免。还存在一个隐患就是，后期的维护中可能会发现它们并未被 CSS 使用而移除它们。

When you have a group of related boolean settings, using one space-separated attribute might be better than using many separate attributes or classes. For example, `<div data-permissions="read add edit delete save logout>"` is better than `<div data-read data-add data-edit data-delete data-save data-logout">`, and `<div class="read add edit delete save logout">` would likely cause a ton of collisions. You can then target individual ones via the `~=` attribute selector. For example, `element.matches("[data-permissions~=read]")` checks whether an element has the `read` permission.

当你有一组相关的布尔类型设置时，使用空格区分多个属性会比使用很多分隔符来区分多个属性和类的方式好得多。比如，`<div data-permissions="read add edit delete save logout">` 就比 `<div data-read data-add data-edit data-delete data-save data-logout">`, and `<div class="read add edit delete save logout">` 好得多，因为后者可能会造成很多的冲突。使用空格区分多个属性，你还可以使用 `~=` 属性选择器来定位单个元素。比如，`element.matches("[data-permissions~=read]")` 可以检查该元素是否有 `read` 权限。

If the type of a setting is an **array or object**, then you can use a `data-*` attribute that links to another element. For example, look at how HTML5 does autocomplete: Because autocomplete requires a list of suggestions, you use an attribute to link to a `<datalist>` element containing these suggestions via its ID.

如果设置的类型是一个**数组或者对象**，那么你就可以使用 `data-*` 属性来联系到另一个元素。比如，来看看 HTML5 如何自动完成的：因为自动完成需要一个建议列表，你使用一个属性并且通过 `<datalist>` 的 ID 联系到这些内容。

This is a point when following HTML conventions becomes painful: In HTML, linking to another element in an attribute is always done by referencing its ID (think of `<label for="…">`). However, this is rather limiting: It’s so much more convenient to allow selectors or even nesting if it makes sense. What you go with will largely depend on your use case. Just keep in mind that, while consistency is important, usability is our goal here.

在遵从 HTML 规定的时候有一点很痛苦：在 HTML 中，用属性联系到另一个元素通常是靠引用其 ID（试想一下 `<label for="...">`）。然而，这相当受限：如果能够允许选择器或者甚至允许嵌套，这将更为方便。其效果将会极大地依赖于你所选用的内容。只要记住，尽管稳定性很重要，但是我们的目标是好用。

**It’s OK if not every single setting is available via HTML.** Settings whose values are functions can stay in JavaScript and be considered “advanced customization.” Consider [Awesomplete](http://leaverou.github.io/awesomplete/#customization): All numerical, boolean, string and object settings are available as `data-*` attributes (`list`, `minChars`, `maxItems`, `autoFirst`). All function settings are only available in JavaScript (`filter`, `sort`, `item`, `replace`, `data`). If someone is able to write a JavaScript function to configure your library, then they can use the JavaScript API.

**即使有部分设置不能通过 HTML 生效也没关系。**在 JavaScript 中设置的函数被认为是“高级自定义”的内容。试想一下 [Awesomplete](http://leaverou.github.io/awesomplete/#customization)：所有数字、布尔值、字符串和对象都可以通过 `data-*` 属性（`list`、`minChars`、`maxItems`、`autoFirst`）设置。所有的函数设置只能通过 JacaScript 生效（`filter`、`sort`、`item`、`replace`、`data`）。如果有人想写一个 JacaScript 函数来配置类库，然后他们就可以使用 JavaScript API 了。

Regular expressions (regex) are a bit of a gray area: Typically, only programmers know regular expressions (and even programmers have trouble with them!); so, at first glance there doesn’t seem to be any point in including settings with regex values in your HTML API. However, HTML5 did include such a setting (`<input pattern="regex">`), and I believe it was quite successful, because non-programmers can look up their use case in a [regex directory](http://www.html5pattern.com/)[16](#16) and copy and paste.

正则表达式（regex）处在灰色地带：典型的，只有程序员才知道正则表达式（甚至程序员也会有问题！）；那么，乍看之下，在 HTML API 中引入正则表达式的设置内容并没有什么意义。然而，HTML5 确实引入了这样的设置（`<input pattern="regex">`），并且我相信那会很成功，因为非程序员能在[正则词典](http://www.html5pattern.com/)<sup>[\[2\]](#note2)</sup>中找到他们的用例并复制粘贴。

### Inheritance ###

###继承###

If your UI library is going to be used once or twice on each page, then inheritance won’t matter much. However, if it could be applied to multiple elements, then configuring the same settings on each one of them via classes or attributes would be painful. Remember that **not everyone uses a build system**, especially non-developers. In these cases, it might be useful to define that settings can be inherited from ancestor elements, so that multiple instances can be mass-configured.

如果你的 UI 库只会在每一页调用一次或者两次，那么继承将不会有很大影响。然而，如果要应用于多个元素，那么通过类或者属性给每个元素做相同的配置将会非常痛苦。只需要记住**并不是每个人都用了构造系统**，尤其是非程序员。在这些情况下，定义能够从祖先元素继承设置将会变得非常有用，那样多个实例就可以被批量设置了。

Take [Prism](http://prismjs.com/), a popular syntax-highlighting library, used here on Smashing Magazine as well. The highlighting language is configured via a class of the form `language-xxx`. Yes, this goes against the guidelines we discussed in the previous section, but this was a conscious decision because the [HTML5 specification recommends this](https://www.w3.org/TR/html51/textlevel-semantics.html#the-code-element) for specifying the language of a code snippet. On a page with multiple code snippets (think of how often a blog post about code uses inline `<code>` elements!), specifying the coding language on each `<code>` element would become extremely tedious. To mitigate this pain, Prism supports inheritance of these classes: If a `<code>` element does not have a `language-xxx` class of its own, then the one of its closest ancestor that does is used. This enables users to set the coding language globally (by putting the class on the `<body>` or `<html>` elements) or by section, and override it only on elements or sections with a different language.

比如 [Prism](http://prismjs.com/)，时下流行的语法高亮类库，在这里也使用了 Smashing Magazine。高亮语言是通过 `languate-xxx` 形式的类来配置高亮语言。是的，这违反了我们在前文中谈过的规则，但是这只是一种主观决定，仅仅是因为在 [HTML5 说明中建议如此而已](https://www.w3.org/TR/html51/textlevel-semantics.html#the-code-element)。在有许多代码段的页面上（想象一下，在博客文章中使用内联 `<code>` 元素的频率！），在每个 `<code>` 元素中指定代码语言将会非常烦人。为了缓解这种痛苦，Prism 支持继承这些类：如果一个 `<code>` 元素自己没有 `language-xxx` 类，那么将会使用最近的祖先元素的 `language-xxx` 类。这使得用户可以设置全局的代码语言（通过在 `<body>` 或者 `<html>` 元素上设置类）或者设置区块的代码语言，并且可以在拥有不同语言的元素或者区块上重写设置。

Now that [CSS variables](https://www.w3.org/TR/css-variables/) are [supported by every browser](http://caniuse.com/#feat=css-variables), they are a good candidate for such settings: They are inherited by default and can be set inline via the `style` attribute, via CSS or via JavaScript. In your code, you get them via `getComputedStyle(element).getPropertyValue("--variablename")`. Besides browser support, their main downside is that developers are not yet used to them, but that is changing. Also, you cannot monitor changes to them via `MutationObserver`, like you can for elements and attributes.

既然 [CSS 变量](https://www.w3.org/TR/css-variables/)已经得到[所有的浏览器支持](http://caniuse.com/#feat=css-variables)，他们可以用于以下设置：他们默认可以被继承，并且可以以内联的方式通过 `style` 属性设置，也可以通过 CSS 或者 JavaScript 设置。在代码中，你可以通过 `getComputedStyle(element).getPropertyValue("--variablename")` 获取它们。除了浏览器支持，它们的不利之处还有开发者们并不习惯使用，但是那已经发生改变了。并且，你不能通过 `MutationObserver` 来监视其改变，就像你监视元素和属性的改变一般。

### Global Settings ###

###全局设置###

Most UI libraries have two groups of settings: settings that customize how each instance of the widget behaves, and global settings that customize **how the library behaves**. So far, we have mainly discussed the former, so you might be wondering what is a good place for these global settings.

大多数 UI 类库都有两组设置：定义每个组件表现形式的设置和定义整个类库表现形式的全局设置。目前为止，我们主要讨论了前者，因此你现在可能在好奇全局设置有什么好用的地方。

One candidate is the `<script>` element that includes your library. You can get this via [`document.currentScript`](http://www.2ality.com/2014/05/current-script.html), and it has very good [browser support](http://caniuse.com/#feat=document-currentscript). The advantage of this is that it’s unambiguous what these settings are for, so their names can be shorter (for example, `data-filter`, instead of `data-stretchy-filter`).

有一个好处就是 `<script>` 元素可以被引入类库。你可以通过 [`document.currentScript`](http://www.2ality.com/2014/05/current-script.html) 获取该元素，并且这有着非常好的[浏览器支持](http://caniuse.com/#feat=document-currentscript)。好处就是，这对于设置的作用域非常清楚，因此它们的名字可以起的更短（比如 `data-filter` 而不是 `data-stretchy-filter`）。

However, the `<script>` element should not be the only place you pick up these settings from, because some users may be using your library in a CMS that does not allow them to customize `<script>` elements. You could also look for the setting on the `<html>` and `<body>` elements or even anywhere, as long as you have a clearly stated policy about which value wins when there are duplicates. (The first one? The last one? Something else?)

然而，你不能只在 `<script>` 元素中进行设置，因为一些用户可能会在 CMS 中使用你的类库，而 CMS 中不允许用户自定义 `<script>` 元素。你也可以在 `<html>` 和 `<body>` 元素或者甚至任何地方设置，只要你清楚地声明了当有属性值重复的时候哪个会生效。（第一个？最后一个？还是其他的？）

### Documentation ###

###文档###

So, you’ve taken care to design a nice declarative API for your library. Well done! However, if all of your documentation is written as if the user understands JavaScript, few will be able to use it. I remember seeing a cool library for toggling the display of elements based on the URL, via HTML attributes on the elements to be toggled. However, its nice HTML API could not be used by the people it targeted because the entire documentation was littered with JavaScript references. The very first example started with, “This is equivalent to `location.href.match(/foo/)`.” What chance does a non-programmer have to understand this?

那么，你已经掌握了如何在类库中设置一个漂亮的声明性的 API。棒极了！然而，如果你所有的文档都写得只有了解 JavaScript 的用户才看得懂，那么就只有很少人能使用了。我记得曾经看过一个很酷的类库，基于 URL 并通过切换元素的 HTML 属性来切换元素的表现形式。然而，这漂亮的 HTML API 并不能被其目标人群所使用，因为整篇文档中都充满了 JavaScript 引用。最开始的例子是这样开始的“这和 `location.href.match(/foo/)` 等价。”非程序员哪能看懂这个呢？

Also, remember that many of these people do not speak any programming language, not just JavaScript. Do not talk about models, views, controllers or other software engineering concepts in text that you expect them to read and understand. All you will achieve is confusing them and turning them away.

同时要记得许多人并不会任何编程语言，不只是 JacaScript。并不知道你所期望用户读懂和理解的文中的模型、视图、控制器或者其他软件工程观念，结果无非是让他们摸不着头难并且放弃。

Of course, you should document the JavaScript parts of your API as well. You could do that in an “Advanced usage” section. However, if you start your documentation with references to JavaScript objects and functions or software engineering concepts, then you’re essentially telling non-programmers that this library is not for them, thereby excluding a large portion of your potential users. Sadly, most documentation for libraries with HTML APIs suffers from these issues, because HTML APIs are often seen as a shortcut for programmers, not as a way for non-programmers to use these libraries. Hopefully, this will change in the future.

当然，你也应该在文档中写 API 中的 JavaScript 部分内容，你可以写在“高级使用”部分。然而，如果你在文档一开头就引用 JavaScript 对象和函数或者软件工程观念，那么你实质上就是在告诉非程序员这个类库不是给他们用的，因此你就排除了一大批潜在用户。不幸的是，大部分的 HTML API 类库文档都受这些问题困扰着，因为 HTML API 经常被视为是是程序员的捷径，而并不是给非程序员使用的。庆幸的是，这种状况在未来可以有改变。

### What About Web Components? ###

###那么 Web 组件呢？###

In the near future, the Web Components quartet of specifications will revolutionize HTML APIs. The `<template>` element will enable authors to provide scripts with partial inert markup. Custom elements will enable much more elegant `init` markup that resembles native HTML. HTML imports will enable authors to include just one file, instead of three style sheets, five scripts and ten templates (if Mozilla gets its act together and [stops thinking that ES6 modules are a competing technology](https://hacks.mozilla.org/2014/12/mozilla-and-web-components)). The Shadow DOM will enable your library to have complex DOM structures that are properly encapsulated and that do not interfere with the user’s own markup.

在不远的未来，Web 组件四分之一的规格将会彻底改变 HTML API。`<template>` 元素将会使得作者提供惰性加载的脚本。自定义元素将能运用更多的 `init` 标记来组建原生的 HTML。引入 HTML 也将使得作者能够仅引入一个文件来替代三个样式表、五个脚本和十个模板（如果浏览器能够同时获取并且[不再认为 ES6 模块是不友好的技术](https://hacks.mozilla.org/2014/12/mozilla-and-web-components)）。Shadow DOM 使得类库可以将复杂的 DOM 结构适当压缩并且不会影响用户自己的标记。

However, `<template>` aside, browser support for the other three is [currently limited](http://caniuse.com/#search=web%20components). So, they require large polyfills, which makes them less attractive for library use. However, it’s something to keep on your radar for the near future.

然而，`<template>` 那边，浏览器对其他三个的支持[目前受限](http://caniuse.com/#search=web%20components)。因此他们需要更高的聚合度，以此来减少对类库的影响。然而，这将会是你在未来一段时间里时刻关注的东西。

### MarkApp: A List Of Libraries With HTML APIs

### MarkApp：一个 HTML API 类库的列表

If you’ve followed the advice in this article, then congratulations on making the web a better, more inclusive space to be creative in! I try to maintain a list of all libraries that have HTML APIs on [MarkApp](http://markapp.io/). Send a pull request and add yours, too!

如果你已经遵循了这篇文章中的建议，那么恭喜你已经能够把网站做得更好，更有内涵和创造性了！我在 [MarkApp](http://markapp.io/) 上维护着一些使用 HTML API 类库的列表。请也发 Pull Request 给我，来添加你自己的内容！
