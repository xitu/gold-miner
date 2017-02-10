> * 原文地址：[So You Want to be a Functional Programmer (Part 5)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-5-c70adc9cf56a#.ewys56rfy)
* 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[luoyaqifei](http://www.zengmingxia.com)
* 校对者：[cyseria](https://github.com/cyseria)，[malcolmyu](https://github.com/malcolmyu)

# 准备充分了嘛就想学函数式编程？(第五部分)


迈出理解函数式编程概念的第一步是最重要的，有时也是最难的一步。但是不一定特别难。只要选对了思考方法就不难。

前几部分: [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-1.md), [第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-2.md), [第三部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-3.md), [第四部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-4.md)

#### 引用透明









![](https://cdn-images-1.medium.com/max/1600/1*4QRVgRMKN2che7VG8H5FxA.png)





**引用透明** 是一个很酷炫的术语，它指的是一个纯函数能够安全地被它的表达式所替代。下面用一个例子来解释这个术语。

在代数中当你有以下这个公式时：

    y = x + 10

并且已知：

    x = 3

你可以将 **_x_** 代入方程来得到：

    y = 3 + 10

此时这个方程依旧成立。我们可以对纯函数进行相同类型的代入。

这里是一个 Elm 的函数，它将单个引号放在提供的字符串周围：

    quote str =
        "'" ++ str ++ "'"

这里有一些使用了它的代码：

    findError key =
        "Unable to find " ++ (quote key)

在这里 **_findError_** 创建了一个当搜索 **_key_** 不成功时会产生的错误信息。

既然 **_quote_** 函数是纯的，我们可以简单地用 **_quote_** 的函数体（只是个表达式）来替代 **_findError_** 中的函数调用：

    findError key =
       "Unable to find " ++ ("'" ++ str ++ "'")

这就是我称作 **反向重构** （对我来说意味着更多）的东西，即一个可以被程序员或程序（例如：编译器和测试程序）用来分析代码的过程。

这尤其对递归函数的分析有帮助。

#### 执行顺序









![](https://cdn-images-1.medium.com/max/1600/1*k8zgyx2Mhlg6F82aSR9U4A.png)





大多数程序是单线程的，也就是说，一次有且只有一段代码被执行。即使你有一个多线程化的程序，其中的多数线程会在等待 I/O 完成时被阻塞，比如说，文件、网络等。

这就是在写代码时，我们自然地使用有序的步骤来思考的一个原因：

    1. 拿出面包
    2. 将两片面包放入吐司机
    3. 选择焦脆程度
    4. 压下控制杆
    5. 等待弹出吐司
    6. 移走吐司
    7. 拿出黄油
    8. 拿切黄油的刀
    9. 将黄油在吐司上涂匀

在这个例子里，有两个独立的操作：拿黄油和烤面包。它们只在步骤 9 变成互相依赖的。

我们可以并发地执行步骤 7 、 8 和 步骤 1 ～ 6 ，因为它们是互相独立的。

然而一旦我们这么做了，事情就变复杂了：

    线程 1
    --------
    1. 拿出面包
    2. 将两片面包放入吐司机
    3. 选择焦脆程度
    4. 压下控制杆
    5. 等待弹出吐司
    6. 移走吐司

    线程 2
    --------
    1. 拿出黄油
    2. 拿切黄油的刀
    3. 等待线程 1 完成
    4. 将黄油在吐司上涂匀

如果线程 1 失败了，线程 2 会发生什么？有什么可以协调这两个线程的机制吗？谁拥有吐司呢？线程 1， 线程 2， 亦或两者？

不思考这些复杂的东西，让我们的程序继续单线程化，是更简单的举措。

但是到了提升我们程序中任何一丁点可能的效率都值得的时候，我们必须使用极大的努力来写多线程软件。

然而对于多线程现在有两个主要的问题。一是多线程化的程序难写、难读、难分析、难测试而且难调试。

二是某些语言并不支持多线程，比如 JavaScript ，又或者有些语言支持但支持得很差。

但是，假若顺序并不重要且所有东西都并行地被执行呢？

尽管这听起来很疯狂，它并不如它听起来那样混乱。让我们看看一些 Elm 代码，来阐述这个吧：

    buildMessage message value =
        let
            upperMessage =
                String.toUpper message

            quotedValue =
                "'" ++ value "'"

        in
            upperMessage ++ ": " ++ value

这里 **_buildMessage_** 接收 **_message_** 和 **_value_** 两个参数，生成了一个大写的 **_message_** 、一个冒号和在单引号里的 **_value_** 。

注意 **_upperMessage_** and **_quotedValue_** 是怎么相互独立的。我们怎么知道这些呢？

对于这种独立性而言，有两个条件是必须的。第一个条件是，它们必须是纯函数。这很重要，因为它们必须要不被另一个的执行所影响。

如果它们不纯，我们永远不会知道它们是独立的。这样的话，我们必须依赖于它们在程序内被调用的顺序来确定它们的执行顺序。这就是所有的命令式语言的工作机制。

第二个独立的条件是，一个函数的输出不被另一个作为输入使用。如果不满足这个条件，我们需要等待一个结束执行来使另一个开始执行。

当前情况下的 **_upperMessage_** 和 **_quotedValue_** 都是纯的且互不需要对方的输出的。

因此，这两个函数可以在 **任意顺序** 下执行。

编译器能够在不需要程序员的任何帮助的情况下作出决定，这只可能在纯函数语言里发生。因为确定非纯函数副作用的影响这件事，就算有可能性，也难度太高。

> 纯函数语言的执行顺序可以由编译器决定。

考虑到 CPU 并不会变得越来越快，这种特性显得极有优势。而且，生产厂商正在添加越来越多的内核，这意味着代码可以在硬件层面并行执行。

不幸的是，如果使用命令式语言，我们只能用一种粗糙的方式来充分利用内核优势，但是这么做需要大规模地改变我们程序的架构。

使用纯函数式语言，我们有机会在一个细粒度层面自动地利用 CPU 内核的优势，而不改变任何一行代码。

#### 类型标注









![](https://cdn-images-1.medium.com/max/1600/1*btL9u2b5VZwivpqNbfoVmw.png)





在静态类型语言中，类型在行内定义。以下 Java 代码可以说明：

    public static String quote(String str) {
        return "'" + str + "'";
    }

请注意类型定义和函数定义发生在同一行。如果你有范型的话，情况会变得更糟：

    private final Map getPerson(Map people, Integer personId) {
       // ...
    }

我已经加粗了类型，使它们更加明显，但是它们仍旧与函数定义相干扰。你需要仔细阅读它来找到变量名。

使用动态类型语言的话，这就不是个问题了。在 JavaScript 里，我们像这样写代码：

    var getPerson = function(people, personId) {
        // ...
    };

没有讨厌的类型信息挡路，这显得易读得多。唯一的问题就是我们牺牲了类型安全性。我们可能会很容易地传入相反的参数，即为 **_people_** 传入一个 _Number_ 类型的参数、为 **_personId_** 传入一个 _Object_ 参数。

直到程序执行后，我们才会找出这里面的问题，这可能发生在代码已经进入生产环境好几个月后。这种情况不会在 Java 里发生，因为它没法通过编译。

但要是我们可以同时拥有这两个代码世界的精华呢： JavaScript 的简洁性和 Java 的安全性。

事实证明我们可以。以下是一个带有类型标注的 Elm 函数：

    add : Int -> Int -> Int
    add x y =
        x + y

请注意类型信息是怎么放在单独一行的。这种分离创造了一个不同的世界。

现在你可能会觉得类型标注有错字，因为在我初瞥时我也这么以为。我当时认为第一个 **_->_** 应该要是一个逗号，然而其实并没有错字。

当你意识到它带有隐含的括号时，就能感受到它的一点意义了：

    add : Int -> (Int -> Int)

这条语句是指 **_add_** 是一个函数，它接收 _单个_ **_Int_** 类型的  参数，返回一个接收 _单个_ **_Int_** 类型参数并返回一个 **_Int_** 值的函数。

以下是另一个将隐含的括号显示出来的类型标注：

    doSomething : String -> (Int -> (String -> String))
    doSomething prefix value suffix =
        prefix ++ (toString value) ++ suffix

这条语句说的是 **_doSomething_** 是一个函数，它接收 _单个_ 类型为 **_String_** 的参数，返回一个接收以 **_Int_** 为类型的 _单个_ 参数和返回一个 **_String_** 的函数。

请注意所有的函数是怎样接收 _单个_ 参数的。这是因为每个 Elm 函数都是柯里化的。

既然括号总是隐含在右边，它们不是必需的。所以我们可以简单地写成：

    doSomething : String -> Int -> String -> String

当我们将函数作为参数传入的时候，括号就是必需的了。如果没有括号，类型标注将会显得模棱两可，比如：

    takes2Params : Int -> Int -> String
    takes2Params num1 num2 =
        -- do something

完全不同于：

    takes1Param : (Int -> Int) -> String
    takes1Param f =
        -- do something
**_takes2Param_** 是一个需要两个参数的函数，一个 **_Int_** 参数和另一个 **_Int_** 参数。然而， **_takes1Param_** 需要一个参数，即一个接收  **_Int_** 和返回 一个 **_Int_** 的函数。

以下是 **_map_** 的类型标注：

    map : (a -> b) -> List a -> List b
    map f list =
        // ...

这里括号是必需的，因为 **_f_** 是 **_(a -> b)_** 类型的，也就是说，它是一个接受单个 **_a_** 类型参数并且返回 **_b_** 类型的值的函数。

此处类型 **_a_** 是任意类型。当类型是大写的，它就是显式类型，比如 **_String_**。当类型是小写的，它可以是任意类型。此处 **_a_** 可以是 **_String_** 也同样可以是 **_Int_**。

I如果你看到 **_(a -> a)_**， 那就意味着输入类型和输出类型 **必须** 是一样的。它们是什么不重要，但是它们必须匹配。

但是在 **_map_** 的情况下，我们有 **_(a -> b)_**。这意味着它 **可以** 返回一个不同的类型但它同样 **可以** 返回相同的类型。

然而一旦 **_a_** 的类型确定了， **_a_** 在整个签名里都必须是这个类型。例如，如果 **_a_** 是 **_Int_** 并且 **_b_** 是 **_String_** 那么签名等同于：

    (Int -> String) -> List Int -> List String

此处所有的 **_a_** 已经被 **_Int_** 替换了，并且所有的 **_b_** 也被 **_String_** 替换了。

**_List Int_** 类型指的是一个 **_Int_** 列表， **_List String_** 类型指的是一个 **_String_** 列表。如果你用过 Java 或其他语言里的范型，那么这个概念你应该熟悉。

#### 我的大脑！！！！









![](https://cdn-images-1.medium.com/max/1600/1*IK5485-iZaHeZRfP8aWmYg.png)





这一部分就到这里吧，相信你已经学到了足够多的东西。

在这篇文章的最后一部分，我会谈论的是你可以如何将你学到的这些东西应用在你的日常工作中，譬如函数式 JavaScript 和 Elm。

下一部分： [第六部分](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-6.md)

如果你想加入一个 web 开发者社区，学习并互相帮助使用 Elm 语言进行函数式编程，请加入我们的 Facebook 小组， **_Learn Elm Programming_** [https://www.facebook.com/groups/learnelm/](https://www.facebook.com/groups/learnelm/)
