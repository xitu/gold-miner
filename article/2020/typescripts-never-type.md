> * 原文地址：[TypeScript’s never Type](https://levelup.gitconnected.com/typescripts-never-type-d5f28271fcd6)
> * 原文作者：[Dornhoth](https://medium.com/@dornhoth)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/typescripts-never-type.md](https://github.com/xitu/gold-miner/blob/master/article/2020/typescripts-never-type.md)
> * 译者：
> * 校对者：

# TypeScript’s never Type

![Photo by [Kristopher Roller](https://unsplash.com/@krisroller?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/never?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/9646/1*p6LlQrG79vtjZfGpeXdBBw.jpeg)

As its name indicates, TypeScript’s `never` type is the type of values that never occur. For example:

```ts
type A = 'A';
type B = 'B';
type C = A & B;
```

The type `C` is the intersection of `A` and `B`. To be of type `C`, an element would have to be equal to `'A'` and to `'B'`, this is impossible so `C` is `never`.

![](https://cdn-images-1.medium.com/max/2000/1*X1y39jBeMMstRMhcI9HbQw.png)

If you think of types as sets of elements, `A` corresponds to the set `{'A'}` , `B` to the set `{'B'}` and `C` to the set `{}`. `never` is the type corresponding to the empty set.

`never` can be used as a return type for a function to declare that the function doesn’t return anything.

```ts
function a(): never {
  throw new Error('error');
}
```

You would maybe use `void` in a such case, but `void` is less specific. `void` allows a function to return `undefined`, whereas `never` doesn’t.

```ts
function a(): void {
  return undefined; // this is OK
}

function b(): never {
  return undefined; // Type 'undefined' is not assignable to type                 
}                      'never'
```

The type `never` is inferred by TypeScript on function expressions that don’t return anything:

![](https://cdn-images-1.medium.com/max/2000/1*b-xts50tX-zOGjIH2OEOQw.png)

But TypeScript will not infer it on function declarations, it will instead infer the type `void`.

![](https://cdn-images-1.medium.com/max/2000/1*wejYn3jah0h8PQuCdyaiKQ.png)

This is not a bug. This was done to ensure backward compatibility. A lot of abstract functions out there that require the user to implement them don’t implicit declare the return type to be `void`. If TypeScript were to infer the type `never`, these functions couldn’t be overridden correctly anymore.

```ts
class AbstractClass {
    methodToBeOverriden() { // the intended type is probably void
        throw new Error('Not implemented!');
    }
}
```

You should in this case not rely on TypeScript’s type inference to set the correct type for you. To ensure that the function doesn’t return anything, you should explicitly declare the return type to be `never`.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
