> * 原文链接 : [How do Promises Work? - Quils in Space](http://robotlolita.me/2015/11/15/how-do-promises-work.html)
* 原文作者 : [Quil](http://robotlolita.me/about/index.html)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Zhangjd](https://github.com/Zhangjd)
* 校对者: [zxc0328](https://github.com/zxc0328)、[Aaaaaashu](https://github.com/Aaaaaashu)
* 状态 :  完成

# Promise 是如何工作的?

## 目录

## 1\. 入门介绍

大部分的JavaScript实现都是单线程的，并且考虑到语言的语义，人们倾向于使用 _callbacks_ （回调函数）来管理并行的过程。在JavaScript中，虽然使用 [Continuation-Passing Style(后继传递格式)](http://matt.might.net/articles/by-example-continuation-passing-style/) 并没有什么明显的过错， 但实际上，这样做会非常容易让代码变得难以阅读和更加程序化（比起它本应有的样子）。

关于这一问题，人们已经提出了很多建议，在这当中，使用promise来让这些并行过程同时进行就是其中之一。 在这篇博文中我们将看到什么是promise，它是怎样工作的，为什么你应该/不该使用它们。

> **备注** 这篇文章假定读者至少熟悉高阶函数、闭包和回调（continuation-passing style）。 或许缺少这些知识，你也能从本文收获到一些什么，但是还是建议你先了解清楚这些概念，再回来读这篇文章。

## 2\. 从概念上理解Promise

在一开始，让我们先来回答一个非常重要的问题: “到底什么是promise?”

要回答这个问题，我们先来看一个现实生活中很常见的情景。

### 插曲: 讨厌排队的姑娘

![](http://robotlolita.me/files/2015/09/promises-01.png) 

_女生们想要在一个热闹的餐馆里吃晚餐。_

Alissa P. Hacker 和她的女性朋友决定到一个非常受欢迎的餐馆吃晚餐。 不幸的是，正如预想的那样，当她们到达的时候所有的餐桌都被占用了。

在一些地方，这意味着她们要不选择放弃，要不选择去别的地方吃，又或者在这排长队，直到有空桌。 但是还好，这个地方给讨厌排队的Alissa提供了完美的解决方法。

> “这是一个有魔力的装置，它代表着你未来的餐桌……”

![](http://robotlolita.me/files/2015/09/promises-02.png) 

_代表着未来餐桌的装置。_

“别担心，亲爱的，只要拿着这款装置，它会帮你处理好一切。” 餐厅里的女士手里拿着一个小盒子对她说。

“这是啥……?” Alissa的朋友，Rue Bae问。

“这是一个有魔力的装置，它代表着你在这家餐厅里将来的餐桌,” 女士一边说，一边示意Bae， “其实里面并没有魔力，但是当排到你的时候，它会通知你们，然后你们就可以过来用餐了。” 她低声说道。

### 2.1\. 什么是Promises?

就像那个“有魔力的”装置可以代表着你未来在餐厅里的餐桌，promise的存在，就是为了代表将会在未来发生的_某些事情_。 在编程语言中，这指的就是值(values)。

![](http://robotlolita.me/files/2015/09/promises-03.png) 

_放进整个苹果，出来的是苹果片_

在同步的世界里，当想到函数时，我们很容易理解计算: 你把输入放进函数里，函数就会给出一些内容作为输出。

这种 _输入输出_ 的模型很容易理解，大部分程序员对此也非常熟悉。 所有JavaScript的句法结构与内建功能，都假设你的函数会跟随这一模型。

可是这一模型有一个大问题: 当我们要给函数提供了输入，为了让我们获得想要的输出，我们需要一直坐等直到函数完成它的工作。 但是理想情况是：我们想要在这段时间内尽量多做点别的事情，而不光是坐着等待。

为了解决这种问题，promise被提了出来，我们会立刻取得某种表示形式来代表这个值，而不需要一直等到最终结果出来。 我们可以继续我们的生活，然后在某个时间点，回来取得我们所需要的值。

> Promise是最终结果的表示形式。

![](http://robotlolita.me/files/2015/09/promises-04.png) 

_放进整个苹果，随后出来一张苹果切片的票据。_

### 插曲: 执行顺序

现在我们希望明白什么是promise，我们可以看看promise是怎么帮助我们更容易写并行程序的。 但在这之前，让我们先后退一步，思考一个更基本的问题: 程序代码的执行顺序。

作为一个JavaScript程序员，你可能已经注意到，你的程序以一种非常特殊的顺序执行，恰好是你在程序源码中所写指令的顺序:

```
var circleArea = 10 * 10 * Math.PI;
var squareArea = 20 * 20;
```

如果我们执行这个程序，首先我们的JavaScript虚拟机会运行计算`circleArea`，一旦计算完成，再执行`squareArea`的计算。 换句话说，我们的程序会告诉机器，“做这个，再做那个，然后再做那个……”

> **问题时间!** 为什么我们的机器一定要先计算 `circleArea` 再计算 `squareArea`? 如果我们颠倒顺序或者同时执行，会产生什么问题呢?

事实证明，按顺序执行每样东西的代价是很高的。如果 `circleArea` 花费太多时间，我们将会阻塞 `squareArea` 执行直到前者完成。实际上，对于这一个例子，我们选择什么样的顺序都没问题，结果是一样的。我们程序中可以任意调整这个顺序。

> […] 按顺序执行的代价是非常高的。

我们想要我们的计算机做更多事情，并且要做得更 _快_。 为了做到这样，首先我们完全去掉执行顺序。换言之，我们假设在我们的程序中所有表达式在同一时间执行。

这个方法很适合我们之前的例子。但是当我们做一点细微改变的时候，问题就来了:

```
var radius = 10;
var circleArea = radius * radius * Math.PI;
var squareArea = 20 * 20;
print(circleArea);
```

如果我们没有遵循任何顺序，怎么做到组合其他表达式计算的值呢? 好吧，我们办不到，因为没办法保证当我们需要用到值的时候，它已经被计算出来。

来换种方法，在我们程序中，唯一的顺序被定义为表达式的组件之间的相互依赖关系。在本质上，这意味着一旦表达式的组件计算好了，就可以马上执行，即使其它内容还在执行中。

![](http://robotlolita.me/files/2015/09/promises-05.png) 

_我们的简单例子里的依赖关系图。_

不是非要声明我们执行程序时应该用哪种顺序，我们只需要定义好每一个计算是如何相互依赖的。 手里拿着这些数据，电脑可以创建如上的依赖关系图，并自己推断出最高效执行程序的方式。

> **有趣的事实!** 这个图表很好地描述了程序在Haskell编程语言中是怎样求值的，它也非常接近于表达式在更加熟知的系统中（比如Excel）的求值方法。

### 2.2\. Promise和并发

前面一章所描述的执行模型，其执行顺序被简单定义为每个表达式间的依赖关系，这是非常强大且高效的，但我们如何应用到JavaScript中呢?

我们不能直接把这个模型应用到JavaScript，因为这门语言的内在语义是同步顺序的。但我们可以创造一种分离机制，来描述表达式之间的依赖，并且帮助我们解决这些依赖关系，然后根据这些规则执行程序。其中一种实现方法，就是通过在promise之上引入依赖的概念.

这种promises的新机制由两个主要部分构成: 一是可以作为值的表现形式（representations），并把值放入这种表示形式中；二是创建表达式（expressions）和值（values）之间的依赖关系（dependencies），创建一个新的promise，就是为了取得表达式的结果。

![](http://robotlolita.me/files/2015/09/promises-06.png) 

_创建代表着未来值的表示形式。_ 

![](http://robotlolita.me/files/2015/09/promises-07.png) 

_创建值和表达式之间的依赖关系_

我们的promise代表着我们还没计算出来的值。这个表示形式是不透明的: 我们看不见值，也不能直接和值相互作用。此外，在JavaScript的promise中，我们也不能从表示形式中取出值。一旦你把一些东西放进一个JavaScript promise，你 **不能** 从promise里面直接取出来。(http://robotlolita.me/2015/11/15/how-do-promises-work.html#fn:1)

这本身没什么用，因为我们需要能够以某种方法使用这些值。如果我们不能从表示形式中取出值，我们需要想别的办法去实现。结果解决 “取出问题”的最简单方法，是通过描述我们想怎么让程序去执行，通过明确地提供依赖关系，然后解决这个依赖关系图并执行它。

要做点这点，我们需要一种方法插进表达式中的实际值，然后延迟表达式的执行，直到它确实被需要。幸运的是，JavaScript中的first-class functions（一等函数）可以达到这个目的。

### 插曲: 表达式的抽象

比如像 `a + 1` 这种表达式，一旦 `a` 的值计算出来，可以通过值来代入 `a` 来抽象化表达式。按这种方式，表达式:

```
var a = 2;
a + 1;
// { 用 `a` 的当前值替换 }
// => 2 + 1
// { 简化表达 }
// => 3
```

再变成以下的lambda抽象(http://robotlolita.me/2015/11/15/how-do-promises-work.html#fn:2):

```
var abstraction = function(a) {
  return a + 1;
};

// 然后我们给 `a` 装上值:
abstraction(2);
// => (a => a + 1)(2)
// { 用提供的值替换 `a` }
// => (2 => 2 + 1)
// { 简化表达式 }
// => 2 + 1
// { 简化表达式 }
// => 3
```

First-class functions是一个很强大的概念（不管是否 lambda 抽象）。因为有了这个，JavaScript可以用一个非常自然的方式去描述这些依赖关系，通过转换使用了promise值的表达式为first-class functions，我们可以在随后插入值。

## 3\. 理解Promise的机制

### 3.1\. Promise的顺序表达

既然我们看过了promise的概念本质，我们开始理解它们在机器中是怎么样工作的。我们将会描述创建promise用到的操作，再把值放进去，然后描述表达式和值之间的依赖。为了方便举例，我们接下来将会用到非常直观的操作，这些操作恰好没有被现存的promise实现使用:

*   `createPromise()` 构造出一个值的表示形式。这个值必须要在之后及时提供。

*   `fulfil(promise, value)` 把值放进promise中，也允许表达式依赖值去计算。

*   `depend(promise, expression)` 定义了表达式和promise的值之间的依赖。返回一个新的promise作为表达式的结果，以便新的表达式可以依赖于那个值。

让我们回到圆形和正方形的例子。目前，我们用简单点的例子开始: 通过使用promises，把同步的`squareArea`变成一个用并行描述的程序。`squareArea`之所以简单，因为它只依赖于`side`值:

```
// 表达式:
var side = 10;
var squareArea = side * side;
print(squareArea);

// 变成:
var squareAreaAbstraction = function(side) {
  var result = createPromise();
  fulfil(result, side * side);
  return result;
};
var printAbstraction = function(squareArea) {
  var result = createPromise();
  fulfil(result, print(squareArea));
  return result;
}

var sidePromise = createPromise();
var squareAreaPromise = depend(sidePromise, squareAreaAbstraction);
var printPromise = depend(squareAreaPromise, printAbstraction);

fulfil(sidePromise, 10);
```

这里会引起很多议论，如果我们和同步版本的代码相比较，可是这个新版本并没有和JavaScript的执行顺序相关联，在执行中的唯一约束，是我们所描述的依赖关系。

### 3.2\. 一个最小限度的promise实现

还有一个悬而未决的问题需要回答: 我们如何运行代码，可使得实际顺序跟我们描述的依赖关系一样呢? 如果我们没有跟随JavaScript的执行顺序，别的东西必须提供我们想要的执行顺序。

幸运地，在我们所使用的函数里，这很容易被定义。首先，我们必须决定如何表示值和其依赖关系，最自然的方式是把这个数据添加到`createPromise`的返回值。

首先，_事物_的promises必须可以表示那个值，然而并不是在所有时间都必须包含一个值。当我们调用`fulfil`时，值才会被放入到promise。这个最小限度的表示形式就是:

```
data Promise of something = {
  value :: something | null
}
```

`Promise of something`以空值`null`初始化，在某个时间点，某个人可能调用这个promise的`fulfil`函数，从那以后这个promise将包含给定的实现值 (fulfilment value)。由于promise只能fulfill一次，那个值将会在剩余的程序中一直包含着。

考虑到一个promise不能只通过`value`（因为`null`也是一个有效值）来判断是否被fulfil，我们还需要跟踪promise处于哪种状态，所以我们不会冒险多于一次去调用fulfil。这需要我们对之前的表示形式做一点小改变:

```
data Promise of something = {
  value :: something | null,
  state :: "pending" | "fulfilled"
}
```

我们还需要处理由`depend`函数创建出的依赖关系。一个依赖关系是一个函数，最终将会被promise中的值所填充，所以它是可以被评估的。一个promise可以有很多依赖其值的函数，因此这样的一个最小限度表示形式可以是:

```
data Promise of something = {
  value :: something | null,
  state :: "pending" | "fulfilled",
  dependencies :: [something -> Promise of something_else]
}
```

既然我们已经决定好promise的表示形式，让我们一起开始定义创建新promise的函数:

```
function createPromise() {
  return {
    // promise初始化为空值,
    value: null,
    // 待定状态的promise，所以它可以在稍后变成fulfilled,
    state: "pending",
    // 它现在还没有依赖关系。
    dependencies: []
  };
}
```

既然我们决定了我们的简单表示形式，构造一个新对象来表示是相当简单的。让我们来看点更复杂的: 附加依赖到Promise中。

解决这个问题的其中一个方法，是把所有创造出的依赖放入promise的 `dependencies` 属性中，然后把promise交给解释器按需计算。用这种实现，解释器开启之前将没有依赖关系会被执行。我们不会这样去实现promise，因为这对于人们通常所写的JavaScript程序并不适合(http://robotlolita.me/2015/11/15/how-do-promises-work.html#fn:3)。

另一种解决方案，来源于这个事实：我们只有当promise处于`pending`状态时，才真正需要跟踪一个promise的依赖关系，因为一旦promise被调用fulfil，我们就可以立刻执行函数了！

```
function depend(promise, expression) {
  // 当我们可以计算表达式的时候，我们需要返回一个包含表达式的值的promise
  var result = createPromise();

  // 假若我们还不能执行表达式，把它放进依赖列表，作为未来的值
  if (Promise.state === "pending") {
    Promise.dependencies.push(function(value) {
      // 我们关心的是表达式最后的值，所以我们可以把值放进我们的promise结果中
      depend(expression(value), function(newValue) {
        fulfil(result, newValue);
        // 我们返回一个空的promise，因为`depend`函数需要一个promise
        return createPromise();
      })
    });

  // 否则只需要执行表达式，我们就可以得到准备好插入的值
  } else {
    depend(expression(promise.value), function(newValue) {
      fulfil(result, newValue);
      // 我们返回一个空的promise，因为`depend`函数需要一个promise
      return createPromise();
    })
  }

  return result;
}
```

当`depend`函数等待的值准备好的时候，`depend`函数负责执行我们的依赖关系计算，但如果我们太早附加依赖，那样函数会在promise对象的一个数组中结束，这样我们的工作并没有完成。对于第二部分的执行，需要在得到值的时候，运行依赖关系。幸运地，我们可以使用`fulfil`函数。

通过调用`fulfil`函数把我们的值放进promise当中，我们可以实现正处于`pending`状态的promise。这是一个好时机，来调用promise值可以用之前所创建的任何的依赖关系，并负责另外一半的执行工作。

```
function fulfil(promise, value) {
  if (promise.state !== "pending") {
    throw new Error("Trying to fulfil an already fulfilled promise!");
  } else {
    promise.state = "fulfilled";
    promise.value = value;
    // 依赖关系可以添加其他的依赖到这个promise当中，
    // 因此我们需要清理依赖列表，
    // 把列表复制出来以避免我们的的迭代受影响。
    var dependencies = promise.dependencies;
    promise.dependencies = [];
    dependencies.forEach(function(expression) {
      expression(value);
    });
  }
}
```

## 4\. Promise和错误处理

### 插曲: 当计算失败的时候

并非所有计算都总能产生一个有效值。某些函数，比如`a / b`或`a[0]`，称作部分函数，因此只能被定义为`a`或`b`的可能取值的子集。 如果我们写的代码包含了部分函数，并碰上了一种函数不能处理的情况，我们就不能继续执行程序了。换句话说，我们的整个程序会崩溃。

一个更好的在程序中包含部分函数的方法是通过让它变得完整。也就是说，定义函数之前没被定义的部分。总之，我们要考虑让函数处理“成功”的情况，和不能处理的“失败”情况。仅这一点，就已经足以让我们写出整个程序，甚至当面临计算不能产生出一个有效值的时候，也可以继续执行:

![](http://robotlolita.me/files/2015/09/promises-08.png)

_部分函数的分支_

一个合理但不一定实用的处理方法，是在每一个可能的失败值上建立分支来处理。比如，我们组合了三个可能失败的计算，意味着我们至少要定义6个不同的分支!

![](http://robotlolita.me/files/2015/09/promises-09.png) 

_在每个部分函数都建分支_

> **有趣的事实!** 对一些编程语言，比如 OCaml，更喜欢这种风格的错误处理，因为这样可以很清楚每个步骤。通常来说函数式编程语言偏爱这种明确性，但在某些编程语言，比如 Haskell，使用一个称作Monad的接口(http://robotlolita.me/2015/11/15/how-do-promises-work.html#fn:4)来让错误处理（比起其它处理方式）变得更为实用。

更理想的方法是，我们只需要写`y / (x / (a / b))`，然后对整个组合式只处理一次错误，而不是处理每一个子表达式的错误。编程语言对此有不同的处理方法，比如 C 和 Go，让你可以完全忽略错误，或者至少尽可能延迟碰它。比如Erlang，会让程序崩溃，但也会提供工具让你的程序恢复运行。但最通用的方法，是给可能发生错误的代码块定义一个“错误处理程序”。JavaScript允许通过`try/catch`声明，实现后一种方法，比如：

![](http://robotlolita.me/files/2015/09/promises-10.png)

_一种错误处理的可行方法_

### 4.1\. 用Promise处理错误

至今，我们的promise构想中，还没允许失败。因此，所有在promises中的计算必须产生一个有效的结果。如果我们要在promise中运行像 `a / b` 这样的计算，如果 `b` 取 0，比如 `2 / 0`，那样的话计算不能产生有效的结果。

![](http://robotlolita.me/files/2015/09/promises-11.png)

_我们的新promise的可能状态_

我们可以很容易修改promise，来考虑失败的表达方式。当前我们的promise以`pending`状态开始，然后它只能被满足。假如我们增加一个新的状态`rejected`，然后我们就可以在promise当中模仿部分函数了。成功的计算以`pending`开始，最终以`fulfilled`状态结束。失败的计算也以`pending`开始，但状态最后会变为`rejected`。

既然现在我们有可能失败，依赖于promise的值的计算也必须要意识这一点。目前我们的`depend`失败只需在promise变成`fulfilled`或者`rejected`的时候各自运行不同的表达式。

带着这个，我们的promise表示形式变成了:

```
data Promise of (value, error) = {
  value :: value | error | null,
  state :: "pending" | "fulfilled" | "rejected",
  dependencies :: [{
    fulfilled :: value -> Promise of new_value,
    rejected  :: error -> Promise of new_error
  }]
}
```

Promise可能包含一个合适的值，或者一个错误，又或者是 `null` 直到它解决（可能是`fulfilled`或者`rejected`）。要这样处理的话，我们的依赖关系也需要知道对于合适值和错误值分别怎样处理，因此稍微改变一下dependencies数组。

除了在表示形式中的改变，我们还要改一下 `depend` 函数，现在读起来就像这样:

```
// 注意我们现在需要两个表达式了，而不是一个。
function depend(promise, onSuccess, onFailure) {
  var result = createPromise();

  if (promise.state === "pending") {
    // 依赖关系现在拿到一个对象，包含了promise在成功与失败情况下分别该怎么做。
    // 函数和前面的大致相同。
    promise.dependencies.push({
      fulfilled: function(value) {
        depend(onSuccess(value),
               function(newValue) {
                 fulfil(result, newValue);
                 return createPromise()
               },
               // 我们在应用表达式的时候也必须关心错误
               function(newError) {
                 reject(result, newError);
                 return createPromise();
               });
      },

      // 失败的分支和成功的分支做的事情是一样的，只不过是使用onFailure表达式。
      rejected: function(error) {
        depend(onFailure(error),
               function(newValue) {
                 fulfil(result, newValue);
                 return createPromise();
               },
               function(newError) {
                 reject(result, newError);
                 return createPromise();
               });
        }
      });
    }
  } else {
    // 如果promise已经成功实现，我们运行onSuccess
    if (promise.state === "fulfilled") {
      depend(onSuccess(promise.value),
             function(newValue) {
               fulfil(result, newValue);
               return createPromise();
             },
             function(newError) {
               reject(result, newError);
               return createPromise();
             });
    } else if (promise.state === "rejected") {
      depend(onFailure(promise.value),
             function(newValue) {
               fulfil(result, newValue);
               return createPromise();
             },
             function(newError) {
               reject(result, newError);
               return createPromise();
             });
    }
  }

  return result;
}
```

最终，我们需要一个把错误放进promise的方法。为此我们需要一个 `reject` 函数：

```
function reject(promise, error) {
  if (promise.state !== "pending") {
    throw new Error("Trying to reject a non-pending promise!");
  } else {
    promise.state = "rejected";
    promise.value = error;
    var dependencies = promise.dependencies;
    promise.dependencies = [];
    dependencies.forEach(function(pattern) {
      pattern.rejected(error);
    });
  }
}
```

由于`dependencies`改变了，我们还要轻微改变下 `fulfil` 函数。

```
function fulfil(promise, value) {
  if (promise.state !== "pending") {
    throw new Error("Trying to fulfil a non-pending promise!");
  } else {
    promise.state = "fulfilled";
    promise.value = value;
    var dependencies = promise.dependencies;
    promise.dependencies = [];
    dependencies.forEach(function(pattern) {
      pattern.fulfilled(value);
    });
  }
}
```

有了这些新内容，我们已经准备好把可能失败的计算放进promise中：

```
// 可能失败的计算
var div = function(a, b) {
  var result = createPromise();

  if (b === 0) {
    reject(result, new Error("Division By 0"));
  } else {
    fulfil(result, a / b);
  }

  return result;
}

var printFailure = function(error) {
  console.error(error);
};

var a = 1，b = 2，c = 0，d = 3;
var xPromise = div(a, b);
var yPromise = depend(xPromise,
                      function(x) {
                        return div(x, c)
                      },
                      printFailure);
var zPromise = depend(yPromise,
                      function(y) {
                        return div(y, d)
                      },
                      printFailure);
```

### 4.2\. Promises的错误传播

上一段代码永远不会执行 `zPromise`，因为 `c` 的值是0，并导致了 `div(x，c)` 计算失败。这正是我们希望的，但是现在我们需要的是：在promise中定义的每一个计算都传递错误。理想情况下，我们喜欢只在必要情况之下定义错误分支，就像我们用 `try/catch` 处理同步的计算一样。

对我们的promise来说，支持这一功能并不重要。只需要在我们不能抽象的时候，始终定义我们的成功与失败分支，并且这通常是在控制流中的条件。比如在JavaScript中，不可能在 `if` 声明或者 `for` 声明上面抽象，因为他们是二等控制流机制了，并且你也不能修改、传递，或者保存在变量当中。我们的promise是一等的对象，有具体的失败与成功的表示形式，以便我们去审查并作出反应什么时候需要它，而不仅仅在它们被创建的时间点上。

![](http://robotlolita.me/files/2015/09/promises-12.png)

_promise可能的链式生命周期_

为了可以得到类似于 `try/catch` 这样的结构，首先，我们必须在成功和失败的表示形式上做到这两点：

*   **从错误中恢复**: 如果计算失败了，我必须可以把值变成某种有意义的成功。比如说，当从 `Map` 或者 `Array` 中尝试取值时，设置默认值。如果map中不存在 `"foo"` 这个键，`map.get("foo").recover(1) + 2` 会返回3。

*   **任何时候可能失败**: 如果我计算成功了，我必须可以把那个值变成失败；如果我失败了，我必须可以保持这个失败。前面的模型允许了计算短路（short-circuiting），后面这个则允许了错误传播。有了这两个，即使 `(a / b) / (c / d)` 的任何的子表达式失败了，你也可以完全去捕获它。

很幸运，`depend` 函数已经帮我们完成了大部分工作了。因为 `depend` 要求它的表达式返回_整个_ promise，使得其不仅可以传播值，也可以传播状态。这很重要，因为如果我们只定义了一个 `successful` 分支，然后promise失败了，我们就不仅要传播值，也要传播失败的状态。

带着这些适如其分的机制：支持简单的失败传播，错误处理，和失败时短路，还需要添加两个操作：`chain` 在promise的成功值上创建一个依赖关系，在失败时进行短路计算；`recover` 在promise的失败值上创建依赖关系，并允许从错误中恢复。

```
function chain(promise, expression) {
  return depend(promise, expression,
                function(error) {
                  // 只需要创建一个等价的promise，我们便可以传播错误状态和相应值。
                  var result = createPromise();
                  reject(result, error);
                  return result;
                })
}

function recover(promise, expression) {
  return depend(promise,
                function(value) {
                  // 只需要创建一个等价的promise，我们便可以传播成功值。
                  var result = createPromise();
                  fulfil(result, value);
                  return result;
                },
                expression)
}
```

我们可以用这两个函数来简化我们之前的除法例子：

```
var a = 1，b = 2，c = 0，d = 3;
var xPromise = div(a, b);
var yPromise = chain(xPromise, function(x) {
                                 return div(x, c)
                               });
var zPromise = chain(yPromise, function(y) {
                                 return div(y, d);
                               });
var resultPromise = recover(zPromise, printFailure);
```

## 5\. 组合promise

### 5.1\. 组合确定性的promise

对promise进行顺序操作时，要求我们创建一个依赖关系链，而并行组合promise只要求promise不存在相互间依赖。

在我们的圆形例子中，我们自然地进行了并行计算。`radius` 表达式和 `Math.PI` 表达式之间没有互相依赖，因此它们可以分开计算，但是 `circleArea` 依赖它们俩的值。依据这个，代码可以写成：

```
var radius = 10;
var circleArea = radius * radius * Math.PI;
print(circleArea);
```

如果用promise来表达，代码如下：

```
var circleAreaAbstraction = function(radius, pi) {
  var result = createPromise();
  fulfil(result, radius * radius * pi);
  return result;
};

var printAbstraction = function(circleArea) {
  var result = createPromise();
  fulfil(result, print(circleArea));
  return result;
};

var radiusPromise = createPromise();
var piPromise = createPromise();

var circleAreaPromise = ???;
var printPromise = chain(circleAreaPromise, printAbstraction);

fulfil(radiusPromise, 10);
fulfil(piPromise, Math.PI);
```

这里有个小问题: `circleAreaAbstraction` 是依赖于 **两个** 值的表达式，但是 `depend` 只能够定义表达式和单个值的依赖！

有些变通的方法可以解决这个限制，让我们从简单的开始。如果 `depend` 对一个表达式能提供单个值，那就必须能够在一个闭包中获取值，然后从promise中每次提取一个值。虽然这样确实创建出一种隐含的执行顺序，但这应该没有过分影响并发性。

```
function wait2(promiseA, promiseB, expression) {
  // 我们先从 promiseA 提取值
  return chain(promiseA, function(a) {
    // 然后从 promiseB 提取值
    return chain(promiseB, function(b) {
      // 既然我们已经取得两个值了，我们就可以执行依赖多于一个值的表达式：
      var result = createPromise();
      fulfil(result, expression(a, b));
      return result;
    })
  })
}
```

有了这个，我们定义如下的 `circleAreaPromise` ：

```
var circleAreaPromise = chain(wait2(radiusPromise, piPromise),
                              circleAreaAbstraction);
```

对于依赖三个值的表达式我们可以定义 `wait3` ，依赖四个值的表达式我们可以定义 `wait4`等。但是，`wait*` 创建出一种隐含顺序(promise以某种特定顺序执行)，这样还要求我们提前知道我们需要依赖多少个值。所以，举个例子，如果我们想等待一整个promise数组的话，这种方法就不好使了。（尽管可以通过组合 `wait2` 和 `Array.prototype.reduce`来这么做）

另一种解决方案是接收一个promise数组作为参数，逐一执行，然后归还一个promise到原promise包含的值数组。这种方法有点复杂，因为我们要实现一个简单的有限状态机，但是这样没有隐含顺序（除了JavaScript自己的执行语义）。

```
function waitAll(promises, expression) {
  // 用于存放promise值的数组，一旦有值会马上放进该数组。
  var values = new Array(promises.length);
  // 记录有多少个promise还在等待着
  var pending = values.length;
  // promise结果
  var result = createPromise();
  // 记录promise是否已经被解决
  var resolved = false;

  // 我们开始执行每个promise，并跟踪原始索引值，以此来获取应该把值放进结果数组的哪个位置。
  promises.forEach(function(promise, index) {
    // 对于每个promise，我们会等到promise解决，然后把值存入 `values` 数组
    depend(promise, function(value) {
      if (!resolved) {
        values[index] = value;
        pending = pending - 1;

        // 如果我们完成了等待所有的promise，我们可以把values数组放进结果的promise中。
        if (pending === 0) {
          resolved = true;
          fulfil(result, values);
        }
      }
      // 我们不关心这个promise的其它方面，并返回空promise，因为`depends`需要它。
      return createPromise();
    }, function(error) {
      if (!resolved) {
        resolved = true;
        reject(result, error);
      }
      return createPromise();
    })
  });

  // 最后，我们返回一个promise，作为最终的值数组。
  return result;
}
```

如果我们要把 `waitAll` 用到 `circleAreaAbstraction`，应该会像下面这样：

```
var circleAreaPromise = chain(waitAll([radiusPromise, piPromise]),
                              function(xs) {
                                return circleAreaAbstraction(xs[0]，xs);
                              })
```

### 5.2\. 组合非确定性的promise

我们已经知道怎样合并promise了，但是到现在我们只能确定性地合并它们。举个例子，比如我们想选择两个计算中最快一个的时候，这就帮不到我们了。或许我们正在两台服务器上面搜索某些东西，而且并不关心哪一台会应答我们，我们只选择最快那一个。

为了支持这样，我们先介绍一些非决定论的知识。特别是，我们需要一个操作是，给定两个promise，拿走更快那个的值与状态。这个主意背后的操作很简单：并行运行两个promise，等待第一个解决，然后把它传到promise结果中。但实现起来并不那么简单，因为我们需要保持着状态。

```
function race(left, right) {
  // 创建promise结果
  var result = createPromise();

  // 并行等待两个promise，doFulfil 和 doReject 会传播第一个解决的promise的值/状态。
  // 这通过检查 `result` 的当前状态并确认是等待中来完成。
  depend(left, doFulfil，doReject);
  depend(right, doFulfil，doReject);

  // 返回promise结果
  return result;

  function doFulfil(value) {
    if (result.state === "pending") {
      fulfil(result, value);
    }
  }

  function doReject(value) {
    if (result.state === "pending") {
      reject(result, value);
    }
  }
}
```

通过这种非确定的选择，我们就可以开始组合操作了。就拿上面的例子来说：

```
function searchA() {
  var result = createPromise();
  setTimeout(function() {
    fulfil(result, 10);
  }, 300);
  return result;
}

function searchB() {
  var result = createPromise();
  setTimeout(function() {
    fulfil(result, 30);
  }, 200);
  return result;
}

var valuePromise = race(searchA(), searchB());
// => valuePromise最终的值是30
```

在两个promise中作出选择已经成为了可能，因为 `race(a, b)` 基本就变成了 `a` 或 `b`，依赖于哪个解决得更快。因此，如果我们进行 `race(c，race(a, b))`，并且 `b` 先解决，然后就变得和 `race(c, b)` 一样了。当然了，输入 `race(a, race(b，race(c, ...)))` 并非最佳，因此我们可以写一个简单的组合器来完成这件事：

```
function raceAll(promises) {
  return promises.reduce(race, createPromise());
}
```

然后我们可以这样使用:

```
raceAll([searchA(), searchB(), waitAll([searchA(), searchB()])]);
```

另一种在两个promise中作出非确定性选择的方法，是等待第一个_成功满足_的promise。举个例子，如果你正试图从一个镜像源列表里面找出一个可用的下载链接，你可不想因为第一个链接不能下载而失败了，你想要的是从第一个能下载的镜像进行下载，如果全都不能下才算失败。我们可以写一个`attempt`操作来这么做： 

```
function attempt(left, right) {
  // 创建promise结果
  var result = createPromise();

  // doFulfil会传第一个成功解决的值与状态。
  // 反之，doReject会合计错误，直到所有的promise失败
  //
  // 我们需要跟踪发生的错误
  var errors = {}

  // 现在我们可以等待两个promise，就像在`race`中那样。
  // 不同的是，在这里`doReject`需要知道拒绝哪一个promise，并保持跟踪错误。
  depend(left, doFulfil，doReject('left'));
  depend(right, doFulfil，doReject('right'));

  // 最后，把promise结果作为返回值。
  return result;

  function doFulfil(value) {
    if (result.state === "pending") {
      fulfil(result, state);
    }
  }

  function doReject(field) {
    return function(value) {
      if (result.state === "pending") {
        // 如果我们还在等待中，我们可以安全地一直收集错误。
        // 我们确保得到的错误能进入对象中正确收集这些错误的地方
        errors[field] = value;

        // 如果我们设法收集了所有的错误，我们可以拒绝promise结果。
        // 我们在所有错误都发生时，以正确顺序拒绝它。
        if ('left' in errors && 'right' in errors) {
          reject(result, [errors.left, errors.right]);
        }
      }
    }
  }  
}
```

和 `race` 用法一样，`attempt(searchA(), searchB())` 会返回第一个_成功_解决的promise，而不仅是第一个解决的promise。可是，和 `race` 不一样，`attempt` 不会自然构成，因为它会聚集错误。因此，如果我们想尝试几个promise时，我们需要解释下：

```
function attemptAll(promises) {
  // 由于我们聚集了所有的promise，我们需要从被拒绝的一个promise开始，
  // 否则，如果存在错误，我们的尝试将一直不能完成。
  var initial = createPromise();
  reject(initial, []);

  // 最后，我们用 `attempt` 来把promise组合起来，注意每一步都要平铺错误数组：
  return promises.reduce(function(result, promise) {
    return recover(attempt(result, promise), function(errors) {
      return errors[0].concat([errors]);
    });
  }, createPromise());
}

attemptAll([searchA(), searchB(), searchC(), searchD()]);
```

## 6\. 对Promise的一种实际理解

[ECMAScript 2015](http://www.ecma-international.org/ecma-262/6.0/) 定义了JavaScript中promise的概念，但直到现在，我们使用的还是一个非常简单却非常规的promise实现。其原因是ECMAScript的promise标准过于复杂，要彻底解释这个概念更加艰难。但是，既然你现在知道promise是什么了，和其中的每个方面是怎样实现的，要迁移到理解标准promise也就很简单了。

### 6.1\. 介绍ECMAScript Promise

新版本ECMAScript语言中，定义了一种JavaScript中的promise标准 [standard for promises](http://www.ecma-international.org/ecma-262/6.0/#sec-promise-constructor)。这个标准和最小限度promise实现有所不同，我们将从几个方面进行介绍，这使得它更复杂，但也更加实际和易于使用。下面的表格列出了每一个实现的不同之处。

<table>
  <thead>
    <tr>
      <th>我们的 Promises</th>
      <th>ES2015 Promises</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>p = createPromise()</td>
      <td>p = new Promise(...)</td>
    </tr>
    <tr>
      <td rowspan="2">fulfil(p, x)</td>
      <td>p = new Promise((fulfil, reject) => fulfil(x))</td>
    </tr>
    <tr>
      <td>p = Promise.resolve(x)</td>
    </tr>
    <tr>
      <td rowspan="2">reject(p, x)</td>
      <td>p = new Promise((fulfil, reject) => reject(x))</td>
    </tr>
    <tr>
      <td>p = Promise.reject(x)</td>
    </tr>
    <tr>
      <td>depend(p, f, g)</td>
      <td>p.then(f, g)</td>
    </tr>
    <tr>
      <td>chain(p, f)</td>
      <td>p.then(f)</td>
    </tr>
    <tr>
      <td>recover(p, g)</td>
      <td>p.catch(g)</td>
    </tr>
    <tr>
      <td>waitAll(ps)</td>
      <td>Promise.all(ps)</td>
    </tr>
    <tr>
      <td>raceAll(ps)</td>
      <td>Promise.race(ps)</td>
    </tr>
    <tr>
      <td>attemptAll(ps)</td>
      <td>(None)</td>
    </tr>
  </tbody>
</table>

在标准promise中，主要的方法是 `new Promise(...)` 引入一个promise对象，然后用 `.then(...)` 变换。通过以上对比，所描述的操作，它们的工作方式也有些不一样的地方。

`new Promise(f)` 构造一个新的promise对象，它通过计算，最终带着某个特定值将状态变为成功或失败。成功或失败的行为，按照预期传递到函数 `f`， `f` 是带有两个参数的函数对象。第一个参数用在处理执行成功的场景，第二个参数则用在处理执行失败的场景，因此：

```
var p = createPromise();
fulfil(p, 10);

// 变为:
var p = new Promise((fulfil, reject) => fulfil(10));

// ---
// 并且:
var q = createPromise();
reject(q, 20);

// 变为:
var p = new Promise((fulfil, reject) => reject(20));
```

`Promise.then(f, g)` 是一个操作，它在一个有空洞的表达式和一个值之间创建依赖关系，类似于 `depend` 操作。`f` 和 `g` 都是可选参数，如果它们都没被提供，promise会把值在那个状态中传播。

不像我们的 `depend`，`.then` 是一个复杂的操作，它试图让promise的使用变得更简单。传给 `.then` 的函数参数可以是一个promise，也可以是一个常规的值，在这种情况下， `.then` 操作会自动帮你把值放入到promise当中。因此：

```
depend(promise, function(value) {
  var q = createPromise();
  fulfil(q, value + 1);
  return q;
})

// ---
// 变为:
Promise.then(value => value + 1);
```

对比我们之前的构想，这样使得promise的代码变得简洁和更方便阅读。

```
var squareAreaAbstraction = function(side) {
  var result = createPromise();
  fulfil(result, side * side);
  return result;
};
var printAbstraction = function(squareArea) {
  var result = createPromise();
  fulfil(result, print(squareArea));
  return result;
}

var sidePromise = createPromise();
var squareAreaPromise = depend(sidePromise, squareAreaAbstraction);
var printPromise = depend(squareAreaPromise, printAbstraction);

fulfil(sidePromise, 10);

// ---
// 变为：
var sideP = Promise.resolve(10);
var squareAreaP = sideP.then(side => side * side);
squareAreaP.then(area => print(area));

// 这更加类似于同步的版本:
var side = 10;
var squareArea = side * side;
print(squareArea);
```

类似于我们的 `waitAll` 操作，并行依赖多个值可以通过 `Promise.all` 操作来处理：

```
var radius = 10;
var pi = Math.PI;
var circleArea = radius * radius * pi;
print(circleArea);

// ---
// 变为:
var radiusP = Promise.resolve(10);
var piP = Promise.resolve(Math.PI);
var circleAreaP = Promise.all([radiusP, piP])
                         .then(([radius, pi]) => radius * radius * pi);
circleAreaP.then(circleArea => print(circleArea));
```

失败和成功的传播通过 `.then` 操作自身来处理，另外还提供了`.catch` 操作，作为一种简洁的、无需定义成功分支的 `.then` 调用。

```
var div = function(a, b) {
  var result = createPromise();

  if (b === 0) {
    reject(result, new Error("Division By 0"));
  } else {
    fulfil(result, a / b);
  }

  return result;
}

var a = 1，b = 2，c = 0，d = 3;
var xPromise = div(a, b);
var yPromise = chain(xPromise, function(x) {
                                 return div(x, c)
                               });
var zPromise = chain(yPromise, function(y) {
                                 return div(y, d);
                               });
var resultPromise = recover(zPromise, printFailure);

// ---
// 变为:
var div = function(a, b) {
  return new Promise((fulfil, reject) => {
    if (b === 0)  reject(new Error("Division by 0"));
    else          fulfil(a / b);
  })
}

var a = 1，b = 2，c = 0，d = 3;
var xP = div(a, b);
var yP = xP.then(x => div(x，c));
var zP = yP.then(y => div(y，d));
var resultP = zP.catch(printFailure);
```

### 6.2\. 深入探究 `.then`

`.then` 方法和我们之前的 `depend` 函数相比，有几个不同之处。`.then` 是一个用来定义最终值和某些计算的依赖关系的方法，它也尝试让大部分情况下promise的使用变得更加容易。这使得 `.then` 成为了一个复杂的方法(http://robotlolita.me/2015/11/15/how-do-promises-work.html#fn:5)，但我们可以通过联系我们之前的机制，去理解这个新方法。

#### `.then` 自动适应常规值

我们的 `depend` 函数只适用于接受promise作为参数。它期待于计算依赖关系返回一个promise，目的是为了它自身的promise返回值。`.then` 却没有这个要求。如果依赖关系返回的是一个像 `42` 这样的常规值，`.then`会把值转换成一个包含该值的promise。本质上说，`.then` 会按需把常规值转换为promise。

把简化类型和我们的 `depend` 函数相比较:

    depend : (Promise of α, (α -> Promise of β)) -> Promise of β

把简化类型和 `.then` 方法相比较:

    Promise.then : (this: Promise of α, (α -> β)) -> Promise of β
    Promise.then : (this: Promise of α, (α -> Promise of β)) -> Promise of β

在 `depend` 函数里，我们唯一能做的，就是返回一个包含某些内容的promise（并且在promise结果中包含同样的东西），`.then` 函数出于方便，也接受返回一个常规值，而不需要把值包装在promise当中。

#### `.then` 不允许嵌套 promise

为了方便通常的使用情况，ECMAScript 2015 promises的另一种方法是禁止嵌套promise。通过同化带有 `.then` 方法的任何东西，会使得你在不期待同化的情景之下出问题(http://robotlolita.me/2015/11/15/how-do-promises-work.html#fn:6)，但另一方面也使大家摆脱了思考匹配返回值类型的痛苦。

受这一功能影响，不可能在非依赖类型系统中给 `.then` 方法一个明智的类型，但大概这意味着如下的例子：

```
Promise.resolve(1).then(x => Promise.resolve(Promise.resolve(x + 1)))
```

等价于:

```
Promise.resolve(1).then(x => Promise.resolve(x + 1))
```

这里执行 `Promise.resolve` ，而不是 `Promise.reject`。

#### `.then` 使异常具体化

如果一个异常同步地发生在 `.then` 方法计算依赖关系的过程中，那么异常会被捕捉到，并具体化为一个被拒绝的Promise。本质上，这意味着所有的在 `.then` 中的附加在promise的值之上的计算，都好像被包裹在 `try/catch` 代码块之中，如此:

```
Promise.resolve(1).then(x => null());
```

等价于：

```
Promise.resolve(1).then(x => {
  try {
    return null();
  } catch (error) {
    return Promise.reject(error);
  }
});
```

Promise的原生实现会追踪这些，并汇报没被处理的内容。由于没有详述promise中的一个“捕获的错误”是由什么构成，所以不同的开发工具汇报的内容有所不同。例如，Chrome开发者工具会输出所有被拒绝的实例到控制台，这可能会给你造成困扰。

#### `.then` 异步调用依赖关系

我们之前的promise实现是同步调用依赖关系计算的，标准ECMAScript promise做这个事情是异步的。如果不是用合理手段（`.then`方法）的话，我们将很难依赖一个promise的值。

因此，下面的代码将不会起作用:

```
var value;
Promise.resolve(1).then(x => value = x);
console.log(value);
// => undefined
// (`value = x` 到这里才发生，在所有其它代码运行以后)
```

这保证了依赖关系运算总是执行在一个空栈上，尽管这种保证在 ECMAScript 2015 中并不是那么重要，因为其要求所有的实现都支持适当的尾部调用(http://robotlolita.me/2015/11/15/how-do-promises-work.html#fn:7)。

## 7\. 什么时候不适合用promise？

虽然promise作为原生并发可以很好地工作，但promise既不像Continuation-Passing Style那样普遍，也不是所有用例的最佳解决方案。Promise是值的占位符，最终会被计算出来，因此它只能在上下文当中有意义，因为你可以使用那些值自身。

![](http://robotlolita.me/files/2015/09/promises-13.png)

_Promises只在**值**的上下文中起作用_

试着在想要的结果之外使用promise，包括在一些非常复杂的代码库，理解，并且扩展。以下是一些应该完全避免使用promise的例子：

*   **通知计算某个特定值的结果**。 Promise被用在和值本身一样的上下文中，所以就像我们不能知道计算某个特定的字符串的进度一样，给定字符串本身，我们不能用promise来做这个。因为这个，如果你有兴趣知道一个文件的下载进度，你会想要一个分离的东西，比如说事件。

*   **一段时间内需要产生多个值**。 Promises只能代表单个最终值。对于一段时间内要产生多个值的情况 (等价于异步迭代器)，你可能需要像流(Streams)，[Observables](http://reactivex.io/documentation/observable.html)，或者 [CSP Channels](http://www.usingcsp.com/cspbook.pdf) 这样的东西。

*   **表示动作**。 这也意味着不能按顺序执行promise，因为一旦得到一个promise，就马上开始计算它的值了。对于动作可以使用 [CPS](http://matt.might.net/articles/by-example-continuation-passing-style/)，[Continuation monad](http://www.haskellforall.com/2012/12/the-continuation-monad.html)，或者像 C♯ 那样的 [Task (co)monad](https://www.cl.cam.ac.uk/teaching/1213/R204/asynclecture.pdf)。

## 8\. 结论

Promise 允许我们组合同步与异步过程，对于处理最后返回的值是一种很棒的方式。虽然 ECMAScript 2015 里面的 promise 标准还有它自身的一系列问题，比如自动地具体化错误应该使进程崩溃，但它有一个非常好用的工具来处理上述问题。无论你是否使用他们，理解 promise 是什么和它的工作原理是很重要的，因为在所有的 ECMAScript 工程当中，它们的使用正变得越来越普遍。

## 引用

[ECMAScript® 2015 Language Specification](http://www.ecma-international.org/ecma-262/6.0/)

_Allen Wirfs-Brock_ — 定义了 JavaScript 中的 promise 标准。

[Alice Through The Looking Glass](http://www.ps.uni-saarland.de/Papers/abstracts/alice-looking-glass.html)

_Andreas Rossberg，Didier Le Botlan，Guido Tack，Thorsten Brunklaus，and Gert Smolka_ — 提出了 Alice 语言，通过 future 和 promise 支持了并发。

[Haskell 98 Language and Libraries](https://www.haskell.org/definition/haskell98-report.pdf)

_Simon Peyton Jones_ — 非正式地描述了 Haskell 编程语言的语义。

[Communicating Sequential Processes](http://www.usingcsp.com/cspbook.pdf)

_C. A. R. Hoare_ — 描述了进程的并发组合，比如确定性和非确定性的选择。

[Monads For Functional Programming](http://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf)

_Philip Wadler_ — 描述了在这当中的其他内容，monads 是如何被用在函数式语言错误处理的。尽管在 ECMAScript 2015 中，promise 没有实现 monad 的接口，但是 Promise 的顺序和错误处理非常接近于 monad 的构想。

## 附加资源

[Source Code For This Blog Post](https://github.com/robotlolita/robotlolita.github.io/tree/master/examples/promises)

包含了这篇博文里所有的（有注释的）源代码（包含一个遵循了 ECMAScript 2015 规范的 promise 最小化实现）。

[Promises/A+ Considered Harmful](http://robotlolita.me/2013/06/28/promises-considered-harmful.html)

_Quildreen Motta_ — 在复杂程度、错误处理、性能方面，讨论了Promises/A+ 和 ECMAScript 2015 Promises 标准中的一些问题。

[Professor Frisby’s Mostly Adequate Guide to Functional Programming](https://www.gitbook.com/book/drboolean/mostly-adequate-guide/details)

_Brian Lonsdorf_ — 一本关于 JavaScript 函数式编程的引导性的图书。

[Callbacks Are Imperative，Promises Are Functional: Node’s Biggest Missed Opportunity](https://blog.jcoglan.com/2013/03/30/callbacks-are-imperative-promises-are-functional-nodes-biggest-missed-opportunity/)

_James Coglan_ — 通过描述一个程序的执行顺序，对比了 Continuation-Passing Style 和 Promise。

[Simple Made Easy](http://www.infoq.com/presentations/Simple-Made-Easy)

_Rich Hickey_ — Rich在演讲中讨论了在设计的背景下的“简单”和“容易”，虽然和 promise 没有直接相关，但是和编程有很大的关系。

[Proper Tail Calls in Harmony](https://blog.mozilla.org/dherman/2011/01/30/proper-tail-calls-in-harmony/)

_Dave Herman_ — 讨论了在 ECMAScript 中合理使用尾部调用的好处。

[Your Mouse is a Database](http://queue.acm.org/detail.cfm?id=2169076)

_Erik Meijer_ — 讨论了基于事件和异步计算的Rx的协调和编制，使用了观察者的概念。

[Stream Handbook](https://github.com/substack/stream-handbook)

_James Halliday (substack)_ — 涵盖了编写 Node.js 流(Streams)程序的一些基础知识。

[By Example: Continuation-Passing Style in JavaScript](http://matt.might.net/articles/by-example-continuation-passing-style/)

_Matt Might_ — 描述了 continuation-passing style 如何被应用在 JavaScript 非阻塞计算中。

[The Continuation Monad](http://www.haskellforall.com/2012/12/the-continuation-monad.html)

_Gabriel Gonzalez_ — 基于 Haskell 编程语言环境，讨论了诸如 monads 这样的概念延续。

[Pause ‘n’ Play: Asynchronous C♯ Explained](https://www.cl.cam.ac.uk/teaching/1213/R204/asynclecture.pdf)

_Claudio Russo_ — 解释了使用 Task comonad 的异步计算在 C♯ 中如何工作，以及那个解决方案是怎样和其它模型建立联系的。

## 资源库

[es6-promise](https://www.npmjs.com/package/es6-promise)

对于没有实现 ECMAScript 2015 的平台，这是一个用来实现 ES2015 promise 的 polyfill。

[Bluebird](https://www.npmjs.com/package/bluebird)

一个高效的 Promises/A+ 实现。

#### 脚注

1.  在 JavaScript 中，你不能在 Promises/A，Promises/A+ 和其它 promise 的常见实现中，直接取出 promise 的值。

    在一些 JavaScript 环境中，比如 Rhino 和 Nashorn（译者注：都是用Java实现的JavaScript引擎），也许可以实现支持提取值的 promise。Java的 Futures 就是一个例子。

    要从 promise 取出还没计算出来的值，要求阻塞线程，直到值被计算出来。对于大多数JS环境，这并不通用，因为它们都是单线程的。 [↩](#fnref:1)

2.  “lambda抽象”是一种在表达式中使用抽象变量的匿名函数。JavaScript 的匿名函数等价于LC的Lambda抽象，然而 JavaScript 也允许给函数命名。 [↩](#fnref:2)

3.  Haskell编程语言的工作方式，就是“计算定义”和“执行计算”的分离。一个 Haskell 程序只不过是大量计算结果为 `IO` 数据结构的表达式。这个结果多少类似于我们在这里定义的 `Promise` 结构，因为它只定义了程序中不同计算之间的依赖关系。

    在Haskell中，你的程序必须返回 `IO` 类型的值，这个值会随后传递到一个单独的解释器。解释器只知道如何允许 `IO` 计算，并遵守其定义的依赖关系。对于JS，也可以定义某些类似的内容。如果我们那样做的话，所有我们的JS程序都仅仅是一个导致 promise 的表达式，并且那个 promise 会传递到一个单独的组件，这个组件知道如何执行 promise 和它的依赖关系。

    看看 [Pure Promises](https://github.com/robotlolita/robotlolita.github.io/tree/master/examples/promises/pure/) 示例目录，可作为这种 promise 形式的一个实现。 [↩](#fnref:3)

4.  Monad 是一个接口，可以（并且通常是）用作顺序语义，通过以下操作，可被描述为一个结构体：

        class Monad m where
          -- 把值放进monad中
          of    :: ∀a. a -> Monad a

          -- 在 monad 中变换值
          -- (转换必须保持类型不变)
          chain :: ∀a, b. m a -> (a -> m b) -> m b

    在这个构想中，monad 的 `chain` 操作符 `print(1).chain(_ => print(2))` 和JS的 “分号操作符” 多少有点类似(例如: `print(1); print(2)`)。 [↩](#fnref:4)

5.  这里使用了Rich Hickey的概念：“复杂”和“简单”。 `.then` 就被定义为一种简单的方法。它迎合了一般的使用案例，作为简化概念的代价，那就是 `.then` 做了太多的事情，而且这些事情有相当多的重叠。

    另一方面，一个简单的API，会把这些单独概念分离到不同的函数中，使得你可以用 `.then` 把这些功能都实现。 [↩](#fnref:5)

6.  `.then` 方法接收一切值和状态，让它们看起来像一个 promise 。在以前，这些是通过一个接口去检查，这意味着通过检查一个对象是否提供了 `.then` 方法，可以包含所有的对象，它们都不符合 promise 的 `.then` 方法。

    如果 promise 标准不受限于向后兼容性，使用现存的 promise 实现，可以进行更可靠的测试，通过使用接口符号（Symbols for interfaces），或者品牌的某些类似形式实现。 [↩](#fnref:6)

7.  适当的尾部调用保证了尾部位置的所有调用将在恒定的堆栈中发生。本质上，这保证了你的程序完全由尾部调用构成，栈将不会增加，因此，栈溢出错误在这样的代码中将不可能出现。附带地，它也允许语言实现，来让这样的代码变得更快，因为它不需要处理常见的函数调用开销。 [↩](#fnref:7)
