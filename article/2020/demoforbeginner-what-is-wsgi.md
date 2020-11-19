> * 原文地址：[DemoForBeginner: What is WSGI?](https://levelup.gitconnected.com/demoforbeginner-what-is-wsgi-ac3c2a67089)
> * 原文作者：[Zosionlee](https://medium.com/@zosionlee.chou)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/demoforbeginner-what-is-wsgi.md](https://github.com/xitu/gold-miner/blob/master/article/2020/demoforbeginner-what-is-wsgi.md)
> * 译者：[JalanJiang](http://jalan.space/)
> * 校对者：

# 给初学者的示例: 什么是 WSGI？

PEP-3333 详细描述了 WSGI 协议规范。WSGI 是 Python Web Server Gateway Interface（Python 服务器网关协议）的缩写，是一个描述如何在 Web 服务器与 Python 应用之间交互的接口规范。因此，我们将讨论并理解如何以代码的形式实现 WSGI 协议。你可以在我的 GitHub 仓库中获得所有的源码。

![](https://cdn-images-1.medium.com/max/3314/1*PHVAYtkTLNcEl-OqhpsUUA.png)

让我们一起来探讨应用程序与服务器吧。

#### 应用程序

* 应用程序是可调用的，它有且仅接收两个参数，例如 `application(environ, start_response)`。并且这两个参数只能作为位置参数传入。
* 应用程序必须被多次调用，因为所有的服务器/网关（除了 CGI）都将发出这种重复的请求。
* `environ` 是一个字典参数，它包含 CGI 风格的环境变量。它必须使用 Python 内置的字典类型，并允许应用程序以任何方式修改它。字典还包括某些 WSGI 变量，它的命名需要符合相应的规范，例如：

```py
environ = {k: v for k, v in os.environ.items()}
environ['wsgi.input'] = self.rfile
environ['wsgi.errors'] = sys.stderr
environ['wsgi.version'] = (1, 0)
environ['wsgi.multithread'] = False
environ['wsgi.multiprocess'] = True
environ['wsgi.run_once'] = True
environ['wsgi.url_scheme'] = 'http'
```

* `start_response` 参数也是一个可调用参数，它接收两个必须的未知的参数（`status` 和 `response_header`）和一个可选参数（`exc_info=None`）。`status` 是一个 HTTP 状态字符串，`response_headers` 是一个描述了 HTTP 响应头部（`header_name`，`header_value`）的元组列表。
* `start_response` 必须返回一个 callable，这个 callable 需要一个位置参数：一个二进制字符串作为 HTTP 响应的主体。
* 如果应用程序返回的迭代对象拥有一个关闭方法，则无论请求是否正常完成，服务器必须在当前请求结束后调用该方法。
  

#### 服务器

* 接收 HTTP 请求并返回 HTTP 响应。
* 提供 `environ` 数据并执行回调函数 `start_response`。
* 调用 WSGI 应用程序并传递 `environ` 和 `start_response` 参数。

#### 中间件

对于某些应用程序，单个对象可能扮演着服务器的角色，同时也可以作为某些服务器相关的应用程序。WSGI 应用程序相当于 WSGI 服务器，WSGI 服务器又等效于 WSGI 应用程序。

#### 让我们手写一个示例代码

所有手写代码都在我的 [GitHub 仓库](https://github.com/ZosionLee/DemoForBeginner/blob/develop/wsgi/wsgi_handwrite.py) 中，代码如下所示：

#### 应用程序

以下列出执行应用程序的三种方式：

```python
def simple_app(environ, start_response):
    '''通过定义函数实现应用程序'''

    status = '200 OK'
    headers = [('Content-type', 'text/plain; charset=utf-8')]
    start_response(status, headers)
    return ['hello,world\n'.encode('utf-8')]


class IterSimpleApp(object):
    '''可迭代类'''

    def __init__(self, environ, start_response):
        self.environ = environ
        self.start_response = start_response

    def __iter__(self):
        status = '200 OK'
        response_headers = [
            ('Content-type', 'text/plain; charset=utf-8')
        ]
        self.start_response(status, response_headers)
        yield 'hello,world\n'.encode('utf-8')


class InstSimpleApp(object):
    '''可调用实例'''

    def __call__(self, environ, start_response):
        status = '200 OK'
        response_headers = [
            ('Content-type', 'text/plain; charset=utf-8'),
        ]
        start_response(status, response_headers)
        yield 'hello,world\n'.encode('utf-8')     
```

#### 中间件

一个用于认证的中间件示例代码如下所示：

```Python
class AuthMiddleware(object):
    '''用于认证过滤的中间件示例'''

    def __init__(self,app):
        self.app=app

    def __call__(self,environ,start_response):
        auth = environ.get('wsgi.authentication', None)
        if not auth or auth != 'zosionlee':
            start_response(
                '403 Forbidden',
                [('Content-Type', 'text/plain; charset=utf-8')]
            )
            return [
                'No authentication, forbidden.\n'.encode('utf-8')
            ]
        return self.app(environ, start_response)
```

#### 服务器

自定义服务器模块比较复杂，主要使用了下列 Python 原生库：

* 使用 `os` 模块获取 `environ`。
* 使用 `sys` 来设置错误输出。
* 通过事件循环实现 IO 多路复用的选择器。
* 使用 socket 通信。

![](https://cdn-images-1.medium.com/max/3702/1*wKZbKXmlXr-dx9QaXgI20w.png)

关于定制服务器，实际上 Python 实现了一个 WSGI 协议库，用于在开发环境中使用，例如 wsgiref。我在这里阐述服务器只是为了方便你更好地理解 WSGI 服务器是如何实现的。

#### 让我们来看看 wsgiref

wsgiref 基于 **socketserver** 库，所以让我们先来看看 socketserver。

socketserver 的类图如下：

![](https://cdn-images-1.medium.com/max/3726/1*ZeEVOdTcTBdMtF7huJydow.png)

基于对 socketserver 的分析和理解，wsgiref 是这样实现 WSGI 协议的： 

![](https://cdn-images-1.medium.com/max/3776/1*kI7Xtyw0pzpv6BjpVEsNHg.png)

#### 让我们总结一下

* PEP-3333 详细描述了 WSGI。
* 我们已经讨论了 WSGI 服务器与应用程序。
* 我们大致地看了 wsgiref，并了解了 WSGIServer 和 WSGIRequestHandler 的交互过程。
* 根据 WSGI 协议的描述，我们手写代码实现了应用程序与服务器。

这就是文章的所有内容，希望它对你有所帮助。如果你喜欢这篇原创文章，请点击 claps。欢迎留言。谢谢。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
