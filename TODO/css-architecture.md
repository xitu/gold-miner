# 一个健壮且可扩展的 CSS 架构所需的8个简单规则

> * 原文地址：[8 simple rules for a robust, scalable CSS architecture](https://github.com/jareware/css-architecture)
* 原文作者：[Jarno Rantanen](https://github.com/jareware)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[linpu.li](https://github.com/llp0574)
* 校对者：[galenyuan](https://github.com/galenyuan)，[StarCrew](https://github.com/StarCrew)


这是一份清单，里面列出了在我多年的专业 Web 开发期间，在复杂的大型 Web 项目中学习到的有关管理 CSS 的事项。我多次被人问起这些东西，所以写一份文档记录下来听起来是个不错的主意。

我已经尽力尝试用简短的语言去解释它们了，然而这篇文章本质上还是长文慎入：

1.  [**总是类名优先**](#1-always-prefer-classes)
2.  [**组件代码放在一起**](#2-co-locate-component-code)
3.  [**使用一致的类命名空间**](#3-use-consistent-class-namespacing)
4.  [**维护命名空间和文件名之间的严格映射**](#4-maintain-a-strict-mapping-between-namespaces-and-filenames)
5.  [**避免组件外的样式泄露**](#5-prevent-leaking-styles-outside-the-component)
6.  [**避免组件内的样式泄露**](#6-prevent-leaking-styles-inside-the-component)
7.  [**遵守组件边界**](#7-respect-component-boundaries)
8.  [**松散地整合外部样式**](#8-integrate-external-styles-loosely)

## [](#introduction)介绍

如果你正在开发前端应用，那么最后你肯定需要关心样式方面的问题。尽管开发前端应用的技术水平持续增长，CSS 仍然是给 Web 应用赋予样式的唯一方式（而且最近，在某些情况下，[原生应用也一样](https://facebook.github.io/react-native/)）。目前在市面上有两大类样式解决方案，即：

*   CSS 预编译器，已经存在很长时间了（如 [SASS](http://sass-lang.com/)、[LESS](http://lesscss.org/) 及其他）
*   CSS-in-JS 库，一个相对较新的样式解决方案（如 [free-style](https://github.com/blakeembrey/free-style) 和很多[其他的](https://github.com/MicheleBertoli/css-in-js)）

两种方法间的抉择不在本文过多赘述，并且像往常一样，它们都有各自的支持者和反对者。说完这些，在下面的内容里，我将会专注于第一种方法，所以如果你选择了后者，那么这篇文章可能就没什么吸引力了。

## [](#high-level-goals)主要目标

但更具体地说，怎样才能被称为健壮且可扩展呢？

*   **面向组件** - 处理 UI 复杂性的最佳实践就是将 UI 分割成一个个的小组件。如果你正在使用一个合理的框架，JavaScript 方面就将原生支持（组件化）。举个例子，[React](https://facebook.github.io/react/) 就鼓励高度组件化和分割。我们希望有一个 CSS 架构去匹配。
*   **沙箱化（Sandboxed）** - 如果一个组件的样式会对其他组件产生不必要以及意想不到的影响，那么将 UI 分割成组件并不会对我们的认知负荷起到帮助作用。就这方面而言，CSS的基本功能，如[层叠（cascade）](https://developer.mozilla.org/en/docs/Web/Guide/CSS/Getting_started/Cascading_and_inheritance)以及一个针对标识符的独立全局命名空间，都会给你造成负担。如果你熟悉 Web 组件规范的话，那么就可以认为它（此架构）有着 [Shadow DOM 的样式隔离好处](http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom-201/) ，而无需关心浏览器支持（或者规范是否经过严格的推敲）。
*   **方便** - 我们想要所有好的东西，并且还不想因它们而产生更多的工作。也就是说，我们不想因为采用这个架构而让我们的开发者体验变得更糟。可能的话，我们想（开发者体验）变得更好。
*   **安全性错误** - 结合之前的一点，我们想要所有东西都可以**默认局部化**，并且全局化只是一个特例。工程师都是很懒的，所以为了得到最容易的方法往往都需要使用合适的解决方案。

## [](#concrete-rules)具体的规则

### [](#1-always-prefer-classes)1\. 总是类名优先

这是显而易见的。

不要去使用 ID 选择器 (如 `#header`)，因为每当你认为某样东西只会有一个实例的时候，[在无限的时间范围内](https://twitter.com/stedwick/status/525777867146539009)，你都将被证明是错的。一个典型的例子就是，当想要在我们构建的大型应用中修复任何数据绑定漏洞的时候（这种情况尤为明显）。我们从为 UI 代码创建两个实例开始，它们并行在同一个 DOM，并都绑定到一个数据模型的共享实例上。这么做是为了保证所有数据模型的变化都可以正确体现到这两个 UI 上。所以任何你可能假设总是唯一的组件，如一个头部模板，就不再唯一了。顺便一提，这对找出其他唯一性假设相关的细微漏洞来说，也是一个很好的基准。我跑题了，但这个故事告诉我们的就是：没有一种情况是使用 ID 选择器会比使用类选择器**更好**，所以只要不使用就行了。

同样也不应该直接使用元素选择器（如 `p`）。通常对一个**属于组件**的元素使用元素选择器是可以的（看下面），但是对于元素本身来说，最终你将会为了一个不想使用它们的组件，而不得不[将那些样式给撤销掉](http://csswizardry.com/2012/11/code-smells-in-css/)。回想一下我们的主要目标，这同样也违背了它们（面向组件，避免折磨人的层叠（cascade），以及默认局部化）。如果你这么选择的话，那么在`body`上设置一些像字体，行高以及颜色的属性（也叫[可继承属性](https://developer.mozilla.org/en-US/docs/Web/CSS/inheritance)），对这个规则来说也可以是一个特例，但是如果你真正想做到组件隔离的话，那么放弃这些也完全是可行的（看下面关于[使用外部样式的部分](#8-integrate-external-styles-loosely)）。

所以在极少特例的情况下，你的样式应该总是类名优先。

### [](#2-co-locate-component-code)2\. 组件代码放在一起

当使用一个组件的时候，如果所有和组件相关的资源（其 JavaScript 代码，样式，测试用例，文档等等）都可以非常紧密地放在一起，那就更好了：

    ui/
    ├── layout/
    |   ├── Header.js              // component code
    |   ├── Header.scss            // component styles
    |   ├── Header.spec.js         // component-specific unit tests
    |   └── Header.fixtures.json   // any mock data the component tests might need
    ├── utils/
    |   ├── Button.md              // usage documentation for the component
    |   ├── Button.js              // ...and so on, you get the idea
    |   └── Button.scss

当你写代码的时候，只需要简单地打开项目的浏览工具，组件的所有其他内容都唾手可得了。样式代码和生成DOM的JavaScript之间有着天然的耦合性，而且我敢打赌你在修改完其中一个之后不久肯定会去修改另外一个。举例来说，这同样适用于组件及其测试代码。可以认为这就是 UI 组件的[访问局部性原理](https://en.wikipedia.org/wiki/Locality_of_reference)。我以前也会细致地去维护各种独立的镜像文件，它们各自存在 `styles/`、 `tests/` 和 `docs/` 等目录下面，直到我意识到，实际上我一直这么做的唯一原因是因为我就是一直这样做的。

### [](#3-use-consistent-class-namespacing)3\. 使用一致的类命名空间

CSS 对类名及其他标识符（如 ID、动画名称等）都有一个独立扁平的命名空间。就像过去在 PHP 里，其社区想通过简单地使用更长且具有结构性的名称来处理这个问题，因此就效仿了命名空间（[BEM](http://getbem.com/) 就是个例子）。我们也想要选择一个命名空间规范，并坚持下去。

比如，使用 `myapp-Header-link` 来当做一个类名，组成它的三个部分都有着特定的功能：

*   `myapp` 首先用来将我们的应用和其他可能运行在同一个 DOM 上的应用隔离开来
*   `Header` 用来将组件和应用里其他的组件隔离开来
*   `link` 用来为局部样式效果保存一个局部名称（在组件的命名空间内）

作为一个特殊的情况，`Header` 组件的根元素可以简单地用 `myapp-Header` 类来标记。对于一个非常简单的组件来说，这可能就是所需要做的全部了。

不管我们选择怎样的命名空间规范，我们都想要通过它保持一致性。那三个类名组成部分除了有着特定**功能**，也同样有着特定的**含义**。只需要看一下类名，就可以知道它属于哪里了。这样的命名空间将成为我们浏览项目样式的地图。

目前为止我都假设命名空间的方案为 `app-Component-class`，这是我个人在工作当中发现确实好用的方案，当然你也可以琢磨出自己的一套来。

### [](#4-maintain-a-strict-mapping-between-namespaces-and-filenames)4\. 维护命名空间和文件名之间的严格映射

这只是对之前两条规则的逻辑组合（组件代码放在一起以及类命名空间）：所有影响一个特定组件的样式都应该放到一个文件里，并以组件命名，没有例外。

如果你正在使用浏览器，然后发现一个组件表现异常，那么你就可以点击右键检查它，接着你就会看到：



    <div class="myapp-Header">...</div>



注意到组件名称，然后切换至你的编辑器，按下“快速打开文件”的快捷键，然后开始输入“head”，就可以看到：

[![Quick open file](https://github.com/jareware/css-architecture/raw/master/quick-open-file.png)](/jareware/css-architecture/blob/master/quick-open-file.png)

这种来自 UI 组件关联源代码文件的严格映射非常有用，特别是如果你新进入一个团队并且还没有完全熟悉代码结构，通过这个方法你不需要熟悉就可以快速找到你应该写代码的地方了。

有一个对这种方法的自然推论（但或许不是那么快变得明显）：一个单独的样式文件应该只包含属于一个独立命名空间的样式。为什么？假设我们有一个登录表单，只在 `Header` 组件内使用。在 JavaScript 代码层面，它被定义成一个名为 `Header.js` 的辅助组件，并且没有在任何地方被引入。你可能想声明一个类名为 `myapp-LoginForm`，并在 `Header.js` 和 `Header.scss` 里使用。那么假设团队里有一个新人被安排去修复登录表单上一个很小的布局问题，并想通过检查元素发现在哪里开始修改。然而并没有 `LoginForm.js` 或者 `LoginForm.scss` 可以被发现，这时他就不得不凭借 `grep` （Linux 命令）或者靠猜去寻找相关联的源代码文件。这也就是说，如果这个登录表单产生了一个独立的命名空间，那么就应该将其分割成一个独立的组件。一致性在大型项目里是非常有价值的。

### [](#5-prevent-leaking-styles-outside-the-component)5\. 避免组件外的样式泄露

我们已经建立了自己的命名空间规范，并且现在想使用它们去沙箱化我们的 UI 组件。如果每个组件都只使用加上它们唯一的命名空间前缀的类名，那我们就可以确定它们的样式不会泄露到其他组件中去。这是非常高效的（看后面的注意事项），但是不得不反复输入命名空间也会变得越来越冗长乏味。

一个健壮，且仍然非常简单的解决方案就是将整个样式文件包装成一个前缀。注意我们是怎样做到只需要重复一次应用和组件名称：



    .myapp-Header {
      background: black;
      color: white;

      &-link {
        color: blue;
      }

      &-signup {
        border: 1px solid gray;
      }
    }



上面的例子是在 SASS 中实现的，但其中的 `&` 符号（或许让人有点惊讶）在所有相关的 CSS 预处理器中都做着同样的工作（[SASS](http://sass-lang.com/)、[PostCSS](https://github.com/postcss/postcss-nested)、[LESS](http://lesscss.org/) 以及 [Stylus](http://stylus-lang.com/)）。出于完整性，接下来给出上面 SASS 代码编译后的结果：



    .myapp-Header {
      background: black;
      color: white;
    }

    .myapp-Header-link {
      color: blue;
    }

    .myapp-Header-signup {
      border: 1px solid gray;
    }



所有常见的模式也可以使用它很好地表示出来，比如不同的组件状态有着不同的样式（想想 [BEM 条件下的修饰符](http://getbem.com/naming/)）：



    .myapp-Header {

      &-signup {
        display: block;
      }

      &-isScrolledDown &-signup {
        display: none;
      }
    }



上面的编译结果如下：



    .myapp-Header-signup {
      display: block;
    }

    .myapp-Header-isScrolledDown .myapp-Header-signup {
      display: none;
    }



只要你的预编译器支持冒泡（SASS、LESS、PostCSS 和 Stylus 都可以做到），甚至媒体查询也可以很方便表示：



    .myapp-Header {

      &-signup {
        display: block;

        @media (max-width: 500px) {
          display: none;
        }
      }
    }



上面的代码就会变成：



    .myapp-Header-signup {
      display: block;
    }

    @media (max-width: 500px) {
      .myapp-Header-signup {
        display: none;
      }
    }



上面的模式让使用长且唯一的类名变得非常方便，因为你再也无需反复输入它们了。方便性是强制的，因为如果不方便，那么我们就会偷工减料了。

### [](#quick-aside-on-the-js-side-of-things)JS 端的快速一览

这篇文档是关于样式规范的，但样式是不能凭空独立存在的：我们在 JS 端也需要产生同样的命名空间化类名，并且方便性也是强制的。

厚着脸皮做个广告，我恰好为此曾经建立了一个非常简单，无任何依赖的 JS 库，叫做 [`css-ns`](https://github.com/jareware/css-ns)。当在框架层面编译的时候（[比如使用 React](https://github.com/jareware/css-ns#use-with-react)），它允许在一个特定文件内**强制**建立一个特定的命名空间。



    // Create a namespace-bound local copy of React:
    var { React } = require('./config/css-ns')('Header');

    // Create some elements:
    <div className="signup">
      <div className="intro">...</div>
      <div className="link">...</div>
    </div>




将渲染出的 DOM 如下所示：




    <div class="myapp-Header-signup">
      <div class="myapp-Header-intro">...</div>
      <div class="myapp-Header-link">...</div>
    </div>




这真的非常方便，并且上面所有的代码让 JS 端也变成了**默认局部化**。

但是我再次跑题了，回到 CSS 端。

### [](#6-prevent-leaking-styles-inside-the-component)6\. 避免组件内的样式泄露

还记得我说过给每个类名加上组件命名空间的前缀时，这是对沙箱化样式来说很高效的一种方式吗？还记得我说过这里有个“注意事项”吗？

考虑下面的样式：



    .myapp-Header {
      a {
        color: blue;
      }
    }



以及下面的组件层：

    +-------------------------+
    | Header                  |
    |                         |
    | [home] [blog] [kittens] | <-- 这些都是 <a> 元素
    +-------------------------+

这很酷，不是吗？`Header` 里只有 `<a>` 元素会变成[蓝色](https://www.youtube.com/watch?v=axHe_BVY_9c)，因为我们生成的规则如下：



    .myapp-Header a { color: blue; }



但是考虑布局在之后做一下变化：

    +-----------------------------------------+
    | Header                    +-----------+ |
    |                           | LoginForm | |
    |                           |           | |
    | [home] [blog] [kittens]   | [info]    | | <-- 这些是 <a> 元素
    |                           +-----------+ |
    +-----------------------------------------+

选择器 `.myapp-Header a` **同样匹配**了 `LoginForm` 里的 `<a>` 元素，所以我们搞砸了这里的样式隔离。事实证明，将所有样式包装到一个命名空间里对于隔离组件及其邻居组件来说，是一个高效的方式，**但却不能总是和其子组件隔离**。

这个问题可以通过两种方法修复：

1.  绝不在样式表中使用元素名称选择器。如果 `Header` 里的 `<a>` 元素都使用 `<a class="myapp-Header-link">` 替代，那么我们就不需要处理这个问题了。再往下看，有时候你会设置一些语义化标签，像 `<article>`、`<aside>` 以及 `<th>`，都放在了正确的位置上，并且你又不想用额外的类名来弄乱它们，这种情况下：
2.  在你的命名空间之外只使用 [`>` 操作符](https://developer.mozilla.org/en-US/docs/Web/CSS/Child_selectors) 来选择元素。

根据第二个方法来做调整，我们的样式代码就可以改写如下：



    .myapp-Header {
      > a {
        color: blue;
      }
    }



这样就可以确保隔离同样作用于更深层次的组件树，因为生成的选择器变成了 `.myapp-Header > a`。

如果这听起来有争议，那么让我通过下面这个同样运行良好的例子更进一步地使你信服：



    .myapp-Header {
      > nav > p > a {
        color: blue;
      }
    }



经过[多年的可靠建议](http://lmgtfy.com/?q=css+nesting+harmful)，我们一直认为要尽量避免选择器嵌套（包括这个使用了 `>` 的强关联形式）。但是为什么呢？这个引用的原因归结为以下三个：

1.  层叠样式最终会毁掉你的一天。要是嵌套越多的选择器，那么就有越高的机会造成一个元素匹配上**多于一个组件**的情况。如果你读到这里，你就会知道我们已经消除了这种可能性了（使用严格的命名空间前缀，并在需要的时候使用强关联子元素选择器）。
2.  太多的特性会减少可复用性。写给 `nav p a` 的样式将不能在特定情况下之外的任意地方被复用。但其实我们**从来没想要它可复用**，事实上，我们特意禁止这个可复用的方法，因为这种可复用性并不能在我们想实现组件隔离的目标上产生好的作用。
3.  太多的特性会让重构变得更加困难。这可以在现实中找到依据，假设你只有一个 `.myapp-Header-link a`，你可以很自由地在组件的 HTML 中移动 `<a>` 元素，同样的样式总是会一直生效。然而如果使用 `> nav > p > a`，就需要更新选择器去匹配组件的 HTML 内这个链接的新位置。但考虑到我们想要 UI 是由一些小且隔离性好的组件组成，这个问题也不是相当重要。当然，如果你不得不在重构的时候考虑整个应用的 HTML 和 CSS，那么这个问题可能就有点严重了。但是现在你是在一个只有十行样式代码的小沙箱内进行操作，并且还知道沙箱外没有其他东西需要考虑，那么这种类型的变化就不是问题了。

通过这个例子，你应该很好的理解了规则，所以你知道什么时候应该打破它们。在我们的架构里，选择器嵌套不仅仅只是可以用，有时候它还是一件非常正确的事情。为之疯狂吧。

### [](#an-aside-for-the-curious-prevent-leaking-styles-into-the-component)出于好奇的题外话：预防泄露样式**进入**组件

所以我们是否已经实现了样式的完美沙箱化，以至于每个组件的存在都可以和页面的其他内容隔离开来呢？做一个快速回顾：

*   我们已经通过用组件的命名空间给每个类名加前缀来避免**组件向外泄露样式**：

        +-------+
        |       |
        |    -----X--->
        |       |
        +-------+

*   引申开来，这也意味着我们已经避免了**组件间的泄露**：

        +-------+     +-------+
        |       |     |       |
        |    ------X------>   |
        |       |     |       |
        +-------+     +-------+

*   而且我们还通过考虑子选择器来避免**泄露进入子组件**：

        +---------------------+
        |           +-------+ |
        |           |       | |
        |    ----X------>   | |
        |           |       | |
        |           +-------+ |
        +---------------------+

*   但更为关键的是，**外部样式仍然可以泄露进入组件当中**：

              +-------+
              |       |
        ---------->   |
              |       |
              +-------+

举个例子，假设我们给组件写了下面的样式：



    .myapp-Header {
      > a {
        color: blue;
      }
    }



但是接着我们引入一个表现不好的第三方库，有着下面的 CSS：



    a {
      font-family: "Comic Sans";
    }



**没有一个简单的方法可以保护我们的组件不受外部样式的污染**，并且这是我们经常需要调整的地方：

[![Give up](https://github.com/jareware/css-architecture/raw/master/give-up.gif)](/jareware/css-architecture/blob/master/give-up.gif)

幸好，对于你自己使用的依赖来说常常会有一个控制方式，并且也可以简单地找一个表现更好的选择。

而且，我说的是没有一个**简单的**的方法可以保护组件，并不意味着没有方法。[老兄，当然是有方法的](https://www.youtube.com/watch?v=20wUS_bbOHY)，它们只是有不同的取舍：

*   只需强制覆盖它：如果你为每个组件的每个元素去引入一个 [CSS 重置样式](http://cssreset.com/what-is-a-css-reset/)，并且使用一个优先级总是高于其他第三方库的选择器，那么就非常棒了。但是除非是一个小应用（假设一个第三方“共享”按钮可以嵌入到网站上那种），否则这种方法将会迅速失控。这不算是一个好主意，只是在这里列出来等待完善。
*   [`all: initial`](https://developer.mozilla.org/en/docs/Web/CSS/all) 是一个很少人知道的新 CSS 属性，它专门为了这个问题而设计。它可以[阻止继承属性流入](https://jsfiddle.net/0d9htatc/)，并且[只要它赢得了特性之争](https://jsfiddle.net/e7rw4L8L/)（并且只要你为每个想保护的属性重复使用它），还可以作为一个本地重置生效。它的实现[有些错综复杂](https://speakerdeck.com/csswizardry/refactoring-css-without-losing-your-mind?slide=39)，而且还不是所有浏览器都[支持](http://caniuse.com/#feat=css-all)，但是 `all: initial` 最后或许可以成为样式隔离的有效方法。
*   Shadow DOM 已经被提到过，而它正是为你解决问题的一个工具，因为它允许为 JS 和 CSS 声明组件边界。尽管最近有[一丝希望的微光](https://developer.apple.com/library/content/releasenotes/General/WhatsNewInSafari/Articles/Safari_10_0.html)，Web 组件规范还是没有在今年取得很大的进步，并且除非你使用的是一些已知可支持的浏览器，否则还是不能将 Shadow DOM 列入考虑范围。
*   最后，还有 `<iframe>`。它提供了 Web 运行环境所能提供的最强的隔离形式（既为 JS 也为 CSS），但同样为运行成本（潜在因素）和维护（保留的内存）带来了巨大的消耗。不过，通常代价是值得的，并且最著名的网络嵌入（Facebook、Twitter、Disqus等等）事实上也是用 iframe 实现的。然而本文档的目的是隔离成千上百个小组件，就此而言，这个方法将数以百倍地消耗我们的性能。

不管怎样，这个题外话跑得有点远了，回到我们的 CSS 规则。

### [](#7-respect-component-boundaries)7\. 遵守组件边界

就像我们赋予 `.myapp-Header > a` 的样式，当嵌套组件的时候，我们可能还需要给子组件提供一些样式（Web 组件类比再次完美，因为接下来 `> a` 和 `> my-custom-a` 的效果并没有什么差异）。考虑下面的布局：

    +---------------------------------+
    | Header           +------------+ |
    |                  | LoginForm  | |
    |                  |            | |
    |                  | +--------+ | |
    | +--------+       | | Button | | |
    | | Button |       | +--------+ | |
    | +--------+       +------------+ |
    +---------------------------------+

我们马上可以看到用 `.myapp-Header .myapp-Button` 写样式不会是一个好主意，显然应该用 `.myapp-Header > .myapp-Button` 来替代。但是我们到底要给子组件提供什么样式呢？

注意到 `LoginForm` 靠在了 `Header` 的右边界上。直观看来，一个可能的样式就是：



    .myapp-LoginForm {
      float: right;
    }



我们没有违反任何规则，但是我们让 `LoginForm` 变得有点难以复用了：如果我们接下来的主页想要这个 `LoginForm`，但是不想要右浮动，那就不走运了。

这个问题实际的解决方案就是（局部地）放宽之前的规则，只对当前文件所属的命名空间提供样式。具体来说，我们希望用下面的代码替换：



    .myapp-Header {
      > .myapp-LoginForm {
        float: right;
      }
    }



这样实际上已经很好了，只要我们不允许随意地破坏子组件的沙箱：



    // COUNTER-EXAMPLE; DON'T DO THIS
    .myapp-Header {
      > .myapp-LoginForm {
        color: blue;
        padding: 20px;
      }
    }



我们不允许这么做，因为这样做会失去局部变化没有全局影响的安全性。使用上面代码的话，当修改 `LoginForm` 组件表现的时候，`LoginForm.scss` 就不再是唯一需要检查的地方了。发生变化再次变得可怕。所以可用与不可用之间的界限到底在哪里？

我们希望遵守每个子组件**内部**的沙箱，因为我们不想依赖其实现细节。它对于我们来说是个黑盒。相反地，在子组件**外部**的是父组件的沙箱，它占据着主要位置。区分内部和外部正好引出了 CSS 中最基本的概念之一：[盒模型](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Box_Model/Introduction_to_the_CSS_box_model)。

[![CSS Box Model](https://github.com/jareware/css-architecture/raw/master/box-model.png)](/jareware/css-architecture/blob/master/box-model.png)

我做的这个类比很糟糕，但我们继续看：就像**在一个国家内**意味着在其物理边界之内，我们建立了一个边界，父组件只可以在子组件边界之外对（直接）子组件样式产生影响。这意味着关系到位置和大小的属性（如 `position`、`margin`、`display`、`width`、`float`、`z-index` 等等）是可用的，而影响到内部边界的属性（如 `border` 本身、`padding`、`color`、`font`等）是不可用的。

按照推论，下面这样显然也是禁止的：



    // COUNTER-EXAMPLE; DON'T DO THIS
    .myapp-Header {
      > .myapp-LoginForm {
        > a { // relying on implementation details of LoginForm ;__;
          color: blue;
        }
      }
    }



有几个有趣或者说无聊的边界情况，比如：

*   `box-shadow` - 一个特定类型的 shadow 可以是一个组件外观不可缺少的部分，因此组件应该自己包含这些样式。话又说回来，这种视觉效果可以在边界外清楚地渲染出来，所以它又可以回到父组件的作用域。
*   `color`, `font` 及其他[可继承属性](https://developer.mozilla.org/en-US/docs/Web/CSS/inheritance) - `.myapp-Header > .myapp-LoginForm { color: red }` 这种写法碰到了子组件内部的属性，但从另一方面来说，这又可以在功能上等同于 `.myapp-Header { color: red; }`，这种写法根据其他规则又是可行的。
*   `display` - 如果子组件使用了 [Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) 布局，那么它很可能依赖于其根元素上设置 `display: flex` 属性。不过，父组件也可能选择通过 `display: none` 来隐藏其子组件。

在这些边界情况下要意识到一件重要的事情，你并不是在冒着打核战争的危险，而只是在引入少量的 CSS 层叠好回到自己的样式。就和其他不好的做法一样，适当地使用层叠是可以的。例如，再仔细看到最后的例子，[特性优先级比较](https://developer.mozilla.org/en-US/docs/Web/CSS/Specificity)正如你所想要的效果一样：当组件可见时，`.myapp-LoginForm { display: flex }` 的优先级更高。而当拥有者决定用 `.myapp-Header-loginBoxHidden > .myapp-LoginBox { display: none }` 隐藏组件时，这个样式的优先级更高。

### [](#8-integrate-external-styles-loosely)8\. 松散地整合外部样式

为了避免重复工作，有时可能需要在组件间共享样式。为了避免全部工作，有时又可能想使用其他人创建的样式。这两种情况的实现都不应该创建出不必要的耦合到代码库中。

拿一个具体的例子来说，考虑使用一些来自 [Bootstrap](http://getbootstrap.com/css/) 的样式，因为这对于使用恼人的框架来说是一个很好的例子。想想我们上面所讨论到的所有事情，关于为样式共享一个独立的全局命名空间，以及不好的冲突，Bootstrap 会：

*   导出一大堆选择器（版本 3.3.7 来说, 具体有 2481 个）到命名空间里，不管你实际上是否使用它们。（有趣的一面：IE9 在默认忽略剩余选择器之前只会处理 4095 个选择器。我曾经听说有人花了**很多天**来调试它们，鬼知道他们经历了什么。）
*   使用写死的类名如 `.btn` 和 `.table`。不敢想象某些不小心复用了这些样式的开发者或者项目。（讽刺脸）

不管了，我们希望使用 Bootstrap 作为 `Button` 组件的基础。

用某段代码替换下面的来整合到 HTML 端：



    <button class="myapp-Button btn">



考虑在样式中[扩展](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#extend)这个类：



    <button class="myapp-Button">


    .myapp-Button {
      @extend .btn; // from Bootstrap
    }



这么做有一个好处，那就是没有给任何人（包括你自己）产生一种想法：在 HTML 组件上去依赖可笑地命名为 `btn` 的类。`Button` 所使用的样式的来源是一个完全不需要显示在外面的实现细节。因此，如果你决定放弃 Bootstrap 转而支持另外的框架（或者只是你自己去写样式），那么这种改变无论如何都不会外部可见（呃，除非，这种可见变化是在于 `Button` 本身长什么样子）。

同样的原则适用于你自己的辅助类，并且你可以选择使用更合理的类名：



    .myapp-Button {
      @extend .myapp-utils-button; // defined elsewhere in your project
    }



或者[干脆放弃放出类](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#placeholder_selectors_)（[大部分预编译器都可以支持](https://csspre.com/placeholder-selectors/)）：



    .myapp-Button {
      @extend %myapp-utils-button; // defined elsewhere in your project
    }



最后，所有的 CSS 预编译器都支持 [mixins](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#mixins) 的概念，这可是一个强有力的工具：



    .myapp-Button {
      @include myapp-generateCoolButton($padding: 15px, $withExplosions: true);
    }



应该注意的是当处理更友好的样式框架时（如 [Bourbon](http://bourbon.io/) 或者 [Foundation](http://foundation.zurb.com/)），它们实际上会这么做：定义一大堆 mixin 给你去在需要的时候使用，并且它们本身没有放出任何样式。[Neat](http://neat.bourbon.io/) 框架。

## [](#in-closing)在结束前

> 知晓所有规则，所以知道何时打破它们

最后，如前所述，当你理解了你所制定的规则（或者是从网上其他人那儿采取的），你就可以写出对你有意义的特例。比如，如果你觉得直接使用一个辅助类是有附加价值的，那么就可以这么做：



    <button class="myapp-Button myapp-utils-button">



这种附加价值可能是，比如说，你的测试框架之后可以更智能地自动找出什么元素表现为按钮，以及可以被点击。

或者你可能会在违背程度很小的情况下决定去打破组件隔离，并且分割组件的额外工作可能会变得更好。但我想要提醒的是这就像是个下坡路，而且不要忘了一致性的重要性等等，只要你的团队保持一致，并且你可以完成它们，那么你就是在做对的事情。

## [](#the-end)结语

如果你喜欢这篇文章，你完全可以 [tweet 关于它的内容！](https://twitter.com/home?status=8%20simple%20rules%20for%20a%20robust,%20scalable%20CSS%20architecture%3A%20https%3A//github.com/jareware/css-architecture)或者不。

## [](#license)证书

[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)