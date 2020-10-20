> * 原文地址：[Note 6. ES6: Default values of parameters](http://dmitrysoshnikov.com/ecmascript/es6-notes-default-values-of-parameters/)
> * 原文作者：[Dmitry Soshnikov](http://dmitrysoshnikov.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/es6-notes-default-values-of-parameters.md](https://github.com/xitu/gold-miner/blob/master/TODO1/es6-notes-default-values-of-parameters.md)
> * 译者：[Chorer](https://github.com/chorer)
> * 校对者：[fireairforce](https://github.com/fireairforce), [xingqiwu55555](https://github.com/xingqiwu55555)

# 笔记 6. ES6：参数默认值

在这篇文章中我们会介绍另一个 ES6 的特性，带**默认值**的函数参数。正如我们将看到的，有一些微妙的案例。

## ES5 及更低版本的手动默认值

以前的默认参数值是通过以下几种可选方式手动处理的：

```
function log(message, level) {
  level = level || 'warning';
  console.log(level, ': ', message);
}
 
log('low memory'); // warning: low memory
log('out of memory', 'error'); // error: out of memory
```

为了避免参数未传递的情况，通常可以看到 `typeof` 检查：

```
if (typeof level == 'undefined') {
  level = 'warning';
}
```

有时，你也可以检查 `arguments.length`：

```
if (arguments.length == 1) {
  level = 'warning';
}
```

所有这些方法都行之有效，但是，它们太偏向手动了，并且不够抽象。ES6 标准化了一种句法结构，在函数头直接定义了参数默认值。

## ES6 默认值：基本实例

许多语言都存在默认参数值，所以大多数开发人员应该熟悉它的基本形式：

```
function log(message, level = 'warning') {
  console.log(level, ': ', message);
}
 
log('low memory'); // warning: low memory
log('out of memory', 'error'); // error: out of memory
```

这种默认参数用法相当随意，但是却很方便。接下来，让我们深入实现细节来理清默认参数可能带来的困惑。

## 实现细节

以下是一些关于 ES6 函数默认参数值的实现细节。

### 执行阶段的重新计值

一些其他语言（例如 Python）会在**定义阶段**对默认参数进行一次计值，相比之下，ECMAScript 则会在**执行阶段**计算默认参数值 —— 每次函数调用的时候。采用这种设计是为了避免与作为默认值的复杂对象混淆。思考下面的 Python 例子：

```
def foo(x = []):
  x.append(1)
  return x
 
# 我们可以看到默认值在函数定义时
# 只创建了一次，并且保存于
# 函数对象的属性中
print(foo.__defaults__) # ([],)
 
foo() # [1]
foo() # [1, 1]
foo() # [1, 1, 1]
 
# 正如我们所说的，原因是：
print(foo.__defaults__) # ([1, 1, 1],)
```

为了避免这种情况，Python 开发者习惯将默认值定义为 `None`，并且显式检查这个值：

```
def foo(x = None):
  if x is None:
    x = []
  x.append(1)
  print(x)
 
print(foo.__defaults__) # (None,)
 
foo() # [1]
foo() # [1]
foo() # [1]
 
print(foo.__defaults__) # ([None],)
```

但是，这与手动处理实际默认值的方式是一样不方便的，并且最初的案例让人感到疑惑。因此，为了避免这种情况，ECMAScript 会在每次函数执行时计算默认值：

```
function foo(x = []) {
  x.push(1);
  console.log(x);
}
 
foo(); // [1]
foo(); // [1]
foo(); // [1]
```

一切都很好，很直观。接下来你会发现，如果我们不了解默认值的工作机制，ES 语义可能会让我们感到困惑。

### 外部作用域的遮蔽

思考下面的例子：

```
var x = 1;
 
function foo(x, y = x) {
  console.log(y);
}
 
foo(2); // 2，不是 1！
```

正如我们**看到**的，上面的例子输出的 `y` 是 `2`，不是 `1`。原因是参数中的 `x` 与全局的 `x` **不是同一个**。由于执行阶段会计算默认值，在赋值 `= x` 发生的时候， `x` 已经在**内部作用域**被解析了，并且指向了 **`x` 参数自身**。具有相同名称的参数 `x` **遮蔽了**全局变量，使得对来自默认值的 `x` 的所有访问都指向参数。

### 参数的 TDZ（暂时性死区）

ES6 提到了所谓的 **TDZ**（表示**暂时性死区**）—— 这是程序的一部分，在这个区域内变量或者参数在**初始化**（即接受一个值）之前将**无法访问**。 

就参数而言，一个**参数不能以自身作为默认值**：

```
var x = 1;
 
function foo(x = x) { // 抛出错误！
  ...
}
```

我们上面提到的赋值 `= x` 在参数作用域中解析 `x` ，遮蔽了全局 `x` 。 但是，参数 `x` 位于 TDZ 内，在初始化之前无法访问。因此，它无法初始化为自身。

注意，上面带有 `y` 的例子是有效的，因为 `x` 已经初始化（为隐式默认值 `undefined`）了。我们再来看一下：

```
function foo(x, y = x) { // 可行
  ...
}
```

之所以可行，是因为 ECMAScript 中的参数是按照**从左到右的顺序**初始化的，我们已经有可供使用的 `x` 了。

我们提到参数已经与“内部作用域”相关联了，在 ES5 中我们可以假定是**函数体**的作用域。但是，它实际上更加复杂：它**可能**是一个函数的作用域，**或者**是一个为了**存储参数绑定**而特别创建的**中间作用域**。我们来思考一下。

### 特定的参数中间作用域

事实上，如果**一些**（至少有一个）参数具有默认值，ES6 会定义一个**中间作用域**用于存储参数，并且这个作用域与**函数体**的作用域**不共享**。这是与 ES5 存在主要区别的一个方面。我们用例子来证明：

```
var x = 1;
 
function foo(x, y = function() { x = 2; }) {
  var x = 3;
  y(); // `x` 被共用了吗？
  console.log(x); // 没有，依然是 3，不是 2
}
 
foo();
 
// 并且外部的 `x` 也不受影响
console.log(x); // 1
```

在这个例子中，我们有**三个作用域**：全局环境，参数环境，以及函数环境：

```
:  {x: 3} // 内部
-> {x: undefined, y: function() { x = 2; }} // 参数
-> {x: 1} // 全局
```

我们可以看到，当函数 `y` 执行时，它在最近的环境（即参数环境）中解析 `x`，函数作用域对其并不可见。

#### 转译为 ES5

如果我们要将 ES6 代码编译为 ES5，并看看这个中间作用域是怎样的，我们会得到下面的结果：

```
// ES6
function foo(x, y = function() { x = 2; }) {
  var x = 3;
  y(); // `x` 被共用了吗？
  console.log(x); // 没有，依然是 3，不是 2
}
 
// 编译为 ES5
function foo(x, y) {
  // 设置默认值。
  if (typeof y == 'undefined') {
    y = function() { x = 2; }; // 现在可以清楚地看到，它更新了参数 `x`
  }
 
  return function() {
    var x = 3; // 现在可以清楚地看到，这个 `x` 来自内部作用域
    y();
    console.log(x);
  }.apply(this, arguments);
}
```

#### 参数作用域的源由

但是，设置这个**参数作用域**的**确切目的**是什么？为什么我们不能像 ES5 那样与函数体共享参数？理由是：函数体中的同名变量**不应该因为名字相同而影响到[闭包](http://dmitrysoshnikov.com/ecmascript/chapter-6-closures/)绑定中的捕获行为**。

我们用下面的例子展示：

```
var x = 1;
 
function foo(y = function() { return x; }) { // 捕获 `x`
  var x = 2;
  return y();
}
 
foo(); // 是 1，不是 2
```

如果我们在**函数体**的作用域中创建函数 `y`，它将会捕获内部的 `x`，也即 `2`。但显而易见，它应该捕获的是外部的 `x`，也即 `1`（除非它被同名参数**遮蔽**）。

同时，我们无法在外部作用域中创建函数，这意味着我们无法从这样的函数中访问**参数**。我们可以这样做：

```
var x = 1;
 
function foo(y, z = function() { return x + y; }) { // 可以看到 `x` 和 `y`
  var x = 3;
  return z();
}
 
foo(1); // 2，不是 4
```

#### 何时不会创建参数作用域

上述的语义与默认值的**手动实现**是**完全不同**的：

```
var x = 1;
 
function foo(x, y) {
  if (typeof y == 'undefined') {
    y = function() { x = 2; };
  }
  var x = 3;
  y(); // `x` 被共用了吗？
  console.log(x); // 是的！2
}
 
foo();
 
// 外部的 `x` 依然不受影响
console.log(x); // 1
```

现在有一个有趣的事实：如果一个函数**没有默认值**，它就**不会创建这个中间作用域**，并且会与一个**函数环境**中的参数绑定**共享**，即**以 ES5 模式运行**。 

为什么要这么复杂呢？为什么不总是创建参数作用域呢？这仅仅和优化有关吗？并非如此。确切地说，这是为了向下兼容 ES5：上述手动实现默认值的代码**应该**更新函数体中的 `x`（也就是参数自身，且位于相同作用域中）。

同时还要注意，那些重复声明只适用于 `var` 和函数。用 `let` 或者 `const` 重复声明参数是不行的：

```
function foo(x = 5) {
  let x = 1; // 错误
  const x = 2; // 错误
}
```

### `undefined` 检查

还要注意另一个有趣的事实，是否应用默认值，取决于对参数初始值（其赋值发生在[一进入上下文](http://dmitrysoshnikov.com/ecmascript/chapter-2-variable-object/#entering-the-execution-context)时）的检查结果是否为值 `undefined`。我们来证明一下： 

```
function foo(x, y = 2) {
  console.log(x, y);
}
 
foo(); // undefined, 2
foo(1); // 1, 2
 
foo(undefined, undefined); // undefined, 2
foo(1, undefined); // 1, 2
```

通常，在编程语言中带默认值的参数在必需参数之后，但是，上述事实允许我们在 JavaScript 中使用如下结构：

```
function foo(x = 2, y) {
  console.log(x, y);
}
 
foo(1); // 1, undefined
foo(undefined, 1); // 2, 1
```

### 解构组件的默认值

涉及默认值的另一个地方是解构组件的默认值。本文不会涉及解构赋值的主题，不过我们会展示一些小例子。不管是在函数参数中使用解构，还是上述的使用简单默认值，处理默认值的方式都是一样的：即在需要的时候创建两个作用域。

```
function foo({x, y = 5}) {
  console.log(x, y);
}
 
foo({}); // undefined, 5
foo({x: 1}); // 1, 5
foo({x: 1, y: 2}); // 1, 2
```

尽管解构的默认值更加通用，不仅仅用于函数中：

```
var {x, y = 5} = {x: 1};
console.log(x, y); // 1, 5
```

## 结论

希望这篇简短的笔记可以帮助解释 ES6 中默认值的细节。注意，在本文撰写的那一天（2014 年 8 月 21 日），默认值**还没有得到真正的实现**（它们都只是创建了一个与函数体共享的作用域），因为这个“第二作用域”是在最近才添加到标准草案里的。默认值一定会是一个很有用的特性，它将使我们的代码更加优雅和整洁。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
