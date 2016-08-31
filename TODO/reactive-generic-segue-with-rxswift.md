> * 原文地址：[iOS: Let’s create Reactive Generic Segue with RxSwift](https://medium.com/@SergDort/reactive-generic-segue-with-rxswift-e20a5219aeea)
* 原文作者：[Serg Dort](https://medium.com/@SergDort)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


Personaly I like the idea behind [UIStoryboardSegue](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIStoryboardSegue_Class/) of decomposition navigation logic from your business logic routine.

But I’m not a fun of using it with storyboard and I’ve never created them programmatically.

So decided to adopt it feature and create something similar.

But what fields this type should have?

It definitely should have

     let fromViewController:UIViewController 

Most of us passing some context (or not) which we want to display on the next ViewController.

Because swift have such a cool feature called Generics lets take advantage of this and make our context to be a generic type _T_

Also, we some how need to create _toViewController_ object. I decided to do this with block, lets call it

let toViewControllerFactory:(context:T) -> UIViewController

And now we ready to implement “reactive” part of our segues =)

There are two things that segue could do — it could push new viewController or present it modally.

    private(set) lazy var pushObserver:AnyObserver

    private(set) lazy var presentObserver:AnyObserver

So lets implement these observers

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

Note: If you don’t want to pass the context within segue just create it with Void type

    lazy var segue:Segue 

And now we can user our Segue some thing like this:

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

What it gives? It separate your navigation logic, and also this class could be easily covered with unit test.

Ideas, remarks? Will be happy to discuss in comments ;)





