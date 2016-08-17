
Closures F.T.W.

I’m starting to really dig the whole initialization dance in Swift. [I wrote about it](https://medium.com/the-traveled-ios-developers-guide/they-say-it-s-all-about-how-you-finish-d0203c7fbe8a#.w30umpm7t). [I wrote about why it even works the way it does](https://medium.com/the-traveled-ios-developers-guide/on-definitive-initialization-54284ef5c96f#.mdqytwjfr). I did a talk over it. I read about it (a lot). But hey, I’m back for one more act on the matter.

Of all the many, beautiful and varied ways one can initialize something in Swift — using closures is not typically brought up as a method in which to do so. But alas, it can make boilerplatey**™** init() code much less painful and a little more manageable.

For the programmatic user interface devs out there — this ones for you 🍻!

### UIKit == UIHugeSetupCode()

Look, it’s not UIKits fault. Components that need to be interacted with by a user lend themselves to a mountain of setup code, because preferences. Typically, a lot of this finds itself in either viewDidLoad or loadView:

```
override func loadView()
{
    let helloWorldLbl = UILabel()
    helloWorldLbl.text = NSLocalizedString(“controller.topLbl.helloWorld”, comment: “Hello World!”)
    helloWorldLbl.font =   UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    helloWorldLbl.textColor = UIColor.whiteColor()
    helloWorldLbl.textAlignment = .Center
    self.view.addSubview(helloWorldLbl)
}
```

This is fairly standard for those of us who venture the Cocoa Touch waters without a .xib or .storyboard in sight. Though, if you share my love for minuscule viewDidLoad or loadView methods, you can put this off elsewhere.

Say, a property:

```
let helloWorldLbl:UILabel = {
    let lbl = UILabel()
    lbl.text = NSLocalizedString(“controller.topLbl.helloWorld”, comment: “Hello World!”)
    lbl.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    lbl.textColor = UIColor.whiteColor()
    lbl.textAlignment = .Center
    return lbl
    }()
```

Pretty. In Apple’s own book on Swift, it notes that “if your property’s default value requires some customization or setup, you can use a closure or a global function to provide a customized default value for that property.” As we just mentioned, UIKit controls yield a lot of customization and setup.

One of the pretty byproducts, though, is how loadView looks now:

```
override func loadView
{
    self.view.addSubview(self.helloWorldLbl)
    }
```

Take note, however, of the “()” at the end of the closure in the property declaration. This is letting the little Swift wizards that compile your code know that the instance is being assigned to the _return_ type of the closure. If we were to omit this, it’s possible we could’ve assigned the actual closure itself to the instance.

And in this case, that’s 🙅.

### Rules are Rules

Even though we have a shiny new toy, it’s imperative to remember the rules of the land. Since we’re assigning a property to a closure, the rest of its containing instance might not have been initialized yet. Because of that, when the closure executes — it’s not possible to reference other property values or self from within it.

For example:

```
let helloWorldLbl:UILabel = {
    let lbl = UILabel()
    lbl.text = self.someFunctionToDetermineText() //Compiler error
    lbl.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    lbl.textColor = self.myAppTheme.textColor() //Another error
    lbl.textAlignment = .Center
    return lbl
    }()
```

The instance of self may not be safe to use yet, or it might not be through with Swift’s two-phase initialization process. The same really is true of any instance properties, which may or may not be allocated and initialized since the closure executes immediately.

This is a distinct, but warranted, disadvantage with using closures for initialization. It makes complete sense, though — and it’s right in line with one of the three design goals of Swift: safety.

### Gettin’ Cute with Collections

One area where I’ve found this technique particularly useful is with instances that are representing one of the many different forms of a collection in Swift. Of Swift’s many talents, slicing and sifting through collections with the power of a thousand titans stands as one of my most favorite.

Consider the following example, taken from a initializer in a project I’m currently working on. The class that houses this code has an [Developer] property. On a fresh launch, I set their initial values from a .plist file. Afterwards, these are stored via NSKeyedArchiver.

```
guard let devs = NSKeyedUnarchiver.unarchiveObjectWithFile(DevDataManager.ArchiveURL.path!) as? [Developer] else
{
    self.developers = {
        let pListData = //Get plist data
        var devArray:[Developer] = [Developer]()
        //Set up devArray from plist data
        return devArray.map{ $0.setLocation() }
                       .filter{ $0.isRentable }
                       .sort{ $0.name < $1.name }
     }()
    return
}
self.developers = devs
```

I quite like this approach, because even though we’re not using it outside of an initializer, the intent of the code is very clear in that it’s only responsible for setting a property.

As initializers and viewDidLoad overrides become larger, sectioning things out like this (at the very least) is a welcome gift in terms of readability.

### Getting NSCute

If you just really dig initializing things with a closure, but are suffering from a severe lack of using those functional $’s in your code, cheer up. Using some adept Swiftery, one can author some code that infers the type within the closure itself, which yields some pro style configuration. Consider this code, which I first came across on the always informative [NSHipster](http://nshipster.com/new-years-2016/):

```
@warn_unused_result
public func Init<Type>(value : Type, @noescape block: (object: Type) -> Void) -> Type
{
    block(object: value)
    return value
}

```

I like where this is going. A public function that takes a closure with a typed object using generics, which then returns that type. This means you could turn around and initialize things with more type information. Our first code sample would then, in turn, look like this:

```
let helloWorldLbl = Init(UILabel()) {
    $0.text = NSLocalizedString(“controller.topLbl.helloWorld”, comment: “Hello World!”)
    $0.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    $0.textColor = UIColor.whiteColor()
    $0.textAlignment = .Center
}
```

Fancy though it may seem, it does indeed kill off the need for the instance variable from within the closure, and it gets rid of the “()” requirement. Very nice 👏.

### Final Thoughts

It could be said that using such a technique is six in one hand, and a half dozen in the other. While it’s true the lines of code authored by the programmer remain largely the same, I’d argue that its placement and flexibility makes it ideal for many scenarios.

It’s a fun way to get things done, and there are even a few ways to do the same thing in our old friend Objective-C. But hey, the more you know, amirite?

Until nextWeek = { let week = Week() week.advancedBy(days: 7) }()
