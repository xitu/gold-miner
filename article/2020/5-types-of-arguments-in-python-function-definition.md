> * 原文地址：[5 Types of Arguments in Python Function Definition](https://levelup.gitconnected.com/5-types-of-arguments-in-python-function-definition-e0e2a2cafd29)
> * 原文作者：[Indhumathy Chelliah](https://medium.com/@IndhumathyChelliah)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-types-of-arguments-in-python-function-definition.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-types-of-arguments-in-python-function-definition.md)
> * 译者：[Zhengjian-L](https://github.com/Zhengjian-L)
> * 校对者：[z0gSh1u](https://github.com/z0gSh1u)，[JalanJiang](https://github.com/JalanJiang)

# 定义 Python 函数时的 5 种参数

![Photo by [Sharon McCutcheon](https://www.pexels.com/@mccutcheon?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/person-s-hand-with-paints-1174932/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/11232/1*TqNYpk6OZ6qBS8CNPWz1tQ.jpeg)

#### Python 定义函数的5种参数：

1. `缺省参数`
2. `关键字参数`
3. `位置参数`
4. `任意位置参数`
5. `任意关键字参数`

#### Python 函数定义：

关键字 `def` 引入一个函数定义。它后面必须跟着函数名称和带括号的形式参数列表。构成函数体的语句从下一行开始，并且必须缩进。

![](https://cdn-images-1.medium.com/max/2000/1*DhAUznkbAFfBUvMqF8rFuw.png)

在定义的函数中需要提及**形式参数**。**实际参数**在函数调用时传递。 

我们可以用各种参数来定义函数。

#### 1. 缺省参数：

* 缺省参数是在定义函数时提供的值。
* 赋值符号`=`用于声明参数的默认值。
* 在调用函数时，参数默认值是可变更项。
* 如果在调用函数时提供缺省参数的值，这个值会替代默认值。
* 一个函数可以有任意数量的缺省参数。
* 缺省参数要在非缺省参数之后。

**例：**

`b`,`c`在下面的例子中，参数`b`,`c`指定了默认值。

```py
def add(a,b=5,c=10):
    return (a+b+c)
```

这个函数有三种调用方式

**1. 只给出必需参数**

```py
print(add(3))
#Output:18
```

**2. 给出一个可选的参数**
3 赋值给 a, 4 赋值给 b。

```py
print(add(3,4))
#Output:14
```

**3.给出所有参数**

```py
print(add(2,3,4))
#Output:9
```

**注意：** 默认值在函数定义处的定义过程中只会计算一次。因此，在把如列表、字典等可变对象作为默认值时会有些许不同。

#### 2. 关键字参数：

也可以使用形如`kwarg=value`的关键字参数来调用函数。

在调用函数时，参数值并不需要与函数定义中的参数顺序相同。这可以通过关键字参数实现。但所有的关键字参数必须与函数定义中的参数一一对应。

**例：**

```py
def add(a,b=5,c=10):
    return (a+b+c)
```

调用函数 `function add` 时提供关键字参数

1. 所有的参数都是关键字参数，因此不需要固定顺序。

```py
print (add(b=10,c=15,a=20))
#Output:45
```

2. 调用函数时，只给出必要参数作为关键字参数，可选缺省参数就会跳过。

```py
print (add(a=10))
#Output:25
```

#### 3. 位置参数

调用函数时，参数传递的值的顺序和形式参数的顺序需要对应。这称之为**位置参数**。

位置参数之后只能是关键字参数。

**例：**

```py
def add(a,b,c):
    return (a+b+c)
```

上面的函数有两种调用的方式：

1. 调用函数时，参数均为位置参数。参数传递的值会通过位置传递到对应参数。`10` 赋值给` a`,`20`赋值给` b` 和 `30` 赋值给 `c`。

```py
print (add(10,20,30))
#Output:60
```

2. 在混合使用位置参数和关键字参数时，关键字参数总是在位置参数之后。

```py
print (add(10,c=30,b=20))
#Output:60
```

**缺省参数、位置参数 、关键字参数三者对比：**

![](https://cdn-images-1.medium.com/max/2000/1*fobgfbPcgmE29Oviud5vWw.png)

---

**关键要点：**

**1. 缺省参数需要在非缺省参数之后**

```py
def add(a=5,b,c):
    return (a+b+c)

#Output:SyntaxError: non-default argument follows default argument
```

**2. 关键字参数需要在位置参数之后**

```py
def add(a,b,c):
    return (a+b+c)

print (add(a=10,3,4))
#Output:SyntaxError: positional argument follows keyword argument
```

**3. 所有传递的关键字参数必须有对应参数，并且顺序不重要。**

```py
def add(a,b,c):
    return (a+b+c)

print (add(a=10,b1=5,c=12))
#Output:TypeError: add() got an unexpected keyword argument 'b1'
```

**4. 参数只能赋值一次**

```py
def add(a,b,c):
    return (a+b+c)

print (add(a=10,b=5,b=10,c=12))
#Output:SyntaxError: keyword argument repeated
```

**5. 缺省参数是可选参数**

**例 1：** 只给必要参数

```py
def add(a,b=5,c=10):
    return (a+b+c)

print (add(2))
#Output:17
```

**例 2：** 给出所有参数（必要参数和可选参数）

```py
def add(a,b=5,c=10):
    return (a+b+c)

print (add(2,3,4))
#Output:9
```

#### 可变长度参数

可变长度参数也称为**任意参数**。如果我们事先不知道函数的参数数量，可以使用任意参数。

**两种任意参数**

1. 任意位置参数
2. 任意关键字参数

#### 4. 任意位置参数：

对于任意位置参数，函数定义的参数前会有一个**星号（`*`）**，该参数可以包含非关键字可变长度参数。这些参数将包含在一个**元组**中。在可变数量的参数之前，可能会出现零个或多个普通参数。

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

#### 5.任意关键字参数：

对于任意关键字参数，函数定义的参数前会有**双星号（`*`）**，该参数可以包含非关键字可变长度参数。

**例：**

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

#### 特殊参数：

根据 [Python 手册](https://docs.python.org/3/tutorial/controlflow.html#special-parameters)

> 默认情况下，函数的参数传递形式可以是位置参数或是显式的关键字参数。 为了确保可读性和运行效率，限制允许的参数传递形式是有意义的，这样开发者只需查看函数定义即可确定参数项是仅按位置、按位置也按关键字，还是仅按关键字传递。

函数的定义看起来可以像是这样：

![Photo by author](https://cdn-images-1.medium.com/max/2000/1*u2CocaIDBg1ctQBeP_-H6A.png)

在这里` /` 和 `*` 是可选的。 如果使用这些符号则表明可以通过何种形参将参数值传递给函数：仅限位置、位置或关键字，以及仅限关键字。 

1. 位置或关键字参数
2. 仅限位置参数
3. 仅限关键字参数

#### 1. 位置或关键字参数

如果函数定义中未使用 `/` 和 `*`，则参数可以按位置或按关键字传递给函数。

```py
def add(a,b,c):
    return a+b+c

print (add(3,4,5))
#Output:12

print (add(3,c=1,b=2))
#Output:6
```

**2. 仅限位置参数**

在定义的函数中，仅限位置参数要放在`/`（正斜杠）之前。这个`/`被用来从逻辑上分隔仅限位置形参和其他形参。在`/`之后的形参可以为**位置或关键字**或者**仅限关键字**。

```py
def add(a,b,/,c,d):
    return a+b+c+d

print (add(3,4,5,6))
#Output:18

print (add(3,4,c=1,d=2))
#Output:10
```

如果将关键字参数规定为仅限位置参数，则会导致**TypeError**。

```py
def add(a,b,/,c,d):
    return a+b+c+d

print (add(3,b=4,c=1,d=2))
#Output:TypeError: add() got some positional-only arguments passed as keyword arguments: 'b'
```

#### 3. 仅限关键字参数

要将形参标记为**仅限关键字**，应在参数列表的第一个**仅限关键字**形参前放置一个 `*`。

```py
def add(a,b,*,c,d):
    return a+b+c+d

print (add(3,4,c=1,d=2))
#Output:10
```

如果将位置参数规定为仅限关键字参数，则会导致**TypeError**。

```py
def add(a,b,*,c,d):
    return a+b+c+d

print (add(3,4,1,d=2))
#Output:TypeError: add() takes 2 positional arguments but 3 positional arguments (and 1 keyword-only argument) were given
```

**在同一个函数中的拥有三种参数的调用规则**

在下面的例子中，`function add` 拥有所有三种参数

`a`,`b` — 仅限位置参数
`c` - 位置或关键字参数
`d` - 仅限关键字参数

```py
def add(a,b,/,c,*,d):
    return a+b+c+d

print (add(3,4,1,d=2))
#Output:10
```

**注意事项：**

1. 当你希望参数的名称对用户不可用时，则使用**仅限位置**。当参数名称没有实际意义时，这很有用。
2. 如果你想规定调用函数的参数数据时，则使用**仅限位置**。
3. 当名称有意义且定义的函数通过名称变得更易于理解时，则使用**仅限关键字**。
4. 当你想要避免用户依赖传递的参数的位置时，则使用**仅限关键字**。

#### 资料来源（Python手册）：

[定义函数](https://docs.python.org/3/tutorial/controlflow.html#defining-functions)

[默认参数](https://docs.python.org/3/tutorial/controlflow.html#default-argument-values)

[关键字参数](https://docs.python.org/3/tutorial/controlflow.html#keyword-arguments)

[特殊参数](https://docs.python.org/3/tutorial/controlflow.html#special-parameters)

[任意参数列表](https://docs.python.org/3/tutorial/controlflow.html#arbitrary-argument-lists)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
