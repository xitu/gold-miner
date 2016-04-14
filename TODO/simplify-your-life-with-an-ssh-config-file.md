>* 原文链接 : [Simplify Your Life With an SSH Config File](http://nerderati.com/2011/03/17/simplify-your-life-with-an-ssh-config-file/)
* 原文作者 : [Joël Perras](http://nerderati.com/about/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [circlelove](https://github.com/circlelove)
* 校对者: [sqrthree](https://github.com/sqrthree) ; [L9m](https://github.com/L9m)
* 状态： 翻译完成

# SSH 简化配置

假如你和我相似的话，或许你的日常就是登入登出六七个远程服务器（或者在那些日子里面使用本地虚拟机）。如果你和我更相像，对于记住n多用户名、远程地址和那些记住非标准连接端口以及本地端口发往远程机器和命令行选项感到头疼。

### shell 别名

好比你有个名为 `dev.example.com` 的远程服务器，它没有为无密码登录设置公钥和私钥。远程账户名为 fooey ，为了减少脚本式登录的次数，你决定把默认 SSH 端口从常规默认值`22`改成`2200`.这就像下面典型的命令一样：

    $ ssh fooey@dev.example.com -p 22000
    password: *************

还不错哈。

我们也可以使用公钥/私钥对让事情更简洁安全；我强烈建议使用 [ssh-copy-id](http://linux.die.net/man/1/ssh-copy-id)来移动你的公共密钥。它能够省去相当数量的文件/文件夹访问许可问题
    $ ssh fooey@dev.example.com -p 22000
    # Assuming your keys are properly setup…

现在这看上去还不算太坏。为了简化冗长的情况，你也可以在 shell 里面创建简单的别名。

    $ alias dev='ssh fooey@dev.example.com -p 22000'
    $ dev # To connect

这个方法相当漂亮：每当需要连接新服务器的时候，只要添加一个别名到你的 .bashrc(或者.zshrc 如果你和很棒的人在一起)，那就是：

### ~/.ssh/config

不过，该问题还有更多优雅灵活的解决方案。进入 SSH 配置文件：

    # contents of $HOME/.ssh/config
    Host dev
        HostName dev.example.com
        Port 22000
        User fooey


这意味着我可以轻松地进行 `$ ssh dev`，选项可以在配置文件中读取。简单极了。让我们看看我们还能用简单的配置指令做什么。


从个人角度来说，我在各种服务器和设备上使用了相当多的公钥/私钥对，为了将密钥泄露事件发生之后的损害降到最低。例如，我有一个专门为 [Github](https://github.com/jperras)  账户设置的密码。让我们配置好特定密钥就可以用于所有 github 相关的操作了：

    Host dev
        HostName dev.example.com
        Port 22000
        User fooey</p>
    Host github.com
        IdentityFile ~/.ssh/github.key


使用带有 `IdentityFile` 的配置文件可以让我精确定位那个我希望用来给主机权限的私钥。你当然也可以轻松地指定命令行选项为”正常“的链接。

    $ ssh -i ~/.ssh/blah.key username@host.com



但是，如果你想指定哪个身份来使用任意 git 命令时，带有 IdentityFile 的配置文件的使用[差不多是你唯一的选择](https://git.wiki.kernel.org/index.php/GitTips#How_to_pass_ssh_options_in_git.3F) 。这也启发了基于每个项目或组织来进一步细分的的有趣设想。

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


这意味着如果我想以我的组织认证克隆一个仓库的话，我能够使用以下的命令


    $ git clone git@github-org:orgname/some_repository.git


### 更进一步


像所有有安全意识的开发者会做的那样，我为所有的服务器都架设了防火墙，使他们尽可能地受限；很多情况下，这意味着我留下来可用的端口只有`80`和`443`（为web服务器），以及为 SSH 的`22`端口（无论我可能映射到欢笑的目的）。表面上看，这似乎防止让我使用像桌面 MySQL 图形客户端这样的东西，在远程服务器上，想要开放和访问的 3306 端口仍未知。然而，懂行的读者会清楚，一个简单的本地端口能省去很多事：

    $ ssh -f -N -L 9906:127.0.0.1:3306 coolio@database.example.com
    # -f puts ssh in background
    # -N makes it not execute a remote command



这样就能把所有来自本地端口`9906`转入远程服务器`dev.example.com`端口`3306`,让我指向桌面图形用户界面到主机名（127.0.0.1:9906)，让它表现得完全像是把`3306`端口全部暴露在远程服务器和直接设备上一样。


现在我不了解你，但是得记住表示标记和[SSH](http://linux.die.net/man/1/ssh)选项的顺序真是令人难受。幸运的是，我们的配置文件可以帮您减负。

    Host tunnel
        HostName database.example.com
        IdentityFile ~/.ssh/coolio.example.key
        LocalForward 9906 127.0.0.1:3306
        User coolio



意味着我可以轻松地进行：
```
   $ ssh -f -N tunnel

```
然后我本地端口转发能够使用我设置在隧道主机上的所有指令，十分顺畅。

### 作业


你可以在`~/.ssh/config`里面指定相当数量的配置选项，我强烈建议你常看网上的[文档](http://linux.die.net/man/5/ssh_config)或者 **ssh_config**  手册页。你可以添加一些有趣/有用的东西：更改连接尝试的默认数量，指定本地环境变量在连接后传给远程服务器，改变默认连接尝试数量。甚至是使用*还有?的通配符来匹配主机。

我希望这些多少对你有用。如果你针对 SSH 配置文件有任何很酷的技巧，在评论中留下你的想法；我一直在寻找有趣的技巧。

