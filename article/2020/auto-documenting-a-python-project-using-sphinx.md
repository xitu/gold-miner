> * 原文地址：[Auto-Documenting a Python Project Using Sphinx](https://medium.com/better-programming/auto-documenting-a-python-project-using-sphinx-8878f9ddc6e9)
> * 原文作者：[Julie Elise](https://medium.com/@julie_elise)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/auto-documenting-a-python-project-using-sphinx.md](https://github.com/xitu/gold-miner/blob/master/article/2020/auto-documenting-a-python-project-using-sphinx.md)
> * 译者：[Herman](https://github.com/actini)
> * 校对者：

# Auto-Documenting a Python Project Using Sphinx

![Photo by [Jason Blackeye](https://unsplash.com/photos/nyL-rzwP-Mk) on [Unsplash](https://unsplash.com/photos/nyL-rzwP-Mk)](https://cdn-images-1.medium.com/max/12000/1*KOMqHlHUwgvf0RgqXUHMgA.jpeg)

While thorough documentation is necessary, it’s often put on the back burner and looked upon as a chore and a low-priority task. As a developer, it’s easy to fall back on the mindset of “why document the code when you, the author, know exactly what it’s doing?” When the code is rapidly changing, keeping the docs up to date becomes an even more substantial burden.

尽管详尽的文档非常必要，但写文档这个事儿还是经常被推迟，并且被视为是一项繁琐的、优先级不高的任务。开发人员也常常会反思“既然你对自己写的代码了如指掌，为啥还要写文档呢？”另外代码经常会改，更新文档也变成了一个繁重的负担。

Luckily, manually writing out documentation is not required due to the capabilities of [Sphinx](https://www.sphinx-doc.org/en/master/), a tool that automatically generates documentation from the docstrings in your code.

幸运的是，得益于 [Sphinx](https://www.sphinx-doc.org/en/master/) 的强大功能，我们无须再手动写文档了，Sphinx 可以从代码的注释中自动生成文档。

Below is a step-by-step guide to easily auto-generate clean and well-organized documentation from Python code using Sphinx.

接下来我们逐步学习在 Python 代码中使用 Sphinx 自动生成结构良好、形式整洁的文档。

## 1. Install Sphinx

## 1. 安装 Sphinx

Sphinx can be installed using pip by opening up the terminal and running `pip install -U Sphinx`, or by downloading the official [Python package](https://pypi.org/project/Sphinx/#files).

Sphinx 既可以通过在终端中执行 `pip install -U Sphinx` 使用 pip 安装，也可以直接从 [Python package](https://pypi.org/project/Sphinx/#files) 官网上下载。

[Here](https://www.sphinx-doc.org/en/master/usage/installation.html) is the official page outlining other ways of installing Sphinx, depending on your platform.

Sphinx 官网上简述了其他的安装方式，可以根据你的实际情况自由选择，详见[这里](https://www.sphinx-doc.org/en/master/usage/installation.html)。

## 2. Initialize the Sphinx Configuration

## 2. 初始化 Sphinx 配置

In the root directory of your project, run `sphinx-quickstart` to initialize the sphinx source directory to create a default configuration. Running this command will prompt you to fill out some basic configuration properties such as whether to create separate source and build directories, the project name, author name, and project version.

在项目根目录下运行 `sphinx-quickstart` 来初始化 sphinx 的 `source` 目录并创建默认配置。运行这个命令的时候，会提示你填写一些基本的配置属性，比如是否创建单独的 `build` 目录、项目名称、作者以及项目版本。

![Initialize the sphinx config using **sphinx-quickstart**](https://cdn-images-1.medium.com/max/2412/1*NiE2w5uY6KtD8DII_vnYmA.png)

![使用 **sphinx-quickstart** 初始化 sphinx 配置](https://cdn-images-1.medium.com/max/2412/1*NiE2w5uY6KtD8DII_vnYmA.png)

As shown above, running the `sphinx-build` command creates a `Makefile`, a `make.bat` file, as well as `build` and `source` directories.

如上所示，运行 `sphinx-build` 命令会创建 `Makefile` 和 `make.bat` 文件以及 `build` 和 `source` 目录。

## 3. Update the conf.py File

## 3. 更新 `conf.py` 文件

The `conf.py` file inside the `source` folder describes the Sphinx configuration, which controls how Sphinx builds the documentation. If you wish to override the theme, version, or module directory, you’ll need to override these changes here. Below are some recommended overrides:

在 `source` 目录下的 `conf.py` 是 Sphinx 的配置文件，控制着 Sphinx 如何生成文档。如果你想重新定义主题、版本或者模块目录，可以在这里做修改。以下是一些推荐的配置：

#### Update the theme

#### 修改主题

The default theme for sphinx is [alabaster](https://alabaster.readthedocs.io/en/latest/). There are many existing [themes](https://www.sphinx-doc.org/en/1.8/theming.html) to choose from, and it’s even possible to create your own. A recommended theme is `sphinx_rtd_theme`, which is a nice-looking, modern, mobile-friendly theme.

Sphinx 默认的主题是 [alabaster](https://alabaster.readthedocs.io/en/latest/)。你既可以从[这里](https://www.sphinx-doc.org/en/1.8/theming.html)选择心仪的主题，也可以自定义主题。推荐使用 `sphinx_rtd_theme` 的主题，不仅样式美观、具有现代感，还兼容手机视图。

To use `sphinx_rtd_theme`, you’ll need to install the sphinx-rtd-theme Python package by running `pip install sphinx-rtd-theme` in the terminal or by downloading the theme [here](https://pypi.org/project/sphinx-rtd-theme/#files).

要使用 `sphinx_rtd_theme`，你首先需要安装该主题，在命令行中运行 `pip install sphinx-rtd-theme` 或者手动[下载](https://pypi.org/project/sphinx-rtd-theme/#files)。

Update the `html_theme` variable inside the `conf.py` file to point to the desired theme name:

然后在 `conf.py` 文件中更新 `html_theme` 的值：

![](https://cdn-images-1.medium.com/max/2884/1*Yy0z8_qggtEY2STcw7DIXw.png)

#### Update the version

#### 修改版本

During each release, you’ll want to update the documentation version to point to the project release version, either manually or using an automated process.

每次项目发布的时候，你都需要更新文档的版本，使其和项目的版本保持一致，既可以手动也可以自动实现。

![](https://cdn-images-1.medium.com/max/2724/1*cggJvzpzN1__-Om7rhwi9w.png)

#### Specify the location of the Python modules

#### 指定模块目录的路径

Update the system **path** to point to the project’s modules directory so that sphinx can find the source files. Lines 13–15 will append the module directory to the system path, and are commented out by default. Uncomment these lines and update the line that reads sys.path.insert(0, os.path.abspath(‘.’)) to append the directory that contains the Python modules.

你也可以将项目的模块目录（即需要使用 sphinx 自动生成文档的代码文件所在的目录，译者注）添加到系统路径中，这样 sphinx 就能找到源文件了。默认被注释掉的 13 ～ 15 行意在将模块目录添加到系统路径中，移除注释并修改 `sys.path.insert(0, os.path.abspath(‘.’))` 这一行，把你的模块目录添加进去。

![](https://cdn-images-1.medium.com/max/2808/1*RYT_TSZLL8haGobmqXrrUA.png)

#### Add extension support for autodoc

#### 添加 actodoc 的扩展支持

The `extensions` variable is assigned to a list of extensions needed to build the documentation. For instance, if you’re planning to include documentation from your doc using the [autodoc directives](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html), you’ll need to activate it by adding `sphinx.ext.autodoc `****to the extension list.

`extensions` 属性表示了在生成文档的时候需要用到的一系列扩展。比如，你可以将 `sphinx.ext.autodoc` 添加到扩展列表中，从而可以在文档中使用 [autodoc 指令](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html)包含其他文档。

#### Add extension support for NumPy and Google Doc style docstrings

#### 添加扩展支持 NumPy 和 Google Doc 风格的注释

This, of course, is optional depending on the preferred docstring format. Should the documentation in your code follow the [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html), you’ll need to append `sphinx.ext.napoleon` to the extensions list.

当然，这取决于你喜欢哪种格式的注释。如果代码的注释遵循了 [Google Python 风格指南](https://google.github.io/styleguide/pyguide.html)的话，你需要将 `sphinx.ext.napoleon` 添加到扩展列表中。

![](https://cdn-images-1.medium.com/max/2672/1*jNTzF4AbQvDwsiSY582DdA.png)

## 4. Auto-generate the rst Files

## 4. 自动生成 rst 文件

Sphinx generates the HTML documentation from reStructuredText (rst) files. These rst files describe each webpage and may contain autodoc directives which will ultimately generate the documentation from docstrings in an automatic way. There’s an automatic way to generate these files, so there’s no need to manually write out the autodoc directives for each class and module.

Sphinx 从 reStructruedText(rst) 文件生成 HTML 文档。这些 rst 文件是对每个页面的描述，并且可能会包含一些 autodoc 指令，并且最终会根据注释内容自动生成文档。由于可以自动生成这些文档，所以就没必要靠人工去给每个类或者模块去手写 autodoc 指令啦。

The `sphinx-autodoc` command will automatically generate rst files with [autodoc directives](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html) from your code. This command only needs to be run when a new module is added to the project.

`sphinx-autodoc` 命令会根据代码生成包含 [autodoc 指令](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html) 的 rst 文件。一旦 rst 文件生成之后，只有在项目中添加了新的模块时才需要重新运行这个命令。

First, make sure that the `sphinx.ext.autodoc` extension is included in the extensions list in `conf.py` as described in the section above.

首先，按照前文将 `sphinx.ext.autodoc` 扩展添加到 `conf.py` 文件的扩展列表中。

To autogenerate the rst files, run the `sphinx-apidoc` command using the following syntax:

要自动生成 tst 文件，只需按照下面的语法运行 `sphinx-apidoc` 命令：

`sphinx-apidoc -o \<输出目录> \<模块目录>`

In our example, the output directory is `source` , and the module directory is `python`.

在本例中，`source` 是输出目录，`python` 是模块目录，

`sphinx-apidoc -f -o source python`

Running the sphinx-apidoc -o source python command will generate the rst files `test.rst`, and `modules.rst`. `test.rst` includes directives to write out the documentation for the classes and functions in `test.py`, and the `modules.rst` contains a list of which module files to include on the modules page (i.e. test).

运行 `sphinx-apidoc -o source python` 命令会生成 `rest.rst` 和 `modules.rst` 文件。`test.rst` 包含了生成 `test.py` 文件中的类和方法文档所需的指令，而 `modules.rst` 文件包含了在模块列表需要包含哪些文件（比如 test 文件）。

![Generate rst files using **sphinx-apidoc**](https://cdn-images-1.medium.com/max/2588/1*NYjOLtNGK77AAhDai5vekA.png)

![使用 **sphinx-apidoc** 生成 rst 文件](https://cdn-images-1.medium.com/max/2588/1*NYjOLtNGK77AAhDai5vekA.png)

```Text
test module
===========

.. automodule:: test
   :members:
   :undoc-members:
   :show-inheritance:

```

## 5. Build the HTML

## 5. 生成 HTML

Now that you have the configuration and rst files set up, we can now run the `make html` command from the terminal in the main directory to generate the HTML files. The HTML files will be created inside the build/HTML folder.

既然你已经准备好了配置文件和 rst 文件，现在我们可以运行 `make html` 命令来生成 HTML 文件了。HTML 文件将会保存在 `build/HTML` 目录中。

![Build HTML using **make HTML**](https://cdn-images-1.medium.com/max/2484/1*3h79Oyr6zuvy3efZ3kq0Jg.png)

![使用 **make HTML** 生成 HTML](https://cdn-images-1.medium.com/max/2484/1*3h79Oyr6zuvy3efZ3kq0Jg.png)

As you can see in this particular case, the warning Warning: "Document isn't included in any toctree was issued since we haven’t included the modules.rst file in any toctree. To fix this, add `modules` under the toctree directive in `index.rst` as shown below:

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

Run the build again:

重新生成：

![](https://cdn-images-1.medium.com/max/2468/1*W3nn6gsVP2UhBUBgrPGWkQ.png)

The HTML files were generated in the build/HTML folder. Open up index.html in the browser to view the generated docs:

HTML 文件都被生成在 `build/HTML` 目录下，在浏览器中打开 index.html 来一睹为快：

![index.html](https://cdn-images-1.medium.com/max/4392/1*Q3YACR12o9iy3HFzVujvGQ.png)

## 6. Advanced Sphinx Markup

## 6. 高级 Shpinx 指令

There are additional Sphinx [directives](https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html) that will help your documentation look and feel more modern and organized. Here are some of the top useful features that will help you further customize the documentation. All examples are generated with the `sphinx_rtd_theme`:

还有许多其他的 Sphinx [指令](https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html) 能帮你把文档组织地更好看、更具有现代感。这里列出一些备受好评的功能，希望对你优化文档有帮助。以下所有的案例都是使用 `sphinx_rtd_theme` 主题来生成的：

#### Table of contents

#### 目录

Sphinx uses a custom directive, known as the **toctree** directive, to describe the relations between different files in the form of a tree, or table of contents.

Sphinx 使用了传统的广为人知的 **toctree** 指令以树状结构来描述不同文件之间的关系，也就是目录。

![Rendered toctree example](https://cdn-images-1.medium.com/max/4396/1*Jx7OJnsEzr6azKdYihxFKA.png)

![目录](https://cdn-images-1.medium.com/max/4396/1*Jx7OJnsEzr6azKdYihxFKA.png)

#### Note box

#### 提示框

A note box can be created using the **note** directive.

可以使用 **note** 指令创建提示框。

.. note:: This is a **note** box.

![Rendered note example](https://cdn-images-1.medium.com/max/2832/1*ziyCsuYgUZd6isrSn18DXA.png)

![提示框](https://cdn-images-1.medium.com/max/2832/1*ziyCsuYgUZd6isrSn18DXA.png)

#### Warning box

#### 警告框

A warning box can be created using the **warning** directive.

可以使用 **warning** 指令创建警告框。

.. warning:: This is a **warning** box.

![Rendered warning example](https://cdn-images-1.medium.com/max/2844/1*lKsiVUE_OmCkc7vJutDEpw.png)

![警告框](https://cdn-images-1.medium.com/max/2844/1*lKsiVUE_OmCkc7vJutDEpw.png)

#### Image

#### 图片

An image can be added using the **image** directive.

可以使用 **image** 指令创建图片。

```Text
.. image:: sphinx.png
    :align: center
    :width: 300px
    :alt: alternate text

```

#### Table

#### 表格

A table can be added using the **table** directive.

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

## Resources

## 其他资源

* [Sphinx Documentation](https://www.sphinx-doc.org/en/master/usage/index.html)
* [ReStructuredText Guide](https://docutils.sourceforge.io/rst.html)
* [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
* [Autogenerate C++ Documentation using Sphinx, Breath, and Doxygen](https://devblogs.microsoft.com/cppblog/clear-functional-c-documentation-with-sphinx-breathe-doxygen-cmake/)

## Conclusion

## 结束语

In this article, we covered the basics required to configure and build Sphinx documentation for any Python project. Sphinx relies on rst files, so any kind of customization that reStructuredText can handle is possible. Being familiar with the capabilities of Sphinx and automation tools when it comes to generating documentation will hopefully encourage you to write and maintain up-to-date documentation.

本文中，

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
