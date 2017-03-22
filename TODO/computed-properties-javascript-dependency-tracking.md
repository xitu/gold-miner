> * 原文地址：[How to build a reactive engine in JavaScript. Part 2: Computed properties and dependency tracking](https://monterail.com/blog/2017/computed-properties-javascript-dependency-tracking)
> * 原文作者：本文已获原作者 [Damian Dulisz](https://disqus.com/by/damiandulisz/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

![](https://d4a7vd7s8p76l.cloudfront.net/uploads/56873733-c918-4cd6-bac1-dea44dcc3a9f/Reactive%20engine.png)

# [How to build a reactive engine in JavaScript. Part 2: Computed properties and dependency tracking](/blog/2017/computed-properties-javascript-dependency-tracking/) #

Hey! If you have ever worked with Vue.js, Ember or MobX I’m pretty sure you stumbled upon so-called **computed** properties. They allow you to create functions that can be accessed just like normal values, but once computed they are cached until one of its dependencies has changed. In general this is a concept very similar to getters and in fact, the following implementation will be using getters. In a smart way. ;)

> This is the 2nd part of the How to build a reactive engine in JavaScript series. Before reading any further it is highly recommended to read [Part 1: Observable objects](https://monterail.com/blog/2016/how-to-build-a-reactive-engine-in-javascript-part-1-observable-objects), because the following implementation is built on top of the previous article's code.

## Computed properties ##

Let’s say we have a computed property called `fullName` which is a combination of `firstName` and `lastName` with space in between.

In Vue.js such a computed value could be created like this:

```
data: {
  firstName: 'Cloud',
  lastName: 'Strife'
},
computed: {
  fullName () {
    return this.firstName + ' ' + this.lastName // 'Cloud Strife'
  }
}
```

Now if we use the `fullName` somewhere in our template, we expect it will be updated whenever `firstName` or `lastName` change. If you come from an AngularJS background you might also remember using expressions inside the template or function calls. Of course, this works the same when using render functions (with JSX or not); it doesn’t really matter.

Let’s consider the following example:

```
<!-- expression -->
<h1>{{ firstName + ' ' + lastName }}</h1>
<!-- function call -->
<h2>{{ getFullName() }}</h2>
<!-- computed property -->
<h3>{{ fullName }}</h3>
```

The result of the above code will be mostly the same. Each time `firstName` or `lastName` changes, the view will update with the headers and show the full name.

However, what if we use the expression, method call and computed property multiple times? The expression and method call will have to be calculated each time they are accessed, whereas the computed property will be cached after the first computation until one of its dependencies change. It will also persist through the re-render cycles! That’s actually quite a nice optimization if you consider that in event-based modern user interfaces, it’s hard to predict which action the user will take first.

## Basic computed property ##

In the previous article, we learned how to track and react to changes inside observable object properties by utilizing an event emitter. We know that when we change the `firstName` it will call all the handlers that subscribed to the `’firstName’` event. Thus it is quite easy to build a computed property by manually subscribing to its dependencies.
This is actually how Ember does it:

```
fullName: Ember.computed('firstName', 'lastName', function() {
  return this.get('firstName') + ' ' + this.get('lastName')
})
```

The drawback here is that you have to declare the dependencies yourself. Doesn’t seem like a problem until you have computed properties that are a result of a chain of more expensive, complex functions. For example:

```
selectedTransformedList: Ember.computed('story', 'listA', 'listB', 'listC', function() {
  switch (this.story) {
    case 'A':
      return expensiveTransformation(this.listA)
    case 'B':
      return expensiveTransformation(this.listB)
    default:
      return expensiveTransformation(this.listC)
  }
})
```

In the above case, even if `this.story` always equals `’A’`, the computed property will have to be re-evaluated each time one of the lists changes. Even if they are not used for the end result.

## Dependency tracking ##

Vue.js and MobX take a different approach to this problem. The difference is, you don’t have to declare the dependencies at all because they are detected automatically each time it is evaluated. Let say `this.story = ‘A’`. The detected dependencies will be:
* `this.story`
* `this.listA`
When `this.story` changes to `’B’` it will collect a fresh set of dependencies and remove the unnecessary ones (`this.listA`) that were used before but was not called anymore.
This way even if the other lists change it won’t trigger a recalculation of `selectedTransformedList`.
That’s smart!

Now it’s a good time to look again at the [code from the previous article - JSFiddle](https://jsfiddle.net/shentao/4k0gk3bx/10/), as the following changes will be based upon that code.

> The code in this article is written to be as simple as possible, ignoring many sanity checks and optimizations. By no means is it production ready, as it’s the only purpose is strictly educational.

Let’s create a new data model:

```
const App = Seer({
  data: {
    // observable values
    goodCharacter: 'Cloud Strife',
    evilCharacter: 'Sephiroth',
    placeholder: 'Choose your side!',
    side: null,
    // computed property
    selectedCharacter () {
      switch (this.side) {
        case 'Good':
          return `Your character is ${this.goodCharacter}!`
        case 'Evil':
          return `Your character is ${this.evilCharacter}!`
        default:
          return this.placeholder
      }
    },
    // computed property depending on other computed
    selectedCharacterSentenceLength () {
      return this.selectedCharacter.length
    }
  }
})
```

### Detecting the dependencies ###

To find out the dependencies of the currently evaluated computed property, we need a way to collect the dependencies. As you know, every observable property is already transformed into a getter and setter.
When evaluating the computed property (function) it will access other properties, which will trigger their getters.

For example this function:

```
{
  fullName () {
    return this.firstName + ' ' + this.lastName
  }
}
```

will call both the `firstName` and `lastName` getters.

Let’s make use of it!

We need a way to collect the information that a getter was called when evaluating a computed property. For this to work, first we need a place to store which computed property is currently being evaluated. We can use a simple object for this:

```
let Dep = {
  // Name of the currently evaluated computed value
  target: null
}
```

We used the `makeReactive` function to transform primitives into observable properties. Let’s create a transform function for computed properties and name it `makeComputed`.

```
function makeComputed (obj, key, computeFunc) {
  Object.defineProperty(obj, key, {
    get () {
      // If there is no target set
      if (!Dep.target) {
        // Set the currently evaluated property as the target
        Dep.target = key
      }
      const value = computeFunc.call(obj)

      // Clear the target context
      Dep.target = null
      return value
    },
    set () {
      // Do nothing!
    }
  })
}

// It will be later called in this manner
makeComputed(data, 'fullName', data['fullName'])
```

Okay. Now that the context is available, we can modify our `makeReactive` function that we created in the previous article to make use of that context.

The new `makeReactive` function should look like this:

```
function makeReactive (obj, key) {
  let val = obj[key]
  // create an empty array for storing dependencies
  let deps = []

  Object.defineProperty(obj, key, {
    get () {
      // Run only when called within a computed property context
      if (Dep.target) {
        // Add the computed property as depending on this value
        // if not yet added
        if (!deps.includes(Dep.target)) {
          deps.push(Dep.target)
        }
      }
      return val
    },
    set (newVal) {
      val = newVal
      // If there are computed properties
      // that depend on this value
      if (deps.length) {
        // Notify each computed property observers
        deps.forEach(notify)
      }
      notify(key)
    }
  })
}
```

One last thing we need is to slightly modify our `observeData` function so that it runs `makeComputed` instead of `makeReactive` for properties that are functions.

```
function observeData (obj) {
  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      if (typeof obj[key] === 'function') {
        makeComputed(obj, key, obj[key])
      } else {
        makeReactive(obj, key)
      }
    }
  }
  parseDOM(document.body, obj)
}
```

And that’s basically it! We just created our own implementation of computed properties with dependency tracking.

Sadly – the above, very naive implementation still lacks some crucial features that can be found in Vue.js and MobX. I guess the most important of those will be caching and removing the dead dependencies. So let’s add them.

## Caching ##

First, we need to add a place to store the cache. Let’s add our cache management to the `makeComputed` function:

```
function makeComputed (obj, key, computeFunc) {
  let cache = null

  // Observe self to clear cache when deps change
  observe(key, () => {
    // Clear cache
    cache = null
  })

  Object.defineProperty(obj, key, {
    get () {
      if (!Dep.target) {
        Dep.target = key
      }

      // If not cached yet
      if (!cache) {
        // calculate new value and save to cache
        cache = computeFunc.call(obj)
      }

      Dep.target = null
      return cache
    },
    set () {
      // Do nothing!
    }
  })
}
```

That’s it! Now each time we access our computed property after the initial computation, it will return the cached value until it has to be recalculated. Pretty straightforward, right?

Thanks to the `observe` method we used inside `makeComputed` during the data transformation process, we ensure to always clean the cache before other signal handlers are executed. This means whenever one of the computed property’s dependencies change, the cache will be cleaned, just before the interface gets updated.

## Removing the unnecessary dependencies ##

So now what’s left is to get rid of dependencies that are no longer valid. This is often a case when our computed properties conditionally depend on different values. What we want to achieve is our computed property only depending on the last used dependencies. The above implementation is flawed in that once a dependency registers that a computed property depends on it, it stays this way forever.

There are probably better ways to handle this, but because we want to keep things really simple let’s just create a secondary dependency list. One that will store a computed property’s dependencies.
To sum things up, our dependency lists:

- List of computed property names that depend on this value (observables or other computed) stored locally. Think: **Those are the values that depend on me.**
- A secondary dependency list that is used to remove dead dependencies and stores the most recent dependencies of a computed property. Think: **Those are the values I’m depending on.**

With those two lists, we can run a filter function to remove the no longer valid dependencies. So let’s start with creating an object to store a secondary dependency list and some utility functions.

```
let Dep = {
  target: null,
  // Stores the dependencies of computed properties
  subs: {},
  // Create a two-way dependency relation between computed properties
  // and other computed or observable values
  depend (deps, dep) {
    // Add the current context (Dep.target) to local deps
    // as depending on the current property
    // if not yet added
    if (!deps.includes(this.target)) {
      deps.push(this.target)
    }
    // Add the current property as a dependency of the computed value
    // if not yet added
    if (!Dep.subs[this.target].includes(dep)) {
      Dep.subs[this.target].push(dep)
    }
  },
  getValidDeps (deps, key) {
    // Filter only valid dependencies by removing dead dependencies
    // that were not used during last computation
    return deps.filter(dep => this.subs[dep].includes(key))
  },
  notifyDeps (deps) {
    // notify all existing deps
    deps.forEach(notify)
  }
}
```

If the `Dep.depend` method doesn’t make much sense right now, wait until we use it. It should become more clear what is actually happening there.

First, let’s tune the `makeReactive` transform function.

```
function makeReactive (obj, key, computeFunc) {
  let deps = []
  let val = obj[key]

  Object.defineProperty(obj, key, {
    get () {
      // Run only when getting within a computed value context
      if (Dep.target) {
        // Add Dep.target as depending on this value
        // this will mutate the deps Array
        // as we’re passing a reference to it
        Dep.depend(deps, key)
      }

      return val
    },
    set (newVal) {
      val = newVal

      // Clean up dead dependencies
      deps = Dep.getValidDeps(deps, key)
      // and notify valid deps
      Dep.notifyDeps(deps, key)

      notify(key)
    }
  })
}
```

Almost the same has to be changed inside the `makeComputed` transform function. The difference is that we won’t be using the setter but the signal handler callback we passed to the `observe` function. Why? Because this callback will be called whenever the actual computed value has to update, as its dependencies have changed.

```
function makeComputed (obj, key, computeFunc) {
  let cache = null
  // Create a local deps list similar to makeReactive deps
  let deps = []

  observe(key, () => {
    cache = null

    // Clean up and notify valid deps
    deps = Dep.getValidDeps(deps, key)
    Dep.notifyDeps(deps, key)
  })

  Object.defineProperty(obj, key, {
    get () {
      // If evaluated during the evaluation of
      // another computed property
      if (Dep.target) {
        // Create a dependency relationship
        // between those two computed properties
        Dep.depend(deps, key)
      }
      // Normalize Dep.target back to self
      // This makes it possible to build a dependency tree
      // instead of a flat structure
      Dep.target = key

      if (!cache) {
        // Clear dependencies list to ensure getting a fresh one
        Dep.subs[key] = []
        cache = computeFunc.call(obj)
      }

      // Clear the target context
      Dep.target = null
      return cache
    },
    set () {
      // Do nothing!
    }
  })
}
```

Done! You might have already noticed that it also enables computed properties to be dependent on other computed properties, without having to know about the observables that lie underneath. Pretty sweet, isn’t it?

## Asynchronous pitfalls ##

Now that you know how dependency tracking works, it should be quite obvious why it’s not possible to track asynchronous data inside computed properties both in MobX and Vue.js. It all breaks because even a `setTimeout(callback, 0)` will be called out of the current context where `Dep.target` no longer exists. This means that whatever happens inside the callback won’t be tracked.

## Bonus: Watchers ##

The above problem can be, however, partially tackled with watchers. You might know them from Vue.js. Building watchers on top of what we already have is actually really simple. After all, a watcher is just a signal handler called after a given value has changed.

We just have to add a watchers registration method and trigger it within our Seer function.

```
function subscribeWatchers(watchers, context) {
  for (let key in watchers) {
    if (watchers.hasOwnProperty(key)) {
      // We use Function.prototype.bind to bind our data model
      // as the new `this` context for our signal handler
      observe(key, watchers[key].bind(context))
    }
  }
}

subscribeWatchers(config.watch, config.data)
```

That’s all! We can use it like this:

```
const App = Seer({
  data: {
    goodCharacter: 'Cloud Strife'
  },
  // here we can declare watchers
  watch: {
    // watch for 'goodCharacter' changes
    goodCharacter () {
      // log the value into the console
      console.log(this.goodCharacter)
    }
  }
}

```

The complete code is available here:
[https://github.com/shentao/seer/tree/cached-computed](https://github.com/shentao/seer/tree/cached-computed)

You can play with it online here (Opera/Chrome only):
[https://jsfiddle.net/oyw72Lyy/](https://jsfiddle.net/oyw72Lyy/)

## Summary ##

I hope you enjoyed the tutorial and that the provided explanation turned out to be good enough to bring some light into what might be happening inside Vue or MobX when using computed properties. Keep in mind that the provided implementation was meant to be quite naive and not on par with the mentioned libraries. It is also not production ready in any way.

## What comes next? ##

The 3rd part should include support for nested properties and observing arrays. I might also finally add a way to unsubscribe from the event bus! :D
As for the 4th part – maybe streams? Would you be interested?

Feel free to leave your feedback in the comments!

Thanks for reading!

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
