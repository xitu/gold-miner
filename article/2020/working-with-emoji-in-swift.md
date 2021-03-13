> * 原文地址：[Working With Emoji in Swift](https://medium.com/better-programming/working-with-emoji-in-swift-f76118e6b6d6)
> * 原文作者：[Alex Nekrasov](https://medium.com/@alex_nekrasov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/working-with-emoji-in-swift.md](https://github.com/xitu/gold-miner/blob/master/article/2020/working-with-emoji-in-swift.md)
> * 译者：[刘嘉一](https://github.com/lcx-seima)
> * 校对者：[Godlowd](https://github.com/Godlowd)、[zenblo](https://github.com/zenblo)

# 在 Swift 中玩转 emoji

![照片来自 Instagram 用户 [Gaby Prestes Nekrasova](https://www.instagram.com/gabypres2808/)](https://cdn-images-1.medium.com/max/2560/1*ITyYFzjAq7_ZP-RoIApDqg.jpeg)

emoji 已经成为我们生活中的一大部分。iPhone 和 iPad 都拥有 emoji 的专用键盘（除非这个功能被关闭了）。我们会在网站、移动端或桌面端应用中见到 emoji，我们也会在编辑文本或填写表格时输入 emoji。

我们怎么管理 emoji？如何阻止用户在 `UITextField` 中输入 emoji？我们又如何从服务器的 JSON 返回体中解析 emoji？这就让我们来探个明白。

## 一点点理论知识

emoji 是当今 Unicode 的一部分。计算机的运转依靠的是比特位和字节 —— 并不依靠微笑符号或其他小图形。文本中的每个字母、数字或特殊字符都是由一个或多个字节编码而成。emoji 也是如此。它们本质上就是一些符号。

Unicode 有三种标准的编码变形。它们都在不断发展，会加入新的符号，和包含新的语言。所以事实上 Unicode 的编码方式是多于三种的，但对于我们开发者来说，了解以下 3 种编码标准显得更为重要：

1. UTF-8（Unicode Transformation Format 8-bit）： 在这种编码下，每个符号由 1 个或多个字节表示。简单的拉丁字符、数字和部分符号只占用 1 个字节（8位）。如果字符的第 1 个比特位是 0，我们可以知道这就是个 1 字节符号。当编码俄语、汉字、阿拉伯文或 emoji 时，每个字符占用多个字节，此时比特位首位为 1。
2. UTF-16（Unicode Transformation Format 16-bit）：所有符号使用 2 个或 4 个字节进行编码。2 个字节可以组合出 65536 种不同的值，基本可以涵盖常用字符。emoji 通常占用 2 个字节，不过部分 emoji 的变种字符（不同颜色的皮肤或头发）会占用更多的数据位。
3. UTF-32（Unicode Transformation Format 32-bit）：这是最容易理解的编码方式，不过内存空间的利用效率比较低。每个字符都用 4 个字节表示。

从 2010 年开始，Unicode 6.0 版本加入了 emoji 字符。当前所有的 iPhone 和 Mac 都支持更新的 Unicode 版本，所以你可以放心地在应用中使用 emoji，它们会正确地展示给用户。

> “`NSString` 对象编码符合 Unicode 的文本字符串，并表示为一系列的 UTF-16 代码单元。” —— [Apple Developer](https://developer.apple.com/documentation/foundation/nsstring)

如你所见，emoji 可以出现在 Swift 的任何字符串中。

## macOS 中的 emoji

因为我们主要用 macOS 来编写 Swift 代码，这就让我们看看怎么在代码中添加 emoji。

在任何有文本编辑能力的应用，包括 Xcode，你可以点击 **编辑** 菜单，再点击 **表情与符号**。你便能看到 emoji 表情输入面板。从中挑选一个 emoji 点击后即可添加到代码中。

另外你也可以使用快捷键 ⌃⌘Space（ctrl + cmd + space）呼出 emoji 面板。

![macOS 中的 emoji](https://cdn-images-1.medium.com/max/2000/1*i7GRMKH_QpI7CMBPN7xmBQ.png)

## 检测 String 中的 emoji

在开始之前，让我们添加一些 extension 到项目中。它们会帮助我们判断一个 `String` 是否含有 emoji、是否全是 emoji，或 `Character` 是否是 emoji 等功能。

```Swift
import Foundation

extension Character {
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}
```

现在你可以检查 `String` 中是否含有 emoji 了：

```swift
"Alex 😊".containsEmoji // true

"Alex 😊".containsOnlyEmoji // false
```

## 在 UITextField 中禁用 emoji

通常，我们并不会允许用户输入 emoji。例如，当我们想获取用户合法姓名或其他类似数据时。

这里有两种限制用户的方法 —— 严格的和稍宽松的。

严格的方法（易实现）需要把 UITextField 的 Keyboard Type 设置为 **ASCII Capable**。这样它只会包含 Unicode 字符集中的前 128 个符号。如果你还记得 UTF-8 的细节，它分为 1 字节、2 字节和 4 字节字符。选项开启后会只包含 1 字节字符（首比特位为 0）。

![修改 keyboard Type](https://cdn-images-1.medium.com/max/2000/1*CEqiLQSZKydzqqMwCDK6FA.png)

虽然这种方法在输入用户名、密码的场景下非常实用，不过名字和其他数据很可能会包含音调符号、非拉丁字母或其他字符。这种情况下，我们就需要选择第二种方法了。具体步骤如下：

1. 设置 keyboard Type 为 **Default**。
2. 设置 delegate。通常指向你的 `UIViewController`。
3. 在 delegate 中，重写 `func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool` 方法。
4. 获取更新的文本：

```swift
if let text = textField.text,
    let textRange = Range(range, in: text) {
    let updatedText = text.replacingCharacters(in: textRange, with: string)
}
```

5. 检查 `updatedText` 是否包含 emoji，如果包含则返回 `false`。

完整的代码如下：

```Swift
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text,
       let textRange = Range(range, in: text) {
       let updatedText = text.replacingCharacters(in: textRange, with: string)
        if updatedText.containsEmoji {
            return false
        }
    }
    return true
}
```

现在，当用户尝试插入 emoji 到字符串时，输入框不会有任何反应了。如果你想显式提醒用户，可以添加一个提示信息的弹窗。

## 解析 API 响应中的 emoji

如果你曾经在 Swift 中调用过 REST API，你应该遇到过这种情况，虽然拿到了接口返回值却丢掉了其中的 emoji。`String` 和 JSON 兼容类型间的转换，像 `Array` 和 `Dictionary`，都会丢失 emoji。

最安全有效的方法就是从 API 中获取 `Data`，并把它转换成你想要的类型：

```swift
let str = String(data: data, encoding: .utf8)
```

JSON 也是如此。我们最好手动解析返回的数据：

```swift
let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
```

让我们试试使用知名的 [Alamofire](https://github.com/Alamofire/Alamofire) 库来解决本例问题：

```Swift
import Foundation
import Alamofire

class API {
    func loadEmojiString(url: URL, delegate: @escaping (_ str: String?) -> Void) {
        AF.request(url).responseData { (response) in
            switch response.result {
            case .success(let data):
                let str = String(bytes: data, encoding: .utf8)
                delegate(str)
                
            case .failure(let error):
                print(error)
                delegate(nil)
            }
        }
    }
}
```

Alamofire 会定期更新代码，所以很有可能未来就会在 `responseString` 处理器中返回 emoji 字符串了。可能此时 Alamofire 已经支持这个功能了，不过在我试的时候，它返回的 `String` 里没有包含 emoji。如果你使用的是其他请求库，上面的方法同样适用。你只需记得从网络请求中获取到的响应都是一堆字节数据。对应到 Swift 中，与之最接近的就是 `Data` 对象。它能转换为其他类型的数据。如果你想完全掌握数据的转换，你一定要优先选择 `Data` 类型。

#### MySQL 及其他 SQL 数据库小记

这部分与 Swift 无关，不过我们已经谈到了 API 中的 emoji，我就再啰嗦几句。如果你计划在 SQL 数据库（如 MySQL）中存储 emoji，你需要做两件事：

1. 将整个数据库、数据库表或单个字段的字符集设置为 `utf8mb4`。简单的 `utf8` 无法允许你在字符串字段中存储 emoji。
2. 在运行其他 SQL 请求前运行 `SET NAMES utf8mb4` 命令。

## emoji 变量

我非常欣赏 Apple 伙计们的幽默感。你可以用 emoji 给函数或变量命名。

例如，这些是合法的 Swift 语句：

```Swift
let 🌸 = 1
let 🌸🌸 = 2

func ＋(_ 🐶: Int, _ 🐮: Int) -> Int {
    🐶 + 🐮
}

let 🌸🌸🌸 = ＋(🌸🌸, 🌸)

print(🌸🌸🌸)
```

千万别在生产环境中这么写代码 —— 这样的代码难以输入、检索或分享。不过它也能很有用，比如，教小孩子编程时。这样的代码看起来就很有趣，对吧？

![使用了 emoji 的源代码](https://cdn-images-1.medium.com/max/2000/1*AAn9SWmyTdOd-pTiTxAsRA.png)

一种更常见的做法是在 `String` 中插入 emoji：

```swift
let errorText = "Sorry, something went wrong 😢"
```

## 结语

在多数情况下，应用应允许用户输入 emoji。倘若你不想让用户输入 emoji，你可以添加一些限制。如今有越来越多的用户界面使用了 emoji。

同时，除非特别需要，不要在源代码中使用 emoji。Swift 允许你这么做，不过这实在不是什么好习惯。即使 emoji 是字符串常量的一部分，也最好把它们存放到单独的文件里。

祝大家开心编码，我们下次再见！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
