> - 原文地址：[What is SQL Injection (SQLi) and How to Prevent It](https://www.acunetix.com/websitesecurity/sql-injection/)
> - 原文作者：[Acunetix](https://www.acunetix.com/)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/sql-injection.md](https://github.com/xitu/gold-miner/blob/master/article/2021/sql-injection.md)
> - 译者：[MoonBall](https://github.com/MoonBall)
> - 校对者：[greycodee](https://github.com/greycodee)、[flashhu](https://github.com/flashhu)

# 什么是 SQL 注入攻击？如何阻止它

SQL 注入（SQLi）是一种可执行恶意 SQL 语句的[注入攻击](https://www.acunetix.com/blog/articles/injection-attacks/)。这些 SQL 语句可控制网站背后的数据库服务。攻击者可利用 SQL 漏洞绕过网站已有的安全措施。他们可绕过网站的身份认证和授权并访问整个 SQL 数据库的数据。他们也可利用 SQL 注入对数据进行增加、修改和删除操作。

SQL 注入可影响任何使用了 SQL 数据库的网站或应用程序，例如常用的数据库有 MySQL、Oracle、SQL Server 等等。攻击者利用它，便能无需授权地访问你的敏感数据，比如：用户资料、个人数据、商业机密、知识产权等等。SQL 注入是一种最古老、最流行、也最危险的网站漏洞。OWASP 组织（Open Web Application Security Project）在 2017 年的 [OWASP Top 10](https://www.acunetix.com/vulnerability-scanner/owasp-top-10-compliance/) 文档中将注入漏洞列为对网站安全最具威胁的漏洞。

![SQL Injection](https://www.acunetix.com/wp-content/uploads/2019/02/SQL-Injection-1024x624.jpg)

## 发起 SQL 注入攻击的过程及原因

为了发起 SQL 注入攻击，攻击者首先需要在网站或应用程序中找到那些易受攻击的用户输入。这些用户输入被有漏洞的网站或应用程序直接用于 SQL 查询语句中。攻击者可创建这些输入内容。这些内容往往被称为恶意载体，它们是攻击过程中的关键部分。随后攻击者将内容发送出去，恶意的 SQL 语句便会在数据库中被执行。

SQL 是一种用于管理关系型数据库中数据的查询语言。你能使用它进行查询、修改和删除数据。很多网站或应用程序将所有数据都存储在 SQL 数据库。有时候，你也可以使用 SQL 指令运行操作系统指令。因此，一次成功的 SQL 注入攻击可能会引起非常严重的后果。

- 攻击者可利用 SQL 注入，从数据库中得到其他用户的用户凭证。之后他们便能伪装成这些用户。这些用户中甚至有可能包括有所有数据库权限的数据库管理员。
- SQL 可用于从数据库中选择并输出数据。SQL 注入漏洞允许攻击者访问数据库服务中的所有数据。
- SQL 也可用于修改数据库中数据，或者添加新数据。例如，在金融产品中，攻击者能利用 SQL 注入修改余额，取消交易记录或给他们的账户转账。
- SQL 可用于从数据库中删除记录，甚至删除数据表。即使管理员做了数据库备份，在数据库中数据恢复之前，被删除的数据仍然会影响应用的可用性。而且，备份很可能没有覆盖最近的数据。
- 在某些数据库服务中，可通过数据库服务访问操作系统。这种设计可能是有意的，也可能是无意的。在这种情况下，攻击者将 SQL 注入作为初始手段，进而攻击防火墙背后的内网。

SQL 注入攻击的类型有：带内 SQL 注入（使用数据库错误或 UNION 指令）、盲目 SQL 注入和带外 SQL 注入。你可在 [SQL 注入的类型](https://www.acunetix.com/websitesecurity/sql-injection2/) 和[盲目 SQL 注入是什么](https://www.acunetix.com/websitesecurity/blind-sql-injection/)中了解更多信息。

为了一步步了解如何发起 SQL 注入攻击和它可能引起的严重后果，可参考[运用 SQL 注入：动手实践的例子](https://www.acunetix.com/blog/articles/exploiting-sql-injection-example/)。

## 简单的 SQL 注入例子

第一个例子非常简单。它展示了攻击者如何利用 SQL 注入漏洞绕过应用安全防护和管理员认证。

以下脚本是执行在网站服务器上的伪代码。它是通过用户名和密码进行身份认证的简单例子。该例子中数据库有一张名为 `users` 的表，该表中有两列数据：`username` 和 `password`。

```python
# 定义 POST 变量
uname = request.POST['username']
passwd = request.POST['password']

# 存在 SQL 注入漏洞的 SQL 查询语句
sql = “SELECT id FROM users WHERE username=’” + uname + “’ AND password=’” + passwd + “’”

# 执行 SQL 语句
database.execute(sql)
```

这些输入字段是容易遭受 SQL 注入攻击的。攻击者能够在输入字段中利用 SQL 指令，修改数据库服务执行的 SQL 语句。比如，他们可使用含有单引号的把戏，将 `password` 字段设置为：

```sql
password' OR 1=1
```

因此，数据库服务将执行以下 SQL 查询：

```sql
SELECT id FROM users WHERE username='username' AND password='password' OR 1=1'
```

由于 `OR 1=1` 语句，无论 `username` 和 `password` 是什么，`WHERE` 分句都将返回 `users` 表中第一个 `id`。数据库中第一个用户的 `id` 通常是数据库管理员。通过这种方式，攻击者不仅绕过了身份认证，而且还获得了管理员权限。他们也可以通过注释掉 SQL 语句的后续部分，进一步控制 SQL 查询语句的执行：

```
-- MySQL, MSSQL, Oracle, PostgreSQL, SQLite
' OR '1'='1' --
' OR '1'='1' /*
-- MySQL
' OR '1'='1' #
-- Access (using null characters)
' OR '1'='1' %00
' OR '1'='1' %16
```

## 基于合并查询的 SQL 注入例子

使用 UNION 操作符是最常见的 SQL 注入类型之一。它允许攻击者将两个或更多个 SELECT 语句的查询结果合并为一个结果。这种技术被称为基于合并查询的 SQL 注入。

以下是这种注入攻击的一个例子。该例子在 **testphp.vulnweb.com** 网页上进行，该网页是 Acunetix 维护的故意存在漏洞的网站。（译者注：可以跟着该例子在 [testphp.vulnweb.com](http://testphp.vulnweb.com/artists.php?artist=1) 站点体验 SQL 注入攻击的过程。）

以下 HTTP 请求是一位用户发送的合法正常请求：

```
GET http://testphp.vulnweb.com/artists.php?artist=1 HTTP/1.1
Host: testphp.vulnweb.com
```

![HTTP request a legitimate user would send](https://www.acunetix.com/wp-content/uploads/2012/10/image02.png)

`artist` 参数容易受到 SQL 注入攻击。以下的载体修改了该参数，希望找到某个不存在的记录。它设置该参数的值为 `-1`。当然，它可以是数据库中不存在的任意值。然而，负数往往是个好主意，因为数据库中的 id 很少会是负数。

在 SQL 注入攻击中，`UNION` 操作符通常被用于在原始查询语句中，附加恶意的 SQL 查询语句，网站服务将执行所有查询语句。注入的查询语句的结果将和原始查询语句的结果合并。这样攻击者便可以得到其他数据表中的数据。（译者注：这步是为了演示当 UNION 之后的语句为 `SELECT 1, 2, 3` 时，页面将输出 2 和 3。）

```
GET http://testphp.vulnweb.com/artists.php?artist=-1 UNION SELECT 1, 2, 3 HTTP/1.1
Host: testphp.vulnweb.com
```

![SQL injection using the UNION operator](https://www.acunetix.com/wp-content/uploads/2012/10/image00.png)

接下来的例子展示了在这个存在漏洞的网站中，如何修改 SQL 注入的载体并得到有意义的数据：

```
GET http://testphp.vulnweb.com/artists.php?artist=-1 UNION SELECT 1,pass,cc FROM users WHERE uname='test' HTTP/1.1
Host: testphp.vulnweb.com
```

![使用 UNION 运算符和 FROM 进行 SQL 注入](https://www.acunetix.com/wp-content/uploads/2012/10/image01.png)

## 如何防止 SQL 注入

防止 SQL 注入唯一可靠的方式是验证输入和参数化查询，参数查询包括预准备的查询语句（译者注：指存储过程）。网站应用不应该在代码中直接使用用户输入。开发者必须检查所有用户输入，而不是仅检查网页表单中的输入，比如登录表单。他们必须移除潜在的恶意代码因素，比如单引号。在你的线上环境中屏蔽数据库错误也是个好主意。因为结合数据库错误，SQL 注入攻击将获得更多数据库相关信息。

如果你使用 Acunetix 扫描器发现了 SQL 注入漏洞，你可能不能立即修复它。比如，这个漏洞可能存在开源代码中。在这种情况下，你可以临时使用网站防火墙对输入进行校验。

参考[在 PHP 应用中防止 SQL 注入漏洞并修复它们](https://www.acunetix.com/blog/articles/prevent-sql-injection-vulnerabilities-in-php-applications/)，了解在 PHP 语言中如何防止 SQL 注入攻击。参考 [Bobby Tables 教你阻止 SQL 注入攻击](http://bobby-tables.com/)，查找如何在其他编程语言中预防 SQL 注入攻击。

## 如何预防 SQL 注入——通用技巧

预防 SQL 注入攻击并不容易。特定的预防技术与 SQL 注入漏洞的子类型、SQL 数据库引擎和编程语言有关。尽管如此，你仍然可以遵循一些通用策略来确保网站安全。

### 第一步：培养并保持安全意识

为了保证你的网站安全，所有参与搭建该网站的人员都必须意识到 SQL 注入漏洞相关的风险。你应该为所有开发者、测试员工、运维员工和系统管理员提供适量的安全培训。你可以让他们参考这篇文章作为安全培训的开始。

### 第二步：不要信任任何用户输入

将所有用户输入都看作不可信的。任何被用作 SQL 查询的用户输入都有 SQL 注入攻击的风险。对待授权用户或内部员工的输入，也应该像对待外部用户输入一样，将其视为不可信。

### 第三步：使用白名单，而不是黑名单

不要基于黑名单过滤用户输入。因为聪明的攻击者总是能找到绕过黑名单的方法，所以应尽可能只使用严格的白名单，对用户输入进行验证和过滤。

### 第四步：采用最新的技术

更老的网站开发技术没有防止 SQL 注入攻击的保护机制。尽量使用最新版本的开发环境和开发语言，并使用与它们相关的新技术。例如，在 PHP 中应使用 PDO 而不是 MySQLi。

### 第五步：采用经过验证的机制

不要尝试从零开始建立应对 SQL 注入攻击的防护机制。大多数现代开发技术已经为你提供了预防 SQL 注入攻击的机制。你应该使用这些已有的技术，而不是尝试重新造轮子。比如，使用参数化查询和存储过程（stored procedure）。

### 第六步：周期性扫描

SQL 注入漏洞可能被开发者引入，也可能被外部库、模块或软件引入。你应该使用网站漏洞扫描器（比如 Acunetix）周期性扫描你的网站。如果你使用 Jenkins，你可以安装 Acunetix 插件，实现每次构建时进行自动扫描。

---

## 进一步阅读

[SQL 注入的类型](https://www.acunetix.com/websitesecurity/sql-injection2/)
[预防 SQL 注入指南](http://bobby-tables.com/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
