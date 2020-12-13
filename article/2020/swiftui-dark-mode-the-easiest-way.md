> * 原文地址：[SwiftUI Dark Mode — the Easiest Way](https://medium.com/level-up-programming/swiftui-dark-mode-the-easiest-way-81e48d055189)
> * 原文作者：[Mahmud Ahsan](https://medium.com/@mahmudahsan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/swiftui-dark-mode-the-easiest-way.md](https://github.com/xitu/gold-miner/blob/master/article/2020/swiftui-dark-mode-the-easiest-way.md)
> * 译者：[zhuzilin](https://github.com/zhuzilin)
> * 校对者：[keepmovingljzy](https://github.com/keepmovingljzy)、[zenblo](https://github.com/zenblo)、[lsvih](https://github.com/lsvih)

# SwiftUI 黑暗模式——最简单的方法

![[https://apps.apple.com/us/app/id1527918864#?platform=iphone](https://apps.apple.com/us/app/id1527918864#?platform=iphone) | Created by the Author](https://cdn-images-1.medium.com/max/8892/1*LC-CTl772dBIs3uQkV30OQ.png)

今年我开始用 SwiftUI 开发我的 [iOS 应用](https://apps.apple.com/us/app/id1527918864#?platform=iphone)的时候，我决定同时支持明暗模式。在本教程中，我会教你如何能在基于 SwiftUI 的 iOS 应用中实现用户界面的明暗模式。

## 1. 创建新项目

让我们创建一个新的 XCode 项目，选择使用 SwiftUI 构造界面（Inference）。

![作者的截图](https://cdn-images-1.medium.com/max/3076/1*_8O1KIZtxqQY4RjmXKy8VA.png)

## 2. 创建用户界面

用下面的代码替换 `ContentView.swift` 文件中的所有代码，这将创建一个有 2 个卡片视图的页面。

```Swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CardView(title: "Mark")
            CardView(title: "Bill")
            Spacer()
        }
    }
}

struct CardView: View {
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(40)
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray)
        .cornerRadius(10)
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

运行或者预览应用，你将看到下图中的用户界面：

![作者的截图](https://cdn-images-1.medium.com/max/4304/1*BOR-JpVnjbcRDDJ042-mNA.png)

## 3. 创建颜色

现在在 XCode 中选择 **Assets.xcassets**

![作者的截图](https://cdn-images-1.medium.com/max/5276/1*rNLYzlepGHGfhUkxIYe-zQ.png)

* 创建一个新颜色集，并把它命名为 **foregroundTitle1**
* 选择 **Any Appearance**，在颜色属性中，把 **Input Method** 设置为 **8-bit Hexadecimal** 并把 **Hex** 值设为 `#0974B8`
* 然后选择 **Dark Appearance**，并设置为 `#E0F2FD`

简单来说，对于 **foregroundTitle1** ，你为明暗 2 种模式创建了 2 种不同的 color assets。

下面，按照相同的步骤，再为卡片的背景颜色创建一组颜色。

![作者的截图](https://cdn-images-1.medium.com/max/5204/1*1RCPFYlfxnXoho9onw7E0Q.png)

* 颜色集的名字是 **background1**
* 为 **Any Appearance** 设置 8 位 16 进制值 `#C9CED9`，**Dark Appearance** 设置为 `#333333` 。

至此你创建了两套前景和背景颜色。

## 4. 创建颜色拓展

新建文件 `Extensions.swift`，并写入下面的代码：

```Swift
import SwiftUI

/// Color
extension Color {
    static func CardForeground() -> Color {
        Color("foregroundTitle1")
    }
    
    static func CardBackground() -> Color {
        Color("background1")
    }
}
```

使用扩展是向现有类添加功能的一种很好的方式。这里你创建了两个静态方法，它们会分别返回一个 Color 实例，用于从 color assets 中取值。这样，只需要使用你在 color asset 中创建的颜色的名称就可以应用指定颜色集了。

## 5. 更新前景和背景颜色

再次用下面的代码替换 `ContentView.swift` 文件中的所有代码。

```Swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CardView(title: "Mark", colorForeground: Color.CardForeground(), colorBackground: Color.CardBackground())
            CardView(title: "Bill", colorForeground: Color.CardForeground(), colorBackground: Color.CardBackground())
            Spacer()
        }
    }
}

struct CardView: View {
    let title: String
    let colorForeground: Color
    let colorBackground: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(40)
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(colorForeground)
        .background(colorBackground)
        .cornerRadius(10)
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .colorScheme(.light)
        }
        
        Group {
            ContentView()
                .colorScheme(.dark)
        }
    }
}
```

* `15, 16 行` —— 通过添加 2 个颜色引用来更新 `CardView` 视图
* `25, 26 行` —— 加上刚刚添加的 `foregroundColor` 和 `backgroundColor`
* `6, 7 行`   —— 把颜色引用传给你在扩展中创建的 `CardView`
* `35-43 行`  —— 通过向 `colorScheme` 传入 `.light` 和 `.dark` 已查看2组预览

你将会在预览文件中看到如下内容。

![作者的截图](https://cdn-images-1.medium.com/max/4428/1*8z7UNF0r2QKSZI8IXOg1-A.png)

运行该应用程序的时候，将 iPhone 或 iPad 的设置更改为明亮或黑暗模式，你会看到应用自动显示你为每种模式选择的颜色。

[**源码**](https://github.com/mahmudahsan/iOS-Swift-SwiftUI/tree/master/SwiftUI/lightdarkmode/LightDarkMode)

## 总结

这只是一个在使用 SwiftUI 的 iOS 应用中创建明暗模式的简单方法。如果你希望开发的应用程序同时支持两种颜色模式，那么你应该从一开始就支持它们，或者创建一些扩展方式去支持颜色的扩展。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
