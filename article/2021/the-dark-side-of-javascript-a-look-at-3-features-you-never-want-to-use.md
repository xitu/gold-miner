> * 原文地址：[The Dark Side of Javascript: A Look at 3 Features You Never Want to Use](https://blog.bitsrc.io/the-dark-side-of-javascript-a-look-at-3-features-you-never-want-to-use-83b6f0b3804b)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-dark-side-of-javascript-a-look-at-3-features-you-never-want-to-use.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-dark-side-of-javascript-a-look-at-3-features-you-never-want-to-use.md)
> * 译者：
> * 校对者：

# The Dark Side of Javascript: A Look at 3 Features You Never Want to Use

![Image by [Free-Photos](https://pixabay.com/photos/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1081873) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1081873)](https://cdn-images-1.medium.com/max/3840/1*kSqZcIr9JLkFQgqwe4LEOQ.jpeg)

JavaScript has been around for quite a while already (around 26 years) and during that time, the language has evolved, a lot.

Most of this evolution has served a purpose, and especially in the latest iterations, the community of developers has managed to influence some of these changes, making JavaScript a very flexible and useful language.

However, during all these years of evolution, one could say that there are some vestiges of a bygone era, features that haven’t yet been taken out but that really serve no purpose (or rather, aren’t very efficient at that) anymore.

Here are three features of JavaScript that even if they’re still available under the runtime you’re using, you still want to avoid.

## Void operator

You’ve probably seen this bad boy in action at one point. Back in the day, whenever you had a link that would fire a JavaScript function when clicked, you would add `href="javascript:void(0)"` to make sure the default action wouldn’t fire.

But what exactly did that mean?

The `void` operator is a way to generate the `undefined` value in JavaScript. That’s right, it takes an expression, any expression, and returns `undefined` every single time.

I know what you’re thinking: why not just use the actual `undefined` keyword, already available? Well, you see, before ECMAScript 5, the `undefined` keyword wasn’t a constant value. That’s right, you could define `undefined` which if you think about it, isn’t that something we all wanted to do at one point?

Although of course, doing that makes no sense which is why eventually it was re-defined as a constant value, and changing it is no longer an option. However, because you could change it back in the day, `void` would allow you to access the coveted `undefined` value, even if the constant was no longer working.

In fact, a great way to re-define the constant only for your namespace, avoiding any issues with 3rd party libraries, would be by creating your own IIFEs where one of the parameters received, was indeed, `undefined`, like this:

```JavaScript
(function (window, undefined) {
  //your logic here, where you can treat undefined as expected
})(window, void(0))
```

Of course, today the `void` operator still has its uses, but they’re non-essential. For example, the best use case in today’s JavaScript is to help avoid unintended returns on single-line arrow functions.

As you probably know, a single-line arrow function will return the result of that line, even if you don’t specifically use the `return` statement.

```JavaScript
const double = x => x * 2; //returns the result of X times 2

const callAfunction = () => myFunction(); //returns what myFunction returns, even when i dont want to
```

Both these functions will return **something**. Clearly, for the `double` function, that’s intended, but the other one might not be, you might just want to call this function, but you’re not interested in its result value. There you can do:

```JavaScript
const callAfunction = () => void myFunction(); //returns what myFunction returns, even when i dont want to
```

And that would immediately obscure the returned value and make sure your call only returns `undefined`.

This behavior, to me, provides a minimal benefit, rendering `void` useless in this time and age of JavaScript.

I would suggest you avoid it and let it wither into a deprecated state.

## With statement

This one is yet one of those constructs that JavaScript has but you’ve probably never heard about it because it’s not really promoted. In fact, even MDN’s official documentation discourages you from using it, because it can lead to very confusing code.

You see, the `with` statement allows you to extend the scope chain for a given statement. In other words, it allows you to inject an expression into the scope of a given statement, ideally, simplifying said statement.

Here is an example so you get what I’m awkwardly trying to say:

```JavaScript
function greet(user) {
  
  with(user) {
    console.log(`Hello there ${name}, how are you and your ${kids.length} kids today?`)
  }
}

greet({
  name: "Fernando",
  kids: ["Brian", "Andrew"]
})
```

Notice the “magic” of the `with` statement inside the `greet` function. Now this is a basic example showing the “happy path” of the expression. But let’s take a look at another case where things get a bit more complicated:

```JavaScript
function greet(user, message) {
  with(user) {
    console.log(`Hey ${name}, here is a message for you: ${message}`)
  }
}

//happy path:
greet({
  name: "Fernando"
}, "You got 2 emails")

//kinda sad path
greet({
  name: "Fernando",
  message: "Unrelated message"
}, "you got email")
```

What do you think would be the output from that execution?

```
Hey Fernando, here is a message for you: You got 2 emails
Hey Fernando, here is a message for you: Unrelated message
```

You’ve unwillingly overwritten the second argument of your function by adding an equally named property to your object. Something, I might add, that is completely normal, since one would never expect both to be at the same scope level. However, thanks to `with` we’ve mixed both scopes and the result is not ideal.

This is all to say, avoid `with`, while it might seem like a great way to save some keystrokes, you’ll create code that can turn very complex very fast, and mentally parsing it can be a challenge for someone else (or you, two weeks in the future).

## Labels

If you’re old enough (like me), you’ve experienced the hate for go-to statements in other languages such as C. That was terrible, that was a feature that made a lot of sense back in the day, but that eventually, with newer solutions to the same problem, became so obsolete and bad that it turned into an anti-pattern.

So of course, JavaScript had to implement it. Kind of.

A go-to statement is a way for you to place a marker **anywhere** on your code, and then jump there, from **anywhere** else. You could be jumping to the middle of a function, or inside an `IF` statement, it was like a magic portal to anywhere inside your code. I’m sure you can see how that can be a problem, it’s just too much power, too much flexibility, of course we’re going to miss use it!

JavaScript however, implemented a similar, yet not identical construct: labels.

A labeled statement in JavaScript is a mark you put before a statement which you can then either `break` out of or `continue`. Notice how there is no more `go-to` which is a definite plus.

You can write something like this:

```JavaScript
label1: {
  console.log(1)
  let condition = true
  if(condition) {
  	break label1
  }
  console.log(2)
}
console.log("end")
```

And the output would be:

```
1
end
```

Of course, that example looks an awful lot like an `if..else` statement. And you can perfectly say that it doesn’t look that bad. However, you’re breaking from the normal flow of the code and skipping statements. If you’re aiming to do that, an `if..else` is much easier to mentally parse by others.

The problem with labels becomes a bit more evident when we include their interaction with loops and the `continue` statement.

```JavaScript
let i, j;

loop1:
for(i = 0; i < 10; i++) {
  loop2:
  for(j = 0; j < 10; j++) {

    if(j == 3 && i == 2) {
      continue loop2;
    }
    console.log({i, j})
    if(j % 2 == 0) {
      continue loop1;
    }
  }
}
```

Can you mentally parse the above code and tell me exactly what the output will be? It’s not impossible, but it’ll take you a while. The above script will print:

```
{ i: 0, j: 0 }
{ i: 1, j: 0 }
{ i: 2, j: 0 }
{ i: 3, j: 0 }
{ i: 4, j: 0 }
{ i: 5, j: 0 }
{ i: 6, j: 0 }
{ i: 7, j: 0 }
{ i: 8, j: 0 }
{ i: 9, j: 0 }
```

Essentially, the second `if` is evaluating `true` on `0` so the `continue` statement affects the outer loop, causing it to move to the next index value, which in turn, resets the inner loop, causing it to go back to zero, and the same thing happens, over and over, ten times. The first `if` , in case you’re wondering, never gets to evaluate to `true`, because `j` never reaches any value other than `0`.

Labels can be tricky little fellas, and even if you get them to work, they make a lot of sense from an interpreter perspective, but you should be writing code for humans, not for machines. Someone else is going to come and read it (or even you in 3 weeks), and the moment they lay eyes on the labels, they’ll hate you forever — and of course, they’ll take a lot longer to understand the basic flow of your code, but that’s a secondary problem at this point.

## Conclusion

I love JavaScript, don’t get me wrong, I’ve been interacting with it in different ways since I started working as a web developer 18 years ago. I’ve seen the language evolve and, like a fine wine, get better with time. However, I’d be lying if I said there aren’t some dark corners of the language where I just don’t like to get myself into. And these 3 elements show exactly that.

The good news is that in my years of experience, I’m yet to see either `with` or labels be implemented and deployed into production. That’s not to say there aren’t cases like that, but the fact that I’ve never seen one makes me think not many code-review processes let them pass.

How about you? Have you seen any of these constructs being used in modern-day JavaScript?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
