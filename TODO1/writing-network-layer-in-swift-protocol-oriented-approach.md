> * 原文地址：[Writing a Network Layer in Swift: Protocol-Oriented Approach](https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908)
> * 原文作者：[Malcolm Kumwenda](https://medium.com/@malcolmcollin?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/writing-network-layer-in-swift-protocol-oriented-approach.md](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-network-layer-in-swift-protocol-oriented-approach.md)
> * 译者：
> * 校对者：

# Writing a Network Layer in Swift: Protocol-Oriented Approach

![](https://cdn-images-1.medium.com/max/2000/1*Kye90jVLsFUfHx2AQ497wg.png)

In this guide we’ll look at how to implement a network layer in pure Swift without any third-party libraries. Lets’ jump straight to it! After reading the guide, our code should be:

*   protocol-oriented
*   easy to use
*   easy to implement
*   type safe
*   use enums to configure endPoints.

Below is an example of what we’ll ultimately achieve with our network layer:

![](https://cdn-images-1.medium.com/max/800/0*eV_EkKllHSk2l6H-.)

End goal for the project.

By just typing **_router.request(._**with the power of enums we can see all the endPoints that are available to us and the parameters needed for that request.

### First, Some Structure

When creating anything it is always important to have structure, so it will be easy to find things later on. I’m a firm believer that folder structure is a key contributor to software architecture. To keep our files well organised let’s create all our groups beforehand and I will make note of where each file should go. Here is an overview of the project structure. (_Please note names are only suggestions, you can name your classes and groups whatever you prefer._)

![](https://cdn-images-1.medium.com/max/800/0*gbQHZBOhWIroMl_i.)

Project folder structure.

### EndPointType Protocol

The first thing that we need is to define our **_EndPointType_** protocol. This protocol will contain all the information to configure an EndPoint. What is an EndPoint? Well, essentially it is a URLRequest with all its comprising components such as headers, query parameters, and body parameters. The **_EndPointType_** protocol is the cornerstone of our network layers implementation. Go ahead, create a file and name it **_EndPointType_**. Place this file in the _Service_ group. (Not the _EndPoint_ group, this will be made clearer as we continue).

![](https://cdn-images-1.medium.com/max/800/0*WQX-_ikNnYOBIVAR.)

EndPointType Protocol.

### HTTP Protocols

Our **_EndPointType_** has a number of HTTP protocols that we need for building an entire endPoint. Let’s explore what these protocols entail.

#### HTTPMethod

Create a file named **_HTTPMethod_ **andplace it in the **_Service_** group. This enum will be used to set the HTTP method of our request.

![](https://cdn-images-1.medium.com/max/800/0*cnfKl7UrZs6GD_up.)

HTTPMethod enum.

#### HTTPTask

Create a file named **_HTTPTask_ **andplace it inside the **_Service_** group. The HTTPTask is responsible for configuring parameters for a specific endPoint. You can add as many cases as are applicable to your Network Layers requirements. I will be making requests so I only have three cases.

![](https://cdn-images-1.medium.com/max/800/0*5dkZJhRbMFNknHwi.)

HTTPTask enum.

We will discuss **_Parameters_ **and how we handle encoding parameters in the next section.

#### HTTPHeaders

**_HTTPHeaders_** is simply just a typealias for a dictionary. You can create this typealias at the top of your **_HTTPTask_** file.

```
public typealias HTTPHeaders = [String:String]
```

### Parameters & Encoding

Create a file named **_ParameterEncoding_ **andplace it inside the **_Encoding_** group. The first thing that we define is a **_Parameters_ **typealias. We use a typealias to make our code cleaner and more concise.

```
public typealias Parameters = [String:Any]
```

Next, define a protocol **_ParameterEncoder_ **with one static function _encode._ The _encode_ method takes two parameters an **_inout URLRequest_** and **_Parameters_**. (To avoid ambiguity from henceforth I will refer to function parameters as arguments.) **INOUT** is a Swift keyword that defines an argument as a reference argument. Usually, variables are passed to functions as value types. By placing **_inout_** in front of the argument we define it as a reference type. To learn more about **_inout_** arguments you can head over [here](http://ios-tutorial.com/in-out-parameters-swift/). The **_ParameterEncoder_** protocol will be implemented by our **_JSONParameterEncoder_** and **_URLPameterEncoder_**.

```
public protocol ParameterEncoder {
 static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
```

A **_ParameterEncoder_** performs one function which is to encode parameters. This method can fail so it throws an error and we need to handle.

It could prove valuable to throw custom errors instead of standard errors. I always find myself having a hard time trying to decipher some of the errors Xcode gives. By having custom errors you can define your own error message and know exactly where the error came from. To do this I simply create an enum that inherits from **Error**.

![](https://cdn-images-1.medium.com/max/800/0*-P95FoFQ9zImpGCz.)

NetworkError enum.

#### URLParameterEncoder

Create a file named **_URLParameterEncoder_** and place it inside the **_Encoding_** group.

![](https://cdn-images-1.medium.com/max/800/0*GuX8ZxKQAlnj5t0e.)

URLParameterEncoder code.

The code above takes parameters and makes them safe to be passed as URL parameters. As you should know some characters are forbidden in URLs. Parameters are also separated by the ‘&’ symbol, so we need to cater for all of that. We also add appropriate headers for the request if they are not set.

This sample of code is something that we should consider testing with Unit Tests. It’s crucial that the URL is built correctly as we could get many unnecessary errors. If you are using an open API you would not want your request quota to be used up by a number of failing test. If you would like to learn more about Unit Testing you can get started by reading [this post](https://medium.com/flawless-app-stories/the-complete-guide-to-network-unit-testing-in-swift-db8b3ee2c327) by [S.T.Huang](https://medium.com/@koromikoneo).

### JSONParameterEncoder

Create a file named **_JSONParameterEncoder_** and place it inside the **_Encoding_** group too.

![](https://cdn-images-1.medium.com/max/800/0*KNCxD7C71WmPBLTC.)

JSONParameterEncoder code.

Similar to the **_URLParameter_** encoder but here we encode the parameters to JSON and add appropriate headers once again.

### NetworkRouter

Create a file named **_NetworkRouter_ **and place it inside the **_Service_** group. We start by defining a completion typealias.

```
public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()
```

Next we define a protocol **_NetworkRouter_**.

![](https://cdn-images-1.medium.com/max/800/0*aNdQ3nHwAXcv0wKD.)

NetworkRouter code.

A **_NetworkRouter_** has an **_EndPoint_** which it uses to make requests and once the request is made it passes the response to the completion. I have added the cancel function as an extra nice to have but don’t go into its use. This function can be called at any time in the life cycle of a request and cancel it. This could prove to be very valuable if your application has an uploading or downloading task. We make use of an **_associatedtype_** here as we want our **_Router_** to be able to handle any **_EndPointType_**. Without the use of **_associatedtype_** the router would have to have a concrete **_EndPointType_**. For more on _associatedtypes_ I suggest checking [this post by NatashaTheRobot.](https://www.natashatherobot.com/swift-what-are-protocols-with-associated-types/)

### Router

Create a file named **_Router_** and place it inside the **_Service_** group. We declare a private variable task of type **_URLSessionTask_**. This task is essentially what will do all the work. We keep the variable private as we do not want anyone outside this class modifying our task.

![](https://cdn-images-1.medium.com/max/800/0*HE_JNaCCPFjhyPqu.)

Router method stubs.

#### Request

Here we create a URLSession using the shared session. This is the simplest way of creating a URLSession. But please bear in mind that it is not the only way. More complex configurations of a URLSession can be implemented using configurations that can change the behavior of the session. For more on this I would suggest taking some time to read [this post](https://www.raywenderlich.com/158106/urlsession-tutorial-getting-started).

Here we create our request by calling _buildRequest_ and giving it a _route_ which is an **_EndPoint_**. This call is wrapped in a do-try-catch block as _buildRequest_ because an error could be thrown by our encoders. We simply pass all response, data, and error to the completion.

![](https://cdn-images-1.medium.com/max/800/0*qUwPqibb5mhGO2sI.)

Request method code.

#### Build Request

Create a private function inside **_Router_ **named _buildRequest_**_._ **This function is responsible for all the vital work in our network layer. Essentially converting **_EndPointType_** to **_URLRequest._** Once our **_EndPoint_** becomes a request we can pass it to the session. A lot is being done here so we will look at each method separately. Let’s break down the _buildRequest_ method:

1.  We instantiate a variable request of type **_URLRequest_**. Give it our base URL and append the specific path we are going to use.
2.  We set the _httpMethod_ of the request equal to that of our **_EndPoint_**.
3.  We create a do-try-catch block since our encoders throws an error. By creating one big do-try-catch block we don’t have to create a separate block for each try.
4.  Switch on **_route.task_**
5.  Depending on the task, call the appropriate encoder.

![](https://cdn-images-1.medium.com/max/800/0*4TPvOc1LjttZDmxF.)

buildRequest method code.

#### Configure Parameters

Create a function named _configureParameters_ inside the **_Router_**.

![](https://cdn-images-1.medium.com/max/800/0*49iY9tUA5EsHN76i.)

configureParameters method implementation.

This function is responsible for encoding our parameters. Since our API expects all **_bodyParameters_** as JSON and **_URLParameters_** to be URL encoded we just pass the appropriate parameters to its designated encoder. If you are dealing with an API that has varied encoding styles I would suggest amending the **_HTTPTask_** to take a encoder Enum. This enum should have all the different styles of encoders you need. Then inside configureParameters add an additional argument of your encoder Enum. Switch on the enum and encode parameters appropriately.

#### Add Additional Headers

Create a function named _addAdditionalHeaders_ inside the **_Router_**.

![](https://cdn-images-1.medium.com/max/800/0*mnyRBFq6ECW1YGqH.)

addAdditionalHeaders method implementation.

#### Simply add all the additional headers to be part of the request headers.

#### Cancel

Cancel function implementation will be like this:

![](https://cdn-images-1.medium.com/max/800/0*2Wglip7ThvVgBkki.)

cancel method implementation.

### In Practice

Let’s now use our built network layer on a practical example. We will make use of [TheMovieDB🍿](https://developers.themoviedb.org/3) to get some movie data into our application.

### MovieEndPoint

The **_MovieEndPoint_** is very similar to the Target Type we had in [Getting Started with Moya](https://medium.com/flawless-app-stories/getting-started-with-moya-f559c406e990) (check it out if you haven’t read it yet). Instead of implementing **_Moya’s_** TargetType we now just implement our own **_EndPointType_**. Place this file inside the **_EndPoint_** Group.

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

Our **_MovieModel_** also does not change as the response for TheMovieDB is still the same JSON. We make use of Decodable protocol to convert our JSON to our model. Place this file inside the **_Model_** group.

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

Create a file named **_NetworkManager_** and place it inside the **_Manager_ **group. For now our NetworkManager will just have two static properties: your API key and the network environment (Reference _MovieEndPoint_). **_NetworkManager_** also has a **_Router_** which is of type **_MovieApi_**.

![](https://cdn-images-1.medium.com/max/800/1*2Tks6DbNHw2XKl2i-0yH_Q.png)

Network Manager code.

#### Network Response

Create an Enum named **_NetworkResponse_** inside the **_NetworkManager_**.

![](https://cdn-images-1.medium.com/max/800/0*D60Pp9d8uEruYN_X.)

Network Response enum.

We will utilise this enum to handle responses from the API and display a suitable message.

#### Result

Create an Enum **_Result_** inside the **_NetworkManager_**.

![](https://cdn-images-1.medium.com/max/800/0*g_HgQtY9Cn66fuSU.)

Result enum.

A result Enum is very powerful and can be used for many different things. We will use Result to determine whether our call to the API was a success or failure. If it failed we would return an error message with the reason. For more on Result Oriented programming you can [watch or read this talk](https://academy.realm.io/posts/tryswift-saul-mora-result-oriented-development/).

#### Handle Network Responses

Create a function named **_handleNetworkResponse_**.This function takes one argument which is a **_HTTPResponse_** and returns a **_Result<String>._**

![](https://cdn-images-1.medium.com/max/800/0*3Lex0gRiQOJeCu8s.)

Here we switch on the HTTPResponse’s statusCode. The statusCode is a HTTP protocol that tells us the status of the response. Generally anything between 200 and 299 is a success. For more on statusCodes read [this](http://www.restapitutorial.com/httpstatuscodes.html).

### Making The Call

So now we have laid down a solid foundation for our networking layer. It is time to make the call!

We will be fetching a list of new movies from the API. Create a function named **_getNewMovies_**.

![](https://cdn-images-1.medium.com/max/800/0*9WYyT_jhq098o2Ac.)

getNewMovies method implementation.

Let’s break down each step of this method:

1.  We define the method **_getNewMovies_** with two arguments: a page number and a completion which returns optional Movie array or optional error message.
2.  We call our Router. Pass in the page number and handle the completion inside a closure.
3.  A **_URLSession_** returns an error if there is no network or the call to the API could not be made for some reason. Please note that this is not an API failure. Such failures are client side and will probably be due to a poor internet connection.
4.  We need to cast our **_response_** to a **_HTTPURLResponse_** because we need access to the statusCode property.
5.  We declare a **_result_** which we get from our **_handleNetworkResponse_** method. We then examine the result in switch-case block.
6.  **_Success_** means we were able to communicate with the API successfully and got an appropriate response back. We then check if the response came back with data. And if there is no date we simply exit the method with return statement.
7.  If the response comes back with data, we need to decode the data to our model. Then we pass the decoded movies to the completion.
8.  In the case of **_failure_** we simply pass the error to the completion.

And done! That is our Network Layer in pure Swift no Cocoapods or third-party libraries. To make a test api request to get movies create a viewController with a Network Manager then call getNewMovies on the manager.

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

Example of MainViewControoler.

### DETOUR- NETWORK LOGGER

One of my favorite features of Moya is the network logger. It makes it so much easier to debug and see what is going on with requests and response by logging all network traffic. This was definitely a feature I wanted when I decided to implement this network layer. Create a file named **_NetworkLogger_** and place it inside the **_Service_** group. I have implemented the code to log the request to the console. I won’t show where we should place this code in our networking layer. As a challenge to you go ahead and create a function that will log the response to the console and also find an appropriate place in our architecture to place these function calls. [Place Gist file]

**_HINT_**_: static func log(response: URLResponse) {}_

### Bonus

Ever find yourself inside Xcode with a placeholder that you do not really understand? For example let’s look at the code we just implemented for our **_Router_**.

![](https://cdn-images-1.medium.com/max/800/0*scwoD53jgJcYyqkA.)

**_NetworkRouterCompletion_** is something we implemented. Even though we implemented it, it’s sometimes hard to remember exactly what that type is and how we should use it. Our beloved Xcode to the rescue! Just double click on the placeholder and Xcode will do the rest.

![](https://cdn-images-1.medium.com/max/800/0*MueEsqJYDaK8kVB6.)

### Conclusion

Now we have an easy to use protocol oriented networking layer that we can customise. We have complete control over its functionality and complete understanding of its mechanics. By embarking on this exercise I can truly say that I myself have learned a few new things. So I’m more proud of this piece of work than a piece of work that just requires installing a library. Hope, this post proves that it is really not that hard to create your own networking layer in Swift. 😜 Just don’t do this:

You can find the Source code on [my GitHub](https://github.com/Mackis/NetworkLayer). Thanks for reading!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
