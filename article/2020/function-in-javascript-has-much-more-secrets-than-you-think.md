> * 原文地址：[Function in JavaScript Has Much More Secrets Than You Think](https://medium.com/javascript-in-plain-english/function-in-javascript-has-much-more-secrets-than-you-think-b3bf64055c99)
> * 原文作者：[bitfish](https://medium.com/@bf2)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/function-in-javascript-has-much-more-secrets-than-you-think.md](https://github.com/xitu/gold-miner/blob/master/article/2020/function-in-javascript-has-much-more-secrets-than-you-think.md)
> * 译者：
> * 校对者：

# Function in JavaScript Has Much More Secrets Than You Think

## Function in JavaScript Has More Secrets Than You Think

#### Things that advanced JavaScript programmers must know.

![Photo by [Luca Bravo](https://unsplash.com/@lucabravo?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*9flb0rn0PvVk8f88)

Functions are a familiar syntax to every programmer. In JavaScript, functions have a very high status and are often referred to as first-class citizens. But are you really good at using functions?

Here I’ll introduce some advanced tips for using functions that I hope will help you. This article includes the following sections:

* Pure Function
* Higher-Order Function
* Function Caching
* Lazy Function
* Currying
* Function Compose

## Pure Function

#### What is a pure function?

A function that meets both of the following conditions is called a pure function:

* It was always returned the same result if given the same arguments.
* No side effects occur during the execution of the function

Example 1:

```
function circleArea(radius){
  return radius * radius * 3.14
}
```

When the values of the radius are the same, the function always returns the same result. And the execution of the function has no effect on the outside of the function, so this is a pure function.

Example 2:

```
let counter = (function(){
  let initValue = 0
  return function(){
    initValue++;
    return initValue
  }
})()
```

![](https://cdn-images-1.medium.com/max/2000/1*-ao0govuJNMZH1Pg_vAu8g.png)

This counter function will run differently every time, so this is not a pure function.

Example 3:

```
let femaleCounter = 0;
let maleCounter = 0;

function isMale(user){
  if(user.sex = 'man'){
    maleCounter++;
    return true
  }
  return false
}
```

In the example above, the function `isMale`, given the same argument, always has the same result, but it has side effects. The side effect is to change the value of the global variable `maleCounter`, so it is not pure.

#### What’s the use of pure functions?

Why do we distinguish pure functions from other functions? Because pure functions have many advantages, we can use pure functions to improve the quality of our code during the programming process.

1. Pure functions are much clearer and easier to read

Each pure function always accomplishes a specific task and has an exact result. This will greatly improve the readability of the code and make it easier to write documents.

2. The compiler can do more optimization on pure functions

Let’s say I have a code snippet like this:

```
for (int i = 0; i < 1000; i++){
    console.log(fun(10));
}
```

If `fun` were not a pure function, then `fun(10)` would need to be executed 1,000 times while this code is running.

If `fun` were a pure function, the editor would be able to optimize the code at compile time. The optimized code might look like this:

```
let result = fun(10)
for (int i = 0; i < 1000; i++){
    console.log(result);
}
```

3. Pure functions are easier to test

Tests of pure functions do not need to be context-dependent. When we write unit tests for pure functions, we simply give an input value and assert that the output of the function meets our requirements.

A simple example: A pure function takes an array of numbers as an argument and increments each element of the array by 1.

```
const incrementNumbers = function(numbers){
  // ...
}
```

We just need to write the unit test for it like this:

```
let list = [1, 2, 3, 4, 5];

assert.equals(incrementNumbers(list), [2, 3, 4, 5, 6])
```

If it’s not a pure function, we have a lot of external factors to consider, and it’s not a simple task.

## Higher-Order Function

What is a higher-order function?

A higher-order function is a function that does at least one of the following:

* takes one or more functions as arguments
* returns a function as its result.

Using higher-order functions can increase the flexibility of our code, allowing us to write a more concise and efficient code.

Let’s say we now have an array of integers, and we want to create a new array. The elements of the new array have the same length as the original array, and the value of the corresponding element is twice the value of the original array.

Without using higher-order functions, we might write like this:

```
const arr1 = [1, 2, 3];
const arr2 = [];

for (let i = 0; i < arr1.length; i++) {
    arr2.push(arr1[i] * 2);
}
```

In JavaScript, the array object has a `map()` method.

> The `**map(callback)**` method creates a new array populated with the results of **calling a provided function** on every element in the calling array.

```
const arr1 = [1, 2, 3];
const arr2 = arr1.map(function(item) {
  return item * 2;
});
console.log(arr2);
```

The `map` function is a higher-order function.

Using higher-order functions correctly can improve the quality of our code. The next sections are all about higher-order functions, so let’s move on.

## Function Caching

Let’s say we have a pure function that looks like this:

![](https://cdn-images-1.medium.com/max/2112/1*I6_ntKBi7pBS03jbyexzMg.png)

```
function computed(str) {    
    // Suppose the calculation in the funtion is very time consuming        
    console.log('2000s have passed')
      
    // Suppose it is the result of the function
    return 'a result'
}
```

To increase the speed of the program, we want to cache the result of the function operation. When it is called later, if the parameters are the same, the function will no longer be executed, but the result in the cache will be returned directly. What can we do?

We can write a `cached` function to wrap around our target function. This cache function takes the target function as an argument and returns a new wrapped function. Inside the `cached` function, we can cache the result of the previous function call with an `Object` or `Map`.

```JavaScript
function cached(fn){
  // Create an object to store the results returned after each function execution.
  const cache = Object.create(null);

  // Returns the wrapped function
  return function cachedFn (str) {

    // If the cache is not hit, the function will be executed
    if ( !cache[str] ) {
        let result = fn(str);

        // Store the result of the function execution in the cache
        cache[str] = result;
    }

    return cache[str]
  }
}
```

Here is an example:

![](https://cdn-images-1.medium.com/max/2528/0*iLTBkgsiO05dd_XZ.png)

## Lazy Function

The body of a function usually contains some conditional statements. Sometimes these statements only need to be executed once.

We can improve the performance of the function by ‘deleting’ these statements after the first execution, so that the function does not need to execute these statements in subsequent executions. That is lazy function.

For example, we now need to write a function called `foo` that always returns the Date object from the `first call`, note ‘the first call’.

![](https://cdn-images-1.medium.com/max/2000/1*EO_O90uQVGtGVVLWK7B6AQ.png)

```
let fooFirstExecutedDate = null;
function foo() {
    if ( fooFirstExecutedDate != null) {
      return fooFirstExecutedDate;
    } else {
      fooFirstExecutedDate = new Date()
      return fooFirstExecutedDate;
    }
}
```

Each time the above function is run, the judgment statement needs to be executed. If this judgment condition is very complex, then it will result in the performance degradation of our program. At this point, we can use the technique of lazy functions to optimize this code.

We could write code like this:

![](https://cdn-images-1.medium.com/max/2000/1*YJLZSc5r7SCKzsYH1Qnr_A.png)

```
var foo = function() {
    var t = new Date();
    foo = function() {
        return t;
    };
    return foo();
}
```

After the first execution, we overwrite the original function with the new function. When this function is executed in the future, the judgment statement will no longer be executed. This will improve the performance of our code.

Then let’s look at a more practical example.

When we add DOM events to the element, in order to be compatible with modern browsers and IE browsers, we need to make a judgment on the browser environment:

```
function addEvent (type, el, fn) {
    if (window.addEventListener) {
        el.addEventListener(type, fn, false);
    }
    else if(window.attachEvent){
        el.attachEvent('on' + type, fn);
    }
}
```

Every time we call the `addEvent` function, we hava to make a judgment. Using lazy functions, we can do this:

![](https://cdn-images-1.medium.com/max/2132/1*Lckc0KzdoRSSkzVZ99qJ0w.png)

```
function addEvent (type, el, fn) {
    if (window.addEventListener) {
        addEvent = function (type, el, fn) {
            el.addEventListener(type, fn, false);
        }
    }
    else if(window.attachEvent){
        addEvent = function (type, el, fn) {
            el.attachEvent('on' + type, fn);
        }
    }
}
```

To sum up, if there is a conditional judgment within a function that only needs to be executed once, then we can optimize it with lazy functions. In particular, after the first judgment is made, the original function is overwritten with the new function, and the new function removes the conditional judgment.

## Function Currying

Currying is a technique of evaluating function with **multiple arguments**, into a sequence of functions with a single argument.

In other words, when a function, instead of taking all arguments at one time, takes the first one and return a new function that takes the second one and returns a new function which takes the third one, and so forth until all arguments have been fulfilled.

That is when we turn a function call `add(1,2,3)` into `add(1)(2)(3)` . By using this technique, the little piece can be configured and reused with ease.

Why it’s useful?

* Currying helps you to avoid passing the same variable again and again.
* It helps to create a higher-order function. It is extremely helpful in event handling.
* Little pieces can be configured and reused with ease.

Let’s look at a simple `add` function. It accepts three operands as arguments and returns the sum of all three as the result.

```
function add(a,b,c){
 return a + b + c;
}
```

You can call it with too few (with odd results), or too many (excess arguments get ignored).

```
add(1,2,3) --> 6 
add(1,2) --> NaN
add(1,2,3,4) --> 6 //Extra parameters will be ignored.
```

How to convert an existing function to a curried version?

#### Code:

```JavaScript
function curry(fn) {
    if (fn.length <= 1) return fn;
    const generator = (...args) => {
        if (fn.length === args.length) {

            return fn(...args)
        } else {
            return (...args2) => {

                return generator(...args, ...args2)
            }
        }
    }
    return generator
}
```

#### Example:

![](https://cdn-images-1.medium.com/max/3172/1*xWlaYdGM43c5UtE-2sDbLw.png)

## Function Compose

Suppose we now need to write a function that does this:

> # Input ‘bitfish’, return ‘HELLO, BITFISH’.

As you can see, this function has two components:

* Concatenated strings
* Converts the string to uppercase

So we can write the code like this:

```
let toUpperCase = function(x) { return x.toUpperCase(); };
let hello = function(x) { return 'HELLO, ' + x; };

let greet = function(x){
    return hello(toUpperCase(x));
};
```

![](https://cdn-images-1.medium.com/max/2836/1*jK2JpMEe_O4ZSdC1c75y8g.png)

There are only two steps in this example, so the greet function does not look complex. If there were more operations, the greet function would need more nesting in it, writing code similar to `fn3(fn2(fn1(fn0(x))))`.

To do this, we can write a `compose` function exclusively for composing functions:

```
let compose = function(f,g) {
    return function(x) {
        return f(g(x));
    };
};
```

Thus, the `greet` function can be obtained through the `compose` function:

```
let greet = compose(hello, toUpperCase);
greet('kevin');
```

Using `compose` functions to combine two functions into a single function makes the code run from right to left, rather than from the inside out, making it much more readable.

But now the `compose` function can only support two parameters, and we really want the function to accept any number of parameters.

The composer function is implemented this way in the well-known open source project [underscore](https://underscorejs.org/).

![](https://cdn-images-1.medium.com/max/2372/1*UW-P_I4wRqvbneYQh5ZrUw.png)

```
function compose() {
    var args = arguments;
    var start = args.length - 1;
    return function() {
        var i = start;
        var result = args[start].apply(this, arguments);
        while (i--) result = args[i].call(this, result);
        return result;
    };
};
```

Through function compose, we can optimize the logical relationships between functions, improve the readability of the code, and facilitate future extensions and refactoring.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
