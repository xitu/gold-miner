> * 原文地址：[Headless User Interface Components](https://medium.com/merrickchristensen/headless-user-interface-components-565b0c0f2e18)
> * 原文作者：[Merrick Christensen](https://medium.com/@iammerrick?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/headless-user-interface-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/headless-user-interface-components.md)
> * 译者：
> * 校对者：

# 无头用户界面组件

[原文](https://www.merrickchristensen.com/articles/headless-user-interface-components/)

无头用户界面组件是一种不提供任何接口而提供最大视觉灵活性的组件。“等等，你是在提倡没有用户界面的用户界面模式么？”

是的，这正是我所提倡的。

### Coin Flip 组件

假设你现在需要实现一个硬币翻转功能，该功能在呈现模拟硬币翻转时执行一些逻辑！50% 的时间组件应该渲染 “Heads”，50% 的时间应该渲染 “Tails”。你对你的产品经理说“这需要多年的研究！”然后你继续工作。

```
const CoinFlip = () =>
 Math.random() < 0.5 ? <div>Heads</div> : <div>Tails</div>;
```

事实证明，模仿硬币翻转比你想象的要容易得多，所以你可以自豪地分享成果。你得到了回复，“这真的是太棒了！请更新那些显示很酷的硬币的图片好么？”没问题！

```
const CoinFlip = () =>
 Math.random() < 0.5 ? (
   <div>
     <img src=”/heads.svg” alt=”Heads” />
   </div>
 ) : (
   <div>
     <img src=”/tails.svg” alt=”Tails” />
   </div>
 );
```

很快，他们会在营销材料中使用你的 `<CoinFlip />` 组件，来向人们演示你的新特性有多么炫酷。“我们想在博客上发表文章，但是我们需要标签 'Heads' 和 'Tails'，用于 SEO 和其他事情。”哦，天啊，或许我们需要在商城网站中添加一个标志？

```
const CoinFlip = (
 // We’ll default to false to avoid breaking the applications
 // current usage.
 { showLabels = false }
) =>
 Math.random() < 0.5 ? (
   <div>
     <img src=”/heads.svg” alt=”Heads” />

     {/* Add these labels for the marketing site. */}
     {showLabels && <span>Heads</span>}
   </div>
 ) : (
   <div>
     <img src=”/tails.svg” alt=”Tails” />

     {/* Add these labels for the marketing site. */}
     {showLabels && <span>Tails</span>}
   </div>
 );
```

后来，出现了一个需求。“我们像知道你能否在应用程序中的 `<CoinFlip />` 只添加一个用来 odds 的按钮？”事情开始变得糟糕，以致于我不敢在直视 Kent C. Dodds 的眼睛。

```
const flip = () => ({
  flipResults: Math.random()
});

class CoinFlip extends React.Component {
  static defaultProps = {
    showLabels: false,
    // We don’t repurpose `showLabels`, we aren’t animals, after all.
    showButton: false
  };

  state = flip();

  handleClick = () => {
    this.setState(flip);
  };

  render() {
   return (
     // Use fragments so people take me seriously.
     <>
     {this.state.showButton && (
       <button onClick={this.handleClick}>Reflip</button>
     )}
     {this.state.flipResults < 0.5 ? (
       <div>
         <img src=”/heads.svg” alt=”Heads” />
         {showLabels && <span>Heads</span>}
       </div>
     ) : (
       <div>
         <img src=”/tails.svg” alt=”Tails” />
         {showLabels && <span>Tails</span>}
       </div>
     )}
     </>
   );
 }
}
```

很快就有同事找到你。“嗨，你的 `<CoinFlip />` 性能太棒了！我们刚使用了新的 `<DiceRoll />` 特性，我们希望可以重用你的代码！”新骰子的功能：

1. 想要“重新运行”赔率的 `onClick`。  
2. 也希望在应用程序和商城网站中显示。
3. 有完全不同的界面。  
4. 有不同的赔率。

您现在有两个选项，回复“对不起，这里没有可以分享的。”或在你看到组件的骨架超出其职责范围时，向 `CoinFlip` 中添加 `DiceRoll` 的复杂性。（是否有一个给沉思的程序员诗人的市场？我喜欢追求这种技术。）

### 输入无头组件

无头用户界面组件将组件的逻辑和行为与其视觉表现分离。当组件的逻辑足够复杂并与它的视觉表现解耦时，这种模式非常有效。实现 `<CoinFlip/>` 的无头将作为[函数子组件](https://www.merrickchristensen.com/articles/function-as-child-components/)或渲染属性，就像这样：

```
const flip = () => ({
  flipResults: Math.random()
});
class CoinFlip extends React.Component {
  state = flip();
  handleClick = () => {
    this.setState(flip);
  };
  render() {
    return this.props.children({
      rerun: this.handleClick,
      isHeads: this.state.flipResults < 0.5
    });
  }
}
```

这个组件事无头的，因为它没有渲染任何东西，它期望不同消费者在处理逻辑提升时，同时进行演示。因此应用程序代码看起来应该是这样的：

```
<CoinFlip>
  {({ rerun, isHeads }) => (
   <>
     <button onClick={rerun}>Reflip</button>
     {isHeads ? (
       <div>
         <img src=”/heads.svg” alt=”Heads” />
       </div>
     ) : (
       <div>
         <img src=”/tails.svg” alt=”Tails” />
       </div>
     )}
   </>
  )}
</CoinFlip>
```

商场站点代码：

```
<CoinFlip>
 {({ isHeads }) => (
   <>
     {isHeads ? (
       <div>
         <img src=”/heads.svg” alt=”Heads” />
         <span>Heads</span>
       </div>
     ) : (
       <div>
         <img src=”/tails.svg” alt=”Tails” />
         <span>Tails</span>
       </div>
     )}
   </>
 )}
</CoinFlip>
```

这很好不是么！我们完全解开了演示中的逻辑！这给我们视觉上带来了很大的灵活性！我知道你正在思考什么......

> 你这小笨蛋，这不是一个渲染属性么？

这个无头组件恰好是作为渲染工具实现的，是的！它也可以作为一个高阶组件来实现。**即使是简单的实现，也可以到达我们的要求。**它甚至可以作为 `View` 和 `Controller` 来实现。或者是 `ViewModel` 和 `View`。这里的重点是将翻转硬币的机制和该机制的“界面”分离。

#### 那 `<DiceRoll />` 呢？

这种分离的巧妙之处在于，推广我们的无头组件以及支持我们同事的新的 `<DiceRoll />` 的特性会很容易。拿着我的 Diet Coke™：

```
const run = () => ({
  random: Math.random()
});

class Probability extends React.Component {
  state = run();

  handleClick = () => {
    this.setState(run);
  };

  render() {
    return this.props.children({
      rerun: this.handleClick,

      // By taking in a threshold property we can support
      // different odds!
      result: this.state.random < this.props.threshold
    });
  }
}
```

利用这个无头组件，我们在没有对消费者进行任何更改对情况下，交换 `<CoinFlip />` 的实现：

```
const CoinFlip = ({ children }) => (
 <Probability threshold={0.5}>
   {({ rerun, result }) =>
     children({
       isHeads: result,
       rerun
   })}
 </Probability>
);
```

现在我们的同事可以分享我们的 `<Probability />` 模拟程序机制了！

```
const RollDice = ({ children }) => (
  // Six Sided Dice
  <Probability threshold={1 / 6}>
    {({ rerun, result }) => (
      <div>
        {/* She was able to use a different event! */}
        <span onMouseOver={rerun}>Roll the dice!</span>
        {/* Totally different interface! */}
        {result ? (
          <div>Big winner!</div>
        ) : (
          <div>You win some, you lose most.</div>
        )}
      </div>
    )}
 </Probability>
);
```

非常干净，不是么？

### 分离规则 —— Unix 哲学

这表达了一个存在很长时间对普遍基本原则，“Unix 基础哲学对第四条”：

> 分离原则：将策略与机制分离，将接口和引擎分离 —— Eric S. Raymond

我想提取书中的部分，并将永“接口”来替换“策略”一词。

> **接口**和机制都倾向于在不同时间范围内变化，但**接口**的变化比机制要快得多。GUI 工具包多外观的时尚和使用感可能会变化，但是操作和组合却不会。

> 因此，硬件**接口**和机制结合在一起有两个不好的影响：它使得接口变的生硬，更难响应用户的需求，这意味着试图更改**接口**具有很强的不稳定性。

> 另一方面，通过将这两者分开，我们可以在没有中断机制的情况下试验新的**接口**。我们还可以更容易地为该机制编写好的测试（**接口**，因为**它们**太新了，难以证明这样的投资是合理的）。

我喜欢这里的真知灼见！这也让我们对何时使用无头组件模式有了一些了解。

1.  这个组件会持续多长时间？除了界面外，是否值得刻意保留这个机制？也许在另一个外观和感觉不同的项目中可以使用这种机制？
2.  我们的界面改变的频率多快？同一机制会有多个接口么？

当你将“机制”和“策略”分离时，就会产生间接的成本。你需要确保分离的好处应该是间接的代价。我认为这在很大程度上是过去许多 MV* 模式出问题的地方，它们从这样一个公理开始，即所有的东西都应该以这种方式分开；而在现实中，机制和策略往往是紧密耦合的，或分离的成本并没有超过分离的好处。

### 开源无头组件和非平凡引用

要获取一个真正的示例性非平凡无头组件，可以查看我朋友 [Kent C. Dodds](https://kentcdodds.com/) 在 Paypal 上一篇叫做 [downshift](https://github.com/paypal/downshift) 的文章。事实上，正是 downshift 给了这篇文章一些灵感。在不提供任何用户界面的情况下，downshift 提供了复杂的自动完成、下拉、选择体验，这些体验都是可以访问的。[在这里](http://downshift.netlify.com/?selectedKind=Examples&selectedStory=basic&full=0&addons=1&stories=1&panelRight=0)看看它可以使用的所以方法。

我希望随着时间的推移，会出现更多类似的项目。我无法计算有多少次我想使用一个特定的开源 UI 组件，但却无法这样做，因为在满足设计要求的方式上，它并不是“主题化的”或“可剥离的”。无头组件完全通过“自带接口”的要求来解决这个问题。

在一个设计系统和用户界面库都是无头的世界里，你的界面可以有一个高级定制感觉，**以及**优秀开源库的持久性和可访问性。你需要花费时间来实现你需要的唯一部分，真正独特的部分，以及特定于应用程序的外观和感觉。

我可以继续讨论从国际化到 E2E 测试集成的好处，但我建议你最好自己去体验。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
