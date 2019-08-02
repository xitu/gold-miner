> * 原文地址：[A deep dive on Python type hints](https://veekaybee.github.io/2019/07/08/python-type-hints/)
> * 原文作者：[Vicki Boykis](http://www.vickiboykis.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-deep-dive-on-python-type-hints.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-deep-dive-on-python-type-hints.md)
> * 译者：
> * 校对者：胡其美(hu7may.github.io)

# 深入理解Python的类型提示

![Smiley face](https://raw.githubusercontent.com/veekaybee/veekaybee.github.io/master/images/presser.png)

Presser, Konstantin Makovsky 1900

## 简介

自从Python的类型提示发布以来 [in 2014](https://www.python.org/dev/peps/pep-0484/), 人们便一直将他们应用到自己的代码中。我估计目前大约有20~30%的Python3代码在使用提示(有时也称为注释)。在去年我看到他们出现在越来越多的[书](https://www.manning.com/books/classic-computer-science-problems-in-python) 和教程中。

> 事实上，我现在很好奇 - 你在积极地使用Python3开发吗？你在代码中使用注解和提示吗？
> 
> — [Vicki Boykis (@vboykis) May 14, 2019](https://twitter.com/vboykis/status/1128324572917448704?ref_src=twsrc%5Etfw)

这是一个[使用类型提示的代码看起来什么样](https://docs.python.org/3/library/typing.html)的典型例子。

没有类型提示的代码：

```python
def greeting(name):
	return 'Hello ' + name
```

有类型提示的代码：

```python
def greeting(name: str) -> str:
    return 'Hello ' + name 
```

提示的样板格式通常是这样：

```python
def function(variable: input_type) -> return_type:
	pass
```

然而，关于他们究竟是什么（在本文中，我暂且称他们为提示）、他们会如何使你的代码受益仍然有许多让人困惑不解的地方。

When I started to investigate and weigh whether type hints made sense for me to use, I became super confused. So, like I usually do with things I don’t understand, I decided to dig in further, and am hopeful that this post will be just as helpful for others.当我开始调查和衡量类型提示是否对我有用时，我变得十分困惑。 所以，就像我通常对待我不理解的事情一样，我决定深入挖掘，同时也希望这篇文章对其他人有用。

像往常一样，如果你想评论你看到的某些内容，请随时[提交拉取请求](https://github.com/veekaybee/veekaybee.github.io)。

## 计算机如何编译我们的代码

为了弄清楚Python核心开发人员在尝试用类型提示做什么，我们来从Python中分几个层次，从而更好地理解计算机和编程语言的工作原理。

编程语言的核心，是使用CPU、在内存中存储输入输出，从而来处理数据。

![](https://raw.githubusercontent.com/veekaybee/veekaybee.github.io/master/images/computer.png)

CPU相当愚蠢，它可以完成艰巨的任务，但只能理解机器语言，其底层依靠电力驱动。机器语言底层使用0和1来表示。

为了得到这些0和1，我们要从高级语言转向低级语言，这就需要编译和解释型语言了。

编程语言要么[被编译要么被执行](http://openbookproject.net/thinkcs/python/english2e/ch01.html) （Python通过解释器解释执行）， 代码转换为较低级别的机器代码，告诉计算机的低级组件即硬件该做什么。

有多种方法可以将代码转换为机器能识别的代码：你可以构建二进制文件并让编译器对其进行翻译（C ++，Go，Rust等），或直接运行代码并让解释器执行。 后者是Python（以及PHP，Ruby和类似的脚本语言）的工作原理。

![](https://raw.githubusercontent.com/veekaybee/veekaybee.github.io/master/images/interpret.png)

硬件如何知道如何将这些0和1存储在内存中？ 软件也就是我们的代码需要告诉硬件该如何为数据分配内存。 这些数据是什么类型的呢？ 这就由语言选择的数据类型来决定了。

每一种语言都有数据类型，他们往往是你学习编程时的第一件要学习的事情。

你可能看过这样的教程 (来组Allen Downey的优秀教材, [像计算机科学家一样思考”](http://openbookproject.net/thinkcs/python/english3e/)),讲述了它们是什么。 简而言之，它们是表示内存中数据的不同方式。

![](https://raw.githubusercontent.com/veekaybee/veekaybee.github.io/master/images/datatypes.png)

根据所使用语言的不同，会有字符串，整数等其他类型. 比如[Python的基本数据类型](https://en.wikibooks.org/wiki/Python_Programming/Data_Types) 包含：

```plain
int, float, complex
str
bytes
tuple
frozenset
bool
array
bytearray
list
set
dict
```

There are also data types made up out of other data types. For example, a Python list can hold integers, strings, or both.还有由几种基本数据类型构成的高级数据类型。 例如，Python列表可以包含整数，字符串或两者都包含。

In order to know how much memory to allocate, the computer needs to know what type of data is being stored. 为了知道需要分配多少内存，计算机需要知道被存储数据的类型。幸运的是，Python的[内置函数](https://docs.python.org/3/library/sys.html#sys.getsizeof), `getsizeof`,可以告诉我们每种不同的数据类型占多少字节。

这个 [精彩的回答](https://stackoverflow.com/a/1331541) 告诉了我们一些“空数据结构”的近似值：

```python
import sys
import decimal
import operator

d = {"int": 0,
    "float": 0.0,
    "dict": dict(),
    "set": set(),
    "tuple": tuple(),
    "list": list(),
    "str": "a",
    "unicode": u"a",
    "decimal": decimal.Decimal(0),
    "object": object(),
 }

# Create new dict that can be sorted by size
d_size = {}

for k, v in sorted(d.items()):
    d_size[k]=sys.getsizeof(v)

sorted_x = sorted(d_size.items(), key=lambda kv: kv[1])

sorted_x

[('object', 16),
 ('float', 24),
 ('int', 24),
 ('tuple', 48),
 ('str', 50),
 ('unicode', 50),
 ('list', 64),
 ('decimal', 104),
 ('set', 224),
 ('dict', 240)]
```

如果我们对结果进行排序，我们可以看到在默认情况下，最大的数据结构是空字典，然后是集合；与字符串相比，整形所占很小。

这让我们知道了程序中不同类型的数据各占了多少内存空间。

Why do we care? Some types are more efficient and better suited to different tasks than others. Other times, we need rigorous checks on these types to make sure they don’t violate some of the assumptions of our program.我们为什么要在意这些呢？因为一些类型比另一些类型更高效，更适合不同的任务。还有些场合，我们需要对类型做严格的检查来保证他们不会违反我们程序的一些假设。

不过这些类型到底是什么？我们又为什么需要他们呢？

下面就是类型系统发挥作用的地方。

## 类型系统介绍

[很久以前](https://homepages.inf.ed.ac.uk/wadler/topics/history.html),  [依靠手工运算数学的人们](https://en.wikipedia.org/wiki/Type_theory) 意识到，如果他们使用“类型”来标记数字或方程的元素，就可以减少在对这些元素进行数学证明中遇到的逻辑问题。

一开始，计算机科学基本上依靠手工完成大量数学运算，一些原则延续下来，类型系统通过为特定类型分配不同的变量或元素，成为减少程序中错误数量的一种方法。

下面是一些例子:

* 如果我们为银行编写软件，在计算用户账户总额的代码片段中不能使用字符串。
* 如果我们要处理调查数据，想要了解人们做或者没做某件事，这时使用表示是/否的布尔值将最恰当。
* 在一个大的搜索引擎中，我们必须限制允许输入搜索框的字符数，因此我们需要对某些类型的字符串进行类型验证。

现今在编程领域，有两种不停地类型系统：静态和动态。 [Steve Klabnik](https://blog.steveklabnik.com/posts/2010-07-17-what-to-know-before-debating-type-systems), 写到：

> 在静态系统中，编译器检查源代码并将“类型”标签分配给代码中的参数，然后使用它们来推断程序行为的信息。 动态类型系统中，编译器生成代码来跟踪程序使用的数据类型（也恰巧称为“类型”）。

这意味着什么？这意味着对编译型语言来说，你需要预先指定类型以便让编译器在编译期进行类型检查来确保程序是合理的。

这也许我最近读到的是[对两者最好的解释](http://www.nicolas-hahn.com/python/go/rust/programming/2019/07/01/program-in-python-go-rust/) ：

> 我之前使用静态类型语言，但过去几年我主要使用Python语言。 起初的体验有点恼火，感觉好像只是放慢了我的速度，而Python本可以完全只让我做我所想做的，即便我偶尔出错也没关系。 这有点像向那些总是阻止你要求你澄清意思的人而不是总是点头并且理解你的人发出指示，尽管你并不总是确定他们理解了一切。

这里有一点需要注意：静态和动态类型的语言是紧密相连的，但不是编译型或解释型语言的同义词。 您可以使用动态类型的语言（如Python）编译执行，也可以使用静态语言（如Java）解释执行，例如使用Java REPL。

## 静态与动态类型语言中的数据类型

那么这两种语言中数据类型的区别是什么呢？ 在静态类型中，你必须先布定义类型。 例如，如果您使用Java，你的程序可能如下所示：

```java
public class CreatingVariables {
	public static void main(String[] args) {
		int x, y, age, height;
		double seconds, rainfall;

		x = 10;
		y = 400;
		age = 39;
		height = 63;

		seconds = 4.71;

		rainfall = 23;

		double rate = calculateRainfallRate(seconds, rainfall);
	
	}
private static double calculateRainfallRate(double seconds, double rainfall) {
	return rainfall/seconds;
}
```

注意到这段程序的开头，我们声明了变量的类型：

```java
int x, y, age, height;
double seconds, rainfall;
```

方法也必须包含传入的变量，以便代码能正确编译。 在Java中，你必须从一开始就设计好类型以便编译器在将代码编译为机器码时知道该检查什么。

而Python将类型隐藏了，类似的 Python代码是这样的：

```python
x = 10
y = 400
age = 39
height = 63

seconds = 4.71

rainfall = 23
rate = calculateRainfall(seconds, rainfall)

def calculateRainfall(seconds, rainfall):
	return rainfall/seconds
```

这背后原理是怎样的呢？

## Python如何处理数据类型

Python是动态类型的语言，这意味着他只会在你运行程序的时候检查你生命的变量类型。正如我们在上述代码片段中看到的，你不必事先计划类型和内存分配。

[这其中](https://nedbatchelder.com/blog/201803/is_python_interpreted_or_compiled_yes.html)发生了什么：

> 在Python中，CPython将源码编译成一种更简单的字节码形式。 这些指令类似于CPU指令，但它们不是由CPU执行，而是由虚拟机软件执行。（这些虚拟机不是模仿整个操作系统，只是简化的CPU执行环境）

当CPython编译程序时，如果不指定数据类型，它如何知道变量的类型呢？答案是它不知道，它只知道变量是对象。Python中一切皆是[对象](https://jakevdp.github.io/blog/2014/05/09/why-python-is-slow/)，直到它变成一种具体的类型，那正是它被检查的时候。

对于像字符串这样的类型，Python假设任何被单引号或者双引号包围起来的内容都是字符串。对于数字，Python有一种数值类型与之对应。如果我们尝试对某种类型执行某种Python无法完成的操作，Python将会提示我们。

例如，就像下面这样：

```python
name = 'Vicki'
seconds = 4.71;

---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
<ipython-input-9-71805d305c0b> in <module>
      3 
      4 
----> 5 name + seconds

TypeError: must be str, not float
```

它提示我们不能将字符串和浮点数相加。Python直到执行的时候那一刻才知道name是一个字符串而seconds是一个浮点数。

[换句话说](http://www.voidspace.org.uk/python/articles/duck_typing.shtml)，

> 鸭子类型是在这种情况下发生的：当我们执行加法时，Python并不关心对象是什么类型。 它关心的是对它调用的加法方法返回的内容是否是合理的， 如果不是， 就会引发错误。

所以这意味着什么呢？如果我们以类似Java或者C的方式写一段代码，我们在CPython解释器执行又问答题的代码行之前不会遇到任何错误。

对于编写大量代码的团队而言，这已被证明是不方便的。因为你不是只需要处理几个变量，而要处理相互调用的大量类，并需要能够快速检查所有内容。

如果你不能写下很好的测试代码，在投入生产环境之前找出程序中的错误，你将会破坏整个系统。

大体上，使用类型提示有[很多好处](https://www.bernat.tech/the-state-of-type-hints-in-python/) ：

> 如果你使用复杂的数据结构，或者有很多输入的函数，在很久之后再次阅读代码时将会更容易。如果只是向我们的示例中带有单个参数的简单函数，则会显得很简单。

但是如果你面对的是含有大量输入的代码库，比如PyTorch文档中的[这个例子](https://github.com/pytorch/examples/blob/1de2ff9338bacaaffa123d03ce53d7522d5dcc2e/mnist/main.py#L28)？

```python
def train(args, model, device, train_loader, optimizer, epoch):
    model.train()
    for batch_idx, (data, target) in enumerate(train_loader):
        data, target = data.to(device), target.to(device)
        optimizer.zero_grad()
        output = model(data)
        loss = F.nll_loss(output, target)
        loss.backward()
        optimizer.step()
        if batch_idx % args.log_interval == 0:
            print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
                epoch, batch_idx * len(data), len(train_loader.dataset),
100. * batch_idx / len(train_loader), loss.item()))
```

什么是model？我们来看下面的代码。

```python
model = Net().to(device)
```

如果我们能够在方法签名中指定而不必查看代码，这样是不是会很酷？就像下面这样：

```python
def train(args, model (type Net), device, train_loader, optimizer, epoch):
```

什么又是device呢

```python
device = torch.device("cuda" if use_cuda else "cpu")
```

什么是 torch.device？它是一种特殊的 PyTorch类型.如果我们到[文档和代码的其他部分](https://github.com/pytorch/pytorch/blob/a9f1d2e3711476ba4189ea804488e5264a4229a8/docs/source/tensor_attributes.rst)，我们可以发现：

```plain
A :class:`torch.device` is an object representing the device on which a :class:`torch.Tensor` is or will be allocated.

The :class:`torch.device` contains a device type ('cpu' or 'cuda') and optional device ordinal for the device type. If the device ordinal is not present, this represents the current device for the device type; e.g. a :class:`torch.Tensor` constructed with device 'cuda' is equivalent to 'cuda:X' where X is the result of :func:`torch.cuda.current_device()`.

A :class:`torch.device` can be constructed via a string or via a string and device ordinal 
```

如果我们能够注释这些，就不必在程序中查找，这样不是更好吗？

```python
def train(args, model (type Net), device (type torch.Device), train_loader, optimizer, epoch):
```

还有很多例子......

因此类型提示对大家编程都是有帮助的。

类型提示也有助于他人阅读你的代码。具有类型提示的代码读起来更容易，不必像上面的例子那样检查整个程序的内容。类型提示提高了易读性。

那么，Python做了什么来提升与静态类型语言相同的易读性呢？

## Python的类型提示

Here’s where type hints come in. As a side note, the docs interchangeably call them type annotations or type hints. I’m going to go with type hints. In other languages, annotations and hints mean someting completely different.下面是类型提示的来源，作为代码旁边的注释，称为类型注释或类型提示。 我将称它们为带类型提示。 在其他语言中，注释和提示的意义完全不同。

在Python2中人们开始在代码中加入提示，来表示各种函数返回了什么。

那种代码看起来就像 [这样](https://www.python.org/dev/peps/pep-0483/):

```python
users = [] # type: List[UserID]
examples = {} # type: Dict[str, Any]
```

开始类型提示就像注释。 但后来Python逐渐使用更统一的方法来处理类型提示，开始包括 [函数注释](https://www.python.org/dev/peps/pep-3107/)：

```plain
Function annotations, both for parameters and return values, are completely optional.

Function annotations are nothing more than a way of associating arbitrary Python expressions with various parts of a function at compile-time.

By itself, Python does not attach any particular meaning or significance to annotations. Left to its own, Python simply makes these expressions available as described in Accessing Function Annotations below.

The only way that annotations take on meaning is when they are interpreted by third-party libraries. These annotation consumers can do anything they want with a function's annotations. For example, one library might use string-based annotations to provide improved help messages, like so:
```

随着PEP 484的发展，它是与mypy一起开发的，这是一个出自DropBox的项目，它在你运行程序时检查类型。 要记住在运行时不检查类型。 如果尝试在不兼容的类型上运行方法，将只会出现问题。 例如尝试对字典切片或从字符串中弹出值。

从实现细节来看：

>  虽然这些注释在运行时通过** annotations **属性可用，但在运行时不会进行类型检查。 相反，该提议假定存在一个单独的离线类型检查器，用户可以自行运行其源代码。 本质上来讲，这种类型的检查器就像一个强大的linter。 （当然个人用户可以在运行时使用类似的检查器来进行设计执行或即时优化，但这些工具还不够成熟）

在实践中是怎样的呢？

类型检查也意味着你可以更容易的使用集成开发环境。例如PyCharm根据类型提供了[代码补全与检查](https://www.jetbrains.com/help/pycharm/type-hinting-in-product.html),就像VS Code一样。

类型检查在另一方面也是有益的：它们可以阻止你犯下愚蠢的错误. [这里是个很好的例子](https://medium.com/@ageitgey/learn-how-to-use-static-type-checking-in-python-3-6-in-10-minutes-12c86d72677b) 。

这里我们要增加一个名字到字典中：

```python
names = {'Vicki': 'Boykis',
         'Kim': 'Kardashian'}

def append_name(dict, first_name, last_name):
    dict[first_name] = last_name

append_name(names,'Kanye',9)
```

如果我们允许程序这样执行了，我们在字典中将会得到一堆格式错误的条目。

那么如何改正呢？

```python
from typing import Dict 

names_new: Dict[str, str] = {'Vicki': 'Boykis',
                             'Kim': 'Kardashian'}

def append_name(dic: Dict[str, str] , first_name: str, last_name: str):
    dic[first_name] = last_name

append_name(names_new,'Kanye',9.7)

names_new
```

通过在mypy运行：

```bash
(kanye) mbp-vboykis:types vboykis$ mypy kanye.py
kanye.py:9: error: Argument 3 to "append_name" has incompatible type "float"; expected "str"
```

我们可以看到，mypy不允许这种类型。在持续集成管道中的测试管道中包含mypy是很有意义的。

## 继承开发环境中的类型提示

使用类型提示的最大好处之一是，你可以在IDE中会获得和静态语言同样的自动补全功能。

比如，我们假设你有这样一段代码，这仅仅是上面是用过的两个函数包装成了类。

```python
from typing import Dict

class rainfallRate:

    def __init__(self, hours, inches):
        self.hours= hours
        self.inches = inches

    def calculateRate(self, inches:int, hours:int) -> float:
        return inches/hours

rainfallRate.calculateRate()

class addNametoDict:

    def __init__(self, first_name, last_name):
        self.first_name = first_name
        self.last_name = last_name
        self.dict = dict

    def append_name(dict:Dict[str, str], first_name:str, last_name:str):
        dict[first_name] = last_name

addNametoDict.append_name()
```

巧妙的是，现在我们添加了类型，当我们调用类的方法时，我们可以看到发生了什么：

![](https://raw.githubusercontent.com/veekaybee/veekaybee.github.io/master/images/tabcomplete2.png)

![](https://raw.githubusercontent.com/veekaybee/veekaybee.github.io/master/images/tabcomplete1.png)

## 开始使用类型提示

mypy有一些关于开发一个代码库的[很好建议](https://mypy.readthedocs.io/en/latest/existing_code.html)：

```plain
 1. Start small – get a clean mypy build for some files, with few hints
 2. Write a mypy runner script to ensure consistent results
 3. Run mypy in Continuous Integration to prevent type errors
 4. Gradually annotate commonly imported modules
 5. Write hints as you modify existing code and write new code
 6. Use MonkeyType or PyAnnotate to automatically annotate legacy code
```

为了在你自己的代码中开始使用类型提示，理解以下几点很会有帮助：:

首先，如果你在使用除了字符串，整形，布尔和其他Python的基本类型，你需要[导入类型模块](https://docs.python.org/3/library/typing.html)。

Second, that there are several complex types available through the module:第二，通过模块，有几种复杂类型可用：

字典，元组，列表，集合等。

例如，字典[str, float]表示你想检查一个字典，其中键是字符串类型，值是浮点数类型。

还有一种叫Optional和Union的类型

第三，如下是类型提示的形式：

```python
import typing

def some_function(variable: type) -> return_type:
	do_something
```

如果你想开始更深入地使用类型提示，很多聪明人已经写下一些教程。 这里有我们人入门[最好的教程](https://pymbook.readthedocs.io/en/latest/typehinting.html) 而且它会知道你如何设置测试环境。

## 那么，该如何决定？用还是不用呢？

你应该使用类型提示吗？

这取决于你的使用场景，就像Guido和mypy文档里说的：

> mypy的目标不是说服每个人都编写静态类型的Python，不管是现在还是将来，静态类型的编程完全是可选的。mypy的目标是为Python程序员提供更多的选择，使Python称为一门在大型项目中相比于其他静态类型语言更具竞争力的可选方案，从儿女提高程序员的工作效率并且提升软件质量。

由于设置mypy和思考所需要的类型的开销，类型提示对于小型代码库来说没有意义（比如在jupyter notebook中）。什么算小代码库呢? 保守的说，大概是任何低于 1k的内容。

对于大型代码库，当你需要与他人一起合作，打包，当你需要版本控制和持续集成系统，类型提示很有意义并可以节省大量时间。

我的意见是，类型提示正变得越来越常见。在在未来几年中，即使在不是很常见的地方，带头使用它也不是坏事。

## 致谢

**特别感谢 [Peter Baumgartner](https://twitter.com/pmbaumgartner), [Vincent Warmerdam](https://twitter.com/fishnets88), [Tim Hopper](https://tdhopper.com/), [Jowanza Joseph](https://www.jowanza.com/), 和 [Dan Boykis](http://danboykis.com/) 阅读本文草稿，所有遗留的错误来自于我 :)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

