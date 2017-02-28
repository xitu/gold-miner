> * 原文地址：[React’s JSX vs Vue’s templates: a showdown on the front end](https://medium.freecodecamp.com/reacts-jsx-vs-vue-s-templates-a-showdown-on-the-front-end-b00a70470409#.wbkkiga1e)
* 原文作者：[Juan Vega](https://medium.freecodecamp.com/@juanmvega)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

---

# React’s JSX vs Vue’s templates: a showdown on the front end

![](https://cdn-images-1.medium.com/max/2000/1*QH4RGlNwXUFnJSytytvb6A.jpeg)

React.js and Vue.js are two of the most popular JavaScript libraries on the planet. They are both powerful and are relatively easy to pick up and run with.

Both React and Vue:

- use a virtual DOM
- provide reactive view components
- maintain a focus on one aspect of development. In this case, the view.

With so many similarities, you might assume that they’re both different versions of the same thing.

Well there’s one major difference between these two libraries: how they empower you the developer to create your view components, and in turn, your application.

React uses JSX, a term coined by the React team, to render content onto the DOM. So what is JSX? Basically, JSX is a JavaScript render function that helps you insert your HTML right into your JavaScript code.

Vue takes a different approach and uses HTML-like templates. Using Vue templates is like using JSX in that they’re both created using JavaScript. The main difference is that JSX functions are never used in the actual HTML file, while Vue templates are.

### **React JSX**

Let’s take a deeper look into how JSX works. Assume that you have a list of names that you want to display onto the DOM. A list of new hires that your company recently made.

If you were using plain HTML, you would first need to create an index.html file. Then you would add the following lines of code.

    <ul>

      <li> John </li>

      <li> Sarah </li>

      <li> Kevin </li>

      <li> Alice </li>

    <ul>

Nothing spectacular here, just plain HTML code.

So how would you do the same thing using JSX? The first step would be to create another index.html file. But instead of adding the full HTML like you did before, you’ll only add a simple `div` element. This `div` will be the container element where all your React code will be rendered.

The `div` will need to have a unique ID so that React knows where to find it. Facebook tends to favor the root keyword, so let’s stick with that.

    <div id=root></div>

Now, onto the most important step. Creating the JavaScript file that will hold all the React code. Call this one app.js.

So now that you have all that out of the way, onto the main event. Displaying all the new hires to the Dom using JSX

You would first need to create an array with the names of the new hires.

    const names = [‘John’, ‘Sarah’, ‘Kevin’, ‘Alice’];

From there you would need to create a React element that will dynamically render the entire list of names. This without you having to manually display each one.

    const displayNewHires = (

      <ul>

        {names.map(name => <li>{name}</li> )}

      </ul>

    );

The key thing to note here is that you are not having to create individual `<li>` elements. You only need describe how you want them to look once and React will handle the rest. That is quite a powerful thing. While you only have a few names, imagine having a list of hundreds of thousands! You can see how this would be a much better approach. Especially if the `<li>` elements are more complex than the ones used here.

The last bit of code that is needed to render the content to the screen is the main ReactDom render function.

    ReactDOM.render(

      displayNewHires,

      document.getElementById(‘root’)

    );

Here you are telling React to render the content of `displayNewHires` inside the `div` with an element of root.

This is what your final React code should look like:

    const names = [‘John’, ‘Sarah’, ‘Kevin’, ‘Alice’];

    const displayNewHires = (

      <ul>

        {names.map(name => <li>{name}</li> )}

      </ul>

    );

    ReactDOM.render(

      displayNewHires,

      document.getElementById(‘root’)

    );

One key thing to keep in mind here is that this is all React code. This means that it will all compile down to plain old JavaScript. Here’s what it would ultimately look like:

    ‘use strict’;

    var names = [‘John’, ‘Sarah’, ‘Kevin’, ‘Alice’];

    var displayNewHires = React.createElement(

      ‘ul’,

      null,

      names.map(function (name) {

        return React.createElement(

          ‘li’,

          null,

          name

        );

      })

    );

    ReactDOM.render(displayNewHires, document.getElementById(‘root’));

That’s all there is to it. You now have a simple React application that will display a list of names. Nothing to write home about, but it should give you a glimpse of what React is capable of.

### **Vue.js Templates**

In keeping with the last example, you will once again create a simple application that will display a list of names onto the browser.

The first thing that you need to do is create another empty index.html file. Inside that file, you will then create another empty `div` with an id of root. Keep in mind though, that root is only a personal preference. You can call the id whatever you like. You only need to make sure that it matches up later on when you sync the html to your JavaScript code.

This div will function like it does in React. It will tell the JavaScript library, in this case Vue, where to look in the DOM when it wants to start making changes.

Once that’s done, you’re going to create a JavaScript file that will house all the Vue code. Call it app.js, to stay consistent.

So now that you have your files ready to go, let’s get into how Vue displays element onto the browser.

Vue uses a template-like approach when it comes to manipulating the DOM. This means that your HTML file will not only have an empty `div`, like in React. You’re actually going to write a good part of your code in your HTML file.

To give you a better idea, think back on what it takes to create a list of name using plain HTML. A `<ul>`element with some `<li>` elements inside. In Vue, you are going to do almost the exact same thing, with only a few changes added in.

Create a `<ul>` element.

    <ul>

    </ul>

Now add one empty `<li>` element inside the `<ul>` element.

    <ul>

      <li>

      </li>

    </ul>

Nothing new yet. Change that by adding a directive, a custom Vue attribute, to your `<li>`element.

    <ul>

      <li v-for=’name in listOfNames’>

      </li>

    </ul>

A directive is Vue’s way of adding JavaScript functionality straight into the HTML. They all start with v- and are followed by descriptive names that give you an idea of what they are doing. In this case, it’s a for loop. For every name in your list of names, `listOfNames`, you want to copy this `<li>`element and replace it with a new `<li>` element with a name from your list.

Now, the code only needs one final touch. Currently, it will display an `<li>` element for every name in your list, but you have not actually told it to display the actual name onto the browser. To fix that, you are going to insert some mustache like syntax inside your `<li>`element. Something you might have seen in some other JavaScript libraries.

    <ul>

      <li v-for=’name in listOfNames’>

        {{name}}

      </li>

    </ul>

Now the `<li>`element is complete. It will now display each item inside a list called listOfNames. Keep in mind that the word **name** is arbitrary. You could have called it **item** and it would have served the same purpose. All the keyword does is serve as a placeholder that will be used to iterate over the list.

The last thing that you need to do is create the data set and actually initialize Vue in your application.

To do so, you will need to create a new Vue instance. Instantiate it by assigning it to a variable called app.

    let app = new Vue({

    });

Now, the object is going to take in a few parameters. The first one being the most important, the `el` (element) parameter that tells Vue where to start adding things to the DOM. Just like you did with your React example.

    let app = new Vue({

      el:’#root’,

    });

The final step is to add the data to the Vue application. In Vue, all the data passed into the application will be done so as a parameter to the Vue instance. Also, each Vue instance can only have one parameter of each kind. While there are quite a few, you only need to focus on two for this example, `el` and `data`.

    let app = new Vue({

      el:’#root’,

      data: {

        listOfNames: [‘Kevin’, ‘John’, ‘Sarah’, ‘Alice’]

      }

    });

The data object will accept an array called `listOfNames`. Now whenever you want to use that dataset in your application, you only need to call it using a directive. Simple, right?

Here’s the final application:

#### **HTML**

    <div id=”root”>

      <ul>

        <li v-for=’name in listOfNames’>

          {{name}}

        </li>

      </ul>

    </div>

#### **JavaScript**

    new Vue({

      el:”#root”,

      data: {

        listOfNames: [‘Kevin’, ‘John’, ‘Sarah’, ‘Alice’]

      }

    });

### **Conclusion**

You know now how to create two simple applications using both React and Vue. They both offer a robust amount of features, though Vue tends to be the easier to use. Also, keep in mind that Vue allows the use of JSX, though it is not the preferred method of implementation.

Either way, these are two powerful libraries and you can’t go wrong using either one.