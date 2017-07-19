
> * 原文地址：[Generic Data Sources in Swift](https://medium.com/capital-one-developers/generic-data-sources-in-swift-c6fbb531520e)
> * 原文作者：[Andrea Prearo](https://medium.com/@andrea.prearo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/generic-data-sources-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO/generic-data-sources-in-swift.md)
> * 译者：
> * 校对者：

# Generic Data Sources in Swift

![](https://cdn-images-1.medium.com/max/1600/1*Lv_C7Y7otRuJyQb5_v35Pw.gif)

In the vast majority of iOS apps I’ve been working on, table views and collection views have been the most commonly used UI components. As setting up a table view or collection view requires a lot of boilerplate, I have recently spent some time looking into a good way to avoid writing the same code over and over and over. My effort was focused on trying to encapsulate the required boilerplate by means of a set of abstractions. Over time, many other developers have worked on this problem and, with the recent advances to [Swift](https://github.com/apple/swift/blob/master/CHANGELOG.md), a lot of interesting approaches have been developed.

In this post, I am going to illustrate the approach I have been using for some time to reduce the amount of boilerplate required for setting up collection views in my apps.

### Table View vs Collection View

*“Why only talk about collection views and not table views?”* some of you may ask.

For the last few months, I have been using collection view in every instance where, previously, I could have used table view. So far it has been working great! It’s helped me avoid the sort of duality that comes from using two concepts that are *almost* similar but not quite the same. The rationale behind my decision is as follows:

- Any table view can always be implemented/refactored as a collection view with one column.
- Table views don’t work well on large screens (e.g.: iPad).

I would like to point out that I am not suggesting that you should go through your codebase and re-implement all table views as collection views. What I am suggesting is that, if you need to add a **new feature** that requires displaying a list of items, you should consider using a collection view instead of a table view. Especially if you are working on a universal app, as a collection view will likely make it is easier to work with all screen sizes by dynamically adjusting the layout.

### Swift Generics and the Search for Useful Abstractions

I have always been a fan of generic programming, so you can imagine I was pretty excited when Apple introduced generics in Swift. However, generics and protocols have not been working well together for some time. Then, with the introduction of [associated types](https://www.natashatherobot.com/swift-what-are-protocols-with-associated-types/) in Swift 2.x, creating generic protocols became much easier and many developers started experimenting with them.

The abstractions that I am going to present started out as an experiment with using generics, and in particular, generic protocols. Such abstractions allowed me to encapsulate the boilerplate required to set up collection views, and to reduce the code required to create a data source for collection views to two lines of code for simple use cases.

I’d like to point out that what I have built is not a silver bullet. The abstractions I implemented are focused on solving a set of specific use cases. For those cases, they do a reasonably good job of simplifying the code required to set up collection views. For some more complicated use cases, additional code may be required. I mainly focused on hiding away the most common functionality related to collection views. More functionality could be encapsulated, if needed, but that wasn’t required for my specific use cases.

For the purpose of this post, I will present a few abstractions that cover the functionality that is commonly required when working with a collection view. This should be a good starting point to illustrate what you can build using generics and, in particular, generic protocols.

### Collection View Cell Abstractions

The first step I usually take in implementing a collection view is to create the cell that I am going to use to display the required data. What is always required when dealing with a cell in a collection view is to:

- Dequeue the cell
- Configure the cell

To simplify the above tasks, I created two protocols:

- ***ReusableCell***
- ***ConfigurableCell***

Let’s take a look at the details of the above abstractions.

### ReusableCell

The ***ReusableCell*** protocol requires you define a ***reuseIdentifier*** that will be used when dequeueing the cell. In my apps, I usually adopt the convention that the cell identifier is the same as the cell class name. Therefore, it is easy to abstract this away by creating a protocol extension that makes ***reuseIdentifier*** return a string with the class name:

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

The ***ConfigurableCell*** protocol requires you implement a method that will be used to configure the cell using an instance of a specific type, which is declared as generic type*** T***:

```
public protocol ConfigurableCell: ReusableCell {
    associatedtype T

    func configure(_ item: T, at indexPath: IndexPath)
}
```

The ***ConfigurableCell ***protocol will be used when it is time to load cell content. I will go into some of its details in a bit. For the time being, I’d just like to highlight a couple of things:

1. ***ConfigurableCel***l extends ***ReusableCell***

2. The use of the associated type (***associatedtype T***) defines ***ConfigurableCell ***as a generic protocol

### Abstracting the Data Source: CollectionDataProvider

Now, let’s go back for a moment to what is required to set up a collection view. In order for the collection view to display any content, we need to conform to the ***UICollectionViewDataSource*** protocol. The first steps usually required are related to specifying:

- The number of sections: ***numberOfSections(in:)***
- The number of rows per section: ***collectionView(_:numberOfItemsInSection:)***
- How to load cell content: ***collectionView(_:cellForItemAt:)***

The above steps implement the delegates that make sure we are able to display cells for a specific collection view. Therefore, to me, this looked like a good place for building an abstraction.

To abstract and encapsulate the above steps, I created the following generic protocol:

```
public protocol CollectionDataProvider {
    associatedtype T

    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> T?

    func updateItem(at indexPath: IndexPath, value: T)
}
```

The first three methods in the protocol are:

- ***numberOfSections()***
- ***numberOfItems(in:)***
- ***item(at:)***

They map what is required to implement the above listed delegate methods of ***UICollectionViewDataSource***. Since I had some use cases where I also needed to update the data source based on some user interaction, I ended up adding a fourth method ***(updateItem(at:, value:))*** that allows you to update the underlying data source if needed. Therefore, the methods declared in ***CollectionDataProvider*** are sufficient to encapsulate the common functionality that is required for conforming to ***UICollectionViewDataSource***.

### Encapsulating the Boilerplate: CollectionDataSource

With the above abstractions in place, it is possible to start implementing a base class that will encapsulate the common boilerplate required to create a data source for a collection view. This is where most of the *“magic”* is going to happen! The main responsibility of this class is to leverage a specific ***CollectionDataProvider*** and ***UICollectionViewCell*** to implement what is required to conform to the ***UICollectionViewDataSource*** protocol. It will also encapsulate some common cell functionality by conforming to the ***UICollectionViewDelegate*** protocol as well.

Here is the class declaration:

```
open class CollectionDataSource<Provider: CollectionDataProvider, Cell: UICollectionViewCell>:
    NSObject,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    where Cell: ConfigurableCell, Provider.T == Cell.T
{ [...] }
```

A lot is happening here:

1. The class has an open access attribute because it will be extended to provide a concrete implementation that will work with a specific CollectionDataProvider.
2. This is a generic class and it requires further specification by defining the particular instance of ***Provider (CollectionDataProvider)*** and Cell ***(UICollectionViewCell)*** it will be working with.
3. The class extends ***NSObject*** and conforms to both ***UICollectionViewDataSource*** and ***UICollectionViewDelegate*** to implement and encapsulate the boilerplate code.
4. The class has a couple of specific constraints declared in the where clause:

- The ***UICollectionViewCell*** it accepts has to conform to the ***ConfigurableCell ***protocol (***Cell:******ConfigurableCell***).
- The specific type ***T*** must be the same for both the Cell and the Provider (***Provider.T == Cell.T***).

The code required to set up and initialize the ***CollectionDataSource*** class is as follows:

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

The code is rather simple: ***CollectionDataSource*** needs to know which collection view instance it will be acting upon and through which specific Provider. Both these elements are passed as parameters of the ***init*** method. During the initialization phase, ***CollectionDataSource*** sets itself as the delegate for ***UICollectionViewDataSource*** and ***UICollectionViewDelegate*** (in the ***setUp*** methods).

Now, let’s take a look at the boilerplate code that implements the delegates for ***UICollectionViewDataSource***.

Here’s the code:

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

The above snippet shows the implementation of the main ***UICollectionViewDataSource*** delegates by means of an instance of ***CollectionDataProvider*** which, as discussed earlier, encapsulates the details of the data source implementation. Each delegate uses the specific ***CollectionDataProvider*** method that abstracts the interaction with the data source.

Notice that the ***collectionView(_:cellForItemAt:)*** method has an open access attribute. This allows it to extend it, in case any subclass requires more customization during the cell content initialization phase.

Now that the functionality for displaying the cells in the collection view is in place, let’s add a couple more features.

For the first additional feature, the user should to be able to tap on a cell and trigger some action. To implement this, a simple solution is to define a custom closure and, if assigned, execute it when the user taps on a cell.

The custom closure to handle cell taps looks as follows:

```
public typealias CollectionItemSelectionHandlerType = (IndexPath) -> Void
```

Now, we can declare a property to store the closure and implement the ***collectionView(_:didSelectItemAt:)*** method of ***UICollectionViewDelegate*** to execute the assigned closure when the user taps the cell:

```
// MARK: - Delegates
public var collectionItemSelectionHandler: CollectionItemSelectionHandlerType?

// MARK: - UICollectionViewDelegate
public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionItemSelectionHandler?(indexPath)
}
```

For the second additional feature, I am going to implement some of the boilerplate to handle multiple headers and sections in ***CollectionDataSource***. This requires implementing the ***viewForSupplementaryElementOfKind*** delegate method of ***UICollectionViewDataSource***. Because I wanted to encapsulate all the logic for setting up the delegates inside ***CollectionDataSource***, in order for a subclass to be able to customize ***viewForSupplementaryElementOfKind***, the delegate method should be declared with an open attribute accessor to make it overridable in any subclass:

```
open func collectionView(_ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath) -> UICollectionReusableView
{
    return UICollectionReusableView(frame: CGRect.zero)
}
```

Generally speaking, this is true for all delegate methods. In case they need to be overridden by a subclass, it is required to implemented them in ***CollectionDataSource ***and declare them with an open attribute accessor.

A different strategy to achieve the same goal would be to use a custom closure, as seen for the cell tap handling ***(CollectionItemSelectionHandlerType)***.

This particular aspect of my implementation is a typical trade-off in software engineering. On one hand — the majority of the details for setting up the data source for a view collection will be hidden (and abstracted away). On the other hand — all functionality that has not been provided as part of the boilerplate will not be available “out-of-the-box” and will require additional customization. Adding new functionality is not overly complicated, but requires implementing more custom code as seen in the two examples above.

### Implementing a Concrete CollectionDataProvider: ArrayDataProvider

Now that the boilerplate is set up, the data source for a collection view is taken care of by means of ***CollectionDataSource***. Let’s see how we can take advantage of it for a very common use case. To do that, let’s go back for a moment to the ***CollectionDataProvider*** protocol. In order to be able to create an instance of ***CollectionDataSource***, it is required to provide a concrete implementation of ***CollectionDataProvider***. A basic implementation, which covers most of the common use cases, can simply leverage an array type to represent a list of items containing the data to be displayed in the collection view cells. As part of my experimentation with data source abstractions, I made this implementation a little bit more generic and capable of representing:

- An array of lists, where each list in the array represents the content for a section of the collection view.
- A single list of items, representing the data for the cells of the collection view, which is represented as the equivalent of having only one section (without header).

The code for the above implementation is contained in the generic class ***ArrayDataProvider***:

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

This takes care of abstracting the details of accessing the data source for the most common use cases where a linear data structure can represent the content of the cells.

### Wrapping it All Together: CollectionArrayDataSource

With the concrete implementation of the ***CollectionDataProvider*** protocol in place, it is easy to create a subclass of ***CollectionDataSource*** that leverages it to cover the very common use case where a simple list of items needs to be displayed.

Let’s start with the class declaration:

```
open class CollectionArrayDataSource<T, Cell: UICollectionViewCell>: CollectionDataSource<ArrayDataProvider<T>, Cell>
     where Cell: ConfigurableCell, Cell.T == T
 { [...] }
```

This declaration defines quite a few things:

1. The class has an open access attribute because it will be extended to eventually create an instance of the data source for a ***UICollectionView ***instance.
2. This is a generic class and it requires further specification by defining the particular type*** T*** that will be representing the cell content and the Cell, based on the ***UICollectionViewCell*** it will be working with.

3. This class extends ***CollectionDataSource*** to provide further specific behavior.

4. The particular type ***T*** that will be representing the cell content which will be accessed through an ***ArrayDataProvider<T>*** instance.

5. The class has a couple of specific constraints, declared in the where clause:

- The ***UICollectionViewCell*** it accepts has to conform to the ***ConfigurableCell*** protocol (Cell: ***ConfigurableCell***).
- The specific type T must be the same for both the Cell and the ***ArrayDataProvider<T> (Cell. T == T)***.

The class body is rather simple:

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

It just provides a couple of initializers and methods to transparently interact with the provider instance to read and write items from/to the data source.

### Setting up a Basic Collection View

The ***CollectionArrayDataSource*** base class can be extended to create a specific data source for any collection view that can be represented with an array of items. Here is an example (taken from the PhotoList sample available in the [GitHub repo](https://github.com/andrea-prearo/GenericDataSource)):

```
class PhotosDataSource: CollectionArrayDataSource<PhotoViewModel, PhotoCell> {}
```

The declaration is relatively simple:

1. The class extends ***CollectionArrayDataSource***.
2. This class specifies ***PhotoViewModel*** as the particular type ***T*** that will be representing the cell content, accessible through an ***ArrayDataProvider<PhotoViewModel>*** instance, and ***PhotoCell*** as the ***UICollectionViewCell*** it will be working with.

Please, notice that ***PhotoCell*** has to conform to the ***ConfigurableCell ***protocol, as specified by the ***CollectionDataSource*** declaration, and be able to configure its properties from an instance of ***PhotoViewModel***.

Creating an instance of ***PhotosDataSource*** is quite simple. It just requires being passed the collection view it will be working on and the array of ***PhotoViewModel*** items that represent each cell content:

```
let dataSource = PhotosDataSource(collectionView: collectionView, array: viewModels)
```

The ***collectionView*** parameter will typically be the outlet pointing to a collection view in a storyboard (***@IBOutlet weak var collectionView: UICollectionView!***).

And that’s it! Two lines of code are sufficient to set up the data source for a basic collection view.

### Setting up a Collection View with Headers and Sections

For a more advanced and complex use case, you could take a look at the ***TaskList*** sample available in the [GitHub repo](https://github.com/andrea-prearo/GenericDataSource). I am not going into the details of the sample in this article as the content is already quite long. I will likely dive deeper into the topic of *“Collection View with Headers and Sections”* in a next post. On this note, if such a topic would be interesting for you, don’t hesitate to let me know so I can prioritize what to write about next. To get in touch with me, please leave a comment on this post or send an email to: [andrea.prearo@gmail.com](mailto:andrea.prearo@gmail.com).

### Conclusion

In this post I presented some abstractions I built to simplify working with collection views using generic data sources. The proposed implementation is based on use cases that fit recurring patterns I’ve run into during my experience with building iOS apps. Some more advanced use cases would likely require further customization. I believe that it would be possible to adapt the presented abstractions, or build new ones, to simplify working with different collection view patterns. But this is outside the scope of this particular post.

All the code for the generic data source and the sample apps is available under MIT license on [GitHub](https://github.com/andrea-prearo/GenericDataSource), and can be freely reused and adapted. All feedback, as well as proposed contributions, are welcome and greatly appreciated. In case there is enough interest, I would be happy to add the required configurations to make the code work with Cocoapods and Carthage and allow the generic data source to be imported using such dependency management tools. Or, this could be a good starting point to contribute to this project.

---

#### Additional Links

- [Smooth Scrolling in UITableView and UICollectionView](https://medium.com/capital-one-developers/smooth-scrolling-in-uitableview-and-uicollectionview-a012045d77f)
- [Boost Smooth Scrolling with iOS 10 Pre-Fetching API](https://medium.com/capital-one-developers/boost-smooth-scrolling-with-ios-10-pre-fetching-api-818c25cd9c5d)

***DISCLOSURE STATEMENT: These opinions are those of the author. Unless noted otherwise in this post, Capital One is not affiliated with, nor is it endorsed by, any of the companies mentioned. All trademarks and other intellectual property used or displayed are the ownership of their respective owners. This article is © 2017 Capital One.***

***For more on APIs, open source, community events, and developer culture at Capital One, visit DevExchange, our one-stop developer portal: ***[***developer.capitalone.com***](https://developer.capitalone.com/)***.***


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
