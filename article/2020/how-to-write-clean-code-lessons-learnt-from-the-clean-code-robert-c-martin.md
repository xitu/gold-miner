> * 原文地址：[How to write clean code? Lessons learnt from “The Clean Code” — Robert C. Martin](https://medium.com/mindorks/how-to-write-clean-code-lessons-learnt-from-the-clean-code-robert-c-martin-9ffc7aef870c)
> * 原文作者：[Shubham Gupta](https://medium.com/@shubham08gupta)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-write-clean-code-lessons-learnt-from-the-clean-code-robert-c-martin.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-write-clean-code-lessons-learnt-from-the-clean-code-robert-c-martin.md)
> * 译者：
> * 校对者：

# How to write clean code? Lessons learnt from “The Clean Code” — Robert C. Martin

There are two things- Programming and Good Programming. Programming is what we have all been doing. Now is the time to do good programming. We all know that even the bad code works. But it takes time and resources to make a program good. Moreover, other developers mock you when they are trying to find what all is happening in your code. But it’s never too late to care for your programs.

This book has given me a lot of knowledge on what are the best practises and how to actually write code. Now I feel ashamed of my coding skills. Though I always strive to better my code, this book has taught a lot more.

Now, you are reading this blog for two reasons. First, you are a programmer. Second, you want to be a better programmer. Good. We need better programmers.

**Characteristics of a Clean code**:

1. It should be elegant — Clean code should be **pleasing** to read. Reading it should make you smile the way a well-crafted music box or well-designed car would.
2. Clean code is focused —Each function, each class, each module exposes a single-minded attitude that remains entirely undistracted, and unpolluted, by the surrounding details.
3. Clean code is taken care of. Someone has taken the time to keep it simple and orderly. They have paid appropriate attention to details. They have cared.

**4.** Runs all the tests

5. Contains no duplication

6. Minimize the number of entities such as classes, methods, functions, and the like.

## How to write Clean code?

## Meaningful Names

Use intention revealing names. Choosing good names takes time but saves more than it takes.The name of a variable, function, or class, should answer all the big questions. It should tell you why it exists, what it does, and how it is used. If a name requires a comment, then the name does not reveal its intent.

Eg- int d; // elapsed time in days.

> **We should choose a name that specifies what is being measured and the unit of that measurement.**

A better name would be:- int elapsedTime. (Even though the book says elapsedTimeInDays, I would still prefer the former one. Suppose the elapsed time is changed to milliseconds. Then we would have to change long to int and elapsedTimeInMillis instead of elapsedTimeInDays. And for how long we’ll keep changing both the data type and name.)

**Class Names** — Classes and objects should have noun or noun phrase names like Customer, WikiPage, Account, and AddressParser. Avoid words like Manager, Processor, Data, or Info in the name of a class. A class name should not be a verb.

**Method Names —**Methods should have verb or verb phrase names like postPayment, deletePage, or save. Accessors, mutators, and predicates should be named for their value and prefixed with get, set.

When constructors are overloaded, use static factory methods with names that describe the arguments. For example,

Complex fulcrumPoint = Complex.FromRealNumber(23.0); is generally better than Complex fulcrumPoint = new Complex(23.0);

**Pick One Word per Concept —**Pick one word for one abstract concept and stick with it. For instance, it’s confusing to have fetch, retrieve, and get as equivalent methods of different classes. How do you remember which method name goes with which class? Likewise, it’s confusing to have a controller and a manager and a driver in the same code base. What is the essential difference between a DeviceManager and a Protocol- Controller?

## Functions

![](https://cdn-images-1.medium.com/max/2000/1*-4gyjQwWkHbhW7Mbx5PBKw.png)

The first rule of functions is that they should be small. The second rule of functions is that they should be smaller than that. This implies that the blocks within if statements, else statements, while statements, and so on should be one line long. Probably that line should be a function call. Not only does this keep the enclosing function small, but it also adds documentary value because the function called within the block can have a nicely descriptive name.

#### Function arguments

A function shouldn’t have more than 3 arguments. Keep it as low as possible. When a function seems to need more than two or three arguments, it is likely that some of those arguments ought to be wrapped into a class of their own. Reducing the number of arguments by creating objects out of them may seem like cheating, but it’s not.

Now when I say to reduce a function size, you would definitely think how to reduce try-catch as it already makes your code so much bigger. My answer is make a function containing just the try-catch-finally statements. And separate the bodies of try/catch/finally block in a separate functions. Eg-

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

This makes the logic crystal clear. Function names easily describe what we are trying to achieve. Error handling can be ignored. This provides a nice separation that makes the code easier to understand and modify.

**Error Handling is one thing** — Function should do one thing. Error handling is one another thing. If a function has try keyword then it should be the very first keyword and there should be nothing after the catch/finally blocks.

#### Comments

If you are writing comments to prove your point, you are doing a blunder. Ideally, comments are not required at all. If your code needs commenting, you are doing something wrong. Our code should explain everything. Modern programming languages are english like through which we can easily explain our point. Correct naming can prevent comments.

Legal comments are not considered here. They are necessary to write. Legal comments means copyright and licenses statements.

#### Objects and Data Structures

This is a complex topic so pay good attention to it. First we need to clarify the difference between object and Data Structures.

> **Objects hide their data behind abstractions and expose functions that operate on that data. Data structure expose their data and have no meaningful functions.**

These 2 things are completely different. One is just about storing data and other is how to manipulate that data. Consider, for example, the procedural shape example below. The Geometry class operates on the three shape classes. The shape classes are simple data structures without any behavior. All the behavior is in the Geometry class.

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

Consider what would happen if a perimeter() function were added to Geometry. The shape classes would be unaffected! Any other classes that depended upon the shapes would also be unaffected! On the other hand, if I add a new shape, I must change all the functions in Geometry to deal with it. Again, read that over. Notice that the two conditions are diametrically opposed.

Now consider another approach for the above scenario.

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

Now we can easily add new Shapes i.e. data structures as compared to previous case. And if we have to add perimeter() function in only one Shape, we are forced to implement that function in all the Shapes as Shape class is an interface containing area() and perimeter() function. This means:

> **Data structures makes it easy to add new functions without changing the existing data structures. OO code(using objects), makes it easy to add new classes without changing existing functions.**

The complimentary is also true:

> **Procedural code(using data structures) makes it hard to add new data structures because all the functions must change. OO code makes it hard to add new functions because all the classes must change.**

So, the things that are hard for OO are easy for procedures, and the things that are hard for procedures are easy for OO!

In any complex system there are going to be times when we want to add new data types rather than new functions. For these cases objects and OO are most appropriate. On the other hand, there will also be times when we’ll want to add new functions as opposed to data types. In that case procedural code and data structures will be more appropriate.

Mature programmers know that the idea that everything is an object **is a myth**. Sometimes you really **do** want simple data structures with procedures operating on them. So you have to carefully think what to implement also thinking about the future perspective that what will be easy to update. As for in this example, as any new shape can be added in the future, I will pick OO approach for it.

---

I understand it’s hard to write good programs given the timeline in which you have to do your tasks. But till how long you’ll delay? Start slow and be consistent. Your code can do wonders for yourself and mostly for others. I’ve started and found so many mistakes I’ve been doing all the time. Though it has taken some extra hours of my daily time limit, it will pay me in the future.

> This is not an end to this blog. I will continue to write about new ways to clean your code. Moreover, I will also write about some basic design patterns which are must know for every developer in any technology.

In the mean time, if you like my blog and learnt from it, please applause. It gives me motivation to create a new blog faster :) Comments/Suggestions are welcomed as always. Keep learning and keep sharing.

[**A complete guide for learning Android App development**](https://mindorks.com/android-app-development-online-course)

**Check out all the top tutorial at [mindorks.com](https://mindorks.com/android-tutorial)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
