> * 原文地址：[JavaScript Symbols: the Most Misunderstood Feature of the Language?](https://blog.bitsrc.io/javascript-symbols-the-most-misunderstood-feature-of-the-language-282b6e2a220e)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/javascript-symbols-the-most-misunderstood-feature-of-the-language.md](https://github.com/xitu/gold-miner/blob/master/article/2021/javascript-symbols-the-most-misunderstood-feature-of-the-language.md)
> * 译者：
> * 校对者：

# JavaScript Symbols: the Most Misunderstood Feature of the Language?

![Image by [Anemone123](https://pixabay.com/users/anemone123-2637160/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2736480) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2736480)](https://cdn-images-1.medium.com/max/3840/1*XF06TaFwVn5fEt8pS9syOA.jpeg)

— **”What does the Symbol has that I don’t”** asked the String to the developer, and he answered — **“Well, it is one of a kind”**

It’s a terrible line, I know, but stick with me for a second, would you? Symbols are one of those strange features of JavaScript that because no one really understands, they don’t use it.

But there is a reason why they’re there, don’t you think? Just like the `with` is there for a reason — whether we like it or not — , Symbols have a purpose. And we’re here to figure it out.

## The basics: What are Symbols?

Long story short, Symbols are a fairly new primitive type that you now have access to, next to strings, numbers, booleans, `undefined` and `null` .

Let’s break that down a bit. Primitive values are the actual value assigned to a variable, so in the following code:

```js
let a = "foo"
```

The primitive is “foo”, not `a` . The latter is a variable that’s been assigned a primitive value. Why am I making this distinction? Because you don’t normally use primitive values directly, instead you assigned them to variables to give them meaning. In other words, `2` by itself means nothing, but `let double = 2;` suddenly has meaning.

Another very interesting aspect around this, is that primitives in JavaScript are immutable. That means you can’t change the number `2` ever. Instead, you can **reassign** a variable to have another (immutable) primitive value.

Now, bringing it all into the scope of Symbols we can gather that:

* Symbols are primitive values and can be assigned to variables.
* Symbols are immutable, you can’t change them, no matter how much you try.

They also have one extra quality: they’re unique across the execution of your script.

The first two characteristics are classic for all values, but the second one isn’t, and that is what makes them so special.

### The uniqueness of Symbols

Let’s do some tests:

```JavaScript
2 === 2 // TRUE
true === true // TRUE
"this is a string" === "this is a string" // TRUE
undefined === undefined // TRUE
null === null // TRUE
Symbol() === Symbol() // FALSE!
```

That result right there is what makes Symbols so special: every time you use them, you’re creating a new one. Even if you give them the same name!

For debugging purposes, you can provide a single attribute to the `Symbol` constructor, a string. That value is of no use other than debugging.

So what’s the use of a value that you can’t really match ever again? I mean, it’s not like I can do:

```js
let obj = {}
obj[Symbol()] = 10;
console.log(obj[Symbol()]);
```

That wouldn’t work. Granted, you can save the `Symbol` into a variable, and then use that instead to reference the unique property. But you’d have to keep track of every symbol inside a new variable. It kind of looks like a watered-down version of a String, to be honest, doesn’t it?

That’s only until you learn about the global symbol cache!

Instead of directly creating symbols by calling the `Symbol` function, you can use the `Symbol.for` method.

```JavaScript
let obj = {}
obj[Symbol.for('unique_prop')] = 10;

console.log(Symbol.for('unique_prop')); //This will print 10!
```

The first call to `for` will create a new symbol, while the second one will only retrieve it. And here is where our little friends start deviating from strings. You see, while the string `"hello"` will always be equal to `"hello"` for obvious reasons, they’re two different strings. So when we do:

```JavaScript
let obj = {}
obj["prop"] = 10;
console.log(obj["prop"]);
```

We’re creating:

* A primitive value of type number (10)
* 2 primitive values of type string (the two “prop” strings)

How relevant is that? Let’s take a look at some use cases for symbols!

## When would you want to use symbols and why?

Look at the last example, how expensive — resource-wise — can that be? How much memory would you say we’ve consumed by creating one extra string? It’s so little that I don’t even want to bother making that calculation.

Especially if you’re working on a web dev environment.

However, if you’re running into some edge cases, like potentially doing some data processing that generates big in-memory dictionaries, or perhaps you’re using JavaScript on edge devices with limited memory, then symbols can be a great way of keeping memory utilization in check.

### Adding “invisible” methods

Another interesting use case for symbols comes from the fact that they’re so unique. They can be used to provide custom, unique “hooks” to objects. Like the `toString` hook that you can add on a custom object and that will get called by `console.log` when serializing it.

The key here is that by using symbols, you’re avoiding a potential name collision with whatever name the user gives to their methods. Unless they specifically use your symbol, there won’t be a problem.

```JavaScript
///Adding the custom hook to "Object"
Object.prototype.symbols = {
    serialize: Symbol.for('serialize')
}

//Your function taking advantage of the hook
function myconsol_log(obj) {
    if(typeof obj[Object.symbols.serialize] === 'function') {
        console.log(obj[Object.symbols.serialize]())
    } else {
        console.log(obj)
    }
}


//You overwriting the hook for your own needs
class MyObject {
    [Object.symbols.serialize]() {
        return "Damn son!"
    }

    serialize() {
        return "Definitely not the same!"
    }
}


myconsol_log(new MyObject())
```

Look at that code, what do you think the output will be?

It’s going to be `"damn son!` because that’s the method you defined using the unique symbol. The other one is essentially treated as a string, so they’re not the same and you’re not overwriting it.

Note that for the sake of simplicity, I’ve added a property to `Object` and this is not something you’d want to do. Instead create a custom class to properly control who inherits this custom hook.

### Metadata for your classes

The last interesting use case for symbols is adding properties to your classes and objects that are really not part of their “shape”.

Let me explain: the “shape” of an object is given by its properties. And the only way to add data to the object, without affecting its shape (its original set of properties) is by adding them as symbols. This is because these types of properties won’t show up as part of `for..in` loops, or as a result of calling `Object.keys`

You can see these properties as living inside a higher abstraction layer than your regular properties.

```JavaScript
const lastAccessedProp = Symbol.for('last_accessed_prop');
const lastAccessedTime = Symbol.for('last_accessed_time');

class User {
    constructor(f_name, l_name, address) {
        this.first_name = f_name;
        this.last_name = l_name;
        this.address = address;
    }

    get FirstName() {
        this[lastAccessedProp] = 'first_name'
        this[lastAccessedTime] = new Date();
        return this.first_name;
    }

    get LastName() {
        this[lastAccessedProp] = 'last_name'
        this[lastAccessedTime] = new Date();
        return this.last_name;
    }

    get Address() {
        this[lastAccessedProp] = 'address'
        this[lastAccessedTime] = new Date();
        return this.address;
    }
}

let myUser = new User('Fernando', 'Doglio', 'Madrid, Spain');
console.log(myUser.FirstName, myUser.LastName)
console.log("Metadata:", myUser[lastAccessedProp], " read at ", myUser[lastAccessedTime].toTimeString())

console.log("Iterating over attributes: ")
for(k in myUser) {
    console.log(k, "=", myUser[k])
}
```

Notice how I’m adding two pieces of metadata to my object: the last property accessed through the getters I defined, and the date & time of when that happened. This is metadata because it’s information not relevant to the business needs of my object, but instead, it’s information **about** my object.

After the class definition, I show you a few things:

* Symbol properties are public. This is obvious right now, because private properties aren’t yet part of the working ES version. We’ll have to see how this fits into that definition once they’re done testing it.
* Iterating over all properties of the object in lines 35–37 does not show my custom, symbol-props. This comes in handy if you’re trying to access debug data inside your classes, because you know it won’t affect the regular behavior of your code.

As you can see, symbols are probably not the richest feature of JavaScript, but they’re also not the worst. There is a very good reason why Symbols are part of the specs and now that you know some interesting use cases for them, consider taking the time to use them and take advantage of them.

Have you used symbols in any other way in your code? Share your use cases in the comments and let’s show everyone the power of this construct!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
