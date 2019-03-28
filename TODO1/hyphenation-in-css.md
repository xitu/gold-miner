# All you need to know about hyphenation in CSS

![Part of a Gutenberg bible showing hyphenation on many lines](https://clagnut.com/images/1-handj-bible-hyphens.jpg)

Earlier this month I was invited to give an [evening lecture](http://typographischegesellschaft.at/k_vortrag_workshop/v_rutter.html) at the Typography Society of Austria ([tga](http://typographischegesellschaft.at/)) in Vienna. I was honoured to do so, as it meant following in the footsteps of such luminaries as Matthew Carter, Wim Crouwel, Margaret Calvert, Erik Spiekermann, and the late Freda Sack to name but a few.

I presented some golden rules for typography on the web, and in the Q&A afterwards I was asked about the current state of automatic hyphenation on the web. This was an apt question considering that German is well known for its long words -- noun compounds feature commonly (for example Verbesserungsvorschlag meaning *suggestion for improvement*) -- so hyphenation is extensively used in most written media.

Automatic hyphenation on the web has been [possible since 2011](https://clagnut.com/blog/2394) and is now [broadly supported](https://caniuse.com/#feat=css-hyphens). Safari, Firefox and Internet Explorer 9 upwards support automatic hyphenation, as does Chrome on Android and MacOS (but [not yet on Windows or Linux](https://bugs.chromium.org/p/chromium/issues/detail?id=652964)).

## How to turn on automatic hyphenation

There are two steps required to turn on automatic hyphenation. The first is to set the language of the text. This will tell the browser which hyphenation dictionary to use -- correct automatic hyphenation requires a hyphenation dictionary appropriate to the language of the text. If the browser does not know the language of the text, the CSS guidelines say it is not required to hyphenate automatically, even if you turn on hyphenation in a style sheet.

Hyphenation is a complex subject. Hyphenation points are mainly based on syllables using a combination of etymology and phonology, but house styles also have differing rules on dividing words.

### 1\. Setting the language

The language of a webpage should be set using the HTML `lang` attribute:

```html
<html lang="en">
```

Setting the language in this way is best practice for all web pages regardless of whether you are hyphenating or not. Knowing the language of the text will help automatic translating tools, screen readers and other assistive software.

The `lang="en"` attribute uses an [ISO language tag](https://www.w3.org/International/articles/language-tags/) to tell the browser that the text is in English. In this case the browser will choose its default English hyphenation dictionary, which will often mean hyphenating for American English. While there are important differences in spelling and pronunciation (and hence hyphenation) between American English and other countries, there can be even bigger differences in languages such as Portuguese. The solution is to add a 'region' to the language so that the browser knows which is the most appropriate hyphenation dictionary. For instance, to specify Brazilian Portuguese or British English:

```html
<html lang="pt-BR">
<html lang="en-GB">
```

### 2\. Turn on the hyphens

Now you've set your language, you are ready to turn on automatic hyphenation in CSS. This couldn't be much easier:

```css
hyphens: auto;
```

Currently Safari and IE/Edge both require prefixes, so this is what you'll need right now:

```css
-ms-hyphens: auto;
-webkit-hyphens: auto;
hyphens: auto;
```

## Hyphenation controls

There is more to setting hyphenation than just turning on the hyphens. The [CSS Text Module Level 4](https://www.w3.org/TR/css-text-4/#hyphenation) has introduced the same kind of hyphenation controls provided in layout software (eg. InDesign) and some word processors (including Word). These controls provide different ways to define how much hyphenation occurs through your text.

### Limiting the word length and the number of characters before and after a hyphen

If you hyphenate short words they can be harder to read. Likewise, you don't want too few characters left on a line before the hyphen, or pushed to the next line after the hyphen. A common rule of thumb is to only allow words at least six-letters long to be hyphenated, leaving at least three characters before the word break, and taking a minimum of two to the next line.

The *Oxford Style Manual* recommends that three is the minimum number of letters after a hyphen at a line break, though exceptions can be made in very short measures.

You can set these limits with the `hyphenate-limit-chars` property. It takes three space-separated values. The first is the minimum character limit for a word to be hyphenated; the second is the minimum number of characters before the hyphenation break; and the last is the minimum characters after the hyphenation break. To set the aforementioned rule of thumb, with a six-character word limit, three characters before the hyphenation break and two after, use:

```css
hyphenate-limit-chars: 6 3 2;
```

![](https://clagnut.com/images/1-handj-hyphenate-limit-chars.png)

hyphenate-limit-chars in action.

The default value for `hyphenate-limit-chars` is `auto` for all three settings. This means that the browser should pick the best settings based on the current language and layout. The CSS Text Module Level 4 suggests that browsers use `5 2 2` as their starting point (which I think results in too much hyphenation), but browsers are free to vary that as they see fit.

Currently only IE/Edge supports this property (with a prefix), however Safari does support hyphenation character limits using some legacy properties specified in an earlier draft of the CSS3 Text Module. This means you can get the same control in Edge and Safari (with some forward planning for Firefox) like this:

```css
/* legacy properties */
-webkit-hyphenate-limit-before: 3;
-webkit-hyphenate-limit-after: 2;

/* current proposal */
-moz-hyphenate-limit-chars: 6 3 2; /* not yet supported */
-webkit-hyphenate-limit-chars: 6 3 2; /* not yet supported */
-ms-hyphenate-limit-chars: 6 3 2;
hyphenate-limit-chars: 6 3 2;
```

### Limiting the number of consecutive hyphenated lines

For primarily aesthetic reasons, you can limit the number of lines in a row that are hyphenated. Consecutively hyphenated lines, particularly three or more, are pejoratively called a ladder. The general rule of thumb for English is that two consecutive lines is the ideal maximum (in contrast, readers of German may well be faced with many ladders). By default, CSS sets no limit to the number of consecutive hyphens, but you can use the `hyphenate-limit-lines` property to specify a maximum. Currently this is only supported by IE/Edge and Safari (with prefixes).

```css
-ms-hyphenate-limit-lines: 2;
-webkit-hyphenate-limit-lines: 2;
hyphenate-limit-lines: 2;
```

![](https://clagnut.com/images/1-handj-hyphenate-limit-lines.png)

hyphenate-limit-lines applied to prevent a ladder.

You can remove the limit using a value of `no-limit`.

### Avoiding hyphenated words across the last line of a paragraph

Unless you tell it otherwise, a browser will happily hyphenate the very last word of a paragraph such that the end of the broken word sits alone on the final line, a lonely orphan of an orphan. It is often preferable to have a large gap at the end of the penultimate line than having half a word on the final line. You can achieve this by activating the `hyphenate-limit-last` property with a value of `always`.

```css
hyphenate-limit-last: always;
```

Currently this is only supported in IE/Edge (with a prefix).

### Reducing hyphenation by setting a hyphenation zone

By default, hyphenation will occur as often as the browser can split a word across two lines, within any `hyphenate-limit-chars` and `hyphenate-limit-lines` values you set. Even when applying those properties to control when hyphenation occurs, you could still end up with heavily hyphenated paragraphs.

Consider a left-aligned paragraph. The right edge is ragged, which hyphenation can reduce. By default, all words which are allowed to be hyphenated will be. This will give you the maximum amount of hyphenation and thus the maximum reduction to the rag. If you are prepared to tolerate a little more unevenness to the edge of the paragraph, you can reduce the amount of hyphenation.

You can do this by specifying the maximum amount of whitespace allowed between the last word of the line and edge of the text box. If a new word begins within this whitespace it is not hyphenated. This whitespace is known as the hyphenation zone. The bigger the hyphenation zone, the greater the rag and the less the hyphenation. By adjusting the hyphenation zone you are balancing the ratio between better spacing and fewer hyphens.

![](https://clagnut.com/images/1-handj-hyphenation-zone.png)

*Left*: Arrows indicate lines where hyphenation is allowed.\
*Right*: Hyphenation with hyphenation zone set.

To do this you use the `hyphenation-limit-zone` property, which takes a length or a percentage value (in terms of the width of the text box). In the context of responsive design, it makes most sense to set your hyphenation zone as a percentage. Doing so means you would get a smaller hyphenation zone on smaller screens, leading to more hyphenation and less rag. Conversely on wider screens you would get a broader hyphenation zone, hence less hyphenation and more rag, which a wider measure would be better able to accommodate. Based on typical defaults in page layout software, 8% is a good start:

```css
hyphenate-limit-zone: 8%
```

Currently this is only supported in IE/Edge (with a prefix).

### Putting it all together

To apply the same kinds of hyphenation controls as are available in conventional layout software (at least on a line-by-line basis) to paragraph using CSSText Module Level 4 properties:

```css
p {
    hyphens: auto;
    hyphenate-limit-chars: 6 3 3;
    hyphenate-limit-lines: 2;
    hyphenate-limit-last: always;
    hyphenate-limit-zone: 8%;
}
```

And with the appropriate browser prefixes and fallbacks:

```css
p {
    -webkit-hyphens: auto;
    -webkit-hyphenate-limit-before: 3;
    -webkit-hyphenate-limit-after: 3;
    -webkit-hyphenate-limit-chars: 6 3 3;
    -webkit-hyphenate-limit-lines: 2;
    -webkit-hyphenate-limit-last: always;
    -webkit-hyphenate-limit-zone: 8%;

    -moz-hyphens: auto;
    -moz-hyphenate-limit-chars: 6 3 3;
    -moz-hyphenate-limit-lines: 2;
    -moz-hyphenate-limit-last: always;
    -moz-hyphenate-limit-zone: 8%;

    -ms-hyphens: auto;
    -ms-hyphenate-limit-chars: 6 3 3;
    -ms-hyphenate-limit-lines: 2;
    -ms-hyphenate-limit-last: always;
    -ms-hyphenate-limit-zone: 8%;

    hyphens: auto;
    hyphenate-limit-chars: 6 3 3;
    hyphenate-limit-lines: 2;
    hyphenate-limit-last: always;
    hyphenate-limit-zone: 8%;
}
```

Hyphenation is a perfect example of progressive enhancement, so you can start applying the above now if you think your readers will benefit from it -- support among browsers will only increase. If you are designing for a website written in a language with long words, such as German, your readers will definitely thank you for it.
