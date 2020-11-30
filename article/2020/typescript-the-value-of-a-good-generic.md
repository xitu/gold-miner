> * 原文地址：[TypeScript: The Value of a Good Generic](https://blog.bitsrc.io/typescript-the-value-of-a-good-generic-bfd820d52995)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/typescript-the-value-of-a-good-generic.md](https://github.com/xitu/gold-miner/blob/master/article/2020/typescript-the-value-of-a-good-generic.md)
> * 译者：[tonylua](https://github.com/tonylua)
> * 校对者：[Alfxjx](https://github.com/Alfxjx)

# TypeScript：一个好泛型的价值

![](https://oscimg.oschina.net/oscnet/up-d1c0028db6c739e0c0ec9b6772abe63794f.png)

在软件开发领域，我们总是致力于创建可复用的组件，架构被设计为可适应多种情境，并且我们始终在寻找一种即便在面临未知情况时，也能自动让逻辑正确行事的方法。

尽管在某些情境下可能并不总是易于做到甚或根本不可行，但我们心里总想找到能被复现并变为可被应付的通用算法的某些模式。所谓 **泛型（Generics）** 的概念就是该行为的另一个例子，只是，这次我们不诉诸宏大，而是在代码层面的细枝末节中试图找出并描绘上述的模式。

**且听我细细道来……**

## 何为泛型？

泛型是种一旦理解就乐在其中的概念，所以让我只是先从这样描述它开始吧：

> 泛型之于类型（Types），犹类型之于变量也

换言之，泛型为你提供了一种不用指定特别某种类型就能使用若干类型的方式。这给你的函数定义、类型定义，甚至接口定义赋予了更高一层的灵活性。

用于解释泛型威力的典型例子，莫过于 identity 函数。该函数本质上只是原样返回你传入的唯一参数，别无他用，但如果你思考一下，如何在一种强类型语言中定义这样一个函数呢？

```TypeScript
function identity(value: number):number {
  return value;
}
```

上面的函数对于数字工作良好，那字符串呢？或布尔值？自定义类型又如何？在 TypeScript 中要覆盖所有可能性，明显只能选择  `any` 类型了：

```TypeScript
function identity(value: any): any {
  return value
}
```

这还挺行得通的，但此刻你的函数实际上丢失了所有类型的概念，你将不能在本该有确定类型信息的地方使用它们了。本质上来说现在你可以传入任何值而编译器将一言不发，这和你使用普通的 JavaScript 就没有区别了（即无论怎样都没有类型信息了）：

```TypeScript

let myVar = identity("Fernando")

console.log(myVar.length) // 工作良好！

myVar = identity(23)

console.log(myVar.length) // 也能工作，尽管打印了 "undefined" 
```

现在因为没有类型信息了，编译器就不能检查和函数相关的任何事情以及变量了，如此一来我们运行出了一个意外的 “undefined”（若将本例推及有更多逻辑复杂逻辑的真实场景将很可能变成最糟糕的一段程序）。

我们该如何修复这点并避免使用 `any` 类型呢？

#### TypeScript 泛型来拯救

正如我曾 **尝试** 说的那样：一个泛型就像若干类型的一个变量，这意味着我们可以定义一个表示任何类型的变量，同时能保持住类型信息。后者是关键，因为那正是 `any` 做不到的。基于这种想法，现在可以这样重构我们的 identity 函数：

```TypeScript
function identity<T>(value: T): T {
  return value;
}
```

记住，用来表示泛型名字的可以是任意字母，你可以随意命名。但使用一个单字母呢，看起来是个标准了，所以我们也从善如流。

这不单让我们定义了一个可被任意类型使用的函数，现在相关的变量也将保留你所选择类型的正确信息。如下：

![](https://oscimg.oschina.net/oscnet/up-7dd0b5764da18f75343065fb90559733c73.png)

图片中两件事情值得注意：

1. 我直接在函数名之后（在 \< 和 > 之间）指定了类型。在本例中，由于函数签名足够简单，我们其实可以省略这部分来调用函数而编译器将会从所传参数推断出类型。然而，如果你把单词 `number` 改为 `string` 则整个例子将不再工作。
2. 现在无法打印出 `length` 属性了，因为数字没有这个属性。

这正是你期待一个强类型语言该做的事情，并且这也是当定义 **通用的** 行为时为何你要使用泛型的原因。

## 我还能用泛型做些什么？

前面的例子常被称为泛型的 **“Hello World”**, 你能在任何一篇文章中找到它，但它是解释泛型潜能的一个绝佳途径。但还有些其他你能做到的有趣之事，当然了总是在类型安全领域的，别忘了，你要构建能在多种环境下复用的东西，同时还要努力保持住我们非常关心的类型信息。

#### 自动结构检查

泛型中的这一点无疑是我最喜欢的了。考虑如下场景：你有一个固定的结构（即一个对象）并且你在试图动态地访问其中一个属性。我们之前已经像这样完成了这个功能：

```JavaScript
function get(obj, prop) {
  if(!obj[prop]) return null;
  return obj[prop]
}
```

我并没有用到 `hasOwnProperty` 或其他类似的技术，但你能明白要点就好，你需要执行一个基础的结构检查以确保能控制所访问的属性不属于对象的情况。现在，让我们将其转换为类型安全的 TypeScript 并看看泛型能如何帮助我们：

```TypeScript
type Person = {
    name: string,
    age: number,
    city: string
}

function getPersonProp<K extends keyof Person>(p:Person, key: K): any {
    return p[key]
}
```

现在，请注意我是如何使用泛型符号的：我不是仅声明了一个泛型 K，同时还说明了它 **继承自 Person 中的键类型。** 这太棒了！你可以声明式的界定你传入的值会匹配字符串 `name`、`age` 或 `city`。本质上你声明了一个枚举值，而当你这么想的时候，就没之前那么兴奋了吧。但你也不用止步于此，可以通过像这样重新定义该函数来重燃激情：

```TypeScript
function get<T, K extends keyof T>(p: T, key: K): any {
    return p[key]
}
```

这就对了，我们现在有了两个泛型，后一个被声明为继承自前一个中的键，但本质上的好处是你现在不再受限于某一种具体类型（即 `Person` 类型的对象) 了，该函数可被你放心大胆地用于任何类型或结构了。

下面是当你用一个非法属性名使用它时将会发生的：

![](https://oscimg.oschina.net/oscnet/up-20f0ec55ab67d58118944e796c971aa0dd7.png)

#### 泛型类（Generic classes）

泛型不仅应用于函数签名，亦可用来定义你自己的泛型类。这提供了将通用逻辑封装进可复用构造中的能力，让一些有意思的行为变得可能。

下面是一个例子：

```TypeScript

abstract class Animal {
    handle() { throw new Error("Not implemented") }
}

class Horse extends Animal{
    color: string
    handle() {
        console.log("Riding the horse...")
    }
}

class Dog extends Animal{
    name: string 
    handle() {
        console.log("Feeding the dog...")
    }
}

class Handler<T extends Animal> {
    animal: T

    constructor(animal: T) {
        this.animal = animal
    }

    handle() {
        this.animal.handle()
    }
}

class DogHandler extends Handler<Dog> {}
class HorseHandler extends Handler<Horse> {}
```

在本例中，我们定义了一个可以处理任意动物类型的处理类，虽说不用泛型也能做到，但使用泛型的益处在最后两行显而易见。这是因为借助泛型，处理类逻辑完全被封装进了一个泛型类中，从而我们可以约束类型并创建指定类型的类，这样的类只对动物类型生效。你也可以在此添加额外的行为，而类型信息也得以保留。

来自这个例子的另一个收获是，泛型可被约束为仅继承自指定的一组类型。正如你所见，`T` 只能是 `Dog` 或 `Horse` 而非其他。

#### 可变参数元组（Variadic Tuples）

实际上这是 TypeScript 4.0 中的新特性。并且尽管我 [已经在这篇文章中介绍了它](https://blog.bitsrc.io/typescript-4-0-what-im-most-excited-about-4ee89693e02e)，此处仍会快速回顾一下。

概况来说，可变参数元组带来的，是用泛型定义某元组中一个可变的部分，默认情况下这部分什么都没有。

一个普通的元组定义将产生一个固定尺寸的数组，其所有元素都是预定义好的类型：

```TypeScript
type MyTuple = [string, string, number]

let myList:MyTuple = ["Fernando", "Doglio", 37]
```

现在，归功于泛型和可变参数元组，你可以这样做：

```TypeScript
type MyTuple<T extends unknown[]> = [string, string, ...T, number]

let myList:MyTuple<[boolean, number]> = ["Fernando", "Doglio", true, 3, 37]
let myList:MyTuple<[number, number, number]> = ["Fernando", "Doglio", 1,2,3,4]
```

如果你注意看，我们使用了一个泛型 `T`（继承自一个 `unknown` 数组）用以将一个可变部分置于元组中。因为 `T` 是 `unknown` 类型的一个列表，你可以在里面装任何东西。比分说，你可以将其定义为单一类型的一个列表，就像这样：

```TypeScript
type anotherTuple<T extends number[]> = [boolean, ...T, boolean];

let oneNumber: anotherTuple<[number]> = [true, 1, true];
let twoNumbers: anotherTuple<[number, number]> = [true, 1, 2, true]
let manyNumbers: anotherTuple<[number, number, number, number]> = [true, 1, 2, 3, 4, true]
```

天高任鸟飞，本质上你可以定义出一种模板元组的形式，以供稍后随意（当然要按照你设置的模板）使用。

## 总结

泛型是一种非常强大的工具，虽然有时阅读由其编写的代码宛如天书，但熟能生巧。慢慢品味，用心阅读，你将看到其内在的潜能。

那你呢？使用过泛型吗？我说明白它的主要用法了吗？在评论中和大家分享你的想法吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
