> * 原文地址：[10 Tips and Shortcuts You Should Be Using Right Now in Xcode](https://medium.com/better-programming/10-tips-shortcuts-you-should-be-using-right-now-on-xcode-2e9e1b01511e)
> * 原文作者：[Mike Pesate](https://medium.com/@mpesate)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/10-tips-shortcuts-you-should-be-using-right-now-on-xcode.md](https://github.com/xitu/gold-miner/blob/master/article/2020/10-tips-shortcuts-you-should-be-using-right-now-on-xcode.md)
> * 译者：
> * 校对者：

# 10 Tips and Shortcuts You Should Be Using Right Now in Xcode

![Image source: Author](https://cdn-images-1.medium.com/max/2800/1*-xfCo4HM6bQ4kieiOHOTGQ.png)

Over the course of my career as an iOS developer, I’ve picked up a few habits that make working within [Xcode](https://developer.apple.com/xcode/resources/) much easier and faster. Most of them revolve around making good use of the great variety of shortcuts that are already in place but that we might not be aware of, or even have forgotten exist.

That is why I’ve gathered a few of my favourites to share with all of you.

Let’s begin!

## 1. Quick Auto-Indent

Whenever your code is misaligned, this shortcut will come in very handy.

> ### control + i / ⌃ + i

This will auto-indent the line where the cursor is. However, if you highlight a section of the code, or even the entire file, and then trigger that shortcut, it will fix the indentation for the entire file.

![Demo of ⌃ + i](https://cdn-images-1.medium.com/max/2000/1*WPbPnBUY-SUzLEE9AiDPkA.gif)

This helps keep the code organised instantly.

## 2. Edit All in Scope

Let’s say you found yourself in a situation where there’s an error in the name of a method or a variable and you have to fix it. Of course, the thought of having to go one by one is never crossing your mind because you already know that there’s a refactor option to rename it. But sometimes, Xcode can be a bit noncooperative when using refactor.

That’s when you can use the following shortcut to highlight all the uses of that variable within the file you are in.

> ### command + control + e / ⌘ + ⌃ + e

This will highlight all the uses and will let you change the name on the fly.

![Demo of ⌘ + ⌃ + e](https://cdn-images-1.medium.com/max/2000/1*-NKhqBvn7jLQk2nVOMbObA.gif)

## 3. Find Next Occurrence

Now let’s say that instead of editing the name of a variable within the entire scope, all you need is to locate the next use of it, or you want to rename it just within a function and not the entire class, or something like this. Well, there's a very similar shortcut for this.

> ### option + control + e / ⌥ + ⌃ + e

![Demo of ⌥ + ⌃ + e](https://cdn-images-1.medium.com/max/2000/1*T9oXtmeKZ9-fH5A-6tqtiA.gif)

When you highlight some value and hit those keys, Xcode will highlight just the next occurrence of that same string. Meaning that if some variables and/or functions share those highlighted characters, it will happen that the next use might not be what you expected.

## 4. Find Previous Occurrence

While the previous shortcut looks for the next occurrence, if you add one more key, then it will look for the previous ones.

> ### shift + option + control + e / ⇧ + ⌥ + ⌃ + e

![Demo of ⇧ + ⌥ + ⌃ + e](https://cdn-images-1.medium.com/max/2000/1*3KQPZ1zDdgAreauSlXKMgw.gif)

## 5. Move Line Up or Down

We might find ourselves doing a bit of reordering in the file. One way to do it could be doing the old and trusted cut-paste technique. However, if all we want is to move the code one line up or one line down, then this following shortcut will for sure be of help.

**Going up:**

> ### option + command + [ / ⌥ + ⌘ + [

**Going down:**

> ### option + command + ] / ⌥ + ⌘ + ]

![Demo of ⌥ + ⌘ + [ and ⌥ + ⌘ + ]](https://cdn-images-1.medium.com/max/2000/1*RejIpD9jKgE8HOtKD_JsCA.gif)

#### Extra tip! You can move multiple lines

If we use the same shortcut as before but highlight several lines, then those lines will move as a block.

![Demo of previous shortcut moving several lines as block](https://cdn-images-1.medium.com/max/2000/1*NNCsSDveGTd_O0TBLrHbjQ.gif)

## 6. Multiline Cursor (With the Mouse)

It has happened that sometimes you need to write the same thing in different parts of the file and you are annoyed at the fact that you have to write it once and copy-paste it a couple of times. Well, fret no more. You can write on multiple lines at once with this simple shortcut.

> ### shift + control + click / ⇧ + ⌃ + click

![Demo of ⇧ + ⌃ + click](https://cdn-images-1.medium.com/max/2000/1*SIOMgVWDQ477m5pjfSJiHw.gif)

## 7. Multiline Cursor (With the Keyboard)

This shortcut is basically the same as the one before but instead of using the mouse to select where to put the cursor, we can use the arrow keys to move up or down.

> ### shift + control + up or down /⇧ + ⌃ + ↑ or ↓

![](https://cdn-images-1.medium.com/max/2000/1*1vC7b4sj4U_rIGvbM94fMw.gif)

## 8. Quickly Create an Init With Several Parameters

One of my favourite uses of the shortcut above is to create an init faster than anything you’ve ever seen before.

![](https://cdn-images-1.medium.com/max/2000/1*8G_uBAI7tyIhejpOBqlMLw.gif)

By using the multi-cursor and several other familiar shortcuts, like copy-paste or highlight entire lines, we are able to quickly create the init. This is just one of the several uses for this powerful feature.

#### 8.1 Another way

There’s also an edit function that allows you to easily Generate Memberwise Initializer. You can find it by placing your cursor on the name of the class and then going to Editor > Refactor > Generate Memberwise Initializer.

However, this article is about shortcuts as well as tips. So, a tip would be to go to Preferences > Key Bindings and look for the command and add a combination of keys.

Here’s an example of how to do it:

![How to add a key binding](https://cdn-images-1.medium.com/max/2000/1*Rg1nkinvgq2hAfG4XLdWog.gif)

## 9. Go Back to Where the Cursor Is

Sometimes you might be working on a very large file. It happens that when we scroll up to check something, we might get lost and can’t find our way back to where we were. Well, with this shortcut, as long as we haven’t moved the cursor away, we can quickly jump back to it.

> ### option + command + L / ⌥ + ⌘ + L

![Demo of ⌥ + ⌘ + L](https://cdn-images-1.medium.com/max/2000/1*Cg9aSw5-Pcl75WJg859Wxw.gif)

## 10. Jump to Line

Related to the one before, if we know exactly at which line we want to be, then with this shortcut we can jump straight back to it.

> ### command + L / ⌘ + L

![Demo of ⌘ + L](https://cdn-images-1.medium.com/max/2000/1*N_UIb2ZCgPQQphMF5EIqjw.gif)

## Final Thoughts

That’s it. Those are ten shortcuts and tips I use on a daily basis to improve my speed when using Xcode. They come in very handy more often than not.

I hope you find them as useful as I do.

I’d love it if you let me know if you already knew about and use them or if any of these is new to you. Also, feel free to share any other shortcut you use that you find very useful and helpful.

#### Small disclaimer

Ideally, all the shortcuts I mentioned before work for you with the same key combinations as work for me. However, it could be that depending on the language your OS is set to, some of them might be slightly different.

You can always go to Xcode > Preferences… > Key Bindings and check the bindings for that specific case.

#### Extra tip! Quickly open preferences

> ### command + , / ⌘ + ,

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
