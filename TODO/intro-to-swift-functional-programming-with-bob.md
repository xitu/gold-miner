> * 原文地址：[Intro to Swift Functional Programming with Bob](https://medium.com/ios-geek-community/intro-to-swift-functional-programming-with-bob-9c503ca14f13#.i3o0lngnq)
* 原文作者：[Bob Lee](https://medium.com/@bobleesj?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Deepmissea](http://deepmissea.blue)
* 校对者：[thanksdanny](http://thanksdanny.mobi)，[Germxu](https://github.com/Germxu)

# Bob，函数式编程是什么鬼？

## 写给年轻的自己的教程

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*AHNKmNnflyMN2zfQh9Cb4Q.png">

老司机怎么开车，我们就怎么开

### 函数式编程？

你懂的。很多人都讨论它。你 Google 一下然后看了看前五篇文章，令人沮丧的是，你发现大部分文章只给出一个含糊不清的 Wikipedia 定义，像是：

> “函数式编程是一种编程范式，能让你的代码清晰又明确，没有变量也没有状态。”

和你一样，老兄，事实上，我也这样搜索过。我温柔地做了个捂脸的表情，并轻声回应道：

> 这 TM 是啥？

#### **先决条件**

和闭包很像。如果你不理解什么是后进和关键标识，比如 $0，那你还没做好阅读这篇教程的准备。你可以暂时离开，找[这里](https://bobleesj.gitbooks.io/bob-s-learning-journey/content/WORK.html)的资源来升升级。

### 非函数式编程

我是十万个为什么。为什么要学习函数式编程？好吧，最好的答案往往来自于历史。假设你要创建一个添加一个数组的计算器应用。

```
// Somewhere in ViewController

let numbers = [1, 2, 3]
var sum = 0 

for number in numbers {
 sum += number
}
```

没问题，但是如果我再添加一个呢？

```
// Somewhere in NextViewController 

let newNumbers = [4, 5, 6]
var newSum = 0

for newNumber in numbers {
 newSum += newNumber
}
```

这看起来就像我们重复我们自己，又长又无聊，还没必要。你不得不创建一个 `sum` 来记录添加的结果。这很让人崩溃，五行代码。我们最好创建一个函数代替这些玩意。

```
func saveMeFromMadness(elements: [Int]) -> Int {
 var sum = 0

 for element in elements {
  sum += element
 }

 return sum
}
```

这样在需要使用 `sum` 的地方，直接调用

```
// Somewhere in ViewController
saveMeFromMadness(elements: [1, 2, 3])

// Somewhere in NextViewController
saveMeFromMadness(elements: [4, 5, 6])
```

**停下别动，对。你现在已经尝试了一个函数式范式的使用。函数式就是用函数来得到你想要的结果。**

### 比喻 ###

在 Excel 或者 Google 的 Spreadsheet 上，如果要对一些值求和，你需要选择表格，然后调用一个像是 C# 编写的函数。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*FT4PCQ2PjKkuX1KcNhk8Yw.gif">

Excel 里的求和函数

*好，就是这样，再见。感谢阅读。* 😂

### 声明式 vs 命令式 

最后，现在，是时候拿出详细的函数式编程定义了。

#### **声明式** ####

我们经常把函数式编程描述为**声明式**的。**你无须在意这个答案从何而来**。举个例子，一个人来爬珠穆朗玛峰，可能从飞机上跳下去，也可能花好几年从地下开始爬。**你会得到同样的结果**。人们往往不知道 Excel 表格里的 `Sum` 是怎么组成的，但是，它就是得到相应的结果。

一个残酷的例子，众所周知的非函数式编程，我们经常看到上面的调用被称为**命令式**。它告诉你**如何（how）**得到从 A 到 B 的答案。

```
let numbers = [1, 2, 3]
var sum = 0

for number in numbers {
 sum += number
}
```

人们知道你循环了 `numbers`。**但是，这有必要么？**我不在意它是怎么做的，我只在意结果的出来的迅速快捷。

因此，Excel 和 Spreadsheet 融合了函数式编程的范式，来更快更简单的获取结果，而不需要关心具体的实现。（我父亲也没必要在处理公司财务数据的时候关心它）

### 其他的好处 ###

在上面那个让人崩溃的例子里，我们不得不创建一个 `var sum = 0` 来跟踪每个视图控制器的增加结果。但是这有必要吗？`sum` 的值不断改变，如果我弄乱了总和怎么办？而且，我在[10 条 tips 让你成为一个更好的 Swift 开发者](https://medium.com/ios-geek-community/10-tips-to-become-better-swift-developer-a7c2ab6fc0c2#.rcnngphgj)中提到过，


更多的变量 → 更多记忆 → 更多头痛 → 更多 bug → 更多的生活问题。

更多的变量 → 容易 TM 的 → 完蛋

> **因此，函数式范式确保在使用的时候不可变或者没有状态的变化。**

而且，和你意识到的或即将发现的一样，函数式范式提供了一个更利于维护代码的模型。

### 目的 ###

那好，现在你明白了为什么我们喜欢函数式编程。所以呢？嗯，这篇教程，**只专注于基本面**。我不会讨论函数式编程在事件和网络等等中的应用。我可能会发一些通过 RxSwift 来做这些事的教程。所以说如果你是新手，跟着我，螺旋稳。

![](http://pic.7230.com/Uploads/Picture/2016-12-23/585cc99f0000f.png)
（译者配的图 😂 ）

### 真正的工作 ###

你可能已经见过像 `filter`、`map`、`reduce` 等等的一些东西。不错，这些让你用函数式的途径中的**过滤器**来处理一个数组。确保你对泛型的理解同样的酷。

这全是关于基本面的东西。如果我能教你如何在泳池里游泳，那你也可以在海里，湖里，池塘里，泥坑里（最好不是）游泳，这这篇教程，如果你学会了基本面，你就可以创建你自己的 `map` 和 `reduce` 或者其他你想要的炫酷函数。你可以 google 东西，否则，你不会从我这里得到这个叫“Bob”的开发者的解释了。

### 过滤器 ###

假设你有个数组。

```
let recentGrade = ["A", "A", "A", "A", "B", "D"] // My College Grade
```

你想要过滤/带来并且返回一个只包含 “A” 的数组，这能让我妈妈感到快乐。你怎么用**命令式**的方式来做这个？

```
var happyGrade: [String] = []

for grade in recentGrade {
 if grade == "A" {
  happyGrade.append(grade)
 } else {
  print("Ma mama not happy")
 }
}

print(happyGrade) // ["A", "A", "A", "A"]
```

**这简直让人发疯。**我竟然写了这种代码。我不会在校对的时候重新检查，这很残忍。视图控制器中的8行代码？🙃

> *不堪回首*。

我们必须停止这种疯狂，并拯救所有像你这么做的人。让我们创建一个函数来完成它。振作起来。**我们现在要对付一下闭包了**。让我们试着创建一个过滤器来完成和上面一样的工作。**真正麻烦现在来了。**
### 函数式的方式简介 ###

现在我们创建一个函数，有一个包含 `String` 类型的数组并且有个闭包，类型是 `(String) -> Bool`。最后，它返回一个过滤后的 `String` 数组。为啥？忍我两分钟就告诉你。

```
func stringFilter(array: [String], **returnBool: (String) -> Bool**) -> [String] {}
```

你可能会对 `returnBool` 部分特别苦恼。我知道你在想什么，

> 那么，我们要在返回 **Bool** 下传递什么？

你需要创建一个闭包，包含一个 if-else 语句来判断数组里是否含有 “A”。如果有，返回 `true`。

```
// A closure for returnBool 
let mumHappy: (String) -> Bool = { grade in return grade == "A" }
```

如果你想让他更短，

```
let mamHappy: (String) -> Bool = { $0 == "A" }

mamHappy("A") // return true 
mamHappy("B") // return false
```

**如果你对上面的两个例子感到困惑，那你还适应不了这个副本。你需要锻炼一下然后再回来。你可以重读我关于闭包的文章**。[**链接**](https://medium.com/ios-geek-community/no-fear-closure-in-swift-3-with-bob-72a10577c564#.uzdsqd7oa)

由于还没完成我们 `stringFilter` 函数的实现，让我们从离开的位置继续。

```
func stringFilter (grade: [String], returnBool: (String) -> Bool)-> [String] {

 var happyGrade: [String] = []
 for letter in grade {
  if returnBool(letter) {
   happyGrade.append(letter)
  }

 }
 return happyGrade
}
```

你的表情一定是 😫。我想说把刀放下，听我解释。通过 `stringFilter` 函数，你可以传递 `mamHappy` 作为 `returnBool`。然后调用 `returnBool(letter)`，把每个项传递个 `mamHappy`，最终就是 `mamHappy(letter)`。

它返回 `true` 或者 `false`。如果返回真，把 `letter` 加到只有 “A” 的 `happyGrade` 里。🤓 这就是为什么我妈妈在过去 12 年里感到开心的原因。

不管怎样，最终运行一下函数。

```
let myGrade = ["A", "A", "A", "A", "B", "D"]

let lovelyGrade = stringFilter(grade: myGrade, returnBool: **mamHappy**)
```

### 直接输入闭包 ###

其实你不需要创建一个分离的 `mamHappy`。可以直接在 `returnBool` 传递。

```
stringFilter(grade: myGrade, returnBool: { grade in
 return grade == "A" })
```

我想让它更简洁。

```
stringFilter(grade: myGrade, returnBool: { $0 == “A” })
```

### 肉和土豆 ###

祝贺，如果你已经到了这里，那你已经做到了。我很感谢你的关注。现在让我们创建一个野蛮点的，广为人知的通用过滤器，你可以创建一堆你想要过滤的。比如，过滤你不喜欢的单词，过滤数组里大于 60 小于 100 的数。过滤只包含真值的布尔类型。

最棒的是它用**一句话**就可以形容。我们拯救了生命和时间。爱它，我们可以努力工作，但是我们要聪明的努力工作。

### 泛型代码 ###

如果你对泛型代码感到不适，那你现在所在的位置并不正确，这里车速很快，赶快到安全的地方，名字是“[**Bob，泛型是什么鬼？**](https://medium.com/ios-geek-community/intro-to-generics-in-swift-with-bob-df58118a5001#.z61lki1c5)”，然后带点武器回来继续。

我要创建一个含有 `Bob` 泛型的函数，你可以使用 `T` 或者 `U`。但是你要知道，这是我的文章。

```
func myFilter<Bob>(array: [Bob], logic: (Bob) -> Bool) -> [Bob] {
 var result: [Bob] = []
 for element in array {
  if logic(element) {
   result.append(element)
  }
 }
 return result
}
```

让我们试着找点聪明的学生

#### 应用到学校系统 ####

```
let AStudent = myFilter(array: Array(1...100), logic: { $0 >= 93 && $0 <= 100 })

print(AStudent) // [93, 94, 95, ... 100]
```

#### 应用到投票计数 ####

```
let answer = [true, false, true, false, false, false, false]

let trueAnswer = myFilter(array: answer, logic: { $0 == true })

// Trailing Closure 
let falseAnswer = myFilter(array: answer) { $0 == false }
```

### Swift 里的过滤器 ###

幸运的是，我们不需要创建 `myFilter`。Swift 已经为我们提供了一个默认的。现在我们创建一个从一到一百的数组，然后只要小于 51 的偶数。

```
let zeroToHund = Array(1…100)
zeroToHund.filter{ $0 % 2 == 0 }.filter { $0 <= 50 })
// [2, 4, 6, 8, 10, 12, 14, ..., 50]
```

> 这就 OK 了。[源码](https://bobleesj.gitbooks.io/bob-s-learning-journey/content/Content/01_Swift_3/Intro_to_Functional_Programming.html) 

### 我的消息 ###

我敢肯定你现在已经在想，怎么在你的应用和程序里使用函数式编程。记住，你使用什么语言都无所谓。

你需要清晰的是如何将函数式范式引用到更多的领域。在你 Google 之前，我建议你花一点时间消耗一两个脑细胞想一想。

从你理解 “filter” 背后的真正含义后，你现在可以更简单的 google 然后查看什么是 `map` 和 `reduce`，以及其他函数是怎么组成的。我希望能你在不冷不热的环境中学会游泳。

> 你现在只被你的想象力所限制。保持思考并 Google。

### 最后的话 ###

在我个人看来，这篇文章是黄金。它出现在我被闭包和函数式的东西弄得一脸懵逼的时候。人们都喜欢特别简单的原则。如果你喜欢我的解释，请分享并推荐给更多的人。我收到的心越多，我就会越像抽水泵一样，为每个人献出更伟大的内容！而且，更多的心意味着基于 Medium 算法上的更多观点。

**有 Instagram 上的 geek 吗？我会发布我的一些日常并更新。欢迎大家随时添加我，跟我打招呼！**@[*bobthedev*](https://instagram.com/bobthedev) 

### Swift 会议 ###

我的一个葡萄牙朋友 [João](https://twitter.com/NSMyself) 正在葡萄牙阿威罗组织一个 Swift 会议。不像许多人在的那里，这次会议的目的是实验性参与。观众与演讲者可以相互交流 - 带上你的笔记本电脑。这是我第一次的 Swift 会议。我超兴奋！除此之外，它也是经济实惠的。活动会在 2017 年的六月一号到二号举行。如果你有兴趣了解更多信息，请随时查看网站[这里](http://swiftaveiro.xyz)或下面的 Twitter。

[SwiftAveiro (@SwiftAveiro) | Twitter](https://twitter.com/SwiftAveiro) 

### 关于我 ###

我在我的 [Facebook 页面](https://www.facebook.com/bobthedeveloper)上给出详细的更新信息。一般在美国东部时间的上午八点，我会发表文章。2017 年，我立志成长为 Medium 上 iOS Geek 社区中第一的 iOS 博客。
