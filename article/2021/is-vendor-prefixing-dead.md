> * 原文地址：[Is Vendor Prefixing Dead?](https://css-tricks.com/is-vendor-prefixing-dead/)
> * 原文作者：[Rob O'Leary](https://css-tricks.com/author/robjoeol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/is-vendor-prefixing-dead.md](https://github.com/xitu/gold-miner/blob/master/article/2021/is-vendor-prefixing-dead.md)
> * 译者：
> * 校对者：

# Is Vendor Prefixing Dead?

Let‘s take a quick stroll down memory-lane to revisit how [vendor prefixing](https://developer.mozilla.org/en-US/docs/Glossary/Vendor_Prefix) CSS properties came to be. I hope I don’t trigger PTSD for anyone!

It‘s not clear who started prefixing, or when it began exactly. What is clear, is that by 2006, prefixed features were in Internet Explorer and Firefox. The *raison d’être* of prefixes was to specify browser-specific features. It was seen as a way to implement non-standard features and offer previews of new standard features.

By 2012, the W3C CSS Working Group was issuing [guidance on the use of vendor prefixes](https://wiki.csswg.org/spec/vendor-prefixes):

> In CSS we use vendor prefixes for properties, values, @-rules that are: – vendor specific extensions (per CSS 2.1), or – experimental implementations (per CSS Snapshot 2010) (e.g. in Working Drafts)

It became an industry norm. The number of prefixes grew, and with it, things grew confusing. It led to partial implementations of CSS features, introduced bugs, and ultimately created a fracture in the browser ecosystem, which disgruntled developers. Developers responded by making [tools](https://css-tricks.com/how-to-deal-with-vendor-prefixes/) to automate the problem away.

Browser vendors slowly began to move away from prefixing, favoring feature flags inside the browser settings instead. It appeared that the problems created by vendor prefixes would fade away in time. The question is: **has that time come yet?**

I did some analysis on the [caniuse dataset](https://github.com/Fyrd/caniuse) and [Mozilla Developer Network Compat dataset](https://github.com/mdn/browser-compat-data) to answer this question.

## Adoption trends

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/04/prefixing-history.png?resize=988%2C506&ssl=1)

You can see the trend of the implementation of prefixed features across the major browsers in the chart above. I have excluded Chrome for Android because of insufficient data.

From 2007 until 2011, there was a steady increase in the numbers of prefixed features in all browsers. Internet Explorer only saw an uptick in 2011. Then, in 2012, Mozilla began to remove prefixed features — such as `-moz-border-radius*` and `-moz-box-shadow` — from Firefox. Thereafter, they consistently removed prefixed properties once the standard version of that property was fully implemented.

In 2013, Mozilla started to [make features available behind feature flags (pref flags)](https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Releases/26#css). That same year, Chrome switched its rendering engine from WebKit to Blink (part of the Chromium project). This was a big turning point in removing some prefixed features.

It was only in April 2016 that [WebKit announced that it would no longer release experimental features with prefixes](https://webkit.org/blog/6131/updating-our-prefixing-policy/):

> Over time this strategy has turned out not to work so well. Many websites came to depend on prefixed properties. They often used every prefixed variant of a feature, which makes CSS less maintainable and JavaScript programs trickier to write. Sites frequently used just the prefixed version of a feature, which made it hard for browsers to drop support for the prefixed variant when adding support for the unprefixed, standard version. Ultimately, browsers felt pressured by compatibility concerns to implement each other’s prefixes.

Because Safari and iOS browsers have always used the WebKit rendering engine, a consistent reduction in the number of prefixes came later to these browsers.

Microsoft was never “gung ho” on prefixing and consistently had the fewest prefixed features. In 2019, Edge switched from its own rendering engine to Blink. In a funny twist, the change actually increased the number of prefixed properties in Edge!

## Feature trends

The table below contrasts the prefixed features in 2013 (the zenith of prefixing) with 2021.

<table>
<thead>
<tr>
<th></th>
<th>2013</th>
<th>2021</th>
</tr>
</thead>
<tbody>
<tr>
<td>Browsers</td>
<td>
<ul>
<li>Chrome 31</li>
<li>Firefox 26</li>
<li>Internet Explorer 11</li>
<li>Safari 11</li>
<li>Safari iOS 7.0-7.1</li>
</ul>
</td>
<td>
<ul>
<li>Chrome 89</li>
<li>Edge 89</li>
<li>Firefox 88</li>
<li>Internet Explorer 11</li>
<li>Safari 14</li>
<li>Chrome Android 89</li>
<li>Safari iOS 14.0-14.5</li>
</ul>
</td>
</tr>
<tr>
<td>Some prefixing required</td>
<td>
<ul>
<li><code><a href="https://caniuse.com/CSS%20:any-link%20selector">any-link</a></code></li>
<li><code><a href="https://caniuse.com/:dir()%20CSS%20pseudo-class">dir()</a></code></li>
<li><code><a href="https://caniuse.com/:focus-visible%20CSS%20pseudo-class">focus-visible</a></code></li>
<li><code><a href="https://caniuse.com/:is()%20CSS%20pseudo-class">is()</a></code></li>
<li><code><a href="https://caniuse.com/::placeholder%20CSS%20pseudo-element">:placeholder</a></code></li>
<li><code><a href="https://caniuse.com/:placeholder-shown%20CSS%20pseudo-class">:placeholder-shown</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20:read-only%20and%20:read-write%20selectors">read-only</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20:read-only%20and%20:read-write%20selectors">:read-write</a></code></li>
<li><code><a href="https://caniuse.com/::selection%20CSS%20pseudo-element">:selection</a></code></li>
<li><code><a href="https://caniuse.com/css-appearance">appearance</a></code></li>
<li><code><a href="https://caniuse.com/Background-clip:%20text">background-clip: text</a></code></li>
 <li><code><a href="https://caniuse.com/css-cross-fade">background-image: crossfade()</a></code></li>
<li><code><a href="https://caniuse.com/Crisp%20edges/pixelated%20images">background-image: image-set()</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20box-decoration-break">box-decoration-break</a></code></li>
<li><code><a href="https://caniuse.com/CSS3%20Box-sizing">box-sizing</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20clip-path%20property%20(for%20HTML)">clip-path</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20color-adjust">color-adjust</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20element()%20function">element()</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20font-feature-settings">font-feature-settings</a></code></li>
<li><code><a href="https://caniuse.com/CSS3%20font-kerning">font-kerning</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20font-smooth">font-smooth</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20Hyphenation">hyphens</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20image-set">image-set</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20line-clamp">line-clamp</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20position:sticky">position:&nbsp;sticky</a></code></li>
<li><code><a href="https://caniuse.com/CSS3%20tab-size">tab-size</a></code></li>
<li><code><a href="https://caniuse.com/CSS3%20text-align-last">text-align-last</a></code></li>
<li><code><a href="https://caniuse.com/text-decoration">text-decoration styling</a></code></li>
<li><code><a href="https://caniuse.com/text-emphasis">text-emphasis styling</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20text-size-adjust">text-size-adjust</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20user-select:%20none">user-select: none</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20writing-mode%20property">writing-mode</a></code></li>
<li><a href="https://caniuse.com/CSS%20Animation">CSS Animation</a></li>
<li><a href="https://caniuse.com/CSS%20Canvas%20Drawings">CSS Canvas Drawings</a></li>
<li><a href="https://caniuse.com/CSS%20Device%20Adaptation">CSS Device Adaptation</a>
</li>
<li><a href="https://caniuse.com/CSS%20grab%20&amp;%20grabbing%20cursors">CSS Cursors:&nbsp;<code>grab</code>&nbsp;and&nbsp;<code>grabbing</code></a></li>
<li><a href="https://caniuse.com/CSS3%20Cursors:%20zoom-in%20&amp;%20zoom-out">CSS&nbsp;Cursors: <code>zoom-in</code> and <code>zoom-out</code> cursors</a></li>
<li><a href="https://caniuse.com/CSS%20Exclusions%20Level%201">CSS Exclusions Level 1</a></li>
<li><a href="https://caniuse.com/CSS%20Filter%20Effects">CSS Filter Effects</a>
</li>
<li><a href="https://caniuse.com/CSS%20Flexible%20Box%20Layout%20Module">CSS Flexible Box Layout Module</a></li>
<li><a href="https://caniuse.com/CSS%20Grid%20Layout%20(level%201)">CSS Grid Layout&nbsp;Level 1</a></li>
<li><a href="https://caniuse.com/CSS%20Logical%20Properties">CSS Logical Properties</a></li>
<li><a href="https://caniuse.com/CSS%20Masks">CSS Masks</a></li>
<li><a href="https://caniuse.com/CSS%20Reflections">CSS Reflections</a></li>
<li><a href="https://caniuse.com/CSS%20Regions">CSS Regions</a></li>
<li><a href="https://caniuse.com/CSS%20Scroll%20Snap">CSS Scroll Snap</a></li>
<li><a href="https://caniuse.com/CSS%20scrollbar%20styling">CSS&nbsp;Scrollbar&nbsp;Styling</a></li>
<li><a href="https://caniuse.com/CSS3%202D%20Transforms">CSS3 2D Transforms</a></li>
<li><a href="https://caniuse.com/CSS3%203D%20Transforms">CSS3 3D Transforms</a></li>
<li><a href="https://caniuse.com/CSS3%20Multiple%20column%20layout">CSS3 Multiple&nbsp;Column&nbsp;Layout</a></li>
<li><a href="https://caniuse.com/text-stroke">CSS Text Fill &amp; Stroking</a></li>
<li><a href="https://caniuse.com/Intrinsic%20&amp;%20Extrinsic%20Sizing">Intrinsic &amp; Extrinsic Sizing</a></li>
<li><a href="https://caniuse.com/Media%20Queries:%20resolution%20feature">Media Queries: Resolution Feature</a></li>
</ul>
</td>
<td>
<ul>
<li><code><a href="https://caniuse.com/css-placeholder-shown">:placeholder-shown</a></code></li>
<li><code><a href="https://caniuse.com/css-appearance">appearance</a></code></li>
<li><code><a href="https://caniuse.com/css-backdrop-filter">backdrop-filter</a></code></li>
<li><code><a href="https://caniuse.com/background-clip-text">background-clip: text</a></code></li>
<li><code><a href="https://caniuse.com/css-cross-fade">background-image: crossfade()</a></code></li>
<li><code><a href="https://caniuse.com/css-crisp-edges">background-image: image-set()</a></code></li>
<li><code><a href="https://caniuse.com/css-boxdecorationbreak">box-decoration-break</a></code></li>
<li><code><a href="https://caniuse.com/css-clip-path">clip-path</a></code> (HTML)</li>
<li><code><a href="https://caniuse.com/css-color-adjust">color-adjust</a></code></li>
<li><code><a href="https://caniuse.com/css-element-function">element()</a></code></li>
<li><code><a href="https://caniuse.com/font-smooth">font-smooth</a></code></li>
<li><code><a href="https://caniuse.com/CSS%20Hyphenation">hyphens</a></code></li>
<li><code><a href="https://caniuse.com/css-image-set">image-set</a></code></li>
<li><code><a href="https://caniuse.com/css-initial-letter">initial-letter</a></code></li>
<li><code><a href="https://caniuse.com/css-line-clamp">line-clamp</a></code></li>
<li><code><a href="https://caniuse.com/css-sticky">position: sticky</a></code></li>
<li><code><a href="https://caniuse.com/text-decoration">text-decoration styling</a></code></li>
<li><code><a href="https://caniuse.com/text-emphasis">text-emphasis-styling</a></code></li>
<li><code><a href="https://caniuse.com/css-text-orientation">text-orientation</a></code></li>
<li><code><a href="https://caniuse.com/text-size-adjust">text-size-adjust</a></code></li>
<li><code><a href="https://caniuse.com/user-select-none">user-select: none</a></code></li>
<li><code><a href="https://caniuse.com/font-kerning">font-kerning</a></code></li>
<li><code><a href="https://caniuse.com/css3-tabsize">tab-size</a></code></li>
<li><a href="https://caniuse.com/css-canvas">CSS Canvas Drawings</a></li>
<li><a href="https://caniuse.com/css-deviceadaptation">CSS Device Adaptation</a></li>
<li><a href="https://caniuse.com/css-exclusions">CSS Exclusions Level 1</a></li>
<li><a href="https://caniuse.com/css-grid">CSS Grid Layout Level 1</a></li>
<li><a href="https://caniuse.com/css-masks">CSS Masks</a></li>
<li><a href="https://caniuse.com/css-reflections">CSS Reflections</a></li>
<li><a href="https://caniuse.com/css-regions">CSS Regions</a></li>
<li><a href="https://caniuse.com/css-snappoints">CSS Scroll Snap</a></li>
<li><a href="https://caniuse.com/css-scrollbar">CSS Scrollbar Styling</a></li>
<li><a href="https://caniuse.com/text-stroke">CSS Text Fill &amp; Stroking</a></li>
<li><a href="https://caniuse.com/intrinsic-width">Intrinsic &amp; Extrinsic Sizing</a></li>
<li><a href="https://caniuse.com/css-media-resolution">Media Queries: Resolution Feature</a></li>
</ul>
</td>
</tr>
<tr>
<td>Total features</td>
<td>53</td>
<td>35</td>
</tr>
</tbody>
</table>

It may be surprising to see the raw numbers. **The number of features that require prefixing fell by ~33% between 2013 and 2021**. That number sounds quite modest to me.

Of course, it could be misleading to focus just on numbers. The impact varies. It could be a family of properties that all require prefixing, such as `animation`; or it could be a feature that only has one property or value that requires a prefix, such as `user-select: none`. Let’s explore the actual features to understand the circumstances better, beginning by looking at what changed in that intervening period.

Twenty features were unprefixed (fully implemented across the major browsers) and three prefixed features were introduced (`backdrop-filter`, CSS `text-orientation`, and CSS `initial-letter`).

In my opinion, the most notable features that are unprefixed now, which were significant pain points are:

1. CSS Flexible Box Layout Module
2. CSS3 Box Sizing
3. CSS Animation
4. CSS3 2D Transforms
5. CSS3 3D Transforms
6. CSS Filter Effects

The other 14 features are less prominent:

1. `:any-link`
2. `::placeholder`
3. `::selection`
4. `:focus-visible`
5. `:is()`
6. `:read-only`
7. `:read-write`
8. `font-feature-settings`
9. `text-align-last`
10. `writing-mode`
11. CSS `grab` and `grabbing` cursors
12. CSS Logical Properties (will be used a lot more in the future, now that support is better)
13. CSS3 `zoom-in` and `zoom-out` cursors
14. CSS3 Multiple Column Layout

If you choose not to support Internet Explorer 11 in 2021, then an additional seven features no longer require prefixing. That reduces the number of features that require prefixing in 2021 to 28, which is a 46% reduction since 2013.

## Prefixing in 2021

Let‘s look at the properties that require prefixing. It’s a motley group!

<table>
<thead>
<tr>
<th>#</th>
<th>Name</th>
<th>Properties/Values</th>
<th>Description</th>
<th>Prefix required</th>
<th>Unprefixed support</th>
<th>Prefixed support</th>
<th>Improvement with prefixes</th>
</tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td><code><a href="https://caniuse.com/CSS%20Appearance">appearance</a></code></td>
<td><code>appearance</code></td>
<td>Defines how elements (particularly form controls) appear by default. Setting the value to <code>none</code> causes in the element’s default appearance being entirely redefined using other CSS properties.</td>
<td><ul><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Android Browser 2.1-4.4.4 <br>(<code>-webkit</code>)</li></ul></td>
<td>69.80%</td>
<td>97.03%</td>
<td>27.23%</td>
</tr>
<tr>
<td>2</td>
<td><code><a href="https://caniuse.com/background-clip-text">background-clip-text</a></code></td>
<td><code>background-clip: text</code></td>
<td>Non-standard method of clipping a background image to the foreground text.</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li></ul></td>
<td>3.89%</td>
<td>96.65%</td>
<td>92.76%</td>
</tr>
<tr>
<td>3</td>
<td><code><a href="https://caniuse.com/css-backdrop-filter">backdrop-filter</a></code></td>
<td><code>backdrop-filter</code></td>
<td>Method of applying filter effects (like <code>blur</code>, <code>grayscale</code> or <code>hue</code>) to content or elements below the target element.</td>
<td><ul><li>Safari <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li></ul></td>
<td>70.20%</td>
<td>88.20%</td>
<td>18.00%</td>
</tr>
<tr>
<td>4</td>
<td><code><a href="https://caniuse.com/css-cross-fade">background-image: crossfade()</a></code></td>
<td><code>background-image: crossfade()</code></td>
<td>Image function to create a “crossfade” between images. This allows one image to transition (fade) into another based on a percentage value.</td>
<td><ul><li>Chrome<br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li></ul></td>
<td>17.77%</td>
<td>92.62%</td>
<td>74.85%</td>
</tr>
<tr>
<td>5</td>
<td><code><a href="https://caniuse.com/css-image-set">background-image: image-set()</a></code></td>
<td><code>background-image: image-set()</code></td>
<td>Method of letting the browser pick the most appropriate CSS background image from a given set, primarily for high <abbr>PPI</abbr> screens.</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>17.77%</td>
<td>92.48%</td>
<td>74.71%</td>
</tr>
<tr>
<td>6</td>
<td><code><a href="https://caniuse.com/css-boxdecorationbreak">box-decoration-break</a></code></td>
<td><code>box-decoration-break</code></td>
<td>Controls whether the box’s margins, borders, padding, and other decorations wrap the broken edges of the box fragments, when the box is split by a break, like a page, column, region, or line.</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android BrowserOpera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>6.39%</td>
<td>97.17%</td>
<td>90.78%</td>
</tr>
<tr>
<td>7</td>
<td><code><a href="https://caniuse.com/css-clip-path">clip-path</a></code></td>
<td><code>clip-path</code></td>
<td>Method of defining the visible region of an HTML element using SVG or a shape definition.</td>
<td><ul><li>Safari <br>(<code>-webkit</code>)</li></ul></td>
<td>72.00%</td>
<td>96.33%</td>
<td>24.33%</td>
</tr>
<tr>
<td>8</td>
<td><code><a href="https://caniuse.com/css-color-adjust">color-adjust</a></code></td>
<td><code>color-adjust</code></td>
<td>A non-standard CSS extension that can be used to force background colors and images to print.</td>
<td><ul><li>Chrome <br>(<code>-webkit-print-color-adjust</code>)</li><li>Edge <br>(<code>-webkit-print-color-adjust</code>)</li><li>Safari <br>(<code>-webkit-print-color-adjust</code>)</li><li>Opera <br>(<code>-webkit-print-color-adjust</code>)</li><li>Android Mobile<br>(<code>-webkit-print-color-adjust</code>)</li></ul></td>
<td>3.69%</td>
<td>39.77%</td>
<td>36.08%</td>
</tr>
<tr>
<td>9</td>
<td><code><a href="https://caniuse.com/css-element-function">element()</a></code></td>
<td><code>background: element()</code></td>
<td>This function renders a live image generated from an arbitrary HTML element</td>
<td><ul><li>Firefox <br>(<code>-moz</code>)</li></ul></td>
<td>0.00%</td>
<td>4.04%</td>
<td>4.04%</td>
</tr>
<tr>
<td>10</td>
<td><code><a href="https://caniuse.com/font-kerning">font-kerning</a></code></td>
<td><code>font-kerning</code></td>
<td>Controls the usage of the spacing between lettersstored in the font. Note that this only affects OpenType fonts with kerning information, it has no effect on other fonts.</td>
<td><ul><li>Safari iOS<br>(<code>-webkit</code>)</li></ul></td>
<td>81.73%</td>
<td>96.03%</td>
<td>14.30%</td>
</tr>
<tr>
<td>11</td>
<td><code><a href="https://caniuse.com/font-smooth">font-smooth</a></code></td>
<td><code>font-smooth</code></td>
<td>Controls how anti-aliasing is applied when fonts are rendered. Though present in early 2002 drafts of the CSS3 Fonts specification, this property has since been removed and is currently not on the standard track.</td>
<td><ul><li>Chrome <br>(<code>-webkit-font-smoothing</code>)</li><li>Edge <br>(<code>-webkit-font-smoothing</code>)</li><li>Firefox <br>(<code>-moz-osx-font-smoothing</code>)</li><li>Safari <br>(<code>-webkit-font-smoothing</code>)</li><li>Opera <br>(<code>-webkit-font-smoothing</code>)</li></ul></td>
<td>0.00%</td>
<td>39.64%</td>
<td>39.64%</td>
</tr>
<tr>
<td>12</td>
<td><code><a href="https://caniuse.com/css-hyphens">hyphens</a></code></td>
<td><code>hyphens</code></td>
<td>Method of controlling when words at the end of lines should be hyphenated.</td>
<td><ul><li>Internet Explorer 10+ <br>(<code>-ms</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li></ul></td>
<td>76.49%</td>
<td>96.51%</td>
<td>20.02%</td>
</tr>
<tr>
<td>13</td>
<td><code><a href="https://caniuse.com/css-initial-letter">initial-letter</a></code></td>
<td><code>initial-letter</code></td>
<td>Method of creating an enlarged cap, including a drop or raised cap, in a robust way.</td>
<td><ul><li>Safari <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li></ul></td>
<td>0.00%</td>
<td>18.00%</td>
<td>18.00%</td>
</tr>
<tr>
<td>14</td>
<td><code><a href="https://caniuse.com/css-line-clamp">line-clamp</a></code></td>
<td><code>line-clamp</code></td>
<td>Contains text to a given amount of lines when used in combination with <code>display: -webkit-box</code>. Any text that overflows the space produces anellipsis when <code>text-overflow: ellipsis</code> is included.</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Firefox <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li><li>Firefox for Android <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>0.19%</td>
<td>96.28%</td>
<td>96.09%</td>
</tr>
<tr>
<td>15</td>
<td><code><a href="https://caniuse.com/css-sticky">position: sticky</a></code></td>
<td><code>position: sticky</code></td>
<td>Keeps elements positioned as”fixed” or”relative” depending on how it appears in the viewport. As a result the element is “stuck” in place while scrolling.</td>
<td><ul><li>Safari 7.1-12.1 <br>(<code>-webkit</code>)</li></ul></td>
<td>93.50%</td>
<td>95.36%</td>
<td>1.86%</td>
</tr>
<tr>
<td>16</td>
<td><code><a href="https://caniuse.com/css3-tabsize">tab-size</a></code></td>
<td><code>tab-size</code></td>
<td>Method of customizing the width of the <kbd>Tab</kbd> character. Only effective alongside <code>white-space: pre</code> or <code>white-space: pre-wrap</code>.</td>
<td><ul><li>Firefox 4+<br>(<code>-moz</code>)</li><li>Firefox for Android <br>(<code>-moz</code>)</li><li>Opera 11.5-12-1 <br>(<code>-o</code>)</li></ul></td>
<td>92.33%</td>
<td>97.38%</td>
<td>5.05%</td>
</tr>
<tr>
<td>17</td>
<td><code><a href="https://caniuse.com/text-decoration">text-decoration styling</a></code></td>
<td><code>text-decoration</code><br><code>text-decoration-*</code> properties.</td>
<td>Method of defining the type, style and color of lines in the <code>text-decoration</code> property. These can be defined as a shorthand (e.g. <code>text-decoration: line-through dashed blue</code>) or as single properties (e.g. <code>text-decoration-color: blue</code>).</td>
<td><ul><li>Firefox 6-35 <br>(<code>-moz</code>)</li><li>Safari 7.1+<br>(<code>-webkit</code>)</li><li>Safari for iOS 8+ <br>(<code>-webkit</code>)</li></ul></td>
<td>80.25%</td>
<td>94.86%</td>
<td>14.61%</td>
</tr>
<tr>
<td>18</td>
<td><code><a href="https://caniuse.com/text-emphasis">text-emphasis styling</a></code></td>
<td><code>text-emphasis</code><br><code>text-emphasis-*</code> properties</td>
<td>Method of using small symbols next to each glyph to emphasize a run of text, commonly used in East Asian languages. The <code>text-emphasis</code> shorthand property, and its <code>text-emphasis-style</code> and <code>text-emphasis-color</code> constituent properties can be used to apply marks to the text. The <code>text-emphasis-position</code> property, which inherits separately, allows setting theposition ofemphasis marks with respect to the text.</td>
<td><ul><li>Chrome 25+ <br>(<code>-webkit</code>)</li><li>Edge 79+<br>(<code>-webkit</code>)</li><li>Opera 15+<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>21.96%</td>
<td>95.99%</td>
<td>74.03%</td>
</tr>
<tr>
<td>19</td>
<td><code><a href="https://caniuse.com/css-text-orientation">text-orientation</a></code></td>
<td><code>text-orientation</code></td>
<td>Specifies the orientation of text within a line. Current values only have an effect in vertical typographic modes (defined with the <code>writing-mode</code> property).</td>
<td>Safari <br>(<code>-webkit</code>)</td>
<td>90.88%</td>
<td>94.84%</td>
<td>3.96%</td>
</tr>
<tr>
<td>20</td>
<td><code><a href="https://caniuse.com/text-size-adjust">text-size-adjust</a></code></td>
<td><code>text-size-adjust</code></td>
<td>Control if and how the text-inflating algorithm is applied to the textual content of the element it is applied to.</td>
<td><ul><li>Edge 12-18 <br>(<code>-ms</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Firefox for Android <br>(<code>-moz</code>)</li></ul></td>
<td>72.75%</td>
<td>87.48%</td>
<td>14.73%</td>
</tr>
<tr>
<td>21</td>
<td><code><a href="https://caniuse.com/user-select-none">user-select: none</a></code></td>
<td><code>user-select</code></td>
<td>Method of preventing text or element selection.</td>
<td><ul><li>Internet Explorer 10-11 <br>(<code>-ms</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser 2.1-4.4.4 <br>(<code>-webkit</code>)</li></ul></td>
<td>74.81%</td>
<td>96.49%</td>
<td>21.68%</td>
</tr>
<tr>
<td>22</td>
<td><a href="https://caniuse.com/css-canvas">CSS Canvas Drawings</a></td>
<td><code>background: -webkit-canvas(mycanvas)</code></td>
<td>Method of using HTML5 Canvas as a background image. Not currently part of any specification.</td>
<td><ul><li>Safari <br>(<code>-webkit</code>)</li></ul></td>
<td>0.00%</td>
<td>19.40%</td>
<td>19.40%</td>
</tr>
<tr>
<td>23</td>
<td><a href="https://caniuse.com/css-masks">CSS Masks</a></td>
<td><code>mask mask-*</code> properties</td>
<td>Method of displaying part of an element, using a selected image as a mask.</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Safari iOSAndroid Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul><p>Partial support in WebKit/Blink browsers refers to supporting the <code>mask-image</code> and <code>mask-box-image</code> properties, but lacking support for other parts of the spec.</p></td>
<td>4.18%</td>
<td>96.93%</td>
<td>92.75%</td>
</tr>
<tr>
<td>24</td>
<td><a href="https://caniuse.com/css-reflections">CSS Reflections</a></td>
<td><code>-webkit-box-reflect</code></td>
<td>Method of displaying a reflection of an element.</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>0.00%</td>
<td>91.20%</td>
<td>91.20%</td>
</tr>
<tr>
<td>25</td>
<td><a href="https://caniuse.com/css-scrollbar">CSS Scrollbar Styling</a></td>
<td><code>scrollbar-color</code><br><code>scollbar-width</code></td>
<td>Methods of styling scrollbar color and width.</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li></ul></td>
<td>4.28%</td>
<td>96.87%</td>
<td>92.59%</td>
</tr>
<tr>
<td>26</td>
<td><a href="https://caniuse.com/text-stroke">CSS Text Fill &amp; Stroking</a></td>
<td><code>text-stroke</code><br><code>text-stroke-*</code> properties</td>
<td>Method of declaring the outline (stroke) width and color for text.</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Firefox <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li><li>Firefox for Android <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>0.00%</td>
<td>96.65%</td>
<td>96.65%</td>
</tr>
<tr>
<td>27</td>
<td><a href="https://caniuse.com/intrinsic-width">Intrinsic &amp; Extrinsi Sizing</a></td>
<td><code>max-content</code><br><code>min-content</code><br><code>fit-content</code><br><code>stretch</code> (formerly <code>fill</code>).</td>
<td>Allows for the height and width of an element to be specified in intrinsic values rather than fixed numeric values.</td>
<td><ul><li>Chrome 22-45 <br>(<code>-webkit</code>)</li><li>Edge 3-65<br>(<code>-webkit</code>)</li><li>Firefox (-moz-available)</li><li>Opera 15-32 <br>(<code>-webkit</code>)</li><li>Safari 6.1-10-1 <br>(<code>-webkit</code>)</li><li>Safari iOS 7-13.7 <br>(<code>-webkit</code>)</li><li>Androind Browser 4.4-4.4.4 <br>(<code>-webkit</code>)</li></ul></td>
<td>91.99%</td>
<td>96.36%</td>
<td>4.37%</td>
</tr>
<tr>
<td>28</td>
<td><a href="https://caniuse.com/css-media-resolution">Media Queries: Resolution Feature</a></td>
<td><code>@media (min-resolution: 300dpi)</code> { … }, <code>@media (max-resolution: 300dpi) { … }</code></td>
<td>Allows a media query to be set based on the device pixels used per CSS unit. While the standard uses <code>min-resolution</code> and <code>max-resolution</code>, some browsers support the older non-standard <code>device-pixel-ratio</code> media query.</td>
<td><ul><li>Chrome 4-28 <br>(<code>-webkit</code>)</li><li>Safari 4+ <br>(<code>-webkit</code>)</li><li>Opera 10-11.5 <br>(<code>-webkit</code>)</li><li>Safari iOS <br>(<code>-webkit</code>)</li><li>Android Browser (2.3-4.3) Opera Mobile 12 <br>(<code>-webkit</code>)</li><li>Firefox 3.5-15 <br>(<code>min--moz-device-pixel-ratio</code>)</li></ul><p>Browsers that support <code>-webkit</code> support the non-standard <code>-webkit-min-device-pixel-ratio</code> and <code>webkit-min-device-pixel-ratio</code>.</p></td>
<td>80.40%</td>
<td>99.16%</td>
<td>18.76%</td>
</tr>
</tbody>
</table>

After putting this list together, my initial impression was that these aren’t things that I would bump into very often. Some properties have not been — and probably will not be — fully implemented. I’d say the `element()` function and CSS Canvas Drawings fall into that category. Safari recently dropped prefixing for `position:` `sticky`, so that will likely drop off the list very soon.

You can winnow the list down and steer away from certain situations if you want to. You can dismiss it and say it’s not important, so why bother? The reality is that the list is still long enough that manually managing prefixes in your code is not something you want to take on. A pertinent question to answer is: do you want to improve cross-browser support to a high level? If the answer is yes, then you should consider this as part of your development effort.

It is also important to remember that it is not just about these properties and current browsers. There are still people out there using older devices with older browsers, which do not support the unprefixed versions of some features. Take the `animation` property, for example. Chrome was the last browser to unprefix it in 2015. Yet, today, 1.3% of the users worldwide are still using a browser that does not support the unprefixed version.

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/04/caniuse-css-animation.png?resize=1998%2C314&ssl=1)

I have bumped into a couple of situations recently that required prefixed properties. For example, I was making [a reading progress bar for a blog](https://roboleary.net/programming/2020/04/21/pimp-blog.html) and needed to use `-webkit-appearance: none;` and `-moz-appearance: none;` to reset the default styling for the `progress` element. It also needed sticky positioning, so I had to prefix `position: sticky` to support sticky positioning in Safari.

[CodePen robjoeol/bGVpePR](https://codepen.io/robjoeol/pen/bGVpePR)

Another example? I wanted to use a PNG image as a mask image for a Christmas-themed design and found that `-webkit-mask-image` is the only property that works properly. Masking is generally a bit erratic because most browsers only partially support the spec.

[CodePen robjoeol/WNojGdm](https://codepen.io/robjoeol/pen/WNojGdm)

Here’s yet another: Flavio Copes, in [“How to apply padding to multiple lines in CSS,”](https://flaviocopes.com/css-padding-multiple-lines/) wrote about how he wanted to have the same padding on each line of a multi-line heading. The solution was to use `box-decoration-break: clone`. Most browsers require the `-webkit` prefixed version of this property, so you need to use this.

[CodePen robjoeol/BapdrZw](https://codepen.io/robjoeol/pen/BapdrZw)

## Tools

Some of the [tools](https://css-tricks.com/how-to-deal-with-vendor-prefixes/) that were created to solve issues with prefixing and browser support have fallen by the wayside. I would recommend checking first to see if a tool is up-to-date before using it.

Certainly, [Autoprefixer](https://github.com/postcss/autoprefixer) (a PostCSS plugin) is maintained and it uses data straight from caniuse to stay current.

[Emmet](https://emmet.io) also has great prefixing capabilities. Specifically, it has a `css.autoInsertVendorPrefixes` preference to automatically insert prefixes for you. I haven’t verified if it is current or not, but it is worth considering as part of your development environment.

Since most code editors support Emmet, it makes editing prefixed properties a lot easier. Emmet has a `CSS reflect value` command that updates the value of all prefixed versions of the same property in a rule. You can read the [Emmet docs](https://docs.emmet.io/css-abbreviations/vendor-prefixes/) for more info about the prefixing capabilities.

## Conclusion

Vendor prefixing is not dead, unfortunately. We are still living with the legacy. At the same time, we can be grateful that prefixed features are on a steady decline. Some good work has been done by browser vendors to implement unprefixed features in lieu of prefixed features. This has removed the brunt of the burden from developers.

However, you may bump into scenarios that require prefixes still from time to time. And if you want to support as many browsers as possible, you should continue with an auto-prefixing strategy.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
