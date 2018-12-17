> * 原文地址：[Make a Native Web Component with Custom Elements v1 and Shadow DOM v1](https://bendyworks.com/blog/native-web-components)
> * 原文作者：[Pearl Latteier](https://bendyworks.com/blog/authors/pearl_latteier)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/native-web-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/native-web-components.md)
> * 译者：[newraina](https://github.com/newraina)
> * 校对者：[CoderMing](https://github.com/CoderMing)

# 用 Shadow DOM v1 和 Custom Elements v1 实现一个原生 Web Component

* * *

![](https://bendyworks.com/assets/images/blog/2017-05-04-native-web-components-80f1a357.png)

假如你有一个小表单或者组件要在网站的好几个地方或者好几个项目里用，你希望它们都能有统一的样式和行为，但是，你也希望它们能有些灵活性：也许你的表单需要根据容器元素的不同有各种大小，或者组件要在不同的项目里显示不同的文字和图标。你知道你需要什么吗？你需要一个 web component！

Web components 是可以重用和共享的自定义 HTML 元素。和原生 HTML 元素一样，它们有属性，有方法，有事件监听器，能嵌套，[能兼容各种 JavaScript 框架](https://medium.com/dev-channel/custom-elements-that-work-anywhere-898e1dd2bc48)。

怎么样，是不是很厉害？没有 jQuery，没有难以维护的面条代码，它就是一个良好封装过的带 UI 和功能的组件了。

## 介绍一下 Mini-Form 组件

我们要实现一个叫 “mini-form” 的 web component。（Custom element 的名字必须用小写字母开头，并且至少有一个连字符。要了解更多可以阅读[相关标准](https://html.spec.whatwg.org/multipage/scripting.html#valid-custom-element-name)。）它是一个很简单的表单组件：让用户提交投诉意见，并且能确认是否收到了用户的输入（实际上并不真的干什么）。这个组件能自适应它容器元素的大小和标题的长度。它有一个基本的 [material design](https://material.io/guidelines/material-design/introduction.html) 样式；你可以给每个组件实例指定颜色主题。组件的代码托管在 [https://github.com/pearlbea/mini-form](https://github.com/pearlbea/mini-form)，在线示例请见[这里](https://mini-form-demo.firebaseapp.com/)。

## 定义 Custom Element

Web components 可以用一些新的 [web 标准](https://www.webcomponents.org/specs)来实现。其中最重要的是最新修订过的 Custom Elements 标准。（要了解更多关于新的 Custom Elements V1 标准，可以阅读 Eric Bidelman 的[文章](https://developers.google.com/web/fundamentals/getting-started/primers/customelements)）要创建一个 custom element，我们需要两个东西：一个定义元素行为的类，以及一个告诉浏览器如何关联 DOM 元素标签和刚才那个类的定义。新建一个叫 `mini-form.js` 的文件，把下面的类和定义代码放进去：

```
class MiniForm extends HTMLElement {
  constructor() {
    super();
  }
}
window.customElements.define('mini-form', MiniForm);
```

constructor 里，对 `super()` 不带参数的调用必须放在第一行。它会为组件设置正确的原型链和 `this` 的值。（更多信息可以参考 Mozilla Developer Network [关于 super 的文章](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/super)。）

## 其他准备工作

新建文件的时候，还要创建：一个 `index.html`，用来实际引用组件；一个 `mini-form-test.html`，用来写测试用例，因为组件是你写的。先在这两个文件里写上基本的 HTML5 样板代码。

你还需要一些 polyfill。我们使用的 web 标准非常新，[还没被所有浏览器支持](https://caniuse.com/#search=custom%20elements%20v1)，至少到目前为止，polyfill 是必须的。对于我们这个简单的组件，只需要两个 polyfill：[custom elements](https://github.com/webcomponents/custom-elements) 和 [shadydom](https://github.com/webcomponents/shadydom)，可以用 Bower 安装：

```
bower install --save webcomponents/custom-elements
bower install --save webcomponents/shadydom
```

把这两个 polyfills 放在 `index.html` 和 `mini-form-test.html` 的 head 里，（或者用你习惯的构建工具打包在一起，都行，无所谓。）同时，也要把 `mini-form.js` 引用进每一个 HTML 文件里。`index.html` 现在差不多是下面的样子：

```
<!doctype html>
<html lang="eng">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, minimum-scale=1, initial-scale=1, user-scalable=yes">
    <script src="bower_components/shadydom/shadydom.min.js"></script>
    <script src="bower_components/custom-elements/custom-elements.min.js"></script>
    <script src="mini-form.js"></script>
  </head>
  <body></body>
</html>
```

注意：shadydom polyfill 要放在 custom elements polyfill 前面。不然，你可能会看到 `Element#attachShadow` 不存在的报错。（猜猜我是怎么知道的。）shadow DOM 的其他内容后面再说。

## 编写测试用例

在真的开始写组件之前，我们先写一些测试。我们要测试这个组件能不能在 DOM 中渲染出一个 `div`，现在它还通不过测试，毕竟我们的组件还几乎不存在。不过，一旦我们渲染出了一个 `div` 元素，我们就能体会到目睹测试通过的乐趣。

测试差不多是这个样子：

```
suite('<mini-form>', () => {
  let component = document.querySelector('mini-form');
  test('renders div', () => {
    assert.isOk(component.querySelector('div'));
  });
});
```

为了运行测试，我们要用到 [Polymer Project](https://www.polymer-project.org/) 创建的 [web component tester](https://github.com/Polymer/web-component-tester) 工具。用 NPM 安装好 web-component-tester 之后，在 `mini-form-test.html` 文件的 head 标签里加上 `node_modules/web-component-tester/browser.js`，polyfills 和 `mini-form.js` 也应该在页面上了。

你还要在 body 里加上 mini-form 的实例，就像这样：

```
<body>
  <mini-form></mini-form>
  <script>
    suite('<mini-form>', function() {
      let component = document.querySelector('mini-form');
      test('renders div', () => {
        assert.isOk(component.shadowRoot.querySelector('div'));
      });
    });
  </script>
</body>
```

好了，跑测试吧！在命令行中输入 `wct`，[web component tester](https://github.com/Polymer/web-component-tester) 会启动你安装的所有浏览器运行测试。然后，你会看到一个测试失败的提示：

```
✖ test/mini-form-test.html » <mini-form> » renders div expected null to be truthy
```

如果你遇到了其他问题，可以在[这里](https://github.com/pearlbea/mini-form/tree/step-1)看看到这一步，你的代码应该是什么样子。

## 编写模版

现在我们可以来扩充组件的实现并让测试通过了。

```
class MiniForm extends HTMLElement {

  constructor() {
    super();
  }

  connectedCallback() {
    this.innerHTML = this.template;
  }

  get template() {
    return `
      <div>This is a div</div>
    `;
  }
}
```

上面的代码新增了一个返回最简单模板的 getter。然后，在 `connectedCallback` 中，模板赋给了组件的 innerHTML。`connectedCallback` 方法是[custom element 生命周期](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Custom_Elements/Custom_Elements_with_Classes)的一部分，当组件插入到 DOM 中时会被调用。

再跑一遍测试，噢耶！这次肯定能通过！当然，这个组件最后不会仅仅只显示一个 div。我们要写更多的测试，看着它们测试失败，再靠代码实现让它们最终都能通过。

```
// mini-form-test.html
test('renders input', function() {
  assert.isOk(component.querySelector('input[type="text"]'));
});

test('renders button', function() {
  assert.isOk(component.querySelector('button'));
});

// mini-form.js
get template() {
  return `
    <div>
      <input type="text" name="complaint" />
      <button>Submit</button>
    </div>
  `;
}
```

## 增加样式和 Shadow DOM

到目前为止，mini-form 组件还不是很好看，是时候加一点样式了。不管用在哪里，组件的样式都应该在所有的实例间保持统一。我们并不希望组件所在页面的 CSS 或者 JS 会影响到组件，也不希望组件的样式或行为影响到了它所处的页面。可以通过把组件的内容封装在 [Shadow DOM](https://developers.google.com/web/fundamentals/getting-started/primers/shadowdom) 里来实现这一点。

Shadow DOM 和你早已熟悉和喜爱的 DOM 很像。它有相同的树形结构和工作方式，只是：它不会和父级 DOM 相互影响；也不会成为它所附属元素的子元素。

我们要修改 mini-form 来让它支持 Shadow DOM。

```
connectedCallback() {
  this.initShadowDom();
}

initShadowDom() {
  let shadowRoot = this.attachShadow({mode: 'open'});
  shadowRoot.innerHTML = this.template;
}
```

我们不再把模板内容直接赋给组件自身的 innerHTML，而是创建一个 shadowRoot 作为中介：给组件关联上一个 Shadow DOM，然后把模板内容赋给这个 Shadow DOM 的 innerHTML。

这样做会破坏掉所有的测试，不过，改起来也很简单，只要在 DOM 查询上加上刚定义过的 shadowRoot 即可。

```
test('renders div', () => {
  assert.isOk(component.shadowRoot.querySelector('div'));
});
test('renders input', () => {
  assert.isOk(component.shadowRoot.querySelector('input'));
});
test('render button', () => {
  assert.isOk(component.shadowRoot.querySelector('button'));
});
```

跑一遍测试，确保全都通过之后，我们来加上 [Material Design](https://getmdl.io/) 的样式。

```
<style>
  @import 'https://fonts.googleapis.com/icon?family=Material+Icons';
  @import 'https://code.getmdl.io/1.3.0/material.indigo-pink.min.css';
  @import 'http://fonts.googleapis.com/css?family=Roboto:300,400,500,700';
  .mdl-card {
    width: 100%;
  }
  .mdl-button {
    margin-top: 10px;
  }
  i {
    margin-right: 5px;
  }
</style>
<div class="mdl-card mdl-shadow--2dp">
  <header class="mdl-layout__header">
    <div class="mdl-layout__header-row">
      <i class="material-icons">mood_bad</i>
      <div class="mdl-layout-title">complaint box</div>
    </div>
  </header>
  <div class="mdl-card__supporting-text">
    <input type="text" class="mdl-textfield__input" />
  </div>
  <div class="mdl-card__actions">
    <button class="mdl-button mdl-button--raised mdl-button--accent">Submit</button>
  </div>
</div>
```

在浏览器里打开组件的 `index.html` 看一下，页面虽然还需要打磨，但是已经有一个好看的输入框和一个漂亮的粉色按钮了。

（没看到粉色按钮？可以来[这里](https://github.com/pearlbea/mini-form/tree/step-3)看下到这一步，代码应该是什么样子。）

## 在内部 DOM 中创建 <slot>

Shadow DOM 有个很棒的特性：`<slot>` 元素，它让组件可以把它实际的子元素插入到内部结构中。这个能力让 web components 变得异常灵活。`<slot>` 元素扮演了一个占位符的角色，使用组件的人可以自己填充内容。对于我们这个组件来说，我们将用 slot 让我们自己（或者组件未来的用户）有能力为表单每一个实例提供不同的文字提示或者问题。第一步，先写好测试：

```
<body>
  <mini-form>What?!</mini-form>
  <script>
    suite('<mini-form>', function() {
      let component = document.querySelector('mini-form');
      ...
      test('renders prompt', () => {
        let index = component.innerText.indexOf('What?!');
        assert.isAtLeast(index, 0);
      });
    });
  </script>
</body>
```

上面的测试检查了 `<mini-form>` 标签之间的文本内容是不是在组件中显示出来了。运行一下测试，可以看到测试失败了。

为了让测试通过，在模板中加一个 `<slot>`。

```
<div class="mdl-card mdl-shadow--2dp">
 <div class="mdl-card__supporting-text">
   <h4><slot></slot></h4>
   <input type="text" rows="3" class="mdl-textfield__input" name="prompt" />
 </div>
 ...
</div>
```

再跑一遍测试，这次通过了！试试在 `index.html` 的 `mini-form` 标签之间写点东西，然后在浏览器里看一下效果。到这一步的代码在[这里](https://github.com/pearlbea/mini-form/tree/step-4)。

## 实现主题化

组件需要能允许我们为每一个实例指定一个颜色主题。为了让主题化和我们在用的 material design CSS 配合得好，用户能用的主题会被限制在[这里](https://getmdl.io/customize/index.html)列出的几种里。我们给组件新增一个 `theme` 属性，用户设置一个字符串值来指定主题。

给这个新特性写点测试。

```
<body>
  <mini-form theme="blue-green">What?!</mini-form>
  <script>
    suite('<mini-form>', function() {
      let component = document.querySelector('mini-form');
      ...
      test('applies color theme to button', () => {
        let button = component.shadowRoot.querySelector('button');
        let buttonColor = window.getComputedStyle(button).getPropertyValue('background-color');
        assert.equal(buttonColor, 'rgb(105, 240, 174)');
      });
      test('applies color theme to header', () => {
        let header = component.shadowRoot.querySelector('header');
        let headerColor = window.getComputedStyle(header).getPropertyValue('background-color');
        assert.equal(headerColor, 'rgb(33, 150, 243)');
      });
    });
  </script>
</body>
```

跑一遍测试，确定一下它们通过没有。没通过吧？很好。修改组件的代码来获取和使用 theme 属性。

```
get theme() {
  return this.getAttribute('theme') || 'indigo-pink';
}

get template() {
  return `
    <style>
      @import 'https://code.getmdl.io/1.3.0/material.${this.theme}.min.css';
      ...
    </style>
    ...
  `;
}
```

我们从 `<mini-form>` 标签上获取 theme 属性，把它或者它的默认值 `indigo-pink` 用在 CSS 的地址里。如果我们给 theme 属性赋了这个 CSS 类库实际并没有的主题值，CSS 的地址就不会生效，组件就会很难看。解决这个问题需要写的代码（和它的测试用例！），我打算交给你自己来完成。

跑一下测试，哎呀，并没有全部通过。因为 Firefox 不支持 Shadow DOM，在 Firefox 里跑的测试失败了。我们已经用上了 shadydom polyfill，但它并不支持 CSS 封装，有另一个叫 [shadycss](https://github.com/webcomponents/shadycss) 的 polyfill 能解决这个问题。跟上面一样，之后你自己完成。

在 `index.html` 里，给 `mini-form` 标签增加一个 [theme](https://getmdl.io/customize/index.html) 属性。然后你就能在浏览器里看到你的艺术创作了。

## 处理事件

组件已经很好看了，但还什么都干不了。我们要干的最后一件事情，是给它加上事件处理的逻辑。当用户点击“Submit”按钮的时候，得发生点什么事情。代码要获取输入，显示一个成功或失败（如果输入为空）的提示。当用户接着聚焦进输入框的时候，错误信息需要消失掉。

给这些事件逻辑写上测试。

```
let input = component.shadowRoot.querySelector('input[type="text"]');
let button = component.shadowRoot.querySelector('button');
let errorMsg = component.shadowRoot.querySelector('.error');

test('displays an error message on submit', () => {
  button.click();
  let index = errorMsg.innerText.indexOf('Don\'t you have something to say?');
  assert.isAtLeast(index, 0);
});
test('clears error message on focus', () => {
  input.focus();
  let index = errorMsg.innerText.indexOf('Don\'t you have something to say?');
  assert.isAtLeast(index, -1);
});
test('displays a success message on submit', () => {
  input.value = 'Some text';
  button.click();
  let index = component.shadowRoot.querySelector('.mdl-card').innerText.indexOf('Thank you.');
  assert.isAtLeast(index, 0);
});
```

在组件代码里，给用户会与之发生交互的两个元素：输入框和按钮绑定事件监听器。

当用户聚焦进输入框，我们希望清空可能在显示的任何错误提示。首先，在模板里新增一个错误提示，并且创建一个带有 `visibility: hidden` 属性的 CSS 类 `hide`。

```
<div class="mdl-card__supporting-text">
  <h4><slot></slot></h4>
  <input type="text" rows="3" class="mdl-textfield__input" name="question" />
  <div class="error hide">Don't you have something to say?</div>
</div>
```

给输入框绑定一个事件监听器，处理它的聚焦事件。

```
connectedCallback() {
  this.initShadowDom();
  this.addFocusListener();
}
get input() {
  return this.shadowRoot.querySelector('input');
}
get errorMessage() {
  return this.shadowRoot.querySelector('.error');
}
addFocusListener() {
  this.input.addEventListener('focus', e => {
    this.hideErrorMessage();
  });
}
hideErrorMessage() {
  this.errorMessage.className = 'error hide';
}
```

上面的代码给输入框元素创建了一个 getter、一个在 connectedCallback 里调用的绑定聚焦事件监听的方法、还有一个在事件监听中用来隐藏错误提示的方法。

接着，给按钮增加点击事件的事件监听和处理点击的逻辑。

```
connectedCallback() {
  this.initShadowDom();
  this.addFocusListener();
  this.addClickListener();
}
get button() {
  return this.shadowRoot.querySelector('button');
}
get card() {
  return this.shadowRoot.querySelector('.mdl-card');
}
get message() {
  // this could be a separate component and probably should be if you make it more complicated
  return `
    <div>
      <div class="mdl-card__title">
        <h4>Thank you.</h4>
      </div>
      <div class="mdl-card__supporting-text">We have received your complaint.</div>
      <div class="mdl-card__actions"></div>
    </div>
  `;
}
addClickListener() {
  this.button.addEventListener('click', e => {
    this.getUserInput();
  });
}
getUserInput() {
  this.input.value.length > 0 ? this.handleSuccess() : this.displayErrorMessage();
}
handleSuccess() {
  // You could call a method to save the user's answer here
  this.displaySuccessMessage();
}
displaySuccessMessage() {
  this.card.innerHTML = this.message;
}
displayErrorMessage() {
  this.errorMessage.className = 'error';
}
```

跑一遍测试，看它们是不是全都通过！也有可能只是大部分通过：在 Firefox 里，样式的测试用例依然会失败。恭喜，你有一个能工作的 web component 了！

全部的代码在[这里](https://github.com/pearlbea/mini-form)。

还可以做很多很多事情来完善和扩展这个组件。除了我早就提到过的，你还可以给头部标题的文本、图标加上 slot，或者美化、保存用户的输入内容。

觉得还不够的话，可以写一个你自己的组件，在 [Twitter](https://twitter.com/pblatteier) 上私信给我。祝编程愉快！

## 相关链接

*   [webcomponents.org](https://www.webcomponents.org/)，关于 web components 最重要的信息来源
*   [Web Components v1 — the next generation](https://developers.google.com/web/updates/2017/01/webcomponents-org) Google 的 Web 更新动向，Taylor Savage 编写
*   [Custom Elements v1: Reusable Web Components](https://developers.google.com/web/fundamentals/getting-started/primers/customelements) Google 的 Web 基础知识，Eric Bidelman 编写
*   [Shadow DOM v1: Self-Contained Web Components](https://developers.google.com/web/fundamentals/getting-started/primers/shadowdom) Google 的 Web 基础知识，Eric Bidelman 编写
*   [Custom Elements That Work Anywhere](https://medium.com/dev-channel/custom-elements-that-work-anywhere-898e1dd2bc48) Rob Dodson 编写
*   [Polymer](https://www.polymer-project.org/)，一个 web component 库
*   [Skate](https://www.gitbook.com/book/skatejs/skatejs/details)，也是一个 web component 库
*   [web-component-tester](https://github.com/Polymer/web-component-tester)，一个测试 web components 的工具

##### 有任何问题或想法，都可以在 twitter [@bendyworks](https://twitter.com/bendyworks) 或者 [Facebook](https://www.facebook.com/bendyworks) 上联系我们。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
