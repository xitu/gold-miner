> * 原文地址：[Announcing Dart 2.12](https://medium.com/dartlang/announcing-dart-2-12-499a6e689c87)
> * 原文作者：[Michael Thomsen](https://medium.com/@mit.mit)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Announcing-Dart-2-12.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Announcing-Dart-2-12.md)
> * 译者：
> * 校对者：
# Announcing Dart 2.12
Today we’re announcing Dart 2.12, featuring stable versions of sound null safety and Dart FFI. Null safety is our latest major productivity feature, intended to help you avoid null errors, a class of bugs that are often hard to spot, as detailed in this video introduction. FFI is an interoperability mechanism that lets you invoke existing code written in the C programming language, such as calling Windows Win32 APIs. Dart 2.12 is available today.

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e3ae9f51-7df0-44d7-a60f-237f41cd2329/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e3ae9f51-7df0-44d7-a60f-237f41cd2329/Untitled.png)

# **The Dart platform’s unique capabilities**

Before we look at sound null safety and FFI in detail, let’s discuss how they fit into our goals with the Dart platform. Programming languages tend to share a lot of capabilities. For example, many languages support object-oriented programming or running on the web. What really sets languages apart is their unique combination of capabilities.

[https://miro.medium.com/max/3200/0*msUXfhSNTNzP4wkf](https://miro.medium.com/max/3200/0*msUXfhSNTNzP4wkf)

Dart’s unique capabilities span three dimensions:

- **Portable**: Efficient compilers generate x86 and ARM machine code for devices, and optimized JavaScript for the web. A [wide range of targets](https://dart.dev/overview#platform) are supported — mobile devices, desktop PCs, app backends, and more. An extensive set of libraries and packages provide consistent APIs that work across all platforms, further lowering the cost of creating true multi-platform apps.
- **Productive**: The Dart platform supports hot reload, enabling fast, iterative development for both native devices and the web. And Dart offers rich constructs like isolates and async/await for handling common concurrent and event-driven app patterns.
- **Robust**: Dart’s sound, null-safe type system catches errors during development. And the overall platform is highly scalable and dependable, with production usage for more than a decade by a large range of apps, including business-critical apps such as Google Ads and Google Assistant.

Sound null safety makes the type system even more robust, and enables better performance. Dart FFI lets you use existing C libraries for better portability, and gives you the option of using highly tuned C code for performance-critical tasks.

# **Sound null safety**

Sound null safety is the largest addition to the Dart language since the introduction of the sound type system in [Dart 2.0](https://medium.com/dartlang/announcing-dart-2-80ba01f43b6). Null safety further strengthens the type system, enabling you to catch null errors, which are a common cause of app crashes. By opting into null safety, you can catch null errors during development, preventing crashes in production.

Sound null safety was designed around [a few core principles](https://dart.dev/null-safety#null-safety-principles). Let’s revisit how these principles impact you as a developer.

# **Non-nullable by default: A fundamental change to the type system**

The core challenge prior to null safety was that you couldn’t tell the difference between code that anticipated being passed null and code that didn’t work with nulls. A few months ago we discovered a bug in the Flutter master channel where various flutter tool commands would crash on certain machine configurations with a null error: `The method '>=' was called on null`. The underlying issue was code like this:

```
final int major = version?.major;
final int minor = version?.minor;
if (globals.platform.isMacOS) {
  // plugin path of Android Studio changed after version 4.1.
  if (major >= 4 && minor >= 1) {
  ...
```

Can you spot the error? Because `version` can be null, both `major` and `minor` can be null also. This bug might seem easy to spot here in isolation, but in practice code like this slips through all the time, even with a rigorous code review process like the one used in the Flutter repo. With null safety, static analysis catches this issue immediately. ([Try it live in DartPad](https://dartpad.dev/0e9797be7488d8ec6c3fca92b7f2740f?null_safety=true).)

[https://miro.medium.com/max/2800/0*jl-o2KmcMjj777Iu](https://miro.medium.com/max/2800/0*jl-o2KmcMjj777Iu)

Screenshot of analysis output in an IDE

That was a pretty simple error. During our early use of null safety in code internally at Google, we’ve seen much more intricate errors be caught. Some of these were bugs that were known for years, but where the teams hadn’t been able to find the cause without the additional static checks from null safety. Here are a few examples:

- An internal team found that they were often checking for null values of expressions that could never be null. This problem was most frequently seen in code using [protobuf](https://developers.google.com/protocol-buffers), where optional fields return a default value when unset, and never null. As a result, code incorrectly checked for the default condition, by confusing default values and null values.
- The Google Pay team found bugs in their Flutter code where they would fail when trying to access Flutter `State` objects outside of the context of a `Widget`. Before null safety, those objects would return null and mask the error; with null safety, the sound analysis determined that those properties could never be null, and threw an analysis error.
- The Flutter team found a bug where the Flutter engine could crash if `null` was passed to the `scene` parameter in `Window.render()`. During null safety migration, they added a hint to [mark Scene as non-nullable](https://github.com/cbracken/engine/blob/bad869e229a8a02cad6e63d12e80807b33b5c12f/lib/ui/window.dart#L1069), and were then able to easily prevent potential app crashes that null would have triggered.

# **Working with non-nullable by default**

Once you [enable null safety](https://dart.dev/null-safety#enable-null-safety), the basics of variable declarations change because the default types are non-nullable:

```
// In null-safe Dart, none of these can ever be null.
var i = 42; // Inferred to be an int.
String name = getFileName();
final b = Foo();
```

If you want to create a variable that can contain either a value or null, you need to make that explicit in the variable declaration by adding a `?` suffix to the type:

```
// aNullableInt can hold either an integer or null.
int? aNullableInt = null;
```

The implementation of null safety is robust, with rich static flow analysis making it easier to work with nullable types. For example, after checking for null, Dart promotes the type of a local variable from nullable to non-nullable:

```
int definitelyInt(int? aNullableInt) {
  if (aNullableInt == null) {
    return 0;
  }
  // aNullableInt has now promoted to a non-null int.
  return aNullableInt;
}
```

We’ve also added a new keyword, `required`. When a named parameter is marked as `required` (which happens a lot in Flutter widget APIs) and the caller forgets to provide the argument, then an analysis error occurs:

[https://miro.medium.com/max/2434/0*U_WEQJAarjskU1k2](https://miro.medium.com/max/2434/0*U_WEQJAarjskU1k2)

# **Incremental migration to null safety**

Because null safety is such a fundamental change to our typing system, it would be extremely disruptive if we insisted on forced adoption. So that *you* decide when the time is right, null safety is an opt-in feature: you can use Dart 2.12 without being forced to enable null safety. You can even depend on packages that have already enabled null safety, whether or not your app or package has enabled null safety.

To help you migrate existing code to null safety, we’re providing a migration tool and a [migration guide](https://dart.dev/null-safety/migration-guide). The tool starts by analyzing all of your existing code. Then you can interactively review the nullability properties that the tool has inferred. If you disagree with any of the tool’s conclusions, you can add nullability hints to change the inference. Adding a few migration hints can have a huge impact on migration quality.

[https://miro.medium.com/max/3200/0*srLwqVUDeF49J_B9](https://miro.medium.com/max/3200/0*srLwqVUDeF49J_B9)

For now, new packages and apps created with `[dart create](https://dart.dev/tools/dart-tool)` and `[flutter create](https://flutter.dev/docs/reference/flutter-cli)` don’t enable sound null safety. We expect to change that in a future stable release, when we see that most of the ecosystem has migrated. You can easily [enable null safety](https://dart.dev/null-safety#create) in a newly created package or app using `dart migrate`.

# **Status of null safety migration of the Dart ecosystem**

Over the past year we’ve offered several preview and beta builds of sound null safety, with the goal of seeding the ecosystem with packages that support null safety. This preparation is important, as we recommend [migrating to sound null safety in order](https://dart.dev/null-safety/migration-guide#step1-wait) — you shouldn’t migrate a package or app before all its dependencies have already migrated.

We’ve published null-safe versions of hundreds of packages offered by the [Dart](https://pub.dev/packages?q=publisher%3Adart.dev&sort=popularity&null-safe=1), [Flutter](https://pub.dev/packages?q=publisher%3Aflutter.dev&sort=popularity&null-safe=1), [Firebase](https://pub.dev/packages?q=publisher%3Afirebase.google.com&sort=popularity&null-safe=1), and [Material](https://pub.dev/packages?q=publisher%3Amaterial.io&sort=popularity&null-safe=1) teams. And we’ve seen great support from the amazing Dart and Flutter ecosystems, so that pub.dev now has more than a thousand packages supporting null safety. Importantly, the most popular packages have migrated first, so that 98% of the top-100 most popular packages, 78% of the top-250, and 57% of the top-500 already support null safety in time for today’s launch. We look forward to seeing yet more packages with null safety on pub.dev in the coming weeks. [Our analysis](https://github.com/dart-lang/sdk/wiki/Null-safety-migration-status) shows that the vast majority of packages on pub.dev are already unblocked and can [start migration](https://dart.dev/null-safety/migration-guide).

# **The benefits of fully sound null safety**

Once you’ve fully migrated, Dart’s null safety is sound. This means that Dart is 100% sure that expressions that have a non-nullable type cannot be null. When Dart analyzes your code and determines that a variable is non-nullable, that variable is *always* non-nullable. Dart shares sound null safety with Swift, but not very many other programming languages.

The soundness of Dart’s null safety has another welcome implication: it means your programs can be smaller and faster. Because Dart is sure that non-nullable variables are never null, [Dart can optimize](https://medium.com/dartlang/dart-and-the-performance-benefits-of-sound-types-6ceedd5b6cdc). For example, the Dart ahead-of-time (AOT) compiler can produce smaller and faster native code, because it doesn’t need to add checks for nulls when it knows that a variable isn’t null.

# **Dart FFI for integrating Dart with C libraries**

Dart FFI enables you to leverage existing code in C libraries, both for better portability and for integrating with highly tuned C code for performance critical tasks. As of Dart 2.12, [Dart FFI](https://dart.dev/guides/libraries/c-interop) is out of the *beta* stage and is now considered stable and ready for production use. We’ve also added some new features, including nested structs and passing structs by value.

# **Passing structs by value**

Structs can be passed both by reference and by value in C code. FFI previously only supported passing by reference, but as of Dart 2.12, you can pass structs by value. Here’s a small example of two C functions that pass both by reference and by value:

```
struct Link {
  double value;
  Link* next;
};void MoveByReference(Link* link) {
  link->value = link->value + 10.0;
}Coord MoveByValue(Link link) {
  link.value = link.value + 10.0;
  return link;
}
```

# **Nested structs**

C APIs often use nested structs — structs that themselves contain structs, such as this example:

```
struct Wheel {
  int spokes;
};struct Bike {
  struct Wheel front;
  struct Wheel rear;
  int buildYear;
};
```

As of Dart 2.12, nested structs are supported in FFI.

# **API changes**

As part of declaring FFI stable, and in support of the features above, we’ve made a few smaller API changes.

Creating empty structs is now disallowed (breaking change [#44622](https://github.com/dart-lang/sdk/issues/44622)) and produces a deprecation warning. You can use a new type, `Opaque`, to represent empty structs. The `dart:ffi` functions `sizeOf`, `elementAt`, and `ref` now require compile-time type arguments (breaking change [#44621](https://github.com/dart-lang/sdk/issues/44621)). Because new convenience functions in `package:ffi` have been added, no additional boilerplate around allocating and freeing memory is required for common cases:

```
// Allocate a pointer to an Utf8 array, fill it from a Dart string,
// pass it to a C function, convert the result, and free the arg.
//
// Before API change:
final pointer = allocate<Int8>(count: 10);
free(pointer);
final arg = Utf8.toUtf8('Michael');
var result = helloWorldInC(arg);
print(Utf8.fromUtf8(result);
free(arg);// After API change:
final pointer = calloc<Int8>(10);
calloc.free(pointer);
final arg = 'Michael'.toNativeUtf8();
var result = helloWorldInC(arg);
print(result.toDartString);
calloc.free(arg);
```

# **Automatically generating FFI bindings**

For large API surfaces it can be very time consuming to write the Dart bindings that integrate with the C code. To reduce this burden, we’ve built a binding generator for automatically creating FFI wrappers from C header files. We invite you to try it out: `[package:ffigen](https://pub.dev/packages/ffigen)`.

# **FFI roadmap**

With the core FFI platform completed, we’re turning our focus to extending the FFI feature set with features that layer on top of the core platform. Some of the features we’re investigating include:

- ABI-specific data types like int, long, size_t ([#36140](https://github.com/dart-lang/sdk/issues/36140))
- Inline arrays in structs ([#35763](https://github.com/dart-lang/sdk/issues/35763))
- Packed structs ([#38158](https://github.com/dart-lang/sdk/issues/38158))
- Union types ([#38491](https://github.com/dart-lang/sdk/issues/38491))
- Exposing finalizers to Dart ([#35770](https://github.com/dart-lang/sdk/issues/35770); however note that you can already [use finalizers from C](https://github.com/dart-lang/sdk/issues/35770))

# **Sample uses of FFI**

We’ve seen many creative uses of Dart FFI to integrate with a range of C-based APIs. Here are a few examples:

- [open_file](https://pub.dev/packages/open_file) is a single API for opening files across multiple platforms. It uses FFI to invoke native operating system APIs on Windows, macOS, and Linux.
- [win32](https://pub.dev/packages/win32) wraps most common Win32 APIs, making it possible to call a wide range of Windows APIs directly from Dart.
- [objectbox](https://pub.dev/packages/objectbox) is a fast database backed by a C-based implementation.
- [tflite_flutter](https://pub.dev/packages/tflite_flutter) uses FFI to wrap the TensorFlow Lite API.

# **What’s next for the Dart language?**

Sound null safety is the largest change we’ve made to the Dart language in several years. Next we’re going to look at making more incremental changes to the language and platform, building on our strong foundation. Here’s a quick view into some of the things we’re experimenting with in our [language design funnel](https://github.com/dart-lang/language/projects/1):

**Type aliases** ([#65](https://github.com/dart-lang/language/issues/65)): The ability to create type aliases to non-function types. For example you could create a typedef and use it as a variable type:

```
typedef IntList = List<int>;
IntList il = [1,2,3];
```

**Triple-shift operator** ([#120](https://github.com/dart-lang/language/issues/120)): Adding a new, fully overridable `>>>` operator for doing unsigned bit-shift on integers.

**Generic metadata annotations** ([#1297](https://github.com/dart-lang/language/issues/1297)): Extending metadata annotations to also support annotations that contain type arguments.

**Static meta-programming** ([#1482](https://github.com/dart-lang/language/issues/1482)): Support for static meta-programming — Dart programs that produce new Dart source code during compilation, similar to Rust [macros](https://doc.rust-lang.org/book/ch19-06-macros.html) and Swift [function builders](https://github.com/apple/swift-evolution/blob/9992cf3c11c2d5e0ea20bee98657d93902d5b174/proposals/XXXX-function-builders.md). This feature is still in an early exploration phase, but we think it may enable use cases that today rely on code generation.

# **Dart 2.12 is available now**

Dart 2.12, with sound null safety and stable FFI, is available today in the [Dart 2.12](https://dart.dev/get-dart) and [Flutter 2.0](https://flutter.dev/docs/get-started/) SDKs. Please take a moment to review the known null safety issues [for Dart](https://dart.dev/null-safety#known-issues) and [for Flutter](https://flutter.dev/docs/null-safety#known-issues). If you find any other issues, please report them in the [Dart issue tracker](https://github.com/dart-lang/sdk/issues).

If you’ve developed packages published on [pub.dev](https://pub.dev/), please review the [migration guide](https://dart.dev/null-safety/migration-guide) today, and learn how to migrate to sound null safety. Migrating your package is likely to help unblock other packages and apps that depend on it. We’d also like to extend a big thanks to those that migrated already!

We’d love to hear about your experience with both sound null safety and FFI. Leave a comment below or tweet us [@dart_lang](https://twitter.com/dart_lang).
> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
