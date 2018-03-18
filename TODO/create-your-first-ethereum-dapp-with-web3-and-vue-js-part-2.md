> * 原文地址：[Create your first Ethereum dAPP with Web3 and Vue.JS (Part 2)](https://itnext.io/create-your-first-ethereum-dapp-with-web3-and-vue-js-part-2-52248a74d58a)
> * 原文作者：[Alt Street](https://itnext.io/@Alt_Street?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/create-your-first-ethereum-dapp-with-web3-and-vue-js-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/create-your-first-ethereum-dapp-with-web3-and-vue-js-part-2.md)
> * 译者：
> * 校对者：

# Create your first Ethereum dAPP with Web3 and Vue.JS (Part 2)

- [使用 Web3 和 Vue.js 来创建你的第一个以太坊 dAPP（第一部分）](https://github.com/xitu/gold-miner/blob/master/TODO/create-your-first-ethereum-dapp-with-web3-and-vue-js.md)
- [使用 Web3 和 Vue.js 来创建你的第一个以太坊 dAPP（第二部分）](https://github.com/xitu/gold-miner/blob/master/TODO/create-your-first-ethereum-dapp-with-web3-and-vue-js-part-2.md)
- [使用 Web3 和 Vue.js 来创建你的第一个以太坊 dAPP（第三部分）](https://github.com/xitu/gold-miner/blob/master/TODO/create-your-first-ethereum-dapp-with-web3-and-vue-js-part-3.md)

[_Click here to share this article on LinkedIn »_](https://www.linkedin.com/cws/share?url=https%3A%2F%2Fitnext.io%2Fcreate-your-first-ethereum-dapp-with-web3-and-vue-js-part-2–52248a74d58a)

Welcome back to part 2 of this awesome tutorial series where we get our hands dirty building our first decentralized application. In this second part we will introduce the core concepts of VueJS and Vuex as well as introduce web3js to interact with metamask.

In case you missed part one you can find it below, as well as throw us a follow on Twitter!

![Snipaste_2018-03-18_17-25-07.png](https://i.loli.net/2018/03/18/5aae308c4ce45.png)

### Down to business: VueJS

VueJS is a javascript frameworking for building user interfaces. At first glance it looks similar to classical moustache templating, but there's alot happening under the hood to make Vue reactive.

```
<div id=”app”>
 {{ message }}
</div>

var app = new Vue({
 el: '#app',
 data: {
 message: 'Hello Vue!'
 }
})
```

This would be the structure of a really basic Vue application. The message property in the data object will be rendered to the screen in the element with id 'app', when we change this message it will update on the screen without refreshing. You can check it out in this jsfiddle (turn on auto-run): [https://jsfiddle.net/tn1mfxwr/2/](https://jsfiddle.net/tn1mfxwr/2/) .

Another important key feature of VueJS is components. Components are small, reusable and self-contained pieces of code. Essentially a web application can be abstracted into a tree of smaller components. This will get more clear when we dive into coding our front-end app.

![](https://cdn-images-1.medium.com/max/800/1*9XlTaVitmHopHmQ634kfvg.png)

Example of a webpage abstracted into components. The webpage consists of three components. Two of these components have subcomponents.

### Union of the state: Vuex

We will use Vuex to manage the state of our application. Similar to redux, Vuex implements a store which serves as the 'single source of truth' for our application regarding data. Vuex allows us to manipulate and serve the data our app uses in a predictable fashion.

The way it works is very straightforward. A **component** needs data when it's rendered, it will **dispatch** an **action** to get the data it needs. The API call to fetch the data happens async in the action. Once the data is fetched the action will **commit** this data to a **mutation**. The mutation will then **alter the state** of our store. When data in the store changes that this component uses, it will re-render.

![](https://cdn-images-1.medium.com/max/800/1*EPstm-VwycENr4PjutJ0KA.png)

State management pattern for Vuex.

### **Before we continue…**

In part one we have generated a Vue app by using the vue-cli, we have also installed the dependencies we need. In case you haven't done this check out part one, link's on top.

If you have done everything correctly your directory structure should look like this:

![](https://cdn-images-1.medium.com/max/800/1*24ZJn3iRu_FZN_Y6E65sgQ.png)

Freshly generated vue application.

**Quick note: if you are going to copy-paste code blocks from here add _/src/_ to your _.eslintignore_ file to avoid indentation errors**

In your terminal you can type 'npm start' to run this app. It will contain the default vue application so we'll clean this out first.
_**NOTE: We are using vue Router despite only having one route, we don't need it but I thought it would be nice to keep it in for the tutorial since it's quite simple.
**TIP: Put your syntax in atom (bottom right) to HTML for .vue files_

Time to clean this baby up:

*   In app.vue delete the img-tag and clear everything between the style-tags.
*   Delete _components/HelloWorld.vue_, make two new files called casino-dapp.vue (our main component) and hello-metamask.vue (will contain our metamask data)
*   In our new _hello-metamask.vue_ file paste the following code, which just displays the text 'Hello' in a p-tag for now.

```
<template>
 <p>Hello</p>
</template>

<script>
export default {
 name: 'hello-metamask'
}
</script>

<style scoped>

</style>
```

*   Now we will load the hello-metamask component into our main casino-dapp component by first importing the file and then referencing it in our vue instance so that we can add it as a tag in our template. Paste this in _casino-dapp.vue_ :

```
<template>
 <hello-metamask/>
</template>

<script>
import HelloMetamask from '@/components/hello-metamask'
export default {
 name: 'casino-dapp',
 components: {
 'hello-metamask': HelloMetamask
 }
}
</script>

<style scoped>

</style>
```

*   Now if you open router/index.js you'll see that we only have one route to the root, it's still pointing to our deleted HelloWorld.vue component. We need to change it to our main casino-dapp.vue component.

```
import Vue from 'vue'
import Router from 'vue-router'
import CasinoDapp from '@/components/casino-dapp'

Vue.use(Router)

export default new Router({
 routes: [
 {
 path: '/',
 name: 'casino-dapp',
 component: CasinoDapp
 }
 ]
})
```

A little on Vue Router: you can add additional paths and bind components to them, these will then render when you visit the defined path. Because of the router-view tag in our App.vue file the correct component will be rendered.

*   Create a new folder in _src_ called _util._ Inside this folder create another folder called _constants_. create a file called _networks.js_ and paste the code below. This will let us display the Ethereum network name instead of it's id while keeping our code clean.

```
export const NETWORKS = {
 '1': 'Main Net',
 '2': 'Deprecated Morden test network',
 '3': 'Ropsten test network',
 '4': 'Rinkeby test network',
 '42': 'Kovan test network',
 '4447': 'Truffle Develop Network',
 '5777': 'Ganache Blockchain'
}
```

*   LAST BUT NOT LEAST (actually it is least for now), create a new folder in _src_ called _store_. We'll come back to this in the next section.

If you run '_npm start'_ in the terminal and go to _localhost:8080_ in your browser you should see _'Hello'_ appear on the screen. If that's the case, you're ready to move on.

### Setting up our Vuex store

In this section we'll set up our store. Start by creating two files inside our brand new _store_ directory (last part of previous section): _index.js_ and _state.js_; We'll start with _state.js_ which will be a blank representation of the data we will be retrieving.

```
let state = {
 web3: {
 isInjected: false,
 web3Instance: null,
 networkId: null,
 coinbase: null,
 balance: null,
 error: null
 },
 contractInstance: null
}
export default state
```

Good, now we'll set up our store in _index.js_. We'll import the vuex library and tell vueJS to use it. We'll import the state and add it to our store as well.

```
import Vue from 'vue'
import Vuex from 'vuex'
import state from './state'

Vue.use(Vuex)

export const store = new Vuex.Store({
 strict: true,
 state,
 mutations: {},
 actions: {}
})
```

Last step is to edit main.js to contain our store:

```
import Vue from 'vue'
import App from './App'
import router from './router'
import { store } from './store/'

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
 el: '#app',
 router,
 store,
 components: { App },
 template: '<App/>'
})
```

Well done, give yourself a pat on the back because this was a lot of set-up. Now we're ready however, to start getting our metamask data through the web3 API and serve it in our application. It's about to get real!

### Getting started with Web3 and Metamask

Like mentioned before in order for us to get the data into our Vue app we need to dispatch an action to make async API calls. We will chain a couple of calls together using promises and abstract this into a file. So in the _util_ folder create a new file called _getWeb3.js_. Paste in the code below which contains quite a bit of comments for you to follow along. We'll go over it below the code block as well.

```
import Web3 from 'web3'

/*
* 1. Check for injected web3 (mist/metamask)
* 2. If metamask/mist create a new web3 instance and pass on result
* 3. Get networkId - Now we can check the user is connected to the right network to use our dApp
* 4. Get user account from metamask
* 5. Get user balance
*/

let getWeb3 = new Promise(function (resolve, reject) {
  // Check for injected web3 (mist/metamask)
  var web3js = window.web3
  if (typeof web3js !== 'undefined') {
    var web3 = new Web3(web3js.currentProvider)
    resolve({
      injectedWeb3: web3.isConnected(),
      web3 () {
        return web3
      }
    })
  } else {
    // web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545')) GANACHE FALLBACK
    reject(new Error('Unable to connect to Metamask'))
  }
})
  .then(result => {
    return new Promise(function (resolve, reject) {
      // Retrieve network ID
      result.web3().version.getNetwork((err, networkId) => {
        if (err) {
          // If we can't find a networkId keep result the same and reject the promise
          reject(new Error('Unable to retrieve network ID'))
        } else {
          // Assign the networkId property to our result and resolve promise
          result = Object.assign({}, result, {networkId})
          resolve(result)
        }
      })
    })
  })
  .then(result => {
    return new Promise(function (resolve, reject) {
      // Retrieve coinbase
      result.web3().eth.getCoinbase((err, coinbase) => {
        if (err) {
          reject(new Error('Unable to retrieve coinbase'))
        } else {
          result = Object.assign({}, result, { coinbase })
          resolve(result)
        }
      })
    })
  })
  .then(result => {
    return new Promise(function (resolve, reject) {
      // Retrieve balance for coinbase
      result.web3().eth.getBalance(result.coinbase, (err, balance) => {
        if (err) {
          reject(new Error('Unable to retrieve balance for address: ' + result.coinbase))
        } else {
          result = Object.assign({}, result, { balance })
          resolve(result)
        }
      })
    })
  })

export default getWeb3
```

First thing to notice is that we use promises to chain our callbacks, if you don't know promises check out [this link](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise). Next we check if the user has Metamask (or Mist) running. Metamask injects its own instance of web3, we'll thus check that window.web3 (the injected instance) is not undefined. If that's not the case we'll create a web3 instance with Metamask as current provider so that we do not depend on the version of the injected instance. We pass on our newly created instance into the next promises where we do a couple of API calls:

*   _web3.version.getNetwork()_ will return the ID of the network we are connected to.
*   _web3.eth.coinbase()_ returns the address our node is mining to, when using Metamask this should be the selected account.
*   _web3.eth.getBalance(<address>)_ returns the balance of the address we pass in as parameter.

Remember how we said async API calls need to happen inside an action in our Vuex store? We'll hook that up now and dispatch it from our component later. In _store/index.js_ we'll import our _getWeb3.js_ file, call it and commit it to a mutation that will save it to our store.

In your import statements add

```
import getWeb3 from '../util/getWeb3'
```

Then in the action object (inside your store) we'll call _getWeb3_ and _commit_ the result. We are adding a bunch of console.logs to our logic so we can see the steps of our process, which will hopefully make the whole dispatch-action-commit-mutation-statechange a bit more clear.

```
registerWeb3 ({commit}) {
      console.log('registerWeb3 Action being executed')
      getWeb3.then(result => {
        console.log('committing result to registerWeb3Instance mutation')
        commit('registerWeb3Instance', result)
      }).catch(e => {
        console.log('error in action registerWeb3', e)
      })
    }
```

Now we will create our mutation which will save our data to the state in our store. We can access the data we passed into our commit in our mutation by accessing the second parameter. Inside the _mutations_ object add the function below.

```
registerWeb3Instance (state, payload) {
 console.log('registerWeb3instance Mutation being executed', payload)
 let result = payload
 let web3Copy = state.web3
 web3Copy.coinbase = result.coinbase
 web3Copy.networkId = result.networkId
 web3Copy.balance = parseInt(result.balance, 10)
 web3Copy.isInjected = result.injectedWeb3
 web3Copy.web3Instance = result.web3
 state.web3 = web3Copy
 }
```

Great! All that's left to do now is dispatch our action from our component to actually retrieve the data and render it to our application. To dispatch our actions we will make use of [Vue's lifecycle hooks](https://vuejs.org/v2/guide/instance.html#Instance-Lifecycle-Hooks). In our case we will dispatch our action from our main casino-dapp component before it is created. So inside _components/casino-dapp.vue_ add the following function below the name property:

```
export default {
  name: 'casino-dapp',
  beforeCreate () {
    console.log('registerWeb3 Action dispatched from casino-dapp.vue')
    this.$store.dispatch('registerWeb3')
  },
  components: {
    'hello-metamask': HelloMetamask
  }
}
```

Alright, now we will render this data from our hello-metamask component, all of our account data will be rendered in this component. To get data from our store we need to pass a getter function into computed. We can then reference the data in our template by using curly-braces.

```
<template>
 <div class='metamask-info'>
   <p>Metamask: {{ web3.isInjected }}</p>
   <p>Network: {{ web3.networkId }}</p>
   <p>Account: {{ web3.coinbase }}</p>
   <p>Balance: {{ web3.balance }}</p>
 </div>
</template>

<script>
export default {
 name: 'hello-metamask',
 computed: {
   web3 () {
     return this.$store.state.web3
     }
   }
}
</script>

<style scoped></style>
```

Great, everything should work now. In your terminal fire up the project with 'npm start' and go to localhost:8080\. We should now see our metamask data. When we open the console we should see the messages from our console log in the state management pattern as described in the vuex paragraph.

![](https://cdn-images-1.medium.com/max/800/1*Z1S3FigrOgjE4xEY8f5PcQ.png)

If you managed to get this far and everything works then well done, seriously. This was by far the hardest part of the series. In the next part we'll learn how to poll for changes to Metamask (eg. switching account) and connect our smart contract we wrote in part 1 to our application.

**In case you ran into an error, the full working code for this part is available in** [**this github repo**](https://github.com/kyriediculous/dapp-tutorial/tree/hello-metamask) **on the hello-metamask branch.**

**Make sure you check out** [**the final part of this series**](https://medium.com/@Alt_Street/create-your-first-ethereum-dapp-with-web3-and-vue-js-part-3-dc4f82fba4b4)**!**

As always you're welcome to leave a tip if you enjoy our tutorials, thanks for reading and sticking through if you got this far!

ETH — 0x6d31cb338b5590adafec46462a1b095ebdc37d50

* * *

Looking to build your idea? We offer Ethereum proof of concept and crowdsale development services.

- [**Alt Street - Blockchain Consultants**: Blockchain proof of concepts and Token sales... altstreet.io](https://altstreet.io)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
