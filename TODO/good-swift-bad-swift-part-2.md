>* 原文链接 : [Good Swift, Bad Swift — Part 2](https://medium.com/@ksmandersen/good-swift-bad-swift-part-2-d6daebf53a5)
* 原文作者 : [Kristian Andersen](https://medium.com/@ksmandersen)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Zheaoli](https://github.com/Zheaoli)
* 校对者: [owenlyn](https://github.com/owenlyn), [yifili09](https://github.com/yifili09)

# 好的与坏的，Swift 语言面面观（二）


不久之前，在我写的[好与坏，Swift面面观 Part1](http://gold.xitu.io/entry/578c647a6be3ff006ce49e91)一文中，我介绍了一些关于在 **Swift** 里怎样去写出优秀代码的小技巧。在 **Swift** 发布到现在的两年里，我花费了很长时间去牢牢掌握最佳的实践方法。欲知详情，请看这篇文章：[好与坏，Swift面面观 Part1](https://medium.com/@ksmandersen/good-swift-bad-swift-part-1-f58f71da3575).

在这个系列的文章中，我将尝试提炼出我认为的 **Swift** 语言中好与不好的部分。唔，我也希望在未来有优秀的 **Swift** 来帮助我征服 **Swift** （唔，小伙子，别看了，中央已经决定是你了，快念两句诗吧）。如果你有什么想法，或者想告诉我一点作为开发者的人生经验什么的话，请在 Twitter 上联系我，我的账号是 [ksmandersen](http://twitter.com/ksmandersen)。

好了废话不多说，让我们开始今天的课程吧。


### `guard` 大法好，入 `guard` 保平安

在 **Swift 2.0** 中， **Swift** 新增了一组让开发者有点陌生的的特性。`Guard` 语句在进行[防御性编程](https://en.wikipedia.org/wiki/Defensive_programming)的时候将会起到不小的作用。（译者注1：防御性编程（Defensive programming）是防御式设计的一种具体体现，它是为了保证，对程序的不可预见的使用，不会造成程序功能上的损坏。它可以被看作是为了减少或消除墨菲定律效力的想法。防御式编程主要用于可能被滥用，恶作剧或无意地造成灾难性影响的程序上。来源自wiki百科）。每个 **Objective-C** 开发者可能对防御性编程都不陌生。通过使用这种技术，你可以预先确定你的代码在处理不可预期的输入数据时，不会发生异常。

`Guard` 语句允许你为接下来的代码设定一些条件和规则，当然你也必须钦定当这些条件（或规则）不被满足时要怎么处理。另外，`guard` 语句必须要返回一个值。在早期的 **Swift** 编程中，你可能会使用 `if-else` 语句来对这些情况进行预先处理。但是如果你使用 `guard` 语句的话，编译器会在你没有考虑到某些情况下时帮你对异常数据进行处理。

接下来的例子有点长，但是这是一个非常好的关于 `guard` 作用的实例。 `didPressLogIn` 函数在屏幕上的 `button` 被点击时被调用。我们期望这个函数被调用时，如果程序产生了额外的请求时，不会产生额外的日志。因此，我们需要提前对代码进行一些处理。然后我们需要对日志进行验证。如果这个日志不是我们所需要的，那么我们不在需要发送这段日志。但是更为重要的是，我们需要返回一段可执行语句来确保我们不会发送这段日志。`guard` 将会在我们忘记返回的时候抛出异常。

~~~Swift
    @objc func didPressLogIn(sender: AnyObject?) {
            guard !isPerformingLogIn else { return }
            isPerformingLogIn = true

            let email = contentView.formView.emailField.text
            let password = contentView.formView.passwordField.text

            guard validateAndShowError(email, password: password) else {
                isPerformingLogIn = false
                return
            }

            sendLogInRequest(ail, password: password)
    }
~~~

当 `let` 和 `guard` 配合使用的时候将会有奇效。下面这个例子中，我们将把请求的结果绑定到一个变量 `user` ，之后通过 `finishSignUp` 方法函数使用(这个变量)。如果 `result.okValue` 为空，那么 `guard` 将会产生作用，如果不为空的话，那么这个值将对 `user` 进行赋值。我们通过利用 `where` 来对 `guard` 进行限制。

~~~Swift
    currentRequest?.getValue { [weak self] result in
      guard let user = result.okValue where result.errorValue == nil else {
        self?.showRequestError(result.errorValue)
        self?.isPerformingSignUp = false
        return
      }

      self?.finishSignUp(user)
    }
~~~

讲道理 `guard` 非常的强大。唔，如果你还没有使用的话，那么你真应该慎重考虑下了。

### 在使用 `subviews` 的时候，将声明和配置同时进行。

如前面一系列文章中所提到的，开发 `viwe` 的时候，我比较习惯于用代码生成。因为对 `view` 的配置套路很熟悉，所以在出现布局问题或者配置不当等问题时，我总是能很快的定位出错的地方。

在开发过程中，我发现将不同的配置过程放在一起非常的重要。在我早期的 **Swift** 编程经历中，我通常会声明一个 `configureView` 函数，然后在初始化时将配置过程放在这里。但是在 **Swift** 中我们可以利用 **属性声明代码块** 来配置 `view` （其实我也不知道这玩意儿怎么称呼啦（逃）。

唔，下面这个例子里，有一个包含两个 `subviews` 、 `bestTitleLabel` 、 和 `otherTitleLabel` 的 `AwesomeView` 视图。两个 `subviews` 都在一个地方进行配置。我们将配置过程都整合在 `configureView` 方法中。因此，如果我想去改变一个 `label` 的 `textColor` 属性，我很清楚的知道到哪里去进行修改。

~~~Swift
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
~~~

对于上面的代码，我很不喜欢的就是在声明 `label` 时所带的类型标签，然后在代码块里进行初始化并返回值。通过使用[Then](https://github.com/devxoul/Then)这个库，我们可以进行一点微小的改进。你可以利用这个小函数去在你的项目里将代码块与对象的声明进行关联。这样可以减少重复声明。
~~~Swift
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
~~~


### 通过不同访问级别来对类成员进行分类。

唔，对我来讲，最近发生的一件比较重要的事儿就是，我利用一种比较特殊的方法来将类和结构体的成员结合在一起。这是我之前在利用 **Objective-C** 进行开发的时候养成的习惯。我通常将私有方法放置在最下面，然后公共及初始化方法放在中间。然后将属性按照公共属性到私有属性的顺序放置在代码上层。唔，你可以按照下面的结构在组织你的代码。

*   公共属性
*   内联属性
*   私有属性
*   初始化容器
*   公共方法
*   内联方法
*   私有方法

你也可以按照静态/类属性/固定值的方式进行排序。可能不同的人会在此基础上补充一些不同的东西。不过对于我来讲，我无时不刻都在按照上面的方法进行编程。

好了，本期节目就到此结束。如果你有什么好的想法，或者什么想说的话，欢迎通过屏幕下方的联系方式联系我。当然欢迎通过这样的[方式](http://twitter.com/ksmandersen)丢硬币丢香蕉打赏并订阅我的文章（大雾）。

下期预告：将继续讲诉 **Swift** 里的点点滴滴，不要走开，下期更精彩 。
