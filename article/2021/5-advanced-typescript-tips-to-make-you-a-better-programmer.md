> * 原文地址：[5 Advanced TypeScript Tips To Make You a Better Programmer](https://levelup.gitconnected.com/5-advanced-typescript-tips-to-make-you-a-better-programmer-bd4070aa2ab4)
> * 原文作者：[Anthony Oleinik](https://medium.com/@anth-oleinik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-advanced-typescript-tips-to-make-you-a-better-programmer.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-advanced-typescript-tips-to-make-you-a-better-programmer.md)
> * 译者：
> * 校对者：

# 5 Advanced TypeScript Tips To Make You a Better Programmer

![Beautiful :)](https://cdn-images-1.medium.com/max/3200/0*RKICUYO863Mu_2mX.png)

Typescript is an amazing language — one that allows us to do everything JavaScript can in a tenth of the debugging time. These tips will mostly be for:

* reducing bugs, by writing more explicit and understandable code
* pack more value into your code without reinventing the wheel.

Here’s 5 advanced TypeScript tips that will allow you to write better TypeScript Code.

#### 1. The “is” operator / Type Guards

Swagger is really, really helpful to see what the backend is going to serve you — but, more often than not, programmers are given bad or inconsistant API’s to use, where properties may or may not exist or different objects are returned depending on status.

Unfortunately, there’s no way to catch these at compile time if you don’t know what might come out of the API, but we can make it easy to handle (and report!) at runtime.

API’s are often an entrypoint for errors for typescript — API call results are usually casted like the following:

```ts
const myApiResult = await callApi("url.com/endpoint") as IApiResult
```

or even worse…

```ts
const myApiResult = await callApi("url.com/endpoint") as any
```

both of these shut the compiler up, but the first is significantly more robust than the second — infact, the second just turns anything you do with the result to JavaScript levels of uncertainty.

But what if the API gives us something that isn’t a `IApiResult` ? What if it returns something different, and now we have a random object type casted as `MyApiResult` ? That would be bad, and would 100% lead to type errors down the line.

We can utilize TS Type Guards:

```ts
interface IApiResponse { 
   bar: string
}

const callFooApi = async (): Promise<IApiResponse> => {
 let response = await httpRequest('foo.api/barEndpoint') //returns unknown
 if (responseIsbar(response)) {
   return response
 } else {
   throw Error("response is not of type IApiResponse")
 }
}

const responseIsBar = (response: unknown): response is IApiResponse => {
    return (response as IApiResponse).bar !== undefined
        && typeof (response as IApiResponse).bar === "string"
}
```

By using `responseIsBar` , we can guarantee that we don't preemptively cast the response to the `IApiResponse` , preventing errors down the line.

In a realistic use case, you might show the user an error like “Got unexpected response from server, please try again” or something similar, instead of `property 'bar' does not exist` .

As a generic explication to the “is” operator: `value is type` is actually a boolean, that when inputting true, tells typescript that value… well, is type.

#### 2. As Const / Readonly

This one is a simpler, more syntactic sugar type thing. Most people know that when assigning an interface, you can write “readonly” to make that property immutable.

```ts
interface MyInterface {
  readonly myProperty: string
}

let t: MyInterface = {
  myProperty: 'hi'
}

t.myProperty = "bye" //compiler err, saying myProperty is Read Only.
```

this is great, until you end up with really big data classes, maybe from API results. Then you have a readonly spam before every single property, just for a simple data class.

Typescript supports “as const” after a declaration so that we add readonly to every single property.

```ts
let t = {
 myProperty: "hi" 
 myArr: [1, 2, 3]
} as const 
```

Now, every property of T is immutable. for instance, `t.myArr.push(1)` won’t compile, and reassigning `myProperty` similarly won’t compile.

The usecases where I see this being the most helpful is the same as the previous — instead of returning an interface, though, we just want to proxy the object called from the API and change some properties around, making it a data object. So, combining with the previous tip:

```ts
const callFooApi = async () => {
 let response = await httpRequest('foo.api/barEndpoint') //returns unknown
 if (responseIsbar(response)) {
   //filter out unecessary data, do whatever formatting is required
   return {
      firstLastName: [response.firstName, response.lastName]
   } as const
 } else {
   throw Error("response is not of type IApiResponse")
 }
}
```

Any programmer working with this would cry tears of joy — there’s still intellisense on the return value (the types are derived from the `response `variable), but it’s immutable. We called the API, verified the response is what we expect it to be, and then return it in an easy to consume way. It’s a win for everyone!

As a little side bar, if you do feel like declaring the type, but don’t want to readonly spam it, you can do: type MyTypeReadonly = Readonly\<MyType> . We’ll get to this more in depth later, in point 5.

#### 3. Exhaustive Switch Case

Extending enums is often a pain due to switch cases — anywhere where we switched on that enum, we now need to add another case. If we missed one, we’re straight out of luck and our program will go to the default case (if there is one) or fall through, often causing unintended behavior.

No one likes unintended behavior.

Many languages solve this by forcing switch cases to either be exhaustive, or have an explicit `default` state. Typescript doesn’t have compiler support for that, but we can create our switch cases in such a way that if we extend an enum or a possible value, our program won’t compile until we explicitly handle that case.

Say we have a situation like this:

```ts
enum Directions {
   Left,
   Right
}

const turnTowards = randomEnum(Direction)

switch (turnTowards) {
      case Directions.Right:
         console.log('we\'re going right!')
         break
      case Directions.Left:
         console.log('Turning left!')
         break
}
```

Even the most rookie programmer can say that we are turning either left, or right. Adding a default statement in here isn’t necessary, there’s only two enums. Remember, though, that we’re not coding just to get it done, but to write maintainable code!

Say in two years, a developer decides to add a new direction: Forward. Now, the enum looks like this:

```ts
enum Directions {
   Left,
   Right,
   Forward
}
```

The switch case knows that, but it **doesn’t care.** it will happy attempt to switch on `goingTowards` , and it will happily fall though if it encounters a forward. Two years is a long time, and the developer forgot about the switch case existing. We can add a default case that throws an error, but runtime errors are bad compared to compiletime.

so we add this default case:

```ts
default:
   const exhaustiveCheck: never = myDirection
   throw new Error(exhaustiveCheck)
```

If we handled the “Forward” direction, then all is well. If we didn’t then our program won’t even compile! (the `throw` line is optional, I just do it to shut eslint up about unused vars)

This reduces the mental overhead of remembering every single time we decide to switch on the enum, and let the compiler find them for us.

#### 4. Use Null instead of ? operator

Many people coming from other languages will think that null === undefined, but that’s simply not the case (don’t worry, this tip gets better!).

Undefined is something that JS can assign — for example, if we have a textbox and no value is inputted, then it would be undefined. Think of undefined as JS’s automatic null.

It can be pretty difficult to tell if a field is undefined by design, or if we accidentally left it that way. If I ever intentionally want to leave to value for a field, I’ll use null. That way, everyone knows that that field is intentionally left blank.

Here’s an example:

```ts
interface Foo {
   bar?: string
}
```

property bar ends with a question mark, which means that the field can be undefined, so doing `let baz: Foo = {}`compiles (as an added note, `let baz: Foo = {bar: null} `also compiles). Developers down the line, though, might not know if I intentionally left bar blank, or if I accidentally did. A better way to broadcast my intentions would be to create my interface like this:

```ts
interface Foo {
  bar: string | null
}
```

and now, we have to **explicitly state that bar is null.** There can be no confusion about my intention — bar was meant to not have a value.

This isn’t only good for declaring interfaces — I also use it when it’s possible to return nothing from a function. This helps at compile time:

```ts
//if we forget to return something, compiler will let 
const myFunc = (): string | void => {
   console.log('blah')
}

//if we forget to return, the compiler makes us return null
const myFunc = (): string | null => {
 //compile time error for not returning null
}
```

#### 5. Utility Types

If you’ve worked with large TS projects, you know that interfaces are everywhere. Some exact duplicates of others with another name, some duplicates with some properties of others, some interfaces with combined properties.

If that’s the case, don’t be alarmed. You’re using TS as intended: safely. You might be writing too much code if you’re not utilizing the built in types, though. Here’s the [link for built in types that you should at least know exist](https://www.typescriptlang.org/docs/handbook/utility-types.html), so that you can utilize them in your code.

I’ll go through my favorites and the ones I use the most, but the more you know, the better you can make your code.

**Partial**

Sets all of the types fields to optional. This is useful when you want to perform updates on an object, like:

```ts
function updateBook<T extends Book>(book: T, updates: Partial<T>) {
   const updatedBook = {...book, ...updates }
   notifyServer(updatedBook)
   return updatedBook
}
```

**Readonly**

this one sets all the fields to readonly. I use this as a return value, mostly when returning data classes.

```ts
function generateData(): Readonly<T>
```

**NonNullable**

creates a new type that removes null / undefined. This is useful if we’re enriching or filling out some data, and we now guarantee it’s there.

```ts
interface IPerson {
  name: string
}

type MaybePerson = Person | null

const fillMaybePerson = (maybe: MaybePerson): NonNullable<MaybePerson> ...
```

**ReturnType**

Type is the return type of a function. useful if you’re writing an API over functions, and don’t want to constrain the functions.

```ts
const getMoney = (): number => {
  return 100000
}

ReturnType<getMoney> //number
```

**Required**

removes the ? from all fields of an interface.

```ts
interface T {
  maybeName?: string
}

type CertainT = Required<T> // equal to { maybeName: string }
```

---

And that’s it! If you see a mistake anywhere, please let me know ASAP so I can fix it before anyone else learns something incorrect. If you think that I’m missing something, then go ahead and let me know!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
