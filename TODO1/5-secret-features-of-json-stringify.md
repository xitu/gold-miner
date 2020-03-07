> * 原文地址：[5 Secret features of JSON.stringify()](https://medium.com/javascript-in-plain-english/5-secret-features-of-json-stringify-c699340f9f27)
> * 原文作者：[Prateek Singh](https://medium.com/@prateeksingh_31398)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-secret-features-of-json-stringify.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-secret-features-of-json-stringify.md)
> * 译者：
> * 校对者：

# 5 Secret features of JSON.stringify()

![Credits: [Kirmeli.com](https://www.google.com/url?sa=i&url=https%3A%2F%2Fahmedalkiremli.com%2Fwhy-to-learn-what-to-learn-and-how-to-learn%2F&psig=AOvVaw3IGik44VGBXe661UZsW5Mh&ust=1581750442478000&source=images&cd=vfe&ved=0CAMQjB1qFwoTCMj-5Oi90OcCFQAAAAAdAAAAABAR)](https://cdn-images-1.medium.com/max/2000/1*aQy1TrGzC_n_UC0j9hXBbw.jpeg)

> # The JSON. stringify() method converts a JavaScript object or value to a JSON string.

Being a JavaScript developer, `JSON.stringify()` is the most common functions used for debugging. But what is the use of this, can’t we use our friend `console.log()` alone for the same? Let’s give it a try.

```
//Initialize a User object
const user = {
 “name” : “Prateek Singh”,
 “age” : 26
}

console.log(user);

RESULT
// [object Object]
```

Oops! `console.log()` didn’t help us print the desired result. It prints `**[object Object]**` **because the default conversion from an object to string is “[object Object]”**. So we use `JSON.stringify()` to first convert the object into a string and then print in the console, like this.

```
const user = {
 “name” : “Prateek Singh”,
 “age” : 26
}

console.log(JSON.stringify(user));

RESULT
// "{ "name" : "Prateek Singh", "age" : 26 }"
```

---

Generally, developers use this `stringify` function in a simple way as we did above. But I am gonna tell you some hidden secrets of this little gem which will make your life easy.

---

## 1: The second argument (Array)

Yes, ours `stringify` function can have a 2nd argument also. It’s an array of keys to the object which you want to print in the console. Look simple? Let’s take a closer look. We have an object **product** & we want to know the name of the product. When when we print it as:
 console.log(JSON.stringify(product)); 
it gives the below result.

```
{“id”:”0001",”type”:”donut”,”name”:”Cake”,”ppu”:0.55,”batters”:{“batter”:[{“id”:”1001",”type”:”Regular”},{“id”:”1002",”type”:”Chocolate”},{“id”:”1003",”type”:”Blueberry”},{“id”:”1004",”type”:”Devil’s Food”}]},”topping”:[{“id”:”5001",”type”:”None”},{“id”:”5002",”type”:”Glazed”},{“id”:”5005",”type”:”Sugar”},{“id”:”5007",”type”:”Powdered Sugar”},{“id”:”5006",”type”:”Chocolate with Sprinkles”},{“id”:”5003",”type”:”Chocolate”},{“id”:”5004",”type”:”Maple”}]}
```

It is difficult to find the **name** key in the log as there is a lot of useless info displayed on the console. When the object grows bigger, difficulty increases.
The 2nd argument of stringify function comes into the rescue. Let’s rewrite the code again & see the result.

```
console.log(JSON.stringify(product,[‘name’]);

//RESULT
{"name" : "Cake"}
```

Problem solved, instead of printing the whole JSON object we can print only the required key by passing it as an array in the 2nd argument.

---

## 2: The second argument (Function)

We can also pass a 2nd argument as a function. It evaluates each key-value pair according to the logic written in the function. If you return `undefined` the key-value pair will not print. See this example for a better understanding.

```
const user = {
 “name” : “Prateek Singh”,
 “age” : 26
}
```

![Passing function as 2nd argument](https://cdn-images-1.medium.com/max/2000/1*V3EQcCdgRLDish8PkY0s5A.png)

```
// Result
{ "age" : 26 }
```

Only `age` is printed as our function condition return `undefined` for the value `typeOf` String.

## 3: The third argument as Number

The third argument controls the spacing in the final string. If the argument is a **number**, each level in the stringification will be indented with this number of space characters.

```
Note: '--' represnts the spacing for understanding purpose

JSON.stringify(user, null, 2);
//{
//--"name": "Prateek Singh",
//--"age": 26,
//--"country": "India"
//}
```

## 4: The third argument as String

If the third argument is a **string**, it will be used instead of the space character as displayed above.

```
JSON.stringify(user, null,'**');
//{
//**"name": "Prateek Singh",
//**"age": 26,
//**"country": "India"
//}
Here * replace the space character.
```

## 5: The toJSON method

We have one method named `toJSON` which can be a part of any object as its property. `JSON.stringify` returns the result of this function and stringifies it instead of converting the whole object into the string. See this example.

```
const user = {
 firstName : "Prateek",
 lastName : "Singh",
 age : 26,
 toJSON() {
    return { 
      fullName: `${this.firstName} + ${this.lastName}`
    };

}

console.log(JSON.stringify(user));

RESULT
// "{ "fullName" : "Prateek Singh"}"
```

Here we can see instead of printing the whole object, it only prints the result of `toJSON` function.

I hope you learned some owsmm features of our little friend `stringify()` .

If you find this article useful, please hit the ‘clap’ button and follow me with more exciting articles like this.

> # Thanks For Reading

> # Happy Coding || Write 2 Learn

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
