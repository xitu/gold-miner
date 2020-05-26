> * 原文地址：[Swift Code Formatters](https://nshipster.com/swift-format)
> * 原文作者：[Mattt](https://nshipster.com/authors/mattt/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/swift-code-formatters.md](https://github.com/xitu/gold-miner/blob/master/TODO1/swift-code-formatters.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：[swants](https://github.com/swants), [fireairforce](https://github.com/fireairforce)

# Swift 代码格式化

> 我刚离开了一家时髦的咖啡馆。里面有很多 iOS 开发者，他们互相窃窃私语，讨论他们是多么得等不及苹果公司为 Swift 发布的官方风格指南和格式化程序。

在过去的几天里，社区一直在讨论 [Tony Allevato](https://github.com/allevato) 和 [Dave Abrahams](https://github.com/dabrahams) 采用官方版的 Swift 格式化工具。

数十名社区成员已经对 [提案草案](https://forums.swift.org/t/pitch-an-official-style-guide-and-formatter-for-swift/21025) 进行了权衡。与所有样式问题一样，每个人都有不同的意见。但幸运的是，来自社区的话语通常具有代表性和洞察力，其中清晰表达了各式各样的观点、用例以及关注点。

在撰写本文时，似乎很多但不是所有受访者都对官方格式化表示赞同。那些赞成给代码格式化约束的人也希望有一个工具可以自动诊断和修复不符合这些约束的代码。但是，其他一些人对这格式化的适用性和可配置性表示担忧。

在本周的 NSHipster 上，我们将讨论一下关于当前可用的 Swift 格式化程序，包括作为提案的一部分发布的 `swift-format` 工具，同时看看它们是如何进行处理的。然后我们再权衡其中的利弊。

首先，让我们从下面的一个问题开始：

## 什么是代码格式化？

我们将代码格式化定义为对代码所做的任何更改，以便在不改变其行为的情况下更容易理解代码的内容。虽然这个定义延伸到等价形式的差异（例如 `[Int]` 和 `Array <Int>`），我们暂且将这里的讨论内容限制为空格和标点符号。

与许多其他编程语言一样，Swift 在接受换行符，制表符和空格时都非常自由。大多数空格都是无关紧要的，从编译器的角度来看对代码没有任何影响。

当我们使用空格来使代码更易于理解而不改变其行为时，此时空格就作为一个 [辅助符号](https://en.wikipedia.org/wiki/Secondary_notation)。当然，主要符号是代码本身。

> 另一种辅助表示法是语法高亮，这在我们以前的 [NSHipster 文章](https://nshipster.com/swiftsyntax/) 中讨论过.

虽然你可以通过分号在一行代码中写几乎任何东西，但是在其他条件相同的情况下，使用空格与换行来对齐代码难道不是一种更易于理解并且直观的方式吗？

不幸的是，因编译器接受空格的性质而产生的歧义往往会引起程序员之间对代码的混淆和分歧：**“我到底应不应该在大括号之前添加换行符？如何分解超出编辑器宽度的语句？”**

一个公司通常会有自己的一套代码规范，但它们通常不够明确，执行力不强，而且可能已经过时。代码格式化程序的作用是自动执行一组约定，以便程序员可以抛开差异来把重心放到解决实际问题上。

## 格式化工具比较

Swift 社区从一开始就考虑过代码格式问题，代码书写规范从 Swift 诞生之初就已经存在，各种开源工具也可以通过规范来自动化格式化代码。

你可以看看以下四个工具来了解目前 Swift 代码格式化程序的状态：

项目 | 仓库链接
------- | -------
[SwiftFormat](#swiftformat) | [https://github.com/nicklockwood/SwiftFormat](https://github.com/nicklockwood/SwiftFormat)
[SwiftLint](#swiftlint) | [https://github.com/realm/SwiftLint](https://github.com/realm/SwiftLint)
[Prettier with Swift Plugin](#prettier-with-swift-plugin) | [https://github.com/prettier/prettier](https://github.com/prettier/prettier)
[swift-format（已提议）](#swift-format) | [https://github.com/google/swift/tree/format](https://github.com/google/swift/tree/format)

> 为简洁起见，本文仅讨论一些可用的 Swift 格式化工具。如果你有兴趣可以了解以下更多内容：[Swimat](https://github.com/Jintin/Swimat)，[SwiftRewriter](https://github.com/inamiy/SwiftRewriter) 和 [swiftfmt](https://github.com/kishikawakatsumi/swiftfmt)。

为了方便比较，我们设计了以下代码来评估每个工具，工具都使用它们的默认配置：

```swift
struct ShippingAddress : Codable  {
    var recipient: String
    var streetAddress : String
    var locality :String
    var region   :String;var postalCode:String
    var country:String

    init(recipient: String,        streetAddress: String,
         locality: String,region: String,postalCode: String,country:String)
    {
        self.recipient = recipient
        self.streetAddress = streetAddress
        self.locality  = locality
        self.region        = region;self.postalCode=postalCode
        guard country.count == 2, country == country.uppercased() else { fatalError("invalid country code") }
        self.country=country}}

let applePark = ShippingAddress(recipient:"Apple, Inc.", streetAddress:"1 Apple Park Way", locality:"Cupertino", region:"CA", postalCode:"95014", country:"US")
```

尽管代码格式化包含各种可能的语法和语义转换，但我们将专注于换行和缩进的问题，我们认为这是任何代码格式化程序的基础要求。

> 诚然，本文中的性能基准并不是非常严格。但是它们应该可以作为参考。我们把秒作为测量时间的单位，采用 2017 款配备 2.9 GHz Intel Core i7 处理器和 16 GB 2133 MHz LPDDR3 内存的 MacBook Pro。

### SwiftFormat

首先是 [SwiftFormat](https://github.com/nicklockwood/SwiftFormat)，它的简介是一个很有用的工具。

#### 安装

SwiftFormat 可以通过 [Homebrew](https://nshipster.com/homebrew/)，[Mint](https://github.com/yonaskolb/Mint) 以及 [CocoaPods](https://nshipster.com/CocoaPods/) 来安装。

你可以通过以下命令来安装它：

```brew
$ brew install swiftformat
```

此外，SwiftFormat 还提供了一个 [Xcode 拓展](https://github.com/nicklockwood/SwiftFormat/tree/master/EditorExtension)，你可以通过在 Xcode 里使用它进行格式化。或者如果你是 VSCode 用户，你可以使用 [此插件](https://marketplace.visualstudio.com/items?itemName=vknabel.vscode-swiftformat)。

#### 使用

`swiftformat` 命令会把在指定文件和目录路径中找到的所有 Swift 文件进行格式化。

```bash
$ swiftformat Example.swift
```

SwiftFormat 有很多规则，你可以通过命令行选项或使用配置文件单独配置。

#### 样例输出

使用默认配置运行 `swiftformat` 后，你会得到以下输出：

```swift
// swiftformat version 0.39.5
struct ShippingAddress: Codable {
    var recipient: String
    var streetAddress: String
    var locality: String
    var region: String; var postalCode: String
    var country: String

    init(recipient: String, streetAddress: String,
         locality: String, region: String, postalCode: String, country: String) {
        self.recipient = recipient
        self.streetAddress = streetAddress
        self.locality = locality
        self.region = region; self.postalCode = postalCode
        guard country.count == 2, country == country.uppercased() else { fatalError("invalid country code") }
        self.country = country
    }
}

let applePark = ShippingAddress(recipient: "Apple, Inc.", streetAddress: "1 Apple Park Way", locality: "Cupertino", region: "CA", postalCode: "95014", country: "US")
```

正如你所见，格式化明显改进了原始版本。每一行都根据其范围缩进，标点符号间的声明都有一致的间距。属性声明中的分号和初始化参数中的换行都被保留。但是，大括号没有像预期的那样被移动到单独一行，[Nick](https://github.com/nicklockwood) 在 [0.39.5](https://twitter.com/nicklockwood/status/1103595525792845825) 修复了它。

#### 性能

SwiftFormat 在本文中测试工具中始终是最快的，它能在几毫秒内完成处理。

```bash
$ time swiftformat Example.swift
        0.03 real         0.01 user         0.01 sys
```

### SwiftLint

接下来是 [SwiftLint](https://github.com/realm/SwiftLint)，它是 Swift 开源社区的支柱。其中包含了超过 100 个规则，SwiftLint 可以对你的代码执行各种各样的检查，从将 `AnyObject` 优于 `class`（仅用于类的协议）到所谓的“尤达条件式”，其中规定变量应放在比较运算符的左侧（即 `if n == 42` 而非 `if 42 == n`）。

顾名思义，SwiftLint 主要不是代码格式化程序，它确实是一种识别滥用惯例和误用 API 的诊断工具。正是由于具备自动校正功能，它常常被用于格式化代码。

#### 安装

你可以通过以下命令使用 Homebrew 来安装它：

```brew
$ brew install swiftlint
```

或者你也可以通过 [CocoaPods](https://nshipster.com/CocoaPods/)，[Mint](https://github.com/yonaskolb/Mint) 或者 [独立 pkg 安装包](https://github.com/realm/SwiftLint/releases/tag/0.31.0) 来安装。

#### 使用

要用 SwiftLint 来进行代码格式化，请运行 `autocorrect` 子命令，`--format` 参数为需要执行的文件或目录。

```bash
$ swiftlint autocorrect --format --path Example.swift
```

#### 样例输出

运行上述命令，你将得到以下输出：

```swift
// swiftlint version 0.31.0
struct ShippingAddress: Codable {
    var recipient: String
    var streetAddress: String
    var locality: String
    var region: String;var postalCode: String
    var country: String

    init(recipient: String, streetAddress: String,
         locality: String, region: String, postalCode: String, country: String) {
        self.recipient = recipient
        self.streetAddress = streetAddress
        self.locality  = locality
        self.region        = region;self.postalCode=postalCode
        guard country.count == 2, country == country.uppercased() else { fatalError("invalid country code") }
        self.country=country}}

let applePark = ShippingAddress(recipient: "Apple, Inc.", streetAddress: "1 Apple Park Way", locality: "Cupertino", region: "CA", postalCode: "95014", country: "US")
```

SwiftLint 可以清除最糟糕的缩进和行内间距问题，同时保留其他无关的空格。值得注意的是，格式化不是 SwiftLint 的主要作用，一般情况下，它只是附带提供可操作的代码诊断。从 **“首先，没有任何副作用”** 的角度来看，你不必在这里抱怨它处理的结果。

#### 性能

SwiftLint 检查的所有内容非常高效，在我们的示例中它只需几分之一秒即可完成。

```bash
$ time swiftlint autocorrect --quiet --format --path Example.swift
        0.11 real         0.05 user         0.02 sys
```

### Swift Plugin 美化

如果你没有使用过 JavaScript（如 [上周文章](https://nshipster.com/swift-format/javascriptcore/) 中所述），这可能是你听说过的第一篇 [Prettier](https://github.com/prettier/prettier) 相关的文章。反之，如果你沉浸在 ES6，React 和 WebPack 的世界中，你几乎肯定会特别依赖它。

Prettier 在代码格式化程序中是独一无二的，因为它体现了代码的美学，用换行来分隔代码，就好像写诗一样。

多亏了一个在开发中的 [插件架构](https://prettier.io/docs/en/plugins.html)，你可以在其他语言上使用它，其中 [包括了 Swift](https://github.com/prettier/plugin-swift)。

> Swift 的 Prettier 插件非常重要，但是当它遇到一个没有规则的语法标记时会崩溃（比如 `EnumDecl` 😩）。然而，正如你将在下面看到的那样，到目前为止它的功能还是很强大以至于我们不能忽视它，所以把它放在本文格式化工具 PK 中是值得的。

#### 安装

要使用 Prettier 及其 Swift 插件，你将涉及到 Node。虽然有很多方法可以安装它，但我们还是最喜欢 [Yarn](https://yarnpkg.com/en/) 😻。

```brew
$ brew install yarn
$ yarn global add prettier prettier/plugin-swift
```

#### 使用

现在环境变量 `$PATH` 里已经可以访问 `prettier` 命令行工具，你可以传入文件或路径来运行它。

```bash
$ prettier Example.swift
```

#### 样例输出

以下是在我们的前面的例子中使用 Prettier 运行最新版本的 Swift 插件得到的输出：

```swift
// prettier version 1.16.4
// prettier/plugin-swift version 0.0.0 (bdf8726)
struct ShippingAddress: Codable {
    var recipient: String
    var streetAddress: String
    var locality: String
    var region: String
    var postalCode: String
    var country: String

    init(
        recipient: String,
        streetAddress: String,
        locality: String,
        region: String,
        postalCode: String,
        country: String
    ) {
        self.recipient = recipient
        self.streetAddress = streetAddress
        self.locality = locality
        self.region = region;
        self.postalCode = postalCode
        guard country.count == 2, country == country.uppercased() else {
            fatalError("invalid country code")
        }
        self.country = country
    }
}

let applePark = ShippingAddress(
    recipient: "Apple, Inc.",
    streetAddress: "1 Apple Park Way",
    locality: "Cupertino",
    region: "CA",
    postalCode: "95014",
    country: "US"
)
```

Prettier 将自己称为 “一个自以为是的代码格式化程序”。实际上，它的配置方式不多，只有两个选项：“常规代码” 或 “更漂亮的代码”。

现在，你可能会面对很多垂直的对齐，但你不得不承认这段代码看起来确实很棒。所有的语句都有均匀间隔、缩进以及对齐，很难相信这是自动实现的。

当然，我们之前的警告仍然适用：这仍然在开发中，并不适合生产环境使用，而且它还有一些性能问题。

#### 性能

说到底，Prettier 比本文讨论的其他工具都慢一到两个数量级。

```bash
$ time prettier Example.swift
    1.14 real         0.56 user         0.38 sys
```

目前还不清楚这到底是语言障碍还是优化不良的结果，Prettier 慢得足以带来很大的问题。

目前，我们建议仅将 Prettier 用于一次性格式化任务，例如编写文章和书籍的代码。

### swift-format

在了解可用于 Swift 格式化程序的现状后，我们现在有了一个合理的标准来评估 Tony Allevato 和 Dave Abrahams 提出的 `swift-format` 工具。

#### 安装

`swift-format` 的代码目前托管在 [Google fork 的 Swift 的 `format` 分支](https://github.com/google/swift/tree/format) 上。你可以通过运行以下命令来下载并且从源代码编译它：

```bash
$ git clone https://github.com/google/swift.git swift-format
$ cd swift-format
$ git submodule update --init
$ swift
```

为了让你方便使用，我们提供了一个自制的公式，该公式来自 [我们自己 Google 仓库上的 fork](https://github.com/NSHipster/swift-format)，你可以通过下面的命令来安装：

```brew
$ brew install nshipster/formulae/swift-format
```

#### 使用

运行 `swift-format` 命令，传入要格式化的 Swift 文件或目录。

```bash
$ swift-format Example.swift
```

`swift-format` 命令还采用了 `--configuration` 选项，该参数需要传入一个 JSON 文件。目前，定制 `swift-format` 行为的最简单方法就是将默认配置转储到文件里。

```bash
$ swift-format -m dump-configuration .swift-format.json
```

创建如下的 JSON 文件，在运行上述命令时传入：

```JSON
{
  "blankLineBetweenMembers": {
    "ignoreSingleLineProperties": true
  },
  "indentation": {
    "spaces": 2
  },
  "lineLength": 100,
  "maximumBlankLines": 1,
  "respectsExistingLineBreaks": true,
  "tabWidth": 8,
  "version": 1
}
```

在配置完之后，你应该这样使用：

```bash
$ swift-format Example.swift --configuration .swift-format.json
```

#### 样例输出

使用其默认配置，这里是 `swift-format` 格式化后的输出：

```swift
// swift-format version 0.0.1
struct ShippingAddress: Codable {
  var recipient: String
  var streetAddress: String
  var locality: String
  var region   :String;
  var postalCode: String
  var country: String

  init(
    recipient: String, streetAddress: String,
    locality: String, region: String, postalCode: String, country: String
  )
  {
    self.recipient = recipient
    self.streetAddress = streetAddress
    self.locality = locality
    self.region = region
    self.postalCode = postalCode
    guard country.count == 2, country == country.uppercased() else {
      fatalError("invalid country code")
    }
    self.country = country
  }
}

let applePark = ShippingAddress(
  recipient: "Apple, Inc.", streetAddress: "1 Apple Park Way", locality: "Cupertino", region: "CA",
  postalCode: "95014", country: "US")
```

随着 `0.0.1` 版本的发布，这好像很有希望！我们可以在没有原始分号的情况下实现，也不用太关心 `region` 属性的冒号位置，但总的来说，这是无可非议的，它正是你想要的官方代码格式化工具。

#### 性能

在性能方面，`swift-format` 目前处于中间位置，不快也不慢。

```bash
$ time swift-format Example.swift
        0.51 real         0.20 user         0.27 sys
```

根据我们有限的初步调查，`swift-format` 似乎提供了一套合理的格式约定。希望未来它能创建出更加生动的例子来帮助我们理解其中的格式化规则。

无论如何，看到提案如何发展以及围绕这些问题展开讨论都将是一件很有趣的事。

---

NSMutableHipster

如果你有其他问题，欢迎给我们提 [Issues](https://github.com/NSHipster/articles/issues) 和 [pull requests](https://github.com/NSHipster/articles/blob/master/2019-03-04-swift-format.md)。

**这篇文章使用 Swift 5.0.**。你可以在 [状态页面](https://nshipster.com/status/) 上查找所有文章的状态信息。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
