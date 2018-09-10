> * 原文地址：[WTF is this - Understanding the this keyword, call, apply, and bind in JavaScript](https://tylermcginnis.com/this-keyword-call-apply-bind-javascript/)
> * 原文作者：[Tyler McGinnis](https://twitter.com/tylermcginnis)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/this-keyword-call-apply-bind-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/this-keyword-call-apply-bind-javascript.md)
> * 译者：
> * 校对者：

# WTF is this - Understanding the this keyword, call, apply, and bind in JavaScript

![](https://tylermcginnis.com/static/wtfIsThis-9b62a3df42b953522d9108f9b51758c4-1eede.jpg)

One of the most misunderstood aspects of JavaScript is the `this` keyword. In this post, you’ll learn four rules for figuring out what the `this` keyword is referencing. Implicit Binding, Explicit Binding, the new binding, and the window binding. In covering these techniques you’ll also learn some other confusing parts of JavaScript as well like `.call`, `.apply`, `.bind`, and the `new` keyword.

### Video

* YouTube 视频链接：https://youtu.be/zE9iro4r918

### Post

Before diving into the specifics of the `this` keyword in JavaScript, it’s important to take a step back and first look at why the `this` keyword exists in the first place. The `this` keyword allows you to reuse functions with different contexts. Said differently, **the “this” keyword allows you to decide which object should be focal when invoking a function or a method.** Everything we talk about after this will build upon that idea. We want to be able to reuse functions or methods in different contexts or with different objects.

The first thing we’ll look at is how to tell what the `this` keyword is referencing. The first and most important question you need to ask yourself when you’re trying to answer this question is ”**Where is this function being invoked?**”. The **only** way you can tell what the `this` keyword is referencing is by looking at where the function using the `this` keyword was invoked.

To demonstrate this with an example you’re already familiar with, say we had a `greet` function that took in a name an alerted a welcome message.

```
function greet (name) {
  alert(`Hello, my name is ${name}`)
}
```

If I were to ask you exactly what `greet` was going to alert, what would your answer be? Given only the function definition, it’s impossible to know. In order to know what `name` is, you’d have to look at the function invocation of `greet`.

```
greet('Tyler')
```

It’s the exact same idea with figuring out what the `this` keyword is referencing and you can even think about `this` as you would a normal argument to a function - it’s going to change based on how the function is invoked.

Now that we know in order to tell what the `this` keyword is referencing you must look at the function definition, let’s establish four rules to look for when actually looking at the function definition. They are,

1.  Implicit Binding
2.  Explicit Binding
3.  new Binding
4.  window Binding

### Implicit Binding

Remember, the goal here is to be able to look at a function definition using the `this` keyword and tell what `this` is referencing. The first and most common rule for doing that is called the `Implicit Binding`. I’d say it’ll tell you what the `this` keyword is referencing about 80% of the time.

Let’s say we had an object that looked like this

```
const user = {
  name: 'Tyler',
  age: 27,
  greet() {
    alert(`Hello, my name is ${this.name}`)
  }
}
```

Now, if you were to invoke the `greet` method on the `user` object, you’d do so be using dot notation.

```
user.greet()
```

This brings us to the main keypoint of the implicit binding rule. In order to figure out what the `this` keyword is referencing, first, **_look to the left of the dot when the function is invoked_**. If there is a “dot”, look to the left of that dot to find the object that the `this` keyword is referencing.

In the example above, `user` is to “the left of the dot” which means the `this` keyword is referencing the `user` object. So, it’s **as if**, inside the `greet` method, the JavaScript interpretor changes `this` to `user`.

```
greet() {
  // alert(`Hello, my name is ${this.name}`)
  alert(`Hello, my name is ${user.name}`) // Tyler
}
```

Let’s take a look at a similar, but slightly more advanced example. Now, instead of just having a `name`, `age`, and `greet` property, let’s also give our user object a `mother` property which also has a `name` and `greet` property.

```
const user = {
  name: 'Tyler',
  age: 27,
  greet() {
    alert(`Hello, my name is ${this.name}`)
  },
  mother: {
    name: 'Stacey',
    greet() {
      alert(`Hello, my name is ${this.name}`)
    }
  }
}
```

Now the question becomes, what is each invocation below going to alert?

```
user.greet()
user.mother.greet()
```

Whenever we’re trying to figure out what the `this` keyword is referencing we need to look to the invocation and see what’s to the “left of the dot”. In the first invocation, `user` is to the left of the dot which means `this` is going to reference `user`. In the second invocation, `mother` is to the left of the dot which means `this` is going to reference `mother`.

```
user.greet() // Tyler
user.mother.greet() // Stacey
```

As mentioned earlier, about 80% of the time there will be an object to the “left of the dot”. That’s why the first step you should take when figuring out what the `this` keyword is referencing is to “look to the left of the dot”. But, what if there is no dot? This brings us to our next rule -

### Explicit Binding

Now what if instead of our `greet` function being a method on the `user` object, it was just its own standalone function.

```
function greet () {
  alert(`Hello, my name is ${this.name}`)
}

const user = {
  name: 'Tyler',
  age: 27,
}
```

We know that in order to tell what the `this` keyword is referencing we first have to look at where the function is being invoked. Now this brings up the question, how can we invoke `greet` but have it be invoked with the `this` keyword referencing the `user` object. We can’t just do `user.greet()` like we did before because `user` doesn’t have a `greet` method. In JavaScript, every function contains a method which allows you to do exactly this and that method is named `call`.

> “call” is a method on every function that allows you to invoke the function specifying in what context the function will be invoked.

With that in mind, we can invoke `greet` in the context of `user` with the following code -

```
greet.call(user)
```

Again, `call` is a property on every function and the first argument you pass to it will be the context in which the function is invoked. In other words, the first argument you pass to call will be what the `this` keyword inside that function is referencing.

This is the foundation of rule #2 (Explicit Binding) because we’re explicitly (using `.call`), specifying what the `this` keyword is referencing.

Now let’s modify our `greet` function just a little bit. What if we also wanted to pass in some arguments? Say along with their name, we also wanted to alert what languages they know. Something like this

```
function greet (lang1, lang2, lang3) {
  alert(`Hello, my name is ${this.name} and I know ${lang1}, ${lang2}, and ${lang3}`)
}
```

Now in order to pass arguments to a function being invoked with `.call`, you pass them in one by one after you specify the first argument which is the context.

```
function greet (lang1, lang2, lang3) {
  alert(`Hello, my name is ${this.name} and I know ${lang1}, ${lang2}, and ${lang3}`)
}

const user = {
  name: 'Tyler',
  age: 27,
}

const languages = ['JavaScript', 'Ruby', 'Python']

greet.call(user, languages[0], languages[1], languages[2])
```

This works and it shows how you can pass arguments to a function being invoked with `.call`. However, as you may have noticed, it’s a tad annoying to have to pass in the arguments one by one from our `languages` array. It would be nice if we could just pass in the whole array as the second argument and JavaScript would spread those out for us. Well good news for us, this is exactly what `.apply` does. `.apply` is the exact same thing as `.call`, but instead of passing in arguments one by one, you can pass in an array and it will spread those out for you as parameters in the function.

So now using `.apply`, our code can change into this (below) with everything else staying the same.

```
const languages = ['JavaScript', 'Ruby', 'Python']

// greet.call(user, languages[0], languages[1], languages[2])
greet.apply(user, languages)
```

So far under our “Explicit Binding” rule we’ve learned about `.call` as well as `.apply` which both allow you to invoke a function, specifying what the `this` keyword is going to be referencing inside of that function. The last part of this rule is `.bind`. `.bind` is the exact same as `.call` but instead of immediately invoking the function, it’ll return a new function that you can invoke at a later time. So if we look at our code from earlier, using `.bind`, it’ll look like this

```
function greet (lang1, lang2, lang3) {
  alert(`Hello, my name is ${this.name} and I know ${lang1}, ${lang2}, and ${lang3}`)
}

const user = {
  name: 'Tyler',
  age: 27,
}

const languages = ['JavaScript', 'Ruby', 'Python']

const newFn = greet.bind(user, languages[0], languages[1], languages[2])
newFn() // alerts "Hello, my name is Tyler and I know JavaScript, Ruby, and Python"
```

### new Binding

The third rule for figuring out what the `this` keyword is referencing is called the `new` binding. If you’re unfamiliar with the `new` keyword in JavaScript, whenever you invoke a function with the `new` keyword, under the hood, the JavaScript interpretor will create a brand new object for you and call it `this`. So, naturally, if a function was called with `new`, the `this` keyword is referencing that new object that the interpretor created.

```
function User (name, age) {
  /*
    Under the hood, JavaScript creates a new object called `this`
    which delegates to the User's prototype on failed lookups. If a
    function is called with the new keyword, then it's this new object
    that interpretor created that the this keyword is referencing.
  */

  this.name = name
  this.age = age
}

const me = new User('Tyler', 27)
```

### window Binding

Let’s say we had the following code

```
function sayAge () {
  console.log(`My age is ${this.age}`)
}

const user = {
  name: 'Tyler',
  age: 27
}
```

As we covered earlier, if you wanted to invoke `sayAge` in the context of `user`, you could use `.call`, `.apply`, or `.bind`. What would happen if we didn’t use any of those and instead just invoked `sayAge` as you normally would

```
sayAge() // My age is undefined
```

What you’d get is, unsurprisingly, `My name is undefined` because `this.age` would be undefined. Here’s where things get crazy though. What’s really happening here is because there’s nothing to the left of the dot, we’re not using `.call`, `.apply`, `.bind`, or the `new` keyword, JavaScript is defaulting `this` to reference the `window` object. What that means is if we add an `age` property to the `window` object, then when we invoke our `sayAge` function again, `this.age` will no longer be undefined but instead it’ll be whatever the `age` property is on the window object. Don’t believe me? Run this code,

```
window.age = 27

function sayAge () {
  console.log(`My age is ${this.age}`)
}
```

Pretty gnarly, right? That’s why the 4th rule is the `window Binding`. If none of the other rules are met, then JavaScript will default the `this` keyword to reference the `window` object.

* * *

> In `strict mode` added in ES5, JavaScript will do the right thing and instead of defaulting to the window object will just keep “this” as undefined.

```
'use strict'

window.age = 27

function sayAge () {
  console.log(`My age is ${this.age}`)
}

sayAge() // TypeError: Cannot read property 'age' of undefined
```

* * *

So putting all of our rules into practice, whenever I see the `this` keyword inside of a function, these are the steps I take in order to figure out what it’s referencing.

1.  Look to where the function was invoked.
2.  Is there an object to the left of the dot? If so, that’s what the “this” keyword is referencing. If not, continue to #3.
3.  Was the function invoked with “call”, “apply”, or “bind”? If so, it’ll explicitly state what the “this” keyword is referencing. If not, continue to #4.
4.  Was the function invoked using the “new” keyword? If so, the “this” keyword is referencing the newly created object that was made by the JavaScript interpretor. If not, continue to #5.
5.  Are you in “strict mode”? If yes, the “this” keyword is undefined. If not, continue to #6.
6.  JavaScript is weird. “this” is referencing the “window” object.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
