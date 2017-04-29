> * 原文地址：[Familiarity Bias is Holding You Back: It’s Time to Embrace Arrow Functions](https://medium.com/javascript-scene/familiarity-bias-is-holding-you-back-its-time-to-embrace-arrow-functions-3d37e1a9bb75)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Familiarity Bias is Holding You Back: It’s Time to Embrace Arrow Functions #

![](https://cdn-images-1.medium.com/max/800/1*Dwv24VW3sEuGBo4BqrsRQg.jpeg)

“Anchor” — Actor212 — (CC BY-NC-ND 2.0)

I teach JavaScript for a living. Recently I’ve shuffled around my curriculum to teach curried arrow functions sooner — within the first few lessons. I moved it earlier in the curriculum because it’s an extremely valuable skill, and students pick up currying with arrows **a lot quicker** than I thought they would.

If they can understand it and take advantage of it earlier, why not teach it earlier?

> Note: My courses are not designed for people who have never touched a line of code before. Most students join after spending at least a few months coding — on their own, in a bootcamp, or professionally. However, I have seen many junior developers with little or no experience pick these topics up quickly.

I’ve seen a bunch of students get a working familiarity with curried arrow functions within the span of a single 1-hour lesson. (If you’re a member of [“Learn JavaScript with Eric Elliott”](https://ericelliottjs.com/product/lifetime-access-pass/), you can watch the 55-minute [ES6 Curry & Composition](https://ericelliottjs.com/premium-content/es6-curry-composition/).

Seeing how quickly students pick it up and start wielding their new-found curry powers, I’m always a bit surprised when I post curried arrow functions on Twitter, and the Twitterverse responds with outrage at the thought of inflicting that “unreadable” code on the people who will need to maintain it.

First, let me give you an example of what we’re talking about. The first time I noticed the backlash was the Twitter response to this function:

```
const secret = msg => () => msg;
```

I was shocked when people on Twitter accused me of trying to confuse people. I wrote that function to demonstrate how **easy** it is to express curried functions in ES6. It is the **simplest** practical application and expression of a closure that I can think of in JavaScript. (Related: [“What is a Closure?”](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-closure-b2f0d2152b36)).

It’s equivalent to the following function expression:

```
const secret = function (msg) {
  return function () {
    return msg;
  };
};
```

`secret()` is a function which takes a `msg` and returns a new function which returns the `msg`. It takes advantage of closures to fix the value of `msg` to whatever value you pass into `secret()`.

Here’s how you use it:

```
const mySecret = secret('hi');
mySecret(); // 'hi'
```

It turns out, the “double arrow” is what confused people. I’m convinced that this is a fact:

> With familiarity, in-line arrow functions are the **most readable** way to express curried functions in JavaScript.

Many people have argued to me that the longer form is easier to read than the shorter form. They’re partly right, but mostly wrong. It’s more verbose, and more explicit, but not easier to read — at least, not to somebody **familiar** with arrow functions.

The objections I saw on Twitter just weren’t jiving with the smooth learning experience my students were enjoying. In my experience, students take to curried arrow functions like fish take to water. Within days of learning them, they are one with the arrows. They sling them effortlessly to tackle all sorts of coding challenges.

I don’t see any sign that arrow functions are “hard” for them to learn, to read, or to understand — once they have made the initial investment of learning them over the course of a few 1-hour lessons and study sessions.

They easily read curried arrow functions they have never seen before and explain to me what’s going on. They naturally write their own when I present a challenge to them.

In other words, as soon as they become **familiar** with seeing curried arrow functions, they have **no trouble **with them. They read them as easily as you are reading this sentence — and their understanding is reflected in much simpler code with fewer bugs.

### Why Some People Think Legacy Function Expressions Look “Easier” to Read ###

**Familiarity bias** is a measurable [human cognitive bias](https://www.psychologytoday.com/blog/mind-my-money/200807/familiarity-bias-part-i-what-is-it) that leads us to make self-destructive decisions despite being aware of a better option. We keep using the same old patterns in spite of knowing about better patterns out of comfort and habit.

You can learn a lot more about familiarity bias (and a lot of other ways we fool ourselves) from the excellent book, [“The Undoing Project: A Friendship that Changed Our Minds”](https://www.amazon.com/Undoing-Project-Friendship-Changed-Minds-ebook/dp/B01GI6S7EK/ref=as_li_ss_tl?ie=UTF8&amp;qid=1492606452&amp;sr=8-1&amp;keywords=the+undoing+project&amp;linkCode=ll1&amp;tag=eejs-20&amp;linkId=4ebd1476f97023e8acb4bba37ea18b90). This book should be required reading for every software developer, because it encourages you to think more critically and test your assumptions in order to avoid falling into a variety of cognitive traps — and the story of how those cognitive traps were discovered is really good, too.

### Legacy Function Expressions are Probably Causing Bugs in Your Code ###

Today I was rewriting a curried arrow function from ES6 to ES5 so that I could publish it as an open-source module that people could use in old browsers without transpiling. The ES5 version shocked me.

The ES6 version was simple, short, and elegant — only 4 lines.

I thought for sure, **this** was the function that would prove to Twitter that arrow functions are superior, and that people should abandon their legacy functions like the bad habit they are.

So I tweeted:

[![Markdown](http://i2.muimg.com/1949/15826825ba3ae5a9.png)](https://twitter.com/_ericelliott/status/854608052967751680/photo/1)

Here’s the text of the functions, in case the image isn’t working for you:

```
// curried with arrows
const composeMixins = (...mixins) => (
  instance = {},
  mix = (...fns) => x => fns.reduce((acc, fn) => fn(acc), x)
) => mix(...mixins)(instance);
// vs ES5-style
var composeMixins = function () {
  var mixins = [].slice.call(arguments);
  return function (instance, mix) {
    if (!instance) instance = {};
    if (!mix) {
      mix = function () {
        var fns = [].slice.call(arguments);
        return function (x) {
          return fns.reduce(function (acc, fn) {
            return fn(acc);
          }, x);
        };
      };
    }
    return mix.apply(null, mixins)(instance);
  };
};
```

The function in question is a simple wrapper around `pipe()`, a standard functional programming utility commonly [used to compose functions](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-function-composition-20dfb109a1a0). A `pipe()` function exists in lodash as `lodash/flow`, in Ramda as `R.pipe()`, and even has its own operator in several functional programming languages.

It should be familiar to everybody familiar with [functional programming](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-functional-programming-7f218c68b3a0). As should its primary dependency: [Reduce](https://medium.com/javascript-scene/reduce-composing-software-fe22f0c39a1d).

In this case, it’s being used to compose functional mixins, but that’s an irrelevant detail (and a whole other blog post). Here are the important details:

The function takes any number of functional mixins and returns a function which applies them one after the other in a pipeline — like an assembly line. Each functional mixin takes the `instance` as an input, and tacks some stuff onto it before passing it on to the next function in the pipeline.

If you omit the `instance`, a new object gets created for you.

Sometimes we may want to compose the mixins differently. For example, you may want to pass `compose()` instead of `pipe()` to reverse the order of precedence.

If you don’t need to customize the behavior, you simply leave the default alone, and get standard `pipe()` behavior.

### Just the Facts ###

Opinions about readability aside, here are **the objective facts** pertaining to this example:

- I have multiple years’ experience with both ES5 and ES6 function expressions, arrows or otherwise. Familiarity bias is **not** a variable in this data.
- I wrote the ES6 version in a few seconds. It contained zero bugs (that I’m aware of — it passes all its unit tests).
- It took me several minutes to write the ES5 version. At least an order of magnitude more time. Minutes vs seconds. I lost my place in the function indentations twice. I wrote 3 bugs, all of which I had to debug and fix. Two of which I had to resort to `console.log()` to figure out what was going on.
- The ES6 version is 4 lines of code.
- The ES5 version is 21 lines long (17 actually contain code).
- In spite of its tedious verbosity, the ES5 version actually loses some of the information fidelity that is available in the ES6 version. It’s much longer, but **communicates less**, read on for details.
- The ES6 version contains 2 spreads for function parameters. The ES5 version omits the spreads, and instead uses the *implicit*`arguments` object, which hurts the readability of the function signature (fidelity downgrade 1).
- The ES6 version defines the default for `mix` in the function signature so you can clearly see that it’s a value for a parameter. The ES5 version obscures that detail and instead hides it deep inside the function body. (fidelity downgrade 2).
- The ES6 version has only 2 levels of indentation, which helps clarify the structure of how it should be read. The ES5 version has 6, and the nesting levels obscure rather than aid the readability of the function’s structure (fidelity downgrade 3).

In the ES5 version, `pipe()` occupies most of the function body — so much so that it’s a bit **insane** to define it inline. It really **needs** to be broken out into a separate function to make the ES5 version readable:

```
var pipe = function () {
  var fns = [].slice.call(arguments);

  return function (x) {
    return fns.reduce(function (acc, fn) {
      return fn(acc);
    }, x);
  };
};

var composeMixins = function () {
  var mixins = [].slice.call(arguments);

  return function (instance, mix) {
    if (!instance) instance = {};
    if (!mix) mix = pipe;

    return mix.apply(null, mixins)(instance);
  };
};
```

This seems clearly more readable and understandable to me.

Let’s see what happens when we apply the same readability “optimization” to the ES6 version:

```
const pipe = (...fns) => x => fns.reduce((acc, fn) => fn(acc), x);

const composeMixins = (...mixins) => (
  instance = {},
  mix = pipe
) => mix(...mixins)(instance);
```

Like the ES5 optimization, this version is more verbose (it adds a new variable that wasn’t there before). Unlike the ES5 version, this version is **not significantly more readable** after abstracting the definition of pipe. After all, it already had a variable name clearly assigned to it *in the function signature:*`mix`.

The definition of `mix` was already contained on its own line, which makes it unlikely for readers to get confused about where it ends and the rest of the function continues.

Now we have 2 variables representing the same thing instead of 1. Have we gained very much? Not obviously, no.

So why is the ES5 version **obviously better** with the same function abstracted?

Because the ES5 version is **obviously more complex.** The source of that complexity is the crux of this matter. I assert that the source of the complexity boils down to **syntax noise**, and that syntax noise is **obscuring the meaning of the function**, not helping.

Let’s shift gears and eliminate some more variables. Let’s use ES6 for both examples, and only compare *arrow functions* vs *legacy function expressions:*

```
var composeMixins = function (...mixins) {
  return function (
    instance = {},

    mix = function (...fns) {
      return function (x) {
        return fns.reduce(function (acc, fn) {
          return fn(acc);
        }, x);
      };
    }
  ) {
    return mix(...mixins)(instance);
  };
};
```

This looks significantly more readable to me. All we’ve changed is that we’re taking advantage of **rest** and **default parameter** syntax. Of course, you’ll have to be **familiar** with rest and default syntax in order for this version to be more readable, but even if you’re not, I think it’s obvious that this version is still **less cluttered**.

That helped a lot, but it’s still clear to me that this version is still cluttered enough that abstracting `pipe()` into its own function would **obviously help:**

```
const pipe = function (...fns) {
  return function (x) {
    return fns.reduce(function (acc, fn) {
      return fn(acc);
    }, x);
  };
};

// Legacy function expressions
const composeMixins = function (...mixins) {
  return function (
    instance = {},
    mix = pipe
  ) {
    return mix(...mixins)(instance);
  };
};
```

That’s better, right? Now that the `mix` assignment only occupies a single line, the structure of the function is much more clear — but there’s still too much syntax noise for my taste. In `composeMixins()`, it’s not clear to me at a glance where one function ends and another begins.

Rather than call out function bodies, that `function` keyword seems to visually **blend in** with the identifiers around it. There are functions **hiding** in my function! Where does the parameter signature end and the function body begin? I can figure it out out if I look closely, but it’s not visually obvious to me.

What if we could get rid of the function keyword, and call out return values by visually pointing to them with a big **fat arrow** `=>`instead of writing a `return` keyword that blends in with surrounding identifiers?

Turns out, we can, and here’s what that looks like:

```
const composeMixins = (...mixins) => (
  instance = {},
  mix = pipe
) => mix(...mixins)(instance);
```

Now it should be clear what’s going on. `composeMixins()` is a function that takes any number of `mixins` and returns a function that takes two optional parameters, `instance`, and `mix`. It returns the result of piping `instance` through the composed `mixins`.

Just one more thing… if we apply the same optimization to `pipe()`, it magically transforms into a one-liner:

```
const pipe = (...fns) => x => fns.reduce((acc, fn) => fn(acc), x);
```

With that definition on one-line, the advantage of abstracting it out into its own function is less clear. Remember, this function exists as a utility in Lodash, Ramda, and a bunch of other libraries, but is it really worth the overhead of importing another library?

Is it even worth pulling it out into its own line? Probably. They’re really two different functions, and separating them makes that more clear.

On the other hand, having it in-line clarifies type and usage expectations when you look at the parameter signature. Here’s what happens when we create it in-line:

```
const composeMixins = (...mixins) => (
  instance = {},
  mix = (...fns) => x => fns.reduce((acc, fn) => fn(acc), x)
) => mix(...mixins)(instance);
```

Now we’re back to the original function. Along the way, **we didn’t discard any meaning.** In fact, by declaring our parameters and default values inline, we **added information** about how the function is used, and what the values of the parameters might look like.

All that extra code in the ES5 version was just noise. Syntax noise. It didn’t serve **any useful purpose** except to acclimate people who are **unfamiliar** with curried arrow functions.

Once you have gained sufficient familiarity with curried arrow functions, it should be clear that the original version is **more readable** because there’s a lot less syntax to get lost in.

It’s also **less error-prone**, because there’s a lot less surface area for bugs to hide in.

I suspect there are lots of bugs hiding in legacy functions that would be found and eliminated if you were to upgrade to arrow functions.

I also supect that your team would become significantly more productive if you learned to embrace and favor more of the concise syntax available in ES6.

While it’s true that sometimes things are easier to understand if they’re made explicit, it’s also true that as a general rule, less code is better.

If less code can accomplish the same thing and communicate more, without sacrificing any meaning, it’s **objectively** better.

The key to knowing the difference is meaning. If more code fails to add more meaning, that code should not exist. That concept is so basic, it is a well-known style guideline for natural language.

The same style guideline applies to source code. Embrace it, and your code will be better.

At the end of the day, a light in the darkness. In response to yet another tweet saying the ES6 version less readable:

[![Markdown](http://i2.muimg.com/1949/4287b75aa0b58a9d.png)](https://twitter.com/blakenewman)

Time to get familiar with ES6, currying, and function composition.

### Next Steps ###

[“Learn JavaScript with Eric Elliott”](https://ericelliottjs.com/product/lifetime-access-pass/) members can watch the 55-minute [ES6 Curry & Composition](https://ericelliottjs.com/premium-content/es6-curry-composition/)  lesson right now.

If you’re not a member, you’re missing out!

[![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)](https://ericelliottjs.com/product/lifetime-access-pass/) 

***Eric Elliott*** *is the author of [*“Programming JavaScript Applications”*](http://pjabook.com) (O’Reilly), and [*“Learn JavaScript with Eric Elliott”*](http://ericelliottjs.com/product/lifetime-access-pass/). He has contributed to software experiences for Adobe Systems, Zumba Fitness, The Wall Street Journal, ESPN, BBC, and top recording artists including Usher, Frank Ocean, Metallica, and many more.*

*He spends most of his time in the San Francisco Bay Area with the most beautiful woman in the world.*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
