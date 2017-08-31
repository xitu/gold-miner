
  > * 原文地址：[Angular vs. React: Which Is Better for Web Development?](https://codeburst.io/angular-vs-react-which-is-better-for-web-development-e0dd1fefab5b)
  > * 原文作者：[Brandon Morelli](https://codeburst.io/@bmorelli25)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/angular-vs-react-which-is-better-for-web-development.md](https://github.com/xitu/gold-miner/blob/master/TODO/angular-vs-react-which-is-better-for-web-development.md)
  > * 译者：
  > * 校对者：

  # Angular vs. React: Which Is Better for Web Development?

  ## There are countless articles out there debating whether React or Angular is the better choice for web development. Do we need yet another one?

The reason I wrote this article is because none of [the](https://gofore.com/en/angular-2-vs-react-the-final-battle-round-1/)[articles](https://medium.com/javascript-scene/angular-2-vs-react-the-ultimate-dance-off-60e7dfbc379c)[published](https://www.sitepoint.com/react-vs-angular/) already — although they contain great insights — go in-depth enough for a practical front-end developer to decide which one may suit their needs.

![](https://cdn-images-1.medium.com/max/1600/0*wom7vFVQS16VhuJB.jpg)

In this article, you will learn how Angular and React both aim to solve similar front-end problems though with very different philosophies, and whether choosing one or the other is merely a matter of personal preference. To compare them, we will build the same application twice, once with Angular and then again with React.

### Angular’s Untimely Announcement

Two years ago, I wrote an article about the [React Ecosystem](https://www.toptal.com/react/navigating-the-react-ecosystem). Among other points, the article argued that Angular had become the victim of “death by pre-announcement.” Back then, the choice between Angular and almost anything else was an easy one for anyone who didn’t want their project to run on an obsolete framework. Angular 1 was obsolete, and Angular 2 was not even available in alpha version.

On hindsight, the fears were more-or-less justified. Angular 2 changed dramatically and even went through major rewrite just before the final release.

Two years later, we have Angular 4 with a promise of relative stability from here on.

Now what?

### Angular vs. React: Comparing Apples and Oranges

Some people say that comparing React and Angular is like comparing apples to oranges. While one is a library that deals with views, the other is a full-fledged framework.

Of course, most [React developers](https://www.toptal.com/react) will add a few libraries to React to turn it into a complete framework. Then again, the resulting workflow of this stack is often still very different from Angular, so the comparability is still limited.

The biggest difference lies in state management. Angular comes with data-binding bundled in, whereas React today is usually augmented by Redux to provide unidirectional data flow and work with immutable data. Those are opposing approaches in their own right, and countless discussions are now going on whether mutable/data binding is better or worse than immutable/unidirectional.

### A Level Playing Field

As React is famously easier to hack on, I’ve decided, for the purpose of this comparison, to build a React setup that mirrors Angular reasonably closely to allow side-by-side comparison of code snippets.

Certain Angular features that stand out but are not in React by default are:

**Feature — *Angular package* — React library**

- Data binding, dependency injection (DI) — *@angular/core* — [MobX](https://mobx.js.org/)
- Computed properties — [*rxjs*](http://reactivex.io/)— [MobX](https://mobx.js.org/)
- Component-based routing — *@angular/router*— [React Router v4](https://reacttraining.com/react-router/)
- Material design components — *@angular/material*— [React Toolbox](http://react-toolbox.com/#/)
- CSS scoped to components — *@angular/core* — [CSS modules](https://github.com/css-modules/css-modules)
- Form validations — *@angular/forms* — [FormState](https://formstate.github.io/)
- Project generator — *@angular/cli* — [React Scripts TS](https://github.com/wmonk/create-react-app-typescript)

### Data Binding

Data binding is arguably easier to start with than the unidirectional approach. Of course, it would be possible to go in completely opposite direction, and use [Redux](http://redux.js.org/) or [mobx-state-tree](https://github.com/mobxjs/mobx-state-tree) with React, and [ngrx](https://github.com/ngrx/store) with Angular. But that would be a topic for another post.

### Computed Properties

While performance is concerned, plain getters in Angular are simply out of question as they get called on each render. It’s possible to use [BehaviorSubject](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/subjects/behaviorsubject.md) from [RsJS](https://github.com/Reactive-Extensions/RxJS/blob/master/doc/api/subjects/behaviorsubject.md), which does the job.

With React, it’s possible to use [@computed](https://mobx.js.org/refguide/computed-decorator.html) from MobX, which achieves the same objective, with arguably a bit nicer API.

### Dependency Injection

Dependency injection is kind of controversial because it goes against current React paradigm of functional programming and immutability. As it turns out, some kind of dependency injection is almost indispensable in data-binding environments, as it helps with decoupling (and thus mocking and testing) where there is no separate data-layer architecture.

One more advantage of DI (supported in Angular) is the ability to have different lifecycles of different stores. Most current React paradigms use some kind of global app state which maps to different components, but from my experience, it’s all too easy to introduce bugs when cleaning the global state on component unmount.

Having a store that gets created on component mount (and being seamlessly available to this component’s children) seems to be really useful, and often overlooked concept.

Out of the box in Angular, but quite easily reproducible with MobX as well.

### Routing

Component-based routing allows components to manage their own sub-routes instead of having one big global router configuration. This approach has finally made it to `react-router` in version 4.

### Material Design

It’s always nice to start with some higher-level components, and material design has become something like an universally-accepted default choice, even in non-Google projects.

I have deliberately chosen [React Toolbox](http://react-toolbox.com/#/) over the usually recommended [Material UI](http://react-toolbox.com/#/), as Material UI has serious self-confessed [performance problems](https://github.com/callemall/material-ui/blob/master/ROADMAP.md#summarizing-what-are-our-main-problems-with-css) with their inline-CSS approach, which they plan to solve in the next version.

Besides, [PostCSS/cssnext](http://cssnext.io/) used in React Toolbox is starting to replace Sass/LESS anyway.

### Scoped CSS

CSS classes are something like global variables. There are numerous approaches to organizing CSS to prevent conflicts (including [BEM](https://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/)), but there’s a clear current trend in using libraries that help process CSS to prevent those conflict without the need for a [front-end developer](https://www.toptal.com/front-end) to devise elaborate CSS naming systems.

### Form Validation

Form validations are a non-trivial and very widely used feature. Good to have those covered by a library to prevent code repetition and bugs.

### Project Generator

Having a CLI generator for a project is just a bit more convenient than having to clone boilerplates from GitHub.

### Same Application, Built Twice

So we are going to create the same application in React and Angular. Nothing spectacular, just a Shoutboard that allows anyone to post messages to a common page.

You can try the applications out here:

- [Shoutboard Angular](http://shoutboard-angular.herokuapp.com/)
- [Shoutboard React](https://shoutboard-react.herokuapp.com/)

![](https://cdn-images-1.medium.com/max/1600/0*wl5od5FrWzu83l6o.jpg)

If you want to have the whole source code, you can get it from GitHub:

- [Shoutboard Angular source](https://github.com/tomaash/shoutboard-angular)
- [Shoutboard React source](https://github.com/tomaash/shoutboard-react)

You will notice we have used TypeScript for the React app as well. The advantages of type checking in TypeScript are obvious. And now, as better handling of imports, async/await and rest spread have finally arrived in TypeScript 2, it leaves Babel/ES7/[Flow](https://flow.org/) in the dust.

Also, let’s add [Apollo Client](https://github.com/apollographql/apollo-client) to both because we want to use GraphQL. I mean, REST is great, but after a decade or so, it gets old.

### Bootstrap and Routing

First, let’s take a look at both applications’ entry points.

#### Angular

    const appRoutes: Routes = [
      { path: 'home', component: HomeComponent },
      { path: 'posts', component: PostsComponent },
      { path: 'form', component: FormComponent },
      { path: '', redirectTo: '/home', pathMatch: 'full' }
    ]

    @NgModule({
      declarations: [
        AppComponent,
        PostsComponent,
        HomeComponent,
        FormComponent,
      ],
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
      providers: [
        AppService
      ],
      bootstrap: [AppComponent]
    })

    @Injectable()
    export class AppService {
      username = 'Mr. User'
    }

Basically, all components we want to use in the application need to go to declarations. All third-party libraries to imports, and all global stores to providers. Children components have access to all this, with an opportunity to add more local stuff.

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

The React version is a bit shorter because there are no module declarations — usually, you just import and it’s ready to use. Sometimes this kind of hard dependency is unwanted (testing), so for global singleton stores, I had to use this decades-old [GoF ](https://www.wikiwand.com/en/Design_Patterns)[pattern](https://en.wikipedia.org/wiki/Singleton_pattern):

    export class AppStore {
      static instance: AppStore
      static getInstance() {
        return AppStore.instance || (AppStore.instance = new AppStore())
      }
      @observable username = 'Mr. User'
    }

Angular’s Router is injectable, so it can be used from anywhere, not only components. To achieve the same in react, we use the [mobx-react-router](https://github.com/alisd23/mobx-react-router)package and inject the `routerStore`.

Summary: Bootstrapping both applications is quite straightforward. React has an edge being more simple, using just imports instead of modules, but, as we’ll see later, those modules can be quite handy. Making singletons manually is a bit of a nuisance. As for routing declaration syntax, JSON vs. JSX is just a matter of preference.

### Links and Imperative Navigation

So there are two cases for switching a route. Declarative, using `<a href...>`elements, and imperative, calling the routing (and thus location) API directly.

#### Angular

    <h1> Shoutboard Application </h1>
    <nav>
      <a routerLink="/home" routerLinkActive="active">Home</a>
      <a routerLink="/posts" routerLinkActive="active">Posts</a>
    </nav>
    <router-outlet></router-outlet>

Angular Router automatically detects which `routerLink` is active, and puts an appropriate `routerLinkActive`class on it, so that it can be styled.

The router uses the special `<router-outlet>` element to render whatever current path dictates. It’s possible to have many `<router-outlet>`s, as we dig deeper into application’s sub-components.

    @Injectable()
    export class FormService {
      constructor(private router: Router) { }
      goBack() {
        this.router.navigate(['/posts'])
      }
    }

The router module can be injected to any service (half-magically by its TypeScript type), the `private`declaration then stores it on the instance without the need for explicit assignment. Use `navigate` method to switch URLs.

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

Here, we cannot provide the class name directly, because it’s been made unique by CSS modules compiler, and we need to use the `style` helper. More on that later.

As seen above, React Router uses the `<Switch>` element inside an `<App>`element. As the `<Switch>` element just wraps and mounts the current route, it means that sub-routes of current component are just `this.props.children`. So that’s composable too.

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

Summary: Both approaches to routing are quite comparable. Angular seems to be more intuitive, while React Router has a bit more straightforward composability.

### Dependency Injection

It has already been proven beneficial to separate the data layer from the presentation layer. What we are trying to achieve with DI here is to make data layers’ components (here called model/store/service) follow the lifecycle of visual components, and thus allow to make one or many instances of such components without the need to touch global state. Also, it should be possible to mix and match compatible data and visualization layers.

Examples in this article are very simple, so all the DI stuff might seem like overkill, but it comes in handy as the application grows.

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

    @Component({
      selector: 'app-home',
      templateUrl: './home.component.html',
      providers: [
        HomeService
      ]
    })
    export class HomeComponent {
      constructor(
        public homeService: HomeService,
        public appService: AppService,
      ) { }
    }

By registering the `HomeService` to the component’s `providers`, we make it available to this component exclusively. It’s not a singleton now, but each instance of the component will receive a new copy, fresh on the component’s mount. That means no stale data from previous use.

In contrast, the `AppService` has been registered to the `app.module` (see above), so it is a singleton and stays the same for all components, though the life of the application. Being able to control the lifecycle of services from components is a very useful, yet under-appreciated concept.

DI works by assigning the service instances to the component’s constructor, identified by TypeScript types. Additionally, the `public` keywords auto-assigns the parameters to `this`, so that we don’t need to write those boring `this.homeService = homeService` lines anymore.

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

#### React

    import { observable } from 'mobx'

    export class HomeStore {
      @observable counter = 0
      increment = () => {
        this.counter++
      }
    }

With MobX, we need to add the `@observable` decorator to any property we want to make observable.

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

The under-the-hood mechanism of this is quite interesting, so let’s go through it briefly here. The `@observable`decorator replaces a property in an object with getter and setter, which allows it to intercept calls. When the render function of an `@observer` augmented component is called, those properties getters get called, and they keep a reference to the component which called them.

Then, when setter is called and the value is changed, render functions of components that used the property on the last render are called. Now, data about which properties are used where are updated, and the whole cycle can start over.

A very simple mechanism, and quite performant as well. More in-depth explanation [here](https://medium.com/@mweststrate/becoming-fully-reactive-an-in-depth-explanation-of-mobservable-55995262a254).

The `@inject` decorator is used to inject `appStore` and `homeStore` instances into `HomeComponent`’s props. At this point, each of those stores has different lifecycle. `appStore` is the same during the application’s life, but `homeStore` is freshly created on each navigation to the “/home” route.

The benefit of this is that it’s not necessary to clean the properties manually as it is the case when all stores are global, which is a pain if the route is some “detail” page that contains completely different data each time.

Summary: As the provider lifecycle management in an inherent feature of Angular’s DI, it is, of course, more simple to achieve it there. The React version is also usable but involves much more boilerplate.

### Computed Properties

#### React

Let’s start with React on this one, it has a more straightforward solution.

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

#### Angular

To achieve the same effect in Angular, we need to be a bit more inventive.

    import { Injectable } from '@angular/core'
    import { BehaviorSubject } from 'rxjs/BehaviorSubject'

    @Injectable()
    export class HomeService {
      message = 'Welcome to home page'
      counterSubject = new BehaviorSubject(0)
      // Computed property can serve as basis for further computed properties
      counterMessage = new BehaviorSubject('')
      constructor() {
        // Manually subscribe to each subject that couterMessage depends on
        this.counterSubject.subscribe(this.recomputeCounterMessage)
      }

      // Needs to have bound this
      private recomputeCounterMessage = (x) => {
        console.log('recompute counterMessage!')
        this.counterMessage.next(`${x} ${x === 1 ? 'click' : 'clicks'} since last visit`)
      }

      increment() {
        this.counterSubject.next(this.counterSubject.getValue() + 1)
      }
    }

We need to define all values that serve as a basis for a computed property as a `BehaviorSubject`. The computed property itself is also an `BehaviorSubject`, because any computed property can serve as an input for another computed property.

Of course, `RxJS` can do [much more](https://www.sitepoint.com/functional-reactive-programming-rxjs/) than just this, but that would be a topic for a completely different article. The minor downside is that this trivial use of RxJS for just computed properties is a bit more verbose than the react example, and you need to manage subscriptions manually (like here in constructor).

    <md-input-container>
      <input mdInput placeholder='Edit your name' [(ngModel)]='appService.username' />
    </md-input-container>
    <span>{{homeService.counterMessage | async}}</span>
    <button (click)='homeService.increment()'>Click!</button>

Note how we can reference the RxJS subject with the `| async` pipe. That is a nice touch, much shorter than needing to subscribe in your components. The `input` component is driven by the `[(ngModel)]` directive. Despite looking strange, it’s actually quite elegant. Just a syntactic sugar for data-binding of value to `appService.username`, and auto-assigning value from user input event.

Summary: Computed properties are easier to implement in React/MobX than in Angular/RxJS, but RxJS might provide some more useful FRP features, that might be appreciated later.

### Templates and CSS

To show how templating stacks against each other, let’s use the Posts component that displays a list of posts.

#### Angular

    @Component({
      selector: 'app-posts',
      templateUrl: './posts.component.html',
      styleUrls: ['./posts.component.css'],
      providers: [
        PostsService
      ]
    })

    export class PostsComponent implements OnInit {
      constructor(
        public postsService: PostsService,
        public appService: AppService
      ) { }

      ngOnInit() {
        this.postsService.initializePosts()
      }
    }

This component just wires together HTML, CSS, and injected services and also calls the function to load posts from API on initialization. `AppService` is a singleton defined in the application module, whereas `PostsService`is transient, with a fresh instance created on each time component created. CSS that is referenced from this component is scoped to this component, which means that the content cannot affect anything outside the component.

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

**Local CSS:**

    .mat-card {
      margin-bottom: 1rem;
    }

The local CSS just augments one of the classes present on the `md-card`component.

**Global CSS:**

    .float-right {
      float: right;
    }

This class is defined in global `style.css` file to make it available for all components. It can be referenced in the standard way, `class="float-right"`.

**Compiled CSS:**

    .float-right {
      float: right;
    }
    .mat-card[_ngcontent-c1] {
        margin-bottom: 1rem;
    }

In compiled CSS, we can see that the local CSS has been scoped to the rendered component by using the `[_ngcontent-c1]` attribute selector. Every rendered Angular component has a generated class like this for CSS scoping purposes.

The advantage of this mechanism is that we can reference classes normally, and the scoping is handled “under the hood.”

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

Now, Angular might be the framework that touts TypeScript the most, but it’s actually JSX where TypeScript really shines. With the addition of CSS modules (imported above), it really turns your template coding into code completion zen. Every single thing is type-checked. Components, attributes, even CSS classes (`appStyle.floatRight` and `style.messageCard`, see below). And of course, the lean nature of JSX encourages splitting into components and fragments a bit more than Angular’s templates.

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

Summary: I personally like JSX a bit better that Angular templates, especially because of the code completion and type checking support. That really is a killer feature. Angular now has the AOT compiler, which also can spot a few things, code completion also works for about half of the stuff there, but it’s not nearly as complete as JSX/TypeScript.

### GraphQL — Loading Data

So we’ve decided to use GraphQL to store data for this application. One of the easiest ways to create GraphQL back-end is to use some BaaS, like Graphcool. So that’s what we did. Basically, you just define models and attributes, and your CRUD is good to go.

#### Common Code

As some of the GraphQL-related code is 100% the same for both implementations, let’s not repeat it twice:

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

- `PostsQuery` is just a name for this query to reference later, it can be named anything.
- `allPosts` is the most important part - it references the function to query all records with the `Post` model. This name was created by Graphcool.
- `orderBy` and `first` are parameters of the `allPosts` function. `createdAt`is one of the `Post` model's attributes. `first: 5` means that it will return just first 5 results of the query.
- `id`, `name`, `title`, and `message` are the attributes of the `Post` model that we want to be included in the result. Other attributes will be filtered out.

As you can already see, it’s pretty powerful. Check out [this page](http://graphql.org/learn/queries/) to familiarize yourself more with GraphQL queries.

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

Summary: The ideas of the RxJS subscribe vs. async/await are really quite the same.

### GraphQL — Saving Data

#### Common Code

Again, some GraphQL related code:

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

Summary: Again, not much difference here. subscribe vs. async/await is basically all that differs.

### Forms

We want to achieve following goals with forms in this application:

- Data binding of fields to a model
- Validation messages for each field, multiple rules
- Support for checking whether the whole form is valid

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

To have the validation for the whole form, it’s beneficial to also wrap those fields with a `FormState` instance, which then provides the aggregate validity.

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

#### Angular

In Angular, we are going to use `FormService` and `FormBuilder`, which are parts of the `@angular/forms`package.

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

Summary: This approach to forms in React and Angular is quite different on both validation and template fronts. The Angular approach involves a bit more “magic” instead of straightforward binding, but, on the other hand, is more complete and thorough.

### Bundle size

Oh, one more thing. The production minified JS bundle sizes, with default settings from the application generators: notably Tree Shaking in React and AOT compilation in Angular.

- Angular: 1200 KB
- React: 300 KB

Well, not much surprise here. Angular has always been the bulkier one.

When using gzip, the sizes go down to 275kb and 127kb respectively.

Just keep in mind, this is basically all vendor libraries. The amount of actual application code is minimal by comparison, which is not the case in a real-world application. There, the ratio would be probably more like 1:2 than 1:4. Also, when you start including a lot of third-party libraries with React, the bundle size also tends to grow rather quickly.

### Flexibility of Libraries vs. Robustness of Framework

So it seems that we have not been able (again!) to turn up a clear answer on whether Angular or React is better for web development.

It turns out that the development workflows in React and Angular can be very similar, depending on which libraries we chose to use React with. Then it’s a mainly a matter of personal preference.

If you like ready-made stacks, powerful dependency injection and plan to use some RxJS goodies, chose Angular.

If you like to tinker and build your stack yourself, you like the straightforwardness of JSX and prefer simpler computable properties, choose React/MobX.

Again, you can get the complete source code of the application from this article [here](https://github.com/tomaash/shoutboard-angular) and [here](https://github.com/tomaash/shoutboard-react).

Or, if you prefer bigger, RealWorld examples:

- [RealWorld Angular 4+](https://github.com/gothinkster/angular-realworld-example-app)
- [RealWorld React/MobX](https://github.com/gothinkster/react-mobx-realworld-example-app)

### Choose Your Programming Paradigm First

Programming with React/MobX is actually more similar to Angular than with React/Redux. There are some notable differences in templates and dependency management, but they have the same mutable/data binding paradigm.

React/Redux with its immutable/unidirectional paradigm is a completely different beast.

Don’t be fooled by the small footprint of the Redux library. It might be tiny, but it’s a framework nevertheless. Most of the Redux best practices today are focused on using redux-compatible libraries, like [Redux Saga](https://redux-saga.js.org/) for async code and data fetching, [Redux Form](http://redux-form.com/) for form management, [Reselect](https://github.com/reactjs/reselect) for memorized selectors (Redux’s computed values). and [Recompose](https://github.com/acdlite/recompose) among others for more fine-grained lifecycle management. Also, there’s a shift in Redux community from [Immutable.js](https://facebook.github.io/immutable-js/) to [Ramda](http://ramdajs.com/) or [lodash/fp](https://github.com/lodash/lodash/wiki/FP-Guide), which work with plain JS objects instead of converting them.

A nice example of modern Redux is the well-known [React Boilerplate](https://github.com/react-boilerplate/react-boilerplate). It’s a formidable development stack, but if you take a look at it, it is really very, very different from anything we have seen in this post so far.

I feel that Angular is getting a bit of unfair treatment from the more vocal part of JavaScript community. Many people who express dissatisfaction with it probably do not appreciate the immense shift that happened between the old AngularJS and today’s Angular. In my opinion, it’s a very clean and productive framework that would take the world by storm had it appeared 1–2 years earlier.

Still, Angular is gaining a solid foothold, especially in the corporate world, with big teams and needs for standardization and long-term support. Or to put it in another way, Angular is how Google engineers think web development should be done, if that still amounts to anything.

As for MobX, similar assessment applies. Really great, but underappreciated.

In conclusion: before choosing between React and Angular, choose your programming paradigm first.

mutable/data-binding or immutable/unidirectional, that… seems to be the real issue.

> I hope you enjoyed this guest post! This [article](https://www.toptal.com/front-end/angular-vs-react-for-web-development) was originally posted in [Toptal](https://www.toptal.com/front-end/), and has been republished with permission.

---

#### ❤ If this post was helpful, please hit the little blue heart


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  