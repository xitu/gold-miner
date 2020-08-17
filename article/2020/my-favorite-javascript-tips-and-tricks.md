> * 原文地址：[My Favorite JavaScript Tips and Tricks](https://blog.greenroots.info/my-favorite-javascript-tips-and-tricks-ckd60i4cq011em8s16uobcelc)
> * 原文作者：[Tapas Adhikary](https://hashnode.com/@atapas)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/my-favorite-javascript-tips-and-tricks.md](https://github.com/xitu/gold-miner/blob/master/article/2020/my-favorite-javascript-tips-and-tricks.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[tanglie1993](https://github.com/tanglie1993) 和 [Chorer](https://github.com/Chorer)

# 我常用的 JavaScript 编程技巧

![image](https://user-images.githubusercontent.com/5164225/89246151-0dbc1300-d63d-11ea-982e-fa61dd13b7d9.png)

## 本文目的

大多数编程语言都足够开放，以允许程序员以多种方式得到类似的结果。JavaScript 也是如此，使用 JavaScript，我们通常可以通过多种方法来达到相似的结果，虽然有时会造成混淆。

其中一些用法比其他方法要好，而这些就是我要分享的。我将在本文中一一列举，我敢肯定，您在阅读本文时会发现，在很多地方您和我的做法是相同的。

## 1. 使用模板字符串

使用`+`运算符拼接字符串来构建有意义的字符串，这是过时的做法。此外，将字符串与动态值（或表达式）连接可能会导致计算或表达错误。

```js
let name = 'Charlse';
let place = 'India';
let isPrime = bit => {
  return (bit === 'P' ? 'Prime' : 'Nom-Prime');
}

// 使用`+`运算符的字符串连接
let messageConcat = 'Mr. ' + name + ' is from ' + place + '. He is a' + ' ' + isPrime('P') + ' member.'
```

模板字面量（或模板字符串）允许嵌入表达式。它具有独特的语法，该字符串必须用反引号（``）括起来。模板字符串提供了可以包含动态值的占位符，以美元符号和大括号标记（${expression}）。

以下是一个演示它的例子，

```js
let name = 'Charlse';
let place = 'India';
let isPrime = bit => {
  return (bit === 'P' ? 'Prime' : 'Nom-Prime');
}

// 使用模板字符串
let messageTemplateStr = `Mr. ${name} is from ${place}. He is a ${isPrime('P')} member.`
console.log(messageTemplateStr);
```

## 2. isInteger

有一种更简洁的方法可以知道值是否为整数。JavaScript 的 `Number` API 提供了名为 `isInteger()` 的方法来实现此目的。这是非常有用的，最好了解一下。

```js
let mynum = 123;
let mynumStr = "123";

console.log(`${mynum} is a number?`, Number.isInteger(mynum));
console.log(`${mynumStr} is a number?`, Number.isInteger(mynumStr));
```

输出结果：

![2.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595930285107/RiLxixUxC.png?auto=format&q=60)

## 3. 值为数字

您是否曾经注意到，即使输入框的类型为数字，`event.target.value`仍始终返回字符串类型的值？

请参见下面的示例。我们有一个简单的数字类型的文本框。这意味着它仅接受数字作为输入，它具有事件处理程序来处理按键事件。

```html
<input type='number' onkeyup="trackChange(event)" />
```

在事件处理程序中，我们使用`event.target.value`取出值，但是它返回一个字符串类型值。现在，我将不得不将其解析为整数。如果输入框接受浮点数（例如 16.56）怎么办？使用 `parseFloat()` 然后呢？啊，我不得不面对各种各样的困惑和额外的工作！

```js
function trackChange(event) {
   let value = event.target.value;
   console.log(`is ${value} a number?`, Number.isInteger(value));
}
```

请改用`event.target.valueAsNumber`，它以数字形式返回值。

```js
let valueAsNumber = event.target.valueAsNumber;
console.log(`is ${value} a number?`, Number.isInteger(valueAsNumber));
```

![3.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595935455526/Tv1sEFRxe.png?auto=format&q=60)

## 4. 使用 && 运算符化简表达式

让我们考虑一个具有布尔值和函数的情况。

```js
let isPrime = true;
const startWatching = () => {
    console.log('Started Watching!');
}
```

像下面这样，通过检查布尔值来确定是否调用函数，代码太多了。

```js
if (isPrime) {
    startWatching();
}
```

能否通过 AND（&&）运算符使用简写形式？是的，完全可以避免使用 if 语句。酷吧！

```js
isPrime && startWatching();
```

## 5. 使用 || 运算符处理默认值

如果您想为变量设置默认值，可以使用 OR（||）运算符轻松实现。

```js
let person = {name: 'Jack'};
let age = person.age || 35; // 如果 age 未定义，则将值设置为 35
console.log(`Age of ${person.name} is ${age}`);
```

## 6. 获取随机项

生成随机数或从数组中获取随机项是非常有用且方便的方法。我已经在我的许多项目中多次看到它们了。

从数组中获取随机项，

```js
let planets = ['Mercury ', 'Mars', 'Venus', 'Earth', 'Neptune', 'Uranus', 'Saturn', 'Jupiter'];
let randomPlanet = planets[Math.floor(Math.random() * planets.length)];
console.log('Random Planet', randomPlanet);
```

通过指定最小值和最大值，在一个范围内生成一个随机数，

```js
let getRandom = (min, max) => {
    return Math.round(Math.random() * (max - min) + min);
}
console.log('Get random', getRandom(0, 10));
```

## 7. 函数默认参数

在JavaScript中，函数实参（或形参）就像该函数的局部变量一样。调用函数时，您可以传递也可以不传递值。如果您不为参数传递值，则该值将是`undefined`，并且可能会导致一些多余的副作用。

有一种在定义参数时将默认值传递给函数参数的简单方法。在以下示例中，我们将默认值`Hello`传递给`greetings`函数的参数`message`。

```js
let greetings = (name, message='Hello,') => {
    return `${message} ${name}`;
}

console.log(greetings('Jack'));
console.log(greetings('Jack', 'Hola!'));

```

## 8. 必需的函数参数

基于默认参数的特性，我们可以将参数作为必需参数。首先定义一个函数以使用错误消息抛出错误，

```js
let isRequired = () => {
    throw new Error('This is a mandatory parameter.');
}
```

然后将函数作为必需参数的默认值。请记住，在调用函数时如果为参数传递值，那么默认值会被忽略。但是，如果参数值为“undefined”，则默认值会被使用。

```js
let greetings = (name=isRequired(), message='Hello,') => {
    return `${message} ${name}`;
}
console.log(greetings());
```

在上面的代码中，`name`将是未定义的，因此将会尝试使用默认值，即 `isRequired()` 函数。 它将引发如下所示的错误：

![8.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595930079306/ossRyuA7X.png?auto=format&q=60)

## 9. 逗号运算符

当我意识到逗号(`,`) 是一个单独的运算符，并且我此前从未注意到时，我感到很惊讶。我已经在代码中使用了大量逗号，但是从未意识到它的其它用途。

运算符用于从左到右计算其每个操作数，并返回最后一个操作数的值。

```js
let count = 1;
let ret = (count++, count);
console.log(ret);
```

在上面的示例中，变量`ret`的值将为 2。同理，下面的代码将在控制台中输出值 32 记录到控制台中。

```js
let val = (12, 32);
console.log(val);
```

我们在哪里使用它？有什么想法吗？逗号 (`,`)运算符最常见的用法是在 for 循环中提供多个参数。

```js
for (var i = 0, j = 50; i <= 50; i++, j--)
```

## 10. 合并多个对象

您可能需要将两个对象合并在一起，并创建一个更好的、内容更丰富的对象来使用。为此，您可以使用扩展运算符`...`（对的，就是三个点！）。

分别考虑 `emp` 和 `job` 这两个对象，

```js
let emp = {
 'id': 'E_01',
 'name': 'Jack',
 'age': 32,
 'addr': 'India'
};

let job = {
 'title': 'Software Dev',
  'location': 'Paris'
};
```

使用扩展运算符将它们合并为

```js
// spread operator
let merged = {...emp, ...job};
console.log('Spread merged', merged);
```

还有另一种实现合并的方法。你可以像下面这样使用 `Object.assign()`：

```js
console.log('Object assign', Object.assign({}, emp, job));
```

输出结果：

![10.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595930544621/2jCCxCSnz.png?auto=format&q=60)

注意，扩展运算符和 `Object.assign` 都执行浅合并。在浅合并中，第一个对象的属性将被第二个对象的相同属性值覆盖。

要进行深度合并，可以考虑使用 [lodash](https://lodash.com/) 中的 `_merge`。

## 11. 解构

将数组元素和对象属性分解为变量的技术称为“解构”。让我们看几个例子，

### 数组

在这里，我们有一系列的表情符号，

```js
let emojis = ['🔥', '⏲️', '🏆', '🍉'];
```

为了解构，我们将使用以下语法，

```js
let [fire, clock, , watermelon] = emojis;
```

这与`let fire = emojis [0];`相同，但具有更大的灵活性。您是否注意到，我只是在奖杯表情符号的位置上使用了空格而忽略了它？那么，这将输出什么呢？

```js
console.log(fire, clock, watermelon);
```

输出结果：

![11.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595931639636/TXaeEwgGq.png?auto=format&q=60)

让我在这里再介绍一个叫做“rest”运算符的东西。如果您想对数组进行解构，从而将一个或多个项目分配给变量并将其余部分暂放在另一个数组中，就可以使用`...rest`来完成，如下所示。

```js
let [fruit, ...rest] = emojis;
console.log(rest);
```

输出结果:

![11.a.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595932001526/GdWuvDoP8.png?auto=format&q=60)

### 对象

像数组一样，我们也可以解构对象。

```js
let shape = {
  name: 'rect',
  sides: 4,
  height: 300,
  width: 500
};
```

像下面这样进行解构，我们可以把对象的 `name` 属性和 `sides` 属性赋值给两个变量，而其余的属性则存放在另一个对象中。

```js
let {name, sides, ...restObj} = shape;
console.log(name, sides);
console.log(restObj);
```

输出结果：

![11.b.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595932176160/97vWj-QQl.png?auto=format&q=60)

阅读有关此主题的更多信息 [from here](https://javascript.info/destructuring-assignment).

## 12. 交换变量

现在，使用我们刚刚学习的解构，变量交换将会变得非常容易。

```js
let fire = '🔥';
let fruit = '🍉';

[fruit, fire] = [fire, fruit];
console.log(fire, fruit);
```

## 13. isArray

确定输入是否为数组的另一种有用方法。

```js
let emojis = ['🔥', '⏲️', '🏆', '🍉'];
console.log(Array.isArray(emojis));

let obj = {};
console.log(Array.isArray(obj));
```

## 14. undefined 和 null

`undefined`指的是还没有给变量定义值，但已经声明了该变量。

`null`本身是一个空且不存在的值，必须将其显式赋值给变量。

`undefined`和`null`并不严格相等，

```js
undefined === null // false
```

阅读有关此主题的更多信息 [from here](https://stackoverflow.com/questions/5076944/what-is-the-difference-between-null-and-undefined-in-javascript).

## 15. 获取查询参数

`window.location`对象具有许多实用方法和属性。使用这些属性和方法，我们可以从浏览器 URL 中获取有关协议、主机、端口、域等的信息。

下面是我发现的一个非常有用的属性：

```js
window.location.search
```

`search`属性从位置 url 返回查询字符串。以这个 url 为例：`https：//tapasadhiary.com？project = js`。 `location.search`将返回`？project = js`

我们可以使用另一个名为`URLSearchParams`的有用接口以及`location.search`来获取查询参数的值。

```js
let project = new URLSearchParams(location.search).get('project');
```

输出结果：`js`

阅读有关此主题的更多信息 [from here](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams).

# 本文并未结束

JavaScript 的编程技巧远远不止这些，我也计划在学到一些新的技巧时，将它们作为示例更新到 GitHub 项目 [https://github.com/atapas/js-tips-tricks](https://github.com/atapas/js-tips-tricks)



> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
