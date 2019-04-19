> * 原文地址：[Why I've stopped exporting defaults from my JavaScript modules](https://humanwhocodes.com/blog/2019/01/stop-using-default-exports-javascript-module/)
> * 原文作者：[Nicholas C. Zakas](https://humanwhocodes.com/blog/2019/01/stop-using-default-exports-javascript-module/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/stop-using-default-exports-javascript-module.md](https://github.com/xitu/gold-miner/blob/master/TODO1/stop-using-default-exports-javascript-module.md)
> * 译者：[Hopsken](https://juejin.im/user/57e766e42e958a00543d99ae)
> * 校对者：[Fengziyin1234](https://github.com/Fengziyin1234)，[SHERlocked93](https://github.com/SHERlocked93)

# 为什么我不再使用 export default 来导出模块

在与默认导出（export default）死缠烂打了这么多年后，我改变了主意。

上个星期，我发了条推特，收到了不少出人意料的回复：

> 2019年，我要做的其中一件事就是不再从我的 CommonJS/ES6 模块中导出默认值。
> 
> 导入一个默认值感觉上就像抛硬币一样，有一半的概率会猜错。比如我有时就会搞不清楚导入的到底是 class 还是 function。
> 
> — Nicholas C. Zakas (@slicknet) [January 12, 2019](https://twitter.com/slicknet/status/1084101377297506304?ref_src=twsrc%5Etfw)

我意识到我所遇到的大多数与 JavaScript 模块有关的问题都可以归咎于默认导出，于是就发了这条推特。不管我用的是 JavaScript 模块（或者 ECMAScript 模块，很多人喜欢这么叫它）还是 CommonJS，都会深陷于默认导出的泥潭。那条推特收到了各种各样的评论，很多人都在问我我是如何得出这个结论的。在这篇文章中，我将尽可能地解释我的思考历程。

## 一些澄清

正如所有的推文一样，我的推文不过是我的看法的一个缩影，而不是我完整看法的规范性参考。首先我要澄清推文里让人困惑的几点：

*   关于不知道导出的是 function 还是 class 这一点，它只是我在使用中所遇到的诸多问题中的一个例子。这不是命名导出为我解决的**唯一的一个**问题。
*   我所遇到的问题不只出现在我自己的项目中，当引入某些第三方库和工具模块时，也会出现这些问题。这意味着文件名的命名约定并不能解决所有问题。
*   我并不是要所有人都放弃默认导出。我只是说在我写的模块中，我会选择不去用默认导出。当然你可以有你自己看法。

希望以上澄清可以避免后文可能产生的一些误会。

## 默认导出：最初的选择

据我所知，默认导出是最先从 CommonJS 流行开来的。模块可以通过如下方式导出某个默认值：

```javascript
class LinkedList {}
module.exports = LinkedList;
```

这段代码导出了 `LinkedList` 类，但是并没有规定它被引用时应该使用的名称。假设该文件名为 `linked-list.js`，你可以通过如下方式在其它模块中导入它：

```javascript
const LinkedList = require("./linked-list");
```

我只是碰巧把 `require()` 还是返回的值命名为 `LinkedList`，以匹配文件名 `linked-list.js`，但是我也完全可以叫它 `foo`、`Mountain` 或者其它随便什么名称。

默认模块导出在 CommonJS 中的流行，说明 JavaScript 模块生来就支持这种模式：

> ES6 偏好单一/默认导出的风格，而且为默认导入提供了甜蜜的语法糖。
> 
> — David Herman [June 19, 2014](https://mail.mozilla.org/pipermail/es-discuss/2014-June/037905.html)

因此，在 JavaScript 模块中，你可以通过如下方式导出默认值：

```javascript
export default class LinkedList {}
```

然后，你可以这样来导入它：

```javascript
import LinkedList from "./linked-list.js";
```

再次说明，这里的 `LinkedList` 这是个随意的选择（如果不是特别合理的话），并没有特殊含义，也可以是 `Dog` 或者 `symphony` 诸如此类。

## 另一个选择：命名导出

除了默认导出以外，CommonJS 和 JavaScript 模块都支持命名导出。在导入时，命名导出允许保留被导出的函数、类或者变量的名称。

在 CommonJS 中，你可以通过在 `exports` 对象上添加某对键值来创建命名导出：

```javascript
exports.LinkedList = class LinkedList {};
```

然后，你可以在另一个文件中使用如下方法来导入它们：

```javascript
const LinkedList = require("./linked-list").LinkedList;
```

再次说明，`const` 之后的名字是任取的，但是为了导出时的名称一致，这里我选择使用 `LinkedList`。

在 JavaScript 模块中，命名导出看上去像这样：

```javascript
export class LinkedList {}
```

然后你可以这样来导入它：

```javascript
import { LinkedList } from "./linked-list.js";
```

这里，`LinkedList` 不可以取任意的标识符，必须与命名导出使用的名称一致。对于这篇文章要讲的东西而言，这是与 CommonJS 唯一的重要区别。

所以说，这两种模块化方案都支持默认导出和命名导出。

## 个人偏好

在进一步深入之前，我需要说明一下我自己在写代码时的一些个人偏好。这是我写代码的总体原则，与语言本身无关。

1.  **明了胜于晦涩**。我不喜欢有秘密的代码。某个东西是干嘛的，应该如何调用，诸如此类，在任何可能的情况下，都应该明确且清晰。

2.  **名称应该在所有文件中保持一致**。如果某样东西在这个文件里叫 `Apple`，那么在另一个文件里就不该叫 `Orange`。`Apple` 永远都是 `Apple`。

3.  **尽早并经常抛出错误**。如果某样东西有可能缺失，那么最好就尽早检查它，接着，在最理想的情况下，抛出一个错误，让我知道问题在哪儿。我不想等着代码全部执行完后才发现出了问题，然后再去搜查问题出在哪儿。

4.  **更少地抉择意味着更快地开发速度**。我的很多编程偏好都是为了减少编码过程中的抉择。每做一个决定，你都会慢上一点。这就是为什么代码规范可以提高开发速度的原因。我喜欢预先决定好所有事情，然后直接放手去做。

5.  **中途打断会拖慢开发速度**。当你在编码过程中不得不停下来查找一些东西时，这就是我所说的『中途打断』。打断有时候是必要的，但是过多不必要的打断则会拖你的后腿。我想写出尽可能不需要『中途打断』的代码。

6.  **认知负荷会拖慢开发速度**。简单来说，编码时，你需要记忆的用来保证效率的细节越多，你的开发速度越慢。

对开发速度的关注对我而言是个很现实的问题。多年来，我一直为自己的健康所困扰，我能用于写代码的精力越来越少。任何能帮我在保证完成度的前提下，减少编码时间的操作都很关键。

## 我遇到的那些问题

在上述前提下，这里是我在使用默认导出时遇到的主要问题，以及为什么我相信在大多数情况下命名导出都是更好的选择。

### 那究竟是啥？

正如我在之前那条推文上说的，如果模块只有一个默认导出，我很难弄清楚我导入的是什么。如果你正在用一个不熟悉的模块或文件，你很难弄清楚返回的是什么。举个例子：

```javascript
const list = require("./list");
```

这里，你预想中 `list` 应该是什么？虽然不太可能是基本类型数据，但从逻辑上讲可以是函数、类或者其它类型的对象。我怎么才能确定呢？我需要中途打断一下。当前情况下，这可能意味着：

*   如果我有 `list.js` 这个文件，我也许会打开它，看看它导出了什么。
*   如果我没有 `list.js` 这个文件，那么我或许会打开某个文档。

不管是那种情况，你不得不把这段额外的信息记在脑海里，以避免当你需要再次从 `list.js` 导入时发生打断。如果你从各种模块中引入了很多默认值，要么你的认知负荷会增加，要么你不得不中途打断多次。两者都不理想，而且很叫人沮丧。

有人可能会说，IDE 可以解决这些问题。那么 IDE 应该足够聪明，聪明到可以弄明白正在导入的是什么，然后告诉你。当然我是支持使用聪明的 IDE 来帮助开发者的，不过我觉得要求 IDE 来有效地使用语言特性是会有问题的。

### 名称匹配问题

命名导出要求模块的消费者至少得指定导入东西的名称。这有个好处，我可以方便地在代码库中查找所有用到 `LinkedList` 的地方，知道它们都指代的同一个 `LinkedList`。因为默认导出并不能限定导入时使用的名称，给导入命名会为每个开发者带来更多的认知负荷。你需要决定正确的命名规范，另外，你还得确保团队中的每个开发者对同一个事物使用相同的名称。（当然你也可以允许每一位开发者使用不同的命名，但是这会为整个团队带来更多的认知负荷。）

使用命名导出意味着至少在它被用到的地方引用的都是定好的名称。就算你选择重命名某个导入，你也得显示说明出来，不可能在不引用规定名称的情况下实现。在 CommonJS 中：

```javascript
const MyList = require("./list").LinkedList;
```

 在 JavaScript 模块中：

```javascript
import { LinkedList as MyList } from "./list.js";
```

在这两种情况下，你都得显示地声明 `LinkedList` 被改为 `MyList`。

如果名称在代码库中保持一致，你就可以做到以下事情：

1.  查找代码库，了解使用情况。
2.  在整个代码库的范围内，重命名某个东西。

如果使用默认导出和特定命名的话，这些操作可以实现吗？我猜是可以的，但是会复杂得多，也容易出现错误。

### 导入错误的东西

相对于默认导出，命名导出有个明显的好处。那就是，当试图导入模块中不存在的东西时，命名导入会抛出错误。考虑以下代码：

```javascript
import { LinkedList } from "./list.js";
```

如果 `list.js` 中不存在 `LinkedList`，则会报错。另外，也方便像 IDE 和 ESLint[1](#fn:1) 这样的工具在代码执行之前检测不存在的引用。

## 糟糕的工具支持

提到 IDE，WebStorm 可以帮你书写 `import` 语句。[2](#fn:2) 当你在打完一个当前文件内未定义的标识符后，WebStorm 会在项目内查找模块，检查该标识符是否是某一个文件的命名导出。这时，它会做如下事情：

1.  在缺失定义的标识符下加上下划线，显示可以修复这个问题的 `import` 语句。
2.  根据你打出的标识符，自动导入正确的 `import` 语句（如果打开了自动导入功能）。事实上，当使用命名导入时，WebStorm 可以帮上很多忙。

Visual Studio Code[3](#fn:3) 有一个插件可以实现类似的功能。这种功能无法通过默认导出实现，因为你想导入的东西没有确定的名称。

## 结论

当我在项目中使用默认导出时，我遇到严重的工作效率问题。然而这些问题并不是无解的，使用命名导出和导入可以更好地配合我的编程习惯。清晰明确的代码和对工具的重度依赖使我成为高效的程序员。只要命名导出可以帮我做到这些，在可预见的未来内，我都会支持它们。当然，我无法决定我用的第三方模块如何导出，但我可以控制我自己写的模块如何导出，我会选择命名导出。

正如前文说的，得提醒一下，这只是我个人的看法，你也许觉得我的论证没有足够的说服力。这篇文章并不是想劝阻任何使用默认导出，而是作为对那些询问我为什么停止使用默认导出的一个更好的回答。

## References

1.  [esling-plugin-import `import/named` rule](https://github.com/benmosher/eslint-plugin-import/blob/master/docs/rules/named.md) [↩](#fnref:1)
    
2.  [WebStorm: Auto Import in JavaScript](https://www.jetbrains.com/help/webstorm/javascript-specific-guidelines.html#ws_js_auto_import) [↩](#fnref:2)
    
3.  [Visual Studio Extension: Auto Import](https://marketplace.visualstudio.com/items?itemName=NuclleaR.vscode-extension-auto-import) [↩](#fnref:3)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
