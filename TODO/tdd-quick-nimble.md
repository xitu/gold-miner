> * 原文地址：[Test Driven Development (TDD) in Swift with Quick and Nimble](https://www.appcoda.com/tdd-quick-nimble/)
> * 原文作者：[LAWRENCE TAN](https://www.appcoda.com/author/lawrencetan/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/tdd-quick-nimble.md](https://github.com/xitu/gold-miner/blob/master/TODO/tdd-quick-nimble.md)
> * 译者：[94haox](https://github.com/94haox)
> * 校对者：[swants](https://github.com/swants), [atuooo](https://github.com/atuooo)

在移动开发领域，编写测试用例并不常见，事实上，大多数移动开发团队为了加快开发速度，都尽可能地避免编写测试用例。

作为一个“成熟的”开发者，我尝到了编写测试用例的好处，它不仅仅能保证你的 app 的功能符合预期，它也能通过“锁住”你的代码来阻止其他开发者改变你的代码。而且测试代码和实现代码之间的联系也有助于新的开发者比较容易地理解和接手项目。

## 测试驱动开发（ TDD ）

**测试驱动开发（ TDD ）** 就像一个新的编码艺术。它遵守下面的递归循环：

* 写一个能导致失败的测试用例
* 为通过上述测试写一些代码
* 重构
* 重复上述操作，直到我们满意

让我为你展示一个简单的例子，首先思考一下下面函数的实现：

```
func calculateAreaOfSquare(w: Int, h: Int) -> Double { }
```

**测试 1:**
给两个数 `w=2`，`h=2`，预期的面积应该是 `4`。在这个例子中，这个测试会失败，因为这个函数目前并没有实现。

接着我们继续写：

```
func calculateAreaOfSquare(w: Int, h: Int) -> Double { return w * h }
```

测试 1 现在通过了！哇哦！

**测试 2:**
给两个数 `w=-1`，`h=-1`，预期的面积应该是 `0`。在这个例子中，测试会失败，因为基于目前函数的实现，它会返回 `1`。

让我们继续：

```
func calculateAreaOfSquare(w: Int, h: Int) -> Double { 
    if w > 0 && h > 0 { 
        return w * h 
    } 
    
    return 0
}
```

测试 2 现在也通过了！哇哦！

这些操作可以继续下去，一直到你处理了所有的边缘情况。接下来你就应该重构你的代码，在保证所有的测试用例都能通过的情况下，让它看起来漂亮简洁。

基于我们上面讨论的，我们意识到，TDD 不仅仅能让我们写出高质量的代码，它也能让我们更早的处理边缘情况。另外，它还能通过不同的分工：一个写测试用例，一个写实现代码，来进行结对编程。你可以在 [Dotariel’s Blog Post](https://medium.com/@dotariel/5-reasons-i-love-test-driven-development-fc257d9093e2#.7eejsiuwg) 找到更多有关于 TDD 的信息。

## 你会在本教程中学到什么？

在教程的结尾，你可以获得以下的知识：

* 对 **为什么 TDD 很棒**，有一个基础的认知。
* 对 **Quick 和 Nimble 如何工作**， 有一个基础的认知。
* 知道如何使用 **Quick 和 Nimble 进行 UI 测试**。
* 知道如何使用 **Quick 和 Nimble 进行单元测试**。

## 前期准备

在我们继续下去之前，有些前期准备：

* Swift3 环境和 8.3.3 版本的 Xcode
* 有 Swift 和 iOS 开发的经验

## 配置我们的项目

假设我们要开发一个能够展示电影列表的 app。 首先打开 Xcode 并创建一个叫做 **MyMovies** 的单视图应用。勾选上 ```Unit Tests```，一旦我们配置好库和视图控制器，我们将重新访问这个目标。

![TDD Sample Project](http://www.appcoda.com/wp-content/uploads/2017/08/tdd-1.png)

下一步，删除已存在的 `ViewController` 并且重新创建一个继承于`UITableViewController` 的新类，把它命名为`MoviesTableViewController`。

将 `Main.storyboard` 中的 `ViewController` 删除，将一个新的`UITableViewController` 拖进去，让它继承于`MoviesTableViewController`。

然后，将 cell 的样式改为 `Subtitle`，并且将 identifier 改为 `MovieCell`，这样，我们后面就可以同时展示电影的标题和类型了。

![](http://www.appcoda.com/wp-content/uploads/2017/08/tdd-3.png)

不要忘了将这个视图控制器标记为 `initial view controller`。

![](http://www.appcoda.com/wp-content/uploads/2017/08/tdd-5.png)

这个时候，你的代码看上去应该像下面一样：

```
import UIKit
 
class MoviesTableViewController: UITableViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
```

### 电影数据

现在，我们需要造出一些电影数据，一会儿，我们需要它们去填充我们的视图。

#### Genre Enum

```
enum Genre: Int {
    case Animation
    case Action
    case None
}
```

这个枚举用来标记电影的类别。

#### Movie Struct

```
struct Movie {
    var title: String
    var genre: Genre
}
```

这个电影数据类型用来描述我们需要的电影数据。

```
class MoviesDataHelper {
    static func getMovies() -> [Movie] {
        return [
            Movie(title: "The Emoji Movie", genre: .Animation),
            Movie(title: "Logan", genre: .Action),
            Movie(title: "Wonder Woman", genre: .Action),
            Movie(title: "Zootopia", genre: .Animation),
            Movie(title: "The Baby Boss", genre: .Animation),
            Movie(title: "Despicable Me 3", genre: .Animation),
            Movie(title: "Spiderman: Homecoming", genre: .Action),
            Movie(title: "Dunkirk", genre: .Animation)
        ]
    }
}
```

这个电影数据助手类可以帮助我们直接调用 `getMovies` 方法，所以我们可以在单次调用中就可以获得需要的数据。

提醒一下，到目前为止，我们并没有在项目中做任何有关 TDD 的配置。现在，让我们开始学习这篇教程的主要内容 Quick 和 Nimble 吧！

## Quick & Nimble

**Quick** 是一个建立在 XCTest 上，为 Swift 和 Objective-C 设计的测试框架. 
它通过 [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) 去编写非常类似于 [RSpec](https://github.com/rspec/rspec) 的测试用例。

**Nimble** 就像是 **Quick** 的搭档，它提供了匹配器作为断言。关于它的更多信息，请查看[这儿](https://github.com/Quick/Quick)

### 使用 Carthage 安装 Quick & Nimble

随着 Carthage 库的增长，相比 Cocoapods 我越来越喜欢 Carthage，因为它更去中心化。即使某一个库编译失败，整个项目依然可以编译成功

```
#CartFile.private
github "Quick/Quick"
github "Quick/Nimble"
```

上面就是 `CartFile.private` 中的内容，我通过它来安装依赖。如果你不熟悉 Carthage，先看看[它](https://github.com/Carthage/Carthage)吧.

将 `CartFile.private` 拖入你的项目目录，然后终端运行 `carthage update`。这个命令会克隆依赖，成功后，你可以在 `Carthage -> Build -> iOS` 找到它们。接着，将两个框架都添加到测试工程。你需要到 Build Phases 点击左上方的加号，并且选择 “New Copy Files Phase”。将它设置为 “Frameworks”，并且将两个框架都添加进去。

现在所有的设置都搞定了！鼓掌撒花！

![](http://www.appcoda.com/wp-content/uploads/2017/08/tdd-6.png)

## 编写测试用例 #1

让我们开始编写第一个测试用例。已知的是我们有一个列表，一些电影数据。那么，我们怎么保证列表视图显示正确项目个数？是的！我们需要保证列表视图的 cell 行数应该和电影数据的个数保持一致。这就是我们第一个需要测试的地方。那么开始吧！进到 `MyMoviesTests` 将 XCTest 代码全部删掉，并且将 Quick 和 Nimble 引入进来！

我们必须保证我们的类是 `QuickSpec` 的子类，当然 `QuickSpec` 也是 `XCTestCase`的子类。要清楚的是 `Quick` 和 `Nimble` 仍然是基于 `XCTest` 的。
最后，我们还有一件事需要做，那就是需要重写 `spec()` 函数， 关于这点，你可以查看 [set of example groups and examples](https://github.com/Quick/Quick/blob/master/Documentation/en-us/QuickExamplesAndGroups.md).

```
import Quick
import Nimble
 
@testable import MyMovies
 
class MyMoviesTests: QuickSpec {
    override func spec() {
    }
}
```

这个时候，你需要明白我们将使用一些 `it`， `describe` 和 `context` 来编写我们的测试。
`describe` 和 `context` 只是 `it` 示例的逻辑分组。

### 测试 #1 – 预计列表视图的行数 = 电影数据的个数

首先，引入我们的视图控制器

```
import Quick
import Nimble
 
@testable import MyMovies
 
class MyMoviesTests: QuickSpec {
    override func spec() {
        var subject: MoviesTableViewController!
        
        describe("MoviesTableViewControllerSpec") {
            beforeEach {
                subject = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoviesTableViewController") as! MoviesTableViewController
                
                _ = subject.view
            }
        }
    }
}
```

需要注意的是，我们有一个对 `MyMovies` 的 `@testable` 引用，这行代码的目的是标记着我们在测试哪个项目，并且允许我们引用那里的类。由于我们需要测试控制器的视图层，所以需要从 storyboard 抓取一个实例。

**describe** 闭包应该是我们为 `MoviesTableViewController` 而写的第一个组合测试用例。

**beforeEach** 闭包将在 **describe** 闭包中所有例子执行之前运行。所以你可以在其中写一些需要在 `MoviesTableViewController` 执行时首先运行的测试。

`_ = subject.view` 会将视图控制器放入内存，它类似于调用 `viewDidLoad`。

最后，我们可以在 `beforeEach { }` 之后添加测试断言。比如：

```
context("when view is loaded") {
    it("should have 8 movies loaded") {
        expect(subject.tableView.numberOfRows(inSection: 0)).to(equal(8))
   }
}
```

让我们一步步来看。首先，我们有一个被标记为 `when view is loaded` 组合示例闭包 `context`；接着，我们还有一个主要的示例 `it should have 8 movies loaded`；然后，我们预计或者断言列表视图的 cell 有 8 行。通过按 CMD+U 或者 Product -> Test 运行测试用例，然后你会在控制面板上看到下面信息：

```
MoviesTableViewController__when_view_is_loaded__should_have_8_movies_loaded] : expected to equal <8>, got <0>
 
Test Case '-[MyMoviesTests.MoviesTableViewControllerSpec MoviesTableViewController__when_view_is_loaded__should_have_8_movies_loaded]' failed (0.009 seconds).
```

所以，你只是写了一个并不完善的测试用例。开始 TDD 吧！

## 完善测试用例 #1

现在，回到 `MoviesTableViewController`，加载电影数据！ 然后再重新运行测试用例，接着，之前写的测试用例通过了！

```
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return MoviesDataHelper.getMovies().count
}
 
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell")
    return cell!
}
```

总结一下，首先你写了一个不完善的测试，然后通过 3 行代码完善了它，并且测试通过了，这就是为什么我们将它称为测试驱动开发（TDD），一个能确保代码良好和高质量的方式。

## 编写测试用例 #2

现在，是时候用第二个测试用例来结束这个教程了。
我们意识到，当我们运行 app 的时候，我们只是在每个地方设置 “title” 和 “subtitle”。但是我们并没有验证它显示的是不是我们实际的数据！所以，为 UI 也写个测试用例吧。

进入 spec 文件。 添加一个新的 `context` 并把它称为 `Table View`。从 列表视图抓取第一个 cell ，并且测试它展示的数据是否和实际应该展示的数据相同。

```
context("Table View") {
    var cell: UITableViewCell!
    
    beforeEach {
            cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
    }
        
    it("should show movie title and genre") {
        expect(cell.textLabel?.text).to(equal("The Emoji Movie"))
        expect(cell.detailTextLabel?.text).to(equal("Animation"))
     }
}
```

测试运行后，会得到下面的失败信息。

```
MoviesTableViewController__Table_View__should_show_movie_title_and_genre] : expected to equal <Animation>, got <Subtitle>
```

来吧，让我们通过给 cell 相应的数据去展示来完善这个测试用例！

## 完善测试用例 #2

因为 Genre 是枚举，我们需要为它添加不同的描述。所以我们需要更新 `Movie` 类：

```
struct Movie {
    var title: String
    var genre: Genre
    
    func genreString() -> String {
        switch genre {
        case .Action:
            return "Action"
        case .Animation:
            return "Animation"
        default:
            return "None"
        }
    }
}
```

同样 `cellForRow` 方法也需要更新：

```
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell")
    
    let movie = MoviesDataHelper.getMovies()[indexPath.row]
    cell?.textLabel?.text = movie.title
    cell?.detailTextLabel?.text = movie.genreString()
    
    return cell!
}
```

哇哦！第二个测试用例通过啦！此时，让我们看看能不能通过重构让代码更加清晰，当然，仍然是在保持测试用例可以通过的基础上。移除空函数，并且将 `getMovies()` 声明为计算属性。

```
class MoviesTableViewController: UITableViewController {
 
    var movies: [Movie] {
        return MoviesDataHelper.getMovies()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell")
        
        let movie = movies[indexPath.row]
        cell?.textLabel?.text = movie.title
        cell?.detailTextLabel?.text = movie.genreString()
        
        return cell!
    }
}
```

试试吧，重新运行测试，它依然是可以通过的。

## 总结

我们做了什么？

* 我们为了检测电影数量，编写了第一个测试用例，测试 **未通过**
* 接着我们实现了加载电影的逻辑，然后测试 **通过**
* 为了检测是否显示了正确的数据，我们编写了第二个测试，测试 **未通过**
* 接着我们实现了显示逻辑，然后测试 **通过**
* 最后我们停止了测试，并且进行了 **重构**

这大概就是 TDD 的全部。你也可以在这个工程上去进行更多的尝试。如果你对教程有任何相关问题，请在下面留下相关评论以便让我知道。

你可以在这找到相关[源码](https://github.com/lawreyios/MyMovies)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
