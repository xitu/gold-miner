> * 原文地址：[Unpacking hoisting](http://2ality.com/2019/05/unpacking-hoisting.html)
> * 原文作者：[Dr. Axel Rauschmayer](http://dr-axel.de/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/unpacking-hoisting.md](https://github.com/xitu/gold-miner/blob/master/TODO1/unpacking-hoisting.md)
> * 译者：
> * 校对者：

Quoting [a recent tweet](https://twitter.com/awbjs/status/1133756684340420609) by ES6 spec author Allen Wirfs-Brock:

> Hoisting is old and confused terminology. Even prior to ES6: did it mean “moved to the top of the current scope” or did it mean “move from a nested block to the closest enclosing function/script scope”? Or both?

This blog post proposes a different approach to describing declarations (inspired by a suggestion by Allen).

## Declarations: scope and activation

I propose to distinguish two aspects of declarations:

* Scope: Where can a declared entity be seen? This is a static trait.
* Activation: When can I access an entity? This is a dynamic trait: Some entities can be accessed as soon as we enter their scopes. For others, we have to wait until execution reaches their declarations.

The following table summarizes how various declarations handle these aspects. “Duplicates” describes whether or not it is allowed to declare a name twice within the same scope. “Global prop.” describes if a declaration adds a property to the global object when it is executed in a **script** (a precursor to modules), in global scope. **TDZ** means **temporal dead zone** (which is explained later). Function declarations are block-scoped in strict mode (e.g. inside modules), but function-scoped in non-strict mode.

![](https://i.loli.net/2019/06/10/5cfe182adf3f968308.png)

The following sections describe the behavior of some of these constructs in more detail.

## `const` and `let`: temporal dead zone

For JavaScript, TC39 needed to decide what happens if you access a constant in its direct scope, before its declaration:

```js
{
  console.log(x); // What happens here?
  const x;
}
```

Some possible approaches are:

1. The name is resolved in the scope surrounding the current scope.
2. You get `undefined`.
3. There is an error.

(1) was rejected, because there is no precedent in the language for this approach. It would therefore not be intuitive to JavaScript programmers.

(2) was rejected, because then `x` wouldn’t be a constant – it would have different values before and after its declaration.

`let` uses the same approach (3) as `const`, so that both work similarly and it’s easy to switch between them.

The time between entering the scope of a variable and executing its declaration is called the **temporal dead zone** (TDZ) of that variable:

* During this time, the variable is considered to be uninitialized (as if that were a special value it has).
* If you access an uninitialized variable, you get a `ReferenceError`.
* Once you reach a variable declaration, the variable is set to either the value of the initializer (specified via the assignment symbol) or `undefined` – if there is no initializer.

The following code illustrates the temporal dead zone:

```js
if (true) { // entering scope of `tmp`, TDZ starts
  // `tmp` is uninitialized:
  assert.throws(() => (tmp = 'abc'), ReferenceError);
  assert.throws(() => console.log(tmp), ReferenceError);

  let tmp; // TDZ ends
  assert.equal(tmp, undefined);
}
```

The next example shows that the temporal dead zone is truly **temporal** (related to time):

```js
if (true) { // entering scope of `myVar`, TDZ starts
  const func = () => {
    console.log(myVar); // executed later
  };

  // We are within the TDZ:
  // Accessing `myVar` causes `ReferenceError`

  let myVar = 3; // TDZ ends
  func(); // OK, called outside TDZ
}
```

Even though `func()` is located before the declaration of `myVar` and uses that variable, we can call `func()`. But we have to wait until the temporal dead zone of `myVar` is over.

## Function declarations and early activation

A function declaration is always executed when entering its scope, regardless of where it is located within the scope. That enables you to call a function `foo()` before it is declared:

```js
assert.equal(foo(), 123); // OK
function foo() { return 123; }
```

The early activation of `foo()` means that the previous code is equivalent to:

```js
function foo() { return 123; }
assert.equal(foo(), 123);
```

If you declare a function via `const` or `let`, then it is not activated early: In the following example, you can only use `bar()` after its declaration.

```js
assert.throws(
  () => bar(), // before declaration
  ReferenceError);

const bar = () => { return 123; };

assert.equal(bar(), 123); // after declaration 
```

### Calling ahead without early activation

Even if a function `g()` is not activated early, it can be called by a preceding function `f()` (in the same scope) – if we adhere to the following rule: `f()` must be invoked after the declaration of `g()`.

```js
const f = () => g();
const g = () => 123;

// We call f() after g() was declared:
assert.equal(f(), 123);
```

The functions of a module are usually invoked after its complete body was executed. Therefore, in modules, you rarely need to worry about the order of functions.

Lastly, note how early activation automatically keeps the aforementioned rule: When entering a scope, all function declarations are executed first, before any calls are made.

### A pitfall of early activation

If you rely on early activation to call a function before its declaration, then you need to be careful that it doesn’t access data that isn’t activated early.

```js
funcDecl();

const MY_STR = 'abc';
function funcDecl() {
  assert.throws(
    () => MY_STR,
    ReferenceError);
}
```

The problem goes away if you make the call to `funcDecl()` after the declaration of `MY_STR`.

### The pros and cons of early activation

We have seen that early activation has a pitfall and that you can get most of its benefits without using it. Therefore, it is better to avoid early activation. But I don’t feel strongly about this and, as mentioned before, often use function declarations, because I like their syntax.

## Class declarations are not activated early

Class declarations are not activated early:

```js
assert.throws(
  () => new MyClass(),
  ReferenceError);

class MyClass {}

assert.equal(new MyClass() instanceof MyClass, true);
```

Why is that? Consider the following class declaration:

```js
class MyClass extends Object {}
```

`extends` is optional. Its operand is an expression. Therefore, you can do things like this:

```js
const identity = x => x;
class MyClass extends identity(Object) {}
```

Evaluating such an expression must be done at the location where it is mentioned. Anything else would be confusing. That explains why class declarations are not activated early.

## `var`: hoisting (partial early activation)

`var` is an older way of declaring variables that predates `const` and `let` (which are preferred now). Consider the following `var` declaration.

```js
var x = 123;
```

This declaration has two parts:

* Declaration `var x`: The scope of a `var`-declared variable is the innermost surrounding function and not the innermost surrounding block, as for most other declarations. Such a variable is already active at the beginning of its scope and initialized with `undefined`.
* Assignment `x = 123`: The assignment is always executed in place.

The following code demonstrates `var`:

```js
function f() {
  // Partial early activation:
  assert.equal(x, undefined);
  if (true) {
    var x = 123;
    // The assignment is executed in place:
    assert.equal(x, 123);
  }
  // Scope is function, not block:
  assert.equal(x, 123);
}
```

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
