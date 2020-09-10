> * 原文地址：[Using JSON.stringify to Work with JavaScript Object](https://levelup.gitconnected.com/using-json-stringify-to-work-with-javascript-object-9416c1e2c7c4)
> * 原文作者：[TRAN SON HOANG](https://medium.com/@transonhoang)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/using-json-stringify-to-work-with-javascript-object.md](https://github.com/xitu/gold-miner/blob/master/article/2020/using-json-stringify-to-work-with-javascript-object.md)
> * 译者：
> * 校对者：

# Using JSON.stringify to Work with JavaScript Object

#### JavaScript

## Filter Object Properties by Using JSON.stringify

#### A simple technique to filter JavaScript object properties by using replacer as an array or a function.

![Photo by [Hanny Naibaho](https://unsplash.com/@hannynaibaho?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/coffee?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/9282/1*Kiz9V-noKpoSaIAdYyzWNA.jpeg)

In this article, I will share about using replacers with JSON.stringify().

1. Syntax Re-introduction
---

2. Using Replacer Argument

## Syntax Re-introduction

I think that most of us know the **`JSON.stringify()`** first argument. But, only some people know about there is a second argument called a **replacer**. So I want to re-introduce again the method syntax.

The `**JSON.stringify()**` method will do 2 things:

1. convert the value to a JSON string.
2. replace values if a replacer function is specified.

```
JSON.stringify(value[, replacer[, space]])
```

There are 3 parameters:

1. **value**
The value to convert to a JSON string.
2. **replacer**
A function that alters the behavior of the stringification process.
3. **space
**Add space to output.

The value supports many kinds of data such as Objects, Arrays, and Primitives.

![JSON stringify with some basic data types](https://cdn-images-1.medium.com/max/2000/1*5E21LFldSmAu59S8nuxEjQ.png)

Some values that return `undefined` such as **function properties**, **symbolic properties**, and `undefined`.

![JSON stringify return undefined for some specific input](https://cdn-images-1.medium.com/max/2000/1*rouzCb86i62XKCX4Ucy_9g.png)

How about `Object` instance such as `Map`, `Set`, `WeakMap`, and `WeakSet`?

![JSON stringify with Object instance](https://cdn-images-1.medium.com/max/2000/1*zmsGDy7_pc_4bs2YSBfofw.png)

Note:

* `Infinity` and `NaN`, `null`, are all considered `null`.
---

* **Object property names**, as well as **string**, are double-quoted after encoding.

## Using Replacer Argument

The object is recursively stringified into the JSON string, calling the `replacer` function on each property. This will help a lot when working with the object in JavaScript.

There is 2 types of **replacers**:

* array
* function

#### replacer, as an array

When we need to filter out object properties, we can apply replacer as an array.

Only these properties that we pass into the array will be encoded.

![excluding object properties by array replacer](https://cdn-images-1.medium.com/max/2000/1*9z346wFbRjwhSoKyjKkJHA.png)

#### replacer as a function

We can use the replacer as a function in the case that we don’t know exactly the property name or cannot list out all properties because there are too many.

So, we write a function to filter the property value by following a data type or a certain pattern.

![excluding object properties by function replacer](https://cdn-images-1.medium.com/max/2000/1*u3xjA0lr8z8doKYIz9JxwQ.png)

**Using the replacer is helpful for some simple case that we want to get some certain properties from an object.**

---

**Sometimes, we work on the old project that we don’t have any superpower tool that supports us to filter the property from a big JSON object.**

I hope you found this article useful! You can follow me on [Medium](https://medium.com/@transonhoang?source=post_page---------------------------). I am also on [Twitter](https://twitter.com/transonhoang). Feel free to leave any questions in the comments below. I’ll be glad to help out!

## References

[1]Json Stringify: [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
