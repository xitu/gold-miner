> * 原文地址：[Untested Python Code is Already Broken](https://python.plainenglish.io/untested-python-code-is-already-broken-934cb40b547b)
> * 原文作者：[Matthew Hull](https://medium.com/@tigenzero)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/untested-python-code-is-already-broken.md](https://github.com/xitu/gold-miner/blob/master/article/2021/untested-python-code-is-already-broken.md)
> * 译者：
> * 校对者：

# Untested Python Code is Already Broken

![Image by [Hier und jetzt endet leider meine Reise auf Pixabay 😢](https://pixabay.com/users/alexas_fotos-686414/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1873171) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1873171)](https://cdn-images-1.medium.com/max/3840/1*CN92tzyClc_mkk4LWWEXtQ.jpeg)

My first mentor was nothing short of incredible. He showed me the best practices of coding, logging, documenting, and what coding for fun and profit really looked like. The one thing he could **not** ram into my head was testing. He had this complex way of testing that involved having my tests before my functions! It was simply the antithesis to my coding style, so my solution was **“If I wrote the function before the test, then I may as well not write the test.”** … I got better.

Here’s the deal: your code needs tests. The reason your code needs tests is because all code, even good code, is one commit away from being broken or buggy. For beginners: bugs are unintended functionality or errors. You may be incredibly knowledgeable of your code and its limitations but what about a new teammate? Or what if, in a year, you want to add a feature to a project you’ve largely forgotten? Tests are your bowling lane bumpers so you can feel confident about committing code, and scoring, every time.

This article will be reusing the code from [Part 3](https://python.plainenglish.io/build-a-fast-food-order-taker-in-python-87188efcbbdd) in my series for learning Python, as well as using a Makefile which I introduced [here](https://python.plainenglish.io/stop-making-excuses-and-use-make-9da448efed12). If you are new to Python, why not check out [Part 1](https://python.plainenglish.io/create-your-own-dice-roller-with-python-40d65c16eb84) and [Part 2](https://python.plainenglish.io/draw-a-random-playing-card-in-python-848393d6d868)? Also, if you do not have a workspace of your own for Python, check out what you need [here](https://python.plainenglish.io/new-python-developers-need-these-tools-979a17cdffc9).

Topics Discussed:

* Unit Test
* Inheritance
* Mocking using patch
* Makefile
* When to test?

Since there’s a bit of code to start with, I’ve created a [Github project](https://github.com/Tigenzero/medium_test_with_order_taker) to help get us started. The easiest way to grab it is to clone it from Github Desktop, or download it as a zip file. Inside there’s the `order_up.py`, a `Makefile`, and a `Pipfile`. There’s also a Solution folder but ignore that for now.

Create a Python package called `tests`. How do you create a Python package? It’s super complex, create a folder with an empty file inside it called `__init__.py`. Yep, that’s it. Inside your new tests folder, create a file called `test_order_up.py` and now we are ready to begin. Quick note: unittest (and pytest) determines what code to test based on files that start with “test”, so bear that in mind when naming non-test files!

## What is a Test?

Simply put, a test answers the question “does my program do things like I expect?” We can answer this question by running a function with a pre-selected input and checking that the output is what we expect. By running a function and verifying the output, making sure it doesn’t throw and error, or making sure it **does** throw an error (to name a few), you can ensure your code is fully tested. A good set of tests is a mix of normal use cases, edge cases, and creative cases. You aren’t only trying to make sure your code works as is but that your **tests will catch any tomfoolery done by you or someone else in the future.**

## Unittest

Unittest is a built-in testing framework for Python, so we’ll start here. Toss this code into your test file.

```py
import unittest
import order_up


class TestOrderUp(unittest.TestCase):
    def test_get_order_one_item(self):
        order = ["fries"]

        result = order_up.get_order(order)

        self.assertEqual(order, result)
```

First, we `import unittest` which is a built-in Python package for testing code, then we import the `order_up.py` file (note that we omit the .py extension).

> **NOTE**: If you are in PyCharm and see a red underline under `order_up`, it means that package can’t be found. Remedy this by either opening up the project at the root(the beginning) of the github project directory OR by right-clicking the project folder and selecting “Mark Directory as” -> “Sources Root”.

Next, we create a class called `TestOrderUp`, which simply matches our file name so our failed tests will be easier to find. Oh, but there’s something in parentheses, `unittest.TestCase`, which means our class is inheriting the `TestCase` class.

### Inheritance

Inheritance is one class receiving the functions and variables from a parent class. In this case, we are inheriting the abundance of functions from `TestCase` so as to make our testing lives a lot easier. What functions and variables? We’ll come back to that.

## Creating a Test

Just below our class is the function `test_output_order_one_item`, which should explain roughly what we are doing in the test. We will be testing the `get_order()` function with one item and checking that the output is what we expect. Let’s run it and see what happens! You can either execute `python -m unittest` in a terminal, click the green arrow next to the function in PyCharm, or you can run `make unit-test` to run it in its own environment (we’ll talk about the `Makefile` in a bit). Check it out!

![Nice, you’ve ran your first test!](https://cdn-images-1.medium.com/max/2000/1*nB9QtcujX_565oxvjNDS9g.png)

### Assert

An inherited set of functions that comes from `unittest.TestCase` are the asserts, or checks to make sure we got what we wanted. In Pycharm, take a look at the different options by writing `self.assert` and letting its Code Completion feature show all the different options. There’s a lot but the main ones I use are `self.assertEqual`, which checks that two objects are the same, and `self.assertTrue`/`self.assertFalse` which are self-explanatory.

Now, `order_up`’s main features are getting an order, removing items that aren’t on the menu, and allowing duplicate items. So let’s add tests to make sure we keep those features in the code.

```py
# Be sure these functions are indented within the class.
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

Now we are checking that our function can handle duplicates and instances where the items aren’t on the menu. Run those tests and make sure they pass! Side note: it’s best practice to leave a line between the setup of the test, the execution of the function, and the validation of the output. That way, you and your teammates can easily see what’s what.

## Patch

I have a confession to make: I cheated a little bit. If you compare the code from [Part 3](https://python.plainenglish.io/build-a-fast-food-order-taker-in-python-87188efcbbdd) to the current `order_up.py`, you’ll notice I added functionality to accommodate a new variable: `test_order`. Using this new variable, I could introduce bypass `input()` so we wouldn’t have the program asking for user input every time we ran tests. But now that we have the basics of testing down, we can tackle mocking. Mocking is simply creating functions or objects that mimic the real functions and objects so our tests can focus on one aspect of a function or logic. In this instance, we will “patch” the `input()` function, or temporarily rewrite it, to simply return an output we want. Take a look:

```py
@patch("builtins.input", return_value="yes")
def test_is_order_complete_yes(self, input_patch):
    self.assertEqual(builtins.input, input_patch)

    result = order_up.is_order_complete()

    self.assertFalse(result)
```

First, addfrom unittest.mock import patch to the beginning of the test file. At the beginning, we are patching the `builtins.input()` function and telling it to instead return “yes”. Then, we do an “assert” to check the pulled in argument from the patch is exactly as it says it is! Notice how `builtins.input` doesn’t have a parenthesis? Instead of executing the function, we are able to reference the function’s signature for validation. After that, we are back to normal test protocol: run the function, get the result, and assert the result is what we expect. In this case, because our `input()` return value is “yes”, we `expect is_order_complete()` to return False. Add it to your test class, click run, get that red OK or those green checkmarks and let’s move forward!

### Side Effect

Now that we have patch under our belt, we can address the inputs in `get_output()`! Well, almost. First, we need to learn about `side_effect` , our savior when we need different returns for the same function. In `get_output()`, we are asked, via `input()` , “what do you want?” and “are you done?” Because of this, we need to have `input()` return not just one but several outputs to fit each situation. Take a look:

```py
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

## When to Write Tests

So when do you write your tests? **IT DOES NOT MATTER.** The point is to write tests that cover most of your code as well as the potential use cases it can encounter. If you cannot properly test your code or one function requires 8 different tests to cover, there’s a huge chance you need to refactor your code. Needing to refactor doesn’t make you a bad coder, it’s all part of the process/experience of programming.

### TDD

Let me address the matter of Test-Driven Development, or TDD. TDD is the testing practice of writing a failing test and writing a function that passes that test. **Story Time:** I joined a startup that took Robert C. Martin’s (author of “Clean Code” and other books) concepts of TDD and anti-patterns, or bad coding practices to avoid, as gospel. On one occasion, we had a meeting about TDD and its benefits so as to encourage the teams to code in way leadership found more “efficient.” Unfortunately, the hour was largely spent arguing the definition and proper usage of TDD. The meeting organizer, a senior engineer argued, was “coding too fast” and not implementing the principles of TDD correctly by writing a test that was “too smart” or a function that did more than pass the test.

I walked away from that meeting with one thought: **Leave** your philosophical debates out of my workspace.

The main point is this: **find a way to incorporate tests into your projects that works for you.** I don’t give two bits how you implement them or when, success is simply defined on whether they keep your code from going into the gutter after the next commit. Until next time!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
