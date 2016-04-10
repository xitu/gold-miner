>* 原文链接 : [Ink Transition Effect](https://codyhouse.co/gem/ink-transition-effect/)
* 原文作者 : [Claudia Romano](https://twitter.com/romano_cla)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [L9m](https://github.com/L9m)
* 校对者:


一个用 CSS 动画实现的墨水晕开过渡效果。

我最近遇到有几个网站使用墨水晕开作为过渡效果。 一个很好的例子是 [Sevenhills website](http://www.sevenhillswholefoods.com/experience/). 起初我以为他们使用 HTML canvas 来实现(允许透明度), 然后我查看源代码发现他们没有并使用视频，而是一个 PNG 雪碧图。

通过用一个 PNG 雪碧图和 CSS 中的 **steps()** 定时方法,我们能创建视频效果并使用它们作为过渡。 在我们的方法中, 我们使用这种手段去触发一个模态窗口, 但你也能使用它作为两个页面之间的过渡效果。

创建这些效果的过程很简单，让我详细分解给你:

首先，你需要一个有填充效果的视频和一个透明区域。 然后你需要把这个视屏导出为 PNG 序列。我们使用 Afrer Effects 导出这个队列（确保导出 alpha 通道）。

![ae-01](https://0bf196087c14ed19d1f11cf1-ambercreativelab.netdna-ssl.com/wp-content/uploads/2016/03/ae-01.png)

因为我们的视频由25帧组成， 导出 25 张PNG 图片资源. 只是为了给你更好设置组成的更多信息, 我们创建了一个 宽高 640x360px 帧率为 25 时长为 1 秒的视频。

![ae-02](https://0bf196087c14ed19d1f11cf1-ambercreativelab.netdna-ssl.com/wp-content/uploads/2016/03/ae-02.png)

最后乏味的部分: 你需要创建一个将所有帧包含在同一行的 PNG 图片。我们手动在 Photoshop 中将所有帧组合在一个 16000×360 像素的图片中。

![png-sequence-preview](https://0bf196087c14ed19d1f11cf1-ambercreativelab.netdna-ssl.com/wp-content/uploads/2016/03/png-sequence-preview.png)

为了将序列变成一个视频，我们只需要平移这个 PNG 雪碧图，然后使用 **steps()** 方法定义帧的数目。

Do you want to learn more about CSS transforms and animations? 你想学习更多关于 CSS 变换和动画的相关内容吗？[查看我们 课程](https://codyhouse.co/course/mastering-css-transitions-transformations-animations/) ;)

现在让我们进入代码！

## 创建结构

 **HTML 结构** 由三个元素组成: 一个 `main.cd-main-content` 容纳页面主要内容, 一个 `div.cd-modal` 容纳一个模态窗口和一个 `div.cd-transition-layer` 包含过渡层。

    <main class="cd-main-content">
        <div class="center">
            <h1>Ink Transition Effect</h1>
            <a href="#0" class="cd-btn cd-modal-trigger">Start Effect</a>
        </div>
    </main> <!-- .cd-main-content -->

    <div class="cd-modal">
        <div class="modal-content">
            <h1>My Modal Content</h1>

            <p>
                Lorem ipsum dolor sit amet, consectetur adipisicing elit. 
                Ad modi repellendus, optio eveniet eligendi molestiae? 
                Fugiat, temporibus! 
            </p>
        </div> <!-- .modal-content -->

        <a href="#0" class="modal-close">Close</a>
    </div> <!-- .cd-modal -->

    <div class="cd-transition-layer"> 
        <div class="bg-layer"></div>
    </div> <!-- .cd-transition-layer -->

## 增加样式

这`.cd-modal` 窗口最初的CSS属性 visibility: hidden, height: 100% 和 width: 100% 并且固定定位.  
当用户点击 `a.cd-modal-trigger`, 模态窗口变为可见，并且它的透明度变为1（使用 `.visible` 类）。

    .cd-modal {
      position: fixed;
      top: 0;
      left: 0;
      z-index: 3;
      height: 100%;
      width: 100%;
      opacity: 0;
      visibility: hidden;
    }
    .cd-modal.visible {
      opacity: 1;
      visibility: visible;
    }

这 `div.cd-transition-layer` 元素用来创建墨水过渡效果:  visibility: hidden, height: 100% 和 width: 100% 并且固定定位。

    .cd-transition-layer {
      position: fixed;
      top: 0;
      left: 0;
      z-index: 2;
      height: 100%;
      width: 100%;
      opacity: 0;
      visibility: hidden;
      overflow: hidden;
    }

它的子元素 `div.bg-layer` 使用 ink.png 雪碧图作为背景， background-size: 100%,  height: 100% 和 width: 2500% (ink.png 雪碧图 由 25 帧组成); 它的 left/top/translate 值设置为最初 ink.png 雪碧图第一帧在 `div.cd-transition-layer`居中:

    .cd-transition-layer .bg-layer {
      position: absolute;
      left: 50%;
      top: 50%;
      transform: translateY(-50%) translateX(-2%);
      height: 100%;
      /* our sprite is composed of 25 frames */
      width: 2500%;
      background: url(../img/ink.png) no-repeat 0 0;
      background-size: 100% 100%;
    }

你可能使用以下方式在父元素中居中一个元素：

    position: absolute;
    left: 50%;
    top: 50%;
    transform: translateY(-50%) translateX(-50%);

在我们的例子中，虽然我们想要居中 ink.png 雪碧图的第一帧，因为  `div.bg-layer`  宽度 为父元素宽度的 25 倍, 我们使用 translateX(-(50/25)%).

To create the ink animation, we change the translate value of the `div.bg-layer`; we defined the `cd-sequence` keyframes rule:

    @keyframes cd-sequence {
      0% {
        transform: translateY(-50%) translateX(-2%);
      }
      100% {
        transform: translateY(-50%) translateX(-98%);
      }
    }

This way, at the end of the animation, the last frame of the ink.png sprite is centered inside the `div.cd-transition-layer` element.

Note: since we have 25 frames, to show the last one you need to translate the `.bg-layer` of -100% * (25 – 1) = -96%; but then, to center it inside its parent, you need to add the additional -2%.

When a user clicks the `a.cd-modal-trigger`, the `.visible` class is added to the `.cd-transition-layer` to show it, while the `.opening` class is used to trigger the ink animation:

    .cd-transition-layer.visible {
      opacity: 1;
      visibility: visible;
    }
    .cd-transition-layer.opening .bg-layer {
      animation: cd-sprite 0.8s steps(24);
      animation-fill-mode: forwards;
    }

Note that we used the `steps()` function: that’s because we don’t want the translate value to change continuously, but rather change through fixed steps, in order to show one frame at a time; the number of steps used is equal to our frames less one.

## Events handling

We used jQuery to add/remove classes when user clicks the `a.cd-modal-trigger` or `.modal-close` to open/close the modal window.

Besides, we change the `.bg-layer` dimensions in order not to modify the png frames aspect ratio. In the style.css file, we set `.bg-layer` height and width so that each frame has height and width equal to the ones of the viewport. Viewport and frames could have a different aspect ratio though and that could distort the single frame. The `setLayerDimensions()` function has been used to prevent this from happening:

    var frameProportion = 1.78, //png frame aspect ratio
        frames = 25, //number of png frames
        resize = false;

    //set transitionBackground dimentions
    setLayerDimensions();
    $(window).on('resize', function(){
        if( !resize ) {
            resize = true;
            (!window.requestAnimationFrame) ? setTimeout(setLayerDimensions, 300) : window.requestAnimationFrame(setLayerDimensions);
        }
    });

    function setLayerDimensions() {
        var windowWidth = $(window).width(),
            windowHeight = $(window).height(),
            layerHeight, layerWidth;

        if( windowWidth/windowHeight > frameProportion ) {
            layerWidth = windowWidth;
            layerHeight = layerWidth/frameProportion;
        } else {
            layerHeight = windowHeight;
            layerWidth = layerHeight*frameProportion;
        }

        transitionBackground.css({
            'width': layerWidth*frames+'px',
            'height': layerHeight+'px',
        });

        resize = false;
    }




</div>

</div>
