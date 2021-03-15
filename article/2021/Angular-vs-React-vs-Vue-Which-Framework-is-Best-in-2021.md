> * 原文地址：[Angular vs. React vs. Vue: Which Framework is Best in 2021?](https://dzone.com/articles/angular-vs-react-vs-vue-which-framework-is-best-to)
> * 原文作者：[Sourabh Nagar](https://dzone.com/users/3456681/chapter247.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Angular-vs-React-vs-Vue:-Which-Framework-is-Best-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Angular-vs-React-vs-Vue:-Which-Framework-is-Best-in-2021.md)
> * 译者：[zenblo](https://github.com/zenblo)、[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)

# Angular vs. React vs. Vue：2021 年哪个框架最好？
> 一个是 UI 库（React），另一个是成熟的前端框架（Angular），而其中最年轻的（Vue）则可以称之为渐进式框架。

你可能是一个 React 开发者，一个 Vue 开发者，或者是一个只专注于技术的 Angular 开发者。不过，你还是不能忽视开发社区不断进行的框架比较。有充分的理由认为：一个是 UI 库（React），另一个是成熟的前端框架（Angular），而其中最年轻的（Vue）则可以称之为渐进式框架。每一个框架都拥有一些独特的优势和性能指标，让人们不得不对这三种框架进行对比分析。

这几个框架都是基于组件的，有利于快速创建 UI 功能。它们可以替代使用，都可以用于构建前端应用。然而，它们并非 100% 相同。

这就是为什么我们决定为你创建一个简短的指南，但最重要的是，为你提供一个参考，帮助你在未来进行技术选择。

让我们开始吧！

## **许可证**

当然，在使用一个开源框架或库之前，一定要彻底检查许可证。幸运的是，React、Angular 和 Vue 都使用 [MIT 许可证](https://opensource.org/licenses/MIT)。它提供了有限的重用限制，甚至可以在专有软件中使用。在使用任何框架或软件之前，一定要留心，注意了解许可证的内容。

## **架构设计**

### **Angular**

Angular 框架属于 MEAN 框架，是如今创业公司最热门的技术栈。Angular 是一个完整的基于 TypeScript 的 Web 应用开发框架，主要用于构建单页 Web 应用（SPA）。

与AngularJS —— 早期的框架不同，Angular2 是基于组件的，与 MV* 模式没有什么关联。Angular 的结构方式包括模块、组件和服务。

在 Angular 框架中，每个组件都有一个类或模板，定义了应用逻辑和 MetaData（装饰器）。组件的这些元数据为创建和呈现其视图所需的构件在哪里提供了指引。

Angular 架构的另一个重要因素是，模板是用 HTML 编写的。它们还可能包含 Angular 模板语法，并带有特殊指令以输出响应式数据，并且可能渲染多个元素。

服务 —— Angular 应用中的一个独特元素 —— 被 Components 用于委托业务逻辑任务，如获取数据或验证输入。虽然使用服务并没有严格执行，但是将应用程序结构作为一组可重用的不同服务则是比较明智的。

### **React**

React 是一个开源的前端库，主要用于开发用户界面。这种灵活的前端解决方案并不强制执行特定的项目结构。一个 React 开发者可能只需要几行代码就可以开始使用它。

React 是基于 JavaScript 的，但在大多数情况下，它与 JSX（JavaScript XML）相结合。JSX 是一种语法扩展，允许开发人员同时创建包含 HTML 和 JavaScript 的元素。实际上，开发者可以用 JSX 创建的任何东西也可以用 `React JavaScript API` 创建。React 元素比 DOM 元素更强大，是 React 应用的最小组件。

React 组件是一种构建模块，它决定了在整个 Web 应用中使用独立和可重用的组件。

### **Vue**

用于开发用户界面和单页 Web 应用，Vue 是一个开源的 `Model-View-View-Model` 前端 JavaScript 库，被称为渐进式框架。Vue 与其它工具一起用于前端开发。Vue 的通用性、高性能和它在 Web 应用程序上的最佳用户体验成就了它的流行。

使用 Vue 时，开发者主要在 ViewModel 层上工作，以确保应用数据的处理方式能让框架呈现最新的视图。

Vue 的模板语法将可识别的 HTML 与特殊的指令和功能相结合。该语法允许开发人员创建 View 组件。

现在 Vue 中的组件是小巧、自成一体和可重用的。系统文件检查器（SFC）或扩展名为 .vue 的单文件组件包含 HTML、JavaScript 和 CSS，因此所有相关代码都留在一个文件中。

在大型的 Vue.js 项目中，通常推荐使用 SFC 来组织代码。要将 SFC 移植到工作的 JavaScript 代码中，你需要 Webpack 或 Browserify 这样的构建工具。

## **目标和范围**

### **Angular**

Angular 最适合大型和高级项目。这些可能包括但不限于：

* 开发渐进式 Web 应用程序（PWA）。
* 重新设计网站应用程序。
* 建立基于内容的动态网页设计。
* 创建需要复杂基础架构的大型企业应用程序。

### **React**

React 来自 MERN 堆栈家族 —— 一种以构建复杂的业务应用程序而闻名的技术堆栈。当与 Redux 或 MobX 或任何流量模式库一起使用时，React 能够成为强大的工具。React 最适合以下项目：

* 对于涉及包含导航项目，折叠或展开的手风琴分节，活动或非活动状态，动态输入，活动或非活动按钮，用户登录，用户访问权限等的许多组件的应用程序。
* 对于具有规模和增长范围的项目，因为 React 组件具有声明性，因此可以轻松处理此类复杂结构。
* 当 UI 是网络应用程序的中心时。

### **Vue**

Vue 最适合解决短期问题，因为 Vue 具有可负担且快速的学习曲线。它可以轻松地与现有代码块集成。在以下情况下可能需要 Vue：

* 您需要带有动画或交互式元素的 Web 应用程序的开发项目。
* 无需高级技能即可进行原型制作。
* 需要与多个其他应用程序无缝集成的应用程序。
* 更早推出 MVP。

## **表现和发展**

### **Angular**

Angular 性能方面的一些亮点包括：

* 具有无缝的第三方集成，以增强产品或应用程序的功能。
* 提供强大的组件集合，从而简化了编写，更改和使用代码的过程。
* 它的“提前编译器”赋予了更快的加载时间和安全性。
* MVC 模型通过允许视图分离来帮助减少后台查询。
* 促进将依赖项注入用作将组件解耦的外部元素，从而为可重用性以及简化管理和测试铺平了道路。
* 通过将任务分成逻辑块来减少网页的初始加载时间。
* 完全可定制的设计。
* 便于将 HTML 和 TypeScript 编译为 JavaScript —— 大大加快了代码的编译速度，并将编译提早到远早于浏览器开始加载 Web 应用程序之前。

### **React**

在性能方面，React 与 Vue 相当，因为两者具有相同的架构，即与 DOM 交互。React Web 开发的性能可以评估如下：

* 支持捆绑和 Tree-shaking —— 这对于减少最终用户的资源负载至关重要。
* 由于提供了单向数据绑定支持，因此可以更好地控制项目。
* 可以轻松测试和监视。
* 最适合需要频繁更改的复杂应用程序。

### **Vue**

形容 Vue 的最贴切的词组是令人难以置信的快速。它的一些性能指标是：

* 更快的学习曲线。
* 单页应用程序高效精密。
* 具有高端功能，因而它有多功能性。

## **各自的优点**

### **Angular**

有对模板、表单、引导程序或架构、组件以及组件之间交互的完整的文档：

* 平滑的双向数据绑定。
* MVC 架构。
* 内置模块系统。
* 大大减少了网页的初始加载时间。

**使用 Angular 构建的流行应用程序：**

Youtube TV | PayPal | Gmail | Forbes | Google Cloud

### **React**

* 出于其模块化的结构而使其拥有灵活的代码。节省时间和成本。
* 助力复杂应用程序的高性能的实现。
* 使用 React 前端开发能够更容易去做代码维护。
* 支持适用于 Android 和 iOS 平台的移动端原生应用程序。

**使用 React 构建的流行应用程序：**

Tesla | AirBnB | CNN | Nike | Udemy | Linked-in

### **Vue**

* 体积小巧，便于安装和下载。
* 倘若我们可以正确利用，我们就可以在多处重用 Vue。
* Vue.js 允许我们更新网页中的元素，而无需渲染整个 DOM，因为它是虚拟的 DOM。
* 需要较少的优化。
* 促进 Web 应用程序的开发，并允许大佬将模板到虚拟 DOM 与编译器分开。
* 经过验证的兼容性和灵活性。
* 不管应用程序的规模如何，代码库都不会变。

**使用 Vue 构建的流行应用程序：**

Gitlab | Spendesk | Behance | 9Gag | Wizzair | Nintendo

### **社区支持与学习曲线**

React JS 库是由 Facebook 创建的，拥有大量的贡献人员和一个庞大的开发者社区，为最大的问题贡献者他们的方案。Angular 有一个宏大的开发者社区，对最具挑战性和最怪异的案例都有答案。Vue 具有良好的生态系统，并具有 React 库和 Angular 框架的所有正确的特性。说到学习曲线，React 无疑是能够最快学习和适应的，其次是 Vue 和 Angular。

## **本文总结**

从前端开发的角度来看，React 将是 2021 年能够学得最快的框架，Vue 和 React 都是轻量级且直观的，并且性能完美无缺。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
