> * 原文地址：[How to debug Front-end: Console](https://blog.pragmatists.com/how-to-debug-front-end-console-3456e4ee5504)
> * 原文作者：[Michał Witkowski](https://blog.pragmatists.com/@WitkowskiMichau?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-debug-front-end-console.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-debug-front-end-console.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[Raoul1996](https://github.com/Raoul1996)

# 前端 Console 调试小技巧

![](https://cdn-images-1.medium.com/max/800/1*7YqeM-SzGWEHzbROo_MyAQ.jpeg)

开发者们在开发的过程中会无意地产生一些 bug。bug 越老，找到并修复它的难度就越高。在本系列的文章中，我将试着向你展示如何使用 Google Chrome 开发者工具、Chrome 插件以及 WebStorm 进行调试。

这篇文章将介绍最常用的调试工具 —— Chrome Console。请享用！

### Console

打开 Chrome 开发者工具的方法：

*   在主菜单中选择“更多工具”菜单 > 点击开发者工具。
*   在页面任何元素上右键，选择“检查”。
*   在 Mac 中，按下 Command+Option+I；在 Windows 与 Linux 中，按下 Ctrl+Shift+I。

请观察 Console 选项卡中的内容。

![](https://cdn-images-1.medium.com/max/800/0*ZggoM0sI_jj1QafW.)

第一行：

![](https://cdn-images-1.medium.com/max/600/1*-EAbAlPJaC22sk1R4z6GPA.png)

- 清空 console 控制台

`top` — 在默认状态下，Console 的上下文（context）为 top（顶级）。不过当你检查元素或使用 Chrome 插件上下文时，它会发生变化。
你可以在此更改 console 执行的上下文（页面的顶级 frame）。

**过滤：**
对控制台的输出进行过滤。你可以根据输出严重级别、正则表达式对其进行过滤，也可以在此隐藏网络连接产生的消息。

**设置：**
`Hide network` — 隐藏诸如 404 之类的网络错误。
`Preserve log` — 控制台将会在页面刷新或者跳转时不清空记录。
`Selected context only` — 勾上后可以根据前面 top 选择的上下文来指定控制台的日志记录范围。
`User messages only` — 隐藏浏览器产生的访问异常之类的警告。
`Log XMLHttpRequests` — 顾名思义，记录 XMLHttpRequest 产生的信息。
`Show timestamps` — 在控制台中显示时间戳信息。
`Autocomplete from history` — Chrome 会记录你曾经输入过的命令，进行自动补全。

### 选择合适的 Console API

控制台会在你应用的上下文中运行你输入的 JS 代码。你可以轻松地通过控制台查看全局作用域中存储的东西，也可以直接输入并查看表达式的结果。例如：“null === 0”。

#### console.log — 对象引用

根据定义，console.log 将会在控制台中打印输出内容。除此之外，你还得知道，console.log 会对你展示的对象保持引用关系。请看下面的代码：

```
var fruits = [{one: 1}, {two: 2}, {three: 3}];
console.log('fruits before modification: ', fruits);
console.log('fruits before modification - stringed: ', JSON.stringify(fruits));
fruits.splice(1);
console.log('fruits after modification: ', fruits);
console.log('fruits after modification - stringed : ', JSON.stringify(fruits))
```

![](https://cdn-images-1.medium.com/max/800/0*L5q3tcszjc1IYXRT.)

当调试对象或数组时，你需要注意这点。我们可以看到 `fruits` 数组再被修改前包含 3 个对象，但之后发生了变化。如需要在特定时刻查看结果，可以使用 `JSON.stringify` 来展示信息。不过这种方法对于展示大对象来说并不方便。之后我们会介绍更好的解决方案。

#### console.log — 对对象属性进行排序

JavaScript 是否能保证对象属性的顺序呢？

> 4.3.3 Object — ECMAScript 第三版 (1999)

> 对象是 Object 的成员，它是一组无序属性的集合，每个属性都包含一个原始值、对象或函数。称存储在对象属性中的函数为方法。

但是…… 在 ES5 中它的定义发生了改变，属性可以有序 —— 但你还是不能确定你的对象属性是否能按顺序排列。浏览器通过各种方法实现了有序属性。在 Chrome 中运行下面的代码，可以看到令人困惑的结果：

```
var letters = {
  z: 1,
  t: 2,
  k: 6
};
console.log('fruits', letters);
console.log('fruits - stringify', JSON.stringify(letters));
```

![](https://cdn-images-1.medium.com/max/800/0*aISOsYX8-BnOtWy4.)

Chrome 按照字母表的顺序对属性进行了排序。没法说我们是否应该喜欢这种排序方式，但了解这儿发生了什么总没坏处。

#### console.assert(expression, message)

如果 expression 表达式的结果为 `false`，`Console.assert` 将会抛出错误。关键的是，assert 函数不会由于报错而停止评估之后的代码。它可以帮助你调试冗长棘手的代码，或者找到多次迭代后函数自身产生的错误。

```
function callAssert(a,b) {
  console.assert(a === b, 'message: a !== b ***** a: ' + a +' b:' +b);
}
callAssert(5,6);
callAssert(1,1);
```

![](https://cdn-images-1.medium.com/max/800/0*Pdq0UFBR4kCZA6iE.)

#### console.count(label)

简而言之，它就是一个会计算相同表达式执行过多少次的 `console.log`。其它的都一样。

```
for(var i =0; i <=3; i++){
	console.count(i + ' Can I go with you?');
	console.count('No, no this time');
}
```

![](https://cdn-images-1.medium.com/max/800/0*2yH13TAvSFpKrTWn.)

如上面的例子所述，只有完全相同的表达式才会增加统计数字。

#### console.table()

很好用的调试函数，但即使它会提高工作效率，我也一般懒得用它…… 别像我这样，咱要保持高效。

```
var fruits = [
  { name: 'apple', like: true },
  { name: 'pear', like: true },
  { name: 'plum', like: false },
];
console.table(fruits);
```

![](https://cdn-images-1.medium.com/max/800/0*qe69gSjpDllYrGvY.)

它非常棒。第一，你可以将所有东西都整齐地放在表格中；第二，你也会得到 `console.log` 的结果。它在 Chrome 中可以正常工作，但是不保证兼容所有浏览器。

```
var fruits = [
  { name: 'apple', like: true },
  { name: 'pear', like: true },
  { name: 'plum', like: false },
];
console.table(fruits, ['name'])
```

![](https://cdn-images-1.medium.com/max/800/0*Fv8KsLDQIPY8yfJN.)

我们可以决定是完全展示数据内容还是只展示整个对象的某几列。这个表格是可排序的 —— 点击需要排序的列的表头，即可按此列对表格进行排序。

#### console.group() / console.groupEnd();

这次让我们直接从代码开始介绍。运行下面的代码看看控制台是如何进行分组的。

```
console.log('iteration');
for(var firstLevel = 0; firstLevel<2; firstLevel++){
  console.group('First level: ', firstLevel);
  for(var secondLevel = 0; secondLevel<2; secondLevel++){
	console.group('Second level: ', secondLevel);
	for(var thirdLevel = 0; thirdLevel<2; thirdLevel++){
  	console.log('This is third level number: ', thirdLevel);
	}
	console.groupEnd();
  }
  console.groupEnd();
}
```

![](https://cdn-images-1.medium.com/max/800/0*X3vtX9amAT_Or_DO.)

它可以帮助你更好的处理数据。

#### console.trace();

console.trace 会将调用栈打印在控制台中。如果你正在构建库或框架时，它给出的信息将十分有用。

```
function func1() {
  func2();
}
function func2() {
  func3();
}
function func3() {
  console.trace();
}
func1();
```

![](https://cdn-images-1.medium.com/max/800/0*4JoZfbntg4bGr03y.)

#### 对比 console.log 与 console.dir

```
console.log([1,2]);
console.dir([1,2]);
```

![](https://cdn-images-1.medium.com/max/800/0*SI2ge80spD1WY9yI.)

它们的实现方式取决于浏览器。在最开始的时候，规范中建议 dir 要保持对对象的引用，而 log 不需要引用。（Log 会显示一个对象的副本）。但现在，如上图所示，log 也保持了对于对象的引用。它们展示对象的方式有所不同，但我们不再加以深究。不过 dir 在调试 HTML 对象的时候会非常有用。
> 译注：console.dir 会详细打印一个对象的所有属性与方法。

#### $_, $0 — $4

`$_` 会返回最近执行表达式的值。
`$0 — $4` — 分别作为近 5 此检查元素时对 HTML 元素的引用。

![](https://cdn-images-1.medium.com/max/800/0*J1jrQOkNHzaDA_hu.)

#### getEventListeners(object)

返回指定 DOM 元素上注册的事件监听器。这儿还有一种更便捷的方法来设置事件监听，下次教程会介绍它。

![](https://cdn-images-1.medium.com/max/800/0*JrWFBmu3UKYy-nFj.)

### monitorEvents(DOMElement, [events]) / unmonitorEvents(DOMElement)

在指定 DOM 元素上触发任何事件时，都可以在控制台中看到相关信息。直到取消对相应元素的监视。

![](https://cdn-images-1.medium.com/max/800/0*PJTUIgivpcMGnrRP.)

### 在控制台中选择元素

![](https://cdn-images-1.medium.com/max/800/0*Dr5KRB77jQrjjdA4.)

在 Element 标签中按 ESC 键展开这个界面。

在 `$` 没有另做它用的情况下：

`$()` — 相当于 `**document.querySelector()**`。它会返回匹配 CSS 选择器的第一个元素（例如 `$('span')` 会返回第一个 span）
`$$()` — 相当于 `**document.querySelectorAll()**`。它会以数组的形式返回所有匹配 CSS 选择器的元素。

#### 复制打印的数据

有时，当你处理数据时可能会想打个草稿，或者简单地看看两个对象是否有区别。全选之后再复制可能会很麻烦，在此介绍一种很方便的方法。

在打印出的对象上点击右键，选择 copy（复制），或选择 Store as global element（将指定元素的引用存储在全局作用域中），然后你就可以在控制台中操作刚才存储的元素啦。

控制台中的任何内容都可以通过使用 `copy('object-name')` 进行复制。

#### 自定义控制台输出样式

假设你正在开发一个库，或者在为公司、团队开发一个大模块。此时在开发模式下对一些日志进行高亮处理会很舒爽。你可以试试下面的代码：

`console.log('%c Truly hackers code! ', 'background: #222; color: #bada55');`

![](https://cdn-images-1.medium.com/max/800/0*RYIJp1JEZhZ7Nqm8.)

`%d` 或 `%i` — 整型值
`%f` — 浮点值
`%o` — 可展开的 DOM 元素
`%O` — 可展开的 JS 对象
`%c` — 使用 CSS 格式化输出

以上就是本文的全部内容，但并不是 Console 这个话题的全部内容。你可以点击以下链接了解更多有关知识：

*   [Command Line API Reference](https://developers.google.com/web/tools/chrome-devtools/console/command-line-reference) by Google
*   [Console API](https://developer.mozilla.org/en-US/docs/Web/API/Console) by MDN
*   [Console API](http://2ality.com/2013/10/console-api.html) by 2ality
*   [CSS Selectors](https://developer.mozilla.org/pl/docs/Web/CSS/CSS_Selectors)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
