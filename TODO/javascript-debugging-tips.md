> * 原文地址：[The 14 JavaScript debugging tips you probably didn't know](https://raygun.com/javascript-debugging-tips)
> * 原文作者：[Luis Alonzo](https://raygun.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/javascript-debugging-tips.md](https://github.com/xitu/gold-miner/blob/master/TODO/javascript-debugging-tips.md)
> * 译者：[ParadeTo](https://github.com/ParadeTo)
> * 校对者：[Yuuoniy](https://github.com/Yuuoniy), [lampui](https://github.com/lampui)

# 14 个你可能不知道的 JavaScript 调试技巧

更快更高效地调试你的 JavaScript


了解你的工具在完成任务时有很重要的意义。 尽管 JavaScript 是出了名的难以调试，但是如果你掌握了一些小技巧，错误和 bug 解决起来就会快多了。

**我们收集了 14 个你必须要知道的调试技巧**，希望你可以牢记以便下次你需要它们来帮助你调试你的 JavaScript 代码。

**让我们开始吧**


大多数技巧都是用于 Chrome Inspector 和 Firefox，尽管有些可能也适用于其他调试器。

## 1. "debugger;"

除了 console.log， “debugger;” 是我最喜欢的临时应急调试工具。一旦它在你的代码中出现，Chrome 会自动地在执行到它所在位置时停下。你甚至可以将它放在条件语句中，只在你需要的时候运行。

```
if (thisThing) {
    debugger;
}
```

## 2. 以表格的形式展示对象

有些时候，你想查看一组复杂的对象。你可以用 console.log 打印并滚动查看，或者使用 console.table 来更加轻松地查看你所处理的对象。

```
var animals = [
    { animal: 'Horse', name: 'Henry', age: 43 },
    { animal: 'Dog', name: 'Fred', age: 13 },
    { animal: 'Cat', name: 'Frodo', age: 18 }
];

console.table(animals);
```

输出: 

[![Screenshot showing the resulting table for JavaScript debugging tip 2 ](https://raygun.com/upload/Debugging%202b.png)](https://raygun.com/upload/Debugging%202b.png)

## 3. 尝试所有的尺寸

拥有所有的移动设备这个想法是很美妙的，但是现实中是不可能的。不如取而代之，改变视口吧？Chrome 提供了所有你需要的东西。打开你的调试器并点击 **"toggle device mode"** 按钮。你会看到媒体查询出现啦！

[![](https://raygun.com/upload/Debugging%201%20.png)](https://raygun.com/upload/Debugging%201%20.png)

## 4. 如何快速找到你的 DOM 元素

在 elements 面板中标记一个 DOM 元素，然后在 console 中使用它。Chrome Inspector 会保存最后 5 个元素在其历史记录中，所以最后标记的元素可以用 $0 来显示，倒数第二个被标记的元素为 $1 ，以此类推。

如果你以 “item-4”, “item-3”, “item-2”, “item-1”, “item-0” 的顺序标记下面的这些元素，你可以像下图所示那样在 console 中访问这些 DOM 节点

[![](https://raygun.com/upload/Debugging%202.png)](https://raygun.com/upload/Debugging%202.png)

## 5. 使用 console.time() 和 console.timeEnd() 对循环做基准测试

知道程序运行的确切时间是非常有用的，尤其当调试非常慢的循环时。通过给函数传参，你甚至可以启动多个计时器。让我们看看如何做：

```
console.time('Timer1');

var items = [];

for(var i = 0; i < 100000; i++){
   items.push({index: i});
}

console.timeEnd('Timer1');
```

得到如下输出：

[![](https://raygun.com/upload/Debugging%203.png)](https://raygun.com/upload/Debugging%203.png)

## 6. 获取函数的堆栈踪迹

您可能了解 JavaScript 框架，生成大量代码 -- 快速地。

它会构建视图和触发事件，因此你最终会想要知道是什么在调用函数。

JavaScript 不是一个非常结构化的语言，所以有时很难搞清楚 **发生了什么** 和 **什么时候发生的** 。因此 console.trace （console 面板中只需要 trace）就派上用场了。

假设你想知道第 33 行 car 实例的 funcZ 方法的整个堆栈踪迹：

```
var car;
var func1 = function() {
	func2();
}

var func2 = function() {
	func4();
}
var func3 = function() {
}

var func4 = function() {
	car = new Car();
	car.funcX();
}
var Car = function() {
	this.brand = 'volvo';
	this.color = 'red';
	this.funcX = function() {
		this.funcY();
	}

	this.funcY = function() {
		this.funcZ();
	}

	this.funcZ = function() {
		console.trace('trace car')
	}
}
func1();
var car;
var func1 = function() {
	func2();
}
var func2 = function() {
	func4();
}
var func3 = function() {
}
var func4 = function() {
	car = new Car();
	car.funcX();
}
var Car = function() {
	this.brand = 'volvo';
	this.color = 'red';
	this.funcX = function() {
		this.funcY();
	}
	this.funcY = function() {
		this.funcZ();
	}
 	this.funcZ = function() {
		console.trace('trace car')
	}
}
func1();
```

第 33 行将输出：

[![](https://raygun.com/upload/Debugging%204.png)](https://raygun.com/upload/Debugging%204.png)

现在我们知道 **func1** 调用了 **func2** ， **它又调用了func4**。 **func4** 接着创建了一个 **Car** 的实例并调用了 **car.funcX**，等等。

即便你认为对你的代码很熟悉，这也仍然非常有用。假设你想优化你的代码。获取到函数堆栈踪迹以及所有相关的其他函数，每一个函数都是可点击的，你可以在他们之间来回跳转，就像一个菜单一样。

## 7. 解压缩代码以便更好地调试 JavaScript

有时生产环境会出现问题，而服务器无法提供 source map 。 **不要害怕**。 Chrome 可以解压你的 JavaScript 代码以更加可读的格式呈现。尽管格式化后的代码不可能跟源码一样有用，但至少你可以知道发生了什么。点击调试器 source 面板下面的 {} Pretty Print 按钮。

[![](https://raygun.com/upload/Debugging%205.png)](https://raygun.com/upload/Debugging%205.png)

## 8. 快速定位要调试的函数

假设你想在某个函数中设置一个断点。

最常用的两种方式是：

**1. 在调试器中找到相应的行并设置一个断点**

**2. 在你的脚本中添加一个 debugger**

以上两种方法，你都必须到你的文件中找到你想调试的那一行。

可能不常见的方式是使用 console。在 console 中使用 debug(funcName)，脚本会在运行到你传入的函数的时候停止。

这种方式比较快，缺点是对私有和匿名函数无效。但是，如果排除这些情形的话，这可能是定位要调试函数的最快方法。

```
var func1 = function() {
	func2();
};

var Car = function() {
	this.funcX = function() {
		this.funcY();
	}

	this.funcY = function() {
		this.funcZ();
	}
}

var car = new Car();
```

在 console 中输入 debug(car.funcY)，在调试模式下当调用 car.faunY 时脚本会停下来：

[![](https://raygun.com/upload/Debugging%206.png)](https://raygun.com/upload/Debugging%206.png)

## 9. 不相关的黑盒脚本

我们经常会在我们的网页应用中用到一些库和框架。他们中大部分都经过良好的测试且相对来说错误较少。但是，调试器在执行调试任务时还是会进入这些不相关的文件。一个解决办法是将你不需要调试的脚本设置成黑盒。也包括你自己的脚本。[更多关于调试黑盒的信息请参考这篇文章](https://raygun.com/blog/javascript-debugging-with-black-box/)

## 10. 在复杂的调试中找到重要的信息

在更复杂的调试中我们有时想输出很多行。为了使你的输出保持更好的结构，你可以使用更多的 console 方法，如：console.log, console.debug, console.warn, console.info, console.error 等。然后，你还可以在调试器中过滤他们。但是有时当你调试 JavaScript 时，这并不是你真正想要的。现在，你可以给你的信息添加点创意和样式了。你可以使用 CSS 并制定你自己的 console 输出格式：

```
console.todo = function(msg) {
	console.log(‘ % c % s % s % s‘, ‘color: yellow; background - color: black;’, ‘–‘, msg, ‘–‘);
}

console.important = function(msg) {
	console.log(‘ % c % s % s % s’, ‘color: brown; font - weight: bold; text - decoration: underline;’, ‘–‘, msg, ‘–‘);
}

console.todo(“This is something that’ s need to be fixed”);
console.important(‘This is an important message’);
```

将输出: 

[![](https://raygun.com/upload/Debugging%207.png)](https://raygun.com/upload/Debugging%207.png)

**例如：**

在 console.log() 中，%s 表示一个字符串，%i 表示整型，%c 表示自定义样式。你可能会找到更好的方式来使用它们。如果你使用单页面框架，你可能想对 view 的输出信息使用一种样式，对 models，collections，controllers 等使用其他的样式，你可能会使用 wlog，clog，mlog 等简称来命名。总之，尽情发挥你的创造力吧。

## 11. 监控一个特定的函数调用及其参数

在 Chrome 的 console 面板中，你可以监视一个特定的函数。每次该函数被调用，它将连同传入的参数一起打印出来。

```
var func1 = function(x, y, z) {
//....
};
```

将输出： 

[![](https://raygun.com/upload/Debugging%208.png)](https://raygun.com/upload/Debugging%208.png)

这是一个查看函数所传入参数的好办法。但是我认为如果 console 能够告诉我函数需要传入的参数个数的话会更好。上面的例子中，func1 需要传入 3 个参数，但是只传了 2 个参数。如果代码中没有对这种情况进行处理，可能会导致 bug。

## 12. 在 console 中快速查询元素

在 console 中执行 querySelector 的一个更快的办法是使用 $ 符号。$('css-selector') 会返回 CSS 选择器所匹配的第一个元素。$$(‘css-selector’) 会返回所有的元素。如果你要不止一次地使用该元素，最好是把它作为变量缓存起来。

[![](https://raygun.com/upload/Debugging%2010.png)](https://raygun.com/upload/Debugging%2010.png)

## 13. Postman 是个好东西（但 Firefox 更快）

很多开发者在使用 Postman 来处理 ajax 请求。Postman 很优秀，使用它需要打开一个新的浏览器窗口，然后编写请求体然后测试，有点烦人。

有时使用你的浏览器会更轻松。

使用浏览器，当你向一个基于密码保护的网页发送请求时你不用再担心 cookie 的认证。你可以在 Firefox 中编辑并再次发送请求。

打开调试器并跳转到 network 选项。右键点击你想要修改的请求并选择 Edit and Resend，你就可以修改任何你想要修改的东西了。你可以修改头部以及参数然后点击 resend。

下面我提交了两个参数不同的请求：

![When debugging JavaScript, Chrome lets you pause when a DOM element changes](https://raygun.com/upload/Debugging%2011.png)

## 14. 打断节点的变化

DOM 是个有趣的东西。有时它发生了变化，然而你却一脸懵逼，不知道为啥。但是，当你使用 Chrome 调试 JavaScript，DOM 发生变化时，你可以暂停，甚至可以监控属性的变化。在 Chrome Inspector 中，右键点击某个元素，然后选择 break on 设置来使用：

[![](https://raygun.com/upload/Debugging%2014.png)](https://raygun.com/upload/Debugging%2014.png)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
