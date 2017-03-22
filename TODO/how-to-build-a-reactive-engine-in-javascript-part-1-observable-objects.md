> * 原文地址：[How to build a reactive engine in JavaScript. Part 1: Observable objects](https://monterail.com/blog/2016/how-to-build-a-reactive-engine-in-javascript-part-1-observable-objects)
> * 原文作者：[Damian Dulisz](https://disqus.com/by/damiandulisz/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

![](https://d4a7vd7s8p76l.cloudfront.net/uploads/1484604970-4-7876/observables.png)

# [How to build a reactive engine in JavaScript. Part 1: Observable objects](/blog/2016/how-to-build-a-reactive-engine-in-javascript-part-1-observable-objects/) # 

## The reactive way ##

With the growing need for robust and interactive web interfaces, many developers have started embracing the reactive programming paradigm.

Before we begin implementing our own reactive engine, let’s quickly explain what reactive programming actually is. Wikipedia gives us a classic example of a reactive interface implementation – namely a spreadsheet. Defining a formula such as `=A1+B1` would update the cell whenever either `A1` or `B1` change. Such a formula can be considered a computed value.

You will learn how to implement computed values in the second part of this reactive series. Before that, we first need a base for our reactivity engine.

## The engine ##

Currently there are many different approaches to solving the problem of observing and reacting to the changing application state.

- Angular 1.x has its dirty checking.
- React, because of the way it works – doesn’t actually track changes in the data model. It uses the virtual DOM to diff and patch the DOM.
- Cycle.js and Angular 2 prefer the reactive streams implementations like XStream and Rx.js.
- Libraries like Vue.js, MobX or Ractive.js all use a variation of getters/setters to create observable data models.

In this tutorial, we will go the getters/setters way of observing and reacting to changes.

> Note: To keep the tutorial as simple as possible, the code lacks the support for non-primitive data types or nested properties and many of the required sanity checks, thus by no means should this code be considered production ready. The code below is written using the ES2015 standard and is loosely inspired by the Vue.js reactive engine implementation.

## The observable object ##

Let’s start with a `data` object, whose properties we want to observe.

```
let data = {
  firstName: 'Jon',
  lastName: 'Snow',
  age: 25
}
```

Let’s start by creating two functions that will transform our object’s properties into observable properties using the getter/setter functionality.

```
function makeReactive (obj, key) {
  let val = obj[key]

  Object.defineProperty(obj, key, {
    get () {
      return val // Simply return the cached value
    },
    set (newVal) {
      val = newVal // Save the newVal
      notify(key) // Ignore for now
    }
  })
}

// Iterate through our object keys
function observeData (obj) {
  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      makeReactive(obj, key)
    }
  }
}

observeData(data)
```

By running `observeData(data)` we transform our object into an object capable of being observed; now we have a way to create notifications whenever the value changes.

## Reacting to changes ##

Before we begin *notifying*, we need something that we can actually notify. This is a perfect example where we can use the observer pattern. In this case we will make use of the signals implementation.

Let’s start with the `observe` function.

```
let signals = {} // Signals start as an empty object

function observe (property, signalHandler) {
  if(!signals[property]) signals[property] = [] // If there is NO signal for the given property, we create it and set it to a new array to store the signalHandlers

  signals[property].push(signalHandler) // We push the signalHandler into the signal array, which effectively gives us an array of callback functions
}
```

We can now use the `observe` function like this: `observe('propertyName', callback)`, where `callback` is a function that should be called each time the property’s value has changed. When we **observe** a property multiple times, each callback will be stored inside the corresponding property’s signal array. This way we can store all callbacks and have easy access to them.

Now for the `notify` function that you saw before.

```
function notify (signal, newVal) {
  if(!signals[signal] || signals[signal].length < 1) return // Early return if there are no signal handlers

  signals[signal].forEach((signalHandler) => signalHandler()) // We call each signalHandler that’s observing the given property
}
```

As you can see, now every time one of the properties changes, the assigned signalHandlers will be called.

So let’s wrap it all up into a factory function that we pass the data object that has to be reactive. I will name mine `Seer`. We end up with something like this:

```
function Seer (dataObj) {
  let signals = {}

  observeData(dataObj)

  // Besides the reactive data object, we also want to return and thus expose the observe and notify functions.
  return {
    data: dataObj,
    observe,
    notify
  }

  function observe (property, signalHandler) {
    if(!signals[property]) signals[property] = []

    signals[property].push(signalHandler)
  }

  function notify (signal) {
    if(!signals[signal] || signals[signal].length < 1) return

    signals[signal].forEach((signalHandler) => signalHandler())
  }

  function makeReactive (obj, key) {
    let val = obj[key]

    Object.defineProperty(obj, key, {
      get () {
        return val
      },
      set (newVal) {
        val = newVal
        notify(key)
      }
    })
  }

  function observeData (obj) {
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        makeReactive(obj, key)
      }
    }
  }
}
```

All we need to do now is to create a new reactive object. Thanks to the exposed `notify` and `observe` functions, we can observe and react to the changes made to the object.

```
const App = new Seer({
  title: 'Game of Thrones',
  firstName: 'Jon',
  lastName: 'Snow',
  age: 25
})

// To subscribe and react to changes made to the reactive App object:
App.observe('firstName', () => console.log(App.data.firstName))
App.observe('lastName', () => console.log(App.data.lastName))

// To trigger the above callbacks simply change the values like this:
App.data.firstName = 'Sansa'
App.data.lastName = 'Stark'

```

Simple, isn’t it? Now that we have the basic reactivity engine covered, let’s make some use of it.
I mentioned that with the more reactive approach to front-end programming, we should not be concerned with things like manually updating the DOM after each change.

There are many approaches to this. I guess the most trending one right now is the so called virtual DOM. If you are interested in learning how to create your own virtual DOM implementation, there are already great tutorials for this. However, here we will go with a much simpler approach.

Let’s say our HTML looks like this:`html<h1>Title comes here</h1>`

The function responsible for updating the DOM would look like this:

```
// First we need to get the node that we want to keep updating.
const h1Node = document.querySelector('h1')

function syncNode (node, obj, property) {
  // Initialize the h1’s textContent value with the observed object’s property value
  node.textContent = obj[property]

  // Start observing the property using our Seer instance App.observe method.
  App.observe(property, value => node.textContent = obj[property] || '')
}

syncNode(h1Node, App.data, 'title')
```

This will work but actually requires a lot of work from us to actually bind all the DOM elements to the desired data models.

That’s why we can go a step further and automate all of this.
If you are familiar with AngularJS or Vue.js you surely remember using custom HTML attributes like `ng-bind` or `v-text`. We will create something similar here!
Our custom attribute will be called `s-text`. We will look for it to create bindings between the DOM and the data model.

Let’s update our HTML:

```
<!-- 'title' is the property which value we want to show inside the <h1> element -->
<h1 s-text="title">Title comes here</h1>
function parseDOM (node, observable) {
  // We get all nodes that have the s-text custom attribute
  const nodes = document.querySelectorAll('[s-text]')

  // For each existing node, we call the syncNode function
  nodes.forEach((node) => {
    syncNode(node, observable, node.attributes['s-text'].value)
  })
}

// Now all we need to do is call it with document.body as the root node. All `s-text` nodes will automatically create bindings to the corresponding reactive property.
parseDOM(document.body, App.data)
```

## Summary ##

Now that we have a way to parse the DOM and bind the nodes to the data model, let’s add those two functions into the Seer factory function, where we will parse the DOM on initialization.

The result should look like this:

```
function Seer (dataObj) {
  let signals = {}

  observeData(dataObj)

  return {
    data: dataObj,
    observe,
    notify
  }

  function observe (property, signalHandler) {
    if(!signals[property]) signals[property] = []

    signals[property].push(signalHandler)
  }

  function notify (signal) {
    if(!signals[signal] || signals[signal].length < 1) return

    signals[signal].forEach((signalHandler) => signalHandler())
  }

  function makeReactive (obj, key) {
    let val = obj[key]

    Object.defineProperty(obj, key, {
      get () {
        return val
      },
      set (newVal) {
        val = newVal
        notify(key)
      }
    })
  }

  function observeData (obj) {
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        makeReactive(obj, key)
      }
    }
    // We can safely parse the DOM looking for bindings after we converted the dataObject.
    parseDOM(document.body, obj)
  }

  function syncNode (node, observable, property) {
    node.textContent = observable[property]
    // We remove the `Seer.` as it is now available for us in our scope.
    observe(property, () => node.textContent = observable[property])
  }

  function parseDOM (node, observable) {
    const nodes = document.querySelectorAll('[s-text]')

    nodes.forEach((node) => {
      syncNode(node, observable, node.attributes['s-text'].value)
    })
  }
}
```

Example on JsFiddle:

HTML

```
<h1 s-text="title"></h1>
<div class="form-inline">
  <div class="form-group">
    <label for="title">Title: </label>
    <input 
      type="text" 
      class="form-control" 
      id="title" placeholder="Enter title"
      oninput="updateText('title', event)">
  </div>
  <button class="btn btn-default" type="button" onclick="resetTitle()">Reset title</button>
</div>
```

JS

```
// This code uses ES2015.
// Please use a compatible browser like: Chrome, Opera, Firefox

function Seer (dataObj) {
  let signals = {}

  observeData(dataObj)

  return {
    data: dataObj,
    observe,
    notify
  }

  function observe (property, signalHandler) {
    if(!signals[property]) signals[property] = []

    signals[property].push(signalHandler)
  }

  function notify (signal) {
    if(!signals[signal] || signals[signal].length < 1) return

    signals[signal].forEach((signalHandler) => signalHandler())
  }

  function makeReactive (obj, key) {
    let val = obj[key]

    Object.defineProperty(obj, key, {
      get () {
        return val
      },
      set (newVal) {
        val = newVal
        notify(key)
      }
    })
  }

  function observeData (obj) {
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        makeReactive(obj, key)
      }
    }
    // We can safely parse the DOM looking for bindings after we converted the dataObject.
    parseDOM(document.body, obj)
  }

  function syncNode (node, observable, property) {
    node.textContent = observable[property]
    // We remove the `Seer.` as it is now available for us in our scope.
    observe(property, () => node.textContent = observable[property])
  }

  function parseDOM (node, observable) {
    const nodes = document.querySelectorAll('[s-text]')

    for (const node of nodes) {
      syncNode(node, observable, node.attributes['s-text'].value)
    }
  }
}

const App = Seer({
  title: 'Game of Thrones',
  firstName: 'Jon',
  lastName: 'Snow',
  age: 25
})

function updateText (property, e) {
	App.data[property] = e.target.value
}

function resetTitle () {
	App.data.title = "Game of Thrones"
}
```

Resources

```
EXTERNAL RESOURCES LOADED INTO THIS FIDDLE:

bootstrap.min.css
```

Result

![Markdown](http://i2.buimg.com/1949/cf89248985467d6f.png)

The above code can be found here: [github.com/shentao/seer](https://github.com/shentao/seer/tree/master)

## To be continued... ##

This is the first part in a series about crafting your own reactivity engine.

**The next part will be about creating computed properties, where each has its own trackable dependencies.**

Your feedback and ideas on what to cover next are both very welcome in the comments!

Thanks for reading. 

