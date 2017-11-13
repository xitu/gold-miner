
> * 原文地址：[Angular vs. React vs. Vue: A 2017 comparison](https://medium.com/unicorn-supplies/angular-vs-react-vs-vue-a-2017-comparison-c5c52d620176)
> * 原文作者：[Jens Neuhaus](https://medium.com/@jensneuhaus?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/angular-vs-react-vs-vue-a-2017-comparison.md](https://github.com/xitu/gold-miner/blob/master/TODO/angular-vs-react-vs-vue-a-2017-comparison.md)
> * 译者：[Hyde Song](https://github.com/HydeSong)
> * 校对者：

# Angular、React、Vue 三剑客: 在 2017 年的比较

决定 web 应用的 JavaScript 开发框架是一件很费劲的事。现如今 [Angular](https://angular.io/) 和 [React](https://facebook.github.io/react/) 非常流行， 并且有一个新贵，最近引起了很大的关注： [VueJS](https://vuejs.org/)。 更重要的是，这只是一些 [新事物](https://hackernoon.com/top-7-javascript-frameworks-c8db6b85f1d0)。

![2017 年的 Javascript— 现在事情并不简单！](https://cdn-images-1.medium.com/max/800/1*xRhs4h2a_rGpXNpoSNlA9w.png)

那么，我们该如何决定呢？ 列出 JavaScript 开发框架的优点和缺点从来没有害处。 我们将按过去文章的风格来说明这一点， “[总共9步：为 Web 应用选择一个技术栈](https://medium.com/unicorn-supplies/9-steps-how-to-choose-a-technology-stack-for-your-web-application-a6e302398e55)”。

## 开始之前 — 是不是 SPA？

首先你应该明确决定是否需要单页面应用程序（SPA），或者是否希望采用多页面方法。 关于这个问题请进一步阅读我的博客文章，“[单页面应用程序（SPA）与多页面Web应用程序（MPA）](https://medium.com/unicorn-supplies/angular-vs-react-vs-vue-a-2017-comparison-c5c52d620176#)“（即将推出，请关注我的 [推特](http://www.twitter.com/jensneuhaus/) 更新）。

## 现今的首发框架：Angular， React 和 Vue

首先，我想讨论 **生命周期和战略考虑**。然后，我们再讨论 这三个 javascript 框架的 **功能和概念**。最后，我们再做 **结论**。

以下是我们今天要解决的问题：


- **这些框架或库有多成熟**？
- 这些框架可能只会 **火热一时** 吗？
- **这些框架相应的生态社区规模有多大，会有多少帮助**？
- 为每个框架找到开发者 **有多容易**？
- 这些框架的 **基本编程概念** 是什么？
- **对于小型或大型应用程序**，使用框架有多容易？
- 每个框架 **学习曲线** 是怎么样的？
- 你期望这些框架的 **性能** 是怎么样的？
- 在哪能 **仔细了解底层原理**？
- 你可以用你选择的框架 **开始开发** 吗？

准备好，听我娓娓道来！

## 生命周期和战略考虑

![React Angular Vue 三者比较](https://cdn-images-1.medium.com/max/800/1*aPijhbTjT0VOxPYq2RkVUw.png)

### 一些历史

**Angular** 是基于 TypeScript 的 Javascript 框架。由 Google 进行开发和维护， 它被描述为“超级牛逼的 JavaScript [MVW](https://plus.google.com/+AngularJS/posts/aZNVhj355G2) 框架”。 Angular （也被称为 “Angular 2+”， “Angular 2” 或者 “ng2”） 已被重写，是与 AngularJS（也被称为 “Angular.js” 或 “AngularJS 1.x”）不兼容的后续版本。 当 AngularJS（旧版本）最初于2010年10月发布时，仍然在 [修复 bug](https://github.com/angular/angular.js)，等等 — 新的 Angular（sans JS）于 2016 年 9 月推出，版本为 2。最新的主要版本是版本4，[因为版本 3 被跳过了](http://www.infoworld.com/article/3150716/application-development/forget-angular-3-google-skips-straight-to-angular-4.html)。Google，Vine，Wix，Udemy，weather.com，healthcare.gov 和 Forbes 都使用 Angular （根据 [madewithangular](https://www.madewithangular.com/)，[stackshare](https://stackshare.io/angular-2) 和 [libscore.com](http://libscore.com/#angular) 提供的数据）。

**React** 被描述为 “用于构建用户界面的 JavaScript 库”。 React 最初于 2013 年 3 月发布，由 Facebook 进行开发和维护，Facebook 在多个页面上使用 React 组件（但不是作为单页应用程序）。 根据 [Chris Cordle](https://medium.com/@chriscordle) 的 [这篇文章](https://medium.com/@chriscordle/why-angular-2-4-is-too-little-too-late-ea86d7fa0bae)，React 在 Facebook 上的使用远远多于 Angular 在 Google 上的使用。React 还被 Airbnb，Uber，Netflix，Twitter，Pinterest，Reddit，Udemy，Wix，Paypal，Imgur，Feedly，Stripe，Tumblr，Walmart 等（根据 [Facebook](https://github.com/facebook/react/wiki/Sites-Using-React), [stackshare](https://stackshare.io/react) 和 [libscore.com](http://libscore.com/#React) 提供的数据）。

Facebook 正在开发 **React Fiber**。它会改变 React 的底层 - 渲染速度应该会更快 - 但是在变化之后，版本会向后兼容。 Facebook 将会在 2017 年 4 月的开发者大会上 [讨论](https://developers.facebook.com/videos/f8-2017/the-evolution-of-react-and-graphql-at-facebook-and-beyond/) 新变化，并发布一篇非官方的 [关于新架构的文章](https://github.com/acdlite/react-fiber-architecture)。React Fiber 可能与 React 16 一起发布。

**Vue** 是 2016 年发展最为迅速的 JS 框架之一。Vue 将自己描述为一款“用于构建直观，快速和组件化交互式界面的 [MVVM](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel) 框架”。它于 2014 年 2 月首次由 Google 前员工 [Evan You](https://github.com/yyx990803) 发布（顺便说一句：尤雨溪那时候发表了一篇 [vue 发布首周的营销活动和数据](http://blog.evanyou.me/2014/02/11/first-week-of-launching-an-oss-project/) 的博客文章）。这无疑是非常成功的，尤其是考虑到 Vue 在没有大公司的支持的情况下，作为一个人开发的框架获得这么多的吸引力。尤雨溪目前有一个数十人核心开发者的团队。2016 年，版本 2 发布。Vue 被阿里巴巴，百度，Expedia，任天堂，GitLab 使用 — 可以在 [madewithvuejs.com](https://madewithvuejs.com/) 找到一些小项目的列表。

Angular 和 Vue 都可以在 **MIT license** 许可下获得，而 React 带有 **[BSD3-license](https://en.wikipedia.org/wiki/BSD_licenses#3-clause_license_.28.22BSD_License_2.0.22.2C_.22Revised_BSD_License.22.2C_.22New_BSD_License.22.2C_or_.22Modified_BSD_License.22.29) 许可证**。专利文件上有很多讨论。 [James Ide](https://medium.com/@ji) （前 Facebook 工程师） 解释专利文件背后的 [原因和历史](https://medium.com/@ji/the-react-license-for-founders-and-ctos-b38d2538f3e5)：Facebook 的专利授权是在保护自己免受专利诉讼的能力的同时分享其代码。专利文件被更新了一次，有些人声称，如果你的公司不打算起诉 Facebook，那么使用 React 是可以的。你可以 [在这个 Github issue 上](https://github.com/facebook/react/issues/7293) 查看讨论。我不是律师，所以如果 React 许可证对您或您的公司有问题，您应该自己决定。关于这个话题还有很多文章：[Dennis Walsh](https://medium.com/@dwalsh.sdlr) 写到, [你为什么不该害怕](https://medium.com/@dwalsh.sdlr/react-facebook-and-the-revokable-patent-license-why-its-a-paper-25c40c50b562)。[Raúl Kripalani](https://medium.com/@raulk) 警告: [反对创业公司使用 React](https://medium.com/@raulk/if-youre-a-startup-you-should-not-use-react-reflecting-on-the-bsd-patents-license-b049d4a67dd2)，他还写了一篇 [备忘录概览](https://medium.com/@raulk/further-notes-and-questions-arising-from-facebooks-bsd-3-strong-patent-retaliation-license-c6386e8e1d60)。此外，Facebook上还有一个最新的声明：[解释React的许可证](https://code.facebook.com/posts/112130496157735/explaining-react-s-license/)。

### 代码开发

如前所述，Angular 和React 得到大公司的支持和使用。Facebook，Instagram 和 WhatsApp 正在它们的页面使用 React。Google 在很多项目中使用 Angular，例如，新的 Adwords 用户界面是使用 [Angular 和 Dart](http://news.dartlang.org/2016/03/the-new-adwords-ui-uses-dart-we-asked.html?m=1)。再次，Vue 是由一群通过 Patreon 和其他赞助方式支持的个人实现的。你可以自己决定这是积极还是消极。[Matthias Götzke](https://medium.com/@mgoetzke) 认为 Vue 小团队的好处是 [导致更简洁和更少的过度设计的代码或 API](https://medium.com/@mgoetzke/some-people-have-been-asking-about-the-dependability-of-vue-jss-9dc2842b3709).

我们来看看一些统计数据：Angular 在团队介绍页 [列出 36 人](https://angular.io/about?group=Angular)， Vue [列出 16 人](https://vuejs.org/v2/guide/team.html)， 而 React 没有团队介绍页。 **在 Github 上**，Angular 有 25,000+ 的 star 和 463 位代码贡献者，React 有 70,000+ 的 star 和 1,000+ 位代码贡献者， 而 Vue 有近 60,000 的 star 和只有 120 位代码贡献者。 你也可以查看 [Angular，React 和 Vue 的 Github Star 历史](http://www.timqian.com/star-history/#facebook/react&angular/angular&vuejs/vue)。Vue 又一次似乎趋势很好。根据 [bestof.js](https://bestof.js.org/tags/framework/trending/last-3-months) 提供的数据显示，在过去三个月 Angular 2 平均每天获得 31 个 star，React 74 个，Vue.JS 107 个。

![Angular，React 与 Due 的 Github Star 历史 (数据来源)](https://cdn-images-1.medium.com/max/800/1*vvRdTNyQNrDeAxBXzBbqQw.png)

[数据来源](http://www.timqian.com/star-history/#facebook/react&angular/angular&vuejs/vue)

**更新**: 感谢 [Paul Henschel](https://medium.com/@drcmda) 提出的 [npm 趋势](http://www.npmtrends.com/angular-vs-react-vs-vue-vs-@angular/core)。npm 趋势显示了 npm 软件包的下载次数，相对比单独地看 Github star 更有用：

![在过去 2 年，npm 软件包的下载次数](https://cdn-images-1.medium.com/max/800/1*JKPQhZwOGAAlViSYsUf--w.png)

### 市场周期

由于各种名称和版本，很难在 Google 趋势中比较 Angular，React 和 Vue。 一种近似的方法可以是“互联网与技术”类别中的搜索。 结果如下：

![](https://cdn-images-1.medium.com/max/600/1*gTNdON6wlXXiDJONUUtioQ.png)

好吧。Vue 没有在 2014 年之前创建 - 所以这里有什么不对劲。La Vue是法语的 “view” ，“sight” 或 “opinion”。也许就是这样。“VueJS” 和 “Angular” 或 “React” 的比较也是不公平的，因为 VueJS 几乎没有任何结果。

那我们试试别的吧。ThoughtWorks 的 [Technology Radar](https://www.thoughtworks.com/de/radar#) 技术随时间推移的变化。ThoughtWorks 的 [Technology Radar](https://www.thoughtworks.com/de/radar#) 随着时间推移，技术的演进过程给人深刻的印象。Redux 是 [在采用阶段](https://www.thoughtworks.com/de/radar/languages-and-frameworks/redux) （被 ThoughtWorks 项目采用的！）， 它在许多 ThoughtWorks 项目中的价值是不可估量的。 Vue.js 是 [在试用阶段](https://www.thoughtworks.com/de/radar/languages-and-frameworks/vue-js) （被试着用的）。 Vue 被称为是 Angular 的轻量级和灵活的替代品，学习曲线较低。 Angular 2 是 [正在处于评估阶段](https://www.thoughtworks.com/de/radar/languages-and-frameworks/angular-2) 使用 — 已被 ThoughtWork 团队成功实践，但不强烈推荐。

根据 [2017 年 Stackoverflow 的最新调查](https://insights.stackoverflow.com/survey/2017#most-loved-dreaded-and-wanted)， React 被 67% 的调查开发者喜爱，喜欢 AngularJS 的有 52%。“没有兴趣在开发中继续使用”的开发者占了更高的数量，AngularJS（48%）和 React（33%）。在这两种情况下，Vue都不在前十。 然后是 statejs.com 关于比较 “[前端框架](http://stateofjs.com/2016/frontend/)” 的调查。 最有意思的事实是：React 和 Angular 有 100% 的认知度，23% 的受访者不了解 Vue。关于满意度，92% 的受访者愿意“再次使用” React ，Vue 有 89% ,而 Angular 2 只有 65%。

另一个客户满意度调查呢？ [Eric Elliott](https://medium.com/@_ericelliott) 于 2016 年 10 月开始评估 Angular 2 和 React。 只有 38% 的受访者会再次使用 Angular 2，而 84% 的人会再次使用 React。

### 长期支持和迁移

Facebook [在其设计原则中指出](https://facebook.github.io/react/contributing/design-principles.html#stability)，React API 非常稳定。还有一些脚本可以帮助您从当前的API移到更新的版本：请查阅 [react-codemod](https://github.com/reactjs/react-codemod)。迁移是非常容易的，没有这样的东西（需要）作为长期支持的版本。在这篇 Reddit 文章中，人们注意到升级 [从来不是问题](https://www.reddit.com/r/reactjs/comments/5a45ai/is_react_a_good_choice_for_a_stable_longterm_app/)。React 团队写了一篇关于他们 [版本控制方案](https://facebook.github.io/react/blog/2016/02/19/new-versioning-scheme.html) 的博客文章。当他们添加弃用警告时，在下一个主要版本中的行为发生更改之前，他们会保留当前版本的其余部分。没有计划更改为新的主要版本 - v14 于 2015 年 10 月发布，v15 于 2016 年 4 月发布，而 v16 还没有发布日期。最近 [React核心开发人员指出](https://github.com/facebook/react/issues/8854#issuecomment-312527769)，升级不应该是一个问题。

关于 Angular，从 v2 发布开始，有一篇 [关于版本管理和发布 Angular](http://angularjs.blogspot.de/2016/10/versioning-and-releasing-angular.html) 的博客文章。每六个月会有一次重大更新，至少有六个月的时间（两个主要版本）。在文档中有一些实验性的 API 被标记为较短的弃用期。目前还没有官方公告，但 [根据这篇文章](https://www.infoq.com/news/2017/04/ng-conf-2017-keynote)，Angular 团队已经宣布了以 Angular 4 开始的长期支持版本。这些将在下一个主要版本发布之后至少一年得到支持。这意味着至少在 **2018 年 9 月** 之前，将支持 Angular 4，并提供 bug 修复和重要补丁。在大多数情况下，将 Angular 从 v2 更新到 v4 与更新 Angular 依赖关系一样简单。Angular 还提供了有关是否需要进一步更改的 [信息指南](https://angular-update-guide.firebaseapp.com/)。

Vue 1.x 到 2.0 的更新过程对于一个小应用程序来说应该很容易 - 开发者团队已经声称 90% 的 API 保持不变。在控制台上有一个很好的升级 - 诊断迁移 - 辅助工具。 一位开发人员 [指出](https://news.ycombinator.com/item?id=13151966)，从 v1 到 v2 的更新在大型应用程序中仍然没有挑战。 不幸的是，关于 LTS 版本的下一个主要版本或计划信息没有清晰的（公共）路线图。

还有一件事：Angular 是一个完整的框架，提供了很多捆绑在一起的东西。 React 比 Angular 更灵活，你可能会使用更多独立的，不稳定的，快速更新的库 - 这意味着你需要自己维护相应的更新和迁移。 如果某些包不再被维护，或者其他一些包在某些时候成为事实上的标准，这也可能是不利的。


### 人力资源和招聘

如果你的团队有不需要了解更多 Javascript 技术的 HTML 开发人员，则最好选择 Angular 或 Vue。React 需要了解更多的 JavaScript 技术（我们稍后再谈）。

你的团队有工作时接触代码的设计师吗？ Reddit 上的用户 “pier25” 指出，如果你在 Facebook 工作，[每个人都是一个大神开发者，React 是有意义的](https://www.reddit.com/r/webdev/comments/5ho71i/why_we_chose_vuejs_over_react/deuynwc/)。在现实世界中，你不会总是找到一个可以修改 JSX 的设计师，因此使用 HTML 模板将会更容易。

Angular 框架的好处是来自另一家公司的新的 Angular 2 开发人员将很快熟悉所有必要的约定。 React 项目在架构决策方面各不相同，开发人员需要熟悉特定的项目设置。

如果您的开发人员具有面向对象的背景或者不喜欢 Javascript，Angular 也是很好的选择。 为了推动这一点，这里是[Mahesh Chand 引述](http://www.c-sharpcorner.com/article/angular-2-or-react-for-decision-makers/)：

> 我不是一个 JavaScript 开发人员。 我的背景是使用 “真正的” 软件平台构建大型企业系统。 我从 1997 年开始使用 C，C ++，Pascal，Ada 和 Fortran 构建应用程序。 （...）我可以清楚地说，JavaScript 对我来说简直是胡言乱语。 作为 Microsoft MVP 和专家，我对 TypeScript 有很好的理解。 我也不认为 Facebook 是一家软件开发公司。 但是，Google 和微软已经是最大的软件创新者。 我觉得使用 Google 和微软强大支持的产品会更舒服。 另外（...）与我的背景，我知道微软有更大的 TypeScript 计划。

那么，那么......我应该提到，Mahesh是微软的区域总监。

## React，Angular 和 Vue 的比较

### 组件

我们所讨论的框架都是基于组件的。 一个组件得到一个输入，并且在一些内部的行为/计算之后，它返回一个渲染的 UI 模板（一个登录/注销区或一个待办事项列表项）作为输出。 定义的组件应该易于在网页或其他组件中重用。 例如，您可以使用具有各种属性（列，标题信息，数据行等）的网格组件（由一个标题组件和多个行组件组成），并且能够在另一个页面上使用具有不同数据集的组件。 这里有一篇 [关于组件的综合性文章](https://derickbailey.com/2015/08/26/building-a-component-based-web-ui-with-modern-javascript-frameworks/)，如果你想了解更多这方面的信息。

React 和 Vue 都擅长处理组件：小型的无状态的函数接收输入和返回元素作为输出。

### Typescript，ES6 和 ES5

React 专注于使用 Javascript ES6。Vue 使用 Javascript ES5 或 ES6。

Angular 依赖于TypeScript。这在相关示例和开源项目中提供了更多的一致性（React 示例可以在 ES5 或 ES6 中找到）。 这也引入了像装饰器和静态类型的概念。 静态类型对于代码智能工具非常有用，比如自动重构，跳转到定义等等 - 它们也可以减少应用程序中的错误数量，尽管这个话题当然没有共识。 [Eric Elliott](https://medium.com/@_ericelliott) 在他的文章 “[静态类型的令人震惊的秘密](https://medium.com/javascript-scene/the-shocking-secret-about-static-types-514d39bf30a3)” 中不同意。 Daniel C Wang 表示，[使用静态类型的代价并没有什么坏处](https://medium.com/@danwang74/the-economics-between-testing-and-types-4a3f8c8a86eb)，同时也有测试驱动开发（TDD）和静态类型。

你也应该知道你 [可以使用 Flow 在 React 中启用类型检查](https://www.sitepoint.com/writing-better-javascript-with-flow/)。 这是 Facebook 为 JavaScript 开发的静态类型检查器。 Flow [也可以集成到 VueJS 中](https://alligator.io/vuejs/components-flow/)。

如果你在用 TypeScript 编写代码，那么你不需要再编写标准的 JavaScript 了。尽管它在不断增长，但与整个 JavaScript 语言相比，TypeScript 的用户群仍然很小。一个风险可能是你正在向错误的方向发展，因为 TypeScript 可能 - 也许不太可能 - 随着时间的推移也会消失。此外，TypeScript 为项目增加了很多（学习）开销 - 您可以在 [Eric Elliott](https://medium.com/@_ericelliott) 的 [Angular 2 vs. React 比较](https://medium.com/javascript-scene/angular-2-vs-react-the-ultimate-dance-off-60e7dfbc379c) 中阅读更多关于这方面的内容。

**更新**: [James Ravenscroft](https://medium.com/@jrwebdev) 在对这篇文章的评论中写道，[TypeScript 对 JSX 有一流的支持](https://medium.com/@jrwebdev/id-argue-that-if-you-love-typescript-then-react-may-be-a-better-choice-ceec950ee543) - 可以无缝地对组件进行类型检查。 所以，如果你喜欢 TypeScript 并且你想使用 React，这应该不成问题。

### 模板 — JSX 还是 HTML

React 打破了长期以来的最佳实践。几十年来，开发人员试图分离 UI 模板和内联的 Javascript 逻辑，但是使用 JSX，这些又被混合了。这听起来很糟糕，但是你应该听彼得·亨特（Peter Hunt）的演讲 “[React：反思最佳实践](https://www.youtube.com/watch?v=x7cQ3mrcKaY)” （2013 年 10 月）。他指出，分离模板和逻辑仅仅是技术的分离，而不是关注的分离。您应该构建组件而不是模板。组件是可重用的，可组合的和单元可测试的。

JSX 是一个类似 HTML 语法的可选预处理器，稍后将在 JavaScript 中进行编译。JSX 有一些奇怪 - 例如，您需要使用 className 而不是 class，因为后者是 Javascript 中的受保护名称。 JSX 对于开发来说是一个很大的优势，因为你在一个地方拥有了所有的东西，可以在代码完成和编译时更好地检查工作成果。当您在 JSX 中输入错误时，React 将不会编译，并打印输出错误的行号。 Angular 2 在运行时静默失败（如果你使用 AOT 和 Angular，这个参数可能是无效的）。

JSX 意味着 React 中的所有内容都是 Javascript -- 用于JSX模板和逻辑。[Cory House](https://medium.com/@housecor) 在 [2016 年 1 月的文章](https://medium.freecodecamp.org/angular-2-versus-react-there-will-be-blood-66595faafd51) 中指出：“Angular 2 继续把 'JS' 放到 HTML 中。 React 把 'HTML' 放到JS 中。“这是一件好事，因为 Javascript 比 HTML 更强大。

Angular 模板使用特殊的 Angular 语法（比如 ngIf 或 ngFor）来增强 HTML。虽然 React 需要 JavaScript 的知识，但 Angular 会迫使你学习 [Angular 特有的语法](https://angular.io/guide/cheatsheet)。

Vue 具有“[单个文件组件](https://vuejs.org/v2/guide/single-file-components.html)”。这似乎是对于关注分离的权衡 - 模板，脚本和样式在一个文件中，但在三个不同的有序部分中。这意味着您可以获得语法高亮，CSS 支持以及更容易使用预处理器（如 Jade 或 SCSS）。我已经阅读过其他文章，JSX 更容易调试，因为 Vue 不会显示错误的 HTML 语法错误。这是不正确的，因为 Vue [转换 HTML 来渲染函数](https://vuejs.org/v2/guide/render-function.html) - 所以错误显示没有问题（感谢 [Vinicius Reis](https://medium.com/@luizvinicius73) 的评论和更正！）。

注意：如果你喜欢 JSX 的思路，并想在 Vue 中使用它，可以使用 [babel-plugin-transform-vue-jsx](https://github.com/vuejs/babel-plugin-transform-vue-jsx)。

### 框架和库

Angular 是一个框架而不是一个库，因为它提供了关于如何构建应用程序的强有力的意见，并且还提供了更多开箱即用的功能。 Angular 是一个 “完整的解决方案” - 包括电池接口，并且你可以愉快的开始开发。 你不需要分析库，路由解决方案或类似的东西 - 你只要开始工作就好了。

另一方面，React 和 Vue 是普遍灵活的。他们的库可以配对各种软件包（在 [npm](https://www.npmjs.com/search?q=react&page=1&ranking=popularity) 上有很多 React 的软件包，但 Vue 的软件包比较少，因为毕竟这个框架还比较新）。 有了 React，你甚至可以交换库本身的 API 兼容替代品，如 [Inferno](https://infernojs.org/)。 然而，灵活性越大，责任就越大 - React 没有规则和有限的指导。 每个项目都需要决定架构，而且事情可能更容易出错。 

另一方面，Angular 还有一个令人困惑的构建工具，样板，检查器（linter）和时间片来处理。 如果使用项目初始套件或样板，React 也是如此。 他们自然是非常有帮助的，但是 React 可以开箱即用，这也许是你应该学习的方式。 有时，在 Javascript 环境下工作所需的各种工具被称为 “Javascript 疲劳”。有时，在 JavaScript 环境中工作要使用各种工具被称为 “Javascript 疲劳”。 [Eric Clemmons](https://medium.com/@ericclemmons) 在他的 [文章](https://medium.com/@ericclemmons/javascript-fatigue-48d4011b6fc4) 中说：

> There are still a bunch of installed tools, you are not used to, when starting with the framework. These are generated but probably a lot of developers do not understand, what is happening under the hood — or it takes a lot of time for them to do.

Vue seems to be the cleanest and lightest of the three frameworks. GitLab has a [blog post about its decision regarding Vue.js](https://about.gitlab.com/2016/10/20/why-we-chose-vue/) (October 2016):

> Vue.js comes with the perfect balance of what it will do for you and what you need to do yourself.(…) Vue.js is always within reach, a sturdy, but flexible safety net ready to help you keep your programming efficient and your DOM-inflicted suffering to a minimum.

They like the simplicity and ease of use — the source code is very readable, and no documentation or external libraries are needed. Everything is very straightforward. Vue.js “does not make large assumptions about much of anything either”. There’s also a [podcast about GitLab’s decision](https://www.youtube.com/watch?v=ioogrvs2Ejc#action=share).

Another blogpost [about a shift towards](http://pixeljets.com/blog/why-we-chose-vuejs-over-react/) Vue comes from Pixeljets. React “was a great step forward for JS world in terms of [state-awareness](https://en.wikipedia.org/wiki/Single_source_of_truth), and it showed lots of people the real functional programming in a good, practical way”. One of the big cons of React vs. Vue is the problem of splitting components into smaller components because of the JSX restrictions. Here is a quote of the article:

> For me and my team the readability of code is important, but it is still very important that writing code is fun. It is not funny to create 6 components when you are implementing really simple calculator widget. In a lot of cases, it is also bad in terms of maintenance, modifications, or applying visual overhaul to some widget, because you need to jump around multiple files/functions and check each small chunk of HTML separately. Again, I am not suggesting to write monoliths — I suggest to use components instead of microcomponents for day-to-day development.

There are interesting discussions about the blog post on [Hacker news](https://news.ycombinator.com/item?id=13151317) and [Reddit](https://www.reddit.com/r/webdev/comments/5ho71i/why_we_chose_vuejs_over_react/) — there are arguments from dissenters and further supporters of Vue alike.

### 状态管理和数据绑定

Building UIs is hard, because there are states everywhere — data changing over time entails complexity. Defined state workflows are a big help when apps grow and get more complex. For limited applications, this is probably overkill and something like Vanilla JS would be sufficient.

How does it work? Components describe the UI at any point in time. When data changes, the framework re-renders the entire UI component — displayed data is always up-to-date. We can call this concept “UI as function”.

React often works bundled with Redux. **Redux** describes itself in three [fundamental principles](http://redux.js.org/docs/introduction/ThreePrinciples.html):

- Single source of truth
- State is read-only
- Changes are made with pure functions

In other words: the status of the complete application is stored in an object tree within a single store. This helps with debugging the application, and some functionalities are easier to implement. The state is read-only and can only be changed via actions to avoid race conditions (it also helps with debugging). Reducers are written to specify how the states can be transformed by actions.

Most of the tutorials and boilerplates have Redux already integrated, but you can use React without it (and you might not need Redux in your project at all). Redux introduces complexity and pretty strong constraints into your code. If you are learning React, you should think about learning plain React before you head over to Redux. You should definitely read “[You might not need Redux](https://medium.com/@dan_abramov/you-might-not-need-redux-be46360cf367)” by [Dan Abramov](https://medium.com/@dan_abramov).

[Some developers](https://news.ycombinator.com/item?id=13151577) suggest the use of **[Mobx](https://github.com/mobxjs/mobx) instead of Redux**. You can think of it as an “automatic Redux”, which makes things much easier to use and understand at the outset. If you want to have a look, you should start with the [introduction](https://mobxjs.github.io/mobx/getting-started.html). You can also read this [useful comparison between Redux & MobX](https://www.robinwieruch.de/redux-mobx-confusion/) by Robin. The same author also offers information on [moving from Redux to MobX](https://www.robinwieruch.de/mobx-react/). [This list](https://github.com/voronianski/flux-comparison) is useful if you want to check on other Flux libraries. And if you are coming from an MVC-world, you’ll want to read the article “[Thinking in Redux (when all you’ve known is MVC)](https://medium.com/p/thinking-in-redux-when-all-youve-known-is-mvc-c78a74d35133?source=user_popover)” by [Mikhail Levkovsky](https://medium.com/@mlovekovsky).

Vue can make use of Redux — but it offers [Vuex](https://github.com/vuejs/vuex) as its own solution.

A big difference between React and Angular is **one-way vs. two-way binding**. Angular’s two-way-binding changes the model state when the UI element (e.g. a user input) is updated. React only goes one way: it updates the model first and then it renders the UI element. Angular’s method is cleaner in the code and easier for the developer to implement. React’s way results in a better data overview, because the data only flows in one direction (this makes debugging easier).

Both concepts have there pros and cons. You need to understand the concepts and determine if this influences your framework decision. The article “[Two-way-data binding: Angular 2 and React](https://www.accelebrate.com/blog/two-way-data-binding-angular-2-and-react/)” and [this Stackoverflow question](https://stackoverflow.com/questions/34519889/can-anyone-explain-the-difference-between-reacts-one-way-data-binding-and-angula) both offer a good explanation. [Here](http://n12v.com/2-way-data-binding/) you can find some interactive code examples (3 years old, for Angular 1 & React only). Last but not least, Vue supports both [one-way-binding and two-way-binding](https://medium.com/js-dojo/exploring-vue-js-reactive-two-way-data-binding-da533d0c4554) (one-way by default).

There is a long article about different types of states and the [state management in Angular applications](https://blog.nrwl.io/managing-state-in-angular-applications-22b75ef5625f) (by [Victor Savkin](https://medium.com/@vsavkin)) if you want to read further.

### 其他一些编程概念

Angular 包含依赖注入（dependency injection），即一个对象将依赖项（服务）提供给另一个对象（客户端）的模式。 这导致更多的灵活性和更干净的代码。 文章 “[理解依赖注入](https://github.com/angular/angular.js/wiki/Understanding-Dependency-Injection)” 更详细地解释了这个概念。

[模型 - 视图 - 控制器模式](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)（MVC）将项目分为三个部分：模型，视图和控制器。 Angular（MVC 模式的框架）有开箱即用的 MVC 特性。React 只有 V 层 - 你需要自己解决 M 和 C。

### 灵活性和缩小到微服务

您可以通过简单地将 JavaScript 库添加到源代码来使用 React 或 Vue。 因为使用了 TypeScript，Angular 是不可能这样用的。

现在我们正在更多地转向微服务和 microapps。React 和 Vue 通过只选择真正需要的东西，你可以更多地控制应用程序的大小。使用以前的应用程序的部分从 SPA 转移到微服务，他们提供了更多的灵活性。 Angular 最适合 SPA，因为它可能太臃肿而不能用于微服务。

正如 [Cory House](https://medium.com/@housecor) 所说:

> JavaScript 发展速度很快，而且 React 可以让你将应用程序的一小部分替换成更好用的 JS 库，而不是期待你的框架能够创新。 **小巧，可组合的单一用途工具的理念永远不会过时**。

有些人对非 SPA 网站也使用 React（例如复杂的表单或向导）。 即使 Facebook 使用 React - 不是用在 Facebook 的主页，而是用在特定的页面和功能。

### 体积和性能

There is a flip-side to all the functionality: the Angular framework is quite bloated. The gzipped file size is 143k, compared to 23K for Vue and 43k for React.

React and Vue both have a Virtual DOM , which is supposed to improve performance. If you’re interested in this, you can read about the [differences between the Virtual DOM & DOM](http://reactkungfu.com/2015/10/the-difference-between-virtual-dom-and-dom/), as well as [the real benefits of the Virtual DOM in react.js](https://www.accelebrate.com/blog/the-real-benefits-of-the-virtual-dom-in-react-js/). Also, one of the authors of the Virtual-DOM itself [answers a performance-related question](https://stackoverflow.com/questions/21109361/why-is-reacts-concept-of-virtual-dom-said-to-be-more-performant-than-dirty-mode) on Stackoverflow.

To check the performance, I had a look at the great [js-framework-benchmark](https://github.com/krausest/js-framework-benchmark). You can download and run it yourself, or have a look at the [interactive result table](http://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html).

![](https://cdn-images-1.medium.com/max/800/1*YpbalqSUMYIYjXCduq7dcA.png)

Angular，React 和 Vue 比较（[源文件](http://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html)）

![](https://cdn-images-1.medium.com/max/800/1*gpq0Y-rRczJ5C3DI5_EUlw.png)

内存分配（[源文件](http://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html)）

结论：具有很好的性能和最深的内存分配，但是与特别慢或者更快的框架相比，所有这些框架都非常接近（比如 [Inferno](http://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html)）。 请记住，性能基准只能作为附注来考虑，而不是作为判断。

### 测试

Facebook使用 Jest 来测试其 React 代码。这里有篇文章 Jest 和 Mocha 之间的比较 - 还有一篇关于 [Enzyme 和 Mocha 如何一起使用](https://semaphoreci.com/community/tutorials/testing-react-components-with-enzyme-and-mocha) 的文章。Enzyme 是 Airbnb 使用的 JavaScript 测试工具（与 Jest，Karma 和其他测试框架一起使用）。如果你想了解更多，有一些关于在 React（[这里](https://medium.com/@bruderstein/the-missing-piece-to-the-react-testing-puzzle-c51cd30df7a0) 和 [这里](http://reactkungfu.com/2015/07/approaches-to-testing-react-components-an-overview/)）测试的旧文章。

Angular 2 中使用 **Jasmine** 作为测试框架。[Eric Elliott](https://medium.com/@_ericelliott) 在一篇文章中抱怨说 Jasmine “以数百种方式编写测试和断言，需要仔细阅读每一个，来了解它在做什么”。输出也是非常臃肿和难以阅读。有关 Angular 2 [与 Karma](https://medium.com/@laco0416/setting-up-angular-2-testing-environment-with-karma-and-webpack-e9b833befd99) 和 [Mocha](https://medium.com/@PeterNagyJob/angular2-configuration-and-unit-testing-with-mocha-and-chai-4ada9484e569) 的整合的一些有用的文章。这里有一个关于 [Angular 2 测试策略](https://www.youtube.com/watch?v=C0F2E-PRm44) 的旧视频（2015年）。

Vue 缺乏测试指导，但是 Evan 在 2017 年的展望中写道，[该团队计划在这方面开展工作](https://medium.com/the-vue-point/vue-in-2016-8df71d98bfb3)。他们推荐使用 [Karma](http://karma-runner.github.io/1.0/index.html)。[Vue 和 Jest 结合使用](https://github.com/locoslab/vue-jest-utils)，还有 [avoriaz 作为测试工具](https://github.com/eddyerburgh/avoriaz)。

### 全平台 app 和原生 app 

Server-side pre-rendering is a plus. All three frameworks have libraries to find help with that. For React there is [next.js](https://github.com/zeit/next.js) , Vue has [nuxt.js](https://nuxtjs.org/), and Angular has….[Angular Universal](https://universal.angular.io/).
全平台 app 正在将应用程序引入 Web、桌面以及原生 app 的世界。

React 和 Angular 都支持原生开发。 Angular 拥有用于原生应用的 [NativeScript](https://docs.nativescript.org/tutorial/ng-chapter-0)（由 Telerik 支持）和用于混合开发的 Ionic 框架。借助 React，您可以查看 react-native-renderer 来构建跨平台的 iOS 和 Android 应用程序，或者用 [react-native](https://facebook.github.io/react-native/) 开发原生 app。许多 app（包括 Facebook；查看更多的 [展示](https://facebook.github.io/react-native/showcase.html)）都是用 react-native 构建的。

Javascript 框架在客户端上渲染页面。 这对于性能，整体用户体验和 SEO 是不利的。服务器端预渲染是一个好办法。所有这三个框架都有相应的库来实现服务端渲染。 React 有next.js，Vue 有 nuxt.js，而 Angular 有......[Angular Universal](https://universal.angular.io/)。

### 学习曲线

Angular 的学习曲线确实很陡。 它有全面的文档，但有时你可能会感到沮丧，因为 [事情比听起来更难](https://www.reddit.com/r/webdev/comments/5ho71i/why_we_chose_vuejs_over_react/db1vppj/)。 即使你对 Javascript 有深入的了解，也需要了解框架的底层原理。 刚开始初始化项目是很神奇的，它提供了很多被引入的软件包和代码。 因为有一个大的，预先存在的生态系统，你需要随着时间的推移学习，这很不利。 另一方面，由于已经做出了很多决定，所以在特定情况下可能会很好。 对于 React，您可能需要针对第三方库进行大量重大决策。仅仅 React 中就有 16 种 [不同的 flux 软件包来用于状态管理](https://github.com/voronianski/flux-comparison)可供选择。

Vue 很容易学习。 公司转向 Vue 是因为它对初级开发者来说似乎更容易。 这里有一片说他们团队为什么 [从 Angular 转到 Vue](https://medium.com/@Hemantisme/moving-from-angular-to-vue-a-vuetiful-journey-c29842ab2039) 的文章。[另一位用户](https://news.ycombinator.com/item?id=13151716) 表示，他公司的 React 应用程序非常复杂，以至于新开发人员无法跟上代码。 通过 Vue，初级和高级开发人员之间的差距缩小了，他们可以更轻松地协作，减少 bug，解决问题和时间。

Meanwhile, Angular and React have their own way of doing things. They may get in your way, because you need to adjust your practices to make things work their way. That can be a detriment because you are less flexible, and there is a steeper learning curve. It could also be a benefit because you are forced to learn the right concepts while learning the technology. With Vue, you can do the things the old-Javascript-fashioned way. This can be easier in the beginning, but could become a problem in the long-run if things are not done properly.

When it comes to debugging, it’s a plus that React and Vue have less magic. The hunt for bugs is easier because there are fewer places to look and the stack traces have better distinctions between their own code and that of the libraries. People working with React report that they never have to read the source code of the library. However, when debugging your Angular application, you often need to debug the internals of Angular to understand the underlying model. On the bright side, the error messages are supposed to be clearer and more informative starting with Angular 4.
有些人声称他们用 React 实现的东西比用 Vue 实现的更好。如果你是一个没有经验的 Javascript 开发人员 - 或者如果你在过去十年中主要使用 jQuery，那么你应该考虑使用 Vue。转向 React 时，思维方式的转换更为明显。 Vue 看起来更像是简单的 Javascript，同时也引入了一些新的概念：组件，事件驱动模型和单向数据流。它也有一个小痕迹。

同时，Angular和React也有自己的做事方式。他们可能会阻碍你，因为你需要调整自己的做法，让事情顺利进行。这可能是一个不利因素，因为你不够灵活，学习曲线陡峭。这也可能是一个好处，因为你在学习技术时被迫学习正确的概念。用Vue，你可以用老式的方式来做事情。这一开始可能会比较容易，但如果做得不好，可能会长期成为一个问题。

在调试方面，React和Vue的魔力更少。寻找错误更容易，因为有更少的地方看，堆栈跟踪有更好的自己的代码和图书馆之间的区别。使用React的人员报告说，他们永远不必阅读库的源代码。但是，在调试Angular应用程序时，通常需要调试Angular的内部来理解底层模型。从好的一面来看，从Angular 4开始，错误信息应该更清晰，更具信息性。

### Angular, React 和 Vue 底层原理

你想自己阅读源代码吗？ 你想看看事情到底是怎么样的？ 可能首先要查看 Github 存储库：React（[github.com/facebook/react](https://github.com/facebook/react)），Angular（[github.com/angular/angular](https://github.com/angular/angular)）和Vue（[github.com/vuejs/vue](https://github.com/vuejs/vue)）。

语法看起来如何？ ValueCoders [比较 Angular，React 和 Vue 的语法](http://www.valuecoders.com/blog/technology-and-apps/vue-js-comparison-angular-react/)。

It is also good to see things in production — in conjunction with the underlying source code. [TodoMVC](http://todomvc.com/) lists dozens of the same Todo app, written with different Javascript frameworks — you can compare the [Angular](http://todomvc.com/examples/angularjs), [React](http://todomvc.com/examples/react/#/) and [Vue](http://todomvc.com/examples/vue/) solutions. [RealWorld](https://realworld.io/#) creates a real-world-application (a Medium-clone), and they have solutions for [Angular](https://github.com/gothinkster/angular-realworld-example-app) (4+) and [React](https://github.com/gothinkster/react-redux-realworld-example-app) (with Redux) ready. [Vue](https://github.com/mchandleraz/realworld-vue) is a work-in-progress.
在生产环境中也很好查看 - 连同底层的源代码。 [TodoMVC](http://todomvc.com/) 列出了几十个相同的 Todo 应用程序，用不同的 Javascript 框架编写 - 你可以比较 [Angular](http://todomvc.com/examples/angularjs)，[React](http://todomvc.com/examples/react/#/) 和 [Vue](http://todomvc.com/examples/vue/) 的解决方案。 [RealWorld](https://realworld.io/#) 创建了一个真实世界的应用程序（一个中等克隆），他们已经准备好了 [Angular](https://github.com/gothinkster/angular-realworld-example-app)（4+） 和 [React](https://github.com/gothinkster/react-redux-realworld-example-app)（带Redux）的解决方案。 [Vue](https://github.com/mchandleraz/realworld-vue) 的开发正在进行中。

你可以看到许多真实的 app，以下是 React 的方案：

- [Do](https://github.com/1ven/do) （一款很好用的笔记管理 app ，用 **React 和 Redux** 实现）
- [sound-redux](https://github.com/andrewngu/sound-redux) （用 React 和 Redux 实现的 Soundcloud 客户端）
- [Brainfock](https://github.com/Brainfock/Brainfock) （用 React 实现的项目和团队管理解决方案）
- [react-hn](https://github.com/insin/react-hn) 和 [react-news](https://github.com/echenley/react-news)（仿 Hacker news）
- [react-native-whatsapp-ui](https://github.com/himanshuchauhan/react-native-whatsapp-ui) 和 [教程](https://www.codementor.io/codementorteam/build-a-whatsapp-messenger-clone-in-react-part-1-4l2o0waav) （仿 Whatsapp 的 react-native 版）
- [phoenix-trello](https://github.com/bigardone/phoenix-trello/blob/master/README.md)（仿 Trello）
- [slack-clone](https://github.com/avrj/slack-clone) 和 [其他教程](https://medium.com/@benhansen/lets-build-a-slack-clone-with-elixir-phoenix-and-react-part-1-project-setup-3252ae780a1) (仿Slack)

There are some apps for Angular:
以下是 Angular 版的 app：

- [angular2-hn](https://github.com/housseindjirdeh/angular2-hn) 和 [hn-ng2](https://github.com/hswolff/hn-ng2) （仿 Hacker News，[一个由 Ashwin Sureshkumar 创建另一个很好的教程](https://medium.com/@Sureshkumar_Ash/angular-2-hackernews-clone-dynamic-components-routing-params-and-refactor-340773d82e6f)）
- [Redux-and-angular-2](https://medium.com/@Sureshkumar_Ash/angular-2-hackernews-clone-dynamic-components-routing-params-and-refactor-340773d82e6f) （仿 Twitter）

以下是 Vue 版的 app：

- [vue-hackernews-2.0](https://github.com/vuejs/vue-hackernews-2.0) 和 [Loopa news](https://github.com/Angarsk8/loopa-news) （仿Hacker News）
- [vue-soundcloud](https://github.com/mul14/vue-soundcloud)（Soundcloud 演示）

## 总结

### 现在决定使用一个框架

React，Angular 和 Vue 都很酷，而且没有一个能明显的超过对方。 相信你的直觉。 [最后一点有趣的玩世不恭的言辞](https://wildermuth.com/2017/02/12/Why-I-Moved-to-Vue-js-from-Angular-2#comment-3153455874)可能会有助于你的决定：

> 这个肮脏的小秘密就是大多数 “现代 JavaScript 开发” 与实际构建网站无关 - 它正在构建可供构建可供人们使用的库的人使用的软件包，这些人可以为编写教程和教授课程的人构建框架。我不确定任何人实际上正在为实际用户建立任何交互。

当然，这是夸张的，但是可能有一点点道理。 是的，Javascript生态系统中有很多嗡嗡声。 在您的搜索过程中，您可能会发现很多其他有吸引力的选择 - 尽量不要被最新，最闪亮的框架蒙蔽。

### 我应该选什么？

如果你在Google工作： **Angular**

如果你热爱 TypeScript: **Angular （[或 React](https://medium.com/@jrwebdev/id-argue-that-if-you-love-typescript-then-react-may-be-a-better-choice-ceec950ee543)）**

如果你热爱面向对象编程（OOP）: **Angular**

如果你需要指导手册，架构和帮助： **Angular**

如果你在Facebook工作：**React**

如果你喜欢灵活性：**React**

如果你热爱大型的技术生态系统：**React**

如果你喜欢在几十个软件包中进行选择：**React**

如果你喜欢JS和“一切都是 Javascript 的方法”：**React**

如果你喜欢真正干净的代码：**Vue**

如果你想要最简单的学习曲线：**Vue**

如果你想要最轻量级的框架：**Vue**

如果你想在一个文件中分离关注点：**Vue**

如果你一个人工作，或者有一个小团队：**Vue（或 React）**

如果你的应用程序往往变得非常大：**Angular（或 React）**

如果你想用 react-native 构建一个应用程序：**React**

如果你想在圈子中有很多的开发者：**Angular 或 React**

如果你与设计师合作，并需要干净的 HTML 文件：**Angular or Vue**

如果你喜欢 Vue 但是害怕有限的技术生态系统：**React**

如果你不能决定，先学习 **React**，然后 **Vue**， 然后 **Angular**。

**所以，你决定了吗？**

![Yeeesss，你做到了！](https://cdn-images-1.medium.com/max/800/1*Eq7k6tq-LbMpCJKNN5SZ3Q.png)

很好！ 阅读关于如何 **开始 Angular，React 或 Vue** 开发（即将推出，在 [Twitter](http://www.twitter.com/jensneuhaus/) 上关注我的更新）。

### 更多资源

- [React JS，Angular 和 Vue JS — 快速开始和比较](https://www.udemy.com/angular-reactjs-vuejs-quickstart-comparison/)（对这三个框架进行了 8 小时的介绍和比较)
- [Angular React（和 Vue） - DEAL破坏者](https://hackernoon.com/angular-vs-react-the-deal-breaker-7d76c04496bc)（一个简短但很好的比较 [Dominik T](https://medium.com/@dominik.t)）
- [Angular 2 和 React — 终极之舞](https://medium.com/javascript-scene/angular-2-vs-react-the-ultimate-dance-off-60e7dfbc379c) （[Eric Elliott](https://medium.com/@_ericelliott) 一个很好的比较）
- [React Angular Ember 和 Vue.js](https://medium.com/@gsari/react-vs-angular-vs-ember-vs-vue-js-e186c0afc1be) （[Gökhan Sari](https://medium.com/@gsari) 的三种框架的比较）
- [React 和 Angular](https://www.sitepoint.com/react-vs-angular/)（两个框架的明确比较）
- [Vue 可以战胜 React 吗？](https://rubygarage.org/blog/vuejs-vs-react-battle)（很多代码示例的一个很好的比较）
- [10 个理由，为什么我从 Angular 转到 React](https://www.robinwieruch.de/reasons-why-i-moved-from-angular-to-react/)（Robin Wieruch另一个很好的比较）
- [所有的JavaScript框架都很糟糕](https://medium.com/@mattburgess/all-javascript-frameworks-are-terrible-e68d8865183e) （[Matt Burgess](https://medium.com/@mattburgess) 对所有主要框架的大肆抨击）

**感谢您的关注。 我忘了重要的事吗？ 你有不同的意见吗？ 我总是很高兴得到反馈。**

**在 Twitter 上关注我的更新和获取更多内容：** [@jensneuhaus](http://www.twitter.com/jensneuhaus/) — 🙌


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
