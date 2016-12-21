> * 原文地址：[Practical Redux, Part 2: Redux-ORM Concepts and Techniques](http://blog.isquaredsoftware.com/2016/10/practical-redux-part-2-redux-orm-concepts-and-techniques/)
* 原文作者：[Mark Erikson](https://twitter.com/acemarke)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[luoyaqifei](http://www.zengmingxia.com)
* 校对者：[richardo2016](https://github.com/richardo2016)，[markzhai](https://github.com/markzhai)

# 实践 Redux，第 2 部分：Redux-ORM 的概念和技术




**使用 Redux-ORM 来帮助你管理范式化 state 的有用技术，第 2 部分:  
我是怎么用 Redux-ORM 的深入实例**

#### 系列目录
*   **[第 0 部分：系列简介](https://github.com/xitu/gold-miner/blob/master/TODO/practical-redux-part-0-introduction.md)**
*   **[第 1 部分：Redux-ORM 基础](https://github.com/xitu/gold-miner/blob/master/TODO/practical-redux-part-1-redux-orm-basics.md)**
*   **第 2 部分：Redux-ORM 概念和技术**

接着上一部分的 「Redux-ORM 是什么」和「为什么你想要用它」，我们现在要谈论的是 **Redux-ORM 的核心概念和我实际上是怎样在自己的应用中使用它的**。

> 注意：本文中的用例代码是为了展示常规概念和工作流使用的，很可能不会完全跑起来。稍后**请参考 [系列介绍](https://github.com/xitu/gold-miner/blob/master/TODO/practical-redux-part-0-introduction.md)** 获得关于在工作例子应用中展示这些想法的用例场景和计划的更多信息。

## Redux-ORM 核心概念

Redux-ORM 是一个作用在你的 Redux Store 里的范式化数据上的非常有用的抽象层。在使用它的时候，有一些关键的概念需要理解：

### 会话（Sessions）

Session 类用来和底层的数据集进行交互。如果你使用 `schema.reducer()` 生成的 reducer，Redux-ORM 将为你创建一个内部的 Session 实例。或者，你也可以通过调用 `schema.from(entities)`（创建的 Session 将不变式地进行更新），或者 `schema.withMutations(entities)`（创建的 Session 将直接改变提供的数据）来创建 Session 实例。

当 Session 实例从源数据创建后，Redux-ORM 创建 Schema 中可用的 Model 类型的临时子类，将它们「绑定」到这个 session，并将这些子类暴露为 Session 实例上的字段。这意味着**你应当总是从 Session 实例中提取你要用的 Model 类并和它们交互**，而不是使用你可能直接从模块层导入的版本。如果你将你的 reducer 作为你的 Model 类的一部分写入的话，Redux-ORM 将当前类的绑定版本作为第三个参数传入，将目前的 Session 实例作为第四个参数传入。

### 模型（Models）

Session 返回的 Model 实例只是 **store 中的 JavaScript 字面量的某些方面**。当请求 Model 实例时，Redux-ORM 根据底层对象的键，在 Model 实例上产生属性字段，以及声明的关联。这些属性字段定义了封装实际行为的 getter 和 setter。根据不同的字段，getter 会返回底层对象的纯值，或者对于单个关联的新 Model 实例，或者对于集合关联的 QuerySet 实例。底层对象可以直接用 `someModelInstance.ref` 来访问。

对于属性和 getter 的使用也意味着**直到你真正访问了那些属性以后关联才非范式化**。所以，即使一个实体有很多的关联，也不应该有任何额外的花费放在得到这个实体的一个 Model 实例上。

在内部，Redux-ORM 使用了一个 action 队列，将这些 action 像 mini-Redux（在 mini-Redux 里每个 action 被用来更新它内部 reducer 风格的 state） 那样应用。例如，执行 `const pilot = Pilot.create(attributes); pilot.name = "Jaime Wolf";` 会把一个 `Create` action 和一个 `UPDATE` action 放入队列。**直到你调用了 session 或者 model 上适当的方法后，这两个 action 才会被应用**，比如 `session.reduce()`。有一个例外：如果 session 用 `schema.withMutations(entities)` 创建，它**将**即刻直接应用所有更新到被影响的对象上。在其他情况下，**所有的更新被放入队列，然后按顺序不变式地被应用，产生最终结果**。

### 管理关联

Redux-ORM 以「QuerySet」类作为管理数据集的抽象。一个 QuerySet 知道它相连的 Model 类型是什么，保存了一个 ID 列表。诸如 `filter()` 这样的操作返回一个带有另外的内部 ID 列表的新 QuerySet 实例。QuerySet 有一个内部的标志，指示着它们究竟该参考纯对象，还是参考相应的 Model 实例。它将决定，在查询流程中使用属性 `withModels` 还是属性 `withRefs`，比如 `this.mechs.withModels.map(mechModel => mechModel.name)`。

对于 `many` 类型的关联，Redux-ORM 会自动生成「穿越模型」类，为关联中的两个条目存储它们的 ID。比如，一个拥有字段 `pilots : many("Pilot")` 的 `Lance` 会生成一个 `LancePilot` 类和表。现在有一个还开着的 PR（Pull Request）允许你定制这些穿越模型，来更好地服务于这种关联下的条目排序之类的情形。

### 同步

理解 Redux-ORM **并没有** 任何与服务器同步数据（比如 Backbone.Model 或 Ember Data 里包含的方法）的能力这一点很重要。它**只是**管理本地存储成纯 JS 数据的关联的库。（实际上，尽管它名字里有 Redux，它甚至完全不依赖于 Redux。）你需要自己负责处理数据同步的问题。

## 典型用法

我优先将 Redux-ORM 作为特定的「超级选择器」和「超级不变更新」工具使用。这意味着我将它和我自己的选择器函数，形实替换程序（thunk），reducer 和 `mapState` 函数一起使用。下面有一些我的实践。

### 实体（Entity）选取

因为我在我的整个应用中一致性地使用 Schema 单例实例，所以我创建了一个选择器，封装了提取当前 `entities` 片段和返回一个用这段数据初始化的 Session 实例的操作：

    import {createSelector} from "reselect";
    import schema from "./schema";

    export const selectEntities = state => state.entities;

    export const getEntitiesSession = createSelector(
        selectEntities,
        entities => schema.from(entities),
    );

利用这个选择器，我可以获取一个 `mapState` 函数内部的 Session 实例，并且在必要的时候，使用这个组件查询数据片段。

这样做有很多好处。尤其是，因为很多不同的 `mapState` 函数可能会连续地试图进行数据查找，对于每个 store 更新只有一个 Session 实例被创建出来，所以这会有一些性能优化的问题。Redux-ORM 提供了一个 `schema.createSelector()` 函数来创建优化的选择器，能够追踪那些被访问的模型，但是我还没有实际上尝试这个。我可能之后会研究下它，当我在我自己的应用上做一些性能/优化步骤时。

总之，我让我的所有组件都不知道 Redux-ORM 的存在，只将纯数据作为 props 传给我的组件。

### 基于实体（Entity）的 Reducer

多数我的实体相关的 reducer 是基于一个特定的 action 情况下的，而不是基于某个 Model 类下。因为这个，我的一些 reducer 是相当通用的，并且在 action payload 下，接收一个条目类型和一个条目 ID 作为参数。作为例子，以下是一个通用的 reducer，用来更新任何 Model 实例的属性：

    export function updateEntity(state, payload) {
        const {itemType, itemID, newItemAttributes} = payload;

        const session = schema.from(state);
        const ModelClass = session[itemType];

        let newState = state;

        if(ModelClass.hasId(itemID)) {
            const modelInstance = ModelClass.withId(itemID);

            modelInstance.update(newItemAttributes);

            newState = session.reduce();
        }

        return newState;
    }

我不是所有的 reducer 都那么通用——有些会结束于特定地引用某些模型类型，以特定的方式。在一些情况下，我会构建一个高层次的功能，通过重新使用这些通用的构建代码块 reducer。

我的 reducer 通常遵循这种模式：从 payload 里提取参数，创建 Session 实例，将更新加入队列，使用 `session.reduce()` 应用更新，然后返回新的 state。不得不承认这有一些冗长，如果我想的话我可以将其进一步抽象，但在我看来，这是值得的，我得到了实际运行中的更新逻辑整体的一致性和简单性。

我也写了一些小的工具来辅助通过模型的类型和 ID 来查找该模型的流程：

    export function getModelByType(session, itemType, itemID) {
        const modelClass = session[itemType];
        const model = modelClass.withId(itemID);
        return model;
    }

    export function getModelIdentifiers(model) {
        return {
            itemID : model.getId(),
            itemType : model.getClass().modelName,
        };
    }

很多我的 action 在它们的 payload 中包含了 `itemType` 和 `itemID` 对。部分原因是我个人习惯于让我的 action 相当轻量，把更多工作尽量放在形实替换程序（thunk）**和** reducer 上，并且我不喜欢盲目地将数据从 action 直接合并到我的 state 里。

我发现我经常需要以一种多步骤方式应用更新。然而，因为 Model 实例是基于字面量的数据集，这并不总是工作得很好。如果我将一些更新放入队列（比如 `someModel.someField = 123`），这种改变在它被应用之前，对 Model 实例都不是「可见」的。因为更新是不变式地被应用的，这种情形就变复杂了。

一种处理这个的方法可能是利用初始数据，创建一个初始的 Session 实例，然后利用更新后的数据，创建第二个 Session 实例：

    const firstSession = schema.from(entities);
    const {Pilot} = firstSession;

    const pilot = Pilot.withId(pilotId);
    // 属性更新在这里排队
    pilot.name = "Natasha Kerensky";

    const updatedEntities = firstSession.reduce();

    const secondSession = schema.from(updatedEntities);
    const {Pilot : Pilot2} = secondSession;

    // 用第二个 session 出来的类，做一些事情
    // 这些类实际上是在更新后的数据对象上的数据集

虽然这样，我并不是这种做法的支持者。这种做法很难看，并且会造成我在任何时候使用时究竟该选择 Session 和 Model 类中的哪个的混乱。

我仔细查看了 Redux-ORM 的源码，并且注意到一个 Session 实例其实是一个在内部存储为 `this.state` 的对象的封装。因为这个字段是 public 的，我们可以与它进行互动。尤其是，我意识到我可以拿一个已有的 Session 实例，更新它，使得它引用另一个 state 对象，而不用创建第二个 Session 实例：

    const session = schema.from(entities);
    const {Pilot} = session;

    const pilot = Pilot.withId(pilotId);
    pilot.name = "Natasha Kerensky";

    // 不变式地应用更新，然后将 session 指向更新后的 state 对象
    session.state = session.reduce();

    // 所有的字段/模型查询现在使用更新后的 state 对象

这种做法允许我实现一些相对复杂的多步数据更新，然而还是保持用一种不变式的方式处理所有的数据。

既然这种过程实际上更改了当前的 Session 实例，我必须特别注意，不使用从 getEntitiesSession() 选择器中返回的「共享的」Session 实例来做这样的更新。如果我在一个 reducer 里需要使用，无论如何我总是创建一个新的 Session。如果我在一个形实替换程序（thunk）中需要使用，我用另一个选择器来为这个任务创建一个单独的 Session 实例：

    export function getUnsharedEntitiesSession(state) {
        const entities = selectEntities(state);
        return schema.from(entities);
    }

## 加入特定行为

Redux-ORM 对于处理范式化数据，提供了一些非常有用的工具，但它只有这么多内置功能。幸运的事，它也是一个很好的构造额外功能的开端。

### 数据的序列化与反序列化

在上篇文章中提到， Normalizr 库是一个关于将从服务器端接收到的数据范式化的事实标准。我发现 Redux-ORM 可以主要被用于构建一个 Normalizr 的替代品。我在我的每个类上加入了静态的 `parse()` 方法，这些方法知道怎样根据关联处理输入的数据：

    class Lance extends Model {
        static parse(lanceData) {
            // 因为这是个静态方法，「this」在这里指代类自身。
            // 在这种情形下，我们在一个绑定在 Session 上的子类中执行代码。
            const {Pilot, Battlemech, Officer} = this.session;

            // 假设我们的输入数据看起来像这样：
            // {name, commander : {}, mechs : [], pilots : []}

            let clonedData = {
               ...lanceData,
               commander = Officer.parse(clonedData.commander),
               mechs : lanceData.mechs.map(mech => Battlemech.parse(mech)),
               pilots : lanceData.pilots.map(pilot => Pilot.parse(pilot))
            };

            return this.create(clonedData);
        }
    }

这个方法可以被形实替换程序（thunk）或 reducer 调用，来帮助处理响应数据，以及将必要的 Redux-ORM 内部的 `CREATE` action 放入队列。如果在 reducer 里被调用，更新可以被直接应用到已有的 state 上。如果在形实替换程序（thunk）里被用到，你可能想将生成的范式化数据放入一个调度 action 内，来合并进 store。

> **注意**: 我自己的数据只是嵌套了，并没有重复。我一度假设这个过程会将重复数据处理得很好，通过将它合并或者类似的操作。然而，一些测试表明，我的假设是错误的。如果一个条目拥有一个已经存在于 state 的 ID，并且这个相同类型和 ID 的 `CREATE` action 已经进入队列，Redux-ORM 会报错。如果两个拥有相同 ID 的 `CREATE` action 在一个队列里，Redux-ORM 会有效地把第一个创建入口扔掉，用第二个来代替。我已经 [提了一个 issue](https://github.com/tommikaikkonen/redux-orm/issues/50) 来讨论理想行为应该是怎么样的。

另一方面，将非范式化的数据版本发送回服务器端通常也是必要的。我对我的模型加入了 `toJSON()` 方法来支持这种需求：

    class Lance extends Model {
        toJSON() {
            const data = {
                // 包括纯数据对象的所有字段
                ...this.ref,
                // 和经过序列化的已知模型间关联（relation）
                commander : this.commander.toJSON(),
                pilots : this.pilots.withModels.map(pilot => pilot.toJSON()),
                mechs : this.mechs.withModels.map(mech => mech.toJSON())
            };

            return data;
        }
    }

### 创建与删除

在将新的实体发送到服务器端或添加到 store 之前，我往往需要用一个 action creator 来创建它的初始数据。我仍在思索什么是最好的做法。目前，我添加了 `generate` 方法来帮助封装过程：

    const defaultAttributes = {
        name : "Unnamed Lance",
    };

    class Lance extends Model {
        static generate(specifiedAttributes = {}) {
            const id = generateUUID("lance");

            const mergedAttributes = {
                ...defaultAttributes,
                id,
                ...specifiedAttributes,     
            }

            return this.create(mergedAttributes);
        }
    }

    function createNewLance(name) {
        return (dispatch, getState) => {
            const session = getUnsharedEntitiesSession(getState());
            const {Lance} = session;

            const newLance = Lance.generate({name : "Command Lance"});
            session.state = session.reduce();
            const itemAttributes = newLance.toJSON();

            dispatch(createEntity("Lance", newLance.getId(), itemAttributes));
        }
    }

同时，Redux-ORM 的 「Model.delete」方法不完全级联，所以我在需要的地方实现了一个自定义的「deleteCascade」方法：

    class Lance extends Model {
        deleteCascade() {
            this.mechs.withModels.forEach(mechModel => mechModel.deleteCascade());
            this.pilots.withModels.forEach(pilotModel => pilotModel.deleteCascade());
            this.delete();
        }
    }

我还实现了一些额外的东西，来更好地处理将数据在不同的模型实例版本（比如「当前」版本 V.S. 「正在工作的草稿」版本）间复制来复制去的问题，我将在之后的一篇关于数据编辑方法的文章中谈到。

## 最终思考

Redux-ORM 在 Redux 上层引入了一些额外的概念。如同任何抽象层，它允许你忽略细节，所以你需要理解 Redux 这层究竟发生了什么。也就是说，我发现它真正地让我可以从一个更高的抽象层思考我的数据管理。而且，它的处理关联和简化不变式地更新数据的能力实在是为我省了很多时间，并让我的代码在流程上更加简洁。我对它已经非常满足，等不及看 Tommi Kaikknonen 在未来还会作出怎样的改进。

想要更多的信息链接，包括文档和文章，请看**[第 1 部分： Redux-ORM 基础](https://github.com/xitu/gold-miner/blob/master/TODO/practical-redux-part-1-redux-orm-basics.md)**。
