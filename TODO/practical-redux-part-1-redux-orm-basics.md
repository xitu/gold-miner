> * 原文地址：[Practical Redux, Part 1: Redux-ORM Basics](http://blog.isquaredsoftware.com/2016/10/practical-redux-part-1-redux-orm-basics/)
* 原文作者：[Mark Erikson](https://twitter.com/acemarke)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[luoyaqifei](http://www.zengmingxia.com)
* 校对者：[richardo2016](https://github.com/richardo2016)，[malcolmyu](https://github.com/malcolmyu)

# 实践 Redux，第 1 部分： Redux-ORM 基础




**使用 Redux-ORM 来帮助你管理范式化 state 的有用技术，第 1 部分：
Redux-ORM 使用场景以及基础的使用**

#### 系列目录
*   **[第 0 部分：系列简介](https://github.com/xitu/gold-miner/blob/master/TODO/practical-redux-part-0-introduction.md)**
*   **第 1 部分：Redux-ORM 基础**
*   **[第 2 部分：Redux-ORM 概念和技术](https://github.com/xitu/gold-miner/blob/master/TODO/practical-redux-part-2-redux-orm-concepts-and-techniques.md)**

## 简介

在过去的一年里，我成为了一个名叫 **[Redux-ORM](https://github.com/tommikaikkonen/redux-orm)** 库的大粉丝，这个库是 Tommi Kaikkonen 写的。它帮助我解决了一些对很多 Redux 应用来说常见的使用场景，尤其是关于管理你的 store 中的范式化、关系型数据。我在自己的应用中用了很多，并且总结出一些实践中很有用的技术和方法。希望你能觉得这些能给你的应用提供帮助。

这第一篇文章将谈论**为什么你可能想要使用Redux-ORM和使用基础**。在第二部分，我们将谈论**当你使用 Redux-ORM 时你应该知道的特定概念，我是怎么将它们用在我自己的应用中的**。

> 注意：本文中的示例代码是为了展示常规概念和工作流使用的，大概不会在实际中应用。稍后**请参考 [系列介绍](http://blog.isquaredsoftware.com/2016/10/practical-redux-part-0-introduction/)** 获得关于在工作示例应用中展示这些想法的示例场景和计划的更多信息...

## 为什么要用 Redux-ORM？

客户端应用经常需要处理原本嵌套或相关的数据。对于 Redux 应用来说，标准的建议是 [将数据用「范式化」的形式存储](http://redux.js.org/docs/faq/OrganizingState.html#organizing-state-nested-data)。对 Redux 应用而言，这意味着将你的 store 部分组织得像一组数据库表。每种你想存储的数据项类型都会获取到一个对象用作索引表，将数据项的 ID 映射到数据记录。因为这些对象没有顺序的概念，所以另需一个数据项的数组来指明顺序。

> **注意**：如果需要更多的 Redux 范式化信息，请看 Redux 文档的 [Structuring Reducers](http://redux.js.org/docs/recipes/StructuringReducers.html) 部分。

因为数据总是从服务器端以嵌套的形式拿到，它需要被转换成范式化的形式，以便于被加入 store 中。对于这个问题，典型的做法是使用 [Normalizr](https://github.com/paularmstrong/normalizr) 库。你可以定义模版对象和它们之间的联系，将根模式 （schema） 和一些嵌套数据传入 Normalizr，它将返回你一个范式化版本的数据，以便你将它融入你的 state 中。

然而， Normalizr 其实只用来对输入数据进行一次性处理，当范式化数据在你的 store 中时，它就无能为力了。比方说，它并没有将数据去范式化、根据 ID 来查找相关条目或是帮助应用数据更新这些功能。有一些其它的库可以帮忙，比如 [Denormalizr](https://github.com/gpbl/denormalizr)，但是肯定还是需要一些能让这些步骤更加容易操作的工具。

幸运的是，有这样的工具存在：**Redux-ORM**。让我们看看它是怎么使用的，以及它怎么能让管理 store 中的范式化数据更简单的吧。

## 使用基础

Redux-ORM 有出色的文档：主要的 [Redux-ORM README](https://github.com/tommikaikkonen/redux-orm)，[Redux-ORM 入门教程](https://github.com/tommikaikkonen/redux-orm-primer)，[API 文档](http://tommikaikkonen.github.io/redux-orm/index.html) 将基础覆盖得很全面，但是这里还是做一个简单的概述。

### 定义模型类 （Model Classes）

首先，你需要确定你的不同数据类型，以及它们是怎样互相关联的（用数据库的术语）。然后，声明 ES6 的类，这些类继承 （extend） 自 Redux-ORM 的 「Model」 类。类似于其它 Redux 应用里的文件类型，对于这些声明的生存地点没有特定的需求，但是你可能想要把它们放入你项目中的某个 `models.js` 文件里，或者是某个 `/models` 文件夹里。

作为声明的一部分，在类里添加一个静态的 `field` 属性，该属性使用 Redux-ORM 的关系操作符来定义这个类拥有的关系：

    import {Model, fk, oneToOne, many} from "redux-orm";

    export class Pilot extends Model{}
    Pilot.modelName = "Pilot";
    Pilot.fields = {
      mech : fk("Battlemech"),
      lance : oneToOne("Lance")
    };

    export class Battlemech extends Model{}
    Battlemech.modelName = "Battlemech";
    Battlemech.fields = {
        pilot : fk("Pilot"),
        lance : oneToOne("Lance"),
    };

    export class Lance extends Model{}
    Lance.modelName = "Lance";
    Lance.fields = {
        mechs : many("Battlemech"),
        pilots : many("Pilot")
    }

这些定义并不需要声明每个类拥有的特定属性——只需要声明它们与其它类的关系。

### 创建 Schema Instance（模式实例）

当你定义完你的模型后，你需要创建一个 Redux-ORM 模式类的实例，并将模型类传入它的 `register` 方法。这个模式实例在你的应用里是单例的：

    import {Schema} from "redux-orm";
    import {Pilot, Battlemech, Lance} from "./models";

    const schema = new Schema();
    schema.register(Pilot, Battlemech, Lance);
    export default schema;

### 设置 Store 和 Reducers

然后，你需要决定怎么把 Redux-ORM 整合进你的 reducer 结构里。文档推荐你将 reducer 函数定义在你的模型类里，然后调用 `schema.reducer()` 并使用 `combineReducers`（大概以 `orm` 为键名）将返回的函数加到你的根 reducer 里。这种做法看起来很像这样：

    // Pilot.js
    class Pilot extends Model {
        static reducer(state, action, Pilot, session) {
            case "PILOT_CREATE": {
                Pilot.create(action.payload.pilotDetails);
                break;
            }
        }
    }

    // rootReducer.js
    import {combineReducers} from "redux";
    import schema from "models/schema";

    const rootReducer = combineReducers({
        orm : schema.reducer()
    });
    export default rootReducer;

**我个人有一些不同的做法**。我的 reducer 的主要逻辑更加通用，不是针对特定类的，所以我选择为这段数据写我自己的片段 reducer，只把 Redux-ORM 当作辅助工具。基本的做法看起来如下：

    // entitiesReducer.js
    import schema from "models/schema";

    // 给我们一些拥有正确结构的数据「表」
    const initialState = schema.getDefaultState();

    export default function entitiesReducer(state = initialState, action) {
        switch(action.type) {
            case "PILOT_CREATE": {
                const session = schema.from(state);
                const {Pilot} = session;

                // 在 Redux-ORM 内部的 action 队列中加入 `creation` action
                const pilot = Pilot.create(action.payload.pilotDetails);

                // 应用队列中的 actions
                // 并返回更新后的「表」结构，其所有的更新都不可变式处理了
                return session.reduce();            
            }    
            // 其它实际 action 分支都在这里
            default : return state;
        }
    }

    // rootReducer.js
    import {combineReducers} from "redux";
    import entitiesReducer from "./entitiesReducer";

    const rootReducer = combineReducers({
        entities: entitiesReducer
    });

    export default rootReducer;

### 选择数据

最后，模式 （schema） 可以被用作从选择器和 `mapState` 函数中查找数据和关系：

    import React, {Component} from "react";
    import schema from "./schema";
    import {selectEntities} from "./selectors";

    export function mapState(state, ownProps) {
        // 基于我们的 entities 片段「表」，创建一个 Redux-ORM 的 Session 实例
        const entities = selectEntities(state);
        const session = schema.from(entities);
        const {Pilot} = session;

        const pilotModel = Pilot.withId(ownProps.pilotId);

        // 取出对 store 中实际底层数据的引用
        const pilot = pilotModel.ref;    

        // 解除一段关联的引用，获得其实际对象
        const battlemech = pilotModel.mech.ref;

        // 解除另一关联的引用，从该模型中读取字段
        const lanceName = pilotModel.lance.name;

        return {pilot, battlemech, lanceName};
    }

    export class PilotAndMechDetails extends Component { ....... }

    export default connect(mapState)(PilotAndMechDetails);

## Redux-ORM 和惯用的 Redux

人们创建过许多插件库，试图在 Redux 上放一个类似于面向对象编程 （OOP） 层，正如我的 [Redux 插件目录](https://github.com/markerikson/redux-ecosystem-links) 里 [“Variations” page](https://github.com/markerikson/redux-ecosystem-links/blob/master/variations.md) 展示的那样。我曾多次指出 [Redux 是专注于函数式编程原则的](https://www.reddit.com/r/reactjs/comments/518qdr/anyone_have_experience_with_jumpsuit/d7arb9g/?context=3)，以及 [在 Redux 之上的 OOP 封装并不常用](https://news.ycombinator.com/item?id=11833301)。所以，出于这些理由，我经常反对大家使用这种类型的库。你可能会问我为什么我推荐使用 Redux-ORM，它跟 Jumpsuit 或是 Radical 这些库有什么区别呢？

大部分我见到的 OOP 封装都通过定义 action creator 作为类的方法，试图将东西抽象出来，并且经常结束于忽视多个 reducers 可以响应一个特定的 action（甚至将它变成不可能的）。**它们将 Redux 当作一个需要被隐藏起来的东西**，并扔掉了很多 Redux 里很吸引人的概念。

另一方面，**Redux-ORM 并不试着隐藏 Redux**。它不假装 action 常量不存在，或者 action 和 reducer 总是 1 : 1 的对应关系。它最终只是在你可能更想要自己写的一些地方提供了一个抽象层：对规范化数据的 CRUD 操作。它使我能够在概念层面少考虑一些「我需要遵从哪些特定的步骤来适当地更新或者取得数据？」，多考虑一些如何操作我的数据这类的问题。

## 最终思考

Redux-ORM 已经变成了我在写 Redux 应用时的利器。我工作相关的数据都是高度嵌套和关系型的，Redux-ORM 完美适合我的使用情况。尽管它还没有被标为版本 1.0，但自从它出现以来，API 一直都很一致且稳定，并且 Tommi Kaikkonen 对于我提的 issue 都有很好的回应。这个库目前的文档十分有意义（包括教程和 API 文档），这也是一个大大的加分项。

总之， **我强烈建议你在任何需要处理范式化嵌套/相关数据的 Redux 应用里使用 Redux-ORM**。它不会神奇地将你从不得不思考如何管理数据的苦恼中解救出来，但是它**会**让你更容易处理这些。
