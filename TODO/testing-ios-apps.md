> * 原文地址：[Testing iOS Apps](http://merowing.info/2017/01/testing-ios-apps/)
* 原文作者：[krzysztofzablocki](http://merowing.info/hire/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：@thanksdanny
* 校对者：

# Testing iOS Apps #
# iOS 应用测试 #

![](http://merowing.info/2017/01/testing.png)

Writing tests in iOS apps is a touchy subject. Not everyone is so privileged to be able to write tests full-time, for different reasons.
给 iOS 应用写测试代码一向都是很尴尬的话题，因为很少人会专门花一天的工作时间去写测试代码，至于不写的理由也是各有不同。

Some people have full control over their development process and choose not to write tests, maybe because they have had a bad experience with it or they just don’t see the value in them.
更有部分人完整控制着他们的开发流程，并不将编写测试代码这一流程加入到项目中。这大概是因为他们在做测试这方面有过不好的经历，又或者他们根本看不出测试对项目的价值所在。

I would argue that if you are part of a smaller team, tests can even be more helpful than in big corporations.
但我想说如果你在一个小团队工作，测试给你带来的帮助会比你在大公司大得多。

A big corporation might have dedicated QA team, but if you are one of 2 developers, then you are often responsible for ensuring quality and reliability of your work, its considerable pressure because each feature you write might break something else in your app.
大公司里会有专业的 QA 团队，但如果你是小团队的独立开发，那也就只剩下你去对自己的代码质量以及功能的可用性去做保证了。这会给你带来相当大得压力，因为任何一个小功能随时都会导致你的应用崩溃。

Let us look at practices and tips for writing maintainable tests in your iOS Apps.
如何写出可维护的 iOS 应用测试代码让我们来看看以下的示范与提示。



## Basics ##
## 基础 ##


### Red - Green - Refactor ###

- **RED**: Write failing tests first.
- **RED**: 显示测试不通过

- **GREEN**: Write whatever code it takes to make those tests pass.
- **GREEN**:  无论写什么代码，都会让测试通过。

- **REFACTOR**: Refactor code to improve quality. **Do not** skip this step.
- **REFACTOR**：重构代码去提高项目质量。**千万不要**忽略这一步

Repeat this cycle until you have code that is clean and tested.
重复这个循环直到你的代码是干净的，而且都是被测试过的。

#### Benefits: ####
#### 好处 ####

- Writing tests first gives you a clear perspective on the API design, by getting into the mindset of being a client of the API before it exists.
- 在客户端还未存在的时候，做测试首先会能给你一个清晰的视角去设计客户端的 API。

- Good tests serve as great documentation of expected behavior.
- 做好测试就是对应用操作，与期望结果的输出的最佳记录。

- It gives you confidence to constantly refactor your code because you know that if you break anything your tests fail.
- 它会给你信心去促使你不断地重构你的代码，因为你知道代码有问题的话都是不会通过测试的。

- Do you understand the problem enough to write good test requirements?
- 你足够清晰地知道写出好的测试需求的问题所在吗？

- If tests are hard to write its usually a sign architecture could be improved. Following RGR helps you make improvements early on.
- 当你发现测试代码很难去编写的时候，就说明你的代码架构还是需要改进。通过 RGR 可以及时地帮助你去改善问题。

Its fine to write untested code to better understand problem at hand, and then rewrite it doing RGR once you have more understanding, the rewrite part is important because writing tests after the product code has been writen is significantly harder.
首先为了更好地发现问题而写一些未被测试过的代码是 ok 的，但在重写代码的时候通过 RGR 这步骤你会对问题的理解更加清晰。重写这一步骤是十分重要的，因为生产代码已经写好的时候再写测试已经是十分困难的了。

When you refactor production code, you should not be doing **RGR**. Instead, you should be going from Green to Green, thus ensuring you did not cause regression.
当你重构生产代码时，你不应该再走**RGR**流程了，相反，你应该让他们都绿灯通过，以此确保不用再去代码回归。

### [Arrange - Act - Assert](http://c2.com/cgi/wiki?ArrangeActAssert) ###

**AAA** is a pattern for arranging and formatting code in Unit Tests.
**AAA** 是单元测试中代码格式与排版的一种模式。

If you were to write pure XCTests each of your tests would group these functional sections, separated by blank lines:
如果你只用 XCTests 去编写的的测试代码，你应该将功能部份并为一组，用空白行分隔：

- **Arrange** all necessary preconditions and inputs.
- **Arrange** 所有必要的预处理与输入

- **Act** on the object or method under test.
- **Act** 被测试的对象或方法

- **Assert** that the expected results have occurred.
- **Assert** 输出预期结果的验证

```
func testArticleIsProvidedCorrectly() {
        let URL = ...
        let articleProvider = ArticleProvider()

        let article = articleProvider.articleFromURL(URL: URL)

        XCTAssertNotNil(article)
    }
```

#### Benefits ####
#### 好处 ####

- Separates tested functionality from the setup and assertion.
- 从 setup 与 assertion 中分离已测试的功能。

- Clear focused on a minimal set of test steps.
- 专注在最小的测试步骤集上。

- Makes test smells more evident:
- 让测试的感觉更浓：

	- Assertions intermixed with “Act” code.
	- 断言混合了“Act”代码

	- Test methods that try to test too many different things at once.
	- 测试方法尝试在同一时间测试太多东西

	- Test methods that have to much setup are good sign refactor should happen
	- 测试方法有更多的 setup 在重构时是好事情

## Quality of test code ##
## 测试代码的质量 ##

One of the most common complaints about testing I hear is the fact that they are hard to maintain.
其中我听过最多关于测试的抱怨，就是他们会觉得测试代码太难维护了。

Many people write good application code, but they write pretty bad test cases, because they treat tests as an artifact, something they do not need to care about so much.
很多代码写得好的人，写出来的测试用例都不咋的，因为他们对待测试就像普通物件一样，根本不需要去重视。

I’ve to quote Klaas here:
这里我想引用 Klaas 的一句话：

> Tests are the first consumer of your API. If the first consumer has to do questionable things to work with the API, chances are your production code will too.
> 测试是第一个使用你 API 的“人”，假如他用你的 API 都觉得有问题，那你的生产代码很有可能也出现同样的情况。

I think tests are part of your product. Consider putting them next to your classes in project structure to make it sink into your subconscious.
我认为测试也是你的产品的一部分。将这一步加入到你的项目结构中，去让他更专注在你的潜意识中。


So what else can we do other than *RGR* and *AAA* to make test cases more maintainable?
还有能做什么可以比 *RGR* 和 *AAA* 让测试用例更好维护呢？

### Use type-inferred factories ###
#### 使用类型推断 factories ###

Instead of repeating the same initialization patterns, introduce simple factories and leverage type inference.
相比重复初始化模式，介绍一些简单的 factories 与使用类型推断功能。

e.g. Instead of feeding each of your test cases different strings, make it easy to generate arbitrary length sentences:
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

You can create `make` functions for all different kinds of data you need to feed, including your model objects, if you add it as extensions you get great intelisense suggestions.
你可以创建 `make` 方法去添加不同类型的数据，也包括你的 model 对象。假如你将它添加到扩展中，你会得到更加智能的提示。

This pattern allows your test cases to be light and highlight what matters, not deal with stubbing data.
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

### Do not test layouts in code ###
### 不要在代码中测试布局 ###

Testing item placement and particular frames in your test suites is not going to end up well, when those kind of tests fail, most people just update the numbers with the expected ones and move on. Don’t do it.
在你的测试套件中测试 item 的放置和特定框架是不会有停止的时候。当这些类型的测试失败，大多数人会预期数字做更新和终止测试。但不要这样做。

Instead leverage [Snapshot tests](https://www.objc.io/issues/15-testing/snapshot-testing/), where you can easily see whether something is wrong with your layout.
相反地，利用[截图测试](https://www.objc.io/issues/15-testing/snapshot-testing/)，就会让你更容易地发现界面是否错位。

They can also be very useful for Visual Quality Assurance sessions, as you can generate many different versions of the same UI element in a manner of few seconds.
这对视图质量的保证非常有效，您可以以几秒钟内生成同一UI元素的许多不同版本。


**Note:** I recommend adding explicit approval for Screenshot changes in your project, otherwise people will do the same thing they can do with layouts, just update the snapshots to pass without thinking about it. You can use [danger](http://danger.systems) to inform users when a screenshot is changed.
**注意：**我建议在你的项目中在改变截图时应该添加明确的权限，否则其他人会使用布局去做同样的事，所以你只需通过更新截图就不用考虑这么多了。当你的截图被修改的时候，你可以使用[danger](http://danger.systems)去通知用户。

### Write custom matchers ###
### 写一个自定义的 matchers ###

It often happens that we have to test similar kind of patterns, instead of repeating them, introduce custom matcher that can make this much easier.
我们测试过程中经常会遇到类似模式的情况，除了重复做同样的事，如果我们使用自定义的 matcher 可以让我们的工作更加轻松。

e.g. Testing NSAttributedStrings can be PITA unless you create a simple matcher to make it easy:
例如 测试 NSAttributedStrings 时可以被 PITA，除非你创建一个简单的 matcher 使工作更轻松：

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

### Replacing Apple or 3rd party interfaces ###
### 替换掉 苹果官方或第三方的接口 ###

Its convienent to be able to replace 3rd party dependencies in tests, so that we can test our object in isolation. Some classes Apple exposes don’t even have public interface for creating them e.g. `UITouch`.
在测试中可以很方便地替换掉第三方的依赖，因此我们可以在隔离区测试我们的对象。一些类苹果甚至表示不会提供公开的接口去创建他们，例如`UITouch`.

One way to deal with those scenarios is to get rid of dependencies as soon as we can, e.g. Instead of relying on `UITouch` instances, we rely on our own protocol and we make `UITouch` adhere to it.
解决这些场景的其中一个办法，就是尽快去掉这些依赖，例如不去依靠`UITouch`实例，而是使用我们自己的协议,并使`UITouch`去遵守他。

```
protocol TouchEvent {
    func location(in view: UIView?) -> CGPoint
    var view: UIView?
}

extension UITouch: TouchEvent {}
```

The added benefit is that we now control what interface we really care about, when we want to trigger something relying on `TouchEvent`s we can create a fake struct in our tests that adheres to `TouchEvent`.
添加后的好处，就是现在我们可以控制我们真正关心的接口，当我们触发了依靠 `TouchEvent`的事件后，我们可以创建一个伪造的结构在我们的测试中，去遵守 `TouchEvent`。

In case of 3rd party dependencies, we should not be leaking them into our codebase even without testing so both using protocols and composition are going to be helpful.
对于第三方依赖，尽管没有经过测试，我们也不应在我们的代码库中漏掉他们，因为共同使用协议与组合会更有帮助。

[Keep in mind that protocols like anything else can be abused](http://chris.eidhof.nl/post/protocol-oriented-programming/)
[谨记，协议也是有可能被滥用的](http://chris.eidhof.nl/post/protocol-oriented-programming/)


### Limit public interfaces ###
### 限制公开的接口 ###

You are responsible for testing all public interfaces, the less you have, the fewer tests you need, but more importantly, you avoid writing fragile tests, focusing on the big picture instead of implementation details.
你应负责所有的公开接口的测试，只有你的接口越少，你需要的测试工作才会减少。但更重要的是，你应该避免写出健壮性差的测试代码，着眼于全局而不是细节的实现。

Avoid testing private methods directly, only test behaviour of those methods via public interfaces.
避免直接去测试私有方法，只有通过公开接口涉及私有方法的行为才需要去测试。

[We should be programming to an interface, not an implementation.](http://www.artima.com/lejava/articles/designprinciples.html)
[我们应该是面向接口编程，而非面向实现](http://www.artima.com/lejava/articles/designprinciples.html)

### Focus on readability ###
### 专注于可读性 ###

It is important that [a failing test should read like a high-quality bug report.](https://medium.com/javascript-scene/what-every-unit-test-needs-f6cd34d9836d#.kn8a3pyi8).
[没有通过的测试的结果读起来应该像一份高质量的测试报告](https://medium.com/javascript-scene/what-every-unit-test-needs-f6cd34d9836d#.kn8a3pyi8)，这点是十分重要的。

RSpec style of testing can improve this aspect of your test cases.
RSpec 的测试风格可以提高你部分的测试用例。

#### RSpec / BDD ####
#### RSpec / BDD ####

[RSpec](http://rspec.info) is common with the behavior-driven development (BDD) process of writing human readable specifications that focus the development of your application.
[RSpec](http://rspec.info)是常见的行为驱动开发（BDD）方式，去写人类可读的的规范，可以专注于你应用的开发。

For iOS I prefer [Quick](https://github.com/Quick/Quick) BDD framework and its “matcher framework,” called [Nimble](https://github.com/Quick/Nimble).
在 iOS 上，我更喜欢 [Quick](https://github.com/Quick/Quick) 这个BDD框架，还有一个“matcher 框架”，叫做[Nimble](https://github.com/Quick/Nimble).

The main difference between BDD and TDD is the fact that BDD test cases can be read by non-engineers, which can be very useful in teams.
实际上BDD跟TDD之间最大的不同，就是BDD的测试用例可以被非工程师去阅读，这对团队来说非常有用。

If you need to verify product requirements for the feature you are working on, you could copy the test specifications and ask your manager whether the expectations are correct, this often uncovers either lack of knowledge or wrong assumptions.
如果你需要验证产品需求的功能是否实现，你可以复制测试规范，并询问你们的产品经理这些执行是否正确，这一过程常常会使你会发现知识的缺漏与一些错误的假设。

BDD R-Spec is more verbose than standard `XCTest`, but this is a good thing when you want to share it with your team, example specification might look like:
BDD R-Spec 比 `XCTest`看起来更加啰嗦，但在与你的团队分享的时候却是十分有用的，例如这些规范可以是下面这样：

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

##### Best practices #####
##### 最有效的练习 #####

There are 3 scoping indicators in RSpec:
一下三个 RSpec 的观察指标：

- `describe`

- `context`

- `it`

The purpose of “describe” is to wrap a set of tests against one functionality while “context” is to wrap a set of tests against one functionality under the same state.
“describe”的目的是在一个功能上封装一组测试，而“context”在同一状态下对一个功能去封装一组测试。

#### `describe` ####
#### `描述` ####

- `describe` is used for *Things*.
- `describe` 是作用于 *Things*.

- `beforeEach` specifies what *Things* you are going to test.
- `beforeEach` 用于具体说明*Things*是你即将要进行的测试。

```
describe("Observable") {
 beforeEach {
   sut = Observable(155)
 }
```

- Wording:
- 语法：

	- use function / object name.
	- 使用 函数 / 对象 名字。
	
	- add ‘when’ for grouping functionality together.
	- 将分组功能添加到一起时使用‘when’

```
 describe("when using the transforming operator") {
    describe("map") {

```

#### `context` ####

- `context` is used for *State*.
- `context` 是用来描述*状态*。

- `beforeEach` lists the *Actions* to get to that state.
- `beforeEach` 列出*Actions*去获取状态
```
context("given a full queue") {
  beforeEach {
    (1...Queue.max).forEach { queue.insert( arc4random() ) }
  }
}
```

- Wording:
- 语法：

	- use ‘given’, ‘with’ or ‘when’, which ever makes it more readable
	- 使用 ‘given’, ‘with’ or ‘when’ 可以使可读性更高。

```
context("given the second observable has a send value")
context("with logged-in user")
```

#### `it` ####

- Immediately shows what’s broken.
- 立刻展示崩溃的位置

- Most `it` blocks should solely contain an assertion.
- 大部分`it`块应该完全包含断言

- Prefer creating custom matchers (after first verifying they do not exist already) if you need multiple steps.
- 如果你需要多步骤，创建一个自定义的 matchers 是最好的（经过第一次验证后，他们已经不存在了）

- Wording:
- 语法：

	- Don’t use ‘should’.
	- 不要使用‘should’.
	
	- Say what will happen.
	- 说说即将会发生什么。
	
	- Running tests will verify whether it’s **true** or **false**.
	- 只有运行测试才能验证通过与否

```
it("sends transformed value to subscriber") {
    expect(received).to(equal("String containing 3"))
}

```

### Selectively running tests ###
### 有选择地去运行测试 ###

- You can prefix any of the above keywords with:
- 你可以在任何关键词上加上前缀：

	- “`x`” to disable specific group of tests temporarily
	- “`x`”是用于暂时禁止特定的测试组

	- “`f`” to focus executing only specific group of tests to improve performance
	- “`f`” 用于专注于执行特定测试组去提高性能

- alternatively, replace them with `pending`, the difference between pending and “`x`” is that pending groups will be logged when running your tests.
- 另外，使用`pending`去代替他们，`pending`与“`x`”的区别是 pending组在运行测试时会被记录。

**Note** : Be careful **not** to commit focused or disabled tests by mistake. It’s best if you use pre-commit hook to ensure that.
** 注意 ** ： 注意不要因为错手而提交集中或被禁用测试。最好是通过预先提交 hook 去确保。

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

#### AAA in RSpec ####
#### 在 RSpec 中的 AAA ####

Usually `beforeEach` takes the role of **Arrange** and **Act**, leaving only the role of **Assert** to particular `it` tests.
通常`beforeEach`扮演者 **Arrange**跟**Act**的角色，留下**Assert**去扮演剩下的角色特定的`it` 测试。

In some scenarios, using `beforeEach` might make test smells less evident and make it harder to see AAA in action, you might consider performing **Act** and **Assert** in `it` directly, though be aware that sometimes this might **require refactoring** later on when adding more tests.
在一些场景， 使用`beforeEach`可能会让测试不明显和让它在操作中更难看到 AAA,你应该直接地在`it`中执行**Act**与**Assert**，虽然要知道，有时这可能会**需要重构**后增加更多的测试。

It’s up to each team to decide which approach they prefer.
这取决于每个团队他们更倾向选择哪种方案。

[Related reading](https://robots.thoughtbot.com/lets-not)
[相关阅读](https://robots.thoughtbot.com/lets-not)

## Conclusion ##
## 尾声 ##

Writing maintainable tests in iOS is not that hard or time-consuming, once you get a hang out of it, it can even make you develop faster. The iteration cycle is much shorter with tests, which means you will get feedback faster.
编写在 iOS 中可维护的测试其实是并不难且不费时的，一旦你掌握了他，你还会发现开发的速度会更快。测试的迭代周期会更短，这就意味着你的交付会变得更快。

Writing tests allows you to:
编写测试代码允许你：

- Understand requirements better, communicate clearer with non-engineers
- 更加了解需求，在没有工程师的情况下沟通更加清晰

- Confidence to perform big refactorings
- 更加有信心去做大范围的重构

- Have better documentation. Good test suites serve as excellent documentation
- 有更好的参考资料。好的测试服务于完美的文档

- Focus on the feature in development
- 更专注于功能的开发

- Design better API’s, because you design it from the perspective of the user
- 设计更好的接口，因为你是从用户的角度去设计它的。

- Limit available mutations and public interfaces
- 限制可用的突变与公开的接口

- Fewer bugs
- 更少的 bug

Testing has increasing returns, the longer the project is alive, the more you appreciate the investments in tests you made in the beginning.
测试可以减少回归，项目的生命周期会更长，你会感激你自己当初在早期对测试环节的投入。

I’d like to thank [Paweł Dudek](https://twitter.com/eldudi) and [Klaas Pieter Annema](https://github.com/klaaspieter) for reviewing this article.
我要感谢[Paweł Dudek](https://twitter.com/eldudi) 与 [Klaas Pieter Annema](https://github.com/klaaspieter)能花费宝贵的时间来帮我校对这篇文章。

