* 原文链接 : [How we "CSS" at BigCommerce](http://www.bigeng.io/how-we-css-at-bigcommerce/)
* 原文作者 : [Simon Taggart](http://www.bigeng.io/author/simon-taggart/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [shenxn](https://github.com/shenxn)
* 校对者: 
* 状态 : 

TL;DR [Our SASS Style Guide is available on GitHub](https://github.com/bigcommerce/sass-style-guide)

CSS很难，而写出好的CSS代码更难。在一个大团队中，基于巨大的基本代码写出好的CSS代码，更是难上加难。

我们不是一个特殊的软件公司：120个工程师，4间办公室，3个不同国家，3个时区，以及7年时间，代表着一个我们都很熟悉的代码库环境。每个人都一直在尝试，代码库中也许有30种不同的按钮风格，4个不同的“品牌色彩”变量，以及一个列举了互联网上所有JavaScript包的 package.json / bower.json 文件。CSS与其他语言相比，看起来就像是一个被忽视的孩子，没有得到应有的照顾。CSS没有固定的规范，没有约定，也没有內建工具来防止你写出自己的代码风格。CSS就是一个雷区，我们都在这个雷区里面，许许多多其他人和团队也会持续不断地陷入其中。

在BC，我们认为至少可以通过设置一些基本规范，并且让每一个编写CSS的人遵循它们，来解决一些在编写大量CSS代码时经常会遇到的问题。我们的《SAAS风格指南》并没有什么突破性的内容，并且其中的观点很像AirBnB的 [《JavaScript风格指南 - JavaScript Style Guide》](https://github.com/airbnb/javascript)。我不会把那篇文章原封不动地复制到我的博客里，但是你可以[在GitHub上找到](https://github.com/bigcommerce/sass-style-guide)。然而我认为，详细解释一些具体规则并且列出我们使用的工具会更加有帮助。


## 目标

首先，我们不是想要变得更巧妙或者进行很好的优化。我们遵循一个开放策略：合理性高于优化，清晰高于精巧。我们的目标是让我们的代码库更容易在一个大型团队中交流与共享。你会注意到在整篇文档中出现了许多类似“可读且可理解的”，“简单的”，“在包含必要内容的前提下尽量精简”，以及“你能做不意味着你应该做”等语句，告诉我们一些关于编写CSS的常识。

## 原则

我们的CSS代码基于一些关于CSS和组件的指导性原则。我会提到其中很重要的，或者是不那么显而易见的点：

> 不要试图贸然地优化你的代码，你应该先保证代码可读且可理解。

我们的CSS代码基于SAAS，准确来说是SCSS语法。SASS是很强大的，同时也是很糟糕的。使用任何强大的工具，都会带来一个风险：软件工程师总是会做一件他们_非常_擅长的事：过度开发。

“你能做不意味着你应该做”用在SASS上非常合适。我见到过一些非常复杂的SASS函数生成一大串非常疯狂的，巧妙的CSS代码。其中的危险在于：很多人根本不关注生成的代码。生成的代码是非常重要的，特别是代码量和代码的明确性。同时，使用巧妙的语法或者选择器构造（类似[《父选择器前缀 - Parent Selector Suffix》](http://thesassway.com/news/sass-3-3-released#parent-selector-suffixes)）会使代码变得简洁，但会使代码在代码库中非常难以搜索。

    /* 尽量避免 */
    .component {
        &-parentSelectorSuffix { ... } /* .component-parentSelectorSuffix {} */

        .component-childSelector { ... } /* .component .component-childSelector {} */

        .notSoObviousParentSelector & { ... } /* .notSoObviousParentSelector .component {} */
    }

不要过分聪明，做一个好公民，与他人好好合作。使用那些巧妙的方法甚至会使我难以找到你的代码。让代码更简单一些，让预处理器去做那些巧妙地事情，我一定会感谢你的。

> 简化复杂的组件名称

不可否认，这是在合并HTML和CSS样式组件时最重要的事。BEM，SUITCSS，SMACSS等命名规范都是保持你代码模块化的非常方便的工具，但是过分遵从这些“规范”会在处理一些深层子元素时产生一下非常长非常复杂的类名。

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

#### 明确性 [<small>(链接)</small>](https://github.com/bigcommerce/sass-style-guide#specificity)

Aim for selectors that are as low in specificity as you can humanly make them. It'll help abstract components into smaller chunks, allow for greater re-use and re-mix of patterns, and it'll stop you having a lot of specificity clashes in the future.


    /* Avoid styling IDs */
    #component { … }

    /* Avoid styling descendant elements */
    .component h2 { … }

    /* Avoid element qualified selectors */
    div.component { … }

    /* Avoid overly specific rules */
    ul.component li span a:hover { … }  

#### Declaring Values [<small>(Link)</small>](https://github.com/bigcommerce/sass-style-guide#when-declaring-values)

When building a large codebase of patterns, try to only style the property you are explicitly concerned with to avoid overzealously resetting something you might want to inherit.

*   `background-color: #333;` over `background: #333`
*   `margin-top: 10px;` over `margin: 10px 0 0;`

Declaring a shorthand property of background for example, resets `background-position`, `background-image`, `background-size` etc which you may not want to do. Play nice with others.

#### Declaration Order [<small>(Link)</small>](https://github.com/bigcommerce/sass-style-guide#declaration-order)

`@extend` first, then `@include`, then set your properties. Ideally the extend and include don't have to override or clash with your properties. Followed by my personal favourite rule, **alphabetical order**, always.

There's been a lot of think pieces by lots of different people about all the magical and logical ways people like to group their CSS properties together inside a rule. Don't force people to learn your opinion or "logic" each time a new starter comes onboard. The order _**literally**_ doesn't matter. Aim for common sense, predictability and wide adoption; a lot of people know the alphabet and it'll let you spot repeat declarations easily.

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

#### Nesting [<small>(Link)</small>](https://github.com/bigcommerce/sass-style-guide#nesting)

Don't. Or at least try your damned hardest not to.

The output of your compiled CSS is extremely easy to lose track of. You can easily break [Specificity](https://github.com/bigcommerce/sass-style-guide#specificity) and [Performance](https://github.com/bigcommerce/sass-style-guide#performance) guidelines when creating your selectors when you start nesting with SASS. Just because you can, doesn't mean you should. We aim for a maximum of 1 level deep of nesting, with the use of common sense when that's not achievable.

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

#### Variable Names [<small>(Link)</small>](https://github.com/bigcommerce/sass-style-guide#variables)

Abstract the name of your variables. Don't name your variables, for example, the name of the colour you are setting. This is no longer a variable, and is no different to finding and replacing a hex colour code in your codebase, if you decide to change the value of `$background-color-blue`, to be red.

*   `$color-brandPrimary` over `$bigcommerceBlue`

#### Maps, and Map Functions [<small>(Link)</small>](https://github.com/bigcommerce/sass-style-guide#component--micro-app-level-variables)

As described by the excellent Erskine Design Article, [Friendlier colour names with SASS maps](http://erskinedesign.com/blog/friendlier-colour-names-sass-maps/), we use SASS maps for a lot of global style properties, not just colours, that our developers are going to need frequent access to.

It allows a simple, predictable API for them and a set scale for things like z-index, font-weight and line-height. We'll cover this in much more detail is a coming blog post.

    color: color("grey", "darker");  
    font-size: fontSize("largest");  
    line-height: lineHeight("smaller");  
    z-index: zIndex("highest");  

#### Component Naming Conventions [<small>(Link)</small>](https://github.com/bigcommerce/sass-style-guide#components)

We took pretty heavy influence from [SuitCSS](http://suitcss.github.io/) and slightly modified it to our tastes and needs. For example we opted for camel case instead of pascal case.

As I mentioned earlier, correctly naming your descendant children is pretty important and we take a fairly pragmatic approach. Just because an element is a descendant of a descendant to the root of your component, doesn't mean it _has_ to live at that level in the DOM. It could easily function the same way and be adjacent to the first descendant.

    <article>  
      <header>
        <img src="{$src}" alt="{$alt}">
        ...
      </header>
      <div>
        ...
      </div>
    </article>  

When dealing with plurals of something, perhaps the descendant name is better suited to be the singular version, and not appended to the parent name.

    <ul>  
      <li>
        <a href="#"></a>
      </li>
    </ul>  

It's much better to avoid verbose descendant class names, by keeping class names as short as possible and as long as necessary.

#### Tools and Enforcement

As I've mentioned our new CSS code base is in SASS and of course like all the other cool kids, we use [libSass](http://sass-lang.com/libsass) to compile our stylesheets. There are a couple of projects that use Ruby Sass, and the performance slow down is extremely noticeable.

I also mentioned about doing clever things with your code _**post**_ compilation. An example of this is vendor prefixes for CSS features that may not be fully adopted by certain browsers. Instead of littering our code with these vendor prefixes, proprietary implementations, or making Sass do a bunch of extra grunt work, we use Autoprefixer to do it for us after Sass has done it's job.

#### Optimisation

In terms of output optimisation, we use [CSSO](http://css.github.io/csso/) to optimise our code when we perform a deploy of our core CSS libraries. CSSO does the usual things you'd expect from minification like stripping out all the whitespace, but it also does some structural optimisations on the code for us. Grouping like selectors together from different components, shortening syntax where it can, shaving off small bites that we may introduce in our more "common sense", "clear over clever" approach to writing our code. Sounds risky, I know, but so far we haven't noticed anything breaking and it works really well.

I'm sure some of you will have read along and through the guide and thrown your arms up in dismay at "the repetition of code" we'd introduce with some of our rules. Well CSSO helps us deal with that _after_ the fact, and we can rely heavily on Gzip to remove some of the other repetitive code snippets that might remain. This leaves our code base readable, clear and obvious. Let tools do the work for you.

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

