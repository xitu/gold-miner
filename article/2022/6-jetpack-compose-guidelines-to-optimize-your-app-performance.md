> * 原文地址：[6 Jetpack Compose Guidelines to Optimize Your App Performance](https://proandroiddev.com/6-jetpack-compose-guidelines-to-optimize-your-app-performance-be18533721f9)
> * 原文作者：[Jaewoong Eum](https://medium.com/@skydoves)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/6-jetpack-compose-guidelines-to-optimize-your-app-performance.md](https://github.com/xitu/gold-miner/blob/master/article/2022/6-jetpack-compose-guidelines-to-optimize-your-app-performance.md)
> * 译者：
> * 校对者：

# 6 Jetpack Compose Guidelines to Optimize Your App Performance

![](https://cdn-images-1.medium.com/max/2400/0*eyCD7K2DQ8AS0GpE.png)

Since Google announced [Jetpack Compose stable 1.0](https://android-developers.googleblog.com/2021/07/jetpack-compose-announcement.html), many companies are getting started to adopt Jetpack Compose into their projects. According to [Google’s What developers are saying](https://developer.android.com/jetpack/compose/adopt#what-developers-are-saying), Jetpack Compose increases their productivity and code quality.

Jetpack Compose has a dedicated optimization system but it’s essential to understand the rendering mechanism of Jetpack Compose for improving your app performance properly.

In this article, you will learn about the overall rendering process of Jetpack Compose and how to optimize your app performance following Jetpack Compose guidelines that were built by [Stream](https://getstream.io/)’s Compose team.

If you want to learn more about the entire guidelines, check out [Stream’s Compose SDK Guidelines](https://github.com/GetStream/stream-chat-android/blob/main/stream-chat-android-compose/GUIDELINES.md).

Before you dive in, let’s see how Jetpack Compose compiler renders UI elements in the runtime.

## Jetpack Compose Phases

Jetpack Compose renders a frame following the three distinct phases:

* **Composition**: This is the first phase of the rendering. Compose run composable functions and analyze your UI information.
* **Layout**: Compose measure and commutates UI information on where to place the UI elements, for each node in the layout tree.
* **Drawing**: UI elements will be drawn on a Canvas.

![](https://cdn-images-1.medium.com/max/2000/0*R94nMSJLI8VPWL4I.png)

Most Composable functions follow the phases above always in the same order.

Let’s assume that you need to update the UI elements, such as the size, and color of your layout. Since the **Drawing** phase is already completed, Compose needs to run the phases from the first to update with the new value; this process is called **Recomposition**:

![](https://cdn-images-1.medium.com/max/2000/0*u6kCggbkUBIRo4JX.png)

Recomposition is the process of running your composable functions again from the **Composition** phase when the function’s inputs change.

However, recomposing the entire UI tree and elements is expensive computations. You can imagine that you should update entire items on [RecyclerView](https://developer.android.com/jetpack/androidx/releases/recyclerview) when you need to update a single item.

To optimize recomposition, Compose runtime contains the smart optimization system, which skips all functions for lambdas that don’t have changed parameters and eventually, Compose can recompose efficiently.

For more information, check out [Jetpack Compose Phases](https://developer.android.com/jetpack/compose/phases).

Now, let’s see how you can optimize the recomposition expenses.

## 1. Aim to Write Stable Classes

Jetpack Compose has its dedicated runtime and it decides which Composable function should be recomposed when their inputs or states change.

To optimize runtime performance, Jetpack Compose relies on being able to infer if a state that is being read has changed.

Fundamentally, there are three stability types below:

* **Unstable**: These hold data that is mutable and do not notify Composition upon mutating. Compose is unable to validate that these have not changed.
* **Stable**: These hold data that is mutable, but notify Composition upon mutating. This renders them stable since Composition is always informed of any changes to state.
* **Immutable**: As the name suggests, these hold data that is immutable. Since the data never changes, Compose can treat this as stable data.

Now let’s see how those stability types work with real-world examples.

#### Example of The Real-World Implications

If Compose is able to guarantee stability, it can grant certain performance benefits to a Composable, chiefly, it can mark it as skippable.

Let’s create pairs of classes and Composables and generate a Compose compiler report for them. For now, you only need to care about the implications and not the mechanics, so you’ll just analyze the results.

Let’s create a stable class and Composable function like the example below:

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

Now, let’s generate compiler reports for the example above and analyze the results:

```
stable class InherentlyStableClass {
  stable val text: String
  <runtime stability> = Stable
}

restartable skippable scheme("[androidx.compose.ui.UiComposable]") fun StableComposable(
  stable stableClass: InherentlyStableClass
)
```

The compiler reports will generate the results above for the `StableComposable` composable function.

What does this tell us?

First off, you see that because the data class has all of its (in this case a single) parameters marked as stable, its runtime stability is deemed to be stable as well.

This has implications for the Composable function, which is now marked as:

* **Restartable**: Meaning that this composable can serve as a restarting scope. This means that whenever this Composable needs to recompose, it will not trigger the recomposition of its parent scope.
* **Skippable**: Since the only parameter our Composable uses as state is stable, Compose is able to infer when it has or has not changed. This makes Compose Runtime able to skip recomposition of this Composable when its parent scope recomposes and all the parameters it uses as state remain the same.

Now, let’s create an unstable class and Composable function like the example below:

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

Now, you generate a Compose Compiler report again:

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

The state classes and Composables perform the same job, but not equally well. Even though 90% of what makes them is identical, because the example is using an unstable class we have lost the ability to skip this composable when necessary.

For smaller Composables that do not do much of anything other than calling other Composables, this may not be such a worrisome situation. However, for larger and more complex Composables, this can present a significant performance hit.

> **Note**: Composables that do not return `Unit` will be neither skippable nor restartable. It is understandable that these are not restartable as they are value producers and should force their parents to recompose upon change.

## 2. Rules for Writing classes

You have inferred your desire for stability. Mostly this means you should aim for immutability as gaining stability through notifying composition requires a lot of work, such as was done by the creation of the `MutableState\<T>` class.

#### 1. Do not use vars as properties inside state holding classes

As these are mutable, but do not notify composition, they will make the composables which use them unstable.

**Do:**

```
data class InherentlyStableClass(val text: String)
```

**Don’t:**

```
data class InherentlyUnstableClass(var text: String)
```

#### 2. Private properties still affect stability

As of the time of writing, it is uncertain if this is a design choice or a bug, but let’s slightly modify our stable class from above.

```Kotlin
data class InherentlyStableClass(
    val publicStableProperty: String,
    private var privateUnstableProperty: String
)
```

The compiler report will mark this class as unstable:

```
unstable class InherentlyStableClass {
  stable val publicStableProperty: String
  stable var privateUnstableProperty: String
  <runtime stability> = Unstable
}
```

Looking at the results, it’s fairly obvious that the compiler struggles here. It marks both individual properties as stable, even though one is not, but marks the whole class as unstable.

#### 3. Do not use classes that belong to an external module to form state

Sadly, Compose can only infer stability for classes, interfaces, and objects that originate from a module compiled by the Compose Compiler. This means that any externally originated class will be marked as unstable, regardless of its true stability.

Let’s say you have the following class which comes from an external module and is therefore unstable:

```Kotlin
class Car(
    val numberOfDoors: Int,
    val hasRadio: Boolean,
    val isCoolCar: Boolean,
    val goesVroom: Boolean
)
```

A common way to build a state using it would be to do the following:

```Kotlin
data class RegisteredCarState(
    val registration: String,
    val car: Car
)
```

However, this is troublesome. Now you’ve made our state class unstable and therefore unskippable. This could potentially cause performance issues.

Luckily there are multiple ways to get around this.

If you only need a few properties of `Car` to form `RegisteredCarState`, you may simply flatten it as follows:

```Kotlin
data class RegisteredCarState(
    val registration: String,
    var numberOfDoors: Int,
    var hasRadio: Boolean
)
```

However, this may not be appropriate in cases where you need the whole object with all of its properties.

In such cases, you may create a local stable counterpart such as:

```Kotlin
class CarState(
    val numberOfDoors: Int,
    val hasRadio: Boolean,
    val isCoolCar: Boolean,
    val goesVroom: Boolean
)
```

The two are identical, but `CarState` is stable.

Because users might need to convert to and from these classes depending on which architectural layer they are dealing with, you should provide easy mapping functions going both ways such as:

```
fun Car.toCarState(): CarState
fun CarState.toCar(): Car
```

#### 4. Do not expect immutability from collections

Things such as `List`, `Set`, and `Map` might seem immutable at first, but they are not and the Compiler will mark them as unstable.

Currently, there are two alternatives, the more straightforward one includes using Kotlin’s [immutable collections](https://github.com/Kotlin/kotlinx.collections.immutable). However, these are still pre-release and might not be viable.

The other solution, which is a technical hack and not officially advised but used by the community, is to wrap your lists and mark the wrapper class as `@Immutable`.

```Kotlin
@Immutable
data class WrappedList(
    val list: List<String> = listOf()
)
```

Here the compiler still marks the individual property as unstable but marks the whole wrapper class as stable.

```
stable class WrappedList {
  unstable val list: List<String>
}
```

Currently, neither of the two solutions are ideal.

#### 5. Flows are unstable

Even though they might seem stable since they are observable, `Flow`s do not notify composition when they emit new values. This makes them inherently unstable. Use them only if absolutely necessary.

#### 6. Inlined Composables are neither restartable nor skippable

As with all inlined functions, these can present performance benefits. Some common Composables such as `Column`, `Row`, and `Box` are all inlined. As such this is not an admonishment of inlining Composables, just a suggestion that you should be mindful when inlining Composables, or using inlined Composables and be aware of how they affect the parent scope recomposition.

You will cover this in more detail in future sections.

## 3. Hoist state properly

Hoisting state is the act of creating stateless Composables. The formula is simple:

* All necessary states should be passed down from the Composable’s caller.
* All events should flow upwards to the source of the state.

Let’s create a simple example.

```Kotlin
@Composable
fun CustomButton(text: String, onClick: () -> Unit) {
    Button(onClick = onClick) {
    Text(text = text)
  }
}
```

Next, host it inside set content.

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

Due to state hoisting, our composable is well-behaved, it follows the unidirectional flow, and is more testable.

However, this doesn’t make us completely safe, as we can easily misuse this pattern in more complex scenarios.

## 4. Don’t read the state from a too high scope

Let’s presume you have a slightly more complex state holder:

```Kotlin
class StateHoldingClass {
  var counter by mutableStateOf(0)
  var whatAreWeCounting by mutableStateOf("Days without having to write XML.")
}
```

And it’s being used in the following manner:

```Kotlin
@Composable
fun CustomButton(count: Int, onClick: () -> Unit) {
  Button(onClick = onClick) {
    Text(text = count.toString())
  }
}
```

In our hypothetical scenario this state holder is hosted inside a `ViewModel` which is a common practice, and read in the following manner:

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

At first glance, this might seem perfectly fine, you might think that because the property `StateHoldingClass.counter`is being used as a `CustomButtom` parameter that means that only `CustomButton` gets recomposed, however this is not the case.

This counts as a state read inside `Column`, meaning that the whole `Column` now has to be recomposed. But it doesn’t end here. Since `Column` is an inline function, this means that it will trigger the recomposition of its parent scope as well.

Luckily you have an easy way of avoiding this, the answer is to lower state reads.

Let’s rewrite our Composable in the following manner:

```Kotlin
@Composable
fun CustomButton(stateHoldingClass: StateHoldingClass, onClick: () -> Unit) {
  Button(onClick = onClick) {
    Text(text = stateHoldingClass.counter.toString())
  }
}
```

And change the call site to:

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

Now, the state read is happening inside `CustomButton`, which means that we will only recompose the contents of said Composable. Both `Column` and its parent scope are spared unnecessary recomposition in this scenario!

## 5. Avoid running expensive calculations unnecessarily

Let’s create the following Composable:

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

This is simple Composable, it displays the name of a venue, along with the performers who are performing at that venue. It also wants to sort that list so that the readers have an easier time finding if a performer they are interested in is performing.

However, it has one key flaw. If the venue gets changed, but the list of performers stays the same, the list will have to be sorted again. This is a potentially very costly operation. Luckily it’s fairly easy to run it only when necessary.

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

In this example above, you’ve used `remember` that uses `performers` as a key to calculate the sorted list. It will recalculate only when the list of performers changes, sparing unnecessary recomposition.

If you have access to the original `State\<T>` instance, you can reap additional benefits by deriving state directly from it, such as in the following example (please note the change function signature):

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

Here, Compose does not only skip unnecessary calculations, but is smart enough to skip recomposing the parent scope since you’re only changing a locally read property and not recomposing the whole function with new parameters.

## 6. Defer reads as long as possible

This section is a simplification of the example provided in the official documentation seen in [Defer reads as long as possible](https://developer.android.com/jetpack/compose/performance#defer-reads).

You’ll create a small composable that is meant to be animated by sliding out:

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

Much like in the original example, you’ve tied it to the scroll position. But since `LazyColumn` doesn't take `ScrollState`, you'll slightly modify our Composables to the following:

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

Now, you can build this layout as follows:

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

By doing this, you run into the same problem you had previously. Read the state high and recompose everything inside `setContent`. You might be tempted to solve it the same way as you did previously, by passing the whole `ScrollState` as a parameter, but there's another very handy way.

You can introduce a lambda to defer the state read:

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

The `scrollPositionProvider` lambda does not change, only the result changes when an invocation occurs. This means that
the state read is now happening inside of `SlidingComposable` and you do not cause parent recomposition.

But wait, there’s an extra step of optimization available!

Compose draws UI in [phases](https://developer.android.com/jetpack/compose/phases):

1. Composition (runs your Composables)
2. Layout (measures the Composables and defines their placement)
3. Drawing (Draws the elements on the screen)

Skipping any of these phases — when possible — will lessen the overhead.

In our example, you still cause recomposition, meaning that you go through all three steps. However, since you have not changed the composition and are still drawing the same elements on a screen, you should skip this step.

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

What’s the big change here? Modifier.offset(offset: Density.() -> IntOffset) is called during the layout phase, so you are able to completely skip the composition phase by using it; this, in turn, provides a significant performance benefit.

## Conclusion

In this article, you learned the overall rendering process of Jetpack Compose and how to optimize your app performance following [Stream](https://getstream.io/)’s Jetpack Compose guidelines.

Stream’s Jetpack Compose team aims to build performant chat APIs for providing the best developer experience to SDK users. If you’re interested in learning more about our guidelines, check out the [Compose SDK Guidelines](https://github.com/GetStream/stream-chat-android/blob/main/stream-chat-android-compose/GUIDELINES.md#project-structure).

**Originally published at [GetStream.io**/blog](https://getstream.io/blog/jetpack-compose-guidelines/)**.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
