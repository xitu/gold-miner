> * 原文地址：[How to Write Clean CSS in 10 Simple Steps Pt2](http://blog.alexdevero.com/write-clean-css-10-simple-steps-pt2/)
* 原文作者：[Alex Devero](http://blog.alexdevero.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[肘子涵](https://github.com/zhouzihanntu)、[naivebenson](https://github.com/bensonlove)

# 如何书写整洁的 CSS 代码？只需十步！

[![How to Write Clean CSS in 10 Simple Steps Pt2](https://i0.wp.com/blog.alexdevero.com/wp-content/uploads/2016/12/How-to-Write-Clean-CSS-in-10-Simple-Steps-Pt2-small.jpg?resize=697%2C464)](https://i0.wp.com/blog.alexdevero.com/wp-content/uploads/2016/12/How-to-Write-Clean-CSS-in-10-Simple-Steps-Pt2-small.jpg)

你知道如何写出易维护的整洁的 CSS 代码吗？要想写出易读易理解易维护的 CSS 代码，你只需掌握一些简单的方法就够了！今天你将会学习其中五个，我们将会讨论文件结构，混合的 CSS 和 JavaScript 及其劣势，还有如何更好地给 CSS 添加前缀以及自动执行，最后我们将学习如何处理技术债务。那么，让我们来学习如何写出整洁的 CSS 代码吧！

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

# No.6: 整理你的文件结构

我们在第一部分讨论了模块化的 CSS 代码，在继续学习下一个方法之前，我们应当简单地讨论一下文件结构。从自身出发，模块化 CSS 代码非常有用，然而可能你习惯将所有的 CSS 代码放入一个样式表文件，那么它很快就会变得无法控制。比如说，从单个样式表文件到十个或者二十个文件那就有如天壤之别了。我们来看写下面这个例子，这是 ITCSS 中的文件结构：

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

上面的例子中包含了 65(!) 个文件，如果这都不算超出了控制，告诉我什么才是！65 个文件，即使对网站的设计开发的老鸟来说也已经非常多了。如果你是个新手，这看上去简直是疯了！当然，这个例子比较特别，文件的数量和你选取的方法有关。然而，项目伊始你需要记住，你应该提前为项目规划文件结构，而不要等到火烧眉毛了才着急。

## 保持文件结构的简洁

我建议两件事情，第一，保持文件结构简洁，第二，找到有效内容。你没必要非得使用上例中的方法，我相信构造模块化 CSS 的关键之一就是因人而异。不一定非要按部就班，你可以随心所欲地改变方法。另外，你也可以自由地组合使用多个框架，比如：第一部分中讲述了我综合使用了 [Atomic design](http://blog.alexdevero.com/atomic-design-scalable-modular-css-sass/) 和 [BEM](http://blog.alexdevero.com/bem-crash-course-for-web-developers/) 和少量的 [SMACSS](https://smacss.com/) 这三种框架的例子。

你也可以和我一样！如果你喜欢框架 A 也喜欢框架 B，不一定非要二选一，你可以取二者之长来使用。这也同样适用于文件结构，你可以想用文件夹就用文件夹，不想用就干脆不用。其实，用文件夹可能会好一点，这样有助于文件管理。然而，用还是不用由你决定，只需要保证你用起来舒服就好。来看一个例子，这是我在某个项目中使用的文件结构：

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

如你所见，我喜欢使用文件夹使框架中各个层相互独立，我也喜欢让文件结构相对第一个 ITCSS 的例子保持简单。要记得，我之所以这样用是因为这很适合我，如果你喜欢其他的方法，那就用其他的方法，如果不喜欢某个方法就不要用。我们的目标是使用有意义的结构避免啰嗦的代码，而代码啰嗦是书写整洁的 CSS 代码最大的阻碍之一。整洁的 CSS 代码就是 DRY CSS。

## 如何在单个文件中构建你的 CSS 代码

我们要讨论的最后一个问题就是如何在单个文件中构建你的 CSS 代码结构。此时此刻，我们假定你没有使用任何的预处理器，因为事实上你没必要去用它。使用预处理器并不会帮你写出好的整洁的 CSS 代码。这种情况非常流行，如果你的 CSS 代码很糟糕，预处理器通常只会雪上加霜而不是雪中送炭。因此，如果你决定使用预处理器，首先保证提高你的 CSS 编码技巧。

说一点次要的，组织 CSS 代码最简单的方式就是使用注释，这也是一个良好的实践。我在单个样式表文件中也会使用注释来组织代码，这样能使编译后的 CSS 代码更具可读性，不然将很难读懂引入内容的开始和结束位置。现在，我通常在工作流中使用两种注释，实际上我用了三种注释，但是第三种注释只在 Sass 中才使用，并且也不会将其编译成 CSS 代码。

这两种注释即单行和多行注释。我用多行注释来标注每一个引入的内容，换句话说，我使用这种注释作为每个引入文件的开始。然后，我会使用单行注释来标明某项内容的开始位置。那么第三种源于 Sass 的注释呢？我会用它记录一些琐事或者未完成的内容，这种注释只在开发中才有用，没必要写入生产环境。

例 1:

    /**
     * Section heading
     */
    
     /* Sub-section heading */

重申一下，你没必要使用相同样式的注释。注释有很多种，让我用几个实例来给你的想象力充满电。

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

模块化的 CSS 代码和有效地使用注释能够很好地维护整洁的 CSS 代码。然而，如果你到处写 CSS 代码，这些方法一个也不会生效。什么意思？网站设计者经常在 JavaScript 代码中定义 CSS 样式，我认为这在使用 jQuery 或者其他 JacaScript 库的开发者中更为普遍。使用 jQuery 来改变 CSS 样式比使用 vanilla JavaScript 更简单迅速，然而，这并不意味着那是好事。

## 为什么混合的 CSS 和 JavaScript 是大忌？

混合的 CSS 和 JavaScript 代码的问题就是很容易被忽视。这和在若干个样式表中维护整洁的 CSS 代码不同，当添加了 JavaScript 文件，你只会给自己的工作添堵。如果你使用了 JavaScript 预处理器，那简直是在自讨苦吃。那么是不是应该不顾代价地避免杂糅的 CSS 和 JacaScript 代码呢？也许不必，如果你只需改动一两次或者改动很小，杂糅也没关系。

当你想要改动一两次某个属性时候，可以选择 JavaScript，但是我不建议你使用这种方法，也不建议修改很多的属性或者反复地修改内容。如果那样做，你将不得不重复写这些代码，其结果是你不会再有 DRY CSS，更不要说是整洁的 CSS 代码了。当然，你可以使用函数来实现，但是你需要兼顾有些设备可能会造成 JavaScript 代码阻塞的情况。

尽管生活在一个技术迭代迅速的时代，但是我们并不能百分百地依赖 JavaScript。想象一下其他很蠢或者自我感觉良好的事情，很可能有不用 JavaScript 的人访问你的网站。如果你的一些样式依赖于 JavaScript，它们将不会生效。因此，即使你不太关心代码的组织结构，写混合的 CSS 和 JavaScript 代码也不是一个好的方法。

## 如何更聪明地使用 CSS 和 JavaScript？

那么，问题来了，你有什么其他办法能够动态地改变 CSS 样式并且维护整洁的 CSS 代码呢？从在你的 CSS 样式表文件中定义新的类开始，之后根据需要使用 JavaScript 来给特定的元素添加或者删除类，这样你就可达到目的。你就没必要在 JavaScript 中写好多遍 CSS 代码了，也不用使用任何的函数来实现。但是仍存在一个问题，这不能帮你解决 JavaScript 阻塞或者失效的问题。

JavaScript 阻塞或者失效问题的解决办法依当时情况而定。但你可以创建一个后备方案，设备不支持 JavaScript 时该方案就会生效，支持 JavaScript 的时候，你再去掉后备方案中的类，并不再使用。特征检测库 [Modernizr](https://modernizr.com/) 工作原理与之类似，我曾经讨论过如何利用 Modernizr 实现特征检测和渐进式增长，请戳[这里](http://blog.alexdevero.com/html5-css3-feature-detection-modernizr/)。有点跑题了。

那么来概括一下，为了书写整洁的 CSS 代码，我建议保持 CSS 和 JavaScript 代码分离。如果你需要动态改变样式，请使用 CSS 中的类，不要直接在 JavaScript 中改变样式。因为哪怕你的改变很微小或者仅仅改动了一次，都可能会引发异常。如果你在为无 JavaScript 的情况写后备方案的时候遇到了任何问题，都可以跟我说。

# No.8: 留心供应商的前缀和后备方案

第八个书写整洁的 CSS 代码的方法是只使用有用的代码，这意味着你应该经常检查你的 CSS 代码并且移除老旧的供应商前缀和后备方案。我是使用 CSS 和 JavaScript 最新特性的忠实拥趸，是的，我喜欢去体验那些或多或少有着试验意味的技术。我认为网站设计和开发者都应该有勇气使用这些技术，并且不光是在开发环境中，也要在生产环境中使用。

然而，这也要求你在网站开发过程中学习更多合理的方法。你需要选择你的网站支持哪些浏览器，光是支持最新版的浏览器是不行的，你必须确保网站在很多浏览器上都可用。比如，我通常比较注重 IE11+、Google Chrome 49+、Firefox 49+ 和 Safari 9+ 浏览器的使用情况，我会在这些浏览器上测试项目并使用必要的前缀和后备方案。

这仅仅是过程中的一部分，还有一个就是在改变浏览器的用法并实现了一些新功能的时候重新访问网站。当一些浏览器淡出用户视野之后，你应该移除为其而写的前缀和后备方案。如果想维护整洁的 CSS 代码，你应该定期这样做，否则你的 CSS 代码将会变得臃肿，将会充斥着没用的代码，并且浏览器在实现的同时会忽视这些前缀内容。

## 避免臃肿的 CSS 代码

不幸的是，这些前缀还存在你的 CSS 代码里，并造成了比实际需要更多的代码。对小项目来说，这并不是问题，但如果你在一个体量庞大的项目中使用 CSS 代码，这些前缀会给样式表增加许多 kB。就性能而言，每个 kB 都锱铢必较。另外，越来越多的人在使用移动设备访问网站，并不是所有人的网速都很快。

矛盾的是，有些设备经常运行的浏览器需要所有的前缀内容，但是其网络状态却差到每个 kB 都举足轻重。于是，用户变得越来越没有耐心。我们学到了什么？你应该在开发过程中做到重复访问过时的前缀和后备方案并移除它们。这样，你就能维护整洁的 CSS 代码，网站也能获得很高的性能。你可以点击[这里](http://blog.alexdevero.com/website-maintenance-web-designers-pt1/)来查看更多网站维护的内容。

# No.9: 让供应商更容易维护，自动执行

移除老旧的前缀对维护整洁的 CSS 代码是非常重要的，然而，要实现这个目的也是很痛苦的。谁会愿意每两个月就检查一遍代码并且手动移除过时的代码呢？估计没人愿意。幸运的是，已经有更好的替代方案啦，我们可以将这项任务“外包”出去。

有两种方法，第一个选择就是使用任务运行工具比如 [Gulp](http://gulpjs.com/)、[Grunt](http://gruntjs.com/) 或者 [Webpack](https://webpack.github.io/)。这些任务运行工具可以使用类似于 [autoprefixer](https://www.npmjs.com/package/autoprefixer) 的插件，多亏了这个插件你才可以外包这些任务。当你在使用这个插件开展任务时，它只在必要的时候才添加前缀，它还可以检查样式表文件并移除过时的前缀。你只需运行任务即可。

第二个选择是使用名为 [prefix-free](https://leaverou.github.io/prefixfree/) 的小工具，它和 autoprefixer 还是有点点区别的。
如我们所谈到的，autoprefixer 和任务运行工具一同工作，比如后处理器。而当你想要使用 prefix-free 时，你需要在页面的头部或者尾部将其引入，它将会在网站加载的时候运行并添加必要的前缀。有什么负面影响吗？又多了一个外部资源并且增加了带宽呗！如果用户遇到了 JavaScript 代码阻塞或者失效呢？然而，这总比不添加前缀好吧，而且这也比学习使用任务运行工具简单多了。

想征求我的建议？因人而异！短期来看并且作为一个快速修复的方法，prefix-free 会是更好的选择。然而，我建议额外花一些时间去学习使用任务运行工具，这会让你学有所得。任务运行工具能够让你的生活变得简单让你的工作变得快捷。我最爱 Gulp了，你可以在 [Gulp for Web Designers](http://blog.alexdevero.com/gulp-web-designers-want-know/) 这篇文章中学习如何使用它。

# N0.10: 管理你的技术债务

我们来谈谈维护整洁的 CSS 代码的最后一个方法吧。你听过所谓的技术债务吗？每一次你为了解决问题而快速地 Hack 一些事情时，技术债务就发生了。当你使用容易实现的代码替代最全面的解决方案时，技术债务就增加了。它通常出现在一些需要快速移动和传输的项目中，换句话说，在初创公司中很常见。

技术债务的问题不在于你创造了它，而在于很多时候你根本没有那么多时间去完美地解决它。有时候为了立竿见影你不得不使用非常差劲的方案，比如：假使你或者别人发现了网站或者产品上的一个大问题，而且网站或产品已经上线了。然后你需要迅速修复，否则就会失去客户，结果就会造成技术债务。

如我所言，其问题不是发生了技术债务，真正的问题是你可能会忘记有这个东西。技术债务发生的时候，你应该只把它作为临时的解决方案。等到时间富裕的时候，你应该回过头来用更好的方法替换掉快速修复的方法。从长远上来看，你将能够维护整洁的 CSS 代码。

不幸的是，我无法准确告诉你如何减少技术债务的发生，解决方法取决于当时的情况。但是，我可以给你三条建议：第一，利用某种方式积累工作内容，每次你使用投机取巧的解决方案时都要新建一个任务，好记性不如烂笔头。第二，花费部分时间来重新查看这些工作，并逐个解决。不要让技术债务和任务的数量积累得太大，否则将超出控制你将无从下手。第三，定期重构你的 CSS 代码。通过保持 [DRY](http://csswizardry.com/2013/07/writing-dryer-vanilla-css/) CSS 来维护整洁的代码，减少重复的代码，做到一次书写多次调用。

## 写在文末

恭喜，你已经读完了第二部分，同时也读完了这个迷你系列的文章！我希望谈论的这十条建议能够帮助你写出整洁的 CSS 代码，也希望你能够长期维护好它。我来告诉你一个秘密，书写整洁的 CSS 代码根本没什么困难，难的是你能够一直保持 CSS 代码的整洁。如果不只你一个人在写 CSS 代码，那将变得更加困难，但是只要怀着良好的目的去写 CSS 代码，事情就会变得简单了。
