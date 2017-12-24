> * 原文地址：[How to build mobile games with people in mind](https://medium.com/googleplaydev/how-to-build-mobile-games-with-people-in-mind-cdc480967fcc)
> * 原文作者：[Player Research](https://medium.com/@player_research?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-build-mobile-games-with-people-in-mind.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-build-mobile-games-with-people-in-mind.md)
> * 译者：
> * 校对者：

# How to build mobile games with people in mind

User experience design principles to help you build games people want to play by [Seb Long](https://twitter.com/seb_long), [Harvey Owen](https://medium.com/@harvey_2330) and [Gareth Lloyd](https://medium.com/@garethlloyd)

![](https://cdn-images-1.medium.com/max/1000/1*LsuiN_0VYxDOVHYSuyDPKg.png)

The audience for mobile games continues to expand globally. As a result, developers face the challenge of building games that meet the needs of a wide range of users, while wanting to differentiate their game from the crowd with a great user experience. The complexity of this challenge means that despite the best intentions, sometimes the players’ experience of a mobile game differs from the intention of the design. There are many nuanced and player-centric reasons why this might happen. The most difficult disparities to uncover are rooted in human psychology; influencing factors such as how your player audience thinks, learns, perceives, and interacts with your games.

We are [Player Research](http://www.playerresearch.com/); playtesting, and user research specialists. Google Play asked us to leverage our experience assessing hundreds of games, to build a set of principles to help you create an engaging, accessible, learnable, and rewarding game for all your players. Using these principles as ‘lenses’ on your game can help identify player experience risks, assumptions, and flaws. Addressing them will increase your chances of crafting an engaging, learnable, and rewarding game for all your players by factoring human psychology into game design.

The principles are presented alongside questions to ask about your audience, to discuss as a team, or to help guide your playtests with players. While not exhaustive, these questions should prompt teams to identify disparities between design intent and a player’s experience.

We’ve grouped these UX principles into two main focus areas:

* **Breaking barriers**: Eliminating hidden ‘barriers to fun’ by accommodating how players see, hear, think, interact, and live with a game.
* **Building structure**: Helping players understand, learn, and progress by designing a game to be learnable, and with a clearly presented and understood sense of progression and depth.

By addressing these areas, you can ensure that a game’s challenge, frustration, and confusion originate from where you intend, rather than from unforeseen consequences of design decisions.

![](https://cdn-images-1.medium.com/max/800/1*JzehAQxovGnC1jSopxIZfA.png)

### **Breaking barriers**

**Accommodating how players see, hear, think, interact, and live**

The _first set of principles_ ask you to consider your players physical and psychological constraints; and whether your players can enjoy your game as part of their everyday lives. Games that break these principles are ripe for a quick uninstall. Players who immediately find frustration or confusion in their basic interactions with a game, or blockers that prevent them from understanding the game, are unlikely to progress beyond the first experience: _“This game just isn’t for me”._

> _Take a look at what your games do to usher in new players. No-one says you have to implement your findings if you don’t want to, no-one says you have to dial back on the challenge in a game or sacrifice complexity. Maybe your game isn’t meant to be more accessible, [but] maybe you’ll find that it is a good idea to reconsider.
> _ — Rami Ismail, Vlambeer ([source](https://www.gamasutra.com/blogs/RamiIsmail/20121105/180905/An_argument_for_easy_achievements.php))

#### **Principle 1: Audience-suitable complexity**

Complexity is not just something you design into your game; as perceived by players, **complexity arises from both the game’s design and players’ capabilities**. You’re likely to be a master at your game; but players’ cognitive, motor, and perceptual abilities won’t necessarily match yours. Your target players — regardless of age or gaming experience — will have their limits regarding acceptable game complexity. Unless these limits are accounted for in design, games can quickly become too complicated or demanding.

Designing audience-suitable complexity means knowing who your audience are, and understanding their **capabilities** across functional domains, such as memory, attention, language processing, and motor skills. These functional domains can happily work in parallel, allowing us to carry out everyday tasks that draw on them all at the same time, or focus on a single domain to tackle a new or exceptionally demanding task. But, high demands in any one domain can reduce the effectiveness of the others; and high demands in multiple domains is a recipe for bad performance and confusion. So, assess the **demands** of your game in terms of those various domains. What changes can be made so that they match up? Could you reduce complexity without affecting the core gameplay?

By understanding the relationship between capabilities and demands, games can be designed to fit any target audience. Here are some questions you can use to assess the audience-complexity fit of your game:

Questions to ask about your players

* What are our target audience’s visual, motor, and cognitive capabilities?
* How do our target audience vary in terms of abilities including language and numeracy?

Questions to ask your team

* How have we ensured that our game is accessible and offers an optimal challenge considering our target audience’s current visual, motor, and cognitive capabilities?
* Should we adapt our game experience to accommodate differences in abilities?
* How early should we bring in users to test the experience?
* How might we protect our game from ‘complexity creep’ during development?

Questions to ask your players

* Did you feel confused at any point while you were playing?
* While playing, did you feel like you had all the information you needed? Did you know where to find it?
* Can you show me how to find [feature] in the menus? Were you able to use the menus easily?
* Do you feel like this game is ‘for you’? Is it aimed at you? If not, who is it aimed at?

#### **Principle 2: Designing for flexibility**

Designing towards your target audience’s capabilities is a great start. But no matter how well you do that, there will always be differences among your players, in terms of their experiences, preferences, and the environments where they play. **Accommodating for differences among players in your target audience is just as important as defining your audience**.

Games are a part of everyday life for people, so where possible games should be designed to be flexible to allow for the various contexts in which they are played. The real world offers interruptions, both on the device and off. To ensure your game fits neatly into people’s lives, make sure it supports flexible session lengths, customizable control and audiovisual settings, and accommodates for distraction and task-switching.

For example, in [Hearthstone Blizzard](https://play.google.com/store/apps/details?id=com.blizzard.wtcg.hearthstone) built in features to accommodate long interruptions in play:

> _Players returning to Hearthstone after a break often still think of themselves as experts, so a traditional hand holding tutorial could be seen as oversimplified and insulting. Instead, we offer a set of quick pop-ups to let them know what’s changed and a couple of unique daily quests to guide them back into the flow of the game.
> _— John Hopson, Senior User Research Manager, Blizzard Entertainment

Here are some questions to ask that can help you assess flexibility in your game:

Questions to ask about your players

* Where, when, and on which devices are our players playing the game?
* What aspects of that context could impact gameplay?
* Does our projected session length match players’ _actual_ session lengths, and fit into their real lives?
* Do we provide enough time for players to perceive and comprehend gameplay feedback?

Questions to ask your team

* How might we let players personalize their experience to their everyday _preferences and capabilities_, such as offering video and audio settings?
* Can we design gameplay that accommodates interruptions?
* How could we accommodate players returning to the game after a long period away?
* Do the game controls reflect players’ ergonomic restrictions when holding their device, for example, require them to reach across the screen or potentially cover elements with their fingers?
* Can we give players the option to automate, hide, or turn off gameplay features that are not core mechanics?

Questions to ask your players

* How often do you find that you are interrupted during game play?
* When your game was interrupted, what happened when you returned to the game? Was that what you expected to happen? If not, why not?
* Did you change any settings in the game?
* Was there anything about the game or the controls that you would have liked to be able to change?

![](https://cdn-images-1.medium.com/max/800/1*yi7pXoB8CGviwAURA6GLKg.png)

### **Building structure**

**Helping players to understand, learn, and progress**

While it’s important to address potential barriers to play, player experience also plays a role in converting an audience of first-time players into experts and fans. By emphasizing learnability and the connectivity of features in your game, you can communicate game knowledge and skills to players, and guide them along the journey you have designed. In turn, they will play the game as you have envisioned.

#### **Principle 3: Leverage familiarity**

Players learn game features effortlessly when aspects are already known to them in some way: as platform or genre standards, or because they mirror the real world. Players recognize progression structures from similar games, such as earning a certain number of stars to progress to a new area. Widely-used and immediately recognizable real-world iconography and behaviors can also be employed, such as pulling and releasing a slingshot. When designed with familiarity in mind, players can make valid, educated guesses about how items, features, or interactions will behave.

Familiarity can also come from internal consistency. As players spend more time with the game, its visual language becomes familiar and recognizable. Associating consistent iconography, terminology, and coloration with game features and functions helps players build a strong mental model of a game. Maintaining this consistency will help players to predict the function of new features, without having to be explicitly taught.

> _When we design UX at King, understanding and responding to our player’s expectations is paramount. All products exist within their context, and our players have grown to recognize and expect the visual shorthand of mobile games. Adhering to these expectations (and knowing when to break them!) helps us to craft delightful experiences, where the player can focus on the fun with minimal cognitive load._
> — Caitlin Goodale, User Experience Designer, [King](https://play.google.com/store/apps/dev?id=6577204690045492686)

Questions to ask about your players

* What are the players’ norms and expectations around gameplay mechanics?

Questions to ask your team

* Is the UI laid out in a manner that is consistent with players’ existing mental models?
* How can our mechanics, features, and interactions be made more intuitive and understandable using our players’ _real-world knowledge_?
* How can our mechanics, features, and interactions be made more intuitive and understandable by being consistent with _other aspects of our game_? And _other games_ that our audience may have played?
* Can we ensure our iconography and terminology is distinct and can be recognized quickly?

Questions to ask your players

* What do you think these icons mean at first glance?
* How might you expect this feature to work?
* Did this feature work as you expected it to? If not, why not?
* Was there anything in the game that didn’t work as you expected it to?
* Is this feature something that you’ve seen in other games?

#### **Principle 4: Assistance nearby**

New players usually start with a game by trying to play it, even if they don’t fully understand it. Motivated players will most likely learn through play, trial, and error.

But successful learning through exploration doesn’t come for free; comprehensive feedback systems and safeguards are needed as players inexpertly interact with the game while they figure it out. To learn, players need feedback that is rich, relevant, and timely, allowing them to understand their effect on the gameworld.

Learning through discovery is also more effective when players are in a safe environment. This should emphasize practice, perhaps by appropriate “chunking” game concepts into approachable trial-and-error sections. It should also allow players to recover from errors, whether by design — for example, by being generous with resources early on — or by providing options to undo in-game actions while learning to play.

Players feeling confused — or simply wanting to learn more — can also be prompted with extra information: ‘read more’ help, ‘information’ buttons, and even full-blown manuals or customer support contact information. However, avoid relying on these resources as the only way for players to understand your game. Although the instructional needs of each game are different, it’s best to enable players to learn as a result of playing with your game.

Questions to ask about your players

* Are your players more likely to learn by exploring your game or by relying on help?

Questions to ask your team

* What are the ideal times (and locations) to present players with supportive information?
* What undesirable errors might players make in our game, and how might we elegantly protect them from that negative experience?
* How might our gameplay feedback better communicate player’s influence on the gameworld?

Questions to ask your players

* Did you ever make any mistakes that you couldn’t recover from? If so, what happened?
* Do you prefer to figure out how to play these sorts of games on your own? Could you do that in this game?
* Did you see any help messages in the game while you were playing? Did you take their advice, and were they useful?
* Did you go looking for further help or information about how to play? Where would you expect to find that information?
* Did you feel like you knew when you were doing well or badly in the game?

#### **Principle 5: Effective, minimal tutorials**

![](https://cdn-images-1.medium.com/max/600/1*b5AAnrLnYQWCn-QJGEVLSw.png)

In situations where teaching methods based on player intuition, familiarity, and trial-and-error discovery aren’t effective, games need to explain themselves clearly. Tutorials, text prompts, and ‘click here’ sequences are common methods of teaching.

Excessive reliance on tutorials can overwhelm players by asking them to remember too much, or make them feel stifled by an inflexible experience. However, in the absence of other methods for players to learn how to play your game, a lack of tutorials can leave players lost.

Playtesting and iterative design can help to pin down the ‘Goldilocks’ tutorial for your audience: the right amount to teach your players the fundamental concepts and features of your game, while balancing explicit tuition with learning through familiarity, intuition, and assistance.

Questions to ask about your players

* Are your players likely to be particularly resistant to tutorials?

Questions to ask your team

* Is our UI accurately communicating the game structure to players?
* Can players recognize our gameplay feedback and are they able to respond as we want them to?
* Which areas need more — or less — tutorialization?
* Have we maximized opportunities to teach players (for example through loading screens, pause menus, teaching through menu interactions, videos, or cutscenes)?
* Are we using tutorials in the right places?

Questions to ask your players

* Are tutorials something you feel comfortable using while learning a new game?
* Did you feel restricted by the tutorials in the game? Were there times where you would have preferred to learn on your own?
* Were you able to understand each tutorial? Did you manage to quickly learn what it was trying to teach you?

#### **Principle 6: Clarity of depth**

Once your players understand the basics, what’s next?

Clear goals give players purpose, things to work towards in a play session, and reasons to return to the game. Communicating goals in term of the structure and depth of a game — the _metagame_ — fosters _confidence_, is _rewarding_, and encourages _retention_.

It’s often a challenge to communicate to players how a deeper metagame links to core gameplay loops, typically as the result of weak, abstract relationship between the two. Many games lean on familiar models to communicate basic structure and progression, such as ‘collect 3 stars’ and ‘complete the previous level to advance.’

Rewards and incentives can also be used to communicate metagame systems; but like goals, they need to be clearly understood by players. A misunderstood reward can confuse rather than reinforce players’ understanding of how and why they progress in the game.

Other players can also provide a source of depth, and potentially an endless metagame. Social interaction and competition between players — via leaderboards, player versus player, co-operative play, ‘clans’, social sharing or simply just chat — can be an incredibly engaging and may be a potentially limitless source of depth. These methods can be challenging to implement however: not only because of the technical demands involved, but also in terms of communicating how multiplayer and social interactions complement the game’s single-player content and mechanics.

These are challenging — but critical — UX issues to address, because a strong metagame means an engaged audience in the long-term. Communicating metagame systems effectively will ensure players can make confident and informed decisions about in-game purchases, and increase the likelihood that they remain active for longer before uninstalling. This is also true outside of free-to-play models: a good metagame means a captive audience for your sequels or follow-ups.

Questions to ask about your players

* Do your players seek out games with longer-term goals?
* To what extent do players seek out this type of game for its social aspects? Do they want to play with or against other players?

Questions to ask your team

* Are we presenting longer-term goals in an understandable manner?
* How do we meaningfully communicate the presence of other real players and how multiplayer and social interactions fit into our metagame?
* How might we reinforce the relationship between gameplay progression and metagame progression?
* Which features are designed to bring players back, and are they presented meaningfully to players in the first-time user experience?

Questions to ask your players

* How do you progress in this game?
* What are you trying to do in this game now?
* What do you need to do in this game [in the long term]?
* How do you get better at this game?
* Will this game get more difficult?
* Can you interact with other people in this game? How?
* What can you buy in this game? Can you buy things to help you?
* What do you spend to buy things in this game? How do you get more of them?

![](https://cdn-images-1.medium.com/max/800/1*86fbAfv5Zjh3ubVCxIP-QA.png)

### **Refining focus**

**Getting the balance right**

We have discussed several ways in which you can make your game intuitive without adding complexity. But, remember, no-one wants a game that’s boring, ‘vanilla’, or uninteresting. Successful games challenge players and provide them with a sense of achievement.

As creative game developers, you can ignore any of these principles in the name of fun. Many successfully games use visual complexity, awkward controls, unfamiliar gameworlds, and so on. In some cases, deliberate complexity and friction can become the ‘source of challenge’ unique to the game.

However, neglecting (or making assumptions about) these principles increases the risk that your game will have unintentional barriers, and add unintended friction to players’ experiences. In short: choose your battles wisely, and try to ensure that your game is only demanding in the ways that you want it to be.

We hope that bringing these player-centric principles into development discussions will help you craft the experience you envision for your game. Careful and deliberate experimentation with these visual, motor, cognitive, and fundamentally _human_ design choices will increase the chances of players finding the fun you’ve made for them, and keep them coming back for more.

In future articles, we will share the results of working with games developers to apply these principles to their game design.

* * *

**What do you think?**

Do you have thoughts on designing user experience for games and how human factors affect gamer behaviour? Let us know in the comments below or tweet using **#AskPlayDev** and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
