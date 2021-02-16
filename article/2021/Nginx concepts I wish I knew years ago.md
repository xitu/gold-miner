> * 原文地址：[Nginx concepts I wish I knew years ago](https://dev.to/aemiej/nginx-concepts-i-wish-i-knew-years-ago-23o0)
> * 原文作者：[Aemie Jariwala](https://dev.to/aemiej)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Nginx%20concepts%20I%20wish%20I%20knew%20years%20ago.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Nginx%20concepts%20I%20wish%20I%20knew%20years%20ago.md)
> * 译者：[joyking7](https://github.com/joyking7)
> * 校对者：

# Nginx concepts I wish I knew years ago
# 我希望多年前就知道的 Nginx 概念
*Nginx is a web server that is used as a reverse proxy, load balancer, mail proxy, and HTTP cache and follows the Master-Slave Architecture.*
*Nginx 是一个可被用作反向代理、负载均衡器、邮件代理和 HTTP 缓存的 Web 服务器，遵循主从架构。*

Woah! A complicated term and a confusing definition filled with big confusing words, right? Don't worry, I can help out with first understanding the basic barebones of the architectures & terms in Nginx. Then we'll move on to installing and creating **Nginx** configurations.
哇！复杂的术语和混乱的定义，里面充斥着大量令人困惑的词语，对吧？不用纠结，我可以帮大家先了解 Nginx 的基本架构和术语，然后我们将安装并创建 **Nginx** 配置。

![https://res.cloudinary.com/practicaldev/image/fetch/s--mxz4Qgrr--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/fbj8exwkli91ord2xscz.gif](https://res.cloudinary.com/practicaldev/image/fetch/s--mxz4Qgrr--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/fbj8exwkli91ord2xscz.gif)

To keep things easy, just remember: *Nginx is an amazing web server*.
为了让事情变简单，只需要记住：*Nginx 是一个神奇的 Web 服务器*。

Web server, in simple terms, is like a middleman. Let's say for instance you want to go to dev.to so you type the address `https://dev.to`, your browser finds out the address of a webserver for `https://dev.to` and then direct it to a backend server which will give back the response to the client.
Web 服务器，简单来说，就像个中间人。比如你想访问 dev.to，输入地址 `https://dev.to`，你的浏览器就会找出 `https://dev.to` 的 Web 服务器地址，然后将其定向到后台服务器，后台服务器会把响应返回给客户端。

### Proxy v/s Reverse Proxy
### 代理 vs 反向代理

The underlying feature of Nginx is proxies. So it's required to understand what is proxy and reverse proxy now.
Nginx 底层特性就是代理，所以现在就需要了解什么是代理和反向代理。

### Proxy
#### 代理

Alright, so we have clients (>= 1), an intermediate web server(in this case, we call it proxy), and a server. The main thing that happens in this is that the server doesn't know which client is requesting. Bit confusing? Let me explain with a diagrammatic sketch.
好的，我们有客户端（>= 1）、一个中间 Web 服务器（在这种情况下，我们称它为代理）和一个服务器。这其中最主要的就是服务器不知道哪个客户端在请求。有点困惑？让我用一张示意图来解释一下。

![https://res.cloudinary.com/practicaldev/image/fetch/s--tPAqn11I--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/1moanfdnfnh5d0dqs4wd.png](https://res.cloudinary.com/practicaldev/image/fetch/s--tPAqn11I--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/1moanfdnfnh5d0dqs4wd.png)

In this, let client1 & client2 send requests request1 & request2 to the server through the Proxy server. Now the backend server will not know whether request1 is sent by client1 or client2 but performs the operation.
在这种情况下，client1 和 client2 通过代理服务器向服务器发送请求 request1 和 request2，现在后端服务器不会知道 request1 和 request2 是由 client1 还是 client2 发送的，而是执行操作。

### Reverse Proxy
#### 反向代理

In simplest terms, a reverse proxy is a reverse of what a proxy does. Here, we will have let's say a single client, an intermediate web server, and several backend servers (>=1). Let's do this with a diagrammatic sketch as well!
最简单的解释，反向代理就是把代理的工作反过来。比方说有一个客户端、一个中间 Web 服务器和若干后端服务器（>= 1），我们也通过一张示意图解释吧！

![https://res.cloudinary.com/practicaldev/image/fetch/s--iUfM34yx--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/64jk21oeqlki2t3bx1kz.png](https://res.cloudinary.com/practicaldev/image/fetch/s--iUfM34yx--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/64jk21oeqlki2t3bx1kz.png)

In this, a client will send a request through the webserver. Now the webserver will direct to any of the many servers through an algorithm, one being round-robin (the cutest one!), and send back the response through the webserver to the client. So here, the client isn't aware which backend server it is interacting with.
在这种情况下，客户端将通过 Web 服务器发送一个请求，Web 服务器会通过一种算法将请求定向到众多服务器的任何一个，其中一种是轮询调度算法（最可爱的一个！），然后再将响应通过 Web 服务器返回给客户端。因此在这里，客户端并不知道与之交互的后端服务器。

### Load Balancing
### 负载均衡

Damn another new term but this term is simpler to understand as it is one instance application of **reverse proxy** itself.
可恶，又是一个新术语，但是这个术语比较容易理解，因为它是**反向代理**本身的一个实际应用。

Let's go with the basic difference. In load balancing, you must have 2 or more backend servers but in reverse proxy setup, that's not a necessity. It can work with even 1 backend server.
我们先说说基本的区别。在负载均衡中，必须要有两个或者更多的后端服务器，但在反向代理设置中，这不是必须的，它甚至可以与一个后端服务器一起使用。

Let's look at it from behind the scene, if we have a lot of requests from the clients this load balancer checks the status of each backend server and distributes the load of the requests, and sends a response faster to the client.
让我们从后面情况看一下，如果我们有大量来自客户端的请求，这个负载均衡器会检查每个后端服务器的状态并分配请求的负载，然后将响应更快地发送给客户端。

### Stateful v/s Stateless Applications
### 有状态应用 vs 无状态应用

Okay, guys, I promise I am real close to starting with the Nginx code. Let's get all the barebones clear!
好的各位，我保证我很快就要开始使用 Nginx 代码了，先让我们把所有的基本概念搞清楚！

### Stateful Applications
#### 有状态应用

This application store an additional variable for saving the information that can work for a single instance of a server only.
这个应用程序存储了一个额外的变量，用于保存只适用于单个服务器实例的信息。

![https://res.cloudinary.com/practicaldev/image/fetch/s--Ng8XRfi_--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/bb9kkupl1z9dpacex8vt.png](https://res.cloudinary.com/practicaldev/image/fetch/s--Ng8XRfi_--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/bb9kkupl1z9dpacex8vt.png)

What I mean is if for a backend server *server1* some information is stored it won't be stored for the server *server2* thus the client (here Bob) interacting may/may not get the desired result as it could be interacting with server1 or server2. In this case, server1 will allow Bob to view the profile but server2 won't. Thus, even if it prevents many API calls with the database and is faster, it can lead to this problem across different servers.
我的意思是，如果后端服务器 *server1* 存储了一些信息，那么它不会被存储在 *server2* 上，因此客户端（这里是 Bob）的交互可能会得到或可能不会得到想要的结果，因为它可能会与服务器 1 或者服务器 2 交互。在这种情况下，服务器 1 将允许 Bob 查看配文件，但服务器 2 不会。因此，即使它阻止了许多与数据库的 API 调用并且速度更快，但可能会在不同的服务器上出现上述的问题。

### Stateless Applications
#### 无状态应用

Now stateless is more API calls with the database but fewer problems exist when it comes to the interaction of the client with different backend servers.
现在，无状态是与数据库的 API 调用更多，但是当客户端与不同的后端服务器进行交互时，存在的问题更少。

![https://res.cloudinary.com/practicaldev/image/fetch/s--42mTsbTP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/c44w9vi7jmgfeo9rea1l.png](https://res.cloudinary.com/practicaldev/image/fetch/s--42mTsbTP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/c44w9vi7jmgfeo9rea1l.png)

I know you didn't get what I mean. It's simple if I send a request from a client to let's say backend server *server1* through web server it will provide a token back to the client to use to access any further requests. The client can use the token and send a request to the webserver. This web server will send the request along with the token to any of the backend servers and each will provide the same desired output.
我知道你没有明白我的意思。很简单，如果我从客户端通过 Web 服务器向比如说后端服务器 *server1* 发送一个请求，它将向客户端提供一个令牌以用于访问其他任何请求。客户端可以使用令牌并将请求发送给 Web 服务器，该 Web 服务器将请求和令牌一起发送给任意后端服务器，每个服务器都将返回相同的所需结果。

### What is Nginx?
### 什么是 Nginx？

Nginx is the web server and I have been using the term web server in the entire blog till now. It's like a **middleman** honestly.
Nginx 是 Web 服务器，到目前位置，我一直在整篇博客中使用 Web 服务器这个词，老实说，它就像一个*中间人*。

![https://res.cloudinary.com/practicaldev/image/fetch/s--Z6CIUUND--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/2u3l8t4klwflv8k36rtg.png](https://res.cloudinary.com/practicaldev/image/fetch/s--Z6CIUUND--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/2u3l8t4klwflv8k36rtg.png)

The diagram isn't confusing, it's just a combination of all the concepts I have explained till now. In this, we have 3 backend servers running at port 3001, 3002, 3003 and all these backend servers use the same database running at port 5432.
这张图并不难懂，它只是结合了我到现在为止解释的所有概念。在这张图中，我们有 3 台后端服务器分别运行在 3001、3002、3003 端口，这些后端服务器都使用运行在 5432 端口的数据库。

Now when a client sends a requests `GET /employees` on `https://localhost` (by default on port 443), it will pass this requests to any of the backend server based on the algorithm and take the information from the database and send the JSON back to the Nginx web server and sent back to the client.
现在，当客户端向 `https://localhost`（默认 443 端口）发送请求 `GET /employees` 时，Nginx 将根据算法把这个请求发送给任意一个后端服务器，后端服务器从数据库中获取信息，然后把 JSON 结果发送回 Nginx Web 服务器，Nginx 再发送回客户端。

If we're to use an algorithm such as **round-robin**, what it'll do is let's say client 2 has sent a request to `https://localhost` then the Nginx server will pass the request first to port 3000 and send the response back to the client. For another request, Nginx will pass the request to 3002 and so on.
如果我们要使用诸如*轮询调度*这样的算法，Nginx 会这样做：比如 client2 发送了一个请求到 `https://localhost`，那么 Nginx 服务器会先把请求传到 3001 端口，然后把响应返回给客户端。对于另一个请求，Nginx 会把请求传到 3002 端口，以此类推。

Too much information right! But by this point, you have a clear understanding of what Nginx is and the terms used with Nginx. Now we'll move on the understanding the installation and configuration techniques.
太多信息辣！但到这里，你应该已经清楚地了解了什么是 Nginx 及其相关术语。现在，我们将继续了解 Nginx 的安装和配置。

### Installation Process
### 安装过程

We're here at last! I am so proud if you've understood the concept to reach the coding part of Nginx at last.
终于到这一步了！如果你能理解 Nginx 概念并看到了代码这部分，我感到灰常自豪。

![https://res.cloudinary.com/practicaldev/image/fetch/s--7rgP-NQB--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/4mju73ad1f22gy1ni3gu.gif](https://res.cloudinary.com/practicaldev/image/fetch/s--7rgP-NQB--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/4mju73ad1f22gy1ni3gu.gif)

Okay, let me just tell you the installation process is super duper easy on any system just one-liner honestly. I am a Mac OSX user, so will be writing the commands based on it. But it will be done similarly for [ubuntu](https://ubuntu.com/tutorials/install-and-configure-nginx#2-installing-nginx) and [windows](https://www.maketecheasier.com/install-nginx-server-windows/) and other Linux distros.
好的，让我告诉你，老实说，在任何操作系统上安装 Nginx 都只需要一行命令。我是 Mac OSX 用户，所以会基于它来写命令。但对于 [ubuntu](https://ubuntu.com/tutorials/install-and-configure-nginx#2-installing-nginx) 和 [windows](https://www.maketecheasier.com/install-nginx-server-windows/) 以及其他 Linux 发行版，也有类似的操作。

```
$ brew install Nginx

```

This is only required and you have Nginx on your system now! Amazing I am sure!
只需要一行命令，你的系统就已经安装上 Nginx 了!非常 Amazing！

### So easy to run! 😛
### 运行 so easy!😛

To run this and check if Nginx is working on your system, it's again way too simple.
运行下面的命令来检查 Nginx 是否在你的系统上运行起来了，又非常简单的一步。

```
$ nginx 
# OR 
$ sudo nginx

```

After this, go on your favorite browser and check out `http://localhost:8080/` and you'll get the below-observed screen!
运行完命令之后，使用你最喜欢的浏览器访问 `http://localhost:8080/`，你将在屏幕上看到下面的画面！

![https://res.cloudinary.com/practicaldev/image/fetch/s--q4OAcvwJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/9mlhwlzgqhs6l8aw8sxi.png](https://res.cloudinary.com/practicaldev/image/fetch/s--q4OAcvwJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/9mlhwlzgqhs6l8aw8sxi.png)

### Basic Configuration Setup & Example
### 基本配置和示例

Okay, we will be doing an example and seeing the magic of Nginx.First, create the directory structure in the local machine as follows:
好的，我们将通过一个示例来展示 Nginx 的神奇之处。首先，在本地机器上创建如下的目录结构：

```
.
├── nginx-demo
│  ├── content
│  │  ├── first.txt
│  │  ├── index.html
│  │  └── index.md
│  └── main
│    └── index.html
└── temp-nginx
  └── outsider
    └── index.html

```

Also, include basic context within the **html** and **md** files.
同时，在 *html* 和 *md* 文件中包含上基本的上下文内容。

### What we're trying to achieve?
### 我们要实现什么效果？

Here, we have two separate folders `nginx-demo` and `temp-nginx`, each containing static HTML files. We're going to focus on running both these folders on a common port and set rules that we like.
在这里，我们有两个单独的文件夹 `nginx-demo` 和 `temp-nginx`，每个文件夹都包含静态 HTML 文件。我们将着眼于在同一个端口上运行这两个文件夹，并设置我们喜欢的规则。

Coming back on track now. For making any changes to the Nginx default configuration, we will make a change in the `nginx.conf` that is located in the `usr/local/etc/nginx` path. Also, I have vim in my system so I make changes using vim but you're free to use your editor of choice.
现在回到正规。我们可以通过修改位于 `usr/local/etc/nginx` 路径下的 `nginx.conf` 文件，实现对 Nginx 默认配置的任何改动。另外，我的系统中有 Vim，所以我使用 Vim 进行修改，你也可以自由使用所选的编辑器。

```
$ cd /usr/local/etc/nginx
$ vim nginx.conf

```

This will open a file with the default nginx configuration which I really don't want to use. Thus, the way I normally do is make a copy of this configuration file and then make changes to the main file. We'll be doing the same as well.
这将打开一个默认的 Nginx 配置文件，我真的不想使用它（的默认配置）。因此，我通常会复制这个配置文件，然后对原文件进行修改。在这里我们也这样做。

```
$ cp nginx.conf copy-nginx.conf
$ rm nginx.conf && vim nginx.conf 

```

This will now open an empty file and we'll be adding our configuration for it.
现在打开一个空文件，我们将给它添加我们的配置。

1. Add a basic setup of configuration. It is a must requirement to add the `events {}` as it is generally used to mention the number of workers for Nginx architecture. We are using `http` here to tell Nginx that we'll be working at layer 7 of the [OSI model](https://bit.ly/2LGdbYB).
1. 添加一个基本配置。添加 `events {}` 是必须的，因为对于 Nginx 架构来讲，它通常被用来表示 worker 的数量。我们在这里使用 `http` 来告诉 Nginx，我们将使用 [OSI 模型](https://bit.ly/2LGdbYB) 的第 7 层。

    In this, we've told nginx to listen on port 5000 and to point to the static file mentioned within the main folder.
    在这里，我们让 Nginx 监听 5000 端口，并指向 `/nginx-demo/main` 文件夹下的静态文件。

    ```
      http {

         server {
           listen 5000;
           root /path/to/nginx-demo/main/; 
          }

      }

      events {}

    ```

2. We'll add additional rules next for the `/content` and `/outsider` URL where **outsider** will be pointing to a directory outside the root directory mentioned in the 1st step.
2. 接下来我们将对 `/content` 和 `/outsider` URL 添加额外的规则，其中 **outsider** 将指向第一步中提到的根目录（`/nginx-demo`）以外的目录。

    Here `location /content` signifies that whichever root I define in the leaf directory for this, the **content** sub URL will be added to the end of the root URL defined. Thus, here when I specify root as `root /path/to/nginx-demo/` it simply means that I am telling Nginx at `http://localhost:5000/path/to/nginx-demo/content/` show me the content of the static files within the folder.
    这里 `location /content` 表示无论我在子目录中定义了哪一个根目录，**content** 子 URL 都会被添加到定义的根目录末尾。因此，这里当我指定根目录为 `root /path/to/nginx-demo/` 时，仅仅表示我告诉 Nginx 在 `http://localhost:5000/path/to/nginx-demo/content/` 向我展示文件夹内静态文件的内容。

    ```
      http {

        server {
            listen 5000;
            root /path/to/nginx-demo/main/; 

            location /content {
              root /path/to/nginx-demo/;
            }   

            location /outsider {
              root /path/temp-nginx/;
            }
       }

      }

      events {}

    ```

    > Pretty cool! Now Nginx is not only limited to defining URL roots but also to set rules such that I can block the client from accessing certain files.
    > 好酷！现在 Nginx 不仅限于定义根 URL，还可以设置规则，以便于我可以阻止客户端访问某些文件。

3. We're going to write an additional rule within our main server defined to block any **.md** files from being accessed. We can use regex in Nginx so we'll define the rule as follows:
3. 我们将在定义的主服务器中写入一条附加规则，用来阻止访问任何 **.md** 文件。我们可以在 Nginx 中使用正则表达式，规则定义如下：

    ```
       location ~ .md {
            return 403;
       }

    ```

4. Let's end this by learning the popular command `proxy_pass`. Now we've learned what a proxy and reverse proxy is so here we'll begin by defining another backend server running at port 8888. So now we've got 2 backend servers running at port 5000 and 8888.
4. 最后我们来学习一下流行的命令 `proxy_pass`。现在我们已经了解了什么是代理和反向代理，这里我们先定义另一个运行在 8888 端口的后台服务器，所以现在我们已经有了 2 个分别运行在 5000 和 8888 端口的后台服务器。

    What we'll do is that when the client accesses port 8888 through Nginx we'll pass this request to port 5000 & send the response back to the client!
    我们要做的是，当客户端通过 Nginx 访问 8888 端口时，将这个请求传到 5000 端口，并向客户端返回响应！

    ```
       server {
           listen 8888;

           location / {
               proxy_pass http://localhost:5000/;
           }

           location /new {
               proxy_pass http://localhost:5000/outsider/;
           }
      }

    ```

### Let's see the final complete code altogether! 😁
### 最后一起来看看完整的代码！😁

```
   http {

        server {
            listen 5000;
            root /path/to/nginx-demo/main/; 

            location /content {
                root /path/to/nginx-demo/;
            }   

            location /outsider {
               root /path/temp-nginx/;
            }

                    location ~ .md {
              return 403;
            }
       }

         server {
           listen 8888;

           location / {
               proxy_pass http://localhost:5000/;
           }

           location /new {
               proxy_pass http://localhost:5000/outsider/;
           }
      }

   }

   events {}

```

Run this code using `sudo nginx`.
通过 `sudo nginx` 来运行代码。

### Extra Nginx Commands!
### 额外的 Nginx 命令！

1. To start an Nginx web server for the first time.
1. 首次启动 Nginx Web 服务器。

    ```
      $ nginx 
      #OR 
      $ sudo nginx

    ```

2. To reload a running Nginx web server.
2. 重新加载正在运行的 Nginx Web 服务器。

    ```
      $ nginx -s reload
      #OR 
      $ sudo nginx -s reload

    ```

3. To stop a running Nginx web server.
3. 关闭正在运行的 Nginx Web 服务器。

    ```
      $ nginx -s stop
      #OR 
      $ sudo nginx -s stop

    ```

4. To know which processes of Nginx are running on your system.
4. 查找有哪些 Nginx 进程正在在系统中运行

    ```
      $ ps -ef | grep Nginx

    ```

The 4th command is important when by any chance the first 3 commands lead to some error, what you can normally do is find all running Nginx processes using the 4th command and kill the processes, and start it again.
第 4 条命令很重要，当前 3 条命令出现错误时，可以使用第 4 条命令找到所有正在运行的 Nginx 进程，然后 kill 掉这些进程，重新启动 Nginx 服务。

To kill a process, you need the PID and then kill it using:
要 kill 一个进程，你需要 PID，然后用下面的命令 kill 它：

```
$ kill -9 <PID>
#OR 
$ sudo kill -9 <PID>

```

Before ending this post, I've used diagrams and visuals from google images and couple of youtube tutorials by [Hussein Nasser](https://www.youtube.com/user/GISIGeometry).
在结束这篇文章之前，声明一下我所使用图片和视觉效果来自 Goole 图片和由 [Hussein Nasser](https://www.youtube.com/user/GISIGeometry) 提供的 Youtube 教程。

We've come to an end with the basic understanding of Nginx and its configuration. If you're interested in the advanced configuration of Nginx, do let me know through comments. Till then enjoy coding and explore the magic of Nginx! 👋
关于 Nginx 的基本认识和配置，我们就讲到这里。如果你对 Nginx 的进阶配置感兴趣，请通过评论告诉我。在此之前，请享受编程的乐趣，探索 Nginx 的魔力！👋
