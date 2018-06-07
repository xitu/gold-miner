> * 原视频地址：[Andrew Godwin - Taking Django Async - PyCon 2018](https://www.youtube.com/watch?v=-7taKQnndfo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/talking-django-async-pycon-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/talking-django-async-pycon-2018.md)
> * 译者：
> * 校对者：

# Andrew Godwin - Taking Django Async - PyCon 2018

> 本文为 PyCon 2018 视频之 Andrew Godwin - Taking Django Async 的中文字幕，您可以搭配原视频食用。

00:00:00,560 --> 00:00:05,700
hello let's give a warm
大家好，让我们热烈欢迎Andrew Godwin

00:00:05,700 --> 00:00:15,660
PyCon welcome to Andrew Godwin

00:00:15,660 --> 00:00:19,109
hello good afternoon everyone I am here to
大家下午好，今天我在这里给大家谈一下Django异步机制

00:00:19,109 --> 00:00:22,619
talk about taking Django async louder

00:00:22,619 --> 00:00:25,289
好吧 ，我想我们现在开始吧

00:00:25,289 --> 00:00:28,410
so a brief introduction for those who

00:00:28,410 --> 00:00:31,769
don't know me I am a person whose

00:00:31,769 --> 00:00:33,210
clicker is not working correctly that's

00:00:33,210 --> 00:00:45,210
fun isn't it I am Andrew Godwin I am a

00:00:45,210 --> 00:00:47,489
member of the Django core team most

00:00:47,489 --> 00:00:50,010
probably known these days my work on

00:00:50,010 --> 00:00:53,010
Django migrations in the past and these

00:00:53,010 --> 00:00:54,840
days working on channels which is what

00:00:54,840 --> 00:00:57,600
this talk is mainly about my day job I

00:00:57,600 --> 00:00:59,609
work as a senior software engineer at

00:00:59,609 --> 00:01:01,859
Eventbrite if you're not familiar we are

00:01:01,859 --> 00:01:03,899
a ticketing company to get events and

00:01:03,899 --> 00:01:05,760
races and all manner of things like that

00:01:05,760 --> 00:01:08,729
and I have a fun side project of doing

00:01:08,729 --> 00:01:11,460
network programming for fun as you will

00:01:11,460 --> 00:01:13,680
see here no sane person would probably

00:01:13,680 --> 00:01:18,840
do this willingly maybe so let's start a

00:01:18,840 --> 00:01:21,479
bit of history 2015 is when I first

00:01:21,479 --> 00:01:24,030
started working on channels back then it

00:01:24,030 --> 00:01:27,110
was sort of nascent project of like

00:01:27,110 --> 00:01:29,220
migrations had mostly been done it was

00:01:29,220 --> 00:01:31,140
merged into Chango some of my fellow

00:01:31,140 --> 00:01:32,939
django team members had taken over some

00:01:32,939 --> 00:01:35,280
of the maintenance thanks Marcos and so

00:01:35,280 --> 00:01:37,290
I wanted to work on a new problem and

00:01:37,290 --> 00:01:39,920
that new problem in my mind was

00:01:39,920 --> 00:01:42,420
WebSockets and other sort of new forms

00:01:42,420 --> 00:01:44,750
of protocols on the web in particular

00:01:44,750 --> 00:01:49,290
channels 0.1 and through up to 1.0 had

00:01:49,290 --> 00:01:51,930
sort of some basic headline goals the

00:01:51,930 --> 00:01:53,850
key thing was to add a sync protocol

00:01:53,850 --> 00:01:56,040
support to Django that is for protocols

00:01:56,040 --> 00:01:57,869
that are not just a request response

00:01:57,869 --> 00:02:00,390
like like HTTP but have an ongoing

00:02:00,390 --> 00:02:02,880
socket where you open a socket you send

00:02:02,880 --> 00:02:04,829
some stuff down you send some stuff back

00:02:04,829 --> 00:02:06,960
it stays open for a bit longer and you

00:02:06,960 --> 00:02:08,819
sort of have much more of a conversation

00:02:08,819 --> 00:02:10,739
than the single question and answer you

00:02:10,739 --> 00:02:13,569
get over HTTP obviously

00:02:13,569 --> 00:02:15,939
for that the headline protocol is

00:02:15,939 --> 00:02:18,790
WebSockets it has a lot of support at

00:02:18,790 --> 00:02:20,590
the time and still now it's quite

00:02:20,590 --> 00:02:22,090
popular and being used for love

00:02:22,090 --> 00:02:24,549
interesting applications on the web real

00:02:24,549 --> 00:02:26,499
time things and games stuff like that

00:02:26,499 --> 00:02:28,659
but I also wanted to have things beyond

00:02:28,659 --> 00:02:30,040
just WebSockets I went to background

00:02:30,040 --> 00:02:31,840
jobs I've heard other support protocols

00:02:31,840 --> 00:02:35,200
as well and all this resulted in around

00:02:35,200 --> 00:02:36,310
2017

00:02:36,310 --> 00:02:39,579
channels 1.0 it was a good two years of

00:02:39,579 --> 00:02:43,150
work and I went through it least it was

00:02:43,150 --> 00:02:44,680
stable it was being used in production

00:02:44,680 --> 00:02:46,780
and it was generally pretty good it

00:02:46,780 --> 00:02:48,819
achieved a lot of those top goals I just

00:02:48,819 --> 00:02:50,560
showed you but there were some problems

00:02:50,560 --> 00:02:54,069
I had made some choices in the design of

00:02:54,069 --> 00:02:56,530
that remember this started in 2015 it's

00:02:56,530 --> 00:02:59,919
now three years ago the thing I thought

00:02:59,919 --> 00:03:01,959
I had to the time was to be Python 2

00:03:01,959 --> 00:03:04,510
compatible Django still was the Django

00:03:04,510 --> 00:03:06,879
LTS at that point was was Django 2

00:03:06,879 --> 00:03:10,180
compatible and so I picked Python 2.7 as

00:03:10,180 --> 00:03:12,459
my base support language and that's

00:03:12,459 --> 00:03:15,099
throughout any idea of async IO support

00:03:15,099 --> 00:03:17,620
I also then picked twisted web server

00:03:17,620 --> 00:03:19,629
because twisted is very reliable has a

00:03:19,629 --> 00:03:20,919
lot of things you can haz plug-in use

00:03:20,919 --> 00:03:25,329
Autobahn as well WebSockets and I stuck

00:03:25,329 --> 00:03:27,669
with synchronous Django I wanted to keep

00:03:27,669 --> 00:03:29,229
that familiarity

00:03:29,229 --> 00:03:31,359
I also not rewrite a lot of Django in

00:03:31,359 --> 00:03:33,639
the process and so you ended up with a

00:03:33,639 --> 00:03:36,370
bit of a weird design about how things

00:03:36,370 --> 00:03:38,799
looked you had this idea of like well

00:03:38,799 --> 00:03:41,290
you have a twisted web server which is

00:03:41,290 --> 00:03:43,030
capable of being highly concurrent it

00:03:43,030 --> 00:03:44,680
can handle hundreds of sockets at once

00:03:44,680 --> 00:03:47,109
easily and you have a synchronous Django

00:03:47,109 --> 00:03:49,569
process that handles things just in a

00:03:49,569 --> 00:03:51,069
big for loop and has one thing at a time

00:03:51,069 --> 00:03:54,579
and these of course can't coexist in

00:03:54,579 --> 00:03:57,430
Python 2 you can't do that and so I also

00:03:57,430 --> 00:03:59,799
had a channel layer this was a piece

00:03:59,799 --> 00:04:02,409
that allowed you to take the async

00:04:02,409 --> 00:04:04,479
scheduling part out of Python and run it

00:04:04,479 --> 00:04:07,269
sort of as a separate piece of code in

00:04:07,269 --> 00:04:09,939
this case Redis was what I use to power

00:04:09,939 --> 00:04:11,909
the async part of that kind of stuff

00:04:11,909 --> 00:04:14,949
now this of course is a bit over

00:04:14,949 --> 00:04:17,769
complicated it gets a bit more so but

00:04:17,769 --> 00:04:19,810
also better when you consider you have

00:04:19,810 --> 00:04:21,430
more than one server and more than one


00:04:21,430 --> 00:04:23,560
Django process because most sites aren't


00:04:23,560 --> 00:04:25,870
just one box and so what you would do is


00:04:25,870 --> 00:04:26,790
you have


00:04:26,790 --> 00:04:29,550
twisted servers in a sort of array that

00:04:29,550 --> 00:04:30,840
things had talked to and then low

00:04:30,840 --> 00:04:32,520
bounced across and they'd all go through

00:04:32,520 --> 00:04:34,350
a central layer and they'd all go to a

00:04:34,350 --> 00:04:36,900
big pool of worker servers and whenever

00:04:36,900 --> 00:04:39,150
you had an event on a WebSocket would go

00:04:39,150 --> 00:04:41,850
into the thing through the network find

00:04:41,850 --> 00:04:43,710
a Django worker run some code

00:04:43,710 --> 00:04:45,390
synchronously finish and then come back

00:04:45,390 --> 00:04:49,530
to the twisted server so Python 2.7

00:04:49,530 --> 00:04:52,020
this was back all you could do I was

00:04:52,020 --> 00:04:54,210
designed limited by my own choices but

00:04:54,210 --> 00:04:56,160
as you can imagine it has too many

00:04:56,160 --> 00:04:58,260
moving pieces there's a reason we don't

00:04:58,260 --> 00:05:00,360
generally have big Network layers in the

00:05:00,360 --> 00:05:02,400
middle of our application stacks you do

00:05:02,400 --> 00:05:04,260
need them eventually one of the things

00:05:04,260 --> 00:05:05,520
we're learning in Eventbrite is that

00:05:05,520 --> 00:05:07,350
like designing a service-oriented

00:05:07,350 --> 00:05:09,240
architecture involves solving a lot of

00:05:09,240 --> 00:05:11,460
those problems but most people don't

00:05:11,460 --> 00:05:13,320
need those and Django as a framework

00:05:13,320 --> 00:05:15,270
does not need to help you do that stuff

00:05:15,270 --> 00:05:18,150
on top of that it doesn't have any async

00:05:18,150 --> 00:05:21,210
IO support these days Python 3 is very

00:05:21,210 --> 00:05:24,270
commonplace most things start in Python

00:05:24,270 --> 00:05:26,610
3 we're now at the amazing point where

00:05:26,610 --> 00:05:29,250
we have libraries on pipe either only

00:05:29,250 --> 00:05:31,320
Welcome 3 and don't work on 2 which is

00:05:31,320 --> 00:05:33,450
an amazing place to be and so it felt

00:05:33,450 --> 00:05:35,280
like it's about an artifact of the past

00:05:35,280 --> 00:05:37,830
it was this sort of remnant of the last

00:05:37,830 --> 00:05:42,090
hurrah of 2.7 and finally the design

00:05:42,090 --> 00:05:43,680
made it very easy to shoot yourself in

00:05:43,680 --> 00:05:45,360
the foot because it was full of these

00:05:45,360 --> 00:05:47,250
weird synchronous processes and didn't

00:05:47,250 --> 00:05:49,140
work to key well and a lot of the

00:05:49,140 --> 00:05:51,870
components were invented from scratch it

00:05:51,870 --> 00:05:53,850
was a little bit too easy to like not

00:05:53,850 --> 00:05:55,440
deadlock but to lock up a whole worker

00:05:55,440 --> 00:05:58,020
process or leave something running too

00:05:58,020 --> 00:05:59,640
long and just generally you couldn't do

00:05:59,640 --> 00:06:01,890
as much you could do with full icing

00:06:01,890 --> 00:06:04,830
support and so one of the things it took

00:06:04,830 --> 00:06:06,180
me a while to do this and I had to sort

00:06:06,180 --> 00:06:08,070
of sit down and go through it but I had

00:06:08,070 --> 00:06:10,170
to admit I was wrong and I think very

00:06:10,170 --> 00:06:11,940
important to say this it's very hard for

00:06:11,940 --> 00:06:14,190
big projects to take a big turn like I

00:06:14,190 --> 00:06:17,160
had to do in this case and change your

00:06:17,160 --> 00:06:19,800
analysis of the problem entirely but at

00:06:19,800 --> 00:06:21,750
the end of the day channels one was a

00:06:21,750 --> 00:06:23,970
nice research project it achieved the

00:06:23,970 --> 00:06:25,890
goals I set out to do it was not a

00:06:25,890 --> 00:06:29,220
long-term solution and so what does a

00:06:29,220 --> 00:06:32,070
long-term solution for Django and for

00:06:32,070 --> 00:06:35,400
Python look like well that's kind of all

00:06:35,400 --> 00:06:36,630
I've been trying to do with channels 2

00:06:36,630 --> 00:06:39,240
channels 2.0 was released earlier this

00:06:39,240 --> 00:06:40,080
year

00:06:40,080 --> 00:06:43,710
it is a pretty significant change from

00:06:43,710 --> 00:06:45,840
the previous iterations in the Channel

00:06:45,840 --> 00:06:47,880
series and I'm going to go through in

00:06:47,880 --> 00:06:49,770
the rest of the presentation some of

00:06:49,770 --> 00:06:52,620
those changes and how taking up a sink

00:06:52,620 --> 00:06:55,009
much more at its face value has

00:06:55,009 --> 00:06:57,720
rethought how I think of Django and web

00:06:57,720 --> 00:07:00,060
flows in general the key things about

00:07:00,060 --> 00:07:03,270
channels to our first and foremost is a

00:07:03,270 --> 00:07:05,819
Cinco native this was the biggest cause

00:07:05,819 --> 00:07:07,650
of the rewrite of course doing this

00:07:07,650 --> 00:07:09,690
means you have to be Python 3.5 that's

00:07:09,690 --> 00:07:11,310
where async EO comes into the standard

00:07:11,310 --> 00:07:13,770
library and more importantly I wanted to

00:07:13,770 --> 00:07:15,810
use the async DEF keyword which is what

00:07:15,810 --> 00:07:19,110
3.5 gives you and I wanted to not only

00:07:19,110 --> 00:07:21,870
have support for async code but also for

00:07:21,870 --> 00:07:24,060
synchronous code our discusses a bit

00:07:24,060 --> 00:07:26,160
later but it's in my opinion very

00:07:26,160 --> 00:07:28,139
important to have the ability to support

00:07:28,139 --> 00:07:30,599
both of those different things and so

00:07:30,599 --> 00:07:33,000
taking this into consideration and also

00:07:33,000 --> 00:07:34,560
the history of Python web programming

00:07:34,560 --> 00:07:38,009
had a much more familiar model channels

00:07:38,009 --> 00:07:40,770
to runs like this it runs like normal

00:07:40,770 --> 00:07:43,020
Python web permits do you have a web

00:07:43,020 --> 00:07:45,419
server and inside that web server you

00:07:45,419 --> 00:07:47,430
run your application in this case you

00:07:47,430 --> 00:07:51,509
run Django it's simplistic there's one

00:07:51,509 --> 00:07:53,400
moving piece there's no network layer

00:07:53,400 --> 00:07:55,139
hidden in there mysteriously causing

00:07:55,139 --> 00:07:58,440
errors there is still a need for cross

00:07:58,440 --> 00:08:00,750
process communication one of the

00:08:00,750 --> 00:08:03,090
problems that you find with WebSockets

00:08:03,090 --> 00:08:05,009
in particular is the applications you

00:08:05,009 --> 00:08:07,020
build require a lot more coordination

00:08:07,020 --> 00:08:09,659
and crosstalk between services and so

00:08:09,659 --> 00:08:10,889
one of the things channels does provide

00:08:10,889 --> 00:08:13,199
still is that crosstalk layer the

00:08:13,199 --> 00:08:14,820
channel layer is still there but it is

00:08:14,820 --> 00:08:17,130
now an optional component and most of

00:08:17,130 --> 00:08:18,750
the traffic does not go through it it's

00:08:18,750 --> 00:08:21,570
only for broadcast and process to

00:08:21,570 --> 00:08:23,699
process messaging if you're writing a

00:08:23,699 --> 00:08:25,979
chat application it's there for you you

00:08:25,979 --> 00:08:28,229
can say oh send this message to all the

00:08:28,229 --> 00:08:29,580
other people listening on these sockets

00:08:29,580 --> 00:08:32,940
it'll do that it's also deliberately a

00:08:32,940 --> 00:08:35,849
lot more simplistic aid he'd be easier

00:08:35,849 --> 00:08:37,890
to maintain and be because it does not

00:08:37,890 --> 00:08:39,630
have to fulfill that middle role it did

00:08:39,630 --> 00:08:41,270
before

00:08:41,270 --> 00:08:44,070
the end result this is not a complete

00:08:44,070 --> 00:08:46,110
rewrite of channels it was about a 75%

00:08:46,110 --> 00:08:48,690
rewrite obviously all the code that used

00:08:48,690 --> 00:08:51,720
to be weird synchronous staff happy

00:08:51,720 --> 00:08:53,070
rewritten

00:08:53,070 --> 00:08:55,650
the twisted code did not twist it has

00:08:55,650 --> 00:08:57,960
very good async support these days and

00:08:57,960 --> 00:08:59,580
so I just plugged in an async reactor

00:08:59,580 --> 00:09:00,870
and change a few things and that kept

00:09:00,870 --> 00:09:03,060
working but a lot of the rest of it had

00:09:03,060 --> 00:09:04,590
to change especially in the Jango layer

00:09:04,590 --> 00:09:08,070
as well and one of the big problems you

00:09:08,070 --> 00:09:10,830
get when you get to this point is about

00:09:10,830 --> 00:09:13,980
how you write a synchros code in Python

00:09:13,980 --> 00:09:15,690
and the way we do asynchronous code in

00:09:15,690 --> 00:09:18,900
Python an asynchronous function and a

00:09:18,900 --> 00:09:21,150
synchronous function a very distinct you

00:09:21,150 --> 00:09:22,710
can't write one thing that satisfies

00:09:22,710 --> 00:09:26,160
both interfaces what this means is it's

00:09:26,160 --> 00:09:28,230
near impossible to write an API that

00:09:28,230 --> 00:09:29,850
provides both synchronous and

00:09:29,850 --> 00:09:32,190
asynchronous version without sitting

00:09:32,190 --> 00:09:34,350
there and writing everything twice this

00:09:34,350 --> 00:09:35,880
is one of the reasons you see separate

00:09:35,880 --> 00:09:38,040
libraries for like talking to various

00:09:38,040 --> 00:09:39,840
asynchronously you're doing HTTP at

00:09:39,840 --> 00:09:42,110
synchronously they're just different

00:09:42,110 --> 00:09:44,520
api's you can't handle the same thing in

00:09:44,520 --> 00:09:47,700
the same place and so I really had to

00:09:47,700 --> 00:09:49,860
sit down and work out how to overcome

00:09:49,860 --> 00:09:51,840
this problem I don't want to rewrite all

00:09:51,840 --> 00:09:54,840
of Jango to be asynchronous like I'd

00:09:54,840 --> 00:09:57,210
love to but I am but one man and I only

00:09:57,210 --> 00:09:58,560
have about you know a day a week to do

00:09:58,560 --> 00:10:00,060
this in and then we have got until like

00:10:00,060 --> 00:10:03,600
in next millennium and so that it's not

00:10:03,600 --> 00:10:05,000
kind of the biggest problem I faced

00:10:05,000 --> 00:10:07,590
before we dive deeper if you're curious

00:10:07,590 --> 00:10:09,360
about this topic at all I have a blog

00:10:09,360 --> 00:10:11,790
post you can look at that covers the

00:10:11,790 --> 00:10:14,790
background of how asynchronous and

00:10:14,790 --> 00:10:16,350
synchronous functions are different in

00:10:16,350 --> 00:10:18,210
Python it has a good coverage of like

00:10:18,210 --> 00:10:19,800
how thread loots work and how the

00:10:19,800 --> 00:10:21,930
implication behind its it's not going to

00:10:21,930 --> 00:10:23,610
weather here but as some background

00:10:23,610 --> 00:10:26,250
reading it's quite a nice high-level

00:10:26,250 --> 00:10:28,440
idea of why they're different but the

00:10:28,440 --> 00:10:30,780
key thing is and assumption in this talk

00:10:30,780 --> 00:10:32,370
is they are different you can't find the

00:10:32,370 --> 00:10:35,760
same way and this meant that I had to

00:10:35,760 --> 00:10:37,890
make Jango at least partially async if

00:10:37,890 --> 00:10:39,420
you're gonna handle WebSockets in

00:10:39,420 --> 00:10:41,910
particular you have to be async up to a

00:10:41,910 --> 00:10:43,740
certain point like the thing that

00:10:43,740 --> 00:10:44,910
handles the sockets the thing that

00:10:44,910 --> 00:10:47,160
handles the basic business logic has to

00:10:47,160 --> 00:10:49,470
be capable of keeping that socket open

00:10:49,470 --> 00:10:51,870
for a long time in parallel with other

00:10:51,870 --> 00:10:54,900
things so let's talk about how Jango is

00:10:54,900 --> 00:10:58,950
structured Jango is sort of a sort of

00:10:58,950 --> 00:11:01,530
basic layer model this is a simplistic

00:11:01,530 --> 00:11:03,780
version but one of my favorite ways

00:11:03,780 --> 00:11:05,730
thinking about Django is a series of

00:11:05,730 --> 00:11:06,840
layers stacked on top

00:11:06,840 --> 00:11:08,670
of each other at the very bottom you

00:11:08,670 --> 00:11:10,770
have a WSGI handler that takes your

00:11:10,770 --> 00:11:14,220
incoming basic raw WSGI request and

00:11:14,220 --> 00:11:17,190
turns into a Django request object above

00:11:17,190 --> 00:11:19,320
that you have a URL routing that reads

00:11:19,320 --> 00:11:21,510
the request object finds of you and then

00:11:21,510 --> 00:11:25,080
gives it to the view above that you have

00:11:25,080 --> 00:11:27,150
middleware so before you get to review

00:11:27,150 --> 00:11:28,830
you run through some middleware it adds

00:11:28,830 --> 00:11:30,930
things like authentication and sessions

00:11:30,930 --> 00:11:31,800
and all that stuff

00:11:31,800 --> 00:11:33,930
then you come to a view that's business

00:11:33,930 --> 00:11:35,670
logic in presentation and then finally

00:11:35,670 --> 00:11:37,560
from a view you're usually talking to

00:11:37,560 --> 00:11:40,050
the ORM obviously middleware talks to

00:11:40,050 --> 00:11:41,580
the RM as well but this is a simplistic

00:11:41,580 --> 00:11:44,520
version now that works fine for

00:11:44,520 --> 00:11:47,250
synchronous stuff but we need to think

00:11:47,250 --> 00:11:51,800
about when it's asynchronous so if

00:11:51,800 --> 00:11:55,530
instead we do this we had entered a

00:11:55,530 --> 00:11:57,090
separate layer of stuff that is

00:11:57,090 --> 00:11:59,490
asynchronous capable inside Django and

00:11:59,490 --> 00:12:00,600
that replicates a lot of that behavior

00:12:00,600 --> 00:12:03,630
up through the stack so in particular

00:12:03,630 --> 00:12:06,690
rather than normal Django URL routing we

00:12:06,690 --> 00:12:07,950
have to have a different kind of routing

00:12:07,950 --> 00:12:10,440
that's async capable that can coexist

00:12:10,440 --> 00:12:14,730
like you can be the other stuff we have

00:12:14,730 --> 00:12:15,930
to have asynchronous middleware

00:12:15,930 --> 00:12:17,670
asynchronous views which we call

00:12:17,670 --> 00:12:19,650
consumers in channels so these all

00:12:19,650 --> 00:12:20,790
mirror their components in the

00:12:20,790 --> 00:12:23,340
synchronous sphere but the one thing I

00:12:23,340 --> 00:12:26,820
couldn't tackle easily is the RM and so

00:12:26,820 --> 00:12:28,980
you can see here the synchronous part is

00:12:28,980 --> 00:12:30,420
highlighted in this blue square on the

00:12:30,420 --> 00:12:33,750
left there is still need to call into

00:12:33,750 --> 00:12:36,690
synchronous Chango not only for the RM

00:12:36,690 --> 00:12:40,590
at the top there but also excuse me but

00:12:40,590 --> 00:12:42,870
also if you are trying to call a normal

00:12:42,870 --> 00:12:44,670
django view if you have a site that's

00:12:44,670 --> 00:12:46,380
mixed between WebSockets and normal

00:12:46,380 --> 00:12:48,360
django you want to call the normal stuff

00:12:48,360 --> 00:12:50,100
you have to drop down as normal django

00:12:50,100 --> 00:12:54,300
for that and so I can replace the WSGI

00:12:54,300 --> 00:12:55,560
handler with an asynchronous version

00:12:55,560 --> 00:12:57,690
that makes a request object but at some

00:12:57,690 --> 00:12:58,860
point you have to drop down into

00:12:58,860 --> 00:13:02,840
synchronous land and how I do that well

00:13:02,840 --> 00:13:05,510
you can see there like I've made Django

00:13:05,510 --> 00:13:08,100
async native most of the way in a

00:13:08,100 --> 00:13:11,130
parallel fashion but I had to bridge

00:13:11,130 --> 00:13:14,490
those gaps at some point and that really

00:13:14,490 --> 00:13:17,850
comes down to a a lot of frustration and

00:13:17,850 --> 00:13:20,040
weekends tearing my hair out

00:13:20,040 --> 00:13:21,930
and be to functions that were the result

00:13:21,930 --> 00:13:25,980
of said hair tearing firstly a function

00:13:25,980 --> 00:13:29,029
called sink to a sink my voice is going

00:13:29,029 --> 00:13:32,220
perfect timing for this and secondly a

00:13:32,220 --> 00:13:34,380
sink to sink the idea is these two

00:13:34,380 --> 00:13:37,800
functions bridge those two worlds sink

00:13:37,800 --> 00:13:39,540
to a sink can take asynchronous Python

00:13:39,540 --> 00:13:41,550
function and make it away table and it

00:13:41,550 --> 00:13:44,160
runs it in a background thread a sink to

00:13:44,160 --> 00:13:46,380
sink can take a a weighted ball

00:13:46,380 --> 00:13:49,170
co-routine in - that's asynchronous and

00:13:49,170 --> 00:13:50,880
turn it into a blocking synchronous

00:13:50,880 --> 00:13:53,610
function that pauses the thread you call

00:13:53,610 --> 00:13:56,220
it from jumps to the thread the main the

00:13:56,220 --> 00:13:57,810
main thread with the event loop runs it

00:13:57,810 --> 00:13:59,149
there and then jumps back again and

00:13:59,149 --> 00:14:03,269
these are the key components of how we

00:14:03,269 --> 00:14:06,060
managed to get that support for crossing

00:14:06,060 --> 00:14:10,350
those two worlds into Jango itself so

00:14:10,350 --> 00:14:12,089
let's go into a bit more technical

00:14:12,089 --> 00:14:13,579
detail about those particular things

00:14:13,579 --> 00:14:16,889
first of all sink to a sink this is in

00:14:16,889 --> 00:14:20,790
many ways the easier of the two it's not

00:14:20,790 --> 00:14:23,130
super easy but a lot of the things that

00:14:23,130 --> 00:14:24,360
you need for this are provided by the

00:14:24,360 --> 00:14:27,750
standard library in Python so the first

00:14:27,750 --> 00:14:29,519
obvious thing not obvious the first

00:14:29,519 --> 00:14:31,529
thing to note synchronous code has to

00:14:31,529 --> 00:14:33,149
run in threads so we are going to run

00:14:33,149 --> 00:14:34,680
more than one synchronous function we

00:14:34,680 --> 00:14:36,750
can't just block the entire main thread

00:14:36,750 --> 00:14:38,790
where the async layer event loop is

00:14:38,790 --> 00:14:40,889
running and so we have to have these

00:14:40,889 --> 00:14:43,199
running sub threads threads in Python

00:14:43,199 --> 00:14:45,420
are not great the context switching is a

00:14:45,420 --> 00:14:47,279
little bit inefficient as many Python

00:14:47,279 --> 00:14:49,800
talks have previously said but they are

00:14:49,800 --> 00:14:51,300
still useful things like this when you

00:14:51,300 --> 00:14:52,920
want to get down briefly run a function

00:14:52,920 --> 00:14:55,139
and pop out again and the standard

00:14:55,139 --> 00:14:57,329
library has a thing called the thread

00:14:57,329 --> 00:14:59,550
pool executor which does this you can

00:14:59,550 --> 00:15:02,430
say hey I have a task you can make a

00:15:02,430 --> 00:15:04,470
thread pool and you say run this in that

00:15:04,470 --> 00:15:06,630
task run this task in that pool and give

00:15:06,630 --> 00:15:09,209
me the result back the simplified code

00:15:09,209 --> 00:15:11,430
looks a bit like this there's a few more

00:15:11,430 --> 00:15:13,949
exception handling pieces around this in

00:15:13,949 --> 00:15:16,350
the code we have in channels but the

00:15:16,350 --> 00:15:18,660
basic flow is similar you find your

00:15:18,660 --> 00:15:20,670
event loop you make a future that

00:15:20,670 --> 00:15:22,800
represents running your task in a thread

00:15:22,800 --> 00:15:25,290
pool and then use a weight on the future

00:15:25,290 --> 00:15:27,899
when you call a weight here behind the

00:15:27,899 --> 00:15:30,089
scenes the thread pool spins up and runs

00:15:30,089 --> 00:15:32,279
your task and then your Co routine

00:15:32,279 --> 00:15:33,700
you're writing this in will just

00:15:33,700 --> 00:15:35,740
and wait for the future to return once

00:15:35,740 --> 00:15:41,380
that's read is complete now this is

00:15:41,380 --> 00:15:44,260
mostly used for things like calling the

00:15:44,260 --> 00:15:47,140
ORM rendering templates other parts of

00:15:47,140 --> 00:15:48,580
Django that you saw crossing that

00:15:48,580 --> 00:15:50,680
boundary just now we're like okay I need

00:15:50,680 --> 00:15:52,990
to talk to a bit of Django that existed

00:15:52,990 --> 00:15:55,330
before that is synchronous and that has

00:15:55,330 --> 00:15:57,610
to run in a thread the ORM is

00:15:57,610 --> 00:15:59,880
particularly tricky Django has

00:15:59,880 --> 00:16:02,260
connection handling that pulls

00:16:02,260 --> 00:16:03,850
connections and threads and make sure

00:16:03,850 --> 00:16:05,230
they're shared between threads properly

00:16:05,230 --> 00:16:07,660
that relies heavily on a request

00:16:07,660 --> 00:16:10,420
response sequence and so one of the

00:16:10,420 --> 00:16:12,580
things we had to do was when you call

00:16:12,580 --> 00:16:14,770
the arm in a thread when the thread

00:16:14,770 --> 00:16:16,150
finishes sit there and clean up

00:16:16,150 --> 00:16:17,650
everything at the end go placate we have

00:16:17,650 --> 00:16:19,300
to like close connections to like that

00:16:19,300 --> 00:16:22,030
and so it's a little bit strange and one

00:16:22,030 --> 00:16:24,130
of the unfortunate side effects is you

00:16:24,130 --> 00:16:25,390
just end up with a lot of outbound

00:16:25,390 --> 00:16:28,480
connections the thread pool defaults to

00:16:28,480 --> 00:16:30,970
five times the number of CPUs you have

00:16:30,970 --> 00:16:33,070
in your machine so you have a 16 core

00:16:33,070 --> 00:16:34,510
machine you're gonna get over a hundred

00:16:34,510 --> 00:16:36,940
threads all trying to connect at once to

00:16:36,940 --> 00:16:39,550
the database that surprised a few people

00:16:39,550 --> 00:16:42,160
but you can tweak that stuff but in

00:16:42,160 --> 00:16:43,330
general for the smaller stuff it works

00:16:43,330 --> 00:16:46,330
really well the more difficult problem

00:16:46,330 --> 00:16:48,300
however is going the other way

00:16:48,300 --> 00:16:51,430
synched a sink is pretty built into the

00:16:51,430 --> 00:16:54,670
chat Python core I think three point

00:16:54,670 --> 00:16:56,080
seven has even better support for that

00:16:56,080 --> 00:16:58,660
stuff going the other way is much less

00:16:58,660 --> 00:17:03,490
common and this is because async code

00:17:03,490 --> 00:17:06,460
has to run on an event loop it has to

00:17:06,460 --> 00:17:07,780
have the thing that provides it a waiter

00:17:07,780 --> 00:17:09,280
balls and provides it the way to do

00:17:09,280 --> 00:17:13,210
interrupts and if you're running in a

00:17:13,210 --> 00:17:14,980
process that we have here there's

00:17:14,980 --> 00:17:16,750
already an event loop in the main thread

00:17:16,750 --> 00:17:18,850
and the particular problem comes when

00:17:18,850 --> 00:17:21,400
your nesting these two things so say

00:17:21,400 --> 00:17:23,590
what I've done is I have called

00:17:23,590 --> 00:17:25,270
asynchronous function from my a

00:17:25,270 --> 00:17:27,310
synchro's main thread okay we're now in

00:17:27,310 --> 00:17:29,710
a sub thread the synchronous I then want

00:17:29,710 --> 00:17:31,240
to call them asynchronous API in

00:17:31,240 --> 00:17:33,490
channels from that sub thread so we've

00:17:33,490 --> 00:17:36,610
then go out of the thread back up to the

00:17:36,610 --> 00:17:38,710
main thread find the event loop then

00:17:38,710 --> 00:17:41,290
come back down again and keep going No

00:17:41,290 --> 00:17:44,200
thank you very much and so it's a little

00:17:44,200 --> 00:17:46,060
bit tricky the code is not quite as

00:17:46,060 --> 00:17:47,710
readable on the screen it's deliberate

00:17:47,710 --> 00:17:50,500
don't worry it's more than this too but

00:17:50,500 --> 00:17:52,120
the basic flow of it is that it tries to

00:17:52,120 --> 00:17:54,659
go up and find that thread you can

00:17:54,659 --> 00:17:57,760
instead try and open a new event loop in

00:17:57,760 --> 00:17:59,140
the sub thread that's the thing that

00:17:59,140 --> 00:18:00,880
Python lets you do you can run as many

00:18:00,880 --> 00:18:02,770
event loops as you like but that is

00:18:02,770 --> 00:18:04,059
gonna be less efficient because you are

00:18:04,059 --> 00:18:05,409
running more loops they all this me or

00:18:05,409 --> 00:18:07,720
more sockets and so one of the things

00:18:07,720 --> 00:18:09,309
that channel's tries to do is if you ask

00:18:09,309 --> 00:18:10,750
for an async function it's going to pop

00:18:10,750 --> 00:18:12,070
back up and try and run it on the main

00:18:12,070 --> 00:18:16,299
loop and why do we need this

00:18:16,299 --> 00:18:20,230
well the key reason is again I wanted to

00:18:20,230 --> 00:18:24,340
only write things once in particular I

00:18:24,340 --> 00:18:26,770
had to rewrite say authentication for

00:18:26,770 --> 00:18:29,620
channels and if you want to have a North

00:18:29,620 --> 00:18:31,990
API that runs in both I want to write it

00:18:31,990 --> 00:18:33,940
once and then have a compatibility layer

00:18:33,940 --> 00:18:36,490
like these two functions make it usable

00:18:36,490 --> 00:18:39,370
from the other side and so rather than

00:18:39,370 --> 00:18:40,870
write things synchronously and have them

00:18:40,870 --> 00:18:41,710
call them threads

00:18:41,710 --> 00:18:43,149
I want to write them in the future way

00:18:43,149 --> 00:18:45,549
which is running asynchronously and if

00:18:45,549 --> 00:18:47,529
you wanted to let you call them from old

00:18:47,529 --> 00:18:50,649
code by using the async to sync function

00:18:50,649 --> 00:18:55,539
instead and that really helps reduce the

00:18:55,539 --> 00:18:57,130
maintenance workload and stuff like this

00:18:57,130 --> 00:18:59,169
because I can just write one set of

00:18:59,169 --> 00:19:01,480
async api's and then just say everywhere

00:19:01,480 --> 00:19:03,520
in the documentation hey if you want to

00:19:03,520 --> 00:19:04,840
call this from a synchronous place just

00:19:04,840 --> 00:19:07,299
wrap it in a sink to sync that really

00:19:07,299 --> 00:19:09,460
helps just have like one or system one

00:19:09,460 --> 00:19:11,740
session system and all the things that

00:19:11,740 --> 00:19:13,779
channels provides obviously those things

00:19:13,779 --> 00:19:15,580
are in Django and channels but there are

00:19:15,580 --> 00:19:16,899
other things too like the channel layers

00:19:16,899 --> 00:19:19,390
if you want to send a message through

00:19:19,390 --> 00:19:21,399
Redis to another to a broadcast set of

00:19:21,399 --> 00:19:24,039
people that's all a sync native it uses

00:19:24,039 --> 00:19:26,860
a i/o Redis underneath it uses a weight

00:19:26,860 --> 00:19:28,960
and they sync everywhere and if you're

00:19:28,960 --> 00:19:30,669
in synchronous code before you just

00:19:30,669 --> 00:19:32,559
couldn't call that which is why lacy

00:19:32,559 --> 00:19:34,510
written synchronously but now we can

00:19:34,510 --> 00:19:37,000
just say hey they seem to sync this and

00:19:37,000 --> 00:19:39,279
then run it wherever you like you can

00:19:39,279 --> 00:19:41,260
even use it outside of channels if

00:19:41,260 --> 00:19:42,820
you're just in a normal synchronous

00:19:42,820 --> 00:19:44,710
application and call async to sync it

00:19:44,710 --> 00:19:49,419
will then make its own event loop and

00:19:49,419 --> 00:19:50,649
just run it inside the thread so it

00:19:50,649 --> 00:19:53,140
really is usable and flexible through

00:19:53,140 --> 00:19:54,970
pretty much every place you would try

00:19:54,970 --> 00:19:56,470
and run asynchronous code from a

00:19:56,470 --> 00:19:59,830
synchronous context and the key thing

00:19:59,830 --> 00:20:01,570
here is that like I don't think

00:20:01,570 --> 00:20:03,429
we'll ever be in a place we only write

00:20:03,429 --> 00:20:05,470
one kind of code at least as it

00:20:05,470 --> 00:20:06,629
currently stands

00:20:06,629 --> 00:20:10,989
pythons async report is not perfect and

00:20:10,989 --> 00:20:13,539
certainly not superior in every way to a

00:20:13,539 --> 00:20:16,029
synchronous support it is much harder to

00:20:16,029 --> 00:20:18,190
write and it's much more dangerous in

00:20:18,190 --> 00:20:20,529
certain ways for example if you're not

00:20:20,529 --> 00:20:23,139
familiar you can easily just write a

00:20:23,139 --> 00:20:25,210
function that blocks the entire event

00:20:25,210 --> 00:20:27,789
loop in Python 3 and if you haven't got

00:20:27,789 --> 00:20:29,919
the nice debug mode of the event loop

00:20:29,919 --> 00:20:31,629
turned on your whole thing will just

00:20:31,629 --> 00:20:33,309
hang for a bit while the function blocks

00:20:33,309 --> 00:20:36,249
and then just keep going and I really

00:20:36,249 --> 00:20:38,169
don't trust myself to write good

00:20:38,169 --> 00:20:40,629
asynchronous code I'm not sure I trust

00:20:40,629 --> 00:20:43,149
the general developer population to

00:20:43,149 --> 00:20:45,129
write it all the time either and I don't

00:20:45,129 --> 00:20:48,309
think they should I think the case here

00:20:48,309 --> 00:20:50,729
is when you need that high parallelism

00:20:50,729 --> 00:20:53,769
long-lived support then you can go async

00:20:53,769 --> 00:20:56,080
if you want safety and simplicity then

00:20:56,080 --> 00:20:58,299
you can go sync and that's really one of

00:20:58,299 --> 00:20:59,440
the ways channels that you do things are

00:20:59,440 --> 00:21:02,289
both and that's why I try to keep both

00:21:02,289 --> 00:21:04,179
systems here you can just write

00:21:04,179 --> 00:21:06,279
synchronous Django code and keep things

00:21:06,279 --> 00:21:07,840
working and have backwards compatibility

00:21:07,840 --> 00:21:10,989
you can also go into the brand-new shiny

00:21:10,989 --> 00:21:13,960
async world and keep things there you

00:21:13,960 --> 00:21:15,369
can even have a version of consumers

00:21:15,369 --> 00:21:17,049
where it goes synchronous in the

00:21:17,049 --> 00:21:19,450
consumer layer before but before the ORM

00:21:19,450 --> 00:21:20,919
layer if you want to write your code

00:21:20,919 --> 00:21:23,919
that way too but there is one part of

00:21:23,919 --> 00:21:25,950
this diagram that's still interesting

00:21:25,950 --> 00:21:29,409
and that's this section here there is a

00:21:29,409 --> 00:21:31,450
line from the outside mysterious world

00:21:31,450 --> 00:21:35,499
into my chart now in the first chart

00:21:35,499 --> 00:21:38,369
with the normal Django one that is WSGI

00:21:38,369 --> 00:21:41,049
we all know and love Everest GI it's

00:21:41,049 --> 00:21:41,979
been around for ages

00:21:41,979 --> 00:21:45,940
it is a incredibly successful interface

00:21:45,940 --> 00:21:49,419
that has let us swap frameworks and

00:21:49,419 --> 00:21:51,729
servers freely it so that let a lot of

00:21:51,729 --> 00:21:53,289
new servers spring up in the Python

00:21:53,289 --> 00:21:54,599
world like when I started doing Python

00:21:54,599 --> 00:21:57,190
you were locked to certain servers by

00:21:57,190 --> 00:21:58,869
certain frameworks like you couldn't use

00:21:58,869 --> 00:22:00,940
a different one and so like I remember

00:22:00,940 --> 00:22:03,190
seeing this come through and really

00:22:03,190 --> 00:22:04,899
relishing the freedom it gave to like

00:22:04,899 --> 00:22:06,359
swap between different things

00:22:06,359 --> 00:22:10,720
the problem with WSGI is that it is very

00:22:10,720 --> 00:22:12,279
much synchronous and it's very much

00:22:12,279 --> 00:22:14,259
based on that request response model of

00:22:14,259 --> 00:22:15,400
HTTP

00:22:15,400 --> 00:22:20,200
it's built as this way where you have a

00:22:20,200 --> 00:22:22,150
function you call the function with the

00:22:22,150 --> 00:22:23,730
request the function returns a response

00:22:23,730 --> 00:22:27,610
there is no real affordance there where

00:22:27,610 --> 00:22:29,440
you can make the function live for a

00:22:29,440 --> 00:22:30,850
long time it's not an asynchronous

00:22:30,850 --> 00:22:32,710
function it's from the early Python two

00:22:32,710 --> 00:22:35,320
days and so you have to really think

00:22:35,320 --> 00:22:37,540
like how do we take that and make it

00:22:37,540 --> 00:22:40,809
work for async my first attempt as you

00:22:40,809 --> 00:22:42,610
saw was not great full of weird

00:22:42,610 --> 00:22:45,790
networking layers but the version that

00:22:45,790 --> 00:22:48,429
channels uses I am quite proud of and I

00:22:48,429 --> 00:22:50,559
think it is a good replacement for that

00:22:50,559 --> 00:22:54,040
that kind of thing it is called a SGI

00:22:54,040 --> 00:22:56,140
because it's like whiskey with an A in

00:22:56,140 --> 00:22:56,530
it

00:22:56,530 --> 00:22:59,200
it's very inventive naming I'm on my

00:22:59,200 --> 00:23:01,210
part and it is basically an asynchronous

00:23:01,210 --> 00:23:03,700
version of whiskey I'll give you a brief

00:23:03,700 --> 00:23:07,300
tour of it here so your standard wsgi

00:23:07,300 --> 00:23:09,460
application of like this you have an

00:23:09,460 --> 00:23:12,070
application it takes two things and

00:23:12,070 --> 00:23:15,250
Enver on the Enver on is the dictionary

00:23:15,250 --> 00:23:16,570
of data from outside the environment

00:23:16,570 --> 00:23:18,760
things like here are the headers here's

00:23:18,760 --> 00:23:20,830
the request here's the par from HTTP all

00:23:20,830 --> 00:23:22,540
that stuff's in there and start

00:23:22,540 --> 00:23:24,309
responses the callable you use to send

00:23:24,309 --> 00:23:27,190
headers back so you get your Enron you

00:23:27,190 --> 00:23:29,110
work on it so like Django requests

00:23:29,110 --> 00:23:31,059
basically read the Enver on break the

00:23:31,059 --> 00:23:32,890
Enver on a part into a full of a quest

00:23:32,890 --> 00:23:34,929
object for you and do path analysis and

00:23:34,929 --> 00:23:36,940
stuff and then once you finish your

00:23:36,940 --> 00:23:38,860
business logic you call start response

00:23:38,860 --> 00:23:40,840
you send your headers in response code

00:23:40,840 --> 00:23:42,880
and then you just basically yield or

00:23:42,880 --> 00:23:46,120
return data out sent over the socket you

00:23:46,120 --> 00:23:50,050
can see here how it's not quite capable

00:23:50,050 --> 00:23:50,590
of doing

00:23:50,590 --> 00:23:52,059
long live connections but it could be

00:23:52,059 --> 00:23:55,059
closer so a SGI looks a bit different

00:23:55,059 --> 00:23:57,550
looks like this the first big difference

00:23:57,550 --> 00:24:00,970
is that it is a class the actual

00:24:00,970 --> 00:24:02,590
interface is is it's a callable it

00:24:02,590 --> 00:24:04,420
returns a callable as you can see here

00:24:04,420 --> 00:24:06,490
the class has a core method but this is

00:24:06,490 --> 00:24:08,950
the easiest way to explain it the first

00:24:08,950 --> 00:24:10,660
time you call it you give it your scope

00:24:10,660 --> 00:24:13,990
the scope is likely Enver on was it is a

00:24:13,990 --> 00:24:15,940
place where all the data about the

00:24:15,940 --> 00:24:18,010
connection that is there when the

00:24:18,010 --> 00:24:20,410
connection happens comes to you so for

00:24:20,410 --> 00:24:22,809
HTTP this is things like the path and

00:24:22,809 --> 00:24:24,700
the method and the headers web

00:24:24,700 --> 00:24:26,290
WebSockets is very similar it's like oh

00:24:26,290 --> 00:24:28,150
here is the WebSocket path here is the

00:24:28,150 --> 00:24:29,100
WebSocket headers

00:24:29,100 --> 00:24:31,019
here's the sub protocol they asked for

00:24:31,019 --> 00:24:33,269
but for other protocols can be different

00:24:33,269 --> 00:24:35,519
so for example if you are a chat bot

00:24:35,519 --> 00:24:37,710
this could be the room of your chap your

00:24:37,710 --> 00:24:39,570
chat bot is in for example or TCP

00:24:39,570 --> 00:24:42,750
endpoint and things like that and so you

00:24:42,750 --> 00:24:45,480
get this information and then the second

00:24:45,480 --> 00:24:48,240
callable is a KO routine and you get

00:24:48,240 --> 00:24:50,330
given two things receive an assent

00:24:50,330 --> 00:24:54,389
because we have taken away the idea of

00:24:54,389 --> 00:24:56,820
when the connection opens from the

00:24:56,820 --> 00:24:58,980
request happening because in a WebSocket

00:24:58,980 --> 00:25:00,450
you can open it then send things all the

00:25:00,450 --> 00:25:03,570
time we've taken away that sort of start

00:25:03,570 --> 00:25:06,059
of request from the scope yet we do much

00:25:06,059 --> 00:25:08,460
in the init here down into the call

00:25:08,460 --> 00:25:10,950
method and so what happens is you cut

00:25:10,950 --> 00:25:13,049
the call method that's called you get

00:25:13,049 --> 00:25:15,240
given these two away tables and it's

00:25:15,240 --> 00:25:18,419
your job application to sit there await

00:25:18,419 --> 00:25:19,740
events from the outside world and

00:25:19,740 --> 00:25:22,620
receive you'll get things like oh you've

00:25:22,620 --> 00:25:24,389
got you've got a WebSocket frame you've

00:25:24,389 --> 00:25:26,429
got a HTTP request stuff like that and

00:25:26,429 --> 00:25:29,610
when you get one to send stuff back the

00:25:29,610 --> 00:25:32,009
crucial thing is these are not raw much

00:25:32,009 --> 00:25:34,620
like WSGI there is a specification for

00:25:34,620 --> 00:25:36,509
how things look it's pretty close that

00:25:36,509 --> 00:25:39,990
WSGI on purpose but things like HTTP

00:25:39,990 --> 00:25:41,669
like the path is decoded for you

00:25:41,669 --> 00:25:43,620
properly things are split out for

00:25:43,620 --> 00:25:45,000
WebSockets you have a nice diction is

00:25:45,000 --> 00:25:46,679
like oh here's the text ID from the

00:25:46,679 --> 00:25:48,629
frame here's the but the binary data

00:25:48,629 --> 00:25:51,330
from the frame the decoding is done for

00:25:51,330 --> 00:25:53,159
you there as well and so it is still

00:25:53,159 --> 00:25:56,100
high level like WSGI is in that respect

00:25:56,100 --> 00:25:58,049
but it also gives you the ability to do

00:25:58,049 --> 00:26:00,059
what you like because this is just a KO

00:26:00,059 --> 00:26:02,490
routine you don't have to just receive

00:26:02,490 --> 00:26:04,379
and send you can launch your own

00:26:04,379 --> 00:26:06,840
background KO routine so for example in

00:26:06,840 --> 00:26:09,480
channels we have a base class of these

00:26:09,480 --> 00:26:12,299
that in its cool method before you even

00:26:12,299 --> 00:26:14,100
starts receiving launches a second

00:26:14,100 --> 00:26:15,659
receiving thread that listens to the

00:26:15,659 --> 00:26:17,549
channel layer and so all it's actually

00:26:17,549 --> 00:26:19,710
doing is listening on both the channel

00:26:19,710 --> 00:26:22,169
layers async thing and on the sockets

00:26:22,169 --> 00:26:24,330
async thing but because we can extract

00:26:24,330 --> 00:26:26,070
it like that we can just say yeah you

00:26:26,070 --> 00:26:27,210
have a KO routine you can do what you

00:26:27,210 --> 00:26:29,610
like as long as you clean up you get a

00:26:29,610 --> 00:26:32,070
lot of freedom and that means we can do

00:26:32,070 --> 00:26:34,799
things like do computations after you've

00:26:34,799 --> 00:26:36,840
sent the response as long as you exit at

00:26:36,840 --> 00:26:38,820
some point and the server's have a

00:26:38,820 --> 00:26:40,830
built-in ten-second timeout after the

00:26:40,830 --> 00:26:42,480
socket closes you can do a lot of

00:26:42,480 --> 00:26:43,080
background

00:26:43,080 --> 00:26:44,399
are seeing or listening on different

00:26:44,399 --> 00:26:46,980
sockets all that kind of stuff but also

00:26:46,980 --> 00:26:49,169
crucially it is still pretty simple and

00:26:49,169 --> 00:26:51,029
it's still an object you pass into your

00:26:51,029 --> 00:26:53,549
server you still have an application you

00:26:53,549 --> 00:26:56,070
pass on the command line to your ASCII

00:26:56,070 --> 00:26:57,749
server and it handles that kind of stuff

00:26:57,749 --> 00:27:00,659
for you and one of the things that we

00:27:00,659 --> 00:27:02,129
wanted to reach here with this was a

00:27:02,129 --> 00:27:05,369
phrase I first heard I Django con EU in

00:27:05,369 --> 00:27:09,119
2009 called Turtles all the way down one

00:27:09,119 --> 00:27:10,799
of the goals with Django we never really

00:27:10,799 --> 00:27:13,230
got to was to have all those layers you

00:27:13,230 --> 00:27:14,399
saw be very similar

00:27:14,399 --> 00:27:17,609
like why is routing and middleware and

00:27:17,609 --> 00:27:20,039
views all different like they all have

00:27:20,039 --> 00:27:21,330
different interfaces you can't write

00:27:21,330 --> 00:27:22,619
them quite the same and there are

00:27:22,619 --> 00:27:25,169
reasons for that in the way WSGI and

00:27:25,169 --> 00:27:28,379
Django is designed there was a push for

00:27:28,379 --> 00:27:30,809
a while to have WSGI middleware and we

00:27:30,809 --> 00:27:32,249
still have this around it exists in

00:27:32,249 --> 00:27:34,590
Python Django is very bad at not using

00:27:34,590 --> 00:27:36,330
it and for a variety of reasons that are

00:27:36,330 --> 00:27:38,759
partially our fault but the idea is I'm

00:27:38,759 --> 00:27:40,379
gonna try and fix that like how can we

00:27:40,379 --> 00:27:42,749
come back to the approach and make it

00:27:42,749 --> 00:27:45,389
all the same again all the way down and

00:27:45,389 --> 00:27:47,039
it's part of making it all async as well

00:27:47,039 --> 00:27:49,320
you know that routing I showed you in

00:27:49,320 --> 00:27:51,299
that layer is just a normal a SGI

00:27:51,299 --> 00:27:54,029
application it's an application that you

00:27:54,029 --> 00:27:56,399
give it a dictionary that says this

00:27:56,399 --> 00:27:57,450
pattern goes to this other application

00:27:57,450 --> 00:28:00,359
and it makes a brand new application the

00:28:00,359 --> 00:28:02,129
middleware is applications to wrap other

00:28:02,129 --> 00:28:05,070
applications the whole point is all the

00:28:05,070 --> 00:28:08,549
stuff in Django channels is generic and

00:28:08,549 --> 00:28:10,440
not particularly tied to Django at all

00:28:10,440 --> 00:28:13,230
and the idea here is to try and free up

00:28:13,230 --> 00:28:15,840
some of that potential for mixing and

00:28:15,840 --> 00:28:17,100
matching Django stuff that we never

00:28:17,100 --> 00:28:20,609
really got to in the existing place but

00:28:20,609 --> 00:28:22,139
then there comes a very interesting

00:28:22,139 --> 00:28:25,679
question I've just stood up here about

00:28:25,679 --> 00:28:27,330
half an hour and told you how I've taken

00:28:27,330 --> 00:28:29,460
Django made a parallel version of it and

00:28:29,460 --> 00:28:32,249
it has different asynchronous things but

00:28:32,249 --> 00:28:34,039
I haven't really touched core Django and

00:28:34,039 --> 00:28:36,210
what does this mean for core Django

00:28:36,210 --> 00:28:37,799
itself like channels is a Django project

00:28:37,799 --> 00:28:40,049
is under the Django organization on

00:28:40,049 --> 00:28:41,879
github but it is still a separate

00:28:41,879 --> 00:28:43,289
project is not part of the core code

00:28:43,289 --> 00:28:45,539
base and it's at this point we have to

00:28:45,539 --> 00:28:48,019
start thinking a bit more in the future

00:28:48,019 --> 00:28:50,730
the real question we have is how much

00:28:50,730 --> 00:28:52,740
can we make a synchronous asynchronous

00:28:52,740 --> 00:28:54,960
code does not come for free for two

00:28:54,960 --> 00:28:55,679
reasons

00:28:55,679 --> 00:28:56,730
first of all it takes

00:28:56,730 --> 00:28:58,679
effort to rewrite code to be

00:28:58,679 --> 00:29:00,870
asynchronous and maintenance is not free

00:29:00,870 --> 00:29:04,200
or cheap I'll pretty much everyone apart

00:29:04,200 --> 00:29:05,940
from a couple of our Django fellows a

00:29:05,940 --> 00:29:07,470
welcome Django works on a volunteer

00:29:07,470 --> 00:29:09,360
basis and our fellows are very busy

00:29:09,360 --> 00:29:11,970
triaging bugs and doing security work we

00:29:11,970 --> 00:29:15,270
do not have a huge amount of people

00:29:15,270 --> 00:29:16,919
power that we can put behind a big

00:29:16,919 --> 00:29:18,090
project to rewrite everything to be

00:29:18,090 --> 00:29:20,580
async one of the big blockers for this

00:29:20,580 --> 00:29:22,440
initially was the idea that if we moved

00:29:22,440 --> 00:29:24,090
it would have to be a breaking change

00:29:24,090 --> 00:29:27,390
well I try to do with channels to is to

00:29:27,390 --> 00:29:29,970
show that we can move things to be async

00:29:29,970 --> 00:29:31,380
and then you keep a synchronous

00:29:31,380 --> 00:29:33,000
interface with us wrapper function to

00:29:33,000 --> 00:29:35,429
saw earlier but there's still a second

00:29:35,429 --> 00:29:37,620
problem which is speed whenever you

00:29:37,620 --> 00:29:39,600
emulate across the layers like that from

00:29:39,600 --> 00:29:41,640
acing to sink or swim to a sink you'll

00:29:41,640 --> 00:29:43,440
be dropping performance if you're

00:29:43,440 --> 00:29:45,210
running your threads Python threads or a

00:29:45,210 --> 00:29:47,160
natural performance hit if you're trying

00:29:47,160 --> 00:29:48,600
to call async code and synchronous code

00:29:48,600 --> 00:29:50,490
having to go up to that main thread and

00:29:50,490 --> 00:29:52,650
back again it's gonna be a performance

00:29:52,650 --> 00:29:54,150
hit before we even consider the fact

00:29:54,150 --> 00:29:55,650
that you're probably gonna keep popping

00:29:55,650 --> 00:29:57,140
in and out of it as you keep doing it

00:29:57,140 --> 00:29:59,309
and so there's a real problem there but

00:29:59,309 --> 00:30:01,410
like looking at Django and like all of

00:30:01,410 --> 00:30:03,919
jangers components and thinking well

00:30:03,919 --> 00:30:05,880
could we make this async

00:30:05,880 --> 00:30:08,010
but would it be much slower like Django

00:30:08,010 --> 00:30:09,900
has had performance problems in the past

00:30:09,900 --> 00:30:11,910
we've tried to speed them up and they

00:30:11,910 --> 00:30:13,559
used to be a graph of Django performance

00:30:13,559 --> 00:30:15,150
released by release that got slower and

00:30:15,150 --> 00:30:17,840
slower that finally managed to fix and

00:30:17,840 --> 00:30:22,350
then the real big question is the Django

00:30:22,350 --> 00:30:26,460
for better or for worse is by complexity

00:30:26,460 --> 00:30:29,130
mostly erm him it's a lot of where our

00:30:29,130 --> 00:30:30,419
complexity is a lot of the maintenance

00:30:30,419 --> 00:30:33,059
goes there and the real question is what

00:30:33,059 --> 00:30:34,020
would that look like

00:30:34,020 --> 00:30:37,940
chango's ORM is very particularly

00:30:37,940 --> 00:30:40,440
opinionated it's designed from a time in

00:30:40,440 --> 00:30:41,970
from a place I really appreciate which

00:30:41,970 --> 00:30:45,390
is like it's not a relational I

00:30:45,390 --> 00:30:47,340
particularly SQL based Roman is much

00:30:47,340 --> 00:30:49,140
more based on object and fetching and

00:30:49,140 --> 00:30:50,790
it's got better over the years and there

00:30:50,790 --> 00:30:52,799
are more relational parts but it's all

00:30:52,799 --> 00:30:55,049
very declarative and quite simplistic in

00:30:55,049 --> 00:30:57,510
in the way you handle it and like how

00:30:57,510 --> 00:31:00,750
could we even do that same stuff in an

00:31:00,750 --> 00:31:03,390
async term could we even do that for

00:31:03,390 --> 00:31:04,950
example one of the big problems I've run

00:31:04,950 --> 00:31:08,010
into with Python 3 async is that even if

00:31:08,010 --> 00:31:10,600
you're in an async context in a code

00:31:10,600 --> 00:31:12,940
attribute access is still synchronous

00:31:12,940 --> 00:31:15,010
there's no asynchronous actuate access

00:31:15,010 --> 00:31:17,560
and so if you override things like

00:31:17,560 --> 00:31:19,900
properties or accessors and/or get

00:31:19,900 --> 00:31:22,840
methods you can't have async versions of

00:31:22,840 --> 00:31:25,150
those a lot of what Jango does relies on

00:31:25,150 --> 00:31:28,420
overriding like operators or actually

00:31:28,420 --> 00:31:30,550
access and you just can't have those

00:31:30,550 --> 00:31:32,950
transparently be asynchronous one of the

00:31:32,950 --> 00:31:34,720
big problems we had of channels was that

00:31:34,720 --> 00:31:37,750
I made a middleware which put users onto

00:31:37,750 --> 00:31:39,580
the scope to stand at Wharf middleware

00:31:39,580 --> 00:31:43,000
it's great the problem is that when you

00:31:43,000 --> 00:31:45,340
are trying to make that take a take a

00:31:45,340 --> 00:31:47,080
cookie from the scope and turn it into a

00:31:47,080 --> 00:31:49,090
user object that involves accessing the

00:31:49,090 --> 00:31:51,460
ORM and this means you have to do it in

00:31:51,460 --> 00:31:53,110
a synchronous context because it's

00:31:53,110 --> 00:31:55,750
Django and it's a synchronous RM but the

00:31:55,750 --> 00:31:57,580
problem is that on the request object

00:31:57,580 --> 00:32:00,820
user is lazy until you look at user the

00:32:00,820 --> 00:32:02,620
first time there's nothing there it's

00:32:02,620 --> 00:32:05,620
sort of a basically a promise as soon as

00:32:05,620 --> 00:32:08,200
you look at it the descriptor triggers

00:32:08,200 --> 00:32:10,600
fires the ORM query comes back and then

00:32:10,600 --> 00:32:12,670
gives you the object the problem we were

00:32:12,670 --> 00:32:14,110
having was that this is happening in the

00:32:14,110 --> 00:32:16,840
middle of an asynchronous piece of code

00:32:16,840 --> 00:32:19,330
like well put in an async function we

00:32:19,330 --> 00:32:21,910
try and get this thing got user it goes

00:32:21,910 --> 00:32:23,110
away it starts running in database

00:32:23,110 --> 00:32:24,610
queries and that's gonna make you a

00:32:24,610 --> 00:32:28,270
resolute block there was protection what

00:32:28,270 --> 00:32:30,400
happened in fact was that channels

00:32:30,400 --> 00:32:31,930
worked out what was happening I said no

00:32:31,930 --> 00:32:35,020
you can't run synchronous code and async

00:32:35,020 --> 00:32:38,080
lupine and quit out bit cause the bug

00:32:38,080 --> 00:32:39,880
had to fix it in a nasty way and it

00:32:39,880 --> 00:32:42,430
still remains and like that becomes much

00:32:42,430 --> 00:32:43,840
more magnified when you think about it

00:32:43,840 --> 00:32:45,520
on the grander scale of like could we

00:32:45,520 --> 00:32:47,590
even partially rewrite this stuff like

00:32:47,590 --> 00:32:50,800
how would that work is there an

00:32:50,800 --> 00:32:51,970
alternate way of doing this can we make

00:32:51,970 --> 00:32:53,920
jung-in more pluggable I said earlier

00:32:53,920 --> 00:32:55,810
like you know shareable middleware and

00:32:55,810 --> 00:32:58,060
whiskey middleware is this goal Jango

00:32:58,060 --> 00:33:00,070
never quite got to could we get back

00:33:00,070 --> 00:33:03,190
there is one of these routes to it based

00:33:03,190 --> 00:33:05,620
around that kind of stuff I would really

00:33:05,620 --> 00:33:08,340
love to see jagger be more pluggable I

00:33:08,340 --> 00:33:11,380
nearly always every year here requests

00:33:11,380 --> 00:33:14,680
for well I'd love to use Django part X

00:33:14,680 --> 00:33:16,480
outside of Django but of course the

00:33:16,480 --> 00:33:18,340
Settings often is the problem pops up

00:33:18,340 --> 00:33:20,680
and comes in there so like part of this

00:33:20,680 --> 00:33:22,960
is if we are rethinking Django at all

00:33:22,960 --> 00:33:26,200
is there a way around that part of it do

00:33:26,200 --> 00:33:28,360
we finally like start separating out the

00:33:28,360 --> 00:33:31,809
RM from the templates from the views

00:33:31,809 --> 00:33:34,029
from the caching from the URL routing

00:33:34,029 --> 00:33:37,390
for example and all these are pretty

00:33:37,390 --> 00:33:38,610
difficult questions

00:33:38,610 --> 00:33:40,600
and then there's an even bigger question

00:33:40,600 --> 00:33:44,289
that's beyond Django itself I have just

00:33:44,289 --> 00:33:46,510
stood up here and showed you what I call

00:33:46,510 --> 00:33:49,659
a replacement for WSGI that is a bold

00:33:49,659 --> 00:33:51,760
claim to make it is not an easy thing to

00:33:51,760 --> 00:33:55,630
replace and it is arguably something

00:33:55,630 --> 00:33:57,880
does not need to be replaced it works

00:33:57,880 --> 00:33:58,899
very well

00:33:58,899 --> 00:34:02,440
some Unicode problems aside form the

00:34:02,440 --> 00:34:05,590
majority of Python web handling and in

00:34:05,590 --> 00:34:07,240
particular WebSockets are not a big

00:34:07,240 --> 00:34:09,190
demand thing one of the differences

00:34:09,190 --> 00:34:11,220
between migrations and channels

00:34:11,220 --> 00:34:14,050
everyone needs migrations but doesn't

00:34:14,050 --> 00:34:16,690
know they need it yet most people don't

00:34:16,690 --> 00:34:17,859
need WebSockets they think they do need

00:34:17,859 --> 00:34:19,179
them they're shiny they're new they're

00:34:19,179 --> 00:34:21,339
exciting the problem is socket

00:34:21,339 --> 00:34:23,950
programming is really hard if you're a

00:34:23,950 --> 00:34:25,540
web developer you are spoiled because

00:34:25,540 --> 00:34:26,740
you had this wonderful stateless

00:34:26,740 --> 00:34:28,899
protocol where like everything is reset

00:34:28,899 --> 00:34:29,679
every request

00:34:29,679 --> 00:34:31,149
there's no persisting state and popping

00:34:31,149 --> 00:34:32,619
cookies it's actually really well

00:34:32,619 --> 00:34:34,570
designed as a protocol to write against

00:34:34,570 --> 00:34:36,879
if you try and go from that world on

00:34:36,879 --> 00:34:39,159
both the front end and the back end side

00:34:39,159 --> 00:34:42,220
into the web world of WebSockets it

00:34:42,220 --> 00:34:43,750
takes a lot of extra effort there's new

00:34:43,750 --> 00:34:45,669
skills to learn this new debugging

00:34:45,669 --> 00:34:48,159
problems learn load testing is even

00:34:48,159 --> 00:34:52,030
worse like the numb load testing

00:34:52,030 --> 00:34:53,080
WebSockets is a thing that's not even a

00:34:53,080 --> 00:34:55,000
good tool for you there's some tools

00:34:55,000 --> 00:34:56,500
there half written but it's not a thing

00:34:56,500 --> 00:34:58,560
we have a good lot of good practice at

00:34:58,560 --> 00:35:01,660
even finding load balancers that

00:35:01,660 --> 00:35:03,490
understand had a load balance long Oh

00:35:03,490 --> 00:35:05,920
like long-standing connections properly

00:35:05,920 --> 00:35:08,230
is difficult too and so the real

00:35:08,230 --> 00:35:12,900
question here is is that demand for

00:35:12,900 --> 00:35:16,540
asynchronous long live protocols

00:35:16,540 --> 00:35:18,070
sufficient to think about replacement

00:35:18,070 --> 00:35:20,800
wci let me replace I mean sit alongside

00:35:20,800 --> 00:35:23,740
as an alternative of course but like do

00:35:23,740 --> 00:35:26,710
we even need that stuff and I've been

00:35:26,710 --> 00:35:29,080
pondering us for a while WSGI is a

00:35:29,080 --> 00:35:32,020
stable state it is written in a pet like

00:35:32,020 --> 00:35:34,119
fashion but is it not a pet at least not

00:35:34,119 --> 00:35:35,140
yet

00:35:35,140 --> 00:35:36,950
one of the things I personally think

00:35:36,950 --> 00:35:39,800
important for any kind of shall we say

00:35:39,800 --> 00:35:42,260
wanting to be specification is to have

00:35:42,260 --> 00:35:45,619
multiple implementations thanks to the

00:35:45,619 --> 00:35:47,359
work of the team over at Django rest

00:35:47,359 --> 00:35:49,430
framework Django rest framework among

00:35:49,430 --> 00:35:51,950
others there are now multiple a SGI

00:35:51,950 --> 00:35:55,040
servers Oh Daphne and Yuva corn both

00:35:55,040 --> 00:35:58,280
just plug in and run stuff um the thing

00:35:58,280 --> 00:35:59,540
I'm really missing here is multiple

00:35:59,540 --> 00:36:02,030
frame looks like what I've written works

00:36:02,030 --> 00:36:05,060
well for Django I am not gonna be happy

00:36:05,060 --> 00:36:06,829
until I know it would fit well into

00:36:06,829 --> 00:36:09,320
other frameworks as well and for this

00:36:09,320 --> 00:36:12,500
reason like my reticence in many ways is

00:36:12,500 --> 00:36:13,820
like I want to sit down but maybe flask

00:36:13,820 --> 00:36:15,710
or pyramid or something one of the other

00:36:15,710 --> 00:36:17,180
big Python web frameworks are like hey

00:36:17,180 --> 00:36:19,520
cam would this fit into their paradigm

00:36:19,520 --> 00:36:21,440
as well could we do similar things with

00:36:21,440 --> 00:36:24,320
this kind of stuff there is a whiskey

00:36:24,320 --> 00:36:26,270
adapter inside a SGI you can run a

00:36:26,270 --> 00:36:28,190
whiskey app inside it's a superset

00:36:28,190 --> 00:36:30,079
that's not really giving many benefits

00:36:30,079 --> 00:36:32,750
why would you do that there's an issue

00:36:32,750 --> 00:36:36,079
open I think it was on the AI Oh HTTP

00:36:36,079 --> 00:36:37,940
track of like oh we should add support

00:36:37,940 --> 00:36:39,609
for this thing and reinvention and like

00:36:39,609 --> 00:36:42,680
some wonderful person who is very very

00:36:42,680 --> 00:36:44,060
enthusiastic opened it and I had a

00:36:44,060 --> 00:36:46,609
search ones they're like you can't just

00:36:46,609 --> 00:36:48,560
go and ask maintainer x' for things that

00:36:48,560 --> 00:36:50,300
give them no benefit right like if we're

00:36:50,300 --> 00:36:51,829
gonna do this happy everyone has to

00:36:51,829 --> 00:36:54,260
benefit we have to agree that having

00:36:54,260 --> 00:36:55,730
that standard having that's probably

00:36:55,730 --> 00:36:57,560
that ability that whiskey gave us is

00:36:57,560 --> 00:37:01,190
important that's really the the crux of

00:37:01,190 --> 00:37:02,510
the problem I ended up having here and

00:37:02,510 --> 00:37:04,220
so my goal is to probably try and bring

00:37:04,220 --> 00:37:06,680
it to some kind of pep form soon and

00:37:06,680 --> 00:37:08,240
work with other frameworks and other

00:37:08,240 --> 00:37:09,740
servers to try and add support for it

00:37:09,740 --> 00:37:12,170
but that is not the direct goal the

00:37:12,170 --> 00:37:13,880
direct girls that get Django working

00:37:13,880 --> 00:37:15,680
first and have that stuff proven and in

00:37:15,680 --> 00:37:17,960
production and on systems and make sure

00:37:17,960 --> 00:37:20,720
this time the design decisions that

00:37:20,720 --> 00:37:22,040
we've made and they've proven through

00:37:22,040 --> 00:37:24,380
actually do work at large scale that are

00:37:24,380 --> 00:37:25,940
things we want to support into the

00:37:25,940 --> 00:37:30,619
future and then of course I set the

00:37:30,619 --> 00:37:32,329
beginning and we want everyone writing

00:37:32,329 --> 00:37:34,970
async async is lovely it opens a lot of

00:37:34,970 --> 00:37:36,890
wonderful new avenues for us to do

00:37:36,890 --> 00:37:38,930
things in parallel it's also very

00:37:38,930 --> 00:37:41,750
difficult and channels very much has

00:37:41,750 --> 00:37:43,849
this philosophy of you can write sync

00:37:43,849 --> 00:37:46,760
you can write async they can coexist but

00:37:46,760 --> 00:37:48,290
as you move more down the async path

00:37:48,290 --> 00:37:49,790
it's easy to forget about synchronous

00:37:49,790 --> 00:37:50,000
code

00:37:50,000 --> 00:37:52,280
as well and one of the things Charles

00:37:52,280 --> 00:37:55,100
does do is like writing synchronous cows

00:37:55,100 --> 00:37:56,810
getting harder and harder because a lot

00:37:56,810 --> 00:37:58,880
of the api's are synchronous what a sync

00:37:58,880 --> 00:38:01,600
one here to wrap them a little bit and I

00:38:01,600 --> 00:38:04,010
am honestly not sure if I want to say

00:38:04,010 --> 00:38:06,770
that Python web should all be async I'm

00:38:06,770 --> 00:38:08,270
not sure that's going to be a safe thing

00:38:08,270 --> 00:38:09,860
to do with the current ways and kayo

00:38:09,860 --> 00:38:12,430
works maybe there's there probably is

00:38:12,430 --> 00:38:14,540
improvements in language improves in

00:38:14,540 --> 00:38:16,190
Mexico itself improvements in the

00:38:16,190 --> 00:38:17,990
frameworks and the way we make things

00:38:17,990 --> 00:38:20,450
safer like HTTP is not safe

00:38:20,450 --> 00:38:22,370
Jango and flask and everyone has work to

00:38:22,370 --> 00:38:24,890
make it safe I think that same kind of

00:38:24,890 --> 00:38:27,230
learning and thinking a process has to

00:38:27,230 --> 00:38:29,960
be done to async stuff as well and

00:38:29,960 --> 00:38:30,980
especially WebSockets cause that

00:38:30,980 --> 00:38:33,200
particularly nasty to try and make these

00:38:33,200 --> 00:38:35,990
things happen correctly and then this

00:38:35,990 --> 00:38:38,570
ultimate becomes very existential right

00:38:38,570 --> 00:38:42,230
like what is Jango I've given this whole

00:38:42,230 --> 00:38:44,300
talk up here I am but one member of the

00:38:44,300 --> 00:38:46,520
Jango team I have a particularly far

00:38:46,520 --> 00:38:48,740
ranging vision for Jango that I know

00:38:48,740 --> 00:38:51,140
some of my colleagues don't share and

00:38:51,140 --> 00:38:53,240
ultimately like you know Jango at the

00:38:53,240 --> 00:38:55,400
moment is defined by by what it where it

00:38:55,400 --> 00:38:56,870
came from it is this amazing MOU

00:38:56,870 --> 00:38:59,510
framework that came from a place of you

00:38:59,510 --> 00:39:00,860
know perfectionist with deadlines with

00:39:00,860 --> 00:39:03,890
this need from it from time when the

00:39:03,890 --> 00:39:05,420
backend where was very much the only

00:39:05,420 --> 00:39:07,790
place these days we live in the world of

00:39:07,790 --> 00:39:10,700
the real-time web with rich JavaScript

00:39:10,700 --> 00:39:12,500
front ends and native apps all this kind

00:39:12,500 --> 00:39:15,740
of stuff Django and Python general was

00:39:15,740 --> 00:39:17,630
still very very relevant but much more

00:39:17,630 --> 00:39:19,820
as a back-end system you know like the

00:39:19,820 --> 00:39:21,170
number of companies who use Django a

00:39:21,170 --> 00:39:23,360
templating is reduced but the number of

00:39:23,360 --> 00:39:25,340
people who huge anger for like business

00:39:25,340 --> 00:39:27,980
logic and models is still there it's the

00:39:27,980 --> 00:39:30,530
real question is at some point we should

00:39:30,530 --> 00:39:32,420
work out where what is our place in this

00:39:32,420 --> 00:39:34,610
future like before we start making

00:39:34,610 --> 00:39:35,750
decisions before we start going awry

00:39:35,750 --> 00:39:38,210
let's rewrite everything to be async is

00:39:38,210 --> 00:39:39,710
that what we need is that what people

00:39:39,710 --> 00:39:42,470
want and one of these things the best

00:39:42,470 --> 00:39:44,900
way I found doing this is to just give

00:39:44,900 --> 00:39:46,370
people options and work out what comes

00:39:46,370 --> 00:39:47,900
more popular and that's kind of one of

00:39:47,900 --> 00:39:49,790
reasons channels exists it's like here

00:39:49,790 --> 00:39:52,490
is this thing it is a moderately

00:39:52,490 --> 00:39:55,430
competent righted rewrite of Django to

00:39:55,430 --> 00:39:56,840
be async it has a lot of the same

00:39:56,840 --> 00:39:58,880
support and then let's see what develops

00:39:58,880 --> 00:40:01,820
what comes out of it and how we can use

00:40:01,820 --> 00:40:03,260
that stuff to improve both

00:40:03,260 --> 00:40:06,230
Django and Python in the future that

00:40:06,230 --> 00:40:08,200
thank you very much

00:40:08,200 --> 00:40:18,350
[Applause]


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
