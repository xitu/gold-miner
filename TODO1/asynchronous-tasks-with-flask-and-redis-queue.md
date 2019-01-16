> * 原文地址：[Asynchronous Tasks with Flask and Redis Queue](https://testdriven.io/blog/asynchronous-tasks-with-flask-and-redis-queue/)
> * 原文作者：[Michael Herman](https://testdriven.io/authors/herman/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/asynchronous-tasks-with-flask-and-redis-queue.md](https://github.com/xitu/gold-miner/blob/master/TODO1/asynchronous-tasks-with-flask-and-redis-queue.md)
> * 译者：[刘嘉一](https://github.com/lcx-seima)
> * 校对者：[kasheemlew](https://github.com/kasheemlew)

# 在 Flask 中使用 Redis Queue 实现异步任务

![](https://testdriven.io/static/images/blog/flask-rq/aysnc_python_redis.png)

如果你的应用中存在长执行任务，你应当把它们从普通流程中剥离并置于后台执行。

可能你的 web 应用会要求用户在注册时上传头像（图片可能需要被裁剪）和进行邮箱验证。如果你直接在请求处理函数中去加工图片和发送验证邮件，那么终端用户不得不等待这些执行的完成。相反，你更希望把这些任务放到任务队列中，并由一个 worker 线程来处理，这种情况下应用就能立刻响应客户端的请求了。由此一来，终端用户可以在客户端继续其他的操作，你的应用也能被释放去响应其他用户的请求。

这篇文章讲了如何在 Flask 应用中配置 [Redis Queue](http://python-rq.org/)（RQ）来处理长执行任务。

> 当然 Celery 也是一个不错的解决方案。不过相比于 Redis Queue，它会稍显复杂并引入更多的依赖项。

## 目录

- [在 Flask 中使用 Redis Queue 实现异步任务](#asynchronous-tasks-with-flask-and-redis-queue)
  - [目录](#contents)
  - [本文目标](#objectives)
  - [工作流程](#workflow)
  - [项目配置](#project-setup)
  - [任务触发](#trigger-a-task)
  - [Redis Queue](#redis-queue)
  - [任务状态](#task-status)
  - [任务控制台](#dashboard)
  - [结语](#conclusion)

## 本文目标

阅读完本文后，你应当学会：

1.  在 Flask 应用中集成 Redis Queue 并创建相应任务。
2.  使用 Docker 镜像化包含 Flask 和 Redis 的应用。
3.  使用独立的 worker 线程在后台处理长执行任务。
4.  配置[RQ Dashboard](https://github.com/eoranged/rq-dashboard)用于监控任务队列、作业和 worker 线程。
5.  使用 Docker 扩展 worker 线程的数量。

## 工作流程

在本文中，我们的目标是借助 Redis Queue 的能力开发一个能处理长执行任务的 Flask 应用，其中长执行任务的执行独立于普通请求、响应的执行。

1.  终端用户通过 POST 请求服务端创建一个新任务
2.  如图所示，任务队列会增加一个新任务，之后服务端再把任务 id 返回给客户端
3.  创建好的任务会在服务端后台执行，客户端只需使用 AJAX 不断轮询任务状态即可

![Flask 集成 Redis Queue 的调用时序图](https://testdriven.io/static/images/blog/flask-rq/flask-rq-flow.png)

最终我们将实现一个如下所示的应用：

![开发完成](https://testdriven.io/static/images/blog/flask-rq/app.gif)

## 项目配置

想要继续看下去吗？clone 下面的仓库来看看里面的代码和结构吧：

```
$ git clone https://github.com/mjhea0/flask-redis-queue --branch base --single-branch
$ cd flask-redis-queue
```

因为我们一共需要管理三个进程（Flask、Redis 和 worker），为了简化这一系列工作流，这里我们选择了使用 Docker 来部署，最终我们仅需在一个终端里就可以运行整个应用了。

像这样就能将应用跑起来：

```
$ docker-compose up -d --build
```

使用你的浏览器访问 [http://localhost:5004](http://localhost:5004)，你应该能看到如下页面：

![flask，redis queue，docker](https://testdriven.io/static/images/blog/flask-rq/flask_redis_queue.png)

## 任务触发

当 **project/client/static/main.js** 里的监听器监听到按键的点击后，它会获取按键对应的任务类型 —— `1`、`2` 或 `3`，并把得到的任务类型当作参数通过 AJAX POST 请求发到服务端。

```
$('.btn').on('click', function() {
  $.ajax({
    url: '/tasks',
    data: { type: $(this).data('type') },
    method: 'POST'
  })
  .done((res) => {
    getStatus(res.data.task_id)
  })
  .fail((err) => {
    console.log(err)
  });
});
```

在服务端，**project/server/main/views.py** 会负责处理客户端发来的请求：

```
@main_blueprint.route('/tasks', methods=['POST'])
def run_task():
    task_type = request.form['type']
    return jsonify(task_type), 202
```

下面我们来装配 Redis Queue。

## Redis Queue

首先我们需要在 **docker-compose.yml** 中添加配置以启动两个新的进程 —— Redis 和 worker：

```
version: '3.7'

services:

  web:
    build: .
    image: web
    container_name: web
    ports:
      - '5004:5000'
    command: python manage.py run -h 0.0.0.0
    volumes:
      - .:/usr/src/app
    environment:
      - FLASK_DEBUG=1
      - APP_SETTINGS=project.server.config.DevelopmentConfig
    depends_on:
      - redis

  worker:
    image: web
    command: python manage.py run_worker
    volumes:
      - .:/usr/src/app
    environment:
      - APP_SETTINGS=project.server.config.DevelopmentConfig
    depends_on:
      - redis

  redis:
    image: redis:4.0.11-alpine
```

在 "project/server/main" 目录中添加一个新的任务 **tasks.py**：

```
# project/server/main/tasks.py

import time

def create_task(task_type):
    time.sleep(int(task_type) * 10)
    return True
```

更新我们的视图代码，让它能连接 Redis 并把任务放入队列，最后再把任务的 id 返回给客户端：

```
@main_blueprint.route('/tasks', methods=['POST'])
def run_task():
    task_type = request.form['type']
    with Connection(redis.from_url(current_app.config['REDIS_URL'])):
        q = Queue()
        task = q.enqueue(create_task, task_type)
    response_object = {
        'status': 'success',
        'data': {
            'task_id': task.get_id()
        }
    }
    return jsonify(response_object), 202
```

别忘了正确地引入上面用到的库：

```
import redis
from rq import Queue, Connection
from flask import render_template, Blueprint, jsonify, \
    request, current_app

from project.server.main.tasks import create_task
```

更新 `BaseConfig` 文件：

```
class BaseConfig(object):
    """基础配置"""
    WTF_CSRF_ENABLED = True
    REDIS_URL = 'redis://redis:6379/0'
    QUEUES = ['default']
```

细心的读者可能发现了，我们在引用 `redis` 服务（在 **docker-compose.yml** 中引入的）的地址时，使用了 `REDIS_URL` 而非 `localhost` 或是某个特定 IP。在 Docker 中如何通过 hostname 连接其他服务，可以在 Docker Compose [官方文档](https://docs.docker.com/compose/networking/) 中找到答案。

最终，我们便可以使用 Redis Queue 的 [worker](http://python-rq.org/docs/workers/) 来处理放在队首的任务了。

```
@cli.command('run_worker')
def run_worker():
    redis_url = app.config['REDIS_URL']
    redis_connection = redis.from_url(redis_url)
    with Connection(redis_connection):
        worker = Worker(app.config['QUEUES'])
        worker.work()
```

在这里，我们通过自定义的 CLI 命令来启动 worker。

需要注意的是，通过装饰器 `@cli.command()` 启动的代码可以访问到应用的上下文，以及访问到在 **project/server/config.py** 中定义的配置变量。

同样需要引入正确的库：

```
import redis
from rq import Connection, Worker
```

在 requirements 文件中添加应用的依赖信息：

```
redis==2.10.6
rq==0.12.0
```

构建并启动新的 Docker 容器：

```
$ docker-compose up -d --build
```

让我们试试触发一个任务：

```
$ curl -F type=0 http://localhost:5004/tasks
```

你应该会得到类似的返回：

```
{
  "data": {
    "task_id": "bdad64d0-3865-430e-9cc3-ec1410ddb0fd"
  },
  "status": "success"
}

```

## 任务状态

让我们回头看看客户端的按键监听器：

```
$('.btn').on('click', function() {
  $.ajax({
    url: '/tasks',
    data: { type: $(this).data('type') },
    method: 'POST'
  })
  .done((res) => {
    getStatus(res.data.task_id)
  })
  .fail((err) => {
    console.log(err)
  });
});
```

每当创建任务的 AJAX 请求返回后，我们便会取出其中的任务 id 继续调用 `getStatus()`。若 `getStatus()` 也成功返回，那么我们便在表格 DOM 中新增一行记录。

```
function getStatus(taskID) {
  $.ajax({
    url: `/tasks/${taskID}`,
    method: 'GET'
  })
  .done((res) => {
    const html = `
      <tr>
        <td>${res.data.task_id}</td>
        <td>${res.data.task_status}</td>
        <td>${res.data.task_result}</td>
      </tr>`
    $('#tasks').prepend(html);
    const taskStatus = res.data.task_status;
    if (taskStatus === 'finished' || taskStatus === 'failed') return false;
    setTimeout(function() {
      getStatus(res.data.task_id);
    }, 1000);
  })
  .fail((err) => {
    console.log(err);
  });
}
```

更新视图层代码：

```
@main_blueprint.route('/tasks/<task_id>', methods=['GET'])
def get_status(task_id):
    with Connection(redis.from_url(current_app.config['REDIS_URL'])):
        q = Queue()
        task = q.fetch_job(task_id)
    if task:
        response_object = {
            'status': 'success',
            'data': {
                'task_id': task.get_id(),
                'task_status': task.get_status(),
                'task_result': task.result,
            }
        }
    else:
        response_object = {'status': 'error'}
    return jsonify(response_object)
```

调用下面命令在队列中新增一个任务：

```
$ curl -F type=1 http://localhost:5004/tasks
```

然后再用上面返回体中的 `task_id` 来请求新增的任务详情接口：

```
$ curl http://localhost:5004/tasks/5819789f-ebd7-4e67-afc3-5621c28acf02

{
  "data": {
    "task_id": "5819789f-ebd7-4e67-afc3-5621c28acf02",
    "task_result": true,
    "task_status": "finished"
  },
  "status": "success"
}
```

同样让我们在浏览器中试试效果：

![flask, redis queue, docker](https://testdriven.io/static/images/blog/flask-rq/flask_redis_queue_updated.png)

## 任务控制台

[RQ Dashboard](https://github.com/eoranged/rq-dashboard) 是一个 Redis Queue 的轻量级 web 端监控系统。

为了集成 RQ Dashboard，首先你需要在 "project" 下新建一个 "dashboard" 文件夹，然后再在其中新建一个 **Dockerfile**：

```
FROM python:3.7.0-alpine

RUN pip install rq-dashboard

EXPOSE 9181

CMD ["rq-dashboard"]
```

接着把上面的模块作为 service 添加到 **docker-compose.yml** 中：

```
version: '3.7'

services:

  web:
    build: .
    image: web
    container_name: web
    ports:
      - '5004:5000'
    command: python manage.py run -h 0.0.0.0
    volumes:
      - .:/usr/src/app
    environment:
      - FLASK_DEBUG=1
      - APP_SETTINGS=project.server.config.DevelopmentConfig
    depends_on:
      - redis

  worker:
    image: web
    command: python manage.py run_worker
    volumes:
      - .:/usr/src/app
    environment:
      - APP_SETTINGS=project.server.config.DevelopmentConfig
    depends_on:
      - redis

  redis:
    image: redis:4.0.11-alpine

  dashboard:
    build: ./project/dashboard
    image: dashboard
    container_name: dashboard
    ports:
      - '9181:9181'
    command: rq-dashboard -H redis
```

构建并启动新的容器：

```
$ docker-compose up -d --build
```

打开 [http://localhost:9181](http://localhost:9181) 来看看整个控制台：

![rq dashboard](https://testdriven.io/static/images/blog/flask-rq/rq_dashboard.png)

可以尝试启动一些任务来试试控制台功能：

![rq dashboard](https://testdriven.io/static/images/blog/flask-rq/rq_dashboard_in_action.png)

你也可以通过增加 worker 的数量来观察应用的变化：

```
$ docker-compose up -d --build --scale worker=3
```

## 结语

这是一篇在 Flask 中配置 Redis Queue 用于处理长执行任务的基础指南。你可以利用该队列来执行任何可能阻塞或拖慢用户体验的进程。

还想继续挑战自己？

1.  注册 [Digital Ocean](https://m.do.co/c/d8f211a4b4c2) 并利用 Docker Swarm 把这个应用部署到多个节点。
2.  为接口增加单元测试。（可以使用 [fakeredis](https://github.com/jamesls/fakeredis) 来模拟 Redis 实例）
3.  利用 [Flask-SocketIO](https://flask-socketio.readthedocs.io) 把客户端的轮询改为 websocket 连接。

可以在 [此仓库](https://github.com/mjhea0/flask-redis-queue) 找到本文代码。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
