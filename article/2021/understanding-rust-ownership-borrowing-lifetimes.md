> * 原文地址：[Understanding Rust: ownership, borrowing, lifetimes](https://medium.com/@bugaevc/understanding-rust-ownership-borrowing-lifetimes-ff9ee9f79a9c)
> * 原文作者：[bugaevc](hhttps://medium.com/@bugaevc)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/understanding-rust-ownership-borrowing-lifetimes.md](https://github.com/xitu/gold-miner/blob/master/article/2021/understanding-rust-ownership-borrowing-lifetimes.md)
> * 译者：[大宁的洛竹](https://github.com/youngjuning)
> * 校对者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)、[Zz招锦](https://github.com/zenblo)

# 理解 Rust：所有权、借用、生命周期

我对这些概念的理解是，你一旦掌握了它，所有这些语法都会看起来自然且优雅。

我不会从零开始展开教学，也不会机械地重复官方文档的内容（虽然说有时会 🙈）—— 如果你还不了解这些概念，那么你现在应该读一下[对应章节](https://kaisery.github.io/trpl-zh-cn/ch04-00-understanding-ownership.html)的内容，因为本文是对书上内容的补充，而不是要替代它。

另外，我也建议你读一下[这篇](http://blog.skylight.io/rust-means-never-having-to-close-a-socket/)出色的文章。它实际上是在讲述相近的话题，但关注点不一样，也值得一读。

让我们先来谈谈资源是什么。资源是宝贵的、“沉重的”、可以获取和释放（或销毁）的东西，比如一个套接字，一个打开的文件，一个信号量，一个锁，一个堆内存区域。按照传统，所有这些事情都是通过调用一个函数来创建的，该函数返回对资源本身的某种引用（一个内存指针或一个文件描述符），当程序认为自己已完成对资源的处理时，需要程序员 👨🏻‍💻 显式关闭该文件。

这种方法存在着问题。人非圣贤，孰能无过。通常我们很容易忘记释放某些资源，从而导致发生所谓的**内存泄漏**。更糟糕的是，人们可能会尝试访问已经释放的资源（即在释放之后使用）。如果运气好，他们会收到一条报错消息，这可能会帮助他们识别和修复错误，也可能不会。反之，它们所具有的引用（尽管就逻辑而言是无效的）可能仍是引用某个“内存位置”，而该“内存位置”已经被其他资源占用。例如说已存储其他内容的内存，其它打开的文件所使用的文件描述符等。试图通过无效的引用访问旧资源可能会破坏其他资源或使得程序完全崩溃。

我们讨论这些问题并不是杞人忧天，因为它们无时无刻伴随着我们。比如，在 [Google Chrome 发布博客](http://googlechromereleases.blogspot.ru/search/label/Stable%20updates)中就存在着大量因为使用了被释放的资源引发的漏洞和崩溃的修复记录 —— 这也极大的浪费了人力物力，去识别和修复它们。

并不是说开发人员是愚蠢和健忘的，因为逻辑流程本身就容易出错：它需要你显示释放资源，但是并不强制你做这些。此外，我们通常不会注意到资源被忘记释放，因为这个问题很少会有着什么明显的影响。

有时要实现简单的目地就需要发明复杂的解决方案，而这些解决方案会带来更复杂的逻辑。我们很难避免在庞大的代码库中迷失，并且 Bug 总是在这里或那里突然冒出来，我们最终也见怪不怪了。其中大多数的问题都很容易被发现，但是与资源相关的错误却很难被发现。因此，一旦如果资源被野指针利用，便会非常危险。

![](https://i.loli.net/2021/03/01/xBOd1QFu27Kfkp6.png)

当然，像 Rust 这样的新语言无法为你解决 Bug，但是，它可以成功地影响你的思维方式，将一些架构带入你的思想，从而使这类错误的发生几率大大降低。

Rust 为你提供了一种安全清晰的方法来管理资源。而且，它不允许你以其他任何方式对其进行管理。这是非常严格的，但这不正是我们的目的吗？

这些限制之所以很棒，有几个原因:

- 它们能让你以正确的方式思考。在有了一些 Rust 开发经验后，即使在其他语言的语法中没有内置这些概念时，你也经常会发现自己尝试应用相似的概念。
- 它们能让你编写的代码更安全。除了几个很稀有的[极端案例](https://doc.rust-lang.org/nomicon/meet-safe-and-unsafe.html)，Rust 基本上可以保证你所有的代码都不会涉及我们正在谈论的错误。
- 虽然如果有垃圾收集机制，Rust 就会像高级语言一样令人愉悦（我可没说 JavaScript 是令人愉悦的！），但是 Rust 与其他低级编译语言一样快且接近底层。

考虑到这一点，让我们来看一下 Rust 的一些优点。

## 所有权

在 Rust 中，关于资源属于哪块代码有很明确的规则。在最简单的情况下，是代码块创建了代表资源的对象。在代码块的末尾，对象被销毁且资源被释放。这里重要的区别是对象不是某种容易忘记的“弱引用”。在内部，该对象只是用于完全相同引用的包装器，而从外部看，它似乎是它表示的资源。当到达拥有资源的代码块的末尾时，资源将会自动且可预测地释放。

当编译到拥有该内存的代码的尾部，程序会自动且安全地释放资源。妈妈再也不用担心忘记释放资源了！因为该行为是全自动且可预测的，它完全会按照你的预期来完成。

这时你可能会问，为什么我要描述这些琐碎而明显的事情，而不是仅仅告诉你聪明人称之为 [RAII](https://zh.wikipedia.org/wiki/RAII) 的概念？ 好吧，让我们继续聊一下。

这个概念适用于临时对象。比如以下操作：`将一些文本写入文件` -> `专用代码块（例如，一个函数）将打开一个文件`（结果是得到一个文件对象（包装文件描述符））-> `然后对其进行一些处理` -> `然后在该块的末尾将得到文件对象` -> `最后删除并且文件描述符关闭`。

但是在很多场景中这个概念并不管用。你可能希望将资源传递给其他人，在几个“用户”之间甚至在线程之间共享它。

让我们来看看这些。首先，你可能希望将资源传递给其他人（转移所有权），被转移的人便会拥有资源，可以对资源进行任何操作，甚至更重要的是负责释放资源。Rust 很好的支持了这一点，实际上，当你将资源提供给其他人时，默认便会发生这种情况。

```rust
fn print_sum(v: Vec<i32>) {
    println!("{}", v[0] + v[1]);
    // v 被移除随后被释放
}

fn main() {
    let mut v = Vec::new(); // 资源在这里被创建
    for i in 1..1000 {
        v.push(i);
    }
    // 在这里， 可变变量 v 被使用
    // 不少于 4000 字节的内存
    // -------------------
    // 转移所有权给 print_sum 函数
    print_sum(v);
    // 我们不拥有并且不能以任何方式控制变量 v
    // 在这里尝试访问 v 将引发编译时错误
    println!("We're done");
    // 这里并不会发生任何释放动作
    // 因为 print_sum 此时负责可变变量 v 的一切
}
```

所有权转移的过程也称为**移动**，因为资源是从旧位置（例如，局部变量）被移动到了新位置（例如，一个函数参数）的。从性能角度来看，这只是“弱引用”被移动，因此这个过程很快。但是对于代码来说，好像我们实际上将整个资源都移到了新地方。

移动和复制是有区别的。广义来说，它们都意味着复制数据（如果 Rust 允许复制资源的话，这种情况下将是“弱引用”），但移动后，原始变量的内容将被视为不再有效或不再重要。Rust 实际上会将该变量视为“ [逻辑上未初始化](https://doc.rust-lang.org/nomicon/checked-uninit.html)”，也就是说，充满了一些垃圾，例如刚刚创建的那些变量。这类变量是被禁止使用的（除非你使用新值重新初始化它），此时也不会发生资源的重新分配：现在拥有资源的人有责任在完成后进行清理。

移动不仅限于传递参数。你可以移动给一个变量。你还可以移至返回值。为此，你可以从返回值、变量、函数参数移动。基本上到处都是隐式和显示的分配。

尽管移动语法是处理资源的完全合理的方式，我将在稍后演示对于普通的旧原始数字类型变量来说，这将是一场灾难（设想无法复制一个 int 类型变量的值给另一个变量）。幸运的是，Rust 有 [Copy 特征](https://doc.rust-lang.org/std/marker/trait.Copy.html)。实现它的类型（所有原始类型都使用）在分配时使用复制语法，所有其他类型都使用移动语法。这非常容实现，如果你希望自己的类型是可以被复制的，则只需要可选地实现 `Copy` 特征。

```rust
fn print_sum(a: i32, b: i32) {
    println!("{}", a + b);
    // 被复制的 a 和 b 变量在这里被移除和释放
}

fn main() {
    let a = 35;
    let b = 42;
    // 复制和传递值
    // 被复制的值传递的所有权传递给 print_sum：
    print_sum(a, b);
    // 我们仍然保留对原始a和b变量的完全控制权
    println!("We still have {} and {}", a, b);
    // 原始的 a 和 b 被移除并随后被释放
}
```

现在，我们来探讨下为什么移动语法会有用呢？如果没有他们，一切都显得那么完美。好吧，也不完全是。有时候，这是最合乎逻辑的事情。比如 [with_capacity](https://doc.rust-lang.org/std/string/struct.String.html#method.with_capacity) 函数会分配一个字符串缓冲区，然后将其返回给调用方。所有权被转移了，并且该函数不再关心缓冲区的生死。而调用者可以完全控制缓冲区，包括负责缓冲区的释放。

在 C 语言中是一样的。诸如 `strdup` 之类的功能将分配内存，将其内存管理交给你，并期望你进行管理并最终对其进行分配。区别在于它只是一个指针，它们所能做的就是在完成后要求或提醒你使用 `free()`。上面所说的移动特性几乎无法做到，而在 Rust 中，这是该语言不可分割的一部分。

另一个示例是迭代器适配器，比如 [count](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.count) 这种无论如何之后都没有访问迭代器的意义。

相反的问题是，在什么情况下，我们需要对同一资源有多个引用。最明显的用例是进行多线程处理的场景。否则，如果所有操作都按顺序执行，则移动语法可能总是起作用的。尽管如此，一直来回移动东西还是很不方便的。

有时，尽管代码严格按顺序运行，但仍然感觉好像同时发生了几件事。想象一下在 vector（可变数组）上进行迭代。循环完成后，迭代器可以将你对相关 vector 的所有权转移给你，但你将无法在循环内获得对 vector 的任何访问权限。也就是说，除非你每次迭代都在你的代码和迭代器之间拥有所有权，否则那将是一团糟。似乎也无法在不破坏堆栈的情况下遍历一棵树，然后重新构造并备给以后做其他事情时用。

同时，我们将无法执行多线程，这就很不方便甚至让人厌烦。值得庆幸的是，还有一个很酷的 Rust 概念可以为我们提供帮助。那就是借用！

## 借用

> 当一个函数使用引用而不是值本身作为参数时，我们便不需要为了归还所有权而特意去返回值，毕竟在这种情况下，我们根本没有取得所有权。这种通过引用传递参数给函数的方法也被成为借用。——《Rust 权威指南》

我们有多种角度解读借用：

- 它使我们在拥有资源的多个引用的同时仍坚持“单一所有者，单一责任”的概念。
- 引用类似于 C 语言中的指针。
- 引用也是一个对象。可变引用被移动，不可变引用被复制。删除引用后，借用将终止（取决于生命周期规则，请参见下一节）。
- 在最简单的情况下，引用的行为就像在没有明确地进行所有权操作的情况下来回移动所有权。

下面这段代码就是最后一条的意思：

```rust
// 没有借用发生
fn print_sum1(v: Vec<i32>) -> Vec<i32> {
    println!("{}", v[0] + v[1]);
    // 返回 v 把所有权返回
    // 顺便一提，由于 Rust 是基于表达式的，所有这里不需要使用 return 关键字便可返回值
    v
}

// 有借用，明确的引用
fn print_sum2(vr: &Vec<i32>) {
    println!("{}", (*vr)[0] + (*vr)[1]);
    // vr 是一个引用，在这里被移除，因为借用结束了
}

// 这就是你应该做的
fn print_sum3(v: &Vec<i32>) {
    println!("{}", v[0] + v[1]);
    // 同 print_sum2
}

fn main() {
    let mut v = Vec::new(); // 创建可变数组
    for i in 1..1000 {
        v.push(i);
    }
    // 此时， v 被使用
    // 不超过 4000 字节的内存

    // 传递 v 的所有权给 print_sum 并在执行结束后反会 v
    v = print_sum1(v);
    // 现在，我们重新取得了 v 的所有权
    println!("(1) We still have v: {}, {}, ...", v[0], v[1]);

    // 取 v 的引用传递给 print_sum2（借用它）
    print_sum2(&v);
    // v 现在仍然可以被使用
    println!("(2) We still have v: {}, {}, ...", v[0], v[1]);

    // 此时仍可以
    print_sum3(&v);
    println!("(3) We still have v: {}, {}, ...", v[0], v[1]);

    // v 被移除并在此处被释放
}
```

让我们看看这里发生了什么。第一个函数中，我们可以始终转移所有权，但是我们已经确信有时这并不是我们想要的。

第二个函数中，我们对 vector 进行引用，然后将其传递给函数。和 C 语言很像，我们通过解引用来获取对象。由于没有复杂的生命周期，因此一旦删除引用，借用便会终止。虽然它看起来像第一个示例，但是有一个重要的区别。`main` 函数拥有 vector 的所有权，在借用 vector 时只能对它做些限制。在这个示例中，`main` 函数在借用 vector 时甚至没有机会观察向量，因此这没什么大不了的。

第三个函数结合了第一个函数不需要解引用和第二个函数不弄乱所有权的优点。这之所以可行是因为 Rust 的[自动解除引用规则](http://stackoverflow.com/questions/28519997/what-are-rusts-exact-auto-dereferencing-rules)。这些有点复杂，但是在大多数情况下，它们可以使你几乎就像使用引用指向的对象一样编写代码，这和 C++ 的引用很相似。

这里是另一个示例：

```rust
// 通过不可变引用获取 v
fn count_occurences(v: &Vec<i32>, val: i32) -> usize {
    v.into_iter().filter(|&&x| x == val).count()
}

fn main() {
    let v = vec![2, 9, 3, 1, 3, 2, 5, 5, 2];
    // 为迭代借用 v
    for &item in &v {
        // the first borrow is still active
        // 第一个借用仍生效
        // 我们在这里第二次借用
        let res = count_occurences(&v, item);
        println!("{} is repeated {} times", item, res);
    }
}
```

你无需关心 `count_occurrences` 函数内部发生的事情，只需要知道它借用了 vector 即可（再次提醒，没有移动它）。循环也借用了 vector，因此我们有两个借用处于同时活动状态。循环结束后，`main` 函数将删除 vector。

哈哈，我会有点不地道了。我前面提到多线程是需要引用的主要原因，但是我展示的所有示例都是单线程的。如果你真的有兴趣，可以在 Rust 中获得有关多线程的一些[详细信息](https://doc.rust-lang.org/book/concurrency.html)。

获取和删除引用似乎很有效，好像涉及到垃圾回收一样。但实际并不是这样的。这一切都在编译时完成。为此，Rust 需要另一个神奇的概念。让我们看下以下示例代码：

```rust
fn middle_name(full_name: &str) -> &str {
    full_name.split_whitespace().nth(1).unwrap()
}

fn main() {
    let name = String::from("Harry James Potter");
    let res = middle_name(&name);
    assert_eq!(res, "James");
}
```

这是可以被成功编译的，但下面的代码是无法被编译的:

```rust
fn middle_name(full_name: &str) -> &str {
    full_name.split_whitespace().nth(1).unwrap()
}

fn main() {
    let res;
    {
        let name = String::from("Harry James Potter");
        res = middle_name(&name);
        // `name` 在这里被移除并随后被释放
    }
    assert_eq!(res, "James");
}
```

首先，让我们解释下 [`string` 类型](http://doc.rust-lang.org/book/strings.html)。`String` 拥有字符串缓冲区，一个 `&str`（字符串切片）是 `String` 类型的一段或其他内存的一段（在这里并不重要）。

为了解释地更加明显，我用 C 语言编写类似的内容：

> 顺便一提：在 C 语言中，你不能获取字符串的中间部分，因为标记字符串的结尾将需要更改字符串，因此我们仅限于在此处查找姓氏。

```c
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

const char *last_name(const char *full_name)
{
    return strrchr(full_name, ' ') + 1;
}

int main() {
    const char *buffer = strcpy(malloc(80), "Harry Potter");
    const char *res = last_name(buffer);
    free(buffer);
    printf("%s\n", res);

    return 0;
}
```

你现在明白了吗？在使用结果之前，将删除缓冲区并重新分配缓冲区。这是一个在释放后使用资源的特殊例子。 如果 `printf` 的实现不会立即将内存用于其他用途，则此 C 代码可以编译并运行良好。不过，在一个不那么特殊的示例中，它仍然是崩溃、错误和安全漏洞的来源。正是在介绍所有权之前我们所说的。

你甚至无法在 Rust 中进行编译（我的意思是上面的 Rust 代码）。这种静态分析机制已内置在语言中，并且在整个生命周期可用。

## 生命周期

资源在 Rust 中是有生命周期的。他们从被创造的那一刻起一直存在到被移除的那一刻。生命周期通常被认为是作用域或代码块，但这实际上并不是一个准确的表述，因为资源可以在代码块之间移动，正如我们已经看到的那样。我们无法引用尚未创建或已删除的对象，我们很快就会看到这个要求是如何被强制执行。否则，这一切看起来都与所有权概念并没有什么不同。

这是比较难理解的一部分。引用以及其他对象也具有生存期，并且这些生存期可能与它们的借用的生存期不同（所谓的关联生命周期）。

让我们来改写下代码。借用的持续时间可能长于它所控制的引用的时间。这通常是因为可以使用另一个引用，该引用取决于借用是否处于活动状态——可以借用相同的对象或只借用其一部分，例如上例中的字符串切片。

实际上，每个引用都会记住它所代表的借用期限，也就是说，每一个引用都有一个生命周期。像所有与“借用检查”相关的事情一样，这是在编译时完成的，并且不占用任何运行时开销。与其他事物不同，你有时必须明确指定生命周期详细信息。

综上所述，让我们用代码深入探讨下：

``` rust
fn middle_name<'a>(full_name: &'a str) -> &'a str {
    full_name.split_whitespace().nth(1).unwrap()
}

fn main() {
    let name = String::from("Harry James Potter");
    let res = middle_name(&name);
    assert_eq!(res, "James");

    // 不会被编译:

    /*
    let res;
    {
        let name = String::from("Harry James Potter");
        res = middle_name(&name);
    }
    assert_eq!(res, "James");
    */
}
```

在前面的示例中，我们不必明确地指出生命周期，因为生命周期的细致程度足以让 Rust 编译器自动找出来（请参阅[lifetime elision](https://doc.rust-lang.org/book/lifetimes.html ＃lifetime-elision)）。无论如何，我们已经在这里演示了它们的工作原理。

`<>` 表示该函数在整个生命周期内都是通用的，我们称其为 `a`。也就是说，对于具有关联生命周期的任何引用传入，它将返回具有相同关联生命周期的另一个引用。友情提示，关联的生命周期是指借用的生命周期，而不是引用的生命周期。

在实践中，它的含义可能不是显而易见的，所以让我们从相反的角度来看它。返回的引用被存储在 `res` 变量中，该变量在 `main()` 的整个范围内都有效。那是引用的生命周期，因此借用（相关的生命周期）至少存在了很长的时间。这意味着函数传入参数的关联生命周期必须相同，因此我们可以得出结论，必须为整个函数借用 `name` 变量。

在释放后使用的示例中（此处已注释），`res` 的生命周期仍然是整个函数，而 `name` 的生存周期没有足够长的时间，以至于借用不能在整个函数中有效。如果你尝试编译此代码，毫无疑问会触发编译错误。

Rust 编译器尝试使借用的生命周期尽可能短，理想情况下，一旦引用被移除就结束了（这是我在**借用**部分开始时所说的“最简单的情况”）。“借用应有尽可能长的生命周期” 的约束却是以另一种相反的方式运作的，比如从 `result` 到原始借用的生命周期会延伸地很长。只要满足所有约束条件，此过程就会停止，如果无法实现，则会出错。

你无法欺骗 Rust 让函数的返回的借用的值与生命周期完全无关，因为那样的话，在函数中你将得到相同的 `does not live long enough` 报错信息，因为不相关的生命周期可能比传入的生命周期长很多。

让我们来看下这个示例：

```rust
fn search<'a, 'b>(needle: &'a str, haystack: &'b str) -> Option<&'b str> {
    // 想象这里有一些聪明的算法
    // 返回了一个原始字符串的切片
    let len = needle.len();
    if haystack.chars().nth(0) == needle.chars().nth(0) {
        Some(&haystack[..len])
    } else if haystack.chars().nth(1) == needle.chars().nth(0) {
        Some(&haystack[1..len+1])
    } else {
        None
    }
}

fn main() {
    let haystack = "hello little girl";
    let res;
    {
        let needle = String::from("ello");
        res = search(&needle, haystack);
    }
    match res {
        Some(x) => println!("found {}", x),
        None => println!("nothing found")
    }
    // 输出 "found ello"
}
```

`search` 函数接受两个引用，这些引用具有完全不相关的生命周期。尽管 `haystack` 受到限制，但关于 `needle` 的唯一要求是在函数本身执行时借用必须有效。完成后，借用立即结束，我们可以安全地重新分配关联的内存，同时仍然保持函数结果不变。

`haystack`是用字符串字面量初始化的。这些是 `&’static str` 类型的字符串切片（一个始终有效的借用）。因此我们可以在需要时将 `res` 变量保持在有效范围内。这是借用期限尽可能短规则的例外。你可以将其视为对“借用字符串”的另一个限制：字符串字面量借用必须持续整个程序的整个执行时间。

最后，我们返回的不是引用本身，而是一个内部的复合对象。这是完全支持的并且不会影响我们的一生逻辑。

因此，在此示例中，该函数接受两个参数，并且在两个生存期内都是通用的。让我们看看如果我们将生命周期设置为相同，会发生什么情况：

```rust
fn the_longest<'a>(s1: &'a str, s2: &'a str) -> &'a str {
    if s1.len() > s2.len() { s1 } else { s2 }
}

fn main() {
    let s1 = String::from("Python");
    // 明确借用以确保借入的持续时间长于s2
    let s1_b = &s1;
    {
        let s2 = String::from("C");
        let res = the_longest(s1_b, &s2);
        println!("{} is the longest if you judge by name", res);
    }
}
```

我在内部代码块之外进行了明确的借用，因此借用会在 `main()` 的其余部分都有效。这明显和 `&s2` 的生命周期不一样。如果仅接受两个具有相同生命周期的参数，那么这里为什么可以调用该函数？

事实证明，相关的生命周期会受到 [类型强制](https://en.wikipedia.org/wiki/Type_conversion) 的约束。与大多数语言（至少是我所熟知的那些语言）不同，Rust 中的原始（整数）值不会强制转换，为此你必须始终明确地强制转换它们。你可以在一些不太明显的地方找到强制转换，例如这些关联的生命周期和 [dynamic dispatch with type erasure](http://doc.rust-lang.org/book/trait-objects.html#dynamic-dispatch)。

我们用 C++ 代码进行比较：

```c++
struct A {
    int x;
};

struct B: A {
    int y;
};

struct C: B {
    int z;
};

B func(B arg)
{
    return arg;
}

int main() {
    A a;
    B b;
    /*
     * 这很好用：B值是有效的A值
     * 换句话说，只要期望A值，就可以使用B值
     */
    a = b;
    /*
     * 另一方面，这将是一个错误
     */

    // b = a;

    // 这能很好地工作
    C arg;
    A res = func(arg);
    return 0;
}
```

派生类型强制为其基本类型。 当我们传递 `C` 的实例时，它强制转换为 `B`，然后返回，强制转换为 `A`，然后存储在 `res` 变量中。

同样，在 Rust 中，更长的借用可以被强制缩短。它不会影响借用本身，而只会在需要较短借用的地方起作用。因此，你可以为函数传递寿命比预期更长的借用（它将被强制执行），并且可以强制将返回的借用的生命周期缩短。

再考虑一下这个示例：

```rust
fn middle_name<'a>(full_name: &'a str) -> &'a str {
    full_name.split_whitespace().nth(1).unwrap()
}

fn main() {
    let name = String::from("Harry James Potter");
    let res = middle_name(&name);
    assert_eq!(res, "James");

    // 不会被编译：

    /*
    let res;
    {
        let name = String::from("Harry James Potter");
        res = middle_name(&name);
    }
    assert_eq!(res, "James");
    */
}
```

人们通常会想知道这样的函数声明是否意味着参数的关联生命周期必须（至少）与返回值一样长，反之亦然。

答案现在应该很明显。对函数来说，两个生命周期完全相同。但是由于可以强制，你可以将其借用更长的时间，甚至可以在获得结果之后缩短结果的关联生命周期。因此正确的答案是参数必须至少与返回值一样长。

而且，如果你创建一个通过引用接受多个参数的函数，并声明它们必须具有相等的关联生命周期（如在我们之前的示例中一样），则该函数的实际参数将被强制为其中最短的生命周期。这只是意味着结果不能超过任何借用的参数。

这与我们之前讨论的反向约束规则可以很好地配合。被调用者并不关心这些-它只是获得并返回相同生命周期的借用。

另一方面，调用者确保参数的关联生命周期永远不会比结果的生命周期短，可以通过扩展它们来实现。

## 小技巧

- 你不能移走借用的值，因为在借用结束后该值必须保持有效。即使你在下一行中移回某些内容，也无法将其移出。但是 `[mem::replace](https://doc.rust-lang.org/std/mem/fn.replace.html)` 特征可以让你同时做这两件事。
- 如果你想拥有一个像 C++ 中的 `unique_ptr` 一样的指针，可以使用 `[Box](https://doc.rust-lang.org/std/boxed/index.html)` 类型。
- 如果你想进行一些基本的引用计数-例如 C ++ 中的 `shared_ptr` 和 `weak_ptr`，可以使用 [这些标准模块](https://doc.rust-lang.org/std/rc/index.html)
- 如果你确实需要摆脱 Rust 所施加的限制，则可以随时求助于 [unsafe code](https://doc.rust-lang.org/nomicon/meet-safe-and-unsafe.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
