> * 原文地址：[What's new in iOS 11 for developers](https://www.hackingwithswift.com/whats-new-in-ios-11)
> * 原文作者：[Paul Hudson](https://twitter.com/twostraws)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# What's new in iOS 11 for developers

iOS 11 was announced at WWDC 2017, and introduces a massive collection of powerful features such as Core ML, ARKit, Vision, PDFKit, MusicKit, drag and drop, and more. I've tried to summarize the key changes below so you can get started with them straight away, providing code where feasible.

**Warning:** Some of these features are not for the faint hearted. I've provided as much code as I can to help give you a head start with working apps, but ultimately a great deal of iOS 11 involves complex functionality that you simply can't avoid.

Before you continue, you might find these articles useful pre-reading:

- [What's new in Swift 4?](/swift4)
- [What's new in Swift 3.1?](/swift3-1)
- [What's new in iOS 10?](/ios10)
- [What's new in iOS 9?](/ios9)

**You might want to buy my new book: Practical iOS 11.** You get seven complete coding projects in tutorial form plus more technique projects that deep-dive specific new technologies – it's the fastest way to get up to speed with iOS 11!

[Buy Practical iOS 11 for $30](https://www.hackingwithswift.com/store/practical-ios11)

## Drag and drop

Drag and drop is something we've always taken for granted on desktop operating systems, but its absence on iOS really held back multitasking – until iOS 11, that is. In iOS 11, and particularly on iPad, multitasking has gone into overdrive, with drag and drop being a huge part of that: you can move content inside apps or between apps, you can use your other hand to manipulate apps while dragging, and you can even use the new dock system to activate other apps mid-drag.

**Note: on iPhone drag and drop is limited to a single app – you can't drag content to other apps.**

Helpfully, both `UITableView` and `UICollectionView` both come with some degree of drag and drop support built in, but there's still a fair amount of code to write in order to get them working. You can also add drag and drop support to other components, and as you'll see this actually takes less work.

Let's take a look at how to implement simple drag and drop to let you copy rows between two tables. First, we need a basic app to work with, so we're going to write some code to create two table views filled with example data we can copy.

Create a new Single View App template in Xcode, then open ViewController.swift for editing.

Now we need to put two table views in there, both filled with dummy data. I'm not going to use IB here because it's clearer just to write it all in code. That being said, I'm *not* going to explain this code in detail because it's just existing iOS code and I don't want to waste your time.

This code will:

- Create two table views, and create two string array filled with "Left" and "Right".
- Configure both table views to use the view controller as their data source, give them hard-coded frames, register a re-use cell, then add them to the view.
- Implement `numberOfRowsInSection` so that each table view has the correct number of items based on its string array.
- Implement `cellForRowAt` to dequeue and cell then show the correct item from one of the two string arrays depending on which table this is.

Again, this is all code from before iOS 11, so it should be nothing new to you. Replace the content of ViewController.swift with this:

```
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var leftTableView = UITableView()
    var rightTableView = UITableView()

    var leftItems = [String](repeating: "Left", count: 20)
    var rightItems = [String](repeating: "Right", count: 20)

    override func viewDidLoad() {
        super.viewDidLoad()

        leftTableView.dataSource = self
        rightTableView.dataSource = self

        leftTableView.frame = CGRect(x: 0, y: 40, width: 150, height: 400)
        rightTableView.frame = CGRect(x: 150, y: 40, width: 150, height: 400)

        leftTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        rightTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        view.addSubview(leftTableView)
        view.addSubview(rightTableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return leftItems.count
        } else {
            return rightItems.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if tableView == leftTableView {
            cell.textLabel?.text = leftItems[indexPath.row]
        } else {
            cell.textLabel?.text = rightItems[indexPath.row]
        }

        return cell
    }
}
```

OK: now for the *new* stuff. If you run the app you'll see it gives us two side-by-side table views filled with items. What we want to do is let the user grab an item from one table and copy it into the other, in either direction.

The first step is to tell both table views to use the current view controller as their drag and drop delegate, then enable drag interaction on both of them. Add this code to `viewDidLoad()`:

```
leftTableView.dragDelegate = self
leftTableView.dropDelegate = self
rightTableView.dragDelegate = self
rightTableView.dropDelegate = self

leftTableView.dragInteractionEnabled = true
rightTableView.dragInteractionEnabled = true
```

As soon as you do that, Xcode will throw up several warnings because our current view controller class doesn't conform to the `UITableViewDragDelegate` or `UITableViewDropDelegate` protocols. This is easily fixed by adding those two protocols to our class – scroll up to the top and change the class definition to this:

```
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate {

```

This in turn creates another problem: we're saying we conform to those two new protocols, but we aren't implementing their required methods. This used to be a real drag (sorry not sorry) to fix, but Xcode 9 can automatically complete required methods for protocols – click the number "2" on the red highlighted line of code, and you should see a more detailed explanation appear. Click "Fix" to have Xcode insert the two missing methods for us – you should see this appear in your class:

```
func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    code
}

func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    code
}
```

At least in this initial beta, Xcode always inserts new method stubs at the top of your class, and if you're like me that will make your eye twitch – feel free to move them somewhere more sensible before continuing!

The `itemsForBeginning` method is easiest, so let's start there. It gets called when the user has initiated a drag operation on a table view cell by holding down their finger, and needs to return an array of drag items. If you return an *empty* array, you're effectively declining drag and drop.

We're going to give this method four lines of code:

1. Figure out which string is being copied. We can do that with a simple ternary: if the table view in question is the left table view then read from `leftItems`, otherwise read from `rightItems`.
2. Attempt to convert the string to a `Data` object so it can be passed around using drag and drop.
3. Place that data inside an `NSItemProvider`, marking it as containing a plain text string so other apps know what to do with it.
4. Finally, place that item provider inside a `UIDragItem` so that it can be used for drag and drop by UIKit.

To mark the item data as being plain text we need to import the MobileCoreServices framework, so please add this line of code near the top of ViewController.swift:

```
import MobileCoreServices
```

Now replace your `itemsForBeginning` method stub with this:

```
func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let string = tableView == leftTableView ? leftItems[indexPath.row] : rightItems[indexPath.row]
    guard let data = string.data(using: .utf8) else { return [] }
    let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)

    return [UIDragItem(itemProvider: itemProvider)]
}
```

Now we just need to fill in the `performDropWith` method. Well, I say "just", but this is actually quite tricky because there are two potential complexities. First, we might be getting several strings at the same time if someone is dragging in lots of things, so we need to insert them all sensibly. Second, we might be told where the user wants to insert the rows, but we might not – they might just drag the strings onto some whitespace in the table, so we need to decide what that means for us.

To solve those two problems means writing more code than you may have expected, but I'll try to walk you through it step by step to make it a bit easier.

First, the easier part: figuring out where to drop rows. The `performDropWith` method passes us an object of the class `UITableViewDropCoordinator`, which has a `destinationIndexPath` property telling us where the user wants to drop the data. However, it's *optional*: it will be nil if they dragged their data over some empty cells in our table view, and if that happens we're going to assume they wanted to drop the data at the end of the table.

So, start by adding this code to the `performDropWith` method:

```
let destinationIndexPath: IndexPath

if let indexPath = coordinator.destinationIndexPath {
    destinationIndexPath = indexPath
} else {
    let section = tableView.numberOfSections - 1
    let row = tableView.numberOfRows(inSection: section)
    destinationIndexPath = IndexPath(row: row, section: section)
}
```

As you can see, that either uses the coordinator's `destinationIndexPath` if it exists, or creates one by looking at the last row of the last section.

The next step is to ask the drop coordinator to load all the objects it has for a specific class, which in our case will be `NSString`. (No, regular `String` doesn't work.) We need to send this a closure of code to run when the items are ready, which is where the complexity starts: we need to insert them all one by one below the destination index path, modifying either the `leftItems` or `rightItems` arrays, before finally calling `insertRows()` on our table view to make them appear.

So, again: we've just written code to figure out the destination index path for a drop operation. But if we get *multiple* items then all we have is the `initial` destination index path – the path for the first item. The *second* item should be one row lower, the third item should be two rows lower, and so on. As we move down each item to copy, we're going to create a new index path and stash it away in an `indexPaths` array so we can call `insertRows()` on our table view all at once.

Add this code to your `performDropWith` method, below the previous code we just wrote:

```
// attempt to load strings from the drop coordinator
coordinator.session.loadObjects(ofClass: NSString.self) { items in
    // convert the item provider array to a string array or bail out
    guard let strings = items as? [String] else { return }

    // create an empty array to track rows we've copied
    var indexPaths = [IndexPath]()

    // loop over all the strings we received
    for (index, string) in strings.enumerated() {
        // create an index path for this new row, moving it down depending on how many we've already inserted
        let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)

        // insert the copy into the correct array
        if tableView == self.leftTableView {
            self.leftItems.insert(string, at: indexPath.row)
        } else {
            self.rightItems.insert(string, at: indexPath.row)
        }

        // keep track of this new row
        indexPaths.append(indexPath)
    }

    // insert them all into the table view at once
    tableView.insertRows(at: indexPaths, with: .automatic)
}
```

That's all the code complete – you should be able to run the app now and drag rows between the two table views to copy them. It took quite a bit of work, yes, but I have a pleasant surprise for you: the work you've done has enabled drag and drop across the entire system: if you try using the iPad simulator you'll find you can drag text from Apple News into either table view, or drag text from your table view into the URL bar in Safari, for example. Nice!

Before we're done with drag and drop, I want to demonstrate one more thing: how to add drag and drop support for other views. This is actually easier than using a table view, so let's whizz through it quickly.

As before, we need a simple harness so we have something we can add drag and drop to. This time we're going to create a `UIImageView` and render a simple red circle for its image. You can keep your existing Single View App template and just replace ViewController.swift with this new code:

```
import UIKit

class ViewController: UIViewController {
    // create a property for our image view and define its size
    var imageView: UIImageView!
    let size = 512

    override func viewDidLoad() {
        super.viewDidLoad()

        // create and add the image view
        imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: size, height: size))
        view.addSubview(imageView)

        // render a red circle at the same size, and use it in the image view
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        imageView.image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: size, height: size)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.fillEllipse(in: rectangle)
        }
    }
}
```

As before, that is all old iOS code so I'm not going to go into detail on it. If you try running that in the iPad simulator you should see a large red circle in your view controller – that's more than enough for us to test with.

Dragging for custom views is done using a new class called `UIDragInteraction`. You tell it where to send messages (in our case, we'll use the current view controller), then attach it to whatever view should be interactive.

**Important:** don't forget to enable user interaction on the view in question, otherwise you'll be scratching your head when things don't work.

First, add these three lines of code to the end of `viewDidLoad()`, just after the previous code. You'll see Xcode complaining that our view controller doesn't conform to the `UIDragInteractionDelegate` protocol, so please modify the class definition to this:

```
class ViewController: UIViewController, UIDragInteractionDelegate {
```

Xcode will complain because we don't actually implement the one required method of the `UIDragInteractionDelegate` protocol, so repeat what you did earlier – click the error marker on the bad line, then select "Fix" to insert this method stub:

```
func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
    code
}
```

This is just like the `itemsForBeginning` method we implemented for our table views earlier: we need to return whatever image we want to share when the user starts dragging on our image view.

The code for this is nice and simple: we'll pull out the image from the image view using `guard` to avoid problems, then wrap that first in a `NSItemProvider` then in a `UIDragItem` before sending it back.

Replace your `itemsForBeginning` stub with this:

```
func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
    guard let image = imageView.image else { return [] }
    let provider = NSItemProvider(object: image)
    let item = UIDragItem(itemProvider: provider)
    return [item]
}
```

And that's it! Try using iPad multitasking to put the Photos app on the right of the screen – you should be able to drag the image from your app into Photos to have it copied across.

## Augmented Reality

Augmented reality (AR) has been around for a while, but with iOS 11 Apple has done something quite remarkable: they've created an advanced implementation that integrates seamlessly with its existing game development technologies. This means you can take your existing SpriteKit or SceneKit skills and integrate them with AR without too much work, which is a tantalising prospect indeed.

Xcode comes with a great ARKit template right out of the box, so I encourage you to give it a try – you'll be surprised how easy it is!

I want to walk through the template just briefly so you can see how everything fits together. First, create a new Xcode project using the Augmented Reality App template, then select SpriteKit for Content Technology. Yes, SpriteKit is a 2D framework, but it still works great in ARKit because it billboards your sprites so they appear to twist and turn in 3D.

If you open Main.storyboard, you'll see that the ARKit template works a little differently from the regular SpriteKit template: it uses a new `ARSKView` Interface Builder object, which is what brings together the two worlds of ARKit and SpriteKit. That's connected to an outlet in ViewController.swift, which sets up the AR tracking in `viewWillAppear()` and pauses it in `viewWillDisappear()`.

However, the *real* work takes place in two other places: the `touchesBegan()` method of Scene.swift, and the `nodeFor` method in ViewController.swift. In regular SpriteKit you create nodes and add them to your scene directly, but with ARKit you create *anchors* – placeholders that have a position in the scene and an identifier, but no actual content. These then get converted into SpriteKit nodes as needed using the `nodeFor` method. If you've ever used `MKMapView`, this is similar to the way annotations and pins work – annotations are your model data, and pins are the views.

Inside Scene.swift's `touchesBegan()` method you'll see code to pull out the current frame from ARKit, then calculate where to place a new enemy. This is done using matrix multiplication: if you create an identity matrix (something representing the position X:0, Y:0, Z:0) then move its Z coordinate back by 0.2 (equivalent to 0.2 meters), you can multiply that by the current scene's camera to move back in the direction the user is pointing.

So, if the user is pointing ahead the anchor will be placed ahead, but if they are pointing up then the anchor will be placed above. And once the anchor is placed there, it stays there: ARKit will move, rotate and warp it automatically to ensure it stays aligned correctly as the player's device moves.

All that is done using these three lines of code:

```
var translation = matrix_identity_float4x4
translation.columns.3.z = -0.2
let transform = simd_mul(currentFrame.camera.transform, translation)
```

Once the transform is calculated it gets converted into an anchor and added to the session like this:

```
let anchor = ARAnchor(transform: transform)
sceneView.session.add(anchor: anchor)
```

Finally, the `nodeFor` method in ViewController.swift will get called. This happens because that view controller was configured to be the delegate of the `ARSKView`, so it's responsible for converting anchors into nodes as needed. You *don't* need to worry about positioning these nodes: remember, anchors are already being placed at precise coordinates in real-world space, and ARKit is responsible for mapping its position and transform to your SpriteKit nodes.

As a result, the `nodeFor` method is simple:

```
func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
    // Create and configure a node for the anchor added to the view's session.
    let labelNode = SKLabelNode(text: "Enemy")
    labelNode.horizontalAlignmentMode = .center
    labelNode.verticalAlignmentMode = .center
    return labelNode;
}
```

In case you were wondering, ARKit anchors have an `identifier` property that lets you know what kind of node to create. In the Xcode template all anchors are space aliens, but in your own projects you'll almost certainly want to identify things more uniquely.

And that's it! The end result is remarkably effective given how little code it takes – ARKit should prove to be a big hit.

## Intermission

If you're enjoying this article, you might be interested in a new book I'm working on that teaches iOS 11 using hands-on tutorials. You'll make real projects that build on Core ML, PDFView, ARKit, drag and drop, and more – **it's the fastest way to learn iOS 11!**

![](https://www.hackingwithswift.com/img/book-ios11@2x.png)

[Buy Practical iOS 11 for $30](https://www.hackingwithswift.com/store/practical-ios11)


## PDF rendering

macOS has always had first-rate support for rendering PDFs, and since OS X 10.4 has benefited from a framework called PDFKit that provides PDF rendering, manipulation, annotations, and more with hardly any code.

Well, as of iOS 11 that's available on iOS 11 in its entirety: you can use the `PDFView` class to display PDFs, let users move through a document, select and share content, zoom in and out, and more. Alternatively, you can use individual classes such as `PDFDocument`, `PDFPage`, and `PDFAnnotation` to create your own custom PDF reader.

As with drag and drop, we can create a simple container app to demonstrate just how easy PDFKit is. You can re-use the same Single View App project you made earlier if you want, but you do need to add a PDF to your project so PDFKit has something to read from.

To write this code you need to learn two new classes, both of which are trivial. The first is `PDFView`, which does all the hard work of rendering PDFs, responding to scroll and zoom gestures, selecting text, and so on. This is just a regular `UIView` subclass in iOS, so you can create it without any parameters then position it using Auto Layout to fit your needs. The second new class is `PDFDocument`, which loads a PDF from a URL ready to be rendered or manipulated elsewhere.

Replace all the code in ViewController.swift with this:

```
import PDFKit
import UIKit

class ViewController: UIViewController {
    // store our PDFView in a property so we can manipulate it later
    var pdfView: PDFView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // create and add the PDF view
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        // make it take up the full screen
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // load our example PDF and make it display immediately
        let url = Bundle.main.url(forResource: "your-pdf-name-here", withExtension: "pdf")!
        pdfView.document = PDFDocument(url: url)
    }
}
```

If you run the app you should already see you can scroll vertically through pages using a continuous scrolling mechanism. You can also pinch to zoom if you're testing on a real device – and you'll see the PDF re-render at higher resolution as you do. If you want to change the way the PDF is laid out, you can try manipulating the `displayMode`, `displayDirection`, and `displaysAsBook` properties.

For example, you can position the pages as double-page spreads with the cover by itself like this:

```
pdfView.displayMode = .twoUpContinuous
pdfView.displaysAsBook = true
```

The `PDFView` class comes with a bunch of helpful methods to let users navigate and manipulate the PDF. To try this out, we're going to add some navigation bar buttons to our view controller, because that's the easiest way to add some interactivity.

This takes three steps, starting with adding a navigation controller so we have an actual navigation bar to work with. So, open Main.storyboard, select View Controller Scene in the document outline, then go to the Editor menu and choose Embed In > Navigation Controller.

Next, add this code to `viewDidLoad()` in ViewController.swift

```
let printSelectionBtn = UIBarButtonItem(title: "Selection", style: .plain, target: self, action: #selector(printSelection))
let firstPageBtn = UIBarButtonItem(title: "First", style: .plain, target: self, action: #selector(firstPage))
let lastPageBtn = UIBarButtonItem(title: "Last", style: .plain, target: self, action: #selector(lastPage))

navigationItem.rightBarButtonItems = [printSelectionBtn, firstPageBtn, lastPageBtn]
```

That sets up three buttons to add some basic functionality. Finally, we just need to write the three methods being called by those buttons, so add these methods to the `ViewController` class:

```
func printSelection() {
    print(pdfView.currentSelection ?? "No selection")
}

func firstPage() {
    pdfView.goToFirstPage(nil)
}

func lastPage() {
    pdfView.goToLastPage(nil)
}
```

Now, if this were Swift 3 we would be done. But as of Swift 4 you'll start seeing the error "Argument of '#selector' refers to instance method 'firstPage()' that is not exposed to Objective-C", along with the proposed fix of "Add '@objc' to expose this instance method to Objective-C". What this means is that the Swift method in question isn't visible to Objective-C, which matters because `UIBarButtonItem` is Objective-C code.

While adding `@objc` to individual methods is a working solution, I expect most people will just shrug their shoulders and put `@objcMembers` before their class – that automatically exposes everything in the class to Objective-C, just like Swift 3 used to. So, modify the class definition to this:

```
@objcMembers
class ViewController: UIViewController {
```

That should compile correctly now, and you'll see the first and last pages work straight away. As for the selection button, you just need to select some text in the PDF before clicking it - this works just like text selection in iBooks.

## NFC reading now available

The iPhone 7 introduced hardware support for NFC, and as of iOS 11 that's available for all of us to use in our apps: you can now write code to detect nearby NFC NDEF tags, and it's surprisingly easy – at least in *code*. However, before we get to the code you have to jump through a number of deeply irritating hoops, all of which I dearly hope will disappear before release.

**Step 1:** Create a new Single View App template in Xcode.

**Step 2:** Go to the iTunes provisioning portal at [https://developer.apple.com/account/](https://developer.apple.com/account/) and create an App ID for your app that includes support for NFC Tag Reading.

**Step 3:** Create a provisioning profile for that app ID, and install it into Xcode. Uncheck the "Automatically manage signing" checkbox, and instead select the provisioning profile you just installed. You should be able to click the small "i" button next to the profile and see "com.apple.developer.nfc.readersession.formats" in the list of entitlements.

**Step 4:** Press Cmd+N to add a new file to the project, then choose Property List. Name it "Entitlements.entitlements", and make sure "Group" has a blue icon next to it.

**Step 5:** Open Entitlements.entitlements for editing, then right-click in the whitespace and choose "Add Row". Give it the key name "com.apple.developer.nfc.readersession.formats" and change its type to Array. Click the disclosure indicator to the left of "com.apple.developer.nfc.readersession.formats", then click the + sign to the right of it. That should insert "Item 0" with an empty value – change the value to be "NDEF".

**Step 6:** Go to the build settings for your target and search for Code Signing Entitlements. Enter "Entitlements.entitlements" into that text box.

**Step 7:** Open your Info.plist file, then right-click in the white space and choose "Add Row". Give it the key name "Privacy - NFC Scan Usage Description" and the value "SwiftyNFC".

Yes, it's a complete mess. No, I don't know why – being able to scan NFC is hardly any more private than having access to someone's health records, and that's much easier to do. And before you think it's because nefarious apps could scan for NFC without the user knowing, put your mind at rest: as you'll see in just a moment that simply isn't possible.

After the chaos of setting up, I'm happy to report that the code required to make NFC work is almost trivial: create a property to store a `NFCNDEFReaderSession` object, which represents the current NFC scanning session, then create it and ask it to begin scanning.

When you create the reader session, you need to give it three pieces of data: the delegate it can send messages to, the queue it should use to send those messages, and whether it should stop scanning as soon as it finds an NFC tag. We're going to use `self` for the delegate, `DispatchQueue.main` for the queue, and false to stop scanning after it finds a tag, so it continues scanning until its 60-second time out is reached.

Open ViewController.swift, add an import for `CoreNFC`, then add this property to the `ViewController` class:

```
var session: NFCNDEFReaderSession!
```

Next, add these two lines of code to `viewDidLoad()`:

```
session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
session.begin()
```

The `ViewController` class doesn't currently conform to the `NFCNDEFReaderSessionDelegate` protocol, so you'll need to amend your class definition to include it:

```
class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {
```

As per usual, Xcode will complain that you're missing some required methods, so use its recommended fix to insert these two method stubs:

```
func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    code
}

func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    code
}
```

Both of those methods are easy enough, but error handling is particularly so – we're just going to make the error print out to the Xcode console. Fill in the `didInvalidateWithError` method like this:

```
func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    print(error.localizedDescription)
}
```

Now for the `didDetectNDEFs` method. When this is called you'll get an array of detected messages, each of which can contain one or more records describing a single piece of data. For example, you might have seen NFC used to launch the Google Cardboard app: Cardboard devices have a simple NFC tag containing the absolute URL "cardboard://V1.0.0", which gets detected by devices and causes the app to be shown.

What you do with the NFC data is down to you, so we're just going to print it out. Modify your `didDetectNDEFs` method to this:

```
func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    for message in messages {
        for record in message.records {
            if let string = String(data: record.payload, encoding: .ascii) {
                print(string)
            }
        }
    }
}
```

That's all the code complete, so go ahead and run the app! If everything has worked, you will immediately see some system user interface appear prompting the user to hold their device near something to scan. This is why it's just not possible for nefarious apps to abuse NFC scanning – not only do we have no control over the user interface, but it also times out after 60 seconds to avoid wasting battery.

## Machine learning and Vision

Machine Learning is the *buzzword du jour*, and lets computers adapt to new data based on processing rules they have been exposed to in the past. For example, "does this picture contain a guitar?" is a difficult question to answer if you just have a picture of a guitar and an empty Swift file, but if you build a trained model out of many sample input images of a guitar then you can effectively train computers to detect new images of guitars.

This might sound dull, but it's actually the basis of a number of huge technologies in iOS 11: Siri, Camera, and Quick Type all use it to help gain a better understanding of the world you're using them in. iOS 11 also introduces a new Vision framework, which is a slightly nebulous combination of things from Core Image, machine learning functionality, and all new technology.

In iOS 11 this is all provided by a new machine learning framework called Core ML, which is designed to support a wide variety of models rather than just examining images. Believe it or not, Core ML is almost trivial to write code for, however, that's only one part of the story.

You see, Core ML requires trained models to work with: the result of training an algorithm on a variety of data. These models can range from a few kilobytes to hundreds of megabytes or more, and obviously require a certain amount of expertise to produce – particularly if you're working with image recognition. Fortunately, Apple has provided a handful of models we can use to get up and running quickly, so if you just want to take Core ML for a test ride it's actually easy.

Sadly, even that is only another part of the story: there's a third part, which is thoroughly evil. You see, Core ML models automatically generate code for us that accept some input data and return some output – that part is beautiful. Sadly, the input data they want when processing images isn't a `UIImage`, nor is it a `CGImage`, or even a `CIImage`.

Instead, Apple has chosen to make us use `CVPixelBuffer`, which is about as welcome in my code as a porcupine in a hemophiliac meetup. There is no nice, efficient way of converting a `UIImage` to a `CVPixelBuffer`, and I feel confident saying that because I wasted several hours trying to make one. Fortunately for me [Chris Cieslak](https://twitter.com/cieslak) was kind enough to share his code with me, and he's made it available under the [WTFPL](http://www.wtfpl.net/about/) so you can use it too.

Let's try out Core ML now. Create a new Single View App project (or re-use your existing one), then add a picture of something – I added a picture of [Washington Dulles International Airport](https://upload.wikimedia.org/wikipedia/commons/9/92/Washington_Dulles_International_Airport_at_Dusk.jpg) from Wikipedia. Name the picture "test.jpg" in your project to avoid typos.

Now that we have some test input, we need to add a trained model. It might not have seen our exact picture before, but it needs to have been exposed to similar pictures in order to have a shot at recognizing the airport. Apple provides a selection of pre-configured models at [https://developer.apple.com/machine-learning](https://developer.apple.com/machine-learning/) – please go there now, and download the model for "Places205-GoogLeNet". This is only 25MB, so it won't take up much space on your user's devices.

Once you've downloaded the model, drag it into your Xcode project then select it so you can see Core ML's model viewer. You'll see it's a neural network classifier produced out of MIT, and available under a Creative Commons license. Below that you'll see it has "sceneImage" for its inputs, and "sceneLabelProbs" and "sceneLabel" for its output – an image for input, and some text describing what it thinks of the image for output.

You'll also see "Model class" and "Swift generated source" – Xcode generates a class for us that wraps up the entire thing in only a few lines of code, which is quite remarkable as you'll see shortly.

At this point we have an image to recognize and a trained model that can examine it. All we need to do now is put the two together: load the image, prepare it for the model, then ask the model for its prediction.

To help make this code easier to understand, I've split it into a number of chunks. To begin with, open ViewController.swift and modify it to this:

```
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "test.jpg")!

        // 1
        // 2
        // 3
    }
}
```

That just loads our test image, ready for processing. The next steps are to fill in those three comments, one by one, starting with `// 1`.

Image-based Core ML models expect to receive images at a precise size, which is whatever size they were trained with. In the case of the GoogLeNetPlaces model that's 224x224, but other models have different sizes and Core ML will tell you if you send something at the wrong resolution.

So, the first thing we need to is scale down our image so that it's precisely 224x224, disregarding whether we're using a retina device or otherwise. This can be done using `UIGraphicsBeginImageContextWithOptions()`, forcing a scale of 1.0. Replace the `// 1` comment with this:

```
let modelSize = 224
UIGraphicsBeginImageContextWithOptions(CGSize(width: modelSize, height: modelSize), true, 1.0)
image.draw(in: CGRect(x: 0, y: 0, width: modelSize, height: modelSize))
let newImage = UIGraphicsGetImageFromCurrentImageContext()!
UIGraphicsEndImageContext()
```

That gives us a new constant called `newImage`, which is a `UIImage` at the correct size for our model.

Now for the second part, which is the truly vicious conversion between `UIImage` and `CVPixelBuffer`. This is pointlessly complicated, so I'm not even going to bother trying to explain all the various steps and I don't recommend you do anything more than copy and paste this code. Replace the `// 2` comment with this:

```
let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
var pixelBuffer : CVPixelBuffer?
let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
guard (status == kCVReturnSuccess) else { return }

CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

context?.translateBy(x: 0, y: newImage.size.height)
context?.scaleBy(x: 1.0, y: -1.0)

UIGraphicsPushContext(context!)
newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
UIGraphicsPopContext()
CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
```

You might want to wrap all that gibberish in a helper function if you intend to use it a lot, but whatever you do please don't bother trying to memorize it.

Now for the important, interesting, and trivial part: actually using Core ML. This is just three lines of code, which is, quite frankly, criminally easy. Like I said, Xcode automatically generates a Swift class from the Core ML model, so we can instantiate that immediately as `GoogLeNetPlaces`.

We can then pass our pixel buffer into its `prediction()` method, which will either return a prediction or throw an error. In practice, you'll probably find it easier to use `try?` to either get a value back or nil. Finally, we'll just print out the prediction so you can see how Core ML fared.

Replace the `// 3` comment with this:

```
let model = GoogLeNetPlaces()
guard let prediction = try? model.prediction(sceneImage: pixelBuffer!) else { return }
print(prediction.sceneLabel)
```

Believe it or not, that really is all it takes to use Core ML in code; all the rest was setup for those three simple lines. What you get printed out depends on what you put in and your model, but GoogLeNetPlaces correctly identified my image as an airport terminal, and did so entirely on device – there was no need to send the image off to a server to be processed, so you get great privacy out of the box.

## Lots of other improvements…

There are lots of other improvements across iOS 11 – here are my favorites:

- Metal 2 is set to increase graphics performance across the system. I haven't provided code examples here because it's quite a specialist topic – most people will just be happy to see their SpriteKit, SceneKit, and Unity apps get faster for no extra work.
- Table view cells are now automatically self-sizing. Previously this behavior was triggered using `UITableViewAutomaticDimension` for a row height, but it's no longer needed.
- Table views also gained a new closure-based `performBatchUpdates()` method, which lets you animate mutiple inserts, deletes, and moves at once – and even runs a completion closure once the animations are finished.
- The new heavy black titles first seen in Apple Music have now spread across the system, and are available to our own apps with one small change: check "Prefers Large Titles" for your navigation bar in IB, or use `navigationController?.navigationBar.prefersLargeTitles = true` if you prefer to do it in code.
- The `topLayoutGuide` property has been deprecated in favor of `safeAreaLayoutGuide`. This provides edges for all sides rather than just top and bottom, but may well forebode future iPhones with non-rectangular layouts – full-screen iPhone 8 with embedded camera, anyone?
- Stack views have gained a `setCustomSpacing(_:after:)` method, which lets you add gaps in the stack view wherever you want rather than uniformly.

## And then there's Xcode

Xcode 9 is the most exciting Xcode release I've ever seen - it's packed full of incredible new features that will make even the most hardened Xcode complainer reconsider.

Here are the big features that caught my eye:

- Refactoring for Swift and Objective-C is built right into the editor, which means you can make sweeping changes to your code (e.g renaming a method) in just a few clicks.
- Wireless debugging is now available for iOS and tvOS. To enable this functionality, connect your device using USB then go to the Window menu and choose Devices and Simulators. Select your device, then check the "Connect via network" option. Don't be surprised if it doesn't work first time – it's only beta 1!
- The source editor has been rewritten in Swift, which has resulted in extraordinary speed improvements for scrolling and searching, along with helpful features such as scope highlighting when you hold down the Ctrl key.
- You can now add named colors to asset catalogs, which lets you define them once and use them everywhere with the new `UIColor(named:)` initializer.
- There's a new main thread checker enabled by default, which will automatically warn you when it detects any UIKit method calls that aren't made on the main thread – a common source of bugs.
- You can now run multiple simulators concurrently, and you can even resize them freely. Apple added extra user interface around the simulators to give us access to hardware controls.
- If you're not keen to use Swift 4 immediately, there's a new "Swift Language Version" build setting that lets you choose either Swift 4.0 or Swift 3.2. Both use the same compiler, but enable different options internally.

Seriously, I wish I were at WWDC this year just so I could hug the Xcode engineers – this is a scorching release that sets Xcode up for continued greatness.

## What now?

Now that you've had a taste of what's new in iOS 11, you should take a look at my new book: [Practical iOS 11](/store/practical-ios11). It's a book that teaches all the major changes in iOS 11 using practical projects, so you can get to speed as fast as possible.

[![Practical iOS 11](https://www.hackingwithswift.com/img/book-ios11@2x.png)](https://www.hackingwithswift.com/store/practical-ios11)

[Buy Practical iOS 11 for $30](https://www.hackingwithswift.com/store/practical-ios11)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
