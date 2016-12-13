> * 原文地址：[Increasing Attacker Cost Using Immutable Infrastructure](https://diogomonica.com/2016/11/19/increasing-attacker-cost-using-immutable-infrastructure/)
* 原文作者：[Diogo Mónica](https://diogomonica.com/author/diogo/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Airmacho](https://github.com/Airmacho)
* 校对者：[sqrthree](https://github.com/sqrthree), [marcmoore](https://github.com/marcmoore), [xiaoheiai4719](https://github.com/xiaoheiai4719)

## 用不可变的基础设施提高攻击者的攻击成本

Docker 容器的一个便捷之处在于它们是不可变的。Docker 附带一个写入时复制的文件系统，意味着基础镜像不能被修改，除非你显式地发布一个提交。

这么便利的原因之一是，你很容易检查出被修改的地方，如果试图调查一个安全事件，这可能会派上用场。

## Demo 应用

以这个 demo 基础设施举例来说：

![](https://diogomonica.com/content/images/2016/09/Security-@Scale-diagrams.png)

我们有一个 [PHP 应用](https://github.com/diogomonica/apachehackdemo)作为前端，用 MYSQL 服务器作为我们的后端数据库，你可以在家试试跑一下命令：

~~~
➜ docker run -d --name db -e MYSQL_ROOT_PASSWORD=insecurepwd mariadb
➜ docker run -d -p 80:80 --link db:db diogomonica/phphack
~~~

现在你的数据库和前端都已经启动起来了，你可以在浏览器看到类似这样的欢迎语：

![](https://diogomonica.com/content/images/2016/09/Screenshot-2015-06-03-17-31-26-1.png)

不幸的是，像其他的 PHP 应用一样，这个应用有远程代码执行的漏洞：

    if($links) {  
    Links found  
    ... 
    eval($_GET['shell']);  
    ?>

看起来某些人正在不应该使用`eval`的地方使用`eval` ！任何攻击者都可能发现这个漏洞，并在远程机器上执行任意命令：

    ➜ curl -s http://localhost/\?shell\=system\("id"\)\; | grep "uid="
    uid=33(www-data) gid=33(www-data) groups=33(www-data)  

攻击者对刚被攻破的主机的第一个动作是通过下载 PHP 的 Shell 和其他工具包让自己反客为主。有些攻击者甚至可能会改写你的网站：



![](https://diogomonica.com/content/images/2016/09/Screenshot-2016-09-03-20-36-55.png)

## 从被 hack 恢复

回到不可变性，写入时复制的文件系统提供的一个很酷的特性就是可以看到发生的所有更改。通过使用`docker diff`命令，我们可以看到攻击者修改文件的详情：

    ➜ docker diff pensive_meitner
    C /run  
    C /run/apache2  
    A /run/apache2/apache2.pid  
    C /run/lock  
    C /run/lock/apache2  
    C /var  
    C /var/www  
    C /var/www/html  
    C /var/www/html/index.html  
    A /var/www/html/shell.php  

很有趣。攻击者似乎不仅修改了我们的`index.html`，还下载了一个 php-shell，简单地将其命名为`shell.php`。但我们的关注点应该是让网站重新上线。

我们可以通过`docker commit`命令存储这个镜像，供以后参考，并且由于容器是不可变的（🎉），我们可以重新启动我们的容器，现在所有都恢复了：

    ➜ docker commit pensive_meitner
    sha256:ebc3cb7c3a312696e3fd492d0c384fe18550ef99af5244f0fa6d692b09fd0af3  
    ➜ docker kill pensive_meitner
    ➜ docker run -d -p 80:80 --link db:db diogomonica/phphack

![](https://diogomonica.com/content/images/2016/09/backinbiz.png)

我们现在可以回到存储的镜像，看攻击者修改了什么：

    ➜ docker run -it ebc3cb7c3a312696e3fd492d0c384fe18550ef99af5244f0fa6d692b09fd0af3 sh
    # cat index.html
    HACKED BY SUPER ELITE GROUP OF HACKERS  
    # cat shell.php

看起来我们被著名的 SUPER ELITE GROUP OF HACKERS 攻击了。¯\_(ツ)_/¯

## 提高攻击者的成本

被攻击后可以看到容器里的改变很有意义，但是如果我们可以第一时间就避免被攻击呢？这就是`--read--only`发挥用处的地方了。

`--read-only`这个参数可以限制 Docker 不允许写入容器的文件系统。这就避免了任何对`index.php`的修改，更重要的是，它不允许攻击者下载 PHP shell 或者其他的攻击者想用的工具

让我们试下修改，看会发生什么：

    ➜ docker run -p 80:80 --link db:db -v /tmp/apache2:/var/run/apache2/ -v /tmp/apache:/var/lock/apache2/ --sig-proxy=false --read-only diogomonica/phphack
    ...
    172.17.0.1 - - [04/Sep/2016:03:59:06 +0000] "GET / HTTP/1.1" 200 219518 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.82 Safari/537.36 OPR/39.0.2256.48"  
    sh: 1: cannot create index.html: Read-only file system  

既然我们的文件系统现在是只读的了，似乎攻击者想要修改我们`index.html`文件的企图破灭了。😎

## 这就刀枪不入了吗？

不，绝对不是。除非我们能修复这个 RCE 漏洞，否则攻击者仍然能在我们的主机上执行代码，窃取我们的凭证，泄漏我们数据库中的数据。

配合运行[最小化镜像](https://hub.docker.com/_/alpine/)和一些很酷的[ Docker 安全特性](https://www.delve-labs.com/articles/docker-security-production-2/)，你可以使攻击者继续骚扰并占用你的网络变得**更**难。

## 结论

我们的应用程序的安全性从来就不完美，但通过不可变的基础设施协助完成事件响应，实现快速恢复，可以加大攻击者的难度。

如果用一个强大的沙盒并且调整几个旋钮就可以让你的应用更加安全，为什么不这样做呢？🐳



