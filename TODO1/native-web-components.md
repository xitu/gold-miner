> * 原文地址：[Make a Native Web Component with Custom Elements v1 and Shadow DOM v1](https://bendyworks.com/blog/native-web-components)
> * 原文作者：[Pearl Latteier](https://bendyworks.com/blog/authors/pearl_latteier)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/native-web-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/native-web-components.md)
> * 译者：
> * 校对者：

# Make a Native Web Component with Custom Elements v1 and Shadow DOM v1

* * *

![](https://bendyworks.com/assets/images/blog/2017-05-04-native-web-components-80f1a357.png)

Say you have a little form or widget that you use in several different places across your website or in several different projects. You want all the instances to have consistent style and behavior, but you also want them to have some flexibility. Maybe your form should vary in size depending on the container element, or your widget should display different text and icons in different projects. You know what you need? You need a web component!

Web components are custom HTML elements that you can reuse and share. Like native HTML elements, they can have properties, methods, and event listeners; they're nestable; and they [play nicely with JavaScript frameworks](https://medium.com/dev-channel/custom-elements-that-work-anywhere-898e1dd2bc48). A web component's main difference from an `<img>` or a `<div>` element is that you get to define its behavior, style, and API.

Cool, right? No jQuery. No spaghetti code. Just a nice, encapsulated package of UI and functionality.

## Introducing the Mini-Form Component

We're going to make a web component called "mini-form". (Custom element names have to start with a lowercase letter and have one or more hyphens. For more info, see the [spec](https://html.spec.whatwg.org/multipage/scripting.html#valid-custom-element-name).) It will be a very simple form that invites users to submit a complaint and confirms receipt the user's input (with which it does nothing). The form will match the size of its containing element and the length of the question text. It has a basic [material design](https://material.io/guidelines/material-design/introduction.html) style; you can assign the color theme for each instance. The code is at [https://github.com/pearlbea/mini-form](https://github.com/pearlbea/mini-form) and a demo is [here](https://mini-form-demo.firebaseapp.com/).

## Define the Custom Element

Web components are made possible by several new [web standards](https://www.webcomponents.org/specs). The most important of these is Custom Elements, which has recently been revised. (For more information about the new Custom Elements V1 spec, see Eric Bidelman's useful [post](https://developers.google.com/web/fundamentals/getting-started/primers/customelements).) To create a custom element we need two things: A class, which defines the behavior of the element, and a definition that tells the browser to associate the DOM tag with the class. Create a file called `mini-form.js` and add the following class and definition:

```
class MiniForm extends HTMLElement {
  constructor() {
    super();
  }
}
window.customElements.define('mini-form', MiniForm);
```

The call to `super()` with no parameters must be the first thing in the constructor. It sets up the proper prototype chain and the meaning of `this` within the component. (See the Mozilla Developer Network's article on [super](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/super) for more info.)

## More Set Up

While you are creating files, also make an `index.html` file where you will admire an instance or two of the component and a `mini-form-test.html` file where you'll write a test suite as you build the component. Populate these files with the basic HTML5 boilerplate.

You will also need a couple polyfills. The web standards that we are using are new and they are [not supported by all browsers](https://caniuse.com/#search=custom%20elements%20v1). At least for the present, polyfills are necessary. For this simple component, we only require two: [custom elements](https://github.com/webcomponents/custom-elements) and [shadydom](https://github.com/webcomponents/shadydom). You can install them with Bower:

```
bower install --save webcomponents/custom-elements
bower install --save webcomponents/shadydom
```

Add these polyfills to the head of your `index.html` and your `mini-form-test.html`. (Or add them in a tidy bundle using your favorite build tool. I don’t care.) Also add the `mini-form.js` script to each HTML file. Your `index.html` will look something like this:

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

Note: You should include the shadydom polyfill before the custom elements polyfill. If you don't, you could get an error telling you that `Element#attachShadow` does not exist. (Guess how I know this.) More about the shadow DOM a little later.

## Write a Test

Before we get any further into the component, let's write a test. We will test that the component renders a `div` in the DOM. It will fail now, since our component barely exists. But we'll get the joy of seeing a passing test as soon as we render a `div` element.

Here's what the test will look like:

```
suite('<mini-form>', () => {
  let component = document.querySelector('mini-form');
  test('renders div', () => {
    assert.isOk(component.querySelector('div'));
  });
});
```

To run the test, we will use the [web component tester](https://github.com/Polymer/web-component-tester) created by the [Polymer Project](https://www.polymer-project.org/). Install the web-component-tester with NPM and add `node_modules/web-component-tester/browser.js` to the head of `mini-form-test.html`. Both polyfills and the `mini-form.js` script should already be on the page.

You will also need to add an instance of the mini-form component to the body of the file, like so:

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

Ready, set, run the test! On the command line, type `wct` and the [web component tester](https://github.com/Polymer/web-component-tester) will spin up whatever browsers you have installed and run the test. After a moment you should get a message that the test has failed:

```
✖ test/mini-form-test.html » <mini-form> » renders div expected null to be truthy
```

If you're running into any problems, you can see what your code should look like at this point [here](https://github.com/pearlbea/mini-form/tree/step-1).

## Make a Template

Now we can extend our component and make the test pass.

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

The code above adds a getter that returns a minimal template. Then it assigns the template to the component's innerHTML in the `connectedCallback`. This method is part of the [custom element lifecycle](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Custom_Elements/Custom_Elements_with_Classes) and is called when the element gets inserted to the DOM.

Run the test again and it should pass. Hurrah! Of course the component will eventually display more than a single div. Add some more tests, watch them fail, and make them pass.

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

## Add Style and Shadow DOM

As yet the mini-form component doesn't look like much. Time to add style. The style should be consistent across all instances of the component, wherever it is used. We don't want the CSS or JS on a parent page to affect the component, and we don't want the component's style or behavior to affect context in which it is used. We can achieve this by encapsulating the component's content within the [Shadow DOM](https://developers.google.com/web/fundamentals/getting-started/primers/shadowdom).

The Shadow DOM is much like the DOM you already know and love. It has the same tree structure and works in the same way, except that it does not interact with the parent DOM; it does not become the child of the element that it is attached to.

To use the Shadow DOM, we will need to modify the mini-form.

```
connectedCallback() {
  this.initShadowDom();
}

initShadowDom() {
  let shadowRoot = this.attachShadow({mode: 'open'});
  shadowRoot.innerHTML = this.template;
}
```

Instead of assigning the template to the innerHTML of the component itself, we will add the shadowRoot as an intermediary. We attach a shadow to the component, and then assign the template to the shadow's innerHTML.

Doing this will break all our tests, but we can modify them easily by adding the shadowRoot we just defined to the DOM query.

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

Run the tests to make sure everything works. Then add some [Material Design](https://getmdl.io/) style.

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

If you peek at your component `index.html` in the browser, you will see it still needs work but does display an elegant input and a pretty pink button.

(No pretty pink button? You can see what your code should look like [here](https://github.com/pearlbea/mini-form/tree/step-3).)

## Make a <slot> in the shadow

The Shadow DOM has a great feature, the `<slot>` element, that allows a component to bring a little "light DOM" into its shadows. This ability makes web components enormously flexible. The `<slot>` element acts as a placeholder that the user of the component can fill with content. For our component, we will use a slot to let us (or future users of the component) supply a different prompt or question for every instance of the form. First, a test:

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

This test checks that the text between the `<mini-form>` tags gets displayed in the component. Run the tests. See it fail.

To make the test past, add a `<slot>` to the template.

```
<div class="mdl-card mdl-shadow--2dp">
 <div class="mdl-card__supporting-text">
   <h4><slot></slot></h4>
   <input type="text" rows="3" class="mdl-textfield__input" name="prompt" />
 </div>
 ...
</div>
```

Run the tests again. It works! In your `index.html`, write something between the `mini-form` tags and admire it in the browser. Code for this step is [here](https://github.com/pearlbea/mini-form/tree/step-4).

## Implement Theming

The component should allow us to assign a color theme to each instance. To make this work nicely with the material design CSS that we are using, users will be limited to the themes specified [here](https://getmdl.io/customize/index.html). We will add a `theme` property to the component that will allow users to pass in a theme as a string.

Write some tests for this new behavior.

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

Run the tests to make sure they fail. They do? Good. Modify the component code to get and use the theme property.

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

We get the theme attribute from the `<mini-form>` tag and use it or a default `indigo-pink` theme in the url for the CSS. If we were to assign the theme attribute to anything other than one of the themes accepted by the CSS library that we're using, the url would not work and the component would look bad. I'll leave it to you to add code (and tests of that code!) to handle this problem.

Run the tests. Oops. They don't all pass. Specifically tests that run in Firefox don't pass because Firefox does not support the Shadow DOM. We are using the shadydom polyfill, but it does not handle CSS encapsulation. There is another polyfill called [shadycss](https://github.com/webcomponents/shadycss) that solves the problem. Again, implementing it can be your fun-time project.

Add a [theme](https://getmdl.io/customize/index.html) to the `mini-form` tag your `index.html` so you can enjoy your artistry in the browser.

## Handle Events

Our component looks nice, but it doesn't do anything. The last thing we need to add is event handling. Something should happen when the user click the "Submit" button. The code should get the input and display a success message or an error message (if the input is empty). The error message should go away when the user clicks into the input.

Let's add tests for these events.

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

In the component code, add event listeners for the input and the button, the two elements that users will interact with.

When users enter the input, we want to clear any error message that might be displayed. First, add an error message to the template and create a CSS class `hide` that has a property of `visibility: hidden`.

```
<div class="mdl-card__supporting-text">
  <h4><slot></slot></h4>
  <input type="text" rows="3" class="mdl-textfield__input" name="question" />
  <div class="error hide">Don't you have something to say?</div>
</div>
```

Now add an event listener and handler for the focus event on the input.

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

This creates a getter for the input element, a focus listener method that is called in the connectedCallback, and a method that the listener calls to hide the error message.

Next, add an event listener for the button click and code to handle the click event.

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

Run the tests and watch them pass! Or watch most of them pass. The style tests will still fail on Firefox. You have a working web component. Congrats!

The code is [here](https://github.com/pearlbea/mini-form).

There are many, many things you could do to improve and extend the component. In addition to the things I've already mentioned, you could for starters add slots for the header text and icon or sanitize and save the user input.

Better yet, make your own component and tweet it to me at [@pblatteier](https://twitter.com/pblatteier). Happy coding!

## Resources

*   [webcomponents.org](https://www.webcomponents.org/), the central source for web components and information about them
*   [Web Components v1 - the next generation](https://developers.google.com/web/updates/2017/01/webcomponents-org) by Taylor Savage, Google Web Updates
*   [Custom Elements v1: Reusable Web Components](https://developers.google.com/web/fundamentals/getting-started/primers/customelements) by Eric Bidelman, Google Web Fundamentals
*   [Shadow DOM v1: Self-Contained Web Components](https://developers.google.com/web/fundamentals/getting-started/primers/shadowdom) by Eric Bidelman, Google Web Fundamentals
*   [Custom Elements That Work Anywhere](https://medium.com/dev-channel/custom-elements-that-work-anywhere-898e1dd2bc48) by Rob Dodson, Medium
*   [Polymer](https://www.polymer-project.org/), a web component library
*   [Skate](https://www.gitbook.com/book/skatejs/skatejs/details), also a library
*   [web-component-tester](https://github.com/Polymer/web-component-tester), a tool for testing web components

##### Have a thought or comment? Hit us up on twitter [@bendyworks](https://twitter.com/bendyworks) or on [Facebook.](https://www.facebook.com/bendyworks)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
