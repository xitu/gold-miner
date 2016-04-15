>* 原文链接 : [HOMEBLOG React JS: newbies tutorial](http://www.leanpanda.com/blog/2016/04/06/react-newbies-tutorial/)
* 原文作者 : Elise Cicognani
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



As you can probably guess from the title, this post is aimed at readers with very little experience of programming. That is, at people such as myself: as I've only been exploring the world of programming for six months now. **So, it's going to be a genuine newbies tutorial!** To follow it, you'll only need to have an understanding of HTML and CSS and a basic level of Javascript (JS).  

N.B. In the following examples we will be taking advantage of some of the new abilities offered by ES6 to facilitate the process of writing JS code. It is, however, entirely possible to use React with ES5.

Estimate reading 9 minutes

<div>

### What is React?

React is a JS library, created by Facebook and Instagram ([https://facebook.github.io/react/](https://facebook.github.io/react/)), which makes it possible to create single-page applications ([Single Page Applications (SPA)](http://www.leanpanda.com/blog/2015/05/25/single-page-application-development/)) using a structure that divides them into a number of dynamic, reusable **components**.

A React component is a JS class that extends the **Component** class provided by React itself. A component represents and defines a block of HTML code, together with any behaviour associated with that block, such as a click event. Components are like Lego blocks that can be assembled to create complex applications as desired. Components, which are entirely composed of JS code, can be isolated and re-used. The fundamental method is **render()**, which simply returns a piece of HTML code.

The syntax used to define the React components is called **JSX**. This syntax was developed by the React creators to facilitate JS-HTML code interaction within components. Code written using the syntax must be compiled prior to becoming actual JS code.

### Creating a component

In order to create our component and render it on a page of HTML, we will first need to define a div, with a unique id, within our HTML file. Next, we will write code in the JSX file to connect the React component to the div using its id, as shown in the following example. Doing things this way will instruct the browser to render the component on the page within the related DOM tag.

<iframe height="266" scrolling="no" src="//codepen.io/makhenzi/embed/XXdmvL/?height=266&amp;theme-id=0&amp;default-tab=js,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen &lt;a href="http://codepen.io/makhenzi/pen/XXdmvL/"&gt;Start&lt;/a&gt; by Makhenzi (&lt;a href="http://codepen.io/makhenzi"&gt;@makhenzi&lt;/a&gt;) on &lt;a href="http://codepen.io"&gt;CodePen&lt;/a&gt;.</iframe>

See the Pen [Start](http://codepen.io/makhenzi/pen/XXdmvL/) by Makhenzi ([@makhenzi](http://codepen.io/makhenzi)) on [CodePen](http://codepen.io).

The attributes of HTML tags within JSX are practically the same as those of normal HTML; with the exception of “class”, which becomes “className” in JSX. The HTML-like syntax is enclosed in round brackets, while the sections containing JS are enclosed in squared ones; as you will see further on. render() will _always_ return a single div, within which the developer is free to include as many tags and elements as they see fit.

## Example: pirates’ extintion

<figure>![](https://upload.wikimedia.org/wikipedia/it/8/84/PiratiVsTemp.png)</figure>

If we choose to create this graphic using React, we will be able to visualize the various dates on-screen and make the relevant temperature and number of pirates appear when those dates are clicked on.

For this we will need two components: the first will be required in order to render the dates and will connect each date to a given number of pirates and a given temperature; the second will be required in order to receive the information relating to the click event on the date, the number of pirates, the temperature and to render the selected elements on the basis of that data.

The former component will act as a the “parent” and will contain links to the various latter “child” components, which will themselves be closely dependent on their “parents”.

The React structure, known as a [virtual DOM](https://facebook.github.io/react/docs/working-with-the-browser.html), makes it possible to update a component every time its content undergoes a change, without the need for the entire page to be refreshed. For this purpose, the component will require an internal method in which the variable data and specific HTML attributes assigned to the element which are to undergo changes will be saved. Those attributes will themselves be linked to other methods which we will define within the components and which will be responsible for bringing about changes.

## State e props

In our example, the independent variable data is composed of dates. These vary as a result of click events which set of chain reactions within the DOM that alter according to the information relating to pirates and temperature. We will therefore save the information related to each date in a “DATA” object. We will also make use of React’s `this.state={}` property within the parent component to save variable data in the form of key-value copies.

Organizing the programme in this way will make it possible for us to take advantage of the methods Reach puts at our disposal to enable us to interact with that data in “state” and carry out arbitrary changes to it.

Given that we want to use the keys of our DATA object to render the dates in HTML, it would be great if we could find a way of using the JS `map()` method ([Array.prototype.map()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map)) on the keys, so as to display the return directly in the `render()` HTML. And there is a way to do so! We’ll just need to wrap the JS code in double squared parentheses at the point where we want the output of that code to be displayed in the DOM block that manages the component, and we’re done.

In this particular case, we will define the `map()` callback in a method within the component, which will return a piece of HTML in the `render()` of the same component.

<iframe height="266" scrolling="no" src="//codepen.io/makhenzi/embed/XXdmvL/?height=266&amp;theme-id=0&amp;default-tab=js,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen &lt;a href="http://codepen.io/makhenzi/pen/XXdmvL/"&gt;Start&lt;/a&gt; by Makhenzi (&lt;a href="http://codepen.io/makhenzi"&gt;@makhenzi&lt;/a&gt;) on &lt;a href="http://codepen.io"&gt;CodePen&lt;/a&gt;.</iframe>

See the Pen [State1](http://codepen.io/makhenzi/pen/qbZbxR/) by Makhenzi ([@makhenzi](http://codepen.io/makhenzi)) on [CodePen](http://codepen.io).

In order to assign a click event to each date, we will assign them the `onClick` attribute. In this attribute we will call the method of the component in which we are going to define the logic that will modify the state and other changes that we may wish to trigger following the onClick event.

In our example, we will define this method as `handleClick()`. Within handleClick() we will call the React method `setState()`, which will permit us to change the state data at each click event. We will just need to insert an object containing the keys of the state that we want to modify and assigning them their related new values inside the parentheses of the latter.

To summarize, every time a date is clicked on the onClick attribute in the selected div calls the `HandClick()` method, which in turns calls the setState() method which modifies the component’s state.

Every time the state changes, and as soon as that happens, React automatically checks the return of the `render()` of the component, in search of content to be updated based on the new state. In the case of there being such data, React will automatically trigger a new `render()` updating only the piece of HTML that is to changed.

(You have my apologies, but in the following example I have inserted three lines of code that make use of Classnames, a little utility for managing CSS on the basis of state changes. I’ve done so just to give a bit of colour to the preview. I will also make use of it in the final example to populate the preview with a number of pirate variables. You can find a link to the Classnames GitHub repository, together with an [easy-to-use to guide](https://github.com/JedWatson/classnames).)

<iframe height="266" scrolling="no" src="//codepen.io/makhenzi/embed/EPKwRo/?height=266&amp;theme-id=0&amp;default-tab=js,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen &lt;a href="http://codepen.io/makhenzi/pen/EPKwRo/"&gt;State2&lt;/a&gt; by Makhenzi (&lt;a href="http://codepen.io/makhenzi"&gt;@makhenzi&lt;/a&gt;) on &lt;a href="http://codepen.io"&gt;CodePen&lt;/a&gt;.</iframe>

See the Pen [State2](http://codepen.io/makhenzi/pen/EPKwRo/) by Makhenzi ([@makhenzi](http://codepen.io/makhenzi)) on [CodePen](http://codepen.io).

Now that the state of our parent component has been set up to change on the basis of selected data the time to create the child component, which will illustrate the number of pirates and the appropriate temperature, has arrived.

We will create an instance of the child component in our JSX file, as we previously did with the parent component. In order to link the child to the parent it will be sufficient for us to define the connection within the return of the latter’s `render()` using the same syntax and a HTML tag. If we call it “Child”, it will appear within the HTML block at the point where we insert `<child></child>`.

Our child component must also pass the information it has regarding the currently selected data related to pirates and temperature to its parent. For this purpose, we will make use of the attributes assigned Child’s tag, in which names are chosen in an arbitrary fashion and whose information is available to the parent component.

In this way, the child component will be able to gain access to its own internal information by means of accessing data apparently belonging to its parent, by making use of these “attribute-bridges”, or **props**. In our example, Child’s props will be `this.props.pirates` and `this.props.temperature`, and will contain information that will vary according to the current state of parent component.

So, every time the state of the parent changes, the content of the child’s props are automatically updated too. But, as the child’s `render()` displays the props content, this will also be automatically updated on the basis of any new information received, following a linear flow of unidirectional data.

<iframe height="266" scrolling="no" src="//codepen.io/makhenzi/embed/EPKbmO/?height=266&amp;theme-id=0&amp;default-tab=js,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen &lt;a href="http://codepen.io/makhenzi/pen/EPKbmO/"&gt;Props&lt;/a&gt; by Makhenzi (&lt;a href="http://codepen.io/makhenzi"&gt;@makhenzi&lt;/a&gt;) on &lt;a href="http://codepen.io"&gt;CodePen&lt;/a&gt;.</iframe>

See the Pen [Props](http://codepen.io/makhenzi/pen/EPKbmO/) by Makhenzi ([@makhenzi](http://codepen.io/makhenzi)) on [CodePen](http://codepen.io).

All done! The components interact with each other and render diverse content in the DOM according to our clicks, without the need for a single page to be refreshed. Working from this base, the complexity of the interactions and the number of component can be increased as desired, making it possible to create complex, efficient applications.

If you to be inspired by this library’s potential, [take a look at the react.rocks site](https://react.rocks/), where you’ll find a load of interesting ideas to get you started. (:

