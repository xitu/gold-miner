* 原文链接 : [How we "CSS" at BigCommerce](http://www.bigeng.io/how-we-css-at-bigcommerce/)
* 原文作者 : [Simon Taggart](http://www.bigeng.io/author/simon-taggart/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [shenxn](https://github.com/shenxn)
* 校对者: 
* 状态 : 

# 在BigCommerce我们如何编写CSS

TL;DR [Our SASS Style Guide is available on GitHub](https://github.com/bigcommerce/sass-style-guide)

CSS很难，而写出好的CSS代码更难。在一个大团队中，基于巨大的代码库写出好的CSS代码，更是难上加难。

我们不是一个特殊的软件公司：120个工程师，4间办公室，3个不同国家，3个时区，以及7年时间，代表着一个大家都很熟悉的代码库环境。每个人都一直在尝试，代码库中也许有30种不同的按钮风格，4个不同的“品牌色彩”变量，以及一个列举了互联网上所有JavaScript包的 package.json / bower.json 文件。CSS与其他语言相比，看起来就像是一个被忽视的孩子，没有得到应有的照顾。CSS没有固定的规范，没有约定，也没有內建工具来防止你写出自己的代码风格。CSS就是一个雷区，我们都在这个雷区里面，许许多多其他人和团队也会持续不断地陷入其中。

在BC，我们认为至少可以通过设置一些基本规范，并且让每一个编写CSS的人遵循它们，来解决一些在编写大量CSS代码时经常会遇到的问题。我们的《SAAS风格指南》并没有什么突破性的内容，并且其中的观点很像AirBnB的 [《JavaScript风格指南 - JavaScript Style Guide》](https://github.com/airbnb/javascript)。我不会把那篇文章原封不动地复制到我的博客里，但是你可以[在GitHub上找到](https://github.com/bigcommerce/sass-style-guide)。然而我认为，详细解释一些具体规则并且列出我们使用的工具会更加有帮助。


## 目标

首先，我们不是想要变得更巧妙或者进行很好的优化。我们遵循一个开放策略：合理性高于优化，清晰高于精巧。我们的目标是让我们的代码库更容易在一个大型团队中交流与共享。你会注意到在整篇文档中出现了许多类似“可读且可理解的”，“简单的”，“在包含必要内容的前提下尽量精简”，以及“你能做不意味着你应该做”等语句，告诉我们一些关于编写CSS的常识。

## 原则

我们的CSS代码基于一些关于CSS和组件的指导性原则。我会提到其中很重要的，或者是不那么显而易见的点：

> 不要试图贸然地优化你的代码，你应该先保证代码可读且可理解。

我们的CSS代码基于SAAS，准确来说是SCSS语法。SASS是很强大的，同时也是很糟糕的。使用任何强大的工具，都会带来一个风险：软件工程师总是会做一件他们_非常_擅长的事：过度开发。

“你能做不意味着你应该做”用在SASS上非常合适。我见到过一些非常复杂的SASS函数生成一大串非常疯狂的，巧妙的CSS代码。其中的危险在于：很多人根本不关注生成的代码。生成的代码是非常重要的，特别是代码量和代码的特殊性。同时，使用巧妙的语法或者选择器嵌套（类似[《父选择器前缀 - Parent Selector Suffix》](http://thesassway.com/news/sass-3-3-released#parent-selector-suffixes)）会使代码变得简洁，但会使代码在代码库中非常难以搜索。

    /* 尽量避免 */
    .component {
        &-parentSelectorSuffix { ... } /* .component-parentSelectorSuffix {} */

        .component-childSelector { ... } /* .component .component-childSelector {} */

        .notSoObviousParentSelector & { ... } /* .notSoObviousParentSelector .component {} */
    }

不要过分聪明，做一个好公民，与他人好好合作。使用那些巧妙的方法甚至会使我难以找到你的代码。让代码更简单一些，让预处理器去做那些巧妙地事情，我一定会感谢你的。

> 简化复杂的组件名称

不可否认，这是在合并HTML和CSS样式组件时最重要的事。BEM，SUITCSS，SMACSS等命名规范都是保持你代码模块化的非常方便的工具，但是过分遵从这些“规范”会在处理一些深层嵌套的子元素时产生一下非常长非常复杂的类名。

尽早抽象一些常用的子样式来防止产生像这样的可怕的选择器：

    .componentName__childName__otherChildName__thisIsSillyNow__nopeYouTotallyMissedThePointOfThis--modifier {
        …
    }

> 使用mixin（混合）构建你的组件以输出可定义的CSS

这是一个很有趣的点。我们作为一个团队，以一种特定的方式编写样式，公共标记和CSS规则来在UI中显示某一种数据。我们的框架不会默认输出CSS，你必须选择你想要的组件。

同时，我们的框架服务多个不同的域名。这其中的数据可能是一样的，样式可能也是非常相似的，但因为某种原因，我们选择的通用样式命名却不适用。也许我们的“card”组件在你域名的代码库下叫做"product"更加合适。所以我们构建的所有组件都是一个mixin，包装在一个通用的类名内。

    /* 以media对象作为例子 */
    .media {
        @include media;
    }

    .mediaTable {
        @include media("table");
    }

因为你可以自定义生成的CSS代码，你就可以自由地重命名你选择的组件，引用mixin，并且依然遵循设计样式。

## 一些需要强调的规则

我会强调一些我们认为对于一个好的代码库很重要的规则。

#### 特殊性 [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#specificity)

尽量使用具有低特殊性的选择器。这会帮助你把组件抽象成小块，并更容易重用和重混合样式。同时，这能防止你的代码在将来产生很多特殊性冲突。

    /* 避免使用ID */
    #component { … }

    /* 避免使用子标签 */
    .component h2 { … }

    /* 避免使用有条件的标签选择器 */
    div.component { … }

    /* 避免使用过于具体的选择器 */
    ul.component li span a:hover { … }  

#### 关于声明属性值 [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#when-declaring-values)

在构建一个大的样式代码库时，试图只定义那些你明确关注的属性，以防止过度重置你想要继承的属性。

*   使用 `background-color: #333;` 而不是 `background: #333`
*   使用 `margin-top: 10px;` 而不是 `margin: 10px 0 0;`

举例来说，在使用background的一个简略写法时，你将会重设`background-position`, `background-image`, `background-size`等你不想设的属性。

#### 声明顺序 [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#declaration-order)

首先使用`@extend`，然后使用`@include`，最后设置你的属性。理论上来说，extend和include不需要覆盖你的属性。同时，根据我的习惯，我总是按照**字母顺序**排列属性。

不同的人喜欢不同的方式来组合他们的CSS属性，每当有新人加入时，不要强迫他们学习你的观点或者是“逻辑”。属性的顺序事实上并不重要。考虑到常识和可预测性，大多数人都知道字母表，并且按字母顺序排序可以让你更快找到重复定义。

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

#### 嵌套 [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#nesting)

不要使用，或者至少是尽量少用。

你编译好的代码很容易被遗忘。当你在SASS中使用嵌套来构造选择器时，你会很容易破坏[特殊性](https://github.com/bigcommerce/sass-style-guide#specificity)和[性能](https://github.com/bigcommerce/sass-style-guide#performance)指导原则。你能做不意味着你应该做。我们最多只使用1层嵌套。

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

Abstract the name of your variables. Don't name your variables, for example, the name of the colour you are setting. This is no longer a variable, and is no different to finding and replacing a hex colour code in your codebase, if you decide to change the value of `$background-color-blue`, to be red.
抽象你的函数名称。不要使用你设置的颜色等来命名你的变量。使用颜色命名的变量不再是一个变量了，并且当你想把变量`$background-color-blue`的值改成red的时候，使用这样的变量与查找和替换一个十六进制颜色码没有区别了。

*   `$color-brandPrimary` over `$bigcommerceBlue`

#### 映射以及映射函数 [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#component--micro-app-level-variables)

正如Erskine设计文章[《SASS映射中更友好的颜色名称 - Friendlier colour names with SASS maps》](http://erskinedesign.com/blog/friendlier-colour-names-sass-maps/)中所描述的，我们使用SASS映射来完成大量全局样式属性，不仅仅是颜色这种我们开发者经常需要用到的属性。

SASS为映射提供了一个简单且可预测的API，并且可以用于大量属性类似z-index，font-weight和line-height。我们会在将来的一篇博客中更详细讲述这个主题。

    color: color("grey", "darker");  
    font-size: fontSize("largest");  
    line-height: lineHeight("smaller");  
    z-index: zIndex("highest");  

#### 组件命名规则 [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#components)

我们深受[SuitCSS](http://suitcss.github.io/)的启发，并且将其规则稍稍改动以符合我们的口味和需求。比如说，我们使用驼峰命名法替代Pascal命名法。

正如我之前提到的，正确命名你的继承是非常重要的，我们使用了一些相当实用的方法。一个元素是你组件根的继承的继承，不意味着它在DOM中_必须_处在那个层级，它可以在与第一个继承相邻的位置完成相同的功能。

    <article>  
      <header>
        <img src="{$src}" alt="{$alt}">
        ...
      </header>
      <div>
        ...
      </div>
    </article>  

当我们处理一些复数的东西时，也许单数形式的继承名字会更合适，并且最好不要附加父亲的名字。

    <ul>  
      <li>
        <a href="#"></a>
      </li>
    </ul>  

最好在保留必要内容的情况下尽量精简来避免冗长的类名。

#### 工具和执行

正如我之前提到的，我们新的CSS代码库是基于SASS的，并且像其他的酷小孩一样使用[libSass](http://sass-lang.com/libsass)来编译我们的样式表。其实还存在一些项目使用Ruby Sass，但是其性能的下降是非常显而易见的。

我也提到了让你的编译器来做一些巧妙的事情。其中一个例子就是浏览器引擎前缀（Vendor Prefixes）。我们在SASS处理完成后使用Autoprefixer来自动添加浏览器引擎前缀，而不是使用不同浏览器专用的实现，或是让SASS做一些额外的事情来扰乱我们的代码。

#### 优化

关于输出优化，我们在每次部署核心CSS库的时候使用[CSSO](http://css.github.io/csso/)来优化我们的代码。CSSO会做一些常见的操作如通过删除空白符来压缩文件等，但是CSSO也会对我们的代码进行一些结构优化：从不同的组件中将相似的选择器分组，缩减语法，并除去由于我们使用更多“常识”和“清晰高于精巧”原则所带来的一些影响。我知道这听起来有些风险，但是到目前为止我们都没有发现任何问题并且CSSO一直都运作良好。

我知道你们中的一些人会在阅读指南的时候惊讶于我们一些规则引入的“重复代码”。然而CSSO帮助我们处理这些问题，并且我们依赖Gzip来移除可能剩下的重复代码片段。这使得我们的代码库可读，清晰并且容易理解。让工具来帮你做事。

#### Linting

Lastly, how do you check your fellow team members are adhering to the rules? A good Pull Request policy will help most of the time, but on large teams that's not exactly scalable from a small CSS team.

We make use of [scss-lint](https://github.com/brigade/scss-lint) to analyse our code as we write it, and upon creating a pull request to the core libraries (just in case you thought you could just sneak that CSS in without spinning any of it up in a browser). If it fails to adhere to the styleguide, your code doesn't build on your machine, travis fails and your PR is marked as so. Helpfully we include the [YAML file for our rule set](https://github.com/bigcommerce/sass-style-guide/blob/master/.scss-lint.yml) which seems to get us really close to the style guide, so anyone can follow it. This configuration is also stored in our common grunt tasks that every new Front End project starts with, so you get CSS code linting out of the box.

## What actually happened

Despite our best efforts, it's still really difficult to enforce these ideas over a wide team. The tools only get you so far and you can still contribute CSS that is functional but doesn't make the grade.

We found education and coaching worked best, coupled with the tools and guidelines as reference. I particularly found that in many cases you really have to learn from your own mistakes with CSS before it really "clicks". Writing functional CSS that "just does the job" is extremely easy to do. Learning to spot how that will play in a wider eco-system and predict what side effects it might cause in the future, takes some time.

On the plus side, distributing our linting rules as part of our grunt plugin package was extremely handy to gain adoption and people generally found it extremely useful. The conventions we put in place for our map based properties like fonts, sizes, spacing, line heights and z-indexes were certainly a highlight for our JavaScript Engineers, as it was completely predictable and easy to remember.

CSS in large teams on a large codebase is hard but you can make it suck less by implementing a few guidelines, tools and training sessions to help your teammates stay on the same page. Overall I think we've done a pretty good job so far.

Now, to preempt another one of those "But what about X which solves that better" moments I know you're having right now, I'd like to quickly acknowledge some of the great work people have been doing around this exact topic with regards to "[CSS in JavaScript](https://github.com/MicheleBertoli/css-in-js)" "[Inline CSS](https://speakerdeck.com/vjeux/react-css-in-js)" or the particularly awesome "[CSS Modules](http://glenmaddern.com/articles/css-modules)". These deal with legit problems, I'm not going to rubbish them whilst protecting the "old guard" way of doing CSS, though there are a few reasons why we haven't gone down this path. Some things we can't deal with. Some things we actually really like about CSS like media queries. Most of these ideas come from the React eco-system which we don't use. Most come from the fortunate place where the majority of your front-end is already in JavaScript, and ours certainly isn't. The chances are your codebase is newer than ours, significantly smaller or you've got more money and developers than sense. We envy you. It doesn't mean we or you are wrong.

#### Summary

So that is our approach. Aimed for our environment, our eco-system and a place where (I imagine) a lot of other teams who aren't Facebook or live in a super ideal world, would find themselves in.

I hope it'll help you, because with the combination of a well reasoned, pragmatic code style guide that's fairly easy for people to understand, coupled with post processing tools and code linting, we are able to find a relatively happy place in terms of a large CSS codebase.

It's obviously not bullet proof, especially on it's own, and we'll be following up on this post with a few articles around "How we CSS" and how we make things "less terrible". We'll be tackling:

*   Our CSS framework, Citadel, and how it helps us reduce and share code between completely different domain teams.
*   Responsive and Scalable design patterns for building components that proportionally scale with browser size.
*   Creating a simple developer API for dealing with common properties and sensible, predictable values for developer happiness.
*   Creating a living Pattern-Lab for your organisation
*   Techniques to deal with an enterprise scale design pattern library with the aim of creating consistency and reducing mutations and snowflakes.

