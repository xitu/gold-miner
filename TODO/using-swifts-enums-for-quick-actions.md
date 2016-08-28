> * 原文地址：[Using Swift’s Enums for Quick Actions](https://medium.com/the-traveled-ios-developers-guide/using-swifts-enums-for-quick-actions-a08c0f6d5b8b#.lbt8itrxd)
* 原文作者：[Jordan Morgan](https://medium.com/@JordanMorgan10?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


#### Makin’ 3D Touch All “Swifty” Up In Here

I’m not sure if Swift’s forefathers could’ve estimated the passion and fervor its future developers would hold for the very language they were crafting. Suffice to say, the community has grown and the language has stabilized(ish) to a point where we even have a term now to bestow upon code that displays Swift in all of its intended glory:

_Swifty._

> “That code isn’t Swifty”. “This should be more Swifty”. “This is a Swifty pattern”. “We can make this Swifty”.

And the list goes.on(). While I’m not much of an advocate of the phrase, I can’t really think of a better alternative to describe an idiomatic way to code for 3D touch quick actions.

This week, let’s see how Swift can make us good citizens when it comes to the implementation details of [UIApplicationShortcutItem](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationShortcutItem_class/).

#### The Scenario

When a user initiates a short cut action from the home screen, one of two things happens. The app either invokes a designated function to handle the shortcut, or it’s fast asleep and gets booted up — which means execution will eventually funnel through to the familiar didFinishLaunchingWithOptions.

Either way, the developer will decide which action to take by typically looking at the UIApplicationShortcutItem’s type property.

```
if shortcutItem.type == "bundleid.shortcutType"
{
    //Action triggered
}
```

It works, and for one off side projects it may float your 🚣 just as well.

Alas, this route quickly becomes cumbersome as more short cuts are added, even with the added bonus of being able to use a switch case on String instances within the Swiftosphere**™**. It’s also widely documented that using String literals for such situations can be a foolhardy endeavor:

```
if shortcutItem.type == "bundleid.shortcutType"
{
    //Action triggered
}
else if shortcutItem.type == "bundleid.shortcutTypeXYZ"
{
    //Another action
}
//and on and on
```

Handling these short cut actions is likely a small part of your codebase, but none the less — Swift can make it that much better and a bit more safe. So, let’s have Swift unleash its magic to provide us a better alternative.

#### Enum .Fun

Let’s just say it, Swift’s enumerations are crazy. I never would’ve thought they could use properties, initializers and functions when Swift was announced back in dub dub 14 — but here we are.

Regardless, we can put them to work here. When one considers the implementation details of supporting UIApplicationShortcutItem, a few key points stick out:

*   One must assign a name to the short cut, via the _type_ property
*   By virtue of Apple’s guidance, we should prefix these actions with our bundle identifier
*   There will likely be multiple short cuts
*   We’ll likely take a given action based off of the type in more than one place in our application

Our game plan is simple. We’ll stray from hard coding a String literal, and instead initialize an enum instance to represent the short cut that’s been invoked.

#### The Implementation

Consider our two fictional short cuts. Each one, and every additional one hereafter, is now represented by a enum case.

```
enum IncomingShortcutItem : String
{
    case SomeStaticAction
    case SomeDynamicAction
}
```

With Objective-C, we may have stopped there. I’d submit it’s widely accepted that just having the enum cases is far superior to the String literals we had before. However, some String interpolation would still come in to play as its also best practice to prefix your app’s bundle identifier to each action’s type property (i.e. com.dreaminginbinary.myApp.MyApp).

But — since Swift’s enums have superpowers, we can implement this in a very tidy fashion:

```
enum IncomingShortcutItem : String
{
    case SomeStaticAction
    case SomeDynamicAction
    private static let prefix: String = {
        return NSBundle.mainBundle().bundleIdentifier! + "."
    }()
}
```

Ah — nice! We’ve got our app’s bundle identifier tucked away safely in a computed property. [Recall from last week](https://medium.com/the-traveled-ios-developers-guide/swift-initialization-with-closures-5ea177f65a5#.ar2zxzrfc) that including the parenthesis at the end of the closure signifies that we wish to assign _prefix_ to the closure’s return statement, and not the closure itself.

#### The Cherry on Top

To finalize the pattern, we’ll make use of two of my dearest Swift features. That is, creating a failable initializer for an enumeration, and using a guard statement to enforce safety and promote clear intent.

```
enum IncomingShortcutItem : String
{
    case SomeStaticAction
    case SomeDynamicAction
    private static let prefix: String = {
        return NSBundle.mainBundle().bundleIdentifier! + "."
    }()

    init?(shortCutType: String)
    {
        guard let bundleStringRange = shortCutType.rangeOfString(IncomingShortcutItem.prefix) else
        {
            return nil
        }
        var enumValueString = shortCutType
        enumValueString.removeRange(bundleStringRange)
        self.init(rawValue: enumValueString)
    }
}
```


The failable initializer is important. If there isn’t a matching short cut action corresponding to the given String, we should bail out. It also tells me, if I was the maintainer, that it might lend itself well to a guard statement when the time comes to use it.

The part I especially adore, though, is how we’re able to take advantage of the enum’s _rawValue_ and easily tack it on to our bundle identifier. It’s all housed right where it needs to be, inside of an initializer.

Lest we forget, once its initialized we can also use it for what it is — a enum. That means we’ll have a very readable switch statement with which to reason against later on.

Here is what the final product might look like when it all comes together, slightly abbreviated from a production app:

```
static func handleShortcutItem(shortcutItem:UIApplicationShortcutItem) -&gt; Bool
{
    //Initialize our enum instance to check for a shortcut
    guard let shortCutAction = IncomingShortcutItem(shortCutType: shortcutItem.type) else
    {
        return false
    }
    
    //Now we've got a valid shortcut, and can use a switch
    switch shortCutAction
    {
        case .ShowFavorites:
            return ShortcutItemHelper.showFavorites()
        case .ShowDeveloper:
            return ShortcutItemHelper.handleAction(with: developer)
    }
}
```


Here, our short cut actions become typed and we promote clear intent using this pattern, which is why I quite like it. It’s also unnecessary to provide a final “return false” statement at the end of the method (or even a _default_within the switch statement to boot) since we’re already exhaustive, which is an added culling of the proverbial code fat.

Contrast this from before:

```
static func handleShortcutItem(shortcutItem:UIApplicationShortcutItem) -&gt; Bool
{
    //Initialize our enum instance to check for a shortcut
    let shortcutAction = NSBundle.mainBundle().bundleIdentifier! + "." + shortcutItem.type
    
    if shortCutAction == "com.aCoolCompany.aCoolApp.shortCutOne"
    {
        return ShortcutItemHelper.showFavorites()
    }
    else if shortCutAction == "com.aCoolCompany.aCoolApp.shortCutTwo"
    {
         return ShortcutItemHelper.handleAction(with: developer)
    }
    return false
}
```


True, this could be made a little easier on the eyes with a switch. But I’ve seen similar code abundant before (I’ve certainly written it 🙈), and while it works — I think it illustrates how we can leverage Swift’s features to our advantage. To make our code _that_ much better.

#### Final Thoughts

When I first started reading about enums in Swift way back when, I found them to be a bit heavy handed. Why do I need enums to be able to conform to protocols, have first class inits(), etc. It just seemed a bit much. Years later, though, I believe patterns like this really show why that is.

When I saw Apple implement this pattern, I indeed got 😍. I think this is a great way to solve a small problem, as its a very “team friendly” approach to the implementation details of short cut actions. I would assume they tend to agree, as its included in two of their sample projects showcasing 3D touch.

Until .NextTime 👋

