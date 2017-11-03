# MacOS 的安全和隐私指南

> * 原文地址：[macOS Security and Privacy Guide](https://github.com/drduh/macOS-Security-and-Privacy-Guide)
* 原文作者：[drduh](https://github.com/drduh)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Nicolas(Yifei) Li](https://github.com/yifili09), [MAYDAY1993](https://github.com/MAYDAY1993), [DeadLion](https://github.com/DeadLion)
* 校对者：[lovelyCiTY](https://github.com/lovelyCiTY), [sqrthree](https://github.com/sqrthree)

这里汇集了一些想法，它们是有关如何保护保护运行了 macOS 10.12 "Sierra" 操作系统（以前是 **OS X**）的现代化苹果 Mac 电脑，也包含了一些提高个人网络隐私的小贴士。

这份指南的目标读者是那些希望采用企业级安全标准的"高级用户"，但是也适用于那些想在 Mac 上提高个人隐私和安全性的初级用户们。

一个系统的安全与否完全取决于管理员的能力。没有一个单独的技术、软件，或者任何一个科技能保证计算机完全安全；现代的计算机和操作系统都是非常复杂的，并且需要大量的增量修改才能获得在安全性和隐私性上真正意义的提高。

**免责声明**：若按照以下操作后对您的 Mac 电脑造成损伤，**望您自行负责**。

如果你发现了本文中的错误或者有待改进的内容，请提交 `pull request` 或者 [创建一个 `issue`](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues).

- [基础知识](#基础知识)
- [固件](#固件)
- [准备和安装 macOS](#准备和安装-macos)
    - [虚拟机](#虚拟机)
- [首次启动](#首次启动)
- [管理员和普通用户账号](#管理员和普通用户账号)
- [对整个磁盘进行数据加密](#对整个磁盘进行数据加密)
- [防火墙](#防火墙)
    - [应用程序层的防火墙](#应用程序层的防火墙)
    - [第三方防火墙](#第三方防火墙)
    - [内核级的数据包过滤](#内核级的数据包过滤)
- [系统服务](#系统服务)
- [Spotlight 建议](#spotlight-建议)
- [Homebrew](#homebrew)
- [DNS](#dns)
    - [Hosts 文件](#hosts-文件)
    - [Dnsmasq](#dnsmasq)
      - [检测 DNSSEC 验证](#检测-dnssec-验证)
    - [DNSCrypt](#dnscrypt)
- [Captive portal](#captive-portal)
- [证书授权](#证书授权)
- [OpenSSL](#openssl)
- [Curl](#curl)
- [Web](#web)
    - [代理](#代理)
    - [浏览器](#浏览器)
    - [插件](#插件)
- [PGP/GPG](#pgpgpg)
- [OTR](#otr)
- [Tor](#tor)
- [VPN](#vpn)
- [病毒和恶意软件](#病毒和恶意软件)
- [系统完整性保护](#系统完整性保护)
- [Gatekeeper 和 XProtect](#gatekeeper-和-xprotect)
- [密码](#密码)
- [备份](#备份)
- [Wi-Fi](#wi-fi)
- [SSH](#ssh)
- [物理访问](#物理访问)
- [系统监控](#系统监控)
    - [OpenBSM 监测](#openbsm-监测)
    - [DTrace](#dtrace)
    - [运行](#运行)
    - [网络](#网络)
- [二进制白名单](#二进制白名单)
- [其它](#其它)
- [相关软件](#相关软件)
- [其它资源](#其它资源)

## 基础知识

安全标准的最佳实践适用于以下几点:

* 创建一个威胁模型
    *  考虑下什么是你需要保护的，避免谁的侵害？你的对手会是一个 [TLA](https://theintercept.com/document/2015/03/10/strawhorse-attacking-macos-ios-software-development-kit/) 机构么？（如果是的，你需要考虑替换使用 [OpenBSD](http://www.openbsd.org)），或者是一个在网络上好管闲事的偷听者，还是一起针对你精心策划的 [apt](https://en.wikipedia.org/wiki/Advanced_persistent_threat) 网络攻击？
    * 研究并识别出[那些威胁](https://www.usenix.org/system/files/1401_08-12_mickens.pdf)，想一想如何减少被攻击的面。

* 保持系统更新
    * 请为你的系统和软件持续更新补丁！更新补丁！更新补丁！（重要的事情说三遍）。
    * 可以使用 `App Store` 应用程序来完成对 `macOS` 系统的更新，或者使用命令行工具 `softwareupdate`，这两个都不需要注册苹果账号。
    * 请为那些你经常使用的程序，订阅公告邮件列表（例如，[Apple 安全公告](https://lists.apple.com/mailman/listinfo/security-announce)）。

* 对敏感数据进行加密
    * 除了对整个磁盘加密之外，创建一个或者多个加密的容器，用它们来保存一些你的密码、秘钥、那些个人文件和余下的其他数据。
    * 这有助于减少数据泄露造成的危害。

* 经常备份数据
    * 定期创建[数据备份](https://www.amazon.com/o/ASIN/0596102461/backupcentral)，并且做好遇到危机时候的数据恢复工作。
    * 在拷贝数据备份到外部存储介质或者 “云” 系统中之前，始终对它们进行加密。
    * 定期对备份进行测试，验证它们是可以工作的。例如，访问某一部分文件或者对比哈希校验值。

* 注意钓鱼网站
    * 最后，具有高安全意识的管理员能大大降低系统的安全风险。
    * 在安装新软件的时候，请加倍小心。始终选择[免费的软件](https://www.gnu.org/philosophy/free-sw.en.html)和开源的软件（[当然了，macOS 不是开源的](https://superuser.com/questions/19492/is-mac-os-x-open-source))

## 固件

为固件设定一个密码，它能阻止除了你的启动盘之外的任何其它设备启动你的 Mac 电脑。它也能设定成每次启动时为必选项。

[当你的计算机被盗的时候，这个功能是非常有用的](https://www.ftc.gov/news-events/blogs/techftc/2015/08/virtues-strong-enduser-device-controls)，因为唯一能重置固件密码的方式是通过 `Apple Store`，或者使用一个 [SPI 程序](https://reverse.put.as/2016/06/25/apple-efi-firmware-passwords-and-the-scbo-myth/)，例如 [Bus Pirate](http://ho.ax/posts/2012/06/unbricking-a-macbook/) 或者其它刷新电路的程序。

1. 开始时，按下 `Command` 和 `R` 键来启动[恢复模式 / Recovery Mode](https://support.apple.com/en-au/HT201314)。

2. 当出现了恢复模式的界面，从 `Utilities / 工具` 菜单中选择 **Firmware Password Utility / 固件密码实用工具**。

3. 在固件工具窗口中，选择 **Turn On Firmware Password / 打开固件密码**。

4. 输入一个新的密码，之后在 **Verify / 验证** 处再次输入一样的密码。

5. 选择 **Set Password / 设定密码**。

6. 选择 **Quit Firmware Utility / 退出固件工具** 关闭固件密码实用工具。

7. 选择 Apple 菜单，并且选择重新启动或者关闭计算机。

这个固件密码会在下一次启动后激活。为了验证这个密码，在启动过程中按住 `Alt` 键 - 按照提示输入密码。

当启动进操作系统以后。固件密码也能通过 `firmwarepasswd` 工具管理。

<img width="750" alt="Using a Dediprog SF600 to dump and flash a 2013 MacBook SPI Flash chip to remove a firmware password, sans Apple" src="https://cloud.githubusercontent.com/assets/12475110/17075918/0f851c0c-50e7-11e6-904d-0b56cf0080c1.png">

**在没有 Apple 技术支持下，使用 [Dediprog SF600](http://www.dediprog.com/pd/spi-flash-solution/sf600) 来输出并且烧录一个 2013 款的 MacBook SPI 闪存芯片，或者移除一个固件密码**

可参考 [HT204455](https://support.apple.com/en-au/HT204455), [LongSoft/UEFITool](https://github.com/LongSoft/UEFITool) 或者 [chipsec/chipsec](https://github.com/chipsec/chipsec) 了解更多信息。

## 准备和安装 macOS

有很多种方式来安装一个全新的 macOS 副本。

最简单的方式是在启动过程中按住 `Command` 和 `R` 键进入 [Recovery Mode / 恢复模式](https://support.apple.com/en-us/HT201314)。系统镜像文件能够直接从 `Apple` 官网上下载并且使用。然而，这样的方式会以明文形式直接在网络上暴露出你的机器识别码和其它的识别信息。

<img width="500" alt="PII is transmitted to Apple in plaintext when using macOS Recovery" src="https://cloud.githubusercontent.com/assets/12475110/20312189/8987c958-ab20-11e6-90fa-7fd7c8c1169e.png">

**在 macOS 恢复过程中，捕获到未加密的 HTTP 会话包**

另一种方式是，从 [App Store](https://itunes.apple.com/us/app/macos-sierra/id1127487414) 或者其他地方下载 **macOS Sierra** 安装程序，之后创建一个自定义可安装的系统镜像。

这个 macOS Sierra 安装应用程序是经过[代码签名的](https://developer.apple.com/library/mac/documentation/Security/Conceptual/CodeSigningGuide/Procedures/Procedures.html#//apple_ref/doc/uid/TP40005929-CH4-SW6)，它可以使用 `code sign` 命令来验证并确保你接收到的是一个正版文件的拷贝。

```
$ codesign -dvv /Applications/Install\ macOS\ Sierra.app
Executable=/Applications/Install macOS Sierra.app/Contents/MacOS/InstallAssistant
Identifier=com.apple.InstallAssistant.Sierra
Format=app bundle with Mach-O thin (x86_64)
CodeDirectory v=20200 size=297 flags=0x200(kill) hashes=5+5 location=embedded
Signature size=4167
Authority=Apple Mac OS Application Signing
Authority=Apple Worldwide Developer Relations Certification Authority
Authority=Apple Root CA
Info.plist entries=30
TeamIdentifier=K36BKF7T3D
Sealed Resources version=2 rules=7 files=137
Internal requirements count=1 size=124
```

macOS 安装程序也可以由 `createinstallmedia` 工具制作，它在 `Install macOS Sierra.app/Contents/Resources/` 文件路径中。请参考[为 macOS 制作一个启动安装程序](https://support.apple.com/en-us/HT201372)，或者直接运行这个命令（不需要输入任何参数），看看它是如何工作的。

**注意** Apple 的安装程序[并不能跨版本工作](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/120)。如果你想要创造一个 10.12 的镜像，例如，以下指令也必须要在 10.12 的机器上运行!

为了创建一个 **macOS USB 启动安装程序**，需要挂载一个 USB 驱动器，清空它的内容、进行重新分区，之后使用 `createinstallmedia` 工具:

```
$ diskutil list
[Find disk matching correct size, usually "disk2"]

$ diskutil unmountDisk /dev/disk2

$ diskutil partitionDisk /dev/disk2 1 JHFS+ Installer 100%

$ cd /Applications/Install\ macOS\ Sierra.app

$ sudo ./Contents/Resources/createinstallmedia --volume /Volumes/Installer --applicationpath /Applications/Install\ macOS\ Sierra.app --nointeraction
Erasing Disk: 0%... 10%... 20%... 30%... 100%...
Copying installer files to disk...
Copy complete.
Making disk bootable...
Copying boot files...
Copy complete.
Done.
```

为了创建一个自定义、可安装的镜像，能用它恢复一台 Mac 电脑，你需要找到 `InstallESD.dmg`，这个文件也包含在 `Install macOS Sierra.app` 中。

通过 `Finder` 找到，并在这个应用程序图标上点击鼠标右键，选择 **Show Package Contents / 显示包内容**，之后从 **Contents / 内容** 进入到 **SharedSupport / 共享支持**，找到 `InstallESD.dmg` 文件。

你能通过 `openssl sha1 InstallESD.dmg` 、`shasum -a 1 InstallESD.dmg` 或者 `shasum -a 256 InstallESD.dmg` 得到的加密过的哈希值[验证](https://support.apple.com/en-us/HT201259)来确保你得到的是同一份正版拷贝（在 Finder 中，你能把文件直接拷贝到终端中，它能提供这个文件的完整路径地址）。

可以参考 [HT204319](https://support.apple.com/en-us/HT204319)，它能确定你最初采购来的计算机使用了哪个版本的 macOS，或者哪个版本适合你的计算机。

可以参考 [InstallESD_Hashes.csv](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/blob/master/InstallESD_Hashes.csv) 这个在我代码仓库中的文件，它是现在和之前该版本文件的哈希值。你也可以使用 Google 搜索这些加密的哈希值，确保这个文件是正版且没有被修改过的。

可以使用 [MagerValp/AutoDMG](https://github.com/MagerValp/AutoDMG) 来创建这个镜像文件，或者手动创建、挂载和安装这个操作系统到一个临时镜像中:

    $ hdiutil attach -mountpoint /tmp/install_esd ./InstallESD.dmg

    $ hdiutil create -size 32g -type SPARSE -fs HFS+J -volname "macOS" -uid 0 -gid 80 -mode 1775 /tmp/output.sparseimage

    $ hdiutil attach -mountpoint /tmp/os -owners on /tmp/output.sparseimage

    $ sudo installer -pkg /tmp/install_esd/Packages/OSInstall.mpkg -tgt /tmp/os -verbose

这一步需要花费一些时间，请耐心等待。你能使用 `tail -F /var/log/install.log` 命令在另一个终端的窗口内查看进度。

**（可选项）** 安装额外的软件，例如，[Wireshark](https://www.wireshark.org/download.html):

    $ hdiutil attach Wireshark\ 2.2.0\ Intel\ 64.dmg

    $ sudo installer -pkg /Volumes/Wireshark/Wireshark\ 2.2.0\ Intel\ 64.pkg -tgt /tmp/os

    $ hdiutil unmount /Volumes/Wireshark

遇到安装错误时，请参考 [MagerValp/AutoDMG/wiki/Packages-Suitable-for-Deployment](https://github.com/MagerValp/AutoDMG/wiki/Packages-Suitable-for-Deployment)，使用 [chilcote/outset](https://github.com/chilcote/outset) 来替代解决首次启动时候的包和脚本。

当你完成的时候，分离、转换并且验证这个镜像:

    $ hdiutil detach /tmp/os

    $ hdiutil detach /tmp/install_esd

    $ hdiutil convert -format UDZO /tmp/output.sparseimage -o ~/sierra.dmg

    $ asr imagescan --source ~/sierra.dmg

现在，`sierra.dmg` 已经可以被用在一个或者多个 Mac 电脑上了。它能继续自定义化这个镜像，比如包含预先定义的用户、应用程序、预置参数等。

这个镜像能使用另一个在 [Target Disk Mode / 目标磁盘模式](https://support.apple.com/en-us/HT201462) 下的 Mac 进行安装，或者从 USB 启动安装盘安装。

为了使用 **Target Disk Mode / 目标磁盘模式**，按住 `T` 键的同时启动 Mac 电脑，并且通过 `Firewire` 接口，`Thunderbolt` 接口或者 `USB-C` 线连接另外一台 Mac 电脑。

如果你没有其它 Mac 电脑，通过启动的时候，按住 **Option** 键用 USB 安装盘启动，把 `sierra.dmg` 和其它需要的文件拷贝到里面。

执行 `diskutil list` 来识别连接着的 Mac 磁盘，通常是 `/dev/disk2`

**（可选项）** 一次性[安全清除](https://www.backblaze.com/blog/securely-erase-mac-ssd/)磁盘（如果之前通过 FileVault 加密，该磁盘必须先要解锁，并且装载在 `/dev/disk3s2`）:

    $ sudo diskutil secureErase freespace 1 /dev/disk3s2

把磁盘分区改成 `Journaled HFS+` 格式:

    $ sudo diskutil unmountDisk /dev/disk2

    $ sudo diskutil partitionDisk /dev/disk2 1 JHFS+ macOS 100%

把该镜像还原到新的卷中:

    $ sudo asr restore --source ~/sierra.dmg --target /Volumes/macOS --erase --buffersize 4m

你也能使用 **Disk Utility / 磁盘工具** 应用程序来清除连接着的 Mac 磁盘，之后将 `sierra.dmg` 还原到新创建的分区中。

如果你正确按照这些步骤执行，该目标 Mac 电脑应该安装了新的 macOS Sierra 了。

如果你想传送一些文件，把它们拷贝到一个共享文件夹，例如在挂载磁盘的镜像中， `/Users/Shared`，例如，`cp Xcode_8.0.dmg /Volumes/macOS/Users/Shared`

<img width="1280" alt="Finished restore install from USB recovery boot" src="https://cloud.githubusercontent.com/assets/12475110/14804078/f27293c8-0b2d-11e6-8e1f-0fb0ac2f1a4d.png">

**完成从 USB 启动的还原安装**

这里还没有大功告成！除非你使用 [AutoDMG](https://github.com/MagerValp/AutoDMG) 创建了镜像，或者把 macOS 安装在你 Mac 上的其它分区内，你需要创建一块还原分区（为了使用对整个磁盘加密的功能）。你能使用 [MagerValp/Create-Recovery-Partition-Installer](https://github.com/MagerValp/Create-Recovery-Partition-Installer) 或者按照以下步骤:

请下载 [RecoveryHDUpdate.dmg](https://support.apple.com/downloads/DL1464/en_US/RecoveryHDUpdate.dmg) 这个文件。

```
RecoveryHDUpdate.dmg
SHA-256: f6a4f8ac25eaa6163aa33ac46d40f223f40e58ec0b6b9bf6ad96bdbfc771e12c
SHA-1:   1ac3b7059ae0fcb2877d22375121d4e6920ae5ba
```

添加并且扩展这个安装程序，之后执行以下命令:

```
$ hdiutil attach RecoveryHDUpdate.dmg

$ pkgutil --expand /Volumes/Mac\ OS\ X\ Lion\ Recovery\ HD\ Update/RecoveryHDUpdate.pkg /tmp/recovery

$ hdiutil attach /tmp/recovery/RecoveryHDUpdate.pkg/RecoveryHDMeta.dmg

$ /tmp/recovery/RecoveryHDUpdate.pkg/Scripts/Tools/dmtest ensureRecoveryPartition /Volumes/macOS/ /Volumes/Recovery\ HD\ Update/BaseSystem.dmg 0 0 /Volumes/Recovery\ HD\ Update/BaseSystem.chunklist
```

必要的时候把 `/Volumes/macOS` 替换成以目标磁盘启动的 Mac 的路径。

这个步骤需要花几分钟才能完成。再次执行 `diskutil list` 来确保 **Recovery HD** 已经存在 `/dev/disk2` 或者相似的路径下。

一旦你完成了这些，执行 `hdituil unmount /Volumes/macOS` 命令弹出磁盘，之后关闭以目标磁盘模式启动的 Mac 电脑。

### 虚拟机

在虚拟机内安装 macOS，可以使用 [VMware Fusion](https://www.vmware.com/products/fusion.html) 工具，按照上文中的说明来创建一个镜像。你**不需要**再下载，也不需要手动创建还原分区。

```
VMware-Fusion-8.5.2-4635224.dmg
SHA-256: f6c54b98c9788d1df94d470661eedff3e5d24ca4fb8962fac5eb5dc56de63b77
SHA-1:   37ec465673ab802a3f62388d119399cb94b05408
```

选择 **Install OS X from the recovery parition** 这个安装方法。可自定义配置任意的内存和 CPU，之后完成设置。默认情况下，这个虚拟机应该进入 [Recovery Mode / 还原模式](https://support.apple.com/en-us/HT201314)。

在还原模式中，选择一个语言，之后在菜单条中由 Utilities 打开 Terminal。

在虚拟机内，输入 `ifconfig | grep inet` — 你应该能看到一个私有地址，比如 `172.16.34.129`

在 Mac 宿主机内，输入 `ifconfig | grep inet` — 你应该能看到一个私有地址，比如 `172.16.34.1`

通过修改 Mac 宿主机内的文件让可安装镜像对虚拟器起作用，比如，修改 `/etc/apache2/htpd.conf` 并且在该文件最上部增加以下内容：(使用网关分配给 Mac 宿主机的地址和端口号 80):

    Listen 172.16.34.1:80

在 Mac 宿主机上，把镜像链接到 Apache 网络服务器目录:

    $ sudo ln ~/sierra.dmg /Library/WebServer/Documents

在 Mac 宿主机的前台运行 Apache:

    $ sudo httpd -X

在虚拟机上通过本地网络命令 `asr`，安装镜像文件到卷分区内:

```
-bash-3.2# asr restore --source http://172.16.34.1/sierra.dmg --target /Volumes/Macintosh\ HD/ --erase --buffersize 4m
    Validating target...done
    Validating source...done
    Erase contents of /dev/disk0s2 (/Volumes/Macintosh HD)? [ny]: y
    Retrieving scan information...done
    Validating sizes...done
    Restoring  ....10....20....30....40....50....60....70....80....90....100
    Verifying  ....10....20....30....40....50....60....70....80....90....100
    Remounting target volume...done
```

完成后，在 `sudo httpd -X` 窗口内通过 `Control` 和 `C` 组合键停止在宿主机 Mac 上运行的  Apache 网络服务器服务，并且通过命令 `sudo rm /Library/WebServer/Documents/sierra.dmg` 删除镜像备份文件。

在虚拟机内，在左上角 Apple 菜单中选择 **Startup Disk**，选择硬件驱动器并重启你的电脑。你可能想在初始化虚拟机启动的时候禁用网络适配器。

例如，在访问某些有风险的网站之前保存虚拟机的快照，并在之后用它还原该虚拟机。或者使用一个虚拟机来安装和使用有潜在问题的软件。

## 首次启动

**注意** 在设置 macOS 之前，请先断开网络连接并且配置一个防火墙。然而，装备有触摸条（`Touch Bar`）的 [2016 最新款 MacBook](https://www.ifixit.com/Device/MacBook_Pro_15%22_Late_2016_Touch_Bar)，它[需要在线激活系统](https://onemoreadmin.wordpress.com/2016/11/27/the-untouchables-apples-new-os-activation-for-touch-bar-macbook-pros/).

在首次启动时，按住 `Command` `Option` `P` `R` 键位组合，它用于[清除 NVRAM](https://support.apple.com/en-us/HT204063)。

当 macOS 首次启动时，你会看到 **Setup Assistant / 设置助手** 的欢迎画面。

请在创建你个人账户的时候，使用一个没有任何提示的[高安全性密码](http://www.explainxkcd.com/wiki/index.php/936:_Password_Strength)。

如果你在设置账户的过程中使用了真实的名字，你得意识到，你的[计算机的名字和局域网的主机名](https://support.apple.com/kb/PH18720)将会因为这个名字而泄露 (例如，**John Applesseed's MacBook**)，所以这个名字会显示在局域网络和一些配置文件中。这两个名字都能在 **System Preferences / 系统配置 > Sharing / 共享** 菜单中或者以下命令来改变:

    $ sudo scutil --set ComputerName your_computer_name

    $ sudo scutil --set LocalHostName your_hostname

## 管理员和普通用户账号

管理员账户始终是第一个账户。管理员账户是管理组中的成员并且有访问 `sudo` 的能力，允许它们修改其它账户，特别是 `root`，赋予它们对系统更高效的控制权。管理员执行的任何程序也有可能获得一样的权限，这就造成了一个安全风险。类似于 `sudo` 这样的工具[都有一些能被利用的弱点](https://bogner.sh/2014/03/another-mac-os-x-sudo-password-bypass/)，例如在默认管理员账户运行的情况下，并行打开的程序或者很多系统的设定都是[处于解锁的状态](http://csrc.nist.gov/publications/drafts/800-179/sp800_179_draft.pdf) [p. 61–62]。[Apple](https://help.apple.com/machelp/mac/10.12/index.html#/mh11389) 提供了一个最佳实践和[其它一些方案](http://csrc.nist.gov/publications/drafts/800-179/sp800_179_draft.pdf) [p. 41–42]，例如，为每天基本的工作建立一个单独的账号，使用管理员账号仅为了安装软件和配置系统。

每一次都通过 macOS 登录界面进入管理员帐号并不是必须的。系统会在需要认证许可的时候弹出提示框，之后交给终端就行了。为了达到这个目的，Apple 为隐藏管理员账户和它的根目录提供了一些[建议](https://support.apple.com/HT203998)。这对避免显示一个可见的 `影子` 账户来说是一个好办法。管理员账户也能[从 FileVault 里移除](http://apple.stackexchange.com/a/94373)。

#### 错误警告

1. 只有管理员账户才能把应用程序安装在 `/Applications` 路径下 （本地目录）。Finder 和安装程序将为普通用户弹出一个许可对话框。然而，许多应用程序都能安装在 `~/Applications` （该目录能被手动创建） 路径下。经验之谈： 那些不需要管理员权限的应用程序 — 或者在不在 `/Applications` 目录下都没关系的应用程序 — 都应该安装在用户目录内，其它的应安装在本地目录。Mac App Store 上的应用程序仍然会安装在 `/Applications` 并且不需要额外的管理员认证。

2. `sudo` 无法在普通用户的 shell 内使用，它需要使用 `su` 或者 `login` 在 shell 内输入一个管理员账户。这需要很多技巧和一些命令行界面操作的经验。

3. 系统配置和一些系统工具 （比如 Wi-Fi 诊断器） 为了所有的功能都能执行，它会需要 root 权限。在系统配置界面中的一些面板都是上锁的，所以需要单独的解锁按钮。一些应用程序在打开的时候会提示认证对话框，其它一些则需要通过一个管理员账号直接打开才能获得全部功能的权限。（例如 Console）

4. 有些第三方应用程序无法正确运行，因为它们假设当前的用户是管理员账户。这些程序只能在登录管理员账户的情况下才能被执行，或者使用 `open` 工具。

#### 设置

账户能在系统设置中创建和管理。在一个已经建立的系统中，通常很容易就能创建第二个管理员账号并且把之前的管理员帐号降级。这就避免了数据迁移的问题。新安装的系统都能增加普通账号。对一个账号降级能通过新建立的管理员帐号中的系统设置 — 当然那个管理员账号必须已经注销 — 或者执行这些命令（这两个指令可能没有必要都执行，可以参考[issue #179](https://github.com/drduh/macOS-Security-and-Privacy-Guide/issues/179)）:

```
$ sudo dscl . -delete /Groups/admin GroupMembership <username>

$ sudo dscl . -delete /Groups/admin GroupMembers <GeneratedUID>
```

通过以下指令，你就能发现你账号的 “GeneratedUID”:

```
$ dscl . -read /Users/<username> GeneratedUID
```

也可以参考[这篇文章](https://superuser.com/a/395738)，它能带给你有关更多 macOS 是如何确定组成员的内容。

## 对整个磁盘进行数据加密

[FileVault](https://en.wikipedia.org/wiki/FileVault) 提供了在 macOS 上对整个磁盘加密的能力（技术上来说，是**整个卷宗**。）

FileVault 加密将在休眠的时候保护数据，并且阻止其它人通过物理访问形式偷取数据或者使用你的 Mac 修改数据。

因为大部分的加密操作都[高效地运作在硬件上](https://software.intel.com/en-us/articles/intel-advanced-encryption-standard-aes-instructions-set/)，性能上的损失对 FireVault 来说并不凸显。

FileVault 的安全性依赖于伪随机数生成器 (PRNG)。

> 这个随机设备实现了 Yarrow 伪随机数生成器算法并且维护着它自己的熵池。额外的熵值通常由守护进程 SecurityServer 提供，它由内核测算得到的随机抖动决定。

> SecurityServer 也常常负责定期保存一些熵值到磁盘，并且在启动的时候重新加载它们，把这些熵值提供给早期的系统使用。

参考 `man 4 random` 获得更多信息。

在开启 FileVault 之前，PRNG 也能通过写入 /dev/random 文件手动提供熵的种子。也就是说，在激活 FileVault 之前，我们能用这种方式撑一段时间。

在启用 FileVault **之前**，手动配置种子熵:

    $ cat > /dev/random
    [Type random letters for a long while, then press Control-D]

通过 `sudo fdsetup enable` 启用 FileVault 或者通过 **System Preferences** > **Security & Privacy** 之后重启电脑。

如果你能记住你的密码，那就没有理由不保存一个**还原秘钥**。然而，如果你忘记了密码或者还原秘钥，那意味着你加密的数据将永久丢失了。

如果你想深入了解 FileVault 是如何工作得， 可以参考这篇论文 [Infiltrate the Vault: Security Analysis and Decryption of Lion Full Disk Encryption](https://eprint.iacr.org/2012/374.pdf) (pdf) 和这篇相关的[演讲文稿](http://www.cl.cam.ac.uk/~osc22/docs/slides_fv2_ifip_2013.pdf) (pdf)。也可以参阅 [IEEE Std 1619-2007 “The XTS-AES Tweakable Block Cipher”](http://libeccio.di.unisa.it/Crypto14/Lab/p1619.pdf) (pdf).

你可能希望强制开启**休眠**并且从内存中删除 FileVault 的秘钥，而非一般情况下系统休眠对内存操作的处理方式:

    $ sudo pmset -a destroyfvkeyonstandby 1
    $ sudo pmset -a hibernatemode 25

> 所有计算机都有 EFI 或 BIOS 这类的固件，它们帮助发现其它硬件，最终使用所需的操作系统实例把计算机正确启动起来。以 Apple 硬件和 EFI 的使用来说，Apple 把有关的信息保存在 EFI 内，它辅助 macOS 的功能正确运行。举例来说，FileVault 的秘钥保存在 EFI 内，在待机模式的时候出现。

> 那些容易被高频攻击的部件，或者那些待机模式下，容易被暴露给所有设备访问的设备，它们都应该销毁在固件中的 FileVault 秘钥来减少这个风险。这么干并不会影响 FileVault 的正常使用，但是系统需要用户在每次跳出待机模式的时候输入这个密码。

如果你选择在待机模式下删除 FileVault 秘钥，你也应该修改待机模式的设置。否则，你的机器可能无法正常进入待机模式，会因为缺少 FileVault 秘钥而关机。参考 [issue #124](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/124) 获得更多信息。可以通过以下命令修改这些设置:

    $ sudo pmset -a powernap 0
    $ sudo pmset -a standby 0
    $ sudo pmset -a standbydelay 0
    $ sudo pmset -a autopoweroff 0

如果你想了解更多， 请参考 [Best Practices for Deploying FileVault 2](http://training.apple.com/pdf/WP_FileVault2.pdf) (pdf) 和这篇论文 [Lest We Remember: Cold Boot Attacks on Encryption Keys](https://www.usenix.org/legacy/event/sec08/tech/full_papers/halderman/halderman.pdf) (pdf)


## 防火墙

在准备连接进入互联网之前，最好是先配置一个防火墙。

在 macOS 上有好几种防火墙。

#### 应用程序层的防火墙

系统自带的那个基本的防火墙，它只阻止**对内**的连接。

注意，这个防火墙没有监控的能力，也没有阻止**对外**连接的能力。

它能在 **System Preferences** 中 **Security & Privacy** 标签中的 **Firewall** 控制，或者使用以下的命令。

开启防火墙:

    $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

开启日志:

    $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

你可能还想开启私密模式:

    $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

> 计算机黑客会扫描网络，所以它们能标记计算机并且实施网络攻击。你能使用**私密模式**，避免你的计算机响应一些这样的恶意扫描。当开启了防火墙的私密模式后，你的计算机就不会响应 ICMP 请求，并且不响应那些已关闭的 TCP 或 UDP 端口的连接。这会让那些网络攻击者们很难发现你的计算机。

最后，你可能会想阻止**系统自带的软件**和**经过代码签名，下载过的软件自动加入白名单:**

    $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off

    $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

> 那些经过一个认证签名的应用程序会自动允许加入列表，而不是提示用户再对它们进行认证。包含在 OS X 内的应用程序都被 Apple 代码签名，并且都允许接对内的连接，当这个配置开启了。举例来说，因为 iTunes 已经被 Apple 代码签名，所以它能自动允许防火墙接收对内的连接。

> 如果你执行一个未签名的应用程序，它也没有被纳入防火墙白名单，此时一个带允许或者拒绝该连接选项的对话框会出现。如果你选择“允许连接”，macOS 对这个应用程序签名并且自动把它增加进防火墙的白名单。如果你选择“拒绝连接”，macOS 也会把它加入名单中，但是会拒绝对这个应用程序的对内连接。

在使用完 `socketfilterfw` 之后，你需要重新启动（或者结束）这个进程:

    $ sudo pkill -HUP socketfilterfw

#### 第三方防火墙

例如 [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html), [Hands Off](https://www.oneperiodic.com/products/handsoff/), [Radio Silence](http://radiosilenceapp.com/) 和 [Security Growler](https://pirate.github.io/security-growler/) 这样的程序都提供了一个方便、易用且安全的防火墙。

<img width="349" alt="Example of Little Snitch monitored session" src="https://cloud.githubusercontent.com/assets/12475110/10596588/c0eed3c0-76b3-11e5-95b8-9ce7d51b3d82.png">

**以下是一段 Little Snitch 监控会话的例子**

```
LittleSnitch-3.7.1.dmg
SHA-256: e6332ee70385f459d9803b0a582d5344bb9dab28bcd56e247ae69866cc321802
SHA-1:   d5d602c0f76cd73051792dff0ac334bbdc66ae32
```

这些程序都具备有监控和阻拦**对内**和**对外**网络连接的能力。然而，它们可能会需要使用一个闭源的[内核扩展](https://developer.apple.com/library/mac/documentation/Darwin/Conceptual/KernelProgramming/Extend/Extend.html)。

如果过多的允许或者阻拦网络连接的选择让你不堪重负，使用配置过白名单的**静谧模式**，之后定期检查你设定项，来了解这么多应用程序都在干什么。

需要指出的是，这些防火墙都会被以 **root** 权限运行的程序绕过，或者通过 [OS vulnerabilities](https://www.blackhat.com/docs/us-15/materials/us-15-Wardle-Writing-Bad-A-Malware-For-OS-X.pdf) (pdf)，但是它们还是值得拥有的 — 只是不要期待完全的保护。然而，一些恶意软件实际上能[自我删除](https://www.cnet.com/how-to/how-to-remove-the-flashback-malware-from-os-x/)，如果发现 `Little Snitch` 或者其他一些安全软件已经安装，它就根本不启动。

若想了解更多有关 Little Snitch 是如何工作的，可参考以下两篇文章：[Network Kernel Extensions Programming Guide](https://developer.apple.com/library/mac/documentation/Darwin/Conceptual/NKEConceptual/socket_nke/socket_nke.html#//apple_ref/doc/uid/TP40001858-CH228-SW1) 和 [Shut up snitch! – reverse engineering and exploiting a critical Little Snitch vulnerability](https://reverse.put.as/2016/07/22/shut-up-snitch-reverse-engineering-and-exploiting-a-critical-little-snitch-vulnerability/).

#### 内核级的数据包过滤

有一个高度可定制化、功能强大，但的确也是最复杂的防火墙存在内核中。它能通过 `pfctl` 或者很多配置文件控制。

pf 也能通过一个 GUI 应用程序控制，例如 [IceFloor](http://www.hanynet.com/icefloor/) 或者 [Murus](http://www.murusfirewall.com/)。

有很多书和文章介绍 pf 防火墙。这里，我们只介绍一个有关通过 IP 地址阻拦访问的例子。

将以下内容增加到 `pf.rules` 文件中:

```
set block-policy drop
set fingerprints "/etc/pf.os"
set ruleset-optimization basic
set skip on lo0
scrub in all no-df
table <blocklist> persist
block in log
block in log quick from no-route to any
pass out proto tcp from any to any keep state
pass out proto udp from any to any keep state
block log on en0 from {<blocklist>} to any
```

使用以下命令:

* `sudo pfctl -e -f pf.rules` — 开启防火墙
* `sudo pfctl -d` — 禁用防火墙
* `sudo pfctl -t blocklist -T add 1.2.3.4` — 把某个主机加入阻止清单中
* `sudo pfctl -t blocklist -T show` — 查看阻止清单
* `sudo ifconfig pflog0 create` — 为某个接口创建日志
* `sudo tcpdump -ni pflog0` — 输出打印数据包

我不建议你花大量时间在如何配置 pf 上，除非你对数据包过滤器非常熟悉。比如说，如果你的 Mac 计算机连接在一个 [NAT](https://www.grc.com/nat/nat.htm) 后面，它存在于一个安全的家庭网络中，那以上操作是完全没有必要的。

可以参考 [fix-macosx/net-monitor](https://github.com/fix-macosx/net-monitor) 来了解如何使用 pf 监控用户和系统级别对“背景连接通讯"的使用。

## 系统服务

在你连接到互联网之前，你不妨禁用一些系统服务，它们会使用一些资源或者后台连接通讯到 Apple。

可参考这三个代码仓库获得更多建议，[fix-macosx/yosemite-phone-home](https://github.com/fix-macosx/yosemite-phone-home), [l1k/osxparanoia](https://github.com/l1k/osxparanoia) 和 [karek314/macOS-home-call-drop](https://github.com/karek314/macOS-home-call-drop)。

在 macOS 上的系统服务都由 **launchd** 管理。可参考 [launchd.info](http://launchd.info/)，也可以参考以下两个材料，[Apple's Daemons and Services Programming Guide](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html) 和 [Technical Note TN2083](https://developer.apple.com/library/mac/technotes/tn2083/_index.html)。

你也可以运行 [KnockKnock](https://github.com/synack/knockknock)，它能展示出更多有关启动项的内容。

* 使用 `launchctl list` 查看正在运行的用户代理
* 使用 `sudo launchctl list` 查看正在运行的系统守护进程
* 通过指定服务名称查看，例如，`launchctl list com.apple.Maps.mapspushd`
* 使用 `defaults read` 来检查在 `/System/Library/LaunchDaemons` 和 `/System/Library/LaunchAgents` 工作中的 plist
* 使用 `man`，`strings` 和 Google 来学习运行中的代理和守护进程是什么

举例来说，想要知道某个系统启动的守护进程或者代理干了什么，可以输入以下指令:

    $ defaults read /System/Library/LaunchDaemons/com.apple.apsd.plist

看一看 `Program` 或者 `ProgramArguments` 这两个部分的内容，你就知道哪个二进制文件在运行，此处是 `apsd`。可以通过 `man apsd` 查看更多有关它的信息。

再举一个例子，如果你对 `Apple Push Nofitications` 不感兴趣，可以禁止这个服务:

    $ sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.apsd.plist

**注意** 卸载某些服务可能造成某些应用程序无法使用。首先，请阅读手册或者使用 Google 检索确保你明白自己在干什么。

禁用那些你不理解的系统进程的时候一定要万分小心，因为它可能会让你的系统瘫痪无法启动。如果你弄坏了你的 Mac，可以使用[单一用户模式](https://support.apple.com/en-us/HT201573)来修复。

如果你觉得 Mac 持续升温，感觉卡顿或者常常表现出诡异的行为，可以使用 [Console](https://en.wikipedia.org/wiki/Console_(OS_X)) 和 [Activity Monitor](https://support.apple.com/en-us/HT201464) 这两个应用程序，因为这可能是你不小心操作造成的。

以下指令可以查看现在已经禁用的服务:

    $ find /var/db/com.apple.xpc.launchd/ -type f -print -exec defaults read {} \; 2>/dev/null

有详细注释的启动系统守护进程和代理的列表，各自运行的程序和程序的哈希校验值都包含在这个代码仓库中了。

**（可选项）** 运行 `read_launch_plists.py` 脚本，使用 `diff` 输出和你系统对比后产生的差异，例如:

    $ diff <(python read_launch_plists.py) <(cat 16A323_launchd.csv)

你可以参考这篇 [cirrusj.github.io/Yosemite-Stop-Launch](http://cirrusj.github.io/Yosemite-Stop-Launch/)，它对具体服务进行了一些解释， 也可以看看这篇 [Provisioning OS X and Disabling Unnecessary Services](https://vilimpoc.org/blog/2014/01/15/provisioning-os-x-and-disabling-unnecessary-services/)，这篇是其它一些解释。

## Spotlight 建议

在 Spotlight 偏好设置面板和 Safari 的搜索偏好设置中都禁用 **Spotlight 建议**，来避免你的搜索查询项会发送给 Apple。

在 Spotlight 偏好设置面板中也禁用**必应 Web 搜索**来避免你的搜索查询项会发送给 Microsoft。

查看 [fix-macosx.com](https://fix-macosx.com/) 获得更详细的信息。

> 如果你已经更新到 Mac OS X Yosemite(10.10)并且在用默认的设置，每一次你开始在 Spotlight （去打开一个应用或在你的电脑中搜索一个文件）中打字，你本地的搜索词和位置会被发送给 Apple 和第三方（包括 Microsoft ）。

 **注意** 这个网站和它的指导说明已不再适用于 macOS Sierra — 参考[issue 164](https://github.com/drduh/macOS-Security-and-Privacy-Guide/issues/164).

下载，查看并应用他们建议的补丁：

```
$ curl -O https://fix-macosx.com/fix-macosx.py

$ less fix-macosx.py

$ python fix-macosx.py
All done. Make sure to log out (and back in) for the changes to take effect.
```

谈到 Microsoft，你可能还想看看 <https://fix10.isleaked.com/>，挺有意思的。

## Homebrew

考虑使用 [Homebrew](http://brew.sh/) 来安装软件和更新用户工具（查看 [Apple’s great GPL purge](http://meta.ath0.com/2012/02/05/apples-great-gpl-purge/)），这样更简单些。
**注意**如果你还没安装 Xcode 或命令行工具，可以用 `xcode-select --install` 来从 Apple 下载、安装。

要[安装 Homebrew](https://github.com/Homebrew/brew/blob/master/docs/Installation.md#installation):

    $ mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew


在你的脚本或 rc 文件中编辑 `PATH` 来使用 `~/homebrew/bin` 和 `~/homebrew/sbin`。例如，先 `echo 'PATH=$PATH:~/homebrew/sbin:~/homebrew/bin' >> .zshrc`，然后用 `chsh -s /bin/zsh` 把登录脚本改为 Z shell，打开一个新的终端窗口并运行 `brew update`。

Homebrew 使用 SSL/TLS 与 GitHub 通信并验证下载包的校验，所以它是[相当安全的](https://github.com/Homebrew/homebrew/issues/18036)。

记得定期在可信任的、安全的网络上运行 `brew update` 和 `brew upgrade` 来下载、安装软件更新。想在安装前得到关于一个包的信息，运行 `brew info <package>` 在线查看。

依据 [Homebrew 匿名汇总用户行为分析](https://github.com/Homebrew/brew/blob/master/docs/Analytics.md)，Homebrew 获取匿名的汇总的用户行为分析数据并把它们报告给 Google Analytics。

你可以在你的（shell）环境或 rc 文件中设置 `export HOMEBREW_NO_ANALYTICS=1`，或使用 `brew analytics off` 来退出 Homebrew 的分析。

可能你还希望启用[额外的安全选项](https://github.com/drduh/macOS-Security-and-Privacy-Guide/issues/138)，例如 `HOMEBREW_NO_INSECURE_REDIRECT=1` 和 `HOMEBREW_CASK_OPTS=--require-sha`。

## DNS

#### Hosts 文件

使用 [Hosts 文件](https://en.wikipedia.org/wiki/Hosts_(file)) 来屏蔽蔽已知的恶意软件、广告或那些不想访问的域名。

用 root 用户编辑 hosts 文件，例如用 `sudo vi /etc/hosts`。hosts 文件也能用可视化的应用 [2ndalpha/gasmask](https://github.com/2ndalpha/gasmask) 管理。

要屏蔽一个域名，在 `/etc/hosts` 中加上 `0 example.com` 或 `0.0.0.0 example.com` 或 `127.0.0.1 example.com`。

网上有很多可用的域名列表，你可以直接复制过来，要确保每一行以 `0`, `0.0.0.0`, `127.0.0.1` 开始，并且 `127.0.0.1 localhost` 这一行包含在内。

对于这些主机列表，可以查看 [someonewhocares.org](http://someonewhocares.org/hosts/zero/hosts)、[l1k/osxparanoia/blob/master/hosts](https://github.com/l1k/osxparanoia/blob/master/hosts)、[StevenBlack/hosts](https://github.com/StevenBlack/hosts) 和 [gorhill/uMatrix/hosts-files.json](https://github.com/gorhill/uMatrix/blob/master/assets/umatrix/hosts-files.json)。

要添加一个新的列表：

```
$ curl "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" | sudo tee -a /etc/hosts

$ wc -l /etc/hosts
31998

$ egrep -ve "^#|^255.255.255|^0.0.0.0|^127.0.0.0|^0 " /etc/hosts
::1 localhost
fe80::1%lo0 localhost
[should not return any other IP addresses]
```

更多信息请查看 `man hosts` 和 [FreeBSD 配置文件](https://www.freebsd.org/doc/handbook/configtuning-configfiles.html)。

#### Dnsmasq

与其他特性相比，[dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) 能缓存请求，避免无资格名单中的查询数据上传和屏蔽所有的顶级域名。

另外，和 DNSCrypt 一起使用来加密输出的 DNS 流量。

如果你不想使用 DNSCrypt，再怎么滴也不要用 [ISP](http://hackercodex.com/guide/how-to-stop-isp-dns-server-hijacking) [提供](http://bcn.boulder.co.us/~neal/ietf/verisign-abuse.html) 的 DNS。两个流行的选择是 [Google DNS](https://developers.google.com/speed/public-dns/) 和 [OpenDNS](https://www.opendns.com/home-internet-security/)。

**(可选)** [DNSSEC](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions) 是一系列 DNS 的扩展，为 DNS 客户端提供 DNS 数据的来源验证、否定存在验证和数据完整性检验。所有来自 DNSSEC 保护区域的应答都是数字签名的。签名的记录通过一个信任链授权，以一系列验证过的 DNS 根区域的公钥开头。当前的根区域信任锚点可能下载下来[从 IANA 网站](https://www.iana.org/dnssec/files)。关于 DNSSEC 有很多的资源，可能最好的一个是 [dnssec.net 网站](http://www.dnssec.net)。

安装 Dnsmasq (DNSSEC 是可选的)：

    $ brew install dnsmasq --with-dnssec

    $ cp ~/homebrew/opt/dnsmasq/dnsmasq.conf.example ~/homebrew/etc/dnsmasq.conf


编辑配置项：

    $ vim ~/homebrew/etc/dnsmasq.conf

检查所有的选项。这有一些推荐启用的设置：

```
# Forward queries to DNSCrypt on localhost port 5355
server=127.0.0.1#5355

# Uncomment to forward queries to Google Public DNS
#server=8.8.8.8

# Never forward plain names
domain-needed

# Examples of blocking TLDs or subdomains
address=/.onion/0.0.0.0
address=/.local/0.0.0.0
address=/.mycoolnetwork/0.0.0.0
address=/.facebook.com/0.0.0.0

# Never forward addresses in the non-routed address spaces
bogus-priv

# Reject private addresses from upstream nameservers
stop-dns-rebind

# Query servers in order
strict-order

# Set the size of the cache
# The default is to keep 150 hostnames
cache-size=8192

# Optional logging directives
log-async
log-dhcp
log-facility=/var/log/dnsmasq.log

# Uncomment to log all queries
#log-queries

# Uncomment to enable DNSSEC
#dnssec
#trust-anchor=.,19036,8,2,49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5
#dnssec-check-unsigned
```

安装并启动程序（`sudo` 需要绑定在 [53 特权端口](https://unix.stackexchange.com/questions/16564/why-are-the-first-1024-ports-restricted-to-the-root-user-only)）：

    $ sudo brew services start dnsmasq

要设置 Dnsmasq 为本地的 DNS 服务器，打开**系统偏好设置** > **网络**并选择“高级”（译者注：原文为 ‘active interface’，实际上‘高级’），接着切换到 **DNS** 选项卡，选择 **+** 并 添加 `127.0.0.1`, 或使用：

    $ sudo networksetup -setdnsservers "Wi-Fi" 127.0.0.1

确保 Dnsmasq 正确配置：

```
$ scutil --dns
DNS configuration

resolver #1
  search domain[0] : whatever
  nameserver[0] : 127.0.0.1
  flags    : Request A records, Request AAAA records
  reach    : Reachable, Local Address, Directly Reachable Address

$ networksetup -getdnsservers "Wi-Fi"
127.0.0.1
```

**注意** 一些 VPN 软件一链接会覆盖 DNS 设置。更多信息查看 [issue #24](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/24)。

#### 检测 DNSSEC 验证

测试已签名区域的 DNSSEC（域名系统安全扩展协议）验证是否成功：

    $ dig +dnssec icann.org

应答应该有`NOERROR`状态并包含`ad`。例如：

    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47039
    ;; flags: qr rd ra ad; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

不恰当签名的区域会导致检测 DNSSEC 验证的失败：

    $ dig www.dnssec-failed.org

应答应该包含`SERVFAIL`状态。例如：

    ;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 15190
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

#### dnscrypt

使用 [dnscrypt](https://dnscrypt.org/) 在可选的范围内加密 DNS 流量（译者注：原文为 ‘the provider of choice’）。

如果你更喜欢一个 GUI 应用程序，看这里 [alterstep/dnscrypt-osxclient](https://github.com/alterstep/dnscrypt-osxclient)。

从 Homebrew 安装 DNSCrypt：

    $ brew install dnscrypt-proxy

如果要和 Dnsmasq 一起使用，找到这个文件`homebrew.mxcl.dnscrypt-proxy.plist`

```
$ find ~/homebrew -name homebrew.mxcl.dnscrypt-proxy.plist
/Users/drduh/homebrew/Cellar/dnscrypt-proxy/1.7.0/homebrew.mxcl.dnscrypt-proxy.plist
```

将下面一行编辑进去：

    <string>--local-address=127.0.0.1:5355</string>

接着写：

    <string>/usr/local/opt/dnscrypt-proxy/sbin/dnscrypt-proxy</string>

<img width="1015" alt="dnscrypt" src="https://cloud.githubusercontent.com/assets/12475110/19222914/8e6f853e-8e31-11e6-8dd6-27c33cbfaea5.png">

**添加一行本地地址来使用 DNScrypt，使用 53 以外的端口，比如 5355**

用 Homebrew 也能实现上述过程，安装 `gnu-sed` 并使用` gsed` 命令行：

    $ sudo gsed -i "/sbin\\/dnscrypt-proxy<\\/string>/a<string>--local-address=127.0.0.1:5355<\\/string>\n" $(find ~/homebrew -name homebrew.mxcl.dnscrypt-proxy.plist)

默认情况下，`resolvers-list` 将会指向 dnscrypt 版本特定的 resolvers 文件。当更新了 dnscrypt，这一版本将不再存在，若它存在，可能指向一个过期的文件。在 `/Library/LaunchDaemons/homebrew.mxcl.dnscrypt-proxy.plist` 中把 resolvers 文件改为 `/usr/local/share` 中的符号链接的版本，能解决上述问题：

    <string>--resolvers-list=/usr/local/share/dnscrypt-proxy/dnscrypt-resolvers.csv</string>

启用 DNSCrypt：

    $ brew services start dnscrypt-proxy

确保 DNSCrypt 在运行：

```
$ sudo lsof -Pni UDP:5355
COMMAND   PID   USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
dnscrypt-  83 nobody    7u  IPv4 0x1773f85ff9f8bbef      0t0  UDP 127.0.0.1:5355

$ ps A | grep '[d]nscrypt'
   83   ??  Ss     0:00.27 /Users/drduh/homebrew/opt/dnscrypt-proxy/sbin/dnscrypt-proxy --local-address=127.0.0.1:5355 --ephemeral-keys --resolvers-list=/Users/drduh/homebrew/opt/dnscrypt-proxy/share/dnscrypt-proxy/dnscrypt-resolvers.csv --resolver-name=dnscrypt.eu-dk --user=nobody
```

> 默认情况下，dnscrypt-proxy 运行在本地 (127.0.0.1) ，53 端口，并且 "nobody" 身份使用dnscrypt.eu-dk DNSCrypt-enabled
resolver。如果你想改变这些设置，你得编辑 plist 文件 (例如, --resolver-address, --provider-name, --provider-key, 等。)

通过编辑 `homebrew.mxcl.dnscrypt-proxy.plist` 也能完成

你能从一个信任的位置或使用 [public servers](https://github.com/jedisct1/dnscrypt-proxy/blob/master/dnscrypt-resolvers.csv) 中的一个运行你自己的 [dnscrypt server](https://github.com/Cofyc/dnscrypt-wrapper)（也可以参考 [drduh/Debian-Privacy-Server-Guide#dnscrypt](https://github.com/drduh/Debian-Privacy-Server-Guide#dnscrypt)）

确保输出的 DNS 流量已加密：

```
$ sudo tcpdump -qtni en0
IP 10.8.8.8.59636 > 77.66.84.233.443: UDP, length 512
IP 77.66.84.233.443 > 10.8.8.8.59636: UDP, length 368

$ dig +short -x 77.66.84.233
resolver2.dnscrypt.eu
```

你也可以阅读 [What is a DNS leak](https://dnsleaktest.com/what-is-a-dns-leak.html)，[mDNSResponder manual page](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/mDNSResponder.8.html) 和 [ipv6-test.com](http://ipv6-test.com/)。

## Captive portal

当 macOS 连接到新的网络，它会**检测**网络，如果连接没有被接通，则会启动 Captive Portal assistant 功能。

一个攻击者能触发这一功能，无需用户交互就将一台电脑定向到有恶意软件的网站，最好禁用这个功能并用你经常用的浏览器登录 captive portals， 前提是你必须首先禁用了任何的客户端 / 代理设置。

    $ sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

也可以看看 [Apple OS X Lion Security: Captive Portal Hijacking Attack](https://www.securestate.com/blog/2011/10/07/apple-os-x-lion-captive-portal-hijacking-attack)，[Apple's secret "wispr" request](http://blog.erratasec.com/2010/09/apples-secret-wispr-request.html)，[How to disable the captive portal window in Mac OS Lion](https://web.archive.org/web/20130407200745/http://www.divertednetworks.net/apple-captiveportal.html)，和 [An undocumented change to Captive Network Assistant settings in OS X 10.10 Yosemite](https://grpugh.wordpress.com/2014/10/29/an-undocumented-change-to-captive-network-assistant-settings-in-os-x-10-10-yosemite/)。

## 证书授权

macOS 上有从像 Apple、Verisign、Thawte、Digicert 这样的营利性公司和来自中国、日本、荷兰、美国等等的政府机关安装的[超过 200](https://support.apple.com/en-us/HT202858) 个可信任的根证书。这些证书授权(CAs)能够针对任一域名处理 SSL/TLS 认证，代码签名证书等等。

想要了解更多，可以看看 [Certification Authority Trust Tracker](https://github.com/kirei/catt)、[Analysis of the HTTPS certificate ecosystem](http://conferences.sigcomm.org/imc/2013/papers/imc257-durumericAemb.pdf)(pdf) 和 [You Won’t Be Needing These Any More: On Removing Unused Certificates From Trust Stores](http://www.ifca.ai/fc14/papers/fc14_submission_100.pdf)(pdf)。

你可以在**钥匙串访问**中的**系统根证书**选项卡下检查系统根证书，或者使用 `security` 命令行工具和 `/System/Library/Keychains/SystemRootCertificates.keychain` 文件。

你可以通过钥匙串访问将它们标记为**永不信任**禁用证书授权并关闭窗口：

<img width="450" alt="A certificate authority certificate" src="https://cloud.githubusercontent.com/assets/12475110/19222972/6b7aabac-8e32-11e6-8efe-5d3219575a98.png">

被你的系统信任的被迫或妥协的证书授权产生一个假的 / 欺骗的 SSL 证书，这样的一个[中间人攻击](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)的风险很低，但仍然是[可能的](https://en.wikipedia.org/wiki/DigiNotar#Issuance_of_fraudulent_certificates)。

## OpenSSL

在 Sierra 中 OpenSSL 的版本是`0.9.8zh`，这[不是最新的](https://apple.stackexchange.com/questions/200582/why-is-apple-using-an-older-version-of-openssl)。它不支持 TLS 1.1 或新的版本，elliptic curve ciphers，[还有更多](https://stackoverflow.com/questions/27502215/difference-between-openssl-09-8z-and-1-0-1)。

Apple 在他们的 [Cryptographic Services 指南](https://developer.apple.com/library/mac/documentation/Security/Conceptual/cryptoservices/GeneralPurposeCrypto/GeneralPurposeCrypto.html)文档中宣布**弃用** OpenSSL。他们的版本也有补丁，可能会[带来惊喜喔](https://hynek.me/articles/apple-openssl-verification-surprises/)。

如果你要在你的 Mac 上用 OpenSSL，用 `brew install openssl` 下载并安装一个 OpenSSL 最近的版本。注意，brew 已经链接了 `/usr/bin/openssl` ，可能和构建软件冲突。查看 [issue #39](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/39)。

在 homebrew 版本和 OpenSSL 系统版本之间比较 TLS 协议和密码：

```
$ ~/homebrew/bin/openssl version; echo | ~/homebrew/bin openssl s_client -connect github.com:443 2>&1 | grep -A2 SSL-Session
OpenSSL 1.0.2j  26 Sep 2016
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES128-GCM-SHA256

$ /usr/bin/openssl version; echo | /usr/bin/openssl s_client -connect github.com:443 2>&1 | grep -A2 SSL-Session
OpenSSL 0.9.8zh 14 Jan 2016
SSL-Session:
    Protocol  : TLSv1
    Cipher    : AES128-SHA
```

阅读 [Comparison of TLS implementations](https://en.wikipedia.org/wiki/Comparison_of_TLS_implementations)，[How's My SSL](https://www.howsmyssl.com/)，[Qualys SSL Labs Tools](https://www.ssllabs.com/projects/) 了解更多，查看更详细的解释和最新的漏洞测试请看 [ssl-checker.online-domain-tools.com](http://ssl-checker.online-domain-tools.com)。

## Curl

macOS 中 Curl 的版本针对 SSL/TLS 验证使用[安全传输](https://developer.apple.com/library/mac/documentation/Security/Reference/secureTransportRef/)。

如果你更愿意使用 OpenSSL，用 `brew install curl --with-openssl` 安装并通过 `brew link --force curl` 确保它是默认的。

这里推荐几个向 `~/.curlrc` 中添加的[可选项](http://curl.haxx.se/docs/manpage.html)（更多请查看 `man curl`）：

```
user-agent = "Mozilla/5.0 (Windows NT 6.1; rv:45.0) Gecko/20100101 Firefox/45.0"
referer = ";auto"
connect-timeout = 10
progress-bar
max-time = 90
verbose
show-error
remote-time
ipv4
```

## Web

### 代理

考虑使用 [Privoxy](http://www.privoxy.org/) 作为本地代理来过滤网络浏览内容。

一个已签名的 privoxy 安装包能从 [silvester.org.uk](http://silvester.org.uk/privoxy/OSX/) 或 [Sourceforge](http://sourceforge.net/projects/ijbswa/files/Macintosh%20%28OS%20X%29/) 下载。签过名的包比 Homebrew 版本[更安全](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/65)，而且能得到 Privoxy 项目全面的支持。

另外，用 Homebrew 安装、启动 privoxy：

    $ brew install privoxy

    $ brew services start privoxy


默认情况下，privoxy 监听本地的 8118 端口。

为你的网络接口设置系统 **http** 代理为`127.0.0.1` 和 `8118`（可以通过 **系统偏好设置 > 网络 > 高级 > 代理**）：

    $ sudo networksetup -setwebproxy "Wi-Fi" 127.0.0.1 8118


**(可选)** 用下述方法设置系统 **https** 代理，这仍提供了域名过滤功能：

    $ sudo networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 8118

确保代理设置好了：

```
$ scutil --proxy
<dictionary> {
  ExceptionsList : <array> {
    0 : *.local
    1 : 169.254/16
  }
  FTPPassive : 1
  HTTPEnable : 1
  HTTPPort : 8118
  HTTPProxy : 127.0.0.1
}
```

在一个浏览器里访问 <http://p.p/>，或用 Curl 访问：

```
$ ALL_PROXY=127.0.0.1:8118 curl -I http://p.p/
HTTP/1.1 200 OK
Content-Length: 2401
Content-Type: text/html
Cache-Control: no-cache
```

代理已经有很多好的规则，你也能自己定义。

编辑 `~/homebrew/etc/privoxy/user.action` 用域名或正则表达式来过滤。

示例如下：

```
{ +block{social networking} }
www.facebook.com/(extern|plugins)/(login_status|like(box)?|activity|fan)\.php
.facebook.com

{ +block{unwanted images} +handle-as-image }
.com/ads/
/.*1x1.gif
/.*fb-icon.[jpg|gif|png]
/assets/social-.*
/cleardot.gif
/img/social.*
ads.*.co.*/
ads.*.com/

{ +redirect{s@http://@https://@} }
.google.com
.wikipedia.org
code.jquery.com
imgur.com
```

验证 Privoxy 能够拦截和重定向：

```
$ ALL_PROXY=127.0.0.1:8118 curl ads.foo.com/ -IL
HTTP/1.1 403 Request blocked by Privoxy
Content-Type: image/gif
Content-Length: 64
Cache-Control: no-cache

$ ALL_PROXY=127.0.0.1:8118 curl imgur.com/ -IL
HTTP/1.1 302 Local Redirect from Privoxy
Location: https://imgur.com/
Content-Length: 0
Date: Sun, 09 Oct 2016 18:48:19 GMT

HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
```

你能用小猫的图片来代替广告图片，例如，通过启动一个本地的 Web 服务器然后[重定向屏蔽的请求](https://www.privoxy.org/user-manual/actions-file.html#SET-IMAGE-BLOCKER)到本地。

### 浏览器

Web 浏览器引发最大的安全和隐私风险，因为它基本的工作是从因特网上下载和运行未信任的代码。

对于你的大部分浏览请使用 [Google Chrome](https://www.google.com/chrome/browser/desktop/)。它提供了[独立的配置文件](https://www.chromium.org/user-experience/multi-profiles)，[好的沙盒处理](https://www.chromium.org/developers/design-documents/sandbox)，[经常更新](http://googlechromereleases.blogspot.com/)（包括 Flash，尽管你应该禁用它 —— 原因看下面），并且[自带牛哄哄的资格证书](https://www.chromium.org/Home/chromium-security/brag-sheet)。

Chrome 也有一个很好的 [PDF 阅读器](http://0xdabbad00.com/2013/01/13/most-secure-pdf-viewer-chrome-pdf-viewer/)。

如果你不想用 Chrome，[Firefox](https://www.mozilla.org/en-US/firefox/new/) 也是一个很好的浏览器。或两个都用。看这里的讨论 [#2](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/2)，[#90](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/90)。

如果用 Firefox，查看 [TheCreeper/PrivacyFox](https://github.com/TheCreeper/PrivacyFox) 里推荐的隐私偏好设置。也要确保为基于 Mozilla 的浏览器检查 [NoScript](https://noscript.net/)，它允许基于白名单预先阻止脚本。

创建至少三个配置文件，一个用来浏览**可信任的**网站 (邮箱，银行)，另一个为了**大部分是可信的** 网站（聚合类，新闻类站点），第三个是针对完全**无 cookie** 和**无脚本**的网站浏览。

* 一个启用了 **无 cookies 和 Javascript**（例如, 在 `chrome://settings/content`中被关掉）的配置文件就应该用来访问未信任的网站。然而，如果不启用 Javascript，很多页面根本不会加载。

* 一个有 [uMatrix](https://github.com/gorhill/uMatrix) 或 [uBlock Origin](https://github.com/gorhill/uBlock)（或两个都有）的配置文件。用这个文件来访问**大部分是可信的**网站。花时间了解防火墙扩展程序是怎么工作的。其他经常被推荐的扩展程序是 [Privacy Badger](https://www.eff.org/privacybadger)、[HTTPSEverywhere](https://www.eff.org/https-everywhere) 和 [CertPatrol](http://patrol.psyced.org/)（仅限 Firefox）。

* 一个或更多的配置文件用来满足安全和可信任的浏览需求，例如仅限于银行和邮件。

想法是分隔并划分数据，那么如果一个“会话”出现漏洞或泄露隐私并不一定会影响其它数据。

在每一个文件里，访问 `chrome://plugins/` 并禁用 **Adobe Flash Player**。如果你一定要用 Flash，访问 `chrome://settings/contents`，在插件部分，启用在**让我自行选择何时运行插件内容**（也叫做 *click-to-play*）。

花时间阅读 [Chromium 安全](https://www.chromium.org/Home/chromium-security)和 [Chromium 隐私](https://www.chromium.org/Home/chromium-privacy)。

例如你可能希望禁用 [DNS prefetching](https://www.chromium.org/developers/design-documents/dns-prefetching)（也可以阅读 [DNS Prefetching and Its Privacy Implications](https://www.usenix.org/legacy/event/leet10/tech/full_papers/Krishnan.pdf)）。

你也应该知道 [WebRTC](https://en.wikipedia.org/wiki/WebRTC#Concerns)，它能获取你本地或外网的（如果连到 VPN）IP 地址。这可以用诸如 [uBlock Origin](https://github.com/gorhill/uBlock/wiki/Prevent-WebRTC-from-leaking-local-IP-address) 和 [rentamob/WebRTC-Leak-Prevent](https://github.com/rentamob/WebRTC-Leak-Prevent) 这样的扩展程序禁用掉。

很多源于 Chromium 的浏览器本文是不推荐的。它们通常[不开源](http://yro.slashdot.org/comments.pl?sid=4176879&cid=44774943)，[维护性差](https://plus.google.com/+JustinSchuh/posts/69qw9wZVH8z)，[有很多 bug](https://code.google.com/p/google-security-research/issues/detail?id=679)，而且对保护隐私有可疑的声明。阅读 [The Private Life of Chromium Browsers](http://thesimplecomputer.info/the-private-life-of-chromium-browsers)。

也不推荐 Safari。代码一团糟而且[安全问题](https://nakedsecurity.sophos.com/2014/02/24/anatomy-of-a-goto-fail-apples-ssl-bug-explained-plus-an-unofficial-patch/)[漏洞](https://vimeo.com/144872861)经常发生，并且打补丁很慢（阅读 [Hacker News 上的讨论](https://news.ycombinator.com/item?id=10150038)）。安全[并不是](https://discussions.apple.com/thread/5128209) Safari 的一个优点。如果你硬要使用它，至少在偏好设置里[禁用](https://thoughtsviewsopinions.wordpress.com/2013/04/26/how-to-stop-downloaded-files-opening-automatically/)**下载后打开"安全的文件**，也要了解其他的[隐私差别](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/93)。

其他乱七八糟的浏览器，例如 [Brave](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/94)，在这个指南里没有评估，所以既不推荐也不反对使用。

想浏览更多安全方面的问题，请阅读 [HowTo: Privacy & Security Conscious Browsing](https://gist.github.com/atcuno/3425484ac5cce5298932)，[browserleaks.com](https://www.browserleaks.com/) 和 [EFF Panopticlick](https://panopticlick.eff.org/)。

### 插件

**Adobe Flash**, **Oracle Java**, **Adobe Reader**, **Microsoft Silverlight**（Netflix 现在使用了 [HTML5](https://help.netflix.com/en/node/23742)） 和其他的插件有[安全风险](https://news.ycombinator.com/item?id=9901480)，不应该安装。

如果它们是必须的，只在一个虚拟机里安装它们并且订阅安全通知以便确保你总能及时修补漏洞。

阅读 [Hacking Team Flash Zero-Day](http://blog.trendmicro.com/trendlabs-security-intelligence/hacking-team-flash-zero-day-integrated-into-exploit-kits/)、[Java Trojan BackDoor.Flashback](https://en.wikipedia.org/wiki/Trojan_BackDoor.Flashback)、[Acrobat Reader: Security Vulnerabilities](http://www.cvedetails.com/vulnerability-list/vendor_id-53/product_id-497/Adobe-Acrobat-Reader.html) 和 [Angling for Silverlight Exploits](https://blogs.cisco.com/security/angling-for-silverlight-exploits)。

## PGP/GPG

PGP 是一个端对端邮件加密标准。这意味着只是选中的接收者能解密一条消息，不像通常的邮件被提供者永久阅读和保存。

**GPG** 或 **GNU Privacy Guard**，是一个符合标准的 GPL 协议项目。

**GPG** 被用来验证你下载和安装的软件签名，既可以[对称](https://en.wikipedia.org/wiki/Symmetric-key_algorithm)也可以[非对称](https://en.wikipedia.org/wiki/Public-key_cryptography)的加密文件和文本。

从 Homebrew 上用 `brew install gnupg2` 安装。

如果你更喜欢图形化的应用，下载安装 [GPG Suite](https://gpgtools.org/)。

这有几个往 `~/.gnupg/gpg.conf` 中添加的[推荐选项](https://github.com/drduh/config/blob/master/gpg.conf)：

```
auto-key-locate keyserver
keyserver hkps://hkps.pool.sks-keyservers.net
keyserver-options no-honor-keyserver-url
keyserver-options ca-cert-file=/etc/sks-keyservers.netCA.pem
keyserver-options no-honor-keyserver-url
keyserver-options debug
keyserver-options verbose
personal-cipher-preferences AES256 AES192 AES CAST5
personal-digest-preferences SHA512 SHA384 SHA256 SHA224
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
cert-digest-algo SHA512
s2k-digest-algo SHA512
s2k-cipher-algo AES256
charset utf-8
fixed-list-mode
no-comments
no-emit-version
keyid-format 0xlong
list-options show-uid-validity
verify-options show-uid-validity
with-fingerprint
```

安装 keyservers [CA 认证](https://sks-keyservers.net/verify_tls.php)：

    $ curl -O https://sks-keyservers.net/sks-keyservers.netCA.pem

    $ sudo mv sks-keyservers.netCA.pem /etc

这些设置将配置 GnuPG 在获取新密钥和想用强加密原语时使用 SSL。

请阅读 [ioerror/duraconf/configs/gnupg/gpg.conf](https://github.com/ioerror/duraconf/blob/master/configs/gnupg/gpg.conf)。你也应该花时间读读 [OpenPGP Best Practices](https://help.riseup.net/en/security/message-security/openpgp/best-practices)。

如果你没有一个密钥对，可以用 `gpg --gen-key` 创建一个。也可以阅读 [drduh/YubiKey-Guide](https://github.com/drduh/YubiKey-Guide)。

读[在线的](https://alexcabal.com/creating-the-perfect-gpg-keypair/)[指南](https://security.stackexchange.com/questions/31594/what-is-a-good-general-purpose-gnupg-key-setup)并练习给你自己和朋友们加密解密邮件。让他们也对这篇文章感兴趣吧！

## OTR

OTR 代表 **off-the-record** 并且是一个针对即时消息对话加密和授权的密码协议。

你能在任何一个已存在的 [XMPP](https://xmpp.org/about) 聊天服务中使用 OTR，甚至是 Google Hangouts（它只在使用 TLS 的用户和服务器之间加密对话）。

你和某人第一次开始一段对话，你将被要求去验证他们的公钥指纹。确保是本人亲自操作或通过其它一些安全的方式(例如 GPG 加密过的邮件)。
针对 XMPP 和其他的聊天协议，有一个流行的 macOS GUI 客户端是 [Adium](https://adium.im/)。

考虑下载一个 [beta 版本](https://beta.adium.im/)，使用 OAuth2 验证，确保登录谷歌账号[更](https://adium.im/blog/2015/04/)[安全](https://trac.adium.im/ticket/16161)。

```
Adium_1.5.11b3.dmg
SHA-256: 999e1931a52dc327b3a6e8492ffa9df724a837c88ad9637a501be2e3b6710078
SHA-1:   ca804389412f9aeb7971ade6812f33ac739140e6
```

记住对于 Adium 的 OTR 聊天[禁用登录](https://trac.adium.im/ticket/15722)。

一个好的基于控制台的 XMPP 客户端是 [profanity](http://www.profanity.im/)，它能用 `brew install profanity` 安装。

想增加匿名性的话，查看 [Tor Messenger](https://blog.torproject.org/blog/tor-messenger-beta-chat-over-tor-easily)，尽管它还在测试中，[Ricochet](https://ricochet.im/)（它最近接受了一个彻底的[安全审查](https://ricochet.im/files/ricochet-ncc-audit-2016-01.pdf)）也是，这两个都使用 Tor 网络而不是依赖于消息服务器。

如果你想了解 OTR 是如何工作的，可以阅读这篇论文 [Off-the-Record Communication, or, Why Not To Use PGP](https://otr.cypherpunks.ca/otr-wpes.pdf)

## Tor

Tor 是一个用来浏览网页的匿名代理。

从[官方 Tor 项目网站](https://www.torproject.org/projects/torbrowser.html)下载 Tor 浏览器。

**不要**尝试配置其他的浏览器或应用程序来使用 Tor，因为你可能会导致一个错误，危及你的匿名信息。

下载 `dmg` 和 `asc` 签名文件，然后验证已经被 Tor 开发者签过名的磁盘镜像：

```
$ cd Downloads

$ file Tor*
TorBrowser-6.0.5-osx64_en-US.dmg:     bzip2 compressed data, block size = 900k
TorBrowser-6.0.5-osx64_en-US.dmg.asc: PGP signature Signature (old)

$ gpg Tor*asc
gpg: assuming signed data in `TorBrowser-6.0.5-osx64_en-US.dmg'
gpg: Signature made Fri Sep 16 07:51:52 2016 EDT using RSA key ID D40814E0
gpg: Can't check signature: public key not found

$ gpg --recv 0xD40814E0
gpg: requesting key D40814E0 from hkp server keys.gnupg.net
gpg: key 93298290: public key "Tor Browser Developers (signing key) <torbrowser@torproject.org>" imported
gpg: no ultimately trusted keys found
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)

$ gpg Tor*asc
gpg: assuming signed data in 'TorBrowser-6.0.5-osx64_en-US.dmg'
gpg: Signature made Fri Sep 16 07:51:52 2016 EDT using RSA key ID D40814E0
gpg: Good signature from "Tor Browser Developers (signing key) <torbrowser@torproject.org>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: EF6E 286D DA85 EA2A 4BA7  DE68 4E2C 6E87 9329 8290
     Subkey fingerprint: BA1E E421 BBB4 5263 180E  1FC7 2E1A C68E D408 14E0
```

确保 `Good signature from "Tor Browser Developers (signing key) <torbrowser@torproject.org>"`出现在输出结果中。关于密钥没被认证的警告没有危害的，因为它还没被手动分配信任。

看 [How to verify signatures for packages](https://www.torproject.org/docs/verifying-signatures.html) 获得更多信息。

要完成安装 Tor 浏览器，打开磁盘镜像，拖动它到应用文件夹里，或者这样：

```
$ hdiutil mount TorBrowser-6.0.5-osx64_en-US.dmg

$ cp -rv /Volumes/Tor\ Browser/TorBrowser.app /Applications
```

也可以验证是否这个 Tor 应用程序是由名为 **MADPSAYN6T** 的 Apple 开发者账号进行签名编译的:

```
$ codesign -dvv /Applications/TorBrowser.app
Executable=/Applications/TorBrowser.app/Contents/MacOS/firefox
Identifier=org.mozilla.tor browser
Format=app bundle with Mach-O thin (x86_64)
CodeDirectory v=20200 size=247 flags=0x0(none) hashes=5+3 location=embedded
Library validation warning=OS X SDK version before 10.9 does not support Library Validation
Signature size=4247
Authority=Developer ID Application: The Tor Project, Inc (MADPSAYN6T)
Authority=Developer ID Certification Authority
Authority=Apple Root CA
Signed Time=Nov 30, 2016, 10:40:34 AM
Info.plist entries=21
TeamIdentifier=MADPSAYN6T
Sealed Resources version=2 rules=12 files=130
Internal requirements count=1 size=184
```

为了查看证书的详细内容，可以使用 `codesign` 提取并且使用 `openssl` 对它进行解码:

```
$ codesign -d --extract-certificates /Applications/TorBrowser.app
Executable=/Applications/TorBrowser.app/Contents/MacOS/firefox

$ file codesign*
codesign0: data
codesign1: data
codesign2: data

$ openssl x509 -inform der -in codesign0 -subject -issuer -startdate -enddate -noout
subject= /UID=MADPSAYN6T/CN=Developer ID Application: The Tor Project, Inc (MADPSAYN6T)/OU=MADPSAYN6T/O=The Tor Project, Inc/C=US
issuer= /CN=Developer ID Certification Authority/OU=Apple Certification Authority/O=Apple Inc./C=US
notBefore=Apr 12 22:40:13 2016 GMT
notAfter=Apr 13 22:40:13 2021 GMT

$ openssl x509 -inform der -in codesign0  -fingerprint -noout
SHA1 Fingerprint=95:80:54:F1:54:66:F3:9C:C2:D8:27:7A:29:21:D9:61:11:93:B3:E8

$ openssl x509 -inform der -in codesign0 -fingerprint -sha256 -noout
SHA256 Fingerprint=B5:0D:47:F0:3E:CB:42:B6:68:1C:6F:38:06:2B:C2:9F:41:FA:D6:54:F1:29:D3:E4:DD:9C:C7:49:35:FF:F5:D9
```

Tor 流量对于[出口节点](https://en.wikipedia.org/wiki/Tor_anonymity_network#Exit_node_eavesdropping)（不能被一个网络窃听者读取）是**加密的**， Tor 是**可以**被发现的- 例如，TLS 握手“主机名”将会以明文显示：

```
$ sudo tcpdump -An "tcp" | grep "www"
listening on pktap, link-type PKTAP (Apple DLT_PKTAP), capture size 262144 bytes
.............". ...www.odezz26nvv7jeqz1xghzs.com.........
.............#.!...www.bxbko3qi7vacgwyk4ggulh.com.........
.6....m.....>...:.........|../*	Z....W....X=..6...C../....................................0...0..0.......'....F./0..	*.H........0%1#0!..U....www.b6zazzahl3h3faf4x2.com0...160402000000Z..170317000000Z0'1%0#..U....www.tm3ddrghe22wgqna5u8g.net0..0..
```

查看 [Tor Protocol Specification](https://gitweb.torproject.org/torspec.git/tree/tor-spec.txt) 和 [Tor/TLSHistory](https://trac.torproject.org/projects/tor/wiki/org/projects/Tor/TLSHistory) 获得更多信息。

另外，你可能也希望使用一个 [pluggable transport](https://www.torproject.org/docs/pluggable-transports.html)，例如 [Yawning/obfs4proxy](https://github.com/Yawning/obfs4) 或 [SRI-CSL/stegotorus](https://github.com/SRI-CSL/stegotorus) 来混淆 Tor 流量。

这能通过建立你自己的 [Tor relay](https://www.torproject.org/docs/tor-relay-debian.html) 或找到一个已存在的私有或公用的 [bridge](https://www.torproject.org/docs/bridges.html.en#RunningABridge) 来作为一个混淆入口节点来实现。

对于额外的安全性，在 [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 或 [VMware](https://www.vmware.com/products/fusion)，可视化的 [GNU/Linux](http://www.brianlinkletter.com/installing-debian-linux-in-a-virtualbox-virtual-machine/) 或 [BSD](http://www.openbsd.org/faq/faq4.html) 机器里用 Tor。

最后，记得 Tor 网络提供了[匿名](https://www.privateinternetaccess.com/blog/2013/10/how-does-privacy-differ-from-anonymity-and-why-are-both-important/)，这并不等于隐私。Tor 网络不一定能防止一个全球的窃听者能获得流量统计和[相关性](https://blog.torproject.org/category/tags/traffic-correlation)。你也可以阅读 [Seeking Anonymity in an Internet Panopticon](http://bford.info/pub/net/panopticon-cacm.pdf) 和 [Traffic Correlation on Tor by Realistic Adversaries](http://www.ohmygodel.com/publications/usersrouted-ccs13.pdf)。

阅读 [Invisible Internet Project (I2P)](https://geti2p.net/en/about/intro) 和它的 [Tor 对比](https://geti2p.net/en/comparison/tor)。

## VPN

如果你在未信任的网络使用 Mac - 机场，咖啡厅等 - 你的网络流量会被监控并可能被篡改。

用一个 VPN 是个好想法，它能用一个你信任的提供商加密**所有**输出的网络流量。举例说如何建立并拥有自己的 VPN，阅读 [drduh/Debian-Privacy-Server-Guide](https://github.com/drduh/Debian-Privacy-Server-Guide)。

不要盲目地还没理解整个流程和流量将如何被传输就为一个 VPN 服务签名。如果你不理解 VPN 是怎样工作的或不熟悉软件的使用，你就最好别用它。

当选择一个 VPN 服务或建立你自己的服务时，确保研究过协议，密钥交换算法，认证机制和使用的加密类型。诸如 [PPTP](https://en.wikipedia.org/wiki/Point-to-Point_Tunneling_Protocol#Security) 这样的一些协议，应该避免支持 [OpenVPN](https://en.wikipedia.org/wiki/OpenVPN)。

当 VPN 被中断或失去连接时，一些客户端可能通过下一个可用的接口发送流量。查看 [scy/8122924](https://gist.github.com/scy/8122924) 研究下如何允许流量只通过 VPN。

另一些脚本会关闭系统，所以只能通过 VPN 访问网络，这就是 the Voodoo Privacy project - [sarfata/voodooprivacy](https://github.com/sarfata/voodooprivacy) 的一部分，有一个更新的指南用来在一个虚拟机上（[hwdsl2/setup-ipsec-vpn](https://github.com/hwdsl2/setup-ipsec-vpn)）或一个 docker 容器（[hwdsl2/docker-ipsec-vpn-server](https://github.com/hwdsl2/docker-ipsec-vpn-server)）上建立一个 IPSec VPN。

## 病毒和恶意软件

面对[日益增长](https://www.documentcloud.org/documents/2459197-bit9-carbon-black-threat-research-report-2015.html)的恶意软件，Mac 还无法很好的防御这些病毒和恶意软件！

一些恶意软件捆绑在正版软件上，比如 [Java bundling Ask Toolbar](http://www.zdnet.com/article/oracle-extends-its-adware-bundling-to-include-java-for-macs/)，还有 [Mac.BackDoor.iWorm](https://docs.google.com/document/d/1YOfXRUQJgMjJSLBSoLiUaSZfiaS_vU3aG4Bvjmz6Dxs/edit?pli=1) 这种和盗版软件捆绑到一块的。 [Malwarebytes Anti-Malware for Mac](https://www.malwarebytes.com/antimalware/mac/) 是一款超棒的应用，它可以帮你摆脱种类繁多的垃圾软件和其他恶意程序的困扰。

看看[恶意软件驻留在 Mac OS X 的方法](https://www.virusbtn.com/pdf/conference/vb2014/VB2014-Wardle.pdf) (pdf) 和[恶意软件在 OS X Yosemite 后台运行](https://www.rsaconference.com/events/us15/agenda/sessions/1591/malware-persistence-on-os-x-yosemite)了解各种恶意软件的功能和危害。

你可以定期运行 [Knock Knock](https://github.com/synack/knockknock) 这样的工具来检查在持续运行的应用(比如脚本，二进制程序)。但这种方法可能已经过时了。[Block Block](https://objective-see.com/products/blockblock.html) 和 [Ostiarius](https://objective-see.com/products/ostiarius.html) 这样的应用可能还有些帮助。可以在 [issue #90](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/90) 中查看相关警告。除此之外，使用 [Little Flocker](https://www.littleflocker.com/) 也能保护部分文件系统免遭非法写入，类似 Little Snitch 保护网络 (注意，该软件目前是 beat 版本，[谨慎使用](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/pull/128))。

**反病毒**软件是把双刃剑 -- 对于**高级**用户没什么用，却可能面临更多复杂攻击的威胁。然而对于 Mac **新手**用户可能是有用的，可以检测到“各种”恶意软件。不过也要考到额外的处理开销。

看看 [Sophail: Applied attacks against Antivirus](https://lock.cmpxchg8b.com/sophailv2.pdf) (pdf), [Analysis and Exploitation of an ESET Vulnerability](http://googleprojectzero.blogspot.ro/2015/06/analysis-and-exploitation-of-eset.html), [a trivial Avast RCE](https://code.google.com/p/google-security-research/issues/detail?id=546), [Popular Security Software Came Under Relentless NSA and GCHQ Attacks](https://theintercept.com/2015/06/22/nsa-gchq-targeted-kaspersky/), 和 [AVG: "Web TuneUP" extension multiple critical vulnerabilities](https://code.google.com/p/google-security-research/issues/detail?id=675).

因此，最好的防病毒方式是日常地防范。看看 [issue #44](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/44) 中的讨论。

macOS 上有很多本地提权漏洞，所以要小心那些从第三方网站或 HTTP([案例](http://arstechnica.com/security/2015/08/0-day-bug-in-fully-patched-os-x-comes-under-active-exploit-to-hijack-macs/))下载且运行受信或不受信的程序。

看看 [The Safe Mac](http://www.thesafemac.com/) 上过去和目前的 Mac 安全新闻。

也检查下 [Hacking Team](https://www.schneier.com/blog/archives/2015/07/hacking_team_is.html) 为 Mac OS 开发的恶意软件：[root installation for MacOS](https://github.com/hackedteam/vector-macos-root)、 [Support driver for Mac Agent](https://github.com/hackedteam/driver-macos) 和 [RCS Agent for Mac](https://github.com/hackedteam/core-macos)，这是一个很好的示例，一些高级的恶意程序是如何在**用户空间**隐藏自己的(例如 `ps`、`ls`)。想了解更多的话，看看 [A Brief Analysis of an RCS Implant Installer](https://objective-see.com/blog/blog_0x0D.html) 和 [reverse.put.as](https://reverse.put.as/2016/02/29/the-italian-morons-are-back-what-are-they-up-to-this-time/)。

## 系统完整性保护

[System Integrity Protection](https://support.apple.com/en-us/HT204899) (SIP) 这个安全特性源于 OS X 10.11 "El Capitan"。默认是开启的，不过[可以禁用](https://derflounder.wordpress.com/2015/10/01/system-integrity-protection-adding-another-layer-to-apples-security-model/)，这可能需要更改某些系统设置，如删除根证书颁发机构或卸载某些启动守护进程。保持这项功能默认开启状态。

摘取自 [OS X 10.11 新增功能](https://developer.apple.com/library/prerelease/mac/releasenotes/MacOSX/WhatsNewInOSX/Articles/MacOSX10_11.html):

> 一项新的安全政策，应用于每个正在运行的进程，包括特权代码和非沙盒中运行的代码。该策略对磁盘上和运行时的组件增加了额外的保护，只允许系统安装程序和软件更新修改系统二进制文件。不再允许代码注入和运行时附加系统二进制文件。

阅读 [What is the “rootless” feature in El Capitan, really?](https://apple.stackexchange.com/questions/193368/what-is-the-rootless-feature-in-el-capitan-really)

[禁用 SIP](http://appleinsider.com/articles/16/11/17/system-integrity-protection-disabled-by-default-on-some-touch-bar-macbook-pros) 的一些 MacBook 已经售出。要验证 SIP 是否已启用，请使用命令 `csrutil status`，该命令应返回：`System Integrity Protection status: enabled.`。否则，通过恢复模式[启用 SIP](https://developer.apple.com/library/content/documentation/Security/Conceptual/System_Integrity_Protection_Guide/ConfiguringSystemIntegrityProtection/ConfiguringSystemIntegrityProtection.html)。

## Gatekeeper 和 XProtect

**Gatekeeper** 和 **quarantine** 系统试图阻止运行（打开）未签名或恶意程序及文件。

**XProtect** 防止执行已知的坏文件和过时的版本插件，但并不能清除或停止现有的恶意软件。

两者都提供了对常见风险的一些保护，默认设置就好。

你也可以阅读 [Mac Malware Guide : How does Mac OS X protect me?](http://www.thesafemac.com/mmg-builtin/) 和 [Gatekeeper, XProtect and the Quarantine attribute](http://ilostmynotes.blogspot.com/2012/06/gatekeeper-xprotect-and-quarantine.html)。

**注意** Quarantine 会将下载的文件信息存储在 `~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2`，这可能会造成隐私泄露的风险。简单的使用 `strings` 或下面的命令来检查文件:

    $ echo 'SELECT datetime(LSQuarantineTimeStamp + 978307200, "unixepoch") as LSQuarantineTimeStamp, LSQuarantineAgentName, LSQuarantineOriginURLString, LSQuarantineDataURLString from LSQuarantineEvent;' | sqlite3 /Users/$USER/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2

阅读[这篇文章](http://www.zoharbabin.com/hey-mac-i-dont-appreciate-you-spying-on-me-hidden-downloads-log-in-os-x/)了解更多信息。

想永久禁用此项功能，[清除文件](https://superuser.com/questions/90008/how-to-clear-the-contents-of-a-file-from-the-command-line)和[让它不可更改](http://hints.macworld.com/article.php?story=20031017061722471)：

    $ :>~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2

    $ sudo chflags schg ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2

此外，macOS 附加元数据（[HFS+ extended attributes](https://en.wikipedia.org/wiki/Extended_file_attributes#OS_X)）来下载文件，能通过 `mdls` 和 `xattr` 指令来观察：

```
$ ls -l@ ~/Downloads/TorBrowser-6.0.8-osx64_en-US.dmg
-rw-r--r--@ 1 drduh  staff  59322237 Dec  1 12:00 TorBrowser-6.0.8-osx64_en-US.dmg
com.apple.metadata:kMDItemWhereFroms	     186
com.apple.quarantine	      68

$ mdls ~/Downloads/TorBrowser-6.0.8-osx64_en-US.dmg
_kMDItemOwnerUserID            = 501
kMDItemContentCreationDate     = 2016-12-01 12:00:00 +0000
kMDItemContentModificationDate = 2016-12-01 12:00:00 +0000
kMDItemContentType             = "com.apple.disk-image-udif"
kMDItemContentTypeTree         = (
    "public.archive",
    "public.item",
    "public.data",
    "public.disk-image",
    "com.apple.disk-image",
    "com.apple.disk-image-udif"
)
kMDItemDateAdded               = 2016-12-01 12:00:00 +0000
kMDItemDisplayName             = "TorBrowser-6.0.8-osx64_en-US.dmg"
kMDItemFSContentChangeDate     = 2016-12-01 12:00:00 +0000
kMDItemFSCreationDate          = 2016-12-01 12:00:00 +0000
kMDItemFSCreatorCode           = ""
kMDItemFSFinderFlags           = 0
kMDItemFSHasCustomIcon         = (null)
kMDItemFSInvisible             = 0
kMDItemFSIsExtensionHidden     = 0
kMDItemFSIsStationery          = (null)
kMDItemFSLabel                 = 0
kMDItemFSName                  = "TorBrowser-6.0.8-osx64_en-US.dmg"
kMDItemFSNodeCount             = (null)
kMDItemFSOwnerGroupID          = 5000
kMDItemFSOwnerUserID           = 501
kMDItemFSSize                  = 60273898
kMDItemFSTypeCode              = ""
kMDItemKind                    = "Disk Image"
kMDItemLogicalSize             = 60273898
kMDItemPhysicalSize            = 60276736
kMDItemWhereFroms              = (
    "https://dist.torproject.org/torbrowser/6.0.8/TorBrowser-6.0.8-osx64_en-US.dmg",
    "https://www.torproject.org/projects/torbrowser.html.en"
)

$ xattr -l TorBrowser-6.0.8-osx64_en-US.dmg
com.apple.metadata:kMDItemWhereFroms:
00000000  62 70 6C 69 73 74 30 30 A2 01 02 5F 10 4D 68 74  |bplist00..._.Mht|
00000010  74 70 73 3A 2F 2F 64 69 73 74 2E 74 6F 72 70 72  |tps://dist.torpr|
00000020  6F 6A 65 63 74 2E 6F 72 67 2F 74 6F 72 62 72 6F  |oject.org/torbro|
00000030  77 73 65 72 2F 36 2E 30 2E 38 2F 54 6F 72 42 72  |wser/6.0.8/TorBr|
00000040  6F 77 73 65 72 2D 36 2E 30 2E 38 2D 6F 73 78 36  |owser-6.0.8-osx6|
00000050  34 5F 65 6E 2D 55 53 2E 64 6D 67 5F 10 36 68 74  |4_en-US.dmg_.6ht|
00000060  74 70 73 3A 2F 2F 77 77 77 2E 74 6F 72 70 72 6F  |tps://www.torpro|
00000070  6A 65 63 74 2E 6F 72 67 2F 70 72 6F 6A 65 63 74  |ject.org/project|
00000080  73 2F 74 6F 72 62 72 6F 77 73 65 72 2E 68 74 6D  |s/torbrowser.htm|
00000090  6C 2E 65 6E 08 0B 5B 00 00 00 00 00 00 01 01 00  |l.en..[.........|
000000A0  00 00 00 00 00 00 03 00 00 00 00 00 00 00 00 00  |................|
000000B0  00 00 00 00 00 00 94                             |.......|
000000b7
com.apple.quarantine: 0081;58519ffa;Google Chrome.app;1F032CAB-F5A1-4D92-84EB-CBECA971B7BC
```

可以使用 `-d` 指令标志移除原数据属性:

```
$ xattr -d com.apple.metadata:kMDItemWhereFroms ~/Downloads/TorBrowser-6.0.5-osx64_en-US.dmg

$ xattr -d com.apple.quarantine ~/Downloads/TorBrowser-6.0.5-osx64_en-US.dmg

$ xattr -l ~/Downloads/TorBrowser-6.0.5-osx64_en-US.dmg
[No output after removal.]
```

## 密码

你可以使用 OpenSSL 生成强密码：

    $ openssl rand -base64 30
    LK9xkjUEAemc1gV2Ux5xqku+PDmMmCbSTmwfiMRI

或者 GPG：

    $ gpg --gen-random -a 0 30
    4/bGZL+yUEe8fOqQhF5V01HpGwFSpUPwFcU3aOWQ

或 `/dev/urandom` 输出：

    $ dd if=/dev/urandom bs=1 count=30 2>/dev/null | base64
    CbRGKASFI4eTa96NMrgyamj8dLZdFYBaqtWUSxKe

还可以控制字符集：

    $ LANG=C tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 40 | head -n 1
    jm0iKn7ngQST8I0mMMCbbi6SKPcoUWwCb5lWEjxK

    $ LANG=C tr -dc 'DrDuh0-9' < /dev/urandom | fold -w 40 | head -n 1
    686672u2Dh7r754209uD312hhh23uD7u41h3875D

你也可以用 **Keychain Access（钥匙串访问）**生成一个令人难忘的密码，或者用 [anders/pwgen](https://github.com/anders/pwgen) 这样的命令行生成。

钥匙串使用 [PBKDF2 派生密钥](https://en.wikipedia.org/wiki/PBKDF2)加密，是个**非常安全**存储凭据的地方。看看 [Breaking into the OS X keychain](http://juusosalonen.com/post/30923743427/breaking-into-the-os-x-keychain)。还要注意钥匙串[不加密](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/118)的密码对应密码输入的名称。

或者，可以自己用 GnuPG (基于 [drduh/pwd.sh](https://github.com/drduh/pwd.sh) 密码管理脚本的一个插件)管理一个加密的密码文件。

除密码外，确保像 GitHub、 Google 账号、银行账户这些网上的账户，开启[两步验证](https://en.wikipedia.org/wiki/Two-factor_authentication)。

看看 [Yubikey](https://www.yubico.com/products/yubikey-hardware/yubikey-neo/) 的两因素和私钥(如：ssh、gpg)硬件令牌。 阅读 [drduh/YubiKey-Guide](https://github.com/drduh/YubiKey-Guide) 和 [trmm.net/Yubikey](https://trmm.net/Yubikey)。两个 Yubikey 的插槽之一可以通过编程来生成一个长的静态密码（例如可以与短的，记住的密码结合使用）。

## 备份

备份到外部介质或在线服务之前，总是先对本地文件进行加密。

一种方法是使用 GPG 对称加密，你选择一个密码。

加密一个文件夹:

    $ tar zcvf - ~/Downloads | gpg -c > ~/Desktop/backup-$(date +%F-%H%M).tar.gz.gpg

解密文档:

    $ gpg -o ~/Desktop/decrypted-backup.tar.gz -d ~/Desktop/backup-2015-01-01-0000.tar.gz.gpg && \
      tar zxvf ~/Desktop/decrypted-backup.tar.gz

你也可以用 **Disk Utility** 或 `hdiutil` 创建加密卷：

    $ hdiutil create ~/Desktop/encrypted.dmg -encryption -size 1g -volname "Name" -fs JHFS+

也可以考虑使用下面的应用和服务：[SpiderOak](https://spideroak.com/)、[Arq](https://www.arqbackup.com/)、[Espionage](https://www.espionageapp.com/) 和 [restic](https://restic.github.io/)。

## Wi-Fi

macOS 会记住它连接过的接入点。比如所有无线设备，每次搜寻网络的时候，Mac 将会显示所有它记住的接入点名称（如 *MyHomeNetwork*） ，比如每次从休眠状态唤醒设备的时候。

这就有泄漏隐私的风险，所以当不再需要的时候最好从列表中移除这些连接过的网络， 在 **System Preferences** > **Network** > **Advanced** 。

看看 [Signals from the Crowd: Uncovering Social Relationships through Smartphone Probes](http://conferences.sigcomm.org/imc/2013/papers/imc148-barberaSP106.pdf) (pdf) 和 [Wi-Fi told me everything about you](http://confiance-numerique.clermont-universite.fr/Slides/M-Cunche-2014.pdf) (pdf)。

保存的 Wi-Fi 信息 (SSID、最后一次连接等)可以在 `/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist` 中找到。

你可能希望在连接到新的和不可信的无线网络之前[伪造网卡 MAC 地址](https://en.wikipedia.org/wiki/MAC_spoofing)，以减少被动特征探测：

    $ sudo ifconfig en0 ether $(openssl rand -hex 6 | sed 's%\(..\)%\1:%g; s%.$%%')

**注意**每次启动，MAC 地址将重置为硬件默认地址。

了解下 [feross/SpoofMAC](https://github.com/feross/SpoofMAC).

最后，WEP 保护在无线网络是[不安全](http://www.howtogeek.com/167783/htg-explains-the-difference-between-wep-wpa-and-wpa2-wireless-encryption-and-why-it-matters/)的，你应该尽量选择连接 **WPA2** 保护网络，可以减少被窃听的风险。

## SSH

对于向外的 ssh 连接，使用硬件或密码保护的秘钥，[设置](http://nerderati.com/2011/03/17/simplify-your-life-with-an-ssh-config-file/)远程 hosts 并考虑对它们进行[哈希](http://nms.csail.mit.edu/projects/ssh/)，以增强安全性。

将这几个[配置项](https://www.freebsd.org/cgi/man.cgi?query=ssh_config&sektion=5)加到 `~/.ssh/config`:

    Host *
      PasswordAuthentication no
      ChallengeResponseAuthentication no
      HashKnownHosts yes

**注意** [macOS Sierra 默认永久记住 SSH 秘钥密码](https://openradar.appspot.com/28394826)。添加配置 `UseKeyChain no` 来关闭这项功能。

你也可以用 ssh 创建一个[加密隧道](http://blog.trackets.com/2014/05/17/ssh-tunnel-local-and-remote-port-forwarding-explained-with-examples.html)来发送数据，这有点类似于 VPN。

例如，在一个远程主机上使用 Privoxy：

    $ ssh -C -L 5555:127.0.0.1:8118 you@remote-host.tld

    $ sudo networksetup -setwebproxy "Wi-Fi" 127.0.0.1 5555

    $ sudo networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 5555

或者使用 ssh 连接作为 [SOCKS 代理](https://www.mikeash.com/ssh_socks.html)：

    $ ssh -NCD 3000 you@remote-host.tld

默认情况下， macOS **没有** sshd ，也不允许**远程登陆**。

启用 sshd 且允许进入的 ssh 连接：

    $ sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

或者设置 **System Preferences** > **Sharing** 菜单。

如果你准备使用 sshd，至少禁用密码身份验证并考虑进一步[强化](https://stribika.github.io/2015/01/04/secure-secure-shell.html)配置。

找到 `/etc/sshd_config`，添加：

```
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
```

确认 sshd 是否启用:

    $ sudo lsof -Pni TCP:22

## 物理访问

时刻保证 Mac 物理安全。不要将 Mac 留在无人照看的酒店之类的地方。

有一种攻击就是通过物理访问，通过注入引导 ROM 来安装键盘记录器，偷走你的密码。看看这个案例 [Thunderstrike](https://trmm.net/Thunderstrike)。

有个工具 [usbkill](https://github.com/hephaest0s/usbkill) 可以帮助你，这是**"一个反监视断路开关，一旦发现 USB 端口发生改变就会关闭你的计算机"**。

考虑购买屏幕[隐私过滤器](https://www.amazon.com/s/ref=nb_sb_noss_2?url=node%3D15782001&field-keywords=macbook)防止别人偷瞄。


## 系统监控

#### OpenBSM 监测

macOS 具有强大的 OpenBSM 审计功能。你可以使用它来监视进程执行、网络活动等等。

跟踪监测日志，使用 `praudit` 工具：

```
$ sudo praudit -l /dev/auditpipe
header,201,11,execve(2),0,Thu Sep  1 12:00:00 2015, + 195 msec,exec arg,/Applications/.evilapp/rootkit,path,/Applications/.evilapp/rootkit,path,/Applications/.evilapp/rootkit,attribute,100755,root,wheel,16777220,986535,0,subject,drduh,root,wheel,root,wheel,412,100005,50511731,0.0.0.0,return,success,0,trailer,201,
header,88,11,connect(2),0,Thu Sep  1 12:00:00 2015, + 238 msec,argument,1,0x5,fd,socket-inet,2,443,173.194.74.104,subject,drduh,root,wheel,root,wheel,326,100005,50331650,0.0.0.0,return,failure : Operation now in progress,4354967105,trailer,88
header,111,11,OpenSSH login,0,Thu Sep  1 12:00:00 2015, + 16 msec,subject_ex,drduh,drduh,staff,drduh,staff,404,404,49271,::1,text,successful login drduh,return,success,0,trailer,111,
```

看看 `audit`、`praudit`、`audit_control` 的操作手册，其它文件在 `/etc/security`目录下。

**注意**虽然 `audit 手册` 上说 `-s` 标签会立即同步到配置中，实际上需要重启才能生效。

更多信息请看 [ilostmynotes.blogspot.com](http://ilostmynotes.blogspot.com/2013/10/openbsm-auditd-on-os-x-these-are-logs.html) 和 [derflounder.wordpress.com](https://derflounder.wordpress.com/2012/01/30/openbsm-auditing-on-mac-os-x/) 上的文章。

#### DTrace

`iosnoop` 监控磁盘 I/O

`opensnoop` 监控文件打开

`execsnoop` 监控进程执行

`errinfo` 监控失败的系统调用

`dtruss` 监控所有系统调用

运行命令 `man -k dtrace` 去了解更多信息。

**注意**[系统完整性保护](https://github.com/drduh/OS-X-Security-and-Privacy-Guide#system-integrity-protection)和 DTrace [冲突](http://internals.exposed/blog/dtrace-vs-sip.html)，所以这些工具可能用不上了。

#### 运行

`ps -ef` 列出所有正在运行的进程。

你也可以通过**活动监视器**来查看进程。

`launchctl list` 和 `sudo launchctl list` 分别列出用户运行和加载的程序、系统启动守护程序和代理。

#### 网络

列出公开网络文件：

    $ sudo lsof -Pni

列出各种网络相关的数据结构的内容：

    $ sudo netstat -atln

你也可以通过命令行使用 [Wireshark](https://www.wireshark.org/)。

监控 DNS 查询和响应：

```
$ tshark -Y "dns.flags.response == 1" -Tfields \
  -e frame.time_delta \
  -e dns.qry.name \
  -e dns.a \
  -Eseparator=,
```

监控 HTTP 请求和响应：

```
$ tshark -Y "http.request or http.response" -Tfields \
  -e ip.dst \
  -e http.request.full_uri \
  -e http.request.method \
  -e http.response.code \
  -e http.response.phrase \
  -Eseparator=/s
```

监控 x509 证书：

```
$ tshark -Y "ssl.handshake.certificate" -Tfields \
  -e ip.src \
  -e x509sat.uTF8String \
  -e x509sat.printableString \
  -e x509sat.universalString \
  -e x509sat.IA5String \
  -e x509sat.teletexString \
  -Eseparator=/s -Equote=d
```

也可以考虑简单的网络监控程序 [BonzaiThePenguin/Loading](https://github.com/BonzaiThePenguin/Loading)。

## 二进制白名单

[google/santa](https://github.com/google/santa/) 是一款为 Google 公司 Macintosh 团队开发的一款安全软件，而且是开源的。

> Santa 是 macOS 上一个二进制白名单/黑名单系统。它由多个部分组成，一个是监控执行程序的内核扩展，基于 SQLite 数据库内容进行执行决策的用户级守护进程，决定拦截的情况下通知用户的一个 GUI 代理，以及用于管理系统和数据库同步服务的命令行实用程序。

Santa 使用[内核授权 API](https://developer.apple.com/library/content/technotes/tn2127/_index.html) 来监视和允许/禁止在内核中执行二进制文件。二进制文件可以是经过唯一哈希或开发者证书签名的白/黑名单。Santa 可以用来只允许执行可信代码，或者阻止黑名单中已知恶意软件在 Mac 上运行，和 Windows 软件 Bit9 类似。

**注意** Santa 目前还没有管理规则的用户图形界面。下面的教程是为高级用户准备的！

安装 Santa，先访问[发布](https://github.com/google/santa/releases)页面，下载最新的磁盘镜像，挂载然后安装相关软件包：

```
$ hdiutil mount ~/Downloads/santa-0.9.14.dmg

$ sudo installer -pkg /Volumes/santa-0.9.14/santa-0.9.14.pkg -tgt /
```

Santa 默认安装为 "Monitor" 模式 (不拦截，只记录)，有两个规则：一条是为了 Apple 二进制，另一条是为了 Santa 软件本身。

验证 Santa 是否在运行，内核模块是否加载：

```
$ santactl status
>>> Daemon Info
  Mode                   | Monitor
  File Logging           | No
  Watchdog CPU Events    | 0  (Peak: 0.00%)
  Watchdog RAM Events    | 0  (Peak: 0.00MB)
>>> Kernel Info
  Kernel cache count     | 0
>>> Database Info
  Binary Rules           | 0
  Certificate Rules      | 2
  Events Pending Upload  | 0

$ ps -ef | grep "[s]anta"
    0   786     1   0 10:01AM ??         0:00.39 /Library/Extensions/santa-driver.kext/Contents/MacOS/santad --syslog

$ kextstat | grep santa
  119    0 0xffffff7f822ff000 0x6000     0x6000     com.google.santa-driver (0.9.14) 693D8E4D-3161-30E0-B83D-66A273CAE026 <5 4 3 1>
```

创建一个黑名单规则来阻止 iTunes 运行：

    $ sudo santactl rule --blacklist --path /Applications/iTunes.app/
    Added rule for SHA-256: e1365b51d2cb2c8562e7f1de36bfb3d5248de586f40b23a2ed641af2072225b3.

试试打开 iTunes ，它会被阻止运行。

    $ open /Applications/iTunes.app/
    LSOpenURLsWithRole() failed with error -10810 for the file /Applications/iTunes.app.

<img width="450" alt="Santa block dialog when attempting to run a blacklisted program" src="https://cloud.githubusercontent.com/assets/12475110/21062284/14ddde88-be1e-11e6-8e9b-32f8a44c0cf6.png">

移除规则：

    $ sudo santactl rule --remove --path /Applications/iTunes.app/
    Removed rule for SHA-256: e1365b51d2cb2c8562e7f1de36bfb3d5248de586f40b23a2ed641af2072225b3.

打开 iTunes：

    $ open /Applications/iTunes.app/
    [iTunes will open successfully]

创建一个新的 C 语言小程序：

```
$ cat <<EOF > foo.c
> #include <stdio.h>
> main() { printf("Hello World\n”); }
> EOF
```

用 GCC 编译该程序（需要安装 Xcode 或者命令行工具）：

```
$ gcc -o foo foo.c

$ file foo
foo: Mach-O 64-bit executable x86_64

$ codesign -d foo
foo: code object is not signed at all
```

运行它：

```
$ ./foo
Hello World
```

将 Santa 切换为 “Lockdown” 模式，这种情况下只允许白名单内二进制程序运行：

    $ sudo defaults write /var/db/santa/config.plist ClientMode -int 2

试试运行未签名的二进制：

```
$ ./foo
bash: ./foo: Operation not permitted

Santa

The following application has been blocked from executing
because its trustworthiness cannot be determined.

Path:       /Users/demouser/foo
Identifier: 4e11da26feb48231d6e90b10c169b0f8ae1080f36c168ffe53b1616f7505baed
Parent:     bash (701)
```
想要在白名单中添加一个指定的二进制，确定其 SHA-256 值：

```
$ santactl fileinfo /Users/demouser/foo
Path                 : /Users/demouser/foo
SHA-256              : 4e11da26feb48231d6e90b10c169b0f8ae1080f36c168ffe53b1616f7505baed
SHA-1                : 4506f3a8c0a5abe4cacb98e6267549a4d8734d82
Type                 : Executable (x86-64)
Code-signed          : No
Rule                 : Blacklisted (Unknown)
```

增加一条白名单规则：

    $ sudo santactl rule --whitelist --sha256 4e11da26feb48231d6e90b10c169b0f8ae1080f36c168ffe53b1616f7505baed
    Added rule for SHA-256: 4e11da26feb48231d6e90b10c169b0f8ae1080f36c168ffe53b1616f7505baed.

运行它：

```
$ ./foo
Hello World
```

小程序没有被阻止，它成功的运行了。

应用程序也可以通过开发者签名来加到白名单中（这样每次更新应用程序的时候，新版本的二进制文件就不用手动加到白名单中了）。例如，下载运行 Google Chrome ，  在 "Lockdown" 模式下 Santa 会阻止它运行：

```
$ curl -sO https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg

$ hdiutil mount googlechrome.dmg

$ cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/

$ open /Applications/Google\ Chrome.app/
LSOpenURLsWithRole() failed with error -10810 for the file /Applications/Google Chrome.app.
```

通过它自己的开发者签名将应用加到白名单中（Signing Chain 中第一项）：

```
$ santactl fileinfo /Applications/Google\ Chrome.app/
Path                 : /Applications/Google Chrome.app/Contents/MacOS/Google Chrome
SHA-256              : 0eb08224d427fb1d87d2276d911bbb6c4326ec9f74448a4d9a3cfce0c3413810
SHA-1                : 9213cbc7dfaaf7580f3936a915faa56d40479f6a
Bundle Name          : Google Chrome
Bundle Version       : 2883.87
Bundle Version Str   : 55.0.2883.87
Type                 : Executable (x86-64)
Code-signed          : Yes
Rule                 : Blacklisted (Unknown)
Signing Chain:
     1. SHA-256             : 15b8ce88e10f04c88a5542234fbdfc1487e9c2f64058a05027c7c34fc4201153
        SHA-1               : 85cee8254216185620ddc8851c7a9fc4dfe120ef
        Common Name         : Developer ID Application: Google Inc.
        Organization        : Google Inc.
        Organizational Unit : EQHXZ8M8AV
        Valid From          : 2012/04/26 07:10:10 -0700
        Valid Until         : 2017/04/27 07:10:10 -0700

     2. SHA-256             : 7afc9d01a62f03a2de9637936d4afe68090d2de18d03f29c88cfb0b1ba63587f
        SHA-1               : 3b166c3b7dc4b751c9fe2afab9135641e388e186
        Common Name         : Developer ID Certification Authority
        Organization        : Apple Inc.
        Organizational Unit : Apple Certification Authority
        Valid From          : 2012/02/01 14:12:15 -0800
        Valid Until         : 2027/02/01 14:12:15 -0800

     3. SHA-256             : b0b1730ecbc7ff4505142c49f1295e6eda6bcaed7e2c68c5be91b5a11001f024
        SHA-1               : 611e5b662c593a08ff58d14ae22452d198df6c60
        Common Name         : Apple Root CA
        Organization        : Apple Inc.
        Organizational Unit : Apple Certification Authority
        Valid From          : 2006/04/25 14:40:36 -0700
        Valid Until         : 2035/02/09 13:40:36 -0800
```

这个例子中， `15b8ce88e10f04c88a5542234fbdfc1487e9c2f64058a05027c7c34fc4201153` 是 Google’s Apple 开发者证书的 SHA-256 (team ID EQHXZ8M8AV)。 将它加到白名单中：

```
$ sudo santactl rule --whitelist --certificate --sha256 15b8ce88e10f04c88a5542234fbdfc1487e9c2f64058a05027c7c34fc4201153
Added rule for SHA-256: 15b8ce88e10f04c88a5542234fbdfc1487e9c2f64058a05027c7c34fc4201153.
```

Google Chrome 现在应该可以启动了，以后的更新也不会被阻止，除非签名证书修改了或过期了。

关闭 “Lockdown” 模式：

    $ sudo defaults delete /var/db/santa/config.plist ClientMode

在 `/var/log/santa.log` 可以查看监控器**允许**和**拒绝**执行的决策记录。

**注意** Python、Bash 和其它解释性语言是在白名单中的（因为它们是由苹果开发者证书签名的），所以 Santa 不会阻止这些脚本的运行。因此，要注意到 Santa 可能无法有效的拦截非二进制程序运行（这不算漏洞，因为它本身就这么设计的）。

## 其它

如果你想的话，禁用[诊断与用量](https://github.com/fix-macosx/fix-macosx/wiki/Diagnostics-&-Usage-Data).

如果你想播放**音乐**或看**视频**，使用 [VLC 播放器](https://www.videolan.org/vlc/index.html)，这是免费且开源的。

如果你想用 **torrents**， 使用免费、开源的 [Transmission](http://www.transmissionbt.com/download/)（注意：所有软件都一样，即使是开源项目，[恶意软件还是可能找到破解的方式](http://researchcenter.paloaltonetworks.com/2016/03/new-os-x-ransomware-keranger-infected-transmission-bittorrent-client-installer/)）。你可能希望使用一个块列表来避免和那些已知的坏主机配对，了解下 [Transmission 上最好的块列表](https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/) 和 [johntyree/3331662](https://gist.github.com/johntyree/3331662)。

用 [duti](http://duti.org/) 管理默认文件处理，可以通过 `brew install duti` 来安装。管理扩展的原因之一是为了防止远程文件系统在 Finder 中自动挂载。 ([保护自己免受 Sparkle 后门影响](https://www.taoeffect.com/blog/2016/02/apologies-sky-kinda-falling-protecting-yourself-from-sparklegate/))。这里有几个推荐的管理指令：

```
$ duti -s com.apple.Safari afp

$ duti -s com.apple.Safari ftp

$ duti -s com.apple.Safari nfs

$ duti -s com.apple.Safari smb
```

使用**控制台**应用程序来监控系统日志，也可以用 `syslog -w` 或 `log stream` 命令。

在 macOS Sierra (10.12) 之前的系统，在 `/etc/sudoers`启用 [tty_tickets flag](https://derflounder.wordpress.com/2016/09/21/tty_tickets-option-now-on-by-default-for-macos-sierras-sudo-tool/) 来阻止 sudo 会话在其它终端生效。使用命令 `sudo visudo` 然后添加一行 `Defaults    tty_tickets` 就可以了。

设置进入休眠状态时马上启动屏幕保护程序：

    $ defaults write com.apple.screensaver askForPassword -int 1

    $ defaults write com.apple.screensaver askForPasswordDelay -int 0

在 Finder 中显示隐藏文件和文件夹：

    $ defaults write com.apple.finder AppleShowAllFiles -bool true

    $ chflags nohidden ~/Library

显示所有文件扩展名（这样 "Evil.jpg.app" 就无法轻易伪装了）。

    $ defaults write NSGlobalDomain AppleShowAllExtensions -bool true

不要默认将文档保存到 iCloud：

    $ defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

在终端启用[安全键盘输入](https://security.stackexchange.com/questions/47749/how-secure-is-secure-keyboard-entry-in-mac-os-xs-terminal)（除非你用 [YubiKey](https://mig5.net/content/secure-keyboard-entry-os-x-blocks-interaction-yubikeys) 或者像 [TextExpander](https://smilesoftware.com/textexpander/secureinput) 这样的程序）。

禁用崩溃报告（就是那个在程序崩溃后，会出现提示将问题报告给苹果的提示框）：

    $ defaults write com.apple.CrashReporter DialogType none

禁用 Bonjour [多播广告](https://www.trustwave.com/Resources/SpiderLabs-Blog/mDNS---Telling-the-world-about-you-(and-your-device)/):

    $ sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool YES

如果用不上的话，[禁用 Handoff](https://apple.stackexchange.com/questions/151481/why-is-my-macbook-visibile-on-bluetooth-after-yosemite-install) 和蓝牙功能。

考虑 [sandboxing](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/sandbox-exec.1.html) 你的应用程序。 了解下 [fG! Sandbox Guide](https://reverse.put.as/wp-content/uploads/2011/09/Apple-Sandbox-Guide-v0.1.pdf) (pdf) 和 [s7ephen/OSX-Sandbox--Seatbelt--Profiles](https://github.com/s7ephen/OSX-Sandbox--Seatbelt--Profiles)。

你知道苹果公司自 [2006](http://osxbook.com/book/bonus/chapter10/tpm/) 后就不再出售带 TPM 的电脑了吗？

## 相关软件

[Santa](https://github.com/google/santa/) - macOS 上一个带二进制白名单/黑名单监控系统的软件。

[kristovatlas/osx-config-check](https://github.com/kristovatlas/osx-config-check) - 检查你的 OSX 设备各种硬件配置设置。

[Lockdown](https://objective-see.com/products/lockdown.html) - 审查和修正安全配置。

[Dylib Hijack Scanner](https://objective-see.com/products/dhs.html) - 扫描那些容易被劫持或已经被黑的应用。

[Little Flocker](https://www.littleflocker.com/) - "Little Snitch for files"， 防止应用程序访问文件。

[facebook/osquery](https://github.com/facebook/osquery) - 可以检索系统底层信息。用户可以编写 SQL 来查询系统信息。

[google/grr](https://github.com/google/grr) - 事件响应框架侧重于远程现场取证。

[yelp/osxcollector](https://github.com/yelp/osxcollector) - 证据收集 & OS X 分析工具包。

[jipegit/OSXAuditor](https://github.com/jipegit/OSXAuditor) - 分析运行系统时的部件，比如隔离的文件， Safari、 Chrome 和 Firefox 历史记录， 下载，HTML5 数据库和本地存储、社交媒体、电子邮件帐户、和 Wi-Fi 接入点的名称。

[libyal/libfvde](https://github.com/libyal/libfvde) - 访问 FileVault Drive Encryption (FVDE) (或 FileVault2) 加密卷的库。

[CISOfy/lynis](https://github.com/CISOfy/lynis) - 跨平台安全审计工具，并协助合规性测试和系统强化。

## 其它资源

**排名不分先后**

[MacOS Hardening Guide - Appendix of \*OS Internals: Volume III - Security & Insecurity Internals](http://newosxbook.com/files/moxii3/AppendixA.pdf) (pdf)

[Mac Developer Library: Secure Coding Guide](https://developer.apple.com/library/mac/documentation/Security/Conceptual/SecureCodingGuide/Introduction.html)

[OS X Core Technologies Overview White Paper](https://www.apple.com/osx/all-features/pdf/osx_elcapitan_core_technologies_overview.pdf) (pdf)

[Reverse Engineering Mac OS X blog](https://reverse.put.as/)

[Reverse Engineering Resources](http://samdmarshall.com/re.html)

[Patrick Wardle's Objective-See blog](https://objective-see.com/blog.html)

[Managing Macs at Google Scale (LISA '13)](https://www.usenix.org/conference/lisa13/managing-macs-google-scale)

[OS X Hardening: Securing a Large Global Mac Fleet (LISA '13)](https://www.usenix.org/conference/lisa13/os-x-hardening-securing-large-global-mac-fleet)

[DoD Security Technical Implementation Guides for Mac OS](http://iase.disa.mil/stigs/os/mac/Pages/mac-os.aspx)

[The EFI boot process](http://homepage.ntlworld.com/jonathan.deboynepollard/FGA/efi-boot-process.html)

[The Intel Mac boot process](http://refit.sourceforge.net/info/boot_process.html)

[Userland Persistence on Mac OS X](https://archive.org/details/joshpitts_shmoocon2015)

[Developing Mac OSX kernel rootkits](http://phrack.org/issues/66/16.html#article)

[IOKit kernel code execution exploit](https://code.google.com/p/google-security-research/issues/detail?id=135)

[Hidden backdoor API to root privileges in Apple OS X](https://truesecdev.wordpress.com/2015/04/09/hidden-backdoor-api-to-root-privileges-in-apple-os-x/)

[IPv6 Hardening Guide for OS X](http://www.insinuator.net/2015/02/ipv6-hardening-guide-for-os-x/)

[Harden the World: Mac OSX 10.11 El Capitan](http://docs.hardentheworld.org/OS/OSX_10.11_El_Capitan/)

[Hacker News discussion](https://news.ycombinator.com/item?id=10148077)

[Hacker News discussion 2](https://news.ycombinator.com/item?id=13023823)

[Apple Open Source](https://opensource.apple.com/)

[OS X 10.10 Yosemite: The Ars Technica Review](http://arstechnica.com/apple/2014/10/os-x-10-10/)

[CIS Apple OSX 10.10 Benchmark](https://benchmarks.cisecurity.org/tools2/osx/CIS_Apple_OSX_10.10_Benchmark_v1.1.0.pdf) (pdf)

[How to Switch to the Mac](https://taoofmac.com/space/HOWTO/Switch)

[Security Configuration For Mac OS X Version 10.6 Snow Leopard](http://www.apple.com/support/security/guides/docs/SnowLeopard_Security_Config_v10.6.pdf) (pdf)

[EFF Surveillance Self-Defense Guide](https://ssd.eff.org/)

[MacAdmins on Slack](https://macadmins.herokuapp.com/)

[iCloud security and privacy overview](http://support.apple.com/kb/HT4865)

[Demystifying the DMG File Format](http://newosxbook.com/DMG.html)

[There's a lot of vulnerable OS X applications out there (Sparkle Framework RCE)](https://vulnsec.com/2016/osx-apps-vulnerabilities/)

[iSeeYou: Disabling the MacBook Webcam Indicator LED](https://jscholarship.library.jhu.edu/handle/1774.2/36569)

[Mac OS X Forensics - Technical Report](https://www.ma.rhul.ac.uk/static/techrep/2015/RHUL-MA-2015-8.pdf) (pdf)

[Mac Forensics: Mac OS X and the HFS+ File System](https://cet4861.pbworks.com/w/file/fetch/71245694/mac.forensics.craiger-burke.IFIP.06.pdf) (pdf)

[Extracting FileVault 2 Keys with Volatility](https://tribalchicken.com.au/security/extracting-filevault-2-keys-with-volatility/)

[Auditing and Exploiting Apple IPC](https://googleprojectzero.blogspot.com/2015/09/revisiting-apple-ipc-1-distributed_28.html)

[Mac OS X and iOS Internals: To the Apple's Core by Jonathan Levin](https://www.amazon.com/Mac-OS-iOS-Internals-Apples/dp/1118057651)

[Demystifying the i-Device NVMe NAND (New storage used by Apple)](http://ramtin-amin.fr/#nvmepcie)
