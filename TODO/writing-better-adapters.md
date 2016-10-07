> * 原文地址：[Writing Better Adapters](https://medium.com/@dpreussler/writing-better-adapters-1b09758407d2)
* 原文作者：[Danny Preussler](https://medium.com/@dpreussler)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Siegeout](https://github.com/siegeout)
* 校对者：

Implementing adapters is one of the most frequent tasks for an Android developer. It’s the base for every list. Looking at apps, lists are the base of most apps.

对 Android 开发者来说,实现适配器是最常见的任务之一。它是每一个列表的基础。看看市面上的应用，列表是大部分应用的基础。

The schema we follow to implement list views is often the same: a View with an adapter that holds the data. Doing this all the time can make us blind to what we are writing, even to ugly code. Even worse, we end up repeating that ugly code.

我们实现列表视图的方式通常是一样的：一个视图搭配一个装载着数据的适配器。一直这样做可能会让我们忽视了我们正在写的东西，甚至是糟糕的代码。更糟的是，我们通常会一直重复那些糟糕的代码。

It’s time to take a close look into adapters.

是时候仔细看看这些适配器。

### RecyclerView Basics
### RecyclerView 的基本操作

The basic operations for RecyclerViews (but also applicable for ListView) are:

*   Creating the view and the ViewHolder that holds the view information.
*   Binding the ViewHolder to the data that the adapter holds, probably a list of model classes.

对于 RecyclerViews（对于 ListView 也适用）来说基本的操作是这样的：

*    创建视图以及容纳视图信息的 ViewHolder 。
*    把 ViewHolder 与适配器装载的数据相绑定，这些数据可能是一系列的模型类。


Implementing this is pretty straightforward and not much can be done wrong here.

这样实现是相当直接的并且也不会出现太多错误。

### RecyclerView With Different Types
### 有着不同类型的 RecyclerView


It gets trickier when you need to have different kind of items in your views. It might be different kind of cards in case you use CardViews or could be ads stitched in between your elements. You might even have a list of completely different kind of objects (this article uses [Kotlin[1]](https://kotlinlang.org/) but it can be easily applied to Java as no language specific feature are used)

    interface Animal
    class Mouse: Animal
    class Duck: Animal
    class Dog: Animal
    class Car

当你在你的视图里需要有不同类型的 item（条目）时，实现适配器会变得更加困难。也许是因为你使用 CardViews 或者你需要在你的控件里插入广告，使得基础的 item 有了不同类型的卡片样式。甚至你可能有一系列完全不同类型的对象（这篇文章使用 [Kotlin](https://kotlinlang.org/) 语言来说明，但是它可以被轻松的应用到 Java 中，因为在这里没有使用什么特殊的语言特征。）

    interface Animal
    class Mouse: Animal
    class Duck: Animal
    class Dog: Animal
    class Car

You have various animals and then suddenly something like a car that is totally unrelated.

在这里，你有好几种动物，然后突然出现了一个完全不相干的东西比如说一辆汽车。

In those use cases you have probably different view types you need to show. Means you need to create different ViewHolders and probably inflate different layouts in each. The API defines type identifier as integers, that’s where the ugliness starts!

在这个使用情况里，你可能用不同的视图类型用来展示。 这意味着你需要创建不同的 ViewHolder 然后逐个的把视图布局填充进去。API 把类型的标识码定义为 integers（整型数），这就是糟糕代码开始的地方！

But let’s look at some code. When you have more than one item type you announce this by overriding:

    override fun getItemViewType(position: Int) : Int

as the default implementation always returns zero. The implementer needs to translate the types into Integer values.


让我们来看一些代码。当你有两个以上的 item 类型的时候，由于它们的默认实现总是返回零，你通常通过覆写这个方法来声明它们：

    override fun getItemViewType(position: Int) : Int


Next step: create the ViewHolders. So you have to implement:

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder

下一步：创建 ViewHolders。你不得不实现下面这个方法：

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder

In this method the API tells the Integer type you passed earlier as parameter. The implementation is pretty trivial: a switch statement, or something similar, can be used to create ViewHolders for every given type.

在这个方法里，API 把你之前传递的 Integer 类型作为参数。这个实现相当琐碎：一个 switch (切换)声明，或者类似的可以用来为每个给定类型创建 ViewHolders 的东西。

The difference comes when binding the newly created (or recycled) ViewHolder:

    override fun onBindViewHolder(holder: ViewHolder, position: Int): Any

Notice that here there is no type parameter. You could use getItemViewType if needed but normally it’s not needed. You could have some bind() method in a base class of all our different ViewHolders that you can call.

不同的地方在于什么时候绑定新创建的（或者是复用的） ViewHolder:

    override fun onBindViewHolder(holder: ViewHolder, position: Int): Any

注意这里没有类型参数。如果有必要的话你可以使用 getItemViewType 方法，但通常这是没必要的。在所有不同的 ViewHolder 的基类里，你可能有一些可以调用的
 bind()  方法。

### The Uglyness
### 槽糕之处

So what is the problem now? Looks straightforward to implement, isn’t it?

所以现在的问题是什么？这样做看起来很容易实现，不是么？

Let’s look once again into getItemViewType().

The system needs the type for every position. So you have to translate an item in your backing model list to a view type.

You might want to write something like:

    if (things.get(position) is Duck) {
        return TYPE_DUCK
    } else if (things.get(position) is Mouse) {
        return TYPE_MOUSE
    }

让我们再看一次 getItemViewType()。

这个系统需要每个位置的类型。所以你不得不在你背后的模型列表中，把一个 item 转成一个视图类型。

你可能想要这样写：

    if (things.get(position) is Duck) {
        return TYPE_DUCK
    } else if (things.get(position) is Mouse) {
        return TYPE_MOUSE
    }

Can we agree on how ugly this is?  It might get even worse if your ViewHolders don’t share a common base class. If they are totally different types, in your lists you have the same ugly code when binding the ViewHolder:

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        val thing = things.get(position)
        if (thing is Animal) {
            (holder as AnimalViewHolder).bind(thing as Animal)
        } else if (thing is Car) {
            (holder as CarViewHolder).bind(thing as Car)
        }
    ...
    }
关于这样做会有多糟糕，我们能达成一致的意见么？如果你的 ViewHolders 没有继承自一个共同基础类，这会变得更糟糕。当你绑定 ViewHolder 的时候，如果它们是完全不同的类型，在你的列表中你会有同样糟糕的代码。

This is a mess. instance-of checks and dozens of casting. Both are code smells and should be even considered [anti-patterns[2]](http://www.yegor256.com/2015/04/02/class-casting-is-anti-pattern.html).

这真是一团糟。许多的实例检查和转型。这两个都是坏代码的味道并且被认为是[反面模式](http://www.yegor256.com/2015/04/02/class-casting-is-anti-pattern.html)的东西。

Many years ago I had a couple of quotes attached to my miontor. One of them was from [Effective C++ by Scott Meyers[3]](https://books.google.de/books/about/Effective_C++.html?id=eQq9AQAAQBAJ&source=kp_cover&redir_esc=y) (one of the best IT books ever written) and goes like this:

> Anytime you find yourself writing code of the form “if the object is of type T1, then do something, but if it’s of type T2, then do something else,” slap yourself.

许多年前，我在我的显示器上贴了许多的名言。其中的一个来自 [《Effective C++》 by Scott Meyers](https://books.google.de/books/about/Effective_C++.html?id=eQq9AQAAQBAJ&source=kp_cover&redir_esc=y) 这本书（最好的IT书籍之一），它是这么说的：
> 任何时候你发现你自己正在的代码形式类似于“如果对象是 T1 类型，这样做，如果它是 T2 类型的，那么就那样做”，请给自己一耳光。

If you look at those adapter implementation, there is a lot of slapping to be done.

*   We have type checks and we have lots of ugly casts!
*   This is simply not object orientated code! OO just celebrated its 50th birthday so we should try to use more of its strengths.
*   In addition, the way we implemented those adapters is a violation of the “[Open-Closed[4]](https://en.wikipedia.org/wiki/Open/closed_principle)” rule from the [SOLID[5]](https://en.wikipedia.org/wiki/SOLID_%28object-oriented_design%29) principles. It says: “open for extension but closed for modifications”. But when we would add another type to our classes, another Model, let’s say Rabbit and therefore RabbitViewHolder, we have to change lots of methods in the adapter. A clear violation of the principle. A new kind of object should not lead to modifications in existing methods.

So let’s try to solve this.

如果你看到那些适配器的实现，应该有许多的耳光需要你去扇了。

*   我们有类型检查并且我们有许多糟糕的转型。
*   这完全不是面向对象的代码。面向对象编程刚刚庆祝了它的 50 岁生日，我么应该尽力去发挥它的长处。
*   另外，我们实行那些适配器的方法违背了 [SOLID](https://en.wikipedia.org/wiki/SOLID_%28object-oriented_design%29) 原则中的“[开闭准则](https://en.wikipedia.org/wiki/Open/closed_principle)” 。它是这样说的：“对扩展开放，对修改封闭。” 让我们谈论下 Rabbit 和 RabbitViewHolder，当我们添加另一个类型或者模型到我们的类中时，我们不得不在适配器里改变许多的方法。 这是对开闭原则明显的违背。一个新对象的添加不应该导致需要在已经存在的方法里进行修改的情况。

### Let’s Fix It
### 让我们解决这个问题

One alternative would be to put something in the middle to do the translation for us. It could be as simple as putting your Class types in some Map and retrieve the type with one call. It would be something like:

    override fun getItemViewType(position: Int) : Int
       = types.get(things.javaClass)

It’s much better now isn’t it?  The sad answer is: not really! In the end this just hides instance-of.

一个替代方案是在中间添加一个东西为我们做转换。这跟把你的 Class 类型放入到 Map 中一样简单并且可以通过函数调用来获取相应的类型。这个方案基本是这样的：

    override fun getItemViewType(position: Int) : Int
       = types.get(things.javaClass)

现在它已经好多了，不是么？答案令人难过：这并不够好！这个方案只是把 instance-of 检查隐藏了起来而已。

How would you implement the onBindViewholder() we’ve seen above? It would be something like: if object is of type T1 then do.. else… so still slapping to be done here.

你会如何实现我们上面见到的 onBindViewholder() 方法？可能会是这样：如果对象是 T1 类型，然后做……或者是……，这样你仍然需要给自己一耳光。

The goal should be to be able to add new view types without even touching the adapter.

我们的目标应该是在不接触适配器的情况下能够添加新的类型。

Therefore: don’t create your own type mapping in the adapter between the models and the views in the first place. Google suggests using layout ids. With this trick you don’t need the artificial type mappings by simply using the layout id you’re inflating. And of course you probably save another enum as [#perfmatters[6]](https://twitter.com/hashtag/perfmatters).

所以：不要一开始就在视图和模型之间的适配器里创建你自己的类型容器。Google 建议使用布局 id。利用这个技巧，你可以简单的使用你正在填充的布局 id 而不需要制作类型容器。当然你可能会把另一个枚举类型保存成 [perfmatters](https://twitter.com/hashtag/perfmatters).


But still you need to map those to each other? How?

但是你仍然需要把它们互相关联到一起么？要怎么做呢？

In the end end you need to map models to views. Could this knowledge move to the model?

在最后你需要把模型与视图关联在一起。这里面的关联信息能够迁移到模型里面吗？


It would be tempting to put the type into your model, something like.

    fun getType() : Int = R.layout.item_duck

把类型放进你的模型里是很诱人的，就像这样。
    
    fun getType() : Int = R.layout.item_duck

This way the adapter implementation for type could be totally generic:

    override fun getItemViewType(pos: Int) = things[pos].getType()
    
这种适配器类型的实现方式是完全通用的：

    override fun getItemViewType(pos: Int) = things[pos].getType()

Open-Closed principle is applied, no changes needed when adding new models.

开闭原则被应用了，当添加新的模型时无需做多余的改变。

But now you totally mixed our layers and indeed broke the complete architecture. Entities know about presentation, arrows pointing into the wrong direction. [This must be unacceptable for us[7]](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html).  And again: adding a method into an object to asks for it’s type is not object orientated. You again would just hide the instance-of check.

但是现在你把我们的布局层完全混合在一起了，这样做确实破坏了完整的结构。实体对外观的呈现有所了解，箭头指向了错误的方向。[这对我们来说是完全不能接受的](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html). 并且再一次：在一个对象里面添加方法来询问它的类型，这不是面向对象。你只是再一次的隐藏了 instance-of 检查而已。

### The ViewModel
### ViewModel

One way to approach this, is to have separat ViewModels instead of using our Model directly. In the end our problem was that our models are disjoint, they don’t share a common base: a car is not an animal. And this is correct. Only for the presentation layer you need to show them in on list. So when you introduce models for this layer you don’t have this problem, they can have a common base.

    abstract class ViewModel {
        abstract fun type(): Int
    }
    class DuckViewModel(val duck: Duck): ViewModel() {
        override fun type() = R.layout.duck
    }
    class CarViewModel(val car: Car): ViewModel() {
        override fun type() = R.layout.car
    }

解决这个问题的一个方法是：拥有独立的 ViewModel 而不是直接使用我们的 Model。我们的问题是我们的模型是互不关联的，他们没有一个共同的基类：一辆车不是一个动物。这是对的。只有表示层你需要在列表里展示它们。所以当你为表示层介绍这些模型时你没有这个问题，他们可以拥有一个共同的基类。

    abstract class ViewModel {
        abstract fun type(): Int
    }
    class DuckViewModel(val duck: Duck): ViewModel() {
        override fun type() = R.layout.duck
    }
    class CarViewModel(val car: Car): ViewModel() {
        override fun type() = R.layout.car
    }


So you simply wrapped the models. You don’t need to modify them at all and keep view specific code in those new ViewModels. This way you can also add all formatting logic into there and use Android’s new [Data Binding Library[8]](https://developer.android.com/topic/libraries/data-binding/index.html).

所以你简单的包装了下模型。你完全不需要修改它们，并且在那些新的视图模型里保留了视图独有的代码。通过这个方式，你可以添加所有模式逻辑并且使用 Android 新出的 [Data Binding Library](https://developer.android.com/topic/libraries/data-binding/index.html)。

The idea of using list of ViewModels in the adapter instead of the Models helps especially when you need artificial items like dividers, section headers or simply advertisement items.

在适配器里使用 ViewModels 列表而不是 Models 的这个点子很有用，尤其是当你需要额外添加的 items 的时候，类似分隔板，列表头部或者只是广告项目。

This is one approach to solve the problem. But not the only one.

这是解决这个问题的一个方法，但不是唯一的一个。

### The Visitor
### 访问者模式


Let’s go back to our initial idea of only using the Model. If you would have lots of model classes, maybe you don’t want to create lots of ViewModel one each.  Thinking of the type() method that you added in the first place into the model, you missed some decoupling. You need to avoid having the presentation code in there directly. You need to indirect it, move the actual type knowledge to somewhere else. How about adding an interface into this type() method:

    interface Visitable {
        fun type(typeFactory: TypeFactory) : Int
        }

让我们回归最初的想法，只使用 Model。如果你有许多的模型类，可能你不想为每一个模型创造许多 ViewModel。想想最开始你添加到模型里的 type() 方法，你错过了一些解耦的机会。你需要避免在模型里直接拥有表示层的代码。你需要间接的使用它，把实际的类型信息迁移到其他地方。在这个 type() 方法里添加一个接口怎么样：

    interface Visitable {
        fun type(typeFactory: TypeFactory) : Int
        }


Now you might ask what have you won here as the factory would still need to branch between types like the adapter did in the first place, right?

现在你可能会问你在这里这样做有什么好处，因为工厂方法仍然需要给不同的类型创建分支，就像在最开始的时候适配器做的一样，是这样么？

No it does not! This approach will be based on the [Visitor pattern[9]](https://en.wikipedia.org/wiki/Visitor_pattern), one of the classic [Gang-of-Four pattern[10]](https://en.wikipedia.org/wiki/Design_Patterns). All the model will do, is forwarding this type call:

    interface Animal : Visitable
        interface Car : Visitable

    class Mouse: Animal {
        override funtype(typeFactory: TypeFactory)
            = typeFactory.type(this)
            }

不，这完全不一样！这个方法是建立在[访问者模式](https://en.wikipedia.org/wiki/Visitor_pattern)之上的，一个典型的[四人帮设计模式](https://en.wikipedia.org/wiki/Design_Patterns)。所有的模型都是这样，执行类型函数调用：

    interface Animal : Visitable
        interface Car : Visitable

    class Mouse: Animal {
        override funtype(typeFactory: TypeFactory)
            = typeFactory.type(this)
            }


The factory has variations you need:

    interface TypeFactory {
        fun type(duck: Duck): Int
        fun type(mouse: Mouse): Int
        fun type(dog: Dog): Int
        fun type(car: Car): Int
        }

这个工厂方法拥有你需要的变化：

    interface TypeFactory {
        fun type(duck: Duck): Int
        fun type(mouse: Mouse): Int
        fun type(dog: Dog): Int
        fun type(car: Car): Int
        }


This way it’s totally type safe, no instance-of, no casts needed at all.

这种方式是完全的类型安全，没有类型检查，也根本不需要转型。

And the responsibility of the factory is clear: it knows about the view types:

    class TypeFactoryForList : TypeFactory {
        override fun type(duck: Duck) = R.layout.duckoverride fun type(mouse: Mouse) = R.layout.mouse    override fun type(dog: Dog) = R.layout.dogoverride fun type(car: Car) = R.layout.car
        
这个工厂方法的责任是明确的：它知道所有的视图类型：


    class TypeFactoryForList : TypeFactory {
        override fun type(duck: Duck) = R.layout.duckoverride fun type(mouse: Mouse) = R.layout.mouse    override fun type(dog: Dog) = R.layout.dogoverride fun type(car: Car) = R.layout.car
       
  

I could even also create ViewHolders to keep the knowledge about the ids in one place. So when adding a new view, this is the place to add. This should be pretty SOLID. You might need another method for new types but not modify any existing method: Open for Extension, Closed for Modification.

我也可以创建 ViewHolders 在某个地方持有关于布局 id 的信息。所以当添加一个新视图的时候，这个地方也跟着添加。这是相当符合 SOLID 原则的。你可能需要为新的类型创建另一个方法但是不修改任何存在的方法：对扩展开放，对修改封闭。

Now you might ask: why not use the factory directly from adapter instead using the indirection of the model? Only with this path you get the type safety without need of casts and type checks. Take a moment to realize this here, there is not a single cast needed! This indirection is the magic behind Visitor Pattern.

现在你可能会问:为什么不直接在适配器里使用工厂方法而是间接的使用模型呢？通过这个方式你可以不需要转型和类型检查就可以确保类型安全。
花点时间在这里实现它，这不是一个需要的转型！间接引用正是访问者模式背后的魔法。

Following this approach leaves the adapter with a very generic implementation that hardly ever needs to be changed.

通过这个方法使得适配器拥有一个非常通用的实现，并且几乎不需要变化。

### Conclusion
### 结论



*   Try to keep your presentation code clean.
*   Instance-of checks should be a red flag!
*   Look out for down casting as it’s a code smell.
*   Try to replace those two with correct OO usage. Think about interfaces and inheritance.
*   Try to use generics to prevent castings.
*   Use ViewModels.
*   Check out for usages for the Visitor pattern.

I would be happy to learn other ideas to make our Adapters cleaner.

*   尽力保持你的表示层代码干净。
*   Instance-of 检查应该是一个警告标志，尽量不要使用!
*   小心向下转型因为这是坏代码的味道.
*   尽量把上面两个替换成正确的面向对象用法。考虑下接口和继承。
*   尽量使用通用的方式来避免转型。
*   使用 ViewModel。
*   检查访问者模式的使用方式。

我很乐意了解到更多其他的想法来使我们的适配器保持整洁。

