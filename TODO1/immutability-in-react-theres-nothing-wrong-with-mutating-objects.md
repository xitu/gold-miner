> * 原文地址：[Immutability in React: There’s nothing wrong with mutating objects](https://blog.logrocket.com/immutability-in-react-ebe55253a1cc)
> * 原文作者：[Esteban Herrera](https://blog.logrocket.com/@eh3rrera?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/immutability-in-react-theres-nothing-wrong-with-mutating-objects.md](https://github.com/xitu/gold-miner/blob/master/TODO1/immutability-in-react-theres-nothing-wrong-with-mutating-objects.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[MechanicianW](https://github.com/MechanicianW) [goldEli](https://github.com/goldEli)

# React 中的 Immutability：可变对象并没有什么问题

![](https://cdn-images-1.medium.com/max/800/1*TPF5q9zVHp944Ub-xtU7MQ.jpeg)

[图源](https://www.geeknative.com/39314/mutate-the-t-shirt/)

当开始使用 React 时，你要学习的第一件事就是不应该改变（修改）一个 数组：

```
// bad, push 操作会修改原数组
items.push(newItem);

// good, concat 操作不会修改原数组
const newItems = items.concat([newItem]);
```

但是

你知道为什么要这么做吗？

可变对象有什么不对吗？

![](https://cdn-images-1.medium.com/max/800/0*88XOllaZvI-HBP8o.)

没什么不对的，真的。可变对象没有任何问题。

当然，在涉及并发情况时会有问题。但这是最简单的开发方法，和编程中许多问题一样，这是一种折衷。

函数式编程和 immutability 等概念很流行，都是很酷的主题。但就 React 而言，immutability 会给你一些实际的好处。不仅仅是因为流行。而是有实用价值。

### 什么是 immutability？

Immutability 表示经过一些处理后值或状态保持不变的变量。

概念很简单，但深究起来并不简单。

你可以在 JavaScript 语言本身中找到 immutable 类型。`String` 对象的**值类型**就是一个很好的例子。

如果你声明一个字符串变量，如下：

```
var str = 'abc';
```

你无法直接修改字符串中的字符。

在 JavaScript 中，字符串类型的值不是数组，所以你不能像下面这样做：

```
str[2] = 'd';
```

可以试试这样：

```
str = 'abd';
```

将另一个字符串赋值给 `str`。

你甚至可以将 `str` 重新声明为一个常量：

```
const str = 'abc'
```

结果，重新声明会产生一个错误（但是这个错误和 immutability 无关）。

如果你想修改字符串的值，可以使用字符串方法，例如：[replace](https://www.w3schools.com/jsref/jsref_replace.asp)、[toUpperCase](https://www.w3schools.com/jsref/jsref_touppercase.asp) 或 [trim](https://www.w3schools.com/jsref/jsref_trim_string.asp)。

所有这些方法都会返回一个新的字符串，而不会改变原字符串的值。

### 值类型

可能你没注意到，之前我加粗强调过**值类型**。

字符串的值是 immutable（不可变的）。字符串**对象**就不是了。

如果一个对象是 immutable 的，你不能改变他的状态（及他的属性值）。也意味着不能给他添加新的属性。

试试下面的代码， [你可以在 JSFiddle 中查看](https://jsfiddle.net/eh3rrera/a6uh7tsv/?utm_source=website&utm_medium=embed&utm_campaign=a6uh7tsv)

```js
const str = "abc";
str.myNewProperty = "some value";

alert(str.myNewProperty);
```

如果你运行他，会弹出一个 `undefined`，

新的属性并没有添加上。

但再试试下面这个：[你可以在 JSFiddle 中查看](https://jsfiddle.net/eh3rrera/e46Lsrp7/?utm_source=website&utm_medium=embed&utm_campaign=e46Lsrp7)

```js
const str = new String("abc");
str.myNewProperty = "some value";

alert(str.myNewProperty);

str.myNewProperty = "a new value";

alert(str.myNewProperty);
```

![](https://cdn-images-1.medium.com/max/1600/0*f3DODCqLTseJ5h3L.)

String 对象不是 immutable 的。

最后一个示例通过 `String()` 构造函数创建了一个字符串对象，他的值是 immutable 的。但你可以给这个对象添加新的属性，因为这是一对象并且没有被 [冻结](https://stackoverflow.com/questions/33124058/object-freeze-vs-const)。

这就要求我们理解另一个重要概念。引用相等和值相等的不同。

### 引用相等 vs 值相等

引用相等，你通过 `===` 和 `!==` (或者 `==` 和 `!=`) 操作符比较对象的引用。如果引用指向同一个对象，那他们就是相等的：

```
var str1 = ‘abc’;
var str2 = str1;

str1 === str2 // true
```

在上面的例子中，两个引用（`str1` 和 `str2`）都指向同一个对象（`'abc'`），所以他们是相等的。

![](https://cdn-images-1.medium.com/max/800/0*ipAtUvsW9QPr3EHO.)

如果两个引用都指向一个 immutable 的值，他们也是相等的，如下：

```
var str1 = ‘abc’;
var str2 = ‘abc’;

str1 === str2 // true

var n1 = 1;
var n2 = 1;

n1 === n2 // also true
```

![](https://cdn-images-1.medium.com/max/800/0*jE_ls1ixbCHkVH5J.)

但如果指向的是对象，那就不再相等了：

```
var str1 =  new String(‘abc’);
var str2 = new String(‘abc’);

str1 === str2 // false

var arr1 = [];
var arr2 = [];

arr1 === arr2 // false
```

上面的两种情况，都会创建两个不同的对象，所以他们的引用不相等：

![](https://cdn-images-1.medium.com/max/800/0*QI4r9ERIF1OPVADk.)

如果你想检查两个对象的值是否相等，你需要比较他们的值属性。

在 JavaScript 中，没有直接比较数组和对象值的方法。

如果你要比较字符串对象，可以使用返回新字符串的 `valueOf` 或 `trim` 方法：

```
var str1 =  new String(‘abc’);
var str2 = new String(‘abc’);

str1.valueOf() === str2.valueOf() // true
str1.trim() === str2.trim() // true
```

但对于其他类型的对象，你只能实现自己的比较方法或者使用第三方工具，可以参考 [这篇文章](http://adripofjavascript.com/blog/drips/object-equality-in-javascript.html)。

但这和 immutability 和 React 有什么关系呢？

如果两个对象是不可变的，那么比较他们是否相等比较容易。React 就是利用了这个概念来进行性能优化的。

我们来具体谈谈吧。

### React 中的性能优化

React 内部会维护一份 UI 表述，就是 [虚拟 DOM](http://reactkungfu.com/2015/10/the-difference-between-virtual-dom-and-dom/)。

如果一个组件的属性和状态改变了，他对应的虚拟 DOM 数据也会更新这些变化。因为不用修改真实页面，操作虚拟 DOM 更加方便快捷。

然后，React 会对现在和更新前版本的虚拟 DOM 进行比较，来找出哪些改变了。这就是 [一致性比较](https://reactjs.org/docs/reconciliation.html) 的过程。

这样，就只有有变化的元素会在真实 DOM 中更新。

有时，一些 DOM 元素自身没变化，但会被其他元素影响，造成重新渲染。

这种情况下，你可以通过 [shouldComponentUpdate](https://reactjs.org/docs/react-component.html#shouldcomponentupdate) 方法来判断属性和方法是不是真的改变了，是否返回 true 来更新这个组件：

```
class MyComponent extends Component {

  // ...

  shouldComponentUpdate(nextProps, nextState) {
    if (this.props.myProp !== nextProps.color) {
      return true;
    }
    return false;
  }

  // ...

}
```

如果组件的属性和状态是 immutable 的对象或值，你可以通过相等比较判断他们是否改变了。

从这个角度看，immutability 降低了复杂度。

因为，有时候很难知道什么改变了。

考虑下面的深嵌套：

```
myPackage.sender.address.country.id = 1;
```

如何跟踪是哪个对象改变了呢？

再考虑下数组。

两个长度一致的数组，比较他们是否相等的唯一方式就是比较每个元素是否都相等。对于大型数组，这样的操作消耗很大。

最简单的解决方法就是使用 immutable 对象。

如果需要更新一个对象，就用新的值创建一个新的对象，因为原对象是 immutable 的。

你也可以通过引用比较来确定他有没有改变。

但对有些人来说，这个概念可能与性能和代码简洁性方面的理念不一致。

那我们来回顾下创建新对象并保证 immutability 的观点。

### 实现 immutability

在实际应用中，state 和 property 可能是对象或数组。

JavaScript 提供了一些创建这些数据新版本的方法。

对于对象，不是手动创建具有新属性的对象（如下）：

```
const modifyShirt = (shirt, newColor, newSize) => {
  return {
    id: shirt.id,
    desc: shirt.desc,
    color: newColor,
    size: newSize
  };
}
```

而是可以使用 [Object.assign](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/assign) 这个方法避免定义未修改的属性（如下）：

```
const modifyShirt = (shirt, newColor, newSize) => {
  return Object.assign( {}, shirt, {
    color: newColor,
    size: newSize
  });
}
```

`Object.assign` 方法用于将（从第二个参数开始）所有源对象的属性复制到第一个参数声明的目标对象。

或者你也可以使用 [扩展运算符](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax) 达到目的（不同的是 `Object.assign()` 使用 setter 方法分配新的值，而扩展运算符不是，[参考](http://2ality.com/2016/10/rest-spread-properties.html#spread-defines-properties-objectassign-sets-them)）：

```
const modifyShirt = (shirt, newColor, newSize) => {
  return {
    ...shirt,
    color: newColor,
    size: newSize
  };
}
```

对于数组，你也可以使用扩展运算符创建具有新元素的数组：

```
const addValue = (arr) => {
  return [...arr, 1];
};
```

或者使用像 `concat` 或 `slice` 这样的方法返回一个新的数组，而不会修改原数组：

```
const addValue = (arr) => {
  return arr.concat([1]);
};

const removeValue = (arr, index) => {
  return arr.slice(0, index)
    .concat(
        arr.slice(index+1)
    );
};
```

在这个 [代码片段](https://gist.github.com/JoeNoPhoto/329f002ef4f92f1fcc21280dc2f4aa71) 中，你可以看到在进行一些常见操作时，如何用这些方法结合扩展运算符避免修改原数组。

但是，使用这些方法会有两个主要缺点：

* 他们通过将属性/元素从一个对象/数组复制到另一个来工作。对于大型对象/数组来说，这样的操作比较慢。
* 对象和数组默认是可变的，没什么来确保 immutability。你必须时刻记住要使用这些方法。

**由于上述原因，使用外部库来实现 immutability 是更好的选择。**

React 团队推荐使用 [Immutable.js](https://facebook.github.io/immutable-js/) 和 [immutability-helper](https://github.com/kolodny/immutability-helper)，但 [这里](https://github.com/markerikson/redux-ecosystem-links/blob/master/immutable-data.md) 有很多同样功能的库。主要有下面三种类型：

* 配合持久的数据结构工作的库。
* 通过冻结对象工作的库。
* 提供辅助方法执行不可变操作的库。

大部分库都是配合 [持久的数据结构](https://en.wikipedia.org/wiki/Persistent_data_structure) 来工作。

### 持久的数据结构

当有些数据需要修改时，持久的数据结构会创建一个新的版本（这实现了数据的 immutable），同时提供所有版本的访问权限。

如果数据部分持久化，所有版本的数据都可以访问，但只有最新版可以修改。如果数据完全持久化，那每个版本都可以访问和修改。

基于树和共享的理念，新版本的创建非常高效。

数据结构表层是一个 list 或 map，但在底层是使用一种叫做 [trie](https://en.wikipedia.org/wiki/Trie) 的树来实现（具体来说就是 [位图向量 tire](https://stackoverflow.com/a/29121204/3593852)），其中只有叶节点存储值，二进制表示的属性名是内部节点。

比如，对于下面的数组：

```
[1, 2, 3, 4, 5]
```

你可以将索引转化为 4 位的二进制数：

```
0: 0000
1: 0001
2: 0010
3: 0011
4: 0100
```

将数组按下面的树形展示：

![](https://cdn-images-1.medium.com/max/800/0*3hlxKXFBvhgY-Pzk.)

每个层级都有两个字节形成到达值的路径。

现在如果我们想将 `1` 修改为 `6`：

![](https://cdn-images-1.medium.com/max/800/0*Yq2TMZjNipslzaQe.)

不是直接修改树中的那个值，而是将从根节点到你要修改的那个值整体复制一份：

![](https://cdn-images-1.medium.com/max/800/0*L2vypVatx0VywZZS.)

会在新复制的树中更新那个值：

![](https://cdn-images-1.medium.com/max/800/0*4TVKbnY7a3av-4Fq.)

原树中的其他节点可以继续使用：

![](https://cdn-images-1.medium.com/max/800/0*aAJm2raVQKpBjzqM.)

也可以说，未修改的节点会被新旧两个版本**共享**。

当然，这些 4 位的树形并不普适于这些持久的数据结构。这只是**结构共享**的基本理念。

我不会介绍更多细节了，想了解更多关于持久化数据和结构共享的知识，可以阅读 [这篇文章](https://medium.com/@dtinth/immutable-js-persistent-data-structures-and-structural-sharing-6d163fbd73d2) 和 [这个演讲](https://www.youtube.com/watch?v=Wo0qiGPSV-s)。

### 缺点

Immutability 也不是没有问题。

正如我前面提到的，处理对象和数组时，你要么必须记住使用保证 immutability 的方法，要么就使用第三方库。

但这些库大多都使用自己的数据类型。

尽管这些库提供了兼容的 API 和将这些类型转为 JavaScript 类型的方法，但在设计你自己的应用时，也要小心处理：

* 避免高耦合
* 避免使用像 [`toJs()`](https://twitter.com/leeb/status/746733697093668864) 这样有性能弊病的方法

如果库没有实现新的数据结构（比如使用冻结对象工作的库），就不能体现结构共享的好处。很可能更新数据时要复制对象，有些情况性能会受到影响。

此外，你必须考虑这些库的学习曲线。

当需要选择 immutability 方案时，要仔细考虑。

也可以阅读下这篇文章 [immutability 的反对观点](http://desalasworks.com/article/immutability-in-javascript-a-contrarian-view/)。

### 结论

Immutability 是 React 开发者需要理解的一个概念。

一个 immutable 的值或对象不能被改变，所以每次更新数据都会创建新的值，将旧版本的数据隔离。

例如，如果你应用的 state 是 immutable 的，就可以将所有 state 对象保存在单个 store 中，这样很容易实现撤销/重做功能。

听起来是不是很熟悉？是的。

像 [Git](https://git-scm.com/) 这种版本管理系统以类似方式工作。

[Redux](https://redux.js.org/) 也是基于这个 [原则](https://redux.js.org/introduction/three-principles)。

但是，人们更关注 Redux 的 [纯函数](https://medium.com/@jamesjefferyuk/javascript-what-are-pure-functions-4d4d5392d49c) 和 应用状态的**快照**。StackOverflow 上的 [这个回答](https://stackoverflow.com/a/34962065/3593852) 很好地解释了 Redux 和 immutability 的关系。

Immutability 还有其他像避免意外的副作用和 [减少耦合](https://stackoverflow.com/a/43918514/3593852) 等优点，但也有缺点。

记住，和编程中许多事一样，这也是一种折衷。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
