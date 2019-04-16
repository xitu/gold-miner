> * 原视频地址：[Jack Diederich - HOWTO Write a Function - PyCon 2018](https://www.youtube.com/watch?v=rrBJVMyD-Gs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-a-function-pycon-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-a-function-pycon-2018.md)
> * 译者：
> * 校对者：

# Jack Diederich - HOWTO Write a Function - PyCon 2018

> 本文为 PyCon 2018 视频之 Jack Diederich - HOWTO Write a Function 的中文字幕，您可以搭配原视频食用。

0:06	welcome everybody let's get started our

0:09  next speaker is Jack Dieterich a core

0:22  yeah good

0:26  little bit about me this is my 16th

0:32  written read a lot of Python written a

0:36  some things I say repeatedly when I'm

0:41  try to do in my own code if you've ever

0:45  mostly about code quality just how to do

0:52  job is hard enough without people trying

0:58  bunch of a bag of little tips and tricks

1:02  why talk about code reviews this is the

1:07  feedback on what you've written this is

1:11  up the code but before it goes out code

1:18  for publishing code and they force you

1:24  code a lot like that's a saying people

1:29  yourself read the code you write many

1:33  you've read it when you write it you

1:37  comparing the code and the tests you

1:42  you look for typos or anything else

1:46  depending on your organization might be

1:51  and any glass give or take forever until

1:56  is very important why talk about a

2:05  code a function fits on a page most of

2:12  if it's a function that's part of a

2:15  same thing it's five ten twenty lines of

2:19  walk in and look at a function that's

2:25  what it is if they already have domain

2:29  it might only take a minute but they

2:33  bottom and figure out what's going on

2:38  what the function is doing

2:42  minute understanding so they read a

2:45  you know where were we again and they go

2:50  be able to to figure out what's going on

2:54  it's your job is the writer to help them

3:04  in Nevers this talk will not have any

3:10  it these are things I put in code

3:15  you thought about this other thing or

3:19  like if you trim this other thing

3:23  for always or Nevers here is a very

3:31  completely understandable if someone

3:37  functions two lines or less this is easy

3:44  you can literally give it on every

3:48  on and you end up with code like this so

3:55  is no function over two lines and the

4:00  you feedback and you're happy because

4:05  everybody spent effort on this thing and

4:09  so my examples are going to be hopefully

4:17  has three parts thinking about function

4:22  big thing you should be able to

4:26  but but it generally has a flow from top

4:31  small examples are things that you can

4:34  little bit and again if you're in a code

4:39  the reader to say yes it's to make it

4:43  function does exactly what is promised

4:47  and the final part which is shorter is

4:53  will get you can find on the internet

4:57  longer than this moment number of lines

5:03  out for function structure functions

5:13  you have input this is where you get the

5:17  middle there's a transform this is kind

5:20  system you're taking the inputs and then

5:24  and output at the end of every function

5:30  giving back to the reader I'm Twitter I

5:36  for for this concept I was not

5:43  should be unexcited your your job in a

5:48  on and get your job so the code of

5:52  predictability let me know if any of

6:00  about function structure the first thing

6:04  you were given some inputs or maybe you

6:09  the database for some stuff that you

6:14  up expectations for the reader you are

6:19  that will exist inside this function so

6:24  the first few lines they should know

6:28  user I bet I know where this is going

6:34  the top gather up the information you

6:38  so again this makes it easier for the

6:44  that you do returns more information

6:47  you don't need and this tells the reader

6:51  care about in this function and then

6:54  not surprised early errors are good

7:00  just the information you need if you

7:02  abort

7:06  job that the function says it's going to

7:10  this not only makes it better when

7:14  big loud errors but it makes it easier

7:18  they don't have to read the next the

7:22  things are true and that's all you need

7:31  you are telling the reader that these

7:34  keep reading transform this is the

7:44  the information you need to continue and

7:49  addresses this is where you do matrix

7:54  something that has more value the reader

8:00  seen the inputs that you have they know

8:03  matrix and in the middle you're going to

8:09  boring readers output is think of it

8:15  had the inputs you've had the transform

8:19  the output is creating whatever is

8:25  name might promise that you're returning

8:29  might have a dictionary of names or a

8:34  the result unique but if the function

8:38  or a list of names this is the the point

8:42  the middle and you just turn it into a

8:45  callers happy everybody's happy

8:54  the errors happen whenever possible so

8:59  the first thing you should do when

9:03  your inputs in that there's lots of fun

9:11  the Internet project Euler if you want

9:16  or you know just practice on on short

9:22  practice programming they don't help

9:28  you thinking about inputs because the

9:33  exactly what you need to solve the

9:40  day-to-day job you're first the first

9:44  a function is figuring out how to get

9:48  talk to the database do I need to call a

9:52  arguments does a function so the first

9:57  you have and what you want and then to

10:01  middle throw out what you don't need any

10:09  anytime you you see a board you can say

10:14  board this is Conway's Game of Life

10:18  dots are on a chess board doesn't have

10:24  piece types and after you have these

10:29  do with them but just try and think

10:36  function

10:39  the promise of the function is I am

10:43  are palindromes right there in a name

10:49  users to get the names so we get a list

10:56  then just take all the names from that

11:01  that here's the thing we here's thing

11:04  right now which is just a list of names

11:09  for name and names is this a palindrome

11:14  we've added we're checking to see which

11:19  is a little bit of output and again

11:24  the input transform output is not very

11:31  speaking top to bottom this is an

11:39  if you have a function called get host

11:44  name has a plural in it implies that

11:49  host configs function is going to return

11:58  information to help the reader you

12:03  only one name that should be returned

12:08  because at this point you are assuming

12:11  want to fail and you are telling the

12:16  returned then something has gone

12:21  so you can say a certain length of

12:28  low overhead and it tells the reader a

12:32  about to happen

12:41  run just means don't do the thing I'm

12:45  would have done so this is a very common

12:51  let's get all the users and if this is a

12:57  things we would have done and seen this

13:04  this is code that you will see in a code

13:12  but if dry run blog the info else

13:20  has to wonder is something else going to

13:24  I'm the reader now has to scroll down

13:28  actually did delete the users which

13:31  so just return early when you can if

13:36  you intend to do get out

13:44  theater the expression is the gun on the

13:47  three because the the idea during a play

13:52  the audience knows that there's a gun on

13:56  happen to it and enjoys the journey as

14:00  is absolutely not what you want when

14:05  mantle goes back so if you tell someone

14:11  to wonder when you're gonna use it and

14:14  stack that there's this there's a gun on

14:18  the gun make it go bang pick up the next

14:22  and this is kind of our inheritance from

14:32  you had to declare everything that you

14:36  at the top of the function that's just

14:39  so you still see that kind of bleed

14:44  tell you up front here are four

14:47  function and then they use one and then

14:52  another one and then they do some stuff

14:55  don't need to do that so just right

15:01  declare it so this helps the reader

15:06  then use a thing and then you take the

15:10  use it again and everyone's happy

15:17  introducing fewer concepts at a time

15:22  get your ship it's everyone's happy

15:31  it is okay to put constants in default

15:42  equal three

15:46  tells you exactly what's about to happen

15:52  max retries okay so you know they said

16:00  Twitter logo look it up times a it's

16:07  and you might say max three tries is

16:11  shared before you declare it at the top

16:14  do but in C there was no way to express

16:22  do you put your function defaults in C

16:26  constants and see in the include file

16:29  be in Python you have options so you

16:41  exceptions if you've seen some of my

16:47  overused exceptions can are usually also

16:54  there's an exception at the top of the

16:59  raise it someone has to go back the

17:02  definition is

17:05  in Python you can usually get away with

17:12  has the added benefit that you don't

17:17  already know the semantics of built-in

17:24  names names are easy and hard both

17:34  going to be a lot of names in your

17:39  you don't have to add a lot of context

17:43  function you know if they're five lines

17:47  all the context they need good naming is

17:54  bad names

18:01  use to tell the reader that they

18:04  the name raw is great

18:09  Python where it's a built-in so I tend

18:14  use bites I tend to use the word raw

18:19  the reader this is some data format it

18:24  tells them that they shouldn't care what

18:28  around whatever this Brawl thing is and

18:32  it's a function so you're gonna do

18:34  very soon later so user equals

18:39  no one's guessing at what this is doing

18:44  from somewhere and it gives you

18:48  instance of a class

18:55  the temporary so again this is a

18:59  lot of context and a small amount it's

19:05  get away without using a temporary then

19:10  one less thing that the reader has to

19:14  you're going to reuse raw later I mean

19:18  and then you used it but if you can if

19:24  immediately use the return value of the

19:29  nobody has to wonder if you're gonna use

19:33  temporary if the reader really really

19:41  well-known idioms and Python for pretend

19:47  around and and del individual variables

19:54  doesn't matter underscore very popular

19:58  probably get what it is dummy

20:05  function signatures and says when you're

20:11  updating an existing thing and you don't

20:15  flag is no longer meaningful you know

20:20  if the it promises the reader that this

20:26  surprised and angry if five lines down

20:32  you won't get your ship it's so ignored

20:41  so how many things are there you can use

20:46  something useful about the return value

20:50  maybe I could we could be returning

20:54  the reader something about what was

21:00  promise to the reader that there's a

21:04  that's a pretty good name left and right

21:10  blow up if there's not two things so the

21:15  there's two things and it doesn't even

21:18  they believe the computer and left in

21:25  so maybe the the left one and the right

21:30  two things if you actually know

21:35  things and then you you can tell the

21:39  if there's an old thing in a new thing

21:44  primary secondary so if you have a pair

21:48  name the variable with a little bit of

21:56  another talk name things once who what

22:04  we're wearing the five W's are good when

22:11  free code who you don't really care who

22:17  when q2 is a terrible name to add to a

22:25  reference unnecessary reference to

22:30  what is four what is four functions what

22:33  making especially for newer coders names

22:46  again in a function you're not going to

22:50  afford to have short names because

22:54  them is in config you will see things

23:01  name is almost a transposition the name

23:05  transposition from what's happening on

23:11  variables tend to get added to so the

23:16  second line has 300

23:20  or seven underscores but again this is a

23:25  there's only a couple things in play in

23:30  very short concise variable names

23:36  there's a name that's type there's a

23:45  return consistently so none of the

23:52  given this talk or the the code is wrong

23:58  wrong and bad it's you know here is a

24:03:00  thing that gives you the same bytes but

24:06:00  these three functions all give you the

24:12:00  same semantics in Python I mean they're

24:17:00  they all set X equal to 3 which is kind

24:22:00  returning none when they're called if

24:30:00  different promise to the reader however

24:34:00  send back for edit compared to lists so

24:40:00  sorted returned true great and this

24:47:00  false II so in almost every place you

24:53:00  blow up it's not going to do the wrong

24:58:00  code reviewer you have to wonder if they

25:03:00  you're writing code make it plain that

25:09:00  reviewer that yes I know exactly what

25:14:00  false much easier to read no one has to

25:21:00  thing with returning the same types this

25:27:00  about what you meant to do

25:32:00  calc Union none might be okay

25:37:00  false or a set but we have another good

25:43:00  empty list so now we're returning a list

25:50:00  promise to the reader is we have a we

25:54:00  great far less confusing we return the

26:04:00  you can you keep handle failure

26:10:00  found the thing you were looking for or

26:15:00  reader that you you clearly thought

26:21:00  an error so a lot of functions will

26:25:00  looking for or raise an exception and

26:31:00  you go with the exception style go with

26:34:00  none style go with a none style but this

26:38:00  about your failure conditions and

26:46:00  functions are short and easy to write

26:51:00  you you want things to be easy to think

26:58:00  code there's three functions though the

27:04:00  actually the validate so we want to make

27:10:00  owners great here's three functions they

27:17:00  the same code at the end of the day it

27:22:00  the user the reader to in addition is

27:27:00  this order so this config exists and has

27:37:00  surface area so it kind of hints to the

27:42:00  any time

27:45:00  more things this tells the reader that

27:50:00  this order so you don't have to think

27:56:00  these things are true it will always

28:01:00  bit easier to read might not make it

28:07:00  about a wash in the end language

28:14:00  language feature immediately starts

28:18:00  this is great

28:23:00  great talks he takes one language

28:27:00  learn its secrets but the more will the

28:32:00  you actually want to use the thing but

28:37:00  will you will see code about the feature

28:42:00  is your professional responsibility to

28:46:00  judiciously I'm leading with the the

28:53:00  make more sense once you see the before

28:58:00  takes reads of CSV great there's your

29:05:00  it's rolling up rows that have same

29:12:00  and then at the bottom for state zip in

29:19:00  you're pretty printer great this is a

29:26:00  says it's short it's readable this was

29:32:00  review for the code that then ended up

29:39:00  there is nothing wrong with this code

29:45:00  idiomatic use of classes it does things

29:51:00  which usually what you want to do if you

29:56:00  and there is nothing wrong with this

30:00:00  written so this was the the first thing

30:09:00  the thing just underneath it so again

30:16:00  that class which was also idiomatic and

30:23:00  somewhat impressive so it uses the the

30:28:00  of yous the group by functions

30:33:00  sure if I have so it has a very weird

30:38:00  10 cases where you think you want to

30:43:00  also uses the reduced function which it

30:49:00  things that that looks like it will be

30:53:00  peculiar interface anyway so this is

30:59:00  it means to do there's no errors it's

31:07:00  case of someone had just learned a bunch

31:11:00  them all at once but after we had to sit

31:19:00  we did some other discarded refactorings

31:25:00  encounter the interface to counter can

31:30:00  the person had written the original code

31:36:00  were some questions about what some was

31:41:00  shorter but it introduced a couple extra

31:45:00  point was the guy who wrote the code

31:52:00  loop and a default dictionary so good I

31:57:00  happy

32:03:00  linters I'm not a huge fan so the

32:08:00  tell you you have an unused import or

32:14:00  the problem with linters is your

32:23:00  it's pie flakes ships with some

32:27:00  complain about you know not just 81

32:31:00  know warning this line is 13 lines this

32:36:00  to go through and make a config file

32:40:00  and then you fight about them and I mean

32:52:00  linter if two of them are dead something

32:59:00  but it feels like you're agreeing on

33:03:00  making effort and then in a code review

33:07:00  you know the linter is unhappy and then

33:11:00  then everyone feels like they've done

33:16:00  haven't it's just been it's been effort

33:24:00  preferences to to linters and I don't

33:29:00  linters crawl the AST so you can add

33:36:00  so function default you can say x equals

33:43:00  been tripped up on this once or twice

33:47:00  then goes into the function every single

33:51:00  list that list persists and that trips

33:58:00  there are valid use cases however for

34:03:00  is cash then you quite intentionally

34:09:00  method definition but I've seen people

34:14:00  again then you have to fight about is

34:17:00  so linters can be an attractive nuisance

34:26:00  nuisance Python type annotations are

34:35:00  type annotations you write should agree

34:42:00  you can spend time making your

34:46:00  don't get it so and I'm on the outside

34:56:00  problem I have I don't pass the wrong

35:01:00  once very very early on before it

35:07:00  extra effort to read and write things

35:12:00  they're smart people so there must be

35:16:00  just don't get it and so like type

35:23:00  thinking about types is is fun I get

35:28:00  like useful effort I don't get it

35:36:00  unhelpful things I am NOT going to link

35:44:00  because I don't want them to spread so

35:50:00  people's lists of do's and don'ts people

35:56:00  that it was 50 things you should do in

36:02:00  number of 50 and then work backwards to

36:07:00  so you can find anyone who will agree

36:10:00  short short functions people will be

36:14:00  function should be and functions should

36:19:00  this is kind of goes back to like early

36:24:00  compiler to only return once it was

36:29:00  about things because computers were 50

36:33:00  hasn't been true for a long time know if

36:40:00  some popularity and this doesn't mean no

36:44:00  an interest the interesting thing that

36:51:00  so there's all kinds of convolutions you

36:56:00  and and they're not pretty

37:01:00  branch

37:04:00  means literally don't type the word if

37:13:00  function think input transform output

37:20:00  work I mean don't clever up the place

37:26:00  any questions

37:36:00  microphone if you have a question Thanks

37:43:00  function return a tuple say if you input

37:50:00  average whatever what's your take on

37:54:00  order of the return or is it better just

38:00:00  if you're returning a tuple should you

38:05:00  so a function designed to return a list

38:09:00  are going to want the max want the min

38:14:00  average so rather than to write the

38:18:00  the list and all of these cool

38:21:00  but you know your users are going to use

38:26:00  that function gets a little hairy what's

38:32:00  question was if you returning a list of

38:37:00  there are transformations than the

38:40:00  men's list of maxes so I'm going to punt

38:46:00  return whatever the caller expects it to

38:52:00  list of mins and a list of maxes then

38:57:00  recommended the use of the ignore value

39:02:00  reconcile that against people's prefer

39:07:00  keyword arguments can you repeat that in

39:12:00  say function paren blah-blah-blah-blah

39:16:00  going to use that value yes

39:19:00  people's tendency to say when they call

39:23:00  with their keyword names instead of the

39:27:00  anything about calling them with right

39:31:00  Oh was then is the question when should

39:36:00  pass by Q no how do you reconcile the

39:40:00  function that's supposed to be used as a

39:43:00  you don't know what parameter is going

39:46:00  they are going to be

39:49:00  don't give the name that was given in

39:52:00  and it gets called with a keyword value

39:56:00  mismatch and you get an error how do you

40:01:00  question as broadly about what when do

40:05:00  keyword what makes things easier to read

40:11:00  be the only one I think that is

40:15:00  boolean's use the keyword arc because

40:22:00  that says do stuff true false false true

40:32:00  what's kind of your rule of thumb for

40:37:00  because it I think it might sacrifice

40:42:00  signature so passing star star kwargs

40:48:00  does hurt readability there are places

40:55:00  anyone's use the AWS boto api it has

41:01:00  um I don't know where I got it from but

41:07:00  you have to not pass that thing at all

41:12:00  kwargs stuff and adding to the kwargs

41:16:00  kwargs yeah so using kwargs is usually a

41:27:00  you

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
