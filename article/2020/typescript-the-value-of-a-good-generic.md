> * 原文地址：[TypeScript: The Value of a Good Generic](https://blog.bitsrc.io/typescript-the-value-of-a-good-generic-bfd820d52995)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/typescript-the-value-of-a-good-generic.md](https://github.com/xitu/gold-miner/blob/master/article/2020/typescript-the-value-of-a-good-generic.md)
> * 译者：
> * 校对者：

# TypeScript: The Value of a Good Generic

![](https://cdn-images-1.medium.com/max/2560/1*C-321Bvdsq6Oz4-rtFOMMw.jpeg)

In software development, we’re always striving to create components that are reusable, architectures that can adapt to multiple situations and we’re always looking for a way to automate our logic in a way that it can behave correctly even upon the face of the unknown.

And although that might not always be easy or even doable in some situations, our mindset is always set to find patterns that can be reproduced and then turned into a generic algorithm that will be able to tackle it. And the concept of **Generics** is another example of that behavior, only this time, instead of going macro, we’re going micro and we’re trying to find and represent patterns at the code level.

**Let me explain…**

## What are Generics?

The concept of Generics is a fun one once you’re able to wrap your head around it, so let me just start by putting it like this:

> Generics are to Types, what Types are to Variables

In other words, Generics provide you with a way of using Types without having to specify one. This provides a new level of flexibility over your Functions, Classes, and even Interface definitions.

The classic example of this used to explain the power of a Generic, is the identity function. This function essentially returns whatever you pass as a parameter, there is nothing fancy about, but if you think about it, how can you define such a function in a typed language?

```TypeScript

function identity(value: number):number {
  return value;
}
```

The above function works great for numbers, but what about strings? Or booleans? What about custom types? These are all possibilities inside TypeScript, so the obvious choice is to go with the `any` type:

```TypeScript

function identity(value: any): any {
  return value
}
```

This works, kinda, but now your function has actually lost all concept of type, you’re not able to use the information of the actual type used for anything. Essentially you can now write something like this and the compiler will not say anything, it’ll be just like if you were using plain JavaScript (i.e with no type information whatsoever):

```TypeScript

let myVar = identity("Fernando")

console.log(myVar.length) //this works great!

myVar = identity(23)

console.log(myVar.length) //this also works, although it prints "undefined" 

```

Now since we don’t have type information, the compiler is unable to check anything related to our function and our variable, thus we’re running into an unwanted “undefined” (which if we extrapolate this example into a real-world scenario with more complex logic would probably turn into the worst problem).

How do we fix this then and avoid using the `any` type?

---

Tip: **Share your reusable components** between projects using [**Bit**](https://bit.dev/) ([Github](https://github.com/teambit/bit)). Bit makes it simple to share, document, and organize independent components from any project**.**

Use it to maximize code reuse, collaborate on independent components, and build apps that scale.

[**Bit**](https://bit.dev/) supports Node, TypeScript, React, Vue, Angular, and more.

![Example: exploring reusable React components shared on [Bit.dev](https://bit.dev/)](https://cdn-images-1.medium.com/max/NaN/0*q1LXHfxl5dnY4pmi.gif)

---

#### TypeScript Generics to the Rescue

Like I **tried** to say before: a Generic is like a variable for our types, which means we can define a variable that represents any type, but that keeps the type information at the same time. That last part is key, because that’s exactly what `any` wasn’t doing. With this in mind, we can now re-define our identity function like this:

```TypeScript

function identity<T>(value: T): T {
  return value;
}
```

Keep in mind, the letter used for the name of the Generic can be anything, you can name it however you want. Using a single letter, however, seems to be a standard, so we’re all going with it.

This now allows us to not only define a generic function that can be used with any type but also, the associated variables will contain correct information about the type you’ve chosen. Like this:

![](https://cdn-images-1.medium.com/max/2528/1*vEtpGm9L-Zh95Nso4KDWaA.png)

Two things to notice about the image:

1. I’m specifying the type directly after the function’s name (between \< and >). In this case, since the function’s signature is simple enough, we could’ve called the function without this and the compiler would’ve inferred the type from the parameter passed. Nevertheless, if you change the word `number` for `string` then the entire example would no longer work.
2. We now can’t print the `length` property, since numbers don’t have it.

This is the behavior you’d expect from a typed language and this is why you want to use Generics when defining **generic** behavior.

## What else can I do with Generics?

The previous example is commonly known as the **“Hello World”** of Generics, you’ll find it on every article, but it’s a great way to explain their potential. But there are other interesting things you can achieve, always within the realm of type-safety of course, remember, you want to build things that can be re-used in multiple situations and at the same time, you’re trying to hold on to that type information we care about so much.

#### Automatic structure checks

This one has got to be my favorite thing to do with generics. Consider the following scenario: you have a fixed structure (i.e an object) and you’re trying to access a property of if dynamically. We’ve all done it before, something like:

```JavaScript

function get(obj, prop) {
  if(!obj[prop]) return null;
  return obj[prop]
}
```

I could’ve used `hasOwnProperty` or something like that, but you get the point, you need to perform a basic structural check to make sure you control the use case in which the property you’re trying to access does not belong to the object. Now, let’s move this into the type-safety land of TypeScript and see how Generics can help us:

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

Now, notice how I’m using the Generics notation: I’m not only declaring a generic type K, but I’m also saying it **extends the type of a key of Person.** This is amazing! You can declaratively state you’re either going to pass a value that matches the strings `name` , `age` or `city`. Essentially you declared an enum, which if you think about it, is less exciting than before. But you don’t have to stop there, you can make this more exciting by re-defining this function like this:

```TypeScript
function get<T, K extends keyof T>(p: T, key: K): any {
    return p[key]
}
```

That’s right, we now have TWO generic types, one of them is declared to be extending the keys of the first one, but essentially you’re now no longer restricted to just one type of objects (i.e `Person` -type objects) and this function can be used with any of your objects or structures and you know it’ll be safe to use.

And here is what happens if you use it with an invalid property name:

![](https://cdn-images-1.medium.com/max/3168/1*_qg66UiR4WmF4k7FXthRFQ.png)

#### Generic classes

Generics don’t only apply to function signatures, you can also use them to define your own generic classes. This allows for some interesting behavior and the ability to again, encapsulate that generic logic into a re-usable construct.

Here is an example:

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
class HorseHandler extends Handler<Horse> {
```

With this example, we’re defining a handler that can handle any type of animal, but we can do that without Generics, the benefit here can be seen in the last two lines of the example. This is because with the generic handler logic completely encapsulated inside a generic class, we can then easily constraint the types and create type-specific classes that will only work for either type of animal. You could potentially add extra behavior here as well, and type information would be kept.

Another takeaway from this example is that generic types can be constrained to only extend certain groups. As you can see in the example, `T` can only be wither `Dog` or `Horse` but nothing else.

#### Variadic Tuples

This is actually something new that was added in version 4.0 of TypeScript. And although I did [already covered it in this article](https://blog.bitsrc.io/typescript-4-0-what-im-most-excited-about-4ee89693e02e), I’ll quickly review it here.

In a nutshell, what Variadic Tuples allow you to do, is to use Generics to define a variable portion of a tuple definition, which by default, has none.

A normal tuple definition would yield a fixed-size array with predefined types for all of its elements:

```
type MyTuple = [string, string, number]

let myList:MyTuple = ["Fernando", "Doglio", 37]
```

Now, thanks to Generics and Variadic Tuples, you can do something like this:

```TypeScript

type MyTuple<T extends unknown[]> = [string, string, ...T, number]

let myList:MyTuple<[boolean, number]> = ["Fernando", "Doglio", true, 3, 37]
let myList:MyTuple<[number, number, number]> = ["Fernando", "Doglio", 1,2,3,4]
```

If you notice, we used a Generic `T` (which extends an array of `unknown`) to put a variable section inside the tuple. Since `T` is a list of `unknown` type, you can put anything in there. You could, potentially, define it to be a list of a single type, like this:

```TypeScript

type anotherTuple<T extends number[]> = [boolean, ...T, boolean];

let oneNumber: anotherTuple<[number]> = [true, 1, true];
let twoNumbers: anotherTuple<[number, number]> = [true, 1, 2, true]
let manyNumbers: anotherTuple<[number, number, number, number]> = [true, 1, 2, 3, 4, true]
```

Sky is the limit here, essentially you can define a form of template tuple, which you can use later down the road and extend it however you see fit (with the limitations you set for the template of course).

## Conclusion

Generics is a very powerful tool and although sometimes reading code that makes use of them might feel like reading hieroglyphs, it’s just a matter of taking it slow at first. Take your time, parse the code mentally and you’ll start seeing the potential built-in inside it.

So what about you? Have you used Generics in the past? Did I leave a major use for the out? Share it in the comments for others!

**See you in the next one!**

## Learn More
[**React TypeScript: Basics and Best Practices**
**An updated handbook/cheat sheet for working with React.js with TypeScript.**blog.bitsrc.io](https://blog.bitsrc.io/react-typescript-cheetsheet-2b6fa2cecfe2)
[**11 JavaScript and TypeScript Shorthands You Should Know**
**Some very useful (and sometimes cryptic) JS/TS shorthands to use or at least understand when reading others’ code.**blog.bitsrc.io](https://blog.bitsrc.io/11-javascript-and-typescript-shorthands-you-should-know-690a002674e0)
[**4 New Exciting Features Coming in ECMAScript 2021**
**Let’s face it, 2020 has probably earned its place in the top 5 worst years in history list. And don’t get me wrong, we…**blog.bitsrc.io](https://blog.bitsrc.io/the-4-new-features-coming-in-ecmascript-2021-6fa24684b99b)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
