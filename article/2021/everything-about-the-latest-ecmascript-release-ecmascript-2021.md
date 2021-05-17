> * 原文地址：[Everything about the latest ECMAScript release | ECMAScript 2021](https://levelup.gitconnected.com/everything-about-the-latest-ecmascript-release-ecmascript-2021-c011e817f41a)
> * 原文作者：[Kritika Sharma](https://medium.com/@kritikasharmablog)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/everything-about-the-latest-ecmascript-release-ecmascript-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/everything-about-the-latest-ecmascript-release-ecmascript-2021.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/Hoarfroster)
> * 校对者：[KimYang](https://github.com/KimYangOfCat)、[Tong-H](https://github.com/Tong-H)

# 有关 ECMAScript 最新版本的所有信息｜ECMAScript 2021

在本文中，我们将通过一些示例代码向大家介绍 ECMAScript 2021 最新版本的功能。

![](https://cdn-images-1.medium.com/max/2000/1*ex1pND6jnzW3Hj2vjRjaDA.jpeg)

## 新的功能

### 1. String.replaceAll( )

将查找到的目标字符串的所有实例替换为所需的字符串：

```js
const fact = "JavaScript is the best web scripting language. JavaScript can be used for both front end and backend";
 
console.log(fact.replaceAll("JavaScript", "TypeScript"));

// 输出：
// "TypeScript is the best web scripting language. TypeScript can be used for both front end and backend";
```

与之前的 `replace()` 方法（仅将目标字符串的第一个匹配项替换为所需的字符串）相比：

```js
const fact = "JavaScript is the best web scripting language. JavaScript can be used for both front end and backend";
 
console.log(fact.replace("JavaScript", "TypeScript"));

// 输出：
// "TypeScript is the best web scripting language. JavaScript can be used for both front end and backend";
```

### 2. Promise.any( )

只要所提供的`Promise` 中的任何一个得到解决，`Promise.any()` 就会直接被解决，而 `Promise.all()` 则等待所有的 `Promise` 都得到解决后才会标记为解决，基本上与 `Promise.all()` 相反。

如果 **“兑现了一个 `Promise`”**：

```js
const promises = [   
          Promise.reject('错误 A'),           
          Promise.reject('错误 B'),   
          Promise.resolve('结果'), 
]; 

Promise
  .any(promises)
  .then((result) => assert.equal(result, '结果')); //true
```

如果 **“所有 `Promise` 都是被拒绝的”**：

```js
const promises = [   
          Promise.reject('错误 A'),  
          Promise.reject('错误 B'),   
          Promise.reject('错误 C'), 
]; 

Promise
  .any(promises)   
  .catch((aggregateError) => {
            assert.deepEqual(aggregateError.errors, 
            ['错误 A', '错误 B', '错误 C']); //true
   });
```

### 3. 逻辑赋值操作符

![来源: [https://exploringjs.com/impatient-js/ch_operators.html#logical-assignment-operators](https://exploringjs.com/impatient-js/ch_operators.html#logical-assignment-operators)](https://cdn-images-1.medium.com/max/2972/1*WS3OZEp_hEv0_zLaihk6-Q.png)

`a ||= b` 等同于 `a || (a = b)`（短路运算符）

为何不是 `a = a || b`？

好吧，因为对于前一个表达式，只有在 `a` 计算为 `false` 时，赋值才会被执行。因此，前者仅在必要时才会被赋值。相反，后一个表达式始终执行赋值。

`a ||= b` 的一个例子：

```js
var a = 1;  
var b = 2;  
 
a ||= b;   

console.log(a); // 1
```

`a &&= b` 的一个例子：

```js
var a = 1; 
var b = 2; 

a &&= b; 

console.log(a); // 2
```

`a ??= b` 的一个例子：

```js
var a;  
var b = 2;   

a ??= b;   

console.log(a); // 2
```

### 4. 数字分隔符

现在，我们可以使用 **下划线（`_`）** 作为数字文字和 bigInt 文字的分隔符。这将帮助开发人员提高其数字文字的可读性（“下划线”基本上会充当我们平日生活中书写数字时候所用的“逗号”（用于在不同的数字组之间提供分隔））。


```js
let budget = 1000000000000; // 可以这样写：

let budget = 1_000_000_000_000; 

console.log(budget); // 会打印正常数字：

// 输出：
// 1000000000000
```

希望本文能帮助您了解 ECMAScript 的最新版本。感谢您的阅读，如有任何疑问，请随时发表评论。

参考资料：

* [https://dev.to/faithfulojebiyi/new-features-in-ecmascript-2021-with-code-examples-302h](https://dev.to/faithfulojebiyi/new-features-in-ecmascript-2021-with-code-examples-302h)
* [https://2ality.com/2020/09/ecmascript-2021.html](https://2ality.com/2020/09/ecmascript-2021.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
