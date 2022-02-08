> * 原文地址：[Speed Up Your Python Code With 100% Thread Utilization Using This Library](https://betterprogramming.pub/speed-up-your-python-code-with-100-thread-utilization-using-this-library-31378a45f0ec)
> * 原文作者：[Haseeb Kamal](https://medium.com/@haseebkamal98)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/speed-up-your-python-code.md](https://github.com/xitu/gold-miner/blob/master/article/2022/speed-up-your-python-code.md)
> * 译者：
> * 校对者：

# Speed Up Your Python Code With 100% Thread Utilization Using This Library

![](https://miro.medium.com/max/1400/0*oZRuzTJK7hDpZ_-E)

Python has many web frameworks the most popular being Django and Flask. I am most familiar with Flask myself and used it extensively to build hobby projects and improve my programming skills.

However, as with all things in tech, new frameworks are constantly being developed. As a programmer, it is important to be up to date with the latest and greatest of what is out there.

[FastAPI](https://fastapi.tiangolo.com/) is a web framework for Python and in many ways resembles the simplicity of Flask. What makes FastAPI different is that it runs on ASGI web servers (such as uvicorn) while Flask only runs on WSGI web servers. This difference can result in a huge performance gap.

ASGI is an emerging trend in Python so it is important that you learn about it. Developing high-performance Python applications becomes super easy with FastAPI and ASGI. We will see how you can develop a simple API in FastAPI and then we will benchmark it against Flask to see exactly how much faster it is.

Let's get onto it!

First, a quick introduction to WSGI vs. ASGI.

# WSGI vs. ASGI

WSGI stands for Web Server Gateway Interface. Put simply, this piece of software sits between a webserver (like nginx) and your Python web framework (like Flask). It specifies how the web server should forward requests to the web framework. WSGI was first released in 2003 so you can imagine how old it is. WSGI is inherently synchronous. This can result in slow execution.

ASGI stands for Asynchronous Server Gateway Interface. ASGI is the emerging trend that will replace WSGI. The crucial difference is that ASGI supports web frameworks with asynchronous code. That is, it is inherently asynchronous. This can speed up execution if your code is asynchronous (i.e. if it uses `async await`)

Confused? No worries. Here's a short illustration to highlight the difference between synchronous and asynchronous execution.

![](https://miro.medium.com/max/1400/0*s2OdGt1kp2_3FNVR.png)

> Synchronous vs asynchronous execution. Notice the huge time savings with async.

As you can see, in synchronous execution (WSGI) a single thread can only handle one request at a time. So, if the current request has some blocking code where it needs to wait for some results a lot of time is wasted (as can be seen in the waiting block in the diagram above). Only once the entire of task A is finished, can the thread move to task B.

On the other hand, in asynchronous execution (ASGI) a single thread can handle multiple requests. While the execution is waiting on task A the thread can jump on task B and finish it in the time it takes for task A to return. The thread then jumps back to task A and completes it. From the diagram above, we see that we save a lot of time in this way with asynchronous execution. More importantly, with asynchronous execution we are utilizing 100\% of the thread which means *less waiting and more doing*. This results in a huge performance boost for certain applications.

In short: With asynchronous code, threads can do more work in the same amount of time. This results in more work done per unit time. This is where the performance boost comes from.

# Benchmarking

Theory is nice and all but it's much more fun to see a real example illustrating the performance difference.

Begin by installing the following libraries for FastAPI:

```
pip3 install fastapi[all]
```

We use the following code for FastAPI:

```python
import os
from fastapi import FastAPI
import time
import pandas as pd
import pickle
import os
import asyncio
from concurrent.futures import ThreadPoolExecutor
import asyncio
import threading

app = FastAPI()

# @app.on_event("startup")
# async def startup_event():
#     loop = asyncio.get_running_loop()
#     loop.set_default_executor(ThreadPoolExecutor(max_workers=1))

@app.get("/dummy")
async def dummy():
    print(threading.active_count())
    return {"message": "async power"}

@app.get("/")
async def func():
    await helper()
    return {"message": "done"}

async def helper():
    await asyncio.sleep(20)
    # time.sleep(20)
    return heavy_func()

def heavy_func():
    # do stuff
    return "ok"
```

We have two endpoints: the root `/` and a secondary endpoint `dummy`. The root endpoint does some heavy work which we simulate by setting a timer to 20 seconds.

We define the endpoints themselves to be `async` and use the `await` keyword to signal that the thread can go and do other work while this call finishes returning. We also use the sleep function from `asyncio` since it supports `async` and `await`. The `dummy` endpoint simply returns a message.

As you can see defining an API in FastAPI is pretty simple. We just need to initialize a FastAPI app and define the endpoints with the `@app` notation.

The following code is used for Flask:

```python
import os
from fastapi import FastAPI
import time
import pandas as pd
import pickle
import os
import asyncio
from concurrent.futures import ThreadPoolExecutor
import asyncio
import threading

app = FastAPI()

# @app.on_event("startup")
# async def startup_event():
#     loop = asyncio.get_running_loop()
#     loop.set_default_executor(ThreadPoolExecutor(max_workers=1))

@app.get("/dummy")
async def dummy():
    print(threading.active_count())
    return {"message": "async power"}

@app.get("/")
async def func():
    await helper()
    return {"message": "done"}

async def helper():
    await asyncio.sleep(20)
    # time.sleep(20)
    return heavy_func()

def heavy_func():
    # do stuff
    return "ok"
```

The code is identical to the FastAPI one.

The idea is that, we call the root endpoint and while it is waiting for 20 seconds we make a call to the `dummy` endpoint.

Here's the key point: If the interface is asynchronous (ASGI), the call to `dummy` should return immediately.

> Note: We are setting the `threaded` flag to false in Flask because we only want to test single-threaded performance for learning purposes. The key takeaway should still be the same for multi-threaded applications.

Start the FastAPI server with:

```bash
uvicorn tfastapi:app --reload
```

You can check in the console what port it is running on. Default is port `8000`.

Next, open up two terminal windows. (I use PowerShell on Windows, you can also use Git Bash or a Linux or macOS terminal)

In the first one paste the curl command:

```bash
curl http://localhost:8000/
```

In the second one, paste the following curl command to hit the `dummy` endpoint:

```bash
curl http://localhost:8000/dummy
```

Press `Enter` on the first window and then on the second window. You should notice that the request to `dummy` returns almost immediately:

![](https://miro.medium.com/max/1400/0*dn-fLnKEE6QKBmEG.png)

> Immediate return of asynchronous endpoint in FastAPI

If you wait 20 seconds, the call to root should return.

What is happening here? The thread first handles the call to the root. While it is waiting on the sleep function, a call is made to the `dummy/`endpoint. The thread then jumps to handle the request. Once it is handled, the thread returns to handle the root request.

Now let's see what happens in the case of Flask.

You can run the Flask server with:

```bash
py tflask.py
```

It should run on port `5000`.

Next, do as before and copy and paste the curl request to root and then the curl request to `dummy`. Run the root request first and then the other one.

You will notice, the call to `dummy/` does not return immediately! It takes 20 seconds for both requests to return. What is happening here?

Even though the code is asynchronous, Flask uses a WSGI implementation of the server-framework interface. This means the endpoints in Flask are not really asynchronous. We make a request to root and it waits. When we make a second request to the thread *does not* jump to handle that request. It sits and waits for the request to root to be handled. In other words, the code sits and waits for the 20 seconds to be over before doing anything else. In this time period, the thread is doing no work apart from waiting! So inefficient!

# Conclusion

In this post, we got a refresher on synchronous vs. asynchronous code. We also learned about WSGI and ASGI interface implementations.

We learned how FastAPI can help achieve 100\% thread utilization and dramatically speed up slow code.

All you need to do to utilize FastAPI is to use `async` in front of every endpoint and also make sure your code is asynchronous. Actually, I would like to expand on this last point and make some general remarks:

- ASGI is still very new so it might be harder to find documentation for it. It is also less tested when compared to WSGI.
- If you want to gain performance boosts, your code needs to be asynchronous. Not all libraries support this yet. Certain database libraries for Python for example only have synchronous implementations. In such cases, you likely won't get much of a performance boost.
- Lastly, FastAPI supports type hinting and integrates quite well with Pydantic. You can check my post [here ](https://betterprogramming.pub/writing-robust-and-error-free-python-code-using-pydantic-151a135a9ff0)for more on that.

Thank you for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
