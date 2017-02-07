> * 原文地址：[A 5-minute Intro to Styled Components](https://medium.freecodecamp.com/a-5-minute-intro-to-styled-components-41f40eb7cd55#.z1nrxe1zr)
* 原文作者：[Sacha Greif](https://medium.freecodecamp.com/@sachagreif)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# A 5-minute Intro to Styled Components

![](https://cdn-images-1.medium.com/max/2000/1*DIFji4ZmJa4_H3EpbG2XAw.png)

CSS 很不可思议，你可以在 15 分钟之内就学会一些基础部分，但是如果你要弄清楚一个好的方式来组织你的样式，将会花费数年时间。

这主要是由于语言本身很奇葩。不合常规的是， CSS 是相当有限的，没有变量、循环或者函数。与此同时，它又是相当宽容的，你可以随意使用元素、Class、ID 或它们的任意组合。

### 混乱的样式表

正如你自己所经历的那样，这通常是很混乱的。虽然有诸如 SASS 和 LESS 这样的预处理器添加了大量有用的特性，但是它们仍然不能阻止 CSS 的这种混乱状态。

组织工作留给了像 [BEM](http://getbem.com/) 这样的方法，这些方法虽然很有用但是完全是自选方案，不能在语言或工具级别强制实施。

### CSS 的新浪潮

快进一两年，新一波基于 JavaScript 的工具正试图通过改变编写 CSS 的方式来从根本上解决这些问题。

[Styled Components](https://github.com/styled-components/styled-components) 就是那些工具库之一，因为兼顾创新和传统的优势，它很快就吸引了大量的关注度。因此，如果你是 React 使用者（如果你不是的话，可以看看[我的 JavaScript 学习计划](https://medium.freecodecamp.com/a-study-plan-to-cure-javascript-fatigue-8ad3a54f2eb1) 和我写的 [React 简介](https://medium.freecodecamp.com/the-5-things-you-need-to-know-to-understand-react-a1dbd5d114a3)），就绝对值得看看这个新的 CSS 替代者。

最近我用它[重新设计了我的个人网站](http://sachagreif.com/)，今天我想分享一些我在这个过程中所学到的东西。

### 组件, 样式化

关于 Styled Components 你需要理解的最主要的事情就是其名称应该采取字面意思。你不在根据他们的 Class 或者 HTML 元素来对 HTML 元素或组件进行样式化了。

    <h1 className="title">Hello World</h1>

    h1.title {
      font-size: 1.5em;
      color: purple;
    }

相反，你正在定义一个拥有它们自己的封装风格的 styled Components。然后你就可以在你的代码中自由的使用它们了。

    import styled from 'styled-components';

    const Title = styled.h1`
      font-size: 1.5em;
      color: purple;
    `;

    <Title>Hello World</Title>

这两段代码看起来有一些细微的差别，事实上两者语法是非常相似的。但是它们的关键区别是样式现在是这些组件的一部分啦。

换句话说，我们正在摆脱 CSS class 作为组件和其样式的中间步骤这种情况。

styled-components 的联合创造者 Max Stoiber 说：

> styled-components 的基本思想就是通过移除样式和组件之间的映射关系来实施最佳实践。

### 减少复杂性

这首先是反直觉的，因为使用 CSS 而不是直接定义 HTML 元素的关键点（还记得 `<font>` 标签吗？）是引入 class 这个中间层来解耦样式和标签。

但是这层解耦也创造了很多复杂性。有这样一个的观点：相比于 CSS，诸如 Javascript 这类『真正』的编程语言具备了更好的处理这种复杂性的能力。

### 类（Class）上的 Props

为了遵循 『无类(no-class)』的理念，当涉及到自定义一个组件的行为时，styled-components 使用了 类上的 props（props over classes）。所以呢，代码不是这样的：

    <h1 className="title primary">Hello World</h1> // will be blue

    h1.title{
      font-size: 1.5em;
      color: purple;

      &.primary{
        color: blue;
      }
    }

你需要这样写：

    const Title = styled.h1`
      font-size: 1.5em;
      color: ${props => props.primary ? 'blue' : 'purple'};
    `;

    <Title primary>Hello World</Title> // will be blue

正如你所看到的那样，styled-components 通过保留所有的 CSS 和 HTML 之间的相关实施细节来让你的 React 组件更干净。

也就是说，styled-components 的 CSS 仍然还是 CSS。所以像下面这样的代码也是完全有效的（尽管略微不常用）。

    const Title = styled.h1`
      font-size: 1.5em;
      color: purple;

      &.primary{
        color: blue;
      }
    `;

    <Title className="primary">Hello World</Title> // will be blue

这是一个让 styled-components 很容易就被接受的一个特性：当存在疑惑时，你总是可以倒退回你所知道的知识。

### 警告

要提到的很重要的一点是 styled-components 仍然是一个很年轻的项目。有一些特性到目前为止还没有完全支持。例如，如果你想 [从父组件中样式化一个子组件](https://github.com/styled-components/styled-components/issues/142) 时，目前你仍不得不依靠 CSS class 来实现（至少要持续到 styled-components 版本 2 发布）。

目前也有一个非官方的方法来实现 [服务端预渲染你的 CSS](https://github.com/styled-components/styled-components/issues/124)，虽然它是通过手动注入样式来实现的。

事实上，styled-components 生成它自己的随机 class 名会使你很难通过浏览器的开发工具来确定你的样式最初是在哪里定义的。

但是鼓舞人心的是，styled-components 核心团队已经意识到了这些问题，并且努力地一个又一个的攻克它们。[版本 2 很快就要来啦]((https://github.com/styled-components/styled-components/tree/v2))，我真的很期待它呢。

### 了解更多点

我这篇文章的目的不是向你解释 styled-components 的工作细节，更多的是给你一个小瞥。所以你可以自己决定是否值得一试。

如果我的文章让你感到好奇的话，这里有一些链接你可以了解更多关于 styled-components 的知识。

- Max Stoiber 最近给 [Smashing Magazine](https://www.smashingmagazine.com/2017/01/styled-components-enforcing-best-practices-component-based-systems/) 写了一篇文章有关创建 styled-components 的原因的文章。
- [styled-components repo](https://github.com/styled-components/styled-components) 它自己就有一个很丰富的文档.
- [Jamie Dixon 写的这篇文章](https://medium.com/@jamiedixon/styled-components-production-patterns-c22e24b1d896#.tfxr5bws2) 讲述了切换到 styled-components 的几个好处.
- 如果你想了解更多关于这个库实际上是如何实现的，可以阅读 Max 的 [这篇文章](http://mxstbr.blog/2016/11/styled-components-magic-explained/)。

如果你想更进一步，也可以了解下 [Glamor](https://github.com/threepointone/glamor) —— 一个完全不同的 CSS 新浪潮。
