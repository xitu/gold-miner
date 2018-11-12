> * 原文地址：[Everything you need to know about change detection in Angular](https://blog.angularindepth.com/everything-you-need-to-know-about-change-detection-in-angular-8006c51d206f)
> * 原文作者：[Max, Wizard of the Web](https://blog.angularindepth.com/@maxim.koretskyi?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/everything-you-need-to-know-about-change-detection-in-angular.md](https://github.com/xitu/gold-miner/blob/master/TODO1/everything-you-need-to-know-about-change-detection-in-angular.md)
> * 译者：[tian-li](https://github.com/tian-li)
> * 校对者：

# 关于 Angular 的变化检测，你需要知道的一切

## 探究内部实现和具体用例

![](https://cdn-images-1.medium.com/max/800/1*bB59KfaXSpZKoy234UJnTQ.jpeg)

* * *

如果你想我一样希望对 Angular 的变化检测机制有和全面的了解，你就不得不去查看源码，因为网上几乎没有这方面的文章。 大部分文章只是提到每个组件都有自己的用来检测组件变化的变化检测器，而且重点都在使用不可变变量（immutable）和变化检测策略（change detection strategy）上，但是没人进行更深入的探讨。这篇文章会带你一起了解*为什么*不可变变量可以出发变化检测以及变化监测策略*如何* 影响检测。另外，你从本文中学到的东西也会让你自己能想出来各种提升性能的场景。

本文包括两部分。第一部分比较偏技术，会有很多源码的链接。主要讲解变化检测机制是如何运作的。本文的内容是基于（当时的）最新版本——Angular 4.0.1。这个版本中的变化检测机制和 2.4.1 的有一点不同。如果你有兴趣的话，可以参考[Stack Overflow上的这个回答](http://stackoverflow.com/a/42807309/2545680)。

第二部分展示了如何应用变化检测。由于 2.4.1 和 4.0.1 的 API 没有发生变化，所以这一部分对于两个版本都适用。

* * *

### 核心概念：视图（view）

Angular 的教程上一直在说，一个 Angular 应用是一颗组件树。然而，在 Angular 内部使用的是一种叫做[视图（view）](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/types.ts#L301)的低阶抽象。视图和组件直接是有直接联系的——一个视图都有一个与之关联的组件，反之亦然。视图通过 `component` 属性将其与对应的组件类[关联](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/types.ts#L309)起来。所有的操作都在视图中执行，比如属性检查和更新 DOM。所以，从技术上来说，更正确的说法是：一个 Angular 应用是一颗视图树。组件可以描述为视图的更高阶的概念。关于视图，[源码](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/linker/view_ref.ts#L31)中有这样一段描述：

> 视图是构成应用 UI 的基本元素。它是一组一起被创造和销毁的最小合集。

> 视图的属性可以更改，而视图中元素的结构（数量和顺序）不能更改。想要改变元素的结构，只能通过用 `ViewContainerRef` 来插入、移动或者移除嵌入的视图。每个视图可以包含多个视图容器（View Container）

在这篇文章中，我会交替使用组件视图和组件的概念。

> 值得一提的是，网上有关变化检测文章和 StackOverflow 中的回答中，都把本文中的视图称为变化检测器对象（Change Detector Object）或者 ChangeDetectorRef。实际上，变化检测并没有单独的对象，它其实是在视图上运行的。

每个视图都通过 [`nodes` 属性](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/types.ts#L316)将其与子视图相关联，这样就能对子视图进行操作。

### 视图的状态

每个视图都有一个 [`state` 属性](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/types.ts#L317)。这是一个非常重要的属性，因为 Angular 会根绝这个属性的值来确定是否要对此视图和所有的子视图执行变化检测。`state` 属性有很多[可能的值](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/types.ts#L325)，与本文相关的有以下几种：

1.  FirstCheck
2.  ChecksEnabled
3.  Errored
4.  Destroyed

如果 `CheckesEnabled` 是 `false` 或者视图的状态是 `Errored` 或者 `Destroyed`，变化检测就会跳过此视图和其所有子视图。默认情况下，所有的视图都以 `ChecksEnabled` 作为初始值，除非使用了 `ChangeDetectionStrategy.OnPush`。后面会对此进行更多的解释。视图的可以同时有多个状态，比如，可以同时是 `FirstCheck` 和 `ChecksEnabled`。

Angular 中有很多高阶概念来操作视图。我在[这篇文章](https://hackernoon.com/exploring-angular-dom-abstractions-80b3ebcfc02)中讲过其中一些。其中一个概念是 [ViewRef](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/refs.ts#L219)。它封装了[底层组件视图](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/refs.ts#L221)，里面还有一个命名很恰当的方法，叫做 [`detectChanges`](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/refs.ts#L239)。当异步事件发生时，Angular 会在最顶层的 ViewRef 上[触发变化检测](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/application_ref.ts#L552.)。最顶层的 ViewRef 自己执行了变化检测后，就会**对其子视图进行变化检测**。

你可以使用 `ChangeDetectorRef` 令牌来将 `viewRef` 注入到组件的构造函数中：

```ts
export class AppComponent {
    constructor(cd: ChangeDetectorRef) { ... }
```

从其定义可以看出这点：

```ts
export declare abstract class ChangeDetectorRef {
    abstract checkNoChanges(): void;
    abstract detach(): void;
    abstract detectChanges(): void;
    abstract markForCheck(): void;
    abstract reattach(): void;
}
export abstract class ViewRef extends ChangeDetectorRef {
   ...
}
```

* * *

### 变化检测操作

执行变化检测的主要逻辑在 [`checkAndUpdateView`](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/view.ts#L325) 方法中。此方法主要是对**子**组件视图执行操作。而且会对从宿主组件开始的所有组件**递归地调用**此方法。也就是说，在下次递归中，子组件就变成了父组件。

当为某个视图触发这个方法时，会按照以下顺序执行操作：

1.  如果视图是第一次被检测，将 `ViewState.firstCheck` 设置为 `true`，如果之前已经检测过了，设置为 `false`
2.  [检查并更新](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/provider.ts#L154)子组件或子指令实例的输入属性
3.  [更新](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/provider.ts#L436)子视图的变化检测状态（这也是变化检测策略的一部分）
4.  对嵌入的视图[执行变化检测](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/view.ts#L327)（重复此列表中的步骤）
5.  如果绑定发生了改变，对子组件[调用](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/provider.ts#L202) `OnChanges` 生命周期钩子
6.  对子组件[调用](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/provider.ts#L202) `OnInit` 和 `ngDoCheck`（`OnInit` 只会在第一次检测时调用）
7.  [更新](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/query.ts#L91)子视图组件实例的 `ContentChildren` 查询列表
8.  对子组件实例[调用](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/provider.ts#L503) `AfterContentInit` 和 `AfterContentChecked` 生命周期钩子（`AfterContentInit` 只会在第一次检测时调用）
9.  如果**当前视图**组件实例的属性发生改变，[更新**当前视图**的 DOM 插值](https://hackernoon.com/the-mechanics-of-dom-updates-in-angular-3b2970d5c03d)
10.  对子视图[执行变化检测](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/view.ts#L541)（重复此列表中的步骤）
11.  [更新](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/query.ts#L91)当前试图组件实例的 `ViewChildren` 查询列表
12.  对子组件实例[调用](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/provider.ts#L503) `AfterViewInit` 和 `AfterViewChecked` 生命周期钩子（`AfterViewInit` 只在第一次检测时调用）
13.  [取消](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/view.ts#L346)对当前视图的检查（这也是变化检测策略的一部分）

对于上面的操作列表，以下几点值得一提：

首先，子组件会在子视图被检测之前触发 `onChanges` 生命周期钩子，哪怕子视图的变化检测被跳过了。这是十分重要的一点，之后我们会在第二部分中看到我们可以如何利用这一点。

第二，当检测视图时，更新视图的 DOM 是变化检测机制的一部分。也就是说，如果组件没被检测，DOM 也就不会更新，用于模板中的组件属性发生了变化。第一次检测之前，模板就已经被渲染好了。我所说的更新 DOM 其实是指更新插值。比如 `<span>some {{name}}</span>`，在第一次检测之前，就会把 DOM 元素 `span` 渲染好。检测过程中，只会渲染 `{{name}}` 部分。

再一个很有意思的是，子组件视图的状态可以在变化检测的时候改变。之前我提到所有的组件视图都默认初始化为 `ChecksEnabled`。但是所有使用 `OnPush` 策略的组件，在第一次检测之后，就不在进行变化检测了（列表中的第9步）：

```ts
if (view.def.flags & ViewFlags.OnPush) {
  view.state &= ~ViewState.ChecksEnabled;
}
```

也就是说，之后的变化检测，都会将它和它的子组件跳过。`OnPush` 的文档中说，只有在它的绑定发生变化时，才会执行检测。所以要设置 `CheckesEnabled` 位来启用检测。下面这段代码就是这个作用（第2步操作）：

```ts
if (compView.def.flags & ViewFlags.OnPush) {
  compView.state |= ViewState.ChecksEnabled;
}
```

只有当父视图的绑定发生了变化，且子组件视图初始化为 `ChangeDetectionStrategy.OnPush` 时，才会更新状态。

最后，当前视图的变化检测也负责启动子视图的变化检测（第8步）。此处会检查子组件视图的状态，如果是 `ChecksEnabled`，那么就对其执行变化检测。这是相关的代码：

```ts
viewState = view.state;
...
case ViewAction.CheckAndUpdate:
  if ((viewState & ViewState.ChecksEnabled) &&
    (viewState & (ViewState.Errored | ViewState.Destroyed)) === 0) {
    checkAndUpdateView(view);
  }
}
```

现在你知道了视图状态控制了是否对此视图和它的子视图进行变化检测。现那么问题来了——我们能控制这个状态吗？答案是可以，这也是本文第二部分要讲的。

有些生命周期钩子在更新 DOM 前调用（3, 4, 5），有些在之后（9）。比如有这样一个组件结构：`A -> B -> C`，它们的生命周期钩子调用和更新绑定的顺序是这样的：

```
A: AfterContentInit
A: AfterContentChecked
A: Update bindings
    B: AfterContentInit
    B: AfterContentChecked
    B: Update bindings
        C: AfterContentInit
        C: AfterContentChecked
        C: Update bindings
        C: AfterViewInit
        C: AfterViewChecked
    B: AfterViewInit
    B: AfterViewChecked
A: AfterViewInit
A: AfterViewChecked
```

* * *

### 总结

假设我们有如图所示的组件树

![](https://cdn-images-1.medium.com/max/800/1*aRo_mATLsi0B3p7E6Ndv4Q.png)

一颗组件树

根据前面说的，每个组件都有一个视图与之相关联。每一个视图都初始化为 `ViewState.ChecksEnabled`，也就是说当 Angular 进行变化检测时，这棵树中的每一个组件都会被检测。

假如我们想禁用 `AComponent` 和它的子组件的变化检测，只需要将 `ViewState.ChecksEnabled` 设置为 `false`。由于改变状态是低阶操作，所以 Angular 为我们提供了许多视图的公共方法。每个组件都可以通过 `ChangeDetectorRef` 令牌来获取与之相关联的视图。Angular 文档中对这个类定义了如下公共接口：

```ts
class ChangeDetectorRef {
  markForCheck() : void
  detach() : void
  reattach() : void
  
  detectChanges() : void
  checkNoChanges() : void
}
```

来看下我们可以如何使用这些接口。

#### detach

第一个允许我们操作状态的是 `detach`，它可以对当前视图禁用检查：

```ts
detach(): void { this._view.state &= ~ViewState.ChecksEnabled; }
```

来看下如何在代码中使用：

```ts
export class AComponent {
  constructor(public cd: ChangeDetectorRef) {
    this.cd.detach();
  }
```

这保证了在接下来的变化检测中，从 `AComponent` 开始，左子树都会被跳过（橙色的组件都不会被检测）：

![](https://cdn-images-1.medium.com/max/800/1*QtTCrT0cVGxoPJAapKGSAA.png)

这里需要注意两点——首先，尽管我们改变的是 `AComponent` 的状态，其所有子组件都不会被检测。第二，由于整个左子树的组件都不执行变化检测，它们模板中的 DOM 也不会更新。下面的例子简单描述了一下这种情况：

```ts
@Component({
  selector: 'a-comp',
  template: `<span>See if I change: {{changed}}</span>`
})
export class AComponent {
  constructor(public cd: ChangeDetectorRef) {
    this.changed = 'false';

    setTimeout(() => {
      this.cd.detach();
      this.changed = 'true';
    }, 2000);
  }
```

当组件第一次被检测时，`span` 就会被渲染成 `See if I change: false`。两秒之后，`changed` 属性变成了 `true`，`span` 中的文字并不会更新。然而，如果去掉 `this.cd.detach()`，就会按照预想的样子更新了。

#### reattach

如第一部分所说，如果 `AComponent` 的输入绑定 `aProp` 发生了变化，`AComponent` 的 `Onchanges` 声明周期钩子就会被触发。这意味着一旦我们得知输入属性发生了变化，就可以对当前组件启动变化检测器来检测变化，然后在下一个周期将其分离。这段代码就是这个作用：

```ts
export class AComponent {
  @Input() inputAProp;

  constructor(public cd: ChangeDetectorRef) {
    this.cd.detach();
  }

  ngOnChanges(values) {
    this.cd.reattach();
    setTimeout(() => {
      this.cd.detach();
    })
  }
```

由于 `reattach` 只是简单地[设置](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/refs.ts#L242) `ViewState.ChecksEnabled` 位：

```ts
reattach(): void { this._view.state |= ViewState.ChecksEnabled; }
```

这和将 `ChangeDetectionStrategy` 设置为 `OnPush` 的效果基本上是一样的：在第一次变化检测之后禁用检测，在父组件绑定的属性发生变化时启用，检测完之后再次禁用。

需要注意的是，`OnChanges` 钩子只会在禁用检测的子树的最顶端组件触发，并不会对整个子树的所有组件都触发。

#### markForCheck

`reattach` 方法只是对当前组件启用检测，如果它的父组件没有启用变化检测，就不会生效。也就是说 `reattach` 方法只对最禁用检测的子树的顶端组件有用。

我们需要一个能够检测所有父组件直到跟组件的方法。[这个方法](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/util.ts#L110)就是 `markForCheck`：

```ts
let currView: ViewData|null = view;
while (currView) {
  if (currView.def.flags & ViewFlags.OnPush) {
    currView.state |= ViewState.ChecksEnabled;
  }
  currView = currView.viewContainerParent || currView.parent;
}
```

从代码中可以看出，它只是简单地向上迭代直到根节点，将所有的父组件都启用检查。

那么什么时候能用到这个方法呢？和 `ngOnChanges` 一样，使用 `OnPush` 策略时也会 `ngDoCheck` 生命周期钩子。再说一次，只有禁用检查的子树的最顶端的组件会触发，子树里的其他组件都不会触发。但是我们可以使用这个钩子来执行一些自定义的逻辑，然后将组件标记为可以执行一次变化检测。由于 Angular 只检测对象引用，我们可以在此检查一下对象的属性：

```ts
Component({
   ...,
   changeDetection: ChangeDetectionStrategy.OnPush
})
MyComponent {
   @Input() items;
   prevLength;
   constructor(cd: ChangeDetectorRef) {}

   ngOnInit() {
      this.prevLength = this.items.length;
   }

   ngDoCheck() {
      if (this.items.length !== this.prevLength) {
         this.cd.markForCheck(); 
         this.prevLenght = this.items.length;
      }
   }
```

#### detectChanges

有一种方法可以对当前组件和所有子组件执行**一次**变化检测，这就是 `detectChanges` [方法](https://github.com/angular/angular/blob/6b79ab5abec8b5a4b43d563ce65f032990b3e3bc/packages/core/src/view/refs.ts#L239)。这个方法会对当前组件视图执行变化检测，不管组件的状态是什么。也就是说，视图仍会禁用检测，并且在接下来常规的变化检测中，不会检测此组件。比如：

```ts
export class AComponent {
  @Input() inputAProp;

  constructor(public cd: ChangeDetectorRef) {
    this.cd.detach();
  }

  ngOnChanges(values) {
    this.cd.detectChanges();
  }
```

尽管变化检测器引用仍保持分离，但 DOM 元素仍会随着输入绑定的变化而变化。

#### checkNoChanges

这是变化检测器的最后一个方法，其主要作用是保证当前执行的变化检测中，不会有变化发生。简单来说，它执行本文第一部分提到的列表中的第1、7、8步。如果发现绑定发生了变化或者 DOM 需要更新，就抛出异常。

* * *

### 还有疑问？

如果关于此文你又问题需要澄清，请到 Stack Overflow 提问，然后在本文评论区贴上链接。这样整个社区都能受益。谢谢。

### 请在 [Twitter](https://twitter.com/maxim_koretskyi) 和 [Medium](https://medium.com/@maxim.koretskyi) 上关注我以获得更多资讯

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
