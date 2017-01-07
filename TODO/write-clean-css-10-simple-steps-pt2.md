> * 原文地址：[How to Write Clean CSS in 10 Simple Steps Pt2](http://blog.alexdevero.com/write-clean-css-10-simple-steps-pt2/)
* 原文作者：[Alex Devero](http://blog.alexdevero.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[肘子涵](https://github.com/zhouzihanntu)、[naivebenson](https://github.com/bensonlove)

# How to Write Clean CSS in 10 Simple Steps Pt2

# 如何书写整洁的 CSS 代码？只需十步！

[![How to Write Clean CSS in 10 Simple Steps Pt2](https://i0.wp.com/blog.alexdevero.com/wp-content/uploads/2016/12/How-to-Write-Clean-CSS-in-10-Simple-Steps-Pt2-small.jpg?resize=697%2C464)](https://i0.wp.com/blog.alexdevero.com/wp-content/uploads/2016/12/How-to-Write-Clean-CSS-in-10-Simple-Steps-Pt2-small.jpg)

你知道如何写出易维护的整洁的 CSS 代码吗？要想写出易读易理解易维护的 CSS 代码，你只需掌握一些简单的方法就够了。今天你将会学习其中五个。我们将会讨论文件结构，混合的 CSS 和 JavaScript 及其劣势，我们还会讨论如何更好地给 CSS 添加前缀以及如何自动执行，最后我们将学习如何处理技术债务。那么，让我们来学习如何写出整洁的 CSS 代码吧！

## 内容列表：

**No.1-5 在**[**第一部分**](https://github.com/xitu/gold-miner/blob/master/TODO/write-clean-css-10-simple-steps-pt1.md)。

**No.6: 整理你的文件结构**

保持文件结构的简洁

如何在单个文件中构建你的 CSS 代码

**No.7: 让 CSS 和 JaceScript 代码分离**

为什么混合的 CSS 和 JavaScript 是大忌？

如何更聪明地使用 CSS 和 JavaScript？

**No.8: 留心供应商的前缀和后备方案**

避免臃肿的 CSS 代码

**No.9: 让供应商更容易维护，自动执行**

**N0.10: 管理你的技术债务**

# No.6: Lay out your file structure

# No.6: 整理你的文件结构

我们在第一部分讨论了模块化的 CSS 代码，在继续下一个方法之前我们应当简洁地讨论一下文件结构。独立来看，模块化 CSS 代码非常有用，然而可能你习惯将所有的 CSS 代码放入单个样式表文件，那么它很快就会变得无法控制。比如说，从一个样式表文件到十个或者二十个文件那就有如天壤之别了。我们来看写下面这个例子，这是 ITCSS 中的文件结构：

例:

    @import "settings.colors";
    @import "settings.global";
    
    @import "tools.mixins";
    @import "normalize-scss/normalize.scss";
    @import "generic.reset";
    @import "generic.box-sizing";
    @import "generic.shared";
    
    @import "elements.headings";
    @import "elements.hr";
    @import "elements.forms";
    @import "elements.links";
    @import "elements.lists";
    @import "elements.page";
    @import "elements.quotes";
    @import "elements.tables";
    
    @import "objects.animations";
    @import "objects.drawer";
    @import "objects.list-bare";
    @import "objects.media";
    @import "objects.layout";
    @import "objects.overlays";
    
    @import "components.404";
    @import "components.about";
    @import "components.archive";
    @import "components.avatars";
    @import "components.blog-post";
    @import "components.buttons";
    @import "components.callout";
    @import "components.clients";
    @import "components.comments";
    @import "components.contact";
    @import "components.cta";
    @import "components.faq";
    @import "components.features";
    @import "components.footer";
    @import "components.forms";
    @import "components.header";
    @import "components.headings";
    @import "components.hero";
    @import "components.jobs";
    @import "components.legal-nav";
    @import "components.main-cta";
    @import "components.main-nav";
    @import "components.newsletter";
    @import "components.page-title";
    @import "components.pagination";
    @import "components.post-teaser";
    @import "components.process";
    @import "components.quote-banner";
    @import "components.offices";
    @import "components.sec-nav";
    @import "components.services";
    @import "components.share-buttons";
    @import "components.social-media";
    @import "components.team";
    @import "components.testimonials";
    @import "components.topbar";
    @import "components.reasons";
    @import "components.wordpress";
    @import "components.work-list";
    @import "components.work-detail";
    
    @import "vendor.prism";
    
    @import "trumps.clearfix";
    @import "trumps.utilities";
    
    @import "healthcheck";

上面的例子中包含了 65(!) 个文件，告诉我，如果这都不算超出了控制！65 个文件即使对网站的设计开发的老鸟来说也已经很多了。如果你是个新手，这看上去简直是疯了！当然，这个例子比较特别，文件的数量和你选取的方法有关。然而，项目伊始你需要记住，你应该提前为项目规划文件结构，而不要等到火烧眉毛了才着急。

## 保持文件结构的简洁

我建议两件事情，第一，保持文件结构简洁，第二，找到有效内容。你没必要非得使用上例中的方法，我相信构造模块化 CSS 的关键之一就是因人而异。不一定非要按部就班，你可以随心所欲地改变方法。另外，你也可以自由地组合使用多个框架，比如：第一部分中，我讲述了我综合使用了 [Atomic design](http://blog.alexdevero.com/atomic-design-scalable-modular-css-sass/) 和 [BEM](http://blog.alexdevero.com/bem-crash-course-for-web-developers/) 和少量的 [SMACSS](https://smacss.com/) 这三种框架。

你也可以和我一样！如果你喜欢框架 A 也喜欢框架 B，不一定非要二选一，你可以取二者之长来使用。这也同样适用于文件结构，你可以想用文件夹就用文件夹，不想用就干脆不用。其实，用文件夹可能会好一点，这样有助于文件管理。然而，用还是不用由你决定，只需要确保你用起来舒服就好。来看一个我在项目中使用过的文件结构的例子：

例:

    // Project imports
    // Import settings
    @import '_settings/config';
    
    // Import tools
    @import '_tools/functions';
    @import '_tools/mixins';
    
    // Import base
    @import '_base/normalize';
    @import '_base/base';
    @import '_base/typography';
    
    // Import atoms
    @import '_atoms/animations';
    @import '_atoms/buttons';
    @import '_atoms/inputs';
    @import '_atoms/inserts';
    @import '_atoms/labels';
    @import '_atoms/links';
    
    // Import molecules
    @import '_molecules/forms';
    @import '_molecules/gallery';
    @import '_molecules/jumbotron';
    @import '_molecules/navigation';
    @import '_molecules/pagination';
    @import '_molecules/parallax';
    @import '_molecules/slider';
    
    // Import organisms
    @import '_organisms/footer';
    @import '_organisms/grid';
    @import '_organisms/header';
    @import '_organisms/sections';
    
    // Import pages
    @import '_pages/404';
    @import '_pages/about';
    @import '_pages/contact';
    @import '_pages/homepage';
    @import '_pages/prices';
    @import '_pages/faq';
    
    // Import templates
    @import '_templates/print';

如你所见，我喜欢使用文件夹使框架中各个层相互独立，我也喜欢保持文件结构相对第一个 ITCSS 的例子更简单一点。要记得，我之所以这样用是因为这很适合我，如果你喜欢其他的方法，那就用其他的方法，如果不喜欢某个方法就不要用。我们的目标是使用有意义的结构避免啰嗦的代码，而代码啰嗦是书写整洁的 CSS 代码的最大的阻碍之一。整洁的 CSS 代码就是 DRY 的 CSS 代码。

## 如何在单个文件中构建你的 CSS 代码

我们要讨论的最后一个问题就是如何在单文件中构建你的 CSS 代码。此时此刻，我们假定你没有使用任何的预处理器，因为事实上你没必要去使用。使用预处理器并不会帮助你写出好的整洁的 CSS 代码。一个知名的现象即，如果你的 CSS 代码很糟糕，预处理器通常只会把它变得更糟糕而不会变更好。因此，如果你决定使用预处理器，首先保证要去加强你的 CSS 技巧。

说一点次要的，组织 CSS 代码最简单的方式就是使用注释，这也是一个良好的实践。我在单个的样式表文件中也会使用注释来组织代码，这样能使编译后的 CSS 代码更具可读性，不然将很难读懂引入内容的开始和结束位置。现在，我通常在工作流中使用两种注释，实际上我用了三种注释，但是第三种注释只在 Sass 中才使用，并且那也不会编译成 CSS 代码。

这两种注释即单行和多行注释。我是用多行注释来标注每一个引入内容，换句话说，我使用这种注释作为每个引入文件的开始。然后，当我想要标明某项内容的开头，我会使用单行注释。那么第三种源于 Sass 的注释呢？我会在说明一些小事或者未完成的内容时候才会使用。这种注释只在开发环境中才有价值，没必要写入生产环境。

例 1:

    /**
     * Section heading
     */
    
     /* Sub-section heading */

重申一下，你没必要非要使用相同样式的注释。注释有很多种，让我用几个实例来给你的想象力加满油。

例 2:

    /*
     * === SECTION HEADING ===
     */
    
    /*
     * — Sub-section Heading —
     */

例 3:

    /* ==========================================================================
    SECTION HEADING
    ========================================================================== */
    
    /**
    * Sub-section Heading
    */

例 4:

    /***************************
    ****************************
    Section heading
    ****************************
    ***************************/
    
    /***************************
    Sub-section heading
    ***************************/

# No.7: 让 CSS 和 JaceScript 代码分离

模块化的 CSS 代码和有意义的使用注释能够很好的维护整洁的 CSS 代码。然而，如果你到处写 CSS 代码，这些方法一个也不会生效。什么意思？网站设计者经常在 JavaScript 代码中定义 CSS 样式，我认为这在使用 jQuery 或者其他 JacaScript 库的开发者中更为普遍。使用 jQuery 来改变 CSS 样式比使用 vanilla JavaScript 更简单迅速，然而，这并不意味着那就是好事。

## 为什么混合的 CSS 和 JavaScript 是大忌？

混合的 CSS 和 JavaScript 的问题就是很容易被忽视。这和在一个或多个 CSS 样式表文件中维护整洁的 CSS 代码不同，当添加了 JavaScript 文件，你会把自己的工作变得更困难，如果你也使用了 JavaScript 的预处理器，你简直是在自讨苦吃。那么是不是应该不顾代价地避免杂糅的 CSS 和 JacaScript 代码呢？也许不必，如果你只需要做一两次很小的改动。

当你想要改动某个属性一两次的时候，可以选择 JavaScript，但是，我不建议你使用这种方法修改或设置一堆的属性值或者反复地修改样式。如果那样做，你将不得不重复写这些代码，其结果是你不会再有 DRY 的代码，更不要说是整洁的 CSS 代码了。当然，你可以使用函数来实现。但是，你需要考虑一件事情，有些设备可能会造成 JavaScript 代码阻塞。

尽管我们生活在一个技术迭代迅速的时代，但是 JavaScript 并不是我们可以百分之百依赖的东西。想象一下其他很蠢或者很自大的事情，很可能会有不用 JavaScript 的人来访问你的网站。如果你的一些样式依赖于 JavaScript，它们将不会生效。因此，即使你不太关心代码的组织，混合的 CSS 和 JavaScript 也不是一个好的方法。

## 如何更聪明地使用 CSS 和 JavaScript？

那么，问题来了，你有什么其他办法能够动态地改变 CSS 样式并且维护整洁的 CSS 代码呢？从在你的 CSS 样式表文件中定义新的类开始，之后，根据需要使用 JavaScript 来给特定的元素添加或者删除类属性，这样你就可以实现了。你就不用非得在 JavaScript 中写好多遍 CSS 代码了，也不用使用任何的函数来实现。还有个问题就是，这不能帮你解决 JavaScript 阻塞或者失效的问题。

这个问题的解决办法取决于你当前的情况，你可以创建一个后备方案，假如不支持 JavaScript 该方案就会生效，而支持 JavaScript 的时候，你再将后备方案中的类去掉，之后就不再使用这些样式了。特征检测库 [Modernizr](https://modernizr.com/) 工作原理与之类似，我们曾经讨论过如何利用 Modernizr 实现特征检测和渐进增长，请戳[这里](http://blog.alexdevero.com/html5-css3-feature-detection-modernizr/)。有点跑题了。

那么来概括一下，为了书写整洁的 CSS 代码，我建议保持 CSS 和 JavaScript 代码的分离。如果你需要动态改变样式，使用 CSS 中的类。不要直接在 JavaScript 中改变样式。在你做出了微小的改变或者仅仅改变了目标内容一次，都可能会引发异常。并且如果你在为无 JavaScript 情况下写后备方案的时候遇到了任何问题，都可以告诉我。

# No.8: 留心供应商的前缀和后备方案

第八个书写整洁的 CSS 代码的方法是只使用有意义的代码，这意味着你应该经常检查你的 CSS 代码并且移除老旧的供应商前缀和后备方案。我是使用 CSS 和 JavaScript 最新特性的忠实拥趸，是的，我喜欢去体验那些或多或少有着试验意味的技术。我认为网站设计和开发者应该有勇气使用这些技术，并且不光是在开发环境中，也要在生产环境中使用。

然而，这也要求在网站开发过程中学习更多合理的方法。你需要选择你的网站支持哪些浏览器，仅仅支持最新版本的浏览器是不行的，你必须确保网站在很多种浏览器上都可用。比如，我通常会专注于 IE11+、Google Chrome 49+、Firefox 49+ 和 Safari 9+ 浏览器，我会在这些浏览器上测试项目并使用必要的前缀和后备方案。

这仅仅是过程中的一部分，还有一个就是改变浏览器的用法并实现一些新的功能的时候重新访问网站。当一些浏览器淡出视野之后，你应该移除为那些浏览器而写的前缀和后备方案。如果想维护整洁的 CSS 代码，你应当定期这样做，否则你的 CSS 代码将会变得臃肿，将会充斥着并不需要的代码，而浏览器在实现功能的时候会忽视这些前缀。

## 避免臃肿的 CSS 代码

不幸的是，这些前缀还在你的 CSS 代码里，并且它们使得 CSS 代码比实际更多了。对于小的项目来说，这并不是什么问题，但是如果你在一个体量庞大的项目中使用 CSS 代码，这些前缀会给样式表增加许多 kB 的大小。就性能而言，每个 kB 都锱铢必较。另外，越来越多的人使用移动设备来访问网站，并且不是所有人都在使用高速的网络连接。

有个自相矛盾观点，这些设备经常运行需要所有前缀内容的浏览器，但是设备的网络状态却差到每个 kB 都举足轻重，最后，用户变得越来越没有耐心。结论是什么？你应该在开发过程中做到重复访问过时的前缀和后备方案并且移除它们。这样，你就能维护整洁的 CSS 代码，你的网站也能获得很高的性能。你可以点击[这里](http://blog.alexdevero.com/website-maintenance-web-designers-pt1/)来查看更多网站维护的内容。

# No.9: 让供应商更容易维护，自动执行

移除老旧的前缀对维护整洁的 CSS 代码是非常重要的，然而，要实现这个目的也是痛苦的。谁会愿意每两个月就检查一下代码并且手动移除过时的代码呢？估计没有人会愿意。幸运的是，已经有更好的替代方案啦，我们可以将这项任务“外包”出去。有两种方法，第一个选择就是使用任务运行工具比如 [Gulp](http://gulpjs.com/)、[Grunt](http://gruntjs.com/) 或者 [Webpack](https://webpack.github.io/)。

这些任务运行工具允许你使用类似于 [autoprefixer](https://www.npmjs.com/package/autoprefixer) 的插件，多亏了这个插件你才可以外包这些任务。当你在使用这个插件开展任务时，它只在必要的时候才添加前缀，它还可以检查样式表文件并移除过时的前缀。你只需运行任务即可。第二个选择是使用名为 [prefix-free](https://leaverou.github.io/prefixfree/) 的小工具，它和 autoprefixer 还是有点点区别的。

如我们所谈到的，autoprefixer 和任务运行工具一同工作，比如后处理器。当你想要使用 prefix-free 时，你需要在页面的头部或者尾部将其引入，它将会在网站加载的时候运行并添加必要的前缀。有什么负面影响吗？又多了一个外部资源并且增加了带宽。如果用户遇到了 JavaScript 代码阻塞或者失效呢？然而，这总强过不添加前缀的情况吧，这也比学习使用任务运行工具要简单多了。

想征求我的建议？因人而异！短期来看并且作为一个快速修复的方法，prefix-free 会是更好的选择。然而，我建议额外花费一些时间去学习使用任务运行工具，这会让你学有所得。任务运行工具能够让你的生活变得简单让你的工作变得快捷。我最爱 Gulp了，你可以在 [Gulp for Web Designers](http://blog.alexdevero.com/gulp-web-designers-want-know/) 这篇文章中学者去使用它。

# N0.10: 管理你的技术债务

我们来谈谈维护整洁的 CSS 代码的最后一个方法吧。你曾经听过所谓的技术债务吗？每一次你利用黑客技术将一些东西组合在一起来解决问题时，技术债务就发生了。当你使用容易实现的代码替代最全面的解决方案时，技术债务就增加了。它通常出现在一些需要快速移动和传输的项目中，换句话说，在初创公司中很常见。

技术债务的问题不在于你创造了它，而在于很多时候你根本没有那么多时间去完美地解决它，有时候，为了立马实现你不得不适用非常差劲的方案。比如：假使你或者其他人发现了你的网站或者产品上的一个大问题，并且网站或者产品已经上线了。然后，你需要迅速修复，否则你就会失去客户，结果就会造成技术债务。

如我所言，问题不是创造了技术债务，真正的问题是忘记有这个东西。当你创造了技术债务，你应该只把它作为临时的解决方案，当时间富裕了你应该回过头来用更好的方法替换掉快速修复的方法。从长远上来看，你将能够维护整洁的 CSS 代码。不幸的是，我无法准确告诉你如何减少技术债务，解决方法取决于当时的情况。但是，我可以给你三条建议。

第一，利用某种方式积累工作，每次你使用小巧的解决方案的时候都要新建一个任务，好记性不如烂笔头。第二，花费部分时间来重新查看这些工作，并逐个解决。不要让技术债务和任务的熟练变得太大，否则将无法控制，你将无从下手。第三，定期重构你的 CSS 代码。通过保持代码 [DRY](http://csswizardry.com/2013/07/writing-dryer-vanilla-css/) 来维护整洁的 CSS 代码。减少重复的代码，写一次然后重复使用。

## 写在文末

恭喜，你已经读完了第二部分，同时也读完了这个迷你系列的文章！我希望谈论的这十条建议能够帮助你写出整洁的 CSS 代码，也希望你能够长期维护好它。我来告诉你一个秘密，书写整洁的 CSS 代码根本没什么困难，难的是你能够一直保持 CSS 代码的整洁。如果不只你一个人在写 CSS 代码，那将变得更困难。但是，只要怀着这种目的去写 CSS 代码，事情就会变得简单了。