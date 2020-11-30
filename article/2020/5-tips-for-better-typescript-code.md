> * 原文地址：[5 Tips for Better TypeScript Code](https://levelup.gitconnected.com/5-tips-for-better-typescript-code-5603c26206ef)
> * 原文作者：[Anthony Oleinik](https://medium.com/@anth-oleinik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-tips-for-better-typescript-code.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-tips-for-better-typescript-code.md)
> * 译者：
> * 校对者：

# 5 Tips for Better TypeScript Code

![5 Tips for Better TypeScript](https://cdn-images-1.medium.com/max/2000/1*VGWjFbzekvE7WD3e5fGQHQ.png)

JavaScript has a lot of problems. TypeScript has a lot of solutions — But some of them take a little bit of digging to find.

Very early in my frontend journey, I figured out that TypeScript was the solution to a lot of problems JavaScript had. Passing incorrect parameters, unorganized switches, or null access all came up daily during my development.

Adding a TypeScript layer on top of my JavaScript skyrocketed my productivity. I’ve been learning the ins and outs of TypeScript, and I’m here to share what I’ve learned with you.

## 1. Null Coalescence

Sometimes automatically, TypeScript will insert a question mark into a property access field. Something like `let t = myObj?.property `and then `t` ends up with the value: `property | undefined` . This is great, but it’s important to know exactly what’s happening here so that you can use it as a tool, rather than a byproduct of TypeScript autocomplete.

If we used a regular property access, `myObj.property` , and myObj was undefined, we’d get an error: Cannot access property 'property' of undefined. This clearly isn’t want we want, so using the `.?` means that if `myObj` is undefined, we “stop looking” there and just assign `t` as undefined.

This is incredibly useful to avoid errors, but sometimes we want a default case. For instance, what if we have a text field that the user never activates, and thus the inner text is undefined? We don’t want to send `undefined` to the backend. We can chain the **optional access operator** (what we just learned, `.?` ) with the **null coalescence operator.** It’d look something like this:

```ts
sendFieldToServer(textField?.text ?? '')
```

This is incredibly resilient code, that handles lots of cases very safely. Infact, it’s **impossible for undefined to be passed into the function.** TypeScript is aware of that, so if `sendFieldToServer` takes a property of `string` , it’d work!

This is because the null coalescence operator makes it so that if what is on the left-hand side is `undefined`, we instead pass in what’s on the right, an empty string.

In JavaScript, it’d be easy to forget all the places where your code could possibly be undefined. Thankfully, TS handles this and would warn you here that `sendFieldToServer` can’t take undefined. By using the question mark operators, you now have code that is 100% safe.

## 2. Don’t use default imports

One reason why TypeScript is superior to JavaScript is the code autocomplete. because in TypeScript, the compiler knows exactly what object you’re working with at the time, it knows exactly what properties are available to you. If you have a `dog` object, we know we can access the `bark()` method.

That is, if `dog` is in scope.

If we exported `dog` in `dog.ts` with a default export, like this:

```ts
default export interface Dog {
     bark: () => void,
}
```

then the import can be anything. I can import `dog` as `cat` from another file, if I’d like:

```ts
import cat from 'dog.ts'

cat.bark()
```

That’s valid TypeScript code. That means that if we do:

```ts
let t: dog = {
   bark: () => console.log('woof!')
}
```

TypeScript doesn’t know what `dog` is. There’ll be a little red line under `dog` saying `dog` is not defined. You’d have the find where dog was defined, and import it manually — and then make sure to name it dog.

This is where regular exports come in. Exporting `dog` like this:

```ts
export interface dog {..} //export without 'default'
```

Means that now, in our other file, when we type `let t: dog`, typescript knows to look for an interface called `dog`! That means that you’ll get the import placed in your file automatically, and that TypeScript knows that you can bark.

Code autocomplete is a great feature. I find that there’s no reason to prefer default export, as the regular export system is actually much more useful. Even if you’re only exporting one thing, regular export still handles that with a breeze.

eslint has a `no default export` rule that can make it so that any default export gets flagged.

## 3. Use constrained string fields

Enums are this planet's gift to programmers, so when JavaScript decided to not have enums, it went from an S tier language to a B at best.

While TypeScript has enums on its own, it might be surprising to say that… you don’t 100% need them. Enums add a little bit of overhead by having to define it. TypeScript has something even better.

```ts
t: "left" | "right" | "middle" = "middle"
```

This functionally operates as an enum. You can switch on it, you can’t assign t to anything but those 3 values. But we defined it in a single line, and TypeScript knows not to allow anything else in there. If I tried to do `t="center"` , TypeScript would error out. I can 100% be certain that the value of `t` is one of those 3 values, so I can do things like switch on those 3 strings and not have to worry about a default.

As a bonus, t is still **just a string.** So if we wanted to display the value to a user, we could pass it into string fields and it’d work just fine.

## 4. use Map\<T>

One thing JavaScript does have going for it is the flexible prototyping system. You can add any key onto any object without even batting an eye. myObj.nonExistantField = "Is This" + 12312 + "A string or a number? Who Cares!" * 4 is valid. But, let me in one some secrets…

1. It’s not fast.
2. It’s not easy to iterate through (you need `Object.keys(myObj)` or similar)
3. It’s hard to work with if every programmer is just tacking on fields to their objects
4. The existence of a field does not mean its value is defined

You can also do the same thing in TypeScript, and allow the value to be any, but I’m not even going to show you how to do it because I don’t want you to.

Instead, there exists `Map`. It exists in JS too, but in JS it’s not type constrained so it’s not as useful. Here’s how it works:

```ts
let myMap: Map<string, string> = new Map()
```

This creates a map that solves all the problems that I mentioned with prototype-based mapping.

1. It’s fast: HashMaps are O(1) to check and are fast to add to.
2. It’s easy to iterate through, with `map.forEach()`
3. You can still throw anything in there, as long as the key and value are of the the correct type
4. undefined cannot be in it (as long as you don’t define the typing as undefined)

Maps are great, and there’s a reason they’re the most commonly asked about data structure in interviews. They’re, in my opinion, strictly better than prototype based mapping. If you’re ever trying to allow the user to define the keys of an Object, perhaps you’re working with the wrong data structure.

## 5. Figure out your eslint config / tsconfig

The greatest part about TS and JS in general is the amount of customization that you can have in the code. For instance, I come from python, where I am partial to the no-semicolon style. So I said “no semicolons!” in my eslint config, and now my compiler yells at me when I accidently put in a semicolon.

keeping double quotes consistent makes the code look prettier, in my opinion, because you often use ‘ in strings but not “. So I made it so that in my eslint config, I have to use double quotes.

I am a big fan of forcing exhaustion in pattern matching, so I made that be mandated in my tsconfig.

I prefer no-default-export, so I made that be forced.

I highly recommend you take an hour out of your day to go through all the values in a `.tsconfig` and `.eslintrc` file and set all options to what you like. Then, save those files somewhere on your computer where you can easily paste it in when you start a new project.

I’m much happier with my code, and I find it much cleaner when all these rules are enforced — as an added bonus, anyone working on your project has to abide by the agreed upon style in the `eslintrc` and the agreed upon functionality in the `tsconfig` , so you can guarantee consistency thought the project.

---

And that’s it! That’s my 5 tips for TypeScript code. I’m always on the lookout for more advice, so if you have anything that you find important, please let me know!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
