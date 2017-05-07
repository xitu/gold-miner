> * 原文地址：[CSS in JavaScript: The future of component-based styling](https://medium.freecodecamp.com/css-in-javascript-the-future-of-component-based-styling-70b161a79a32)
> * 原文作者：本文已获原作者 [Jonathan Z. White](https://medium.freecodecamp.com/@JonathanZWhite) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[bambooom](https://github.com/bambooom)
> * 校对者：[Aladdin-ADD](https://github.com/Aladdin-ADD)、[reid3290](https://github.com/reid3290)

# JavaScript 中的 CSS：基于组件的样式的未来

![](https://cdn-images-1.medium.com/max/1000/1*yVKDbwtvfoakj3RZ9g8ARQ.png)

图片所属 [@jonathanzwhite](https://twitter.com/JonathanZWhite)

使用行内样式使我们可以获得 JavaScript 的所有编程支持。这让我们获得类似 CSS 预处理器（变量、混入和函数）的好处，它也解决了 CSS 的很多问题，如全局命名空间和样式冲突。

如果想要更深入了解 JavaScript 中的 CSS 所解决的问题，可以查看著名的演示幻灯：[React：JS 中的 CSS](https://speakerdeck.com/vjeux/react-css-in-js)。有关使用 Aphrodite 性能优化的案例研究，你可以阅读 [行内 CSS 在可汗学院：Aphrodite](http://engineering.khanacademy.org/posts/aphrodite-inline-css.htm)。如果想要学习更多有关 JavaScript 中的 CSS 的最佳实践，可以阅读 [Airbnb 的风格指南](https://github.com/airbnb/javascript/tree/master/css-in-javascript)。

此外，我们将使用行内 JavaScript 样式来构建组件，以解决我之前的一篇文章（[掌握设计之前，必须掌握基本原理](https://medium.freecodecamp.com/before-you-can-master-design-you-must-first-master-the-fundamentals-1981a2af1fda)）中涉及的一些基础设计问题。

### 一个启发性的例子 ###

让我们从一个简单的例子开始：构建一个按钮并给它添加样式。

一般来说，组件及其样式在同一个文件中：`Button` 和 `ButtonStyles`。这是因为他们都属于视图层。但是，下面的例子中，我将代码拆分成多个代码片段，以便更容易理解。

下面就是按钮组件：

```javascript
...

function Button(props) {
  return (
    <input
      type="button"
      className={css(styles.button)}
      value={props.text}
    />
  );
}
```

它没什么特别的，只是一个无状态的 React 组件。Aphrodite 起作用的地方是在 `className` 属性中。`css` 函数接受一个 `styles` 对象为参数并将其转换为 `css`。`styles` 对象是由 Aphrodite 的函数 `StyleSheet.create({ ... })` 创建的，你可以用 [Aphrodite playground](https://output.jsbin.com/qoseye?) 来查看这个函数的输出结果。

**下面是按钮的样式表：**

```javascript
...

const gradient = 'linear-gradient(45deg, #FE6B8B 30%, #FF8E53 90%)';

const styles = StyleSheet.create({
  button: {
    background: gradient,
    borderRadius: '3px',
    border: 0,
    color: 'white',
    height: '48px',
    textTransform: 'uppercase',
    padding: '0 25px',
    boxShadow: '0 3px 5px 2px rgba(255, 105, 135, .30)',
  },
});
```

Aphrodite 的优势之一是迁移很直观，学习曲线较平缓。类似 `border-radius` 变成 `borderRadius`，值变成字符串，伪类选择器、媒体查询、字体定义都可以正常工作。另外也可以自动添加浏览器引擎前缀。

**下面就是按钮的样子：**

![](https://cdn-images-1.medium.com/max/800/1*x1ccRv9UGvcxBvz4TvC4Qg.png)

以这个例子为基础，**让我们来看看如何使用 Aphrodite 来构建一个基本的视觉设计系统**，着重关注排版和间距两个设计基础元素。

### 设计基础第一部分：排版 ###

我们先从排版开始，这是设计基础要素。**第一步是定义排版常数**。与 Sass 及 Less 不一样，Aphrodite 的常数可以直接放在 JavaScript 中或 JSON 文件中。

#### 定义排版常数

在定义常量时，**使用语义化的变量名**。例如，在给字体大小命名时，不要使用 `h2`，使用 `displayLarge` 描述它的作用。类似的，不要给字体粗细命名 `600`，使用 `semibold` 描述它的效果。

```javascript
export const fontSize = {
  // heading
  displayLarge: '32px',
  displayMedium: '26px',
  displaySmall: '20px',
  heading: '18px',
  subheading: '16px',

  // body
  body: '17px',
  caption: '15px',
};

export const fontWeight = {
  bold: 700,
  semibold: 600,
  normal: 400,
  light: 200,
};

export const tagMapping = {
  h1: 'displayLarge',
  h2: 'displayMedium',
  h3: 'displaySmall',
  h4: 'heading',
  h5: 'subheading',
};

export const lineHeight = {
  // heading
  displayLarge: '48px',
  displayMedium: '48px',
  displaySmall: '24px',
  heading: '24px',
  subheading: '24px',

  // body
  body: '24px',
  caption: '24px',
};
```

设置正确的字体大小和行高变量的值是很重要的。这是因为他们直接影响了设计的垂直韵律。垂直韵律是一个能帮助你实现一致的元素间距的概念。

想要了解更多有关垂直韵律的内容，你可以阅读这篇文章：[为什么垂直韵律对排版实践很重要？](https://zellwk.com/blog/why-vertical-rhythms/)

![](https://cdn-images-1.medium.com/max/800/1*Ehj9XMvQ9wJNhxWNqwXfKw.png)

[上图：行高计算器](https://drewish.com/tools/vertical-rhythm/)

选择行高以及字体大小的背后是有科学原理的。我们可以使用比率生成一组可能的值。几周前，我写了一篇文章，详细地介绍了方法细节（[排版可以成就设计，也可以毁了设计](https://medium.freecodecamp.com/typography-can-make-your-design-or-break-it-7be710aadcfe)）。你可以使用 [Modular Scale](http://www.modularscale.com/) 确定字体大小，使用 [vertical rhythm calculator](https://drewish.com/tools/vertical-rhythm/) 计算行高。

#### 定义标题组件 ####

定义好了排版常量后，下一步就是使用它们创建一个组件。**这个组件的目标是对整个代码库中的标题实现一致的设计**。

```javascript
import React, { PropTypes } from 'react';
import { StyleSheet, css } from 'aphrodite/no-important';
import { tagMapping, fontSize, fontWeight, lineHeight } from '../styles/base/typography';

function Heading(props) {
  const { children, tag: Tag } = props;
  return <Tag className={css(styles[tagMapping[Tag]])}>{children}</Tag>;
}

export default Heading;

export const styles = StyleSheet.create({
  displayLarge: {
    fontSize: fontSize.displayLarge,
    fontWeight: fontWeight.bold,
    lineHeight: lineHeight.displayLarge,
  },
  displayMedium: {
    fontSize: fontSize.displayMedium,
    fontWeight: fontWeight.normal,
    lineHeight: lineHeight.displayLarge,
  },
  displaySmall: {
    fontSize: fontSize.displaySmall,
    fontWeight: fontWeight.bold,
    lineHeight: lineHeight.displaySmall,
  },
  heading: {
    fontSize: fontSize.heading,
    fontWeight: fontWeight.bold,
    lineHeight: lineHeight.heading,
  },
  subheading: {
    fontSize: fontSize.subheading,
    fontWeight: fontWeight.bold,
    lineHeight: lineHeight.subheading,
  },
 }); 
```

`Heading` 组件是一个无状态的函数，接收一个标签作为属性，并返回这个标签连带它的样式。我们在前面的常量中定义了标签映射，所以这是可行的。

```javascript
...
export const tagMapping = {
  h1: 'displayLarge',
  h2: 'displayMedium',
  h3: 'displaySmall',
  h4: 'heading',
  h5: 'subheading',
};
```

在组件文件的下方我们定义了 `styles` 对象，我们就是在此处使用排版常量的。

```javascript
export const styles = StyleSheet.create({
  displayLarge: {
    fontSize: fontSize.displayLarge,
    fontWeight: fontWeight.bold,
    lineHeight: lineHeight.displayLarge,
  },
  
  ...
});
```

`Heading` 组件是这样调用的：

```javascript
function Parent() {
  return (
    <Heading tag="h2">Hello World</Heading>
  );
}
```

通过这种方法，**我们可以减少类型的意外变化**。通过取消全局样式以及标准化标题，我们避免了上百种字体大小的问题。此外，这种方法还可以应用于构建 `Text` 组件。

### 设计基础第二部分：间距 ###

**间距同时控制着设计中的垂直与水平韵律**。所以间距对建立视觉设计系统至关重要。和排版部分一样，第一步也是设定间距常量。

#### 定义间距常量 ###

当为元素之间的 margin 定义间距常量时，我们可以采取一种数学方法。使用一个 `spacingFactor` 常量来生成一组距离。**这种方法确保元素之间的间距是有逻辑并且一致的**。

```javascript
const spacingFactor = 8;
export const spacing = {
  space0: `${spacingFactor / 2}px`,  // 4
  space1: `${spacingFactor}px`,      // 8
  space2: `${spacingFactor * 2}px`,  // 16
  space3: `${spacingFactor * 3}px`,  // 24
  space4: `${spacingFactor * 4}px`,  // 32
  space5: `${spacingFactor * 5}px`,  // 40
  space6: `${spacingFactor * 6}px`,  // 48

  space8: `${spacingFactor * 8}px`,  // 64
  space9: `${spacingFactor * 9}px`,  // 72
  space13: `${spacingFactor * 13}px`, // 104
};
```

上面的例子采用了线性关系，从 1 到 13。不管怎样，多试验几种不同的尺度和比例的搭配才能找到合适的方案。目的、受众、目标设备的不同都需要在设计时考虑。**下面是使用黄金比率计算出来的前 6 个距离**，以 `spacingFactor` 等于 8 为例。

    Golden Ratio (1:1.618)

    8.0 x (1.618 ^ 0) = 8.000
    8.0 x (1.618 ^ 1) = 12.94
    8.0 x (1.618 ^ 2) = 20.94
    8.0 x (1.618 ^ 3) = 33.89
    8.0 x (1.618 ^ 4) = 54.82
    8.0 x (1.618 ^ 5) = 88.71

下面是在代码中如何写间距比例。我添加了一个帮助处理间距计算结果的函数，它会返回其最近的像素值。

```javascript
const spacingFactor = 8;
export const spacing = {
  space0: `${computeGoldenRatio(spacingFactor, 0)}px`,  // 8
  space1: `${computeGoldenRatio(spacingFactor, 1)}px`,  // 13
  space2: `${computeGoldenRatio(spacingFactor, 2)}px`,  // 21
  space3: `${computeGoldenRatio(spacingFactor, 3)}px`,  // 34
  space4: `${computeGoldenRatio(spacingFactor, 4)}px`,  // 55
  space5: `${computeGoldenRatio(spacingFactor, 5)}px`,  // 89
};

function computeGoldenRatio(spacingFactor, exp) {
  return Math.round(spacingFactor * Math.pow(1.618, exp));
}
```

定义好间距常量后，我们就可以用它们给元素添加间距。**一种方法就是在组件中 import**。

例如，下面我们给 `Button` 组件添加 `marginBottom`。

```javascript
import { spacing } from '../styles/base/spacing';

...

const styles = StyleSheet.create({
  button: {
    marginBottom: spacing.space4, // 使用间距常量来添加 margin
    ...
  },
});
```

多数情况下这都是有效的。但是如果我们想要根据按钮的位置来修改它的 `marginBottom` 属性呢？

实现可变边距的一种方法是覆盖从父组件继承的样式。另一种方法是**创建一个 `Spacing` 组件来控制元素的垂直边距**。

```javascript
import React, { PropTypes } from 'react';
import { spacing } from '../../base/spacing';

function getSpacingSize(size) {
  return `space${size}`;
}

function Spacing(props) {
  return (
    <div style={{ marginBottom: spacing[getSpacingSize(props.size)] }}>
      {props.children}
    </div>
  );
}

export default Spacing;
```

这种方法可以将设置边距的任务从子组件转移到父组件上。**这样，子组件就对布局无感知了，它不需要知道将被放置在何处及与其他元素的关联**。

由于按钮、输入框、卡片等组件可能需要可变的间距，所以这种方法是有效的。例如，表单中的按钮可能比导航栏的按钮需要更大的边距。需要注意的是，如果一个组件始终具有一致的边距，那么在组件内部处理边距更好。

你可能注意到前面的例子中只使用了 `marginBottom` ，这是因为**在一个方向定义所有的垂直边距可以避免边距合并，并能跟踪垂直韵律**。你可以从 Harry Robert 的文章 [单向边距声明](https://csswizardry.com/2012/06/single-direction-margin-declarations/) 中了解更多这方面知识。

最后，你还可以使用间距常量来定义 padding。

```javascript
import React, { PropTypes } from 'react';
import { StyleSheet, css } from 'aphrodite/no-important';
import { spacing } from '../../styles/base/spacing';

function Card(props) {
  return (
    <div className={css(styles.card)}>
      {props.children}
    </div>
  );
}

export default Card;

export const styles = StyleSheet.create({
  card: {
    padding: spacing.space4}, // using spacing constants as padding
    
    background: 'rgba(255, 255, 255, 1.0)',
    boxShadow: '0 3px 17px 2px rgba(0, 0, 0, .05)',
    borderRadius: '3px',
  },
});
```

对 margin 和 padding 使用相同的间距常量，可以在设计中实现更好的视觉一致性。

结果大致如下：

![](https://cdn-images-1.medium.com/max/800/1*oDkbVmgCJ4ss5fuRNvzoUg.png)

现在你已经大致了解 JavaScript 中的 CSS 了，去试验一下吧。尝试在下个项目中采用行内 JavaScript 样式吧。我想**你会喜欢上能够在同一个上下文中处理所有样式及视图问题的感觉**。

有关 CSS 和 JavaScript 的主题中，你对什么新的发展感兴趣呢？我个人对 async/await 非常感兴趣。给我留言或者在  [Twitter](https://twitter.com/jonathanzwhite) 上发信息给我吧。

你可以在 Medium 上找到我，我每周都会发布一篇文章。你也可以在 [Twitter](https://twitter.com/jonathanzwhite) 上关注我，我会在那里发布一些有关设计、前端开发和虚拟现实的随笔。

**如果你喜欢这篇文章，欢迎给我点赞 ❤ 并分享给朋友，非常感谢！**

[![](https://cdn-images-1.medium.com/max/600/1*mxQhZLqG7l5dMLvxYAklgw.png)](http://mrwhite.space/signup)

[![](https://cdn-images-1.medium.com/max/600/1*UOsjAdUZ9O0QSyfXOpQPbA.png)](https://twitter.com/JonathanZWhite)
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
