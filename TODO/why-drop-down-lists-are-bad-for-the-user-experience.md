>* 原文链接 : [Why drop-down lists are bad for the user experience.](https://medium.com/apegroup-texts/why-drop-down-lists-are-bad-for-the-user-experience-eeda5cbbd315#.p1yny0k15)
* 原文作者 : [Nils Sköld](https://medium.com/@NilsSkold)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:
![](https://cdn-images-1.medium.com/fit/t/1200/504/0*gY3MGKcuxGcVrBwJ.png)

# Why drop-down lists are bad for the user experience.

#### An industry standard that makes no sense at all.

Over the time working with user interfaces and usability, especially when I do user input forms, I have grown more and more aware of the fact that drop-down lists almost always are bad for the user experience.

A drop-down list is used when there are a number of options in which the user is only allowed to choose one. It works very much in the same fashion as radio buttons do. The reason to use it instead of radio buttons, is that it takes up much less space. But I have already stated that [we don’t need to save vertical space on the web anymore](https://medium.com/design-ux/11faa3abb6b7).

A drop-down list suffers from a huge problem, the user can’t see all the options they are presented with directly. Instead the need to click to see the options, then scan through the options, then click to make a selection. This is especially bad when in a form of mostly input fields, where many users only use the keyboard.

Here are some proposed alternatives that we should use instead of drop-down lists:

#### 1\. Replace drop-down menues with radio buttons

Instead of hiding the options for the user behind a click, it should be laid out in plain sight. The user can then see what options she has and make an informed decision. Be sure to design the radio buttons so that it’s clear than only one can be selected.

![](https://cdn-images-1.medium.com/max/800/0*Utv3Kmbo8HWtLiIl.png)

#### 2\. Two options should be a switch

If there are only two options, then a drop-down should be replaced with a switch, and the most common option should be prefilled. A great example of this is chosing gender in a sign-up form. With a drop down, everyone has to do 2 click: selecting the menu and then selecting the choice. In a switch, where female is pre-selected (51% of the population), then only 49% of the users have to do 1 click. That’s a HUGE difference. Here is an example of the bad way, from Yahoo.com:

![](http://ww3.sinaimg.cn/large/a490147fgw1f2w3s0eu0nj20m805a74f.jpg)

#### 3\. Many options should be a auto-complete field

It is widely accepted that the maximum number of items in a drop-down list should be around 15 items (some say 12, others say 16). If it’s more than that it easy gets confusing and a hard choice to make for the user. Scanning through a long list of items puts a lot of choice in the hands of the user. We should always strive towards taking as many options away from the user as possible. The less they have to think because we do the thinking in the background, the better.

A perfect example is the country selector. It is still standard to add a drop-down when choosing your country of residence, and this is absolutlely [ludacris](http://open.spotify.com/track/77dC7dKzMm65Y9jkJs0Ssd). Smashing Mag wrote a great article on this matter a year ago called [Redesigning the Country Selector](http://uxdesign.smashingmagazine.com/2011/11/10/redesigning-the-country-selector/). Always use a auto-complete field when there are many possible inputs, and let the system do the work, not the user.

![](http://ww1.sinaimg.cn/large/a490147fgw1f2w3sl6tm8j2077065glw.jpg)

So, are there any situations where a drop-down menu might be the best option? Well, yes there is. In any situation where you have more options than you can fit as radio buttons in your form, and where the users don’t know which options they are presented with. But this happens in very rare cases, and if it does it could be wise to re-think that typical field to make it easier for the user. For a great example of how forms should be designed, [head over to Typeform](http://www.typeform.com/). They do everything right.

For final words, I give you this, which is a bit off-topic but needs to be said: If the field is optional it shouldn’t be in the form. Take away everything that is unneccesary for the sign up process, or unneccesary for the user. That also means you don’t need to put out * for mandatory fields. (If by some chance you still need to have optional fields, mark them as optional, not the other way around).


