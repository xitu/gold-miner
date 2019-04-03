> * 原文地址：[An Illustrated (and Musical) Guide to Map, Reduce, and Filter Array Methods](https://css-tricks.com/an-illustrated-and-musical-guide-to-map-reduce-and-filter-array-methods/)
> * 原文作者：[Una Kravets](https://css-tricks.com/author/unakravets/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-illustrated-and-musical-guide-to-map-reduce-and-filter-array-methods.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-illustrated-and-musical-guide-to-map-reduce-and-filter-array-methods.md)
> * 译者：
> * 校对者：

# An Illustrated (and Musical) Guide to Map, Reduce, and Filter Array Methods

Map, reduce, and filter are three very useful array methods in JavaScript that give developers a ton of power in a short amount of space. Let's jump right into how you can leverage (and remember how to use!) these super handy methods.

## Array.map()

`Array.map()` updates each individual value in a given array based on a provided transformation and returns a new array of the same size. It accepts a callback function as an argument, which it uses to apply the transform.

```js
let newArray = oldArray.map((value, index, array) => {
  ...
});
```

> A mnemonic to remember this is MAP: Morph Array Piece-by-Piece.

Instead of a for-each loop to go through and apply this transformation to each value, you can use a map. This works when you want to preserve each value, but update it. We're not potentially eliminating any values (like we would with a filter), or calculating a new output (like we would use reduce for). A map lets you morph an array piece-by-piece. Let's take a look at an example:

```js
[1, 4, 6, 14, 32, 78].map(val => val * 10)
// the result is: [10, 40, 60, 140, 320, 780]
```

In the above example, we take an initial array (`[1, 4, 6, 14, 32, 78]`) and map each value in it to be that value times ten (`val * 10`). The result is a new array with each value of the original array transformed by the equation: `[10, 40, 60, 140, 320, 780]`.

![An illustration of the code examples covered in this section.](https://css-tricks.com/wp-content/uploads/2019/03/arrays-01.png)

## Array.filter()

`Array.filter()` is a very handy shortcut when we have an array of values and want to filter those values into another array, where each value in the new array is a value that passes a specific test.

This works like a search filter. We're filtering out values that pass the parameters we provide.

For example, if we have an array of numeric values, and want to filter them to just the values that are larger than 10, we could write:

```js
[1, 4, 6, 14, 32, 78].filter(val => val > 10)
// the result is: [14, 32, 78]
```

If we were to use a *map* method on this array, such as in the example above, we would return an array of the same length as the original with `val > 10` being the "transform," or a test in this case. We transform each of the original values to their answer if they are greater than 10. It would look like this:

```js
[1, 4, 6, 14, 32, 78].map(val => val > 10)
// the result is: [false, false, false, true, true, true]
```

A filter, however, returns *only* the true values. So the result is smaller than the original array or the same size if all values pass a specific test.

> Think about filter like a strainer-type-of-filter. Some of the mix will pass through into the result, but some will be left behind and discarded.

![An illustration of a funnel with numbers going in the top and a few coming out of the bottom next to a handwritten version of the code covered in this section.](https://css-tricks.com/wp-content/uploads/2019/03/arrays-02.png)

Say we have a (very small) class of four dogs in obedience school. All of the dogs had challenges throughout obedience school and took a graded final exam. We'll represent the doggies as an array of objects, i.e.:

```js
const students = [
  {
    name: "Boops",
    finalGrade: 80
  },
  {
    name: "Kitten",
    finalGrade: 45
  },
  {
    name: "Taco",
    finalGrade: 100
  },
  {
    name: "Lucy",
    finalGrade: 60
  }
]
```

If the dogs get a score higher than 70 on their final test, they get a fancy certificate; and if they don't, they'll need to take the course again. In order to know how many certificates to print, we need to write a method that will return the dogs with passing grades. Instead of writing out a loop to test each object in the array, we can shorten our code with `filter`!

```js
const passingDogs = students.filter((student) => {
  return student.finalGrade >= 70
})

/*
passingDogs = [
  {
    name: "Boops",
    finalGrade: 80
  },
  {
    name: "Taco",
    finalGrade: 100
  }
]
*/
```

As you can see, Boops and Taco are good dogs (actually, all dogs are good dogs), so Boops and Taco are getting certificates of achievement for passing the course! We can write this in a single line of code with our lovely implicit returns and then remove the parenthesis from our arrow function since we have single argument:

```js
const passingDogs = students.filter(student => student.finalGrade >= 70)

/*
passingDogs = [
  {
    name: "Boops",
    finalGrade: 80
  },
  {
    name: "Taco",
    finalGrade: 100
  }
]
*/
```

## Array.reduce()

The `reduce()` method takes the input values of an array and returns a single value. This one is really interesting. Reduce accepts a callback function which consists of an accumulator (a value that accumulates each piece of the array, [growing like a snowball](https://css-tricks.com/understanding-the-almighty-reducer/)), the value itself, and the index. It also takes a starting value as a second argument:

```js
let finalVal = oldArray.reduce((accumulator, currentValue, currentIndex, array) => {
  ...
}), initalValue;
```

![An illustration of a saucepan cooking ingredients next to handwritten code from the examples covered in this section.](https://css-tricks.com/wp-content/uploads/2019/03/arrays-03.png)

Let's set up a cook function and a list of ingredients:

```js
// our list of ingredients in an array
const ingredients = ['wine', 'tomato', 'onion', 'mushroom']

// a cooking function
const cook = (ingredient) => {
    return `cooked ${ingredient}`
}
```

If we want to reduce the items into a sauce (pun absolutely intended), we'll reduce them with `reduce()`!

```js
const wineReduction = ingredients.reduce((sauce, item) => {
  return sauce += cook(item) + ', '
  }, '')

// wineReduction = "cooked wine, cooked tomato, cooked onion, cooked mushroom, "
```

That initial value (`''` in our case) is important because if we don't have it, we don't cook the first item. It makes our output a little wonky, so it's definitely something to watch out for. Here's what I mean:

```js
const wineReduction = ingredients.reduce((sauce, item) => {
  return sauce += cook(item) + ', '
  })

// wineReduction = "winecooked tomato, cooked onion, cooked mushroom, "
```

Finally, to make sure we don't have any excess spaces at the end of our new string, we can pass in the index and the array to apply our transformation:

```js
const wineReduction = ingredients.reduce((sauce, item, index, array) => {
  sauce += cook(item)
  if (index < array.length - 1) {
        sauce += ', '
        }
        return sauce
  }, '')

// wineReduction = "cooked wine, cooked tomato, cooked onion, cooked mushroom"
```

Now we can write this even more concisely (in a single line!) using ternary operators, string templates, and implicit returns:

```js
const wineReduction = ingredients.reduce((sauce, item, index, array) => {
  return (index < array.length - 1) ? sauce += `${cook(item)}, ` : sauce += `${cook(item)}`
}, '')

// wineReduction = "cooked wine, cooked tomato, cooked onion, cooked mushroom"
```

> A little way to remember this is to recall how you make sauce: you reduce a few ingredients down to a single item.

## Sing it with me!

I wanted to end this blog post with a song, so I wrote a little ditty about array methods that might just help you to remember them:

[Video](https://youtu.be/-_YEbB_y3Mk)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
