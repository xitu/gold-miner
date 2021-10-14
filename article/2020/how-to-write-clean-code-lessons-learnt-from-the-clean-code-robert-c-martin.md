> * 原文地址：[How to write clean code? Lessons learnt from “The Clean Code” — Robert C. Martin](https://medium.com/mindorks/how-to-write-clean-code-lessons-learnt-from-the-clean-code-robert-c-martin-9ffc7aef870c)
> * 原文作者：[Shubham Gupta](https://medium.com/@shubham08gupta)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-write-clean-code-lessons-learnt-from-the-clean-code-robert-c-martin.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-write-clean-code-lessons-learnt-from-the-clean-code-robert-c-martin.md)
> * 译者：[司徒公子](https://github.com/stuchilde)
> * 校对者：[PingHGao](https://github.com/PingHGao)、[niayyy-S](https://github.com/niayyy-S)

# 如何编写整洁代码？从 Robert C. Martin 的“代码整洁之道”中吸取的教训

有两件事 —— 编程和良好的编程。编程是我们一直在做的事情。现在是时候关注良好的编程了。我们都知道，即使是糟糕的代码也能工作。但是写好代码，需要花费时间和资源。此外，当其他开发者试图找出你代码的运行细节，他们会嘲笑你。但是，关心你的程序永远不会太迟。

这本书给了我很多关于最佳实践和如何编写代码的知识。现在，我为自己的编程技能感到羞愧。尽管我总是努力改善我的代码，但是这本书教会我的更多。

现在，你阅读这篇博客有两种原因。第一，你是个程序员；第二，你想成为更好的程序员。很好，我们需要更好的程序员。

**整洁代码的特征**：

1. 应该是优雅的 —— 整洁的代码读起来令人**愉悦**。读这种代码，就像见到手工精美的音乐盒或者设计精良的汽车一般，让你会心一笑。
2. 整洁的代码力求集中。每个函数、每个类和每个模块都全神贯注于一件事，完全不受四周细节的干扰和污染。
3. 整洁的代码是有意维护的 —— 有人曾花时间让它保持简单有序。他们适当地关注到了细节。他们在意过。
4. 能通过所有的测试
5. 没有重复代码
6. 包括尽量少的实体，比如类、方法、函数等

## 如何编写整洁代码？

## 有意义的命名

名副其实。选个好名字要花时间，但省下来的时间要比花掉的多。变量、函数或类的名称应该已经回复了所有的大问题。它该告诉你，它为什么会存在，它做什么事，它应该怎么用。如果名称需要注释来补充，那就不算是名副其实。

Eg- int d; // 消逝的时间，以日计

> **我们应该选择指明了计量对象和计量单位的名称。**

更好的命名应该是：-int elapsedTime。（尽管书中说的是 elapsedTimeInDays，但是我仍然倾向于前者。假设运行的时间改为毫秒，我们不得不将 int 改为 long，并且用 elapsedTimeInMillis 替换 elapsedTimeInDays。我们不知道何时是个尽头。）

**类名** —— 类名和对象名应该是名词或名词短语，如 Customer、WikiPage、Account 和 AddressParser。避免使用 Manager、Processor、Data 或 Info 这样的类名。类名不应当是动词。

**方法名** —— 方法名应当是动词或动词短语，如 postPayment、deletePage 或者 save。属性访问器、修改器和断言应该根据其值命名，并加上 get、set 前缀。

重载构造器时，使用描述了参数的静态工厂方法名。例如，

Complex fulcrumPoint = Complex.FromRealNumber(23.0); 
通常好于 
Complex fulcrumPoint = new Complex(23.0);

**每个概念对应一个词** —— 每个抽象概念选一个词，而且一以贯之。例如，使用 fetch、retrieve 和 get 来给多种类中的同种方法命名。你怎么能记得住哪个类中对应的是哪个名字呢？同样，在一堆代码中有 controller，又有 manager，还有 driver，就会令人困惑。DeviceManager 和 Protocol-Controller 之间有何根本区别？

## 函数

![](https://blog-private.oss-cn-shanghai.aliyuncs.com/20200506082602.png)

函数的第一规则就是要短小，第二条规则是还要更短小。这意味着 if 语句、else 语句、while 语句等，其中的代码块应该只有一行。该行大抵应该是一个函数调用语句。这样不仅能保持函数短小，而且，因为块内调用的函数拥有具体说明性的名称，从而增加了文档上的价值。

#### 函数参数

一个函数不应该有超过 3 个参数，尽可能使其少点。一个函数需要两个或者三个以上参数的时候，就说明这些参数应该封装为类了。通过创建参数对象，从而减少参数数量，看起来像是在作弊，但实则并非如此。

现在，当我说要减少函数大小的时候，你肯定在想如何减少 try-catch 的内容，因为，它使你的代码变得越来越臃肿。我的答案是只生成一个仅包含 try-catch-finally 语句的方法。将 try/catch/finally 代码块从主体部分抽离出来，另外形成函数。

```Java
public void delete(Page page) { 
  try {
     deletePageAndAllReferences(page);
  }
  catch (Exception e) { 
    logError(e);
  } 
}

private void deletePageAndAllReferences(Page page) throws Exception { 
    deletePage(page);
    registry.deleteReference(page.name); 
    configKeys.deleteKey(page.name.makeKey());
}

private void logError(Exception e) { 
    logger.log(e.getMessage());
}
```

这使得逻辑变得清晰明了，函数名能更容易描述我们想要表达的。错误处理可以忽略。有了这样美妙的区隔，代码就更易于理解和修改了。

**错误处理就是一件事** —— 函数应该只做一件事。错误处理就是一件事。如果关键字 try 在某个函数中存在，它就该是这个函数的第一个关键字，而且在 catch/finally 代码块后面也不该有其他内容。

#### 注释

如果你通过写注释来证明你的观点，那你就大错特错了。理想情况下，根本不需要注释。如果你的代码需要注释，说明你做错了。我们的代码应该阐述一切。现代编程语言是英语，我们能更加容易阐述自己的观点。正确的命名能避免注释。

与法律有关的注释除外，它们是有必要的，与法律有关的注释是指版权及著作权声明。

#### 对象和数据结构

这是个复杂的话题，所以要多加留意。首先，我们要澄清对象与数据结构之间的区别。

> **对象把数据隐藏于抽象之后，暴露操作数据的函数。数据结构暴露其数据，没有提供有意义的函数。**

这两件事完全不同，一个是关于存储 数据，另一个是关于如何操作这些数据。例如，考虑到过程式代码形状规范，Geometry 类操作三个形状类。形状类都是简单的数据结构，没有任何行为。所有行为都在 Geometry 类中。

```Java
public class Square { 
  public Point topLeft;
  public double side;
}

public class Rectangle { 
  public Point topLeft; 
  public double height; 
  public double width;
}

public class Circle { 
  public Point center;
  public double radius;
}

public class Geometry {
  public final double PI = 3.141592653589793;
  public double area(Object shape) throws NoSuchShapeException {
    if (shape instanceof Square) { 
        Square s = (Square)shape; 
        return s.side * s.side;
    } else if (shape instanceof Rectangle) {
        Rectangle r = (Rectangle)shape; 
        return r.height * r.width;
    } else if (shape instanceof Circle) {
        Circle c = (Circle)shape;
        return PI * c.radius * c.radius;
    }
        throw new NoSuchShapeException();
    }
}
```

想想看，如果给 Geometry 类添加一个 perimeter() 函数会怎么样。那些形状类根本不会因此而受影响！另一方面，如果添加一个新形状，就得修改 Geometry 中的所有函数来处理它，再读一遍代码，注意，这两种情形也是直接对立的。

现在考虑上述场景的另一种方法。

```Java
public class Square implements Shape {
  private Point topLeft;
  private double side;
  public double area() { 
    return side*side;
  } 
}

public class Rectangle implements Shape { 
  private Point topLeft;
  private double height;
  private double width;
  public double area() { 
    return height * width;
  } 
}

public class Circle implements Shape {
  private Point center;
  private double radius;
  public final double PI = 3.141592653589793;
  public double area() {
    return PI * radius * radius;
  } 
}
```

现在，与之前的案例相比，我们能很轻松的添加新形状，即数据结构。而且，如果我们只需在一个 Shape 类中添加 perimeter() 方法，则我们就必须在所有 Shapes 类中实现该函数，因为 Shapes 类是一个包含 area() 和 perimeter() 方法的接口。这意味着：

> **数据结构便于在不改动既有数据结构的前提下添加新函数。面向对象代码（使用对象）便于在不改动既有函数的前提下添加新类。**

反过来讲也说得通：

> **过程式代码（使用数据结构的代码）难以添加新的数据结构，因为必须修改所有的函数。面向对象代码难以添加新函数，因为必须修改所有的类。**

因此，对于面向对象困难的事情对于面向过程来说很容易，对于面向对象容易的事情对于面向过程来说很困难。

在任何复杂的系统中，我们有时会希望能够灵活的添加新的数据类型而不是新的函数。在这种情况下，对象和面向对象就是最合适的。另外一些时候，我们希望能灵活的添加新函数而不是数据类型。在这种情况下，过程式代码和数据结构将会更加合适。

老练的程序员知道，一切都是对象**只是一个传说**。有时，你真的想要在简单的数据结构上**做**一些过程试的操作。因此，你必须仔细思考要实现什么，也要考虑未来的前景，什么是容易更新的。在这个例子中，因为以后可能会添加其他新的形状，所以我会选择面向对象的方法。

---

我知道，在给定时间期限内完成你的工作，很难写好代码。但是你要耽搁多久呢？慢慢开始，坚持不懈。你的代码可以为你自己和其他人（主要受益者）创造奇迹。我已经开始，并且发现了许多我一直在犯的错误。虽然它每天占用我一些额外的时间，但将来我会得到报酬的。

> 这不是博客的结尾。我将继续编写关于代码整洁之道的新方法。此外，我还将写一些基础的设计模式，这是从事任何技术的开发者都必须了解的知识。

同时，如果你喜欢我的博客并从中获益，请鼓掌。它给了我更快创建新博客的动力 :) 欢迎进行评论/建议。不断学习，不断分享。

[**学习 Android APP 开发的完整指南**](https://mindorks.com/android-app-development-online-course)

**在 [mindorks.com](https://mindorks.com/android-tutorial) 上查看所有顶级教程**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
