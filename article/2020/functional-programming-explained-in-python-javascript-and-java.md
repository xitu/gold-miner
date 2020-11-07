> * 原文地址：[Functional Programming Explained in Python, JavaScript, and Java](https://medium.com/better-programming/functional-programming-explained-in-python-javascript-and-java-2dbf875046a9)
> * 原文作者：[The Educative Team](https://medium.com/@educative)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/functional-programming-explained-in-python-javascript-and-java.md](https://github.com/xitu/gold-miner/blob/master/article/2020/functional-programming-explained-in-python-javascript-and-java.md)
> * 译者：
> * 校对者：

# Functional Programming Explained in Python, JavaScript, and Java

![Image source: Author](https://cdn-images-1.medium.com/max/2048/1*CWuM2vAxWNcitQStHD7eUg.png)

Functional programming (FP) is the process of building software by composing pure functions. Nowadays, employers are looking for programmers who can draw on multiple paradigms to solve problems. Functional programming especially is gaining in popularity due to its efficiency and scalability to solve modern problems.

But how can you make the jump from OOP to FP?

Today, we’ll explore the core concepts of functional programming and show you how to implement them in Python, JavaScript, and Java.

**Here’s what we’ll cover today:**

* What is functional programming?
* Functional programming languages
* Concepts of functional programming
* Functional programming with Python
* Functional programming with JavaScript
* Functional programming with Java
* What to learn next

## What Is Functional Programming?

**Functional programming** is a declarative programming paradigm where programs are created by applying sequential functions rather than statements.

Each function takes in an input value and returns a consistent output value without altering or being affected by the program state.

These functions complete a single operation and can be composed in sequence to complete complex operations. The functional paradigm results in highly modular code since functions can be reused across the program and can be called, passed as parameters, or returned.

**Pure functions** produce no side effects and do not depend on global variables or states.

![Visualizing FP Functions](https://cdn-images-1.medium.com/max/2000/1*Se-OXiNwp2jEA8N9S5x2Dg.png)

Functional programming is used when solutions are easily expressed in functions and have little physical meaning. While object-oriented programs model code after real-world objects, functional programming excels at mathematical functions where intermediate or end values have no physical correlation.

Some common uses of functional programming are AI design, ML classification algorithms, financial programs, or advanced mathematical function models.

**Simplified:** Functional programs execute many pure, single-purpose functions in sequence to solve complex mathematical or non-physical problems.

## Advantages of Functional programming

* **Easy debugging**: Pure functions and immutable data make it easy to find where variable values are set. Pure functions have fewer factors influencing them and therefore allow you to find the bugged section easier.
* **Lazy evaluation**: Functional programs only evaluate computations at the moment they’re needed. This allows the program to reuse results from previous computations and save runtime.
* **Modular**: Pure functions do not rely on external variables or states to function, meaning they’re easily reused across the program. Also, functions will only complete a single operation or computation to ensure you can reuse that function without accidentally importing extra code.
* **Enhanced readability**: Functional programs are easy to read because the behavior of each function is immutable and isolated from the program’s state. As a result, you can predict what each function will do often just by the name.
* **Parallel programming**: It’s easier to create parallel programs with a functional programming approach because immutable variables reduce the amount of change within the program. Each function only has to deal with user input and can trust that the program state will remain mostly the same.

## Functional Programming Languages

Not all programming languages support functional programming. Some languages, like Haskell, are designed to be functional programming languages., Other languages, like JavaScript, have functional capabilities and OOP capabilities, and others do not support functional programming at all.

#### Functional programming languages

* [**Haskell**](https://www.haskell.org/): This is the clear favorite language for functional programming. It’s memory-safe, has excellent garbage collection, and is fast due to early machine code compiling. Haskell’s rich and static typing system gives you access to unique algebraic and polymorphic types that make functional programming more efficient and easier to read.
* [**Erlang**](https://www.erlang.org/): This language and its descendent, Elixir, have established a niche as the best functional language for concurrent systems. While not as popular or widely usable as Haskell, it’s often used for back-end programming. Erlang has more recently gained traction for scalable messaging apps like WhatsApp and Discord.
* [**Clojure**](https://clojure.org/): This language is a functional-first dialect of Lisp used on the Java virtual machine (JVM). It’s a predominantly functional language that supports both mutable and immutable data structures but is less strictly functional than others here. If you like Lisp, you’ll like Clojure.
* [**F#**](https://fsharp.org/): F# is similar to Haskell (they’re in the same language group) but has less advanced features. It also has minor support for object-oriented constructions.

#### Functional-capable languages

* **[Scala](https://www.scala-lang.org/):** Scala supports both OOP and functional programming. It’s most interesting feature is a strong static typing system similar to Haskell’s that helps create strong functional programs. Scala was designed to address Java criticisms and is therefore a good language for Java developers who want to try functional programming.
* **JavaScript**: While not functional-first, JS stands out for functional programming due to its asynchronous nature. JavaScript also supports essential functional programming features like lambda expressions and destructuring. Together these attributes mark JS as a top language for functional programming among other multi-paradigm languages.
* **Python, PHP, C++**: These multi-paradigm languages support functional programming but have incomplete support compared to Scala and JavaScript.
* **Java**: Java is a general-purpose language but forefronts class-based OOP. The addition of lambda expressions allows you to pursue a more functional style in a limited way. Java is ultimately an OOP language that **can** achieve functional programming but is missing key features to make the shift worth it.

## Concepts of Functional Programming

Functional programs are designed with a few core concepts in mind.

#### Variables and functions

The core building blocks of a functional program are variables and functions rather than objects and methods. You should avoid global variables because mutable global variables make the program hard to understand and lead to impure functions.

#### Pure functions

Pure functions have two properties:

* They create no side effects.
* They always produce the same output if given the same input.

Side effects are caused if a function alters the program state, overwrites an input variable, or in general makes any change along with generating an output. Pure functions are less buggy because side effects complicate a program’s state.

Referential transparency means that any function output should be replaceable with its value without changing the result of the program. This concept ensures that you create functions that only complete a single operation and achieve a consistent output.

Referential transparency is only possible if the function does not affect the program state or generally attempts to accomplish more than one operation.

#### Immutability and states

Immutable data or states cannot be changed once set and allow a stable environment for a function’s output to be constant. It’s best practice to program each function to produce the same result regardless of the program state. If it does rely on a state, the state must be immutable to ensure that the function output remains constant.

Functional programming approaches generally avoid shared state functions (multiple functions relying on the same state) and mutating state functions (function relies on a mutable function) because they make programs less modular. If you must use shared state functions, make it an immutable state.

#### Recursion

One major difference between object-oriented programming and functional programming is that functional programs avoid constructions like if-else statements or loops that can create different outputs on each execution.

Functional programs use recursion in place of loops for all iteration tasks.

#### First-class functions

Functions in functional programming are treated as a data type and can be used like any other value. For example, we populate an array with functions, pass them as parameters, or store them in variables.

#### Higher-order functions

Higher-order functions can accept other functions as parameters or return functions as output. Higher-order functions allow us greater flexibility in how we make function calls and abstract over actions.

#### Functional composition

Functions can be sequentially executed to complete complex operations. The result of each function is passed to the next function as an argument. This allows you to call a series of functions with just a single function call.

## Functional Programming With Python

Python has partial support for functional programming as a multi-paradigm language. Some Python solutions of mathematical programs can be more easily accomplished with a functional approach.

The most difficult shift to make when you start using a functional approach is to cut down how many classes you use. Classes in Python have mutable attributes which make it difficult to create pure, immutable functions.

Try to instead keep most of your code at the module level and only switch to classes if you need to.

Let’s see how to achieve pure, immutable functions and first-class functions in Python. Then, we’ll learn the syntax for composing functions.

#### Pure and immutable functions

Many of Python’s built-in data structures are immutable by default:

* integer
* float
* boolean
* string
* Unicode
* tuple

Tuples are especially useful as an immutable form of an array.

```py
# Python code to test that  
# tuples are immutable  

tuple1 = (0, 1, 2, 3)  
tuple1[0] = 4
print(tuple1)
```

This code causes an error because it attempts to reassign an immutable tuple object. Functional Python programs should use these immutable data structures often to achieve pure functions.

The following is a pure function because it has no side effects and will always return the same output:

```py
def add_1(x):
    return x + 1
```

#### First-class functions

Functions are treated as objects in Python. Here’s our quick guide on how you can use functions in Python:

**Functions as objects**

```py
def shout(text): 
    return text.upper()
```

**Pass function as parameter**

```py
def shout(text): 
    return text.upper() 

def greet(func): 
    # storing the function in a variable 
    greeting = func("Hi, I am created by a function passed as an argument.") 
    print greeting  

greet(shout)
```

**Return function from another function**

```py
def create_adder(x): 
    def adder(y): 
        return x+y 

    return adder
```

#### Functional composition

To compose functions in Python, we’ll use a `lambda function` call. This allows us to call any number of arguments in a single call.

```py
import functools

def compose(*functions):
    def compose2(f, g):
        return lambda x: f(g(x))
    return functools.reduce(compose2, functions, lambda x: x)
```

At **line 4**, we’ll define a function `compose2` that takes two functions as arguments `f` and `g`.
At **line 5**, we return a new function that represents the composition of `f` and `g`.

Finally, at **line 6**, we return the results of our composition function.

## Functional Programming in JavaScript

JavaScript has long offered functional capabilities due to its support for first-class functions. Functional programming has recently become more popular in JavaScript because it boosts performance when used in frameworks like Angular and React.

Let’s take a look at how to achieve different functional concepts using JavaScript. We’ll focus on how to create the core concepts; pure functions, first-class functions, and function compositions.

#### Pure and immutable functions

To start creating pure functions in JavaScript we’ll have to use functional alternatives of common behavior, like `const`, `concat`, and `filter()`.

The `let` keyword sets a mutable variable. Declaring with `const` instead guarantees that the variable is immutable because it prevents reassignment.

```js
const heightRequirement = 46;

function canRide (height){
    return height >= heightRequirement;
}
```

We also need to use functional alternatives to manipulate arrays. The `push()` method is the usual way to append an element onto an array. Unfortunately, `push()` modifies the original array and is therefore impure.

Instead we’ll use the functional equivalent, `concat()`. This method returns a new array that contains all original elements as well as the newly added element, The original array is not modified when using `concat()`.

```js
const a = [1, 2]
const b = [1, 2].concat(3)
```

To remove an item from an array, we’d usually use the `pop()` and `slice()` methods. However, these are not functional as they modify the original array. Instead, we'll use `filter()` that creates a new array that contains all elements that pass a conditional test.

```js
const words = ['spray', 'limit', 'elite', 'exuberant', 'destruction', 'present'];

const result = words.filter(word => word.length > 6);
```

#### First-class functions

JavaScript supports first-class functions by default. Here’s a quick guide of what we can do with functions in JavaScript.

**Assign function to variable**

```js
const f = (m) => console.log(m)
f('Test')
```

**Add function to array**

```js
const a = [
  m => console.log(m)
]
a[0]('Test')
```

**Pass function as argument**

```js
const f = (m) => () => console.log(m)
const f2 = (f3) => f3()
f2(f('Test'))
```

**Return function from another function**

```js
const createF = () => {
  return (m) => console.log(m)
}
const f = createF()
f('Test')
```

#### Functional composition

In JavaScript, we can compose functions with chained function calls:

```js
obj.doSomething()
   .doSomethingElse()
```

Alternatively, we can pass a function execution into the next function:

```js
obj.doSomething(doThis())
```

If we want to compose more functions, we can instead use `lodash` to simplify the composition. Specifically, we'll use the `compose` feature that is given an argument and then a list of functions.

The first function in the list uses the original argument as its input. Later functions inherit an input argument from the return value of the function before it.

```js
import { compose } from 'lodash/fp'

const slugify = compose(
  encodeURIComponent,
  join('-'),
  map(toLowerCase),
  split(' ')
)

slufigy('Hello World') // hello-world
```

## Functional Programming in Java

Java does not truly support functional programming as Python or JavaScript does. However, we can mimic functional programming behavior in Java by using lambda functions, streams, and anonymous classes.

Ultimately, the Java compiler was not created with functional programming in mind and therefore cannot receive many of the benefits of functional programming.

#### Pure and immutable functions

Several of Java’s built-in data structures are immutable:

* integer
* boolean
* byte
* short
* string

You can also create your own immutable classes with the `final` keyword.

```java
// An immutable class 
public final class Student 
{ 
    final String name; 
    final int regNo; 

    public Student(String name, int regNo) 
    { 
        this.name = name; 
        this.regNo = regNo; 
    } 
    public String getName() 
    { 
        return name; 
    } 
    public int getRegNo() 
    { 
        return regNo; 
    } 
}
```

The `final` keyword on the class prevents the construction of a child class. The `final` on `name` and `regNo` make it impossible to change the values after object construction.

This class also has a parameterized constructor, getter methods for all variables, and no setter methods which each help to make this an immutable class.

#### First-class functions

Java can use lambda functions to achieve first-class functions. Lambda takes in a list of expressions like a method but does not need a name or to be predefined.

We can use lambda expressions in place of functions as they are treated as standard class objects that can be passed or returned.

```java
// FIRST-CLASS
Supplier<String> lambda = myObject::toString;
// HIGHER-ORDER
Supplier<String> higherOrder(Supplier<String> fn) {
    String result = fn.get();
    return () -> result;
}
```

#### Functional composition

Java contains an interface, `java.util.function.Function`, that gives methods for functional composition. The `compose` method executes the passed function first (`multiplyByTen`) then passes the return to the external function (`square`).
The `andThen` method executes the external function first **and then** the function within its parameters.

```java
Function<Integer, Integer> square = (input) -> input * input;
Function<Integer, Integer> multiplyByTen = (input) -> input * 10;

// COMPOSE: argument will be run first
Function<Integer, Integer> multiplyByTenAndSquare = square.compose(multiplyByTen);

// ANDTHEN: argument will run last
Function<Integer, Integer> squareAndMultiplyByTen = square.andThen(multiplyByTen);
```

At **lines 1 and 2**, we first create two functions, `square` and `multiplyByTen`.
Next at **lines 5 and 8**, we make two composite functions, `multiplyByTenAndSquare` and `squareAndMultiplyByTen`, that each takes two arguments (to satisfy `square`).

These composite functions each complete both original functions but in different orders. You can now call the composite functions to execute both original functions on the same input.

## What to Learn Next

Today, we went over some general functional programming concepts and explored how those core concepts appear in Python, JavaScript, and Java.

One of the top functional programming languages making a resurgence is Scala. Many tech giants like Twitter and Facebook have adopted Scala and look for it in their applicants. Your next step is to learn the basics of Scala as an introduction to functional languages.

**Happy learning!**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
