> * 原文链接: [Revisiting the Float Label pattern with CSS](http://thatemil.com/blog/2016/01/23/floating-label-no-js-pure-css/)
* 原文作者：[Emil Björklund](http://thatemil.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Zhangjd](https://github.com/zhangjd)
* 校对者:
* 状态 : 待校对


设计师似乎喜欢用 [浮动 label 模式](http://mds.is/float-label-pattern/) 来设计漂亮的效果，虽然我不确定我是否百分百喜欢这种方式，但我忍不住快速实现了一个这样的 demo。这个版本用上了一些新的表单样式技巧，这些技巧是我最近才看见的，特别是 `:placeholder-shown` 选择器。

先说重点：不管从形状或者形式上，这都**不是**一种最佳实践。这个 demo 只能在某些浏览器的较新的版本上才能起效 - 特别是 Chrome/Opera 和 Safari/WebKit。非常不幸的是，在 Firefox 上 demo 失效了。要注意了，我可几乎没有测试过它。

我主要是参考了下面这些技巧来实现该效果的：

1.  Flexbox — 借助 [Hugo Giraudel 的示例代码](http://codepen.io/HugoGiraudel/pen/b3274eb0bf93bed79afeafd30b7a33f1) ，在 HTML 中，把 label 放在了 input 之后，并通过 CSS 颠倒其显示顺序。
2.  使用 `transform` 属性，把 label 放在 input 之上。当处于该状态的时候，placeholder 的文字被设置为 `opacity: 0`，也就是透明，因此 label 和 placeholder 的文本不会重叠显示。
3.  当 placeholder _不_ 显示，比如表单域被填充或者获得焦点的时候，才把 label 上移，这里我是受到了 [Jeremy 关于 ”Pseudon’t” 的文章](https://adactio.com/journal/10000) 启发。

最后一点是，我的实现不同于 [Chris Coyier](http://css-tricks.com/float-labels-css/) 和 [Jonathan Snook](http://snook.ca/archives/html_and_css/floated-label-pattern-css) 的版本，他们在代码中都使用了 `:valid` 伪类。我想这个 demo 只是围绕特定限制所实现的，但也正如我一开始所说，这会受限于浏览器支持。

这个版本使用了 `:placeholder-shown` 伪类作为代替，但不仅仅是在 placeholder 文本不显示时移动 label 的位置 - 而是生动地展示出这个模式应该是怎么生效的。

这里是相关 HTML 代码：

    <div class="field">
        <input type="text" placeholder="Jane Appleseed">
        <label for="fullname">Name</label>
    </div>

...以及 CSS 代码：

    /**
    * 把区域设置为 flex 容器，并逆序排列，使得 label 标签显示在上方
    */
    .field {
      display: flex;
      flex-flow: column-reverse;
    }
    /**
    * 给 label 和 input 设置一个过渡属性
    */
    label, input {
      transition: all 0.2s;
    }

    input {
      font-size: 1.5em;
      border: 0;
      border-bottom: 1px solid #ccc;
    }
    /**
    * 设置 input 获得焦点时的边框样式
    */
    input:focus {
      outline: 0;
      border-bottom: 1px solid #666;
    }
    /**
    * 1\. 标签最多占据一行 2/3 的宽度，超出显示省略号，以确保其放大后内容正常显示不超出一行。
    * 2\. 修正光标形状，使用户知道这里可以输入.
    * 3\. 把标签往下平移并放大1.5倍，使其覆盖 placeholder 层.
    */
    label {
      /* [1] */
      max-width: 66.66%;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      /* |2] */
      cursor: text;
      /* [3 */
      transform-origin: left bottom; 
      transform: translate(0, 2.125rem) scale(1.5);
    }
    /**
    * 默认情况下，placeholder 应该是透明的，并且其 transition 属性应被设置为 inherit。
    */
    ::-webkit-input-placeholder {
      transition: inherit;
      opacity: 0;
    }
    /**
    * 在 input 获得焦点时，显示 placeholder 内容。
    */
    input:focus::-webkit-input-placeholder {
      opacity: 1;
    }
    /**
    * 1\. 当元素获取焦点时，还原 transform 效果，把 label 移回原来的位置。
    *     并且，当 placeholder 不显示，比如用户已经输入了内容时，也作同样处理。
    * 2\. ...并把光标设置为指针形状。
    */
    input:not(:placeholder-shown) + label,
    input:focus + label {
      transform: translate(0, 0) scale(1); /* [1] */
      cursor: pointer; /* [2] */
    }

2016-01-26 更新: 我更新了 label 的选择器，以便其对应的 input 标签符合 :placeholder-shown 属性时才被使用。那样的话，不支持的浏览器就回退到 “正常模式” ，也就是标签显示在 input 上方。

点这里查看 [JSBin 实例](http://jsbin.com/pagiti/9/edit?html,css,output).
