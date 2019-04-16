> * 原文地址：[Let’s settle ‘this’ — Part Two](https://medium.com/@nashvail/lets-settle-this-part-two-2d68e6cb7dba)
> * 原文作者：[Nash Vail](https://medium.com/@nashvail?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-two.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-two.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：[Moonliujk](https://github.com/Moonliujk)、[coconilu](https://github.com/coconilu)

# 让我们一起解决“this”难题 — 第二部分

嗨！欢迎来到让我们一起解决“this”难题的第二部分，我们试图揭开 JavaScript 中最难让人理解的一部分内容 - “this”关键字的神秘面纱。如果您还没有读过 [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-settle-this-part-one.md)，你需要先把它读一下。在第一部分中，我们通过 15 个示例介绍了默认绑定规则和隐式绑定规则。我们了解了函数内部的“this”如何随着函数调用方式的不同而发生改变。最后，我们也介绍了箭头函数以及它是如何进行词法绑定。我希望你能记住这一切。

在这一部分我们将讨论两个新规则，从 _new_ 绑定开始，我们将深入地分析这一切是如何工作的。接下来，我们将介绍显式绑定以及如何通过　call(...)，apply(...) 和　bind(...) 方法将任意对象绑定到函数内部的“this”上。

让我们接着之前的内容继续。你的任务还是一样，继续猜一下控制台的输出内容是什么。还记得 WGL 吗？

不过，在深入之前，先让我们通过一个例子来热热身。

#### Example #16

```Javascript
function foo() {}

foo.a = 2;
foo.bar = {
 b: 3,
 c: function() {
  console.log(this);
 } 
}

foo.bar.c();
```

我知道，现在你可能会想“到底发生了什么？为什么在这里将属性分配给函数？这不会导致错误吗？”好吧，首先，这不会导致错误。JavaScript 中的每个函数也都是一个对象。就像其他普通的对象一样，你也可以为函数指定属性！

接下来，让我们弄清楚控制台会输出什么。如果您注意下，你会发现隐式绑定在此处起作用。_c_ 调用之前的对象是 _bar_，对吗？因此 _c_ 中的“this”指向的是 _bar_，因此 _bar_ 被输出到控制台中。

通过这个示例，你可以知道，JavaScript 中的函数也是对象，就像任何其他对象一样，它们可以被赋予属性。

#### Example #17

```Javascript
function foo() {
 console.log(this);
}

new foo();
```

那么，输出什么？还是根本没有输出？

正确答案是一个空对象。是的，不是 _a_，也不是 _foo_，只是一个空对象。让我们看看它是如何工作的。

首先要注意，函数 **如何** 被调用。它不是一个独立调用，它的前面也没有对象引用。它的前面只有一个 _new_。在 Javascript 中可以通过 _new_ 关键字来引入任意函数。当这样做的时候，使 _new_ 引入一个函数时，大致会发生四件事情，其中两个是，

 1. 创建一个空对象。
 2. 新创建的对象被绑定到函数调用的“this”上。

第二点正是你执行上面的代码时控制台输出一个空对象的原因。你可能会问“这能有什么用？”。我们会发现这里有些小争议。

#### Example #18

```Javascript
function foo(id, name) {
 this.id = id;
 this.name = name;
}

foo.prototype.print = function() {
 console.log( this.id, this.name );
};

var a = new foo(1, ‘A’);
var b = new foo(2, ‘B’);

a.print();
b.print();
```

直观地说，在这个例子中很容易就能猜到控制台上输出什么，但是从技术角度你知道真正的原理吗？让我们来看看。

来回顾一下，当使用 _new_ 关键字调用函数时，会发生四个事件。

 1. 创建一个空对象。
 2. 新创建的对象被绑定到函数调用的“this”上。
 3. **新创建对象的原型链指向函数的原型对象。**
 4. **函数被正常执行，最后返回新创建的对象。**

在前面的例子中我们已经验证了前两个事情，这就是我们会在控制台中输出空对象的原因。先忘掉第三点，让我们聚焦在第四点上。没有什么可以阻止函数的执行，除了函数内部的“this”是新创建的空对象之外，传参后函数的执行过程与其他正常的 Javascript 函数一样。因此，这个例子中的 _foo_，在它里面我们执行类似 _this.id=id_　的操作时，**我们实际上是将属性分配给了在调用函数时绑定到“this”上的新创建的空对象**。再读一遍这句话。一旦函数执行完成，**就会返回这个刚被创建的对象**。由于在上面的示例中我们为返回的对象分配了 _id_ 和 _name_ 属性，所以这个返回的对象也会拥有这些属性。然后我们可以将返回的对象赋值给我们想要的任何变量，就像我们上面示例中的 a 和 b。

每个使用 _new_ 关键字的函数调用都会创建一个全新的空对象，在函数内部配置对象的参数属性 _(_this.propName = …)_　在函数执行完毕后返回这个对象。

```Javascript
var a = {
 id: 1,
 name: ‘A’
};

var b = {
 id: 2,
 name: ‘B’
};
```

太棒了！我们刚刚学会了创建对象的新方法。但是 _a_　和 _b_　有一些共同点，它们都是 **原型链指向 foo 的原型对象**（事件 4），因此可以访问它们的属性（变量，函数等等）。正因为如此，我们可以调用 _a.print()_ 和 _b.print()_，因为 _print_ 是我们在 _foo_ 原型链上创建的函数。快速的问一个问题，当我调用 _a.print()_ 时会发生什么绑定？如果你说发生了隐性绑定，那你就答对了。因此，在调用 _a.print()_ 时，_print_ 里面的“this”指向的就是 _a_，并且控制台上首先输出的是 _1,A_，同样当我们调用 _b.print()_ 时，会输出 _2,B_。

#### Example #19

```Javascript
function foo(id, name) {
 this.id = id;
 this.name = name;

 return {
  message: ‘Got you!’
 };
}

foo.prototype.print = function() {
 console.log( this.id, this.name );
};

var a = new foo(1, ‘A’);
var b = new foo(2, ‘B’);

console.log( a );
console.log( b );
```

几乎与上一个示例中的代码完全相同，除了请注意，_foo_ 函数现在返回的是一个对象。好吧，让我们返回上一个例子，重读一下第四点，怎么样？注意加粗的内容了吗？当使用 _new_ 关键字调用函数时，在执行结束时将返回新创建的对象，**除非**你返回自定义对象，就像我们在这个示例中所做的这样。

所以？输出的什么？很明显，它返回自定义对象，具有 _message_ 属性的这个对象会在控制台中输出，输出两次。如此容易就打破了整个结构，是不是？只返回了一个没有意义的对象，一切就完全改变了。此外，你现在无法调用 _a.print()_ 或 _b.print()_，因为 _a_ 和 _b_ 被分配了返回的对象，但返回的对象没有链接到 _foo_ 的原型链。

但等一下，如果不返回一个对象，我们返回比如 _'abc'_、数字、布尔值、函数、nullundefined 或是数组，结果会怎样？事实证明，构造对象是否会改变取决于你返回的内容。看看下面的模式？

```Javascript
return {}; // 改变
return function() {}; // 改变
return new Number(3); // 改变
return [1, 2, 3]; // 改变
return null; // 不改变
return undefined; // 不改变
return ‘Hello’; // 不改变
return 3; // 不改变
...
```

为什么会这样呢，这就是另外一篇文章的主题了。我的意思是我们已经离题有点远了，这个例子与“this”绑定没太大关系，对吗？

在 Javascript 中，从很久之前就开始通过使用 _new_ 关键字绑定来创建完整的对象（也许是一种误用），以此来伪造传统的类。实际上，在 JavaScript 中没有类的概念，ES2015 中新的 _class_ 语法只是一个语法。在它的后面还是使用 _new_ 绑定，没有任何变化。我一点都不关心你是否使用 _new_ 绑定伪造类，只要你的程序工作正常，代码是可扩展，可读和可维护的，就没有问题。但是，由于 _new_ 绑定带来的不稳定性，你如何能够确保所有代码包都拥有可扩展，可读和可维护的代码呢？

可能这里还涉及很多内容。如果你还有点迷茫，你应该再重新阅读一下。重要的是如果你了解了 _new_ 绑定的工作原理，可能永远都不会再使用它 ：）。

不开玩笑，让我们继续。

思考以下的代码。不用猜测这个例子会输出什么，我们将从下个例子开始继续“猜谜游戏” :)。

```Javascript
var expenses = {
 data: [1, 2, 3, 4, 5],
 total: function(earnings) {
  return this.data.reduce( (prev, cur) => prev + cur ) - (earnings || 0);
 }
};

var rents = {
 data: [1, 2, 3, 4]
};
```

_expenses_ 对象具有 _data_ 和 _total_ 两个属性。_data_ 包含一些数字，而 _total_ 是一个函数，它将 _earnings_ 作为输入参数并返回 _data_ 中所有数字的总和减去 _earnings_。非常直观。

现在看一下 _rents_，就像 _expenses_ 一样，它也有 _data_ 属性。这样说，出于某种原因，这只是个假设，你想基于 _rent_ 的 _data_ 数组运行 _total_ 函数，因为我们是优秀的程序员，我们不喜欢重复工作。我们绝对无法调用 _rents.total()_，也无法把 _rents_ 的“this”隐式绑定为 _total_，因为 _rents.total()_ 是一个无效的调用，因为 _rents_ 没有名为 _total_ 的属性。现在有没有一种方法可以将 _rents_ 的“this”绑定为 _total_ 函数。好吧，猜猜是什么？是有的，请允许我介绍 _call()_ 和 _apply()_。

你可以看到 _call_ 和 _apply_ 做了同样的事情，它们允许你将你想要的对象绑定到你想要的功能上。这意味着我可以做到这一点……

```Javascript
console.log( expenses.total.call(rents) ); // 10
```

还有这个。

```Javascript
console.log( expenses.total.apply(rents) ); // 10
```

这很棒！上面的两行代码都会导致 _total_ 函数被调用，而内部的“this”被绑定为 _rents_ 对象。_call_ 和 _apply_ 两个方法就“this”绑定而言，只有传递参数的方式不同。

注意，_total_ 函数有一个参数 _earnings_，让我们传一下参数试试。

```Javascript
console.log( expenses.total.call(rents, 10) ); // 0 正常！
console.log( expenses.total.apply(rents, 10) ); // 报错
```

使用 _call_ 给目标函数（在我们的例子中是 _total_ ）传递参数很简单，像给其他普通函数传递参数一样，你只需传入一个由逗号隔开的参数列表 _.call(customThis, arg1, arg2, arg3…)_。在上面的代码我们传入了 10 作为 _earnings_ 参数，一切正常。

而 _apply_ 要求你将参数传递给目标函数（在我们的例子中是 _total_）时，将参数包装在一个数组里 _.apply(customThis，[arg1，arg2，arg3 ...])_ 你应该注意到了，上面的代码中我们没有这样传入参数，所以会发生错误。把参数封装成一个数组，然后再传入，就不会报错了。就像下面这样。

```Javascript
console.log( expenses.total.apply(rents, [10]) ); // 0 正常！
```

我过去曾经总结了一个助记符就是通过上面说的这点差别来记住 _call_ 和 _apply_ 之间的区别的。A 代表 _**a**pply_ ，A 也代表 _**a**rray_ ！所以通过 _**a**pply_ 把参数传给目标函数时，需要把参数封装成 _**a**rray_ 。这只是一个简单的小助记符，但它确实很有用。

现在如果我们传入一个数字，或一个字符串，或一个布尔值，或 null/undefined，而不是传入一个对象来调用 _**call**，**apply**_ 和 _**bind**_ （接下来讨论）。那样会发生什么？没有什么特别，比如你给“this”传入数字 2， 它在对象内被封装成对象形式 _new Number(2)_ ，同样如果你传入一个字符串，它会变成 _new String(...)_ ，布尔值会变成 _new Boolean(...)_ 等等，这个新对象，不管是字符，还是数字或是布尔值都被绑定到被调用函数的“this”。传入 _null_ 和 _undefined_ 的结果会有点不同。如果调用函数时为“this”传入 _null_ 或 _undefined_ ，那它就好像进行了默认绑定一样，那意味着全局对象被绑定在被调用函数的“this”上。

还有另一种方法将'this'绑定到一个函数，这次通过一个方法名叫，等等，_bind_！

让我们看看你是否可以解决这个问题。下面的示例会输出什么？

#### Example #2

```Javascript
var expenses = {
 data: [1, 2, 3, 4, 5],
 total: function(earnings) {
  return this.data.reduce( (prev, cur) => prev + cur ) - (earnings   || 0);
 }
};

var rents = {
 data: [1, 2, 3, 4]
};

var rentsTotal = expenses.total.bind(rents);

console.log(rentsTotal());
console.log(rentsTotal(10));
```

这个例子的答案是 10 后跟着输出 0。注意 _rents_ 对象声明下面发生了什么。我们从函数 _expenses.total_ 创建一个新函数 _rentsTotal_ 。这里 _bind_ 创建一个新函数，当这个函数被调用时，它的“this”关键字设置为提供的值（在我们的例子中是 _rents_ ）。因此，当我们调用 _rentsTotal()_ 时，虽然它是一个独立的调用，但它的“this”已指向了 _rents_ ，而默认绑定无法覆盖它。这次调用会在控制台输入 10。

在下一行中，使用参数（10）调用 _rentsTotal_ 与使用相同的参数（10）调用 _expenses.total_ 完全相同，它只是“this”中的值不同。这次调用的结果为 0。

另外，你也可以使用 _bind_ 绑定参数给目标函数（在我们的例子中是 _expenses.total_）。思考下这个。

```Javascript
var rentsTotal = expenses.total.bind(rents, 10);
console.log(rentsTotal());
```

你认为控制台输出什么？当然是 0，因为 10 已通过 _bind_ 绑定到目标函数（_expenses.total_）作为 _earnings_ 参数。

让我们看一个例子，它可以说明 _bind_ 生命周期。

#### Example #21

```Javascript
// HTML

<button id=”button”>Hello</button>

// JavaScript

var myButton = {
 elem: document.getElementById(‘button’),
 buttonName: ‘My Precious Button’,
 init: function() {
  this.elem.addEventListener(‘click’, this.onClick);
 },
 onClick: function() {
  console.log(this.buttonName);
 }
};

myButton.init();
```

我们已经在 HTML 中创建了一个按钮，然后我们在 Javascript 代码中，将这个按钮定义为 _myButton_ 。注意，在 _init_ 中，我们还为按钮上添加了一个鼠标点击的事件监听。你现在的问题是当点击按钮的时候，控制台会输出什么？

如果您猜对了，被打印出来的就是 _undefined_ 。这种“奇怪的结果”的原因是作为事件监听的回调（在我们的例子中是 _this.onClick_），它会把目标元素绑定在“this”上。这意味着，当 _onClick_ 被调用时，它内部的“this”是按钮的 DOM 对象（_elem_），而不是我们的 _myButton_ 对象，因为按钮的 DOM 对象没有 _buttonName_ 的属性，所以控制台输出 _undefined_。

但是有办法解决这个问题（双关语）。我们需要做的就是添加一行代码，仅需一行代码。

#### 方案 #1

```Javascript
var myButton = {
 elem: document.getElementById(‘button’),
 buttonName: ‘My Precious Button’,
 init: function() {
  this.onClick = this.onClick.bind(this);
  this.elem.addEventListener(‘click’, this.onClick);
 },
 onClick: function() {
  console.log(this.buttonName);
 }
};
```

注意上面的代码片段（#21）中调用函数 _init_ 的方式。确切地说，隐式绑定将 _myButton_ 绑定到 _init_ 函数的“this”上。现在注意，我们新加的代码行是如何把 _myButton_ 绑定到 _onClick_ 函数。这样做会创建一个新的函数，除了它内部的“this”指向了 _myButton_，其他就和 _onClick_ 完全一样。然后新创建的函数被重新分配给 _myButton.onClick_。这就是全部操作，当你点击按钮时，你将看到控制台上输出“My Precious Button”。

你也可以通过箭头函数来修复代码。就是这样。我将把这个问题留给你，让你思考一下这为什么可以。

#### 方案 #2

```Javascript
var myButton = {
 elem: document.getElementById(‘button’),
 buttonName: ‘My Precious Button’,
 init: function() {
  this.elem.addEventListener(‘click’, () => {
   this.onClick.call(this);
  });
 },
 onClick: function() {
 console.log(this.buttonName);
 }
};
```

#### 方案 #3

```Javascript
var myButton = {
 elem: document.getElementById(‘button’),
 buttonName: ‘My Precious Button’,
 init: function() {
  this.elem.addEventListener(‘click’, () => {
   console.log(this.buttonName);
  });
 }
};
```

好了。我们差不多就要结束了。还有一些问题，比如绑定是否有优先顺序？如果两个规则都试图将“this”绑定到同一个函数，这样的冲突该怎么办？这是另一篇文章的主题了。第3部分？可能吧，但是老实说，你很少会遇到这样的冲突。所以现在我们已经全部讲完了，让我们总结一下我们在这两部分学到的东西。

#### 总结

在第一部分中，我们看到函数的“this”是如何变化的，并且如何根据函数的调用方式而改变。我们讨论了默认绑定规则，它适用于函数的独立调用，而隐式绑定规则适用于调用函数时，前面有一个对象引用和箭头函数，以及它们如何使用词法绑定。在第一部分的结尾处，我们还快速的介绍了在 JavaScript 对象中进行自调用。

在第二部分，我们从 _new_ 绑定开始，并讨论它是如何工作以及如何能够轻松地破坏整个结构。这一部分的后半部分致力于使用 _call_ ，_apply_ 和 _bind_ 显式地将'this'绑定到函数。我还略显尴尬地与你分享了关于如何记住 _call_ 和 _apply_ 之间差异的助记符。希望你能记住它。

#### 这篇文章很长。非常感谢你能一直读完。我希望这篇文章能让你学到些东西。如果觉得还不错，也请把这篇文章推荐给其他人吧。祝你一天都有好心情！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
