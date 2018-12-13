> * 原文地址：[Control Flow Integrity in the Android kernel](https://android-developers.googleblog.com/2018/10/control-flow-integrity-in-android-kernel.html)
> * 原文作者：[Android Developers Blog](https://android-developers.googleblog.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/control-flow-integrity-in-android-kernel.md](https://github.com/xitu/gold-miner/blob/master/TODO1/control-flow-integrity-in-android-kernel.md)
> * 译者：[nanjingboy](https://github.com/nanjingboy)
> * 校对者：

# Android 内核控制流完整性

_由 Android 安全研究工程师 Sami Tolvanen 发布_

Android 的安全模型由 Linux 内核强制执行，这将诱使攻击者将其视为攻击目标。我们在已发布的 Android 版本和 Android 9 上为[加强内核](https://android-developers.googleblog.com/2017/08/hardening-kernel-in-android-oreo.html)投入了大量精力，我们将继续这项工作，通过将关注点放在[基于编译器的安全缓解措施](https://android-developers.googleblog.com/2018/06/compiler-based-security-mitigations-in.html)上以防止代码重用攻击。

Google 的 Pixel 3 将是第一款在内核中实施 LLVM 前端[控制流完整性（CFI）](https://clang.llvm.org/docs/ControlFlowIntegrity.html)的设备，我们已经实现了 [Android 内核版本 4.9 和 4.14 中对 CFI 的支持](https://source.android.com/devices/tech/debug/kcfi) 。这篇文章描述了内核 CFI 的工作原理，并为开发人员在启用该功能时可能遇到的常见问题提供了解决方案。

## 防止代码重用攻击

利用内核的常用方法是使用错误来覆盖存储在内存中的函数指针，例如存储了回调函数的指针，或已被推送到堆栈的返回地址。这允许攻击者执行任意内核代码来完成利用，即使他们不能注入自己的可执行代码。这种获取代码执行能力的方法在内核中特别受欢迎，因为它使用了大量的函数指针，以及使代码注入更具挑战性的现有内存保护机制。

CFI 尝试通过添加额外的检查，来确认内核控制流停留在预先设计的版图中，以便缓解这类攻击。尽管这无法阻止攻击者利用一个已存在的 bug 获取写入权限，从而更改函数指针，但它会严格限制可被其有效调用的目标，这使得攻击者在实践中利用漏洞的过程变得更加困难。

[![](https://1.bp.blogspot.com/-SAbAK7FpTNw/W700bhOfGuI/AAAAAAAAFz4/N6PNS6LDxN0-yRl-xwWdRQW4pyqKAcRwACLcBGAs/s1600/figure_cfi_effectivenessimage1.png)](https://1.bp.blogspot.com/-SAbAK7FpTNw/W700bhOfGuI/AAAAAAAAFz4/N6PNS6LDxN0-yRl-xwWdRQW4pyqKAcRwACLcBGAs/s1600/figure_cfi_effectivenessimage1.png)

图1. 在 Android 设备内核中，LLVM 的 CFI 将 55% 的间接调用限制为最多 5 个可能的目标，80% 限制为最多 20 个目标。

## 通过链接时优化（LTO）获得完整的程序可见性

为了确定每个间接分支的所有有效调用目标，编译器需要立即查看所有内核代码。传统上，编译器一次处理单个编译单元（源代文件），并将目标文件合并到链接器。LLVM 的 CFI 要求使用 LTO，其编译器为所有 C 编译单元生成特定于 LLVM 的 bitcode，并且 LTO 感知链接器使用 LLVM 后端来组合 bitcode，并将其编译为本机代码。

[![](https://3.bp.blogspot.com/-qyrtXmMXuVs/W700gB5yQOI/AAAAAAAAFz8/9Dm4v75Sl9oNEskKppbYap9AMbE7s2KWACLcBGAs/s1600/2_lto_overviewimage2.png)](https://3.bp.blogspot.com/-qyrtXmMXuVs/W700gB5yQOI/AAAAAAAAFz8/9Dm4v75Sl9oNEskKppbYap9AMbE7s2KWACLcBGAs/s1600/2_lto_overviewimage2.png)

图2. LTO 在内核中的工作原理的简单概述。所有 LLVM bitcode 在链接时被组合，优化并生成本机代码。

几十年来，Linux 一直使用 GNU 工具链来汇编，编译和链接内核。虽然我们继续将 GNU 汇编程序用于独立的汇编代码，但 LTO 要求我们切换到 LLVM 的集成汇编程序以进行内联汇编，并将 GNU gold 或 LLVM 自己的 lld 作为链接器。在巨大的软件项目上切换到未经测试的工具链会导致兼容性问题，我们已经在内核版本 [4.9](https://android-review.googlesource.com/q/topic:android-4.9-lto) 和 [4.14](https://android-review.googlesource.com/q/topic:android-4.14-lto) 的 arm64 LTO 补丁集中解决了这些问题。

除了使 CFI 成为可能，由于全局优化，LTO 还可以生成更快的代码。但额外的优化通常会导致更大的二进制尺寸，这在资源受限的设备上可能是不需要的。禁用 LTO 特定的优化（比如全局内联和循环展开）可以通过牺牲一些性能收益来减少二进制尺寸。使用 GNU gold 时，可以通过以下方式设置 LDFLAGS 来禁用上述优化：

```
LDFLAGS += -plugin-opt=-inline-threshold=0 \
           -plugin-opt=-unroll-threshold=0
```

注意，禁用单个优化的标志不是稳定 LLVM 接口的一部分，在将来的编译器版本中可能会更改。

## 在 Linux 内核中实现 CFI

[LLVM 的 CFI](https://clang.llvm.org/docs/ControlFlowIntegrity.html#indirect-function-call-checking) 实现在每个间接分支之前添加一个检查，以确认目标地址指向一个拥有有效签名的函数。这可以防止一个间接分支跳转到任意代码位置，甚至限制可以调用的函数。由于 C 编译器没有对间接分支强制执行类似限制，函数类型声明不匹配导致了几个 CFI 违规，即使在我们在内核的 CFI 补丁集中解决的内核 [4.9](https://android-review.googlesource.com/q/topic:android-4.9-cfi) 和 [4.14](https://android-review.googlesource.com/q/topic:android-4.14-cfi) 中也是如此。

内核模块为 CFI 添加了另一个复杂功能，因为它们在运行时加载，并且可以独立于内核的其它部分进行编译。为了支持可加载模块，我们在内核中实现了 LLVM 的 [cross-DSO CFI](https://clang.llvm.org/docs/ControlFlowIntegrity.html#shared-library-support) 支持，包括用来加速跨模块查找的 CFI 影子。在使用 cross-DSO 支持进行编译时，每个内核模块都会包含有关有效本地分支目标的信息，内核根据目标地址和模块的内存布局从正确的模块中查找信息。

[![](https://2.bp.blogspot.com/-Iee5TBAz8Yo/W700nNjYZkI/AAAAAAAAF0A/oPsRJJhs2qMb-jNv4RGd4a5K3h8W7B9ygCLcBGAs/s1600/3_cfi_checkimage3.png)](https://2.bp.blogspot.com/-Iee5TBAz8Yo/W700nNjYZkI/AAAAAAAAF0A/oPsRJJhs2qMb-jNv4RGd4a5K3h8W7B9ygCLcBGAs/s1600/3_cfi_checkimage3.png)

图3. 注入 arm64 内核的 cross-DSO CFI 检查示例。 类型信息在 X0 中传递，目标地址在 X1 中验证。

CFI 检查会给间接分支增加一些开销，但由于更积极的优化，我们的测试表明影响很小，在很多情况下整体系统性能甚至提高了 1-2%。

## 为 Android 设备启用内核 CFI

arm64 中的 CFI 需要 clang 版本 >= 5.0 并且 binutils >= 2.27。内核构建系统还假定 LLVMgold.so 插件在 LD_LIBRARY_PATH 中可用。[clang](https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/master) 和 [binutils](https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+/master) 预构建工具链二进制文件可在 AOSP 获得，也可使用上游二进制文件。

启用内核 CFI 需要开启以下内核配置选项：

```
CONFIG_LTO_CLANG=y
CONFIG_CFI_CLANG=y
```

在调试 CFI 违规或设备启动期间，使用 CONFIG_CFI_PERMISSIVE=y 可能会有所帮助。此选项将违规转换为警告而不是内核恐慌。

如前一节所述，我们在 Pixel 3 上启用 CFI 时遇到的最常见问题是由函数指针类型不匹配引起的良性违规。当内核遇到这种违规时，它会打印出一个运行时警告，其中包含失败时的调用堆栈，以及未通过 CFI 检查的目标调用。更改代码以使用正确的函数指针类型可以解决问题。虽然我们已经修复了 Android 内核中所有已知的间接分支类型不匹配的问题，但在设备特定的驱动程序中仍然可能发现类似的问题，例如。

```
CFI 失败 (目标: [<fffffff3e83d4d80>] my_target_function+0x0/0xd80):
------------[ cut here ]------------
kernel BUG at kernel/cfi.c:32!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
…
调用堆栈:
…
[<ffffff8752d00084>] handle_cfi_failure+0x20/0x28
[<ffffff8752d00268>] my_buggy_function+0x0/0x10
…
```

图4. CFI 故障引起的内核恐慌示例。

另一个潜在的缺陷是地址空间冲突，但这在驱动程序代码中应该不太常见。LLVM 的 CFI 检查仅清楚内核虚拟地址和在另一个异常级别运行或间接调用物理地址的任何代码都将导致 CFI 违规。可通过使用 __nocfi 属性禁用单个函数的 CFI 来解决这些类型的故障，甚至可以使用 Makefile 中的 $(DISABLE_CFI) 编译器标志来禁用整个文件的 CFI。

```
static int __nocfi address_space_conflict()
{
      void (*fn)(void);
 …
/* 切换分支到物理地址将使 CFI 没有 __nocfi */
 fn = (void *)__pa_symbol(function_name);
      cpu_install_idmap();
      fn();
      cpu_uninstall_idmap();
 …
}
```

图5. 修复由地址空间冲突引起 CFI 故障的示例。

最后，和许多增强功能一样，CFI 也可能因内存损坏错误而被触发，否则可能导致随后的内核崩溃。这些可能更难以调试，但内存调试工具，如 [KASAN](https://www.kernel.org/doc/html/v4.14/dev-tools/kasan.html) 在这种情况下可以提供帮助。

## 结论

我们已经在 Android 内核 4.9 和 4.14 中实现了对 LLVM 的 CFI 的支持。Google 的 Pixel 3 将是第一款提供这些保护功能的 Android 设备，我们已通过 Android 通用内核向所有设备供应商提供了该功能。如果你要发布运行 Android 9 的新 arm64 设备，我们强烈建议启用内核 CFI 以帮助防止内核漏洞。

LLVM 的 CFI 保护间接分支免受攻击者的攻击，这些攻击者设法访问存储在内核中的函数指针。这使得利用内核的常用方法更加困难。我们未来的工作还涉及到 LLVM 的 [影子调用堆栈]（https://clang.llvm.org/docs/ShadowCallStack.html）来保护函数返回地址免受类似攻击，这将在即将发布的编译器版本中提供。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
