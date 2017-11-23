
> * 原文地址：[JavaScript Factory Functions with ES6+](https://medium.com/javascript-scene/javascript-factory-functions-with-es6-4d224591a8b1)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/javascript-factory-functions-with-es6.md](https://github.com/xitu/gold-miner/blob/master/TODO/javascript-factory-functions-with-es6.md)
> * 译者：[lampui](https://github.com/lampui)
> * 校对者：[IridescentMia](https://github.com/IridescentMia)、[sunui](https://github.com/sunui)

# ES6+ 中的 JavaScript 工厂函数（第八部分）

![Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

>注意：这是“软件编写”系列文章的第八部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科 [Composability](https://en.wikipedia.org/wiki/Composability)）。后续还有更多精彩内容，敬请期待！
> [< 上一篇](https://github.com/xitu/gold-miner/blob/master/TODO/functional-mixins-composing-software.md) | [<< 第一篇](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md)  | [下一篇 >](https://github.com/xitu/gold-miner/blob/master/TODO/why-composition-is-harder-with-classes.md)

**工厂函数**是一个能返回对象的函数，它既不是类也不是构造函数。在 JavaScript 中，任何函数都可以返回一个对象，如果函数前面没有使用 `new` 关键字，却又返回一个对象，那这个函数就是一个工厂函数。

因为工厂函数提供了轻松生成对象实例的能力，且无需深入学习类和 `new` 关键字的复杂性，所以工厂函数在 JavaScript 中一直很具吸引力。

JavaScript 提供了非常方便的对象字面量语法，代码如下：

```
const user = {
  userName: 'echo',
  avatar: 'echo.png'
};
```

就像 JSON 的语法（JSON 就是基于 JavaScript 的对象字面量语法），`:`（冒号）左边是属性名，右边是属性值。你可以使用点运算符访问变量：

```
console.log(user.userName); // "echo"
```

或者使用方括号及属性名访问变量：

```
const key = 'avatar';
console.log( user[key] ); // "echo.png"
```

如果在作用域内还有变量和你的属性名相同，那你可以直接在对象字面量中使用这个变量，这样就省去了冒号和属性值：

```
const userName = 'echo';
const avatar = 'echo.png';
const user = {
  userName,
  avatar
};
console.log(user);
// { "avatar": "echo.png",   "userName": "echo" }
```

对象字面量支持简洁表示法。我们可以添加一个 `.setUserName()` 的方法：

```
const userName = 'echo';
const avatar = 'echo.png';
const user = {
  userName,
  avatar,
  setUserName (userName) {
    this.userName = userName;
    return this;
  }
};
console.log(user.setUserName('Foo').userName); // "Foo"
```

在简洁表示法中，`this` 指向的是调用该方法的对象，要调用一个对象的方法，只需要简单地使用点运算符访问方法并使用圆括号调用即可，例如 `game.play()` 就是在 `game` 这一对象上调用 `.play()`。要使用点运算符调用方法，这个方法必须是对象属性。你也可以使用函数原型方法 `.call()`、`.apply()` 或 `.bind()` 把一个方法应用于一个对象上。

本例中，`user.setUserName('Foo')` 是在 `user` 对象上调用 `.setUserName()`，因此 `this === user`。在`.setUserName()` 方法中，我们通过 `this` 这个引用修改了 `.userName` 的值，然后返回了相同的对象实例，以便于后续方法链式调用。

## 字面量偏向单一对象，工厂方法适用众多对象

如果你需要创建多个对象，你应该考虑把对象字面量和工厂函数结合使用。

使用工厂函数，你可以根据需要创建任意数量的用户对象。假如你正在开发一个聊天应用，你会用一个用户对象表示当前用户，以及用很多个用户对象表示其他已登录和在聊天的用户，以便显示他们的名字和头像等等。

让我们把 `user` 对象转换为一个 `createUser()` 工厂方法:

```
const createUser = ({ userName, avatar }) => ({
  userName,
  avatar,
  setUserName (userName) {
    this.userName = userName;
    return this;
  }
});
console.log(createUser({ userName: 'echo', avatar: 'echo.png' }));
/*
{
  "avatar": "echo.png",
  "userName": "echo",
  "setUserName": [Function setUserName]
}
*/
```

## 返回对象

箭头函数（`=>`）具有隐式返回的特性：如果函数体由单个表达式组成，则可以省略 `return` 关键字。`()=>'foo'` 是一个没有参数的函数，并返回字符串 `"foo"`。

返回对象字面量时要小心。当使用大括号时，JavaScript 默认你创建的是一个函数体，例如 `{ broken: true }`。如果你需要返回一个明确的对象字面量，那你就需要通过使用圆括号将对象字面量包起来以消除歧义，如下所示：

```
const noop = () => { foo: 'bar' };
console.log(noop()); // undefined
const createFoo = () => ({ foo: 'bar' });
console.log(createFoo()); // { foo: "bar" }
```

在第一个例子中，`foo:` 被解释为一个标签，`bar` 被解释为一个没有被赋值或者返回的表达式，因此函数返回 `undefined`。

在 `createFoo()` 例子中，圆括号强制着大括号，使其被解释为要求值的表达式，而不是一个函数体。

## 解构

请特别注意函数声明：

```
const createUser = ({ userName, avatar }) => ({
```

这一行里，大括号 (`{, }`) 表示对象解构。这个函数有一个参数（即一个对象），但是从这个参数中，却解构出了两个形参，`userName` 和 `avatar`。这些形参可以作为函数体内的变量使用。解构还可以用于数组：

```
const swap = ([first, second]) => [second, first];
console.log( swap([1, 2]) ); // [2, 1]
```

你可以使用扩展语法 (`...varName`) 获取数组（或参数列表）余下的值，然后将这些值回传成单个元素：

```
const rotate = ([first, ...rest]) => [...rest, first];
console.log( rotate([1, 2, 3]) ); // [2, 3, 1]
```

## 计算属性值

前面我们使用方括号的方法动态访问对象的属性值：

```
const key = 'avatar';
console.log( user[key] ); // "echo.png"
```

我们也可以计算属性值来赋值：

```
const arrToObj = ([key, value]) => ({ [key]: value });
console.log( arrToObj([ 'foo', 'bar' ]) ); // { "foo": "bar" }
```

本例中，`arrToObj` 接受一个包含键值对（又称`元组`）的数组，并将其转化成一个对象。因为我们并不知道属性名，因此我们需要计算属性名以便在对象上设置属性值。为了做到这一点，我们使用了方括号表示法，来设置属性名，并将其放在对象字面量的上下文中来创建对象：

```
{ [key]: value }
```

在赋值完成后，我们就能得到像下面这样的对象：

```
{ "foo": "bar" }
```

## 默认参数

JavaScript 函数支持默认参数值，给我们带来以下优势：

1. 用户可以通过适当的默认值省略参数。
2. 函数自我描述性更高，因为默认值提供预期的输入例子。
3. IDE 和静态分析工具可以利用默认值推断参数的类型。例如，一个默认值 `1` 表示参数可以接受的数据类型为 `Number`。

使用默认参数，我们可以为我们的 `createUser` 工厂函数描述预期的接口，此外，如果用户没有提供信息，可以自动地补充`某些`细节：

```
const createUser = ({
  userName = 'Anonymous',
  avatar = 'anon.png'
} = {}) => ({
  userName,
  avatar
});
console.log(
  // { userName: "echo", avatar: 'anon.png' }
  createUser({ userName: 'echo' }),
  // { userName: "Anonymous", avatar: 'anon.png' }
  createUser()
);
```

函数签名的最后一部分可能看起来有点搞笑：

```
} = {}) => ({
```

在参数声明最后那部分的 `= {}` 表示：如果传进来的实参不符合要求，则将使用一个空对象作为默认参数。当你尝试从空对象解构赋值的时候，属性的默认值会被自动填充，因为这就是默认值所做的工作：用预先定义好的值替换 `undefined`。

如果没有 `= {}` 这个默认值，且没有向 `createUser()` 传递有效的实参，则将会抛出错误，因为你不能从 `undefined` 中访问属性。

## 类型判断

在写这篇文章的时候，JavaScript 都还没有内置的类型注解，但是近几年涌现了一批格式化工具或者框架来填补这一空白，包括 JSDoc（由于出现了更好的选择其呈现出下降趋势）、Facebook 的 [Flow](https://flow.org/)、还有微软的 [TypeScript](https://www.typescriptlang.org/)。我个人使用 [rtype](https://github.com/ericelliott/rtype)，因为我觉得它在函数式编程方面比 TypeScript 可读性更强。

直至写这篇文章，各种类型注解方案其实都不相上下。没有一个获得 JavaScript 规范的庇护，而且每个方案都有它明显的不足。

类型推断是基于变量所在的上下文推断其类型的一个过程，在 JavaScript 中，这是对类型注解非常好的一个替代。

如果你在标准的 JavaScript 函数中提供足够的线索去推断，你就能获得类型注解的大部分好处，且不用担心任何额外成本或风险。

即使你决定使用像 TypeScript 或 Flow 这样的工具，你也应该尽可能利用类型推断的好处，并保存在类型推断抽风时的类型注解。例如，原生 JavaScript 是不支持定义共享接口的。但使用 TypeScript 或 rtype 都可以方便有效地定义接口。

[Tern.js](http://ternjs.net/) 是一个流行的 JavaScript 类型推断工具，它在很多代码编辑器或 IDE 上都有插件。

微软的 Visual Studio Code 不需要 Tern，因为它把 TypeScript 的类型推断功能附带到了 JavaScript 代码的编写中。

当你在 JavaScript 函数中指定默认参数值时，很多诸如 Tern.js、TypeScript 和 Flow 的类型推断工具就可以在 IDE 中给予提示以帮助开发者正确地使用 API。

没有默认值，各种 IDE（更多的时候，连我们自己）都没有足够的信息来判断函数预期的参数类型。

![没有默认值， `userName` 的类型未知。](https://cdn-images-1.medium.com/max/800/1*2sP_9k1e0dkgYqdEPs0G3g.png)

有了默认值，IDE (更多的时候，我们自己) 可以从代码中推断出类型。

![有默认值，IDE 可以提示 `userName` 的类型应该是字符串。](https://cdn-images-1.medium.com/max/800/1*tFUXCLA8ClAzsPgZXGGR9A.png)

将参数限制为固定类型（这会使通用函数和高阶函数更加受限）是不怎么合理的。但要说这种方法什么时候有意义的话，使用默认参数通常就是，即使你已经在使用 TypeScript 或 Flow 做类型推断。

## Mixin 结构的工厂函数

工厂函数擅于利用一个优秀的 API 创建对象。通常来说，它们能满足基本需求，但不久之后，你就会遇到这样的情况，总会把类似的功能构建到不同类型的对象中，所以你需要把这些功能抽象为 mixin 函数，以便轻松重用。

mixin 的工厂函数就要大显身手了。我们来构建一个 `withConstructor` 的 mixin 函数，把 `.constructor` 属性添加到所有的对象实例中。

`with-constructor.js:`

```
const withConstructor = constructor => o => {
  const proto = Object.assign({},
    Object.getPrototypeOf(o),
    { constructor }
  );
  return Object.assign(Object.create(proto), o);
};
```

现在你可以导入和使用其他 mixins：
```
import withConstructor from `./with-constructor';
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);
// 或者 `import pipe from 'lodash/fp/flow';`
// 设置一些 mixin 的功能
const withFlying = o => {
  let isFlying = false;
  return {
    ...o,
    fly () {
      isFlying = true;
      return this;
    },
    land () {
      isFlying = false;
      return this;
    },
    isFlying: () => isFlying
  }
};
const withBattery = ({ capacity }) => o => {
  let percentCharged = 100;
  return {
    ...o,
    draw (percent) {
      const remaining = percentCharged - percent;
      percentCharged = remaining > 0 ? remaining : 0;
      return this;
    },
    getCharge: () => percentCharged,
    get capacity () {
      return capacity
    }
  };
};
const createDrone = ({ capacity = '3000mAh' }) => pipe(
  withFlying,
  withBattery({ capacity }),
  withConstructor(createDrone)
)({});
const myDrone = createDrone({ capacity: '5500mAh' });
console.log(`
  can fly:  ${ myDrone.fly().isFlying() === true }
  can land: ${ myDrone.land().isFlying() === false }
  battery capacity: ${ myDrone.capacity }
  battery status: ${ myDrone.draw(50).getCharge() }%
  battery drained: ${ myDrone.draw(75).getCharge() }%
`);
console.log(`
  constructor linked: ${ myDrone.constructor === createDrone }
`);
```

正如你所见，可重用的 `withConstructor()` mixin 与其他 mixin 一起被简单地放入 `pipeline` 中。`withBattery()` 可以被其他类型的对象使用，如机器人、电动滑板或便携式设备充电器等等。`withFlying()` 可以被用来模型飞行汽车、火箭或气球。

对象组合更多的是一种思维方式，而不是写代码的某一特定技巧。你可以在很多地方用到它。功能组合只是从头开始构建你思维方式的最简单方法，工厂函数就是将对象组合有关实现细节包装成一个友好 API 的简单方法。

## 结论

对于对象的创建和工厂函数，ES6 提供了一种方便的语法，大多数时候，这样就足够了，但因为这是 JavaScript，所以还有一种更方便并更像 Java 的语法：`class` 关键字。

在 JavaScript 中，类比工厂更冗长和受限，当进行代码重构时更容易出现问题，但也被像是 React 和 Angular 等主流前端框架所采纳使用，而且还有一些少见的用例，使得类更有存在意义。

> “有时，最优雅的实现仅仅是一个函数。不是方法，不是类，不是框架。仅仅只是一个函数。” ~ John Carmack

最后，你还要切记，不要把事情搞复杂，工厂函数不是必需的，对于某个问题，你的解决思路应当是：

`纯函数 > 工厂函数 > 函数式 Mixin > 类`

[Next: Why Composition is Harder with Classes >](https://medium.com/javascript-scene/why-composition-is-harder-with-classes-c3e627dcd0aa)

## 接下来

想更深入学习关于 JavaScript 的对象组合？

[跟着 Eric Elliott 学 Javacript](http://ericelliottjs.com/product/lifetime-access-pass/)，机不可失时不再来！

![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)

**Eric Elliott** 是  [**“编写 JavaScript 应用”**](http://pjabook.com) （O’Reilly） 以及 [**“跟着 Eric Elliott 学 Javascript”**](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 **Adobe Systems**、**Zumba Fitness**、**The Wall Street Journal**、**ESPN** 和 **BBC** 等 , 也是很多机构的顶级艺术家，包括但不限于 **Usher**、**Frank Ocean** 以及 **Metallica**。

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。

感谢 [JS_Cheerleader](https://medium.com/@JS_Cheerleader?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
