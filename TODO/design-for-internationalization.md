> * 原文地址：[Design for internationalization](https://medium.com/dropbox-design/design-for-internationalization-24c12ea6b38f#.9j1hidxim)
* 原文作者：[John Saito](https://medium.com/@jsaito?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*4b5cI9BV1Fqqq98YsqmJQg.jpeg">

# Design for internationalization #

## Build better products for people around the world ##

Imagine you’re trying out a new app for the first time. It’s getting rave reviews from people on Twitter. They’re saying it’s brilliant. Life-changing. Delightful.

You start it up and see this:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*Cy5mMktsKBZvbPzlXaVBLA.png">

Hmm. That’s odd. There’s a video up top, but the captions are in a language you don’t understand. The wording is weird, and the button text doesn’t even fit in the button. How could people think this is good?

Well, it turns out this app wasn’t designed in your language. It was designed in Elvish, then translated into your language. Most people are using the Elvish version, so they don’t know how things look in your language.

Believe it or not, this is what non-English users have to deal with time and time again. Because many apps are only designed with English in mind, some design details can get lost in translation if you’re not careful.



To avoid running into situations like the one above, here are a few tips to keep in mind when designing for internationalization.

### 1. Leave room for longer translations ###

The most common internationalization problem is not having enough space for translations.

Think of the label “**New!**” for example. In English, it’s 4 characters with the exclamation point. But in French, it’s 9 characters: “**Nouveau !**” That’s more than double the size of English. And yes, in French, there’s supposed to be a space before exclamation points.

If your design includes words, make sure you have enough space to fit longer translations. If you don’t, you might end up with overlapping text or text that gets cut off.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*09D6oeP9hutAyl8N1CPOBA.png">

Uh-oh. It’s feeling a little cramped in here.

One way I estimate translation lengths is by using Google Spreadsheets. Using the [GoogleTranslate](https://support.google.com/docs/answer/3093331?hl=en) function, I can get machine translations in a bunch of languages at once. Within seconds, I can get a rough idea of how long the translations might be in each language.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*cwW9C7ixEaUOGUnllnHxJw.png">

A tool I made in Google Spreadsheets to estimate translation lengths

[IBM’s globalization site](http://www-01.ibm.com/software/globalization/guidelines/a3.html) has a useful chart that shows how much extra space is needed when translating from English:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*w0CjFH1xAw5yd8ZrFIi6kA.png">

### 2. Avoid putting text in narrow columns ###

Columns are a great way to organize your content. They create balance, structure, and rhythm. They work well with your carefully crafted grid system.

But what happens when the length of your text becomes unpredictable? Well, that’s what happens during translation. Your 1-line headings can grow into 2 or 3 lines, and your beautifully balanced layout can suddenly break.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*ZtT3APKFK2VHpJWpIHDxCA.png">

*Wrapping translations can ruin a designer’s day.*

When you put text in narrow columns, there’s a good chance some translations will wrap into more lines. A safer choice is to use wide rows instead of narrow columns. That’ll give your text more room to grow without breaking your layout.

### 3. Don’t embed text in images ###

If your design includes an image with text in it, it can be a nightmare to get that image translated into a bunch of languages.

Translators can translate each of the text layers in a Photoshop or Sketch file, but it gets messy because you might have to adjust the layout in each language to accommodate longer translations.

Here are a couple of better options:

- **Use lines instead of text:** Sometimes you don’t have to use real words to get your message across. It’s amazing what a few fuzzy lines can do.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*nMA-vKio8AcY_AhZaf_rLA.png">

- **Overlay text with CSS:** The text in the green circle below isn’t actually part of the image. The text was just added on top using CSS.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*wrkH7j-wuQPTFlOdAMosag.png">

### 4. Don’t create sentences with UI elements ###

It’s common for designers to move different UI elements around to see which layouts work best. “Let’s put this text field over here to the right. Let’s move this dropdown to the left.”

But you’ve got to be extra careful when working with words. If you try to form sentences by combining text with buttons, boxes, or dropdowns, you’ll often end up in a lot of trouble.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*pg9WGS2Mjzw-bOBczAyPWw.png">

*This can get messy for internationalization.*

There are a few reasons why this is a pain for internationalization:

- **Different word order:** Languages have different ways of ordering words. If you translate “Buy 3 shirts” into Japanese, the word “Buy” will move to the end of the sentence. If your design depends on words to be in a certain order, it won’t work in every language.

- **Pluralization:** In English, we have one singular form and one plural form for each noun: “1 picture” and “__ pictures.” But in Russian, there are 3 possible forms. So if a user needs to enter a number in the middle of a sentence, that sentence might end up with a grammatical error depending on the number they enter.

- **Gender:** Some languages have gender-specific forms for nouns and adjectives. In French, the word “large” could be translated as “grand,” “grande,” “grands,” or “grandes” depending on the thing it describes. If you place a dropdown in a sentence, that sentence might end up with a grammatical error depending on the words around it.

So what do you do instead? A better alternative is to keep the UI element out of the sentence:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*TkIA4qufokEsRD1SiDSWwA.png">

*It’s better to leave UI elements outside of the sentence.*

### 5. Watch out for metaphors ###

Product design is all about metaphors. Every icon, every button, and every interaction is a metaphor for something in the physical world. The Dropbox icon is a metaphor for a storage box. Click-and-drag is a metaphor for picking things up with your hand.

But some metaphors mean different things in different cultures. In the United States, an owl represents wisdom. In Finland and India, an owl can represent foolishness.

Objects can also look different around the world. For most Americans, it’s pretty clear that the object below is a mailbox. But this isn’t what mailboxes look like around the world. Most countries don’t put flags on their mailboxes, so this metaphor might not make sense to everyone.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*UJt8-pNscLjUqjR7RzWM2g.png">

*This isn’t what a mailbox looks like in most parts of the world.*

If possible, it’s a good idea to do some research on metaphors before including them in your design. At Dropbox, we’ll often ask our Internationalization team to review icons or illustrations if we’re worried about how they’ll be perceived internationally.

### 6. Use descriptive feature names ###

From a marketing perspective, it’s tempting to invent fun feature names that get people talking. But fun names are difficult to translate, and they might be meaningless in other languages.

Years ago, Dropbox introduced a feature that let users have unlimited version history on a file. We initially called this feature “Packrat.”

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*42MIMQ_0yT7Ob656HJnRqQ.png">

“Packrat” option with a little rat icon

While “Packrat” might’ve been a clever name for a U.S. audience, it made no sense in other languages. The rat icon next to it made things even more confusing. Thankfully, we changed the name to “Extended version history,” which was so much easier to translate.

To avoid translation problems, it’s safer to use descriptive terms for feature names. Descriptive terms might seem a bit boring, but they’re better for translation and for usability, too.

### 7. Provide alternates for translation ###

In general, when you’re writing words that’ll get translated, it’s best to write in a style that’s precise, literal, and neutral. However, there might be special branding moments when you want to be a little more playful.

For cases like this, we’ll sometimes write two versions: one version for English and an alternate version for translation.

You can do this by adding comments for translators for anything that’s tricky to translate. We’re currently writing labels for stickers used in Dropbox. We decided to use “OMG cat” as the label for the sticker below.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*6IMEaGvddRarCRZ15EtDEw.png">

Oh my gosh! It’s OMG cat.

When translators work on this, they’ll see a comment saying this can be also translated as “Surprised cat.” That way, translators have the freedom to use a playful translation, but they can fall back on a more literal translation if needed.

Hope you found some of these tips helpful. If you’ve got other design tips for internationalization, feel free to chime in below so we can all learn from each other. By spreading the word about internationalization, I’m hoping we can all do our part to build better products for people around the world.


*Want more from the Dropbox Design team? Follow our* [*publication*](https://medium.com/dropbox-design), [*Twitter*](https://twitter.com/dropboxdesign), and [*Dribbble*](https://dribbble.com/dropbox). Want to make magic together? [*We’re hiring*](https://www.dropbox.com/jobs/design?gh_src=2x3mfd1)!

*Many thanks to everyone who helped tell this story, including Fanny Luor, Jensen Hong, Adam Sawyer, Dawn Lee, Andrea Drugay, Anthony Kosner, Dave Weiss, Galina Mishnyakova, Kurt Varner, and all the incredible i18n gurus who’ve taught me so much over the years.*🙏

