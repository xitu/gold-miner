> * 原文地址：[Good Coding Practices – Five Tips to Enhance Code Quality](https://www.thecodingdelight.com/good-coding-practices-tips-enhance-code-quality/)
> * 原文作者：[Jay](https://www.thecodingdelight.com/author/ljay189/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/good-coding-practices-tips-enhance-code-quality.md](https://github.com/xitu/gold-miner/blob/master/TODO1/good-coding-practices-tips-enhance-code-quality.md)
> * 译者：
> * 校对者：

# Good Coding Practices – Five Tips to Enhance Code Quality

Good coding practices are like a bright beacon guiding unwary developers to the shore at night. Good code is predictable. Easy to debug, extend and test.

Good coding practices help your teammates become more productive and makes working with your code base an overall pleasant experience.

What I will share with you are five universal good coding practices that will improve the readability, extensibility and overall value of your code. The sooner you understand and apply these principles, the greater the benefits will be.

Let’s get started.

## Why Good Coding Practices?

Learning and applying good coding practices is like investing in stocks that you know, for sure, will rise exponentially. In other words, as long as you invest that lump sum right now, the returns you get, years or even months down the track will far outweigh what you put in now.

Developers at all stages in their journey will benefit from applying and learning good coding practices. And as I mentioned before, the sooner you start applying them, the better. Now is the best time to learn and integrate good coding practices into your current projects.

I aimed to present these points so that they build on each other, and make sense as both individual pieces of advice and as a cohesive unit.

## 1. Name Methods and Variables Succinctly

When naming classes, variables, and methods, it can be very tempting to give names to our methods out of impulse. Especially when everything makes a lot of sense in your head. Try coming back to that code a few months down the line and see if it makes sense to you. If it does, chances are, you named your variables and methods wisely.

[![good coding practices - method names are like headings and sentences in an article](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2017/07/good-coding-practices-method-names-are-like-heading-sentences.jpg)](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2017/07/good-coding-practices-method-names-are-like-heading-sentences.jpg)

Methods are like headings or sentences in an article.

Therefore, when naming methods, aim to give names that accurately summarize the contents of the method. If the method name becomes too long or vague, it is an indicator that the method is doing way too many things.

The code that you write inside of a method body is the words that make up the sentence.

When looking at an article, what stands out to you the most? Generally, it is the heading that stands out the most. Well, in a program, **key methods are like headings**. When writing an article for a high school or college essay, do you just write some random string of words and finalize the heading without a second thought?

> A simple, intuitive method name is worth a thousand words.

Naturally, the choice of words in the sentence and how they are packaged together is also important. This is why we also need to be intentional on how we name our variables. Most of the time, before looking at the logic, people try to grasp the big-picture view of the implementation detail by reading the variable names in each line of logic.

Make sure that both methods and variable names are clear and accurately describe what is going on. Imagine if you gave a tourist the wrong direction, just how mad and confused he/she will be. You are giving directions to the next programmer who comes around to read your code.

## 2. Minimize Global Variables

You may have heard this often in programming, regardless of language. People just state that global variables are bad and leave it at that. Let me tell you why global variables should be minimized and avoided when possible.

> Global variables cause confusion because they are accessible from anywhere within the program.

The layer of confusion is amplified if that global variable is also mutable. If you declared a variable, chances are, you declared it to use it in your program. And guess what?

Here is a basic example in JavaScript, but should be easy to understand, regardless of your programming language background.

```
var GLOBAL_NUMBER = 5;
function add(num1) {
return num1 + GLOBAL_NUMBER;
}
```

For this function, even if we put in num1 = 3, we won’t know for certain whether or not we will get 8 because another part of the program may have and can manipulate the value of GLOBAL_NUMBER.

This increases the likelihood of side-effects, especially when we get all funky with multi-threaded programs. Whats worse, the complexity of the program scales in proportion to the size of the program.

Use cases of a single global variable in a 100 line program are manageable. But imagine if that program later evolved into a 10,000 line program. There are so many places where that variable could be manipulated. And chances are, by this point, other global variables may have been added to keep track of the program.

You now have a maintenance nightmare.

If possible, find ways to eliminate global variables. They make the life of every developer working on it hard.

## 3. Write Code with Predictable Results

If you follow this blog, you might have picked up the fact that I love pure functions. Especially if you are a beginner, I implore you to try writing code that is pure. Let me give you four points to keep when writing code.

**Avoid shared states** (Ahemm … global variables). **Keep functions pure**. In other words, functions, classes, subroutines, should all have a **single responsibility**.

If your job is to cook rice, then cook rice and nothing else to avoid confusing your coworkers. Don’t do something that you are not supposed to.

Code with predictable results is like a vending machine. You insert money in, press the button for Coke. You know that you are going to get a can of Coke in exchange for your money. No exception to the rule. What comes out is predictable. A good coding practice is to write code that yields **predictable outcomes**.

Imagine if you inserted money and pressed Coke, but instead, the vending machine spat Fanta out at you. Unless you like surprises, or you don’t care what drink you get, you are not going to be happy.

Without any exceptions, developers don’t like surprises that are a by-product of poorly written code.

Let’s take a look at a very simple example.

```
function add(num1, num2) {
return num1 + num2;
}
```

The simple add function above is pure. It yields predictable outcomes. No matter what environment you work in, regardless of any global variable, if you insert 1 and 2, you will always get 3 back.

```
// This will never equal a value 
// other than three
add(1, 2);
```

## 4. Write Reusable Code

I try to write modular code so that I can simply import that module without having to rewrite it. It is way better than reinventing the wheel and if you keep it pure, guess what? Fewer bugs and side-effects.

Most importantly, I want you to understand the reason why we like to adhere to these principles.

[Code is reusable when it can be ported to another development environment and integrated seamlessly Click To Tweet](https://twitter.com/share?text=Code+is+reusable+when+it+can+be+ported+to+another+development+environment+and+integrated+seamlessly&url=https://www.thecodingdelight.com/good-coding-practices-tips-enhance-code-quality/%3Futm_source%3Dtwitter%26utm_medium%3Dsocial%26utm_campaign%3DSocialWarfare&via=JayLee189).

Remember, you are not the only one (or at least you shouldn’t be) writing and maintaining that code base. Building on points one, two and three enables us to achieve point four, which is to write reusable code. In other words, steps 1-3 help us write code that is reusable. Let’s backtrack and review why steps 1-3 help developers write reusable code.

*   Simple and no-nonsense method and variable names make the code more palatable to other developers.
*   The reusable code should never depend on global states. Code with added dependencies is generally classified as difficult to reuse.
*   The reusable code should also yield consistent results that are not dependant on mutable states.

When writing code, ask yourself the following question: “Can I (and do I want to) reuse this code in another project?”. This will help you write reusable and therefore, more value-adding code.

## 5. Write Unit Tests

You may have heard this many times, but that is because unit tests provide an avenue for a piece of code to mature. Unit tests are one of the good coding practices that are frowned down upon, because of the time constraints. Project managers and clients want immediate results.

> Code written with the help of unit tests are like a [Chinese bamboo tree](http://www.mattmorris.com/how-success-is-like-a-chinese-bamboo-tree/). The results are not visible at the start, but with patient and in due time, the benefits are visible and well worth it!

In the first four years, the Chinese bamboo tree shows limited growth. And like any plant, it requires nurturing. In the fifth year, it grows 80 feet in just 6 weeks.

[![code written with unit tests are like bamboo trees](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2017/07/code-written-with-unit-tests-are-like-bamboo-trees.jpg)](//personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2017/07/code-written-with-unit-tests-are-like-bamboo-trees.jpg)

Although unit tests do not require as much time to reap the benefits, often at times, your patience, as well as that of your project manager will be tested. However, if time is invested into writing these unit tests and paying attention to the code quality, you will see great improvements in code quality and robustness. All of these ultimately translate into better user experience and easier to extend the code, with minimal side-effects. If you are not allowed to write unit tests at your work place, try getting into a habit of writing them in your personal projects. A lot of companies see the value in writing unit tests, and it is a very useful skill to have.

If you are not allowed to write unit tests at your work place, try getting into a habit of writing them in your personal projects. A lot of companies see the value in writing unit tests, and it is a very useful skill to have.

But more important than the skill, unit tests broaden the developer’s mind to think outside of the box and scan for all possible situations. Accounting for these situations, its likelihood, weighing the pros and cons of adding too many validation checks. Making assumptions, re-engineering. All the blood, sweat and tears will eventually produce beautiful, tested, pure and robust code. One that is reusable, predictable and may potentially serve you well in your future endeavors.

Accounting for these situations, its likelihood, weighing the pros and cons of adding too many validation checks. Making assumptions, re-engineering. All the blood, sweat and tears will eventually produce beautiful, tested, pure and robust code. One that is reusable, predictable and may potentially serve you well in your future endeavors.

All the blood, sweat and tears will eventually produce beautiful, tested, pure and robust code. One that is reusable, predictable and may potentially serve you well in your future endeavors.

At the very least, all the acquired knowledge will help mature you as a programmer.

## Grow the List

If you would like for me to add more points to this list or feel as though an important point was omitted from the list, please leave a comment and let me know. I will do my best to add to this list as quickly as possible.

Thank you for reading and happy coding!

### About the Author [Jay](https://www.thecodingdelight.com/author/ljay189/)

I am a programmer currently living in Seoul, South Korea. I created this blog as an outlet to express what I know / have been learning in text form for retaining knowledge and also to hopefully help the wider community. I am passionate about data structures and algorithms. The back-end and databases is where my heart is at.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
