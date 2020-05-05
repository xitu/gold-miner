> * 原文地址：[Magic Numbers Are Not That Magic](https://medium.com/better-programming/magic-numbers-are-not-that-magic-132297d435f5)
> * 原文作者：[Steven Popovich](https://medium.com/@steven.popovich)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/magic-numbers-are-not-that-magic.md](https://github.com/xitu/gold-miner/blob/master/TODO1/magic-numbers-are-not-that-magic.md)
> * 译者：
> * 校对者：

# Magic Numbers Are Not That Magic

> A better solution for hardcoded numbers

![Photo by [Maail](https://unsplash.com/@maail?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/feathers?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/9562/1*fzMDTQAsZ8D9O3YXJwLW5A.jpeg)

I really dislike the phrase **magic number**. I see so many people get it wrong. I have seen and had multiple code reviews where someone sees any digits in code and comments, “Oh this is a magic number, make sure you put it up top with a name.”

(I also really dislike the fact that we feel the need to put all the variables to the top of a file, but that’s for another day.)

Developers, you are allowed to use your numpad in your code. Just be careful of how you do.

## What Is a Magic Number?

I mean, you can google it and get a bunch of lame definitions, but the bottom line is that a magic number is a number in your code that is hard to reason about.

```kotlin
fun generate() {
    for (i in 0 until 52) {
        deck[i] = uniqueCard()
    }
}
```

Where does 52 come from?

Well, it turns out that this is code to generate a deck of cards because 52 is the number of cards in a deck. Let’s give the number a name.

```kotlin
const val numberOfCardsInADeck = 52

fun generate() {
    for (i in 0 until numberOfCardsInADeck) {
        deck[i] = uniqueCard()
    }
}
```

This is code that’s more readable, more maintainable, and better. Great, you have mastered clean code.

No, this is just the tip of the iceberg. The thing with this example (and this is a very common example) is that a developer probably could have easily figured out what the hell 52 was from the rest of the code. This is a pretty tame magic number.

Where magic numbers really bite you is when they come from nowhere. Take this code for tuning a search algorithm:

```kotlin
fun search(query: String) {
    find(query, 2.4f, 10.234f, 999, Int.MAX_VALUE, false)
}
```

What the heck do these numbers mean? It’s not easy to understand what these numbers are for and what they do.

## What’s the Problem With Magic Numbers?

Let’s say your app grows in size and has a bunch more things to search through, and all of a sudden your search results are not exactly yielding what you want.

We have the bug “when I search for ‘frosted flakes’, the cereal doesn’t come up in the results, even though I know it’s in there.”

So you, Joe Schmo, four years after this algorithm was originally tuned, need to change these values around to fix this bug. What do you change first?

This is the problem with magic numbers. These numbers would have been much better off grouped together with long, descriptive names, along with in-code documentation about how changing them affects the results.

Bonus points for explaining the algorithm, too.

Let’s fix this:

```kotlin
const val searchWeight = 2.4f // How specific your query must be. Increase this number to get more fuzzy results
const val searchSpread = 10.234f // How spread the result are. Selects more words in a row in the database
const val searchPageSize = 999 // The number of results we want per search page
const val searchMaxResults = Int.MAX_VALUE // We want every possible result from the search
const val shouldSearchIndex = false // We don't want to search indicies 

fun search(query: String) {
    find(query, searchWeight, searchSpread, searchPageSize, searchMaxResults, shouldSearchIndex)
}

// Calls our weighted search algorithim. Read the docs about this alogirthim at foo.bar.com
fun find(query: String, weight: Float, spread: Float, pageSize: Int, maxResults: Int, index: Boolean) {}
```

Wouldn’t you feel more comfortable working on code like this? You might even have an idea of what to change to get started. Tuning search can be difficult, but someone would be much more well-equipped to tackle this bug with this documentation.

## What Isn’t a Magic Number?

In reality, numbers that are hard to reason about don’t come up as often as numbers that are easy to reason about. Take these hardcoded numbers

```kotlin
view.height = 42
```

This is not a magic number. I repeat: This is not a magic number.

I know. I am giving some Java purists and clean freaks an aneurysm.

But this number is not hard to reason about. Its idea is entirely self-contained. The height of this view is 42**.** It just is. What value is added by giving it a name, like this?

```kotlin
const val viewHeight = 42

fun buildView() {
    view.height = viewHeight
}
```

This is just code bloat. It may seem like a small example, but this idea of needlessly naming numbers quickly puffs up the size of UI code and only serves to increase the number of lines of code.

## Wait, So Can I Use Numbers in My Code or Not?

Of course. There is plenty of good code in the world with numbers in it. You just need to keep in mind a few things:

* Make sure your numbers are easily understandable — like, a child could figure out where the number comes from.
* If you are changing a number around, tuning something, or doing some calculation on paper to get a hardcoded number, explain it. In the code. Next to the number. Or at least in the commit. Changes of hardcoded numbers should be explained.
* Bonus: Make sure your hardcoded numbers are DRY.

It’s not rocket science, but there is a lot of subtlety in using your number row.

You’ll be fine. Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
