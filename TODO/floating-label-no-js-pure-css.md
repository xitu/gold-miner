> * 原文链接: [Revisiting the Float Label pattern with CSS](http://thatemil.com/blog/2016/01/23/floating-label-no-js-pure-css/)
* 原文作者：[Emil Björklund](http://thatemil.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:
* 状态 :  认领中


The [float label pattern](http://mds.is/float-label-pattern/) is a slick pattern that designers seem to love. I’m not sure that I'm 100% in love with it, but I couldn't resist cooking up a quick demo implementation. This version uses a few nice form-styling tricks using modern CSS that I've seen recently, particularly the `:placeholder-shown` selector.

First things first: this is **not** a "Best practice" implementation in any way, shape or form. It works in recent versions of some browsers — most notably Chrome/Opera and Safari/WebKit. It fails miserably in Firefox. I have barely tested it. Be warned.

I'm relying on quite a few moving parts here:

1.  Flexbox—using [Hugo Giraudel’s pattern](http://codepen.io/HugoGiraudel/pen/b3274eb0bf93bed79afeafd30b7a33f1) for putting the label after the input in the markup, then reversing the order.
2.  A `transform` to shift the `label` down over the input. When this state is active, the placeholder text get's an `opacity: 0` so the two pieces of text don’t overlap.
3.  Shifting the `label` up only when the placeholder is _not_ shown, i.e. when the field is filled in, or when it’s focused, inspired by [Jeremy’s ”Pseudon’t” post](https://adactio.com/journal/10000).

That last part is what separates this implementation from for example [Chris Coyier’s](http://css-tricks.com/float-labels-css/) and [Jonathan Snook’s](http://snook.ca/archives/html_and_css/floated-label-pattern-css) versions, in that they use the `:valid` pseudo-class. I think this demo steps around that particular limitation, but as I said at the start, there are limitations in the form of browser support.

This version instead uses the `:placeholder-shown` pseudo-class, but negated to only move the label out of the way when the placeholder text is not showing—which plays nicely with how the pattern is supposed to work.

Here's the relevant HTML:

    <div class="field">
        <input type="text" placeholder="Jane Appleseed">
        <label for="fullname">Name</label>
    </div>

...and the CSS:

    /**
    * Make the field a flex-container, reverse the order so label is on top.
    */
    .field {
      display: flex;
      flex-flow: column-reverse;
    }
    /**
    * Add a transition to the label and input.
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
    * Change input border on focus.
    */
    input:focus {
      outline: 0;
      border-bottom: 1px solid #666;
    }
    /**
    * 1\. Make sure the label is only on one row, at max 2/3rds of the
    *     field—to make sure it scales properly and doesn't wrap.
    * 2\. Fix the cursor.
    * 3\. Translate down and scale the label up to cover the placeholder.
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
    * By default, the placeholder should be transparent. Also, it should 
    * inherit the transition.
    */
    ::-webkit-input-placeholder {
      transition: inherit;
      opacity: 0;
    }
    /**
    * Show the placeholder when the input is focused.
    */
    input:focus::-webkit-input-placeholder {
      opacity: 1;
    }
    /**
    * 1\. When the element is focused, remove the label transform.
    *     Also, do this when the placeholder is _not_ shown, i.e. when 
    *     there's something in the input at all.
    * 2\. ...and set the cursor to pointer.
    */
    input:not(:placeholder-shown) + label,
    input:focus + label {
      transform: translate(0, 0) scale(1); /* [1] */
      cursor: pointer; /* [2] */
    }

Update 2016-01-26: I updated the selector for the label so that the transformed label is only used when it's following an input matching :placeholder-shown. That way, non-supporting browsers fall back to the ”normal” label-above-the-input pattern.

Here's the full [JSBin demo](http://jsbin.com/pagiti/9/edit?html,css,output).
