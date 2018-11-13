> * 原文地址：[Javascript: call(), apply() and bind()](https://medium.com/@omergoldberg/javascript-call-apply-and-bind-e5c27301f7bb)
> * 原文作者：[Omer Goldberg](https://medium.com/@omergoldberg?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-call-apply-and-bind.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-call-apply-and-bind.md)
> * 译者：
> * 校对者：

# Javascript: call(), apply() and bind()

### “this” refresher

In Object Oriented JS we learned that in JS, everything is an object. Because everything is an object, we came to understand that we could set and access additional properties to functions.

Setting properties to a function and additional methods via the prototype is super awesome … **but how do we access them?!??!**

![](https://cdn-images-1.medium.com/max/800/1*IWxOuXB3csN4_na6SSm_Rg.gif)

When he says myself, he really means ‘this’

We were introduced to the `this` keyword. We learned that every function gets this property automatically. So at this point in time, if we were to create a mental model of our function execution context( I am not the only one who does this!… right?!?!), it would look something like this:

![](https://cdn-images-1.medium.com/max/800/1*oGDRHlH5QWXTFTenWvMaBw.png)

It took us a little while to get comfortable with the `this` keyword, but once we did we began to realize how useful it is. `this` is used inside a function, and will always refer to a single object — [the object that invokes (calls) the function where “this”  is used](http://javascriptissexy.com/understand-javascripts-this-with-clarity-and-master-it/).

But life isn’t perfect. Sometimes, we lose our `this` reference. When that happens, we end up using confusing hacks to save our reference to `this`. Check out this confusing hack [from our localStorage exercise:](https://github.com/Arieg419/ITCCodingBootcamp/blob/master/localStorage/eBay.js)

![](https://cdn-images-1.medium.com/max/800/1*aE3Ao2PIEo21WK7C6Ofdfg.png)

Line 31 :(

So why did I need to save a `this` reference? Because _inside_ deleteBtn.addEventListener, `this` refers to the _deleteBtn_ object. This is unfortunate. Is there a better solution?

* * *

### call(), apply() and bind() — a new hope

Up until now we have treated functions as objects that are composed of a name (optional, can also be an anonymous function) and the code it executes when it is invoked. But that isn’t the entire truth. As a truth loving person, I must let you know that a function actually looks closer to the following image:

![](https://cdn-images-1.medium.com/max/800/1*TkzF3ckhM9Xf_U9XFaCyhA.png)

What is this??????? Don’t worry! I will now walk through these 3 similar methods that appear on every function with examples. Rejoice!

### **bind()**

[The official docs say:](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_objects/Function/bind) The `**bind()**` method creates a new function that, when called, has its `this` keyword set to the provided value. (It actually talks about even more stuff, but we’ll leave that for another time :) )

This is extremely powerful. It let’s us explicitly define the value of `this` when calling a function. Let’s look at cooooode:

```
var pokemon = {
    firstname: 'Pika',
    lastname: 'Chu ',
    getPokeName: function() {
        var fullname = this.firstname + ' ' + this.lastname;
        return fullname;
    }
};

var pokemonName = function() {
    console.log(this.getPokeName() + 'I choose you!');
};

var logPokemon = pokemonName.bind(pokemon); // creates new object and binds pokemon. 'this' of pokemon === pokemon now

logPokemon(); // 'Pika Chu I choose you!'
```

Using the `bind() method on line 14.`

**_Let’s break it down._** When we use the `bind()` method:

1.  the JS engine is creating a new `pokemonName` instance and binding `pokemon` as its `this` variable. It is important to understand that **_it copies the pokemonName function._**
2.  After creating a copy of the `pokemonName` function it is able to call `logPokemon()`, although it wasn’t on the pokemon object initially. It will now recognizes its properties (_Pika_ and _Chu) and its methods._

And the cool thing is, after we bind() a value we can use the function just like it was any other normal function. We could even update the function to accept parameters, and pass them like so:

```
var pokemon = {
    firstname: 'Pika',
    lastname: 'Chu ',
    getPokeName: function() {
        var fullname = this.firstname + ' ' + this.lastname;
        return fullname;
    }
};

var pokemonName = function(snack, hobby) {
    console.log(this.getPokeName() + 'I choose you!');
    console.log(this.getPokeName() + ' loves ' + snack + ' and ' + hobby);
};

var logPokemon = pokemonName.bind(pokemon); // creates new object and binds pokemon. 'this' of pokemon === pokemon now

logPokemon('sushi', 'algorithms'); // Pika Chu  loves sushi and algorithms

```

### call(), apply()

[The official docs for call() say](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call): The `**call()**` method calls a function with a given `this` value and arguments provided individually.

What that means, is that we can call any function, and _explicitly specify what_ `_this_` _should reference_ within the calling function. Really similar to the `bind()` method! This can definitely save us from writing hacky code (even though we are all still hackerzzz).

The main differences between `bind()` and `call()` is that the `call()` method:

1.  Accepts additional parameters as well
2.  Executes the function it was called upon right away.
3.  The `call()` method does not make a copy of the function it is being called on.

`call()` and `apply()` serve the **exact same purpose.** The **_only difference between how they work is that_** call() expects all parameters to be passed in individually, whereas apply() expects an array of all of our parameters. Example:

```
var pokemon = {
    firstname: 'Pika',
    lastname: 'Chu ',
    getPokeName: function() {
        var fullname = this.firstname + ' ' + this.lastname;
        return fullname;
    }
};

var pokemonName = function(snack, hobby) {
    console.log(this.getPokeName() + ' loves ' + snack + ' and ' + hobby);
};

pokemonName.call(pokemon,'sushi', 'algorithms'); // Pika Chu  loves sushi and algorithms
pokemonName.apply(pokemon,['sushi', 'algorithms']); // Pika Chu  loves sushi and algorithms
```

Notice that apply accepts and array, and call expects each param individually.

These built in methods, that exist on every JS function can be very useful. Even if you do not end up using them in your day to day programming, you will still run into it often when reading other peoples code.

If you have any questions, as always, reach out via [Instagram](https://www.instagram.com/omeragoldberg/) ❤

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
