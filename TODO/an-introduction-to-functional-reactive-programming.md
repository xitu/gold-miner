> * 原文地址：[An Introduction to Functional Reactive Programming](http://blog.danlew.net/2017/07/27/an-introduction-to-functional-reactive-programming/)
> * 原文作者：[Daniel Lew](https://github.com/dlew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/an-introduction-to-functional-reactive-programming.md](https://github.com/xitu/gold-miner/blob/master/TODO/an-introduction-to-functional-reactive-programming.md)
> * 译者：[龙骑将杨影枫](https://github.com/stormrabbit/)
> * 校对者：[jasonxia23](https://github.com/jasonxia23)、[Tobias Lee](https://github.com/lileizhenshuai)

# 函数式响应编程入门指南

今年，我做了一场有关函数式响应编程（functional reactive programming，简称 FRP）的演讲，演讲的内容包括“什么是函数式响应编程”以及“为什么你应该关注它”。本篇是此演讲的文字版。

---

## 介绍

函数式响应编程最近几年非常流行。但是它到底是什么呢？为什么你应该关注它呢？

即便是对于现在正在使用 FRP 框架的人 —— 比如 RxJava —— 来说，FRP 背后的基础理论还是很神秘的。今天我就来揭开这层神秘的面纱，将函数式响应编程分解成两个独立的概念：响应型编程和函数式编程。

## 响应型编程

[![](http://blog.danlew.net/content/images/2017/07/slide01-1.png)](http://blog.danlew.net/content/images/2017/07/slide01-1.png)

首先，让我们来看一下什么叫做响应型代码。

先从一个简单的例子开始：开关和灯泡。当有人拨动开关时，灯泡随之发亮或熄灭。

在编程术语中，这两个组件是耦合的。通常人们不太关心它们**如何**耦合，不过这次让我们深入研究一下。

[![](http://blog.danlew.net/content/images/2017/07/slide02-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide02.png)

让灯泡随着开关发光或熄灭的方法之一，是让开关修改灯泡的状态。在这种情况下，开关是**主动**的，用新状态给灯泡赋值；灯泡是**被动**的，单纯地收到指令改变自己的状态。

我们在开关旁边画一个箭头来表示这种状态 —— 这就是说，连接两个组件的是开关，不是灯泡。

[![](http://blog.danlew.net/content/images/2017/07/slide03-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide03.png)

这是主动型解决方法的代码：开关类中持有一个灯泡类的实例化对象，通过修改实例对象来完成状态的修改。

[![](http://blog.danlew.net/content/images/2017/07/slide04-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide04.png)

另一种连接这两个组件的办法是让灯泡通过监听开关的状态来改变自己的值。在这种模型下，灯泡是**响应型**的，根据开关的状态修改自身的状态；开关是**被观察者**（**observable**），其他的观察者可以观察它的状态变化。

[![](http://blog.danlew.net/content/images/2017/07/slide05-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide05.png)

这是响应型解决方案的代码：灯泡 `LightBulb` 监听开关 `Switch` 的状态，根据开关状态改变的事件改变自身的状态。

[![](http://blog.danlew.net/content/images/2017/07/slide06-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide06.png)

对终端用户来说，主动型和响应型编码结果是相同的。那么两者的差别在哪里呢？

第一个区别是，`灯泡`的控制者不同。在主动型模式中，是由**另一个**组件调用了灯泡对象的 `LightBulb.power()` 方法。但是在响应型里，是由`灯泡`自己控制自己的亮度。

第二个区别是，谁决定了`开关`的控制对象。在主动型模式里，开关自己决定它控制谁。在响应式模式里，`开关`并不关心它控制谁，而其他组件只是在它身上挂了个监听器。

两者看起来好像是对方的镜像。两者间是二元对应的。

然而，正是这些微妙的差别造成了两个组件间是高耦合还是低耦合。在主动型模式中，组件互相直接控制。在响应型模式中，组件自己控制自己，互相之间没有直接交互。

[![](http://blog.danlew.net/content/images/2017/07/slide07-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide07.png)

举个现实中的例子：

这是 Trello 的主页面，它从数据库拿取图片数据并展示给用户。那么采用主动型的数据关系与响应型（的数据关系）有什么不同呢？

[![](http://blog.danlew.net/content/images/2017/07/slide08-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide08.png)

如果是主动型模式，当数据库的数据更新时，数据库将最新的数据推送到用户界面。但是这种做法看起来毫无逻辑：为什么数据库需要关心用户界面？为什么要由数据库关心主页面到底展示了没有？为什么它要关心是否需要推送数据到主页面？主动型编码让数据库和用户界面之间缠缠绵绵，看起来好像是在做羞羞的事（creates a bizarrely tight coupling between my DB and my UI ）。

[![](http://blog.danlew.net/content/images/2017/07/slide09-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide09.png)

相对而言，响应型就简洁多了。用户界面监听数据库的数据变化，如果有需要的话就更新自己的界面。数据库就是一个傻乎乎的资源堆放地，顺便提供了一个监听器。任何组件都能读取到数据库的数据变化，而这些变化也很容易反应到需要的用户界面上。

[![](http://blog.danlew.net/content/images/2017/07/slide10-thumb.jpg)](http://blog.danlew.net/content/images/2017/07/slide10.jpg)

用一句好莱坞的拍戏信条概括就是：别给我们打电话，我们会打电话给你的（校对 Tobias Lee ：*don't call us, we'll call you* ，这个似乎是好莱坞演员面试的原则。是否被录用是由剧组决定的，演员不要主动打电话去询问）。这种形式会降低代码耦合度，允许攻城狮很好地封装组件。

现在我们可以回答什么是响应型编程了：那就是使用组件响应事件的编码形式，代替通常使用的主动型编码。

[![](http://blog.danlew.net/content/images/2017/07/slide11-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide11.png)

如果想经常使用响应型编码的话，简单的监听器还是不够完善。这样会产生一系列问题：

首先，每一个监听器都是独一无二的。我们有 `Switch.OnFlipListener` ，但是只能用来监听开关类 `Switch`。如果有多个被观察者，那每一个（被观察者）组件都需要实现（观察者）的监听接口。这不仅带来一系列无聊繁重的实现接口的工作，还意味着不能重复使用响应型编码的思维 —— 因为没有一个共同的架构来实现这种模式。

第二个问题是每一个观察者必须直接连接被观察的组件。`灯泡`对象必须直接和`开关`对象直连才能开始监听开关对象的状态。这其实是一个高耦合的编码形式，和我们的目标背道而驰。

[![](http://blog.danlew.net/content/images/2017/07/slide12-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide12.png)

我们真正希望的是 `Switch.flips()` 返回一些可以被传递的泛型。来看看为了满足需求，我们应该选择哪种类型。

[![](http://blog.danlew.net/content/images/2017/07/slide13-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide13.png)

Java 函数可以返回四种基本对象。横轴代表需要返回值的数量：要么是一个，要么是多个。纵轴代表是否需要立刻（同步）返回还是需要延迟（异步）返回。

[![](http://blog.danlew.net/content/images/2017/07/slide14-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide14.png)

同步的返回值很简单。如果是需要返回一个元素，那么可以用泛型 `T`。如果是需要多个返回值，可以用 `Iterable<T>`。

编写同步类型的代码比较简单，因为同步是所见即所用，但理论和现实还是有差距的。响应型编程天生具有异步属性：鬼知道被观察者什么时候会抽风个新状态出来。

[![](http://blog.danlew.net/content/images/2017/07/slide15-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide15.png)

这种情况下，我们需要研究一下异步返回值。如果需要一个返回值，可以用 `Future<T>`。看起来不错，但离需要的（类）还差点 —— 一个被观察者组件也许有很多返回值（比如说，`开关`对象就可能多次开开关关)。

我们真正需要的类在右下角，这块区域的类可以被称之为 `Observable<T>`。`Observable` 类是响应型框架的基础。

[![](http://blog.danlew.net/content/images/2017/07/slide16-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide16.png)

来看看 `Observable<T>` 是如何起作用的。在上面的新代码里，`Switch.flips()` 返回一个 `Observable<Boolean>` 对象 —— 换句话说，就是一系列 true 或则 false 的值，代表开关对象 `Switch` 是处于打开状态还是处于关闭状态。灯泡对象 `LightBulb` 没有直接没有直接受制于 `Switch` 对象，它只是订阅了由`开关`提供的 `Observable<Boolean>`。

这段代码和无 `Observable` 代码起着相同的作用，但是足以解决刚才我提到的两个问题。`Observable<T>` 是一个基础类型，在此基础之上可以进行更高层次的开发。而且它是可以被传递的，所以组件间的耦合度就降低了。

[![](http://blog.danlew.net/content/images/2017/07/slide17-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide17.png)

再巩固一下 `Observable` 是什么：一个 `Observable` 是一组随时间变化的元素集合。

用这张图来说明的话，横线代表时间，圈圈代表 `Observable` 发送给它的订阅者的事件。

`Observable` 可以很好地表示两种可能的状态：成功还是报错。

[![](http://blog.danlew.net/content/images/2017/07/slide18-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide18.png)

图中竖线代表一个成功的访问。并不是所有的集合都是无限的，所以有必要这么表示。比如说，如果你在 Netflix 上看视频的话，在特定的时候视频就会结束。

[![](http://blog.danlew.net/content/images/2017/07/slide19-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide19.png)

X 代表错误，即表示在结果流的数据在某个时候会变为非法值。比如说，如果莱因哈特对着开关就是一锤子，那么还是应该提醒用户：开关不仅没法产生任何新状态，甚至连开关自身都不可能再监听任何状态 — 因为它被砸坏了。


## 函数式编程

[![](http://blog.danlew.net/content/images/2017/07/slide20-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide20.png)

让我们先把响应型编程放在一边，看看函数式编程是什么。

函数式编程的关键词是函数。嗯，对吧？我不准备讲什么普通的老式函数：我们现在研究的是纯函数。

[![](http://blog.danlew.net/content/images/2017/07/slide21-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide21.png)

通过这个加法的例子来解释下什么是纯函数。

假设有一个完美的取两数之和的 `add()` 函数。等下，这个函数空缺的部分是啥？

[![](http://blog.danlew.net/content/images/2017/07/slide22-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide22.png)

哎呀，看起来 `add()` 函数把一些文字流输出到了控制台。这就是所谓的**副作用**。`add()` 的目的本不包括显示结果，仅做相加的动作。但是现在它修改了 app 全局的状态。

等下，还有更多。

[![](http://blog.danlew.net/content/images/2017/07/slide23-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide23.png)

天啊，这回不光把数据输出到了控制台，连函数都强行结束了。如果单纯的看函数定义(两个参数，一个返回值)，谁也不知道这个函数会造成什么样的破坏。

[![](http://blog.danlew.net/content/images/2017/07/slide24-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide24.png)

再来看看另一个例子。

这次的例子是取一组数据，看看数据相加与数组相积是否一样。对数组 `[1, 2, 3]` 来说，这个结果应该是 true，因为不论相加还是相乘都是6。

[![](http://blog.danlew.net/content/images/2017/07/slide25-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide25.png)

然而，检查一下 `sum()` 方法是如何实现的。虽然没有修改 app 的全局状态，但是它改变了输入的参数！这意味着代码会失败，因为随着 `product(numbers)` 运行，`numbers` 最终会变成空集合的。这一系列的问题可能随时发生在真实的、不纯的函数中。

[![](http://blog.danlew.net/content/images/2017/07/slide26-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide26.png)

任何改变函数额外状态的时候，都会产生副作用。如你所见，副作用会使得编码复杂化。纯函数不允许有任何的副作用。

有趣的是，这意味着纯函数**必须**有返回值。如果只有 `void` 的返回值，意味着纯函数啥都没做，因为它既没有改变输入值，也没有改变函数外的状态。

这同时意味着，函数的参数必须是不可变的(译者：比如用 final 修饰？)。不能允许参数可变，否则函数执行的时候有可能修改参数值，从而打破了纯函数的原则。顺便一提，这也暗示着输出值也必须是不可变的（不然的话输出值不能作为其他纯函数的参数）

[![](http://blog.danlew.net/content/images/2017/07/slide27-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide27.png)

有关纯函数的第二个方面，就是对于给定的输入值，纯函数必须返回相同的输出值。换句话说，纯函数不能依靠额外的状态。

比如说，检查一下这个欢迎用户的函数。虽然没有任何副作用，但是它随机返回两种欢迎语。这种随机性提供了一个额外的、静态的函数。

这使得编码从两方面来说更坑爹了。第一，函数的返回值和输入值没什么关系。如果知道相同的输入值可以产生相同的返回值，那么阅读代码会更不容易懵圈。第二，函数中有一个额外的依赖，如果该依赖产生了变化，那么函数的输出值也会改变。

面向对象的开发者很可能不理解，纯函数不能访问持有的类的状态。比如说，`Random` 的方法自带不纯属性，因为每次调用它都会返回不同的值。

[![](http://blog.danlew.net/content/images/2017/07/slide28-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide28.png)

简单的说：函数式编程依赖于纯函数。纯函数是不会消耗或者改变外部的状态 - 他们完全依赖输入值来产生输出值。

[![](http://blog.danlew.net/content/images/2017/07/slide29-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide29.png)

介绍函数式编程给大家时比较容易被混淆的是：(既然输入值是不可变的)，那如何让输出值有变化呢？比如说，如果我有一组整数，想获得以该组整数每个元素乘 2 的结果为新元素组成的数组。是不是必须改变列表的值呢？

嗯，其实不全是的。你可以使用纯函数改变列表。这是一个可以把集合里的值做 * 2 操作的纯函数。没有副作用，没有额外的状态，也没有改变输入值或者输出值。这个函数做了额外的修改状态的工作，所以你就不必这么做的。

然而，我们所写的这个方法扩展性太差了。它能做的只是把数组的每一个值都乘 2，但是如果想对数组的值进行其他操作呢？比如乘 3，除 2，想法是无穷无尽的。

[![](http://blog.danlew.net/content/images/2017/07/slide30-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide30.png)

让我们写一个通用的整数数组计算器。首先写一个`函数式`接口，这样我们就可以定义如何计算每一个值。

然后写一个 `map()` 函数，此函数接受一个整数数组**和**一个 `Function`函数 做参数。对每一个数组的整数来说，都可以用 `Function` 计算。

赞美太阳！通过一点点额外的代码，我们可以对任何整数数组进行计算。

[![](http://blog.danlew.net/content/images/2017/07/slide31-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide31.png)

我们甚至可以把这个例子拓展的更广泛一些：为什么不用一个更通用的类型，这样我们可以把任何列表转换为另一个其他的列表？只需要简单的修改一点刚才的代码。

现在，我们可以把任何 `List<T>` 转换为 `List<R>`。比如说，我们可以把一组字符串数组转换为一组每个字符串的长度的数组。

`map()` 就是所谓的**高阶函数**，因为它的参数之一也是函数。能够传递并且使用函数做参数是一个很牛逼的做法，因为它允许代码变的更灵活。不必再写反复的、实例化的函数，可以使用泛型度更高的函数比如 `map()` 来处理具有共性的逻辑。

[![](http://blog.danlew.net/content/images/2017/07/slide-31.2-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide-31.2.png)

除了能更轻松的处理一系列额外的状态之外，纯函数还可以更容易组织函数。如果有一个 `A -> B` 的函数，又有一个 `B -> C` 的函数，我们可以把两个函数结合起来，以产生 `A -> C`。

当你**可以**组织不纯函数时，总是会发生意料之外的副作用，这意味着组织函数是否正确的执行是个未知数。只有纯函数可以保证组织起来的代码是安全的。

[![](http://blog.danlew.net/content/images/2017/07/slide-31.3-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide-31.3.png)

再举个栗子。这是另一个简单的函数式编程的函数 —— `filter()`。`filter()` 可以帮助我们过滤集合中的元素。现在我们可以在转换集合之前，先进行过滤操作。

现在我们有了一对很小但是很勥的转换函数。它们的强力值随着允许我们自有组装函数而变的越来越大。

其实函数式编程比我提到的还要多，但是现在讲述的东西足够我们明白函数式响应编程里的函数式了。

## 函数式响应编程
[![](http://blog.danlew.net/content/images/2017/07/slide32-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide32.png)

现在可以解释什么是函数式响应编程了。

还是以开关类 `Switch` 举例，这次我们不提供  `Observable<Boolean>` 类，我们提供一个基于自身状态枚举流的  `Observable<State>`。

看起来我们没办法把开关和灯泡关联在一起，因为我们的泛型不相容。但是还有一个明显的方式让 `Observable<State>` 酷似
`Observable<Boolean>` —— 如果可以把一种流转换为另一种呢？

还记得之前函数式编程里的 `map()` 函数吗？该函数将一个同步集合转换为另一个。我们能否用相同的思想来把一个异步集合转换为另一个呢？

[![](http://blog.danlew.net/content/images/2017/07/slide33-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide33.png)

啦啦啦：这就是 `map()`，但是是用来转换 `Observable`的。`Observable.map()` 就是所谓的**操作符（operator）**。操作符允许攻城狮把任一 `Observable` 转换成基本上其他能所想到的类。

操作符的图表画起来比之前见到的要麻烦。让我们来把它弄清楚：

上面的代表输入流：一系列的有颜色的圈圈。

中间的代表一系列操作符：把一个圈圈转换为方块。

下面的那行代表着输出流：一系列有颜色的方块。

本质上，在输入流里做的是 1:1 的转换。

[![](http://blog.danlew.net/content/images/2017/07/slide34-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide34.png)

还是以开关的例子来说明。先写一个 `Observable<State>` ，然后使用 `map()` 操作符（对 `Observable<State>` 进行转换），这样每次产生新 `状态` 的时候，操作符 `map()` 返回一个 `Observable<Boolean>` 对象。现在我们有了正确的返回类型，就可以构造`灯泡`对象`LightBulb`了。

[![](http://blog.danlew.net/content/images/2017/07/slide-34.2-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide-34.2.png)

好吧，这很有用。但是为什么一定要用纯函数呢？为什么不能随便在 `map()` 写一点？为什么引起副作用就有问题呢？当然，可以这么做，但是马上就会让代码很难处理。再说，这么做会错过不少不允许副作用的操作符。

假设 `State` 的枚举类型有两种以上的状态，但是用户只关心打开或者关闭。如果这样的话，我们要过滤掉其他的状态。看，这里有一个 `filter()` 的操作符。还可以用 `map()` 来获得想要的结果。

将函数式响应编程的代码和之前的函数式代码相比较，你会发现两者非常相似。唯一的区别就是函数式编程的代码处理的是同步的集合，函数式响应编程处理的是异步集合。

[![](http://blog.danlew.net/content/images/2017/07/slide35-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide35.png)

函数式响应编程的代码有一大堆操作符，可以把常见的问题转换成对流的控制，而流最大的好处就是可以多次组装。举一个真实的例子：

我之前展示的 Trello 主屏幕很简单 —— 它只有一个从数据库到用户界面的大箭头。但事实上，主屏幕用的数据源还有很多。

事实上，每一个数据源的数据可能有很多的展示位置。我们必须保证同步接收资源，否则可能会出现数据匹配错误，造成展示位置没有对应的数据源的 bug。

[![](http://blog.danlew.net/content/images/2017/07/slide36-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide36.png)

我们使用 `combineLatest()` 避免这种问题，`combineLatest()` 接收复数的数据流并且将他们组合成一个数据流。这么做有什么好处呢？每次任何一个输入流改变的时候，它也跟着改变，这样就可以保证发送给 UI 的数据包是完整的了。

[![](http://blog.danlew.net/content/images/2017/07/slide37-thumb.png)](http://blog.danlew.net/content/images/2017/07/slide37.png)

函数式响应编程中有很多有价值的操作符，这里只给大家看一些简单的…… 多数情况下，第一次使用函数式响应编程的攻城狮看到一大堆操作符都会晕过去。

然而，这些操作符的目标并不是让人崩溃 —— 它们为了组织典型的数据。它们是你的朋友，不是敌人。

我建议大家可以一步一步的接受他们。并不需要马上记住所有的操作符；相反，只需要记住当前应该使用什么操作符。需要的时候去查询一下，然后经过一系列训练你就会习惯它们的。

## 额外的东西

我试图去回答“什么是函数式响应编程”。现在我们有了答案：所谓函数式响应编程，就是响应型数据流与函数式操作符的组合。

但是为什么要尝试使用函数式响应编程呢？

响应型数据流允许你通过标准方法编写组件间的模块化编码。响应型数据可以帮助攻城狮对组件进行解耦。

响应型数据流天生自带异步属性。也许你的工作是同步的，但是大部分我编写的 app 都是基于异步的用户输入和操作。使用一个基于异步编写的框架比自己摸索着写代码的方式要简单的多。

函数式响应型编码的函数式部分可以给予攻城狮使用可靠的方法操作数据流的工具，因而特别有用。 函数式操作符允许攻城狮控制数据流之间的交互，同时可以编写可复用的代码模块来应对有共性的逻辑。

函数式响应编程不够直观。大部分人开始编程的时候都是使用非纯的函数或者主动的方式，包括我。也许你使用这种方式的时间太久了，而这种方式也深深的印在了你的脑子里，以至于你认为这种方式是唯一的解决方式。如果能够打破这种惯性思维，你可以编写出更多高质量的代码。

## 引用

感谢在以下资料对我演讲的帮助：

- [cycle.js 对主动型与响应型编码的解释(cycle.js has a great explanation of proactive vs. reactive code)](https://cycle.js.org/streams.html)，我参考了很多这篇文档来筹备演讲。

- [Erik Meijer 做了一场碉堡了的、有关响应型/主动型二元对应的演讲](https://channel9.msdn.com/Events/Lang-NEXT/Lang-NEXT-2014/Keynote-Duality)，我从中借鉴了 4 项函数式的基本效果。本演讲有点高深，但是如果你能吃透它，它非常有启发性。

- 如果读者希望了解更多有关函数式编程的东西，我推荐大家使用一门函数式编程语言。Haskell 就特别不错，因为它严格使用函数式编程的规范，意味着你不能使用作弊的方式学习。["Learn you a Haskell" 是一部优秀而且免费的在线书籍](http://learnyouahaskell.com/)，想跟深入研究得人可以看一看。

- 如果想学习更多函数式响应编程的姿势，欢迎阅读[我的博客上的一系列文章](http://blog.danlew.net/2014/09/15/grokking-rxjava-part-1/)。此演讲中所阐述的知识点和博客上的文章有交叉，但是博客上的文章会更多的阐述使用 RxJava 的细节。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
