>* 原文链接 : [Good Swift, Bad Swift — Part 2](https://medium.com/@ksmandersen/good-swift-bad-swift-part-2-d6daebf53a5)
* 原文作者 : [Kristian Andersen](https://medium.com/@ksmandersen)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


A little while ago [I wrote](https://medium.com/@ksmandersen/good-swift-bad-swift-part-1-f58f71da3575) about my concerns in figuring out what constitutes good code and bad code in Swift. 2 years into the public lifetime of the language I am still having a hard time to get a firm grip on best practices. Read the full article here: [Good Swift, Bad Swift — Part 1](https://medium.com/@ksmandersen/good-swift-bad-swift-part-1-f58f71da3575).

In this series of posts I trying to distill what I think makes good Swift code and what does not. I am hoping the awesome community of Swift developers (oh yeah, that is probably you 🤓) will help me onto the path of Swift mastery. If you have any thoughts, critiques or ideas for what is good code please leave a comment below or [get in touch with me on Twitter](http://twitter.com/ksmandersen).

Let’s get started on part 2.


### Bailing out early with guard blocks

With the launch of Swift 2 we got a new keyword that got this developer a little rattled. Guard statements are pretty ingenious when writing [“defensive code”](https://en.wikipedia.org/wiki/Defensive_programming). Every Objective-C programmer should be familiar with defensive programming. With this technique, you try to “bail out” as early as possible when you determine the code you’re about to run is not satisfied with the given input.

Guard statements let’s you specify some constraint that must be satisfied by the code that follows after the guard statement. You are also required to specify what happens if the constraint is not satisfied. Furthermore guard enforces the use of return. In earlier Swift code you would have used regular if-else statements to bail out early. But with guard statements the compiler will save you if you don’t properly return from the unsatisfied constraint.

Here is a rather long but typical example of where guard statements are very handy. This function didPressLogIn is called when the Log In button in a screen is tapped. We want to make sure that the button does not cause the program to perform an additional log in request if it is tapped while an existing request is performed. Therefore we bail out early. Later on we validate the log in form. if the form is not valid we need to remember that we are not trying to log in anymore, but more importantly we need to return execution so we don’t send the log in request. The guard statement will complain if we don’t include the return.

    @objc func didPressLogIn(sender: AnyObject?) {
            guard !isPerformingLogIn else { return }
            isPerformingLogIn = true

            let email = contentView.formView.emailField.text
            let password = contentView.formView.passwordField.text

            guard validateAndShowError(email, password: password) else {
                isPerformingLogIn = false
                return
            }

            sendLogInRequest(email, password: password)
    }

Guard statements can become even more powerfull when combined with let assignments. Below we are binding the result of request in a variable for later use by the finishSignUp function. If the result.okValue is nil then the guard is not satisfied, but if it is not nil, the value will be bound to the user variable. We are restricting the guard further with a where clause.

    currentRequest?.getValue { [weak self] result in
      guard let user = result.okValue where result.errorValue == nil else {
        self?.showRequestError(result.errorValue)
        self?.isPerformingSignUp = false
        return
      }

      self?.finishSignUp(user)
    }

Guards are powerfull. If you’re not using them, you should reconsider.

### Group configuration of subviews together with declaration

As mentioned in the previous post, I enjoy writing all of my views out entirely in code. Making sure that all view configuration happens in the view classes so I only have to look in exactly one place when a view has layout issues or is configured improperly.

I’ve found it particularly useful to group the configuration of a single subview together as much as possible. Earlier in my Swift-coding experience I would have one giant configureView method where I initialized every subview and configured them on the spot. But with swift we can use “property declaration blocks” (I don’t know what they’re called) to declare fully configured subviews.

Here AwesomeView has two subviews, bestTitleLabel and otherTitleLabel. Both subviews are configured fully in one place. Their constraints configuration is grouped together in configureView. If I ever need to say change the textColor of a label, I know exactly where to look because it’s easy to find where the label is declared.

    cclass AwesomeView: GenericView {
        let bestTitleLabel = UILabel().then {
            $0.textAlignment = .Center
            $0.textColor = .purpleColor()tww
        }

        let otherTitleLabel = UILabel().then {
            $0.textAlignment = .
            $0.textColor = .greenColor()
        }

        override func configureView() {
            super.configureView()

            addSubview(bestTitleLabel)
            addSubview(otherTitleLabel)

            // Configure constraints
        }
    }

My only dislike with the code above is the repetition of first declaring the label with type and then inside the block explicitly initializing it and returning it. With [Then](https://github.com/devxoul/Then).swift we can do just a little bit better. Then is a tiny little function that you can drop into your project to run blocks of code chained to the declaration of objects. This reduces the duplication a bit.

    class AwesomeView: GenericView {
        let bestTitleLabel = UILabel().then {
            $0.textAlignment = .Center
            $0.textColor = .purpleColor()tww
        }

        let otherTitleLabel = UILabel().then {
            $0.textAlignment = .
            $0.textColor = .greenColor()
        }

        override func configureView() {
            super.configureView()

            addSubview(bestTitleLabel)
            addSubview(otherTitleLabel)

            // Configure constraints
        }
    }



### Grouping class members by access level

One thing that occurred to me recently is that I have a very particular way of arranging properties and functions on classes and structs. It is something I’ve brought over from my Ojective-C habits. I have always grouped methods such that private method goes further towards the bottom and while public and intialization methods go towards the top. Variables always stay on the top of the class/struct and are ordered from public to private. So if you were to make a list of groups of declarations it would go something like this:

*   public properties
*   internal properties
*   private properties
*   initializers
*   public methods
*   internal methods
*   private methods

The general ranking of things then also change when mix in static/class properties/constants and methods. This sort of ranking is probably the stuff people keep in styleguides. But since I don’t follow one, I’ve never encoded it.

That is it for the second part of the Good Swift, Bad Swift series. I’d love to hear your thoughts, critique and suggestions. Leave a comment below or [shoot me a tweet](http://twitter.com/ksmandersen).

Until the next part, stay Swift 🤓

