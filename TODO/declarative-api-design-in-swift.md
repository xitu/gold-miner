> * 原文地址：[Declarative API Design in Swift](http://blog.benjamin-encz.de/post/declarative-api-design-in-swift/)
* 原文作者：[Benjamin Encz](http://blog.benjamin-encz.de/about)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：





In my first real job as an iOS developer I built an XML parser and a simple layout engine - both had in common that they had a declarative interface. The parsers was driven by a `.plist` file that mapped XML elements to Objective-C classes. The layout engine allowed you to describe layouts in an HTML-like language (this was before AutoLayout & CollectionViews existed).

Though neither of these libraries were even close to perfect, they showed me four main advantages of declarative code:

*   **Separation of concerns**: The parts of the code that are written in a declarative style only declare an intent, without having any understanding of the underlying implementation. Separation of concerns happens naturally.
*   **Less repeated code**: A declarative system shares a common implementation. Most of the code is configuration. No risk of repeating implementation details.
*   **Exceptional API design**: Declarative APIs allow consumers to configure an existing implementation instead of providing their own one. The API surface can be kept minimal.
*   **Readability**: Signal to noise ratio of declarative code is great!

These days I write most of my code in Swift which lends itself well for a declarative programming style.

The majority of types I define are simple structs that either describe a piece of data or an intent. Separate types, typically generic classes, are then responsible for consuming these intents and implementing the necessary work. We also use this approach throughout all new Swift code we’re writing in the PlanGrid app. It has had a huge impact on code readability and developer efficiency.

Today I want to discuss an API from the PlanGrid app, that used to be implemented using `NSOperationQueue` and since has been moved to a more declarative approach - discussing this API should demonstrate the various benefits of a declarative programming style.

## Building a Declarative Request Sequence in Swift

The API that we’ve re-written is responsible for syncing local changes (that might have occurred offline) with our API server. I won’t go into details of the change tracking approach, but will instead only discuss the generation & execution of network requests.

For this post I want to focus on one particular request type: uploading locally generated images. Due to various reasons (outside of the scope of this blog post) three separate requests are involved in uploading an image:

1.  Request to API Server. API Server responds with information for an image upload to AWS.
2.  Image Upload to AWS (using information from previous request).
3.  Request to API Server to confirm completed upload.

Since we have a few upload tasks that involve such request sequences, we decided to model this as a type and support in our upload infrastructure.

### Defining the Request Sequence Protocol

We decided to introduce a separate type that is only responsible for describing a sequence of network requests. That type is consumed by our uploader class which turns the descriptions into actual network requests (the uploader itself won’t be discussed as part of this post).

The following type captures the essence of our control flow: we have a sequences of requests. Each request might depend on the result of the previous request.

_Note: Some types names might seem a little odd, but they mostly follow an app-specific ontology (e.g. Operation). Others should simply be renamed; still waiting for that refactor capabilities for Swift code…_



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



When asking the request sequence to generate a request, by calling the `nextRequest:` method, we provide a reference to previous request, a `NSURLResponse` and if available the JSON response body. Each request might result in a subsequent request (returns a new `PushRequest`), no subsequent request (returns `nil`) or an in an error in case the previous request didn’t provide the response that is necessary to continue (in which case the request sequence `throws`).

It’s worth noting that `PushRequest` isn’t an ideal name for the return type of this method. The type is only a description of a request (endpoint, HTTP method, etc.), it doesn’t perform any work on its own. That’s an important aspect of this declarative design.

You might also have noticed that the protocol comes with a `class` requirement. We made this decision after realizing that the `OperationRequestSequence` is a stateful type. It needs to be able to capture and use results from previous requests (the third request might need to access the response from the first request). While this could have been modeled with a struct with `mutating` methods, that approach made the code in the uploader a fair bit more complex (correctly re-assigning mutated struct values isn’t always trivial).

After implementing the first request sequence based on the `OperationRequestSequence` protocol, we noticed that it often would be more convenient to simply provide an array of chained requests instead of implementing the `nextRequest` method. We added an `ArrayRequestSequence` protocol that provides a default implementation based on an array of requests:



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



At this point it became almost trivial to define a new upload sequence.

### Implementing the Request Sequence Protocol

As an example, let’s take a look at the upload sequence for uploading snapshots (snapshots in PlanGrid capture a blueprint + annotations in an image that can be exported):



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



