> * 原文地址：[Writing a Compiler in Rust](http://thume.ca/2019/04/18/writing-a-compiler-in-rust/)
> * 原文作者：[Tristan Hume](https://github.com/trishume/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-compiler-in-rust.md](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-compiler-in-rust.md)
> * 译者：
> * 校对者：

# Writing a Compiler in Rust

在 UWaterloo 的最后一个学期，我参加了 [CS444 编译器班级](https://www.student.cs.uwaterloo.ca/~cs444/)，这个班有个项目，在你可以选择一种语言和两个队友的情况下，编写基于 x86 架构的 Java 子集编译器。我所在的团队选择使用 Rust 编写我们的编译器，这真是一次有趣的经历。我们花了很多时间来设计一些能充分利用 Rust 优势的好方案。最终的编译器大约有 6800 行 Rust 代码，我个人大概用了 60 个小时来编写代码，并在代码设计和评审上投入了更多时间。在这篇文章中，我将回顾我们所做的一些设计，以及使用 Rust 的一些想法。

## Lexing and Parsing

这个课程的讲座推荐写基于 DFA 的 NFA 编译器来实现词法分析器，并编写 [LR(1)](https://en.wikipedia.org/wiki/Canonical_LR_parser) 解析器生成器，然后使其分离传递并构造 AST（[抽象语法树](https://en.wikipedia.org/wiki/Abstract_syntax_tree)），然后以多种方式进行检验。

我建议我们应该尝试手写词法分析器和递归下降的解析器，我的队友也同意了。递归下降解析器可以让我们把所有要解析、验证和创建 AST 节点的代码放在一个地方。我们认为，除了必须实现 LR(1) 解析器生成器这个额外工作之外，通过遍历来将原始解析树重写为一个强类型 AST 将需要与递归下降解析器一样多的代码。

我们制作的 AST 充分利用了 Rust 的类型系统，包括广泛使用 `enum` 加上类型来处理类型、表达式和语句的变体。我们还广泛使用了 `Option` 和 `Vec`，以及 `Box` 来实现递归类型。我们的 AST 类型类似于这样：

```rust
// 我们使用 `Spanned` 结构体保存各种源信息
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

我们使用一个 `Parser` 结构体来生成它，其中包含用于解析不同结构的函数，解析这些函数时也可能出现解析错误。`Parser` 结构有许多辅助函数，可以方便地使用以及 token 验证，借助于编程语言的抽象能力，可以让解析器生成器的 DSL 更简洁。下面是我们的解析器的示例代码：

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

### Backtracking

大多数情况下，我们的解析器采用 [LL(1) 解析器](https://en.wikipedia.org/wiki/LL_parser) 的形式，它向前查看一个标记来决定如何解析。但是有些结构需要无限的向前查看来解析。例如 `(java.lang.String)a`，除开末尾的使其成为强制表达式的 `a`，应该将其解析为在“java”变量上带括号的字段访问链。事实上，即使是 `LR(1)` 解析器也不能正确地解析这种特殊情况，建议将 parens 内部解析为“表达式”，然后在 weeder（tips：文末有注解） 中验证该表达式实际上是一种类型。

我们使用回溯来解决这个问题，在回溯中我们可以在 token 流中保存一个位置，并尝试性地将后续的输入解析为一个结构，如果解析失败，则回滚到保存时的位置。这可能会导致对非常规输入的处理时间是非线性的，但非常规情况在实践中不一定是坏的，尤其是回溯仅仅只是用于一些特定的情况而非整个解析器。

在某些情况下，回溯的另一种策略是解析两个非终结符的公共元素，然后当解析到可以确定结果集的状态时，调用特定的非终结符函数，并将已解析的内容作为参数传递。我们使用此策略来决定解析类、接口、解析方法和构造函数之间的关系，首先解析修饰符，然后查看前面的内容，再解析“解析修饰符后的结果”作为参数的其余部分。

我们有 Rust 的辅助函数，所以用回溯的方式去尝试解析，然后再解析另一个真的简单多了。假如第一次解析返回 `Err`：

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

### Pratt expression parsing

Instead of parsing expressions with precedence using many grammar levels, we use a [Pratt parsing / precedence climbing](https://www.oilshell.org/blog/2017/03/31.html) system. This algorithm allows specifying the operators as a table with a “binding power” integer, with higher binding power for operators with higher precedence. This is both easier and more efficient for parsing expressions with many levels of precedence.

Instead of using data tables like in the canonical Pratt parser implementation, we used Rust functions with match statements, which fill the same purpose but with more power and no need to keep a data structure around:

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

## Snapshot testing

Starting when we did our parser and continuing for the rest of our compiler, we made extensive use of snapshot testing with the [insta crate](https://github.com/mitsuhiko/insta). Snapshot testing (similar to [expect tests](https://blog.janestreet.com/testing-with-expectations/)) allows you to write tests which just provide the resulting data structure of some process and the testing system will create a “snapshot” of the result of that test in a file, and if the result ever changes it will cause a test failure and show you the diff between the snapshot file and the result it got. If the change was expected, you can then run a command to update the snapshot files that changed.

This was super useful for writing our parser, before we could parse full files and do anything with them, we could parse short snippets into AST types implementing the Rust `Debug` trait, and `insta` would create pretty-printed snapshots that we could inspect for correctness, and then commit to check for future regressions.

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

Later during the code generation phase we used this extensively to check our assembly output on test programs.

## Semantic analysis

About half of our compiler is in the middle-end passes which compute information necessary for code generation and verify various correctness properties. This includes:

* Resolving variable and type names.
* Folding constant expressions like `5*3+2` into numbers.
* Checking many different constraints of the Java class/interface hierarchy.
* Checking that all statements are reachable and all non-`void` functions return.
* Resolving types of all expressions and checking their correctness.

### Visitor infrastructure

Most of the passes in the middle of our compiler only care about certain AST nodes, but need to act on those nodes anywhere they might occur in the AST. One way to do this would be to pattern match through the whole AST in every patch, but there’s a lot of nodes so that would involve a lot of duplication.

Instead we have a `Visitor` trait (like an interface in other languages) which can be implemented by a compiler pass. It has callbacks only for the events we actually need, which can run code at various points in the traversal of the AST, as well as modify the AST in place. All the callbacks have default implementations that do nothing so that passes only need to implement the methods they need.

```rust
// We use a dynamic error type here so we don't have to make the visitor generic and
// instantiate it a bunch for every error type
pub type VResult = Result<(), Box<std::error::Error>>;

pub trait Visitor {
    // used for resolving variable references
    fn visit_var_ref(&mut self, _t: &mut VarRef) -> VResult {
        Ok(())
    }

    fn start_method(&mut self, _t: &mut Method) -> VResult {
        Ok(())
    }

    // `finish_` methods get passed the result of traversing their body so that they
    // can wrap errors to provide better location information
    fn finish_method(&mut self, _t: &mut Method, res: VResult) -> VResult {
        res
    }

    // like a `finish_` method except it doesn't need the result
    fn post_expr(&mut self, _t: &mut Expr) -> VResult {
        Ok(())
    }

    // ... a bunch of other methods
}
```

Passes that implement `Visitor` are driven by dynamically dispatched calls from the `Visitable` trait, which is implemented by every AST node and traverses the whole tree in evaluation order. A cool Rust feature we make good use of is “blanket impls” which make the logic for handling AST children that are in containers clean and uniform.

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

// ... other blanket impls for Option<T> and Box<T>

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
        // closure allows us to use ? to combine results
        let res = (|| {
            self.init.visit(v)?;
            self.condition.visit(v)?;
            self.update.visit(v)?;
            self.body.visit(v)
        })();
        v.finish_for_statement(self, res)
    }
}

// ... many other Visitable implementations
```

This made a lot of our passes much easier. For example constant folding just overrides the `post_expr` method, checks if the children of an expression are constants and if so uses `mem::replace` to replace the node with a constant.

### Resolving names

One discussion we had is how to handle resolving type and variable names. The most obvious way was doing so by mutating the AST using an `Option` field that’s initially `None`. However our functional programmer instincts felt icky about this so we tried to think of a better way. Using an optional field also had the problem that we knew by the code generation phase that all variables would be resolved but the type system would still think they could be `None` so we’d need to `unwrap()` them every time we wanted to access them.

We first considered using a side table where we’d give every named reference an ID or hash it, then have a map from ID to resolved location that we created during the resolution stage. But we didn’t like how this would make debugging harder since we could no longer just print out our AST types with `Debug` to see all their information including resolutions. It also would require passing around quite a few side tables and doing lots of lookups in them by the later stages. It didn’t even solve the need for `unwrap` since the table access could theoretically not find the corresponding element.

Next we considered making all of our AST types generic with an annotation type parameter that started out as `()` but changed as the AST progressed through stages where it gained more info. The main problem with this is that each pass would need to re-build the entire AST, which would make easy visitor infrastructure much harder. Maybe if Rust had something like [an automatically derivable `Functor` implementation](https://gitlab.haskell.org/ghc/ghc/wikis/commentary/compiler/derive-functor) it wouldn’t have been bad, but barring that it would need a lot of boilerplate. There were also multiple things we needed to annotate at various stages necessitating many parameters, and a lot of AST types, which would require a lot of refactoring our AST and parser to add a multitude of parameters.

So instead we just bit the bullet and used `Option` type fields, and I think it worked out well. We implemented a nice `Reference<T, R>` generic that had a `raw` and `resolved` field. We used it for both variable and type references. It had `Hash` and `PartialEq` implementations that only looked at the resolved value because that’s what mattered for data structures in later passes. It also had a special `Debug` implementation that made the output in snapshot tests nicer:

```rust
impl<T: fmt::Debug, R: fmt::Debug> fmt::Debug for Reference<T, R> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if let Some(r) = &self.resolved {
            write!(f, "{:#?} => {:#?}", self.raw, r)
        } else {
            write!(f, "{:?}", self.raw) // only print the raw if not resolved yet
        }
    }
}
```

### Reference counting

In a number of different places, especially the class hierarchy checking and type checking phases, a lot of things needed to have the same pieces of information propagated to them. For example types bubbling up an expression or inherited methods bubbling down a tree. In a language like Java we’d just have multiple references to the same object, but in Rust for ownership reasons we couldn’t do that straightforwardly. We started out in some places by `clone`ing things which worked fine, but I realized I could just switch everything to use `Rc` to allow sharing.

I had an interesting moment where I thought “man it sucks that this code has to do all this reference count manipulation, that’s unnecessarily slow, maybe I should refactor this to use an arena or something”. Then I realized that if I had been writing in Swift I wouldn’t have given this a second thought because **everything** would be ref-counted, and even worse than the Rust version, **atomically** ref-counted. Writing code in Rust makes me feel like I have an obligation to make code as fast as possible in a way other languages don’t, just by surfacing the costs better. Sometimes I need to remind myself that actually it’s fast enough already.

## Code Generation

The course requires that we generate textual NASM x86 assembly files. Given that we only need to output to those, we decided we didn’t need an intermediate abstraction for generating assembly, and our code generation stage could just use Rust string formatting. This would make our code simpler, easier and also allow us to more easily include comments in the generated assembly.

The fact that we preserved source span information through our whole compiler and could generate comments came in handy because we could output comments containing the source expression/statement location for every single generated piece of code. This made it much easier to track down exactly which piece of code was causing a bug.

A somewhat annoying Rust thing we ran into is that we could find two easy ways of formatting to a string, both of which had an issue:

```rust
let mut s = String::new();
// Requires a Result return type or unwrap, even though it won't ever fail.
// Generates a bunch of garbage error handling LLVM needs to optimize out.
writeln!(s, "mov eax, {}", val)?;
// Allocates an intermediate String which it then immediately frees
s.push_str(format!("mov eax, {}", val));
```

My two teammates worked on the initial stages of code generation in parallel and each of them chose a different fork of this tradeoff, and by that close to the end of the course our consistency standards had relaxed, so our code generation has both.

### Usercorn

Our compiler was supposed to output Linux ELF binaries and link to a runtime that made Linux syscalls. However, our entire team used macOS. Rewriting the runtime for macOS would have been somewhat annoying since syscalls aren’t always as easy and well documented on macOS as Linux. It also would have added an annoying delay to running our tests and made the harness more complex if we had to `scp` the binaries to a Linux server or VM.

I remembered that my internet friend had written a cool tool called [usercorn](https://github.com/lunixbochs/usercorn) that used the [Unicorn CPU emulator](https://www.unicorn-engine.org/) plus some fanciness to run Linux binaries on macOS as if they were normal macOS binaries (or vice versa and a bunch of other things). It was straightforward to build a self-contained version that I could check into our repository and use in our tests to run our binaries. My teammate then got together a macOS build of `ld` that could link Linux ELF binaries and included it.

We could also use `usercorn` to output a trace of all the instructions executed and registers modified by our programs, and this came in handy quite a few times for debugging our code generation.

I ran into one problem where a test program that did a lot of allocation was 1000x slower under usercorn than on a real Linux server. Luckily I knew the author and I just sent him the offending binary and he quickly figured it was due to an inefficient implementation of the `brk` syscall which reasonable programs don’t use for every single memory allocation like the runtime the course provided did. He quickly figured out how to make it more efficient and pushed a fix later that evening which solved my problem. He’s pretty awesome, [subscribe to his Patreon!](https://www.patreon.com/lunixbochs/overview)

I then shared our pre-compiled bundle of `usercorn` and `ld` (with the bug fix for the assignment tests) with a few other teams I knew who used macOS so they could have an easier time testing as well.

## Conclusion

Overall I’m proud of how our compiler turned out. It was a fun project and my teammates were excellent. I also think Rust ended up being a good choice of implementation language, especially the powerful `enum`s and pattern matching. The main downsides of Rust were the long compile times (although apparently comparable to a group that did their compiler in C++), and the fact that sometimes we had to do somewhat more work to satisfy the borrow checker.

One of the most interesting learning experiences from the project was when afterwards I talked to some other teams and got to compare what it was like to do the same project in different languages and with different design decisions. I’ll talk about that in an upcoming post!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

## 注解
### weeder
* [weeder](https://metacpan.org/pod/release/LIBVENUS/HPPPM-Demand-Management-0.04/lib/FieldParser.pm#weeder)：消除/去除/过滤输入字符中无用、无意义字符的逻辑单元

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
