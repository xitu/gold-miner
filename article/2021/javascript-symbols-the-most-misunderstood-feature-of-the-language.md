> * 原文地址：[JavaScript Symbols: the Most Misunderstood Feature of the Language?](https://blog.bitsrc.io/javascript-symbols-the-most-misunderstood-feature-of-the-language-282b6e2a220e)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/javascript-symbols-the-most-misunderstood-feature-of-the-language.md](https://github.com/xitu/gold-miner/blob/master/article/2021/javascript-symbols-the-most-misunderstood-feature-of-the-language.md)
> * 译者：[Zavier](https://github.com/zaviertang) 
> * 校对者：[jaredliw](https://github.com/jaredliw)、[niayyy](https://github.com/nia3y) 

# Symbol：JavaScript 中最容易被误解的特性？

![Image by [Anemone123](https://pixabay.com/users/anemone123-2637160/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2736480) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2736480)](https://cdn-images-1.medium.com/max/3840/1*XF06TaFwVn5fEt8pS9syOA.jpeg)

String 问开发者：“Symbol 中的哪个特性是我 String 没有的？”。“额，Symbol 是独一无二的。”

我知道，这是一个糟糕的回答，但请和我一起来看看，好吗？Symbol 是 JavaScript 中的奇怪特性之一，因为很少有人真正理解它，也不去使用它。

但是 Symbol 的存在是有原因的，你不觉得吗？就像 `with` 一样有它存在的价值，无论你是否喜欢它。Symbol 也有它存在的价值。这里，我们来分析一下。

## Symbol 是什么?

长话短说，Symbol 是一种新的原始数据类型，现在你可以像访问字符串、数值、布尔值、`undefined` 和 `null` 一样去访问它。

让我们来分析一下。原始数据类型的值是会被直接赋值到变量当中的，如下：

```js
let a = "foo"
```

这里的原始值是指字符串 `"foo"` 而不是 `a`。后者只是一个被赋值为原始值的变量。为什么我要在这里进行这样的区分呢？因为一般你不会直接地使用一个原始值，而是将它赋值给变量并赋予它含义。换句话说，数值 `2` 本身没有任何含义，但 `let double = 2;` 是有含义的。

另一个有趣的点是，在 JavaScript 中原始值是不可变更的。这意味着你永远不能修改数值 `2`。但实际上，你可以为变量**重新赋值**为其他（不可变更的）原始值。

同样作为原始值的 Symbol 也有以上的特性：

* Symbol 是一种原始值，可以直接赋值给变量。
* Symbol 是不可变更的，不管你如何尝试，都无法修改它。

它还有一个额外的特性：Symbol 在全局是唯一的。

前两个特性对于所有原始类型来说都是常见的，但第三个特性却不是，这就是它们如此特别的原因。

### 独一无二的 Symbol

让我们来测试一下：

```JavaScript
2 === 2 // TRUE
true === true // TRUE
"this is a string" === "this is a string" // TRUE
undefined === undefined // TRUE
null === null // TRUE
Symbol() === Symbol() // FALSE!
```

以上结果就表明 Symbol 独特的特性：每次创建的 Symbol 都是一个新的值，即使你给他们传递了相同的名称。

如果想调试一下，你可以为 `Symbol` 构造函数提供一个字符串值作为参数。除了调试之外，该值没有任何用处。

那么这样一个你永远无法真正匹配的值有什么用呢？

```js
let obj = {}
obj[Symbol()] = 10;
console.log(obj[Symbol()]);
```

结果不是我们预期的。当然，你可以将 `Symbol` 保存到变量中，然后使用变量去访问唯一的属性值。但是你必须保存每个 Symbol 到变量中。实在的说，它像是字符串的一个变种，不是吗？

直到你认识到全局 Symbol 缓存后！

你可以通过 `Symbol.for` 方法来创建 Symbol 值，而不是直接调用 `Symbol` 函数。

```JavaScript
let obj = {}
obj[Symbol.for('unique_prop')] = 10;

console.log(obj[Symbol.for('unique_prop')]); // 将输出 10!
```

第一次调用 `Symbol.for` 将会创建一个新的 Symbol 值，然后在第二次调用时将会返回它。这里就是 Symbol 偏离字符串的地方。显然，字符串 `"hello"` 和另一个字符串 `"hello"` 是相等的，但他们是不同的字符串。比如当我们：

```JavaScript
let obj = {}
obj["prop"] = 10;
console.log(obj["prop"]);
```

我们创建了：

* 一个 Number 类型的原始值 (`10`)
* 两个 String 类型的原始值（两个 `"prop"` 字符串）

他们之间有什么联系呢？让我们来看一些 Symbol 的例子！

## 何时使用 Symbol？

在上一个例子里，资源方面的成本有多高？创建一个额外的字符串消耗了多少内存？太少了，我甚至不愿去关注它。

但特别的是，如果它工作在 Web 环境中。

或者，如果你遇到一些边缘情况，例如可能需要进行一些数据处理以生成大型内存字典，或者你可能在内存有限的设备上使用 JavaScript，那么 Symbol 可能是维持内存利用率的好方法。

### 添加“不可见的”方法

Symbol 的另一个有趣的用途来自它们是唯一的这样一个特性。它们可用于为对象提供自定义的、唯一的“hooks”。就像你可以在自定义对象上添加的 `toString` 钩子一样，它会在 `console.log` 序列化时被调用。

这里的关键是，通过使用 Symbol，你可以避免与用户为其方法提供的任何名称发生潜在的名称冲突。除非他们特意使用你的 Symbol，否则不会有问题。

```JavaScript
// 为 "Object" 添加自定义 hook
Object.prototype.symbols = {
    serialize: Symbol.for('serialize')
}

// 在函数中使用 hook
function myconsol_log(obj) {
    if(typeof obj[Object.symbols.serialize] === 'function') {
        console.log(obj[Object.symbols.serialize]())
    } else {
        console.log(obj)
    }
}


// 编写你自己的 hook
class MyObject {
    [Object.symbols.serialize]() {
        return "Damn son!"
    }

    serialize() {
        return "Definitely not the same!"
    }
}


myconsol_log(new MyObject())
```

以上代码，你认为输出会是什么？

将会输出 `"damn son!"`，因为这是你使用 Symbol 定义的方法。而另一个本质上会被视为字符串，因此它们不相同并且你也不会覆盖它。

注意，为了简单起见，我向 `Object` 添加了一个属性，这不是必要的。相反，你应创建一个自定义类来正确控制谁继承了这个自定义钩子。

### 作为类的元数据

Symbol 的最后一个有趣的用例是向你的类和对象中添加属性，这些属性实际上不属于其”结构“的一部分。

解释一下：一个对象的“结构”是由它的属性决定的。将数据添加到对象而不影响其结构（其原始属性集）的唯一方法是将它们添加为 Symbol。这是因为这些类型的属性不会作为 `for..in` 循环的一部分出现，也不会作为调用 `Object.keys` 的结果出现。

你可以将这些属性视为位于比常规属性更高的抽象层中。

```JavaScript
const lastAccessedProp = Symbol.for('last_accessed_prop');
const lastAccessedTime = Symbol.for('last_accessed_time');

class User {
    constructor(f_name, l_name, address) {
        this.first_name = f_name;
        this.last_name = l_name;
        this.address = address;
    }

    get FirstName() {
        this[lastAccessedProp] = 'first_name'
        this[lastAccessedTime] = new Date();
        return this.first_name;
    }

    get LastName() {
        this[lastAccessedProp] = 'last_name'
        this[lastAccessedTime] = new Date();
        return this.last_name;
    }

    get Address() {
        this[lastAccessedProp] = 'address'
        this[lastAccessedTime] = new Date();
        return this.address;
    }
}

let myUser = new User('Fernando', 'Doglio', 'Madrid, Spain');
console.log(myUser.FirstName, myUser.LastName)
console.log("Metadata:", myUser[lastAccessedProp], " read at ", myUser[lastAccessedTime].toTimeString())

console.log("Iterating over attributes: ")
for(k in myUser) {
    console.log(k, "=", myUser[k])
}
```

注意，我是如何向我的对象中添加两个元数据的：通过我定义的 getter 方法设置最后一次访问的属性，以及访问的日期和时间。这是元数据，因为它是与我的业务需求无关的信息，而是和对象相关的信息。

在类定义之后，我做了一些操作：

* Symbol 属性是公开的。这很明显，因为私有属性还不是 ES 标准的一部分。一旦他们完成测试，我们可以看看是如何定义私有属性的。
* 在上面 `for..in` 迭代的所有属性中不会显示我的自定义 Symbol 属性。如果你尝试访问类中这些作为调试数据的属性，这会派上用场，因为你知道它不会影响代码的正常运行。

就像上面提到的，Symbol 不是 JavaScript 最方便的特性，但也不是最差的。Symbol 成为标准的一部分是有充分理由的，现在你知道了它们的一些有趣的用例，考虑花时间去尝试一下吧。

你是否在代码中以任何其他方式使用过 Symbol 呢？在评论中分享你的代码吧，让我们向所有人展示 Symbol 的力量！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
