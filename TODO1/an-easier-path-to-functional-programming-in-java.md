> * 原文地址：[An easier path to functional programming in Java](https://www.ibm.com/developerworks/library/j-java8idioms1/)
> * 原文作者：[Venkat Subramaniam](https://developer.ibm.com/author/venkats/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-easier-path-to-functional-programming-in-java.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-easier-path-to-functional-programming-in-java.md)
> * 译者：[maoqyhz](https://github.com/maoqyhz)
> * 校对者：

# 一种更简单的途径在 Java 中进行函数式编程

## 以声明式的思想在你的 Java 程序中使用函数式编程技术

Java™ 开发人员习惯于面向命令式和面向对象的编程，因为这些特性自 Java 语言首次发布以来一直受到支持。在 Java 8 中，我们获得了一组新的强大的函数式特性和语法。函数式编程已经存在了数十年，与面向对象编程相比，函数式编程通常更加简洁和达意，不易出错，并且更易于并行化。所以有很好的理由将函数式编程特性引入到Java程序中。尽管如此，在使用函数式特性进行编程时，就如何设计你的代码这一点上需要进行一些改变。

**关于本文**

Java 8 自 Java 语言诞生以来就是其最重要的更新，它包含丰富的新特性，以至于你可能想知道从哪开始了解它。在本文中，身为作家和教育家的 Venkat Subramaniam 提供了 Java 8 的一般用法。邀请你进行简短的探索后，重新思考你认为理所当然的 Java 一贯用法和规范，同时逐渐将新技术和语法集成到你的程序中去。

我认为，以声明式的思想而不是命令式的思想来编程，可以更加轻松地向更加函数化的编程风格过渡。在 [_Java 8 idioms_ series](http://www.ibm.com/developerworks/library/?series_title_by=Java+8+idioms) 这个系列的第一篇文章中，我解释了命令式，声明式和函数式编程风格之间的异同。然后，我将向你展示如何使用声明式的思想逐渐将函数式编程技术集成到你的 Java 程序中。

## 命令式风格（面向过程）

受命令式编程风格训练的开发者习惯于告诉程序需要做什么以及如何去做。这里是一个简单的例子：

<h5 id="listing1">清单 1. 以命令式风格编写的 findNemo 方法</h5>

```
import java.util.*;

public class FindNemo {
  public static void main(String[] args) {
    List<String> names = 
      Arrays.asList("Dory", "Gill", "Bruce", "Nemo", "Darla", "Marlin", "Jacques");

    findNemo(names);
  }                 
  
  public static void findNemo(List<String> names) {
    boolean found = false;
    for(String name : names) {
      if(name.equals("Nemo")) {
        found = true;
        break;
      }
    }
    
    if(found)
      System.out.println("Found Nemo");
    else
      System.out.println("Sorry, Nemo not found");
  }
}
```

方法 `findNemo()` 首先初始化一个可变变量 **flag**，也成为垃圾变量（garbage variable）。开发者经常会给予某些变量一个临时性的名字，例如 `f`、`t`、`temp`。这表明了我们普遍的态度，这些变量是不应该存在的。在这种情况下，这些变量应该被命名为 `found`。

接下来，程序会循环遍历给定的 `names` 列表，每次都会判断当前遍历的值是否和待匹配值相同。在这个例子中，待匹配值为 `Nemo`，如果遍历到的值匹配，程序会将标志位设为 `true`，并执行流程控制语句"break"跳出循环。

这是对于广大 Java 开发者最熟悉的编程风格 —— 命令式风格的程序，因此你可以定义程序的每一步：你告诉程序遍历每一个元素，和待匹配值进行比较，设置标志位，以及跳出循环。命令式编程风格让你可以完全控制程序，有的时候这是一件好事。但是，换个角度来看，你做了很多机器可以独立完成的工作，这势必导致生产力下降。因此，有的时候，你可以通过少做事来提高生产力。

## 声明式风格

声明式编程意味着你仍然需要告诉程序需要做什么，但是你可以将实现细节留给底层函数库。让我们看看使用声明式编程风格重写 [清单 1](#listing1) 中的 `findNemo` 方法时会发生什么：

##### 清单 2. 以声明式风格编写的 findNemo 方法

```
public static void findNemo(List<String> names) {
  if(names.contains("Nemo"))
    System.out.println("Found Nemo");
  else
    System.out.println("Sorry, Nemo not found");
}
```

首先需要注意的是，此版本中没有任何垃圾变量。你也不需要在遍历集合中浪费精力。相反，你只需要使用内建的 `contains()` 方法来完成这项工作。你仍然需要告诉程序需要做什么，集合中是否包含我们正在寻找的值，但此时你已经将细节交给底层的方法来实现了。 

在命令式编程风格的例子中，你控制了遍历的流程，程序可以完全按照指令进行；在声明式的例子中，只要程序能够完成工作，你完全需要关注它是如何工作的。`contains()` 方法的实现可能会有所不同，但只要结果符合你的期望，你就会对此感到满意。更少的工作能够得到相同的结果。

训练自己以声明式的编程风格来进行思考将更加轻松地向更加函数化的编程风格过渡。原因在于，函数式编程风格是建立在声明式风格之上的。声明式风格的思维可以让你逐渐从命令式编程转换到函数式编程。

## 函数式编程风格

虽然函数式风格的编程总是声明式的，但是简单地使用声明式风格编程并不等同与函数式编程。这是因为函数式编程时将声明式编程和高阶函数结合在了一起。图 1 显示了命令式，声明式和函数式编程风格之间的关系。

##### 图 1. 命令式、声明式和函数式编程风格之间的关系

![A logic diagram showing how the imperative, declarative, and functional programming styles differ and overlap.](https://www.ibm.com/developerworks/library/j-java8idioms1/fig1.png)

### Java 中的高阶函数

在 Java 中，你可以将对象传递给方法，在方法中创建对象，也可以从方法中返回对象。同时你也可以用函数做相同的事情。也就是说，你可以将函数传递给方法，在方法中创建函数，也可以从方法中返回函数。

在这种情况下，**方法**是类的一部分（静态或实例），但是函数可以是方法的一部分，并且不能有意地与类或实例相关联。一个可以接收、创建、或者返回函数的方法或函数称之为**高阶函数**。

## 一个函数式编程的例子

采用新的编程风格需要改变你对程序的看法。这是一个可以用简单的例字练习的过程。函数式编程可以构建更复杂的程序。

<h5 id="listing3">清单 3. 命令式编程风格下的 Map</h5>

```
import java.util.*;

public class UseMap {
  public static void main(String[] args) {
    Map<String, Integer> pageVisits = new HashMap<>();            
    
    String page = "https://agiledeveloper.com";
    
    incrementPageVisit(pageVisits, page);
    incrementPageVisit(pageVisits, page);
    
    System.out.println(pageVisits.get(page));
  }
  
  public static void incrementPageVisit(Map<String, Integer> pageVisits, String page) {
    if(!pageVisits.containsKey(page)) {
       pageVisits.put(page, 0);
    }
    
    pageVisits.put(page, pageVisits.get(page) + 1);
  }
}
```

在 [清单 3](#listing3) 中，`main()` 函数创建了一个 `HashMap` 来保存网站访问次数。同时，`incrementPageVisit()` 方法增加了每次访问给定页面的计数。我们将聚焦次方法。

以命令式编程风格写的 `incrementPageVisit()` 方法：它的工作是为给定页面增加一个计数，并存储在 `Map` 中。该方法不知道给定页面是否已经有计数值，所以会先检查计数值是否存在，如果不存在，会为该页面插入一个值为"0"的计数值。然后再获取该计数值，递增它，并将新的计数值存储在 `Map` 中。

以声明式的方式思考需要你将方法的设计从"how"转变到"what"。当 `incrementPageVisit()` 方法被调用时，你需要将给定的页面计数值初始化为 1 或者计数值加 1。这就是 **what**。

因为你是通过声明式编程的，那么下一步就是在 JDK 库中寻找可以完成这项工作且实现了 `Map` 接口的方法。换言之，你需要找到一个知道**如何**完成你指定任务的内建方法。

事实证明 `merge()` 方法非常适合你的而目的。清单 4 使用新的声明式方法对 [清单 3](#listing3) 中的 `incrementPageVisit()` 方法进行修改。但是，在这种情况下，你不仅仅只是选择更智能的方法来写出更具声明性风格的代码，因为 `merge()` 是一个更高阶的函数。所以说，新的代码实际上是一个体现函数式风格的很好的例子：

<h5 id="listing4">清单 4. 函数式编程风格下的 Map</h5>

```
public static void incrementPageVisit(Map<String, Integer> pageVisits, String page) {
    pageVisits.merge(page, 1, (oldValue, value) -> oldValue + value); 
}
```

在清单 4 中，`page` 作为第一个参数传递给 `merge()`：map 中键对应的值将会被更新。第二个参数作为初始值，**如果** `Map` 中不存在指定键的值，那么该值将会赋值给 `Map` 中键对应的值（在本例中为"1"）。第三个参数为一个 lambda 表达式，接受当前 `Map` 中键对应的值和该函数中第二个参数对应的值作为参数。lambda 表达式返回其参数的总和，实际上增加了计数值。（**编者注**：感谢 István Kovács 修正了代码错误）

将 [清单 4](#listing4) 的 `incrementPageVisit()`方法中的单行代码与 [清单 3](#listing3) 中的多行代码进行比较。虽然 [清单 4](#listing4) 中的程序是函数式编程风格的一个例子，但通过声明性地思想去思考问题帮助能够我们实现飞跃。

## 总结

在 Java 程序中采用函数式编程技术和语法有很多好处：代码更简洁，表达更多样化，移动部分更少，实现并行化更容易，并且通常比面向对象的代码更易理解。 目前面临的挑战是，如何将你的思维从绝大多数开发人员所熟悉的命令式编程风格转变为以声明式的方式进行思考。

虽然函数式编程并没有那么简单或直接，但是你可以学习专注于你希望程序**做什么**而不是**如何做**这件事，来取得巨大的飞跃。通过允许底层函数库管理执行，你将逐渐直观地了解用于构建函数式编程模块的高阶函数。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
