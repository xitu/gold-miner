> * 原文地址：[Even Fibonacci numbers (Python vs. JavaScript)](https://hackernoon.com/even-fibonacci-numbers-python-vs-javascript-55590ccb2fd6)
> * 原文作者：[Ethan Jarrell](https://hackernoon.com/@ethan.jarrell?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/even-fibonacci-numbers-python-vs-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO/even-fibonacci-numbers-python-vs-javascript.md)
> * 译者：[zephyrJS](https://github.com/zephyrJS)
> * 校对者：[hexianga](https://github.com/hexianga), [Starriers](https://github.com/Starriers)

# 斐波那契数列中的偶数 (Python vs. JavaScript)

![](https://cdn-images-1.medium.com/max/800/0*MiZvmg8hpsmkAv0t.jpg)

对于雇主来说，用某种方式来生成斐波那契数列是一道热门的面试题。而求斐波那契数列中的所有偶数便是其热门的变体之一。这里，我将用 Python 和 JavaScript 两种方式来实现。为了让事情变得更加简单，我们将只生成 4,000,000 以下的序列中的偶数，并且对他们进行求和。

#### 什么是斐波那契数列？

在斐波那契数列中每一个新项都等于前两项之和。所以，我们就能看到这样一个例子，从 1 和 2 开始，序列中的前 10 个数字便是：

1, 2, 3, 5, 8, 13, 21, 34, 55, 89

#### 我们将如何生成序列中的所有数字呢？

首先，我们可以通过类似下面这种方式来思考如何生成数列：

![](https://cdn-images-1.medium.com/max/800/1*uCzO0PZEFUJqNrSBUlAQIw.png)

这里的问题是我们没办法为每个数字都创建一个变量，所以更好的解决方案是，每当我们调用完 a + b = c 之后，我们将对这三个变量重新赋值。 所以现在我们将上一个 'b' 的值赋给 'a'，将上一个 'c' 的值赋给 'b'，以此类推。它看起来会像是这样：

![](https://cdn-images-1.medium.com/max/800/1*hHFDX_t6iij089zAx55WsQ.png)

所以初步的想法是，在某个循环里，我们要检查并确保不要触发 4,000,000 这个临界点，然后我们重置 a、b 和 c 的值，紧接着将 c 存入到数组或列表中。最后我们将对这个数组或列表进行求和。

伪代码的讨论到此为止，接下来我们将展示一些实例代码，让我们看看将会是什么样子：

### Python:

让我们像伪代码那样开始。我将空数组赋值给变量 'x'。

```Python
x = []
a = 1
b = 2
c = a + b
```

接下来，我将使用 Python 的 while 循环来检查并确保 `c` 的值小于 `4000000`。

```Python
while c < 4000000:
    a = b
    b = c
    c = a + b
    if c % 2 == 0:
        x.insert(0, c)
```

因为我们只需要偶数，所以在 while 循环内部，我们将检查并确保它是一个偶数，才会执行插入到 `x.` 的操作。接下来，我们会在 Python 中对这个列表里的数字进行求和并打印这个值。

```Python
numSum = (sum(x))
print numSum
```

### JavaScript:

我想用 JavaScript 的方式去解决，但它跟 Python 相比会有些许差异。首先我将创建一个空数组，然后对数组的前两个索引赋值：

```JavaScript
var fib = [];

fib[0] = 1;
fib[1] = 2;
```

接着，我将循环数组。选择我需要的索引来生成斐波那契数列。在上一个例子里，每一次循环我们都会重置 a、b 和 c 的值。但在这个版本里，我们将不会重置任何一个值，取而代之的是，我会把 f[i-2] + f[i-1] 的值赋值给 f[i]，然后把 f[i] 的值存入到数组中。

```JavaScript
for(i=2; i<=50; i++) {
  fib[i] = fib[i-2] + fib[i-1];
  fib.push(fib[i]);
}
```

至此，我拥有一个完整的斐波那契数列，却不是仅有偶数的序列，所以我将用第二个循环来获取少于 4,000,000 并且里面都是偶数的数组。

```JavaScript
arrUnder4mil = [];
for (var i = 0; i < fib.length; i++) {
  if (fib[i] <= 4000000 && fib[i] %2 == 0) {
    arrUnder4mil.push(fib[i]);
  }
}
```

最后，我将对数组里面数字进行求和，并打印这个结果。

```JavaScript
let fibSum = arrUnder4mil.reduce((a, b) => a + b, 0);

console.log(fibSum);
```

### 总结：

尽管我们的 JavaScript 代码有点多，但这两种方法都能在几毫秒内解决这个问题。我认为，对于这些技术面试，通过两种不同的方式或语言能过帮助雇主发现你的全面性和创造性。但最重要的是，它展示了你的逻辑思维能力。如果有任何反馈，请联系我。谢谢！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


