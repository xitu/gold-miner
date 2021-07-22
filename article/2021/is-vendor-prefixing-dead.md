> * 原文地址：[Is Vendor Prefixing Dead?](https://css-tricks.com/is-vendor-prefixing-dead/)
> * 原文作者：[Rob O'Leary](https://css-tricks.com/author/robjoeol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/is-vendor-prefixing-dead.md](https://github.com/xitu/gold-miner/blob/master/article/2021/is-vendor-prefixing-dead.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 浏览器引擎前缀的时代结束了吗？

让我们快速回忆一下记忆中的相关内容，重新审视 [浏览器引擎前缀](https://developer.mozilla.org/en-US/docs/Glossary/Vendor_Prefix) CSS 属性是如何形成的。我希望这不会让任何人触发 PTSD！

目前尚不清楚谁开始添加前缀，或者它何时开始，但很清楚的是，2006 年，Internet Explorer 和 Firefox 中都带有了前缀。前缀的**存在原因**是用于指定浏览器特定的功能。它被视为实现非标准功能并提供新标准功能预览的一种方式。

到 2012 年，W3C CSS 工作组发布了[浏览器引擎前缀使用指南](https://wiki.csswg.org/spec/vendor-prefixes)：

> 在 CSS 中，我们为属性、值和 `@-` 规则使用浏览器引擎前缀，它们是：—— 浏览器引擎前缀（根据 CSS 2.1），或 —— 实验性实现（根据 CSS Snapshot 2010）（例如在工作草案中）

成为了行业规范。前缀的数量增加了，随之而来的是事情变得混乱。它导致了 CSS 功能的部分实现，引入了错误，并最终在浏览器生态系统中造成了裂痕，这让开发者们感到不满。开发者们通过制作 [解决工具](https://css-tricks.com/how-to-deal-with-vendor-prefixes/) 来自动解决这些问题。

浏览器引擎慢慢开始摆脱前缀，转而支持浏览器设置中的功能 Flags。引擎前缀造成的问题似乎会随着时间而消失，但问题是：**我们现在到了结束浏览器引擎前缀的时候了吗？**

我对 [caniuse 数据集](https://github.com/Fyrd/caniuse)和 [Mozilla Developer Network Compat dataset](https://github.com/mdn/browser-compat-data) 做了一些分析来回答这个问题。

## 采用趋势

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/04/prefixing-history.png?resize=988%2C506&ssl=1)

我们可以在上图中看到各种主要浏览器的前缀功能实现趋势。由于数据不足，我已将 Chrome for Android 排除在外。

从 2007 年到 2011 年，所有浏览器中前缀功能的数量都在稳步增加。Internet Explorer 仅在 2011 年出现增长。然后，在 2012 年，Mozilla 开始从 Firefox 中删除前缀功能，例如 `-moz-border-radius*` 和 `-moz-box-shadow`。此后，一旦完全实现该属性的标准版本，他们就会始终删除前缀属性。

2013 年，Mozilla 开始[在功能 Flags（pref 标志）后提供功能](https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Releases/26#css)。同年，Chrome 将其渲染引擎从 WebKit 切换到 Blink（Chromium 项目的一部分）。这是删除一些前缀功能的一个重大转折点。

直到 2016 年 4 月，[WebKit 宣布不再发布带前缀的实验性功能](https://webkit.org/blog/6131/updating-our-prefixing-policy/)：

> 随着时间的推移，这种策略效果不佳。许多网站开始依赖于前缀属性。他们经常使用一个特性的每个前缀变体，这使得 CSS 的可维护性和 JavaScript 程序编写起来更加棘手。站点经常只使用功能的前缀版本，这使得浏览器在添加对无前缀标准版本的支持时很难放弃对前缀变体的支持。最终，浏览器因兼容性问题而感到压力，需要实现彼此的前缀。

由于 Safari 和 iOS 浏览器一直使用 WebKit 渲染引擎，因此这些浏览器后来一直在减少前缀数量。

微软从来没有在前缀上“疯狂”，并且始终拥有最少的前缀功能。2019 年，Edge 从自己的渲染引擎切换到 Blink。有趣的是，这一变化实际上增加了 Edge 中前缀属性的数量！

## 功能趋势

下表将 2013 年（前缀的顶峰）与 2021 年的前缀特征进行了对比。

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
<td>浏览器</td>
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
<td>一些需要的前缀</td>
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
<li><a href="https://caniuse.com/CSS%20grab%20&amp;%20grabbing%20cursors">CSS 光标：&nbsp;<code>grab</code>&nbsp;和&nbsp;<code>grabbing</code></a></li>
<li><a href="https://caniuse.com/CSS3%20Cursors:%20zoom-in%20&amp;%20zoom-out">CSS&nbsp;光标：<code>zoom-in</code> 和 <code>zoom-out</code> 光标</a></li>
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
<td>总计功能数量</td>
<td>53</td>
<td>35</td>
</tr>
</tbody>
</table>

看到原始数字可能会令人惊讶。**在 2013 年至 2021 年间，需要前缀的功能数量下降了约 33%**。这个数字对我来说听起来很谦虚。

当然，只关注数字可能会产生误导。影响各不相同。它可能是一系列都需要前缀的属性，例如 `animation`；或者它可能是一个只有一个属性或值需要前缀的特性，例如 `user-select: none`。让我们探索实际特征以更好地了解情况，首先看看在此期间发生了什么变化。

20 项功能不带前缀（在主要浏览器中完全实现），并引入了 3 项带前缀功能（`backdrop-filter`、CSS `text-orientation` 和 CSS `initial-letter`）。

在我看来，现在没有前缀的最显着的特征是：

1. CSS Flexible Box 布局模块
2. CSS3 Box Sizing
3. CSS Animation
4. CSS3 2D Transform
5. CSS3 3D Transform
6. CSS Filter

其他 14 个特征不太突出：

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
11. CSS `grab` 和 `grabbing` 光标
12. CSS 逻辑属性（以后会用到更多，现在支持更好了）
13. CSS3 `zoom-in` 和 `zoom-out` 光标
14. CSS3 多列布局

如果你选择在 2021 年不支持 Internet Explorer 11，那么另外七项功能不再需要前缀。这将 2021 年需要添加前缀的功能数量减少到 28 个，比 2013 年减少了 46%。

## 2021 年的前缀

让我们看看需要前缀的属性。这是一个杂七杂八的团体！

<table>
<thead>
<tr>
<th>#</th>
<th>名称</th>
<th>属性/取值</th>
<th>描述</th>
<th>需要前缀</th>
<th>支持不前缀</th>
<th>支持前缀</th>
<th>对前缀的改进</th>
</tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td><code><a href="https://caniuse.com/CSS%20Appearance">appearance</a></code></td>
<td><code>appearance</code></td>
<td>定义默认情况下元素（特别是表单控件）的显示方式。 将该值设置为 <code>none</code> 会导致使用其他 CSS 属性完全重新定义元素的默认外观。</td>
<td><ul><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Android Browser 2.1-4.4.4 <br>(<code>-webkit</code>)</li></ul></td>
<td>69.80%</td>
<td>97.03%</td>
<td>27.23%</td>
</tr>
<tr>
<td>2</td>
<td><code><a href="https://caniuse.com/background-clip-text">background-clip-text</a></code></td>
<td><code>background-clip: text</code></td>
<td>将背景图像剪切到前景文本的非标准方法。</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li></ul></td>
<td>3.89%</td>
<td>96.65%</td>
<td>92.76%</td>
</tr>
<tr>
<td>3</td>
<td><code><a href="https://caniuse.com/css-backdrop-filter">backdrop-filter</a></code></td>
<td><code>backdrop-filter</code></td>
<td>将滤镜效果（如 <code>blur</code>、<code>grayscale</code> 或 <code>hue</code>）应用于目标元素下方的内容或元素的方法。</td>
<td><ul><li>Safari <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li></ul></td>
<td>70.20%</td>
<td>88.20%</td>
<td>18.00%</td>
</tr>
<tr>
<td>4</td>
<td><code><a href="https://caniuse.com/css-cross-fade">background-image: crossfade()</a></code></td>
<td><code>background-image: crossfade()</code></td>
<td>在图像之间创建“交叉淡入淡出”的图像功能。 这允许一个图像根据百分比值过渡（淡入）到另一个图像。</td>
<td><ul><li>Chrome<br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li></ul></td>
<td>17.77%</td>
<td>92.62%</td>
<td>74.85%</td>
</tr>
<tr>
<td>5</td>
<td><code><a href="https://caniuse.com/css-image-set">background-image: image-set()</a></code></td>
<td><code>background-image: image-set()</code></td>
<td>让浏览器从给定的集合中选择最合适的 CSS 背景图像的方法，主要用于高 <abbr>PPI</abbr> 屏幕。</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>17.77%</td>
<td>92.48%</td>
<td>74.71%</td>
</tr>
<tr>
<td>6</td>
<td><code><a href="https://caniuse.com/css-boxdecorationbreak">box-decoration-break</a></code></td>
<td><code>box-decoration-break</code></td>
<td>控制一个盒模型的边距、边框、内边距和其他装饰在盒模型截断（如页面、列、区域或行）分割时是否包裹盒模型的片段。/td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android BrowserOpera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>6.39%</td>
<td>97.17%</td>
<td>90.78%</td>
</tr>
<tr>
<td>7</td>
<td><code><a href="https://caniuse.com/css-clip-path">clip-path</a></code></td>
<td><code>clip-path</code></td>
<td>使用 SVG 或形状定义定义 HTML 元素可见区域的方法。</td>
<td><ul><li>Safari <br>(<code>-webkit</code>)</li></ul></td>
<td>72.00%</td>
<td>96.33%</td>
<td>24.33%</td>
</tr>
<tr>
<td>8</td>
<td><code><a href="https://caniuse.com/css-color-adjust">color-adjust</a></code></td>
<td><code>color-adjust</code></td>
<td>可用于强制打印背景颜色和图像的非标准 CSS 扩展。</td>
<td><ul><li>Chrome <br>(<code>-webkit-print-color-adjust</code>)</li><li>Edge <br>(<code>-webkit-print-color-adjust</code>)</li><li>Safari <br>(<code>-webkit-print-color-adjust</code>)</li><li>Opera <br>(<code>-webkit-print-color-adjust</code>)</li><li>Android Mobile<br>(<code>-webkit-print-color-adjust</code>)</li></ul></td>
<td>3.69%</td>
<td>39.77%</td>
<td>36.08%</td>
</tr>
<tr>
<td>9</td>
<td><code><a href="https://caniuse.com/css-element-function">element()</a></code></td>
<td><code>background: element()</code></td>
<td>此函数呈现从任意 HTML 元素生成的实时图像</td>
<td><ul><li>Firefox <br>(<code>-moz</code>)</li></ul></td>
<td>0.00%</td>
<td>4.04%</td>
<td>4.04%</td>
</tr>
<tr>
<td>10</td>
<td><code><a href="https://caniuse.com/font-kerning">font-kerning</a></code></td>
<td><code>font-kerning</code></td>
<td>控制字体中存储的字母之间的间距的使用。请注意，这只会影响带有字距调整信息的 OpenType 字体，对其他字体没有影响。</td>
<td><ul><li>Safari iOS<br>(<code>-webkit</code>)</li></ul></td>
<td>81.73%</td>
<td>96.03%</td>
<td>14.30%</td>
</tr>
<tr>
<td>11</td>
<td><code><a href="https://caniuse.com/font-smooth">font-smooth</a></code></td>
<td><code>font-smooth</code></td>
<td>控制在呈现字体时如何应用抗锯齿。虽然出现在 2002 年初的 CSS3 字体规范草案中，但此属性已被删除，目前不在标准支持路径上。</td>
<td><ul><li>Chrome <br>(<code>-webkit-font-smoothing</code>)</li><li>Edge <br>(<code>-webkit-font-smoothing</code>)</li><li>Firefox <br>(<code>-moz-osx-font-smoothing</code>)</li><li>Safari <br>(<code>-webkit-font-smoothing</code>)</li><li>Opera <br>(<code>-webkit-font-smoothing</code>)</li></ul></td>
<td>0.00%</td>
<td>39.64%</td>
<td>39.64%</td>
</tr>
<tr>
<td>12</td>
<td><code><a href="https://caniuse.com/css-hyphens">hyphens</a></code></td>
<td><code>hyphens</code></td>
<td>控制行尾单词何时应如何连字符的方法。</td>
<td><ul><li>Internet Explorer 10+ <br>(<code>-ms</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li></ul></td>
<td>76.49%</td>
<td>96.51%</td>
<td>20.02%</td>
</tr>
<tr>
<td>13</td>
<td><code><a href="https://caniuse.com/css-initial-letter">initial-letter</a></code></td>
<td><code>initial-letter</code></td>
<td>创建扩大的 cap 的方法，包括变小或变大的 cap。</td>
<td><ul><li>Safari <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li></ul></td>
<td>0.00%</td>
<td>18.00%</td>
<td>18.00%</td>
</tr>
<tr>
<td>14</td>
<td><code><a href="https://caniuse.com/css-line-clamp">line-clamp</a></code></td>
<td><code>line-clamp</code></td>
<td>与 <code>display: -webkit-box</code> 结合使用时，包含给定行数的文本。 当包含 <code>text-overflow: ellipsis</code> 时，任何溢出空格的文本都会产生省略号。</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Firefox <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li><li>Firefox for Android <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>0.19%</td>
<td>96.28%</td>
<td>96.09%</td>
</tr>
<tr>
<td>15</td>
<td><code><a href="https://caniuse.com/css-sticky">position: sticky</a></code></td>
<td><code>position: sticky</code></td>
<td>将元素定位为“固定 fixed”或“相对 relative”，具体取决于它在视口中的显示方式。 结果，元素在滚动时“卡住”在原地。</td>
<td><ul><li>Safari 7.1-12.1 <br>(<code>-webkit</code>)</li></ul></td>
<td>93.50%</td>
<td>95.36%</td>
<td>1.86%</td>
</tr>
<tr>
<td>16</td>
<td><code><a href="https://caniuse.com/css3-tabsize">tab-size</a></code></td>
<td><code>tab-size</code></td>
<td>自定义 <kbd>Tab</kbd> 字符宽度的方法。 仅与 <code>white-space: pre</code> 或 <code>white-space: pre-wrap</code> 一起有效。</td>
<td><ul><li>Firefox 4+<br>(<code>-moz</code>)</li><li>Firefox for Android <br>(<code>-moz</code>)</li><li>Opera 11.5-12-1 <br>(<code>-o</code>)</li></ul></td>
<td>92.33%</td>
<td>97.38%</td>
<td>5.05%</td>
</tr>
<tr>
<td>17</td>
<td><code><a href="https://caniuse.com/text-decoration">text-decoration styling</a></code></td>
<td><code>text-decoration</code><br><code>text-decoration-*</code> properties.</td>
<td>在 <code>text-decoration</code> 属性中定义线条的类型、样式和颜色的方法。 这些可以定义为速记（例如 <code>text-decoration: line-through dashed blue</code>）或单个属性（例如 <code>text-decoration-color: blue</code>）。</td>
<td><ul><li>Firefox 6-35 <br>(<code>-moz</code>)</li><li>Safari 7.1+<br>(<code>-webkit</code>)</li><li>Safari for iOS 8+ <br>(<code>-webkit</code>)</li></ul></td>
<td>80.25%</td>
<td>94.86%</td>
<td>14.61%</td>
</tr>
<tr>
<td>18</td>
<td><code><a href="https://caniuse.com/text-emphasis">text-emphasis styling</a></code></td>
<td><code>text-emphasis</code><br><code>text-emphasis-*</code> properties</td>
<td>在每个字形旁边使用小符号来强调一系列文本的方法，常用于东亚语言。 <code>text-emphasis</code> 速记属性及其 <code>text-emphasis-style</code> 和 <code>text-emphasis-color</code> 组成属性可用于将标记应用于 文本。 单独继承的 <code>text-emphasis-position</code> 属性允许设置强调标记相对于文本的位置。</td>
<td><ul><li>Chrome 25+ <br>(<code>-webkit</code>)</li><li>Edge 79+<br>(<code>-webkit</code>)</li><li>Opera 15+<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>21.96%</td>
<td>95.99%</td>
<td>74.03%</td>
</tr>
<tr>
<td>19</td>
<td><code><a href="https://caniuse.com/css-text-orientation">text-orientation</a></code></td>
<td><code>text-orientation</code></td>
<td>指定行内文本的方向。当前值仅在垂直排版模式下有效（使用 <code>writing-mode</code> 属性定义）。</td>
<td>Safari <br>(<code>-webkit</code>)</td>
<td>90.88%</td>
<td>94.84%</td>
<td>3.96%</td>
</tr>
<tr>
<td>20</td>
<td><code><a href="https://caniuse.com/text-size-adjust">text-size-adjust</a></code></td>
<td><code>text-size-adjust</code></td>
<td>控制是否以及如何将文本膨胀算法应用于它所应用到的元素的文本内容。</td>
<td><ul><li>Edge 12-18 <br>(<code>-ms</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Firefox for Android <br>(<code>-moz</code>)</li></ul></td>
<td>72.75%</td>
<td>87.48%</td>
<td>14.73%</td>
</tr>
<tr>
<td>21</td>
<td><code><a href="https://caniuse.com/user-select-none">user-select: none</a></code></td>
<td><code>user-select</code></td>
<td>防止文本或元素选择的方法。</td>
<td><ul><li>Internet Explorer 10-11 <br>(<code>-ms</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser 2.1-4.4.4 <br>(<code>-webkit</code>)</li></ul></td>
<td>74.81%</td>
<td>96.49%</td>
<td>21.68%</td>
</tr>
<tr>
<td>22</td>
<td><a href="https://caniuse.com/css-canvas">CSS Canvas Drawings</a></td>
<td><code>background: -webkit-canvas(mycanvas)</code></td>
<td>使用 HTML5 Canvas 作为背景图像的方法。目前不属于任何规范。</td>
<td><ul><li>Safari <br>(<code>-webkit</code>)</li></ul></td>
<td>0.00%</td>
<td>19.40%</td>
<td>19.40%</td>
</tr>
<tr>
<td>23</td>
<td><a href="https://caniuse.com/css-masks">CSS Masks</a></td>
<td><code>mask mask-*</code> properties</td>
<td>显示元素的一部分的方法，使用选定的图像作为蒙版。</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Safari iOSAndroid Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul><p>Partial support in WebKit/Blink browsers refers to supporting the <code>mask-image</code> and <code>mask-box-image</code> properties, but lacking support for other parts of the spec.</p></td>
<td>4.18%</td>
<td>96.93%</td>
<td>92.75%</td>
</tr>
<tr>
<td>24</td>
<td><a href="https://caniuse.com/css-reflections">CSS Reflections</a></td>
<td><code>-webkit-box-reflect</code></td>
<td>显示元素反射的方法。</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>0.00%</td>
<td>91.20%</td>
<td>91.20%</td>
</tr>
<tr>
<td>25</td>
<td><a href="https://caniuse.com/css-scrollbar">CSS Scrollbar Styling</a></td>
<td><code>scrollbar-color</code><br><code>scollbar-width</code></td>
<td>给滚动条颜色和宽度添加样式的方法。</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li></ul></td>
<td>4.28%</td>
<td>96.87%</td>
<td>92.59%</td>
</tr>
<tr>
<td>26</td>
<td><a href="https://caniuse.com/text-stroke">CSS Text Fill &amp; Stroking</a></td>
<td><code>text-stroke</code><br><code>text-stroke-*</code> properties</td>
<td>声明文本轮廓（描边）宽度和颜色的方法。</td>
<td><ul><li>Chrome <br>(<code>-webkit</code>)</li><li>Edge <br>(<code>-webkit</code>)</li><li>Firefox <br>(<code>-webkit</code>)</li><li>Safari <br>(<code>-webkit</code>)</li><li>Opera <br>(<code>-webkit</code>)</li><li>Safari iOS<br>(<code>-webkit</code>)</li><li>Android Browser <br>(<code>-webkit</code>)</li><li>Chrome for Android <br>(<code>-webkit</code>)</li><li>Firefox for Android <br>(<code>-webkit</code>)</li><li>Opera Mobile <br>(<code>-webkit</code>)</li></ul></td>
<td>0.00%</td>
<td>96.65%</td>
<td>96.65%</td>
</tr>
<tr>
<td>27</td>
<td><a href="https://caniuse.com/intrinsic-width">Intrinsic &amp; Extrinsi Sizing</a></td>
<td><code>max-content</code><br><code>min-content</code><br><code>fit-content</code><br><code>stretch</code> (formerly <code>fill</code>).</td>
<td>允许以本身指定的值而不是固定数值指定元素的高度和宽度。</td>
<td><ul><li>Chrome 22-45 <br>(<code>-webkit</code>)</li><li>Edge 3-65<br>(<code>-webkit</code>)</li><li>Firefox (-moz-available)</li><li>Opera 15-32 <br>(<code>-webkit</code>)</li><li>Safari 6.1-10-1 <br>(<code>-webkit</code>)</li><li>Safari iOS 7-13.7 <br>(<code>-webkit</code>)</li><li>Androind Browser 4.4-4.4.4 <br>(<code>-webkit</code>)</li></ul></td>
<td>91.99%</td>
<td>96.36%</td>
<td>4.37%</td>
</tr>
<tr>
<td>28</td>
<td><a href="https://caniuse.com/css-media-resolution">Media Queries: Resolution Feature</a></td>
<td><code>@media (min-resolution: 300dpi)</code> { … }, <code>@media (max-resolution: 300dpi) { … }</code></td>
<td>允许根据每个 CSS 单元使用的设备像素设置媒体查询。 虽然标准使用 <code>min-resolution</code> 和 <code>max-resolution</code>，但一些浏览器支持旧的非标准 <code>device-pixel-ratio</code> 媒体查询。</td>
<td><ul><li>Chrome 4-28 <br>(<code>-webkit</code>)</li><li>Safari 4+ <br>(<code>-webkit</code>)</li><li>Opera 10-11.5 <br>(<code>-webkit</code>)</li><li>Safari iOS <br>(<code>-webkit</code>)</li><li>Android Browser (2.3-4.3) Opera Mobile 12 <br>(<code>-webkit</code>)</li><li>Firefox 3.5-15 <br>(<code>min--moz-device-pixel-ratio</code>)</li></ul><p>Browsers that support <code>-webkit</code> support the non-standard <code>-webkit-min-device-pixel-ratio</code> and <code>webkit-min-device-pixel-ratio</code>.</p></td>
<td>80.40%</td>
<td>99.16%</td>
<td>18.76%</td>
</tr>
</tbody>
</table>

把这个清单放在一起后，我的初步印象是这些不是我经常碰到的东西。一些属性还没有 —— 很可能不会 —— 完全实现。我会说 `element()` 函数和 CSS Canvas 绘图属于该类别。Safari 最近删除了 `position: sticky` 的前缀，因此它可能很快就会从列表中消失。

如果你愿意，你可以筛选列表并避开某些情况。你可以忽略它并说它不重要，那何必呢？现实情况是，该列表仍然足够长，以至于你不想在代码中手动管理前缀。一个需要回答的相关问题是：你是否想将跨浏览器支持提高到一个高水平吗？如果答案是肯定的，那么你应该将其视为开发工作的一部分。

同样重要的是要记住，这不仅仅与这些属性和当前浏览器有关。仍然有人使用带有旧浏览器的旧设备，这些设备不支持某些功能的无前缀版本。以 `animation` 属性为例， Chrome 是 2015 年最后一个取消前缀的浏览器。然而，今天，全球仍有 1.3% 的用户仍在使用不支持无前缀版本的浏览器。

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/04/caniuse-css-animation.png?resize=1998%2C314&ssl=1)

我最近遇到了几种需要前缀属性的情况。例如，我正在制作[我的博客的阅读进度条](https://roboleary.net/programming/2020/04/21/pimp-blog.html) 并且需要使用 `-webkit-appearance: none; ` 和 `-moz-appearance: none;` 来重置 `progress` 元素的默认样式。它还需要粘性定位，所以我不得不在 `position:sticky` 前缀以支持 Safari 中的粘性定位。

[CodePen robjoeol/bGVpePR](https://codepen.io/robjoeol/pen/bGVpePR)

另一个例子？我想使用 PNG 图像作为圣诞节主题设计的蒙版图像，发现 `-webkit-mask-image` 是唯一可以正常工作的属性。蒙版通常有点不稳定，因为大多数浏览器仅部分支持该规范。

[CodePen robjoeol/WNojGdm](https://codepen.io/robjoeol/pen/WNojGdm)

这是另一个：Flavio Copes 在[“如何在 CSS 中对多行应用填充”](https://flaviocopes.com/css-padding-multiple-lines/) 中写道，他希望拥有相同的填充在多行标题的每一行上。解决方案是使用 `box-decoration-break: clone`。大多数浏览器需要此属性的 `-webkit` 前缀版本，因此我们还是需要使用前缀。

[CodePen robjoeol/BapdrZw](https://codepen.io/robjoeol/pen/BapdrZw)

## 工具

为解决前缀和浏览器支持问题而创建的一些 [工具](https://css-tricks.com/how-to-deal-with-vendor-prefixes/) 已经咕咕咕了，我建议在使用之前先检查工具是否是最新的。

当然，[Autoprefixer](https://github.com/postcss/autoprefixer)（一个  PostCSS 插件）得到了维护，它直接使用来自 caniuse 的数据来保持最新。

[Emmet](https://emmet.io) 也有强大的前缀功能。具体来说，它有一个 `css.autoInsertVendorPrefixes` 首选项，可以自动为你插入前缀。我还没有验证它是否是最新的，但作为开发环境的一部分值得考虑。

由于大多数代码编辑器都支持 Emmet，因此可以更轻松地编辑前缀属性。 Emmet 有一个“CSS 反映值”命令，用于更新规则中相同属性的所有前缀版本的值。你可以阅读 [Emmet 文档](https://docs.emmet.io/css-abbreviations/vendor-prefixes/) 了解有关前缀功能的更多信息。

## 结论

不幸的是，浏览器引擎前缀并没有消亡。我们仍然生活在这遗留问题中。与此同时，我们很高兴前缀功能总数正在稳步下降，浏览器引擎已经做了一些很好的工作来实现无前缀的功能来代替有前缀的功能，这直接减轻了开发人员的负担。

但是，你可能会不时遇到仍然需要前缀的场景。如果你想支持尽可能多的浏览器，你应该继续使用自动前缀策略。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
