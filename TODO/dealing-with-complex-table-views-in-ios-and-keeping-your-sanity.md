
> * 原文地址：[Dealing with Complex Table Views in iOS and Keeping Your Sanity](https://medium.cobeisfresh.com/dealing-with-complex-table-views-in-ios-and-keeping-your-sanity-ff5fee1fbb83)
> * 原文作者：[Marin Benčević](https://medium.cobeisfresh.com/@marinbenc?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/dealing-with-complex-table-views-in-ios-and-keeping-your-sanity.md](https://github.com/xitu/gold-miner/blob/master/TODO/dealing-with-complex-table-views-in-ios-and-keeping-your-sanity.md)
> * 译者：
> * 校对者：

# Dealing with Complex Table Views in iOS and Keeping Your Sanity

Table views are one of the most important layout components in iOS development. Usually some of our most important screens are table views: feeds, settings, lists of items etc.

Every iOS developer that’s worked on a complex table view knows that it can get pretty gnarly pretty quickly. Huge view controllers with massive `UITableViewDataSource` methods and tons of ifs and switch statements. Add to that array index math and the occasional, very fun, out of bounds error and you’ve got yourself a nice sandwich of frustration.

I’ve come to a set of principles that I am (at least of the time being) somewhat happy with, which help me get over these problems. The good thing about these tips is that they’re not only for complex table views, but are also good pieces of advice to apply on all your table views.

Let’s look at an example of a complex `UITableView`.

![](https://cdn-images-1.medium.com/max/2000/1*qzuG8HnLA5c5qA2HbP6jAA.png)

The awesome selfie illustration is by [LazyAmphy](https://lazyamphy.deviantart.com/)

This is PokeBall, a social network for Pokémon. Like all social networks, it needs a feed that shows different events relevant to the user. These events include new photos and status messages, grouped by day. So, we have two axes to worry about here: the table view has different states, and multiple cells and sections.

## 1. Make the cell do the work

I see a lot of developers putting cell configuration inside their `cellForRowAt:` method. When you think about it, that method’s purpose is to create a cell. The `UITableViewDataSource`’s purpose is to supply data. **The data source is not supposed to set the font on a button.**

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

You should put the code needed to style and configure a cell inside the actual cell. If it’s something that’s going to be there during the whole lifecycle of the cell, like a label’s font, put it in the `awakeFromNib` method.

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

Otherwise you can use property observers to set the data of the cell.

```
var status: Status! {
  didSet {
    statusLabel.text = status.text
    usernameLabel.text = status.user.name
  }
}
```

That way your `cellForRow` method is clear, readable and concise.

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

What’s more, cell-specific logic is now in a single place, instead of being scattered between the cell and the view controller.

## 2. Make the model do the work

Usually, you fill a table view with an array of model objects that you’ve got from some sort of a backend service. A cell then needs to make changes on itself based on that model.

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

You can create a cell-specific model which you will initialize with your model object, and it will compute titles, images and other properties for the cell.

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

Now you can move a lot of the logic of presenting the cell to the model itself. You can then instantiate and unit test the model separately, without having to do complex mocking and fetching cells in your unit tests. This also means that your cells are dead-simple and easy to read.

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

This is a similar pattern to [MVVM](http://artsy.github.io/blog/2015/09/24/mvvm-in-swift/), but applied to a single table view cell.

## 3. See the matrix (but make it prettier)

![Just a regular iOS developer making some table views](https://cdn-images-1.medium.com/max/1600/1*EnFp796gd61cMcpnUv3Vcg.jpeg)

Sectioned table views are usually a huge mess. Have you ever seen this?

```
func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
  switch section {
  case 0: return "Today"
  case 1: return "Yesterday"
  default: return nil
  }
}
```

This is a lot of code, and a lot of hard-coded indices for something that should be pretty simple and easy to change and swap around. There’s an easy solution for this problem: a matrix.

Remember matrices? It’s something Machine Learning people and first-year Computer Science students use, but app developers usually don’t. Yet, if you think of a sectioned table view, what’s really happening is that you’re presenting a list of sections. Each section is a list of cells. That sounds like an array of arrays, or a matrix.

![](https://cdn-images-1.medium.com/max/1600/1*DrkAd_ssNhl2ezokmXH_Zg.png)

That’s the way you should model sectioned table views. Instead of a flat array, use an array of arrays. That’s how `UITableViewDataSource` methods are structured: you're asked to return the nth cell of mth section, and not the nth cell in the table view itself.

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

We can then expand on this concept, by defininig a Section container type. This type will not only hold the cells for a specific section, but also things like the section title.

```
struct Section {
  let title: String
  let cells: [Status]
}
var sections: [Section] = []
```

Now we can avoid having hard-coded indices that we switch on, and can instead define an array of sections and return their titles directly.

```
func tableView(_ tableView: UITableView, 
  titleForHeaderInSection section: Int) -> String? {
  return sections[section].title
}
```

This way, we have less code in our data source methods, and thus less potential for out-of-bounds errors. The code also becomes more expressive and readable.

## 4. Enums are your friend

Working with multiple cell types can be really tricky. Consider some sort of feed, where you have to show different types of cells, like photos and statuses. To keep your sanity and avoid weird array index math, you should store both of these in the same array.

However, arrays are homogenuous, which means you can’t have an array of different types. The first solution that comes to mind are protocols. Swift is protocol-oriented, after all!

You can define a protocol FeedItem, and make sure our cells’ models conform to that protocol.

```
protocol FeedItem {}
struct Status: FeedItem { ... }
struct Photo: FeedItem { ... }
```

Then you can define an array of `FeedItem`s.

```
var cells: [FeedItem] = []
```

However, when implementing cellForRowAt: with this solution, we can see a small problem.

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

In upcasting the models to a protocol, you’ve lost a lot of information that you actually need. You have abstracted away your cells, but you actually need concrete instances. So, you end up having to check whether you can cast into a type, and then display a cell based on that.

This will work, but it’s not pretty. Downcasting is inherently unsafe and leads to optionals. You also don’t know if you’ve covered all cases or not, because an infinite number of types can implement your protocol. That’s why you need to call `fatalError` if you get an unexpected type.

When you try to cast an instance of a protocol into a concrete type, it’s usually code smell. Protocols are there when you don’t need specific information, but can instead work with a subset of the original data.

A better approach would be to use an enum. That way you can switch on it, and the code won’t compile if you haven’t handled all cases.

```
enum FeedItem {
  case status(Status)
  case photo(Photo)
}
```

Enums can also have associated values, so you can put the data you need inside the actual enum value.

Your array definition stays the same, but your `cellForRowAt:`method now looks much cleaner:

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

This way, you have no casting, no optionals and no unhandled cases, so we have no bugs.

## 5. Make the state explicit

![](https://cdn-images-1.medium.com/max/2000/1*qzuG8HnLA5c5qA2HbP6jAA.png)

The awesome selfie illustration is by [LazyAmphy](https://lazyamphy.deviantart.com/)

Because it’s confusing to see a blank screen, we usually show some sort of a message when the table view is empty. We also show an indicator while the data is loading. However, if things are amiss, it would be nice to tell the user what’s up so that they know how to fix the problem.

Our table views often have all these states, and more. Managing them can be painful.

Let’s say you have two possible states: either you show the data, or a no-data view. A naive developer would show the “no data” state by simply hiding the table view, and showing the no data view.

```
noDataView.isHidden = false
tableView.isHidden = true
```

Changing state in this case means you have to change two boolean properties. In another part of the view controller, you might want to set the state to something else, and you need to remember to set both properties.

In reality, those two bools should always be in sync. You can’t have the no data view up, and also be showing some data.

It’s useful to think of the difference between real-world number of states, and the possible number of states in your app. **Two boolean values have four possible combinations**. This means that you have two invalid states that you can accidentally enter, and that you need to handle.

You can work around this by defining a `State` enum that will encompass all the possible states your screen can be in.

```
enum State {
  case noData
  case loaded
}
var state: State = .noData
```

You can also define a single `state` property, which will be the only way to change the state of the screen. Every time that property gets changed, you will update the screen to show that state.

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

If you only ever modify the state trough this property, you can be sure that you’ll never forget to update a property, and will never enter invalid states. Changing the state is now simple.

```
self.state = .noData
```

The more possible states you have, the more useful this pattern is.
You can even improve this by using associated values for our error message and our items.

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

This way you have defined a single data structure that is a complete representation of our table view controller. It’s [easily testable](https://medium.cobeisfresh.com/unit-testing-in-swift-part-1-the-philosophy-9bc85ed5001b) (since it’s a pure Swift value), and provides a **single point of update** and a **single source of truth** for our table view. Welcome to a brave new world of easy debugging!

## Quick tips

Here are some more minor tips that didn’t warrant their own section, but are still really useful:

**Be reactive!**

Make sure the table view always represents the current state of the source array. Use a property observer to refresh the table view, don’t try to keep them in sync manually.

```
var cells: [Cell] = [] {
  didSet {
    tableView.reloadData()
  }
}
```

**Delegate != View Controller**

Anything and anyone can implement a protocol! Remember that next time you’re writing a complex table view data source or delegate. It’s perfectly valid (and better) to define a type whose sole purpose is to be a table view’s data source. This keeps your view controller clean, and separates logic and responsibilities into their respective objects.

**Never assume indices!**

If you ever find yourself checking the index path for a specific index, switching on the section, or some other sorcery like that, you are most likely doing something wrong. If you have specific cells at specific places, represent that in your source array. Don’t hide those cells in your code.

**Remember the Law of Demeter**

In short, the Law of Demeter (or principle of least knowledge) states that, in programming, friends should only talk to their friends, not their friends’ friends. Wait, what?

In other words, this means that one object should only ever access its properties. The properties of those properties should be left alone. So, the `UITableViewDataSource` should not set the `text`property of the cell's label. If you see two dots in one expression (`cell.label.text = ...`), it usually means you know too much.

If you don’t follow the Law of Demeter, changing the cell would also mean you have to change the data source. Decoupling the cell from the data source allows you to change and refactor one without affecting the other.

**Beware of Wrong Abstractions**

Sometimes it’s better to have multiple similar `UITableViewCellclasses` than a single class with a bunch of if statements. You never know how they will diverge in the future, and abstracting them can be a trap. YAGNI (You Aren't Gonna Need It) is a good principle to follow, but sometimes YJMNI (You Just Might Need It).

I hope these tips will help you keep the gorgeous set of hair I’m sure you have next time you’re making a table view. Here’s some extra reading for you to help you even more:

- [Law of Demeter](https://en.wikipedia.org/wiki/Law_of_Demeter)
- [The Wrong Abstraction](https://www.sandimetz.com/blog/2016/1/20/the-wrong-abstraction?duplication)
- [You aren’t gonna need it](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it)

If you have any questions or comments, feel free to comment below.

Marin is an iOS developer at COBE, a [blogger](https://medium.cobeisfresh.com/marinbenc.com), and a Computer Science student. He likes to program, learn about stuff and then write about them, ride bicycles and drink coffee. Mostly, though, he just causes SourceKit crashes. He has a chubby cat called Amigo. He totally didn’t write this bio himself.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
