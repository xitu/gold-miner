> * 原文地址：[DATA FLOW IN VUE AND VUEX](https://benjaminlistwon.com/blog/data-flow-in-vue-and-vuex/)
* 原文作者：[Benjamin Listwon](https://benjaminlistwon.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：





It seems like one of the things that trips people up in [Vue](https://vuejs.org) is how to share state across components. For those new to reactive programming, something like [vuex](https://github.com/vuejs/vuex/) can seem daunting with loads of new jargon and the way it separates concerns. It can also seem like overkill when all you want is to share one or two pieces of data.

With that in mind, I thought I’d pull together a couple of quick demos. The first implements shared state by using a simple javascript object that is referenced by each new component. The second does the same with vuex. There’s also an example of something that, while it works, you should _never_ do. (We’ll look at why at the end.)

You can start by checking out the demos:

*   [Using shared object](https://benjaminlistwon.com/demo/dataflow/shared/index.html)
*   [Using vuex](https://benjaminlistwon.com/demo/dataflow/vuex/index.html)
*   [Using evil bindings](https://benjaminlistwon.com/demo/dataflow/evil/index.html)

Or [grab the repo](https://github.com/BenjaminListwon/vue-data-flow) and try it out locally! The code is 2.0 specific at a couple points, but the data flow theory is relevant in any version and is easily ported down to 1.0 with a couple changes that I try to note below.

The demos are all the same, just implemented differently. The app consists of two instance of a single chat component. Whena user posts a message in one instance, it should appear in both chat windows because the message state is what is shared. Here’s a screenshot:

![](http://ac-Myg6wSTV.clouddn.com/db8486b182725e0a482f.png)

## Sharing State With An Object

To start off, let’s take a look at how the data will flow in our example app.

![](http://ww4.sinaimg.cn/large/65e4f1e6gw1f8n994g79xj203z0463yk.jpg)

In this demo we’ll use a simple javascript object, `var store = {...}`, to share our state between the instances of the `Client.vue` component. Here’s the important bits of the key files.

##### index.html

    
    
      var store = {
        state: {
          messages: []
        },
        newMessage (msg) {
          this.state.messages.push(msg)
        }
      }
    

There’s two key things here.

1.  We make the object available to our entire app by just adding it to `index.html`. We could inject it into the app further down the chain, but this is quick and easy for now.
2.  We store our state here, but we also provide a function to act on that data. Rather than scatter unctions all over our components, we want to keep them all in one place, and simple use them whereever we need them.

##### App.vue

    
      
        
          
            
          
          
            
          
        
      
    

    
    import Client from './components/Client.vue'

    export default {
      components: {
        Client
      }
    }
    

Here we import our client componet, and create two instances of it. We use a prop, `clientid`, to uniquely identify each client. In reality, you’d do this more dynamically, but remember, quick and easy for now.

One thing to note, we don’t even pull in any state here at all.

##### Client.vue

    
      
        {{ clientid }}
        
          
              
                {{ message.sender }}: {{ message.text }}
              
          
          
            
          
        
      
    

    
    export default {
      data() {
        return {
          msg: '',
          messages: store.state.messages
        }
      },
      props: ['clientid'],
      methods: {
        trySendMessage() {
          store.newMessage({
            text: this.msg, 
            sender: this.clientid
          })
          this.resetMessage()
        },
        resetMessage() {
          this.msg = ''
        }
      }
    }
    

Here’s the meat of the app.

1.  In the template, we set up our `v-for` loop to iterate over the `messages` collection.
2.  The `v-model` binding on our text input simply stores the message the component’s local data object at `msg`.
3.  Also in the data object, we establish a reference to `store.state.messages`. This is what will trigger the update of our component.
4.  Lastly, we bind the enter key to the `trySendMessage` function. That function is a wrapper that
    1.  Prepares the data to be stored (a dictionary of sender and message).
    2.  Invokes the `newMessage` function we defined on our shared store.
    3.  Calls a cleanup function, `resetMessage`, that resets the input box. Typically you’d call that after a promise is fulfilled.

That’s it! Go [give it a try](https://benjaminlistwon.com/demo/dataflow/shared/index.html).

## Sharing State With Vuex

Okay, so now let’s try it with vuex. Again, a diagram, so we can map vuex’s terminology (actions, mutations, etc) to the example we just went through.

![](http://ww2.sinaimg.cn/large/65e4f1e6gw1f8n99fc7hrj208b046dg1.jpg)

As you can see, vuex simply formalizes the process we just went through. When you use it, you do the very same things we did above:

1.  Create a store that is shared, in this case injected into components for you by vue/vuex.
2.  Define actions that components can call, so they remain centralized.
3.  Define mutations which actually touch the store’s state. We do this so actions can compose more than one mutation, or perform logic todetermine which mutation to call. That means you never have to worry about that business logic in the components. Win!
4.  When the state is updated, any component with a getter, computed property, or other mapping to the store will be instantly up-to-date.

Again, the code.

##### main.js

    import store from './vuex/store'

    new Vue({ // eslint-disable-line no-new
      el: '#app',
      render: (h) => h(App),
      store: store
    })

This time, instead of a `store` object in the index, we create it with vuex and pass it into our app directly. Let’s take a look at the store, before we continue.

##### store.js

    export default new Vuex.Store({

      state: {
        messages: []
      },

      actions: {
        newMessage ({commit}, msg) {
          commit('NEW_MESSAGE', msg)
        }
      },

      mutations: {
        NEW_MESSAGE (state, msg) {
          state.messages.push(msg)
        }
      },

      strict: debug

    })

Very similar to the object we made ourselves, but with the addition of the `mutations` object.

##### Client.vue

    
      
        
      
      
        
      
    

Same deal as last time. (Amazing how similar it is, right?)

##### Client.vue

    
    import { mapState, mapActions } from 'vuex'

    export default {
      data() {
        return {
          msg: ''
        }
      },
      props: ['clientid'],
      computed: {
        ...mapState({
          messages: state => state.messages
        })
      },
      methods: {
        trySendMessage() { 
          this.newMessage({
            text: this.msg, 
            sender: this.clientid
          })
          this.resetMessage()
        },
        resetMessage() {
          this.msg = ''
        },
        ...mapActions(['newMessage'])
      }
    }
    

The template remains exactly the same, so I didn’t even bother to include it. The big differences here are:

1.  We use `mapState` to bring in the reference to our shared messages collection.
2.  we use `mapActions` to bring in the action that will create a new message.

(**Note**: These are vuex 2.0 features.)

And bingo, we are done! Feel free to [go give this one a look too](https://benjaminlistwon.com/demo/dataflow/vuex/index.html).

## Conclusions

So, as you can hopefully see, there is not a huge gulf between simply sharing state on your own, and using vuex. The **huge** advantage to vuex is that it formalizes the process of centralizing your data store for you, and providing all the machinery to work wirth that data.

At first, when you read the vuex docs or examples, it can seem daunting with the individual files for mutations, actions and modules. But if you are just starting out, simply write all of those in the single `store.js` file to begin. As your file size grows, you’ll find the right time to move the actions into `actions.js` or to split them out even further.

Don’t fret, take it slow, and you’ll be up in no time. And definitely start off with a template used with [vue-cli](https://github.com/vuejs/vue-cli). I use the [browserify](https://github.com/vuejs-templates/browserify) template, and add the following to my `package.json`.

    "dependencies": {
        "vue": "^2.0.0-rc.6",
        "vuex": "^2.0.0-rc.5"
    }

## Still Here?

I know, I promised the “evil” way. Once again, the demo is [exactly the same](https://benjaminlistwon.com/demo/dataflow/evil/index.html). What is evil is that I am exploiting the one-way binding nature of Vue 2.0 to inject the callback function, thus allowing a two-way binding of sorts between the parent and child templates. First, check out [this portion of the 2.0 docs](http://rc.vuejs.org/guide/components.html#One-Way-Data-Flow), then take a look at my evil.

##### App.vue

    
      
        
      
      
        
      
    

Here, I use a dynamic binding to pass in the `messages` collection using a prop on the component. _But_, I also pass in the action function so I can call it from the child component.

##### Client.vue

    
    export default {
      data() {
        return {
          msg: ''
        }
      },
      props: ['clientid', 'messages', 'callback'],
      methods: {
        trySendMessage() { 
          this.callback({
            text: this.msg, 
            sender: this.clientid
          })
          this.resetMessage()
        },
        resetMessage() {
          this.msg = ''
        }
      }
    }
    

Here’s the evil in action.

Why so bad you ask?

1.  We are defeting the one-way loop found in the diagrams above.
2.  We create a ridculously tight coupling between the component and it’s parent.
3.  This would be _impossible_ to maintain. If you needed twenty functions in the component, you’d have to add twenty props, manage their names, etc, etc. Then, if anything ever changed, ugh!

So why bother showing this at all? Because I am lazy just like everyone else. Sometimes I do something like this only to discover how horrible it is down the road. Then I curse my lazy self because I have hours, or days, of cleanup to do. In this case, I hope I can help you avoid costly decisions or mistakes early by advocating for _never_ passing around anything you don’t need to. In 99% of the cases I’ve run into, a single shared state is more than perfect. (More on that 1% case soon).



