> * 原文地址：[Untested Python Code is Already Broken](https://python.plainenglish.io/untested-python-code-is-already-broken-934cb40b547b)
> * 原文作者：[Matthew Hull](https://medium.com/@tigenzero)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/untested-python-code-is-already-broken.md](https://github.com/xitu/gold-miner/blob/master/article/2021/untested-python-code-is-already-broken.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：

# Untested Python Code is Already Broken

![Image by [Hier und jetzt endet leider meine Reise auf Pixabay 😢](https://pixabay.com/users/alexas_fotos-686414/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1873171) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1873171)](https://cdn-images-1.medium.com/max/3840/1*CN92tzyClc_mkk4LWWEXtQ.jpeg)

我的第一位导师极其的令人难以置信。他向我展示了编码、日志记录、文档编制的最佳实践和其带来的收益。但有一件事情一直xxxx。他的测试代码方式很复杂，包括在xxxxx！他的方式与我的编码风格对立，这让我觉得：**“如果我在写函数前就写好了测试，那么我还不如不写测试。”**这样想让我感觉好多了。

问题在于：你的代码需要测试。这是因为所有代码，即便是好的代码，都难免会有xxxx。对于新手的解释：bug 是意外的功能或错误。你可能对自己的代码及其局限性非常了解，但是新队友呢？或者，在一年后，你想为一个您已经基本忘记的项目添加一个功能，该怎么办？测试就好比保龄球道上的保险杠，让你每次都可以对提交代码和性能评估充满信心。

本文将重用我的 Python 学习系列中[第 3 部分](https://python.plainenglish.io/build-a-fast-food-order-taker-in-python-87188efcbbdd)的代码，并使用我在[此处](https://python.plainenglish.io/stop-making-excuses-and-use-make-9da448efed12)介绍的 Makefile。如果你是 Python 新手，为何不来看[第 1 部分](https://python.plainenglish.io/create-your-own-dice-roller-with-python-40d65c16eb84)和[第 2 部分](https://python.plainenglish.io/draw-a-random-playing-card-in-python-848393d6d868)？此外，如果您没有自己的 Python 工作环境，请在[此处](https://python.plainenglish.io/new-python-developers-need-these-tools-979a17cdffc9)查看您需要的内容。

讨论的课题：

* 单元测试
* 继承
* Mocking using patch
* Makefile
* 什么时候编写测试？

由于这需要一些代码，我已经创建了一个 [Github Project](https://github.com/Tigenzero/medium_test_with_order_taker) 来帮助我们开始这个话题。获取它最简单的方法是通过 Github Desktop 克隆它，或将其下载为 zip 文件。文件夹中包含 `order_up.py`、一个 `Makefile` 和一个 `Pipfile`，还有一个 `Solutions` 文件夹，但我们暂时先不管它。

创建一个名为 `tests` 的 Python 包。如何创建？这非常复杂 —— 创建一个文件夹，在里面创建一个名为 `__init__.py` 的空文件。是的，这样就完成了。在新的 `tests` 文件夹中，创建一个名为 `test_order_up.py` 的文件。现在我们可以开始了。注意：unittest（和 pytest）根据以 “test” 开头的文件确定测试的代码，因此在命名非测试文件时请避免这一点！

## 测试是什么？

简而言之，测试回答了“我的程序是否像我期望的那样做事？”这个问题。 要想回答这个问题，我们可以通过使用预选输入来运行一个函数并检查输出是否符合我们的预期。 通过运行一个函数并验证输出，确保它不会抛出和错误，或者确保它**确实**抛出错误，你可以确保你的代码通过了全面的测试。 一组好的测试应包含正常用例、边缘用例和天马行空的用例。 您不仅要确保您的代码按原样运行，而且还要确保你的**测试将捕获你或其他人将来所做的任何愚蠢行为**。

## Unittest

Unittest 是 Python 的内置测试框架，所以我们将从这里开始。将此代码放入您的测试文件中：

```python
import unittest
import order_up


class TestOrderUp(unittest.TestCase):
    def test_get_order_one_item(self):
        order = ["fries"]
        result = order_up.get_order(order)
        self.assertEqual(order, result)
```

首先，我们 `import unittest`，它是一个用于测试代码的内置 Python 包，然后我们导入 `order_up.py` 文件（注意我们省略了 `.py` 扩展名）。

> **注**：如果你使用的是 PyCharm 并在 `order_up` 下看到了红色的波浪线，这表示找不到此包。你可以通过在 Github 项目目录的根（开头）打开项目或右键单击项目文件夹并选择 “Mark Directory as” -> “Sources Root” 来解决此问题。

接下来，我们创建一个名为 ·TestOrderUp· 的类，它只的名称和我们的文件名相匹配，这样一来我们能更容易找到失败的测试。哦，但是括号里有个东西，`unittest.TestCase`，这意味着我们的类继承了 `TestCase` 类。

### 继承

继承表示一个类从父类接收函数和变量。 对于我们的这种情况来说，我们从 `TestCase`  继承了丰富的功能，以便让我们的测试工作更加轻松。 继承了什么函数和变量？ 我们之后后探讨这个问题。

## 创建一个测试

在我们的类下面有个名为 `test_output_order_one_item` 的函数，它应该大致解释我们在测试中所做的事情。 我们将用其于测试 `get_order()` 函数并检查输出是否符合我们的预期。让我们运行它，看看会发生什么！ 你可以在终端中执行 `python -m unittest`，或者点击 PyCharm 中函数旁边的绿色箭头，或者xxxx。 看看结果：

![Nice, you’ve ran your first test!](https://cdn-images-1.medium.com/max/2000/1*nB9QtcujX_565oxvjNDS9g.png)

### 断言（assert）

An inherited set of functions that comes from `unittest.TestCase` are the asserts, or checks to make sure we got what we wanted. In Pycharm, take a look at the different options by writing `self.assert` and letting its Code Completion feature show all the different options. There’s a lot but the main ones I use are `self.assertEqual`, which checks that two objects are the same, and `self.assertTrue`/`self.assertFalse` which are self-explanatory.

现在，`order_up` 的主要功能是获取订单，删除不在菜单上的项目，并允许重复项目。 因此，让我们添加测试以确保我们在代码中保留这些功能。

```python
# 确保这些函数在类中缩进。
def test_get_order_duplicate_in_list(self):
    order = ["fries", "fries", "fries", "burger"]
    result = order_up.get_order(order)
    self.assertEqual(order, result)

def test_get_order_not_on_menu(self):
    order = ["banana", "cereal", "cookie"]
    expected_result = ["cookie"]
    result = order_up.get_order(order)
    self.assertEqual(expected_result, result)
```

Now we are checking that our function can handle duplicates and instances where the items aren’t on the menu. Run those tests and make sure they pass! Side note: it’s best practice to leave a line between the setup of the test, the execution of the function, and the validation of the output. That way, you and your teammates can easily see what’s what.现在我们正在检查我们的函数是否可以处理重复项目和不在菜单上的项目。 运行这些测试并确保它们通过！ 旁注：最好的做法是在写测试让函数的执行和输出的验证之间隔开一行。 这样，你和你的队友就可以很容易地分辨什么是什么。

## Patch

I have a confession to make: I cheated a little bit. If you compare the code from [Part 3](https://python.plainenglish.io/build-a-fast-food-order-taker-in-python-87188efcbbdd) to the current `order_up.py`, you’ll notice I added functionality to accommodate a new variable: `test_order`. Using this new variable, I could introduce bypass `input()` so we wouldn’t have the program asking for user input every time we ran tests. But now that we have the basics of testing down, we can tackle mocking. Mocking is simply creating functions or objects that mimic the real functions and objects so our tests can focus on one aspect of a function or logic. In this instance, we will “patch” the `input()` function, or temporarily rewrite it, to simply return an output we want. Take a look:

```python
@patch("builtins.input", return_value="yes")
def test_is_order_complete_yes(self, input_patch):
    self.assertEqual(builtins.input, input_patch)

    result = order_up.is_order_complete()

    self.assertFalse(result)
```

First, addfrom unittest.mock import patch to the beginning of the test file. At the beginning, we are patching the `builtins.input()` function and telling it to instead return “yes”. Then, we do an “assert” to check the pulled in argument from the patch is exactly as it says it is! Notice how `builtins.input` doesn’t have a parenthesis? Instead of executing the function, we are able to reference the function’s signature for validation. After that, we are back to normal test protocol: run the function, get the result, and assert the result is what we expect. In this case, because our `input()` return value is “yes”, we `expect is_order_complete()` to return False. Add it to your test class, click run, get that red OK or those green checkmarks and let’s move forward!

### Side Effect

Now that we have patch under our belt, we can address the inputs in `get_output()`! Well, almost. First, we need to learn about `side_effect` , our savior when we need different returns for the same function. In `get_output()`, we are asked, via `input()` , “what do you want?” and “are you done?” Because of this, we need to have `input()` return not just one but several outputs to fit each situation. Take a look:

```python
@patch("builtins.input", side_effect=["banana", "cookie", "yes", "fries", "no"])
def test_get_order_valid(self, input_patch):
    self.assertEqual(builtins.input, input_patch)
    expected_result = ["cookie", "fries"]

    result = order_up.get_order()

    self.assertEqual(expected_result, result)
```

To do this, we don’t assign `return_value` and instead assign `side_effect` a list. 

> **NOTE:** you can assign `side_effect` or `return_value` inside the test function as well.

`side_effect` will take each item in the list and provide it individually each time the patched function is called. Add that code and hit that test button/command! One last thing: there’s no yes/no in between “banana” and “cookie” because `get_order()` doesn’t ask “do you want to order more?” if an item doesn’t exist in the `MENU`. Something to keep in mind if you play around with list yourself.

## Makefile

Now that the basics of testing are out of the way, take a look inside the Makefile. I won’t copy/paste the code, since you can see it in the project, but the main recipes to look at are `unit-test` and `run`. `unit-test` requires `venv` to execute, and makes sure to start a virtual environment based on our Pipfile config. Notice at the end of `unit-test`, we execute python3 -m pipenv run python3 -m unittest; ? That’s where the testing magic happens, and it will be there even when you forget how to run tests! Again.

## 什么时候编写测试？

那么什么时候编写测试呢？**这不重要。** 重点是所写的测试能涵盖大部分代码以及它可能遇到的潜在用例。 如果你不能正确地测试你的代码或者需要 8 个不同的测试来覆盖一个函数，那么你很有可能需要重构你的代码。 这并不会让你成为一个糟糕的程序员，这只是编程过程/经验的一部分。

### TDD

Let me address the matter of Test-Driven Development, or TDD. TDD is the testing practice of writing a failing test and writing a function that passes that test. **Story Time:** I joined a startup that took Robert C. Martin’s (author of “Clean Code” and other books) concepts of TDD and anti-patterns, or bad coding practices to avoid, as gospel. On one occasion, we had a meeting about TDD and its benefits so as to encourage the teams to code in way leadership found more “efficient.” Unfortunately, the hour was largely spent arguing the definition and proper usage of TDD. The meeting organizer, a senior engineer argued, was “coding too fast” and not implementing the principles of TDD correctly by writing a test that was “too smart” or a function that did more than pass the test.

I walked away from that meeting with one thought: **Leave** your philosophical debates out of my workspace.

The main point is this: **find a way to incorporate tests into your projects that works for you.** I don’t give two bits how you implement them or when, success is simply defined on whether they keep your code from going into the gutter after the next commit. Until next time!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
