> * 原文地址：[DemoForBeginner: What is WSGI?](https://levelup.gitconnected.com/demoforbeginner-what-is-wsgi-ac3c2a67089)
> * 原文作者：[Zosionlee](https://medium.com/@zosionlee.chou)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/demoforbeginner-what-is-wsgi.md](https://github.com/xitu/gold-miner/blob/master/article/2020/demoforbeginner-what-is-wsgi.md)
> * 译者：
> * 校对者：

# DemoForBeginner: What is WSGI?

PEP-3333 describes the WSGI protocol specification in detail. WSGI is the abbreviation of Python Web Server Gateway Interface, and is an interface specification that describes how to interact between a Web server and a Python application. Therefore, we discuss and understand how to implement the WSGI protocol in the form of code.All the original codes can be obtained in my github repository

![](https://cdn-images-1.medium.com/max/3314/1*PHVAYtkTLNcEl-OqhpsUUA.png)

---

#### Let`s talk about application and server.

#### Application

* The application is a callable that must and can only receive two parameters, like application(environ, start_response). And these two parameters can only be passed in as positional parameters.
* The application must be called multiple times, because all servers/gateway (except CGI) will issue such repeated requests.
* environ is a dictionary parameter that contains CGI-style environment variables. It must use the built-in Python dictionary type and allow the application to modify it in any way it wants. The dictionary also includes certain WSGI variables, and their naming needs to comply with corresponding specifications. Such as

```
environ = {k: v for k, v in os.environ.items()}
environ['wsgi.input'] = self.rfile
environ['wsgi.errors'] = sys.stderr
environ['wsgi.version'] = (1, 0)
environ['wsgi.multithread'] = False
environ['wsgi.multiprocess'] = True
environ['wsgi.run_once'] = True
environ['wsgi.url_scheme'] = 'http'
```

* The start_response parameter is also a callable, which receives two necessary unknown parameters(status and response_header) and one optional parameter(exc_info=None). The status is a status string and
response_headers is a list of tuples describing HTTP Response Headers(header_name, header_value)
* start_response must return a write callable, this callable requires a positional parameter: a bytestring to be part of the HTTP response body
* If the iterable returned by the application has a close method, the server must call it after the current request is completed, regardless of whether the request is completed normally

#### Server

* Receive HTTP request and return HTTP response
* Provide environ data and implement the callback function start_response
* Invoke the WSGI application and pass in environ and start_response as parameters

#### MiddleWare

A single object may play the role of a server with respect to some application(s), while also acting as an application with respect to some server(s).For WSGI application it is equivalent to WSGI server, and for WSGI server it is equivalent to WSGI application.

---

#### Let`t make a demo code by handwriting.

All the handwritten codes can be obtained in my github repository, as shown below：

[wsgi_demo](https://github.com/ZosionLee/DemoForBeginner/blob/develop/wsgi/wsgi_handwrite.py)

#### Application

The following lists three forms of implementing application：

```Markdown
```python
def simple_app(environ, start_response):
    '''a application by define a function'''

    status = '200 OK'
    headers = [('Content-type', 'text/plain; charset=utf-8')]
    start_response(status, headers)
    return ['hello,world\n'.encode('utf-8')]


class IterSimpleApp(object):
    '''iterable class'''

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
    '''callable instance'''

    def __call__(self, environ, start_response):
        status = '200 OK'
        response_headers = [
            ('Content-type', 'text/plain; charset=utf-8'),
        ]
        start_response(status, response_headers)
        yield 'hello,world\n'.encode('utf-8')
        
```
```

#### MiddleWare

A middleware demo for authetication as below:

```Python
class AuthMiddleware(object):
    '''A middleware demo to filter authentication'''

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

#### Server

The custom server module is more complicated and mainly uses the python native library as below:

* use os module to get environ
* use sys to set err output
* selectors to make IO multiplex by event loop
* socket to communication

![](https://cdn-images-1.medium.com/max/3702/1*wKZbKXmlXr-dx9QaXgI20w.png)

Regarding custom server, Python actually has a library that implements the WSGI protocol for the use in the development environment, such as wsgiref. I write server here is just to better understand how to implement a WSGI server.

---

#### Let’s take a peek at wsgiref.

wsgiref based on the lib of **socketserver**, so let`s look at socketserver first.

the class diagram of socketserver below:

![](https://cdn-images-1.medium.com/max/3726/1*ZeEVOdTcTBdMtF7huJydow.png)

Based on the analysis and understanding of socketserver, the wsgi protocol on how wsgiref is implemented is as follows：

![](https://cdn-images-1.medium.com/max/3776/1*kI7Xtyw0pzpv6BjpVEsNHg.png)

---

#### let`s make a summary.

* PEP3333 make a specification of wsgi
* we have been talk about the wsgi server and application
* we take a look at wsgiref and understand the proceduce of interactive process for WSGIServer and WSGIRequestHandler.
* According to the description of the wsgi protocol, we implement an application and server by handwriting code.

#### That`s all for this post, and hope it helps you. If you like this original article, please click claps. Welcome to comment. THX

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
