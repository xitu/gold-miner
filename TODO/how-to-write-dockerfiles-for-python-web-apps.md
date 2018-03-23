> * 原文地址：[How to write Dockerfiles for Python Web Apps](https://blog.hasura.io/how-to-write-dockerfiles-for-python-web-apps-6d173842ae1d)
> * 原文作者：[Praveen Durairaj](https://blog.hasura.io/@praveenweb?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-dockerfiles-for-python-web-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-dockerfiles-for-python-web-apps.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[Starriers](https://github.com/Starriers), [steinliber](https://github.com/steinliber)

# 为 Python Web App 编写 Dockerfiles

![](https://cdn-images-1.medium.com/max/800/1*8rsXezmgl9VTA4zqCcUsfw.jpeg)

### TL;DR

本文涵盖了从创建简单的 Dockerfile 到生产环境多级构建 Python 应用的例子。以下为本指南的内容摘要：

*   使用合适的基础镜像（开发环境使用 debian，生产环境使用 alpine）。
*   在开发时使用 `gunicorn` 进行热加载。
*   优化 Docker 的 cache layer（缓存层）—— 按照正确的顺序使用命令，仅在必要时运行 `pip install`。
*   使用 `flask` 的 static 及 template 目录部署静态文件（比如 React、Vue、Angular 生成的 bundle）。
*   使用 `alpine` 进行生产环境下的多级构建，减少最终镜像文件的大小。
*   \#彩蛋 — 在开发时可以用 gunicorn 的 `--reload` 与 `--reload_extra_files` 监视文件（包括 html、css 及 js）的修改。

如果你需要以上步骤的代码，请参考 [GitHub repo](https://github.com/praveenweb/python-docker).

### 内容

1.  简单的 Dockerfile 与 .dockerignore
2.  使用 gunicorn 实现热加载
3.  运行一个单文件 python 脚本
4.  部署静态文件
5.  生产环境中的直接构建
6.  生产环境中的多级构建

假设我们有一个名为 python-app 的应用，为其准备一个简单的目录结构。在顶级目录下，包含 `Dockerfile` 以及 `src` 文件夹。

python app 的源码就存放在 `src` 目录中，app 的依赖关系保存在 `requirements.txt` 里。为了简洁起见，我们假设 server.py 定义了一个运行于 8080 端口的 flask 服务。

```
python-app
├── Dockerfile
└── src
    └── server.py
    └── requirements.txt
```

### 1. 简单的 Dockerfile 样例

```docker
FROM python:3.6

# 创建 app 目录
WORKDIR /app

# 安装 app 依赖
COPY src/requirements.txt ./

RUN pip install -r requirements.txt

# 打包 app 源码
COPY src /app

EXPOSE 8080
CMD [ "python", "server.py" ]
```

我们将使用最新版本的 `python:3.6` 作为基础镜像。

在构建镜像时，docker 会获取所有位于 `context` 目录下的文件。为了提高 docker 构建的速度，可以在 context 目录中添加 `.dockerignore` 文件来排除不需要的文件与目录。

通常，你的 `.dockerignore` 文件件应该如下所示：

```text
.git
__pycache__
*.pyc
*.pyo
*.pyd
.Python
env
```

构建并运行此镜像：

```bash
$ cd python-docker
$ docker build -t python-docker-dev .
$ docker run --rm -it -p 8080:8080 python-docker-dev
```

你将能在 `[http://localhost:8080](http://localhost:8080.)` 访问此 app。使用 `Ctrl+C` 组合键可以退出程序。

现在，假设你希望在每次修改代码（比如在本地部署时）时都运行以上代码，那么你需要在启停 python 服务时将代码源文件挂载到容器中。

```
$ docker run --rm -it -p 8080:8080 -v $(pwd):/app \
             python-docker-dev bash
root@id:/app# python src/server.py
```

### 2. 使用 Gunicorn 实现热更新

[gunicorn](http://gunicorn.org) 是一款运行于 Unix 下的 Python WSGI HTTP server，使用的是 pre-fork worker 模型（注，Arbiter 是 gunicorn 的 master，因此称 gunicorn 为 pre-fork worker）。你可以使用各种各样的选项来配置 gunicorn。向 gunicorn 命令中传入 `--reload` 或是将 `reload` 写入配置文件，就可以让 gunicorn 在有文件发生变化时自动重启 python 服务。

```docker
FROM python:3.6

# 创建 app 目录
WORKDIR /app

# 安装 app 依赖
COPY gunicorn_app/requirements.txt ./

RUN pip install -r requirements.txt

# 打包 app 源码
COPY gunicorn_app /app

EXPOSE 8080
```

我们将构建镜像并运行 gunicorn，以便在 `app` 目录下文件发生变动时对代码进行 rebuild。

```
$ cd python-docker
$ docker build -t python-hot-reload-docker .
$ docker run --rm -it -p 8080:8080 -v $(pwd):/app \
             python-hot-reload-docker bash
root@id:/app# gunicorn --config ./gunicorn_app/conf/gunicorn_config.py gunicorn_app:app
```

一切在 `app` 目录下 python 文件的更改都会触发 rebuild，发生的变化都能在 `[http://localhost:8080](http://localhost:8080.)` 上实时展示。请注意，我们已经将文件挂载到了容器中，因此 gunicorn 才能正常工作。

**其它格式的文件怎么办？** 如果你希望 gunicorn 在监视代码变动的时候也监视其它类型的文件（如 template、view 之类的文件），可以在 `reload_extra_files` 参数中进行指定。此参数接受数组形式的多个文件名。

### 3. 运行一个单文件 python 脚本

你可以通过 docker run，使用 python 镜像来简单地运行 python 单文件脚本。

```bash
docker run -it --rm --name single-python-script -v "$PWD":/app -w /app python:3 python your-daemon-or-script.py
```

你也可以给脚本传递一些参数。在上面的例子中，我们就已经挂载了当前工作目录，也就是说可以将目录中的文件当做参数传递。

### 4. 部署静态文件

上面的 Dockerfile 假定了你是使用 Python 运行一个 API 服务器。如果你想用 Python 为 React.js、Vue.js、Angular.js app 提供服务，可以使用 Flask。Flask 为渲染静态文件提供了一种便捷的方式：html 文件放在 `templates` 目录中，css、js 及图片放在 `static` 目录中。

请[在此 repo](https://github.com/praveenweb/python-docker/tree/master/static_app) 中查看简单的 hello world 静态 app 的目录结构。

```docker
FROM python:3.6

# 创建 app 目录
WORKDIR /app

# 安装 app 依赖
COPY static_app/requirements.txt ./

RUN pip install -r requirements.txt

# 打包 app 源码
COPY static_app /app

EXPOSE 8080
CMD ["python","server.py"]
```

In your server.py,

```python
if __name__ == '__main__':
    app.run(host='0.0.0.0')
```

请注意，host 需要设置为 `0.0.0.0` - 这样可以让你的服务在容器外被访问。如果不设置此参数，host 会默认设为 `localhost`。

### 5. 生产环境中的直接构建

```docker
FROM python:3.6

# 创建 app 目录
WORKDIR /app

# 安装 app 依赖
COPY gunicorn_app/requirements.txt ./

RUN pip install -r requirements.txt

# 打包 app 源码
COPY . /app

EXPOSE 8080
CMD ["gunicorn", "--config", "./gunicorn_app/conf/gunicorn_config.py", "gunicorn_app:app"]
```

构建并运行这个一体化镜像：

```bash
$ cd python-docker
$ docker build -t python-docker-prod .
$ docker run --rm -it -p 8080:8080 python-docker-prod
```

由于底层为 Debian，构建完成后镜像约为 700MB（具体数值取决于你的源码）。下面探讨如何减小这个文件的大小。

### 6. 生产环境中的多级构建

使用多级构建时，将在 Dockerfile 中使用多个 `FROM` 语句，但最后仅会使用最终阶段构建的文件。这样，得到的镜像将仅包含生产服务器中所需的依赖，理想情况下文件将非常小。

当你需要使用依赖于系统的模块或需要编译的模块时，这种构建模式十分有用。比如 `pycrypto` 和 `numpy` 就很适合这种方法。

```docker
# ---- 基础 python 镜像 ----
FROM python:3.6 AS base
# 创建 app 目录
WORKDIR /app

# ---- 依赖 ----
FROM base AS dependencies  
COPY gunicorn_app/requirements.txt ./
# 安装 app 依赖
RUN pip install -r requirements.txt

# ---- 复制文件并 build ----
FROM dependencies AS build  
WORKDIR /app
COPY . /app
# 在需要时进行 Build 或 Compile

# --- 使用 Alpine 发布 ----
FROM python:3.6-alpine3.7 AS release  
# 创建 app 目录
WORKDIR /app

COPY --from=dependencies /app/requirements.txt ./
COPY --from=dependencies /root/.cache /root/.cache

# 安装 app 依赖
RUN pip install -r requirements.txt
COPY --from=build /app/ ./
CMD ["gunicorn", "--config", "./gunicorn_app/conf/gunicorn_config.py", "gunicorn_app:app"]
```

使用上面的方法，用 Alpine 构建的镜像文件大小约 90MB，比之前少了 8 倍。使用 `alpine` 版本进行构建能有效减小镜像的大小。

**注意：**上面的 Dockerfiles 是为 `python 3` 编写的，你可以只做少数修改就能将其改为 `python 2` 版本。如果你要部署的是 `django` 应用，也应该能通过少数改动就做出可部署于生产环境的 Dockerfiles。

如果你对前面的方法有任何建议，或希望看到别的用例，请告知作者。

欢迎加入 [Reddit](https://www.reddit.com/r/flask/comments/80css4/how_to_write_dockerfiles_for_python_web_apps/) 或 [HackerNews](https://news.ycombinator.com/item?id=16471630) 参与讨论 :)

* * *

此外，你是否试过将 python web app 部署在 Hasura 上呢？这其实是将 python 应用部署于 HTTPS 域名的最快的方法（仅需使用 git push）。尝试使用 [https://hasura.io/hub/projects/hasura/hello-python-flask](https://hasura.io/hub/projects/hasura/hello-python-flask) 的模板快速入门吧！Hasura 中所有的项目模板都带有 Dockerfile 与 Kubernetes 标准文件，你可以自由进行定义。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


