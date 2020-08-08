> * 原文地址：[My Favorite JavaScript Tips and Tricks](https://blog.greenroots.info/my-favorite-javascript-tips-and-tricks-ckd60i4cq011em8s16uobcelc)
> * 原文作者：[Tapas Adhikary](https://hashnode.com/@atapas)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/my-favorite-javascript-tips-and-tricks.md](https://github.com/xitu/gold-miner/blob/master/article/2020/my-favorite-javascript-tips-and-tricks.md)
> * 译者：
> * 校对者：

# My Favorite JavaScript Tips and Tricks

![image](https://user-images.githubusercontent.com/5164225/89246151-0dbc1300-d63d-11ea-982e-fa61dd13b7d9.png)

## Motivation

Most of the programming languages are open enough to allow programmers doing things multiple ways for the similar outcome. JavaScript is no way different. With JavaScript, we often find multiple ways of doing things for a similar outcome, and that's confusing at times.

Some of the usages are better than the other alternatives and thus, these are my favorites. I am going to list them here in this article. I am sure, you will find many of these in your list too.

## 1. Forget string concatenation, use template string(literal)

Concatenating strings together using the `+` operator to build a meaningful string is old school. Moreover, concatenating strings with dynamic values(or expressions) could lead to frustrations and bugs.

```js
let name = 'Charlse';
let place = 'India';
let isPrime = bit => {
  return (bit === 'P' ? 'Prime' : 'Nom-Prime');
}

// string concatenation using + operator
let messageConcat = 'Mr. ' + name + ' is from ' + place + '. He is a' + ' ' + isPrime('P') + ' member.'
```

Template literals(or Template strings) allow embedding expressions. It has got unique syntax where the string has to be enclosed by the backtick (\`\`). Template string can contain placeholders for dynamic values. These are marked by the dollar sign and curly braces (${expression}).

Here is an example demonstrating it,

```js
let name = 'Charlse';
let place = 'India';
let isPrime = bit => {
  return (bit === 'P' ? 'Prime' : 'Nom-Prime');
}

// using template string
let messageTemplateStr = `Mr. ${name} is from ${place}. He is a ${isPrime('P')} member.`
console.log(messageTemplateStr);
```

## 2. isInteger

There is a much cleaner way to know if a value is an integer. The `Number` API of JavaScript provides a method called, `isInteger()` to serve this purpose. It is very useful and better to be aware.

```js
let mynum = 123;
let mynumStr = "123";

console.log(`${mynum} is a number?`, Number.isInteger(mynum));
console.log(`${mynumStr} is a number?`, Number.isInteger(mynumStr));
```

Output:

![2.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595930285107/RiLxixUxC.png?auto=format&q=60)

## 3. Value as Number

Have you ever noticed, `event.target.value` always returns a string type value even when the input box is of type number?

Yes, see the example below. We have a simple text box of type number. It means it accepts only numbers as input. It has an event handler to handle the key-up events.

```html
<input type='number' onkeyup="trackChange(event)" />
```

In the event handler method we take out the value using `event.target.value`. But it returns a string type value. Now I will have additional headache to parse it to an integer. What if the input box accepts floating numbers(like, 16.56)? parseFloat() then? Ah, all sort of confusions and extra work!

```js
function trackChange(event) {
   let value = event.target.value;
   console.log(`is ${value} a number?`, Number.isInteger(value));
}
```

Use `event.target.valueAsNumber` instead. It returns the value as number.

```js
let valueAsNumber = event.target.valueAsNumber;
console.log(`is ${value} a number?`, Number.isInteger(valueAsNumber));
```

![3.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595935455526/Tv1sEFRxe.png?auto=format&q=60)

## 4. Short hand with AND

Lets consider a situation where we have a boolean value and a function.

```js
let isPrime = true;
const startWatching = () => {
    console.log('Started Watching!');
}
```

This is too much code to check for the boolean condition and invoke the function,

```js
if (isPrime) {
    startWatching();
}
```

How about using the short-hand using the AND(&&) operator? Yes, avoid `if` statement altogether. Cool, right?

```js
isPrime && startWatching();
```

## 5. Default value with OR

If you ever like to set a default value for a variable, you can do it using the OR(||) operator easily.

```js
let person = {name: 'Jack'};
let age = person.age || 35; // sets the value 35 if age is undefined
console.log(`Age of ${person.name} is ${age}`);
```

## 6. Randoms

Generating random number or getting a random item from an array are very useful methods to keep handy. I have seen them appearing multiple times in many of my projects.

Get a random item from an array,

```js
let planets = ['Mercury ', 'Mars', 'Venus', 'Earth', 'Neptune', 'Uranus', 'Saturn', 'Jupiter'];
let randomPlanet = planets[Math.floor(Math.random() * planets.length)];
console.log('Random Planet', randomPlanet);
```

Generate a random number from a range by specifying the min and max values,

```js
let getRandom = (min, max) => {
    return Math.round(Math.random() * (max - min) + min);
}
console.log('Get random', getRandom(0, 10));
```

## 7. Function default params

In JavaScript, function arguments(or params) are like local variables to that function. You may or may not pass values for those while invoking the function. If you do not pass a value for a param, it will be `undefined` and may cause some unwanted side effects.

There is a simple way to pass a default value to the function parameters while defining them. Here is an example where we are passing the default value `Hello` to the parameter `message` of the `greetings` function.

```js
let greetings = (name, message='Hello,') => {
    return `${message} ${name}`;
}

console.log(greetings('Jack'));
console.log(greetings('Jack', 'Hola!'));

```

## 8. Required Function Params

Expanding on the default parameter technique, we can mark a parameter as mandatory. First define a function to throw an error with an error message,

```js
let isRequired = () => {
    throw new Error('This is a mandatory parameter.');
}
```

Then assign the function as the default value for the required parameters. Remember, the default values are ignored when a value is passed for a parameter at the invocation time. But, the default value is considered if the parameter value is `undefined`.

```js
let greetings = (name=isRequired(), message='Hello,') => {
    return `${message} ${name}`;
}
console.log(greetings());
```

In the above code, `name` will be undefined and that will try to set the default value for it which is the `isRequired()` function. It will throw an error as,

![8.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595930079306/ossRyuA7X.png?auto=format&q=60)

## 9. Comma Operator

I was surprised when I realized, comma(,) is a separate operator and never gone noticed. I have been using it so much in code but, never realized its true existence.

In JavaScript, the comma(,) operator is used for evaluating each of its operands from left to right and returns the value of the last operand.

```js
let count = 1;
let ret = (count++, count);
console.log(ret);
```

In the above example, the value of the variable `ret` will be, 2. Similar way, the output of the following code will be logging the value 32 into the console.

```js
let val = (12, 32);
console.log(val);
```

Where do we use it? Any guesses? The most common usage of the comma(,) operator is to supply multiple parameters in a for loop.

```js
for (var i = 0, j = 50; i <= 50; i++, j--)
```

## 10. Merging multiple objects

You may have a need to merge two objects together and create a better informative object to work with. You can use the spread operator `...`(yes, three dots!).

Consider two objects, emp and job respectively,

```js
let emp = {
 'id': 'E_01',
 'name': 'Jack',
 'age': 32,
 'addr': 'India'
};

let job = {
 'title': 'Software Dev',
  'location': 'Paris'
};
```

Merge them using the spread operator as,

```js
// spread operator
let merged = {...emp, ...job};
console.log('Spread merged', merged);
```

There is another way to perform this merge. Using `Object.assign()`. You can do it like,

```js
console.log('Object assign', Object.assign({}, emp, job));
```

Output:

![10.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595930544621/2jCCxCSnz.png?auto=format&q=60)

Note, both spread operator and the Object.assign perform a shallow merge. In a shallow merge, the properties of the first object are overwritten with the same property values of the second object.

For deep merge, please use something like, `_merge` of [lodash](https://lodash.com/).

## 11. Destructuring

The technique of breaking down the array elements and object properties as variables called, `destructuring`. Let us see it with few examples,

### Array

Here we have an array of emojis,

```js
let emojis = ['🔥', '⏲️', '🏆', '🍉'];
```

To destructure, we would use a syntax as follows,

```js
let [fire, clock, , watermelon] = emojis;
```

This is same as doing, `let fire = emojis[0];` but with lots more flexibility. Have you noticed, I have just ignored the trophy emoji using an empty space in-between? So what will be the output of this?

```js
console.log(fire, clock, watermelon);
```

Output:

![11.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595931639636/TXaeEwgGq.png?auto=format&q=60)

Let me also introduce something called `rest` operator here. If you want to destructure an array such that, you want to assign one or more items to variables and park rest of it into another array, you can do that using `...rest` as shown below.

```js
let [fruit, ...rest] = emojis;
console.log(rest);
```

Output:

![11.a.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595932001526/GdWuvDoP8.png?auto=format&q=60)

### Object

Like arrays we can also destructure objects.

```js
let shape = {
  name: 'rect',
  sides: 4,
  height: 300,
  width: 500
};
```

Destructuring such that, we get name, sides in couple of variables and rest are in another object.

```js
let {name, sides, ...restObj} = shape;
console.log(name, sides);
console.log(restObj);
```

Output:

![11.b.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1595932176160/97vWj-QQl.png?auto=format&q=60)

Read more about this topic [from here](https://javascript.info/destructuring-assignment).

## 12. Swap variables

This must be super easy now using the concept of `destructuring` we learned just now.

```js
let fire = '🔥';
let fruit = '🍉';

[fruit, fire] = [fire, fruit];
console.log(fire, fruit);
```

## 13. isArray

Another useful method for determining if an input is an Array or not.

```js
let emojis = ['🔥', '⏲️', '🏆', '🍉'];
console.log(Array.isArray(emojis));

let obj = {};
console.log(Array.isArray(obj));
```

## 14. undefined vs null

`undefined` is where a value is not defined for a variable but, the variable has been declared.

`null` itself is an empty and non-existent value which must be assigned to a variable explicitly.

`undefined` and `null` are not strictly equal,

```js
undefined === null // false
```

Read more about this topic [from here](https://stackoverflow.com/questions/5076944/what-is-the-difference-between-null-and-undefined-in-javascript).

## 15. Get Query Params

`window.location` object has bunch of utility methods and properties. We can get information about protocol, host, port, domain etc from the browser urls using these properties and methods.

One of the properties that I found very useful is,

```js
window.location.search
```

The `search` property returns the query string from the location url. Here is an example url: `https://tapasadhiary.com?project=js`. The `location.search` will return, `?project=js`

We can use another useful interface called, `URLSearchParams` along with `location.search` to get the value of the query parameters.

```js
let project = new URLSearchParams(location.search).get('project');
```

Output: `js`

Read more about this topic [from here](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams).

# This is not the end

This is not the end of the list. There are many many more. I have decided to push those to the git repo as mini examples as and when I encounter them.

[https://github.com/atapas/js-tips-tricks](https://github.com/atapas/js-tips-tricks)

What are your favorite JavaScript tips and tricks? How about you let us know about your favorites in the comment below?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
