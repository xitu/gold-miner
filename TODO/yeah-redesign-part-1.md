> * 原文地址：[Yeah, redesign(Part 1)](https://medium.muz.li/yeah-redesign-part-1-b61af07eb41a)
> * 原文作者：[Jingxi Li](https://medium.muz.li/@jingxili)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

![](https://cdn-images-1.medium.com/max/2000/1*ZZP4Og3NWAYova0lgaTqHg.jpeg)

# Yeah, redesign(Part 1) #
# 是的, 重新设计(第一部分) #

## How to approach redesign in the mobile world ##
## 如何在移动世界中重新设计 ##

As a design leader, I ask myself constantly: “How can my team continuously deliver the best product experience to our Users?” My answer is always the same, ‘we need to consider our Users’ constantly changing and evolving tastes in a rapidly growing community’. However, if redesigning the product experience is the solution, how do we begin an internal conversation to get that process started? How do we achieve a scalable solution, balancing new features and designs, while also maintaining the product’s identity?

作为一个设计领导者，我经常问自己：“我的团队怎样才能够持续向我们的用户提供最好的产品体验？”我的答案总是相同的：我们需要考虑到我们用户是在持续变化以及在迅速发展的社会中不断提升的品位。但是，如果重新设计产品的体验就是解决方案的话，怎样从内部对话入手来开始这个过程呢？如何实现一个能够平衡新功能和设计的同时还能保持产品的一致性的可拓展的解决方案呢？

If you are facing the same design challenges, I hope this article will help you find the answers you need to the following questions:

如果你也面临着同样的设计挑战，我希望这篇文章能够帮你找到以下问题的答案：

> **1. Why does a product need redesign when its users already love it?**

> **2. How do you execute redesign in a fast paced data driven company?**

> **3. How do you measure results?**

> **4. What is the next step?**


> **1. 为什么当用户已经爱上这个产品的时候仍需要重新设计？**

> **2. 如何在一个以数据驱动快节奏的公司中执行重新设计？**

> **3. 你如何衡量结果？**

> **4. 下一步是什么？**

To help answer these questions, I would like to share the redesign experience we had on our flagship product Sing! Karaoke and walk you through the approach our team took to overcome obstacles along the way.

为了帮助解答这些问题，我想通过分享我们对龙头产品 “唱吧！卡拉OK”（原文：sing！karaoke）的重新设计的经验，来带你看到我们团队在这一路上所克服的障碍。

When I first joined the company two and a half years ago, we had four teams, each assigned to one of the following apps: Sing! Karaoke, Magic Piano, Autoharp and Guitar. Each of the teams consisted of one designer, one product manager, and two or three engineers. With different growth speeds, we saw Sing! become the leading app in the Smule family. The company decided to shift focus from an app based development structure to a feature based structure. This means more efforts and features were added to Sing and more design collaboration is needed between the designers. With business changes, we knew our existing product design and process would not meet the needs for scaling the team and satisfying our Users.

两年半以前，当我第一次加入公司的时候，我们有四个团队，分别对应以下其中一个应用： “唱吧！卡拉OK”，魔术钢琴（magic piano），Autoharp和吉他。每个团队由一名设计师，一名产品经理和两到三名工程师组成。随着成长速度的不同，我们看到“唱吧！卡拉OK”成为了Smule家族中领先的应用。公司决定将重心由基于开发框架的应用转为基于架构的功能，这就是说将有更多的努力和功能被添加到“唱吧”以及在设计师之间会有更多的设计合作。随着业务变化，我们知道我们现有的产品设计和流程不能满足团队的扩展和用户的需求。

We knew that a redesign would not be a solitary project and would need to engage our users, designers, product managers, engineers and executive staffs. Have these parties buy into at early stage for the reasons of redesign and provide feedback for “how” the redesign should happen helped us set a clear goal what redesign would achieve in four areas:

我们知道重新设计不会是一个孤立的项目，我们需要与用户，设计师，产品经理，工程师和执行人员保持联系。由于重新设计的原因，让这些部分的人在早期阶段参与进来，并为“如何”重新设计提供反馈意见，帮助我们确定了重新设计将在四个方面实现的明确目标：

![](https://cdn-images-1.medium.com/max/2000/1*ZsWu9BZbUZzS0FqMxTPcPA.jpeg)

source:shutterstock

来源：shutterstock

> **Improve users experience**

> **Empower design team for scale**

> **Increase product engagement**

> **Build a sustainable engineering solution**

 
> **提升用户体验**

> **授权设计团队进行规范化**

> **提升产品参与度**

> **建立可持续的工程解决方案**


### **1. Improving Sing! user experience by** ###

### **1. 改善“唱吧！”的用户体验通过** ###

#### *Bring the consistency and continuity into Sing! experience* ####

#### *给“唱吧”加入体验上的一致性和连续性* ####

From many users research, we have known that consistency is one of the strongest contributors to usability. Sing! is a fun product with many features. When the product was released in 2012, it had fewer features and a smaller user base. These fewer features, resulted in a design that employed different colors to represent separate content in different contexts. For example, previous versions of Sing! had more than four colors to display ‘Call to Actions’ on various uses. While the old design aimed to please its users, we noticed that the multiple colors CTAs also confused new Users. This means that the redesign needs to establish a consistent UI language to improve our current user experiences.

从许多用户研究中，我们已经知道一致性是可用性最强的因素之一。“唱吧！”是一个有着很多功能的有趣产品。在2012年产品发布的时候，只有很少的功能和用户基础。这些少量的功能导致了用不同的颜色在不同的环境下分别代表了某部分。比如，在“唱吧！”的早起版本中，有超过四种颜色来展示“行为召唤”（在商场超市里，我们经常会看见一些新品上市，会推出免费试用以及低价促销的活动，用以刺激、吸引用户的购买行为。这就是行为召唤中的一种。译者注）的不同用途，旧的设计旨在取悦他们的用户，我们发现这种多种颜色符合的“行为召唤”会给新用户造成困惑。这意味着重新设计需要建立一致的UI语言来改善我们当前的用户体验。

#### *Improve new user engagement* ####

#### *提升新用户的参与度* ####

From conducting user studies, we noticed that new users brought their previous experiences, interacting with UIs from other apps and products, into assumptions about how their first time interactions with Sing! would function. And, most importantly, when the Sing! interface did not correspond with the user’s expectations, extra energy was spent learning and understanding the interface, which made trying this new product both exciting but also nerve-wracking. We surmised that increasing standard UIs, or updating custom UIs to match patterns that have developed in the redesign would help Users get more familiar with our product more quickly and easily. It helps user ease into understanding the product quickly which led to better engagement.

通过进行用户研究，我们发现新用户往往会带着他们之前的经验，和其他应用或产品的UI交互的经历来假设他们和“唱吧！”的第一次交互也会如此。最重要的是，当“唱吧！”的界面没有符合用户的预期时，用户需要花费额外的精力来学习和理解这个界面，这将使试用产品变得刺激却令人头疼。我们推测增加标准UI或更新自定义UI以匹配在重。新设计中开发的模式可以帮助用户更快速，更轻松地熟悉我们的产品。它可以帮助用户快速了解产品，从而导致更好的参与。

#### *Increase existing user retention* ####

#### *增加用户存留* ####

Interactions with apps have quantifiable costs that are both physical and mental. Physical costs measure the number of steps required of a user to achieve a specific goal, or time. Mental costs measure the intrinsic and extraneous cognitive load required of a user to complete a task or achieve a goal, or stress. For example, when Sing! users want to start a duet with another user, they have to navigate through multiple UIs to achieve this goal, which costs the user both time and stress which does not enhance understanding of the content. It is the belief and plan that using clear standard interactions and UI design, will significantly reduce user’s physical and mental costs.

与应用程序的交互具有可量化的物理和心理成本。物理成本是用户达到特定目标所需的步骤数量或时间来衡量。心理成本是通过让用户完成一个任务，或达到一个目标所需的内在和外在的认知负荷以及压力。比如，当“唱吧！”的用户想要和其他用户开始一个合唱的时候，他们需要通过多个UI进行导航才能达到这个目的，这不仅仅浪费了用户的时间和压力，同时也没有帮助用户理解内容。有计划有信念的使用明确的标准交互和UI设计，将显著降低用户的身心成本。

![](https://cdn-images-1.medium.com/max/2000/1*ZH2VNJu33_eaMvPVikPUxg.jpeg)

source:shutterstock

来源:shutterstock

### 2. Empowering design team for scale ###


### 2. 赋予设计团队可拓展性 ###

#### *Create a new font for Sing!* ####

#### *为“唱吧！”创造一个新字体* ####

Sing! started with Gotham font, a font inspired by mid-century architecture setting of New York City. Gotham is a great font to celebrates Smule’s fun, whimsical and welcoming feelings. It still represents Smule’s brand identity through today. However, Gotham is a font intended to be used in print and media applications. When rendered on mobile devices, it caused many issues. Gotham has a wide kerning and takes more space in a given word or sentence. Mobile devices have limited real estate (screen size), therefore designers must always make the extra effort to make sure the text works well in both iOS and Android environments. Many times, the font size has to be reduced to make it fit in the small space, causing a readability issue for users. Another issue caused by Gotham is it’s lower baseline. Because of this, the engineers have to manually, and visually, make sure copy is centered. As you can see by these examples, we encountered many design bugs during development as a result. We know now that finding a scalable and platform standard font is one of the critical decisions we have to make during the redesign.

“唱吧！”开始使用的是Gotham字体，是一种灵感来自纽约市中世纪建筑设计的字体。Gotham是一款非常棒的字体，可以庆祝Smule的乐趣，异想天开的感觉。它仍然代表了Smule在今天的品牌形象。然而，Gotham是用于打印和媒体应用程序的字体。在移动设备上呈现时，会引起许多问题。Gotham有着较宽的字间距，会在同样的词句上占据更多的位置。移动设备具有有限的屏幕尺寸，因此设计师必须总是做出额外的努力，以确保文字在iOS和Android环境中都能显示正常。很多时候，字体的大小字体大小必须缩小，使其适合小空间，造成用户可读性问题。Gotham引起的另一个问题是基线较低。因此，工程师必须手动，在视觉上确保副本是居中的。正如你所看到的这些例子，我们在开发阶段遇到了很多设计问题。我们现在知道，找到可扩展和平台标准字体是我们在重新设计过程中必须做出的关键决定之一。

#### *Sing! needs to standardize its’ design language* ####


#### *”唱吧！”需要规范其设计语言* ####

Design is a creative process that is both organic and nostalgic. Without a standard UX/UI design guideline in place, the product can become a hodge podge of the aesthetics of each designer who worked on the project. Keep working on these designs caused confusion within the design team, limited designers’ output, and reduced product quality. We knew that our previous Sing! design standard was not clearly defined. This ambiguity caused further delays and difficulties during our design critique and review process. When no one on the team can articulate the design standard that we are aiming for, all feedback and review is judged based on personal preference, thereby invalidating much of it. As a team we understand it will take a collaborative effort to deliver the best product and experience to our users. To that end we recognize that we need a clearly defined standard that is communicated to all design team members for use throughout the redesign and moving forward. This will set the foundation for every product design decision made by the team.

设计是一个既有机又怀旧的创作过程。没有一个标准的UX/UI设计指南，该产品将成为每个在项目中的设计师对于美学理解的大杂烩。继续研究这些设计会使设计团队产生混乱，限制设计人员的产出，并降低了产品质量。我们知道我们以前的“唱吧！”没有明确定义设计标准。这种模糊不清在我们的设计评论和审查过程中造成了进一步的延误和困难。当团队中没有人能够阐明我们的目标设计标准时，所有的反馈和审查都是基于个人偏好来判断的，其中大部分都是无效的。作为一个团队，我们明白我们需要共同努力为用户提供最好的产品和体验。为此，我们认识到，我们需要一个明确界定的标准，传达给所有设计团队成员，以便在整个重新设计和推进过程中使用。这将为团队的每个产品设计决策奠定基础。

Tremendous growth in the design team has made us realize that a set of rules needs to be established. This guideline will establish the treatment of , IA, layout, fonts, color, imagery, and interactions. The advantage of a guideline is that it will act as a framework that will apply to most design issues speeding up the design process by helping designers to make right design decisions the first time. More importantly the design team needs to create a shared, central repository, updated as frequently as needed, that documents our styles, components, and patterns. With this shared hub in place, improvements in the consistency of designs as well as the quality and quantity of designs is sure to follow. That means, along with the Sing! Redesign, the design team needs to create this guideline so that there is less room for disjointed, personal design styles and the visual appeal of the product will remain consistent. It is our goal that, eventually, the designers won’t have to work on specing icons and think about what the right spec is. Instead, they can focus more on creative design solutions for users.

设计团队的巨大增长使我们意识到需要建立一套规则。这个规范的建立是对于信息框架，布局，字体，颜色，图像和交互的处理。优点是，它将作为一个框架，适用于大多数设计问题，帮助设计人员在第一次就做出正确的设计决策来加快设计的过程。更重要的是，设计团队需要创建一个共享的中央存储库，根据需要经常更新，记录我们的样式，组件和规范。随着这个共享中心的到位，设计的一致性以及设计的质量和数量将得到改善。这意味着在“唱吧！”的重新设计中，设计团队需要制定这个指导方针，以减少脱节的空间，个人设计风格和产品的视觉吸引力将保持一致。这是我们的目标，最终，设计师不必致力于图标的细节刻画，不必思考正确的规。相反，他们可以更多地关注用户的创意设计解决方案。


#### *Design team needs to scale up* ####

#### *设计团队需要扩大规模* ####

With more product features being added and more users joining our Sing family, our design team needs to grow and improve our collaboration. Without a common understanding of building blocks that forms the basis for collaboration, pressures on the team to keep up with this growth can result in communications getting complicated. To ensure our teams are successful, we know our design approach and workflows need to be modularized. This means the redesign team needs need to create some design building blocks that will be the foundation of the redesign and all design efforts. These individual building blocks will help our designers to collaborate easily and split up their works when needed. Furthermore, when a new designer joins, senior members of the team can utilize these building blocks to lead projects and set up clear plans for new members.

随着加入了更多的产品功能，更多的用户加入了我们的“唱吧！”大家庭。我们的设计团队需要发展和提升合作。没有对于建立合作基础的模块的共识，压力将会在团队增长的同时一直伴随，使得沟通变得复杂。为了确保我们的团队成功，我们知道我们的设计方法和工作流程需要模块化。这意味着重新设计团队需要创建一些设计构建模块，这将是重新设计和所有设计工作的基础。这些单独的构建块将帮助我们的设计师轻松协作，并在需要时分开他们的作品。此外，当新设计师加入时，团队的高级成员可以利用这些模块来引导项目，并为新成员制定明确的计划。

![](https://cdn-images-1.medium.com/max/2000/1*Jh6XD2B8Nx3P7mOKZSqJGA.jpeg)

source:shutterstock

来源:shutterstock

### 3. Increasing product engagement by ###
### 3. 增加产品参与度 ###

#### *Improve the new user onboarding experience* ####
#### *提升新用户的登录体验* ####


When new users try a new app, they are learning two things at once: (1) features of this app and (2) how to access those features. Without a clear and standardized UI/UX design, users might not fully understand the individual interface elements in the app and get lost. In order to let the user focus on using the product functions rather than navigating interface designs, we need to understand new users’ expectations and clearly communicate information valuable to them. Overall, the new design should simplify the confusing portions of our app and allow the user to feel comfortable to try and interact with new features.

当新用户尝试新应用时，他们他们会同时学习两件事情（1）此应用程序的功能和（2）如何访问这些功能。没有明确和标准化的UI / UX设计，用户可能无法完全了解应用程序中的各个界面元素并感到迷失。为了让用户专注于使用产品功能而不是导航界面设计，我们需要了解新用户的期望并明确传达对他们有价值的信息。总体而言，新设计应该简化我们应用程序的混乱部分，并允许用户尝试和新功能进行交互时感到舒服。

#### *Increase user retention* ####
#### *增加用户留存* ####

At Smule, we closely monitor user retention defined as how many of the new users come back to the app after their first time experience in subsequent days, such as day 2 and day 7. If a user didn’t have a good first time experience, they are less likely to come back on day 2. Through user studies, we found users enjoyed many of the features if they found the entry point. Or they requested features that already existed. These findings indicated that our design navigation wasn’t aligned with users’ intentions. If the design is not helping users know where they are and how they can access the features in their mind, they might get confused and lost their interests to continue to use Sing. With the redesign, we need to come up a better navigation what meet users intention and product business goals.

在Smule，我们密切监视用户存留，定义为在第一次使用体验后接下来的几天（例如第2天和第7天），有多少新用户回到应用程序。如果用户在第一次没有得到很好的体验他们在第2天不太可能回来。通过用户研究，我们发现如果用户找到了入口点，他们便会享受这些功能，否则他们会要这些已经有了的功能。这些发现表明，我们的设计导航与用户的意图不一致。如果设计没有帮助用户知道他们在哪里，以及他们如何访问他们所想的功能，他们可能会感到困惑，对于继续使用“唱吧”失去了兴趣。通过重新设计，我们需要提供更好的导航，满足用户意图和产品商业目标。

#### *Improve development and release cycle* ####
#### *提升开发和发布周期* ####

By the time we started to consider redesign in 2014, the product features on iOS and Android were not the same. Sing! iOS was more feature rich than Sing! Android. This lack of consistency between iOS and Android doubled the work for the design team and delayed development cycles. Sing! had gained a lot of new users by the time we started to think redesign. We wanted to carry that momentum and speed up our product design and development cycles. With that in mind, we know the redesign needs to improve our internal design team work flow and efficiency. The redesign can cut design and development time by 50%, which will give us more chances to test and release new features with current resources.

在2014年，我们开始考虑重新设计时，iOS和Android上的产品功能是不一样的。“唱吧！”在iOS上的功能要比Android上的功能多，iOS和Android的不一致使设计团队的工作翻了一番，延迟了开发周期。当我们开始思考重新设计时，“唱吧！”已经获得了很多新用户。我们想携带这种势头，加快产品设计和开发周期。考虑到这一点，我们知道重新设计需要改进我们内部设计团队的工作流程和效率。重新设计可以将设计和开发时间缩短50％，这将为我们提供更多的机会来测试和发布具有当前资源的新功能。

![](https://cdn-images-1.medium.com/max/2000/1*P4nIML48uPpJuVX-ut1tcg.jpeg)

source:shutterstock

来源:shutterstock

### 4. Building sustainable engineering solution by ###

### 4. 建设可持续发展的工程解决方案 ###

#### *Improve development process* ####

#### *完善开发进程* ####

Inconsistent UI not only caused usability issues but also created additional work overload for designers and engineers. For example, for a single icon, designers created multiple colors or sizes assets to be used in different scenarios. To make sure engineers placed the assets in the right screen, designers spent almost an extra 40% of their time to spec and create assets for engineers. On the other side, engineers needed to follow the specs, writing customized code to make sure each asset is in the right location. It sounds simple on paper, but when accounting for other variables like screen sizes and platform (iOS & Android), the process became hideous. After talking with engineers, both designers and engineers want to collaborate with each other in a better way. This brought up another perspective on the needs of the redesign: create a systematic approach on how designers and engineers can set up and build product efficiently.

不一致的UI不仅引起了可用性问题，而且为设计师和工程师创造了额外的工作负担。例如，对于单个图标，设计人员创建了多种颜色或大小的组件以在不同的场景中使用。为了确保工程师将组件放在屏幕的正确位置上，设计人员花费了大约40％的时间来为工程师规划和创建组件。另一方面，工程师需要遵循规范，编写自定义代码，以确保每个组件都位于正确的位置。这在纸上听起来很简单，但是当考虑其他变量（如屏幕尺寸和平台（iOS和Android））时，该过程变得可怕。在与工程师交谈之后，设计师和工程师都希望以更好的方式相互协作。这再次提出了重新设计需求的另一个视角：创造一个可以使设计师和工程师建立并构造产品更加有效的一套系统的方法。

#### *Increase product development quality* ####

#### *提升产品开发质量* ####

It is designers’ responsibility to do the design QA, and ensure the design was implemented correctly. The most frustrating moment for designers and engineer was: engineering fixing a design bug by changing some part of the design, which created another bug. As a consequence, engineers spend more time fixing design bugs, and there were still no guarantee that the implementation will match the design without bugs . We know that it is unrealistic to ask the redesign to address all the design bugs that may be encountered up front, but creating a standard central design guideline on how to set margins, how to create icon sizes, and how to apply for pressed status, etc. would limit the chances that previous scenarios happen.

做设计质量保证是设计者的责任，并确保设计得到正确实施。设计师和工程师最令人沮丧的时刻是：工程师通过改变设计的某些部分来修复设计错误，这将产生另一个错误。因此，工程师花费更多的时间来修复设计错误，并且仍然不能保证实现现有的与没有错误的设计是一致的。我们知道，要重新设计解决可能遇到的所有设计错误是不切实际的，但是创建一个关于如何设置边距，如何创建图标大小以及如何申请压缩状态等等的标准中央设计指南，将限制以前的情景发生的机会。

#### *Prepare for global localization* ####

#### *准备全球本地化* ####

By the time we started to think redesign, Sing had moved from US centric app to an international product. To serve the community of global users, we localized Sing! from 12 languages to 20 languages. When applying foreign language into an English-based app, the UI could easily break. For example, compared to English, German or Russian takes more characters to express the same meanings. A defined limited space that would normally fit English labels would not work for German and Russian. Without a clear rule on how to set spacing and apply the right hierarchy, our localized languages were either cut off or presented in the smaller sizes. Addressing these issues for each language one by one consumed a lot of efforts from our engineers and QA. We know through the redesign, we need to find a sustainable solution that could optimize for all the different languages that we have or might have in the future.

当我们开始思考重新设计时，“唱吧”从以美国为中心的应用程序转型为国际产品。为了服务全球用户社区本地化，我们把“唱吧！”从12种语言发展到20种语言。将外语应用于英文的应用程序时，UI会很轻易被中断。例如，与英语比起来，德语或俄语需要更多的字符来表达相同的含义。通常适合英文标签的限定空间将不适用于德语和俄语。没有一个清晰的规则关于如何设置间距和应用正确层次结构，我们的本地化语言不仅会被切断，也会以较小的尺寸呈现。逐一解决每种语言的这些问题，耗费了我们工程师和质量保证方面的大量工作。我们知道，通过重新设计我们需要找到一个可持续的解决方案,可以优化我们现有以及未来会有的不同的语言。

![](https://cdn-images-1.medium.com/max/2000/1*cAPZbmDZEe5byrPDOB7QVA.jpeg)

source:shutterstock

来源:shutterstock

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
