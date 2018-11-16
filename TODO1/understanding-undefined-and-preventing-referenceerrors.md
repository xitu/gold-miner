> * 原文地址：[Understanding JavaScript’s ‘undefined’](https://javascriptweblog.wordpress.com/2010/08/16/understanding-undefined-and-preventing-referenceerrors/)
> * 原文作者：[Angus Croll](https://javascriptweblog.wordpress.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-undefined-and-preventing-referenceerrors.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-undefined-and-preventing-referenceerrors.md)
> * 译者：
> * 校对者：

# Understanding JavaScript’s ‘undefined’

Compared to other languages, JavaScript’s concept of undefined is a little confusing. In particular, trying to understand ReferenceErrors (“x is not defined”) and how best to code against them can be frustrating.

This is my attempt to straighten things out a little. If you’re not already familiar with the difference between variables and properties in JavaScript (including the internal VariableObject) now might be a good time to check out my [previous posting](https://javascriptweblog.wordpress.com/2010/08/09/variables-vs-properties-in-javascript/).

#### What is undefined?

In JavaScript there is Undefined (type), undefined (value) and undefined (variable).  
  
**Undefined (type)** is a built-in JavaScript type.

**undefined (value)** is a primitive and is the sole value of the Undefined type. Any property that has not been assigned a value, assumes the `undefined` value. (ECMA 4.3.9 and 4.3.10). A function without a return statement, or a function with an empty return statement returns undefined. The value of an unsupplied function argument is undefined.

```
var a;
typeof a; //"undefined"
 
window.b;
typeof window.b; //"undefined"
 
var c = (function() {})();
typeof c; //"undefined"
 
var d = (function(e) {return e})();
typeof d; //"undefined"
```

**undefined (variable)** is a global property whose initial value is undefined (value), Since its a global property we can also access it as a variable. For consistency I’m always going to call it a variable in this article.

```
typeof undefined; //"undefined"
 
var f = 2;
f = undefined; //re-assigning to undefined (variable)
typeof f; //"undefined"
```

As of ECMA 3, its value can be reassigned :

```
undefined = "washing machine"; //assign a string to undefined (variable)
typeof undefined //"string"
 
f = undefined;
typeof f; //"string"
f; //"washing machine"
```

Needless to say, re-assigning values to the undefined variable is very bad practice, and in fact its not allowed by ECMA 5 (though amongst the current set of full browser releases, only Safari enforces this).

#### And then there’s null?

Yes, generally well understood but worth re-stating: `undefined` is distinct from `null` which is also a primitive value representing the _intentional_ absence of a value. The only similarity between `undefined` and `null` is they both coerce to false.

#### So what’s a ReferenceError?

A ReferenceError indicates that an invalid reference value has been detected (ECMA 5 15.11.6.3)

In practical terms, this means a ReferenceError will be thrown when JavaScript attempts to get the value of an unresolvable reference. (There are other cases where a ReferenceError will be thrown, most notably when running in ECMA 5 Strict mode. If you’re interested check the reading list at the end of this article)

Note how the message syntax varies across browser. As we will see none of these messages is particularly enlightening:

```
alert(foo)
//FF/Chrome: foo is not defined
//IE: foo is undefined
//Safari: can't find variable foo
```

#### Still not clear…”unresolvable reference”?

In ECMA terms, a Reference consists of a base value and a reference name (ECMA 5 8.7 – again I’m glossing over strict mode. Also note that ECMA 3 terminology varies slightly but the effect is the same)

If the Reference is a property, the base value and the reference name sit either side of the dot (or first bracket or whatever):

```
window.foo; //base value = window, reference name = foo;
a.b; //base value = a, reference name = b;
myObj['create']; // base value = myObj, reference name = 'create';
//Safari, Chrome, IE8+ only
Object.defineProperty(window,"foo", {value: "hello"}); //base value = window, reference name = foo;
```

For variable References, the base value is the VariableObject of the current execution context. The VariableObject of the global context is the global object itself (`window` in a browser)). Each functional context has an abstract VariableObject known as the ActivationObject.

```
var foo; //base value = window, reference name = foo
function a() {
    var b; base value = <code>ActivationObject</code>, reference name = b
}
```

**A Reference is considered unresolvable if its base value is undefined**

Therefore a property reference is unresolvable if the value before the dot is undefined. The following example would throw a ReferenceError but it doesn’t because TypeError gets there first. This is because the base value of a property is subject to CheckObjectCoercible (ECMA 5 9.10 via 11.2.1) which throws a TypeError when trying to convert Undefined type to an Object. (thanks to kangax for the pre-posting tip off via twitter)

```
var foo;
foo.bar; //TypeError (base value, foo, is undefined)
bar.baz; //ReferenceError (bar is unersolvable)
undefined.foo; //TypeError (base value is undefined)
```

A variable Reference will never be unresolvable since the var keyword ensures a VariableObject is always assigned to the base value.

References which are neither properties or variables are by definition unresolvable and will throw a ReferenceError:

```
foo; //ReferenceError
```

JavaScript sees no explicit base value and therefore looks up the VariableObject for a property with reference name ‘foo’. Finding none it determines ‘foo’ has no base value and throws a ReferenceError

#### But isn’t `foo` just an undeclared variable?

Technically no. Though we sometimes find “undeclared variable” a useful term for bug diagnostics, in reality a variable is not a variable until its declared.

#### What about implicit globals?

It’s true, identifiers which were never declared with the var keyword will get created as global variables – but only if they are the object of an assignment

```
function a() {
    alert(foo); //ReferenceError
    bar = [1,2,3]; //no error, foo is global
}
a();
bar; //"1,2,3"
```

This is, of course, annoying. It would be better if JavaScript consistently threw ReferenceErrors when it encountered unresolvable references (and in fact this is what it does in ECMA Strict Mode)

#### When do I need to code against ReferenceErrors?

If your code is sound, very rarely. We’ve seen that in typical usage there is only one way to get an unresolvable reference: use a syntactically correct Reference that is neither a property or a variable. In most cases this scenario is avoided by ensuring you remember the var keyword. The only time you might get a run-time surprise is when referencing variables that only exist in certain browsers or 3rd party code.

A good example is the **console**. In Webkit browsers the console is built-in and the console property is always available. The Firefox console depends on Firebug (or other add-ons) being installed and switched on. IE7 has no console, IE8 has a console but the console property only exists when IE Developer Tools is started. Apparently Opera has a console but I’ve never got it to work 😉

The upshot is that there’s a good chance the following snippet will throw a ReferenceError when run in the browser:

```
console.log(new Date());
```

#### How do I code against variables that may not exist?

One way to inspect an unresolvable reference without throwing a ReferenceError is by using the `typeof` keyword

```
if (typeof console != "undefined") {
    console.log(new Date());
}
```

However this always seems verbose to me, not to mention dubious (its not the reference name that is undefined, its the base value), and anyway I prefer to reserve `typeof` for positive type checking.

Fortunately there’s an alternative: we already know that undefined properties will not throw a ReferenceError providing their base value is defined- and since console belongs to the global object, we can just do this:

```
window.console && console.log(new Date());
```

In fact you should only ever need to check for variable existence within the global context (the other execution contexts exist within functions, and you control what variables exist in your own functions). So in theory at least you should be able to get away without ever using a `typeof` check against a ReferenceError

#### Where can I read more?

Mozilla Developer Center: [undefined](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/undefined)
Angus Croll: [Variables vs. properties in JavaScript](https://javascriptweblog.wordpress.com/2010/08/09/variables-vs-properties-in-javascript/)  
Juriy Zaytsev (“kangax”): [Understanding Delete](http://perfectionkills.com/understanding-delete/)  
Dmitry A. Soshnikov: [ECMA-262-3 in detail. Chapter 2. Variable object.](http://dmitrysoshnikov.com/ecmascript/chapter-2-variable-object/)  
[ECMA-262 5th Edition](http://www.ecmascript.org/docs/tc39-2009-043.pdf)  
_undefined_: 4.3.9, 4.3.10, 8.1
_Reference Error_: 8.7.1, 8.7.2, 10.2.1, 10.2.1.1.4, 10.2.1.2.4, and 11.13.1.
_The Strict Mode of ECMAScript_ Annex C

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
