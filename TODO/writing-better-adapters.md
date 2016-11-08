> * 原文地址：[Writing Better Adapters](https://medium.com/@dpreussler/writing-better-adapters-1b09758407d2)
* 原文作者：[Danny Preussler](https://medium.com/@dpreussler)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Siegen](https://github.com/siegeout)
* 校对者：[Liz](https://github.com/lizwangying),[张拭心](https://github.com/shixinzhang)

# 关于 Android Adapter，你的实现方式可能一直都有问题

对Android 开发者来说实现 adapter 是最常见的任务之一。它是每一个列表的基础。看看市面上的应用，列表是大部分应用的基础。


我们实现列表 view  的方式通常是一样的：一个 view 搭配一个装载着数据的 adapter。一直这样做可能会让我们忽视了我们正在写的东西，甚至是糟糕的代码。更糟的是，我们通常会一直重复那些糟糕的代码。


是时候仔细看看这些 adapter 。

### RecyclerView 的基本操作

RecyclerView （ ListView 也适用）基本使用方式如下：

*    创建 view  以及容纳 view  信息的 ViewHolder 。
*    把 ViewHolder 与 adapter 装载的数据相绑定，这些数据可能是一系列的 model 类。



实现这些操作一气呵成并且也不会出现太多错误。

### 有着不同类型的 RecyclerView



当你在你的 view  里需要有不同类型的 item（条目）时，实现 adapter 会变得更加困难。也许是因为你使用 CardView 或者你需要在你的控件里插入广告，使得基础的 item 有了不同类型的卡片样式。甚至你可能有一系列完全不同类型的对象（本文使用 [Kotlin](https://kotlinlang.org/) 来举例，但是它可以被轻松的应用到 Java 中，因为在这里没有使用 kotlin 特有的语法。））

    interface Animal
    class Mouse: Animal
    class Duck: Animal
    class Dog: Animal
    class Car


在这里，你有好几种动物，然后突然出现了一个完全不相干的汽车。。


在这个使用情况里，你可能用不同的 view  类型用来展示。 这意味着你可能还需要在每个 ViewHolder 中解析不同的布局。API 把类型的标识码定义为 integers（整型数），这就是糟糕代码开始的地方！



 


让我们来看一些代码。当你的 item 有两个以上的类型时，，由于它们的默认实现总是返回零，你通常需要通过覆写这个方法来声明它们：

    override fun getItemViewType(position: Int) : Int

这个实现把类型转换成 Integer 值。


下一步：创建 ViewHolder。你不得不实现下面这个方法：

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder



在这个方法里，API 把你之前传递的 Integer 类型作为参数。接下来的实现非常常见：用一个 switch 语句，或者类似的东西（if-else），为每个给定类型创建对应的 ViewHolder 。


不同的地方在于当绑定新创建的（或者复用的）ViewHolder 的时候：

    override fun onBindViewHolder(holder: ViewHolder, position: Int): Any

注意这里没有类型参数。如果有必要的话你可以使用 getItemViewType 方法，但通常这是没必要的。在所有 ViewHolder 的基类里，你可以做绑定 bind () 操作。

### 槽糕之处


所以现在的问题是什么？这样做看起来很容易实现，不是么？


让我们再看一次 getItemViewType()。

这个系统需要每个位置的类型。所以你不得不在你背后的 model 列表中，把一个 item 转成一个 view  类型。

你可能想要这样写：

    if (things.get(position) is Duck) {
        return TYPE_DUCK
    } else if (things.get(position) is Mouse) {
        return TYPE_MOUSE
    }

这样写代码真的很糟糕。如果你的 ViewHolder 没有继承自一个共同基础类，这会变得更糟。当你绑定 ViewHolder 的时候，如果它们是完全不同的类型，在你的列表中你会有同样糟糕的代码。


许多的 instance-of 检查和转型，这真是一团糟。这两个都是坏代码的味道，这种写法，通常被认为是[反面模式](http://www.yegor256.com/2015/04/02/class-casting-is-anti-pattern.html)的例子。

许多年前，我在我的显示器上贴了许多的名言。其中的一个来自  Scott Meyers 写的[《Effective C++》 ](https://books.google.de/books/about/Effective_C++.html?id=eQq9AQAAQBAJ&source=kp_cover&redir_esc=y) 这本书（最好的IT书籍之一），它是这么说的：

> 不管什么时候，只要你发现自己写的代码类似于 “ if the object is of type T1, then do something, but if it’s of type T2, then do something else ”，就给自己一耳光。


如果你看到那些 adapter 的实现，应该有许多的耳光需要你去扇了。

*   我们有类型检查并且我们有许多糟糕的转型。
*   这完全不是面向对象的代码。面向对象编程刚刚庆祝了它的 50 岁生日，我们应该尽力去发挥它的长处。
*   另外，我们实行那些 adapter 的方法违背了 [SOLID](https://en.wikipedia.org/wiki/SOLID_%28object-oriented_design%29) 原则中的“[开闭准则](https://en.wikipedia.org/wiki/Open/closed_principle)” 。它是这样说的：“对扩展开放，对修改封闭。” 当我们添加另一个类型或者 model 到我们的类中时，比如叫 Rabbit 和 RabbitViewHolder，我们不得不在 adapter 里改变许多的方法。 这是对开闭原则明显的违背。添加新对象不应该修改已存在的方法。


### 让我们解决这个问题

一个替代方案是在中间添加一个东西为我们做转换。这跟把你的 Class 类型放入到 Map 中一样简单并且可以通过函数调用来获取相应的类型。这个方案基本是这样的：

    override fun getItemViewType(position: Int) : Int
       = types.get(things.javaClass)

现在它已经好多了，不是么？答案令人难过：这并不够好！这个方案只是把 instance-of 检查隐藏了起来而已。


你会如何实现上文提到的 onBindViewholder() 方法？可能会是这样：if object is of type T1 then do.. else… ，这样你仍然需要给自己一耳光。



我们的目标应该是在不修改 adapter 的情况下能够添加新的类型。



所以：不要一开始就在 view  和 model 之间的 adapter 里创建你自己的类型映射。Google 建议使用布局 id。利用这个技巧，你可以简单的使用你正在填充的布局 id 而不需要人为制作类型映射。当然你可能会把另一个枚举类型保存成 [perfmatters](https://twitter.com/hashtag/perfmatters)。



但是你仍然需要把它们互相关联到一起么？要怎么做呢？



在最后你需要把 model 与 view  关联在一起。这里面的关联信息能够迁移到 model 里面吗？




把 item 类型放进你的 model 里是很诱人的，就像这样。

    fun getType() : Int = R.layout.item_duck


这种 adapter 类型的实现方式是完全通用的：

    override fun getItemViewType(pos: Int) = things[pos].getType()


开闭原则被应用了，当添加新的 model 时无需做多余的改变。


但是这样做，布局层完全混合在一起不说，还破坏了整体结构。实体直接对外展示，这样的展示方向是错误的。[这对我们来说是完全不能接受的](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html)。并且：在一个对象里面添加方法来询问它的类型，这不是面向对象。你只是再一次的隐藏了 instance-of 检查而已。

### ViewModel


解决这个问题的一个方法是：拥有独立的 ViewModel 而不是直接使用我们的 Model。我们的问题是我们的 model 是互不关联的，他们没有一个共同的基类：一辆车不是一个动物。这是对的。只有 presenter 层你需要在列表里展示它们。所以当你为 presenter 层展示这些 model 时没有这个问题，他们可以拥有一个共同的基类也就是 ViewModel。

    abstract class ViewModel {
        abstract fun type(): Int
    }
    class DuckViewModel(val duck: Duck): ViewModel() {
        override fun type() = R.layout.duck
    }
    class CarViewModel(val car: Car): ViewModel() {
        override fun type() = R.layout.car
    }




所以你可以简单包装下 model ,完全不需要修改它们，然后在新的 ViewModel 中保留它对应的 model ，这样你还可以添加所有的逻辑代码并且还能使用 Android 最新的 [Data Binding Library](https://developer.android.com/topic/libraries/data-binding/index.html)。


在 adapter 里使用 ViewModel list 而不是 Model 的这个点子很有用，尤其是当你需要额外添加的 item 的时候，类似 divider ，header或者只是广告 item。


这是解决这个问题的一个方法，但不是唯一的一个。


### 访问者模式


让我们回归原点，只使用 Model。假如你有许多的 model 类，不想为每一个 model 创建对应的 ViewModel。想想最开始 model 里的 type() 方法，这个过程缺失了必要的解耦。要避免在 model 里直接写入 presenter 层的代码，间接的使用它，把实际的类型信息迁移到其他地方。那么不如在 type() 方法里添加一个接口：

    interface Visitable {
        fun type(typeFactory: TypeFactory) : Int
        }



现在你可能会问你在这里这样做有什么好处，因为工厂方法仍然需要给不同的 item 类型分流，就像在最开始的时候 adapter 做的一样，是这样么？


不，这完全不一样！这个方法是建立在[访问者模式](https://en.wikipedia.org/wiki/Visitor_pattern)之上的，一个典型的[四人帮设计模式](https://en.wikipedia.org/wiki/Design_Patterns)。所有的 model 都会调用如下方法：：

    interface Animal : Visitable
        interface Car : Visitable

    class Mouse: Animal {
        override funtype(typeFactory: TypeFactory)
            = typeFactory.type(this)
            }



这个工厂方法拥有你需要的变化：

    interface TypeFactory {
        fun type(duck: Duck): Int
        fun type(mouse: Mouse): Int
        fun type(dog: Dog): Int
        fun type(car: Car): Int
        }



这种方式是完全的类型安全，没有 instance-of 检查，也根本不需要转型。

这个工厂方法的责任是明确的：它知道所有的 view  类型：


    class TypeFactoryForList : TypeFactory {
        override fun type(duck: Duck) = R.layout.duckoverride fun type(mouse: Mouse) = R.layout.mouse    
        override fun type(dog: Dog) = R.layout.dogoverride fun type(car: Car) = R.layout.car




我也可以创建 ViewHolder 在某个地方持有关于布局 id 的信息。所以当添加一个新 view  的时候，这个地方也跟着添加。这是相当符合 SOLID 原则的。你可能需要为新的类型创建另一个方法，但是不修改任何存在的方法：对扩展开放，对修改封闭。



现在你可能会问:为什么不直接在 adapter 里使用工厂方法而是间接的使用 model 呢？通过这个方式你可以不需要转型和类型检查就可以确保类型安全。花点时间在这里实现它，这不是一个需要的转型！间接引用正是访问者模式背后的魔法。


通过这个方法使得 adapter 拥有一个非常通用的实现，并且几乎不需要变化。


### 结论



*   尽力保持你的 presenter 层代码干净。
*   Instance-of 检查应该是一个警告标志，尽量不要使用!
*   注意向下转型，因为这是坏代码的味道.
*   尽量把上面两个替换成正确的面向对象用法。考虑下接口和继承。
*   尽量使用通用的方式来避免转型。
*   使用 ViewModel。
*   检查访问者模式的使用方式。

我很乐意了解到更多其他的想法来使我们的 adapter 保持整洁。
