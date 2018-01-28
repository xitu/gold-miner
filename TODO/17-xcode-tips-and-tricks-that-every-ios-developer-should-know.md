> * 原文地址：[17 Xcode Tips and Tricks That Every iOS Developer Should Know](https://www.detroitlabs.com/blog/2017/04/13/17-xcode-tips-and-tricks-that-every-ios-developer-should-know/)
> * 原文作者：[Elyse Turner](https://www.detroitlabs.com/blog/author/elyse-turner/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/17-xcode-tips-and-tricks-that-every-ios-developer-should-know.md](https://github.com/xitu/gold-miner/blob/master/TODO/17-xcode-tips-and-tricks-that-every-ios-developer-should-know.md)
> * 译者：
> * 校对者：

# 17 Xcode Tips and Tricks That Every iOS Developer Should Know

![](https://dl-blog-uploads.s3.amazonaws.com/2017/Apr/dual_screen_1745705-1492006265590.png)

Xcode can be overwhelming to iOS developers, especially newbies, but fear not! We are here to help. The number of things that Xcode can help with and allow you to do is astronomical. Being familiar with your IDE is one of the easiest and best ways to sharpen your skills.

Here at Detroit Labs, we are no strangers to battling the mighty, mighty Xcode, and wanted to share our battle stories with you! After polling the Detroit Labs iOS developers, here are 17 of our favorite Xcode tips and tricks.

**Key Reference:**

* `⌃`: Control
* `⌘`: Command
* `⌥`: Option
* `⇧`: Shift
* `⏎`: Return

* * *

**1)** Moving a full line or many lines of code up or down using: `⌘ ⌥ {` to move up and `⌘ ⌥ }` to move down. If you have text selected, Xcode will move each line containing your selection; otherwise, it’ll move the line the cursor is in.

**2)** Using tabs to stay organized/focused. Tabs can be configured individually and optimized for different use cases. Tabs can also be named and later used in behaviors.

**3)** Using behaviors to display contextually helpful panes.

* Behaviors are essentially preferences for what Xcode does in response to certain events. Say you started a build; you can set a preference to open a pane in response to it succeeding, failing, starting to be debugged, etc.
* **Fun fact:** You can play a sound as a behavior when your tests fail. A developer here likes to set theirs to the failure sound from “The Price is Right.”

**4)** Open the file in the Assistant Editor. When using “Open Quickly” (`⌘ ⇧ O`), hold `⌥` while also hitting return.

**5)** `⌘ ⇧ ⌃ ⌥ C` when the cursor is inside a method performs the “Copy Qualified Symbol Name” command, which copies the method name in a nice, easily-pasteable format

**6)** Effectively use inline documentation that can be parsed by Xcode to provide help when `⌥` clicking on code/methods.

**7)** Edit the name of a variable everywhere it appears in scope by hitting `⌘ ⇧ E`.

**8)** Are you in a folder in Terminal and aren’t sure if your project uses Xcode workspaces or just a project file? Simply run “open -a Xcode .” to open the folder itself and Xcode will figure it out. Protip: Add this to your .bash_profile with a saucy name like ‘workit’ to feel like a real hacker.

**9)** Shortcuts for showing and hiding things in Xcode.

* `⌘ ⇧ Y`: show/hide debug area
* `⌘ ⌥ ⏎`: show assistant editor
* `⌘ ⏎`: hide assistant editor

**10)** Auto-indent code by hitting `⌘ A ^ I`

**11)** [LICEcap](http://www.cockos.com/licecap/) is really useful for making gifs of the simulator. It’s great for PR screenshots. On top of LICEcap, you can use QuickTime to share your hardware device on your screen (for a demo, or to use LICEcap to make a gif). With your iPhone or iPad plugged in, open QuickTime Player and go File -> New Movie Recording. Then tap the down arrow next to the record button and select your connected device. This is useful for remote client demos, using LICEcap to make a gif, or actually recording your device for a PR. ![](https://dl-blog-uploads.s3.amazonaws.com/2017/Apr/Screen_Shot_2017_04_12_at_11_41_31_AM-1492011708141.png)

**12)** Hitting `⌥ ⇧` then clicking on a file in the Project navigator opens a selection box to allow you to choose where to open a file.

**13)** Hold `⌥` and click a file in the Project Navigator and it opens the file in the Assistant Editor.

**14)** Think of the Navigator pane (which shows up on the left side of the Xcode window) as the “Command” pane. That’s because holding `⌘` and pressing a number opens the corresponding “tab” within that pane. For instance, `⌘ 1` opens the Project Navigator. `⌘ 7` opens the Breakpoint Navigator. Similarly, think of the Utilities Panes as the “Command+Option” pane. `⌘ ⌥ 1` opens the first tab in that pane, the File Inspector.

**15)** `⌥ ⌘ ↑` and `⌥ ⌘ ↓` navigates among related files (e.g. .m and .h and .xib files).

**16)** If you're fighting with code signing and Xcode tells you that you don't have a valid signing identity that matches the provisioning profile, it may show you a seemingly random code that may not look to mean much. Find-identity is useful for finding this. Security find-identity -v shows installed valid identities.

**17)** Finding a file folder in your folder hierarchy is a HUGE waste of time. In Xcode 8, you can use the “Open Quickly" dialog or `⌘ ⇧ O` to save some time. When it’s open you can type any part of the file name you are looking for to find it.

Are you an iOS developer? See what it’s like to work here, and if you’re interested, [apply](https://detroitlabs.workable.com/j/F1D69FF0B5)!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
