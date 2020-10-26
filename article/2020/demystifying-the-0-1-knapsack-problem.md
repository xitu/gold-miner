> * 原文地址：[Demystifying the 0-1 Knapsack Problem](https://medium.com/better-programming/demystifying-the-0-1-knapsack-problem-56e7ac4dfcf7)
> * 原文作者：[The Educative Team](https://medium.com/@educative)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/demystifying-the-0-1-knapsack-problem.md](https://github.com/xitu/gold-miner/blob/master/article/2020/demystifying-the-0-1-knapsack-problem.md)
> * 译者：
> * 校对者：

# Demystifying the 0-1 Knapsack Problem

![Image credit: Author](https://cdn-images-1.medium.com/max/2048/1*q3OBnVDmaPAk__W_7n0cDA.png)

In any dynamic programming coding interview you take, you’ll likely encounter the **knapsack problem.** This question is often a source of anxiety to interviewees because of the complexity of the solution and the number of variants of the problem.

Today, we’ll get you comfortable with the knapsack problem in multiple languages by exploring two popular solutions: the **recursive solution** and the **top-down dynamic programming algorithm solution**. By the end of the article, you’ll have the experience needed to solve the knapsack problem with confidence.

#### Here’s what we’ll cover today

```
1. What's the knapsack problem?
2. Brute-force recursive solution
3. Optimized dynamic programming solution
4. What to learn next
```

## What’s the Knapsack Problem?

The knapsack problem is one of the top dynamic programming interview questions for computer science.

The problem statement is:

![Image credit: Author](https://cdn-images-1.medium.com/max/4298/1*4b1qYRRYPnPvOhT5UIYP1g.png)

You’re a burglar with a knapsack that can hold a total weight of `capacity`. You have a set of items (`n` items), each with fixed weight capacities and values. The weight and value are represented in an integer array. Create a function, `knapsack()`, that finds a subset or number of these items that’ll maximize value but whose total weight doesn’t exceed the given number `capacity`.

## Knapsack Question Variants

There are two major variants of this question: **fractional** or **0-1.** The fractional variant allows you to break items to maximize the value in the pack. The 0-1 variant doesn’t allow you to break items.

Another common variant is the **constrained** knapsack problem that restricts your program so you can’t select any item more than once. When an element is selected, the program must decide if it should place it in the pack or leave it.

At senior-level interviews, you’ll encounter variants that add volume as a constrained attribute. In this case, each item also has a fixed volume, and the knapsack has a volume limit.

## What Skills Does It Test?

This problem is so popular because it tests many desired skills at once and can be altered to throw interviewees off balance. In other words, you have to really understand the logic of the problem and code. Simple memorization won’t take you far.

The optimal solution for the knapsack problem is always a dynamic programming solution. The interviewer can use this question to test your dynamic programming skills and see if you work for an optimized solution.

Another popular solution to the knapsack problem uses recursion. Interviewers may ask you to produce both a recursive and dynamic solution if they value both skill sets. This is a popular choice because interviewers can see how well you shift from a recursive to a dynamic solution.

The knapsack problem also tests how well you approach **combinatorial optimization** problems. This has many practical applications in the workplace, as all combinatorial optimization problems seek maximum benefit within constraints.

For example, combinatorial optimization is used in solutions like:

* Determine the best programs to run on a limited resource cloud system
* Optimize water distribution across a fixed pipe network
* Automatically plan the best package delivery route
* Optimize the company’s supply chain

You can expect this question to be asked for any role that manages or creates automated optimization software.

## Brute-Force Recursive Solution

The most obvious solution to this problem is brute-force recursive. This solution is brute-force because it evaluates the total weight and value of all possible subsets, then selects the subset with the highest value that’s still under the weight limit.

While this is an effective solution, it’s not optimal because the time complexity is exponential. Use this solution if you’re asked for a recursive approach. It can also be a good starting point for the dynamic solution.

**Time complexity:** O(2^{n})O(2n), due to the number of calls with overlapping subcalls

**Auxiliary space:** O(1)O(1), no additional storage is needed

## Solution

Here’s a visual representation of our algorithm.

**Note:** All red-item subsets exceed our pack’s capacity; light green are within capacity but aren’t the highest value.

![Knapsack brute-force recursion](https://cdn-images-1.medium.com/max/4774/1*UvpCzvWCSHRRPdALmuXu0g.png)

![](https://cdn-images-1.medium.com/max/4956/1*C3g6sdkm2KnLWjtcqlMiIA.png)

---

## Explanation

On line 14, we start from the beginning of the weight array and check if the item is within the maximum capacity. If it is, we call the `knapsack()` function recursively with the item and save the result in `profit1`.

Then we recursively call the function, exclude the item, and save the result in the `profit2` variable. On line 21, we return the greater of `profit1` and `profit2`.

#### Pseudocode

Here’s a pseudocode explanation of how this program functions.

```
for each item 'i' starting from the end
  create a new set which INCLUDES item 'i' if the total weight does not exceed the capacity, and recursively process the remaining capacity and items
  create a new set WITHOUT item 'i', and recursively process the remaining items 
 
return the set from the above two sets with higher profit
```

This program contains many overlapping subproblems, but they’re calculated each time rather than stored. Repeated calculations increase runtime drastically. To avoid recalculating, we can instead use dynamic programming to memoize the solution to subproblems for reuse.

## Optimized Dynamic Programming Solution

Now, we’ll optimize our recursive solution through the addition of top-down dynamic programming to handle the overlapping subproblems.

Since we have two changing values (`capacity` and `currentIndex`) in our recursive function `knapsackRecursive()`, we can use a two-dimensional array to store the results of all the solved subproblems. As mentioned above, we need to store results for every subarray (i.e., for every possible index `i`) and for every possible capacity `c`.

This is the optimal solution for the knapsack problem in both time and space complexity.

#### Time complexity

O(N\*C)O(N∗C): our memoization table stores results for all subproblems and will have a maximum of N\*CN∗C subproblems.

#### Auxiliary space

O(N\*C+N)O(N∗C+N), O(N\*C)O(N∗C) space for the memoization table and O(N)O(N) space for the recursion call stack.

**Tip:** During the interview, make sure to talk through your thought process with the interviewer so they can see your problem-solving skills.

---

## Solution

![Visualization of dynamic programming with memoization](https://cdn-images-1.medium.com/max/4828/1*yUbDTle-uPoqvQZtDtGn9A.png)

![](https://cdn-images-1.medium.com/max/4924/1*MBjOpWvtK59bXVXsB2T4Qw.png)

---

## Explanation

To implement dynamic programming, we only need to change five lines.

In line 9, we create a two-dimensional array, `dp`, to hold the results of any solved subproblem. This allows us to use these memoized solutions later, rather than recalculating the answer.

In lines 22 and 23, we create a case that checks `dp` to see if the current subproblem’s solution has already been found. If we have it, we return the memoized solution and move onto the next subproblem.

In line 38, we calculate the maximum possible value of the bag if we include the current item in `profit1` and the maximum value of the bag if we exclude the current item in `profit2`. We then save the higher of these in our two-dimensional array, `dp`.

In line 39, we return the item that makes the highest knapsack value. This is a partial result that ends one recursive call before the next begins. Once this has occurred for all possible combinations, the first call will return the actual result.


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
