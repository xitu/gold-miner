> * 原文地址：[Getting to Swift 3](https://medium.com/airbnb-engineering/getting-to-swift-3-at-airbnb-79a257d2b656#.b0f62n181)
* 原文作者：[Chengyin Liu](https://twitter.com/chengyinliu), [Paul Kompfner](https://github.com/kompfner), [Michael Bachand](https://twitter.com/michaelbachand)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Deepmissea](http://deepmissea.blue)
* 校对者：[Karthus1110](https://github.com/Karthus1110)，[lovelyCiTY](https://github.com/lovelyCiTY)

# 步入 Swift 3 

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*yRyt_nc-U0j7xGW0bMADOg.png">

从 Swift 出现开始，Airbnb 就开始使用它。我们从这门现代、安全、社区驱动的语言看到了很多好处。

直到最近，我们大部分的代码还是基于 Swift 2 的。我们刚刚完成了 Swift 3 的迁移，正好赶上 Xcode 新版发布，就舍弃了对 Swift 2 的支持。

我们想在社区分享我们的迁移方式，Swift 3 对我们应用的影响，以及我们在此过程中获得的一些技术经验。

### “可持续发展”的方法 ###

我们有几十个模块和几个三方库都是用 Swift 编写的，包括了几千个文件和几十万代码。就好像这个代码量还不足够具有挑战性一样，Swift 2 和 Swift 3 模块之间无法互相导入的事实，更加剧了迁移过程的复杂度。由于 Swift ABI 在版本 2 和 3 之间的改变，即使是正确的 Swift 3 代码引入 Swift 2 的库也不能编译。这个不兼容性，导致了代码并行优化变得异常困难。

为了确保我们能渐进地转换并校验代码，我们建立了一个依赖图，为我们 36 个 Swift 模块进行了拓扑排序。我们的升级计划如下：

1. 升级 CocoaPods 到 1.1.0（用来支持必要的 pod 升级）

2. 升级第三方的 pods 到 Swift 3 版本

3. 按照拓扑顺序，转换我们自己的模块
 
在与已经完成迁移的公司的交流中，我们了解到冻结开发是一个常见策略。如果可能的话，我们希望尽量避免代码冻结，即使这意味着增加迁移的难度。由于转换工作无法简单的并行化，全员出动（all-hands-on-deck）的方法是低效的。而且，由于无法估计转换要花多长时间，所以我们想确保在迁移的过程中，继续的发布新版本。

我们有三个人来做迁移工作。两个人专注于代码的转换，然后第三个人来协调团队沟通和基准的检测。

包括准备工作，我们项目的时间线看起来是这样的：

- 1 周：调研和准备（一个人）

- 2.5 周：转换（两个人），并分析转换的效率，与大团队沟通（一个人）

- 2 周：QA 和修复 bug（QA 团队 + 各个功能的作者）

### Swift 3 的影响 ###

在我们对 Swift 3 新语言特性的感到兴奋时，我们也想知道这次更新会对最终用户，以及整体的开发体验有怎样的影响。我们密切关注着 Swift 3 对发布的 IPA 大小和调试时的编译时间的影响，因为至今为止，这些是  Swift 项目的两个最大痛点。不幸的是，在尝试了不同的优化设置测试以后，Swift 3 在这两点上的指标还是略差。

#### 发布 IPA 的体积 ####

在迁移到 Swift 3 以后，我们发现 IPA 增加了 2.2MB。经过一些分析发现，这几乎都是由于 Swift 本身的库体积增加（我们自己的二进制文件大小几乎没有改变）。这里有一些未压缩二进制体积增加的例子：

- libswiftFoundation.dylib: up 233.40% (3.8 MB)

- libswiftCore.dylib: up 11.76% (1.5 MB)

- libswiftDispatch.dylib: up 344.61% (0.8 MB)

由于 Swift 3 库的增益，比如 Foundation，这种增加也是可以理解的。尽管，我们更期待的是 Swift ABI 稳定时，程序的体积不会再因为这些增益而增加。

#### 调试的构建时间 ####

我们迁移之后，程序的构建时间比之前慢了 4.6%，以前 6 分钟，增加了 16 秒。

我们试着比较在 Swift 2 和 Swift 3 之间每个函数的编译时间，但是我们无法得出具体结论，因为函数在不同的文件都不相同。我们确实发现了一个函数，由于迁移，编译时间暴增 12 秒。幸运的是，我们能慢慢把它还原下来，但这也说明了检查转换代码类似异常的重要性。[Build Time Analyzer for Xcode](https://github.com/RobertGummesson/BuildTimeAnalyzer-for-Xcode) 这个工具很有帮助，或者你只需要[设置适当的编译标识，并解析他们，生成日志](http://irace.me/swift-profiling)。

#### Runtime 问题 ####

不幸地，代码在 Swift 3 下成功编译并不意味着完成了迁移的工作。Xcode 的代码转换工具不能保证运行时的行为像编译时正常。此外，这是我们一会儿要讨论的，代码转换还是需要一些体力活，而且还有一些陷阱。这些不幸的事情，意味着代码回归。由于单元测试覆盖率没有给我们足够的信心，我们不得不耗费额外的 QA 周期在新迁移的应用上。

新迁移的应用通过首次 QA 时有很多明显的问题。通过应用本文后面讨论的几种技术，大部分的问题都被三人小队快速地解决了（在几个小时内）。经过初步的消除容易的问题，高可见度的回归分析，我们的 iOS 团队在大型项目里留下了 15 个潜在回归，其中 3 个崩溃，这是我们在发布下一版本应用前需要解决的。

### 代码转换过程 ###

我们从 `master` 新建一个 `swift-3` 的分支开始。和刚才提到的一样，我们模块化的处理了代码转换模块，从叶子模块开始，依据依赖树展开工作。只要可能，我们就并行的转换不同的模块。如果不能，我们就在一起说一声我们正在做的，以避免冲突。

对于每个模块，过程大概是这样的：

1. 从 `swift-3` 创建一个新的分支

2. 在模块上运行 Xcode 代码转换工具

3. 提交并推送更改

4. 构建

5. 手动修复一些构建错误

6. 提交并且推送更改

7. 再构建

8. 重复前面 3 步，直到完成

在手动地更新代码时，我们坚持的哲学是“做最表面的代码转换”。这意味着我们的目的不是在转换期间提高代码的安全性。这么做的原因有两个。第一，由于团队正在 Swift 2 积极开发，这是一场与时间的赛跑。第二，我们希望代码的回归风险降到最小。

幸运地是，我们在进行这个项目的时间是比较宽裕的，因为恰好是假期。这意味着我们可以安全的度过几天，即使不急着把 `swift-3` 重组（rebase）到 `master` 分支上，也不会落后太多。在我们要重组的时候，使用 `git rebase -Xours master` 来保持尽量多的 `swift-3` 代码，而默认用 `master` 上的代码解决冲突。

一旦 `master` 的进度被 `swift-3` 赶上，我们就知道在合并它之前，大概只有一天的时间来解决这些问题。鉴于我们 iOS 团队的规模，而且 `master` 是一个动态的目标。所以，为了完成 Swift 3 的迁移工作，我们强烈的鼓励整个团队（除了做代码迁移的）做到真真正正的周六歇一天 😄。


### 值得一提的问题 ###

#### Objective-C 中的闭包参数 ####

我们最常见的问题之一，就是 Xcode 没有自动建议修复 Objective-C 和 Swift 之间的闭包参数。看一下这个函数在一个 Objective-C 头文件的声明：

![Markdown](http://i1.piimg.com/1949/300646b3b962e346.png)

很多东西都变了，但是最重要的是 `completionBlock` 里面的参数从隐式拆包类型变成了可选类型，这会破坏这个参数在闭包中的使用。

我们决定最“表面”的转化到 Swift 3（不和 Objective-C代码接触），我们想要在闭包的顶部声明一个变量，它有和参数相同的名字，不过它是隐式拆包的：

![Markdown](http://i1.piimg.com/1949/bbdc00bdcba906bb.png)

这么做，而不是在使用参数的时候再拆包，是因为这样做几乎不会破坏闭包内部其他地方的语义。在上面的例子里，接下来的语句像 `if let someReview = review { /* … */ } ` 和 `review ?? anotherReview` 都会正常的工作。

#### 隐式拆包里的类型推演问题 ####

另一个常见（以及相关）的问题是，处理 Swift 3 所推演出变量的类型，原来是隐式拆包的，现在变为可选类型了。考虑下面的例子：

```
func doSomething() -> Int! {
  return 5
}

var result = doSomething()
```
在 Swift 2.3 里，`result` 的类型被推断为 `Int!`。而在 Swift 3，它的类型是 `Int？`

鉴于上面提到的闭包参数问题，最直接的解决方案就是把你的变量声明为一个隐式拆包类型：

```
var result: Int! = doSomething()
```
因为桥接的 Objective-C 的初始化方法返回隐式拆包类型，导致这个特殊问题出现的比预期要频繁。

#### 个别的函数编译时间爆炸 ####

在我们代码迁移的工作中，偶尔地，编译器会停顿那么几分钟。

我们项目中的一些函数，需要很多复杂的类型推演。在正常情况下，编译的时间只有一丢丢，但是如果他们包含了编译错误，那编辑器就会一脸懵逼。

在构建过程被这个问题卡住的时候，我们使用 [Xcode 构建时间分析](https://github.com/RobertGummesson/BuildTimeAnalyzer-for-Xcode)工具来帮助我们发现瓶颈所在。接着我们就能专注于这个功能上，暂别我们快乐的转化代码、构建、再转换代码的快乐周期了。

#### 可选协议方法上的 “Near misses”  ####

在转换 Swift 3 的过程中，可选协议方法是很容易忽略的一部分。

考虑 `UICollectionViewDataSource` 上的这个方法：

```
func collectionView(
  _ collectionView: UICollectionView, 
  viewForSupplementaryElementOfKind kind: String, 
  at indexPath: IndexPath) -> UICollectionReusableView
```
假设你的类实现了 `UICollectionViewDataSource`，并且定义了下面这个方法：

```
func collectionView(
  collectionView: UICollectionView, 
  viewForSupplementaryElementOfKind kind: String, 
  atIndexPath indexPath: IndexPath) -> UICollectionReusableView
```

你能指出不同吗？很难说。但是他们就是不同的，而且你的类编译的时候正常，因为它是一个可选的函数，没有更新描述的签名。

幸运地，有时候编译警告会帮你发现这些，但不是全部。所以去检查每个协议的可选方法（比如 UIKit 里的代理协议和数据源协议）是否正确是很重要的。搜索像 “`func collectionView(collectionView:`” 这样的文本（注意第一个参数，这是 Swift 2 遗留的标识），可以帮助找到代码里的元凶。

#### 具有默认实现的协议 ####

通过协议扩展，协议本身可以有默认的实现。如果一个协议的方法签名在 Swift 2 到 Swift 3 之间改变了，那确认他们是否在任何地方都改变了就很重要。如果*协议的扩展实现*，或者是*你的类型的实现*是正确的，编译器都会很开心的编译，但是成功的编译并不能保证*两个*实现都是正确的。

#### String 类型的枚举 ####

在 Swift 3 中，枚举的命名被规定为`小驼峰`。Xcode 转换工具自动的对任何现有的枚举进行更改。尽管它会略过值类型为 `String` 的枚举。这么做是有理由的，因为有可能在用 `String` 初始化枚举的时候，匹配到了一个枚举的名字。如果你更改了枚举的名字，那你很有可能破坏某些地方的初始化代码。你可能会出于“完成工作”的目的，把一些枚举小写，但是这么做的前提是，你有足够的信心，不会破坏某些基于 `String` 的初始化。

#### 三方库 API 的改变 ####

和大多数应用一样，我们也依赖了一些三方库。迁移过程需要更新任何用 Swift 编写的三方库。这看上去显而易见，但是仍然值得一提：仔细的阅读发布说明，尤其是你依赖的已经有一个重大版本更改（这可能发生在语言的版本更改的时候）。这帮助我们发现了一些难以发现的 API 更改，编译器做不到这一点。

### 下一步 ###

哇！我们的 `master` 分支现在是 Swift 3 了，Swift 2 没有新开发的功能，所有的迁移工作已经完成了，是这样么？

好吧，不全是。就像前面提到的，在代码转换过程中，我们只做了 Swift 2 和 Swift 3 之间最“表面”的转换。这代表我们还没利用上 Swift 3 的新特性和安全性。

在持续更新的基础上，我们会寻找一些潜在的改进。

#### 更精细的访问控制 ####

默认情况下，Xcode 代码转换工具将 `private` 访问控制符改为 `fileprivate`，`public` 改为 `open`。这代表着一个“表面”的转换，保证代码能继续像以前一样工作。 然而，它也错过了一个机会，来让开发者思考新的 `private` 和 `public` 行为是否能*更好*的工作。下一步是重新查看访问控制符的转换的实例，并检查我们是否可以利用 Swift 3 新增的表达式，来提供更精细的控制。

#### Swift 3 方法命名 ####

在手动转换代码的时候（在 Xcode 转换工具不好使，或者重组的时候），我们经常“表面”的修改方法名字，来让调用会正确的进行。采用 Swift 2.3 的方法签名，像这样：

```
func incrementCounter(counter: Counter, atIndex index: Int)
```

为了做出最少的改动、最快的修改，能让代码再次 Swift 3 上编译，我们把代码改成了这样：


```
func incrementCounter(_ counter: Counter, atIndex index: Int)
```

尽管，一个更 “Swift 3” 的写法是这样的：

```
func increment(_ counter: Counter, at index: Int)
```

下一步工作就是找出快捷命名的变量，然后更新方法签名，来更好地跟随 Swift 3 的转变。

#### 更安全的使用隐式解包 ####

如同前面展示的，我么应对新的 Objective-C 闭包参数的做法是转换成自动拆包的可选变量，这避免了更新闭包中的大量代码。而我们现在应该做的是，适当的处理闭包中参数可能是 `nil` 的情况。

#### 修复 ⚠️ ####

为了让代码全速的转换，我们最终忽略了一堆不是特别重要的编译警告，在未来，我们会意识到必须要让警告数量减少。

### 结论 ###

由于 Airbnb 对 Swift 很期待，并且是早期的使用者，我们积累了大量的 Swift 代码。 迁移到 Swift 3 的展望似乎令人望而生畏，并且我们不清楚将如何进行或者说迁移后会对我们的应用造成怎样的影响。如果你还没有决定将你的代码转换为 Swift 3，我们希望我们的经验对你的困惑有一些帮助。

最后，如果你对使用最新的移动技术（比如 Swift 3）来帮助他人感兴趣，[我们正在招聘](https://www.airbnb.com/careers/departments/engineering)
