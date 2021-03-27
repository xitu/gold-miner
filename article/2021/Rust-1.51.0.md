> * 原文地址：[Announcing Rust 1.51.0](https://blog.rust-lang.org/2021/03/25/Rust-1.51.0.html)
> * 原文作者：The Rust Release Team
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Rust-1.51.0.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Rust-1.51.0.md)
> * 译者：[洛竹](https://github.com/youngjuning)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)

# Rust v1.51.0 发布

Rust 团队很高兴地宣布 Rust v1.51.0 发布了。Rust 是一种编程语言，它使每个人都可以构建可靠且高效的软件。

如果你通过 `rustup` 安装过旧版本的 Rust，那么可以通过下面的命令快速更新到 Rust 1.51.0：

```sh
rustup update stable
```

如果你还没有安装 `rustup`，你可以在我们网站的 [安装 Rust](https://www.rust-lang.org/zh-CN/tools/install) 页面获取。另外，你可以在 GitHub 上查看 [v1.51.0 的详细发行说明](https://github.com/rust-lang/rust/blob/master/RELEASES.md#version-1510-2021-03-25)。

## v1.51.0 包含的内容

此版本代表了相当长一段时间以来 Rust 语言和 Cargo 的大量功能新增和改进、稳定了 [最简可行](https://zh.wikipedia.org/wiki/%E6%9C%80%E7%B0%A1%E5%8F%AF%E8%A1%8C%E7%94%A2%E5%93%81) 的 Const Generics（Const 泛型）以及 Cargo 的新的功能解析器。那么，接下来我们具体了解下这些内容。

### Const Generics MVP（Const 泛型）

> MVP（中文：最简可行产品，Minimum Viable Product） 是新产品开发中的名词，是指有部分机能，恰好可以让设计者表达其核心设计概念的产品。

在此版本之前，Rust 允许你在生命周期或类型中对类型进行参数化。比如，如果我们创建了一个 `struct` 并且想让其数据元素的类型是泛型，我们可以编写以下代码：

```rs
struct FixedArray<T> {
    // Type generic 定义
    list: [T; 32]
    // 我们在这里使用它
}
```

如果我们随后使用 `FixedArray <u8>`，则编译器将生成 `FixedArray` 的单态版本，如下所示：

```rs
struct FixedArray<u8> {
    list: [u8; 32]
}
```

这是一项强大的功能，可让你编写没有运行时的开销的可重用的代码。但是，直到发布此版本之前，你不可能轻松地对这些类型的 *值* 进行泛型化。这在数组中最为明显，在数组的类型定义中包含了长度（`[T; N]`），以前你不能将其泛型化。现在有了 1.51.0，你可以编写将任何`integer`、`bool` 或 `char` 类型的值泛型化的代码！（使用 `struct` 或 `enum` 的值仍然不稳定。）

```rs
struct Array<T, const LENGTH: usize> {
    // Const generic 定义
    list: [T; LENGTH]
    // 我们在这里使用它
}
```

现在如果我们使用了 `Array<u8, 32>`，则编译器将生成 `FixedArray` 的单态版本，如下所示：

```rs
struct Array<u8, 32> {
    list: [u8; 32]
}
```

Const 泛型为库设计人员添加了一个重要的新工具，可用于创建新的，功能强大的编译时安全 API。如果你想了解有关 Const 泛型的更多信息，还可以查看  [Const Generics MVP Hits Beta](https://blog.rust-lang.org/2021/02/26/const-generics-mvp-beta.html) 以获取有关此功能及其当前限制的更多信息。我们迫不及待想要看看你创建了哪些新的库和 API！

### `array::IntoIter` 稳定了

作为 Const 泛型稳定化的一部分，我们还正在稳定使用它的新 API，即 `std::array::IntoIter`。`IntoIter` 允许你在任何数组上创建按值迭代器。以前，没有一种便捷的方法可以遍历数组的所有值，仅引用它们即可。

```rs
fn main() {
  let array = [1, 2, 3, 4, 5];

  // 过去
  for item in array.iter().copied() {
      println!("{}", item);
  }

  // 现在
  for item in std::array::IntoIter::new(array) {
      println!("{}", item);
  }
}

```

请注意，这是作为单独的方法添加的，而不是在数组上添加 `.into_iter()` 的方法。由于引入了一些破坏性修改，当前 `.into_iter()` 指的是切片按引用迭代器。我们正在探索将来使之更符合人体工程学的方法。

### Cargo 的新的功能解析器

依赖管理是一个难题，它最难的部分之一就是选择两个不同的包依赖它时要使用的依赖版本。这不仅包括其版本号，还包括该软件包启用或不启用的功能。Cargo 的默认行为是在依赖关系图中多次引用单个包时合并功能。

例如，假设你有一个具有功能 A 和 B 的名为 `foo` 的依赖项，它被 `bar` 和 `baz` 软件包使用，但是 `bar` 依赖于 `foo+A` 以及  `baz` 依赖于 `foo+B`。Cargo 将合并这两个功能并以 `foo+AB` 的形式编译 `foo`。这样做的好处是你只需编译一次 `foo`，然后就可以将其重新用于 `bar` 和 `baz`。

但是，这也有不利的一面。如果在构建依赖性中启用的功能与要构建的目标不兼容怎么办？

生态系统中的一个常见示例是许多 `#![no_std]` crate 包含的可选 `std` 功能，当 `std` 可用时，它允许 crate 提供附加功能。现在假设你想在 `#![no_std]` 二进制文件中使用 `foo` 的 `#![no_std]` 版本，并在 `build.rs` 中的构建时使用 `foo`。如果你的构建时间依赖项依赖于 `foo+std`，那么你的二进制文件现在也依赖于 `foo+std`，这意味着它将不再编译，因为 `std`对你的目标平台不可用。


这是 Cargo 的一个长期存在的问题，在此版本中，你的 `Cargo.toml` 中有一个新的 `resolver` 选项，你可以在其中设置 `resolver="2"` 来告诉 Cargo 尝试一种新的方法来解析功能。你可以查看 [RFC 2957](https://rust-lang.github.io/rfcs/2957-cargo-features2.html) 以获取有关行为的详细说明，可以将其总结如下：

- **Dev dependencies**：当程序包被常规 dependency 和 dev-dependency 共享时，仅当当前版本包含 dev-dependencies 时才启用 dev-dependency 功能。
- **Host Dependencies**：当程序包被常规 dependency、build-dependency 或 proc-macro 共享时，用于常规 dependency 的功能将独立于 build-dependency 或 proc-macro。
- **Target dependencies**：当程序包在构建图中多次出现，并且其中一个实例是特定于目标的依赖项时，仅当当前正在构建目标时，才启用特定于目标的依赖项的功能。

虽然这可能导致某些 crate 不止一次被编译，但是在将功能与 Cargo 一起使用时，这会提供更直观的开发体验。如果你想了解更多信息，还可以阅读 [Feature Resolver](https://doc.rust-lang.org/nightly/cargo/reference/features.html#feature-resolver-version-2) 部分中的更多信息。我们要感谢 Cargo 以及所有参与设计和实施新解析器的辛勤工作的人！

```toml
[package]
resolver = "2"
# 或者你正在使用 workspace
[workspace]
resolver = "2"
```

### 拆分调试信息

尽管在发行版中并不经常强调，但 Rust 团队一直在努力改善 Rust 的编译时间，而该发行版是 macOS 上 Rust 长期以来最大的改进之一。调试信息将二进制代码映射回你的源代码，以便该程序可以为你提供有关运行时出现问题的更多信息。在 macOS 中，以前使用名为 `dsymutil` 的工具将调试信息收集到单个 `.dSYM` 文件夹中，该工具可能会花费一些时间并占用大量磁盘空间。

将所有调试信息收集到此目录中有助于在运行时查找它，尤其是在二进制文件正在移动的情况下。但是这样做的缺点是，即使你对程序进行了很小的更改，`dsymutil` 也将需要在整个最终二进制文件上运行以产生最终的 `.dSYM` 文件夹。时这可能会增加构建时间，尤其是对于大型项目，因为总是会收集所有依赖项，但这是必要的步骤，因为没有它，Rust 的标准库就不知道如何在 macOS 上加载调试信息。

最近，Rust 回溯切换到使用其他后端，该后端支持加载调试信息而不需要运行 `dsymutil`，并且我们已经稳定了对跳过 `dsymutil` 运行的支持。这可以显着加快包含调试信息的构建，并显着减少所使用的磁盘空间量。我们还没有运行广泛的基准测试，但是已经看到很多关于人们使用这种行为在 macOS 上构建速度更快的反馈。

你可以通过在运行 `rustc` 时设置 `-Csplit-debuginfo=unpacked` 标志或设置 [split-debuginfo](https://doc.rust-lang.org/nightly/cargo/reference/profiles.html#split-debuginfo) `[profile]` 选项以在 Cargo 中解压缩。解压缩选项指示 `rustc` 将 `.o` 对象文件保留在生成输出目录中，而不是删除它们，并跳过运行 `dsymutil` 的步骤。Rust 的回溯支持足够智能，足以知道如何查找这些 `.o` 文件。 诸如 `lldb` 之类的工具也知道如何执行此操作。只要你不需要在保留调试信息的情况下将二进制文件移动到其他位置，这就应该起作用。

```toml
[profile.dev]
split-debuginfo = "unpacked"
```

### 稳定的 API

总体而言，此发行版稳定了针对 `slice` 和 `Peekable` 等各种类型的 18 种新方法的稳定性。其中尤其值得注意的是 `ptr::addr_of!` 和 `ptr::addr_of_mut!` 的稳定化，它们允许你创建指向未对齐字段的原始指针。 以前这是不可能的，因为 Rust 要求将 `&/&mut` 对齐并指向已初始化的数据，并且 `&addr as * const _` 会导致未定义的行为，因为需要对 `&addr` 进行对齐。 这两个宏现在使你可以安全地创建未对齐的指针。

```rs
use std::ptr;

#[repr(packed)]
struct Packed {
    f1: u8,
    f2: u16,
}

let packed = Packed { f1: 1, f2: 2 };
// `＆packed.f2` 将创建未对齐的引用，因此是未定义的行为！
let raw_f2 = ptr::addr_of!(packed.f2);
assert_eq!(unsafe { raw_f2.read_unaligned() }, 2);
```

以下方法已经稳定：

- [`Arc::decrement_strong_count`](https://doc.rust-lang.org/stable/std/sync/struct.Arc.html#method.decrement_strong_count)
- [`Arc::increment_strong_count`](https://doc.rust-lang.org/stable/std/sync/struct.Arc.html#method.increment_strong_count)
- [`Once::call_once_force`](https://doc.rust-lang.org/stable/std/sync/struct.Once.html#method.call_once_force)
- [`Peekable::next_if_eq`](https://doc.rust-lang.org/stable/std/iter/struct.Peekable.html#method.next_if_eq)
- [`Peekable::next_if`](https://doc.rust-lang.org/stable/std/iter/struct.Peekable.html#method.next_if)
- [`Seek::stream_position`](https://doc.rust-lang.org/stable/std/io/trait.Seek.html#method.stream_position)
- [`array::IntoIter`](https://doc.rust-lang.org/stable/std/array/struct.IntoIter.html)
- [`panic::panic_any`](https://doc.rust-lang.org/stable/std/panic/fn.panic_any.html)
- [`ptr::addr_of!`](https://doc.rust-lang.org/stable/std/ptr/macro.addr_of.html)
- [`ptr::addr_of_mut!`](https://doc.rust-lang.org/stable/std/ptr/macro.addr_of_mut.html)
- [`slice::fill_with`](https://doc.rust-lang.org/stable/std/primitive.slice.html#method.fill_with)
- [`slice::split_inclusive_mut`](https://doc.rust-lang.org/stable/std/primitive.slice.html#method.split_inclusive_mut)
- [`slice::split_inclusive`](https://doc.rust-lang.org/stable/std/primitive.slice.html#method.split_inclusive)
- [`slice::strip_prefix`](https://doc.rust-lang.org/stable/std/primitive.slice.html#method.strip_prefix)
- [`slice::strip_suffix`](https://doc.rust-lang.org/stable/std/primitive.slice.html#method.strip_suffix)
- [`str::split_inclusive`](https://doc.rust-lang.org/stable/std/primitive.str.html#method.split_inclusive)
- [`sync::OnceState`](https://doc.rust-lang.org/stable/std/sync/struct.OnceState.html)
- [`task::Wake`](https://doc.rust-lang.org/stable/std/task/trait.Wake.html)

## 其它更新

Rust 1.51.0 发行版中还有其他更改：请查看 [Rust](https://github.com/rust-lang/rust/blob/master/RELEASES.md#version-1510-2021-03-25)、[Cargo](https://github.com/rust-lang/cargo/blob/master/CHANGELOG.md#cargo-151-2021-03-25) 和 [Clippy](https://github.com/rust-lang/rust-clippy/blob/master/CHANGELOG.md#rust-151)。

## 1.51.0 贡献者

许多优秀的开发者一起创建了 Rust 1.51.0。没有你们的支持，我们不可能做到这一点。[感谢大家](https://thanks.rust-lang.org/rust/1.51.0/)！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
