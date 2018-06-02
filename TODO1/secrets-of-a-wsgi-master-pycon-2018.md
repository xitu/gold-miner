> * 原视频地址：[Graham Dumpleton - Secrets of a WSGI master. - PyCon 2018](https://www.youtube.com/watch?v=CPz0s1CQsTE)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/secrets-of-a-wsgi-master-pycon-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/secrets-of-a-wsgi-master-pycon-2018.md)
> * 译者：
> * 校对者：

# Graham Dumpleton - Secrets of a WSGI master. - PyCon 2018

> 本文为 PyCon 2018 视频之 Graham Dumpleton - Secrets of a WSGI master. 的中文字幕，您可以搭配原视频食用。

0:01  so welcome this is Graham Dumpleton with Secrets of a WSGI master thank you.
	
0:09  so thank you everyone for comming last talk of the day and it's 

0:21  always challenge sometimes at least I'm not the last talk of the last day

0:26  everyone half the time everyone's gone home already

0:29  so my background if you're not familiar, I'm the author of the mod_wsgi. So I have

0:37  been involved with the wsgi and what it is for over ten years.

0:42  shortly after when it was created I've always been very opinionted on my ideas

0:48  around it so the point of this talk is to sort of hopefully give you a bit of

0:52  wisdom which I've accumulated about using wsgi apps or in particular with

0:58  mod_wsgi which is the Apache module  which I wrote which allows you

1:05  run your Python web application with Apache so I'm gonna give various tips 

1:10  and things a lot along the way and also perhaps tell you about some things you 

1:15  may not have known about around mod_wsgi because I've been doing a lot of 

1:18  work with it over the last few years where I haven't necessarily documented 

1:23  much or said much about it and so you

1:25 might not know about those things so 

1:29  what is whiskey I call whiskey now 

1:32 I used to always called WSGI but what it

1:34  means is web server gateway interface

1:37 and what it is is a means of plugging in 

1:41  a Python web application with a web

1:45 server so it's going to act as a

1:48  bridge between those two now importantly

1:51 wsgi is an application programming

1:54  interface so when I have this picture

1:57 again here where I talk about HTTP and

1:59  WSGI wsgi. HTTP is a wire protocol, wsgi is not it's an application

2:06  programming interface and I see a lot of

2:08 people get confused about that at times

2:10  in trying to understand it that's not a wire protocol the other 

2:15  thing worth pointing out that wsgi is not implementation of anything. it is 

2:20  a specification and it's defined by pep originally free free free free but there was

2:25  an update related to Python free called free free free free just made

2:31  everything confusing so it's not an implementation especially with me being the

2:37  author of mod whiskey you'll often see people say I'm using Apache and 

2:41  wsgi that's actually confusing. because you don't know whether they're

2:45  talking about mod_wsgi or they're talking about Apache with core 

2:49  behind it as a using Apache as a proxy. so it's all important if you're talking

2:53  about implementation use the name. so use mod_wsgi if you're talking about that or

2:57  or guna corn you wsgi and so on.so what does the canonical HelloWorld

3:02  program look like for wsgi this is it. it's very simple you have a call all

3:07  object to function in this case and for each request you'll passed an

3:12  environ with all the information about the request of

3:16  the HTTP headers but also information from the server itself information such

3:21  as the remote client IP address and other information about the server. and it's 

3:27  then the job of the wsgi application to act on that request information and

3:32  it's going to generate a response and  a response composes of headers for

3:39  HTTP response and a request body start response is called to setup the header

3:45  and then we're doing to actually return that body. so very very simple there are

3:50  lots of traps and pitfalls of writing wsgi application so it may look

3:54  simple but when you start to actually build on top of this very basic

3:58  construct and try to create a whole application stack you might start to

4:02  introduce wsgi middleware and other bits like that and how you deal with

4:06  requesting the request content and it gets very very messy at times so my 

4:13  suggestion is friends don't let friends use raw wsgi. okay it's very

4:18  frustrating to see a lot of people on stack of comming up with problems I'm

4:21  trying to understand this I don't understand why are you trying to do 

4:26  with raw wsgi. so if you have friends who

4:29  think you're getting it's wsgi steer them to a web framework please.it'll

4:35  save them a lot of trouble because they won't be well these ones have a lot of 

4:40  documentation for a start which explains how to use them, good tutorials and so on

4:45  but do provide an interface on top of wsgi which hides all those horrible

4:49  things and ensures that things are implemented correctly. now even if you're using one of those frameworks you still need a way to host a wsgi application they

4:55  using one of those frameworks you still

5:00  they are a framework to help you build that application now those frameworks such as 

5:05  such as Dango and flask they do provide you a wsgi server you can use. that is

5:11  a development wsgi server it's not suitable for production. so even if they

5:18  do have them do not use them and this is the way you need to start looking at

5:22  what's called we call production grade wsgi server and there is various

5:26  attributes that a production grade wsgi server has to have and those

5:30  development service don't so for wsgi service we're talking

5:34  about mod_wsgi with Apache we  guna corn we have u_wsgi there the 

5:40  main free there's also tornado and waitress which is another one

5:45  which is straight wsgi server and then we have to have other ones which is tornado

5:49  tornado which is not really a strictly just the wsgi service actually an 

5:54  asynchronous web server but they do have an adapter for wsgi but the three

5:58  main ones you'll see Apache mod_wsgi, gunicorn, uwsgi. Apache mod_wdgo 

6:05  is traditionally been seen as very hard to setup. back in the

6:11  day when everything started up with when mod_wsgi first came out you had to

6:16  like download the source code for mod_wsgi from the site you had to unpack tar.baz 

6:20  you had to go and do a configure step and make step and make

6:24  install step and then you still had to configure Apache to actually load it and

6:28  then configure it for your application there was a bit of a black art to that

6:32  that I wrote a lot of Doc's people didn't necessarily read them but 

6:37  even if you read them it'll still perhaps difficult to setup.

6:41  things were slightly better when the Linux distribution started to package it

6:44  mod_wsgi you could at least go apt-get install or yum install and get

6:49  it in but you still have to configure it. now at least for installation now, things

6:55  are a bit easier because one of the problems with the Linux distributions

6:59  now is they don't necessarily have an up to date version of mod_wsgi, there was

7:03  a situation and not too fond ago that Debian Ubuntu was supplying a version of mod_wsgi which was 

7:08  5 years old. it was 50 versions out of date that drives me nuts.

7:15  you know when I was be supporting the last version not alone 50 versions ago.

7:18  so what a lot of people don't konw is that it's 

7:23  actually possible to build mod_wsgi and install it using pip

7:29  so you still have to have a patchy installed. you still have to have the Apache dev

7:32  package installed for your operating system but you can pip install it. 

7:36  it'll pull down the source code and it will actually build it up and install

7:40  mod_wsgi module that is built into the pip installation or version environment

7:44  you're using but that's not all. there's also now a way of running a

7:50  patch with mod_wsgi from the command line so rather than actually having to

7:55  go in and configure Apache to load it. you can just run this command so I just

8:01  go to mod_wsg-express start-server and give it my wsgi script file

8:05  it's going to do startup Apache for me and run my webapp, and I haven't done a

8:11  single line of configuration and that was a bit that was difficult for a lot

8:16  of people this does it all for you so this is just like you came with gunicorn now 

8:21  I can run it from the command. it'll start on port 8000 by default

8:26  it'll go in and set up the configuration for you for Apache by

8:33  itself and do it with a set of configuration which I regard as being a

8:38  really good starting point and this is important because mod_wsgi has been

8:43  around for over 10 years and like with a lot of software packages you make

8:46  decisions early on which you think are good decisions and once you make that 

8:52  decision you can't change your mind. so this is actually

8:56  been a really good thing for me because it means I've been able to go back and

8:59  because I'm automatically configuring it. I've been able to draw on all that

9:03  experience from how people used mod_wsgi and set up with a really good

9:07  configuration which isn't actually the same as what the default configuration

9:11  would be if you using Apache yourself and doing it yourself

9:14  so I've done a lot better you can learn from that and I part of the latest

9:20  slides will talk about some of that  extra configuration I do now do

9:26  if you're using Django though we can make it easier again. you can go into

9:31  your Django settings module. you can add in mod_wsgi server to the list of

9:39  installed apps and that's just going to give you a new management command you 

9:43  can run with the manage.py so I can python manage.py runmodwsgi and

9:48  it will start up django app just like if you're running python manage.py runserver 

9:53  but in this case it's using mod_wsgi in Apache underneath and so

10:00  you'll now have a production grade server rather than just that development server

10:04  now you may be saying well why would I want to do that the runserver

10:09  is really useful in development I get automatic source code reloading and

10:15  you might think well no point okay but you can't it's not the default because I

10:20  want the default to be a production ready configuration but you can if you

10:25  want say reload-on-changes that means that once you go in and change your

10:29  source code it will automatically restart the process to reload the code

10:33  on the next request okay so you still have functionality so it is possible to

10:37  use this for development those used to be in the past the idea is that no one

10:42  ever would ever use mod Wiis can develop them because they felt it was too hard

10:45  to set up Apache and to go and manually restart Apache every time you made a

10:49  change so with this you don't need to. there are a bunch of other options which

10:54  the mod whiskey Express supports and one other example is enabling the debugger

11:00  so if you want to start debugging in PDB, the python debugger is why and

11:08  exception occurs you can actually run that command like that and it will throw

11:12  you into the Python debugger to actually then debug it if you want and there's 

11:16  various other commands for tracking or capturing an audit trail of all the 

11:20  requests so you can actually look at all the request headers the request content

11:24  responses and response content for every query request if you need to actually

11:27  start debugging at that level and various other things. so I can do that

11:33  from the command line we've with Django in that way. now if I want to take that

11:37  to production. all I need to do is run the same command that I ran before we've

11:45  run mod_wsgi. I need a place in to actually say this if you're 

11:49  looking closely when I ran this before it was doing stuff in slash temp

11:53  with the generated configuration for a real production we want to actually put

11:56  it in a better location so that a cron job doesn't go and remove all the files

12:00  from slash temp on us so we'll give it a center root we'll put that in etc 

12:04  directory so I'm gonna run this command as root initially. I'm gonna want to use

12:08  port 80 that means it's a privileged port I need to be route to start this up

12:12  so that's why I'm specifying a user and group two to have this run the

12:16  application knows when it starts and I just put --setup-only on the end

12:21  and it will generate the config but not actually start anything. okay so I've got

12:27  my config and it's not gonna be generator each time. one of the things in

12:32  that generator config is an Apache CTL script just like you would have with a

12:37  normal Apache installation but this one is tied to this particular generated

12:40  conflict and I can do start restart and stop and I can then put that into my

12:47  init scripts in my system setup or using systemd and have that started up when

12:52  the box starts now very very important in all of this what it described so far

12:57  about that generating configuration it is not touching your system Apache

13:02  configuration. okay it's generating it all in a separate area. so it is a

13:07  totally isolated config. so if you were using Apache 

13:12  on your system for something else it will not interface with it the only 

13:16  thing is if you do want to run it this way on port 80, you would install Apache

13:22  but you wouldn't actually enable it in systemd.so it started up in that way

13:26  because we want this one to take over port 80 so we've got a very easy way now

13:30  going from development being able to run on the command line generate your config

13:36  put it in your system init files and have it start up as your actual main

13:40  Apache on your box although those examples I guess our work so far we're

13:46  primarily involving Django if you're not using Django you can still do the same

13:50  thing starts over risky script file I have all my options now one of the

13:57  things about how the Django integration worked is that it automatically setup

14:02  the capatch II configuration required to map your static files into Apache so

14:09  that when you access the slash static directory that would all we handle for

14:14  you now in this case on running a separate wsgi application now so I

14:18  can still do that by using this URL alias option and say I have these files

14:23  in my static directory here I want to map them at slash static and they're a

14:27  bunch of other options available you can override the number of processes and

14:31  Fred's and lots of other things to do with how you handle things like

14:39  responding to headers for proxy information if you're putting this

14:42  behind a proxy for example there's all sorts of things like that if you need to

14:46  know about any of the information you can go --help it'll put out lots of

14:50  helpful information not as long as the volumn alias,your wsgi docs but then

14:56  it's not as complicated diver is trying to set up your wsgi it's much simpler

15:01  so latest rage these days actually is docker and containers and one of the

15:07  reasons that I went and created mod_wsgi-express in the first place was

15:11  because of what was happening in the container space if you had to set up

15:15  Apache with mod_wsgi in a docker file for running in a container it was just

15:21  as messy as if you're doing it on your own box and in some ways even more messy

15:25  because you couldn't do it manually by hand you had to actually script the

15:28  generation of all config to integrated into the Apache config so that was

15:33  actually one of the reasons why I did this.

15:36  using this with docker not too hard. we just potentially start out with your

15:41  docker base image you're going to install Apache packages required very

15:47  importantly if you have don't work with the python base images from docker is

15:51  this problems of Unicode so we can fix them up

15:54  we people install mod_wsgi and we set our pip command to actually run things

16:01  and because we're in a docker container,we're going to say log to terminal so

16:04  that we can capture those locks ok pretty simple so once we do that we do

16:11  we can build that for look at our docker file and we can run it ok fairly

16:15  straightforward but if you have used docker

16:20  I don't know how many people aware of this problem if you saw that if you

16:24  understood had docker builds work that container when I was running it was I 

16:27  was running as root inside of that container 

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
