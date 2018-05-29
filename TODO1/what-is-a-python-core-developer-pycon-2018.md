> * 原视频地址：[Mariatta Wijaya - What is a Python Core Developer? - PyCon 2018](https://www.youtube.com/watch?v=hhj7eb6TrtI)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-a-python-core-developer-pycon-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-a-python-core-developer-pycon-2018.md)
> * 译者：
> * 校对者：

# Mariatta Wijaya - What is a Python Core Developer? - PyCon 2018

> 本文为 PyCon 2018 视频之 Mariatta Wijaya - What is a Python Core Developer? 的中文字幕，您可以搭配原视频食用。

0:00  hello everybody welcome to our next

0:02  session here and I'm really really

0:06  excited about this session gonna have a

0:10  great talk on what it is to be a Python

0:14  core developer and giving the speech is

0:17  my friend here maryada we yaha we see I

0:23  got it wrong all right it's Marietta and

0:27  we won't be having any Q&A; afterwards

0:30  but I'm sure Marietta would be happy to

0:33  talk with you during the rest of the

0:35  conference if you find her so on she'll

0:37  be around so without further ado Mario

0:44  it's working all right hi welcome to my

0:49  top so before I introduce more about

0:52  myself I'd like to introduce all of you

0:55  here will will all be here in the same

0:57  room for like 45 minutes I think it's

1:01  good that we all know each other more so

1:05  I'm pretty sure everyone in this room

1:06  use Python right you have written at

1:08  least hello world with Python yes you

1:12  use f strings yes and you're all here

1:16  are members of the Python community

1:18  you're here at PyCon meeting interacting

1:21  with other Python is this you're all

1:23  member of the community and and I

1:26  believe many of you here do give back to

1:29  the community by contributing to open

1:31  source can I see how many people have at

1:34  least made one pull request to any open

1:37  source project to see Python there's a

1:40  lot of you there's a lot of you that's

1:42  great that's awesome so thank you so

1:44  much for contributing to open source and

1:46  to see Python

1:48  alright Who am I now I am really busy

1:54  that's a summary of it so my name is

1:57  Mary era and now you can find me on

1:59  Twitter github I'm a mom I have two

2:02  children two sons seven and five years

2:04  old I moved to Canada a long time ago so

2:08  I now live in Vancouver I work for

2:11  zapier so first of all

2:13  I want to thank SAP year for completely

2:16  supporting me sending me here to speak

2:18  at PyCon all they ask is I wear the

2:22  t-shirt branding so thank you is a paean

2:26  we're hiring so check out check us out

2:29  tomorrow at a job fair I will be there

2:31  too and I'm outside of my family and

2:34  work I helped organize thank you bye

2:37  ladies

2:37  and I helped organize conference called

2:41  PI Cascades so the next one will happen

2:44  in Seattle sometime in 2019 and on top

2:49  of all that I I do contribute to open

2:51  source so it's kind of a new thing for

2:53  me I just really started doing that two

2:56  years ago I I really feel a newbie when

2:59  it comes to open source so but last year

3:03  somehow they granted me the commit write

3:06  to see Python I can now call myself a

3:10  Python core developer and this talk is

3:16  all about this like since I became a

3:18  core developer everybody has lots of

3:20  questions like what even is a Python

3:23  core developer like what is it like how

3:25  can they become a core developer so to

3:30  save myself from answering all of that

3:32  for future generations I'm just gonna

3:34  answer all of that here in this talk and

3:36  I can point them to this video next time

3:39  and to help illustrate the journey I'm

3:43  gonna borrow this diagram which I saw it

3:46  by Caribbean Lyceum I saw this from dr.

3:49  Russell Keith McGee's keynote speech he

3:52  called is the open source conversion

3:54  funnel so he described it as follows

3:57  like there is a universe of people who

3:59  could potentially use your project some

4:02  of the potential users eventually find

4:03  your project and start using a project

4:05  and some of the new users sticks around

4:07  and becomes a regular user some of the

4:10  regular users stick around and start

4:12  participating in a community becoming

4:13  community members some of the community

4:16  members start contributing to the

4:17  project and become contributors some of

4:20  the contributors stick around long

4:21  enough and eventually becomes the core

4:23  team and some of the core teams becomes

4:24  the leader of the community

4:26  I copied it McGee and he talked really

4:31  fast too so throughout this talk I will

4:37  start with this diagram except I'm gonna

4:41  flip it upside down I felt the journey

4:44  has been more like climbing up the

4:47  ladder going up in the food chain

4:49  instead of going down like that

4:51  and I wouldn't be distinguishing between

4:56  potential users or new users let's just

4:59  talk about everyone's the user of Python

5:02  and in place of the leader we have to be

5:06  the FL and in my opinion the core team

5:10  they also become the leaders of the

5:12  community and I will talk about a more

5:15  of that later but this is how I felt my

5:19  journey has been I started as a user I

5:21  used Python and then I started getting

5:24  involved in the community going to

5:27  conferences I went to PyCon I went to

5:29  meetups and then I started contributing

5:31  to open source and eventually they gave

5:34  me commit right and I become the core

5:37  team members and I think that's where

5:40  the journey ends like the BD FL nobody

5:43  will replace him he will be around

5:45  forever forever now back to the question

5:52  what is a Python core developer

5:56  technically it just means that you have

5:59  the commit right to see Python and

6:02  currently there are 89 people in this

6:06  whole world this programming language

6:08  with seven million users there are 89

6:11  people with such commit writing comes

6:17  with certain nice perks so I get to have

6:19  this cool Python logo next to my name in

6:23  the back tracker I get to come to the

6:27  Python language submit free admission

6:29  free lunch

6:30  and it happens every year at PyCon us

6:34  and I get to come to buy some coarse

6:36  prints and uh it seems to be happening

6:39  annually I really hope it just becomes

6:41  an annual tradition but it comes with

6:47  certain responsibilities once you were

6:50  granted commit right you will be added

6:53  to the Python core team on github and

6:57  you will be added you will be

7:00  responsible for 17 repositories

7:03  obviously the C Python the Deaf guide

7:07  the paps our workflow performance and

7:10  all our github BOTS you'll be expected

7:14  to subscribe and participate in various

7:17  Python mailing lists Python runs our

7:20  mailing list so it means you'll get

7:24  thousands of emails I have thousands of

7:28  emails I receive thousands of emails my

7:29  inbox is full I have to figure out today

7:33  so you're going to have to learn how to

7:36  manage your emails I said that you'll be

7:42  responsible I talked about

7:43  responsibilities what I meant is that

7:47  it's expected that you're going to have

7:50  to review a lot of for requests today

7:53  there are more than 600 still open and

7:56  you're going to have to make decisions

7:59  whether you want to accept those peers

8:01  or said no and in the past year core

8:06  developers has closed more than 6,000

8:10  for requests that's a lot of work and

8:14  when you do accept the full request

8:17  you've gotta be prepared to face the

8:19  consequence I mean if if everything's

8:24  fine it was the right decision usually

8:26  nobody said anything but if it was the

8:29  wrong decision that it actually breaks

8:33  things introduced bugs

8:36  the person who merged the poor requests

8:40  we all have to take the blame you will

8:43  be responsible and follow up and try to

8:45  fix things just because you merge it

8:48  so it's a huge responsibility and then

8:55  you're going to be expected to help

8:57  people to contribute to cpython because

9:00  you you know how to contribute you know

9:02  what you expect and since you have the

9:07  commit right to cpython

9:08  you get to make decisions you get to

9:11  tell people what goes in to python or

9:15  not you get to shape the language decide

9:21  how it's going to evolve that's a huge

9:25  responsibility and that makes you the

9:28  representative and leader of Python the

9:34  language and the community yes there's

9:39  there's a PDF file he makes a lot of big

9:42  decisions but he takes input from the

9:46  core developers he relies on us to and

9:48  he delegates many things to the core

9:51  developers often he just say I want

9:53  these to happen and core developers make

9:55  it happen

9:56  so we're his helpers well his

9:58  second-in-command core developers are

10:02  the leaders of this community so now

10:06  I've talked a lot about what being a

10:08  core developer is people still have lots

10:12  of questions about it so I'm going to

10:14  answer them one by one this is one of

10:19  the most frequent question I got a new

10:21  user or somebody I just met asked how

10:26  they can be a core available but this is

10:31  a really big question it's difficult

10:34  concept to explain to just a user so I'm

10:38  going to try to answer some really easy

10:40  questions first how can someone be more

10:44  involved in the community this is really

10:48  easy because there are lots of ways to

10:51  be involved anyone can take part you

10:54  start locally help out your local Python

10:58  Meetup I run meetups I know we're always

11:02  looking for help we're always looking

11:04  for people to speak give workshop teach

11:07  so if you want to help out reach out to

11:10  your local meetup organizers tell them I

11:14  want to give a talk I know a venue where

11:17  you can host made ups help them out and

11:20  if there's no Meetup

11:21  start one if you don't like to do

11:25  meetups it's too much for you that's

11:27  fine you can just write blogs about

11:30  Python share to the world how you you

11:33  use Python write about your favorite

11:35  library write a tutorial or just spread

11:38  the knowledge of Python to everyone

11:41  volunteer at conferences that's a good

11:44  way to contribute back to the community

11:46  especially here at PyCon PyCon

11:50  conferences rely on volunteers and

11:55  whenever you're interacting with other

11:58  members of the community always always

12:00  be a good person the open considerate

12:04  and respectful next question how to

12:10  contribute to open source lots of ways

12:15  join the communication channels join

12:18  their mailing list

12:19  Ayana see kitaru slack just get to know

12:23  other country viewers get to know the

12:25  maintainer help by reporting issues tell

12:29  us how to reproduce bugs that you

12:31  encounter propose new ideas help with

12:36  documentation this is really important

12:39  every projects I've participated in

12:42  really could use help in the

12:45  documentation review pull request and

12:48  again you're interacting with other

12:50  contributors always be open be a good

12:55  person be considerate and respect now

13:00  usually after I answer all that the next

13:04  follow-up question is always well

13:08  actually I just want to contribute to

13:11  code not the documentation maybe I can

13:15  start with me

13:15  but eventually I want to contribute to

13:18  code tell me how all right I guess

13:23  people really have this specific desire

13:26  to contribute to codes

13:29  sure if the goal is don't come tribute

13:32  to code you have to first rate the

13:35  contribution guide every large project

13:38  has one everyone every project has

13:41  different guide different workflow you

13:43  have to up first read that and then find

13:47  an issue to work on and then you have to

13:50  learn how to use version control like

13:53  get and then create a pull request and

13:59  then the follow-up question through this

14:01  is okay Mary receives your Python core

14:04  developer please be more specific and

14:07  tell me how to contribute code to see

14:11  python this is this is the biggest

14:14  mystery everybody wants to know this and

14:17  I I wanted to know this too I asked this

14:21  very same question to the media fellow

14:24  two years ago and so I'm just going to

14:27  tell you what he told me first with the

14:33  dev guide it really has everything you

14:36  need to know the Deaf guide tells you

14:38  how to get the source code how to use

14:41  kit where our mailing list are how to

14:44  run tests how to compile everything he

14:47  said here this is the URL that guy read

14:50  it and then next he told me join the

14:55  core mentorship and Python death mailing

14:58  list and if I ever need had ever have

15:00  questions just ask me the mailing list

15:03  is that just tell them Guido sent you

15:06  okay

15:09  really the first few emails I wrote to

15:12  the mailing list

15:13  it started with hey I asked Widow about

15:17  this and he told me to write to you so

15:20  here is my question then he pointed me

15:25  to the bug tracker this is where you're

15:28  supposed to find issues to work on and

15:31  then said what an easy issue create a

15:36  patch patch at a time pull requests now

15:38  so these are what we don't old me simple

15:44  sounds like it and he never really

15:48  actually gave me any issues to work on

15:51  he never assigned anything to me because

15:52  he didn't know what I was interested in

15:55  so that was something that I had to

15:59  learn on my own so I started subscribing

16:03  to updates to the bug tracker

16:05  so I get email whenever there are new

16:09  activities and then I try to read some

16:13  of them find anything that interests me

16:16  and then start researching and figure

16:20  out how to fix the bug now at that time

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
