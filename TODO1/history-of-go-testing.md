> * 原文地址：[A History of Testing in Go at SmartyStreets](https://smartystreets.com/blog/2018/03/history-of-go-testing)
> * 原文作者：[Michael Whatcott]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/history-of-go-testing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/history-of-go-testing.md)
> * 译者：
> * 校对者：

# A History of Testing in Go at SmartyStreets

I was recently [asked two interesting questions](https://github.com/smartystreets/goconvey/issues/360#issuecomment-368348056):

1.  Why did you move (from [GoConvey](http://goconvey.co)) to [gunit](https://github.com/smartystreets/gunit)?
2.  Are you recommending folks do the same?

These are great questions, and since I’m a co-creator of GoConvey and principle author of gunit I feel responsible to give a thorough answer. For the impatient, here’s the TL;DR:

Question 1: Why did you move to gunit?

> After using GoConvey and feeling consistent friction with that approach, we came up with an alternate approach that was more aligned with what we value in a testing library and which eliminated said friction. At that point, we couldn’t not make the transition. I go into **a lot** more detail below, eventually culminating in a [succinct, manifesto-style conclusion](#conclusion).

Question 2: Are you recommending folks do that same (move from GoConvey to gunit)?

> No. What I recommend is that you use only those tools and libraries that facilitate accomplishing your objectives. Get really specific about your requirements for testing tools and then set out to acquire and/or create them as quickly as possible. Testing tools are the foundation upon which you build your whole enterprise. If the rest of this article resonates with you, then gunit might be a compelling option for your consideration. Study things out and make a deliberate choice. The GoConvey community is still going strong and has active maintainers. Feel free to get involved if you feel strongly about supporting the project.

* * *

## A long time ago, in a galaxy far, far away…

### Go Test

We first started using Go right around the release of Go 1.1 (so, around mid-2013). As we begain getting our feet wet and writing actual code, we naturally came across [`go test`](https://golang.org/cmd/go/#hdr-Test_packages) and the [`"testing"` package](https://golang.org/pkg/testing/). I was happy to see testing baked into the standard library and even the tooling, but was not excited about the idiomatic approach to testing in Go. For the remainder of this article, we’ll use the famous [“Bowling Game” kata](http://butunclebob.com/ArticleS.UncleBob.TheBowlingGameKata) as a mutating illustration of the various approaches to testing we’ve employed. (You may want to take a moment to familiarize yourself with [the production code](https://github.com/smartystreets/gunit/blob/master/advanced_examples/bowling_game.go) for the test suites presented.)

Here are a few ways to write the bowling game tests using nothing but the standard library `"testing"` package:

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

If you’re coming from an [xUnit](https://en.wikipedia.org/wiki/XUnit) background, you’ll immediately be frustrated by two things:

1.  The creation of the game construct is repeated as there is no inherent `Setup` function/method.
2.  The assertion failure messages are all hand-constructed and nested within an if statement that checks for the opposite of the assertion you would normally craft. This kind of negated assertion becomes even more annoying when comparison operators are involed (`<`, `>`, `<=`, `>=`).

So, we researched more about testing and how the Go community purposefully left out [“our favorite test helpers”](https://golang.org/doc/faq#testing_framework) and the concept of [“assertions methods”](http://xunitpatterns.com/Assertion%20Method.html) in favor of the boilerplate-reducing promise of [“table-driven” tests](https://github.com/golang/go/wiki/TableDrivenTests). Here’s that same suite of tests reimagined using table-driven tests:

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

Ok, this is completely different.

The good:

1.  It’s a lot shorter! There’s now just a single test function for the entire suite of tests.
2.  The repetitive setup has been consolidated by the for loop.
3.  Similarly, there’s now only one assertion to get wrong code.
4.  It’s easy to add a `skip bool` to the struct definition to allow skipping of individual tests for debugging.

The bad:

1.  The anonymous struct definition mixed into the for loop declaration is strange looking.
2.  The table-driven approach works in very simple data-in/data-out scenarios but doesn’t scale to more complex scenarios where it becomes cumbersome (or impossible) to represent your entire test suite cleanly in a single struct.
3.  The slice representing throws/rolls is very ‘noisy’. A little ingenuity would allow us to simplify the throw/roll declaractions, but that would introduce [more complicated logic](http://xunitpatterns.com/Conditional%20Test%20Logic.html) into the test boilerplate.
4.  Even though there’s only one assertion to code, it’s still indirect/negated and gets under my skin.

### [GoConvey](http://goconvey.co)

At this point we just couldn’t be content with the out-of-the-box `go test` experience so we set out to implement our own approach on top of the tool and library provided by Go. If you’ve perused the [SmartyStreets GitHub page](https://github.com/smartystreets), you may have noticed a somewhat popular repository called GoConvey, one of our very first [contributions to the Go OSS community](https://smartystreets.com/docs/oss).

GoConvey is a two-pronged testing tool. The first is a test runner that watches your code for changes, runs `go test`, and displays a fancy rendering of the results in a web browser. The second is a library that allows you to write BDD-style tests inside standard `go test` functions. Good news: You can use either or both or neither of these aspects of the GoConvey project.

Our main reason for creating GoConvey was two-fold: recreate the kind of test runner we left behind in [JetBrains IDEs](https://www.jetbrains.com/) (we were using ReSharper) and the kind of test composition and assertions we enjoyed using libraries like [nUnit](http://nunit.org/) and [Machine.Specifications](https://github.com/machine/machine.specifications) (we were a .Net shop previous to picking up Go).

Here’s what the same test suite would look like in a GoConvey test suite:

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

Like the table-driven approach, the entire suite is contained in a single function. Like the original example, we are making use of a few helpers to make repeated rolls/throws. Unlike either example there is now a clever, a word which here means [non](https://github.com/smartystreets/goconvey/issues/4)-[trivial](https://github.com/smartystreets/goconvey/issues/81) and [scope-based](https://github.com/smartystreets/goconvey/issues/248), [execution model](https://github.com/smartystreets/goconvey/wiki/Execution-order) in play. The `game` variable is shared by the entire suite but the magic of GoConvey is that each outer scope is executed for each of the inner scopes. So, each test case has a degree of isolation. Obviously, if you aren’t careful about initialization and scoping you can get into trouble.

Also, when you wrap calls to `Convey` in for loops (like trying to combine GoConvey and table-driven tests), weird things can happen. The `*testing.T` is completely managed by the top-level `Convey` call (did you notice it’s slightly different from all other `Convey` calls?) and so you don’t need to pass it around to make assertions, but if you’ve written any reasonably complex test suites with GoConvey you’ll know that it’s actually pretty cumbersome to extract helper functions. What I’ve done before to get around this is create a `Fixture struct` to hold all the state for a test suite and then create methods on that struct which I then call from the `Convey` callbacks. So there’s the Convey block/scope and then, somewhere else, there’s the Fixture and its methods. It gets wierd.

### [gunit](https://github.com/smartystreets/gunit)

So, it took a while but in the end we realized that we really just wanted xUnit for Go, but without any of the wierd dot-imports or underscored package-level registration variables (lookin’ at you [GoCheck](https://labix.org/gocheck)). We also were still very much in favor of the assertions used by GoConvey. So, they ended up being split to [their own repository](https://github.com/smartystreets/assertions) and then gunit was born:

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

As you can see, it’s trivial to extract helper methods because we are operating on struct-level state, not a function’s local variable state. Also, the Setup/Test/Teardown execution model of xUnit is so much simpler to understand (and implement) than GoConvey’s scoped execution model. The `*testing.T` is now managed by the embedded `*gunit.Fixture`. This approach is equally straightforward for simple scenarios as well as the most complex interaction-based test you might find.

Another important contrast between gunit and GoConvey is that in terms of xUnit Test Patterns, GoConvey employs [shared fixtures](http://xunitpatterns.com/Shared%20Fixture.html) where gunit uses [fresh fixtures](http://xunitpatterns.com/Fresh%20Fixture.html). Both have a place, depending on your context. Fresh fixtures are generally more desirable in a unit test context, whereas a shared fixture might be more advantageous in an integration/systems testing context where there is expensive setup.

The concept of fresh fixtures makes it much easier to ensure that separate test cases are truly isolated. This allows gunit to use [`t.Parallel()`](https://golang.org/pkg/testing/#T.Parallel) by default. Also, because we are simply using reflection to invoke subtests, it’s possible to use the `-run` parameter to single out specific test cases:

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

Admittedly, there’s a bit of boilerplate still present (the stuff at the top of the fixture file). We’ve installed the following live template into [GoLand](https://www.jetbrains.com/go/) which automates most of that. Here are instructions for installing that live template in GoLand:

*   In GoLand, open preferences.
*   Under `Editor/Live Templates` highlight the `Go` list and click the `+` sign and choose “Live Template”.
*   Give it an abbreviation (we use `fixture`)
*   Paste the following into the `Template text` area:

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

*   Underneath that, click on `Define` next to the warning about “No applicable context yet”.
*   Put a check in the `Go` box and then click `OK`.

Now, when opening a test file, just type `fixture` and let the tab-completion fill in the template.

## Conclusion

Allow me to couch our conclusions in the style of the [Manifesto for Agile Software Development](http://agilemanifesto.org/):

> We are uncovering better ways of **testing** software by doing it and helping others do it. Through this work we have come to value:
> 
> *   **Fresh fixtures** over shared fixtures
> *   **Simple execution models** over clever scoping semantics
> *   **Struct-level scope** over local function (or package-level) variable scope
> *   **Straightforward assertion functions** over inverted checks and hand-crafted failure messages
> 
> That is, while there is value in the way the other testing libraries operate (items on the right), we value the way gunit works more (items on the left).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
