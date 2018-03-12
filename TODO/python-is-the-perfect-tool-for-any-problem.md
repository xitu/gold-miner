> * 原文地址：[Python is the Perfect Tool for any Problem](https://towardsdatascience.com/python-is-the-perfect-tool-for-any-problem-f2ba42889a85)
> * 原文作者：[William Koehrsen](https://towardsdatascience.com/@williamkoehrsen?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/python-is-the-perfect-tool-for-any-problem.md](https://github.com/xitu/gold-miner/blob/master/TODO/python-is-the-perfect-tool-for-any-problem.md)
> * 译者：[Ryden Sun](https://github.com/rydensun)
> * 校对者：[zephyrJS](https://github.com/zephyrjs) [lampui](https://github.com/lampui)

# Python 是解决任何问题的完美工具

![](https://cdn-images-1.medium.com/max/1600/0*UiI1SaCbMvovF2wh.)

**关于我第一个 Python 程序的反思**

反思一直是一个有帮助的（有时是很有趣的）训练。出于怀旧的目的 —— 如果一个人能够对某件事念念不忘两年 —— 我想要分享一下我的第一个 Python 程序。当时作为一名航天工程专业的学生，为了从那堆数据表中脱身，我开始用起了 Python，我当时并不知道这个决定会变得这么好。

我的 Python 自学是从由 Al Sweigart 写的 [Automate the Boring Stuff with Python](https://automatetheboringstuff.com/) 这本书开始的，这是一个本出色的基于应用程序开发的书，里面有一些简单的程序例子，但这些程序执行了一些很有用的任务。当我学习新东西时，我会寻找任何机会来使用它，因此我需要一些可以用 Python 解决的问题。幸运的是，我找到了学以致用的例子。这个课程需要 $200 的教科书，而我只想为这本书花 $20 (Automate the Boring Stuff 在网上是免费的)，我甚至拒绝去借这本书。在第一个作业之前基本是不可能得到这本书了，我发现在 Amazon 上新开一个账户，可以有一个星期的免费试看。我获得了这本书的一个星期使用权限并且可以完成我的第一个作业。虽然我可以继续一个星期创建一个新账户，但我需要一个更好的解决办法。这就进入了 Python 和我的第一个应用程序。 

_Automate the Boring Stuff_ 中有很多有用的库，其中一个是 [pyautogui](https://pyautogui.readthedocs.io/en/latest/)，它允许我用 Python 控制键盘和鼠标。俗话说，当你有一个锤子的时候，任何问题看起来都像是一颗钉子， 这句话绝对适合现在这个情景。Python 和 pyautogui 允许我按下方向键并且对屏幕截图，我把它们两个放到一起，一个针对书本的解决方案就出来了。我写的第一个程序就是自动地翻过电子书的每一页并且进行截图。最终的程序只有 10 行代码长，但我的自豪感超过了我在航天工程做的所有事情！下面是程序的完整代码：

```
import pyautogui
import time

# Sleep for 5 seconds to allow me to open book
time.sleep(5)

# Range can be changed depending on the number of pages
for i in range(1000):

 # Turn page
 pyautogui.keyDown('right')
 pyautogui.keyUp('right')

 # Take and save a screenshot
 pyautogui.screenshot('images/page_%d.pdf' % i)
 time.sleep(0.05)
```

运行这个程序很简单（我推荐每一个人都试一试）。我保存这个脚本名字叫 book_screenshot.py，然后我打开控制台，切换到同一个文件目录下，输入：

```
python book_screenshot.py
```

然后我有 5 秒时间翻到这本书并且进入全屏模式。 程序会先休息 5 秒，然后自动翻过每一页并且截屏，最后保存为一个 pdf 文件。我接下来可以把所有 pdf 文件汇总起来到一个 pdf 文件， 这样我了这本书的一个复件（不知是否合法）！诚然，由于不支持检索，这种复制方式很烂。但我还是会义无反顾地使用我的“书”。

![](https://cdn-images-1.medium.com/max/800/1*kxxaqXCHYHJbuURp6clKtA.gif)

我可以看上几个小时。

这个例子展示了两个在我数据科学学习中，一直困扰我的两个关键点：

1. [最好的学习新技能的方式就是找到一个你需要解决的问题](https://towardsdatascience.com/how-to-master-new-skills-656d42d0e09c?source=user_profile---------7----------------)！
2. 在一项技能有用之前，你不需要完全掌握它。

用简单几行代码和一本免费的电子书，我写了一个我会真实使用的程序。学习基础知识是单调乏味的，我学习 Python 的第一次尝试在几个小时后就失败了， 我陷入了那些数据结构和循环方法中。改变战略，我从开发解决真实问题的方案开始并且最终真的在过程中学会了这些基础知识。编程和数据科学有太多需要掌握的东西，但你不需要一次就学习所有的东西。挑一个你需要解决的问题并且直接开始！

从那以后，我做了几个[更精细的程序](https://towardsdatascience.com/stock-analysis-in-python-a0054e2c1a4c)，但我始终记着我第做一个脚本时的乐趣！

分享你的第一个程序！我欢迎大家的讨论，反馈和建设性的批评建议。你可以在 Twitter @koehrsen_will 上找到我。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
