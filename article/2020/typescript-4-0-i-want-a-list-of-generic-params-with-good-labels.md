> * 原文地址：[TypeScript 4.0 finally delivers what I’ve been waiting for](https://medium.com/javascript-in-plain-english/typescript-4-0-i-want-a-list-of-generic-params-with-good-labels-c6087d2df935)
> * 原文作者：[Nathaniel Kessler](https://medium.com/@nathanielkessler)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/typescript-4-0-i-want-a-list-of-generic-params-with-good-labels.md](https://github.com/xitu/gold-miner/blob/master/article/2020/typescript-4-0-i-want-a-list-of-generic-params-with-good-labels.md)
> * 译者：
> * 校对者：

# TypeScript 4.0 finally delivers what I’ve been waiting for

Yesterday, Microsoft announced the [release candidate of TypeScript 4.0](https://devblogs.microsoft.com/typescript/announcing-typescript-4-0-rc). And with that comes [Labeled Tuple Elements](https://devblogs.microsoft.com/typescript/announcing-typescript-4-0-rc/#labeled-tuple-elements), which is the answer to the title of this post.

![Arguments with useful labels and arguments with useless labels](https://cdn-images-1.medium.com/max/2148/1*G00zmJivkNGN1L6fDo9vnQ.png)

## Generic interface with unknown arguments

Here’s a contrived example. `IQuery`. It’s meant to describe the shape of functions that query things. It always returns a promise and takes a [Generic](https://www.typescriptlang.org/docs/handbook/generics.html) to describe what the promise emits (`TReturn`). The interface is also flexible enough to take no arguments **or** an unknown number of arguments (`UParams extends any[] = []`).

```ts
interface IQuery<TReturn, UParams extends any[] = []> {
  (...args: UParams): Promise<TReturn>
}
```

#### Sample function: findSongAlbum()

Leveraging this interface, we’ll write a function that finds a song album by a title and an artist. It returns a promise that emits a single object of type `Album`.

```ts
type Album = {
  title: string
}
```

Without TypeScript, the function could look like this:

```js
const findSongAlbum = (title, artist) => {
  // data fetching code...
  
  const albumName = '1989';

  return Promise.resolve({
     title: albumName
  });
}
```

With TypeScript, and leveraging the `IQuery` interface, you’d pass in `Album` type as the first Generic parameter to ensure the shape of what the promise emits always matches `Album` type.

```ts
const findSongAlbum: IQuery<Album> = (title, artist) => {
  // data fetching code...
  
  const albumName = '1989';

  return Promise.resolve({
     title: albumName 
  });
}
```

#### Before TypeScript 4.0

You also want to define the parameters and what their types are. In this case `title` and `artist` are both strings. You define a new type, `Params`, and pass that as the second Type for `IQuery`.

On the example, **before TypeScript 4.0**, `Params` would be defined as a list of types. Each item in the list defines the type in the same order as the list of arguments. This kind of typing is called [Tuple](https://www.typescriptlang.org/docs/handbook/basic-types.html#tuple) types.

```ts
type Params: [string, string]

const findSongAlbum: IQuery<Album, Params> = (title, artist) => {
  // data fetching code...
  
  const albumName = '1989';

  return Promise.resolve({
     title: albumName
  });
}
```

You can see in the `Params` type above, the first item type is `string` making the first argument “title” a `string`. The second, of course, following the same pattern, is `string` making the second parameter “artist” also a `string`. This will give us the proper type safety for the arguments list.

![findSongAlbum() showing useless argument labels](https://user-images.githubusercontent.com/5164225/90373125-09174600-e0a4-11ea-8290-c7a976da28d8.gif)

Unfortunately, using Tuple types this way doesn’t give useful type safe **labels** when you’re using the function. Instead it just lists the arguments as args_0: string, args_1: string. Besides knowing that the first argument is a `string`, “arg_0” doesn’t tell me that the first parameter should be the “title” of the song I’m searching for.

#### After TypeScript 4.0

With the TypeScript 4 release candidate we get **Labeled Tuple Elements** which we can use to get the useful labels in our parameter list.

Each item in the `Params` type now gets a label which will show up nicely in your IDE anytime you use the `findSongAlbum` function.

```ts
type Params: [title: string, artist: string]

const findSongAlbum: IQuery<Album, Params> = (title, artist) => {
  // data fetching code...
  
  const albumName = '1989';

  return Promise.resolve({
     title: albumName
  });
}
```

![findSongAlbum() showing valuable argument labels](https://user-images.githubusercontent.com/5164225/90373135-0c123680-e0a4-11ea-8e49-4467ee3345e8.gif)

Now, instead of `arg_0: string`, we get `title: string` in our intellisense which tells us **what** string we need to pass in.

Thanks for reading ❤

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
