>* 原文链接 : [Right Click Logo to Show Logo Download Options](https://css-tricks.com/right-click-logo-show-logo-download-options/)
* 原文作者 : [CHRIS COYIER ](https://css-tricks.com/author/chriscoyier/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态： 认领中




I was on the [Invision](http://www.invisionapp.com/) website the other day and I wanted to snag their logo for some reason or another. Sometimes you can have better luck doing that (like when you happily discover it's SVG) than you can Google Image Searching or even regular web searching for something like "Invision Logo" and loping to find some kind of branding page with a logo kit download.

So I right-clicked their logo, hoping to "inspect" it with the DevTools and check it out.

Rather than showing me a context menu, it triggered a modal:

![](https://css-tricks.com/wp-content/uploads/2016/03/show-logo.gif)

I was pleasantly surprised, because that's exactly what I wanted.

### Here's a simple zero-dependencies way to do that

See the Pen [Right Click Logo to Show Logo Options](http://codepen.io/chriscoyier/pen/QNyeVd/) by Chris Coyier ([@chriscoyier](http://codepen.io/chriscoyier)) on [CodePen](http://codepen.io).

<iframe height="268" scrolling="no" src="//codepen.io/chriscoyier/embed/QNyeVd/?height=268&amp;theme-id=0&amp;default-tab=result" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen &lt;a href="http://codepen.io/chriscoyier/pen/QNyeVd/"&gt;Right Click Logo to Show Logo Options&lt;/a&gt; by Chris Coyier (&lt;a href="http://codepen.io/chriscoyier"&gt;@chriscoyier&lt;/a&gt;) on &lt;a href="http://codepen.io"&gt;CodePen&lt;/a&gt;.</iframe>

Your app might already have a whole fancy system for showing modals. If so, then it's even easier. Attach a "right click" event (it's actually called `contextmenu`) to the logo and do your thing.

    logo.addEventListener('contextmenu', function(event) {
      // do whatever you do to show a modal
    }, false);

If you don't have a modal system in place, it's very easy to make a rudimentary one. You need an overlay and a modal element:

    <div class="overlay" id="overlay"></div>

    <div class="modal" id="modal">
      <h3>Looking for our logo?</h3>
      <p>You clever thing. We've prepared a <a href="#0">.zip you can download</a>.</p>
      <p><button id="close-modal-button">Close</button></p>
    </div>

And a plan:

1.  When the logo is right-clicked, show the overlay and modal
2.  When the close button is clicked, hide them

No problem:

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

Bare bones styling:

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

### Never EVER break the default context menu and override with your own custom behavior OMG what are you an evil troll you should have never been born

You're right! Oh god what have I done! Nothing can ever change! Murderous screams!!

<iframe src="https://vine.co/v/i675aBFnWta/embed/simple" width="600" height="600" frameborder="0"></iframe><script src="https://platform.vine.co/static/scripts/embed.js"></script>
