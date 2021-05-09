> * 原文地址：[Everything about the latest ECMAScript release | ECMAScript 2021](https://levelup.gitconnected.com/everything-about-the-latest-ecmascript-release-ecmascript-2021-c011e817f41a)
> * 原文作者：[Kritika Sharma](https://medium.com/@kritikasharmablog)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/everything-about-the-latest-ecmascript-release-ecmascript-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/everything-about-the-latest-ecmascript-release-ecmascript-2021.md)
> * 译者：
> * 校对者：

# Everything about the latest ECMAScript release | ECMAScript 2021

In this article, we will be going through the new features available in the latest version of ECMAScript 2021 with some coding examples.

![](https://cdn-images-1.medium.com/max/2000/1*ex1pND6jnzW3Hj2vjRjaDA.jpeg)

## New Features

#### 1. String.replaceAll( )

Replaces all instances of the target string with the desired string.

```js
const fact = "Javascript is the best web scripting language. Javascript can be used for both front end and backend";
 
console.log(fact.replaceAll("Javascript", "Typescript"));

Result:
"Typescript is the best web scripting language. Typescript can be used for both front end and backend";
```

In comparison with the previous replace( ) method which only replaces the first occurrence of the target string with the desired string.

```js
const fact = "Javascript is the best web scripting language. Javascript can be used for both front end and backend";
 
console.log(fact.replace("Javascript", "Typescript"));

Result:
"Typescript is the best web scripting language. Javascript can be used for both front end and backend";
```

#### 2. Promise.any( )

`Promise.any()` resolves as soon as any one of the supplied promises is resolved, unlike `promise.all()` which waits for all the promises to resolve. It's basically the opposite of `Promise.all()`.

This is what happens if **one Promise is fulfilled**:

```js
const promises = [   
          Promise.reject('ERROR A'),           
          Promise.reject('ERROR B'),   
          Promise.resolve('result'), 
]; 

Promise
  .any(promises)
  .then((result) => assert.equal(result, 'result')); //true
```

This is what happens if all Promises are **rejected**:

```js
const promises = [   
          Promise.reject('ERROR A'),  
          Promise.reject('ERROR B'),   
          Promise.reject('ERROR C'), 
]; 

Promise
  .any(promises)   
  .catch((aggregateError) => {
            assert.deepEqual(aggregateError.errors, 
            ['ERROR A', 'ERROR B', 'ERROR C']); //true
   });
```

#### 3. Logical Assignment Operator

![Source: [https://exploringjs.com/impatient-js/ch_operators.html#logical-assignment-operators](https://exploringjs.com/impatient-js/ch_operators.html#logical-assignment-operators)](https://cdn-images-1.medium.com/max/2972/1*WS3OZEp_hEv0_zLaihk6-Q.png)

`a ||= b` is equivalent to `a || (a = b)`. (Short-circuiting).

Why not to this expression? `a = a || b`

Well, because for the former expression the assignment is only evaluated if `a` evaluates to `false`. Therefore, the assignment is only performed if it's necessary. In contrast, the latter expression always performs an assignment.

Example `a ||= b`:

```js
var a = 1;  
var b = 2;  
 
a ||= b;   

console.log(a); // 1
```

Example `a &&= b`:

```js
var a = 1; 
var b = 2; 

a &&= b; 

console.log(a); // 2
```

Example `a ??= b`:

```js
var a;  
var b = 2;   

a ??= b;   

console.log(a); // 2
```

#### 4. Numerical Separators

We can now use **Underscores (`_`)** as separators in number literals and bigInt literals. It will help developers to make their numeric literals more readable, as the **underscore** will basically act as a **comma** (used to provide separation between the different groups of digits) when we write numbers in our day-to-day lives.

```js
let budget = 1000000000000 //can be written as the following..

let budget = 1_000_000_000_000; 

console.log(budget); //printed as regular numeric literal.

result:
1000000000000
```

I hope this article helped you to understand the latest ECMAScript release. Thanks for reading. If you have any questions, feel free to leave a comment.

Resources:

* [https://dev.to/faithfulojebiyi/new-features-in-ecmascript-2021-with-code-examples-302h](https://dev.to/faithfulojebiyi/new-features-in-ecmascript-2021-with-code-examples-302h)
* [https://2ality.com/2020/09/ecmascript-2021.html](https://2ality.com/2020/09/ecmascript-2021.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
