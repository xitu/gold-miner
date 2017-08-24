
  > * 原文地址：[CSS Hex Colors Demystified](https://medium.com/dev-channel/css-hex-colors-demystified-51c712179982)
  > * 原文作者：[Dave Gash](https://medium.com/@davidagash)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/css-hex-colors-demystified.md](https://github.com/xitu/gold-miner/blob/master/TODO/css-hex-colors-demystified.md)
  > * 译者：
  > * 校对者：

  # CSS Hex Colors Demystified

  ![](https://cdn-images-1.medium.com/max/1600/1*-_xWZmET00Mx_BM9aZou-g.jpeg)

### Introduction

As a long-time presenter at tech pubs conferences around the world, I’ve had the opportunity to chat with many technical communicators, the folks I call “*technical* technical writers”, about their jobs. Every writer has their own particular likes and dislikes, pet features and problematic ones — “pros and woes”, as one New Zealander put it — about the more technical aspects of technical communication.

One theme that comes up repeatedly is CSS colors — specifically their hex (hexadecimal) representation in CSS property values. You’ve seen them: weird-looking strings of characters scattered through your CSS such as `#FF0080`, `#9AC0B3`, and `#B5CBE8`. I mean, `#WTF`, amirite?

While most tech writers encounter hex color coding at some point, it’s a fuzzy subject because, usually, no one has ever taken the time to explain it to them. Most comments I hear tend to run along these lines:

- I have to deal with CSS hex color coding all the time, but I don’t really *get* it.
- I actually know some hex codes and which colors they represent, but I don’t know *why*.
- I can sometimes get the color I want by fiddling with the hex, but I don’t understand *how *that works.
- Is it wrong to use a color with a rude-sounding hex code like `#BADA55`?

Okay, I made up that last one, but the answer is no. No, it isn’t. If you’re into chartreuse, go for it!

### Colors in CSS

Colors are ubiquitous in CSS; they’re used as property values for foregrounds, backgrounds, shadows, tables, borders, links, shading, and much more. Because of the importance of colors to CSS, we need a common, standardized way to refer to them so that all browsers everywhere can process color requests identically, and so that users can see the colors the page authors intended.

There are several ways to specify colors in CSS, and we’ll take a look at some of them in a bit. But this article focuses on hex notation because hexadecimal color codes are specific, consistent, and what developers call “elegant” (the rest of us just say “cool”). But, while they are certainly all those things, they aren’t exactly intuitive — yet.

### Oh No, Physics!

Let’s begin with the single underlying premise of all color: that white light is actually made up of all the colors of the rainbow. Remember *Roy G. Biv*? What we see as white light is just the combination of the visible spectrum of Red, Orange, Yellow, Green, Blue, Indigo, and Violet light mixed together. And if you don’t believe me, just ask David Gilmour.

![](https://cdn-images-1.medium.com/max/1600/1*apZ_o9Z6v6tf4uBXzphgaw.png)

If you’re too young to get that joke, tough.

#### Pigments

To see how colors work, let’s first review the physics of light in pigments, something we’ve all understood since childhood. The primary colors in pigments are blue, yellow, and red, just like in your first box of crayons.

![](https://cdn-images-1.medium.com/max/1600/1*WgrNsoQrXQ2HVtEb2JE24Q.png)

Pigment primary colors

And one of the first things you learned about pigments was that you could combine primary colors to make secondary colors. For example, you discovered that you could color blue and red on top of each other when that snot-nosed brat Susie stole your purple crayon (but I’m not bitter!). Likewise with the other primaries; you quickly found you could color red and yellow, and yellow and blue, together to get orange and green — brand-new secondary colors.

![](https://cdn-images-1.medium.com/max/1600/1*RBfoOD8CS_lFMB_oIyG_1g.png)

Pigment secondary colors

Take that, Susie.

What you didn’t know at the time is the reason it works that way: pigments are *subtractive*. That is, they absorb, or subtract, different wavelengths of the light that hits them, and reflect back only what they don’t subtract.

> For those of you partial to thought experiments, this means that an object that appears to be a single color is really, truly, in actual fact, not that color at all. Because the object absorbs all light wavelengths but the one it’s reflecting back (the one we see), it’s actually all colors at once; that is, it’s *every color except the one it appears to be*. In other words, an orange isn’t. Seriously.

Without knowing the physics of it, we all understood early on that putting two or more colors together gave us other colors, and the more colors we added, the more new colors we made, each secondary color becoming darker than either of its primaries. We eventually learned that if we mixed all the colors together, we ended up with black, or something pretty close to it. We now know that that’s because as more and more pigments were added, more and more light was absorbed, or subtracted, from the original white light. So, it becomes obvious that **less light = darker colors**. Tip: Remember that factoid; it will be important later.

![](https://cdn-images-1.medium.com/max/1600/1*OXCcIybMtfaIoXTtIZSDLQ.png)

Dark dark dark really dark gray is about as close to black as we’re going to get
The next thing we discovered about mixing pigments was that, beyond which colors were mixed, the *levels* of the mixed colors affected the result. That is, for a blue-yellow mix, more yellow yields a lightish “spring green”, while more blue yields a darkish “forest green”. So it became clear that the mix ratio is quite important too; so far, so good.

#### Optics

Okay, have you got all that? Good! Now forget it, because all computer device screens are based on light, not pigments. I just needed to walk you through pigments to prepare you for optics; you’ll thank me later. As it turns out, the physics of optics is the same, only different. (No, really.)

Let’s begin as we did with pigments with the primary colors, which in optics are red, green, and blue.

![](https://cdn-images-1.medium.com/max/1600/1*0L0ixGTpbm1X20Y84cDcUQ.png)

Stay with me here; it might get a tad gnarly
Just like pigments, we can mix primary colors to get secondary colors. And, just like pigments, the secondary mixes make sense — mostly. Blue light and red light make a purple-y color called magenta; okay, I’ll buy that. Green light and blue light make a teal-y color called cyan; all right, fair enough. And red light and green light make… wait, *what?!?*

![](https://cdn-images-1.medium.com/max/1600/1*2Hx5hxBCeG81iq6Z0bIb-w.png)

Mind officially blown
Yeah, that last one is a kick in the head, and anything but intuitive. But that’s how optics works: red light plus green light makes yellow light.

> Why? Well, it just does, okay? That’s how light works. You got a problem with that, talk to one of [these guys](https://en.wikipedia.org/wiki/List_of_light_deities) and tell Heimdallr I said wazzup.

The reason for this is that optics are *additive*, the opposite of pigments. The more different wavelengths of light we combine, the more new colors are created. And the more light we add, the brighter the colors we create, until — when all colors are mixed at their maximum levels — we end up with white light. And it’s easy to see that each secondary color we create is brighter than either of its primaries. Thus, the corollary to our earlier pigments discovery, that less light = darker colors, is that **more light = brighter colors**. (The “duh” is silent.)

![](https://cdn-images-1.medium.com/max/1600/1*BC1eJ6IwEa4ow_t2wDHPYQ.png)

So light light light really light everything is just white
### Back to CSS

In CSS, then, to achieve a desired color result, we need a way to specify not only which primary colors to mix, but also what levels of each color to let into the mix. That is, we need to specify exactly how much red, green, and blue light to add together to get a specific color. Hey, it’s physics!

In all of Computerdom, the minimum-to-maximum range for a given value is generally 0–255. There is of course a nerdy technical reason for that but, right now, you don’t care. Really, you don’t. That explanation, how binary works, is for another article entirely. For now, just trust me that our range for each color is a minimum of 0 and a maximum of 255. Thanks.

#### Ways to Specify Colors

Although I’m promoting the hexadecimal color scheme in this article, I can’t ignore the fact that it is by no means the only way to specify CSS colors. Before proceeding, then, let’s quickly look at three other methods.

> **Note:** If you aren’t interested in this part, feel free to jump right ahead to the next main heading, **A Quick Review**. Seriously, you won’t miss anything significant about hexadecimal. I include this brief digression mostly for completeness and, in no small way, to avoid a deluge of “But but but…!” comments later. You know who you are.

**Color Names**

One easy way to refer to colors is by name. All modern browsers understand a wide range of color names that can be used as CSS property values. Many of the names make perfect sense, like black, white, red, green, blue, yellow, purple, orange, and so on. Some are more obtuse but semi-obvious, like aquamarine, blueviolet, cornsilk, and khaki. And then some are just ridiculous, like aliceblue, lavenderblush, burlywood, and gainsboro.

The problem is, none of them are very flexible, not even the common ones; there’s only one purple color, and that’s “purple”; if you want a specific, particular, purple-y, lavender-y, mauve-y color, “purple” ain’t it. Oh, sure, there’s “mediumorchid” and “plum” and “thistle”, but those are probably not exactly what you want, and how would you even know if they were? Also, as we just noted, the more exotic the name, the less intuitive the color. Anyone want to guess what color “peru” is? Didn’t think so.

For example, here’s yellow text on a red background using color names:

`span.hilite { color: yellow; background-color: red; }`

**RGB**

Another method is called RGB, for… well, I expect you can work that one out. This method sticks with plain old numbers and fairly cleanly specifies each color’s level in either decimal notation or percentages. This method, however, suffers from verbosity and complexity; what with the extra parentheses, commas, and/or percentage signs, it’s dead easy to typo an RGB color right into something unwanted — or even invalid.

Here’s yellow text on a red background using RGB:

`span.hilite { color: rgb(255, 255, 0); background-color: rgb(255, 0, 0); }`

or

`span.hilite { color: rgb(100%, 100%, 0%); background-color: rgb(100%, 0%, 0%); }`

**HSL**

Just to further muddy the water, yet another method is called HSL, for Hue, Saturation, and Lightness. This method — which has various sub-methods I’m not even going to touch — uses one decimal value and two percentage values. The hue decimal value represents a color on the color wheel from 0 to 360, where 0 is red, 120 is green, and 240 is blue. The saturation percentage represents the quantity of light, where 0% is no color and 100% is full color. The lightness percentage then modifies the brightness, or luminosity, of the color, where 0% is black and 100% is white. I’ve always found this method a bit confusing and, in my experience, seldom used by developers.

And here’s yellow text on a red background using HSL:

`span.hilite { color: hsl(60, 100%, 50%); background-color: hsl(0, 100%, 50%) }`

**Hex**

Hexidecimal notation, on the other hand, is generally the most popular CSS color designation method. It is specific, consistent, compact, and precise. Hex uses three two-character codes to specify RGB values in the range 00-FF, where 00 is no color and FF is full color.

Finally, here’s yellow text on a red background using hex:

`span.hilite { color: #FFFF00; background-color: #FF0000; }`

Okay, enough of that. Movin’ on!

### A Quick Review

I know you think I’m lying, but hex really is easier than you think. Hex color codes are based on hexadecimal (base 16) arithmetic. To understand how hex works, you just have to understand how decimal (base 10) works. Oh, wait, you already do! Excellent; let’s review.

> Don’t skip this part, okay? I know you know *how *decimal works; I want you to think about *why* it works.

The decimal system has ten single-character digits, 0 through 9. You can repeatedly increment a digit to get the next digit, but eventually you’ll run out of digits. When that happens, you put a zero in that place and increment the next place to its left. Let’s think about what that really means in plain old words.

![](https://cdn-images-1.medium.com/max/1600/1*-QBjj9bsURSYsSlaSYKUbg.png)

Or “ten

The important bit here is that the place names denote the value of the digits in them, and each place name represents one more than the maximum number that can be represented in the place to its right. In decimal, the right-most place is called “ones” and the second-from-right place is called “tens”. The digit “9” means “nine ones”, and if we add “1” (“one ones”) to it, we run out of digits, so we put a 0 in the ones place and a 1 in the tens place, yielding the digit pair 10.

Thus, the decimal value of a 1 followed by a 0 — what we call “ten” — really means “one ten and no ones”. Likewise, decimal 26 means “two tens and six ones”, decimal 33 means “three tens and three ones”, and decimal 42 means “four tens and two ones” (as well as being the answer to the [Ultimate Question](https://en.wikipedia.org/wiki/Phrases_from_The_Hitchhiker%27s_Guide_to_the_Galaxy#Answer_to_the_Ultimate_Question_of_Life.2C_the_Universe.2C_and_Everything_.2842.29), of course).

The great thing about hex is that it works *exactly* like decimal. **Exactly!** No kidding, no exaggerating, no alternative fact-ing. Hex arithmetic works exactly like decimal arithmetic; it just has sixteen single-character digits instead of ten.

![](https://cdn-images-1.medium.com/max/1600/1*jhKg0v_TTUDXht8y4VQD9g.png)

Digits A-F are pronounced, well, like A-F
That’s right, the decimal values 10 through 15 are represented by the letters A through F. Sure, the computer wizards of ye olden tymes could have come up with six completely new characters for those digits, but (a) we would all have to learn them, (b) how are you supposed to type

![](https://cdn-images-1.medium.com/max/1600/1*f4G4sDddeNFIEkfcGOJffw.png)

on a keyboard, and (c) what is that thing, even?!? So they just stuck with letters as the path of least shenanigans.

In other words, the decimal value 10 is represented in hex by the single digit A, which just means “ten ones”. The hex digit B means “eleven ones”, and so on up to F, meaning “fifteen ones”.

Again, just like in decimal, the place names denote the value of the digits in them, and each place name represents one more than the maximum number that can be represented in the place to its right. The right-most place is still called “ones” and, because we can now count up to F (“fifteen ones”) in that place, the second-from-right place is called “sixteens”.

![](https://cdn-images-1.medium.com/max/1600/1*hz81_Qc6tCAhsrrSJ8fopA.png)

Hex addition: 9 + 1 = A
The digit “9” still means “nine ones”, but now if we add “1” (“one ones”) to it, we haven’t yet run out of digits, so we can put an A (“ten ones”) in the ones place and leave the sixteens place alone — we don’t need it yet because we still have some digits left.

And, just like in decimal, you can repeatedly increment a digit to get the next digit, but you’ll **still** eventually run out of digits. When that happens, you put a zero in that place and increment the next place to its left. *Just. Like. In. Decimal.* Again, let’s think about what that really means in words.

![](https://cdn-images-1.medium.com/max/1600/1*VstVral1WUbSHywS5kBYtg.png)

Hex addition: F + 1 = 10
So, that hex value of 10 (say “one zero”) is not ten, it’s sixteen, because it means “one sixteen and no ones”. And yet again, just like in decimal, any two-digit hex number can be read and understood the same way. And that means that if we keep counting and incrementing and flopping over to the sixteens place when we get to “F” — stand back, here it comes — *we can represent any decimal number from 0 to 255 with exactly two hex digits from 00 to FF*.

For example, in the chart below, hex 14 (say “one four”) means twenty, because it is literally one sixteen (16) and four ones (4), and 16 + 4 = 20 in decimal. Hex A5 means one hundred sixty-five, because it is ten (A) sixteens (160) and five ones (5). Finally, it’s important to note the lines in red, because they are the end- and mid-points of the range: hex 00 (say “zero zero”) is zero, hex FF is two hundred fifty-five (fifteen sixteens, or 240, plus 15 ones = 255), and hex 80 (“eight zero”) is one hundred twenty-eight (eight sixteens, or 128, plus 0 ones) — exactly halfway between 00 and FF. Tip: Remember that “80” halfway point; we’ll use it heavily in a minute.

![](https://cdn-images-1.medium.com/max/1600/1*UMYMc30_T_tX6G-KAB4H-A.png)

Hex counting, 00 to FF
> As The Eagles sang, “Are ya with me so far?”

Let’s take a breath here, because this counting scheme is the crux of the whole thing, and it’s critical to understanding hex colors. But please don’t make it harder than it is; I’m not dumbing it down or making false equivalences: hex really, *really*, **really** works exactly like decimal. The concepts are truly identical; you just have more available digits in hex before you have to roll over to the next place.

Be sure you understand this concept before you go on. Here are some more hex-to-decimal conversion examples.

- 1F = one sixteen and fifteen ones = 16 + 15 = 31 decimal
- 2B = two sixteens and eleven ones = 32 + 11 = 43 decimal
- 41 = four sixteens and one one = 64 + 1 = 65 decimal
- AA = ten sixteens and ten ones = 160 + 10 = 170 decimal
- F0 = fifteen sixteens and no ones = 240 + 0 = 240 decimal

See, it’s easy once you get the hang of it. It’s only math. With letters.

And so three of those two-digit hex numbers, from 00 (0) to FF (255), are going to represent the levels of red, blue, and green in our CSS color property values.

### Intuitive-icity-ish-ness

Now that we understand how to mix the primary colors and how to specify each level, it should be clear that we can create any color code in exactly six hex digits, from `#000000` to `#FFFFFF`— two for red, two for green, and two for blue — and always in that order: RGB.

> How many different colors can we code in six hex digits? Well, the hex number FFFFFF is decimal 16,777,216, so the correct answer is “a buttload”.

When we specify hex color codes in CSS, we precede them with “#”, called a *pound sign* or *hash mark* (not *hashtag*, millennials). That’s how CSS knows that what follows is a hex color code. Also, letter case doesn’t matter to CSS; `#A94CB3` is identical to `#a94cb3`.

Knowing what we know now, some color codes should start to become obvious, like black, white, and the three primaries.

![](https://cdn-images-1.medium.com/max/1600/1*TZK3FiDgZlRFqeJNNK8Z6g.png)

Hex black, white, and primary colors
Easy-peasy, right? It’s the physics of light: in those color codes, each RGB component is either “none” (00) or “all” (ff). So, for example, `#000000` can’t be anything but black. It just can’t. Look at all those zeros; there’s no red, no green, and no blue — no light whatsoever — and what is “no light” if not black? (And if you say “dark”, you’re dismissed.) Likewise, `#ff0000` cannot possibly be anything but bright red. That code specifies full red, no green, and no blue. Nothing but red light. Can’t be anything else but red. Not possible. Has to be red. Just red. RED.

And, believe it or not, now we’re on the downhill slope, because once you grasp that idea, other colors start to become intuitive as well. You should now start seeing hex codes as the colors they simply **have** to be.

Consider the three secondaries, magenta (full red, no green, full blue), cyan (no red, full green, full blue), and yellow (the admittedly unintuitive full red, full green, no blue). The hex codes that create those colors should now be obvious.

![](https://cdn-images-1.medium.com/max/1600/1*2ttPfJOfPNuAr5ch49wqjw.png)

Hex secondary colors
Okay. So far we’re still working with just “none” or “all” values. But recall that hex 80 (“eight zero”) is halfway between 00 and FF, so we should now be able to use that value to easily construct some color codes with half the light — that is, codes that create darker shades of both the primary and secondary colors. Hmm, I wonder what those would look like? Probably like this.

![](https://cdn-images-1.medium.com/max/1600/1*vWe3elGJZAK4EImaBPGEmA.png)

Hex primary and secondary half-light shades
What we’re doing here by changing the values of the three components is merely *varying the amount of light* we put into the code for each color, from none/00 to half/80 to full/FF, and this fact leads us to a little epiphany. Okay, a great big huge massive ginormous epiphany. Two, actually.

**Higher numbers = more light = closer to white = brighter colors.**

**Lower numbers = less light = closer to black = darker colors.**

Those are really important; please read them again, but in Morgan Freeman’s voice.

### Pop Quiz

Let’s try some color code questions. C’mon, it’ll be fun! Just answer these in plain English (not hex codes), then scroll down a bit to reveal the answers.

**Question 1.** If `#FF00FF` is bright magenta and `#800080` is dark magenta, what’s `#B000B0`?

**Question 2.** If `#00FFFF` is bright cyan and `#008080` is dark cyan (also called teal), what is `#004040`?

**Question 3.** If `#000000` is black and `#FFFFFF` is white, what are the colors in the range `#010101` through `#323232`?

…scroll down

…

…lower

…

…keep going

…

…a little more

…

…almost there

…

**Answer 1:**`#B000B0` is a medium-bright magenta-y color that’s somewhere between bright and dark magenta, because B0 is less than FF but more than 80.

**Answer 2:**`#004040` is a quite dark teal-y color, because 40 is less than both FF and 80.

**Answer 3:**`#010101` through `#323232` is *fifty shades of gray!* (oh, don’t roll your eyes, I know you laughed), because hex 32 — three sixteens (48) plus 2 ones (2) = decimal 50.

And actually, that last question leads us to one more, slightly less huge massive and ginormous but still quite important, epiphany.

**Whenever all three component values are the same, no matter what the value is, the color is some shade of gray.**

That’s right, `#232323`, `#a9a9a9`, `#4b4b4b`, `#2f2f2f`, `#959595`, `#dadada`, and every other combo with identical RGB values is some shade of gray — some darker, some lighter. And, because hex 80 is midway between 00 and FF, it means that `#808080` is the most medium of medium grays. And yes, “gray” technically includes black and white, `#000000` and `#ffffff`; that means, for those of you keeping track, there are really 256 shades of gray. Bite on that, E. L. James.

### Practical Examples

Let’s close up with some realistic CSS color coding samples. Based on your new knowledge of colors and hex, you should be able to see why these hex color codes make the colors they do. Look at the codes in these CSS rules and think about what color levels the three hex pairs represent, and they should jump out at you.

Example 1: Here, the body foreground (text) color is set to dark blue and the background color is a medium-light gray.

![](https://cdn-images-1.medium.com/max/1600/1*mDaO6vXwz14YzMl3YCKfcQ.png)
Example 1
Example 2: Here, any element with a class of “warning” displays in red text on a yellow background. (Note that the page background is still gray from the rule above, assuming all this is in the same page.)

![](https://cdn-images-1.medium.com/max/1600/1*PoLdJEGTrqmVIGUxxNtmpw.png)
Example 2
Example 3: Here, normal links display in teal text, while hovered links display in white text on a teal background. (Still on the gray page background.)

![](https://cdn-images-1.medium.com/max/1600/1*o8TIPpnBOqvqgbOLTKBQHQ.png)

Example 3
Example 4: And finally, this blockquote displays in various levels of brown: a light brown (pastel yellow) background, a medium brown border, and dark brown text. (All on the same gray page background.)

![](https://cdn-images-1.medium.com/max/1600/1*lPMcAGAbSXru_aq4HXJ9iA.png)

Example 4
### Shorthand

I need to mention that you can abbreviate CSS hex color codes from six digits to three, but please don’t. Graphic designers generally discourage the practice, for good reasons.

First, shorthand codes often result in unintended colors. Shorthand is only accurate when both hex digits for one color value are the same, like FF, 88, or 22. For example, `#fff` is the same as `#ffffff`, and `#d09` is the same as `#dd0099`. But if the hex digits in the original color aren’t the same, shorthand coding “smooths out” the color, resulting in something close to — but not quite like — the original. That is, `#080` is the same as `#008800`; it is absolutely **not** the same as `#008000`. And `#a4d` is the same as #aa44dd, **not**`#a040d0`.

Second, even when shorthand is used correctly, it is seldom used consistently, rendering global search and replace problematic or useless. If you code `#4be` in some CSS rules and `#44bbee` in others, and then find you need to change that color later, you’ve got a matching problem. Even simple codes like `#000` and `#000000` can’t be easily matched and replaced.

Third, the download efficiency gain of color shorthand is *three crummy bytes*. The reduction in color specificity alone, never mind the soon-to-jump-up-and-kick-your-butt maintenance hassle, just isn’t worth it.

### Summary

Let’s take it home. The point to be made here is that hexadecimal isn’t hard, and it’s not even that different from decimal — it just has more digits. Remember that you’re really just dealing with decimal numbers from 0–255, but written with the hex two-digit 00-FF notation. Once you accept the concept of base 16, you’ll see that its mechanics are identical to base 10, and hex color codes will start to become more intuitive.

![](https://cdn-images-1.medium.com/max/1600/1*dBgajGgo1neP6GZlHOG09g.jpeg)

Some folks get it… some folks don’t
Remember, it’s always three pairs of hex digits, always in red-green-blue order, and higher numbers always mean brighter colors (and vice versa).

Now take a moment to scrunch your arm around behind you and pat yourself on the back. You now know something that about 98% of your peers don’t!

### Resources (sites)

#### Colors

- [http://www.w3schools.com/cssref/css_colors.asp](http://www.w3schools.com/cssref/css_colors.asp)
- [https://en.wikipedia.org/wiki/Web_colors](https://en.wikipedia.org/wiki/Web_colors)
- [https://developer.mozilla.org/en-US/docs/Web/CSS/color](https://developer.mozilla.org/en-US/docs/Web/CSS/color)
- Thousands more, just Google “CSS colors”

#### Hexadecimal

- [https://learn.sparkfun.com/tutorials/hexadecimal](https://learn.sparkfun.com/tutorials/hexadecimal)
- [http://www.codeproject.com/Articles/4069/Learning-Binary-and-Hexadecimal](http://www.codeproject.com/Articles/4069/Learning-Binary-and-Hexadecimal)
- Again, more than you can count

### Resources (tools)

#### Integrated with editors/HATs

Integrated tools typically let you choose a color and see the code, or enter a code and see the color. For example, Chrome DevTools has an integrated color picker, and Mac Sublime Text has a color picker plug-in.

#### Standalone

- [http://www.colorpicker.com/](http://www.colorpicker.com/) (online)
- [http://www.iconico.com/colorpic/](http://www.iconico.com/colorpic/) (desktop)
- [http://www.eyecon.ro/colorpicker/](http://www.eyecon.ro/colorpicker/) (jQuery)
- [http://colorcop.net/](http://colorcop.net/) (desktop, an oldie but goodie)

### Thanks!

Thank you for reading this article; I hope you had fun and learned something along the way! Comments or questions? Contact the author, Dave Gash, at [dave@davegash.com](mailto:dave@davegash.com).


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  