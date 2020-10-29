> * 原文地址：[UIKit or SwiftUI: Which Should You Use in Production?](https://medium.com/better-programming/uikit-or-swiftui-which-should-you-use-in-production-f57258bc6ad5)
> * 原文作者：[Alexey Naumov](https://medium.com/@nalexn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/uikit-or-swiftui-which-should-you-use-in-production.md](https://github.com/xitu/gold-miner/blob/master/article/2020/uikit-or-swiftui-which-should-you-use-in-production.md)
> * 译者：
> * 校对者：

# UIKit or SwiftUI: Which Should You Use in Production?

![Photo by [Mario Dobelmann](https://unsplash.com/@mariodobelmann?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11516/0*uqSWA_30Auiz_7F4)

Apple has recently released iOS 14, which means SwiftUI already has a required one-year buffer for being adopted not only by enthusiasts in their pet projects but actually by enterprise teams in their business apps.

Literally everyone says writing SwiftUI code is fun, but is SwiftUI a toy or a professional tool? If we want to take it seriously, we need to consider its stability and flexibility as a tool, not as a toy.

When is the right time to start using SwiftUI in the production code?

This question is rather tricky to answer if you’re starting a new major project between 2020 and possibly 2022!

With all the innovation that SwiftUI brought in, even by iOS 14, we [still have bugs and a lack of flexibility for customization](https://steipete.com/posts/state-of-swiftui/).

While this can be mitigated by situationally appealing to UIKit, can you estimate how much code will eventually be written in UIKit? Could SwiftUI become a burden in the long run, where you’d better off just writing everything in UIKit?

We can only bet on iOS 15 to have no issues with SwiftUI. It means that only by 2022 at best (with the release of iOS 16) will we have a perfect moment to relax and fully trust SwiftUI.

In this article, I elaborate on how to structure the project in two scenarios:

1. You’re supporting iOS 11 or 12 but consider migrating the app to SwiftUI in a foreseeable future.
2. You’re supporting iOS 13+ but want to control the risks related to SwiftUI and be able to fall back to UIKit seamlessly.

## Sticky UI Frameworks

Historically, UI frameworks were very central to mobile apps’ architectures. We took UIKit and built everything around it.

Consider your last UIKit project and try to evaluate how much effort it would take to completely get rid of UIKit and replace it with another UI framework, [AsyncDisplayKit](https://github.com/texturegroup/texture/) for example?

For the majority of projects, that would mean a complete rewrite.

Web engineers would laugh at us because they’ve always had an abundance of UI frameworks. So they learned to apply the “dependency rule” and consider UI a peripheral “detail” in the system, just like the concrete type of database they use.

Does it mean that we, the mobile developers, didn’t decouple UI from the business logic? We did, right? MVC, MVVM, VIPER, etc., were there to help us, but we still got trapped.

Mobile apps are seldom responsible for any core business logic, such as calculating interest for a loan and approving it. Businesses want to minimize numerous risks here, so they run such logic on the back end.

Nevertheless, there is a heck of a lot of business logic running on modern mobile apps, but that logic is different. It’s just more focused on the presentation rather than on the core rules the business runs on.

This means we need to do a better job at decoupling that presentation-related business logic from the specifics of the UI framework we’re using.

If we fail to do so, no wonder the framework gets monolithically baked into the code base.

---

APIs of both UIKit and SwiftUI are sticky for the code base. These frameworks are pushing developers to make them super central, tied to everything, used directly in places that are not UI at all!

Let’s take, for example, `@FetchRequest` in SwiftUI. It blends `CoreData` model details right in the presentation layer. It looks convenient. But at the same time, this is a major violation of multiple software design principles and best practices in CS. Such code saves time in the short term but may cause significant harm to the project in the long run.

How about `@AppStorage`? Data IO operations right in the UI layer. How do you test it? Can you easily identify key name collisions in the container? Can you migrate it seamlessly to another data storage type, such as Keychain?

Again, the speed of the development is maximized, with quality assurance, maintainability, and code reuse concern being neglected.

And what about the screen routing?

UIKit always whispered to us: “Pssst! Just use presentViewController(:, animated:, completion:); don't bother with those nasty coordinators!"

SwiftUI, on the other hand, is not whispering. It is screaming at us: “Listen here. You either do it the way I want, or I’ll kill your family in the most elaborate way!” (*)

Is there a way to protect our codebase from these barbarian APIs?

Certainly!

(\*) Screaming APIs are usually a good thing — the programmer has fewer chances of making a mistake. However, such APIs become a huge problem when they don’t work properly, as is the case with SwiftUI’s problematic programmatic navigation, for example.

## Estranging the UI Layer

As you can see, frameworks have traps everywhere.

The more hooks you bite, the harder it will be to step back from using this framework for a specific screen or entire app.

If we want the system to be solid enough to survive the transition from UIKit to SwiftUI (or vice versa) we need to make sure the boundary between UI and the rest of the system is not a wooden fence, but The Great Wall!

Nothing should sneak in, even string formatting.

Are you able to convert a float 5434.35 to “$5,434.35” without UIKit or SwiftUI? Perfect — let’s do it elsewhere!

Does the framework’s API for screen routing impose the view’s tight coupling? We need to introduce a boundary for isolating them.

Not only do we need to extract as much logic as possible from the UI layer, but we also need to make the UIKit component and its SwiftUI counterpart fully compatible with the socket they are plugged into.

How do we bring UIKit and SwiftUI to a common denominator?

We know that SwiftUI is entirely data-driven, powered by reactive data bindings. Fortunately, UIKit can be twisted that way with MVVM and reactive frameworks.

That means data sources, delegates, target actions, and the rest of the UIKit APIs should be isolated in the UI layer.

The line `import UIKit` should not appear in any ViewModel and beyond.

I should note that as long as the UI component is fully data-driven, the exact architecture pattern for the screen module is not important. I’ll be referring to MVVM in this article for ease of example.

Now. Which reactive framework should we use for the ViewModel? We know that SwiftUI works exclusively with [Combine](https://developer.apple.com/documentation/combine), while UIKit is best supported by RxCocoa.

Either way is possible, so this depends on whether you can support iOS 13 (Combine) and how much you love RxSwift.

Let’s consider both!

## Bridge Between RxSwift and SwiftUI

Combine is available from iOS 13, which is a deal-breaker for those who still need to support iOS 11 or 12.

Here I’ll talk about an easy way to migrate (UIKit + RxSwift) to (SwiftUI + RxSwift).

Consider this minimal setup:

```Swift
class HomeViewModel {
    
    let isLoadingData: Driver<Bool>
    let disposeBag = DisposeBag()
    
    func doSomething() { ... }
}

class HomeViewController: UIViewController {
    
    let loadingIndicator: UIActivityIndicatorView!
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .isLoadingData
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    @IBAction func handleButtonPressed() {
        viewModel.doSomething()
    }
}
```

The view is data-driven: the ViewModel fully controls the state changes for the View.

Let’s migrate this screen to SwiftUI without touching ViewModel’s code.

There are two ways we can make it work:

1. Define a new `ObservableObject` with `@Published` variables bound to `Driver` (or `Observable`) from the original ViewModel.
2. Adapt each `Driver` to `Publisher` and bind to `@State` inside the SwiftUI's view.

## Binding Observable to @Published

For the first approach, we’ll need to create a new `ObservableObject` that mirrors every observable variable from the original ViewModel:

```Swift
extension HomeViewModel {
    class Adapter: ObservableObject {
        let viewModel: HomeViewModel
        @Published var isLoadingData = false
    }
}

struct HomeView: View {
    let adapter: HomeViewModel.Adapter
    
    var body: some View {
        if adapter.isLoadingData {
            ProgressView()
        }
        Button("Do something!") {
            self.adapter.viewModel.doSomething()
        }
    }
}
```

The value binding code between the original ViewModel and the adapter should be as concise as possible. Here is how bridging would look in the case of `Driver` and `Observable`:

```Swift
let observable: Observable<Bool> = ...
observable
    .bind(to: self.binder(\.isLoadingData))
    .disposed(by: disposeBag)
    
let driver: Driver<Bool> = ...
driver
    .drive(self.binder(\.name))
    .disposed(by: disposeBag)
```

All we need here is a `Binder` from RxSwift that assigns values to specific `@Published`value. Here is a snippet for the `binder` function that does the bridging:

```Swift
extension ObservableObject {
    func binder<Value>(_ keyPath: WritableKeyPath<Self, Value>) -> Binder<Value> {
        Binder(self) { (object, value) in
            var _object = object
            _object[keyPath: keyPath] = value
        }
    }
}
```

Going back to our ViewModel, you can do the binding right in the `Adapter` initialization:

```Swift
extension HomeViewModel {

    class Adapter: ObservableObject {
    
        let viewModel: HomeViewModel
        private let disposeBag = DisposeBag()
        
        @Published var isLoadingData = false
        
        init(viewModel: HomeViewModel) {
            self.viewModel = viewModel
            viewModel.isLoadingData
                .drive(self.binder(\.isLoadingData))
                .disposed(by: self.disposeBag)
        }
    }
}
```

A disadvantage of this approach is the boilerplate code that has to be repeated for every `@Published` variable you have.

---

## Binding Observable to @State

This second approach requires much less setup code and is based on another way SwiftUI views can consume external state: `onReceive` view modifier with assigning values to local `@State`.

The beauty here is that we can use the original ViewModel directly in the SwiftUI view:

```Swift
struct HomeView: View {

    let viewModel: HomeViewModel
    @State var isLoadingData = false
    
    var body: some View {
        if isLoadingData {
            ProgressView()
        }
        Button("Do something!") {
            self.viewModel.doSomething()
        }
        .onReceive(viewModel.isLoadingData.publisher) {
            self.isLoadingData = $0
        }
    }
}
```

The `viewModel.isLoadingData` is a `Driver`, so we need to convert it to a `Publisher` from Combine.

The community has already come up with [RxCombine](https://github.com/CombineCommunity/RxCombine) library that allows for bridging from `Observable` to `Publisher`, so extending it to support `Driver` is straightforward:

```Swift
import RxCombine
import RxCocoa

extension Driver {
    var publisher: AnyPublisher<Element, Never> {
        return self.asObservable()
            .publisher
            .catch { _ in Empty<Element, Never>() }
            .eraseToAnyPublisher()
    }
}
```

## Connecting UIKit With Combine

If you have the luxury of supporting iOS 13+, you can consider using Combine for building the networking and other non-UI modules in the app.

Even though binding Combine with UIKit is somewhat inconvenient, choosing Combine as the core framework driving data in your application should pay off in the long run, when your project fully migrates to SwiftUI.

In the meanwhile, you can either update the UIKit view inside the `sink` function:

```Swift
viewModel.$userName
    .sink { [weak self] name in
        self?.nameLabel.text = name
    }
    .store(in: &cancelBag)
```

Or you can use the aforementioned RxCombine library to convert `Publisher` to `Observable`, taking full advantage of data bindings available in RxCocoa:

```Swift
viewModel.$userName // Publisher
    .asObservable() // Observable
    .bind(to: nameLabel.rx.text) // RxCocoa binding
    .disposed(by: disposeBag)
```

I should note that if we choose Combine as the main reactive framework in the app, the use of RxSwift, RxCocoa, and RxCombine should be limited to only data bindings to the UIKit views, so we could easily get rid of these dependencies along with the last UIKit view in the app.

The ViewModel, in this case, should be built with just Combine (no `import RxSwift`!).

Revisiting the original example:

```Swift
class HomeViewModel: ObservableObject {

    @Published var isLoadingData = false
    func doSomething() { ... }
}

class HomeViewController: UIViewController {
    
    let loadingIndicator: UIActivityIndicatorView!
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .$isLoadingData // obtaining Publisher
            .asObservable() // converting to Observable
            .bind(to: loadingIndicator.rx.isAnimating) // RxCocoa binding
            .disposed(by: disposeBag)
    }
    
    @IBAction func handleButtonPressed() {
        viewModel.doSomething()
    }
}
```

And when it’s time to rebuild this screen in SwiftUI, everything will be set up for you: Nothing has to be changed in ViewModel.

## Thoughts About Routing

In the past, I’ve explored how [programmatic navigation](https://nalexn.github.io/swiftui-deep-linking/) works in SwiftUI, and from my experience, this is the part of SwiftUI that still suffers from all kinds of glitches and crashes and lacks animation customization.

As time passes, this will be fixed for sure, but as of now, I wouldn’t trust SwiftUI with routing.

There is not much that we lose when opting out of SwiftUI’s routing. As long as SwiftUI is backed by UIKit, there will be no positive performance difference compared to what we can achieve with UIKit.

In the sample project I built for this article, I used the traditional Coordinator pattern (MVVM-R) that worked just fine for screens built with `UIHostingController` from SwiftUI.

## Conclusion

If we want to control the risks related to using a specific UI framework, we should put additional effort into controlling its expansion in the codebase.

Existing problems with SwiftUI should not stop you from at least preparing your project for migration to this framework in a foreseeable future.

Extract as much business logic as possible from the UI layer and make your UIKit screens data-driven. This way it’ll be a breeze to migrate to SwiftUI.

I’ve built a [sample project](https://github.com/nalexn/uikit-swiftui) with ordinary login/home/details screens that illustrate how UIKit and SwiftUI views can become a peripheral dummy detail that you can easily detach and replace.

There are two targets — one runs on UIKit, the other on SwiftUI, while both share the essential part of the code base.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
