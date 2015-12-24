> * 原文链接: [iOS 9 Tutorial Series: Protocol-Oriented Programming with UIKit](http://www.captechconsulting.com/blogs/ios-9-tutorial-series-protocol-oriented-programming-with-uikit)
* 原文作者 : [TYLER TILLAGE](http://www.captechconsulting.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 :
* 状态 : 待定

After the thought-provoking [Protocol-Oriented Programming in Swift](https://developer.apple.com/videos/wwdc/2015/?id=408) talk at WWDC 2015 (yeah, the "Crusty" one) it seems like everyone has been talking about **protocol extensions**, that exciting new language feature that makes everyone confused at least once.

I've read countless articles about Swift protocols and the ins/outs of protocol extensions, and it's clear that protocol extensions will be another strong ingredient in the Swift recipe. Apple even recommends defaulting to a protocol instead of a class whenever possible -- this approach is the crux of **protocol-oriented programming**.

But while the articles I've read have been clear on what protocol extensions _are_, they don't reveal what protocol-oriented programming truly _means_ for UI development in particular. Most of the sample code currently available is built from contrived scenarios that don't utilize any frameworks.

I wanna know how protocol extensions affect the apps I've already built, how I can leverage them to work more powerfully within the single most important iOS framework, UIKit.

Now that we have protocol extensions, are protocol-based approaches more valuable in the class-heavy land of UIKit? This article is my attempt to rationalize Swift protocol extensions with real-world UI scenarios, and a chronicle of my discovery that protocol extensions aren't quite what I expected them to be.

### The Benefit of Protocols

Protocols are nothing new, but the idea that we can _extend_ them with built-in functionality, shared logic, magical power...well that's a fascinating thought. More protocols == more flexibility. A protocol extension is a small chunk of modular functionality that can be adopted, overriden (or not) and can interact with type-specific code through the `where` clause.

> _Protocols_ really only exist to keep the compiler happy, but protocol  
> _extensions_ are tangible pieces of logic shared across the entire codebase.

While it's only possible to inherit from one superclass, we can adopt as many extended protocols as desired. Adopting a protocol that's extended is kind of like adding a directive to an element in Angular.js -- we're injecting logic that alters the way our object behaves. Protocols are no longer just a contract, with extensions they can be an adoption of functionality.

## How to Use Protocol Extensions

The usage of protocol extensions is very simple. This article is not a how-to, but instead a discussion about the applicability of protocol extensions to UIKit development. If you need to get up-to-speed on how they work, check out the [Official Swift Documentation on Procotol Extensions](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID521).

### Protocol Extension Limitations

Before we get started, let's clear the air about what protocol extensions _aren't_. There's a lot we can't do with protocol extensions, many of them by design. However I would love to see Apple address some of these limitations in future versions of Swift.

*   Cannot call protocol extension members from Objective-C.
*   Cannot use the `where` clause with a `struct` type.
*   Cannot define multiple comma-separated `where` clauses, similar to an `if let` statement.
*   Cannot store dynamic variables inside a protocol extension.
    *   This is also true for non-generic extensions.
    *   Static variables are supposed to be allowed, but as of Xcode 7.0 they print the error "static stored properties not yet supported in generic types."
*   Cannot call `super` to invoke a protocol extension, unlike a non-generic extension.
    *   For this reason there's no real concept of protocol extension inheritance.
*   Cannot adopt multiple protocol extensions with duplicate members.
    *   The Swift runtime chooses the last protocol adopted and ignores the others.
    *   For example, if we have 2 protocol extensions which implement the same methods, only the last one we've adopted will be used when the method is invoked. There's no way to invoke the methods from the other extensions.
*   Cannot extend optional protocol methods.
    *   Optional protocol methods require the `@objc` tag, which cannot be used together with a protocol extension.
*   Cannot declare a protocol & its extension at the same time.
    *   It would be nice to be able to declare `extension protocol SomeProtocol {}` to simultaneously declare the protocol and implement the extension, since protocols don't always have any members when the extension contains all of the important logic.

## Part 1: Extending Existing UIKit Protocols

When I first learned about protocol extensions, the protocol that popped into my head was `UITableViewDataSource`, arguably the most widely implemented protocol on the iOS platform. Wouldn't it be interesting, I pondered, if I could provide a _default implementation_ for all of the `UITableViewDataSource` adopters in my app?

If every `UITableView` has a set # of sections, why not extend `UITableViewDataSource` and implement `numberOfSectionsInTableView:` in one place? If I implement the same swipe to delete functionality in all of my tables, why not implement `UITableViewDelegate` inside a protocol extension?

For now, that's not possible.

**What we CAN'T do:**  
_Provide default implementations for Objective-C protocols._

UIKit is still compiled from Objective-C, and Objective-C has no concept of protocol extendability. What this means in practice is that despite our ability to declare extensions on UIKit protocols, UIKit objects can't see the methods inside our extensions.

For example: if we extend `UICollectionViewDelegate` to implement `collectionView:didSelectItemAtIndexPath:`, it won't be invoked when tapping the cell because `UICollectionView` itself can't see the method from the Objective-C context. If we put a non-optional method in the protocol extension like `collectionView:cellForItemAtIndexPath:`, the compiler will complain that our adopter doesn't conform to `UICollectionViewDelegate`.

Xcode vainly attempts to fix this problem by prepending `@objc` to our protocol extension methods, which reveals a new error "Method in protocol extension cannot be represented in Objective-C." This is the underlying issue -- protocol extensions are only available in Swift 2+ code.

**What we CAN do:**  
_Add new methods to existing Objective-C protocols._

We _can_ invoke UIKit protocol extension methods directly from Swift even if UIKit can't see them. This means that although we can't _override_ existing UIKit protocol methods, we can _add_ new convenience methods for when we're working with that protocol.

Not as exciting, I admit. And any legacy Objective-C code still can't invoke these methods. But there remain some opportunities here. Below are some simple examples of what's now possible when combining protocol extensions & existing UIKit protocols.

### UIKit Protocol Extension Examples

#### Extending `UICoordinateSpace`

Ever have to convert between the Core Graphics and UIKit coordinate space? We can add helper methods to `UICoordinateSpace`, a protocol adopted by `UIView`.



```swift
extension UICoordinateSpace {
    func invertedRect(rect: CGRect) -> CGRect {
        var transform = CGAffineTransformMakeScale(1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -self.bounds.size.height)
        return CGRectApplyAffineTransform(rect, transform)
    }
}
```swift



Now our `invertedRect` method is available within any `UICoordinateSpace` adopter. We can use it in our drawing code:



```swift
class DrawingView : UIView {
    // Example -- Referencing custom UICoordinateSpace method inside UIView drawRect.
    override func drawRect(rect: CGRect) {
        let invertedRect = self.invertedRect(CGRectMake(50.0, 50.0, 200.0, 100.0))
        print(NSStringFromCGRect(invertedRect)) // 50.0, -150.0, 200.0, 100.0
    }
}
```swift



#### Extending `UITableViewDataSource`

Although we can't provide default implementations of `UITableViewDataSource` methods, we can still put global logic into the protocol to be used by any `UITableViewDataSource` in our app.



```swift
extension UITableViewDataSource {
    // Returns the total # of rows in a table view.
    func totalRows(tableView: UITableView) -> Int {
        let totalSections = self.numberOfSectionsInTableView?(tableView) ?? 1
        var s = 0, t = 0
        while s < totalsections="" {="" t="" +="self.tableView(tableView," numberofrowsinsection:="" s)="" s++="" }="" return="" t="" }="">
```swift



The `totalRows:` method above is a quick way to tally up how many items we have in our table view, useful if we want to display a total label but have our content separated into sections. A good place to use this is `tableView:titleForFooterInSection:`.



```swift
class ItemsController: UITableViewController {
    // Example -- displaying total # of items as a footer label.
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == self.numberOfSectionsInTableView(tableView)-1 {
            return String("Viewing %f Items", self.totalRows(tableView))
        }
        return ""
    }
}
```swift



#### Extending `UIViewControllerContextTransitioning`

Maybe you're working on a custom navigation transition after reading my iOS 7 article on [Custom Navigation Transitions & More](https://www.captechconsulting.com/blogs/ios-7-tutorial-series-custom-navigation-transitions--more) (shameless plug). Here are a couple methods that I could have used in that tutorial, made available through the `UIViewControllerContextTransitioning` protocol.



```swift
extension UIViewControllerContextTransitioning {
    // Mock the indicated view by replacing it with its own snapshot. Useful when we don't want to render a view's subviews during animation, such as when applying transforms.
    func mockViewWithKey(key: String) -> UIView? {
        if let view = self.viewForKey(key), container = self.containerView() {
            let snapshot = view.snapshotViewAfterScreenUpdates(false)
            snapshot.frame = view.frame

            container.insertSubview(snapshot, aboveSubview: view)
            view.removeFromSuperview()
            return snapshot
        }

        return nil
    }

    // Add a background to the container view. Useful for modal presentations, such as showing a partially translucent background behind our modal content.
    func addBackgroundView(color: UIColor) -> UIView? {
        if let container = self.containerView() {
            let bg = UIView(frame: container.bounds)
            bg.backgroundColor = color

            container.addSubview(bg)
            container.sendSubviewToBack(bg)
            return bg
        }
        return nil
    }
}
```swift



We can call these methods on the `transitionContext` object passed into our animation coordinator:



```swift
class AnimationCoordinator : NSObject, UIViewControllerAnimatedTransitioning {
    // Example -- using helper methods during a view controller transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Add a background
        transitionContext.addBackgroundView(UIColor(white: 0.0, alpha: 0.5))

        // Swap out the "from" view
        transitionContext.mockViewWithKey(UITransitionContextFromViewKey)

        // Animate using awesome 3D animation...
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 5.0
    }
}
```swift



Let's say we have multiple `UIPageControl` instances throughout our app and we copied and pasted some code between our `UIScrollViewDelegate` implementations to make them work. With protocol extensions we can make this logic global, all while still calling it using `self`.



```swift
extension UIScrollViewDelegate {
    // Convenience method to update a UIPageControl with the correct page.
    func updatePageControl(pageControl: UIPageControl, scrollView: UIScrollView) {
        pageControl.currentPage = lroundf(Float(scrollView.contentOffset.x / (scrollView.contentSize.width / CGFloat(pageControl.numberOfPages))));
    }
}
```swift



Additionally, if we know `Self` is a `UICollectionViewController` we can eliminate the method's `scrollView` parameter.



```swift
extension UIScrollViewDelegate where Self: UICollectionViewController {
    func updatePageControl(pageControl: UIPageControl) {
        pageControl.currentPage = lroundf(Float(self.collectionView!.contentOffset.x / (self.collectionView!.contentSize.width / CGFloat(pageControl.numberOfPages))));
    }
}

// Example -- Page control updates from a UICollectionViewController using a protocol extension.
class PagedCollectionView : UICollectionViewController {
    let pageControl = UIPageControl()

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updatePageControl(self.pageControl)
    }
}
```swift



Admittedly, these examples are pretty contrived. It turns out that there just aren't a huge number of options when it comes to extending existing UIKit protocols, and any added value is only subtle. However, there's still the question of how we can employ **custom** protocol extensions within existing UIKit design patterns.

## Part 2: Extending Custom Protocols

### Protocol-Oriented Programming with MVC

At its core, an iOS application performs 3 essential functions. This is commonly described as the MVC (Model-View-Controller) design pattern. All an app really does is manipulate some kind of data to be represented visually.

![](http://www.captechconsulting.com/blogs/library/A9AAC94D44AB4D64B4F2634F2E4AF6B8.ashx?h=480&w=1200)

In the next 3 examples I'll demonstrate some protocol-oriented design patterns that feature protocol extensions, working through each of the 3 components of the MVC pattern in the order Model -> Controller -> View.

### Protocols for Model Management (M)

Say we're making a music app, call it Pear Music. Say we have model objects for Artists, Albums, Songs and Playlists. We need to structure some code to load these models from the network based on an identifier that we've already loaded.

When working with protocols it's best to start at the highest level of abstraction. The fundamental idea here is a resource which has a remote representation that we need to populate using an API. Let's make a protocol for that:



```swift
// Any entity which represents data which can be loaded from a remote source.
protocol RemoteResource {}
```swift



But wait, that's just an empty protocol! `RemoteResource` is not intended to be adopted directly. It's not a contract, but a collection of functionality that involves making network requests. Therefore the real value of `RemoteResource` lies in its protocol extension:



```swift
extension RemoteResource {
    func load(url: String, completion: ((success: Bool)->())?) {
        print("Performing request: ", url)

        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse where error == nil && data != nil {
                print("Response Code: %d", httpResponse.statusCode)

                dataCache[url] = data
                if let c = completion {
                    c(success: true)
                }
            } else {
                print("Request Error")
                if let c = completion {
                    c(success: false)
                }
            }
        }
        task.resume()
    }

    func dataForURL(url: String) -> NSData? {
        // A real app would require a more robust caching solution.
        return dataCache[url]
    }
}

public var dataCache: [String : NSData] = [:]
```swift



Now we have a protocol with built-in functionality to load remote data and retrieve it. Any adopter of this protocol will automatically have access to these methods.

We've been given 2 APIs to interface with, one for JSON data (api.pearmusic.com) and one for media (media.pearmusic.com). To handle this, we'll make sub-protocols of `RemoteResource` for each type of data.



```swift
protocol JSONResource : RemoteResource {
    var jsonHost: String { get }
    var jsonPath: String { get }
    func processJSON(success: Bool)
}

protocol MediaResource : RemoteResource {
    var mediaHost: String { get }
    var mediaPath: String { get }
}
```swift



Let's build the implementations of these protocols.



```swift
extension JSONResource {
    // Default host value for REST resources
    var jsonHost: String { return "api.pearmusic.com" }

    // Generate the fully qualified URL
    var jsonURL: String { return String(format: "http://%@%@", self.jsonHost, self.jsonPath) }

    // Main loading method.
    func loadJSON(completion: (()->())?) {
        self.load(self.jsonURL) { (success) -> () in
            // Call adopter to process the result
            self.processJSON(success)

            // Execute completion block on the main queue
            if let c = completion {
                dispatch_async(dispatch_get_main_queue(), c)
            }
        }
    }
}
```swift



We provided a default host, a way to generate the full request URL, and a way to load the resource itself using the `load:` method from `RemoteResource`. We'll then rely on our adopters to provide the correct `jsonPath`.

`MediaResource` follows a similar pattern:



```swift
extension MediaResource {
    // Default host value for media resources
    var mediaHost: String { return "media.pearmusic.com" }

    // Generate the fully qualified URL
    var mediaURL: String { return String(format: "http://%@%@", self.mediaHost, self.mediaPath) }

    // Main loading method
    func loadMedia(completion: (()->())?) {
        self.load(self.mediaURL) { (success) -> () in
            // Execute completion block on the main queue
            if let c = completion {
                dispatch_async(dispatch_get_main_queue(), c)
            }
        }
    }
}
```swift



You may notice that these implementations are very much alike. In fact, it would make a lot of sense to elevate these methods to `RemoteResource` itself, only using our sub-protocols to return the proper host.

The catch is that our protocols are not mutually exclusive -- we want to be able to have an object which is both a `JSONResource` and a `MediaResource`. Remember that protocol extensions override eachother. Unless we explicitly separate these properties & methods, only those within the _last protocol adopted_ will be called.

Let's specialize even more by giving ourselves some data accessors.



```swift
extension JSONResource {
    var jsonValue: [String : AnyObject]? {
        do {
            if let d = self.dataForURL(self.jsonURL), result = try NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                return result
            }
        } catch {}
        return nil
    }
}

extension MediaResource {
    var imageValue: UIImage? {
        if let d = self.dataForURL(self.mediaURL) {
            return UIImage(data: d)
        }
        return nil
    }
}
```swift



This is a classic example of the value of protocol extensions. While a traditional protocol is saying "I promise I am _this_ type of thing, with _these_ features," a protocol extension is saying "_because_ I have these features I can _do_ these unique things" Since `MediaResource` has access to image data, it can easily provide an `imageValue` regardless of specific types or contexts.

I mentioned we'll be loading our models based on known identifiers, so let's make a protocol for any entity which has a unique identifier.



```swift
protocol Unique {
    var id: String! { get set }
}

extension Unique where Self: NSObject {
    // Built-in init method from a protocol!
    init(id: String?) {
        self.init()
        if let identifier = id {
            self.id = identifier
        } else {
            self.id = NSUUID().UUIDString
        }
    }
}

// Bonus: Make sure Unique adopters are comparable.
func ==(lhs: Unique, rhs: Unique) -> Bool {
    return lhs.id == rhs.id
}
extension NSObjectProtocol where Self: Unique {
    func isEqual(object: AnyObject?) -> Bool {
        if let o = object as? Unique {
            return o.id == self.id
        }
        return false
    }
}
```swift



We'll still have to rely on our `Unique` adopters to declare the `id` property since we can't store properties inside extensions. Additionally, you probably noticed that I only extended `Unique` when `Self: NSObject`. Otherwise we couldn't call `self.init()` as it wouldn't be declared. A workaround for this is to declare the `init()` method as part of the protocol, but that would require the adopters to implement it. Since all of our models are `NSObject`-based, this condition is not a problem.

Ok, we've got a basic strategy for loading resources from the network. Let's start conforming our models to these protocols. Here's what our `Song` model would look like:



```swift
class Song : NSObject, JSONResource, Unique {
    // MARK: - Metadata
    var title: String?
    var artist: String?
    var streamURL: String?
    var duration: NSNumber?
    var imageURL: String?

    // MARK: - Unique
    var id: String!
}
```swift



But wait, where's the `JSONResource` implementation?

Instead of implementing `JSONResource` directly within our class, we can use a conditional protocol extension. This gives us the ability to organize all of our `RemoteResource`-based formatting logic in one place for easy adjustment, and keeps our model implementation clean. Therefore we'd put the following into our `RemoteResource.swift` file, in addition to all of the previous `RemoteResource`-based logic.



```swift
extension JSONResource where Self: Song {
    var jsonPath: String { return String(format: "/songs/%@", self.id) }

    func processJSON(success: Bool) {
        if let json = self.jsonValue where success {
            self.title = json["title"] as? String ?? ""
            self.artist = json["artist"] as? String ?? ""
            self.streamURL = json["url"] as? String ?? ""
            self.duration = json["duration"] as? NSNumber ?? 0
        }
    }
}
```swift



Keeping everything related to `RemoteResource` in a single place has organizational advantages. The protocol implementation is in one place, and the scope of the extension is clear. When declaring a protocol which is to be extended, I suggest keeping the extensions within the same file.

Here's what it looks like to load a `Song` thanks to the `JSONResource` and `Unique` protocol extensions:



```swift
let s = Song(id: "abcd12345")
let artistLabel = UILabel()

s.loadJSON { (success) -> () in
    artistLabel.text = s.artist
}
```swift



Suddenly our `Song` object is simply a wrapper around some metadata, which is all it really should be. Our protocol extensions are doing all of the hard work!

Here's an example of a `Playlist` object which conforms to both `JSONResource` and `MediaResource`:



```swift
class Playlist: NSObject, JSONResource, MediaResource, Unique {
    // MARK: - Metadata
    var title: String?
    var createdBy: String?
    var songs: [Song]?

    // MARK: - Unique
    var id: String!
}

extension JSONResource where Self: Playlist {
    var jsonPath: String { return String(format: "/playlists/%@", self.id) }

    func processJSON(success: Bool) {
        if let json = self.jsonValue where success {
            self.title = json["title"] as? String ?? ""
            self.createdBy = json["createdBy"] as? String ?? ""
            // etc...
        }
    }
}
```swift



Before we blindly implement `MediaResource` for `Playlist`, we should step back a bit. We notice our media API only requires the identifier in the endpoint, with nothing type-specific. That means as long as we know the identifier we can build the `mediaPath`. Let's use a `where` clause to make `MediaResource` work intelligently with `Unique`.



```swift
extension MediaResource where Self: Unique {
    var mediaPath: String { return String(format: "/images/%@", self.id) }
}
```swift



Since our `Playlist` already conforms to `Unique` there's literally nothing we have to implement to make it work with `MediaResource`! The same logic applies to any `MediaResource` which is also `Unique` -- as long as the object's identifier corresponds to an image inside our media API, it'll just work.

Here's how it looks to load our `Playlist` image:



```swift
let p = Playlist(id: "abcd12345")
let playlistImageView = UIImageView(frame: CGRectMake(0.0, 0.0, 200.0, 200.0))

p.loadMedia { () -> () in
    playlistImageView.image = p.imageValue
}
```swift



We now have a generic way of defining remote resources that can be used with _any other entity in our app_, not just these model objects. We could easily extend `RemoteResource` to handle different types of REST operations, and build more sub-protocols for additional types of data.

### Protocols for Data Formatting (C)

Now that we've constructed a way to load our model objects, let's move on to the next step. We need to format the metadata from our objects for display in a consistent manner.

Pear Music is a big app, and we have lots of different types of models. Each model can be displayed in a variety of places. For example, if we have an `Artist` as the title of a view controller, we want it to display simply as "{name}". However if we have some extra space, say in a `UITableViewCell`, we'd like to use "{name} ({instrument})" instead. And if we have even more space in a larger `UILabel`, we'd like to use "{name} ({instrument}) {bio}".

We _could_ put all of this formatting code within our view controllers, cells and labels. It would work fine, but we'd be spreading out the logic across our app and reducing maintainability.

We _could_ put the string formatting in our model object itself, but we'd have to make type assumptions when we're actually trying to display the strings.

We _could_ throw some convenience methods in a base class and have each model subclass to provide their own formatting, but with protocol-oriented programming we should be thinking more generically.

Let's abstract this idea into another protocol, which designates any entity which can be represented as a string. We'll provide various lengths of strings to be used in different UI scenarios.



```swift
// Any entity which can be represented as a string of varying lengths.
protocol StringRepresentable {
    var shortString: String { get }
    var mediumString: String { get }
    var longString: String { get }
}

// Bonus: Make sure StringRepresentable adopters are printed descriptively to the console.
extension NSObjectProtocol where Self: StringRepresentable {
    var description: String { return self.longString }
}
```swift



Easy enough. Here are a few more model objects that we're going to make `StringRepresentable`:



```swift
class Artist : NSObject, StringRepresentable {
    var name: String!
    var instrument: String!
    var bio: String!
}

class Album : NSObject, StringRepresentable {
    var title: String!
    var artist: Artist!
    var tracks: Int!
}
```swift



Similar to how we organized our `RemoteResource` implementations, we'll put all of our formatting logic into a single `StringRepresentable.swift` file:



```swift
extension StringRepresentable where Self: Artist {
    var shortString: String { return self.name }
    var mediumString: String { return String(format: "%@ (%@)", self.name, self.instrument) }
    var longString: String { return String(format: "%@ (%@), %@", self.name, self.instrument, self.bio) }
}

extension StringRepresentable where Self: Album {
    var shortString: String { return self.title }
    var mediumString: String { return String(format: "%@ (%d Tracks)", self.title, self.tracks) }
    var longString: String { return String(format: "%@, an Album by %@ (%d Tracks)", self.title, self.artist.name, self.tracks) }
}
```swift



Now that we've handled our formatting we need a way to choose which string to use based on a given UI scenario. Sticking with our generic approach, let's define behavior for displaying any `StringRepresentable` onscreen, given a `containerSize` and `containerFont` for calculation.



```swift
protocol StringDisplay {
    var containerSize: CGSize { get }
    var containerFont: UIFont { get }
    func assignString(str: String)
}
```swift



I recommend only declaring methods inside the protocol which are meant to be implemented by adopters. In the protocol extension, we'll put the methods which contain the actual functionality of the protocol. The `displayStringValue:` determines which string to use, and passes it on to the type-specific `assignString:` method.



```swift
extension StringDisplay {
    func displayStringValue(obj: StringRepresentable) {
        // Determine the longest string which can fit within the containerSize, then assign it.
        if self.stringWithin(obj.longString) {
            self.assignString(obj.longString)
        } else if self.stringWithin(obj.mediumString) {
            self.assignString(obj.mediumString)
        } else {
            self.assignString(obj.shortString)
        }
    }

#pragma mark - Helper Methods

    func sizeWithString(str: String) -> CGSize {
        return (str as NSString).boundingRectWithSize(CGSizeMake(self.containerSize.width, .max),
            options: .UsesLineFragmentOrigin,
            attributes:  [NSFontAttributeName: self.containerFont],
            context: nil).size
    }

    private func stringWithin(str: String) -> Bool {
        return self.sizeWithString(str).height <= self.containersize.height="" }="">
```swift



Now we have model objects which are `StringRepresentable`, and a protocol which, when adopted, will help us automatically choose the right string to use. So how do we plug this into UIKit?

Let's start with `UILabel`, the simplest example. The traditional choice would be to subclass `UILabel` and adopt the protocol, then use the custom `UILabel` whenever we want to make use of a `StringRepresentable`. However a better choice (assuming we don't need the subclass) is to use a non-generic extension to have all `UILabel` instances adopt `StringDisplay` automatically:



```swift
extension UILabel : StringDisplay {
    var containerSize: CGSize { return self.frame.size }
    var containerFont: UIFont { return self.font }
    func assignString(str: String) {
        self.text = str
    }
}
```swift



That's really all there is to it. We can do the same with other UIKit classes, simply returning the data that `StringDisplay` requires to work its magic.



```swift
extension UITableViewCell : StringDisplay {
    var containerSize: CGSize { return self.textLabel!.frame.size }
    var containerFont: UIFont { return self.textLabel!.font }
    func assignString(str: String) {
        self.textLabel!.text = str
    }
}

extension UIButton : StringDisplay {
    var containerSize: CGSize { return self.frame.size}
    var containerFont: UIFont { return self.titleLabel!.font }
    func assignString(str: String) {
        self.setTitle(str, forState: .Normal)
    }
}

extension UIViewController : StringDisplay {
    var containerSize: CGSize { return self.navigationController!.navigationBar.frame.size }
    var containerFont: UIFont { return UIFont(name: "HelveticaNeue-Medium", size: 34.0)! } // default UINavigationBar title font
    func assignString(str: String) {
        self.title = str
    }
}
```swift



So what does this look like in practice? Let's declare an `Artist` object, which already adopts `StringRepresentable`.



```swift
let a = Artist()
a.name = "Bob Marley"
a.instrument = "Guitar / Vocals"
a.bio = "Every little thing's gonna be alright."
```swift



Since all `UIButton` instances have been extended to adopt `StringDisplay`, we can call the `displayStringValue:` method on them.



```swift
let smallButton = UIButton(frame: CGRectMake(0.0, 0.0, 120.0, 40.0))
smallButton.displayStringValue(a)

print(smallButton.titleLabel!.text) // 'Bob Marley'

let mediumButton = UIButton(frame: CGRectMake(0.0, 0.0, 300.0, 40.0))
mediumButton.displayStringValue(a)

print(mediumButton.titleLabel!.text) // 'Bob Marley (Guitar / Vocals)'
```swift



The button's title now reflects the appropriate string based on its frame.

Say our user taps an `Album` and we push an `AlbumDetailsViewController`. Our protocols can negotiate the formatting of the navigation title. Because of our `StringDisplay` protocol extension, the `UINavigationBar` will display a longer string on iPads and a shorter one on iPhones.



```swift
class AlbumDetailsViewController : UIViewController {
    var album: Album!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Display the right string based on the nav bar width.
        self.displayStringValue(self.album)
    }
}
```swift



We've made sure that the string formatting of our models is done in a single place, and the display of them is flexible based on the UI element being used. This pattern can be repeated for future models & a variety of UI elements. Because of the flexibility we've built into our protocols, we could even use this approach for non-UI situations.

### Protocols for Styling (V)

We've covered the use of protocol extensions for our model & our string formatting, now let's look at a purely front-end example of how protocol extensions can empower our UI development.

We can treat protocols like CSS classes, and use them to define styling for our UIKit objects. Then, by adopting a styling protocol the visual appearance of our object changes automatically.

First we'll define a base protocol that represents an entity which is styled, declaring a method that will eventually be used to apply the styles.



```swift
// Any entity which supports protocol-based styling.
protocol Styled {
    func updateStyles()
}
```swift



Then we'll make some sub-protocols which define different types of styles we'd like to use.



```swift
protocol BackgroundColor : Styled {
    var color: UIColor { get }
}

protocol FontWeight : Styled {
    var size: CGFloat { get }
    var bold: Bool { get }
}
```swift



We make these inherit `Styled` so our adopters don't have to explicitly do so.

Now we can branch off into specific styles, and use protocol extensions to actually return the values required.



```swift
protocol BackgroundColor_Purple : BackgroundColor {}
extension BackgroundColor_Purple {
    var color: UIColor { return UIColor.purpleColor() }
}

protocol FontWeight_H1 : FontWeight {}
extension FontWeight_H1 {
    var size: CGFloat { return 24.0 }
    var bold: Bool { return true }
}
```swift



All that's left is implementing the `updateStyles` method based on the type of UIKit element. We'll use a non-generic extension to have all `UITableViewCell` instances conform to the `Styled` protocol.



```swift
extension UITableViewCell : Styled {
    func updateStyles() {
        if let s = self as? BackgroundColor {
            self.backgroundColor = s.color
            self.textLabel?.textColor = .whiteColor()
        }

        if let s = self as? FontWeight {
            self.textLabel?.font = (s.bold) ? UIFont.boldSystemFontOfSize(s.size) : UIFont.systemFontOfSize(s.size)
        }
    }
}
```swift



To make sure that `updateStyles` is called automatically, we'll override `awakeFromNib` in our extension. For those who are curious -- this override is essentially inserted into the inheritance chain, as if the extension was the immediate subclass of `UITableViewCell` itself. Calling `super` from a `UITableViewCell` subclass now calls this method directly.



```swift
public override func awakeFromNib() {
        super.awakeFromNib()
        self.updateStyles()
    }
}
```swift



Now when we create our cell we can just adopt the styles we want!



```swift
class PurpleHeaderCell : UITableViewCell, BackgroundColor_Purple, FontWeight_H1 {}
```swift



We've created CSS-like style declarations on our UIKit elements. We could even write something akin to a Bootstrap clone for UIKit. This approach could be enhanced in numerous directions, and would be valuable in applications where styling is highly dynamic and the number of visual elements is large.

Imagine an app that has 20+ different view controllers, each conforming to 2-3 common visual styles. Instead of forcing ourselves into sharing a base class or having some growing list of global methods to configure our styling, we can just adopt the style protocol that's needed and proceed with the more important implementation details.

## What Have We Gained?

We've done a lot so far, and it's very interesting, but what have we gained by using protocols & protocol extensions? One could argue that the protocols we've created aren't really necessary.

> Protocol-oriented programming isn't a perfect fit for every UI-based scenario.

Protocols & protocol extensions typically only become valuable when we add shared, generic functionality to our application. Additionally, the value added tends to be more organizational than functional.

The more data types there are, the more protocols may become useful. Whenever there's UI which displays multiple formats of information, protocols might offer great improvements. But that doesn't mean we need 6 protocols and a bunch of extensions just to make a purple cell which displays an artist's name.

Let's augment the Pear Music scenario to see if our protocol-oriented approach becomes more worthwhile.

## Adding Complexity

Say we've worked on Pear Music for a while, and we have great UI for listing albums, artists, songs and playlists. We're still using our fancy protocols & extensions to facilitate all aspects of our MVC process. Now the Pear CEO has asked us to build version 2.0 of Pear Music...we need to compete with a strange new competitor called Apple Music.

We need a cool new feature to define ourselves, and after extensive research we've decided that feature is **long-press to preview**. It's bold, it's innovative, our Jony Ive look-alike is already on camera talking about it. Let's build it using protocol-oriented programming with UIKit.

### Building the Modal Page

Here's how it will work -- our users long-press an artist, album, song or playlist and a modal view animates onscreen, loads the item's image from the network, and displays a description of the item as well as a Facebook share button.

Let's build the `UIViewController` which we'll present modally when the user long-presses something. From the getgo we can be generic with our initializer, only requiring _something_ which conforms to `StringRepresentable` and `MediaResource`.



```swift
class PreviewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    // The main model object which we're displaying
    var modelObject: protocol<stringrepresentable>!

    init(previewObject: protocol<stringrepresentable>) {
        self.modelObject = previewObject

        super.init(nibName: "PreviewController", bundle: NSBundle.mainBundle())
    }
}</stringrepresentable></stringrepresentable>
```swift



Next we can used the built-in protocol extension methods to assign data to our `descriptionLabel` and `imageView`.



```swift
override func viewDidLoad() {
        super.viewDidLoad()

        // Apply string representations to our label. Will use the string which fits into our descLabel.
        self.descriptionLabel.displayStringValue(self.modelObject)

        // Load MediaResource image from the network if needed
        if self.modelObject.imageValue == nil {
            self.modelObject.loadMedia { () -> () in
                self.imageView.image = self.modelObject.imageValue
            }
        } else {
            self.imageView.image = self.modelObject.imageValue
        }
    }
```swift



Finally, we can use the same methods to obtain metadata for our Facebook functionality.



```swift
// Called when tapping the Facebook share button.
    @IBAction func tapShareButton(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)

            // Use StringRepresentable.shortString in the title
            let post = String(format: "Check out %@ on Pear Music 2.0!", self.modelObject.shortString)
            vc.setInitialText(post)

            // Use the MediaResource url to link to
            let url = String(self.modelObject.mediaURL)
            vc.addURL(NSURL(string: url))

            // Add the entity's image
            vc.addImage(self.modelObject.imageValue!);

            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
}
```swift



We've gained a lot with protocols -- without them we may have defined intializers in `PreviewController` for each type of object we accept. Using the protocol-based approach lets us keep our view controller super clean, and opens our implementation to future flexibility.

We're left with a lightweight, concise `PreviewController` that can be passed an `Artist`, `Album`, `Song`, `Playlist` or **any** other model we build into our protocol pattern. `PreviewController` doesn't have a single line of model-specific code!

### Integrating 3rd Party Code

Here's one last awesome scenario that we enabled by using protocols & protocol extensions when building `PreviewController`. Say we're integrating with a new framework which loads Twitter information for the musicians in our app. We want to display the list of tweets on our main page, and we're given a model object for a tweet:



```swift
class TweetObject {
    var favorite_count: Int!
    var retweet_count: Int!
    var text: String!
    var user_name: String!
    var profile_image_id: String!
}
```swift



We don't own this code, and we can't modify `TweetObject`, but we still want our users to be able to long-press to preview the tweets using the same `PreviewController` UI. All we need to do is extend it to adopt our existing protocols!



```swift
extension TweetObject : StringRepresentable, MediaResource {
    // MARK: - MediaResource
    var mediaHost: String { return "api.twitter.com" }
    var mediaPath: String { return String(format: "/images/%@", self.profile_image_id) }

    // MARK: - StringRepresentable
    var shortString: String { return self.user_name }
    var mediumString: String { return String(format: "%@ (%d Retweets)", self.user_name, self.retweet_count) }
    var longString: String { return String(format: "%@ Wrote: %@", self.user_name, self.text) }
}
```swift



Now we can now pass a `TweetObject` to our `PreviewController` and it doesn't even know we're working with an external framework!



```swift
let tweet = TweetObject()
let vc = PreviewController(previewObject: tweet)
```swift



## Lessons Learned

At WWDC 2015 Apple recommended creating protocols when we would normally create classes, but I argue that this rule ignores the subtle limitations of protocol extensions when working with a class-heavy framework like UIKit. Protocol extensions only add real value when they are widely applicable and don't need to support legacy code. Although some of the examples I mentioned sound trivial at first, this kind of versatile design becomes extremely effective as your application grows in size and complexity.

It's a cost-benefit question of code interpretability. Protocols & extensions don't always have a place in a largely UI-based application. If you have a single view which displays a single type of information that will never change, don't overthink it with protocols. But if your app drifts between different visual states, styles & representations of the same core information, using protocols & protocol extensions as a bridge between your data and its visual representation is a thoughtful approach that will reap future rewards.

In the end I wouldn't call protocol extensions a universal game-changing feature, but rather a constructive tool in highly precise development scenarios. Still, I think it's worth it for any developer to try protocol-oriented techniques -- you'll never fully know the benefits until you start to refocus your existing code in the context of protocols. Use them wisely.

For any questions, or if you want to chat in more detail, shoot me an [email](mailto:ttillage@captechconsulting.com) or find me on [Twitter](https://twitter.com/ttillage)!



