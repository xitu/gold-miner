> * 原文地址：[CSS in 3D: Learning to Think in Cubes Instead of Boxes](https://css-tricks.com/css-in-3d-learning-to-think-in-cubes-instead-of-boxes/)
> * 原文作者：[Jhey Tompkins](https://css-tricks.com/author/jheytompkins/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/css-in-3d-learning-to-think-in-cubes-instead-of-boxes.md](https://github.com/xitu/gold-miner/blob/master/article/2021/css-in-3d-learning-to-think-in-cubes-instead-of-boxes.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# CSS 中的 3D：学习去以立方体而不是盒子的方式考虑问题

我学习 CSS 的道路有点不正统。我不是从前端开发人员开始的，而是一名 Java 开发人员。事实上，我最早对 CSS 的回忆是在 Visual Studio 中为挑选颜色。

直到后来我才开始解决并找到我对前端的热爱。探索 CSS 是后话了。当它完全出现在我世界中时，大概已经是 CSS3 蓬勃发展的时候了。3D 和动画是这个街区的酷孩子，他们几乎塑造了我对 CSS 的学习。他们吸引我并*塑造*了（双关语）我，让对 CSS 的理解比其他东西更重要，比如布局、颜色等。

我的意思是我每一分钟都在做关于 CSS 3D 事情。与你花费大量时间处理的任何事情一样，随着你在这一技能上的磨练，你最终会在多年内完善你的处理能力。这篇文章介绍了我目前是如何处理 CSS 3D 的，并介绍了一些可能对你有所帮助的提示和技巧！

[Codepen jh3y/mLaXRe](https://codepen.io/jh3y/pen/mLaXRe)

## 一切都是长方体

对于 3D 中大多数的情况，我们可以使用长方体。我们当然可以创建更复杂的形状，但它们通常需要更多考虑。圆滑弯曲的部分特别的难，有一些处理它们的技巧（我们稍后会做详细介绍）。

我们不会介绍如何在 CSS 中制作长方体。你可以参考 [Ana Tudor 的帖子](https://css-tricks.com/simplifying-css-cubes-custom-properties/)，或者看一下我制作的这个[制作长方体的截屏](https://css-tricks.com/wp-content/uploads/2020/10/use-css-transforms-to-create-configurable-3d-cuboids.mp4)。

这里的核心是我们需要使用一个元素来包裹我们的长方体，然后在其中转换六个元素，让每个元素都充当我们长方体的一面。其中，应用 `transform-style:preserve-3d` 是很重要的，而且将它应用于任何地方也不是一个坏主意。当形状变得更复杂时，我们很可能会处理嵌套的长方体。在浏览器之间切换去尝试去调试一个缺失的 `transform-style` 可能会很痛苦。

```css
* {
    transform-style: preserve-3d;
}
```

[Codepen jh3y/QWELPQg](https://codepen.io/jh3y/pen/QWELPQg)

对于我们的 3D 创作而言，远不止是常见的那几样形状。请尝试想象由长方体构建的整个场景，比如说，让我作一个真实的例子，请考虑在页面上渲染一本 3D 的图书，其中包含四个长方体。正反封面各一个、书脊一个、个书页一张。使用 `background-image` 为我们完成剩下的工作。

[Codepen jh3y/ZEOzNbm](https://codepen.io/jh3y/pen/ZEOzNbm)

## 设置场景

我们将使用像乐高积木这样的长方体。但是，我们可以通过设置场景和创建平面来让我们的生活更轻松一些。那个平面是我们的创作所在的地方，让我们更容易旋转和移动整个创作。

[Codepen jh3y/pobzmNx](https://codepen.io/jh3y/pen/pobzmNx)

对我来说，当我创建一个场景时，我喜欢先在 X 和 Y 轴上旋转它。然后我会用 `rotateX(90deg)` 把它平放。这样，当我想在场景中添加一个新的长方体时，我可以直接将新元素添加到平面元素中。我将在这里做的另一件事是在所有长方体上设置 `position: absolute`。

```css
.plane {
    transform: rotateX(calc(var(--rotate-x, -24) * 1deg)) rotateY(calc(var(--rotate-y, -24) * 1deg)) rotateX(90deg) translate3d(0, 0, 0);
}
```

## 从样板开始

在平面上创建各种大小的长方体会导致每次创建都需要大量重复的代码。出于这个原因，我使用 Pug 通过 mixin 创建我的长方体。如果您不熟悉 Pug，我写了一个 [5 分钟的介绍](https://dev.to/jh3y/pug-in-5-minutes-272k)。

一个典型的场景是这样的：

```pug
//- Front
//- Back
//- Right
//- Left
//- Top
//- Bottom
mixin cuboid(className)
  .cuboid(class=className)
    - let s = 0
    while s < 6
      .cuboid__side
      - s++
.scene
  //- Plane that all the 3D stuff sits on
  .plane
    +cuboid('first-cuboid')
```

至于 CSS，我的长方体类的样式代码目前看起来像这样：

```css
.cuboid {
    /* 默认样式 */
    --width: 15;
    --height: 10;
    --depth: 4;
    height: calc(var(--depth) * 1vmin);
    width: calc(var(--width) * 1vmin);
    transform-style: preserve-3d;
    position: absolute;
    font-size: 1rem;
    transform: translate3d(0, 0, 5vmin);
}

.cuboid > div:nth-of-type(1) {
    height: calc(var(--height) * 1vmin);
    width: 100%;
    transform-origin: 50% 50%;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) rotateX(-90deg) translate3d(0, 0, calc((var(--depth) / 2) * 1vmin));
}

.cuboid > div:nth-of-type(2) {
    height: calc(var(--height) * 1vmin);
    width: 100%;
    transform-origin: 50% 50%;
    transform: translate(-50%, -50%) rotateX(-90deg) rotateY(180deg) translate3d(0, 0, calc((var(--depth) / 2) * 1vmin));
    position: absolute;
    top: 50%;
    left: 50%;
}

.cuboid > div:nth-of-type(3) {
    height: calc(var(--height) * 1vmin);
    width: calc(var(--depth) * 1vmin);
    transform: translate(-50%, -50%) rotateX(-90deg) rotateY(90deg) translate3d(0, 0, calc((var(--width) / 2) * 1vmin));
    position: absolute;
    top: 50%;
    left: 50%;
}

.cuboid > div:nth-of-type(4) {
    height: calc(var(--height) * 1vmin);
    width: calc(var(--depth) * 1vmin);
    transform: translate(-50%, -50%) rotateX(-90deg) rotateY(-90deg) translate3d(0, 0, calc((var(--width) / 2) * 1vmin));
    position: absolute;
    top: 50%;
    left: 50%;
}

.cuboid > div:nth-of-type(5) {
    height: calc(var(--depth) * 1vmin);
    width: calc(var(--width) * 1vmin);
    transform: translate(-50%, -50%) translate3d(0, 0, calc((var(--height) / 2) * 1vmin));
    position: absolute;
    top: 50%;
    left: 50%;
}

.cuboid > div:nth-of-type(6) {
    height: calc(var(--depth) * 1vmin);
    width: calc(var(--width) * 1vmin);
    transform: translate(-50%, -50%) translate3d(0, 0, calc((var(--height) / 2) * -1vmin)) rotateX(180deg);
    position: absolute;
    top: 50%;
    left: 50%;
}
```

默认情况下，它给了我这样的东西：

[Codepen jh3y/abZorVz](https://codepen.io/jh3y/pen/abZorVz)

## 由 CSS 变量提供支持

你可能已经注意到我在 CSS 代码中使用了一些 CSS 变量（也称为自定义属性）。这很大程度上节省了我的时间。我用了不少 CSS 变量助力构建我的长方体。

* `--width`：平面上长方体的宽度
* `--height`：平面上长方体的高度
* `--depth`：平面上长方体的深度
* `--x`: 平面上的 X 位置
* `--y`: 平面上的 Y 位置

我主要使用 `vmin` 作为我的大小调整单位，以保持响应式布局。如果我正在创建需要缩放的东西，我可能会创建一个响应式单位。我们在[上一篇文章](https://css-tricks.com/advice-for-complex-css-illustrations/)中提到了这种技术。我再次将形状放平，现在我可以将我的长方体称为具有高度、宽度和深度的形状了。下面的演示展示了我们如何在平面上移动一个长方体来改变它的尺寸。

[Codepen jh3y/BaKqQLJ](https://codepen.io/jh3y/pen/BaKqQLJ)

## 使用 dat.GUI 调试

您可能已经注意到我们介绍的一些演示右上角的小面板。那是 [dat.GUI](https://github.com/dataarts/dat.gui)。这是一个轻量级的 JavaScript 控制器库，对于调试 CSS 3D 来说非常有用。不用太多代码，我们就可以设置一个面板，允许我们在运行时更改 CSS 变量。我喜欢做的一件事是使用面板在 X 和 Y 轴上旋转平面。这样，就可以看到事情如何排列或在我们一开始可能看不到的部分上工作。

```javascript
const {
    dat: {GUI},
} = window
const CONTROLLER = new GUI()
const CONFIG = {
    'cuboid-height': 10,
    'cuboid-width': 10,
    'cuboid-depth': 10,
    x: 5,
    y: 5,
    z: 5,
    'rotate-cuboid-x': 0,
    'rotate-cuboid-y': 0,
    'rotate-cuboid-z': 0,
}
const UPDATE = () => {
    Object.entries(CONFIG).forEach(([key, value]) => {
        document.documentElement.style.setProperty(`--${key}`, value)
    })
}
const CUBOID_FOLDER = CONTROLLER.addFolder('Cuboid')
CUBOID_FOLDER.add(CONFIG, 'cuboid-height', 1, 20, 0.1)
    .name('Height (vmin)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'cuboid-width', 1, 20, 0.1)
    .name('Width (vmin)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'cuboid-depth', 1, 20, 0.1)
    .name('Depth (vmin)')
    .onChange(UPDATE)
// 在这里你有一个选择，可以使用 x||y
// 或者使用标准的带有 vmin 的 transform
CUBOID_FOLDER.add(CONFIG, 'x', 0, 40, 0.1)
    .name('X (vmin)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'y', 0, 40, 0.1)
    .name('Y (vmin)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'z', -25, 25, 0.1)
    .name('Z (vmin)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'rotate-cuboid-x', 0, 360, 1)
    .name('Rotate X (deg)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'rotate-cuboid-y', 0, 360, 1)
    .name('Rotate Y (deg)')
    .onChange(UPDATE)
CUBOID_FOLDER.add(CONFIG, 'rotate-cuboid-z', 0, 360, 1)
    .name('Rotate Z (deg)')
    .onChange(UPDATE)
UPDATE()
```

如果您观看此推文中的延时摄影视频。您会注意到我在构建场景时经常旋转平面。

[@jh3yy 的一份推文](https://twitter.com/jh3yy/status/1312126353177673732?s=20)

dat.GUI 代码有点重复。我们可以创建接受配置并生成控制器的函数，不过需要稍加修改才能满足你的需求。我开始在 [这个演示](https://codepen.io/jh3y/pen/GRJoWyp) 中使用了动态生成的控制器。

## 居中

你可能已经注意到，默认情况下，每个长方体都位于平面下方和上方的一半。这是我故意设置的，也是我最近才开始做的事情。为什么？因为我们想使用长方体的包含元素作为长方体的中心，而这能够让动画变得更容易。特别是，如果我们考虑绕 Z 轴旋转。我在创建 `CSS is Cake` 时发现了这一点。制作蛋糕后，我决定让每一片蛋糕都是能够交互的，然后我不得不返工更改我的实现，以修复翻转的蛋糕片的旋转中心。

[Codepen jh3y/KKVGoGJ](https://codepen.io/jh3y/pen/KKVGoGJ)

在这里，我拆分了该演示的显示中心以及偏移中心，展示这些会如何影响效果。

[Codepen jh3y/XWKrLwe](https://codepen.io/jh3y/pen/XWKrLwe)

## 定位

如果我们正在处理一个更复杂的场景 —— 我们可能会将其拆分为不同的部分。这就是子平面的概念派上用场的地方。考虑这个演示，我在其中重新创建了我的个人工作区。

[@jh3yy 的一份推文](https://twitter.com/jh3yy/status/1310658720746045440?s=20)。

这里发生了很多事情，很难跟踪所有的长方体。为此，我们可以引入子平面。让我们分解那个演示。椅子有自己的子平面。这使得在场景中移动和旋转它变得更容易 —— 除其他外 —— 而不影响其他任何东西。事实上，我们甚至可以在不移动椅子脚的情况下旋转顶部！

[Codepen jh3y/QWELerg](https://codepen.io/jh3y/pen/QWELerg)

## 美学

一旦我们有了一个结构，就该研究美学了。这一切都取决于你在做什么。但是您可以通过使用某些技术获得一些快速的胜利。我倾向于从让事情变得“丑陋”开始，然后回去为所有颜色创建 CSS 变量并应用它们。特定事物的三种阴影使我们能够在视觉上区分长方体的侧面。考虑这个烤面包机的例子，让我们使用三种色调覆盖烤面包机的侧面：

[Codepen jh3y/KKVjLrx](https://codepen.io/jh3y/pen/KKVjLrx)

我们之前的 Pug mixin 允许我们为长方体定义类名。将颜色应用到一侧通常看起来像这样：

```css
/* 正面使用线性渐变来应用微光效果 */
.toaster__body > div:nth-of-type(1) {
    background: linear-gradient(120deg, transparent 10%, var(--shine) 10% 20%, transparent 20% 25%, var(--shine) 25% 30%, transparent 30%), var(--shade-one);
}

.toaster__body > div:nth-of-type(2) {
    background: var(--shade-one);
}

.toaster__body > div:nth-of-type(3),
.toaster__body > div:nth-of-type(4) {
    background: var(--shade-three);
}

.toaster__body > div:nth-of-type(5),
.toaster__body > div:nth-of-type(6) {
    background: var(--shade-two);
}
```

在我们的 Pug mixin 中包含额外的元素有点棘手。但是我们不要忘记，我们长方体的每一面都提供了两个伪元素。我们可以将这些用于各种细节。例如，烤面包机插槽和侧面的手柄插槽是伪元素。

另一个技巧是使用 `background-image` 来添加细节。例如，考虑 3D 工作区。我们可以使用背景层来创建阴影。我们可以使用实际图像来创建纹理表面。地板和地毯是重复的 `background-image`。事实上，对纹理使用伪元素是很棒的，因为我们可以在需要时转换它们，比如旋转平铺图像。我还发现，在某些情况下，直接使用长方体侧面工作时会出现渲染上的闪烁。

[Codepen jh3y/XWdQBRx](https://codepen.io/jh3y/pen/XWdQBRx)

将图像用于纹理的一个问题是我们如何创建不同的阴影。我们需要色调来区分不同的侧面，这就是 `filter` 属性可以提供帮助的地方。让我们将 `brightness()` 过滤器应用于长方体的不同侧面使它们变亮或变暗。考虑这个 CSS 翻转桌子，所有的表面都使用纹理图像。但是为了区分侧面，我们在上面应用了亮度过滤器。

[Codepen jh3y/xJXvjP](https://codepen.io/jh3y/pen/xJXvjP)

如何使用有限的元素集来创建形状——或者我们想要创建的看似不可能的特征？有时我们可以用一点烟雾和镜像效果来欺骗眼睛。我们可以提供一种伪造的 3D 感觉。[Z dog library](https://zzz.dog) 做得很好，就是一个很好的例子。

考虑一下我们现在有一捆气球，固定它们的绳子使用了正确的视角，并且每个绳子都有自己的旋转、倾斜等的效果。但气球本身是平的。如果我们旋转平面，气球会保持反平面旋转。这给人一种“虚假”的 3D 感觉，试用演示并解决这一问题。

[Codepen jh3y/NWNVgJw](https://codepen.io/jh3y/pen/NWNVgJw)

有时需要一点开箱即用的思考。我在构建 3D 工作空间时有人向我建议种一些室内植物。在我房间里的确重了一些植物，但我最初的想法是，“不，我可以做一个方形的锅，我怎么做所有的叶子？”实际上，我们也可以在这个上使用一些视觉上的技巧。我们可以获取一些叶子或植物的图片，使用 [remove.bg](https://www.remove.bg) 之类的工具删除背景，然后将许多图像放置在同一位置，但将它们每个旋转一定量。现在，当它们旋转时，我们就能够得到 3D 植物的感觉。

[Codepen jh3y/oNLNZMR](https://codepen.io/jh3y/pen/oNLNZMR)

## 处理尴尬的形状

笨拙的形状很难以通用的方式覆盖，每个创作都有自己的障碍。但是，有几个示例可以帮助您提供解决问题的想法。我最近看了一篇关于【乐高界面面板的 UX】的[文章](https://www.designedbycave.co.uk/2020/LEGO-Interface-UX/)。事实上，将 CSS 3D 像乐高玩具一样处理并不是一个坏主意。但是乐高界面面板是我们可以用 CSS 制作的形状（除去螺柱 —— 我最近才知道这是螺栓的名称）。这是一个长方体，然后我们可以裁剪顶面，使端面透明，并旋转一个伪元素将其连接起来。我们可以使用伪元素添加一些背景层的细节。快来尝试在下面的演示中打开和关闭线框。如果我们想要形状的确切高度和角度，我们可以使用一些数学来构建斜边等。

[Codepen jh3y/PozojYe](https://codepen.io/jh3y/pen/PozojYe)

另一个尴尬的事情是曲线 —— 球形不被 CSS 支持。在这一点上，我们有多种选择，一种选择是接受这一事实并创建边数有限的多边形，而另一种是创建圆形并使用我们在植物中提到的旋转方法。这些选项中的每一个都可以工作。但同样，它是基于用例的，各有利弊。有了多边形，我们在使用了很多的元素的情况下，我们几乎可以得到一条曲线，而后者可能会导致性能问题。使用透视技巧，我们最终也可能会遇到性能问题。我们也放弃了设计形状“侧面”的能力，因为没有适宜的方法。

[Codepen jh3y/wvWvqqM](https://codepen.io/jh3y/pen/wvWvqqM)

## 与 Z 轴作斗争

最后但并非最不重要的是与 Z 轴作斗争。这是平面上的某些元素可能重叠或导致我们不希望看到的渲染闪烁的地方。很难给出很好的例子，也没有通用的解决方案。这是要根据具体情况来解决的问题。主要策略是根据需要对 DOM 中的事物进行排序，但有时这不是唯一的问题。

做得准确有时也会导致问题，让我们再次参考 3D 工作区的案例。想一想墙上的画布，其中的阴影是一个伪元素。如果我们将画布正好靠在墙上，我们就会遇到问题。如果我们这样做，阴影和墙壁将争夺渲染上的层次问题。为了解决这个问题，我们可以稍微应用 translate。这将解决问题，可以有效声明应该放在前面的内容。

[Codepen jh3y/PozoYWK](https://codepen.io/jh3y/pen/PozoYWK)

尝试在打开和关闭“画布偏移”的情况下调整此演示的大小。注意没有偏移时阴影是如何闪烁的？那是因为阴影和墙壁在争夺层次。偏移量将 `--x` 设置为我们命名为 `--cm` 的 `1vmin` 的一小段长度，即用于该创作的响应单位。

## 就是这样

我们现在可以将我们的 CSS 带到另一个维度 —— 3D。使用我的一些技巧，找到属于你自己的技巧，分享这些技巧，并分享你的 3D 创作！是的，在 CSS 中制作 3D 东西可能很困难，但绝对是一个我们可以随着我们进行而改进的能力。不同的方法适用于不同的人，耐心是必需的成分。我很想知道你的方法是什么！

最重要的事情？其实还是玩得开心，哈哈哈！

[Codepen jh3y/MWeWvGO](https://codepen.io/jh3y/pen/MWeWvGO)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
