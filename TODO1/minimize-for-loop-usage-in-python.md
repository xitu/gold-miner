> * 原文地址：[Minimize for loop usage in Python](https://towardsdatascience.com/minimize-for-loop-usage-in-python-78e3bc42f03f)
> * 原文作者：[Rahul Agarwal](https://medium.com/@rahul_agarwal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/minimize-for-loop-usage-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/minimize-for-loop-usage-in-python.md)
> * 译者：
> * 校对者：

# Minimize for loop usage in Python

> How to and Why you should minimize for loop usage in your Python code?

![Photo by [Etienne Girardet](https://unsplash.com/@etiennegirardet?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6528/0*aYSzzvJDJ28kV200)

Python provides us with many styles of coding.

In a way, it is pretty inclusive.

One can come from any language and start writing Python.

****However, learning to write a language and writing a language in an optimized way are two different things.****

In this series of posts named [**Python Shorts**](https://bit.ly/2XshreA), I will explain some simple but very useful constructs provided by Python, some essential tips and some use cases I come up with regularly in my Data Science work.

In this post, ****I am going to talk about `for` loops in Python and how you should avoid them whenever possible.****

## 3 Ways of writing a for loop:

Let me explain this with a simple example statement.

Suppose you want to take the ****sum of squares in a list.****

This is a valid problem we all face in machine learning whenever we want to calculate the distance between two points in n dimension.

You can do this using loops easily.

In fact, I will show you **three ways to do the same task which I have seen people use and let you choose for yourself which you find the best.**

```
x = [1,3,5,7,9]
sum_squared = 0

for i in range(len(x)):
    sum_squared+=x[i]**2
```

Whenever I see the above code in a python codebase, I understand that the person has come from C or Java background.

A **slightly more pythonic way** undefinedof doing the same thing is:

```
x = [1,3,5,7,9]
sum_squared = 0

for y in x:
    sum_squared+=y**2
```

Better.

I didn’t index the list. And my code is more readable.

But still, the pythonic way to do it is in one line.

```
x = [1,3,5,7,9]
sum_squared = sum([y**2 for y in x])
```

****This approach is called List Comprehension, and this may very well be one of the reasons that I love Python.****

You can also use `if` in a list comprehension.

Let’s say we wanted a list of squared numbers for even numbers only.

```
x = [1,2,3,4,5,6,7,8,9]
even_squared = [y**2 for y in x if y%2==0]
--------------------------------------------
[4,16,36,64]
```

`****if-else?****`

What if we wanted to have the number squared for even and cubed for odd?

```
x = [1,2,3,4,5,6,7,8,9]
squared_cubed = [y**2 if y%2==0 else y**3 for y in x]
--------------------------------------------
[1, 4, 27, 16, 125, 36, 343, 64, 729]
```

Great!!!

![](https://cdn-images-1.medium.com/max/2000/0*E3GXaHSrdRSdcikf.png)

So basically follow specific **guidelines:** Whenever you feel like writing a `for` statement, you should ask yourself the following questions,

* Can it be done without a `for` loop? Most Pythonic

* Can it be done using **list comprehension**? If yes, use it.

* Can I do it without indexing arrays? if not, think about using `enumerate`

What is `enumerate?`

Sometimes we need both the index in an array as well as the value in an array.

In such cases, I prefer to use **enumerate** rather than indexing the list.

```
L = ['blue', 'yellow', 'orange']
for i, val in enumerate(L):
    print("index is %d and value is %s" % (i, val))
---------------------------------------------------------------
index is 0 and value is blue
index is 1 and value is yellow
index is 2 and value is orange
```

The rule is:
> # Never index a list, if you can do without it.

## Try Using Dictionary Comprehension

Also try using **dictionary comprehension**, which is a relatively new addition in Python. The syntax is pretty similar to List comprehension.

Let me explain using an example. I want to get a dictionary with (key: squared value) for every value in x.

```
x = [1,2,3,4,5,6,7,8,9]
{k:k**2 for k in x}
---------------------------------------------------------
{1: 1, 2: 4, 3: 9, 4: 16, 5: 25, 6: 36, 7: 49, 8: 64, 9: 81}
```

What if I want a dict only for even values?

```
x = [1,2,3,4,5,6,7,8,9]
{k:k**2 for k in x if x%2==0}
---------------------------------------------------------
{2: 4, 4: 16, 6: 36, 8: 64}
```

What if we want squared value for even key and cubed number for the odd key?

```
x = [1,2,3,4,5,6,7,8,9]
{k:k**2 if k%2==0 else k**3 for k in x}
---------------------------------------------------------
{1: 1, 2: 4, 3: 27, 4: 16, 5: 125, 6: 36, 7: 343, 8: 64, 9: 729}
```

## Conclusion

To conclude, I will say that while it might seem easy to transfer the knowledge you acquired from other languages to Python, you won’t be able to appreciate the beauty of Python if you keep doing that. ****Python is much more powerful when we use its ways and decidedly much more fun.

**So, use List Comprehensions and Dict comprehensions when you need a`for` loop. Use `enumerate` if you need array index.**
> # Avoid for loops like plague

Your code will be much more readable and maintainable in the long run.

Also if you want to learn more about Python 3, I would like to call out an excellent course on Learn [Intermediate level Python](https://bit.ly/2XshreA) from the University of Michigan. Do check it out.

I am going to be writing more beginner friendly posts in the future too. Let me know what you think about the series. Follow me up at [**Medium**](https://medium.com/@rahul_agarwal) or Subscribe to my [**blog**](https://mlwhiz.com/) to be informed about them.

As always, I welcome feedback and constructive criticism and can be reached on Twitter [@mlwhiz](https://twitter.com/MLWhiz).

**Originally published at [https://mlwhiz.com](https://mlwhiz.com/blog/2019/04/22/python_forloops/) on April 23, 2019.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
