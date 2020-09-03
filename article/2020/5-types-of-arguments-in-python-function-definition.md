> * 原文地址：[5 Types of Arguments in Python Function Definition](https://levelup.gitconnected.com/5-types-of-arguments-in-python-function-definition-e0e2a2cafd29)
> * 原文作者：[Indhumathy Chelliah](https://medium.com/@IndhumathyChelliah)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-types-of-arguments-in-python-function-definition.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-types-of-arguments-in-python-function-definition.md)
> * 译者：
> * 校对者：

# 5 Types of Arguments in Python Function Definition

![Photo by [Sharon McCutcheon](https://www.pexels.com/@mccutcheon?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/person-s-hand-with-paints-1174932/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/11232/1*TqNYpk6OZ6qBS8CNPWz1tQ.jpeg)

#### 5 Types of Arguments in Python Function Definition:

1. `default arguments`
2. `keyword arguments`
3. `positional arguments`
4. `arbitrary positional arguments`
5. `arbitrary keyword arguments`

#### Python Function Definition:

The function definition starts with the keyword `def`. It must be followed by the function name and the parenthesized list of formal parameters. The statements that form the body of the function start at the next line and must be indented.

![](https://cdn-images-1.medium.com/max/2000/1*DhAUznkbAFfBUvMqF8rFuw.png)

**Formal parameters** are mentioned in function definition. **Actual parameters(arguments)** are passed during function call.

We can define a function with a variable number of arguments

#### 1.default arguments:

* default arguments are values that are provided while defining functions.
* The assignment operator `=` is used to assign a default value to the argument.
* default arguments become optional during the function calls.
* If we provide value to the default arguments during function calls, it overrides the default value.
* The function can have any number of default arguments
* Default arguments should be followed by non-default arguments.

**Example:**

In the below example, the default value is given to argument `b`,`c`

```py
def add(a,b=5,c=10):
    return (a+b+c)
```

This function can be called in 3 ways

1. **Giving only the mandatory argument**

```py
print(add(3))
#Output:18
```

**2. Giving one of the optional arguments.**
3 is assigned to a, 4 is assigned to b.

```py
print(add(3,4))
#Output:14
```

**3.Giving all the arguments**

```py
print(add(2,3,4))
#Output:9
```

**Note:** Default values are evaluated only once at the point of the function definition in the defining scope. So, it makes a difference when we pass mutable objects like list,dictionary as default values.

#### 2. Keyword Arguments:

Functions can also be called using keyword arguments of the form `kwarg=value.`

During function call, values passed through arguments need not be in the order of parameters in the function definition. This can be achieved by keyword arguments. But all the keyword arguments should match the parameters in the function definition.

**Example:**

```py
def add(a,b=5,c=10):
    return (a+b+c)
```

Calling the `function add` by giving keyword arguments

1. All parameters are given as keyword arguments. So no need to maintain the same order.

```py
print (add(b=10,c=15,a=20))
#Output:45
```

2. During function call, only giving mandatory argument as a keyword argument. Optional default arguments are skipped.

```py
print (add(a=10))
#Output:25
```

#### 3. Positional Arguments

During function call, values passed through arguments should be in the order of parameters in the function definition. This is called **positional arguments.**

Keyword arguments should follow positional arguments only.

**Example:**

```py
def add(a,b,c):
    return (a+b+c)
```

The above function can be called in two ways:

1. During function call, all arguments are given as positional arguments. Values passed through arguments are passed to parameters by their position. `10` is assigned to` a`,`20` is assigned to` b` and `30` is assigned to `c`

```py
print (add(10,20,30))
#Output:60
```

2. Giving a mix of positional and keyword arguments. keyword arguments should always follow positional arguments

```py
print (add(10,c=30,b=20))
#Output:60
```

**Default vs positional vs keyword arguments:**

![](https://cdn-images-1.medium.com/max/2000/1*fobgfbPcgmE29Oviud5vWw.png)

---

**Important points to remember:**

**1.default arguments should follow non-default arguments**

```py
def add(a=5,b,c):
    return (a+b+c)

#Output:SyntaxError: non-default argument follows default argument
```

**2. keyword arguments should follow positional arguments**

```py
def add(a,b,c):
    return (a+b+c)

print (add(a=10,3,4))
#Output:SyntaxError: positional argument follows keyword argument
```

**3. All the keyword arguments passed must match one of the arguments accepted by the function and their order is not important.**

```py
def add(a,b,c):
    return (a+b+c)

print (add(a=10,b1=5,c=12))
#Output:TypeError: add() got an unexpected keyword argument 'b1'
```

**4.No argument should receive a value more than once**

```py
def add(a,b,c):
    return (a+b+c)

print (add(a=10,b=5,b=10,c=12))
#Output:SyntaxError: keyword argument repeated
```

**5. Default arguments are optional arguments**

**Example 1:** Giving only the mandatory arguments

```py
def add(a,b=5,c=10):
    return (a+b+c)

print (add(2))
#Output:17
```

**Example 2:** Giving all arguments(optional and mandatory arguments)

```py
def add(a,b=5,c=10):
    return (a+b+c)

print (add(2,3,4))
#Output:9
```

#### Variable-length arguments

Variable-length arguments are also known as **arbitary arguments**. If we don’t know the number of arguments needed for the function in advance, we can use arbitary arguments

**Two types of arbitrary arguments**

1. arbitary positional arguments
2. arbitrary keyword arguments

#### 4. arbitrary positional arguments:

For arbitrary positional argument, an **asterisk(`*`)** is placed before a parameter in function definition which can hold non-keyword variable-length arguments. These arguments will be wrapped up in a **tuple**. Before the variable number of arguments, zero or more normal arguments may occur.

```py
def add(*b):
    result=0
    for i in b:
         result=result+i
    return result

print (add(1,2,3,4,5))
#Output:15

print (add(10,20))
#Output:30
```

#### 5.arbitrary keyword arguments:

For arbitrary positional argument, a **double asterisk(`**`)** is placed before a parameter in function which can hold keyword variable-length arguments.

**Example:**

```py
def fn(**a):
    for i in a.items():
        print (i)
fn(numbers=5,colors="blue",fruits="apple")
'''
Output:
('numbers', 5)
('colors', 'blue')
('fruits', 'apple')
'''
```

#### Special Parameters:

As per [Python Documentation](https://docs.python.org/3/tutorial/controlflow.html#special-parameters)

> By default, arguments may be passed to a Python function either by position or explicitly by keyword. For readability and performance, it makes sense to restrict the way arguments can be passed so that a developer need only look at the function definition to determine if items are passed by position, by position or keyword, or by keyword.

A function definition may look like:

![Photo by author](https://cdn-images-1.medium.com/max/2000/1*u2CocaIDBg1ctQBeP_-H6A.png)

where `/` and `*` are optional. If used, these symbols indicate the kind of parameter by how the arguments may be passed to the function: positional-only, positional-or-keyword, and keyword-only.

1. Positional or keyword arguments
2. Positional only parameters
3. keyword-only arguments

#### 1.Positional or keyword arguments

If `/` and `*` are not present in the function definition, arguments may be passed to a function by position or by keyword

```py
def add(a,b,c):
    return a+b+c

print (add(3,4,5))
#Output:12

print (add(3,c=1,b=2))
#Output:6
```

**2. Positional only parameters**

Positional-only parameters are placed before a `/` (forward-slash)in the function definition. The `/` is used to logically separate the positional-only parameters from the rest of the parameters. Parameters following the `/` may be **positional-or-keyword** or **keyword-only**.

```py
def add(a,b,/,c,d):
    return a+b+c+d

print (add(3,4,5,6))
#Output:12

print (add(3,4,c=1,d=2))
#Output:6
```

If we specify keyword arguments for positional only arguments, it will raise **TypeError.**

```py
def add(a,b,/,c,d):
    return a+b+c+d

print (add(3,b=4,c=1,d=2))
#Output:TypeError: add() got some positional-only arguments passed as keyword arguments: 'b'
```

#### 3. Keyword only arguments

To mark parameters as **keyword-only**, place an `*` in the arguments list just before the first **keyword-only** parameter.

```py
def add(a,b,*,c,d):
    return a+b+c+d

print (add(3,4,c=1,d=2))
#Output:10
```

If we specify positional arguments for keyword-only arguments it will raise **TypeError.**

```py
def add(a,b,*,c,d):
    return a+b+c+d

print (add(3,4,1,d=2))
#Output:TypeError: add() takes 2 positional arguments but 3 positional arguments (and 1 keyword-only argument) were given
```

**All 3 calling conventions used in the same function**

In the below-given example`,function add` has all three arguments

`a`,`b` — positional only arguments
`c` - positional or keyword arguments
`d` - keyword-only arguments

```py
def add(a,b,/,c,*,d):
    return a+b+c+d

print (add(3,4,1,d=2))
#Output:10
```

**Important Points to remember:**

1. Use **positional-only** if you want the name of the parameters to not be available to the user. This is useful when parameter names have no real meaning.
2. Use **positional-only** if you want to enforce the order of the arguments when the function is called.
3. Use **keyword-only** when names have meaning and the function definition is more understandable by being explicit with names.
4. Use **keyword-only** when you want to prevent users from relying on the position of the argument being passed.

#### Resources(Python Documentation):

[Defining functions](https://docs.python.org/3/tutorial/controlflow.html#defining-functions)

[default arguments](https://docs.python.org/3/tutorial/controlflow.html#default-argument-values)

[keyword arguments](https://docs.python.org/3/tutorial/controlflow.html#keyword-arguments)

[special parameters](https://docs.python.org/3/tutorial/controlflow.html#special-parameters)

[arbitary argument list](https://docs.python.org/3/tutorial/controlflow.html#arbitrary-argument-lists)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
