> * 原文地址：[Note 6. ES6: Default values of parameters](http://dmitrysoshnikov.com/ecmascript/es6-notes-default-values-of-parameters/)
> * 原文作者：[Dmitry Soshnikov](http://dmitrysoshnikov.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/es6-notes-default-values-of-parameters.md](https://github.com/xitu/gold-miner/blob/master/TODO1/es6-notes-default-values-of-parameters.md)
> * 译者：
> * 校对者：

# Note 6. ES6: Default values of parameters

In this small note we’ll cover another ES6 feature, function parameters with _default values_. As we will see there are some subtle cases there.

## Manual defaults from ES5 and lower

Previously default parameter values were handled manually in several alternative ways:

```
function log(message, level) {
  level = level || 'warning';
  console.log(level, ': ', message);
}
 
log('low memory'); // warning: low memory
log('out of memory', 'error'); // error: out of memory
```

To avoid possible “falsey values”, often one can see `typeof` check:

```
if (typeof level == 'undefined') {
  level = 'warning';
}
```

Sometimes, one could check also `arguments.length`:

```
if (arguments.length == 1) {
  level = 'warning';
}
```

All these approaches worked well, however, all of them are too manual, and less abstract. ES6 standardized a syntactic construct to define a default value for a parameter directly in the head of a function.

## ES6 defaults: basic example

Default parameter values are present in many languages, so the basic form should probably be familiar to most of the developers:

```
function log(message, level = 'warning') {
  console.log(level, ': ', message);
}
 
log('low memory'); // warning: low memory
log('out of memory', 'error'); // error: out of memory
```

Pretty casual default parameters usage, and yet convenient. Let’s dive into implementation details to clarify possible confusions that may arise with default parameters.

## Implementation details

Below are several specific to ES6 implementation details of function default parameter values.

### Fresh evaluation at execution time

In contrast with some other languages (e.g. Python), that may calculate default parameters once, at _definition time_, ECMAScript evaluates default parameter values at _execution time_ — on every single function call. This design choice was made to avoid confusions with complex objects used as default values. Consider the following Python example:

```
def foo(x = []):
  x.append(1)
  return x
 
# We can see that defaults are created once, when
# the function is defined, and are stored as
# just a property of the function
print(foo.__defaults__) # ([],)
 
foo() # [1]
foo() # [1, 1]
foo() # [1, 1, 1]
 
# The reason for this as we said:
print(foo.__defaults__) # ([1, 1, 1],)
```

To avoid such behavior Python developers used to define the default value as `None`, and make an explicit check for this value:

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

However, this is the same manual inconvenient handling of the actual default value, and the initial case is just confusing. That’s said, to avoid this, ECMAScript defaults are evaluated on every function execution:

```
function foo(x = []) {
  x.push(1);
  console.log(x);
}
 
foo(); // [1]
foo(); // [1]
foo(); // [1]
```

All good and intuitive. Now let’s see when ES semantics may also confuse if not to know how it works.

### Shadowing of the outer scope

Consider the following example:

```
var x = 1;
 
function foo(x, y = x) {
  console.log(y);
}
 
foo(2); // 2, not 1!
```

The example above outputs `2` for `y`, not `1`, as _visually_ may look like. The reason for this is that `x` from the parameters is _not the same_ as the global `x`. And since evaluation of the defaults happens at call time, then when assignment, `= x`, happens, the `x` is already resolved in the _inner scope_, and refers to the _`x` parameter itself_. That is parameter `x` _shadowed_ global variable with the same name, and every access to `x` from the default values refers to the parameter.

### TDZ (Temporal Dead Zone) for parameters

ES6 mentions so called _TDZ_ (stands for _Temporal Dead Zone_) — this is the region of a program, where a variable or a parameter _cannot be accessed_ until it’s _initialized_ (i.e. received a value).

Regarding parameters, a _parameter cannot have default value of itself_:

```
var x = 1;
 
function foo(x = x) { // throws!
  ...
}
```

The assignment `= x` as we mentioned above resolves `x` in the parameters scope, that shadowed the global `x`. However, the parameter `x` is under the TDZ, and cannot be accessed until it’s initialized. Obviously, it cannot be initialized to itself.

Notice, that previous example from above with `y` is valid, since `x` is already initialized (to implicit default value `undefined`). Let’s show it again:

```
function foo(x, y = x) { // OK
  ...
}
```

The reason why it’s allowed is that parameters in ECMAScript are initialized from _left to right order_, and we have `x` already available for usage.

We mentioned that parameters are related already with the “inner scope”, which from ES5 we could assume it’s the scope of the _function body_. However, it’s a bit more complicated: it _may_ be a scope of a function, _or_, an _intermediate scope_, created specially _to store parameters bindings_. Let’s consider them.

### Conditional intermediate scope for parameters

In fact, in case if _some_ (at least one) of the parameters have default values, ES6 defines an _intermediate scope_ to store the parameters, and this scope is _not shared_ with the scope of the _function body_. This is a major difference from ES5 in this respect. Let’s demonstrate it on the example:

```
var x = 1;
 
function foo(x, y = function() { x = 2; }) {
  var x = 3;
  y(); // is `x` shared?
  console.log(x); // no, still 3, not 2
}
 
foo();
 
// and the outer `x` is also left untouched
console.log(x); // 1
```

In this case, we have _three scopes_: the global environment, the parameters environment, and the environment of the function:

```
:  {x: 3} // inner
-> {x: undefined, y: function() { x = 2; }} // params
-> {x: 1} // global
```

Now we see that when function `y` is executed, it resolves `x` in the nearest environment (i.e. in the same environment), and doesn’t even see the scope of the function.

#### Transpiling to ES5

If we’re about to compile ES6 code to ES5, and see how this intermediate scope looks like, we would get something like this:

```
// ES6
function foo(x, y = function() { x = 2; }) {
  var x = 3;
  y(); // is `x` shared?
  console.log(x); // no, still 3, not 2
}
 
// Compiled to ES5
function foo(x, y) {
  // Setup defaults.
  if (typeof y == 'undefined') {
    y = function() { x = 2; }; // now clearly see that it updates `x` from params
  }
 
  return function() {
    var x = 3; // now clearly see that this `x` is from inner scope
    y();
    console.log(x);
  }.apply(this, arguments);
}
```

#### The reason for the params scope

However, what is the _exact purpose_ of this _params scope_? Why can’t we still do ES5-way and share params with the function body? The reason is: the variables in the body with the same name _should not affect captured in [closures](http://dmitrysoshnikov.com/ecmascript/chapter-6-closures/) bindings with the same name_.

Let’s show on the example:

```
var x = 1;
 
function foo(y = function() { return x; }) { // capture `x`
  var x = 2;
  return y();
}
 
foo(); // correctly 1, not 2
```

If we create the function `y` in the scope of the _body_, it would capture inner `x`, that is, `2`. However, it’s clearly observable, that it should capture the outer `x`, i.e. `1` (unless it’s _shadowed_ by the parameter with the same name).

At the same time we cannot create the function in the outer scope, since this would mean we won’t be able to access the _parameters_ from such function, and we should be able to do this:

```
var x = 1;
 
function foo(y, z = function() { return x + y; }) { // can see `x` and `y`
  var x = 3;
  return z();
}
 
foo(1); // 2, not 4
```

#### When the params scope is not created

The described above semantics _completely different_ than what we have in _manual implementation_ of defaults:

```
var x = 1;
 
function foo(x, y) {
  if (typeof y == 'undefined') {
    y = function() { x = 2; };
  }
  var x = 3;
  y(); // is `x` shared?
  console.log(x); // yes! 2
}
 
foo();
 
// and the outer `x` is again untouched
console.log(x); // 1
```

Now that’s an interesting fact: if a function _doesn’t have defaults_, it _doesn’t create this intermediate scope_, and _share_ the parameters binding _in the environment of a function_, i.e. _works in the ES5-mode_.

Why these complications? Why not always create the parameters scope? Is it just about optimizations? Not really. The reason for this is exactly legacy backward compatibilities with ES5: the code from above with manual implementation of defaults _should_ update `x` from the function body (which is the parameter itself, and is in the same scope).

Notice also, that those redeclarations are allowed only for `var`s and functions. It’s not possible to redeclare parameter using `let` or `const`:

```
function foo(x = 5) {
  let x = 1; // error
  const x = 2; // error
}
```

### The check for `undefined`

Another interesting thing to note, is that the fact whether a default value should be applied, is based on checking the initial value (that is assigned [on entering the context](http://dmitrysoshnikov.com/ecmascript/chapter-2-variable-object/#entering-the-execution-context)) of the parameter with the value of `undefined`. Let’s demonstrate it:

```
function foo(x, y = 2) {
  console.log(x, y);
}
 
foo(); // undefined, 2
foo(1); // 1, 2
 
foo(undefined, undefined); // undefined, 2
foo(1, undefined); // 1, 2
```

Usually in programming languages parameters with default values go after the required parameters, however, the fact from above allows us to have the following construct in JavaScript:

```
function foo(x = 2, y) {
  console.log(x, y);
}
 
foo(1); // 1, undefined
foo(undefined, 1); // 2, 1
```

### Default values of destructured components

Another place where default values participate is the defaults of destructured components. The topic of destructuring assignment is not covered in this article, but let’s show some small examples. The handling of defaults in case of using destructuring in the function parameters is the same as with simple defaults described above: i.e create two scopes if needed.

```
function foo({x, y = 5}) {
  console.log(x, y);
}
 
foo({}); // undefined, 5
foo({x: 1}); // 1, 5
foo({x: 1, y: 2}); // 1, 2
```

Although, defaults of destructuring are more generic, and can be used not only in functions:

```
var {x, y = 5} = {x: 1};
console.log(x, y); // 1, 5
```

## Conclusion

Hope this brief note helped to explain the details of default values in ES6. Notice, that at the day of writing (Aug 21, 2014), _none of the implementations_ implement the defaults correctly (all of them just create one scope, which is shared with the function body), since this “second scope” was just recently added to the spec draft. The default values are definitely a useful feature, that will make our code more elegant and concise.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
