> * 原文地址：[React is Slow, React is Fast: Optimizing React Apps in Practice](https://marmelab.com/blog/2017/02/06/react-is-slow-react-is-fast.html/)
> * 原文作者：[François Zaninotto ](https://github.com/francoisz)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Jiang Haichao](https://github.com/AceLeeWinnie)
> * 校对者：[Wneil](https://github.com/avocadowang), [Chen Lu](https://github.com/1992chenlu)

# React 的慢与快：优化 React 应用实战

React 是慢的。我的意思是，任何中等规模的 React 应用都是慢的。但是在开始找备选方案之前，你应该明白任何中等规模的 Angular 或 Ember 应用也是慢的。好消息是：如果你在乎性能，使 React 应用变得超级快则相当容易。这篇文章就是案例。

## 衡量 React 性能

我说的 “慢” 到底是什么意思？举个例子。

我正在为 [admin-on-rest](https://github.com/marmelab/admin-on-rest) 这个开源项目工作，它使用 [material-ui](http://www.material-ui.com/#/) 和 [Redux](http://redux.js.org/) 为任一 REST API 提供一个 admin 用户图形界面。这个应用已经有一个数据页，在一个表格中展示一系列记录。当用户改变排列顺序，导航到下一个页面，或者做结果筛选，这个界面的响应式做的我不够满意。接下来的截屏是刷新放慢了 5x 的结果。

![Datagrid refresh](https://marmelab.com/images/blog/admin-on-rest-slow-sort.gif)

来看看发生了什么，我在 URL 里插入一个 `?react_perf`。自 React 15.4，可以通过这个属性启用 [组件 Profiling](https://facebook.github.io/react/blog/2016/11/16/react-v15.4.0.html#profiling-components-with-chrome-timeline)。等待初始化数据页加载完毕。在 Chrome 开发者工具打开 Timeline 选项卡，点击 "Record" 按钮，并单击表头更新排列顺序。一旦数据更新，再次点击 "Record" 按钮停止记录，Chrome 会在 "User Timing" 标签下展示一个黄色的火焰图。

![Initial flamegraph](https://marmelab.com/images/blog/initial_flamegraph.png)

如果你从未见过火焰图，看起来会有点吓人，但它其实非常易于使用。这个 "User Timing" 图显示的是每个组件占用的时间。它隐藏了 React 内部花费的时间（这部分时间是你无法优化的），所以这图使你专注优化你的应用。这个 Timeline 显示的是不同阶段的窗口截屏，这就能聚焦到点击表头时对应的时间点情况。

![Initial flamegraph zoomed](https://marmelab.com/images/blog/initial_flamegraph_zoomed.png)

似乎在点击排序按钮后，甚至在拿到 REST 数据 **之前** 就已经重新渲染，我的应用就重新渲染了 `<List>` 组件。这个过程花费了超过 500ms。这个应用仅仅更新了表头的排序 icon，和在数据表之上展示灰色遮罩表明数据仍在传输。

另外，这个应用花了半秒钟提供点击的视觉反馈。500ms 绝对是可感知的 - UI 专家如是说，[当视觉层改变低于 100ms 时，用户感知才是瞬时的](https://www.nngroup.com/articles/website-response-times/)。这一可觉察的变更即是我所说的 ”慢“。

## 为何而更新？

根据上述火焰图，你会看到许多小的凹陷。那不是一个好标志。这意味着许多组件被重绘了。火焰图显示，`<Datagrid>` 组件更新花费了最多时间。为什么在获取到新数据之前应用会重绘整个数据表呢？让我们来深入探讨。

要理解重绘的原因，通常要借助在 `render` 函数里添加 `console.log()` 语句完成。因为函数式的组件，你可以使用如下的单行高阶组件（HOC）:

```
// in src/log.js
const log = BaseComponent => props => {
    console.log(`Rendering ${BaseComponent.name}`);
    return <BaseComponent {...props} />;
}
export default log;

// in src/MyComponent.js
import log from './log';
export default log(MyComponent);
```

**小提示**：另一值得一提的 React 性能工具是 [`why-did-you-update`](https://github.com/garbles/why-did-you-update)。这个 npm 包在 React 基础上打了一个补丁，当一个组件基于相同 props 重绘时会打出 console 警告。说明：输出十分冗长，并且在函数式组件中不起作用。

在这个例子中，当用户点击列的标题，应用触发一个 action 来改变 state：此列的排序 [`currentSort`] 被更新。这个 state 的改变触发了 `<List>` 页的重绘，反过来造成了整个 `<Datagrid>` 组件的重绘。在点击排序按钮后，我们希望 datagrid 表头能够立刻被重绘，作为用户行为的反馈。

使得 React 应用迟缓的通常不是单个慢的组件（在火焰图中反映为一个大的区块）。**大多数时候，使 React 应用变慢的是许多组件无用的重绘。** 你也许曾读到，React 虚拟 DOM 超级快的言论。那是真的，但在一个中等规模的应用中，全量重绘容易造成成百的组件重绘。甚至最快的虚拟 DOM 模板引擎也不能使这一过程低于 16ms。

## 切割组件即优化

这是 `<Datagrid>` 组件的 `render()` 方法：

```
// in Datagrid.js
render() {
    const { resource, children, ids, data, currentSort } = this.props;
    return (
        <table>
            <thead>
                <tr>
                    {React.Children.map(children, (field, index) => (
                        <DatagridHeaderCell key={index} field={field} currentSort={currentSort} updateSort={this.updateSort}
                        />
                    ))}
                </tr>
            </thead>
            <tbody>
                {ids.map(id => (
                    <tr key={id}>
                        {React.Children.map(children, (field, index) => (
                            <DatagridCell record={data[id]} key={`${id}-${index}`} field={field} resource={resource} />
                        ))}
                    </tr>
                ))}
            </tbody>
        </table>
    );
}
```

这看起来是一个非常简单的 datagrid 的实现，然而这 **非常低效**。每个 `<DatagridCell>` 调用会渲染至少两到三个组件。正如你在初次界面截图里看到的，这个表有 7 列，11 行，即 7x11x3 = 231 个组件会重新渲染。仅仅是 `currentSort` 的改变时，这简直是浪费时间。虽然在虚拟 DOM 没有更新的情况下，React 不会更新真实DOM，所有组件的处理也会耗费 500ms。

为了避免无用的表体渲染，第一步就是把它 **抽取** 出来：

```
// in Datagrid.js
render() {
    const { resource, children, ids, data, currentSort } = this.props;
    return (
        <table>
            <thead>
                <tr>
                    {React.Children.map(children, (field, index) => (
                        <DatagridHeaderCell key={index} field={field} currentSort={currentSort} updateSort={this.updateSort}
                        />
                    ))}
                </tr>
            </thead>
            <DatagridBody resource={resource} ids={ids} data={data}>
                {children}
            </DatagridBody>
            </table>
        );
    );
}
```

通过抽取表体逻辑，我创建了新的 `<DatagridBody>` 组件：

```
// in DatagridBody.js
import React from 'react';

const DatagridBody = ({ resource, ids, data, children }) => (
    <tbody>
        {ids.map(id => (
            <tr key={id}>
                {React.Children.map(children, (field, index) => (
                    <DatagridCell record={data[id]} key={`${id}-${index}`} field={field} resource={resource} />
                ))}
            </tr>
        ))}
    </tbody>
);

export default DatagridBody;
```

抽取表体对性能上毫无影响，但它反映了一条优化之路。庞大的，通用的组件优化起来有难度。小的，单一职责的组件更容易处理。

## shouldComponentUpdate

[React 文档](https://facebook.github.io/react/docs/react-component.html#shouldcomponentupdate) 里对于避免无用的重绘有非常明确的方法：`shouldComponentUpdate()`。默认的，React **一直重绘** 组件到虚拟 DOM 中。换句话说，作为开发者，在那种情况下，检查 props 没有改变的组件和跳过绘制都是你的工作。

以上述 `<DatagridBody>` 组件为例，除非 props 改变，否则 body 就不应该重绘。

所以组件应该如下：

```
import React, { Component } from 'react';

class DatagridBody extends Component {
    shouldComponentUpdate(nextProps) {
        return (nextProps.ids !== this.props.ids
             || nextProps.data !== this.props.data);
    }

    render() {
        const { resource, ids, data, children } = this.props;
        return (
            <tbody>
                {ids.map(id => (
                    <tr key={id}>
                        {React.Children.map(children, (field, index) => (
                            <DatagridCell record={data[id]} key={`${id}-${index}`} field={field} resource={resource} />
                        ))}
                    </tr>
                ))}
            </tbody>
        );
    }
}

export default DatagridBody;
```

**小提示**：相比手工实现 `shouldComponentUpdate()` 方法，我可以继承 React 的 `PureComponent` 而不是 `Component`。这个组件会用严格对等（`===`）对比所有的 props，并且仅当 **任一** props 变更时重绘。但是我知道在例子的上下文中 `resource` 和 `children` 不会变更，所以无需检查他们的对等性。

有了这一优化，点击表头后，`<Datagrid>` 组件的重绘会跳过表体及其全部 231 个组件。这会将 500ms 的更新时间减少到 60ms。网络性能提高超过 400ms！

![Optimized flamegraph](https://marmelab.com/images/blog/optimized_flamegraph.png)

**小提示**：别被火焰图的宽度骗了，比前一个火焰图而言，它放大了。这幅火焰图显示的性能绝对是最好的！

`shouldComponentUpdate` 优化在图中去掉了许多凹坑，并减少了整体渲染时间。我会用同样的方法避免更多的重绘（例如：避免重绘 sidebar，操作按钮，没有变化的表头和页码）。一个小时的工作之后， 点击表头的列后，整个页面的渲染时间仅仅是 100ms。那相当快了 - 即使仍然存在优化空间。

添加一个 `shouldComponentUpdate` 方法也许似乎很麻烦，但如果你真的在乎性能，你所写的大多数组件都应该加上。

别哪里都加上 `shouldComponentUpdate` - 在简单组件上执行 `shouldComponentUpdate` 方法有时比仅渲染组件要耗时。也别在应用的早期使用 - 这将过早地进行优化。但随着应用的壮大，你会发现组件上的性能瓶颈，此时才添加 `shouldComponentUpdate` 逻辑保持快速地运行。

## 重组

我不是很满意之前在 `<DatagridBody>` 上的改造：由于使用了 `shouldComponentUpdate`，我不得不改造成简单的基于类的函数式组件。这增加了许多行代码，每一行代码都要耗费精力 - 去写，调试和维护。

幸运的是，得益于 [recompose](https://github.com/acdlite/recompose)，你能够在高阶组件（HOC）上实现 `shouldComponentUpdate` 的逻辑。它是一个 React 的函数式工具，提供 `pure()` 高阶实例。

```
// in DatagridBody.js
import React from 'react';
import pure from 'recompose/pure';

const DatagridBody = ({ resource, ids, data, children }) => (
    <tbody>
        {ids.map(id => (
            <tr key={id}>
                {React.Children.map(children, (field, index) => (
                    <DatagridCell record={data[id]} key={`${id}-${index}`} field={field} resource={resource} />
                ))}
            </tr>
        ))}
    </tbody>
);

export default pure(DatagridBody);
```

这段代码与上述的初始实现仅有的差异是：我导出了 `pure(DatagridBody)` 而非 `DatagridBody`。`pure` 就像 `PureComponent`，但是没有额外的类模板。

当使用 `recompose` 的 `shouldUpdate()` 而不是 `pure()` 的时候，我甚至可以更加具体，只瞄准我知道可能改变的 props：

```
// in DatagridBody.js
import React from 'react';
import shouldUpdate from 'recompose/shouldUpdate';

const DatagridBody = ({ resource, ids, data, children }) => (
    ...
);

const checkPropsChange = (props, nextProps) =>
    (nextProps.ids !== this.props.ids
  || nextProps.data !== this.props.data);

export default shouldUpdate(checkPropsChange)(DatagridBody);
```

`checkPropsChange` 是纯函数，我甚至可以导出做单元测试。

recompose 库提供了更多 HOC 的性能优化方案，例如 `onlyUpdateForKeys()`，这个方法所做的检查，与我自己写的 `checkPropsChange` 那类检查完全相同。

```
// in DatagridBody.js
import React from 'react';
import onlyUpdateForKeys from 'recompose/onlyUpdateForKeys';

const DatagridBody = ({ resource, ids, data, children }) => (
    ...
);

export default onlyUpdateForKeys(['ids', 'data'])(DatagridBody);
```

强烈推荐 recompose 库，除了能优化性能，它能帮助你以函数和可测的方式抽取数据获取逻辑，HOC 组合和进行 props 操作。

## Redux

如果你正在使用 [Redux](http://redux.js.org/) 管理应用的 state （我也推荐这一方式），那么 connected 组件已经是纯组件了。不需要添加 HOC。只要记住一旦其中一个 props 改变了，connected 组件就会重绘 - 这也包括了所有子组件。因此即使你在页面组件上使用 Redux，你也应该在渲染树的深层用 `pure()` 或 `shouldUpdate()`。

并且，当心 Redux 用严格模式对比 props。因为 Redux 将 state 绑定到组件的 props 上，如果你修改 state 上的一个对象，Redux 的 props 对比会错过它。这也是为什么你必须在 reducer 中用 **不可变性原则**

举个栗子，在 admin-on-rest 中，点击表头 dispatch 一个 `SET_SORT` action。监听这个 action 的 reducer 必须 **替换** state 中的 object，而不是 **更新** 他们。

```
// in listReducer.js
export const SORT_ASC = 'ASC';
export const SORT_DESC = 'DESC';

const initialState = {
    sort: 'id',
    order: SORT_DESC,
    page: 1,
    perPage: 25,
    filter: {},
};

export default (previousState = initialState, { type, payload }) => {
    switch (type) {
    case SET_SORT:
        if (payload === previousState.sort) {
            // inverse sort order
            return {
                ...previousState,
                order: oppositeOrder(previousState.order),
                page: 1,
            };
        }
        // replace sort field
        return {
            ...previousState,
            sort: payload,
            order: SORT_ASC,
            page: 1,
        };

    // ...

    default:
        return previousState;
    }
};
```

还是这个 reducer，当 Redux 用 '===' 检查到变化时，它发现 state 对象的不同，然后重绘 datagrid。但是我们修改 state 的话，Redux 将会忽略 state 的改变并错误地跳过重绘：

```
// don't do this at home
export default (previousState = initialState, { type, payload }) => {
    switch (type) {
    case SET_SORT:
        if (payload === previousState.sort) {
            // never do this
            previousState.order = oppositeOrder(previousState.order);
            return previousState;
        }
        // never do that either
        previousState.sort = payload;
        previousState.order = SORT_ASC;
        previousState.page = 1;
        return previousState;

    // ...

    default:
        return previousState;
    }
};
```

为了不可变的 reducer，其他开发者喜欢用同样来自 Facebook 的 [immutable.js](https://facebook.github.io/immutable-js/)。我觉得这没必要，因为 ES6 解构赋值使得有选择地替换组件属性十分容易。另外，Immutable 也很笨重（60kB），所以在你的项目中添加它之前请三思。

## 重新选择

为了防止（Redux 中）无用的绘制 connected 组件，你必须确保 `mapStateToProps` 方法每次调用不会返回新的对象。

以 admin-on-rest 中的 `<List>` 组件为例。它用以下代码从 state 中为当前 resource 获取一系列记录（如：帖子，评论等）：

```
// in List.js
import React from 'react';
import { connect } from 'react-redux';

const List = (props) => ...

const mapStateToProps = (state, props) => {
    const resourceState = state.admin[props.resource];
    return {
        ids: resourceState.list.ids,
        data: Object.keys(resourceState.data)
            .filter(id => resourceState.list.ids.includes(id))
            .map(id => resourceState.data[id])
            .reduce((data, record) => {
                data[record.id] = record;
                return data;
            }, {}),
    };
};

export default connect(mapStateToProps)(List);
```

state 包含了一个数组，是以前获取的记录，以 resource 做索引。举例，`state.admin.posts.data` 包含了一系列帖子：

```
{
    23: { id: 23, title: "Hello, World", /* ... */ },
    45: { id: 45, title: "Lorem Ipsum", /* ... */ },
    67: { id: 67, title: "Sic dolor amet", /* ... */ },
}
```

`mapStateToProps` 方法筛选 state 对象，只返回在 list 中展示的部分。如下所示：

```
{
    23: { id: 23, title: "Hello, World", /* ... */ },
    67: { id: 67, title: "Sic dolor amet", /* ... */ },
}
```

问题是每次 `mapStateToProps` 执行，它会返回一个新的对象，即使底层对象没有被改变。结果，`<List>` 组件每次都会重绘，即使只有 state 的一部分改变了 - date 或 ids 改变造成 id 改变。

[Reselect](https://github.com/reactjs/reselect) 通过备忘录模式解决这个问题。相比在 `mapStateToProps` 中直接计算 props，从 reselect 中用 **selector** 如果输入没有变化，则返回相同的输出。

```
import React from 'react';
import { connect } from 'react-redux';
import { createSelector } from 'reselect'

const List = (props) => ...

const idsSelector = (state, props) => state.admin[props.resource].ids
const dataSelector = (state, props) => state.admin[props.resource].data

const filteredDataSelector = createSelector(
  idsSelector,
  dataSelector
  (ids, data) => Object.keys(data)
      .filter(id => ids.includes(id))
      .map(id => data[id])
      .reduce((data, record) => {
          data[record.id] = record;
          return data;
      }, {})
)

const mapStateToProps = (state, props) => {
    const resourceState = state.admin[props.resource];
    return {
        ids: idsSelector(state, props),
        data: filteredDataSelector(state, props),
    };
};

export default connect(mapStateToProps)(List);
```

现在 `<List>` 组件仅在 state 的子集改变时重绘。

作为重组问题，reselect selector 是纯函数，易于测试和组合。它是为 Redux connected 组件编写 selector 的最佳方式。

## 当心 JSX 中的对象字面量

当你的组件变得更 “纯” 时，你开始检测导致无用重绘坏模式。最常见的是 JSX 中对象字面量的使用，我更喜欢称之为 "**臭名昭著的 {{**"。请允许我举例说明：

```
import React from 'react';
import MyTableComponent from './MyTableComponent';

const Datagrid = (props) => (
    <MyTableComponent style={{ marginTop: 10 }}>
        ...
    </MyTableComponent>
)
```

每次 `<Datagrid>` 组件重绘，`<MyTableComponent>` 组件的 `style` 属性都会得到一个新值。所以即使 `<MyTableComponent>` 是纯的，每次 `<Datagrid>` 重绘时它也会跟着重绘。事实上，每次把对象字面量当做属性值传递到子组件时，你就打破了纯函数。解法很简单：

```
import React from 'react';
import MyTableComponent from './MyTableComponent';

const tableStyle = { marginTop: 10 };
const Datagrid = (props) => (
    <MyTableComponent style={tableStyle}>
        ...
    </MyTableComponent>
)
```

这看起来很基础，但是我见过太多次这个错误，因而生成了检测臭名昭著的 `{{` 的敏锐直觉。我把他们一律替换成常量。

另一个常用来劫持纯函数的 suspect 是 `React.cloneElement()`。如果你把 prop 值作为第二参数传入方法，每次渲染就会生成一个带新 props 的新 clone 组件。

```
// bad
const MyComponent = (props) => <div>{React.cloneElement(Foo, { bar: 1 })}</div>;

// good
const additionalProps = { bar: 1 };
const MyComponent = (props) => <div>{React.cloneElement(Foo, additionalProps)}</div>;
```

[material-ui](http://www.material-ui.com/#/) 已经困扰了我一段时间，举例如下：

```
import { CardActions } from 'material-ui/Card';
import { CreateButton, RefreshButton } from 'admin-on-rest';

const Toolbar = ({ basePath, refresh }) => (
    <CardActions>
        <CreateButton basePath={basePath} />
        <RefreshButton refresh={refresh} />
    </CardActions>
);

export default Toolbar;
```

尽管 `<CreateButton>` 是纯函数，但每次 `<Toolbar>` 绘制它也会绘制。那是因为 material-ui 的 `<CardActions>` 添加了一个特殊 style，为了使第一个子节点适应 margin - 它用了一个对象字面量来做这件事。所以 `<CreateButton>` 每次都收到不同的 `style` 属性。我用 recompose 的 `onlyUpdateForKeys()` HOC 解决了这个问题。

```
// in Toolbar.js
import onlyUpdateForKeys from 'recompose/onlyUpdateForKeys';

const Toolbar = ({ basePath, refresh }) => (
    ...
);

export default onlyUpdateForKeys(['basePath', 'refresh'])(Toolbar);
```

## 结论

还有许多可以使 React 应用更快的方法（使用 keys、懒加载重路由、`react-addons-perf` 包、使用 ServiceWorkers 缓存应用状态、使用同构等等），但正确实现 `shouldComponentUpdate` 是第一步 - 也是最有用的。

React 默认是不快的，但是无论是什么规模的应用，它都提供了许多工具来加速。这也许是违反直觉的，尤其自从许多框架提供了 React 的替代品，它们声称比 React 快 n 倍。但 React 把开发者的体验放在了性能之前。这也是为什么用 React 开发大型应用是个愉快的体验，没有惊吓，只有不变的实现速度。

只要记住，每隔一段时间 profile 你的应用，让出一些时间在必要的地方添加一些 `pure()` 调用。别一开始就做优化，别花费过多时间在每个组件的过度优化上 - 除非你是在移动端。记住在不同设备进行测试，让用户对应用的响应式有良好印象。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
