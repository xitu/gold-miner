> * 原文地址：[Backend API Documentation in Swift](https://medium.com/ios-os-x-development/backend-api-documentation-in-swift-92b4874e4f78#.g2ofuey9d)
* 原文作者：[Christopher Truman](https://medium.com/@iamchristruman?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者： 

I have recently started development on a completely new project and am trying to establish some new design patterns as I jump into Swift 3\. One pattern that I am starting to use is Request & Response Models. That is the fancy name I came up with for Structs that document the backend API. Lets look at an example:

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

We have a protocol Request that specifies basically everything you want to know about making a request to an API.

*   The path to append to the base URL (“auth” in this case)
*   The HTTP Method (GET, POST, PUT, DELETE, etc.)
*   The parameters the endpoint expects

You could extend this Protocol to require information like a specific ContentType or other HTTP Header. You could imagine adding validation rules, completion handlers, or anything else associated with a network request to this protocol.

Each of these Structs should now look like a succinct API documentation and provide some structure and type safety to your networking. You can pass these Request structs to your network client of choice. My example uses [Alamofire](https://github.com/Alamofire/Alamofire/tree/swift3):

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

We pass the AuthRequest object to Alamofire which expects a generic object that confirms to the Request protocol. It uses the properties/functions from the protocol to construct and execute a network call.

Now we have defined the structure of the request and used it to simply hit the server. We now need to handle the response. Our AuthRequest returns a small User JSON object that we need to serialize into a Swift object.

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

This approach isn’t very fancy, but still documents the properties of the response object. You could create a protocol to define an initializer that expects JSON, but just using simple Structs is working for me so far.

Do you see any issues with this approach? Is there a way I can use Protocols/Extensions to structure my networking code in a more effective way? Let me know! [@iAmChrisTruman](https://twitter.com/iAmChrisTruman)
