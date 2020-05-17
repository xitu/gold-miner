> * 原文地址：[User Defaults in Swift](https://levelup.gitconnected.com/user-defaults-in-swift-dfe228f684c6)
> * 原文作者：[Yafonia Hutabarat](https://medium.com/@yafonia)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/user-defaults-in-swift.md](https://github.com/xitu/gold-miner/blob/master/article/2020/user-defaults-in-swift.md)
> * 译者：
> * 校对者：

# User Defaults in Swift

![](https://cdn-images-1.medium.com/max/2560/0*6_KzN8_SEi_uf5vh.jpg)

All iOS apps have a built-in data dictionary that stores small amounts of user settings for as long as the app is installed. This system is called UserDefault.

## What is User Defaults?

According to Apple’s documentation, UserDefaults is an interface to the user’s default database, where you store key-value pairs persistently across launches of your app.

UserDefault can save integers, booleans, strings, arrays, dictionaries, dates and more, but you should be careful not to save too much data because it will slow the launch of your app.

UserDefaults is just like dictionaries, it consists of keys and values. For example:

```swift
var dict = [
    "Name": "Yafonia",
    "Age" : 21,
    "Language": "Indonesian"
]
```

User defaults are saved in a `.plist` file, and in this case is in `Info.plist`.

![UserDefaults on Info.plist file](https://cdn-images-1.medium.com/max/3480/1*mXhXVzPFqU0cfmsmbrqWJA.png)

## When to Use User Defaults

The user defaults are best used for simple pieces of data. If you need to store multiple objects, you better use the real database. These are several example pieces of data that are saved in UserDefaults:

* User information, like name, email address, age, occupation
* App settings, like user interface language, app color theme or font
* Flags (isLoggedIn to check whether the user is logged in or not, etc.)

## Saving Data in User Defaults

We can save several variable types on UserDefaults:

* Booleans with `Bool`, integers with `Int`, floats with `Float` and doubles with `Double`
* Strings with `String`, binary data with `Data`, [dates with Date](https://learnappmaking.com/swift-date-datecomponents-dateformatter-how-to/), URLs with the `URL` type
* Collection types with `Array` and `Dictionary`

Internally the `UserDefaults` class can only store `NSData`, `NSString`, `NSNumber`, `NSDate`, `NSArray` and `NSDictionary` classes.

For example, in this project, I want to save several account’s information such as email, code, name, token, and UserID. So I set values from loginResponse as the values of the keys (Email, LawyerCode, LawyerName, Token, UserID). All the values are string.

![](https://cdn-images-1.medium.com/max/2000/1*Ib1Wh7T8llBLq50fMuVfrA.png)

![](https://cdn-images-1.medium.com/max/3040/1*yudXhvkyriw_lS1efU3o6Q.png)

Besides account info, there’s a key named `"Token"` that is used for login info. If there’s value on that key, then the user is logged in, vice versa. You can also use flags, for example you can call it `"isLoggedIn"` with `boolean` values.

## Getting Data in User Defaults

Getting data in User Defaults is as simple as saving it. Let’s see example below.

![Account page on my project](https://cdn-images-1.medium.com/max/2000/1*iddCb3-eth4W0BcpQITCVA.png)

For this page above, I need account’s name (ex: lawyer_staging) and email (ex: lawyer_staging@justika.com), which is saved in User Defaults with the key `"Email"` and `"LawyerName"` . So here’s what we’re going to do:

![](https://cdn-images-1.medium.com/max/2424/1*I1RNdSsvWvQxwj8tqFeYww.png)

To show the account’s name and email you can just set the label’s text to the data you get from UserDefaults. Yes, it’s as simple as that!

## Reset Data in User Defaults

Maybe you’ve been wondering, since I don’t use flags for login info, how would it be when user is not logged in?

If the user’s logged out, then we can reset the keys and values on the User Default. How do we do that?

![](https://cdn-images-1.medium.com/max/2496/1*TGG_S-wQRAm_W7zCJyXNzg.png)

So, when the user clicks “Keluar” button, we can reset all the User Defaults’ key and values for login info. When a user is logged in, the key and the values are set again in User Defaults.

## User Interface Language on User Defaults

As mentioned above, we also can save app settings like user interface language on User Defaults. For example, fonts info is saved in User Defaults.

![Info.plist](https://cdn-images-1.medium.com/max/3508/1*Ixk7iG6wdvGSWCx8ciyWhA.png)

On the image above, you can see that there’s a key called "Fonts provided by application" and that’s where we save the fonts.

## Conclusion

We can easily use User Defaults for saving simple pieces of data such as user’s information, app settings, and flags in the form of string, boolean, integers, arrays, dictionaries, dates, and more.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
