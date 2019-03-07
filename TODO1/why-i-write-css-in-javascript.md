> * 原文地址：[Why I Write CSS in JavaScript](https://mxstbr.com/thoughts/css-in-js/)
> * 原文作者：[max stoiber](https://mxstbr.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-i-write-css-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-i-write-css-in-javascript.md)
> * 译者：
> * 校对者：

# Why I Write CSS in JavaScript

For three years, I have styled my web apps without any `.css` files. Instead, I have written all the CSS in JavaScript.

I know what you are thinking: “why would anybody write CSS in JavaScript?!” Let me explain.

### What Does CSS-in-JS Look Like?

Developers have created [different flavors of CSS-in-JS](https://github.com/michelebertoli/css-in-js). The most popular to date, with over 20,000 stars on GitHub, is a library I co-created, called [styled-components](https://styled-components.com).

Using it with React looks like this:

```
import styled from 'styled-components'

const Title = styled.h1`
  color: palevioletred;
  font-size: 18px;
`

const App = () => (
  <Title>Hello World!</Title>
)
```

This renders a palevioletred `<h1>` with a font size of 18px to the DOM:

![](https://user-images.githubusercontent.com/26959437/53942001-9c4cfd80-40f4-11e9-80ad-5cc9a4c35c4e.png)

### Why I like CSS-in-JS

Primarily, **CSS-in-JS boosts my confidence**. I can add, change and delete CSS without any unexpected consequences. My changes to the styling of a component will not affect anything else. If I delete a component, I delete its CSS too. No more [append-only stylesheets](https://css-tricks.com/oh-no-stylesheet-grows-grows-grows-append-stylesheet-problem/)! ✨

**Confidence**: Add, change and delete CSS without any unexpected consequences and avoid dead code.

**Painless Maintenance**: Never go on a hunt for CSS affecting your components ever again.

Teams I have been a member of are especially benefitting from this confidence boost. I cannot expect all team members, particularly juniors, to have an encyclopedic understanding of CSS. On top of that, deadlines can get in the way of quality.

With CSS-in-JS, we automatically sidestep common CSS frustrations such as class name collisions and specificity wars. This keeps our codebase clean and lets us move quicker. 😍

**Enhanced Teamwork**: Avoid common CSS frustrations to keep a neat codebase and moving quickly, regardless of experience levels.

Regarding performance, CSS-in-JS libraries keep track of the components I use on a page and only inject their styles into the DOM. While my `.js` bundles are slightly heavier, my users download the smallest possible CSS payload and avoid extra network requests for `.css` files.

This leads to a marginally slower time to interactive, but a much quicker first meaningful paint! 🏎💨

**Fast Performance**: Send only the critical CSS to the user for a rapid first paint.

I can also easily adjust the styles of my components based on different states (`variant="primary"` vs `variant="secondary"`) or a global theme. The component will apply the correct styles automatically when I dynamically change that context. 💅

**Dynamic Styling**: Simply style your components with a global theme or based on different states.

CSS-in-JS still offers all the important features of CSS preprocessors. All libraries support auto-prefixing, and JavaScript offers most other features like mixins (functions) and variables natively.

* * *

I know what you are thinking: “Max, you can also get these benefits with other tools or strict processes or extensive training. What makes CSS-in-JS special?”

CSS-in-JS combines all these benefits into one handy package and enforces them. It guides me to the [pit of success](https://blog.codinghorror.com/falling-into-the-pit-of-success/): doing the right thing is easy, and doing the wrong thing is hard (or even impossible).

### Who Uses CSS-in-JS?

Thousands of companies use CSS-in-JS in production, including [Reddit](https://reddit.com), [Patreon](https://patreon.com), [Target](https://target.com), [Atlassian](https://atlaskit.atlassian.com), [Vogue](https://vogue.de), [GitHub](https://primer.style/components), [Coinbase](https://pro.coinbase.com), and many more. ([including this website](https://github.com/mxstbr/mxstbr.com))

### Is CSS-in-JS For You?

If you are using a JavaScript framework to build a web app with components, CSS-in-JS is probably a good fit. Especially if you are part of a team where everybody understands basic JavaScript.

If you are not sure how to get started, I would recommend trying it out and seeing for yourself how good it feels! ✌️

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
