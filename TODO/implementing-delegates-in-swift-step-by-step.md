> * 原文地址：[Implementing delegates in Swift, step by step](https://medium.com/@jamesrochabrun/implementing-delegates-in-swift-step-by-step-d3211cbac3ef#.er1y3jh2l)
* 原文作者：[James Rochabrun](https://medium.com/@jamesrochabrun)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [Gocy](https://github.com/Gocy015)
* 校对者：[skyar2009](https://github.com/skyar2009) ,[thanksdanny](https://github.com/thanksdanny)


# 手把手带你在 Swift 中应用代理（Delegate）

![](https://cdn-images-1.medium.com/max/800/1*q9CR-wzFHkccp7I761piVw.png)

什么是代理呢？在软件开发中，存在许多用于解决特定场景中的普遍问题的通用方案架构，这些所谓的“模板”，常被称为设计模式。

代理就是一种设计模式，它允许某个对象在特定事件发生时，向另一个对象发送消息。

试想对象 A 调用对象 B 来执行某项操作。该操作完成后，对象 A 理应感知到对象 B 已经完成了任务以便采取后续的其它必要操作，而代理模式便能帮助我们完成这样的要求！

![](https://cdn-images-1.medium.com/max/800/0*l4JyFlg2IPKL6lSr.jpg)

为了更好地理解这个概念，我将用 Swift 写一个简单地应用来向你展示如何创建一个自定义代理来在类之间传递数据，首先，下载或 clone [初始项目](https://github.com/jamesrochabrun/DelegateTutorial) 并运行看看吧！

![](https://cdn-images-1.medium.com/max/800/0*mTYwNIwVsFUlDwuI.gif)

你可以看到项目中有两个类，ViewController A 和 ViewController B。B 有两个视图，被点击时会修改 ViewController 的背景颜色，没什么复杂的概念，对吧？现在我们要想一个简单办法，来让类 A 的背景颜色也随着类 B 中的视图点击变化。

![](https://cdn-images-1.medium.com/max/800/0*mLo9CmQAdhGb_l60.png)

问题在于，这些视图是类 B 的一部分，并不能感知到类 A，所以我们要想办法使两个类建立起联系，这便是代理大展身手的地方。

我将实现过程分为了六个步骤，当你需要实现代理时可以依此作为参考。

第一步：在 ClassBVC 文件中找到 step 1 的注释，并添加如下代码

```
//MARK: step 1 Add Protocol here.

protocol ClassBVCDelegate: class {

func changeBackgroundColor(_ color: UIColor?)

}

```

首先我们需要创建一个协议（protocol），本例中，我们将在类 B 中创建这个协议，你可以根据实际需要来向协议中添加任意数量的方法。本例只添加了一个接收可选的 UIColor 实例（optional UIColor）为参数的简单方法。

**在类名末尾添加 Delegate 并将其作为你的协议的名称是一个良好的习惯，本例中就是 ClassBVCDelegate。**

第二步：在 ClassBVC 文件中找到 step 2 的注释，并添加如下代码

```
//MARK: step 2 Create a delegate property here.
weak var delegate: ClassBVCDelegate?

```

这里我们仅仅是为类添加了一个 delegate 属性，该属性必须遵循对应的协议，同时其应该被定义为可选的。同时，在声明属性时添加 weak 关键字来避免循环引用以及可能出现的内存泄露，如果你现在还不了解这是什么意思，也没关系，记着要加上这个关键字即可。

第三步：在 ClassBVC 文件中的 handleTap 方法中找到 step 3 的注释，并添加如下代码

```
//MARK: step 3 Add the delegate method call here.
delegate?.changeBackgroundColor(tapGesture.view?.backgroundColor)

```

你需要注意一件事，如果你现在运行程序，不论你点击哪个视图都不会看到有任何新增的表现，这是正常的，我想特别说明的是，尽管此时 delegate 属性仍未被赋值，但我们访问它的时候应用并没有崩溃，这正是因为我们将其定义为了可选类型。现在让我们把视线移动到 ClassAVC 文件中，并将其实现为代理。

第四步：在 ClassAVC 文件中找到 step 4 的注释，在类的类型后添加如下代码

```
//MARK: step 4 conform the protocol here.
class ClassAVC: UIViewController, ClassBVCDelegate {

```

现在 ClassAVC 便遵循了 ClassBVCDelegate 协议，你会发现编译器已经给了你一个“Type ‘ClassAVC does not conform to protocol ‘ClassBVCDelegate’”的错误了，这不过是因为你还没有实现协议中所规定的方法而已，类 A 遵循该协议时就像是和类 B 签下了一纸合约，合约规定“任何遵循该协议的类都 **必须** 实现规定的方法！”

![](https://cdn-images-1.medium.com/max/800/0*0nAPyS5dneFZqjtm.jpg)

**注意：如果你有一定的 Objective-C 开发经验，你或许认为将该协议方法标记为可选就能消除这个错误了，但出乎我意料的是（或许你也感到惊讶），Swift 中并没有可选协议方法的概念。**

第五步：在 prepare for segue 方法中找到 step 5 的注释，并添加

```
//MARK: step 5 create a reference of Class B and bind them through the prepareforsegue method.
if let nav = segue.destination as? UINavigationController, let classBVC = nav.topViewController as? ClassBVC {
classBVC.delegate = self
}

```

此处我们创建了一个 ClassBVC 的实例，并将 self 赋值给其 delegate 属性，self 是什么呢？self 就是实现了代理协议的 ClassAVC 实例！

第六步：最终，在 ClassAVC 中找到 step 6 的注释，实现协议中的方法。当你着手输入 func changeBackgroundColor 的时候，会发现编译器会出现相应的自动补全。在方法中你可以添加对应的实现，而本例中，我们仅仅是改变背景颜色，因此添加如下代码。

```
//MARK: step 6 finally use the method of the contract
func changeBackgroundColor(_ color: UIColor?) {
view.backgroundColor = color
}

```

现在，运行程序吧！

![](https://cdn-images-1.medium.com/max/800/0*ME6nP1z13pvMyLep.gif)

代理无处不在，你或许正在使用却毫无察觉，如果你曾经使用过 table view，那么你就用过代理模式，许多 UIKIT 和各种框架中的类都围绕着代理做文章，而代理主要解决了以下几个问题。

- 避免了对象之间的强耦合。
- 无需继承便可改变对象的行为和外观。
- 使任务可以交付给任意对象。（译者注：即抽象，无需依赖于具体类型）

恭喜，你刚刚动手实现了一个自定义代理，我知道或许此时你想着的是，这么大费周折就为了实现这点事情？呃，如果你想成为一个 iOS 开发者，那么理解代理这种设计模式至关重要，你要时刻记住，代理模式中对象之间总是一对一关系。

如果你感到疑惑也不必担心，我也花了好些时间才弄明白其中的含义，这甚至是我在上 iOS 培训课时候的重点课题。所以放轻松，慢慢来，如果你想和我讨论讨论，欢迎来 [Twitter](https://twitter.com/roch4brun) 找我。

你可以在 [这里](https://github.com/jamesrochabrun/DelegateTutorialFinal) 找到项目的完整代码。

感谢阅读！
