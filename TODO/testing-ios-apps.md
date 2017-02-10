> * 原文地址：[Testing iOS Apps](http://merowing.info/2017/01/testing-ios-apps/)
* 原文作者：[krzysztofzablocki](http://merowing.info/hire/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[thanksdanny](https://github.com/thanksdanny)
* 校对者：[DeepMissea](https://github.com/DeepMissea), [lovelyCity](https://github.com/lovelyCiTY)

# iOS 应用测试 #

![](http://merowing.info/2017/01/testing.png)

在 iOS 项目中写测试代码是个很敏感的话题。因为出于各种原因，不是每一位开发者都可以花费大量的时间去写测试代码。

更有部分人完整控制着他们的开发流程，并不将编写测试代码这一流程加入到项目中。这大概是因为他们在做测试这方面有过不好的经历，又或者他们根本看不出测试对项目的价值所在。

但我想说如果你在一个小团队工作，测试给你带来的帮助会比你在大公司大得多。

大公司里会有专业的 QA 团队，但如果你是两个开发者中的一员，确保代码的质量和可靠性就是你在工作中必须要承担的责任。这其中的压力不言而喻，因为项目中你写的每一个功能都可能对其他的部分造成影响。

我们来看看在 iOS 应用里编写可维护测试的实践与技巧。


## 基础 ##


### Red - Green - Refactor ###

- **RED**：显示测试不通过

- **GREEN**：无论写什么代码，都会让测试通过

- **REFACTOR**：重构代码去提高项目质量。**千万不要**忽略这一步

重复这个循环直到你的代码是干净的，而且都是被测试过的。

#### 好处 ####

- 在客户端还未存在的时候，做测试首先会能给你一个清晰的视角去设计客户端的 API 。

- 好的测试用例就好像对于预期执行结果的完美文档。

- 它会给你信心去促使你不断地重构你的代码，因为你知道代码有问题的话都是不会通过测试的。

- 你是否足够的了解如何去写好测试代码？

- 当你发现测试代码很难去编写的时候，就说明你的代码架构还是需要改进。通过 RGR 可以及时地帮助你去改善问题。

写一些未经测试的代码可以更好的理解手头的问题，然后通过 RGR 原则重写，会对问题理解的更深入。重写这一步骤是十分重要的，因为生产代码已经写好的时候再写测试已经是十分困难的了。

当你重构生产代码时，你不应该再走 **RGR** 流程了，相反，你应该让他们都绿灯通过，以此确保没有引发代码回归。

### [Arrange - Act - Assert](http://c2.com/cgi/wiki?ArrangeActAssert) ###

**AAA** 是单元测试中代码格式与排版的一种模式。

如果你只用 XCTests 去编写的的测试代码，你应该将功能部份并为一组，用空白行分隔：

- **Arrange** 所有必要的预处理与输入

- **Act** 被测试的对象或方法

- **Assert** 输出预期结果的验证

```
func testArticleIsProvidedCorrectly() {
        let URL = ...
        let articleProvider = ArticleProvider()

        let article = articleProvider.articleFromURL(URL: URL)

        XCTAssertNotNil(article)
    }
```

#### 好处 ####

- 从 setup 与断言中分离已测试的功能。

- 专注在最小的一组测试步骤集上。

- 让测试的感觉更浓：

	- 断言混合了“Act”代码

	- 测试方法尝试在同一时间测试太多东西

	- 测试方法需要写很多 setup 的时候，是一个需要重构的好信号

## 测试代码的质量 ##

其中我听过最多关于测试的抱怨，就是他们会觉得测试代码太难维护了。

很多人应用程序的代码写的很好，而测试用例写的惨不忍睹，因为他们把测试当摆设，根本不需要去重视。

这里我想引用 Klaas 的一句话：

> 测试是第一个使用你 API 的“人”，假如他用你的 API 都觉得有问题，那你的生产代码很有可能也出现同样的情况。

我认为测试也是你的产品的一部分。将这一步加入到你的项目结构中，让他成为你潜意识的一部分。

还有能做什么可以比 *RGR* 和 *AAA* 让测试用例更好维护呢？

### 使用类型推断工厂 ###

不同于重复初始化的模式，这里介绍一下简单的工厂与类型推断。

例如：相比在你每个测试用例中添加不同的字符串，让他更容易地组成任意长度的句子：

```
extension String {
    func make(_ words: Int = 2) -> String {
        let wordList = [
            "alias", "consequatur", "aut", "perferendis", "sit", "voluptatem",
            "accusantium", "doloremque", "aperiam", "eaque", "ipsa", "quae", "ab",
            "illo", "inventore", "veritatis", "et", "quasi", "architecto",
            "beatae", "vitae", "dicta", "sunt", "explicabo", "aspernatur", "aut",
            ...
        ]

        var result = "$START$ "
        (0..<words - 2).forEach { idx in
            result += wordList[idx % wordList.count] + " "
        }

        result += "$END$"
        return result
    }
}
```

你可以创建 `make` 方法去添加不同类型需要被反馈的数据，也包含你的 model 对象。 如果你以扩展的形式进行添加会获得更加智能的提示。

这种模式会让你的测试用例更轻量以及重要部分会出现高亮提示，且不对 stub 数据进行处理。

```
Snapshot<ThumbnailNode>.verify("short summary", with:
    ThumbnailNodeViewModel(
        url: .make(),
        headline: .make(),
        summary: .make(words: 5),
        promotionalImageCrop: .make()
    )
```

### 不要在代码中测试布局 ###

一般情况下，测试用例集合中的视图布局和特定 frames 的用例不会顺利的执行完，这种情况出现时，大多数人仅仅是将数据更新成预期的数据然后继续。请不要这样做。


相反地，利用[截图测试](https://www.objc.io/issues/15-testing/snapshot-testing/)，就会让你更容易地发现界面是否错位。

这对视图质量的保证非常有效，您可以以几秒钟内生成同一 UI 元素的许多不同版本。


**注意：**我建议在你的项目中在改变截图时应该添加明确的权限，否则其他人会使用布局去做同样的事（只更新截图而不考虑其他）。当截图被修改的时候，你可以使用 [danger](http://danger.systems) 去通知用户。

### 写一个自定义的 matchers ###

我们测试过程中经常会遇到类似模式的情况，为了不重复他们，使用自定义的 matcher 可以让我们的工作更加轻松。

例如，测试 NSAttributedStrings 时可以被 PITA，除非你创建一个简单的 matcher 使工作更轻松：

```
it("has an attributed kicker with the expected font") {
  expect(sut?.attributedKicker).to(haveFont("NYTFranklin-Medium", size: 13.0))
}
```

```
it("has an attributed string with the expected kicker font") {
    expect(sut?.attributedString).to(
        haveFont("NYTFranklin-Bold", size: 13.0,
        forRange: .firstOccurrence(substring: expectedSubstring))
    )
}
```

### 替换掉苹果官方或第三方的接口 ###

在测试中可以很方便地替换掉第三方的依赖，因此我们可以在隔离区测试我们的对象。一些类苹果甚至表示不会提供公开的接口去创建他们，例如 `UITouch`.

解决这些场景的其中一个办法，就是尽快去掉这些依赖，例如不去依靠 `UITouch` 实例，而是使用我们自己的协议,并使 `UITouch` 去遵守他。

```
protocol TouchEvent {
    func location(in view: UIView?) -> CGPoint
    var view: UIView?
}

extension UITouch: TouchEvent {}
```

添加后的好处，就是现在我们可以控制我们真正关心的接口，当我们想要触发依靠于 `TouchEvent` 事件时，我们可以在测试中创建一个伪造的结构来相应对应的 `TouchEvent` 事件。

对于第三方依赖，尽管没有经过测试，我们也不应在我们的代码库中漏掉他们，因为共同使用协议与组合会更有帮助。

[谨记，协议也是有可能被滥用的](http://chris.eidhof.nl/post/protocol-oriented-programming/)


### 限制公开的接口 ###

你应负责所有的公开接口的测试，只有你的接口越少，你需要的测试工作才会减少。但更重要的是，你应该避免写出不稳定的测试代码，着眼于全局而不是细节的实现。

避免直接去测试私有方法，只通过公开的接口测试他们的行为。

[我们应该是面向接口编程，而非面向实现。](http://www.artima.com/lejava/articles/designprinciples.html)

### 专注于可读性 ###

[一次失败的测试应该像一份高质量的 bug 反馈报告](https://medium.com/javascript-scene/what-every-unit-test-needs-f6cd34d9836d#.kn8a3pyi8)，这点是十分重要的。

RSpec 的测试风格可以提高你部分的测试用例。


#### RSpec / BDD ####

[RSpec](http://rspec.info)是常见的行为驱动开发（BDD）方式，去写人类可读的的规范，可以专注于你应用的开发。

在 iOS 上，我更喜欢 [Quick](https://github.com/Quick/Quick) 这个进行 BDD 测试的框架和一个叫做 [Nimble](https://github.com/Quick/Nimble) 的 “matcher 框架”.

实际上 BDD 跟 TDD 之间最大的不同，就是 BDD 的测试用例可以被开发者外的成员去阅读，这对团队来说非常有用。

如果你需要验证产品需求的功能是否实现，你可以复制测试规范，并询问你们的产品经理这些执行是否正确，这一过程常常会使你会发现知识的缺漏与一些错误的理解。

BDD R-Spec 比 `XCTest` 看起来更加啰嗦，但在与你的团队分享的时候却是十分有用的，例如这些规范可以是下面这样：

```
describe("Dolphin") {
      var sut: Dolphin?

      beforeEach {
        sut = Dolphin()
      }

      afterEach {
        sut = nil
      }

      describe("click") {
        context("when it is not near anything interesting") {
          it("emits once") {
            expect(sut?.click().count).to(equal(1))
          }
        }

        context("when it is near something interesting") {
          beforeEach {
            let ship = SunkenShip()
            Jamaica.dolphinCove.add(ship)
            Jamaica.dolphinCove.add(sut!)
          }

          it("emits three times") {
            expect(sut?.click().count).to(equal(3))
          }
        }
      }
    }
}
```

##### 最有效的练习 #####

以下三个 RSpec 的观察指标：

- `describe`

- `context`

- `it`

“describe” 的目的是在一个功能上封装一组测试，而 “context” 在同一状态下对一个功能去封装一组测试。

#### `describe` ####

- `describe` 是作用于 *Things*.

- `beforeEach` 用于具体说明 *Things* 是你即将要进行的测试。

```
describe("Observable") {
 beforeEach {
   sut = Observable(155)
 }
```

- 语法：
	- 使用 函数 / 对象 名字。

	- 将分组功能添加到一起时使用 ‘when’

```
 describe("when using the transforming operator") {
    describe("map") {

```

#### `context` ####

- `context` 是用来描述*状态*。

- `beforeEach` 列出 *Actions* 去获取状态
```
context("given a full queue") {
  beforeEach {
    (1...Queue.max).forEach { queue.insert( arc4random() ) }
  }
}
```

- 语法：

	- 使用 ‘given’, ‘with’ 或 ‘when’ 可以使可读性更高。

```
context("given the second observable has a send value")
context("with logged-in user")
```

#### `it` ####

- 立刻展示崩溃的位置

- 大部分 `it` 块应该包含唯一的断言

- 如果你需要多步骤，创建一个自定义的 matchers 是最好的（经过第一次验证后，他们已经不存在了）

- 语法：
	- 不要使用‘should’

	- 说说即将会发生什么

	- 只有运行测试才能验证通过与否

```
it("sends transformed value to subscriber") {
    expect(received).to(equal("String containing 3"))
}

```

### 有选择地去运行测试 ###

- 你可以在任何关键词上加上前缀：
	- “`x`”是用于暂时禁止特定的测试组

	- “`f`” 用于专注于执行特定测试组去提高性能

- 另外，使用 `pending` 去代替他们，`pending` 与 “`x`” 的区别是 pending 组在运行测试时会被记录。

**注意** ： 注意不要因为错手而提交集中或被禁用测试。最好是通过预先提交 hook 去确保。

```
#!/usr/bin/env bash
set -eu

if git diff-index -p -M --cached HEAD -- '*Specs.swift' | grep '^+' | egrep '(fdescribe|fit|fcontext|xdescribe|xit|xcontext)' >/dev/null 2>&1
then
  echo "COMMIT REJECTED because it contains fdescribe/fit/fcontext/xdescribe/xit/xcontext; please remove focused and disabled tests before committing."
  exit 1
fi

exit 0

```
#### 在 RSpec 中的 AAA ####

通常 `beforeEach` 扮演着 **Arrange** 跟 **Act** 的角色，留下 `it` 去扮演 **Assert** 的角色。

在一些场景， 使用 `beforeEach` 可能会让测试不明显和让它在操作中更难看到 AAA,你应该直接地在`it`中执行 **Act** 与 **Assert**，尽管在有些时候，添加更多测试意味着**需要重构**。

这取决于每个团队他们更倾向选择哪种方案。

[相关阅读](https://robots.thoughtbot.com/lets-not)


## 结论 ##

编写在 iOS 中可维护的测试其实是并不难且不费时的，一旦你掌握了他，你还会发现开发的速度会更快。测试的迭代周期会更短，这就意味着你的交付会变得更快。

编写测试代码让你：

- 更加了解需求，在和非开发人员沟通起来思路更加清晰

- 更加有信心去做大范围的重构

- 好的测试就像一份完美的文档

- 更专注于功能的开发

- 设计更好的接口，因为你是从用户的角度去设计它的。

- 限制可用的突变与公开的接口

- 更少的 bug

测试的回报会越来越高，项目的存在时间越长，你越会感激自己在早期对测试的投入。

我要感谢 [Paweł Dudek](https://twitter.com/eldudi) 与 [Klaas Pieter Annema](https://github.com/klaaspieter) 能花费宝贵的时间来帮我校对这篇文章。

