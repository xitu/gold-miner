
> * 原文地址：[Angular vs. React: Which Is Better for Web Development?](https://codeburst.io/angular-vs-react-which-is-better-for-web-development-e0dd1fefab5b)
> * 原文作者：[Brandon Morelli](https://codeburst.io/@bmorelli25)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/angular-vs-react-which-is-better-for-web-development.md](https://github.com/xitu/gold-miner/blob/master/TODO/angular-vs-react-which-is-better-for-web-development.md)
> * 译者：[龙骑将杨影枫](https://github.com/stormrabbit)
> * 校对者：

# Angular vs. React: Which Is Better for Web Development?

# Angular vs React：谁更适合前端开发

## There are countless articles out there debating whether React or Angular is the better choice for web development. Do we need yet another one?

## 大家总在写文章争论，何者是前端开发的更好选择，Angular 还是 React（译者：在中国还要加上 vue :P）。我们必须要另一个吗？

The reason I wrote this article is because none of [the](https://gofore.com/en/angular-2-vs-react-the-final-battle-round-1/)[articles](https://medium.com/javascript-scene/angular-2-vs-react-the-ultimate-dance-off-60e7dfbc379c)[published](https://www.sitepoint.com/react-vs-angular/) already — although they contain great insights — go in-depth enough for a practical front-end developer to decide which one may suit their needs.

我写这篇文章的原因，是因为[这些](https://gofore.com/en/angular-2-vs-react-the-final-battle-round-1/)[发](https://medium.com/javascript-scene/angular-2-vs-react-the-ultimate-dance-off-60e7dfbc379c)[表](https://www.sitepoint.com/react-vs-angular/) 的文章 —— 虽然它们包含不错的观点 —— 并没有深入讨论作为一个实际的前端开发者应该选取那种框架来满足自己的需求。

![](https://cdn-images-1.medium.com/max/1600/0*wom7vFVQS16VhuJB.jpg)

In this article, you will learn how Angular and React both aim to solve similar front-end problems though with very different philosophies, and whether choosing one or the other is merely a matter of personal preference. To compare them, we will build the same application twice, once with Angular and then again with React.

在这篇文章中，我会介绍 Angular 与 React 如何用不同的哲♂学解决同一类前端问题，以及选择哪种框架基本上是看个人喜好。为了方便进行比较，我准备编写同一个 app 两次，一次使用 Angular 一次使用 React。

### Angular’s Untimely Announcement

### Angular 之殇

Two years ago, I wrote an article about the [React Ecosystem](https://www.toptal.com/react/navigating-the-react-ecosystem). Among other points, the article argued that Angular had become the victim of “death by pre-announcement.” Back then, the choice between Angular and almost anything else was an easy one for anyone who didn’t want their project to run on an obsolete framework. Angular 1 was obsolete, and Angular 2 was not even available in alpha version.

两年前，我写了一篇有关 [React 生态系统](https://www.toptal.com/react/navigating-the-react-ecosystem) 的文章。以我的观点来说，Angular 是“预发布时就跪了”的倒霉蛋（victim of “death by pre-announcement”）。那个时候，任何不想让自己项目跑在过时框架上的开发者很容易在 Angular 和 React 之间做出选择。Angular 1 就是被时代抛弃的框架，Angular 2 甚至没有活到 alpha 版本。

On hindsight, the fears were more-or-less justified. Angular 2 changed dramatically and even went through major rewrite just before the final release.

不过事后证明，这种担心是多多少少有合理性的。Angular 2 进行了大幅度的修改，甚至在最终发布前对主要部分进行了重写。

Two years later, we have Angular 4 with a promise of relative stability from here on.

两年后，我们有了相对稳定的 Angular 4。

Now what?

怎么样？

### Angular vs. React: Comparing Apples and Oranges

### Angular vs React：苹果与橘子的比较

Some people say that comparing React and Angular is like comparing apples to oranges. While one is a library that deals with views, the other is a full-fledged framework.

据说把 React 和 Angular 拿来比长短就像把苹果和橘子来比好吃一样。即便 React 只是一个处理界面的库，而 Angular 是一个完整齐备的全家桶框架。

Of course, most [React developers](https://www.toptal.com/react) will add a few libraries to React to turn it into a complete framework. Then again, the resulting workflow of this stack is often still very different from Angular, so the comparability is still limited.

当然，大部分 [React 开发者](https://www.toptal.com/react)会添加一系列的库，使得 React 成为完整的框架。但是这套完整框架的工作流程又一次和 Angular 完全不同，所以其可比性也很有限。

The biggest difference lies in state management. Angular comes with data-binding bundled in, whereas React today is usually augmented by Redux to provide unidirectional data flow and work with immutable data. Those are opposing approaches in their own right, and countless discussions are now going on whether mutable/data binding is better or worse than immutable/unidirectional.

两者最大的差别是对状态（state）的管理。Angular 通过数据绑定（data-binding）来将状态绑在数据上，而 React 如今通常增加 Redux 来提供单项数据流、处理不可变的数据（译者：我个人理解这句话的意思是 Angular 的数据和状态是互相影响的，而 React 只能通过切换不同的状态来显示不同的数据）。这是刚好互相对立的解决问题方法，而且开发者们不停的争论`可变的/数据绑定模式`与`不可变的/单向的数据流`两者间谁更优秀。

### A Level Playing Field

### 公平竞争的环境

As React is famously easier to hack on, I’ve decided, for the purpose of this comparison, to build a React setup that mirrors Angular reasonably closely to allow side-by-side comparison of code snippets.

既然 React 更容易理解，为了便于比较，我决定编写一份 React 与 Angular 的对应表，来合理的并排比较两者的代码结构。

Certain Angular features that stand out but are not in React by default are:

Angular 中有但是 React 没有默认自带的特性有：

**Feature — *Angular package* — React library**

**特性 — *Angular 包* — React 库**

- Data binding, dependency injection (DI) — *@angular/core* — [MobX](https://mobx.js.org/)
- 数据绑定，依赖注入（DI）—— *@angular/core* — [MobX](https://mobx.js.org/)
- Computed properties — [*rxjs*](http://reactivex.io/)— [MobX](https://mobx.js.org/)
- 属性处理（Computed properties） —— [*rxjs*](http://reactivex.io/)— [MobX](https://mobx.js.org/)
- Component-based routing — *@angular/router*— [React Router v4](https://reacttraining.com/react-router/)
- 基于组件的路由 —— *@angular/router*— [React Router v4](https://reacttraining.com/react-router/)
- Material design components — *@angular/material*— [React Toolbox](http://react-toolbox.com/#/)
- Material design 的组件 —— *@angular/material*— [React Toolbox](http://react-toolbox.com/#/)
- CSS scoped to components — *@angular/core* — [CSS modules](https://github.com/css-modules/css-modules)
- CSS 组件作用域 —— *@angular/core* — [CSS modules](https://github.com/css-modules/css-modules)
- Form validations — *@angular/forms* — [FormState](https://formstate.github.io/)
- 表单验证 —— *@angular/forms* — [FormState](https://formstate.github.io/)
- Project generator — *@angular/cli* — [React Scripts TS]
- 程序生产器（Project generator）—— *@angular/cli* — [React Scripts TS]

(https://github.com/wmonk/create-react-app-typescript)

### Data Binding
### 数据绑定

Data binding is arguably easier to start with than the unidirectional approach. Of course, it would be possible to go in completely opposite direction, and use [Redux](http://redux.js.org/) or [mobx-state-tree](https://github.com/mobxjs/mobx-state-tree) with React, and [ngrx](https://github.com/ngrx/store) with Angular. But that would be a topic for another post.

数据绑定相对单项数据流来说可能更适合入门。当然，也可以使用完全相反的做法（指单项数据流），比如使用 React 中的 [Redux](http://redux.js.org/) 或者 [mobx-state-tree](https://github.com/mobxjs/mobx-state-tree)，或者使用 Angular 中的 [ngrx](https://github.com/ngrx/store)。不过那就是另一篇文章所要阐述的内容了。

### Computed Properties
### 属性处理

While performance is concerned, plain getters in Angular are simply out of question as they get called on each render. It’s possible to use [BehaviorSubject]
(https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/subjects/behaviorsubject.md) from [RsJS](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/subjects/behaviorsubject.md), which does the job.

考虑到性能问题，Angular 中简单的 `getters` 每次渲染时都被调用，所以被排除掉了。这次我们使用 [RsJS](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/subjects/behaviorsubject.md) 中的 [BehaviorSubject]
(https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/subjects/behaviorsubject.md) 来处理此类问题。

With React, it’s possible to use [@computed](https://mobx.js.org/refguide/computed-decorator.html) from MobX, which achieves the same objective, with arguably a bit nicer API.

在 React 中，可以使用 MobX 中的 [@computed](https://mobx.js.org/refguide/computed-decorator.html) 来达成相同的效果，而且此 api 会更方便一些。

### Dependency Injection

### 依赖注入

Dependency injection is kind of controversial because it goes against current React paradigm of functional programming and immutability. As it turns out, some kind of dependency injection is almost indispensable in data-binding environments, as it helps with decoupling (and thus mocking and testing) where there is no separate data-layer architecture.

依赖注入有一定的争议性，因为它与当前 React 推行的函数式编程与数据不可变性理念背道而驰。事实证明，某种程度的依赖注入是数据绑定环境中必不可少的部分，因为它可以帮助没有独立数据层的结构（no separate data-layer architecture）解耦（这样做更便于使用模拟数据和测试）。

One more advantage of DI (supported in Angular) is the ability to have different lifecycles of different stores. Most current React paradigms use some kind of global app state which maps to different components, but from my experience, it’s all too easy to introduce bugs when cleaning the global state on component unmount.

另一项依赖注入（Angular 中已支持）的优点是可以在（app）不同的生命周期中保有不同的数据仓库（store）。目前大部分 React 范例使用了映射到不同组件的全局状态（global app state）。但是依我得经验来看，当组件卸载（unmount）的时候清理全局状态很容易产生 bug。

Having a store that gets created on component mount (and being seamlessly available to this component’s children) seems to be really useful, and often overlooked concept.

在组件加载（mount）的时候创建一个独立的数据仓库（而且可以无缝传递给此组件的子组件）非常方便，而且是一项很容易被忽略的概念。

Out of the box in Angular, but quite easily reproducible with MobX as well.

Angular 中这项创造性的做法，在 MobX 中也很容易重现。

### Routing
### 路由

Component-based routing allows components to manage their own sub-routes instead of having one big global router configuration. This approach has finally made it to `react-router` in version 4.

组件依赖的路由允许组件管理自身的子路由，而不是配置一个大的全局路由。这种方案终于在 `react-router` 4 里实现了。

### Material Design

### Material Design

It’s always nice to start with some higher-level components, and material design has become something like an universally-accepted default choice, even in non-Google projects.

使用高级组件（higher-level components）总是很棒的，而 material design 已经成为即便是在非谷歌的项目中也被广泛接受的选择。

I have deliberately chosen [React Toolbox](http://react-toolbox.com/#/) over the usually recommended [Material UI](http://react-toolbox.com/#/), as Material UI has serious self-confessed [performance problems](https://github.com/callemall/material-ui/blob/master/ROADMAP.md#summarizing-what-are-our-main-problems-with-css) with their inline-CSS approach, which they plan to solve in the next version.

我特意选择了 [React Toolbox](http://react-toolbox.com/#/) 而不是通常推荐的 [Material UI](http://react-toolbox.com/#/)，因为 Material UI 有一系列公开承认的行内 css [性能问题](https://github.com/callemall/material-ui/blob/master/ROADMAP.md#summarizing-what-are-our-main-problems-with-css)，而它的开发者们计划在下个版本解决这些问题。

Besides, [PostCSS/cssnext](http://cssnext.io/) used in React Toolbox is starting to replace Sass/LESS anyway.

此外，React Toolbox 中已经开始使用即将取代 Sass/LESS 的 [PostCSS/cssnext](http://cssnext.io/)。

### Scoped CSS
### 带有作用域的 CSS

CSS classes are something like global variables. There are numerous approaches to organizing CSS to prevent conflicts (including [BEM](https://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/)), but there’s a clear current trend in using libraries that help process CSS to prevent those conflict without the need for a [front-end developer](https://www.toptal.com/front-end) to devise elaborate CSS naming systems.

CSS 的类比较像是全局变量一类的东西。有许多方法来组织 CSS 以避免互相起冲突（包括 [BEM](https://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/)），但是当前的趋势是使用库辅助处理 CSS 以避免冲突，而不是需要[前端开发者](https://www.toptal.com/front-end)煞费苦心的给 CSS 起不同的名字。

### Form Validation

### 表单校验

Form validations are a non-trivial and very widely used feature. Good to have those covered by a library to prevent code repetition and bugs.

表单校验是非常重要而且使用广泛的特性，使用相关的库可以有效避免冗余代码和八阿哥。

### Project Generator
### 程序生产器（Project Generator，也就是命令行工具）

Having a CLI generator for a project is just a bit more convenient than having to clone boilerplates from GitHub.

使用一个命令行工具来创建项目比从 Github 上下载样板文件要方便的多。

### Same Application, Built Twice

### 同一个 APP，编写两次

So we are going to create the same application in React and Angular. Nothing spectacular, just a Shoutboard that allows anyone to post messages to a common page.

那么我们准备使用 React 和Anuglar 编写同一个 app。这个 app 并不复杂，只是一个可以供任何人发布帖子的公共贴吧（Shoutboard）。

You can try the applications out here:

你可以在这里体验到这个 app：

- [Shoutboard Angular](http://shoutboard-angular.herokuapp.com/)

- [使用 Angular 编写的贴吧](http://shoutboard-angular.herokuapp.com/)

- [Shoutboard React](https://shoutboard-react.herokuapp.com/)

- [使用 React 编写的贴吧](https://shoutboard-react.herokuapp.com/)

![](https://cdn-images-1.medium.com/max/1600/0*wl5od5FrWzu83l6o.jpg)

If you want to have the whole source code, you can get it from GitHub:

如果想阅读本项目的完整源代码，可以从如下地址下载：

- [Angular 贴吧源码](https://github.com/tomaash/shoutboard-angular)
- [React 贴吧源码](https://github.com/tomaash/shoutboard-react)

You will notice we have used TypeScript for the React app as well. The advantages of type checking in TypeScript are obvious. And now, as better handling of imports, async/await and rest spread have finally arrived in TypeScript 2, it leaves Babel/ES7/[Flow](https://flow.org/) in the dust.

你瞧，我们同样使用 TypeScript 编写 React app，因为能够进行类型检查的优势还是很赞的。作为更好的处理引入的方式（handling of imports)，async/await 以及休眠线程如今终于可以在 TypeScript2 里使用了，这就让 Babel/ES7/[Flow](https://flow.org/) 显得有点过时（leaves Babel/ES7/[Flow](https://flow.org/) in the dust）。

Also, let’s add [Apollo Client](https://github.com/apollographql/apollo-client) to both because we want to use GraphQL. I mean, REST is great, but after a decade or so, it gets old.

同样，我们为两者添加了 [Apollo Client](https://github.com/apollographql/apollo-client)，因为我希望使用 GraphQL 风格的接口。我的意思是，REST 风格的接口确实不错，但是经过十几年的发展后，它已经跟不上时代了。

### Bootstrap and Routing
### 启动与路由

First, let’s take a look at both applications’ entry points.
首先，让我们看一下两者的入口文件：

#### Angular

    // 译者：这里是路由配置
    const appRoutes: Routes = [
      { path: 'home', component: HomeComponent },
      { path: 'posts', component: PostsComponent },
      { path: 'form', component: FormComponent },
      { path: '', redirectTo: '/home', pathMatch: 'full' }
    ]

    @NgModule({
      // 这里是项目中使用组件的声明
      declarations: [
        AppComponent,
        PostsComponent,
        HomeComponent,
        FormComponent,
      ],
      // 这里是引用的第三方库
      imports: [
        BrowserModule,
        RouterModule.forRoot(appRoutes),
        ApolloModule.forRoot(provideClient),
        FormsModule,
        ReactiveFormsModule,
        HttpModule,
        BrowserAnimationsModule,
        MdInputModule, MdSelectModule, MdButtonModule, MdCardModule, MdIconModule
      ],
      // 这里是整个 app 都会使用的服务（service）
      providers: [
        AppService
      ],
      // 这是启动时最先访问的组件
      bootstrap: [AppComponent]
    })

    @Injectable()
    export class AppService {
      username = 'Mr. User'
    }

Basically, all components we want to use in the application need to go to declarations. All third-party libraries to imports, and all global stores to providers. Children components have access to all this, with an opportunity to add more local stuff.

基本上，所有希望使用的组件、所有需要引入的第三方库以及所有 provider 中需要注入的全局数据仓库（global store）都要预先声明。子组件可以访问到已声明的变量，而且有机会可以添加一些自己的东西。

#### React

    const appStore = AppStore.getInstance()
    const routerStore = RouterStore.getInstance()

    const rootStores = {
      appStore,
      routerStore
    }

    ReactDOM.render(
      <Provider {...rootStores} >
        <Router history={routerStore.history} >
          <App>
            <Switch>
              <Route exact path='/home' component={Home as any} />
              <Route exact path='/posts' component={Posts as any} />
              <Route exact path='/form' component={Form as any} />
              <Redirect from='/' to='/home' />
            </Switch>
          </App>
        </Router>
      </Provider >,
      document.getElementById('root')
    )

The `<Provider/>` component is used for dependency injection in MobX. It saves stores to context so that React components can inject them later. Yes, React context can (arguably) be used [safely](https://medium.com/@mweststrate/how-to-safely-use-react-context-b7e343eff076).

`<Provider/>` 组件在 MobX 中被用来依赖注入。它将数据仓库保存在上下文（context）中，这样 React 组件可以稍后进行注入。是的，React 上下文可以（大概）保证使用的[安全性](https://medium.com/@mweststrate/how-to-safely-use-react-context-b7e343eff076)。

The React version is a bit shorter because there are no module declarations — usually, you just import and it’s ready to use. Sometimes this kind of hard dependency is unwanted (testing), so for global singleton stores, I had to use this decades-old [GoF ](https://www.wikiwand.com/en/Design_Patterns)[pattern](https://en.wikipedia.org/wiki/Singleton_pattern):

    export class AppStore {
      static instance: AppStore
      static getInstance() {
        return AppStore.instance || (AppStore.instance = new AppStore())
      }
      @observable username = 'Mr. User'
    }

React 版本的入口文件相对要简短一些，因为不需要做那么多模块声明 —— 通常的情况下，只要导入就可以使用了。有时候这种硬依赖很麻烦（比如测试的时候），所以对于全局单例来说，我只好使用过时的[GoF](https://www.wikiwand.com/en/Design_Patterns) [模式](https://en.wikipedia.org/wiki/Singleton_pattern)。

Angular’s Router is injectable, so it can be used from anywhere, not only components. To achieve the same in react, we use the [mobx-react-router](https://github.com/alisd23/mobx-react-router)package and inject the `routerStore`.

Angular 的路由是已注入的，所以可以在程序的任何地方使用，并不仅仅是组件中。为了在 React 中达到相同的功能，我们使用
[mobx-react-router](https://github.com/alisd23/mobx-react-router) 并注入`routerStore`。

Summary: Bootstrapping both applications is quite straightforward. React has an edge being more simple, using just imports instead of modules, but, as we’ll see later, those modules can be quite handy. Making singletons manually is a bit of a nuisance. As for routing declaration syntax, JSON vs. JSX is just a matter of preference.

总结：两个 app 的启动文件都非常直观。React 看起来更简单一点的，使用 import 代替了模块的加载。不过接下来我们会看到，虽然在入口文件中加载模块有啰嗦，但是之后使用起来会很便利；而手动创建一个单例也有自己的麻烦。至于路由创建时的语法问题，是 JSON 更好还是 JSX 更好只是单纯的个人喜好。

### Links and Imperative Navigation
### 连接（Links）与必要的导航

So there are two cases for switching a route. Declarative, using `<a href...>`elements, and imperative, calling the routing (and thus location) API directly.

现在有两种方法来切换路由。声明式的方法，使用超链接 `<a href...>` 标签；命令式的方法，直接调用 routing （以及 location）API。

#### Angular

    <h1> Shoutboard Application </h1>
    <nav>
      <a routerLink="/home" routerLinkActive="active">Home</a>
      <a routerLink="/posts" routerLinkActive="active">Posts</a>
    </nav>
    <router-outlet></router-outlet>

Angular Router automatically detects which `routerLink` is active, and puts an appropriate `routerLinkActive`class on it, so that it can be styled.

Angular Router 自动检测处于启动状态的 `routerLink`，为其加载适当的 `routerLinkActive` CSS 样式，方便在页面中凸显。

The router uses the special `<router-outlet>` element to render whatever current path dictates. It’s possible to have many `<router-outlet>`s, as we dig deeper into application’s sub-components.

router 使用特殊的  `<router-outlet>` 标签来渲染当前的路径（不管是哪种）。当 app 的子组件嵌套的比较深的时候，便可以使用很多 `<router-outlet>` 标签。

    @Injectable()
    export class FormService {
      constructor(private router: Router) { }
      goBack() {
        this.router.navigate(['/posts'])
      }
    }

The router module can be injected to any service (half-magically by its TypeScript type), the `private`declaration then stores it on the instance without the need for explicit assignment. Use `navigate` method to switch URLs.

路由模块可以注入进任何服务（一般是因为 TypeScript 是强类型语言的功劳），`私有的`声明将其存储在组件的实例上，不需要显示声明。使用 `navigate` 方法便可以切换路径。

#### React

    import * as style from './app.css'
    // …
      <h1>Shoutboard Application</h1>
      <div>
        <NavLink to='/home' activeClassName={style.active}>Home</NavLink>
        <NavLink to='/posts' activeClassName={style.active}>Posts</NavLink>
      </div>
      <div>
        {this.props.children}
      </div>

React Router can also set the class of active link with `activeClassName`.

React  Router 也可以通过 `activeClassName` 来设置当前连接的 CSS 样式。

Here, we cannot provide the class name directly, because it’s been made unique by CSS modules compiler, and we need to use the `style` helper. More on that later.

然而，我们不能直接使用 CSS 样式的名称，因为经过 CSS 模块编译后（CSS 样式的名字）会变得独一无二，所以必须使用 `style` 来进行辅助。稍后会详细解释。

As seen above, React Router uses the `<Switch>` element inside an `<App>`element. As the `<Switch>` element just wraps and mounts the current route, it means that sub-routes of current component are just `this.props.children`. So that’s composable too.

如上面所见，React Router 在 `<App>` 标签内使用 `<Switch>` 标签。因为 `<Switch>` 标签只是包裹并加载当前路由，这意味着当前组件的子路由就是 `this.props.children`。当然这些子组件也是这么组成的。
    export class FormStore {
      routerStore: RouterStore
      constructor() {
        this.routerStore = RouterStore.getInstance()
      }
      goBack = () => {
        this.routerStore.history.push('/posts')
      }
    }

The `mobx-router-store` package also allows easy injection and navigation.

`mobx-router-store` 也允许简单的注入以及导航。

Summary: Both approaches to routing are quite comparable. Angular seems to be more intuitive, while React Router has a bit more straightforward composability.

总结：两种方案都相当类似。Angular 看起来更直观，React 的组合更简单。

### Dependency Injection
### 依赖注入

It has already been proven beneficial to separate the data layer from the presentation layer. What we are trying to achieve with DI here is to make data layers’ components (here called model/store/service) follow the lifecycle of visual components, and thus allow to make one or many instances of such components without the need to touch global state. Also, it should be possible to mix and match compatible data and visualization layers.

事实证明，将数据层与展示层分离开是非常有必要的。我们希望通过依赖注入让数据逻辑层的组件（这里的叫法是 model/store/service）关联上表示层组件的生命周期，这样就可以创造一个或多个的数据层组件实例，不需要干扰全局状态。同时，这么做更容易兼容不同的数据与可视化层。

Examples in this article are very simple, so all the DI stuff might seem like overkill, but it comes in handy as the application grows.

这篇文章的例子非常简单，所有的依赖注入的东西看起来似乎有点画蛇添足。但是随着 app 业务的增加，这种做法会很方便的。

#### Angular

    @Injectable()
    export class HomeService {
      message = 'Welcome to home page'
      counter = 0
      increment() {
        this.counter++
      }
    }

So any class can be made `@injectable`, and its properties and methods made available to components.

任何类（class）均可以使用 `@injectable` 的装饰器进行修饰，这样它的属性与方法便可以在其他组件中调用。

    @Component({
      selector: 'app-home',
      templateUrl: './home.component.html',
      providers: [
        HomeService // 注册在这里
      ]
    })
    export class HomeComponent {
      constructor(
        public homeService: HomeService,
        public appService: AppService,
      ) { }
    }

By registering the `HomeService` to the component’s `providers`, we make it available to this component exclusively. It’s not a singleton now, but each instance of the component will receive a new copy, fresh on the component’s mount. That means no stale data from previous use.

通过将 `HomeService` 注册进组件的 `providers`，此组件获得了一个独有的 `HomeService`。虽然现在它还不是一个实例，但是每一个组件在初始化的时候都会收到一个新的 `HomeService` 副本（译者注：也就是这个时候就算实例啦）。这意味着不会有之前 `HomeService` 使用过的过期数据。

In contrast, the `AppService` has been registered to the `app.module` (see above), so it is a singleton and stays the same for all components, though the life of the application. Being able to control the lifecycle of services from components is a very useful, yet under-appreciated concept.

相对而言，`AppService` 被注册进了 `app.module` 文件（参见之前的入口文件），所以它是驻留在每一个组件中的单例，贯穿整个 app 的生命周期。能够从组件中控制服务的声明周期是一项非常有用、而且常被低估的概念。

DI works by assigning the service instances to the component’s constructor, identified by TypeScript types. Additionally, the `public` keywords auto-assigns the parameters to `this`, so that we don’t need to write those boring `this.homeService = homeService` lines anymore.

依赖注入通过在 TypeScript 类型定义的组件构造函数（constructor）内分配服务（service）的实例来起作用（译者：也就是上面代码中的 `public homeService: HomeService`）。此外，`public` 的关键词修饰的参数会自动赋值给 `this` 的同名变量，这样我们就不必再编写那些无聊的 `this.homeService = homeService` 代码了。

    <div>
      <h3>Dashboard</h3>
      <md-input-container>
        <input mdInput placeholder='Edit your name' [(ngModel)]='appService.username' />
      </md-input-container>
      <br/>
      <span>Clicks since last visit: {{homeService.counter}}</span>
      <button (click)='homeService.increment()'>Click!</button>
    </div>

Angular’s template syntax, arguably quite elegant. I like the `[()]` shortcut, which works like a 2-way data binding, but under the hood, it is actually an attribute binding + event. As the lifecycle of our services dictates, `homeService.counter` is going to reset every time we navigate away from `/home`, but the `appService.username`stays, and is accessible from everywhere.

Angular 的模板语法被证明相当优雅（译者：其实这也算是个人偏好问题吧...），我喜欢 `[()]` 的缩写，这样就代表双向绑定（2-way data binding）。但是其本质上（under the hood）是属性绑定 + 事件驱动。就像（与组件关联后）服务的生命周期所规定的那样，`homeService.counter` 每次离开 `/home` 页面的时候都会重置，但是 `appService.username` 会保留，而且可以在任何页面访问到。

#### React

    import { observable } from 'mobx'

    export class HomeStore {
      @observable counter = 0
      increment = () => {
        this.counter++
      }
    }

With MobX, we need to add the `@observable` decorator to any property we want to make observable.
如果希望通过 MobX 实现同样的效果，我们需要在任何需要监听其变化的属性上添加 `@observable` 装饰器。

    @observer
    export class Home extends React.Component<any, any> {

      homeStore: HomeStore
      componentWillMount() {
        this.homeStore = new HomeStore()
      }

      render() {
        return <Provider homeStore={this.homeStore}>
          <HomeComponent />
        </Provider>
      }
    }

To manage the lifecycle correctly, we need to do a bit more work than in Angular example. We wrap the `HomeComponent` inside a `Provider`, which receives a fresh instance of `HomeStore` on each mount.

为了正确的控制（数据层的）生命周期，开发者必须比 Angular 例子多做一点工作。我们用 `Provider` 来包裹 `HomeComponent` ，这样在每次加载的时候都获得一个新的 `HomeStore` 实例。

    interface HomeComponentProps {
      appStore?: AppStore,
      homeStore?: HomeStore
    }

    @inject('appStore', 'homeStore')
    @observer
    export class HomeComponent extends React.Component<HomeComponentProps, any> {
      render() {
        const { homeStore, appStore } = this.props
        return <div>
          <h3>Dashboard</h3>
          <Input
            type='text'
            label='Edit your name'
            name='username'
            value={appStore.username}
            onChange={appStore.onUsernameChange}
          />
          <span>Clicks since last visit: {homeStore.counter}</span>
          <button onClick={homeStore.increment}>Click!</button>
        </div>
      }
    }

`HomeComponent` uses the `@observer` decorator to listen to changes in `@observable` properties.

`HomeComponent` 使用 `@observer` 装饰器监听被 `@observable` 装饰器修饰的属性变化。

The under-the-hood mechanism of this is quite interesting, so let’s go through it briefly here. The `@observable`decorator replaces a property in an object with getter and setter, which allows it to intercept calls. When the render function of an `@observer` augmented component is called, those properties getters get called, and they keep a reference to the component which called them.

其底层机制很有趣，所以我们简单的介绍一下。`@observable` 装饰器通过替换对象中（被观察）属性的 getter 和 setter 方法，拦截对该属性的调用。当被 `@observer` 修饰的组件调用其渲染函数（render function）时，这些属性的 getter 方法也会被调用，getter 方法会将对属性的引用保存在调用它们的组件上。

Then, when setter is called and the value is changed, render functions of components that used the property on the last render are called. Now, data about which properties are used where are updated, and the whole cycle can start over.

然后，当 setter 方法被调用、这些属性的值也改变的时候，上一次渲染这些属性的组件会（再次）调用其渲染函数。这样被改变过的属性会在界面上更新，然后整个周期会重新开始（译者注：其实就是典型的观察者模式啊...）。

A very simple mechanism, and quite performant as well. More in-depth explanation [here](https://medium.com/@mweststrate/becoming-fully-reactive-an-in-depth-explanation-of-mobservable-55995262a254).

这是一个非常简单的机制，也是很棒的特性。更深入的解释在[这里](https://medium.com/@mweststrate/becoming-fully-reactive-an-in-depth-explanation-of-mobservable-55995262a254).

The `@inject` decorator is used to inject `appStore` and `homeStore` instances into `HomeComponent`’s props. At this point, each of those stores has different lifecycle. `appStore` is the same during the application’s life, but `homeStore` is freshly created on each navigation to the “/home” route.

`@inject` 装饰器用来将 `appStore` 和 `homeStore` 的实例注入进 `HomeComponent` 的属性。这种情况下，每一个数据仓库（也）具有不同的生命周期。`appStore` 的生命周期同样也贯穿整个 app，而 `homeStore` 在每次进入 "/home" 页面的时候重新创建。

The benefit of this is that it’s not necessary to clean the properties manually as it is the case when all stores are global, which is a pain if the route is some “detail” page that contains completely different data each time.

这么做的好处，是不需要手动清理属性。如果所有的数据仓库都是全局变量，每次详情页想展示不同的数据就会很崩溃（译者：因为每次都要手动擦掉上一次的遗留数据）。

Summary: As the provider lifecycle management in an inherent feature of Angular’s DI, it is, of course, more simple to achieve it there. The React version is also usable but involves much more boilerplate.

总结：因为自带管理生命周期的特性，Angular 的依赖注入更容易获得预期的效果。React 版本的做法也很有效，但是会涉及到更多的引用。

### Computed Properties

### 处理过的属性

#### React

Let’s start with React on this one, it has a more straightforward solution.

这次我们先讲 React，它的做法更直观一些。

    import { observable, computed, action } from 'mobx'

    export class HomeStore {
    import { observable, computed, action } from 'mobx'

    export class HomeStore {
      @observable counter = 0
      increment = () => {
        this.counter++
      }
      @computed get counterMessage() {
        console.log('recompute counterMessage!')
        return `${this.counter} ${this.counter === 1 ? 'click' : 'clicks'} since last visit`
      }
    }

So we have a computed property that binds to `counter` and returns a properly pluralized message. The result of `counterMessage` is cached, and recomputed only when `counter` changes.

这样我们就将处理过的属性绑定到 `counter` 上，同时返回一段根据点击数量来确定的信息。`counterMessage` 被放在缓存中，只有当 `counter` 属性被改变的时候才重新进行处理。

    <Input
      type='text'
      label='Edit your name'
      name='username'
      value={appStore.username}
      onChange={appStore.onUsernameChange}
    />
    <span>{homeStore.counterMessage}</span>
    <button onClick={homeStore.increment}>Click!</button>

Then, we reference the property (and `increment` method) from the JSX template. The input field is driven by binding to a value, and letting a method from `appStore` handle the user event.

然后我们在 JSX 模版中引用此属性（以及 `increment` 方法）。再讲用户的姓名数据绑定在输入框（input field）上，通过 `appStore` 的一个方法处理用户的(输入)事件。

#### Angular

To achieve the same effect in Angular, we need to be a bit more inventive.

为了在 Angular 中实现相同的结果，我们必须另辟蹊径。

    import { Injectable } from '@angular/core'
    import { BehaviorSubject } from 'rxjs/BehaviorSubject'

    @Injectable()
    export class HomeService {
      message = 'Welcome to home page'
      counterSubject = new BehaviorSubject(0)
      // Computed property can serve as basis for further computed properties
      // 初始化属性，可以作为进一步属性处理的基础
      counterMessage = new BehaviorSubject('')
      constructor() {
        // Manually subscribe to each subject that couterMessage depends on
        // 手动订阅 couterMessage 依赖的方法
        this.counterSubject.subscribe(this.recomputeCounterMessage)
      }

      // Needs to have bound this
      // 需要设置约束
      private recomputeCounterMessage = (x) => {
        console.log('recompute counterMessage!')
        this.counterMessage.next(`${x} ${x === 1 ? 'click' : 'clicks'} since last visit`)
      }

      increment() {
        this.counterSubject.next(this.counterSubject.getValue() + 1)
      }
    }

We need to define all values that serve as a basis for a computed property as a `BehaviorSubject`. The computed property itself is also an `BehaviorSubject`, because any computed property can serve as an input for another computed property.

我们需要初始化所有计算属性（computed property）的值，也就是所谓的 `BehaviorSubject`。计算属性自身同样也是 `BehaviorSubject` ，因为每次计算后属性都是另一个计算属性的基础。

Of course, `RxJS` can do [much more](https://www.sitepoint.com/functional-reactive-programming-rxjs/) than just this, but that would be a topic for a completely different article. The minor downside is that this trivial use of RxJS for just computed properties is a bit more verbose than the react example, and you need to manage subscriptions manually (like here in constructor).

当然，RxJs 可以做的[远不于此](https://www.sitepoint.com/functional-reactive-programming-rxjs/)，不过还是留待另一篇文章去详细讲述吧。在简单的情况下强行使用 Rxjs 处理计算属性的话反而会比 React 例子要麻烦一点，而且程序员必须手动去订阅（就像在构造函数中做的那样）。

    <md-input-container>
      <input mdInput placeholder='Edit your name' [(ngModel)]='appService.username' />
    </md-input-container>
    <span>{{homeService.counterMessage | async}}</span>
    <button (click)='homeService.increment()'>Click!</button>

Note how we can reference the RxJS subject with the `| async` pipe. That is a nice touch, much shorter than needing to subscribe in your components. The `input` component is driven by the `[(ngModel)]` directive. Despite looking strange, it’s actually quite elegant. Just a syntactic sugar for data-binding of value to `appService.username`, and auto-assigning value from user input event.

注意，我们可以通过 `| async` 的管道（pipe）来引用 RxJS 项目。这是一个很棒的做法，比在组件中订阅要简短一些。用户姓名与输入框则通过 `[(ngModel)]` 实现了双向绑定。尽管看起来很奇怪，但这么做实际上相当优雅（译者：优雅你妹）。就像一个数据绑定到 `appService.username` 的语法糖，而且自动相应用户的输入事件。

Summary: Computed properties are easier to implement in React/MobX than in Angular/RxJS, but RxJS might provide some more useful FRP features, that might be appreciated later.

总结：计算属性在 React/MobX 比在 Angular/RxJ 中更容易实现，但是 RxJS 可以提供一些有用的函数式响应编程（FRP）的、不久之后会被人们所称赞的新特性。

### Templates and CSS
### 模板与 CSS

To show how templating stacks against each other, let’s use the Posts component that displays a list of posts.

为了演示两者的模版栈是多么的相爱相杀（against each other），我们来编写一个展示帖子列表的组件。

#### Angular

    @Component({
      selector: 'app-posts',
      templateUrl: './posts.component.html', // 使用 templateUrl 关联组件的模版文件
      styleUrls: ['./posts.component.css'], // 使用 styleUrls 关联组件的 css 文件
      providers: [
        PostsService
      ]
    })

    export class PostsComponent implements OnInit {
      // 译者：请注意这里的 implements OnInit，这是 Angular 4 为了实现控制组件生命周期而提供的钩子（hook）接口
      constructor(
        public postsService: PostsService,
        public appService: AppService
      ) { }

      // 这里是对 OnInit 的具体实现，所以 ngOnInit 的名字不能错
      // ngOnInit 方法在组件初始化的时候会被调用
      // 以达到和 React 中 componentWillMount 相同的作用
      // Angular 4 还提供了很多的生命周期钩子
      // 结果译者都没记住（捂脸跑）
      ngOnInit() {
        this.postsService.initializePosts()
      }
    }

This component just wires together HTML, CSS, and injected services and also calls the function to load posts from API on initialization. `AppService` is a singleton defined in the application module, whereas `PostsService`is transient, with a fresh instance created on each time component created. CSS that is referenced from this component is scoped to this component, which means that the content cannot affect anything outside the component.

本组件（指 post.component.ts 文件）连接了此组件（指具体的帖子组件）的 HTML、CSS，而且在组件初始化的时候通过注入过的服务从 API 读取帖子的数据。AppService 是一个定义在 app 入口文件中的单例，而 PostsService 则是暂时的、每次创建组件时都会重新初始化的一个实例(译者：又是不同生命周期的不同数据仓库)。CSS 被引用到组件内，以便于将作用域限定在本组件内 —— 这意味着它不会影响组件外的东西。

    <a routerLink="/form" class="float-right">
      <button md-fab>
        <md-icon>add</md-icon>
      </button>
    </a>
    <h3>Hello {{appService.username}}</h3>
    <md-card *ngFor="let post of postsService.posts">
      <md-card-title>{{post.title}}</md-card-title>
      <md-card-subtitle>{{post.name}}</md-card-subtitle>
      <md-card-content>
        <p>
          {{post.message}}
        </p>
      </md-card-content>
    </md-card>

In the HTML template, we reference mostly components from Angular Material. To have them available, it was necessary to include them in the `app.module` imports (see above). The `*ngFor` directive is used to repeat the `md-card` component for each post.

在 HTML 模版中，我们从 Angular Material 引用了大部分组件。为了保证其正常使用，必须把把它们包含在 app.module 的 import 里（参见上面的入口文件）。*ngFor 指令用来循环使用 md-card 输出每一个帖子。

**Local CSS:**

    .mat-card {
      margin-bottom: 1rem;
    }

The local CSS just augments one of the classes present on the `md-card`component.
  这段局部 CSS 只在 `md-card` 组件中起作用

**Global CSS:**

    .float-right {
      float: right;
    }

This class is defined in global `style.css` file to make it available for all components. It can be referenced in the standard way, `class="float-right"`.

  // 这段 CSS 类定义在全局样式文件 `style.css` 中，这样所有的组件都可以用标准的方法使用它（指 style.css 文件）的样式，class="float-right"。

**Compiled CSS:**

    .float-right {
      float: right;
    }
    .mat-card[_ngcontent-c1] {
        margin-bottom: 1rem;
    }

In compiled CSS, we can see that the local CSS has been scoped to the rendered component by using the `[_ngcontent-c1]` attribute selector. Every rendered Angular component has a generated class like this for CSS scoping purposes.

在编译后的 CSS 文件中，我们可以发现局部 CSS 的作用域通过添加 `[_ngcontent-c1]` 的属性选择器被限定在本组件中。每一个已渲染的 Angular 组件都会产生一个用作确定 CSS 作用域的类。

The advantage of this mechanism is that we can reference classes normally, and the scoping is handled “under the hood.”

这种机制的优势是我们可以正常的引用 CSS 样式，而 CSS 的作用域在后台被处理了（is handled “under the hood”）。

#### React

    import * as style from './posts.css'
    import * as appStyle from '../app.css'

    @observer
    export class Posts extends React.Component<any, any> {

      postsStore: PostsStore
      componentWillMount() {
        this.postsStore = new PostsStore()
        this.postsStore.initializePosts()
      }

      render() {
        return <Provider postsStore={this.postsStore}>
          <PostsComponent />
        </Provider>
      }
    }

In React, again, we need to use the `Provider` approach to make `PostsStore`dependency “transient”. We also import CSS styles, referenced as `style` and `appStyle`, to be able to use the classes from those CSS files in JSX.

在 React 中，开发者又一次需要使用 Provider 来使 PostsStore 的 依赖“短暂（transient）”。我们同样引入 CSS 样式，声明为 `style` 以及 `appStyle` ，这样就可以在 JSX 语法中使用 CSS 的样式了。

    interface PostsComponentProps {
      appStore?: AppStore,
      postsStore?: PostsStore
    }

    @inject('appStore', 'postsStore')
    @observer
    export class PostsComponent extends React.Component<PostsComponentProps, any> {
      render() {
        const { postsStore, appStore } = this.props
        return <div>
          <NavLink to='form'>
            <Button icon='add' floating accent className={appStyle.floatRight} />
          </NavLink>
          <h3>Hello {appStore.username}</h3>
          {postsStore.posts.map(post =>
            <Card key={post.id} className={style.messageCard}>
              <CardTitle
                title={post.title}
                subtitle={post.name}
              />
              <CardText>{post.message}</CardText>
            </Card>
          )}
        </div>
      }
    }

Naturally, JSX feels much more JavaScript-y than Angular’s HTML templates, which can be a good or bad thing depending on your tastes. Instead of `*ngFor`directive, we use the `map` construct to iterate over posts.

当然，JSX 的语法比 Angular 的 HTML 模版更有 javascript 的风格，是好是坏取决于开发者的喜好。我们使用高阶函数 `map` 来代替 *ngFor 指令循环输出帖子。

Now, Angular might be the framework that touts TypeScript the most, but it’s actually JSX where TypeScript really shines. With the addition of CSS modules (imported above), it really turns your template coding into code completion zen. Every single thing is type-checked. Components, attributes, even CSS classes (`appStyle.floatRight` and `style.messageCard`, see below). And of course, the lean nature of JSX encourages splitting into components and fragments a bit more than Angular’s templates.

如今，Angular 也许是使用 TypeScript 最多的框架，但是实际上 JSX 语法才是 TypeScript 能真正发挥作用的地方。通过添加 CSS 模块（在上面引入的），它能够将模版转化为高质量的代码之道（code completion zen）。每一个事情都是经过类型检验的。组件、属性甚至 CSS 类（`appStyle.floatRight` 以及 `style.messageCard` 见下）。当然，JSX 语法的单薄特性比起 Angular 的模版更鼓励将代码拆分成组件和片段（fragment）。

**Local CSS:**

    .messageCard {
      margin-bottom: 1rem;
    }

**Global CSS:**

    .floatRight {
      float: right;
    }

**Compiled CSS:**

    .floatRight__qItBM {
      float: right;
    }

    .messageCard__1Dt_9 {
        margin-bottom: 1rem;
    }

As you can see, the CSS Modules loader postfixes each CSS class with a random postfix, which guarantees uniqueness. A straightforward way to avoid conflicts. Classes are then referenced through the webpack imported objects. One possible drawback of this can be that you cannot just create a CSS with a class and augment it, as we did in the Angular example. On the other hand, this can be actually a good thing, because it forces you to encapsulate styles properly.

如你所见，CSS 模块加载器通过在每一个 CSS 类之后添加随机的后缀来保证其名字独一无二。这是一种非常简单的、可以有效避免命名冲突的办法。（编译好的）CSS 类随后会被 webpack 打包好的对象引用。这么做的缺点之一是不能像 Angular 那样只创建一个 CSS 文件来使用。但是从另一方面来说，这也未尝不是一件好事。因为这种机制会强迫你正确的封装 CSS 样式。

Summary: I personally like JSX a bit better that Angular templates, especially because of the code completion and type checking support. That really is a killer feature. Angular now has the AOT compiler, which also can spot a few things, code completion also works for about half of the stuff there, but it’s not nearly as complete as JSX/TypeScript.

总结：比起 Angular 的模版，我更喜欢 JSX 语法多一点，尤其是代码补全以及类型检查。这真是一项杀手锏（really is a killer feature）。Angular 现在采用了 AOT 编译器，也有一些新的东西，代码补全同样在一半的情况下起作用，但是不如 JSX/TypeScript 中做的那么完善。

### GraphQL — Loading Data

### GraphQL — 加载数据

So we’ve decided to use GraphQL to store data for this application. One of the easiest ways to create GraphQL back-end is to use some BaaS, like Graphcool. So that’s what we did. Basically, you just define models and attributes, and your CRUD is good to go.

那么我们决定使用 GraphQL 来保存本 app 的数据。在服务端创建 GraphQL 风格的接口的简单方法之一就是使用后端即时服务（Baas），比如说 Graphcool。其实，我们就是这么做的。基本上，开发者只需要定义数据模型和属性，随后就可以方便的进行增删改查了。

#### Common Code

#### 通用代码

As some of the GraphQL-related code is 100% the same for both implementations, let’s not repeat it twice:

因为很多 GraphQL 相关的代码实现起来完全相同，那么我们不必重复编写两次：

    const PostsQuery = gql`
      query PostsQuery {
        allPosts(orderBy: createdAt_DESC, first: 5)
        {
          id,
          name,
          title,
          message
        }
      }
    `

GraphQL is a query language aimed at providing a richer set of functionality compared to classical RESTful endpoints. Let’s dissect this particular query.

比起传统的 REST风格的接口，GraphQL 是一种为了提供函数性富集合的查询语言。让我们分析一下这个特定的查询。

- `PostsQuery` is just a name for this query to reference later, it can be named anything.
- `PostsQuery` 只是该查询被随后引用的名称，可以任意起名。

- `allPosts` is the most important part - it references the function to query all records with the `Post` model. This name was created by Graphcool.

- allPosts 是最重要的部分：它是查询所有帖子数据函数的引用。这是 Graphcool 创建的名字。

- `orderBy` and `first` are parameters of the `allPosts` function. `createdAt`is one of the `Post` model's attributes. `first: 5` means that it will return just first 5 results of the query.

- `orderBy` 和 `first` 是 allPost 的参数，`createdAt` 是帖子数据模型的一个属性。`first: 5` 意思是返回查询结果的前 5 条数据。

- `id`, `name`, `title`, and `message` are the attributes of the `Post` model that we want to be included in the result. Other attributes will be filtered out.

- `id`、`name`、`title`、以及 `message` 是我们希望在返回的结果中包含`帖子`的数据属性，其他的属性会被过滤掉。

As you can already see, it’s pretty powerful. Check out [this page](http://graphql.org/learn/queries/) to familiarize yourself more with GraphQL queries.

你瞧，这真的太棒了。仔细阅读[这个页面](http://graphql.org/learn/queries/)的内容来熟悉更多有关 GraphQL 查询的东西。

    interface Post {
      id: string
      name: string
      title: string
      message: string
    }

    interface PostsQueryResult {
      allPosts: Array<Post>
    }

Yes, as good TypeScript citizens, we create interfaces for GraphQL results.

然后，作为 TypeScript 的好市民，我们为 GraphQL 的结果创建了接口。

#### Angular

    @Injectable()
    export class PostsService {
      posts = []

      constructor(private apollo: Apollo) { }

      initializePosts() {
        this.apollo.query<PostsQueryResult>({
          query: PostsQuery,
          fetchPolicy: 'network-only'
        }).subscribe(({ data }) => {
          this.posts = data.allPosts
        })
      }
    }

The GraphQL query is an RxJS observable, and we subscribe to it. It works a bit like a promise, but not quite, so we are out of luck using `async/await`. Of course, there’s still [toPromise](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/core/operators/topromise.md), but it does not seem to be the Angular way anyway. We set `fetchPolicy: 'network-only'` because in this case, we don’t want to cache the data, but refetch each time.

GraphQL 查询结果集是一个 RxJS 的被观察者类（observable），该结果集可供我们订阅。它有点像 Promise，但并不是完全一样，所以我们不能使用 async/await。当然，确实有 toPromise 方法（将其转化为 Promise 对象），但是这种做法并不是 Angular 的风格（译者：那为啥 Angular 4 的入门 demo 用的就是 toPromise...）。我们通过设置 `fetchPolicy: 'network-only'` 来保证在这种情况不进行缓存操作，而是每次都从服务端获取最新数据。

#### React

    export class PostsStore {
      appStore: AppStore

      @observable posts: Array<Post> = []

      constructor() {
        this.appStore = AppStore.getInstance()
      }

      async initializePosts() {
        const result = await this.appStore.apolloClient.query<PostsQueryResult>({
          query: PostsQuery,
          fetchPolicy: 'network-only'
        })
        this.posts = result.data.allPosts
      }
    }

The React version is almost identical, but as the `apolloClient` here uses promises, we can take advantage of the `async/await` syntax. There are other approaches in React that just “tape” the GraphQL queries to [higher order components](https://github.com/apollographql/react-apollo), but it seemed to me as mixing together the data and presentation layer a tad too much.

React 版本的做法差不多一样，不过既然 `apolloClient` 使用了 Promise，我们就可以体会到 async/await 语法的优点了（译者：async/await 语法的优点便是用写同步代码的模式处理异步情况，不必在使用 Promose 的 then 回调，逻辑更清晰，也更容易 debug）。React 中有其他做法，便是在[高阶组件](https://github.com/apollographql/react-apollo)中“记录” GraphQL 查询结果集，但是对我来说这么做显得数据层和展示层耦合度太高了。

Summary: The ideas of the RxJS subscribe vs. async/await are really quite the same.

总结：RxJS 中的订阅以及 async/await 其实有着非常相似的观念。

### GraphQL — Saving Data

GraphQL — 保存数据

#### Common Code

通用代码

Again, some GraphQL related code:

又一次，这是 GraphQL 相关的代码：

    const AddPostMutation = gql`
      mutation AddPostMutation($name: String!, $title: String!, $message: String!) {
        createPost(
          name: $name,
          title: $title,
          message: $message
        ) {
          id
        }
      }
    `

The purpose of mutations is to create or update records. It’s therefore beneficial to declare some variables with the mutation because those are the way how to pass data into it. So we have `name`, `title`, and `message`variables, typed as a `String`, which we need to fill each time we call this mutation. The `createPost` function, again, is defined by Graphcool. We specify that the `Post` model’s keys will have values from out mutation variables, and also that we want just the `id` of the newly created Post to be sent in return.


修改（mutations，GraphQL 术语）的目的是为了创建或者更新数据。在修改中声明一些变量是十分有益的，因为这其实是传递数据的方式。我们有 `name`、`title`、以及 `message` 这些变量，类型为字符串，每次调用本修改的时候都会为其赋值。`createPost` 函数，又一次是由 Graphcool 来定义的。我们指定 `Post` 数据模型的属性会从修改（mutation）对应的属性里获得属性值，而且希望每创建一条新数据的时候都会返回一个新的 id。

#### Angular

    @Injectable()
    export class FormService {
      constructor(
        private apollo: Apollo,
        private router: Router,
        private appService: AppService
      ) { }

      addPost(value) {
        this.apollo.mutate({
          mutation: AddPostMutation,
          variables: {
            name: this.appService.username,
            title: value.title,
            message: value.message
          }
        }).subscribe(({ data }) => {
          this.router.navigate(['/posts'])
        }, (error) => {
          console.log('there was an error sending the query', error)
        })
      }

    }

When calling `apollo.mutate`, we need to provide the mutation we call and the variables as well. We get the result in `subscribe` callback and use the injected `router` to navigate back to post list.

当调用 `apollo.mutate` 方法的时候，我们会传入一个希望的修改（mutation）以及修改中所包含的变量值。然后在订阅的回调函数中获得返回结果，使用注入的`路由`来跳转帖子列表页面。

#### React

    export class FormStore {
      constructor() {
        this.appStore = AppStore.getInstance()
        this.routerStore = RouterStore.getInstance()
        this.postFormState = new PostFormState()
      }

      submit = async () => {
        await this.postFormState.form.validate()
        if (this.postFormState.form.error) return
        const result = await this.appStore.apolloClient.mutate(
          {
            mutation: AddPostMutation,
            variables: {
              name: this.appStore.username,
              title: this.postFormState.title.value,
              message: this.postFormState.message.value
            }
          }
        )
        this.goBack()
      }

      goBack = () => {
        this.routerStore.history.push('/posts')
      }
    }

Very similar to above, with the difference of more “manual” dependency injection, and the usage of `async/await`.

和上面 Angular 的做法非常相似，差别就是有更多的“手动”依赖注入，更多的 async/await 的做法。

Summary: Again, not much difference here. subscribe vs. async/await is basically all that differs.

总结：又一次，并没有太多不同。订阅与　async/await　基本上就那么点差异。

### Forms

### 表单：

We want to achieve following goals with forms in this application:

我们希望在 app 中用表单达到以下目标：

- Data binding of fields to a model

- 将表单作用域绑定至数据模型

- Validation messages for each field, multiple rules

- 为每个表单域进行校验，有多条校验规则

- Support for checking whether the whole form is valid

- 支持检查整个表格的值是否合法

#### React

    export const check = (validator, message, options) =>
      (value) => (!validator(value, options) && message)

    export const checkRequired = (msg: string) => check(nonEmpty, msg)

    export class PostFormState {
      title = new FieldState('').validators(
        checkRequired('Title is required'),
        check(isLength, 'Title must be at least 4 characters long.', { min: 4 }),
        check(isLength, 'Title cannot be more than 24 characters long.', { max: 24 }),
      )
      message = new FieldState('').validators(
        checkRequired('Message cannot be blank.'),
        check(isLength, 'Message is too short, minimum is 50 characters.', { min: 50 }),
        check(isLength, 'Message is too long, maximum is 1000 characters.', { max: 1000 }),
      )
      form = new FormState({
        title: this.title,
        message: this.message
      })
    }

So the [formstate](https://formstate.github.io/#/) library works as follows: For each field of your form, you define a `FieldState`. The passed parameter is the initial value. The `validators` property takes a function, which returns “false” when the value is valid, and a validation message when the value is not valid. With the `check`and `checkRequired` helper functions, it can all look nicely declarative.

[formstate](https://formstate.github.io/#/) 的库是这么工作的：对于每一个表单域，需要定义一个 `FieldState`。`FieldState` 的参数是表单域的初始值。`validators` 属性接受一个函数做参数，如果表单域的值有效就返回 false；如果表单域的值非法，那么就弹出一条提示信息。通过使用 `check`、`checkRequired` 这两个辅助函数，可以使得声明部分的代码看起来很漂亮。

To have the validation for the whole form, it’s beneficial to also wrap those fields with a `FormState` instance, which then provides the aggregate validity.

为了对整个表单进行验证，最好使用另一个 FormState 实例来包裹这些字段，然后提供整体有效性的校验。

    @inject('appStore', 'formStore')
    @observer
    export class FormComponent extends React.Component<FormComponentProps, any> {
      render() {
        const { appStore, formStore } = this.props
        const { postFormState } = formStore
        return <div>
          <h2> Create a new post </h2>
          <h3> You are now posting as {appStore.username} </h3>
          <Input
            type='text'
            label='Title'
            name='title'
            error={postFormState.title.error}
            value={postFormState.title.value}
            onChange={postFormState.title.onChange}
          />
          <Input
            type='text'
            multiline={true}
            rows={3}
            label='Message'
            name='message'
            error={postFormState.message.error}
            value={postFormState.message.value}
            onChange={postFormState.message.onChange}
          />

The `FormState` instance provides `value`, `onChange`, and `error` properties, which can be easily used with any front-end components.

`FormState` 实例拥有 `value`、`onChange`以及 `error` 三个属性，可以非常方便的在前端组件中使用。

    <Button
            label='Cancel'
            onClick={formStore.goBack}
            raised
            accent
          /> &nbsp;
          <Button
            label='Submit'
            onClick={formStore.submit}
            raised
            disabled={postFormState.form.hasError}
            primary
          />

        </div>

      }
    }

When `form.hasError` is `true`, we keep the button disabled. The submit button sends the form to the GraphQL mutation presented earlier.

当 `form.hasError` 的返回值是 `true` 的时候，我们让按钮控件保持禁用状态。提交按钮发送表单数据到之前编写的 GraphQL 修改（mutation）上。

#### Angular

In Angular, we are going to use `FormService` and `FormBuilder`, which are parts of the

在 Angular 中，我们会使用 @angular/formspackage 中的 `FormService` 和 `FormBuilder`。

`@angular/forms`package.

    @Component({
      selector: 'app-form',
      templateUrl: './form.component.html',
      providers: [
        FormService
      ]
    })
    export class FormComponent {
      postForm: FormGroup
      validationMessages = {
        'title': {
          'required': 'Title is required.',
          'minlength': 'Title must be at least 4 characters long.',
          'maxlength': 'Title cannot be more than 24 characters long.'
        },
        'message': {
          'required': 'Message cannot be blank.',
          'minlength': 'Message is too short, minimum is 50 characters',
          'maxlength': 'Message is too long, maximum is 1000 characters'
        }
      }

First, let’s define the validation messages.

首先，让我们定义校验信息。

    constructor(
        private router: Router,
        private formService: FormService,
        public appService: AppService,
        private fb: FormBuilder,
      ) {
        this.createForm()
      }

      createForm() {
        this.postForm = this.fb.group({
          title: ['',
            [Validators.required,
            Validators.minLength(4),
            Validators.maxLength(24)]
          ],
          message: ['',
            [Validators.required,
            Validators.minLength(50),
            Validators.maxLength(1000)]
          ],
        })
      }

Using `FormBuilder`, it’s quite easy to create the form structure, even more succintly than in the React example.

使用 `FormBuilder`，很容易创建表格结构，甚至比 React 的例子更出色。

    get validationErrors() {
        const errors = {}
        Object.keys(this.postForm.controls).forEach(key => {
          errors[key] = ''
          const control = this.postForm.controls[key]
          if (control && !control.valid) {
            const messages = this.validationMessages[key]
            Object.keys(control.errors).forEach(error => {
              errors[key] += messages[error] + ' '
            })
          }
        })
        return errors
      }

To get bindable validation messages to the right place, we need to do some processing. This code is taken from the official documentation, with a few small changes. Basically, in FormService, the fields keep reference just to active errors, identified by validator name, so we need to manually pair the required messages to affected fields. This is not entirely a drawback; it, for example, lends itself more easily to internationalization.

为了让绑定的校验信息在正确的位置显示，我们需要做一些处理。这段代码源自官方文档，只做了一些微小的变化。基本上，在 FormService 中，表单域保有根据校验名识别的错误，这样我们就需要手动配对信息与受影响的表单域。这并不是一个完全的缺陷，而是更容易国际化（译者：即指的方便的对提示语进行多语言翻译）。

    onSubmit({ value, valid }) {
        if (!valid) {
          return
        }
        this.formService.addPost(value)
      }

      onCancel() {
        this.router.navigate(['/posts'])
      }
    }

Again, when the form is valid, data can be sent to GraphQL mutation.

和 React 一样，如果表单数据是正确的，那么数据可以被提交到 GraphQL 的修改。

    <h2> Create a new post </h2>
    <h3> You are now posting as {{appService.username}} </h3>
    <form [formGroup]="postForm" (ngSubmit)="onSubmit(postForm)" novalidate>
      <md-input-container>
        <input mdInput placeholder="Title" formControlName="title">
        <md-error>{{validationErrors['title']}}</md-error>
      </md-input-container>
      <br>
      <br>
      <md-input-container>
        <textarea mdInput placeholder="Message" formControlName="message"></textarea>
        <md-error>{{validationErrors['message']}}</md-error>
      </md-input-container>
      <br>
      <br>
      <button md-raised-button (click)="onCancel()" color="warn">Cancel</button>
      <button
        md-raised-button
        type="submit"
        color="primary"
        [disabled]="postForm.dirty && !postForm.valid">Submit</button>
      <br>
      <br>
    </form>

The most important thing is to reference the formGroup we have created with the FormBuilder, which is the `[formGroup]="postForm"` assignment. Fields inside the form are bound to the form model through the `formControlName`property. Again, we disable the “Submit” button when the form is not valid. We also need to add the dirty check, because here, the non-dirty form can still be invalid. We want the initial state of the button to be “enabled” though.

最重要的是引用我们通过 FormBuilder 创建的表单组，也就是 `[formGroup]="postForm"` 分配的数据。表单中的表单域通过 `formControlName` 的属性来限定表单的数据。当然，还得在表单数据验证失败的时候禁用 “Submit” 按钮。顺便还需要添加脏数据检查，因为这种情况下，脏数据可能会引起表单校验不通过。我们希望每次初始化 button 都是可用的。

Summary: This approach to forms in React and Angular is quite different on both validation and template fronts. The Angular approach involves a bit more “magic” instead of straightforward binding, but, on the other hand, is more complete and thorough.

总结：对于 React 以及 Angular 的表单方面来说，表单校验和前端模版差别都很大。Angular 的方法是使用一些更“魔幻”的做法而不是简单的绑定，但是从另一方面说，这么做的更完整也更彻底。

### Bundle size
### 打包后的文件大小

Oh, one more thing. The production minified JS bundle sizes, with default settings from the application generators: notably Tree Shaking in React and AOT compilation in Angular.

哎呀，另一件事。就是使用程序默认设置进行打包后 bundle 文件的大小：特指 React 中的  Tree Shaking 以及 Angular 中的 AOT 编译。

- Angular: 1200 KB
- React: 300 KB

Well, not much surprise here. Angular has always been the bulkier one.

嗯，并不意外，Angular 确实是个巨无霸。

When using gzip, the sizes go down to 275kb and 127kb respectively.

使用 gzip 进行压缩的后，两者的大小分别会降低至 275kb 和 127kb。

Just keep in mind, this is basically all vendor libraries. The amount of actual application code is minimal by comparison, which is not the case in a real-world application. There, the ratio would be probably more like 1:2 than 1:4. Also, when you start including a lot of third-party libraries with React, the bundle size also tends to grow rather quickly.

请记住，这还只是主要的库。相比较而言真正的执行逻辑的代码是很小的部分。在真实的情况下，这部分的比率大概是 1:2 到 1:4 之间。同时，当开发者开始在 React 中引入一堆第三方库的时候，文件的体积也会随之快速增长。

### Flexibility of Libraries vs. Robustness of Framework
### 库的灵活性与框架的稳定性

So it seems that we have not been able (again!) to turn up a clear answer on whether Angular or React is better for web development.

那么，看起来我们还是无法（再一次）对 “Angular 与 React 中何者才是更好的前端开发框架”给出明确的答案。

It turns out that the development workflows in React and Angular can be very similar, depending on which libraries we chose to use React with. Then it’s a mainly a matter of personal preference.

事实证明，React 与 Angular 中的开发工作流程可以非常相似（译者：因为用的是 mobx 而不是 redux），而这其实和使用 React 的哪一个库有关。当然，这还是一个个人喜好问题。

If you like ready-made stacks, powerful dependency injection and plan to use some RxJS goodies, chose Angular.

如果你喜欢现成的技术栈，牛逼的依赖注入而且计划体验 RxJS 的好处，那么选择 Angular 吧。

If you like to tinker and build your stack yourself, you like the straightforwardness of JSX and prefer simpler computable properties, choose React/MobX.

如果你喜欢自由定制自己的技术栈，喜欢 JSX 的直观（译者：我怎么觉得模版更直观...），更喜欢简单的计算属性，那么就用 React/MobX 吧。

Again, you can get the complete source code of the application from this article [here](https://github.com/tomaash/shoutboard-angular) and [here](https://github.com/tomaash/shoutboard-react).

当然，你可以从[这里](https://github.com/tomaash/shoutboard-angular)以及[这里](https://github.com/tomaash/shoutboard-react)获得本文 app 的所有源代码。

Or, if you prefer bigger, RealWorld examples:

或者，如果你喜欢大一点的真实项目：

- [RealWorld Angular 4+](https://github.com/gothinkster/angular-realworld-example-app)
- [RealWorld React/MobX](https://github.com/gothinkster/react-mobx-realworld-example-app)

### Choose Your Programming Paradigm First
### 首先，选择自己的编程范式


Programming with React/MobX is actually more similar to Angular than with React/Redux. There are some notable differences in templates and dependency management, but they have the same mutable/data binding paradigm.

使用 React/MobX 实际上比起 React/Redux 更接近于 Angular。虽然在模版以及依赖管理中有一些显著的差异，但是它们有着相似的可变/数据绑定的风格。

React/Redux with its immutable/unidirectional paradigm is a completely different beast.

React/Redux 与它的不可变/单项数据流的模式则是完全不同的另一种东西（译者：个人观点，主动式观察者模式和函数式响应编程的差异）。

Don’t be fooled by the small footprint of the Redux library. It might be tiny, but it’s a framework never the less. Most of the Redux best practices today are focused on using redux-compatible libraries, like [Redux Saga](https://redux-saga.js.org/) for async code and data fetching, [Redux Form](http://redux-form.com/) for form management, [Reselect](https://github.com/reactjs/reselect) for memorized selectors (Redux’s computed values). and [Recompose](https://github.com/acdlite/recompose) among others for more fine-grained lifecycle management. Also, there’s a shift in Redux community from [Immutable.js](https://facebook.github.io/immutable-js/) to [Ramda](http://ramdajs.com/) or [lodash/fp](https://github.com/lodash/lodash/wiki/FP-Guide), which work with plain JS objects instead of converting them.

不要被 Redux 库的体积迷惑，它也许很娇小，但确实是一个框架。如今大部分 Redux 的优秀做法关注使用兼容 Redux 的库，比如用来处理异步代码以及获取数据的 [Redux Saga](https://redux-saga.js.org/)，用来管理表单的 [Redux Form](http://redux-form.com/)，用来记录选择器（Redux 计算后的值）的[Reselect](https://github.com/reactjs/reselect)，以及用来管理组件生命周期的 [Recompose](https://github.com/acdlite/recompose)。同时 Redux 社区也在从  [Immutable.js](https://facebook.github.io/immutable-js/) 转向  [lodash/fp](https://github.com/lodash/lodash/wiki/FP-Guide)，更专注于处理普通的 JS 对象而不是转化它们。

A nice example of modern Redux is the well-known [React Boilerplate](https://github.com/react-boilerplate/react-boilerplate). It’s a formidable development stack, but if you take a look at it, it is really very, very different from anything we have seen in this post so far.

[React Boilerplate](https://github.com/react-boilerplate/react-boilerplate)是一个非常著名的使用 Redux 的例子。这是一个强大的开发栈，但是如果你仔细研究的话，会发现它与到目前为止本文提到的东西非常、非常不一样。

I feel that Angular is getting a bit of unfair treatment from the more vocal part of JavaScript community. Many people who express dissatisfaction with it probably do not appreciate the immense shift that happened between the old AngularJS and today’s Angular. In my opinion, it’s a very clean and productive framework that would take the world by storm had it appeared 1–2 years earlier.

我觉得主流 JavaScript 社区一直对 Angular 抱有某种程度的偏见（译者：我也有这种感觉，作为全公司唯一会 Angular 的稀有动物每次想在组内推广 Angular 都会遇到无穷大的阻力）。大部分对 Angular 表达不满的人也许还无法欣赏到 Angular 中老版本与新版本之间的巨大改变。以我的观点来看，这是一个非常整洁高效的框架，如果早一两年出现肯定会在世界范围内掀起一阵 Angular 的风潮（译者：可惜早一两年出的是 Angular 1.x）。

Still, Angular is gaining a solid foothold, especially in the corporate world, with big teams and needs for standardization and long-term support. Or to put it in another way, Angular is how Google engineers think web development should be done, if that still amounts to anything.

当然，Angular 还是获得了一个坚实的立足点。尤其是在大型企业中，大型团队需要标准化和长期化的支持。换句话说，Angular 是谷歌工程师们认为前端开发应有的样子，如果它终究能有所成就的话（amounts to anything）。

As for MobX, similar assessment applies. Really great, but underappreciated.

对于 MobX 来说，处境也差不多。十分优秀，但是受众不多。

In conclusion: before choosing between React and Angular, choose your programming paradigm first.

结论是：在选择 React 与 Angular 之前，先选择自己的编程习惯（译者：这结论等于没结论）。

mutable/data-binding or immutable/unidirectional, that… seems to be the real issue.

是可变的/数据绑定 ，还是不可变的/单项数据流？看起来真的很难抉择。

> I hope you enjoyed this guest post! This [article](https://www.toptal.com/front-end/angular-vs-react-for-web-development) was originally posted in [Toptal](https://www.toptal.com/front-end/), and has been republished with permission.

> 我希望你能喜欢这篇客座文章。这篇[文章](https://www.toptal.com/front-end/angular-vs-react-for-web-development) 最初发表在[Toptal](https://www.toptal.com/front-end/)，并且已经获得转载授权。
---

#### ❤ If this post was helpful, please hit the little blue heart

#### ❤ 如果你喜欢这篇文章，轻轻扎一下小蓝心吧老铁


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
