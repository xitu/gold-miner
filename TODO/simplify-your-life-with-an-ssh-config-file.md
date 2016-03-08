>* 原文链接 : [Simplify Your Life With an SSH Config File](http://nerderati.com/2011/03/17/simplify-your-life-with-an-ssh-config-file/)
* 原文作者 : [Joël Perras](http://nerderati.com/about/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态： 认领中

# 用SSH  配置文件简化你的生活

假如你和我相似的话，或许你的日常就是登陆登出六七个远程服务器（或者在那些日子里面使用本地虚拟机）。如果你和我更相像，对于记住n多用户名、远程地址和那些记住非标准连接端口以及本地端口发往远程机器和命令行选项感到头疼。

### shell别名

好比你有个名为dev.example.com的远程服务器，它没有为登录设置公钥和私钥进行无密码登录。远程账户名为fooey，为了减少登录尝试的次数的表述，你决定把默认SSH端口从常规默认值22改成2200 。这就像下面典型的命令一样：

    $ ssh fooey@dev.example.com -p 22000
    password: *************

还不错哈。

我们也可以使用公钥/私钥对让事情更简单更安全；我强烈建议使用 [ssh-copy-id](http://linux.die.net/man/1/ssh-copy-id)来移动你的公共密钥。它能够省去相当数量的文件/文件夹访问许可问题
    $ ssh fooey@dev.example.com -p 22000
    # Assuming your keys are properly setup…

现在这看上去还不算太坏。为了简化冗长的情况，你也可以在shell里面创建简单的别名。

    $ alias dev='ssh fooey@dev.example.com -p 22000'
    $ dev # To connect

这个操作惊人地漂亮：每当需要连接新服务器的时候，只要添加一个别名到你的.bashrc(或者.zshrc 如果你和最酷的小伙伴一起)，那就是：

### ~/.ssh/config

不过，该问题还有更多优雅灵活的解决方案。进入SSH配置文件：

    # contents of $HOME/.ssh/config
    Host dev
        HostName dev.example.com
        Port 22000
        User fooey

This means that I can simply `$ ssh dev`, and the options will be read from the configuration file. Easy peasy. Let's see what else we can do with just a few simple configuration directives.
这意味着我可以轻松地进行`$ ssh dev`，选项可以在配置文件中读取。简单极了。让我们看看我们还能用简单的配置指令做什么。


从个人角度来说，我在各种服务器和设备上使用了相当多的公钥/私钥对，为了保证密钥泄露事件发生之后尽可能限制迫话程度。例如，我有一个不只是为[Github](https://github.com/jperras) 账户设置的密码。让我们配置好它私钥就可以在所有github关联的操作了：

    Host dev
        HostName dev.example.com
        Port 22000
        User fooey</p>
    Host github.com
        IdentityFile ~/.ssh/github.key


使用`IdentityFile`可以让我精确定位那个私钥我希望用来给主机权限。你当然也可以轻松地指定命令行选项为”普通“的链接。

    $ ssh -i ~/.ssh/blah.key username@host.com


but the use of a config file with `IdentityFile` is [pretty much your only option](https://git.wiki.kernel.org/index.php/GitTips#How_to_pass_ssh_options_in_git.3F) if you want to specify which identity to use for any git commands. This also opens up the very interesting concept of further segmenting your github keys on something like a per-project or per-organization basis:
但是，如果你想指定哪个身份来使用任意git命令时，带有IdentityFile的配置文件的使用[差不多是你唯一的选择](https://git.wiki.kernel.org/index.php/GitTips#How_to_pass_ssh_options_in_git.3F) 。

    Host github-project1
        User git
        HostName github.com
        IdentityFile ~/.ssh/github.project1.key</p>
    Host github-org
        User git
        HostName github.com
        IdentityFile ~/.ssh/github.org.key</p>
    Host github.com
        User git
        IdentityFile ~/.ssh/github.key


这意味着如果你想用我的组织认证克隆一个仓库的话，我能够看到以下的命令


    $ git clone git@github-org:orgname/some_repository.git


### 深入操作

As any security-conscious developer would do, I set up firewalls on all of my servers and make them as restrictive as possible; in many cases, this means that the only ports that I leave open are `80/443` (for webservers), and port `22` for SSH (or whatever I might have remapped it to for obfuscation purposes). On the surface, this seems to prevent me from using things like a desktop MySQL GUI client, which expect port `3306` to be open and accessible on the remote server in question. The informed reader will note, however, that a simple local port forward can save you:
像任何安全意识强的开发者会做的那样，我为所有的服务器都架设了防火墙，使他们尽可能强地约束；很多情况下，这意味着我留下来可用的端口只有`80`和`443`（为web服务器），以及为SSH的`22`端口（或者我不知道为了什么目的重构的）。表面上看，这似乎能阻止我使用桌面MySQL图形用户界面客户端，该客户端期望`3306`端口开放可访问问题远程服务器。然而，懂行的读者会清楚，一个简单的本地端口转发就能拯救你：

    $ ssh -f -N -L 9906:127.0.0.1:3306 coolio@database.example.com
    # -f puts ssh in background
    # -N makes it not execute a remote command



这样就能把所有来自本地端口`9906`转入远程服务器`dev.example.com`端口`3306`,让我指向桌面图形用户界面到主机名（127.0.0.1:9906)，让它表现得和我把`3306`端口全部暴露在远程服务器和直接设备上。


现在我不了解你，记住得表示标记和[SSH](http://linux.die.net/man/1/ssh)选项的结果真是令人难受。幸运的是，我们的配置文件可以您减负。

    Host tunnel
        HostName database.example.com
        IdentityFile ~/.ssh/coolio.example.key
        LocalForward 9906 127.0.0.1:3306
        User coolio



意味着我可以轻松地进行：
```
   $ ssh -f -N tunnel

```
我本地端口转送能够使用为隧道主机设置的所有配置指令，十分顺畅。

### Homework

There are quite a few configuration options that you can specify in `~/.ssh/config`, and I highly suggest consulting the online [documentation](http://linux.die.net/man/5/ssh_config) or the **ssh_config** man page. Some interesting/useful things that you can do include: change the default number of connection attempts, specify local environment variables to be passed to the remote server upon connection, and even the use of * and ? wildcards for matching hosts.
你可以在`~/.ssh/config`里面指定相当数量的配置选项，我强烈建议你常看网上的[documentation](http://linux.die.net/man/5/ssh_config)或者**ssh_config** man网页。你可以添加一些有趣/有用的东西：改变默认连接尝试数量、特殊本地环境变化再进行。指定本地环境变量将被传递到远程服务器的连接时连接。甚至是*还有?的通配符来匹配主机。
I hope that some of this is useful to a few of you. Leave a note in the comments if you have any cool tricks for the SSH config file; I'm always on the lookout for fun hacks.
我希望这些多少对你有用。如果你针对SSH配置文件有任何巧妙的做法，在评论中留下你的想法；我一直在寻找有趣的黑客。
