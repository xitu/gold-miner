> * 原文地址：[Let’s Simplify the Work with UserDefaults](https://medium.com/rosberryapps/lets-simplify-the-work-with-userdefaults-93d142d47741)
> * 原文作者：[Nikita Ermolenko](https://medium.com/@otbivnoe?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lets-simplify-the-work-with-userdefaults.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-simplify-the-work-with-userdefaults.md)
> * 译者：
> * 校对者：

# Let’s Simplify the Work with UserDefaults

![](https://cdn-images-1.medium.com/max/2000/1*7Zy2OC1nxK-BqmDbGxtPDg.png)

Everyone has worked with _UserDefaults_ in order to store some simple data and knows that working with that storage is easy as it can be. But today I’m going to improve the interaction with it a bit though! Let’s start with the most obvious solution and implement something new and elegant. 😌

Imagine we have some service — _SettingsService_. This service knows about the app’s settings — which theme is used (dark, light), whether notifications are enabled and so on. To implement it the majority of developers will think about the _UserDefaults_ at first. Of course, it depends on the case, but let’s simplify it.

1.  Our first simplest solution:

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

For simplifying, I explicitly use `UserDefaults.standard` but in a real project you’d better to store it on a property and use DI of course.

2. The next step what I want to take is to get rid of _Keys_ enum — use the `#function`instead:

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

Looks better! Let’s go further :)

3. Subscript time! We’ve just wrapped the `value(forKey:)`function into a subscript with a generic:

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

It already looks pretty neat! But what about _Enums_? 🤔

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

There’s a place for refactoring!

4. Let’s write a similar _subscript_ only for _RawRepresentable_ values:

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

Ready for production! Please, be aware that this extension is only applied for enums with _RawRepresentable_ presentation.

* * *

> Don’t miss a chance to subscribe to my [telegram channel](http://bit.ly/2xaqaYR)! Be the first to know interesting news, articles from the iOS World!

* * *

I hope you enjoyed my extensions! If you know any ways of improving it — let me know! There’s a [final extension](https://gist.github.com/Otbivnoe/04b8bd7984fba0cb58ca7f136fd95582) on _UserDefaults._ Feel free to test it out! :)

![](https://cdn-images-1.medium.com/max/800/1*s9Rzi_gHLe5rllzlj5ox1A.png)

That’s me during ITC build processing.

Shaggy iOS Engineer at [Rosberry](http://www.rosberry.com). Reactive, Open-Source lover and Retain-cycle detector :)

Thanks to [Evgeny Mikhaylov](https://medium.com/@evgenmikhaylov?source=post_page) and [Rosberry](https://medium.com/@Rosberry?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
