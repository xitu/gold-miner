> * 原文地址：[Writing a Compiler in Rust](http://thume.ca/2019/04/18/writing-a-compiler-in-rust/)
> * 原文作者：[Tristan Hume](https://github.com/trishume/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-compiler-in-rust.md](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-compiler-in-rust.md)
> * 译者：[suhanyujie](https://www.github.com/suhanyujie)
> * 校对者：[司徒公子](https://github.com/stuchilde)，[githubmnume](https://github.com/githubmnume)

# 用 Rust 写编译器

在 UWaterloo 的最后一个学期，我参加了 [CS444 编译器课程](https://www.student.cs.uwaterloo.ca/~cs444/)，这个课程有个项目，在你可以选择一种语言和两个队友的情况下，编写基于 x86 架构的 Java 子集编译器。我的三人小组选择使用 Rust 编写我们的编译器，这是一次有趣的经历。我们花了很多时间来设计一些能充分利用 Rust 优势的好方案。最终的编译器大约有 6800 行 Rust 代码，我个人大概用了 60 个小时来编写代码，并在代码设计和评审上投入了更多时间。在这篇文章中，我将回顾我们所做的一些设计，以及使用 Rust 的一些思考。

## 词法分析和解析

这个课程的讲座推荐使用 DFA 转化为 NFA 的编译器来实现词法分析器，并为解析器编写 [LR(1)](https://en.wikipedia.org/wiki/Canonical_LR_parser) 解析器生成器，然后使其分离传递并构造 AST（[抽象语法树](https://en.wikipedia.org/wiki/Abstract_syntax_tree)），然后以多种方式进行检验。

我建议我们应该尝试手写词法分析器和递归下降的解析器，我的队友也同意了。递归下降解析器可以让我们把所有要解析、验证和创建的 AST 节点代码放在一个地方。除了需要实现 LR(1) 解析器生成器这个额外工作之外，我们认为，原始的解析树重写为强类型 AST ，将需要与递归下降解析器一样多的代码。

我们构造的 AST 充分利用了 Rust 的类型系统，包括广泛使用 `enum` 加上类型来处理类型、表达式和语句的变体。我们还广泛使用了 `Option` 和 `Vec`，以及 `Box` 来实现递归类型。我们的 AST 类型类似于这样：

```rust
// 我们使用 Spanned 结构体保存源跨度信息
pub type Type = Spanned<TypeKind>;

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub enum TypeKind {
    Array(Box<Type>),
    Ref(TypeRef),
    Int,
    Byte,
    // ...
}

// ...

#[derive(Clone, Debug)]
pub struct InterfaceDecl {
    pub name: String,
    pub extends: Vec<TypeRef>,
    pub methods: Vec<Signature>,
}
```

我们使用一个 `Parser` 结构体来生成它，该结构具有解析不同结构的函数，这些函数也可能返回解析错误。`Parser` 结构有许多辅助函数，可以方便地使用和标记检查，借助于完整编程语言的抽象能力，可以让解析器生成器的 DSL 语法更简洁。下面是我们的解析器的部分示例代码：

```rust
#[derive(Clone, Debug)]
pub enum ParseError {
    Unexpected(SpannedToken),
    DuplicateModifier(SpannedToken),
    MultipleVisibilities,
    // ...
}

pub struct Parser<'a> {
    tokens: &'a [SpannedToken],
    pos: usize,
}

// ...

fn parse_for_statement(&mut self) -> PResult<ForStatement> {
    self.eat(&Token::For)?;
    self.eat(&Token::LParen)?;
    let init = self.parse_unless_and_eat(Token::Semicolon, Self::parse_for_init)?;
    let condition = self.parse_unless_and_eat(Token::Semicolon, Self::parse_expr)?;
    let update = self.parse_unless_and_eat(Token::RParen, Self::parse_statement_expr)?;
    let body = self.parse_statement()?;
    Ok(ForStatement { init, condition, update, body })
}

// ...
```

### 回溯

大多数情况下，我们的解析器采用 [LL(1) 解析器](https://en.wikipedia.org/wiki/LL_parser) 的形式，它向前查看一个标记来决定如何解析。但是有些结构需要无限的向前查看来解析。例如 `(java.lang.String)a`，除开末尾的使其成为强制表达式的 `a`，应该将其解析为在“java”变量上带括号的字段访问链。事实上， 即使是 `LR(1)` 解析器也不能正确地解析这个特定案例，推荐一个 hack 方法，将 parens 内部解析为“表达式”，然后在 weeder（tips：文末有注解）中验证该表达式实际上是一种类型。

我们使用回溯来解决这个问题，在回溯中我们可以在 token 流中保存一个位置，并尝试性地将后续的输入解析为一个结构，如果解析失败，则回滚到保存时的位置。这可能会导致对不合理输入的处理时间是非线性的，但非常规情况在实践中不一定是坏的，尤其是回溯仅仅只是用于一些特定的情况而非整个解析器。

在某些情况下，回溯的另一种策略是解析两个非终结符的公共元素，然后当解析到解析器可以确定的状态点时，调用特定的非终结符函数，并将已解析的内容作为参数传递。我们使用此策略来决定解析类、接口、解析方法和构造器之间的关系，首先解析修饰符，然后查看前面的内容，再解析“解析修饰符后的结果”作为参数的其余部分。

我们使用 Rust 的辅助函数，通过尝试一个解析，然后在第一个解析返回 `Err` 时尝试另一个解析的方式，使得回溯变得非常容易：

```rust
// 和 Java 规范不同，我们可以使用 `allow_minus` 这样的参数来避免在少量情况下出现很多重复。
// `allow_minus` 确保 `(a)-b` 被解析为 `int-int` 而不是 `(Type)(-int)`
fn parse_prim_expr(&mut self, allow_minus: AllowMinus) -> PResult<Box<Expr>> {
    let cur = &self.tokens[self.pos];
    let mut lhs = match &cur.tok {
        Token::LParen => self.one_of(Self::parse_cast_expr, Self::parse_paren_expr),
        // ...
    };
    // ...
}
```

### Pratt 表达式解析

我们使用 [Pratt 解析 / precedence climbing](https://www.oilshell.org/blog/2017/03/31.html) 方式，而非解析多语法优先级表达式。Pratt 算法允许将运算符指定为具有“绑定能力”的整数表，该整数表具有高优先级运算符所具有的绑定能力。这对于解析具有多种优先级的表达式来说既简单又高效。

我们没有像规范的 Pratt 解析器实现中那样使用整数表，而是使用 Rust 的 match 语句功能，它具有一样的作用，并且功能更加强大，且无需保存数据结构：

```rust
fn binding_power(cur: &SpannedToken) -> Option<u8> {
    match &cur.tok {
        Token::Operator(op) => match op {
            Op::Times | Op::Divide | Op::Modulo => Some(12),
            Op::Plus | Op::Minus => Some(11),
            Op::Greater | Op::GreaterEqual | Op::Less | Op::LessEqual => Some(9),
            Op::Equal | Op::NotEqual => Some(8),
            Op::And => Some(7),
            // ...
        },
        Token::Instanceof => Some(9),
        _ => None,
    }
}
```

## 快照测试

从完成解析器到继续实现编译器的剩余部分，我们广泛的使用了 [insta crate](https://github.com/mitsuhiko/insta) 的快照测试。快照测试（类似于 [expect 测试](https://blog.janestreet.com/testing-with-expectations/)），它可以让我们只提供一些测试过程以及对应结果的数据结构，并且测试系统会创建测试结果的“快照”，将其存放在一个文件中。如果结果发生变化会导致测试失败，并且显示出快照文件和结果之间的差异。如果预期发生改变，则可以运行一个命令来更新快照文件。

这是我们解析器特别强大的地方，在我们解析整个文件和对应的内容之前，我们可以解析一小段代码为 AST 来实现 Rust 中的 `Debug` trait，并且 `insta` 将创建美化后的快照，这样我们可以检查是否正确，然后提交，便于后续的回归检查。

```rust
#[test]
fn test_statement() {
    let mut lexer = file_lexer("testdata/statements.java");
    let tokens = lexer.lex_all().unwrap();
    let mut parser = Parser::create(&tokens);

    let statement = parser.parse_statement();
    assert_debug_snapshot_matches!("statements", statement);
}
```

在后面的代码生成阶段，我们广泛地使用它来检查测试程序上的汇编输出。

## 语义分析

编译器大约有一半的工作量是在中间阶段，该阶段主要是计算“代码生成”以及验证各种属性的正确性。包括以下内容：

* 解析变量和类型名称
* 转换形如 `5*3+2` 的常量表达式为数字
* 检查多个不同的 Java 类 / 接口结构的限定。
* 检查所有语句都是可用的，以及非 `void` 函数的返回。
* 解析所有表达式的类型并检查它们是否正确。

### Visitor 基础构造

编译器中端中的大部分地方只关心能确定的 AST 节点，但是也需要对那些在 AST 的任何位置可能出现的节点有效。一种方法是通过整个 AST 对每个补丁进行模式匹配，但如此多的节点会导致大量的重复。

相反，我们有 `Visitor` trait（类似于其他语言中的接口），可以通过“编译器传递”来实现它。它只对我们实际需要的事件有回调，这些回调可以在遍历 AST 节点时的不同地方运行代码，也可以在适当的位置修改 AST。所有回调都有默认的实现，默认情况下它们什么也不做，因此“编译器传递”只需要实现它们需要的方法。

```rust
// 我们使用了一个动态错误类型，这样就不必让“访问者”成为通用状态，并为每种错误类型实例化它。
pub type VResult = Result<(), Box<std::error::Error>>;

pub trait Visitor {
    // 用于解析变量引用
    fn visit_var_ref(&mut self, _t: &mut VarRef) -> VResult {
        Ok(())
    }

    fn start_method(&mut self, _t: &mut Method) -> VResult {
        Ok(())
    }

    // `finish_` 方法遍历它们的主体后，产生对应的结果，并将此结果传递给它们，以便它们能够包装错误以提供更好的上下文信息
    fn finish_method(&mut self, _t: &mut Method, res: VResult) -> VResult {
        res
    }

    // 类似于 `finish_` 方法，只是它不需要结果
    fn post_expr(&mut self, _t: &mut Expr) -> VResult {
        Ok(())
    }

    // ... 一些其他方法
}
```

实现 `Visitor` 的传递由 `Visitable` trait 的动态分派调用驱动。每个 AST 节点都实现这个 trait，并按赋值顺序遍历整个树。我们充分利用了 Rust 一个很酷的特性“blanket impls”，这使得处理处于容器内的 AST 的逻辑干净而统一。

```rust
pub trait Visitable {
    fn visit(&mut self, v: &mut dyn Visitor) -> VResult;
}

impl<T: Visitable> Visitable for Vec<T> {
    fn visit(&mut self, v: &mut dyn Visitor) -> VResult {
        for t in self {
            t.visit(v)?;
        }
        Ok(())
    }
}

// ... Option<T> 和 Box<T> 的其它 blanket impls

impl Visitable for TypeKind {
    fn visit(&mut self, v: &mut dyn Visitor) -> VResult {
        match self {
            TypeKind::Array(t) => t.visit(v)?,
            TypeKind::Ref(t) => t.visit(v)?,
            _ => (),
        }
        Ok(())
    }
}

impl Visitable for ForStatement {
    fn visit(&mut self, v: &mut dyn Visitor) -> VResult {
        v.start_for_statement(self)?;
        // 闭包允许我们使用吗？合并结果
        let res = (|| {
            self.init.visit(v)?;
            self.condition.visit(v)?;
            self.update.visit(v)?;
            self.body.visit(v)
        })();
        v.finish_for_statement(self, res)
    }
}

// ... 很多其它可见的实现
```

这使得“编译传递”更简单。例如，常量折叠只是覆盖 `post_expr` 方法，检查表达式的子元素节点是否为常量，如果是，则使用 `mem::replace` 代替常量节点。

### 解析名称

前面我们讨论了如何处理解析类型和变量名。最明显的方法是使用初始值为 `None` 的 `Option` 类型来修改 AST。然而，我们的函数式编程者本能地不想这么做，想用其它更好的方法。使用可选的字段还有一个问题，我们在代码生成阶段就知道所有变量都将被解析，但是类型系统仍然认为它们可以是 `None`，因而我们每次想访问它们的时候需要使用 `unwrap()` 解包装。

我们首先考虑使用一个副表，在该表中我们为每个命名的引用提供一个 ID 或者哈希值，然后在解析阶段创建从 ID 到解析结果作为映射。但是我们不喜欢这样，会使调试变得更加困难，因为我们不再能通过 `Debug` 打印出 AST 的类型来查看它们的包括“解决提示”在内的所有信息。而且它还需要传递很多副表，并在后面的阶段对它们进行大量查找。它甚至没有解决对 `unwrap` 的依赖。因为从理论上讲，表的访问不能直接找到对应的元素。

接下来，我们考虑使用注解类型参数使所有 AST 类型都能具有泛型能力，该参数一开始是 `()`，但随着 AST 获取更多信息阶段后会发生改变。这样做的话，主要问题是每次“传递”都要重新构建整个 AST，这将使简单的查询基础设施更加困难。也许如果 Rust 有类似 [自动派生的 `Functor` 实现](https://gitlab.haskell.org/ghc/ghc/wikis/commentary/compiler/derive-functor)就会好很多，除非它需要大量的样本文件。在不同的阶段，我们还需要注解很多东西，这就需要很多参数，以及很多 AST 类型，这就需要对 AST 和解析器进行大量重构，以添加这些参数。

因此，我们咬咬牙，使用了 `Option` 类型字段这种方案，并且我觉得效果还不错。我们实现了很棒的 `Reference<T, R>` 泛型类型，它有一个 `raw` 和 `resolved` 字段。我们将它用于变量和类型引用。它实现了 `Hash` 和 `PartialEq` trait，这些实现有助于查看已解析的值，因为这对以后的数据结构很重要。它还有一个特殊的 `Debug` 实现，使快照测试的输出更友好：

```rust
impl<T: fmt::Debug, R: fmt::Debug> fmt::Debug for Reference<T, R> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if let Some(r) = &self.resolved {
            write!(f, "{:#?} => {:#?}", self.raw, r)
        } else {
            write!(f, "{:?}", self.raw) // 如果还未解析，则打印原始数据
        }
    }
}
```

### 引用计数

在许多不同的地方，特别是类层次结构检查和类型检查阶段，这些过程中需要传递同一个数据。例如，类型在表达式中向上冒泡，或者继承方法中，向下的冒泡树。在如 Java 这样的语言中，我们只需要对同一个对象有多个引用，但是在 Rust，由于所有权的原因，我们不能直接这样做。我们开始在一些地方通过克隆（`clone`）来实现，这个方式挺好的，但我意识到我可以切换到使用 `Rc` 类型来进行共享数据所有权。

我曾经历过这样有趣的时刻，那时候，我想“天哪，这段代码必须实现所有的引用计数操作，太糟糕了，没必要这么慢，或许我应该寻找更好的其他方案重构它”。然后，我意识到，如果我是用 Swift 写的话，我就不会要考虑这个问题了，因为 Swift 中，**所有**的东西都可以被引用计数的，它比 Rust 中的**原子**引用计数要稍逊一筹。用 Rust 编写代码让我觉得有必要使用其它语言没有的特性来尽可能快的编写代码，而这仅仅是为了解决成本问题。有时候我还提醒自己，它已经够快的了。

## 代码生成

本课程要求我们生成文本类型的 NASM x86 汇编文件。考虑到我们只需要输出这些，我们决定去除用于生成汇编的中间抽象层，并且我们的代码生成阶段可以只是用 Rust 字符串格式化方式。这将使我们的代码更简单、更易懂，并且允许我们更容易地在生成的汇编程序中包含注释。

我们通过整个编译器保存了源码信息，并且可以生成注释，这个特性非常有用，因为我们可以为每个生成的代码段输出包含源表达式、语句位置的注释信息。这样可以更容易并且准确地跟踪到是哪段代码导致了 bug。

我们遇到的一个有些恼人的问题是，我们可以找到两种简单的格式化字符串的方法，可这两个方法都有个问题：

```rust
let mut s = String::new();
// 即使没有出错，也还是需要返回值的类型或者对其 unwrap
// 生成一堆需要优化的垃圾错误处理的 LLVM
writeln!(s, "mov eax, {}", val)?;
// 分配一个中间临时字符串变量，然后立即释放该变量空间
s.push_str(format!("mov eax, {}", val));
```

我两个队友一同处理代码生成的初始阶段，他们每个人都选择了这个折衷方案的不同分支，在课程的尾声时，我们一致性标准已经放宽了，所以我们的代码生成能兼具这两个分支。

### Usercorn

我们的编译器支持输出 Linux ELF 二进制文件，并链接到运行时，供 Linux 系统调用。然而，我们这个团队都使用 macOS。重写 macOS 的运行时可能会有些烦人，因为系统调用并不总是像 Linux 那样简单，且有很好的文档支持。如果我们坚持将二进制文件通过 `scp` 发送到 Linux 服务器上或者 VM 上，可能会导致测试结果有延迟，并让控制变得复杂。

我记得有个网友写了一个很酷的工具，叫 [usercorn](https://github.com/lunixbochs/usercorn)，使用 [Unicorn CPU emulator](https://www.unicorn-engine.org/) 加上一些想象在 macOS 上运行 Linux 二进制程序，前提是这些程序是通用的二进制程序（反过来也会有一堆问题）。构建一个包含自己的版本很简单，我可以检入我们的仓库并在测试中使用它来运行。然后，我的队友找到了一个由 `ld` 构建的 macOS，它可以链接 Linux ELF 二进制文件并包含它。

我们还可以使用 `usercorn` 输出程序中经过修改的寄存器的所有指令的跟踪状态，这在调试代码时非常方便。

我还遇到一个问题，在 usercorn 下执行大量内存分配测试比在真实的 Linux 服务器上慢 1000 倍。幸运的是，我认识 usercorn 作者，我给他发了能复现异常的二进制程序文件，的，合理的程序不会像教程中提供的运行时那样，对每个内存分配都使用 `brk` 调用。他很快相他很快排查到这个问题是由于 `brk` 的系统调用效率低效导想出了解决办法，并在当天晚上提供了该解决方案，解决了我的问题。他真的很棒，你们可以[订阅他的 Patreon](https://www.patreon.com/lunixbochs/overview)

然后，我将预先编译好的 `usercorn` 和 `ld` 包（带有用于分配内存测试的 bug 修复）分享给我认识的使用 macOS 的其他团队成员，这样可以便于他们测试。

## 结语

总的来说，我为我们的编译器的表现感到骄傲。这是一个有趣的项目，我的队友都很出色。最后我认为用 Rust 来实现是一个很好的选择，特别是它强大的枚举和模式匹配。Rust 的主要缺点是编译时间长（尽管可以明显比得上 C++ 编译器），并且有时候我们不得不做更多的工作来满足借用检查。

通过跟其他的团队交流，比较了用不同的语言和不同的设计来做同一个项目的心得是从这个项目中学习到的最有趣的经验之一。我会在后面的文章中讨论这些。

## 注解
### weeder
* [weeder](https://metacpan.org/pod/release/LIBVENUS/HPPPM-Demand-Management-0.04/lib/FieldParser.pm#weeder)：消除/去除/过滤输入字符中无用、无意义字符的逻辑单元

---

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
