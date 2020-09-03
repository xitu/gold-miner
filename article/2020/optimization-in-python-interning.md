> * 原文地址：[Optimization in Python — Interning](https://towardsdatascience.com/optimization-in-python-interning-805be5e9fd3e)
> * 原文作者：[Chetan Ambi](https://medium.com/@chetan.ambi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/optimization-in-python-interning.md](https://github.com/xitu/gold-miner/blob/master/article/2020/optimization-in-python-interning.md)
> * 译者：
> * 校对者：

# Python的优化 — 驻留机制

![Photo by [George Stewart](https://unsplash.com/@_stewart_) on [Unsplash](https://unsplash.com/photos/D8gtlT7j1v4)](https://cdn-images-1.medium.com/max/2000/0*TVH3cYeJ4s6F-4F3)

如今有几种不同的Python解释器，包括CPython,Jython,IronPython等。我们现在讨论的优化技术是跟CPython有关的，它是标准的Python解释器。

## 驻留机制

**Interning(驻留机制)是指根据需要重用对象** ，而不是创建新对象。我们通过一些例子来理解Integer类型对象和String类型对象的驻留机制。

**is**是一种运算符，用于比较两个Python对象的内存位置。
**id**用于获取对象的十进制形式的内存位置。

#### Integer对象的驻留

Python启动之时，内存中预加载了一系列Integer对象，这些对象是从-5到256之间的数字。我们无论何时创建的该范围内的Integer对象都会自动指向这些预先加载的内存位置，Python不会因此创建新的对象。

使用这样的优化策略的原因很简单，是由于-5到256范围内的数字经常会用到。把它们预存在内存中是有实际意义的。

**例1**

本例中，变量a和变量b都被赋值100。由于是-5到256范围内的数值，Python会使用驻留的对象，变量b也会指向同一内存位置，而不会创建另一个值为100的对象。

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*2bCl5cSdmLdcdcu4SJ7yZA.png)

从下面的代码可以看出，变量a和变量b指向的是内存中同一对象。Python不会为变量b创建新的对象，变量a与变量b指向的内存位置是相同的。这是由于Integer对象的驻留机制决定的。

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*KXOVe2gvDFXx-yEbYwWoiA.png)

**例2**

本例中，变量a和变量b都被赋值1000。由于不在-5到256范围内，Python会创建两个Integer对象。所以变量a和变量b的存储位置就不一样了。

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*1xhLqtk8pxzLbzJESmv9MQ.png)

从下面的代码可以看出，变量a和变量b在内存中的存储位置是不同的。

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*qzdvHUE2Bl6sjegrGX_pJg.png)

#### String对象的驻留

跟Integer对象一样，某些String对象也是驻留的。一般来说，任何符合标识符命名规范的String对象都是驻留的。有时也存在例外。所以，不要完全依赖于驻留机制。

**例1**

字符串“Data”是合法的标识符，它会驻留，所以两个变量都指向同一内存位置。

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*TwabGuCDNvtJZF4Z--hxfQ.png)

**例2**

字符串“Data Science”不是合法的标识符，驻留机制无效，所以两个变量指向不同的内存位置。

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*75_mJbYlq-pIEpRtzyxVXQ.png)

> 上述例子都来自Google Colab，使用的Python版本是3.6.9。

在Python3.6中，所有合法的、长度不小于20的字符串都是驻留的。但在Python3.7中，长度下限变为4096。所以正如我以前提到的，这些标准因Python版本而异。

由于不是所有的String对象都被驻留，Python提供了强制驻留字符串的方法sys.intern()。这个方法除非确实需要，不建议使用。使用方法参考下面的代码。

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*XlY1DoTzGDFaLSdYa1MaIw.png)

## String对象驻留的重要意义

假定在你的应用程序中，会频繁进行字符串操作。如果使用==运算符来比较长度较大的字符串，Python会一个个字符去比较，这显然是费时的。但如果这些长字符串被驻留，它们就指向了相同的内存位置。由于比较内存位置的操作会快得多，我们就可以使用is运算符来进行字符串比较。

## 结论

阅读本文后，你应该理解Python的驻留机制。如果你要获得更多关于Python和数据科学的文章，请关注我的账号。

如果对Python的易变性和不变性感兴趣，请点击(https://towardsdatascience.com/mutability-immutability-in-python-b698bc592cbc)查看我的文章。

---

感谢你抽出时间阅读本文。你还可以关注我的领英账号(https://www.linkedin.com/in/chetanambi/)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
