> * 原文地址：[Refactoring -- Not on the backlog!](http://ronjeffries.com/xprog/articles/refactoring-not-on-the-backlog/)
* 原文作者：[Ron Jeffries](http://ronjeffries.com/about.html)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Refactoring -- Not on the backlog!




There has recently been a lot of noise on the lists, and questions at conferences, about putting refactoring "stories" on the backlog. Even if "technical debt" has grown up, this is invariably an inferior idea. Here's why:

[![Ref01](http://ronjeffries.com/xprog/wp-content/uploads/Ref01-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref01.jpg)

When our project begins, the code is clean. The field is well-mowed, life is good, the world's our oyster. Everything is going to be just fine.

[![Ref02](http://ronjeffries.com/xprog/wp-content/uploads/Ref02-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref02.jpg)

We can build features smoothly and easily, though we always seem to take a few little twists and turns. Things look pretty clean, and besides, we're in a hurry. We don't notice anything going wrong and we press on rapidly.

[![Ref03](http://ronjeffries.com/xprog/wp-content/uploads/Ref03-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref03.jpg)

However, we're letting some brush build up in our nearly perfect field of code. Sometimes people call this "technical debt". It really isn't: it's really just not very good code. But it doesn't look too bad -- yet.

[![Ref04](http://ronjeffries.com/xprog/wp-content/uploads/Ref04-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref04.jpg)

As we build, however, we do have to detour around the thickets, or push through them. Generally we detour around.

[![Ref05](http://ronjeffries.com/xprog/wp-content/uploads/Ref05-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref05.jpg)

Inevitably, this slows us down a bit. In order to keep going rapidly, we are even less careful than before, and soon more weedy thickets have grown up.

[![Ref06](http://ronjeffries.com/xprog/wp-content/uploads/Ref06-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref06.jpg)

These new thickets, on top of the old ones, slow us down even more. We realize there's a problem but we're in too much of a hurry to do anything about it. We press harder to maintain our early velocity.

[![Ref07](http://ronjeffries.com/xprog/wp-content/uploads/Ref07-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref07.jpg)

Soon, it seems like half the code we have to work with is burdened with weeds, brush, undergrowth, obstacles of every kind. There might even be some old cans and dirty clothes in there somewhere. Maybe even some pits.

[![Ref08](http://ronjeffries.com/xprog/wp-content/uploads/Ref08-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref08.jpg)

Every trip through this messed-up field of code becomes a long trek of dodging through the brush, trying to avoid the pits that have been left behind. Inevitably, we fall into some of these and have to dig our way back out. We're going slower than ever before. Something has to give!

[![Ref09](http://ronjeffries.com/xprog/wp-content/uploads/Ref09-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref09.jpg)

The density of problems is very visible to us now, and we see that we can't just take a quick wipe at the field and do ourselves any good. We have a lot of refactoring to do to get back to a clean field. We are tempted to ask for time from our product owner to refactor. Often, that time is not granted: we're asking for time to fix what we screwed up in the past. Not likely anyone is going to cut us any slack on that.

[![Ref10](http://ronjeffries.com/xprog/wp-content/uploads/Ref10-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/Ref10.jpg)

If we do get the time, we won't get a very good result. We'll clean up what we see, as well as we can in the time available, which will never be enough. We took many weeks to get the code this bad, and we'll surely not get that many weeks to fix it.

This is not the way to go. A big refactoring session is hard to sell, and if sold, it returns less than we hoped, after a long delay. Not a good idea. What should we do?

[![RefA1](http://ronjeffries.com/xprog/wp-content/uploads/RefA1-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/RefA1.jpg)

Simples! We take the next feature that we are asked to build, and instead of detouring around all the weeds and bushes, we take the time to clear a path through some of them. Maybe we detour around others. We improve the code where we work, and ignore the code where we don't have to work. We get a nice clean path for some of our work. Odds are, we'll visit this place again: that's how software development works.

Maybe this feature takes a little bit longer. Often it doesn't, because the cleanup helps us even with the first feature that passes this way. And of course it'll help any others as well.

[![RefA2](http://ronjeffries.com/xprog/wp-content/uploads/RefA2-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/RefA2.jpg)

Rinse, repeat. With each new feature, we clean the code needed by that feature. We invest a little time more than we would if we continued to trash the field, but not much more -- and often less. Especially as the process goes on, we get more and more advantage from our cleanup, and things begin to go faster and faster.

[![RefA3](http://ronjeffries.com/xprog/wp-content/uploads/RefA3-1024x768.jpg)](http://ronjeffries.com/xprog/wp-content/uploads/RefA3.jpg)

Soon, often within the same Sprint where we begin to clean up, we find that a subsequent feature actually uses an area we just previously cleaned. We start to get a benefit from the incremental refactoring right away. Had we waited to do it in a big batch, we'd have put in more effort, delayed any benefits until later still, and likely wasted effort on places that don't provide benefit yet.

Work goes better, the code gets cleaner, and we deliver more features than we were able to before. Every one wins.

This is how you do it.



