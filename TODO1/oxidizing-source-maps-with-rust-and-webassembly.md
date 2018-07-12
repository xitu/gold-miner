> * 原文地址：[Oxidizing Source Maps with Rust and WebAssembly](https://hacks.mozilla.org/2018/01/oxidizing-source-maps-with-rust-and-webassembly/)
> * 原文作者：[Nick Fitzgerald](http://fitzgeraldnick.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/oxidizing-source-maps-with-rust-and-webassembly.md](https://github.com/xitu/gold-miner/blob/master/TODO1/oxidizing-source-maps-with-rust-and-webassembly.md)
> * 译者：[D-kylin](https://github.com/D-kylin)
> * 校对者：

# 论 Rust 和 WebAssembly 对源码地址索引的极限优化

[Tom Tromey](http://tromey.com) 和我尝试使用 Rust 语言进行编码，然后用 WebAssembly 进行编译打包后替换 `source-map`（源码地址索引，以下行文为了理解方便均不进行翻译）的 JavaScript 工具库中性能敏感的部分。在实际场景中以相同的基准进行对比操作， [WebAssembly](https://webassembly.org/) 的性能要比已有的 source-map 库 **快上 5.89 倍** 。 另外，多次测试结果也更为一致：相对一致的情况下偏差值很小。

我们以提高性能的名义将那些令人费解又难以阅读的 JavaScript 代码替换成更加语义化的 Rust 代码，这确实行之有效。

现在，我们把 Rust 结合 WebAssembly 使用的经验分享给大家，也鼓励程序员按照自己的需求对性能敏感的 JavaScript 进行重构。

## 背景

### source-map 的技术规范

[source map 文件](https://docs.google.com/document/d/1U1RGAehQwRypUTovF1KRlpiOFze0b-_2gc6fAH0KY0k) 提供了 JavaScript 源码被编译器<sup><a href="#note0">[0]</a></sup>、压缩工具、包管理工具转译成的文件之间的地址索引供编程人员使用。JavaScript 开发者工具使用 source-map 后可以实现字符级别的回溯，调试工具中的按步调试也是依赖它来实现的。Source-map 对报错信息的编码方式与 [DWARF’s `.debug_line`](http://dwarfstd.org/) 的部分标准很相似。

source-map 对象是 JSON 对象的其中一个分支。 其中 `“映射集”` 用字符串表示，是 source-map 的重要组成部分，包含了最终代码和定位对象的双向索引。

我们用 [extended Backus-Naur form (EBNF)](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form) 标准描述 `“映射集”` 的字符串语法。

Mappings 是 JavaScript 代码块的分组行号，每一个映射集只要以分号结尾了就代表一个独立的映射集，它就自增 1 。同一行 JavaScript 代码如果生成多个映射集，就用逗号分隔开：

```
<mappings> = [ <generated-line> ] ';' <mappings>
            | ''
            ;

<generated-line> = <mapping>
                    | <mapping> ',' <generated-line>
                    ;
```

每一个独立的映射集都能定位到当初生成它的那段 JavaScript 代码，还能有一个关联名字的可选项能定位到那段代码中的源码字符串：

```
<mapping> = <generated-column> [ <source> <original-line> <original-column> [ <name> ] ] ;
```

每个映射集组件都通过一种叫做 `大数值的位数可变表示法(Variable Length Quantity，缩写为 VLQ)` 编码成二进制数字。 文件名和相关联的名字被编码后储存在 source-map 的 JSON 对象中。每一个值标注了源码最后出现的位置，现在，给你一个 `<source>` 值那么它跟前一个 `<source>` 值就给我们提供了一些信息。如果这些值之间趋向于越来越小，就说明它们在被编码的时候更加紧密：

```
<generated-column> = <vlq> ;
<source> = <vlq> ;
<original-line> = <vlq> ;
<original-column> = <vlq> ;
<name> = <vlq> ;
```

利用 VLQ 编码后的字符都能从 ASCII 字符集中找到，比如大小写的字母，又或者是十进制数字跟一些符号。每个字符都表示了一个 6 位大小的值。 VLQ 编码后的二进制数前五位用来表示数值，最后一位只用来做标记正负。

与其向你解释 EBNF 标准，不如来看一段简单的 VLQ 转换代码实现：

```
constant SHIFT = 5
constant CONTINUATION_BIT = 1 << SHIFT
constant MASK = (1 << SHIFT) - 1

decode_vlq(input):
    let accumulation = 0
    let shift = 0

    let next_digit_part_of_this_number = true;
    while next_digit_part_of_this_number:
        let [character, ...rest] = input
        let digit = decode_base_64(character)
        accumulation += (digit & MASK) << shift
        shift += SHIFT;
        next_digit_part_of_this_number = (digit & CONTINUATION_BIT) != 0
        input = rest

    let is_negative = accumulation & 1
    let value = accumulation >> 1
    if is_negative:
        return (-value, input)
    else:
        return (value, input)
```

###  `source-map` JavaScript 工具库

[`source-map`](https://github.com/mozilla/source-map) 是由 [火狐开发者工具团队](https://twitter.com/firefoxdevtools) 维护，发布在 [npm](https://www.npmjs.com/) 上。它是 JavaScript 社区最流行的依赖包之一，下载量达到 [每周 1000 万次](https://www.npmjs.com/package/source-map)。

就像许多软件项目一样， `source-map` 工具库最开始也没有很好的去实现它，以至于后面只能通过不断的修复来改善性能。截止到本文完成之前，其实已经有了不错的性能表现了。

当我们使用 source-map ，很大一部分的时间都是消耗在解析 `“映射集”` 字符串和构建数组对：一旦 JavaScript 的定位改变了，另一个文件的代码标示的定位也要改变。选用合适的二进制查找方式对数组进行查找。解析和排序操作只有在特定的时机才会被调用。例如，在调试工具中查看源码时，不需要对任何的映射集进行解析和排序。一次性的解析和排序、查找并不会成为性能瓶颈。

VLQ 编码函数通过输入字符串，解析字符串并返回一对由解析结果和其余输入组成的值。通常把函数的返回值写成有两个属性组成的 `对象` ，这样更具有可读性，也方便日后进行格式转换。

```
function decodeVlqBefore(input) {
    // ...
    return { result, rest };
}
```

我们发现返回这样的对象成本很高。针对 JavaScript 的 `即时编译（JIT）` 优化，很难用第三方编译的方式来优化这部分花销。因为 VLQ 的编码事件总是频繁产生，所以这部分的内存分配工作给垃圾收集机制带来很大的压力，导致垃圾收集工作就像是走走停停一样。

为了禁用内存分配，我们 [修改程序](https://github.com/mozilla/source-map/pull/135) 的第二个参数：将返回 `对象` 进行变体并作为输出参数，这样就把结果当成一个外部 `对象` 的属性。我们可以肯定这个外部对象与 VLQ 函数返回的对象是一致的。虽然损失了一点可读性，但是执行效率更高：

```
function decodeVlqAfter(input, out) {
    // ...
    out.result = result;
    out.rest = rest;
}
```

当查找一个位置长度的字符串或者 base 64 字符， VLQ 编码函数会 `抛出` 一个 `报错`。我们发现如果 [如果转换 base 64 数字出现错误，编码函数返回 `-1`](https://github.com/mozilla/source-map/pull/185) 而不是 `抛出` 一个 `报错`，那么 JavaScript 的即时编译效率更高。虽然损失了一点可读性，但是执行效率又高了那么一丢丢。

剖析 SpiderMonkey 引擎中 [JITCoach](http://users.eecs.northwestern.edu/~stamourv/papers/optimization-coaching-js.pdf) 原型， 我们发现 SpiderMonkey 引擎即时编译机制是使用多态短路径实时缓存 `对象` 的 getter 和 setter。它的即时编译没有如我们期待的那样直接通过快速访问得到对象的属性，因为以同样的 [“形状” (或者称之为 “隐藏类”)](http://bibliography.selflanguage.org/_static/implementation.pdf) 是访问不到它返回出来的对象。有一些属性可能都不是你存入对象时的键名，甚至键名是完全省略掉的，比如当它在映射集中定位不到名字时。创建一个 Mapping 类生成器，初始化每一个属性，我们配合即时编译，为 Mapping 类添加通用属性。完整结果可以在这里看到 [另一种性能改进](https://github.com/mozilla/source-map/pull/188):

```
function Mapping() {
    this.generatedLine = 0;
    this.generatedColumn = 0;
    this.lastGeneratedColumn = null;
    this.source = null;
    this.originalLine = null;
    this.originalColumn = null;
    this.name = null;
}
```

对两个映射集数组进行排序时，我们使用自定义对比函数。当 `source-map` 工具库源码被第一次写入， SpiderMonkey 的 `Array.prototype.sort` 是用 C++ 实现来提升性能<sup><a href="#note1">[1]</a></sup>。尽管如此，当使用外部提供的对比函数并对一个巨大的数组进行 `排序` 的时候，排序代码也需要调用很多次对比函数。从 C++ 中调用 JavaScript 相对来说也是很昂贵的花销，所以调用自定义对比函数会使得排序性能急速下降。  

基于上述条件，我们 [实现了另一个版本 Javascript 快排](https://github.com/mozilla/source-map/pull/186)。它只能通过 C++ 调用 Javascript 时才能使用，它也允许 JavaScript 即时编译时作为排序函数的对比函数传入，用来获取更好的性能。这个改进给我们带来大幅度的性能提升，同时只需要损失很小的代码可读性。

### WebAssembly

[WebAssembly](http://webassembly.org/) 是一种新的技术，它以二进制形式运行在 Web 浏览器底层，为浏览器隔离危险代码和减少代码量所设计的。现在已经作为 Web 的标准，而且大多数的浏览器厂商已经支持这个功能。

WebAssembly 开辟一块新的栈区供机器运行，有现代处理器架构的支持能更好的处理映射，它可以直接操作一大块连续的储存 buffer 字节。WebAssembly 不支持自动化的垃圾回收，不过 [在不久的将来](https://github.com/WebAssembly/design/issues/1079) 它也会继承 JavaScript 对象的垃圾回收机制。控制流是具有结构化的，比起在代码间随意的打标记或者跳跃，它被设计用来提供一种更可靠、运行一致的执行流程。处理一些架构上的边缘问题，比如：超出表示范围的数值怎么截取、溢出问题、规范 `NaN` 。

WebAssembly 的目标是获得或者逼近原始指令的运行速度。目前在大多数的基准测试中跟原始指令相比 [只相差 1.5x](https://github.com/WebAssembly/spec/blob/master/papers/pldi2017.pdf) 了。

因为缺乏垃圾收集器，要编译成 WebAssembly 语言仅限那些没有运行时和垃圾采集器的编程语言，除非把控制器和运行时也编译成 WebAssembly 。实际中这些一般很难做到。现在，语言开发者事实上是把 C ，C++ 和 Rust 编译成 WebAssembly。

### Rust

[Rust](https://www.rust-lang.org) 是一种更加安全和高效的系统编程语言。它的内存管理更加安全，不依赖于垃圾回收机制，而是允许你通过静态追踪函数 _ownership_ 和 _borrowing_ 这两个方法来申请和释放内存。

使用 Rust 来编译成 WebAssembly 是一种不错的选择。由于语言设计者一开始就没有为 Rust 设计垃圾自动回收机制，也就不用为了编译成 WebAssembly 做额外的工作。Web 开发者还发现一些在 C 和 C++ 没有的优点：

*   Rust 库更加容易构建、容易共享、打包简单和容易提取公共部分，而且自成文档。Rust 有诸如 `rustup`， `cargo` 和 [crates.io](https://crates.io/) 的完整生态系统。这是 C 和 C++ 所不能比拟的。
*   内存安全方面。在 `迭代算法` 中不断产生内存碎片。Rust 则可以在编译时就避免大部分类似的性能陷阱。

## Rust 对映射集的解析和查找

当我们决定把 source-map 中使用频率最高的解析和查找功能进行重构，就需要考虑到 JavaScript 和 WebAssembly 的运行边界问题。如果出现了 JavaScript 即时编译和 WebAssembly 相互穿插运行可能会影响彼此原来的执行效率。关于这个问题可以回忆一下前面我们讨论过的在 C++ 代码中调用 JavaScript 代码的例子<sup><a href="#note2">[2]</a></sup>。所以确定好边界来最小化两个不同语言相互穿插执行的次数显得尤为重要。

在 VLQ 编码函数中供选择的 JavaScript 和 WebAssembly 的运行边界其实很少。VLQ 编码函数对 `“映射集”` 字符串的每一次 Mapping 时需要被引用 1 ~ 4 次，在整个解析过程不得不在 JavaScript 和 WebAssembly 的边界来回切換很多次。

因此，我们决定只用 Rust/WebAssembly 解析整个 `“映射集”` 字符串，然后把解析结果保留在内存中，WebAssembly 堆就可以直接查找到解析后的数据。这意味着我们不用把数据从 WebAssembly 堆中复制出来，也就不需要频繁的在 JavaScript 和 WebAssembly 边界来回切换了。除此之外，每次的查找只需要切换一次边界，每执行一次 Mapping 只不过是在解析结果中多查找一次。每次查找只产生一个结果，而这样的操作次数屈指可数。

通过这两个单元化测试，我们确信利用 Rust 语言来实现是正确的。 一个是 `source-map` 工具库已有的单元测试，另一个是 [`快速查找` 性能的单元测试](https://github.com/fitzgen/source-map-mappings/blob/97ba6fb4163f6edfa45f6a3c9e86914ec5ef02a2/tests/quickcheck.rs) 。这个测试的是通过解析随机输入 `“映射集”` 字符串，判断执行结果的多个性能指标。

[我们基于 Rust 实现 crates.io，利用 crates.io 的 api 作为 Mapping 函数对 `“映射集”` 进行解析和查找。](https://crates.io/crates/source-map-mappings)

### Base 64 大数值的位数可变表示法

对 source-map 进行 Mapping 的第一步是 VLQ 编码。这里是我们实现的 [`vlq` 工具库](https://github.com/tromey/vlq)，基于 Rust 实现，发布到 crates.io 上。

`decode64` 函数解码结果是一个 base 64 数值。它使用匹配模式和可读性良好的 `Result` —— 处理错误。

`Result<T, E>` 函数运行得到一个类型为 `T`，值为 `V` 就返回 `Ok(v)`；运行得到一个类型为 `E`，值为 `error` 就返回 `Err(error)` 来提供报错细节。`decode64` 函数运行得到一个类型为 `Result<u8, Error>` 的返回值，如果成功，值为 `u8`，如果失败，值为 `vlq::Error`:

    fn decode64(input: u8) -> Result<u8, Error> {
        match input {
            b'A'...b'Z' => Ok(input - b'A'),
            b'a'...b'z' => Ok(input - b'a' + 26),
            b'0'...b'9' => Ok(input - b'0' + 52),
            b'+' => Ok(62),
            b'/' => Ok(63),
            _ => Err(Error::InvalidBase64(input)),
        }
    }
    

通过 `decode64` 函数，我们可以对 VLQ 值进行解码。 `decode` 函数将可变引用作为输入字节的迭代器，消耗需要解码的 VLQ，最后返回 `Result` 函数作为解码结果。 

    pub fn decode<B>(input: &mut B) -> Result<i64>
    where
        B: Iterator<Item = u8>,
    {
        let mut accum: u64 = 0;
        let mut shift = 0;
    
        let mut keep_going = true;
        while keep_going {
            let byte = input.next().ok_or(Error::UnexpectedEof)?;
            let digit = decode64(byte)?;
            keep_going = (digit & CONTINUED) != 0;
    
            let digit_value = ((digit & MASK) as u64)
                .checked_shl(shift as u32)
                .ok_or(Error::Overflow)?;
    
            accum = accum.checked_add(digit_value).ok_or(Error::Overflow)?;
            shift += SHIFT;
        }
    
        let abs_value = accum / 2;
        if abs_value > (i64::MAX as u64) {
            return Err(Error::Overflow);
        }
    
        // The low bit holds the sign.
        if (accum & 1) != 0 {
            Ok(-(abs_value as i64))
        } else {
            Ok(abs_value as i64)
        }
    }
    
    

不像被替换掉的 JavaScript，这段代码没有为了性能而降低错误处理代码的可读性，可读性更好的错误处理执行逻辑更容易理解，也没有涉及到堆的值包装和栈的压栈出栈。

### `"mappings"` 字符串

我们开始定义一些辅助函数。`is_mapping_separator` 函数判断给定的数据能否被 `Mapping` 如果可以就返回 `true`，否则返回 `false`。这是一个语法与 JavaScript 很相似的函数：

    #[inline]
    fn is_mapping_separator(byte: u8) -> bool {
        byte == b';' || byte == b','
    }
    

然后我们定义一个辅助函数用来读取 VLQ 数据并把它添加到前一个值中。这个函数没法用 JavaScript 类比了，每读取一段 VLQ 数据就要运行这个函数一遍。 Rust 可以控制参数在内存中以怎样的形式存储，JavaScript 则没有这个功能。虽然我们可以用一组数字属性引用 `对象` 或者把数字变量通过闭包保存下来，但是依然模拟不了 Rust 在引用一组数组属性的时候做到零花销。JavaScript 只要运行时就一定会有相关的时间花销。

    #[inline]
    fn read_relative_vlq<B>(
        previous: &mut u32,
        input: &mut B,
    ) -> Result<(), Error>
    where
        B: Iterator<Item = u8>,
    {
        let decoded = vlq::decode(input)?;
        let (new, overflowed) = (*previous as i64).overflowing_add(decoded);
        if overflowed || new > (u32::MAX as i64) {
            return Err(Error::UnexpectedlyBigNumber);
        }
    
        if new < 0 {
            return Err(Error::UnexpectedNegativeNumber);
        }
    
        *previous = new as u32;
        Ok(())
    }
    

总而言之，基于 Rust 实现的 `“映射集”` 解析与被替换调的 JavaScript 实现语法逻辑非常相似。尽管如此，使用 Rust 我们可以控制底层哪些功能要打包到一起，哪些用辅助函数来解决。JavaScript 语言对底层的控制权就小了很多，举个简单例子，解析映射 `对象` 只能用 JavaScript 原生方法。Rust 语言的优势源于把内存的分配和垃圾回收交给编程人员自己去实现：

    pub fn parse_mappings(input: &[u8]) -> Result<Mappings, Error> {
        let mut generated_line = 0;
        let mut generated_column = 0;
        let mut original_line = 0;
        let mut original_column = 0;
        let mut source = 0;
        let mut name = 0;
    
        let mut mappings = Mappings::default();
        let mut by_generated = vec![];
    
        let mut input = input.iter().cloned().peekable();
    
        while let Some(byte) = input.peek().cloned() {
            match byte {
                b';' => {
                    generated_line += 1;
                    generated_column = 0;
                    input.next().unwrap();
                }
                b',' => {
                    input.next().unwrap();
                }
                _ => {
                    let mut mapping = Mapping::default();
                    mapping.generated_line = generated_line;
    
                    read_relative_vlq(&mut generated_column, &mut input)?;
                    mapping.generated_column = generated_column as u32;
    
                    let next_is_sep = input.peek()
                        .cloned()
                        .map_or(true, is_mapping_separator);
                    mapping.original = if next_is_sep {
                        None
                    } else {
                        read_relative_vlq(&mut source, &mut input)?;
                        read_relative_vlq(&mut original_line, &mut input)?;
                        read_relative_vlq(&mut original_column, &mut input)?;
    
                        let next_is_sep = input.peek()
                            .cloned()
                            .map_or(true, is_mapping_separator);
                        let name = if next_is_sep {
                            None
                        } else {
                            read_relative_vlq(&mut name, &mut input)?;
                            Some(name)
                        };
    
                        Some(OriginalLocation {
                            source,
                            original_line,
                            original_column,
                            name,
                        })
                    };
    
                    by_generated.push(mapping);
                }
            }
        }
    
        quick_sort::<comparators::ByGeneratedLocation, _>(&mut by_generated);
        mappings.by_generated = by_generated;
        Ok(mappings)
    }
    

最后，我们仍然在 Rust 代码中使用我们自己定义的快排，这可能是所有 Rust 代码中可读性最差了。我们还发现，在原生代码环境中，标准库的内置排序函数执行效率更高，但是一旦把运行环境换成 WebAssembly，我们定义的排序函数比标准库的内置排序函数执行效率更高。（对于这样的差异很意外，不过我们也没有再深究了。）

JavaScript 接口
---------------------------

WebAssembly 的对外函数接口（foreign function interface，简称 FFI）受限于标量值，所以一些以 Rust 语言编写，通过 WebAssembly 转成 JavaScript 代码后的函数参数只能是标量数值类型，返回值也是标量数值类型。因此，JavaScript 要求 Rust 为 `“映射集”` 字符串分配一块缓冲区并返回该 buffer 字节的地址指针。然后，JavaScript 必须复制出 `“映射集”` 字符串的 buffer 字节，这时候因为 FFI 的限制什么也做不了，只能把整段连续的 WebAssembly 内存直接写入。之后 JavaScript 调用 `parse_mappings` 函数进行 buffer 字节的初始化工作，初始化完毕后返回解析结果的指针。完成上述这些前置工作后，JavaScript 就可以使用 WebAssembly 的 API ，给定一些数值查找结果，或者给定一个指针得到解析后的映射集。所有查询结果完毕以后，JavaScript 会告诉 WebAssembly 释放存储映射集结果的内存空间。

### 从 Rust 暴露 WebAssembly 的应用编程接口

所有的暴露出去的 WebAssembly APIs 都被封装在一个 “小胶箱” 里。这样的分离很有用，它允许我们用测试环境来执行 `source-map-mappings`。如果你想编译成纯的 WebAssembly 代码也可以，只需要把编译环境修改成 WebAssembly 。

另外，受限于 FFI 的传值要求，那么输出的函数必须满足一下两点：

*   它不能有 `#[无名]` 属性，要方便 JavaScript 能调用它 。
*   它标记 `外部 "C"` 以便提取到 `.wasm` 公共文件中。

不同于核心库，这些代码暴露功能给 WebAssembly 转 JavaScript，有必要提醒你，频繁使用非常的 `不安全`。 只要调用 `外部` 函数和使用指针从 FFI 边界接收指针，就是 `不安全`，因为 Rust 编译器没法校验另一端是否安全。我们很少关心到这个安全性问题 —— 最坏的情况下我们可以做一个 `陷阱`（把 JavaScript 端的 `报错` 全部抓住），或者直接返回一个报错响应。在同一段地址中，可以向地址写入内容要比只是将地址储存的内容以二进制字节运行要危险的多，如果可写入的话，攻击者就可以欺骗程序跳转到特定的内存地址，然后插入一段他自己的 shell 脚本代码。

我们输出的一个最简单是函数功能是把工具库产生的一个报错捕获到。它提供了 `libc` 中 `errno` 类似的功能，它会将 API 运行出错时报告 JavaScript 到底是什么样的错误。我们总是把最近的报错保留在全局对象上，这个函数可以检索错误值：

```
static mut LAST_ERROR: Option<Error> = None;

#[no_mangle]
pub extern "C" fn get_last_error() -> u32 {
    unsafe {
        match LAST_ERROR {
            None => 0,
            Some(e) => e as u32,
        }
    }
}
```

JavaScript 和 Rust 的第一次交互发生在为 buffer 字节分配内存空间来存储 `“映射集”` 字符串。我们希望能有一块独立的，由 `u8` 组成的连续块，它建议使用 `Vec<u8>`，但我们想要暴露一个简单的指针给 JavaScript。一个简单的指针可以跨越 FFI 的边界，但是很容易在 JavaScript 端引起报错。我们可以用 `Box<Vec<u8>>` 添加一个连接层或者保存在外部数据中，另一端有需要这份数据的时候再载体进行格式化。我们决定采用后一个方法。

这个载体由以下三者组成：

1.  一个指针指向堆内存元素，
2.  分配内存的容量有多大，
3.  元素的初始化长度。

当我们暴露一个堆内存元素的指针给 JavaScript，我们需要一种方式来保存长度和容量，将来通过 `Vec` 重建它。我们在堆元素的开头添加两个额外的词来存储长度和容量，然后我们把这个添加了两个标注的指针传给 JavaScript：

```
#[no_mangle]
pub extern "C" fn allocate_mappings(size: usize) -> *mut u8 {
    // Make sure that we don't lose any bytes from size in the remainder.
    let size_in_units_of_usize = (size + mem::size_of::<usize>() - 1)
        / mem::size_of::<usize>();

    // Make room for two additional `usize`s: we'll stuff capacity and
    // length in there.
    let mut vec: Vec<usize> = Vec::with_capacity(size_in_units_of_usize + 2);

    // And do the stuffing.
    let capacity = vec.capacity();
    vec.push(capacity);
    vec.push(size);

    // Leak the vec's elements and get a pointer to them.
    let ptr = vec.as_mut_ptr();
    debug_assert!(!ptr.is_null());
    mem::forget(vec);

    // Advance the pointer past our stuffed data and return it to JS,
    // so that JS can write the mappings string into it.
    let ptr = ptr.wrapping_offset(2) as *mut u8;
    assert_pointer_is_word_aligned(ptr);
    ptr
}
```

把 buffer 字节初始化为 `“字符集”` 字符串之后，JavaScript 把 buffer 字节的控制器交给 `parse_mappings`，将字符串解析为可查找结构。解析成功会返回 `Mappings` 后的结构，失败就返回 `NULL`。

`parse_mappings` 要做的第一步就是恢复 `Vec` 的长度和容量。第二部，`“映射集”` 字符串数据被截取，在被截取的整个生命周期内都无法从当前作用域检测到，只有当他们被重新分配到内存中，并被我们的工具库解析为 `“字符集”` 字符串之后才能获取到。不论解析结果有没有成功，我们都重新申请 buffer 字节来储存 `“字符集”` 字符串，然后返回一个指针指向解析成功的结果，或者返回一个指针指向 `NULL`。

```
/// 留意在匹配的生命周期内作用域中的引用，
/// 某些 `不安全` 的操作，比如解除指针关联引用。
/// 生命周期内返回一些不保留的引用，
/// 使用这个函数保证我们不会一不小心的使用了
/// 一个非法的引用值。
#[inline]
fn constrain<'a, T>(_scope: &'a (), reference: &'a T) -> &'a T
where
    T: ?Sized
{
    reference
}

#[no_mangle]
pub extern "C" fn parse_mappings(mappings: *mut u8) -> *mut Mappings {
    assert_pointer_is_word_aligned(mappings);
    let mappings = mappings as *mut usize;

    // 在指针指向映射集字符串前将数据拿出
    // string.
    let capacity_ptr = mappings.wrapping_offset(-2);
    debug_assert!(!capacity_ptr.is_null());
    let capacity = unsafe { *capacity_ptr };

    let size_ptr = mappings.wrapping_offset(-1);
    debug_assert!(!size_ptr.is_null());
    let size = unsafe { *size_ptr };

    // 从指针的截取片段构造一个指针并解析成映射集。
    let result = unsafe {
        let input = slice::from_raw_parts(mappings as *const u8, size);
        let this_scope = ();
        let input = constrain(&this_scope, input);
        source_map_mappings::parse_mappings(input)
    };

    // 重新分配映射集字符串的内存并添加两个前置的数据。
    let size_in_usizes = (size + mem::size_of::<usize>() - 1) / mem::size_of::<usize>();
    unsafe {
        Vec::<usize>::from_raw_parts(capacity_ptr, size_in_usizes + 2, capacity);
    }

    // 返回结果，保存一些报错给另一端语言提供帮助
    // 如果 JavaScript 需要的话。
    match result {
        Ok(mappings) => Box::into_raw(Box::new(mappings)),
        Err(e) => {
            unsafe {
                LAST_ERROR = Some(e);
            }
            ptr::null_mut()
        }
    }
}
```

当我们进行查找时，我们需要找一个方法来转换结果，才能传给 FFI 使用。查找结果可能是一个 `映射` 或者集合组成的 `映射`，`映射` 不能直接给 FFI 使用，除非我们进行封装。 我们肯定不希望对 `映射` 进行封装，因为之后我们还可能需要从原来的结构中获取内容，那时我们还要费时费力的分配内存和间接取值。我们的方法是调用一个引导进来的函数处理每一个 `映射`。

`mappings_callback` 就是一个 `外部` 函数，它不是本地定义的函数，而是在 WebAssembly 模块实例化的时候由 JavaScript 引导进来。`mappings_callback` 将 `映射` 分解成不同的部分：每个文件都是被展平后的 `映射`，被转换后可以作为参数传递给 FFI 使用。 `可选项<T>` 我们加入一个 `bool` 参数控制不同的转换结果，由 `可选项<T>` 是 `Some` 还是 `None` 决定参数 `T` 是合法值还是无用值：

```
extern "C" {
    fn mapping_callback(
        // These two parameters are always valid.
        generated_line: u32,
        generated_column: u32,

        // The `last_generated_column` parameter is only valid if
        // `has_last_generated_column` is `true`.
        has_last_generated_column: bool,
        last_generated_column: u32,

        // The `source`, `original_line`, and `original_column`
        // parameters are only valid if `has_original` is `true`.
        has_original: bool,
        source: u32,
        original_line: u32,
        original_column: u32,

        // The `name` parameter is only valid if `has_name` is `true`.
        has_name: bool,
        name: u32,
    );
}

#[inline]
unsafe fn invoke_mapping_callback(mapping: &Mapping) {
    let generated_line = mapping.generated_line;
    let generated_column = mapping.generated_column;

    let (
        has_last_generated_column,
        last_generated_column,
    ) = if let Some(last_generated_column) = mapping.last_generated_column {
        (true, last_generated_column)
    } else {
        (false, 0)
    };

    let (
        has_original,
        source,
        original_line,
        original_column,
        has_name,
        name,
    ) = if let Some(original) = mapping.original.as_ref() {
        let (
            has_name,
            name,
        ) = if let Some(name) = original.name {
            (true, name)
        } else {
            (false, 0)
        };

        (
            true,
            original.source,
            original.original_line,
            original.original_column,
            has_name,
            name,
        )
    } else {
        (
            false,
            0,
            0,
            0,
            false,
            0,
        )
    };

    mapping_callback(
        generated_line,
        generated_column,
        has_last_generated_column,
        last_generated_column,
        has_original,
        source,
        original_line,
        original_column,
        has_name,
        name,
    );
}
```

所有输出的查找函数都有相似的结构。它们一开始都是转换 `*mut Mappings` 成一个 `&mut Mappings` 引用。`&mut Mappings` 生命周期仅限于当前范围，以强制它只用于这个函数的调用，在它被重新分配内存后不能再使用。其次，每一个查找方法都依赖于 `Mapping` 方法。每个被输出的函数都调用 `mapping_callback` 的结果都是 `映射`。

输出一个典型的查找函数 `all_generated_locations_for`，它包裹了`Mappings::all_generated_locations_for` 方法，并找到所有源标注的映射依赖：

```
#[inline]
unsafe fn mappings_mut<'a>(
    _scope: &'a (),
    mappings: *mut Mappings,
) -> &'a mut Mappings {
    mappings.as_mut().unwrap()
}

#[no_mangle]
pub extern "C" fn all_generated_locations_for(
    mappings: *mut Mappings,
    source: u32,
    original_line: u32,
    has_original_column: bool,
    original_column: u32,
) {
    let this_scope = ();
    let mappings = unsafe { mappings_mut(&this_scope, mappings) };

    let original_column = if has_original_column {
        Some(original_column)
    } else {
        None
    };

    let results = mappings.all_generated_locations_for(
        source,
        original_line,
        original_column,
    );
    for m in results {
        unsafe {
            invoke_mapping_callback(m);
        }
    }
}
```

最后，当 JavaScript 完成查找 `映射集` 时，必须输出 `free_mappings` 函数来为结果重新分配内存：

```
#[no_mangle]
pub extern "C" fn free_mappings(mappings: *mut Mappings) {
    unsafe {
        Box::from_raw(mappings);
    }
}
```

### 将 Rust 编译成 `.wasm` 文件

为目标添加 `wasm32-unknown-unknown` 给 Rust 编译成 WebAssembly 带来可能，而且 `rustup` 使得安装 Rust 的编译工具指向 `wasm32-unknown-unknown` 更加便捷：

```
$ rustup update
$ rustup target add wasm32-unknown-unknown
```

现在我们就有了一个 `wasm32-unknown-unknown` 编译器, 通过修改 `--target` 标记就可以实现不同的语言到 WebAssembly 之间的编译：

```
$ cargo build --release --target wasm32-unknown-unknown
```

`.wasm` 后缀的编译文件保存在 `target/wasm32-unknown-unknown/release/source_map_mappings_wasm_api.wasm`.

尽管我们已经有一个可以运行的 `.wasm` 文件，工作还没完成：这个 `.wasm` 文件体积仍然太大了。生产环境的 `.wasm` 文件体积越小越好，我们通过以下工具一步步压缩它：

*   [`wasm-gc`](https://github.com/alexcrichton/wasm-gc)，`--gc-sections` 标记了要移除没有使用过的对象文件，对于 `.wasm` 文件，ELF，Mach-O 除外。它会找到哪些输出函数没有被用过，然后从 `.wasm` 文件中移除。

*   [`wasm-snip`](https://github.com/fitzgen/wasm-snip)，用 `非访问性` 的指令来替代 WebAssembly 的函数体，这对于那些运行时从头到尾没有没调用过，但是 `wasm-gc` 静态分析没法移除掉，通过手动配置编译结果。丢弃一个函数引用指针使得其他函数没法访问到失去引用指针的函数，所以很有必要在此操作之后再一次使用 `wasm-gc`。

*   [`wasm-opt`](https://github.com/WebAssembly/binaryen)，用 `binaryen` 优化 `.wasm` 文件，压缩文件体积并提高运行时的性能。实际上，随着后端底层虚拟机越来越成熟，这步操作变得可有可无。

我们的 [生产流程配置](https://github.com/fitzgen/source-map-mappings/blob/e76dac2cd16fda8bcd49b35c234fccc42b754bae/source-map-mappings-wasm-api/build.py) 是 `wasm-gc` → `wasm-snip` → `wasm-gc` → `wasm-opt`.

### 在 JavaScript 使用 WebAssembly APIs

在 JavaScript 使用 WebAssembly 的首要问题就是，如何加载 `.wasm` 文件。 `source-map` 工具库的运行环境主要有三个：

1.  Node.js
2.  网页
3.  火狐开发者工具里

不同的环境使用不同的方式将 `.wasm` 文件加载为 `ArrayBuffer` 字节，才能在 JavaScript 运行时进行编译使用。在网页和火狐浏览器里可以用标准化的 `fetch` API 建立 HTTP 请求来加载 `.wasm` 文件。它是一个工具库，负责将 URL 指向需要从网络加载的 `.wasm` 文件，加载完成后才能进行任何的 source-map 解析。当使用 Node.js 把工具库换成 `fs.readFile` API 从硬盘中读取 `.wasm` 文件。在这个脚本中，在进行任何 source-map 解析之前不需要执行初始化。我们只负责提供一个统一的接口，基于什么环境、用什么的工具库才能正确的加载 `.wasm` 文件，各位自己去撸代码吧。

当编译和实例化 WebAssembly 模块时，我们必须提供 `mapping_callback`。 这个回调函数不能在实例化 WebAssembly 模块的生命周期外进行回调，但是可以根据我们将要执行的查找工作和不同的映射结果对返回结果进行一些调整。所以实际上 `mapping_callback` 只提供对分离后的映射成员进行对象结构化，然后把结果用一个闭包函数包裹起来后返回给你，你随意进行查找操作。

```
let currentCallback = null;

// ...

WebAssembly.instantiate(buffer, {
    env: {
    mapping_callback: function (
        generatedLine,
        generatedColumn,

        hasLastGeneratedColumn,
        lastGeneratedColumn,

        hasOriginal,
        source,
        originalLine,
        originalColumn,

        hasName,
        name
    ) {
        const mapping = new Mapping;
        mapping.generatedLine = generatedLine;
        mapping.generatedColumn = generatedColumn;

        if (hasLastGeneratedColumn) {
        mapping.lastGeneratedColumn = lastGeneratedColumn;
        }

        if (hasOriginal) {
        mapping.source = source;
        mapping.originalLine = originalLine;
        mapping.originalColumn = originalColumn;

        if (hasName) {
            mapping.name = name;
        }
        }

        currentCallback(mapping);
    }
    }
})
```

为了 `currentCallback` 工程化和非工程化设置，我们定义了 `withMappingCallback` 辅助函数来完成这件事：它就像设置过的 `currentCallback`，如果不想设置的话直接调用 `currentCallback` 就可以。一旦 `withMappingCallback` 完成，我们就把  `currentCallback` 重置成 `null`。[RAII](https://en.wikipedia.org/wiki/Resource_acquisition_is_initialization) 等价于以下代码：

```
function withMappingCallback(mappingCallback, f) {
    currentCallback = mappingCallback;
    try {
    f();
    } finally {
    currentCallback = null;
    }
}
```

回想以下 JavaScript 最初的设想，当解析一段 source-map 时，需要告诉 WebAssembly 分配一段内存来存储 `“映射集”` 字符串，然后将字符串复制到一段 buffer 字节内存里：

```
const size = mappingsString.length;
const mappingsBufPtr = this._wasm.exports.allocate_mappings(size);
const mappingsBuf = new Uint8Array(
    this._wasm.exports.memory.buffer,
    mappingsBufPtr,
    size
);
for (let i = 0; i < size; i++) {
    mappingsBuf[i] = mappingsString.charCodeAt(i);
}
```

JavaScript 对 buffer 字节进行初始化的时候，它会调用从 WebAssembly 导出的 `parse_mappings` 函数，如果转换过程失败就 `抛出` 一些 `报错`。

```
const mappingsPtr = this._wasm.exports.parse_mappings(mappingsBufPtr);
if (!mappingsPtr) {
    const error = this._wasm.exports.get_last_error();
    let msg = `Error parsing mappings (code ${error}): `;
    // XXX: 用 `fitzgen/source-map-mappings` 同步接收报错信息。
    switch (error) {
    case 1:
        msg += "the mappings contained a negative line, column, source index or name index";
        break;
    case 2:
        msg += "the mappings contained a number larger than 2**32";
        break;
    case 3:
        msg += "reached EOF while in the middle of parsing a VLQ";
        break;
    case 4:
        msg += "invalid base 64 character while parsing a VLQ";
        break
    default:
        msg += "unknown error code";
        break;
    }

    throw new Error(msg);
}

this._mappingsPtr = mappingsPtr;
```

运行在 WebAssembly 中的查找函数都有相似的结构，跟 Rust 语言定义的方法一样。它们判断传入的查找参数，传入一个临时的闭包回调函数到 `withMappingCallback` 得到返回值，将 `withMappingCallback` 传入 WebAssembly 就得到最终结果。

`allGeneratedPositionsFor` 在 JavaScript 中的实现如下：

```
BasicSourceMapConsumer.prototype.allGeneratedPositionsFor = function ({
    source,
    line,
    column,
}) {
    const hasColumn = column === undefined;
    column = column || 0;

    source = this._findSourceIndex(source);
    if (source < 0) {
    return [];
    }

    if (originalLine < 1) {
    throw new Error("Line numbers must be >= 1");
    }

    if (originalColumn < 0) {
    throw new Error("Column numbers must be >= 0");
    }

    const results = [];

    this._wasm.withMappingCallback(
    m => {
        let lastColumn = m.lastGeneratedColumn;
        if (this._computedColumnSpans && lastColumn === null) {
        lastColumn = Infinity;
        }
        results.push({
        line: m.generatedLine,
        column: m.generatedColumn,
        lastColumn,
        });
    }, () => {
        this._wasm.exports.all_generated_locations_for(
        this._getMappingsPtr(),
        source,
        line,
        hasColumn,
        column
        );
    }
    );

    return results;
};
```

当 JavaScript 查找 source-map，调用 `SourceMapConsumer.prototype.destroy` 方法，它会在内部调用从 WebAssembly 导出的 `free_mappings`函数：

```
BasicSourceMapConsumer.prototype.destroy = function () {
    if (this._mappingsPtr !== 0) {
    this._wasm.exports.free_mappings(this._mappingsPtr);
    this._mappingsPtr = 0;
    }
};
```

## 基准测试

所有测试都是运行在 2014 年年中生产的 MacBook Pro 上，具体配置是 2.8 GHz Intel i7 处理器，16 GB 1600 MHz DDR3 内存。笔记本电脑测试过程中一直插入电源，并且在进行网页基准测试时，每次测试开始前都刷新网页。测试使用的浏览器的版本号非别是：Chrome Canary 65.0.3322.0, Firefox Nightly 59.0a1 (2018-01-15), Safari 11.0.2 (11604.4.7.1.6)<sup><a href="#note3">[3]</a></sup>。为了保证测试环境一致，在采集执行时间前都运行 5 次来 `预热` 浏览器的 JIT 编译器，然后计算运行 100 次的总时间。

我们使用同一个 source-map 文件，选用文件中三个不同位置大小的片段作为测试素材：

1. 用 JavaScript 实现的 [压缩版](https://github.com/mozilla/source-map/blob/2c6fb7e30bae18d7213a721c2854cb24a84cab04/dist/source-map.min.js.map) `source-map`。这个 source-map 文件用 [UglifyJS](https://github.com/mishoo/UglifyJS2) 进行压缩，最终的 `“映射集”` 字符串长度只有 30,081 个字符。

2. [Angular.JS 最后版本压缩得到的 source-map](https://code.angularjs.org/latest/)，这个 `“映射集”` 字符串长度是 391,473 个字符。

1. [Scala.JS 运行时的计算得到 JavaScript](https://github.com/mozilla/source-map/blob/master/bench/scalajs-runtime-sourcemap.js) 的 `source-map`。这个映射体积最大，`“映射集”` 字符串长度是 14,964,446 个字符。

另外，我们还专门增加两种人为的 source-map 结构：

1. 将 Angular.JS source map 原体积扩大 10 倍。`“映射集”` 字符串长度是 3,914,739 个字符。

2. 将 Scala.JS source map 原体积扩大 2 倍。`“映射集”` 字符串长度是 29,928,893 个字符。这个 source-map 在保持其他基准的情况下我们只收集运行 40 次的时间。

精明的读者可能会留意到，扩大后的 source-map 分别多出 9 个和 1 个字符，这多出的字符数量恰好是在扩大过程中将 suorce-map 分隔开的 `;`。

我们把目光集中到 Scala.JS source map，它是不经过人为扩大时体积最大的版本。另外，它还是我们所测试的过的浏览器环境中体积最大的。用 Chrome 测试体积最大的 source-map 时什么数据也没有 (扩大 2 倍的 Scala.JS source map)。用 JavaScript 实现的版本，我们没法通过组合模拟出 Chrome 标签的内容进行崩溃；用 WebAssembly 实现的版本，Chrome 将会抛出 `运行时错误：内存访问超出界限`，使用 Chrome 的 debugger 工具，可以发现是由于 `.wasm` 文件缺少内存泄漏时的处理指令。其他浏览器在 WebAssembly 实现的版本都能成功通过基准测试，所以，我只能认为这是 Chrome 浏览器的一个bug

**对于基准测试，值越小测试效果越好**

### 在某个位置设置一个断点

第一个基准测试程序通过在源码打上断点来进行分步调试。它需要 source-map 正在被解析成 `“映射集”` 字符串，而且解析得到的映射以源码出现的位置进行排列，这样我们就可以通过二分查找的方法找到断点对应 `“映射集”` 中的行号。查找结果返回编译后的文件对应 JavaScript 源码的定位。 

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/set.first_.breakpoint.mean_.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/set.first_.breakpoint.mean_.png)

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/set.first_.breakpoint.scalajs.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/set.first_.breakpoint.scalajs.png)

WebAssembly 的实现在浏览器中的执行性能要全面优于 JavaScript 的实现。对于 Scala.JS source map，使用 WebAssembly 实现的版本运行时间在 Chrome 浏览器只有原来的 0.65x、在 Firefox 浏览器只有原来的 0.30x、在 Safari 浏览器只有原来的 0.37x。使用 WebAssembly 实现，运行时间最短的是 Safari 浏览器，平均只需要 702 ms，紧跟着的是 Firefox 浏览器需要 877 ms，最后是 Chrome 浏览器需要 1140 ms。

此外，[相对误差值](https://en.wikipedia.org/wiki/Coefficient_of_variation) ，WebAssembly 实现要远远小于 JavaScript 实现的版本，尤其是在 Firefox 浏览器中。以 Scala.JS source map 的 JavaScript 实现的版本为例，Chrome 浏览器相对误差值是 ±4.07%，Firefox 浏览器是 ±10.52%，Safari 浏览器是 ±6.02%。WebAssembly 实现的版本中，Chrome 浏览器的相对误差值缩小到 ±1.74%，在 Firefox 浏览器 ±2.44%，在 Safari 浏览器 ±1.58%。

### 在异常的位置暂停

第二个基准测试用来补充第一个基准测试中的意外情况。当逐步调试暂停而且捕获到一个未知的异常，但是没有生成 JavaScript 代码，当一个控制台打印信息没有给出生成 JavaScript 代码，或者逐步调试生成的 JavaScript 来自于其他的 JavaScript 源码，就启用第二个基准测试方案。

对 JavaScript 源码和编译后的代码进行定位时，`“映射集”` 字符串必须停止解析。已经解析好的映射经过排序创建 JavaScript 的定位，这样就可以通过二分查找定位到最接近的映射定位，根据映射定位找到最接近的源文件定位。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/first.pause_.at_.exception.mean_.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/first.pause_.at_.exception.mean_.png)

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/first.pause_.at_.exception.scalajs.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/first.pause_.at_.exception.scalajs.png)

再一次的，在所有浏览器对 WebAssembly 和 JavaScript 这两种实现多维评估模型测试，WebAssembly 在运行时间上遥遥领先。对比 Scala.JS source map，在 Chrome 浏览器中 WebAssembly 实现的版本只需要花费 JavaScript 的 0.23x。在 Firefox 浏览器和 Safari 浏览器中只需要花费 0.17x。Safari 浏览器运行 WebAssembly 最快 (305ms)，紧接着是 Firefox 浏览器 (397ms)，最后是 Chrome 浏览器 (486ms)。

WebAssembly 实现的结果误差值也更小，对比 Scala.JS 的实现，在 Chrome浏览器中相对误差值从 ±4.04% 降到 2.35±%，在 Firefox 浏览器从 ±13.75% 降到 ±2.03%，在 Safari 浏览器从 ±6.65% 降到 ±3.86%。

### 伴随断点和异常暂停的基准测试

第三和第四个基准测试，通过观察在第一个断点紧接着又设置一个断点，或者在发现异常暂停的位置后又设置暂停，或者转换打印的运行日志信息的时间花销。按照以往，这些操作都不会成为性能瓶颈：性能花销最大的地方在于 `“映射集”` 字符串的解析和可查找数据的结构构建（对数组进行排序）。

话说是这么说，我们还是希望能确保这些花销能维持的更加 `稳定`：我们不希望这些操作会在某些条件下性能花销突然提高。

以下是在基准测试中，不同的编译后文件定位到源文件的二分查找所花的时间。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/subsequent.setting.breakpoints.mean_.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/subsequent.setting.breakpoints.mean_.png) [![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/subsequent.setting.breakpoints.scalajs.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/subsequent.setting.breakpoints.scalajs.png)

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/subsequent.pausing.at_.exceptions.mean_.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/subsequent.pausing.at_.exceptions.mean_.png) [![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/subsequent.pausing.at_.exceptions.scalajs.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/subsequent.pausing.at_.exceptions.scalajs.png)

这个基准测试比其他基准测试的结果要更丰富。查看 Scala.JS source map 以不同的实现方式输入到不同浏览器中可以看到更细小的差异。因为都是用很小的时间单位去衡量测试结果，所以细小的时间差异也能显现出来。我们可以看到 Chrome 浏览器只用了十分之一毫秒，Firefox 浏览器只用了 0.02 毫秒，Safari 浏览器用了 1 毫秒。

根据这些数据，我们可以得出结论，后续查询操作在 JavaScript 和 WebAssembly 实现中大部分都保持在毫秒级以下。后续查询从来不会成为用 WebAssembly 来重新实现时的瓶颈。

### 遍历所有映射

最后两个基准测试的是解析 source-map 并立即遍历所有映射所花的时间，而且遍历的映射都是假定为已经解析完毕的。这是一个很普通的操作，通过构建工具消耗和重建 source-map。它们有时也通过逐步调试器向用户强调用户可以设置断点的原始源内的哪些行 —— 在没有转换为生成中的任何位置的 JavaScript 行上设置断点没有意义。

这些基准测试也有一个地方让我们十分担忧：它涉及了很多 JavaScript↔WebAssembly 两种代码相互穿插运行，在映射 source-map 时还要注意 FFI。对于所有基准测试，我们已经最大限度的减少这种 FFI 调用。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/parse.and_.iterate.mean_.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/parse.and_.iterate.mean_.png) [![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/parse.and_.iterate.scalajs.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/parse.and_.iterate.scalajs.png)

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/iterate.already.parsed.mean_.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/iterate.already.parsed.mean_.png) [![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/iterate.already.parsed.scalajs.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/iterate.already.parsed.scalajs.png)

事实证明，我们的担心是多余的。 WebAssembly 实现不仅满足 JavaScript 实现的性能，即使 source-map 已被解析，也超过了 JavaScript 实现的性能。对于分析迭代和迭代已解析的基准测试，WebAssembly 在 Chrome 浏览器中的时间花费是 JavaScript 的 0.61 倍和 0.71 倍。在 Firefox 浏览器中，WebAssembly 的时间花费 JavaScript 的 0.56 倍和 0.77 倍。在 Safari 浏览器中，WebAssembly 实现是 JavaScript 实现的时间 0.63 倍和 0.87倍。 Safari 浏览器再一次以最快的速度运行 WebAssembly 实现，Firefox 浏览器和 Chrome 浏览器基本上排在第二位。 Safari 浏览器在迭代已解析的基准测试中值得对 JavaScript 性能给予特别优化：除了超越其他浏览器的 JavaScript 时间之外，Safari 浏览器运行 JavaScript 的速度比其他浏览器运行WebAssembly 的速度还要快！

这符合早期基准测试趋势，我们还看到 WebAssembly 相对误差比 JavaScript 的相对误差要小。经过解析和遍历，Chrome 浏览器的相对误差从 ±1.80% 降到 ±0.33%，Firefox 浏览器从 ±11.63% 降到 ±1.41%，Safari 浏览器从 ±2.73% 降到 ±1.51%。当遍历一个已经解析完的映射，Firefox 浏览器的相对误差从 ±12.56% 降到 ±1.40%，Safari 浏览器从 ±1.97% 降到 ±1.40%。Chrome 浏览器的相对误差从 ±0.61% 升到 ±1.18%，这是基准测试中唯一一个趋势上升的浏览器。

### 代码体积

使用 `wasm32-unknown-unknown` 比 `wasm32-unknown-emscripten` 的好处在于生成的 WebAssembly 代码体积更小。`wasm32-unknown-emscripten` 包含了许多补丁，比如 `libc`，比如在文件系统顶部建立 `IndexedDB`，对于 `source-map` 库，我们只使用 `wasm32-unknown-unknown`。

我们考虑的是最终交付到客户端的 JavaScript 和 WebAssembly 代码体积。也就是说，我们在将 JavaScript 模块捆绑到一个 `.js` 文件后查看代码大小。我们看看使用 `wasm-gc`，`wasm-snip` 和 `wasm-opt` 缩小 `.wasm` 文件体积的效果，以及使用网页上都支持的 `gzip` 压缩。

在这个衡量标准下，JavaScript 的体积总是指压缩后的大小， 用 [Google Closure 编译器](https://developers.google.com/closure/compiler) 创建属于 “简单” 的优化级别。我们使用 Closure Compiler 只因为 UglifyJS 对于一些新的 ECMAScript 标准无效(例如 `let` 和箭头函数)。我们使用 “简单” 的优化级别，因为 “高级” 优化级别对于没有用 Closure Compiler 编写的 JavaScript 具有破坏性。

标记为 “JavaScript” 的条形图用于原始的纯 JavaScript `source-map` 库实现的变体。标记为 “WebAssembly” 的条形图用于新的 `source-map` 库实现的变体，它使用 WebAssembly 来解析字符串的 “映射” 并查询解析的映射。请注意，“WebAssembly” 实现仍然使用 JavaScript 来实现所有其他功能！ `source-map` 库有额外的功能，比如生成映射地图，这些功能仍然在 JavaScript 中实现。对于 “WebAssembly” 实现，我们报告 WebAssembly 和 JavaScript 的大小。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/size.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/size.png)

在最小处，新的 WebAssembly 实现总代码体积要比旧的 JavaScript 实现大很多：分别是 20,996 字节与 8,365字节。尽管如此，使用 `.wasm` 的工具进行代码压缩，得到的 WebAssembly 文件只有原来体积的 0.16 倍。代码量跟 JavaScript 差不多。

如果我们用 WebAssembly 替换 JavaScript 解析和查询代码，为什么 WebAssembly 实现不包含更少的 JavaScript？有两个因素导致 JavaScript 无法剔除。首先，需要引入一些新的 JavaScript 来加载 `.wasm` 文件并给 WebAssembly 提供接口。其次，更重要的是，我们 “替换” 的一些 JavaScript 事务与 `suorce-map` 库的其他部分共享。虽然现在事务已经不再共享，但是其他库可能仍然在使用。

让我们把目光投向 `gzip` 压缩过的 `.wasm` 文件。运行 `wasm-objdump -h` 给出每一部分的体积：

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/section-sizes.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/section-sizes.png)

`Code` 和 `Data` 几乎占据了 `.wasm` 文件的体积。`Code` 部分包含组成函数体的 WebAssembly 编码指令。`Data` 部分包含要加载到 WebAssembly 模块的连续内存空间中的静态数据。

使用 `wasm-objdump` 手动检查 `Data` 部分的内容，显示它主要由用于构建诊断消息的字符串片段组成，比如 Rust 代码运行出错的。但是，在定位 WebAssembly 时，Rust 运行错误会转化为 WebAssembly 陷阱，并且陷阱不会携带额外的诊断信息。我们认为这是 `rustc` 中的一个错误，即这些字符串片段被提交出去。不幸的是，`wasm-gc` 目前还不能移除没有使用过的 `Data` 片段，所以我们在这段时间内一直处于这种臃肿的状态。WebAssembly 和相关工具仍然不成熟，我们希望工具链随着时间的推移在这方面得到改进。 

接下来，我们对 `wasm-objdump` 的反汇编输出进行后处理，以计算 `Code` 部分中每个函数体的大小，并得到用 Rust 创建时的大小：

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/crate-size.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/crate-size.png)

最重要的代码块是 `dlmalloc`，它通过 `alloc` 实现 Rust 底层的内存分配 APIs。`dlmalloc` 和 `alloc` 加起来一共是 10,126 字节，占总函数代码量的 50.98%。从某种意义上说，这是一种解脱：分配器的代码大小是一个常数，不会随着我们将更多的 JavaScript 代码移植到 Rust 而增长。

我们自己实现的代码总量是（`vlq`，`source_map_mappings`和 `source_map_mappings_wasm_api`）9,320 字节，占总函数体积的 46.92%。只留了 417 字节（2.10%）给其它函数。这足以说明 `wasm-gc`，`wasm-snip` 和 `wasm-opt` 的功效：`std` 比我们的代码要多，但我们只使用了一小部分 API，所以只保留我们用过的函数。

## 总结和展望

用 Rust 和 WebAssembly 重构 source-map 中性能最敏感的解析和查找的功能已经完成。在我们的基准测试中，WebAssembly 实现只需要原始 JavaScript 实现所花费时间的一小部分 —— 仅为 0.17倍。我们观察到在所有浏览器中，WebAssembly 实现总是比 JavaScript 实现的性能要好。WebAssembly 实现也比 JavaScript 实现更加一致和可靠的性能：WebAssembly 实现的进行遍历操作的时间相对误差值更小。

JavaScript 已经以性能的名义积累了许多令人费解的代码，我们用可读性更好的 Rust 替代了它。Rust 并不强迫我们在清晰表达意图和运行时间表现之间进行选择。

换句话说，我们仍然要为此做许多工作。

下一步工作的首要目标是彻底了解为什么 Rust 标准库的排序在 WebAssembly 中没有达到我们实现的快排性能。这个表现另我们惊讶不已，因为我们实现的快排依旧很粗糙，而标准库的快排在模式设计上很失败，投机性的使用了最小插入排序和大范围排序。事实上，在原生环境下，标准库的排序性能要比我们实现的排序要好。我们推测是内联函数引起运行目标转移，而我们的比较函数没有内联到标准库中，所以当目标转移到 WebAssembly 时，标准库的排序性能就会下降。这需要进一步的验证。

我们发现 WebAssembly 体积分析太困难而显得不是很必要。为了获得更有意义的信息，我们只能编写 [我们自己实现的反编译脚本 `wasm-objdump`](https://github.com/fitzgen/source-map-mappings/blob/cfbb11e1af65b1e9c22bfe082c95f849e5812708/source-map-mappings-wasm-api/who-calls.py)。该脚本构造调用图，并让我们查询某些函数的调用者是谁，帮助我们理解为什么该函数是在 `.wasm` 文件中被提交，即使我们没有预料到它。很不好意思，这个脚本对内联函数不起作用。一个适当的 WebAssembly 体积分析器会有所帮助，并且任何人都能从追踪得到有用的信息。

内存分配器的代码体积相对较大，重构或者调整一个分配器的代码量可以为 WebAssembly 生态系统提供相当大的作用。至少对于我们的用例，内存分配器的性能几乎不用考虑，我们只需要手动分配很小的动态内存。对于内存分配器，我们会毫不犹豫的选择代码体积小的。

`Data` 部分中没有使用的片段需要用 `wasm-gc` 或者其他工具进行高亮，检测和删除永远不会被使用的静态数据。

我们仍然可以对库的下游用户进行一些 JavaScript API 改进。在我们当前的实现中引入 WebAssembly 需要引入在用户完成映射解析时手动释放内存。对于大多数习惯依赖垃圾回收器的 JavaScript 程序员来说，这并非自然而然，他们通常不会考虑任何特定对象的生命周期。我们可以传入 `SourceMapConsumer.with` 函数，它包含一个未解析的 source-map 和一个 `async` 函数。 `with` 函数将构造一个 `SourceMapConsumer` 实例，用它调用 `async` 函数，然后在 `async` 函数调用完成后调用 `SourceMapConsumer` 实例的 `destroy`。这就像 JavaScript 的`async` RAII。

```
SourceMapConsumer.with = async function (rawSourceMap, f) {
    const consumer = await new SourceMapConsumer(rawSourceMap);
    try {
    await f(consumer);
    } finally {
    consumer.destroy();
    }
};
```

另一个使 API 更容易被 JavaScript 编程人员使用的方法是把 `SourceMapConsumer` 传入每一个  WebAssembly 模块。因为 `SourceMapConsumer` 实例占据了 WebAssembly 模块实例的 GC 边缘，垃圾回收器就管理了 `SourceMapConsumer` 实例、WebAssembly 模块实例和模块实例堆。通过这个策略，我们用一个简单的 `static mut MAPPINGS: Mappings` 就可以把 Rust 和 WebAssembly 胶粘起来，并且 `Mapping` 实例在所有导出的查找函数都是不可见的。在 `parse_mappings` 函数中不再有 `Box :: new（mappings）` ，并且不再传递 `* mut Mappings` 指针。谨慎期间，我们可能需要把 Rust 库所有内存分配函数移除，这样可以把需要提交的 WebAssembly 体积缩小一半。当然，这一切都取决于创建相同 WebAssembly 模块的多个实例是一个相对简单的操作，这需要进一步调查。

[`wasm-bindgen`](https://github.com/alexcrichton/wasm-bindgen) 项目的目标是移除所有需要手动编写的 FFI 胶粘代码，实现 WebAssembly 和 JavaScript 的自动化对接。使用它，我们能够删除所有涉及将 Rust API 导出到 JavaScript 的手写 `不安全` 指针操作代码。

在这个项目中，我们将 source-map 解析和查询移植到 Rust 和 WebAssembly 中，但这只是 `source-map` 库功能的一半。另一半是生成源映射，它也是性能敏感的。我们希望在未来的某个时候重写 Rust 和 WebAssembly 中构建和编码源映射的核心。我们希望将来能看到生成源映射也能达到这样的性能。

[WebAssembly 实现的 `mozilla/source-map` 库所有提交申请的合集](https://github.com/mozilla/source-map/pull/306) 这个提交申请包含了基准测试代码，可以将结果重现，你也可以继续完善它。

最后，我想感谢 [Tom Tromey](http://tromey.com) 对这个项目的支持。同时也感谢 [Aaron Turon](http://aturon.github.io/blog/)、[Alex Crichton](http://alexcrichton.com/)、[Benjamin Bouvier](https://benj.me/)、[Jeena Lee](http://jeenalee.com/)、[Jim Blandy](http://www.red-bean.com/jimb/)、[Lin Clark](https://code-cartoons.com/)、[Luke Wagner](https://blog.mozilla.org/luke/)、[Mike Cooper](http://www.mythmon.com/) 以及 [Till Schneidereit](http://tillschneidereit.net/) 阅审阅原稿并提供了宝贵的意见。非常感谢他们对基准测试代码和 `source-map` 库的贡献。

* * *

<a name="note0">[0]</a> 或者你坚持叫做 [“转译器”](http://composition.al/blog/2017/07/30/what-do-people-mean-when-they-say-transpiler/)

<a name="note1">[1]</a> [当你传入自己定义的对比函数，SpiderMonkey 引擎会使用 JavaScript 数组原型的排序方法 `Array.prototype.sort`；如果不传入对比函数，SpiderMonkey 引擎会使用 C++ 实现的排序方法](https://searchfox.org/mozilla-central/rev/7fb999d1d39418fd331284fab909df076b967ac6/js/src/builtin/Array.js#184-227) 

<a name="note2">[2]</a> [一旦 Firefox 浏览器出现 1319203 错误码，WebAssembly 和 JavaScript 之间的调用性能将会急速下降](https://bugzilla.mozilla.org/show_bug.cgi?id=1319203)。WebAssembly 和 JavaScript 的调用和 JavaScript 之间的调用开销都是非线性增长的，截止本文发表前各大浏览器厂商仍然没能改进这个问题。 

<a name="note3">[3]</a> Firefox 浏览器和 Chrome 浏览器我们都进行了 `每日构建` 测试，但是没有对 Safari 浏览器进行这样的测试。因为最新的 Safari Technology Preview 需要比 El Capitan 更新的 macOS 版本，而这款电脑就运行这个版本了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
