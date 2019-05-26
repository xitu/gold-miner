> * 原文地址：[The 4 Layers of Single Page Applications You Need to Know](https://hackernoon.com/architecting-single-page-applications-b842ea633c2e)
> * 原文作者：[Daniel Dughila](https://hackernoon.com/@danieldughila?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/architecting-single-page-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO1/architecting-single-page-applications.md)
> * 译者：[zwwill 木羽](https://github.com/zwwill)
> * 校对者：[Starriers](https://github.com/Starriers)，[NoName4Me](https://github.com/NoName4Me)

# 关于 SPA，你需要掌握的 4 层

## 我们从头来构建一个 React 的应用程序，探究领域、存储、应用服务和视图这四层

![](https://cdn-images-1.medium.com/max/800/1*5aa2cNrij2fVO0rZTJCZHQ.png)

每个成功的项目都需要一个清晰的架构，这对于所有团队成员都是心照不宣的。

试想一下，作为团队的新人。技术负责人给你介绍了在项目进程中提出的新应用程序的架构。

![](https://cdn-images-1.medium.com/max/800/1*6wpX8u_mM8Z1xdZVMFj67w.png)

然后告诉你需求：

> 我们的应用程序将显示一系列文章。用户能够创建、删除和收藏文章。

然后他说，去做吧！

### Ok，没问题，我们来搭框架吧

我选择 FaceBook 开源的构建工具 [Create React App](https://github.com/facebook/create-react-app)，使用 [Flow](https://flow.org) 来进行类型检查。简单起见，先忽略样式。

作为先决条件，让我们讨论一下现代框架的声明性本质，以及涉及到的 state 概念。

### 现在的框架多为声明式的

React， Angular， Vue 都是声明式的，并鼓励我们使用函数式编程的思想。

你有见过手翻书吗？

> 一本手翻书或电影书，里面有一系列逐页变化的图片，当页面快速翻页的时候，就形成了动态的画面。 [1]

![](https://cdn-images-1.medium.com/max/800/1*YC8GwZboKkBFfJI8cRzUnQ.jpeg)

现在让我们来看一下 React 中的定义：

> 在应用程序中为每个状态设计简单的视图， React 会在数据发生变化时高效地更新和渲染正确的组件。 [2]

Angular 中的定义：

> 使用简单、声明式的模板快速构建特性。使用您自己的组件扩展模板语言。 [3]

大同小异？

框架帮助我们构建包含视图的应用程序。视图是状态的表象。那状态又是什么？

### 状态

状态表示应用程序中会更改的所有数据。

你访问一个URL，这是状态，发出一个 Ajax 请求来获取电影列表，这是也状态，将信息持久化到本地存储，同上，也是状态。

状态由一系列**不变对象**组成

[不可变结构](http://enterprisecraftsmanship.com/2016/05/12/immutable-architecture)有很多好处，其中一个就是在视图层。

下面是 React 指南对[性能优化](https://reactjs.org/docs/optimizing-performance.html)介绍的引言。

> 不变性使得跟踪更改变得更容易。更改总是会产生一个新对象，所以我们只需要检查对象的引用是否发生了更改。

### 领域层

域可以描述状态并保存业务逻辑。它是应用程序的核心，应该与视图层解耦。Angular， React 或者是 Vue，这些都不重要，重要的是不管选择什么框架，我们都能够使用自己的领。

![](https://cdn-images-1.medium.com/max/800/1*iNmdhMwXJ53tv0fyhhpmmw.png)

因为我们处理的是不可变的结构，所以我们的领域层将包含实体和域服务。

在 OOP 中存在争议，特别是在大规模应用程序中，在使用不可变数据时，贫血模型是完全可以接受的。

> 对我来说，弗拉基米尔·克里科夫（Vladimir Khorikov）的[这门课](https://www.pluralsight.com/courses/refactoring-anemic-domain-model)让我大开眼界。

要显示文章列表，我们首先要建模的是**Article**实体。

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

现在，让我们使用工厂函数模式创建 **articleService**。

> 查看 @mpjme 的这个[视频](https://www.youtube.com/watch?v=ImwrezYhw4w)，了解更多关于JS中的工厂函数知识。

由于在我们的应用程序中只需要一个**articleService**，我们将把它导出为一个单例。

**createArticle** 允许我们创建 **Article** 的[冻结对象](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze)。每一篇新文章都会有一个唯一的自动生成的id和零收藏，我们仅需要提供作者和标题。

> `**Object.freeze()**` 方法可冻结一个对象：即无法给它新增属性。 [5]

**createArticle** 方法返回的是一个 **Article** 的「Maybe」类型

> [Maybe](https://flow.org/en/docs/types/maybe) 类型强制你在操作 **Article** 对象前先检查它是否存在。

如果创建文章所需要的任一字段校验失败，那么 **createArticle** 方法将返回null。这里可能有人会说，最好抛出一个用户定义的异常。如果我们这么做，但上层不实现catch块，那么程序将在运行时终止。
**updateLikes** 方法会帮我们更新现存文章的收藏数，将返回一个拥有新计数的副本。

最后，**isTitleValid** 和 **isAuthorValid** 方法能帮助 **createArticle** 隔离非法数据。

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

验证对于保持数据一致性非常重要，特别是在领域级别。我们可以用纯函数来编写 **Validators** 服务。


```
// @flow
export const isObject = (toValidate: any) => !!(toValidate && typeof toValidate === 'object');

export const isString = (toValidate: any) => typeof toValidate === 'string';

export const isLengthGreaterThen = (length: number) => (toValidate: string) => toValidate.length > length;
```

请使用最小的工程来检验这些验证方法，仅用于演示。

> 事实上，在 JavaScript 中检验一个对象是否为对象并不容易。 :)

现在我们有了领域层的结构!

好在现在就可以使用我们的代码来，而无需考虑框架。

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

### 存储层

创建和更新文章所产生的数据代表了我们的应用程序的状态。

我们需要一个地方来储存这些数据，而 store 就是最佳人选

![](https://cdn-images-1.medium.com/max/800/1*h8IDykExd_PhCBhKYr9e0Q.png)

状态可以很容易地由一系列文章来建模。

```
// @flow
import type {Article} from "./Article";

export type ArticleState = Article[];
```

ArticleState.js

**ArticleStoreFactory** 实现了发布-订阅模式，并导出 **articleStore** 作为单例。

store 可保存文章并赋予他们添加、删除和更新的不可变操作。

> 记住，store 只对文章进行操作。只有 **articleService** 才能创建或更新它们。

感兴趣的人可以订阅和退订 **articleStore**。

**articleStore** 保存所有订阅者的列表，并将每个更改通知到他们。

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

我们的 store 实现对于演示的目的是有意义的，它让我们理解背后的概念。在实际运作中，我推荐使用状态管理系统，像 [Redux](https://redux.js.org/)， [ngrx](https://github.com/ngrx)， [MobX](https://github.com/mobxjs/mobx)， 或者是[可监控的数据管理系统](https://medium.com/bucharestjs/the-developers-guide-to-redux-like-state-management-in-angular-3799f1877bb)

好的，现在我们有了领域层和存储层的结构。

让我们为 store 创建两篇文章和两个订阅者，并观察订阅者如何获得更改通知。

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

### 应用服务层

这一层用于执行与状态流相关的各种操作，如Ajax从服务器或状态镜像中获取数据。

![](https://cdn-images-1.medium.com/max/800/1*ZVstPN2LBFjdPoRaFq4SEw.png)

出于某种原因，设计师要求所有作者的名字都是大写的。

我们知道这种要求是比较无厘头的，而且我们并不想因此污化了我们的模块。

于是我们创建了 **ArticleUiService** 来处理这些特性。这个服务将取用一个状态，就是作者的名字，将其构建到项目中，可返回大写的版本给调用者。

```
// @flow
export const displayAuthor = (author: string) => author.toUpperCase();
```

让我们看一个如何使用这个服务的演示！

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
// 将输出 JORDAN PETERSON

if (article) {
  console.log(article.author);
  // 将输出 Jordan Peterson
}
```

app-service-demo.js

### 视图层

现在我们有了一个可执行且不依赖于框架的应用程序，React 已经准备投入使用。

视图层由 `presentational components` 和 `container components` 组成。

`presentational components` 关注事物的外观，而 `container components` 则关注事物的工作方式。更多细节解释请关注 Dan Abramov 的[文章](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)。

![](https://cdn-images-1.medium.com/max/800/1*R-6nKbTqru_qsdg8O7PJJg.png)

让我们使用 **ArticleFormContainer** 和 **ArticleListContainer** 开始构建 **App** 组件。

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

接下来，我们来创建 **ArticleFormContainer**。React 或者 Angular 都不重要，表单有些复杂。

> 查看 [Ramda](http://ramdajs.com) 库以及如何增强我们代码的声明性质的方法。

表单接受用户输入并将其传递给 **articleService** 处理。此服务根据该输入创建一个 **Article**，并将其添加到 **ArticleStore** 中以供 interested 组件使用它。所有这些逻辑都存储在 **submitForm** 方法中。

『ArticleFormContainer.js』

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

这里注意 **ArticleFormContainer**，`presentational component`，返回用户看到的真实表单。该组件显示容器传递的数据，并抛出 **changeArticleTitle**、 **changeArticleAuthor** 和 **submitForm** 的方法。

『[ArticleFormComponent.js](https://gist.github.com/intojs/4a41a3817de53c9c8767d11d96d61d79)』

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

现在我们有了创建文章的表单，下面就陈列他们吧。**ArticleListContainer** 订阅了 **ArticleStore**，获取所有的文章并展示在 **ArticleListComponent** 中。

『ArticleListContainer.js』

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

**ArticleListComponent** 是一个 `presentational component`，他通过 `props` 接收文章，并展示组件 **ArticleContainer**。

『ArticleListComponent.js』

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

**ArticleContainer** 传递文章数据到表现层的 **ArticleComponent**，同时实现 **likeArticle** 和 **removeArticle** 这两个方法。

**likeArticle** 方法负责更新文章的收藏数，通过将现存的文章替换成更新后的副本。

**removeArticle** 方法负责从 `store` 中删除制定文章。

『ArticleContainer.js』

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

**ArticleContainer** 负责将文章的数据传递给负责展示的 **ArticleComponent**，同时负责当 「收藏」或「删除」按钮被点击时在响应的回调中通知 `container component`。

> 还记得那个作者名要大写的无厘头需求吗？

**ArticleComponent** 在应用程序层调用 **ArticleUiService**，将一个状态从其原始值（没有大写规律的字符串）转换成一个所需的大写字符串。

『ArticleComponent.js』

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

### 干得漂亮！

我们现在有一个功能完备的 React 应用程序和一个鲁棒的、定义清晰的架构。任何新晋成员都可以通过阅读这篇文章学会如何顺利的进展我们的工作。:)

你可以在[这里](https://intojs.github.io/architecting-single-page-applications/)查看我们最终实现的应用程序，同时奉上 [GitHub 仓库地址](https://github.com/intojs/architecting-single-page-applications)。

如果你喜欢这份指南，请为它点赞。

- [1] [https://en.wikipedia.org/wiki/Flip_book](https://en.wikipedia.org/wiki/Flip_book)
- [2] [https://reactjs.org](https://reactjs.org/)
- [3] [https://angular.io](https://angular.io/)
- [4] [https://reactjs.org/docs/optimizing-performance.html](https://reactjs.org/docs/optimizing-performance.html)
- [5] [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
