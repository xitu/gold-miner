> * 原文地址：[如何编写更少的代码](http://www.heydonworks.com/article/on-writing-less-damn-code)
* 原文作者：[Heydon Pickering](http://www.heydonworks.com/about)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[circlelove](https://github.com/circlelove)
* 校对者：[MAYDAY1993](https://github.com/MAYDAY1993)，[cbangchen](https://github.com/cbangchen)

# 如何编写更少的代码

我不是世界上最有天赋的码神。是的，这是事实。所以我尽可能地减少代码量。我写的越少，需要破坏、解释和维护的地方就越少。

我也挺懒的，所以懒人有懒福（原文为it’s all gravy）。(_作者: 或许这里用了个关于食物的比喻?_)

但事实证明唯一可靠的方法来实现 Web 应用的性能优化也还是缩减代码量。削减？好。压缩？行吧。缓存？听起来有技术含量。完全拒绝写代码或者把别人的代码放在首位？ **这就对了。** 输入的东西要以某种方式输出，不论它是否被破坏还是被你的任务执行器的胃液消化成水了。(_作者: 我对这个食物的比喻改变了想法。_)



而且这还不是全部。不像那些为了‘看得见’的性能提升————你还是得发送一样的代码量，不过要先尝一口( _作者:严肃脸_ )————你可以实实在在地让你的 Web 应用 _方便_ 使用。我的数据协定不管你是发送多个小代码块还是一个大块；它都一律添加。

但是我_最喜欢的_削减代码的事情就是：你最终以你真正需要也就是的_用户_真正想要的东西实现代码功能。大口喝拿铁的大块头硬汉形象？别那样！让那些挂了一堆第三方代码的社交媒体按钮，同步地破坏你的页面设计？打发他们滚蛋。谁见过 JavaScript 的东西会劫持用户的右键按钮来显示一些自定义的模式？把他们送进冰月亮监狱。

这并不只是有关你加上的东西会不会破坏你的 UX 的问题。你写（自己）代码的_方法_也是简化它的一个重要组成。这里有几个小建议和想法或许能帮上忙。我过去曾经写过一些，但那是有关无障碍和响应设计的。一个灵活的无障碍的 Web 是我们努力发挥自己对代码量的控制的结果，也是为了减少破坏。

## 无障碍网页应用技术 (WAI-ARIA)

首先，辅助应用程序不等于 Web 的可访问性。它只是一个在需要的时候利用特定辅助技术（例如屏幕阅读）提升性能的工具。因此[ ARIA 使用第一守则](https://www.w3.org/TR/aria-in-html/#first-rule-of-aria-use) 就是 _不要_在不需要的使用使用 WAI-ARIA 。

LOL, 不要这样：

```

<div role="heading" aria-level="2">Subheading</div>

```

要这样:

```

<h2>Subheading</h2>

```

使用原生元素的好处就是你不用为自己的操作编写脚本了。不仅是下面的复选框执行冗长的 HTML ，还需要一个 JavaScript 的依赖来控制状态改变和 [follyfill](https://twitter.com/heydonworks/status/765444886099288064) 标准，有关 `name` 属性和 `GET` 的方法的基本行为。代码一多就不稳定。开心！
```

<div role="checkbox" aria-checked="false" tabindex="0" id="checkbox1" aria-labelledby="label-for-checkbox1"/>
<div class="label" id="label-for-checkbox1">My checkbox label</div>

```

[样式？不用担心，有人罩你](http://wtfforms.com/)。你真的需要自定义样式的话，随你。

```

<input type="checkbox" id="checkbox1" name="checkbox1">
<label for="checkbox1">My checkbox label</label>
```

## 网格
你还记得曾经享受使用/阅读一个多于两栏的网站表示的体验吗？我可没有。一次性给出太多的东西，渴望我的关注。“我想知道这一坨看起来像
是导航的东西到底哪个才是我要的导航？” 这是个反问：我的执行工作已经停滞，然后离开了网站。

当然有时候我想把一个东西和另一个挨着。比如搜索结果之类的。但是为什么要为了这么个东西拖了整个臃肿的样板框架呢？ Flexbox 用不了几个声明块就能解决。

```

.grid {
  display: flex;
  flex-flow: row wrap;
}

.grid > * {
  flex-basis: 10em;
  flex-grow: 1;
}

```

现在一切都 “flex” 到了 10 em 宽。列数取决于你能在视口里面放多少`10em`的单元格。搞定。继续。

哦还有，这时候我们需要谈谈下面这个东西：

```

width: 57.98363527356473782736464546373337373737%;

```

你知道这个精确的测量结果是从一个神秘的比例里面算出来的吗？是一种使你达到平静和敬畏状态的比例？不，我不知道也不感兴趣。把那个色情的按钮弄得大到我能找到就行。

## 外边距

[我们完成这些了](http://alistapart.com/article/axiomatic-css-and-lobotomized-owls)。使用通用选择器分享你的外边距元素定义。只在需要的时候添加重写。你不需要太多的。

```

body * + * {
  margin-top: 1.5rem;
}

```

不，通用选择器不会破坏你的性能。那是废话。

## 视图

你也不需要整个的 Angular 或者 Meteor 或者什么的来把简单的 web 页面分成一个个“视图”。视图也只是页面中可见的部分，而其余的看不见而已。 CSS 可以做到这些：

```

.view {
  display: none;
}

.view:target {
  display: block;
}

```

“但是单页应用加载了视图才运行项目！”我听到你会说这个。“那就是 `onhashchange` 的用处了。不需要库，以一个种标准的、可添加书签的方法是用链接。那就挺好。[如果你很感兴趣的话，关于这个技术还有更多介绍](https://www.smashingmagazine.com/2015/12/reimagining-single-page-applications-progressive-enhancement/).

## 字体大小

改变字号真的可以打消你的 `@media` 块。那就是你需要让 CSS 帮你关照一下的原因。只需一行代码：

```

font-size: calc(1em + 1vw);

```

额。。。就是这样。你甚至有一个最小的字体尺寸，手机上不会有这么小的字。感谢 [Vasilis](https://twitter.com/vasilis) 的分享。

## [10k Apart](https://a-k-apart.com/)

就像我说过的，我不是最好的码农。我只是懂得一些小技巧。但是这些小技巧真的可以办到很多大事情。这就是 [10k Apart competition](https://a-k-apart.com/) 的前提————发现我们可以用 10k 或者更少代码完成的事情。还有很多的大奖需要我们去赢取，作为一个内行，我期待鞭策自己看完所有的神奇的条目；我希望我能有这样的想法和执行。你有没有想做些什么呢？






