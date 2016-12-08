> * 原文地址：[macOS Security and Privacy Guide](https://github.com/drduh/macOS-Security-and-Privacy-Guide)
* 原文作者：[drduh](https://github.com/drduh)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# macOS Security and Privacy Guide

This is a collection of thoughts on securing a modern Apple Mac computer using macOS (formerly *"OS X"*) 10.12 "Sierra", as well as steps to improving online privacy.

This guide is targeted to “power users” who wish to adopt enterprise-standard security, but is also suitable for novice users with an interest in improving their privacy and security on a Mac.

There is no security silver bullet. A system is only as secure as its administrator is capable of making it.

I am **not** responsible if you break a Mac by following any of these steps.

If you wish to make a correction or improvement, please send a pull request or [open an issue](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues).

- [Basics](#basics)
- [Firmware](#firmware)
- [Preparing and Installing macOS](#preparing-and-installing-macos)
    - [Virtualization](#virtualization)
- [First boot](#first-boot)
- [Admin and standard user accounts](#admin-and-standard-user-accounts)
- [Full disk encryption](#full-disk-encryption)
- [Firewall](#firewall)
    - [Application layer firewall](#application-layer-firewall)
    - [Third party firewalls](#third-party-firewalls)
    - [Kernel level packet filtering](#kernel-level-packet-filtering)
- [Services](#services)
- [Spotlight Suggestions](#spotlight-suggestions)
- [Homebrew](#homebrew)
- [DNS](#dns)
    - [Hosts file](#hosts-file)
    - [Dnsmasq](#dnsmasq)
      - [Test DNSSEC validation](#test-dnssec-validation)
    - [DNSCrypt](#dnscrypt)
- [Captive portal](#captive-portal)
- [Certificate authorities](#certificate-authorities)
- [OpenSSL](#openssl)
- [Curl](#curl)
- [Web](#web)
    - [Privoxy](#privoxy)
    - [Browser](#browser)
    - [Plugins](#plugins)
- [PGP/GPG](#pgpgpg)
- [OTR](#otr)
- [Tor](#tor)
- [VPN](#vpn)
- [Viruses and malware](#viruses-and-malware)
- [System Integrity Protection](#system-integrity-protection)
- [Gatekeeper and XProtect](#gatekeeper-and-xprotect)
- [Passwords](#passwords)
- [Backup](#backup)
- [Wi-Fi](#wi-fi)
- [SSH](#ssh)
- [Physical access](#physical-access)
- [System monitoring](#system-monitoring)
    - [OpenBSM audit](#openbsm-audit)
    - [DTrace](#dtrace)
    - [Execution](#execution)
    - [Network](#network)
- [Miscellaneous](#miscellaneous)
- [Related software](#related-software)
- [Additional resources](#additional-resources)

## Basics

The standard best security practices apply:

* Create a threat model
	* What are you trying to protect and from whom? Is your adversary a [three letter agency](https://theintercept.com/document/2015/03/10/strawhorse-attacking-macos-ios-software-development-kit/) (if so, you may want to consider using [OpenBSD](http://www.openbsd.org/) instead), a nosy eavesdropper on the network, or determined [apt](https://en.wikipedia.org/wiki/Advanced_persistent_threat) orchestrating a campaign against you?
	* Study and recognize threats and how to reduce attack surface.

* Keep the system up to date
	* Patch, patch, patch your system and software.
	* Subscribe to announcement mailing lists (e.g., [Apple security-announce](https://lists.apple.com/mailman/listinfo/security-announce)) for programs you use often.

* Encrypt sensitive data
	* In addition to full disk encryption, create one or many encrypted containers to store passwords, keys and personal documents.
	* This will mitigate damage in case of compromise and data exfiltration.

* Frequent backups
	* Create regular backups of your data and be ready to reimage in case of compromise.
	* Always encrypt before copying backups to external media or the "cloud".

* Click carefully
	* Ultimately, the security of a system can be reduced to its administrator.
	* Care should be taken when installing new software. Always prefer [free](https://www.gnu.org/philosophy/free-sw.en.html) and open source software ([which macOS is not](https://superuser.com/questions/19492/is-mac-os-x-open-source)).

## Firmware

Setting a firmware password prevents your Mac from starting up from any device other than your startup disk. It may also be set to be required on each boot.

This feature [can be helpful if your laptop is stolen](https://www.ftc.gov/news-events/blogs/techftc/2015/08/virtues-strong-enduser-device-controls), as the only way to reset the firmware password is through an Apple Store, or by using an [SPI programmer](https://reverse.put.as/2016/06/25/apple-efi-firmware-passwords-and-the-scbo-myth/), such as [Bus Pirate](http://ho.ax/posts/2012/06/unbricking-a-macbook/) or other flash IC programmer.

1. Start up pressing `Command` `R` keys to boot to [Recovery Mode](https://support.apple.com/en-au/HT201314) mode.

3. When the Recovery window appears, choose **Firmware Password Utility** from the Utilities menu.

4. In the Firmware Utility window that appears, select **Turn On Firmware Password**.

5. Enter a new password, then enter the same password in the **Verify** field.

6. Select **Set Password**.

7. Select **Quit Firmware Utility** to close the Firmware Password Utility.

8. Select the Apple menu and choose Restart or Shutdown.

The firmware password will activate at next boot. To validate the password, hold `Alt` during boot - you should be prompted to enter the password.

The firmware password can also be managed with the `firmwarepasswd` utility while booted into the OS.

<img width="750" alt="Using a Dediprog SF600 to dump and flash a 2013 MacBook SPI Flash chip to remove a firmware password, sans Apple" src="https://cloud.githubusercontent.com/assets/12475110/17075918/0f851c0c-50e7-11e6-904d-0b56cf0080c1.png">

*Using a [Dediprog SF600](http://www.dediprog.com/pd/spi-flash-solution/sf600) to dump and flash a 2013 MacBook SPI Flash chip to remove a firmware password, sans Apple*

See [HT204455](https://support.apple.com/en-au/HT204455), [LongSoft/UEFITool](https://github.com/LongSoft/UEFITool) and [chipsec/chipsec](https://github.com/chipsec/chipsec) for more information.

## Preparing and Installing macOS

There are several ways to install a fresh copy of macOS.

The simplest way is to boot into [Recovery Mode](https://support.apple.com/en-us/HT201314) by holding `Command` `R` keys at boot. A system image can be downloaded and applied directly from Apple. However, this way exposes the serial number and other identifying information over the network in plaintext.

<img width="500" alt="PII is transmitted to Apple in plaintext when using macOS Recovery" src="https://cloud.githubusercontent.com/assets/12475110/20312189/8987c958-ab20-11e6-90fa-7fd7c8c1169e.png">

*Packet capture of an unencrypted HTTP conversation during macOS recovery*

Another way is to download **macOS Sierra** from the [App Store](https://itunes.apple.com/us/app/macos-sierra/id1127487414) or some other place and create a custom, installable system image.

The macOS Sierra installer application is [code signed](https://developer.apple.com/library/mac/documentation/Security/Conceptual/CodeSigningGuide/Procedures/Procedures.html#//apple_ref/doc/uid/TP40005929-CH4-SW6), which should be verified to make sure you received a legitimate copy, using the `codesign` command:

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

macOS installers can be made with the `createinstallmedia` utility included in `Install macOS Sierra.app/Contents/Resources/`. See [Create a bootable installer for OS X Yosemite](https://support.apple.com/en-us/HT201372), or run the utility without arguments to see how it works.

**Note** Apple's installer [does not appear to work](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/120) across OS versions. If you want to build a 10.12 image, for example, the following steps must be run on a 10.12 machine!

To create a **bootable USB macOS installer**, mount a USB drive, and erase and partition it, then use the `createinstallmedia` utility:

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

To create a custom, installable image which can be [restored](https://en.wikipedia.org/wiki/Apple_Software_Restore) to a Mac, you will need to find the file `InstallESD.dmg`, which is also inside `Install macOS Sierra.app`.

With Finder, right click on the app, select **Show Package Contents** and navigate to **Contents** > **SharedSupport** to find the file `InstallESD.dmg`.

You can [verify](https://support.apple.com/en-us/HT201259) the following cryptographic hashes to ensure you have the same copy with `openssl sha1 InstallESD.dmg` or `shasum -a 1 InstallESD.dmg` or `shasum -a 256 InstallESD.dmg` (in Finder, you can drag the file into a Terminal window to provide the full path).

See [InstallESD_Hashes.csv](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/blob/master/InstallESD_Hashes.csv) in this repository for a list of current and previous file hashes. You can also Google the cryptographic hashes to ensure the file is genuine and has not been tampered with.

To create the image, use [MagerValp/AutoDMG](https://github.com/MagerValp/AutoDMG), or to create it manually, mount and install the operating system to a temporary image:

    $ hdiutil attach -mountpoint /tmp/install_esd ./InstallESD.dmg

    $ hdiutil create -size 32g -type SPARSE -fs HFS+J -volname "macOS" -uid 0 -gid 80 -mode 1775 /tmp/output.sparseimage

    $ hdiutil attach -mountpoint /tmp/os -owners on /tmp/output.sparseimage

    $ sudo installer -pkg /tmp/install_esd/Packages/OSInstall.mpkg -tgt /tmp/os -verbose

This part will take a while, so be patient. You can `tail -F /var/log/install.log` in another Terminal window to check progress.

**(Optional)** Install additional software, such as [Wireshark](https://www.wireshark.org/download.html):

    $ hdiutil attach Wireshark\ 2.2.0\ Intel\ 64.dmg

    $ sudo installer -pkg /Volumes/Wireshark/Wireshark\ 2.2.0\ Intel\ 64.pkg -tgt /tmp/os

    $ hdiutil unmount /Volumes/Wireshark

See [MagerValp/AutoDMG/wiki/Packages-Suitable-for-Deployment](https://github.com/MagerValp/AutoDMG/wiki/Packages-Suitable-for-Deployment) for caveats and [chilcote/outset](https://github.com/chilcote/outset) to instead processes packages and scripts at first boot.

When you're done, detach, convert and verify the image:

    $ hdiutil detach /tmp/os

    $ hdiutil detach /tmp/install_esd

    $ hdiutil convert -format UDZO /tmp/output.sparseimage -o ~/sierra.dmg

    $ asr imagescan --source ~/sierra.dmg

Now `sierra.dmg` is ready to be applied to one or multiple Macs. One could futher customize the image to include premade users, applications, preferences, etc.

This image can be installed using another Mac in [Target Disk Mode](https://support.apple.com/en-us/HT201462) or from a bootable USB installer.

To use **Target Disk Mode**, boot up the Mac you wish to image while holding the `T` key and connect it to another Mac using a Firewire, Thunderbolt or USB-C cable.

If you don't have another Mac, boot to a USB installer, with `sierra.dmg` and other required files copied to it, by holding the *Option* key at boot.

Run `diskutil list` to identify the connected Mac's disk, usually `/dev/disk2`

**(Optional)** [Securely erase](https://www.backblaze.com/blog/securely-erase-mac-ssd/) the disk with a single pass (if previously FileVault-encrypted, the disk must first be unlocked and mounted as `/dev/disk3s2`):

    $ sudo diskutil secureErase freespace 1 /dev/disk3s2

Partition the disk to Journaled HFS+:

    $ sudo diskutil unmountDisk /dev/disk2

    $ sudo diskutil partitionDisk /dev/disk2 1 JHFS+ macOS 100%

Restore the image to the new volume:

    $ sudo asr restore --source ~/sierra.dmg --target /Volumes/macOS --erase --buffersize 4m

You can also use the **Disk Utility** application to erase the connected Mac's disk, then restore `sierra.dmg` to the newly created partition.

If you've followed these steps correctly, the target Mac should now have a new install of macOS Sierra.

If you want to transfer any files, copy them to a shared folder like `/Users/Shared` on the mounted disk image, e.g. `cp Xcode_8.0.dmg /Volumes/macOS/Users/Shared`

<img width="1280" alt="Finished restore install from USB recovery boot" src="https://cloud.githubusercontent.com/assets/12475110/14804078/f27293c8-0b2d-11e6-8e1f-0fb0ac2f1a4d.png">

*Finished restore install from USB recovery boot*

We're not done yet! Unless you have built the image with [AutoDMG](https://github.com/MagerValp/AutoDMG), or installed macOS to a second partition on your Mac, you will need to create a recovery partition (in order to use full disk encryption). You can do so using [MagerValp/Create-Recovery-Partition-Installer](https://github.com/MagerValp/Create-Recovery-Partition-Installer) or using the following manual steps:

Download the file [RecoveryHDUpdate.dmg](https://support.apple.com/downloads/DL1464/en_US/RecoveryHDUpdate.dmg).

```
RecoveryHDUpdate.dmg
SHA-256: f6a4f8ac25eaa6163aa33ac46d40f223f40e58ec0b6b9bf6ad96bdbfc771e12c
SHA-1:   1ac3b7059ae0fcb2877d22375121d4e6920ae5ba
```

Attach and expand the installer, then run it:

```
$ hdiutil attach RecoveryHDUpdate.dmg

$ pkgutil --expand /Volumes/Mac\ OS\ X\ Lion\ Recovery\ HD\ Update/RecoveryHDUpdate.pkg /tmp/recovery

$ hdiutil attach /tmp/recovery/RecoveryHDUpdate.pkg/RecoveryHDMeta.dmg

$ /tmp/recovery/RecoveryHDUpdate.pkg/Scripts/Tools/dmtest ensureRecoveryPartition /Volumes/macOS/ /Volumes/Recovery\ HD\ Update/BaseSystem.dmg 0 0 /Volumes/Recovery\ HD\ Update/BaseSystem.chunklist
```

Replace `/Volumes/macOS` with the path to the target disk mode-booted Mac as necessary.

This step will take several minutes. Run `diskutil list` again to make sure **Recovery HD** now exists on `/dev/disk2` or equivalent identifier.

Once you're done, eject the disk with `hdiutil unmount /Volumes/macOS` and power down the target disk mode-booted Mac.

### Virtualization

To install macOS as a virtual machine (vm) using [VMware Fusion](https://www.vmware.com/products/fusion.html), follow the instructions above to create an image. You will **not** need to download and create a recovery partition manually.

```
VMware-Fusion-8.5.2-4635224.dmg
SHA-256: f6c54b98c9788d1df94d470661eedff3e5d24ca4fb8962fac5eb5dc56de63b77
SHA-1:   37ec465673ab802a3f62388d119399cb94b05408
```

For the Installation Method, select *Install OS X from the recovery partition*. Customize any memory or CPU requirements and complete setup. The guest vm should boot into [Recovery Mode](https://support.apple.com/en-us/HT201314) by default.

In Recovery Mode, select a language, then Utilities > Terminal from the menubar.

In the guest vm, type `ifconfig | grep inet` - you should see a private address like `172.16.34.129`

On the host Mac, type `ifconfig | grep inet` - you should see a private gateway address like `172.16.34.1`

From the host Mac, serve the installable image to the guest vm by editing `/etc/apache2/httpd.conf` and adding the following line to the top (using the gateway address assigned to the host Mac and port 80):

    Listen 172.16.34.1:80

On the host Mac, link the image to the default Apache Web server directory:

	$ sudo ln ~/sierra.dmg /Library/WebServer/Documents

From the host Mac, start Apache in the foreground:

	$ sudo httpd -X

From the guest VM, install the disk image to the volume over the local network using `asr`:

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

When it's finished, stop the Apache Web server on the host Mac by pressing `Control` `C` at the `sudo httpd -X` window and remove the image copy with `sudo rm /Library/WebServer/Documents/sierra.dmg`

In the guest vm, select *Startup Disk* from the top-left corner Apple menu, select the hard drive and restart. You may wish to disable the Network Adapter in VMware for the initial guest vm boot.

Take and Restore from saved guest vm snapshots before and after attempting risky browsing, for example, or use a guest vm to install and operate questionable software.

## First boot

**Note** Before setting up macOS, consider disconnecting networking and configuring a firewall(s) first.

On first boot, hold `Command` `Option` `P` `R` keys to [clear NVRAM](https://support.apple.com/en-us/HT204063).

When macOS first starts, you'll be greeted by **Setup Assistant**.

When creating your account, use a [strong password](http://www.explainxkcd.com/wiki/index.php/936:_Password_Strength) without a hint.

If you enter your real name at the account setup process, be aware that your [computer's name and local hostname](https://support.apple.com/kb/PH18720) will be comprised of that name (e.g., *John Appleseed's MacBook*) and thus will appear on local networks and in various preference files. You can change them both in **System Preferences > Sharing** or with the following commands:

	$ sudo scutil --set ComputerName your_computer_name

	$ sudo scutil --set LocalHostName your_hostname

## Admin and standard user accounts

The first user account is always an admin account. Admin accounts are members of the admin group and have access to `sudo`, which allows them to usurp other accounts, in particular root, and gives them effective control over the system. Any program that the admin executes can potentially obtain the same access, making this a security risk. Utilities like `sudo` have [weaknesses that can be exploited](https://bogner.sh/2014/03/another-mac-os-x-sudo-password-bypass/) by concurrently running programs and many panes in System Preferences are [unlocked by default](http://csrc.nist.gov/publications/drafts/800-179/sp800_179_draft.pdf) [p. 61–62] for admin accounts. It is considered a best practice by [Apple](https://help.apple.com/machelp/mac/10.12/index.html#/mh11389) and [others](http://csrc.nist.gov/publications/drafts/800-179/sp800_179_draft.pdf) [p. 41–42] to use a separate standard account for day-to-day work and use the admin account for installations and system configuration.

It is not strictly required to ever log into the admin account via the OS X login screen. The system will prompt for authentication when required and Terminal can do the rest. To that end, Apple provides some [recommendations](https://support.apple.com/HT203998) for hiding the admin account and its home directory. This can be an elegant solution to avoid having a visible 'ghost' account. The admin account can also be [removed from FileVault](http://apple.stackexchange.com/a/94373).

#### Caveats

1. Only administrators can install applications in `/Applications` (local directory). Finder and Installer will prompt a standard user with an authentication dialog. Many applications can be installed in `~/Applications` instead (the directory can be created manually). As a rule of thumb: applications that do not require admin access – or do not complain about not being installed in `/Applications` – should be installed in the user directory, the rest in the local directory. Mac App Store applications are still installed in `/Applications` and require no additional authentication.

2. `sudo` is not available in shells of the standard user, which requires using `su` or `login` to enter a shell of the admin account. This can make some maneuvers trickier and requires some basic experience with command-line interfaces.

3. System Preferences and several system utilities (e.g. Wi-Fi Diagnostics) will require root privileges for full functionality. Many panels in System Preferences are locked and need to be unlocked separately by clicking on the lock icon. Some applications will simply prompt for authentication upon opening, others must be opened by an admin account directly to get access to all functions (e.g. Console).

4. There are third-party applications that will not work correctly because they assume that the user account is an admin. These programs may have to be executed by logging into the admin account, or by using the `open` utility.

#### Setup

Accounts can be created and managed in System Preferences. On settled systems, it is generally easier to create a second admin account and then demote the first account. This avoids data migration. Newly installed systems can also just add a standard account. Demoting an account can be done either from the the new admin account in System Preferences – the other account must be logged out – or by executing this command:
```
sudo dscl . -delete /Groups/admin GroupMembership user_name
```

## Full disk encryption

[FileVault](https://en.wikipedia.org/wiki/FileVault) provides full disk (technically, full _volume_) encryption on macOS.

FileVault encryption will protect data at rest and prevent someone with physical access from stealing data or tampering with your Mac.

With much of the cryptographic operations happening [efficiently in hardware](https://software.intel.com/en-us/articles/intel-advanced-encryption-standard-aes-instructions-set/), the performance penalty for FileVault is not noticeable.

The security of FileVault greatly depends on the pseudo random number generator (PRNG).

> The random device implements the Yarrow pseudo random number generator algorithm and maintains its entropy pool.  Additional entropy is fed to the generator regularly by the SecurityServer daemon from random jitter measurements of the kernel.

> SecurityServer is also responsible for periodically saving some entropy to disk and reloading it during startup to provide entropy in early system operation.

See `man 4 random` for more information.

The PRNG can be manually seeded with entropy by writing to /dev/random **before** enabling FileVault. This can be done by simply using the Mac for a little while before activating FileVault.

To manually seed entropy *before* enabling FileVault:

	$ cat > /dev/random
	[Type random letters for a long while, then press Control-D]

Enable FileVault with `sudo fdesetup enable` or through **System Preferences** > **Security & Privacy** and reboot.

If you can remember your password, there's no reason to save the **recovery key**. However, your encrypted data will be lost forever if you can't remember the password or recovery key.

If you want to know more about how FileVault works, see the paper [Infiltrate the Vault: Security Analysis and Decryption of Lion Full Disk Encryption](https://eprint.iacr.org/2012/374.pdf) (pdf) and related [presentation](http://www.cl.cam.ac.uk/~osc22/docs/slides_fv2_ifip_2013.pdf) (pdf). Also see [IEEE Std 1619-2007 “The XTS-AES Tweakable Block Cipher”](http://libeccio.di.unisa.it/Crypto14/Lab/p1619.pdf) (pdf).

You may wish to enforce **hibernation** and evict FileVault keys from memory instead of traditional sleep to memory:

    $ sudo pmset -a destroyfvkeyonstandby 1
    $ sudo pmset -a hibernatemode 25

> All computers have firmware of some type—EFI, BIOS—to help in the discovery of hardware components and ultimately to properly bootstrap the computer using the desired OS instance. In the case of Apple hardware and the use of EFI, Apple stores relevant information within EFI to aid in the functionality of OS X. For example, the FileVault key is stored in EFI to transparently come out of standby mode.

> Organizations especially sensitive to a high-attack environment, or potentially exposed to full device access when the device is in standby mode, should mitigate this risk by destroying the FileVault key in firmware. Doing so doesn’t destroy the use of FileVault, but simply requires the user to enter the password in order for the system to come out of standby mode.

If you choose to evict FileVault keys in standby mode, you should also modify your standby and power nap settings. Otherwise, your machine may wake while in standby mode and then power off due to the absence of the FileVault key. See [issue #124](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/124) for more information. These settings can be changed with:

    $ sudo pmset -a powernap 0
    $ sudo pmset -a standby 0
    $ sudo pmset -a standbydelay 0
    $ sudo pmset -a autopoweroff 0

For more information, see [Best Practices for
Deploying FileVault 2](http://training.apple.com/pdf/WP_FileVault2.pdf) (pdf) and paper [Lest We Remember: Cold Boot Attacks on Encryption Keys](https://www.usenix.org/legacy/event/sec08/tech/full_papers/halderman/halderman.pdf) (pdf)

## Firewall

Before connecting to the Internet, it's a good idea to first configure a firewall.

There are several types of firewall available for macOS.

#### Application layer firewall

Built-in, basic firewall which blocks **incoming** connections only.

Note, this firewall does not have the ability to monitor, nor block **outgoing** connections.

It can be controlled by the **Firewall** tab of **Security & Privacy** in **System Preferences**, or with the following commands.

Enable the firewall:

    $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

Enable logging:

    $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

You may also wish to enable stealth mode:

    $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

> Computer hackers scan networks so they can attempt to identify computers to attack. You can prevent your computer from responding to some of these scans by using **stealth mode**. When stealth mode is enabled, your computer does not respond to ICMP ping requests, and does not answer to connection attempts from a closed TCP or UDP port. This makes it more difficult for attackers to find your computer.

Finally, you may wish to prevent *built-in software* as well as *code-signed, downloaded software from being whitelisted automatically*:

    $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off

    $ sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off

> Applications that are signed by a valid certificate authority are automatically added to the list of allowed apps, rather than prompting the user to authorize them. Apps included in OS X are signed by Apple and are allowed to receive incoming connections when this setting is enabled. For example, since iTunes is already signed by Apple, it is automatically allowed to receive incoming connections through the firewall.

> If you run an unsigned app that is not listed in the firewall list, a dialog appears with options to Allow or Deny connections for the app. If you choose Allow, OS X signs the application and automatically adds it to the firewall list. If you choose Deny, OS X adds it to the list but denies incoming connections intended for this app.

After interacting with `socketfilterfw`, you may want to restart (or terminate) the process:

    $ sudo pkill -HUP socketfilterfw

#### Third party firewalls

Programs such as [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html), [Hands Off](https://www.oneperiodic.com/products/handsoff/), [Radio Silence](http://radiosilenceapp.com/) and [Security Growler](https://pirate.github.io/security-growler/) provide a good balance of usability and security.

<img width="349" alt="Example of Little Snitch monitored session" src="https://cloud.githubusercontent.com/assets/12475110/10596588/c0eed3c0-76b3-11e5-95b8-9ce7d51b3d82.png">

*Example of Little Snitch-monitored session*

```
LittleSnitch-3.7.dmg
SHA-256: 5c44d853dc4178fb227abd3e8eee19ef1bf0d576f49b5b6a9a7eddf6ae7ea951
SHA-1:   1320ca9bcffb8ff8105b7365e792db6dc7b9f46a
```

These programs are capable of monitoring and blocking **incoming** and **outgoing** network connections. However, they may require the use of a closed source [kernel extension](https://developer.apple.com/library/mac/documentation/Darwin/Conceptual/KernelProgramming/Extend/Extend.html).

If the number of choices of allowing/blocking network connections is overwhelming, use **Silent Mode** with connections allowed, then periodically check your settings to gain understanding of what various applications are doing.

It is worth noting that these firewalls can be bypassed by programs running as **root** or through [OS vulnerabilities](https://www.blackhat.com/docs/us-15/materials/us-15-Wardle-Writing-Bad-A-Malware-For-OS-X.pdf) (pdf), but they are still worth having - just don't expect absolute protection.

For more on how Little Snitch works, see the [Network Kernel Extensions Programming Guide](https://developer.apple.com/library/mac/documentation/Darwin/Conceptual/NKEConceptual/socket_nke/socket_nke.html#//apple_ref/doc/uid/TP40001858-CH228-SW1) and [Shut up snitch! – reverse engineering and exploiting a critical Little Snitch vulnerability](https://reverse.put.as/2016/07/22/shut-up-snitch-reverse-engineering-and-exploiting-a-critical-little-snitch-vulnerability/).

#### Kernel level packet filtering

A highly customizable, powerful, but also most complicated firewall exists in the kernel. It can be controlled with `pfctl` and various configuration files.

pf can also be controlled with a GUI application such as [IceFloor](http://www.hanynet.com/icefloor/) or [Murus](http://www.murusfirewall.com/).

There are many books and articles on the subject of pf firewall. Here's is just one example of blocking traffic by IP address.

Add the following into a file called `pf.rules`:

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

Use the following commands:

* `sudo pfctl -e -f pf.rules` to enable the firewall
* `sudo pfctl -d` to disable the firewall
* `sudo pfctl -t blocklist -T add 1.2.3.4` to add hosts to a blocklist
* `sudo pfctl -t blocklist -T show` to view the blocklist
* `sudo ifconfig pflog0 create` to create an interface for logging
* `sudo tcpdump -ni pflog0` to dump the packets

Unless you're already familiar with packet filtering, spending too much time configuring pf is not recommended. It is also probably unnecessary if your Mac is behind a [NAT](https://www.grc.com/nat/nat.htm) on a secured home network, for example.

For an example of using pf to audit "phone home" behavior of user and system-level processes, see [fix-macosx/net-monitor](https://github.com/fix-macosx/net-monitor).

## Services

Before you connect to the Internet, you may wish to disable some system services, which use up resources or phone home to Apple.

See [fix-macosx/yosemite-phone-home](https://github.com/fix-macosx/yosemite-phone-home), [l1k/osxparanoia](https://github.com/l1k/osxparanoia) and [karek314/macOS-home-call-drop](https://github.com/karek314/macOS-home-call-drop) for further recommendations.

Services on macOS are managed by **launchd**. See (launchd.info)[http://launchd.info/], as well as [Apple's Daemons and Services Programming Guide](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html) and [Technical Note TN2083](https://developer.apple.com/library/mac/technotes/tn2083/_index.html)

You can also run [KnockKnock](https://github.com/synack/knockknock) that shows more information about startup items.

* Use `launchctl list` to view running user agents
* Use `sudo launchctl list` to view running system daemons
* Specify the service name to examine it, e.g. `launchctl list com.apple.Maps.mapspushd`
* Use `defaults read` to examine job plists in `/System/Library/LaunchDaemons` and `/System/Library/LaunchAgents`
* Use `man`, `strings` and Google to learn about what the agent/daemon runs

For example, to learn what a system launch daemon or agent does, start with:

    $ defaults read /System/Library/LaunchDaemons/com.apple.apsd.plist

Look at the `Program` or `ProgramArguments` section to see which binary is run, in this case `apsd`. To find more information about that, look at the man page with `man apsd`

For example, if you're not interested in Apple Push Notifications, disable the service:

    $ sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.apsd.plist

**Note** Unloading services may break usability of some applications. Read the manual pages and use Google to make sure you understand what you're doing first.

Be careful about disabling any system daemons you don't understand, as it may render your system unbootable. If you break your Mac, use [single user mode](https://support.apple.com/en-us/HT201573) to fix it.

Use [Console](https://en.wikipedia.org/wiki/Console_(OS_X)) and [Activity Monitor](https://support.apple.com/en-us/HT201464) applications if you notice your Mac heating up, feeling sluggish, or generally misbehaving, as it may have resulted from your tinkering.

To view currently disabled services:

    $ find /var/db/com.apple.xpc.launchd/ -type f -print -exec defaults read {} \; 2>/dev/null

Annotated lists of launch daemons and agents, the respective program executed, and the programs' hash sums are included in this repository.

**(Optional)** Run the `read_launch_plists.py` script and `diff` output to check for any discrepancies on your system, e.g.:

    $ diff <(python read_launch_plists.py) <(cat 16A323_launchd.csv)

See also [cirrusj.github.io/Yosemite-Stop-Launch](http://cirrusj.github.io/Yosemite-Stop-Launch/) for descriptions of services and [Provisioning OS X and Disabling Unnecessary Services](https://vilimpoc.org/blog/2014/01/15/provisioning-os-x-and-disabling-unnecessary-services/) for another explanation.

## Spotlight 建议

在 Spotlight 偏好设置面板和 Safari 的搜索偏好设置中都禁用 **Spotlight 建议** ，来避免你的搜索查询项会发送给 Apple 。

在 Spotlight 偏好设置面板中也禁用 **必应 Web 搜索** 来避免你的搜索查询项会发送给 Microsoft 。

查看[fix-macosx.com](https://fix-macosx.com/)获得更详细的信息。

> If you've upgraded to Mac OS X Yosemite (10.10) and you're using the default settings, each time you start typing in Spotlight (to open an application or search for a file on your computer), your local search terms and location are sent to Apple and third parties (including Microsoft).

如需下载，查看并应用他们建议的补丁：

```
$ curl -O https://fix-macosx.com/fix-macosx.py

$ less fix-macosx.py

$ python fix-macosx.py
All done. Make sure to log out (and back in) for the changes to take effect.
```

谈到 Microsoft ，你可能还想看看<https://fix10.isleaked.com/> ，挺有意思的。

## Homebrew

考虑使用 [Homebrew](http://brew.sh/) 来让安装软件和更新 userland 工具 (查看 [Apple’s great GPL purge](http://meta.ath0.com/2012/02/05/apples-great-gpl-purge/)) 更简单。

**注意** 如果你还没安装 Xcode 或命令行工具，用 `xcode-select --install` 来从 Apple 下载、安装。

要[安装 Homebrew](https://github.com/Homebrew/brew/blob/master/docs/Installation.md#installation):
    $ mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew


在你的脚本或 rc 文件中编辑 `PATH` 来使用 `~/homebrew/bin` 和 `~/homebrew/sbin`。例如，先 `echo 'PATH=$PATH:~/homebrew/sbin:~/homebrew/bin' >> .zshrc`，然后用 `chsh -s /bin/zsh` 把登录脚本改为 Z shell ，打开一个新的终端窗口并运行 `brew update`。

Homebrew 使用 SSL/TLS 与 GitHub 通信并验证下载包的校验，所以它是[相当安全的](https://github.com/Homebrew/homebrew/issues/18036)。

记得定期在可信任的、安全的网络上运行`brew update` 和 `brew upgrade`来下载、安装软件更新。想在安装前得到关于一个包的信息，运行`brew info <package>`，在线查看。

依据[Homebrew 匿名汇总用户行为分析](https://github.com/Homebrew/brew/blob/master/docs/Analytics.md)，Homebrew 获取匿名的汇总的用户行为分析数据并把它们报告给 Google Analytics。

要退出  Homebrew 的分析，你能在你的环境中或编辑 rc 文件来设置 `export HOMEBREW_NO_ANALYTICS=1`，或使用 `brew analytics off`。

可能你还希望启用[额外的安全选项](https://github.com/drduh/macOS-Security-and-Privacy-Guide/issues/138)，例如 `HOMEBREW_NO_INSECURE_REDIRECT=1` 和 `HOMEBREW_CASK_OPTS=--require-sha`。

## DNS

#### Hosts 文件

使用[Hosts 文件](https://en.wikipedia.org/wiki/Hosts_(file)) 来屏蔽已知的恶意代码，广告或讨厌的域名。

以根用户身份编辑 hosts 文件，例如用 `sudo vi /etc/hosts`。hosts 文件也能用可视化的应用[2ndalpha/gasmask](https://github.com/2ndalpha/gasmask)管理。

要屏蔽一个域名，在 `/etc/hosts` 中加上 `0 example.com` 或 `0.0.0.0 example.com` 或 `127.0.0.1 example.com`。

网上能获得很多域名的可复制的列表，要确保每一行以 `0`, `0.0.0.0`, `127.0.0.1` 开始，并且 `127.0.0.1 localhost` 这一行包含在内。

对于主机列表，查看[someonewhocares.org](http://someonewhocares.org/hosts/zero/hosts), [l1k/osxparanoia/blob/master/hosts](https://github.com/l1k/osxparanoia/blob/master/hosts), [StevenBlack/hosts](https://github.com/StevenBlack/hosts) 和 [gorhill/uMatrix/hosts-files.json](https://github.com/gorhill/uMatrix/blob/master/assets/umatrix/hosts-files.json)。

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

更多信息请查看 `man hosts` 和[FreeBSD 配置文件](https://www.freebsd.org/doc/handbook/configtuning-configfiles.html) 。

#### Dnsmasq

与其他特性相比，[dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) 能缓存请求，避免向上查询无保留的名字，并且屏蔽整个顶级域名。

另外，和 DNSCrypt 一起使用来加密输出的 DNS 流量。

如果你不想使用 DNSCrypt，你至少应该[通过你的 ISP](http://hackercodex.com/guide/how-to-stop-isp-dns-server-hijacking/)使用 DNS[没有提供](http://bcn.boulder.co.us/~neal/ietf/verisign-abuse.html) 。两个流行的选择是[Google DNS](https://developers.google.com/speed/public-dns/) 和 [OpenDNS](https://www.opendns.com/home-internet-security/).

**(可选)** [DNSSEC](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions)是一系列 DNS 的扩展,为 DNS 客户端提供 DNS 数据的来源验证、否定存在验证和数据完整性检验。所有来自 DNSSEC 保护区域的应答都是数字签名的。签名的记录通过一个信任链授权，以一系列验证过的 DNS 根区域的公钥开头。当前的根区域信任猫店可能下载下来[从 IANA 网站](https://www.iana.org/dnssec/files)。关于 DNSSEC 有很多的资源，可能最好的一个是[dnssec.net 网站](http://www.dnssec.net)。

安装 Dnsmasq (DNSSEC 是可选的)：
    $ brew install dnsmasq --with-dnssec

    $ cp ~/homebrew/opt/dnsmasq/dnsmasq.conf.example ~/homebrew/etc/dnsmasq.conf


编辑配置项：

    $ vim ~/homebrew/etc/dnsmasq.conf

检查所有的选项。这有一些推荐的设置来启用：

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

安装并启动程序：

    $ brew services start dnsmasq

要设置 Dnsmasq 为本地的 DNS 服务器，打开 **系统偏好设置** > **网络** 并选择“高级”(译者注：原文为 ‘active interface’，实际上‘高级’)，接着 **DNS** 选项卡，选择 **+** 并 添加 `127.0.0.1`, 或使用:

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

**注意** 一些 VPN 软件一链接会覆盖 DNS 设置。更多信息查看[issue #24](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/24)。

#### 检测 DNSSEC 验证

检测 DNSSEC 验证需要有签过名的区域：

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

使用[dnscrypt](https://dnscrypt.org/) 来加密 DNS 流量（译者注：the provider of choice怎么翻啊求指教）。

如果你更喜欢一个 GUI 应用程序，看这里[alterstep/dnscrypt-osxclient](https://github.com/alterstep/dnscrypt-osxclient)。

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

*加一行本地地址，通过除了 53 的端口，像 5355，来使用 DNScrypt*

用 Homebrew 也能实现上述过程，安装`gnu-sed`并使用`gsed`命令行：

    $ sudo gsed -i "/sbin\\/dnscrypt-proxy<\\/string>/a<string>--local-address=127.0.0.1:5355<\\/string>\n" $(find ~/homebrew -name homebrew.mxcl.dnscrypt-proxy.plist)

默认情况下，`resolvers-list`将会指向 dnscrypt 版本特定的 resolvers 文件。当更新了 dnscrypt，这一版本将不再存在，若它存在，可能指向一个过期的文件。在`/Library/LaunchDaemons/homebrew.mxcl.dnscrypt-proxy.plist`中把 resolvers 文件改为`/usr/local/share`中的符号链接的版本，能解决上述问题：

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

> By default, dnscrypt-proxy runs on localhost (127.0.0.1), port 53,
and under the "nobody" user using the dnscrypt.eu-dk DNSCrypt-enabled
resolver. If you would like to change these settings, you will have to edit the plist file (e.g., --resolver-address, --provider-name, --provider-key, etc.)

通过编辑`homebrew.mxcl.dnscrypt-proxy.plist`也能完成

你能从一个信任的位置或使用[public servers](https://github.com/jedisct1/dnscrypt-proxy/blob/master/dnscrypt-resolvers.csv) 中的一个运行你自己的[dnscrypt server](https://github.com/Cofyc/dnscrypt-wrapper)(也看看这个 [drduh/Debian-Privacy-Server-Guide#dnscrypt](https://github.com/drduh/Debian-Privacy-Server-Guide#dnscrypt))

确保输出的 DNS 流量已加密：

```
$ sudo tcpdump -qtni en0
IP 10.8.8.8.59636 > 77.66.84.233.443: UDP, length 512
IP 77.66.84.233.443 > 10.8.8.8.59636: UDP, length 368

$ dig +short -x 77.66.84.233
resolver2.dnscrypt.eu
```

也读读[What is a DNS leak](https://dnsleaktest.com/what-is-a-dns-leak.html), [mDNSResponder manual page](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/mDNSResponder.8.html) 和 [ipv6-test.com](http://ipv6-test.com/)。

## Captive portal

当 macOS 连接到新的网络，它会 **检测** 网络，如果连接没有接通，启动 Captive Portal assistant 功能。

一个攻击者能触发这一功能，无需用户交互就将一台电脑定向到有恶意代码的网站，所以如果你起初禁用任何的客户端/代理设置，最好禁用 captive portal 并用你通常的浏览器登录 captive portals。

    $ sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

也看看这些 [Apple OS X Lion Security: Captive Portal Hijacking Attack](https://www.securestate.com/blog/2011/10/07/apple-os-x-lion-captive-portal-hijacking-attack), [Apple's secret "wispr" request](http://blog.erratasec.com/2010/09/apples-secret-wispr-request.html), [How to disable the captive portal window in Mac OS Lion](https://web.archive.org/web/20130407200745/http://www.divertednetworks.net/apple-captiveportal.html), and [An undocumented change to Captive Network Assistant settings in OS X 10.10 Yosemite](https://grpugh.wordpress.com/2014/10/29/an-undocumented-change-to-captive-network-assistant-settings-in-os-x-10-10-yosemite/).

## 证书授权

macOS 上有从营利的公司像 Apple, Verisign, Thawte, Digicert 和来自中国，日本，荷兰，美国等等的政府机关安装的[超过 200](https://support.apple.com/en-us/HT202858)个可信任的根证书。这些证书授权(CAs)能够针对任一域名处理 SSL/TLS 认证，代码签名证书等等。

想要了解更多，看看 [Certification Authority Trust Tracker](https://github.com/kirei/catt), [Analysis of the HTTPS certificate ecosystem](http://conferences.sigcomm.org/imc/2013/papers/imc257-durumericAemb.pdf) (pdf), 和 [You Won’t Be Needing These Any More: On Removing Unused Certificates From Trust Stores](http://www.ifca.ai/fc14/papers/fc14_submission_100.pdf) (pdf)。

你能在 **钥匙串访问** 中检查系统根证书，在 **系统根证书** 选项卡下或使用`security`命令行工具和`/System/Library/Keychains/SystemRootCertificates.keychain`文件。

你能通过钥匙串访问将它们标记为 **永不信任** 禁用证书授权并关闭窗口：

<img width="450" alt="A certificate authority certificate" src="https://cloud.githubusercontent.com/assets/12475110/19222972/6b7aabac-8e32-11e6-8efe-5d3219575a98.png">

被你的系统信任的被迫或妥协的证书授权产生一个假的/欺骗的 SSL 证书，这样的一个[中间人攻击](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)的风险很低，但仍然是[可能的](https://en.wikipedia.org/wiki/DigiNotar#Issuance_of_fraudulent_certificates)。

## OpenSSL

在 Sierra 中 OpenSSL 的版本是`0.9.8zh`，这[不是最新的](https://apple.stackexchange.com/questions/200582/why-is-apple-using-an-older-version-of-openssl)。它不支持TLS 1.1或新的版本，elliptic curve ciphers（译者注：这个要怎么翻求指教），[还有更多](https://stackoverflow.com/questions/27502215/difference-between-openssl-09-8z-and-1-0-1)。

Apple 在他们的[Cryptographic Services 指南](https://developer.apple.com/library/mac/documentation/Security/Conceptual/cryptoservices/GeneralPurposeCrypto/GeneralPurposeCrypto.html)文档中宣布 **弃用** OpenSSL。他们的版本也有补丁，可能会 [带来惊喜喔](https://hynek.me/articles/apple-openssl-verification-surprises/)。

如果你要在你的 Mac 上用 OpenSSL，用`brew install openssl`下载并安装一个 OpenSSL 最近的版本。注意，将 brew 连接来支持`/usr/bin/openssl` 可能会干扰构建软件。(译者注：校对着求帮助 这句话主语不会翻)查看 [issue #39](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/39)。

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

也看看 [Comparison of TLS implementations](https://en.wikipedia.org/wiki/Comparison_of_TLS_implementations), [How's My SSL](https://www.howsmyssl.com/), [Qualys SSL Labs Tools](https://www.ssllabs.com/projects/)以及更详细的解释和最新的漏洞测试 [ssl-checker.online-domain-tools.com](http://ssl-checker.online-domain-tools.com)。

## Curl

macOS 中 Curl 的版本针对 SSL/TLS 验证使用[安全传输](https://developer.apple.com/library/mac/documentation/Security/Reference/secureTransportRef/) 。

如果你更愿意使用 OpenSSL，用`brew install curl --with-openssl`安装并确保默认是`brew link --force curl`

这推荐几个向`~/.curlrc`中添加的[可选项](http://curl.haxx.se/docs/manpage.html)(更多请查看 `man curl` ):
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

考虑使用 [Privoxy](http://www.privoxy.org/)作为本地代理来过滤网络浏览内容。

一个已签名的 privoxy 安装包能从[silvester.org.uk](http://silvester.org.uk/privoxy/OSX/) 或 [Sourceforge](http://sourceforge.net/projects/ijbswa/files/Macintosh%20%28OS%20X%29/)下载。签过名的包比 Homebrew 版本[更安全](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/65)，而且能得到 Privoxy 项目全面的支持。

另外，用 Homebrew 安装、启动 privoxy：

    $ brew install privoxy

    $ brew services start privoxy


默认情况下，privoxy 监听本地的 8118 端口。

为你的网络接口设置系统 **http** 代理为`127.0.0.1` 和 `8118`(可以通过 **系统偏好设置 > 网络 > 高级 > 代理** ):

    $ sudo networksetup -setwebproxy "Wi-Fi" 127.0.0.1 8118


**(可选)** 用下述方法设置系统 **https** 代理，这仍提供了域名过滤功能:

    $ sudo networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 8118

确保代理设置好了:

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

在一个浏览器里访问<http://p.p/>,或用 Curl 访问:

```
$ ALL_PROXY=127.0.0.1:8118 curl -I http://p.p/
HTTP/1.1 200 OK
Content-Length: 2401
Content-Type: text/html
Cache-Control: no-cache
```

代理已经有很多好的规则，你也能自己定义。

编辑`~/homebrew/etc/privoxy/user.action`用域名或正则表达式来过滤。

示例如下:
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

验证 Privoxy 能够屏蔽和重定向:

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

对于你的大部分浏览使用[Google Chrome](https://www.google.com/chrome/browser/desktop/)。它提供了[独立的配置文件](https://www.chromium.org/user-experience/multi-profiles), [好的沙盒处理](https://www.chromium.org/developers/design-documents/sandbox), [经常更新](http://googlechromereleases.blogspot.com/) (包括 Flash，尽管你应该禁用它 - 看下面i), 并且有 [很好的证书](https://www.chromium.org/Home/chromium-security/brag-sheet).

Chrome 也有一个很好的[PDF 阅读器](http://0xdabbad00.com/2013/01/13/most-secure-pdf-viewer-chrome-pdf-viewer/)。

如果你不想用 Chrome，[Firefox](https://www.mozilla.org/en-US/firefox/new/)也是一个很好的浏览器。或就用这两个。看这里的讨论[#2](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/2)。

如果用 Firefox，查看[TheCreeper/PrivacyFox](https://github.com/TheCreeper/PrivacyFox) 里推荐的隐私偏好设置。也要确保为基于 Mozilla 的浏览器检查[NoScript](https://noscript.net/)，它允许基于白名单的抢先脚本阻止。

创建至少三个配置文件，一个用来浏览 **可信任的** 网站 (邮箱，银行)，另一个为了 **大部分是可信的** 网站(链路聚合，新闻站点)，第三个是针对完全 **无 cookie** 和 **无脚本** 的体验。

* 一个启用了 **无 cookies 和 Javascript** 的配置文件就应该用来访问未信任的网站。然而，如果不启用 Javascript，很多页面根本不会加载。

* 一个有[uMatrix](https://github.com/gorhill/uMatrix) 或 [uBlock Origin](https://github.com/gorhill/uBlock) (或两个都有)的配置文件。用这个文件来访问 **大部分是可信的** 网站。花时间了解防火墙扩展程序是怎么工作的。其他经常被推荐的扩展程序是[Privacy Badger](https://www.eff.org/privacybadger), [HTTPSEverywhere](https://www.eff.org/https-everywhere) 和 [CertPatrol](http://patrol.psyced.org/) (仅限 Firefox).

* 一个或更多的配置文件用来满足安全和可信任的浏览需求，例如仅限于银行和邮件。

想法是分隔并划分数据，因此在一个"区域"的漏洞利用或隐私漏洞并不一定影响另一个的数据。

在每一个文件里，访问`chrome://plugins/`并禁用 **Adobe Flash Player**。如果你一定要用 Flash，访问`chrome://settings/contents`，在插件部分，启用在 **让我自行选择何时运行插件内容** (也叫做 *click-to-play*)。

花时间阅读[Chromium 安全](https://www.chromium.org/Home/chromium-security) 和 [Chromium 隐私](https://www.chromium.org/Home/chromium-privacy)。

例如你可能希望禁用[DNS prefetching](https://www.chromium.org/developers/design-documents/dns-prefetching) (也看看 [DNS Prefetching and Its Privacy Implications](https://www.usenix.org/legacy/event/leet10/tech/full_papers/Krishnan.pdf) (pdf))。

你也应该知道[WebRTC](https://en.wikipedia.org/wiki/WebRTC#Concerns)，它能获取你本地或外网的(如果连到 VPN)IP 地址.这能用例如[uBlock Origin](https://github.com/gorhill/uBlock/wiki/Prevent-WebRTC-from-leaking-local-IP-address) 和 [rentamob/WebRTC-Leak-Prevent](https://github.com/rentamob/WebRTC-Leak-Prevent)的扩展程序禁用掉。

很多源于 Chromium 的浏览器这里不推荐。它们通常 [不开源](http://yro.slashdot.org/comments.pl?sid=4176879&cid=44774943), [维护性差](https://plus.google.com/+JustinSchuh/posts/69qw9wZVH8z), [有问题](https://code.google.com/p/google-security-research/issues/detail?id=679),而且对保护隐私有可疑的声明。 看这里 [The Private Life of Chromium Browsers](http://thesimplecomputer.info/the-private-life-of-chromium-browsers)。

也不推荐 Safari。代码一团糟而且[安全问题](https://nakedsecurity.sophos.com/2014/02/24/anatomy-of-a-goto-fail-apples-ssl-bug-explained-plus-an-unofficial-patch/) [漏洞](https://vimeo.com/144872861) 经常发生，并且打补丁很慢 (看这里 [Hacker News上的讨论](https://news.ycombinator.com/item?id=10150038))。安全[并不是](https://discussions.apple.com/thread/5128209)Safari 的一个优点，。如果你硬要使用它，至少在偏好设置里[禁用](https://thoughtsviewsopinions.wordpress.com/2013/04/26/how-to-stop-downloaded-files-opening-automatically/)  **下载后打开"安全的文件**,也要了解其他的[隐私差别](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/93)。

其他乱七八糟的浏览器，例如[Brave](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/94)，在这个指南里没有评估，所以既不推荐也不反对使用。

查看更多关于安全意识的浏览，看[HowTo: Privacy & Security Conscious Browsing](https://gist.github.com/atcuno/3425484ac5cce5298932), [browserleaks.com](https://www.browserleaks.com/) 和 [EFF Panopticlick](https://panopticlick.eff.org/)。

### 插件

**Adobe Flash**, **Oracle Java**, **Adobe Reader**, **Microsoft Silverlight** (Netflix 现在使用 [HTML5](https://help.netflix.com/en/node/23742)) 和其他的插件有[安全风险](https://news.ycombinator.com/item?id=9901480)，不应该安装。

如果它们是必须的，只在一个虚拟机里安装它们并且订阅安全通知以便确保你总是被保护的。

看 [Hacking Team Flash Zero-Day](http://blog.trendmicro.com/trendlabs-security-intelligence/hacking-team-flash-zero-day-integrated-into-exploit-kits/), [Java Trojan BackDoor.Flashback](https://en.wikipedia.org/wiki/Trojan_BackDoor.Flashback), [Acrobat Reader: Security Vulnerabilities](http://www.cvedetails.com/vulnerability-list/vendor_id-53/product_id-497/Adobe-Acrobat-Reader.html), 和 [Angling for Silverlight Exploits](https://blogs.cisco.com/security/angling-for-silverlight-exploits).

## PGP/GPG

PGP 是一个端对端邮件加密标准。这意味着只是选中的接收者能解密一条消息，不像通常的邮件被提供者永久阅读和保存。

**GPG**, 或 **GNU Privacy Guard**，是一个符合标准的 GPL 协议项目。

**GPG** 被用来验证你下载和安装的软件签名，也[对称](https://en.wikipedia.org/wiki/Symmetric-key_algorithm) 或 [非对称](https://en.wikipedia.org/wiki/Public-key_cryptography)的加密文件和文本。

从 Homebrew 上用`brew install gnupg2`安装。

如果你更喜欢图形化的应用，下载安装[GPG Suite](https://gpgtools.org/)。

这有几个往`~/.gnupg/gpg.conf`中添加的[推荐选项](https://github.com/drduh/config/blob/master/gpg.conf):

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

安装 keyservers[CA 认证](https://sks-keyservers.net/verify_tls.php):

    $ curl -O https://sks-keyservers.net/sks-keyservers.netCA.pem

    $ sudo mv sks-keyservers.netCA.pem /etc

这些设置将会配置 GnuPG 当得到新的密码时使用 SSL 并且更喜欢强健的密码学原语。

也看看[ioerror/duraconf/configs/gnupg/gpg.conf](https://github.com/ioerror/duraconf/blob/master/configs/gnupg/gpg.conf)。你也应该花时间读读[OpenPGP Best Practices](https://help.riseup.net/en/security/message-security/openpgp/best-practices)。

如果你没有一个密钥对，用`gpg --gen-key`创建一个。也看看[drduh/YubiKey-Guide](https://github.com/drduh/YubiKey-Guide)。

读[在线的](https://alexcabal.com/creating-the-perfect-gpg-keypair/) [指南](https://security.stackexchange.com/questions/31594/what-is-a-good-general-purpose-gnupg-key-setup)并练习给你自己和朋友们加密解密邮件。让他们也对这篇文章感兴趣吧！

## OTR

OTR 代表 **off-the-record** 并且是一个针对即时消息对话加密和授权的密码协议。

你能在任何一个已存在的[XMPP](https://xmpp.org/about) 聊天服务顶部使用 OTR，甚至是 Google Hangouts(它只在使用 TLS 的用户和服务器之间加密对话)。

你和某人第一次开始一段对话，你将会被询问来验证他们的公钥 fingerprint。确保亲自或通过某些其他的安全方法(例如 GPG 加密过的邮件)做这件事。
针对 XMPP 和其他的聊天协议，有一个流行的 macOS GUI 客户端是[Adium](https://adium.im/)。

考虑下载使用 OAuth2 的 [测试版](https://beta.adium.im/)，确保登录谷歌账号[更](https://adium.im/blog/2015/04/) [安全](https://trac.adium.im/ticket/16161)。

```
Adium_1.5.11b3.dmg
SHA-256: 999e1931a52dc327b3a6e8492ffa9df724a837c88ad9637a501be2e3b6710078
SHA-1:   ca804389412f9aeb7971ade6812f33ac739140e6
```

记住对于 Adium 的 OTR 聊天[禁用登录](https://trac.adium.im/ticket/15722)。

一个好的基于控制台的 XMPP 客户端是[profanity](http://www.profanity.im/)，它能用`brew install profanity`安装。

针对改进的匿名，查看[Tor Messenger](https://blog.torproject.org/blog/tor-messenger-beta-chat-over-tor-easily)，尽管它还在测试中，[Ricochet](https://ricochet.im/) (它最近接受了一个彻底的 [安全 审查](https://ricochet.im/files/ricochet-ncc-audit-2016-01.pdf) (pdf))也是，这两个都使用 Tor 网络而不是依赖于消息服务器。

如果你想了解 OTR 是如何工作的，读这篇论文[Off-the-Record Communication, or, Why Not To Use PGP](https://otr.cypherpunks.ca/otr-wpes.pdf) (pdf)

## Tor

Tor 是一个用来浏览网页的匿名代理。

从[官方 Tor 项目网站](https://www.torproject.org/projects/torbrowser.html)下载 Tor 浏览器。

**不要** 尝试配置其他的浏览器或应用程序来使用 Tor，因为你可能会犯破坏匿名的错。

下载`dmg` 和 `asc`签名文件，然后验证磁盘镜像已经被 Tor 开发者签过名了：

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

确保`Good signature from "Tor Browser Developers (signing key) <torbrowser@torproject.org>"`出现在输出结果中。关于密钥没被认证的警告不是坏的，因为它还没被手动分配信任。

看[How to verify signatures for packages](https://www.torproject.org/docs/verifying-signatures.html) 获得更多信息。

要完成安装 Tor 浏览器，打开磁盘镜像，拖动它到应用文件夹里，或者这样：

```
$ hdiutil mount TorBrowser-6.0.5-osx64_en-US.dmg

$ cp -rv /Volumes/Tor\ Browser/TorBrowser.app /Applications
```

Tor 流量对于[出口节点](https://en.wikipedia.org/wiki/Tor_(anonymity_network#Exit_node_eavesdropping)(不能被一个网络窃听者读取) 是 **加密的**，但是Tor的使用 **能** 被确认 - 例如，TLS 握手“主机名”将会以明文显示：

```
$ sudo tcpdump -An "tcp" | grep "www"
listening on pktap, link-type PKTAP (Apple DLT_PKTAP), capture size 262144 bytes
.............". ...www.odezz26nvv7jeqz1xghzs.com.........
.............#.!...www.bxbko3qi7vacgwyk4ggulh.com.........
.6....m.....>...:.........|../*	Z....W....X=..6...C../....................................0...0..0.......'....F./0..	*.H........0%1#0!..U....www.b6zazzahl3h3faf4x2.com0...160402000000Z..170317000000Z0'1%0#..U....www.tm3ddrghe22wgqna5u8g.net0..0..
```

查看 [Tor Protocol Specification](https://gitweb.torproject.org/torspec.git/tree/tor-spec.txt) 和 [Tor/TLSHistory](https://trac.torproject.org/projects/tor/wiki/org/projects/Tor/TLSHistory) 获得更多信息。

另外，你可能也希望使用一个[pluggable transport](https://www.torproject.org/docs/pluggable-transports.html), 例如 [Yawning/obfs4proxy](https://github.com/Yawning/obfs4) 或 [SRI-CSL/stegotorus](https://github.com/SRI-CSL/stegotorus)来混淆 Tor 流量。

这能通过建立你自己的[Tor relay](https://www.torproject.org/docs/tor-relay-debian.html)或找到一个已存在的私有或公用的[bridge](https://www.torproject.org/docs/bridges.html.en#RunningABridge) 来作为一个混淆入口节点来实现。

对于额外的安全性，在[VirtualBox](https://www.virtualbox.org/wiki/Downloads) 或 [VMware](https://www.vmware.com/products/fusion) ，可视化的 [GNU/Linux](http://www.brianlinkletter.com/installing-debian-linux-in-a-virtualbox-virtual-machine/) 或 [BSD](http://www.openbsd.org/faq/faq4.html)及其里用 Tor。

最后，记得 Tor 网络提供了[匿名](https://www.privateinternetaccess.com/blog/2013/10/how-does-privacy-differ-from-anonymity-and-why-are-both-important/)，这并不等于隐私。Tor 网络不一定能防止一个全球的窃听者能获得流量统计和[相关性](https://blog.torproject.org/category/tags/traffic-correlation)。也看看 [Seeking Anonymity in an Internet Panopticon](http://bford.info/pub/net/panopticon-cacm.pdf) (pdf) 和 [Traffic Correlation on Tor by Realistic Adversaries](http://www.ohmygodel.com/publications/usersrouted-ccs13.pdf) (pdf)。

也看看 [Invisible Internet Project (I2P)](https://geti2p.net/en/about/intro) 和它的 [Tor 对比](https://geti2p.net/en/comparison/tor)。

## VPN

如果你在未信任的网络使用 Mac - 机场，咖啡厅等 - 你的网络流量会被监控并可能被篡改。

用一个 VPN 是个好想法，它能用一个你信任的提供商加密 **所有** 输出的网络流量。举例说如何建立并拥有自己的 VPN，看 [drduh/Debian-Privacy-Server-Guide](https://github.com/drduh/Debian-Privacy-Server-Guide)。

不要盲目地还没理解整个含义和流量的路由原理就为一个 VPN 服务签名。如果你不理解 VPN 是怎样工作的或不熟悉软件的使用，你就最好别用它。

当选择一个 VPN 服务或建立你自己的服务时，确保研究过协议，密钥交换算法，认证机制和使用的加密类型。一些协议，例如[PPTP](https://en.wikipedia.org/wiki/Point-to-Point_Tunneling_Protocol#Security)，应该避免支持 [OpenVPN](https://en.wikipedia.org/wiki/OpenVPN)。

当 VPN 被中断或失去连接时，一些客户端可能通过下一个可用的接口发送流量。查看[scy/8122924](https://gist.github.com/scy/8122924)研究下如何允许流量只通过VPN。

另一些脚本会关闭系统，所以只能通过 VPN 访问网络，这就是 the Voodoo Privacy project - [sarfata/voodooprivacy](https://github.com/sarfata/voodooprivacy)的一部分，有一个更新的指南用来在一个虚拟机上([hwdsl2/setup-ipsec-vpn](https://github.com/hwdsl2/setup-ipsec-vpn))或一个 docker 容器([hwdsl2/docker-ipsec-vpn-server](https://github.com/hwdsl2/docker-ipsec-vpn-server)).建立一个 IPSec VPN。

## Viruses and malware

There is an [ever-increasing](https://www.documentcloud.org/documents/2459197-bit9-carbon-black-threat-research-report-2015.html) amount of Mac malware in the wild. Macs aren't immune from viruses and malicious software!

Some malware comes bundled with both legitimate software, such as the [Java bundling Ask Toolbar](http://www.zdnet.com/article/oracle-extends-its-adware-bundling-to-include-java-for-macs/), and some with illegitimate software, such as [Mac.BackDoor.iWorm](https://docs.google.com/document/d/1YOfXRUQJgMjJSLBSoLiUaSZfiaS_vU3aG4Bvjmz6Dxs/edit?pli=1) bundled with pirated programs. [Malwarebytes Anti-Malware for Mac](https://www.malwarebytes.com/antimalware/mac/) is an excellent program for ridding oneself of "garden-variety" malware and other "crapware".

See [Methods of malware persistence on Mac OS X](https://www.virusbtn.com/pdf/conference/vb2014/VB2014-Wardle.pdf) (pdf) and [Malware Persistence on OS X Yosemite](https://www.rsaconference.com/events/us15/agenda/sessions/1591/malware-persistence-on-os-x-yosemite) to learn about how garden-variety malware functions.

You could periodically run a tool like [Knock Knock](https://github.com/synack/knockknock) to examine persistent applications (e.g. scripts, binaries). But by then, it is probably too late. Maybe applications such as [Block Block](https://objective-see.com/products/blockblock.html) and [Ostiarius](https://objective-see.com/products/ostiarius.html) will help. See warnings and caveats in [issue #90](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/90) first, however.  Using an application such as [Little Flocker] (https://github.com/jzdziarski/littleflocker) can also protect parts of the filesystem from unauthorized writes similar to how Little Snitch protects the network (note, however, the software is still in beta and should be [used with caution](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/pull/128)).

**Anti-virus** programs are a double-edged sword -- not useful for **advanced** users and will likely increase attack surface against sophisticated threats, however possibly useful for catching "garden variety" malware on **novice** users' Macs. There is also the additional processing overhead to consider.

See [Sophail: Applied attacks against  Antivirus](https://lock.cmpxchg8b.com/sophailv2.pdf) (pdf), [Analysis and Exploitation of an ESET Vulnerability](http://googleprojectzero.blogspot.ro/2015/06/analysis-and-exploitation-of-eset.html), [a trivial Avast RCE](https://code.google.com/p/google-security-research/issues/detail?id=546), [Popular Security Software Came Under Relentless NSA and GCHQ Attacks](https://theintercept.com/2015/06/22/nsa-gchq-targeted-kaspersky/), and [AVG: "Web TuneUP" extension multiple critical vulnerabilities](https://code.google.com/p/google-security-research/issues/detail?id=675).

Therefore, the best anti-virus is **Common Sense 2016**. See more discussion in [issue #44](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/44).

Local privilege escalation bugs are plenty on macOS, so always be careful when downloading and running untrusted programs or trusted programs from third party websites or downloaded over HTTP ([example](http://arstechnica.com/security/2015/08/0-day-bug-in-fully-patched-os-x-comes-under-active-exploit-to-hijack-macs/)).

Have a look at [The Safe Mac](http://www.thesafemac.com/) for past and current Mac security news.

Also check out [Hacking Team](https://www.schneier.com/blog/archives/2015/07/hacking_team_is.html) malware for Mac OS: [root installation for MacOS](https://github.com/hackedteam/vector-macos-root), [Support driver for Mac Agent](https://github.com/hackedteam/driver-macos) and [RCS Agent for Mac](https://github.com/hackedteam/core-macos), which is a good example of advanced malware with capabilities to hide from **userland** (e.g., `ps`, `ls`), for example. For more, see [A Brief Analysis of an RCS Implant Installer](https://objective-see.com/blog/blog_0x0D.html) and [reverse.put.as](https://reverse.put.as/2016/02/29/the-italian-morons-are-back-what-are-they-up-to-this-time/)

## System Integrity Protection

[System Integrity Protection](https://support.apple.com/en-us/HT204899) (SIP) is a new security feature of OS X 10.11. It is enabled by default, but [can be disabled](https://derflounder.wordpress.com/2015/10/01/system-integrity-protection-adding-another-layer-to-apples-security-model/), which may be necessary to change some system settings, such as deleting root certificate authorities or unloading certain launch daemons. Keep this feature on, as it is by default.

From [What's New in OS X 10.11](https://developer.apple.com/library/prerelease/mac/releasenotes/MacOSX/WhatsNewInOSX/Articles/MacOSX10_11.html):

> A new security policy that applies to every running process, including privileged code and code that runs out of the sandbox. The policy extends additional protections to components on disk and at run-time, only allowing system binaries to be modified by the system installer and software updates. Code injection and runtime attachments to system binaries are no longer permitted.

Also see [What is the “rootless” feature in El Capitan, really?](https://apple.stackexchange.com/questions/193368/what-is-the-rootless-feature-in-el-capitan-really)

## Gatekeeper and XProtect

**Gatekeeper** and the **quarantine** system try to prevent unsigned or "bad" programs and files from running and opening.

**XProtect** prevents the execution of known bad files and outdated plugin versions, but does nothing to cleanup or stop existing malware.

Both offer trivial protection against common risks and are fine at default settings.

See also [Mac Malware Guide : How does Mac OS X protect me?](http://www.thesafemac.com/mmg-builtin/) and [Gatekeeper, XProtect and the Quarantine attribute](http://ilostmynotes.blogspot.com/2012/06/gatekeeper-xprotect-and-quarantine.html).

**Note** Quarantine stores information about downloaded files in `~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2`, which may pose a privacy risk. To examine the file, simply use `strings` or the following command:

    $ echo 'SELECT datetime(LSQuarantineTimeStamp + 978307200, "unixepoch") as LSQuarantineTimeStamp, LSQuarantineAgentName, LSQuarantineOriginURLString, LSQuarantineDataURLString from LSQuarantineEvent;' | sqlite3 /Users/$USER/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2

See [here](http://www.zoharbabin.com/hey-mac-i-dont-appreciate-you-spying-on-me-hidden-downloads-log-in-os-x/) for more information.

To permanently disable this feature, [clear the file](https://superuser.com/questions/90008/how-to-clear-the-contents-of-a-file-from-the-command-line) and [make it immutable](http://hints.macworld.com/article.php?story=20031017061722471):

    $ :>~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
    $ sudo chflags schg ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2

Furthermore, macOS attaches metadata ([HFS+ extended attributes](https://en.wikipedia.org/wiki/Extended_file_attributes#OS_X)) to downloaded files:

```
$ ls -l@ ~/Downloads/TorBrowser-6.0.5-osx64_en-US.dmg
-rw-r--r--@ 1 drduh  staff  59322237 Oct  9 15:20 TorBrowser-6.0.5-osx64_en-US.dmg
com.apple.metadata:kMDItemWhereFroms	     186
com.apple.quarantine	      68

$ xattr -l ~/Downloads/TorBrowser-6.0.5-osx64_en-US.dmg
com.apple.metadata:kMDItemWhereFroms:
00000000  62 70 6C 69 73 74 30 30 A2 01 02 5F 10 4D 68 74  |bplist00..._.Mht|
00000010  74 70 73 3A 2F 2F 64 69 73 74 2E 74 6F 72 70 72  |tps://dist.torpr|
00000020  6F 6A 65 63 74 2E 6F 72 67 2F 74 6F 72 62 72 6F  |oject.org/torbro|
00000030  77 73 65 72 2F 36 2E 30 2E 35 2F 54 6F 72 42 72  |wser/6.0.5/TorBr|
00000040  6F 77 73 65 72 2D 36 2E 30 2E 35 2D 6F 73 78 36  |owser-6.0.5-osx6|
00000050  34 5F 65 6E 2D 55 53 2E 64 6D 67 5F 10 39 68 74  |4_en-US.dmg_.9ht|
00000060  74 70 73 3A 2F 2F 77 77 77 2E 74 6F 72 70 72 6F  |tps://www.torpro|
00000070  6A 65 63 74 2E 6F 72 67 2F 64 6F 77 6E 6C 6F 61  |ject.org/downloa|
00000080  64 2F 64 6F 77 6E 6C 6F 61 64 2D 65 61 73 79 2E  |d/download-easy.|
00000090  68 74 6D 6C 2E 65 6E 08 0B 5B 00 00 00 00 00 00  |html.en..[......|
000000A0  01 01 00 00 00 00 00 00 00 03 00 00 00 00 00 00  |................|
000000B0  00 00 00 00 00 00 00 00 00 97                    |..........|
000000ba
com.apple.quarantine: 0081;52fb9173;Google Chrome.app;3AB6D46E-4AC5-3C3E-B427-32C7F804AAA3

$ xattr -d com.apple.metadata:kMDItemWhereFroms ~/Downloads/TorBrowser-6.0.5-osx64_en-US.dmg

$ xattr -d com.apple.quarantine ~/Downloads/TorBrowser-6.0.5-osx64_en-US.dmg

$ xattr -l ~/Downloads/TorBrowser-6.0.5-osx64_en-US.dmg
[No output after removal.]
```

## Passwords

You can generate strong passwords with OpenSSL:

    $ openssl rand -base64 30
    LK9xkjUEAemc1gV2Ux5xqku+PDmMmCbSTmwfiMRI

Or GPG:

    $ gpg --gen-random -a 0 30
    4/bGZL+yUEe8fOqQhF5V01HpGwFSpUPwFcU3aOWQ

Or `/dev/urandom` output:

    $ dd if=/dev/urandom bs=1 count=30 2>/dev/null | base64
    CbRGKASFI4eTa96NMrgyamj8dLZdFYBaqtWUSxKe

With control over character sets:

    $ LANG=C tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 40 | head -n 1
    jm0iKn7ngQST8I0mMMCbbi6SKPcoUWwCb5lWEjxK

    $ LANG=C tr -dc 'DrDuh0-9' < /dev/urandom | fold -w 40 | head -n 1
    686672u2Dh7r754209uD312hhh23uD7u41h3875D

You can also generate passwords, even memorable ones, using **Keychain Access** password assistant, or a command line equivalent like [anders/pwgen](https://github.com/anders/pwgen).

Keychains are encrypted with a [PBKDF2 derived key](https://en.wikipedia.org/wiki/PBKDF2) and are a _pretty safe_ place to store credentials. See also [Breaking into the OS X keychain](http://juusosalonen.com/post/30923743427/breaking-into-the-os-x-keychain). Also be aware that Keychain [does not encrypt](https://github.com/drduh/OS-X-Security-and-Privacy-Guide/issues/118) the names corresponding to password entries.

Alternatively, you can manage an encrypted passwords file yourself with GnuPG (shameless plug for my [drduh/pwd.sh](https://github.com/drduh/pwd.sh) password manager script).

In addition to passwords, ensure eligible online accounts, such as GitHub, Google accounts, banking, have [two factor authentication](https://en.wikipedia.org/wiki/Two-factor_authentication) enabled.

Look to [Yubikey](https://www.yubico.com/products/yubikey-hardware/yubikey-neo/) for a two factor and private key (e.g., ssh, gpg) hardware token. See [drduh/YubiKey-Guide](https://github.com/drduh/YubiKey-Guide) and [trmm.net/Yubikey](https://trmm.net/Yubikey). One of two Yubikey's slots can also be programmed to emit a long, static password (which can be used in combination with a short, memorized password, for example).

## Backup

Always encrypt files locally before backing them up to external media or online services.

One way is to use a symmetric cipher with GPG and a password of your choosing.

To encrypt a directory:

    $ tar zcvf - ~/Downloads | gpg -c > ~/Desktop/backup-$(date +%F-%H%M).tar.gz.gpg

To decrypt an archive:

    $ gpg -o ~/Desktop/decrypted-backup.tar.gz -d ~/Desktop/backup-2015-01-01-0000.tar.gz.gpg && \
      tar zxvf ~/Desktop/decrypted-backup.tar.gz

You may also create encrypted volumes using **Disk Utility** or `hdiutil`:

    $ hdiutil create ~/Desktop/encrypted.dmg -encryption -size 1g -volname "Name" -fs JHFS+

Also see the following applications and services: [SpiderOak](https://spideroak.com/), [Arq](https://www.arqbackup.com/), [Espionage](https://www.espionageapp.com/), and [restic](https://restic.github.io/).

## Wi-Fi

macOS remembers access points it has connected to. Like all wireless devices, the Mac will broadcast all access point names it remembers (e.g., *MyHomeNetwork*) each time it looks for a network, such as when waking from sleep.

This is a privacy risk, so remove networks from the list in **System Preferences** > **Network** > **Advanced** when they're no longer needed.

Also see [Signals from the Crowd: Uncovering Social Relationships through Smartphone Probes](http://conferences.sigcomm.org/imc/2013/papers/imc148-barberaSP106.pdf) (pdf) and [Wi-Fi told me everything about you](http://confiance-numerique.clermont-universite.fr/Slides/M-Cunche-2014.pdf) (pdf).

Saved Wi-Fi information (SSID, last connection, etc.) can be found in `/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist`

You may wish to [spoof the MAC address](https://en.wikipedia.org/wiki/MAC_spoofing) of your network card before connecting to new and untrusted wireless networks to mitigate passive fingerprinting:

    $ sudo ifconfig en0 ether $(openssl rand -hex 6 | sed 's%\(..\)%\1:%g; s%.$%%')

**Note** MAC addresses will reset to hardware defaults on each boot.

Also see [feross/SpoofMAC](https://github.com/feross/SpoofMAC).

Finally, WEP protection on wireless networks is [not secure](http://www.howtogeek.com/167783/htg-explains-the-difference-between-wep-wpa-and-wpa2-wireless-encryption-and-why-it-matters/) and you should favor connecting to **WPA2** protected networks only to mitigate the risk of passive eavesdroppers.

## SSH

For outgoing ssh connections, use hardware- or password-protected keys, [set up](http://nerderati.com/2011/03/17/simplify-your-life-with-an-ssh-config-file/) remote hosts and consider [hashing](http://nms.csail.mit.edu/projects/ssh/) them for added privacy.

Here are several recommended [options](https://www.freebsd.org/cgi/man.cgi?query=ssh_config&sektion=5) to add to  `~/.ssh/config`:

    Host *
      PasswordAuthentication no
      ChallengeResponseAuthentication no
      HashKnownHosts yes

**Note** [macOS Sierra permanently remembers SSH key passphrases by default](https://openradar.appspot.com/28394826). Append the option `UseKeyChain no` to turn this feature off.

You can also use ssh to create an [encrypted tunnel](http://blog.trackets.com/2014/05/17/ssh-tunnel-local-and-remote-port-forwarding-explained-with-examples.html) to send your traffic through, which is similar to a VPN.

For example, to use Privoxy on a remote host:

    $ ssh -C -L 5555:127.0.0.1:8118 you@remote-host.tld

    $ sudo networksetup -setwebproxy "Wi-Fi" 127.0.0.1 5555

    $ sudo networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 5555

Or to use an ssh connection as a [SOCKS proxy](https://www.mikeash.com/ssh_socks.html):

    $ ssh -NCD 3000 you@remote-host.tld

By default, macOS does **not** have sshd or *Remote Login* enabled.

To enable sshd and allow incoming ssh connections:

    $ sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

Or use the **System Preferences** > **Sharing** menu.

If you are going to enable sshd, at least disable password authentication and consider further [hardening](https://stribika.github.io/2015/01/04/secure-secure-shell.html) your configuration.

To `/etc/sshd_config`, add:

```
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
```

 Confirm whether sshd is enabled or disabled:

    $ sudo lsof -Pni TCP:22

## Physical access

Keep your Mac physically secure at all times. Don't leave it unattended in hotels and such.

A skilled attacker with unsupervised physical access to your computer can infect the boot ROM to install a keylogger and steal your password - see [Thunderstrike](https://trmm.net/Thunderstrike), for example.

A helpful tool is [usbkill](https://github.com/hephaest0s/usbkill), which is *"an anti-forensic kill-switch that waits for a change on your USB ports and then immediately shuts down your computer"*.

Consider purchasing a [privacy filter](https://www.amazon.com/s/ref=nb_sb_noss_2?url=node%3D15782001&field-keywords=macbook) for your screen to thwart shoulder surfers.

## System monitoring

#### OpenBSM audit

macOS has a powerful OpenBSM auditing capability. You can use it to monitor process execution, network activity, and much more.

To tail audit logs, use the `praudit` utility:

```
$ sudo praudit -l /dev/auditpipe
header,201,11,execve(2),0,Thu Sep  1 12:00:00 2015, + 195 msec,exec arg,/Applications/.evilapp/rootkit,path,/Applications/.evilapp/rootkit,path,/Applications/.evilapp/rootkit,attribute,100755,root,wheel,16777220,986535,0,subject,drduh,root,wheel,root,wheel,412,100005,50511731,0.0.0.0,return,success,0,trailer,201,
header,88,11,connect(2),0,Thu Sep  1 12:00:00 2015, + 238 msec,argument,1,0x5,fd,socket-inet,2,443,173.194.74.104,subject,drduh,root,wheel,root,wheel,326,100005,50331650,0.0.0.0,return,failure : Operation now in progress,4354967105,trailer,88
header,111,11,OpenSSH login,0,Thu Sep  1 12:00:00 2015, + 16 msec,subject_ex,drduh,drduh,staff,drduh,staff,404,404,49271,::1,text,successful login drduh,return,success,0,trailer,111,
```

See the manual pages for `audit`, `praudit`, `audit_control` and other files in `/etc/security`

**Note** although `man audit` says the `-s` flag will synchronize the audit configuration, it appears necessary to reboot for changes to take effect.

See articles on [ilostmynotes.blogspot.com](http://ilostmynotes.blogspot.com/2013/10/openbsm-auditd-on-os-x-these-are-logs.html) and [derflounder.wordpress.com](https://derflounder.wordpress.com/2012/01/30/openbsm-auditing-on-mac-os-x/) for more information.

#### DTrace

`iosnoop` monitors disk I/O

`opensnoop` monitors file opens

`execsnoop` monitors execution of processes

`errinfo` monitors failed system calls

`dtruss` monitors all system calls

See `man -k dtrace` for more information.

**Note** [System Integrity Protection](https://github.com/drduh/OS-X-Security-and-Privacy-Guide#system-integrity-protection) [interferes](http://internals.exposed/blog/dtrace-vs-sip.html) with DTrace, so it may no longer be possible to use these tools.

#### Execution

`ps -ef` lists information about all running processes.

You can also view processes with **Activity Monitor**.

`launchctl list` and `sudo launchctl list` list loaded and running user and system launch daemons and agents.

#### Network

List open network files:

    $ sudo lsof -Pni

List contents of various network-related data structures:

    $ sudo netstat -atln

You can also use [Wireshark](https://www.wireshark.org/) from the command line.

Monitor DNS queries and replies:

```
$ tshark -Y "dns.flags.response == 1" -Tfields \
  -e frame.time_delta \
  -e dns.qry.name \
  -e dns.a \
  -Eseparator=,
```

Monitor HTTP requests and responses:

```
$ tshark -Y "http.request or http.response" -Tfields \
  -e ip.dst \
  -e http.request.full_uri \
  -e http.request.method \
  -e http.response.code \
  -e http.response.phrase \
  -Eseparator=/s
```

Monitor x509 certificates:

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

Also see the simple networking monitoring application [BonzaiThePenguin/Loading](https://github.com/BonzaiThePenguin/Loading)

## Miscellaneous

If you wish, disable [Diagnostics & Usage Data](https://github.com/fix-macosx/fix-macosx/wiki/Diagnostics-&-Usage-Data).

If you want to play **music** or watch **videos**, use [VLC media player](https://www.videolan.org/vlc/index.html) which is free and open source.

If you want to use **torrents**, use [Transmission](http://www.transmissionbt.com/download/) which is free and open source (note: like all software, even open source projects, [malware may still find its way in](http://researchcenter.paloaltonetworks.com/2016/03/new-os-x-ransomware-keranger-infected-transmission-bittorrent-client-installer/)). You may also wish to use a block list to avoid peering with known bad hosts - see [Which is the best blocklist for Transmission](https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/) and [johntyree/3331662](https://gist.github.com/johntyree/3331662).

Manage default file handlers with [duti](http://duti.org/), which can be installed with `brew install duti`. One reason to manage extensions is to prevent auto-mounting of remote filesystems in Finder (see [Protecting Yourself From Sparklegate](https://www.taoeffect.com/blog/2016/02/apologies-sky-kinda-falling-protecting-yourself-from-sparklegate/)). Here are several recommended handlers to manage:

```
$ duti -s com.apple.Safari afp

$ duti -s com.apple.Safari ftp

$ duti -s com.apple.Safari nfs

$ duti -s com.apple.Safari smb
```

Monitor system logs with the **Console** application or `syslog -w` or `log stream` commands.

In systems prior to macOS Sierra (10.12), enable the [tty_tickets flag](https://derflounder.wordpress.com/2016/09/21/tty_tickets-option-now-on-by-default-for-macos-sierras-sudo-tool/) in `/etc/sudoers` to restrict the sudo session to the Terminal window/tab that started it. To do so, use `sudo visudo` and add the line `Defaults    tty_tickets`.

Set your screen to lock as soon as the screensaver starts:

    $ defaults write com.apple.screensaver askForPassword -int 1

    $ defaults write com.apple.screensaver askForPasswordDelay -int 0

Expose hidden files and Library folder in Finder:

    $ defaults write com.apple.finder AppleShowAllFiles -bool true

    $ chflags nohidden ~/Library

Show all filename extensions (so that "Evil.jpg.app" cannot masquerade easily).

    $ defaults write NSGlobalDomain AppleShowAllExtensions -bool true

Don't default to saving documents to iCloud:

    $ defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

Enable [Secure Keyboard Entry](https://security.stackexchange.com/questions/47749/how-secure-is-secure-keyboard-entry-in-mac-os-xs-terminal) in Terminal (unless you use [YubiKey](https://mig5.net/content/secure-keyboard-entry-os-x-blocks-interaction-yubikeys) or applications such as [TextExpander](https://smilesoftware.com/textexpander/secureinput)).

Disable crash reporter (the dialog which appears after an application crashes and prompts to report the problem to Apple):

    $ defaults write com.apple.CrashReporter DialogType none

Disable Bonjour [multicast advertisements](https://www.trustwave.com/Resources/SpiderLabs-Blog/mDNS---Telling-the-world-about-you-(and-your-device)/):

    $ sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool YES

[Disable Handoff](https://apple.stackexchange.com/questions/151481/why-is-my-macbook-visibile-on-bluetooth-after-yosemite-install) and Bluetooth features, if they aren't necessary.

Consider [sandboxing](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/sandbox-exec.1.html) your applications. See [fG! Sandbox Guide](https://reverse.put.as/wp-content/uploads/2011/09/Apple-Sandbox-Guide-v0.1.pdf) (pdf) and [s7ephen/OSX-Sandbox--Seatbelt--Profiles](https://github.com/s7ephen/OSX-Sandbox--Seatbelt--Profiles).

Did you know Apple has not shipped a computer with TPM since [2006](http://osxbook.com/book/bonus/chapter10/tpm/)?

## Related software

[Santa](https://github.com/google/santa/) - A binary whitelisting/blacklisting system for Mac OS X.

[kristovatlas/osx-config-check](https://github.com/kristovatlas/osx-config-check) - checks your OSX machine against various hardened configuration settings.

[Lockdown](https://objective-see.com/products/lockdown.html) - audits and remediates security configuration settings.

[Dylib Hijack Scanner](https://objective-see.com/products/dhs.html) - scan for applications that are either susceptible to dylib hijacking or have been hijacked.

[Little Flocker](https://www.littleflocker.com/) - "Little Snitch for files"; prevents applications from accessing files.

[facebook/osquery](https://github.com/facebook/osquery) - can be used to retrieve low level system information.  Users can write SQL queries to retrieve system information.

[google/grr](https://github.com/google/grr) - incident response framework focused on remote live forensics.

[yelp/osxcollector](https://github.com/yelp/osxcollector) - forensic evidence collection & analysis toolkit for OS X.

[jipegit/OSXAuditor](https://github.com/jipegit/OSXAuditor) - analyzes artifacts on a running system, such as quarantined files, Safari, Chrome and Firefox history, downloads, HTML5 databases and localstore, social media and email accounts, and Wi-Fi access point names.

[libyal/libfvde](https://github.com/libyal/libfvde) - library to access FileVault Drive Encryption (FVDE) (or FileVault2) encrypted volumes.

[CISOfy/lynis](https://github.com/CISOfy/lynis) - cross-platform security auditing tool and assists with compliance testing and system hardening.

## Additional resources

*In no particular order*

[Mac Developer Library: Secure Coding Guide](https://developer.apple.com/library/mac/documentation/Security/Conceptual/SecureCodingGuide/Introduction.html)

[OS X Core Technologies Overview White Paper](https://www.apple.com/osx/all-features/pdf/osx_elcapitan_core_technologies_overview.pdf)

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
