> * 原文地址：[How to get the most out of the JavaScript console](https://medium.freecodecamp.com/how-to-get-the-most-out-of-the-javascript-console-b57ca9db3e6d)
> * 原文作者：[Darryl Pargeter](https://medium.freecodecamp.com/@darrylpargeter)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：[reid3290](https://github.com/reid3290)、[Aladdin-ADD](https://github.com/Aladdin-ADD)

---

# 如何充分利用 JavaScript 控制台

![](https://cdn-images-1.medium.com/max/2000/1*mM2AMk0TRENA2zF2RMEebA.jpeg)

JavaScript 中最基本的调试工具之一就是 `console.log()`。`console` 还附带了一些其他好用的方法，可以添加到开发人员的调试工具包中。

你可以使用 `console` 执行以下任务：

- 输出一个计时器来协助进行简单的基准测试
- 输出一个表格来以易读的格式显示一个数组或对象
- 使用 CSS 将颜色和其他样式选项应用于输出

### Console 对象

`console` 对象允许您访问浏览器的控制台。它允许你输出有助于调试代码的字符串、数组和对象。`console` 是 `window` 对象的属性，由[浏览器对象模型(BOM)](https://www.w3schools.com/js/js_window.asp)提供。

我们可以通过这两种方法之一访问 `console`：

1. `window.console.log('This works')`
2. `console.log('So does this')`

第二个选项本质上是对前者的引用，所以我们使用后者以精简代码。

关于 BOM 的快速提示：它没有设定标准，所以每家浏览器都以稍微不同的方式实现。我在 Chrome 和 Firefox 测试了所有示例，但你的输出可能有所不同，这取决于你使用的浏览器。

### 输出文本

![](https://cdn-images-1.medium.com/max/800/1*eEnUT7quS8oCeOsoGn1Kxw.png)

将文本记录到控制台
`console` 对象最常见的元素是 `console.log`，对于大多数情况，使用它就可以完成任务。

输出信息到控制台的四种方式：

1. `log`
2. `info`
3. `warn`
4. `error`

他们四个工作方式相同。你唯一要做的是给选择的方法传递一个或更多的参数。控制台会显示不同的图标来指示其记录级别。下面的例子中你可以看到 info 级别的记录和 warning/error 级别的不同之处。

![](https://cdn-images-1.medium.com/max/800/1*AKbeddGNDqLYaJOMQlrrMw.png)

简单易读的输出

![](https://cdn-images-1.medium.com/max/800/1*3yKUiYLyju8f9gE71w1Sxw.png)

输出东西太多将变得难以阅读

你可能注意到了 error 日志消息 —— 它比其他消息更显眼。它显示着红色的背景和[堆栈跟踪](https://en.wikipedia.org/wiki/Stack_trace)，而 `info` 和 `warn` 就不会。但是在 Chrome 中 `warn` 确实有一个黄色的背景。

视觉上的区分有助于你在控制台快速浏览辨别出错误或警告信息。你应该确保在准备生产的应用中移除它们，除非你打算让它们来警示其他操作你的代码的开发者。

### 字符串替换

这个技术可以使用字符串中的占位符来替换你向方法中传入的其他参数。

**输入**： `console.log('string %s', 'substitutions')`

**输出**： `string substitutions`

`%s` 是逗号后面第二个参数 `'substitutions'` 的占位符。任何的字符串、整数或数组都将被转换成字符串并替换 `%s`。如果你传入一个对象，它将显示为 `[object Object]`。

如果你想传入对象，你需要使用 `%o` 或者 `%O`，而不是 `%s`。

`console.log('this is an object %o', { obj: { obj2: 'hello' }})`

![](https://cdn-images-1.medium.com/max/800/1*WhqTGnch8S2kAIQYxXOLhw.png)

#### 数字

字符串替换可以与整数和浮点数一起使用：

- 整数使用 `%i` 或 `%d`,
- 浮点数使用 `%f`。

**输入**： `console.log('int: %d, floating-point: %f', 1, 1.5)`

**输出**：`int: 1, floating-point: 1.500000`

可以使用 `%.1f` 来格式化浮点数，使小数点后仅显示一位小数。你可以用 `%.nf` 来显示小数点后 n 位小数。

如果我们使用上述例子显示小数点后一位小数来格式化浮点数值，它看起来这样：

**输入**： `console.log('int: %d, floating-point: %.1f', 1, 1.5)`

**输出**： `int: 1, floating-point: 1.5`

#### 格式化说明符

1. `%s` | 使用字符串替换元素
2. `%(d|i)`| 使用整数替换元素
3. `%f `| 使用浮点数替换元素
4. `%(o|O)` | 元素显示为一个对象
5. `%c` | 应用提供的 CSS

#### 字符串模板

随着 ES6 的出现，模板字符串是替换或连接的替代品。他们使用反引号(\`\`)来代替引号，变量包裹在 `${}` 中：

    const a = 'substitutions';

    console.log(`bear: ${a}`);

    // bear: substitutions

对象在模板字符串中显示为 `[object Object]`，所以你将需要使用 `%o` 或 `%O` 替换以看到详情，或单独记录。

比起使用字符串连接：`console.log('hello' + str + '!');`，使用替换或模板可以创建更易读的代码。

#### 美妙的彩色插曲！

现在，是时候来点更有趣而多彩的东西了！

是时候用字符串替换让我们的 `console` 弹出丰富多彩的颜色了。

我将使用一个模仿 Ajax 的例子，给我们显示一个请求成功（用绿色）和失败（用红色）。这是输出和代码：

![](https://cdn-images-1.medium.com/max/800/1*BRAhnRn9GpZgrUf_SQfi3A.png)

成功的小熊和失败的蝙蝠

    const success = [
     'background: green',
     'color: white',
     'display: block',
     'text-align: center'
    ].join(';');

    const failure = [
     'background: red',
     'color: white',
     'display: block',
     'text-align: center'
    ].join(';');

    console.info('%c /dancing/bears was Successful!', success);
    console.log({data: {
     name: 'Bob',
     age: 'unknown'
    }}); // "mocked" data response

    console.error('%c /dancing/bats failed!', failure);
    console.log('/dancing/bats Does not exist');

在字符串替换中使用 `%c` 占位符来应用你的样式规则。

    console.error('%c /dancing/bats failed!', failure);

然后把你的 CSS 元素作为参数，你就能看到应用 CSS 的日志了。 你也可以给你的字符串添加多个 `%c`。

    console.log('%cred %cblue %cwhite','color:red;','color:blue;', 'color: white;')

这将按照他们的代表的颜色输出字符 “red”、“blue” 和 “white”。

控制台仅仅支持少数 CSS 属性，建议你试验一下哪些支持哪些不支持。重申一下，你的输出结果可能因你的浏览器而异。

### 其他可用的方法

还有几个其他可用的 `console` 方法。注意下面有几项还不是 API 标准，所以可能浏览器间互不兼容。这个例子使用的是 Firefox 51.0.1。

#### Assert()

`Assert` 携带两个参数 —— 如果第一个参数计算为 false，那么它将显示第二个参数。

    let isTrue = false;

    console.assert(isTrue, 'This will display');

    isTrue = true;

    console.assert(isTrue, 'This will not');

如果断言为 false，控制台将输出内容。它显示为一个上文提到的 error 级别的日志，给你显示一个红色的错误消息和堆栈跟踪。

#### Dir()

`dir` 方法显示一个传入对象的可交互属性列表。

    console.dir(document.body);

![](https://cdn-images-1.medium.com/max/800/1*4Zj5EuPTHcQH5-K0NWHb7g.png)

Chrome 会显示不同的层级
最终，`dir` 仅仅能节省一两次点击，如果你需要检查一个 API 响应返回的对象，你可以用它结构化地显示出来以节约一些时间。

#### Table()

`table` 方法用一个表格显示数组或对象

    console.table(['Javascript', 'PHP', 'Perl', 'C++']);

![](https://cdn-images-1.medium.com/max/800/1*nza7ZWxYG-_X47VJ54FtZg.png)

输出数组

数组的索引或对象的属性名位于左侧的索引栏，值显示在右侧列栏。

    const superhero = {
        firstname: 'Peter',
        lastname: 'Parker',
    }
    console.table(superhero);

![](https://cdn-images-1.medium.com/max/800/1*BXhY3PzulYFzzcW-Qwga8Q.png)

输出对象

**Chrome 用户需要注意：** 这是我的同事提醒我的，上述 `table` 方法的例子在 Chrome 中貌似不能工作。你可以通过将项目放入数组或对象数组中来解决此问题。

    console.table([['Javascript', 'PHP', 'Perl', 'C++']]);

    const superhero = {
        firstname: 'Peter',
        lastname: 'Parker',
    }
    console.table([superhero]);

#### Group()

`console.group()` 由至少三个 `console` 调用组成，它可能是使用时需要打最多字的方法。但它也是最有用的方法之一（特别对使用 [Redux Logger](https://github.com/evgenyrodionov/redux-logger) 的开发者）。

稍基础的调用看起来是这样的：

    console.group();
    console.log('I will output');
    console.group();
    console.log('more indents')
    console.groupEnd();
    console.log('ohh look a bear');
    console.groupEnd();

这将输出多个层级，显示效果因你的显示器而异。

Firefox 显示成缩进列表：

![](https://cdn-images-1.medium.com/max/800/1*xFU0AtDqgwLJVUwE4Yo9_w.png)

Chrome 显示成对象的风格：

![](https://cdn-images-1.medium.com/max/800/1*9hJkBrf4uEXaC1PYe8bomQ.png)

每次调用 `console.group()` 都将开启一个新的组，如果在一个组内会创建一个新的层级。每次调用 `console.groupEnd()` 都会结束当前组或层级并向上移动一个层级。

我发现 Chrome 的输出样式更易读，因为它看起来像一个可折叠的对象。

你可以给 `group` 传入一个 header 参数，它将被显示并替代 `console.group`：

    console.group('Header');

如果你调用 `console.groupCollapsed()`，你可以从一开始就将这个组显示为折叠。据我所知，这个方法可能只有 Chrome 支持。

#### Time()

`time` 方法和上文的 `group` 方法类似，由两部分组成。

一个用于启动计时器的方法和一个停止它的方法。

一旦计时器完成，它将以毫秒为单位输出总运行时间。

启动计时器使用 `console.time('id for timer')`，结束计时器使用 `console.timeEnd('id for timer')`。您可以同时运行多达 10,000 个定时器。

输出结果可能有点像这样： `timer: 0.57ms`。

当你需要做一个快速的基准测试时，它非常有用。

### 结论  

我们已经更深入地了解了 console 对象以及其中附带的其他一些方法。当我们需要调试代码时，这些方法是可用的好工具。

仍然有几种方法我没有谈论，因为他们的 API 依然在变动。具体可以阅读 [MDN Web API](https://developer.mozilla.org/en/docs/Web/API/console) 和 [WHATWG 规范](https://console.spec.whatwg.org/)。

![](https://cdn-images-1.medium.com/max/800/1*0SNCJfem2WVKSJIDzConxg.png)

[https://developer.mozilla.org/en/docs/Web/API/console](https://developer.mozilla.org/en/docs/Web/API/console)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
