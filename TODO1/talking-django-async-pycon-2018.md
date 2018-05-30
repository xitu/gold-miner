> * 原视频地址：[Andrew Godwin - Taking Django Async - PyCon 2018](https://www.youtube.com/watch?v=-7taKQnndfo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/talking-django-async-pycon-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/talking-django-async-pycon-2018.md)
> * 译者：
> * 校对者：

# Andrew Godwin - Taking Django Async - PyCon 2018

> 本文为 PyCon 2018 视频之 Andrew Godwin - Taking Django Async 的中文字幕，您可以搭配原视频食用。

0:00	 	hello let's give a warm

0:15  good afternoon everyone I am here to

0:22  okay I think there we go

0:28  don't know me I am a person whose

0:33  fun isn't it I am Andrew Godwin I am a

0:47  probably known these days my work on

0:53  days working on channels which is what

0:57  work as a senior software engineer at

1:01  a ticketing company to get events and

1:05  and I have a fun side project of doing

1:11  see here no sane person would probably

1:18  bit of history 2015 is when I first

1:24  was sort of nascent project of like

1:29  merged into Chango some of my fellow

1:32  of the maintenance thanks Marcos and so

1:37  that new problem in my mind was

1:42  of protocols on the web in particular

1:49  sort of some basic headline goals the

1:53  support to Django that is for protocols

1:57  like like HTTP but have an ongoing

2:02  some stuff down you send some stuff back

2:06  sort of have much more of a conversation

2:10  get over HTTP obviously

2:15  WebSockets it has a lot of support at

2:20  popular and being used for love

2:24  time things and games stuff like that

2:28  just WebSockets I went to background

2:31  as well and all this resulted in around

2:36  channels 1.0 it was a good two years of

2:43  stable it was being used in production

2:46  achieved a lot of those top goals I just

2:50  I had made some choices in the design of

2:56  now three years ago the thing I thought

3:01  compatible Django still was the Django

3:06  compatible and so I picked Python 2.7 as

3:12  throughout any idea of async IO support

3:17  because twisted is very reliable has a

3:20  Autobahn as well WebSockets and I stuck

3:27  that familiarity

3:31  the process and so you ended up with a

3:36  looked you had this idea of like well

3:41  capable of being highly concurrent it

3:44  easily and you have a synchronous Django

3:49  big for loop and has one thing at a time

3:54  Python 2 you can't do that and so I also

3:59  that allowed you to take the async

4:04  sort of as a separate piece of code in

4:09  the async part of that kind of stuff

4:14  complicated it gets a bit more so but

4:19  more than one server and more than one

4:23  just one box and so what you would do is

4:26  twisted servers in a sort of array that

4:30  bounced across and they'd all go through

4:34  big pool of worker servers and whenever

4:39  into the thing through the network find

4:43  synchronously finish and then come back

4:49  this was back all you could do I was

4:54  as you can imagine it has too many

4:58  generally have big Network layers in the

5:02  need them eventually one of the things

5:05  like designing a service-oriented

5:09  those problems but most people don't

5:13  does not need to help you do that stuff

5:18  IO support these days Python 3 is very

5:24  3 we're now at the amazing point where

5:29  Welcome 3 and don't work on 2 which is

5:33  like it's about an artifact of the past

5:37  hurrah of 2.7 and finally the design

5:43  the foot because it was full of these

5:47  work to key well and a lot of the

5:51  was a little bit too easy to like not

5:55  process or leave something running too

5:59  as much you could do with full icing

6:04  me a while to do this and I had to sort

6:08  to admit I was wrong and I think very

6:11  big projects to take a big turn like I

6:17  analysis of the problem entirely but at

6:21  nice research project it achieved the

6:25  long-term solution and so what does a

6:32  Python look like well that's kind of all

6:36  channels 2.0 was released earlier this

6:40  it is a pretty significant change from

6:45  series and I'm going to go through in

6:49  those changes and how taking up a sink

6:55  rethought how I think of Django and web

7:00  channels to our first and foremost is a

7:05  of the rewrite of course doing this

7:09  where async EO comes into the standard

7:13  use the async DEF keyword which is what

7:19  have support for async code but also for

7:24  later but it's in my opinion very

7:28  both of those different things and so

7:33  the history of Python web programming

7:38  to runs like this it runs like normal

7:43  server and inside that web server you

7:47  run Django it's simplistic there's one

7:53  hidden in there mysteriously causing

7:58  process communication one of the

8:03  in particular is the applications you

8:07  and crosstalk between services and so

8:10  still is that crosstalk layer the

8:14  now an optional component and most of

8:18  only for broadcast and process to

8:23  chat application it's there for you you

8:28  other people listening on these sockets

8:32  lot more simplistic aid he'd be easier

8:37  have to fulfill that middle role it did

8:41  the end result this is not a complete

8:46  rewrite obviously all the code that used

8:51  rewritten

8:55  very good async support these days and

8:59  and change a few things and that kept

9:03  to change especially in the Jango layer

9:08  get when you get to this point is about

9:13  and the way we do asynchronous code in

9:18  synchronous function a very distinct you

9:22  both interfaces what this means is it's

9:28  provides both synchronous and

9:32  there and writing everything twice this

9:35  libraries for like talking to various

9:39  synchronously they're just different

9:44  the same place and so I really had to

9:49  this problem I don't want to rewrite all

9:54  love to but I am but one man and I only

9:58  this in and then we have got until like

10:03  kind of the biggest problem I faced

10:07  about this topic at all I have a blog

10:11  background of how asynchronous and

10:16  Python it has a good coverage of like

10:19  implication behind its it's not going to

10:23  reading it's quite a nice high-level

10:28  key thing is and assumption in this talk

10:32  same way and this meant that I had to

10:37  you're gonna handle WebSockets in

10:41  certain point like the thing that

10:44  handles the basic business logic has to

10:49  for a long time in parallel with other

10:54  structured Jango is sort of a sort of

11:01  version but one of my favorite ways

11:05  layers stacked on top

11:08  have a WSGI handler that takes your

11:14  turns into a Django request object above

11:19  the request object finds of you and then

11:25  middleware so before you get to review

11:28  things like authentication and sessions

11:31  then you come to a view that's business

11:35  from a view you're usually talking to

11:40  the RM as well but this is a simplistic

11:44  synchronous stuff but we need to think

11:51  instead we do this we had entered a

11:57  asynchronous capable inside Django and

12:00  up through the stack so in particular

12:06  have to have a different kind of routing

12:10  like you can be the other stuff we have

12:15  asynchronous views which we call

12:19  mirror their components in the

12:23  couldn't tackle easily is the RM and so

12:28  highlighted in this blue square on the

12:33  synchronous Chango not only for the RM

12:40  also if you are trying to call a normal

12:44  mixed between WebSockets and normal

12:48  you have to drop down as normal django

12:54  handler with an asynchronous version

12:57  point you have to drop down into

13:02  you can see there like I've made Django

13:08  parallel fashion but I had to bridge

13:14  comes down to a a lot of frustration and

13:20  and be to functions that were the result

13:25  called sink to a sink my voice is going

13:32  sink to sink the idea is these two

13:37  to a sink can take asynchronous Python

13:41  runs it in a background thread a sink to

13:46  co-routine in - that's asynchronous and

13:50  function that pauses the thread you call

13:56  main thread with the event loop runs it

13:59  these are the key components of how we

14:06  those two worlds into Jango itself so

14:12  detail about those particular things

14:16  many ways the easier of the two it's not

14:23  you need for this are provided by the

14:27  obvious thing not obvious the first

14:31  run in threads so we are going to run

14:34  can't just block the entire main thread

14:38  running and so we have to have these

14:43  are not great the context switching is a

14:47  talks have previously said but they are

14:51  want to get down briefly run a function

14:55  library has a thing called the thread

14:59  say hey I have a task you can make a

15:04  task run this task in that pool and give

15:09  looks a bit like this there's a few more

15:13  the code we have in channels but the

15:18  event loop you make a future that

15:22  pool and then use a weight on the future

15:27  scenes the thread pool spins up and runs

15:32  you're writing this in will just

15:35  that's read is complete now this is

15:44  ORM rendering templates other parts of

15:48  boundary just now we're like okay I need

15:52  before that is synchronous and that has

15:57  particularly tricky Django has

16:02  connections and threads and make sure

16:05  that relies heavily on a request

16:10  things we had to do was when you call

16:14  finishes sit there and clean up

16:17  to like close connections to like that

16:22  of the unfortunate side effects is you

16:25  connections the thread pool defaults to

16:30  in your machine so you have a 16 core

16:34  threads all trying to connect at once to

16:39  but you can tweak that stuff but in

16:43  really well the more difficult problem

16:48  synched a sink is pretty built into the

16:54  seven has even better support for that

16:58  common and this is because async code

17:06  have the thing that provides it a waiter

17:09  interrupts and if you're running in a

17:14  already an event loop in the main thread

17:18  your nesting these two things so say

17:23  asynchronous function from my a

17:27  a sub thread the synchronous I then want

17:31  channels from that sub thread so we've

17:36  main thread find the event loop then

17:41  thank you very much and so it's a little

17:46  readable on the screen it's deliberate

17:50  the basic flow of it is that it tries to

17:54  instead try and open a new event loop in

17:59  Python lets you do you can run as many

18:02  gonna be less efficient because you are

18:05  more sockets and so one of the things

18:09  for an async function it's going to pop

18:12  loop and why do we need this

18:20  only write things once in particular I

18:26  channels and if you want to have a North

18:31  once and then have a compatibility layer

18:36  from the other side and so rather than

18:40  call them threads

18:43  which is running asynchronously and if

18:47  code by using the async to sync function

18:55  maintenance workload and stuff like this

18:59  async api's and then just say everywhere

19:03  call this from a synchronous place just

19:07  helps just have like one or system one

19:11  channels provides obviously those things

19:15  other things too like the channel layers

19:19  Redis to another to a broadcast set of

19:24  a i/o Redis underneath it uses a weight

19:28  in synchronous code before you just

19:32  written synchronously but now we can

19:37  then run it wherever you like you can

19:41  you're just in a normal synchronous

19:44  will then make its own event loop and

19:50  really is usable and flexible through

19:54  and run asynchronous code from a

19:59  here is that like I don't think

20:03  one kind of code at least as it

20:06  pythons async report is not perfect and

20:13  synchronous support it is much harder to

20:18  certain ways for example if you're not

20:23  function that blocks the entire event

20:27  the nice debug mode of the event loop

20:31  hang for a bit while the function blocks

20:36  don't trust myself to write good

20:40  the general developer population to

20:45  think they should I think the case here

20:50  long-lived support then you can go async

20:56  you can go sync and that's really one of

20:59  both and that's why I try to keep both

21:04  synchronous Django code and keep things

21:07  you can also go into the brand-new shiny

21:13  can even have a version of consumers

21:17  consumer layer before but before the ORM

21:20  that way too but there is one part of

21:25  and that's this section here there is a

21:31  into my chart now in the first chart

21:38  we all know and love Everest GI it's

21:41  it is a incredibly successful interface

21:49  servers freely it so that let a lot of

21:53  world like when I started doing Python

21:57  certain frameworks like you couldn't use

22:00  seeing this come through and really

22:04  swap between different things

22:10  much synchronous and it's very much

22:14  HTTP

22:20  function you call the function with the

22:23  there is no real affordance there where

22:29  long time it's not an asynchronous

22:32  days and so you have to really think

22:37  work for async my first attempt as you

22:42  networking layers but the version that

22:48  think it is a good replacement for that

22:54  because it's like whiskey with an A in

22:56  it's very inventive naming I'm on my

23:01  version of whiskey I'll give you a brief

23:07  application of like this you have an

23:12  Enver on the Enver on is the dictionary

23:16  things like here are the headers here's

23:20  that stuff's in there and start

23:24  headers back so you get your Enron you

23:29  basically read the Enver on break the

23:32  object for you and do path analysis and

23:36  business logic you call start response

23:40  and then you just basically yield or

23:46  can see here how it's not quite capable

23:50  long live connections but it could be

23:55  looks like this the first big difference

24:00:00  interface is is it's a callable it

24:04:00  the class has a core method but this is

24:08:00  time you call it you give it your scope

24:13:00  place where all the data about the

24:18:00  connection happens comes to you so for

24:22:00  the method and the headers web

24:26:00  here is the WebSocket path here is the

24:29:00  here's the sub protocol they asked for

24:33:00  so for example if you are a chat bot

24:37:00  chat bot is in for example or TCP

24:42:00  get this information and then the second

24:48:00  given two things receive an assent

24:54:00  when the connection opens from the

24:58:00  you can open it then send things all the

25:03:00  of request from the scope yet we do much

25:08:00  method and so what happens is you cut

25:13:00  given these two away tables and it's

25:18:00  events from the outside world and

25:22:00  got you've got a WebSocket frame you've

25:26:00  when you get one to send stuff back the

25:32:00  like WSGI there is a specification for

25:36:00  WSGI on purpose but things like HTTP

25:41:00  properly things are split out for

25:45:00  like oh here's the text ID from the

25:48:00  from the frame the decoding is done for

25:53:00  high level like WSGI is in that respect

25:58:00  what you like because this is just a KO

26:02:00  and send you can launch your own

26:06:00  channels we have a base class of these

26:12:00  starts receiving launches a second

26:15:00  channel layer and so all it's actually

26:19:00  layers async thing and on the sockets

26:24:00  it like that we can just say yeah you

26:27:00  like as long as you clean up you get a

26:32:00  things like do computations after you've

26:36:00  some point and the server's have a

26:40:00  socket closes you can do a lot of

26:43:00  are seeing or listening on different

26:46:00  crucially it is still pretty simple and

26:51:00  server you still have an application you

26:56:00  server and it handles that kind of stuff

27:00:00  wanted to reach here with this was a

27:05:00  2009 called Turtles all the way down one

27:10:00  got to was to have all those layers you

27:14:00  like why is routing and middleware and

27:20:00  different interfaces you can't write

27:22:00  reasons for that in the way WSGI and

27:28:00  a while to have WSGI middleware and we

27:32:00  Python Django is very bad at not using

27:36:00  partially our fault but the idea is I'm

27:40:00  come back to the approach and make it

27:45:00  it's part of making it all async as well

27:49:00  that layer is just a normal a SGI

27:54:00  give it a dictionary that says this

27:57:00  and it makes a brand new application the

28:02:00  applications the whole point is all the

28:08:00  not particularly tied to Django at all

28:13:00  some of that potential for mixing and

28:17:00  really got to in the existing place but

28:22:00  question I've just stood up here about

28:27:00  Django made a parallel version of it and

28:32:00  I haven't really touched core Django and

28:36:00  itself like channels is a Django project

28:40:00  github but it is still a separate

28:43:00  base and it's at this point we have to

28:48:00  the real question we have is how much

28:52:00  code does not come for free for two

28:55:00  first of all it takes

28:58:00  asynchronous and maintenance is not free

29:04:00  from a couple of our Django fellows a

29:07:00  basis and our fellows are very busy

29:11:00  do not have a huge amount of people

29:16:00  project to rewrite everything to be

29:20:00  initially was the idea that if we moved

29:24:00  well I try to do with channels to is to

29:29:00  and then you keep a synchronous

29:33:00  saw earlier but there's still a second

29:37:00  emulate across the layers like that from

29:41:00  be dropping performance if you're

29:45:00  natural performance hit if you're trying

29:48:00  having to go up to that main thread and

29:52:00  hit before we even consider the fact

29:55:00  in and out of it as you keep doing it

29:59:00  like looking at Django and like all of

30:03:00  could we make this async

30:08:00  has had performance problems in the past

30:11:00  used to be a graph of Django performance

30:15:00  slower that finally managed to fix and

30:22:00  for better or for worse is by complexity

30:29:00  complexity is a lot of the maintenance

30:33:00  would that look like

30:37:00  opinionated it's designed from a time in

30:41:00  is like it's not a relational I

30:47:00  more based on object and fetching and

30:50:00  are more relational parts but it's all

30:55:00  in the way you handle it and like how

31:00:00  async term could we even do that for

31:04:00  into with Python 3 async is that even if

31:10:00  attribute access is still synchronous

31:15:00  and so if you override things like

31:19:00  methods you can't have async versions of

31:25:00  overriding like operators or actually

31:30:00  transparently be asynchronous one of the

31:34:00  I made a middleware which put users onto

31:39:00  it's great the problem is that when you

31:45:00  cookie from the scope and turn it into a

31:49:00  ORM and this means you have to do it in

31:53:00  Django and it's a synchronous RM but the

31:57:00  user is lazy until you look at user the

32:02:00  sort of a basically a promise as soon as

32:08:00  fires the ORM query comes back and then

32:12:00  having was that this is happening in the

32:16:00  like well put in an async function we

32:21:00  away it starts running in database

32:24:00  resolute block there was protection what

32:30:00  worked out what was happening I said no

32:35:00  lupine and quit out bit cause the bug

32:39:00  still remains and like that becomes much

32:43:00  on the grander scale of like could we

32:47:00  how would that work is there an

32:51:00  jung-in more pluggable I said earlier

32:55:00  whiskey middleware is this goal Jango

33:00:00  there is one of these routes to it based

33:05:00  love to see jagger be more pluggable I

33:11:00  for well I'd love to use Django part X

33:16:00  Settings often is the problem pops up

33:20:00  is if we are rethinking Django at all

33:26:00  we finally like start separating out the

33:31:00  from the caching from the URL routing

33:37:00  difficult questions

33:40:00  that's beyond Django itself I have just

33:46:00  a replacement for WSGI that is a bold

33:51:00  replace and it is arguably something

33:57:00  very well

34:02:00  majority of Python web handling and in

34:07:00  demand thing one of the differences

34:11:00  everyone needs migrations but doesn't

34:16:00  need WebSockets they think they do need

34:19:00  exciting the problem is socket

34:23:00  web developer you are spoiled because

34:26:00  protocol where like everything is reset

34:29:00  there's no persisting state and popping

34:32:00  designed as a protocol to write against

34:36:00  both the front end and the back end side

34:42:00  takes a lot of extra effort there's new

34:45:00  problems learn load testing is even

34:52:00  WebSockets is a thing that's not even a

34:55:00  there half written but it's not a thing

34:58:00  even finding load balancers that

35:03:00  like long-standing connections properly

35:08:00  question here is is that demand for

35:16:00  sufficient to think about replacement

35:20:00  as an alternative of course but like do

35:26:00  pondering us for a while WSGI is a

35:32:00  fashion but is it not a pet at least not

35:35:00  one of the things I personally think

35:39:00  wanting to be specification is to have

35:45:00  work of the team over at Django rest

35:49:00  others there are now multiple a SGI

35:55:00  just plug in and run stuff um the thing

35:59:00  frame looks like what I've written works

36:05:00  until I know it would fit well into

36:09:00  reason like my reticence in many ways is

36:13:00  or pyramid or something one of the other

36:17:00  cam would this fit into their paradigm

36:21:00  this kind of stuff there is a whiskey

36:26:00  whiskey app inside it's a superset

36:30:00  why would you do that there's an issue

36:36:00  track of like oh we should add support

36:39:00  some wonderful person who is very very

36:44:00  search ones they're like you can't just

36:48:00  give them no benefit right like if we're

36:51:00  benefit we have to agree that having

36:55:00  that ability that whiskey gave us is

37:01:00  the problem I ended up having here and

37:04:00  it to some kind of pep form soon and

37:08:00  servers to try and add support for it

37:12:00  direct girls that get Django working

37:15:00  production and on systems and make sure

37:20:00  we've made and they've proven through

37:24:00  things we want to support into the

37:30:00  beginning and we want everyone writing

37:34:00  wonderful new avenues for us to do

37:38:00  difficult and channels very much has

37:43:00  you can write async they can coexist but

37:48:00  it's easy to forget about synchronous

37:50:00  as well and one of the things Charles

37:55:00  getting harder and harder because a lot

37:58:00  one here to wrap them a little bit and I

38:04:00  that Python web should all be async I'm

38:08:00  to do with the current ways and kayo

38:12:00  improvements in language improves in

38:16:00  frameworks and the way we make things

38:20:00  Jango and flask and everyone has work to

38:24:00  learning and thinking a process has to

38:29:00  especially WebSockets cause that

38:33:00  things happen correctly and then this

38:38:00  like what is Jango I've given this whole

38:44:00  Jango team I have a particularly far

38:48:00  some of my colleagues don't share and

38:53:00  moment is defined by by what it where it

38:56:00  framework that came from a place of you

39:00:00  this need from it from time when the

39:05:00  place these days we live in the world of

39:10:00  front ends and native apps all this kind

39:15:00  still very very relevant but much more

39:19:00  number of companies who use Django a

39:23:00  people who huge anger for like business

39:27:00  real question is at some point we should

39:32:00  future like before we start making

39:35:00  let's rewrite everything to be async is

39:39:00  want and one of these things the best

39:44:00  people options and work out what comes

39:47:00  reasons channels exists it's like here

39:52:00  competent righted rewrite of Django to

39:56:00  support and then let's see what develops

40:01:00  that stuff to improve both

40:06:00  thank you very much

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
