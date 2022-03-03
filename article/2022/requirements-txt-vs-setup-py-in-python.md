> * 原文地址：[A Comparison of requirements.txt vs setup.py in Python](https://python.plainenglish.io/requirements-txt-vs-setup-py-in-python-325bca3939af)
> * 原文作者：[Muppala Sunny Chowdhary](https://medium.com/@muppalasunnychowdhary)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/requirements-txt-vs-setup-py-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2022/requirements-txt-vs-setup-py-in-python.md)
> * 译者：
> * 校对者：

# A Comparison of requirements.txt vs setup.py in Python

![Photo by [Eugen Str](https://unsplash.com/@eugen1980?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/tool?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/2800/0*hYTVmma-P6S3t51L.jpeg)

## Introduction

Managing dependencies in Python projects could be quite challenging, especially for people new to the language. When developing a new Python package, then chances are you will also need to utilize some other packages that will eventually help you write less code (in less time) so that you don’t have to re-invent the wheel. Additionally, your Python package may also be used as a dependency in future projects.

In today’s article, we will discuss how to properly manage dependencies for Python projects. More specifically, we will discuss the purpose of `**requirements.txt**` the file and how to use `**setuptools**` in order to distribute your Python package and let other users develop it further. Therefore, we will also be discussing the purpose of setup files (namely `**setup.cfg**` and `**setup.py**`) and how they can be used along with requirements files in order to make package development and redistribution easier.

## What are the dependencies of Python projects?

First, let’s start our discussion with package dependencies; what they really are, and why it’s important to manage them properly in order for your Python project to be maintained easier.

In very simple terms, dependencies are external Python packages that your own project relies on, in order to do the job is intended to. In the context of Python, these dependencies are usually found on the Python Package Index (PyPI) or in other repository management tools, such as Nexus.

As an example, let’s consider a Python project that makes use of pandas DataFrames. In this case, this project has a dependency on `pandas` package since it cannot work properly without pre-installing pandas.

Every dependency — which is in turn a Python package on its own — may also have other dependencies. Therefore, dependency management can sometimes get quite tricky or challenging and needs to be handled properly in order to avoid issues when installing or even enhancing the package.

Now our own Python project may have a dependency on a specific version of a third-party package. And since this is a case, we may also end up with dependency conflicts where (at least) two dependencies may have a dependency on another package, but each one needs a specific version of that external package. These cases can be handled (well, not always!) by package management tools such as `pip`. Usually, though, we should instruct `pip` how it needs to handle the dependencies and what specific versions we need.

The most common way for handling dependencies and instructing package management tools about what specific versions we need in our own project is through a requirements text file.

## The requirements.txt file

The `requirements.txt` is a file listing all the dependencies for a specific Python project? It may also contain dependencies of dependencies, as discussed previously. The listed entries can be pinned or non-pinned. If a pin is used, then you can specify a specific package version (using `==`), an upper or lower bound or even both.

**Example `requirements.txt` file**

```
matplotlib>=2.2
numpy>=1.15.0, <1.21.0
pandas
pytest==4.0.1
```

Finally, you could install these dependencies (normally in a virtual environment) through `pip` using the following command:

```bash
pip install -r requirements.txt
```

In the example requirements file above, we specified a few dependencies using various pins. For example, for the `pandas` the package that has no pin associated with it, `pip` will normally install the latest version, unless one of the other dependencies has any conflict with this (in this case `pip` will normally install the latest `pandas` the version that satisfies the conditions specified by the remaining dependencies). Now going forward, for `pytest` the package manager will install the specific version (i.e. `4.0.1`) while for matplotlib, will install the latest version, which is at least greater or equal than `2.2` (again this depends on whether another dependency specifies otherwise). Finally, for `numpy` package, `pip` will attempt to install the latest version between versions `1.15.0` (inclusive) and `1.21.0` (non-inclusive).

Once you install all the dependencies, you can see the precise version of each dependency installed in the virtual environment by running `pip freeze`. This command will list all the packages along with their specific pins (i.e. `==`).

The requirements file is extremely useful but in most cases, it must be used for development purposes. If you are planning to distribute your package so that it is widely available (say on PyPI), you may need something more than just this file.

## setuptools in Python

`[setuptools](https://setuptools.pypa.io/en/latest/)` is a package built on top of `distutils` that allows developers to develop and distribute Python packages. It also offers functionality that makes dependency management easier.

When you want to release a package, you normally need some **metadata** including the package name, version, dependencies, entry points, etc. and `setuptools` offers the functionality to do exactly this.

The project metadata and options are defined in a `setup.py` file, as shown below.

```python
from setuptools import setup
setup(     
    name='mypackage',
    author='Giorgos Myrianthous',     
    version='0.1',     
    install_requires=[         
        'pandas',         
        'numpy',
        'matplotlib',
    ],
    # ... more options/metadata
)
```

In fact, this is considered to be a somewhat bad design given that the file is purely declarative. Therefore, a better approach is to define these options and metadata in a file called `setup.cfg` and then simply call `setup()` in your `setup.py` file. An example `setup.cfg` the file is illustrated below:

```
[metadata]
name = mypackage
author = Giorgos Myrianthous
version = 0.1[options]
install_requires =
    pandas
    numpy
    matplotlib
```

and finally, you can have a minimal `setup.py` file:

```python
from setuptools import setup
if __name__ == "__main__":
    setup()
```

Note that the `install_requires` an argument can take a list of dependencies along with their specifiers (including the operators `\<`, `>`, `\<=`, `>=`, `==` or `!=`, followed by a version identifier. Therefore, when the project gets installed, every dependency that isn’t already satisfied in the environment will be located on PyPI (by default), downloaded, and installed.

## Do we need both requirements.txt and setup.py/setup.cfg files?

Well.. it depends! First of all, I want to clarify that the dilemma between `requirements.txt` vs `setup.py` does not exactly correspond to an apple-to-apple comparison because they are **normally used to achieve different things**.

This is a common misunderstanding regarding this topic as people usually feel that they are simply duplicating information across these files and that they should maybe use one or the other. This isn’t actually the case though.

First, let’s understand when you’d normally have both files or just one of the two. **As a general rule of thumb**:

* If your package is mostly for development purposes but you aren’t planning on redistributing it, **`requirements.txt` should be enough** (even when the package is developed on multiple machines).
* If your package is developed only by yourself (i.e. on a single machine) but you are planning to redistribute it, then **`setup.py`/`setup.cfg` should be enough**.
* If your package is developed on multiple machines and you also need to redistribute it, you will **need both the `requirements.txt` and `setup.py`/`setup.cfg` files**.

Now if you need to use both notations (pretty much always to be honest), then you need to make sure that you won’t repeat yourself.

In case you are using both, your **`setup.py` (and/or `setup.cfg`) files should include the list of abstract dependencies, whereas the `requirements.txt` file must contain the concrete dependencies** with the specific pins for each package version (using `==` pin).

Whereas `install_requires` (i.e. `setup.py`) defines the dependencies for a single project, [Requirements Files](https://pip.pypa.io/en/latest/user_guide/#requirements-files) are often used to define the requirements for a complete Python environment.

Whereas `install_requires` requirements are minimal, requirements files often contain an exhaustive listing of pinned versions for the purpose of achieving [repeatable installations](https://pip.pypa.io/en/latest/user_guide/#repeatability) of a complete environment.

- [Python Documentation](https://packaging.python.org/en/latest/discussions/install-requires-vs-requirements/#requirements-files)

## Final Thoughts

In today’s tutorial, we discussed the importance of proper dependency management when it comes to developing Python projects and applications. We discussed the purpose of `requirements.txt` file and how it can be used alongside setup files of `setuptools` (i.e. `setup.py` and `setup.cfg`) in order to ensure that other developers can install, run, develop or even test the source code of a Python package.

As already highlighted, `setuptools` are not exactly a replacement for `requirements.txt` files. In most cases, you will need both files to be present in order to properly manage your package dependencies in a way that they can also be re-distributed later on.

If you are wondering now how you can potentially distribute your Python package and make it available on PyPI so that it can also be installed through the `pip` package manager, make sure to read the article below.

And there you have it. Thank you for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
