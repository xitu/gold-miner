> * 原文地址：[Increasing Attacker Cost Using Immutable Infrastructure](https://diogomonica.com/2016/11/19/increasing-attacker-cost-using-immutable-infrastructure/)
* 原文作者：[Diogo Mónica](https://diogomonica.com/author/diogo/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Increasing Attacker Cost Using Immutable Infrastructure




One neat thing about Docker containers is the fact that they are immutable. Docker ships with a copy-on-write filesystem, meaning that the base image cannot be modified, unless you explicitly issue a commit.

One of the reasons why this is so handy is that you get to check for drift really easily, and that might come in handy if are trying to investigate a security incident.

### Demo application

Take the following demo infrastructure as an example:

![](https://diogomonica.com/content/images/2016/09/Security-@Scale-diagrams.png)

We have a [PHP application](https://github.com/diogomonica/apachehackdemo) running on our Front-end, and a MySQL server acting as our backend database. You can follow along at home by running:

    ➜ docker run -d --name db -e MYSQL_ROOT_PASSWORD=insecurepwd mariadb
    ➜ docker run -d -p 80:80 --link db:db diogomonica/phphack

Now that you have your database and front-end running you should be greeted by something that looks like this:

![](https://diogomonica.com/content/images/2016/09/Screenshot-2015-06-03-17-31-26-1.png)

Unfortunately, and not unlike every single other PHP application out there, this application has a remote code execution vulnerability:

    if($links) {  
    Links found  
    ... 
    eval($_GET['shell']);  
    ?>

It looks like someone is using `eval` where they shouldn't! Any attacker can exploit this vulnerability, and execute arbitrary commands on the remote host:

    ➜ curl -s http://localhost/\?shell\=system\("id"\)\; | grep "uid="
    uid=33(www-data) gid=33(www-data) groups=33(www-data)  

The first action of any attacker on a recently compromised host is to make herself at home by downloading PHP shells and toolkits. Some attackers might even be inclined to redesign your website:

![](https://diogomonica.com/content/images/2016/09/Screenshot-2016-09-03-20-36-55.png)

### Recovering from the hack

Going back to immutability, one of the cool things that a copy-on-write filesystem provides is the ability to see all the changes that took place. By using the `docker diff` command, we can actually see what the attacker was up to in terms of file modifications:

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

Interesting. It seems like the attacker not only modified our `index.html`, but also downloaded a php-shell, conveniently named `shell.php`. But our focus should be on getting the website back online.

We can store this image for later reference by doing a `docker commit`, and since containers are immutable (🎉), we can restart our container and we’re back in business:

    ➜ docker commit pensive_meitner
    sha256:ebc3cb7c3a312696e3fd492d0c384fe18550ef99af5244f0fa6d692b09fd0af3  
    ➜ docker kill pensive_meitner
    ➜ docker run -d -p 80:80 --link db:db diogomonica/phphack

![](https://diogomonica.com/content/images/2016/09/backinbiz.png)

We can now go back to the saved image and look at what the attacker modified:

    ➜ docker run -it ebc3cb7c3a312696e3fd492d0c384fe18550ef99af5244f0fa6d692b09fd0af3 sh
    # cat index.html
    HACKED BY SUPER ELITE GROUP OF HACKERS  
    # cat shell.php
    

It looks like we just got hacked by the famous SUPER ELITE GROUP OF HACKERS. ¯\_(ツ)_/¯

### Increasing the attacker cost

Being able to see the changes in the container after an attack is certainly useful, but what if we could have avoided the attack in the first place? This is where `--read-only` comes in.

The `--read-only` flag instructs Docker to not allow any writes to the container’s file-system. This would have avoided any modifications to `index.php`, but more importantly, it would not have allowed the attacker to download the php shell, or any other useful tools the attacker might want to use.

Let’s try it out and see what happens:

    ➜ docker run -p 80:80 --link db:db -v /tmp/apache2:/var/run/apache2/ -v /tmp/apache:/var/lock/apache2/ --sig-proxy=false --read-only diogomonica/phphack
    ...
    172.17.0.1 - - [04/Sep/2016:03:59:06 +0000] "GET / HTTP/1.1" 200 219518 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.82 Safari/537.36 OPR/39.0.2256.48"  
    sh: 1: cannot create index.html: Read-only file system  

Given that our filesystem is now read-only, it seems that the attacker’s attempt to modify our `index.html` was foiled. 😎

### Is this bullet-proof?

No, absolutely not. Until we fix this RCE vulnerability, the attacker will still be able to execute code on our host, steal our credentials, and exfiltrate the data in our database.

This said, together with running a [minimal image](https://hub.docker.com/_/alpine/), and some other really cool [Docker security features](https://www.delve-labs.com/articles/docker-security-production-2/), you can make it _a lot_ harder for any attacker to maintain persistence and continue poking around your network.

### Conclusion

The security of our applications will never be perfect, but having immutable infrastructure helps with incident response, allows fast-recovery, and makes the attacker’s jobs harder.

If by using a strong sandbox and tuning a few knobs you can make your application safer, why wouldn’t you? 🐳



