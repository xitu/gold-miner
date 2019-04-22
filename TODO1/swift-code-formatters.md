> * 原文地址：[Swift Code Formatters](https://nshipster.com/swift-format)
> * 原文作者：[Mattt](https://nshipster.com/authors/mattt/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/swift-code-formatters.md](https://github.com/xitu/gold-miner/blob/master/TODO1/swift-code-formatters.md)
> * 译者：
> * 校对者：

# Swift Code Formatters

> I just left a hipster coffee shop. It was packed with iOS devs, whispering amongst each other about how they can’t wait for Apple to release an official style guide and formatter for Swift.

Over the past few days, the community has been buzzing about the latest pitch from [Tony Allevato](https://github.com/allevato) and [Dave Abrahams](https://github.com/dabrahams) to adopt an official style guide and formatting tool for the Swift language.

[Dozens of community members have already weighed in on the draft proposal](https://forums.swift.org/t/pitch-an-official-style-guide-and-formatter-for-swift/21025). As with all matters of style, opinions are strong, and everybody has one. Fortunately, the discourse from the community has been generally constructive and insightful, articulating a diversity of viewpoints, use cases, and concerns.

At the time of writing, it appears that a plurality, if not an outright majority of respondents are +1 (or more) for some degree of official guidance on formatting conventions. And those in favor of a sanctioned style guide would also like for there to be a tool that automatically diagnoses and fixes violations of these guidelines. However, others have expressed concerns about the extent to which these guidelines are applicable and configurable.

This week on NSHipster, we’ll take a look at the current field of Swift formatters available today — including the `swift-format` tool released as part of the proposal — and see how they all stack up. From there, we’ll take a step back and try to put everything in perspective.

But first, let’s start with a question:

## What is Code Formatting?

For our purposes, we’ll define code formatting as any change made to code that makes it easier to understand without changing its behavior. Although this definition extends to differences in equivalent forms, (e.g. `[Int]` vs. `Array<Int>`), we’ll limit our discussion here to whitespace and punctuation.

Swift, like many other programming languages, is quite liberal in its acceptance of newlines, tabs, and spaces. Most whitespace is insignificant, having no effect on the code around from the compiler’s point of view.

When we use whitespace to make code more comprehensible without changing its behavior, that’s an example of [secondary notation](https://en.wikipedia.org/wiki/Secondary_notation); the primary notation, of course, being the code itself.

> Another example of secondary notation is syntax highlighting, discussed in [a previous NSHipster article](/swiftsyntax/).

Put enough semicolons in the right places, and you can write pretty much anything in a single line of code. But all things being equal, why not use horizontal and vertical whitespace to visually structure code in a way that’s easier for us to understand, right?

Unfortunately, the ambiguity created by the compiler’s accepting nature of whitespace can often cause confusion and disagreement among programmers: _“Should I add a newline before a curly bracket? How do I break up statements that extend beyond the width of the editor?”_

Organizations often codify guidelines for how to deal with these issues, but they’re often under-specified, under-enforced, and out-of-date. The role of a code formatter is to automatically enforce a set of conventions so that programmers can set aside their differences and get to work solving actual problems.

## Formatter Tool Comparison

The Swift community has considered questions of style from the very beginning. Style guides have existed from the very first days of Swift, as have various open source tools to automate the process of formatting code to match them.

In order to get a sense of the current state of Swift code formatters, we’ll take a look at the following four tools:

Project | Repository URL
------- | -------
[SwiftFormat](#swiftformat) | [https://github.com/nicklockwood/SwiftFormat](https://github.com/nicklockwood/SwiftFormat)
[SwiftLint](#swiftlint) | [https://github.com/realm/SwiftLint](https://github.com/realm/SwiftLint)
[Prettier with Swift Plugin](#prettier-with-swift-plugin) | [https://github.com/prettier/prettier](https://github.com/prettier/prettier)
[swift-format (proposed)](#swift-format) | [https://github.com/google/swift/tree/format](https://github.com/google/swift/tree/format)

> For brevity, this article discusses only some of the Swift formatting tools available. Here are some other ones that you may want to check out: [Swimat](https://github.com/Jintin/Swimat), [SwiftRewriter](https://github.com/inamiy/SwiftRewriter), and [swiftfmt](https://github.com/kishikawakatsumi/swiftfmt).

To establish a basis of comparison, we’ve contrived the following code sample to evaluate each tool (using their default configuration):

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

Although code formatting encompasses a wide range of possible syntactic and semantic transformations, we’ll focus on newlines and indentation, which we believe to be baseline requirements for any code formatter.

> The performance benchmarks in this article are, admittedly, not very rigorous. But they should provide some indication of general performance characteristics. Timings are measured in seconds and taken on a 2017 MacBook Pro with 2.9 GHz Intel Core i7 processor and 16 GB 2133 MHz LPDDR3 memory.

### SwiftFormat

First up is [SwiftFormat](https://github.com/nicklockwood/SwiftFormat), a tool as helpful as it is self-descriptive.

#### Installation

SwiftFormat is distributed via [Homebrew](/homebrew/) as well as [Mint](https://github.com/yonaskolb/Mint) and [CocoaPods](/CocoaPods/).

You can install it by running the following command:

```swift
$ brew install swiftformat
```

In addition, SwiftFormat also provides an Xcode Source Editor Extension, found in the [EditorExtension](https://github.com/nicklockwood/SwiftFormat/tree/master/EditorExtension), which you can use to reformat code in Xcode. Or, if you’re a user of [VSCode](/vscode/), you can invoke SwiftFormat with [this plugin](https://marketplace.visualstudio.com/items?itemName=vknabel.vscode-swiftformat).

#### Usage

The `swiftformat` command formats each Swift file found in the specified file and directory paths.

```swift
$ swiftformat Example.swift
```

SwiftFormat has a variety of rules that can be configured either individually via command-line options or using a configuration file.

#### Example Output

Running the `swiftformat` command on our example using the default set of rules produces the following result:

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

As you can see, this is a clear improvement over the original. Each line is indented according to its scope, and each declaration has consistent spacing between punctuation. Both the semicolon in the property declarations and the newline in the initializer parameters are preserved; ~~however, the closing curly braces aren’t moved to separate lines as might be expected~~ this is [fixed in 0.39.5](https://twitter.com/nicklockwood/status/1103595525792845825). Great work, [Nick](https://github.com/nicklockwood)!

#### Performance

SwiftFormat is consistently the fastest of the tools tested in this article, completing in a few milliseconds.

```swift
$ time swiftformat Example.swift
            0.03 real         0.01 user         0.01 sys
```

### SwiftLint

Next up is, [SwiftLint](https://github.com/realm/SwiftLint), a mainstay of the Swift open source community. With over 100 built-in rules, SwiftLint can perform a wide variety of checks on your code — everything from preferring `AnyObject` over `class` for class-only protocols to the so-called “Yoda condition rule”, which prescribes variables to be placed on the left-hand side of comparison operators (that is, `if n == 42` not `if 42 == n`).

As its name implies, SwiftLint is not primarily a code formatter; it’s really a diagnostic tool for identifying convention violation and API misuse. However, by virtue of its auto-correction faculties, it’s frequently used to format code.

#### Installation

You can install SwiftLint using Homebrew with the following command:

```swift
 $ brew install swiftlint
```

Alternatively, you can install SwiftLint with [CocoaPods](/CocoaPods/), [Mint](https://github.com/yonaskolb/Mint), or as a [standalone installer package (`.pkg`)](https://github.com/realm/SwiftLint/releases/tag/0.31.0).

#### Usage

To use SwiftLint as a code formatter, run the `autocorrect` subcommand passing the `--format` option and the files or directories to correct.

```swift
 $ swiftlint autocorrect --format --path Example.swift
```

#### Example Output

Running the previous command on our example yields the following:

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

SwiftLint cleans up the worst of the indentation and inter-spacing issues but leaves other, extraneous whitespace intact. Again, it’s worth noting that formatting isn’t SwiftLint’s primary calling; if anything, it’s merely incidental to providing actionable code diagnostics. And taken from the perspective of _“first, do no harm”_, it’s hard to complain about the results here.

#### Performance

For everything that SwiftLint checks for, it’s remarkably snappy — completing in a fraction of a second for our example.

```swift
    $ time swiftlint autocorrect --quiet --format --path Example.swift
            0.11 real         0.05 user         0.02 sys
```  

### Prettier with Swift Plugin

If you’ve mostly shied away from JavaScript (as discussed in [last week’s article](/javascriptcore/)), this may be the first you’ve heard of [Prettier](https://github.com/prettier/prettier). On the other hand, if you’re steeped in the world of ES6, React, and WebPack, you’ve almost certainly come to rely on it.

Prettier is unique among code formatters in that it optimizes — first and foremost — for aesthetics, wrapping lines of code onto newlines as if they were poetry.

Thanks to its (in-development) [plugin architecture](https://prettier.io/docs/en/plugins.html), the same line-breaking behavior can be applied to other languages, [including Swift](https://github.com/prettier/plugin-swift).

> The Prettier plugin for Swift is very much a work-in-progress and crashes when it encounters a syntax token it doesn’t have rules for (like `EnumDecl` 😩). However, as you’ll see below, the results so far are too good to ignore, which is why we thought it worthwhile to include it in this round-up.

#### Installation

To use Prettier and its plugin for Swift, you’ll have to wade into the murky waters of the Node packaging ecosystem. There are a few different approaches to get everything installed _(because of course there are)_, but [Yarn](https://yarnpkg.com/en/) is our favorite 😻.

```brew
    $ brew install yarn
    $ yarn global add prettier prettier/plugin-swift
``` 

#### Usage

With the `prettier` command-line tool accessible from our `$PATH`, run it with one or more file or directory paths.

```
    $ prettier Example.swift
``` 

#### Example Output

Here’s the result of running the latest build of the Swift plugin with Prettier on our example from before:

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

Prettier describes itself to be “An opinionated code formatter”. In practice, this means that there isn’t much in the way of configuration; there are only two options: “regular code” and “prettier code”.

Now, you may object to the increase in vertical whitespace, but you’d be lying if you said this code didn’t look _amazing_. The way that everything is evenly spaced… the way that long lines are wrapped and indented… it’s almost hard to believe that you achieve something like this automatically.

Of course, our caveat from before still applies: This is still very much a work-in-progress and isn’t suitable for production use yet. Also, there’s the matter of performance…

#### Performance

To put it bluntly: Prettier is one or two orders of magnitude slower than every other tool discussed in this article.

``` cmd
$ time prettier Example.swift
    1.14 real         0.56 user         0.38 sys
```

It’s unclear whether this is a consequence of navigating a language barrier or an opportunity for optimization, but Prettier is slow enough to cause problems at scale.

For now, we recommend using Prettier only for one-off formatting tasks, such as writing code for articles and books.

### swift-format

Having looked at the current landscape of available Swift formatters, we now have a reasonable baseline for evaluating the `swift-format` tool proposed by Tony Allevato and Dave Abrahams.

#### Installation

The code for `swift-format` is currently hosted on [the `format` branch of Google’s fork of the Swift project](https://github.com/google/swift/tree/format). You can check it out and build it from source by running the following commands:

``` cmd
$ git clone https://github.com/google/swift.git swift-format
$ cd swift-format
$ git submodule update --init
$ swift 
``` 

For your convenience, we’re providing a Homebrew formula that builds from [our own fork of Google’s fork](https://github.com/NSHipster/swift-format), which you can install with the following command:

```brew
$ brew install nshipster/formulae/swift-format
``` 

#### Usage

Run the `swift-format` command, passing one or more file and directory paths to Swift files that you want to format.

```swift
$ swift-format Example.swift 
``` 

The `swift-format` command also takes a `--configuration` option, which takes a path to a JSON file. For now, the easiest way to customize `swift-format` behavior is to dump the default configuration to a file and go from there.

```swift
$ swift-format -m dump-configuration .swift-format.json
```

Running the command above populates the specified file with the following JSON:

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

 After fiddling with the configuration — such as setting `lineLength` to the correct value of 80 _(don’t @ me)_ — you can apply it thusly:

```swift
$ swift-format Example.swift --configuration .swift-format.json 
```

#### Example Output

Using its default configuration, here’s how `swift-format` formats our example:

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

For a version `0.0.1` release, this is promising! We could do without the original semicolon and don’t much care for the colon placement for the `region` property, either, but overall, this is pretty unobjectionable — which is exactly what you’d want from an official code style tool.

#### Performance

In terms of performance, `swift-format` is currently in the middle of the pack: not so fast as to feel instantaneous, but not so slow as to be an issue.

```swift
$ time swift-format Example.swift
            0.51 real         0.20 user         0.27 sys
```  

Based on our initial investigation (albeit limited), `swift-format` appears to offer a reasonable set of formatting conventions. Going forward, it will be helpful to create more motivated examples to help inform our collective beliefs about the contours of such a tool.

No matter what, it’ll be interesting to see how the proposal changes and the discussion evolves around these issues.

---

NSMutableHipster

Questions? Corrections? [Issues](https://github.com/NSHipster/articles/issues) and [pull requests](https://github.com/NSHipster/articles/blob/master/2019-03-04-swift-format.md) are always welcome.

_This article uses Swift version 5.0._ Find status information for all articles on the [status page](/status/).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
