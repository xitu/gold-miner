> * 原文地址：[Understanding Execution Context and Execution Stack in Javascript](https://blog.bitsrc.io/understanding-execution-context-and-execution-stack-in-javascript-1c9ea8642dd0)
> * 原文作者：[Sukhjinder Arora](https://blog.bitsrc.io/@Sukhjinder?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-execution-context-and-execution-stack-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-execution-context-and-execution-stack-in-javascript.md)
> * 译者：
> * 校对者：

# Understanding Execution Context and Execution Stack in Javascript

![](https://cdn-images-1.medium.com/max/2000/0*qPD741uxGb8ldrYt)

Photo by [Greg Rakozy](https://unsplash.com/@grakozy?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

If you are or want to be a JavaScript developer, then you must know how the JavaScript programs are executed internally. The understanding of execution context and execution stack is vital in order to understand other JavaScript concepts such as Hoisting, Scope, and Closures.

Properly understanding the concept of execution context and execution stack will make you a much better JavaScript developer.

So without further ado, let’s get started :)

* * *

### Shared with ❤️ in [Bit](https://bitsrc.io)’s Blog

With Bit components are building blocks, and you are the architect. Share, discover and develop components anywhere with your team. Give it a try!

* [**Bit - Share and build with code components**: Bit helps you share, discover and use code components between projects and applications to build new features and…](https://bitsrc.io)

* * *

### What is an Execution Context?

Simply put, an execution context is an abstract concept of an environment where the Javascript code is evaluated and executed. Whenever any code is run in JavaScript, it’s run inside an execution context.

#### Types of Execution Context

There are three types of execution context in JavaScript.

*   **Global Execution Context — **This is the default or base execution context. The code that is not inside any function is in the global execution context. It performs two things: it creates a global object which is a window object (in case of browsers) and sets the value of `this` to equal to the global object. There can only be one global execution context in a program.
*   **Functional Execution Context —** Every time a function is invoked, a brand new execution context is created for that function. Each function has its own execution context, but it’s created when the function is invoked or called. There can be any number of function execution contexts. Whenever a new execution context is created, it goes through a series of steps in a defined order which I will discuss later in this article.
*   **Eval Function Execution Context —** Code executed inside an `eval` function also gets its own execution context, but as `eval` isn’t usually used by Javascript developers, so I will not discuss it here.

### Execution Stack

Execution stack, also known as “calling stack” in other programming languages, is a stack with a LIFO (Last in, First out) structure, which is used to store all the execution context created during the code execution.

When the JavaScript engine first encounters your script, it creates a global execution context and pushes it to the current execution stack. Whenever the engine finds a function invocation, it creates a new execution context for that function and pushes it to the top of the stack.

The engine executes the function whose execution context is at the top of the stack. When this function completes, its execution stack is popped off from the stack, and the control reaches to the context below it in the current stack.

Let’s understand this with a code example below:

```
let a = 'Hello World!';

function first() {
  console.log('Inside first function');
  second();
  console.log('Again inside first function');
}

function second() {
  console.log('Inside second function');
}

first();
console.log('Inside Global Execution Context');
```

![](https://cdn-images-1.medium.com/max/1000/1*ACtBy8CIepVTOSYcVwZ34Q.png)

An Execution Context Stack for the above code.

When the above code loads in the browser, the Javascript engine creates a global execution context and pushes it to the current execution stack. When a call to `first()` is encountered, the Javascript engines creates a new execution context for that function and pushes it to the top of the current execution stack.

When `second()` function is called from within `first()` function, the Javascript engine creates a new execution context for that function and pushes it to the top of the current execution stack. When`second()` function finishes, its execution context is popped off from the current stack, and the control reaches to the execution context below it, that is `first()` function execution context.

When the `first()` finishes, its execution stack is removed from the stack and control reaches to the global execution context. Once all the code is executed, the JavaScript engine removes the global execution context from the current stack.

### How is the Execution Context created?

Up until now, we have seen how the JavaScript engine manages the execution context, Now let’s understand how an execution context is created by the JavaScript engine.

The execution context is created in two phases: **1) Creation Phase** and **2) Execution Phase.**

### The Creation Phase

Before any JavaScript code is executed, the execution context goes through the creation phase. Three things happen during the creation phase:

1.  Value of **this** is determined, also known as **This Binding**.
2.  **LexicalEnvironment** component is created.
3.  **VariableEnvironment** component is created.

So the execution context can be conceptually represented as follows:

```
ExecutionContext = {
  ThisBinding = <this value>,
  LexicalEnvironment = { ... },
  VariableEnvironment = { ... },
}
```

#### **This Binding:**

In the global execution context, the value of `this` refers to the global object. (in browsers, `this` refers to the Window Object).

In the function execution context, the value of `this` depends on how the function is called. If it is called by an object reference, then the value of `this` is set to that object, otherwise the value of `this` is set to the global object or `undefined`(in strict mode). For example:

```
let foo = {
  baz: function() {
  console.log(this);
  }
}

foo.baz();    // 'this' refers to 'foo', because 'baz' was called 
             // with 'foo' object reference

let bar = foo.baz;

bar();       // 'this' refers to the global window object, because
             // no object reference was given
```

#### Lexical Environment

The [official ES6](http://ecma-international.org/ecma-262/6.0/) docs defines Lexical Environment as

> A _Lexical Environment_ is a specification type used to define the association of _Identifiers_ to specific variables and functions based upon the lexical nesting structure of ECMAScript code. A Lexical Environment consists of an Environment Record and a possibly null reference to an _outer_ Lexical Environment.

Simply put, A _lexical environment_ is a structure that holds **identifier-variable mapping**. (here **identifier** refers to the name of variables/functions, and **variable** is the reference to actual object [including function type object] or primitive value).

Now, _within_ the Lexical Environment, there are two components: (1) the **environment record** and (2) a **reference to the outer environment**.

1.  The _environment record_ is the actual place where the variable and function declarations are stored.
2.  The _reference to the outer environment_ means it has access to its parent lexical environment (scope).

There are two types of _lexical environment_:

*   A _global environment_ (in a global execution context) is a Lexical Environment which does not have an outer environment. The global environment’s outer environment reference is **null**. It has built-in Object/Array/etc. prototype functions (associated with the global object i.e window object) inside this environment record as well as any user-defined global variables, and the value of `this` refers to the global object.
*   In _function environment_, the user-defined variables inside the function are stored in the _environment record_. And the reference to the outer environment can be the global environment, or whatever outer function that wraps around the inner function.

There are also two types of **_environment record_**  (see above!):

1.  **Declarative environment record** stores variables, functions, and parameters.
2.  **Object environment record** is used to define association of variables and functions appeared in the _global context._

In short,

*   In _global environment_, the environment record is object environment record.
*   In _function_ environment, the environment record is declarative environment record.

**Note —** for _function environment_, the _declarative environment record_ also contains an `arguments` object that stores mapping between indexes and arguments passed to the function and the _length_ of the arguments passed into the function.

Abstractly, the lexical environment looks like this in pseudocode:

```
GlobalExectionContext = {
  LexicalEnvironment: {
    EnvironmentRecord: {
      Type: "Object",
      // Identifier bindings go here
    }
    outer: <null>
  }
}

FunctionExectionContext = {
  LexicalEnvironment: {
    EnvironmentRecord: {
      Type: "Declarative",
      // Identifier bindings go here
    }
    outer: <Global or outer function environment reference>
  }
}
```

#### Variable Environment:

It’s also a Lexical Environment whose EnvironmentRecord holds bindings created by _VariableStatements_ within this execution context.

As written above, the variable environment is also a lexical environment, So it has all the properties of a lexical environment as defined above.

In ES6, one difference between **LexicalEnvironment** component and the **VariableEnvironment** component is that the former is used to store function declaration and variable (`let` and `const`) bindings, while the latter is used to store only variable `(var)` bindings.

Let’s look at some code example to understand the above concepts:

```
let a = 20;
const b = 30;
var c;

function multiply(e, f) {
 var g = 20;
 return e * f * g;
}

c = multiply(20, 30);
```

The execution context will look something like this:

```
GlobalExectionContext = {

  ThisBinding: <Global Object>,

  LexicalEnvironment: {
    EnvironmentRecord: {
      Type: "Object",
      // Identifier bindings go here
      a: < uninitialized >,
      b: < uninitialized >,
      multiply: < func >
    }
    outer: <null>
  },

  VariableEnvironment: {
    EnvironmentRecord: {
      Type: "Object",
      // Identifier bindings go here
      c: undefined,
    }
    outer: <null>
  }
}

FunctionExectionContext = {
 
  ThisBinding: <Global Object>,

  LexicalEnvironment: {
    EnvironmentRecord: {
      Type: "Declarative",
      // Identifier bindings go here
      Arguments: {0: 20, 1: 30, length: 2},
    },
    outer: <GlobalLexicalEnvironment>
  },

VariableEnvironment: {
    EnvironmentRecord: {
      Type: "Declarative",
      // Identifier bindings go here
      g: undefined
    },
    outer: <GlobalLexicalEnvironment>
  }
}
```

**Note **— The function execution context will only be created when the call to function `multiply` is encountered.

As you might have noticed that the `let` and `const` defined variables do not have any value associated to them, but `var` defined variables are set to `undefined` .

This is because during the the creation phase, the code is scanned for variable and function declarations, while the function declaration is stored in its entirety in the environment, but the variables are initially set to `undefined` (in case of `var`) or remain uninitialized (in case of `let` and `const`).

This is the reason why you can access `var` defined variables before they are declared (though `undefined`) but get a reference error when accessing `let` and `const` variables before they are declared.

This is, what we call hoisting.

### Execution Phase

This is the simplest part of this entire article. In this phase assignments to all those variables are done, and the code is finally executed.

**Note —** During the execution phase, if the JavaScript engine couldn’t find the value of `let` variable at the actual place it was declared in the source code, then it will assign it the value of `undefined`.

### Conclusion

So we have discussed how JavaScript programs are executed internally. While it’s not necessary that you learn all these concepts to be an awesome JavaScript developer, having decent understanding of the above concepts will help you to understand other concepts such as Hoisting, Scope, and Closures more easily and deeply.

That’s it and if you found this article helpful, please hit the 👏 button and feel free to comment below! I’d be happy to talk 😃

* * *

### Shared in Bit’s blog

Bit makes it very easy to share small components and modules between projects and applications, so that you and your team can build faster. Share components, develop them anywhere and create a beautiful collection. Try it.

* [**Bit - Share and build with code components**: Bit helps you share, discover and use code components between projects and applications to build new features and…](https://bitsrc.io)

* * *

### Learn more

* [**11 React UI Component Libraries You Should Know In 2018**: 11 React component libraries with great components for building your next app’s UI interface in 2018.](https://blog.bitsrc.io/11-react-component-libraries-you-should-know-178eb1dd6aa4)

* [**5 Tools for Faster Vue.js App Development**: Speed the development of your Vue.js applications.](https://blog.bitsrc.io/5-tools-for-faster-vue-js-app-development-ad7eda1ee6a8)

* [**How To Write Better Code In React**: 9 Useful tips for writing better code in React: Learn about Linting, propTypes, PureComponent and more.](https://blog.bitsrc.io/how-to-write-better-code-in-react-best-practices-b8ca87d462b0)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
