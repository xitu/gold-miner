> * 原文地址：[Send HTTP Requests As Fast As Possible in Python](https://python.plainenglish.io/send-http-requests-as-fast-as-possible-in-python-304134d46604)
> * 原文作者：[Andrew Zhu](https://medium.com/@xhinker)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/send-http-requests-as-fast-as-possible-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2021/send-http-requests-as-fast-as-possible-in-python.md)
> * 译者：
> * 校对者：

# Send HTTP Requests As Fast As Possible in Python

#### Use Python’s synchronous, multi-threading, queue, and asyncio event loop to make 100 HTTP requests and see which solution performs the best.

![Who dives faster? by Charles Zhu, my 6yo boy](https://cdn-images-1.medium.com/max/2312/1*EzgpOKoso264gwJa5-r_9w.png)

It is easy to send a single HTTP request by using the `requests `package. What if I want to send hundreds or even millions of HTTP requests asynchronously? This article is an exploring note to find my fastest way to send HTTP requests.

The code is running in a Linux(Ubuntu) VM host in the cloud with Python 3.7. All code in gist is ready for copy and run.

## Solution #1: The Synchronous Way

The most simple, easy-to-understand way, but also the slowest way. I forge 100 links for the test by this magic python list operator:

```
url_list = ["https://www.google.com/","https://www.bing.com"]*50
```

The code:

```Python
import requests
import time

def download_link(url:str) -> None:
    result = requests.get(url).content
    print(f'Read {len(result)} from {url}')
def download_all(urls:list) -> None:
    for url in urls:
        download_link(url)
        
url_list = ["https://www.google.com/","https://www.bing.com"]*50
start = time.time()
download_all(url_list)
end = time.time()
print(f'download {len(url_list)} links in {end - start} seconds')
```

It takes about 10 seconds to finish downloading 100 links.

```
...
download 100 links in 9.438416004180908 seconds
```

As a synchronous solution, there are still rooms to improve. We can leverage the `Session` object to further increase the speed. The Session object will use urllib3’s connection pooling, which means, for repeating requests to the same host, the `Session `object’s underlying TCP connection will be re-used, hence gain a performance increase.

> So if you’re making several requests to the same host, the underlying TCP connection will be reused, which can result in a significant performance increase — [Session Objects](https://docs.python-requests.org/en/master/user/advanced/)

To ensure the request object exit no matter success or not, I am going to use the `with `statement as a wrapper. the `with`keyword in Python is just a clean solution to replace `try… finally… `.

Let’s see how many seconds are saved by changing to this:

```Python
import requests
from requests.sessions import Session
import time

url_list = ["https://www.google.com/","https://www.bing.com"]*50

def download_link(url:str,session:Session):
    with session.get(url) as response:
        result = response.content
        print(f'Read {len(result)} from {url}')

def download_all(urls:list):
    with requests.Session() as session:
        for url in urls:
            download_link(url,session=session)

start = time.time()
download_all(url_list)
end = time.time()
print(f'download {len(url_list)} links in {end - start} seconds')
```

Looks like the performance is really boosted to 5.x seconds.

```
...
download 100 links in 5.367443561553955 seconds
```

But this is still slow, let’s try the multi-threading solution

## Solution #2: The Multi-Threading Way

Python threading is a dangerous topic to discuss, sometimes, multi-threading could be even slower! David Beazley brought with gut delivered a wonderful presentation to cover this dangerous topic. here is the Youtube [link](https://docs.python-requests.org/en/master/user/advanced/).

Anyway, I am still going to use Python Thread to do the HTTP request job. I will use a queue to hold the 100 links and create 10 HTTP download worker threads to consume the 100 links asynchronously.

![How the multi-thread works](https://cdn-images-1.medium.com/max/2994/1*JfPvverf5eScyBkQQ6NOqw.png)

To use the Session object, it is a waste to create 10 Session objects for 10 threads, I want one Session object and reuse it for all downloading work. To make it happen, The code will leverage the `local `object from `threading `package, so that 10 thread workers will share one Session object.

```
from threading import Thread,local
...
thread_local = local()
...
```

The code:

```Python
import requests
from requests.sessions import Session
import time
from threading import Thread,local
from queue import Queue

url_list = ["https://www.google.com/","https://www.bing.com"]*50
q = Queue(maxsize=0)            #Use a queue to store all URLs
for url in url_list:
    q.put(url)
thread_local = local()          #The thread_local will hold a Session object

def get_session() -> Session:
    if not hasattr(thread_local,'session'):
        thread_local.session = requests.Session() # Create a new Session if not exists
    return thread_local.session

def download_link() -> None:
    '''download link worker, get URL from queue until no url left in the queue'''
    session = get_session()
    while True:
        url = q.get()
        with session.get(url) as response:
            print(f'Read {len(response.content)} from {url}')
        q.task_done()          # tell the queue, this url downloading work is done

def download_all(urls) -> None:
    '''Start 10 threads, each thread as a wrapper of downloader'''
    thread_num = 10
    for i in range(thread_num):
        t_worker = Thread(target=download_link)
        t_worker.start()
    q.join()                   # main thread wait until all url finished downloading

print("start work")
start = time.time()
download_all(url_list)
end = time.time()
print(f'download {len(url_list)} links in {end - start} seconds')
```

The result:

```
...
download 100 links in 1.1333789825439453 seconds
```

This is fast! way faster than the synchronous solution.

## Solution #3: Multi-Threading by ThreadPoolExecutor

Python also provides `ThreadPoolExecutor `to perform multi-thread work, I like ThreadPoolExecutor a lot.

In the Thread and Queue version, there is a `while True` loop in the HTTP request worker, this makes the worker function tangled with Queue and needs additional code change from the synchronous version to the asynchronous version.

Using ThreadPoolExecutor, and its map function, we can create a Multi-Thread version with very concise code, require minimum code change from the synchronous version.

![How the ThreadPoolExecutor version works](https://cdn-images-1.medium.com/max/2676/1*21PJpOn4vMaFCgJPn1CDbQ.png)

The code:

```Python
import requests
from requests.sessions import Session
import time
from concurrent.futures import ThreadPoolExecutor
from threading import Thread,local

url_list = ["https://www.google.com/","https://www.bing.com"]*50
thread_local = local()

def get_session() -> Session:
    if not hasattr(thread_local,'session'):
        thread_local.session = requests.Session()
    return thread_local.session

def download_link(url:str):
    session = get_session()
    with session.get(url) as response:
        print(f'Read {len(response.content)} from {url}')

def download_all(urls:list) -> None:
    with ThreadPoolExecutor(max_workers=10) as executor:
        executor.map(download_link,url_list)

start = time.time()
download_all(url_list)
end = time.time()
print(f'download {len(url_list)} links in {end - start} seconds')
```

And the output is as fast as the Thread-Queue version:

```
...
download 100 links in 1.0798051357269287 seconds
```

## Solution #4: asyncio with aiohttp

Everyone says `asyncio `is the future, and it is fast. Some folks use it [making 1 million HTTP requests with Python `asyncio `and `aiohttp`](https://pawelmhm.github.io/asyncio/python/aiohttp/2016/04/22/asyncio-aiohttp.html). Although `asyncio `is super fast, it uses **zero** Python Multi-Threading.

Believe it or not, asyncio runs in one thread, in one CPU core.

![asyncio Event Loop](https://cdn-images-1.medium.com/max/3490/1*yByf16mv2X7XaaTX4oQFaA.png)

The event loop implemented in `asyncio `is almost the same thing that is beloved in Javascript.

Asyncio is so fast that it can send almost any number of requests to the server, the only limitation is your machine and internet bandwidth.

Too many HTTP requests send will behave like “attacking”. Some web site may ban your IP address if too many requests are detected, even Google will ban you too. To avoid being banned, I use a custom TCP connector object that specified the max TCP connection to 10 only. (it may safe to change it to 20)

```
my_conn = aiohttp.TCPConnector(limit=10)
```

The code is pretty short and concise:

```Python
import asyncio
import time 
import aiohttp
from aiohttp.client import ClientSession

async def download_link(url:str,session:ClientSession):
    async with session.get(url) as response:
        result = await response.text()
        print(f'Read {len(result)} from {url}')

async def download_all(urls:list):
    my_conn = aiohttp.TCPConnector(limit=10)
    async with aiohttp.ClientSession(connector=my_conn) as session:
        tasks = []
        for url in urls:
            task = asyncio.ensure_future(download_link(url=url,session=session))
            tasks.append(task)
        await asyncio.gather(*tasks,return_exceptions=True) # the await must be nest inside of the session

url_list = ["https://www.google.com","https://www.bing.com"]*50
print(url_list)
start = time.time()
asyncio.run(download_all(url_list))
end = time.time()
print(f'download {len(url_list)} links in {end - start} seconds')
```

And the above code finished 100 links downloading in 0.74 seconds!

```
...
download 100 links in 0.7412574291229248 seconds
```

Note that if you are running code in JupyterNotebook or IPython. please also install the`nest-asyncio` package. (Thanks to [this StackOverflow link](https://stackoverflow.com/questions/46827007/runtimeerror-this-event-loop-is-already-running-in-python). Credit to [Diaf Badreddine](https://stackoverflow.com/users/12371243/diaf-badreddine).)

```
pip install nest-asyncio
```

and add the following two lines of code at the beginning of the code.

```
import nest_asyncio
nest_asyncio.apply()
```

## Solution #5: What about NodeJS?

I am wondering, what if I do the same work in Nodejs, which has a built-in event loop?

Here is the full code.

```JavaScript
const requst = require('request')
//build a 100 links array
url_list = []
url_list.push(...Array(50).fill("https://www.google.com"))
url_list.push(...Array(50).fill("https://www.bing.com"))

const batch_num = 10;     // send 10 Http requesta at one time
let batch_index = batch_num;
let resolvehandler = null;
function download_link(url){
    requst({
        url: url,
        timeout:1000
    },function(error,response,body){
        if (body){
            console.log(body.length)
        }
        batch_index = batch_index -1
        if(batch_index==0){
            batch_index = batch_num
            resolvehandler()
        }
    });
}

function download_batch(url_list){
    for(j = 0;j<batch_num;j++){
        download_link(url_list[j])
    }
}

async function download_all(url_list){
    let loop_count = url_list.length/batch_num;
    console.time('test')
    for(var i =0;i<loop_count;i++){
        await new Promise(function(resolve,reject){
            download_batch(url_list.slice(i,i+10))
            resolvehandler = resolve
        })
    }
    console.timeEnd('test')
}

download_all(url_list)
```

It takes 1.1 to 1.5 seconds, you can give it a run to see the result in your machine.

```
...
test: 1195.290ms
```

Python, win the speed game!

(Looks like the request Node package is [deprecated](https://github.com/request/request/issues/3142), but this sample is just for testing out how NodeJs’s event loop performs compare with Python’s event loop.)

---

Let me know if you have a better/faster solution. If you have any questions, leave a comment and I will do my best to answer, If you spot an error or mistake, don’t hesitate to mark them out. Thanks for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
