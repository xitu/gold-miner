> * 原文地址：[Headless User Interface Components](https://medium.com/merrickchristensen/headless-user-interface-components-565b0c0f2e18)
> * 原文作者：[Merrick Christensen](https://medium.com/@iammerrick?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/headless-user-interface-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/headless-user-interface-components.md)
> * 译者：
> * 校对者：

# Headless User Interface Components

[Original Article](https://www.merrickchristensen.com/articles/headless-user-interface-components/)

A headless user interface component is a component that offers maximum visual flexibility by providing no interface. “Wait for a second, are you advocating a user interface pattern that doesn’t have a user interface?”

Yes. That is exactly what I’m advocating.

### Coin Flip Component

Suppose you had a requirement to implement a coin flip feature that performed some logic when it is rendered to emulate a coin flip! 50% of the time the component should render “Heads” and 50% of the time it should render “Tails”. You say to your product manager, “Oof that will take years of research!”, and you get to work.

```
const CoinFlip = () =>
 Math.random() < 0.5 ? <div>Heads</div> : <div>Tails</div>;
```

Turns out emulating coin flips is way easier than you thought so you proudly share the results. You get a response, “This is great! Could you please update it to show these cool coin images?”. No problem!

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

Soon, they’d like to use your `<CoinFlip />` component in the marketing material to show people how cool your new feature is. “We’d like to put in the blog post, but we need the labels “Heads” & “Tails” back, for SEO and stuff.” Oh man, I guess we’ll add a flag for the marketing site?

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

Later, a requirement emerges. “We were wondering if you could add a button to `<CoinFlip />`, but only in the application, to rerun the odds?”. Things are starting to get ugly, I can’t even look Kent C. Dodds in the eyes anymore:

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

Soon a co-worker reaches out to you. “Hey, your `<CoinFlip />` feature is rad! We just got assigned the new `<DiceRoll />` feature and we’d like to reuse your code!”. The new dice feature:

1. Wants to “re-run” the odds `onClick`.  
2. Wants to be displayed in the application and marketing site as well.  
3. Has a totally different interface.  
4. Has different odds.

You now have two options, replying “Sorry, not much to share here.” or adding `DiceRoll` complexity into `CoinFlip` as you watch the bones of your component break under the weight of its responsibility. (Is there a market for brooding programmer poets? I’d love to pursue that craft.)

### Enter Headless Components

Headless user interface components separate the logic & behavior of a component from its visual representation. This pattern works great when the logic of a component is sufficiently complex and decoupled from its visual representation. A headless implementation of `<CoinFlip/>` as [function as child component](https://www.merrickchristensen.com/articles/function-as-child-components/) or render prop would look like so:

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

This component is headless because it doesn’t render anything, it expects the various consumers to do the presentation work while it tackles the logic lifting. So the application code would look like so:

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

The marketing website code:

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

Isn’t this great! We’ve completely untangled the logic from the presentation! This gives us so much visual flexibility! I know what you’re thinking…

> You mindless sack of idiot! Isn’t that just a render prop?!

This headless component happens to be implemented as a render prop, yes! It could just as well be implemented as a higher order component. _Looks over my shoulder, in a hushed low tone._ It could have even been implemented as a `View` and a `Controller`. Or a `ViewModel` and a `View`. The point here is about separating the “mechanism” of flipping coins and the “interface” to that mechanism.

#### What about `<DiceRoll />`?

The neat thing about this separation is how easy it is to generalize our headless component to support our co-workers new `<DiceRoll />` feature. Hold my Diet Coke™:

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

With this headless component we can swap out the implementation of `<CoinFlip />` without any changes to its consumers:

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

Now our co-worker can share the mechanism of our `<Probability />` emulator!

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

Pretty neat, eh?

### Rule of Separation — Unix Philosophy

This is one expression of a general underlying principle, one that has been around for a very long time! Rule 4 of the “Basics of Unix Philosophy” is:

> Rule of Separation: Separate policy from mechanism; separate interfaces from engines. — Eric S. Raymond

I’d like to extract a portion of that book and replace the word “policy” with “interface”.

> _Interface_ and mechanism tend to mutate on different timescales, with _interfaces_ changing much faster than mechanism. Fashions in the look and feel of GUI toolkits may come and go, but raster operations and compositing are forever.

> Thus, hardwiring _interfaces_ and mechanisms together has two bad effects: It makes _interfaces_ rigid and harder to change in response to user requirements, and it means that trying to change _interfaces_ has a strong tendency to destabilize the mechanism.

> On the other hand, by separating the two we make it possible to experiment with new _interfaces_ without breaking mechanism. We also make it much easier to write good tests for the mechanism (_interfaces_, because _they_ age so quickly, often do not justify the investment).

I love the great insights here! This also gives us some insight as to when it is useful to use the headless component pattern.

1.  How long will this component live for? Is it worth deliberately preserving the mechanism aside from the interface? Perhaps to use this mechanism in another project with a different look and feel?
2.  How frequently is our interface bound to change? Will the same mechanism have multiple interfaces?

There is an indirection cost paid when you separate “mechanism” and “policy”. You need to be sure that the benefits of separation merit the expense of indirection. I think this is largely where a lot of the MV* patterns of the past went wrong, they started with the axiom that _everything_ should be separated this way; when in reality, mechanism and policy are often deeply coupled or the cost of separation doesn’t outweigh the benefits of this sort of separation.

### Open Source Headless Components & Non-Trivial References

For a truly exemplar non-trivial headless component, check out a project by my friend [Kent C. Dodds](https://kentcdodds.com/) over at Paypal called [downshift](https://github.com/paypal/downshift). In fact, it is downshift that ultimately inspired this post. Without providing any user interface, downshift offers sophisticated autocomplete/dropdown/select experiences that are accessible. Take a look at all the ways it can be used [here](http://downshift.netlify.com/?selectedKind=Examples&selectedStory=basic&full=0&addons=1&stories=1&panelRight=0).

I sincerely hope that more projects like downshift emerge over time. I can’t count how many times I’ve wanted to use a particular open source UI component but couldn’t because it wasn’t “themeable” or “skinnable” in the way that met design requirements. Headless components circumvent this problem entirely with a “bring your own interface” requirement.

In a world where design systems and user interface libraries are headless, your interfaces can have a high-end custom feel _and_ the durability & accessibility of a great open source library. You spend your time implementing the only part that you needed to, the part that is truly unique, the look and feel specific to your application.

I could go on about the benefits from internationalization to E2E test integration but I’d recommend you try it out for yourself.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
