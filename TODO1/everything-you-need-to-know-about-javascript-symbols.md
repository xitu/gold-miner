> * 原文地址：[Everything you need to know about JavaScript symbols](https://levelup.gitconnected.com/everything-you-need-to-know-about-javascript-symbols-24650a163038)
> * 原文作者：[Narek Ghevandiani](https://medium.com/@narghev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/everything-you-need-to-know-about-javascript-symbols.md](https://github.com/xitu/gold-miner/blob/master/TODO1/everything-you-need-to-know-about-javascript-symbols.md)
> * 译者：
> * 校对者：

# Everything you need to know about JavaScript symbols

![](https://cdn-images-1.medium.com/max/3684/1*13nRTbL0V3Idd3fDdKGkjQ.png)

A **JavaScript Symbol** is a relatively new JavaScript “feature”. It was introduced back in 2015 as part of [ES6](http://es6-features.org). In this article, I am going to cover:

1. What exactly is a JavaScript Symbol
2. The motivation of adding the data type to the language
3. Whether the data type was successful in solving the problem it was supposed to
4. The differences with the symbol data type in other languages, for example Ruby
5. Well-known JavaScript symbols
6. Benefiting from the data type

---

## JavaScript symbol

Symbols were added to the lineup of primitive data types in JavaScript in 2015. It was part of ES6 specification and its sole purpose is to act as a **unique identifier of object properties**, i.e. it can be used as a **key** in objects. You can **think** of symbols as big numbers and every time you create a symbol, a new random number gets generated **(uuid)**. You can use that symbol **(the random big number)** as a key in objects.

A symbol is created by calling the Symbol function which takes an optional argument string which is used only for debugging purposes and acts as a description of the symbol. The Symbol function returns a unique symbol value.

![](https://cdn-images-1.medium.com/max/3880/1*CbM8A2Xj43EjYVz8Vmi_Og.png)

Note that a Symbol is not a constructor and **cannot** be called with **new**.

![](https://cdn-images-1.medium.com/max/4656/1*9i7eeHcx4t-NCESG71aZbQ.png)

It is also possible to create symbols which will be assigned to the **global symbol registry**. The methods `**Symbol.for()**` and `**Symbol.keyFor()**` help create and read Symbols in the global symbol registry. The `**Symbol.for()**` method looks in the global symbol registry and retrieves or initializes the symbol depending if it is found or not.

![](https://cdn-images-1.medium.com/max/6984/1*IBCJQzFflSlnOAgMYNP4MA.png)

And the `**Symbol.keyFor()**` method looks for the symbol in the global symbol registry and returns its key if found and `undefined` otherwise. Think of the global symbol registry as a global object where the keys are the strings passed to `**Symbol.for()**` and the values are the symbols.

![](https://cdn-images-1.medium.com/max/5688/1*HZ06QgqZp3IQOpQ6LuYkkQ.png)

Symbols registered to the global symbol registry are not only accessible in all scopes, but even accessible across realms.

---

## Motivations of adding the new data type

One of the reasons of adding the data type was to enable private properties in JavaScript. Before symbols, privacy or immutability were being solved with closures, proxies, and other workarounds. But all of the solutions are too verbose and require a lot of code and logic to achieve their purpose.

So let’s see how the Symbol was supposed to solve the issue. Every symbol value returned from the Symbol function is unique and can be used as an object property identifier. That is the main purpose of the Symbol.

![](https://cdn-images-1.medium.com/max/4328/1*4aakLJrmi1vCnqPIncSFDw.png)

Since every symbol is unique, and in no way can two symbols be equal to each other, if a symbol is used as a property identifier and is not available in a scope, that property cannot be accessed from that scope.

![](https://cdn-images-1.medium.com/max/4656/1*DOx36fH8NLbGYatdUKWG9w.png)

![](https://cdn-images-1.medium.com/max/4912/1*JoAxAJgflsM6tUEXSZ_sXQ.png)

Symbols defined in the global symbol registry can be accessed with **`Symbol.for()`** and will be the same.

![](https://cdn-images-1.medium.com/max/4048/1*CaQbgutU-KYxLPOQm-7Ztw.png)

Okay, so symbols are cool. They help us make unique values that can never be repeated and use them to **hide** properties. But do they really solve the privacy problem?

---

## Do symbols achieve property privacy?

JavaScript symbol does **NOT** achieve property privacy. You cannot rely on symbols to hide something from the user of your library. There is a method defined on the Object class called **Object.getOwnPropertySymbols()** that takes an object as an argument and returns an array of property symbols of the argument object.

![](https://cdn-images-1.medium.com/max/7072/1*mzNkoGU403VrYTL0T2GBtw.png)

Additionally, if the symbol is assigned to the global symbol registry, nothing can stop accessing the symbol and its property value.

---

## Symbol in computer programming

If you are familiar with other programming languages, you will know that they have symbols too. And in fact, even if the name of the datatype is the same, there are pretty significant differences between them.

Now let’s talk about symbols in programming in general. The definition of a symbol in [Wikipedia](https://en.wikipedia.org/wiki/Symbol_(programming)) is the following:

> A symbol in computer programming is a primitive data type whose instances have a unique human-readable form.

In JavaScript symbol is a primitive datatype and although the language does not force you to make the instance human-readable, you can provide the symbol with a debugging description property.

Given that, we should know that there are some differences between **JS** symbols and symbols in other languages. Let’s take a look at [**Ruby symbols**](https://ruby-doc.org/core-2.2.0/Symbol.html). In Ruby, Symbol objects are usually used to represent some strings. They are generated using the colon syntax and also by type conversion using the `**to_sym**` method.

![](https://cdn-images-1.medium.com/max/5176/1*0u8FeH7Nn_fSmLWV2ixcLg.png)

If you noticed, we never assign the “created” symbol to a variable. If we use **(generate)** a symbol in the Ruby program it will always be the same during the entire execution of the program, regardless of its creation context.

![](https://cdn-images-1.medium.com/max/5088/1*KbQyAg5yHC7KXSdBSWyR7Q.png)

In JavaScript, we can replicate this behavior by creating a symbol in the global symbol registry.

A major difference between symbol in the 2 languages is that in Ruby, symbols can be used instead of string, and in fact in many cases they auto-convert to strings. Methods available on string objects are also available on symbols and as we saw string can be converted to symbols using the `**to_sym**` method.

We already saw the reasons and the motivation of adding symbols to JavaScript, now let’s see what is their purpose in Ruby. In Ruby, we can think of symbols as immutable strings, and that alone results in many advantages of using them. They can be used as object property identifiers, and usually are.

![](https://cdn-images-1.medium.com/max/4568/1*Fa2BNIGDEvDW9R_44uI97w.png)

Symbols also have performance advantages over strings. Every time you use the string notation, a new object gets created in the memory while symbols are always the same.

![](https://cdn-images-1.medium.com/max/4744/1*3qvoL8xoQD4H5As3u-j87g.png)

Now imagine we use a string as a property identifier and create 100 of that object. Ruby will have to also create 100 different string objects. That can be avoided by using symbols.

Another use-case of symbols is showing status. For example, it is a good practice for functions to return a symbol, indicating the success status like (**:ok**, **:error**) and the result.

In [Rails](https://rubyonrails.org/) **(a famous Ruby web-app framework),** almost all [HTTP status codes can be used with symbols](https://gist.github.com/mlanett/a31c340b132ddefa9cca). You can send status **:ok**, **:internal_server_error** or **:not_found,** and the framework will replace them with correct status code and message.

To conclude, we can say that symbols are not the same and do not share the same purpose in all programming languages and as a person who already was familiar with Ruby symbols, for me JavaScript symbols and their motivation were a bit confusing.

**Note: In some programming languages ([erlang](https://www.erlang.org/), [elixir](https://elixir-lang.org/)), symbol is called an [atom](https://elixir-lang.org/getting-started/basic-types.html#atoms).**

---

## Well-known JavaScript symbols

JavaScript has some built-in symbols which allow the developer to access some properties which were not exposed before the introduction of symbols to the language.

Here are some of the well-known JavaScript symbols that are used for iteration, Regexp, etc.

#### Symbol.iterator

This symbol gives the developer access to the default iterator for an object. It is used in `**for…of**` and its value should be a generator function.

![](https://cdn-images-1.medium.com/max/4224/1*pTFWK26OfUHMKysmg36Zlg.png)

![](https://cdn-images-1.medium.com/max/5520/1*qYvPQJVoT5tQKCjoQ5Hkuw.png)

> `function*() {}` is the syntax for defining a **generator function.** A generator function returns a Generator object.
>
> `yield` is a keyword used to pause and resume generator functions.
>
> See more on [generator functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function*) and [yield](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield).

For async iteration there is **Symbol.asyncIterator** which is used by `**for await…of**` loop.

#### Symbol.match

As we know, functions like **String.prototype.startsWith(), String.prototype.endsWith()** take a string as their first argument.

![](https://cdn-images-1.medium.com/max/4656/1*ZQnSSyo2bD95Xo--mJDK3g.png)

Let’s try passing a regexp instead of a string to the function, we get a type error.

![](https://cdn-images-1.medium.com/max/6552/1*mVSJ9mZR6eiVxa_wt0piLw.png)

Actually, what happens is that the functions check specifically whether the passed argument is a regexp or not. We can say that an object is not intended to be used as a regexp by setting its `**Symbol.match**` property to **false** or to another falsey value.

![](https://cdn-images-1.medium.com/max/5256/1*bE28F0Oz0o5Sl6LGuHVR4Q.png)

**Note: Honestly, I am not sure why you would want to do this. The code above is an example to demonstrate how to use the `Symbol.match` . It seems like a hack and it will be problematic if used like this because it changes the behavior of functions that are used a lot. I cannot think of any real use-cases for using this one.**

---

## Benefiting from JavaScript symbols

Although JS Symbol is not being used widely and did not solve the property privacy problem, we still can benefit from it.

We can use the Symbol to define some **metadata** on the object. For example, we want to create a dictionary which we will implement by adding word and definition pairs to the object and for some computational reasons, we want to keep track of the word count in the dictionary. The word count in this case can be considered metadata. It is not really a valuable piece of information for the user and the user may not want to see it when say iterating over the object.

![](https://cdn-images-1.medium.com/max/5088/1*sRYsDvC0c4-EQkaD-MIoww.png)

We can solve this problem by keeping the word count property keyed with a symbol. In this case, we avoid the problem of the user accidentally accessing it.

![](https://cdn-images-1.medium.com/max/5776/1*F6CB9NdXMu60kWx3TljHOA.png)

And the reason for which symbols will be used the most is probably property name collisions. Sometimes we get and set object properties when iterating over them, or we use a dynamic value to access the property **(with using the** obj[key] **notation)** and as a result of that, accidentally mutate the property we never wanted to. So we can solve this problem by using symbols as property identifiers. In this case, we can never land on that key while iterating over the object or using a dynamic value. Iteration case will not happen because we can never land on them while iterating with `**for…in**`

![](https://cdn-images-1.medium.com/max/3184/1*yhZemW2nIYKx_CLHWP72-g.png)

The dynamic valued key case cannot happen because there is no other value equal to a symbol except that symbol.

And of course, well-known symbols like `**Symbol.iterator**` or `**Symbol.asyncIterator**` can have interesting use-cases.

![](https://cdn-images-1.medium.com/max/5448/1*ZkrQzQrm6Xf9LV_C9-KyZw.png)

---

I covered the important concepts and practices needed for grasping the idea of JavaScript Symbol. Of course there is a lot more to cover like other well-known symbols, or use cases of crossing realms with symbols, but I will leave out some useful material that cover those and other parts of JavaScript Symbol.

---

#### Additional Material

> [JavaScript Symbol MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol)
>
> [ES6 Symbol tc39wiki](http://tc39wiki.calculist.org/es6/symbols/)
>
> [JS Symbols exploringjs.com](https://exploringjs.com/es6/ch_symbols.html)
>
> [JS Realms stackoverflow](https://stackoverflow.com/questions/49832187/how-to-understand-js-realms)
>
> [Symbol (programming) wikipedia](https://en.wikipedia.org/wiki/Symbol_(programming))
>
> [Ruby Symbols](https://ruby-doc.org/core-2.2.0/Symbol.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
