> * 原文地址：[Auto-Documenting a Python Project Using Sphinx](https://medium.com/better-programming/auto-documenting-a-python-project-using-sphinx-8878f9ddc6e9)
> * 原文作者：[Julie Elise](https://medium.com/@julie_elise)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/auto-documenting-a-python-project-using-sphinx.md](https://github.com/xitu/gold-miner/blob/master/article/2020/auto-documenting-a-python-project-using-sphinx.md)
> * 译者：
> * 校对者：

# Auto-Documenting a Python Project Using Sphinx

![Photo by [Jason Blackeye](https://unsplash.com/photos/nyL-rzwP-Mk) on [Unsplash](https://unsplash.com/photos/nyL-rzwP-Mk)](https://cdn-images-1.medium.com/max/12000/1*KOMqHlHUwgvf0RgqXUHMgA.jpeg)

While thorough documentation is necessary, it’s often put on the back burner and looked upon as a chore and a low-priority task. As a developer, it’s easy to fall back on the mindset of “why document the code when you, the author, know exactly what it’s doing?” When the code is rapidly changing, keeping the docs up to date becomes an even more substantial burden.

Luckily, manually writing out documentation is not required due to the capabilities of [Sphinx](https://www.sphinx-doc.org/en/master/), a tool that automatically generates documentation from the docstrings in your code.

Below is a step-by-step guide to easily auto-generate clean and well-organized documentation from Python code using Sphinx.

## 1. Install Sphinx

Sphinx can be installed using pip by opening up the terminal and running `pip install -U Sphinx`, or by downloading the official [Python package](https://pypi.org/project/Sphinx/#files).

[Here](https://www.sphinx-doc.org/en/master/usage/installation.html) is the official page outlining other ways of installing Sphinx, depending on your platform.

## 2. Initialize the Sphinx Configuration

In the root directory of your project, run `sphinx-quickstart` to initialize the sphinx source directory to create a default configuration. Running this command will prompt you to fill out some basic configuration properties such as whether to create separate source and build directories, the project name, author name, and project version.

![Initialize the sphinx config using **sphinx-quickstart**](https://cdn-images-1.medium.com/max/2412/1*NiE2w5uY6KtD8DII_vnYmA.png)

As shown above, running the `sphinx-build` command creates a `Makefile`, a `make.bat` file, as well as `build` and `source` directories.

## 3. Update the conf.py File

The `conf.py` file inside the `source` folder describes the Sphinx configuration, which controls how Sphinx builds the documentation. If you wish to override the theme, version, or module directory, you’ll need to override these changes here. Below are some recommended overrides:

#### Update the theme

The default theme for sphinx is [alabaster](https://alabaster.readthedocs.io/en/latest/). There are many existing [themes](https://www.sphinx-doc.org/en/1.8/theming.html) to choose from, and it’s even possible to create your own. A recommended theme is `sphinx_rtd_theme`, which is a nice-looking, modern, mobile-friendly theme.

To use `sphinx_rtd_theme`, you’ll need to install the sphinx-rtd-theme Python package by running `pip install sphinx-rtd-theme` in the terminal or by downloading the theme [here](https://pypi.org/project/sphinx-rtd-theme/#files).

Update the `html_theme` variable inside the `conf.py` file to point to the desired theme name:

![](https://cdn-images-1.medium.com/max/2884/1*Yy0z8_qggtEY2STcw7DIXw.png)

#### Update the version

During each release, you’ll want to update the documentation version to point to the project release version, either manually or using an automated process.

![](https://cdn-images-1.medium.com/max/2724/1*cggJvzpzN1__-Om7rhwi9w.png)

#### Specify the location of the Python modules

Update the system **path** to point to the project’s modules directory so that sphinx can find the source files. Lines 13–15 will append the module directory to the system path, and are commented out by default. Uncomment these lines and update the line that reads sys.path.insert(0, os.path.abspath(‘.’)) to append the directory that contains the Python modules.

![](https://cdn-images-1.medium.com/max/2808/1*RYT_TSZLL8haGobmqXrrUA.png)

#### Add extension support for autodoc

The `extensions` variable is assigned to a list of extensions needed to build the documentation. For instance, if you’re planning to include documentation from your doc using the [autodoc directives](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html), you’ll need to activate it by adding `sphinx.ext.autodoc `****to the extension list.

#### Add extension support for NumPy and Google Doc style docstrings

This, of course, is optional depending on the preferred docstring format. Should the documentation in your code follow the [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html), you’ll need to append `sphinx.ext.napoleon` to the extensions list.

![](https://cdn-images-1.medium.com/max/2672/1*jNTzF4AbQvDwsiSY582DdA.png)

## 4. Auto-generate the rst Files

Sphinx generates the HTML documentation from reStructuredText (rst) files. These rst files describe each webpage and may contain autodoc directives which will ultimately generate the documentation from docstrings in an automatic way. There’s an automatic way to generate these files, so there’s no need to manually write out the autodoc directives for each class and module.

The `sphinx-autodoc` command will automatically generate rst files with [autodoc directives](https://www.sphinx-doc.org/en/master/usage/extensions/autodoc.html) from your code. This command only needs to be run when a new module is added to the project.

First, make sure that the `sphinx.ext.autodoc` extension is included in the extensions list in `conf.py` as described in the section above.

To autogenerate the rst files, run the `sphinx-apidoc` command using the following syntax:

sphinx-apidoc -o \<OUTPUT_PATH> \<MODULE_PATH>

In our example, the output directory is `source` , and the module directory is `python`.

sphinx-apidoc -f -o source python

Running the sphinx-apidoc -o source python command will generate the rst files `test.rst`, and `modules.rst`. `test.rst` includes directives to write out the documentation for the classes and functions in `test.py`, and the `modules.rst` contains a list of which module files to include on the modules page (i.e. test).

![Generate rst files using **sphinx-apidoc**](https://cdn-images-1.medium.com/max/2588/1*NYjOLtNGK77AAhDai5vekA.png)

```Text
test module
===========

.. automodule:: test
   :members:
   :undoc-members:
   :show-inheritance:

```

## 5. Build the HTML

Now that you have the configuration and rst files set up, we can now run the `make html` command from the terminal in the main directory to generate the HTML files. The HTML files will be created inside the build/HTML folder.

![Build HTML using **make HTML**](https://cdn-images-1.medium.com/max/2484/1*3h79Oyr6zuvy3efZ3kq0Jg.png)

As you can see in this particular case, the warning Warning: "Document isn't included in any toctree was issued since we haven’t included the modules.rst file in any toctree. To fix this, add `modules` under the toctree directive in `index.rst` as shown below:

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

![](https://cdn-images-1.medium.com/max/2468/1*W3nn6gsVP2UhBUBgrPGWkQ.png)

The HTML files were generated in the build/HTML folder. Open up index.html in the browser to view the generated docs:

![index.html](https://cdn-images-1.medium.com/max/4392/1*Q3YACR12o9iy3HFzVujvGQ.png)

## 6. Advanced Sphinx Markup

There are additional Sphinx [directives](https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html) that will help your documentation look and feel more modern and organized. Here are some of the top useful features that will help you further customize the documentation. All examples are generated with the `sphinx_rtd_theme`:

#### Table of contents

Sphinx uses a custom directive, known as the **toctree** directive, to describe the relations between different files in the form of a tree, or table of contents.

![Rendered toctree example](https://cdn-images-1.medium.com/max/4396/1*Jx7OJnsEzr6azKdYihxFKA.png)

#### Note box

A note box can be created using the **note** directive.

.. note:: This is a **note** box.

![Rendered note example](https://cdn-images-1.medium.com/max/2832/1*ziyCsuYgUZd6isrSn18DXA.png)

#### Warning box

A warning box can be created using the **warning** directive.

.. warning:: This is a **warning** box.

![Rendered warning example](https://cdn-images-1.medium.com/max/2844/1*lKsiVUE_OmCkc7vJutDEpw.png)

#### Image

An image can be added using the **image** directive.

```Text
.. image:: sphinx.png
    :align: center
    :width: 300px
    :alt: alternate text

```

#### Table

A table can be added using the **table** directive.

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

![Rendered table example with an embedded image](https://cdn-images-1.medium.com/max/2176/1*cw-s-06qUEIzUnQLhwR09Q.png)

## Resources

* [Sphinx Documentation](https://www.sphinx-doc.org/en/master/usage/index.html)
* [ReStructuredText Guide](https://docutils.sourceforge.io/rst.html)
* [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
* [Autogenerate C++ Documentation using Sphinx, Breath, and Doxygen](https://devblogs.microsoft.com/cppblog/clear-functional-c-documentation-with-sphinx-breathe-doxygen-cmake/)

## Conclusion

In this article, we covered the basics required to configure and build Sphinx documentation for any Python project. Sphinx relies on rst files, so any kind of customization that reStructuredText can handle is possible. Being familiar with the capabilities of Sphinx and automation tools when it comes to generating documentation will hopefully encourage you to write and maintain up-to-date documentation.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
