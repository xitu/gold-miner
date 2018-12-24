> * 原文地址：[Value-Oriented Programming](https://matt.diephouse.com/2018/08/value-oriented-programming)
> * 原文作者：[MattDiephouse](https://matt.diephouse.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/value-oriented-programming.md](https://github.com/xitu/gold-miner/blob/master/TODO1/value-oriented-programming.md)
> * 译者：
> * 校对者：

# Value-Oriented Programming

At WWDC 2015, in a very influential session titled [_Protocol-Oriented Programming in Swift_](https://developer.apple.com/videos/play/wwdc2015/408/), Dave Abrahams explained how Swift’s protocols can be used to overcome some shortcomings of classes. He suggested this rule: “Don’t start with a class. Start with a protocol”.

To illustrate the point, Dave described a protocol-oriented approach to a primitive drawing app. The example worked from a few of primitive shapes:

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

These are value types. That eliminates many of the problems of an object-oriented approach:

1.  Instances aren’t shared implicitly
    
    The reference semantics of objects add complexity when passing objects around. Changing a property of an object in one place can affect other code that has access to that object. Concurrency requires locking, which adds tons of complexity.
    
2.  No problems from inheritance
    
    Reusing code via inheritance is fragile. Inheritance also couples interfaces to implementations, which makes reuse more difficult. This is its own topic, but even OO programmers will tell you to prefer “composition over inheritance”.
    
3.  No imprecise type relationships
    
    With subclasses, it’s difficult to precisely identify types. e.g. with `NSObject.isEqual()`, you must be careful to only compare against compatible types. Protocols work with generics to precisely identify types.

To handle the actual drawing, a `Renderer` protocol was added that describes the primitive drawing operations:

```
protocol Renderer {
  func move(to p: CGPoint)
  func line(to p: CGPoint)
  func arc(at center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
}
```

Each type could then `draw` with a `Renderer`.

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

This made it possible to define different renderers that worked easily with the given types. A main selling point was the ability to define a test renderer, which let you verify drawing by comparing strings:

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

But you could also easily extend platform-specific types to make them work as renderers:

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

Lastly, Dave showed that you can extended the protocol to provide conveniences:

```
extension Renderer {
  func circle(at center: CGPoint, radius: CGFloat) {
    arc(at: center, radius: radius, startAngle: 0, endAngle: twoPi)
  }
}
```

I think that approach is pretty compelling. It’s much more testable. It also allows us to interpret the data differently by providing separate renderers. And value types neatly sidestep a number of problems that an object-oriented version would have.

But I think there’s a better way to write this code.

Despite the improvements, logic and side effects are still tightly coupled in the protocol-oriented version. `Polygon.draw` does 2 things: it converts the polygon into a number of lines and then renders those lines. So when it comes time to test the logic, we need to use `TestRenderer`—which, despite what the WWDC talk implies, is a mock.

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

We can separate logic and effects here by turning them into separate steps. Instead of the `Renderer` protocol, with `move`, `line`, and `arc`, let’s declare value types that represent the underlying operations.

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

Now, instead of calling those methods, `Drawable`s can return a set of `Path`s that are used to draw them:

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

And now `CGContext` to be extended to draw those paths:

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

And we can add our convenience method for creating circles:

```
extension Path {
  static func circle(at center: CGPoint, radius: CGFloat) -> Path {
    return .arc(Path.Arc(center: center, radius: radius, startAngle: 0, endAngle: twoPi))
  }
}
```

This works just the same as before and requires roughly the same amount of code. But we’ve introduced a boundary that lets us separate two parts of the system. That boundary lets us:

1.  Test without a mock
    
    We don’t need `TestRenderer` anymore. We can verify that a `Drawable` will be drawn correctly testing the values return from its `paths` property. `Path` is `Equatable`, so this is a simple test.

```
let polygon = Polygon(corners: [(x: 0, y: 0), (x: 6, y: 0), (x: 3, y: 6)])
let paths: Set<Path> = [
  .line(Line(from: (x: 0, y: 0), to: (x: 6, y: 0))),
  .line(Line(from: (x: 6, y: 0), to: (x: 3, y: 6))),
  .line(Line(from: (x: 3, y: 6), to: (x: 0, y: 0))),
]
XCTAssertEqual(polygon.paths, paths)
```

2.  Insert more steps
    
    With the value-oriented approach, we can take our `Set<Path>` and transform it directly. Say you wanted to flip the result horizontally. You calculate the size and then return a new `Set<Path>` with flipped coordinates.
    
    In the protocol-oriented approach, it would be somewhat difficult to transform our drawing steps. To flip horizontally, you need to know the final width. Since that width isn’t known ahead of time, you’d need to write a `Renderer` that (1) saved all the calls to `move`, `line`, and `arc` and then (2) pass it another `Render` to render the flipped result.
    
    (This theoretical renderer is creating the same boundary we created with the value-oriented approach. Step 1 corresponds to our `.paths` method; step 2 corresponds to `draw(Set<Paths>)`.)
    
3.  Easily inspect data while debugging
    
    Say you have a complex `Diagram` that isn’t drawing correctly. You drop into the debugger and find where the `Diagram` is drawn. How do you find the problem?
    
    If you’re using the protocol-oriented approach, you’ll need to create a `TestRenderer` (if it’s available outside your tests) or you’ll need to use a real renderer and actually render somewhere. Inspecting that data will be difficult.
    
    But if you’re using the value-oriented approach, you only need to call `paths` to inspect this information. Debuggers can display values much more easily than effects.
    

The boundary adds another semantic layer, which opens up additional possibilities for testing, transformation, and inspection.

I’ve used this approach on a number of projects and found it immensely helpful. Even with a simple example like the one given here, values have a number of benefits. But those benefits become much more obvious and helpful when working in larger, more complex systems.

If you’d like to see a real world example, check out [PersistDB](https://github.com/PersistX/PersistDB), the Swift persistence library I’ve been working on. The public API presents `Query`s, `Predicate`s, and `Expression`s. These are reduced to `SQL.Query`s, `SQL.Predicate`s, and `SQL.Expression`s. And each of those is reduced to a `SQL`, a value representing some actual SQL.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
