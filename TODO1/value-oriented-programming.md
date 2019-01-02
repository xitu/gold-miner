> * 原文地址：[Value-Oriented Programming](https://matt.diephouse.com/2018/08/value-oriented-programming)
> * 原文作者：[MattDiephouse](https://matt.diephouse.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/value-oriented-programming.md](https://github.com/xitu/gold-miner/blob/master/TODO1/value-oriented-programming.md)
> * 译者：[nanjingboy](https://github.com/nanjingboy)
> * 校对者：

# 值类型导向编程

在 2015 WWDC 大会上，在一个具有影响力的会议（[面向协议的 Swift 编程](https://developer.apple.com/videos/play/wwdc2015/408/)）中，Dave Abrahams 解释了如何用 Swift 的协议来解决类的一些缺点。他提出了这条规则：“不要从类开始，从协议开始”。

为了说明这一点，Dave 通过面向协议的方法描述了一个基本绘图应用。该示例使用了一些基本形状：

```
protocol Drawable {}

struct Polygon: Drawable {
  var corners: [CGPoint] = []
}

struct Circle: Drawable {
  var center: CGPoint
  var radius: CGFloat
}

struct Diagram: Drawable {
  var elements: [Drawable] = []
}
```

这些是值类型。它解决了面向对象方法中的许多问题：

1.  实例不能隐式共享

    对象的引用在对象传递时增加了复杂性。在一个地方改变对象的属性可能会影响有权访问该对象的其他代码。并发需要锁定，这增加了大量的复杂性。

2.  无继承问题

    通过继承来重用代码的方式是脆弱的。继承还将接口与实现耦合在一起，这使得代码重用变得更加困难。这是它的特性，但即使是使用面向对象的程序员也会告诉你他更喜欢”组合而不是继承“。

3.  明确的类型关系

    对于子类，很难精确识别其类型。比如  `NSObject.isEqual()`，你必须小心且只能与兼容类型比较。协议和泛型协同工作可以精确识别类型。

为了处理实际的绘图操作，我们可以添加一个描述基本绘图操作的 `Renderer` 协议：

```
protocol Renderer {
  func move(to p: CGPoint)
  func line(to p: CGPoint)
  func arc(at center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
}
```

然后每种类型都可以使用 `Renderer` 的 `draw` 方法进行绘制。

```
protocol Drawable {
  func draw(_ renderer: Renderer)
}

extension Polygon : Drawable {
  func draw(_ renderer: Renderer) {
    renderer.move(to: corners.last!)
    for p in corners {
      renderer.line(to: p)
    }
  }
}

extension Circle : Drawable {
  func draw(renderer: Renderer) {
    renderer.arc(at: center, radius: radius, startAngle: 0.0, endAngle: twoPi)
  }
}

extension Diagram : Drawable {
  func draw(renderer: Renderer) {
    for f in elements {
      f.draw(renderer)
    }
  }
}
```

这使得定义根据给定类型并能为此轻松工作的各种渲染器变的可能。一个最主要的卖点是定义测试渲染器的能力，它允许你通过比较字符串来验证绘制：

```
struct TestRenderer : Renderer {
  func move(to p: CGPoint) { print("moveTo(\(p.x), \(p.y))") }
  func line(to p: CGPoint) { print("lineTo(\(p.x), \(p.y))") }
  func arc(at center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
      print("arcAt(\(center), radius: \(radius),"
        + " startAngle: \(startAngle), endAngle: \(endAngle))")
  }
}
```

你也可以轻松扩展平台特定的类型，使其成为渲染器：

```
extension CGContext : Renderer {
  // CGContext already has `move(to: CGPoint)`

  func line(to p: CGPoint) {
    addLine(to: p)
  }

  func arc(at center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
    addArc(
      center: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: true
    )
  }
}
```

最后，Dave 表明你可以通过扩展协议来提供方便：

```
extension Renderer {
  func circle(at center: CGPoint, radius: CGFloat) {
    arc(at: center, radius: radius, startAngle: 0, endAngle: twoPi)
  }
}
```

我认为这种方法非常棒，它具有更好的可测试性。它还允许我们通过提供不同的渲染器，从而使用不同的方式解释数据。并且值类型巧妙地回避了面对对象版本中可能遇到的许多问题。

虽然有所改进，但逻辑和副作用仍然在面向协议的版本中强度耦合。`Polygon.draw` 做了两件事：它将多边形转换为多条线，然后渲染这些线。因此，当需要测试这些逻辑时，我们需要使用 `TestRenderer` - 尽管 WWDC 暗示它只是一个模拟。

```
extension Polygon : Drawable {
  func draw(_ renderer: Renderer) {
    renderer.move(to: corners.last!)
    for p in corners {
      renderer.line(to: p)
    }
  }
}
```

我们可以将逻辑和效果拆分成不同的步骤来区分它们。使用 `move`、`line` 和 `arc` 来替代 `Renderer` 协议，让我们声明代表这些底层操作的值类型。

```
enum Path: Hashable {
  struct Arc: Hashable {
    var center: CGPoint
    var radius: CGFloat
    var startAngle: CGFloat
    var endAngle: CGFloat
  }

  struct Line: Hashable {
    var start: CGPoint
    var end: CGPoint
  }

  // Replacing `arc(at: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)`
  case arc(Arc)
  // Replacing `move(to: CGPoint)` and `line(to: CGPoint)`
  case line(Line)
}
```

现在，`Drawable` 可以通过返回一组用于绘制的 `path` 来替代方法调用：

```
protocol Drawable {
  var paths: Set<Path> { get }
}

extension Polygon : Drawable {
  var paths: Set<Path> {
    return Set(zip(corners, corners.dropFirst() + corners.prefix(1))
      .map(Path.Line.init)
      .map(Path.line))
  }
}

extension Circle : Drawable {
  var paths: Set<Path> {
    return [.arc(Path.Arc(center: center, radius: radius, startAngle: 0.0, endAngle: twoPi))]
  }
}

extension Diagram : Drawable {
  var paths: Set<Path> {
    return elements
      .map { $0.paths }
      .reduce(into: Set()) { $0.formUnion($1) }
  }
}
```

现在 `CGContext` 通过扩展来绘制这些路径：

```
extension CGContext {
    func draw(_ arc: Path.Arc) {
        addArc(
            center: arc.center,
            radius: arc.radius,
            startAngle: arc.startAngle,
            endAngle: arc.endAngle,
            clockwise: true
        )
    }

    func draw(_ line: Path.Line) {
        move(to: line.start)
        addLine(to: line.end)
    }

    func draw(_ paths: Set<Path>) {
        for path in paths {
            switch path {
            case let .arc(arc):
                draw(arc)
            case let .line(line):
                draw(line)
            }
        }
    }
}
```

我们可以添加用来创建 circle 的便捷方法：

```
extension Path {
  static func circle(at center: CGPoint, radius: CGFloat) -> Path {
    return .arc(Path.Arc(center: center, radius: radius, startAngle: 0, endAngle: twoPi))
  }
}
```

这与之前的运行效果一样，并需要大致相同数量的代码。但我们引入了一个边界，让我们将系统的两个部分分开。这个边界让我们：

1.  没有模拟测试

    我们不再需要 `TestRenderer` 了，我们可以通过测试从`paths`属性返回的值来验证 `Drawable` 是否可以正确绘制。 `Path` 是`可进行相等比较`的，所以这是一个简单的测试。

```
let polygon = Polygon(corners: [(x: 0, y: 0), (x: 6, y: 0), (x: 3, y: 6)])
let paths: Set<Path> = [
  .line(Line(from: (x: 0, y: 0), to: (x: 6, y: 0))),
  .line(Line(from: (x: 6, y: 0), to: (x: 3, y: 6))),
  .line(Line(from: (x: 3, y: 6), to: (x: 0, y: 0))),
]
XCTAssertEqual(polygon.paths, paths)
```

2.  插入更多步骤

    使用值类型导向方法，我们可以使用 `Set<Path>` 并直接对其进行转换。假设你想要水平翻转结果。你只要计算尺寸，然后返回一个新的 `Set<Path>` 翻转坐标即可。

    在面向协议的方法中，绘制转换步骤会有些困难。如果想要水平翻转，你需要知道最终宽度。由于预先不知道这个宽度，你需要实现一个 `Renderer`，（1）它保存了所有的方法调用（`move`、`line` 和 `arc`）。（2）然后将其传递给另一个 `Render` 来渲染翻转结果。

    （这个假设的渲染器创建了我们通过值类型导向方法创建的渲染器相同的边界。步骤 1 对应于 `.paths` 方法；步骤 2 对应于 `draw(Set<Paths>)`。）

3.  在调试时轻松检查数据

    假设你有一个没有正确绘制的复杂  `Diagram`。你进入调试器并找到绘制 `Diagram` 的位置。你如何定位这个问题？

    如果你正在使用面向协议的方法，你需要创建一个 `TestRenderer`（如果它在测试之外可用），或者你需要使用真实的渲染器并实际渲染某一部分。数据检查将变得很困难。

    但如果你使用值类型导向方法，你只需要调用 `paths` 来检查这些信息。相对于渲染效果，调试器更容易显示数据值。


边界增加了另一个语义，为测试、转换和检查带来了更多的可能性。

我已经在很多项目中使用了这种方法，并发现它非常有用。即使是像本文给出的简单例子，值类型也具有很多好处。但在更大、更复杂的系统中，这些好处将变得更加明显和有用。

如果你想看一个真实的例子，请查看 [PersistDB](https://github.com/PersistX/PersistDB)。我一直在研究的 Swift 持久存储库。公共 API 提供 `Query`、`Predicate` 和 `Expression`。它们是 `SQL.Query`、`SQL.Predicate` 及 `SQL.Expression` 的简化版。它们中的每一个都会被转换成一个 `SQL`（一个代表一些实际 SQL 的值）。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
