> * 原文地址：[Untested Python Code is Already Broken](https://python.plainenglish.io/untested-python-code-is-already-broken-934cb40b547b)
> * 原文作者：[Matthew Hull](https://medium.com/@tigenzero)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/untested-python-code-is-already-broken.md](https://github.com/xitu/gold-miner/blob/master/article/2021/untested-python-code-is-already-broken.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：

# Untested Python Code is Already Broken

![Image by [Hier und jetzt endet leider meine Reise auf Pixabay 😢](https://pixabay.com/users/alexas_fotos-686414/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1873171) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1873171)](https://cdn-images-1.medium.com/max/3840/1*CN92tzyClc_mkk4LWWEXtQ.jpeg)

我的第一位导师极其的令人难以置信。他向我展示了编码、日志记录、文档编制的最佳实践和其带来的收益。但有一件事他一直无法灌输给我，那就是测试。他的测试代码方式很复杂，比如说先写测试程序，然后编码实现！他的方式与我的编码风格对立，这让我觉得：**“如果我在写函数前就写好了测试，那么我还不如不写测试。”**这样想让我感觉好多了。

问题在于：你的代码需要测试。这是因为所有代码，即便是好的代码，都与 bug 只有一线之遥。对于新手的解释：bug 是代码中意外的功能或错误。你可能对自己的代码及其局限性非常了解，但是新队友呢？或者，在一年后，你想为一个您已经基本忘记的项目添加一个功能，该怎么办？测试就好比保龄球道上的保险杠，让你每次都可以对提交代码和性能评估充满信心。

本文将重用我的 Python 学习系列中[第 3 部分](https://python.plainenglish.io/build-a-fast-food-order-taker-in-python-87188efcbbdd)的代码，并使用我在[此处](https://python.plainenglish.io/stop-making-excuses-and-use-make-9da448efed12)介绍的 `Makefile`。如果你是 Python 新手，为何不来看[第 1 部分](https://python.plainenglish.io/create-your-own-dice-roller-with-python-40d65c16eb84)和[第 2 部分](https://python.plainenglish.io/draw-a-random-playing-card-in-python-848393d6d868)？此外，如果您没有自己的 Python 工作环境，请在[此处](https://python.plainenglish.io/new-python-developers-need-these-tools-979a17cdffc9)查看你所需要的内容。

讨论的课题：

* 单元测试
* 继承
* Mocking using patch
* Makefile
* 什么时候编写测试？

由于这需要一些代码，我已经创建了一个 [Github Project](https://github.com/Tigenzero/medium_test_with_order_taker) 来帮助我们开始这个话题。获取它最简单的方法是通过 Github Desktop 克隆它，或将其下载为 zip 文件。文件夹中包含 `order_up.py`、一个 `Makefile` 和一个 `Pipfile`，还有一个 `Solutions` 文件夹，但我们暂时先不管它。

创建一个名为 `tests` 的 Python 包。如何创建？这非常复杂 —— 创建一个文件夹，在里面创建一个名为 `__init__.py` 的空文件。是的，这样就完成了。在新的 `tests` 文件夹中，创建一个名为 `test_order_up.py` 的文件。现在我们可以开始了。注意：unittest（和 pytest）根据以 “test” 开头的文件确定测试的代码，因此在命名非测试文件时请避免这一点！

## 测试是什么？

简而言之，测试回答了“我的程序是否像我期望的那样做事？”这个问题。要想回答这个问题，我们可以通过使用预选输入来运行一个函数并检查输出是否符合我们的预期。 通过运行一个函数并验证输出，确保它不会抛出错误，或者确保它**确实**抛出错误，你能保障代码已被全面的测试。 一组好的测试应包含正常用例、边缘用例和天马行空的用例。 您不仅要确保您的代码按原样运行，而且还要确保你的**测试将捕获你或其他人将来所做的任何愚蠢行为**。

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

继承表示一个类从父类接收函数和变量。 对于我们的这种情况来说，我们从 `TestCase`  继承了丰富的功能以便我们的测试工作更加的轻松。 继承了什么函数和变量？ 我们之后会探讨这个问题。

## 创建一个测试

在我们的类下面有个名为 `test_output_order_one_item` 的函数，它应该大致地解释我们在测试中所做的事情。我们将用其于测试 `get_order()` 函数并检查输出是否符合我们的预期。让我们运行它，看看会发生什么！ 你可以在终端中执行 `python -m unittest`，或者点击 PyCharm 中函数旁边的绿色箭头。你也可以选择执行 `make unit-test`，让代码在虚拟环境中运行。 看看结果：

![Nice, you’ve ran your first test!](https://cdn-images-1.medium.com/max/2000/1*nB9QtcujX_565oxvjNDS9g.png)

### 断言（assert）

我们从 `unittest.TestCase` 中继承的函数包括断言，以确保我们得到我们想要的xxxx。 在 Pycharm 中，输入 `self.assert`，代码完成功能将显示所有不同的选项。 这有很多，但我主要使用是 `self.assertEqual`，它检查两个对象是否相同，以及 `self.assertTrue` 或 `self.assertFalse`，功能不言自明。

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

现在我们正在检查我们的函数是否可以处理重复项目和不在菜单上的项目。 运行这些测试并确保它们通过！ 旁注：最好的做法是在写测试时让执行和验证之间隔开一行。 这样，你和你的队友就可以很容易地分辨哪个是哪个。

## Patch

我必须承认：我作弊了一点。如果你将[第 3 部分](https://python.plainenglish.io/build-a-fast-food-order-taker-in-python-87188efcbbdd)中的代码与当前的 `order_up.py` 进行比较，你将我会注意到我添加了一个功能来容纳一个新变量：`test_order`。有了这个新变量，我可以引入绕过 `input()`，这样我们就不会在每次运行测试时让程序要求用户输入。 但是现在我们已经掌握了测试的基础知识，我们可以模拟模拟问题xxxx。 模拟只是创建模仿真实函数和对象的函数或对象，因此我们的测试可以专注于函数或逻辑方面。 在这种情况下，我们将“补缀” `input()` 函数，或者暂时重写它，以简单地返回我们想要的输出。 看看：

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

说完了测试的基础知识，我们来看一看 `Makefile`。 我不会复制/粘贴代码到这里，因为您可以在项目中看到它。主要方法是`unit-test`和 `run`。`unit-test` 需要 `venv` 来执行，根据我们的 `Pipfile` 配置启动一个虚拟环境。 注意在`unit-test`的末尾，我们执行了 `python3 -m pipenv run python3 -m unittest;` 这就是测试魔法发生的地方，即使你忘记如何运行测试，你也能在那里找到它！

## 什么时候编写测试？

那么什么时候编写测试呢？**这不重要。**重点是所写的测试能涵盖大部分代码以及它可能遇到的潜在用例。 如果你不能正确地测试你的代码或者说需要 8 个不同的测试来覆盖一个函数，那么你很有可能需要重构你的代码。 这并不会让你成为一个糟糕的程序员，这只是编程过程/经验的一部分。

### 测试驱动开发（TDD）

Let me address the matter of Test-Driven Development, or TDD. TDD is the testing practice of writing a failing test and writing a function that passes that test. **Story Time:** I joined a startup that took Robert C. Martin’s (author of “Clean Code” and other books) concepts of TDD and anti-patterns, or bad coding practices to avoid, as gospel. On one occasion, we had a meeting about TDD and its benefits so as to encourage the teams to code in way leadership found more “efficient.” Unfortunately, the hour was largely spent arguing the definition and proper usage of TDD. The meeting organizer, a senior engineer argued, was “coding too fast” and not implementing the principles of TDD correctly by writing a test that was “too smart” or a function that did more than pass the test.让我谈谈测试驱动开发（TDD）的问题吧。TDD 是一种开发实践，先编写失败的测试程序再编写函数来通过它。 **故事时间：** 我加入了一家初创公司，该初创公司将 Robert C. Martin（《代码整洁之道》和其他书籍的作者）的 TDD 和反面模式概念，或要避免的不良编码实践，作为信仰。 有一次，我们召开了一次关于 TDD 及其好处的会议来鼓励团队以领导认为更“有效”的方式进行编码。 不幸的是，大部分时间都花在争论 TDD 的定义和正确用法上。会议组织者，一位高级工程师，认为“编码编得太快”，并没有通过编写"聪明"的测试或功能超过测试的函数来正确实现 TDD 的原则。

我带着一个想法离开那次会议：把你的哲学辩论从我的工作空间中**移开**。

本篇的重点是：**找到一种合适的方法将测试囊括到项目中**。我没有具体的给出实现它们的方法或何时实现，只要它们能阻止你的代码在下一次提交后进入排水沟就算成功了。 再见！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
