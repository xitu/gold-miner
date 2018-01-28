> * 原文地址：[The complete guide to Network Unit Testing in Swift](https://medium.com/flawless-app-stories/the-complete-guide-to-network-unit-testing-in-swift-db8b3ee2c327)
> * 原文作者：[S.T.Huang](https://medium.com/@koromikoneo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-complete-guide-to-network-unit-testing-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-complete-guide-to-network-unit-testing-in-swift.md)
> * 译者：
> * 校对者：

# The complete guide to Network Unit Testing in Swift

![](https://cdn-images-1.medium.com/max/2000/1*tbwvWm4U3z0au5X6gOddiQ.png)

Let’s face it, writing tests is not so popular in iOS development (at least in comparison with writing tests for backend). I used to be a solo developer and I wasn’t initially trained as a native “test-driven” developer. So I have spent a lot of time studying how to write tests, and how to write testable code. That’s why I’m writing this article. I want to share what I’ve found while doing testing in Swift. I hope, my insights will save you time beating around the bush.

In this article, we are going to talk about the beginning of the testing 101: **Dependency Injection**.

Imagine, that you are writing the test.
If your testing target (SUT, System Under Test) is somehow related to the real world, such as Networking and CoreData, it would be more complicated to write the test code. Basically, we don’t want our test code to depend on real world things. The SUT shouldn’t be dependent on other complex system so that we are able to test it faster, time invariant and environment invariant. Besides, it’s important that our test code won’t “pollute” the production environment. What does it mean “to pollute”? It means that our test code writes some test thing to the database, submits some testing data to the production server, etc. Those are why **dependency injection** exists.

Let’s start with an example.
Given a class that supposed to be executed over the internet in the production environment. The internet part is called the **dependency** of that class. As described above, the internet part of that class must be able to be substituted with a mock, or fake, environment when we are running tests. In other words, the dependency of that class has to “injectable”. Dependency injection makes our system more flexible. We can “inject” the real networking environment in our production code. And meanwhile, we can also “inject” the mock networking environment to run the test code without access to the internet.

### TL;DR

In this article, we are gonna talk about:

1. How to use **Dependency Injection** technique to design an object
2. How to use Protocol in Swift to design a mock object
3. How to test the data used by the object and how to test the behavior of the object

### Dependency Injection (DI)

Let’s start! Now we are going to implement a class named **HttpClient**. The HttpClient should meet the following requirements:

1. The HttpClient should submit the request with the same URL as the assigned one.
2. The HttpClient should submit the request.

So, this is our first implementation of HttpClient:

```
class HttpClient {
    typealias completeClosure = ( _ data: Data?, _ error: Error?)->Void
    func get( url: URL, callback: @escaping completeClosure ) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            callback(data, error)
        }
        task.resume()
    }
}
```

It seems that the HttpClient can submit a “GET” request, and pass the returned value via the closure “callback”.

```
HttpClient().get(url: url) { (success, response) in // Return data }
```

The usage of HttpClient.

Here’s the problem: how do we test it? How do we make sure the code meets the requirements listed above? Intuitively, we can execute the code, assign a URL to the HttpClient, then observe the results in the console. However, doing this means that we have to connect to the internet every time when we implement the HttpClient. It seems worse if the testing URL is on a production server: your test run does affect the performance to some extent and your test data are submitted to the real world. As we described before, we have to make the HttpClient “testable”.

Let’s take a look at the URLSession. The URLSession is a kind of ‘environment’ of the HttpClient, it’s the gateway to the internet. Remember what we said about the ‘testable’ code? We have to make the internet component replaceable. So we edit the HttpClient:

```
class HttpClient {
    typealias completeClosure = ( _ data: Data?, _ error: Error?)->Void
    private let session: URLSession
    init(session: URLSessionProtocol) {
        self.session = session
    }
    func get( url: URL, callback: @escaping completeClosure ) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            callback(data, error)
        }
        task.resume()
    }
}
```

We replace the

```
let task = URLSession.shared.dataTask()
```

with

```
let task = session.dataTask()
```

Then we add a new variable: **session**, add a corresponding **init**. From now on, when we create a HttpClient, we have to assign the **session**. That is, we have to “inject” the session to any HttpClient object we create. Now we are able to run the production code with the ‘URLSession.shared’ injected, and run the test code with a mock session injected. Bingo!

The usage of the HttpClient becomes: HttpClient(session: SomeURLSession() ).get(url: url) { (success, response) in // Return data }

It becomes quite easy to write test code to this HttpClient. So we setup our test environment:

```
class HttpClientTests: XCTestCase { 
    var httpClient: HttpClient! 
    let session = MockURLSession()
    override func setUp() {
        super.setUp()
        httpClient = HttpClient(session: session)
    }
    override func tearDown() {
        super.tearDown()
    }
}
```

This is a classic XCTestCase setup. The variable, **httpClient**, is the system under test (SUT), and the variable, **session**, is the environment that we gonna inject to httpClient. Since we run the code in the test environment, we assign a MockURLSession object to **session**. Then we inject the mock **session** to httpClient. It makes the httpClient run over MockURLSession instead of URLSession.shared.

### Test data

Now we focus on our first requirement:

1. The HttpClient should submit the request with the same URL as the assigned one.

We want to make sure the url of the request is exactly the same as we assigned to “get” method at the beginning.

Here is our draft test case:

```
func test_get_request_withURL() {
    guard let url = URL(string: "https://mockurl") else {
        fatalError("URL can't be empty")
    }
    httpClient.get(url: url) { (success, response) in
        // Return data
    }
    // Assert 
}
```
This test case could be presented as:

* **Precondition**: Given a url “https://mockurl”
* **When**: Submit a http GET request
* **Assert**: The submitted url should be equal to “https://mockurl”

We still need to write the assert part.

So how do we know the “get” method of HttpClient does submit the correct url? Let’s take a look at the dependency: URLSession. In general, the “get” method creates a request with given url, and assign the request to the URLSession to submit the request:

```
let task = session.dataTask(with: request) { (data, response, error) in
    callback(data, error)
}
task.resume()
```

Now, in the test environment, the request is assigned to the MockURLSession. So we might be able to hack into MockURLSession, which is owned by us, to check if the request is created properly.

This is a draft of MockURLSession:

```
class MockURLSession {
    private (set) var lastURL: URL?
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        lastURL = request.url
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)        
        return // dataTask, will be impletmented later
    }
}
```

The MockURLSession acts like a URLSession. Both of URLSession and MockURLSession have the same method, dataTask(), and the same callback closure type. Although the dataTask() in URLSession does more jobs than what MockURLSession does, their interfaces look similar. Due to the same interface, we are able to substitute the URLSession with MockURLSession without changing too many codes of the “get” method. Then we create a variable, **lastURL**, to track the final url we have submitted in the “get” method. To put it simply, when testing, we create a HttpClient, inject the MockURLSession into it, and then see if the urls are the same before and after.

The draft test case would be:

```
func test_get_request_withURL() {
    guard let url = URL(string: "https://mockurl") else {
        fatalError("URL can't be empty")
    }
    httpClient.get(url: url) { (success, response) in
        // Return data
    }
    XCTAssert(session.lastURL == url)
}
```

We assert the **lastURL** with **url** to see if the “get” method correctly creates the request with the correct url.

In the code above, there’s still one thing to be implemented: the `return // dataTask` . In URLSession, the return value must be a URLSessionDataTask. However, the URLSessionDataTask can’t be created programmatically, thus, this is an object that needs to be mocked:

```
class MockURLSessionDataTask {  
    func resume() { }
}
```

As URLSessionDataTask, this mock has the same method, resume(). So it might be able to treat this mock as the return value of the dataTask().

Then, if you’re writing the code with me, you will find some compile errors in your code:

```
class HttpClientTests: XCTestCase {
    var httpClient: HttpClient!
    let session = MockURLSession()
    override func setUp() {
        super.setUp()
        httpClient = HttpClient(session: session) // Doesn't compile 
    }
    override func tearDown() {
        super.tearDown()
    }
}
```

The interface of MockURLSession is different from that of URLSession. Thus, the compiler won’t recognize MockURLSession when we try to inject it. We have to make the mock object’s interface be the same as a real object. So, let’s introduce the “Protocol”!

The dependency of HttpClient is:

```
private let session: URLSession
```

We want the session to be either URLSession or MockURLSession. So we change the type from URLSession to a protocol, URLSessionProtocol:

```
private let session: URLSessionProtocol
```

Now we are able to inject either URLSession or MockURLSession or whatever object that conforms this protocol.

This is the implementation of the protocol:

```
protocol URLSessionProtocol { typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}
```

In our test code, we need only one method: `dataTask(NSURLRequest, DataTaskResult)`, so we define only one required method in the protocol. This technique is usually adapted when we want to mock the thing we don’t own.

Remember the MockURLDataTask? That is another thing that we don’t own, so yes, we are going to create another protocol.

```
protocol URLSessionDataTaskProtocol { func resume() }
```

We also have to make the real objects conform the protocols.

```
extension URLSession: URLSessionProtocol {}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}
```

The URLSessionDataTask has the exact same protocol method, resume(), so nothing happens about URLSessionDataTask.

The problem is, URLSession does not have a dataTask() returning URLSessionDataTaskProtocol. So we need to extend a method to conform the protocol.

```
extension URLSession: URLSessionProtocol {
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}
```

This is a simple method converting the return type from URLSessionDataTask to URLSessionDataTaskProtocol. It won’t change the behavior of the dataTask() at all.

Now we are able to finish the missing part in MockURLSession:

```
class MockURLSession {
    private (set) var lastURL: URL?
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        lastURL = request.url
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)        
        return // dataTask, will be impletmented later
    }
}
```

We know the // dataTask… could be a MockURLSessionDataTask:

```
class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
}
```

This is a mock which acts like URLSession in our test environment, and the url could be saved for asserting. The skyscraper has been created! All code has been compiled and the tests have been passed!

Let’s move on.

### Test Behavior

The second requirement is:

`The HttpClient should submit the request`

We want to make sure the “get” method in HttpClient does submit the request as expected.

Different from the previous test, which tests the correctness of the data, this test asserts a method is called or not. In other words, we want to know if the URLSessionDataTask.resume() is called. Let’s play the old trick:
we create a new variable, resumeWasCalled, to record if the resume is called or not.

So we simply write a test:

```
func test_get_resume_called() {
    let dataTask = MockURLSessionDataTask()
    session.nextDataTask = dataTask
    guard let url = URL(string: "https://mockurl") else {
        fatalError("URL can't be empty")
    }
    httpClient.get(url: url) { (success, response) in
        // Return data
    }
    XCTAssert(dataTask.resumeWasCalled)
}
```

The variable **dataTask** is a mock, which is owned by ourselves, so we can add a property to test the behavior of the resume():

```
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}
```

If the resume() gets called, the `resumeWasCalled` would become ‘true’! :) Easy, right?

### Recap

In this article, we have learned:

1. How to adapt DI to change production/test environment.
2. How to utilize the protocol to create mocks.
3. How to test the correctness of the passing values.
4. How to assert the behavior of a certain function.

At the beginning, you must spend a lot of time writing a simple test. And, test code is also code, so you still need to make it clear and well-structured. But the benefit of writing test is invaluable. The code can only be scaled up with proper tests, and tests help you avoiding trivial bugs. So, let’s do it!

The sample code is on [GitHub](https://github.com/koromiko/Tutorial/blob/master/NetworkingUnitTest.playground/Contents.swift). It’s a Playground, and I put an additional test there. Feel free to download/fork it and any feedback is welcome!

Thank you for reading my article 💚.

### Reference

1. [Mocking Classes You Don’t Own](http://masilotti.com/testing-nsurlsession-input/)
2. [Dependency Injection](https://www.objc.io/issues/15-testing/dependency-injection/)
3. [Test-Driven iOS Development with Swift](https://www.amazon.com/Test-Driven-Development-Swift-Dominik-Hauser/dp/178588073X)

Thanks to [Lisa Dziuba](https://medium.com/@lisadziuba?source=post_page) and [Ahmed Sulaiman](https://medium.com/@ahmedsulaiman?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
