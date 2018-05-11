> * 原文地址：[This is why we need to bind event handlers in Class Components in React](https://medium.freecodecamp.org/this-is-why-we-need-to-bind-event-handlers-in-class-components-in-react-f7ea1a6f93eb)
> * 原文作者：[Saurabh Misra](https://medium.freecodecamp.org/@saurabh__misra?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/this-is-why-we-need-to-bind-event-handlers-in-class-components-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/this-is-why-we-need-to-bind-event-handlers-in-class-components-in-react.md)
> * 译者：
> * 校对者：

# This is why we need to bind event handlers in Class Components in React

![](https://cdn-images-1.medium.com/max/2000/1*kdZr8L9pUOgosVNWqMSmlQ.png)

Background photo by [Kaley Dykstra](https://unsplash.com/photos/gtVrejEGdmM?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash,](https://unsplash.com/search/photos/chain?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) source code image generated at [carbon.now.sh](https://carbon.now.sh)

While working on React, you must have come across controlled components and event handlers. We need to bind these methods to the component instance using `.bind()` in our custom component’s constructor.

```
class Foo extends React.Component{
  constructor( props ){
    super( props );
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick(event){
    // your event handling logic
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

In this article, we are going to find out why we need to do this.

I would recommend reading about `.bind()` [here](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_objects/Function/bind) if you do not already know what it does.

### **Blame JavaScript, Not React**

Well, laying blame sounds a bit harsh. This is not something we need to do because of the way React works or because of JSX. This is because of the way the `this` binding works in JavaScript.

Let’s see what happens if we do not bind the event handler method with its component instance:

```
class Foo extends React.Component{
  constructor( props ){
    super( props );
  }

  handleClick(event){
    console.log(this); // 'this' is undefined
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

If you run this code, click on the “Click Me” button and check your console. You will see `undefined` printed to the console as the value of `this` from inside the event handler method. The `handleClick()` method seems to have **lost** its context (component instance) or `this` value.

### **How ‘this’ binding works in JavaScript**

As I mentioned, this happens because of the way `this` binding works in JavaScript. I won’t go into a lot of detail in this post, but [here](https://github.com/getify/You-Dont-Know-JS/blob/master/this%20%26%20object%20prototypes/ch2.md) is a great resource to understand how the `this` binding works in JavaScript.

But relevant to our discussion here, the value of `this` inside a function depends upon how that function is invoked.

#### **Default Binding**

```
function display(){
 console.log(this); // 'this' will point to the global object
}

display(); 
```

This is a plain function call. The value of `this` inside the `display()` method in this case is the window — or the global — object in non-strict mode. In strict mode, the `this` value is `undefined`.

#### **Implicit binding**

```
var obj = {
 name: 'Saurabh',
 display: function(){
   console.log(this.name); // 'this' points to obj
  }
};

obj.display(); // Saurabh 
```

When we call a function in this manner — preceded by a context object — the `this` value inside `display()` is set to `obj`.

But when we assign this function reference to some other variable and invoke the function using this new function reference, we get a different value of `this` inside `display()` .

```
var name = "uh oh! global";
var outerDisplay = obj.display;
outerDisplay(); // uh oh! global
```

In the above example, when we call `outerDisplay()`, we don’t specify a context object. It is a plain function call without an owner object. In this case, the value of `this` inside `display()` falls back to **default binding**_._ It points to the global object or `undefined` if the function being invoked uses strict mode.

This is especially applicable while passing such functions as callbacks to another custom function, a third-party library function, or a built-in JavaScript function like `setTimeout` .

Consider the `setTimeout` dummy definition as shown below, and then invoke it.

```
// A dummy implementation of setTimeout
function setTimeout(callback, delay){

   //wait for 'delay' milliseconds

   callback();
}

setTimeout( obj.display, 1000 );
```

We can figure out that when we call `setTimeout`, JavaScript internally assigns `obj.display` to its argument `callback` .

```
callback = obj.display;
```

This assignment operation, as we have seen before, causes the `display()` function to lose its context. When this callback is eventually invoked inside `setTimeout`, the `this` value inside `display()` falls back to **default binding**.

```
var name = "uh oh! global";
setTimeout( obj.display, 1000 );

// uh oh! global
```

#### **Explicit Hard Binding**

To avoid this, we can **explicitly hard bind** the `this` value to a function by using the `bind()` method.

```
var name = "uh oh! global";
obj.display = obj.display.bind(obj); 
var outerDisplay = obj.display;
outerDisplay();

// Saurabh
```

Now, when we call `outerDisplay()`, the value of `this` points to `obj` inside `display()` .

Even if we pass `obj.display` as a callback, the `this` value inside `display()` will correctly point to `obj` .

### **Recreating the scenario using only JavaScript**

In the beginning of this article, we saw this in our React component called `Foo` . If we did not bind the event handler with `this` , its value inside the event handler was set as `undefined`.

As I mentioned and explained, this is because of the way `this` binding works in JavaScript and not related to how React works. So let’s remove the React-specific code and construct a similar pure JavaScript example to simulate this behavior.

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

// The assignment operation below simulates loss of context 
// similar to passing the handler as a callback in the actual 
// React Component
var display = foo.display; 
display(); // TypeError: this is undefined
```

We are not simulating actual events and handlers, but instead we are using synonymous code. As we observed in the React Component example, the `this` value was `undefined` as the context was lost after passing the handler as a callback — synonymous with an assignment operation. This is what we observe here in this non-React JavaScript snippet as well.

“Wait a minute! Shouldn’t the `this` value point to the global object, since we are running this in non-strict mode according to the rules of default binding?” you might ask.

**No.** This is why:

> The bodies of _class declarations_ and _class expressions_ are executed in [strict mode](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode), that is the constructor, static and prototype methods. Getter and setter functions are executed in strict mode.

You can read the full article [here](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes).

So, to prevent the error, we need to bind the `this` value like this:

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

We don’t need to do this in the constructor, and we can do this somewhere else as well. Consider this:

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

But the constructor is the most optimal and efficient place to code our event handler bind statements, considering that this is where all the initialization takes place.

#### **Why don’t we need to bind ‘**`**this’**` **for Arrow functions?**

We have two more ways we can define event handlers inside a React component.

*   [**Public Class Fields Syntax(Experimental)**](https://babeljs.io/docs/plugins/transform-class-properties/)

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

*   [**Arrow function in the callback**](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Functions/Arrow_functions)

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

Both of these use the arrow functions introduced in ES6\. When using these alternatives, our event handler is already automatically bound to the component instance, and we do not need to bind it in the constructor.

The reason is that in the case of arrow functions, `this` is bound **lexically**. This means that it uses the context of the enclosing function — or global — scope as its `this` value.

In the case of the public class fields syntax example, the arrow function is enclosed inside the `Foo` class — or constructor function — so the context is the component instance, which is what we want.

In the case of the arrow function as callback example, the arrow function is enclosed inside the `render()` method, which is invoked by React in the context of the component instance. This is why the arrow function will also capture this same context, and the `this` value inside it will properly point to the component instance.

For more details regarding lexical `this` binding, check out [this excellent resource](https://github.com/getify/You-Dont-Know-JS/blob/master/this%20%26%20object%20prototypes/ch2.md#lexical-this).

### **To make a long story short**

In Class Components in React, when we pass the event handler function reference as a callback like this

```
<button type="button" onClick={this.handleClick}>Click Me</button>
```

the event handler method loses its **implicitly bound** context. When the event occurs and the handler is invoked, the `this` value falls back to **default binding** and is set to `undefined` , as class declarations and prototype methods run in strict mode.

When we bind the `this` of the event handler to the component instance in the constructor, we can pass it as a callback without worrying about it losing its context.

Arrow functions are exempt from this behavior because they use **lexical** `this` **binding** which automatically binds them to the scope they are defined in.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
