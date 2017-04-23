> * 原文地址：[Mastering Swift: essential details about strings](https://rainsoft.io/mastering-swift-essential-details-about-strings/)
* 原文作者：[Dmitri Pavlutin](https://rainsoft.io/author/dmitri-pavlutin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Tuccuay](https://www.tuccuay.com)
* 校对者：[oOatuo](https://github.com/atuooo) , [lsvih](https://github.com/lsvih)


# 掌握 Swift 的字符串细节

String 类型在任何编程语言中都是一个重要的组成部分。而用户从 iOS 应用的屏幕上能读取到最有效的信息也来自文本。

为了触及更多的用户，iOS 应用必须国际化以支持大量现代语言。Unicode 标准解决了这个问题，不过这也给我们使用 string 类型带来了额外的挑战性。

从一方面来说，编程语言在处理字符串时应该在 Unicode 复杂性和性能之间取得平衡。而另一方面，它需要为开发者提供一个舒适的结构来处理字符串。

而在我看来，Swift 在这两方面都做的不错。

幸运的是 Swift 的 string 类型并不是像 JavaScript 或者 Java 那样简单的 UTF-16 序列。

对一个 UTF-16 码单元序列执行 Unicode 感知的字符串操作是很痛苦的：你可能会打破代理对或组合字符序列。

Swift 对此有着更好的实现方式。字符串本身不再是集合，而是能够根据不同情况为内容提供不同的 view。其中一个特殊的 view： `String.CharacterView` 则是完全支持 Unicode 的。

对于 `let myStr = "Hello, world"` 来说，你可以访问到下面这些 view：

- `myStr.characters` 即 `String.CharacterView`。可以获取字形的值，视觉上呈现为单一的符号，是最常用的视图。
- `myStr.unicodeScalars` 即 `String.UnicodeScalarView`。可以获取 21 整数表示的 Unicode 码位。
- `myStr.utf16` 即 `String.UTF16View`。用于获取 UTF16 编码的代码单元。
- `myStr.utf8` 即 `String.UTF8View`。能够获取 UTF8 编码的代码单元。

![Swift 中的 CharacterView, UnicodeScalarView, UTF16View 和 UTF8View](https://rainsoft.io/content/images/2016/10/Swift-strings--3-.png)

在大多数时候开发者都在处理简单的字符串字符，而不是深入到编码或者码位这样的细节中。

`CharacterView` 能很好地完成大多数任务：迭代字符串、字符计数、验证是否包含字符串、通过索引访问和比较操作等。

让我们看看如何用 Swift 来完成这些任务。

# 1. Character 和 CharterView 的结构

`String.CharacterView` 的结构是一个字符内容的视图，它是 `Character` 的集合。

要从字符串访问视图，使用字符的 `characters` 属性：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57ff7e018ef62b25bcea2ab1)

```swift
let message = "Hello, world"
let characters = message.characters
print(type(of: characters))// => "CharacterView"
```

`message.characters` 返回了 `CharacterView` 结构.

字符视图是 `Character` 结构的集合。例如，我们可以这样来访问字符视图里的第一个字符：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57ff7e188ef62b25bcea2ab2)

```swift
let message = "Hello, world"
let firstCharacter = message.characters.first!
print(firstCharacter)           // => "H"
print(type(of: firstCharacter)) // => "Character"

let capitalHCharacter: Character = "H"
print(capitalHCharacter == firstCharacter) // => true
```

`message.characters.first`  返回了一个可选类型，内容是它的第一个字符 `"H"`.

这个字符实例代表了单个符号 `H`。

在 Unicode 标准中，`H` 代表 *Latin Capital letter H* (拉丁文大写字母 H)，码位是 `U+0048`。

让我们掠过 ASCII 看看 Swift 如何处理更复杂的符号。这些字符被渲染成单个视觉符号，但实际上是由两个或更多个 [Unicode 标量](http://unicode.org/glossary/#unicode_scalar_value) 组成。严格来说这些字符被称为 **字形簇**

**重点**： `CharacterView` 是字符串的字形簇集合。

让我们看看 `ç` 的字形。他可以有两种表现形式：

- 使用 `U+00E7` *LATIN SMALL LETTER C WITH CEDILLA* (拉丁文小写变音字母 C)：被渲染为 `ç`
- 或者使用组合字符序列：`U+0063`*LATIN SMALL LETTER C* 加上 组合标记 `U + 0327` *COMBINING CEDILLA* 组成复合字形：`c` + `◌̧` = `ç`

我们看看在第二个选项中 Swift 是如何处理它的：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f3466012fc531b0551b918)

```swift
let message = "c\u{0327}a va bien" // => "ça va bien"
let firstCharacter = message.characters.first!
print(firstCharacter) // => "ç"

let combiningCharacter: Character = "c\u{0327}"
print(combiningCharacter == firstCharacter) // => true
```

`firstCharacter` 包含了一个字形 `ç`，它是由两个 Unicode 标量 `U+0063` and `U+0327` 组合渲染出来的。

`Character` 结构接受多个 Unicode 标量来创建一个单一的字形。如果你尝试在单个 `Character` 中添加更多的字形，Swift 将会出发错误：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f3510212fc531b0551b91c)

```swift
let singleGrapheme: Character = "c\u{0327}\u{0301}" // Works
print(singleGrapheme) // => "ḉ"

let multipleGraphemes: Character = "ab" // Error!
```

即使 `singleGrapheme` 由 3 个 Unicode 标量组成，它创建了一个字形 `ḉ`。
而 `multipleGraphemes` 则是从两个 Unicode 标量创建一个 `Character`，这将在单个 `Character` 结构中创建两个分离的字母 `a` 和 `b`，这不是被允许的操作。

# 2. 遍历字符串中的字符

`CharacterView` 集合遵循了 `Sequence` 协议。这将允许在 `for-in` 循环中遍历字符视图：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bc8f27a61152fe7c7410)

```swift
let weather ="rain"for char in weather.characters {print(char)}// => "r" // => "a" // => "i" // => "n"
```

我们可以在 `for-in` 循环中访问到 `weather.characters` 中的每个字符。`char` 变量将会在迭代中依次分配给 `weather` 中的 `"r"`, `"a"`, `"i"` 和 `"n"` 字符。

当然你也可以用 `forEach(_:)` 方法来迭代字符，指定一个闭包作为第一个参数：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bca927a61152fe7c7411)

```swift
let weather = "rain"
for char in weather.characters {
  print(char)
}
// => "r"
// => "a"
// => "i"
// => "n"

```

使用 `forEach(_:)` 的方式与 `for-in` 相似，唯一的不同是你不能使用 `continue` 或者 `break` 语句。

要在循环中访问当前字符串的索引可以通过 `CharacterView` 提供的 `enumerated()` 方法。这个方法将会返回一个元组序列 `(index, character)`：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bcd127a61152fe7c7412)

```swift
let weather = "rain"
for (index, char) in weather.characters.enumerated() {
  print("index: \(index), char: \(char)")
}
// => "index: 0, char: r"
// => "index: 1, char: a"
// => "index: 2, char: i"
// => "index: 3, char: n"
```

`enumerated()` 方法在每次迭代时返回元组 `(index, char)`。
`index` 变量即为循环中当前字符的索引，而 `char` 变量则是循环中当前的字符。

# 3. 统计字符

只需要访问 `CharacterView` 的 `count` 属性就可以获得字符串中字符的个数：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bcf327a61152fe7c7413)

```swift
let weather ="sunny"print(weather.characters.count)// => 5
```

`weather.characters.count` 是字符串中字符的个数。

视图中的每一个字符都拥有一个字形。当相邻字符（比如 [组合标记](http://unicode.org/glossary/#combining_character) ）被添加到字符串时，你可能发现 `count` 属性没有没有变大。

这是因为相邻字符并没有在字符串中创建一个新的字形，而是附加到了已经存在的 [基本 Unicode 字形](http://unicode.org/glossary/#base_character) 中。让我们看一个例子：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd0927a61152fe7c7414)

```swift
var drink = "cafe"
print(drink.characters.count) // => 4
drink += "\u{0301}"
print(drink)                  // => "café"
print(drink.characters.count) // => 4
```

一开始 `drink` 含有四个字符。

当组合标记 `U+0301`*COMBINING ACUTE ACCENT* 被添加到字符串中，它改变了上一个基本字符 `e` 并创建了新的字形 `é`。这时属性 `count` 并没有变大，因为字形数量仍然相同。

# 4. 按索引访问字符

因为 Swift 直到它实际评估字符视图中的字形之前都不知道字符串中的字符个数，所以无法通过下标的方式访问字符串索引。

你可以通过特殊的类型 `String.Index` 访问字符。

如果你需要访问字符串中的第一个或者最后一个字符，字符视图结构提供了 `first` 和 `last` 属性：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd2027a61152fe7c7415)

```swift
let season = "summer"
print(season.characters.first!) // => "s"
print(season.characters.last!)  // => "r"
let empty = ""
print(empty.characters.first == nil) // => true
print(empty.characters.last == nil)  // => true

```

注意 `first` 和 `last` 属性将会返回可选类型 `Character?`。

在空字符串 `empty` 这些属性将会是 `nil`。

![String indexes in Swift](https://rainsoft.io/content/images/2016/10/Swift-strings--2--1.png)

要获取特定位置的字符，你必须使用 `String.Index` 类型（实际上是 `String.CharacterView.Index`的别名）。字符提供了一个接受 `String.Index` 下标访问字符的方法，以及预定义的索引 `myString.startIndex` 和 `myString.endIndex`。

让我们使用字符串索引来访问第一个和最后一个字符：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd3627a61152fe7c7416)

```swift
let color = "green"
let startIndex = color.startIndex
let beforeEndIndex = color.index(before: color.endIndex)
print(color[startIndex])     // => "g"
print(color[beforeEndIndex]) // => "n"
```

`color.startIndex` 是第一个字符的索引，所以 `color[startIndex]` 表示为 `g`。
`color.endIndex` 表示**结束**位置，或者简单的说是比最后一个有效下标参数大的位置。要访问最后一个字符，你必须计算它的前一个索引：`color.index(before: color.endIndex)`

要通过偏移访问字符的位置， 在 `index(theIndex, offsetBy: theOffset)` 方法中使用 `offsetBy` 参数：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd4d27a61152fe7c7417)

```swift
let color = "green"
let secondCharIndex = color.index(color.startIndex, offsetBy: 1)
let thirdCharIndex = color.index(color.startIndex, offsetBy: 2)
print(color[secondCharIndex]) // => "r"
print(color[thirdCharIndex])  // => "e"
```

指定 `offsetBy` 参数，你将可以放特定偏移量位置的字符。

当然，`offsetBy` 参数是的步进是字符串的字形。即偏移量适用于 `ChacterView` 中的 `Chacter` 实例。

如果索引超出范围，Swift 会触发错误。

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd7227a61152fe7c7418)

```swift
let color ="green"
let oops = color.index(color.startIndex, offsetBy:100) // Error!
```

为了防止这种情况，可以指定一个 `limitedBy` 参数来限制最大偏移量：`index(theIndex, offsetBy: theOffset, limitedBy: theLimit)`。这个函数将会返回一个可选类型，当索引超出范围时将会返回 `nil`：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bd8d27a61152fe7c7419)

```swift
let color = "green"
let oops = color.index(color.startIndex, offsetBy: 100,
   limitedBy: color.endIndex)
if let charIndex = oops {
  print("Correct index")
} else {
  print("Incorrect index")
}
// => "Incorrect index"
```

`oops` 是一个可选类型 `String.Index?`。展开可选类型可以验证索引是否超出了字符串的范围。

# 5. 检查子串是否存在

验证子串是否存在的最简单方法是调用 `contains(_ other: String)` 方法：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bda427a61152fe7c741a)

```swift
import Foundation
let animal = "white rabbit"
print(animal.contains("rabbit")) // => true
print(animal.contains("cat")) // => false
```

`animal.contains("rabbit")` 将返回 `true` 因为 `animal` 包含了 `"rabbit"` 字符串。

那么当子字串不存在的时候 `animal.contains("cat")` 的值将为 `false`。

要验证字符串是否具有特定的前缀或后缀，可以使用 `hasPrefix(_:)` 和  `hasSuffix(_:)` 方法。我们来看一个例子：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bdb627a61152fe7c741b)

```swift
importFoundationlet
animal = "white rabbit"
print(animal.hasPrefix("white")) // => true
print(animal.hasSuffix("rabbit")) // => true
```

`"white rabbit"` 以 `"white"` 开头并以 `"rabbit"` 结尾。所以我们调用 `animal.hasPrefix("white")` 和 `animal.hasSuffix("rabbit")` 方法都将返回 `true`。

当你想搜索字符串时，直接查询字符视图是就可以了。比如：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bdc827a61152fe7c741c)

```swift
let animal = "white rabbit"
let aChar: Character = "a"
let bChar: Character = "b"
print(animal.characters.contains(aChar)) // => true
print(animal.characters.contains {
  $0 == aChar || $0 == bChar
}) // => true
```

`contains(_:)` 将验证字符视图是否包含指定视图。

而第二个函数 `contains(where predicate: (Character) -> Bool)` 则是接受一个闭包并执行验证。

# 6. 字符串操作

字符串在 Swift 中是 *value type*（值类型）。无论你是将它作为参数进行函数调用还是将它分配给一个变量或者常量——每次复制都将会创建一个全新的**拷贝**。

所有的可变方法都是在空间内将字符串改变。

本节涵盖了对字符串的常见操作。

#### 附加字符串到另一个字符串

附加字符串较为简便的方法是直接使用 `+=` 操作符。你可以直接将整个字符串附加到原始字符串：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bddf27a61152fe7c741d)

```swift
var bird ="pigeon"
bird +=" sparrow"
print(bird) // => "pigeon sparrow"
```

字符串结构提供了一个可变方法 `append()`。该方法接受字符串、字符甚至字符序列，并将其附加到原始字符串。例如

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bdff27a61152fe7c741e)

```swift
var bird = "pigeon"
let sChar: Character = "s"
bird.append(sChar)
print(bird) // => "pigeons"
bird.append(" and sparrows")
print(bird) // => "pigeons and sparrows"
bird.append(contentsOf: " fly".characters)
print(bird) // => "pigeons and sparrows fly"
```

#### 从字符串中截取字符串

使用 `substring()` 方法可以截取字符串：

- 从特定索引到字符串的末尾
- 从开头到特定索引
- 或者基于一个索引区间

让我们来看看它是如何工作的

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be1527a61152fe7c741f)

```swift
let plant = "red flower"
let strIndex = plant.index(plant.startIndex, offsetBy: 4)
print(plant.substring(from: strIndex)) // => "flower"
print(plant.substring(to: strIndex))   // => "red "

if let index = plant.characters.index(of: "f") {
  let flowerRange = index..<plant.endIndex
  print(plant.substring(with: flowerRange)) // => "flower"
}
```

字符串下标接受一个区间或者封闭区间作为字符索引。这有助于根据范围截取子串：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be3127a61152fe7c7420) (target=undefined)

```swift
let plant ="green tree"let excludeFirstRange =
  plant.index(plant.startIndex, offsetBy:1)..<plant.endIndex
print(plant[excludeFirstRange]) // => "reen tree"
let lastTwoRange = plant.index(plant.endIndex, offsetBy:-2)..<plant.endIndex
print(plant[lastTwoRange]) // => "ee"
```

#### 插入字符串

字符串类型提供了可变方法 `insert()`。此方法可以在特定索引处插入一个字符或者一个字符序列。

新的字符将被插入到指定索引的元素之前。

来看一个例子：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be4a27a61152fe7c7421)

```swift
var plant = "green tree"
plant.insert("s", at: plant.endIndex)
print(plant) // => "green trees"
plant.insert(contentsOf: "nice ".characters, at: plant.startIndex)
print(plant) // => "nice green trees"
```

#### 移除字符

可变方法 `remove(at:)` 可以删除指定索引处的字符：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be6527a61152fe7c7422)

```swift
var weather = "sunny day"
if let index = weather.characters.index(of: " ") {
  weather.remove(at: index)
  print(weather) // => "sunnyday"
}
```

你也可以使用 `removeSubrange(_:)` 来从字符串中移除一个索引区间内的全部字符：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be7b27a61152fe7c7423)

```swift
var weather = "sunny day"
let index = weather.index(weather.startIndex, offsetBy: 6)
let range = index..<weather.endIndex
weather.removeSubrange(range)
print(weather) // => "sunny"
```

#### 替换字符串

`replaceSubrange(_:with:)` 方法接受一个索引区间并可以将区间内的字符串替换为特定字符串。这是字符串的一个可变方法。

一个简单的例子：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4be9327a61152fe7c7424)

```swift
var weather = "sunny day"
if let index = weather.characters.index(of: " ") {
  let range = weather.startIndex..<index
  weather.replaceSubrange(range, with: "rainy")
  print(weather) // => "rainy day"
}
```

#### 另一些关于字符串的可变操作

上面描述的许多字符串操作都是直接应用于字符串中的字符视图。

如果你觉得直接对字符序列进行操作更加方便的话，那也是个不错的选择。

比如你可以删除特定索引出的字符，或者直接删除第一个或者最后一个字符：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bea927a61152fe7c7425)

```swift
var fruit = "apple"
fruit.characters.remove(at: fruit.startIndex)
print(fruit) // => "pple"
fruit.characters.removeFirst()
print(fruit) // => "ple"
fruit.characters.removeLast()
print(fruit) // => "pl"
```

使用字符视图中的 `reversed()` 方法来翻转字符视图：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bebf27a61152fe7c7426)

```swift
var fruit ="peach"
var reversed =String(fruit.characters.reversed())
print(reversed)// => "hcaep"
```

 你可以很简单得过滤字符串：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4beea27a61152fe7c7427)

```swift
let fruit = "or*an*ge"
let filtered = fruit.characters.filter { char in
  return char != "*"
}
print(String(filtered)) // => "orange"
```

Map 可以接受一个闭包来对字符串进行变换：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4befd27a61152fe7c7428)

```swift
let fruit = "or*an*ge"
let mapped = fruit.characters.map { char -> Character in
  if char == "*" {
      return "+"
  }
  return char
}
print(String(mapped)) // => "or+an+ge"
```

或者使用 reduce 来对字符串来进行一些累加操作：

[Try in Swift sandbox](http://swiftlang.ng.bluemix.net/#/repl/57f4bf1d27a61152fe7c7429)

```swift
let fruit = "or*an*ge"
let numberOfStars = fruit.characters.reduce(0) { countStars, char in
    if (char == "*") {
        return countStarts + 1
    }
    return countStars
}
print(numberOfStars) // => 2
```

# 7. 说在最后

首先要说，大家对于字符串内容持有的不同观点看起来似乎过于复杂。

而在我看来这是一个很好的实现。字符串可以从不同的角度来看待：作为字形集合、UTF-8 / UTF-16 码位或者简单的 Unicode 标量。

根据你的任务来选择合适的视图。在大多数情况下，`CharacterView` 都很合适。

因为字符视图中可能包含来自一个或多个 Unicode 标量组成的字形。因此字符串并不能像数组那样直接被整数索引。不过可以用特殊的 `String.Index` 来索引字符串。

虽然特殊的索引类型导致在访问单个字符串或者操作字符串时增加了一些难度。我接受这个成本，因为在字符串上进行真正的 Unicode 感知操作真的很棒！

**对于字符操作你有没有找到更舒适的方法？写下评论我们一起来讨论一些吧！**

**P.S.** 不知道你有没有兴趣阅读我的另一篇文章：[detailed overview of array and dictionary literals in Swift](https://rainsoft.io/concise-initialization-of-collections-in-swift/)

>[掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。