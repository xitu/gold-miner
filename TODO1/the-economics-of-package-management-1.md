> * 原文地址：[The economics of package management](https://github.com/ceejbot/economics-of-package-management/blob/master/essay.md)
> * 原文作者：[ceejbot](https://github.com/ceejbot)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-economics-of-package-management-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-economics-of-package-management-1.md)
> * 译者：
> * 校对者：

# The economics of package management - 上半部分

I’m going to tell you a story about who owns the JavaScript language commons, how we got here, and why we need to change it. It’s a story about money as much as it is about Javascript— money and ownership and control.

I'm going to tell you the version of the story I know how to tell. I'm one human with imperfect knowledge and a point of view, so the story is not the only story anybody could tell about it, not by a long way. But I can tell you a good version of one slice of this story, because I was part of it. I was at its heart, because until last year I was CTO of npm Inc, the company that runs the Javascript package registry. This gives me an expertise on the topic that few people in the world have. It also comes along with a point of view, which I invite you to keep in mind as you listen to this story.

_You_ are part of this story about Javascript package management. I bet you didn’t know that. By the time I'm done with this story, you'll know why you're part of it, and why that matters.

This is a story about money, and people who have money, and how the people who make money from open source software are mostly not the people who write it. It's a story of an accidental decision that you made without knowing about it, and one that I made consciously, and how that decision worked out today. It’s a story about ownership, control, and their consequences.

It’s also a story about power—who has it, how much of it you have, and what we can do with it.

You ready? Here we go.

Our story starts with the late Yahoo back in its glory days, the mid-2000s. Yahoo was the heart of a lot of Javascript activity back then. It employed a lot of Javascript thought leaders, like Douglas Crockford, and it was pushing the state of the art forward. It might not have had a good business plan, but it had a good tech stack.

One thing Yahoo had in its tech stack was a package manager, called ypm, that apparently did some neat things.

Javascript was starting to be very interesting as a programming language, around then thanks to jquery and modern browsers adhering to a spec. Server-side Javascript was a hot topic, and there were several projects in motion attempting to make that happen.

This very conference was part of the server-side javascript action. It was here, in 2009, at JSConfEU, where Ryan Dahl announced node.js.

node.js turned out to be the server-side Javascript platform people were wanting. The early node community swept up interesting people who enjoyed the bleeding edge and the possibilities of a brand-new ecosystem where nobody had done much invention yet. Several of the people involved in early node figured out early on that package management for node would be very useful, and started writing package managers. Yes, more than one-- there were several competitors.

One of these people was a Yahoo employee who was extra-into node. He quit his job so he could write something inspired by the Yahoo package manager, but open source and for node.js. This particular programmer was clever in a couple of useful ways: he got deeply involved in the node project, and this let him work on the implementation of the CommonJS module spec in node. And he did things to beat other package managers, like give projects pull requests to support his package manager instead of the others.

This package manager was good enough and supported inside node well enough that it won. The node package manager, or `npm`, started being packaged with node instead of living as a separate third-party thing that you downloaded right after you downloaded node. That official status granted by the node project continues to today.

Somewhere around this time, Joyent bought node from Ryan Dahl for a paltry amount of money.

You’ll notice that we’re already in interesting economic territory. The man who invented node.js, the tool used by millions of people daily to develop Javascript, made a couple tens of thousands of dollars from it. Whoever’s making money from node today, it’s not its inventor. He did at least make a living from it, because Joyent hired him. [NOTE: I hear from somebody who ought to know that Dahl collected more than few tens of thousands, so he did okay in the short term. Still less than the overall value generated, however.]

The programmer who wrote npm was also hired by Joyent to work on node but-- important plot point-- he retained ownership of the the npmjs.org domain name, the npm source code, and any inventions in it as his own intellectual property. He didn’t turn it all over to Joyent the way the node source had been turned over to Joyent. This decision matters later, so take note.

In 2012 Dahl left the node project, and npm's owner stepped up to lead it in his stead, and by this time npm was the only package manager left standing.

Right about here is where you all started trickling onto the scene, or some of you anyway. You're Javascript programmers. You like writing Javascript. If you can write a tool in Javascript, you will! So you started writing Javascript with node and you liked it. Meanwhile people like me figured out that node was handy for writing I/O multiplexing services, because the reactor pattern is pretty awesome and node has it built-in. I don’t have to worry about threads, yay! As 2013 went on, more people joined us on this fun Javascript train, and node got pretty popular. And that meant npm got popular too.

Great, right? Well.

The thing about npm is that it's not just a cli tool that grabs code and slams it onto your hard drive into node_modules. In fact, the cli is probably the least important part of the npm machinery, despite how frequently you interact with it. npm is most importantly a centralized package *registry* and *repository*. Right from the beginning, the registry was there, running inside a CouchDB database, on the same domain it's on today. A "registry" is a list of a whole lot of Javascript packages, their names, their authors, their many versions. This registry made node's packages *easy to find* and it made installing them *fast and reliable*.

There's a lot to unpack here, but I think it's worth a moment of our time.

We’re looking right now at the advantages of _centralization_. The npm registry is _centralized_. Centralization has some obvious usability wins— you need to go to only one place to look for something. That one place can enforce some rules about the things you’re looking for— they all look the same, provide the same kinds of information, and maybe even don’t vanish on a whim when the person who made them gets bored.

Centralization has a lot of advantages for users. When you have one source for something, you can short-circuit a lot of work in finding the thing you're looking for. I've been doing a lot of Go programming recently, and it's very strange to try to find Go packages, because they're everywhere, and the only way to find them is to Google for them, or look at old-fashioned text lists maintained by hand— you know, Yahoo’s original thing. And when you install Go packages, you install from Github repos that could just go away on you, and this is freaky to me. I have expectations that come from using npm for 8 years or so. The absence of a central registry for Go helps me appreciate what npm gave me.

Centralization has been until recently a huge trend for the Internet. Blogging, for example, moved to centralized hosting platforms that stick around for a while, like Tumblr and Medium. Social media centralized itself. Open source centralized on Github, even though git exists  to support decentralization.

So npm is a centralized registry for all the node packages there are, and this is great, except that in 2013, as node started taking off, it started not to be so great. The downside of centralization is that _costs_ are centralized too. The downside of npm's registry is that it needed to run on a server with a database.

Servers cost money.

Where was the money coming from?

For years, node’s package manager ran on donated hosting. It was written with help from some of the people involved with implementing CouchDB, so CouchDB was its database, and it freeloaded on CouchDB hosting services. It was, for a long time, treated as an advertisement for CouchDB and the services offered by IrisCouch. IrisCouch was bought by NodeJitsu and they continued to host npm's registry as a cheap ad for their CouchDB and node hosting services.

But as 2013 went on, and you all started using node, the node package registry started getting some serious use, and it stopped being a cheap ad. Various lazy shortcuts taken in implementing the registry caused pain once the registry saw real use. In Oct 2013, the registry was down more than it was up, and it was clear something had to be done.

npm needed better servers. npm needed a maintainer who didn't mostly ignore it for his day job. npm needed money.

This is not an unusual problem for language ecosystems to face. RubyGems costs money to run, too. Perl solved its problem long ago with a network of CPAN mirrors.

npm's sole owner decided to try something other language package managers hadn't tried: he decided to try to take VC funding and turn his software into a company. He'd seen how little money Joyent gave Ryan Dahl, and how much node.js was turning out to be worth (even if Joyent was doing a terrible job of making money from it themselves). This was possible because he'd retained ownership of npm, even while he was running the node project.

So he quit Joyent, founded a company-- npm, Inc.-- and took seed funding from a VC firm.

The node project made a decision to allow this, and to continue to give npm Inc special privileges as software packaged along with node.  I don't know if there was internal dissention about this, because I wasn't part of it. The node project was entering its moribund period at the end of 2013, so it's possible the decision was made through inaction. Anyway, the node project has continued to decide to give a privately-owned company special privileges by bundling its product. They're fine with it.

^You made the decision to allow this too.  You made a critical decision right here, you and the entire rest of the Javascript community. You voted with your feet, and kept using npm's registry, thus tacitly agreeing that this was fine.

But Ceej, I hear you say, we weren't using npm then! We weren't around! Yes! Most of you weren't! You inherited this decision. You probably never realized it *was* a decision. npm exists out there, a fact of Javascript life that you never questioned. You might not have been aware or even cared that it was a company at all.

At the time, it was a controversial decision. Nodejitsu, which had been hosting npm free of charge, wasn't happy about this. They had been up to their own fix with a `#scalenpm` campaign, which ended up raising money for it at the same time npm's owner was raising VC money. There were legal maneuverings, most of which I know little about. I do know that npm exited Nodejitsu hosting very quickly and messily because the two companies were fighting and it involved lawyers. And later on, npm exited Joyent’s hosting very quickly because those two companies were also fighting.

When money is at stake, relationships can dissolve. Friendships made when it's all just open source fun can end under the strain of competing for money.

At this moment in time, I made a decision: I also decided to let Javascript's language commons be owned by VCs. I didn’t frame it that way to myself, though. The decision I told myself I was making was the decision to contribute what I could toward making node successful. I really liked programming in node, and npm was the first place I’d ever participated in open source development. I was thrilled to be able to make it go better. And I believed the story told by npm’s IP owner that we would make npm Inc self-sustaining and the servers would hum along happily dispensing packages to the masses.

So our story has taken us to 2014. npm Inc is a company; it has VC money; it starts hiring people. The first hire was Raquel Vélez, somebody you've heard speak at this very conference. The second hire was me.

I ended up leading npm's engineering team, and well, you know this part of the story. We did in fact scale npm rather ludicrously. We scaled it so well that node exploded. You all started using node to build everything you do in Javascript, and npm became an unquestioned part of every Javascript programmer's workflow. You all reinvented web development in ways you couldn't do before npm was there. Great success! It was the highlight of an excellent career, and I felt pretty great about it.

Let’s pause here for a moment, at the successful zenith of the node package manager.

Let’s talk about money.

Why isn’t Ryan Dahl living on a tropical island?

Why isn't James Halliday retired on his tropical island?

Why isn’t Dominic Tarr living on a yacht instead of a sailboat?

Why does Jan Lehnardt have a day job?

Do you know those names? They're the authors of software you have on your laptops right now, in software that is the beating heart of a thousand open-source programs you use every day. And not just you-- every Fortune 500 company there is runs the software written by those people, and dozens of others who contributed software to node and npm in the early days. They aren't wealthy, despite the enormous value created by the software they wrote.

Capitalism is supposed to reward people like them, but in practice it does not.

I think most of the people who contributed to Javascript’s commons did so without expecting or wanting money in return. They might wish they had tropical islands, but they never expected them. Money wasn’t on their minds when they wrote those modules and invented the node ecosystem, back in the early days of node, when the users of the node package manager mostly knew each other.

They were doing something else. They were exchanging gifts with their peers in a kind of economy that didn’t have much to do with money.

The native American people of the Northwest Pacific Coast of the US and Canada had an economic practice that was based on *giving* gifts rather than receiving gifts. They called their practice [potlatch](~~https://en.wikipedia.org/wiki/Potlatch~~) .  Potlatch as a social system was violently suppressed by Western colonizers, but the word stays with us, because the urge is a human thing. Potlatch as a motivation is what brings us here, because it motivated the people who put on this conference as well as many of its speakers. Potlatch culture was early node culture, when people chasing their own interests shared software libraries with each other to make everybody’s node programs work better.

There’s a little potlatch urge in every open source project announced by humans who did it it on their own, not supported by any company. this particular modern expression of potlatch culture isn't getting violently suppressed. Capitalism loves this one! Why? Well, because it’s found a way to weaponize it against us. The weaponization is Eric Raymond style open source.

You are likely aware of the difference between _free software_ — Richard Stallman style— and _open source_ — Eric Raymond style. Stallman's GNU license aims to require users of shared source code to give what they build with it away freely as well. Or at least to give their code away freely. We can argue about whether the GNU license achieves that goal or not, and people do argue about that at length. I don’t want to rehash the question here. I will merely observe that ESR’s style of open source, where you give away code with permissive licenses, is the style that has won. It’s _most likely_ the style that you practice-- you probably use "permissive" MIT & BSD licenses on your software, and you treat the GPL like poison.

Capitalism loves ESR-open-source because companies get a lot of good stuff for free. Capitalism takes this even further by telling you all that you _have_ to do this to get hired. “Github is your resume,” they tell you, hand outstretched to take free code from you and sell what they make with it.

Dominic Tarr gives away pull-stream and every Fortune 500 company there is gets to use his work without compensating him. This is our reality.

The person in this story who _did not_ give away his intellectual property is the person in this story who’s most likely to make a pile of money. Of course, he’s not going to make anywhere near as much as the venture capital funds that paid for everything— the people who truly do well in this story are the people who had money to begin with. The people who had nothing to do with Javascript are the people who effectively own its commons.

Let's talk about this term I keep using-- the Javascript commons. What do I mean by that?

The commons! It's a singular noun, meaning the collection of resources accessible to all members of a society. This could be natural resources, like the air we all breathe. It could also mean the field we all share to graze our sheep in.

> 欢迎继续阅读本系列文章的下半部分：
> 
> * [The economics of package management - 下半部分](https://github.com/xitu/gold-miner/blob/master/TODO1/the-economics-of-package-management-2.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
