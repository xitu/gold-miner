> * 原文地址：[Greedy Algorithms 101](https://codeburst.io/greedy-algorithms-101-957842232cf2)
> * 原文作者：[Mario Osorio](https://medium.com/@mario5o)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/greedy-algorithms-101.md](https://github.com/xitu/gold-miner/blob/master/article/2020/greedy-algorithms-101.md)
> * 译者：
> * 校对者：

# Greedy Algorithms 101

#### YOU ARE FALLING BEHIND IF YOU DON’T KNOW GREEDY ALGORITHMS

#### … and why you should learn to build them right now

![](https://cdn-images-1.medium.com/max/2000/0*udmPDWYUmHDNJX5D)

Greedy algorithms are easy to implement in most cases, they are one of the most used programming schemas when it comes to solving optimization problems, they are also a very good option because of their low resource consumption.

They have a little downside and it is that, they don’t always guarantee the optimal solution, they will get a close approach to the optimal but not always find it. Anyway in many cases, a close-to-optimal solution is more than enough.

When talking about complexity, they typically take “**n”** iterations for an “**n”** sized problem so their complexities vary from O(n), O(n × log(n)) or as much as O(n²)

Most problems for which they produce very good results share a couple of characteristics:

1. **Greedy property**: It is based on taking in every iteration, the optimal local solution without thinking about future consequences. We trust in that taking the optimal local solution could lead to the optimal global solution, but as I said before, that not always happens. To demonstrate that in every iteration we are taking the most optimal solution we need to use the induction method (clearly not a trivial demonstration).
2. **An optimal** substructure****: I kind of mentioned it before. The problem must have the capability of been divided into subsets with each having an optimal solution.

Now let me show you how to write your own greedy algorithm and then we will look at a very well known problem and solve it using our new greedy superpower.

---

## General Greedy schema (Java)

```Java
public ArrayList greedy(ArrayList candidates) {
    solution;
    while (!isSolution(solution) && (candidatesLeft(candidates)) {
            cadidate = selectCandidate(candidates);
            removeCandidate(candidate, candidates);
            if (isGoodCandidate(candidate, solution)) {
                addCandidate(candidate, solution);
            }
        }
        if (isSolution(solution)) {
            return solution;
        } else {
            return null;
        }
    }
}
```

Before I explain the code, let’s first define some of the terminology I used in the pseudocode

1. **Candidates:** List of possible solutions to the problem. This can be any kind of data type, but usually an iterable one. You will see it better when we get to the example problem, bear with me for now 😁.
2. **Candidate:** The selected possible current solution to our problem
3. **Solution:** The first instance of the solution variable should simply be a data structure in which we will store our current solution to the problem.
4. **isSolution, candidatesLeft, removeCandidate, addCandidate, isGoodCandidate:** These are functions that we will also build, some of them, depending on the problem we are approaching, don’t even need to be whole functions but, for the shake of summarizing the schema, I decided to put them as functions.

First we initialize our solution data structure, this could be an array, a boolean, an int… we simply need to state it.

```
solution
```

Then we see this main **while** loop with a couple of functions inside. Those functions must also be build but sometimes you don’t need a whole other function to see for example if you have left candidates to try.

```
while (!isSolution(solution) && (candidatesLeft(candidates))
```

Once we have checked that we didn’t yet find a solution and that we still have candidates left to try, we select one candidate and immediately remove it from our list of candidates.

```
cadidate = selectCandidate(candidates);                removeCandidate(candidate, candidates);
```

The next step is pretty straight forward. If the candidate is suitable for our solution, then simply add it to the solution structure.

```
if (isGoodCandidate(candidate, solution)) { 
    addCandidate(candidate, solution); 
}
```

Then we simply check if we have reached the solution state and finally return it

```
if (isSolution(solution)) { 
    return solution; 
} else { 
    return null; 
}
```

OK! so once we have seen the code and broadly explained it, I will give you a problem and you should try and solve it yourself. It is a very well known problem so you will easily find it on the internet but I recommend giving it a try.

---

## Coin change problem

You have 6 types of coins, and the value of each type is given as {50, 20, 10, 5, 2, 1} respectively, they are passed as an argument already sorted in decreasing value. **Each of the possible coins would be our candidates.** You must find a way of giving away the optimal change (**least amount of coins and the exact amount of change**)

**Example input:** 15 (**We must return a sum of 15 with the least amount of coins possible**)

**Example output:** 10, 5 (**We gave back a sum of 15 with the least amount of coins possible**)

For this exact monetary system {50, 20, 10, 5, 2, 1} the algorithm should find an optimal solution but it is worth mentioning that any change in the available candidates, can result in the algorithm not giving an optimal solution.

#### Hint

If you didn’t try hard enough, you shouldn’t be reading this 🤨… Just kidding, go ahead, I’m sure I̶ ̶h̶o̶p̶e̶ you already learned something new 😄

* A good **selectCandidate()** function is to start choosing big coins, and then filling the remaining change with smaller coins. Always check you are not surpassing the remaining change.

#### Solution

I will provide my solution written in java, so I’m using OOP.

```Java
public class Coin {
    private int value;
    private int quantity;
    Moneda(int value, int quantity) {
        this.value = value;
        this.quantity = quantity;
    }
    /* getters & setters */
}

/* This is actually the "hard" part */
int selectCandidate(ArrayList < Integer > values) {
    int biggest = Integer.MIN_VALUE;
    for (Integer coin: values)
        if ((biggest < coin)) biggest = coin;
    return biggest;
}

/* Now the actual schema */

ArrayList < Coin > greedySchema(ArrayList < Integer > values, int quantity) {
    /* We initialize our solution structure */
    ArrayList < Coin > solution = new ArrayList < Coin > ();
    /* Any auxiliary variable is ok */
    int value;
    
    while ((quantity > 0) && (!values.isEmpty())) {
        /* Select and remove the coin from our monetary system */
        value = selectCandidate(values);
        values.remove(new Integer(value));
        
        /* If this is true, it meanwe can still look for coins to give */
        if ((quantity / value) > 0) {
            solution.add(new Coin(value, quantity / value));
            /* This will lower the quantity we need to give back */
            quantity = quanity % value;
        }
    }
    
    /* Once the quantity is 0 we are DONE! */
    if (quantity == 0) {
        return solution;
    } else return null;
}
```

---

#### Resources

If you did like how Greedy algorithms work and now feel the urge to go and investigate more about them, pages like [Hackerrank](https://www.hackerrank.com/) or [Hackerearth](https://www.hackerearth.com/practice/) provide a huge amount of problems to solve, I’m sure you already knew about them but it is always good to mention 😊.

Sometimes what I personally do is use GitHub as a search engine and simply write the topic I’m looking for [[greedy algorithms](https://github.com/search?q=greedy+algorithm)].

---

## Conclusion

So to sum up, Greedy Algorithms are really good even for personal easy projects, they should not take to much to think and they consume little resources. If that wasn’t enough, a lot of interview questions might be easily solved using a good Greedy algorithm, most of the times the memory and complexity requirements are satisfied using either Greedy or Dynamic Programming, but that’s another story 😉.

Thanks for reading and feel free to comment out anything 😄.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
