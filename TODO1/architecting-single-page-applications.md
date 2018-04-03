> * 原文地址：[The 4 Layers of Single Page Applications You Need to Know](https://hackernoon.com/architecting-single-page-applications-b842ea633c2e)
> * 原文作者：[Daniel Dughila](https://hackernoon.com/@danieldughila?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/architecting-single-page-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO1/architecting-single-page-applications.md)
> * 译者：[zwwill 木羽](https://github.com/zwwill)
> * 校对者：

# The 4 Layers of Single Page Applications You Need to Know
# 关于 SPA 的 4 层

## Let’s architect a React application from the ground up, exploring the domain and its services, store, application services and the view.

## 我们从头来构建一个 React 的应用程序，探究领域及服务、存储、应用服务和视图。

![](https://cdn-images-1.medium.com/max/800/1*5aa2cNrij2fVO0rZTJCZHQ.png)

The four layers of single page applications — by [Alberto V](https://dribbble.com/AlbertoV).
SPA 的四层 - 由 [Alberto V](https://dribbble.com/AlbertoV) 提供

Every successful project needs a clear architecture, which is understood by all team members.
每个成功的项目都需要一个清晰的架构，这是所有团队成员都心知肚明的。

Imagine you’re new to the team. The technical leader presents the proposed architecture for the new application coming up on the roadmap:
试想一下，作为团队的新人。技术负责人给你介绍了在项目进程中提出的新应用程序的架构。

![](https://cdn-images-1.medium.com/max/800/1*6wpX8u_mM8Z1xdZVMFj67w.png)

The four layers of single page applications (detailed).
SPA 的四层（细节）

He talks about the requirements:
然后告诉你需求：

> Our app will display a list of articles. As a user, I will be able to create, delete and like articles.
> 我们的应用程序将显示一系列文章。用户能够创建、删除和收藏文章。

And then he asks you to do it!
然后他说，去做吧！

### Ok, no problem, let’s start architecting
### Ok，没问题，我们来搭框架吧

I’ve chosen [Create React App](https://github.com/facebook/create-react-app) and [Flow](https://flow.org) for type checking. For brevity, the application has no styling.
我选择 FaceBook 开源的构建工具 [Create React App](https://github.com/facebook/create-react-app)，使用 [Flow](https://flow.org) 来进行类型检查。为了简捷，暂不开放样式。

As a prerequisite, let’s talk about the declarative nature of modern frameworks, touching on the concept of state.
作为先决条件，让我们讨论一下现代框架的声明性本质，以及涉及到的 state 概念。

### Today’s frameworks are declarative
### 现在的框架多为声明式的

React, Angular, Vue are [declarative](https://tylermcginnis.com/imperative-vs-declarative-programming/), encouraging us to use elements of functionalprogramming.
React， Angular， Vue 都是声明式的，并鼓励我们使用函数式编程的元素。

Have you ever seen a flip book?
你有见过手翻书吗？

> A flip book or flick book is a book with a series of pictures that vary gradually from one page to the next, so that when the pages are turned rapidly, the pictures appear to animate … [1]
> 一本手翻书或电影书，里面有一系列逐页变化的图片，当页面快速翻页的时候，就形成了动态的画面。 [1]

![](https://cdn-images-1.medium.com/max/800/1*YC8GwZboKkBFfJI8cRzUnQ.jpeg)

Now let’s check a part of React’s definition:
现在让我们来看一下 React 中的定义：

> Design simple views for each state in your application, and React will efficiently update and render just the right components when your data changes … [2]
> 在应用程序中为每个状态设计简单的视图， React 会在数据发生变化时高效地更新和渲染正确的组件。 [2]

And a part of Angular’s:
Angular 中的定义：

> Build features quickly with simple, declarative templates. Extend the template language with your own components … [3]
> 使用简单、声明式的模板快速构建特性。使用您自己的组件扩展模板语言。 [3]

Sounds familiar?
大同小异？

Frameworks help us build apps consisting of views. Views are representations of state. But what is the state?
框架帮助我们构建包含视图的应用程序。视图是状态的表象。那状态又是什么？

### The state
### 状态

The state represents every piece of data that changes in an application.
状态表示应用程序中会更改的所有数据。

You visit an URL, that’s state, make an Ajax call to retrieve a list of movies, that’s state again, you persist info to local storage, ditto, state.
你访问一个URL，这是状态，发出一个 Ajax 请求来获取电影列表，这是也状态，将信息持久化到本地存储，同上，也是状态。

The state will consist of **immutable objects**.
状态由一系列**不变对象**组成

[Immutable architecture](http://enterprisecraftsmanship.com/2016/05/12/immutable-architecture) has many benefits, one being at the view level.
[不变对象](http://enterprisecraftsmanship.com/2016/05/12/immutable-architecture)有很多好处，其中一个就是在视图层。

Here is a quote from React’s guide to [optimizing performance](https://reactjs.org/docs/optimizing-performance.html):
下面是 React 指南对[性能优化](https://reactjs.org/docs/optimizing-performance.html)介绍的引言。

> Immutability makes tracking changes cheap. A change will always result in a new object so we only need to check if the reference to the object has changed. [4]
> 不变性使得跟踪更改变得更容易。更改总是会产生一个新对象，所以我们只需要检查对象的引用是否发生了更改。


### The domain layer
### 领域层

The domain describes the state and holds the business logic. It represents the core of our application and should be agnostic to the view layer. Angular, React, Vue, it shouldn’t matter, we should be able to use our domain regardless of the framework we choose.
域可以描述状态并保存业务逻辑。它是应用程序的核心，应该与视图层解耦。Angular， React 或者是 Vue，这些都不重要，重要的是不管选择什么框架，我们都能够使用自己的领。

![](https://cdn-images-1.medium.com/max/800/1*iNmdhMwXJ53tv0fyhhpmmw.png)

The domain layer.
领域层

Because we are dealing with immutable architecture, our domain layer will consist of entities and domain services.
因为我们处理的是不可变的结构，所以我们的领域层将包含实体和域服务。

Controversial in OOP, especially in large-scale applications, the anemic domain model is perfectly acceptable when working with immutable data.
在 OOP 中存在争议，特别是在大规模应用程序中，在使用不可变数据时，贫血模型是完全可以接受的。

> For me, this [course](https://www.pluralsight.com/courses/refactoring-anemic-domain-model) by Vladimir Khorikov was eye-opening.
> 对我来说，弗拉基米尔·克里科夫（Vladimir Khorikov）的[这门课](https://www.pluralsight.com/courses/refactoring-anemic-domain-model)让我大开眼界。

Having to display a list of articles, the first thing we’ll model is the **Article** entity.
要显示文章列表，我们首先要建模的是**Article**实体。

All future objects of type **Article** are meant to be immutable. Flow can [enforce immutability](https://flow.org/en/docs/react/redux/#typing-redux-state-immutability-a-classtoc-idtoc-typing-redux-state-immutability-hreftoc-typing-redux-state-immutabilitya) by making every property read-only(see the plus sign before each prop).
所有 **Article** 类型实体的未来对象都是不可变的。Flow 可以通过使所有属性只读（属性前面带 + 号）来强制将对象不可变。

```
// @flow
export type Article = {
  +id: string;
  +likes: number;
  +title: string;
  +author: string;
}
```

Now let’s create the **articleService** using the factory function pattern.
现在，让我们使用工厂函数模式创建 **articleService**。

> Check out this [video](https://www.youtube.com/watch?v=ImwrezYhw4w) by @mpjme for a great explanation**.**
> 通过查看 @mpjme 的这个[视频]，可得到一个很好的解释

Since we need only one **articleService** in our application, we will export it as a singleton.
由于在我们的应用程序中只需要一个**articleService**，我们将把它导出为一个 singleton。

The **createArticle** methodwill allow us to create [frozen objects](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze) of type **Article**. Each new article will have a unique autogenerated id and zero likes, letting us supply only the author and title.
**createArticle** 允许我们创建 **Article** 的[冻结对象](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze)。每一篇新文章都会有一个唯一的自动生成的id和零收藏，我们仅需要提供作者和标题。

> The `**Object.freeze()**` method freezes an object: that is, prevents new properties from being added to it. [5]
> `**Object.freeze()**` 方法可冻结一个对象：也就是说，将阻止被新曾属性。 [5]

The **createArticle** method returns a “maybe” **Article** type.
**createArticle** 方法返回的是一个 **Article** 的「Maybe」类型

> [Maybe](https://flow.org/en/docs/types/maybe) types enforce you to check if an **Article** object exists before operating on it.
> [Maybe](https://flow.org/en/docs/types/maybe) 类型强制你在操作 **Article** 对象前先检查它是否存在。

If any of the fields necessary to create an article fail validation, the **createArticle** method returns null. Some may argue that it’s better to throw a user-defined exception. If we enforce this and the upper layers do not implement catch blocks, the program will terminate at runtime.
如果创建文章所需要的任一字段无法验证，那么 **createArticle** 方法将返回null。这里可能有人会说，最好抛出一个用户定义的异常。如果我们这么早，但上层不实现catch块，那么程序将在运行时终止。

The **updateLikes** method will help us update the number of likes from anexisting article, by returning a copy of it with the new count.
**updateLikes** 方法会帮我们更新现存文章的收藏数，将返回一个拥有新计数的副本。

Finally, the **isTitleValid** and **isAuthorValid** methods prevent the **createArticle** from working with corrupt data.
最后，**isTitleValid** 和 **isAuthorValid** 方法用来避免 **createArticle** 处理会使其出处的数据。

```
// @flow
import v1 from 'uuid';
import * as R from 'ramda';

import type {Article} from "./Article";
import * as validators from "./Validators";

export type ArticleFields = {
  +title: string;
  +author: string;
}

export type ArticleService = {
  createArticle(articleFields: ArticleFields): ?Article;
  updateLikes(article: Article, likes: number): Article;
  isTitleValid(title: string): boolean;
  isAuthorValid(author: string): boolean;
}

export const createArticle = (articleFields: ArticleFields): ?Article => {
  const {title, author} = articleFields;
  return isTitleValid(title) && isAuthorValid(author) ?
    Object.freeze({
      id: v1(),
      likes: 0,
      title,
      author
    }) :
    null;
};

export const updateLikes = (article: Article, likes: number) =>
  validators.isObject(article) ?
    Object.freeze({
      ...article,
      likes
    }) :
    article;

export const isTitleValid = (title: string) =>
  R.allPass([
    validators.isString,
    validators.isLengthGreaterThen(0)
  ])(title);

export const isAuthorValid = (author: string) =>
  R.allPass([
    validators.isString,
    validators.isLengthGreaterThen(0)
  ])(author);

export const ArticleServiceFactory = () => ({
  createArticle,
  updateLikes,
  isTitleValid,
  isAuthorValid
});

export const articleService = ArticleServiceFactory();
```

Validations are very important in keeping our data consistent, especially at the domain level. We can compose our **Validators** service out of pure functions.
验证对于保持数据一致性非常重要，特别是在领域级别。我们可以用纯函数来编写 **Validators** 服务。


```
// @flow
export const isObject = (toValidate: any) => !!(toValidate && typeof toValidate === 'object');

export const isString = (toValidate: any) => typeof toValidate === 'string';

export const isLengthGreaterThen = (length: number) => (toValidate: string) => toValidate.length > length;
```

Please take these validations with a grain of salt, just for demo purposes.
请使用最小的工程来检验这些验证方法，仅用于演示。

> In JavaScript, checking if an object is, in fact, an object is not that easy. :)
> 事实上，在 JavaScript 中检验一个对象是否为对象并不容易。 :)

We now have our domain layer setup!
现在我们有了自己领域层的结构!

The nice part is that we can use our code right now, agnostic of a framework.
好在现在就可以使用我们的代码来，而无需考虑框架。

Let’s see how we can use the **articleService** to create an article about one of my favorite books and update its number of likes.
让我们来看一下如何使用 **articleService** 创建一篇关于我最喜欢的书的文章，并更新它的收藏数。

```
// @flow
import {articleService} from "../domain/ArticleService";

const article = articleService.createArticle({
  title: '12 rules for life',
  author: 'Jordan Peterson'
});
const incrementedArticle = article ? articleService.updateLikes(article, 4) : null;

console.log('article', article);
/*
   const itWillPrint = {
     id: "92832a9a-ec55-46d7-a34d-870d50f191df",
     likes: 0,
     title: "12 rules for life",
     author: "Jordan Peterson"
   };
 */

console.log('incrementedArticle', incrementedArticle);
/*
   const itWillPrintUpdated = {
     id: "92832a9a-ec55-46d7-a34d-870d50f191df",
     likes: 4,
     title: "12 rules for life",
     author: "Jordan Peterson"
   };
 */
```

### The store layer
### 存储层

The data which results from creating and updating articles represents our application’s state.

We need a place to hold that data, the store being the perfect candidate for the job.

![](https://cdn-images-1.medium.com/max/800/1*h8IDykExd_PhCBhKYr9e0Q.png)

The store layer.

The state can easily be modeled by an array of articles.

```
// @flow
import type {Article} from "./Article";

export type ArticleState = Article[];
```

ArticleState.js

The **ArticleStoreFactory** implements the publish-subscribe pattern and exports the **articleStore** as a singleton.

The store holds the articles and performs the add, remove and update immutable operations on them.

> Keep in mind that the store onlyoperates on articles. Only the **articleService**, can create or update them.

Interested parties can subscribe and unsubscribe to the **articleStore**.

The **articleStore** keeps a list in memory of all subscribers and notifies them of each change.

```
// @flow
import {update} from "ramda";

import type {Article} from "../domain/Article";
import type {ArticleState} from "./ArticleState";

export type ArticleStore = {
  addArticle(article: Article): void;
  removeArticle(article: Article): void;
  updateArticle(article: Article): void;
  subscribe(subscriber: Function): Function;
  unsubscribe(subscriber: Function): void;
}

export const addArticle = (articleState: ArticleState, article: Article) => articleState.concat(article);

export const removeArticle = (articleState: ArticleState, article: Article) =>
  articleState.filter((a: Article) => a.id !== article.id);

export const updateArticle = (articleState: ArticleState, article: Article) => {
  const index = articleState.findIndex((a: Article) => a.id === article.id);
  return update(index, article, articleState);
};

export const subscribe = (subscribers: Function[], subscriber: Function) =>
  subscribers.concat(subscriber);

export const unsubscribe = (subscribers: Function[], subscriber: Function) =>
  subscribers.filter((s: Function) => s !== subscriber);

export const notify = (articleState: ArticleState, subscribers: Function[]) =>
  subscribers.forEach((s: Function) => s(articleState));

export const ArticleStoreFactory = (() => {
  let articleState: ArticleState = Object.freeze([]);
  let subscribers: Function[] = Object.freeze([]);

  return {
    addArticle: (article: Article) => {
      articleState = addArticle(articleState, article);
      notify(articleState, subscribers);
    },
    removeArticle: (article: Article) => {
      articleState = removeArticle(articleState, article);
      notify(articleState, subscribers);
    },
    updateArticle: (article: Article) => {
      articleState = updateArticle(articleState, article);
      notify(articleState, subscribers);
    },
    subscribe: (subscriber: Function) => {
      subscribers = subscribe(subscribers, subscriber);
      return subscriber;
    },
    unsubscribe: (subscriber: Function) => {
      subscribers = unsubscribe(subscribers, subscriber);
    }
  }
});

export const articleStore = ArticleStoreFactory();
```

[ArticleStore.js](https://gist.github.com/intojs/3acd875bf72c42c559e80e0495039bb5#file-articlestorefactory-js)

Our store implementation makes sense for demo purposes, allowing us to understand the concepts behind it. In real life, I recommend using a state management system like [Redux](https://redux.js.org/), [ngrx](https://github.com/ngrx), [MobX](https://github.com/mobxjs/mobx) or at least [observable data services](https://medium.com/bucharestjs/the-developers-guide-to-redux-like-state-management-in-angular-3799f1877bb).

Ok, right now we have the domain and store layers setup.

Let’s create two articles and two subscribers to the store and observe how the subscribers get notified of changes.

```
// @flow
import type {ArticleState} from "../store/ArticleState";
import {articleService} from "../domain/ArticleService";
import {articleStore} from "../store/ArticleStore";

const article1 = articleService.createArticle({
  title: '12 rules for life',
  author: 'Jordan Peterson'
});

const article2 = articleService.createArticle({
  title: 'The Subtle Art of Not Giving a F.',
  author: 'Mark Manson'
});

if (article1 && article2) {
  const subscriber1 = (articleState: ArticleState) => {
    console.log('subscriber1, articleState changed: ', articleState);
  };

  const subscriber2 = (articleState: ArticleState) => {
    console.log('subscriber2, articleState changed: ', articleState);
  };

  articleStore.subscribe(subscriber1);
  articleStore.subscribe(subscriber2);

  articleStore.addArticle(article1);
  articleStore.addArticle(article2);

  articleStore.unsubscribe(subscriber2);

  const likedArticle2 = articleService.updateLikes(article2, 1);
  articleStore.updateArticle(likedArticle2);

  articleStore.removeArticle(article1);
}
```

### Application services

This layer is useful for doing all kinds of operations which are adjacent to the state flow like Ajax calls to retrieve data from the server or state projections.

![](https://cdn-images-1.medium.com/max/800/1*ZVstPN2LBFjdPoRaFq4SEw.png)

The application services layer.

For whatever reason, a designer comes and demands all author names to be uppercase.

We know this request is kind of silly and we don’t want to pollute our model with it.

We create the **ArticleUiService** to handle this feature. The service will take a piece of state, the author’s name, and project it, returning the uppercase version of it to the caller.

```
// @flow
export const displayAuthor = (author: string) => author.toUpperCase();
```

Let’s see a demo on how to consume this service!

```
// @flow
import {articleService} from "../domain/ArticleService";
import * as articleUiService from "../services/ArticleUiService";

const article = articleService.createArticle({
  title: '12 rules for life',
  author: 'Jordan Peterson'
});

const authorName = article ?
  articleUiService.displayAuthor(article.author) :
  null;

console.log(authorName);
// It will print JORDAN PETERSON

if (article) {
  console.log(article.author);
  // It will print Jordan Peterson
}
```

app-service-demo.js

### The view layer

Right now we have a fully working application, agnostic of any framework, ready to be put to life by React.

The view layer is composed of presentational and container components.

Presentational components are concerned with how things look while container components are concerned with how things work. For a detailed explanation check out Dan Abramov’s [article](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0).

![](https://cdn-images-1.medium.com/max/800/1*R-6nKbTqru_qsdg8O7PJJg.png)

The view layer.

Let’s build the **App** component, consisting of the **ArticleFormContainer** and **ArticleListContainer.**

```
// @flow
import React, {Component} from 'react';

import './App.css';

import {ArticleFormContainer} from "./components/ArticleFormContainer";
import {ArticleListContainer} from "./components/ArticleListContainer";

type Props = {};

class App extends Component<Props> {
  render() {
    return (
      <div className="App">
        <ArticleFormContainer/>
        <ArticleListContainer/>
      </div>
    );
  }
}

export default App;
```

Now let’s create the **ArticleFormContainer.** React, Angular, it does not matter, forms are complicated.

> Check out the [Ramda](http://ramdajs.com) library and how it’s methods enhance the declarative nature of our code.

The form takes user input and passes it to the **articleService**. The service creates an **Article** from that input and adds it to the **ArticleStore** for interested components to consume it. All this logic resides primarily in the **submitForm** method.

```
// @flow
import React, {Component} from 'react';
import * as R from 'ramda';

import type {ArticleService} from "../domain/ArticleService";
import type {ArticleStore} from "../store/ArticleStore";
import {articleService} from "../domain/ArticleService";
import {articleStore} from "../store/ArticleStore";
import {ArticleFormComponent} from "./ArticleFormComponent";

type Props = {};

type FormField = {
  value: string;
  valid: boolean;
}

export type FormData = {
  articleTitle: FormField;
  articleAuthor: FormField;
};

export class ArticleFormContainer extends Component<Props, FormData> {
  articleStore: ArticleStore;
  articleService: ArticleService;

  constructor(props: Props) {
    super(props);

    this.state = {
      articleTitle: {
        value: '',
        valid: true
      },
      articleAuthor: {
        value: '',
        valid: true
      }
    };

    this.articleStore = articleStore;
    this.articleService = articleService;
  }

  changeArticleTitle(event: Event) {
    this.setState(
      R.assocPath(
        ['articleTitle', 'value'],
        R.path(['target', 'value'], event)
      )
    );
  }

  changeArticleAuthor(event: Event) {
    this.setState(
      R.assocPath(
        ['articleAuthor', 'value'],
        R.path(['target', 'value'], event)
      )
    );
  }

  submitForm(event: Event) {
    const articleTitle = R.path(['target', 'articleTitle', 'value'], event);
    const articleAuthor = R.path(['target', 'articleAuthor', 'value'], event);

    const isTitleValid = this.articleService.isTitleValid(articleTitle);
    const isAuthorValid = this.articleService.isAuthorValid(articleAuthor);

    if (isTitleValid && isAuthorValid) {
      const newArticle = this.articleService.createArticle({
        title: articleTitle,
        author: articleAuthor
      });
      if (newArticle) {
        this.articleStore.addArticle(newArticle);
      }
      this.clearForm();
    } else {
      this.markInvalid(isTitleValid, isAuthorValid);
    }
  };

  clearForm() {
    this.setState((state) => {
      return R.pipe(
        R.assocPath(['articleTitle', 'valid'], true),
        R.assocPath(['articleTitle', 'value'], ''),
        R.assocPath(['articleAuthor', 'valid'], true),
        R.assocPath(['articleAuthor', 'value'], '')
      )(state);
    });
  }

  markInvalid(isTitleValid: boolean, isAuthorValid: boolean) {
    this.setState((state) => {
      return R.pipe(
        R.assocPath(['articleTitle', 'valid'], isTitleValid),
        R.assocPath(['articleAuthor', 'valid'], isAuthorValid)
      )(state);
    });
  }

  render() {
    return (
      <ArticleFormComponent
        formData={this.state}
        submitForm={this.submitForm.bind(this)}
        changeArticleTitle={(event) => this.changeArticleTitle(event)}
        changeArticleAuthor={(event) => this.changeArticleAuthor(event)}
      />
    )
  }
}
```

ArticleFormContainer.js

Notice that the **ArticleFormContainer** returns the actual form which the user sees, the presentational **ArticleFormComponent**. This component displays the data passed by the container and emits events like **changeArticleTitle**, **changeArticleAuthor**, and **submitForm**.

```
// @flow
import React from 'react';

import type {FormData} from './ArticleFormContainer';

type Props = {
  formData: FormData;
  changeArticleTitle: Function;
  changeArticleAuthor: Function;
  submitForm: Function;
}

export const ArticleFormComponent = (props: Props) => {
  const {
    formData,
    changeArticleTitle,
    changeArticleAuthor,
    submitForm
  } = props;

  const onSubmit = (submitHandler) => (event) => {
    event.preventDefault();
    submitHandler(event);
  };

  return (
    <form
      noValidate
      onSubmit={onSubmit(submitForm)}
    >
      <div>
        <label htmlFor="article-title">Title</label>
        <input
          type="text"
          id="article-title"
          name="articleTitle"
          autoComplete="off"
          value={formData.articleTitle.value}
          onChange={changeArticleTitle}
        />
        {!formData.articleTitle.valid && (<p>Please fill in the title</p>)}
      </div>
      <div>
        <label htmlFor="article-author">Author</label>
        <input
          type="text"
          id="article-author"
          name="articleAuthor"
          autoComplete="off"
          value={formData.articleAuthor.value}
          onChange={changeArticleAuthor}
        />
        {!formData.articleAuthor.valid && (<p>Please fill in the author</p>)}
      </div>
      <button
        type="submit"
        value="Submit"
      >
        Create article
      </button>
    </form>
  )
};
```

[ArticleFormComponent.js](https://gist.github.com/intojs/4a41a3817de53c9c8767d11d96d61d79)

Now that we have a form to create articles, it’s time to list them. **ArticleListContainer** subscribes to the **ArticleStore**, gets all the articles and displays the **ArticleListComponent**.

```
// @flow
import * as React from 'react'

import type {Article} from "../domain/Article";
import type {ArticleStore} from "../store/ArticleStore";
import {articleStore} from "../store/ArticleStore";
import {ArticleListComponent} from "./ArticleListComponent";

type State = {
  articles: Article[]
}

type Props = {};

export class ArticleListContainer extends React.Component<Props, State> {
  subscriber: Function;
  articleStore: ArticleStore;

  constructor(props: Props) {
    super(props);
    this.articleStore = articleStore;
    this.state = {
      articles: []
    };
    this.subscriber = this.articleStore.subscribe((articles: Article[]) => {
      this.setState({articles});
    });
  }

  componentWillUnmount() {
    this.articleStore.unsubscribe(this.subscriber);
  }

  render() {
    return <ArticleListComponent {...this.state}/>;
  }
}
```

ArticleListContainer.js

The **ArticleListComponent** is a presentational component. It receives the articles through props and renders **ArticleContainer** components.

```
// @flow
import React from 'react';

import type {Article} from "../domain/Article";
import {ArticleContainer} from "./ArticleContainer";

type Props = {
  articles: Article[]
}

export const ArticleListComponent = (props: Props) => {
  const {articles} = props;
  return (
    <div>
      {
        articles.map((article: Article, index) => (
          <ArticleContainer
            article={article}
            key={index}
          />
        ))
      }
    </div>
  )
};
```

ArticleListComponent.js

The **ArticleContainer** passes the article data to the presentational **ArticleComponent**. It also implements the **likeArticle** and **removeArticle** methods.

The **likeArticle** method updates the number of likes, by replacing the existing article inside the store with an updated copy.

The **removeArticle** method deletes the article from the store.

```
// @flow
import React, {Component} from 'react';

import type {Article} from "../domain/Article";
import type {ArticleService} from "../domain/ArticleService";
import type {ArticleStore} from "../store/ArticleStore";
import {articleService} from "../domain/ArticleService";
import {articleStore} from "../store/ArticleStore";
import {ArticleComponent} from "./ArticleComponent";

type Props = {
  article: Article;
};

export class ArticleContainer extends Component<Props> {
  articleStore: ArticleStore;
  articleService: ArticleService;

  constructor(props: Props) {
    super(props);

    this.articleStore = articleStore;
    this.articleService = articleService;
  }

  likeArticle(article: Article) {
    const updatedArticle = this.articleService.updateLikes(article, article.likes + 1);
    this.articleStore.updateArticle(updatedArticle);
  }

  removeArticle(article: Article) {
    this.articleStore.removeArticle(article);
  }

  render() {
    return (
      <div>
        <ArticleComponent
          article={this.props.article}
          likeArticle={(article: Article) => this.likeArticle(article)}
          deleteArticle={(article: Article) => this.removeArticle(article)}
        />
      </div>
    )
  }
}
```

ArticleContainer.js

The **ArticleContainer** passes the article data to the **ArticleComponent** which displays it. It also informs the container component when the like or delete buttons are clicked, by executing the appropriate callbacks.

> Remember the crazy request that the author name should be uppercase?

The **ArticleComponent** uses the **ArticleUiService** from the application layer to project a piece of state from its original value (string with no rule for uppercase) to the desired one, uppercase string.

```
// @flow
import React from 'react';

import type {Article} from "../domain/Article";
import * as articleUiService from "../services/ArticleUiService";

type Props = {
  article: Article;
  likeArticle: Function;
  deleteArticle: Function;
}

export const ArticleComponent = (props: Props) => {
  const {
    article,
    likeArticle,
    deleteArticle
  } = props;

  return (
    <div>
      <h3>{article.title}</h3>
      <p>{articleUiService.displayAuthor(article.author)}</p>
      <p>{article.likes}</p>
      <button
        type="button"
        onClick={() => likeArticle(article)}
      >
        Like
      </button>
      <button
        type="button"
        onClick={() => deleteArticle(article)}
      >
        Delete
      </button>
    </div>
  );
};
```

ArticleComponent.js

### Good work!

We now have a fully functional React app and a robust, clear defined architecture. Anyone who joins our team can read this article and feel comfortable to continue our work. :)

You can check out the finished app [here](https://intojs.github.io/architecting-single-page-applications/) and the GitHub repository [here](https://github.com/intojs/architecting-single-page-applications).

If you liked this guide, please clap for it. If you want to help me improve it, I am interested in your comment. [@danielDughy](http://twitter.com/danielDughy "Twitter profile for @danielDughy")

[1] [https://en.wikipedia.org/wiki/Flip_book](https://en.wikipedia.org/wiki/Flip_book)
[2] [https://reactjs.org](https://reactjs.org/)
[3] [https://angular.io](https://angular.io/)
[4][https://reactjs.org/docs/optimizing-performance.html](https://reactjs.org/docs/optimizing-performance.html)
[5] [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
