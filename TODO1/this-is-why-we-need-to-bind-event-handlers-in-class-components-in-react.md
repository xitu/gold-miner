> * 原文地址：[This is why we need to bind event handlers in Class Components in React](https://medium.freecodecamp.org/this-is-why-we-need-to-bind-event-handlers-in-class-components-in-react-f7ea1a6f93eb)
> * 原文作者：[Saurabh Misra](https://medium.freecodecamp.org/@saurabh__misra?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/this-is-why-we-need-to-bind-event-handlers-in-class-components-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/this-is-why-we-need-to-bind-event-handlers-in-class-components-in-react.md)
> * 译者：[whuzxq](https://github.com/whuzxq)
> * 校对者：

# 这就是为什么我们需要在 React 的类组件中为事件处理程序绑定 this

![](https://cdn-images-1.medium.com/max/2000/1*kdZr8L9pUOgosVNWqMSmlQ.png)

背景图源来自 [Kaley Dykstra](https://unsplash.com/photos/gtVrejEGdmM?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 并发布在 [Unsplash](https://unsplash.com/search/photos/chain?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 上，源代码图像生成自 [carbon.now.sh](https://carbon.now.sh)。

在使用 React 时，你难免会和组件和事件处理程序打交道。在自定义组件的构造函数中，我们需要使用 `.bind()` 来将方法绑定到组件实例上面。

```
class Foo extends React.Component{
  constructor( props ){
    super( props );
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick(event){
    // 你的事件处理逻辑
  }

  render(){
    return (
      <button type="button" 
      onClick={this.handleClick}>
      Click Me
      </button>
    );
  }
}

ReactDOM.render(
  <Foo />,
  document.getElementById("app")
);
```

在这篇文章中，我们将探究为什么要这么做。

如果你对 `.bind()` 尚不了解，推荐阅读 [这篇文章](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_objects/Function/bind)。

### **应责怪 JavaScript，而不是 React**

好吧，责怪听起来有些苛刻。如果按照 React 和 JSX 的语法，我们并不需要这么做。其实绑定 `this` 是 JavaScript 中的语法。 

让我们看看，如果不将事件处理程序绑定到组件实例上，会发生什么：

```
class Foo extends React.Component{
  constructor( props ){
    super( props );
  }

  handleClick(event){
    console.log(this); // 'this' 值为 undefined
  }

  render(){
    return (
      <button type="button" onClick={this.handleClick}>
        Click Me
      </button>
    );
  }
}

ReactDOM.render(
  <Foo />,
  document.getElementById("app")
);
```

如果你运行这个代码，点击 “Click Me” 按钮，检查你的控制台，你将会看到控制台打印出  `undefined`，这个值是 `handleClick()` 方法内部的 this 值。`handleClick()` 方法似乎已经**丢失了**其上下文(组件实例)，即 this 值。

### **在 JavaScript 中，this 的绑定是如何工作的**

正如我上文提到的，是 JavaScript 的 `this` 绑定机制导致了上述情况的发生。在这篇文章中，我不会深入探讨太多细节，但是 [这篇文章](https://github.com/getify/You-Dont-Know-JS/blob/master/this%20%26%20object%20prototypes/ch2.md) 可以帮助你进一步学习在 JavaScript 中 this 的绑定是如何工作的。

与我们讨论相关的是，函数内部的 `this` 的值取决于该函数如何被调用。

#### **默认绑定**

```
function display(){
 console.log(this); // 'this' 将指向全局变量
}

display(); 
```

这是一个普通的函数调用。在这种情况下，`display()` 方法中的 `this` 在非严格模式下指向 window 或 global 对象。在严格模式下，`this` 指向 `undefined`。

#### **隐式绑定**

```
var obj = {
 name: 'Saurabh',
 display: function(){
   console.log(this.name); // 'this' 指向 obj
  }
};

obj.display(); // Saurabh 
```

当我们以一个 obj 对象来调用这个函数时，`display()` 方法内部的 `this` 指向 `obj`。

但是，当我们将这个函数引用赋值给某个其他变量并使用这个新的函数引用去调用该函数时，我们在display（）中获得了不同的`this`值。

```
var name = "uh oh! global";
var outerDisplay = obj.display;
outerDisplay(); // uh oh! global
```

在上面的例子里，当我们调用 `outerDisplay()` 时，我们没有指定一个具体的上下文对象。这是一个没有所有者对象的纯函数调用。在这种情况下，`display()` 内部的 `this` 值回退到**默认绑定**。现在这个 `this` 指向全局对象，在严格模式下，它指向 `undefined`。
 
在将这些函数以回调的形式传递给另一个自定义函数、第三方库函数或者像 `setTimeout` 这样的内置JavaScript函数时，上面提到的判断方法会特别实用。

考虑下方的代码，当自定义一个 `setTimeout` 方法并调用它，会发生什么。

```
//setTimeout 的虚拟实现
function setTimeout(callback, delay){

   //等待 'delay' 毫秒

   callback();
}

setTimeout( obj.display, 1000 );
```

我们可以分析出，当调用 `setTimeout` 时，JavaScript 在内部将 `obj.display` 赋给参数 `callback`。

```
callback = obj.display;
```

正如我们之前分析的，这种赋值操作会导致 `display()` 函数丢失其上下文。当此函数最终在 `setTimeout` 函数里面被调用时，`display()`内部的 `this` 的值会退回至**默认绑定**。

```
var name = "uh oh! global";
setTimeout( obj.display, 1000 );

// uh oh! global
```

#### **明确绑定**

为了避免这种情况，我们可以使用 **明确绑定方法**，将 `this` 的值通过 `bind()` 方法绑定到函数上。

```
var name = "uh oh! global";
obj.display = obj.display.bind(obj); 
var outerDisplay = obj.display;
outerDisplay();

// Saurabh
```

现在，当我们调用 `outerDisplay()` 时，`this` 指向 `display()` 内部的 `obj`。

即时我们将 `obj.display` 直接作为 callback 参数传递给函数，`display()` 内部的 `this` 也会正确的指向 `obj`。

### **仅使用 JavaScript 重新创建场景**

在本文的开头，我们创建了一个类名为 `Foo` 的 React 组件。如果我们不将 `this` 绑定到事件上，事件内的值会变成 `undefined`。

正如我上文解释的那样，这是由 JavaScript 中 `this` 绑定的方式决定的，与React的工作方式无关。因此，让我们删除 React 本身的代码，并构建一个类似的纯 JavaScript 示例，来模拟此行为。

```
class Foo {
  constructor(name){
    this.name = name
  }

  display(){
    console.log(this.name);
  }
}

var foo = new Foo('Saurabh');
foo.display(); // Saurabh

//下面的赋值操作模拟了上下文的丢失。 
//与实际在 React Component 中将处理程序作为 callback 参数传递相似。
var display = foo.display; 
display(); // TypeError: this is undefined
```

我们不是模拟实际的事件和处理程序，而是用同义代码替代。正如我们在 React 组件示例中所看到的那样，由于将处理程序作为回调传递后，丢失了上下文，导致 `this` 值变成 `undefined`。这也是我们在这个纯 JavaScript 代码片段中观察到的。 

你可能会问：“等一下！难道 `this` 的值不是应该指向全局对象么，因为我们是按照默认绑定的规则，在非严格模式下运行的它。“

**答案是否定的** 原因如下：

> *类声明*和*类表达式*的主体以 [严格模式](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode) 执行，主要包括构造函数、静态方法和原型方法。Getter 和 setter 函数也在严格模式下执行。

你可以在 [这里](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes) 阅读完整的文章。

所以为了避免错误，我们需要像下文这样绑定 `this` 的值：

```
class Foo {
  constructor(name){
    this.name = name
    this.display = this.display.bind(this);
  }

  display(){
    console.log(this.name);
  }
}

var foo = new Foo('Saurabh');
foo.display(); // Saurabh

var display = foo.display;
display(); // Saurabh
```

我们不仅可以在构造函数中执行此操作，也可以在其他位置执行此操作。考虑这个：

```
class Foo {
  constructor(name){
    this.name = name;
  }

  display(){
    console.log(this.name);
  }
}

var foo = new Foo('Saurabh');
foo.display = foo.display.bind(foo);
foo.display(); // Saurabh

var display = foo.display;
display(); // Saurabh
```

但由于构造函数是所有初始化发生的地方，因此它是编写绑定事件语句最佳的位置。

#### **为什么我们不需要为箭头函数绑定 ‘**`**this’**` **？**

在 React 组件内，我们有两种定义事件处理程序的方式。

*[**公共类字段语法(实验)**](https://babeljs.io/docs/plugins/transform-class-properties/)

```
class Foo extends React.Component{
  handleClick = () => {
    console.log(this); 
  }
 
  render(){
    return (
      <button type="button" onClick={this.handleClick}>
        Click Me
      </button>
    );
  }
}

ReactDOM.render(
  <Foo />,
  document.getElementById("app")
);
```

*   [**回调中的箭头函数**](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Functions/Arrow_functions)

```
class Foo extends React.Component{
 handleClick(event){
    console.log(this);
  }
 
  render(){
    return (
      <button type="button" onClick={(e) => this.handleClick(e)}>
        Click Me
      </button>
    );
  }
}

ReactDOM.render(
  <Foo />,
  document.getElementById("app")
);
```

这两个都使用了ES6引入的箭头函数。当使用这些替代方法时，我们的事件处理程序已经自动绑定到了组件实例上，并且我们不需要在构造函数中绑定它。

原因是在箭头函数的情况下，`this` 是有**词法**约束力的。这意味它可以使用封闭的函数的上下文或者全局的上下文作为 `this` 的值。

在公共类字段语法的例子中，箭头函数被包含在 `Foo` 类中或者构造函数中，所以它的上下文就是组件实例，而这就是我们想要的。

在箭头函数作为回调的例子中，箭头函数被包含在 `render()` 方法中，该方法由 React 在组件实例的上下文中调用。这就是为什么箭头函数也可以捕获相同的上下文，并且其中的 `this` 值将正确的指向组件实例。

有关 `this` 绑定的更多细节，请查看 [此优秀资源](https://github.com/getify/You-Dont-Know-JS/blob/master/this%20%26%20object%20prototypes/ch2.md#lexical-this)。

### **总结**

在 React 的类组件中，当我们把事件处理函数引用作为回调传递过去，如下所示：

```
<button type="button" onClick={this.handleClick}>Click Me</button>

```

事件处理程序方法会丢失其**隐式绑定**的上下文。当事件被触发并且处理程序被调用时，`this`的值会回退到**默认绑定**，即值为 `undefined`，这是因为类声明和原型方法是以严格模式运行。

当我们将事件处理程序的 `this` 绑定到构造函数中的组件实例时，我们可以将它作为回调传递，而不用担心会丢失它的上下文。

箭头函数可以免除这种行为，因为它使用的是**词法** `this` **绑定**，会将其自动绑定到定义他们的函数上下文。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
