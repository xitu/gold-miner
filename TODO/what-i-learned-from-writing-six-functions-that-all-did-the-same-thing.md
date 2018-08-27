> * 原文地址：[What I learned from writing six functions that all did the same thing](https://medium.freecodecamp.com/what-i-learned-from-writing-six-functions-that-all-did-the-same-thing-b38fd48f0d55#.tt79h3s25)
* 原文作者：[Jackson Bates](https://medium.freecodecamp.com/@JacksonBates)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[Danny Lau](https://github.com/Danny1451)，[luoyaqifei](https://github.com/luoyaqifei)

# 写了六个相同功能的函数之后，我学到了什么

几周之前，一个社区在 [Free Code Camp’s Forum](http://forum.freecodecamp.com/t/javascript-algorithm-challenge-october-9-through-16/44096?u=jacksonbates) 上发起了非官方的算法大赛。

这个题目看似很简单：返回小于数字 N 的所有 3 或者 5 的倍数的和，N 是函数的参数。

但不是简单的找到解决办法，[P1xt](https://medium.com/u/bf42d244c85) 的竞赛要求参赛者把重点放在效率上，它鼓励你自己来写测试用例，并且用它们来评估你方案的性能。

以下是我写出并测试过的每个函数的评估，包括我的测试用例和评估脚本。最后，我将展示最终的赢家，就是那个将我所有的作品杀的片甲不留然后狠狠地给我上了一课的函数。

![](https://media.giphy.com/media/qhY3EfioLSshO/giphy.gif)

给自己的代码做测试，真的是超乎寻常地痛苦啊…… 来自：The Simpsons, 在这里 [Giphy](http://gph.is/1szb6yu)

### 函数 1 ：数组，Push 方法，累加

    function arrayPushAndIncrement(n) {
      var array = [];
      var result = 0;
      for (var i = 1; i < n; i ++) {
        if (i % 3 == 0 || i % 5 == 0) {
          array.push(i);
        }
      }
      for (var num of array) {
        result += num;
      }
      return result;
    }

    module.exports = arrayPushAndIncrement; // this is necessary for testing

对于这类问题，我的大脑直接闪现：创建一个数组，然后对这个数组进行操作。

这个函数创建了一个数组，并且将符合条件（能够被 3 或者 5 整除）的数字压入数组，之后遍历得到所有单元的和。

### 开始测试

这是该函数的自动测试，运行在 NodeJS 环境下，用到了 Mocha 和 Chai 测试工具。

如果你想了解更多关于 Mocha 和 Chai 的安装等信息，可以参考我在自由代码营社区（Free Code Camp's forum）写的一份 [Mocha 和 Chai 测试入门](http://forum.freecodecamp.com/t/testing-your-own-code-using-mocha-and-chai-simple-example/44149?u=jacksonbates) 

我依照 [P1xt](https://medium.com/u/bf42d244c85) 提供的标准写了一份简单的测试脚本，需要注意的是在下面这份脚本中，该函数是被封装在模块中的。

    // testMult.js

    var should = require( 'chai' ).should();
    var arrayPushAndIncrement = require( './arrayPushAndIncrement' );

    describe('arrayPushAndIncrement', function() {
      it('should return 23 when passed 10', function() {
        arrayPushAndIncrement(10).should.equal(23);
      })
      it('should return 78 when passed 20', function() {
        arrayPushAndIncrement(20).should.equal(78);
      })
      it('should return 2318 when passed 100', function() {
        arrayPushAndIncrement(100).should.equal(2318);
      })
      it('should return 23331668 when passed 10000', function() {
        arrayPushAndIncrement(10000).should.equal(23331668);
      })
      it('should return 486804150 when passed 45678', function() {
        arrayPushAndIncrement(45678).should.equal(486804150);
      })
    })

当我用 `mocha testMult.js` 进行测试的时候，返回了如下结果：







![](https://cdn-images-1.medium.com/max/1600/1*tmJwwmFxPQevv_kEKOWPRw.png)





我们认为本文中所有的函数都已经通过测试，在你的代码中，请给你想要试验的函数添加测试用例。

### 函数 2 ：数组，Push 方法，Reduce 方法

    function arrayPushAndReduce(n) {
      var array = [];
      for (var i = 1; i < n; i ++) {
        if (i % 3 == 0 || i % 5 == 0) {
          array.push(i);
        }
      }
      return array.reduce(function(prev, current) {
        return prev + current;
      });
    }

    module.exports = arrayPushAndReduce;

这个函数使用了跟前者相似的方法，但是它没有使用 `for` 循环，而是使用了更加精妙的 `reduce`方法来得到结果。

### 开始执行效率评估测试

现在我们来比较以上两个函数的效率。再次感谢 [P1xt](https://medium.com/u/bf42d244c85) 在往期主题中提供的这份脚本。

    // performance.js

    var Benchmark = require( 'benchmark' );
    var suite = new Benchmark.Suite;

    var arrayPushAndIncrement = require( './arrayPushAndIncrement' );
    var arrayPushAndReduce = require( './arrayPushAndReduce' );

    // add tests
    suite.add( 'arrayPushAndIncrement', function() {
      arrayPushAndIncrement(45678)
    })
    .add( 'arrayPushAndReduce', function() {
      arrayPushAndReduce(45678)
    })
    // add listeners
    .on( 'cycle', function( event ) {
        console.log( String( event.target ));
    })
    .on( 'complete', function() {
        console.log( 'Fastest is ' + this.filter( 'fastest' ).map( 'name' ));
    })
    // run async
    .run({ 'async': true });

如果你在 `node performance.js` 模式下运行测试，将得到以下输出：

    arrayPushAndIncrement x 270 ops/sec ±1.18% (81 runs sampled)
    arrayPushAndReduce x 1,524 ops/sec ±0.79% (89 runs sampled)
    Fastest is arrayPushAndReduce



![](https://media.giphy.com/media/3oGRFKJ8Ea3hKkLRyE/200_s.gif)


事实证明，还是后者更快！来自 [Giphy](http://gph.is/1UXFu1x)



所以，我们用 `reduce` 方法能够得到一个**快 5 倍**的函数！

如果这还不够激动人心，如果这还不足以激励我们继续进行下去，那我也真的是没谁了！

### 函数 3 ：While 循环，数组，Reduce 方法

既然我总是对 `for` 循环情有独钟，所以我觉得我有必要用 `while` 循环试一下：

    function whileLoopArrayReduce(n) {
      var array = [];
      while (n >= 1) {
        n--;
        if (n%3==0||n%5==0) {
          array.push(n);
        }
      }
      return array.reduce(function(prev, current) {
        return prev + current;
      });
    }

    module.exports = whileLoopArrayReduce;

那么结果怎样呢？稍微有一点慢：

    whileLoopArrayReduce x 1,504 ops/sec ±0.65% (88 runs sampled)

### 函数 4 ：While 循环，求和，没有数组

我发现不同的循环并没有多大的区别，于是我另辟蹊径，用一个没有数组的方法会怎样呢？

    function whileSum(n) {
      var sum = 0;
      while (n >= 1) {
        n--;
        if (n%3==0||n%5==0) {
          sum += n;
        }
      }
      return sum;
    }

    module.exports = whileSum;

当我沿着这个思路勇往直前的时候，我意识到**一直**以来第一选择使用数组是多么错误的行为……

    whileSum x 7,311 ops/sec ±1.26% (91 runs sampled)

又一项宏伟的提升：将近是上一个的 **5 倍快**，并且是第一个函数的 **27 倍快**！

### **函数 5 ：For 循环，求和**

当然，我们已经知道 for 循环会快一点：

    function forSum(n) {
      n = n-1;
      var sum = 0;
      for (n; n >= 1 ;n--) {
        (n%3==0||n%5==0) ? sum += n : null;
      }
      return sum;
    }

这次我用了三元运算符来做条件判断，但是测试结果表明其他版本表现的同样高效。

    forSum x 8,256 ops/sec ±0.24% (91 runs sampled)

速度又得到了提升。

我最后一个函数以**快 28 倍**的速度完爆第一个函数。

我感觉我要夺冠了。

我要上天了。

我将摘得桂冠从容小憩。

### 进入数学的世界

![](https://media.giphy.com/media/Tf4pP3z2EqowM/giphy.gif)

学着热爱数学：来自 [Giphy](http://gph.is/292GnFR) (Originally, [this music video](https://www.youtube.com/watch?v=vpOau9ZxQNY&t=116s))


一周很快过去了，每个人的最终答案都被发布、测试、校验。最快的那个函数没有使用循环，而是用了一种代数公式来操作数字：

    function multSilgarth(N) {
      var threes = Math.floor(--N / 3);
      var fives = Math.floor(N / 5);
      var fifteen = Math.floor(N / 15);

      return (3 * threes * (threes + 1) + 5 * fives * (fives + 1) - 15 * fifteen * (fifteen + 1)) / 2;
    }

    module.exports = multSilgarth;

测试结果马上出来……

    arrayPushAndIncrement x 279 ops/sec ±0.80% (83 runs sampled)
    forSum x 8,256 ops/sec ±0.24% (91 runs sampled)
    maths x 79,998,859 ops/sec ±0.81% (88 runs sampled)
    Fastest is maths

### 数学最快

最终获胜的那个函数大概地比我最好的作品**快 9690 倍**，比我最初的作品**快 275,858 倍**。

如果你想找我，我估计要去可汗学院学习数学了。
