> * 原文地址：[Syslog : The Complete System Administrator Guide](https://devconnected.com/syslog-the-complete-system-administrator-guide/)
> * 原文作者：[Schkn](https://devconnected.com/author/schkn/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/syslog-the-complete-system-administrator-guide.md](https://github.com/xitu/gold-miner/blob/master/TODO1/syslog-the-complete-system-administrator-guide.md)
> * 译者：
> * 校对者：

# Syslog : The Complete System Administrator Guide

[![Syslog : The Complete System Administrator Guide](https://devconnected.com/wp-content/themes/soledad/images/penci2-holder.png "syslog featured")](https://devconnected.com/wp-content/uploads/2019/08/syslog-featured-1.png) 

If you are a **system administrator**, or just a regular Linux user, there is a very high chance that you worked with **Syslog**, at least one time.

On your Linux system, pretty much everything related to system logging is linked to the **Syslog protocol**.

Designed in the early 80’s by Eric Allman (from Berkeley University), the syslog protocol is a specification that defines a **standard for message logging on any system**.

Yes.. any system.

Syslog is not tied to Linux operating systems, it can also be used on Windows instances, or ony operating system that implements the syslog protocol.

If you want to know more about syslog and about Linux logging in general, this is probably the tutorial that you should read.

**Here is everything that you need to know about Syslog.**

## I – What is the purpose of Syslog?

![Syslog presentation card](https://devconnected.com/wp-content/uploads/2019/08/syslog-card.png)

**Syslog is used as a standard to produce, forward and collect logs produced on a Linux instance. Syslog defines severity levels as well as facility levels helping users having a greater understanding of logs produced on their computers. Logs can later on be analyzed and visualized on servers referred as Syslog servers.**

Here are a few more reasons why the syslog protocol was designed in the first place:

* **Defining an architecture**: this will be explained in details later on, but if syslog is a protocol, it will probably be part of a complete network architecture, with multiple clients and servers. As a consequence, we need to define roles, in short : are you going to receive, produce or relay data?
* **Message format**: syslog defines the way messages are formatted. This obviously needs to be standardized as logs are often parsed and stored into different storage engines. As a consequence, we need to define what a syslog client would be able to produce, and what a syslog server would be able to receive;
* **Specifying reliability**: syslog needs to define how it handles messages that can not be delivered. As part of the TCP/IP stack, syslog will obviously be opiniated on the underlying network protocol (TCP or UDP) to choose from;
* **Dealing with authentication or message authenticity:** syslog needs a reliable way to ensure that clients and servers are talking in a secure way and that messages received are not altered.

Now that we know why Syslog is specified in the first place, **let’s see how a Syslog architecture works.**

## II – What is Syslog architecture?

When designing a logging architecture, like a centralized logging server, it is very likely that multiple instances will work together.

Some will generate log messages, and they will be called “**devices**” or “**syslog clients**“.

Some will simply forward the messages received, they will be called “**relays**“.

Finally, there is some instances where you are going to receive and store log data, those are called “**collectors**” or “syslog servers”.

![Syslog architecture components](https://devconnected.com/wp-content/uploads/2019/08/syslog-component-arch.png)

Knowing those concepts, we can already state that a standalone Linux machine acts as a “**syslog client-server**” on its own : it **produces** log data, it is **collected** by rsyslog and stored right into the filesystem.

Here’s a set of architecture examples around this principle.

In the first design, you have one device and one collector. This is the most simple form of logging architecture out there.

![One device and one collector](https://devconnected.com/wp-content/uploads/2019/08/arch-1.png)

Add a few **more clients** in your infrastructure, and you have the basis of a **centralized logging architecture.**

![Multiple devices and one collector](https://devconnected.com/wp-content/uploads/2019/08/arch-2.png)

Multiple clients are producing data and are sending it to a centralized syslog server, responsible for aggregating and storing client data.

If we were to complexify our architecture, we can add a “**relay**“.

Examples of relays could be **Logstash** instances for example, but they also could be **rsyslog rules** on the client side.

![Multiple devices, one collector and one relay](https://devconnected.com/wp-content/uploads/2019/08/arch-3-1.png)

Those relays act most of the time as “content-based routers” ([if you are not familiar with content-based routers, here is a link to understand it](https://www.enterpriseintegrationpatterns.com/patterns/messaging/ContentBasedRouter.html)).

It means that based on the log content, data will be redirected to different places. Data can also be completely discarded if you are not interested in it.

Now that we have detailed Syslog components, let’s see what a Syslog message looks like.

## III – What is Syslog message format?

The syslog format is divided into three parts:

* **PRI part**: that details the message priority levels (from a debug message to an emergency) as well as the facility levels (mail, auth, kernel);
* **HEADER part:** composed of two fields which are the TIMESTAMP and the HOSTNAME, the hostname being the machine name that sends the log;
* **MSG part:** this part contains the actual information about the event that happened. It is also divided into a TAG and a CONTENT field.

![Syslog format explained](https://devconnected.com/wp-content/uploads/2019/08/syslog-format.png)

Before detailing the different parts of the syslog format, let’s have a quick look at syslog severity levels as well as syslog facility levels.

### a – What are Syslog facility levels?

In short, **a facility level** is used to determine the program or part of the system that produced the logs.

By default, some parts of your system are given facility levels such as the kernel using the **kern facility**, or your **mailing system using the mail facility.**

If a third-party wants to issue a log, it would probably a reserved set of facility levels from 16 to 23 called “**local use” facility levels.**

Alternatively, they can use the “**user-level**” facility, meaning that they would issue logs related to the user that issued the commands.

In short, if my Apache server is run by the “apache” user, then the logs would be stored under a file called “apache.log” (<user>.log)

**Here are the Syslog facility levels described in a table:**

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

Do those levels sound familiar to you?

Yes! On a Linux system, by default, files are separated by facility name, meaning that you would have a file for auth (auth.log), a file for the kernel (kern.log) and so on.

Here’s a screenshot example of [my Debian 10 instance](https://devconnected.com/how-to-install-and-configure-debian-10-buster-with-gnome/).

![Showing facility logs on debian 10](https://devconnected.com/wp-content/uploads/2019/08/var-log-debian-10.png)

Now that we have seen syslog facility levels, let’s describe what syslog severity levels are.

### b – What are Syslog severity levels?

**Syslog severity levels** are used to how severe a log event is and they range from debug, informational messages to emergency levels.

Similarly to Syslog facility levels, severity levels are divided into numerical categories ranging from 0 to 7, 0 being the **most critical emergency level**.

**Here are the syslog severity levels described in a table:**

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

Even if logs are stored by facility name by default, you could totally decide to have them stored by severity levels instead.

If you are using rsyslog as a default syslog server, you can check **[rsyslog properties](https://www.rsyslog.com/doc/master/configuration/properties.html)** to configure how logs are separated.

Now that you know a bit more about facilities and severities, let’s go back to our **syslog message format.**

### c – What is the PRI part?

The PRI chunk is the first part that you will get to read on a syslog formatted message.

The PRI stores the “**Priority Value**” between angle brackets.

> Remember the facilities and severities you just learned?

If you take the message facility number, multiply it by eight, and add the severity level, you get the “Priority Value” of your syslog message.

Remember this if you want to **decode** your syslog message in the future.

![](https://devconnected.com/wp-content/uploads/2019/08/pri-calc-fixed.png)

### d – What is the HEADER part?

As stated before, the HEADER part is made of two crucial information : the **TIMESTAMP** part and the **HOSTNAME** part (that can sometimes be resolved to an IP address)

This HEADER part directly follows the PRI part, right after the right angle bracket.

It is noteworthy to say that the **TIMESTAMP** part is formatted on the “**Mmm dd hh:mm:ss**” format, “Mmm” being the first three letters of a month of the year.

![HEADER part examples](https://devconnected.com/wp-content/uploads/2019/08/HEADER-example.png)

When it comes to the **HOSTNAME**, it is often the one given when you type the hostname command. If not found, it will be assigned either the IPv4 or the IPv6 of the host.

![Hostname on Debian 10](https://devconnected.com/wp-content/uploads/2019/08/debian-10-hostname.png)

## IV – How does Syslog message delivery work?

When issuing a syslog message, you want to make sure that you use reliable and secure ways to deliver log data.

Syslog is of course opiniated on the subject, and here are a few answers to those questions.

### a – What is syslog forwarding?

**Syslog forwarding consists in sending clients logs to a remote server in order for them to be centralized, making log analysis and visualization easier.**

Most of the time, system administrators are not monitoring one single machine, but they have to monitor dozens of machine, on-site and off-site.

As a consequence, it is a very common practice to send logs to a distant machine, called a centralized logging server, using different communication protocols such as UDP or TCP.

### b – Is Syslog using TCP or UDP?

As specified on [the RFC 3164 specification](https://tools.ietf.org/html/rfc3164#section-6.4), syslog clients use UDP to deliver messages to syslog servers.

Moreover, Syslog uses the port 514 for UDP communication.

However, on recent syslog implementations such as rsyslog or syslog-ng, you have the possibility to use TCP (Transmission Control Protocol) as a secure communication channel.

For example, rsyslog uses the port 10514 for TCP communication, ensuring that no packets are lost along the way.

Furthermore, you can use the TLS/SSL protocol on top of TCP to encrypt your Syslog packets, making sure that no man-in-the-middle attacks can be performed to spy on your logs.

If you are curious about rsyslog, here’s a tutorial on [how to setup a complete centralized logging server in a secure and reliable way.](https://devconnected.com/the-definitive-guide-to-centralized-logging-with-syslog-on-linux/)

## V – What are current Syslog implementations?

Syslog is a specification, but not the actual implementation in Linux systems.

Here is a list of current Syslog implementations on Linux:

* **Syslog daemon**: published in 1980, the syslog daemon is probably the first implementation ever done and only supports a limited set of features (such as UDP transmission). It is most commonly known as the sysklogd daemon on Linux;

* **Syslog-ng**: published in 1998, syslog-ng extends the set of capabilities of the original syslog daemon including TCP forwarding (thus enhancing reliability), TLS encryption and content-based filters. You can also store logs to local databases for further analysis.

![Syslog-ng presentation card](https://devconnected.com/wp-content/uploads/2019/08/syslog-ng.png)

* **Rsyslog**: released in 2004 by Rainer Gerhards, rsyslog comes as a default syslog implementation on most of the actual Linux distributions (Ubuntu, RHEL, Debian etc..). It provides the same set of features as syslog-ng for forwarding but it allows developers to pick data from more sources (Kafka, a file, or Docker for example)

![Rsyslog presentation card](https://devconnected.com/wp-content/uploads/2019/08/rsyslog-card.png)

## VI – What are the log best practices?

When manipulating Syslog or when building a complete logging architecture, there are a few best practices that you need to know:

* **Use reliable communication protocols unless you are willing to lose data**. Choosing between UDP (a non-reliable protocol) and TCP (a reliable protocol) really matters. Make this choice ahead of time;
* **Configure your hosts using the NTP protocol:** when you want to work with real time log debugging, it is best for you to have hosts that are synchronized, otherwise you would have a hard time debugging events with a good precision;
* **Secure your logs:** using the TLS/SSL protocol surely has some performance impacts on your instance, but if you are to forward authentication or kernel logs, it is best to encrypt them to make sure that no one is having access to critical information;
* **You should avoid over-logging**: defining a good log policy is crucial for your company. You have to decide if you are interested in storing (and essentially consuming bandwidth) for informational or debug logs for example. You may be interested in having only error logs for example;
* **Backup log data regularly:** if you are interested in keeping sensitive logs, or if you are audited on a regular basis, you may be interested in backing up your log on an external drive or on a properly configured database;
* **Set up log retention policies:** if logs are too old, you may be interested in dropping them, also known as “rotating” them. This operation is done via the logrotate utility on Linux systems.

## VII – Conclusion

The Syslog protocol is definitely a classic for **system administrators** or **Linux engineers** willing to have a deeper understanding on how logging works on a server.

However, there is a time for theory, and there is a time for practice.

> So where should you go from there? You have multiple options.

You can start by setting up a **syslog server** on your instance, like a Kiwi Syslog server for example, and starting gathering data from it.

Or, if you have a bigger infrastructure, you should probably start by setting up a **[centralized logging architecture](https://devconnected.com/the-definitive-guide-to-centralized-logging-with-syslog-on-linux/)**, and later on [monitor it using very modern tools such as Kibana for visualization](https://devconnected.com/monitoring-linux-logs-with-kibana-and-rsyslog/).

I hope that you learned something today.

Until then, have fun, as always.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
