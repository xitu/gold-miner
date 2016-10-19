> * 原文地址：[Declarative API Design in Swift](http://blog.benjamin-encz.de/post/declarative-api-design-in-swift/)
* 原文作者：[Benjamin Encz](http://blog.benjamin-encz.de/about)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Zheaoli](https://github.com/Zheaoli)
* 校对者：

在我第一份 iOS 开发工程师的工作中，我编写了一个 XML 解析器和一个简单的布局工具，两个东西都是基于声明式接口。XML 解析器是基于 `.plist` 文件来实现 Objective-C 类关系映射。而布局工具则允许你利用类似 HTML 一样标签化的语法来实现界面布局（不过这个工具使用的前提是已经正确使用 `AutoLayout` & `CollectionViews`）。

虽然这两个库都不能算作是一个非常优秀的库，但是在编写过程中，我有了这样几点收获：

*   **焦点分离**: 我们在编写具体的样式代码时，无需关注具体的底层实现，可以说这样的分离是自然发生的。
*   **减少重复的代码**: 所有声明式代码都共用一套样式实现，这里面很多属于配置文件，这样可以减少重复代码所带来的风险。
*   **优秀的 API 设计**: 声明式 API 可以让用户自行定制已有实现，而不是将已有实现做一种固定的存在看待。这样可以保证修改程度降至最小。
*   **可读性**: 讲真，按照声明式 API 所写出来的代码简直优美无比。

这段时间我所编写的 Swift 代码，都是按照声明式 API 编程规范来实现的。

不管是对于某一种数据结构的描述，或者是对某个功能的实现，在编写过程中，我最常使用的类型还是一些简单的结构体。声明不同的类型，主要是基于泛型类，然后这些东西负责实现具体的功能或者完成必要的工作。我们在 PlanGrid 开发过程中采用这种方法来编写我们得 Swift 代码。这种开发方式已经对对代码可读性的提升还有开发人员的效率提升上产生了巨大的影响。

现在，我想讨论下 PlanGrid 中的 API 设计，that used to be implemented using `NSOperationQueue` and since has been moved to a more declarative approach - discussing this API should demonstrate the various benefits of a declarative programming style.（这段话请校者帮忙参考一二）

## 在 Swift 中构建一个声明式请求序列

我们需要设计一个 API 服务器来同步本地的更改（当然这种情况也可能是在离线的情况下产生的）。我并不会去过多的讨论这里面的细节，而是将精力放在网络请求的执行上。

在这篇文章里，我想专注于一个特定的请求类型上：上传本地生存的图片。处于多种因素的考虑，我们将上传图片的操作分为三部进行：

1.  向 API 服务器发起请求，API 服务器将会响应一个包含 AWS 服务器上传的方式的信息。
2.  上传图片至 AWS 。
3.  向 API 服务器发起请求以确认图片上传成功。

既然我们有依赖于请求序列的上传任务，我们决定将其抽象成一个特殊的类型。

### 定义请求序列协议

我们决定一个单独的类型来对网络请求序列进行描述。这个类型将由我们的上传类根据网络实际情况来进行消费。(要提醒你们的是我们不会在本篇文章中讨论上传者类的实现）。

接下来这个类型是我们控制流的精髓：我们有一个请求序列。队列中的每个请求都可能依赖于前一个请求的状态。

小贴士: 接下来的代码里的一些类型的命名方式看起来有点奇怪，但是他们大多数是根据具体的操作来命名的。因此他们都能很轻易的按照 Swift 编程风格进行重命名。

~~~Swift
    public typealias PreviousRequestTuple = (
    	request: PushRequest,
    	response: NSURLResponse,
    	responseBody: JsonValue?
    )

    /// A sequence of push requests required to sync this operation with the server.
    /// As soon as a request of this sequence completes,
    /// `PushSyncQueueManager` will poll the sequence for the next request.
    /// If `nil` is returned for the `nextRequest` then
    /// this sequence is considered complete.
    public protocol OperationRequestSequence: class {
        /// When this method returns `nil` the entire `OperationRequestSequence`
        /// is considered completed.
        func nextRequest(previousRequest: PreviousRequestTuple?) throws -> PushRequest?
    }
~~~

我们通过 `nextRequest:` 方法来让请求序列生成一个请求，每一个请求中的 `NSURLResponse` 都是前一个请求所产生的。每一个请求的结果都可能在下一次请求时产生（（将会返回一个 `PushRequest` 对象），除了没有下一次请求或者在请求过程中发生了一些以外的情况导致没有返回必要的响应以外。

`PushRequest` 并不是这个返回值类型的理想名。这个类型只是描述一个请求的详情（结束符，HTTP 方法等等），其并不参与任何实质性的工作。这是声明式设计中很重要的一个方面。

你可能已经注意到了这个协议依赖于一个特定 `class` ，我们这样做是因为我们意识到 `OperationRequestSequence` 其是一个状态描述类型。它可能需要捕获并使用前面的请求所产生的结果（比如：在第三个请求里可能需要获取第一个请求的响应结果）。这个做法参考了 `mutating` 方法的结构，不得不说这样的行为貌似让上传操作变得更为复杂了一(所以说改变代码结构并不是一件那么简单的事儿)。

在基于 `OperationRequestSequence` 协议实现了我们第一个请求序列后，我们发现相比实现 `nextRequest` 方法来说，可能提供一个数组来保存请求链更显简单。于是我们便添加了 `ArrayRequestSequence` 协议来提供了一个请求数组的实现：

~~~Swift
    public typealias RequestContinuation = (previous: PreviousRequestTuple?) throws -> PushRequest?

    public protocol ArrayRequestSequence: OperationRequestSequence {
        var currentRequestIndex: Int { get set }
        var requests: [RequestContinuation] { get }
    }

    extension ArrayRequestSequence {
        public func nextRequest(previous: PreviousRequestTuple?) throws -> PushRequest? {
            let nextRequest = try self.requests[self.currentRequestIndex](previous: previous)
            self.currentRequestIndex += 1
            return nextRequest
        }huo
    }
~~~

At this point it became almost trivial to define a new upload sequence.

### Implementing the Request Sequence Protocol

As an example, let’s take a look at the upload sequence for uploading snapshots (snapshots in PlanGrid capture a blueprint + annotations in an image that can be exported):

~~~Swift
    /// Describes a sequence of requests for uploading a snapshot.
    final class SnapshotUploadRequestSequence: ArrayRequestSequence {

        // Removed boilerplate initializer &
        // instance variable definition code...

        // This is the definition of the request sequence
        lazy var requests: [RequestContinuation] = {
            return [
                // 1\. Get AWS Upload Package from API
                self._allocationRequest,
                // 2\. Upload Snapshot to AWS
                self._awsUploadRequest,
                // 3\. Confirm Upload with API
                self._metadataRequest
            ]
        }()

        // It follows the detailed definition of the individual requests:

        func _allocationRequest(previous: PreviousRequestTuple?) throws -> PushRequest? {
        	// Generate an API request for this file upload
        	// Pass file size in JSON format in the request body
            return PushInMemoryRequestDescription(
                relativeURL: ApiEndpoints.snapshotAllocation(self.affectedModelUid.value),
                httpMethod: .POST,
                jsonBody: JsonValue(values:
                    [
                        "filesize" : self.imageUploadDescription.fullFileSize
                    ]
                ),
                operationId: self.operationId,
                affectedModelUid: self.affectedModelUid,
                requestIdentifier: SnapshotUploadRequestSequence.allocationRequest
            )
        }

        func _awsUploadRequest(previous: PreviousRequestTuple?) throws -> PushRequest? {
        	// Check for presence of AWS allocation data in response body
            guard let allocationData = previous?.responseBody else {
                throw ImageCreationOperationError.MissingAllocationData
            }

            // Attempt to parse AWS allocation data
            self.snapshotAllocationData = try AWSAllocationPackage(json: allocationData["snapshot"])

            guard let snapshotAllocationData = self.snapshotAllocationData else {
                throw ImageCreationOperationError.MissingAllocationData
            }

            // Get filesystem path for this snapshot
            let thumbImageFilePath = NSURL(fileURLWithPath:
                SnapshotModel.pathForUid(
                    self.imageUploadDescription.modelUid,
                    size: .Full
                )
            )

            // Generate a multipart/form-data request
            // that uploads the image to AWS
            return AWSMultiPartRequestDescription(
                targetURL: snapshotAllocationData.targetUrl,
                httpMethod: .POST,
                fileURL: thumbImageFilePath,
                filename: snapshotAllocationData.filename,
                operationId: self.operationId,
                affectedModelUid: self.affectedModelUid,
                requestIdentifier: SnapshotUploadRequestSequence.snapshotAWS,
                formParameters: snapshotAllocationData.fields
            )
        }

        func _metadataRequest(previous: PreviousRequestTuple?) throws -> PushRequest? {
            // Generate an API request to confirm the completed upload
            return PushInMemoryRequestDescription(
                relativeURL: ApiEndpoints.snapshotAllocation(self.affectedModelUid.value),
                httpMethod: .PUT,
                jsonBody: self.snapshotMetadata,
                operationId: self.operationId,
                affectedModelUid: self.affectedModelUid,
                requestIdentifier: SnapshotUploadRequestSequence.metadataRequest
            )
        }

    }
~~~


A few things should stand out in this implementation:

*   It has almost no imperative code. Most code describes network request based on instance variables and previous requests.
*   It doesn’t call the networking layer, nor does it have any knowledge of the type that actually performs the upload. It just describes the intent of each request. In fact, the code has no observable side effects at all, it only mutates internal state.
*   There is almost no error handling code here. The responsibility of this type is only to handle errors specific to this request sequence (e.g. missing required data from a previous request). All other errors are generically handled in the networking layer.
*   We are using separate types (`PushInMemoryRequestDescription`/`AWSMultipartRequestDescription`) to model requests to our API vs. requests to AWS. Our uploader switches over these types and uses a different URL session configuration for each. This way we don’t send our API auth token to AWS.

I won’t discuss the entire code in detail, but I hope this sample shows the various advantages of a declarative approach that I mentioned earlier:

*   **Separation of concerns**: this type has the single responsibility of describing a sequence of requests.
*   **Less repeated code**: this type only contains code for describing a request sequence; we’re not at risk of repeating any network communication / error handling code.
*   **Exceptional API design**: this API places as little burden as possible onto the developer. They only need to implement a simple protocol that produces a subsequent request description based on the result of a previous request.
*   **Readability**: once again, the code listing above is extremely focused; there’s no need to skim over boilerplate code to find the intention. That said, to understand this code quickly, some familiarity with our abstractions is required.

How does this compare to our previous solution that was using `NSOperationQueue`?

### What About NSOperationQueue?

The solution using an `NSOperationQueue` was a lot less concise, so there’s no good way to present its code in this blog post. We can still discuss the issues that the approach had on a high level.

**Separation of concerns** was a lot harder to come by. Instead of simply describing a request sequence, the NSOperations in the NSOperationQueue themselves were responsible for kicking off a network request. This promptly introduced a bunch of other responsibilities such as request cancellation and error handling. While similar code had been implemented in other places that dealt with creating upload requests there was no good way of sharing that implementation. Subclassing wasn’t an option since most upload requests were modeled as a single `NSOperation`, while this upload request sequence was modeled as an `NSOperation` that wrapped an `NSOperationQueue`.

The **signal/noise ratio** of the NSOperationQueue based solution was a lot worse. The code was littered with references to the network layer and with `NSOperation` specific code, such as the `main` and `finish` methods. Without knowing about the sequence of requests required by the API it would have been hard to understand what exactly the operation was responsible for.

The **API was a lot worse to deal with for developers**. Instead of simply implementing a protocol, as in the new Swift solution, one needed to understand a set of conventions. While most conventions were documented there was no way of enforcing them programmatically.

Among other issues, this resulted in some bugs around error reporting for network requests. In order to avoid each operation implementing its own error reporting code, it was handled in a central location. The error handling code would run whenever a operation finished. The error handling code would check for the presence of a value in the `error` property of the operation. In order to report an error a developer needed to set the `error` property on the `NSOperation` subclass before the operation completed. Since this was a non-obvious convention (that wasn’t well documented) a bunch of new code forgot to set that property. This resulted in a decent amount of unreported errors.

TL;DR: we’re glad we’re able to provide a more explicit API & easier to understand code to developers that will change the upload code in future.

## Conclusion

Using a declarative programming approach has had a huge impact on our codebase and our productivity. We can provide constrained APIs that can be only used in one way and don’t leave a lot of room for error. We can avoid subclassing as a means of polymorphism and instead implement generic types that are controlled by declarative code. We can write code with excellent signal to noise ratio. The declarative code we write is extremely easy to test (to the point where even testing enthusiasts might deem tests unnecessary). So what are the downsides, if any?

Firstly, there’s some cost associated with understanding our custom abstraction. However, the cost can be mitigated by careful API design, and by providing tests that serve as example implementations.

Secondly, and more importantly, declarative programming isn’t always applicable. You need a problem that is solved multiple times throughout your codebase in a very similar way. If you try to apply declarative programming principles to code that needs a high degree of customization, you’ve built the wrong abstraction and will end up with convoluted semi-declarative code. As with any abstraction, introducing it too early can cause a lot of harm.

**Declarative APIs place more burden onto the API developer and less onto the API consumer**. In order to provide a declarative API a developer needs to be able to isolate the interface strictly from the implementation details; this is a lot less true for imperative APIs. React and GraphQL have demonstrated that the simplicity of declarative APIs can enable a great developer experience while making it easier for development teams to write coherent code at scale.

I think this is just a first step into a future where we’ll see sophisticated libraries hide their complexity by providing simple, declarative, interfaces. And hopefully, some day, we’ll get a declarative UI library for building iOS apps.
