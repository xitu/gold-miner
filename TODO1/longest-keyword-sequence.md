
# What's the longest keyword sequence in Javascript?

# Javascript 中的最长关键字序列是什么意思？
# Javascript 中的最长关键字序列长什么样子？

So there were a few threads going around recently about a challenge to write the longest sequence of keywords in Javascript:

最近有几个挑战主题关于使用 Javascript 编写最长关键字序列。
最近有几个关于使用 Javascript 编写最长关键字序列挑战主题。

* https://twitter.com/bterlson/status/1093624668903268352
* https://news.ycombinator.com/item?id=19102367

There are, however, a few problems:

但是，问题是：
但问题是：

* These solutions use non-keyword tokens (`null`, `true`, `false` are actually [Literals](https://tc39.github.io/ecma262/#prod-Literal), not [Keywords](https://tc39.github.io/ecma262/#prod-Keyword))
* One of the solutions isn't quite valid (`new super`)

* 这些解决方案使用非关键字标记(null、true、false实际上是文字，而不是关键字)
* 这些解决方案使用了非关键字标记(null、true、false实际上是普通标记，而不是关键字)

* 其中一个解决方案不是很有效

@@ -33,15 +33,15 @@ Let's see if we can do better!

(...but first let's review the ground rules)

(但是我们首先的温故一些基础规则)
(但是我们首先的回顾一些基础规则)
## Rules
1) Code must parse and run as valid Javascript. No ignoring [early errors](https://tc39.github.io/ecma262/#early-error), nuh-uh!
2) Only [keywords](https://tc39.github.io/ecma262/#sec-keywords) are allowed
3) The only other character allowed other than lower case letters are whitespaces
4) Cannot repeat keywords within the sequence
5) You can add as much preamble and postamble code as necessary
## 规则
1) 代码必须作为有效的 Javascript 进行解析和运行。不能忽略[早期错误]
1) 代码必须能作为有效的 Javascript 进行解析和运行。不能忽略 [early errors]
2) 只允许使用关键字
3) 除小写字母外，其它唯一允许的字符是空格
4) 不能在序列中重复使用一个关键字
@@ -55,9 +55,11 @@ Let's see if we can do better!
7) 允许使用类似关键字的标记

## The bar to meet

##  进入正题
arjunb_msft starts off with this 15 word solution:

[@arjunb_msft](https://twitter.com/arjunb_msft) 提出的最长15个关键字程序

```js
function *f() {
  if (1);
@@ -67,8 +69,11 @@ function *f() {

Unfortunately, it uses `true` and `false`, which are ReservedWords, but not Keywords. It also throws an error in Chrome: `Uncaught SyntaxError: Unexpected token in`.

bluepnume is tied with this 15 word solution: 
不幸的是，他的方法里使用了保留字 `true` 和 `false`，而两者实际上不是关键字。在 Chrome 中运行程序也会抛出一个错误:“Uncaught SyntaxError: Unexpected token in”。

[@bluepnume](https://news.ycombinator.com/user?id=bluepnume) is tied with this 15 word solution: 

[@bluepnume](https://news.ycombinator.com/user?id=bluepnume)提出15个关键字的方案是：
```js
async function* foo() {
  return yield delete void await null in this instanceof typeof new class extends async function () {} {}
@@ -77,8 +82,12 @@ async function* foo() {

This one does run in Chrome, but it uses a `null`, which is also not a Keyword.

这段程序可以在 Chrome 中运行，但是程序中使用了 `null` 标记，这也不是一个关键字。

If we remove the `null` from the second solution, and combine ideas from the first, we can get a different but pedantically kosher 15 keyword solution:

如果我们从第二个解决方案中剔除 `null` ，并结合第一个解决方案，我们可以得到一个不同的，但有些卖弄的，15 个关键字解决方案:

```js
async function* foo() {
  if (0);
@@ -89,22 +98,37 @@ async function* foo() {

Hooray!

## Bring the real fun
哦耶！

## Bring the real fun
## 更有趣的在这儿
Now, while being super pedantic can be fun, it's not necessarily _fun_ fun.

虽然这样做没什么意思，但卖弄知识却很有趣。

But worry not, because just a bit downthread, bterlson added this [stipulation](https://twitter.com/bterlson/status/1093651943325483008): 

> Oh, and `this`, `null`, and `undefined` were considered keywords even though they aren't technically keywords. It made the contest more fun (plus editors color them as keywords so it makes some sense).
但不用担心，因为在下面的讨论中 [Bterlson](https://twitter.com/bterlson) 作了这样的补充:
> `this`、`null`和 `undefined` 可以认为是关键字，即使它们在技术上不是关键字。这使得比赛更有趣（加上编辑们把它们涂成关键字，所以这么说也行得通）
Technically technically, `this`  _is_ in fact a keyword. However, he's right about `null` and `undefined` not being keywords.

从技术层面讲，`this` 实际上是一个关键字。 但是，Bterlson 对 `null` 和 `undefined` 不是技术上关键字的认定却是正确的。

In the rest of the thread we can see `true` and `false` are also considered ok. This brings us to the question: if non-keyword tokens are ok to use, which tokens are kosher for this challenge?

在余下部分，我们可以看到 `true` 和 `false` 也被当作关键字使用。这就给我们带来了一个问题：如果可以使用非关键字标记，那么对于这个挑战，哪些标记更合适？

What `null`, `true` and `false` have in common is that they are Literals whose token consist solely of letters (NumericLiterals and StringLiterals are obviously not allowed).

`null`、`true` 和 `false` 的共同点是它们都是由字母组成的文本标记（显然，字符串和数字文本不能组成标记） 

With NullLiterals and BooleanLiterals allowed, we can easily build up on the previous sequence and get this 17 word sequence:

由于可以使用 null 字符和 boolean 字符，我们可以轻松地复现出先前的序列，并构建17个单词长度的序列：

```js
async function* foo() {
  if (0);
@@ -114,6 +138,8 @@ async function* foo() {

What about `undefined`? Well, that's actually an Identifier. If we allow ASI, one can construct an infinite sequence of arbitrary identifiers, but that's not very interesting and, I think, not in the spirit of the challenge.

那 `undefined` 呢？它实际上是一个标识符。如果允许 ASI，那我们就可以使用任意标识符去构造一个无限序列，但这就索然无味了，也失去了挑战的乐趣。

```js
a
b
@@ -123,8 +149,12 @@ c

Instead, I think the spirit of the challenge is to use only tokens that _look like_ keywords (even if they are not technically Keywords in the spec)

我倒认为这项挑战的精神在于仅使用 _类似_ 关键字的标记完成挑战 (即使这些类似关键字的标记在技术层面不能算作规范的关键字)

Here are a few of those keyword-like-tokens-that-aren't-actually-keywords:

下面是一些像是关键字实际上不是关键字的标记：

```js
let x
for (foo of bar) {}
@@ -135,12 +165,20 @@ import {foo as bar} from 'baz'

In case your hobbies don't include meticulously poring over ridiculously large programming language specifications, and you can't tell from a glance which of the tokens above are keywords and which aren't, here are the illegitimate ones: `let`, `of`, `static`, `as`, `from`, `get` and `set`. They sure _look_ like keywords though.

如果你不喜欢仔细研究编程语言诸多的规范，而且你一眼就看不出上面的哪些标记是关键字，哪些不是关键字，那么下面的标记都可以当作是关键字： `let`、`of`、`static`、`as`、`from`、`get`、`set`。它们看起来也确实像关键字。

We could arguably also add things like `NaN` and `Infinity` to the list, since they fall in the same bucket as `undefined` (Identifiers that always point to the same value), but some might also argue that only lower case characters should be allowed, so let's leave those out. We probably should leave out `arguments` as well, since it doesn't get mentioned as a token in the grammar spec and thus it's really just a magic variable rather than a keyword.

我们可能认为不可以往上面的列表中添加 `NaN` 和 `Infinity` 之类的东西，是因为它们与 `undefined` 属于同一个类型，都是标识符（标识符总是指向相同的值），也可能是由于只允许使用小写字符。不管怎样，我们将它们排除在外。我们也应该省略排除 `atguments`，因为在语法规范中它没有作为标记出现，因此它实际上只是一个magic 变量，而不是关键字。

Another one we will need to leave out is `new.target` because well, it has a period smack in the middle of it.

另一个我们需要排除是 `new.target`，因为它中间有一个“.”。

Some tokens such as `enum` and `public` are [FutureReservedTokens](https://tc39.github.io/ecma262/#prod-FutureReservedWord) and look an awful lot like keywords, especially if you are familiar with languages like Java. The problem is that they automatically become SyntaxErrors pretty much everywhere in the grammar, so we can't actually use them even if we allowed them...

一些标记例如 `enum` 和 `public` 是保留字，它们看起来非常像关键字，特别是如果你熟悉像 Java 这样的语言。问题是，它们在语法中几乎处处都会自动变成语法错误，所以即使我们允许使用它们，也不能真正地使用它们…

```js
// the party poopers
@@ -154,42 +192,74 @@ class {

Now that we have separated the wheat from the chaff, what can we do?

既然我们已经理清了规则，我们接下来能做什么呢？

Well, a LOT.

当然有很多啦

It turns out that due to historical backwards-compatibility reasons, in some cases many "keywords" act as... umm not keywords. We previously said that abusing ASI and Identifiers is boring, but did you know you that this is valid Javascript syntax?

由于一贯的向后兼容性问题，在某些情况下，许多“关键字” 充当......呃，不能称它们为关键词。我们之前说过滥用 ASI 和标识符很无聊，但你知道吗？，在 Javascript 他们却是有效的语法。

```js
var undefined
typeof let
```

That's certainly not boring, and super promising, so in the name of fun, we just have to allow it :)
That's certainly not boring, and super promising, so in the name of fun, we just have to allow it 

这当然不是无聊的，而且非常有希望，所以以娱乐的名义，我们必须允许它。

There's just one tiny last little detail to talk about. While the snippet above is interesting and eyebrow-raising, it has one ugly problem: it spans two lines. It's just unfortunate, but we need ASI to separate the two statements, so there's nothing we can do to put them on the same line.

最后还有一个小细节要谈。虽然上面的代码片段很有趣，而且让人眼花缭乱，但它有一个问题：它跨越了两行。很不幸，但我们需要 ASI 将这两个语句分开，所以我们无法将它们放在同一行。

Or is there?

或者这样做：

Enter one of the obscure Unicode characters that the Javascript spec recognizes as a line terminator: the Paragraph Separator character (`\u2029`), which, when rendered properly, looks like this: <code></code>.

输入一个段落分隔符(`\u2029`),如果正确呈现，它看起来如下：

什么都看不见？这就对了！这是一个隐形变量。

That's right. It's an _invisible character!_

Now, armed with knowledge of deliciously devious shenanigans, we can finally come up with this little monstrosity: 

现在，有了上面的知识储备，我们可以提出自己的解决方案：

```js
async function* foo() {
  from: set: while (0) {
    if (0)
    throw as  else this  null  continue from  false  break set  true  var let  debugger  do return yield await delete void typeof get instanceof static in new class of extends async function undefined
      throw as
    else this
    null
    continue from
    false
    break set
    true
    var let
    debugger
    do return yield await delete void typeof get instanceof static in new class of extends async function undefined
    () {} {}; while (0);
  }
}
```

Yes, that's valid Javascript that parses and runs on Chrome. And it has a sequence of __32 keywords in a single line!__

你没看错，这就是在 chrome 上解析和运行有效的 javascript 程序。它是在一行中有 32 个关键字的序列！

Granted, not all of them are _technically_ keywords, and this is probably the dirtiest abuse of ASI ever, but hey, it still falls within the spirit of the challenge. Besides, I'm having fun and that's what matters!

当然，并不是所有的关键词都是技术层面的，这可能是 ASI 有史以来最严重的滥用，但是，这仍然有挑战精神。另外，我很开心，这才是最重要的！

So, what do you think? Can you make a larger sequence? Can you figure out why this is syntactically valid? Is this cheating? Are gists the most misappropriated blogging platform ever? Comment below!
那么，你觉得呢？你能做一个更长的序列吗？你能弄明白为什么这在语法上是有效的吗？这是作弊吗？Gists [译者注：原文发布在gist上]是有史以来最被滥用的博客平台吗？下面评论！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
