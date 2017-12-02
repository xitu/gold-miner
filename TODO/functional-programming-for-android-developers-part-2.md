> * 原文地址：[Functional Programming for Android developers?—?Part 2](https://medium.com/@anupcowkur/functional-programming-for-android-developers-part-2-5c0834669d1a#.r6495260x)
* 原文作者：[Anup Cowkur](https://medium.com/@anupcowkur)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [tanglie1993](https://github.com/tanglie1993)
* 校对者：[skyar2009](https://github.com/skyar2009), [phxnirvana](https://github.com/phxnirvana)

---

# Android 开发者如何使用函数式编程 （二） 

![](https://cdn-images-1.medium.com/max/1600/1*1-2UBc_3rxKqKn89iMN2nQ.jpeg)

如果你没有读过第一部分，请到这里读：

- [Android 开发者如何函数式编程 （一）](https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-for-android-developers-part-1.md)
- [Android 开发者如何函数式编程 （三）](https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-for-android-developers-part-3.md)

在上一篇帖子中，我们学习了**纯粹性*、**副作用**和**排序**。在本部分中，我们将讨论**不变性**和**并发**。

### 不变性

不变性是指一旦一个值被创建，它就不可以被修改。

假设我有一个像这样的 *Car* 类：

    public final class Car {
        private String name;
    
        public Car(final String name) {
            this.name = name;
        }
    
        public void setName(final String name) {
            this.name = name;
        }
    
        public String getName() {
            return name;
        }
    }

因为它有一个 setter，我可以在创建之后修改车的名称：

    Car car = new Car("BMW");
    car.setName("Audi");

这个类**不是**不可变的。他在创建之后可以被改变。

我们把它变成不可变的。要做到这一点，我们必须：

- 把 name 变量设为 *final*。
- 移除 setter。
- 把这个类也设为 *final*，这样另一个类就不可以继承它并修改它的内容。

```
public final class Car {
    private final String name;

    public Car(final String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
```

如果现在有人需要创建一个新的 car，他们需要初始化一个新的对象。没有人可以在 car 被创建之后修改它。这个类现在是**不可变**的了。

但是 *getName()* 方法呢？它在把名称返回给外部世界对吧？如果有人在通过 getter 取得引用之后修改了 *name* 的值怎么办？

在 Java 中，[string在默认情况下是不可变的](http://stackoverflow.com/questions/1552301/immutability-of-strings-in-java)。哪怕有人获得了对 *name*  string 的引用并修改它，他们也只能得到 *name*  string 的拷贝，原先的 string 保持不变。

但是可变的东西怎么办？比如一个 list？我们修改一下 *Car* 类，使它具有一个驾驶员的 list。

    public final class Car {
        private final List<String> listOfDrivers;
    
        public Car(final List<String> listOfDrivers) {
            this.listOfDrivers = listOfDrivers;
        }
    
        public List<String> getListOfDrivers() {
            return listOfDrivers;
        }
    }

在这种情况下，有人可以通过 *getListOfDrivers()* 方法取得我们内部 list 的一个引用，并修改这个 list。这样，我们的类就是**可变**的了。

要让它不可变，我们必须在 getter 中返回一个 list 的深度拷贝。这样，新的 list 就可以被调用者安全地修改。深度拷贝的含义是我们递归地复制所有依赖它的数据。例如，如果这是一个 *Driver* 类的 list而不是简单的 string 列表，我们就必须复制每一个 *Driver* 对象。否则，我们就会创建一个新的 list，其内容是对原先 *Driver* 对象的引用，而这些对象是可变的。在我们的类中，由于这个 list 是由不可变的 string 组成的，我们可以这样创建一个深度拷贝：

    public final class Car {
        private final List<String> listOfDrivers;
    
        public Car(final List<String> listOfDrivers) {
            this.listOfDrivers = listOfDrivers;
        }
    
        public List<String> getListOfDrivers() {
            List<String> newList = new ArrayList<>();
            for (String driver : listOfDrivers) {
                newList.add(driver);
            }
            return newList;
        }
    }

现在这个类就是真正**不可变**的了。

### 并发

好了，**不可变**是很酷，但为什么要用它？我们在第一部分中已经讨论过，纯函数让我们很容易地实现并发。而且，如果一个对象是不可变的，它就很容易在纯函数中使用，因为你不能通过改变它而造成副作用。

来看一个例子。假设我们在 *Car* 中添加一个 *getNoOfDrivers* 方法，并允许外部调用者修改 driver 的数量，从而使它可变：

    public class Car {
        private int noOfDrivers;
    
        public Car(final int noOfDrivers) {
            this.noOfDrivers = noOfDrivers;
        }
    
        public int getNoOfDrivers() {
            return noOfDrivers;
        }
    
        public void setNoOfDrivers(final int noOfDrivers) {
            this.noOfDrivers = noOfDrivers;
        }
    }

假设有两个线程共享 *Car* 类的实例：*Thread_1* 和 *Thread_2*。*Thread_1* 需要基于 driver 的数量做一些计算，所以它调用了 *getNoOfDrivers()*。同时 *Thread_2* 开始执行，并修改了 *noOfDrivers* 变量。*Thread_1* 并不知道这个改变，愉快地继续它的计算。这些计算是不对的，因为 *Thread_2* 已经修改了变量的状态，而 *Thread_1* 并不知道。

下面的流程图说明了这个问题：

![](https://cdn-images-1.medium.com/max/2000/1*PXDu-vgwZ6hmh96lc5TYOg.png)

这是一个名为“读-修改-写问题”的典型资源竞争。传统的解决方案是使用[锁和互斥](https://en.wikipedia.org/wiki/Mutual_exclusion)。这样，同时只有一个线程可以操纵共享数据，在操作结束之后才释放锁（在我们的例子中，*Thread_1* 将持有对 *Car* 的锁，直到它完成计算）。

这种基于锁的资源管理是很难以保证安全的。它会造成极其难以分析的并发 bug。许多程序员在面对[死锁和活锁](https://en.wikipedia.org/wiki/Deadlock)时会失去理智。

不可变性如何解决这个问题呢？我们再次把 *Car* 设为不可变：

    public final class Car {
        private final int noOfDrivers;
    
        public Car(final int noOfDrivers) {
            this.noOfDrivers = noOfDrivers;
        }
    
        public int getNoOfDrivers() {
            return noOfDrivers;
        }
    }

现在，*Thread_1* 可以放心地计算，因为 *Thread_2* 保证无法修改这个对象。如果 *Thread_2* 想要修改 *Car*，那么它将会创建它自己的拷贝，而 *Thread_1* 完全不会受到影响。不需要任何锁。

![](https://cdn-images-1.medium.com/max/2000/1*EyBmNH__K0QlOfapgib_rg.png)

不可变性保证共享数据在默认状况下就是线程安全的。**不应该**被修改的东西是**不能**被修改的。

#### 如果我们需要全局可变状态怎么办？

要写出有用的应用，我们在很多情况下需要共享可变的状态。我们可能会真正需要更新 *noOfDrivers* ，并把改变反映到整个系统中去。我们在下一章讨论**函数式架构**时，将使用状态隔离处理这种情况，并把副作用推到系统的边缘。

### 持久数据结构

不可变对象可能很好，但如果我们不加限制地使用它们，它们将会给垃圾回收器造成负担，从而导致性能问题。函数式编程向我们提供具有不可变性，并能最小化对象创建的数据结构。这些专门化的数据结构被称为**持久数据结构**。

持久数据结构在被修改时，总会保留自己之前的版本。这些数据结构实际上是不可变的。对它们的操作不会（可见地）更新数据结构，而是返回一个新的修改过的结构。

假设我们需要把这些 string 存储在内存中：**reborn, rebate, realize, realizes, relief, red, redder**。

我们可以分开储存它们，但这需要的内存超出必要的限度。如果仔细看的话，我们可以看到这些 string 有很多共同的字符，我们可以用一个 [*trie*](https://en.wikipedia.org/wiki/Trie) 树储存它们（并不是所有的 trie 树都是持久的，但它是我们用来实现持久数据结构的工具之一）：

![](https://cdn-images-1.medium.com/max/1600/1*5_7HbxMEMGRmpPkxlUnIHA.png)

这是持久数据结构的基本工作原理。如果一个新的 string 被加入，我们就创建一个新的节点，并把它链接到正确的位置。如果一个使用这个结构的对象需要删除一个节点，我们只要停止引用它即可。然而，实际的节点不会被从内存中删除，这样副作用就可以被避免。这保证引用这个数据结构的其它对象可以继续使用它。如果没有其它对象引用它，我们可以回收整个结构以收回内存。

在 Java 中使用持久数据结构并不是一个激进的想法。[Clojure](https://clojure.org/) 是一个函数式语言，它在 JVM 上运行，并有一整个标准库的持久数据结构。你可以在 Android 代码中直接使用 Clojure 的标准库，但它很大而且有很多方法。我找到了一个更好的替代方法：一个叫做 [PCollections](https://pcollections.org/) 的库。它有 [427 个方法和 48Kb dex 文件大小](http://www.methodscount.com/?lib=org.pcollections%3Apcollections%3A2.1.2) ，很适合我们的需要。

作为一个例子，这是我们使用 PCollections 创建并使用一个持久链表时的情形：

    ConsPStack<String> list = ConsPStack.*empty*();
    System.*out*.println(list);  // []
    
    ConsPStack<String> list2 = list.plus("hello");
    System.*out*.println(list);  // []
    System.*out*.println(list2); // [hello]
    
    ConsPStack<String> list3 = list2.plus("hi");
    System.*out*.println(list);  // []
    System.*out*.println(list2); // [hello]
    System.*out*.println(list3); // [hi, hello]
    
    ConsPStack<String> list4 = list3.minus("hello");
    System.*out*.println(list);  // []
    System.*out*.println(list2); // [hello]
    System.*out*.println(list3); // [hi, hello]
    System.*out*.println(list4); // [hi]

可见，没有任何一个 list 是在原位被修改的。每次进行一个修改时，它都会返回一个新的拷贝。

PCollections 有一些标准持久数据结构。它们是针对多种不同的用例实现的，都很值得探索。他们都很适合与易用的 Java 的标准集合库一起使用。

持久数据结构的范围是很广泛的，而这一部分只是触及了冰山的一角。如果你对学习更多相关知识感兴趣，我强烈推荐 [Chris Okasaki 的纯函数数据结构](https://www.amazon.com/Purely-Functional-Structures-Chris-Okasaki/dp/0521663504)。

### 总结

**不可变性**和**纯粹性**是帮助我们写出安全的并发代码的强力组合。现在我们已经学习了足够多的概念，我们可以在下一部分中看一看如何为 Android 应用设计函数式框架。

### **额外内容**

我在 Droidcon India 中做了一个关于不可变性和并发的报告。希望你们喜欢。

[![](https://i.ytimg.com/vi_webp/lE9XnvBV-ys/sddefault.webp)](https://www.youtube.com/embed/lE9XnvBV-ys?wmode=opaque&widget_referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F77eb6effeadb0e8ce1fd46d5f9efdc2c%3FpostId%3D5c0834669d1a&enablejsapi=1&origin=https%3A%2F%2Fcdn.embedly.com&widgetid=1)
