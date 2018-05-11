> * 原文地址：[Writing a Network Layer in Swift: Protocol-Oriented Approach](https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908)
> * 原文作者：[Malcolm Kumwenda](https://medium.com/@malcolmcollin?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/writing-network-layer-in-swift-protocol-oriented-approach.md](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-network-layer-in-swift-protocol-oriented-approach.md)
> * 译者：[talisk](https://github.com/talisk)
> * 校对者：[ALVINYEH](https://github.com/ALVINYEH)，[rydensun](https://github.com/rydensun)

# Swift 写网络层：用面向协议的方式

![](https://cdn-images-1.medium.com/max/2000/1*Kye90jVLsFUfHx2AQ497wg.png)

在本指南中，我们将介绍如何在没有任何第三方库的情况下以纯 Swift 实现网络层。让我们快开始吧！阅读了本指南后，我们的代码应该是：

*   面向协议
*   易于使用
*   易于实现
*   类型安全
*   使用枚举来配置 endPoints

以下是我们最终通过网络层实现的一个例子：

![](https://cdn-images-1.medium.com/max/800/0*eV_EkKllHSk2l6H-.)

该项目的最终目标。

借助枚举输入 **router.request(.**，我们可以看到所有可用的端点以及该请求所需的参数。

### 首先，一些关于结构的东西

在创建任何东西时，结构总是非常重要的，好的结构便于以后找到所需。我坚信文件夹结构是软件架构的一个关键贡献者。为了让我们的文件保持良好的组织性，我们事先就创建好所有组，然后记下每个文件应该放在哪里。这是一个对项目结构的概述。（**请注意以下名称都只是建议，你可以根据自己的喜好命名你的类和分组。**）

![](https://cdn-images-1.medium.com/max/800/0*gbQHZBOhWIroMl_i.)

项目目录结构。

### EndPointType 协议

我们需要的第一件事是定义我们的 **EndPointType** 协议。该协议将包含配置 EndPoint 的所有信息。什么是 EndPoint？本质上它是一个 URLRequest，它包含所有包含的组件，如标题，query 参数和 body 参数。**EndPointType** 协议是我们网络层实现的基石。接下来，创建一个文件并将其命名为 **EndPointType**。将此文件放在 **Service** 组中。（请注意不是 **EndPoint** 组，这会随着我们的继续变得更清晰）。

![](https://cdn-images-1.medium.com/max/800/0*WQX-_ikNnYOBIVAR.)

EndPointType 协议。

### HTTP 协议

我们的 **EndPointType** 具有构建整个 endPoint 所需的大量HTTP协议。让我们来探索这些协议的含义。

#### HTTPMethod

创建一个名为 **HTTPMethod** 的文件，并把它放到 **Service** 组里。这个枚举将被用于为我们的请求设置 HTTP 方法。

![](https://cdn-images-1.medium.com/max/800/0*cnfKl7UrZs6GD_up.)

HTTPMethod 枚举。

#### HTTPTask

创建一个名为 **HTTPTask** 的文件，并把它放到 **Service** 组里。HTTPTask 负责为特定的 endPoint 配置参数。你可以添加尽可能多的适用于你的网络层要求的情况。 我将要发一个请求，所以我只有三种情况。

![](https://cdn-images-1.medium.com/max/800/0*5dkZJhRbMFNknHwi.)

HTTPTask 枚举。

我们将在下一节讨论**参数**以及参数的编解码。

#### HTTPHeaders

**HTTPHeaders** 仅仅是字典的 typealias（别名）。你可以在 **HTTPTask** 文件的开头写下这个 typealias。

```
public typealias HTTPHeaders = [String:String]
```

### 参数及其编解码

创建一个名为 **ParameterEncoding** 的文件，并把它放到 **Encoding** 组里。然后首要之事便是定义 **Parameters** 的 typealias。我们利用 typealias 使我们的代码更简洁、清晰。

```
public typealias Parameters = [String:Any]
```

接下来，用一个静态函数 **encode** 定义一个协议 **ParameterEncoder**。**encode** 方法包含 **inout URLRequest** 和 **Parameters** 这两个参数。**inout** 是一个 Swift 的关键字，它将参数定义为引用参数。通常来说，变量以值类型传递给函数。通过在参数前面添加 **inout**，我们将其定义为引用类型。要了解更多关于 **inout** 参数的信息，你可以参考[这里](http://ios-tutorial.com/in-out-parameters-swift/)。**ParameterEncoder**协议将由我们的 **JSONParameterEncoder** 和 **URLPameterEncoder** 实现。

```
public protocol ParameterEncoder {
 static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
```

**ParameterEncoder** 执行一个函数来编码参数。此方法可能失败而抛出错误，需要我们处理。

可以证明抛出自定义错误而不是标准错误是很有价值的。我总是发现自己很难破译 Xcode 给出的一些错误。通过自定义错误，您可以定义自己的错误消息，并确切知道错误来自何处。为此，我只需创建一个从 **Error** 继承的枚举。

![](https://cdn-images-1.medium.com/max/800/0*-P95FoFQ9zImpGCz.)

NetworkError 枚举。

#### URLParameterEncoder

创建一个名为 **URLParameterEncoder** 的文件，并把它放到 **Encoding** 组里。

![](https://cdn-images-1.medium.com/max/800/0*GuX8ZxKQAlnj5t0e.)

URLParameterEncoder 的代码。

上面的代码传递了参数，并将参数安全地作为 URL 类型的参数传递。正如你应该知道，有一些字符在 URL 中是被禁止的。参数需要用「&」符号分开，所以我们应该注意遵循这些规范。如果没有设置 header，我们也要为请求添加适合的 header。

这个代码示例是我们应该考虑使用单元测试进行测试的。正确构建 URL 是至关重要的，不然我们可能会遇到许多不必要的错误。如果你使用的是开放 API，你肯定不希望配额被大量失败的测试耗尽。如果你想了解更多有关单元测试方面的知识，可以阅读 [S.T.Huang](https://medium.com/@koromikoneo) 写的[这篇文章](https://medium.com/flawless-app-stories/the-complete-guide-to-network-unit-testing-in-swift-db8b3ee2c327)。

### JSONParameterEncoder

创建一个名为 **JSONParameterEncoder** 的文件，并把它放到 **Encoding** 组里。

![](https://cdn-images-1.medium.com/max/800/0*KNCxD7C71WmPBLTC.)

JSONParameterEncoder 的代码。

与 **URLParameter** 解码器类似，但在此，我们把参数编码成 JSON，再次添加适当的 header。

### NetworkRouter

创建一个名为 **NetworkRouter** 的文件，并把它放到 **Service** 组里。我们来定义一个 block 的 typealias。

```
public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()
```

接下来我们定义一个名为 **NetworkRouter** 的协议。

![](https://cdn-images-1.medium.com/max/800/0*aNdQ3nHwAXcv0wKD.)

NetworkRouter 的代码。

一个 **NetworkRouter** 具有用于发出请求的 **EndPoint**，一旦发出请求，就会将响应传递给完成的 block。我已经添加了一个非常好的取消请求的功能，但不要深入探究它。这个功能可以在请求生命周期的任何时候调用，然后取消请求。如果您的应用程序有上传或下载的功能，取消请求可能会是非常有用的。我们在这里使用 **associatedtype**，因为我们希望我们的 **Router** 能够处理任何 **EndPointType**。如果不使用 **associatedtype**，则 router 必须具有具体的 **EndPointType**。更多有关 **associatedtypes** 的内容，我建议可以看下 [NatashaTheRobot 写的这篇文章](https://www.natashatherobot.com/swift-what-are-protocols-with-associated-types/)。

### Router

创建一个名为 **Router** 的文件，并把它放到 **Service** 组里。我们声明一个类型为 **URLSessionTask** 的私有变量 task。这个 task 变量本质上是要完成所有的工作。我们让变量声明为私有，因为我们不希望在这个类之外还能修改这个 task 变量。

![](https://cdn-images-1.medium.com/max/800/0*HE_JNaCCPFjhyPqu.)

Router 方法的代码。

#### Request

这里我们使用 sharedSession 创建一个 URLSession。这是创建 URLSession 最简单的方法。但请记住，这不是唯一的方法。更复杂的 URLSession 配置可用可以改变 session 行为的 configuration 来实现。要了解更多信息，我建议花点时间阅读下[这篇文章](https://www.raywenderlich.com/158106/urlsession-tutorial-getting-started)。

这里我们通过调用 **buildRequest** 方法来创建请求，并传入名为 **route** 的一个 **EndPoint** 类型参数。由于我们的解码器可能会抛出一个错误，这段调用用一个 do-try-catch 块包起来。我们只是单纯地把所有请求、数据和错误传给 completion 回调。

![](https://cdn-images-1.medium.com/max/800/0*qUwPqibb5mhGO2sI.)

Request 方法的代码.

#### 创建 Request

在 **Router** 里面创建一个名为 **buildRequest** 的私有方法，这个方法会在我们的网络层中负责至关重要的工作，从本质上把 **EndPointType** 转化为 **URLRequest**。一旦我们的 **EndPoint** 发出了一个请求，我们就把他传递给 session。这里做了很多工作，我们来逐一看看每个方法。让我们分解 **buildRequest** 方法：

1. 我们实例化一个 **URLRequest** 类型的变量请求。传给它我们的 URL 前半段，并附加我们要使用的特定路径。
2. 我们将请求的 **httpMethod** 设置为和 **EndPoint** 相同的 **httpMethod**。
3. 我们创建了一个 do-try-catch 块，因为我们的编码器抛出错误。通过创建一个大的 do-try-catch 块，我们不必每次尝试创建一个单独的 do-try-catch。
4. 开启 **route.task**。
5. 根据 task 变量，调用适当的编码器。

![](https://cdn-images-1.medium.com/max/800/0*4TPvOc1LjttZDmxF.)

buildRequest 方法的代码。

#### 配置参数

创建一个名为 **configureParameters** 的方法，并把它放到 **Router** 里面。

![](https://cdn-images-1.medium.com/max/800/0*49iY9tUA5EsHN76i.)

configureParameters 方法的实现。

这个函数负责编码我们的参数。由于我们的API期望所有 **bodyParameters** 是 JSON 格式的，以及 **URLParameters** 是 URL 编码的，我们将相应的参数传递给其指定的编码器即可。如果您正在处理具有不同编码风格的 API，我会建议修改 **HTTPTask** 以获取编码器枚举。这个枚举应该有你需要的所有不同风格的编码器。然后在 configureParameters 里面添加编码器枚举的附加参数。适当地调用枚举并编码参数。

#### 添加额外的 header

创建一个名为 **addAdditionalHeaders** 的方法，并把它放到 **Router** 里面。

![](https://cdn-images-1.medium.com/max/800/0*mnyRBFq6ECW1YGqH.)

addAdditionalHeaders 方法的实现。

#### 只需将所有附加标题添加为请求标题的一部分即可

#### 取消请求

cancel 方法的实现就像下面这样：

![](https://cdn-images-1.medium.com/max/800/0*2Wglip7ThvVgBkki.)

cancel 方法的实现。

### 实践

现在让我们把封装好的网络层在实际样例项目中进行实践。我们将用 [TheMovieDB🍿](https://developers.themoviedb.org/3) 获取一些数据，并展示在我们的应用中。

### MovieEndPoint

**MovieEndPoint** 与我们在 [Getting Started with Moya](https://medium.com/flawless-app-stories/getting-started-with-moya-f559c406e990)（如果没看过的话就看看）中的 Target 类型非常相近。**Moya** 中的 TargetType，在我们今天的例子中是 **EndPointType**。把这个文件放到 **EndPoint** 分组当中。

```
import Foundation


enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum MovieApi {
    case recommended(id:Int)
    case popular(page:Int)
    case newMovies(page:Int)
    case video(id:Int)
}

extension MovieApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://api.themoviedb.org/3/movie/"
        case .qa: return "https://qa.themoviedb.org/3/movie/"
        case .staging: return "https://staging.themoviedb.org/3/movie/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .recommended(let id):
            return "\(id)/recommendations"
        case .popular:
            return "popular"
        case .newMovies:
            return "now_playing"
        case .video(let id):
            return "\(id)/videos"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .newMovies(let page):
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: ["page":page,
                                                      "api_key":NetworkManager.MovieAPIKey])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
```

EndPointType

### MovieModel

我们的 **MovieModel** 也不会改变，因为 TheMovieDB 的响应是相同的 JSON 格式。我们利用 Decodable 协议将我们的 JSON 转换为我们的模型。将此文件放在 **Model** 组中。

```
import Foundation

struct MovieApiResponse {
    let page: Int
    let numberOfResults: Int
    let numberOfPages: Int
    let movies: [Movie]
}

extension MovieApiResponse: Decodable {
    
    private enum MovieApiResponseCodingKeys: String, CodingKey {
        case page
        case numberOfResults = "total_results"
        case numberOfPages = "total_pages"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieApiResponseCodingKeys.self)
        
        page = try container.decode(Int.self, forKey: .page)
        numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
        numberOfPages = try container.decode(Int.self, forKey: .numberOfPages)
        movies = try container.decode([Movie].self, forKey: .movies)
        
    }
}


struct Movie {
    let id: Int
    let posterPath: String
    let backdrop: String
    let title: String
    let releaseDate: String
    let rating: Double
    let overview: String
}

extension Movie: Decodable {
    
    enum MovieCodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case backdrop = "backdrop_path"
        case title
        case releaseDate = "release_date"
        case rating = "vote_average"
        case overview
    }
    
    
    init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)
        
        id = try movieContainer.decode(Int.self, forKey: .id)
        posterPath = try movieContainer.decode(String.self, forKey: .posterPath)
        backdrop = try movieContainer.decode(String.self, forKey: .backdrop)
        title = try movieContainer.decode(String.self, forKey: .title)
        releaseDate = try movieContainer.decode(String.self, forKey: .releaseDate)
        rating = try movieContainer.decode(Double.self, forKey: .rating)
        overview = try movieContainer.decode(String.self, forKey: .overview)
    }
}
```

Movie Model

### NetworkManager

创建一个名为 **NetworkManager** 的文件，并将它放在 **Manager** 分组中。现在我们的 NetworkManager 将有两个静态属性：你的 API key 和 网络环境（参考 **MovieEndPoint**）。**NetworkManager** 也有一个 **MovieApi** 类型的 **Router**。

![](https://cdn-images-1.medium.com/max/800/1*2Tks6DbNHw2XKl2i-0yH_Q.png)

Network Manager 的代码。

#### Network Response

在 **NetworkManager** 里创建一个名为 **NetworkResponse** 的枚举。

![](https://cdn-images-1.medium.com/max/800/0*D60Pp9d8uEruYN_X.)

Network Response 枚举。

我们将用这些枚举去处理 API 返回的结果，并显示合适的信息。

#### Result

在 **NetworkManager** 中创建一个名为 **Result** 的枚举。

![](https://cdn-images-1.medium.com/max/800/0*g_HgQtY9Cn66fuSU.)

Result 枚举。

Result 这个枚举非常强大，可以用来做许多不同的事情。我们将使用 Result 来确定我们对 API 的调用是成功还是失败。如果失败，我们会返回一条错误消息，并说明原因。想了解更多关于 Result 对象编程的信息，你可以 [观看或阅读本篇](https://academy.realm.io/posts/tryswift-saul-mora-result-oriented-development/)。

#### 处理 Network 响应

创建一个名为 **handleNetworkResponse** 的方法。这个方法有一个 **HTTPResponse** 类型的参数，并返回 **Result<String>** 类型的值。

![](https://cdn-images-1.medium.com/max/800/0*3Lex0gRiQOJeCu8s.)

这里我们运用 HTTPResponse 状态码。状态码是一个告诉我们响应值状态的 HTTP 协议。通常情况下，200 至 299 的状态码都表示成功。需要了解更多关于 statusCodes 的信息可以阅读 [这篇文章](http://www.restapitutorial.com/httpstatuscodes.html).

### 调用

因此，现在我们为我们的网络层奠定了坚实的基础。现在该去调用了！

我们将要从 API 拉取一个新电影的列表。创建一个名为 **getNewMovies** 的方法。

![](https://cdn-images-1.medium.com/max/800/0*9WYyT_jhq098o2Ac.)

getNewMovies 方法实现。

我们来分解这个方法的每一步：

1. 我们用两个参数定义 **getNewMovies** 方法：一个页码和一个成功回调，它返回 Movie 可选值数组或可选值错误消息。
2. 调用我们的 Router。传入页码并在闭包内处理回调。
3. 如果没有网络，或由于某种原因无法调用 API，**URLSession** 将返回错误。请注意，这不是 API 异常。这样的异常是客户端的原因，可能是网络连接有问题。
4. 因为我们需要访问 statusCode 属性，所以我们需要将 **response** 传递给 **HTTPURLResponse**。
5. 我们声明 **result**，这是我们从 **handleNetworkResponse** 方法得到的。然后我们检查 switch-case 块中的结果。
6. **success** 意味着我们能够成功地与 API 进行通信并获得适当的响应。然后我们检查响应是否带有数据。如果没有数据，我们只需使用 return 语句退出该方法。
7. 如果响应返回数据，我们需要将数据解码到我们的模型。然后我们将解码的 Movie 传递给回调。
8. 在 **failure** 的情况下，我们只是将错误传递给回调。

完成了！这是我们用纯 Swift 写的，没有用到 Cocoapods 和第三方库的网络层。为了测试获得电影列表的 API，使用 Network Manager 创建一个 ViewController，然后在 mamager 上调用 getNewMovies 方法。

```
class MainViewController: UIViewController {
    
    var networkManager: NetworkManager!
    
    init(networkManager: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        networkManager.getNewMovies(page: 1) { movies, error in
            if let error = error {
                print(error)
            }
            if let movies = movies {
                print(movies)
            }
        }
    }
}
```

MainViewControoler 的例子。

### 网络日志

我最喜欢的 Moya 功能之一就是网络日志。它通过记录所有网络流量，来使调试和查看请求和响应更容易。当我决定实现这个网络层时，这是我非常想要的功能。创建一个名为 **NetworkLogger** 的文件，并将其放入 **Service** 组中。我已经实现了将请求记录到控制台的代码。我不会显示应该把这个代码放在我们的网络层的什么位置。作为你的挑战，请继续创建一个将响应记录到控制台的方法，并在我们的项目结构中找到放置这些函数调用的合适位置。[放置 Gist 文件]

**提示**：**static func log(response: URLResponse) {}**

### 彩蛋

有没有发现自己在 Xcode 中有一个你不太了解的占位符？例如，让我们看看我们为 **Router** 实现的代码。

![](https://cdn-images-1.medium.com/max/800/0*scwoD53jgJcYyqkA.)

**NetworkRouterCompletion** 是需要用户实现的。尽管我们已经实现了它，但有时很难准确地记住它是什么类型以及我们应该如何使用它。这让我们亲爱的 Xcode 来拯救吧！只需双击占位符，Xcode 就会完成剩下的工作。

![](https://cdn-images-1.medium.com/max/800/0*MueEsqJYDaK8kVB6.)

### 结论

现在我们有一个完全可以自定义的、易于使用的、面向协议的网络层。我们可以完全控制其功能并彻底理解其机制。通过这个练习，我可以真正地说我自己学到了一些新的东西。所以我对这部分工作感到自豪，而不是仅仅安装了一个库。希望这篇文章证明了在 Swift 中创建自己的网络层并不难。😜就像这样：

你可以到[我的 GitHub](https://github.com/Mackis/NetworkLayer) 上找到源码，感谢你的阅读！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
