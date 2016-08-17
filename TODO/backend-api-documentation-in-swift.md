> * 原文地址：[Backend API Documentation in Swift](https://medium.com/ios-os-x-development/backend-api-documentation-in-swift-92b4874e4f78#.g2ofuey9d)
* 原文作者：[Christopher Truman](https://medium.com/@iamchristruman?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Nicolas(Yifei) Li](https://github.com/yifili09) 
* 校对者： 

我最近开始开发一个全新的项目，并且我正尝试建立一些新的设计模式，因为我开始投身于 `Swift 3`。我正使用的一个模式是“请求和响应模型”。这是我为记录这个后台 `API` 的结构想到的一个好听的名字。让我们来看一个例子：

```
import Alamofire

protocol Request {
    var path : String { get }
    var method : Method { get }
    func parameters() -> [String : AnyObject]
}

struct AuthRequest : Request {
    let path = "auth"
    let method = Method.POST

    var password : String
    var password_verify : String
    var name : String
    var email : String

    func parameters() -> [String : AnyObject] {
        return ["password" : password, "password_verify" : password_verify, "name" : name, "email" : email]
    }
}
```

我们有一个请求协议，它指定了基本上你需要知道的发起一个 `API` 请求的所有内容。

* 需要添加进基本地址的路径（就这个例子来说是 `auth`）
* `HTTP` 方法（`GET`, `POST`, `PUT`, `DELETE` etc.）
* 端点所要求的参数

你可以扩展这个协议，为了需要例如某个指定的 `ContentType` 或者其他 `HTTP` 报头的信息。你能想象到增加一些验证规则，（请求）完成处理方法，或者与这个协议网络请求有关的任何东西。

所有这些结构现在应该看上去像一个简明扼要的 `API` 文档，并且提供了对你的计算机网络一些框架结构和类型安全。你可以把这个请求结构转变成你最喜欢的网络客户端。我有一个例子 [Alamofire](https://github.com/Alamofire/Alamofilre/tree/swift3)

```
class Client {
    var baseURL = "http://dev.whatever.com/"

    func execute(request : Request, completionHandler: (Response<AnyObject, NSError="">) -> Void){
        Alamofire.request(request.method, baseURL + request.path, parameters: request.parameters())
            .responseJSON { response in
                completionHandler(response)
        }
    }
}

Client().execute(request: AuthRequest(/*Insert parameters here*/), completionHandler: { response in } )
```

我们把 `AuthRequest` 对象传递给 `Alamofire`，它需要一个通用的对象去确认请求协议。它使用来自协议中的属性/方法来组成和执行一个网络请求。

现在我们已经定义了这个请求的结构，并且使用它简单的访问服务器。我们现在需要处理响应。我们的 `AuthRequest` 返回一个不太大的用户 `JSON` 对象，我们需要把他序列化成一个 `Swift` 对象。

```
struct UserResponse {
    var _id : String
    var first_name : String
    var last_name : String

    init(JSON: [String : AnyObject]) {
        _id = JSON["_id"] as! String
        first_name = JSON["first_name"] as! String
        last_name = JSON["last_name"] as! String
    }
}

/* Inside our completion handler */
var user = UserResponse(JSON: response.result.value as! [String : AnyObject])

```

这个实现不太花哨，但是仍然记录了响应对象的属性。你能创建一个协议，用来定义一个初始器来等待 `JSON`，但是使用简单的结构目前对我来说已经足够了。

你发现这个实现有任何问题么？我能更高效地使用协议/扩展来组成我的网络请求代码么？请让我知道！[@iAmChrisTruman](https://twitter.com/iAmChrisTruman)
