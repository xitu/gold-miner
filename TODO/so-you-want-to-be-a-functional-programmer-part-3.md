> * 原文地址：[So You Want to be a Functional Programmer (Part 3)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7#.7e7fhqghb)
* 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Airmacho](https://github.com/Airmacho)
* 校对者：[cyseria](https://github.com/cyseria) 和 [xuxiaokang](https://github.com/xuxiaokang)

# 准备充分了嘛就想学函数式编程？(Part 3)

想要理解函数式编程，第一步总是最重要，也是最困难的。但是只要有了正确的思维，其实也不是太难。
之前部分内容：[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-1.md)，[第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-2.md)

#### 函数组合

![](https://cdn-images-1.medium.com/max/1600/1*yGnDGRW4pTgmcDUi4oC8Uw.png)



作为程序员，懒惰是我们的美德。我们不想不断重复地构建，测试，部署写过的代码。

我们希望有办法可以一处写完，各处复用。

代码复用听起来很棒，实现起来很困难。如果代码写的非常明确，就不能复用。太泛化的话，最开始用都困难。

所以我们需要权衡，有种方案是写简短可复用的代码，我们可以将它们当作零件用来组合成更复杂的代码。

在函数式编程中，函数就是我们的零件。我们可以用它们来完成指定的任务，再像乐高积木一样拼凑在一起。

这被称作**函数组合**。

该怎么实现呢，让我们从两个 JavaScript 函数开始：

    var add10 = function(value) {
        return value + 10;
    };
    var mult5 = function(value) {
        return value * 5;
    };

这个写法太冗长，所以我们用 [**箭头函数**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)表达式重写成：

    var add10 = value => value + 10;
    var mult5 = value => value * 5;

好多了，现在设想我们再需要一个函数，它可以接受一个值作为参数，将值加 10，再乘以 5，把结果返回。我们可以写成：

    var mult5AfterAdd10 = value => 5 * (value + 10)
尽管这只是一个很简单的需求，我们仍不想重新写一个新的函数。首先，我们可能会因为忘记括号而出错。

其次，我们已经有一个函数可以将值加上 10，另一个函数将值可以乘以 5。我们这是在重复之前的工作。

因此，我们用 **add10** 和 **mult5** 来构建我们的新函数：

    var mult5AfterAdd10 = value => mult5(add10(value));
我们可以用现有的函数来创建 **mult5AfterAdd10** 函数，但其实有更好的办法。

在数学中， **_f ∘ g_** 是函数的组合，所以读作 **“函数 f 与函数 g 的复合函数”**，或者更通用的说法是 **“在 g 之后调用 f”**。所以 **_(f ∘ g)(x)_** 相当于先以 **x** 为自变量调用函数 **g**，再以结果为自变量调用函数 **f**，简写成  **_f(g(x))_**。

对于我们的例子，我们可以用  **_mult5 ∘ add10_** 或者  **_“mult5 after add10”_** 来表示，所以我们的函数名叫 **_mult5(add10(value))_** 。

    add10 value =
        value + 10
    
    mult5 value =
        value * 5
    
    mult5AfterAdd10 value =
        (mult5 << add10) value

在 Elm 中，你可以用插入运算符 **<<** 来组合函数。这在带给我们一种数据是怎样流动的视觉效果。首先，**value** 传入 **add10** 中，再将结果作为参数传入 **mult5** 中。

注意 **mult5AfterAdd10** 中的括号，比如  **_(mult5 << add10)_**。这里是说明函数是先组合，再传入参数 **value** 的。

你可以用这种方式随意组合函数：

    f x =
       (g << h << s << r << t) x

这里 **x** 传入函数 **t** ，将运算结果传给函数 **r**，然后再将结果传给函数 **s**，这样一直进行下去。如果你要在 JavaScript 里实现类似的功能，看起来会是这样  **_g(h(s(r(t(x)))))_**，括号的恶梦。

#### Point-Free 表示法

![](https://cdn-images-1.medium.com/max/1600/1*g2pWcQJ0jOUf1WKbTDIktQ.png)



有一种可以不需要指定参数的函数写法，叫做 **Point-Free 表示法**。开始时，这种风格看起来有些奇怪，随着使用继续，你会开始欣赏它带来的简洁性。

你可以注意到，在 **mult5AfterAdd10** 里我们有两处用到 **value** 变量。一处是在参数列表中，一处是内部使用时。

    -- This is a function that expects 1 parameter

    mult5AfterAdd10 value =
        (mult5 << add10) value

其实这个参数并不是必须的，因为 **add10**，组合中最外侧的函数，和函数组合接受的参数相同。与下面的 point-free 版本是等价的：

    -- This is also a function that expects 1 parameter

    mult5AfterAdd10 =
        (mult5 << add10)

用这种 point-free 风格表示法有很多好处。

首先，我们不需要指定多余的参数。因为我们不要明确指定它们，我们可以不用去费心给它们起名字。

其次，因为更简洁，阅读和理解起来也更容易。这个例子非常简单，但是想象一下如果函数有很多参数的情况。

#### 天堂里的烦恼

![](https://cdn-images-1.medium.com/max/1600/1*RE3Qxh6Bg9umzQ5dOrF6pw.png)



到目前为止，我们已经见过函数组合是怎样工作的，我们如何用 Point-Free 风格的写法来提高代码的简洁性，清晰性和灵活性。

现在让我们尝试在稍微不同的场景中运用这些思想。设想我们用 **add** 替换 **add10**:

    add x y =
        x + y
    
    mult5 value =
        value * 5

我们如何只用这两个函数来组合 **mult5After10** 呢？

继续读之前请先思考这个问题，想一想，试着做一做。

好，如果你真的花时间想了，也许你会想到这样的方案：

    -- This is wrong !!!!

    mult5AfterAdd10 =
        (mult5 << add) 10

但是这不行，为什么？因为 **add** 函数需要两个参数。

用 Elm 也许不明显，可以用 JavaScript 写：

    var mult5AfterAdd10 = mult5(add(10)); // this doesn't work
这段代码是错的，为什么？

因为在这里 **add** 函数只接受了两个参数中的一个，然后**错误结果**再被传入 **mult5** 函数，结果也是错的。

实际上，在 Elm 中，编译器不会让你写出这种残缺的代码（ Elm 的优点之一）

    var mult5AfterAdd10 = y => mult5(add(10, y)); // not point-free
这样不是 point-free 的，但可用。但是现在不再是函数组合了，我写了一个新的函数。另外，如果函数更复杂，例如，如果我想用 **mult5AfterAdd10** 与其他函数组合，那就会很麻烦。

可见函数组合的可用性有限，因为我们不能将这两个函数结合在一起。太糟了。

我们怎样解决这个问题呢？我们需要做什么？

如果我们可以找到一种方法可以让 **add** 函数先接受一个参数，再在后面调用 **mult5AfterAdd10** 时接受第二个参数就太棒了。

真的有这样一种方法，叫做 **柯里化** 。



#### 我的脑子！

![](https://cdn-images-1.medium.com/max/1600/1*IK5485-iZaHeZRfP8aWmYg.png)



到目前暂时足够消化一段了。

在文章接下来的部分里，我会涉及到柯里化，函数式编程中常见的函数（如 map，filter，fold 等），参照透明性等。

接下来 [第四部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-4.md)