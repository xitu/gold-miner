> * 原文地址：[How to Build an iOS Mobile Group Chat App with Swift 5](https://www.pubnub.com/blog/how-to-build-ios-mobile-group-chat-app-swift-5-pubnub/)
> * 原文作者：[Samba Diallo](https://www.pubnub.com/blog/author/samba_diallo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-ios-mobile-group-chat-app-swift-5-pubnub.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-ios-mobile-group-chat-app-swift-5-pubnub.md)
> * 译者：[LucaslEliane](https://github.com/lucasleliane)
> * 校对者：[江五渣](http://jalan.space)，[Endone](https://github.com/Endone)

# 使用 Swift 5 构建 iOS 移动端群聊 App

无论是独立的[群聊应用](https://www.pubnub.com/solutions/chat/)，嵌入式的客户服务组件，或者是[约会应用里面的私人一对一聊天](https://dev-www.pubnub.com/solutions/chat/dating-apps/)，各种特征和规模的[移动端聊天](https://www.pubnub.com/solutions/chat/)无处不在。

在本教程中，我们将向你展示如何使用 Swift 5 构建一个 iOS 移动聊天应用程序，其可以让任意数量的用户进行实时聊天。我们还将向你展示如何存储消息历史记录，因此当用户离开之后回来时，他们的消息仍然在应用程序中。

为了实现上述的应用，我们使用了 PubNub 的一些关键特性：**[发布/订阅](https://www.pubnub.com/developers/tech/key-concepts/publish-subscribe/)**（实时消息）和 **[存储 & 回放](https://www.pubnub.com/developers/tech/key-concepts/message-caching-persistence/)（消息存储）**。

* **发布**是每个客户端如何将自己的消息发送到全世界的方式，或者至少传递到自己想要发布的频道中。Pub/Sub 模式最简单的应用就是将你发送的每一条消息传递给订阅频道的任何人。发布需要一个 PubNub 连接的实例（我将在后面详细介绍），要发送的消息消息（类型为 String、NSNumber、Array 和 Dictionary），以及我们要将消息发送到的频道。[了解有关 Swift 发布的更多信息。](https://www.pubnub.com/docs/swift/api-reference-publish-and-subscribe#publish)
* **订阅**是 PubNub 即时通信的另外一个部分。为了订阅，我们需要一个 PubNub 连接的实例和一个要订阅的频道。成功订阅后，我们会收到消息，但如果我们在消息到达的时候不进行处理，我们仍然看不到这些消息。[了解有关 Swift 订阅的更多信息](https://www.pubnub.com/docs/swift/api-reference-publish-and-subscribe#subscribe)。
* **事件处理或监听**的更新在 PubNub 的生命周期中非常重要。Pub/Sub 虽然非常引人注目，但使用 PubNub 的关键是事件处理程序，它将[数据流网络](https://www.pubnub.com/products/global-data-stream-network/)连接到我们的控制台和应用程序。它们中的一个专门监听消息，而另一个负责寻找其他任何内容，包括订阅变动和错误。
* **存储和回放**是这个伟大的功能集的另外一个关键点。如果存储和消息检索已导入你的工程，那么存储和播放对你的应用程序来说也是很好的补充。这个功能允许检索历史消息。应用程序消息的范围囊括了应用程序的整个生命周期。我们将设置 PubNub 帐户并获取 API 密钥，在 PubNub 管理控制台中设置存储的生存时间。[了解有关  Swift 中存储和回放的更多信息](https://www.pubnub.com/docs/swift/api-reference-storage-and-playback)。

在看完这个教程之后，你会实现一个提供了聊天室服务的应用，并且这个应用可以是其他任何应用程序很好的基础或者补充。

**[完整的 Swift 5 iOS 聊天应用程序可以在这里找到](https://github.com/SambaDialloB/PubNubChat)**。

## 构建

### PubNub

如果你还没有 PubNub 账户，[可以在这里注册一个帐户](https://dashboard.pubnub.com/signup)。登录后，创建一个新的应用程序。单击它并创建一个新的密钥集或单击已有的演示版。 你现在应该看到发布和订阅密钥，我们可以通过其使用 PubNub API。

在 keys 下，我们可以启用不同的选项！让我们在左下角附近启用存储和回放功能。我们现在可以决定你希望保留多长时间的消息。我选择了一天的保留时长并保存了更改。在保留设置下，还可以设置启用[从 PubNub 历史记录中删除](https://www.pubnub.com/docs/swift/api-reference-storage-and-playback#delete-messages-from-history)。

### Xcode 应用构建

打开 Xcode 并创建一个新项目，选择单视图应用程序，给他起一个名字，然后关闭项目。使用终端导航到项目文件夹，运行命令 `gem install cocoapods` 或运行命令 `gem update cocoapods` 来更新已有的安装。

在终端中输入 `touch Podfile`，为你的应用创建 Podfile，然后使用 `open Podfile` 打开文件。

将下面的代码写入到文件中，确保将“application-target-name”替换为项目的名称。

```swift
source ‘https://github.com/CocoaPods/Specs.git'
# 如果出现编译问题，可以选择取消下面的注释并且填写完整
# project ‘<path to project relative to this Podfile>/<name of project without extension>’
# workspace ‘MyPubNubProject’
use_frameworks!
# 用你的项目名称替换下一行中的引号里面的内容
target ‘application-target-name’ do
# 下面的配置只适用于
# 最小编译目标为
# iOS 8 的项目
platform :ios, ‘8.0’ # (or ‘9.0’ or ‘10.0’)
pod “PubNub”, “~> 4”

```

之后在终端中执行命令 `pod install`。这个命令会帮你在项目中安装 PubNub。安装完成之后，双击 .xcworkspace 文件可以打开项目工程。

## 设计应用程序

在我们开始介绍所有逻辑之前，让我们先设计并构建应用程序的视图。首先我们从登录视图开始。

通过高亮点击类声明中的名字，将 ViewController.swift 重命名为 ConnectVC.swift，并且进入 Editor -> Refactor -> Rename。

当用户打开应用程序时，除了连接按钮外，我们希望他们有一个字段来输入他们想要连接的用户名和频道。将这些添加到你的第一个视图中。另外，我选择了 Topically 作为我们应用程序的标题，你也可以选择一个更酷的标题。

然后，我通过 control + 拖动的方式，将我的 storyboard 上的项目拖动到我的 ConnectVC 文件，来为我的用户名和频道的 TextFields 设置 outlet。对按钮执行相同操作，但不要使用 outlet，而是创建 UIButton 的 action，以便在按下时执行操作。

![使用 PubNub 的聊天应用程序的 Xcode Swift storyboard 截图](https://www.pubnub.com/wp-content/uploads/2019/04/xcode-storyboard-swift-chat-pubnub.png)

接下来，让我们创建频道聊天视图。

创建一个新的 Cocoa Touch 类并将其命名为 ChannelVC。在 storyboard 中创建一个新的视图控制器，并将该类设置为 ChannelVC。选择该视图时，请转到屏幕顶部，然后单击 Editor -> Embed In -> Navigation Controller。另一个视图现在应该在你的 storyboard 中。这是导航控制器，它允许用户在进入视图之间切换。

将一个 UIBarButtonItem 添加到 ChannelVC 导航栏上的左侧位置，这是我们的“离开”按钮。按住 Control 键并将其拖到 ChannelVC.swift，并创建名为 leaveChannel，UIBarButtonItem 类型的 action。将 UITableView 拖到 ChannelVC 视图中。使其占据屏幕的大部分空间，但需要流出空间放置另一个 TextField 和一个带有文本 Send 的按钮。创建它们。

在 ChannelVC.swift 中为 table 和 TextField 创建 outlet，并为发送按钮添加另一个 action。

我们的下一步不涉及我们的 ChannelVC，而是在我们的 table 内创建自定义单元格。一旦我们得到 ChannelVC 设置的总体布局，我们就必须在 tableView 中自定义单元格。创建一个新的 cocoa touch 类并且命名为 MessageCell，并将 UITableViewCell 拖到表视图中。将该 cell 类设置为新类，并将标识符更改为 MessageCell。

拖动任何东西来完成你想要的设计和需要的任何细节。我们将用户名和消息标签放入 cell 中，完成之后，按住 Ctrl 键拖动即可为 MessageCell 类创建 outlet。确保设置样式约束，以便表格不会压缩你的内容。

**有关使你的应用程序适用于所有屏幕尺寸的更多信息，请参阅 [Apple 关于自动布局的文档](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/index.html)或者查阅众多的在线指南。**

现在我们得到很多不错的 view 视图，但它们之间无法进行自由切换。单击 ConnectVC 上方有其名称的栏，然后单击黄色圆圈。按住 Control 键并将其拖动到导航控制器并选择 show 选项。选择导航控制器，单击右侧面板上的属性选项卡，其顶部显示“Storyboard Segue”。将标识符命名为“connectSegue”。当你单击 ConnectVC 上的连接按钮时，就可以执行这个 Segue 了。

我们需要的下一个也是最后一个任务是将我们从 ChannelVC 导航到 ConnectVC。选择 ChannelVC 的方式与 ConnectVC 相同，并将其拖到 ConnectVC。这次选择“Present Modally”并在属性检查器中将其命名为“leaveChannelSegue”。

![PubBub 聊天程序的 Xode Storyboard](https://www.pubnub.com/wp-content/uploads/2019/04/xcode-storyboard-screenshot-chat-pubnub.png)

## 编码：ConnectVC

现在我们已经完成了 storyboard，让我们开始编码。我们将从 ConnectVC 开始，它为我们的 ChannelVC 提供用户名和频道，我们将利用我们所有的 PubNub 知识。首先，在我们的连接操作中执行 segue。

```swift
@IBAction func connectToChannel(_ sender: UIButton) {
    self.performSegue(withIdentifier: "connectSegue", sender: self)
}
```

这利用了我们在上一节中制作的 connectSegue，它将我们导航到了 ChannelVC 的导航控制器。我们在这个视图控制器中唯一需要做的就是为上面的 segue 做准备。通过重写这个功能，我们可以在视图之间发送信息。

**注意：在本教程中，如果用户未提供用户名，我会自动为其分配用户名“A Naughty Moose”。如果他们没有提供频道，我会将他们发送到频道“General”。**

为了访问我们想要访问的视图，我们需要获得导航控制器的实例，然后从那里获取我们的 ChannelVC 视图。我们检查文本字段是否为空，如果需要则替换值，然后使用我们的用户名和频道在 ChannelVC 中设置两个我们尚未创建的变量。

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    // 访问导航控制器和 ChannelVC 视图
    if let navigationController = segue.destination as? UINavigationController,
        let channelVC = navigationController.viewControllers.first as? ChannelVC{
        var username = ""
        var channel = ""

        // 下面的空字符串替换成一个你需要的默认值
        if(usernameTextField.text == "" ){
            username = "A Naughty Moose"
        }
        else{
            username = usernameTextField.text ?? "A Naughty Moose"
        }
        if(channelTextField.text == "" ){
            print("nothing in channel")
            channel = "General"
        }
        else{
            channel = channelTextField.text ?? "General"
        }

        // 设置 ChannelVC 的变量值
        channelVC.username = username
        channelVC.channelName = channel
    }
}
```

## 编码：ChannelVC

在我们的 ChannelVC 中，我们应该有两个 outlet，一个 action，另一个是我们的 viewDidLoad 函数。最重要的是，在类定义下，我们将开始为类的其余部分定义一些我们需要的变量和资源。

首先，让我们的类监听 PubNub 事件并使其与我们的 table 一起工作。在文件顶部引入 PubNub，在我们的类定义中的 UIViewController 写入 PNObjectEventListener、UITableViewDataSource 和 UITableViewDelegate 之后。我们的类现在应该显示错误，单击错误并添加建议的那些类，这样进行引入比较便捷。

* 在我们的类定义下，让我们定义一个结构，使得处理我们的消息更容易一些。我的结构有三个字符串：消息，用户名和 UUID。稍后当我们发布消息时，你可以发送不同的信息并使用这些来更新结构。
* 之后，创建一个 Message 数组并将其初始化为空，因为所有类变量都需要具有某种初始值。
* 为我们最早收到的消息创建一个 NSNumber 类型的标记，并设置标记的初始值为 -1。
* 另一个变量，用于跟踪我们是否已开始加载更多消息。
* 现在，对于这个视图控制器来说，最重要的、用于发布和订阅的变量，是我们将在此视图控制器中调用 PubNub 函数的对象。
* 然后我们得到用户在最后一步中输入的用户名和频道，并使用临时值进行初始化。
* 之后应该是我们的消息文本字段，我们的 tableView，以及我们的发送 action。

```swift
class ChannelVC: UIViewController,PNObjectEventListener, UITableViewDataSource, UITableViewDelegate {

    // 我们的消息结构体，可以让消息的处理更方便
    struct Message {
        var message: String
        var username: String
        var uuid: String
    }
    var messages: [Message] = []

    // 跟踪我们加载的最早的一条消息
    var earliestMessageTime: NSNumber = -1

    // 来跟踪我们是否已经加载了更多消息
    var loadingMore = false

    // 我们使用 PubNub 对象来发布，订阅和获取我们频道的内容
    var client: PubNub!

    // 临时值
    var channelName = "Channel Name"
    var username = "Username"

    //-- 应该已经存在在你的文件里面了
    // 消息入口
    @IBOutlet weak var messageTextField: UITextField!

    // 我们用来自 messages 数组的信息填充了这个 View
    @IBOutlet weak var tableView: UITableView!

    //...

}
```

我们已经建立了一些可以在整个代码中使用的全局变量，接下来，让我们设置 viewDidLoad 函数。在调用继承的 viewDidLoad 之后，将导航控制器顶部的标题更改为频道名称，并将 table view 的 delegate 数据源设置为 self。

```swift
self.navigationController?.navigationBar.topItem?.title = channelName

tableView.delegate = self
tableView.dataSource = self
```

接下来，我们配置并初始化我们的 PubNub 对象。你可以在此处插入 PubNub 帐户中的发布和订阅密钥。我们将 stripMobilePayload 设置为 false，因为它已弃用，并为此连接提供唯一的 UUID，这使我们在将来更容易开发更多功能。接着初始化它，将它设置为监听器，并订阅用户选择的频道。然后我们调用将在下一步创建的方法 loadLastMessages。

```swift
// 设置我们的 PubNub 对象！
let configuration = PNConfiguration(publishKey: "INSERT PUBLISH KEY", subscribeKey: "INSERT SUBSCRIBE KEY")
// 删除已经弃用的警告
configuration.stripMobilePayload = false
// 给每个连接设置标志以供将来进行开发
configuration.uuid = UUID().uuidString
client = PubNub.clientWithConfiguration(configuration)
client.addListener(self)
client.subscribeToChannels([channelName],withPresence: true)

// 我们加载最后的消息来填充 tableview
loadLastMessages()
```

现在应该有一个 error，说我们在 viewDidLoad 末尾调用的函数是未定义的，所以让我们定义它！此功能用于在连接到通道时加载初始消息。它利用我们即将创建的，名为 addHistory 的另一个函数。

让我们调用下一个函数，使用 nil 作为开始和结束，然后设置你想要接收的消息的数量，最多为 100。我们在函数内部的最后一个操作是将我们的 table view 向下滚动到表格底部的新消息。

```swift
// 当这个视图初始化加载来填充 tableview 的时候，将调用此函数
func loadLastMessages()
{
    addHistory(start: nil, end: nil, limit: 10)
    // 将 tableview 滚动到最新消息的底部
    if(!self.messages.isEmpty){
        let indexPath = IndexPath(row: self.messages.count-1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
```

### 存储和回放历史消息

现在，我们可以通过这个功能回顾我们频道的历史记录。使用一些关键参数创建它，只有 limit 参数是必须的，然后调用函数就可以允许我们查看频道历史记录了。

我们使用具有许多重载版本的函数 historyForChannel。我们可以使用返回最后 100 条消息的简单消息或者接收开始和结束时间的消息，这两种方法都由 PNHistoryResultBlock 处理，这允许我们访问查询结果和 error。

首先，让我们检查结果是否为非空，如果是，我们就可以开始访问消息了！一旦我们知道我们的消息至少包含某些内容，我们就可以开始访问它们。我们需要使用我们在结果中收到的最早消息来更新我们的 earlistMessage 开始时间。接下来将我们返回的对象转换为我们可以使用的对象，一个键值为 String 类型的数组。

我们可以从这个新对象创建一个 Message 对象，将它们添加到一个临时数组中，然后将它插入到我们的全局消息数组的开头而不是每次都去费力地直接访问这些对象。确保重新加载表格然后检查错误！

```swift
// 获取并且将频道的历史消息放入到 messages 数组中
func addHistory(start:NSNumber?,end:NSNumber?,limit:UInt){
    // PubNub 函数，它返回 X 消息的对象，然后发送第一个和最后一个消息的时间
    // limit 是接收的消息数量，最大值为 100，默认值为 100
    client.historyForChannel(channelName, start: start, end: end, limit:limit){ (result, status) in
        if(result != nil && status == nil){

            // 当我们想要加载更多的时候，我们会保存最早发送的消息的时间，以便获取之前的消息。
            self.earliestMessageTime = result!.data.start

            // 将我们获得的 [Any] 包转换为 String 和 Any 的 dictionary
            let messageDict = result!.data.messages as! [[String:String]]

            // 从中创建新的消息并且将它们放在消息数组的末尾
            var newMessages :[Message] = []
            for m in messageDict{
                let message = Message(message: m["message"]! , username: m["username"]!, uuid: m["uuid"]! )
                newMessages.append(message)
            }
            self.messages.insert(contentsOf: newMessages, at: 0)
            // 使用新的消息重新加载 tableview，并且将 tableview 向下滚动到最新消息的底部
            self.tableView.reloadData()

            // 确保在加载完成之前，我们无法尝试重新加载更多数据
            self.loadingMore = false
        }
        else if(status !=  nil){
            print(status!.category)

        }
        else{
            print("everything is nil whaaat")
        }
    }
}
```

接下来，让我们填写 tableView 所需的函数。第一个，numberOfRowsInSection 是一个简单的单行函数，返回数组中的消息数。第二个函数，我们首先需要获取消息 cell 的实例，并将 cell 标签的文本设置为消息和消息数组索引的用户名。然后，直接返回 cell 就可以了！

```swift
// 需要 tableview 函数
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 后面修改
    return messages.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell

    cell.messageLabel.text = messages[indexPath.row].message
    cell.usernameLabel.text = messages[indexPath.row].username


    return cell
}
```

在 Swift 中使用和调试 PubNub 最重要的部分之一就是为事件和消息创建监听器。在这个应用程序中，我们使用函数 didRecieveMessage，这个函数允许我们访问进入到我们频道的消息。此函数内部的逻辑就是我们的 loadLastMessages 函数的精简版本。

检查进来的消息是否与我们订阅的频道匹配，以防我们订阅到其他频道的内容。获取我们给出的消息，并将其转换为键值类型为 String 的数组。使用该 dictionary 创建消息并将其绑定到消息数组的末尾。

再次重新加载数据，然后向下滚动到新消息。可以根据你想要的实现更改这个操作。我在控制台中打印消息以便进行调试。

```swift
func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
    // 每当我们收到一条新的消息时，我们都会将它添加到我们消息数组的末尾
    // 重新加载 table，以便消息展示在底部

    if(channelName == message.data.channel)
    {
        let m = message.data.message as! [String:String]
        self.messages.append(Message(message: m["message"]!, username: m["username"]!, uuid: m["uuid"]!))
        tableView.reloadData()


        let indexPath = IndexPath(row: messages.count-1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)

    }

    print("Received message in Channel:",message.data.message!)
}
```

现在我们可以在第一次打开频道时加载一些历史消息，当发送新消息时，它们会显示在底部。

如果有比我们最初加载的消息更多的消息怎么办？在这个新函数 scrollViewDidScroll 中，当我们从顶部向下拉时，我们从 historyForChannel 中提取了另外一些消息。这个函数也可以修改，以便当用户没有到达页面顶部时，它可以进行预加载，来帮助实现一个无限滚动的效果。

我们有一个名为 loadingMore 的全局变量，我们在开始时检查是否已经加载了更多消息，然后检查用户是否滚动超过某个阈值来开始加载更多消息。值得庆幸的是，使用 PubNub 非常快，所以几乎可以立即加载。一旦真的有更多历史消息，我们将 loadingMore 设置为 true 并开始调用我们的 addHistory 函数，将 earliestMessageTime 作为开始，将 nil 作为结束，可以根据你的需求来设置 limit，尽管返回消息的最大值是 100。

```swift
// 这个方法允许用户通过从顶部向下拖动来查询更多消息
func scrollViewDidScroll(_ scrollView: UIScrollView){
    //If we are not loading more messages already
    if(!loadingMore){

        // 当从消息顶部向下拖动超过 -40 的时候
        if(scrollView.contentOffset.y < -40 ) {
            loadingMore = true
            addHistory(start: earliestMessageTime, end: nil, limit: 10)
        }
    }

}
```

我们现在需要在单击“发送”按钮时发布消息。为此，让我们创建一个函数来发送 messageTextField 中的消息。首先，我们检查 messageTextField 是否为空，如果是，则进行处理，然后创一个 dictionary 用于包含你要发送的消息信息，之后在 PubNub 对象上使用简单发布功能。

这个函数接收多种类型的变量和对象作为消息和频道名称发送。你也可以在回调中包含一个处理程序，以根据状态代码执行某些操作。之后，调用我们刚刚在 sendMessage  操作中创建的函数。

```swift
func publishMessage() {
    if(messageTextField.text != "" || messageTextField.text != nil){
        let messageString: String = messageTextField.text!
        let messageObject : [String:Any] =
            [
                "message" : messageString,
                "username" : username,
                "uuid": client.uuid()
        ]

        client.publish(messageObject, toChannel: channelName) { (status) in
            print(status.data.information)
        }
        messageTextField.text = ""
    }

}

// 单击发送按钮的时候，将会发送消息
@IBAction func sendMessage(_ sender: UIButton) {
    publishMessage()
}
```

为了使我们的应用程序完全正常工作，我们需要能够离开频道并返回 ConnectVC。我们已经有了这个功能，我们只需要填写它。取消订阅客户订阅的所有频道，然后执行我们最初创建的“leaveChannelSegue”。

```swift
client.unsubscribeFromAll()
self.performSegue(withIdentifier: "leaveChannelSegue", sender: self)
```

## 运行 App

让我们来运行一下这个应用程序！

![PubNub Swift 聊天应用程序](https://www.pubnub.com/wp-content/uploads/2019/04/pubnub-swift-chat.gif)

我们现在拥有了基本的聊天功能。用户可以实时发送和接收消息，并且历史消息可以被存储一段时间。

[这个项目完整的 Github 仓库在这里](https://github.com/SambaDialloB/PubNubChat)

PubNub 提供每个月一百万条免费的消息。这里有 [PubNub Swift SDK 文档](https://www.pubnub.com/docs/swift/pubnub-swift-sdk)，以及其他 [75+ PubNub 客户端 SDKs。](https://www.pubnub.com/developers/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
