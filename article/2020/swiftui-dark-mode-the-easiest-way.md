> * 原文地址：[SwiftUI Dark Mode — the Easiest Way](https://medium.com/level-up-programming/swiftui-dark-mode-the-easiest-way-81e48d055189)
> * 原文作者：[Mahmud Ahsan](https://medium.com/@mahmudahsan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/swiftui-dark-mode-the-easiest-way.md](https://github.com/xitu/gold-miner/blob/master/article/2020/swiftui-dark-mode-the-easiest-way.md)
> * 译者：
> * 校对者：

# SwiftUI Dark Mode — the Easiest Way

#### iOS Dev

#### Adding dark and light mode in SwiftUI based iOS app

![[https://apps.apple.com/us/app/id1527918864#?platform=iphone](https://apps.apple.com/us/app/id1527918864#?platform=iphone) | Created by the Author](https://cdn-images-1.medium.com/max/8892/1*LC-CTl772dBIs3uQkV30OQ.png)

Starting this year when I started developing my [iOS app](https://apps.apple.com/us/app/id1527918864#?platform=iphone) using SwiftUI, I decided to support both light and dark mode. In this tutorial, I will teach you, how you could implement the light and dark mode user interface in SwiftUI based iOS application.

## 1. Create a New Project

Let’s create a new XCode project. Select SwiftUI for the Interface.

![Screenshot created by the author](https://cdn-images-1.medium.com/max/3076/1*_8O1KIZtxqQY4RjmXKy8VA.png)

## 2. Create the User Interface

Now replace all the code in `ContentView.swift` file and write the following code on there. You will create a screen with two card views.

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

If you run the app, or just see the preview, you will see the following user interface for the app now.

![Screenshot created by the author](https://cdn-images-1.medium.com/max/4304/1*BOR-JpVnjbcRDDJ042-mNA.png)

## 3. Creating Colors

Now in the XCode select **Assets.xcassets**

![Screenshot created by the author](https://cdn-images-1.medium.com/max/5276/1*rNLYzlepGHGfhUkxIYe-zQ.png)

* Create a new Color Set named **foregroundTitle1**
* Select **Any Appearance** and in the Color property, set the **Input Method** as **8-bit Hexadecimal** and for the **Hex** value use `#0974B8`
* Then select the Dark Appearance and use the value `#E0F2FD`

So basically for the **foregroundTitle1**, you created a color asset with 2 different colors for light and dark mode.

Now following the same procedure, create one more color which we will be using for the card’s background.

![Screenshot created by the author](https://cdn-images-1.medium.com/max/5204/1*1RCPFYlfxnXoho9onw7E0Q.png)

* The color set name will be **background1**
* Select 8-bit Hexadecimal value `#C9CED9` for **Any Appearance** and `#333333` for the **Dark Appearance**.

So you created two sets of foreground and background color.

## 4. Creating Color Extensions

Now create a new file `Extensions.swift` file and write the following code.

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

An extension is a good way to add some functionality to the existing class. So here you created two static methods, which will return a Color instance where the Color will be coming from the color assets. In this case, you’re just using the name of the colors you created within the color asset.

## 5. Updating Foreground and Background Colors

Now again remove all the code from the `ContentView.swift` file and write the following code

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

* `Line 15, 16` — You update the `CardView` view by adding 2 color reference
* `Line 25, 26` — You add the `foregroundColor` and `backgroundColor` with the previous references
* `Line 6, 7` — You pass the color references to the `CardView` that you created in the extension
* `Line 35-43` — You add 2 groups of views by passing a `colorScheme` of `.light` and `.dark` to see the previews

Now you will see the following output in the preview file.

![Screenshot created bu the author](https://cdn-images-1.medium.com/max/4428/1*8z7UNF0r2QKSZI8IXOg1-A.png)

If you run the app, and if you change the setting of your iPhone/iPad to light or dark mode, you will see your app will automatically show the color you decided for each mode.
[**Source-Code**
github.com](https://github.com/mahmudahsan/iOS-Swift-SwiftUI/tree/master/SwiftUI/lightdarkmode/LightDarkMode)

## Conclusion

This is just a simple way to show you how you can create light and dark mode easily for your iOS app developed using SwiftUI. If you develop your app and want to support both color modes, from the beginning you should add support or create some extensions to support the color. Later if you want to update, it will be super easy to do.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
