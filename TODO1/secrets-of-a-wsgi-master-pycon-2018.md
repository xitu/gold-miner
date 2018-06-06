> * 原视频地址：[Graham Dumpleton - Secrets of a WSGI master. - PyCon 2018](https://www.youtube.com/watch?v=CPz0s1CQsTE)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/secrets-of-a-wsgi-master-pycon-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/secrets-of-a-wsgi-master-pycon-2018.md)
> * 译者：
> * 校对者：

# Graham Dumpleton - Secrets of a WSGI master. - PyCon 2018

> 本文为 PyCon 2018 视频之 Graham Dumpleton - Secrets of a WSGI master. 的中文字幕，您可以搭配原视频食用。

00:01  so welcome this is Graham

00:04  Dumbleton and with secrets of wsgi master

00:09  thank you. so thank you everyone for

00:19  coming last talk of the day and it's

00:21  always challenge sometimes. at least I'm

00:23  not the last talk of the last day. cuz

00:26  everyone half the time everyone's gone

00:27  off half go home already.

00:29  so my background if you're not familiar

00:33  I am the author of mod_wsgi. so I've

00:37  been involved with the wsgi and what

00:40  it is for over ten years.

00:42  shortly after when it was created. I've

00:45  always been very opinionated on my ideas

00:48  around it .so the point of this talk is

00:51  to sort of hopefully give you a bit of

00:52  wisdom which I've accumulated about

00:55  using wsgi apps or in particular with

00:58  mod_wsgi which is Apache

01:02  module which I wrote which allows you to

01:05  run your Python web application with

01:06  Apache. so I'm gonna give various tips

01:10  and things a lot along the way. and also

01:13  perhaps tell you about some things you

01:15  may not have known about around mod

01:17  wsgi because I've been doing a lot of

01:18  work with it over the last few years.

01:21  where I haven't necessarily documented

01:23  much or said much about it and so you

01:26  might not know about those things. so

01:29  what is wsgi I call wsgi now I

01:31  used to always called WSGI but what it

01:34  means is web server gateway interface.

01:36  and what it is is a means of plugging in

01:41  a Python web application with a web

01:44  server. so it's going to bridge act as a

01:48  bridge between those two. now importantly

01:52  wsgi is an application programming

01:54  interface. so when I have this picture

01:57  again here where I talk about HTTP and

01:59  WSGI wsgi HTTP is a wire protocol

02:04  wsgi is not it's an application

02:06  programming interface and I see a lot of

02:08  people get confused about that at times

02:10  in trying to understand it

02:13  that's not a wire protocol. the other

02:15  thing worth pointing out that wsgi is

02:17  not an implementation of anything. it is

02:20  a specification and it's defined by pep

02:22  originally free free free but there was

02:25  an update related to Python free called

02:28  free free free free. just to make

02:31  everything confusing. so it's not an

02:34  invitation especially with me being the

02:37  author of mod_wsgi. you'll often see

02:39  people say oh I'm using Apache and

02:41  wsgi that's actually confusing

02:44  because you don't know whether they're

02:45  talking about mod_wsgi or they're

02:47  talking about Apache with gunicorn

02:49  behind it as using Apache as a proxy.

02:52  so it's all important if you're talking

02:53  about implementation use the name so use

02:55  mod_wsgi if you're talking about that

02:57  or gunicorn you wsgi and so on

02:59  so what does the canonical HelloWorld

03:02  program look like for wsgi .this is it

03:05  it's very simple you have a call all

03:07  object to function in this case and for

03:09  each request you'll get passed an

03:12  environ

03:14  all the information about the request of

03:16  the HTTP headers but also information

03:19  from the server itself information such

03:21  as the remote client IP address and

03:25  other information about the server. its

03:27  then the job of that wsgi application

03:29  to act on that request information and

03:32  it's going to generate a response and a

03:35  response composes of headers for the

03:39  HTTP response and a request body start

03:43  response is called to setup the header

03:45  and then we're doing to actually return

03:46  that body. so very very simple there are

03:50  lots of traps and pitfalls of writing

03:52  wsgi applications.so it may look

03:54  simple but when you start to actually

03:56  build on top of this very basic

03:58  construct and try to create a whole

04:00  application stack. you might start to

04:02  introduce wsgi middleware and other

04:04  bits like that and how you deal with

04:06  requesting the request content and it

04:09  gets very very messy at times. so my

04:13  suggestion is friends don't let friends

04:14  use raw wsgi. okay it's very

04:18  frustrating to see a lot of people on

04:19  stack of coming up with problems I'm

04:21  trying to understand this. I don't

04:23  understand why are you trying to do it

04:26  with

04:26  raw wsgi so if you have friends who

04:29  think you're getting it's wsgi steer

04:32  them to a web framework please it'll

04:35  save them a lot of trouble because they

04:38  won't be well these ones have a lot of

04:40  documentation for a start which explains

04:43  how to use them good tutorials and so on

04:45  but do provide an interface on top of

04:47  wsgi which hides all those horrible

04:49  things and ensures that things are

04:51  implemented correctly now even if you're

04:55  using one of those frameworks you still

04:57  need a way to host a wsgi application

05:00  they are a framework to help you build

05:02  that application. now those frameworks

05:05  such as Dango and flask. they do provide

05:08  you a wsgi server you can use that is

05:11  a development wsgi server. it's not

05:15  suitable for production so even if they

05:18  do have them. do not use them and this is

05:21  the way you need to start looking at

05:22  what's called we call production grade

05:23  wsgi server and there's various

05:26  attributes that a production grade

05:28  wsgi server has to have and those

05:30  development service don't.

05:32  so for wsgi service we're talking

05:34  about mod_wsgi with Apache we have

05:36  gunicorn we have uwsgi. there the

05:40  main free there's also tornado and knock

05:42  tornado waitress which is another one

05:45  which is straight wsgi server and

05:48  then we have to have other ones which is

05:49  tornado which is not really a strictly

05:52  just the wsgi service actually an

05:54  asynchronous web server. but they do have

05:56  an adapter for wsgi but the three

05:58  main ones you'll see Apache mod_wsgi

06:00  gunicorn and uwsgi Apache and mod

06:05  wsgi is traditionally been seen as

06:07  being very hard to set up. back in the

06:11  day when everything started up with when

06:14  mod_wsgi first came out you had to

06:16  like download the source code for mod

06:18  wsgi from the site you had to unpack

06:20  tar ball you had to go and do a

06:22  configure step and make step and make

06:24  install step and then you still had to

06:26  configure Apache to actually load it and

06:28  then configure it for your application.

06:30  there was a bit of a black art to that

06:32  that I wrote a lot of Doc's

06:34  people didn't necessarily read them but

06:37  even if you read them it'll still

06:38  perhaps difficult to set up.

06:41  things were slightly better when the

06:42  Linux distribution started to package it

06:44  mod_wsgi. you could at least go

06:47  apt-get install or yum install and get

06:49  it in but you still have to configure it

06:51  now at least for installation now. things

06:55  are a bit easier because one of the

06:57  problems with the Linux distributions

06:59  now is they don't necessarily have an up

07:00  to date version of mod_wsgi. there was

07:03  a situation and not too fond ago that

07:05  Debian Ubuntu was supplying a version of

07:08  mod_wsgi which was 5 years old it

07:11  was 50 versions out of date. that drives

07:15  me nuts. you know when I was be

07:16  supporting the last version not alone 50

07:18  versions ago so what a lot of people

07:21  probably don't know is that it's

07:23  actually possible to build mod_wsgi

07:25  and install it using PIP so long you

07:29  still have to have Apache installed

07:31  you still have to have the Apache dev

07:32  package installed for your operating

07:34  system but you can pip install it it'll

07:36  pull down the source code and it will

07:38  actually build it up and install mod

07:40  wsgi module that is built into the

07:43  pipe installation or version environment

07:44  you're using. but that's not all

07:47  there's also now a way of running 

07:50  Apache with mod_wsgi from the command

07:53  line. so rather than actually having to

07:55  go in and configure Apache to load it

07:58  you can just run this command. so I just

08:01  go to mod_wsgi-express start server

08:03  and give it my wsgi script file and

08:05  it's going to do start up Apache for me

08:08  and run my web app. and I haven't done a

08:11  single line of configuration and that

08:14  was a bit that was difficult for a lot

08:16  of people. this does it all for you. so

08:19  this is just like you came with gunicorn

08:21  now I can run it from the command

08:23  line it'll start on port 8000 by

08:26  default it'll go in and set up the

08:29  configuration for you for Apache by

08:33  itself and do it with a set of

08:35  configuration which I regard as being a

08:38  really good starting point and this is

08:40  important because mod_wsgi has been

08:43  around for over 10 years and like with a

08:45  lot of software packages you make

08:46  decisions early on which you think are

08:49  good decisions and once you make that

08:52  decision you can't

08:54  change your mind so this is actually

08:56  been a really good thing for me because

08:57  it means I've been able to go back and

08:59  because I'm automatically configuring it

09:01  I've been able to draw on all that

09:03  experience from how people used mod

09:04  wsgi and set up with a really good

09:07  configuration which isn't actually the

09:09  same as what the default configuration

09:11  would be if you using Apache yourself

09:13  and doing it yourself.

09:14  so I've done a lot better. you can learn

09:18  from that and I part of the latest

09:20  slides will talk about some of that.

09:21  extra configuration I now do. if

09:26  you're using Django though we can make

09:28  it even easier again. you can go into

09:31  your Django settings module. you can add

09:36  in mod_wsgi.server to the list of

09:39  installed apps and that's just going to

09:41  give you a new management command you

09:43  can run with the manage.py. so I can

09:46  go python manage.py runmodwsgi and

09:48  it will start up Django app just like if

09:51  you're running Python manageby. run

09:53  server but in this case it's using mod

09:56  wsgi in Apache underneath and so

10:00  you'll now have a production grade server rather than just that development server

10:01  server rather than just that development

10:04  server. now you may be saying well why

10:07  would I want to do that. the run

10:09  is really useful in development I get automatic source code reloading and

10:12  get automatic source code reloading. and

10:15  you might think well no point. okay but

10:18  you can it's not the default because I

10:20  want the default to be a production ready configuration but you can if you

10:22  ready configuration .but you can if you

10:25  want say reload-on-changes that means

10:27  that once you go in and change your

10:29  source code it will automatically restart the process to reload the code

10:31  restart the process to reload the code

10:33  on the next request okay so you still

10:35  have functionality. so it is possible to

10:37  use this for development those used to

10:40  be in the past the idea is that no one

10:42  ever would ever use mod_wsgi to develop

10:43  because they felt it was too hard

10:45  to set up Apache and to go and manually

10:47  restart Apache every time you made a

10:49  change. so with this you don't need to.

10:52  there are a bunch of other options which

10:54  the mod_wsgi-express supports and one

10:58  other example is enabling the debugger.

11:00  so if you want to start debugging in PDB--

11:05  the Python debugger is why and

11:08  exception occurs you can actually run that command like that and it will throw

11:10  that command like that and it will throw

11:12  you into the Python debugger to actually

11:14  then debug it if you want. and there's

11:16  various other commands for tracking or

11:18  capturing an audit trail of all the

11:20  requests so you can actually look at all

11:22  the request headers the request content

11:24  responses and response content for every

11:26  query quest. if you need to actually

11:27  start debugging at that level and

11:30  various other things. so I can do that

11:33  from the command line we've with Django

11:35  in that way now if I want to take that

11:37  to production. all I need to do is run the same command that I ran before we've

11:40  the same command that I ran before we've

11:45  runmodwsgi. I need a place in to

11:48  actually say this  if you're

11:49  looking closely when I ran this before it was doing stuff in slash temp

11:51  it was doing stuff in temp slash temp

11:53  with the generated configuration for a

11:55  real production we want to actually put

11:56  it in a better location so that a cron

11:58  job doesn't go and remove all the files

12:00  from slash temp on us so we'll give it a

12:02  center root we'll put that in etc

12:04  directory so I'm gonna run this command

12:06  as root initially I'm gonna want to use

12:08  port 80 that means it's a privileged

12:10  port I need to be route to start this up

12:12  so that's why I'm specifying a user and

12:14  group two to have this run the

12:16  application knows when it starts and I

12:18  just put - - setup - only on the end

12:21  and it will generate the config but not

12:24  actually start anything okay so I've got

12:27  my config and it's not gonna be

12:29  generator each time .one of the things in

12:32  that generator config is an Apache CTL

12:35  script just like you would have with a

12:37  normal Apache installation but this one

12:39  is tied to this particular generated

12:40  conflict and I can do start restart and

12:44  stop and I can then put that in to my

12:47  init scripts in my system setup or using

12:50  systemd and have that started up when

12:52  the box starts now very very important

12:55  in all of this what it described so far

12:57  about that generating configuration it

12:59  is not touching your system Apache

13:02  configuration. okay it's generating it

13:05  all in a separate area so it is a

13:07  totally isolated config. so if you were

13:10  using Apache

13:12  on your system for something else it will not interface with it the only 

13:13  will not interfere with it. the only

13:16  thing is if you do want to run it this

13:18  way on port 80 you would install Apache

13:22  but you wouldn't actually enable it in

13:24  systemd so it started up in that way

13:26  because we want this one to take over

13:27  port 80. so we've got a very easy way now

13:30  going from development being able to run

13:33  on the command line generate your config

13:36  put it in your system init files and

13:38  have it start up as your actual main

13:40  Apache on your box. although those

13:44  examples I guess our work so far we're

13:46  primarily involving Django if you're not using Django you can still do the same

13:49  using Django you can still do the same

13:50  thing starts over wsgi script file I

13:54  have all my options now one of the

13:57  things about how the Django integration worked is that it automatically setup

13:59  worked is that it automatically set up

14:02  the Apache configuration required to

14:06  map your static files into Apache. so

14:09  that when you access the  /static

14:11  directory that would all we handle for

14:14  you now. in this case on running a

14:16  separate wsgi application now so I

14:18  can still do that by using this URL alias option and say I have these files

14:20  alias option and say I have these files

14:23  in my static directory here I want to

14:25  map them at slash static and they're a

14:27  bunch of other options available you can

14:29  override the number of processes and

14:31  Fred's and lots of other things to do

14:33  with how you handle things like

14:39  responding to headers for proxy

14:41  information if you're putting this

14:42  behind a proxy for example there's all

14:44  sorts of things like that if you need to

14:46  know about any of the information you

14:48  can go - - help. it'll put out lots of

14:50  helpful information not as long as the

14:53  volume Alice you wsgi Doc's. but then

14:56  it's not as complicated diver is trying

14:58  to set up you wsgi it's much simpler.

15:01  so latest trends these days actually is

15:04  docker and containers and one of the

15:07  reasons that I went and created mod_wsgi-express in the first place was

15:09  wsgi Express in the first place was

15:11  because of what was happening in the

15:13  container space if you had to set up

15:15  Apache with mod_wsgi in a docker file

15:19  for running in a container. it was just

15:21  as messy as if you're doing it on your own box and in some ways even more messy

15:23  own box and in some ways even more messy.

15:25  because you couldn't do it manually by

15:27  hand you had to actually script the

15:28  generation of all config to integrated

15:30  into the Apache config. so that was

15:33  actually one of the reasons why I did

15:34  this.

15:36  using this with docker not too hard

15:40  we just potentially start out with your

15:41  docker base image you're going to

15:43  install Apache packages required. very

15:47  importantly if you have don't work with

15:48  the Python base images from docker is

15:51  this problems of Unicode so we can fix

15:53  them up

15:54  we people install mod_wsgi and we set

15:58  our PL command to actually run things

16:01  and because we're in a docker container,we're going to say log to terminal so

16:02  we're going to say log to terminal so

16:04  that we can capture those locks ok

16:06  pretty simple so once we do that we do

16:11  we can build that for look at our docker

16:12  file and we can run it ok fairly

16:15  straightforward. but if you have used

16:19  docker

16:20  I don't know how many people aware of this problem if you saw that if you

16:21  this problem if you saw that if you

16:24  understood had docker builds work that

16:26  container when I was running it was I

16:27  was running as root inside of that

16:29  container please don't do that. who does

16:32  say hey so he's going to admit that they

16:34  run their docker containers root. yeah

16:36  please don't do that.

16:39  containers do provide you an extra level

16:41  of isolation but the important things

16:44  with production systems you always have

16:45  as many layers of security as you can. if

16:48  you run things as root then as a

16:51  vulnerability found in the container

16:52  runtime someone can escape out so the

16:54  hosts they're already root so please

16:57  don't run things as root the other thing

16:59  about that very simple docker file is I

17:01  was not using a virtual environment even

17:03  if you're using docker you might think

17:05  oh I don't need a virtual environment

17:06  because I'm the only person using it

17:09  please also use a virtual environment

17:11  because there are a lot of issues that

17:12  can come up with trying to install

17:14  packages into a system Python. if this

17:16  operating system itself has to install

17:19  packages to support the operating system

17:21  you can give lots of conflict so avoid

17:23  that. so a better docker file might start

17:26  out with creating a non root user we can

17:29  do things this and I'll you'll note that

17:32  are actually putting the GID is 0.I'll

17:34  tell why in a moment. we can create our

17:38  virtual environment when we're finishing

17:40  off the docker file make sure doing

17:42  things as a non root user and because we

17:45  are a non root user we can't use port 80

17:47  but that's ok because we can just map

17:49  when we run the container. now thrown in

17:52  another thing here as well I could have

17:54  just put in here

17:55  run mod_wsgi-express but I've

17:57  actually got another package here or

17:58  just what I just wanted to show off of

18:00  it

18:01  and that's called warpdrive I actually

18:03  create this two years ag.o I haven't had

18:04  much pickup on it but I haven't actually

18:06  said much about it either but it may be

18:08  of interest if you have me of Heroku and

18:12  how that works when you push up a

18:14  application to Heroku it uses what's

18:16  called a build pack. it will go into your

18:19  source code look and see if you've got a

18:20  requirements text file and will

18:23  automatically install the packages for

18:24  you warpdrive build in this example

18:27  does the same thing so what is providing

18:31  is a really easy ability to build up

18:32  your all the files you need to support

18:35  your application so that can be

18:37  requirements not text because you can

18:39  also put various hooks in there to do

18:41  pre and post build actions and so on and

18:45  to start at the end I just go warpdrive

18:48  start now in this case it's going to run

18:50  mod_wsgi but that's only your default

18:52  warpdrive actually knows how to startup

18:54  gunicorn and waitress and  uwsgi as

18:57  well so even if you didn't want to use

18:59  mod_wsgi-express you may be

19:01  interested in looking at warpdrive

19:02  because of its ability to do that and it

19:05  will worry about providing some good

19:07  default options even for gunicorn and

19:10  you wsgi it's even smart enough to

19:12  realize if you're using Django it no

19:16  matter which of those service we've

19:17  being used how to startup Django for you.

19:19  including hosting of static files or

19:22  even injecting in white noise middle

19:25  wrapper if using gunicorn to actually

19:28  handle static files. so again just to run

19:32  it up and you'll see that it's not

19:33  running as root now, now one of the other

19:36  things is that even though you're

19:38  running as non-root it's actually very

19:40  good to design your container or your

19:42  image so it can run as an arbitrary user

19:44  ID and that is actually why I was using

19:47  group ID 0. if you run a image as a non

19:52  root user of a very very high value

19:54  there's no entry in the password file

19:56  it'll default to group ID of 0 so if you

19:59  run a system which is a container

20:01  environment which

20:02  provides extra protections and forces

20:05  you to run as a arbitrary user ID this

20:08  will still work. warpdrive I used it in

20:14  docker container there or docker image

20:16  it's not intended just for that .one of

20:19  the good things about it is you can

20:21  actually still use it in your local

20:22  development environment so I can

20:25  actually create my project under warp

20:27  drive and essentially it's gone and

20:29  created a virtual environment for me and

20:30  put me in that I can still go warpdrive

20:33  built and that ought to be all that

20:35  running of the PIP to install the

20:38  packages running in your hooks and then

20:40  I thought when I run this over I can go

20:41  warpdrive start and it will start up my

20:43  server for me okay so it's intended to

20:45  provide you a way of building up your

20:47  application environment that works on

20:49  your development box but also in a

20:52  containerized environment or production

20:54  system so you have parity between them

20:57  so you got a better better guarantee

20:59  that if something works or builds

21:01  properly in your own development box it

21:03  will work fine in production or a

21:04  container .so that I haven't I haven't

21:08  done much on warpdrive lately but you

21:10  are interested please talk to me because

21:12  I'd like to sort of kick to start that

21:13  again and with some of the stuff that's

21:15  been happening with people in fact put

21:17  ppm support in there as well and start

21:20  utilizing some of that for it as far as

21:26  generating a docker image we previously

21:28  were using a docker file

21:29  wellwe've warpdrive you don't even need

21:31  that. I can actually use it go warpdrive

21:33  image name of an image to crate and it

21:36  all go and build the image for me. you

21:38  don't even need to generate a docker

21:39  file now I could have done that by

21:42  generating a docker file myself in this

21:44  case I'm actually using a package called

21:46  source to image it can be viewed as

21:50  being like build packs for Heroku.

21:53  but it's purpose-built for doing stuff

21:55  with docker images and

21:57  container images. it allows you to define

22:00  a what's called a sauce which builder as

22:02  a image itself and you can point that at

22:06  a source code repo using this command

22:09  it'll pull down the git repo for me

22:10  it'll run up that builder inject a repo

22:13  source code and then run that build step

22:16  inside

22:16  and generates you an image and then I

22:18  can come along and run that after. now

22:20  source to image is understood by at

22:23  least

22:23  openshift which is a kubernetes platform

22:27  provided by Red Hat which builds on

22:29  kubernetes and has extra capabilities

22:31  for doing builds and as well as just

22:33  running images. so it's giving that past

22:35  like environment or platform as a

22:37  service and it has a source to merge

22:39  build support so I've now got a way then

22:42  of doing things with warpdrive at my

22:43  local box it understands source to image

22:46  I could generate images with it but I

22:48  can also deploy it direct into openshift

22:50  as well. all using the same underlying

22:52  build mechanism but also the same way of

22:54  running up there. if you are using still

22:59  the Apache on your box you're not left

23:02  out of this still you can do peep

23:04  install to build that mod_wsgi

23:06  module' for Apache. but if you want to

23:08  use your system patchy still and

23:09  configure it manually you can and

23:12  because the module is built into a

23:14  virtual environment your path

23:16  installation that's fair will run this

23:18  module config command it'll generate the

23:20  couple lines you need to put in the

23:22  Apache config to load that you still

23:24  need to go and configure it manually for

23:27  your application but that's a good

23:29  starting point now as far as using mod

23:34  wsgi in Apache and doing it yourself

23:36  when I did mod_wsgi-express it used a

23:40  mode called daemon mode. that is the

23:42  preferred way that you run mod_wsgi.

23:45  unfortunately the history of how mod

23:47  wsgi got created meant that the

23:49  default mode is something called

23:50  embedded mode.

23:52  if you're using embedded mode please

23:54  don't use daemon mode it is much better

23:58  now what is the difference when we run

24:01  Apache. Apache creates all these worker

24:04  process they're the things that accepts

24:05  the HTTP requests. normally in embedded

24:09  mode your Python web application is

24:11  actually embedded in the same process

24:14  the same work Apache worker process that

24:18  is useful soft some things but in

24:20  general it's really hard to set up

24:21  proper and that's where a lot of people

24:23  have problems so you're better off using

24:25  daemon mode and in what happens in

24:27  daemon mode is that a separate process

24:29  is created

24:30  for running the wsgi application in
 
24:32  or more than one .and there's a little

24:35  proxy in there so the only thing that is

24:37  running inside of the Apache worker

24:38  process is these little prosecutes now

24:40  this is all handle for you so it's not

24:43  like you have to manually run your

24:45  wsgi application separately and then

24:48  setup Apache to proxy mod_wsgi

24:50  handles all that running of the separate

24:52  daemon process for you so if you restart

24:53  Apache it'll also restart the separate

24:55  process so if you're doing this manually

25:00  yourself the key bit is this wsgi

25:03  daemon process directive which you have

25:05  an Apache so if you're using mod_wsgi

25:07  now and if you don't have with wsgi

25:09  daemon process go find out about it

25:11  because you're not using daemon mode

25:13  here the other thing is that you want to

25:16  turn off embedded mode so that it isn't

25:18  used and that's what wsgi is strict

25:21  embedded does so if you don't have that

25:23  in your Apache config iver

25:24  maybe research that one as well but

25:28  otherwise we set up an application with

25:29  wsgi script alias and we're going to

25:31  tell it that I'm going to run that

25:32  inside of that daemon process the daemon

25:38  processing in the daemon mode it is

25:39  existed since version 1.0

25:42  of mod_wsgi so it's always been there

25:44  but it has been improved gradually as

25:47  that when I went got developed over

25:49  those 10 years now there are a lot of

25:51  options on it but a lot of options

25:53  aren't set with same defaults and that

25:57  is again because of the history I

25:58  couldn't go back when I added these new

26:00  features and set a value because I would

26:02  have upset those people who had an

26:03  existing configuration. so if you're

26:05  using daemon mode already if you are not

26:09  using some of these especially these

26:10  ones within the red boxes go back and

26:13  have a look at it lang and loco you

26:16  might have already hit this before some

26:18  operating systems set the locale to be

26:20  ASCII which causes lots of problems

26:21  we've basically Python web applications

26:24  so those options safe for setting laying

26:25  locale. but the other ones are more

26:27  probably important startup timeout

26:29  socket I'm a cute on and request timeout

26:31  so startup time at this one is very

26:34  important if you're using django. django

26:36  once upon a time if it failed when it

26:38  first loaded it was fine if it was a

26:42  transient problem

26:44  the second time reloaded on the next

26:46  request that worked fine it could be

26:47  really out of twice. Django changed that

26:49  once it tries to attempt reloading once

26:52  on a transit problem you can't try and

26:55  attempt reload after that and you have

26:57  to manually go in and restart Apache if

26:59  you've seen that use this dial up

27:01  timeout set that what will happen is we

27:03  can't load that wsgi application

27:05  within that time frame successfully.

27:06  it'll actually restart the processes

27:08  again that wafers transient problem

27:10  you'll keep going and hopefully the next

27:12  time it'll work. socket time and a

27:16  queue timeout especially queue timeout if

27:20  you have requests come in and your

27:22  application locks up on that request

27:24  because of a deadlock or something and

27:27  all your friends start to backup all

27:31  or it takes a

27:34  long-running request and takes a long

27:35  time all these requests start backing up

27:38  and if it takes a long time for your

27:41  application to recover then what can

27:43  happen is that Apache gets backlogged

27:47  and when your recovers finally you've

27:50  got this huge number requests queued up

27:51  the users have already gone away

27:53  there's no point serving the request

27:55  your queue time allows you to throw

27:56  those requests out and recover from the

27:58  backlog really quickly

28:00  sohcahtoa is to avoid other things we've

28:02  blocked blocking in connections because

28:04  the default and patch is actually three

28:06  minutes five minutes which is way too

28:09  long so look for those options

28:12  another one is request timeout if your

28:14  request is taking too long

28:16  it's meant to finish in in 20 seconds

28:19  and it's taking two hours every time

28:22  that happens it reduces the capacity of

28:24  your server and you can't handle any

28:26  more requests you can put a timeout on

28:28  this and it will actually go and restart

28:30  the process to kick out all the requests

28:32  out so that you can get back to a fresh

28:34  start and keep going and that's helping

28:37  you to recover automatically when your

28:38  applications blocks up for various

28:40  reasons with all this there's all these

28:44  options things like processes and Fred's

28:46  and all these other ones very important

28:48  to know how to set them up a lot of

28:51  people ask me how do I set up my

28:52  wsgi' server well I can't answer that

28:54  question because I don't know how your

28:55  application works I don't

28:57  out behaves that's where monitoring is

29:00  very very important there are things out

29:03  there application performance monitoring

29:05  products such as New Relic which you can

29:07  blame me for because I actually wrote

29:09  the hyphenation for that and also now

29:12  more recently data dog has application

29:15  form its monitoring they to a degree

29:17  allow you to see what's happening inside

29:19  of your web app and can be used to help

29:23  make your application perform better but

29:26  they don't capture some metrics which

29:28  are very useful for tuning your actual

29:32  web server Apache in this case. in mod

29:36  wsgi there is this ability to get out

29:38  metric information this is an event

29:40  mechanism there where you can actually

29:42  be notified when requests start when

29:43  they finish when exceptions occurred you

29:46  can actually pull that information out

29:48  and send it into some sort of metrics

29:51  aggregation systems such as data dog

29:54  some of the important ones as far as

29:56  treating the the web server is how much

29:58  of the capacity of that server is being

29:59  used now things like New Relic and data

30:02  dog APM don't have those things I

30:04  provide them I just don't provide a

30:06  back-end so if you're really interested

30:08  in it being able to tune the wsgi

30:10  server you might be interested in

30:11  looking at this capability or for

30:13  tracking the events of when things occur

30:15  in in aside of Apache so I can use that

30:18  to pull out my data request very

30:21  important response time in this case

30:22  happens to be using DotA dog but there's

30:25  other interesting things you can do

30:26  because it's an event model and I can

30:28  actually track every request then I can

30:31  do fancy things like this .so this is a

30:34  bouquet application that is actually

30:36  showing live traffic and this can be

30:39  really useful in helping you to sort of

30:40  get a concept of what's happening in

30:43  there and how your requests coming in

30:46  relative to each other and like that

30:49  green line for example is showing

30:50  requests while they're being handled if

30:54  one of those requests went on and

30:56  started running for ten minutes and

30:58  blocked up then note that that green

31:00  line would go forever and obviously

31:02  while that happens I've got less

31:03  capacity to handle other requests so

31:06  that bottom line is then actually the

31:08  capacity so you see how it jumps up and

31:09  down

31:10  so the event thing is cute for for doing

31:12  that and so hopefully is that something

31:15  of interest

31:17  forest fires resources there is various

31:19  mod wsgi documentation the pypi

31:22  site has information on mod_wsgi

31:24  expressed because the other Doc's aren't

31:25  really up to tail warp-drive project and

31:28  source to in which might be of interest

31:29  as well

31:30  now a few summary things I'd like to say

31:35  I get a lot of questions people trying

31:37  to use my wsgi on Windows please I'd

31:40  rather you didn't okay if you do it's

31:42  just at least use docker on Windows ok

31:44  there are shortcomings of using Apache

31:46  on Windows please don't use packages

31:52  that provided by your linux distro i

31:53  know your sister admins or in your

31:55  devops via whatever in your work may say

31:58  no no you have to use the package system

32:00  it's a pain in the neck they are

32:01  generally a very old and out of date use

32:03  pip install method if you can and

32:07  friends tell their friends other user

32:08  use other wsgi service right you're

32:10  all using mud wsgi and you all tell

32:12  people not to use gunicorn and the others

32:14  right because mud wsgi is definitely

32:16  not dead i've been doing a lot of work

32:18  on it it's just not very public

32:20  knowledge at the moment and finally part

32:23  of the reason I feel I'd like to see

32:24  people use mod_wsgis I have done a

32:26  lot of work of making it using easier to

32:28  use now. especially if you want to run

32:30  omit containers okay so have a look at

32:33  it please don't dismiss it as I often

32:36  have people do so that's it

32:39  and hopefully you understand the joke

32:41  most people don't seem to when I would

32:42  do it so that'll be all I'll take

32:46  questions to the side and that's it so

32:49  thank you

32:50  [Applause]

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
