> * 原文地址：[Python: smart coding with locals() and global()](https://medium.com/python-in-plain-english/python-smart-coding-with-locals-and-global-257ae25461ee)
> * 原文作者：[Konstantinos Patronas](https://medium.com/@kpatronas)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/python-smart-coding-with-locals-and-global.md](https://github.com/xitu/gold-miner/blob/master/article/2020/python-smart-coding-with-locals-and-global.md)
> * 译者：
> * 校对者：

# Python: smart coding with locals() and global()

![Photo by [Christina @ wocintechchat.com](https://unsplash.com/@wocintechchat?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12032/0*ZYy01ayW-6rkXMGV)

Coding can be hard! and one of the most common reasons for that is that we tend to solve a coding problem thinking complex ways which can create more problems than solutions.

**Lets try to break down the following coding problem:**

* The first server in servers list is a proxy server, so it needs to use the connect_to_proxy function.
* All other server are just servers that we want to connect and get to the next server, so they need to use the hop_to_server function.

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

locals() returns the variables / objects declared in the scope a function. So in this case the code will do the following:

1. The first time that will run it will check if the “server_conn” variable has been created or not. Since this is the first time running the connect_to_proxy function will be executed and will return its value to the server_conn variable.
2. After the first run of the loop the hop_to_server function will be executed untill the end of the loop.

But what about the globals() function? well it does the same thing, checks if a variable exists but not only in the scope of a function but globaly.

So using the locals() and globals() functions allows writing smart shortcuts, which in turn means less things that can go wrong and makes the code more readable.

**Doing the same without using the locals() function:**

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

It will work, but the code has more lines and is not as readable as the first example.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
