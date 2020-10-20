> * 原文地址：[Python: smart coding with locals() and globals()](https://medium.com/python-in-plain-english/python-smart-coding-with-locals-and-global-257ae25461ee)
> * 原文作者：[Konstantinos Patronas](https://medium.com/@kpatronas)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/python-smart-coding-with-locals-and-global.md](https://github.com/xitu/gold-miner/blob/master/article/2020/python-smart-coding-with-locals-and-global.md)
> * 译者：[Herman](https://github.com/actini)
> * 校对者：[loststar](https://github.com/loststar)

# Python：使用 locals() 和 globals() 巧妙编程

![Photo by [Christina @ wocintechchat.com](https://unsplash.com/@wocintechchat?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12032/0*ZYy01ayW-6rkXMGV)

写代码是一件很困难的事儿！尤其是我们往往把代码问题想得太复杂，导致在解决问题的过程中引发更多的问题。

**我们来试着解决下面这个问题：**

* 列表的第一个服务器是代理服务器，因此它需要调用 `connect_to_proxy` 函数。
* 其他服务器只提供服务，我们可以使用代理连接到它们，因此需要调用 `hop_to_server` 函数。

```python
def connect_servers():
    '''
    Connect servers
    '''
    for server in servers:
        if not "server_conn" in locals():
            server_conn = connect_to_proxy(server=server)
        else:
            server_conn = hop_to_server(server=server)
```

`locals()` 会返回在当前函数里声明的变量/对象，因此这段代码是这样工作的：

1. 每次循环执行时，程序都会检查 `server_conn` 变量是否已经存在，因此第一次循环时 `connect_to_proxy` 函数会被执行，并且其返回值将会传递给 `server_conn` 变量。
2. 之后每次执行的过程中，程序都会调用 `hop_to_server` 函数，直到循环结束。

那么 `globals()` 函数又是干什么的呢？其实它的功能跟 `locals()` 是一样的，都可以用来检查变量是否存在，只不过它的作用域是全局的，而不仅限于当前函数。

因此合理使用 `locals()` 和 `globals()` 函数能写出巧妙的代码，换句话说，代码不容易出错也更具有可读性。

**不使用 `locals()` 实现相同的功能**

```python
def connect_servers():
    '''
    Connect servers
    '''
    first_run = True
    for server in servers:
        if first_run == True:
            server_conn = connect_to_proxy(server=server)
            first_run = False
        else:
            server_conn = hop_to_server(server=server)
```

这也奏效，但是代码行数变多了，并且不如第一个例子可读性好。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
