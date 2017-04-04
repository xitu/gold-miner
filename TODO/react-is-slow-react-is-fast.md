> * 原文地址：[React is Slow, React is Fast: Optimizing React Apps in Practice](https://marmelab.com/blog/2017/02/06/react-is-slow-react-is-fast.html/)
> * 原文作者：[François Zaninotto ](https://github.com/francoisz)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Jiang Haichao](https://github.com/AceLeeWinnie)
> * 校对者：

# React is Slow, React is Fast: Optimizing React Apps in Practice
# React 的慢与快：优化 React 应用实战

React is slow. I mean, any medium-size React application is slow. But before you start looking for alternatives, you should know that any medium-size Angular of Ember application is slow, too. And the good news is: If you care about performance, it’s fairly easy to make any React application super fast. Here is how.

React 是慢的。我的意思是，任何中等规模的 React 应用都是慢的。但是在开始找备选方案之前，你应该明白任何中等规模的 Angular 应用也是慢的。好消息是：如果你在乎性能，使 React 应用变得超级快则相当容易。这里就是例子。

## Mesuring React Performance

## 测量 React 性能

What do I mean by “slow”? Let’s take an example.

我说的 “慢” 到底是什么意思？举个例子。

I’m working on an open-source project called [admin-on-rest](https://github.com/marmelab/admin-on-rest), which leverages [material-ui](http://www.material-ui.com/#/) and [Redux](http://redux.js.org/) to provide an admin GUI for any REST API. This application has a datagrid page, displaying a list of records in a table. When the user changes the sort order, or goes to the next page, or filters the result, the interface isn’t as responsive as I would expect. The following screencast shows the refresh slowed down 5 times:

我正在为 [admin-on-rest](https://github.com/marmelab/admin-on-rest) 这个开源项目工作，它使用 [material-ui](http://www.material-ui.com/#/) 和 [Redux](http://redux.js.org/) 为任一 REST API 提供一个 admin 用户图形界面。这个应用已经有一个数据页，在一个表格中展示一系列记录。当用户改变订阅类型，导航到下一个页面，或者做结果删选，这个界面的响应式做的我不够满意。接下来的截屏展示的是放慢 5x 倍速的刷新。

![Datagrid refresh](https://marmelab.com/images/blog/admin-on-rest-slow-sort.gif)

To see what’s happening, I append a `?react_perf` to the URL. This enables [Component Profiling](https://facebook.github.io/react/blog/2016/11/16/react-v15.4.0.html#profiling-components-with-chrome-timeline) since React 15.4. I wait for the initial datagrid to load. Then I open the Chrome Developer Tools on the Timeline tab, hit the “Record” button, and click on a table header to update the sort order. Once the data refreshes, I hit the “Record” button again to stop recording, and Chrome displays a yellow flamegraph with a “User Timing” label.

来看看发生了什么，我在 URL 里插入一个 `?react_perf`。自 React 15.4，可以通过这个属性启用 [组件 Profiling](https://facebook.github.io/react/blog/2016/11/16/react-v15.4.0.html#profiling-components-with-chrome-timeline)。等待初始化数据页加载完毕。在 Timeline 面板打开 Chrome 开发者工具，点击 "Record" 按钮，并单击表头更新命令类型。一旦数据更新，再次点击 "Record" 按钮停止记录，Chrome 会在 "User Timing" 标签下展示一个黄色的火焰图。

![Initial flamegraph](https://marmelab.com/images/blog/initial_flamegraph.png)

If you’ve never seen a flamegraph, it can look intimidating, but it’s actually very easy to use. This “User Timing” graph shows the time passed in each of your components. It hides the time spend inside React internals (you can’t optimize this time anyway), so it lets you focus on optimizing your app. The Timeline displays screenshots of the window at various stages, this lets me zoom in to the moment I clicked on the table header:

如果你从未见过火焰图，看起来会有点吓人，但它确实非常易于使用。这个 "User Timing" 图显示的是每个组件占用的时间。它隐藏了 React 内部花费的时间（这部分时间是你无法优化的），所以这图使你专注优化你的应用。这个 Timeline 显示的是不同阶段的窗口截屏，点击表头的时间，就能聚焦到对应的时间点的情况。

![Initial flamegraph zoomed](https://marmelab.com/images/blog/initial_flamegraph_zoomed.png)

It seems that my app rerenders the `<List>` component just after clicking on the sort button, *before* even fetching the REST data. And this takes more than 500ms. The app just updates the sort icon in the table header, and displays a grey overlay on the datagrid to show that the data is being fetched.

似乎在点击排序按钮后，甚至在拿到 REST 数据 **之前** 就已经重新渲染，我的应用就重新渲染了 `<List>` 组件。这个过程花费了超过 500ms。这个应用仅仅更新了表头的排序 icon，和在数据表之上展示灰色遮罩表明数据仍在传输。

To put it otherwise, the app takes half a second to provide visual feedback to a click. Half a second is definitely perceivable - UI experts say that [users perceive an interface change as instantaneous when it’s below 100ms](https://www.nngroup.com/articles/website-response-times/). A change slower than that is what I mean by “slow”.

另外，这个应用花了半秒钟提供点击的视觉反馈。500ms 绝对是可感知的 - UI 专家如是说，[当视觉层改变低于 100ms 时，用户感知才是瞬时的](https://www.nngroup.com/articles/website-response-times/)。这一可觉察的变更即是我所说的 ”慢“。

## Why Did You Update?

## 为何而更新？

In the flamegraph above, you can see many tiny pits. That’s not a good sign. It means that many components are rerendered. The flamegraph shows that the `<Datagrid>` update takes the most time. Why did the app rerender the entire datagrid before fetching new data? Let’s dig down.

根据上述火焰图，你会看到许多小的凹陷。那不是一个好标志。这意味着许多组件被重绘了。火焰图显示，`<Datagrid>` 组件更新花费了最多时间。为什么在获取到新数据之前应用会重绘整个数据表呢？让我们来深入探讨。

Understanding the causes of a rerender often implies adding `console.log()` statements in `render()` functions. For functional components, you can use the following one-liner Higher-Order Component (HOC):

要理解重绘的原因，通常要借助在 `render` 函数里添加 `console.log()` 语句。因为函数式的组件，你可以使用如下的单行高阶组件（HOC）:

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

**Tip**: Another React performance tool worth mentioning is [`why-did-you-update`](https://github.com/garbles/why-did-you-update). This npm package patches React to emit console warnings whenever a component rerenders with identical props. Caveats: The output is verbose, and it doesn’t work on functional components.

**小提示**：另一值得一提的 React 性能工具是 [`why-did-you-update`](https://github.com/garbles/why-did-you-update)。这个 npm 包在 React 基础上打了一个补丁，当一个组件基于相同 props 重绘时会打出 console 警告。警告：输出十分冗长，并且在函数式组件中不起作用。

In the example, when the user clicks on a header column, the app emits an action, which changes the state: the list sort order (`currentSort`) is updated. This state change triggers the rerendering of the `<List>` page, which in turn rerenders the entire `<Datagrid>` component. We want the datagrid header to be immediately rendered to show the sort icon change as a feedback to user action.

在这个例子中，当用户点击列的标题，应用触发一个 action 来改变 state：此列的排序 [`currentSort`] 被更新。这个 state 的改变触发了 `<List>` 页的重绘，反过来造成了整个 `<Datagrid>` 组件的重绘。我们希望 datagrid 表头能够在用户行为产生时立即重绘用以展示排序 icon，作为用户行为的反馈。

What makes a React app slow is usually not a single slow component (that would translate in the flamegraph as one large pit). **What makes a React app slow is, most of the time, useless rerenders of many components.** You may have read that the React VirtualDom is super fast. That’s true, but in a medium size app, a full redraw can easily render hundreds of components. Even the fastest VirtualDom templating engine can’t make that in less than 16ms.

使得 React 应用迟缓的通常不是单个慢的组件（在火焰图中反映为一个大的区块）。**大多数时候，使 React 应用变慢的是许多组件无用的重绘。** 你也许曾读到，React 虚拟 DOM 超级快的言论。那是真的，但在一个中等规模的应用中，全量重绘容易造成成百上千的组件重绘。甚至最快的虚拟 DOM 模板引擎也不能使这一过程低于 16ms。

## Cutting Components To Optimize Them

## 切割组件即优化

Here is the `<Datagrid>` component `render()` method:

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

This seems like a very simple implementation of a datagrid, yet it is *very inefficient*. Each `<DatagridCell>` call renders at least two or three components. As you can see in the initial interface screencast, the list has 7 columns, 11 rows, that means 7x11x3 = 231 components rerended. When only the `currentSort` changes, it’s a waste of time. Even though React doesn’t update the real DOM if the rerendered VirtualDom is unchanged, it takes about 500ms to process all the components.

这看起来是一个非常简单的 datagrid 的实现，然而这 **非常低效**。每个 `<DatagridCell>` 调用会渲染至少两到三个组件。正如你在初次界面截图里看到的，这个表有 7 列，11 行，即 7*11*3 = 231 个组件会重新渲染。仅仅是 `currentSort` 的改变时，这简直是浪费时间。即使如果虚拟 DOM 没有更新，React 不更新真实的 DOM时，所有组件的处理也会耗费 500ms。

In order to avoid a useless rendering of the table body, I must first *extract* it:

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

I created a new `<DatagridBody>` component by extracting the table body logic:

在抽取表体逻辑之后，我创建了新的 `<DatagridBody>` 组件：

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

Extracting the table body has no effect on performance, but it reveals the path to optimization. Large, general purpose components are hard to optimize. Small, single-responsibility components are much easier to deal with.

抽取表体在性能上毫无作用，但它反映了一条优化之路。庞大的，通用的组件优化起来有难度。小的，单一职责的组件更容易处理。

## shouldComponentUpdate

## shouldComponentUpdate

The [React documentation](https://facebook.github.io/react/docs/react-component.html#shouldcomponentupdate) is very clear about the way to avoid useless rerenders: `shouldComponentUpdate()`. By default, React *always renders* a component to the virtual DOM. In other terms, it’s your job as a developer to check that the props of a component didn’t change and skip rendering altogether in that case.

[React 文档](https://facebook.github.io/react/docs/react-component.html#shouldcomponentupdate) 里对于避免无用的重绘有非常明确的方法：`shouldComponentUpdate()`。默认的，React **一直重绘** 组件到虚拟 DOM 中。换句话说，作为开发者，在那种情况下，检查 props 没有改变的组件和跳过绘制都是你的工作。

In the case of the `<DatagridBody>` component above, there should be no rerender of the body unless the props have changed.

以上述 `<DatagridBody>` 组件为例，除非 props 改变，否则 body 就不应该重绘。

So the component should be completed as follows:

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

**Tip**: Instead of implementing `shouldComponentUpdate()` manually, I could inherit from React’s `PureComponent` instead of `Component`. This would compare all props using strict equality (`===`) and rerender only if *any* of the props change. But I know that `resource` and `children` cannot change in that context, so I don’t need to check for their equality.

**小提示**：相比手工实现 `shouldComponentUpdate()` 方法，我可以继承 React 的 `PureComponent` 而不是 `Component`。这个组件会用严格对等（`===`）对比所有的 props，并且仅当 **任一** props 变更时重绘。但是我知道在例子的上下文中 `resource` 和 `children` 不不会变更，所以无需检查他们的对等性。

With this optimization, the rerendering of the `<Datagrid>` component after clicking on a table header skips the table body and its 231 components entirely. This reduces the update time from 500ms to 60ms. That’s a net performance improvement of more than 400ms!

有了这一优化，点击表头后，`<Datagrid>` 组件的重绘会跳过表体及其全部 231 个组件。这会将 500ms 的更新时间减少到 60ms。网络性能能有超过 400ms！

![Optimized flamegraph](https://marmelab.com/images/blog/optimized_flamegraph.png)

**Tip**: Don’t get fooled by the flamegraph width, it’s zoomed even more than the previous flamegraph. This one is definitely better!

**小提示**：别被火焰图的宽度骗了，比前一个火焰图而言，它放大了。这幅火焰图显示的性能绝对是最好的！

The `shouldComponentUpdate` optimization has removed a lot of pits in the graph, and reduced the overall rendering time. I can use the same trick to avoid even more rerenders (e.g. to avoid rendering the sidebar, the action buttons, the table headers that didn’t change, the pagination). After about an hour of work, the entire page renders just 100ms after clicking on a header column. That’s fast enough - even if there is still room for optimization.

`shouldComponentUpdate` 优化在图中去掉了许多凹坑，并减少了整体渲染时间。我会用同样的方法避免更多的重绘（例如：避免重绘 sidebar，操作按钮，没有变化的表头和页码）。一个小时的工作之后， 点击表头的列后，整个页面的渲染时间仅仅是 100ms。那相当快了 - 即使仍然存在优化空间。

Adding a `shouldComponentUpdate` method may seem cumbersome, but if you care about performance, most of the components you write should end up with one.

添加一个 `shouldComponentUpdate` 方法也许似乎很麻烦，但如果你真的在乎性能，你所写的大多数组件都应该加上。

Don’t do it everywhere - executing `shouldComponentUpdate` on simple components is sometimes slower than just rendering the component. Don’t do that too early in the life of an application either - this would be premature optimization. But as your apps grow, and you can detect performance bottlenecks in your components, add `shouldComponentUpdate` logic to remain fast.

别哪里都加上 `shouldComponentUpdate` - 在简单组件上执行 `shouldComponentUpdate` 方法有时比仅渲染组件要耗时。也别在应用的早期使用 - 这将过早地进行优化。但随着应用的壮大，你会发现组件上的性能瓶颈，此时才添加 `shouldComponentUpdate` 逻辑保持快速地运行。

## Recompose

## 重组

I’m not very happy with the previous change on `<DatagridBody>`: because of `shouldComponentUpdate`, I had to transform a simple, functional component to a class-based component. This adds more lines of code, and every line of code has a cost - to write, to debug, and to maintain.

我不是很满意之前在 `<DatagridBody>` 上的改造：为了使用 `shouldComponentUpdate`，我不得不改造成简单的基于类的函数式组件。这增加了许多行代码，每一行代码都要耗费精力 - 去写，调试和维护。

Fortunately, you can implement the `shouldComponentUpdate` logic in a higher-order component (HOC) thanks to [recompose](https://github.com/acdlite/recompose). It’s a functional utility belt for React, providing for instance the `pure()` HOC:

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

The only difference between this code and the initial implementation is the last line: I export `pure(DatagridBody)` instead of `DatagridBody`. `pure` is like `PureComponent`, but without the extra class boilerplate.

这段代码与上述的初始实现仅有的差异是：我导出了 `pure(DatagridBody)` 而非 `DatagridBody`。`pure` 就像 `PureComponent`，但是没有额外的类模板。

I can even be more specific and target only the props that I know may change, using recompose’s `shouldUpdate()` instead of `pure()`:

我甚至能够更加具体到目标，当我所了解的 props 也许会改变时，使用 recompose 的 `shouldUpdate()` 而不是 `pure()`：

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

The `checkPropsChange` function is pure, and I can even export it for unit tests.

`checkPropsChange` 是春函数，我甚至可以导出做单元测试。

The recompose library offers more performance HOCs, like `onlyUpdateForKeys()`, which does exactly the type of check I did in my own `checkPropsChange`:

recompose 库提供了更多 HOC 的性能优化方案，例如 `onlyUpdateForKeys()`，这个方法只会检查我在 `checkPropsChange` 中定义的类型是否改变。

```
// in DatagridBody.js
import React from 'react';
import onlyUpdateForKeys from 'recompose/onlyUpdateForKeys';

const DatagridBody = ({ resource, ids, data, children }) => (
    ...
);

export default onlyUpdateForKeys(['ids', 'data'])(DatagridBody);
```

I warmly recommend recompose. Beyond performance optimization, it helps you extract data fetching logic, HOC composition, and props manipulation in a functional and testable way.

强烈推荐 recompose 库，撇开性能优化不谈，它能帮助你以函数和可测的方式抽取数据获取逻辑，HOC 组合和进行 props 操作。

## Redux

## Redux

If you’re using [Redux](http://redux.js.org/) to manage application state (which I also recommend), then connected components are already pure. No need to add another HOC. Just remember that if only one of the props change, then the connected component rerenders - this includes all its children, too. So even if you use Redux for page components, you should use `pure()` or `shouldUpdate()` for components further down in the render tree.

如果你正在使用 [Redux](http://redux.js.org/) 管理应用 state （我也推荐这一方式），那么 connected 组件已经是纯组件了。不需要添加 HOC。只要记住一旦其中一个 props 改变了，connected 组件就会重绘 - 这也包括了所有子组件。所以甚至当你在页面组件上使用 Redux 时，你也应该在渲染树的深层用 `pure()` 或 `shouldUpdate()`。

Also, beware that Redux does the props comparison using strict equality. Since Redux connects the state to a component’s props, if you mutate an object in the state, Redux props comparison will miss it. That’s why you must use **immutability** in your reducers.

并且，当心 Redux 用严格模式对比 props。因为 Redux 将 state 绑定到组件的 props 上，如果你修改 state 上的一个对象，Redux 的 props 对比会错过它。这也是为什么你必须在 reducer 中用 **不可变性原则**

For instance, in admin-on-rest, clicking on a table header dispatches a `SET_SORT` action. The reducer listening to that action must pay attention to *replace* objects in the state, not *update* them:

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

With this reducer, when Redux checks for changes using triple equal, it finds that the state object is different, and rerenders the datagrid. But had we mutated the state, Redux would have missed the state change, and skipped rerendering by mistake:

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

To write immutable reducers, other developers like to use [immutable.js](https://facebook.github.io/immutable-js/), also from Facebook. I find it unnecessary, since ES6 destructuring makes it easy to selectively replace a component properties. Besides, Immutable is heavy (60kB), so think twice before you add it to your project dependencies.

为了不可变的 reducer，其他开发者喜欢用同样来自 Facebook 的 [immutable.js](https://facebook.github.io/immutable-js/)。我觉得这没必要，因为 ES6 解构赋值使得有选择地替换组件属性十分容易。另外，Immutable 也很笨重（60kB），所以在你的项目中添加它之前请三思。

## Reselect

## 重新选择

To prevent useless renders in (Redux) connected components, you must also make sure that the `mapStateToProps` function doesn’t return new objects each time it is called.

为了防止（Redux 中）无用的绘制 connected 组件，你必须确保 `mapStateToProps` 方法每次调用不会返回新的对象。

Take for instance the `<List>` component in admin-on-rest. It grabs the list of records for the current resource (e.g. posts, comments, etc) from the state using the following code:

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

The state contains an array of all the previously fetched records, indexed by resource. For instance, `state.admin.posts.data` contains the list of posts:

state 包含了一个数组，是上次获取的记录，以 resource 做索引。举例，`state.admin.posts.data` 包含了一系列帖子：

```
{
    23: { id: 23, title: "Hello, World", /* ... */ },
    45: { id: 45, title: "Lorem Ipsum", /* ... */ },
    67: { id: 67, title: "Sic dolor amet", /* ... */ },
}
```

The `mapStateToProps` function filters this state object to return only the records actually displayed in the list. Something like:

`mapStateToProps` 方法筛选 state 对象，只返回在 list 中展示的部分。如下所示：

```
{
    23: { id: 23, title: "Hello, World", /* ... */ },
    67: { id: 67, title: "Sic dolor amet", /* ... */ },
}
```

The problem is that each time `mapStateToProps` runs, it returns a new object, even if the underlying objects didn’t change. As a consequence, the `<List>` component rerenders every time something in the state changes - while id should only change if the date or ids change.

问题是每次 `mapStateToProps` 执行，它会返回一个新的对象，即使底层对象没有被改变。结果，`<List>` 组件每次都会重绘，即使只有 state 的一部分改变了 - date 或 ids 改变造成 id 改变。

[Reselect](https://github.com/reactjs/reselect) solves this problem by using memoization. Instead of computing the props directly in `mapStateToProps`, you use a *selector* from reselect, which returns the same output if the input didn’t change.

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

Now the `<List>` component will only rerender if a subset of the state changes.

现在 `<List>` 组件仅在 state 的子集改变时重绘。

As for recompose, reselect selectors are pure functions, easy to test and compose. It’s a great way to code your selectors for Redux connected components.

作为重组问题，reselect selector 是纯函数，易于测试和组合。它是为 Redux connected 组件编写 selector 的最佳方式。

## Beware of Object Literals in JSX

## 当心 JSX 中的对象文字

Once your components become more “pure”, you start detecting bad patterns that lead to useless rerenders. The most common is the usage of object literals in JSX, which I like to call “**The infamous {{**”. Let me give you an example:

当你的组件变得更 “纯” 时，你开始检测坏模式，这将导致无用重绘。最常见的是 JSX 中对象文字的使用，我更喜欢称之为 "**臭名昭著的双大括号**"。请允许我举例说明：

```
import React from 'react';
import MyTableComponent from './MyTableComponent';

const Datagrid = (props) => (
    <MyTableComponent style={{ marginTop: 10 }}>
        ...
    </MyTableComponent>
)
```

The `style` prop of the `<MyTableComponent>` component gets a new value every time the `<Datagrid>` component is rendered. So even if `<MyTableComponent>` is pure, it will be rendered every time `<Datagrid>` is rendered. In fact, each time you pass an object literal as prop to a child component, you break purity. The solution is simple:

每次 `<Datagrid>` 组件重绘，`<MyTableComponent>` 组件的 `style` 属性都会得到一个新值。所以即使 `<MyTableComponent>` 是纯的，每次 `<Datagrid>` 重绘时它也会跟着重绘。事实上，每次把对象文字当做属性值传递到子组件时，你就打破了纯函数。解法很简单：

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

This looks very basic, but I’ve seen this mistake so many times that I’ve developed a sense for detecting the infamous `{{` in JSX. I routinely replace it with constants.

这看起来很基础，但是我见过太多次这个错误，因而生成了检测臭名昭著的 `{{` 的敏锐直觉。我把他们一律替换成常量。

Another usual suspect for hijacking pure components is `React.cloneElement()`. If you pass a prop by value as second parameter, the cloned element will receive new props at every render.

另一个常用来劫持纯函数的 suspect 是 `React.cloneElement()`。如果你把 prop 值作为第二参数传入方法，每次渲染就会生成一个带新 props 的新 clone 组件。

```
// bad
const MyComponent = (props) => <div>{React.cloneElement(Foo, { bar: 1 })}</div>;

// good
const additionalProps = { bar: 1 };
const MyComponent = (props) => <div>{React.cloneElement(Foo, additionalProps)}</div>;
```
    
This has bitten me a couple times with [material-ui](http://www.material-ui.com/#/), for instance with the following code:

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

Although `<CreateButton>` is pure, it was rendered every time `<Toolbar>` was rendered. That’s because material-ui’s `<CardActions>` adds a special style to its first child to accommodate for margins - and it does so with an object literal. So `<CreateButton>` received a different `style` prop every time. I solved it using recompose’s `onlyUpdateForKeys()` HOC.

尽管 `<CreateButton>` 是纯函数，但每次 `<Toolbar>` 绘制它也会绘制。那是因为 material-ui 的 `<CardActions>` 添加了一个特殊 style，为了使第一个子节点适应 margin - 它用了一个对象文字来做这件事。所以 `<CreateButton>` 每次都收到不同的 `style` 属性。我用 recompose 的 `onlyUpdateForKeys()` HOC 解决了这个问题。

```
// in Toolbar.js
import onlyUpdateForKeys from 'recompose/onlyUpdateForKeys';

const Toolbar = ({ basePath, refresh }) => (
    ...
);

export default onlyUpdateForKeys(['basePath', 'refresh'])(Toolbar);
```

## Conclusion

## 结论

There are many other things you should do to keep your React app fast (using keys, lazy loading heavy routes, the `react-addons-perf` package, using ServiceWorkers to cache app state, going isomorphic, etc), but implementing `shouldComponentUpdate` correctly is the first step - and the most rewarding.

还有许多可以使 React 应用更快的方法（使用 keys，懒加载重路由，`react-addons-perf` 包，使用 ServiceWorkers 缓存应用状态，使用同构等等），但正确实现 `shouldComponentUpdate` 是第一步 - 也是最有用的。

React isn’t fast by default, but it offers all the tools to be fast whatever the size of the application. This may seem counterintuitive, especially since many frameworks offering an alternative to React claim themselves as n times faster. But React puts developer experience before performance. That’s the reason why developing large apps with React is such a pleasant experience, without bad surprises, and a constant implementation rate.

React 默认是不快的，但是无论是什么规模的应用，它都提供了许多工具来加速。这也许是违反直觉的，尤其自从许多框架提供了 React 的替代品，它们声称比 React 快 n 倍。但 React 把开发者的体验放在了性能之前。这也是为什么用 React 开发大型应用是个愉快的体验，没有差劲的惊喜，只有不变的实现速度。

Just remember to profile your app every once in a while, and dedicate some time to add a few `pure()` calls where it’s needed. Don’t do it first, or spend too much time to over optimize each and every component - except if you’re on mobile. And remember to test on various devices to get a good impression of your app’s responsiveness from a user’s point of view.

只要记住，每隔一段时间 profile 你的应用，让出一些时间在必要的地方添加一些 `pure()` 调用。别一开始就做优化，别花费过多时间在每个组件的过度优化上 - 除非你是在移动端。记住测试不同设备，从用户观点得到对你的应用响应式的良好印象。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
