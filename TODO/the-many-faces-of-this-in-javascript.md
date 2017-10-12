
> * 原文地址：[The many faces of `this` in javascript](https://blog.pragmatists.com/the-many-faces-of-this-in-javascript-5f8be40df52e)
> * 原文作者：[Michał Witkowski](https://blog.pragmatists.com/@michal.witkowski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-many-faces-of-this-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-many-faces-of-this-in-javascript.md)
> * 译者：
> * 校对者：

# The many faces of `this` in javascript

![](https://cdn-images-1.medium.com/max/800/1*7SJ32rCU2QasXn9Uyv8NyQ.jpeg)

In this post, I will do my best to explain one of the most fundamental parts of JavaScript: the execution context. If you use JS frameworks a lot, understanding “this” may at first seem like a nice addition. However, if you are going to take programming seriously, understanding the context is absolutely crucial to being a JavaScript programmer.

We use `this` in much the same way as we use it in natural language. We would rather write “My mom turned blue, this is very worrying.” instead of “My mom turned blue. My mom turning blue is very worrying.” Knowing the context of `this`, enables us to understand what is worrying us so much.

Let’s try to connect it somehow with the programming language. In JavaScript, we use `this` as a shortcut, a reference. It refers to objects, variables and we use it in context.

This is very worrying, but fear not. In a minute, everything will become clear.

## **Global context**

What will you think if somebody says “This is very worrying”? Without any noticeable reason, just as the start of a conversation, without context or introduction. Most probably you’ll start to connect `this` with something around, or the latest situation.

This is happening to the browser A LOT. Hundreds of thousands of developers are using `this` without context. Our poor browser is doing its best to understand `this` in reference to a global object, windows in this particular example.

```
var a = 15;
console.log(this.a);
// => 15
console.log(window.a);
// => 15
```

[Web browsers]

Outside of any function in a global execution context, `this` refers to the global context (window object).

## Function context

To refer to the real-world example once again, the function context can be perceived as the sentence context. “My mom turned blue, this is very worrying.”. We used this in the sentence, so we know what `this` means, but we can use it in different sentences as well. For example: “A hurricane is coming, this is very worrying.” The same `this`, but a different context and completely different meaning.

Context in JavaScript is related to objects. It refers to the object within the function being executed. `this` refers to the object that the function is executing in.

```
var a = 20;

function gx () {
    return this;
}

function fx () {
    return this.a;
}

function fy () {
    return window.a;
}

console.log(gx() === window);
// => True
console.log(fx());
// => 20
console.log(fy());
// => 20
```

`this` is determined by how a function is invoked. As you can see, all the above functions have been called in a global context.

```
var o = {
  prop: 37,
  f: function() {
    return this.prop;
  }
};

console.log(o.f());
// => 37
```

When a function is called as a method of an object, `this` is set to the object the method is called on.

```
function fx () {
    return this;
}

var obj = {
    method: function () {
        return this;
    }
};

var x_obj = {
    y_obj: {
        method: function () {
            return this;
        }
    }
};

console.log(fx() === window);
// => True
console.log(obj.method() === window);
// => False
console.log(obj.method() === obj);
// => True
console.log(x_obj.y_obj.method() === x_obj)
// => False
```

`True` — We are still in a global context.
`False` — Function is called as a method of an object.
`True` — Function is called as a method of an object.
`False` — Function is called as a method of object y_obj, so `this` is its context.

**Example 4**

```
function f2 () {
  'use strict'; 
  return this;
}

console.log(f2() === undefined);
// => True
```

In strict mode, rules are different. Context remains as whatever it was set to. In this particular example, `this` was not defined, so it’s remained undefined.

**Example 5**

```
function fx () {
    return this;
}

var obj = {
    method: fx
};

console.log(obj.method() === window);
// => False
console.log(obj.method() === obj);
// => True
```

As in the previous example, the function is called as a method of an object, no matter how it was defined.

**Example 6**

```
var obj = {
    method: function () {
        return this;
    }
};

var sec_obj = {
    method: obj.method
};

console.log(sec_obj.method() === obj);
// => False
console.log(sec_obj.method() === sec_obj);
// => True
```

`this` is dynamic, meaning it can change from one object to another

**Example 7**

```
var shop = {
  fruit: "Apple",
  sellMe: function() {
    console.log("this ", this.fruit);
// => this Apple
    console.log("shop ", shop.fruit);
// => shop Apple
  }
}

shop.sellMe()
```

We can call fruit by `this` and by object name.

**Example 8**

```
var Foo = function () {
    this.bar = "baz"; 
};

var foo = new Foo();

console.log(foo.bar); 
// => baz
console.log(window.bar);
// => undefined
```

Ok, so new changes the rules. `new` operator creates an instance of an object. Context of the function will be set to the created instance of an object.

## Call, apply, bind

Real-life example: “This is very worrying, the fact my mom turned blue.”

These methods allow us to execute any function in any desired context. Let’s see how they work, on examples.

**Example 1**

```
var bar = "xo xo";

var foo = {
    bar: "lorem ipsum"
};

function test () {
    return this.bar;
}

console.log(test());
// => xo xo
console.log(test.call(foo)); 
// => lorem ipsum
console.log(test.apply(foo));
// => lorem ipsum
```

`xo xo` — We called test in a global context.
`lorem ipsum` — By using call, we call the test in context of foo.
`lorem ipsum `— By using apply, we call the test in context of foo.
Those two methods allow you to execute the function in any desired context.

`apply` lets you invoke the function with arguments as an array, whereas call requires the parameters to be listed explicitly.

**Example 2**

```
var a = 5;

function test () {
    return this.a;
}

var bound = test.bind(document);

console.log(bound()); 
// => undefined
console.log(bound.call(window)); 
// => undefined

var sec_bound = test.bind({a: 15})

console.log(sec_bound())
// => 15
```

`Undefined` — There is no a variable in document object.
`Undefined` — There is no a variable in document object. In this situation, call can’t change the context.
`15` — We created new object {a:15} and called test in this context.

The bind method permanently sets the context to the provided value.
After using bind, this is immutable, even by invoking call, apply or bind.

## **Arrow functions (ES6)**

Arrow functions were introduced as a feature in ES6\. They may be regarded as a very handy tool. However, you should know that arrow functions work differently from regular functions in terms of context. Let’s see.

**Example 1**

```
var foo = (() => this);
console.log(foo() === window); 
// => True
```

When we use arrow functions, `this` retains the value of the enclosing lexical context.

**Example 2**

```
var obj = {method: () => this};

var sec_obj = {
  method: function() {
    return this;
  }
};

console.log(obj.method() === obj);
// => False
console.log(obj.method() === window);
// => True
console.log(sec_obj.method() === sec_obj);
// => True
```

Notice the difference between the arrow and the regular function. With an arrow function, we are in a window context.
We can say that:

> *x => this.y equals function (x) { return this.y }.bind(this)*

The arrow function always has bound “this” and so can’t be used as a constructor.This last example illustrates the difference.

**Example 3**

```
var a = "global";

var obj = {
 method: function () {
   return {
     a: "inside method",
     normal: function() {
       return this.a;
     },
     arrowFunction: () => this.a
   };
 },
 a: "inside obj"
};

console.log(obj.method().normal());
// => inside method
console.log(obj.method().arrowFunction());
// => inside obj
```

Once you know the difference between the function dynamic and the lexical `this`, think twice before declaring a new function. If it is invoked as a method, use the dynamic `this`. If it is invoked as a subroutine, use the lexical `this`.

## **Further reading**

[http://www.joshuakehn.com/2011/10/20/Understanding-JavaScript-Context.html](http://www.joshuakehn.com/2011/10/20/Understanding-JavaScript-Context.html)
[http://ryanmorr.com/understanding-scope-and-context-in-javascript/](http://ryanmorr.com/understanding-scope-and-context-in-javascript/)
[https://hackernoon.com/execution-context-in-javascript-319dd72e8e2c](https://hackernoon.com/execution-context-in-javascript-319dd72e8e2c)
[http://2ality.com/2012/04/arrow-functions.html](http://2ality.com/2012/04/arrow-functions.html)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
