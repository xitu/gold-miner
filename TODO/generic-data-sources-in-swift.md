
> * 原文地址：[Generic Data Sources in Swift](https://medium.com/capital-one-developers/generic-data-sources-in-swift-c6fbb531520e)
> * 原文作者：[Andrea Prearo](https://medium.com/@andrea.prearo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/generic-data-sources-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO/generic-data-sources-in-swift.md)
> * 译者：[Swants](https://swants.github.io)
> * 校对者：[iOSleep](https://github.com/iOSleep)

# Swift 中的通用数据源

![](https://cdn-images-1.medium.com/max/1600/1*Lv_C7Y7otRuJyQb5_v35Pw.gif)

在我开发的绝大多数 iOS app 中， tableView 和 collectionView 绝对是最常用的 UI 组件。鉴于设置一个 tableView 或 collectionView 需要大量样板代码，我最近花了些时间找到一个比较好的方法，去避免一遍又一遍地重复同样的代码。我的主要工作是对必需的样板代码进行抽取封装。随着时间的推移，很多其他开发者也解决了这个问题。并且随着 [Swift](https://github.com/apple/swift/blob/master/CHANGELOG.md) 的最新进展出现了很多有趣的解决方案。

本篇文章里，我将介绍在我 APP 里已经使用了一段时间的解决方案，这个方案让我在设置 collectionView 的时候减少了大量的样板代码。

### TableView vs CollectionView

有些人可能会问 **为什么单讨论 collectionView 而不提 tableView 呢?**

在最近的几个月里，我在之前可以使用 tableView 的地方都使用成了 collectionView 。它们到目前为止表现良好！这一做法帮助我不用去区分这两个 **几乎完全** 相似但并不完全相同的集合概念。接下来则是让我做出这一决定的根本原因：

- 任何 tableView 都可以用单列的 collectionView 进行实现/重构。
- tableView 在大屏幕上（如：iPad ）表现的不是特别好。

需要说明的是，我没有建议你把代码库里所有的 tableView 都用 collectionView 重新实现。我建议的是，当你需要添加一个展示列表的新功能时，你应该考虑下使用 collectionView 来代替 tableView 。尤其是在你开发一个 Universal APP 时，因为 collectionView 将让你的 APP 在所有尺寸屏幕上动态调整布局变得更简单。

### Swift 泛型与有效抽取的探索

我一直是泛型编程的拥趸，所以你能想象的到当苹果宣布在 Swift 中引进泛型时，我是多么的兴奋。但是泛型和协议结合有时并不合作的那么和谐。这时 Swift 2.x 中关于 [关联类型](https://www.natashatherobot.com/swift-what-are-protocols-with-associated-types/) 的介绍让使用泛型协议变得更加简单，越来越多的开发者开始去尝试使用它们。

我打算展示的代码抽取是基于对泛型使用的尝试，尤其是泛型协议。这样的代码抽取能够让我对设置 collectionView 所需的样板代码进行封装，从而减少设置数据源所需的代码，甚至在一些简单的使用场景两行代码就足够了。

我想说明下我所创建的不是通解。我做的代码封装针对于解决一些特定使用场景。对于这些场景来说，使用抽取封装后的代码效果非常好。对于一些复杂的使用场景，可能就需要添加额外的代码了。我把抽取工作主要放在了 collectionView 最常用的功能。如果需要的话，你可以封装更多的功能，但是对于我的特定场景来说，这并不是必需的。

作为本篇文章的目的，我将会展示一部分抽取代码来概括使用 collectionView 时常用的功能。这将是你了解使用泛型，尤其是泛型协议能够来做什么的一个好的机会。

### Collection View Cell 抽取

首先，我实现 collectionView 通常都是先创建展示数据的 cell 。处理 collectionView 的 cell 时通常需要：

- 重用 cell
- 配置 cell

为了简化上面的工作，我写了两个协议：

- ***ReusableCell***
- ***ConfigurableCell***

让我们详细地看一下这两个抽取后代码吧。

### ReusableCell

这个 **ReusableCell** 协议需要你定义一个 **重用标识符** ，这个标志符将在重用 cell 的时候被用到。在我的 APP 里，我总是图方便把 cell 的重用标识符设置为和 cell 的类名一样。因此，很容易通过创建一个协议扩展来抽取出，让 **reuseIdentifier** 返回一个带有类名称的字符串：

```
public protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
```

### ConfigurableCell

这个 **ConfigurableCell** 协议需要你实现一个方法，这个方法将使用特定类型的实例配置 cell ,而这个实例被定义成了一个泛型类型 **T**:

```
public protocol ConfigurableCell: ReusableCell {
    associatedtype T

    func configure(_ item: T, at indexPath: IndexPath)
}
```

这个 **ConfigurableCell** 协议将会在加载 cell 内容的时候被调用。接下来我会详细介绍一些细节，现在我就强调下一些地方：

1. **ConfigurableCell** 继承 **ReusableCell**

2. 绑定类型的使用（ **绑定类型 T** ）将 **ConfigurableCell** 定义为泛型协议。

### 数据源的抽取: CollectionDataProvider

现在，让我们把目光收回，再回想下设置 collection view 都需要做些什么。为了让 collection view 展示内容，我们需要遵循 **UICollectionViewDataSource** 协议。那么最先要做的常常是确定下来这些:

- 需要几组：**numberOfSections(in:)**
- 每组需要几行：**collectionView(_:numberOfItemsInSection:)**
- cell 的内容怎么加载 ：**collectionView(_:cellForItemAt:)**

将上述代理方法实现，会确保我们能够对指定 collectionView 的 cell 进行展示 。而对于我来说，这里是非常适合进行代码抽取的地方。

为了抽取和封装上述步骤，我创建了以下泛型协议：

```
public protocol CollectionDataProvider {
    associatedtype T

    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> T?

    func updateItem(at indexPath: IndexPath, value: T)
}
```

这个协议前三个方法是：

- ***numberOfSections()***
- ***numberOfItems(in:)***
- ***item(at:)***

他们指明了遵循 **UICollectionViewDataSource** 协议需要实现的代理方法列表。基于我有过一些当用户交互后需要更新数据源的使用场景，我在最后又加了一个 **(updateItem(at:, value:))** 方法。这个方法允许你在需要的时候更新底层数据。到这里，在 **CollectionDataProvider** 定义的方法满足了遵循 **UICollectionViewDataSource** 协议时需要实现的常用功能。

### 封装样板: CollectionDataSource

通过上面的抽取，现在可以开始实现一个基类，这个基类将被封装为 collectionView 创建数据源所需的常用样板。这就是最神奇地方！这个类的主要作用就是利用特定的 **CollectionDataProvider** 和 **UICollectionViewCell** 来满足遵循 **UICollectionViewDataSource** 协议所需要实现的方法。

这是这个类的定义：

```
open class CollectionDataSource<Provider: CollectionDataProvider, Cell: UICollectionViewCell>:
    NSObject,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    where Cell: ConfigurableCell, Provider.T == Cell.T
{ [...] }
```

它为我们做了很多事：

1. 这个类有一个公有属性，让我们能够将它扩展为指定 CollectionDataProvider 提供正确的实现。
2. 这是一个泛型的类，所以它需要特定的 **Provider (CollectionDataProvider)** 和 Cell **(UICollectionViewCell)** 对象进一步的定义来使用。
3. 这个类继承于 **NSObject** 基类，所以能够遵循 **UICollectionViewDataSource** 和 **UICollectionViewDelegate** 来进行抽取封装样板代码。
4. 这个类在以下场景使用的时候有一些特定限制：

- **UICollectionViewCell** 必须遵循 **ConfigurableCell** 协议。（ **Cell:** **ConfigurableCell** ）
- 特定类型 **T** 必须和 cell 跟 Provider 的 **T** 相同 (**Provider.T == Cell.T**)。

代码需要像下面一样对 **CollectionDataSource** 进行初始化和设置：

```
// MARK: - Private Properties
let provider: Provider
let collectionView: UICollectionView

// MARK: - Lifecycle
init(collectionView: UICollectionView, provider: Provider) {
    self.collectionView = collectionView
    self.provider = provider
    super.init()
    setUp()
}

func setUp() {
    collectionView.dataSource = self
    collectionView.delegate = self
}
```

代码是非常简单的：**CollectionDataSource** 需要知道它将针对哪个 collectionView 对象，将根据哪个作为数据提供者。这些问题都是通过 **init** 方法的参数进行传递确定的。在初始化的过程中，**CollectionDataSource** 将自己设置为 **UICollectionViewDataSource** 和 **UICollectionViewDelegate** 的代理对象(在 **setUp** 方法中)。

现在让我们看一下 **UICollectionViewDataSource** 代理的样板代码。

这是代码：

```
// MARK: - UICollectionViewDataSource
public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return provider.numberOfSections()
}

public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return provider.numberOfItems(in: section)
}

open func collectionView(_ collectionView: UICollectionView,
     cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
{
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
        for: indexPath) as? Cell else {
        return UICollectionViewCell()
    }
    let item = provider.item(at: indexPath)
    if let item = item {
        cell.configure(item, at: indexPath)
    }
    return cell
}
```

上面的代码片段通过 **CollectionDataProvider** 的一个对象展示了 **UICollectionViewDataSource** 代理的主要实现，就像之前所说的那样，它封装了数据源实现的所有细节。每个代理都使用指定的 **CollectionDataProvider** 方法来抽取跟数据源之间进行交互。

注意 **collectionView(_:cellForItemAt:)** 方法有一个公开的属性，这就能够让它的任何子类在需要对 cell 内容进行更多定制化的时候进行扩展。

现在对 collectionView cell 展示的功能已经做好了，让我们再为它添加更多的功能吧。

而作为第一个要添加的功能，用户应该能够在点击 cell 的时候触发某些操作。为了实现这个功能，一个简单的方案就是定义一个简单的 closure,并对这个 closure 初始化，当用户点击 cell 的时候执行这个 closure 。

处理 cell 点击的自定义 closure 如下所示：

```
public typealias CollectionItemSelectionHandlerType = (IndexPath) -> Void
```

现在，我们能定义个属性来存储这个 closure ，当用户点击这个 cell 的时候就会在 **UICollectionViewDelegate** 的 **collectionView(_:didSelectItemAt:)** 代理方法实现中执行这个初始化好的 closure 。

```
// MARK: - Delegates
public var collectionItemSelectionHandler: CollectionItemSelectionHandlerType?

// MARK: - UICollectionViewDelegate
public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionItemSelectionHandler?(indexPath)
}
```

作为第二个要添加的功能，我打算在 **CollectionDataSource** 中对多组组头和组的一些代码样板进行封装。这就需要实现 **UICollectionViewDataSource** 的代理方法 **viewForSupplementaryElementOfKind** 。为了能够让子类自定义的实现 **viewForSupplementaryElementOfKind** ，这个代理方法需要定义为公开方法，以便让任何子类能够对这个方法进行重写。

```
open func collectionView(_ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath) -> UICollectionReusableView
{
    return UICollectionReusableView(frame: CGRect.zero)
}
```

通常来说，这种方式适用于所有的代理方法，当他们需要被子类重写覆盖时，这些方法需要定义为公有方法，并在 **CollectionDataSource** 中实现。

另一种不同的解决方案就是使用一个自定义的 closure ，就像在 **(CollectionItemSelectionHandlerType)** 方法中处理 cell 点击事件一样。

我实现的这个特定方面是软件工程中的一个典型的权衡，一方面 —— 为 collectionView 设置数据源的主要细节都被隐藏（被抽取封装）。另一方面 —— 封装的样板代码中没有提供的功能，就会变得不能开箱即用，添加新的功能并不复杂，但是需要像我上面两个例子那样，需要实现更多的自定义代码。

### 实现一个具体的 CollectionDataProvider 也就是 ArrayDataProvider

现在样板代码已经设置好了，collectionView 的数据源由 **CollectionDataSource** 负责。让我们通过一个普通的使用案例来看看样板代码用起来有多方便。为了做这个，**CollectionDataSource** 对象需要提供 **CollectionDataProvider** 具体的实现。一个覆盖大多数常见使用案例的基本实现，可以简单地使用二维数组来包含展示 collectionView  cell 内容的数据 。作为我对数据源抽象的试验的一部分，我使这个实现变得更加通用，并且能够表示:

- 二维数组，每一个数组元素代表 collectionView 一组 cell 的内容。
- 数组，表示 collectionView 只有一组 cell 的内容（没有组头）。

上面的代码实现都包含在泛型类 **ArrayDataProvider** 中：

```
public class ArrayDataProvider<T>: CollectionDataProvider {
    // MARK: - Internal Properties
    var items: [[T]] = []

    // MARK: - Lifecycle
    init(array: [[T]]) {
        items = array
    }

    // MARK: - CollectionDataProvider
    public func numberOfSections() -> Int {
        return items.count
    }

    public func numberOfItems(in section: Int) -> Int {
        guard section >= 0 && section < items.count else {
            return 0
        }
        return items[section].count
    }

    public func item(at indexPath: IndexPath) -> T? {
        guard indexPath.section >= 0 &&
            indexPath.section < items.count &&
            indexPath.row >= 0 &&
            indexPath.row < items[indexPath.section].count else
        {
            return items[indexPath.section][indexPath.row]
        }
        return nil
    }

    public func updateItem(at indexPath: IndexPath, value: T) {
        guard indexPath.section >= 0 &&
            indexPath.section < items.count &&
            indexPath.row >= 0 &&
            indexPath.row < items[indexPath.section].count else
        {
            return
        }
        items[indexPath.section][indexPath.row] = value
    }
}
```

这样做可以提取访问数据源的细节，线性数据结构可以表示 cell 的内容是最常见的使用情况。

### 封装到一块: CollectionArrayDataSource

这样 **CollectionDataProvider** 协议就具体实现了，创建一个 **CollectionDataSource** 子类来实现最常见的简单的列表数据展示是非常容易的。

让我们从这个类的定义开始：

```
open class CollectionArrayDataSource<T, Cell: UICollectionViewCell>: CollectionDataSource<ArrayDataProvider<T>, Cell>
     where Cell: ConfigurableCell, Cell.T == T
 { [...] }
```

这个声明定义了很多事情：

1. 这个类有一个公有的属性，因为它最终将被扩展为 **UICollectionView** 对象的数据源对象。
2. 这是一个继承 **UICollectionViewCell** 的泛型类，需要被特定的类型 **T** 进一步定义才能正确展示 cell 和 cell 的内容。

3. 这个类扩展了 **CollectionDataSource** 来提供进一步的特定行为。

4. 特定类型 **T** 将被表示，它将通过一个 **ArrayDataProvider\<T\>** 对象来访问 cell 内容。

5. 这个类在 closure 中的定义表明有些特定的约束:

- **UICollectionViewCell** 必须遵循 **ConfigurableCell** 协议。（ **Cell:** **ConfigurableCell** ）
- cell 中的特定类型 **T** 必须跟 Provider 的 **T** 相同  (**Provider.T == Cell.T**) 。

类的实现非常简单：

```
// MARK: - Lifecycle
public convenience init(collectionView: UICollectionView, array: [T]) {
   self.init(collectionView: collectionView, array: [array])
}

public init(collectionView: UICollectionView, array: [[T]]) {
   let provider = ArrayDataProvider(array: array)
   super.init(collectionView: collectionView, provider: provider)
}

// MARK: - Public Methods
public func item(at indexPath: IndexPath) -> T? {
   return provider.item(at: indexPath)
}

public func updateItem(at indexPath: IndexPath, value: T) {
   provider.updateItem(at: indexPath, value: value)
}
```

它只是提供了一些初始化方法和与交互方法，这些方法使我们能够让数据提供者与数据源透明地进行读取和写入操作。

### 创建一个基本的 CollectionView

可以将 **CollectionArrayDataSource** 基类扩展，为任何可以用二维数组展示的 collection view 创建一个特定的数据源。

```
class PhotosDataSource: CollectionArrayDataSource<PhotoViewModel, PhotoCell> {}
```

声明比较简单:

1. 继承于 **CollectionArrayDataSource** 。
2. 这个类表示 **PhotoViewModel** 作为特定类型 **T** 将会展示 cell 内容，可通过 **ArrayDataProvider\<PhotoViewModel\>** 对象访问，**PhotoCell** 将作为 **UICollectionViewCell** 展示。

请注意，**PhotoCell** 必须遵守 **ConfigurableCell** 协议，并且能够通过 **PhotoViewModel** 实例初始化它的属性。

创建一个 **PhotosDataSource** 对象是非常简单的。只需要传递过去将要展示的 collectionView 和由展示每个 cell 内容的 **PhotoViewModel** 元素组成的数组：

```
let dataSource = PhotosDataSource(collectionView: collectionView, array: viewModels)
```

**collectionView** 参数通常是 storyboard 上的 collectionView 通过 outlet 指向获取到的。

所有的就完成了！两行代码就可以设置一个基本的 collectionView 数据源。

### 设置带有组标题和组的 CollectionView

对于更高级和复杂的用例，你可以简单在 [GitHub repo](https://github.com/andrea-prearo/GenericDataSource) 上查看 **TaskList** 。内容已经很长了，本文就不再不介绍示例的更多细节。我将在下一篇 *“Collection View with Headers and Sections”* 文章里进行深入地探讨。在这个说明中，如果存在一个话题对你来说很有意思，请不要犹豫让我知道，这样我就可以优先考虑下一步写什么。为了和我联系，请在这篇文章下方留言或发邮件给我: [andrea.prearo@gmail.com](mailto:andrea.prearo@gmail.com) 。

### 结论

在这篇文章中，我介绍了一些我做的抽取封装，以简化使用泛型数据源的 collectionView 。所提出的实现都是基于我在构建 iOS app 时遇到的重复代码的场景。一些更高级的的功能可能需要进一步的自定义。我相信，继续优化所得到的代码抽取，或者构建新的代码抽取，来简化处理不同的 collectionView 模式都是可能的。但这已经超出了这篇文章的范围。

所有的通用数据源代码和示例工程都在 [GitHub](https://github.com/andrea-prearo/GenericDataSource) 并且是遵守 MIT 协议的。你可以直接使用和修改它们。欢迎所有的反馈意见和建议的贡献，并非常感谢你这么做。如果你有足够的兴趣，我将很乐意添加所需的配置，使代码与Cocoapods和Carthage一起使用，并允许使用这种依赖关系管理工具导入通用数据源。或者，这可能是一个很好的起点去为这个项目做出贡献。

---

#### 额外链接

- [Smooth Scrolling in UITableView and UICollectionView](https://medium.com/capital-one-developers/smooth-scrolling-in-uitableview-and-uicollectionview-a012045d77f)
- [Boost Smooth Scrolling with iOS 10 Pre-Fetching API](https://medium.com/capital-one-developers/boost-smooth-scrolling-with-ios-10-pre-fetching-api-818c25cd9c5d)

**披露声明：这些意见是作者的意见。 除非在文章中额外声明，否则 Capital One 版权不属于任何所提及的公司，也不属于任何上述公司。 使用或显示的所有商标和其他知识产权均为其各自所有者的所有权。 本文版权为 ©2017 Capital One**

更多关于 API、开源、社区活动或开发文化的信息，请访问我们的一站式开发网站  [**developer.capitalone.com**](https://developer.capitalone.com/) 。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
