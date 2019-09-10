> * 原文地址：[Reverse Engineering, how YOU can build a testing library in JavaScript](https://dev.to/itnext/reverse-engineering-how-you-can-build-a-test-library-53e3)
> * 原文作者：[Chris Noring](https://dev.to/softchris)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/reverse-engineering-how-you-can-build-a-test-library.md](https://github.com/xitu/gold-miner/blob/master/TODO1/reverse-engineering-how-you-can-build-a-test-library.md)
> * 译者：[DEARPORK](https://github.com/Usey95)
> * 校对者：[三月源](https://github.com/MarchYuanx), [yzw7489757](https://github.com/yzw7489757)

# 逆向工程，如何在 JavaScript 中打造一个测试库

我知道你在想什么，在已有那么多测试库的情况下再自己造轮子？其实不是，本文是关于如何能够**逆向工程**，以及理解背后发生的事。这么做的目的，是为了能够让你更广泛同时更深刻地理解你所使用的库。

再强调一遍，我并不打算完全实现一个测试库，只是粗略地看看有哪些公共 API，粗略地理解一下，然后实现它们。我希望通过这种方式可以对整个架构有所了解，知道如何删除、扩展模块以及了解各个部分的难易程度。

希望你享受这个过程 :)

我们将介绍以下内容：

* **为什么**，试着解释逆向工程的所有好处
* **是什么**，我们将构建什么，不构建什么
* **构建**，手把手教你构建过程

## 为什么

很多年前，在我作为一位软件开发人员的职业生涯开始的时候，我询问过一些高级开发人员他们如何进步。其中一个突出的答案是**逆向工程**，或者更确切地说是重建他们正在使用或者感兴趣的框架或库。

> 对我来说听起来像是在试图重新造轮子。有什么好处，难道我们没有足够的库来做同样的事情吗？

当然，这个论点是有道理的。不要因为不喜欢库的某些地方就重新造轮子，除非你真的需要，但有时候你确实需要重新造轮子。

> 什么时候？

当你想要在你的职业中变得更好的时候。

> 听起来很模糊

确实，毕竟有很多方法可以让你变得更好。我认为要真正理解某些东西仅仅使用它是不够的 —— 你需要**构建**它。

> 什么？全部吗？

取决于库或框架的大小。有些库足够小，值得从头构建，但大多数都不是。尝试实现某些东西有着很多价值，仅仅是开始就能让你明白许多（**如果卡住了**）。这就是练习的目的，试着理解更多。

## 是什么

我们在开头提到了构建一个测试库，具体是哪个测试库呢？我们来看下大部分 JavaScript 里的测试库长什么样子：

```js
describe('suite', () => {
  it('should be true', () => {
    expect(2 > 1).toBe(true)
  })
})
```

这就是我们将要构建的东西 —— 让上述代码成功运行并且在构建过程中评论架构好坏，有可能的话，放进一个库里使其美观 :)

让我们开始吧。

## 构建

**If you build it they will come（只要付出就会有回报）。**

> 真的吗？

你知道电影《梦幻之地（Field of Dreams）》吗？

> 别啰嗦快开始吧

### Expect，断言我们的值

让我们从最基础的声明开始 —— `expect()` 函数。通过调用方式我们可以看出很多：

```js
expect(2 > 1).toBe(true)
```

`expect()` 看起来像是接收一个 `boolean` 作为参数的函数，它返回一个对象，对象有一个 `toBe()` 方法，这样就可以将 `expect()` 的值以及传递给 `toBe()` 函数的值进行比较。让我们试着去写出大概：

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

另外，如果匹配成功或者失败，我们应该反馈一些声明。因此需要更多代码：

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

注意 `else` 的声明有一些更专业的信息并给我们提供失败提示。

类似这样比较两个值的函数例如 `toBe()` 被称为 `matcher`。让我们尝试添加另一个 matcher `toBeTruthy()`。**truthy** 匹配 JavaScript 中的很多值，这样我们可以不用 `toBe()` 去匹配所有东西。

> 所以我们在偷懒？

对的，这是最佳的理由 :)

在 JavaScript 中，任何被认为是 truthy 的值都能成功执行，其它都会失败。让我们去 MDN 看看那些值被认为是 **truthy** 的：

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

所以所有在 `if` 中执行后执行为 `true` 的都为 truthy。是时候添加上述方法了：

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

我不知道你的意见，但是我觉得 `expect()` 方法开始变得臃肿了。让我们把我们的 `matchers` 放进一个 `Matchers` 类里：

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

### it，我们的测试方法

在我们的眼里它应该是这样运行的：

```js
it('test method', () => {
  expect(3).toBe(2)
})
```

好的，将这点东西逆向工程我们差不多能写出我们自己的 `it()` 方法：

```js
function it(testName, fn) {
  console.log(`test: ${testName}`);
  fn();
}
```

让我们停下来思考一下。我们想要什么样的行为？我看到过一旦出现故障就退出运行的单元测试库。我想如果你有 200 个单元测试（并非说你应该在一个文件里放 200 个测试），我们也绝对不想等待它们完成，最好直接告诉我哪里报错，好让我可以解决它。为了实现后者，我们需要稍微调整我们的 matchers：

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

这意味着我们的 `it()` 函数需要捕获所有错误：

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

如上所示，我们不仅捕获了错误并打印日志，我们还重新抛出错误以终止运行。再次，这样做的主要原因是我们认为报了错就没有必要继续测试了。你可以以合适的方式实现这个功能。

### Describe，我们的测试套件

现在，我们介绍了如何编写 `it()` 和 `expect()`，甚至还介绍了几个 matcher 方法。但是，所有测试库都应该具有套件概念，这表示这是一组测试。

让我们看看代码是什么样的：

```js
describe('our suite', () => {
  it('should fail 2 != 1', () => {
    expect(2).toBe(1);
  })

  it('should succeed', () => { // 技术上讲它不会运行到这里，在第一个测试后它将崩溃
    expect('abc').toBeTruthy();
  })
})
```

至于实现，我们知道失败的测试会引发错误，因此我们需要捕获它以避免整个程序崩溃：

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

### 运行代码

此时我们的完整代码应该如下所示：

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

当我们在终端运行 `node app.js` 时，控制台应该长这样：

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--AU3RQVD8--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/y3hmyys7hsph5gbg16bb.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--AU3RQVD8--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/y3hmyys7hsph5gbg16bb.png)

## 美化日志

如上所示，我们的代码看起来正常运行，但是它看起来**太**丑了。我们可以做什么呢？颜色，丰富的色彩将让它看起来好点。使用库 `chalk` 我们可以给日志注入生命：

```js
npm install chalk --save
```

接下来让我们添加一些颜色、一些标签和空格，我们的代码应如下所示：

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

运行之后，控制台应该如下所示：

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--Gt0KQDcz--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/nusgojpo4vmi22r8q7zx.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Gt0KQDcz--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/nusgojpo4vmi22r8q7zx.png)

## 总结

我们的目标是逆向工程一个相当小的库，如单元测试库。通过查看代码，我们可以推断它背后的内容。

我们创造了一些东西，一个起点。话虽如此，我们需要意识到大多数单元测试库都带有很多其他东西，例如，处理异步测试、多个测试套件、模拟数据、窥探更多的 `matcher` 等等。通过尝试理解你每天使用的内容可以获得很多东西，但也请你意识到你不必完全重新发明它以获得大量洞察力。

我希望你可以使用此代码作为起点，使用它、从头开始或扩展，决定权在你。

另一个可能结果是你已经足够了解 OSS 并改进其中一个现有库。

记住，只要付出就有回报：

[![](https://res.cloudinary.com/practicaldev/image/fetch/s--YY1Wgcm0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/vndsyrcrelnklmbamhhy.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--YY1Wgcm0--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/vndsyrcrelnklmbamhhy.jpg)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
