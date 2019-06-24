> * 原文地址：[Integrating Third-Party Animation Libraries to a Project - Part 2](https://css-tricks.com/integrating-third-party-animation-libraries-to-a-project/)
> * 原文作者：[Travis Almand](https://css-tricks.com/author/travisalmand/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-2.md)
> * 译者：[Baddyo](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[lgh757079506](https://github.com/lgh757079506)

# 在项目中集成第三方动画库 —— 第二部分

> - [在项目中集成第三方动画库 —— 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-1.md)
> - [在项目中集成第三方动画库 —— 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-2.md)

## 过关斩将

在为本文查资料时，我发现第三方动画库中最常见的动画类型就是过渡动画（并非 CSS transition）了。有些简单的动画应用于元素出入页面的过程。现代单页应用中最司空见惯的模式就是让一个元素进入页面，顶替另一个离开页面的元素。想想这种情况：第一个元素淡出而第二个元素淡入。这个动画可以用于新旧数据交替、按顺序移动面板或切换路由到另一个页面。[Sarah Drasner](https://css-tricks.com/native-like-animations-for-page-transitions-on-the-web/) 和 [Georgy Marchuk](https://css-tricks.com/page-transitions-for-everyone/) 都列举了很多此类过渡动画的优秀案例。

大多数情况下，动画库不支持在过渡动画中添加或删除元素。用额外的 JavaScript 代码实现的库也许支持这样的功能，但毕竟这样的库很少见，因此我们现在就来讨论如何实现该功能。

### 插入单个元素

对于本例，我们继续使用 Animate.css,并会用到 fadeInDown 动画。

在 DOM 中插入元素有很多种方式，在此不再赘述。我仅会展示如何用动画优雅流畅地插入元素，而非让元素生硬地突现。对于 Animate.css（或其他类似的库）来说，这个功能十分简单。

```javascript
let insertElement = document.createElement('div');
insertElement.innerText = 'this div is inserted';
insertElement.classList.add('animated', 'fadeInDown');

insertElement.addEventListener('animationend', function () {
  this.classList.remove('animated', 'fadeInDown');
});

document.body.append(insertElement);
```

你如何创建该元素不重要，关键在于确保元素插入之前添加了所需的类。然后，此元素就会以优雅的动画登场。我还监听了 `animationend` 事件，用于移除动画类。通常来说，实现此效果的方式不一而足，而这种方式是最直接的方式了。移除动画类是为了方便实现退场效果。我们不想让退场动画和进场动画相互冲突。

### 移除单个元素

移除单个元素和插入大体类似。目标元素已经存在了，我们添加所需的动画类就好。然后在 `animationend` 事件触发时，我们把该元素从 DOM 中移除。在本例中，我们会使用 Animate.css 提供的 `fadeOutDown` 动画，因为它和 `fadeInDown` 动画是相互呼应的。

```javascript
let removeElement = document.querySelector('#removeElement');

removeElement.addEventListener('animationend', function () {
  this.remove();
});

removeElement.classList.add('animated', 'fadeOutDown');
```

如你所见，锁定目标元素、添加类以及在动画结束时移除元素，一气呵成。

这个过程会有一个问题，那就是随着目标元素的插入或移除，其他元素将会在页面中重排。我们需要去考虑使用 CSS 技术和一些布局方式去规避这个问题。

### 你方唱罢我登场

现在我们要切换两个元素，一进一出。条条大路通罗马，但我举的例子是上文中两个例子的结合。


参见 [CodePen](https://codepen.io) 上来自 Travis Almand（[@talmand](https://codepen.io/talmand)）的代码示例：[第三方动画库：双元素过渡](https://codepen.io/talmand/pen/JqPLbm/)。

我会把 JavaScript 代码分块来讲解其原理。首先，我们创建 button、container 变量分别存储对应的两个 DOM 节点。然后，我们创建 box1、box2 来存储在 container 中要交换的两个元素。

```javascript
let button = document.querySelector('button');
let container = document.querySelector('.container');
let box1 = document.createElement('div');
let box2 = document.createElement('div');
```

我写了一个通用函数，用来在每次触发 `animationEnd` 时移除动画类。

```javascript
let removeClasses = function () {
  box1.classList.remove('animated', 'fadeOutRight', 'fadeInLeft');
  box2.classList.remove('animated', 'fadeOutRight', 'fadeInLeft');
}
```

第二个函数则是切换功能的核心。首先，我们确定当前显示的是哪个元素。借此我们可以推断出哪个元素切入，哪个切出。切出元素用 `switchElements` 函数监听，预先移除动画类，避免陷入动画循环。然后，等切出元素的动画完成，我们将其从容器中移除。接下来，给切入元素添加动画类，并将其插入容器，让它以动画登场。

```javascript
let switchElements = function () {
  let currentElement = document.querySelector('.container .box');
  let leaveElement = currentElement.classList.contains('box1') ? box1 : box2;
  let enterElement = leaveElement === box1 ? box2 : box1;
  
  leaveElement.removeEventListener('animationend', switchElements);
  leaveElement.remove();
  enterElement.classList.add('animated', 'fadeInLeft');
  container.append(enterElement);
}
```

我们需要给两个盒子做一些通用设置。接着，将第一个盒子插入到容器中。

```javascript
box1.classList.add('box', 'box1');
box1.addEventListener('animationend', removeClasses);
box2.classList.add('box', 'box2');
box2.addEventListener('animationend', removeClasses);

container.appendChild(box1);
```

最后，给触发切换的按钮添加点击事件监听。这一系列事件的启动顺序取决于你。在本例中，我打算从按钮点击事件开始。我确定了正在显示的盒子 —— 即将切出的盒子，给它添加对应的类让它以动画切出。然后我监听切出元素的 `animationEnd` 事件，触发该事件会调用切实操纵切换的函数 —— 上面列出的 `switchElements` 函数。

```javascript
button.addEventListener('click', function () {
  let currentElement = document.querySelector('.container .box');
  
  if (currentElement.classList.contains('box1')) {
    box1.classList.add('animated', 'fadeOutRight');
    box1.addEventListener('animationend', switchElements);
  } else {
    box2.classList.add('animated', 'fadeOutRight');
    box2.addEventListener('animationend', switchElements);
  }
}
```

这个例子眼下有个问题：其代码是专门为这一情况写死的。当然了，它也很易于扩展，也能适应不同场景。故此，该例子只是用来理解如何实现这一功能的。还好，一些诸如 [MotionUI](https://zurb.com/playground/motion-ui) 这样的动画库支持用 JavaScript 操纵元素的过渡动画。另外，像 [VueJS](https://vuejs.org/v2/guide/transitions.html) 这类 JavaScript 框架也支持切换元素的过渡动画。

我在另一个例子中展示了一个更灵活的系统。它由一个容器构成，该容器存放着用 data 属性引用的切入和切出动画。容器中的两个元素按照命令切换位置。这个例子的原理是，通过 JavaScript 控制 data 属性可以轻松改变动画。Demo 中还有两个容器，一个用的是 Animate.css 实现动画；另一个用的则是 Animista。这个例子代码量较大，我将不在本文中讲解，但这个例子的注释很充足，感兴趣的话可以看看。

参见 [CodePen](https://codepen.io) 上来自 Travis Almand（[@talmand](https://codepen.io/talmand)）的代码示例：[第三方动画库：自定义动画示例](https://codepen.io/talmand/pen/mYdeBb/)。

## 停下来思考一下……

是所有人都想看到这些动画吗？可能有些人会觉得这些动画浮夸，没什么必要，而另一些人会认为这些动画会导致一些问题。就在前不久，WebKit 为了解决 [Vestibular Spectrum Disorder](https://alistapart.com/article/accessibility-for-vestibular/) 问题，引入了 [`prefers-reduced-motion`](https://webkit.org/blog/7551/responsive-design-for-motion/) 媒体查询功能。Eric Bailey 也针对该媒体查询功能发表了一篇[详尽的说明文章](https://css-tricks.com/introduction-reduced-motion-media-query/)，和[一篇关于最佳实践的跟进文章](https://css-tricks.com/revisiting-prefers-reduced-motion-the-reduced-motion-media-query/)。务必看看这些资料。

那么，你选择的动画库支持 `prefers-reduced-motion` 吗？如果官方文档没说能支持，那你最好假设不支持。就算官方文档语焉不详，你还可以查看动画库的代码来确定是否支持，这也容易。例如，Animate.css 在 [`_base.scss`](https://github.com/daneden/animate.css/blob/0ca8f2dc7c74c9e76b93bc378dad8b1cc1590dad/source/_base.css#L46) 文件中就有关于媒体查询的代码。

```css
@media (print), (prefers-reduced-motion) {
  .animated {
    animation: unset !important;
    transition: none !important;
  }
}
```

如果你选择的动画库不支持媒体查询，那么看到这里的代码，你也会知道如何自己动手写一个补丁。如果该库使用一个通用类 —— 比如 Animate.css 的 animated 类 —— 那你以这个通用类为目标就行了。如果没有这样一个通用类，那你可以选某个特定的动画类或者自己写一个来实现。

```css
.scale-up-center {
  animation: scale-up-center 0.4s cubic-bezier(0.390, 0.575, 0.565, 1.000) both;
}

@keyframes scale-up-center {
  0% { transform: scale(0.5); }
  100% { transform: scale(1); }
}

@media (print), (prefers-reduced-motion) {
  .scale-up-center {
    animation: unset !important;
    transition: none !important;
  }
}
```

可以看到，我比照 Animate.css 中的代码改造了 Animista 中的动画类。记住，你得把所选库中每个动画类都做这样的处理。在 Eric 的文章中，他建议[对所有动画都做渐进增强](https://css-tricks.com/revisiting-prefers-reduced-motion-the-reduced-motion-media-query/#article-header-id-4)，以此减少代码并提高用户体验。

## 让框架帮你干力气活

在很多方面，React、Vue 这些五花八门的框架，让第三方 CSS 动画库比原生 JavaScript 更加易用，因为你不需要手动接驳那些类或者 `animationend` 事件。你可以用框架提供的现成功能实现所需效果。使用框架的便利之处在于框架还提供多种操纵动画的方式，满足多种项目需求。下面的例子展示的只是冰山一角。

### hover 效果

对于 hover 效果，我建议用 CSS（一如上文中的建议）来设置会比较好。如果你确实需要在 Vue 之类的框架中用 JavaScript 实现，将会是这样：

```html
<button @mouseover="over($event, 'tada')" @mouseleave="leave($event, 'tada')">
  tada
</button>
```

```javascript
methods: {
  over: function(e, type) {
    e.target.classList.add('animated', type);
  },
  leave: function (e, type) {
    e.target.classList.remove('animated', type);
  }
}
```

和上面列举的原生 JavaScript 方案没有太多不同。 同样地，有很多办法实现该效果。

### 夺目动画（Attention seekers）

设置吸引用户注意力的动画效果非常容易。我们只需添加类名即可，仍然用 Vue 为例：

```html
<div :class="{animated: isPulse, pulse: isPulse}">pulse</div>

<div :class="[{animated: isBounce, bounce: isBounce}, 'infinite']">bounce</div>
```

在 pulse 效果中，当布尔变量 `isPulse` 的值为 true 时，就会给元素添加两个类名。在 bounce 效果中，当布尔变量 `isBounce` 的值为 true 时，就会给元素添加 `animated` 类和 `bounce` 类。`infinite` 这个类是默认启用的，这样在布尔变量 `isBounce` 的值变为 false 之前，bounce效果会一直持续。

### 过渡动画

幸好，Vue 的[过渡组件](https://vuejs.org/v2/guide/transitions.html)可以通过[自定义过渡类](https://vuejs.org/v2/guide/transitions.html#Custom-Transition-Classes)轻松支持第三方动画类。其他库 —— 比如 React —— 也有类似的[功能或插件](https://reactjs.org/docs/animation.html)。要在 Vue 中使用动画类，我们只需在过渡组件中实现即可。

```html
<transition
  enter-active-class="animated fadeInDown"
  leave-active-class="animated fadeOutDown"
  mode="out-in"
>
  <div v-if="toggle" key="if">if example</div>
  <div v-else key="else">else example</div>
</transition>
```

使用 Animate.css 时，我们仅仅使用必要的类即可。要实现 `enter-active` 效果，我们使用 `animated` 和 `fadeInDown` 即可。要实现 `leave-active` 效果，我们使用 `animated` 和 `fadeOutDown` 即可。在过渡过程中，这些类会在适当的时候插入。Vue 会替我们控制类的插入和移除。

想要了解关于在 JavaScript 框架中使用第三方动画库的更复杂的例子，请点击下方链接：

参见 [CodePen](https://codepen.io) 上来自 Travis Almand（[@talmand](https://codepen.io/talmand)）的代码示例：[KLKdJy](https://codepen.io/talmand/pen/KLKdJy/)。

## 来狂欢吧！

这只是一次小小的尝试，还有更多第三方 CSS 动画库等你去探索。有[详细完备](http://animista.net/play/basic)的，有[别出心裁](http://www.joerezendes.com/projects/Woah.css/)的，有[特色鲜明](http://ianlunn.github.io/Hover/)的，有[口味偏重](http://tholman.com/obnoxious/)的，也有[直接明了](https://daneden.github.io/animate.css/)的。还有针对复杂的 JavaScript 动画的库，例如 [Greensock](https://greensock.com/) 和 [Anime.js](https://animejs.com/)。甚至还有专门针对[字母动画](http://cssanimation.io/)的库。

真心希望这些库能够激发你的灵感，创造你自己的 CSS 动画。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
