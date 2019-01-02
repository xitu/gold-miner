> * 原文地址：[So You Want to be a Functional Programmer (Part 4)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-4-18fbe3ea9e49#.1p212lwov)
> * 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[linpu.li](https://github.com/llp0574)
> * 校对者：[luoyaqifei](https://github.com/luoyaqifei)，[supertong](https://github.com/supertong)

# 准备充分了嘛就想学函数式编程？(第四部分)

想要理解函数式编程，第一步总是最重要，也是最困难的。但是只要有了正确的思维，其实也不是太难。

之前的部分: [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-1.md), [第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-2.md), [第三部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-3.md)

#### 柯里化

![](https://cdn-images-1.medium.com/max/1600/1*zihd0We3yAkjAxleLPL2aA.png)

如果你还记得[第三部分](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7)内容的话，就会知道我们在组合 **_mult5_** 和 **_add_** 这两个函数时遇到问题的原因是：**_mult5_** 接收一个参数而 **_add_** 却接收两个。

其实只需要通过限制所有函数都只接收一个参数，就可以轻易地解决这个问题。

相信我，这并没有听起来那么糟糕。

我们只需要来写一个使用两个参数，但一次只接收一个参数的 add 函数。**柯里**函数允许我们这样做。

> 柯里函数是一种一次只接收单个参数的函数。

这就可以让我们在将 **_add_** 和 **_mult5_** 组合之前只传递第一个参数给 **_add_**。然后当调用（组合后的） **_mult5AfterAdd10_** 函数时，**_add_** 函数就将得到第二个参数。

在 JavaScript 里，可以通过改写 **_add_** 函数来实现这个功能：

    var add = x => y => x + y

这个版本的 **_add_** 函数现在就只接收一个参数，之后再接收另外一个参数。。

详细来讲，这个 **_add_** 函数接收单参数 **_x_**，然后返回一个接收单参数 **_y_** 的函数，而这个函数最终就会返回 **x + y** 的结果。

现在我们就可以使用这个版本的 **_add_** 函数来构建一个 **_mult5AfterAdd10_** 函数的可运行版本：

    var compose = (f, g) => x => f(g(x));
    var mult5AfterAdd10 = compose(mult5, add(10));

这个组合函数接收两个参数，**_f_** 和 **_g_**，然后它返回一个接收单参数 **_x_** 的函数，这个函数在调用的时候就会将 **_g_** 函数作用于 **_x_**，然后再将 **_f_** 函数作用于上一步的结果。

实际上我们到底做了什么呢？好吧，我们其实是将旧的 **_add_** 函数进行了柯里化。这么做就让 **_add_** 函数变得更加灵活，因为我们可以先把10作为第一个参数传入，而最后的参数则可以在 **_mult5AfterAdd10_** 被调用的时候传入。

看到这里，你可能会想知道在 Elm 里怎么来改写这个 **_add_** 函数。答案是，不需要改写。在 Elm 和其他函数式（编程）语言里，所有的函数都会自动柯里化。

所以这个 **_add_** 函数看起来和之前是一样的：

    add x y =
        x + y

**_mult5AfterAdd10_** 函数曾经在[第三部分](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7)怎么写，也还是一样：

    mult5AfterAdd10 =
        (mult5 << add 10)

语法上讲，Elm 其实打败了像 JavaScript 这样的命令式（编程）语言，因为它在函数式方面是做了优化的，就像柯里化和组合函数。

#### 柯里化和重构

![](https://cdn-images-1.medium.com/max/1600/1*kbFszF2qDVeeN591mpq8Ug.png)

柯里化在重构的的时候也能发挥它闪亮的一面，当我们创建一个多参数通用版本的函数时，我们可以通过柯里化的方法用它来创建接收更少参数的特定版本的函数。

举个例子，当我们有下面两个方法，在一个字符串前后分别添加一对大括号和两对大括号。

    bracket str =
        "{" ++ str ++ "}"

    doubleBracket str =
        "{{" ++ str ++ "}}"

下面是如何使用它们：

    bracketedJoe =
        bracket "Joe"

    doubleBracketedJoe =
        doubleBracket "Joe"

我们可以通用化 **_bracket_** 和 **_doubleBracket_** 函数：

    generalBracket prefix str suffix =
        prefix ++ str ++ suffix

但现在每当我们使用 **_generalBracket_** 时，都必须传入大括号：

    bracketedJoe =
        generalBracket "{" "Joe" "}"

    doubleBracketedJoe =
        generalBracket "{{" "Joe" "}}"

我们实际上想要的是两全其美。

如果我们重新对 **_generalBracket_** 函数的参数进行排序，就可以创建柯里化后的 **_bracket_** 和 **_doubleBracket_** 函数了。

    generalBracket prefix suffix str =
        prefix ++ str ++ suffix

    bracket =
        generalBracket "{" "}"

    doubleBracket =
        generalBracket "{{" "}}"

注意到通常将静态参数放到前面，如 **_prefix_** 和 **_suffix_**，而可变参数尽量放到最后，如 **_str_**，这样，就可以简单地创建出 **_generalBracket_** 函数的特定版本了。

> 参数顺序对全面柯里化来说非常重要。

还注意到 **_bracket_** 和 **_doubleBracket_** 函数都是免参数（point-free）写法，如 **_str_** 参数是隐式表明的。**_bracket_** 和 **_doubleBracket_** 函数都在等待最后参数的传入。

现在就可以像之前那样使用了：

    bracketedJoe =
        bracket "Joe"

    doubleBracketedJoe =
        doubleBracket "Joe"

但这次我们使用的是通用化的柯里函数：**_generalBracket_**。

#### 常用的功能函数

![](https://cdn-images-1.medium.com/max/1600/1*I7nCgMOzuVxKPj_amfQxNw.png)

让我们来看三个函数式（编程）语言里的常用函数。

但首先，来看看下面的 JavaScript 代码：

    for (var i = 0; i < something.length; ++i) {
        // do stuff
    }

这段代码有一个主要的错误，但并不是 bug。问题在于这个代码是一个模板代码，就是那些一遍又一遍重复写的代码。

如果你是使用像 Java、C#、JavaScript、PHP 和 Python 等这样的命令式（编程）语言。你就会发现相比其他语言你会写更多这样的模板代码。

这就是这段代码的问题所在。

所以让我们来解决它。将它放到一个函数里（或者几个函数），然后再也不写 for 循环了。好吧，几乎不写，至少直到我们移步使用一个函数式（编程）语言。

首先从修改一个 **_things_** 数组来开始：

    var things = [1, 2, 3, 4];
    for (var i = 0; i < things.length; ++i) {
        things[i] = things[i] * 10; // MUTATION ALERT !!!!
    }
    console.log(things); // [10, 20, 30, 40]

呃！！又是变量！

再试一次，这次不再去更改 **_things_** 数组了：

    var things = [1, 2, 3, 4];
    var newThings = [];

    for (var i = 0; i < things.length; ++i) {
        newThings[i] = things[i] * 10;
    }
    console.log(newThings); // [10, 20, 30, 40]

好了，我们没有更改 **_things_** 数组但技术上来说我们更改了 **_newThings_** 数组。目前为止，我们将忽略这个问题。毕竟我们在使用 JavaScript，一旦我们移步使用一个函数式语言，就不可以更改了。

这里的重点是弄明白这些函数是怎么工作的，以及它们怎么来帮助我们减少代码噪音（冗余等）。

来把这段代码放到一个函数里。接下来将调用我们第一个常用函数 **_map_**，它会将旧数组里的每个值映射成新值放到一个新的数组里。

    var map = (f, array) => {
        var newArray = [];

        for (var i = 0; i < array.length; ++i) {
            newArray[i] = f(array[i]);
        }
        return newArray;
    };

注意到 **_f_** 函数，它作为参数传入，这样就可以让 **_map_** 函数对**数组**里的每一项进行任何我们想要的操作。

现在我们就可以使用 **_map_** 来改写之前的代码了：

    var things = [1, 2, 3, 4];
    var newThings = map(v => v * 10, things);

看看，没有 for 循环，而且更简单易读，这就是（关于之前的代码错误）原因。

好吧，技术上来说，**_map_** 函数里是有 for 循环的，但至少我们不必再写一大堆模板代码了。

现在来写另外一个常用函数，从一个数组当中**过滤**一些数据：

    var filter = (pred, array) => {
        var newArray = [];
        for (var i = 0; i < array.length; ++i) {
            if (pred(array[i]))
                newArray[newArray.length] = array[i];
        }
        return newArray;
    };  
    
注意谓词函数 **_pred_** ，如果通过验证返回 TRUE，否则返回 FALSE。

下面展示了如何使用 **_filter_** 函数来过滤奇数：
    
    var isOdd = x => x % 2 !== 0;
    var numbers = [1, 2, 3, 4, 5];
    var oddNumbers = filter(isOdd, numbers);
    console.log(oddNumbers); // [1, 3, 5]

使用新的 **_filter_** 函数比用 for 循环来手写实现简单太多了。

最后一个常用函数叫做 **_reduce_**。一般来说，它用来接收一个列表并将其减少到一个值，但实际上可以用它做更多的事情。

在函数式（编程）语言里这个函数通常叫做 **_fold_**。

    var reduce = (f, start, array) => {
        var acc = start;
        for (var i = 0; i < array.length; ++i)
            acc = f(array[i], acc); // f() takes 2 parameters
        return acc;
    });

这个 **_reduce_** 函数接收一个（自定义）减少函数 **_f_**、一个初始 **_start_** 开始值和一个 **_array_** 数组。

注意到这个减少函数 **_f_**，接收两个参数，**_array_** 数组的当前项，以及累计器 **_acc_**。每次迭代，它都将使用这两个参数产生一个新的累计器，最后一次迭代得到的累计器将会被返回。

一个例子将帮助我们更好地来理解它如何工作：

    var add = (x, y) => x + y;
    var values = [1, 2, 3, 4, 5];
    var sumOfValues = reduce(add, 0, values);
    console.log(sumOfValues); // 15

注意到 **_add_** 函数接收两个参数并把它们相加。而  **_reduce_** 函数正是期望一个接收两个参数的函数，所以它们可以一起正常运行。

我们将初始 **_start_** 值设为0，并将 **_values_** 数组传入进行计算。**_reduce_** 函数内部，**_values_** 数组各项的总值作为累计器循环计算。最后的累计值返回为 **_sumOfValues_**。

每个这些函数，**_map_**、**_filter_** 和 **_reduce_**，都让我们可以在不必写 for 循环的情况下对数组进行常用操作。

但是在函数式（编程）语言里，它们甚至更有用，因为没有循环体只有递归。迭代函数不只是非常有用，它们是必要的。

#### 我的脑子！！！

![](https://cdn-images-1.medium.com/max/1600/1*IK5485-iZaHeZRfP8aWmYg.png)

目前为止足够了.

在这个系列文章的随后部分，我将谈到有关引用完整性、执行顺序、类型以及其他更多的东西。

下一篇: [第五部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-5.md)

**如果你喜欢这篇文章，点击下面的![💚](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f49a.png)，其他人就可以在这里看到了哦。**

如果你想加入 Web 开发者学习社区并帮助其他人在 Elm 里用函数式编程开发 Web 应用，请看我的 Facebook Group，**学习 Elm 编程** [https://www.facebook.com/groups/learnelm/](https://www.facebook.com/groups/learnelm/)。
