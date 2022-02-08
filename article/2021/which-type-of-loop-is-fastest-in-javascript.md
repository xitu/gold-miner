> * 原文地址：[Which type of loop is fastest in JavaScript?](https://medium.com/javascript-in-plain-english/which-type-of-loop-is-fastest-in-javascript-ec834a0f21b9)
> * 原文作者：[kushsavani](https://kushsavani.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/which-type-of-loop-is-fastest-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/which-type-of-loop-is-fastest-in-javascript.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Chorer](https://github.com/Chorer)、[HumanBeing](https://github.com/HumanBeingXenon)、[yoghurt](https://juejin.cn/user/2840793777440296)

# JavaScript 中哪一种循环最快呢？

了解哪一种 `for` 循环或迭代器适合我们的需求，防止我们犯下一些影响应用性能的低级错误。

![由 [Artem Sapegin](https://unsplash.com/@sapegin?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)](https://miro.medium.com/max/10944/0*FjGuCxH-seN1PrRF)

JavaScript 是 Web 开发领域的“常青树”。无论是 JavaScript 框架（如 Node.js、React、Angular、Vue 等），还是原生 JavaScript，都拥有非常庞大的粉丝基础。我们来谈谈现代 JavaScript 吧。循环一直是大多数编程语言的重要组成部分，而现代 JavaScript 为我们提供了许多迭代或循环值的方法。

但问题在于，我们是否真的知道哪种循环或迭代最适合我们的需求。`for` 循环有很多变形，例如 `for`、`for`（倒序）、`for…of`、`forEach`、`for…in`、`for…await`。本文将围绕这些展开讨论。

## **究竟哪一种循环更快？**

**答案其实是：** `for`（倒序）

最让我感到惊讶的事情是，当我在本地计算机上进行测试之后，我不得不接受 `for`（倒序）是所有 `for` 循环中最快的这一事实。下面我会举个对一个包含超过一百万项元素的数组执行一次循环遍历的例子。

**声明**：`console.time()` 结果的准确度在很大程度上取决于我们运行测试的系统配置。你可以在[此处](https://johnresig.com/blog/accuracy-of-javascript-time/)对准确度作进一步了解。

```
const million = 1000000; 
const arr = Array(million);
console.time('⏳');
for (let i = arr.length; i > 0; i--) {} // for(倒序) 	:- 1.5ms
for (let i = 0; i < arr.length; i++) {} // for          :- 1.6ms
arr.forEach(v => v)                     // foreach      :- 2.1ms
for (const v of arr) {}                 // for...of     :- 11.7ms
console.timeEnd('⏳');
```

造成这样结果的原因很简单，在代码中，正序和倒序的 `for` 循环几乎花费一样的时间，仅仅相差了 0.1 毫秒。原因是，`for`（倒序）只需要计算一次起始变量 `let i = arr.length`，而在正序的 `for` 循环中，它在每次变量增加后都会检查条件 `i<arr.length`。这个细微的差别不是很重要，你可以忽略它。（译者注：在数据量小或对时间不敏感的代码上，我们大可忽略它，但是根据译者的测试，当数据量扩大，例如十亿，千亿等的数量级，差距就显著提升，我们就需要考虑时间对应用程序性能的影响了。）

而 `forEach` 是 `Array` 原型的一个方法，与普通的 `for` 循环相比，`forEach` 和 `for…of` 需要花费更多的时间进行数组迭代。（译者注：但值得注意的是，`for…of` 和 `forEach` 都从对象中获取了数据，而原型并没有，因此没有可比性。）

## **循环的类型，以及我们应该在何处使用它们**

### **1. For 循环（正序和倒序）**

我想，也许大家都应该对这个基础循环非常熟悉了。我们可以在任何我们需要的地方使用 `for` 循环，按照核定的次数运行一段代码。最基础的 `for` 循环运行最迅速的，那我们每一次都应该使用它，对吗？并不然，性能不仅仅只是唯一尺度，代码可读性往往更加重要，就让我们选择适合我们应用程序的变形即可。

### **2. `forEach`**

这个方法需要接受一个回调函数作为输入参数，遍历数组的每一个元素，并执行我们的回调函数（以元素本身和它的索引（可选参数）作为参数赋予给回调函数）。`forEach` 还允许在回调函数中使用一个可选参数 `this`。

```
const things = ['have', 'fun', 'coding'];
const callbackFun = (item, idex) => {
    console.log(`${item} - ${index}`);
}
things.foreach(callbackFun); 
/* 输出 	have - 0
      	fun - 1
      	coding - 2 */
```

需要注意的是，如果我们要使用 `forEach`，我们不能使用 JavaScript 的短路运算符（||、&&……），即不能在每一次循环中跳过或结束循环。

### **3. `for…of`**

`for…of` 是在 ES6（ECMAScript 6）中实现标准化的。它会对一个可迭代的对象（例如 `array`、`map`、`set`、`string` 等）创建一个循环，并且有一个突出的优点，即优秀的可读性。

```
const arr = [3, 5, 7];
const str = 'hello';
for (let i of arr) {
   console.log(i); // 输出 3, 5, 7
}
for (let i of str) {
   console.log(i); // 输出 'h', 'e', 'l', 'l', 'o'
}
```

需要注意的是，请不要在生成器中使用 `for……of`，即便 `for……of` 循环提前终止。在退出循环后，生成器被关闭，并尝试再次迭代，不会产生任何进一步的结果。

### **4. `for` `in`**

`for…in` 会在对象的所有可枚举属性上迭代指定的变量。对于每个不同的属性，`for…in` 语句除返回数字索引外，还将返回用户定义的属性的名称。
因此，在遍历数组时最好使用带有数字索引的传统 `for` 循环。 因为 `for…in` 语句还会迭代除数组元素之外的用户定义属性，就算我们修改了数组对象（例如添加自定义属性或方法），依然如此。

```
const details = {firstName: 'john', lastName: 'Doe'};
let fullName = '';
for (let i in details) {
    fullName += details[i] + ' '; // fullName: john doe
}
```

### `for…of` 和 `for…in`

`for…of` 和 `for…in` 之间的主要区别是它们迭代的内容。`for…in` 循环遍历对象的属性，而 `for…of` 循环遍历可迭代对象的值。

```
let arr= [4, 5, 6];
for (let i in arr) {
   console.log(i); // '0', '1', '2'
}
for (let i of arr) {
   console.log(i); // '4', '5', '6'
}
```

![由 [Tine Ivanič](https://unsplash.com/@tine999?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)](https://miro.medium.com/max/12000/0*E9FPH2LFeFnTGWF5)

### **结论**

- `for` 最快，但可读性比较差
- `foreach` 比较快，能够控制内容
- `for...of` 比较慢，但香
- `for...in` 比较慢，没那么方便

最后，给你一条明智的建议 —— 优先考虑可读性。尤其是当我们开发复杂的结构程序时，更需要这样做。当然，我们也应该专注于性能。尽量避免增添不必要的、多余的花哨代码，因为这有时可能对你的程序性能造成严重影响。祝你编码愉快。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
