> * 原文地址：[Animated QR data transfer with Gomobile and Gopherjs](https://divan.dev/posts/animatedqr/)
> * 原文作者：[Divan](https://divan.dev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/animated-qr-data-transfer-with-gomobile-and-gopherjs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/animated-qr-data-transfer-with-gomobile-and-gopherjs.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[suhanyujie](https://github.com/suhanyujie)

# 使用 Gomobile 和 Gopherjs 的动态二维码数据传输

太长了不想看，直接给出全文结论：这是在周末开展，想要通过动态二维码传递数据的项目，项目采用 Go 语言编程并使用了喷泉抹除码。移动端应用使用了 Gomobile，可以复用 Go 代码，而对于网页应用，为了自动化测试二维码参数，项目使用 GopherJS 和 Vecty 框架构建。

![在两个手机之间通过二维码传输文件](https://divan.dev/images/txqr_send.gif#center)

我将会分享构建这个项目的经验，以及使用动态二维码作为数据传输方式的代码和基准测试的结果。

![测试结果](https://divan.dev/images/results_3d.png)

## 疑难问题

曾经有一天，我试着想找到如下这个场景下可行的解决方案：

假设你正在一个人流拥挤的地方，忽然间收发消息的应用停止工作了，因为独裁政府阻止了通讯。也许他们只是封禁了收发消息使用节点的 IP 地址，或者通过国有 DNS 提供器限制了一些主机的访问权，又或者是切断了其他的 VPN 和代理服务 —— 在这里何种方式其实并不重要。问题是 —— 如果至少有一台设备还能成功连网，如何能恢复其他人的网络连接，并能和他人分享连网信息呢。

这部分如果展开来说，篇幅就会很长了，但是这其中最重要的、必须明白的概念就是 —— [渗流阈值](https://en.wikipedia.org/wiki/Percolation_threshold)。简单的说就是，如果你用概率 p 将格子或图（或者人群中的人）中的节点连接起来，那么在某个临界概率 **p**0 处，将会出现较大的集群和远距离链接。用更简单的话说，如果人群中的每个人都和他们周围 **n** 个人共享信息，那么你可以运用数学的准确性保证，每个人都会得到这些信息。

而在例如启动节点 IP 的情境下，这就意味着，每个人的应用的连接都将会恢复。

好了，现在回到我们的问题 —— 当你处于一个对抗性的环境中，并且被切断了部分网络，如何能快速的将任意的信息碎片从一个应用发送到另一个呢？最先想到的是使用蓝牙，但是这需要一个冗长枯燥的发现设备和识别设备名的过程，并且在很多时候，蓝牙就是会出现“不知为什么而无法连接”的问题。另外，NFC 也是个不错的主意 —— 可以直接将一个手机连接到另一个手机 —— 但是主要的缺点是，还有很多手机和平板设备并不支持 NFC 或者是对 NFC 的支持还有限。那么，二维码如何呢？

## 二维码

[二维码](https://en.wikipedia.org/wiki/QR_code)是一种非常受欢迎的视觉编码，在多种行业都广泛应用。它支持多种不同的错误恢复级别，最高可有将近 30% 的冗余信息。容量最高的版本（版本 40）允许编码最多 4296 个字母或者 2953 个二进制符号。

但是有两个很明显的问题：

* 3-4KB 的传输速度恐怕是不够的
* 二维码中包含的数据越多，图像的质量和解析精度就要越高

在本例中，我想要能够在性能中等的用户设备之间传输大约 15KB 的数据，所以很自然的想到，为什么不用具有动态 FPS 和大小会变动的动态二维码呢？

我快速调研了一些前人做的工作，发现有[一些](https://github.com/leonjza/qrxfer) [类似的](https://volumeintegration.com/jumping-the-gap-data-transmission-over-an-air-gap/) [项目](http://stephendnicholas.com/posts/quicker-video-qr-codes)，大部分是作为黑客项目，或者甚至是作为[学位论文](http://www.theseus.fi/bitstream/handle/10024/96359/Grasbeck_Max.pdf?sequence=1&isAllowed=y)，并且使用了 Java、Python 或者 JavaScript 作为编程语言。这就意味着，这些代码并不能跨平台，也不能真正的被复用，所以我的项目必须要从零开始实现。幸运的是，由于二维码非常流行，很多人都在使用，所以并不缺少于此相关的代码库，同时，二维码的解析甚至已经嵌入在大多数智能手机制造商的相机软件中。（这实际上也正是人们不去研发其他方法来增加二维码功能的原因，比如说彩色二维码，在彩色二维码中，颜色编码附加层，或者甚至是亮度编码这种更酷的东西，像苹果用于他们的[Apple Watch 配对过程中的粒子云](https://www.youtube.com/watch?v=-WK4jiwlE5k)那样）。

## TXQR

我的周末项目就是这样开始的。TxQR 这个单词的意思就是通过二维码传输（Tx）。

如下就是本项目主要的设计思路。客户端需要选择一个准备发送的数据，生成动态二维码然后循环展示它们，直到读取设备收到了所有帧。编码被设计成如下方式，它可以支持任意的帧的次序，也支持 FPS 或者编码数据块大小的动态变化。这是为了读取设备读取的很慢而设计的，并且它还可以展示信息“请降低发送设备的 FPS”，然后继续接收同一个文件，甚至连帧体积也会改变。

TXQR 协议非常简单 —— 每一帧都以 “NUM/TOTAL|” 开始，（NUM 和 TOTAL 都是整数，分别表示当前正在收发的帧以及帧总数）其余的就是文件内容。为了生成二进制的内容，原始数据使用 Base64 编码，所以实际上只有字母和数字被编码到了二维码里。然后所有帧就以给定的 FPS 无限循环展示。

![TXQR 协议](https://divan.dev/images/txqr_protocol.png)

它非常简单，[这里](https://github.com/divan/txqr)有一个本协议的 Go 语言的实现，并且为了编解码二维码，已经做了简便的封装。它最酷的部分是让移动端应用也可以使用这个代码。

**更新：txqr 现在使用更加有效的方法即[喷泉码](https://en.wikipedia.org/wiki/Fountain_code)。[后续的文章](https://divan.dev/posts/fountaincodes/)里有详细讲解和测试结果比较，有兴趣可以查看。**

### Gomobile

多亏了有 [gomobile](https://github.com/golang/mobile)，这个项目就变得非常简单了。

文件中有你刚写好的标准 Go 语言代码，然后运行 `gomobile bind ...`，几秒钟以后就可以将 `.framework` 或者 `.aar` 文件加入到你的 iOS 或者 Android 项目中去了，你可以像其他常规库那样引用它，并且可以自动获取名称补全以及类型信息。

我迅速的用 Swift 搭建了一个简单的 iOS 二维码扫描器（多亏了 Simon Ng 的[精彩介绍](https://medium.com/appcoda-tutorials/how-to-build-qr-code-scanner-app-in-swift-b5532406dd6b)），然后将其调整为可以读取动态二维码，它将需要解码的数据块提供给 txqr 解码器，然后在一个预览窗口展示接收到的文件。

每当我被“如何在 Swift 中做某某事”这样的问题困扰的时候，使用 Go 语言来解决通常要简单的多，然后只需要像上文描述的那样，直接调用库中的方法即可。但是请大家不要误会，Swift 在很多方面的表现都很出色，是很优秀的编程语言，但是它会对一件事情提供很多的解决方案，再加上有很多变动巨大的历史版本，导致你总是需要花很长时间在 Google 或者 stackoverflow 上搜索一些像“如何计算毫秒精度的时间”这样简单的问题。在浪费了 40 分钟以后，我决定使用 Go 语言，只需要调用函数 `time.Since(start)`，然后将代码转换并在 Swift 里面直接使用。

我也写了一个命令行工具，它可以在控制台展示二维码，用于对应用进行快速测试。综合所有这些，这个方案得工作状态格外优秀 —— 我可以在大约十秒钟内发送体积较小的图片，但是我开始测试大一些的文件并且尝试不同的 FPS 的时候，我意识到终端应用的二维码的帧率不足以测试更高的传输速度，如果手动进行高帧率测试可能会让应用卡死。

## TXQR 测试

![TXQR 测试](https://divan.dev/images/txqr_tester.jpg)

如果我希望找到最优 FPS、二维码帧体积以及二维码恢复级别的组合，我需要进行至少 1000 次的测试，手动调整参数并在表单记录结果，并且还要一直举着手机对准屏幕。太麻烦了，没门儿。很明显，我应该将这个步骤自动化。

所以我需要一个 txqr 测试应用。首先，我决定使用 Go 语言实现的桌面应用 UI 框架 [x/exp/shiny](x/exp/shiny)，但是它似乎还是个试验性的框架，所以我就放弃了它。真是很遗憾，因为一年前我尝试过使用 `shiny`，那时候它在简单的桌面应用上很有发展前途。但是我现在再尝试用它的时候，它甚至已经无法编译了。似乎是开发桌面 UI 框架没什么动力了 —— 因为现在大多数的应用都是在 web 端。

但是 web 编程依旧在发展的初期阶段 —— 浏览器才刚刚可以通过 WASM 而支持其他编程语言，但也仅仅是起步。当然，你可以用 JavaScript，但是作为朋友我还是不建议你使用 JavaScript 来写 web 应用，所以我决定使用我最近发现的一个项目 —— [Vecty](https://github.com/gopherjs/vecty) 框架，这样你就可以用 Go 语言写前端代码然后通过一个非常成熟的项目 [GopherJS](https://github.com/gopherjs/gopherjs) 自动编译成 JS。

### Vecty 和 GopherJS

![Vecty](https://raw.githubusercontent.com/vecty/vecty-logo/master/horizontal_color.png)

老实说，我以前从没有这么愉快的写过前端代码。

关于我近期使用 Vecty 的经历，我将会写更多的博客来介绍，包括开发 WebGL 应用等等，但是重要的是 —— 在使用 React、Angulars 和 Ember 写了几个项目后，能用一个设计精良的语言来实现这个项目实在是拨云见日般的感觉！我现在可以不用写一行 JavaScript 代码就完成一个不错的 web 应用，并且在大多数情况下，“它真的可以运行”！

开个玩笑啦，下面就是如今用 Go 写 web 应用的方法：

```
package main

import (
    "github.com/gopherjs/vecty"
)

func main() {
    app := NewApp()

    vecty.SetTitle("My App")
    vecty.AddStylesheet(/* ... add your css... */)
    vecty.RenderBody(app)
}
```

一个应用就是一个类型 —— 一个嵌入了 `vecty.Core` 类型的结构体 —— 并且需要实现接口 `vecty.Component`。这就行了！初始化 DOM 对象一开始看上去有些冗长，但是当你开始重构代码的时候，你就会清楚的意识到它实际上是如此厉害了：

```
// App 是一个顶层的应用组建
type App struct {
    vecty.Core

    session      *Session
    settings     *Settings
    // any other stuff you need,
    // it's just a struct
}

// Render 实现了接口 vecty.Component
func (a *App) Render() vecty.ComponentOrHTML {
    return elem.Body(
        a.header(),
        elem.Div(
            vecty.Markup(
                vecty.Class("columns"),
            ),
            // 左半边
            elem.Div(
                vecty.Markup(
                    vecty.Class("column", "is-half"),
                ),
                elem.Div(a.QR()), // 二维码显示区域
            ),
            // 右半边
            elem.Div(
                vecty.Markup(
                    vecty.Class("column", "is-half"),
                ),
                vecty.If(!a.session.Started(), elem.Div(
                    a.settings,
                )),
                vecty.If(a.session.Started(), elem.Div(
                    a.resultsTable,
                )),
            ),
        ),
        vecty.Markup(
            event.KeyDown(a.KeyListener),
        ),
    )
}
```

你也许在审视这段代码并且觉得它非常冗长，我承认确实是，但是写代码的过程却是很愉悦！不需要 html 的开始/结束标签，就是非常简单的复制粘贴操作（如果你想要移动一些 DOM 节点），代码结构非常分明，可读性也比较高，同时都是强类型的！我向你保证，当你开始写自己的组件的时候，你就会觉得它的冗长是非常有用的了。

人们都认为 Vecty 是一个和 React 类似的项目，但是这种说法并不准确。确实有 GopherjS 与 React 的绑定 —— [myitcv.io/react](https://github.com/myitcv/x/blob/master/react/_doc/README.md)，但是我不认为我们需要仿照和 React 相同的做法。当你使用 Vecty 写前端的时候，你会意识到事情其实非常简单。你并不需要大多数 JavaScript 框架创造出来的隐藏的高级用法和新特性 —— 这些只是个别的比较复杂内容。你只需要类型、函数和方法，将它们组合好，然后适时调用，就可以了。

关于 CSS，我使用了超好用的 CSS 框架 [Bulma](https://bulma.io) —— 它提供了一些逻辑清晰并且有意义的命名，让编译结果的 UI 代码非常易读。

然而最神奇的部分是编译阶段。你只需要运行 `gopherjs build`，然后只需要不到一秒钟，你就得到了编译好的 JS 代码，可以作为页面引用或者服务器的服务了。当我第一次运行它的时候，我本来以为会有一堆的错误、警告或者不可读信息，但是并没有 —— 它速度非常块，默默完成了所有任务，仅在一行中显示了一些编译错误。顺便说一下，在浏览器端，如果有错误抛出，你可以看到链接到 Go 文件的栈追踪（而不是编译好的 JS 文件），并且还能看到代码所处的行数。是不是超酷的？

### 测试 TXQR 编码参数

就这样，几个小时后，我完成了能让我配置测试参数范围的 web 应用：

* FPS（每秒帧数）
* 二维码帧体积（每个二维码帧中可以承载多少比特）
* 二维码恢复界别（低，中，高或者最高）

然后就可以初始化移动端应用的测试程序了。

![TXQR 测试应用](https://divan.dev/images/txqr_app.png)

当然，移动端应用也需要自动化 —— 应用需要能识别下一轮测试什么时候开始，并需要处理超时（有时候手机摄像头无法获取到所有帧，也就无法得到结果），还要将结果发送给应用，等等。

一个比较麻烦的部分是，web 应用无法创建监听 socket —— 它运行在浏览器中，对于这样一个简单的通信测试协议，除了使用 WebRTC 之外（我觉得并没有 必要），你只能作为客户端使用而不能创建。

解决方案其实很简单 —— 小型的 Go 应用可以作为 web 应用的 HTTP 静态服务（并可以自动提供浏览器功能），并且还可以包含预计只有两个连接的 WebSocket 代理 —— 来自于 UI（或者说 web 应用）的连接以及来自于移动端的连接 —— 这是一个透明的代理，从两个客户端的角度来看，可以认为它们在直接传递信息。当然，它们必须要在一个 WiFi 网络中。

另外还需要想办法将 WebSocket 地址传递给移动端应用，你猜怎么着 —— 你可以使用二维码完成这个任务 :) 综上，工作流如下： 

* 移动端应用寻找二维码中的 “start” 标记
* 从标记开始，提取出 “ws://” URL 然后连接到该地址的服务
* UI 应用马上识别出这个连接，并开始生成下一轮二维码测试
* 展示出新的带有 “readyToStart?” 标记的二维码
* 移动端读取二维码然后通过 WebSocket 发送确认信息

![TXQR 测试设计](https://divan.dev/images/txqr_tester_design.png)

这样，最后，我只需要把移动电话放到架子上，让它通过扫描二维码发送信息并通过 WebSocket 发送信息和应用相互交流即可。

![TXQR 测试范例](https://divan.dev/images/txqr_tester.gif#center)

终端 UI 支持下载 CSV 文件，基于这个文件，可以使用 R 或者其他统计工具和语言对其进行分析。

# 基准测试

完整的测试循环运行了大约 4 个小时（最花费时间的部分 —— 生成动态二维码是在浏览器运行的，依旧是使用的 JS，它只用了一个 CPU 内核），我还需要确保屏幕不会关闭，或者其他应用的窗口没有覆盖掉测试应用。我采用如下参数配置了测试：

* **FPS** —— 3 到 12
* **二维码帧体积** —— 100 到 1000（步长 30）
* **二维码恢复级别** —— 所有级别，共 4 个
* **数据体积** —— 13KB（数据是随机生成的二进制字节）

几个小时后，我下载了 CSV 文件并做了快速分析和可视化。

# 结果

一张图像的信息量等同于千言万语，而三维可交互的小部件能提供的信息则相当于上千图像。如下是测试获取结果的 3D 散点图：

[![qr_scan_results](https://plot.ly/~divan0/1.png?share_key=t8DizOL9dynI6NTcLA88Xi)](https://plot.ly/~divan0/1/?share_key=t8DizOL9dynI6NTcLA88Xi "qr_scan_results") 

最佳结果是 1.4 秒，速度几乎到达 9KB/s！这个结果的速率是 11 帧每秒，数据块体积是 850 字节，采用中等恢复级别。事实上，在这个编码率和 fps 上，手机摄像机丢失帧的可能非常高，所以很多时候应用只是在不断循环，等待丢失的帧，直到测试循环的时间耗尽。

下面是数据块体积和 fps 变化时的条形图（注意，这里过期时间是 30s）：

#### 时间与数据块体积：

[![Time vs Size](https://divan.dev/images/qr_size.png)](https://plot.ly/~divan0/3/)

如上图所示，较小的数据块体积会导致二维码编码开销过大，并导致整体时间飙升。比较明智的取值是每个数据块 550 以及 900 字节，但是更高或者更低的字节都会由于丢失帧而导致超时。到了 1000 字节的大小，我们几乎可以肯定会丢失帧，并导致超时。

#### 时间与 FPS：

[![Time vs FPS](https://divan.dev/images/qr_fps.png)](https://plot.ly/~divan0/2/)

很令我吃惊，FPS 参数对结果并没有很大的影响。最佳取值似乎是 6-7 FPS，大约等于帧间隔 150ms。更低的 fps 会导致等待时间增加，而更高的 FPS 则导致帧丢失。

#### Time 与二维码恢复级别

[![Time vs Lvl](https://divan.dev/images/qr_lvl.png)](https://plot.ly/~divan0/6/)

二维码恢复级别参数和传输时间以及冗余级别都有很强的关联性，很明显，更好的选择是比较低的恢复级别（7% 的冗余），毫无疑问 —— 较少的冗余数据更容易读取，二维码体积也更小，也就更容易扫描和识别。对于数据传输，我们也许并不需要很多冗余。所以比较好的取值可以是中等或者低级就可以了。

为了获取更丰富的结论，这些测试循环也许应该在不同屏幕和设备上运行上百次。但是对于我这个周末的研发，已经足够了。

# 结论

这个有趣的项目向我证明了，不需要任何网络连接，仅使用动态二维码的情况下，单向的数据传输是绝对可能的。并且最大的数据传输速率约为 9KB/s，绝大多数情况下的平均速率是 —— 1-2KB/s。

同时，使用 Gomobile 和 Gopherjs（同时配合 Vecty） 也让我有了一段非常棒非常高效的研发体验 —— 它们几乎成为了我的日常开发工具。它们是成熟的框架，运行迅速并且能给你“它真的可以运行”的惊喜体验。

最后，但是也同等重要的是，使用 Go 语言你可以大大提高效率，这一直都让我感到非常神奇，一旦你知道你需要构建什么 —— 附加简短的编辑运行循环时间却可以促进测试，简单的代码并且不存在让人发狂的类继承，这让重构成为简单流畅的工作，跨平台的设计思路让你能在服务端、web 应用和移动端应用同时复用相同的代码。同时还有大量可以优化和加速的空间，我只是用最直接的方式完成了工作。

如果你还从没尝试过 gomobile 或者 gopherjs —— 我建议你有机会尝试一下。它会需要你大概一个小时的时间来学习，但是能为你开启一扇能使用 Go 开发 web 或者移动端的世界的大门。去试试看吧！

## 参考链接

* [https://github.com/divan/txqr](https://github.com/divan/txqr)
* [https://github.com/divan/txqr/tree/master/cmd/txqr-tester](https://github.com/divan/txqr/tree/master/cmd/txqr-tester)
* [https://github.com/divan/txqr-tester-ios](https://github.com/divan/txqr-tester-ios)
* [https://github.com/divan/txqr-reader](https://github.com/divan/txqr-reader)
* [https://github.com/gopherjs/vecty](https://github.com/gopherjs/vecty)
* [https://github.com/golang/mobile](https://github.com/golang/mobile)

## 更新

**更新：txqr 现在使用更加有效的方法即[喷泉码](https://en.wikipedia.org/wiki/Fountain_code)。[后续的文章](https://divan.dev/posts/fountaincodes/)里有详细讲解和测试结果比较，有兴趣可以查看。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
