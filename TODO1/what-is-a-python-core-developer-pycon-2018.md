> * 原视频地址：[Mariatta Wijaya - What is a Python Core Developer?- PyCon 2018](https://www.youtube.com/watch?v=hhj7eb6TrtI)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-a-python-core-developer-pycon-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-a-python-core-developer-pycon-2018.md)
> * 译者：[Elliott Zhao](https://github.com/elliott-zhao)
> * 校对者：

# Mariatta Wijaya —— 什么是 Python 核心开发人员？- PyCon 2018

> 本文为 PyCon 2018 视频之 Mariatta Wijaya - What is a Python Core Developer? 的中文字幕，您可以搭配原视频食用。

0:00  大家好，欢迎进入我们的下一个

0:02  议程，我对这个议程

0:06  感到非常兴奋。这个议程将会对

0:10  什么是Python核心开发者

0:14  进行非常棒的讨论。进行演讲的人是

0:17  我的好朋友玛利亚塔·维加亚。我们

0:23  发现我犯了一个错误。好吧，应该是玛利亚塔。

0:27  我们在之后不会有问答环节

0:30  不过我相信如果你找到她的话，

0:33  Marietta应该很乐意在会议的

0:35  休息时间中和你聊聊，她就会在

0:37  附近。那么，如果没有其他事情的话，玛利亚。

0:44  这很有用。好吧，欢迎来到我的

0:49  演讲。所以在我对我自己做更多

0:52  介绍之前，我想先介绍一下在座的各位。

0:55  因为我们都会在这同一个房间中

0:57  共处差不多45分钟的时间，我觉得我们

1:01  互相加深一下了解是个不错的主意。

1:05  我十分确信在这个房间中的每个人

1:06  都是用Python，对么？你至少使用

1:08  Python写过 hello world。没错！你还

1:12  使用 F-String ，没错！而且在座的所有

1:16  人都是Python社区的一员。

1:18  你们正在PyCon会议上和其他“Python家”进行

1:21  互动。 所以你们都是Python社区

1:23  中的一员。并且我相信你们中

1:26  的很多人都会通过向开源项目

1:29  贡献代码的方式回馈社区

1:31  可以让我看看有多少人

1:34  对任何一个开源项目做过至少一次

1:37  Pull Request ？给CPython？有很多人。

1:40  非常多的人。这实在是

1:42  太好了，简直太棒了。因此，我对各位

1:44  向开源软件和CPython贡献代码表示由衷的

1:46  感谢。

1:48  好的，现在来介绍一下我到底是谁。我真是很忙。

1:54  这是一个汇总。我的名字是

1:57  玛利亚塔，你可以在 Twitter 、 Github

1:59  上找到我。我是两个孩子的母亲，

2:02  两个都是儿子，一个七岁一个五岁。

2:04  我很久以前就搬到了加拿大

2:08  我现在住在温哥华，

2:11  为 Zapier 工作，所以首先

2:13  我想要感谢 Zapier 给予我不遗余力

2:16  的支持，派我到 PyCon 这里来发言

2:18  而对我的唯一要求就是让我穿上

2:22  这件企业文化T恤。所以感谢 Zapier 。

2:26  我们正在招聘，所以在明天的招聘会上

2:29  请关注我们一下，我也会在那。

2:31  在工作和家庭之外，我还

2:34  帮助组织了 Thank Goodbye

2:37   Ladies 。

2:37  另外我还参与组织了一个名叫

2:41  PyCascades的会议，它会在2019

2:44  年的某个时间在西雅图召开。

2:49  而最重要的是，我向开源项目

2:51  贡献代码，这对我来说

2:53  是一种新的尝试。我真正开始做这件事

2:56  是两年，当加入开源项目，

2:59  我感觉我真是个新手。 不过去年

3:03  不知为何他们赋予了我向CPython提交代码的

3:06  的写权限。我现在可以自称是一个

3:10  Python核心开发者了，而这个演讲都是

3:16  关于这件事。自从我成为一个

3:18  核心开发者，有很多人提出

3:20  像这样的问题：作为一个Python

3:23  核心开发者感觉怎样？感觉如何？他们怎样

3:25  才能成为一个核心开发者？因此，为了日后

3:30  免于回答所有的这类问题，

3:32  我要在这次演讲中

3:34  回答所有的这些问题。

3:36  下次我就可以直接把这个视频指给他们看。

3:39  为了帮助说明我的历程，

3:43  我借用了这张我去年在PyCaribbean

3:46  上罗素·基思 - 马吉博士的主题演讲

3:49   中看到的图表。他把这个

3:52  成为开源转换漏斗。

3:54  他是这么介绍这个图表的：

3:57  假设有一大群人作为

3:59  你项目的潜在用户，其中

4:02  一些潜在用户最终找到

4:03  你的项目并且开始使用这个项目。

4:05  然后一些新用户留存下来，

4:07  并变成了一些常规用户。一部分

4:10  常规用户留存下来，并且开始

4:12  参与社区，成为社区中的

4:13  一员。一部分社区成员

4:16  开始向项目贡献代码，

4:17  并成为了贡献者。一部分贡献者

4:20  坚持的时间足够长，

4:21  并最终成为了核心

4:23  团队，然后一些核心团队成为了

4:24  社区的领袖。

4:26  我从罗素·基思 - 马吉那里拷贝过来的！而且他的演讲

4:31  也非常的快。所以纵观整个演讲，我会

4:37  从这张图表开始，除了我会把它

4:41  上下翻转。我觉得整个历程

4:44  更像是爬上阶梯或

4:47  在食物链中上升，

4:49  而不是像那样下行。

4:51  而且我不会区别对待

4:56  潜在用户和新用户，我们仅仅

4:59  讨论所有的Python用户。

5:02  然后再领袖的位置，是

5:06  BDFL。而在我的观点来看，

5:10  核心团队也充当了社区领袖

5:12  的角色，这个之后我会详细说。

5:15  而这就是我对我的历程

5:19  的感受。我开始作为一个用户，

5:21  我使用Python，然后我开始

5:24  参与到社区中，参加

5:27  会议，我参加PyCon，我参加

5:29  聚会，然后我开始向开源

5:31  项目贡献代码，然后最终他们给

5:34  了我提交权限，然后我就成为了

5:37  核心团队的一员，而这我认为成为BDFL

5:40  就是旅行的终点，没有人

5:43  会取代他，他会永远都在周围。

5:45  永远。现在我们回到问题：

5:52  什么是Python核心开发者？

5:56  技术上来讲，这意味着你拥有

5:59  向CPython提交代码的权限，现在

6:02  在全世界范围内有89个人。

6:06  这门有着编程语言七百万用户的

6:08  编程语言，有89个人拥有

6:11  这种提交权限。还有一些

6:17  不错的福利，所以我得到的

6:19  有在bug跟踪紧挨着我的名字这个很酷的

6:23  Python标志。 我来到Python语言

6:27  峰会，可以享受免费入场和

6:29  免费午餐。

6:30  而这，在美国每年召开的PyCon上都会发生。

6:34  我会来买一些Core Sprint，

6:36  呃，这似乎每年都在发生。

6:39  我真心希望它成为

6:41  每年一度的传统，但是一旦

6:47  你被授予了提交权，一些

6:50  责任也就随之而来了。 您将被

6:53  添加到github上的Python核心

6:57  团队。然后你就要加入……你会

7:00  负责17个存储库。

7:03  可见的有CPython，开发指南，

7:07  peps，我们的工作流，性能，

7:10  以及我们所有的github机器人。您将被期望

7:14  订阅并参与各种

7:17  Python邮件列表。Python运营我们的

7:20  邮件列表。所以，这意味着你会得到

7:24  数以千计的电子邮件。我就收到过这么多

7:28  邮件。我收到数以千计的邮件，我的

7:29  邮箱被塞得满满的，我必须弄清楚该做什么。

7:33  所以你将不得不学习如何去管理

7:36  你的邮件。 我之前说过你会

7:42  负担起很多责任。我之前说到的

7:43  责任就是指这个。

7:47  一般来讲，你会不得不去

7:50  Review一大堆Pull Request。直到今天为止，

7:53  还有超过600个Pull Request仍处在打开状态。

7:56  你还需要做决策，决定你是否

7:59  接收这些PR，

8:01  抑或说No。在过去的一年里，核心

8:06  开发者已经关闭了超过6000个

8:10  Pull Request，这是很繁重的工作。

8:14  当你接受Pull Request时，

8:17  你必须做好准备面对

8:19  后果。我是说，如果一切

8:24  正常，这是一个正确的决定，一般来说

8:26  没有人会说什么。然而一旦这是

8:29  一个错误的决定，它实际上会

8:33  搞坏东西，引入BUG，

8:36  合并Pull Request的人

8:40  将不得不负担起责任。你将

8:43  负责并且跟进，并且尝试去

8:45  解决问题，仅因为是你合并的它。

8:48  所以这是一个非常巨大的责任。然后

8:55  你还要帮助人们

8:57  向CPython贡献代码，因为

9:00  你知道怎么贡献代码，你知道

9:02  你想要什么，而且因为你有

9:07  CPython的提交权限，

9:08  所以你可以作出决定，你可以告诉

9:11  别人什么东西可以进入Python，什么东西

9:15  不能。你可以塑造这门语言的形状，

9:21  决定它如何发展。这是一个非常巨大的

9:25 责任, 这使你成为

9:28  Python语言和社区的

9:34  代表和领导者。对，这里有一个

9:39  BDFL。他做出许多

9:42  重大决定，但是他从

9:46  核心开发者那里获取信息。他也很依赖我们，

9:48  他把很多事情交给核心

9:51  开发者。通常他仅仅说我想要

9:53  这些事情发生，然后核心开发者们就会让

9:55  它发生。

9:56  所以，我们是他的助手，我们是

9:58  他的二把手。核心开发者是

10:02  社区的领袖。现在我

10:06  已经针对”作为核心开发者是

10:08  怎样一种体验？“说了很多，但是大家还是

10:12  有非常多的问题。所以我要一个一个

10:14  地回答他们。这是我遇到的出现频率

10:19  最高的问题中的一个。一个我刚刚

10:21  认识的新用户或者什么人，问我

10:26  他们怎么才能成为一个核心开发者。不过这是一个

10:31  非常大的问题。向一个普通用户

10:34  解释这个概念很难。因此我

10:38  准备先回答一些特别简单的

10:40  问题。怎样让某个人积极的

10:44  参与社区。这非常

10:48  简单，因为有很多种途径

10:51  让人变得更积极。任何人都可以参加。

10:54  你可以从本地开始，帮助你的本地的

10:58  Python聚会。我组织聚会，所以我知道我们一直

11:02  在寻求帮助。我们一直寻找

11:04  演讲者，提供工作室或是教学。

11:07  所以如果你想帮忙，请联系

11:10  当地的聚会组织者，告诉他们

11:14  我想发表演讲，我可以提供场地

11:17  供你们举办聚会。帮帮他们。

11:20  如果没有聚会，

11:21  自己举办一个。如果你不喜欢举办

11:25  聚会，这对你来说有点过，

11:27  没问题， 你可以写一些关于Python的

11:30  博客，向全世界分享你

11:33  如何使用Python。 写下你最喜欢的

11:35  库，写一篇教程，或者单纯的把

11:38  Python的知识传播给每个人。

11:41  在会议上做志愿者，这是

11:44  回馈社区的好方法，

11:46  尤其是在PyCon。

11:50  PyCon会议依靠志愿者，

11:55  每当你与其他社区成员

11:58  互动时，永远都要

12:00  做一个开放，体贴和尊重他人

12:04  的好人。 下一个问题：如何

12:10  为开源项目做贡献？有很多中途径。

12:15  加入沟通渠道，

12:18  加入他们的邮件列表，

12:19  IRC，Gitter，Slack。只要能认识

12:23  其他的贡献者和

12:25  项目的维护者就行。通过报告问题提供帮助，

12:29  告诉我们如何重现您

12:31  遇到的错误，提出新的想法，帮助

12:36  完善文档。这很真的重要。

12:39  我参与过的所有项目，

12:42  都真的可以从文档中寻求

12:45  帮助。检查Pull Request，

12:48  并再次与其他贡献者

12:50  进行交互。要永远做一个善于体谅和尊重

12:55  别人的好人。那么，

13:00  通常在我回答所有这些后，下一个

13:04  后续问题总是：好吧，

13:08  其实我只是想贡献

13:11  代码而不是文档。也许我可以

13:15  从文档开始，

13:15  但最终我想贡献

13:18  代码。告诉我怎么做。好吧，我想

13:23  大家都有这个愿望——

13:26  贡献代码。

13:29  当然。如果目标是

13:32  贡献代码，您必须先阅读

13:35  贡献指南。每个大项目

13:38  都有一个，每个项目都

13:41  有不同的指南，不同的工作流程。你

13:43  必须首先阅读这些，然后找到一个

13:47  问题来处理，然后你必须

13:50  学习如何使用版本控制，

13:53  如git，然后创建一个拉请求。

13:59  那么下一个后续问题是：

14:01  好的Mariatta，因为你是Python核心

14:04  开发者，请更具体一些，

14:07  告诉我如何为CPython

14:11  贡献代码。这是最大的

14:14  秘密，每个人都想知道，

14:17  我原来也想知道。我在两年前

14:21  向BDFL提出了同样的

14:24  问题。所以我只是要给你们

14:27  讲讲他怎么告诉我的。首先阅读

14:33  开发指南，它真的有你

14:36  需要知道的一切。开发指南告诉你

14:38  如何获得源代码，如何使用

14:41  git，我们的邮件列表在哪里，如何

14:44  运行测试，如何编译...他对我

14:47  说的所有话就是：这里是开发指南的网址，

14:50  读一遍。接下来，他告诉我加入

14:55  核心指导和Python研发邮件

14:58  列表，如果我有任何

15:00  疑问，只需在邮件列表中提问即可。

15:03   他说，只要告诉他们圭多让你来的。

15:06  好吧。

15:09  真的。 所以我写给邮件列表

15:12  的前几封电子邮件

15:13  都是这么开始的：嘿，我问圭多这件事，

15:17  他告诉我写信给你。 

15:20  所以这是我的问题... 然后他给我指出

15:25  错误跟踪器，这是你应该

15:28  找到问题去解决的地方。 然后说

15:31  多简单的问题，创建

15:36  一个补丁，修补它并提出请求，

15:38  所以这些都是圭多告诉我的。 很简单，

15:44  就像听起来那样。 他从来没有真的

15:48  给我任何问题让我处理，

15:51  他从来没有给我分配任何东西，因为

15:52  他不知道我对哪方面更感兴趣。

15:55  所以我必须

15:59  自己学习的东西，所以我开始订阅

16:03  更新和错误跟踪器，

16:05  所以我在每当有新活动时都会收到

16:09  邮件。然后我尝试阅读其中

16:13  的一些内容，找到对我感兴趣的任何内容，

16:16  然后开始研究，并找出如何解决

16:20  这个问题。now at that time

16:28  people that start asking me well since

16:31  you've been following the bug tracker

16:33  maybe you can find me an issue to work

16:36  on all right give me some time because

16:43  in order to really find an issue I have

16:46  to really really watch the bug tracker

16:49  recent some of the issues that I thought

16:52  could be interesting to you and then

16:54  still ask you whether you're interested

16:56  and you might not actually want to be

16:58  interested so I think I feel that this

17:03  is finding an issue to work on is a

17:06  skill you're going to have to acquire to

17:09  learn and it's going to take time so you

17:14  shouldn't be relying on me or maintainer

17:18  to assign you an issue it just doesn't

17:21  work like that

17:22  so so perhaps people want to hear what

17:28  I've been contributing what are my open

17:31  sort of contributing contributions for

17:34  inspiration for examples except I really

17:39  don't think I've had many meaningful

17:42  contributions

17:43  I fix a lot of typos really this this

17:48  was one of my first contribution to open

17:51  source and one will change this is how I

17:53  started two years ago I really fix a lot

18:02  of typos I was reading a pap saw typos

18:05  fixing really the moral of the story is

18:13  my contributions have been accidental

18:17  like I was it wasn't intentional but it

18:19  wasn't really goal I was learning I read

18:23  the docs trying to learn how to use it

18:26  so problems and I take them I contribute

18:33  very little code to see Python and

18:36  that's something that seems like

18:39  everybody expects core developers to be

18:42  contributing code a lot of code well I

18:45  don't I write documentation I write to

18:49  fight on the developers guide my github

18:53  bought right even more code than I have

18:57  ever done to see Python so if if you use

19:01  iPhone 3 6 4 or 3 6 5 you're likely

19:06  using code generated by my github bot

19:09  and I I participate in mailing list help

19:12  answer questions and I like to review

19:16  pull requests I try to prioritize

19:19  reviewing pull requests from first-time

19:22  contributors because I want to be the

19:25  one to congratulate you on your first

19:28  pull request to see Python so that's

19:30  that's how I've been contributing

19:36  and there are lots of open-source

19:40  projects out there that really could use

19:42  help

19:43  I just contribute to tools I use in love

19:46  I contribute to Colin

19:49  I made a contribution to warehouse a

19:51  couple months ago I use github and a

19:55  HTTP for my BOTS so I started

19:57  contributing them to really like look at

20:02  your requirements txt file and think of

20:06  contributing them don't be fixated in

20:10  contributing just to see Python there

20:12  are a lot of open source projects now

20:17  once people start contributing to see

20:20  Python they they all have the same

20:22  questions please when can you review my

20:28  PR I'm sorry I'm really sorry that I

20:34  haven't got around reviewing your PR and

20:38  now let me share you some numbers since

20:42  the migration to get up February 2017 we

20:47  have more than 65,000 pull requests we

20:51  have closed a lot of them like more two

20:55  days I think we merged 5200 the thing is

20:59  that I'm just there's so many of you

21:01  there are so many people contributing

21:04  more than 800 in the last year there are

21:10  even though there are close to 90 core

21:14  developers only half of them are still

21:17  active in the last year so we just don't

21:23  have enough time to review everything so

21:26  I'm really really sorry

21:28  but there are other reasons in addition

21:31  to not having enough time sometimes it's

21:35  just not my expertise I don't think I

21:37  should be reviewing it I think it's

21:38  something for other color weapons to

21:40  review that's why I haven't review it or

21:44  maybe I just

21:46  it sounds bad I just didn't care it's

21:50  it's it's not my interest area and I

21:54  didn't ask for this change you went

21:57  ahead and cleared up er anyway so i'm

22:00  sorry and i know i when i want to read

22:04  jack appear i'm supposed to explain to

22:07  you why i am rejecting it but a lot of

22:12  time I have no good reason I just don't

22:14  want it I don't I'm sorry that I find it

22:20  easier to just abandon it and leave it

22:24  to the next core developer to review

22:28  then to actually say no to you so again

22:32  I'm sorry I'm also Canadian so and as

22:41  I've mentioned a real accepting a peer

22:44  comes with certain consequence and I

22:48  don't always want to accept such

22:52  responsibilities again sorry okay let's

22:59  go back to this really really difficult

23:00  question how to become a Python core

23:03  available this is big and and it's

23:07  hardly involve multiple stages but I've

23:11  explained to you how to get involved in

23:14  the community and how to start

23:16  contributing and I've explained what are

23:19  the responsibilities of Python core

23:22  developers so kind of broken those apart

23:28  into smaller questions this is a much

23:34  smaller scope how can a contributor to

23:38  see Python become a Python core

23:41  developer now when we want to promote

23:45  somebody to be a core developer we have

23:49  one really big question can we trust

23:57  this person

23:59  you're going to be when we give you

24:02  commit right to see Python you will be

24:04  responsible for programming language

24:06  used by seven million people and if you

24:13  do inspire to be Co developer you need

24:15  to earn our trust and there is no other

24:20  way for us to learn to trust you

24:23  other than actually interacting with you

24:27  and these interactions can be in a form

24:30  of you contributing you're participating

24:33  in mailing list you made pull requests

24:36  you review pull requests for us the more

24:39  you do those the more we get to know you

24:42  the more we know you the more we can

24:46  learn whether to trust you or not and

24:50  then you're going to have to accept all

24:53  the responsibilities I've said that and

24:57  above all we do need to know that you're

25:01  a good person that you'll be kind be

25:05  open considerate and respectful to other

25:09  core developers and to other

25:11  contributors now a lot of people then

25:20  ask me well how did you do all this how

25:22  did you earn the trust how did you

25:26  become core developer I really don't

25:29  know don't don't ask me I I I really

25:32  don't know this is a question you need

25:34  to ask to other core developer at v--

25:36  for me I really just feel lucky so a

25:40  squid or a snake as Brad Raymond they

25:46  they know why I why they trust me I

25:48  don't I really just feel lucky how much

25:56  time I spend contributing way too much

25:59  time then I'm willing to admit so I

26:04  realized I had too much time in the open

26:08  source so in the past two months I've

26:10  taken a break sighs

26:12  I'm not contributing until the end of

26:14  the month and um except for the days

26:18  when I'm at PyCon and at the spring

26:22  way too much time so this people do ask

26:32  me this and it always feels like a trick

26:34  question I asked this

26:39  couple days ago here at this conference

26:41  I got asked when I was at PyCon it tell

26:45  ya I was asked when I was at PyCon

26:47  Australia people around the world are

26:49  curious no I don't I don't get paid to

26:56  contribute to Python

26:57  my salary is zero and as the core

27:02  developer I don't receive salaries very

27:07  few core developers are getting paid

27:10  some kauravas got paid to contribute but

27:14  not full-time they still put in a lot of

27:17  personal time into Python another big

27:24  mystery how do i balance all of this III

27:30  don't know I do not have balance I

27:34  forget a lot of things I keep forgetting

27:37  to take my vitamins I run late

27:39  appointments and I double booked

27:41  appointment I don't have things I don't

27:45  have my life all balanced I don't know I

27:52  thought I was done with the big

27:54  questions but I ask this question every

28:00  day some kordell's has asked me the same

28:05  question the VFL asked me this question

28:10  how can we get more women to contribute

28:13  to open source

28:18  let me first share some numbers

28:24  Python has seven million users and I'm

28:27  pretty sure it's a very diverse set of

28:29  users and our communities is diverse

28:34  I see our even here at PyCon I see many

28:38  women participating I see lots of people

28:40  of color

28:41  I see disabled people I see

28:44  transgender people I see diversity in

28:48  this conference and I think we've done a

28:50  great job at that so now let's look at

28:55  the contributors to cpython

28:59  I've told you we have more than 800

29:01  contributors in the last year a lot of

29:09  out of all those 800 less than 10 or

29:16  women no 10% 10 individuals we have a

29:26  team and core developers only two women

29:37  I let the shock wears off because this

29:46  is real but this is also wrong this is

29:53  not the right representation of our

29:57  community this is not leadership

30:03  qualities you should not try to achieve

30:08  this you should try to avoid this kind

30:12  of statistics in your own organization

30:18  this is this is a problem and I'm

30:21  putting this out there so that you can

30:26  see what I've been seeing in the last

30:31  year I see a gap a really huge gap and I

30:40  don't know what to do about it

30:41  I need help I really don't know what I

30:46  need to do so asking me I ask this to

30:51  myself how to get more women

30:53  contributing and I I really don't know

30:56  if people know of another large open

31:00  source project with seven million users

31:02  that is doing good with diversity tell

31:06  me about it it's like a little I don't

31:08  know and I I care so much about this I

31:14  tried to get professional advice I ask

31:18  sharp and I've explained to them the

31:22  situation and I ask if they have an

31:25  advice and what can I pass on core

31:30  developer do to improve the diversity in

31:34  the community so they gave me some

31:40  advice they said I need to identify the

31:43  problems and they also told me that it's

31:47  not something I can do on my own

31:50  I'm going to need all the corners to

31:53  participate and work on improving

32:01  identifying problems I really had to ask

32:08  myself like what are their barriers what

32:16  are the bearings that applies only to

32:19  women that somehow 800 men were able to

32:25  contribute to cpython and only so few

32:29  women the there are lots of problems and

32:35  for me personally I've I faced the same

32:39  barriers I'm not gonna say all of them

32:43  here but one of the barriers was I

32:51  didn't have any role models I didn't see

32:55  anyone who looked like me

32:59  participating in open source for a long

33:03  time I believed it's just maybe I

33:07  shouldn't be doing maybe it's just not

33:09  the place for people like me and it it

33:16  was a huge barrier that I had to

33:18  overcome and I just feel so lucky that

33:22  there are members of this community that

33:26  the BDF algorithm and my son core

33:29  developers have always been there for me

33:31  supporting me helping me throughout this

33:34  Tamia I I just felt like it so thank you

33:39  all but we we have to do better and the

33:44  core developers do want to do better

33:46  they've acknowledged that there is still

33:49  diversity problem in our community and

33:56  during the language summit few days ago

33:58  after the core developers that they need

34:01  to take part

34:02  I've taught them that going forward

34:05  they're going to have to do at least one

34:08  of the following they're gonna have to

34:11  provide mentorship prioritizing women

34:14  and the underrepresented group members

34:16  they could try to set up office hours

34:19  AMA citizens one-on-ones and I've made

34:24  them understand that public forums like

34:28  mailing lists are always the safe space

34:32  for women and minorities to ask

34:35  questions so I've told them they're

34:40  going to have to be available to answer

34:43  questions in private so and the quarter

34:48  levels have been very receptive they are

34:50  all on board and we are working harder

34:54  to try to be more welcoming to women and

34:57  minorities still iirc is there anything

35:03  more I could have done to help improve I

35:08  mean I've always been available

35:10  privately my DM is always open six

35:15  suggests that maybe I could start

35:17  sharing more of my experiences I thought

35:20  I have but she said it they said it

35:25  could inspire me maybe it could inspire

35:27  other women I don't know I don't think

35:31  I've done anything spectacular I fix

35:34  typos but if sharing my stories can help

35:38  then I will try so oh my my name is Mary

35:44  era I like and strings and you really

35:47  really want to hear my stories you have

35:49  to follow me on Twitter that's where I

35:51  will be sharing my stories if you wanna

35:53  reach out privately that's my email and

35:56  when I have really really long stories I

35:59  might just post them on my website that

36:02  is all thank you so much for listening

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
