> - 原文地址：[Beyond console.log()](https://medium.com/@mattburgess/beyond-console-log-2400fdf4a9d8)
> - 原文作者：[Matt Burgess](https://medium.com/@mattburgess?source=post_header_lockup)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/beyond-console-log.md](https://github.com/xitu/gold-miner/blob/master/TODO1/beyond-console-log.md)
> - 译者：[Pomelo1213](https://github.com/Pomelo1213)
> - 校对者：

# 不局限于 console.log()

## 相比使用 console.log 去输出值，我们有更多的方式去调试 JavaScript 。看似我要去闲扯调试器，实则不然。

![](https://cdn-images-1.medium.com/max/2000/1*uUhNZZObj6zD9_qxrDTD9w.jpeg)

告诉写 JavaScript 的人应该使用浏览器的调试器，这看来很不错，并且肯定有其适用的时间和场合。但是大多数时候你仅仅只想查看一段特定的代码是否执行或者一个变量的值是什么，而不是迷失在 RxJS 代码库或者一个 Promise 库的深处。

然而，尽管 `console.log` 有其适用的场合，大多数人仍然没有意识到`console`本身除了基础 `log` 还有许多选择。合理使用这些方法能让调试更简单，更快速，并且更加直观。

### console.log()

标准的 console.log 有着惊人数量的函数特性，这些是人们没有预料到的。尽管多数人将它作为 `console.log(object)` 使用，但你仍然能写 `console.log(object, otherObject, string)` 并且它会将所有东西都整齐的打印出来。有时候确实很方便。

不止那些，这儿还有另一种格式：`console.lo(msg, values)`。这个执行方式和 C 或者 PHP 的`sprintf`很相似。

```
console.log('I like %s but I do not like %s.', 'Skittles', 'pus');
```

会准确的输出你所预期的东西。

```
> I like Skittles but I do not like pus.
```

一般的占位符有 `%o`（这是字符 o，不是 0）表示一个对象，`%s` 表示一个字符串，以及 `%d` 代表一个小数或者整数。

![](https://cdn-images-1.medium.com/max/800/1*k36EIUqbxmWeYwZVqOrzNQ.png)

另一个有趣是 `%c`，你可能并不这么认为。事实上它是作为 CSS 值的占位符。

```
console.log('I am a %cbutton', 'color: white; background-color: orange; padding: 2px 5px; border-radius: 2px');
```

![](https://cdn-images-1.medium.com/max/800/1*LetSPI-9ubOuADejUa_YSA.png)

后面的值可以一直添加，这里没有「结束标签」，确实有点怪异。但是你可以像这样将它们隔开。

![](https://cdn-images-1.medium.com/max/800/1*cHWO5DRw9c2z9Jv_Fx2AvQ.png)

这并不优美，也不是特别的有用。当然这也不是真实的按钮。

![](https://cdn-images-1.medium.com/max/800/1*0qgPtZGOZKBKPi1Va5wf2A.png)

真的很有用吗？不太认同。

### **console.dir()**

通常来看，`console.dir()` 功能和 `log()` 非常相似，尽管看起来有略微不同。

![](https://cdn-images-1.medium.com/max/800/1*AUEqpGMNKtp28OK057V3Ow.png)

下拉小箭头展示的对象信息和 `console.log` 的视图里一样。但是在你观察元素节点的时候，两者结果会非常有趣并且截然不同。

```
let element = document.getElementById('2x-container');
```

这是 log 输入 element 的输出

![](https://cdn-images-1.medium.com/max/800/1*l7ujPmSWwpH7QtXCZ-jk2Q.png)

我打开了一些元素节点。清晰的展示了 DOM 节点，一览无余。但是 `console.dir(element)` 给我们一个意外不同的输出。

![](https://cdn-images-1.medium.com/max/800/1*CERwy7Fs7tdijOxugLW54A.png)

这是一种更**对象化**的方式去观察元素节点。也许在某些像监测元素节点的时候，这样的结果才是你所想要的。

### console.warn()

可能是 `log()` 最直接明显的替换，你可以用相同的方式使用 `console.warn()`。唯一的区别在于输出是一抹黄色。确切的说，输出是一个 warn 级别而不是一个 info 级别，因此浏览器的处理稍稍有些不同。在一堆杂乱的输出中高亮你的输出是很有效果的。

不过，这还有一个更大的优点。因为输出是一个 warn 级别而不是一个 info 级别，你可以将所有的 `console.log` 过滤掉只留下 `console.warn`。这有时在那些不停输出一堆无用和无意义的东西到浏览器的随意的应用程序中是非常有用。屏蔽干扰能更容易的看到你自己的输出。

### console.table()

令人惊讶的是这个并没有广为人知，但是 `console.table()` 方法更偏向于一种方式展示列表形式的数据，这比只扔下原始的对象数组要更加整洁。

举一个例子，下面是数据的列表。

```
const transactions = [{
  id: "7cb1-e041b126-f3b8",
  seller: "WAL0412",
  buyer: "WAL3023",
  price: 203450,
  time: 1539688433
},
{
  id: "1d4c-31f8f14b-1571",
  seller: "WAL0452",
  buyer: "WAL3023",
  price: 348299,
  time: 1539688433
},
{
  id: "b12c-b3adf58f-809f",
  seller: "WAL0012",
  buyer: "WAL2025",
  price: 59240,
  time: 1539688433
}];
```

如果使用 `console.log` 去列出以上信息，我们能得到一些中看不中用的输出：

```
▶ (3) [{…}, {…}, {…}]
```

这小箭头允许你点击并会展开这个数组，但这并不是我们想要的「一目了然」。

然而更有用的是 `console.table(data)` 的输出。

![](https://cdn-images-1.medium.com/max/800/1*wr2e5dAr_K5ilwMsYMetgw.png)

第二个参数选项是你想要显示列表的某列。默认是整个列表，但是我们也能这样做。

```
> console.table(data, ["id", "price"]);
```

我们得到这样的输出，仅仅只展示 id 和 price。在有着大量不相关信息的庞杂对象中非常有用。index 列是自动生成的并且据我所知是不会消失。

![](https://cdn-images-1.medium.com/max/800/1*_je_I8pwxVgFjvCnwybMDw.png)

值得一提的是在最右一列头部的右上角有个箭头可以颠倒次序。点击了它，会排序整个列。非常方便的找出一列的最大或者最小值，或者只是得到不同的数据展示形式。这个功能特性并没有做什么，只是对列的展示。但那总是有用的。

`console.table()` 只有处理最多1000行的数据的能力，所以它可能并不适用于所有的数据集合。

### console.assert()

一个经常被忽视的实用的函数，`assert()` 在第一个参数是**假值**时和 `log()` 一样。当第一个参数为真值时也什么都不做。

这个在你需要循环（或者不同的函数调用）并且只有一个要显示特殊的行为的场景下特别有用。本质上和这个是一样的。

```
if (object.whatever === 'value') {
  console.log(object);
}
```

澄清一下，当我说「一样」的时候，我本应该说是做**相反**的事。所以你需要变换一下场合。

所以，假设我们上面的值在时间戳里有一个 `null` 或者 `0`，这会破坏我们代码日期格式。

```
console.assert(tx.timestamp, tx);
```

当和任何**有效**的事物对象一起使用时会跳过。但是有一个触发了我们的日志记录，因为时间戳在 0 和 null 时为**假值**。

有时我们想要更加复杂的场景。举个例子，我们看到了关于用户 `WAL0412` 的数据问题并且想要只展示来自它们的事务。这是直接的解答方式。

```
console.assert(tx.buyer === 'WAL0412', tx);
```

看起来正确，但是并不奏效。牢记，场景必须是为否定态,我门想要的是**断言**，而不是**过滤**。

```
console.assert(tx.buyer !== 'WAL0412', tx);
```

我们想做的就是这样。在那种情况下，所有**不是 ** WAL0412 号顾客的事务都为真值，只留下那些符合的事务。或者，也不完全是。

诸如此类，`console.assert()` 并不总是特别的有用。但是在特定的场景下会是最优雅的的解决方法。

### console.count()

Count 仅仅作为一个计数器，另一个小众 的用法是，还可选的命名这个计数器。

```
for(let i = 0; i < 10000; i++) {
  if(i % 2) {
    console.count('odds');
  }
  if(!(i % 5)) {
    console.count('multiplesOfFive');
  }
  if(isPrime(i)) {
    console.count('prime');
  }
}
```

这不是一段有用的代码，并且有点抽象。我也不打算去证明 `isPrime` 函数，只假设可以运行。

我们将得到应该是这样的列表

```
odds: 1
odds: 2
prime: 1
odds: 3
multiplesOfFive: 1
prime: 2
odds: 4
prime: 3
odds: 5
multiplesOfFive: 2
...
```

以及剩下的。在你只想列出索引，或者想保留一次（或多次）计数的情况下非常有用。

你也能像那样使用 `console.count()`，不需要参数。使用 `default` 调用。

这还有关联函数 `console.countReset()`，如果你希望重置计数器可以使用它。

### console.trace()

这在简单的数据中演示更加困难。在你试图找出有问题的内部类或者库的调用这一块是它最擅长。

举个例子，这儿可能有 12 个不同的组件正在调用一个服务，但是其中一个没有正确配置依赖。

```
export default class CupcakeService {
    
  constructor(dataLib) {
    this.dataLib = dataLib;
    if(typeof dataLib !== 'object') {
      console.log(dataLib);
      console.trace();
    }
  }
  ...
}
```

这里单独使用 `console.log()` 我们只能知道执行了哪一个基础库，并不知道执行的具体位置。但是，堆栈轨迹会清楚的告诉我们问题在于 `Dashboard.js`，我们从中发现 `new CupcakeService(false)` 是造成出错的罪魁祸首。

### console.time()

console.time() 是专门用于监测操作的时间开销的函数，也是监测 JavaScript 细微时间的更好的方式。

```
function slowFunction(number) {
  var functionTimerStart = new Date().getTime();
  // something slow or complex with the numbers. 
  // Factorials, or whatever.
  var functionTime = new Date().getTime() - functionTimerStart;
  console.log(`Function time: ${ functionTime }`);
}
var start = new Date().getTime();

for (i = 0; i < 100000; ++i) {
  slowFunction(i);
}

var time = new Date().getTime() - start;
console.log(`Execution time: ${ time }`);
```

这是一个过时的方法。我指的同样还有上面的 console.log。大多数人没有意识到这里你本可以使用模版字符串和插值法。它时不时的会帮助到你。

那么让我们更新一下上面的代码。

```
const slowFunction = number =>  {
  console.time('slowFunction');
  // something slow or complex with the numbers. 
  // Factorials, or whatever.
  console.timeEnd('slowFunction');
}
console.time();

for (i = 0; i < 100000; ++i) {
  slowFunction(i);
}
console.timeEnd();
```

我现在不需要去做任何算术或者设置临时变量。

### console.group()

如今我们可能在大多数 console 中要输出高级和复杂的东西。分组可以让你归纳这些。尤其是让你能使用嵌套。它擅长展示代码中存在的结构关系。

```
// this is the global scope
let number = 1;
console.group('OutsideLoop');
console.log(number);
console.group('Loop');
for (let i = 0; i < 5; i++) {
  number = i + number;
  console.log(number);
}
console.groupEnd();
console.log(number);
console.groupEnd();
console.log('All done now');
```

这又有一点难以理解。你可以看看这里的输出。

![](https://cdn-images-1.medium.com/max/800/1*4Dil0L35FnGxiVPJx4mJsQ.png)

这并不是很有用，但是你能看到其中一些是如何组合的。

```
class MyClass {
  constructor(dataAccess) {
    console.group('Constructor');
    console.log('Constructor executed');
    console.assert(typeof dataAccess === 'object', 
      'Potentially incorrect dataAccess object');
    this.initializeEvents();
    console.groupEnd();
  }
  initializeEvents() {
    console.group('events');
    console.log('Initialising events');
    console.groupEnd();
  }
}
let myClass = new MyClass(false);
```

![](https://cdn-images-1.medium.com/max/800/1*MW0eKpxlBK-Cf9atJv3Baw.png)

很多工作和代码在调试信息上可能并不是那么有用。但是仍然是一个有意思的办法，同时你可以看到它使你打印的上下文是多么的清晰。

关于这个，还有最后一点需要说明，那就是 `console.groupCollapsed`。功能上和 `console.group` 一样，但是分组块一开始是折叠的。它没有得到很好的支持，但是如果你有一个无意义的庞大的分组并想默认隐藏它，可以试试这个。

### 结语

这里真的没有过多的总结。在你可能只想得到比 `console.log(pet)` 的信息更多一点，并且不太需要调试器的时候，上面这些工具都可能帮到你。

也许最有用的是 `console.table`，但是其他方法也都有其适用的场景。在我们想要调试一些东西时，我热衷于使用 `console.assert`，但那也只在某种特殊情况下。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
