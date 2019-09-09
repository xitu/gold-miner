> * 原文地址：[Syslog : The Complete System Administrator Guide](https://devconnected.com/syslog-the-complete-system-administrator-guide/)
> * 原文作者：[Schkn](https://devconnected.com/author/schkn/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/syslog-the-complete-system-administrator-guide.md](https://github.com/xitu/gold-miner/blob/master/TODO1/syslog-the-complete-system-administrator-guide.md)
> * 译者：https://github.com/githubmnume
> * 校对者：

# Syslog:《系统管理员完整指南》

[![Syslog : The Complete System Administrator Guide](https://devconnected.com/wp-content/themes/soledad/images/penci2-holder.png "syslog featured")](https://devconnected.com/wp-content/uploads/2019/08/syslog-featured-1.png) 

如果您是**系统管理员**，或者只是一个普通的Linux用户，那么您很有可能至少使用过一次 **Syslog**。

在您的Linux系统上，几乎所有与系统日志记录相关的东西都链接到 **Syslog 协议**。

syslog协议由埃里克·奥尔曼(伯克利大学)在80年代早期设计，它是一个规范，定义了 **任何系统上消息日志记录的标准**。

是的..任何系统。

系统日志并不与Linux操作系统相关联，它也可以在Windows操作系统上使用，或者仅在实现系统日志协议的操作系统上使用。 

如果您想更多地了解syslog日志和一般的Linux日志记录，这可能是您应该阅读的教程。

**以下是您需要了解的关于syslog日志的所有信息。**

## I – Syslog日志的目的是什么？

![Syslog presentation card](https://devconnected.com/wp-content/uploads/2019/08/syslog-card.png)

**Syslog用作生成、转发和收集在Linux实例上生成的日志的标准。Syslog定义了严重性级别和设施级别，有助于用户更好地理解其计算机上生成的日志。日志稍后可以在称为Syslog服务器的服务器上分析和可视化。**

以下是syslog协议最初设计的几个原因:

* **定义体系结构**: 稍后将详细解释这一点，但是如果syslog是一个协议，它可能是具有多个客户端和服务器的完整网络体系结构的一部分。因此，我们需要定义角色，简而言之:您将接收、生成还是转发数据？
* **消息格式**: 定义了消息的格式化方式。这显然需要标准化，因为日志经常被解析并存储到不同的存储引擎中。因此，我们需要定义系统日志客户端能够产生什么，系统日志服务器能够接收什么；
* **指定可靠性**: syslog需要定义它如何处理无法传递的消息。作为TCP/IP堆栈的一部分，syslog显然会被添加到底层的网络协议中进行选择；
* **处理身份验证或消息真实性**: syslog需要一种可靠的方法来确保客户端和服务器以安全的方式进行交互，并且接收到的消息不会被更改。

现在我们知道为什么首先规定Syslog，**让我们看看Syslog架构是如何工作的。** 

## II – 什么是Syslog架构?

当设计一个日志架构时，比如一个集中式日志服务器，很可能多个实例会一起工作。

有些实例将生成日志消息，它们将被称为“**设备**”或“**syslog客户端**”。

有些只是转发收到的消息，它们将被称为“**中继**”。

最后，在某些情况下，您将接收和存储日志数据，这些被称为“**收集器**”或““syslog服务器”。

![Syslog architecture components](https://devconnected.com/wp-content/uploads/2019/08/syslog-component-arch.png)

了解这些概念后，我们可以说独立的Linux机器本身就充当了“**syslog客户端-服务器**”:它**生成**日志数据，由rsyslog **收集**并存储到文件系统中。

这里有一组围绕这一原则的架构示例。

在第一种设计中，您有一个设备和一个收集器。这是最简单的日志架构形式。

![One device and one collector](https://devconnected.com/wp-content/uploads/2019/08/arch-1.png)

Add a few **more clients** in your infrastructure, and you have the basis of a **centralized logging architecture.** 在您的基础架构中添加一些**更多的客户端* *，您就拥有了**集中式日志记录架构**的基础。

![Multiple devices and one collector](https://devconnected.com/wp-content/uploads/2019/08/arch-2.png)

多个客户端正在生成数据，并将其发送到负责聚合和存储客户端数据的集中式syslog服务器。

如果我们要使我们的架构复杂化，我们可以添加一个“**中继**”。

例如，中继可以是**Logstash**实例，但在客户端也可以是**rsyslog规则**。

![Multiple devices, one collector and one relay](https://devconnected.com/wp-content/uploads/2019/08/arch-3-1.png)

这些中继大多充当“基于内容的路由器”([，如果你不熟悉基于内容的路由器，这里有一个链接可以理解它(https://www.enterpriseintegrationpatterns.com/patterns/messaging/ContentBasedRouter.html))。

这意味着基于日志内容，数据将被重定向到不同的位置。如果您对数据不感兴趣，也可以将其完全丢弃。

现在我们已经有了详细的Syslog组件，让我们看看Syslog消息是什么样子的。

## III – 什么是Syslog消息格式？

Syslog格式分为三个部分:

* **PRI part**: 详细说明消息优先级(从调试消息到紧急事件)以及设施级别(邮件、授权、内核)；
* **HEADER part:** 由时间戳和主机名两个字段组成，主机名是发送日志的计算机名；
* **MSG part:** 该部分包含发生事件的实际信息。它也分为TAG和CONTENT字段。

![Syslog format explained](https://devconnected.com/wp-content/uploads/2019/08/syslog-format.png)

在详细描述syslog格式的不同部分之前，让我们快速了解syslog的严重性级别以及系统日志设施级别。

### a – 什么是Syslog设施级别？

简单来说，**设备级别** 用于确定生成日志的程序或系统的一部分。

默认情况下，系统的某些部分会被赋予功能级别，例如使用 **kern功能的内核**，或者* *使用邮件功能的邮件系统。**

如果第三方想要记录日志，它可能会保留一组从16到23的设施级别，称为**“本地使用”设施级别。**

或者，他们可以使用“**用户级别**”工具，这意味着他们将发布与发出命令的用户相关的日志。

简而言之，如果我的Apache服务器由“apache”用户运行，那么日志将存储在一个名为“apache.log”的文件中(<user>.log)

**下表描述了Syslog设施级别:**

| **Numerical Code** | **Keyword**      | **Facility name**       |
| ------------------ | ---------------- | ----------------------- |
| 0                  | kern	            | Kernel messages         |
| 1                  | user	            | User-level messages     |
| 2                  | mail	            | Mail system             |
| 3                  | daemon           | System Daemons          |
| 4                  | auth	            | Security messages       |
| 5                  | syslog           | Syslogd messages        |
| 6                  | lpr	            | Line printer subsystem  |
| 7                  | news	            | Network news subsystem  |
| 8                  | uucp	            | UUCP subsystem          |
| 9                  | cron	            | Clock daemon            |
| 10                 | authpriv	        | Security messages       |
| 11                 | ftp	FTP         | daemon                  |
| 12                 | ntp	NTP         | subsystem               |
| 13                 | security	        | Security log audit      |
| 14                 | console	        | Console log alerts      |
| 15                 | solaris-cron     | Scheduling logs         |
| 16-23              | local0 to local7	| Locally used facilities |

这些级别你是不是很眼熟？

是的！在Linux系统中，默认情况下，文件由设施名称分隔，这意味着您将有一个用于身份验证的文件(auth.log)，一个用于内核的文件(kern.log)等等。

这是[我的Debian 10实例的截屏示例](https://devconnected.com/how-to-install-and-configure-debian-10-buster-with-gnome/).

![展示debian 10上的设施日志](https://devconnected.com/wp-content/uploads/2019/08/var-log-debian-10.png)

现在我们已经看到了syslog设施级别，让我们来描述什么是syslog严重性级别。

### b – 什么是Syslog严重性级别？

**Syslog严重级别** 用于记录事件的严重程度，范围从调试、信息消息到紧急级别。

与Syslog设施级别相似，严重性级别分为0到7的数字类别，0是**最关键的紧急级别**。

**下表中描述的是syslog严重性级别:**

| **Value** | **Severity**  | **Keyword** |
| --------- | ------------- | ------------|
| 0         | Emergency	    | `emerg`     |
| 1         | Alert	        | `alert`     |
| 2         | Critical	    | `crit`      |
| 3         | Error	        | `err`       |
| 4         | Warning	    | `warning`   |
| 5         | Notice	    | `notice`    |
| 6         | Informational	| `info`      |
| 7         | Debug	        | `debug`     |

即使默认情况下日志是按设施名称存储的，您完全也可以决定改为按严重性级别存储日志。

如果您使用rsyslog作为默认系统日志服务器，您可以检查**[rsyslog属性](https://www.rsyslog.com/doc/master/configuration/properties.html)** 配置日志的分隔方式。

现在您对设施和严重性有了更多的了解，让我们回到**syslog消息格式。**

### c – PRI部分是什么？

PRI块是syslog格式消息的第一部分。

PRI尖括号之间存储的“**优先级值**”。

> 还记得你刚刚学到的设施和严重程度吗？

如果您选取消息设施号，将其乘以8，并添加严重性级别，您将获得syslog消息的“优先级值”。

如果您希望将来**解码** 您的syslog消息，请记住这一点。

![](https://devconnected.com/wp-content/uploads/2019/08/pri-calc-fixed.png)

### d – HEADER部分是什么？

如前所述，HEADER部分由两个关键信息组成: **TIMESTAMP** 部分和 **HOSTNAME** 部分(有时可以解析为一个IP地址)

该HEADER部分直接连着PRI部分，正好在右尖括号之后。

值得注意的是**TIMESTAMP**部分的格式是“**Mmm dd hh:mm:ss**”格式，“Mmm”是一年中一个月的前三个字母。

![HEADER part examples](https://devconnected.com/wp-content/uploads/2019/08/HEADER-example.png)

谈到**HOSTNAME**，它通常是在您键入HOSTNAME命令时给出的。如果找不到，它将被分配主机的IPv4或IPv6。

![Hostname on Debian 10](https://devconnected.com/wp-content/uploads/2019/08/debian-10-hostname.png)

## IV – Syslog消息传递是如何工作的？

发布Syslog消息时，您需要确保使用可靠和安全的方式来传递日志数据。 

Syslog当然是关于这个主题的观点，下面是这些问题的一些答案。

### a – 什么是syslog转发？

**Syslog转发包括将客户端日志发送到远程服务器，以便对其进行集中，从而使日志分析和可视化更加容易。** 

大多数情况下，系统管理员不是监控一台机器，而是必须监控几十台机器，现场和非现场。

因此，使用不同的通信协议(如UDP或TCP)将日志发送到称为集中式日志服务器的远程机器是一种非常常见的做法。

### b – Syslog使用TCP还是UDP？

根据[RFC 3164规范](https://tools.ietf.org/html/rfc3164#section-6.4)的规定，syslog客户端使用UDP向系统日志服务器发送消息。 

此外，Syslog使用端口514进行UDP通信。

但是，在最近的系统日志实现中，例如rsyslog或syslog-ng，您可以使用TCP (Transmission Control Protocol) 作为安全的通信通道。

例如，rsyslog使用端口10514进行TCP通信，确保链路没有数据包丢失。

此外，您可以在TCP之上使用TLS/SSL协议来加密系统日志数据包，确保不会执行中间人攻击来监视您的日志。

如果您对rsyslog感兴趣，这里有一个关于[如何以安全可靠的方式设置一个完整的集中式日志服务器的教程。](http://devconnected . com/the-definitive-guide-to-centralized-logging-with-syslog-on-Linux/)

## V – 当前的Syslog实现是什么？

Syslog是一个规范，但不是Linux系统中的实际实现。

以下是Linux上当前Syslog实现的列表:

* **Syslog daemon**: 发布于1980年，syslog守护程序可能是第一个实现，并且只支持有限的一组功能(如UDP传输)。它通常被称为Linux上的sysklogd守护程序；

* **Syslog-ng**: syslog-ng于1998年发布，它扩展了原始syslog daemon的功能集，包括TCP转发(从而增强了可靠性)、TLS加密和基于内容的过滤器。您还可以将日志存储到本地数据库中以供进一步分析。

![Syslog-ng演示卡片](https://devconnected.com/wp-content/uploads/2019/08/syslog-ng.png)

* **Rsyslog**: rsyslog于2004年由Rainer Gerhards发布，是大多数实际Linux发行版(Ubuntu、RHEL、Debian等)上的默认syslog实现..)。它提供了与syslog-ng相同的转发功能，但是它允许开发人员从更多的来源(例如卡夫卡、文件或文档)中选择数据

![Rsyslog 演示卡片](https://devconnected.com/wp-content/uploads/2019/08/rsyslog-card.png)

## VI – 什么是日志最佳实践？

在操作系统日志或构建完整的日志架构时，您需要了解一些最佳实践:

* **除非您愿意丢失数据，否则请使用可靠的通信协议**. 在UDP(一种不可靠的协议)和TCP(一种可靠的协议)之间进行选择真的很重要。提前做出这个选择；
* **使用NTP协议配置您的主机:** 当您想要使用实时日志调试时，最好让主机同步，否则很难准确调试事件；
* **保护好你的日志:** 使用TLS/SSL协议肯定会对您的实例产生一些性能影响，但是如果您要转发身份验证或内核日志，最好对它们进行加密，以确保没有人能够访问关键信息；
* **你应该避免过度记录**: 定义好的日志策略对您的公司至关重要。例如，您必须决定您是否有兴趣存储(并且基本上消耗带宽)信息日志或调试日志。例如，您可能只对错误日志感兴趣；
* **定期备份日志数据:** i如果您关注保留敏感日志，或者如果您定期接受审计，您可能在有关的外部驱动器或正确配置的数据库上备份日志；
* **设置日志保留策略:** 如果日志太旧，您可能会有兴趣丢弃它们，也称为“循环”它们。该操作是通过Linux系统上的logrotate实用程序完成的。

## VII – 结论

Syslog协议绝对是 **系统管理员** 或 **Linux工程师** 愿意更深入了解日志记录在服务器上如何工作的的经典之作。

然而，有理论的时候，也有实践的时候。

> 那么你应该去哪里？你有多种选择。

您可以从在您的实例上设置 **syslog服务器** 开始，例如Kiwi Syslog服务器，并开始从中收集数据。

或者，如果您有更大的基础架构，您可能应该首先建立 **[集中式日志记录体系结构](https://devconnected.com/the-definitive-guide-to-centralized-logging-with-syslog-on-linux/)**, 然后[使用非常现代的工具如Kibana可视化工具对其进行监控](https://devconnected.com/monitoring-linux-logs-with-kibana-and-rsyslog/)。

我希望你今天学到了一些东西。

在那之前，一如既往地享受乐趣。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
