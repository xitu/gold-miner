> * 原文地址：[Testing iOS Apps](http://merowing.info/2017/01/testing-ios-apps/)
* 原文作者：[krzysztofzablocki](http://merowing.info/hire/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Testing iOS Apps #

![](http://merowing.info/2017/01/testing.png)

Writing tests in iOS apps is a touchy subject. Not everyone is so privileged to be able to write tests full-time, for different reasons.

Some people have full control over their development process and choose not to write tests, maybe because they have had a bad experience with it or they just don’t see the value in them.

I would argue that if you are part of a smaller team, tests can even be more helpful than in big corporations.

A big corporation might have dedicated QA team, but if you are one of 2 developers, then you are often responsible for ensuring quality and reliability of your work, its considerable pressure because each feature you write might break something else in your app.

Let us look at practices and tips for writing maintainable tests in your iOS Apps.

## Basics ##

### Red - Green - Refactor ###

- **RED**: Write failing tests first.

- **GREEN**: Write whatever code it takes to make those tests pass.

- **REFACTOR**: Refactor code to improve quality. **Do not** skip this step.

Repeat this cycle until you have code that is clean and tested.

#### Benefits: ####

- Writing tests first gives you a clear perspective on the API design, by getting into the mindset of being a client of the API before it exists.

- Good tests serve as great documentation of expected behavior.

- It gives you confidence to constantly refactor your code because you know that if you break anything your tests fail.

- Do you understand the problem enough to write good test requirements?

- If tests are hard to write its usually a sign architecture could be improved. Following RGR helps you make improvements early on.

Its fine to write untested code to better understand problem at hand, and then rewrite it doing RGR once you have more understanding, the rewrite part is important because writing tests after the product code has been writen is significantly harder.

When you refactor production code, you should not be doing **RGR**. Instead, you should be going from Green to Green, thus ensuring you did not cause regression.

### [Arrange - Act - Assert](http://c2.com/cgi/wiki?ArrangeActAssert) ###

**AAA** is a pattern for arranging and formatting code in Unit Tests.

If you were to write pure XCTests each of your tests would group these functional sections, separated by blank lines:

- **Arrange** all necessary preconditions and inputs.

- **Act** on the object or method under test.

- **Assert** that the expected results have occurred.

```
func testArticleIsProvidedCorrectly() {
        let URL = ...
        let articleProvider = ArticleProvider()

        let article = articleProvider.articleFromURL(URL: URL)

        XCTAssertNotNil(article)
    }
```

#### Benefits ####

- Separates tested functionality from the setup and assertion.

- Clear focused on a minimal set of test steps.



- Makes test smells more evident:

	- Assertions intermixed with “Act” code.
	
	- Test methods that try to test too many different things at once.
	
	- Test methods that have to much setup are good sign refactor should happen

## Quality of test code ##

One of the most common complaints about testing I hear is the fact that they are hard to maintain.

Many people write good application code, but they write pretty bad test cases, because they treat tests as an artifact, something they do not need to care about so much.

I’ve to quote Klaas here:

> Tests are the first consumer of your API. If the first consumer has to do questionable things to work with the API, chances are your production code will too.

I think tests are part of your product. Consider putting them next to your classes in project structure to make it sink into your subconscious.
So what else can we do other than *RGR* and *AAA* to make test cases more maintainable?

### Use type-inferred factories ###

Instead of repeating the same initialization patterns, introduce simple factories and leverage type inference.

e.g. Instead of feeding each of your test cases different strings, make it easy to generate arbitrary length sentences:

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

This pattern allows your test cases to be light and highlight what matters, not deal with stubbing data.

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

Testing item placement and particular frames in your test suites is not going to end up well, when those kind of tests fail, most people just update the numbers with the expected ones and move on. Don’t do it.

Instead leverage [Snapshot tests](https://www.objc.io/issues/15-testing/snapshot-testing/), where you can easily see whether something is wrong with your layout.

They can also be very useful for Visual Quality Assurance sessions, as you can generate many different versions of the same UI element in a manner of few seconds.

**Note:** I recommend adding explicit approval for Screenshot changes in your project, otherwise people will do the same thing they can do with layouts, just update the snapshots to pass without thinking about it. You can use [danger](http://danger.systems) to inform users when a screenshot is changed.

### Write custom matchers ###

It often happens that we have to test similar kind of patterns, instead of repeating them, introduce custom matcher that can make this much easier.

e.g. Testing NSAttributedStrings can be PITA unless you create a simple matcher to make it easy:

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

Its convienent to be able to replace 3rd party dependencies in tests, so that we can test our object in isolation. Some classes Apple exposes don’t even have public interface for creating them e.g. `UITouch`.

One way to deal with those scenarios is to get rid of dependencies as soon as we can, e.g. Instead of relying on `UITouch` instances, we rely on our own protocol and we make `UITouch` adhere to it.

```
protocol TouchEvent {
    func location(in view: UIView?) -> CGPoint
    var view: UIView?
}

extension UITouch: TouchEvent {}
```

The added benefit is that we now control what interface we really care about, when we want to trigger something relying on `TouchEvent`s we can create a fake struct in our tests that adheres to `TouchEvent`.

In case of 3rd party dependencies, we should not be leaking them into our codebase even without testing so both using protocols and composition are going to be helpful.

[Keep in mind that protocols like anything else can be abused](http://chris.eidhof.nl/post/protocol-oriented-programming/)

### Limit public interfaces ###

You are responsible for testing all public interfaces, the less you have, the fewer tests you need, but more importantly, you avoid writing fragile tests, focusing on the big picture instead of implementation details.

Avoid testing private methods directly, only test behaviour of those methods via public interfaces.

[We should be programming to an interface, not an implementation.](http://www.artima.com/lejava/articles/designprinciples.html)

### Focus on readability ###

It is important that [a failing test should read like a high-quality bug report.](https://medium.com/javascript-scene/what-every-unit-test-needs-f6cd34d9836d#.kn8a3pyi8).

RSpec style of testing can improve this aspect of your test cases.

#### RSpec / BDD ####

[RSpec](http://rspec.info) is common with the behavior-driven development (BDD) process of writing human readable specifications that focus the development of your application.

For iOS I prefer [Quick](https://github.com/Quick/Quick) BDD framework and its “matcher framework,” called [Nimble](https://github.com/Quick/Nimble).

The main difference between BDD and TDD is the fact that BDD test cases can be read by non-engineers, which can be very useful in teams.

If you need to verify product requirements for the feature you are working on, you could copy the test specifications and ask your manager whether the expectations are correct, this often uncovers either lack of knowledge or wrong assumptions.

BDD R-Spec is more verbose than standard `XCTest`, but this is a good thing when you want to share it with your team, example specification might look like:

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

There are 3 scoping indicators in RSpec:

- `describe`

- `context`

- `it`

The purpose of “describe” is to wrap a set of tests against one functionality while “context” is to wrap a set of tests against one functionality under the same state.

#### `describe` ####

- `describe` is used for *Things*.

- `beforeEach` specifies what *Things* you are going to test.

```
describe("Observable") {
 beforeEach {
   sut = Observable(155)
 }
```

- Wording:

	- use function / object name.
	
	- add ‘when’ for grouping functionality together.

```
 describe("when using the transforming operator") {
    describe("map") {

```

#### `context` ####

- `context` is used for *State*.

- `beforeEach` lists the *Actions* to get to that state.

```
context("given a full queue") {
  beforeEach {
    (1...Queue.max).forEach { queue.insert( arc4random() ) }
  }
}
```

- Wording:

	- use ‘given’, ‘with’ or ‘when’, which ever makes it more readable

```
context("given the second observable has a send value")
context("with logged-in user")
```

#### `it` ####

- Immediately shows what’s broken.

- Most `it` blocks should solely contain an assertion.

- Prefer creating custom matchers (after first verifying they do not exist already) if you need multiple steps.

- Wording:

	- Don’t use ‘should’.
	
	- Say what will happen.
	
	- Running tests will verify whether it’s **true** or **false**.

```
it("sends transformed value to subscriber") {
    expect(received).to(equal("String containing 3"))
}

```

### Selectively running tests ###

- You can prefix any of the above keywords with:

	- “`x`” to disable specific group of tests temporarily
	
	- “`f`” to focus executing only specific group of tests to improve performance

- alternatively, replace them with `pending`, the difference between pending and “`x`” is that pending groups will be logged when running your tests.

**Note** : Be careful **not** to commit focused or disabled tests by mistake. It’s best if you use pre-commit hook to ensure that.

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

Usually `beforeEach` takes the role of **Arrange** and **Act**, leaving only the role of **Assert** to particular `it` tests.

In some scenarios, using `beforeEach` might make test smells less evident and make it harder to see AAA in action, you might consider performing **Act** and **Assert** in `it` directly, though be aware that sometimes this might **require refactoring** later on when adding more tests.

It’s up to each team to decide which approach they prefer.

[Related reading](https://robots.thoughtbot.com/lets-not)

## Conclusion ##

Writing maintainable tests in iOS is not that hard or time-consuming, once you get a hang out of it, it can even make you develop faster. The iteration cycle is much shorter with tests, which means you will get feedback faster.

Writing tests allows you to:

- Understand requirements better, communicate clearer with non-engineers

- Confidence to perform big refactorings

- Have better documentation. Good test suites serve as excellent documentation

- Focus on the feature in development

- Design better API’s, because you design it from the perspective of the user

- Limit available mutations and public interfaces

- Fewer bugs

Testing has increasing returns, the longer the project is alive, the more you appreciate the investments in tests you made in the beginning.

I’d like to thank [Paweł Dudek](https://twitter.com/eldudi) and [Klaas Pieter Annema](https://github.com/klaaspieter) for reviewing this article.

