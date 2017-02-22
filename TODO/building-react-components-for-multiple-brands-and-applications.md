> * 原文地址：[Building React Components for Multiple Brands and Applications](https://medium.com/walmartlabs/building-react-components-for-multiple-brands-and-applications-7e9157a39db4#.7tbsp6vsz)
* 原文作者：[Alex Grigoryan](https://medium.com/@lexgrigoryan)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[XatMassacrE](https://github.com/XatMassacrE) 
* 校对者：

---

# Building React Components for Multiple Brands and Applications
# 为多个品牌和应用构建React组件
![](https://cdn-images-1.medium.com/max/1600/1*7bG_2QAIOzbKNeesEkkTzg.png)

There are several distinct brands that make up the Walmart family, including [Sam’s Club](https://www.samsclub.com/), [Asda](http://www.asda.com/), and regional branches like [Walmart Canada](http://www.walmart.ca/en). E-commerce applications use tons of functionally similar capabilities, such as; credit card components, login forms, onboarding, carousels, navigation, and more. Developing e-commerce applications for each of these brands in isolation would reduce opportunities for code reuse, resulting in countless hours of duplicated work of these functionally similar components. At @WalmartLabs, [code reusability is important to us](https://medium.com/walmartlabs/how-to-achieve-reusability-with-react-components-81edeb7fb0e0#.arwumefxh). That’s why our application architecture is centered around multi-tenancy/multi-branding — which is the act of building a component for one brand and then adopting it for other brands with different visuals or content. Below, you’ll find our multi brand strategy for react components.
沃尔玛家庭由多个不同的品牌组成，其中包括 [Sam’s Club](https://www.samsclub.com/)， [Asda](http://www.asda.com/)，和例如 [Walmart Canada](http://www.walmart.ca/en) 之类的地区分支。电商应用使用大量功能相似的函数，例如信用卡组件，登录表单，新手引导，轮播图，导航栏等等。然而为每一个独立的品牌开发他们的电商应用将会降低代码的复用率，这将导致在相似功能的组件上耗费大量的时间进行重复性的工作。在@WalmartLabs， [代码的复用性对我们非常重要](https://medium.com/walmartlabs/how-to-achieve-reusability-with-react-components-81edeb7fb0e0#.arwumefxh)。这就是为什么我们的产品架构是基于多重租户或者说多重品牌来构建的 —— 其实就是为一个品牌构建组件的同时把它应用在其他拥有不同外观和内容的品牌上的一种行为。接下来，你将会看到我们的React组件的多重品牌策略。
For context, most of our services are built around different types of multi tenancy. When you make a call to the service, you would usually pass the tenant in the header or in the payload, and the service provides data for that specific tenant. The service might pull different item data for example for samsclub.com versus walmart.com.
就像上面说的， 我们的大部分服务都是建立在不同类型的多重租户上的。当你访问服务的时候，通常情况下你会在头部或者载荷上经过租户，而这个服务也会为特定的租户提供数据。这个服务或许会拉取不同的项目数据举例来说就像 samsclub.com 通过 walmart.com。
We then tried to extend that idea to the front end applications as well. Because we’re using React with Redux, the visual components are already separated from application state, actions, and reducers. This meant we could abstract the React components into one GitHub organization and Redux actions, reducers, and connected components into another. By publishing all of these in a private npm registry, we make it easy for developers to install, try out, and upgrade not only the shared UI elements, but also the actions and reducers that implement our business logic and API calls. [You can read more about how we reuse here.](https://medium.com/walmartlabs/how-to-achieve-reusability-with-react-components-81edeb7fb0e0#.arwumefxh)
然后我们尝试着去在前端应用上推广这个想法。因为我们使用 React 和 Redux，视图层组件已经和应用的 state，actions，以及 reducers 分离开了。这意味着我们可以将 React 组件抽象出来作为一个 GitHub 组织，将 Redux actions，reducers 和已连接的组件抽象成另一个。通过把这些发布在 npm 的私人地址上，我们的开发者就可以轻易的安装，调试和升级这些分享出来的 UI 界面以及事项了我们业务逻辑和 API 调用的 actions 和 reducers。 [你可以了解更多关于我们这个地方的复用](https://medium.com/walmartlabs/how-to-achieve-reusability-with-react-components-81edeb7fb0e0#.arwumefxh)
Of course, if that were the end of the story, all of our applications would look and act the same. In reality, each brand has different requirements in regards to visual guidelines, business requirements, or content, and those requirements must be accounted for.
当然，如果这就结束了，那么我们的所有的应用外观和行为都将会是一模一样的了。然而实际上，每一个品牌对于视觉指导方案，业务需求或者内容都有不同的要求，并且这些要求对于品牌来说是必不可少的。
### Visual Differences
### 视觉差异
Purely visual differences can be handled through styling. The majority of our styling is at the component level. We have a “styles” folder and within that folder are tenant folders, and within those tenant folders are tenant specific styles.
纯粹的视觉差异可以通过样式来处理。我们的样式主要是在组件级别。我们有一个 "style" 文件夹，这个文件夹里面是一些租户文件夹，租户文件夹里面是租户的特定的样式文件。
Looks kind of like this:
就像这样：
    Component
    - src
    - styles
      - walmart
      - samsclub
      - grocery

A problem that occurs when managing styles at the component layer is your css clashes across components. I’m particularly not very creative in naming and definitely would have conflicts. We are moving towards using [CSS modules](https://github.com/css-modules/css-modules) (who have a really brilliant logo) which help remove the problem of accidental clashing (already supported in our archetype).
当在组件层管理这些样式文件的时候，会发生一个问题，这个问题就是你的组件的 css 会相互冲突。在命名方面我是尤其的没有创造性，所有对于我来说绝对会产生冲突。我们将会使用 [CSS modules](https://github.com/css-modules/css-modules) （它有一个绝妙的 logo），它会帮助我们移除意外冲突的问题 （在我们的原型中已经支持了）。
On the topic of icons, we abstract common icons into a separate GitHub organization and import them into components as required.
在图标方面，我们可以抽取一些常用的图标放到一个单独 GitHub 组织并且按照需要导入到组件中。
These tenant-specific CSS files and icons are bundled using Webpack at build time.
这些特定租户的 CSS 文件和图标在 build 的时候会使用 Webpack 打包到一起。
### Content Differences
### 内容差异
Different brands also have different content requirements based on the region they are serving. A super simple example is, walmart.com and walmart.ca say “add to cart”, but asda.com just says “add”, while our George clothing brand says “add to basket”, and our grocery.walmart.com has an icon.
不同的品牌同样也有基于他们服务地区的内容需求。一个超级简单的例子就是，walmart.com 和 walmart.ca 显示 "加入购物车" 的地方，asda.com 只显示 "加入"，而我们的 George clothing 品牌显示 "加入篮子"，grocery.walmart.com 会显示一个图标。
![](https://cdn-images-1.medium.com/max/1600/1*a-3DlvR6-xabNhFenEcRkg.png)

We use [React-Intl](https://github.com/yahoo/react-intl) for the heavy lifting of content management. Content is managed at a component level, very similar to styling and each tenant has their own content file. You would specify content that is specific to your tenant/brand in your tenant content folder (just like CSS), but the unique part about content is that for unspecified keys, we default to walmart.com content. During build time of the component, based on your tenant build parameter, our webpack build will only keep your tenant content plus the default unspecified keys from walmart.com content.
我们使用 [React-Intl](https://github.com/yahoo/react-intl) 进行繁杂的内容管理。这些内容实在组件层面被管理的，和样式类似，每个租户都有他们自己的内容文件。你将会在你的租户或者品牌特定的内容文件夹（就像 CSS 一样）里指定你的内容，但是对于内容来讲不一样的地方是，对于没有指定的地方我们使用 walmart.com 默认的内容。在组件的构建过程中，基于你的租户的构建参数，我们的 webpack 将会仅仅保留你的租户的内容加上那些来自 walmart.com 的默认内容。
### Larger Differences
### 更大的差异
Even larger differences between tenants, such as DOM variations within shared components we have two different strategies. For minor DOM variations, we use component props to enable, disable, and manipulate child components. An example of this is our login form; Sam’s Club likes to have a little “SHOW PASSWORD” button inside the password form while Walmart does not. I would make a prop called “displayShowPassword” which would manage this tenant specific feature.
在租户之间还有更大的差异，例如在可分享组件中的 DOM 变动我们会采取两个策略。对于微小的 DOM 变动, 我们通过组件的属性决定是否启用和操作它的子组件。我们的登录表单就是这样做的，Sam’s Club 希望在密码表单中有一个 "显示密码" 的按钮而 Walmart 则没有。我将会使用一个叫做 “displayShowPassword” 的属性来管理每个租户的特定需求。
One thing to note, if you heavily rely on using props to manage different tenant features, it can make your components larger in size, making it more unwieldy to manage in development as well as have a bigger file footprint. This is especially true if you have code paths that are mutually exclusive to tenants. We are working on solutions to manage that.
有一点需要注意的是，如果你过份的依赖使用属性去管理不同的租户的需求的话，将会导致你的组件变的臃肿，这和更大的文件占用一样会使得开发更加难以管理。这个问题在租户之间的文件路径相互冲突时将会尤其明显。我们正在想办法解决这个问题。
For larger changes, we use higher-order components and composed components. Of course, this requires that each shared component be built with this sort of configurability in mind from day one, which involves forethought when initially developing. In the long run, however, we find the reusability payoff to be worth the extra up-front thinking.
对于更大的改变说来，我们使用高级组件和合成组件。当然，这就需要在还没开发的时候就高瞻远瞩，在开发的第一天就思考如何构建出一个可配置的的共享组件。从长期来看，我们就会发现额外的预先思考是值得复用性的回报的。
### Example of Large Difference
### 较大差异的例子
We will take the “Login use case” for 2 different tenants. Consider the picture below, where on the left hand side of the image expects an email, password and also shows Forgot password link and Sign In Button. On the right hand side, we take an email and password along with a ***header*** with ***few additional more links*** along with the sign In Button. We can clearly see that there are elements in the UI that are shareable between the tenants (for example both the tenants expect an email address/password and allows the user to sign in) but there are tenant specific functional variations as well (for eg the tenant on the right needs additional links and header).
我们使用两个不同租户的 "登录案例" 来说明。请看下图，左边的图片需要一个邮箱，密码，显示忘记密码的链接和一个登录按钮，右边则是邮箱，密码，登录按钮和***页眉***以及***一些额外的链接***。我们可以清楚的看到这两个租户的一些 UI 元素是可以共用的（举例来说就是他们都需要邮箱地址，密码和用户登录），而另外一些特定的功能又是不同的（举例来说就是右边的租户需要额外的链接和页眉）。
Now, before we dive into the how, I want to address the question of “these seem like really different pieces of UI, why are we trying to make it multi brand instead of building a new one?” While the components look quite different, the amount of effort it would take to extend an existing component is smaller than making a new one in the long term (and usually in the short term as well). For example, in login, you might have special security or privacy requirements that must be taken care of which are not visible off the bat, then ensure you have ADA compliance, then you support all the browsers and mweb, handle errors cases, write automation for the forms (oh yeah, we share automation too), make the API calls and other data business (remember, we share our redux too). You get all of this out of the box with the initial component that would all have to be duplicated. In the future, there is also the fact that samsclub might want “show password” if it converts better or maybe walmart wants a create account section. In essence, as one team does bug fixes or a/b tests and has improvements to the forms, these increases are shared across all the tenants/brands.
现在，在我们深入之前我想先来解释一个问题 "这些看起来并不相同的 UI，我们为什么不重新做一个而是尽可能的让它们适用于多个品牌呢？"，从长期来讲（短期也是同理）即使这些组件看起来并不相同，但是基于一个已经存在的组件做拓展所花费的努力任然要小于重新做一个。拿登录来举例，因为你需要特殊的安全和隐私需求所以你必须要注意很多地方例如离开站点后哪些是不可见的，然后还要保证你拥有自动数据采集许可，而且还要支持所有的浏览器和移动端，处理错误，编写表单的自动填充（记住，我们还共享了 redux ）。在组件初始化的时候除了这个盒子以外的所有东西都需要被复制一遍。在未来还有可能发生如果 samsclub 需要优化想要 "显示密码" 或者 walmart 想要一个注册区域。从本质上讲，只要一个团队修复了 bug ，做了 a/b 测试或者改进了表单，那么这些新增的部分都会分享到所有的租户和品牌。
Okay, sorry for the side tracking on the why, let’s talk about how do we solve the problem of code sharing and at the same time provide customization/extensibility?
好了，对于一直阐述为什么这个问题感到很抱歉，接下来就让我们来讨论下如何解决在共享代码的同时又能够提供个性化和拓展性的问题吧。
Well, we will apply 2 of the points discussed above, **Composition** and use **props** to control features within a component,
我们将会应用之前讨论的两点 —— 使用**组合**和**属性**来控制一个组件的特性。
![](https://cdn-images-1.medium.com/max/1600/1*3w8MYZu8-HuChhbQPSrlSg.gif)


![](https://cdn-images-1.medium.com/max/1600/0*X8Kmo4nhFo0ZvJea.)

We will take a different example solving a problem from Aspect oriented programming world. **Aspect-oriented programming** (**AOP**) is a programming paradigm that aims to increase modularity by allowing the separation of cross-cutting concerns. In this example we will try to do **“analytics tracking”** for React components, which is a cross cutting concern.How do we solve this problem?
我们接下来使用一个不同的例子来从面向切面编程的角度来解决问题。**面向切面编程**（**AOP**）是旨在通过允许分离问题的切面来增加模块性的一个编程范式。在这个例子中我们将会试着对 React 组件做一个横切面概念的 **"追踪分析"** 。那么如何来解决这个问题呢？
Well, we will apply the concept of “Higher Order Components” mentioned above.
我们将会使用上面提到的 "高级组件" 的概念。
![](https://cdn-images-1.medium.com/max/1600/0*7Dfmiy7JH4clBEnW.)

If the tenants have different ways in which they do tracking, then we will have different HOC specific for each tenant.
如果租户们在做追踪的时候有不同的方法，那么我们将对每个特定的租户使用不同的 HOC。
On top of the above mentioned strategies, make sure components are coded by adhering to basic software development principles like ***Single Responsibility Principle,*** ***Dont Repeat Yourself(DRY)*** etc., which aides in code sharing between different tenants.
在最上面的提到的策略中，确保编写的组件是遵循像***单一职责原则***，***避免重复原则***之类的可以辅助不同租户间的代码共享的基本软件开发原则。
These are the basic elements of our multi-tenancy strategy at @WalmartLabs. We’ve found this to be a great foundation for developing robust, maintainable applications that share a common backend without sacrificing localization and branding.
这些就是我们在 @WalmartLabs 基于多重租户策略的基础元素。同时也是我们能够开发出健壮，可维护的并且在不牺牲本地化和品牌化的前提下共享一个通用后端的应用的至关重要的基石。