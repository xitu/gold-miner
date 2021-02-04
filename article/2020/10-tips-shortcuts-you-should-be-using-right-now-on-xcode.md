> * 原文地址：[10 Tips and Shortcuts You Should Be Using Right Now in Xcode](https://medium.com/better-programming/10-tips-shortcuts-you-should-be-using-right-now-on-xcode-2e9e1b01511e)
> * 原文作者：[Mike Pesate](https://medium.com/@mpesate)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/10-tips-shortcuts-you-should-be-using-right-now-on-xcode.md](https://github.com/xitu/gold-miner/blob/master/article/2020/10-tips-shortcuts-you-should-be-using-right-now-on-xcode.md)
> * 译者：[Franz Wang](https://github.com/Franz-Wang)
> * 校对者：[NieZhuZhu](https://github.com/NieZhuZhu) [zenblo](https://github.com/zenblo)

# 你不可错过的 10 个 Xcode 技巧和快捷键

![Image source: Author](https://cdn-images-1.medium.com/max/2800/1*-xfCo4HM6bQ4kieiOHOTGQ.png)

在我作为 iOS 开发人员的职业生涯中，养成了一些使得工作变得更加轻松快捷的 [Xcode](https://developer.apple.com/xcode/resources/) 习惯。很多好用的快捷键一直都存在，只是我们没有发现而已。

所以我收集了一些我最喜欢的，在这里和大家分享。

我们开始吧！

## 1. 快速自动缩进

当你的代码没有对齐时，这个快捷键非常有用。

> ### control + i / ⌃ + i

它会自动缩进光标所在的行。如果你选中了一些代码，甚至整个文件，这个快捷键就会调整选中部分的缩进。

![Demo of ⌃ + i](https://cdn-images-1.medium.com/max/2000/1*WPbPnBUY-SUzLEE9AiDPkA.gif)

这对及时保持代码整洁非常有帮助。

## 2. 在所有作用域中修改

假设你发现某个方法或变量名有错误，你想要修复它。当然你不会一个个去修改，因为你知道有重构（Refactor）功能可以批量重命名，但有时候 Xcode 的重构功能可能不太靠谱。

此时你可以使用以下快捷键，选中当前文件中所有用到该变量的位置。

> ### command + control + e / ⌘ + ⌃ + e

这将选中所有用到这个变量的位置，让你可以非常方便地更改变量名。

![Demo of ⌘ + ⌃ + e](https://cdn-images-1.medium.com/max/2000/1*-NKhqBvn7jLQk2nVOMbObA.gif)

## 3. 查找下一个

现在，假设你不想在所有作用域中修改变量名称，而只想找到下一处；或者只想在一个函数中重命名，而不是整个类中，或者其他类似情况。有一个（和上面）非常相似的快捷键。

> ### option + control + e / ⌥ + ⌃ + e

![Demo of ⌥ + ⌃ + e](https://cdn-images-1.medium.com/max/2000/1*T9oXtmeKZ9-fH5A-6tqtiA.gif)

当你选中某个字符串，按下这个快捷键，Xcode 将选中下一个出现该字符串的位置。但这意味着，如果某些变量和函数同名，则下一个选中的，也许和你预期的不一样。（译注：这里指的是，并不判断是否真的是同一个变量，只是单纯的字符串匹配）。


## 4. 查找上一个

上面我们介绍了“查找下一个”，再多按一个键，则变成了“查找上一个”。

> ### shift + option + control + e / ⇧ + ⌥ + ⌃ + e

![Demo of ⇧ + ⌥ + ⌃ + e](https://cdn-images-1.medium.com/max/2000/1*3KQPZ1zDdgAreauSlXKMgw.gif)

## 5. 整行向上或向下移动

我们可能会对代码进行一些顺序调整，当然可以用经典的“剪切粘贴”，但如果我们只想将代码向上移动一行或向下移动一行，那么以下快捷键肯定会对你有所帮助。

**向上移动：**

> ### option + command + [ / ⌥ + ⌘ + [

**向下移动：**

> ### option + command + ] / ⌥ + ⌘ + ]

![Demo of ⌥ + ⌘ + [ and ⌥ + ⌘ + ]](https://cdn-images-1.medium.com/max/2000/1*RejIpD9jKgE8HOtKD_JsCA.gif)

#### 额外提示！你可以移动多行

如果选中多行之后再使用前面的快捷键，那么这些行将作为一个整体进行移动。

![Demo of previous shortcut moving several lines as block](https://cdn-images-1.medium.com/max/2000/1*NNCsSDveGTd_O0TBLrHbjQ.gif)


## 6. 多行光标（使用鼠标）

有时你需要在文件的不同部分中写入相同的内容，你很烦恼，因为你必须编写一次并复制粘贴几次。好吧，别再烦了。你可以使用一个快捷键同时写入多行。

> ### shift + control + click / ⇧ + ⌃ + click

![Demo of ⇧ + ⌃ + click](https://cdn-images-1.medium.com/max/2000/1*SIOMgVWDQ477m5pjfSJiHw.gif)

## 7. 多行光标（使用键盘）

此快捷键与上一个基本相同，但是我们不是使用鼠标来选择光标的位置，而是使用箭头向上或向下来移动光标。

> ### shift + control + up or down /⇧ + ⌃ + ↑ or ↓

![](https://cdn-images-1.medium.com/max/2000/1*1vC7b4sj4U_rIGvbM94fMw.gif)

## 8. 快速创建带有多个参数的初始化（init）函数

上面的快捷键，我最喜欢用法之一，就是快速创建一个初始化函数，比之前的任何方法都快。

![](https://cdn-images-1.medium.com/max/2000/1*8G_uBAI7tyIhejpOBqlMLw.gif)

通过使用多行光标，配合其他一些快捷键，例如复制粘贴或选中整行，我们可以快速创建初始化函数。这只是这个按键的几种用途之一。

#### 8.1 另一种方式

还有一个编辑功能，可以让你轻松地生成 “成员初始化器”（Memberwise Initializer）。你可以将光标放在类的名称上，然后找到 Editor > Refactor > Generate Memberwise Initializer。

但是，由于本文介绍快捷键，所以这里给一个小提示：可以进入 Preferences > Key Bindings，再查找对应命令，并添加快捷键。

这是操作示例：

![How to add a key binding](https://cdn-images-1.medium.com/max/2000/1*Rg1nkinvgq2hAfG4XLdWog.gif)

## 9. 返回光标之前所在的位置

有时候你需要处理很大的文件，向上滚动查看某些内容之后，可能很难找到原来位置。有了这个快捷键，只要我们没有将光标移开，我们就可以快速跳回之前的位置。

> ### option + command + L / ⌥ + ⌘ + L

![Demo of ⌥ + ⌘ + L](https://cdn-images-1.medium.com/max/2000/1*Cg9aSw5-Pcl75WJg859Wxw.gif)

## 10. 跳到某一行

和上一条相关，如果我们知道要跳转的那一行的行号，那么使用此快捷键，我们可以直接跳到该行。

> ### command + L / ⌘ + L

![Demo of ⌘ + L](https://cdn-images-1.medium.com/max/2000/1*N_UIb2ZCgPQQphMF5EIqjw.gif)

## 最后的想法

这些就是我每天用来高效使用 Xcode 的十个快捷键和技巧。他们经常会派上用场。

我希望他们对你也一样有用。

如果你已经知道了这些快捷键，或者还不知道，都可以与我交流，我会很高兴。也欢迎和我分享你用到的其他有用的快捷键。

#### 小贴士

理想情况下，你可以使用同样的快捷键，来实现前面提到的所有技巧。但是也可能取决于你的操作系统语言设置，其中一些可能略有不同。

你可以在 Xcode > Preferences… > Key Bindings 中查看特定快捷键的按键组合。

#### 额外提示! 快速打开偏好设置（Preferences）

> ### command + , / ⌘ + ,

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
