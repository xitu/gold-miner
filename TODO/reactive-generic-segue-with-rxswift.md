> * 原文地址：[iOS: Let’s create Reactive Generic Segue with RxSwift](https://medium.com/@SergDort/reactive-generic-segue-with-rxswift-e20a5219aeea)
* 原文作者：[Serg Dort](https://medium.com/@SergDort)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[mypchas6fans] (https://github.com/mypchas6fans)
* 校对者：[yifili09] (https://github.com/yifili09) [siegeout] (https://github.com/siegeout)

# 用 RxSwift 实现通用的响应式转场

个人而言，我喜欢 [UIStoryboardSegue](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIStoryboardSegue_Class/) 这个类背后的思路，把导航逻辑从业务逻辑程序中分离出来。

但是我并不推崇通过 storyboard 来实现这个方法，并且我也从来没有在代码中实现过。

所以我决定吸取上文的思想，自己做一个类似的东西。

但是这个类型应该有哪些域呢？

当然必须要有

     let fromViewController:UIViewController 

很多人会把想要显示的 context 传递给下一个 ViewController。

因为 Swift 有一个很酷的功能叫泛型，我们可以利用它把 context 变成通用类型 _T_

同时，我们还需要创建 _toViewController_ 对象，我决定用 block 来做

let toViewControllerFactory:(context:T) -> UIViewController

现在我们可以实现转场的“响应式”部分了 =)

转场可以做两件事—— push 新的 viewController ，或者以模式方式显示。

    private(set) lazy var pushObserver:AnyObserver

    private(set) lazy var presentObserver:AnyObserver

我们来实现这些 observers

    import UIKit
    import RxSwift

    class Segue {

       private(set) weak var fromViewController:UIViewController?
       let toViewControllerFactory:(context:T) -> UIViewController

       init(fromViewController:UIViewController,
          toViewControllerFactory:(context:T) -> UIViewController) {
             self.fromViewController = fromViewController
             self.toViewControllerFactory = toViewControllerFactory
       }

       private(set) lazy var pushObserver:AnyObserver = AnyObserver {[weak self] event in
          switch event {
          case .Next(let value):
             guard let strong = self else {return}
             let toViewController = strong.toViewControllerFactory(context: value)
             strong.fromViewController?.navigationController?
                .pushViewController(toViewController, animated:true)
          default:
             break
          }
       }

       private(set) lazy var presentObserver:AnyObserver = AnyObserver {[weak self] event in
          switch event {
          case .Next(let value):
             guard let strong = self else {return}
             let toViewController = strong.toViewControllerFactory(context: value)
             strong.fromViewController?.presentViewController(toViewController, animated: true, completion: nil)
          default:
             break
          }
       }

    }

注意：如果你不想在转场中传递 context ，需要把它创建成 Void 类型

    lazy var segue:Segue 

现在我们可以这样使用转场了：

    import RxSwift
    import RxCocoa

    class SomeTableViewController:UITableViewController {
      let disposeBag = DisposeBag()
      let items:[Item] ...

      lazy var itemDetailsSegue:Segue = {
          return Segue(fromViewController: self,
                  toViewControllerFactory: { context -> UIViewController in
                      return ItemDetailsViewController(item:context)
                  })
      }

        lazy var voidModalSegue:Segue = {
          return Segue(fromViewController: self,
                  toViewControllerFactory: { _ -> UIViewController in
                      return SomeViewController()
                  })
      }

        override func viewDidLoad() {
          super.viewDidLoad()

          someButton.rx_tap
                .bindTo(voidModalSegue.presentObserver)
                .addDisposableTo(disposeBag)

          tableView.rx_itemSelected
                .map({[unowned self] indexPath in self.items.[indexPath.row]})
                .bindTo(itemDetailsSegue.pushObserver)
                .addDisposableTo(disposeBag)
        }

    }

结果如何？导航逻辑被分离出来了，而且这个类很容易进行单元测试。

大家有什么想法评论，欢迎留言讨论 :)





