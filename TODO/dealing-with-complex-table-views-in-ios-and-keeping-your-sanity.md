
> * 原文地址：[Dealing with Complex Table Views in iOS and Keeping Your Sanity](https://medium.cobeisfresh.com/dealing-with-complex-table-views-in-ios-and-keeping-your-sanity-ff5fee1fbb83)
> * 原文作者：[Marin Benčević](https://medium.cobeisfresh.com/@marinbenc?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/dealing-with-complex-table-views-in-ios-and-keeping-your-sanity.md](https://github.com/xitu/gold-miner/blob/master/TODO/dealing-with-complex-table-views-in-ios-and-keeping-your-sanity.md)
> * 译者：[zhangqippp](https://github.com/zhangqippp)

# 处理 iOS 中复杂的 Table Views 并保持优雅

Table views 是 iOS 开发中最重要的布局组件之一。通常我们的一些最重要的页面都是 table views：feed 流，设置页，条目列表等。

每个开发复杂的 table view 的 iOS 开发者都知道这样的 table view 会使代码很快就变的很粗糙。这样会产生包含大量 `UITableViewDataSource` 方法和大量 if 和 switch 语句的巨大的 view controller。加上数组索引计算和偶尔的越界错误，你会在这些代码中遭受很多挫折。

我会给出一些我认为有益（至少在现在是有益）的原则，它们帮助我解决了很多问题。这些建议并不仅仅针对复杂的 table view，对你所有的 table view 来说它们都能适用。

我们来看一下一个复杂的 `UITableView` 的例子。

![](https://cdn-images-1.medium.com/max/2000/1*qzuG8HnLA5c5qA2HbP6jAA.png)

这些很棒的截屏插图来自 [LazyAmphy](https://lazyamphy.deviantart.com/)

这是 PokeBall，一个为 Pokémon 定制的社交网络。像其它社交网络一样，它需要一个 feed 流来显示跟用户相关的不同事件。这些事件包括新的照片和状态信息，按天进行分组。所以，现在我们有两个需要担心的问题：一是 table view 有不同的状态，二是多个 cell 和 section。

## 1. 让 cell 处理一些逻辑

我见过很多开发者将 cell 的配置逻辑放到  `cellForRowAt:` 方法中。仔细思考一下，这个方法的目的是创建一个 cell。`UITableViewDataSource` 的目的是提供数据。**数据源的作用不是用来设置按钮字体的。**

```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(
    withIdentifier: identifier,
    for: indexPath) as! StatusTableViewCell
  
  let status = statuses[indexPath.row]
  cell.statusLabel.text = status.text
  cell.usernameLabel.text = status.user.name
  
  cell.statusLabel.font = .boldSystemFont(ofSize: 16)
  return cell
}
```

你应该把配置和设置 cell 样式的代码放到 cell 中。如果是一些在 cell 的整个生命周期都存在的东西，例如一个 label 的字体，就应该把它放在 `awakeFromNib` 方法中。

```
class StatusTableViewCell: UITableViewCell {
  
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    statusLabel.font = .boldSystemFont(ofSize: 16)
  }
}
```

另外你也可以给属性添加观察者来设置 cell 的数据。

```
var status: Status! {
  didSet {
    statusLabel.text = status.text
    usernameLabel.text = status.user.name
  }
}
```

那样的话你的 `cellForRow` 方法就变得简洁易读了。

```
func tableView(_ tableView: UITableView, 
  cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(
    withIdentifier: identifier,
    for: indexPath) as! StatusTableViewCell
  cell.status = statuses[indexPath.row]
  return cell
}
```

此外，cell 的设置逻辑现在被放置在一个单独的地方，而不是散落在 cell 和 view controller 中。

## 2. 让 model 处理一些逻辑

通常，你会用从某个后台服务中获取的一组 model 对象来填充一个 table view。然后 cell 需要根据 model 来显示不同的内容。

```
var status: Status! {
  didSet {
    statusLabel.text = status.text
    usernameLabel.text = status.user.name
    
    if status.comments.isEmpty {
      commentIconImageView.image = UIImage(named: "no-comment")
    } else {
      commentIconImageView.image = UIImage(named: "comment-icon")
    }
    
    if status.isFavorite {
      favoriteButton.setTitle("Unfavorite", for: .normal)
    } else {
      favoriteButton.setTitle("Favorite", for: .normal)
    }
  }
}
```

你可以创建一个适配 cell 的对象，传入上文提到的 model 对象来初始化它，在其中计算 cell 中需要的标题，图片以及其它属性。

```
class StatusCellModel {
  
  let commentIcon: UIImage
  let favoriteButtonTitle: String
  let statusText: String
  let usernameText: String
  
  init(_ status: Status) {
    statusText = status.text
    usernameText = status.user.name
    
    if status.comments.isEmpty {
      commentIcon = UIImage(named: "no-comments-icon")!
    } else {
      commentIcon = UIImage(named: "comments-icon")!
    }
    
    favoriteButtonTitle = status.isFavorite ? "Unfavorite" : "Favorite"
  }
}
```

现在你可以将大量的展示 cell 的逻辑移到 model 中。你可以独立地实例化并单元测试你的 model 了，不需要在单元测试中做复杂的数据模拟和 cell 获取了。这也意味着你的 cell 会变得非常简单易读。

```
var model: StatusCellModel! {
  didSet {
    statusLabel.text = model.statusText
    usernameLabel.text = model.usernameText
    commentIconImageView.image = model.commentIcon
    favoriteButton.setTitle(model.favoriteButtonTitle, for: .normal)
  }
}
```

这是一种类似于 [MVVM](http://artsy.github.io/blog/2015/09/24/mvvm-in-swift/) 的模式，只是应用在一个单独的 table view 的 cell 中。

## 3. 使用矩阵（但是把它弄得漂亮点）

![Just a regular iOS developer making some table views](https://cdn-images-1.medium.com/max/1600/1*EnFp796gd61cMcpnUv3Vcg.jpeg)

分组的 table view 经常乱成一团。你见过下面这种情况吗？

```
func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
  switch section {
  case 0: return "Today"
  case 1: return "Yesterday"
  default: return nil
  }
}
```

这一大团代码中，使用了大量的硬编码的索引，而这些索引本应该是简单并且易于改变和转换的。对这个问题有一个简单的解决方案：矩阵。

记得矩阵么？搞机器学习的人以及一年级的计算机科学专业的学生会经常用到它，但是应用开发者通常不会用到。如果你考虑一个分组的 table view，其实你是在展示分组的列表。每个分组是一个 cell 的列表。听起来像是一个数组的数组，或者说矩阵。

![](https://cdn-images-1.medium.com/max/1600/1*DrkAd_ssNhl2ezokmXH_Zg.png)

矩阵才是你组织分组 table view 的正确姿势。用数组的数组来替代一维的数组。 `UITableViewDataSource` 的方法也是这样组织的：你被要求返回第 m 组的第 n 个 cell，而不是 table view 的第 n 个 cell。

```
var cells: [[Status]] = [[]]
  
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(
    withIdentifier: identifier,
    for: indexPath) as! StatusTableViewCell
  cell.status = statuses[indexPath.section][indexPath.row]
  return cell
}
```

我们可以通过定义一个分组容器类型来扩展这个思路。这个类型不仅持有一个特定分组的 cell，也持有像分组标题之类的信息。

```
struct Section {
  let title: String
  let cells: [Status]
}
var sections: [Section] = []
```

现在我们可以避免之前 switch 中使用的硬编码索引了，我们定义一个分组的数组并直接返回它们的标题。

```
func tableView(_ tableView: UITableView, 
  titleForHeaderInSection section: Int) -> String? {
  return sections[section].title
}
```

这样在我们的数据源方法中代码更少了，相应地也减少了越界错误的风险。代码的表达力和可读性也变得更好。

## 4. 枚举是你的朋友

处理多种 cell 的类型有时候会很棘手。例如在某种 feed 流中，你不得不展示不同类型的 cell，像是图片和状态信息。为了保持代码优雅以及避免奇怪的数组索引计算，你应该将各种类型的数据存储到同一个数组中。

然而数组是同质的，意味着你不能在同一个数组中存储不同的类型。面对这个问题首先想到的解决方案是协议。毕竟 Swift 是面向协议的。

你可以定义一个 FeedItem 协议，并且让我们的 cell 的 model 对象都遵守这个协议。

```
protocol FeedItem {}
struct Status: FeedItem { ... }
struct Photo: FeedItem { ... }
```

然后定义一个持有 FeedItem 类型对象的数组。

```
var cells: [FeedItem] = []
```

但是，用这个方案实现 cellForRowAt: 方法时，会有一个小问题。

```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cellModel = cells[indexPath.row]
  
  if let model = cellModel as? Status {
    let cell = ...
    return cell
  } else if let model = cellModel as? Photo {
    let cell = ...
    return cell
  } else {
    fatalError()
  }
}
```

在让 model 对象遵守协议的同时，你丢失了大量你实际上需要的信息。你对 cell 进行了抽象，但是实际上你需要的是具体的实例。所以，你最终必须检查是否可以将 model 对象转换成某个类型，然后才能据此显示 cell。

这样也能达到目的，但是还不够好。向下转换对象类型内在就是不安全的，而且会产生可选类型。你也无法得知是否覆盖了所有的情况，因为有无限的类型可以遵守你的协议。所以你还需要调用 `fatalError` 方法来处理意外的类型。

当你试图把一个协议类型的实例转化成具体的类型时，代码的味道就不对了。使用协议是在你不需要具体的信息时，只要有原始数据的一个子集就能完成任务。

更好的实现是使用枚举。那样你可以用 switch 来处理它，而当你没有处理全部情况时代码就无法编译通过。

```
enum FeedItem {
  case status(Status)
  case photo(Photo)
}
```

枚举也可以具有关联的值，所以也可以在实际的值中放入需要的数据。

数组依然是那样定义，但你的 `cellForRowAt:` 方法会变的清爽很多：

```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cellModel = cells[indexPath.row]
  
  switch cellModel {
  case .status(let status):
    let cell = ... 
    return cell
  case .photo(let photo):
    let cell = ...
    return cell
  }
}
```

这样你就没有类型转换，没有可选类型，没有未处理的情况，所以也不会有 bug。

## 5. 让状态变得明确

![](https://cdn-images-1.medium.com/max/2000/1*qzuG8HnLA5c5qA2HbP6jAA.png)

这些很棒的截屏插图来自 [LazyAmphy](https://lazyamphy.deviantart.com/)

空白的页面可能会使用户困惑，所以我们一般在 table view 为空时在页面上显示一些消息。我们也会在加载数据时显示一个加载标记。但是如果页面出了问题，我们最好告诉用户发生了什么，以便他们知道如何解决问题。

我们的 table view 通常拥有所有的这些状态，有时候还会更多。管理这些状态就有些痛苦了。

我们假设你有两种可能的状态：显示数据，或者一个提示用户没有数据的视图。初级开发者可能会简单的通过隐藏 table view，显示无数据视图来表明“无数据”的状态。

```
noDataView.isHidden = false
tableView.isHidden = true
```

在这种情况下改变状态意味着你要修改两个布尔值属性。在 view controller 的另一部分中，你可能想修改这个状态，你必须牢记你要同时修改这两个属性。

实际上，这两个布尔值总是同步变化的。不能显示着无数据视图的时候，又在列表里显示一些数据。

我们有必要思考一下实际中状态的数值和应用中可能出现的状态数值有何不同。**两个布尔值有四种可能的组合。**这表示你有两种无效的状态，在某些情况下你可能会变成这些无效的状态值，你必须处理这种意外情况。

你可以通过定义一个 `State` 枚举来解决这个问题，枚举中只列举你的页面可能出现的状态。

```
enum State {
  case noData
  case loaded
}
var state: State = .noData
```

你也可以定义一个单独的 `state` 属性，来作为修改页面状态的唯一入口。每当该属性变化时，你就更新页面到相应的状态。

```
var state: State = .noData {
  didSet {
    switch state {
    case .noData:
      noDataView.isHidden = false
      tableView.isHidden = true
    case .loaded:
      noDataView.isHidden = false
      tableView.isHidden = true
    }
  }
}
```

如果你只通过这个属性来修改状态，就能保证不会忘记修改某个布尔值属性，也就不会使页面处于无效的状态中。现在改变页面状态就变得简单了。

```
self.state = .noData
```

可能的状态数量越多，这种模式就越有用。
你甚至可以通过关联值将错误信息和列表数据都放置在枚举中。

```
enum State {
  case noData
  case loaded([Cell])
  case error(String)
}
var state: State = .noData {
  didSet {
    switch state {
    case .noData:
      noDataView.isHidden = false
      tableView.isHidden = true
      errorView.isHidden = true
    case .loaded(let cells):
      self.cells = cells
      noDataView.isHidden = true
      tableView.isHidden = false
      errorView.isHidden = true
    case .error(let error):
      errorView.errorLabel.text = error      
      noDataView.isHidden = true
      tableView.isHidden = true
      errorView.isHidden = false
    }
  }
}
```

至此你定义了一个单独的数据结构，它完全满足了整个 table view controller 的数据需求。它[
易于测试](https://medium.cobeisfresh.com/unit-testing-in-swift-part-1-the-philosophy-9bc85ed5001b)（因为它是一个纯 Swift 值），为 table view 提供了一个**唯一更新入口**和**唯一数据源**。欢迎来到易于调试的新世界！

## 几点建议

还有几点不值得单独写一节的小建议，但是它们依然很有用：

**响应式！**

确保你的 table view 总是展示数据源的当前状态。使用一个属性观察者来刷新 table view，不要试图手动控制刷新。

```
var cells: [Cell] = [] {
  didSet {
    tableView.reloadData()
  }
}
```

**Delegate != View Controller**

任何对象和结构都可以实现某个协议！你下次写一个复杂的 table view 的数据源或者代理时一定要记住这一点。有效而且更优的做法是定义一个类型专门用作 table view 的数据源。这样会使你的 view controller 保持整洁，把逻辑和责任分离到各自的对象中。

**不要操作具体的索引值！**

如果你发现自己在处理某个特定的索引值，在分组中使用 switch 语句以区别索引值，或者其它类似的逻辑，那么你很有可能做了错误的设计。如果你在特定的位置需要特定的 cell，你应该在源数据的数组中体现出来。不要在代码中手动地隐藏这些 cell。

**牢记迪米特法则**

简而言之，迪米特法则（或者最少知识原则）指出，在程序设计中，实例应该只和它的朋友交谈，而不能和朋友的朋友交谈。等等，这是说的啥？

换句话说，一个对象只应访问它自身的属性。不应该访问其属性的属性。因此， `UITableViewDataSource` 不应该设置 cell 的 label 的 `text` 属性。如果你看见一个表达式中有两个点（`cell.label.text = ...`），通常说明你的对象访问的太深入了。

如果你不遵循迪米特法则，当你修改 cell 的时候你也不得不同时修改数据源。将 cell 和数据源解耦使得你在修改其中一项时不会影响另一项。

**小心错误的抽象**

有时候，多个相近的 `UITableViewCell 类` 会比一个包含大量 if 语句的 cell 类要好得多。你不知道未来它们会如何分歧，抽象它们可能会是设计上的陷阱。YAGNI（你不会需要它）是个好的原则，但有时候你会实现成 YJMNI（你只是可能需要它）。

希望这些建议能帮助你，我确信你肯定会有下一次做 table view 的时候。这里还有一些扩展阅读的资源可以给你更多的帮助：

- [迪米特法则](https://en.wikipedia.org/wiki/Law_of_Demeter)
- [错误的抽象](https://www.sandimetz.com/blog/2016/1/20/the-wrong-abstraction?duplication)
- [你并不需要它](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it)

如果你有任何问题或建议，欢迎在下方留言。

Marin 是 COBE 的一名 iOS 开发人员，一名[博主](https://medium.cobeisfresh.com/marinbenc.com)和一名计算机科学学生。他喜欢编程，学习东西，然后写下它们，还喜欢骑自行车和喝咖啡。大多数情况下，他只会把 SourceKit 搞崩溃。他有一只叫 Amigo 的胖猫。他基本上不是靠自己写完的这篇文章。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
