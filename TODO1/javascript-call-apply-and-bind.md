> - 原文地址：[Javascript: call(), apply() and bind()](https://medium.com/@omergoldberg/javascript-call-apply-and-bind-e5c27301f7bb)
> - 原文作者：[Omer Goldberg](https://medium.com/@omergoldberg?source=post_header_lockup)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-call-apply-and-bind.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-call-apply-and-bind.md)
> - 译者：[YueYong](https://github.com/YueYongDev)
> - 校对者：[Guangping](https://github.com/GpingFeng) [sun](https://github.com/sunui)

# Javascript: call()， apply() 和 bind()

### 回顾一下 “this”

我们了解到，在面向对象的 JS 中，一切都是对象。因为一切都是对象，我们开始明白我们可以为函数设置并访问额外的属性。

通过原型给函数设置属性并且添加其他方法非常棒……**但是我们如何访问它们？！??！**

![](https://cdn-images-1.medium.com/max/800/1*IWxOuXB3csN4_na6SSm_Rg.gif)

当他说 “myself” 时，他的确意味着 'this'

我们介绍过 `this` 关键字。我们了解到每个函数都会自动获取此属性。所以这时，如果我们创建一个有关我们函数执行上下文的抽象模型（我不是唯一一个这么做的人！。。。对吗？！？！），它看起来就会像这样：

![](https://cdn-images-1.medium.com/max/800/1*oGDRHlH5QWXTFTenWvMaBw.png)

我们花了一些时间来熟悉 `this` 关键字，但是一旦我们这样做了，我们就开始意识到它是多么有用了。`this` 在函数内部使用，并且总是引用单个对象 — [这个对象会在使用 “this” 的地方调用函数](http://javascriptissexy.com/understand-javascripts-this-with-clarity-and-master-it/)。

但是生活肯定都不是完美的。有时候我们会失去 `this` 的引用。当这种情况发生时，我们最终使用了令人困惑的解决方法去保存我们对于 `this`  的引用。让我们通过[ localSorage 练习](https://github.com/Arieg419/ITCCodingBootcamp/blob/master/localStorage/eBay.js)来看看这个方法吧：

![](https://cdn-images-1.medium.com/max/800/1*aE3Ao2PIEo21WK7C6Ofdfg.png)

第 31 行 :(

那为什么我需要保存 `this`  引用呢？因为在 deleteBtn.addEventListener 中，`this`  指向了 _deleteBtn_ 对象。这并不太好。有更好的解决方案吗？

------

### call()，apply() 和 bind() — 一个新的希望

到目前为止，我们已将函数视为由名称（可选，也可以是匿名函数）及其在调用时执行的代码所组成的对象。但这并不是全部真相。作为一个 热爱真理的人，我必须让你知道一个函数实际上看起来更接近下面的图像：

![](https://cdn-images-1.medium.com/max/800/1*TkzF3ckhM9Xf_U9XFaCyhA.png)

这是什么？？？？？？？别担心！现在，我将通过示例介绍每个函数中出现的这 3 种类似方法。真是很让人兴奋呢!

### **bind()**

[官方文档说：](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_objects/Function/bind)**`bind()`**方法创建一个新函数，在调用时，将其 `this` 关键字设置为所需的值。（它实际上谈论了更多的东西，但我们将把它留到下一次讲）

这非常强大。它让我们在调用函数时明确定义  `this`  的值。我们来看看 cooooode：

```
var pokemon = {
    firstname: 'Pika',
    lastname: 'Chu ',
    getPokeName: function() {
        var fullname = this.firstname + ' ' + this.lastname;
        return fullname;
    }
};

var pokemonName = function() {
    console.log(this.getPokeName() + 'I choose you!');
};

var logPokemon = pokemonName.bind(pokemon); // creates new object and binds pokemon. 'this' of pokemon === pokemon now

logPokemon(); // 'Pika Chu I choose you!'
```

在第 14 行使用了 `bind（）方法`。

***我们来逐个分析。*** 当我们使用了 `bind()` 方法：

1. JS 引擎创建了一个新的 `pokemonName` 的实例，并将 `pokemon`  绑定到 'this' 变量。 重要的是要理解**_它复制了 pokemonName 函数。_**
2. 在创建了 `pokemonName` 函数的副本之后，它可以调用 `logPokemon（）` 方法，尽管它最初不在`pokemon` 对象上。它现在将识别其属性（Pika和Chu）及其方法。

很酷的是，在我们 bind() 一个值后，我们可以像使用任何其他正常函数一样使用该函数。我们甚至可以更新函数来接受参数，并像这样传递它们：

```
var pokemon = {
    firstname: 'Pika',
    lastname: 'Chu ',
    getPokeName: function() {
        var fullname = this.firstname + ' ' + this.lastname;
        return fullname;
    }
};

var pokemonName = function(snack, hobby) {
    console.log(this.getPokeName() + 'I choose you!');
    console.log(this.getPokeName() + ' loves ' + snack + ' and ' + hobby);
};

var logPokemon = pokemonName.bind(pokemon); // creates new object and binds pokemon. 'this' of pokemon === pokemon now

logPokemon('sushi', 'algorithms'); // Pika Chu  loves sushi and algorithms

```

### call(), apply() 

[call() 方法的官方文档说：](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call)**`call()`** 方法调用一个给定 `this`  值的函数，并单独提供参数。

这意味着，我们可以调用任何函数，并明确指定 `_this_` 应该在调用函数中引用的内容。真的类似于 `bind()` 方法！这绝对可以让我们免于编写 hacky 代码（即使我们仍然是 hackerzzz ）。

`bind()` 和 `call()`  之间的主要区别在于  `call()`  方法：

1. 支持接受其他参数
2. 当它被调用的时候，立即执行函数。
3. `call()` 方法不会复制正在调用它的函数。

`call()` 和`apply()` 使用于**完全相同的目的。** **它们工作方式之间的唯一区别**是 `call()`  期望所有参数都单独传递，而 `apply()` 需要所有参数的数组。 例如：

```
var pokemon = {
    firstname: 'Pika',
    lastname: 'Chu ',
    getPokeName: function() {
        var fullname = this.firstname + ' ' + this.lastname;
        return fullname;
    }
};

var pokemonName = function(snack, hobby) {
    console.log(this.getPokeName() + ' loves ' + snack + ' and ' + hobby);
};

pokemonName.call(pokemon,'sushi', 'algorithms'); // Pika Chu  loves sushi and algorithms
pokemonName.apply(pokemon,['sushi', 'algorithms']); // Pika Chu  loves sushi and algorithms
```

注意，apply 接受数组，call 接受每个单独的参数。

这些存在于每一个 JS 函数的内置方法都非常有用。即使你最终没有在日常编程中使用它们，你仍然会在阅读其他人的代码时经常遇到它们。

如果您有任何疑问，请一如既往地通过  [Instagram](https://www.instagram.com/omeragoldberg/)  与我们联系。❤

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
