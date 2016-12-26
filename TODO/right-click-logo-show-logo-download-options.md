>* 原文链接 : [Right Click Logo to Show Logo Download Options](https://css-tricks.com/right-click-logo-show-logo-download-options/)
* 原文作者 : [CHRIS COYIER ](https://css-tricks.com/author/chriscoyier/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Yushneng](https://github.com/rainyear)
* 校对者: [circlelove](https://github.com/circlelove)，[ZhaofengWu](https://github.com/ZhaofengWu)

# 在网站 Logo 上右击时提示下载网站的 Logo 素材下载

有一天我在访问 [Invision](http://www.invisionapp.com/) 网站时，突然想要抓取他们网站的 logo。如果运气好的话（例如你非常开心地发现他们 logo 的 SVG 文件），有时候你不需要去 Google 图片搜索，也不用普通网页搜索关键词 “Invision Logo”找到一些品牌介绍页面之类网页，才可以下载 logo 图片。

因此我右击了他们的 logo，希望可以通过”查看元素”从开发者工具（DevTools）中找到它的图片文件。

然而并没有出现右键菜单，而是触发了一个对话框：


![](https://css-tricks.com/wp-content/uploads/2016/03/show-logo.gif)

我感到非常惊喜，因为这正是我想要的。


### 下面是一个简单的无依赖的实现方法

看这个来自 Chris Coyier（[@chriscoyier](http://codepen.io/chriscoyier) 的示例 [右击 Logo 以显示 Logo 选项](http://codepen.io/chriscoyier/pen/QNyeVd/)）。

<iframe height="268" scrolling="no" src="//codepen.io/chriscoyier/embed/QNyeVd/?height=268&amp;theme-id=0&amp;default-tab=result" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen &lt;a href="http://codepen.io/chriscoyier/pen/QNyeVd/"&gt;Right Click Logo to Show Logo Options&lt;/a&gt; by Chris Coyier (&lt;a href="http://codepen.io/chriscoyier"&gt;@chriscoyier&lt;/a&gt;) on &lt;a href="http://codepen.io"&gt;CodePen&lt;/a&gt;.</iframe>

你的应用可能已经有一整套精致的系统来展示对话框了。如果是这样，那就更简单了。为 logo 绑定“右击”事件（准确来说是`contextmenu`）并加入你想完成的操作。

    logo.addEventListener('contextmenu', function(event) {
      // do whatever you do to show a modal
    }, false);

如果你当前没有实现对话框的系统，也很容易实现一个简单的版本。你需要一个浮层和一个对话框元素：

    <div class="overlay" id="overlay"></div>

    <div class="modal" id="modal">
      <h3>Looking for our logo?</h3>
      <p>You clever thing. We've prepared a <a href="#0">.zip you can download</a>.</p>
      <p><button id="close-modal-button">Close</button></p>
    </div>

还有一个计划表：

1. 右击 logo 时，显示浮层和对话框
2. 点击关闭按钮时，隐藏它们

没问题：

    var logo = document.querySelector("#logo");
    var button = document.querySelector("#close-modal-button");
    var overlay = document.querySelector("#overlay");
    var modal = document.querySelector("#modal");

    logo.addEventListener('contextmenu', function(event) {
      event.preventDefault();
      overlay.classList.add("show");
      modal.classList.add("show");
    }, false);

    button.addEventListener('click', function(event) {
      event.preventDefault();
      overlay.classList.remove("show");
      modal.classList.remove("show");
    }, false);

基本样式：

    .overlay {
      position: fixed;
      background: rgba(0, 0, 0, 0.75);
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      display: none;
    }
    .overlay.show {
      display: block;
    }

    .modal {
      position: fixed;
      left: 50%;
      width: 300px;
      margin-left: -150px;
      top: 100px;
      background: white;
      padding: 20px;
      text-align: center;
      display: none;
    }
    .modal.show {
      display: block;
    }
    .modal > h3 {
      font-size: 26px;
      color: #900;
    }

### 永远不要用你自己自定义的行为破坏原有的右键菜单，我的天，你这个根本就不应该存在的恶魔

你是对的！天呐我都做了些什么！Murderous screams!!

<iframe src="https://vine.co/v/i675aBFnWta/embed/simple" width="600" height="600" frameborder="0"></iframe><script src="https://platform.vine.co/static/scripts/embed.js"></script>
