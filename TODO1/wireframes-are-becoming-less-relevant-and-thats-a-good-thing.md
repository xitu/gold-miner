> * 原文地址：[Wireframes are becoming less relevant — and that’s a good thing](https://medium.com/@seandexter1/wireframes-are-becoming-less-relevant-and-thats-a-good-thing-e66b30724a27)
> * 原文作者：[Sean Dexter](https://medium.com/@seandexter1)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/wireframes-are-becoming-less-relevant-and-thats-a-good-thing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/wireframes-are-becoming-less-relevant-and-thats-a-good-thing.md)
> * 译者：
> * 校对者：

# Wireframes are becoming less relevant — and that’s a good thing

![](https://cdn-images-1.medium.com/max/3160/1*-uTCxjdcMtjgKnKfUJqixA.png)

Over time I’ve found wireframes to be less and less useful, and I don’t think I’m alone. Because the term is somewhat loosely defined, it’s probably important to be specific. While there are many types of prototypes that examine levels of fidelity across various [dimensions](https://medium.com/in-the-hudl/prototype-fidelity-its-more-than-high-and-low-4dedb4cb1a0), I’d like to focus on the specific variant that most immediately comes to mind when hearing the word wireframe. It’s not a sketch or a fully realized mockup but rather the typical “middle” state —digital artifacts left intentionally unstyled and made to represent the “skeleton” of a full page in black and white. The prototypical wireframe attempts to be an accurate representation of layout and information architecture while **intentionally** undefinedavoiding high visual fidelity and sometimes high content fidelity as well.

![Behold the drab, spindly splendor of a wireframe in it’s natural habitat](https://cdn-images-1.medium.com/max/3360/0*0FGSCBVTYpA2Dt4z.png)

In discussions I’ve had and online I’ve been surprised to hear wireframes are still posited as an **essential** undefinedstep in the process of design. This attitude seems to be on the decline, but I’ve still heard everyone from early career designers to industry leading agencies insist on the necessity of a “wireframing phase”. The argument typically looks something like this:

>  ⦁ Wireframes focus attention on usability instead of aesthetics. They prevent stakeholders derailing meetings over irrelevant details like button color, and they allow user testing to focus on interactions instead of visuals.
>
>  ⦁ Wireframes are faster to create. They keep things conceptual and avoid the risk of getting too invested or attached to a particular direction.
>
>  ⦁ There’s also a somewhat separate argument (more enterprise-oriented) for wireframes as a tool for detailed documentation of interactions without the additional overhead of visual design.

That doesn’t mean that everyone actually makes wireframes, but when someone admits they don’t it’s often in a hushed tone and without a lot of eye contact. They would like to include them. It’s just that the constraints of their organization, stakeholders, or project prevent it from always being possible. But the mindset that they are essential, and many beliefs about their advantages may be misguided. While I won’t deny that wireframes are **ever** undefineduseful, nowadays they’re valuable only in limited circumstances that are narrowing by the day. There are a number of shifts in industry thinking and practices that are contributing to this change and are worth examining.

## **Shifting product development methodologies are changing how design gets done**

**Agile** undefinedproduct development encourages less linear process. Instead of starting with work on foundational elements across an entire product and then building layers on top of that foundation, the focus has shifted to smaller, more frequent delivery of fully realized “vertical” slices.

![](https://cdn-images-1.medium.com/max/2000/1*ZP-WJyxl2cwFlE_SifUCkA.png)

This also includes fully realized design, making it important to consider visuals, information architecture, and interactivity simultaneously. On an agile team, where your next iteration is coming in days or weeks rather than months or years, the extensive up front mapping phase that so often gives birth to wireframes is less likely to have a place.

[**Lean UX**](https://www.smashingmagazine.com/2011/03/lean-ux-getting-out-of-the-deliverables-business/) is an accompanying process shift that seems to be gaining traction as well. In Lean, heavy design artifacts are de-emphasized or omitted entirely in favor of directly collaborating on the product itself whenever possible. Lean also provides a rebuttal to the idea of wireframes as a documentation tool. It suggests that the layout of screens in an actual product can serve as their own documentation. Design artifacts you create can instead become more temporary items — to be put aside as soon as the information they contain exists in an accessible way within the actual product. Other relevant context might still be documented but only at or after the point of implementation.

### Usability and information architecture don’t exist in a vacuum

At the risk of stating the obvious, the visual presentation of elements in an interface affects how they’re perceived. A drop-down that resembles a form field may have it’s function misinterpreted. A menu header that doesn’t stand out from a menu item may be missed. Color and contrast play huge roles in directing visual attention. If you do usability testing on a wireframe the test is going to lose a lot of it’s value when you ultimately change how everything looks. You’re also probably going to have to make even more layout changes at that point to better accommodate your visuals. Users might get fixated on visual elements, but they’re not wrong to do so, and making everything grey-scale doesn’t necessarily reduce that risk. Issues with usability or information architecture are better exposed through comprehension questions and task completion tests than verbal comments anyways. Input on a concept can be achieved with any level of fidelity as long as you set expectations well and pay attention to how you solicit feedback.

### Wireframes are rarely effective for stakeholders

I get it. It can be incredibly frustrating to have a stakeholder get fixated on the color of a button or a piece of copy in a meeting. But by intentionally avoiding higher fidelity visuals and putting lorem ipsum everywhere are you really solving that problem? Or are you just deferring it? Do you like low fidelity because it makes things easier for people to understand and give input on? Or is the truth that it makes things **harder** for others to understand and that we **like** undefinedthat because it allows us to lord our expertise over others and avoid criticism? If a stakeholder isn’t interested in commenting on the IA and cares more about other things closer to their expertise, then why are you trying to fight that? You’re the expert on information architecture, not them, and any changes needed to layout should become clear through testing with users.

### It’s getting faster and easier to approximate high fidelity visuals

Years ago photoshop was the UI design king and everyone was in an arms race to see who could add the most detailed, photo-realistic texture to a given page. Back then there was a valid argument for the time saving benefits of wireframes, but today our tools are purpose built for UI design (Think Sketch, Adobe XD, or Figma) and make it significantly quicker and easier to manage and update styles globally. Changing layout “after” the visual style is “set” shouldn’t be any harder than changing it early. And for those at design-mature organizations the combination of design systems and component libraries supporting those systems pretty much remove any excuse. Even if you aren’t at at a mature organization you probably still have access to UI kits that match the UI frameworks available to your developers. It also helps that even the most visually complex aesthetics today are still relatively simple. If your button is just going to be a blue rectangle with round corners, then how much time are you really saving by intentionally making it grey?

### Does wireframing ever make sense?

It can—in the right situation. For example, you might create wireframes because:

⦁ You really do have a product that will be visually complex (like a mobile game) and need to work out the interaction independent of an unavoidably long art process. Even if this is the case you can still do your best to approximate style.

⦁ You’re using them as an exercise to help someone learn about information architecture in isolation (hopefully a one-off rather than a recurring part of real product development).

⦁ You want to map out or test information architecture but have a dependency on someone else for visual design (not ideal!) or are limited in some way by the visual capabilities of the tools available to you, or by your own skill-set.

⦁ You’re in a dated waterfall or agency environment and don’t have yet have much autonomy over your process. This isn’t great, but may be outside of your control.

I’m sure there are plenty of other possible scenarios and exceptions, but I would argue that they are likely infrequent for most designers operating today. If you think of traditional wireframes as a tactic to be employed only when really suited for the problem, then you’ll probably find that they can often be avoided — and that’s OK.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
