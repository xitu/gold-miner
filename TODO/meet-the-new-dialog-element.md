> * 原文地址：[Meet the New Dialog Element](https://keithjgrant.com/posts/2018/meet-the-new-dialog-element/?utm_source=frontendfocus&utm_medium=email)
> * 原文作者：[keithjgrant](https://keithjgrant.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/meet-the-new-dialog-element.md](https://github.com/xitu/gold-miner/blob/master/TODO/meet-the-new-dialog-element.md)
> * 译者：
> * 校对者：

# Meet the New Dialog Element

![Old iron mailbox with the word 'letters' emblazoned on front](https://keithjgrant.com/images/2018/iron-mailbox.jpg)

[HTML 5.2](https://www.w3.org/TR/html52/) has introduced a new `<dialog>` element for native modal dialog boxes. At first glance, it seems fairly straightforward (and it is), but as I’ve been playing around with it, I’ve found it has some nice features that might be easy to miss.

I’ve embedded a full working demo at the end of this article, but if you want to check it out as you read along, [you can see it here](https://codepen.io/keithjgrant/pen/eyMMVL).

Here is the markup for a basic dialog box:

```
<dialog open>
  Native dialog box!
</dialog>
```

The `open` attribute means that the dialog is visible. Without it, the dialog is hidden until you use JavaScript to make it appear. Before any styling is added, the dialog renders as follows:

![Text in a box with a thick black outline](https://keithjgrant.com/images/2018/native-dialog-basic.png)

It’s absolutely positioned on the page, so it will appear in front of other content as you would expect, and is centered horizontally. By default, it’s as wide as the contents within.

## Basic Operation

JavaScript has a few methods and properties to make working with the `<dialog>` element easy. The two methods you will probably need the most are `showModal()` and `close()`.

```
const modal = document.querySelector('dialog');

// makes modal appear (adds `open` attribute)
modal.showModal();

// hides modal (removes `open` attribute)
modal.close();
```

When you use `showModal()` to open the dialog, a backdrop is added to the page, blocking user interaction with the contents outside the modal. By default, this backdrop is fully transparent, but you can make it visible with CSS (more on that below).

Pressing Esc will close the dialog, and you can provide a close button to trigger the `close()` method.

There is a third method, `show()` that also make the modal appear but without the accompanying backdrop. The user will still be able to interact with elements that are visible outside the dialog box.

### Browser Support and Polyfill

Right now, `<dialog>` behavior is only supported in Chrome. Firefox provides default styling, but the JavaScript API is only enabled behind a flag. I suspect Firefox will enable it by default soon.

Thankfully, there is [a polyfill](https://github.com/GoogleChrome/dialog-polyfill) that provides both the JavaScript behavior and a stylesheet with default styling. Install `dialog-polyfill` in npm to use it—or use a regular old `<script>` tag. It works in IE9 and up.

When using the polyfill, each dialog on the page needs to be initialized:

```
dialogPolyfill.registerDialog(modal);
```

This will not replace native behavior for browsers that have it.

## Styling

Opening and closing a modal is nice, but it doesn’t look very professional at first. Adding styling is as simple as styling any other element. The backdrop can be styled with the new `::backdrop` pseudo-element.

```
dialog {
  padding: 0;
  border: 0;
  border-radius: 0.6rem;
  box-shadow: 0 0 1em black;
}

dialog::backdrop {
  /* make the backdrop a semi-transparent black */
  background-color: rgba(0, 0, 0, 0.4);
}
```

For older browsers using the polyfill, this pseudo-element selector will not work, however. In its place, the polyfill adds a `.backdrop` element immediately following the dialog. You can target it with CSS like this:

```
dialog + .backdrop {
  background-color: rgba(0, 0, 0, 0.4);
}
```

Add a little more markup to provide styling hooks. A common approach to dialog boxes is to break it up into a header, a body, and a footer:

```
<dialog id="demo-modal">
  <h3 class="modal-header">A native modal dialog box</h3>
  <div class="modal-body">
    <p>Finally, HTML has a native dialog box element! This is fantastic.</p>
    <p>And a polyfill makes this usable today.</p>
  </div>
  <footer class="modal-footer">
    <button id="close" type="button">close</button>
  </footer>
</dialog>
```

Add some CSS to this, and you can make the modal look however you want:

![Text in a box with a thick black outline](https://keithjgrant.com/images/2018/native-dialog-styled.png)

## More control

Often, we want some sort of user feedback from a dialog box. When closing a dialog, you can pass a string value to the `close()` method. This value is assigned to the `returnValue` property of the dialog DOM element, so it can be read later:

```
modal.close('Accepted');

console.log(modal.returnValue); // logs `Accepted`
```

There are also some events you can listen for. Two useful ones are `close` (triggered when the modal is closed) and `cancel` (triggered when the user presses Esc to close the modal).

One thing that seems to be missing is the ability to close the modal when the backdrop is clicked, but there is a workaround. Clicking the backdrop fires a click event with the `<dialog>` as the event target. And if you construct the modal such that child elements fill the entire space of the dialog, those child elements will be the target of any clicks inside the dialog. This way, you can listen for clicks on the dialog, and close it when the dialog itself is the target of the click event:

```
modal.addEventListener('click', (event) => {
  if (event.target === modal) {
    modal.close('cancelled');
  }
});
```

This isn’t perfect, but it works. Please let me know if you find a better way to detect clicks on the backdrop.

## Full working demo

I’ve worked a lot of stuff into the demo below. Play around with and see what else you can do with `<dialog>`. This includes the polyfill, so it should work in most browsers.

See the Pen [<dialog>](https://codepen.io/keithjgrant/pen/eyMMVL/) by Keith J. Grant ([@keithjgrant](https://codepen.io/keithjgrant)) on [CodePen](https://codepen.io).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
