> * 原文地址：[Nested Ternaries are Great](https://medium.com/javascript-scene/nested-ternaries-are-great-361bddd0f340)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/nested-ternaries-are-great.md](https://github.com/xitu/gold-miner/blob/master/TODO/nested-ternaries-are-great.md)
> * 译者：
> * 校对者：

# Nested Ternaries are Great

![](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)

> Note: This is part of the “Composing Software” series on learning functional programming and compositional software techniques in JavaScript ES6+ from the ground up. Stay tuned. There’s a lot more of this to come!
>
> [< Previous](https://medium.com/javascript-scene/the-hidden-treasures-of-object-composition-60cd89480381) | [<< Start over at Part 1](https://medium.com/javascript-scene/composing-software-an-introduction-27b72500d6ea)

Conventional wisdom would have you believe that nested ternaries are unreadable, and should be avoided.

> Conventional wisdom is sometimes unwise.

The truth is, _ternaries are usually much simpler than if statements._ People believe the reverse for two reasons:

1. They’re more familiar with if statements. Familiarity bias can lead us to believe things that aren’t true, even when we’re presented with evidence to the contrary.
2. People try to use ternary statements as if they’re if statements. That doesn’t work, because ternary expressions are _expressions, not statements._

Before we get into the details, let’s define a ternary expression:

A ternary expression is a conditional expression that evaluates to a value. It consists of a conditional, a truthy clause (the value to produce if the conditional evaluates to a truthy value), and a falsy clause (the value to produce if the conditional evaluates to a falsy value).

They look like this:

```
(conditional)
  ? truthyClause
  : falsyClause
```

### Expressions vs Statements

Several programming languages (including Smalltalk, Haskell, and most functional programming languages) don’t have if statements at all. They have `if` _expressions_, instead.

An if expression is a conditional expression that evaluates to a value. It consists of a conditional, a truthy clause (the value to produce if the conditional evaluates to a truthy value), and a falsy clause (the value to produce if the conditional evaluates to a falsy value).

Does that look familiar? Most functional programming languages use _ternary expressions_ for their `if` keyword. Why?

An expression is a chunk of code that evaluates to a single value.

A statement is a chunk of code that may not evaluate to a value at all. In JavaScript if statements _don’t evaluate to values_. In order for an if statement in JavaScript to do anything useful, it _must_ cause a side-effect or return a value from the containing function.

In functional programming, we tend to _avoid_ mutations and other side-effects. Since `if` in JavaScript naturally _affords_ mutation and side effects, many functional programmers reach for ternaries instead — nested or not. Including me.

Thinking in terms of ternary expressions is a bit different from thinking in terms of if statements, but if you practice a lot for a couple of weeks, you’ll start to gravitate towards ternaries naturally, if only because it’s less typing, as you’ll soon see.

### Familiarity Bias

The common claim I hear is that nested ternary expressions are “hard to read”. Let’s shatter that myth with some code examples:

```
const withIf = ({
  conditionA, conditionB
}) => {
  if (conditionA) {
    if (conditionB) {
      return valueA;
    }
    return valueB;
  }
  return valueC;
};
```

Note that in this version, there are nesting conditions and braces visually separating the truthy clause from the falsy clauses, making them feel very disconnected. This is fairly simple logic, but it’s a little taxing to parse.

Here’s the same logic written in ternary expression form:

```
const withTernary = ({
  conditionA, conditionB
}) => (
  (!conditionA)
    ? valueC
    : (conditionB)
    ? valueA
    : valueB
);
```

There are a few interesting points to be made here:

### Daisy Chaining vs Nesting

First, we’ve flattened out the nesting. “Nested” ternaries is a bit of a misnomer, because ternaries are easy to write in a straight line, you never need to nest them with indent levels at all. They simply read top to bottom in a straight line, returning a value as soon as they hit a truthy condition or the fallback.

If you write ternaries properly, there is no nesting to parse. It’s pretty hard to get lost following a straight line.

We should probably call them “chained ternaries” instead.

The second thing I want to point out is that, in order to simplify this straight line chaining, I switched up the order a little bit: If you get to the end of a ternary expression and find you need to write two colon clauses (`:`), grab the last clause, move it to the top, and reverse the logic of the first conditional to simplify parsing the ternary. No more confusion!

It’s worth noting that we can use the same trick to simplify the if statement form:

```
const withIf = ({
  conditionA, conditionB
}) => {
  if (!conditionA) return valueC;
  if (conditionB) {
    return valueA;
  }
  return valueB;
};
```

That’s better, but it still visually breaks up the related clauses for `conditionB`, which can cause confusion. I've seen that problem lead to logic bugs during code maintenance. Even with the logic flattened, this version is still more cluttered than the ternary version.

### Syntax Clutter

The `if` version contains a bit more noise: the `if` keyword vs `?`, `return` to force the statement to return a value, extra semicolons, extra braces, etc... Unlike this example, most if statements also mutate some outside state, which further adds to the extra code and complexity.

Extra code is bad for a few important reasons. I’ve said all this before but it’s worth repeating until every developer has it burned into their brain:

#### Working Memory

The average human brain has only a few shared resources for discrete [quanta in working memory](https://www.nature.com/articles/nn.3655), and each variable potentially consumes one of those quanta. As you add more variables, your ability to accurately recall the meaning of each variable is diminished. Working memory models typically involve 4–7 discrete quanta. Above those numbers, error rates dramatically increase.

When we force mutation or side-effects with if statements as opposed to ternaries, that often entails adding variables to the mix that don’t need to be there.

#### Signal to Noise Ratio

Concise code also improves the signal-to-noise ratio of your code. It’s like listening to a radio — when the radio is not tuned properly to the station, you get a lot of interfering noise, and it’s harder to hear the music. When you tune it to the correct station, the noise goes away, and you get a stronger musical signal.

Code is the same way. More concise code expression leads to enhanced comprehension. Some code gives us useful information, and some code just takes up space. If you can reduce the amount of code you use without reducing the meaning that gets transmitted, you’ll make the code easier to parse and understand for other people who need to read it.

#### Surface Area for Bugs

Take a look at the before and after functions. It looks like the function went on a diet and lost a ton of weight. That’s important because extra code means extra surface area for bugs to hide in, which means more bugs will hide in it.

> _Less code = less surface area for bugs = fewer bugs._

### Side Effects and Shared Mutable State

Many if statements do more than evaluate to a value. They also cause side-effects, or mutate variables, so you can’t see the complete effect of the if statement without also knowing the impact of those side effects and the full history of everything else that touches its shared mutable state.

Restricting yourself to returning a value forces discipline: severing dependencies so your program is easier to understand, debug, refactor, and maintain.

This is actually my favorite benefit of ternary expressions:

> _Using ternaries will make you a better developer._

### Conclusion

Since all ternaries are easy to arrange in a straight line, top to bottom, calling them “nested ternaries” is a bit of a misnomer. Let’s call them “chained ternaries”, instead.

Chained ternaries have several advantages over if statements:

* It’s always easy to write them so that they read in a straight line, top to bottom. If you can follow a straight line, you can read a chained ternary.
* Ternaries reduce syntax clutter. Less code = less surface area for bugs = fewer bugs.
* Ternaries don’t need temporary variables, reducing load on working memory.
* Ternaries have a better signal-to-noise ratio.
* If statements encourage side effects and mutation. Ternaries encourage pure code.
* Pure code decouples our expressions and functions from each other, so ternaries train us to be better developers.

### Learn More at EricElliottJS.com

Video lessons on functional programming are available for members of EricElliottJS.com. If you’re not a member, [sign up today](https://ericelliottjs.com/).

[![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)](https://ericelliottjs.com/product/lifetime-access-pass/)

* * *

**_Eric Elliott_** _is the author of_ [_“Programming JavaScript Applications”_](http://pjabook.com) _(O’Reilly), and_ [_“Learn JavaScript with Eric Elliott”_](http://ericelliottjs.com/product/lifetime-access-pass/)_. He has contributed to software experiences for_ **_Adobe Systems_**_,_ **_Zumba Fitness_**_,_ **_The Wall Street Journal_**_,_ **_ESPN_**_,_ **_BBC_**_, and top recording artists including_ **_Usher_**_,_ **_Frank Ocean_**_,_ **_Metallica_**_, and many more._

_He works remote from anywhere with the most beautiful woman in the world._


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
