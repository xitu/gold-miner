>* 原文链接 : [Good Swift, Bad Swift — Part 1](https://medium.com/@ksmandersen/good-swift-bad-swift-part-1-f58f71da3575)
* 原文作者 : [Kristian Andersen](https://medium.com/@ksmandersen)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


### Good Swift, Bad Swift — Part 1

In about just one short week Swift will be celebrating it’s 2nd anniversary since it’s first developer preview when it was announced at WWDC 2014\. At my workplace we jumped head first into Swift when it was first announced and we haven’t looked back since. But 2 years in I still struggle with defining what makes good Swift code. With Objective-C we’ve had roughly 3 decades of time to figure out the best practices and what makes good and bad Objective-C code.

In this series of posts I will try to distill what I think makes good Swift code and what does not. I am in no way an expert on this subject. My hope is to express my thoughts on the subject and incentivise other Swift developers (yes I am looking at you 🤓) to share their opinions and ideas. If you have any thoughts, critiques or ideas for what is good code please leave a comment below or [get in touch with me on Twitter](http://twitter.com/ksmandersen).

Let’s get started

### Avoid stringly-typed coding errors with Enums

I can’t begin to tell you how many times I’ve banged my face against the desk after spending enormous amounts of time debugging odd bugs that we’re caused by some tiny spelling error in some string somewhere in my code. In addition to saving you time with debugging Enums you will save time on typing since Xcode’s code completion tool will suggest enum values for you.

Here’s a snippet I include in every project where I touch NSURLSession:

    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE
    }

This is an extremely simple enum, that most developers would probably not bother including which I understand. I really do only include it for that reasons stated above.

**Edit:** As pointed out by [Tobias Due Munk](https://medium.com/u/82271c72eab3) you don’t even have to type out the raw string values, since that is provided for you by Swift. You can get away with writing only:

    enum HTTPMethod: String { case GET, POST, PUT, DELETE }

### Locking things down with Access Control keywords

Hang on for a minute. What is up with all this public, private, internal? Why are we all of a sudden writing Java? Like most graduated CS students I have written my fair share of Java code. The language and eco-system is much to my disliking. But even though I don’t care for it, the language still has some sane ideas. If you are writing an API that is any way exposed to other developers who does not know about all the ins and outs of the code your’e exposing you will know about the importance if defining sane and well documented APIs. Adding proper access control keywords to your API methods will help consumers of your code navigate what part of the API surface they are supposed to interface with. Sure you can write some documentation explaining what methods should be used and which should be left alone, but why not just add a keyword to enforce it?

Much to my surprise I’ve talked to a few dusin developers who dislike adding Access Control keywords. The idea of Access Control is not even new in iOS/OS X land. In Objective-C we had the the “public” interface in the .h file and the “private” interface in the .m file.

When writing Swift code I always work from the principle of “most restrictive”. I always start by marking any class, struct, enum and function as private if possible. If I then discover that I will be needing a function outside of the class scope I then go “one level” down in restriction. By using this principle I achieve the smallest possible API surface that other developers have to interact with.

### Using Generics to avoid UIKit boilerplate code

Ever since Swift came out I have been writing views and view controllers entirely in code. Being a former heavy user of the Storyboards I find it much more tangible to see all the code that belongs to a view in one place and not spread between some XML file and a few lines of code.

Having coded a lot of views and view controllers I’ve developed a pattern that has stuck with me. I prefer to instantiate views without arguments (init:frame is the designated initializer) since I also prefer auto layout. If you specify a no-argument initializer in Swift for any UIKit class you are forced to specify a init:coder initializer too. This is extremely annoying. So in order to eliminate a tiny bit of boilerplate code each time I start writing a new view I have a base “Generic View Class” that all my view inherit from instead of UIView.

    public class GenericView: UIView {
        public required init() {
            super.init(frame: CGRect.zero)
            configureView()
        }
             public required init?(coder: NSCoder) {
            super.init(coder: coder)
            configureView()
        }
       internal func configureView() {}
    }

This class also expresses another habit I have, which is to put any “view setup” code like adding subviews, constraints and adjusting colors, fonts, etc in a “configureView” method. Then whenever I want to create a new view I don’t need any of the usual boilerplate code.

    class AwesomeView: GenericView {
        override func configureView() {
            ....
        }
    }let awesomeView = AwesomeView()

This pattern becomes even more powerfull when you combine it with generic view controllers.

    public class GenericViewController&lt;View: GenericView&gt;: UIViewController {
        internal var contentView: View {
            return view as! View
        }
        public init() {
            super.init(nibName: nil, bundle: nil)
        }
        public required init?(coder: NSCoder)
            super.init(coder: coder)
        }
        public override func loadView() {
            view = View()
        }
    }

Now making an awesome view controller for our awesome view is much simpler.

    class AwesomeViewController: GenericViewController&lt;AwesomeView&gt; {
        override func viewDidLoad()
            super.viewDidLoad()
            ....
        }
    }

I’ve taken the code from this pattern and extracted it into a [GitHub repo](https://github.com/ksmandersen/GenericViewKit). [The code](https://github.com/ksmandersen/GenericViewKit) is available as a framework through Carthage or CocoaPods.

I agree, 4 base classes with virtually no implementation doesn’t justify a framework. I choose to publish the code here as a framework because that is for most people the easiest way to start using it. I would argue that it is totally fine to just copy paste the classes into your project. I don’t anticipate many if any updates to the code.

That is it for the first part of the Good Swift, Bad Swift series. I’d love to hear your thoughts, critique and suggestions. Leave a comment below or [shoot me a tweet](http://twitter.com/ksmandersen).

