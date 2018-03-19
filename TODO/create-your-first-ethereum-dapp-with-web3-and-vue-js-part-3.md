> * 原文地址：[Create your first Ethereum dAPP with Web3 and Vue.JS (Part 3)](https://itnext.io/create-your-first-ethereum-dapp-with-web3-and-vue-js-part-3-dc4f82fba4b4)
> * 原文作者：[Alt Street](https://itnext.io/@Alt_Street?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/create-your-first-ethereum-dapp-with-web3-and-vue-js-part-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/create-your-first-ethereum-dapp-with-web3-and-vue-js-part-3.md)
> * 译者：
> * 校对者：

# Create your first Ethereum dAPP with Web3 and Vue.JS (Part 3)

Hello and welcome to the final part of this series. In case you're just tuning in, we're creating a simple decentralized application for the ethereum blockchain. Feel free to check out parts 1 and 2 !

- [使用 Web3 和 Vue.js 来创建你的第一个以太坊 dAPP（第一部分）](https://github.com/xitu/gold-miner/blob/master/TODO/create-your-first-ethereum-dapp-with-web3-and-vue-js.md)
- [使用 Web3 和 Vue.js 来创建你的第一个以太坊 dAPP（第二部分）](https://github.com/xitu/gold-miner/blob/master/TODO/create-your-first-ethereum-dapp-with-web3-and-vue-js-part-2.md)

### Picking up where we left off

So at this stage our application is able to get our account data from metamask and display it. However, when changing accounts the data doesn't update without reloading the page. That's not optimal and we want to make sure the changes are displayed reactively.

Our approach will be slightly different to simply registering the web3 instance. Metamask doesn't support websockets yet so we'll have to poll for changes on an interval. We don't want to dispatch actions when there are no changes, therefore our actions will be dispatched with their respective payload only once a condition (certain change) is met.

There's likely several approaches and this is probably not most pretty one, it works inside the constraints of strict-mode however so we're good. Create a new file in the _util_ folder called _pollWeb3.js_. Here's what we'll do:

*   Import Web3 so we are not dependent on the Metamask instance
*   Import our store so we can compare values and dispatch actions if needed
*   Create our web3 instance
*   Set an interval to check if the address has changed, if that's not the case check if the balance has changed
*   If there are changes to the address or balance we will update our store. Because our _hello-metamask component_ has a _computed property_ this data change is reactive

```

import Web3 from 'web3'
import {store} from '../store/'

let pollWeb3 = function (state) {
  let web3 = window.web3
  web3 = new Web3(web3.currentProvider)

  setInterval(() => {
    if (web3 && store.state.web3.web3Instance) {
      if (web3.eth.coinbase !== store.state.web3.coinbase) {
        let newCoinbase = web3.eth.coinbase
        web3.eth.getBalance(web3.eth.coinbase, function (err, newBalance) {
          if (err) {
            console.log(err)
          } else {
            store.dispatch('pollWeb3', {
              coinbase: newCoinbase,
              balance: parseInt(newBalance, 10)
            })
          }
        })
      } else {
        web3.eth.getBalance(store.state.web3.coinbase, (err, polledBalance) => {
          if (err) {
            console.log(err)
          } else if (parseInt(polledBalance, 10) !== store.state.web3.balance) {
            store.dispatch('pollWeb3', {
              coinbase: store.state.web3.coinbase,
              balance: polledBalance
            })
          }
        })
      }
    }
  }, 500)
}

export default pollWeb3
```

Now we just need to start polling for updates once our web3Instance is initially registed. So open up _store/index.js_, import our _pollWeb3.js_ file and add it to the bottom of our _registerWeb3Instance() mutation_ to be executed after the state change.

```
import pollWeb3 from '../util/pollWeb3'

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
 pollWeb3()
 }
```

Since we are dispatching actions we need to add this to our store, as well as a mutation to commit the change. We could directly commit a change, but let's keep our pattern consistent. We'll add some console.logs so you can watch the wonderful process unfold in the console. Inside the actions object add:

```
pollWeb3 ({commit}, payload) {
 console.log('pollWeb3 action being executed')
 commit('pollWeb3Instance', payload)
 }
```

Now we just need a mutation for the possible two variables that we pass on

```
pollWeb3Instance (state, payload) {
 console.log('pollWeb3Instance mutation being executed', payload)
 state.web3.coinbase = payload.coinbase
 state.web3.balance = parseInt(payload.balance, 10)
 }
```

Done! If we now change address in Metamask or our balance changes, we will see this update in our app without reloading the page. When we change the network the page will reload and we will register a new instance from the start. In production however we would want to show a warning to change to the correct network where our contract is deployed on.

It's been a long road, I know but in the next section we'll finally dive into connecting our smart contract to our app. This will actually be pretty easy compared to what we already did.

### Instantiating our contract

We'll start by writing the code, later we'll deploy our contract and insert the ABI and address into our application. Almost to create our long awaited casino-component that does the following:

*   We need an input field so that the user can enter an amount to bet
*   We need buttons that represent the number to bet on, when a user clicks on a number he will bet his entered amount on that number.
*   The on click function will call the bet() function on our smart contract.
*   We will display a loading spinner to display that the transaction is ongoing
*   When the transaction finishes we will display whether the user has won and the amount

First we need our application to be able to talk to our smart contract however. We’ll approach this the same way as we have already done. In the _util_ folder create a new file called _getContract.js_.

```
import Web3 from ‘web3’
import {address, ABI} from ‘./constants/casinoContract’

let getContract = new Promise(function (resolve, reject) {
 let web3 = new Web3(window.web3.currentProvider)
 let casinoContract = web3.eth.contract(ABI)
 let casinoContractInstance = casinoContract.at(address)
 // casinoContractInstance = () => casinoContractInstance
 resolve(casinoContractInstance)
})

export default getContract
```

First thing to notice is that we’re importing a file that doesn’t exist yet, we’ll fix that later when we deploy our contract.

First we create a contract object for a solidity contract by passing in the ABI (which we’ll come back to) into _web3.eth.contract()_. Then we can initiate that object at an address. **It is on this instance that we can call upon our methods and events.**

This wouldn’t be complete however without actions and mutations, right.
So inside the script tags of _casino-component.vue_ add the following.

```
export default {
 name: ‘casino’,
 mounted () {
 console.log(‘dispatching getContractInstance’)
 this.$store.dispatch(‘getContractInstance’)
 }
}
```

Now for our action and mutation inside the store. First import our _getContract.js_ file, I’m sure you know how to do this by now. Then in the action we’re creating, call upon it:

```
getContractInstance ({commit}) {
 getContract.then(result => {
 commit(‘registerContractInstance’, result)
 }).catch(e => console.log(e))
 }
```

Pass the result to our mutation:

```
registerContractInstance (state, payload) {
 console.log(‘Casino contract instance: ‘, payload)
 state.contractInstance = () => payload
 }
```

This will store our contract instance in the store for us to use in our component.

### Interacting with our contract

First we’ll add a data property (inside the export) to our casino-component so we can have variables with reactive properties. These values will be winEvent, amount and pending.

```
data () {
 return {
 amount: null,
 pending: false,
 winEvent: null
 }
 }
```

Now we will create the onclick function for when a user clicks a number. This will trigger the _bet()_ function on our contract, display the spinner and when it receives the event hide the spinner and display the event arguments. Under the data property add a property called methods, this property takes an object in which we’ll place our function.

```
methods: {
    clickNumber (event) {
      console.log(event.target.innerHTML, this.amount)
      this.winEvent = null
      this.pending = true
      this.$store.state.contractInstance().bet(event.target.innerHTML, {
        gas: 300000,
        value: this.$store.state.web3.web3Instance().toWei(this.amount, 'ether'),
        from: this.$store.state.web3.coinbase
      }, (err, result) => {
        if (err) {
          console.log(err)
          this.pending = false
        } else {
          let Won = this.$store.state.contractInstance().Won()
          Won.watch((err, result) => {
            if (err) {
              console.log('could not get event Won()')
            } else {
              this.winEvent = result.args
              this.pending = false
            }
          })
        }
      })
    }
  }
```

The first argument our _bet()_ function takes is the parameter we defined in our contract, u number. _event.target. innerHTML_ refers to the number inside the list tags we’ll create next. Then comes an object to define the transaction parameters, this is where we enter the amount the user bets. The third parameter is a callback. On success we will watch for the event.

Now we’ll create the html and css for our component. Just copy-paste it, I think it’s self-explanatory. After this we’ll deploy the contract and get the ABI and address.

```
<template>
 <div class=”casino”>
   <h1>Welcome to the Casino</h1>
   <h4>Please pick a number between 1 and 10</h4>
   Amount to bet: <input v-model=”amount” placeholder=”0 Ether”>
   <ul>
     <li v-on:click=”clickNumber”>1</li>
     <li v-on:click=”clickNumber”>2</li>
     <li v-on:click=”clickNumber”>3</li>
     <li v-on:click=”clickNumber”>4</li>
     <li v-on:click=”clickNumber”>5</li>
     <li v-on:click=”clickNumber”>6</li>
     <li v-on:click=”clickNumber”>7</li>
     <li v-on:click=”clickNumber”>8</li>
     <li v-on:click=”clickNumber”>9</li>
     <li v-on:click=”clickNumber”>10</li>
  </ul>
  <img v-if=”pending” id=”loader” src=”https://loading.io/spinners/double-ring/lg.double-ring-spinner.gif”>
  <div class=”event” v-if=”winEvent”>
    Won: {{ winEvent._status }}
    Amount: {{ winEvent._amount }} Wei
  </div>
 </div>
</template>

<style scoped>
.casino {
 margin-top: 50px;
 text-align:center;
}
#loader {
 width:150px;
}
ul {
 margin: 25px;
 list-style-type: none;
 display: grid;
 grid-template-columns: repeat(5, 1fr);
 grid-column-gap:25px;
 grid-row-gap:25px;
}
li{
 padding: 20px;
 margin-right: 5px;
 border-radius: 50%;
 cursor: pointer;
 background-color:#fff;
 border: -2px solid #bf0d9b;
 color: #bf0d9b;
 box-shadow:3px 5px #bf0d9b;
}
li:hover{
 background-color:#bf0d9b;
 color:white;
 box-shadow:0px 0px #bf0d9b;
}
li:active{
 opacity: 0.7;
}
*{
 color: #444444;
}
</style>
```

### Ropsten Network and Metamask (for first time users)

If you’re not familiar with metamask or ethereum networks, don’t worry.

1.  Open up your browser and metamask addon. Accept the terms of use and create a password.
2.  Store the seed phrase somewhere safe (this is to restore your wallet when you lose it)
3.  Click “Ethereum Main Net” and switch it to Ropsten test net.
4.  Click “Buy”, then on “Ropsten Testnet Faucet”. This is where we’ll get some free test-Ethers
5.  On the faucet website, click the “request 1 ether from faucet” a couple of times.

When all is said and done your Metamask should look like this:

![](https://cdn-images-1.medium.com/max/800/1*IT3Lpfh2FiPSMEvVUl4ffA.png)

### Deployment and hook-up

Open up remix again, our contract should be there still. If it isn’t, go to [this gist](https://gist.github.com/anonymous/6b06bef626928589e3a53a70c021ec02) and copy paste. In the rop right of remix make sure our environment is set to “Injected Web3 (ropsten)” and that our address is selected.

The deployment is just as in [part 1](https://itnext.io/create-your-first-ethereum-dapp-with-web3-and-vue-js-c7221af1ed82). We enter a couple of Ethers in the value field to preload the contract with, enter our constructor parameters and click create. This time metamask will prompt to accept/reject a transaction (contract deployment). Click ‘accept’ and wait until the transaction is completed.

When the TX completes click on it, this will take you to the ropsten blockchain explorer for that TX. We can find the contract address under the “to” field. Yours will of course be different, but look similar.

![](https://cdn-images-1.medium.com/max/800/1*_l_EVygtbwHgway4sxwOjQ.png)

Our contract address is in the “To” field.

So that gives us the address, now for the ABI. Go back to remix and switch to the ‘compile’ tab (top right). Next to the name of our contract we’ll see a button called ‘details’, click it. The fourth field is our ABI.

![](https://cdn-images-1.medium.com/max/800/1*gGPKAotB7qmUY70ZdZDDyA.png)

Great work, now we just have to create that one file from the previous section that doesn’t exist yet. So in the _util/constants_ folder create a new file called _casinoContract.js_. Create two variables, paste the necessary stuff in and export the variables so our import from above can access them.

```
const address = ‘0x…………..’
const ABI = […]
export {address, ABI}
```

### Amazing work !

We can now test our application by running _npm start_ in the terminal and going to _localhost:8080_ in our browser. Enter an amount and click a number. Metamask will prompt you to accept the transaction and the spinner will start. After 30 seconds to a minute we get the first confirmation and thus the event as well. Our balance changes, so pollweb3 fires it’s action to update the balance:

![](https://cdn-images-1.medium.com/max/800/1*GvWC8YzcuzWBs8TdSphiQw.png)

Final result (left) and lifecycle (right).

I applaud you if you got this far in this series. I’m not a professional writer so it will not have been easy reading at times. The main backbone for our application is set, we just need to make it a bit more pretty and user friendly. We’ll do that in the next section, although this is totally optional.

### The eye wants it’s part

We’ll go over this pretty fast. It’ll just be some html, css and vue-conditionals with v-if/v-else.

**In App.vue** add the container class to our div-element, in our css define the class:

```
.container {
 padding-right: 15px;
 padding-left: 15px;
 margin-right: auto;
 margin-left: auto;
}
@media (min-width: 768px) {
 .container {
 width: 750px;
 }
}
```

**In main.js** import the font-awesome library we’ve installed (I know, not the optimal way for the two icons we need):

```
import ‘font-awesome/css/font-awesome.css’
```

**In hello-metamask.vue** we’re gonna do some changes. We’re gonna use the mapState helper in our _computed_ property, instead of the current function. We’re also going to use v-if to check for _isInjected_ and display different HTML based on that. This is what the final component looks like:

```
<template>
  <div class='metamask-info'>
    <p v-if="isInjected" id="has-metamask"><i aria-hidden="true" class="fa fa-check"></i> Metamask installed</p>
    <p v-else id="no-metamask"><i aria-hidden="true" class="fa fa-times"></i> Metamask not found</p>
    <p>Network: {{ network }}</p>
    <p>Account: {{ coinbase }}</p>
    <p>Balance: {{ balance }} Wei </p>
  </div>
</template>

<script>
import {NETWORKS} from '../util/constants/networks'
import {mapState} from 'vuex'
export default {
  name: 'hello-metamask',
  computed: mapState({
    isInjected: state => state.web3.isInjected,
    network: state => NETWORKS[state.web3.networkId],
    coinbase: state => state.web3.coinbase,
    balance: state => state.web3.balance
  })
}
</script>

<style scoped>
#has-metamask {
  color: green;
}
#no-metamask {
  color:red;
}</style>
```

We’ll do the same v-if/v-else approach to style our event that’s being returned **inside casino-component.vue** :

```
<div class=”event” v-if=”winEvent”>
 <p v-if=”winEvent._status” id=”has-won”><i aria-hidden=”true” class=”fa fa-check”></i> Congragulations, you have won {{winEvent._amount}} wei</p>
 <p v-else id=”has-lost”><i aria-hidden=”true” class=”fa fa-check”></i> Sorry you lost, please try again.</p>
 </div>

#has-won {
  color: green;
}
#has-lost {
  color:red;
}
```

Finally in our _clickNumber()_ function, add a line below _this.winEvent = result.args_ :

```
this.winEvent._amount = parseInt(result.args._amount, 10)
```

### You’ve reached the end, congragulations!

**First of all , the full code for the project is available now under the master branch:** [**https://github.com/kyriediculous/dapp-tutorial/tree/master**](https://github.com/kyriediculous/dapp-tutorial/tree/master) **!**

![](https://cdn-images-1.medium.com/max/800/1*jb6ety7sf_MxbbAR30NIxQ.png)

Final application after losing a bet :(.

There’s still a few caveats in our application. We’re not handling errors correctly everywhere, we don’t need all the console log statements, it’s not a very pretty application (I’m not a designer), etc. The app does it’s job well however.

Hopefully this tutorial series can put you on the path to building more and better decentralized applications. I sincerely hope you enjoyed reading this as much as I did writing.

I’m not a software engineer with over 20 years of experience. Thus, if you have any recommendations or improvements, feel free to leave a comment. I love to learn new things and improve where I can. Thanks.

UPDATE: [Added balance display in Ether](https://github.com/kyriediculous/dapp-tutorial/commit/a07edf3182a3d6c7284e830f709d79b61a40ab0e)

**Feel free to follow us on twitter, visit our website or leave a tip if you enjoyed the tutorial!**

- [**Alt Street (@Alt_Strt) | Twitter**: The latest Tweets from Alt Street (@Alt_Strt). Blockchain is love, blockchain is life. We develop proof of concepts and… twitter.com](https://twitter.com/Alt_Strt)

- [**Alt Street - Blockchain Consultants**: Blockchain proof of concepts and Token sales... altstreet.io](https://altstreet.io)

TIPJAR: ETH — 0x6d31cb338b5590adafec46462a1b095ebdc37d50


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
