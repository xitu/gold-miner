> * 原文地址：[In UNIX Everything is a File](https://ph7spot.com/musings/in-unix-everything-is-a-file)
> * 原文作者：[ph7spot.com](https://ph7spot.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/in-unix-everything-is-a-file.md](https://github.com/xitu/gold-miner/blob/master/TODO1/in-unix-everything-is-a-file.md)
> * 译者：
> * 校对者：

# In UNIX Everything is a File

The UNIX operating system crystallizes a couple of unifying ideas and concepts that shaped its design, user interface, culture and evolution. One of the most important of these is probably the mantra: “everything is a file”, widely regarded as one of the defining points of UNIX.

This key design principle consists of providing a unified paradigm for accessing a wide range of input/output resources: documents, directories, hard-drives, CD-Roms, modems, keyboards, printers, monitors, terminals and even some inter-process and network communications. The trick is to provide a common abstraction for all of these resources, each of which the UNIX fathers called a “file”. Since every “file” is exposed through the same API1, you can use the same set of basic commands to read/write to a disk, keyboard, document or network device.

This fundamental concept is actually two-fold:

*   In UNIX everything is a stream of bytes
*   In UNIX the filesystem is used as a universal name space

## In UNIX Everything is a Stream of Bytes

So what really constitutes a file in UNIX? A file is not much more than a plain collection of bytes that you can read and/or write. Once you have a reference to a file, called a file descriptor2, I/O access in UNIX is done using the same set of operations, the same API – whatever the type of the device and the underlying hardware.

Historically, UNIX was the first operating system to abstract all I/O under such a unified concept and small set of primitives. At the time, most operating systems were providing a distinct API for each device or device family. Some early microcomputer operating systems even required you to use multiple user commands to copy files – each one dedicated to a specific floppy disk size!

From the programmer and the user perspectives, UNIX exposes:

*   Documents stored on a hard-drive
*   Directories
*   Links
*   Mass storage devices (e.g. hard-drive, CD-ROM, Tape, USB Key)
*   Inter-process communication (e.g. Pipes, Shared Memory, UNIX Sockets)

*   Network connections
*   Interactive terminals
*   Almost all other devices (e,g, Printers, Graphic Card)

as a stream of bytes that you can:

*   `read`
*   `write`
*   `lseek`
*   `close`

The unified API feature is extremely empowering and fundamental for UNIX programs: you can write a program processing a file while being blissfully unaware of whether the file is actually stored on a local disk, stored on a remote drive somewhere on the network, streamed over the Internet, typed interactively by the user or even generated in memory by another program. This dramatically reduces the program complexity and eases the developer’s learning curve. Besides, this fundamental feature of the UNIX architecture also makes composing programs together a snap (you just pipe two special files: standard input and standard output).

Finally, please note that while all files present a consistent API, some operations might not be supported by a specific type of device. For instance, and for obvious reasons, you cannot `lseek` on a mouse device, or `write` on a CD-ROM device (assuming your CD is read-only).

## The Filesystem as a Universal Name Space

In UNIX, files are not only a stream of bytes with a consistent API, they can also be referenced in a uniform manner: the filesystem is used as a universal namespace.

### Global Namespace and the Mounting Mechanism

UNIX filesystem paths provide a consistent and global scheme to label resources, regardless of their nature. For instance you can reference a local directory with `/usr/local`, a file with `/home/joe/memo.pdf`, a CD-ROM with `/mnt/cdrom`, a directory on a network drive with `/usr`, a hard disk partition with `/dev/sda1`, a UNIX domain socket with `/tmp/mysql.sock`, a terminal with `/dev/tty0` or even a mouse with `/dev/mouse`. This global namespace is often viewed as a hierarchy of files and directories. However, as the previous examples illustrate, this is just a convenient abstraction, and a file path can reference just about anything: a filesystem, an device, a network share or a communication channel.

The namespace is hierarchical and all resources can be referenced from the root directory (`/`). You can access multiple filesystems within the same namespace: you just “attach” a device or a filesystem (let’s say an external hard-drive) at a specific location in the namespace (say `/backups`). In UNIX jargon, this action is called _mounting_ a filesystem, and the namespace location where you attach the filesystem is called a _mount point_. You can reference all the resources of a mounted filesystem as a part of the global namespace by prefixing them with the mount point (say the file `/backups/myproject-Oct07.zip`)

The mounting mechanism I just described is crucial in establishing a unified and coherent namespace where heterogenous resources can be transparently overlaid. Contrast this with the filesystem namespace found in Microsoft operating systems – MS-DOS and Windows treat devices as files, but do _not_ use the file system as a universal name space. The Namespace is partitioned and each physical storage location is treated as a distinct entity3: `C:\` is the first hard drive, `E:\` the CD-ROM device, etc.

### Pseudo Filesystems

Early on, UNIX dramatically increased the integration of Input/Output resources by providing a global API and putting devices into a unified filesystem name space. This approach was so successful that ever since there has been a trend of exposing more and more resources and system services as part of the filesystem global namespace. This effort was pioneered by Plan 9 and is now present in all modern UNIX systems.

This approach lead to the creation of numerous _pseudo_ filesystems that behave like normal file systems but can be used to access resources that are not directly related to a traditional filesystem. For instance you can use a pseudo filesystem to query and control processes, access kernel internals or establish TCP connections. These pseudo filesystems provide filesystem semantics as a convenient way to represent hierarchical information and to offer uniform access to a wide variety of objects. Pseudo filesystems, sometimes also referred to as virtual filesystems, typically have no physical presence and backing storage at all, they are memory based.

Example of pseudo filesystems are:

*   **procfs** (`/proc`): The proc filesystem contains a hierarchy of special files which can be used to query or control running processes or peek into the kernel internals through standard file entries (mostly text based).
*   **devfs** (`/dev` or `/devices`): Devfs presents all devices on the system as a dynamic filesystem namespace. Devfs also manages this namespace and interfaces directly with kernel device drivers to provide intelligent device management – including device entry registration/unregistration.
*   **tmpfs** (`/tmp`): Temporary filesystem whose content disappear on reboot. Tmpfs is designed for speed and efficiency with features such as dynamic filesystem size as well as memory storage with transparent fallback to swap space.
*   **portalfs** (`/p`): With the BSD portal filesystem you can attach a server process to the filesystem global namespace. This can be used to provide transparent access to network services through the filesystem. For instance an application could interact with the SMTP server hosted by `ph7spot.com` just by opening a regular file:`/p/tcp/ph7spot.com/smtp`. The Portal filesystem is somewhat magical in that it provides socket semantic in the filesystem which can be piped and leveraged by standard UNIX tools (e.g. `cat`, `grep`, `awk`, etc.) – even from the shell!
*   **ctfs** (`/system/contract`): The contract filesystem acts as a file based interface to Solaris contract subsystem. A Solaris contract defines the behavior of a process or process group for various types of event and failures – e.g. restart it if it dies. Solaris contracts provide very advanced capabilities for software management and monitoring in environments such as clustering fail-over software, batch queuing systems, and grid computing engines.

The previous examples should give you an idea of the wide range of system resources that can be managed through filesystem semantics.

## Conclusion

In modern UNIX operating systems all devices and most type of communications between processes are managed and visible as files or pseudo-files within the filesystem hierarchy. This fundamental UNIX vision and design principle, known as “Everything is a File”, is one of the key factors for UNIX success and longevity. It provided a powerful yet simple abstraction that the system, the tools and the community could build on. More importantly it provided strong integration and a fundamental composition mechanism for connecting tools and applications in an ad-hoc manner to solve the problem at hand.

Despite the success of the “Everything is a File” metaphor, some people are somewhat skeptical on its universality. When every file is considered to be a stream of bytes, one consequence is the lack of standard support for meta-data: To process a file appropriately, each application must come up with its own way of figuring the file type, structure and sematics. Besides, for the meta-data to be preserved, _every_ tool that processes the stream must keep the meta-data unaltered (e.g. XMP information for a photograph). Therefore, while the fact that a UNIX file is just a big bag of bytes is extremely powerful for connecting programs based on a text interface, it seriously limits application composition when it comes to multimedia and binary formats.

In spite of its limitations, most people acknowledge the power in the metaphor and its effect on the integration of the operating system. Ever since UNIX was first released, researchers kept trying to further this central concept. For instance, the Plan 9 operating system pioneered a fully integrated approach to system resources: A cornerstone of Plan 9 vision was the objective to represent not only devices and communication channels but _all_ system interfaces through the filesystem. For instance, Plan 9 designers noted that in UNIX, network devices cannot _completely_ be considered as regular files: They are accessed through sockets which have distinct opening semantics and which reside in a different name space (host and port for internet sockets). Plan 9 implementation demonstrated that you could successfully unify all local and remote devices in a global namespace. This concept eventually came back to UNIX in the form of portalfs.

Other innovative concepts from Plan 9 built on the “In UNIX Everything is a File” principle. For instance, Plan 9 provides yet another layer of abstraction on top on the unified namespace design: The filesystem namespace can be customized for each user or each process and even adjusted dynamically4. Ultimately, Plan 9 demonstrated that “In UNIX Everything is a File” metaphor could be implemented on an even larger scale. In fact, this fundamental concept continues to expand within modern UNIX operating systems5.

## References

*   The fantastic book “The Art of UNIX Programming” by Eric S. Raymond.
*   “The Elements of Operating-System Style” and “Problems in the Design of UNIX” chapters are especially relevant to this document.
*   “10 Things I Hate About (U)NIX” by David Chisnall.
*   Mouting Definition by the The Linux Information Project
*   “UNIX File Types” on Wikipedia
*   “Understanding UNIX Concepts” by USAIL (UNIX System Administration Independent Learning)
*   The Filesystem Hierachy Standard
*   The proc Filesystem by Redhat
*   A Modular User Mode File System for BSD
*   “Self-Healing in Modern Operating Systems” by Michael W. Shapiro for a better understanding of Solaris contracts.

* * *

1.  For more background on the UNIX operating system read this wikipedia entry
2.  A file descriptor is simply an abstract key for accessing a file. A file descriptor is usually an integer and is associated with an open file.
3.  For more details see this wikipedia entry
4.  This concept also eventually made its way back to UNIX in the for ofunionfs
5.  For example of current activity in this arena, check out unionfs, portalfs andobjfs for instance.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
