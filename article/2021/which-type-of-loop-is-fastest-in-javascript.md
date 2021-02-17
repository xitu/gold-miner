> * 原文地址：[Which type of loop is fastest in JavaScript?](https://medium.com/javascript-in-plain-english/which-type-of-loop-is-fastest-in-javascript-ec834a0f21b9)
> * 原文作者：[kushsavani](https://kushsavani.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/which-type-of-loop-is-fastest-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/which-type-of-loop-is-fastest-in-javascript.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# JavaScript 中哪一种循环更快呢？

了解哪一种 `for` 循环或迭代器适合我们的需求，防止我们犯下一些低级错误，让我们的应用程序性能受到影响。

[由 [Artem Sapegin](https://unsplash.com/@sapegin?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)](https://miro.medium.com/max/10944/0*FjGuCxH-seN1PrRF)

JavaScript 是 Web 开发的一种新的重磅引发者。JavaScript 不仅拥有着巨额的框架（如 Node.js、React、Angular 又或是 Vue 等），而且 Vanilla JavaScript 也拥有庞大的支持者。让我们一起走进 JavaScript。我们都清楚，循环一直是大多数编程语言的重要组成部分，而 JavaScript 为我们提供了许多迭代或循环值的方法。

但是问题是，我们是否真的知道哪个循环或迭代最适合我们的需求。`for` 循环有很多变形，例如 `for`、`for`（倒序）、`for` `of`、`forEach`、`for` `in`、`for` `await`。本文将涵盖此类辩论。

## **究竟哪一种循环更快？**

**答案其实是：** `for`（倒序）

这才是令人惊讶的事情！我在我的计算机上测试了一下它们，而我最后发现，也被迫接受这个现实，`for`（倒序）是所有 `for` 循环中最快的。让我分享一个例子：对一个包含超过一百万项元素的 `array` 执行循环。

**免责声明**：结果的准确性在很大程度上取决于我们运行测试的系统配置。在[此处](https://johnresig.com/blog/accuracy-of-javascript-time/)仔细了解准确性。

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

造成这样结果的原因很简单，在代码中，正序或倒序的 `for` 循环几乎花费一样的时间，仅仅相差了 0.1 毫秒。原因是，`for`（倒序）只需要计算一次起始变量 `let i = arr.length`，而在正序的 `for` 循环中，它在每次变量增加后都会检查条件 `i<arr.length`。对于小量数据来说，我们大可忽略它，但是根据译者的测试，当数据量扩大，例如十亿，千亿等的数量级，差距就显著提升。 而 `forEach` 是 `Array` 原型的一种方法。与普通的 `for` 循环相比，`forEach` 和 `for` `of` 需要花费更多的时间进行数组迭代，但值得注意的是，`for` `of` 和 `forEach` 都获取了数据，而原型并没有，因此没有可比性。

## **循环的类型，以及我们应该在何处使用它们**

### **1. For loop (forward and reverse)**

我想，所有人都应该对这个基础循环非常熟悉了。我们可以在任何我们需要的地方使用 `for` 循环，按照核定的次数运行一段代码。最基础的 `for` 循环运行最迅速的，那么我们应该就这样使用？并不然，性能不仅仅只是唯一标准，我们还需要注意代码可读性，就让我们按照符合我们应用程序的版本就行了。

### **2. `forEach`**

这个函数需要提供一个回调函数，回调函数会对每一个元素以元素和元素索引（`T`, `Int`）两个值作为参数赋予给我们提供的回调函数并执行这个函数，其中元素索引是可选的参数。

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

需要注意的是，如果我们要使用 `forEach`，我们不能使用 JavaScript 的短路运算符，即不能在每一次循环中跳过或结束循环。

### **3. `for` `of`**

`for` `of` 作为 ECMAScript 6 的标准内容，会对一个可迭代的对象（例如 `array`、`map`、`set`、`string` 等）创建一个循环，并且有一个突出的优点，即优秀的可读性。

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

需要注意的是，请不要再生成器中使用 `for` `of`，因为即便循环体结束了，在结束一次循环以后，生成器会被关闭，并且在下一次循环中再次重复生成。

### **4. `for` `in`**

`for` `in` 会在对象的所有可枚举属性上迭代指定的变量。对于每个不同的属性，`for` `in` 语句除返回数字索引外，还将返回用户定义的属性的名称。 因此，在遍历数组时最好使用带有数字索引的传统 `for` 循环。 因为 `for` `in` 语句还会迭代除数组元素之外的用户定义属性，就算我们修改了数组对象（例如添加自定义属性或方法），依然如此。

```
const details = {firstName: 'john', lastName: 'Doe'};
let fullName = '';
for (let i in details) {
    fullName += details[i] + ' '; // fullName: john doe
}
```

### `for` `of` 和 `for` `in`

`for` `of` 和 `for` `in` 之间的主要区别是它们迭代的内容。`for` `in` 循环遍历对象的属性，而 `for` `of` 循环遍历可迭代对象的值。

```
let arr= [4, 5, 6];
for (let i in arr) {
   console.log(i); // '0', '1', '2'
}
for (let i of arr) {
   console.log(i); // '4', '5', '6'
}
```

[由 [Tine Ivanič](https://unsplash.com/@tine999?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)](https://miro.medium.com/max/12000/0*E9FPH2LFeFnTGWF5)

## **Conclusion**

- `for` 最快，但在可读性上比较差
- `foreach` 比较快，能够控制内容
- `for...of` 比较慢，但香
- `for...in` 比较慢，并且太不方便使用 最后，让我们提供一条明智的建议 —— 在性能差距不大或对性能不敏感的代码上，优先看中可读和易写。毕竟当我们开发复杂的结构程序时，代码的可读性是必不可少的。当然我们也应该专注于性能，尽量避免在代码中添加不必要的多余装饰，防止增加应用程序性能。祝你编码愉快。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
