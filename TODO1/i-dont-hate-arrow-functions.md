> * 原文地址：[I Don’t Hate Arrow Functions](https://davidwalsh.name/i-dont-hate-arrow-functions)
> * 原文作者：[Kyle Simpson](https://github.com/getify)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/i-dont-hate-arrow-functions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/i-dont-hate-arrow-functions.md)
> * 译者：
> * 校对者：

# I Don’t Hate Arrow Functions

## TL;DR

Arrow functions are fine for certain usages, but they have so many variations that they need to be carefully controlled to not break down the readability of the code.

While arrow functions clearly have a ubiquitous community consensus (though not unanimous support!), it turns out there's a wide variety of opinions on what makes "good" usage of `=>` and not.

Configurable linter rules are the best solution to wrangling the variety and disagreement of arrow functions.

I released [**proper-arrows** ESLint plugin](https://github.com/getify/eslint-plugin-proper-arrows) with several configurable rules to control `=>` arrow functions in your code base.

## Opinions are like noses...

Anyone who's followed me (tweets, books, courses, etc) for very long knows that I have lots of opinions. In fact, that's the only thing I'm an expert on -- my own opinions -- and I'm never at a loss for them!

I don't subscribe to the "strong opinions, loosely held" mantra. I don't "loosely hold" my opinions because I don't see any point in having an opinion if there isn't sufficient reason for that opinion. I spend a lot of time researching and tinkering and writing and trying out ideas before I form an opinion that I would share publicly. By that point, my opinion is pretty strongly held, by necessity.

What's more, I teach based on these opinions -- thousands of developers in different companies all over the world -- which affords me the opportunity to deeply vet my opinions through myriad discussion and debate. I'm tremendously privleged to be in such a position.

That doesn't mean I can't or won't change my opinions. As a matter of fact, one of my most strongly held opinions -- that JS types and coercion are useful in JS -- has been shifting lately, to a fairly significant degree. I have a much more rounded and deepened perspective on JS types and why type-aware tooling can be useful. And even my opinion on `=>` arrow functions, the punchline of this article, has evolved and deepened.

But one of the things many people tell me they appreciate about me is, I don't just state opinions, I back those opinions up with careful, thought-out reasoning. Even when people vehemently disagree with my opinions, they often compliment me on at least owning those opinions with backing.

And I try to inspire the same in others through my speaking, teaching, and writing. I don't care if you agree with me, I only care that you know why you have an technical opinion and can earnestly defend it with your own line of reasoning. To me, that's a healthy relationship with technology.

## Arrow Functions != `function`s

It is my sincere belief that the `=>` arrow function is not suitable as a general purpose replacement for all (or even most) `function` functions in your JS code. I genuinely don't find them more readable in most cases. And I'm not alone. Any time I [share an opinion like that](https://twitter.com/getify/status/1105182569824346112) on social media, I often [get dozens](https://twitter.com/bence_a_toth/status/1105185760448311296) of ["me too!" responses](https://twitter.com/joehdodd/status/1105185789942603777) peppered in with [the scores](https://twitter.com/kostitsyn/status/1105229763369680896) of "you're [totally wrong!](https://twitter.com/fardarter/status/1105347990225649664)" responses.

But I'm not here to rehash the entire debate over `=>` arrow functions. I've written extensively about my opinions on them, including these sections in my books:

* ["You Don't Know JS: ES6 & Beyond", Ch2, "Arrow Functions"](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch2.md#arrow-functions)
* ["Functional-Light JavaScript", Ch2, "Functions Without `function`"](https://github.com/getify/Functional-Light-JS/blob/master/manuscript/ch2.md/#functions-without-function) (and the preceding section on function names).

Whatever your preferences around `=>`, to suggest that it's **only** a **better** `function` is to be plainly reductive. It's a far more nuanced topic than just a one-to-one correspondence.

There are things to like about `=>`. You might find that surprising for **me** to say, since most people seem to assume I hate arrow functions.

I don't (hate them). I think there are definitely some important benefits.

It's just that I don't unreservedly endorse them as the new `function`. And these days, most people aren't interested in nuanced opinions in the middle. So since I'm not entirely in the pro-`=>` camp, I must be entirely in the opposition camp. **Not true**.

What I hate is suggesting they're universally more readable, or that they're objectively **better** in basically all cases.

The reason I reject this stance is because **I REALLY DO STRUGGLE TO READ THEM** in many cases. So that perspective just makes me feel dumb/inferior as a developer. "There must be something wrong with me, since I don't think it's more readable. Why do I suck so much at this?" And I'm not the only one whose impostor syndrome is seriously stoked by such absolutes.

And the cherry on top is when people tell you that the only reason you don't understand or like `=>` is because you haven't learned them or used them enough. Oh, right, thanks for the (condescending) reminder it's due to **my** ignorance and inexperience. SMH. I've written and read literally thousands of `=>`functions. I'm quite certain I know enough about them to hold the opinions I have.

I'm not in the pro-`=>` camp, but I recognize that some really do prefer them, legitimately. I recognize that some people come to JS from languages that have used `=>` and so they feel and read quite natural. I recognize that some prefer their resemblance to mathematical notation.

What's problematic IMO is when some in those camps simply cannot understand or empathize with dissenting opinions, as if there must just be something **wrong** with them.

## Readability != Writability

I also don't think **you** know what you're talking about when you talk about code readability. By and large, the vast majority of opinions on code readability, when you break them down, are based on a personal stance about preferences in **writing**concise code.

When I push back in debates about code readability, some just dig in their heels and refuse to support their opinion. Others will waive off the concerns with, "readability is all just subjective anyway".

The flimsiness of that response is stunning: two seconds ago they were vehemently claiming `=>` arrow is absolutely and objectively more readable, and then when pressed, they admit, "well, **I** think it's more readable, even if ignorants like you don't."

Guess what? Readability **is** subjective, **but not entirely so**. It's a really complex topic. And there are some who are undertaking to formally study the topic of code readability, to try to find what parts of it are objective and what parts are subjective.

I have read a fair amount of such research, and I'm convinced that it's a complicated enough topic that it can't be reduced to a slogan on a t-shirt. If you want to read them, I would encourage you doing some google searching and reading of your own.

While I don't have all the answers myself, one thing I'm certain about is, code is more often read than written, so perspectives on the topic which ultimately come from "it's easier/quicker to write" don't hold much standing. What needs to be considered is, not how much time do you save writing, but how clearly will the reader (future you or someone else on the team) be able to understand? And ideally, can they mostly understand it without pouring over the code with a fine-toothed comb?

Any attempt to justify writability affordances with unsubstantiated claims about readability benefits is a weak argument at best, and in general, nothing but a distraction.

So I roundly reject that `=>` is always and objectively "more readable".

But I still don't hate arrow functions. I just think to use them effectively, we need to be more disciplined.

## Linters == Discipline

You might be of the (incorrect) belief that linters tell you objective facts about your code. They **can** do that, but that's not their primary purpose.

The tool that's best suited to tell you if your code is valid is a compiler (ie, the JS engine). The tool that's best suited to tell you whether your code is "correct" (does what you want it to do) is your test suite.

But the tool that's best suited to tell you if your code is **appropriate** is a linter. Linters are opinionated collections of rules about how you should style and structure your code, so as to avoid likely problems -- according to the authors of those opinion-based rules.

That's what they're for: **to apply opinions to your code.**

That means it's almost certain that these opinions will, at one time or another, "offend" you. If you're like most of us, you fancy yourself pretty good at what you do, and you know that this thing you're doing on this line of code is **right**. And then the linter pops up and says, "Nope, don't do it that way."

If your first instinct is sometimes to disagree, then you're like the rest of us! We get emotionally attached to our own perspectives and abilities, and when a tool tells us we're wrong, we chuff a little bit.

I don't get mad at the test suite or the JS engine. Those things are all reporting **facts** about my code. But I can definitely get irritated when the linter's **opinion** disagrees with mine.

I have this one linter rule that I enabled a few weeks ago, because I had an inconsistency in my coding that was annoying me on code re-reads. But now this lint rule is popping up two or three times an hour, nagging me like a stereotypical grandma on a 90's sitcom. Every single time, I ponder (for just a moment) if I should just go disable that rule. I leave it on, but to my chagrin.

So why subject ourselves to this torment!? Because linter tools and their opinions are what give us discipline. They help us collaborate with others.

They ultimately help us communicate more clearly in code.

Why shouldn't we let every developer make their own decisions? Because of our tendency toward emotional attachment. While we're in the trenches working on **our own code**, against unreasonable pressure and deadlines, we're in the least trustable mindset to be making those judgement calls.

We should be submitting to tools to help us maintain our discipline.

It's similar to how TDD advocates submit to the discipline of writing tests first, in a formal set of steps. The discipline and the bigger picture outcome of the process are what we value most, when we're level headed enough to make that analysis. We don't institute that kind of process when our code is hopelessly broken and we have no idea why and we're just resorting to trying random code changes to see if they fix it!

No. If we're being reasonable, we admit that the **overall good** is best served when we set up reasonable guidelines and then follow the discipline of adhering to them.

## Configurability Is King

If you're going to knowingly subject yourself to this finger wagging, you (and your team, if applicable) are certainly going to want some say-so in what rules you're required to play by. Arbitrary and unassailable opinions are the worst kind.

Remember the JSLint days when 98% of the rules were just Crockford's opinions, and you either used the tool or you didn't? He straight up warned you in the README that you were going to be offended, and that you should just get over it. That was fun, right? (Some of you may still be using JSLint, but I think you should consider moving on to a more modern tool!)

That's why [ESLint is king](https://eslint.org/) of the linters these days. The philosophy is, basically, let everything be configurable. Let developers and teams democratically decide which opinions they all want to submit to, for their own discipline and good.

That doesn't mean every developer picks their own rules. The purpose of rules is to conform code to a reasonable compromise, a "centralized standard", that has the best chance of communicating most clearly to the most developers on the team.

But no rule is ever 100% perfect. There's always exception cases. Which is why having the option to disable or re-configure a rule with an inline comment, for example, is not just a tiny detail but a critical feature.

You don't want a developer to just have their own local ESLint config that overrides rules while they commit code. What you want is for a developer to either follow the established rules (preferred!) **OR** to make an exception to the rules that is clear and obvious right at the point where the exception is being made.

Ideally, during a code review, that exception can be discussed and debated and vetted. Maybe it was justified, maybe it wasn't. But at least it was obvious, and at least it was possible to be discussed in the first place.

Configurability of tools is how we make tools work for us instead of us working for the tools.

Some prefer convention-based approaches to tooling, where the rules are pre-determined so there's no discussion or debate. I'm know that works for some developers and for some teams, but I don't think it is a sustainable approach for generalized, broad application. Ultimately, a tool that is inflexible to the changing project needs and DNA of the developer(s) using it, will end up falling into obscurity and eventually replaced.

## Proper Arrows

I fully recognize my usage of the the word "proper" here is going to ruffle some feathers. "Who is getify to say what is proper and not?"

Remember, I'm not trying to tell you what is proper. I'm trying to get you to embrace the idea that opinions about `=>` arrow functions are as varied as all the nuances of their syntax and usage, and that ultimately what is most appropriate is that **some set of opinions**, no matter what they are, should be applicable.

While I'm a big fan of ESLint, I've been disappointed by the lack of support from built-in ESLint rules for controlling various aspects of `=>` arrow functions. [There](https://eslint.org/docs/rules/arrow-body-style) [are](https://eslint.org/docs/rules/arrow-parens) [a](https://eslint.org/docs/rules/arrow-spacing) [few](https://eslint.org/docs/rules/implicit-arrow-linebreak) built-in rules, but I'm frustrated that they seem to focus mostly on superficial stylistic details like whitespace.

I think there are a number of aspects that can hamper `=>` arrow function readability, issues that go way beyond what the current ESLint ruleset can control. I [asked](https://twitter.com/getify/status/1106902287010709504) around [on twitter](https://twitter.com/getify/status/1106641030273736704), and it seems from the many replies that a lot of people have opinions on this.

The ultimate linter would not only let you configure rules to your liking, but build your own rules if something were lacking. Luckily, ESLint supports exactly that!

So I decided to build an ESLint plugin to define an additional set of rules around `=>` arrow functions: [**proper-arrows**](https://github.com/getify/eslint-plugin-proper-arrows).

Before I explain anything about it, let me just point out: it's a set of rules that can be turned on or off, and configured, at your discretion. If you find even one detail of one rule helpful, it would be better to use the rule/plugin than not.

I'm fine with you having your own opinions on what makes `=>` arrow functions proper. In fact, that's the whole point. If we all have different opinions on `=>` arrow functions, we should have tooling support to let us pick and configure those different opinions.

The philosophy of this plugin is that, for each rule, when you turn the rule on, you get all of its reporting modes on by default. But you can of course either not turn the rule on, or turn the rule on and then configure its modes as you see fit. But I don't want you to have to go hunting for rules/modes to turn on, where their obscurity prevents them from even being considered. So **everything comes on per rule.**

The only exception here is that by default, all rules ignore [trivial `=>` arrow functions](https://github.com/getify/eslint-plugin-proper-arrows#trivial--arrow-functions), like `() => {}`, `x => x`, etc. If you want those to be checked, on a per-rule basis you have to turn on that checking with the `{ "trivial": true }` option.

### Proper Arrows Rules

So what rules are provided? Here's an [excerpt from the project overview](https://github.com/getify/eslint-plugin-proper-arrows/blob/master/README.md#overview):

* [`"params"`](https://github.com/getify/eslint-plugin-proper-arrows/blob/master/README.md#rule-params): controls definitions of `=>` arrow function parameters, such as forbidding unused parameters, forbidding short/unsemantic parameter names, etc.
* [`"name"`](https://github.com/getify/eslint-plugin-proper-arrows/blob/master/README.md#rule-name): requires `=>` arrow functions to only be used in positions where they receive an inferred name (i.e., assigned to a variable or property, etc), to avoid the poor readbility/debuggability of anonymous function expressions.
* [`"where"`](https://github.com/getify/eslint-plugin-proper-arrows/blob/master/README.md#rule-where): restricts where in program structure `=>` arrow functions can be used: forbidding them in the top-level/global scope, object properties, `export` statements, etc.
* [`"return"`](https://github.com/getify/eslint-plugin-proper-arrows/blob/master/README.md#rule-return): restricts the concise return value kind for `=>` arrow functions, such as forbidding object literal concise returns (`x => ({ x })`), forbidding concise returns of conditional/ternary expressions (`x => x ? y : z`), etc.
* [`"this"`](https://github.com/getify/eslint-plugin-proper-arrows/blob/master/README.md#rule-this): requires/disallows `=>` arrow functions using a `this` reference, in the `=>` arrow function itself or in a nested `=>` arrow function. This rule can optionally forbid `this`-containing `=>` arrow functions from the global scope.

Remember, each rule has various modes to configure, so none of this is all-or-nothing. Pick what works for you.

As an illustration of what the **proper-arrows** rules can check for, let's look at the [`"return"` rule](https://github.com/getify/eslint-plugin-proper-arrows/blob/master/README.md#rule-return), specifically its [`"sequence"` mode](https://github.com/getify/eslint-plugin-proper-arrows/blob/master/README.md#rule-return-configuration-sequence). This mode refers to the concise return expression of `=>` arrow functions being a comma-separated **sequence**, like this:

```JavaScript
var myfunc = (x,y) => ( x = 3, y = foo(x + 1), \[x,y\] );
```

Sequences are typically used in `=>` arrow function concise returns to string together multiple (expression) statements, without needing to use a full `{ .. }` delimited function body and an explicit `return` statement.

Some may love this style -- that's OK! -- but a lot of folks think it favors clever terse style coding over readability, and would prefer instead:

```JavaScript
var fn2 = (x,y) => { x = 3; y = foo(x + 1); return \[x,y\]; };
```

Notice that it's still an `=>` arrow function and it's not even that many more characters. But it's clearer that there are three separate statements in this function body.

Even better:

```JavaScript
var fn2 = (x,y) => {
   x = 3;
   y = foo(x + 1);
   return \[x,y\];
};
```

To be clear, the **proper-arrows** rules don't enforce trivial styling differences like whitespace/indentation. There are other (built-in) rules if you want to enforce those requirements. **proper-arrows** focuses on what I consider to be more substantive aspects of `=>` function definition.

## [](https://gist.github.com/getify/71680e9b86cd4895874f6a3768bd6eca#concise-summary)Concise Summary

You and I almost certainly disagree on what makes **good, proper** `=>` arrow function style. That's a good and healthy thing.

My goal here is two-fold:

1. Convince you that opinions on this stuff vary and that's OK.
2. Enable you to make and enforce your own opinions (or team consensus) with configurable tooling.

There's really nothing to be gained from arguing over opinion-based rules. Take the ones you like, forget the ones you don't.

I hope you take a look at **[proper-arrows](https://github.com/getify/eslint-plugin-proper-arrows)**[ ](https://github.com/getify/eslint-plugin-proper-arrows)and see if there's anything in there which you could use to ensure your `=>` arrow functions are the best form they can be in your code base.

And if the plugin is missing some rules that would help define more **proper arrows**, please [file an issue and we can discuss](https://github.com/getify/eslint-plugin-proper-arrows/issues)! It's entirely plausible we may add that rule/mode, ****even if I personally plan to keep it turned off!****

I don't hate `=>` arrow functions, and you shouldn't either. I just hate uninformed and undisciplined debate. Let's embrace smarter and more configurable tooling and move on to more important topics!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
