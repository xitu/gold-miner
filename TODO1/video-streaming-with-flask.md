> * 原文地址：[Video Streaming with Flask](https://blog.miguelgrinberg.com/post/video-streaming-with-flask)
> * 原文作者：[Miguel Grinberg](https://blog.miguelgrinberg.com/author/Miguel%20Grinberg)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/video-streaming-with-flask.md](https://github.com/xitu/gold-miner/blob/master/TODO1/video-streaming-with-flask.md)
> * 译者：[BriFuture](https://github.com/brifuture)
> * 校对者：

# 用 Flask 输出视频流

相信你已经知道，我和 O'Reilly Media 合作出版了 [讲解 Flask 的书籍和一些视频](http://flaskbook.com)。尽管这些书籍和视频对 Flask 的讲解已经足够详细了，但由于某些原因一小部分特性讲的不够多，因此我觉得把他们写在这篇文章中是个好主意。

本文专注于**流**，一个有意思的特性，它让 Flask 应用能够以分割成小块的形式提供超大的响应，这可能要花一段较长的时间。为了阐明这个主题，你将会看到如何构建一个实时视频流服务器。

**注意**： 现在有一篇关于本文的后续文章，[Flask Video Streaming Revisited](http://blog.miguelgrinberg.com/post/flask-video-streaming-revisited)，我在后续文章中讲了关于本文介绍的流服务器的一些改进。

## 什么是流？

流是一种让服务器在响应请求时将响应数据分块的技术。我能想到好多可能很有用的理由：

*   **超级巨大的响应数据**。对于超大的响应数据来说，先把响应数据装载到内存中，再返回给客户端是非常低效的。另一种方法是将响应数据写入到磁盘中，然后用 `flask.send_file()` 将文件返回给客户端，但这样将会增加 I/O 操作。如果响应数据较小，这就是个好得多的方法，因为数据能够按块进行存储。
*   **实时数据**。对于某些应用来说，也许需要向某个请求返回来自实时数据源的数据。一个很贴切的例子是实时视频或音频传送。很多安全摄像头用该技术将视频以流的形式发送到服务器。

## 用 Flask 实现流

Flask 通过使用 [生成器（generator functions）](http://legacy.python.org/dev/peps/pep-0255/) 原生支持流式响应。生成器是一个特殊的函数，可以被中止或继续运行。看看下面的函数：

```
def gen():
    yield 1
    yield 2
    yield 3
```

这是一个分三步运行的函数，每一步都返回一个值。生成器的实现超出了本文的范围，如果你对此很感兴趣的话，下面的 shell session 会让你知道怎么使用生成器：

```
>>> x = gen()
>>> x
<generator object gen at 0x7f06f3059c30>
>>> x.next()
1
>>> x.next()
2
>>> x.next()
3
>>> x.next()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration
```

可以看到，在这个简单的例子中，一个生成器可以依次返回多个值。Flask 使用生成器的该特性实现了流。

下面的例子展示了如何在不把整个表都装配到内存的情况下，使用流生成巨型数据表：

```
from flask import Response, render_template
from app.models import Stock

def generate_stock_table():
    yield render_template('stock_header.html')
    for stock in Stock.query.all():
        yield render_template('stock_row.html', stock=stock)
    yield render_template('stock_footer.html')

@app.route('/stock-table')
def stock_table():
    return Response(generate_stock_table())
```

在这个例子中你可以看到 Flask 是如何使用生成器的。某个返回流式响应的路由需要返回一个入参为生成器的 `Response` 对象。Flask 将会负责调用生成器，并把所有部分的结果以块的形式发送给客户端。  
> 译者注：python3 中，访问 `/stock-table` 路由时，如果在 Debug 模式下看到 `AttributeError: 'NoneType' object has no attribute 'app'`，则需要将 Response 的入参用 `stream_with_context()` 预处理。导入该函数：`from flask import stream_with_context`，路由的返回值：`return Response( stream_with_context( generate_stock_table() ) )`。

对于这个特殊的例子，假设 `Stock.query.all()` 返回的是可迭代的数据库查询结果，那么你可以按每次一行的速度生成一个巨大的表，因此无论查询结果中的元素数量有多少，该 Python 进程的内存占用不会因为装配巨大的响应字符串而变得越来越大。

## 分部响应

上述的表格示例生成小部分传统页面，再把所有部分衔接成最终的文档。这是如何生成巨大响应的很好的示例，但更让人兴奋的事情是操作实时数据。

一种有趣的流的用法是让每一个数据块取代页面中的前一块，这样流就能够在浏览器窗口中进行“播放”或者动画。使用该技术你能够用图片作为流的每一部分，这将带来一个很酷的在浏览器中运行的视频播放器。

实现原地更新的秘诀在于使用 **multipart（分部）** 响应。分部响应的内容是一个包含分部内容类型的头部，后面的是用 **boundary（分界线）** 标记分割的部分，每一部分有各自的特定内容类型。

有若干个分部内容类型用于不同的用途。为了达到让流中的每部分能够替代前一部分的目的，内容类型必须用 `multipart/x-mixed-replace` 。为了让你知道它看上去是什么样的，这里有个分部视频流的结构：

```
HTTP/1.1 200 OK
Content-Type: multipart/x-mixed-replace; boundary=frame

--frame
Content-Type: image/jpeg

<jpeg data here>
--frame
Content-Type: image/jpeg

<jpeg data here>
...
```

如你所见，结构很简单。主要的 `Content-Type` 头部设为 `multipart/x-mixed-replace`，还定义了边界字符串。然后是各个分部，边界字符串前面带有两个横线，占据一行。这部分有自己的 `Content-Type` 头部，每个部分有可选的 `Content-Length` 头部，表明该部分数据的字节数长度，但至少对于图片来说，浏览器不需要长度也能够处理流数据。

## 构建一个实时视频流服务器

在本文中已经有了足够的理论，现在是时候构建一个完整的能够将直播视频流式传输到浏览器的应用了。

有很多种流式传输视频到浏览器的方式，每一种方法各有优劣。与 Flask 的流式特性结合得非常好的一种方法是流式输出一系列单独的 JPEG 图片。这被称为 [移动的 JPEG（Motion JPEG）]((http://en.wikipedia.org/wiki/Motion_JPEG))，这种方法正被一些 IP 安全摄像头使用。这种方法的延迟低，但是质量并不是最好，因为对于移动视频来说， JPEG 的压缩并不高效。

下面你将看到一个特别简单但又十分完善的 web 应用，可以提供移动的 JPEG 流：

```
#!/usr/bin/env python
from flask import Flask, render_template, Response
from camera import Camera

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

def gen(camera):
    while True:
        frame = camera.get_frame()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

@app.route('/video_feed')
def video_feed():
    return Response(gen(Camera()),
                    mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
```

这个应用导入了 `Camera` 类，该类负责提供帧序列。当前情形将摄像头控制部分放在单独的模块中是很好的主意，这样 web 应用就能保持代码的整洁、简单和通用性。

该应用有两个路由。路由 `/` 提供定义在 `index.html` 模版中的主页面。你能从下面的代码中看到模版文件的内容：

```
<html>
  <head>
    <title>Video Streaming Demonstration</title>
  </head>
  <body>
    <h1>Video Streaming Demonstration</h1>
    <img src="{{ url_for('video_feed') }}">
  </body>
</html>
```

这是个简单的 HTML 页面，只有一个 heading 和一个图片标签。注意图片标签的 `src` 属性指向的是该应用的第二个路由，而这正是奇妙的地方。

路由 `/video_feed` 返回的是流式响应。因为流返回的是可以显示在网页中的图片，到该路由的 URL 就放在图片标签的 `src` 属性中。浏览器会自动显示流中的 JPEG 图片，从而保持更新图片元素，由于分部响应受大多数（甚至所有）浏览器的支持（如果你找到一款浏览器没有这种功能，请务必告诉我）。

在 `/video_feed` 路由中用到的生成器函数叫做 `gen()`，它接收 `Camera` 类的实例作为参数。`mimetype` 参数的设置和上面一样，是 `multipart/x-mixed-replace` 类型，边界字符串设置为 `frame`。

`gen()` 函数进入循环，从而持续地将摄像头中获取的帧数据作为响应块返回。该函数通过调用 `camera.get_frame()` 方法从摄像头中获取一帧数据，然后它将这一帧以内容类型为 `image/jpeg` 的响应块形式产出（yield），如上所述。

## 从视频摄像头中获取帧

现在剩下要做的只有实现 `Camera` 类了，它要能够连接到摄像机硬件，并从硬件中下载实时视频帧。将应用的硬件依赖部分封装到类中的好处是，这个类可以针对不同人群有不同的实现，但应用的其它部分保持不变。你可以把这个类想象成设备驱动，无论实际使用的是什么硬件，它都能提供统一的实现。

将 `Camera` 类从应用中分离出来的另一个优势是很容易让应用误以为相机是存在的，而实际情况是相机并不存在，因为相机类可以被实现成没有真实硬件的模拟相机。实际上，在我制作这个应用的时候，对我来说最简单的测试流的方式就是模拟相机，在我跑通其它部分前，不用考虑硬件问题。接下来你将看到我所使用的简单模拟相机的实现：

```
from time import time

class Camera(object):
    def __init__(self):
        self.frames = [open(f + '.jpg', 'rb').read() for f in ['1', '2', '3']]

    def get_frame(self):
        return self.frames[int(time()) % 3]
```

这种实现是从硬盘中读取三张分别叫做 `1.jpg`、`2.jpg` 和 `3.jpg` 的图片，然后以每秒一帧的速度循环返回它们。`get_frame()` 方法使用当前时间的秒数来决定当前应该返回三张图片中的哪一张。非常简单，不是吗？

要运行这个模拟相机，我需要创建三个帧。我使用 [gimp](http://www.gimp.org/) 做出了下面的图片：

![Frame 1](https://blog.miguelgrinberg.com/static/images/video-streaming-1.jpg) ![Frame 2](https://blog.miguelgrinberg.com/static/images/video-streaming-2.jpg) ![Frame 3](https://blog.miguelgrinberg.com/static/images/video-streaming-3.jpg)

因为相机模拟出来了，这个应用可以运行在任何环境中，因此你可以立即运行它！我把这个应用的所有东西都准备好了，放在 [GitHub](https://github.com/miguelgrinberg/flask-video-streaming) 上。如果你熟悉 `git`，你可以用下面的命令克隆这个仓库：

```
$ git clone https://github.com/miguelgrinberg/flask-video-streaming.git
```

如果你要下载该应用，你可以从 [这儿](https://github.com/miguelgrinberg/flask-video-streaming/archive/v1.zip) 获取一个 zip 压缩文件。

装好应用后，创建一个虚拟环境并安装好 Flask。然后你可以运行命令：

```
$ python app.py
```

当你开启应用后，在浏览器中输入 `http://localhost:5000`，你就能看到模拟的视频流，不断播放着图片 1、2、3。是不是很酷？

当我做好了这些事情后，我用相机模块启动了树莓派，并实现了一个新的 `Camera` 类，这个类将树莓派转换成一个视频流服务器，使用 `picamera` 包来控制硬件。这里不会涉及到相应的相机实现，但你可以在文件 `camera_pi.py` 中找到相应的源代码。

如果你有一个树莓派和相机模块，你可以编辑 `app.py` 文件，从这个模块中引入 `Camera` 类，然后你就可以流式直播树莓派的相机，就像在下面的截图中我所做的那样：

![Frame 1](https://blog.miguelgrinberg.com/static/images/video-streaming-3.png)

如果你想让这个流式应用和不同的相机一起使用，那么你要做的就是改写 `Camera` 类的实现。如果你实现了这样的一个相机类，并将它贡献到我的 GitHub 项目中，我将不胜感激。

## 流的局限

Flask 应用在服务常规请求时，请求的周期短。web worker 接收到请求，调用处理函数，最终返回响应。一旦响应返回给了客户端，worker 就处于空闲状态，等待着接收下一次请求。

当接收到使用流的请求时，在流的持续时间内 worker 一直留存在客户端中。在处理永不结束的、长的流时，比如从摄像机发来的一个视频流，worker 将会对客户端保持锁定状态，直到客户端断开连接。这也就意味着除非采用特殊的方法，否则有多少客户端，应用就要为多少 web workers 提供服务。在 debug 模式下运行 Flask 应用意味着只有一个线程，因此你无法打开另一个浏览器窗口，在两个地方同时观看流。

有很多方法可以解决这个关键的限制。我认为最好的方案是使用基于协程的 web 服务器，比如 Flask 支持很好的 [gevent](http://www.gevent.org/)。gevent 通过使用协程能够在一个工作线程中处理多个客户端，因为 gevent 修改了 Python I/O 函数，在必要时处理上下文的切换。

## 结论

如果你跳过了上面的内容，可以在 GitHub 仓库上看到本文相应的代码：[https://github.com/miguelgrinberg/flask-video-streaming/tree/v1](https://github.com/miguelgrinberg/flask-video-streaming/tree/v1)。你能从中找到不需要相机的视频流通用实现，也可以看到树莓派相机模块的实现。这篇 [后续文章](http://blog.miguelgrinberg.com/post/flask-video-streaming-revisited) 讲述了本文最开始发布后我所做的一些改进。

我希望本文能够为流这一话题带来一些启发。我专注于视频流，因为我在这一领域中有些经验，但流的应用不仅限于视频。比如，这个技术可以用来保持服务器与客户端的连接长时间有效，允许服务器在有信息时发送新信息。最近 Web Socket 协议可以更高效的实现这个目的，但是 Web Socket 相当新颖，只能在现代浏览器中使用，而流却能在非常多的浏览器中使用。

如果你有任何问题，请将它们写在下方。我打算为不为大众所知的 Flask 专题继续撰写文章，所以希望你能以某种方式联系我，以便知道更多文章发布的时间，下篇文章中再见。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
