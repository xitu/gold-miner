> * 原文地址：[Reverse Engineering, how YOU can build a testing library in JavaScript](https://dev.to/itnext/reverse-engineering-how-you-can-build-a-test-library-53e3)
> * 原文作者：[Chris Noring](https://dev.to/softchris)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/reverse-engineering-how-you-can-build-a-test-library.md](https://github.com/xitu/gold-miner/blob/master/TODO1/reverse-engineering-how-you-can-build-a-test-library.md)
> * 译者：
> * 校对者：

# Reverse Engineering, how YOU can build a testing library in JavaScript

I know what you are thinking. Building my own testing library with so many out there?? Hear me out. This article is about being able to do **reverse engineering** and understand what might go on under the hood. Why? Simply to gain more understanding and a deeper appreciation of the libraries you use.

Just to make it clear. I'm not about to implement a test library fully, just have a look at the public API and understand roughly what's going on and start implementing it. By doing so I hope to gain some understanding of the overall architecture, both how to line it out but also how to extend it and also appreciate what parts are tricky vs easy.

I hope you enjoy the ride :)

We will cover the following:

* **The WHY**, try to explain all the benefits to reverse engineering
* **The WHAT**, what we will build and not build
* **Constructing**, slowly take you through the steps of building it out

## WHY

Many years ago, in the beginning of my career as a software developer, I asked a senior developer how they got better. It wasn't just one answer but one thing stood out, namely **reverse engineering** or rather recreating libraries or frameworks they were using or were curious about.

> Sounds to me like you are trying to reinvent the wheel. What's good about that, don't we have enough libraries that do the same thing already?

Of course, there is merit to this argument. Don't build things primarily cause you don't like the exact flavoring of a library, unless you reeeeally need to, sometimes you do need to though.

> So when?

When it's about trying to become better at your profession.

> Sounds vague

Well, yes it partly is. There are many ways to become better. I'm of the opinion that to truly understand something it's not enough to just use it - **you need to build it**.

> What, all of it?

Depends on the size of the library or framework. Some are small enough that it's worth building all of it. Most are not though. There is a lot of value in trying to implement something though, a lot can be understood by just starting **if only to get stuck**. That's what this exercise is, to try to understand more.

## [](#the-what)The WHAT

We mentioned building a testing library in the beginning. What testing library? Well, let's have a look at how most testing libraries look like in JavaScript. They tend to look like this:

```js
describe('suite', () => {
  it('should be true', () => {
    expect(2 > 1).toBe(true)
  })
})
```

This is the scope of what we will be building, getting the above to work and in the process comment on the architecture and maybe throw in a library to make it pretty :)

Let's get started.

## Constructing

Ok then. **If you build it they will come**.

> Sure?

You know, the movie Field of Dreams?

> Whatever grandpa **bored**

### Expect, assert our values

Let's begin from our most inner statement, the `expect()` function. By looking at an invocation we can learn a lot:

```js
expect(2 > 1).toBe(true)
```

`expect()` looks like a function taking a `boolean`. It seems to be returning an object that has a method `toBe()` on it that additionally is able to compare the value in `expect()` by what `toBe()` is fed with. Let's try to sketch this:

```js
function expect(actual) {
  return {
    toBe(expected) { 
      if(actual === expected){ 
        /* do something*/ 
      } else {
        /* do something else*/
      }
    }
  }
}
```

Additionally, we should consider that this should produce some kind of statement if the matching is a success or if it's a failure. So some more code is needed:

```js
function expect(actual) {
  return {
    toBe(expected) { 
      if(expected === actual){ 
        console.log(`Succeeded`)
      } else {
        console.log(`Fail - Actual: ${val}, Expected: ${expected}`)
      }
    }
  }
}

expect(true).toBe(true) // Succeeded
expect(3).toBe(2)  // Fail - Actual: 3, Expected: 2 
```

Note, how the `else` statement has a bit more specialized message and gives us a hint on what failed.

Methods like this comparing two values to each other like `toBe()` are called `matchers`. Let's try to add another matcher `toBeTruthy()`. The reason is that the term **truthy** matches a lot of values in JavaScript and we would rather not have to use the `toBe()` matcher for everything.

> So we are being lazy?

YES, best reason there is :)

The rules for this one is that anything considered truthy in JavaScript should succeed and anything else should render in failure. Let's cheat a bit by going to MDN and see what's considered **truthy**:

```js
if (true)
if ({})
if ([])
if (42)
if ("0")
if ("false")
if (new Date())
if (-42)
if (12n)
if (3.14)
if (-3.14)
if (Infinity)
if (-Infinity)
```

Ok, so everything within an `if` statement that evaluates to `true`. Time to add said method:

```js
function expect(actual) {
  return {
    toBe(expected) { 
      if(expected === actual){ 
        console.log(`Succeeded`)
      } else {
        console.log(`Fail - Actual: ${val}, Expected: ${expected}`)
      }
    },
    toBeTruthy() {
      if(actual) {
        console.log(`Succeeded`)
      } else {
        console.log(`Fail - Expected value to be truthy but got ${actual}`)
      }
    }
  }
}

expect(true).toBe(true) // Succeeded
expect(3).toBe(2)  // Fail - Actual: 3, Expected: 2 
expect('abc').toBeTruthy();
```

I don't know about you, but I feel like my `expect()` function is starting to contain a lot of things. So let's move out our `matchers` to a `Matchers` class, like so:

```js
class Matchers {
  constructor(actual) {
    this.actual = actual;
  }

  toBe(expected) { 
    if(expected === this.actual){ 
      console.log(`Succeeded`)
    } else {
      console.log(`Fail - Actual: ${this.actual}, Expected: ${expected}`)
    }
  }

  toBeTruthy() {
    if(this.actual) {
      console.log(`Succeeded`)
    } else {
      console.log(`Fail - Expected value to be truthy but got ${this.actual}`)
    }
  }
}

function expect(actual) {
  return new Matchers(actual);
}
```

### it, our test method

Looking at our vision it should be working like so:

```js
it('test method', () => {
  expect(3).toBe(2)
})
```

Ok, reverse engineering this bit we can pretty much write our `it()` method:

```js
function it(testName, fn) {
  console.log(`test: ${testName}`);
  fn();
}
```

Ok, let's stop here a bit and think. What kind of behavior do we want? I've definitely seen unit testing libraries that quits running the tests if something fails. I guess if you have 200 unit tests (not that you should have 200 tests in one file :), you don't want to wait for them to finish, better to tell me directly what's wrong so I can fix it. For the latter to be possible we need to adjust our matchers a little:

```js
class Matchers {
  constructor(actual) {
    this.actual = actual;
  }

  toBe(expected) { 
    if(expected === actual){ 
      console.log(`Succeeded`)
    } else {
      throw new Error(`Fail - Actual: ${val}, Expected: ${expected}`)
    }
  }

  toBeTruthy() {
    if(actual) {
      console.log(`Succeeded`)
    } else {
      console.log(`Fail - Expected value to be truthy but got ${actual}`)
      throw new Error(`Fail - Expected value to be truthy but got ${actual}`)
    }
  }
}
```

This means that our `it()` function needs to capture any erros like so:

```js
function it(testName, fn) {
  console.log(`test: ${testName}`);
  try {
    fn();
  } catch(err) {
    console.log(err);
    throw new Error('test run failed');
  }

}
```

As you can see above we not only capture the error and logs it but we rethrow it to put an end to the run itself. Again, main reason was that we saw no point in continuing. You can implement this the way you see fit.

### Describe, our test suite

Ok, we covered writing `it()` and `expect()` and even threw in a couple of matcher functions. All testing libraries should have a suite concept though, something that says this is a group of tests that belong together.

Let's look at what the code can look like:

```js
describe('our suite', () => {
  it('should fail 2 != 1', () => {
    expect(2).toBe(1);
  })

  it('should succeed', () => { // technically it wouldn't get here, it would crash out after the first test
    expect('abc').toBeTruthy();
  })
})
```

As for the implementation, we know that tests that fail throws errors so we need to capture that to not crash the whole program:

```js
function describe(suiteName, fn) {
  try {
    console.log(`suite: ${suiteName}`);
    fn();
  } catch(err) {
    console.log(err.message);
  }
}
```

### Running the code

At this point our full code should look like this:

```js
// app.js

class Matchers {
  constructor(actual) {
    this.actual = actual;
  }

  toBe(expected) {
    if (expected === this.actual) {
      console.log(`Succeeded`)
    } else {
      throw new Error(`Fail - Actual: ${this.actual}, Expected: ${expected}`)
    }
  }

  toBeTruthy() {
    if (actual) {
      console.log(`Succeeded`)
    } else {
      console.log(`Fail - Expected value to be truthy but got ${this.actual}`)
      throw new Error(`Fail - Expected value to be truthy but got ${this.actual}`)
    }
  }
}

function expect(actual) {
  return new Matchers(actual);
}

function describe(suiteName, fn) {
  try {
    console.log(`suite: ${suiteName}`);
    fn();
  } catch(err) {
    console.log(err.message);
  }
}

function it(testName, fn) {
  console.log(`test: ${testName}`);
  try {
    fn();
  } catch (err) {
    console.log(err);
    throw new Error('test run failed');
  }
}

describe('a suite', () => {
  it('a test that will fail', () => {
    expect(true).toBe(false);
  })

  it('a test that will never run', () => {
    expect(1).toBe(1);
  })
})

describe('another suite', () => {
  it('should succeed, true === true', () => {
    expect(true).toBe(true);
  })

  it('should succeed, 1 === 1', () => {
    expect(1).toBe(1);
  })
})
```

and when run in the terminal with `node app.js`, should render like so:

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--AU3RQVD8--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/y3hmyys7hsph5gbg16bb.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--AU3RQVD8--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/y3hmyys7hsph5gbg16bb.png)

## Making it pretty

Now the above seems to be working but it looks **sooo** boring. So what can we do about it? Colors, plenty of colors will make this better. Using the library `chalk` we can really induce some life into this:

```js
npm install chalk --save
```

Ok, next let's add some colors and some tabs and spaces and our code should look like so:

```js
const chalk = require('chalk');

class Matchers {
  constructor(actual) {
    this.actual = actual;
  }

  toBe(expected) {
    if (expected === this.actual) {
      console.log(chalk.greenBright(`    Succeeded`))
    } else {
      throw new Error(`Fail - Actual: ${this.actual}, Expected: ${expected}`)
    }
  }

  toBeTruthy() {
    if (actual) {
      console.log(chalk.greenBright(`    Succeeded`))
    } else {
      throw new Error(`Fail - Expected value to be truthy but got ${this.actual}`)
    }
  }
}

function expect(actual) {
  return new Matchers(actual);
}

function describe(suiteName, fn) {
  try {
    console.log('\n');
    console.log(`suite: ${chalk.green(suiteName)}`);
    fn();
  } catch (err) {
    console.log(chalk.redBright(`[${err.message.toUpperCase()}]`));
  }
}

function it(testName, fn) {
  console.log(`  test: ${chalk.yellow(testName)}`);
  try {
    fn();
  } catch (err) {
    console.log(`    ${chalk.redBright(err)}`);
    throw new Error('test run failed');
  }
}

describe('a suite', () => {
  it('a test that will fail', () => {
    expect(true).toBe(false);
  })

  it('a test that will never run', () => {
    expect(1).toBe(1);
  })
})

describe('another suite', () => {
  it('should succeed, true === true', () => {
    expect(true).toBe(true);
  })

  it('should succeed, 1 === 1', () => {
    expect(1).toBe(1);
  })
})
```

and render like so, when run:

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--Gt0KQDcz--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/nusgojpo4vmi22r8q7zx.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Gt0KQDcz--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/nusgojpo4vmi22r8q7zx.png)

## Summary

We aimed at looking at a fairly small library like a unit testing library. By looking at the code we could deduce what it might look like underneath.

We created something, a starting point. Having said that we need to realize that most unit testing libraries come with a lot of other things as well like, handling asynchronous tests, multiple test suites, mocking, spies a ton more `matchers` and so on. There is a lot to be gained by trying to understand what you use on a daily basis but please realize that you don't have to completely reinvent it to gain a lot of insight.

My hope is that you can use this code as a starting point and maybe play around with it, start from the beginning or extend, the choice is yours.

Another outcome of this might be that you understand enough to help out with OSS and improve one of the existing libraries out there.

Remember, if you build they will come:

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--YY1Wgcm0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/vndsyrcrelnklmbamhhy.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--YY1Wgcm0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/vndsyrcrelnklmbamhhy.jpg)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
