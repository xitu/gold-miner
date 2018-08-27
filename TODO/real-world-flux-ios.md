> * 原文链接 : [real-world-flux-ios](http://blog.benjamin-encz.de/post/real-world-flux-ios/)
> * 原文作者 : [Benjamin Encz](http://blog.benjamin-encz.de/about)
> * 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者 : [Nicolas(Yifei) Li](https://github.com/yifili09) 
> * 校对者: [rccoder](https://github.com/rccoder), [Gran](https://github.com/Graning)

# iOS 开发中的 Flux 架构模式

在半年前，我开始在 `PlanGrid` iOS 应用程序中采用 `Flux` 架构（开发）。这篇文章将会讨论我们从传统的 `MVC` 转换到 `Flux`的动机，同时分享我们目前积累到的经验。

我尝试通过讨论代码来描述我们大部分的 `Flux` 实现， 它用于我们今天的产品中。 如果你只对综合结果感兴趣， 请跳过这篇文章的中间部分。

## 为什么从 `MVC` 转移

为了引入我们的决定， 我想要先谈一谈 `PlanGrid` 这个应用遇到的一些挑战。一些问题仅针对企业级应用程序，其他应该适用于大部分的 `iOS` 应用程序。

### 我们有所有的状态

`PlanGrid` 是一个相当复杂的 `iOS` 应用程序。它允许用户能看到（设计）蓝图并且可以使用不同类型的（标记) 注释，问题和附件（和很多其他特定工业需要的知识）。

一个重要的方面是， 这个应用程序（可以）先离线使用。无论是否有英特网连接，用户可以使用所有应用程序提供的特性。这意味着我们需要在客户端存储许多数据和状态。我们也需要实施一些本地的业务规则（例如，一个注释是否可以被用户删除？）。 

`PlanGrid` 可以在 `iPad` 和 `iPhone` 平台上运行，但他的 `UI` 被优化过，可以充分使用平板的屏幕。这意味着不像其他 `iPhone` 应用程序，我们常常同时展现多个视图控制器。这些视图控制器常常（互相）共享着相当多的状态。

### 状态管理器

所有的这些意味着，我们的应用程序花在状态管理上费了很多努力。任何应用程序结果的变化或多或少都和以下几点相关：

1. 更新本地对象的状态。
2. 更新 `UI`。
3. 更新数据库。
4. 用队列保存变化，它将在有网络连接的情况下发送给服务器。
5. **当状态改变时，通知其他对象**

尽管我计划在之后的文章中（更新）包含我们新架构中其他的部分，我今天想把精力集中在第5个\. _我们怎么在应用程序中构成状态更新（机制）？_ 

这是我们应用程序开发中至关重要的问题（价值十亿美元 :moneybag:）。

大多数 `iOS` 的工程师，包括 `PlanGrid` 应用程序早些时候的开发者们，想出了以下答案： 

* 代理机制 (`Delegation`)
* 键值观察策略 （`KVO`）
* 通知中心 （`NSNotificationCenter`）
* 回调代码块 （`Callback Blocks`）
* 使用数据库作为来源 （`Using the DB as source of truth`）

所有这些实现都在不同的情况下有效。然而，这些不同的操作是来源于很多在由发展多年以来的很大的代码库中的不一致。

### 自由是危险的

经典的 `MVC` 只提倡分离数据和它的展示层。在缺少其他结构性的指导下，剩下的东西都由个别开发者们决定。

很长一段时间 `PlanGrid` 应用程序（像其他 `iOS` 应用程序）都没有一个定义好的模式去管理状态。

很多现存的状态管理工具，例如 `delegation` 和 `blocks` 常常去在组件中创建强连接（依赖），这并不令人满意 - 两个视图控制器迅速变得强耦合，在尝试互相分享更新的状态时。

其他工具，例如，`KVO` 和 `通知`， 创建无形的（程序）依赖。将他们使用在大型的代码库中，会迅速导致代码的变化，引起不可预期的副作用。对于一个控制器来说，想观察到那些本不需要关心的数据模型层的细节实在是太容易了。

完整的代码审阅和样式指导的作用有限，许多架构上的问题都从很小的不一致性开始并且花很长的时间扩展到许多严重的问题。使用意义清晰明确的模式替换，这将会很容易尽早发现差异。

### 状态管理的一种架构的模式

在重构 `PlanGrid` 应用程序期间，我们最重要的目标是，采用一个清晰的模式和（创造）最佳实现方式。这样允许未来的新特性能以更加一致的方式写入代码库，也让更多新进的工程师提高工作效率。

在我们的应用程序中，状态管理是复杂度比较大的代码源之一，所以我们决定去定义一个模式，所有新的特性都会按照这个模式更好的前进。

在遭遇了很多我们代码中的痛苦后，更加让我们相信，那些 `Facebook` (脸书) 在第一次提出 `Flux` 模式是偶提出的问题：

* 不可预见性，联级状态更新
* 很难在（多个）组件中明白（互相）依赖关系
* 复杂的信息流程
* 不清晰的真实来源

看上去 `Flux` 将会非常适合解决很多我们现在遇到的问题。

## `Flux` 的简单概要

`Flux` 是一个轻量级的架构的模式，它被 `Facebook` (脸书) 用在客户端的网页应用程序中。虽然有一个 [参考的演示程序](https://github.com/facebook/flux)，`Facebook` (脸书) 强调说，`Flux` 模式的想法有比这个单独实现更多的想法（内容）。

这个模式能被下图很好的诠释，它展示了不同的 `Flux` 组件：

![](https://raw.githubusercontent.com/Ben-G/Website/master/static/assets/flux-post/Flux_Original.png)

在 `Flux` 架构中，`store` 是应用程序某一个部分的单一真实来源。无论 `store` 中的状态何时更新，它都将发送一个变更事件给所有订阅这个 `store` （通知/消息）的视图。

状态更新（事件）只会通过 `actions` 产生。

一个 `action` 描述了一个预期的状态的变化，但它不自己实现状态的改变。所有想要改变状态的组件，都要发送一个 `action` 给全局的 `dispatcher`。每当一个 `action` 被分发，所有有关系的 `store` 都会收到它。

作为对 `actions` 的响应，`stores` 会更新他们的状态并且通知和这些视图有关这个新的状态。

在上图显示了，`Flux` 架构实施的一个单向的数据流。它对以下几个点严格区分：

* 视图只会从 `stores` 接收数据。每当 `store` 更新的时候，在视图上的处理方法会被调用。
* 视图只会通过分发的 `actions` 改变状态。 因为 `actions` 只描述意图，业务逻辑从视图里隐去了。
* `store` 只会更新它的状态，当它接收到 `action`的时候。

这些限制使得设计，开发和调试一些新的特性变得更加容易。

## `Flux` 在 `PlanGrid iOS` 中的使用

我们在 `PlanGrid iOS` 应用程序上的实现和 `Flux` （官方提供的）参考程序有些不同。我们为每一个 `store` 实施了一个看得见的 `state` 属性。不像原生的 `Flux` 实现方式，当 `store` 有更新的时候，我们不发送变更通知。而是视图观察 `store` 中的 `state` 属性。每当视图观察到 `state` 属性有变化，他们按照下图响应（变化）:

![](https://raw.githubusercontent.com/Ben-G/Website/master/static/assets/flux-post/Flux.png)

对于 `Flux` 参考程序仅有细微的差别，但是提到这个有助于下来部分（的理解）。

有了对 `Flux` 架构的基本认识，让我们看看更多实现的细节，和一些当在 `PlanGrid` 应用程序中实现 `Flux` 架构，我们需要去回答的问题。

### 什么是 `Store` 的作用域？

（去定义）每一个 `store` 的作用域是一个非常又去的问题，每当使用 `Flux` 模式的时候会经常发生。

由于 `Facebook` (脸书) 发布了 `Flux` 模式，不同的社区开发出了不同的版本。有一个叫做 `Redux`，通过迭代 `Flux` 实施了每一个应用程序应该只有一个 `store`。这个 `store` 存储了整个应用程序的状态（有很多其他，细微，不同的其他作用域的文章。）

`Redux` 很受大众欢迎，因为这个单个 `store` 的实现方式将大大简化很多应用程序的架构。在传统的　`Flux`，有多个 `stores`，应用程序将会遭遇这个情况，当他们需要结合的状态，它被存储在了一个其他的 `store`中，为了去渲染某一个视图。这个实现常常重现 `Flux` 模式尝试去解决的问题，例如在应用程序中多个组件的复杂依赖。

对　`PlanGird`　来说，我们决定使用传统 `Flux`　而非使用 `Redux`。我们不确定怎么将单个 `store`　存储整个应用程序的状态实现到这个庞大的应用程序中。未来，我们认为，我们将使用非常少的内部存储依赖，让 `Redux` 作为一个可选项来说变得不那么重要了。　　

**我们已经总结出一个硬性规定有关单独 `store` 的作用域。**

目前，在我们的代码库中，我能识别出的两个模式:

* **特性／视图特定的存储:** 每一个视图控制器（或者每一个相关联的视图控制器）收到它自己的 `store`。这个 `store`　模仿了视图独特的状态。　
* **共享状态的 `stores`:** 我们有 `stores`　存储和管理状态，被很多视图共享。我们尝试保持这些 `stores`　很小的数量。`IssueStore`　就是一个这样的一个 `store`。它负责管理所有问题，在当前选中的设计蓝图中可见的状态。这些形式的 `stores` 本质上来说一个实时更新的数据库查询。

我们目前在实现我们第一个_共享形状态 stores_ 的过程中，并且正在决定基于这些 `stores` 类型，模拟不同视图依赖最好的方式。

### 使用 `Flux` 模式实现一个特性

让我们深入观察下构成 `Flux`　模式特性的细节。

作为贯穿下几个部分的例子，我们将使用 `PlanGrid`　应用程序产品中的一个特性。这个特性允许用户过滤设计蓝图中的注释: 

![](https://raw.githubusercontent.com/Ben-G/Website/master/static/assets/flux-post/filter_screenshot.png)

我们讨论的特性是截图上左边展示出的弹出框。

#### 第一步：　定义状态

一般来说，我实现一个特性，都由通过决定与其相关的状态开始。这个状态展示了 `UI` 需要了解的所有东西，为了渲染某一个特性。

让我们深入我们的例子，看看过滤注释特性的状态


```
    struct AnnotationFilterState {
      let hideEverythingFilter: RepresentableAnnotationFilter
      let shareStatusFilters: [RepresentableAnnotationFilter]
      let issueFilters: [RepresentableAnnotationFilter]
      let generalFilters: [RepresentableAnnotationFilter]

      var selectedFilterGroup: AnnotationFilterGroupType? = nil
      /// Indicates whether any filter is active right now
      var isFiltering: Bool = false
    }
```


这个状态有一揽子的过滤器, 一个当前选择的过滤器组和一个布尔值标记，显示了过滤器是否是活动的。

这个状态为 `UI` 需求定做。这一揽子过滤器用表视图渲染。这个被选择的过滤器组用于显示／隐藏每一个单独的过滤器组的细节。`isFiltering`标记被用于决定去消除所有过滤器的按钮是否被在 `UI` 中启用和关闭。

#### 第二步: 定义 `Actions`

在决定了某一个特性状态的模型之后，我常常在下一步考虑不同的状态变换。在 `Flux` 架构中，状态的变换以 `actions` 形式模拟，描述了什么样的改变是预期的。对于注释过滤器特性，这一揽子 `actions` 很段:


```
    struct AnnotationFilteringActions {

      /// Enables/disables a filter.
      struct ToggleFilterAction: AnyAction {
        let filter: AnnotationFilterType
      }

      /// Navigates to details of a filter group.
      struct EnterFilterGroup: AnyAction {
        let filterGroup: AnnotationFilterGroupType
      }

      /// Leaves detail view of a filter group.
      struct LeaveFilterGroup: AnyAction { }

      /// Disables all filters.
      struct ResetFilters: AnyAction { }

      /// Disables all filters within a filter group.
      struct ResetFiltersInGroup: AnyAction {
        let filterGroup: AnnotationFilterGroupType
      }
    }
```


甚至没有一个对这个特性深入认识，它也是能被理解的，状态由 `action` 来转换。众多 `Flux` 架构中的一个好处是，这个 `actions` 的列表是一个所有状态改变的全方位的概述，它能被触发用于这个特别的特性。

#### 第三步: 在 `store` 中实现对 `Actions` 的响应

我们在这一步中实现这个特性的核心业务逻辑。我个人想使用 `TDD` 开发方式，我将在之后讨论。这个 `store` 能用以下内容总结:

1. 用 `dispatcher` 注册对所有 `actions`　感兴趣的 `store`。当前的例子中，它是所有的 `AnnotationFilteringActions`。
2. 实现一个处理函数，它将被每一个单独的 `actions` 调用。
3. 在这个处理函数中，执行必要的业务逻辑和在完成后更新状态。

最为一个例子，我们能看一下 `AnnotationFilterStore`　怎么处理 `toggleFilterAction`。

```
    func handleToggleFilterAction(toggleFilterAction: AnnotationFilteringActions.ToggleFilterAction) {
      var filter = toggleFilterAction.filter
      filter.enabled = !filter.enabled

      // Check for issue specific filters
      if filter is IssueAssignedToFilter ||
        filter is IssueStatusAnnotationFilter ||
        filter is IssueAssignedToFilter ||
        filter is IssueUnassignedFilter {
          // if no annotation types are filtered, activate the issue/punchItem type
          var issueTypeFilter = self._annotationFilterService.annotationTypeFilterGroup.issueTypeFilter
          if self._annotationFilterService.annotationTypeFilterGroup.activeFilterCount() == 0 ||
              issueTypeFilter?.enabled == false {
                issueTypeFilter?.enabled = true
          }
      }

      self._applyFilter()
    }
```

这个例子并不是那么简单。所以让我们一点一点分解。每当 `ToggleFilterAction` 被分发的时候，`handleToggleFilterAction` 就被调用。`ToggleFilterAction`　携带了哪个具体的过滤器需要被切换的消息。

作为一个实现这个业务逻辑的开端，这个方法简单地通过切换 `filter.enabled`　这个值来切换过滤器。

之后，我们对这个特性，实现了一些定制化的业务逻辑。当配合使用那些过滤有问题的注释的过滤器的时候，我们需要去激活 `issueTypeFilter`。没有必要深入讨论这个 `PlanGrid` 特有的特性，但是这个方法封装了一些和开关触发器有关的业务逻辑。

在这个方法的结尾，我们调用 `_applyFilter()` 方法。这是一个共享方法，它被很多 `action`　处理函数中使用:

```
  func _applyFilter() {
    self._annotationFilterService.applyFilter()

    self._state.value?.isFiltering = self._annotationFilterService.allFilterGroups.reduce(false) { isFiltering, filterGroup in
      isFiltering || (filterGroup.activeFilterCount() > 0)
    }

    // Phantom state update to refresh the cell state, technically not needed since filters are reference types
    // and previous statement already triggers a state update.
    self._state.value = self._state.value
  }
```

调用 `self._annotationFilterService.applyFilter()` 真正触发了注释过滤器在页面上显示。过滤器的逻辑本身是有点复杂的，所以把它移动一个独立的，专门的类型中。 

每一个 `store`　的角色是提供状态信息，它与相关的 `UI` 和成为关联点为了状态的更新。这并不意味着整个业务逻辑需要被实现在 `store` 本身。

每一个 `action` 处理函数最后一步是更新状态。在 `_applyFilter()` 方法中，我们正在更新 `isFiltering` 状态值通过检查是否任何过滤器正在被激活。
 
还有一个需要注意的事情是有关这个特别的 `store`: 你可能期望看到一个外部的状态更新，去更新过滤器的值，它存储在 `AnnotationFilterState`。一般来说，这是我们如何去实现我们的 `stores`的方式，但是这个实现方式有一点特别。

由于存在 `AnnotationFilterState` 中的过滤器需要与很多现存的 `Objective-C` 代码交互，我们决定将他们模型成类。这意味着他们是引用类型并且 `store` 和注释过滤器 `UI` 共享一个对同一个实例的引用。反过来意味着在`store`内所有发生在过滤器上的变化，也对 `UI` 是可见的。一般来说，我们尝试避免这个，通过只在我们的状态结构中使用值类型 - 但是这篇文章是有关真实世界的 `Flux`　并且在这个特别的例子中，为了让 `Objective-C`　交互更容易被接受而妥协。

如果过滤器是值类型，我们需要对更新过的过滤器的值赋值到我们的状态属性，为了让 `UI` 观察到这个变化。由于我们在这里使用了引用类型，我们执行一个幽灵状态更新：


```
  // Phantom state update to refresh the cell state, technically not needed since filters are reference types
  // and previous statement already triggers a state update.
  self._state.value = self._state.value
```


这个对 `_state`　属性赋值的任务将会开启更新 `UI` 的策略 - 一会我们将讨论这个过程的细节。

我们已经深入足够了解实现的细节了，所以我想暂告这一个部分，并提醒有关高层次 `store`　的责任:

1. 用 `dispatcher` 注册 `store`，对所有 `actions` 感兴趣的。在当前的例子中，它就是 `AnnotationFilterActions`。
2. 实现一个处理函数，它将会被每个单独的 `actions` 调用。
3. 在这个处理函数中，执行必要的业务逻辑并且在完成后更新状态。

让我们移步到讨论 `UI`　怎么接收到来自　`store`　的状态更新。

#### 第四步: 将 `UI` 绑定到 `Store` 

每当一个状态更新（的事件）发生， 自动更新 `UI` 的机制就被触发, 这是 `Flux` 的一个核心理念。它保证了 `UI` 始终显示最新的状态，并且可以摆脱一直需要（手动地）维护这些代码的工作。这一步类似于在 `MVVM` 架构中，将一个视图绑定到 `ViewModel`。

有很多中方式实现这个 - 我们决定在 `PlanGrid`中，使用 `ReactiveCocoa` 使得 `store` 提供一个可见的 `state` 属性。下面就是 `AnnotationFilterStore`　怎么去实现这个模式的方法:


```
  /// The current `AnnotationFilterState`, this should be observed within the view layer.
  let state: SignalProducer<AnnotationFilterState?, NoError>
  /// Internal state.
  let _state: MutableProperty<AnnotationFilterState?> = MutableProperty(nil)
```

`_state` 属性被用于在 `store` 内改变状态。`state`　属性被客户端使用于订阅 `store` 的消息。这允许 `store`　信息的订阅者们接收到状态的更新，但是并不允许他们直接改变状态。(状态的改变只能通过 `actions` 发生!)。

在初始化中，内部可被观察的属性仅仅简单的绑定到外部信号发生器:



```
  self.state = self._state.producer
```


现在，任何 `_state` 的更新将会自动将最新的状态值通过信号发生器发送给并且存储在 `state`　中。

仅剩下的就是通过代码确认，每当一个新的 `state`　值被发出，`UI` 都更新了。这算得上当开始在 `iOS` 上使用 `Flux` 模式最复杂的部分之一了。在网页上，`Flux` 能很好的和 `Facebook` (脸书) 的 `React` 框架配合。`Recat`　是为处理以下特性场景而设计的:

当配合 `UIKit` 时，我们没有这个至宝，相反我们需要自己手工实现 `UI` 的更新。我不能在这篇文章里深入讨论这个实现的细节，否则这篇文章将会太冗长。我们的底线是为 `UITableView` 和 `UICollectionView`　创建一些类似于 `React API` 提供的调用接口，我们将在之后的文章里提到他们。

如果你想要学习更多这些组件的内容，你可以去看 [我最近提到的](https://skillsmatter.com/skillscasts/8179-turning-uikit-inside-out)，也可以看看这两个 `GitHub` 代码库( [`AutoTable`](https://github.com/Ben-G/AutoTable), [`UILib`](https://github.com/Ben-G/UILib))。

让我们再看看实际的代码 (我们摘选了部分代码)，从注释过滤器这个特性中。这段代码存在于 `AnnotationFilterViewController` 中:


```
  func _bind(compositeDisposable: CompositeDisposable) {
    // On every state update, recalculate the cells for this table view and provide them to
    // the data source.
    compositeDisposable += self.tableViewDataSource.tableViewModel  self.store.state
      .ignoreNil()
      .map { [weak self] in
        self?.annotationFilterViewProvider.tableViewModelForState($0)
      }
      .on(event: { [weak self] _ in
        self?.tableViewDataSource.refreshViews()
      })

  compositeDisposable += self.store.state
      .ignoreNil()
      .take(1)
      .startWithNext { [weak self] _ in
        self?.tableView.reloadData()
      }

   compositeDisposable += self.navigationItem.rightBarButtonItem!.racEnabled  self.store.state
      .map { $0?.isFiltering ?? false }
  }
```


我们在代码库中遵循着一个准则，每一个视图控制器都有一个 `_bind`　方法，它被 `viewWillAppear` 调用。这个 `_bind` 方法负责订阅 `store` 的状态并且提供当状态变化发生时候，提供更新 `UI` 的代码。

由于我们需要我们自己实现部分 `UI` 更新的代码并且不能依靠类似 `React` 的框架，这个方法，一般来说，需要包含描述一个特定的状态更新如何映射到 `UI` 更新的代码。`ReactiveCocoa` 是非常便利的，因为它提供了很多操作 (`skipUntil`，`take`，`map`，其他。)，很容易就能创建这些关系。如果你之前没有使用过 `Reactive` 的库，这些代码可能会让你感到困惑 - 这一小部分的 `ReactiveCocoa` 代码学起来很快。

在例子中的第一行 `_bind` 方法确保了，每当一个状态发生更新的时候，表视图能获得这个更新。我们使用 `ReactiveCocoa` 中 `ignoreNil()` 操作符，来确保我们不会为一个空状态启动了更新。之后，我们使用 `map` 操作符将最新的状态从 `store` 中映射到表述图应该变成什么样的描述符。

这个映射通过 `annotationFilterViewProvider.tableViewModelForState` 方法发生。这也是我们自定义的类似 `React` 的 `UIKit` 包装器参与作用的地方。

我不会深入讨论所有的实现细节，但是 `tableViewModelForState` 方法看上去是这样的:


```
    func tableViewModelForState(state: AnnotationFilterState) -> FluxTableViewModel {

      let hideEverythingSection = FluxTableViewModel.SectionModel(
        headerTitle: nil,
        headerHeight: nil,
        cellViewModels: AnnotationFilterViewProvider.cellViewModelsForGroup([state.hideEverythingFilter])
      )

      let shareStatusSection = FluxTableViewModel.SectionModel(
        headerTitle: "annotation_filters.share_status_section.title".translate(),
        headerHeight: 28,o
        cellViewModels: AnnotationFilterViewProvider.cellViewModelsForGroup(state.shareStatusFilters)
      )

      let issueFilterSection = FluxTableViewModel.SectionModel(
        headerTitle: "annotation_filters.issues_section.title".translate(),
        headerHeight: 28,
        cellViewModels: AnnotationFilterViewProvider.cellViewModelsForGroup(state.issueFilters)
      )

      let generalFilterSection = FluxTableViewModel.SectionModel(
        headerTitle: "annotation_filters.general_section.title".translate(),
        headerHeight: 28,
        cellViewModels: AnnotationFilterViewProvider.cellViewModelsForGroup(state.generalFilters)
      )

      return FluxTableViewModel(sectionModels: [
        hideEverythingSection,
        shareStatusSection,
        issueFilterSection,
        generalFilterSection
      ])
    }
```


`tableViewModelForState` 是一个接收最新状态作为它的输入并且返回一个表视图的描述符，以 `FluxTableViewModel` 的形式。这个方法的实现想法类似于 `React` 的渲染方法。`FluxTableViewModel` 完全独立于 `UIKit`，它也是描述表格内容的一个简单的结构。你能在开源的 [AutoTable 代码库](https://github.com/Ben-G/AutoTable/blob/master/AutoTable/AutoTable/TableViewModel.swift) 中发现这个实现。

这个方法的结果，之后绑定到视图控制器的 `tableViewDataSource` 属性。存储在这个属性中的组件，会负责基于 `FluxTableViewModel` 提供的信息来更新 `UITableView`。

其他的绑定代码会比较容易，比如，负责基于 `isFiltering` 状态来开启/关闭 `Clear Filter` 的按钮。


```
    compositeDisposable += self.navigationItem.rightBarButtonItem!.racEnabled  self.store.state
      .map { $0?.isFiltering ?? false }
```


实现 `UI` 绑定的过程是比较复杂的部分之一，由于它不能与 `UIKit` 的编程模型完美配合。但它只需要花一点精力写出一些自定义的组件，就能简单些。从我们的经验来看，我们通过实现这些自定义组件节省了很多研发时间，而不是一定要保持经典的 `MVC` 实现方式，在那些在多个视图控制器需要重复实现 `UI` 更新的地方。 

有了这些 `UI` 的绑定方法，我们讨论实现 `Flux` 特性的最后一个部分。由于我们已经掌握了很多内容，我想要快速回顾下之前的内容，在我们继续讨论如何测试这些 `Flux` 特性之前。

#### 回顾

当实现一个 `Flux` 模式特性的时候，我们需要将工作分为以下几个部分:

1. 定义状态类型的形状。
2. 定义 `actions`。
3. 实现业务逻辑和针对每个 `action` 状态的转变 - 这个实现在 `store` 中。
4. 实现 `UI` 绑定方法，将状态映射到视图展示层。

这些已经包括了所有我们讨论过的有关实现的细节。

让我们继续讨论如何测试 `Flux` 特性。

### 撰写测试

有一个 `Flux` 主要的好处是，它把有关的内容严格的区分开。这让测试业务逻辑和大块的 `UI` 代码变得非常容易。

每一个 `Flux` 特性都有两个重要的区域需要被测试:

1. 在 `store` 中的业务逻辑
2. 视图模型的提供者 （就是那些我们实现的类似 `React` 的方法，他们基于输入的状态描述了 `UI`。）

#### 测试 `stores`

测试 `stores` 很简单。我们能通过插入 `actions` 到 `stores` 驱动交互，并且我们能通过订阅 `store` 或者观察在我们测试用的内部 `_state` 属性来观察状态的变化。 

另外，我们能模拟其他外部的类型，那些,`store` 可能需要去交互的内容，为了实现某一个特性(可能是一个 `API` 的客户端或者数据对象)并且在 `store` 的初始化器中注入这些。这允许我们去验证，那些类型是否被如期调用。 

在 `PlanGrid`中，我们使用 `Quick` 和 `Nimble` 以反应样式来写测试代码。以下是一个简单的例子，来自于注释过滤器，保存某一个 `action`:


```
    describe("toggling a filter") {

      var hideAllFilter: AnnotationFilterType!

      beforeEach {
        hideAllFilter = annotationFilterService.hideAllFilterGroup.filters[0]
        let toggleFilterAction = AnnotationFilteringActions.ToggleFilterAction(filter: hideAllFilter)
        annotationFilterStore._handleActions(toggleFilterAction)
      }

      it("toggles the selected filter") {
        expect(hideAllFilter.enabled).to(beTrue())
      }

      it("enables filtering mode") {
        expect(annotationFilterStore._state.value?.isFiltering).to(beTrue())
      }

      context("when subsequently resetting filters") {

        beforeEach {
          annotationFilterStore._handleActions(AnnotationFilteringActions.ResetFilters())
        }

        it("deactivates previously active filters and stops filter mode") {
          expect(hideAllFilter.enabled).to(beFalse())
          expect(annotationFilterStore._state.value?.isFiltering).to(beFalse())
        }

      }
  }
```

再一次强调，有关测试 `stores` 将会被放在其他文章里，所以我们也不会深入讨论过多细节。然而，测试的方式已经很清楚了。我们把 `actions` 发送给 `store`并且验证响应，以改变状态或者模拟注入代码的形式。

（你会对为什么我们在 `store` 中调用 `_handleActions`，而非使用 `dispatcher` 来分配感到好奇。起初，我们使用异步 `dispatcher`，当有 `actions` 需要被分配时，这也意味着我们的测试方法也需要是异步调用的。因此，我们直接在 `store` 中直接调用处理函数。因此，这个 `dispatcher` 的实现方式也变了，所以我们在我们的测试中使用 `dispatcher`。 ）

当实现 `store` 中的业务逻辑的时候，我总会先写我的测试代码。我们的代码结构能很好的配合 `TDD` 开发过程。

#### 测试视图

`Flux` 架构结合我们申明的 `UI` 层能让测试视图变得非常容易。我们也一直在内部讨论有关我们想要覆盖(测试)多少的视图的话题。

实际上，所有我们的视图代码都是相当清晰的。它绑定了在 `store` 中的状态到我们不同 `UI` 层的属性上。对于我们的应用程序，我们决定通过 `UI` 自动测试机制来覆盖我大部分的代码。

然而，也有很多其他选择。由于视图层被设定去渲染一个注入的状态，快照测试也工作得非常好。有很多快照测试的讨论和文章，[包括一个非常好的在 `objc.io` 上的文章](https://www.objc.io/issues/15-testing/snapshot-testing/)。

对于我们的应用程序，我们的 `UI` 自动测试已经足够了，所以我们不需要其他的快照测试。

我们也尝试使用单元测试在我们的视图方法上（例如，早些时候我们看到的 `tableViewModelForState` 方法）。这些视图提供者，映射一个状态到 `UI` 描述符，所以他们能基于输入和返回值被很容易的测试，我发现，这些测试并不能增加很多价值，因为他们仅仅是复制了申明过的实现了的描述符。）

使用 `Flux` 架构在视图测试熵变得非常简单，因为视图的代码独立于其他的应用程序的实现。你只需要注入一些状态，他们应该被反映在你的测试中，并且他们处理的很好。

就如我们所见，的确有很多其他的方法可以测试 `UI`,我对我们（其他开发者），从长远来看，会选择哪一个很感兴趣。

## 总结

在我们深入讨论了那么多的实现细节之后，我想总结下目前我们的经验和教训。

我们只使用了 `Flux` 架构 6 个月左右，但是我们已经能看到很多给我们代码库带来的好处:

* 新的特性能被一致性的实现。贯穿于多个特性间的，`stores` , 视图提供者和视图控制器的结构几乎保持一致（完全相同）。
* 通过监视状态，`actions` 和 `TDD` 的测试框架，几分钟之内，就能很容易的理解，某一个特性是怎么工作得。
* 我们很好的分离了 `stores` 和视图之间的关系。对于某个代码是否应该存在没有模糊的界定。
* 我们的代码阅读起来很简单。状态和视图之间的以来关系总是非常明确。这也让调试工作轻松愉快。
* 所有以上的优点，都让新来的开发者门更容易上手工做。

显而易见，我们也遇到了一些**痛点**:

* 首先，集成 `UIKit` 组件有一点麻烦。不像 `React` 组件， `UIKit` 视图不提供 `API` 基于一个新的状态容易的更新自己。这部分的工作完全依赖与我们自己，我们需要实现手动绑定视图的工作或者自定义的组件，对 `UIKit` 二次开发。
* 并不是所有我们的新代码都严格遵守了 `Flux` 模式。例如，我们还没有解决实现能与 `Flux` 配合工作的导航/路由系统。我们需要集成一个 [坐标模式](http://khanluo.com/2015/10/coordinators-redux/) 进入我们的 `Flux` 架构，或者使用一个与 [ReSwift 路由器](https://github.com/ReSwift/ReSwift-Router) 相似的。
* 我们需要想出一个在大型应用程序中共享状态的好的模式，(如文章一开始讨论的，"什么是 `Store` 的作用域？")。我们需要在原版的 `Flux` 架构中，增加 `stores` 之间的依赖关系么？ 我们还有其他选择么？

还有很多，很多的实现细节，优点和缺点，我想我会在之后的文章里深入讨论他们。

至此，我对目前的选择很满意，并且我希望这篇文章能给你们一些参考，是否 `Flux` 架构也对你适合。

最后，如果你对 `Flux` 在 `Swift` 上的实现感兴趣，或只想为我们的产品贡献一份你的力量共同成就一个巨大的产业。**[我们正在招聘](http://grnh.se/8fcutd)**。

非常感谢 [@zats](https://twitter.com/zats), [@kubanekl](https://twitter.com/kubanekl) 和 [@pixelpartner](https://twitter.com/pixelpartner)，感谢他们为这个文章进行校对。

**参考文献**:

*   [Flux](https://facebook.github.io/flux/) - `Facebook` (脸书) 的官方讨论 `Flux` 的网站
*   [Unidirectional Data Flow in Swift](https://realm.io/news/benji-encz-unidirectional-data-flow-swift/) - 有关 `Swift` @ `Redux` 概念和 `ReSwift` 的实现方式
*   [ReSwift](https://github.com/reswift/reswift) - 一个以 `Swift` 实现的 `Redux`
*   [ReSwift Router](https://github.com/ReSwift/ReSwift-Router) - 一个给 `ReSwift` 用的路由应用程序
