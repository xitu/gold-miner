> * 原文地址：[Styling In Modern Web Apps](https://www.smashingmagazine.com/2019/06/styling-modern-web-apps/)
> * 原文作者：[Ajay](https://www.smashingmagazine.com/author/ajay-ns)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/styling-modern-web-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/styling-modern-web-apps.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[chechebecomestrong](https://github.com/chechebecomestrong)

# 关于现代 Web 应用程序样式的探讨

欢迎你和我们一起通过本文深度探索现代应用中样式的不同组织方法，这些不同的方法通常会包含复杂的接口和设计模式。我们将会一起探讨 BEM（Block Element Modfier，块元素编辑器）、预处理器、CSS-in-JS（即在组件内部使用 JavaScript 对 CSS 进行了抽象，可以对其声明和加以维护。） 甚至是设计系统，然后找出更适合你的方案。

---

如果你在搜寻如何为网络应用编写样式，一般你会浏览很多不同的方法和库，这其中有一些甚至会更新非常快。包括块级元素修饰符（BEM）；譬如 Less 和 SCSS 这样的预处理器；CSS-in-JS 库，包括 JSS 和 styled-components；以及最近出现的设计系统。你会在不同的文章、博客、教程、讨论，当然还有 Twitter 上的争论中浏览这些内容。

那么你如何在这之中做出选择呢？为什么会存在这么多种不同的方法？如果你已经熟悉适应了一种方法，为什么还要考虑迁移到其他的方法呢？

在本篇文章中，我会带你一起了解我曾使用于生产环境应用的工具，以及我搭建的网站，我会根据我的实际经历，对比不同方法的特性，而不是单纯的总结这些方法的 readme 文件。我这趟关于样式的旅行途径 [BEM](https://www.smashingmagazine.com/2018/06/bem-for-beginners/)、SCSS、[styled-components](https://www.smashingmagazine.com/2017/01/styled-components-enforcing-best-practices-component-based-systems/) 和最特别的[设计系统](https://www.smashingmagazine.com/category/design-systems)；但是注意，即使你使用的是不同的库，但它们万变不离其宗，基本的原则和方法都是一样的。

### 过去的 CSS

当网站刚开始火起来的时候，CSS 只是用来为网站添加一些时髦的设计，以此吸引用户的眼球，就像繁华街道边上的霓虹灯广告牌：

![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ffc58213-33f4-4dc6-85df-813e0a8c93d2/css-back-ex.png)

左侧是 Microsoft 的第一个网站，右边是 21 世纪早期的 MTV 网站。

它并不用于布局、改变大小，或者其他我们日常就会用 CSS 完成基本需求，只作为一个能让网站更好看并且显眼的可选项。但随着 CSS 加入了更多的特性，新版的浏览器也随之支持更多功能和特性，而后网站标准和用户界面也加入了进来 —— CSS 成为了网站开发的重要部分。

很难找到没有至少要几百行的自定样式或者 CSS 框架的网站（当然至少这些网站要看上去是紧跟潮流、没有过时的）：

![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/0ca9b797-a15d-4fb0-987f-aca51fc8d395/css-back-modern.png)

Wired 的现代响应式网站，来自 InVision 的响应式网站设计实例。

接下来发生的事情很好猜了。用户界面的复杂度持续增加，所以 CSS 的应用也跟着上升；但是 CSS 的书写却没有任何指导，同时 CSS 又变得很复杂，于是样式问题就变得非常复杂，让人头疼。开发者都有自己的一套方法来处理样式问题，用所有这些想办法让网页看上去和设计稿要求的一致。

这反过来导致了很多常规性的问题，而这些问题都要开发者来处理，比如在项目中管理大型团队，或者长时间维护一个没有清晰指导的项目。甚至是现在，这些事情发生的最主要原因是，CSS 仍旧经常被认为是不重要的部分，并不值得人们关注它，这是很可悲的。

### CSS 并不容易掌握

当团队负责大型项目的时候，却并不为 CSS 的维护和管理构建任何内容，此时团队可能会面临的常规问题包括：

* 缺少代码结构和标准，导致可靠性大幅下降；
* 维护成本随项目增大而增加；
* 由于缺乏可靠性导致的优先级问题。

如果你曾经用过 Bootstrap，你一定注意到，你是无法覆盖默认的样式的，也许你也尝试过添加 `!important` 或者特殊选择器的方法来解决。想象一个超大项目的样式表，表里会有很多类，以及每个元素的样式。此时使用 Bootstrap 是个很不错的选择，因为它有很好的文档，同时 它的目标就是作为样式框架应用。但是对于大多数项目内的样式表而言，并不属于这种情况，那么你很可能会迷失在级联样式中。

在很多项目中，一个文件中可能包含几千行 CSS 代码，如果你看到哪个文件有注释，那你可真是非常幸运了，因为大多数文件根本没有。你也可能会看到很多写在最后的 `!important`，来让特定的样式覆盖其他的。

![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8dfc9ac6-7677-4770-9c98-5dd1eee56e6f/css-important-meme.png)

!important 语法并不能拯救糟糕的 CSS 代码。

你可能面临一些特定的问题，但是不知道它们是如何运作的。下面让我们一起来看一下。

![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/346b4288-8baa-435a-9ed4-f40ede30a5b5/specificity-1.png)

假设这两个样式都指向右边的图片，它们中的哪个会生效呢？

选择器的权重都是多少呢？这些选择器包括内联样式，ID、属性和元素选择器。长话短说，它们的权重排序是：

> 从 `0` 开始；内联样式可以加 `1,000`；每个 `id` 选择器可以加 `100`；每个属性或者类、伪类选择器可以加 `10`；每个元素名选择器或者伪元素选择器可以加 `1`。

通常情况下，这是计算以及表明哪个样式可以工作的最简单的方法，但请注意真正的表示方法应形如：(`0`,`0`,`0`,`0`)。这其中第一个数字代表内联样式，第二个代表 ID，以此类推。每个选择器都可以是大于 `9` 的数字，只有高权重的选择器相等的时候，才需要对比低权重的选择器。

举个例子，比如上文的示例：

![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1d6a0f37-c0f5-4566-9a82-b3ded61b4e7b/specificity-2.png)

![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/189a7b3d-1f45-40df-b3cd-a1941d81dfab/specificity-3.png)

所以你明白为什么第二个样式真正生效了吗？很明显，`id` 选择器的权重要比元素选择器高。这也就是为什么有时候你的 CSS 样式看上去没有生效的原因。你可以在 Vitaly Friedman 的文章中阅读更多细节：“[关于 CSS 权重，你应该知道的](https://www.smashingmagazine.com/2007/07/css-specificity-things-you-should-know/)”。

代码库越大，类的数量也就越多。新的类可能会生效，或者基于权重原理覆盖掉其他样式，所以你就能够发现随着类的数量增多，代码维护会变得非常困难。初次之外，和我们使用其他语言一样，我们还要处理代码结构和可维护性。我们可以使用原子设计，组件，模版引擎等等；它们对于 CSS 也同等需要，所以我们有不同的方法来解决这些问题。

### 块级元素修饰符（BEM）

> “BEM 是一种设计方法论，它能够帮助你在前端开发中，创建可复用的组件以及可共享的代码。”
> 
> —— getbem.com

BEM 的核心思想是，在应用的概念之外创建可以复用的独立的组件。更深入地说，它的设计过程和原子设计很类似：将事物模块化，并将其作为可复用的组件。

我选择将 BEM 作为管理样式第一课的原因是，它的方式和 React 非常类似（我对 React 非常熟悉了），它们都将应用分解为可以复用的组件。

![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f057bd36-3a9b-4d57-b352-4a563587aaca/bem-ex.png)

#### 使用 BEM

BEM 其实就是一种指导思想：它不是一个新的框架，也不是一种新的语言，它只是使用了一种命名规范的 CSS，可以将代码组织得更好。遵从 BEM 的方法论，你可以在 CSS 中实现你已经使用过的模式，但却是以更有调理的方式实现的。同时因为 BEM 不需要额外的工具配置和任何复杂的操作，你也可以很轻松的为你已经写好的代码库进行渐进式的升级。

#### 优势

* BEM 的核心是管理可重用的组件，防止随机全局样式覆盖其他的样式。所以最后我们能得到更好预测的代码，能够解决很多因权重而覆盖了样式这方面的问题。
* 学习成本不高；就是我们熟悉的 CSS 以及几个能够提高可维护性的指导思想。只需要使用 CSS 本身就可以将代码模型化，非常简单。

#### 缺点

* 虽然能够提高复用性和可维护性，但是 BEM 的命名原则也有副作用，那就是会让类的命名非常困难，消耗时间。
* 组件嵌套层数越多，类名就越长并且难以读懂。深层嵌套或者孙子级元素选择器常常会面临这样的问题。

```html
<div class="card__body">
  <p class="card__body__content">Lorem ipsum lorem</p>
  <div class="card__body__links">
    <!-- 孙子级元素 -->
    <a href="#" class="card__body__links__link--active">Link</a>
  </div>
</div>
```

上文内容只是对 BEM 的概览，并简单介绍了它是如何解决我们在 CSS 中遇到的问题的。如果你想要更深入的了解，可以阅读发布在 Smashing 杂志的文章：“[BEM For Beginners](https://www.smashingmagazine.com/2018/06/bem-for-beginners/)”。

### Sassy CSS（SCSS）

坦白说，SCSS 就是 CSS 高级版。它为 CSS 添加了变量、嵌套选择器、可复用的 mixin 功能，以及 import 功能，这让 CSS 更加像一个编程语言了。于我而言，SCSS 也很容易上手（如果你还没有接触过 SCSS，可以看一看它的[文档](https://sass-lang.com/guide)），并且一旦掌握了那些附加的特性，我就非常乐意使用它们，因为它们让代码编写变得非常方便。SCSS 是一个预处理器，这也就意味着编译的结果还是普通的 CSS 文件；你唯一需要做的就是在构建过程中配置好编译工具。

#### 超级好用的特性

* **Import** 功能让你能将样式表分解到多个文件中去，你可以按照组件/章来分配，也可以是其他任何可读性高的方法。

```css
// main.scss
@import "_variables.scss";
@import "_mixins.scss";

@import "_global.scss";
@import "_navbar.scss";
@import "_hero.scss";
```

* **Mixin 功能**、**循环** 和 **变量** 能够帮助你复用代码，并让书写 CSS 的过程更加简便。

```css
@mixin flex-center($direction) {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: $direction;
}

.box {
  @include flex-center(row);
}
```

**注**：**关于 SCSS 的 mixin 功能：在[这里](https://sass-lang.com/guide)可以查看更多 SCSS 的便捷特性。**

* 嵌套选择器大大提高了代码的可阅读性，因为它和 HTML 元素的结构一致了：都是嵌套的模式。这种方法能够让你一眼看出样式的层级关系。

#### SCSS 和 BEM 一起使用

将不同组件的代码分组到不同的代码块中是可以实现的，SCSS 同 BEM 一起使用可以大大提高可读性，并且可以轻松编写出 BEM。

![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/9faa139e-870f-4e22-bb7f-eb0e8f7d6bb2/bem-scss.png)

对比于右边的多层级代码，左边这段代码相对小巧简单得多。

**注**：**如果你想深入了解它是如何运作的，可以读一读 Victor Jeman 的“[BEM with Sass](https://assist-software.net/blog/css-guideline-tutorial-bem-sass)”教程。**

### Styled-Components

它是使用最广泛的 CSS-in-JS 类型仓库之一。不吹不黑，它对我而言真的非常实用，它的很多特性都满足了我的需求。花时间搜索不同的库并找到最适合你的，这真的很值得。

我认为将 styled-components 和普通 CSS 对比来看是一个很好的学习方式。下面是如何应用 styled-components 以及它解决了什么问题的一个概览：

styled-components 没有为元素添加类，它让每个有类名的元素都成为了一个组件。代码看上去要比需要长类名的 BEM 整洁很多。

有趣的是，styled-components 的原理其实是为每个指定元素添加相关的类。这实质上就是我们在样式表中做的事（注意这和内联样式无关）。

```css
import styled from 'styled-components';
    
const Button = styled.button`
  background-color: palevioletred;
  color: papayawhip;
`;

// Output
<style>
  .dRUXBm {
    background-color: palevioletred;
    color: papayawhip;
  }
</style>

<button class="dRUXBm" />
```

**注**：**styled-components 原理：在 Max Stoiber 的文章“[Writing your styles in JS ≠ writing inline styles](https://mxstbr.blog/2016/11/inline-styles-vs-css-in-js/)”中，你可以阅读更多关于内联样式和 CSS-in-JS 的内容。**

#### 为什么 Styled-Components 是 CSS-In-JS 中应用最为广泛的库之一呢？

关于样式问题，我们只需要用普通的 CSS 语法来使用模版库。所以你可以使用 JavaScript 的全部功能来处理样式问题：可以将条件、属性作为参数传入（和 React 的方法类似），并且实际上这些功能也全都可以通过 JavaScript 来实现。

SCSS 有变量、mixin、嵌套以及其他特性，而 styled-components 的功能有增无减，它变得更加强大。它的方法基本是基于组件的，所以第一眼看可能会被它吓住，因为它和传统的 CSS 很不一样。但是一旦你熟悉了它的原则和技术，你将会意识到，所有 SCSS 能做的 styled-components 都能做到，甚至更多。而这时你只需要使用 JavaScript。

```css
const getDimensions = size => {
  switch(size) {
    case 'small': return 32;
    case 'large': return 64;
    default: return 48;
  }
}

const Avatar = styled.img`
  border-radius: 50%;
  width: ${props => getDimensions(props.size)}px;
  height: ${props => getDimensions(props.size)}px;
`;

const AvatarComponent = ({ src }) => (
  <Avatar src={src} size="large" />
);
```

**注**：**styled-components 模版库让你能直接使用 JS 实现不同条件下的样式以及更多功能。**

另一个需要说明的是，styled-components 和当前模块化的网页非常完美的契合了。每个 React 组件都有自己的功能，它可以使用 JavaScript、JSX 模版，现在又有了 CSS-in-JS 来指定样式：这个组件可以自己实现所有的功能，在内部就可以处理一切组件相关的事物了。

不用我提醒，这就是我们寻找了很久的权重问题的解决方案。BEM 只是一个指导思想，强制规定了元素和样式基于组件的结构，但它依旧有赖于类，styled-components 则加强了它。

我觉得 styled-components 的几个附加特性非常实用：主题，它可以配置全局属性或者变量，这些属性和变量可以被传递到每一个组件中；自动添加前缀；以及自动清理没有使用过的代码。另外超高的支持度和活跃的社区也只是 styled-components 众多优势中冰山一角。

**注**：**styled-components 还有很多可以学习和应用的方面。更多内容详见 [styled-components](https://www.styled-components.com/) 文档。**

##### 特性概览

* 模版语言服务于 CSS 语法，和传统 CSS 语法一样。
* 它强制要求代码符合模块化的设计
* 通过帮你处理类名，能够解决权重的问题。
* 所有能用 SCSS 完成的，以及更多的功能，现在都可以用 JS 实现。

##### 可能不太适用的场景

* 很显然，它需要依赖 JavaScript，这也就意味着如果没有它，样式就不会加载，这可能导致样式混乱。
* 可读性很好的类名被替换为毫无疑义的 hash 字符串。
* 组件的概念而不是级联的类名可能会让人更难以理解，尤其是这种思维的转变可能对代码安排有比较大的影响。

### 设计系统

随着网页组件的兴起和对[原子设计](http://atomicdesign.bradfrost.com/chapter-2/)（基本思想是将 UI 打破为基本的构建单元）的需求增加，很多公司都选择创建组件库和设计系统。与能够处理上述的样式问题的技术和方法不同，设计系统代表了一种组织方法，能够处理整个平台或应用中的组件和设计一致性的问题。

或许可以使用我们在设计系统中讨论过的方法来管理样式，但是设计系统本身侧重于的是构建应用的单元块而不是内部实现。

> “设计系统实际上是可以应用于设计和代码的规则、约束条件和原则们的集合。”

设计系统和组件库都针对于跨越不同平台和媒介的整个系统，并能够决定整个公司本身的前景。

> “设计系统是样式，组件和理念表达的合体。”

![IBM’s Carbon design system](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e3afb514-9b7d-42d7-bb86-24f731495b07/carbon-design-system-preview.png)

IBM 的 Carbon 设计系统

技术企业一旦获得了动力支持，有时候就必须非常快速的扩大规模，但是对于设计和研发团队来说，想要跟上企业的发展速度就非常困难了。不同的应用、各种新的特性纷至沓来，当企业需要的时候，不断重新评估、更改以及功能增强，这些都要尽可能迅速的交付。

以一个简单的弹窗为例；例如，某界面包含一个确认弹窗，它非常简单，只是接受一个用户的肯定或否定的行为作为参数。它的代码来自于开发者 A。接下来，在设计团队交付的另一个界面上，弹窗需要包含一个带有数个输入框的表单 —— 开发者 B 完成这部分工作。A 和 B 的工作是分开进行的，他们并不知道对方也在开发相同的模式，于是构建出了两个基于相同底层功能的不同的组件。如果不同的开发者都在不同的界面上进行开发，我们甚至可能会看到不同的人提交给代码库的 UI 都变得不一致了。

更不必想，一个拥有众多开发者和设计者的大公司会怎样了 —— 结果肯定是组件和工作流中都是不同的独立的组件，而不是人们所期待的那样具有一致性。

设计系统的主要准则就是帮助企业达成这样的需求：构建并交付新的特性、功能甚至是全部应用，同时能维护标准、高质量、具有一致性的设计。

这里是一些流行的设计系统的实例：

* [Shopify Polaris](https://polaris.shopify.com/)
* [IBM’s Carbon](https://www.carbondesignsystem.com/)
* [Alibaba’s Ant D](https://ant.design/)
* [Mailchimp Design](https://mailchimp.com/design/)

尽管设计系统本身不仅仅是一个组件集合，但是当我们专门讨论样式问题的时候，应该会对组件库的部分更加感兴趣。组件能够在内部就处理好它的功能、模版以及样式。工作于应用级别的开发者不需要关注所有组件内部的运作，只需要知道如何在应用里把它们组装起来即可。

现在让我们想象一下，这些组件中的一些能够更进一步，它们能够被复用并且可维护性很好，然后将它们组织为一个库。此时开发应用就是把组件拖过去然后放下那么简单了（其实这么说也并不非常确切，但是在应用中使用一个组件可以不必顾虑其内部的工作）。这其实就是组件库在做的事情。

![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d8d03aa4-4bbc-4d25-835f-aa14b2b89222/carbon-components-react.png)

![](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c8ae26ea-99fb-4e2c-87d3-99b0af5ac516/carbon-design-system-react-storybook.png)

#### 为什么人们会想要构建设计系统

* 如前文所述，它能帮助工程师和设计团队跟上企业快速变化的节奏，同时维护代码的标准和质量。
* 它保证了全局设计和代码的一致性，能够在长时间内相当程度地帮助你保持可维护性。
* 设计系统最棒的特性就是它让设计和开发团队配合更紧密，从而让工作协作更流畅。它将过去那种，给研发者数页的实体模型，让他们从头开始研发的模式淘汰了，现在组件和组件的行为已经是经过充分定义的。这是一种完全不同的方式，同时也是更好更快研发具有一致性的界面的方式。

#### 为什么有时候对于你它并不是最佳选择

* 设计系统需要提前投入大量的时间和精力来从头将一切安排好 —— 代码和设计都要很明智。除非真的需要，拖延开发进度，而先来专注于构建设计系统可能并不值得。
* 如果项目相对比较小，实际上只需要几个标准和指导方针就可以保证一致性，那么设计系统可能会增加不必要的复杂度，从而导致浪费。由于很多著名的公司都采纳的设计系统，这种现象可能会影响开发者，让他们觉得这是最好的方式，而忘记了分析项目实际需求，并确认它是不是真的可行。

![Different appearances of a button](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/48392d62-fec1-4d5a-a538-3424be363c46/ibm-buttons-dp.png)

按钮的不同外观

### 总结

样式的应用是一个完整的世界，但是却经常不那么被人关注和重视。现在的应用大多有复杂的用户交互界面，如果不考虑样式问题，它迟早会变得一团乱，它的一致性会减弱，那么代码的增加和修改都会变得很困难。

总结一下我们讨论的内容：BEM，以及 SCSS 能够帮助你更好的管理样式表，它们为 CSS 带来了编程的新方法，并以最少的配置创建了有意义的类名结构，使代码更加整洁。使用像 React 或者 Vue 这样的前端框架搭建应用，如果你觉得基于组件的方法很顺手，你或许能发现，使用 CSS-in-JS 库来处理类名问题非常方便，它将所有权重问题都解决了，并且还有数个其他的优势。对于更大的应用和多平台项目，你或许应该考虑结合其他方法构建设计系统，这样可以加速开发速度并同时保证代码可维护的统一性。

实质上，方法的选择还是要依赖于你的需求和项目的大小，花时间来决定对你来说最好的方法，这是非常重要的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
