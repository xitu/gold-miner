> * 原文地址：[Let’s Simplify the Work with UserDefaults](https://medium.com/rosberryapps/lets-simplify-the-work-with-userdefaults-93d142d47741)
> * 原文作者：[Nikita Ermolenko](https://medium.com/@otbivnoe?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lets-simplify-the-work-with-userdefaults.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-simplify-the-work-with-userdefaults.md)
> * 译者：[talisk](https://github.com/talisk)
> * 校对者：[allen](https://github.com/allenlongbaobao)，[stormluke](https://github.com/stormluke)

# 让我们来简化 UserDefaults 的使用

![](https://cdn-images-1.medium.com/max/2000/1*7Zy2OC1nxK-BqmDbGxtPDg.png)

每个人都用 _UserDefaults_ 来存储一些简单的数据，并且知道使用该存储很容易。但是今天我会改善一点它的交互性！让我们从最明显的解决方案开始，并实现一些新颖且优雅的东西。😌

想象一下我们有一个服务 —— SettingsService。这个服务掌握了应用的设置 —— 正在使用哪个主题（黑暗，明亮），是否启用通知等等。为了实现它，大多数开发人员会首先考虑 _UserDefaults_。 当然，用哪种方式取决于具体情况，但先让我们来简化 _UserDefaults_。

1. 我们的第一个最简方案

```
class SettingsService {

    private enum Keys {
        static let isNotificationsEnabled = "isNotificationsEnabled"
    }

    var isNotificationsEnabled: Bool {
        get {
            let isEnabled = UserDefaults.standard.value(forKey: Keys.isNotificationsEnabled) as? Bool
            return isEnabled ?? true
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.isNotificationsEnabled)
        }
    }
}
```

为了简单化，我直接使用 `UserDefaults.standard`，但在一个真实项目中，你最好把它存到一个 property 中，并使用依赖注入。

2. 下一步，我想要摆脱 _Keys_ 枚举——使用 `#function` 来代替：

```
class SettingsService {

    var isNotificationsEnabled: Bool {
        get {
            let isEnabled = UserDefaults.standard.value(forKey: #function) as? Bool
            return isEnabled ?? true
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
}
```

看，怎么样！让我们继续：）

3. 下标时间！我们刚刚把 `value(forKey:)` 方法封装成支持范型的下标语法形式：

```
extension UserDefaults {

    subscript<T>(key: String) -> T? {
        get {
            return value(forKey: key) as? T
        }
        set {
            set(newValue, forKey: key)
        }
    }
}

class SettingsService {

    var isNotificationsEnabled: Bool {
        get {
            return UserDefaults.standard[#function] ?? true
        }
        set {
            UserDefaults.standard[#function] = newValue
        }
    }
}
```

它看起来已经很整洁了！但是 _Enums_ 呢？🤔

```
enum AppTheme: Int {
    case light
    case dark
}

class SettingsService {

    var appTheme: AppTheme {
        get {
            if let rawValue: AppTheme.RawValue = UserDefaults.standard[#function], let theme = AppTheme(rawValue: rawValue) {
                return theme
            }
            return .light
        }
        set {
            UserDefaults.standard[#function] = newValue.rawValue
        }
    }
}
```

这里可以重构！

4. 让我们为 _RawRepresentable_ 值编写一个类似的 _subscript_： 

```
extension UserDefaults {
    
    subscript<T: RawRepresentable>(key: String) -> T? {
        get {
            if let rawValue = value(forKey: key) as? T.RawValue {
                return T(rawValue: rawValue)
            }
            return nil
        }
        set {
            set(newValue?.rawValue, forKey: key)
        }
    }
}

class SettingsService {
    
    var appTheme: AppTheme {
        get {
            return UserDefaults.standard[#function] ?? .light
        }
        set {
            UserDefaults.standard[#function] = newValue
        }
    }
}
```


马上完成啦！请注意，此扩展仅适用于使用 _RawRepresentable_ 的枚举。

* * *

> 别忘了订阅我的 [telegram channel](http://bit.ly/2xaqaYR)！第一时间了解 iOS 世界的有趣新闻和文章！

* * *

希望你能喜欢我写的 extension！如果你有任何改进它的想法请告诉我！查看 _UserDefaults._ 的[最新版本 extension](https://gist.github.com/Otbivnoe/04b8bd7984fba0cb58ca7f136fd95582) 尽情地体验一下吧：）

![](https://cdn-images-1.medium.com/max/800/1*s9Rzi_gHLe5rllzlj5ox1A.png)

这就是在构建 ITC 时候的我

一个在 [Rosberry](http://www.rosberry.com) 工作的毛发浓密的 iOS 工程师。热衷响应式编程，开源爱好者，循环引用检测人。：）

感谢 [Evgeny Mikhaylov](https://medium.com/@evgenmikhaylov?source=post_page) 和 [Rosberry](https://medium.com/@Rosberry?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
