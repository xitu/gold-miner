> * 原文地址：[The missing ☑️: SwiftWebUI](http://www.alwaysrightinstitute.com/swiftwebui/)
> * 原文作者：[The Always Right Institute](http://www.alwaysrightinstitute.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/swiftwebui.md](https://github.com/xitu/gold-miner/blob/master/TODO1/swiftwebui.md)
> * 译者：
> * 校对者：

# The missing ☑️: SwiftWebUI

Beginning of the month Apple announced [SwiftUI](https://developer.apple.com/xcode/swiftui/) at the [WWDC 2019](https://developer.apple.com/wwdc19/). A single “cross platform”, “declarative” framework used to build tvOS, macOS, watchOS and iOS UIs. [SwiftWebUI](https://github.com/SwiftWebUI/SwiftWebUI) is bringing that to the Web ✔️

**Disclaimer**: This is a toy project! Do not use for production. Use it to learn more about SwiftUI and its inner workings.

## SwiftWebUI

So what exactly is [SwiftWebUI](https://github.com/SwiftWebUI/SwiftWebUI)? It allows you to write SwiftUI [Views](https://developer.apple.com/documentation/swiftui/view) which display in a web browser:

```swift
import SwiftWebUI

struct MainPage: View {
  @State var counter = 0
  
  func countUp() { counter += 1 }
  
  var body: some View {
    VStack {
      Text("🥑🍞 #\(counter)")
        .padding(.all)
        .background(.green, cornerRadius: 12)
        .foregroundColor(.white)
        .tapAction(self.countUp)
    }
  }
}
```

Results in:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/AvocadoCounter/AvocadoCounter.gif)

Unlike some other efforts this doesn’t just render SwiftUI Views as HTML. It also sets up a connection between the browser and the code hosted in the Swift server, allowing for interaction - buttons, pickers, steppers, lists, navigation, you get it all!

In other words: [SwiftWebUI](https://github.com/SwiftWebUI/SwiftWebUI) is an implementation of (many but not all parts of) the SwiftUI API for the browser.

To repeat the **Disclaimer**: This is a toy project! Do not use for production. Use it to learn more about SwiftUI and its inner workings.

## Learn once, use anywhere

The stated goal of SwiftUI is not “[Write once, run anywhere](https://en.wikipedia.org/wiki/Write_once,_run_anywhere)” but “[Learn once, use anywhere](https://developer.apple.com/videos/play/wwdc2019/216)”. Don’t expect to be able to take a beautiful SwiftUI application for iOS, drop the code into a SwiftWebUI project and get it to render exactly the same in the browser. That is not the point.

The point is to be able to reuse the [knoff-hoff](https://en.wikipedia.org/wiki/Die_Knoff-Hoff-Show) and share it between different platforms. In this case, the Web ✔️

But lets get down to the nitty gritty and write a simple SwiftWebUI application. In the spirit of “Learn once, use anywhere” watch those two WWDC sessions first: [Introducing SwiftUI](https://developer.apple.com/videos/play/wwdc2019/204/) and [SwiftUI Essentials](https://developer.apple.com/videos/play/wwdc2019/216). We don’t go that deep in this blog entry, but this one is recommended too (and the concepts are mostly supported in SwiftWebUI): [Data Flow Through SwiftUI](https://developer.apple.com/videos/play/wwdc2019/226).

## Requirements

As of today SwiftWebUI requires a [macOS Catalina](https://www.apple.com/macos/catalina-preview/) installation to run (“Swift ABI” 🤦‍♀️). Fortunately it is really easy to [install Catalina on a separate APFS volume](https://support.apple.com/en-us/HT208891). And an installation of [Xcode 11](https://developer.apple.com/xcode/) is required to get the new Swift 5.1 features SwiftUI makes heavy use of. Got that? Very well!

> Linux? The project is indeed **prepared** to run on Linux, but that hasn’t been finished yet. The only real thing missing is a simple implementation of the [Combine](https://developer.apple.com/documentation/combine) [PassthroughSubject](https://developer.apple.com/documentation/combine/passthroughsubject) and a little infrastructure surrounding that. Prepared: [NoCombine](https://github.com/SwiftWebUI/SwiftWebUI/blob/master/Sources/SwiftWebUI/Misc/NoCombine.swift). PRs are welcome!

> Mojave? There is a chance to get this to run on Mojave w/ Xcode 11. You’d need to create an iOS 13 simulator project and run the whole thing within that.

## Getting Started with a First App

### Creating a SwiftWebUI Project

Fire up Xcode 11, select “File > New > Project…” or just press Cmd-Shift-N:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/1-new-project.png)

Select the “macOS / Command Line Tool” project template:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/2-new-cmdline-tool.png)

Give it some nice name, let’s go with “AvocadoToast”:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/3-swift-project-name.png)

Then we add [SwiftWebUI](https://github.com/SwiftWebUI/SwiftWebUI) as a Swift Package Manager dependency. The option is hidden in the “File / Swift Packages” menu group:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/4-add-pkg-dep.png)

Enter `https://github.com/SwiftWebUI/SwiftWebUI.git` as the package URL:

[![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/5-add-swui-dep.png)](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/5-add-swui-dep-large.png)

Use “Branch” `master` option to always get the latest and greatest (you can also use a revision or the `develop` branch):

[![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/6-branch-select.png)](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/6-branch-select-large.png)

Finally add the `SwiftWebUI` library to your tool target:

[![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/7-target-select.png)](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/7-target-select-large.png)

That’s it. You now have a tool project which can `import SwiftWebUI`. (Xcode might take a moment to fetch and build the dependencies.)

### SwiftWebUI Hello World

Let’s get started w/ SwiftWebUI. Open the `main.swift` file and replace it’s content with:

```swift
import SwiftWebUI

SwiftWebUI.serve(Text("Holy Cow!"))
```

Compile and run the app in Xcode, open Safari and hit [`http://localhost:1337/`](http://localhost:1337/):

![](http://www.alwaysrightinstitute.com/images/swiftwebui/HolyCow/holycow.png)

What is going on here: First the SwiftWebUI module is imported (don’t accidentially import the macOS SwiftUI 😀)

Then we call `SwiftWebUI.serve` which either takes a a closure returning a View, or just a straight View - as shown here: a [`Text`](https://developer.apple.com/documentation/swiftui/text) View (aka a “UILabel” which can show plain or formatted text).

#### Behind the scenes

Internally the [`serve`](https://github.com/SwiftWebUI/SwiftWebUI/blob/master/Sources/SwiftWebUI/ViewHosting/Serve.swift#L66) function creates a very simple [SwiftNIO](https://github.com/apple/swift-nio) HTTP server listening on port 1337. When the browser hits that server, it creates a [session](https://github.com/SwiftWebUI/SwiftWebUI/blob/master/Sources/SwiftWebUI/ViewHosting/NIOHostingSession.swift) and passes our (Text) View to that session.  
Finally, from the View, SwiftWebUI creates a “Shadow DOM” on the server, renders that as HTML and sends the result to the server. That “Shadow DOM” (and a state object kept alongside) is stored in the session.

> This is a difference between a SwiftWebUI application and a watchOS or iOS SwiftUI app. A single SwiftWebUI application serves a bunch of users instead of just one.

### Adding some Interaction

As a first step, lets organize the code a little better. Create a new Swift file in the project and call that `MainPage.swift`. And add a simple SwiftUI View definition to it:

```swift
import SwiftWebUI

struct MainPage: View {
  
  var body: some View {
    Text("Holy Cow!")
  }
}
```

Adjust the main.swift to serve our custom View:

```swift
SwiftWebUI.serve(MainPage())
```

We can now leave the `main.swift` alone and do all our work in our custom [`View`](https://developer.apple.com/documentation/swiftui/view). Let’s add some interaction to it:

```swift
struct MainPage: View {
  @State var counter = 3
  
  func countUp() { counter += 1 }
  
  var body: some View {
    Text("Count is: \(counter)")
      .tapAction(self.countUp)
  }
}
```

Our [`View`](https://developer.apple.com/documentation/swiftui/view) got a persistent [`State`](https://developer.apple.com/documentation/swiftui/state) variable named `counter` (not sure what this is? Have another look at [Introducing SwiftUI](https://developer.apple.com/videos/play/wwdc2019/204/)). And a small function to bump the counter.  
We then use the SwiftUI [`tapAction`](https://developer.apple.com/documentation/swiftui/text/3086357-tapaction) modifier to attach an event handler to our `Text`. Finally, we show the current value within the label:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/HolyCow/ClickCounter.gif)

🧙‍♀️ **MAGIC** 🧙

#### Behind the scenes

How does that work? When the browser hit our endpoint, SwiftWebUI created the session and our “Shadow DOM” within that. It then sent the HTML describing our View to the browser. The `tapAction` works by adding an `onclick` handler to the HTML. SwiftWebUI also ships (tiny amounts, no big framework!) of JavaScript to the browser which handles the click and forwards that to our Swift server.

Then the usual SwiftUI magic kicks in. SwiftWebUI correlates the click event with the event handler in our “Shadow DOM” and invokes the `countUp` function. By modifying the `counter` [`State`](https://developer.apple.com/documentation/swiftui/state) variable the function invalidates the rendering of our View. SwiftWebUI kicks in, and diffes the changes in the “Shadow DOM”. Those changes are then sent back to the browser.

> The “changes” are sent as a JSON array which our small JavaScript in the page can process. If a whole subtree changed (e.g. if a user navigated to a whole new View), a change can be a larger HTML snippet which is applied to `innerHTML` or `outerHTML`.  
> But usually the changes are small things like `add class`, `set HTML attribute` and the likes (i.e. browser DOM modifications).

## 🥑🍞 Avocado Toast

Excellent, the basics work. Let’s bring in more interactivity. The following is based on the “Avocado Toast App” used to demo SwiftUI in the [SwiftUI Essentials](https://developer.apple.com/videos/play/wwdc2019/216) talk. Didn’t watch it yet? Maybe you should, it is about delicious toasts.

> The HTML/CSS styling isn’t quite perfect nor beautiful yet. As you can imagine we are not web designers and could use some help here. PRs are welcome!

Want to skip the details, watch a GIF of the app and download it on GitHub: [🥑🍞](#the--finished-app).

### The 🥑🍞 Order Form

The talk starts off with this (~6:00), which we can add to a new `OrderForm.swift` file:

```swift
struct Order {
  var includeSalt            = false
  var includeRedPepperFlakes = false
  var quantity               = 0
}
struct OrderForm: View {
  @State private var order = Order()
  
  func submitOrder() {}
  
  var body: some View {
    VStack {
      Text("Avocado Toast").font(.title)
      
      Toggle(isOn: $order.includeSalt) {
        Text("Include Salt")
      }
      Toggle(isOn: $order.includeRedPepperFlakes) {
        Text("Include Red Pepper Flakes")
      }
      Stepper(value: $order.quantity, in: 1...10) {
        Text("Quantity: \(order.quantity)")
      }
      
      Button(action: submitOrder) {
        Text("Order")
      }
    }
  }
}
```

For testing direct `SwiftWebUI.serve()` in `main.swift` to the new `OrderForm` View.

This is what it looks like in the browser:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/AvocadoOrder/orderit.gif)

> [SemanticUI](https://semantic-ui.com) is used for styling some things in SwiftWebUI. It is not strictly required for the operation, it just accomplishes somewhat decent looking widgets.  
> Note: Only the CSS/fonts are used, not the JavaScript components.

### Intermission: Some SwiftUI Layout

Around 16:00 in [SwiftUI Essentials](https://developer.apple.com/videos/play/wwdc2019/216) they are getting to SwiftUI layout and View modifier ordering:

```swift
var body: some View {
  HStack {
    Text("🥑🍞")
      .background(.green, cornerRadius: 12)
      .padding(.all)
    
    Text(" => ")
    
    Text("🥑🍞")
      .padding(.all)
      .background(.green, cornerRadius: 12)
  }
}
```

Results in this, notice how the ordering of the modifiers is relevant:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/AvocadoLayout.png)

> SwiftWebUI tries to replicate common SwiftUI layouts, but doesn’t fully succeed yet. After all it has to deal with the layout system the browser provides. Help wanted, flexbox experts welcome!

### The 🥑🍞 Order History

Back to the app, the talk (~19:50) introduces the [List](https://developer.apple.com/documentation/swiftui/list) View for showing an Avocado toast order history. This is how it looks on the Web:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/OrderHistory/OrderHistory1.png)

The `List` view walks over the array of completed orders and creates a child View for each one (`OrderCell`), passing in the current item in the list.

This is the code we are using:

```swift
struct OrderHistory: View {
  let previousOrders : [ CompletedOrder ]
  
  var body: some View {
    List(previousOrders) { order in
      OrderCell(order: order)
    }
  }
}

struct OrderCell: View {
  let order : CompletedOrder
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(order.summary)
        Text(order.purchaseDate)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      Spacer()
      if order.includeSalt {
        SaltIcon()
      }
      else {}
      if order.includeRedPepperFlakes {
        RedPepperFlakesIcon()
      }
      else {}
    }
  }
}

struct SaltIcon: View {
  let body = Text("🧂")
}
struct RedPepperFlakesIcon: View {
  let body = Text("🌶")
}

// Model

struct CompletedOrder: Identifiable {
  var id           : Int
  var summary      : String
  var purchaseDate : String
  var includeSalt            = false
  var includeRedPepperFlakes = false
}
```

> The SwiftWebUI List View is really inefficient, it always renders the whole set of children. No cell reuse, no nothing 😎 There are various ways to deal with that in a web app, e.g. by using paging or more client side logic.

So you don’t have to type down the sample data from the talk, we did that for you:

```swift
let previousOrders : [ CompletedOrder ] = [
  .init(id:  1, summary: "Rye with Almond Butter",  purchaseDate: "2019-05-30"),
  .init(id:  2, summary: "Multi-Grain with Hummus", purchaseDate: "2019-06-02",
        includeRedPepperFlakes: true),
  .init(id:  3, summary: "Sourdough with Chutney",  purchaseDate: "2019-06-08",
        includeSalt: true, includeRedPepperFlakes: true),
  .init(id:  4, summary: "Rye with Peanut Butter",  purchaseDate: "2019-06-09"),
  .init(id:  5, summary: "Wheat with Tapenade",     purchaseDate: "2019-06-12"),
  .init(id:  6, summary: "Sourdough with Vegemite", purchaseDate: "2019-06-14",
        includeSalt: true),
  .init(id:  7, summary: "Wheat with Féroce",       purchaseDate: "2019-06-31"),
  .init(id:  8, summary: "Rhy with Honey",          purchaseDate: "2019-07-03"),
  .init(id:  9, summary: "Multigrain Toast",        purchaseDate: "2019-07-04",
        includeSalt: true),
  .init(id: 10, summary: "Sourdough with Chutney",  purchaseDate: "2019-07-06")
]
```

### The 🥑🍞 Spread Picker

The Picker control and how to use it w/ enum’s is demonstrated ~43:00. First the enums for the various toast options:

```swift
enum AvocadoStyle {
  case sliced, mashed
}

enum BreadType: CaseIterable, Hashable, Identifiable {
  case wheat, white, rhy
  
  var name: String { return "\(self)".capitalized }
}

enum Spread: CaseIterable, Hashable, Identifiable {
  case none, almondButter, peanutButter, honey
  case almou, tapenade, hummus, mayonnaise
  case kyopolou, adjvar, pindjur
  case vegemite, chutney, cannedCheese, feroce
  case kartoffelkase, tartarSauce

  var name: String {
    return "\(self)".map { $0.isUppercase ? " \($0)" : "\($0)" }
           .joined().capitalized
  }
}
```

We can add those to our `Order` struct:

```swift
struct Order {
  var includeSalt            = false
  var includeRedPepperFlakes = false
  var quantity               = 0
  var avocadoStyle           = AvocadoStyle.sliced
  var spread                 = Spread.none
  var breadType              = BreadType.wheat
}

```

And then display them using the different Picker types. It is pretty neat how you can just loop over the enum values:

```swift
Form {
  Section(header: Text("Avocado Toast").font(.title)) {
    Picker(selection: $order.breadType, label: Text("Bread")) {
      ForEach(BreadType.allCases) { breadType in
        Text(breadType.name).tag(breadType)
      }
    }
    .pickerStyle(.radioGroup)
    
    Picker(selection: $order.avocadoStyle, label: Text("Avocado")) {
      Text("Sliced").tag(AvocadoStyle.sliced)
      Text("Mashed").tag(AvocadoStyle.mashed)
    }
    .pickerStyle(.radioGroup)
    
    Picker(selection: $order.spread, label: Text("Spread")) {
      ForEach(Spread.allCases) { spread in
        Text(spread.name).tag(spread) // there is no .name?!
      }
    }
  }
}
```

The result:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/AvocadoOrder/picker.png)

> Again, this needs some CSS love to make it look better …

### The 🥑🍞 “Finished” App

No we diverge a little from the original, and do not really finish it either. It doesn’t look that great yet, but it is a demo after all 😎

![](http://www.alwaysrightinstitute.com/images/swiftwebui/AvocadoOrder/AvocadoToast.gif)

The finished app is available on GitHub: [AvocadoToast](https://github.com/SwiftWebUI/AvocadoToast).

## HTML and SemanticUI

The [`UIViewRepresentable`](https://developer.apple.com/documentation/swiftui/uiviewrepresentable) peer in SwiftWebUI is emitting raw HTML.

Two variants are provided, the `HTML` outputs a String as-is, or by HTML escaping the contents:

```swift
struct MyHTMLView: View {
  var body: some View {
    VStack {
      HTML("<blink>Blinken Lights</blink>")
      HTML("42 > 1337", escape: true)
    }
  }
}
```

Using this primitive you can essentially build any HTML you want.

A little higher level and even used internally is `HTMLContainer`. For example this is the implementation of our `Stepper` control:

```swift
var body: some View {
  HStack {
    HTMLContainer(classes: [ "ui", "icon", "buttons", "small" ]) {
      Button(self.decrement) {
        HTMLContainer("i", classes: [ "minus", "icon" ], body: {EmptyView()})
      }
      Button(self.increment) {
        HTMLContainer("i", classes: [ "plus", "icon" ], body: {EmptyView()})
      }
    }
    label
  }
}
```

The `HTMLContainer` is “reactive”, i.e. it will emit regular DOM changes if classes, styles or attributes change (instead of re-rendering the whole thing)

### SemanticUI

SwiftWebUI also comes w/ a few [SemanticUI](https://semantic-ui.com) controls pre-setup:

```swift
VStack {
  SUILabel(Image(systemName: "mail")) { Text("42") }
  HStack {
    SUILabel(Image(...)) { Text("Joe") } ...
  }
  HStack {
    SUILabel(Image(...)) { Text("Joe") } ...
  }
  HStack {
    SUILabel(Image(...), Color("blue"), 
             detail: Text("Friend")) 
    {
      Text("Veronika")
    } ...
  }
}
```

… renders such:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/SemanticUI/labels.png)

> Note that SwiftWebUI also supports some SFSymbols image names (via `Image(systemName:)`). Those are backed by SemanticUI’s [support for Font Awesome](https://semantic-ui.com/elements/icon.html).

There is also `SUISegment`, `SUIFlag` and`SUICard`:

```swift
SUICards {
  SUICard(Image.unsplash(size: UXSize(width: 200, height: 200),
                         "Zebra", "Animal"),
          Text("Some Zebra"),
          meta: Text("Roaming the world since 1976"))
  {
    Text("A striped animal.")
  }
  SUICard(Image.unsplash(size: UXSize(width: 200, height: 200),
                         "Cow", "Animal"),
          Text("Some Cow"),
          meta: Text("Milk it"))
  {
    Text("Holy cow!.")
  }
}
```

… renders those:

![](http://www.alwaysrightinstitute.com/images/swiftwebui/SemanticUI/cards.png)

It is very easy and a lot of fun to add such Views. One can quickly compose pretty complex and good looking layouts using WOComponent's SwiftUI Views.

> `Image.unsplash` constructs image queries against the Unsplash API running at `http://source.unsplash.com`. Just give it some query terms, the size you want and optional scopes.  
> Note: That specific Unsplash service seems to be a little slow and unreliable sometimes.

# Summary

That’s it for our demo. We hope you like it! But to again repeat the **Disclaimer**: This is a toy project! Do not use for production. Use it to learn more about SwiftUI and its inner workings.

We think it is a nice toy and likely a valuable tool to learn more about the inner workings of SwiftUI.

## Abitrary Technology Notes

Just a set of notes on various aspects of the technology. Can be skipped, not that interesting 😎

### Issues

There are a whole lot of issues, some are filed on GitHub: [Issues](https://github.com/SwiftWebUI/SwiftWebUI/issues). Feel free to file more.

Quite a few HTML layout things (e.g. `ScrollView` doesn’t always scroll), but also some open ends like Shapes (which might be easy to do via SVG &| CSS).

Oh, and the single case If-ViewBuilder doesn’t work. No idea why:

```swift
var body: some View {
  VStack {
    if a > b {
      SomeView()
    }
    // currently need an empty else: `else {}` to make it compile.
  }
}
```

Halp wanted! PRs welcome!

### Vs the original SwiftUI

This implementation is pretty simple and inefficient. The real thing has to deal with a much higher rate of state modifying events, does all the animation things at 60Hz frame rates, etc etc.

Our’s focuses on getting the basic operations right, e.g. how States and Bindings work, how and when Views get updated, and so on. Quite possible that the implementation does some things incorrectly, Apple forgot to send us the original’s sources as part of Xcode 11.

### WebSockets

We currently use AJAX to connect the browser to the server. Using WebSockets would have multiple advantages:

* guaranteed event ordering (AJAX requests can arrive out of sync)
* non-user initiated, server side DOM updates (timers, push)
* session timeout indicator

It would make a chat client demo trivial.

Adding WebSockets is actually really easy because events are already sent as JSON. We just need the client and server side shims. All this is already tried out in [swift-nio-irc-webclient](https://github.com/NozeIO/swift-nio-irc-webclient) and just needs to be ported over.

### SPA

The current incarnation of SwiftWebUI is an SPA (single page application) attached to a stateful backend server.

There are other ways to do this, e.g. by persisting the tree states while the user traverses through an application via regular links. Aka WebObjects ;-)

In general it would be nice to have better control on DOM ID generation, link generation, routing and more. Similar to what [SwiftObjects](http://swiftobjects.org/) provides.  
But in the end a user would have to give up a lot of the “Learn once, use anywhere” since SwiftUI action handlers often are built around the fact that those capture arbitrary state.

We’ll see what Swift based server side frameworks come up with 👽

### WASM

The whole thing would become more useful once we get proper Swift WASM. Go WASM!

### WebIDs

Some SwiftUI Views like `ForEach` require `Identifiable` objects, where the `id` can be any `Hashable`. This doesn’t play too well w/ the DOM, because we need string based IDs to identify the nodes.  
This is worked around by mapping IDs to strings in a global map. Which is technically unbounded (a particular issue w/ class references).

Summary: For web code it is better to identify items using strings or ints.

### Form

The Form could use a lot more love: [Issue](https://github.com/SwiftWebUI/SwiftWebUI/issues/10).

SemanticUI has some good form layouts, we should probably rewrite the child trees to those. TBD.

## WebObjects 6 for Swift

Took a while to make it click, but:

> SwiftUI summarised for 40s+ people. [pic.twitter.com/6cflN0OFon](https://t.co/6cflN0OFon)
> 
> — Helge Heß (@helje5) [June 7, 2019](https://twitter.com/helje5/status/1137092138104233987?ref_src=twsrc%5Etfw)

With [SwiftUI](https://developer.apple.com/xcode/swiftui/) Apple indeed gave us a “Swift-style” [WebObjects](https://en.wikipedia.org/wiki/WebObjects) 6!

Next: Direct To Web and some Swift’ified EOF (aka CoreData aka ZeeQL).

## Links

* [SwiftWebUI](https://github.com/SwiftWebUI/SwiftWebUI) on GitHub
* [SwiftUI](https://developer.apple.com/xcode/swiftui/)
    * [Introducing SwiftUI](https://developer.apple.com/videos/play/wwdc2019/204/) (204)
    * [SwiftUI Essentials](https://developer.apple.com/videos/play/wwdc2019/216) (216)
    * [Data Flow Through SwiftUI](https://developer.apple.com/videos/play/wwdc2019/226) (226)
    * [SwiftUI Framework API](https://developer.apple.com/documentation/swiftui)
* [SwiftObjects](http://swiftobjects.org/)
* [SemanticUI](https://semantic-ui.com)
    * [Font Awesome](https://fontawesome.com/)
    * [SemanticUI Swift](https://github.com/SwiftWebResources/SemanticUI-Swift)
* [SwiftNIO](https://github.com/apple/swift-nio)

## Contact

Hey, we hope you liked the article and we love feedback!  
Twitter, any of those: [@helje5](https://twitter.com/helje5), [@ar_institute](https://twitter.com/ar_institute).  
Email: [wrong@alwaysrightinstitute.com](mailto:wrong@alwaysrightinstitute.com).  
Slack: Find us on SwiftDE, swift-server, noze, ios-developers.

Written on June 30, 2019

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
