> * 原文地址：[A History of Testing in Go at SmartyStreets](https://smartystreets.com/blog/2018/03/history-of-go-testing)
> * 原文作者：[Michael Whatcott]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/history-of-go-testing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/history-of-go-testing.md)
> * 译者：[kasheemlew](https://github.com/kasheemlew)
> * 校对者：

# SmartyStreets 的 Go 测试探索之路

最近常有人问我[这两个有趣的问题](https://github.com/smartystreets/goconvey/issues/360#issuecomment-368348056):

1. 你为什么将测试工具 (从 [GoConvey](http://goconvey.co)) 换成 [gunit](https://github.com/smartystreets/gunit)？
2. 你建议大家都这么做吗？

这两个问题很好，作为 GoConvey 的联合创始人兼 gunit 的主要作者，我也有责任将这两个问题解释清楚。直接回答，太长不读系列：

问题 1: 为什么换用 gunit？

> 在使用 GoConvey 的过程中，有一些问题一直困扰着我们，所以我们想了一个更能体现测试库中重点的替代方案，以解决这些问题。此时，我们已经无法完成过渡了。下面我会 **更** 仔细介绍一下，并提炼到[简明的宣明式结论](#conclusion)。

问题 2: 你是否建议大家都这么做（从 GoConvey 换成 gunit）？

> 不。我只建议你们使用能帮助你们达成目标的工具和库。你得先明确自己的需求，然后再尽快去找或着造适合自己的工具。测试工具是你们构建项目的基础。如果你对后面的内容产生了共鸣，那么你一定会对 gunit 有兴趣的。你得好好研究，然后慎重选择。GoConvey 的社区还在不断成长，并且拥有很多活跃的维护者。如果你很想支持一下这个项目，随时欢迎加入我们。

* * *

## 很久以前在一个遥远的星系...

### Go 测试

我们初次使用 Go 大概是在 Go 1.1 发布的时候 （也就是 2013年年中），在刚开始写代码的时候，我们很自然地接触到了 [`go test`](https://golang.org/cmd/go/#hdr-Test_packages) 和 [`"testing"` 包](https://golang.org/pkg/testing/)。我很高兴看到 testing 包被收进了标准库甚至是工具集中，但是对于它管用的方法并没有什么感觉。后文中，我们将使用著名的[“保龄球游戏” 练习](http://butunclebob.com/ArticleS.UncleBob.TheBowlingGameKata) 检验我们完成效果。（你可以花点时间熟悉一下[生产代码](https://github.com/smartystreets/gunit/blob/master/advanced_examples/bowling_game.go)，以便更好地了解后面的测试部分。）

下面是用标准库中的 `"testing"` 包编写保龄球游戏测试的一些方法：

```
import "testing"

// Helpers:

func (this *Game) rollMany(times, pins int) {
	for x := 0; x < times; x++ {
		this.Roll(pins)
	}
}
func (this *Game) rollSpare() {
	this.rollMany(2, 5)
}
func (this *Game) rollStrike() {
	this.Roll(10)
}

// Tests:

func TestGutterBalls(t *testing.T) {
	t.Log("Rolling all gutter balls... (expected score: 0)")
	game := NewGame()
	game.rollMany(20, 0)

	if score := game.Score(); score != 0 {
		t.Errorf("Expected score of 0, but it was %d instead.", score)
	}
}

func TestOnePinOnEveryThrow(t *testing.T) {
	t.Log("Each throw knocks down one pin... (expected score: 20)")
	game := NewGame()
	game.rollMany(20, 1)

	if score := game.Score(); score != 20 {
		t.Errorf("Expected score of 20, but it was %d instead.", score)
	}
}

func TestSingleSpare(t *testing.T) {
	t.Log("Rolling a spare, then a 3, then all gutters... (expected score: 16)")
	game := NewGame()
	game.rollSpare()
	game.Roll(3)
	game.rollMany(17, 0)

	if score := game.Score(); score != 16 {
		t.Errorf("Expected score of 16, but it was %d instead.", score)
	}
}

func TestSingleStrike(t *testing.T) {
	t.Log("Rolling a strike, then 3, then 7, then all gutters... (expected score: 24)")
	game := NewGame()
	game.rollStrike()
	game.Roll(3)
	game.Roll(4)
	game.rollMany(16, 0)

	if score := game.Score(); score != 24 {
		t.Errorf("Expected score of 24, but it was %d instead.", score)
	}
}

func TestPerfectGame(t *testing.T) {
	t.Log("Rolling all strikes... (expected score: 300)")
	game := NewGame()
	game.rollMany(21, 10)

	if score := game.Score(); score != 300 {
		t.Errorf("Expected score of 300, but it was %d instead.", score)
	}
}
```

对于之前使用过[xUnit](https://en.wikipedia.org/wiki/XUnit)的人， 下面两点会让你很难受：

1.  由于没有统一的`Setup`函数/方法可以使用，所有游戏中需要不断重复创建 game 结构。
2.  所有的断言错误信息都得自己写，并且混杂在一个 if 表达式中，由它来检验你所编写的断言语句。 在使用比较运算符 （`<`, `>`, `<=`, `>=`）的时候，这些否定断言会更加恼人。

所以，我们调研如何测试，深入了解为什么 Go 社区放弃了 [“我们最爱的测试帮手”](https://golang.org/doc/faq#testing_framework) 和“断言方法”](http://xunitpatterns.com/Assertion%20Method.html)的观点， 转而使用 [“表格驱动” 测试](https://github.com/golang/go/wiki/TableDrivenTests)来减少模板代码。 用表格驱动测试重新写一遍上面的例子：

```
import "testing"

func TestTableDrivenBowlingGame(t *testing.T) {
	for _, test := range []struct {
		name  string
		score int
		rolls []int
	}{
		{"Gutter Balls", 0, []int{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
		{"All Ones", 20, []int{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}},
		{"A Single Spare", 16, []int{5, 5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
		{"A Single Strike", 24, []int{10, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}},
		{"The Perfect Game", 300, []int{10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10}},
	} {
		game := NewGame()
		for _, roll := range test.rolls {
			game.Roll(roll)
		}
		if score := game.Score(); score != test.score {
			t.Errorf("FAIL: '%s' Got: [%d] Want: [%d]", test.name, score, test.score)
		}
	}
}
```

不错，这和之前的代码完全不一样。

优点：

1.  新的代码短多了！整套测试现在只有一个测试函数了。
2.  使用循环语句解决了 setup 重复的问题。
3.  同样的，用户只能从一条断言语句中获取错误码。
4.  在 debug 的过程中，可以很容易地在 struct 的定义中加一个 `skip bool` 来跳过一些测试

缺点：

1.  匿名 struct 的定义和循环的声明混在一起，看起来很奇怪。
2.  表格驱动测试只在一些比较简单的，只涉及数据读入/读出的情况下才比较有效。当情况逐渐复杂起来的时候，它会变得很笨重，也不容易（或者说不可能）用单一的 struct 对整个测试进行扩展。
3.  使用 slice 表示 throws/rolls 很“烦人”。虽然动动脑筋我们还是可以简化一下的，但是这会让我们的模板代码的[逻辑变复杂](http://xunitpatterns.com/Conditional%20Test%20Logic.html)。
4.  尽管只用写一条断言语句，但是这种间接/否定的测试还是让我很愤怒。

### [GoConvey](http://goconvey.co)

现在，我们不能仅仅满足于开箱即用的 `go test` ，于是我们开始使用 Go 提供的工具和库来实现我们自己的测试方法。 如果你仔细看过 [SmartyStreets GitHub page](https://github.com/smartystreets)， 你会注意到一个比较有名的仓库——GoConvey。它是我们对[Go OSS社区贡献](https://smartystreets.com/docs/oss)的最早的项目之一。

GoConvey 可以说是一个双管齐下的测试工具。首先，有一个测试运行器监控你的代码，在有变化的时候执行`go test`，并将结果渲染成炫酷的网页，然后用浏览器展示出来。其次，它提供了一个库让你可以在标准的`go test`函数中写行为驱动开发风格的测试。还有一个好消息：你可以自由选择不使用或者使用这些功能，也可以使用某些功能的组合。

有两个原因促使我们开发了 GoConvey： 重新开发一个我们本来打算在 [JetBrains IDEs](https://www.jetbrains.com/)中完成的测试运行器（我们当时用的是 ReSharper）以及创造一套我们很喜欢的像 [nUnit](http://nunit.org/) 和 [Machine.Specifications](https://github.com/machine/machine.specifications)（在开始使用 Go 之前我们是 .Net 商店）那样的测试组合和断言。

下面使用 GoConvey 重写上面测试的效果：

```
import (
	"testing"

	. "github.com/smartystreets/goconvey/convey"
)

func TestBowlingGameScoring(t *testing.T) {
	Convey("Given a fresh score card", t, func() {
		game := NewGame()

		Convey("When all gutter balls are thrown", func() {
			game.rollMany(20, 0)

			Convey("The score should be zero", func() {
				So(game.Score(), ShouldEqual, 0)
			})
		})

		Convey("When all throws knock down only one pin", func() {
			game.rollMany(20, 1)

			Convey("The score should be 20", func() {
				So(game.Score(), ShouldEqual, 20)
			})
		})

		Convey("When a spare is thrown", func() {
			game.rollSpare()
			game.Roll(3)
			game.rollMany(17, 0)

			Convey("The score should include a spare bonus.", func() {
				So(game.Score(), ShouldEqual, 16)
			})
		})

		Convey("When a strike is thrown", func() {
			game.rollStrike()
			game.Roll(3)
			game.Roll(4)
			game.rollMany(16, 0)

			Convey("The score should include a strike bonus.", func() {
				So(game.Score(), ShouldEqual, 24)
			})
		})

		Convey("When all strikes are thrown", func() {
			game.rollMany(21, 10)

			Convey("The score should be 300.", func() {
				So(game.Score(), ShouldEqual, 300)
			})
		})
	})
}
```

和表格驱动的方法一样，整个测试都包含在一个函数中。又像在原来的例子中一样，我们通过一个辅助函数进行重复的 rolls/throw。不同于其他的例子，我们现在已经拥有了一个巧妙的、简洁的、基于作用域的执行模型。所有的测试共享了 `game` 变量，但 GoConvey 的奇妙之处在于外层作用域执行的部分对内层的都有效。所以，每一个测试之间又相对隔离。显然，如果不注意初始化和作用域的话，你很容易就会陷入麻烦。

另外，当你将对 Convey 的调用加入到循环中时（例如尝试将 GoConvey 和表格驱动测试组合起来使用），可能会发生意想不到的事情。`*testing.T` 完全由顶层的 `Convey` 调用管理（你注意到它和其他的 `Convey` 稍有不同了吗？），因此你也不必在所有需要断言的地方都传递这个参数。但是如果用 GoConvey 写过任何稍微复杂点的测试的话，你就会发现取出辅助函数的过程相当复杂。在我决定绕过这个问题之前，我建了一个 `固定结构` 来存放所有测试的状态，然后在这个结构里创建 `Convey` 的回调会用到的函数。所以一会是 Convey 的块/作用域，一会又是固定结构和它的方法，这看起来就很奇怪了。

### [gunit](https://github.com/smartystreets/gunit)

所以，尽管我们花了点时间，但最终还是意识到我们只是想要一个 xUnit 的摒弃了奇怪的点导入和下划线包等级注册变量（看着你[GoCheck](https://labix.org/gocheck)）的 Go 版本。我们还是很喜欢 GoConvey 中的断言，因此从原来的项目中分裂出了一个[独立的仓库](https://github.com/smartystreets/assertions)，gunit 就这样诞生了：

```
import (
	"testing"

	"github.com/smartystreets/assertions/should"
	"github.com/smartystreets/gunit"
)

func TestBowlingGameScoringFixture(t *testing.T) {
	gunit.Run(new(BowlingGameScoringFixture), t)
}

type BowlingGameScoringFixture struct {
	*gunit.Fixture

	game *Game
}

func (this *BowlingGameScoringFixture) Setup() {
	this.game = NewGame()
}

func (this *BowlingGameScoringFixture) TestAfterAllGutterBallsTheScoreShouldBeZero() {
	this.rollMany(20, 0)
	this.So(this.game.Score(), should.Equal, 0)
}

func (this *BowlingGameScoringFixture) TestAfterAllOnesTheScoreShouldBeTwenty() {
	this.rollMany(20, 1)
	this.So(this.game.Score(), should.Equal, 20)
}

func (this *BowlingGameScoringFixture) TestSpareReceivesSingleRollBonus() {
	this.rollSpare()
	this.game.Roll(4)
	this.game.Roll(3)
	this.rollMany(16, 0)
	this.So(this.game.Score(), should.Equal, 21)
}

func (this *BowlingGameScoringFixture) TestStrikeReceivesDoubleRollBonus() {
	this.rollStrike()
	this.game.Roll(4)
	this.game.Roll(3)
	this.rollMany(16, 0)
	this.So(this.game.Score(), should.Equal, 24)
}

func (this *BowlingGameScoringFixture) TestPerfectGame() {
	this.rollMany(12, 10)
	this.So(this.game.Score(), should.Equal, 300)
}

func (this *BowlingGameScoringFixture) rollMany(times, pins int) {
	for x := 0; x < times; x++ {
		this.game.Roll(pins)
	}
}
func (this *BowlingGameScoringFixture) rollSpare() {
	this.game.Roll(5)
	this.game.Roll(5)
}
func (this *BowlingGameScoringFixture) rollStrike() {
	this.game.Roll(10)
}
```

可以看到, 去除辅助方法的过程很繁琐，这是因为我们是在操作结构级的状态，而不是函数的局部变量的状态。此外，xUnit 中配置/测试/清除的执行模型比 GoConvey 中的作用域执行模型好懂多了。这里，`*testing.T` 现在由嵌入的 `*gunit.Fixture` 管理。这种方式对于简单的和基于交互的复杂测试来说同样直接。

gunit 和 GoConvey 的另一个巨大区别是，按照 xUnit 的测试模式，GoConvey 使用[共享的固定结构](http://xunitpatterns.com/Shared%20Fixture.html)而gunit 使用[全新的固定结构](http://xunitpatterns.com/Fresh%20Fixture.html)。这两种方法都有道理，主要还是看你的应用场景。全新的固定结构通常在单元测试中更能让人满意，而共享的固定结构在一些配置消耗比较大的情况下更有利，例如集成测试/系统测试。

全新的固定结构更能保证分开的测试项之间是相互独立的，因此 gunit 默认使用 [`t.Parallel()`](https://golang.org/pkg/testing/#T.Parallel)。同样的，因为我们只用反射调用子测试，所以也可以使用 `--run` 参数挑选特定的测试项执行：

```
$ go test -v -run 'BowlingGameScoringFixture/TestPerfectGame'
=== RUN   TestBowlingGameScoringFixture
=== PAUSE TestBowlingGameScoringFixture
=== CONT  TestBowlingGameScoringFixture
=== RUN   TestBowlingGameScoringFixture/TestPerfectGame
=== PAUSE TestBowlingGameScoringFixture/TestPerfectGame
=== CONT  TestBowlingGameScoringFixture/TestPerfectGame
--- PASS: TestBowlingGameScoringFixture (0.00s)
    --- PASS: TestBowlingGameScoringFixture/TestPerfectGame (0.00s)
PASS
ok  	github.com/smartystreets/gunit/advanced_examples	0.007s
```

但不可否认, 一些之前的样本代码仍然存在（比如文件头部的一些代码）。 我们在 [GoLand](https://www.jetbrains.com/go/) 中安装了下面的实时模板，这些会自动生成前面大部分的内容。下面是在 GoLand 中安装实时模板的命令：

*   在 GoLand 中打开偏好设置。
*   在 `编辑器/实时模板` 中选中 `Go` 列表，然后点击  `+`  号并选择 “实时模板”
*   给他取个缩写名（我们用的是 `fixture`）
*   将下面的代码粘贴到 `模板文本` 区域：

```
func Test$NAME$(t *testing.T) {
    gunit.Run(new($NAME$), t)
}

type $NAME$ struct {
    *gunit.Fixture
}

func (this *$NAME$) Setup() {
}

func (this *$NAME$) Test$END$() {
}
```

*   在那之后，点击 “未指定应用上下文” 警告旁边的`定义`。
*   在 `Go` 前面打个勾然后点`好`。

现在我们只用打开一个测试文件，输入 `fixture` 然后用 tab 自动补全测试模板就行了。

## 结论

让我效仿[敏捷软件开发宣言](http://agilemanifesto.org/)的风格来做个总结：

> 我们不断实践、帮助他人，最终发现了更好的方法来进行软件**测试**。这让我们实现了很多有价值的东西：
>
> *   在**共享的固定结构**的基础上实现了**全新的固定结构**
> *   用巧妙的作用域语义实现了**简单的执行模型**
> *   用局部函数（或者说包级的）变量作用域实现了**结构级作用域**
> *   通过倒置的检查和手动创建的错误信息实现了**直接的断言函数**
>
> 也就是说，虽然其他的测试库也很不错（这是一方面） ，我们更喜欢 gunit（这是另一方面）。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
