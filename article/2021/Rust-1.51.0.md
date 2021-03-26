> * 原文地址：[Announcing Rust 1.51.0](https://blog.rust-lang.org/2021/03/25/Rust-1.51.0.html)
> * 原文作者：The Rust Release Team
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Rust-1.51.0.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Rust-1.51.0.md)
> * 译者：
> * 校对者：

# Announcing Rust 1.51.0

The Rust team is happy to announce a new version of Rust, 1.51.0. Rust is a programming language that is empowering everyone to build reliable and efficient software.

If you have a previous version of Rust installed via rustup, getting Rust 1.51.0 is as easy as:

```
rustup update stable

```

If you don't have it already, you can [get `rustup`](https://www.rust-lang.org/install.html) from the appropriate page on our website, and check out the [detailed release notes for 1.51.0](https://github.com/rust-lang/rust/blob/master/RELEASES.md#version-1510-2021-03-25) on GitHub.

## What's in 1.51.0 stable

This release represents one of the largest additions to the Rust language and Cargo in quite a while, stabilizing an MVP of const generics and a new feature resolver for Cargo. Let's dive right into it!

### Const Generics MVP

Before this release, Rust allowed you to have your types be parameterized over lifetimes or types. For example if we wanted to have a `struct` that is generic over the element type of an array, we'd write the following:

```
struct FixedArray<T> {
              // ^^^ Type generic definition
    list: [T; 32]
        // ^ Where we're using it.
}

```

If we then use `FixedArray<u8>`, the compiler will make a monomorphic version of `FixedArray` that looks like:

```
struct FixedArray<u8> {
    list: [u8; 32]
}

```

This is a powerful feature that allows you to write reusable code with no runtime overhead. However, until this release it hasn't been possible to easily be generic over the *values* of those types. This was most notable in arrays which include their length in their type definition (`[T; N]`), which previously you could not be generic over. Now with 1.51.0 you can write code that is generic over the values of any integer, `bool`, or `char` type! (Using `struct` or `enum` values is still unstable.)

This change now lets us have our own array struct that's generic over its type *and* its length. Let's look at an example definition, and how it can be used.

```
struct Array<T, const LENGTH: usize> {
    //          ^^^^^^^^^^^^^^^^^^^ Const generic definition.
    list: [T; LENGTH]
    //        ^^^^^^ We use it here.
}

```

Now if we then used `Array<u8, 32>`, the compiler will make a monomorphic version of `Array` that looks like:

```
struct Array<u8, 32> {
    list: [u8; 32]
}

```

Const generics adds an important new tool for library designers in creating new, powerful compile-time safe APIs. If you'd like to learn more about const generics you can also check out the ["Const Generics MVP Hits Beta"](https://blog.rust-lang.org/2021/02/26/const-generics-mvp-beta.html) blog post for more information about the feature and its current restrictions. We can't wait to see what new libraries and APIs you create!

### `array::IntoIter` Stabilisation

As part of const generics stabilising, we're also stabilising a new API that uses it, `std::array::IntoIter`. `IntoIter` allows you to create a by value iterator over any array. Previously there wasn't a convenient way to iterate over owned values of an array, only references to them.

```
fn main() {
  let array = [1, 2, 3, 4, 5];

  // Previously
  for item in array.iter().copied() {
      println!("{}", item);
  }

  // Now
  for item in std::array::IntoIter::new(array) {
      println!("{}", item);
  }
}

```

Note that this is added as a separate method instead of `.into_iter()` on arrays, as that currently introduces some amount of breakage; currently `.into_iter()` refers to the slice by-reference iterator. We're exploring ways to make this more ergonomic in the future.

### Cargo's New Feature Resolver

Dependency management is a hard problem, and one of the hardest parts of it is just picking what *version* of a dependency to use when it's depended on by two different packages. This doesn't just include its version number, but also what features are or aren't enabled for the package. Cargo's default behaviour is to merge features for a single package when it's referred to multiple times in the dependency graph.

For example, let's say you had a dependency called `foo` with features A and B, which was being used by packages `bar` and `baz`, but `bar` depends on `foo+A` and `baz` depends on `foo+B`. Cargo will merge both of those features and compile `foo` as `foo+AB`. This has a benefit that you only have to compile `foo` once, and then it can reused for both `bar` and `baz`.

However, this also comes with a downside. What if a feature enabled in a build-dependency is not compatible with the target you are building for?

A common example of this in the ecosystem is the optional `std` feature included in many `#![no_std]` crates, that allows crates to provide added functionality when `std` is available. Now imagine you want to use the `#![no_std]` version of `foo` in your `#![no_std]` binary, and use the `foo` at build time in your `build.rs`. If your build time dependency depends on `foo+std`, your binary now also depends on `foo+std`, which means it will no longer compile because `std` is not available for your target platform.

This has been a long-standing issue in cargo, and with this release there's a new `resolver` option in your `Cargo.toml`, where you can set `resolver="2"` to tell cargo to try a new approach to resolving features. You can check out [RFC 2957](https://rust-lang.github.io/rfcs/2957-cargo-features2.html) for a detailed description of the behaviour, which can be summarised as follows.

- **Dev dependencies** — When a package is shared as a normal dependency and a dev-dependency, the dev-dependency features are only enabled if the current build is including dev-dependencies.
- **Host Dependencies** — When a package is shared as a normal dependency and a build-dependency or proc-macro, the features for the normal dependency are kept independent of the build-dependency or proc-macro.
- **Target dependencies** — When a package appears multiple times in the build graph, and one of those instances is a target-specific dependency, then the features of the target-specific dependency are only enabled if the target is currently being built.

While this can lead to some crates compiling more than once, this should provide a much more intuitive development experience when using features with cargo. If you'd like to know more, you can also read the ["Feature Resolver"](https://doc.rust-lang.org/nightly/cargo/reference/features.html#feature-resolver-version-2) section in the Cargo Book for more information. We'd like to thank the cargo team and everyone involved for all their hard work in designing and implementing the new resolver!

```
[package]
resolver = "2"
# Or if you're using a workspace
[workspace]
resolver = "2"

```

### Splitting Debug Information

While not often highlighted in the release, the Rust teams are constantly working on improving Rust's compile times, and this release marks one of the largest improvements in a long time for Rust on macOS. Debug information maps the binary code back to your source code, so that the program can give you more information about what went wrong at runtime. In macOS, debug info was previously collected into a single `.dSYM` folder using a tool called `dsymutil`, which can take some time and use up quite a bit of disk space.

Collecting all of the debuginfo into this directory helps in finding it at runtime, particularly if the binary is being moved. However, it does have the drawback that even when you make a small change to your program, `dsymutil` will need to run over the entire final binary to produce the final `.dSYM` folder. This can sometimes add a lot to the build time, especially for larger projects, as all dependencies always get recollected, but this has been a necessary step as without it Rust's standard library didn't know how to load the debug info on macOS.

Recently, Rust backtraces switched to using a different backend which supports loading debuginfo without needing to run `dsymutil`, and we've stabilized support for skipping the `dsymutil` run. This can significantly speed up builds that include debuginfo and significantly reduce the amount of disk space used. We haven't run extensive benchmarks, but have seen a lot of reports of people's builds being a lot faster on macOS with this behavior.

You can enable this new behaviour by setting the `-Csplit-debuginfo=unpacked` flag when running `rustc`, or by setting the `[split-debuginfo](https://doc.rust-lang.org/nightly/cargo/reference/profiles.html#split-debuginfo)` `[profile]` option to `unpacked` in Cargo. The "unpacked" option instructs rustc to leave the .o object files in the build output directory instead of deleting them, and skips the step of running dsymutil. Rust's backtrace support is smart enough to know how to find these .o files. Tools such as lldb also know how to do this. This should work as long as you don't need to move the binary to a different location while retaining the debug information.

```
[profile.dev]
split-debuginfo = "unpacked"

```

### Stabilized APIs

In total, this release saw the stabilisation of 18 new methods for various types like `slice` and `Peekable`. One notable addition is the stabilisation of `ptr::addr_of!` and `ptr::addr_of_mut!`, which allow you to create raw pointers to unaligned fields. Previously this wasn't possible because Rust requires `&/&mut` to be aligned and point to initialized data, and `&addr as *const _` would then cause undefined behaviour as `&addr` needs to be aligned. These two macros now let you safely create unaligned pointers.

```
use std::ptr;

#[repr(packed)]
struct Packed {
    f1: u8,
    f2: u16,
}

let packed = Packed { f1: 1, f2: 2 };
// `&packed.f2` would create an unaligned reference, and thus be Undefined Behavior!
let raw_f2 = ptr::addr_of!(packed.f2);
assert_eq!(unsafe { raw_f2.read_unaligned() }, 2);

```

The following methods were stabilised.

- `[Arc::decrement_strong_count](https://doc.rust-lang.org/stable/std/sync/struct.Arc.html#method.decrement_strong_count)`
- `[Arc::increment_strong_count](https://doc.rust-lang.org/stable/std/sync/struct.Arc.html#method.increment_strong_count)`
- `[Once::call_once_force](https://doc.rust-lang.org/stable/std/sync/struct.Once.html#method.call_once_force)`
- `[Peekable::next_if_eq](https://doc.rust-lang.org/stable/std/iter/struct.Peekable.html#method.next_if_eq)`
- `[Peekable::next_if](https://doc.rust-lang.org/stable/std/iter/struct.Peekable.html#method.next_if)`
- `[Seek::stream_position](https://doc.rust-lang.org/stable/std/io/trait.Seek.html#method.stream_position)`
- `[array::IntoIter](https://doc.rust-lang.org/stable/std/array/struct.IntoIter.html)`
- `[panic::panic_any](https://doc.rust-lang.org/stable/std/panic/fn.panic_any.html)`
- `[ptr::addr_of!](https://doc.rust-lang.org/stable/std/ptr/macro.addr_of.html)`
- `[ptr::addr_of_mut!](https://doc.rust-lang.org/stable/std/ptr/macro.addr_of_mut.html)`
- `[slice::fill_with](https://doc.rust-lang.org/stable/std/primitive.slice.html#method.fill_with)`
- `[slice::split_inclusive_mut](https://doc.rust-lang.org/stable/std/primitive.slice.html#method.split_inclusive_mut)`
- `[slice::split_inclusive](https://doc.rust-lang.org/stable/std/primitive.slice.html#method.split_inclusive)`
- `[slice::strip_prefix](https://doc.rust-lang.org/stable/std/primitive.slice.html#method.strip_prefix)`
- `[slice::strip_suffix](https://doc.rust-lang.org/stable/std/primitive.slice.html#method.strip_suffix)`
- `[str::split_inclusive](https://doc.rust-lang.org/stable/std/primitive.str.html#method.split_inclusive)`
- `[sync::OnceState](https://doc.rust-lang.org/stable/std/sync/struct.OnceState.html)`
- `[task::Wake](https://doc.rust-lang.org/stable/std/task/trait.Wake.html)`

## Other changes

There are other changes in the Rust 1.51.0 release: check out what changed in [Rust](https://github.com/rust-lang/rust/blob/master/RELEASES.md#version-1510-2021-03-25), [Cargo](https://github.com/rust-lang/cargo/blob/master/CHANGELOG.md#cargo-151-2021-03-25), and [Clippy](https://github.com/rust-lang/rust-clippy/blob/master/CHANGELOG.md#rust-151).

## Contributors to 1.51.0

Many people came together to create Rust 1.51.0. We couldn't have done it without all of you. [Thanks!](https://thanks.rust-lang.org/rust/1.51.0/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
