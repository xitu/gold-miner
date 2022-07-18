> * 原文地址：[How to package and deploy CLI applications with Python PyPA setuptools build](https://pybit.es/articles/how-to-package-and-deploy-cli-apps/)
> * 原文作者：[yaythomas](https://pybit.es/author/thomasgaigher/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-package-and-deploy-cli-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-package-and-deploy-cli-apps.md)
> * 译者：
> * 校对者：

# How to package and deploy CLI applications with Python PyPA setuptools build

This article covers how to package your Python code as a CLI application using just the official [PyPA](https://www.pypa.io) provided tools, without installing additional external dependencies.

If you prefer reading code to reading words, you can find the full example demo code discussed in this article here: [example repo of Python CLI packaged with PyPA setuptools build](https://github.com/yaythomas/python-cli-pypa-build-example)

## Run your Python code from the command line

### Run a Python file as a script

Since Python is a scripting language, you can easily run your Python code from the CLI with the Python interpreter, like this:

```python
# run a python source file as a script
$ python mycode.py

# run a python module
$ python -m mycode
```

### Create a CLI shortcut to bootstrap your Python application

If you want to run your Python script as a CLI application with a user-friendly name and not have to type in the Python interpreter & path in front of it, you could of course just create an executable shortcut file in your `/bin` directory like this:

```bash
#!/bin/sh

python3 /path/to/mycode.py "$@"
```

💡 The `"$@"` passes all the CLI arguments from your shortcut launcher to your Python script.

But this is not all that useful when you actually want to distribute your code, because you’d still have to create & permission this executable file on all your end-users’ machines somehow, in addition to provisioning the actual Python dependencies and your app itself.

Thankfully, Python has great well-tested & widely used built-in mechanisms for doing exactly this for you – so no, you don’t even need to jerry-rig your own shortcut like this at all!

## How to package your Python code as a CLI application the proper way

The standard way to package your Python code is to use [setuptools](https://setuptools.readthedocs.io/). You use **setuptools** to create distributions that you can install with [pip](https://pip.pypa.io/).

**setuptools** has been around for ages, and is currently (August 2021) in a bit of a transitional phase. This has been the case for a few years. This means that there are different ways of achieving the same thing using this tool-set, as the new and improved ways slowly have been supplanting the old:

* **setup.py** – the old way
* **setup.cfg** – the sort-of newer
* **pyproject.toml** (aka PEP 517 & PEP 518) – shiny & new

The key to creating your own CLI application is to specify an [entry_point](https://setuptools.readthedocs.io/en/latest/userguide/entry_point.html) in either your **setup.cfg** or **setup.py** file.

The **pyproject.toml** specification does define this property (as `[project.scripts]`), but the standard PyPA build has not yet implemented actually doing anything with this property yet.

## Should you use setup.cfg, setup.py or pyproject.toml to configure Python packaging?

The short answer is: for the moment, you probably should have all three.

Now for the longer answer. You don’t **necessarily** have to have all three, but if you don’t you need to be sure you know exactly what you’re doing and why, otherwise you’re setting yourself up for mysterious errors down the line. If you’re not interested in the evolution & background of these mechanisms, feel free to skip to the next section.

### In the beginning was setup.py

**setup.py** is the older, traditional way of packaging Python projects. Since **setup.py** is literally a Python script in itself, it is very powerful because you can script whatever advanced installation functionality you want as part of the install.

But just because you **can**, doesn’t mean you **should**. The more unusual scripting you do as part of your install, the more your install becomes brittle & unpredictable on diverse client machines where you don’t necessarily have strict control over the state & configuration of those machines.

### Evolution to setup.cfg

By comparison, **setup.cfg** is a config file, not an installation script like **setup.py**. **setup.cfg** is static, **setup.py** is dynamic.

**setup.cfg** lets you specify declarative config – meaning that you can define your project meta-data without having to worry about scripting. This is a good thing because you avoid having to run arbitrary code during installs, which will make your security & ops teams happy, and you don’t have to maintain boilerplate code in your source. Bonus!

Although it has been there alongside **setup.py** since the beginning, **setup.cfg** has taken more of a central role over the years. You can more or less accomplish the same thing with either, so from this perspective it doesn’t really matter which you use.

However, even if you do ALL your configuration in **setup.cfg** you do still need a stub **setup.py** file **unless** you are running a PEP517 build. We’ll discuss this new build system in the next section.

### Enter pyproject.toml

**pyproject.toml** is the official, anointed successor to **setup.py** and **setup.cfg**, but it has not reached feature parity with its predecessors yet. This new file format has come as a result of the [PEP517 build specification](https://www.python.org/dev/peps/pep-0517/).

One of the notable features of the new Python build mechanisms specified in PEP517 is that you don’t **have** to use the **setuptools** build system – other build & packaging tools like [Poetry](https://python-poetry.org) and [Flit](https://flit.readthedocs.io/) can use the same **pyproject.toml** specification file (PEP621) to package python projects.

Eventually all these tools **should** be using the exact same **pyproject.toml** file format, but be aware that historically build tools other than **setuptools** have had their own ways of specifying CLI entry-points, so be sure to check the documentation for whichever tool you end up using to double-check that it’s conforming to the latest PEP621 standard. Here, we are just going to focus on how to do this with **setuptools**.

While the latest version of the **pyproject.toml** specification did add definitions for project meta-data that you will usually find in **setup.cfg** and/or **setup.py**, the **setuptools** build tool does NOT yet support using the meta-data from **pyproject.toml**. Other PEP517 compliant tools like Flit & Poetry do support projects with **only** a **pyproject.toml** file, so if you use those you don’t need **setup.py** and/or **setup.cfg**.

You can find the [full file format specification for pyproject.toml in PEP621](https://www.python.org/dev/peps/pep-0621/).

For all the gory details & progress of implementing full support for **pyproject.toml** metadata in **setuptools**, you can track the discussion here: [https://github.com/pypa/setuptools/issues/1688](https://github.com/pypa/setuptools/issues/1688)

### Recommended Python packaging setup in 2021

If you are using PyPA’s **setuptools** during this transitional phase of Python packaging, while you can get away with using one or the other combination of **setup.py**, **setup.cfg** & **pyproject.toml** to specify your meta-data and build attributes, you probably want to cover your bases and avoid subtle problems by having all 3 as follows:

1. have a minimal **pyproject.toml** to specify the build system
2. put all project related config in **setup.cfg**
3. have a simple shim **setup.py**

By “subtle problems” I mean inconsistencies like editable installs not working or builds that look like they’re working but they’re not actually using the meta-data you thought you specified (which you might only discover at deployment, urk!). So let’s avoid the unpleasantness!

In this setup, since **pyproject.toml** and **setup.py** are only minimalist shims, your individual project related configuration is only contained in the one place in **setup.cfg**. Therefore you’re not needlessly duplicating values between different files.

## Create CLI entry point configuration for your Python project

### Sample project structure

Let’s work through an example of a simple CLI application.

The project structure looks like this:

```
.
│ my-repo/
	│- mypackage/
		│- mymodule.py
	│- pyproject.toml
	│- setup.cfg
	│- setup.py
```

### mypackage/mymodule.py

This is just some arbitrary code that we want to call directly from the CLI:

```python
def my_function():
    print('hello from my_function')


def another_function():
    print('hello from another_function')


if __name__ == "__main__":
    """This runs when you execute '$ python3 mypackage/mymodule.py'"""
    my_function()
```

### setup.py

To allow editable installs (useful for your local dev machine) you need a shim **setup.py** file.

All you need in this file is this bit of boilerplate:

```python
from setuptools import setup

setup()
```

💡 You could actually skip the **setup.cfg** file and set your properties in `setup()` itself in **setup.py**, but this will make your migration harder in the future when the new PEP517 build system, like a death-star, is fully operational. I mention this because you’ll see a lot of examples on [Stack Overflow](https://stackoverflow.com) & friends that go this way – it is not wrong, per se, but be aware that it is the older way of doing things.

An old-style **setup.py** file would look something like this:

```python
from setuptools import setup

setup(
	name='mypackage',
	version='0.0.1',
    # To provide executable scripts, use entry points in preference to the
    # "scripts" keyword. Entry points provide cross-platform support and allow
    # pip to create the appropriate form of executable for the target platform.
    entry_points={
        'console_scripts': [
            'myapplication=mypackage.mymodule:my_function'
        ]
    },
)
```

### setup.cfg

The **setup.cfg** file is where the real magic happens. This is where you set your project-specific properties.

```
[metadata]
name = mypackage
version = 0.0.1

[options]
packages = mypackage

[options.entry_points]
console_scripts =
    my-application = mypackage.mymodule:my_function
    another-application = mypackage.mymodule:another_function
```

* **name**
    * The build system uses this value to generate the build output files.
    * If you do not specify this, your output filename will have “UNKNOWN” instead of a more user-friendly name.
* **version**
    * The build system uses this value to add a version number to your output files.
    * If you do not specify this, your output filename will contain “0.0.0”.
* **packages**
    * Use this property to tell the build system which packages to build.
    * This is a list, so you can specify more than one package.
    * If you’re not sure what a “package” is in Python, just think of it as the name of the directory your code lives in.
    * ❗If you do not specify this, your build output will not actually contain your code. If you forget to specify this, your package & deploy will look like it’s working, but it won’t actually package the code you want to run and it will not actually deploy correctly.
* **console_scripts**
    * This property tells the build system to create a shortcut CLI wrapper script to run a Python function.
    * This is a list, so you can create more than one CLI application from the same code-base.
    * In this example, we are creating two CLI shortcuts:
        * **my-application**, which calls **my_function** in **mypackage/mymodule.py**.
        * **another-application**, which calls **another_function** in **mypackage/mymodule.py**.
    * The syntax for an entry is: **<name> = \[\<package\>.\[\<subpackage\>.\]\]\<module\>\[:\<object\>.\<object\>\]**.
    * The name on the left will become the name of your CLI application. This is what an end-user will type in the CLI to invoke your application.
    * If you do not specify this property, your build will not create any CLI shortcuts for your code.
    * ❗Remember that you have to include the root package of the code you reference here under `options.packages`, otherwise the build tool will not actually package the code you’re referencing here!

There are many more meta-data properties that you can (and maybe should!) specify in **setup.cfg** – here is a [more comprehensive setup.cfg example](https://setuptools.readthedocs.io/en/latest/userguide/declarative_config.html). Given here instead is the bare minimum for a tidy build & packaging experience.

💡 Of the additional unlisted properties, of especial interest is **install_requires**, with which you specify dependencies – in other words, any external packages that your code depends on and that you want the installer to install alongside your application.

```
[options]
install_requires =
    requests
    importlib; python_version == "2.6"
```

### pyproject.toml

All you need in your minimalist **pyproject.toml** file is:

```
[build-system]
build-backend = "setuptools.build_meta"
requires = ["setuptools", "wheel"]
```

💡 In the **pyproject.toml** specification, `project.scripts` is the equivalent to `console_scripts` in **setup.py** and **setup.cfg**. However, at present this functionality is not implemented yet by the **setuptools** build system.

## Use python -m build to create a python distribution

**build**, aka PyPA build, is the more modern PEP517 equivalent of the older `setup.py sdist bdist_wheel` build command with which you might be familiar.

If you’ve not done this before, you can install the build tool like this:

```bash
$ pip install build
```

Now, in the root of your project directory, you can run:

```bash
$ python -m build
```

This will result in two output files in the `dist` directory:

* dist/mypackage-0.0.1.tar.gz
* dist/mypackage-0.0.1-py3-none-any.whl

The tool will create the **./dist** directory for you if it doesn’t exist already.

What this command does is to create a source distribution tarball (the **tar.gz** file), and then also create a wheel from that source distribution. A wheel (**.whl**) is a versioned distribution format that deploys faster because during installation you can skip the build step necessary for source distributions, and there are better caching mechanisms for it.

The output filenames you see here follow a defined format that you can find specified in the [PEP427 wheel file name convention](https://www.python.org/dev/peps/pep-0427/#file-name-convention).

You’ll notice that the build tool uses **name** and **version** from **setup.cfg** to generate these filenames – which is why, even though you strictly speaking don’t **need** to specify these properties, they are useful if you want nicely named & easily identifiable outputs.

## Install your wheel with pip

You can use [pip](https://pip.pypa.io/) to install the distribution you just created. (I’m sure **pip** doesn’t need any introduction to any Pythonista…)

```bash
$ pip install dist/mypackage-0.0.1-py3-none-any.whl
```

### How PyPA build creates CLI shortcuts

The pip install command will install your package and create the CLI shortcuts (the ones you specified in **setup.cfg**) in the current Python environment’s `bin` directory.

* {Python Path}/bin/my-application
* {Python Path}/bin/another-application

Under the hood, these shortcut files are actually just a more sophisticated version of the quick-and-dirty bash file we created in the beginning. The auto-generated **my-application** shortcut file in the `bin/` directory looks like this:

```python
#!/bin/python3
# -*- coding: utf-8 -*-
import re
import sys
from mypackage.mymodule import my_function
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(my_function())
```

### Testing your install in a clean environment

💡If you want to test whether your shiny new package is installable, create a fresh new virtual environment and install your package into it so that you can test it in isolation.

```bash
# create virtual environment
$ python3 -m venv .env/fresh-install-test

# activate your virtual environment
$ . .env/fresh-install-test/bin/activate

# install your package into this fresh environment
$ pip install dist/mypackage-0.0.0-py3-none-any.whl

# your shortcuts are now in the venv bin directory
$ ls .env/fresh-install-test/bin/
my-application
another-application

# so you can run it directly from the cli
$ my-application
hello from my_function

# and run the second application
$ another-application
hello from another_function
```

## Publishing & distributing your Python package

Publishing means **how** you make your Python package available to your end-users.

How you publish your package depends on your deployment plan for your specific requirements. A full discussion of these is beyond the scope of this article, but just to get you started, some of the options are:

* You can publish to and [use pip to install from a private git repository](https://pip.pypa.io/en/stable/topics/vcs-support/).
* You can create your own [private Python repository manager](https://packaging.python.org/guides/hosting-your-own-index/).
* You could just use **pip** to install the **whl** or **sdist** from a file-share in your organization.
* If you are planning to release your application publicly to the official [PyPI](https://pypi.org) repository, you can use [twine](https://twine.readthedocs.io/) to upload the distribution to PyPi.
    * Be aware that you very probably should be a lot more detailed in filling in your project’s meta-data than the deliberately bare-bones minimal example given here if you are planning to create a public package.
* Whereas **pip** installs to whichever Python environment is active at the time, this can get messy on end-user machines that you do not control – for example, shared dependencies can clash with other applications’ requirements.
    * If you want to install your application into an isolated environment, purposely separate just for your app with the dependencies for your app isolated from and not polluting the main system-wide Python installation, you can use [pipx](https://pypa.github.io/pipx) to install from a git repo (such as a private repo in your organization) or even just a file-path.
* You can email your wheels around as attachments and tell people to install. Just kidding, just kidding! Don’t do this – just because it’s been known to happen doesn’t make it **right**. . .

## How to structure a Python CLI project

For the sake of clarity, this example just directly calls a simple Python function from the CLI. Your code is very likely to be more involved.

How best to structure your code in any given application is, of course, a very. . . debatable. . . topic 😬. So instead of making bold claims about what is “best”, lets instead just look at what a typical tidy structure might look like… which is to say, while this is a relatively common way of doing things, it’s not necessarily THE way.

```
.
│ my-repo/
  │- mypackage/
    │- mynamespace/
      │- anothermodule.py
    │- anothernamespace/
      │- arbmodule.py
    │- mymodule.py
    │- cli.py
    │- pyproject.toml
    │- setup.cfg
    │- setup.py
```

If you create your entry-point function as `def main()` in **cli.py** then your **setup.cfg** file **entry_points** configuration simply becomes:

```
[options.entry_points]
console_scripts =
    my-application = mypackage.cli:main
```

You can think of your functional code as a library, and the CLI is effectively a client or consumer of that library. Break your code into namespaces and modules that make sense for you – you can group together code by functional area, or by dependency, or by object, or by whatever categorization scheme works for you.

If you think of the CLI as a consumer of your library’s API, it makes sense to encapsulate the code specific to CLI handling in its own module. You can name this what you like, but **cli.py** does have the benefit of being snappy. In this module you will very probably import something like [argparse](https://docs.python.org/3/library/argparse.html), to parse your CLI input arguments, print out errors when someone invokes your CLI with the wrong arguments, assign defaults and generate help & usage messages.

Here is a real-life example of a large project structured like this, with a [CLI handling module](https://github.com/pypyr/pypyr/blob/master/pypyr/cli.py) that encapsulates all CLI functionality and invokes the underlying program being called like you would an API.

## Alternative packaging tools in Python

In this article we just focused on using the “official” minimalist way of packaging & building your Python projects. But there are other 3rd party options out there that provide some extra functionality over and above what the vanilla setuptools **build** tool does.

We’ve already mentioned PEP517 compliant build tools **poetry** and **flit**. With these, as with the standard PyPA **build**, the end-user has to have an active Python run-time on their machine. Your code installs into that Python environment.

Whereas other utilities follow a completely different approach by creating a single file executable of your application and its Python dependencies – these 3rd party utilities create a standalone platform-native executable of your app for you. This means that the end-user does not even need to have a Python distribution on their machine – they can just run your executable file by itself.

In no particular order, some free tools in this space are:

* [PyInstaller](https://www.pyinstaller.org)
* [p2exe](https://www.py2exe.org)
* [bbFreeze](https://github.com/schmir/bbfreeze) (unmaintained)
* [cx_Freeze](https://cx-freeze.readthedocs.io/)
* [Briefcase](https://beeware.org/project/projects/tools/briefcase/)
* [Nuitka](https://nuitka.net)
* [py2app](https://py2app.readthedocs.io/) (Mac-only)
* [PyOxidizer](https://pyoxidizer.readthedocs.io)

Each of these has its own way of specifying which function to call from the CLI, so if you do want to go in this direction, be sure to check the documentation for your chosen tool.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
