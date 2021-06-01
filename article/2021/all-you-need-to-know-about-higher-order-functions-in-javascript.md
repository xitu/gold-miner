> * 原文地址：[All You Need to Know About Higher-Order Functions in JavaScript](https://javascript.plainenglish.io/all-you-need-to-know-about-higher-order-functions-in-javascript-19d30c8cc8e5)
> * 原文作者：[Rahul](https://medium.com/@rahulism)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/all-you-need-to-know-about-higher-order-functions-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/all-you-need-to-know-about-higher-order-functions-in-javascript.md)
> * 译者：
> * 校对者：

# All You Need to Know About Higher-Order Functions in JavaScript

![](https://cdn-images-1.medium.com/max/2400/1*KQnA_VQkW6DVV-4zLBu_-Q.png)

As a JavaScript developer, you will utilize higher-order functions frequently. So, having a decent comprehension of these functions is vital. Presently I see individuals get frequently confounded when finding out about the `reduce()` technique. Yet, I had clarified everything in detail so attempt to comprehend it bit by bit, and I'm certain you will dominate it.

---

## What are higher-order functions?

In a nutshell, higher-order functions are those functions that take other functions as arguments or return other functions. The function passed as arguments in higher-order function is known as callbacks.

**Why use Higher-Order Functions?**

* They help us to write clean and simple code.
* Since the code will be clean, it will be easier to debug.

Now JavaScript has some built-in higher-order functions, you may have already been using them without even realising — (filter(), reduce(), sort(), forEach()).

---

## filter()

The filter method returns a new array of elements that passes a specific test provided by a callback function. And since `filter` takes a callback function, therefore `filter()` is known as higher-order function.

Now the callback function that is passed into `filter()` is known as the higher- order function.

* `value of the element` (required)
* `index of the element` (optional)
* `the array object` (optional)

```
let arr [1,2,3,4,5]; 

const resultant Array = arr.filter((element ) => {
    return element > 3; 
})

console.log(resultantArray); // [4, 5]
```

In the above example, what’s happening is that the elements of the `arr` array is getting passed one by one into the `filter()` callback method and they are getting tested for a specific test that is `element > 3`. And those elements which are passing the test are getting pushed in the `resultantArray`, that's why the output is [4,5] since 4 and 5 were the only elements that pass the test.

The `element argument` is getting the value of elements of `arr` array one by one, it will first become 1 and then it will test `1>3` if it's true 1 will get pushed in the resultant array and if it's false it will be skipped to the next element.

Example:

```
// filter age that is less than 18

const ageArray = [10, 12, 35, 55, 40, 32, 15]; 

const filterAgeArray = ageArray.filter((age)=> {
    return age < 18; >
}); 

console.log(filterAgeArray); 
// [10, 12, 15]

-----------------

// /filter positive numbers

const numArray = [-2, 1, 50, 20, -47, -40]; 

const positiveArray = numArray.filter((num) => {
    return num > 0; 
}); 

console.log(positiveArray);
// [1, 50, 20]

-----------------

// filter names that contains `sh` in it

const namesArray = ["samuel", "rahul", "harsh", "hitesh"]; 

const filterNameArray = namesArray.filter((name) =>{
    return name.includes("sh"); 
}); 

console.log(filterNameArray); 
// ["harsh", "hitesh"]
```

---

## map()

As the name suggests, the `map()` method is used to map the values of an existing array to new values and it pushes that new values to a new array and it returns that new array. Now `map()` also takes a callback function and hence it is known as higher-order function.

Now the callback fucntion that is passed into `map()` method takes three arguments:

* `values of the element` (required)
* `index of the element` (optional)
* `the array object` (optional)

```
const numArray = [1, 5, 3, 6, 4, 7]; 

const increasedArray = numArray.map((element) => {
    return element + 1; 
}); 

console.log(increasedArray);
[2, 6, 4, 7, 5, 8]
```

Just like in `filter()`, the elements of numArray will be passed one by one into the `map()` callback function (as the element argument) and they will get mapped into a new value that is `element + 1` and then they will be pushed into the `increasedArray`.

Firstly 1 will get a pass as an element argument and it will get the map to a new value that is `element + 1` such that 1 + 1 (because here element is 1) and the 2 will get pushed into increased Array and so on for 5, 3, 6, 4, 7.

Example:

```
// exponentiate every number on an array

const numArray = [2, 3, 4, 5, 15]; 

const poweredArray = numArray.map((number) => {
    return number * number; 
}); 

console.log(poweredArray); 
// [4, 9 ,16, 25, 144, 225]

// extract the marks of student

const studentsArray = [
    {
        name: "Rahul", 
        marks: 45, 
    }, 
    {
        name: "Samuel", 
        marks: 85, 
    }, 
    {
        name: "Chris", 
        marks: 25, 
    },
]; 

const ScoreArray = studentsArray.map((student) => {
    return student.marks; 
}); 

console.log(scoreArray); 
// [45, 85, 25]
```

## reduce()

The `reduce()` method is used to reduce the array to a single value, just like `filter()` and `map()`, `reduce()` also takes a callback function as an argument hence it is known as a higher-order function.

But `reduce()` takes one more argument other than the callback function and that is `initialValue`. And again like `filter()` and `map()` the callback function passed into `reduce()` takes some arguments but the callback functions passed into reduce takes 4 arguments instead of 3.

* `total` (required)
* `value of the elements` (required)
* `index of the element` (optional)
* `the array object` (optional)

```
// A basic example reduce()

const numArray = [1, 2, 3, 4, 5]; 

const sum = numArray.reduce((total, num) => {
    return total + num; 
}); 

console.log(sum);
```

Let’s first understand what **total argument** is:- Total argument is the previous value returned by `reduce()` function, now when the `reduce()` will run for the first time there will be no previous returned value therefore for the first time `total argument` is equal to the initialValue(remember the second argument that we passed into `reduce()`).

Now we also haven’t used the initialValue in our example, so what is that **when we don’t pass initialValue, the reduce() method skips the first element of the numArray becomes the value of total argument**.

Coming to our example, we haven’t passed initialValue so the first element of numArray such that `1` will become the value of total argument and the second element of `numArray` will pass as num argument, and the reduction will return `total + num` such that `1+2 = 3`, 3 will become the new value of total and now the third element from `numArray` will get a pass into `reduce()` callback as **num argument**, again reduce will return **total + num** that is 3 + 3 = 6 and 6 will become the new value of total and so on.

(This explanation is a bit tough and confusing. If you try to learn step by step you will master `reduce()`).

#### The initialValue argument

initialValue as the name suggests, is the initial value of the total argument, as we know when `reduce()` runs for the first time there is no previous returned value and hence the first element from existing array **(numArray in our case)** becomes the value of the total argument, so instead of doing that we can give an initial value to the total argument (remember initialValue will be the initial value of the total argument, the total argument will become the previous return value of reduce() later).

**Note:** When you will use the initialValue argument, numArray will not skip it’s the first element hence every element will get passed into the `reduce()` callback.

Syntax of reduce() with initial value:

```
const resultantArray = existingArray.reduce((total,element,index.array)=> {
    // return something
}, initialValue);
```

---

Thank you for reading!

You can follow me on Twitter — [@rahxul](https://twitter.com/rahxul)

**More content at [plainenglish.io](http://plainenglish.io/)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
