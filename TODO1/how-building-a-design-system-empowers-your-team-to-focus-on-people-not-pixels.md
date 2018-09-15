> * 原文地址：[How building a design system empowers your team to focus on people — not pixels.](https://medium.com/hubspot-product/people-over-pixels-b962c359a14d)
> * 原文作者：[Mariah Muscato](https://medium.com/@mariahmuscato?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-building-a-design-system-empowers-your-team-to-focus-on-people-not-pixels.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-building-a-design-system-empowers-your-team-to-focus-on-people-not-pixels.md)
> * 译者：
> * 校对者：

# How building a design system empowers your team to focus on people — not pixels.

_This post is the first in a series about_ [_HubSpot Canvas_](https://canvas.hubspot.com/)_, our new Design Language._

![](https://cdn-images-1.medium.com/max/1000/0*9SsSqQVZoaZo-paO.png)

There’s an [old comedy skit](http://www.funnyordie.com/videos/f648312caa/taco-mail-from-holyhackjack?short_id=17p9&_cc=__d___&_ccid=jp2h43.nvxip9) about a mailman who decides he’s no longer passionate about delivering mail — he’d rather deliver tacos instead.

In the skit, a man waits by his mailbox to confront the mailman about the lack of actual mail in his mailbox. Despite loving tacos, the resident says, “If I had to choose between the tacos and the mail, I’d have to choose the mail.”

Tacos are much more exciting than bills, but the man doesn’t _need_ tacos. He _needs_ his mail.

HubSpot customers _need_ a product that’s consistent, highly functional and delightful. So the HubSpot Design team needed to create a design system that would help us fullfil those needs on a continual basis.

Over the last couple of years, we’ve:

*   Created a new design language (called HubSpot Canvas; more on that later)
*   Redesigned the HubSpot platform and refreshed the visual identity of our brand
*   Built a living, breathing design system that can scale with our growing business

In order to accomplish all this, we needed to invest in our talent. We’ve scaled our UX team from 14 product designers, 2 researchers, and 1 writer to more than 34 product designers, 8 researchers, 3 writers, and 1 product illustrator ([and we’re still hiring](https://www.hubspot.com/jobs/search?&department=product+and+engineering)).

![](https://cdn-images-1.medium.com/max/1000/1*yMhbkX8vmnJjUQqrboLs2A.png)

This is the story of how we committed to delivering the mail (while still managing to sneak some tacos in, too).

* * *

### Why we redesigned

We needed to redesign the HubSpot platform for two reasons. First, to do a better job on delivering the promise of our brand. Our customers love the HubSpot brand. It’s fun, vibrant, and full of personality. But the product, well, wasn’t. It just didn’t reflect the energy our customers were putting into growing their businesses.

Second, to eliminate the inconsistencies that had crept into our UI. Our interface had inconsistencies across the platform, which made it harder to use and navigate the tool. Take these two modals in the Marketing Hub as an example:

![](https://cdn-images-1.medium.com/max/1000/0*tasdLDY9cnLCvYEX.png)

Notice the inconsistencies in button placement, tab design, and interaction patterns? These inconsistencies increased the cognitive load on our customers, making it difficult for them to perform simple actions like saving their work or closing a dialog, which ultimately slowed them every day.

So we decided to start by gathering user feedback about our current design. The feedback wasn’t pretty, but it _was_ valuable:

> “Seems more complex than it needs to be.”

> “Too many options. My eye isn’t drawn anywhere specifically.”

> “Dense and busy. No white space.”

> “The color combinations are out of date and not pleasing.”

> “Too much grey and everything seems to be tucked away in it’s own little box.”

> “Uninteresting.”

We knew we needed a complete refocus and rededication to the customers we serve — to their personalities, quirks, motivations, aspirations, and even (or especially) their anxieties. Ultimately, we wanted to craft a new design for our product that would be as delightful and easy to use as any of the consumer apps our customers used every day.

But with that came the realization of a universal truth:

![](https://cdn-images-1.medium.com/max/1000/0*shYmOHnr870nSDWY.png)

Redesigning our platform meant we would need to disrupt 40+ product teams across two continents. It meant we would need to divert some design and engineering resources away from creating new experiences so we could fix existing ones. And during the rollout, it meant our support and services teams and our customers would need to continuously adapt to ongoing product changes.

#### We started this process knowing that we weren’t setting out to redesign just our product — we needed to entirely rethink the way we designed and built products.

We needed to understand what inefficiencies in our organizational structure and workflows had led us to create a fragmented user experience in the first place, and replace them with practices and systems that worked.

So the first part of this story focuses on how we identified those challenges, how we approached the redesign of our product, and the tools we’ve created to empower our design team to be as consistent, efficient, and autonomous as possible.

* * *

### The root of the problem

Last year, my parents decided to sell my childhood home. I was roped into helping them clean out the attic — an attic that has accumulated twenty years’ worth of stuff. As you can imagine, there were a lot of WTF moments during that cleaning session. Some moments were along the lines of: _WTF: We saved this thing!? Cool!_ But most were more like: _WTF: Why do we still have 87 Beanie Babies?_

Well, in much the same way, our design team first needed to audit every component that was ever imagined, coded, and shipped into production over the previous ten years at HubSpot. We needed to get down to this granular level to better understand what the current product experience was. Every designer was asked to go through their respective apps and find every component, take a screenshot, name it, and file it away for review.

Pop quiz: How many date pickers is too many?

Three? Maybe four?

Well, we had eight.

Here are some of the other things we found in our attic:

*   100+ shades of the color gray
*   40+ text styles in 3 different fonts
*   16 different styles of modals
*   6 different primary buttons (which means we really had _no_ primary button)
*   5 different ways to filter a table
*   Modals with confirmation actions on the left
*   Modals with confirmation actions on the right
*   Thousands and thousands of lines of custom CSS

Here’s a visual of all the buttons that existed in the HubSpot platform at the same time:

![](https://cdn-images-1.medium.com/max/800/0*Rh1VruiQzhTjgbhC.png)

Does this push your buttons?

So how did this happen? How did we end up with so many buttons? How did we end up with so many date pickers?

Here’s an actual Slack conversation from those old, darker days:

![](https://cdn-images-1.medium.com/max/800/1*Y0e2gqKh0shBq7uS3Hs-kw.png)

Putting the sass back in SaaS

The truth is, no designer or developer at HubSpot really wants to spend their time reimagining the date picker.

We identified that the reason teams had created so many variations of essentially the same styles and components was because our organizational structure created visibility issues. In short, it was very hard to discover what was already in play, and easier to just build something new.

The HubSpot product team consists of small, autonomous teams that are structured around solving for specific customer needs. This allows us to move quickly as a product development organization and be highly responsive to our customers’ changing needs. But it also presents challenges when it comes to keeping different product teams aligned.

When you have 40+ product teams rapidly building, shipping, and iterating, it’s actually pretty easy to lose sight of the overall customer experience. Being tightly focused on a specific problem often means you’re putting on blinders to everything else. Because of these blinders, our designers and developers were unknowingly recreating existing elements, components, and patterns across our user interface. This led to a fragmented user experience and compounded design and tech debt.

Our small, autonomous team structure isn’t going to change — it’s part of our DNA. So it was clear that we needed to put more effort into creating tools and systems to better align our product teams. By connecting everyone to one centralized design system, we could ensure that we’d have a unified user experience even as we continued to grow.

#### This would free our designers and developers from obsessing over pixels so they could spend more time obsessing over people.

### Getting principled

The audit helped us identify problems in our design process and understand what aspects of our development culture had created inefficiencies. But before the mood boards could be created, before the typography could be explored, before we could have heated discussions over the perfect hue of orange, we needed to get _principled_.

We needed to agree on our core beliefs, the ones we could lean on when decisions were hard. And we needed to uncover which ideals our teams felt the responsibility to uphold.

So the design team ran a few ideation exercises to establish the foundation of our new design language. We debated, we stack-ranked, and we landed on five core design principles, ones that have guided us through a million micro- and macro-design decisions since.

#### These principles are:

![](https://cdn-images-1.medium.com/max/800/1*8ZFXJph76Xf87rXDi1ICNg.png)

**Clear  
**We design for clarity and focus. Our work helps users do the next right thing through feature prioritization, visual hierarchy, and contextual awareness.

![](https://cdn-images-1.medium.com/max/800/1*Mx1oVTj3Pe_tfLcnLPELKw.png)

**Human  
**We foster a sense of joy by humanizing the experience in ways that resonate across cultures. Our work provides users with a playful and personable interaction every time.

![](https://cdn-images-1.medium.com/max/800/1*1mQH155WwYQCsFqEcESCHg.png)

**Inbound  
**We reinforce the message and meaning of the Inbound methodology. Our work makes the Inbound path clear to our users and helps them understand why it’s the right thing to do.

![](https://cdn-images-1.medium.com/max/800/1*-l2aXvIftJ7K3Xu1yLMEIA.png)

**Integrated  
**We simplify the user’s experience by creating a unified system that solves for their needs. Our work helps users achieve great things by offering a streamlined, efficient approach.

![](https://cdn-images-1.medium.com/max/800/1*pg7By-fiVHS_CVcNvhCA8w.png)

**Collaborative  
**We devise powerful systems that encourage people to work seamlessly together. Our work helps people create and collaborate with each other in natural, intuitive ways.

These principles helped us stay aligned and focused as we worked through the many details of redesigning our product. You can change the color of a button, the thickness of a line, and the size of a header. But you shouldn’t change the things you fundamentally believe in. In those aspects of the design, you should be firm.

* * *

### A new visual direction

Our design team ran a few sessions to redesign some of the core screens in our product, then elected a group of four product designers to spend a full, uninterrupted week ideating, designing, and ultimately testing a few different visual directions with our customers. These sessions produced some wildly different design directions that felt really new and exciting.

Here’s a taste of some very early design concepts from two members of the design language team, Drew Condon and Jackie Barcamonte:

![](https://cdn-images-1.medium.com/max/800/0*c-I9eExCRkuYV6Rg.png)

Former HubSpot design

![](https://cdn-images-1.medium.com/max/800/0*D6ADdRVEVyFNvCxg.jpg)

![](https://cdn-images-1.medium.com/max/800/1*RICbQgZjc-PMVdxCeUtBYA.png)

![](https://cdn-images-1.medium.com/max/800/0*JHGMI16yfbrSbJdz.png)

Wild, right? Different. Exciting. Definitely not boring, stiff “business software”.

The design language team ultimately tested three different design directions with our customers through multiple rounds of surveys and interviews. Once we heard the following statements, we knew we’d found a winning direction:

> “Makes me feel productive.”

> “I feel capable. I feel like I know exactly what to do.”

> “This is fun. This is what I would expect from HubSpot.”

> “Next generation of web.” _(someone actually said that)_

> “Doesn’t look like business software.”

> “Makes me feel in control.”

Here’s a peek into the evolution of the design direction that was preferred most by the customers we interviewed:

![](https://cdn-images-1.medium.com/max/800/0*4JJBg-EC9gjetEG3.png)

Former HubSpot design

![](https://cdn-images-1.medium.com/max/800/0*VNaNbD26_WpUrxIB.png)

Design preferred during first round of interviews

![](https://cdn-images-1.medium.com/max/800/0*PSHNwIsMTyA5WJ_a.png)

Evolved design for second round of interviews

Once we validated our design direction with actual users, it was time to apply that visual style to all of our core UI components. And I’m talking about _hundreds_ of components: buttons, links, selects, tables, breadcrumbs, modals, inputs, popovers (the list goes on). This is where the redesign got a lot less fun and a lot more meticulous and exhausting.

But that meticulous, exhausting work was a long-term investment in our company and our customers. I remember one Friday afternoon that the design language team and I spent in a two-hour long meeting. We were in the trough of sorrow.

![](https://cdn-images-1.medium.com/max/1000/0*A5bMyyGst8Mg56gw.png)

Our job that day was to decide on the margin and padding of some of our most atomic components (buttons, controls, inputs, etc.) — the building blocks of our user interface.

There were five of us in that meeting and we spent probably fifteen minutes carefully considering the margin of all our new buttons. This means that HubSpot was paying the salaries of five designers to sit in a room and debate something as mundane as the space that surrounds text in a box.

But.

Not one of our front-end engineers, product designers, researchers, writers, or product illustrators has needed to think about the margin of a button since that decision was made two years ago.

#### That’s the beauty of building a design system. By deciding on a detail once, you free up your entire product development team to focus on solving actual customer problems.

We put all of our shiny new components, as well as some guidance on how to use them, into Sketch (our design tool of choice). This created an immediate explosion in our team’s productivity, while also (suddenly) keeping our design work closely aligned.

* * *

### Keeping teams aligned

Before this process started, we didn’t have one centralized place designers could go to understand which elements or components already existed, and no place where they could go if they wanted to use those elements or components in their own work. Designers and developers were trying their best to make good decisions about which components or patterns to use, but their main reference point was the existing product — which was decidedly inconsistent.

To combat inconsistencies (while speeding up our workflow) we built a robust style and component library for our new design language. This thirty-page Sketch file is organized by “component families” and houses every single element or component that comprises our products user interface. It’s updated weekly and is shepherded by a small, rotating task force of product designers and a dedicated front-end development team.

Need an icon? Come right this way.

![](https://cdn-images-1.medium.com/max/1000/1*YEXjbh_z3Q_kCpTRFugtOg.png)

Icons by [Joshua Mulvey](https://dribbble.com/joshua_mulvey), [Sue Yee](https://dribbble.com/suechews), and Chelsea Bathurst

Need data visualization? You got it.

![](https://cdn-images-1.medium.com/max/1000/0*pFLV3FlTdL74O0wY.png)

Data visualization by Drew Condon

Need a button? As you wish.

![](https://cdn-images-1.medium.com/max/1000/0*-GqDKYlgn7I1k8N7.png)

We have one primary button now. It’s orange. We like the color orange.

Need literally anything else? HubSpot Canvas has you covered.

![](https://cdn-images-1.medium.com/max/1000/0*V42eVXCKQy2waw_s.png)

Each component that exists in the Sketch kit also exists as a React component, making it easy to translate any mockup into a code the same way you assemble legos.

That means our designers don’t spend their days pushing pixels, drawing up spec sheets, or worrying about the responsiveness of their layouts. It means our developers don’t spend hours tweaking custom CSS (in fact, they write almost none at all).

#### It means our developers spend more time building. And it means our designers spend more time researching, ideating, and iterating, quickly and in high fidelity.

Here’s a peek at the average HubSpot designer’s workflow, using Sketch libraries and the Runner and Craft (by Invision) plugins.

* YouTube 视频链接：https://youtu.be/d4RuKwOwqnM

And to keep pace with the HubSpot product, our component library continues to grow and evolve. It’s maintained by a core group of designers and developers, but everyone on the product team contributes and weighs in. Whenever a new component is built or improved, it’s rolled back into the Sketch library and is accessible to all. This vastly reduces the number of rogue components or duplicate components.

* * *

### Building out the system

Our Sketch kit is just one piece of a larger design system. In order for it to be truly effective in the long term, we needed to create tools that worked just as effectively for developers. We learned that the best way to create consistent, functional, and delightful product experiences is to make the lives of those who build those experiences much easier.

[Read the next post](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-gain-widespread-adoption-of-your-design-system.md) to learn how documentation helped cultivate co-ownership between design and development, how we got widespread adoption of our design system, and what tools we’ve created for developers.

#### In closing:

People over pixels.  
Mail over tacos.  
Tacos are delicious.  
But people need their mail.

**Credits:**
Illustrations by [Sue Yee](https://dribbble.com/suechews)

**Resources we found helpful:**
[Atomic Design](http://atomicdesign.bradfrost.com/) by Brad Frost  
[Designing The Perfect Date And Time Picker](https://www.smashingmagazine.com/2017/07/designing-perfect-date-time-picker/) by Vitaly Friedman  
[Finding the Right Color Palettes for Data Visualizations](https://blog.graphiq.com/finding-the-right-color-palettes-for-data-visualizations-fcd4e707a283) by Samantha Zhang

_Originally published on the_ [_HubSpot Product Blog_](https://product.hubspot.com/blog/how-building-a-design-system-empowers-your-team-to-focus-on-people-not-pixels)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
