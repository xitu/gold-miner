
> * 原文地址：[Better Form Design: One Thing Per Page (Case Study)](https://www.smashingmagazine.com/2017/05/better-form-design-one-thing-per-page/)
> * 原文作者：[Adam Silver](https://www.smashingmagazine.com/author/adamsilver/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译文地址：[github.com/xitu/gold-miner/blob/master/TODO/better-form-design-one-thing-per-page.md](https://github.com/xitu/gold-miner/blob/master/TODO/better-form-design-one-thing-per-page.md)
> * 译者：
> * 校对者：

# Better Form Design: One Thing Per Page （实例研究）

In 2008, I worked on *Boots.com*. They wanted a single-page checkout with the trendiest of techniques from that era, including accordions, AJAX and client-side validation.
2008 年，我在 Boots.com 工作时，团队提出需求，要设计当时最流行的单页表单进行付款操作，主要技术有折叠选项卡，AJAX，客户端验证。

Each step (delivery address, delivery options and credit-card details) had an accordion panel. Each panel was submitted via AJAX. Upon successful submission, the panel collapsed and the next one opened, with a sliding transition.
表单提交的每一步（快递地址，快递方式，付款方式）都是一个折叠模块。每一个模块通过 AJAX 提交，提交成功后当前模块折叠，下一步所在的折叠模块滑动展开。

如下图所示：

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots1-780w-opt-1.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots1-large-opt-1.png)

Boots’ single-page checkout, using an accordion panel for each step.
Boots 网站的单页付款图，每一步都是一个折叠模块。([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots1-large-opt-1.png)

Users struggled to complete their orders. Errors were hard to fix because users had to scroll up and down. And the accordion panels were painful and distracting. Inevitably, the client asked us to make changes.
用户在提交订单时备受折磨，因为一旦填错内容就很难修改，用户需要上下来来回回滑动屏幕。折叠面板的设计简直太让人不爽了。果不其然，客户提出需求让我们修改。

We redesigned it so that each panel became its own page, removing the need for accordions and AJAX. However, we kept the client-side validation to avoid an unnecessary trip to the server.
我们重新设计了页面，将原来的每个折叠模块变成了独立的页面，删掉了折叠面板效果，也不再使用 AJAX，唯独保留了客户端验证，以省去不必要的服务器请求。

It looked a little like this:
更改后的设计如下：

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots2-780w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots2-large-opt.png)

Boots’ checkout: Each step became its own screen.
Boots 网站的多页付款图，每一步都是一个单独页面。([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/boots2-large-opt.png)

This version converted much better. Though I can’t remember the exact numbers, I do know that the client was happy.
这一版本变得好多了。我记不清确切的支持数据，但我记得客户当时很满意。

Six years later (2014), when I was at *Just Eat*, the same thing happened. We redesigned the single-page checkout flow so that each section became its own page. This time, I made a note of the numbers.
六年过去了（2014），当我就职于 Just Eat，同样的事情在不同地点又发生了一次。我们又重新设计了单页提交订单页面，将单页的多个模块修改成独立的页面。这次，我记录下了数据。

The result was an **extra 2 million orders a year**. Just to be clear, that’s orders, not revenue. The number is based on a percentage increase to conversion at checkout after releasing the new version for at least a week. The percentage was then converted to orders and multiplied by 52.
结果显示，**每年新增订单数量有两百万**。这里要强调一下，这个数字仅仅是订单量，还不是利润。该数据是版本更新一周内的订单统计结果，由结账时订单增加的百分比而得来。我们这个百分比转化成了订单数量，再乘以52周。

Here are some of the mobile-first designs we used:
下图是一些移动端设计：

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/justeat-780w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/justeat-large-opt.png)

Just Eat’s checkout split up into pages. We also had a design that further simplified the payment page: The user would first choose “Pay with cash” or “Pay with card,” which would then go to a page with the relevant form on it. Unfortunately, we never tested it.
Just Eat 的结账被分成了多个页面。我们还提出了一个设计方案使付款更简便：用户可以选择“现金付款”或者“银行卡付款”，这会使下一步走向相关页面。不巧的是，我们从未对此进行测试。([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/justeat-large-opt.png)

A couple of years later (2016), Robin Whittleton of GDS told me that putting each thing on a page of its own was a design pattern in its own right, known as “One Thing Per Page.” Apart from the resulting numbers, there is a strong rationale behind the pattern, which we’ll get to shortly.
几年过去了（2016），GDS 公司的 Robin Whittleton 告诉我说，把每一件事情放在属于自己一个页面里，这本事是一个设计模式，被称为“每一页，一件事”。除了数据支持，这个设计模式背后还有可靠的理论依据，我们马上会讲到。

Before we do that, though, let’s take a look at exactly what this pattern is.
不过在这之前，我们先来看看这个设计模式到底是什么样的。

### What Does “One Thing Per Page” Mean Exactly?
### “每一页，一件事”到底意味着什么？

One Thing Per Page is not necessarily about having one element or component on a page (although it could be). In all likeliness, you’ll still have, for example, a header and footer.
“每一页，一件事”，指的并不是在一个页面上只摆放一个元素或者组件（当然了，这样也可以）。至少，你也得给加个页眉页脚吧。

Similarly, it’s not about having a single form field on each page either (although, again, it could be).
同理，它也不是在单页上放置单个表格。（尽管，你非要这样做也不是不行）

This pattern is about **splitting up a complex process into multiple smaller pieces, and placing those smaller pieces on screens of their own**.
这种模式是将复杂繁琐的步骤分割成很多多个更小的部分，将这些更小的部分格子分布在只属于它们自己的屏幕。

For example, instead of placing the address form on the same page as the delivery options and payment forms, we would put it on a dedicated page.
例如，在设计快递地址表单时，我们将这个功能单独放置一页，而不是将它和快递方式，付款方式几个功能挤在同一个页面。

An address form has multiple fields, but it’s a single, discrete question that is being asked of the user. It makes sense to tackle this question on one screen.
一个快递地址表单有多个字段（城市，街道，邮政编码等），然而终究这些字段共同回答了同一个具体问题。因而在同一页面上解决这个问题是合理的。

Let’s consider why the pattern is so good.下面让我们考虑一下，究竟为什么这种模式这么好。

### Why Is It So Good? 为什么这种模式这么好嘞？

While this pattern often bears wonderful and delicious fruit (or orders and conversions, if you hate my analogies), it would be nice to understand the rationale behind it. 这个模式往往产出奇妙美味的果子（其实是订单啦，原谅我的比喻）能够理解其背后的运作原理，那就好办啦。

#### 1. It Reduces Cognitive Load 减少认知负荷

As Ryan Holiday describes in *The Obstacle Is The Way*:
正如 Ryan Holiday 在 *The Obstacle Is The Way* （最近在美国很火的鸡汤畅销书－－译者注）里所说的那样：

> Remember the first time you saw a complicated algebra equation? It was a jumble of symbols and unknowns. But when you stopped to break it down and isolate the parts, all that was left was the answer. 还记得你第一次见到复杂的代数方程么？有那么一大堆混淆的符号和未知数。但是当你静下心分解方程式，最终得到的，那就是答案。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/algebra-780w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/algebra-large-opt.png)

An equation broken down step by step is easier to solve. 解决方程式的简单办法就是，分步骤分解等式。([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/algebra-large-opt.png)

It’s the same for users trying to complete a form, or anything else for that matter. If there is less stuff on screen and only one choice to make, then friction is reduced to a minimum. Therefore, users stay on task.
同样的道理可以应用到用户到试图填好一份表单，或者任何其它事情。如果屏幕上内容较少，且用户只能做出一种选择，阻力将降到最小。因而用户就会专注停留在任务上。

#### 2. Handling Errors Is Easy 简化错误处理

When users fill out a small form, errors are caught and presented early. If there’s one thing to fix, then it becomes easy to fix, which reduces the chance of users giving up.
当用户填写一个较小的表格时，一旦犯错能够早发现早处理。如果只有一件事，修复错误会变得很容易，这降低了用户放弃填写表格的几率。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/errors-780w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/errors-large-opt.png)

Even with several errors, Kidly’s address form is easy to fix.即使有好几个错误发生，Kidly 的地址表单修改起来仍很简便。([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/errors-large-opt.png)

#### 3. Pages Load Faster 加快页面加载

If pages are small by design, they will load faster. Faster pages reduce the risk of users leaving, and they build trust in the service. 当页面设计上遵从“小”的原则，页面加载速度会更快。快速加载的页面降低了用户等不及而离开的风险，在服务上得到了用户的信任。

#### 4. Tracking Behavior Is Easier 简化行为追踪

The more there is on a page, the harder it is to determine why a user has left the page. Don’t get me wrong: The ability to analyze a page shouldn’t drive design, but it is a nice byproduct.
页面内容越多，越难分析用户为什么会离开页面。这里要弄清楚：用户行为分析并不应该作为页面设计的主导，但它作为副产品还是不错的。

#### 5. Tracking Progress and Returning to Previous Steps Is Easier 简化进度查看和返回上一步操作

If a user submits information frequently, we can save it in a more granular fashion. If a user drops off, we can send them an email, prompting them to complete their order, for example.
如果用户频繁提交信息，我们可以将信息以更细化的方式保存起来。比如当有用户在中途放弃订单，我们可以发邮件以推动他们完成订单。

#### 6. Scrolling Is Reduced or Eliminated 减少滑动操作

Don’t get me wrong: [Scrolling isn’t a big deal](http://uxmyths.com/post/654047943/myth-people-dont-scroll) — users expect web pages to work that way. But if pages are small, users won’t have to scroll. And the call to action is more likely to appear above the fold, which reinforces the requirements, making it easier to proceed. 不要搞错了噢，[滑动操作也没什么大不了](http://uxmyths.com/post/654047943/myth-people-dont-scroll) —用户期望网页以滑动的方式运作。但是一旦页面变小了，用户不必再滑动屏幕。而且推广召集活动一般都在折叠面板最顶端，加强了需求，也简化了操作流程。

#### 7. Branching Is Easier 分支操作更便捷

Sometimes we’ll send users down a different path based on a previous answer. A simple example would be two dropdown menus; what the user chooses in the first will affect the values shown in the second. 有时候我们我们会根据用户上一步的操作而决定下一步进入不同的分支操作。举个简单的例子，假设我们有两个下拉选择菜单。用户在第二个菜单看到的选项取决于他在第一个菜单的选择。

One Thing Per Page makes this simple: The user makes a choice and submits, and the server works out what the user sees next — easy and inclusive by default. 每一页只做一件事使其更简单：当用户在第一个下拉菜单选好并点击提交，服务器相应并返回给用户第二个菜单的内容，简单易行。

We could use JavaScript. But it’s more complicated to build it and ensure that the UI is accessible. When [JavaScript fails](https://kryogenix.org/code/browser/everyonehasjs.html), the user might suffer a broken experience. And loading the page with all of the permutations and options could add significant page weight.
我们可以使用 JavaScript，但其实构建界面，并保证用户界面可以访问还是很复杂的。倘若 JavaScript 

Alternatively, we could use AJAX, but this doesn’t free us from having to render new (parts of) screens. More crucially, it doesn’t negate the server-side roundtrip.

That’s not all. We’d need to send more code to send an AJAX request, to handle errors and to show a loading indicator. Once again, this makes the page slower to load.

Custom loading indicators are problematic because they aren’t accurate, unlike the browser’s native implementation. And they aren’t familiar to the user — that is, they are specific to the website showing them. However, familiarity is a UX convention that we should break only if we really have to.

Also, having two or more fields that are dynamically updated on one page depends on the user interacting with the fields **in order**. We could enable and disable or show and hide fields, but this is more complicated.

Lastly, a user could make a change that requires a subsequent panel to disappear or be replaced by a different panel, which is confusing.

#### 8. It’s Easier for Screen-Reader Users

If there is less on a page, then screen readers don’t have to wade through a lot of superfluous secondary information. Users can navigate to the first heading and start interacting with the form more quickly.

#### 9. Amending Details Is Easier

Imagine someone is about to confirm their order. Crucially, they spot a mistake with their payment details. Going back to a dedicated page is far easier than going to a section *within* a page.

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/04/kidly-780w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/04/kidly-large-opt.png)

Clicking “Edit” takes the user to the payment page, with a dedicated title and related form fields. ([View large version](https://www.smashingmagazine.com/wp-content/uploads/2017/04/kidly-large-opt.png)

Being taken halfway down the page is disorienting. Remember that the user clicked a link to perform a particular action — having other things on the page would be distracting.

It’s also potentially more work. For example, if you want to show and hide panels within the same page, you’d need extra logic to handle it.

With One Thing Per Page, these problems fade away.

#### 10. Users Get Control of Their Data Allowance

Users cannot half download a page. It’s all or nothing. Smaller pages save user’s data. If they want more information, they can click a link, getting the ability to **choose**. [Users don’t mind clicking](http://uxmyths.com/post/654026581/myth-all-pages-should-be-accessible-in-3-clicks), as long as each step brings them closer to their goal.

#### 11. It Solves Performance Problems

If everything is one gigantic thing — the extreme of which is a single-page application — then figuring out performance problems is hard. Is it a runtime issue? A memory leak? An AJAX call?

It’s easy to think that AJAX improves the experience, but adding more code rarely leads to a faster experience.

Having complexity on the client obscures the root cause of problems on the server. But if a page has one thing, then there’s little chance of performance issues. And if there is an issue, then finding it will be easier.

#### 12. It Adds a Sense of Progression

Because the user is constantly moving to the next step, there is a sense of progression, which gives the user a positive feeling as they fill out the form.

#### 13. It Reduces the Risk of Losing Information

A long form takes longer to complete. If it takes too long, then a page timeout may cause the information to be lost, leading to tremendous frustration.

Alternatively, the computer might freeze, which is the case for Daniel, the lead character in *I, Daniel Blake*. With declining health and having never used a computer before, he suffers from a frozen computer and lost data. In the end, he gives up.

#### 14. Second-Time Experiences Are Faster

If, for example, we store the user’s address and payment details, we can skip these pages and take them straight to the “check and confirm” page. This reduces friction and increases conversion.

#### 15. It Complements Mobile-First Design

Mobile-first design encourages us to design what is truly essential for small screens. One Thing Per Page follows the same approach.

#### 16. The Design Process Is Easier

When we’re designing a complex flow, breaking it down into atomic screens and components makes it easier to understand the problem.

It’s easy to swap screens to change the order. And analyzing problem areas is easier when, like the user, we’re looking at one thing at a time.

This reduces the design effort — which is a nice byproduct of a pattern that benefits users so greatly.

### Is This Pattern Suitable In All Situations?

Not always. Caroline Jarrett, who first wrote about [One Thing Per Page](https://designnotes.blog.gov.uk/2015/07/03/one-thing-per-page/) in 2015, makes this quite clear. She explains that user research “will quickly show you that some questions will be best grouped into a longer page.”

However, conversely, she also goes onto explain that “questions that naturally ‘go together’ from the point of view of designers… don’t need to be on the same page to work for users.”

She provides an enlightening example when, for GOV.UK Verify, they tested putting “Create a username” on one page and “Create a password” on the next.

Like most designers, Caroline thought that putting these two form fields on separate pages would be overkill. In reality, users weren’t bothered by this at all.

The key point here is to at least start with One Thing Per Page and then, through research, find out whether grouping fields together would improve the user experience.

That is not to say you’ll always end up combining screens together — in my experience, the best results come from splitting things apart, period. I’d love to hear about your own experience, though.

### Summary

This inconspicuous and humble UX pattern is flexible, performant and inclusive by design. It truly embraces the web, making things easy for high- and low-confidence users.

Having a lot (or everything) on one page might give the illusion of simplicity, but like algebraic equations, they are difficult to deal with unless they are broken down.

If we consider a task as a transaction that the user wants to complete, breaking it down into multiple steps makes sense. It’s as if we’re using the very building blocks of the web as a form of progressive disclosure. And the metaphor behind pages provides a subconscious sense of moving forward.

I’ve not come across another design pattern that has as many benefits as this one. This is one of those times when simple is just that: simple.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
