> * 原文地址：[What's the longest keyword sequence in Javascript?](https://gist.github.com/lhorie/c0d9fd9b2aa215f4984f3ce1c8fd01bf)
> * 原文作者：[Leo Horie](https://mithril.js.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/longest-keyword-sequence.md](https://github.com/xitu/gold-miner/blob/master/TODO1/longest-keyword-sequence.md)
> * 译者：
> * 校对者：

# What's the longest keyword sequence in Javascript?

So there were a few threads going around recently about a challenge to write the longest sequence of keywords in Javascript:

* https://twitter.com/bterlson/status/1093624668903268352
* https://news.ycombinator.com/item?id=19102367

There are, however, a few problems:

* These solutions use non-keyword tokens (`null`, `true`, `false` are actually [Literals](https://tc39.github.io/ecma262/#prod-Literal), not [Keywords](https://tc39.github.io/ecma262/#prod-Keyword))
* One of the solutions isn't quite valid (`new super`)

Let's see if we can do better!

(...but first let's review the ground rules)

## Rules

1) Code must parse and run as valid Javascript. No ignoring [early errors](https://tc39.github.io/ecma262/#early-error), nuh-uh!
2) Only [keywords](https://tc39.github.io/ecma262/#sec-keywords) are allowed
3) The only other character allowed other than lower case letters are whitespaces
4) Cannot repeat keywords within the sequence
5) You can add as much preamble and postamble code as necessary

## Bonus Challenge

6) Line breaks are allowed between keywords
7) Keyword-like tokens are allowed

## The bar to meet

arjunb_msft starts off with this 15 word solution:

```js
function *f() {
  if (1);
  else do return yield delete true instanceof typeof void new class extends false in this {}; while (1)
}
```

Unfortunately, it uses `true` and `false`, which are ReservedWords, but not Keywords. It also throws an error in Chrome: `Uncaught SyntaxError: Unexpected token in`.

bluepnume is tied with this 15 word solution: 

```js
async function* foo() {
  return yield delete void await null in this instanceof typeof new class extends async function () {} {}
}
```

This one does run in Chrome, but it uses a `null`, which is also not a Keyword.

If we remove the `null` from the second solution, and combine ideas from the first, we can get a different but pedantically kosher 15 keyword solution:

```js
async function* foo() {
  if (0);
  else do return yield delete void await this instanceof typeof new class extends async function
  () {} {}; while (0)
}
```

Hooray!

## Bring the real fun

Now, while being super pedantic can be fun, it's not necessarily _fun_ fun.

But worry not, because just a bit downthread, bterlson added this [stipulation](https://twitter.com/bterlson/status/1093651943325483008): 

> Oh, and `this`, `null`, and `undefined` were considered keywords even though they aren't technically keywords. It made the contest more fun (plus editors color them as keywords so it makes some sense).

Technically technically, `this`  _is_ in fact a keyword. However, he's right about `null` and `undefined` not being keywords.

In the rest of the thread we can see `true` and `false` are also considered ok. This brings us to the question: if non-keyword tokens are ok to use, which tokens are kosher for this challenge?

What `null`, `true` and `false` have in common is that they are Literals whose token consist solely of letters (NumericLiterals and StringLiterals are obviously not allowed).

With NullLiterals and BooleanLiterals allowed, we can easily build up on the previous sequence and get this 17 word sequence:

```js
async function* foo() {
  if (0);
  else do return yield await delete void typeof null instanceof this in new class extends async function () {} {}; while (0);
}
```

What about `undefined`? Well, that's actually an Identifier. If we allow ASI, one can construct an infinite sequence of arbitrary identifiers, but that's not very interesting and, I think, not in the spirit of the challenge.

```js
a
b
c
// boooring
```

Instead, I think the spirit of the challenge is to use only tokens that _look like_ keywords (even if they are not technically Keywords in the spec)

Here are a few of those keyword-like-tokens-that-aren't-actually-keywords:

```js
let x
for (foo of bar) {}
class { static foo() {} }
import {foo as bar} from 'baz'
{get foo() {}, set foo() {}}
```

In case your hobbies don't include meticulously poring over ridiculously large programming language specifications, and you can't tell from a glance which of the tokens above are keywords and which aren't, here are the illegitimate ones: `let`, `of`, `static`, `as`, `from`, `get` and `set`. They sure _look_ like keywords though.

We could arguably also add things like `NaN` and `Infinity` to the list, since they fall in the same bucket as `undefined` (Identifiers that always point to the same value), but some might also argue that only lower case characters should be allowed, so let's leave those out. We probably should leave out `arguments` as well, since it doesn't get mentioned as a token in the grammar spec and thus it's really just a magic variable rather than a keyword.

Another one we will need to leave out is `new.target` because well, it has a period smack in the middle of it.

Some tokens such as `enum` and `public` are [FutureReservedTokens](https://tc39.github.io/ecma262/#prod-FutureReservedWord) and look an awful lot like keywords, especially if you are familiar with languages like Java. The problem is that they automatically become SyntaxErrors pretty much everywhere in the grammar, so we can't actually use them even if we allowed them...

```js
// the party poopers

let enum // SyntaxError
interface Bar {} // SyntaxError
package Baz; // SyntaxError
class {
  private foo() {} // SyntaxError
}
```

Now that we have separated the wheat from the chaff, what can we do?

Well, a LOT.

It turns out that due to historical backwards-compatibility reasons, in some cases many "keywords" act as... umm not keywords. We previously said that abusing ASI and Identifiers is boring, but did you know you that this is valid Javascript syntax?

```js
var undefined
typeof let
```

That's certainly not boring, and super promising, so in the name of fun, we just have to allow it :)

There's just one tiny last little detail to talk about. While the snippet above is interesting and eyebrow-raising, it has one ugly problem: it spans two lines. It's just unfortunate, but we need ASI to separate the two statements, so there's nothing we can do to put them on the same line.

Or is there?

Enter one of the obscure Unicode characters that the Javascript spec recognizes as a line terminator: the Paragraph Separator character (`\u2029`), which, when rendered properly, looks like this: <code></code>.

That's right. It's an _invisible character!_

Now, armed with knowledge of deliciously devious shenanigans, we can finally come up with this little monstrosity: 

```js
async function* foo() {
  from: set: while (0) {
    if (0)
    throw as  else this  null  continue from  false  break set  true  var let  debugger  do return yield await delete void typeof get instanceof static in new class of extends async function undefined
    () {} {}; while (0);
  }
}
```

Yes, that's valid Javascript that parses and runs on Chrome. And it has a sequence of __32 keywords in a single line!__

Granted, not all of them are _technically_ keywords, and this is probably the dirtiest abuse of ASI ever, but hey, it still falls within the spirit of the challenge. Besides, I'm having fun and that's what matters!

So, what do you think? Can you make a larger sequence? Can you figure out why this is syntactically valid? Is this cheating? Are gists the most misappropriated blogging platform ever? Comment below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
