> * 原文地址：[TypeScript’s never Type](https://levelup.gitconnected.com/typescripts-never-type-d5f28271fcd6)
> * 原文作者：[Dornhoth](https://medium.com/@dornhoth)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/typescripts-never-type.md](https://github.com/xitu/gold-miner/blob/master/article/2020/typescripts-never-type.md)
> * 译者：[JohnieXu](https://github.com/JohnieXu)
> * 校对者：[z0gSh1u](https://github.com/z0gSh1u)

# TypeScript 中的 never 类型

![图片源自 [Unsplash](https://unsplash.com/s/photos/never?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 由 [Kristopher Roller](https://unsplash.com/@krisroller?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 发布](https://cdn-images-1.medium.com/max/9646/1*p6LlQrG79vtjZfGpeXdBBw.jpeg)

正如 `never` 的中文释义所示，TypeScript 中的 `never` 类型表示的是值永远不会出现的一种类型。例如：

```ts
type A = 'A';
type B = 'B';
type C = A & B;
```

联合类型 `C` 是类型 `A` 和类型 `B` 的交集，这意味着其类型值同时等于 `A` 和 `B`。这种类型定义叫做联合类型，在 TypeScript 中是支持的，但是该例子的写法表示类型 `C` 的值同时等于 `A` 和 `B`，显然这是不可能达到的条件，所以这里类型 `C` 就是 `never` 类型。

![](https://cdn-images-1.medium.com/max/2000/1*X1y39jBeMMstRMhcI9HbQw.png)

可以把类型信息看成是一系列元素的集合，类型 `A` 相当于集合 `{'A'}`，类型 `B` 相当于集合 `{'B'}`，类型 `C` 相当于集合 `{}`，而类型 `never` 则对应一个空集合。

`never` 类型可以用于声明函数的返回值类型，表示该函数不会有任何返回值。

```ts
function a(): never {
  throw new Error('error');
}
```

当然，`void` 类型也可以用于声明函数的返回值类型来表示函数没有任何返回值，但是 `void` 所表示的意思就不那么明确了。使用 `void` 的话，函数是可以返回 `undefined` 的，而采用 `never` 则不允许函数返回 `undefined`。

```ts
function a(): void {
  return undefined; // 一切正常
}

function b(): never {
  return undefined; // 类型 'undefined' 不能分配给类型 'never'
}
```

使用函数表达式创建的无返回值的函数在不指定函数返回值类型时，TypeScript 将自动推断其返回值类型为 `never` 类型。

![](https://cdn-images-1.medium.com/max/2000/1*b-xts50tX-zOGjIH2OEOQw.png)

但是，上述情况中如果采用函数声明创建函数，其返回值类型将会被推断为 `void` 类型。

![](https://cdn-images-1.medium.com/max/2000/1*wejYn3jah0h8PQuCdyaiKQ.png)

这并非是 TypeScript 的 bug，之所以设计成这样是出于对向后兼容的考虑。现存的很多库中有大量抽象函数定义的返回值类型信息并没有明确指定为 `void`。由于这些函数是抽象的（抽象函数仅有类型信息，无函数功能实现），函数的具体实现交给了库使用者，使用者在实现过程中可自由决定函数是否有返回值。如果这种情况下函数类型被 TypeScript 推断为 `never`，则表示函数实现不能有返回值（函数实现中不可出现 `return` 关键字），很显然这样就出现了冲突，导致函数的实现无法被正确重写。

```ts
class AbstractClass {
    methodToBeOverriden() { // TypeScript 推断其返回类型为 void
        throw new Error('Not implemented!');
    }
}
```

因此，在实际项目开发中，不能完全依赖于 TypeScript 的类型推断系统来帮助我们生成正确的类型信息。当需要明确表明函数无返回值时，需要将其返回值类型指定为 `never`。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
