> * 原文地址：[TypeScript — JavaScript with superpowers](https://medium.freecodecamp.org/typescript-javascript-with-super-powers-a333b0fcabc9)
> * 原文作者：[Indrek Lasn](https://medium.freecodecamp.org/@wesharehoodies?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/typescript-javascript-with-super-powers.md](https://github.com/xitu/gold-miner/blob/master/TODO/typescript-javascript-with-super-powers.md)
> * 译者：
> * 校对者：

# TypeScript — JavaScript with superpowers

![](https://cdn-images-1.medium.com/max/800/1*aOhXVPhLT8tZLYQu62HcPA.png)

Javascript is cool. But do you know what’s even more cooler? Typescript.

#### Can you tell what’s wrong with this code?

![](https://cdn-images-1.medium.com/max/600/1*IgMNDPa6Oq8De5f7Pvnmnw.png)

![](https://cdn-images-1.medium.com/max/600/1*TV6Dyfy3Bmul2JPC7eyKaQ.png)

TypeScript (left) and ES6 (right).

**TypeScript can **— see that little red underline? That’s Typescript giving us a hint something is horribly gone wrong.

You probably figured this one out (good job) — `toUpperCase()` is a type of String method. We’re passing an integer as the argument, thus we can’t call `toUpperCase()` on an integer.

Let’s fix it by stating we can only pass the type String as an argument to our `nameToUpperCase()` method.

![](https://cdn-images-1.medium.com/max/800/1*N0xiNAjnnX3CijE82PpTjA.png)

Great! Now instead of having to remember `nameToUpperCase()` only accepts a String, we can trust Typescript to remember it. Imagine having to remember thousands, if not — tens of thousands methods and all the argument types. Bananas!

We still see red though. Why? Cause we’re still passing an integer! Let’s pass a String now.

![](https://cdn-images-1.medium.com/max/800/1*4JtcPUxZ7NPyf5gxhPqs2Q.png)

Notice TypeScript gets compiled to Javascript (it’s just a superset of Javascript, much like C++ to C).

That’s the a big-big argument why TypeScript and type checking is great.

![](https://cdn-images-1.medium.com/max/800/1*AgAGlFdiYSiYKZLW9fNvuw.png)

TypeScript had **10,327,953** downloads in the last month.

![](https://cdn-images-1.medium.com/max/1000/1*12nXNNgYHMLqWl7FWe4mwQ.png)

Typescript downloads compared to Flow downloads.

Let’s explore the TypeScript world — we’ll take a deep dive later, but first let’s understand what exactly Typescript is and why it exists.

[TypeScript first appeared on 1st of October, 2012\.](https://en.wikipedia.org/wiki/TypeScript) It’s being developed by Microsoft, lead by [Anders Hejlsberg](https://en.wikipedia.org/wiki/Anders_Hejlsberg) (lead architect of [C#](https://en.wikipedia.org/wiki/C_Sharp_%28programming_language%29)) and his team.

[TypeScript](https://www.typescriptlang.org/) is completely [open sourced on GitHub](https://github.com/Microsoft/TypeScript), so anyone can read the source code and contribute.

![](https://cdn-images-1.medium.com/max/800/1*4DNoN1QejqOlOFNft6teuw.png)

TypeScript — JavaScript that scales.

### How to get started

It’s simple actually — all we need is a NPM package. Open your terminal and type the following:

```

npm i -g typescript && mkdir typescript && cd typescript && tsc --init
```

We should end up with the Typescript config.

![](https://cdn-images-1.medium.com/max/1000/1*0a1jcXX5gYTRnVCkgisYbQ.png)

All we need to do is create a `.ts` file and tell the Typescript compiler to watch for changes.

```
touch typescript.ts && tsc -w
```

**tsc **— typescript compiler.

#### This is we what we should end up with

![](https://cdn-images-1.medium.com/max/1000/1*ervvuE5kcy2isO1zTDL_0w.png)

Great — now you can follow along with our examples!

We write the code in `.ts` files, the `.js` is the compiled version for the browser to read. In this case we don’t have a browser, we’re using Node.js (so the `.js` is for Node to read).

![](https://cdn-images-1.medium.com/max/800/1*6VLCkqegvidS5dJm-e7zSA.png)

Javascript has seven data types which 6 are primitives, the the rest are defined as objects.

#### **Javascript primitives are the following:**

*   _String_
*   _Number_
*   _Undefined_
*   _Null_
*   _Symbol_
*   _Boolean_

#### What’s left are called [_objects_](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object)

*   [Functions are first class objects](https://en.wikipedia.org/wiki/Function_object#In_JavaScript)
*   [Arrays are special objects](https://stackoverflow.com/a/5048482/5073961)
*   [Prototypes are objects](http://raganwald.com/2015/06/10/mixins.html)

![](https://cdn-images-1.medium.com/max/800/1*9FeYC-4ZEsKAQ565pEdTqw.png)

Typescript shares the same basic types with Javascript but have a couple extra types in the bag.

The extra types are optional and you don’t have to use them if you’re not familiar with them. I’ve found that’s the beauty of Typescript, it doesn’t use much force and is not as restrictive.

### The extra types are the following:

![](https://cdn-images-1.medium.com/max/800/1*QlcVGtDb2FVJjkQRIh6gLQ.png)

Imagine tuples as organized arrays. You predefine the types in the correct order.

![](https://cdn-images-1.medium.com/max/800/1*tF_IxeUVobcsA2BiBbConA.png)

unorganized array vs tuple (organized array).

If we don’t follow the sorting index rules we issued for our tuple, Typescript will hint us we didn’t go by the rules

![](https://cdn-images-1.medium.com/max/800/1*6LvBeYZZrPTaxNIBkzQKAQ.png)

The tuple expects the first value to be a `number` — but it’s not in this case, it’s a string `"Indrek"` and thus giving us an error.

* * *

![](https://cdn-images-1.medium.com/max/800/1*Bto4sAfIzfV3EIyYS04JmA.png)

In Typescript, you have to define the return type in your functions. Like so:
There are functions which don’t have a `return` statement;

![](https://cdn-images-1.medium.com/max/800/1*AboEEgZSSq9YvI-Y6KLBgA.png)

Notice how we declare the argument type AND the return type — both are strings.

Now what happens if we don’t return anything? Real world example would be a `console.log` statement inside the functions body.

![](https://cdn-images-1.medium.com/max/800/1*EI69g4tgKBUJYp6BZkignQ.png)

We can see the Typescript compiler telling us: “Hey, you didn’t return anything but you **explicitly** said we HAVE to return a string. I’m just letting you know that we didn’t follow the rules.”

So what if we don’t want to return anything? Let’s say we have a callback in our function. We use the `Void` return type in such situations.

![](https://cdn-images-1.medium.com/max/800/1*JJdm0IAG6MOvVwKh-XUS-w.png)

But in case we do return a value, implicitly or explicitly, we can’t have the return type of `Void`

![](https://cdn-images-1.medium.com/max/800/1*LYPDIzRpqPZtg03qMz_5SQ.png)

* * *

![](https://cdn-images-1.medium.com/max/800/1*DHGUJYw9MdbnobyC1wf0Pg.png)

The any type is very simple. We simple don’t know what type we’re dealing with so it might as well be `any`

For example;

![](https://cdn-images-1.medium.com/max/800/1*aDKDyw7uN7cbA7QMjpm3GA.png)

Notice how we’re reassigning the person’s type around so many times. First it’s a string, after a number and finally a boolean. We simply can’t be sure of the type.

Real world examples would be if you’re using a 3rd party library and you don’t know the types.

Let’s take an array. You pull some data from an API and store it in the array. The array consists of random data. It won’t consist of only strings, numbers nor will it have a organized structure like a tuple. `Any` type comes to the rescue!

![](https://cdn-images-1.medium.com/max/800/1*nDGWiVcZHWXRPT3NMqHeuQ.png)

If you know the array only consists of one type, you can explicitly state that to the compiler, like so:

![](https://cdn-images-1.medium.com/max/800/1*AT2v5vHOq9_kuraL2E2hnA.png)

While this article is gaining length, we’ll continue in the next chapter. We still have to cover couple last basic types — `enum` — `never` — `null` — `undefined` and special case `type assertions`.

[Here’s the docs in case you’re interested in learning more.](https://www.typescriptlang.org/docs/handbook/basic-types.html)

You might find more interesting articles on my Medium profile

Since everyone asks me what tools I used for the screenshots in this article, I use **Visual Studio Code**, and the **Ayu Mirage** theme withthe **Source Code Pro** font.

- [**Indrek Lasn - Medium**: Read writing from Indrek Lasn on Medium. Merchant of happiness, founder @ https://vaulty.io, growth/engineering @… medium.com](https://medium.com/@wesharehoodies)

Or you can follow me on twitter for updates. ❤

- [**Indrek Lasn (@lasnindrek) | Twitter**: The latest Tweets from Indrek Lasn (@lasnindrek). business propositons: lasnindrek@gmail.com. Zurich, Switzerland twitter.com](https://twitter.com/lasnindrek)

Thanks for reading and taking the time! I appreciate and you’re awesome!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
