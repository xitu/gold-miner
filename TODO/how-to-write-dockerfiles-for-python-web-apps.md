> * 原文地址：[How to write Dockerfiles for Python Web Apps](https://blog.hasura.io/how-to-write-dockerfiles-for-python-web-apps-6d173842ae1d)
> * 原文作者：[Praveen Durairaj](https://blog.hasura.io/@praveenweb?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-dockerfiles-for-python-web-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-dockerfiles-for-python-web-apps.md)
> * 译者：
> * 校对者：

# How to write Dockerfiles for Python Web Apps

![](https://cdn-images-1.medium.com/max/800/1*8rsXezmgl9VTA4zqCcUsfw.jpeg)

### TL;DR

This post is filled with examples ranging from a simple Dockerfile to multistage production builds for Python apps. Here’s a quick summary of what this guide covers:

*   Using an appropriate base image (debian for dev, alpine for production).
*   Using `gunicorn` for hot reloading during development.
*   Optimising for Docker cache layers — placing commands in the right order so that `pip install` is executed only when necessary.
*   Serving static files (bundles generated via React/Vue/Angular) using `flask` static and template folders.
*   Using multi-stage `alpine` build to reduce final image size for production.
*   #Bonus — Using gunicorn’s `--reload` and `--reload_extra_files` for watching on changes to files (html, css and js included) during development.

If you’d like to jump right ahead to the code, check out the [GitHub repo](https://github.com/praveenweb/python-docker).

### Contents

1.  [Simple Dockerfile and .dockerignore](#78dd)
2.  [Hot Reloading with gunicorn](#7fca)
3.  [Running a single python script](#0959)
4.  [Serving Static Files](#645b)
5.  [Single Stage Production Build](#9227)
6.  [Multi Stage Production Build](#d0a8)

Let’s assume a simple directory structure. The application is called python-app. The top level directory has a `Dockerfile` and an `src` folder.

The source code of your python app will be in the`src` folder. It also contains the app dependencies in `requirements.txt` file. For brevity, let’s assume that server.py defines a flask server running on port 8080.

```
python-app
├── Dockerfile
└── src
    └── server.py
    └── requirements.txt
```

### 1. Simple Dockerfile Example

```
FROM python:3.6

# Create app directory
WORKDIR /app

# Install app dependencies
COPY src/requirements.txt ./

RUN pip install -r requirements.txt

# Bundle app source
COPY src /app

EXPOSE 8080
CMD [ "python", "server.py" ]
```

For the base image, we have used the latest version `python:3.6`

During image build, docker takes all files in the `context` directory. To increase the docker build’s performance, exclude files and directories by adding a `.dockerignore` file to the context directory.

Typically, your `.dockerignore` file should be:

```
.git
__pycache__
*.pyc
*.pyo
*.pyd
.Python
env
```

Build and run this image:

```
$ cd python-docker
$ docker build -t python-docker-dev .
$ docker run --rm -it -p 8080:8080 python-docker-dev
```

The app will be available at `[http://localhost:8080](http://localhost:8080.)`. Use `Ctrl+C` to quit.

Now let’s say you want this to work every time you change your code. i.e. local development. Then you would mount the source code files into the container for starting and stopping the python server.

```
$ docker run --rm -it -p 8080:8080 -v $(pwd):/app \
             python-docker-dev bash
root@id:/app# python src/server.py
```

### 2. Hot Reloading with Gunicorn

[gunicorn](http://gunicorn.org) is a Python WSGI HTTP Server for UNIX and a pre-fork worker model. You can configure gunicorn to make use of multiple options. You can pass on `--reload` to the gunicorn command or place it in the configuration file. If any files change, gunicorn will automatically restart your python server.

```
FROM python:3.6

# Create app directory
WORKDIR /app

# Install app dependencies
COPY gunicorn_app/requirements.txt ./

RUN pip install -r requirements.txt

# Bundle app source
COPY gunicorn_app /app

EXPOSE 8080
```

We’ll build the image and run gunicorn so that the code is rebuilt whenever there is any change inside the `app` directory.

```
$ cd python-docker
$ docker build -t python-hot-reload-docker .
$ docker run --rm -it -p 8080:8080 -v $(pwd):/app \
             python-hot-reload-docker bash
root@id:/app# gunicorn --config ./gunicorn_app/conf/gunicorn_config.py gunicorn_app:app
```

All edits to python files in the`app`directory will trigger a rebuild and changes will be available live at `[http://localhost:8080](http://localhost:8080.)`. Note that we have mounted the files into the container so that gunicorn can actually work.

**What about other files?** If you have other types of files (templates, views etc) that you want gunicorn to watch for code changes, you can specify the file types in `reload_extra_files` argument. It accepts an array of files.

### 3. Running a single python script

For simple single file scripts, you can run the python script using the python image with docker run.

```
docker run -it --rm --name single-python-script -v "$PWD":/app -w /app python:3 python your-daemon-or-script.py
```

You can also pass some arguments to your python script. In the above example, we have mounted the current working directory, which also allows files in that directory to be passed as arguments.

### 4. Serving Static Files

The above Dockerfile assumed that you are running an API server with Python. Let’s say you want to serve your React.js/Vue.js/Angular.js app using Python. Flask provides a quick way to render static files. Your html should be present inside the `templates` folder and your css, js, images should be present inside the `static` folder.

Check out a sample hello world static app structure [here](https://github.com/praveenweb/python-docker/tree/master/static_app).

```
FROM python:3.6

# Create app directory
WORKDIR /app

# Install app dependencies
COPY static_app/requirements.txt ./

RUN pip install -r requirements.txt

# Bundle app source
COPY static_app /app

EXPOSE 8080
CMD ["python","server.py"]
```

In your server.py,

```
if __name__ == '__main__':
    app.run(host='0.0.0.0')
```

Note the host, `0.0.0.0` — this allows your container to be accessible from outside. By default, if you don’t give a host, it binds only to the `localhost` interface.

### 5. Single Stage Production Build

```
FROM python:3.6

# Create app directory
WORKDIR /app

# Install app dependencies
COPY gunicorn_app/requirements.txt ./

RUN pip install -r requirements.txt

# Bundle app source
COPY . /app

EXPOSE 8080
CMD ["gunicorn", "--config", "./gunicorn_app/conf/gunicorn_config.py", "gunicorn_app:app"]
```

Build and run the all-in-one image:

```
$ cd python-docker
$ docker build -t python-docker-prod .
$ docker run --rm -it -p 8080:8080 python-docker-prod
```

The image built will be ~700MB (depending on your source code), due to the underlying Debian layer. Let’s see how we can cut this down.

### 6. Multi Stage Production Build

With multi stage builds, you use multiple `FROM` statements in your Dockerfile but the final build stage will be the one used, which will ideally be a tiny production image with only the exact dependencies required for a production server.

This will be really useful when you are using system dependent modules or ones that requires compiling etc. `pycrypto`, `numpy` are good examples of this type.

```
# ---- Base python ----
FROM python:3.6 AS base
# Create app directory
WORKDIR /app

# ---- Dependencies ----
FROM base AS dependencies  
COPY gunicorn_app/requirements.txt ./
# install app dependencies
RUN pip install -r requirements.txt

# ---- Copy Files/Build ----
FROM dependencies AS build  
WORKDIR /app
COPY . /app
# Build / Compile if required

# --- Release with Alpine ----
FROM python:3.6-alpine3.7 AS release  
# Create app directory
WORKDIR /app

COPY --from=dependencies /app/requirements.txt ./
COPY --from=dependencies /root/.cache /root/.cache

# Install app dependencies
RUN pip install -r requirements.txt
COPY --from=build /app/ ./
CMD ["gunicorn", "--config", "./gunicorn_app/conf/gunicorn_config.py", "gunicorn_app:app"]
```

With the above, the image built with Alpine comes to around ~90MB, a 8X reduction in size. The `alpine` variant is usually a very safe choice to reduce image sizes.

**Note:** All of the above Dockerfiles were written with `python 3` — the same can be replicated for `python 2` with little to no changes. If you are looking to deploy your `django` app, you should be able to deploy a production ready app with minimal tweaking to the Dockerfiles above.

Any suggestions to improve the ideas above? Any other use-cases that you’d like to see? Do let me know in the comments.

Join the discussion on [Reddit](https://www.reddit.com/r/flask/comments/80css4/how_to_write_dockerfiles_for_python_web_apps/) and [HackerNews](https://news.ycombinator.com/item?id=16471630) :)

* * *

Psst…. Have you tried deploying a python web app on Hasura? It is literally the fastest way in the world for deploying python apps to an HTTPS domain (with just a git push). Get started with a flask project boilerplate here: [https://hasura.io/hub/projects/hasura/hello-python-flask](https://hasura.io/hub/projects/hasura/hello-python-flask). All project boilerplates on Hasura come with a Dockerfile and Kubernetes spec files that you can customize as you wish!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
