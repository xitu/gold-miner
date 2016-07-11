> * 原文链接 : [Your Timeline for Learning React](https://daveceddia.com/timeline-for-learning-react/)
* 原文作者 : [DAVE CEDDIA](https://daveceddia.com/timeline-for-learning-react/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [aleen42](http://aleen42.github.io/)
* 校对者: [llp0574](https://github.com/llp0574), [jiaowoyongqi](https://github.com/jiaowoyongqi)

以下所谈及的，就是为你定制的 React 学习路线。

为了能稳固基础，我们一定要逐步地来进行学习。

倘若你正在建造一间房子，那么为了能快点完成，你是否会跳过建造过程中的部分步骤？如在具体建设前先铺设好部分石头？或直接在一块裸露的土地上先建立起墙面？

又假如你是在堆砌一个结婚蛋糕：能因为上半部分装饰起来更有趣，而直接忽略了下半部分？

不行吗？

当然不行。众所周知，这些做法只会导致失败。

因此，不要想着通过接触 React 来将 ES6 + Webpack + Babel + React + Routing + AJAX 这些知识一次性学好。因为想一下，就能明白这难道不正是导致学习失败的原因吗？

既然我把该文章称作是一条学习路线，那么每一次都应该走好每一步。既不要尝试去跨越，也不要贪步。

一步一脚印。若把其置身于每一天的那么一点时间，那么也许几周就能把整个学习完成。

制定该路线的主要目的在于：使你在学习过程中避免头脑不堪重负。因此，请脚踏实地地去学习 React 吧。

当然，你也可以为整个学习过程[制定一个可打印的 PDF 文件](https://daveceddia.com/timeline-for-learning-react/#signup-modal)，以便在学习过程中能够查记。

## 第零步：JavaScript


在学习之前的你，理应对 JavaScript 有所了解，或至少是 ES5 标准下的 JavaScript。可若了解甚少，那么，你就应该停下手头上的工作，学习好该[基础部分](https://developer.mozilla.org/en-US/Learn/Getting_started_with_the_web/JavaScript_basics)后，*才可*迈步前行。

可倘若早已熟知 ES6 所带来的新特性，那么请继续。因为如你所料，React 的 API 接口在 ES5 和 ES6 两标准间存在着较大的差异性。所以对于你来说，熟悉两种标准其特性的不同至关重要。尽管发生了异常，你也可以通过两种标准之间的转换，寻找出广泛有效的答案。

## 第半步：NPM

NPM 在 JavaScript 世界中，可谓是软件管理方的王者。然而，在这里你却并不需要学习太多关于 NPM 自身的东西。只要在安装好后 [（连同 Node.js）](https://nodejs.org)，学习如何使用其安装软件即可。（`npm install <package name>`）

## 第一步：React

学习一个新的编程技术，我们往往会从熟悉的 [Hello World](https://daveceddia.com/test-drive-react) 教程开始。首先，我们可以通过使用 React 官方教程所展示的原生 HTML 文件来实现，而该文件包含有一些 `script` 标签。其次，我们还可以通过使用像 React Heatpack 这样的工具来快速上手。

尝试一下该[三分钟运行起 Hello World 的教程](https://daveceddia.com/test-drive-react)。

## 第二步：构建后摒弃

由于这一步是一个棘手的中间过程，所以往往会有大量的人忽略了该步。

谨记，请勿犯这样的错误。因为，倘若对 React 的概念没有一个稳固的掌握而擅自前行，那么，最后只会对自己的大脑搪塞过多的知识，以致遗忘。

当然，该步需要一定时间的斟酌：该构建什么呢？是工作中的一个原型项目？还是能贴合于整个框架的一些 Facebook 克隆项目呢？

其实，我们应该构建的都不是这些项目。因为，它们要不是包裹过甚，以致无甚可学；要不是过于庞大，以致成本过高。

尤其是工作中的“原型项目”，它们更为糟糕。因为在你心目中，*早已明白*这些项目并不会占有一席之地。况且，该类项目往往会长期驻留在原型阶段，或变成线上的软件。最终，你将无法摒弃或重写。

此外，把原型项目当作学习的项目将会为带来大量的烦恼。对于你来说，你可能会就*未来的因素*考虑一切可能发生的事情。而当你*认为*这不仅仅是一个原型的时候，你就会产生疑惑 —— 是否要测试一下呢？我应该要保证架构能延伸扩展……我需要延后重构的工作吗？还是不进行测试呢？

为了解决该问题，我希望能用上我所写的一篇指引《[为 Augular 开发者所准备的 React](https://daveceddia.com/react-for-angular-developers)》：一旦你完成了 “Hello World” 的基础课程，你将如何去学习 ”think in React” 的课程。

在这里，我有一些个人的提议给到大家：那就是，理想的项目是介乎于 “Hello World” 和 ”All of Twitter“ 之间。

另外，请尝试去构建一些官方文档列表中所展示的项目（TODOs、beers、movies），然后，借此学会数据流（data flow）的工作原理。

当然，你也可以把一些已有的大型 UI 项目（Twitter、Reddit、Hacker News等）分割成一小块来构建 —— 即把其瓜分成组件（components），并使用静态的数据去进行构建。

总的来说，我们需要构建的，理应是一些小型且可被摒弃的应用程序项目。这些项目*必须是*可摒弃的。否则，你将深陷于一些不为重要的东西，如可维护性和代码结构等。

值得提醒的是，如果你曾经[订阅于](https://daveceddia.com/timeline-for-learning-react/#signup-modal)我，那么当《[为 Angular 开发者准备的 React](https://daveceddia.com/react-for-angular-developers)》发布的时候，你将会第一时间收到通知。

## 第三步：Webpack

构建工具是学习过程中的一个主要的难点。搭建 Webpack 的环境会让你感觉是一件*繁杂的工作*，而且，完全不同于 UI 代码的书写。这就是为什么我要将 Webpack 放在了整个学习路线的第三步，而不是第零步。

在这里，我推荐一篇名为《[Webpack —— 令人疑惑的地方](https://medium.com/@rajaraodv/webpack-the-confusing-parts-58712f8fcad9)》的文章，作为对 Webpack 的简介。此外，该文章还讲述了 Webpack 本身所具有的一些思考方式。

一旦你清楚 Webpack 所负责的工作（打包生成*各种的文件*，而不仅仅是 JS 文件） —— 以及其中的工作原理（适用于各种文件类型的加载器），那么，Webpack 对于你来说将会是一个更为欣喜的部分。

## 第四步：ES6

如今，进入了整个路线的第四步。上述的所有将会作为下面的*铺垫*。之前，在学习 ES6 过程中，所学到的部分也将会让你写出更为利落简洁的代码 —— 以及性能更高的代码。回想起一开始那时候，某些问题本不应卡住在那 —— 但现在的你，已然清楚知道为啥 ES6 能完美地融合在其中。

在 ES6 中，你应该学习一些常用的部分：箭头函数（arrow functions）、let/const、类（classes）、析构（destructuring）和 `import`

## 第五步：Routing

有些人会把 React Router 和 Redux 这两个概念混为一谈 —— 但是，它们之间并没有任何的关系或依赖。因此，你可以（也理应）在深入 Redux 之前学习如何去使用 React Router。

由于在之前“think in React”的教程中，积累了坚实的基础。因此，相比于第一天学习 React Router，我们此时更能从基于组件（component-based）的构建方式中，领悟出更多的精髓。

## 第六步：Redux

Dan Abramov，作为 Redux 的创造人，他[会告诉你们](https://github.com/gaearon/react-makes-you-sad)不要过早地接触 Redux。其实，这是有缘由的 —— Redux 其复杂度在早期的学习过程中，将会带来灾难性的影响。

虽然，在 Redux 背后所隐藏着的原理相当简单，但想要从理解跃至实践，却是一个很大的跨度。

因此，重复第二步所做的：构建一次性的应用程序。通过些许的 Redux 经验，去逐渐理解其背后的工作原理。

## 非步骤

在前面列出的步骤中，你曾否看见过”选择一个模板项目“的字眼吗？并没有。

若仅通过挑选大量模板项目中的其中一个，去深入学习 React。那么，后面将只会带来大量的疑惑。虽然这些项目会含有一切可能的库，且规定要求一定的目录结构 —— 但对于小型的应用程序，或开始入门的我们来说，并不需要。

也许你会说，“Dave，我可并不是在构建一个小应用。我所构建的，是一个服务于上万用户级别的复杂应用！”……那么，请你重新阅读一下关于原型的理解

## 该如何应对

对于 React 来说，虽然有大量的学习计划需要采取，且有大量的东西需要学习 —— 但一切需要循规蹈矩，一步一脚印。

虽说我已提供了一系列的步骤，那如果你在学习的过程中会忘记了步骤的顺序或跳过了某一步，那怎么办？

你会想，要是有一个能监督的方式就最好了……

的确是有：我已经把上述的学习路线整理成一个可打印的 PDF 文件，您仅需注册便可获取！
