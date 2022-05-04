> * 原文地址：[TypeScript 4.0 finally delivers what I’ve been waiting for](https://medium.com/javascript-in-plain-english/typescript-4-0-i-want-a-list-of-generic-params-with-good-labels-c6087d2df935)
> * 原文作者：[Nathaniel Kessler](https://medium.com/@nathanielkessler)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/typescript-4-0-i-want-a-list-of-generic-params-with-good-labels.md](https://github.com/xitu/gold-miner/blob/master/article/2020/typescript-4-0-i-want-a-list-of-generic-params-with-good-labels.md)
> * 译者：[rocwong-cn](https://github.com/rocwong-cn)
> * 校对者：[Inchill](https://github.com/Inchill)、[Samuel Jie](https://github.com/suhanyujie)

# TypeScript 4.0 终于发布了我一直在等待的东西

昨天，微软官宣了 [TypeScript 4.0 的候选版本](https://devblogs.microsoft.com/typescript/announcing-typescript-4-0-rc)。然后随之而来的 [具标签的元组元素（Labeled Tuple Elements）](https://devblogs.microsoft.com/typescript/announcing-typescript-4-0-rc/#labeled-tuple-elements)，就成为了这篇文章标题的答案。

![具有有用标签的参数和具有无用标签的参数](https://cdn-images-1.medium.com/max/2148/1*G00zmJivkNGN1L6fDo9vnQ.png)

## 具有未知参数的泛型接口

这是一个人为的例子。`IQuery`，它旨在描述查询事物的函数的形状。它总是返回一个 Promise 并且使用一个 [泛型](https://www.typescriptlang.org/docs/handbook/generics.html) 来描述这个 Promise 发出的内容（`TReturn`）。该接口对于没有参数或者未知数量的参数（`UParams extends any[] = []`）的场景也足够灵活。

```ts
interface IQuery<TReturn, UParams extends any[] = []> {
  (...args: UParams): Promise<TReturn>
}
```

#### 示例函数：findSongAlbum()

利用此接口，我们将编写一个根据标题和歌手查找对应歌曲专辑的函数。它返回一个发出 `Album` 类型的单个对象的 Promise。

```ts
type Album = {
  title: string
}
```

不使用 TypeScript，该函数可能如下所示：

```js
const findSongAlbum = (title, artist) => {
  // 一些获取数据的代码...
  
  const albumName = '1989';

  return Promise.resolve({
     title: albumName
  });
}
```

使用 TypeScript 并利用 `IQuery` 接口，你可以将 `Album` 类型作为第一个泛型参数传递，以确保 Promise 触发返回的数据类型始终与 Album 类型匹配。

```ts
const findSongAlbum: IQuery<Album> = (title, artist) => {
  // 一些获取数据的代码...
  
  const albumName = '1989';

  return Promise.resolve({
     title: albumName
  });
}
```

#### TypeScript 4.0 发布以前

你还想定义其他参数及其类型。在这种情况下，`title` 和 `artist` 都是字符串。你定义了一个新类型 `Params`，并将其作为 `IQuery` 的第二个参数传递。

在示例中，**TypeScript 4.0 发布以前**，`Params` 将会被定义成一个类型列表。列表中定义的每一项都和参数列表中顺序一致。这种类型的输入称为 [元组](https://www.typescriptlang.org/docs/handbook/basic-types.html#tuple) 类型。

```ts
type Params: [string, string]

const findSongAlbum: IQuery<Album, Params> = (title, artist) => {
  // 一些获取数据的代码...
  
  const albumName = '1989';

  return Promise.resolve({
     title: albumName
  });
}
```

您可以在上面的 `Params` 类型中看到，第一项类型是 `string`，使第一个参数 “title” 的类型成为 `string`。第二项，当然，遵循相同的模式，也是 `string` 使第二个参数 “artist” 的类型成为了 `string`。这将为我们的参数列表提供适当的类型安全。

![findSongAlbum() 函数展示无用的参数标签](https://user-images.githubusercontent.com/5164225/90373125-09174600-e0a4-11ea-8290-c7a976da28d8.gif)

不幸的是，当你在函数中以这种方式使用元组类型时，它并不会提供有用的类型安全**标签**。相反，它只是将参数列出为 args_0: string，args_1: string。除了知道第一个参数是 `string` 之外，"arg_0” 并没有告诉我第一个参数应该是我要搜索的歌曲的 “title”。

#### TypeScript 4.0 之后

使用 TypeScript 4 候选版本，我们可以获得**具标签元组元素（Labeled Tuple Elements）**，我们可以使用它来获取参数列表中的有用标签。

现在，`Params` 类型的每项都会获得一个标签，只要您使用 `findSongAlbum` 函数，该标签就会在您的 IDE 中很好地显示出来。

```ts
type Params: [title: string, artist: string]

const findSongAlbum: IQuery<Album, Params> = (title, artist) => {
  // 一些获取数据的代码...
  
  const albumName = '1989';

  return Promise.resolve({
     title: albumName
  });
}
```

![findSongAlbum() 展示有价值的参数标签](https://user-images.githubusercontent.com/5164225/90373135-0c123680-e0a4-11ea-8e49-4467ee3345e8.gif)

现在，我们在智能提示中得到的是 `title: string`，而不是 `arg_0: string`，它告诉我们需要传递的是**什么内容**的字符串。

感谢您的阅读 ❤

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
