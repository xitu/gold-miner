> * 原文地址：[Deno 1.8 Release Notes](https://deno.land/posts/v1.8)
> * 原文作者：[Deno官方](https://deno.land/posts/v1.8)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/6-css-properties-nobody-is-talking-about.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Deno-1-8-Release-Notes.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[zenblo](https://github.com/zenblo)

# Deno 1.8 发行公告

今天我们正式地发布了 Deno 1.8.0 版本。我们在这个版本中添加了大量的新功能，也同时优化了它的稳定性：

- **[对 WebGPU API 的实验性功能支持](https://deno.land/posts/v1.8#experimental-support-for-the-webgpu-api)**：提供在 Deno 中开箱即用的使用 GPU 去加速机器学习的路径。
- **[内置国际化 API 的启用](https://deno.land/posts/v1.8#icu-support)**：所有的 JS `Intl` API 现在都支持开箱即用。
- **[改进了的覆盖率工具](https://deno.land/posts/v1.8#revamped-coverage-tooling-codedeno-coveragecode)**：覆盖率工具现在支持输出 `lcov` 格式的报告。
- **[导入映射功能现已稳定](https://deno.land/posts/v1.8#import-maps-are-now-stable)**：我们已经发布了 Web 兼容的依赖的重写。

- **[对引入私有模块的支持](https://deno.land/posts/v1.8#auth-token-support-for-fetching-modules)**：通过使用验证 token 来引入你的私有服务器上的远程模块。

如果你已经安装了 Deno 那么你可以直接通过运行 `deno upgrade` 命令更新到 1.8 版本，而如果你是第一次使用，那么你可以用下面的方法去获取：

```shell
# 使用 Shell (macOS 和 Linux):
curl -fsSL https://deno.land/x/install/install.sh | sh

# 使用 PowerShell (Windows):
iwr https://deno.land/x/install/install.ps1 -useb | iex

# 使用 Homebrew (macOS):
brew install deno

# 使用 Scoop (Windows):
scoop install deno

# Using Chocolatey (Windows):
choco install deno
```

## 新功能和变化

### 对 WebGPU API 的实验性功能支持

WebGPU API 为开发者们提供了一种更低级，高性能，跨体系结构的方式，通过 JavaScript 去编写运行在 GPU 硬件上的程序。它是 WebGL 在 Web 应用程序上的有效替代品，虽然尚未确定最终规范，但是目前 Firefox，Chromium 和 Safari 都提供了支持，同样我们 Deno 也对其提供了支持。

通过此 API，我们可以直接从 Deno 内部访问 GPU 的渲染和通用 GPU 计算。一旦我们完成了移植且功能稳定取消标记后，这个方式将会让我们可以在 Web 端、服务器和开发者的设备上实现可移植地去访问 GPU 资源。

GPU 能够帮助开发者实现高度并行某些数值算法，而不是局限于图形渲染和游戏。在机器学习中有效使用 GPU，使得运行更复杂的神经网络 —— 也就是我们所说的深度学习中能更有效地使用 GPU，成为可能。计算机视觉、翻译、图像生成、强化学习等方面的飞速发展都源于 GPU 硬件的有效利用。

如今，大多数神经网络都是用 Python 编写的，而计算则转移到了 GPU 上。但我们相信，如果存在适当的基础架构，JavaScript（而不是 Python）也可以用作表达数学思想的理想语言。在 Deno 中我们提供的现成的 WebGPU 支持就是我们朝这个方向迈出的一步。我们的目标是通过 GPU 加速在 Deno 上运行 [Tensorflow.js](https://www.tensorflow.org/js)。我们预计这将在未来几周或几个月内实现。

这是一个基本示例，演示了如何访问连接的 GPU 设备以及读取名称和支持的功能：

```js
// 使用 `deno run --unstable https://deno.land/posts/v1.8/webgpu_discover.ts` 运行
// 尝试去从 UserAgent 中获取一个适配器
const adapter = await navigator.gpu.requestAdapter();
if (adapter) {
    // 打印一些有关适配器的基础的信息
    console.log(`找到了适配器：${adapter.name}`);
    const features = [...adapter.features.values()];
    console.log(`支持的功能：${features.join(", ")}`);
} else {
    console.error("没找到适配器");
}
```

以下是一个小示例，演示了 GPU 渲染着色器在一个简单的绿色背景上渲染红色三角形：

```shell
$ deno run --unstable --allow-write=output.png https://raw.githubusercontent.com/crowlKats/webgpu-examples/f3b979f57fd471b11a28c5b0c91d0447221ba77b/hello-triangle/mod.ts
```

![一个简单的绿色背景的红色三角形](https://deno.land/posts/v1.8/webgpu_triangle.png)

[需要注意的是在输出 PNG 上使用了 WebAssembly](https://github.com/crowlKats/webgpu-examples/blob/f3b979f57fd471b11a28c5b0c91d0447221ba77b/utils.ts#L77-L106)。有关更多的信息请访问这一个 GitHub 仓库：[crowlKats/webgpu-examples](https://github.com/crowlKats/webgpu-examples)。

最终的 PR 拉取请求有 15.5k 行的代码，我们花费了整整 5 个月的时间进行审查以及并入仓库。我们十分感谢领导 Deno 中引入 WebGPU 项目的 [crowlKats](https://github.com/crowlKats)。我们同样感谢所有对 [wgpu](https://github.com/gfx-rs/wgpu) 和 gfx-rs 这些加固了 Deno WebGPU 项目的贡献者。我们同样向 [kvark](https://github.com/kvark) 为他所在 WebGPu 规范中作出的贡献以及 wgpu 和 gfx-rs 项目中的开发的引领（为我们做出了 WebGPU 的模范）致以衷心的感谢。

### ICU 支持

ICU 支持一直是 Deno 版本库中第二大需求的功能。我们很高兴地宣布，Deno v1.8 已经提供了完整的 ICU 支持。

所有依赖于 ICU 的 JavaScript API 现在都能对应浏览器的 API 了。

尝试在 REPL 中使用一下：

```shell
$ deno
Deno 1.8.0
exit using ctrl+d or close()
> const d = new Date(Date.UTC(2020, 5, 26, 7, 0, 0));
undefined
> d.toLocaleString("de-DE", {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
});
"Freitag, 26. Juni 2020"
```

### 改进了的覆盖率工具 `deno coverage`

新的 Deno 版本的发行扩大了我们的代码覆盖范围基础架构，添加了一些强大的新功能。此版本的主要变化是代码覆盖的处理现在分为覆盖集合和覆盖报告。

以前，代码覆盖范围的收集和报告都将在单个子命令中进行，只需在启动 `deno test` 时指定 `--coverage` 标志即可。而现在，`deno test` 的` --coverage` 标志带来了一个参数，用来存储收集的配置文件的目录的路径，即代码覆盖的集合。在第二步中，我们现在会去调用 `deno coverage`，其路径指向存储代码覆盖配置文件的目录。此子命令可以直接在控制台上以美观的文本输出形式返回报告，也可以输出 [lcov](https://manpages.debian.org/testing/lcov/lcov.1.en.html) 文件（`--lcov` 标志），用于诸如 `genhtml`，coveralls.io 或 codecov.io 之类的工具。

最近几天，我们一直在
 [`deno_std`](https://github.com/denoland/deno_std) 上对该功能进行测试。对于每次的提交，我们都将覆盖率报告上传到 codecov.io，然后我们就可以在 [codecov.io](https://codecov.io/gh/denoland/deno_std) 中查看这些内容。添加这些代码也很简单，我们的 GitHub Actions 工作流配置中仅有 10 行的更改：

```yml
       - name: Run tests
       - run: deno test --unstable --allow-all
       +        run: deno test --coverage=./cov --unstable --allow-all
         +
       +      - name: Generate lcov
       +        run: deno coverage --unstable --lcov ./cov > cov.lcov
         +
       +      - name: Upload coverage
       +        uses: codecov/codecov-action@v1
       +        with:
       +          name: ${{ matrix.os }}-${{ matrix.deno }}
       +          files: cov.lcov
```

要查看使用 coveralls.io 的例子，看看这个仓库即可：[https://github.com/lucacasonato/deno_s3](https://github.com/lucacasonato/deno_s3)。

### 导入映射功能现已稳定

[导入映射](https://github.com/WICG/import-maps) 功能在 Chrome 89 版本是稳定的，之后，我们已经更新功能实现，以符合最新版本的规范，现在也被认为是稳定的。这意味着在使用 `--import-map` 时候我们不必再提供 `--unstable` 标志。

```shell
$ deno run --import-map=./import_map.json ./mod.ts
```

同时，`--import-map` 标记现在不仅支持本地路径，也支持其他超链接，让我们能够从远程服务器中导入映射。

```shell
$ deno run --import-map=https://example.com/import_map.json ./mod.ts
```

导入映射功能允许开发者使用所谓的“裸露”说明符来代替相对或绝对的文件路径或者是 HTTP URL 路径。

```js
// Deno 默认不支持这样的说明符，
// 但通过提供一个映射，我们就可以重新映射
// 这些空白的说明符去其他的 URL
import * as http from "std/http";
```

```json
{
    "imports": {
        "std/http": "https://deno.land/std@0.85.0/http/mod.ts"
    }
}
```

开发者应该注意，导入映射是不能组合的：这意味着你只能提供一个导入映射到 `deno run` 或 `deno test`。正因为如此，依赖库的作者应该仍然使用常规的、非裸露的说明符（相对或绝对的文件路径或者是 http URL 路径），否则依赖库的使用者将需要手动将依赖库（以及库的依赖）裸露说明符添加到他们的导入映射中。

导入映射的一个更有用的功能是能够将常规说明符重新映射为完全不同的说明符。例如如果我们的模块图中嵌套了一些支离破碎的依赖关系，我们可以在将其固定到上游之前替换它为固定版本。或者如果我们使用将哈希添加到模块文件名的构建过程，我们可以在源代码中直接引用该文件而非哈希值，并且只需要在运行时使用一个导入的映射去重新映射说明符。

有关更多示例和详细说明，请参考[规范](https://github.com/WICG/import-maps#the-import-map)。

### 支持使用 Auth Token 获取模块

并非所有代码都可以在公共互联网上公开获得。以前，Deno 无法从需要身份验证的服务器上下载代码。在此版本中，我们增加了用户指定第一次提取模块时使用的每个域身份验证令牌的功能。

为此，Deno CLI 将查找名为 `DENO_AUTH_TOKENS` 的环境变量，以确定在请求远程模块时应考虑使用的身份验证令牌。环境变量的值采用以分号（`;`）分隔的 n 个令牌的格式，其中每个令牌的格式为 `{token}@{hostname[:port]}`。

例如，单个令牌看起来像这样：

```text
DENO_AUTH_TOKENS=a1b2c3d4e5f6@deno.land
```

多个令牌看起来像这样：

```text
DENO_AUTH_TOKENS=a1b2c3d4e5f6@deno.land; f1e2d3c4b5a6@example.com：8080
```

当 Deno 提取主机名与远程模块的主机名匹配的远程模块时，Deno 会将请求的 `Authorization` 标头设置为 `Bearer {token}` 的值。这允许远程服务器明白这个请求是一个被授权的请求，与一个特定的被授权的用户相关联，以提供对服务器上特定资源和模块的访问权限。

有关配置我们的环境以从私有 GitHub 存储库获取数据的更详细的使用指南和说明，请参阅[相关手册条目](https://deno.land/manual/linking_to_external_code/private)。

## **`Deno.test` 的 Exit 清理程序**

`Deno.test` API 已经拥有了[两个清理程序](https://deno.land/manual@v1.7.5/testing#resource-and-async-op-sanitizers)帮助我们确保我们的代码没有泄露运营机密或是资源，例如，所有打开的文件或网络请求都会在测试代码结束前被关闭，并且不会有更多的系统调用出现。

Deno 1.8 版本添加了一个新的清理程序，保证测试的代码不会调用 `Deno.exit()`。流氓的 exit 声明可能表示错误的阳性测试结果，并且经常被滥用或忘记删除。

这个清理程序默认为所有的测试启用，但是可以在测试定义中设置 `sanitizeExit` 布尔值为 `false` 以关闭：

```js
Deno.test({
    name: "false success",
    fn() {
        Deno.exit(0);
    },
    sanitizeExit: false,
});
// 这个测试不会被运行：
Deno.test({
    name: "failing test",
    fn() {
        throw new Error("this test fails");
    },
});
```

你可以试着自己去运行这段代码：`deno test https://deno.land/posts/v1.8/exit_sanitizer.ts`。

### `Deno.permissions` API 现在进入稳定状态

Deno 的安全模型是基于权限的。当前，只有在启动应用程序时才能授予这些权限。这在大多数情况下都适用，但是在某些情况下，在运行时请求或撤消权限会带来更好的用户体验。

在 Deno 1.8 中，我们有了一个稳定的 API 可以去 `query`、`request` 和 `revoke` 权限。这些 API 包含在 `Deno.permissions` 对象中。这是一个示例：

```js
function homedir() {
    try {
        console.log(`你的目录是：${Deno.env.get("HOME")}`);
    } catch (err) {
        console.log(`无法获取目录：${err}`);
    }
}

// 尝试获取主目录（此操作将失败，因为还没有 env 的权限）。
homedir();
const {granted} = await Deno.permissions.request({name: "env"});
if (granted) {
    console.log(`你被授予了 "env" 权限`);
} else {
    console.log(`你没有被授予 "env" 权限`);
}
// 尝试获取主目录（如果用户授权，则应成功）
homedir();
await Deno.permissions.revoke({name: "env"});
// 尝试获取主目录（此操作将失败，因为权限被撤销了）
homedir();
```

你可以自己尝试运行一下这段脚本：`deno run https://deno.land/posts/v1.8/permission_api.ts`。

### `Deno.link` 和 `Deno.symlink` API 现在进入稳定状态

这个发行还提供了有关符号链接的四个 API 的稳定版本：

- `Deno.link`
- `Deno.linkSync`
- `Deno.symlink`
- `Deno.symlinkSync`

在这些 API 的稳定化之前，他们通过了一项安全评估，并且我们需要特定的权限去使用它。

`Deno.link` 和 `Deno.linkSync` 需要对源文件和目标路径的读写权限。

`Deno.symlink` 和 `Deno.symlinkSync` 需要目标路径的写权限。

### 更细致的 `Deno.metrics`

随着 Deno 变得更加稳定，对于开发者来说，使用简便的方法来检测其应用程序变得越来越重要。这从最低级别（在运行时本身）开始。在 Deno 中，JS 中的所有特权操作（转到 Rust 的那些操作）都是通过 JS 和 Rust 之间的单个中心接口来完成的。我们称通过该接口的请求为 `ops`。例如，调用 `Deno.open` 会在特权端调用`op_open_async` 操作，返回打开文件的资源 ID（或错误）。

两年多以前，在 2018 年 10 月 11 日，我们提供了一种查看 Rust 和 JS 之间所有操作的指标的方法：`Deno.metrics`。该 API 当前会暴露出已启动和已完成的同步和异步操作的数量，以及通过操作接口发送的数据量。到目前为止，这仅限于所有不同操作的组合数据。我们没有办法找出**某个**操作被调用的次数 —— 只能获取所有操作的数据。

当使用 `--unstable` 运行这段代码时候，此版本会向 `Deno.metrics` 中添加一个名为 `ops` 的新字段。此字段会包含每个操作的信息，涉及 API 的调用频率以及通过 API 传输的数据量。这允许对运行时进行更精细的检测。

这是示例：

```shell
$ deno --unstable
Deno 1.8.0
exit using ctrl+d or close()
> Deno.metrics().ops["op_open_async"]
undefined
> await Deno.open("./README.md")
File {}
> Deno.metrics().ops["op_open_async"]
{
  opsDispatched: 1,
  opsDispatchedSync: 0,
  opsDispatchedAsync: 1,
  opsDispatchedAsyncUnref: 0,
  opsCompleted: 1,
  opsCompletedSync: 0,
  opsCompletedAsync: 1,
  opsCompletedAsyncUnref: 0,
  bytesSentControl: 54,
  bytesSentData: 0,
  bytesReceived: 22
}
```

在即将发布的版本中，`Deno.test` 中的异步操作清理工具将使用此新信息，以在测试完成之前未完成异步操作时提供更多可操作的错误。我们已经看到此功能用于检测应用程序并将数据通过管道传输到监视软件中：

![一个网站表格显示着 `Deno.metrics` 的输出](https://deno.land/posts/v1.8/per_op_metrics.png)

### `deno fmt` 对 JSON 的支持

`deno fmt` 现在可以格式化 `.json` 和 `.jsonc` 文件，就像是 JS 或 TS 文件一样，格式化工具会同时将 Markdown 文件中的 JSON 和 JSONC 代码格式化掉。

## `Deno.emit` 对 IIFE 捆绑包的支持

内置捆绑程序现在可以发出立即调用函数表达式（IIFE）格式的捆绑包。

默认情况下，输出格式仍然是 `esm`，但是用户可以通过将 `EmitOptions.bundle` 选项设置为 `iife` 来更改它：

```js
const {files} = await Deno.emit("/a.ts", {
    bundle: "iife",
    sources: {
        "/a.ts": `import { b } from "./b.ts";
        console.log(b);`,
        "/b.ts": `export const b = "b";`,
    },
});
console.log(files["deno:///bundle.js"]);

```

结果是：

```js
(function () {
    const b = "b";
    console.log(b);
    return {};
})();

```

你可以自己运行下这个：`deno run --unstable https://deno.land/posts/v1.8/emit_iife.ts`。

这对于为不支持ESM的较旧浏览器创建捆绑包特别有用。

### `deno lsp` 现在进入了稳定状态

在过去的几个月中，我们一直在努力更新着旧的 VS Code 编辑器集成（Deno 扩展）。旧的扩展名仅适用于 VS Code，而且解析的类型并不总是与 Deno CLI 中的类型匹配。

在 Deno 1.6 中，我们在 canary 版本中发布了 `deno lsp` —— Deno 的内置语言服务器。LSP 使我们能够从单个代码库向所有支持 LSP 的编辑器提供编辑器集成。内置的语言服务器与 Deno CLI 的其余部分基于相同的体系结构，也因此，它提供的 TypeScript 诊断与 CLI 的其余部分相同。

两周前，在 Deno 1.7.5 中，我们稳定了 `deno lsp` 并切换了我们的 [VS Code 扩展名](https://marketplace.visualstudio.com/items?itemName=denoland.vscode-deno)来使用它。到目前为止，我们已经收到了很好的反馈，并将努力解决所有报告的问题。如果你在扩展程序中遇到问题，请在我们的问题跟踪器中报告该问题，毕竟我们无法解决我们不知道的问题。

除了官方的 VS Code 集成以外，我们还创建了更多基于 `deno lsp` 的社区集成：

- 带有 CoC 的 Vim：[https://github.com/fannheyward/coc-deno](https://github.com/fannheyward/coc-deno)
- Neovim：[https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#denols](https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#denols)
- Emacs：[https://emacs-lsp.github.io/lsp-mode/page/lsp-deno/](https://emacs-lsp.github.io/lsp-mode/page/lsp-deno/)
- Kakoune：[https://deno.land/manual/getting_started/setup_your_environment#example-for-kakoune](https://deno.land/manual/getting_started/setup_your_environment#example-for-kakoune)
- Sublime：[https://deno.land/manual/getting_started/setup_your_environment#example-for-sublime-text](https://deno.land/manual/getting_started/setup_your_environment#example-for-sublime-text)

### TypeScript 4.2

Deno 1.8 捆绑了 TypeScript 的最新稳定版本。

有关 Typescript 4.2 中新功能的更多信息，请参见 [TypeScript 4.2](https://devblogs.microsoft.com/typescript/announcing-typescript-4-2/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
