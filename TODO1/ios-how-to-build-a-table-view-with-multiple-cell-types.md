> * 原文地址：[iOS: How to build a Table View with multiple cell types](https://medium.com/@stasost/ios-how-to-build-a-table-view-with-multiple-cell-types-2df91a206429)
> * 原文作者：[Stan Ostrovskiy](https://medium.com/@stasost)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ios-how-to-build-a-table-view-with-multiple-cell-types.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ios-how-to-build-a-table-view-with-multiple-cell-types.md)
> * 译者：
> * 校对者：

# iOS: How to build a Table View with multiple cell types

Part 1. How not to get lost in spaghetti code

![](https://cdn-images-1.medium.com/max/800/1*cTOkFg6sVgV0MEdThEw2bA.png)

There are Table Views with the static cells, where the number of the cells and the cell order is constant. Implementing this Table View is very simple and not much different from the regular _UIView_.

There are Table Views with dynamic cells of one type: the number and the order of the cells are changing dynamically, but all cells have the same type of content. This is where the reusable cells come in place. This is also the most popular type if Table Views.

The are also Table Views with dynamic cells that have different content types: the number, order and the cell types are dynamic. These Table Views are the most interesting and the most challenging to implement.

Imagine the app, where you have to build this screen:

![](https://cdn-images-1.medium.com/max/800/1*MTXgVkRfdmcGrdZKlaUjdQ.gif)

All the data comes from the backend, and we have no control over what data will be received with the next request: maybe there will be no “about” info, or the gallery will be empty. In this case, we don’t need to display those cells at all. Finally, we have to know what cell type the user taps on and react accordingly.

First, let’s determine the problem.

This is the approach I often see in different projects: configuring the cell based on its index in _UITableView._

```
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

   if indexPath.row == 0 {  
        //configure cell type 1  
   } else if indexPath.row == 1 {  
        //configure cell type 2  
   }  
   ....  
}
```

Almost the same code is used for delegate method _didSelectRowAt_:

```
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

if indexPath.row == 0 {  
        //configure action when tap cell 1  
   } else if indexPath.row == 1 {  
        //configure action when tap cell 1  
   }  
   ....  
}
```
This will work as expected up until the moment when you want to reorder the cells or remove/add new cells to the tableView. If you change one index, the whole table view structure will be broken and you will need to manually update all the indexes in _cellForRowAt_ and _didSelectRowAt_ methods.

> In other words, it’s not reusable, not clearly readable and it doesn’t follow any programming patterns since it mixes together the view and the model_._

What’s the better way?

In this project, we will use the MVVM pattern. MVVM stands for “Model-View-ViewModel, and this pattern is very useful when you need an extra layer between your model and the view. You can read more about all major iOS design patterns [here](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52).

In the first part of this tutorial series, we will build the dynamic Table View, using the JSON as a data source. We will cover the following topics and concepts: _protocols_, _protocol extensions, computed properties, switch statements_ and more.

In the next tutorial, we will take it one level up: make the section collapsible with just a few lines of code.

* * *

#### **Part 1: Model**

First, create a new project, add a TableView to default ViewController, pin the tableView to the ViewController, and embed the ViewController it in Navigation Controller and make sure the project compiles and runs as expected. This is the basic step and it will not be covered here. If you are having troubles with this part, it’s probably too soon for you to go deeper on this topic.

Your ViewController class will look like this:

```
class ViewController: UIViewController {  
   @IBOutlet weak var tableView: UITableView?  

   override func viewDidLoad() {  
      super.viewDidLoad()  
   }  
}
```

I created a simple JSON data, that imitates the server response. You can download it from my Dropbox [here](https://www.dropbox.com/s/esh7uvr6dovwq53/Images.zip?dl=0). Save this file in the project folder and make sure the file has the project name as it’s target in the file inspector:

![](https://cdn-images-1.medium.com/max/800/1*TSOtH7H7wvmEuzld6LNcqg.png)

You will also need some images, that you can find [here](https://www.dropbox.com/sh/90h0obxashbwgj0/AAA-eQlN3qe8Bcy-6Yw4R5vwa?dl=0). Download the archive, unzip it, and add the pictures to the assets folder. Don’t rename any images.

We need to create a Model, that will hold all the data we read from the JSON.

```
class Profile {  
   var fullName: String?  
   var pictureUrl: String?  
   var email: String?  
   var about: String?  
   var friends = \[Friend\]()  
   var profileAttributes = \[Attribute\]()  
}

class Friend {  
   var name: String?  
   var pictureUrl: String?  
}

class Attribute {  
   var key: String?  
   var value: String?  
}
```

We will add an initializer using a JSON object, so you can easily map the JSON to the Model. First, we need the way to extract the content from the .json file, and represent it as Data:
```
public func dataFromFile(_ filename: String) -> Data? {  
   @objc class TestClass: NSObject { }  
   let bundle = Bundle(for: TestClass.self)  
   if let path = bundle.path(forResource: filename, ofType: "json") {  
      return (try? Data(contentsOf: URL(fileURLWithPath: path)))  
   }  
   return nil  
}
```
Using the Data, we can initialize the Profile. There are many different ways to parse JSON in swift using both native or 3rd party serializers, so you can use the one you like. I will stick to the standard Swift JSONSerialization to keep the project simple and not overload it with any external libraries:
```
class Profile {  
   var fullName: String?  
   var pictureUrl: String?  
   var email: String?  
   var about: String?  
   var friends = \[Friend\]()  
   var profileAttributes = \[Attribute\]()

   init?(data: Data) {  
      do {  
         if let json = try JSONSerialization.jsonObject(with: data) as? \[String: Any\], let body = json\[“data”\] as? \[String: Any\] {  
            self.fullName = body\[“fullName”\] as? String  
            self.pictureUrl = body\[“pictureUrl”\] as? String  
            self.about = body\[“about”\] as? String  
            self.email = body\[“email”\] as? String

            if let friends = body\[“friends”\] as? \[\[String: Any\]\] {  
               self.friends = friends.map { Friend(json: $0) }  
            }
    
            if let profileAttributes = body\[“profileAttributes”\] as? \[\[String: Any\]\] {  
               self.profileAttributes = profileAttributes.map { Attribute(json: $0) }  
            }  
         }  
      } catch {  
         print(“Error deserializing JSON: \\(error)”)  
         return nil  
      }  
   }  
}

class Friend {  
   var name: String?  
   var pictureUrl: String?

   init(json: \[String: Any\]) {  
      self.name = json\[“name”\] as? String  
      self.pictureUrl = json\[“pictureUrl”\] as? String  
   }  
}

class Attribute {  
   var key: String?  
   var value: String?  
    
   init(json: \[String: Any\]) {  
      self.key = json\[“key”\] as? String  
      self.value = json\[“value”\] as? String  
   }  
}
```
#### Part 2: View Model

Our _Model_ is ready, so we need to create the _ViewModel_. It will be responsible for providing data to our _TableView_.

We are going to create 5 different table sections:

*   Full name and Profile Picture
*   About
*   Email
*   Attributes
*   Friends

The first three sections have one cell each, the last two can have multiple cells depending on the content of our JSON file.

Because our data is dynamic, the number of cells is not constant, and we use different tableViewCells for each type of data, we need to come up with the right ViewModel structure.

First, we have to distinguish the data types, so we can use an appropriate cell. The best way to work with multiple items when you need to easily switch between them in swift is the enum. So let’s start building the _ViewModel_ with the _ViewModelItemType_:
```
enum ProfileViewModelItemType {  
   case nameAndPicture  
   case about  
   case email  
   case friend  
   case attribute  
}
```
Each _enum_ case represents the data type that requires the different _TableViewCell._ But because we want to use our data within the same tableView, so need to have the single _DataModelItem_, that will determine all properties. We can achieve this by using the protocol, that will provide computed properties to our items:
```
protocol ProfileViewModelItem {  

}
```
The first thing we need to know about our item is its type. So we create a type property for the protocol. When you create a protocol property, you need to provide its _name_, _type_ and specify whether the property is _gettable_ or _settable_ and _gettable_. You can get more information and examples about the protocol properties [here](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html). In our case, the type will be the _ProfileViewModelItemType,_ and we only need a getter for this property:
```
protocol ProfileViewModelItem {  
   var type: ProfileViewModelItemType { get }  
}
```
The next property we need is the _rowCount._ It will tell us how many rows each section will have. Provide the type and the getter for this property:
```
protocol ProfileViewModelItem {  
   var type: ProfileViewModelItemType { get }  
   var rowCount: Int { get }  
}
```
The last thing that is good to have in this protocol is the section title. Basically, a section title is also a data for the _tableView_. As you remember, using the MVVM structure we don’t want to create the data or any kind anywhere else, but in the _viewModel_:
```
protocol ProfileViewModelItem {  
   var type: ProfileViewModelItemType { get }  
   var rowCount: Int { get }  
   var sectionTitle: String  { get }  
}
```
Now we are ready to create the _ViewModelItem_ for each of our data types. Each item will conform to the protocol. But before we do it, let’s make another step to the clean and organized project: provide some defaults values for our protocol. In Swift, we can provide the default values to protocols using the protocol extension:
```
extension ProfileViewModelItem {  
   var rowCount: Int {  
      return 1  
   }  
}
```
Now we don’t have to provide the row count for our items if the row count is one, so it will save you a few extra lines of redundant code.

> Protocol extension can also allow you to make the optional protocol methods without using the @objc protocols. Just create a protocol extension and place the default method implementation in this extension.

Create the first _ViewModeItem_ for the Name and Picture cell.
```
class ProfileViewModelNameItem: ProfileViewModelItem {  
   var type: ProfileViewModelItemType {  
      return .nameAndPicture  
   }

   var sectionTitle: String {  
      return “Main Info”  
   }  
}
```
As I said before, we don’t need to provide the row count, because in this case, we need the default value of 1.

Now we add other properties, that will be unique for this item: _pictureUrl_ and _userName_. Both will be the stored properties with no initial value, so we also need to provide the init for this class:
```
class ProfileViewModelNameAndPictureItem: ProfileViewModelItem {  
   var type: ProfileViewModelItemType {  
      return .nameAndPicture  
   }

   var sectionTitle: String {  
      return “Main Info”  
   }

   var pictureUrl: String  
   var userName: String

   init(pictureUrl: String, userName: String) {  
      self.pictureUrl = pictureUrl  
      self.userName = userName  
   }  
}
```
Now we can create the remaining 4 model items:
```
class ProfileViewModelAboutItem: ProfileViewModelItem {  
   var type: ProfileViewModelItemType {  
      return .about  
   }

   var sectionTitle: String {  
      return “About”  
   }

   var about: String  
    
   init(about: String) {  
      self.about = about  
   }  
}

class ProfileViewModelEmailItem: ProfileViewModelItem {  
   var type: ProfileViewModelItemType {  
      return .email  
   }

   var sectionTitle: String {  
      return “Email”  
   }

   var email: String

   init(email: String) {  
      self.email = email  
   }  
}

class ProfileViewModelAttributeItem: ProfileViewModelItem {  
   var type: ProfileViewModelItemType {  
      return .attribute  
   }

   var sectionTitle: String {  
      return “Attributes”  
   }  

   var rowCount: Int {  
      return attributes.count  
   }

   var attributes: \[Attribute\]

   init(attributes: \[Attribute\]) {  
      self.attributes = attributes  
   }  
}

class ProfileViewModeFriendsItem: ProfileViewModelItem {  
   var type: ProfileViewModelItemType {  
      return .friend  
   }

   var sectionTitle: String {  
      return “Friends”  
   }

   var rowCount: Int {  
      return friends.count  
   }

   var friends: \[Friend\]

   init(friends: \[Friend\]) {  
      self.friends = friends  
   }  
}
```
For the _ProfileViewModeAttributeItem_ and _ProfileViewModeFriendsItem_ we can have multiple cells, so the _RowCount_ will be the number of Attributes and number of Friends correspondently.

That’s all we need for the data items. The last step will be the _ViewModel_ class. This class can be used by any _ViewController_, and this is one of the key ideas behind the MVVM structure: your _ViewModel_ knows nothing about the _View_, but it provides all the data, that _View_ may need.

The only property the _ViewModel_ will have is the array of items, that will represent the array of sections for the _UITableView:_
```
class ProfileViewModel: NSObject {  
   var items = \[ProfileViewModelItem\]()  
}
```
To initialize the _ViewModel_ we will use the _Profile_ model. First, we try to parse the .json file to Data:
```
class ProfileViewModel: NSObject {  
   var items = \[ProfileViewModelItem\]()  
     
   override init(profile: Profile) {  
      super.init()  
      guard let data = dataFromFile("ServerData"), let profile = Profile(data: data) else {  
         return  
      }

      // initialization code will go here  
   }  
}
```
Here is the most interesting part: based on the _Model_, we will configure the _ViewModel_ items we want to display.
```
class ProfileViewModel: NSObject {  
   var items = \[ProfileViewModelItem\]()

   override init() {  
      super.init()  
      guard let data = dataFromFile("ServerData"), let profile = Profile(data: data) else {  
         return  
      }  

      if let name = profile.fullName, let pictureUrl = profile.pictureUrl {  
         let nameAndPictureItem = ProfileViewModelNamePictureItem(name: name, pictureUrl: pictureUrl)  
         items.append(nameAndPictureItem)  
      }
    
      if let about = profile.about {  
         let aboutItem = ProfileViewModelAboutItem(about: about)  
         items.append(aboutItem)  
      }
    
      if let email = profile.email {  
         let dobItem = ProfileViewModelEmailItem(email: email)  
         items.append(dobItem)  
      }
    
      let attributes = profile.profileAttributes  
      // we only need attributes item if attributes not empty  
      if !attributes.isEmpty {  
         let attributesItem = ProfileViewModeAttributeItem(attributes: attributes)  
         items.append(attributesItem)  
      }
    
      let friends = profile.friends  
      // we only need friends item if friends not empty  
      if !profile.friends.isEmpty {  
         let friendsItem = ProfileViewModeFriendsItem(friends: friends)  
         items.append(friendsItem)  
      }  
   }  
}
```
Now if you want to reorder, add or remove the items, you just need to modify this _ViewModel_ items array. Pretty clear, right?

Next, we will add UITableViewDataSource to our ModelView:
```
extension ViewModel: UITableViewDataSource {  
   func numberOfSections(in tableView: UITableView) -> Int {  
      return items.count  
   }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  
      return items\[section\].rowCount  
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

   // we will configure the cells here

   }  
}
```
* * *

#### Part 3: View

Return to the _ViewController_ and prepare the _TableView_.

First, we create the stored property _ProfileViewModel_ and initialize it. In a real project, you would have to request the data first, feed that data to the _ViewModel,_ and then reload _TableView_ on data update ([check out the ways to pass data in iOS app here](https://medium.com/ios-os-x-development/ios-three-ways-to-pass-data-from-model-to-controller-b47cc72a4336)).

Next, we configure the tableViewDataSource:
```
override func viewDidLoad() {  
   super.viewDidLoad()  
     
   tableView?.dataSource = viewModel  
}
```
Now we are ready to build a UI. We need to create five different types of cells, one for each of _ViewModelItems._ Building  the cells is not something I will cover in this tutorial, so you can create your own cell classes, design, and cell layout. As a reference, I will show you the simple example of what you need to do:

![](https://cdn-images-1.medium.com/max/800/1*Opk9kuxb8bPCZNeS6P-c2Q.png)

<center>NameAndPictureCell and FriendCell Example</center>

![](https://cdn-images-1.medium.com/max/800/1*e_Lxqxroxf6UY02CrTzq1w.png)

<center>EmailCell and AboutCell Example</center>

![](https://cdn-images-1.medium.com/max/800/1*fyGmuvX7IkeZbX1DG4f3iA.png)

<center>AttributeCell Example</center>

If you need an assistance creating the cell, or want to find for some tips, [check one of my previous tutorials](https://medium.com/ios-os-x-development/ios-tableview-with-mvc-a05103c01110) about the _tableViewCells._

Each cell should have the _item_ property of type _ProfileViewModelItem_, that we will use to setup the cell UI:
```
// this assumes you already have all the cell subviews: labels, imagesViews, etc

class NameAndPictureCell: UITableViewCell {  
    var item: ProfileViewModelItem? {  
      didSet {  
         // cast the ProfileViewModelItem to appropriate item type  
         guard let item = item as? ProfileViewModelNamePictureItem  else {  
            return  
         }

         nameLabel?.text = item.name  
         pictureImageView?.image = UIImage(named: item.pictureUrl)  
      }  
   }  
}

class AboutCell: UITableViewCell {  
   var item: ProfileViewModelItem? {  
      didSet {  
         guard  let item = item as? ProfileViewModelAboutItem else {  
            return  
         }

         aboutLabel?.text = item.about  
      }  
   }  
}

class EmailCell: UITableViewCell {  
    var item: ProfileViewModelItem? {  
      didSet {  
         guard let item = item as? ProfileViewModelEmailItem else {  
            return  
         }

         emailLabel?.text = item.email  
      }  
   }  
}

class FriendCell: UITableViewCell {  
    var item: Friend? {  
      didSet {  
         guard let item = item else {  
            return  
         }

         if let pictureUrl = item.pictureUrl {  
            pictureImageView?.image = UIImage(named: pictureUrl)  
         }  
         nameLabel?.text = item.name  
      }  
   }  
}

var item: Attribute?  {  
   didSet {  
      titleLabel?.text = item?.key  
      valueLabel?.text = item?.value  
   }  
}
```
Some of you can ask a reasonable question: why don’t we use the same cell for _ProfileViewModelAboutItem_ and _ProfileViewModelEmailItem,_ since they both have a single text label? The answer is yes, we can use the same cell. But the purpose of this tutorial is to show you the way of using different cell types.

> Don’t forget to register the cells, if you want to use them as reusableCells: UITableView has methods to register both cell classes or nib files, depending on the way you created the cell.

Now it’s time to use the cells in our _TableView._ Again, the _ViewModel_ will handle this in a very simple way:
```
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  
   let item = items\[indexPath.section\]  
   switch item.type {  
   case .nameAndPicture:  
      if let cell = tableView.dequeueReusableCell(withIdentifier: NamePictureCell.identifier, for: indexPath) as? NamePictureCell {  
         cell.item = item  
         return cell  
      }  
   case .about:  
      if let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.identifier, for: indexPath) as? AboutCell {  
         cell.item = item  
         return cell  
      }  
   case .email:  
      if let cell = tableView.dequeueReusableCell(withIdentifier: EmailCell.identifier, for: indexPath) as? EmailCell {  
         cell.item = item  
         return cell  
      }  
   case .friend:  
      if let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as? FriendCell {  
         cell.item = friends\[indexPath.row\]  
         return cell  
      }  
   case .attribute:  
      if let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.identifier, for: indexPath) as? AttributeCell {  
         cell.item = attributes\[indexPath.row\]  
         return cell  
      }  
   }

   // return the default cell if none of above succeed  
   return UITableViewCell()  
}


You can use the same structure to setup the _didSelectRowAt_ delegate method:

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  
      switch items\[indexPath.section\].type {  
          // do appropriate action for each type

      }  
}
```
Finally, configure a _headerView_:
```
override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {  
   return items\[section\].sectionTitle  
}
```
Build and run your project and enjoy the dynamic table view!

![](https://cdn-images-1.medium.com/max/800/1*ZYedJ6I233Ek9MiQX2ELIQ.png)

<center>Result Image</center>

To test the flexibility, you can modify the JSON file: add or remove some friends, or remove some of the data completely (just don’t break the JSON structure, otherwise, you will not see any data at all). When you re-build your project, the _tableView_ will look and work the way it should without any code modifications. You will only need to modify your _ViewModel_ and _ViewController_ if you change the _Model_ itself: add a new property, or dramatically change its whole structure. But this is a completely different story.

You can check out the complete project here:

[Stan-Ost/TableViewMVVM](https://github.com/Stan-Ost/TableViewMVVM)

Thanks for reading! If you have any questions or suggestions — feel free to ask!

In the next article we will upgrade the existing project to add a nice collapse/expand effect for the sections.

* * *

Update: check [here](https://medium.com/ios-os-x-development/ios-aimate-tableview-updates-dc3df5b3fe07) to learn how to dynamically update this _tableView_ without using _ReloadData_ method.

* * *

_I also write for the American Express Engineering Blog. Check out my other works and the works of my talented co-workers at_ [_AmericanExpress.io_](http://americanexpress.io/)_._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。