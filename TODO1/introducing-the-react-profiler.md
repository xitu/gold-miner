> * 原文地址：[Introducing the React Profiler](https://reactjs.org/blog/2018/09/10/introducing-the-react-profiler.html)
> * 原文作者：[Brian Vaughn](https://github.com/bvaughn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-the-react-profiler.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-the-react-profiler.md)
> * 译者：
> * 校对者：

# Introducing the React Profiler

React 16.5 adds support for a new DevTools profiler plugin. This plugin uses React’s [experimental Profiler API](https://github.com/reactjs/rfcs/pull/51) to collect timing information about each component that’s rendered in order to identify performance bottlenecks in React applications. It will be fully compatible with our upcoming [time slicing and suspense](https://reactjs.org/blog/2018/03/01/sneak-peek-beyond-react-16.html) features.

This blog post covers the following topics:

*   [Profiling an application](#profiling-an-application)
*   [Reading performance data](#reading-performance-data)
    
    *   [Browsing commits](#browsing-commits)
    *   [Filtering commits](#filtering-commits)
    *   [Flame chart](#flame-chart)
    *   [Ranked chart](#ranked-chart)
    *   [Component chart](#component-chart)
    *   [Interactions](#interactions)
*   [Troubleshooting](#troubleshooting)
    
    *   [No profiling data has been recorded for the selected root](#no-profiling-data-has-been-recorded-for-the-selected-root)
    *   [No timing data to display for the selected commit](#no-timing-data-to-display-for-the-selected-commit)

## Profiling an application

DevTools will show a “Profiler” tab for applications that support the new profiling API:

 [![New DevTools ](/static/devtools-profiler-tab-4da6b55fc3c98de04c261cd902c14dc3-acf85.png)](/static/devtools-profiler-tab-4da6b55fc3c98de04c261cd902c14dc3-53c76.png) 

> Note:
> 
> `react-dom` 16.5+ supports profiling in DEV mode. A production profiling bundle is also available as `react-dom/profiling`. Read more about how to use this bundle at [fb.me/react-profiling](https://fb.me/react-profiling)

The “Profiler” panel will be empty initially. Click the record button to start profiling:

[![Click ](https://reactjs.org/static/start-profiling-bae8d10e17f06eeb8c512c91c0153cff-acf85.png)](https://reactjs.org/static/start-profiling-bae8d10e17f06eeb8c512c91c0153cff-53c76.png) 

Once you’ve started recording, DevTools will automatically collect performance information each time your application renders. Use your app as you normally would. When you are finished profiling, click the “Stop” button.

[![Click ](https://reactjs.org/static/stop-profiling-45619de03bed468869f7a0878f220586-acf85.png)](https://reactjs.org/static/stop-profiling-45619de03bed468869f7a0878f220586-53c76.png) 

Assuming your application rendered at least once while profiling, DevTools will show several ways to view the performance data. We’ll [take a look at each of these below](#reading-performance-data).

## Reading performance data

### Browsing commits

Conceptually, React does work in two phases:

*   The **render** phase determines what changes need to be made to e.g. the DOM. During this phase, React calls `render` and then compares the result to the previous render.
*   The **commit** phase is when React applies any changes. (In the case of React DOM, this is when React inserts, updates, and removes DOM nodes.) React also calls lifecycles like `componentDidMount` and `componentDidUpdate` during this phase.

The DevTools profiler groups performance info by commit. Commits are displayed in a bar chart near the top of the profiler:

[![Bar chart of profiled commits](https://reactjs.org/static/commit-selector-bd72dec045515d59be51c944e902d263-8ef72.png)](https://reactjs.org/static/commit-selector-bd72dec045515d59be51c944e902d263-8ef72.png) 

Each bar in the chart represents a single commit with the currently selected commit colored black. You can click on a bar (or the left/right arrow buttons) to select a different commit.

The color and height of each bar corresponds to how long that commit took to render. (Taller, yellow bars took longer than shorter, blue bars.)

### Filtering commits

The longer you profile, the more times your application will render. In some cases you may end up with _too many commits_ to easily process. The profiler offers a filtering mechanism to help with this. Use it to specify a threshold and the profiler will hide all commits that were _faster_ than that value.

![Filtering commits by time](https://reactjs.org/filtering-commits-683b9d860ef722e1505e5e629df7ef7e.gif)

### Flame chart

The flame chart view represents the state of your application for a particular commit. Each bar in the chart represents a React component (e.g. `App`, `Nav`). The size and color of the bar represents how long it took to render the component and its children. (The width of a bar represents how much time was spent _when the component last rendered_ and the color represents how much time was spent _as part of the current commit_.)

[![Example flame chart](https://reactjs.org/static/flame-chart-3046f500b9bfc052bde8b7b3b3cfc243-acf85.png)](https://reactjs.org/static/flame-chart-3046f500b9bfc052bde8b7b3b3cfc243-53c76.png) 

> Note:
> 
> The width of a bar indicates how long it took to render the component (and its children) when they last rendered. If the component did not re-render as part of this commit, the time represents a previous render. The wider a component is, the longer it took to render.
> 
> The color of a bar indicates how long the component (and its children) took to render in the selected commit. Yellow components took more time, blue components took less time, and gray components did not render at all during this commit.

For example, the commit shown above took a total of 18.4ms to render. The `Router` component was the “most expensive” to render (taking 18.4ms). Most of this time was due to two of its children, `Nav` (8.4ms) and `Route` (7.9ms). The rest of the time was divided between its remaining children or spent in the component’s own render method.

You can zoom in or out on a flame chart by clicking on components: ![Click on a component to zoom in or out](https://reactjs.org/zoom-in-and-out-39ba82394205242af7c37ccb3a631f4d.gif)

Clicking on a component will also select it and show information in the right side panel which includes its `props` and `state` at the time of this commit. You can drill into these to learn more about what the component actually rendered during the commit:

![Viewing a component's props and state for a commit](https://reactjs.org/props-and-state-1f4d023f1a0f281386625f28df87c78f.gif)

In some cases, selecting a component and stepping between commits may also provide a hint as to _why_ the component rendered:

![Seeing which values changed between commits](https://reactjs.org/see-which-props-changed-cc2a8b37bbce52c49a11c2f8e55dccbc.gif)

The above image shows that `state.scrollOffset` changed between commits. This is likely what caused the `List` component to re-render.

### Ranked chart

The ranked chart view represents a single commit. Each bar in the chart represents a React component (e.g. `App`, `Nav`). The chart is ordered so that the components which took the longest to render are at the top.

 [![Example ranked chart](https://reactjs.org/static/ranked-chart-0c81347535e28c9cdef0e94fab887b89-acf85.png)](https://reactjs.org/static/ranked-chart-0c81347535e28c9cdef0e94fab887b89-53c76.png) 

> Note:
> 
> A component’s render time includes the time spent rendering its children, so the components which took the longest to render are generally near the top of the tree.

As with the flame chart, you can zoom in or out on a ranked chart by clicking on components.

### Component chart

Sometimes it’s useful to see how many times a particular component rendered while you were profiling. The component chart provides this information in the form of a bar chart. Each bar in the chart represents a time when the component rendered. The color and height of each bar corresponds to how long the component took to render _relative to other components_ in a particular commit.

 [![Example component chart](https://reactjs.org/static/component-chart-d71275b42c6109e222fbb0932a0c8c09-acf85.png)](https://reactjs.org/static/component-chart-d71275b42c6109e222fbb0932a0c8c09-53c76.png) 

The chart above shows that the `List` component rendered 11 times. It also shows that each time it rendered, it was the most “expensive” component in the commit (meaning that it took the longest).

To view this chart, either double-click on a component _or_ select a component and click on the blue bar chart icon in the right detail pane. You can return to the previous chart by clicking the “x” button in the right detail pane. You can aso double click on a particular bar to view more information about that commit.

![How to view all renders for a specific component](https://reactjs.org/see-all-commits-for-a-fiber-99cb4321ded8eb0c21ae5fc673878563.gif)

If the selected component did not render at all during the profiling session, the following message will be shown:

[![No render times for the selected component](https://reactjs.org/static/no-render-times-for-selected-component-8eb0c37a13353ef5d9e61ae8fc040705-acf85.png)](https://reactjs.org/static/no-render-times-for-selected-component-8eb0c37a13353ef5d9e61ae8fc040705-53c76.png) 

### [](#interactions)Interactions

React recently added another [experimental API](https://fb.me/react-interaction-tracking) for tracking the _cause_ of an update. “Interactions” tracked with this API will also be shown in the profiler:

[![The interactions panel](https://reactjs.org/static/interactions-a91a39ac076b71aa7a202aaf46f8bd5a-acf85.png)](https://reactjs.org/static/interactions-a91a39ac076b71aa7a202aaf46f8bd5a-53c76.png) 

The image above shows a profiling session that tracked four interactions. Each row represents an interaction that was tracked. The colored dots along the row represent commits that were related to that interaction.

You can also see which interactions were tracked for a particular commit from the flame chart and ranked chart views as well:

[![List of interactions for a commit](https://reactjs.org/static/interactions-for-commit-9847e78f930cb7cf2b0f9682853a5dbc-acf85.png)](https://reactjs.org/static/interactions-for-commit-9847e78f930cb7cf2b0f9682853a5dbc-53c76.png) 

You can navigate between interactions and commits by clicking on them:

![Navigate between interactions and commits](https://reactjs.org/navigate-between-interactions-and-commits-7c66e7686b5242473c87b3d0b4576cf3.gif)

The tracking API is still new and we will cover it in more detail in a future blog post.

## Troubleshooting

### No profiling data has been recorded for the selected root

If your your application has multiple “roots”, you may see the following message after profiling: [![No profiling data has been recorded for the selected root](https://reactjs.org/static/no-profiler-data-multi-root-0755492a211f5bbb775285c0ff2fdfda-acf85.png)](https://reactjs.org/static/no-profiler-data-multi-root-0755492a211f5bbb775285c0ff2fdfda-53c76.png) 

This message indicates that no performance data was recorded for the root that’s selected in the “Elements” panel. In this case, try selecting a different root in that panel to view profiling information for that root:

![Select a root in the "Elements" panel to view its performance data](https://reactjs.org/select-a-root-to-view-profiling-data-bdc30593d414b5c8d2ae92027ed11940.gif)

### No timing data to display for the selected commit

Sometimes a commit may be so fast that `performance.now()` doesn’t give DevTools any meaningful timing information. In this case, the following message will be shown:

 [![No timing data to display for the selected commit](https://reactjs.org/static/no-timing-data-for-commit-63b2fb6298feecb179272c467020ed95-acf85.png)](https://reactjs.org/static/no-timing-data-for-commit-63b2fb6298feecb179272c467020ed95-53c76.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
