> * 原文地址：[Angular vs. React vs. Vue: Which Framework is Best in 2021?](https://dzone.com/articles/angular-vs-react-vs-vue-which-framework-is-best-to)
> * 原文作者：[Sourabh Nagar](https://dzone.com/users/3456681/chapter247.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Angular-vs-React-vs-Vue:-Which-Framework-is-Best-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Angular-vs-React-vs-Vue:-Which-Framework-is-Best-in-2021.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：

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

Angular is best suitable for large-scale and advanced projects. These may include but not be limited to:

- Developing Progressive Web App (PWA).
- Redesigning of a website application.
- Building dynamic content-based web designs.
- Creating large enterprise application that needs complex infrastructure.

### **React**

React comes from the family of the MERN stack — a technology stack known for building sophisticated business applications. React becomes a powerful tool when used along with Redux or MobX, or any flux patterned library. React is best suited for the following projects:

- For applications that involve many components with navigation items, collapsed/expanded accordion sections, active/inactive states, dynamic inputs, active/inactive buttons, user login, user access permissions, etc.
- For projects that have scope for scale and growth because React components have declarative nature that makes way for easy handling around such complex structures.
- When UI is the center of the web app.

### **Vue**

Vue is best suited for solving short-term problems because Vue has an affordable and quick learning curve. It can integrate with existing code blocks easily. Vue may be required when:

- You need development projects of web apps with animations or interactive elements.
- Prototyping without the need for advanced skills.
- Applications requiring seamless integration with multiple other apps.
- Faster launch of MVP.

## **表现和发展**

### **Angular**

Some highlights in Angular’s performance are:

- Has seamless third-party integrations for enhancing the functionality of the product/application.
- Provides a robust collection of components leading to simplified art of writing, altering, and using the code.
- Its 'ahead-of-time-compiler' bestows faster load times and security strength.
- The MVC model helps in curtailing queries in the background by allowing separation of views.
- Facilitates the use of dependency injection as external elements for decoupling components that make way for reusability and ease of management and testing.
- Reduces the initial load time of a webpage by splitting the tasks into logical chunks.
- Fully customizable designs.
- Facilitates the compiling of HTML and TypeScript into JavaScript — leading to the faster compilation of the code much before the browser starts to load the web app.

### **React**

React is comparable to Vue when it comes to performance because both have the same architecture, i.e., interaction with DOM. The performance of React web development can be assessed as follows:

- Supports bundling and tree-shaking — a feature crucial for reducing the end users’ resource loads.
- Offers better control over the project due to one-way data-binding support.
- It can be easily tested and monitored.
- Best for complex applications that require frequent changes.

### **Vue**

Incredibly fast is the phrase that’s most attached with Vue. Some of its performance metrics are:

- Faster learning curve.
- Efficient and sophisticated single-page application.
- Versatility due to high-end features.

## **各自的优点**

### **Angular**

Well-documented understanding of templates, forms, bootstrapping or details about architecture, components, and interaction between components:

- Smooth two-way data binding.
- MVC architecture.
- Built-in module system.
- Significant reduction of the initial load time of a webpage.

**使用 Angular 构建的流行应用程序：**

Youtube TV | PayPal | Gmail | Forbes | Google Cloud

### **React**

- Flexible code due to its modular structure. Saves time and cost.
- Facilitates high performance of complex apps.
- Easier to maintain code during React front-end development.
- Supports mobile native applications for both Android and iOS platforms.

**使用 React 构建的流行应用程序：**

Tesla | AirBnB | CNN | Nike | Udemy | Linked-in

### **Vue**

- Small size facilitates easy installation and download.
- When properly harnessed, Vue can be reused.
- Vue.js allows updating of elements in a web page without rendering the whole DOM since it is virtual.
- Requires less optimization.
- Stimulates web application development and allows the experts to separate template-to-virtual DOM from the compiler.
- Proven compatibility and flexibility.
- The codebase remains light regardless of the scaling of the application.

**使用 Vue 构建的流行应用程序：**

Gitlab | Spendesk | Behance | 9Gag | Wizzair | Nintendo

### **社区支持与学习曲线**

React JS library is created by Facebook that enjoys a large community of coders and developers offering solutions to the biggest problems. Angular has a large community of developers who have answers to the most challenging and weirdest cases. Vue has a decent ecosystem and enjoys all the right characteristics of React library and Angular framework. When it comes to the learning curve, React is the quickest to learn and adapt, followed by Vue and Angular.

## **本文总结**

From the point of view of front-end development, React will be the quickest to learn in 2021. Both Vue and React are lightweight, intuitive, and perform flawlessly.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
