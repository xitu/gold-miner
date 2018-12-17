> * 原文地址：[Flask Video Streaming Revisited](https://blog.miguelgrinberg.com/post/flask-video-streaming-revisited)
> * 原文作者：[Miguel Grinberg](Miguel Grinberg)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flask-video-streaming-revisited.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flask-video-streaming-revisited.md)
> * 译者：
> * 校对者：

# Flask Video Streaming Revisited

![](https://blog.miguelgrinberg.com/static/images/video-streaming-revisited.jpg)

Almost three years ago I wrote an article on this blog titled [Video Streaming with Flask](https://juejin.im/post/5bea86fc518825158c531e9c), in which I presented a very modest streaming server that used a Flask generator view function to stream a [Motion-JPEG](https://en.wikipedia.org/wiki/Motion_JPEG) stream to web browsers. My intention with that article was to show a simple, yet practical use of [streaming responses](http://flask.pocoo.org/docs/0.12/patterns/streaming/), a not very well known feature in Flask.

That article is extremely popular, but not because it teaches how to implement streaming responses, but because a lot of people want to implement streaming video servers. Unfortunately, my focus when I wrote the article was not on creating a robust video server, so I frequently get questions and requests for advice from those who want to use the video server for a real application and quickly find its limitations. So today I'm going to revisit my streaming video server and describe a few improvements I've made to it.

## Recap: Using Flask's Streaming for Video

I recommend you read the [original article](https://blog.miguelgrinberg.com/post/video-streaming-with-flask) to familiarize yourself with my project. In short, this is a Flask server that uses a streaming response to provide a stream of video frames captured from a camera in Motion JPEG format. This format is very simple and not the most efficient, but has the advantage that all browsers support it natively and without any client-side scripting required. It is a fairly common format used by security cameras for that reason. To demonstrate the server, I implemented a camera driver for a Raspberry Pi with its camera module. For those that didn't have a Pi with a camera at hand, I also wrote an emulated camera driver that streams a sequence of jpeg images stored on disk.

## Running the Camera Only When There Are Viewers

One aspect of the original streaming server that people did not like is that the background thread that captures video frames from the Raspberry Pi camera starts when the first client connects to the stream, but then it never stops. A more efficient way to handle this background thread is to only have it running while there are viewers, so that the camera can be turned off when nobody is connected.

I implemented this improvement a while ago. The idea is that every time a frame is accessed by a client the current time of that access is recorded. The camera thread checks this timestamp and if it finds it is more than ten seconds old it exits. With this change, when the server runs for ten seconds without any clients it will shut its camera off and stop all background activity. As soon as a client connects again the thread is restarted.

Here is a brief description of the changes:

```
class Camera(object):
    # ...
    last_access = 0  # time of last client access to the camera

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
                # if there hasn't been any clients asking for frames in
                # the last 10 seconds stop the thread
                if time.time() - cls.last_access > 10:
                    break
        cls.thread = None
```

## Simplifying the Camera Class

A common problem that a lot of people mentioned to me is that it is hard to add support for other cameras. The `Camera` class that I implemented for the Raspberry Pi is fairly complex because it uses a background capture thread to talk to the camera hardware.

To make this easier, I decided to move the generic functionality that does all the background processing of frames to a base class, leaving only the task of getting the frames from the camera to implement in subclasses. The new `BaseCamera` class in module `base_camera.py` implements this base class. Here is what this generic thread looks like:

```
class BaseCamera(object):
    thread = None  # background thread that reads frames from camera
    frame = None  # current frame is stored here by background thread
    last_access = 0  # time of last client access to the camera
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

            # if there hasn't been any clients asking for frames in
            # the last 10 seconds then stop the thread
            if time.time() - BaseCamera.last_access > 10:
                frames_iterator.close()
                print('Stopping camera thread due to inactivity.')
                break
        BaseCamera.thread = None
```

This new version of the Raspberry Pi's camera thread has been made generic with the use of yet another generator. The thread expects the `frames()` method (which is a static method) to be a generator implemented in subclasses that are specific to different cameras. Each item returned by the iterator must be a video frame, in jpeg format.

Here is how the emulated camera that returns static images can be adapted to work with this base class:

```
class Camera(BaseCamera):
    """An emulated camera implementation that streams a repeated sequence of
    files 1.jpg, 2.jpg and 3.jpg at a rate of one frame per second."""
    imgs = [open(f + '.jpg', 'rb').read() for f in ['1', '2', '3']]

    @staticmethod
    def frames():
        while True:
            time.sleep(1)
            yield Camera.imgs[int(time.time()) % 3]
```

Note how in this version the `frames()` generator forces a frame rate of one frame per second by simply sleeping that amount between frames.

The camera subclass for the Raspberry Pi camera also becomes much simpler with this redesign:

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

## OpenCV Camera Driver

A fair number of users complained that they did not have access to a Raspberry Pi equipped with a camera module, so they could not try this server with anything other than the emulated camera. Now that adding camera drivers is much easier, I wanted to also have a camera based on [OpenCV](http://opencv.org/), which supports most USB webcams and laptop cameras. Here is a simple camera driver for it:

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
            # read current frame
            _, img = camera.read()

            # encode as a jpeg image and return it
            yield cv2.imencode('.jpg', img)[1].tobytes()
```

With this class, the first video camera reported by your system will be used. If you are using a laptop, this is likely your internal camera. If you are going to use this driver, you need to install the OpenCV bindings for Python:

```
$ pip install opencv-python
```

## Camera Selection

The project now supports three different camera drivers: emulated, Raspberry Pi and OpenCV. To make it easier to select which driver to use without having to edit the code, the Flask server looks for a `CAMERA` environment variable to know which class to import. This variable can be set to `pi` or `opencv`, and if it isn't set, then the emulated camera is used by default.

The way this is implemented is fairly generic. Whatever the value of the `CAMERA` environment variable is, the server will expect the driver to be in a module named `camera_$CAMERA.py`. The server will import this module and then look for a `Camera` class in it. The logic is actually quite simple:

```
from importlib import import_module
import os

# import camera driver
if os.environ.get('CAMERA'):
    Camera = import_module('camera_' + os.environ['CAMERA']).Camera
else:
    from camera import Camera
```

For example, to start an OpenCV session from bash, you can do this:

```
$ CAMERA=opencv python app.py
```

From a Windows command prompt you can do the same as follows:

```
$ set CAMERA=opencv
$ python app.py
```

## Performance Improvements

Another observation that was made a few times is that the server consumes a lot of CPU. The reason for this is that there is no synchronization between the background thread capturing frames and the generator feeding those frames to the client. Both run as fast as they can, without regards for the speed of the other.

In general it makes sense for the background thread to run as fast as possible, because you want the frame rate to be as high as possible for each client. But you definitely do not want the generator that delivers frames to a client to ever run at a faster rate than the camera is producing frames, because that would mean duplicate frames will be sent to the client. While these duplicates do not cause any problems, they increase CPU and network usage without any benefit.

So there needs to be a mechanism by which the generator only delivers original frames to the client, and if the delivery loop inside the generator is faster than the frame rate of the camera thread, then the generator should wait until a new frame is available, so that it paces itself to match the camera rate. On the other side, if the delivery loop runs at a slower rate than the camera thread, then it should never get behind when processing frames, and instead it should skip frames to always deliver the most current frame. Sounds complicated, right?

What I wanted as a solution here is to have the camera thread signal the generators that are running when a new frame is available. The generators can then block while they wait for the signal before they deliver the next frame. In looking through synchronization primitives, I've found that [threading.Event](https://docs.python.org/3.6/library/threading.html#event-objects) is the one that matches this behavior. So basically, each generator should have an event object, and then the camera thread should signal all the active event objects to inform all the running generators when a new frame is available. The generators deliver the frame and reset their event objects, and then go back to wait on them again for the next frame.

To avoid having to add event handling logic in the generator, I decided to implement a customized event class that uses the thread id of the caller to automatically create and manage a separate event for each client thread. This is somewhat complex, to be honest, but the idea came from how Flask's context local variables are implemented. The new event class is called `CameraEvent`, and has `wait()`, `set()`, and `clear()` methods. With the support of this class, the rate control mechanism can be added to the `BaseCamera` class:

```
class CameraEvent(object):
    # ...

class BaseCamera(object):
    # ...
    event = CameraEvent()

    # ...

    def get_frame(self):
        """Return the current camera frame."""
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

The magic that is done in the `CameraEvent` class enables multiple clients to be able to wait individually for a new frame. The `wait()` method uses the current thread id to allocate an individual event object for each client and wait on it. The `clear()` method will reset the event associated with the caller's thread id, so that each generator thread can run at its own speed. The `set()` method called by the camera thread sends a signal to the event objects allocated for all clients, and will also remove any events that aren't being serviced by their owners, because that means that the clients associated with those events have closed the connection and are gone. You can see the implementation of the `CameraEvent` class in the [GitHub repository](https://github.com/miguelgrinberg/flask-video-streaming/blob/master/base_camera.py).

To give you an idea of the magnitude of the performance improvement, consider that the emulated camera driver consumed about 96% CPU before this change because it was constantly sending duplicate frames at a rate much higher than the one frame per second being produced. After these changes, the same stream consumes about 3% CPU. In both cases there was a single client viewing the stream. The OpenCV driver went from about 45% CPU down to 12% for a single client, with each new client adding about 3%.

## Production Web Server

Lastly, I think if you plan to use this server for real, you should use a more robust web server than the one that comes with Flask. A very good choice is to use Gunicorn:

```
$ pip install gunicorn
```

With Gunicorn, you can run the server as follows (remember to set the `CAMERA` environment variable to the selected camera driver first):

```
$ gunicorn --threads 5 --workers 1 --bind 0.0.0.0:5000 app:app
```

The `--threads 5` option tells Gunicorn to handle at most five concurrent requests. That means that with this number you can get up to five clients to watch the stream simultaneously. The `--workers 1` options limits the server to a single process. This is required because only one process can connect to a camera to capture frames.

You can increase the number of threads some, but if you find that you need a large number, it will probably be more efficient to use an asynchronous framework instead of threads. Gunicorn can be configured to work with the two frameworks that are compatible with Flask: gevent and eventlet. To make the video streaming server work with these frameworks, there is one small addition to the camera background thread:

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

The only change here is the addition of a `sleep(0)` in the camera capture loop. This is required for both eventlet and gevent, because they use cooperative multitasking. The way these frameworks achieve concurrency is by having each task release the CPU either by calling a function that does network I/O or explicitly. Since there is no I/O here, the sleep call is what achieves the CPU release.

Now you can run Gunicorn with the gevent or eventlet workers as follows:

```
$ CAMERA=opencv gunicorn --worker-class gevent --workers 1 --bind 0.0.0.0:5000 app:app
```

Here the `--worker-class gevent` option configures Gunicorn to use the gevent framework (you must install it with `pip install gevent`). If you prefer, `--worker-class eventlet` is also available. The `--workers 1` limits to a single process as above. The eventlet and gevent workers in Gunicorn allocate a thousand concurrent clients by default, so that should be much more than what a server of this kind is able to support anyway.

## Conclusion

All the changes described above are incorporated in the [GitHub repository](https://github.com/miguelgrinberg/flask-video-streaming). I hope you get a better experience with these improvements.

Before concluding, I want to provide quick answers to other questions I have received about this server:

*   How to force the server to run at a fixed frame rate? Configure your camera to deliver frames at that rate, then sleep enough time during each iteration of the camera capture loop to also run at that rate.

*   How to increase the frame rate? The server as described here delivers frames as fast as possible. If you need better frame rates, you can try configuring your camera for a smaller frame size.

*   How to add sound? That's really difficult. The Motion JPEG format does not support audio. You are going to need to stream the audio separately, and then add an audio player to the HTML page. Even if you manage to do all this, synchronization between audio and video is not going to be very accurate.

*   How to save the stream to disk on the server? Just save the sequence of JPEG files in the camera thread. For this you may want to remove the automatic mechanism that ends the background thread when there are no viewers.

*   How to add playback controls to the video player? Motion JPEG was not made for interactive operation by the user, but if you are set on doing this, with a little bit of trickery it may be possible to implement playback controls. If the server saves all jpeg images, then a pause can be implemented by having the server deliver the same frame over and over. When the user resumes playback, the server will have to deliver "old" images that are loaded from disk, since now the user would be in DVR mode instead of watching the stream live. This could be a very interesting project!

That is all for now. If you have other questions please let me know!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
