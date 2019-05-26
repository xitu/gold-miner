> * 原文地址：[Running Flask with an SSH Remote Python Interpreter](https://blog.jetbrains.com/pycharm/2018/04/running-flask-with-an-ssh-remote-python-interpreter/)
> * 原文作者：[Ernst Haagsman](https://blog.jetbrains.com/pycharm/author/ernst-haagsmanjetbrains-com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/running-flask-with-an-ssh-remote-python-interpreter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/running-flask-with-an-ssh-remote-python-interpreter.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[shisaq](https://github.com/shisaq)

# 通过 SSH 远程使用 Python 解释器来运行 Flask

许多应用程序中出现 bug 的普遍原因是开发环境和生产环境不同。虽然在大多数情况下不可能为开发提供生产环境中的精确副本，但[追求生产-开发的均衡](https://12factor.net/dev-prod-parity)是值得的。

大多数应用程序会被部署到某种类型的 Linux 虚拟机中。或许你正在使用的是传统的 web 主机，即所谓的 VPS 主机。

如果我们想在一个类似于我们生产环境的环境中进行开发，那我们如何才能做到这一点呢？最好的方法就是为了开发目的而设置第二个虚拟机。让我们看看 PyCharm 是如何连接到 VPS 环境。

## 我们的应用程序

我太懒了，所以我将使用自己去年做的一款 web-app 作为示例。该应用程序是一个非常简单的老式留言系统。在去年的博客中，我使用 Dockeer Compose 来描述了一个包含 Python 服务和 PostgreSQL 数据库的环境。

首先[克隆仓库](https://github.com/ErnstHaagsman/flask-compose/tree/with-database)，然后切换到 ‘with-database’ 分支。打开项目之后，我们需要配置服务器。我使用 AWS EC2 实例，但是你也可以使用任何其他的 Linux 环境（包括树莓派）。 

想要配置解释器，请打开设置/项目设置，并使用齿轮图标添加解释器：

![添加解释器](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Add-Interpreter.png)

在左边选择 SSH。如果你没有看到 SSH，首先要确保自己使用的是 PyCharm Professional 2018 或者更高版本。然后，按照指示链接到 SSH 框即可：

[![连接到 SSH](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/RC-SSH.png)](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/RC-SSH.png)

在本教程中，我们将主要使用默认值。唯一的例外是你的 Linux 环境只安装了 Python 3，而且并没有将 /usr/bin/python 连接到该版本。考虑到 AWS 的当前版本 Ubuntu 16.04 AMI，我们将确保会更改解释器路径：

[![添加 SSH 解释器 —— 第二步](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Add-SSH-interpreter-step-2.png)](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Add-SSH-interpreter-step-2.png)

我们配置好解释器后，就可以开始运行代码了。比如，打开 Python 控制台，就可以在远程控制台上运行代码了：

[![Python 远程控制台](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Remote-Python-Console.png)](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Remote-Python-Console.png)

在我们可以运行我们 Flask 脚本之前，还有一些事情需要我们处理。

## 配置我们的环境

Docker Compose 非常方便，因为它允许我们以非常简洁的方式指定和配置服务器。如果我们想要在常规 Linux 机器上工作，我们需要自己处理这个配置。因此，我们先开始下载 PostgreSQL。

打开 SSH 会话，也可以转到工具/SSH 会话，或者使用 Ctrl+Shift+A 查找 ‘Start SSH session’ 操作：

[![开启 SSH 会话](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Start-SSH-session.png)](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Start-SSH-session.png)

现在，我们可以运行 `sudo apt-get install postgresql`。如果你正在树莓派上实验，也是如此。如果我们正在开发一个应用程序，那么记录我们正在做的事情，可以确保我们以后正确重现环境。 

一款配置 Linux 机器的优秀软件是 [Ansible](https://www.ansible.com/)。使用 Ansible，我们可以通过 YAML 文件来描述 Linux 服务器的所需状态，然后使用 Ansible 工具来应用所需的配置。

用 Ansible 安装 PostgreSQL，如下所示：

```
- hosts: localhost
  become: yes
  tasks:
   - name: Install PostgreSQL
     apt:
       name: postgresql-9.5
```

如果我们使用这些内容新建一个 `setup.yml` 文件，PyCharm 会自动将其上传到我们在项目配置期间配置的位置。默认情况下，这是 `/tmp/` 的子文件夹。因此，我们先安装 Ansible，导航到这个文件夹，运行这个文件（在 Ansible 术语中称为 playbook）。你可以通过在服务器上运行这些命令（使用你之前启动的 SSH 会话）来实现这一点：

```
sudo apt update && sudo apt install -y ansible
cd /tmp/pycharm*
ansible-playbook ./setup.yml
```

看下这个，PostgreSQL 已经安装了：

[![Ansible Output](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Ansible-Output.png)](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Ansible-Output.png)

我们可以使用 Ansible 做一些更酷的事情，比如配置虚拟环境：

```
- name: Install pip
  apt:
    name: python3-pip

- name: Copy requirements
  copy:
    src: requirements.txt
    dest: /tmp/requirements.txt

- name: Install virtualenv
  pip:
    name: virtualenv
    executable: pip3

- name: Set up virtualenv
  become: false
  pip:
    requirements: /tmp/requirements.txt
    virtualenv: /home/ubuntu/venv
    virtualenv_python: python3
```

我们将这些任务添加到 playbook（setup.yml）并重新运行之后，就可以重新配置 PyCharm 来使用远程 venv 而不是我们环境的系统解释器。为此，请返回到设置解释器的界面。使用齿轮图标选择“显示所有”，然后单击铅笔编辑解释器。更改虚拟环境 （`/home/ubuntu/venv/bin/python`）中 Python 可执行文件的路径:

[![修改解释器](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Change-interpreter.png)](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Change-interpreter.png)

既然我们已经准备妥当，我们可以运行 Flask 来运行配置。让我们先编辑它，这样它就可以从外界获取。我们需要提供 `host=0.0.0.0` 作为 Flask 的附加选项：

[![Flask Run Configuration](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Flask-Run-Configuration.png)](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Flask-Run-Configuration.png)

如果你在 AWS 或类似的提供者上运行此代码，则可能需要在防火墙中打开端口 5000。在 AWS 上，你需要向安全组添加一个新规则，允许 TCP 端口 5000 上的入站流量从 0.0.0.0/0 开始。

现在点击 debug 按钮来运行 Flask：

[![Flask Starts](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Flask-Starts.png)](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Flask-Starts.png)

让我们访问下我们的页面！

[![500 Error](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/500-Error.png)](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/500-Error.png)

用 Butters Stotch 的话来说：oh hamburgers。如果我们回顾一下 PyCharm，就会在调试窗口看到堆栈的跟踪信息，这表明我们仍然需要完成数据库连接。

在 Flask 应用程序中，为了用于 Docker Compose 配置，数据库主机被设置为 ‘db’。我们将其改为 `127.0.0.1`：

```
g.db = psycopg2.connect(dbname='flaskapp',
                       user='flaskapp',
                       password='hunter2',
                       host='127.0.0.1')
```

我们实际上还需要创建数据库和表。感谢我们的朋友 [Ansible 可以帮助我们](http://docs.ansible.com/ansible/latest/list_of_database_modules.html)！为了保证这篇博客更短一些，我会跳过一些细节。切换到 ‘ansible’ 分支。然后运行以下 SSH 命令：

```
cd /tmp/pycharm*
ansible-playbook setup.yml
ansible-playbook clean-db.yml
```

第一个剧本会配置 PostgreSQL 用户账户。第二个剧本会删除已存在的数据库，然后创建一个干净的数据库。在这个数据库中，运行 `schema.sql` 文件来创建这个应用程序所需要的表。

你还可以使用 PyCharm 来运行 SQL 命令并检查数据库。 [阅读我们关于在树莓派上运行代码的文章来了解更多内容](https://blog.jetbrains.com/pycharm/2017/07/raspberry-ping-1/)。

## The Finish Line

在设置数据库后，我们应该可以使用调试配置再次启动 Flask，并查看我们的炫酷的留言系统：

[![Results](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Results.png)](https://d3nmt5vlzunoa1.cloudfront.net/pycharm/files/2018/03/Results.png)

当然，如果我们要在代码中添加一个断点，我们现在就可以选中它了。尝试一下，然后告诉我们它的进展！

如果你对 DevOps 感兴趣，而且想了解更多信息：[阅读我们的 AWS 高级教程](https://blog.jetbrains.com/pycharm/2017/12/developing-in-a-vm-with-vagrant-and-ansible/)、我们的[树莓派教程](https://blog.jetbrains.com/pycharm/2017/07/raspberry-ping-1/)或者我们的 [Docker Compose 教程](https://blog.jetbrains.com/pycharm/2017/08/using-docker-compose-on-windows-in-pycharm/)。如果你还有其他想了解的内容，请在评论中告诉我们！ 

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
