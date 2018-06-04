> * 原视频地址：[Graham Dumpleton - Secrets of a WSGI master. - PyCon 2018](https://www.youtube.com/watch?v=CPz0s1CQsTE)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/secrets-of-a-wsgi-master-pycon-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/secrets-of-a-wsgi-master-pycon-2018.md)
> * 译者：
> * 校对者：

# Graham Dumpleton - Secrets of a WSGI master. - PyCon 2018

> 本文为 PyCon 2018 视频之 Graham Dumpleton - Secrets of a WSGI master. 的中文字幕，您可以搭配原视频食用。

0:01	so welcome this is grand

0:09  thank you so thank you everyone for

0:21  always challenge sometimes at least I'm

0:26  everyone half the time everyone's gone

0:29  so my background if you're not familiar

0:37  been involved with the whiskey and what

0:42  shortly after when it was created I've

0:48  around it so the point of this talk is

0:52  wisdom which I've accumulated about

0:58  Maude whiskey which is the might Apache

1:05  run your Python web application with

1:10  and things a lot along the way and also

1:15  may not have known about around Maude

1:18  work with it over the last few years

1:23  much or said much about it and so you

1:29  what is whiskey I call whiskey now I

1:34  means is web server gateway interface

1:41  a Python web application with a web

1:48  bridge between those two now importantly

1:54  interface so when I have this picture

1:59  WSGI whiskey HTTP is a wire protocol

2:06  programming interface and I see a lot of

2:10  in trying to understand it

2:15  thing worth pointing out that whiskey is

2:20  a specification and it's defined by pep

2:25  an update related to Python free called

2:31  everything confusing so it's not an

2:37  author of mod whiskey you'll often see

2:41  whiskey that's actually confusing

2:45  talking about mod whiskey or they're

2:49  behind it as a using Apache as a proxy

2:53  about implementation use the name so use

2:57  or guna corn you whiskey and so on

3:02  program look like for whiskey this is it

3:07  object to function in this case and for

3:12  environ

3:16  the HTTP headers but also information

3:21  as the remote client IP address and

3:27  then the job of that whiskey application

3:32  it's going to generate a response and a

3:39  HTTP response and a request body start

3:45  and then we're doing to actually return

3:50  lots of traps and pitfalls of writing

3:54  simple but when you start to actually

3:58  construct and try to create a whole

4:02  introduce whiskey middleware and other

4:06  requesting the request content and it

4:13  suggestion is friends don't let friends

4:18  frustrating to see a lot of people on

4:21  trying to understand this I don't

4:26  with

4:29  think you're getting it's whiskey steer

4:35  save them a lot of trouble because they

4:40  documentation for a start which explains

4:45  but do provide an interface on top of

4:49  things and ensures that things are

4:55  using one of those frameworks you still

5:00  they are a framework to help you build

5:05  such as Jango and flask they do provide

5:11  a development whiskey server it's not

5:18  do have them do not use them and this is

5:22  what's called we call production grade

5:26  attributes that a production grade

5:30  development service don't

5:34  about mod whiskey with Apache we have

5:40  main free there's also tornado and knock

5:45  which is straight whiskey server and

5:49  tornado which is not really a strictly

5:54  asynchronous web server but they do have

5:58  main ones you'll see Apache mod whiskey

6:05  whiskey is traditionally been seen as

6:11  day when everything started up with when

6:16  like download the source code for mod

6:20  tar ball you had to go and do a

6:24  install step and then you still had to

6:28  then configure it for your application

6:32  that I wrote a lot of Doc's

6:37  even if you read them it'll still

6:41  things were slightly better when the

6:44  mod whiskey you could at least go

6:49  it in but you still have to configure it

6:55  are a bit easier because one of the

6:59  now is they don't necessarily have an up

7:03  a situation and not too fond ago that

7:08  mod key whiskey which was 5 years old it

7:15  me nuts you know when I was be

7:18  versions ago so what a lot of people

7:23  actually possible to build mod whiskey

7:29  still have to have a patchy installed

7:32  package installed for your operating

7:36  pull down the source code and it will

7:40  whiskey module that is built into the

7:44  you're using but that's not all

7:50  patch with mod whiskey from the command

7:55  go in and configure Apache to load it

8:01  go to mod whiskey Express start server

8:05  it's going to do startup Apache for me

8:11  single line of configuration and that

8:16  of people this does it all for you so

8:21  core now I can run it from the command

8:26  default it'll go in and set up the

8:33  itself and do it with a set of

8:38  really good starting point and this is

8:43  around for over 10 years and like with a

8:46  decisions early on which you think are

8:52  decision you can't

8:56  been a really good thing for me because

8:59  because I'm automatically configuring it

9:03  experience from how people used mud

9:07  configuration which isn't actually the

9:11  would be if you using Apache yourself

9:14  so I've done a lot better you can learn

9:20  slides will talk about some of that that

9:26  you're using Django though we can make

9:31  your Django settings module you can add

9:39  installed apps and that's just going to

9:43  can run with the managed up I so I can

9:48  it will start up django app just like if

9:53  server but in this case it's using mod

10:00  you'll now have a production grade

10:04  server now you may be saying well why

10:09  server is really useful in development I

10:15  you might think well no point okay but

10:20  want the default to be a production

10:25  want say reload uncle changes that means

10:29  source code it will automatically

10:33  on the next request okay so you still

10:37  use this for development those used to

10:42  ever would ever use mod Wiis can develop

10:45  to set up a pesci and to go and manually

10:49  change so with this you don't need to

10:54  the mod whiskey Express supports and one

11:00  so if you want to start debugging in PDB

11:08  exception occurs you can actually run

11:12  you into the Python debugger to actually

11:16  various other commands for tracking or

11:20  requests so you can actually look at all

11:24  responses and response content for every

11:27  start debugging at that level and

11:33  from the command line we've with Jango

11:37  to production all I need to do is run

11:45  run mod whiskey I need a place in to

11:49  looking closely when I ran this before

11:53  with the generated configuration for a

11:56  it in a better location so that a cron

12:00  from slash temp on us so we'll give it a

12:04  directory so I'm gonna run this command

12:08  port 80 that means it's a privileged

12:12  so that's why I'm specifying a user and

12:16  application knows when it starts and I

12:21  and it will generate the config but not

12:27  my config and it's not gonna be

12:32  that generator config is an Apache CTL

12:37  normal Apache installation but this one

12:40  conflict and I can do start restart and

12:47  init scripts in my system setup or using

12:52  the box starts now very very important

12:57  about that generating configuration it

13:02  configuration okay it's generating it

13:07  totally isolated config so if you were

13:12  on your system for something else it

13:16  thing is if you do want to run it this

13:22  but you wouldn't actually enable it in

13:26  because we want this one to take over

13:30  going from development being able to run

13:36  put it in your system init files and

13:40  Apache on your box although those

13:46  primarily involving Django if you're not

13:50  thing starts over risky script file I

13:57  things about how the Django integration

14:02  the capatch II configuration required to

14:09  that when you access the slash static

14:14  you now in this case on running a

14:18  can still do that by using this URL

14:23  in my static directory here I want to

14:27  bunch of other options available you can

14:31  Fred's and lots of other things to do

14:39  responding to headers for proxy

14:42  behind a proxy for example there's all

14:46  know about any of the information you

14:50  helpful information not as long as the

14:56  it's not as complicated diver is trying

15:01  so latest rage these days actually is

15:07  reasons that I went and created mod

15:11  because of what was happening in the

15:15  Apache with mod whiskey in a docker file

15:21  as messy as if you're doing it on your

15:25  because you couldn't do it manually by

15:28  generation of all config to integrated

15:33  actually one of the reasons why I did

15:36  using this with docker not too hard

15:41  docker base image you're going to

15:47  importantly if you have don't work with

15:51  this problems of Unicode so we can fix

15:54  we people install mod whiskey and we set

16:01  and because we're in a docker container

16:04  that we can capture those locks ok

16:11  we can build that for look at our docker

16:15  straightforward but if you have used

16:20  I don't know how many people aware of

16:24  understood had docker builds work that

16:27  was running as root inside of that

16:32  say hey so he's going to admit that they

16:36  please don't do that

16:41  of isolation but the important things

16:45  as many layers of security as you can if

16:51  vulnerability found in the container

16:54  hosts they're already root so trees

16:59  about that very simple docker file is I

17:03  if you're using docker you might think

17:06  because I'm the only thing using it

17:11  because there are a lot of issues that

17:14  packages into a system Python if this

17:19  packages to support the operating system

17:23  that so a better docker file might start

17:29  do things this and I'll you'll note that

17:34  get to why in a moment we can create our

17:40  off the docker file make sure doing

17:45  are a non reducer we can't use port 80

17:49  when we run the container now thrown in

17:54  just put in here

17:57  actually got another package here or

18:00  it

18:03  create this two years ago I haven't had

18:06  said much about it either but it may be

18:12  how that works when you push up a

18:16  called a build pack it will go into your

18:20  requirements text file and will

18:24  you warp drive build in this example

18:31  is a really easy ability to build up

18:35  your application so that can be

18:39  also put various hooks in there to do

18:45  to start at the end I just go warp drive

18:50  mod whiskey but that's only your default

18:54  unicorn and waitress and you whiskey as

18:59  mod whiskey Express you may be

19:02  because of its ability to do that and it

19:07  default options even for guna corn and

19:12  realize if you're using Django it no

19:17  being used how to startup Django for you

19:22  even injecting in white noise middle

19:28  handle static files so again just to run

19:33  running as root now now one of the other

19:38  running as non-root it's actually very

19:42  image so it can run as an arbitrary user

19:47  group ID 0 if you run a image as a non

19:54  there's no entry in the password file

19:59  run a system which is a container

20:02  provides extra protections and forces

20:08  will still work warp-drive I used it in

20:16  it's not intended just for that one of

20:21  actually still use it in your local

20:25  actually create my project under warp

20:29  created a virtual environment for me and

20:33  built and that ought to be all that

20:38  packages running in your hooks and then

20:41  warp drive start and it will start up my

20:45  provide you a way of building up your

20:49  your development box but also in a

20:54  system so you have parity between them

20:59  that if something works or builds

21:03  will work fine in production or a

21:08  done much on warp drive lately but you

21:12  I'd like to sort of kick to start that

21:15  been happening with people in fact put

21:20  utilizing some of that for it as far as

21:28  were using a docker file

21:31  that I can actually use it go warp drive

21:36  all go and build the image for me you

21:39  file now I could have done that by

21:44  case I'm actually using a package called

21:50  being like build packs for Heroku

21:55  with docker images and containers

22:00  a what's called a sauce which builder as

22:06  a source code repo using this sy command

22:10  it'll run up that builder inject a repo

22:16  inside

22:18  can come along and run that after now

22:23  least

22:27  provided by Red Hat which builds on

22:31  for doing builds and as well as just

22:35  like environment or platform as a

22:39  build support so I've now got a way then

22:43  local box it understands source to image

22:48  can also deploy it direct into openshift

22:52  build mechanism but also the same way of

22:59  the Apache on your box you're not left

23:04  install to build that mod whiskey

23:08  use your system patchy still and

23:12  because the module is built into a

23:16  installation that's fair will run this

23:20  couple lines you need to put in the

23:24  need to go and configure it manually for

23:29  starting point now as far as using mod

23:36  when I did mod whiskey Express it used a

23:42  preferred way that you run mod whiskey

23:47  whiskey got created meant that the

23:50  embedded mode

23:54  don't use daemon mode it is much better

24:01:00  Apache Apache creates all these worker

24:05:00  the HTTP requests normally in embedded

24:11:00  actually embedded in the same process

24:18:00  is useful soft some things but in

24:21:00  proper and that's where a lot of people

24:25:00  daemon mode and in what happens in

24:29:00  is created

24:32:00  or more than one and there's a little

24:37:00  running inside of the Apache worker

24:40:00  this is all handle for you so it's not

24:45:00  whiskey application separately and then

24:50:00  handles all that running of the separate

24:53:00  Apache it'll also restart the separate

25:00:00  yourself the key bit is this whiskey

25:05:00  an Apache so if you're using mod whiskey

25:09:00  daemon process go find out about it

25:13:00  here the other thing is that you want to

25:18:00  used and that's what whiskey is strict

25:23:00  in your Apache config iver

25:28:00  otherwise we set up an application with

25:31:00  tell it that I'm going to run that

25:38:00  processing in the daemon mode it is

25:42:00  of mod whiskey so it's always been there

25:47:00  that when I went got developed over

25:51:00  options on it but a lot of options

25:57:00  is again because of the history I

26:00:00  features and set a value because I would

26:03:00  existing configuration so if you're

26:09:00  using some of these especially these

26:13:00  have a look at it lang and loco you

26:18:00  operating systems set the locale to be

26:21:00  we've basically Python web applications

26:25:00  locale but the other ones are more

26:29:00  socket I'm a cute on and request timeout

26:34:00  important if you're using django django

26:38:00  first loaded it was fine if it was a

26:44:00  the second time reloaded on the next

26:47:00  really out of twice Django changed that

26:52:00  on a transit problem you can't try and

26:57:00  to manually go in and restart Apache if

27:01:00  timeout set that what will happen is we

27:05:00  within that time frame successfully

27:08:00  again that wafers transient problem

27:12:00  time it'll it'll work socket time and a

27:20:00  you have requests come in and your

27:24:00  because of a deadlock or something and

27:31:00  your your or it takes it takes a

27:35:00  time all these requests start backing up

27:41:00  application to recover then what can

27:47:00  and when your recovers finally you've

27:51:00  the users have already gone away

27:55:00  your queue time allows you to throw

27:58:00  backlog really quickly

28:02:00  blocked blocking in connections because

28:06:00  minutes five minutes which is way too

28:12:00  another one is request timeout if your

28:16:00  it's meant to finish in in 20 seconds

28:22:00  that happens it reduces the capacity of

28:26:00  more requests you can put a timeout on

28:30:00  the process to kick out all the requests

28:34:00  start and keep going and that's helping

28:38:00  applications blocks up for various

28:44:00  options things like processes and Fred's

28:48:00  to know how to set them up a lot of

28:52:00  whiskey' server well I can't answer that

28:55:00  application works I don't

29:00:00  very very important there are things out

29:05:00  products such as New Relic which you can

29:09:00  the hyphenation for that and also now

29:15:00  form its monitoring they to a degree

29:19:00  of your web app and can be used to help

29:26:00  they don't capture some metrics which

29:32:00  web server Apache in this case in mod

29:38:00  metric information this is an event

29:42:00  be notified when requests start when

29:46:00  can actually pull that information out

29:51:00  aggregation systems such as data dog

29:56:00  treating the the web server is how much

29:59:00  used now things like New Relic and data

30:04:00  provide them I just don't provide a

30:08:00  in it being able to tune the Whiskey

30:11:00  looking at this capability or for

30:15:00  in in aside of Apache so I can use that

30:21:00  important response time in this case

30:25:00  other interesting things you can do

30:28:00  actually track every request then I can

30:34:00  bouquet application that is actually

30:39:00  really useful in helping you to sort of

30:43:00  there and how your requests coming in

30:49:00  green line for example is showing

30:54:00  one of those requests went on and

30:58:00  blocked up then note that that green

31:02:00  while that happens I've got less

31:06:00  that bottom line is then actually the

31:09:00  down

31:12:00  that and so hopefully is that something

31:17:00  forest fires resources there is various

31:22:00  site has information on mod whiskey

31:25:00  really up to Tait warp-drive project and

31:29:00  as well

31:35:00  I get a lot of questions people trying

31:40:00  rather you didn't okay if you do it's

31:44:00  there are shortcomings of using Apache

31:52:00  that provided by your linux distro i

31:55:00  devops via whatever in your work may say

32:00:00  it's a pain in the neck they are

32:03:00  p p-- install method if you can and

32:08:00  use other whiskey service right you're

32:12:00  people not to use unicorn and the others

32:16:00  not dead i've been doing a lot of work

32:20:00  knowledge at the moment and finally part

32:24:00  people use mod whiskeys I have done a

32:28:00  use now especially if you want to run

32:33:00  it please don't dismiss it as I often

32:39:00  and hopefully you understand the joke

32:42:00  do it so that'll be all I'll take

32:49:00  thank you

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
