> * 原文地址：[Understanding Recursion, Tail Call and Trampoline Optimizations](https://marmelab.com/blog/2018/02/12/understanding-recursion.html)
> * 原文作者：[Thiery Michel](https://twitter.com/hyriel_mecrith)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-recursion.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-recursion.md)
> * 译者：
> * 校对者：

# Understanding Recursion, Tail Call and Trampoline Optimizations

In order to understand recursion, you must understand recursion. Joke aside, [recursion](https://en.wikipedia.org/wiki/Recursion) is a programming technique allowing to loop execution without using `for` or `while`, but using a function that calls itself.

## Example 1: Sum of Integers

For instance, let's say we want to sum integers from 1 to i. The goal is to have the following result:

```js
sumIntegers(1); // 1
sumIntegers(3); // 1 + 2 + 3 = 6
sumIntegers(5); // 1 + 2 + 3 + 4 + 5 = 15
```

Here is the code without recursion:

```js
// loop
const sumIntegers = i => {
    let sum = 0; // initialization
    do { // repeat
        sum += i; // operation
        i --; // next step
    } while(i > 0); // stop condition

    return sum;
}
```

And with recursion:

```js
// loop
const sumIntegers = (i, sum = 0) => { // initialization
    if (i === 0) { // stop condition
        return sum; // sum
    }

    return sumIntegers( // repeat
        i - 1, // next step
        sum + i // operation
    );
}

// or even simpler
const sumIntegers = i => {
    if (i === 0) {
        return i;
    }
    return i + sumIntegers(i - 1);
}
```

So that's the basis of recursion.

Note that the recursion version has **no intermediate variables**. It doesn't use `for` or `do...while`. It's **declarative**.

And in case you wonder, the recursive version is **slower** than the loop version - at least in JavaScript. Recursion isn't a matter of performance, but of expressiveness.

![inception](https://marmelab.com/images/blog/inception1.jpg)

## [](#example-2-sum-of-array-elements)Example 2: Sum of Array Elements

Let's try a slightly more complex example, a function that add all numbers in an array.

```js
sumArrayItems([]); // 0
sumArrayItems([1, 1, 1]); // 1 + 1 + 1 = 3
sumArrayItems([3, 6, 1]); // 3 + 6 + 1 = 10

// loop
const sumArrayItems = list => {
    let result = 0;
    for (var i = 0; i++; i <= list.length) {
        result += list[i];
    }
    return result;
}
```

As you can see, the loop version is imperative: you tell the program exactly **what to do** to get the sum of all numbers. Here is the version with recursion:

```js
// recursive
const sumArrayItems = list => {
    switch(list.length) {
        case 0:
            return 0; // the sum of an empty array is 0
        case 1:
            return list[0]; // the sum of an array of a single element, is it's only element. #captain_obvious
        default:
            return list[0] + sumArrayItems(list.slice(1)); // otherwise the sum of an array, is the array first element + the sum of the remaining elements.
    }
}
```

The recursive version is much more interesting, as we do not tell the program **what to do**, we introduce simple rules to **define** what the sum of all numbers in an array is.

If you're a fan of functional programming, you may prefer the `Array.reduce()` version:

```text
// reduce
const sumArrayItems = list => list.reduce((sum, item) => sum + item, 0);
```

It's way shorter, and very expressive. But that's a topic for another article.

![inception](https://marmelab.com/images/blog/inception2.jpg)

## [](#example-3-quick-sort)Example 3: Quick Sort

Now, let's see another example, this time a bit more complex: [QuickSort](https://en.wikipedia.org/wiki/Quicksort). QuickSort is one of the quickest algorithms to sort an array.

Quicksort sorts an array by taking its first element, and then splitting the rest in an array of smaller elements and an array of bigger elements. It then places the first element between the two arrays, before repeating the operations for them.

To implement it with recursion, we just need to follow this definition:

```js
const quickSort = array => {
    if (array.length <= 1) {
        return array; // an array of one or less elements is already sorted
    }
    const [first, ...rest] = array;

    // then separate all elements smaller and bigger than the first
    const smaller = [], bigger = [];
    for (var i = 0; i < rest.length; i++) {
        const value = rest[i];
        if (value < first) { // smaller
            smaller.push(value);
        } else { // bigger
            bigger.push(value);
        }
    }

    // a sorted array is
    return [
        ...quickSort(smaller), // the sorted array of all elements smaller or equal to the first
        first, // the first elements
        ...quickSort(bigger), // the sorted array of all elements greater than the first
    ];
};
```

Simple, elegant and declarative, by reading the code we can see the definition of the quicksort.

Now imagine implementing this with loop. I'll let you think about it for a bit, and you'll find the solution at the end of this article.

![inception](https://marmelab.com/images/blog/inception3.jpg)

## [](#example-4-get-leaves-of-a-tree)Example 4: Get Leaves Of A Tree

Recursion really shines when we need to deal with **recursive data structures**, such as trees. A tree is an object with some values and a `children` property ; the children contain other trees or leafs (a leaf being an object without children). For instance:

```js
const tree = {
    name: 'root',
    children: [
        {
            name: 'subtree1',
            children: [
                { name: 'child1' },
                { name: 'child2' },
            ],
        },
        { name: 'child3' },
        {
            name: 'subtree2',
            children: [
                {
                    name: 'child1',
                    children: [
                        { name: 'child4' },
                        { name: 'child5' },
                    ],
                },
                { name: 'child6' }
            ]
        }
    ]
};
```

Let's say I need a function that takes a tree, and returns an array of leaves (without children). The expected result is:

```js
getLeaves(tree);
/*[
    { name: 'child1' },
    { name: 'child2' },
    { name: 'child3' },
    { name: 'child4' },
    { name: 'child5' },
    { name: 'child6' },
]*/
```

Let's first try this the old way, without recursion.

```js
// for no nested tree, this is trivial
const getChildren = tree => tree.children;

// for one level of recursion it becomes
const getChildren = tree => {
    const { children } = tree;
    let result = [];

    for (var i = 0; i++; i < children.length - 1) {
        const child = children[i];
        if (child.children) {
            for (var j = 0; j++; j < child.children.length - 1) {
                const grandChild = child.children[j];
                result.push(grandChild);
            }
        } else {
            result.push(child);
        }
    }

    return result;
}

// for two levels:
const getChildren = tree => {
    const { children } = tree;
    let result = [];

    for (var i = 0; i++; i < children.length - 1) {
        const child = children[i];
        if (child.children) {
            for (var j = 0; j++; j < child.children.length - 1) {
                const grandChild = child.children[j];
                if (grandChild.children) {
                    for (var k = 0; k++; j < grandChild.children.length - 1) {
                        const grandGrandChild = grandChild.children[j];
                        result.push(grandGrandChild);
                    }
                } else {
                    result.push(grandChild);
                }
            }
        } else {
            result.push(child);
        }
    }

    return result;
}
```

Urgh, that's already painful, and it's only for two levels of recursion. I let you imagine how ugly it get for third, fourth, and tenth level.

And it is only to get a list of leafs ; what if you wanted to convert the tree to an array and back? Not to mention that if you wanted to use this version, you had to decide the maximum depth you want to support.

And now with recursion:

```js
const getLeaves = tree => {
    if (!tree.children) { // The leaves of a tree is the tree itself if it has no children.
        return tree;
    }

    return tree.children // otherwise it's the leaves of all its children.
        .map(getLeaves) // at this step we can have nested arrays ([child1, [grandChild1, grandChild2], ...])
        .reduce((acc, item) => acc.concat(item), []); // so we use concat to flatten the array [1,2,3].concat(4) => [1,2,3,4] and [1,2,3].concat([4]) => [1,2,3,4]
}
```

That's all, and it works for any level of recursion.

## [](#drawbacks-of-recursion-in-javascript)Drawbacks Of Recursion in JavaScript

Sadly, recursive function have a huge drawback: the accursed error

```text
Uncaught RangeError: Maximum call stack size exceeded
```

Javascript, like many languages, keeps track of all function calls in a **stack**. And this stack possesses a maximum size which, once exceeded, leads to a `RangeError`. On nested calls, the stack gets cleared once the root function finishes. But with recursion, the first function call won't end until all the other further calls are resolved. And if there are too many calls, we get this error.

![inception](https://marmelab.com/images/blog/inception5.jpg)

To deal with the stack size problem, you may try to make sure computation won't get anywhere near the stack size limit. This limit depends on platform, but it seems to be around 10 000. So we can still use recursion in js, we just must be cautious.

If you can't limit the recursion size, there are 2 solutions to this problem: Tail call optimization, and the Trampoline.

## [](#tail-call-optimization)Tail Call Optimization

This optimization is used by every language that heavily relies on recursion, like Haskell. It was implemented in Node.js v6.

A [tail call](https://en.wikipedia.org/wiki/Tail_call) is when the last statement of a function is a call to another function. The optimization consists in having the tail call function replace its parent function in the stack. This way, recursive functions won't grow the stack. Note that, for this to work, the recursive call must be **the last statement** of the recursive function. So `return loop(..);` would work, but `return loop() + v;` would not.

Let's rework our sum example to be tail call optimized:

```js
const sum = (array, result = 0) => {
    if (!array.length) {
        return result;
    }
    const [first, ...rest] = array;

    return sum(rest, first + result);
}
```

This allows the runtime engine to avoid call stack errors. But unfortunately, this does not work in Node.js anymore, as [support for tail call optimization has been removed in Node 8](https://stackoverflow.com/questions/42788139/es6-tail-recursion-optimisation-stack-overflow/42788286#42788286). Maybe it will come back in the future, but as of now this is not the case.

## [](#trampoline-optimization)Trampoline Optimization

The other solution is called the [trampoline](http://funkyjavascript.com/recursion-and-trampolines/). The idea is to use lazy evaluation to execute the recursive call later, one recursion at a time. Let's see an example:

```js
const sum = (array) => {
    const loop = (array, result = 0) =>
        () => { // the code is not executed right away, instead we return a function that will execute it later: it's lazy
            if (!array.length) {
                return result;
            }
            const [first, ...rest] = array;
            return loop(rest, first + result);
        };

    // When we execute the loop, all we get is a function to execute the first step, so no recursion.
    let recursion = loop(array);

    // as long as we get another function, there are still additional steps in the recursion
    while (typeof recursion === 'function') {
        recursion = recursion(); // we execute the current step, and retrieve the next
    }

    // once done, return the result of the last recursion.
    return recursion;
}
```

This works, but this approach has a huge drawback as well: it is **slow**. At each recursion, a new function get created, and on large recursions, this results in a huge number of functions. And this hurts. True, we won't get an error, but this will slow down (it can even freeze) execution.

![inception](https://marmelab.com/images/blog/inception6.jpg)

## [](#from-recursion-to-iteration)From Recursion to Iteration

If eventually you have performance and/or maximum call stack size exceeded issue, you can still convert the recursive version into an iterative one. Unfortunately, as you will see, the iterative version is often way more complex.

Let's take our `getLeaves` implementation, and convert the recursive logic into an iteration. I know, I tried that before, and the result was ugly. But now let's try again, but from the recursive version this time.

```js
// recursive version
const getLeaves = tree => {
    if (!tree.children) { // The leaves of a tree is the tree itself if it has no children.
        return tree;
    }

    return tree.children // otherwise it's the leaves of all its children.
        .map(getLeaves) // at this step we can have nested arrays ([child1, [grandChild1, grandChild2], ...])
        .reduce((acc, item) => acc.concat(item), []); // so we use concat to flatten the array [1,2,3].concat(4) => [1,2,3,4] and [1,2,3].concat([4]) => [1,2,3,4]
}
```

First, we need to refactor the recursive function to take an accumulator argument, that will serve to construct the result. It's even shorter:

```js
const getLeaves = (tree, result = []) => {
    if (!tree.children) {
        return [...result, tree];
    }

    return tree.children
        .reduce((acc, subTree) => getLeaves(subTree, acc), result);
}
```

Then, the trick is unroll the recursive calls into a stack of remaining computations. Initialize the result accumulator **outside the recursion**, and push the parameter that would go to the recursive function into a stack. Finally, unstack the stacked operations to get the final result:

```js
const getLeaves = tree => {
    const stack = [tree]; // add the initial tree to the stack
    const result = []; // initialize the result accumulator

    while (stack.length) { // as long as there is an item in the stack
        const currentTree = stack.pop(); // retrieve the first item in the stack
        if (!currentTree.children) { // the leaves of a tree is the tree itself if it has no children.
            result.unshift(currentTree); // so add it in the result
            continue;
        }
        stack.push(...currentTree.children);// otherwise add all children to the stack to be treated in next iterations
    }

    return result;
}
```

It's tricky, so let's do it again with quickSort. Here is the recursive version:

```js
const quickSort = array => {
    if (array.length <= 1) {
        return array; // an array of one or less elements is already sorted
    }
    const [first, ...rest] = array;

    // then separate all elements smaller and bigger than the first
    const smaller = [], bigger = [];
    for (var i = 0; i < rest.length; i++) {
        const value = rest[i];
        if (value < first) { // smaller
            smaller.push(value);
        } else { // bigger
            bigger.push(value);
        }
    }

    // a sorted array is
    return [
        ...quickSort(smaller), // the sorted array of all elements smaller or equal to the first
        first, // the first element
        ...quickSort(bigger), // the sorted array of all elements greater than the first
    ];
};
```

To remove recursion, first add an accumulator.

```js
const quickSort = (array, result = []) => {
    if (array.length <= 1) {
        return result.concat(array); // an array of one or less elements is already sorted
    }
    const [first, ...rest] = array;

    // then separate all elements smaller and bigger than the first
    const smaller = [], bigger = [];
    for (var i = 0; i < rest.length; i++) {
        const value = rest[i];
        if (value < first) { // smaller
            smaller.push(value);
        } else { // bigger
            bigger.push(value);
        }
    }

    // a sorted array is
    return [
        ...quickSort(smaller, result), // the sorted array of all elements smaller or equal to the first
        first, // the first element
        ...quickSort(bigger, result), // the sorted array of all elements greater than the first
    ];
};
```

Then use a stack to store arrays to sort, unstack it applying our previous recursive logic on each loop.

```js
const quickSort = (array) => {
    const stack = [array]; // we create a stack of array to sort
    const sorted = [];

    // we iterate over the stack until it get emptied
    while (stack.length) {
        const currentArray = stack.pop(); // we take the last array in the stack

        if (currentArray.length == 1) { // if only one element, then we add it to sorted
            sorted.push(currentArray[0]);
            continue;
        }
        const [first, ...rest] = currentArray; // otherwise we take the first element in the array

        // then separate all elements smaller and bigger than the first
        const smaller = [], bigger = [];
        for (var i = 0; i < rest.length; i++) {
            const value = rest[i];
            if (value < first) { // smaller
                smaller.push(value);
            } else { // bigger
                bigger.push(value);
            }
        }

        if (bigger.length) {
            stack.push(bigger); // we add bigger to the stack to be sorted first
        }
        stack.push([first]); // we add first in the stack, when it will get unstacked, then bigger will have been sorted
        if (smaller.length) {
            stack.push(smaller); // we add smaller to the stack to be sorted last
        }
    }

    return sorted;
}
```

And voilà! We just have an iterative version of QuickSort. But remember, this is an optimization, and

> premature optimization is the root of all evil -- Donald Knuth

So do this only when you need to.

![inception](https://marmelab.com/images/blog/inception4.jpg)

## [](#conclusion)Conclusion

I love recursion. It is much more declarative than the iterative versions, and often shorter. Recursion allows to implement complex logic easily. And despite the stack overflow problem, it can be used in JavaScript as long as you don't recure too much. And if the need arises, a recursive function can be refactored into an iterative version.

So I recommend it despite its shortcomings!

If you like this pattern, take a look at functional programming languages like Scala or Haskell. They love recursion, too!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
