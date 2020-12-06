> * 原文地址：[Functional Programming Explained in Python, JavaScript, and Java](https://medium.com/better-programming/functional-programming-explained-in-python-javascript-and-java-2dbf875046a9)
> * 原文作者：[The Educative Team](https://medium.com/@educative)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/functional-programming-explained-in-python-javascript-and-java.md](https://github.com/xitu/gold-miner/blob/master/article/2020/functional-programming-explained-in-python-javascript-and-java.md)
> * 译者：[z0gSh1u](https://github.com/z0gSh1u)
> * 校对者：[regonCao](https://github.com/regon-cao)、[NieZhuZhu](https://github.com/NieZhuZhu)、[icicle198514](https://github.com/icicle198514)

# 函数式编程 —— 使用 Python、JavaScript 和 Java 描述

![Image source: Author](https://i.loli.net/2020/11/09/XbJCtsNHlfIyjVG.png)

函数式编程（FP）是通过组合纯函数来构建软件的过程。如今，雇主们在寻找能利用多种范式来解决问题的程序员。而函数式编程凭借其解决最新的问题的高效性和可扩展性，尤其受到欢迎。

但怎样才可以从面向对象编程（OOP）转换到函数式编程（FP）呢？

今天，我们将探究函数式编程的核心概念，并向你展示如何在 Python、JavaScript 和 Java 中实现它们。

**本文将覆盖下面这些内容：**

* 函数式编程是什么
* 函数式编程语言
* 函数式编程的相关概念
* 函数式编程 —— 使用 Python
* 函数式编程 —— 使用 JavaScript
* 函数式编程 —— 使用 Java
* 接下来学什么

## 函数式编程是什么

**函数式编程**是一种声明式的编程范式，程序是基于应用函数序列而非语句构建的。

每个函数接收一个输入，并对相同输入总是返回一致的输出，且不会改变程序的状态，也不会受其影响。

这些函数完成单一的操作，并且能够顺序地组合起来以完成复杂的操作。函数式编程范式会让代码高度模块化，因为函数能够在程序中复用，也能被调用、作为参数传递，或者是被返回。

**纯函数**没有副作用，并且不依赖于全局的变量或状态。

![Visualizing FP Functions](https://i.loli.net/2020/11/09/gnxakfDrOi23jVZ.png)

当解决方案能够容易地用函数表示，并且几乎没有实体方面的含义时，就可以使用函数式编程。相比面向对象程序基于现实对象的代码建模方法，函数式编程则更擅长于实现数学意义上的函数，它的中间或者最终值之间并没有实体关联。

函数式编程的常见应用有 AI 设计、机器学习分类算法、经济学程序，或者高级的数学函数模型。

**简而言之：**函数式的程序顺序执行许多纯的、单一职能的函数来解决复杂的数学或者非实体问题。

## 函数式编程的优点

* **调试简单**：纯函数和不可变的数据使查找设置变量值的位置变得容易。影响纯函数的因素更少，因此能让你更容易发现有 Bug 的部分。
* **延迟计算**：函数式程序只在计算结果被需要时才进行计算。这让程序能够复用之前的计算结果，并节省运行时间。
* **模块化**：纯函数并不依赖外部的变量或者状态，这意味着可以很简单地在程序中复用它们。并且，函数只会完成单一的操作或者计算，来保证你可以在不引入额外代码的前提下复用函数。
* **更好的可读性**：函数式程序易于阅读，因为每个函数的行为是不可变的，并且隔离于程序的状态。这使得你多数情况下借助函数名就可以预见每个函数的行为。
* **并行化编程**：使用函数式编程的方法构建并行程序更简单，因为不可变量减少了程序内部的变化。每个函数只需要处理自己的输入，并且可以认为程序的状态大多数情况下都会保持不变。

## 函数式编程语言

不是所有的编程语言都支持函数式编程。某些语言，比如 Haskell，生来就被设计为函数式编程语言。其他一些语言，比如 JavaScript，既有函数式编程的能力，也有面向对象编程的能力。剩下的就是那些完全不支持函数式编程的语言。

#### 纯粹的函数式编程语言

* [**Haskell**](https://www.haskell.org/)：这是最受欢迎的函数式编程语言。它内存安全、垃圾收集完善，并且得益于提前的机器码编译，运行速度也快。Haskell 丰富且静态的类型系统让你可以使用独特的代数和多态的类型，使函数式编程更加高效，并且可读性更好。
* [**Erlang**](https://www.erlang.org/)：这门语言以及它的衍生语言 Elixir，在并发系统开发方面建立了函数式语言的标杆。尽管并不像 Haskell 一样受欢迎且使用广泛，它仍经常被用在后端开发中。Erlang 最近在开发像 WhatsApp 和 Discord 这类可扩展的通信应用方面也越来越受欢迎。
* [**Clojure**](https://clojure.org/)：这门语言是 Lisp 的函数作为一等公民的方言，运行在 JVM 上。它基本上是一门函数式编程语言，既支持可变的，也支持不可变的数据结构。相较于这里其他的函数式语言，它不是特别严格。如果你喜欢 Lisp，你也会喜欢 Clojure。
* [**F#**](https://fsharp.org/)：F# 类似于 Haskell（它们属于同一语言组），但高级特性比较少。它也对面向对象编程有一些支持。

#### 支持函数式编程的语言

* **[Scala](https://www.scala-lang.org/)**：Scala 既支持函数式编程，也支持面向对象编程。它最有意思的特性是一个类似于 Haskell 的强静态类型系统，来帮助你编写健壮的函数式程序。Scala 被设计用来解决对 Java 的批评，因此对于那些想要尝试函数式编程的 Java 开发者是一门好语言。
* **JavaScript**：尽管函数并不是一等公民，JavaScript 凭借自身的异步特性，在函数式编程方面也相当突出。JavaScript 也支持基本的函数式编程特性，比如 lambda 表达式和解构。这些特性共同让 JavaScript 成为了多范式语言中把函数式编程支持得最好的语言。
* **Python、PHP、C++**：这些多范式语言支持函数式编程，但比起 Scala 和 JavaScript，支持得并不完全。
* **Java**：Java 是一门多目标的语言，但在面向对象编程方面最为领先。新增的 Lambda 表达式让你能够有限地使用更加函数式的编程风格。Java 终究还是一门面向对象的语言，它**能**实现函数式编程，但缺失了很多关键的特性，这使得这种转变并不是特别值得。

## 函数式编程相关概念

编写函数式的程序时，需要了解下面几个核心概念：

#### 变量和函数

函数式程序的核心部分是变量和函数，而不是对象和方法。你应该避免使用全局变量，因为可变的全局变量会使得程序难以读懂，并带来不纯的函数。

#### 纯函数

纯函数有两个属性：

* 不产生副作用；
* 对于相同的输入，总是给出相同的输出。

当函数改变程序的状态、覆写了输入变量，或者在生成输出值时改变了任何其他东西，就产生了副作用。纯函数更不容易产生 Bug，因为副作用会使程序的状态复杂化。

函数的 “引用透明性” 指的是函数的输出可以在不改变程序的情况下发生变化。这个概念保证了你能创建单一职能的函数并对相同输入获得前后一致的输出。

引用透明性只有在函数不影响程序状态或者尝试完成多于一种操作时才是可能的。

#### 不可变性和状态

不可变的数据或状态一旦被设置，就不能更改，这为函数输出的一致性提供了稳定的环境。函数对相同输入能给出相同输出，不受程序状态的影响，是一种编程的最佳实践。如果函数必须依赖于某个状态，则这个状态必须是不可变的，以保证函数输出的一致性。

函数式编程避免使用有共享状态的函数（多个函数依赖同一个状态）以及会改变状态的函数（函数依赖于另一个可变的函数），因为它们减弱了程序的模块化。如果你必须用有共享状态的函数，就让状态不可变。

#### 递归

面向对象编程和函数式编程的显著不同的一点是，函数式编程避免使用诸如 if-else 语句或者循环等在每次执行时会产生不同输出的结构。

函数式的程序使用递归来替代所有迭代中的循环操作。

#### 函数是一等公民

函数式编程语言中的函数被认为是一种数据类型，并且能够像其他值一样被使用。比如，我们可以构造一个函数组成的数组、将函数作为参数传递，或者把函数保存在变量中。

#### 高阶函数

高阶函数能接收其他函数作为参数，或者将函数作为返回值。高阶函数让我们的函数调用以及对动作的抽象变得灵活了许多。

#### 函数组合

函数可以序列地执行来完成复杂的操作。每个函数的执行结果都作为参数被传递给下一个函数。这让你可以通过一处函数调用来调用一系列函数。

## 函数式编程 —— 使用 Python

Python 作为一个多范式语言，部分地支持了函数式编程。借助函数式编程，一些数学问题可以通过 Python 更容易地被实现。 

开始使用函数式编程最难的一个改变是要减少类的使用量。Python 中的类有着可变的属性，这使得我们难以创建纯的、不可变的函数。

试着将你的大部分代码保持在模块级别，仅当必须时才使用类。

让我们看看在 Python 中如何实现纯的、不可变的函数以及一等公民函数。然后，我们将学习函数组合的语法。

#### 纯的、不可变的函数

许多 Python 的内置数据结构默认就是不可变的：

* integer
* float
* boolean
* string
* Unicode
* tuple

元组作为数组的不可变形式，尤其有用。

```python
# 用来测试元组的不可变性的 Python 代码

tuple1 = (0, 1, 2, 3)  
tuple1[0] = 4
print(tuple1)
```

这份代码会产生错误，因为它试图给不可变的元组对象重新赋值。函数式的 Python 程序应该多使用这些不可变的数据结构来实现纯函数。

下面是一个纯函数，因为它没有副作用，并且对相同输入总是给出相同输出：

```python
def add_1(x):
    return x + 1
```

#### 函数是一等公民

函数在 Python 中被认为是对象。下面简要介绍了如何在 Python 中使用函数：

**函数作为对象**

```python
def shout(text): 
    return text.upper()
```

**函数作为参数传递**

```python
def shout(text): 
    return text.upper() 

def greet(func): 
    # 把函数存在一个变量里
    greeting = func("Hi, I am created by a function passed as an argument.") 
    print greeting

greet(shout)
```

**从函数中返回函数**

```python
def create_adder(x): 
    def adder(y): 
        return x+y 

    return adder
```

#### 函数组合

为了在 Python 中组合函数，我们会用 Lambda 表达式。这使得我们能够在一次函数调用中同时调用多个函数。

```python
import functools

def compose(*functions):
    def compose2(f, g):
        return lambda x: f(g(x))
    return functools.reduce(compose2, functions, lambda x: x)
```

在**第 4 行**，我们定义了 `compose2` ，它接收两个函数 `f` 和 `g` 作为参数。
在**第 5 行**，我们返回了一个表示 `f` 和 `g` 的组合的新函数。

最后，在**第 6 行**，我们返回了组合函数的结果。

## 函数式编程 —— 使用 JavaScript

得益于对 “函数是一等公民” 的支持，JavaScript 已经提供函数式编程能力很久了。最近，JavaScript 中的函数式编程越来越受欢迎，因为在 Angular 和 React 等框架中使用函数式编程时可以提升性能。

让我们看看如何使用 JavaScript 来实现函数式编程。我们会关注如何表达函数式编程的核心概念：纯函数、函数是一等公民，以及函数组合。

#### 纯函数和不可变函数

为了在 JavaScript 中创建纯函数，我们必须用函数式的方法替代传统方法，比如 `const`，`concat` 和 `filter()`。

`let` 关键字声明了一个可变的量。转而用 `const` 来声明可以保证变量的不可变性，因为它阻止了重新赋值。

```js
const heightRequirement = 46;

function canRide (height) {
    return height >= heightRequirement;
}
```

我们也需要用函数式的方式来操作数组。通常我们往数组中增加元素的方法是 `push()`。然而，`push()` 会修改原数组，因此是不纯的。

相反地，我们使用函数式的等价方法 `concat()`。这个方法会返回一个包含了原有元素和新增元素的新数组，且原数组不会被修改。

```js
const a = [1, 2]
const b = [1, 2].concat(3)
```

为了从数组中删除元素，我们通常使用 `pop()` 和 `slice()` 方法。然而，由于它们会修改原数组，所以并不是函数式的。相反地，我们会使用 `filter()`，它创建一个由那些能通过条件测试的元素组成的新数组。

```js
const words = ['spray', 'limit', 'elite', 'exuberant', 'destruction', 'present'];

const result = words.filter(word => word.length > 6);
```

#### 函数是一等公民

JavaScript 默认支持函数作为一等公民。下面简单介绍了我们可以在 JavaScript 中用函数做什么。

**把函数赋值给变量**

```js
const f = (m) => console.log(m)
f('Test')
```

**将函数放在数组中**

```js
const a = [
  m => console.log(m)
]
a[0]('Test')
```

**把函数作为参数传递**

```js
const f = (m) => () => console.log(m)
const f2 = (f3) => f3()
f2(f('Test'))
```

**从函数中返回函数**

```js
const createF = () => {
  return (m) => console.log(m)
}
const f = createF()
f('Test')
```

#### 函数组合

在 JavaScript 中，我们可以使用链式函数调用来组合函数：

```js
obj.doSomething()
   .doSomethingElse()
```

或者，我们可以把函数的执行结果传给下一个函数：

```js
obj.doSomething(doThis())
```

如果我们想要组合更多的函数，我们可以使用 `lodash` 来简化组合过程。具体地，我们会使用 `compose` 特性。它接收一个函数作为第一个参数，后面跟着一系列函数调用。

参数中的第一个函数会使用原始的调用参数，之后的函数调用则依赖前面那个函数的返回值。

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

## 函数式编程 —— 使用 Java

Java 并不像 Python 和 JavaScript 那样真正意义上地支持函数式编程。然而，我们可以使用 Lambda 表达式、流以及匿名类来模拟函数式编程行为。

Java 编译器终归不是针对函数式编程设计的，因此无法带来函数式编程的许多好处。

#### 纯函数和不可变函数

Java 内置的一些数据类型是不可变的：

* integer
* boolean
* byte
* short
* string

你也可以借助 `final` 关键字来创建自定义的不可变的类：

```java
// 一个不可变的类
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

作用在类上的 `final` 关键字阻止了子类的构造。在 `name`  和 `regNo` 上的 `final` 则使得在完成对象构造后对它们的修改变得不可能。

这个类同样有一个带参的构造函数以及所有属性上的 Getter 方法。因为没有 Setter 方法，所以这个类是不可变的。

#### 函数是一等公民

Java 可以使用 Lambda 表达式来实现函数作为一等公民。Lambda 表达式像一个方法一样接收一系列的表达式，但自身不需要具名或者被预先定义。

我们可以使用 Lambda 表达式来替代普通的函数，因为它也被认为是标准的类对象，可以用来传递或者返回。

```java
// 函数是一等公民
Supplier<String> lambda = myObject::toString;
// 高阶函数
Supplier<String> higherOrder(Supplier<String> fn) {
    String result = fn.get();
    return () -> result;
}
```

#### 函数组合

Java 里有一个 Interface：`java.util.function.Function`。它提供了进行函数组合的方法。`compose` 方法会首先执行传入的函数（`multiplyByTen`），然后把返回值传递给外部的函数（`square`）。
`andThen` 方法则首先执行外部的函数，然后才是参数中的函数。

```java
Function<Integer, Integer> square = (input) -> input * input;
Function<Integer, Integer> multiplyByTen = (input) -> input * 10;

// COMPOSE: 参数中的函数会先被运行
Function<Integer, Integer> multiplyByTenAndSquare = square.compose(multiplyByTen);

// ANDTHEN: 参数中的函数会后被运行
Function<Integer, Integer> squareAndMultiplyByTen = square.andThen(multiplyByTen);
```

在**第 1 行和第 2 行**，我们首先创建了两个函数 `square` 和 `multiplyByTen`。
然后在**第 5 行和第 8 行**，我们创建了两个组合函数 `multiplyByTenAndSquare` 和 `squareAndMultiplyByTen`，这两个组合函数都会被传入两个参数（第一个参数是调用时传给组合函数的参数，第二个参数是首先被调用的那个函数的返回值）。

这两种组合函数最终都完成了原来的分函数的功能，但顺序不同。你可以试着使用同样的输入来执行这两个组合函数。

## 接下来学什么

今天，我们讨论了一些函数式编程的基本概念，并探索了这些核心概念在 Python、JavaScript 和 Java 中是如何体现的。

重新变得火热的函数式编程语言之一是 Scala。许多科技巨头，比如 Twitter 和 Facebook，都使用 Scala，并招聘相关的技术人员。作为函数式编程语言的入门，你的下一步是学习路线应该是 Scala。

**祝你学的开心！**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
