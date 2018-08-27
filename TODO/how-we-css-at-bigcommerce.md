* 原文链接 : [How we "CSS" at BigCommerce](http://www.bigeng.io/how-we-css-at-bigcommerce/)
* 原文作者 : [Simon Taggart](http://www.bigeng.io/author/simon-taggart/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [shenxn](https://github.com/shenxn)
* 校对者: [CoderBOBO](https://github.com/CoderBOBO)，[aleen42](https://github.com/aleen42)，[Evaxtt](https://github.com/Evaxtt)
* 状态 : 翻译完成

# 在 BigCommerce 我们如何编写 CSS

[我们的《SASS风格指南 - SASS Style Guide》现在已经可以在GitHub上找到](https://github.com/bigcommerce/sass-style-guide)

CSS 很难，而写出好的 CSS 代码更难。在一个大团队中，基于巨大的代码库写出好的 CSS 代码，更是难上加难。

我们并不是一家独一无二的软件公司：120个工程师，4间办公室，3个不同国家，3个时区，以及7年时间，代表着一个大家都很熟悉的代码库环境。每个人都有着一份干劲。这里有着30种不同风格的按钮，4种“品牌色彩”的变形，以及一个列举了互联网上所有 JavaScript 包的 package.json / bower.json 文件。CSS 与其他语言相比，看起来就像是一个被忽视的可的孩子，只得到了最少的关怀。CSS 没有固定的规范，没有约定，也没有內建工具来防止你写出只有自己看得懂的代码。CSS 就是一个雷区，我们困在其中，也有许多人会继续一头扎进来。

在 BigCommerce，我们认为至少可以通过设置一些基本规范，并且让每一个编写 CSS 的人遵循它们，来解决一些在编写大量 CSS 代码时经常会遇到的问题。我们的《SAAS 风格指南》并没有什么突破性的内容，并且其中的观点很像 AirBnB 的 [《JavaScript 风格指南 - JavaScript Style Guide》](https://github.com/airbnb/javascript)。我不会把那篇文章原封不动地复制到我的博客里，你可以[在 GitHub 上找到](https://github.com/bigcommerce/sass-style-guide)。同时我认为，详细解释一些具体规则并且列出我们使用的工具会更加有帮助。


## 目标

首先，我们想要完成的并不是尝试去变得更加聪颖，前沿或高度地优化。我们遵循一个公开的策略：合理性高于优化，清晰高于精巧。我们的目标是让我们的代码库更容易在一个大型团队中交流与共享。你会注意到在整篇文档中出现了许多类似“可读且可理解的”、“简单的”、“在包含必要内容的前提下尽量精简”、以及“你能做不意味着你应该做”等语句，使我们在编写 CSS 方式上达成共识。

## 原则

我们对 CSS 的贡献基于一些关于 CSS 和组件的指导性原则。我会提到一些对于我们来说非常重要的点，不管它们是关键点或是不那么显而易见的点：

> 不要过早地优化你的代码；先保证代码容易阅读且容易理解。

我们的 CSS 代码基于 SAAS，准确来说是 SCSS 语法。SASS 是很强大的，同时也是很糟糕的。使用任何强大的工具，都会带来一个风险：软件工程师总是会做一件他们_非常_擅长的事：过度开发。

“你能做不意味着你应该做”这样的措辞在 SASS 中的应用会非常的多。我见到过一些非常复杂的 SASS 函数生成一串巧妙的 CSS 代码。而其中的危险在于：很多人根本不关注函数的输出。其实，这些输出是非常重要的，特别是代码的权重和特殊性（specificity）。同时，使用巧妙的语法或者选择器嵌套（类似[《父选择器前缀 - Parent Selector Suffix》](http://thesassway.com/news/sass-3-3-released#parent-selector-suffixes)）会使代码变得简洁，但这会使代码在代码库中非常难以被搜索出来。

    /* 尽量避免 */
    .component {
        &-parentSelectorSuffix { ... } /* .component-parentSelectorSuffix {} */

        .component-childSelector { ... } /* .component .component-childSelector {} */

        .notSoObviousParentSelector & { ... } /* .notSoObviousParentSelector .component {} */
    }

不要过度使用一些“巧妙”的技巧。这甚至会使得我难以理解你的代码并作出修改。如果你让代码更简单一些，并让预处理器去做那些巧妙的事情，那么我一定会感谢你的。

> 分解复杂的组件，并使得它们由简单的组件构成

不可否认，这是在 HTML 和 CSS 样式中撰写时最为重要的事情。BEM，SUITCSS，SMACSS等命名规范都是保持你代码模块化非常方便的工具，但是过分遵从这些“规范”会在处理一些深层嵌套的子元素时产生一些非常长非常复杂的类名。

尽早抽象出通用的子样式以防止产生像这样的可怕的选择器：

    .componentName__childName__otherChildName__thisIsSillyNow__nopeYouTotallyMissedThePointOfThis--modifier {
        …
    }

> 使用混合（mixin）构建你的组件以便输出可定义的CSS

这是一个很有趣的点。我们作为一个团队，以一种特定的方式编写样式、公共标记和 CSS 规则以在 UI 中显示一种特定类型的数据。我们的框架不会默认输出 CSS，你必须选择你想要的组件。

同时，我们的框架服务多个不同的领域。由于这其中的数据可能是一样的，样式可能也是相似的，但种种原因使得我们选择的通用样式命名并不适用。也许我们的 “card” 组件在你领域的代码库下叫做 "product" 更加合适。所以我们构建的所有组件都是混合型组件，并包装在一个通用的类名内。

    /* 以 media 对象作为例子 */
    .media {
        @include media;
    }

    .mediaTable {
        @include media("table");
    }

因为你可以自定义生成的 CSS 代码，你就可以自由地重命名你选择的组件和引用 mixin。同时你依然遵循设计样式。

## 一些需要强调的规则

在这里，我将就如何构建一个用于稍大项目的优秀代码库强调几个关键规则。

#### 特殊性（Specificity） [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#specificity)

尽量使用具有低特殊性的选择器。这会帮助你把组件抽象成小块，并更容易重用和重混合样式。同时，这能防止你的代码在将来产生很多特殊性冲突（Specificity Clash）。

    /* 避免使用ID */
    #component { … }

    /* 避免使用子标签 */
    .component h2 { … }

    /* 避免使用有条件的标签选择器 */
    div.component { … }

    /* 避免使用过于具体的选择器 */
    ul.component li span a:hover { … }  

#### 声明属性 [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#when-declaring-values)

在构建一个大的样式代码库时，试图只定义那些你明确关注的属性，以防止过度重置你想要继承的属性。

*   使用 `background-color: #333;` 而不是 `background: #333`
*   使用 `margin-top: 10px;` 而不是 `margin: 10px 0 0;`

举例来说，在使用 background 简略写法时，你将会重设`background-position`, `background-image`, `background-size`等你不想重设的属性。

#### 声明顺序 [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#declaration-order)

首先使用 `@extend`，然后使用 `@include`，最后设置你的属性。理论上来说，extend 和 include 不需要覆盖你的属性。同时，根据我的习惯，我总是按照**字母顺序**排列属性。

不同的人喜欢不同的方式来组合他们的 CSS 属性，每当有新人加入时，不要强迫他们学习你的观点或者是逻辑。事实上，属性的顺序并不重要，为了能够达成共识，并做到可预测和可广泛使用，我们会使用字母顺序，因为绝大多数人都知道字母表，并且按字母顺序排序可以让你更快找到重复定义。

    .component {
        @extend %a-placeholder;
        @include silly-links;
        color: #aaa;
        left: 0;
        line-height: 1.25;
        min-height: 400px;
        padding: 0 20px;
        top: 0;
        width: 150px;
    }

#### 嵌套（Nesting） [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#nesting)

不要使用，或者至少是尽量少用。

你编译好的代码很容易被遗忘。当你在 SASS 中使用嵌套来构造选择器时，你会很容易破坏[特殊性](https://github.com/bigcommerce/sass-style-guide#specificity)和[性能](https://github.com/bigcommerce/sass-style-guide#performance)指导原则。你能做不意味着你应该做。我们最多只使用1层嵌套。

    .panel-body {
        position: relative;
    }

    .panel-sideBar {
        z-index: 10;
    }

    .panel-sideBar-item {
        cursor: pointer;
    }

    .panel-sideBar-item-label {
        color: #AEAEAE;

        &.has-smallFont {
            font-size: 13px;
        }
    }

#### 变量名 [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#variables)

抽象你的变量名称。不要使用你设置的颜色等来命名你的变量。使用颜色命名的变量不再是一个变量了，并且当你想把变量 `$background-color-blue` 的值改成 red 的时候，使用这样的变量与查找和替换一个十六进制颜色码就没有区别了。

*   使用 `$color-brandPrimary` 而不是 `$bigcommerceBlue`

#### 映射（Map）以及映射函数（Map Function） [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#component--micro-app-level-variables)

正如 Erskine Design 的[《SASS映射中更友好的颜色名称 - Friendlier colour names with SASS maps》](http://erskinedesign.com/blog/friendlier-colour-names-sass-maps/)所描述的，我们使用 SASS 映射来完成大量全局样式属性，不仅仅是颜色这种我们开发者经常需要用到的属性。

SASS 为映射提供了一个简单且可预测的 API，并且可以用于大量属性类似 z-index，font-weight 和 line-height。我们会在将来的一篇博客中更详细讲述这个主题。

    color: color("grey", "darker");  
    font-size: fontSize("largest");  
    line-height: lineHeight("smaller");  
    z-index: zIndex("highest");  

#### 组件命名规则 [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#components)

我们深受 [SuitCSS](http://suitcss.github.io/) 的启发，并且将其规则稍稍改动以符合我们的口味和需求。比如说，我们使用驼峰命名法（Camel Case）替代 Pascal 命名法（Pascal Case）。

正如我之前提到的，正确命名你的继承是非常重要的，因此我们使用了一些相当实用的方法。一个元素是你组件根的继承的继承，不意味着它在 DOM 中_必须_处在那个层级，它可以在与第一个继承相邻的位置完成相同的功能。

    <article>  
      <header>
        <img src="{$src}" alt="{$alt}">
        ...
      </header>
      <div>
        ...
      </div>
    </article>  

当我们处理一些复数的东西时，也许单数形式的继承名字会更合适，并且最好不要附加父元素的名字。

    <ul>  
      <li>
        <a href="#"></a>
      </li>
    </ul>  

所以，我们最好尽可能去精简类名以防止其过于冗长，但我们依然需要保证包含了必要的内容。

#### 工具和执行

正如我之前提到的，我们新的 CSS 代码库是基于 SASS 的，并且像其他的流行库一样使用 [libSass](http://sass-lang.com/libsass) 来编译我们的样式表。然而还存在一些项目使用 Ruby 来编译 Sass，以致其性能的下降是非常明显。

我也提到了让你的编译器来做一些巧妙的事情。其中一个例子就是浏览器引擎前缀（Vendor Prefixes）。我们在 SASS 处理完成后使用 Autoprefixer 来自动添加浏览器引擎前缀，而不是使用不同浏览器专用的实现来扰乱我们的代码，或是让 SASS 做一些额外的 Grunt 任务。

#### 优化

关于输出优化，我们在每次部署核心CSS库的时候使用 [CSSO](http://css.github.io/csso/)来优化我们的代码。CSSO 会做一些常见的操作如通过删除空白符来压缩文件等，但是 CSSO 也会对我们的代码进行一些结构优化：从不同的组件中将相似的选择器分组，尽量缩减语法，并除去由于我们使用更多“共识”和“清晰高于精巧”原则所带来的影响。我知道这听起来有些风险，但是到目前为止我们都没有发现任何问题并且 CSSO 一直都运作良好。

我知道你们中的一些人会在阅读指南的时候惊讶于我们一些规则引入的“重复代码”。然而 CSSO 帮助我们处理这些问题，并且我们依赖Gzip来移除可能剩下的重复代码片段。这使得我们的代码库可读，清晰并且容易理解。让工具来帮你做事。

#### 审查

最后，你如何检查你的团队成员是否遵从这些规则呢？一个好的 Pull Request 规则在大多数时候是有效的，但是对于一个大团队来说这并不只是一个小团队规则的放大版本。

当我们编写代码和在核心库上创建 Pull Request 时，我们使用 [scss-lint](https://github.com/brigade/scss-lint) 来分析我们的代码。如果代码不符合风格指南，你的代码不会在你的机器上构建，Travis 会失败，你的 Pull Request 也会被标记为失败。我们使用[YAML文件描述我们的规则 set](https://github.com/bigcommerce/sass-style-guide/blob/master/.scss-lint.yml)，这帮助我们非常接近风格指南，所以任何人都可以遵守。这个配置也被储存在我们开始所有新前端项目的公共 Grunt 任务上，所以你的 CSS 代码总是能被审查。

## 到底发生了什么

尽管我们已经尽力了，要把这些观点应用在一个大型的团队中依然非常困难。工具能够对你有所帮助，但是你依然可能编写出那些只是功能上满足但是并不好的 CSS 代码。

与工具和指南相比，我们发现教育和训练是更好用的。我尤其发现很多时候你真的需要在为时已晚之前从你在 CSS 上犯的错误中学习。编写只是功能上满足的 CSS 代码是很容易的，要花一些时间去学习这样的代码在整个生态系统中扮演着怎样的角色，并尝试预测这会带来什么副作用。

从好的方面来说，把我们的审查规则作为我们插件包的一部分确实能使风格指南易于被采用，并且人们都认为这非常实用。我们在基于映射的属性（像 fonts，sizes，spacing，line，heights 和 z-index）中使用的规则对于我们的 JavaScript 工程师也帮助非常大，因为这些都是可预测而且便于记忆的。

在大团队中基于大代码库编写 CSS 是非常困难的，但是你可以通过使用一些指南，工具和训练来帮助你的团队成员保持一致。总体来说，我觉得我们到目前为止都做得很好。

我知道你们一些人可能会说“可是X把这个处理得更好”。我希望能介绍一些出色的人在这个问题上是怎么做的，参考[《JavaScript 中 的CSS - CSS in JavaScript》](https://github.com/MicheleBertoli/css-in-js)，[《内联 CSS - Inline CSS》](https://speakerdeck.com/vjeux/react-css-in-js)以及[《CSS 模块 - CSS Modules》](http://glenmaddern.com/articles/css-modules)。我不会通过贬损这些处理方法，来保护那种编写CSS的老式方法，然而的确有一些原因使得我们没有按照那些方法去做。有一些问题是我们无法解决的；有一些问题我们真的很喜欢使用CSS来解决，比如使用媒体查询（Media Query）。大多数上面的观点和方法都是 从React 这个我们不使用的生态环境中来的。大多数也是来自于一些更幸运的环境比如大多数前端都已经是 JavaScript，但我们的并不是。只是因为你们的代码库比我们的更新，更小，或者你们有更多钱和更多工程师，但这并不意味着我们是错的或者你们是错的。

#### 总结

这就是我们的全部内容了。着眼于我们、以及很多不是 Facebook 团队或不是生活在理想世界中的团队所生存的环境和生态系统。

我希望这能够帮助你，因为使用一个有理有据的、实用的、并且通俗易懂的代码风格指南，以及一些预处理工具和代码审查，我们将能够在一个巨大的 CSS 代码库中找到乐趣。

很明显，文章中的很多内容都没有被着重阐明。我们将会发表一些其他关于“我们如何编写 CSS”以及我们如何让事情“不那么糟糕”的文章。我们将会解答：

*   我们的 CSS 框架——Citadel，以及它如何帮助我们减少代码和在不同领域的团队间共享代码。
*   构建自适应浏览器宽度的组件时使用的响应式和可伸缩设计样式。
*   创建一个简单的开发接口来处理公共属性。
*   为你的组织创建一个即时的 Pattern-Lab。
*   处理一个企业范围的设计样式库的技巧

