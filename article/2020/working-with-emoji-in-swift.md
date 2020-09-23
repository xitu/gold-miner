> * 原文地址：[Working With Emoji in Swift](https://medium.com/better-programming/working-with-emoji-in-swift-f76118e6b6d6)
> * 原文作者：[Alex Nekrasov](https://medium.com/@alex_nekrasov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/working-with-emoji-in-swift.md](https://github.com/xitu/gold-miner/blob/master/article/2020/working-with-emoji-in-swift.md)
> * 译者：
> * 校对者：

# Working With Emoji in Swift

#### Emoji aren’t just simple strings

![Photo by [Gaby Prestes Nekrasova](https://www.instagram.com/gabypres2808/) on Instagram.](https://cdn-images-1.medium.com/max/2560/1*ITyYFzjAq7_ZP-RoIApDqg.jpeg)

Emoji have become a big part of our life. iPhones and iPads have a special emoji keyboard (unless it’s turned off). We see them on websites, in mobile and desktop apps, and we enter them when writing texts and filling in forms.

How do we control them? How do we prevent users from entering emoji in `UITextField`? How do we parse emoji in the JSON response from a server? Let’s discuss it all.

---

## A Little Bit of Theory

Emoji are a part of modern Unicode. Computers work with bits and bytes — not with smiles and other small pictures. Letters, numbers, and special characters in a text are all encoded in one or more bytes each. The same goes for emoji. They’re just symbols.

There are three standard modifications of Unicode. All of them are constantly evolving, new symbols appear, new languages are included. So there are actually more than three versions, but for us developers, it’s important to know three different standards:

1. UTF-8 (Unicode Transformation Format eight bits): Each symbol in this encoding is presented as one or more bytes. Simple latin characters, digits, and some other symbols take only one byte (eight bits). If the first bit is 0, we know that it’s a one-byte symbol. If it’s a Russian, Chinese, or Arabic symbol or an emoji, it will start with bit 1 and have more than one byte.
2. UTF-16 (Unicode Transformation Format 16 bits): All symbols are encoded into two or four bytes. Two bytes make 65,536 combinations, which include almost all known characters. Emoji usually take two bytes, but they can have modifiers (colour of skin or hair). In that case, it uses extra space.
3. UTF-32 (Unicode Transformation Format 32 bits): The simplest for understanding encoding, but the least memory-efficient. Each symbol takes exactly four bytes.

Emoji have appeared in Unicode since version 6.0 back in 2010. All modern iPhones and Macs support much newer versions, so by adding emoji to your apps, you can be sure that users will see them.

> # “An `NSString` object encodes a Unicode-compliant text string, represented as a sequence of UTF–16 code units.” — [Apple Developer](https://developer.apple.com/documentation/foundation/nsstring)

As you can see, emoji can be included in any string in Swift.

---

## Emoji in macOS

As we write Swift code mostly in macOS, let’s see how to add emoji to our code.

In any app with text editing capability, including Xcode, you can click on the **Edit** menu, then **Emoji & Symbols**. You’ll see a panel with emoji. Choose any of them and they will appear in your code.

Another way is to use the hotkey ⌃⌘Space (ctrl + cmd + space).

![Emoji in macOS](https://cdn-images-1.medium.com/max/2000/1*i7GRMKH_QpI7CMBPN7xmBQ.png)

---

## Detecting Emoji in Strings

Before we continue, let’s add several extensions to our project. They will allow us to check if `String` has emoji, if it has only emoji, if `Character` is an emoji, and so on.

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

Now you can check if `String` has an emoji:

```
"Alex 😊".containsEmoji // true

"Alex 😊".containsOnlyEmoji // false
```

---

## Forbidding Emoji in UITextField

Oftentimes, we shouldn’t allow the user to enter emoji. For example, if we want to know their legal name or other data.

There are two ways to do so — a more restrictive one and less restrictive one.

The more restrictive (but easier) way is to choose the **ASCII Capable** keyboard type. It will remove all symbols that are not included in the first 128 symbols of the Unicode set. If you still remember details about UTF-8, it has one-byte, two-byte, and four-byte characters. This option will allow only one-byte characters (starting with bit 0).

![Changing keyboard type](https://cdn-images-1.medium.com/max/2000/1*CEqiLQSZKydzqqMwCDK6FA.png)

It can be useful for entering usernames or passwords, but names and other data can have diacritic, non-Latin, and other characters. In this case, we use the second way. It has several steps:

1. Set keyboard type to **Default**.
2. Set a delegate. Usually, it’s your `UIViewController`.
3. In a delegate, override the method **func** textField(**_** textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool.
4. Get updated text:

```
if let text = textField.text,
    let textRange = Range(range, in: text) {
    let updatedText = text.replacingCharacters(in: textRange, with: string)
}
```

5. Check that `updatedText` doesn’t have emoji and return `false` if it does.

That’s how it looks:

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

Now when the user tries to insert an emoji in a text string, there will be no effect. If you want to make it clearer for the user, add an alert with a message.

---

## Decoding Emoji in API Response

If you’ve worked with a REST API in Swift, you may know that sometimes you get a response without emoji. Conversions between `Strings` and JSON-compatible types, like `Array` and `Dictionary`, may also lose emoji.

The safest way to go is to get `Data` from the API and convert it to the type you need:

```
let str = String(data: data, encoding: .utf8)
```

Same with JSON. It’s better to decode them manually from data:

```
let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
```

Let’s have a look at this example with the popular library [Alamofire](https://github.com/Alamofire/Alamofire):

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

Alamofire gets regular updates, so maybe it will return emoji in the `responseString` handler. It’s possibly already done, but when I tested it, I got `String` in return without any emoji. If you use another library, this trick will be also handy. Remember that you always receive a buffer of bytes from any web request. The closest to it in Swift is a `Data` object. All other types are converted from it. You should always prefer `Data` if you want full control.

#### Note about MySQL and other SQL databases

This is not exactly about Swift, but as we are talking about emoji in API, I’ll mention this too. If you plan to have emoji in a SQL database (e.g. MySQL), you should do two things:

1. Set the character set of the whole database, table, or a separate field to `utf8mb4`. Simple `utf8` won’t let you store emoji in string fields.
2. Run `SET NAMES utf8mb4` before running other SQL requests.

---

## Emoji Variables

I’ll give some credit to Apple for their sense of humour. You can use emoji in the names of functions or variables.

For example, this is a valid Swift code:

```Swift
let 🌸 = 1
let 🌸🌸 = 2

func ＋(_ 🐶: Int, _ 🐮: Int) -> Int {
    🐶 + 🐮
}

let 🌸🌸🌸 = ＋(🌸🌸, 🌸)

print(🌸🌸🌸)

```

Never do it in production code — it’s very uncomfortable to type, search, or share. But it can be useful, for example, to teach children. Looks funny, right?

![Source code with emoji](https://cdn-images-1.medium.com/max/2000/1*AAn9SWmyTdOd-pTiTxAsRA.png)

A more common practice is to include emoji in `Strings`:

```
let errorText = "Sorry, something went wrong 😢"
```

---

## Conclusion

In most cases, apps should allow users to enter emoji. But if it’s not a desired behaviour, it’s always possible to add restrictions. Using emoji in the user interface is also getting more and more popular these days.

At the same time, don’t use emoji in your source code unless it’s really necessary. Swift allows it, but it’s not a good practice. Even if it’s a part of a string constant, it’s better to put it in a separate file.

See you next time and happy coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
