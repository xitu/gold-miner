> * 原文地址：[5 Tips to Write Better Conditionals in JavaScript](https://scotch.io/tutorials/5-tips-to-write-better-conditionals-in-javascript)
> * 原文作者：[Jecelyn Yeen](https://scotch.io/@jecelyn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-tips-to-write-better-conditionals-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-tips-to-write-better-conditionals-in-javascript.md)
> * 译者：[Hopsken](https://blog.hopsken.com)
> * 校对者：[ThomasWhyne](https://github.com/ThomasWhyne) [Park-ma](https://github.com/Park-ma)

# 五个小技巧让你写出更好的 JavaScript 条件语句

![](https://scotch-res.cloudinary.com/image/upload/dpr_1,w_1050,q_auto:good,f_auto/v1536994013/udpahiv8rqlemvz0x3wc.png)

在使用 JavaScript 时，我们常常要写不少的条件语句。这里有五个小技巧，可以让你写出更干净、漂亮的条件语句。

## 1. 使用 Array.includes 来处理多重条件

举个栗子 🌰：

```javascript
// 条件语句
function test(fruit) {
  if (fruit == 'apple' || fruit == 'strawberry') {
    console.log('red');
  }
}
```

乍一看，这么写似乎没什么大问题。然而，如果我们想要匹配更多的红色水果呢，比方说『樱桃』和『蔓越莓』？我们是不是得用更多的 `||` 来扩展这条语句？

我们可以使用 `Array.includes`[(Array.includes)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes) 重写以上条件句。

```javascript
function test(fruit) {
  // 把条件提取到数组中
  const redFruits = ['apple', 'strawberry', 'cherry', 'cranberries'];

  if (redFruits.includes(fruit)) {
    console.log('red');
  }
}
```

我们把`红色的水果`（条件）都提取到一个数组中，这使得我们的代码看起来更加整洁。

## 2. 少写嵌套，尽早返回

让我们为之前的例子添加两个条件：

*   如果没有提供水果，抛出错误。
*   如果该水果的数量大于 10，将其打印出来。

```javascript
function test(fruit, quantity) {
  const redFruits = ['apple', 'strawberry', 'cherry', 'cranberries'];

  // 条件 1：fruit 必须有值
  if (fruit) {
    // 条件 2：必须为红色
    if (redFruits.includes(fruit)) {
      console.log('red');

      // 条件 3：必须是大量存在
      if (quantity > 10) {
        console.log('big quantity');
      }
    }
  } else {
    throw new Error('No fruit!');
  }
}

// 测试结果
test(null); // 报错：No fruits
test('apple'); // 打印：red
test('apple', 20); // 打印：red，big quantity
```

让我们来仔细看看上面的代码，我们有：
*   1 个 if/else 语句来筛选无效的条件
*   3 层 if 语句嵌套（条件 1，2 & 3）

就我个人而言，我遵循的一个总的规则是**当发现无效条件时尽早返回**。

```javascript
/_ 当发现无效条件时尽早返回 _/

function test(fruit, quantity) {
  const redFruits = ['apple', 'strawberry', 'cherry', 'cranberries'];

  // 条件 1：尽早抛出错误
  if (!fruit) throw new Error('No fruit!');

  // 条件2：必须为红色
  if (redFruits.includes(fruit)) {
    console.log('red');

    // 条件 3：必须是大量存在
    if (quantity > 10) {
      console.log('big quantity');
    }
  }
}
```

如此一来，我们就少写了一层嵌套。这是种很好的代码风格，尤其是在 if 语句很长的时候（试想一下，你得滚动到底部才能知道那儿还有个 else 语句，是不是有点不爽）。

如果反转一下条件，我们还可以进一步地减少嵌套层级。注意观察下面的条件 2 语句，看看是如何做到这点的：
```javascript
/_ 当发现无效条件时尽早返回 _/

function test(fruit, quantity) {
  const redFruits = ['apple', 'strawberry', 'cherry', 'cranberries'];

  if (!fruit) throw new Error('No fruit!'); // 条件 1：尽早抛出错误
  if (!redFruits.includes(fruit)) return; // 条件 2：当 fruit 不是红色的时候，直接返回

  console.log('red');

  // 条件 3：必须是大量存在
  if (quantity > 10) {
    console.log('big quantity');
  }
}
```

通过反转条件 2 的条件，现在我们的代码已经没有嵌套了。当我们代码的逻辑链很长，并且希望当某个条件不满足时不再执行之后流程时，这个技巧会很好用。

然而，并没有任何**硬性规则**要求你这么做。这取决于你自己，对你而言，这个版本的代码（没有嵌套）是否要比之前那个版本（条件 2 有嵌套）的更好、可读性更强？

是我的话，我会选择前一个版本（条件 2 有嵌套）。原因在于：

*   这样的代码比较简短和直白，一个嵌套的 if 使得结构更加清晰。
*   条件反转会导致更多的思考过程（增加认知负担）。

因此，**始终追求更少的嵌套，更早地返回，但是不要过度**。感兴趣的话，这里有篇关于这个问题的文章以及 StackOverflow 上的讨论：

*   [Avoid Else, Return Early](http://blog.timoxley.com/post/47041269194/avoid-else-return-early) by Tim Oxley
*   [StackOverflow discussion](https://softwareengineering.stackexchange.com/questions/18454/should-i-return-from-a-function-early-or-use-an-if-statement) on if/else coding style

## 3. 使用函数默认参数和解构

我猜你也许很熟悉以下的代码，在 JavaScript 中我们经常需要检查 `null` / `undefined` 并赋予默认值：

```javascript
function test(fruit, quantity) {
  if (!fruit) return;
  const q = quantity || 1; // 如果没有提供 quantity，默认为 1

  console.log(`We have ${q} ${fruit}!`);
}

//测试结果
test('banana'); // We have 1 banana!
test('apple', 2); // We have 2 apple!
```

事实上，我们可以通过函数的默认参数来去掉变量 `q`。

```javascript
function test(fruit, quantity = 1) { // 如果没有提供 quantity，默认为 1
  if (!fruit) return;
  console.log(`We have ${quantity} ${fruit}!`);
}

//测试结果
test('banana'); // We have 1 banana!
test('apple', 2); // We have 2 apple!
```

是不是更加简单、直白了？请注意，所有的函数参数都可以有其[默认值](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Default_parameters)。举例来说，我们同样可以为 `fruit` 赋予一个默认值：`function test(fruit = 'unknown', quantity = 1)`。

那么如果 `fruit` 是一个对象（Object）呢？我们还可以使用默认参数吗？

```javascript
function test(fruit) { 
  // 如果有值，则打印出来
  if (fruit && fruit.name)  {
    console.log (fruit.name);
  } else {
    console.log('unknown');
  }
}

//测试结果
test(undefined); // unknown
test({ }); // unknown
test({ name: 'apple', color: 'red' }); // apple
```

观察上面的例子，当水果名称属性存在时，我们希望将其打印出来，否则打印『unknown』。我们可以通过默认参数和解构赋值的方法来避免写出 `fruit && fruit.name` 这种条件。

```javascript
// 解构 —— 只得到 name 属性
// 默认参数为空对象 {}
function test({name} = {}) {
  console.log (name || 'unknown');
}

//测试结果
test(undefined); // unknown
test({ }); // unknown
test({ name: 'apple', color: 'red' }); // apple
```

既然我们只需要 fruit 的 `name` 属性，我们可以使用 `{name}` 来将其解构出来，之后我们就可以在代码中使用 `name` 变量来取代 `fruit.name`。

我们还使用 `{}` 作为其默认值。如果我们不这么做的话，在执行 `test(undefined)` 时，你会得到一个错误 `Cannot destructure property name of 'undefined' or 'null'.`，因为 `undefined` 上并没有 `name` 属性。（译者注：这里不太准确，其实因为解构只适用于对象（Object），而不是因为`undefined` 上并没有 `name` 属性（空对象上也没有）。参考[解构赋值 - MDN](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)）

如果你不介意使用第三方库的话，有一些方法可以帮助减少空值（null）检查：

*   使用 [Lodash get](https://lodash.com/docs/4.17.10#get) 函数
*   使用 Facebook 开源的 [idx](https://github.com/facebookincubator/idx) 库（需搭配 Babeljs）

这里有一个使用 Lodash 的例子：

```javascript
//  使用 lodash 库提供的 _ 方法
function test(fruit) {
  console.log(_.get(fruit, 'name', 'unknown'); // 获取属性 name 的值，如果没有，设为默认值 unknown
}

//测试结果
test(undefined); // unknown
test({ }); // unknown
test({ name: 'apple', color: 'red' }); // apple
```

你可以在[这里](http://jsbin.com/bopovajiye/edit?js,console)运行演示代码。另外，如果你偏爱函数式编程（FP），你可以选择使用 [Lodash fp](https://github.com/lodash/lodash/wiki/FP-Guide)——函数式版本的 Lodash（方法名变为 `get` 或 `getOr`）。

## 4. 相较于 switch，Map / Object 也许是更好的选择

让我们看下面的例子，我们想要根据颜色打印出各种水果：

```javascript
function test(color) {
  // 使用 switch case 来找到对应颜色的水果
  switch (color) {
    case 'red':
      return ['apple', 'strawberry'];
    case 'yellow':
      return ['banana', 'pineapple'];
    case 'purple':
      return ['grape', 'plum'];
    default:
      return [];
  }
}

//测试结果
test(null); // []
test('yellow'); // ['banana', 'pineapple']
```

上面的代码看上去并没有错，但是就我个人而言，它看上去很冗长。同样的结果可以通过对象字面量来实现，语法也更加简洁：

```javascript
// 使用对象字面量来找到对应颜色的水果
  const fruitColor = {
    red: ['apple', 'strawberry'],
    yellow: ['banana', 'pineapple'],
    purple: ['grape', 'plum']
  };

function test(color) {
  return fruitColor[color] || [];
}
```

或者，你也可以使用 [Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) 来实现同样的效果：

```javascript
// 使用 Map 来找到对应颜色的水果
  const fruitColor = new Map()
    .set('red', ['apple', 'strawberry'])
    .set('yellow', ['banana', 'pineapple'])
    .set('purple', ['grape', 'plum']);

function test(color) {
  return fruitColor.get(color) || [];
}
```

[Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) 是 ES2015 引入的新的对象类型，允许你存放键值对。

**那是不是说我们应该禁止使用 switch 语句？** 别把自己限制住。我自己会在任何可能的时候使用对象字面量，但是这并不是说我就不用 switch，这得视场景而定。

Todd Motto 有一篇[文章](https://toddmotto.com/deprecating-the-switch-statement-for-object-literals/)深入讨论了 switch 语句和对象字面量，你也许会想看看。

### 懒人版：重构语法

就以上的例子，事实上我们可以通过重构我们的代码，使用 `Array.filter` 实现同样的效果。

```javascript
 const fruits = [
    { name: 'apple', color: 'red' }, 
    { name: 'strawberry', color: 'red' }, 
    { name: 'banana', color: 'yellow' }, 
    { name: 'pineapple', color: 'yellow' }, 
    { name: 'grape', color: 'purple' }, 
    { name: 'plum', color: 'purple' }
];

function test(color) {
  // 使用 Array filter 来找到对应颜色的水果

  return fruits.filter(f => f.color == color);
}
```

解决问题的方法永远不只一种。对于这个例子我们展示了四种实现方法。Coding is fun！

## 5. 使用 Array.every 和 Array.some 来处理全部/部分满足条件

最后一个小技巧更多地是关于使用新的（也不是很新了）JavaScript 数组函数来减少代码行数。观察以下的代码，我们想要检查是否所有的水果都是红色的：

```javascript
const fruits = [
    { name: 'apple', color: 'red' },
    { name: 'banana', color: 'yellow' },
    { name: 'grape', color: 'purple' }
  ];

function test() {
  let isAllRed = true;

  // 条件：所有的水果都必须是红色
  for (let f of fruits) {
    if (!isAllRed) break;
    isAllRed = (f.color == 'red');
  }

  console.log(isAllRed); // false
}
```

这段代码也太长了！我们可以通过 `Array.every` 来缩减代码：

```javascript
const fruits = [
    { name: 'apple', color: 'red' },
    { name: 'banana', color: 'yellow' },
    { name: 'grape', color: 'purple' }
  ];

function test() {
  // 条件：（简短形式）所有的水果都必须是红色
  const isAllRed = fruits.every(f => f.color == 'red');

  console.log(isAllRed); // false
}
```

清晰多了对吧？类似的，如果我们想要检查是否有至少一个水果是红色的，我们可以使用 `Array.some` 仅用一行代码就实现出来。

```javascript
const fruits = [
    { name: 'apple', color: 'red' },
    { name: 'banana', color: 'yellow' },
    { name: 'grape', color: 'purple' }
];

function test() {
  // 条件：至少一个水果是红色的
  const isAnyRed = fruits.some(f => f.color == 'red');

  console.log(isAnyRed); // true
}
```

## 总结

让我们一起写出可读性更高的代码吧。希望这篇文章能给你们带来一些帮助。

就是这样啦。Happy coding！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
