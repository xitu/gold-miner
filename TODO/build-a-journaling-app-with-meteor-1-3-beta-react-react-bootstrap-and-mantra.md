>* 原文链接 : [Build A Journaling App with Meteor 1.3 (Beta), React, React-Bootstrap, and Mantra](https://medium.com/@kenrogers/build-a-journaling-app-with-meteor-1-3-beta-react-react-bootstrap-and-mantra-7965d9e9fc23#.bjcr4yhbf)
* 原文作者 : [Ken Rogers](https://medium.com/@kenrogers)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [yangzj1992](http://qcyoung.com)
* 校对者: [Zhongyi Tong](https://github.com/geeeeeeeeek), [刘鑫](https://github.com/lx7575000)


由于目前 Meteor 1.3 正式版仍在开发中，在这份 Meteor 指南里我们采用了目前可以获取到的 Meteor 1.3 beta 版本进行开发。尽管 Meteor 1.3 版本很棒并有着许多精彩的改进，但部分人对于到底应该如何使用它来进行开发仍有一些困惑。 MDG(Meteor Development Group) 目前正在编写 Meteor 1.3 版指南，随着 1.3 正式版的发布，我们将会获得 Meteor 1.3 最佳开发实践的确切信息。

**旁注：我写了一本关于使用 Meteor 1.3 ，React ，React-Bootstrap 遵循 Mantra 框架规范进行应用开发的书，点击[这里](http://kenrogers.co/meteor-react)可以了解更多并免费获取前三章的内容**。

我写这份指南的目的是让开发者现在就能用上 Meteor 1.3 。当你阅读本指南时，需要留意 1.3 版本目前仍处于 beta 阶段，因此内容可能发生任何变化。我会尽我所能的更新这份指南来适应最新版本。如果你发现了什么过期的内容，希望能指出来让我知道。

在这份指南中，我们将要构建一个简单的任务清单，开个玩笑，不会再是任务清单了。我们将用 Meteor 1.3 ，React 和 React-Bootstrap 构建一个基本的日志应用。

我们将采用 Arunoda 的 Mantra 规范。如果你对 Mantra 不够熟悉，你可以访问[这里](https://github.com/kadirahq/mantra)了解更多。 基本来说， Mantra 应用程序架构规范向我们提供了一个宜于维护的方式去构建 Meteor 应用。

在我们开始前，你需要安装好 Meteor 并需要对 Meteor 的原理及使用方法具备一定的理解。如果你并不熟悉，可以看看[官方 Meteor 向导](https://www.meteor.com/tutorials/react/creating-an-app)。

首先我们将通过一些资源来熟悉 Meteor 1.3 和 Mantra ，然后运用它们创建一个简单的日志应用。

#### 了解 Meteor 1.3

首先我们要介绍 Meteor 1.3 并且了解它的主要改动包含什么。在 1.3 版本中它最大的改动是完全支持 ES2015 并提供了模块功能。

一开始你会发现这和我们以往开发 Meteor 应用很不一样，但一旦你习惯了你会发现体验是相当不错的，尤其是你要使用 Mantra 的架构的话。

这里有一篇关于 Meteor 1.3 的模块机制是怎样工作的精彩介绍：[https://github.com/meteor/meteor/blob/release-1.3/packages/modules/README.md](https://github.com/meteor/meteor/blob/release-1.3/packages/modules/README.md)

使用模块可以让我们更容易的去写更多的代码，更加模块化。这样我们可以更好地组织我们的应用，由于 Meteor 1.3 也添加了对 npm 包的支持，我们不必再像过去那样只有 Meteor 包支持的情况下进行开发了。

接下来，你可以看看这三篇文章来了解如何在 Meteor 1.3 中配置 React ，并用它来处理数据。第二篇会向你介绍容器组件，这是使用 Mantra 开发的一个重要部分。

1.  [https://voice.kadira.io/getting-started-with-meteor-1-3-and-react-15e071e41cd1#.qn4zj3420](https://voice.kadira.io/getting-started-with-meteor-1-3-and-react-15e071e41cd1#.qn4zj3420)
2.  [https://voice.kadira.io/let-s-compose-some-react-containers-3b91b6d9b7c8#.pd37xdmpn](https://voice.kadira.io/let-s-compose-some-react-containers-3b91b6d9b7c8#.pd37xdmpn)
3.  [https://voice.kadira.io/using-meteor-data-and-react-with-meteor-1-3-13cb0935dedb#.3oe66g4ye](https://voice.kadira.io/using-meteor-data-and-react-with-meteor-1-3-13cb0935dedb#.3oe66g4ye)

#### 第一步 — 项目设置

通常来说，我们需要做的第一件事就是通过 Meteor 1.3 来创建我们的 Meteor 项目，像下面这样。

    meteor create journal --release 1.3-modules-beta.8

**但是稍等一下**，构建一个 Mantra 应用需要非常多的项目设置
，为了加快开发速度，我已经使用 Meteor 1.3，React，Mantra 创建创建了一个样板项目。我们就用它来代替初始方案直接开始。

如果你想知道这些具体做了什么，查看 [Mantra 规范](https://kadirahq.github.io/mantra/)和 [Mantra 博客应用实例](https://github.com/mantrajs/mantra-sample-blog-app)。

现在我们安装完样板项目，它完全包含了遵循 Mantra 规范的 Meteor 项目中所有你需要的核心文件和目录。

你可以通过以下命令 clone 项目：

    git clone git@github.com:kenrogers/mantraplate.git

然后切换到刚创建的目录中运行

    npm install

这样会安装本应用依赖的所有的包。你可以查看示例项目来熟悉整个目录结构。

它包含完整的布局，路由系统以及具有注册，登录登出功能的用户系统。

在这份指南中，我们将要讨论这些内容是如何组合在一起的，以及如何使用户在应用中添加日志记录的功能。

在我们添加内容前我们来看看样例项目的目录结构，你可以发现，在客户端文件夹中我们将整个应用分成一个个模块，这些模块是你的应用的主要组成部分。

我们总是需要一个核心模块，如果你的 APP 比较简单，这个核心模块就是你所唯一需要的。在我们的 APP 中包含了核心模块和用户模块，这里还要加入一个条目模块来添加我们的日志记录。

这样的模块结构让我们可以轻松地组织我们的代码。

在用户模块中，看看 containers 和 components 文件夹中的 NewUser 文件，。container 文件夹如下所示。

    import NewUser from ‘../components/NewUser.jsx’;
    import {useDeps, composeWithTracker, composeAll} from ‘mantra-core’;
    export const composer = ({context, clearErrors}, onData) => {
     const {LocalState} = context();
     const error = LocalState.get(‘CREATE_USER_ERROR’);
     onData(null, {error});
     return clearErrors;
    };
    export const depsMapper = (context, actions) => ({
     create: actions.users.create,
     clearErrors: actions.users.clearErrors,
     context: () => context
    });
    export default composeAll(
     composeWithTracker(composer),
     useDeps(depsMapper)
    )(NewUser);

你可以看到我们在这里实际上并没有进行任何渲染，我们只是做一些设置和清理的工作，然后在 NewUser 组件中我们才实际上渲染了视图。

如果你运行应用并访问 /register 路由，打开 React 开发者工具，你可以看到 react-komposer 正在后台执行。它会创建一个容器组件负责处理底层子组件的数据或是 UI 组件。

当我们获取数据时容器组件的用途将会得到具体的展现，但是这里我们不这样处理。

#### 第二步 — 原型制作

对于这个日志程序我们准备使用 React-Bootstrap 。它可以很方便地使用 Bootstrap 来创建 React 应用。这种方式易于上手，并且保持了模块化，正如我们所愿。

让我们设置好并添加一个简单的表单。

首先让我们为项目添加 `react-bootstrap`

    npm install react-bootstrap

因为 React-Bootstrap 并不依赖任何特定的 Bootstrap 库，所以我们需要自行添加，现在让我们添加 Twitter 的官方 Meteor 包。

    meteor add twbs:bootstrap

首先我们用 React-Bootstrap 来修改 MainLayout.jsx 文件的内容如下：

    import React from ‘react’;
    import {Grid, Row} from ‘react-bootstrap’;
    const Layout = ({content = () => null }) => (
     <grid>
      <row>
       <h1>Journal</h1>
       {content()}
      </row>
     </grid>
    );
    export default Layout;

在这里，我们从 react-boostrap 包中引入 Grid 和 Row 组件，并且像使用 div 一样为它们添加合适的 bootstrap 类。想要了解更多关于这个优秀的包的工作原理，可以在[这里](https://react-bootstrap.github.io/components.html)查看组件列表。

现在让我们修改 NewUser 和 Login UI 的组件让他们更友好地贴近 Bootstrap 。打开 NewUser.jsx 文件进行如下修改：

    import React from ‘react’;
    import { Col, Panel, Input, ButtonInput, Glyphicon } from ‘react-bootstrap’;
    class NewUser extends React.Component {
     render() {
     const {error} = this.props;
     return (
       <col xs="{12}" sm="{6}" smoffset="{3}">
        <panel>
         <h1>Register</h1>
         {error ? <p style="{{color:" ‘red’}}="">{error}</p> : null}
         <form>
          <input ref="”email”" type="”email”" placeholder="”Email”">
          <input ref="”password”" type="”password”" placeholder="”Password”">
          <buttoninput onclick="{this.createUser.bind(this)}" bsstyle="”primary”" type="”submit”" value="”Sign" up”="">
         </buttoninput></form>
        </panel>

      )
     }
    createUser(e) {
     e.preventDefault();
     const {create} = this.props;
     const {email, password} = this.refs;
     create(email.getValue(), password.getValue());
     email.getInputDOMNode().value = ‘’;
     password.getInputDOMNode().value = ‘’;
     }
    }
    export default NewUser;

这个表单十分简单，它仅仅负责显示自身并调用 create 方法。这里我们简单介绍一下。

在我们的 actions 文件夹中，它们负责处理我们应用的逻辑，下面这一行

    create(email.getValue(), password.getValue());

将调用该方法并创建实际用户。 Mantra 重点强调了希望把一切分离成单独的文件。因此，我们将文件分为展示、逻辑、以及这个应用程序的每个组件。

现在让我们修改登录表单如下：

    import React from ‘react’;
    import { Col, Panel, Input, ButtonInput, Glyphicon } from ‘react-bootstrap’;
    class Login extends React.Component {
     render() {
      const {error} = this.props;
      return (
       <col xs="{12}" sm="{6}" smoffset="{3}">
        <panel>
         <h1>Login</h1>
         {error ? <p style="{{color:" ‘red’}}="">{error}</p> : null}
         <form>
          <input ref="”email”" type="”email”" placeholder="”Email”">
          <input ref="”password”" type="”password”" placeholder="”Password”">
          <buttoninput onclick="{this.login.bind(this)}" bsstyle="”primary”" type="”submit”" value="”Login”/">
         </buttoninput></form>
        </panel>

      )
     }
    login(e) {
     e.preventDefault();
     const {loginUser} = this.props;
     const {email, password} = this.refs;
     loginUser(email.getValue(), password.getValue());
     email.getInputDOMNode().value = ‘’;
     password.getInputDOMNode().value = ‘’;
     }
    }
    export default Login;

这基本上是一个相同的表单，但我们将用登录方法来代替它的逻辑。

React-Boostrap 非常易于使用，我们只需要安装好项目，使用 import 函数引入每个我们想要引用的组件，就像其他类型一样渲染这些组件。

我们处理使用数据的方法则有一些不同，因为它是组件，而不是我们实际需要处理的输入内容，我们需要使用特殊的 React-Bootstrap 函数 getValue() 来帮我们轻松地取值。

#### 第二步 — 添加条目模块

现在，我们将添加新的模块来管理我们的日志条目，首先让我们设置目录和文件。

    mkdir client/modules/entries
    cd client/modules/entries
    mkdir actions components containers
    touch index.js
    touch actions/index.js actions/entries.js
    touch components/NewEntry.jsx components/Entry.jsx components/EntryList.jsx
    touch containers/NewEntry.js containers/Entry.js containers/EntryList.js

好了，现在我们有了应用中所需要的所有文件和文件夹。让我们来做一些真正的开发工作吧。

首先，让我们再来看一下我们创建的应用结构。这里我们制造了一个简单的 Mantra 模块。我们通过这些目录文件来看看他们是怎么做到交互的。通过这些将会让你很好地理解如何使用 Meteor 1.3 和 Mantra 。

**索引**

Mantra 有一个庞大的单一入口。这个索引文件负责导入内容随后导出路由和动作，这样在我们导入模块时即可使用。通过这种方式我们不用担心再单独导入每个文件。

    import actions from ‘./actions’;
    import routes from ‘../core/routes.jsx’;
    export default {
     routes,
     actions
    };

**动作**

动作文件夹负责我们应用的所有逻辑。你可以看到我们在这里创建了两个文件。首先是一个索引文件。这是一个类似目的模块的索引文件。我们向里面添加下面的内容。

    import entries from ‘./entries’;
    export default {
     entries
    };

上面所做的就是导入条目文件，在条目文件中有我们的动作逻辑。这只是为了更容易地从其他文件导入我们的逻辑。

接下来我们要添加实际逻辑，这些包含了我们的应用逻辑。这里我们要添加一个创建条目的函数方法。

你可以通过查看例子中 users 模块的方法文件来了解这是怎么工作的。

在 actions.js 中添加下面的内容来补全条目模块。

    export default {
     create({Meteor, LocalState, FlowRouter}, text) {
      if (!text) {
       return LocalState.set(‘CREATE_ENTRY_ERROR’, ‘Text is required.’);
      }
      LocalState.set(‘CREATE_ENTRY_ERROR’, null);
      Meteor.call(‘entries.create’, text, (err) => {
       if (err) {
        return LocalState.set(‘CREATE_ENTRY_ERROR’, err.message);
       }
      });
     }
    };

当我们填写表格来创建一个新条目时，这就是会被执行的方法，我们就快设置好这些组件了，让我们先别管服务端的东西，为我们的条目创建集合和方法。

在 lib 目录中打开 collections.js 文件然后添加条目集合。

    export const Entries = new Mongo.Collection(‘entries’);

现在在 server 目录下的 methods 目录中添加 entries.js 文件，并添加以下内容来创建一个创建新条目的方法。

    import {Entries} from ‘/lib/collections’;
    import {Meteor} from ‘meteor/meteor’;
    import {check} from ‘meteor/check’;
    export default function () {
     Meteor.methods({
      ‘entries.create’(text) {
       check(text, String);
       const createdAt = new Date();
       const entry = {text, createdAt};
       Entries.insert(entry);
      }
     });
    }

这是一个我们刚创建的将要被调用的方法。

我们还需要将下面代码添加到 methods 文件夹中的 index.js 文件。

    import entries from ‘./entries’;
    export default function () {
     entries();
    }

**组件**

组件目录存放着我们的 UI 组件。这里的组件只负责显示我们的接口内容，他们不操作任何数据，这些是容器组件需要做的。

让我们创建 UI 组件，然后我们将建立相应的容器组件。

    import React from ‘react’;
    import {Grid, Row, Col} from 'react-bootstrap';
    const Entry = ({entry}) => (
     <grid>
      <row>
       <col xs="{6}" xsoffset="{3}">
        <p>
         {entry.text}
        </p> 

      </row>
     </grid>
    );
    export default Entry;

这里获取到的 {entry} 对象是我们容器组件要传递给它属性。它包含了我们的数据。

接下来我们创建 NewEntry 组件。

    import React from ‘react’;
    import { Col, Panel, Input, ButtonInput, Glyphicon } from ‘react-bootstrap’;
    class NewEntry extends React.Component {
     render() {
      const {error} = this.props;
      return (
       <col xs="{12}" sm="{6}" smoffset="{3}">
        <panel>
         <h1>Add a New Entry</h1>
         {error ? <p style="{{color:" ‘red’}}="">{error}</p> : null}
         <form>
          <input ref="”text”" type="”textarea”" placeholder="”Add" your="" entry”="">
          <buttoninput onclick="{this.newEntry.bind(this)}" bsstyle="”primary”" type="”submit”" value="”Create”/">
         </buttoninput></form>
        </panel>

      )
     }
     newEntry(e) {
      e.preventDefault();
      const {create} = this.props;
      const {text} = this.refs;
      create(text.getValue());
      text.getInputDOMNode().value = ‘’;
     }
    }
    export default NewEntry;

这里我们使用了更多的 React-Bootstrap 组件，你会留意到为了获取输入的值，我们用了一个特别的 getValue() 方法。这是因为我们的渲染组件实际上并不是输入框，输入框是在这些组件的内部。所以我们需要使用这个函数来访问它。

最后，我们创建一个 EntryList 组件。

    import React from ‘react’;
    import {Grid, Row, Col, Panel} from ‘react-bootstrap’;
    const EntryList = ({entries}) => (
     <grid>
      <row>
       {entries.map(entry => (
        <col xs="{3}" key="{entry._id}">
         <panel>
          <p>{entry.title}</p>
          <a href="{`/entry/${entry._id}`}">View Entry</a>
         </panel>

       ))}
      </row>
     </grid>
    );
    export default EntryList;

接下来，我们通过属性来获取数据，设置一些 React-Bootstrap 组件，并为每个入口映射一个对应专属的面板。

现在，让我们来设置这些容器组件，首先从最简单的 NewEntry 容器组件开始。

    import NewEntry from ‘../components/NewEntry.jsx’;
    import {useDeps, composeWithTracker, composeAll} from ‘mantra-core’;
    export const composer = ({context, clearErrors}, onData) => {
     const {LocalState} = context();
     const error = LocalState.get(‘CREATE_ENTRY_ERROR’);
     onData(null, {error});
     return clearErrors;
    };
    export const depsMapper = (context, actions) => ({
     create: actions.entries.create,
     clearErrors: actions.entries.clearErrors,
     context: () => context
    });
    export default composeAll(
     composeWithTracker(composer),
     useDeps(depsMapper)
    )(NewEntry);

这里你应该已经对 react-komposer 较为熟悉了，我们将用它来创建这一容器组件。它负责创建一个容器组件，用于处理错误、调用合适的动作。在大多数情况下，它还将获取数据并通过属性传给 UI 组件。

depsMapper 通过 react-komposer 中的 useDeps 函数检索动作及上下文内容并将它们传递给 UI 组件。

clearErrors 方法负责清除组件卸载时发生的所有错误。

让我们在创建条目方法时创建这一方法。

    clearErrors({LocalState}) {
     return LocalState.set(‘SAVING_ERROR’, null);
    }

现在我们将要创建 EntryList 组件的容器。这个稍许有些复杂，因为我们会实际上获取一些数据。

    import EntryList from ‘../components/EntryList.jsx’;
    import {useDeps, composeWithTracker, composeAll} from ‘mantra-core’;
    export const composer = ({context}, onData) => {
     const {Meteor, Collections} = context();
     if (Meteor.subscribe(‘entries.list’).ready()) {
      const entries = Collections.Entries.find().fetch();
      onData(null, {entries});
     }
    };
    export default composeAll(
     composeWithTracker(composer),
     useDeps()
    )(EntryList);

这也确实与其他容器组件较为相似，但一个重要的区别在于，我们会检查我们的入口集合条目结合，并将它们分配给一个变量。最终我们通过 onData 函数将这个变量传给 UI 组件。

让我们在 publications 目录下的 entries.js 文件中设置发布

    import {Entries} from ‘/lib/collections’;
    import {Meteor} from ‘meteor/meteor’;
    import {check} from ‘meteor/check’;
    export default function () {
     Meteor.publish(‘entries.list’, function () {
      const selector = {};
      const options = {
       fields: {_id: 1, text: 1},
       sort: {createdAt: -1}
      };
      return Entries.find(selector, options);
     });
    }

同时我们将要为此发布创建一个 index 文件。

    import entries from ‘./entries’;
    export default function () {
     entries();
    }

我们需要在 server 目录中打开 main.js 文件，取消注释行，导入 publications 和 methods ，所以文件就像这样：

    import publications from ‘./publications’;
    import methods from ‘./methods’;

    // publications();
    // methods();

最后我们将要为独立的 Entry 组件创建容器组件。

    import Entry from ‘../components/Entry.jsx’;
    import {useDeps, composeWithTracker, composeAll} from ‘mantra-core’;
    export const composer = ({context, entryId}, onData) => {
     const {Meteor, Collections} = context();
     if (Meteor.subscribe(‘entries.single’, entryId).ready()) {
      const entry = Collections.Entries.findOne(entryId);
      onData(null, {entry});
     } else {
      const entry = Collections.Entries.findOne(entryId);
      if (entry) {
       onData(null, {entry});
      } else {
       onData();
      }
     }
    };
    export default composeAll(
     composeWithTracker(composer),
     useDeps()
    )(Entry);

此容器使用了一个 entryId (将通过我们之后设立的一个路由进行传递)并且找到一个合适的入口，来通过属性传递它给UI组件。

让我们在之前设置的发布列表中快速设置发布来展示发布条目。

    Meteor.publish(‘entries.single’, function (entryId) {
     check(entryId, String);
     const selector = {_id: entryId};
     return Entries.find(selector);
    });

现在让我们设置我们的路由吧。

**路由** 

打开 routes 文件来添加一些新的路由，修改 routes 文件类似如下所示。

    import React from ‘react’;
    import {mount} from ‘react-mounter’;
    import Layout from ‘./components/MainLayout.jsx’;
    import Home from ‘./components/Home.jsx’;
    import NewUser from ‘../users/containers/NewUser.js’;
    import Login from ‘../users/containers/Login.js’;
    import EntryList from ‘../entries/containers/EntryList.js’;
    import Entry from ‘../entries/containers/Entry.js’;
    import NewEntry from ‘../entries/containers/NewEntry.js’;
    export default function (injectDeps, {FlowRouter}) {
     const MainLayoutCtx = injectDeps(Layout);
     FlowRouter.route(‘/’, {
      name: ‘items.list’,
      action() {
       mount(MainLayoutCtx, {
        content: () => (<entrylist>)
       });
      }
     });
     FlowRouter.route(‘/entry/:entryId’, {
      name: ‘entries.single’,
      action({entryId}) {
       mount(MainLayoutCtx, {
        content: () => (<entry entryid="{entryId}/">)
       });
      }
     });
    FlowRouter.route(‘/new-entry’, {
      name: ‘newEntry’,
      action() {
       mount(MainLayoutCtx, {
        content: () => (<newentry>)
       });
      }
     });

     FlowRouter.route(‘/register’, {
      name: ‘users.new’,
      action() {
       mount(MainLayoutCtx, {
        content: () => (<newuser>)
       });
      }
     });
    FlowRouter.route(‘/login’, {
      name: ‘users.login’,
      action() {
       mount(MainLayoutCtx, {
        content: () => (<login>)
       });
      }
     });
    FlowRouter.route(‘/logout’, {
      name: ‘users.logout’,
      action() {
       Meteor.logout();
       FlowRouter.go(‘/’);
      }
     }); 
    }</login></newuser></newentry></entry></entrylist>

在运行我们的应用之前我们还需要做最后一件事，打开 main.js 文件并导入我们的 entries 模块，修改内容如下。

    import {createApp} from ‘mantra-core’;
    import initContext from ‘./configs/context’;
    // modules
    import coreModule from ‘./modules/core’;
    import usersModule from ‘./modules/users’;
    import entriesModule from ‘./modules/entries’;
    // init context
    const context = initContext();
    // create app
    const app = createApp(context);
    app.loadModule(coreModule);
    app.loadModule(usersModule);
    app.loadModule(entriesModule);
    app.init();

现在我们设置了我们的所有路由并且应用已经准备好运行，让我们切换目录到根目录并运行

    meteor

你可以看到应用程序在 Mantra 提供的默认加载效果中启动，让我们添加一个条目，这样我们应该可以在屏幕上看到效果了。

访问 localhost:3000/new-entry ，填写并提交表单来添加一个条目。

然后访问根目录，你应该可以看到一个可以逐个查看链接的的条目列表。

希望这个简单的 Mantra 引导以及目前的 Meteor 1.3 beta 版本有助于让你更加了解如何运用它们来构建一个应用。

![](http://ww3.sinaimg.cn/large/a490147fjw1f391r94o1nj20go0lgq5b.jpg)
