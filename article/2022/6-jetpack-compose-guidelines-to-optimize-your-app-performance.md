> * 原文地址：[6 Jetpack Compose Guidelines to Optimize Your App Performance](https://proandroiddev.com/6-jetpack-compose-guidelines-to-optimize-your-app-performance-be18533721f9)
> * 原文作者：[Jaewoong Eum](https://medium.com/@skydoves)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/6-jetpack-compose-guidelines-to-optimize-your-app-performance.md](https://github.com/xitu/gold-miner/blob/master/article/2022/6-jetpack-compose-guidelines-to-optimize-your-app-performance.md)
> * 译者：[Quincy-Ye](https://github.com/Quincy-Ye)
> * 校对者：[gs666](https://github.com/gs666) [timerring](https://github.com/timerring)

# 6 条 Jetpack Compose 使用指南助你优化 App 性能

![](https://cdn-images-1.medium.com/max/2400/0*eyCD7K2DQ8AS0GpE.png)

自从 Google 发布了 [Jetpack Compose stable 1.0](https://android-developers.googleblog.com/2021/07/jetpack-compose-announcement.html), 很多公司开始在他们的项目中使用 Jetpack Compose. 如 [Google’s What developers are saying](https://developer.android.com/jetpack/compose/adopt#what-developers-are-saying) 所说, Jetpack Compose 提高了他们的生产效率和代码质量。

虽然 Jetpack Compose 有一个专门的优化系统，但是理解 Jetpack Compose 的渲染机制对于正确提高你 app 的性能至关重要。

在本文中，你将了解 Jetpack Compose 的整体渲染过程，以及如何按照 [Stream](https://getstream.io/) 的 Compose 团队制定的 Jetpack Compose 指南优化你的 app 性能。

如果你想进一步了解完整指南, 请查看 [Stream’s Compose SDK Guidelines](https://github.com/GetStream/stream-chat-android/blob/main/stream-chat-android-compose/GUIDELINES.md).

在深入研究之前，我们先看看 Jetpack Compose 编译器是如何在运行时渲染 UI 元素的。

## Jetpack Compose 的阶段

Jetpack Compose 按照下面三个不同的阶段渲染帧：

* **组合**: 这是渲染的第一阶段。 Compose 运行可组合函数并分析 UI 信息。
* **布局**: 对于布局树中的每个节点，Compose 会测量并交换 UI 元素的位置信息。
* **绘制**: UI 元素会绘制在 Canvas 上。

![](https://cdn-images-1.medium.com/max/2000/0*R94nMSJLI8VPWL4I.png)

大多数可组合函数总是以相同的顺序遵循执行上述流程。

假设你需要更新 UI 元素，例如布局的大小和颜色。由于**绘制**阶段已经完成，Compose 需要从第一个阶段开始执行这整个流程来更新数据；这个过程称为**重新组合**：

![](https://cdn-images-1.medium.com/max/2000/0*u6kCggbkUBIRo4JX.png)

重新组合是当可组合函数的输入发生变化时，从**组合**阶段再次运行可组合函数的过程。

但是，重新组合整个 UI 树和元素的代价是很高的。你可以想一下，就像当你只需要更新单个 item 时，却更新 [RecyclerView](https://developer.android.com/jetpack/androidx/releases/recyclerview) 上的所有的 item 那样。

为了优化重组，Compose 运行时有智能优化系统，它跳过所有未更改参数的 lambda 函数，最终，Compose 可以高效地进行重组。

有关更多信息，请查看 [Jetpack Compose 的阶段](https://developer.android.com/jetpack/compose/phases) 。

现在，让我们看看如何降低重组的成本。

## 1. 写稳定的类

Jetpack Compose 有其专用的运行时，它决定在输入或状态发生变化时应该重构哪个可重组函数。

Jetpack Compose 通过推断正在读取的状态是否已发生改变，从而优化运行时的性能。

总的来说，有以下三种稳定性类型：

* **不稳定型**: 这些保存可变的数据，并且在发生改变时不通知 Composition。 Compose 无法验证这种类型的数据是否已经发生变化了。
* **稳定型**: 这些保存可变的数据，但在发生改变时通知Composition。因为这样认为它们是稳定的，因为 Composition 总能知道状态的任何改变。
* **不可变型**: 顾名思义，它们保存不可变的数据。由于数据永远不会改变，Compose 直接认为这是稳定型数据。

现在让我们来看看这些稳定型的数据具体是怎么使用的吧。

#### 从真实案例来看看它们的影响

如果 Compose 能够保证稳定性，将会给可组合项带了一定的性能优势，主要是可以将它标记为是可跳过的。

创建几对类和可组合项，然后生成对应的 Compose 的编译报告。现在起，你只需要关注它的影响而不是机制，因此只需分析其结果。

创建一个稳定的类和可组合函数，如下例所示：

```Kotlin
data class InherentlyStableClass(val text: String)

@Composable
fun StableComposable(
    stableClass: InherentlyStableClass
) {
    Text(
        text = stableClass.text
    )
}
```

现在，为上面的示例生成编译报告并分析结果：

```
stable class InherentlyStableClass {
  stable val text: String
  <runtime stability> = Stable
}

restartable skippable scheme("[androidx.compose.ui.UiComposable]") fun StableComposable(
  stable stableClass: InherentlyStableClass
)
```

编译器将为 StableComposable 可组合函数生成上面说的结果。

报告有些什么？

首先，可以看到因为数据类的所有（在本例中，参数只有一个）参数都标记为稳定类型，所以它的运行时也被认为是稳定的。

这对可组合函数是有影响到结果的，现在标记为：

* **Restartable**: 意味着这个可组合项可以作为一个重新启动的范围。每当这个可组合项需要重组时，它都不会触发父级作用域的重组。
* **Skippable**: 由于我们的可组合项用作状态的唯一参数是稳定的，因此 Compose 能够推断它什么时候发生变化，什么时候没发生变化。这使得 Compose Runtime 能够在其父级作用域重构并且它用作状态的所有参数保持不变时跳过这个可组合项的重组。

现在，创建一个不稳定的类和可组合函数，如下例所示：

```Kotlin
data class InherentlyUnstableClass(var text: String)

@Composable
fun UnstableComposable(
    unstableClass: InherentlyUnstableClass
) {
    Text(
        text = unstableClass.text
    )
}
```

然后，再次生成报告：

```
unstable class InherentlyUnstableClass {
  stable
  var text: String
  <runtime stability> = Unstable
}

restartable scheme("[androidx.compose.ui.UiComposable]") fun UnstableComposable(
  unstable unstableClass: InherentlyUnstableClass
)
```

状态类和可组合项做的工作一样，但效果不一样。尽管它们的组成 90% 都是相同的，但由于该示例使用了一个不稳定的类，导致失去了在必要时跳过这个可组合的能力。

对于只是调用其他的可组合项之外，什么都不做的可组合项来说，这可能并没什么。但是，对于比较复杂的可组合项，这可能会对性能造成重大影响。

> **注意**: 不返回 Unit 的可组合项既不能跳过也不能重新启动。它们是不可重启的，因为它们是值的生产者，应该在发送变化时强制让他们父级元素重新组合。

## 2. 编写类的规则

现在，你已经对稳定性很渴望了吧。大多数情况下，你如果想要稳定，你应该以不变性为目标，因为通过通知组合获得稳定性需要大量工作，例如通过创建 `MutableState<T>` 类来完成。

#### 1. 不要在状态持有类中使用 var 修饰属性

当属性是可变的，但不通知composition ，这会导致使用它们的可组合项变得不稳定。

**应该这样写:**

```
data class InherentlyStableClass(val text: String)
```

**不应该这样写:**

```
data class InherentlyUnstableClass(var text: String)
```

#### 2. 私有属性仍会影响稳定性

在写这篇文章的时候，不知道是设计问题还是一个 bug，我们可以稍微修改一下上面的类。

```Kotlin
data class InherentlyStableClass(
    val publicStableProperty: String,
    private var privateUnstableProperty: String
)
```

编译报告会将此类标记为是不稳定的：

```
unstable class InherentlyStableClass {
  stable val publicStableProperty: String
  stable var privateUnstableProperty: String
  <runtime stability> = Unstable
}
```

查看结果，很明显编译器在这里遇到了问题。它将两个单独的属性标记为稳定，即使只有一个不是稳定的，也把将整个类标记为不稳定。

#### 3. 不要用外部模块的类来定义状态

因为 Compose 只能推断源自 Compose 编译器编译的模块的类、接口和对象的稳定性。这意味着任何来自外部的类都将被标记为不稳定，无论它实际上是否稳定。

假如你使用了下面来自外部模块类的话，将会导致不稳定：

```Kotlin
class Car(
    val numberOfDoors: Int,
    val hasRadio: Boolean,
    val isCoolCar: Boolean,
    val goesVroom: Boolean
)
```

下面是常见的一种用外部模块类来构建状态的方法： 

```Kotlin
data class RegisteredCarState(
    val registration: String,
    val car: Car
)
```

但是，这会带来问题。这么做的话，会导致不稳定并且不可以跳过。这就可能会导致性能问题了。

不过，解决这个问题有很多办法。

如果 `RegisteredCarState` 类只是由 `Car` 的几个属性来构成的，那么我们可以简单地写成下面这样：

```Kotlin
data class RegisteredCarState(
    val registration: String,
    var numberOfDoors: Int,
    var hasRadio: Boolean
)
```

但是，如果需要所有的属性，那可能就不适合了。

在这种情况下，你可以创建一个本地稳定的副本，例如：

```Kotlin
class CarState(
    val numberOfDoors: Int,
    val hasRadio: Boolean,
    val isCoolCar: Boolean,
    val goesVroom: Boolean
)
```

他们是一样的，只是 CarState 是稳定的。

因为用户可能需要根据他们正在处理的架构层来转换这些类，所以应该提供便捷的映射函数，例如：

```
fun Car.toCarState(): CarState
fun CarState.toCar(): Car
```

#### 4. 不要期待集合是不变的

诸如 `List`、`Set` 和 `Map` 之类的东西起初可能看起来是不可变的，但它们并非如此，编译器会将它们标记为不稳定的。

目前，有两种选择，更直接的一种包括使用 Kotlin’s [不可变集合](https://github.com/Kotlin/kotlinx.collections.immutable) 。但是，这些仍然是预发布的，可能行不通。

另一种解决方案是，把 `list` 包装起来，并且标记为 `@Immutable` 。这种方法已经被社区采用，但是并未被官方认可。
```Kotlin
@Immutable
data class WrappedList(
    val list: List<String> = listOf()
)
```

这样做，虽然编译器仍然认为这单个属性是不稳定的，但认为整个包装类是稳定的。

```
stable class WrappedList {
  unstable val list: List<String>
}
```

但是，这两种都不是理想的解决方案。

#### 5. Flows 是不稳定的

尽管 `Flow` 看起来很稳定，因为 `Flow` 是可观察的，但 `Flow` 在发出新值时不会通知 `composition`。这使得 `Flow` 本质上是不稳定的。所以，非必要的时候不要使用 `Flow`。

#### 6. 内联可组合项既不可重新启动也不可跳过

与所有内联函数一样，内联可组合项也可以带来性能优势。一些常见的可组合项，例如 `Column`、`Row` 和 `Box` 都是内联的。我不是警告你不要用内联可组合项，只是建议你小心使用内联可组合项，并注意它们如何影响父级范围的重组的。

在后面的内容里，将会更详细地介绍这一点。

## 3. 适当地提升状态

提升状态是创建无状态可组合项的行为。原则很简单：

* 所有必要的状态都应该从可组合项的调用者那里传下来。
* 所有事件都应该向上流向状态源。

举个例子。

```Kotlin
@Composable
fun CustomButton(text: String, onClick: () -> Unit) {
    Button(onClick = onClick) {
    Text(text = text)
  }
}
```

接下来，将其托管在设置内容中。

```Kotlin
setContent {
  var count by remember {
    mutableStateOf(0)
  }

  CustomButton(text = "Clicked $count times") {
    count++
  }
}
```

由于状态提升，可组合项表现良好，它遵循单向流，并且更具可测试性。

但是，这并不能意味着完全安全，因为很容易在更复杂的场景中误用这种模式。

## 4. 不要在过高层级读取状态

假设你有一个稍微复杂的状态持有者：

```Kotlin
class StateHoldingClass {
  var counter by mutableStateOf(0)
  var whatAreWeCounting by mutableStateOf("Days without having to write XML.")
}
```

使用如下：

```Kotlin
@Composable
fun CustomButton(count: Int, onClick: () -> Unit) {
  Button(onClick = onClick) {
    Text(text = count.toString())
  }
}
```

在我们假设的场景中，这个状态持有者托管在 `ViewModel` 中，通常也是这么做，并以下列方式读取：

```Kotlin
setContent {
  val viewModel = ViewModel()

  Column {
    Text("This is a cool column I have")
    CustomButton(count = viewModel.stateHoldingClass.counter) {
      viewModel.stateHoldingClass.counter++
    }
  }
}
```

乍一看，这好像很完美，你可能认为因为属性 `StateHoldingClass.counter` 被当作 `CustomButtom` 的参数，这好像只有 `CustomButton` 会被重新组合，但事实并非如此。

这算作在 `Column` 内部读取的状态，这意味着现在必须重新组合整个 `Column`。但这并没有结束。由于 `Column` 是一个内联函数，这意味着它也会触发其父作用域的重组。

好在，有一个简单的方法可以避免这种情况，答案是降低状态的读取。

用下面的方式重写上面的可组合项：

```Kotlin
@Composable
fun CustomButton(stateHoldingClass: StateHoldingClass, onClick: () -> Unit) {
  Button(onClick = onClick) {
    Text(text = stateHoldingClass.counter.toString())
  }
}
```

并将回调点更改为：

```Kotlin
setContent {
  val viewModel = ViewModel()

  Column {
    Text("This is a cool column I have")
    CustomButton(stateHoldingClass = viewModel.stateHoldingClass) {
      viewModel.stateHoldingClass.counter++
    }
  }
}
```

现在，状态读取发生在 `CustomButton` 内部，这样就只会重新组合刚刚说的可组合项的内容了。在这种情况下，`Column` 和它父级范围都可以避免不必要的重组了！

## 5. 避免不必要的且代价高的运行时计算

创建下面的可组合项：

```Kotlin
@Composable
fun ConcertPerformers(venueName: String, performers: PersistentList<String>) {
  val sortedPerformers = performers.sortedDescending()

  Column {
    Text(text = "The following performers are performing at $venueName tonight:")

    LazyColumn {
      items(items = sortedPerformers) { performer ->
        PerformerItem(performer = performer)
      }
    }
  }
}
```

这是一个简单的可组合项，它只展示了场地的名称，以及在这个场地表演的表演者。我们还希望它可以对该列表进行排序，以便读者更容易找到他们感兴趣的表演者是否正在表演。

但是，它有一个关键的问题。如果场地发生变化，但表演者名单保持不变，则必须再次对名单进行排序。这是一个潜在的高代价操作。不过，我们可以轻松地让这种情况只发生在必要的时候。

```Kotlin
@Composable
fun ConcertPerformers(venueName: String, performers: PersistentList<String>) {
  val sortedPerformers = remember(performers) {
    performers.sortedDescending()
  }

  Column {
    Text(text = "The following performers are performing at $venueName tonight:")

      LazyColumn {
        items(items = sortedPerformers) { performer ->
          PerformerItem(performer = performer)
        }
      }
    }
}
```

在上面的示例中，通过 `remember` ，来让 `performers` 作为 key 计算排序列表。只有当表演者列表发生变化时，它才会重新计算，避免不必要的重组。

如果你可以访问原始的 `State<T>` 实例，则可以通过直接从中派生状态来获得额外的好处，例如以下示例（请注意函数签名发生了变化）：

```Kotlin
@Composable
fun ConcertPerformers(venueName: String, performers: State<PersistentList<String>>) {
  val sortedPerformers = remember {
    derivedStateOf { performers.value.sortedDescending() }
  }

  Column {
    Text(text = "The following performers are performing at $venueName tonight:")

    LazyColumn {
      items(items = sortedPerformers.value) { performer ->
          PerformerItem(performer = performer)
      }
    }
  }
}
```

这时，Compose 不仅跳过了不必要的计算，而且可以跳过重新组合父范围，因为只是更改本地读取的属性，而不是使用新参数重新组合整个函数。

## 6. 尽可能延后读取

本节是官方提供示例的一个简化，官方示例详情请参阅 [尽可能延后读取](https://developer.android.com/jetpack/compose/performance#defer-reads).

创建一个简单的可组合项，这个组件主要是滑出动画的处理：

```Kotlin
@Composable
fun SlidingComposable(scrollPosition: Int) {
  val scrollPositionInDp = with(LocalDensity.current) { scrollPosition.toDp() }

  Card(
    modifier = Modifier.offset(scrollPositionInDp),
    backgroundColor = Color.Cyan
  ) {
    Text(
      text = "Hello I slide out"
    )
  }
}
```

就像在原来示例中一样，将这个可组合项绑定到滚动位置。但由于 `LazyColumn` 不采用 `ScrollState`，你需要像下面那样稍微改动一下这个可组合项：

```Kotlin
@Composable
fun ConcertPerformers(
  scrollState: ScrollState,
  venueName: String,
  performers: PersistentList<String>,
  modifier: Modifier = Modifier
) {
  Column(modifier = modifier) {
    Text(
      modifier = Modifier.background(color = Color.LightGray),
      text = "The following performers are performing at $venueName tonight:"
    )

    Column(
      Modifier
        .weight(1f)
        .verticalScroll(scrollState)
    ) {
        for (item in performers) {
          PerformerItem(performer = item)
        }
      }
    }
}

@Composable
fun PerformerItem(performer: String) {
  Card(
    modifier = Modifier
      .padding(vertical = 10.dp)
      .background(
        color = Color.LightGray,
      )
      .wrapContentHeight()
      .fillMaxWidth()
    ) {
      Text(
        modifier = Modifier.padding(10.dp),
        text = performer
      )
   }
}
```

接着，你可以像下面这样构建这个布局：

```Kotlin
setContent {
  val scrollState = rememberScrollState()

  Column(
    Modifier.fillMaxSize()
  ) {
    SlidingComposable(scrollPosition = scrollState.value)

    ConcertPerformers(
      modifier = Modifier.weight(1f),
      scrollState = scrollState,
      venueName = viewModel.venueName,
      performers = viewModel.concertPerformers.value
    )
  }
}
```

按照这么做，还是会遇到与以前相同的问题。阅读高层的状态并且重构 `setContent` 中的所有内容。你可能打算像以前一样通过将整个 `ScrollState` 作为参数传递来解决这个问题，但还有另一种非常方便的做法。

你可以用一个 lambda 来延迟读取状态：

```Kotlin
@Composable
fun SlidingComposable(scrollPositionProvider: () -> Int) {
  val scrollPositionInDp = with(LocalDensity.current) { scrollPositionProvider().toDp() }

  Card(
    modifier = Modifier.offset(scrollPositionInDp),
    backgroundColor = Color.Cyan
  ) {
    Text(
      text = "Hello I slide out"
    )
  }
}
```

`scrollPositionProvider lambda` 不会变，只有在调用时结果才会改变。这也就是说现在状态读取发生在 `SlidingComposable` 内部，所以这不会导致父级重组。


但是等等，还有一个可以优化的点！

Compose 绘制 UI 的[阶段](https://developer.android.com/jetpack/compose/phases) ：

1. 组合（运行可组合项）
2. 布局（测量可组合项并确定它们的位置）
3. 绘制（将元素绘制到屏幕上）

尽可能跳过其中的一些步骤，这将会减少不必要的开销。

在我们的示例中，仍然会导致重组，还是要走完这三个步骤。但是，由于没有更改组合并且仍在屏幕上绘制相同的元素，所以应该跳过这个步骤。

```Kotlin
@Composable
fun SlidingComposable(scrollPositionProvider: () -> Int) {

  Card(
    modifier = Modifier.offset {
      IntOffset(x = scrollPositionProvider(), 0)
    },
      backgroundColor = Color.Cyan
  ) {
    Text(
      text = "Hello I slide out"
    )
  }
}
```

这会有什么变化吗？ Modifier.offset(offset: Density.() -> IntOffset) 在布局阶段被调用，所以可以通过调用它来跳过组合阶段。从而，带来了显著的性能优化效果。

## 结论

在本文中，你可以学到 Jetpack Compose 的整体渲染过程，以及如何按照 [Stream](https://getstream.io/) 的 Jetpack Compose 指南优化你的应用性能。 

Stream 的 Jetpack Compose 团队目标是构建高性能的聊天 API，为 SDK 用户提供最佳的开发者体验。如果你有兴趣了解更多指南内容，请查看 [Compose SDK 指南](https://github.com/GetStream/stream-chat-android/blob/main/stream-chat-android-compose/GUIDELINES.md#project-structure)。

**本文发表于 [GetStream.io**/blog](https://getstream.io/blog/jetpack-compose-guidelines/)**。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
