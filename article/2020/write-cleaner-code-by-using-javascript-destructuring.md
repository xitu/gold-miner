> * 原文地址：[Write Cleaner Code by Using JavaScript Destructuring](https://medium.com/better-programming/write-cleaner-code-by-using-javascript-destructuring-cd6b55c25bac)
> * 原文作者：[Juan Cruz Martinez](https://medium.com/@bajcmartinez)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/write-cleaner-code-by-using-javascript-destructuring.md](https://github.com/xitu/gold-miner/blob/master/article/2020/write-cleaner-code-by-using-javascript-destructuring.md)
> * 译者：
> * 校对者：

# Write Cleaner Code by Using JavaScript Destructuring

![Photo by the author.](https://cdn-images-1.medium.com/max/2560/1*h-mNn0rVcSdzJ4FZq_Oj9w.jpeg)

Destructuring is one of my favorite tools in JavaScript. In simple terms, destructuring allows you to break down a complex structure (like an array or an object) into simpler parts, though there’s a bit more to it than that.

Let’s see it better in an example:

```JavaScript
const article = {
  title: "My Article",
  rating: 5,
  author: {
    name: "Juan",
    twitter: "@bajcmartinez"
  }
}
// Now let's print it to the screen
console.log(`"${article.title}" by ${article.author.name} had ${article.rating} stars`)
// By using destructuring, we can achieve the same by doing
const { title, rating, author: { name } } = article
console.log(`"${title}" by ${name} had ${rating} stars`)
------------------------
Output
------------------------
"My Article" by Juan had 5 stars
"My Article" by Juan had 5 stars
```

Now, some people have been using this feature for some time — perhaps while building React apps — but they don’t quite understand it. For others, it may be the first time. So I’ll guide you through the process from start to finish so that we all have the same level of understanding by the end of this article.

## Destructuring Objects

In the example above, all the magic happens in the following line:

```js
const { title, rating, author: { name } } = article
```

Now it may seem a bit weird to have those brackets like that on the left side of the assignment, but that’s how we tell JavaScript that we are destructuring an object.

Destructuring objects lets you bind to different properties of an object at any depth. Let’s start with an even simpler example:

```js
const me = {
  name: "Juan"
}

const { name } = me
```

In the case above, we are declaring a variable called `name` that will be initialized from the property with the same name in the object `me` so that when we evaluate the value of `name`, we get `Juan`. Awesome! The same can be applied to any depth. Heading back to our example:

```js
const { title, rating, author: { name } } = article
```

For `title` and `rating`, it’s exactly the same as we already explained. But in `author`, things are a bit different. When we get to a property that is either an object or an array, we can choose whether to create the variable `author` with a reference to the `article.author` object or do a deep destructuring and get immediate access to the properties of the inner object.

Accessing the object property:

```JavaScript
const { author } = article
console.log(author.name)
------------------------
Output
------------------------
Juan
```

Doing a deep or nested destructuring:

```JavaScript
const { author: { name } } = article
console.log(name)
console.log(author)
------------------------
Output
------------------------
Juan
Uncaught ReferenceError: author is not defined
```

Wait, what? If I destructured `author`, why is it not defined? It is actually quite simple. When we ask JavaScript to also destructure the `author` object, that binding itself is not created and we instead get access to all the `author` properties we selected. So please always remember that.

Spread operator (`…`):

```JavaScript
const article = {
  title: "My Article",
  rating: 5,
  author: {
    name: "Juan",
    twitter: "@bajcmartinez"
const { title, ...others } = article
console.log(title)
console.log(others)
------------------------
Output
------------------------
My Article
> {rating: 5, author: {name: "Juan", twitter: "@bajcmartinez" }}
```

Additionally, we can use the spread operator `...` to create an object with all the properties that did not get destructured.

If you are interested in learning more about the spread operator, check out [my article](https://medium.com/@bajcmartinez/how-to-use-the-spread-operator-in-javascript-3aff104adb71).

#### Renaming properties

One great property of destructuring is the ability to choose a different name for the variable to the property we are extracting. Let’s look at the following example:

```JavaScript
const me = { name: "Juan" }
const { name: myName } = me
console.log(myName)
------------------------
Output
------------------------
Juan
```

By using `:` on a property, we can provide a new name for it (in our case, `newName`). And then we can access that variable in our code. It’s important to note that a variable with the original property `name` won’t be defined.

#### Missing properties

So what would happen if we tried to destructure a property that is not defined in our object?

```JavaScript
const { missing } = {}
console.log(missing)
------------------------
Output
------------------------
undefined
```

In this case, the variable is created with value `undefined`.

#### Default values

Expanding on missing properties, it’s possible to assign a default value when the property does not exist. Let’s see some examples of this:

```JavaScript
const { missing = "missing default" } = {}
const { someUndefined = "undefined default" } = { someUndefined: undefined }
const { someNull = "null default" } = { someNull: null }
const { someString = "undefined default" } = { someString: "some string here" }
console.log(missing)
console.log(someUndefined)
console.log(someNull)
------------------------
Output
------------------------
missing default
undefined default
null
some string here
```

These are some examples of assigning default values to our destructured objects. The default values are only assigned when the property is `undefined`. If the value of the property is `null` or a `string` for instance, the default value won’t be assigned, but the actual value of the property will be.

## Destructuring Arrays and Iterables

We already saw some examples of destructuring objects, but the same can apply to arrays or iterables in general. Let’s start with an example:

```JavaScript
const arr = [1, 2, 3]
const [a, b] = arr
console.log(a)
console.log(b)
------------------------
Output
------------------------
1
2
```

When we need to destructure an array, we need to use `[]` instead of `{}`, and we can map each position of the array with a different variable. But there are some nice tricks.

#### Skipping elements

By using the `,` operator, we can skip some elements from the iterable as follows:

```JavaScript
const arr = [1, 2, 3]
const [a,, b] = arr
console.log(a)
console.log(b)
------------------------
Output
------------------------
1
3
```

Note how leaving an empty space between `,` skips the elements. It's subtle but has big consequences on the results.

What else can you do? You can also use the spread operator `...` as follows:

```JavaScript
const arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
const [a,, b, ...z] = arr
console.log(a)
console.log(b)
console.log(z)
------------------------
Output
------------------------
1
3
(7) [4, 5, 6, 7, 8, 9, 10]
```

In this case, `z` will get all the values after `b` as an array. Or maybe you have a more specific need and you want to destructure specific positions in the array. No problem. JavaScript has you covered:

```JavaScript
const arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
const { 4: fourth, 9: ninth } = arr
console.log(fourth)
console.log(ninth)
------------------------
Output
------------------------
5
10
```

If we destructure an array as if it were an object, we can use the indexes as properties and thus access any position within the array.

#### Missing properties

As was the case with objects, it is also possible to set default values for undefined elements in the array. Let’s take a look at some examples:

```JavaScript
const [missing = 'default missing'] = []
const [a, b, c = "missing c", ...others] = [1, 2]
console.log(missing)
console.log(a)
console.log(b)
console.log(c)
console.log(others)
------------------------
Output
------------------------
default missing
1
2
missing c
[]
```

When destructuring arrays, it is also possible to set default values for `undefined` properties. However, it is not possible to set a default when we have the spread operator `...`. In the case of `undefined`, it will return an empty array.

## Swapping Variables

This is a fun use case of destructuring. Two variables can be swapped in one single expression:

```JavaScript
let a = 1
let b = 5
[a, b] = [b, a]
console.log(a)
console.log(b)
------------------------
Output
------------------------
5
1
```

## Destructuring With Computed Properties

Until now, any time we wanted to destructure the properties of an object or the elements of an iterable, we used static keys. If we want dynamic keys (like those stored on a variable), we need to use computed properties.

Here is an example:

```JavaScript
const me = { name: "Juan" }
let dynamicVar = 'name'
let { [dynamicVar]: myName } = me
console.log(myName)
------------------------
Output
------------------------
Juan
```

Pretty awesome, right? By using a variable between `[]`, we can evaluate its value before doing the assignment. Thus, it’s possible to do dynamic destructuring, though it is mandatory to provide a name for this new variable.

## Destructuring Function Arguments

Destructured variables can be placed anywhere we can declare variables (e.g. by using `let`, `const`, or `var`), but it’s also possible to destructure function arguments. Here is a simple example of the concept:

```JavaScript
const me = { name: "Juan" }
function printName({ name }) {
    console.log(name)
}
printName(me)
------------------------
Output
------------------------
Juan
```

Very simple and elegant. Also, all the same rules we discussed before apply.

## Conclusion

Destructuring may seem awkward at the beginning, but once you get used to it, there’s no going back. It can really help your code be more readable and it’s a great concept to know.

Did you know you can also use destructuring while importing modules? Check out [my article](https://levelup.gitconnected.com/an-intro-to-javascript-modules-36c07c5d4c9c) on the topic.

Thanks for reading! I hope you enjoyed it.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
