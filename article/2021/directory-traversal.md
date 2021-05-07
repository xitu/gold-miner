> * 原文地址：[Directory Traversal Attacks](https://www.acunetix.com/websitesecurity/directory-traversal/)
> * 原文作者：[Acunetix](https://www.acunetix.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/directory-traversal.md](https://github.com/xitu/gold-miner/blob/master/article/2021/directory-traversal.md)
> * 译者：
> * 校对者：

# Directory Traversal Attacks

## What is a Directory Traversal attack?

Properly controlling access to web content is crucial for running a secure web server. Directory traversal or [Path Traversal](https://www.acunetix.com/blog/articles/path-traversal/) is an HTTP attack which allows attackers to access restricted directories and execute commands outside of the web server’s root directory.

Web servers provide two main levels of security mechanisms

* Access Control Lists (ACLs)
* Root directory

An Access Control List is used in the authorization process. It is a list which the web server’s administrator uses to indicate which users or groups are able to access, modify or execute particular files on the server, as well as other access rights.

![What is a Directory Traversal Attack?](https://www.acunetix.com/wp-content/uploads/2012/10/PTMFOG00000002841.gif "Directory Traversal Attacks")

The root directory is a specific directory on the server file system in which the users are confined. Users are not able to access anything above this root.

For example: the default root directory of IIS on Windows is C:\\Inetpub\\wwwroot and with this setup, a user does not have access to C:\\Windows but has access to C:\\Inetpub\\wwwroot\\news and any other directories and files under the root directory (provided that the user is authenticated via the ACLs).

The root directory prevents users from accessing any files on the server such as C:\\WINDOWS/system32/win.ini on Windows platforms and the /etc/passwd file on Linux/UNIX platforms.

This vulnerability can exist either in the web server software itself or in the web application code.

In order to perform a directory traversal attack, all an attacker needs is a web browser and some knowledge on where to blindly find any default files and directories on the system.

## What an attacker can do if your website is vulnerable

With a system vulnerable to directory traversal, an attacker can make use of this vulnerability to step out of the root directory and access other parts of the file system. This might give the attacker the ability to view restricted files, which could provide the attacker with more information required to further compromise the system.

Depending on how the website access is set up, the attacker will execute commands by impersonating himself as the user which is associated with “the website”. Therefore it all depends on what the website user has been given access to in the system.

## Example of a Directory Traversal attack via web application code

In web applications with dynamic pages, input is usually received from browsers through GET or POST request methods. Here is an example of an HTTP GET request URL

GET http://test.webarticles.com/show.asp?view=oldarchive.html HTTP/1.1
Host: test.webarticles.com

With this URL, the browser requests the dynamic page show.asp from the server and with it also sends the parameter view with the value of oldarchive.html. When this request is executed on the web server, show.asp retrieves the file oldarchive.html from the server’s file system, renders it and then sends it back to the browser which displays it to the user. The attacker would assume that show.asp can retrieve files from the file system and sends the following custom URL.

GET http://test.webarticles.com/show.asp?view=../../../../../Windows/system.ini HTTP/1.1
Host: test.webarticles.com

This will cause the dynamic page to retrieve the file system.ini from the file system and display it to the user. The expression ../ instructs the system to go one directory up which is commonly used as an operating system directive. The attacker has to guess how many directories he has to go up to find the Windows folder on the system, but this is easily done by trial and error.

## Example of a Directory Traversal attack via web server

Apart from vulnerabilities in the code, even the web server itself can be open to directory traversal attacks. The problem can either be incorporated into the web server software or inside some sample script files left available on the server.

The vulnerability has been fixed in the latest versions of web server software, but there are web servers online which are still using older versions of IIS and Apache which might be open to directory traversal attacks. Even though you might be using a web server software version that has fixed this vulnerability, you might still have some sensitive default script directories exposed which are well known to hackers.

For example, a URL request which makes use of the scripts directory of IIS to traverse directories and execute a command can be

GET http://server.com/scripts/..%5c../Windows/System32/cmd.exe?/c+dir+c:\ HTTP/1.1
Host: server.com

The request would return to the user a list of all files in the C:\ directory by executing the cmd.exe command shell file and run the command dir c:\ in the shell. The %5c expression that is in the URL request is a web server escape code which is used to represent normal characters. In this case %5c represents the character \.

Newer versions of modern web server software check for these escape codes and do not let them through. Some older versions however, do not filter out these codes in the root directory enforcer and will let the attackers execute such commands.

## How to check for Directory Traversal vulnerabilities

The best way to check whether your website and web applications are vulnerable to directory traversal attacks is by using a Web Vulnerability Scanner. A Web Vulnerability Scanner crawls your entire website and automatically checks for directory traversal vulnerabilities. It will report the vulnerability and how to easily fix it. Besides directory traversal vulnerabilities a web application scanner will also check for SQL injection, Cross-site Scripting and other web vulnerabilities.

[Acunetix](https://www.acunetix.com/vulnerability-scanner/ "Acunetix Web Vulnerability Scanner") scans for [SQL Injection](https://www.acunetix.com/websitesecurity/sql-injection "SQL Injection: What is it?"), [Cross Site Scripting](https://www.acunetix.com/websitesecurity/cross-site-scripting/ "What is Cross Site Scripting?"), [Google Hacking](https://www.acunetix.com/websitesecurity/google-hacking/ "What is Google Hacking?") and many more vulnerabilities.

## Preventing Directory Traversal attacks

First of all, ensure you have installed the latest version of your web server software, and sure that all patches have been applied.

Secondly, effectively filter any user input. Ideally remove everything but the known good data and filter meta characters from the user input. This will ensure that only what should be entered in the field will be submitted to the server.

## Check if your website is vulnerable to attack with Acunetix

Acunetix ensures website security by automatically checking for [SQL Injection](https://www.acunetix.com/vulnerability-scanner/sql-injection/ "Auditing for SQL Injection Vulnerabilities is Critical"), [Cross-site Scripting](https://www.acunetix.com/cross-site-scripting/scanner-download/ "Is your website vulnerable to XSS attacks?"), Directory Traversal and other vulnerabilities. It checks password strength on authentication pages and automatically audits shopping carts, forms, dynamic content and other web applications. As the scan is being completed, the software produces detailed reports that pinpoint where vulnerabilities exist.

## Frequently asked questions

#### What is directory traversal and how does it work?

Directory traversal (path traversal) happens when the attacker is able to read files on the web server outside of the directory of the website. Directory traversal is only possible if the website developer makes mistakes.

[Read more about directory traversal](https://www.acunetix.com/blog/articles/path-traversal/).

#### What are the potential consequences of a directory traversal attack?

An attacker may use directory traversal to download server configuration files, which contain sensitive information and potentially expose more server vulnerabilities. Ultimately, the attacker may access confidential information or even get full control of the server.

[Directory traversal is becoming more common – read about it in our latest report](https://www.acunetix.com/acunetix-web-application-vulnerability-report/).

#### How to detect directory traversal vulnerabilities?

The only way to effectively detect directory traversal vulnerabilities is by using a web vulnerability scanner. A professional vulnerability scanner like Acunetix will give you detailed reports, advice on how to get rid of the vulnerability, and much more.

[Find out more about the capabilities of Acunetix Premium](https://www.acunetix.com/product/premium/).

#### How to defend against directory traversal attacks?

The only way to effectively defend against directory traversal attacks is to carefully write the code of the website or web application and use user input sanitization libraries. Note that web application firewalls (WAF) do not eliminate directory traversal issues, just make it harder for the attacker to exploit vulnerabilities.

[Learn how to make sure that your website code is secure](https://www.acunetix.com/blog/web-security-zone/secure-coding-practices/).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
