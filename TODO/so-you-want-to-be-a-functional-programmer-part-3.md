> * 原文地址：[So You Want to be a Functional Programmer (Part 3)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7#.7e7fhqghb)
* 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Airmacho](https://github.com/Airmacho)
* 校对者：

# So You Want to be a Functional Programmer (Part 3)

# 准备充分了嘛就想学函数式编程？(Part 3)

Taking that first step to understanding Functional Programming concepts is the most important and sometimes the most difficult step. But it doesn’t have to be. Not with the right perspective.

Previous parts: [Part 1](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-1-1f15e387e536), [Part 2](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-2-7005682cec4a)

#### Function Composition

函数组合

![](https://cdn-images-1.medium.com/max/1600/1*yGnDGRW4pTgmcDUi4oC8Uw.png)





As programmers, we are lazy. We don’t want to build, test and deploy code that we’ve written over and over and over again.

We’re always trying to figure out ways of doing the work once and how we can reuse it to do something else.

Code reuse sounds great but is difficult to achieve. Make the code too specific and you can’t reuse it. Make it too general and it can be too difficult to use in the first place.

So what we need is a balance between the two, a way to make smaller, reusable pieces that we can use as building blocks to construct more complex functionality.

In Functional Programming, functions are our building blocks. We write them to do very specific tasks and then we put them together like Lego™ blocks.

This is called **_Function Composition_**.

作为程序员，懒惰是我们的美德。我们不想不断重复地构建，测试，部署写过的代码。

我们希望有办法可以一处写完，各处复用。

代码复用听起来很棒，实现起来很困难。如果代码写的非常明确，就不能复用。太泛化的话，最开始用都困难。

所以我们需要权衡，有种方案是写简短可复用的代码，我们可以将它们当作零件用来组合成更复杂的代码。

在函数式编程中，函数就是我们的零件。我们可以用它们来完成指定的任务，再像乐高积木一样拼凑在一起。

这被称作**函数组合**。

So how does it work? Let’s start with two Javascript functions:

这怎么实现呢，让我们用这两个 JavaScript 函数来说：

    var add10 = function(value) {
        return value + 10;
    };
    var mult5 = function(value) {
        return value * 5;
    };

This is too verbose so let’s rewrite it using [**_fat arrow_**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) notation:

这个写法太冗长，所以我们用箭头函数表达式重写成：

    var add10 = value => value + 10;
    var mult5 = value => value * 5;

That’s better. Now let’s imagine that we also want to have a function that takes a value and adds 10 to it and then multiplies the result by 5\. We _could_write:

好多了，现在设想我们再需要一个函数，它可以接受一个值作为参数，将值与10相加，再把结果乘以5的返回。我们可以写成：

    var mult5AfterAdd10 = value => 5 * (value + 10)

Even though this is a very simple example, we still don’t want to have to write this function from scratch. First, we could make a mistake like forget the parentheses.

Second, we already have a function that adds 10 and another that multiplies by 5\. We’re writing code that we’ve already written.

So instead, let’s use **_add10_** and **_mult5_** to build our new function:

尽管这只是一个很简单的需求，我们仍不想重新写一个新的函数。首先，我们可能会因为忘记括号而出错。

其次，我们已经有一个函数可以将值加上 10，另一个函数将值可以乘以 5。我们这是在重复之前的工作。

因此，我们用 **add10** 和 **mult5** 来构建我们的新函数：

    var mult5AfterAdd10 = value => mult5(add10(value));
We just used existing functions to create **_mult5AfterAdd10_**, but there’s a better way.

In math, **_f ∘ g_** is functional composition and is read **_“f composed with g”_** or, more commonly, **_“f after g”_**. So **_(f ∘ g)(x)_** is equivalent to calling **_f_** after calling **_g_** with **_x_** or simply, **_f(g(x))_**.

In our example, we have **_mult5 ∘ add10_** or **_“mult5 after add10”_**, hence the name of our function, **_mult5AfterAdd10_**.

And that’s exactly what we did. We called **_mult5_** after we called **_add10_** with **_value_** or simply, **_mult5(add10(value))_**.

Since Javascript doesn’t do Function Composition natively, let’s look at Elm:

我们用现有的函数来创建 **mult5AfterAdd10** 函数，但有更好的办法。

在数学中， **_f ∘ g_** 是函数的组合，所以读作 **“函数 f 与函数 g 的复合函数”**，或者更通用的说法是 **“在 g 之后调用 f”**。所以 **_(f ∘ g)(x)_** 相当于先以 **x** 为自变量调用函数 **g**，再以结果为自变量调用函数 **f**，简写成  **_f(g(x))_**。

对于我们的例子，我们可以用  **_mult5 ∘ add10_** 或者  **_“mult5 after add10”_** 来表示，所以我们的函数名叫 **_mult5(add10(value))_** 。

    add10 value =
        value + 10
    
    mult5 value =
        value * 5
    
    mult5AfterAdd10 value =
        (mult5 << add10) value

The **_<<_** infixed operator is how you _compose_ functions in Elm. It gives us a visual sense of how the data is flowing. First, **_value_** is passed to **_add10_** then its results are passed to **_mult5_**.

Note the parentheses in **_mult5AfterAdd10_**, i.e. **_(mult5 << add10)_**. They are there to make sure that the functions are composed first before applying **_value_**.

You can compose as many functions as you like this way:

在 Elm 中，你可以用插入运算符 **<<** 来组合函数。这在带给我们一种数据是怎样流动的视觉效果。首先，**value** 传入 **add10** 中，再将结果作为参数传入 **mult5** 中。

注意 **mult5AfterAdd10** 中的括号，比如  **_(mult5 << add10)_**。这里是说明函数是先组合，再传入参数 **value** 的。

你可以用这种方式随意组合函数：

    f x =
       (g << h << s << r << t) x

Here **_x_** is passed to function **_t_** whose result is passed to **_r_** whose result is passed to **_s_** and so on. If you did something similar in Javascript it would look like **_g(h(s(r(t(x)))))_**, a parenthetical nightmare

这里 **x** 传入函数 **t** ，将运算结果传给函数 **r**，然后再将结果传给函数 **s**，这样一直进行下去。如果你要在 JavaScript 里实现类似的功能，看起来会是这样  **_g(h(s(r(t(x)))))_**，括号的恶梦。

#### Point-Free Notation

#### Point-Free 表示法

![](https://cdn-images-1.medium.com/max/1600/1*g2pWcQJ0jOUf1WKbTDIktQ.png)





There is a style of writing functions without having to specify the parameters called **_Point-Free Notation_**. At first, this style will seem odd but as you continue, you’ll grow to appreciate the brevity.

In **_mult5AfterAdd10_**, you’ll notice that **_value_** is specified twice. Once in the parameter list and once when it’s used.

有一种可以不需要指定参数的函数写法，叫做 **Point-Free 表示法**。开始时，这种风格看起来有些奇怪，随着使用继续，你会开始欣赏它带来的简洁性。

你可以注意到，在 **mult5AfterAdd10** 里我们有两处用到 **value** 变量。一处是在参数列表中，一处是内部使用时。

    -- This is a function that expects 1 parameter

    mult5AfterAdd10 value =
        (mult5 << add10) value

But this parameter is unnecessary since **_add10,_ **the rightmost function in the composition, expects the same parameter. The following point-free version is equivalent:

其实这个参数并不是必须的，因为 **add10**，组合中最外侧的函数，和函数组合接受的参数相同。与下面的 point-free 版本是等价的：

    -- This is also a function that expects 1 parameter

    mult5AfterAdd10 =
        (mult5 << add10)

There are many benefits from using the point-free version.

First, we don’t have to specify redundant parameters. And since we don’t have to specify them, we don’t have to think up names for all of them.

Second, it’s easier to read and reason about since it’s less verbose. This example is simple, but imagine a function that took more parameters.

用这种 point-free 风格表示法有很多好处。

首先，我们不需要指定多余的参数。因为我们不要明确指定它们，我们可以不用去费心给它们起名字。

其次，因为更简洁，阅读和理解起来也更容易。这个例子就非常简单，但是设想需要更多参数的函数。

#### Trouble in Paradise

#### 天堂里的烦恼

![](https://cdn-images-1.medium.com/max/1600/1*RE3Qxh6Bg9umzQ5dOrF6pw.png)





So far we’ve seen how Function Composition works and how we should specify our functions in Point-Free Notation for brevity, clarity and flexibility.

Now, let’s try to use these ideas in a slightly different scenario and see how they fare. Imagine we replace **_add10_** with **_add_**:

到目前为止，我们已经见过函数组合是怎样工作的，我们如何用 Point-Free 风格的写法来提高代码的简洁性，清晰性和灵活性。

现在让我们尝试在稍微不同的场景中运用这些思想。设想我们用 **add** 替换 **add10**:

    add x y =
        x + y
    
    mult5 value =
        value * 5

How do we write **_mult5After10_** with just these 2 functions?

Think about it for a bit before reading on. No seriously. Think about. Try and do it.

Okay, so if you actually spent time thinking about it, you may have come up with a solution like:

我们如何只用这两个函数来组合 **mult5After10** 呢？

继续读之前请先思考这个问题，想一想，试着做一做。

好，如果你真的花时间想了，也许你会想到这样的方案：

    -- This is wrong !!!!

    mult5AfterAdd10 =
        (mult5 << add) 10

But this wouldn’t work. Why? Because **_add_** takes 2 parameters.

If this isn’t obvious in Elm, try to write this in Javascript:

但是这不行，为什么？因为 **add** 函数需要两个参数。

用 Elm 也许不明显，可以用 JavaScript 写：

    var mult5AfterAdd10 = mult5(add(10)); // this doesn't work

This code is wrong but why?

Because the **_add_** function is only getting 1 of its 2 parameters here then its _incorrect results_ are passed to **_mult5_**. This will produce the wrong results.

In fact, in Elm, the compiler won’t even let you write such mis-formed code (which is one of the great things about Elm).

Let’s try again:

这段代码是错的，为什么？

因为 **add** 函数只接受两个必需参数的一个，然后**错误结果**再被传入 **mult5** 函数，结果也是错的。

实际上，在 Elm 中，编译器不会让你写出这种残缺的代码（ Elm 的优点之一）

    var mult5AfterAdd10 = y => mult5(add(10, y)); // not point-free
This isn’t point-free but I could probably live with this. But now I’m no longer just combining functions. I’m writing a new function. Also, if this gets more complicated, e.g. if I want to compose **_mult5AfterAdd10_** with something else, I’m going to get into real trouble.

So it would appear that Function Composition has limited usefulness since we cannot marry these two functions. That’s too bad since it’s so powerful.

How could we solve this? What would we need to make this problem go away?

Well, what would be really great is if we had some way of giving our **_add_**function only one of its parameters _ahead of time_ and then it would get its second parameter _later_ when **_mult5AfterAdd10_** is called.

Turns out there is way and it’s called **_Currying_**.

这样不是 point-free 的，但可用。但是现在不再是函数组合了，我写了一个新的函数。另外，如果函数更复杂，例如，如果我想用 **mult5AfterAdd10** 与其他函数组合，那就会很麻烦。

可见函数组合的可用性有限，因为我们不能将这两个函数结合在一起。太糟了。

我们怎样解决这个问题呢？我们需要做什么？

如果我们可以找到一种方法可以让 **add** 函数先接受一个参数，再在后面调用 **mult5AfterAdd10** 时接受第二个参数就太棒了。

真的有这样一种方法，叫做 **柯里化** 。



#### My Brain!!!!

#### 我的脑子！

![](https://cdn-images-1.medium.com/max/1600/1*IK5485-iZaHeZRfP8aWmYg.png)





Enough for now.

In subsequent parts of this article, I’ll talk about Currying, common functional functions (e.g map, filter, fold etc.), Referential Transparency, and more.

到目前暂时足够消化一段了。

在文章接下来的部分里，我会涉及到柯里化，函数式编程中常见的函数（如 map，filter，fold 等），参照透明性等。

Up next: [Part 4](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-4-18fbe3ea9e49)