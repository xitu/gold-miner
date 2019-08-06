> * 原文地址：[Current State of Python Packaging - 2019](https://stefanoborini.com/current-status-of-python-packaging/)
> * 原文作者：[Stefano Borini](https://stefanoborini.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/current-status-of-python-packaging.md](https://github.com/xitu/gold-miner/blob/master/TODO1/current-status-of-python-packaging.md)
> * 译者：
> * 校对者：

# Current State of Python Packaging - 2019

In this post, I will try to explain the intricate details of python packaging. I spent the best part of my evenings in the past two months to gather as much information as possible about the problem, the current solutions, what is legacy and what is not.

The first source of confusion is the ambiguity surrounding terminology in python. In programming circles, the meaning of the word “package” means an installable component (a library for example). Not so in python, where the term for the same concept is “distribution”. However, nobody really uses the term “distribution” except when they do (typically in official documentation and Python Enhancement Proposals). Incidentally, the term is a bad choice because “distribution” is generally used for a brand of Linux.

This is a warning that you should keep in mind, because python packaging is not really about python **packages**. It’s about python **distributions** (python distributioning? whatever) but I’ll keep calling it packaging.

**I don’t have time to read. Can you give me the short version? What should I do as of today in 2019 to manage python packages?**

I assume you are a programmer and wants to start developing a python package:

* Create your development environment with [Poetry](https://poetry.eustace.io/), specifying the direct dependencies of your project with a strict version. This way you ensure your development (and testing) environment is always reproducible.
* Create a pyproject.toml and use poetry as a backend to create your source and binary distributions.
* Now it’s time to specify your abstract package dependencies. Specify them with a minimum version that you know your package can work with. This way you ensure you don’t create needless version conflicts with other packages.

If you really want to work the old way with setuptools:

* Create a setup.py where you specify all your abstract dependencies with the minimum version your package is working with in `install_requires`.
* Create a `requirements.txt` where you specify your strict, concrete (i.e. specifically versioned), direct dependencies. You will use this file to generate your actual working environment.
* Create a virtual environment with `python -m venv`, activate the environment and then install the dependencies with `pip install -rrequirements.txt` in that environment. Use this environment to develop.
* if you need dependencies for testing (very likely), create a `dev-requirements.txt` and install those too.
* If you really want to lock your total environment (recommended) do `pip freeze >requirements-freeze.txt` and use this to create the environmment from now on.

**I have time. Explain me the problem please.**

The problems. Plural.

Suppose we want to create a python “thing”: maybe it’s a standalone program, maybe a library. The development and usage of this thing involves the following “actors”:

* **Developer**: the person or persons who write the thing.
* **CI**: an automated process that runs tests on the thing.
* **Build**: an automated or semi-automated process to go from the thing on our git to the thing someone else can install and use.
* **Enduser**: the final person or persons that use the thing. They may be other developers, if the thing is a library, or they might be the general public, if it’s an application. Or a cloud computing microservice, if the thing is a web service of some sort. You get the point.

The goal is to make all these people and machines happy, because each of them has different workflows and needs, and these needs overlap somehow. To add to this, there is the problem that things change, new releases are made, old releases are declared obsolete, and almost all code relies on other code to perform its task. There are always dependencies, these dependencies change with time, may or may not be required, may run quite deep and have to consider that code may be non portable between operating systems, or even inside the same operating system. It’s complicated.

And it gets worse, because your direct dependencies have in turn their own set of dependencies. What if your package depends on A and B directly, and they both depend on C? Which version of C should you install? Is it even possible to do so, if, say, A wants C strictly version 2 and B wants C strictly version 1?

To organise this mess somehow, the devised approach is to package code so that it can be reused, installed, versioned and given some metainformation that describes, for example, “this has been compiled on windows 64 bits” or “this will only work on macos”, or “this needs that package of this version or above to work”.

**Ok, now I know the problem. What’s the solution?**

A first step is to define a shippable entity that aggregates a given release of a given software. This shippable entity is what we call here a **package** (distribution in python-speak). You can ship it in two forms:

* **source**: you take the source code, put it in a zip or tar.gz, and who gets it has to compile it by himself.
* **binary**: you compile the code, publish the compiled stuff, and who gets it uses it directly with no additional fuss.

Both may be useful, and it’s generally a good idea to provide both. Of course with the need of packaging come the need for tools to do it properly specifically for the following tasks:

* create the shippable package (what I called **build** above)
* publish the package somewhere so that it can be obtained by others
* download and install a package
* handle dependencies. What if package A needs package B to run? What if package A may or may not need package B to run depending on what and how you are using A for. What if A needs package B only if installed on windows?
* define a runtime. As said earlier, in general a piece of software needs a bunch of dependencies to run, and these dependencies are better separated from the needs of another software. This is true both when you develop and when you run it.

**Can you be more specific? What do I have to do when I want to write some code?**

Sure. You want to write some code. So you generally follow these steps:

1. You create an isolated python environment that is independent of your system python. This way you can work on multiple projects. If you don’t, the stuff for project A might mess up the stuff from project B.
2. You want to specify which dependencies you want, but keep into account that there are two ways of doing so: **abstract** where you just say what you want in general terms (e.g. numpy) and **concrete**, where you say which specific version you want (e.g. numpy 1.1.0). Why the difference? I’ll detail later. To create a real, working environment you need concrete dependencies.
3. Now you have what you need and you can start developing.

**Which tools do I have to use to do this?**

This is tricky, because there are many and they are changing. One option is that you create the isolated python “virtual environment” with **venv**, which is part of python. Then, you use **pip** (also part of python) to install the packages that you depend on. Typing them one by one is boring so people put the concrete dependencies (with hardcoded versions) in a file and then tell pip: “go read that file and install what’s in there”. And pip obliges. This file is the famous requirements.txt you might have seen around.

**Ok, what is pip exactly?**

A program that downloads packages and installs them. If they in turn have dependencies, it installs these sub-dependencies too.

**How?**

It goes to a remote service, pypi, finds the package by name and version, downloads it, and installs it. If it’s binary, it just installs it. If it’s source, it compiles it, then installs it. But it does a little more than that, because this package may have additional dependencies itself, so it gets those too, and installs them.

**Why do you say that this approach with requirements.txt is an “option”?**

Because it gets boring and complex quite quickly. You have to manage by hand your direct dependencies versions for different platforms. For example, on windows you might need a package, and on linux another and you end up with win-requirements.txt, linux-requirements.txt etc.

You also have to consider that some of your dependencies are real dependencies that you use and need for your software to work. Other dependencies are only required to run tests, and so are really dependencies that as a developer, or a CI machine, needs, but for someone that wants to use your software, they are not needed, so they are not dependencies. So now you have dev-requirements.txt as well.

Then you have the problem that requirements.txt may only specify direct dependencies, but in practice you want to specify **everything** is needed to create your environment reliably. Why? What if you install direct dependency A which has a subdependency C which is currently at version 1.1. But one day C releases a new version 1.2, and from this moment on, when you create your environment, pip will download C version 1.2, which might have a bug. Suddenly your tests start failing, and you don’t know why.

So you think you might want to specify both dependencies and their sub-dependencies in requirements.txt. But now you can’t distinguish them anymore in the file, and if you want to bump up one of your dependencies, maybe because it has a bug, now you have to find out which one are its own subdependencies in that file, and …

You get the point. It’s a mess, and you don’t want to deal with this mess.

Then you have the problem that pip decides which versions to install in a rather primitive way, and can eventually paint itself into a corner and give you either a broken environment or an error. Remember the case where two packages A and B share a subdependency C. So you need a more complex process, and basically use pip to just download well-defined versions, and leave the task of deciding which versions to install to something else that has a higher-level picture and can make smarter decisions because of it.

**For example?**

pipenv is one. It puts together venv, pip and some magic so that you give a list of direct dependencies and it tries its best to resolve the mess above and give you an environment that works. Poetry is another. People talk about the two and there’s some feud going on because of political and human reason. Most people seem to prefer Poetry.

Some companies, such as Continuum and Enthought, have their own version (conda and edm) which are generally one step above for some additional platform complexities. We don’t go into that detail here. Suffice to say that if you are going to use a lot of dependencies that are compiled and/or depend on compiled libraries, a scenario that is highly common with scientific computing, you are better off using their system to manage your environment, because they took care of solving a lot of headaches for you. It’s their business.

**Which one is better? pipenv or Poetry?**

As I said, people seem to prefer Poetry. I personally tried both, and to me Poetry seems to be a better, more encompassing and polished solution.

**Ok so the bottom line is to use Poetry, that creates an environment so that I can install my dependencies in an environment and then code.**

Well yes. But we haven’t even started talking about building yet. That is, once you have your code, how do you create something you can release?

**Right, is that what setup.py, setuptools and distutils are about?**

Yes and no. Originally, when you wanted to create source or binary distributions you used a standard lib module called distutils. The idea was to have a python script, called setup.py, that did its magic to create something you could give to others. The script could have been named anything else, but kind of became the standard and some tools (notably pip) specifically look for it. For example, if pip can’t find a built version of the dependency you need, it will download the source and build it, basically running setup.py and hoping for the best.

However… distutils stinks, so someone came up with alternatives that do a lot more stuff that distutils didn’t do. Big fight, big mess, long story short setuptools is better, everybody uses it. setuptools keeps using setup.py to give the illusion that nothing has changed and the process to create your stuff is still the same.

**Why hoping for the best?**

Because pip has no guarantee that when it runs setup.py to build the package it can actually run. It’s a python script and may have some dependencies in itself that you have no way of specifying or retrieving. It’s a chicken and egg problem.

**but there’s a setup_requires option in setuptools.setup()**

That option is deeply flawed and you don’t solve the problem in any case. It’s still a chicken and egg problem. PEP 518 talks in detail about it and the final conclusion is that it’s just broken. So don’t use it.

**So setuptools and setup.py is or isn’t the way to go when I need to build my stuff for release??**

It used to be. Not anymore, or maybe yes. It depends. See, the current situation is that nobody wants setuptools to be the only one able to decide how packages are made. The reason is deeper than that, and there are technicalities involved that go too deep, but if you are curious take a look at PEP 518. The most egregious is the one I gave above: if pip wants to build a dependency it downloaded, how does it know what to download to even start executing the setup script? Yes, it can assume it needs setuptools, but it’s just an assumption. And you don’t necessarily have setuptools in your environment, so how does pip know that it’s needed to build this package or that package? And more in general, why would it have to use setuptools at all, instead of something else?

In any case, they decided that anybody that want to write their own tool to package should be able to do so, and therefore you need just another meta step to define which packaging system to use and which dependencies you need in order to build your stuff.

**pyproject.toml?**

Exactly. More specifically, a subsection in it that defines the “backend” you want to use to build a package. If you want to use a different build backend, you can say so, and pip will oblige. If you don’t, then pip assumption is that you are using distutils or setuptools and therefore pip will fallback to look for setup.py, execute it, and hopefully build something.

setup.py is just going eventually to disappear, or not. setup.py is a way **setuptools** (and before that, distutils) describes how to create a build. Another tool might use some other approach. Possibly, they will rely on pyproject.toml by adding some sections in it.

Also, in pyproject.toml you can finally specify the dependencies needed to even perform the build, removing the chicken egg problem given above.

**Why toml? I’ve never heard of this format. What’s wrong with JSON/INI/YAML?**

JSON does not allow (from standard) to write comments. Yes. Crockford actually wanted that. One could bend the rules, but then it’s not JSON. Plus, JSON is actually not very pleasant to use by a human.

INI, believe it or not, is not standard, plus it’s rather limited in features.

YAML is a can of worms and a potential security threat.

**Fair enough on toml. But, couldn’t they have included setuptools in the standard library instead?**

Maybe, but the problem is that the standard library has veeery slooow release cycles. The slowness of improvements over distutils is what triggered the implementation of setuptools in the first place. Besides, there’s no guarantee that setuptools can satisfy all needs. Some packages may have specialized needs.

**Ok, so if I understand correctly: to create my working environment I need Poetry. To create the built package, I need setup.py and setuptools. or pyproject.toml?**

If you want to use setuptools, you need a setup.py, but then you have the problem that people will need setuptools installed to build your package.

**Which other tools can I use instead of setuptools?**

you can use flit, or Poetry itself.

**Wasn’t Poetry something to install dependencies?**

Yes but it also does building. pipenv doesn’t do that.

**By the way, if I use setup.py I have to write the dependencies, why? What is their relationship with the ones I installed with pipenv/Poetry/requirements.txt?**

Those are the abstract dependencies that are needed for your package to run, and are the dependencies that pip needs when it’s time to decide what to download and install next. You should generally put loose (unversioned) dependencies in there, because if you don’t… remember when I told you about A and B having a common dependency C? what if A says “I want to use C version 1.2.1” and B says “I want to use C version 1.2.2”?

Pip has no choice when it’s time to build a source distribution it downloaded. It doesn’t know anything about your requirements.txt. All it knows is that it needs to run setup.py, which in turns uses setuptools to then invoke pip again to resolve the abstract dependencies written there into something concrete it can install.

**What about eggs? easy install? .egg-info directories? distribute? virtualenv (not venv)? zc.buildout? bento?**

Forget them. They are either legacy, forks, or attempts that went nowhere.

**What’s with Wheels?**

Rememeber when I said that pip needs to know what to download from pypi to download the right versions and the right operating system? a Wheel is a file that contains the stuff to install, and has some special, well-codified name so that pip can make decisions as it installs dependencies and subdependencies.

Wheels file names (pep-0425) contain tags that act as metadata, so that when something has been compiled for, say CPython, it knows the version, the ABI, etc. There is a standard layout of this tags in the filename, and there are particular keywords in that metadata that have specific meanings.

Always build wheels for your binary distributions.

**What about .pyz?**

Forget it. Unrelated to packaging, strictly speaking. It could be useful in some circumstances. See PEP-441 for more info.

**What about pyinstaller?**

Pyinstaller opens a completely different topic. See, the problem with the word “packaging” is that it’s unclear what it refers to. Until now, we spoke about

1. creating an environment in which you can develop your own library
2. bundling what you created into something other people can use

But those apply generally to libraries. When it’s time to distribute applications, the situation changes. When you package a library, you know it’s going to be part of a larger whole. When you package an application, the application **is the larger whole**.

Plus, with an application you want to provide things that are platform specific. For example, you might want to provide an executable with an icon, but how this works differs between Windows, macOS and Linux.

PyInstaller is a tool that you involve when you want to create an application as a single executable. It addresses this need: get a final application on your user’s desktop. Packaging is about managing the network of dependencies, libraries and tools that you need to create that application that you might, or might not, create with pyinstaller.

Note however, that this approach assumes that your application is simple and self-contained. If the application needs to do something much more complex when it gets installed, such as creating registry keys on Windows, now you need a proper, full fledged installer such as NSIS. I am unaware if anything like NSIS is available in the python world. In any case, NSIS is agnostic of what you deploy. You can definitely create an application executable with pyinstaller, and deploy this executable plus any needed Registry changing magic or filesystem modifying sauce to make it work using NSIS.

**Ok, but how do I install something I have the sources of? python setup.py?**

No. Use `pip install .` because it guarantees you can uninstall it afterwards and it’s overall better. What pip does is try to check for pyproject.toml and run the build backend. If it does not find a pyproject.toml, it just reverts to the old ways and tries to build running setup.py.

**I like this post, but I have a question or something in this narrative that is unclear**

Just [open an issue](https://github.com/stefanoborini/stefanoborini.github.io/issues). If I know the answer, I’ll add it immediately. If I don’t, I’ll do some research and reply as soon as possible. My aim is to keep this post as the place where people finally **understand** python packaging.

**Any links I can explore further?**

Sure.

* https://sedimental.org/the_packaging_gradient.html

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
