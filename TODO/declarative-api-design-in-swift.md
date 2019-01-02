> * 原文地址：[Declarative API Design in Swift](http://blog.benjamin-encz.de/post/declarative-api-design-in-swift/)
* 原文作者：[Benjamin Encz](http://blog.benjamin-encz.de/about)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Zheaoli](https://github.com/Zheaoli)
* 校对者：[luoyaqifei](https://github.com/luoyaqifei), [Edison-Hsu](https://github.com/Edison-Hsu)

# Swift 声明式程序设计

在我第一份 iOS 开发工程师的工作中，我编写了一个 XML 解析器和一个简单的布局工具，两个东西都是基于声明式接口。XML 解析器是基于 `.plist` 文件来实现 Objective-C 类关系映射。而布局工具则允许你利用类似 HTML 一样标签化的语法来实现界面布局（不过这个工具使用的前提是已经正确使用 `AutoLayout` & `CollectionViews`）。

尽管这两个库都不完美，它们还是展现了声明式代码的四大优点：

*   **关注点分离**: 我们在使用声明式风格编写的代码时声明了意图，从而无需关注具体的底层实现，可以说这样的分离是自然发生的。
*   **减少重复的代码**: 所有声明式代码都共用一套样式实现，这里面很多属于配置文件，这样可以减少重复代码所带来的风险。
*   **优秀的 API 设计**: 声明式 API 可以让用户自行定制已有实现，而不是将已有实现做一种固定的存在看待。这样可以保证修改程度降至最小。
*   **良好的可读性**: 讲真，按照声明式 API 所写出来的代码简直优美无比。

这些天我写的大多数 Swift 代码非常适用于声明式编程风格。

不管是对于某一种数据结构的描述，或者是对某个功能的实现，在编写过程中，我最常使用的类型还是一些简单的结构体。声明不同的类型，主要是基于泛型类，然后这些东西负责实现具体的功能或者完成必要的工作。我们在 PlanGrid 开发过程中采用这种方法来编写我们得 Swift 代码。这种开发方式已经对对代码可读性的提升还有开发人员的效率提升上产生了巨大的影响。

本文我想讨论的是 PlanGrid 应用中所使用的 API 设计，它原本使用 NSOperationQueue 实现，现在使用了一种更接近声明式的方法－讨论这个 API 应该可以展示声明式编程风格在各方面的好处。

## 在 Swift 中构建一个声明式请求序列

我们重新设计的 API 用来将本地变化（也可能是离线发生的）与 API 服务器进行同步。我不会讨论这种变化追踪方法的细节，而是将精力放在网络请求的生成和执行上。

在这篇文章里，我想专注于一个特定的请求类型上：上传本地生成的图片。出于多种因素的考虑（超出本文讨论范围），上传图片的操作包括三次请求：

1.  向 API 服务器发起请求，API 服务器将会响应，响应内容为向 AWS 服务器上传图片所需信息。
2.  上传图片至 AWS （使用上次请求得到的信息）。
3.  向 API 服务器发起请求以确认图片上传成功。

既然我们有包括这些请求序列的上传任务，我们决定将其抽象成一个特殊的类型，并让我们的上传架构支持它。

### 定义请求序列协议

我们决定引入一个单独的类型来对网络请求序列进行描述。这个类型将被我们的上传者类使用，上传者类的作用是将描述转化为实在的网络请求(要提醒你们的是我们不会在本篇文章中讨论上传者类的实现）。

接下来这个类型是我们控制流的精髓：我们有一个请求序列，序列中的每个请求都可能依赖于前一个请求的结果。

小贴士: 接下来的代码里的一些类型的命名方式看起来有点奇怪，但是它们中大多数是根据应用专属术语集来命名的（如： Operation ）。

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

通过调用 `nextRequest:` 方法来让请求序列生成一个请求时，我们提供了一个对前一个请求的引用，包括 `NSURLResponse` 和 JSON 响应体（如果存在的话）。每一个请求的结果都可能在下一次请求时产生（（将会返回一个 `PushRequest` 对象），除了没有下一次请求（返回 `nil` ）或者在请求过程中发生了一些以外的情况导致没有返回必要的响应以外（请求序列在该情况下 `throws` ）。

值得注意的是， PushRequest 并不是这个返回值类型的理想名。这个类型只是描述一个请求的详情（结束符，HTTP 方法等等），其并不参与任何实质性的工作。这是声明式设计中很重要的一个方面。

你可能已经注意到了这个协议依赖于一个特定 `class` ，我们这样做是因为我们意识到 `OperationRequestSequence` 其是一个状态描述类型。它需要能够捕获并使用前面的请求所产生的结果（比如：在第三个请求里可能需要获取第一个请求的响应结果）。这个做法参考了 `mutating` 方法的结构，不得不说这样的行为貌似让这部分有关上传操作的代码变得更为复杂了（所以说重新赋值变化结构体并不是一件那么简单的事儿）

在基于 `OperationRequestSequence` 协议实现了我们第一个请求序列后，我们发现相比实现 `nextRequest` 方法来说，简单地提供一个数组来保存请求链更合适。于是我们便添加了 `ArrayRequestSequence` 协议来提供了一个请求数组的实现：

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
        }
    }
~~~

这个时候，我们定义了一个新的上传序列，这只是很微小的一点工作。

### 实现请求序列协议

作为一个小例子，让我们看看用来上传快照的上传序列吧（在 PlanGrid 中，快照指的是在图片中绘制的可导出的蓝图或者注释）：

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


在实现的过程中你应该注意这样几件事情：

*   这里面几乎没有命令式代码。大多数的代码都通过实例变量和前次请求的结果来描述网络请求。
*   代码并不调用网络层，也没有任何上传操作的类型信息。它们只是对每个请求的详情进行了描述。事实上，这段代码没有能被观测到的副作用，它只更改了内部状态。
*   这段代码里可以说没有任何的错误处理代码。这个类型只负责处理该请求序列中发生的特定错误（比如前次请求并未返回任何结果等）。而其余的错误通常都在网络层予以处理了。
*   我们使用 `PushInMemoryRequestDescription`/`AWSMultipartRequestDescription` 来对我们对自己的 API 服务器或者是对 AWS 服务器发起请求的行为进行抽象。我们的上传代码将会根据情况在两者之前进行切换，对两者使用不同的 URL 会话配置，以免将我们自有 API 服务器的认证信息发送至 AWS 。

我不会详细讨论整个代码，但是我希望这个例子能充分展现我之前提到过的声明式设计方法的一系列优点：

*   **关注点分离**: 上面编写的类型只有描述一系列请求这一单一功能。
*   **减少重复的代码**: 上面编写的类型里面只包含对请求进行描述的代码，并不包含网络请求及错误处理的代码。
*   **优秀的 API 设计**: 这样的 API 设计能有效的减轻开发者的负担，他们只需要实现一个简单的协议以确保后续产生的请求是基于前一个请求结果的即可。
*   **良好的可读性**: 再次声明，以上代码非常集中；我们不需要在样板代码的海洋里游泳，就可以找到代码的意图。那也说明，为了更快地理解这段代码，你需要对我们的抽象方式有一定的了解。

现在可以想想如果利用 `NSOperationQueue` 来替代我们的方案会怎么样？

### 什么是 `NSOperationQueue` ？

采用 `NSOperationQueue` 的方案复杂了很多，所以在这篇文章里给出相对应的代码并不是一个很好的选择。不过我们还是可以讨论下这种方案。

**关注点分离**在这种方案中难以实现。和对请求序列进行简单抽象不同的是，`NSOperationQueue` 中的 `NSOperations` 对象将负责网络请求的开关操作。这里面包含请求取消和错误处理等特性。在不同的位置都有相似的上传代码，同时这些代码很难进行复用。在大多数上传请求被抽象成一个` NSOperation` 的情况下，使用子类并不是一个好选择，虽然说我们得上传请求队列被抽象成为一个被 `NSOperationQueue` 所装饰的 `NSOperation` 。

`NSOperationQueue` 中的无关信息相当多。。代码中随处可见对网络层的操作和调用 `NSOperation` 中的特定方法，比如 `main` 和 `finish` 方法。在没有深入了解具体的 API 调用规则前，很难知道具体操作是用来做什么的

**这种 API 所采用的处理方式，某种意义上让开发者的开发体验变得更差了**。和简单的实现相对应的协议不同的是，在 Swift 中如果采用上述的开发方式，人们需要去了解一些约定俗成的规定，尽管这些规定可能并不强制要求你遵守。

**这种处理方式将会显著增加开发者的负担。**与实现一个简单协议不同的是，在新版本的 Swift 中实现这样的代码的话，我们需要去理解一些特有的约定。尽管很多被记载下来的约定并不是与编程相关的。

由于一些其他原因，该 API 可能会导致一些与网络请求的错误报告相关的 bug 。为了避免每个请求操作都执行自己的错误报告代码，我们将其集中在一个地方进行处理。错误处理代码将会在请求结束之后开始执行。然后代码将会检查请求类型中的 error 属性的值是否存在。为了及时地反馈错误信息，开发者需要及时在操作完成之前设置 `NSOperation` 中的 `error` 属性的值。由于这是一个非强制性约定导致一堆新代码忘记设置其属性的值，可能会导致诸多错误信息的遗失。

所以啊，我们很期待我们介绍的这样一种新的方式能帮助开发者们在未来编写上传及其余功能的代码。

## 总结

声明式的编程方法已经对我们的编程技能和开发效率产生了巨大的影响。我们提供了一种受限的 API ，这种 API 用途单一且不会留下一堆迷之 Bug 。我们可以避免使用子类及多态等一系列手段，转而使用基于泛型类型的声明式风格代码来替代它。我们可以写出优美的代码。我们所编写的代码都是能很方便的进行测试的(关于这点，编程爱好者们可能觉得在声明式风格代码中测试可能不是必要的。）所以你可能想问：“别告诉我这是一种完美无瑕的编程方式？”

首先，在具体的抽象过程中，我们可能会花费一些时间与精力。不过，这种花费可以通过仔细设计 API ，并并通过提供一些测试，代替用例实现功能，为使用者提供参考。

其次，请注意，声明式编程并不是适用于任何时间任何业务的。要想适用声明式编程，你的代码库里至少要有一个用相似方法解决了多次的问题。如果你尝试在一个需要高度可定制化的应用里使用声明式编程， 然后你又对整个代码进行了错误的抽象，那么最后你会得到如同乱麻一般的**半**声明式代码。对于任何的抽象过程而言，过早地进行抽象都会造成一大堆令人费解的问题。

**声明式 API 有效地将 API 使用者身上的压力转移至 API 开发者身上，对于命令式 API 则不需要这样**。为了提供一组优秀的声明式 API ，API 的开发者必须确保接口的使用与接口的实现细节进行严格的隔离。不过严格遵循这样要求的 API 是很少的。React 和 GraphQL 证明了声明式 API 能有效提升团队编码的体验。

其实我觉得，这只是一个开端，我们会慢慢发现在复杂的库中所隐藏复杂的细节和对外提供的简单易用的接口。期待有一天，我们能利用一个基于声明式编程的 UI 库来构建我们的 iOS 程序。
