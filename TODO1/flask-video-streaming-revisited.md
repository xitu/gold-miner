> * 原文地址：[Flask Video Streaming Revisited](https://blog.miguelgrinberg.com/post/flask-video-streaming-revisited)
> * 原文作者：[Miguel Grinberg](https://blog.miguelgrinberg.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flask-video-streaming-revisited.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flask-video-streaming-revisited.md)
> * 译者：[zhmhhu](https://github.com/zhmhhu)
> * 校对者：[1992chenlu](https://github.com/1992chenlu)

# 再看 Flask 视频流

![](https://blog.miguelgrinberg.com/static/images/video-streaming-revisited.jpg)

大约三年前，我在这个名为 [Video Streaming with Flask](https://juejin.im/post/5bea86fc518825158c531e9c) 的博客上写了一篇文章，其中我提出了一个非常实用的流媒体服务器，它使用 Flask 生成器视图函数将 [Motion-JPEG](https://en.wikipedia.org/wiki/Motion_JPEG)  流传输到 Web 浏览器。在那片文章中，我的意图是展示简单而实用的[流式响应](http://flask.pocoo.org/docs/0.12/patterns/streaming/)，这是 Flask 中一个不为人知的特性。

那篇文章非常受欢迎，倒并不是因为它教会了读者如何实现流式响应，而是因为很多人都希望实现流媒体视频服务器。不幸的是，当我撰写文章时，我的重点不在于创建一个强大的视频服务器所以我经常收到读者的提问及寻求建议的请求，他们想要将视频服务器用于实际应用程序，但很快发现了它的局限性。

## 回顾：使用 Flask 的视频流

我建议您阅读[原始文章](https://blog.miguelgrinberg.com/post/video-streaming-with-flask)以熟悉我的项目。简而言之，这是一个 Flask 服务器，它使用流式响应来提供从 Motion JPEG 格式的摄像机捕获的视频帧流。这种格式非常简单，虽然并不是最有效的，它具有以下优点：所有浏览器都原生支持它，无需任何客户端脚本。出于这个原因，它是安防摄像机使用的一种相当常见的格式。为了演示服务器，我使用相机模块为树莓派编写了一个相机驱动程序。对于那些没有没有树莓派，只有手持相机的人，我还写了一个模拟的相机驱动程序，它可以传输存储在磁盘上的一系列 jpeg 图像。

## 仅在有观看者时运行相机

人们不喜欢的原始流媒体服务器的一个原因是，当第一个客户端连接到流时，从树莓派的摄像头捕获视频帧的后台线程就开始了，但之后它永远不会停止。处理此后台线程的一种更有效的方法是仅在有查看者的情况下使其运行，以便在没有人连接时可以关闭相机。

我刚刚实施了这项改进。这个想法是，每次客户端访问视频帧时，都会记录该访问的当前时间。相机线程检查此时间戳，如果发现它超过十秒，则退出。通过此更改，当服务器在没有任何客户端的情况下运行十秒钟时，它将关闭其相机并停止所有后台活动。一旦客户端再次连接，线程就会重新启动。

以下是对这项改进的简要说明：

```
class Camera(object):
    # ...
    last_access = 0  # 最后一个客户端访问相机的时间

    # ...

    def get_frame(self):
        Camera.last_access = time.time()
        # ...

    @classmethod
    def _thread(cls):
        with picamera.PiCamera() as camera:
            # ...
            for foo in camera.capture_continuous(stream, 'jpeg', use_video_port=True):
                # ...
                # 如果没有任何客户端访问视屏帧
                # 10 秒钟之后停止线程
                if time.time() - cls.last_access > 10:
                    break
        cls.thread = None
```

## 简化相机类

很多人向我提到的一个常见问题是很难添加对其他相机的支持。我为树莓派实现的 `Camera` 类相当复杂，因为它使用后台捕获线程与相机硬件通信。

为了使它更容易，我决定将对于帧的所有后台处理的通用功能移动到基类，只留下从相机获取帧以在子类中实现的任务。模块 `base_camera.py` 中的新 `BaseCamera` 类实现了这个基类。以下是这个通用线程的样子：

```
class BaseCamera(object):
    thread = None  # 从摄像机读取帧的后台线程
    frame = None  # 后台线程将当前帧存储在此
    last_access = 0  # 最后一个客户端访问摄像机的时间
    # ...

    @staticmethod
    def frames():
        """Generator that returns frames from the camera."""
        raise RuntimeError('Must be implemented by subclasses.')

    @classmethod
    def _thread(cls):
        """Camera background thread."""
        print('Starting camera thread.')
        frames_iterator = cls.frames()
        for frame in frames_iterator:
            BaseCamera.frame = frame

            # 如果没有任何客户端访问视屏帧
            # 10 秒钟之后停止线程
            if time.time() - BaseCamera.last_access > 10:
                frames_iterator.close()
                print('Stopping camera thread due to inactivity.')
                break
        BaseCamera.thread = None
```

这个新版本的树莓派的相机线程使用了另一个生成器而变得通用了。线程期望 `frames()` 方法（这是一个静态方法）成为一个生成器，这个生成器在特定的不同摄像机的子类中实现。迭代器返回的每个项目必须是 jpeg 格式的视频帧。

以下展示的是返回静态图像的模拟摄像机如何适应此基类：

```
class Camera(BaseCamera):
    """模拟相机的实现过程，将
     文件1.jpg，2.jpg和3.jpg形成的重复序列以每秒一帧的速度以流式文件的形式传输。"""
    imgs = [open(f + '.jpg', 'rb').read() for f in ['1', '2', '3']]

    @staticmethod
    def frames():
        while True:
            time.sleep(1)
            yield Camera.imgs[int(time.time()) % 3]
```

注意在这个版本中，`frames()` 生成器如何通过简单地在帧之间休眠来形成每秒一帧的速率。

通过重新设计，树莓派相机的相机子类也变得更加简单：

```
import io
import picamera
from base_camera import BaseCamera

class Camera(BaseCamera):
    @staticmethod
    def frames():
        with picamera.PiCamera() as camera:
            # let camera warm up
            time.sleep(2)

            stream = io.BytesIO()
            for foo in camera.capture_continuous(stream, 'jpeg', use_video_port=True):
                # return current frame
                stream.seek(0)
                yield stream.read()

                # reset stream for next frame
                stream.seek(0)
                stream.truncate()
```

## OpenCV 相机驱动

很多用户抱怨他们无法访问配备相机模块的树莓派，因此除了模拟相机之外，他们无法尝试使用此服务器。现在添加相机驱动程序要容易得多，我想要一个基于 [OpenCV](http://opencv.org/) 的相机，它支持大多数 USB 网络摄像头和笔记本电脑相机。这是一个简单的相机驱动程序：

```
import cv2
from base_camera import BaseCamera

class Camera(BaseCamera):
    @staticmethod
    def frames():
        camera = cv2.VideoCapture(0)
        if not camera.isOpened():
            raise RuntimeError('Could not start camera.')

        while True:
            # 读取当前帧
            _, img = camera.read()

            # 编码成一个 jpeg 图片并且返回
            yield cv2.imencode('.jpg', img)[1].tobytes()
```

使用此类，将使用您系统检测到的第一台摄像机。如果您使用的是笔记本电脑，这可能是您的内置摄像头。如果要使用此驱动程序，则需要为 Python 安装 OpenCV 绑定：

```
$ pip install opencv-python
```

## 相机选择

该项目现在支持三种不同的摄像头驱动程序：模拟、树莓派和 OpenCV。为了更容易选择使用哪个驱动程序而不必编辑代码，Flask 服务器查找 `CAMERA` 环境变量以了解要导入的类。此变量可以设置为 `pi` 或 `opencv`，如果未设置，则默认使用模拟摄像机。

实现它的方式非常通用。无论 `CAMERA` 环境变量的值是什么，服务器都希望驱动程序位于名为 `camera_$CAMERA.py` 的模块中。服务器将导入该模块，然后在其中查找 `Camera`类。逻辑实际上非常简单：

```
from importlib import import_module
import os

# import camera driver
if os.environ.get('CAMERA'):
    Camera = import_module('camera_' + os.environ['CAMERA']).Camera
else:
    from camera import Camera
```

例如，要从 bash 启动 OpenCV 会话，你可以执行以下操作：

```
$ CAMERA=opencv python app.py
```

使用 Windows 命令提示符，你可以执行以下操作：

```
$ set CAMERA=opencv
$ python app.py
```

## 性能优化

在另外几次观察中，我们发现服务器消耗了大量的 CPU。其原因在于后台线程捕获帧与将这些帧回送到客户端的生成器之间没有同步。两者都尽可能快地运行，而不考虑另一方的速度。

通常，后台线程尽可能快地运行是有道理的，因为你希望每个客户端的帧速率尽可能高。但是你绝对不希望向客户端提供帧的生成器以比生成帧的相机更快的速度运行，因为这意味着将重复的帧发送到客户端。虽然这些重复项不会导致任何问题，但它们除了增加 CPU 和网络负载之外没有任何好处。

因此需要一种机制，通过该机制，生成器仅将原始帧传递给客户端，并且如果生成器内的传送回路比相机线程的帧速率快，则生成器应该等待直到新帧可用，所以它应该自行调整以匹配相机速率。另一方面，如果传送回路以比相机线程更慢的速率运行，那么它在处理帧时永远不应该落后，而应该跳过某些帧以始终传递最新的帧。听起来很复杂吧？

我想要的解决方案是，当新帧可用时，让相机线程信号通知生成器运行。然后，生成器可以在它们传送下一帧之前等待信号时阻塞。在查看同步单元时，我发现 [threading.Event](https://docs.python.org/3.6/library/threading.html#event-objects) 是匹配此行为的函数。所以，基本上每个生成器都应该有一个事件对象，然后摄像机线程应该发出信号通知所有活动事件对象，以便在新帧可用时通知所有正在运行的生成器。生成器传递帧并重置其事件对象，然后等待它们再次进行下一帧。

为了避免在生成器中添加事件处理逻辑，我决定实现一个自定义事件类，该事件类使用调用者的线程 id 为每个客户端线程自动创建和管理单独的事件。说实话，这有点复杂，但这个想法来自于 Flask 的上下文局部变量是如何实现的。新的事件类称为 `CameraEvent`，并具有 `wait()`、`set()` 和 `clear()` 方法。在此类的支持下，可以将速率控制机制添加到 `BaseCamera` 类：

```
class CameraEvent(object):
    # ...

class BaseCamera(object):
    # ...
    event = CameraEvent()

    # ...

    def get_frame(self):
        """返回相机的当前帧."""
        BaseCamera.last_access = time.time()

        # wait for a signal from the camera thread
        BaseCamera.event.wait()
        BaseCamera.event.clear()

        return BaseCamera.frame

    @classmethod
    def _thread(cls):
        # ...
        for frame in frames_iterator:
            BaseCamera.frame = frame
            BaseCamera.event.set()  # send signal to clients

            # ...
```

在 `CameraEvent` 类中完成的魔法操作使多个客户端能够单独等待新的帧。`wait()` 方法使用当前线程 id 为每个客户端分配单独的事件对象并等待它。`clear()` 方法将重置与调用者的线程 id 相关联的事件，以便每个生成器线程可以以它自己的速度运行。相机线程调用的 `set()` 方法向分配给所有客户端的事件对象发送信号，并且还将删除未提供服务的任何事件，因为这意味着与这些事件关联的客户端已关闭，客户端本身也不存在了。您可以在 [GitHub 仓库](https://github.com/miguelgrinberg/flask-video-streaming/blob/master/base_camera.py)中看到 `CameraEvent` 类的实现。

为了让您了解性能改进的程度，请看一下，模拟相机驱动程序在此更改之前消耗了大约 96％ 的 CPU，因为它始终以远高于每秒生成一帧的速率发送重复帧。在这些更改之后，相同的流消耗大约 3％ 的CPU。在这两种情况下，都只有一个客户端查看视频流。OpenCV 驱动程序从单个客户端的大约 45％ CPU 降低到 12％，每个新客户端增加约 3％。

## 部署 Web 服务器

最后，我认为如果您打算真正使用此服务器，您应该使用比 Flask 附带的服务器更强大的 Web服务器。一个很好的选择是使用 Gunicorn：

```
$ pip install gunicorn
```

有了 Gunicorn，您可以按如下方式运行服务器（请记住首先将 `CAMERA` 环境变量设置为所选的摄像头驱动程序）：

```
$ gunicorn --threads 5 --workers 1 --bind 0.0.0.0:5000 app:app
```

`--threads 5` 选项告诉 Gunicorn 最多处理五个并发请求。这意味着设置了这个值之后，您最多可以同时拥有五个客户端来观看视频流。`--workers 1` 选项将服务器限制为单个进程。这是必需的，因为只有一个进程可以连接到摄像头以捕获帧。

您可以增加一些线程数，但如果您发现需要大量线程，则使用异步框架比使用线程可能会更有效。可以将 Gunicorn 配置为使用与 Flask 兼容的两个框架：gevent 和 eventlet。为了使视频流服务器能够使用这些框架，相机后台线程还有一个小的补充：

```
class BaseCamera(object):
    # ...
   @classmethod
    def _thread(cls):
        # ...
        for frame in frames_iterator:
            BaseCamera.frame = frame
            BaseCamera.event.set()  # send signal to clients
            time.sleep(0)
            # ...
```

这里唯一的变化是在摄像头捕获循环中添加了 `sleep(0)`。这对于 eventlet 和 gevent 都是必需的，因为它们使用协作式多任务处理。这些框架实现并发的方式是让每个任务通过调用执行网络 I/O 的函数或显式执行以释放 CPU。由于此处没有 I/O，因此执行 sleep 函数以实现释放 CPU 的目的。

现在您可以使用 gevent 或 eventlet worker 运行 Gunicorn，如下所示：

```
$ CAMERA=opencv gunicorn --worker-class gevent --workers 1 --bind 0.0.0.0:5000 app:app
```

这里的 `--worker-class gevent` 选项配置 Gunicorn 使用 gevent 框架（你必须用`pip install gevent`安装它）。如果你愿意，也可以使用 `--worker-class eventlet`。如上所述，`--workers 1` 限制为单个处理过程。Gunicorn 中的 eventlet 和 gevent workers 默认分配了一千个并发客户端，所以这应该超过了这种服务器能够支持的客户端数量。

## 结论

上述所有更改都包含在 [GitHub 仓库](https://github.com/miguelgrinberg/flask-video-streaming) 中。我希望你通过这些改进以获得更好的体验。

在结束之前，我想提供有关此服务器的其他问题的快速解答：

*  如何设定服务器以固定的帧速率运行？配置您的相机以该速率传送帧，然后在相机传送回路的每次迭代期间休眠足够的时间以便以该速率运行。

*  如何提高帧速率？我在此描述的服务器，以尽可能快的速率提供视频帧。如果您需要更好的帧速率，可以尝试将相机配置成更小的视频帧。

如何添加声音？那真的很难。Motion JPEG 格式不支持音频。你将需要使用单独的流传输音频，然后将音频播放器添加到 HTML 页面。即使你设法完成了所有的操作，音频和视频之间的同步也不会非常准确。

如何将流保存到服务器上的磁盘中？只需将 JPEG 文件的序列保存在相机线程中即可。为此，你可能希望移除在没有查看器时结束后台线程的自动机制。

如何将播放控件添加到视频播放器？Motion JPEG 不允许用户进行交互式操作，但如果你想要这个功能，只需要一点点技巧就可以实现播放控制。如果服务器保存所有 jpeg 图像，则可以通过让服务器一遍又一遍地传送相同的帧来实现暂停。当用户恢复播放时，服务器将必须提供从磁盘加载的“旧”图像，因为现在用户处于 DVR 模式而不是实时观看流。这可能是一个非常有趣的项目！

以上就是本文的所有内容。如果你有其他问题，请告诉我们！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
