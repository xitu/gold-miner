> * 原文地址：[iOS: Custom Modality](https://medium.com/@_kolodziejczyk/ios-custom-modality-a193c293d4d6#.b2d4uj1bt)
* 原文作者：[Kamil Kołodziejczyk](https://twitter.com/_kolodziejczyk)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

---

# iOS: Custom Modality

## Modals became so diverse that Apple’s HIG no longer cuts it. How to choose from all the custom options out there?

![](https://cdn-images-1.medium.com/max/2000/1*LPXhF6DNBVu8qz4P-sHZTA.png)

I’m thrilled when developers ask me about my choice of view types. I get to go on and on about the problem and my take on it. Interestingly, they are often surprised when they realise it had nothing to do with aesthetics.

[Modality](https://developer.apple.com/ios/human-interface-guidelines/interaction/modality/) in *iOS Human Interface Guidelines* is a great resource on that topic. That’s where I refer everyone to. But recently a friend told me, that it wasn’t enough for him.

Curious, I started checking out existing patterns to figure out how much more there is to it. He was right.

Which modal is the best choice then? I put together a list that’ll help you decide. Let’s go through it.

### Modal Types

Modals are a way to step out of the main flow of the app to make a decision or complete a task. They are the best tool when we need user’s uninterrupted attention.

> While *navigation controllers* promote content and its hierarchy, modals always exist in the context of a task.

There is a lot of modal types out there. They can take up the whole screen, or a part of it. They can be centered, fixed to the top or bottom. Sometimes they pop-up, sometimes slide from a side. *No wonder this is confusing.*

There’s a lot to break down here before you make a decision. My rule of thumb is to check if the view lets people **pick** a task or **do** a task.

### **Pickers**

This type of modal requires a decision before you can proceed. It could be a warning, dialog letting you specify what you want to do or which mode you want to select.

![](https://cdn-images-1.medium.com/max/800/1*llj4coNsU1kwsUIdBgeNAA.png)

- **Action sheet** is best for showing multiple actions. It’s a safe choice when you don’t have a lot of additional content to show besides the list.
- **Popover** helps if the context of the previous screen is important. Arrow does a great job explaining the relation between views.
- If you need to ask a question or get a permission from the user, it’s best to go with an **alert**.

Notice how none of those takes the whole screen? It’s because they are meant to be **fast to use**, you make a selection and you’re back on.

### **Doers**

Those modals are for getting stuff done. They are great for adding, editing—any complex task, basically.

**Fullscreen**

![](https://cdn-images-1.medium.com/max/800/1*xu_NhNyGVRNfMl2a0ztL_Q.png)

Definitely the most common type of modal. Covers the whole screen, requiring the full attention. Designed for complex tasks that might have multiple steps.

For fullscreen modals it’s generally agreed that:

- Main action (*Done*/*Save/Close*) is always in the top right corner
- Destructive action (*Cancel*) should be in the top left corner

**Part Screen**

Sometimes you have a feature that affects a part of the main view. In that case it‘s helpful to show it in the background, for context. People will instantly get what the modal does, then.

![](https://cdn-images-1.medium.com/max/800/1*i4OTZP-ESmIxde2sELE1SA.png)

When you pick the Part Screen view, there are two additional things to consider:

- **Pick an appropriate animation.** If a view is related to something at the top of the screen, let it slide from there. Making modals appear in a predictable way gives a better sense of place in the app.
- **Add a close gesture.** When modals appear with a certain animation, people often try to reverse it with gestures (*e.g. pinching out views that zoomed in)*. Supporting it will make the app feel more natural.

There is one more thing, and it’s tricky. Sometimes the feature might refer to a specific part of the previous view. This means that a **popover** can be used here as well.

---

Modals are a very effective tool. At first you might find it hard to get. But when you do it right your app will feel much faster and easier to use.

If you are still not sure which type of modal to choose I prepared a flowchart for a quick reference:

![](https://cdn-images-1.medium.com/max/1000/1*xmvX16jk_E5mxxYDPnAt9Q.png)

Hope this helps!
