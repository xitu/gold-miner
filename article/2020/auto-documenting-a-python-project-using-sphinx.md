> * 原文地址：[Auto-Documenting a Python Project Using Sphinx](https://medium.com/better-programming/auto-documenting-a-python-project-using-sphinx-8878f9ddc6e9)
> * 原文作者：[Julie Elise](https://medium.com/@julie_elise)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/auto-documenting-a-python-project-using-sphinx.md](https://github.com/xitu/gold-miner/blob/master/article/2020/auto-documenting-a-python-project-using-sphinx.md)
> * 译者：[Herman](https://github.com/actini)
> * 校对者：[lsvih](https://github.com/lsvih)

# 使用 Shpinx 为 Python 项目自动生成文档

![Photo by [Jason Blackeye](https://unsplash.com/photos/nyL-rzwP-Mk) on [Unsplash](https://unsplash.com/photos/nyL-rzwP-Mk)](https://cdn-images-1.medium.com/max/12000/1*KOMqHlHUwgvf0RgqXUHMgA.jpeg)

虽说非常有必要好好写项目文档，但写文档这个事儿还是经常被一拖再拖，并且大家都觉得它很繁琐、优先级也很低。开发人员也常常会想“既然对自己写的代码了如指掌，为啥还要写文档呢？”另外，随着代码的不断更新，维护文档也变成了一项繁重的负担。

好消息，得益于 [Sphinx](https://www.sphinx-doc.org/en/master/) 的强大功能，我们无须再手动写文档了，Sphinx 可以从代码的注释中自动生成项目文档。

接下来我们逐步学习在 Python 代码中如何使用 Sphinx 自动生成结构良好、形式整洁的文档。

## 1. 安装 Sphinx

在终端中执行 `pip install -U Sphinx` 可以使用 pip 安装 Sphinx，或者直接从 [Python package](https://pypi.org/project/Sphinx/#files) 官网上下载也可以。

Sphinx 官网上也讲了其他的安装方式，根据你的实际情况自由选择合适的方式安装即可，详见[这里](https://www.sphinx-doc.org/en/master/usage/installation.html)。

## 2. 初始化 Sphinx 配置

在项目根目录下运行 `sphinx-quickstart` 来初始化 sphinx 的 `source` 目录并创建默认的配置。命令执行过程中，需要你填写一些基本的配置内容，比如是否创建单独的 `source` 和 `build` 目录、项目的名称、作者以及版本。

![使用 **sphinx-quickstart** 初始化 sphinx 配置](https://cdn-images-1.medium.com/max/2412/1*NiE2w5uY6KtD8DII_vnYmA.png)

如上所示，运行 `sphinx-build` 命令会创建 `Makefile` 和 `make.bat` 文件以及 `build` 和 `source` 目录（使用单独的 `source` 和 `build` 目录的情况，译者注）。

## 3. 更新 `conf.py` 文件

`source` 目录下的 `conf.py` 是 Sphinx 的配置文件，控制着 Sphinx 如何生成文档。如果你可以在这里重新定义主题、版本或者模块目录。以下是一些推荐的配置内容：

#### 修改主题

Sphinx 默认的主题是 [alabaster](https://alabaster.readthedocs.io/en/latest/)。你既可以从[这里](https://www.sphinx-doc.org/en/1.8/theming.html)选择心仪的主题，也可以自定义主题。推荐使用 `sphinx_rtd_theme` 的主题，不仅样式美观、具有现代感，还兼容手机视图。

你需要先安装 `sphinx_rtd_theme` 主题然后才能使用，可以通过运行 `pip install sphinx-rtd-theme` 安装，也可以手动[下载](https://pypi.org/project/sphinx-rtd-theme/#files)该主题。

在 `conf.py` 文件中更新 `html_theme` 的值：

![](https://cdn-images-1.medium.com/max/2884/1*Yy0z8_qggtEY2STcw7DIXw.png)

#### 修改版本

每次项目发布都需要更新文档的版本，使其和项目版本保持一致，你可以手动更新也可以自动实现。

![](https://cdn-images-1.medium.com/max/2724/1*cggJvzpzN1__-Om7rhwi9w.png)

#### 指定模块目录的路径

你也可以将项目的模块目录（即需要使用 sphinx 自动生成文档的代码文件所在的目录，译者注）添加到系统路径中，这样 sphinx 就能找到源文件了。配置文件中默认被注释掉的 13 ～ 15 行意在将模块目录添加到系统路径中，移除注释并修改 `sys.path.insert(0, os.path.abspath(‘.’))` 这一行，把你的模块目录添加进去。

![](https://cdn-images-1.medium.com/max/2808/1*RYT_TSZLL8haGobmqXrrUA.png)

#### 添加 autodoc 的扩展支持

`extensions` 是 Sphinx 生成文档的时候需要用到的一系列扩展。比如，你想使用 [autodoc 指令](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html)自动导入需要生成文档的模块，只需在扩展列表中添加 `sphinx.ext.autodoc` 就行了。

#### 添加扩展支持 NumPy 和 Google Doc 风格的注释

当然，这取决于你喜欢哪种格式的注释。如果代码的注释遵循了 [Google Python 风格指南](https://google.github.io/styleguide/pyguide.html)，你需要将 `sphinx.ext.napoleon` 添加到扩展列表中。

![](https://cdn-images-1.medium.com/max/2672/1*jNTzF4AbQvDwsiSY582DdA.png)

## 4. 自动生成 rst 文件

Sphinx 会根据 reStructruedText（rst）文件生成 HTML 文档。这些 rst 文件是对每个页面的描述，也可能会包含一些 autodoc 指令，并且最终会根据注释内容自动生成文档。由于可以自动生成这些文档，所以就没必要靠人工去给每个类或者模块去手写 autodoc 指令啦。

`sphinx-autodoc` 命令会根据代码生成包含 [autodoc 指令](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html) 的 rst 文件。一旦 rst 文件生成之后，只有在项目中添加了新的模块时才需要重新运行这个命令。

首先，按照前文将 `sphinx.ext.autodoc` 扩展添加到 `conf.py` 文件的扩展列表中。

要自动生成 tst 文件，只需按照下面的语法运行 `sphinx-apidoc` 命令：

`sphinx-apidoc -o \<输出目录> \<模块目录>`

在本例中，`source` 是输出目录，`python` 是模块目录，

`sphinx-apidoc -f -o source python`

运行 `sphinx-apidoc -o source python` 命令会生成 `rest.rst` 和 `modules.rst` 文件。`test.rst` 包含了生成 `test.py` 文件中的类和方法文档所需的指令，而 `modules.rst` 文件包含了在模块列表中需要包含的文件（比如 test 文件）。（类似于模块的目录，译者注）

![使用 **sphinx-apidoc** 生成 rst 文件](https://cdn-images-1.medium.com/max/2588/1*NYjOLtNGK77AAhDai5vekA.png)

```Text
test module
===========

.. automodule:: test
   :members:
   :undoc-members:
   :show-inheritance:

```

## 5. 生成 HTML

既然你已经准备好了配置文件和 rst 文件，现在我们可以运行 `make html` 命令来生成 HTML 文件了，HTML 文件将会保存在 `build/HTML` 目录中。

![使用 **make HTML** 生成 HTML](https://cdn-images-1.medium.com/max/2484/1*3h79Oyr6zuvy3efZ3kq0Jg.png)

如你所见，这里出现了一个警告“Document isn't included in any toctree was issued since we haven’t included the modules.rst file in any toctree”，将 `modules` 添加到 `index.rst` 的 `toctree` 指令下可以修复这个问题：

```Text
.. SphinxDemo documentation master file, created by
   sphinx-quickstart on Wed Jul 22 15:15:34 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to SphinxDemo's documentation!
======================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   modules



Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
```

重新生成：

![](https://cdn-images-1.medium.com/max/2468/1*W3nn6gsVP2UhBUBgrPGWkQ.png)

HTML 文件都在 `build/HTML` 目录下，我们在浏览器中打开 index.html 来一睹为快：

![index.html](https://cdn-images-1.medium.com/max/4392/1*Q3YACR12o9iy3HFzVujvGQ.png)

## 6. 高级 Shpinx 指令

还有许多其他的 Sphinx [指令](https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html) 能帮你把文档组织地更好看、更具有现代感。以下这些指令都备受好评，希望对你优化文档有帮助。以下所有的案例都是使用 `sphinx_rtd_theme` 主题生成的：

#### 目录

Sphinx 使用了传统的广为人知的 **toctree** 指令以树状结构来描述不同文件之间的关系，也就是目录。

![目录](https://cdn-images-1.medium.com/max/4396/1*Jx7OJnsEzr6azKdYihxFKA.png)

#### 提示框

可以使用 **note** 指令创建提示框。

.. note:: This is a **note** box.

![提示框](https://cdn-images-1.medium.com/max/2832/1*ziyCsuYgUZd6isrSn18DXA.png)

#### 警告框

可以使用 **warning** 指令创建警告框。

.. warning:: This is a **warning** box.

![警告框](https://cdn-images-1.medium.com/max/2844/1*lKsiVUE_OmCkc7vJutDEpw.png)

#### 图片

可以使用 **image** 指令创建图片。

```Text
.. image:: sphinx.png
    :align: center
    :width: 300px
    :alt: alternate text

```

#### 表格

可以使用 **table** 指令创建表格。

```Text
.. table::
	:align: center
	:widths: auto

	+--------------------------------------+---------------------------------+
	| .. image:: sphinx.png                |                                 |
	|     :align: center                   |                                 |
	|     :width: 300px                    |                                 |
	|     :alt: alternate text             | A description can go here       |
	+--------------------------------------+---------------------------------+

```

![表格和图片](https://cdn-images-1.medium.com/max/2176/1*cw-s-06qUEIzUnQLhwR09Q.png)

## 其他资源

* [Sphinx Documentation](https://www.sphinx-doc.org/en/master/usage/index.html)
* [ReStructuredText Guide](https://docutils.sourceforge.io/rst.html)
* [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
* [Autogenerate C++ Documentation using Sphinx, Breath, and Doxygen](https://devblogs.microsoft.com/cppblog/clear-functional-c-documentation-with-sphinx-breathe-doxygen-cmake/)

## 结束语

本文中，我们介绍了在 Python 项目中配置和使用 Sphinx 生成文档的基本内容。Sphinx 依赖 rst 文件，因此你可以在 rst 文件中自定义任何 reStructuredText 格式的内容。希望熟练使用 Sphinx 等自动化工具生成文档能够激励你书写并维护与时俱进的文档！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
