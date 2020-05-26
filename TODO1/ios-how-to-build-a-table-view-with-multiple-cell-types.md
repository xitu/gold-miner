> * 原文地址：[iOS: How to build a Table View with multiple cell types](https://medium.com/@stasost/ios-how-to-build-a-table-view-with-multiple-cell-types-2df91a206429)
> * 原文作者：[Stan Ostrovskiy](https://medium.com/@stasost)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ios-how-to-build-a-table-view-with-multiple-cell-types.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ios-how-to-build-a-table-view-with-multiple-cell-types.md)
> * 译者：[LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：[Fengziyin1234](https://github.com/Fengziyin1234)

# iOS：如何构建具有多种 Cell 类型的表视图

第1部分：怎样才能不迷失在大量代码中

![](https://cdn-images-1.medium.com/max/800/1*cTOkFg6sVgV0MEdThEw2bA.png)

在具有静态 Cell 的表视图中，其 Cell 的数量和顺序是恒定的。要实现这样的表视图非常简单，与实现常规 _UIView_ 没有太大的区别。

只包含一种内容类型的动态 Cell 的表视图：Cell 的数量和顺序是动态变化的，但所有 Cell 都有相同类型的内容。在这里你可以使用可复用 Cell 。这也是最常见的表视图样式。

包含具有不同内容类型的动态 Cell 的表视图：数量，顺序和 Cel l类型是动态的。实现这种表视图是最有趣和最具挑战性的。

想象一下这个应用程序，你必须构建这样的页面：

![](https://cdn-images-1.medium.com/max/800/1*MTXgVkRfdmcGrdZKlaUjdQ.gif)

所有数据都来自后端，我们无法控制下一个请求将接收哪些数据：可能没有「about」的信息，或者「gallery」部分可能是空的。在这种情况下，我们根本不需要展示这些 Cell。最后，我们必须知道用户点击的 Cell 类型并做出相应的反应。

首先，让我们来先确定问题。

我经常在不同项目中看到这样的方法：在 _UITableView_ 中根据 index 配置 Cell。

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

同样在代理方法 _didSelectRowAt_ 中几乎使用相同的代码：

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

直到你想要重新排序 Cell 或在表视图中删除或添加新的 Cell 的那一刻，代码都将如所预期的工作。如果你更改了一个 index，那么整个表视图的结构都将破坏，你需要手动更新 _cellForRowAt_ 和 _didSelectRowAt_ 方法中所有的 index。

> 换句话说，它无法重用，可读性差，也不遵循任何编程模式，因为它混合了视图和 Model。

有什么更好的方法吗？

在这个项目中，我们将使用 MVVM 模式。MVVM 代表「Model-View-ViewModel」，当你在模型和视图之间需要额外的视图时，这种模式非常有用。你可以在此处阅读有关所有主要 [iOS 设计模式](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52) 的更多信息。

在本系列教程的第一部分中，我们将使用 JSON 作为数据源构建动态表视图。我们将讨论以下主题和概念：_协议，协议拓展，属性计算，声明转换_ 以及更多。

在下一个教程中，我们将把它提高一个难度：通过几行代码来实现 section 的折叠。。

* * *

#### 第1部分： Model

首先，创建一个新项目，将 TableView 添加到默认的 ViewController 中，ViewController 绑定该 tableView，并将ViewController 嵌入到 NavigationController 中，并确保项目能按预期编译和运行。这是基本步骤，此处不予介绍。如果你在这部分遇到麻烦，那对你来说深入研究这个话题可能太早了。

你的 ViewController 类应该像这样子：

```
class ViewController: UIViewController {
   @IBOutlet weak var tableView: UITableView?
 
   override func viewDidLoad() {
      super.viewDidLoad()
   }
}
```

我创建了一个简单的 JSON 数据，来模仿服务器响应。你可以在我的 [Dropbox](https://www.dropbox.com/s/esh7uvr6dovwq53/Images.zip?dl=0) 中下载它。将此文件保存在项目文件夹中，并确保该文件的项目名称与文件检查器中的目标名称相同：

![](https://cdn-images-1.medium.com/max/800/1*TSOtH7H7wvmEuzld6LNcqg.png)

你还需要一些图片，你可以在 [这里](https://www.dropbox.com/sh/90h0obxashbwgj0/AAA-eQlN3qe8Bcy-6Yw4R5vwa?dl=0) 找到。下载存档，解压缩，然后将图片添加到资源文件夹。不要对任何图片重命名。

我们需要创建一个 Model，它将保存我们从 JSON 读取的所有数据。

```
class Profile {
   var fullName: String?
   var pictureUrl: String?
   var email: String?
   var about: String?
   var friends = [Friend]()
   var profileAttributes = [Attribute]()
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

我们将给 JSON 对象添加初始化方法，那样你就可以轻松地将 JSON 映射到 Model。首先，我们需要从 .json 文件中提取内容的方法，并将其转成 Data 对象：

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

使用 Data 对象，我们可以初始化 Profile 类。原生或第三方库中有许多不同的方可以在 Swift 中解析JSON，你可以使用你喜欢的那个。我坚持使用标准的 Swift JSONSerialization 库来保持项目的精简，不使用任何第三方库：

```
class Profile {
   var fullName: String?
   var pictureUrl: String?
   var email: String?
   var about: String?
   var friends = [Friend]()
   var profileAttributes = [Attribute]()
   
   init?(data: Data) {
      do {
         if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let body = json[“data”] as? [String: Any] {
            self.fullName = body[“fullName”] as? String
            self.pictureUrl = body[“pictureUrl”] as? String
            self.about = body[“about”] as? String
            self.email = body[“email”] as? String
            
            if let friends = body[“friends”] as? [[String: Any]] {
               self.friends = friends.map { Friend(json: $0) }
            }
            
            if let profileAttributes = body[“profileAttributes”] as? [[String: Any]] {
               self.profileAttributes = profileAttributes.map { Attribute(json: $0) }
            }
         }
      } catch {
         print(“Error deserializing JSON: \(error)”)
         return nil
      }
   }
}

class Friend {
   var name: String?
   var pictureUrl: String?
   
   init(json: [String: Any]) {
      self.name = json[“name”] as? String
      self.pictureUrl = json[“pictureUrl”] as? String
   }
}

class Attribute {
   var key: String?
   var value: String?
  
   init(json: [String: Any]) {
      self.key = json[“key”] as? String
      self.value = json[“value”] as? String
   }
}
```

#### 第2部分：View Model

我们的 _Model_ 已准备就绪，所以我们需要创建 _ViewModel_。它将负责向我们的 _TableView_ 提供数据。

我们将创建 5 个不同的 table sections：

*   Full name and Profile Picture
*   About
*   Email
*   Attributes
*   Friends

前三个 section 各只有一个 Cell，最后两个 section 可以有多个 Cell，具体取决于我们的 JSON 文件的内容。

因为我们的数据是动态的，所以 Cell 的数量不是固定的，并且我们对每种类型的数据使用不同的 tableViewCell，因此我们需要使用正确的 ViewModel 结构。首先，我们必须区分数据类型，以便我们可以使用适当的 Cell。当你需要在 Swift 中使用多种类型并且可以轻松的切换时，最好的方法是使用枚举。那么让我们开始使用 _ViewModelItemType_ 构建 _ViewModel_：

```
enum ProfileViewModelItemType {
   case nameAndPicture
   case about
   case email
   case friend
   case attribute
}
```

每个 _enum case_ 表示 _TableViewCell_ 需要的不同的数据类型。但是，我由于们希望在同一个表视图中使用数据，所以需要有一个单独的 _dataModelItem_，它将决定所有属性。我们可以通过使用协议来实现这一点，该协议将为我们的 item 提供属性计算：

```
protocol ProfileViewModelItem {  

}
```

首先，我们需要知道的是 item 的类型。因此我们为协议创建一个类型属性。当你创建协议属性时，你需要为该属性设置 _name_, _type_，并指定该属性是 _gettable_ 还是 _settable_ 和 _gettable_。你可以在 [此处](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html) 获得有关协议属性的更多信息和示例。在我们的例子中，类型将是 _ProfileViewModelItemType_，我们仅需要只读该属性：

```
protocol ProfileViewModelItem {
   var type: ProfileViewModelItemType { get }
}
```

我们需要的下一个属性是 _rowCount_。它将告诉我们每个 section 有多少行。为此属性指定类型和只读类型：

```
protocol ProfileViewModelItem {
   var type: ProfileViewModelItemType { get }
   var rowCount: Int { get }
}
```

我们最好在协议中添加一个 _sectionTitle_ 属性。基本上，_sectionTitle_ 也属于 _TableView_ 的相关数据。如你所知，在使用 MVVM 结构时，除了在 _viewModel_ 中，我们不希望在其他任何地方创建任何类型的数据，：

```
protocol ProfileViewModelItem {
   var type: ProfileViewModelItemType { get }
   var rowCount: Int { get }
   var sectionTitle: String  { get }
}
```

现在，我们已经准备好为每种数据类型创建 _ViewModelItem_。每个 item 都需要遵守协议。但在我们开始之前，让我们再向简洁有序的项目迈出一步：为我们的协议提供一些默认值。在 swift 中，我们可以使用协议扩展为协议提供默认值：

```
extension ProfileViewModelItem {
   var rowCount: Int {
      return 1
   }
}
```

现在，如果 rowCount 为 1，我们就不必为 item 的 rowCount 赋值了，它将为你节省一些冗余的代码。

> 协议扩展还允许您在不使用 @objc 协议的情况下生成可选的协议方法。只需创建一个协议扩展并在这个扩展中实现默认方法。

先为 nameAndPicture Cell 创建一个 _ViewModeItem_。

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

正如我之前所说，在这种情况下，我们不需要为 rowCount 赋值，因为，我们只需要默认值 1。

现在我们添加其他属性，这些属性对于这个 item 来说是唯一的：_pictureUrl_ 和 _userName_。两者都是没有初始值的存储属性，因此我们还需要为这个类提供 init 方法：

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

然后我们可以创建剩余的4个 Model：

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
   
   var attributes: [Attribute]
   
   init(attributes: [Attribute]) {
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
   
   var friends: [Friend]
   
   init(friends: [Friend]) {
      self.friends = friends
   }
}
```

对于 _ProfileViewModeAttributeItem_ 和 _ProfileViewModeFriendsItem_，我们可能会有多个 Cell，所以 _RowCount_ 将是相应的 Attributes 数量和 Friends 数量。

这就是数据项所需的全部内容。最后一步是创建 _ViewModel_ 类。这个类可以被任何 _ViewController_ 使用，这也是MVVM结构背后的关键思想之一：你的 _ViewModel_ 对 _View_ 一无所知，但它提供了 _View_ 可能需要的所有数据。

_ViewModel_拥有的唯一属性是 item 数组，它对应着 _UITableView_ 包含的 section 数组：

```
class ProfileViewModel: NSObject {
   var items = [ProfileViewModelItem]()
}
```

要初始化 _ViewModel_，我们将使用 _Profile_ Model。首先，我们尝试将 .json 文件解析为 Data：

```
class ProfileViewModel: NSObject {
   var items = [ProfileViewModelItem]()
   
   override init(profile: Profile) {
      super.init()
      guard let data = dataFromFile("ServerData"), let profile = Profile(data: data) else {
         return
      }
      
      // initialization code will go here
   }
}
```

下面是最有趣的部分：基于 _Model_，我们将配置需要显示的 _ViewModel_。

```
class ProfileViewModel: NSObject {
   var items = [ProfileViewModelItem]()
   
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

现在，如果要重新排序、添加或删除 item，只需修改此 _ViewModel_ 的 item 数组即可。很清楚，是吧？

接下来，我们将 UITableViewDataSource 添加到 ModelView：

```
extension ViewModel: UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return items.count
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return items[section].rowCount
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
   // we will configure the cells here
   
   }
}
```

* * *

#### 第3部分：View

让我们回到 _ViewController_ 中，开始 _TableView_ 的准备。

首先，我们创建存储属性 _ProfileViewModel_ 并初始化它。在实际项目中，你必须先请求数据，将数据提供给 _ViewModel_，然后在数据更新时重新加载 _TableView_（[在这里查看在 iOS 应用程序中传递数据的方法](https://medium.com/ios-os-x-development/ios-three-ways-to-pass-data-from-model-to-controller-b47cc72a4336)）。

接下来，让我们来配置 tableViewDataSource：

```
override func viewDidLoad() {  
   super.viewDidLoad()  
     
   tableView?.dataSource = viewModel  
}
```

现在我们可以开始构建 UI 了。我们需要创建五种不同类型的 Cell，每种 Cell 对应一种 _ViewModelItems_。如何创建 Cell 并不是本教程中所需要介绍的内容，你可以创建自己的 Cell 类、样式和布局。作为参考，我将向你展示一些简单示例：

![](https://cdn-images-1.medium.com/max/800/1*Opk9kuxb8bPCZNeS6P-c2Q.png)

<center>NameAndPictureCell 和 FriendCell 示例</center>

![](https://cdn-images-1.medium.com/max/800/1*e_Lxqxroxf6UY02CrTzq1w.png)

<center>EmailCell 和 AboutCell 示例</center>

![](https://cdn-images-1.medium.com/max/800/1*fyGmuvX7IkeZbX1DG4f3iA.png)

<center>AttributeCell 示例</center>

如果你对创建 Cell 需要一些帮助，或者想要一些提示，可以查看我之前关于 _tableViewCells_ 的某个 [教程](https://medium.com/ios-os-x-development/ios-tableview-with-mvc-a05103c01110) 。

每个 Cell 都应该具有 _ProfileViewModelItem_ 类型的 _item_ 属性，我们将使用它来构建 Cell UI：

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

你们可能会提一个合理的问题：为什么我们不为 _ProfileViewModelAboutItem_ 和 _ProfileViewModelEmailItem_ 创建同一个的 Cell，他们都只有一个 label？答案是可以这样子做，我们可以使用一个的 Cell。但本教程的目的是向你展示如何使用不同类型的 Cell。

> 如果你想将它们用作 reusableCells，不要忘记注册 Cell：UITableView 提供注册 Cell class 和 nib 文件的方法，这取决于你创建 Cell 的方式。

现在是时候在 _TableView_ 中使用 Cell 了。同样，_ViewModel_ 将以一种非常简单的方式处理它：

```
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let item = items[indexPath.section]
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
         cell.item = friends[indexPath.row]
         return cell
      }
   case .attribute:
      if let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.identifier, for: indexPath) as? AttributeCell {
         cell.item = attributes[indexPath.row]
         return cell
      }
   }
   
   // return the default cell if none of above succeed
   return UITableViewCell()
}

你可以使用相同的结构来构建 didSelectRowAt 代理方法：

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      switch items[indexPath.section].type {
          // do appropriate action for each type
      }
}
```

最后，配置 _headerView_：

```
override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
   return items[section].sectionTitle
}
```

构建运行你的项目并享受动态表视图！

![](https://cdn-images-1.medium.com/max/800/1*ZYedJ6I233Ek9MiQX2ELIQ.png)

<center>结果图</center>

要测试该方法的灵活性，你可以修改 JSON 文件：添加或删除一些 friends 数据，或完全删除一些数据（只是不要破坏 JSON 结构，不然，你就无法看到任何数据）。当你重新构建项目时，_tableView_ 将以其应有的方式查找和工作，而无需任何代码修改。 如果要更改 _Model_ 本身，你只需修改 _ViewModel_ 和 _ViewController_：添加新属性，或重构其整个结构。当然那就要另当别论了。

在这里，你可以查看完整的项目：

[Stan-Ost/TableViewMVVM](https://github.com/Stan-Ost/TableViewMVVM)

谢谢你的阅读！如果你有任何问题或建议 - 请随意提问！

在下一篇文章中，我们将升级现有项目，为这些 section 添加一个良好的折叠/展开效果。

* * *

更新：在 [此处](https://medium.com/ios-os-x-development/ios-aimate-tableview-updates-dc3df5b3fe07) 查看如何在不使用 _ReloadData_ 方法的情况下动态更新此 _tableView_。

* * *

_我同时也为美国运通工程博客写作。在 [_AmericanExpress.io_](http://americanexpress.io/) 查看我的其他作品和我那些才华横溢的同事的作品。_

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
