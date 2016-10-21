> * 原文链接 : [Building iOS Apps with Xamarin and Visual Studio](https://www.raywenderlich.com/134049/building-ios-apps-with-xamarin-and-visual-studio)
> * 原文作者 : [Bill Morefield](https://www.raywenderlich.com/u/bmorefield)
> * 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者 : [Nicolas(Yifei) Li](https://github.com/yifili09) 
> * 校对者: [Gran](https://github.com/Graning), [Jasper Zhong (DeadLion)](https://github.com/DeadLion)

# 用 Xamarin 和 Visual Studio 构建 iOS 应用

![](https://cdn4.raywenderlich.com/wp-content/uploads/2016/07/VisualStudioXamarin-Feature-250x250.png)

当创见一个 `iOS` 的应用程序的时候，开发者们一贯倾向于使用那些由 `Apple` 公司提供的编程语言和 `IDE`: `Objective-C` / `Swift` 和 `Xcode`。然而，这并不是唯一的选择 - 你还可以通过使用很多其他的编程语言和框架去创建一个 `iOS` 应用程序。

[Xamarin](https://xamarin.com) 是最热门的选择方式之一，它是一个跨平台的开发框架，允许你使用 `C#` 和 `Visual Studio` 开发 `iOS`, `Android`, `OS X` 和 `Windows` 应用程序。`Xamarin` 最主要的好处是，它能让你在 `iOS` 和 `Android` 应用程序（平台）共享你的代码。

`Xamarin` 相比其他跨平台的框架还有一个很大的优势: （若）使用 `Xamarin`，你的项目会编译成原生代码，并且在底层使用原生的 `APIs`。这意味着用 `Xamarin` 框架写的应用程序和用 `Xcode` 创建出的应用程序几乎无差别。查看 [Xamarin 与 Native 应用程序开发](http://willowtreeapps.com/blog/xamarin-vs-native-app-development/) 了解更多细节。 

过去，`Xamarin` 也有一个很大的缺点: 它的价格。因为每个平台每年的起步价格是 `$ 1,000（美元）`，你只能放弃你每天一杯的拿铁咖啡或者卡布奇诺，甚至_考虑_你能否承受这个价格......并且在编程的时候没有咖啡会是很危险的。因为这个（高昂的）起步价格，`Xamarin` 吸引的主要是那些有着很多预算的企业级项目。

然而，最近这个情况已经改变了，当 `微软` 收购了 `Xamarin` 并且发表声明，它将被包含进全新的 `Visual Studio` 中，包含进 [免费的社区版本](https://www.visualstudio.com/en-us/products/visual-studio-community-vs.aspx)，它能被个人开发者和小团体(免费)获取。

免费？这个价格值得我们去庆祝一下了！

[![More money for coffee!](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/dollar-941246_1280-427x320.jpg)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/dollar-941246_1280.jpg)

有更多买咖啡的钱了！



除了价格（或者漏掉的其他原因），`Xamarin` 还有其他优点，包括允许程序员:

* 利用现存的 `C#` 库和工具去创建移动应用程序。
* 在不同平台上复用代码。
* 在 `ASP.Net` 后端和面向用户的应用程序之间分享代码。

`Xamarin` 也提供了一系列的工具，取决与你的需求。为了最大化的跨平台代码复用，使用 [Xamarin 表单](https://www.xamarin.com/forms)。它对那些不需要平台特定的功能或者特别的用户自定义的接口的应用程序特别好用。

如果你的应用程序（依赖于）需要平台特定的功能或者设计，使用 [`Xamarin.iOS`](https://developer.xamarin.com/guides/ios/), [`Xamarin.Android`](https://developer.xamarin.com/guides/android) 和其他的平台特定的模块，去直接与原生 `APIs` 和框架进行交互。这些工具能提供最大限度的灵活度，来创建高度定制的用户接口，当然仍旧允许跨平台地共享通用的代码。

在这份指南中，你将使用 `_Xamarin.iOS_` 去创建一个 `iPhone` 应用程序，它展示了一个用户的照片库。

这份指南不需要任何有关 `iOS` 或者 `Xamarin` 开发的经验，但是为了明白其中的大部分内容，你将需要对 `C#` 有一个基本的认识。

## 开始

为了开发一个使用 `Xamarin` 和 `Visual Studio` 的 `iOS` 应用程序，理论上你需要两台计算机:

1. 使用_一台 `Windows` 计算机_去运行 `Visual Stuido` 并且编写你的工程代码 
2. 使用_一台 装有 `Xcode` 的 `Mac` 计算机_作为一个构建代码的主机。这台计算机不必专门用来构建，但是开发和测试期间，需要和你的 `Windows` 计算机网络互通。

如果你那两个计算机互相之间离得很近是很棒的，因为当你构建代码并且在 `Windows` 上运行， `iOS` 模拟器将在你的 `Mac` 上加载。

你们可能会说，"如果我没有同时拥有两个计算机怎么办？"

* _对于只有 `Mac` 的用户_，`Xamarin` 确实提供了一个给 `OS X` 用的 `IDE`，但是我们今天的指南将只关注这个崭新的 `Visual Studio` 支持。所以如果你还想继续的话，你可以在运行在 `Mac` 上的虚拟机运行 `Windows`。很多工具，例如 [VMWare Fusion](https://www.vmware.com/products/fusion) 或者免费的，开源软件 [VirtualBox](https://www.virtualbox.org/) 对于一个只使用单独一个计算机的用户来说都是有效的方法。

    如果你使用了 `Windows` 的虚拟机，你需要确认 `Windows` 有网络连接能访问到你的 `Mac`。总之，如果你能从 `Windows` 上 `ping` 到你的 `Mac` 的 `IP` 地址，那么你一点问题都没有。

* _对于只有 `Windows` 的用户_，请速度购买一台 `Mac`。我会等你！ :] 如果不行，虚拟主机服务，例如 [MacinCloud](http://www.macincloud.com/) 或者 [Macminicolo](https://macminicolo.net) 提供了远程 `Mac` 访问和构建代码。

这个指南假设你正在使用一个单独的 `Mac` 和 `Windows` 计算机，但是不用担心 - 这些说明几乎与如果你在你的 `Mac` 上使用 `Windows` 的虚拟机一样。

### 安装 `Xcode` 和 `Xamarin`

如果你还没有它，[下载并且安装 `Xcode`](https://itunes.apple.com/us/app/xcode/id497799835) 在你的 `Mac`。这和从 `App Stroe` 安装其他应用程序一样，但是因为有几个 GB 的数据，可能需要下载一段时间。

[![Installing Xcode? Perfect time for a cookie break!](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/danish-butter-cookies-1032894_1280-480x270.jpg)](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/danish-butter-cookies-1032894_1280.jpg)

刚好茶歇时间到！


在安装了 `Xcode` 后，[下载 `Xamarin Studio`](https://www.xamarin.com/download) 到你的 `Mac` 上。你需要提供你的 `email`，但是下载是免费的。可选的: 开心吧，跳个舞吧，你那些买咖啡的钱能省下了。 

一旦下载完成，_打开安装包_并且双击_安装 `Xamarin.app`_。接受条款和条件并且继续。

安装器会搜索已经安装的工具并检查目前平台的版本。它之后将为你显示开发环境的列表。确认 _`Xamarin.iOS`_ 完成检查，之后点击_继续_。

![Xamarin Installer](https://cdn1.raywenderlich.com/wp-content/uploads/2016/05/xamarin-installer.png)

之后，你会看到确认列表，总结所有会安装的项目。点击_继续_执行。你将得到一份总结并且一个可选项启动 `Xamarin Studio`。相反，点击_退出_完成安装。

### 安装 `Visual Studio` 和 `Xamarin`

对于这份指南，你能使用任何版本的 `Visual Studio`，包括 [免费的社区版本](https://www.visualstudio.com/en-us/products/visual-studio-community-vs.aspx)。有些特性在社区版本里是 [没有的](https://www.visualstudio.com/products/compare-visual-studio-2015-products-vs)，但是任何都没法阻止你开发复杂的应用程序。

你的 `Windows` 计算机应当满足 [`Visual Studio` 最低需求](https://www.visualstudio.com/en-us/downloads/visual-studio-2015-system-requirements-vs.aspx#1)。为了享受一个流畅的开发环境，你需要至少 `3 GB` 的内存空间。

如果你还没有安装 `Visual Studio`，通过点击在 [社区版本官方网站](https://www.visualstudio.com/en-us/products/visual-studio-community-vs.aspx) 上的绿色按钮_下载社区2015_下载社区版本安装器。

运行安装器开始安装过程，选择_自定义_安装选项。在特性列表中，展开_跨平台移动程序开发_，并选择 _`C#/.Net (Xamarin v4.0.3)`_ (`v4.0.3` 是这篇文章写作的时候，目前最新的版本，但是未来可能会不同。)

![vs-installer](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/vs-installer-354x500.png)

点击_下一步_并等待安装完成。将会需要等待一段时间；当安装 `Xcode` 的时候，你可以去散个步，把你吃掉的曲奇饼干的热量燃烧掉。：]

如果你已经安装了 `Visual Studio` 但是没有 `Xamarin` 工具，移动到你的 `Windows` 计算机上的_项目和特性_并且找到 _`Visual Studio 2015`_。选择它，点击_更改_去访问它的设置，之后选择_修改_。

你将会发现 `Xamarin` 在_跨平台移动程序开发_作为_`C#/.NET (Xamarin v4.0.3)`_。选择他并且点击_更新_来安装。

哟 - 实在有太多需要安装的了，但是你已经有你所需要的东西了。

![Install_Powers](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Install_Powers.png)

## 创建应用程序

打开 `Visual Studio` 并且选择_`文件\新建\项目`_。在 `Visual C#` 下展开 _`iOS`_，选择 _`iPhone`_ 并且勾选_`单一视图应用程序`_（开发）模板。这个（开发）模板创建了一个单一视图控制器的应用程序，它是一个简单的，管理单一视图的 _`iOS`_ 应用程序。

![NewProject](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/NewProject-461x320.png)

为_`项目名字`_和_`解决方案名字`_，都输入 _`ImageLocation`_ 。选择一个存储你应用程序文件的地址，并且点击 _`OK`_ 去创建这个项目工程。 

`Visual Studio` 会提示你，去把你的 `Mac` 计算机设定成 `Xamarin` 的构建主机:

1. 在 `Mac` 上，打开_系统偏好_并且选择_共享_。
2. 打开_远程登录_。
3. 将_允许所有访问_改成_只允许这些用户_，并且增加一个在 `Mac` 上可以访问 `Xamarin` 和 `Xcode` 的用户。
    ![Setup Mac as Build Host](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/build-host-setup-629x500.png)
4. 关闭说明并回到你的 `Windows` 计算机。

回到 `Visual Studio`，你将被要求去选择 `Mac` 作为构建主机。选择你的 `Mac` 并点击_连接_。输入用户名和密码，之后点击_登录_。

你能从工具栏上确认你是否已经连接上。

[![Connected_Indicator](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Connected_Indicator-480x68.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Connected_Indicator.png)

从平台解决方案下拉框中选择 _`iPhone 模拟器`_ - 这将自动从构建主机中选择一个模拟器。你也能通过点击目前模拟器设备上的小箭头改变设备模拟器。 

[![Change_Simulator](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Change_Simulator-1.png)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Change_Simulator-1.png)

通过绿色的_调试_箭头或者快捷键 _`F5`_ 构建和运行工程。

[![Build_and_Run](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Build_and_Run.png)](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Build_and_Run.png)

你的应用程序将被编译和执行，但是你看不到它在 `Windows` 上运行。反而，在 `Mac` 上会看到它在运行。这就是为什么需要两台计算机在一起的原因了。

在最近的 [发展例会](https://evolve.xamarin.com) 上，`Xamarin` 已揭晓了（新特性） [iOS 模拟器的远程控制](https://blog.xamarin.com/live-from-evolve-new-xamarin-previews/)，它能让你和运行在 `Apple`　计算机中模拟器的应用进行远程交互，就好像模拟器是安装在你的 `Windows` 计算机上一样。然而，就目前来说，你需要使用你 `Mac` 计算机上的模拟器。

你将看到一个启动画面出现在模拟器上，之后一个出现一个空的视图。恭喜！你的 `Xamarin` 配置完毕了！

[![Template App](https://cdn1.raywenderlich.com/wp-content/uploads/2016/05/template-app-running-1-272x500.png)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/05/template-app-running-1-272x500.png)

可以通过_红色的停止按钮_来停止应用程序（快捷键是 _`Shift + F5`_）。

## 创建集合视图

这个应用程序会在集合视图中显示用户照片库的缩略图，它是一个 `iOS` 的控制器，用于显示在网格中显示很多内容。

为了修改应用程序的 `storyboard`，它包含了应用程序的 `scenes`，从 _`Solution Explorer`_ 中打开_`Main.storyboard`_。

[![](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Main_Storyboard-269x320.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Main_Storyboard.png)

打开 _`Toolbox`_ 并且输入 _`collection`_ 到文本框内，去过滤出项目列表。在 _`Collection Views`_ 选项，把 _`Collection View`_对象从 _`Toolbox`_ 拖入到空视图的中间。

[![Add Collection View](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Drag_Collection_View-650x456.png)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Drag_Collection_View.png)

选择集合视图；你将在视图的每一边看到一些 _空心圈_。如果你在每一边看到 _`T 型`_，再次点击它，并切换到_`圈`_的样式。

[![Resizing the Collection View](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/resize-collection-view-521x500.gif)](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/resize-collection-view-521x500.gif)

点击并且拖动每一个圈到视图的边界直到出现蓝色的线。当你放开鼠标按钮的时候，边界应该和这个地方重合。

现在你将对集合视图设置自动布局的限制条件；这告诉了应用程序，当设备旋转的时候，视图应该怎么调整大小。

[![Add_Constraints](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Add_Constraints-650x112.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Add_Constraints.png)

这个创建的限制条件几乎都是正确的，但是你将需要修改其中的一些。在 _`Properties`_ 窗口，切换到 _`Layout`_ 页面并且下滑到 _`Constraints`_ 选项。

两个来自于边界的限制条件都是正确的，但是高度和宽度的限制条件是不正确的。通过点击 _`X`_ 来删除_`宽度`_和_`高度`_的限制条件。

[![Delete Constraints](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Delete_Constraints-304x500.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Delete_Constraints.png)

关注到集合视图是如何变化到橙色的。这是限制条件需要被修正的信号。

点击集合视图并选择它。如果你看到了之前的圈，再次点击去让图标变成绿色的 _`T 型`_。点击并将在集合视图_最上边界_的 `T` 拖动到 绿色_`最上布局指导`_。释放它去创建一个相对最上视图的限制条件。

最后，点击并拖动这个 `T` 到集合视图_最左边_直到你看到一个_蓝色的点状线_。释放它并创建一个相对视图左边边界的限制条件。

在这点，你的限制条件会像这样:

![Constraints](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Constraints.png)

## 配置集合视图的单元格

你可能已经注意到在集合视图里的方块的轮廓，在它里面是一个红色惊叹号。这就是一个集合视图的单元格，它表示了集合视图里的一个单独的内容。

为了去配置这个单元格的大小，它在集合视图里完成，选择集合视图并且滑动到最上面的 _`Layout`_ 标签。在 _`Cell Size`_ 里，将 _`Width`_ 和 _`Height`_ 配置成 `100`。

[![cell-size](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/cell-size.png)](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/cell-size.png)

接下来，点击在集合视图单元格上的_红色的圈_。一个弹出框会告知你，你还没有为这个单元格设定一个可复用的标识符，所以选择这个单元格，并且到 _`Widget`_ 标签。下滑到 _`Collection Resuable View`_ 部分并且输入 _`ImageCellIdentifier`_ 作为这个的 _`标识符`_。刚才的哪个错误信号应该消失了。

[![Set_Reuse_Identifier](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Set_Reuse_Identifier-480x202.png)](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Set_Reuse_Identifier.png)

继续滑动到 _`Interaction Section`_。通过选择 _`Predefined`_ 将 _`Background Color`_ 设置成_`蓝色`_。

[![Set Cell Background Color](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Set_Cell_Background_Color-427x320.png)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Set_Cell_Background_Color.png)

场景应该看上去和下图差不多:

![Collection Cell with Color](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/collection-cell-with-color-470x500.png)

滑动到 _`Widget`_ 上部，并且将 _`Class`_ 设置成 _`PhotoCollectionImageCell`_。 

[![Set Cell Class](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Set_Cell_Class.png)](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Set_Cell_Class.png)

`Visual Studio` 将自动创建以这个名字命名的类，继承自 `UICollectionViewCell`，并且创建 `PhotoCollectionImageCell.cs`。太好了，我希望 `Xcode` 也能做到。

## 创建集合视图的数据源

你会需要手动创建一个类充当 `UICollectionViewDataSource`，它会为集合视图提供数据。

在 _`Soultuion Explorer`_ 中右键选择 _`ImageLocation`_。选择 _`Add \ Class`_ ，将类命名为 _`PhotoCollectionDataSource.cs`_ 并 点击 _`Add`_。

打开最近新增的 _`PhotoCollectionDataSource.cs`_ 并且在文件最上方增加以下内容：

    using UIKit;

这给予了你访问 `iOS` `UIKit` 框架的权限。

改变这个类的定义:

```
    public class PhotoCollectionDataSource : UICollectionViewDataSource
    {
    }
```

还记得之前那个为集合视图单元格定义过的可复用的标识符么？你会在这个类中使用他们。增加以下内容到这个类的定义中:

```
    private static readonly string photoCellIdentifier = "ImageCellIdentifier";
```

`UICollectionViewDataSource` 类中包含两个抽象成员（方法），你必须要去实现的。增加以下内容到类中:

```
    public override UICollectionViewCell GetCell(UICollectionView collectionView, 
        NSIndexPath indexPath)
    {
        var imageCell = collectionView.DequeueReusableCell(photoCellIdentifier, indexPath)
           as PhotoCollectionImageCell;

        return imageCell;
    }

    public override nint GetItemsCount(UICollectionView collectionView, nint section)
    {
        return 7;
    }
```

`GetCell()` 负责提供一个在集合视图里显示的单元格。

`DequeueReusableCell` 复用了一些今后不需要的单元格，例如，如果他们已经不在屏幕上显示了，你可以回收他们。如果没有可复用的单元格可用，一个新的将会被自动创建。

`GetItemsCount` 告诉集合视图可以显示 7 个内容。

接下来，你会增加一个对集合视图对 `ViewController` 类的引用，它是控制场景的视图控制器，包括集合视图。切换回 _`Main.storyboard`_，选择集合视图，之后选择 —_`Widget`_ 标签。把 _`collectionView`_ 输入到 _`Name`_。

[![Set Collection View Name](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Set_CollectionView_Name-480x160.png)](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Set_CollectionView_Name.png)

`Visual Studio` 将自动创建一个实例变量，使用这个名称在 `ViewController` 类上。

_注意_: 你不会在 _`ViewController.cs`_ 内看到这个实例变量。为了看见这个实例变量，点击在 _`ViewController.cs`_ 左边的扩展标识符，去显示 _`ViewController.designer.cs`_。这个包含了由 `Visual Studio` 自动创建的 `collctionView` 的实例变量。

从 _`Solution Explorer`_ 中打开 _`ViewController.cs`_，并且增加以下内容: 


```
    private PhotoCollectionDataSource photoDataSource;
```


在 `ViewDidLoad()` 的末尾，增加这几行，去初始化数据源，并且将它和集合视图链接起来。

```
    photoDataSource = <a href="http://www.google.com/search?q=new+msdn.microsoft.com">new</a> PhotoCollectionDataSource();
    collectionView.DataSource = photoDataSource;
```

这样一来，`photoDataSource` 将为集合视图提供数据。

构建和运行。你能看到有 7 个蓝色方块的集合视图。

![App Running with collection view](https://cdn3.raywenderlich.com/wp-content/uploads/2016/05/cells-no-photo-app-272x500.png)

太棒了 - 这个应用程序真的就快要完成了！

![Blue Squares!](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Blue_Squares-230x320.png)

## 展示图片

当然蓝色的方块很 `cool`，你接下来会更新数据源，从设备上获取真实的照片，并且将他们显示在集合视图上。你将使用 `Photos` 框架去访问那些通过 `Photos` 应用程序管理的照片和视频资源。

首先，你要为集合视图的单元格增加可以显示照片的视图。再次打开 _`Main.storyboard`_ 并选择集合视图。在 _`Widget`_ 标签上，下滑并且修改 _`Background color`_ 成默认值。

[![Set_Default_Cell_Background_Color](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Set_Default_Cell_Background_Color-480x247.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Set_Default_Cell_Background_Color.png)

打开 _`Toolbox`_，搜索 _`Image View`_，之后拖一个 _`Image View`_ 在 _`集合视图单元格`_ 的上面。

[![Drag Image View](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Drag_Image_View-650x400.png)](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Drag_Image_View.png)

`Image View` 开始的时候肯定比单元格大；为了重新制定它的大小，选择这个 `Image View` 并且到 _`Properties \ Layout`_ 标签。在 _`View`_ 部分，把 _`X`_ 和 _`Y`_ 设定为 `0`，并且把 _`Width`_ 和 _`Height`_ 设置为 `100`。

[![Set Image View Size](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Size-480x296.png)](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Size.png)

切换到 `Image View` 的 _`Widget`_ 标签，并且把 _`Name`_ 设置为 _`cellImageView`_。`Visual Studio` 将会为你自动创建一个命名好的 `cellImageView`。

[![Set Image View Name](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Name-480x152.png)](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Name.png)

滑动到 _`View`_ 部分并且把 _`Mode`_ 改变到 _`Aspect Fill`_。这个保证图片能被拉伸。

[![Set Image View Mode](https://cdn5.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Mode-480x147.png)](https://cdn4.raywenderlich.com/wp-content/uploads/2016/06/Set_Image_View_Mode.png)

_注意_: 如果你打开 _`PhotoCollectionImageCell.cs`_，你无法看见新的字段。相反，这个类被声明为 `partial`，它意味着这个字段在另外一个文件里。

在 _Solution Explorer_，选择 `PhotoCollectionImageCell.cs` 左边的箭头去扩展文件。打开 `PhotoCollectionImageCell.desinger.cs` 就能看见 `celImageView` 在这里被声明。

[![](https://cdn1.raywenderlich.com/wp-content/uploads/2016/06/Expand_PhotoCollectionImageCell-480x248.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Expand_PhotoCollectionImageCell.png)

这个文件被自动生成; **不要改变** 这个文件。如果你改变了，他们必须没有任何警告语句或者断开类类和 `storyboard` 之间的链接，它们可能就被覆盖了，造成了运行时的错误。



由于这一字段不是公有的，其他类无法访问它。相反，你需要为设定图片提供一个公有函数。

打开 `PhotoCollectionImageCell.cs` 并且为这个类增加以下几个方法:

```
    public void SetImage(UIImage image)
    {
        cellImageView.Image = image;
    }
```



现在你将更新 `PhotoCollectionDataSource` 去获取真实的照片。

将以下内容增加到 _`PhotoCollectionDataSource.cs`_ 的上部:

```
    using Photos;
```

增加以下内容到 `PhotoCollectionDataSource`:


```
    private PHFetchResult imageFetchResult;
    private PHImageManager imageManager;
```


`imageFetchResult` 字段会保留有序的保存照片库的对象，并且你能从 `imageManager` 中获得这些照片列表。 

在 `GetCell()` 中增加以下构造器:

```
    public PhotoCollectionDataSource()
    {
        imageFetchResult = PHAsset.FetchAssets(PHAssetMediaType.Image, null);
        imageManager = new PHImageManager();
    }
```


这个构造器获取在 `Photo` 应用程序中所有照片资源的列表并且把结果保存在 `imageFetchResult` 字段。它之后设置 `imageManager`，之后应用程序会通过它查询更多有关每一个照片的详细信息。

当这个类完成了任务后，通过增加析构函数来销毁 `imageManager`。

```
    ~PhotoCollectionDataSource()
    {
        imageManager.Dispose();
    }
```



为了让 `GetItemsCount` 和 `GetCell` 方法使用这些资源，并且返回图片，而非空的单元格，将 `GetItemsCOunt()` 改成以下内容:


```
    public override nint GetItemsCount(UICollectionView collectionView, nint section)
    {
        return imageFetchResult.Count;
    }
```


之后，替换 `GetCell` 为以下内容:

```
    public override UICollectionViewCell GetCell(UICollectionView collectionView, 
        NSIndexPath indexPath)
    {
        var imageCell = collectionView.DequeueReusableCell(photoCellIdentifier, indexPath) 
            as PhotoCollectionImageCell;

        // 1
        var imageAsset = imageFetchResult[indexPath.Item] as PHAsset;

        // 2
        imageManager.RequestImageForAsset(imageAsset, 
            <a href="http://www.google.com/search?q=new+msdn.microsoft.com">new</a> CoreGraphics.CGSize(100.0, 100.0), PHImageContentMode.AspectFill,
            <a href="http://www.google.com/search?q=new+msdn.microsoft.com">new</a> PHImageRequestOptions(),
             // 3
             (UIImage image, NSDictionary info) =>
            {
               // 4
               imageCell.SetImage(image);
            });

        return imageCell;
    }
```



我们对改变分解为以下几步:

1. `indexPath` 包括了一个引用，它会返回哪一个集合视图。`Item` 属性是一个简单的索引。你通过这个索引获得了一个资源并且把它转换为 `PHAsset`。
2. 你可以使用 `imageManager` 为一个资源去请求符合尺寸和填充模式的图片。
3. 许多 `iOS` 框架使用延迟执行的方法，因为需要消耗时间去完成请求，例如，`RequestImageForAsset`，并且当完成的时候通过代理模式来通知。当请求完成的时候，代理方法会被调用，它包含了图片和相关的信息。
4. 最后，图片会被设置在单元格上。

构建并且运行。你会看到请求访问许可的提示。

[![](https://cdn2.raywenderlich.com/wp-content/uploads/2016/06/Permission_Prompt-333x500.png)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Permission_Prompt.png)

如果你选择了 _`OK`_，然而，这个应用程序......不会做任何事请。_所以_ 这令人沮丧！

![Why_no_work](https://cdn3.raywenderlich.com/wp-content/uploads/2016/06/Why_no_work-248x320.png)

`iOS` 考虑到访问用户的照片库是非常隐私的事情，并且提示用户去给予许可权限。然而，应用程序必须注册到这个通知，当用户授权了应用程序可以使用，所以它能重新加载视图。你会在接下来看到怎么做。

## 为访问权限的改变注册通知消息

首先，你将对 `PhotoCollectionDataSource` 类增加一个方法，来通知它去重新检索照片。在类的末尾增加这些内容:


```
    public void ReloadPhotos()
    {
        imageFetchResult = PHAsset.FetchAssets(PHAssetMediaType.Image, null);
    }
```


之后，打开 _`ViewController.cs`_ z且增加以下框架 

```
    using Photos;
```

之后，增加这段代码到 `ViewDidLoad()`:

```
    // 1
    PHPhotoLibrary.SharedPhotoLibrary.RegisterChangeObserver((changeObserver) =>
    {
        //2
        InvokeOnMainThread(() =>
        {
            // 3
            photoDataSource.ReloadPhotos();
            collectionView.ReloadData();
        });
    });
```


以上代码干了什么:

1. 这个应用程序在共享的照片库上注册了一个代理，每当照片库有变更的时候被调用。
2. `InvokeOnMainThread()` 确保了 `UI` 变化始终在主线程上执行; 否则会发生程序崩溃。
3. 你调用 `photoDataSource.ReloadPhotos()` 去重新加载照片，并且 `collectionView.ReloadData()`，告诉集合视图重新绘制。

最后，你会处理初始状态的情况，这个应用程序还没有被给予对照片的访问权限，并且请求权限。

在 `ViewDidLoad()`，在 `photoDataSource` 设置中增加这些代码:


```
    if (PHPhotoLibrary.AuthorizationStatus == PHAuthorizationStatus.NotDetermined)
    {
        PHPhotoLibrary.RequestAuthorization((PHAuthorizationStatus newStatus) =>
        { });
    }
```

这个检查了目前认证的状态，并且若它是 `NotDetermined （不确定的）`，明确的发送请求去获取访问照片库的许可。

为了再次触发照片库的访问权限，通过 _`模拟器 \ 重置设定和内容`_ 来重置 `iPhone 模拟器`。

构建和运行应用程序。你将被提醒为照片库的许可，并且当你在应用程序中按下 _`Ok`_，应用程序会显示为有所有照片的缩略图的集合视图。

![Final Project Running](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/photo-collection-app-272x500.png)

## 之后我们应该怎么办？

你们可以通过 [这里](https://cdn1.raywenderlich.com/wp-content/uploads/2016/07/ImageLocation.zip) 下载完整的 `Visual Studio` 工程。

在这篇指南中，你可以学习一些有关 `Xamarin` 是如何工作和使用来创建 `iOS` 应用程序的。 

[`Xamarin` 指南网站](https://developer.xamarin.com/guides/) 提供了很多非常好的资源用于学习更多有关 `Xamarin` 平台的内容。为了更好的理解怎么构建跨平台的应用程序，查看 `Xamarin` 有关构建为 [`iOS`](https://www.xamarin.com/getting-started/ios) 和 [`Android`](https://www.xamarin.com/getting-started/android) 构建相同应用程序的指南。

`微软` 购买了 `Xamarin` 引入了很多令人激动的改变。`微软` 构建会议上的公告和 [`Xamarin` 发展会议](https://blog.xamarin.com/xamarin-evolve-2016-recap/) 上的指导能给你有关 `Xamarin` 新的发展方向。`Xamarin` 也提供了来自于最新发展例会上的 [视频](https://evolve.xamarin.com/#sessions)，它提供了更多有关将 `Xamarin` 使用在产品上的未来方向。 

你会考虑尝试用 `Xamarin` 来构建应用程序么？如果你有任何有关这个指导指南的问题或者建议，请在下方留言。
