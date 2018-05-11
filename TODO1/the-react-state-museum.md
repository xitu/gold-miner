> * 原文地址：[⚛ The React State Museum: ⚡️View the hottest state management libs for React](https://hackernoon.com/the-react-state-museum-a278c726315)
> * 原文作者：[Gant Laborde](https://hackernoon.com/@gantlaborde?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-react-state-museum.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-react-state-museum.md)
> * 译者：
> * 校对者：

# ⚛ The React State Museum

## ⚡️View the hottest state management libs for React

![](https://cdn-images-1.medium.com/max/1000/1*PhVcG3Re-i8ejmhsD6ULRg.png)

### Why?

This is to serve as a Rosetta Stone of state management systems. A basic packing list app was built in:

*   **setState**
*   **React 16.x Context**
*   **Redux — by** [**Dan Abramov**](https://medium.com/@dan_abramov)
*   **MobX — by** [**Michel Weststrate**](https://medium.com/@mweststrate)
*   **unstated — by** [**Jamie Kyle**](https://medium.com/@thejameskyle)
*   **MobX-State-Tree — by** [**Michel Weststrate**](https://medium.com/@mweststrate) **again**
*   **Apollo GraphQL with Amazon AppSync**
*   **setState + react-automata — by** [**Michele Bertoli**](https://medium.com/@michelebertoli)
*   **Freactal — by Dale while at** [**Formidable**](https://medium.com/@FormidableLabs)
*   **ReduxX — by** [**Mikey Stecky-Efantis**](https://medium.com/@mikeysteckyefantis)

Surely you’re familiar with one or more of the aforementioned systems, and now you can leverage that knowledge to better understand many others. It’s your chance to see what all the buzz is about, and honestly, how similar all these state systems really are.

To portray these systems in a terse and understandable form, the chosen app is a simple packing list app with only the ability to _add_ and _clear_.

![](https://cdn-images-1.medium.com/max/800/1*iQNRn15HETzdjALJITCFsQ.gif)

Simple as it gets app (Native and Web).

To illustrate state jumping the wire, the ADD/CLEAR is one component, and the LIST is a secondary component in all examples.

Even the two main components (adding/listing) have been abstracted to an imported library, leaving only fundamental code in order to emphasize state choice(s). The code is meant to be minimalistic.

### Welcome to the React State Museum!

The code for each of these systems can be found in React and React Native.

![](https://cdn-images-1.medium.com/max/800/1*jNZ4p0HGFML_ziNS0BPErA.png)

> [https://github.com/GantMan/ReactStateMuseum](https://github.com/GantMan/ReactStateMuseum)

Use the above repo to personally dive into each of those systems and check them out! 🔥

* * *

### Personal Notes on Each Solution:

If you want code, check the GitHub, if you want opinions, continue into this very long description below.

Here I jump into the differences between each item in the museum, and that which makes it unique. If you’ve got some strong opinions, or experiences, please share them in the comments. I’m also interested in giving this report as a fun-filled conference talk.

#### setState

Here’s the most basic structure of state management, it depends only on the fundamental understanding of components and their encapsulation. In many ways, this is a great example for beginners in React. Explicitly raising state to a root component that all components are children of identifies the props vs. state relationship. As an application grows, explicit connections down into components would be more and more complex and fragile, which is why this is not commonly used.

> The Code: [React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/setState) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/setState)

#### React Context

[https://reactjs.org/docs/context.html](https://reactjs.org/docs/context.html)

There’s been a lot of buzz about the updates to Context. In fact, the final form of Context in 16.x feels a bit like a state management system itself. For simplicity, the context allows for **provider** and a **consumer**. All children of a provider will have access to the values applied there. All non-children will see the context defaults. The following graph explains such lineage.

![](https://cdn-images-1.medium.com/max/800/1*6mJlcm3Ra5PHXwCEnHeTJQ.png)

Only children inherit.

On a second, and very opinionated note, I’m not a fan of the consumption syntax structure. Clearly, it’s a function that is the child of Consumer, but it feels like it violates JSX while mega-overloading all use cases of braces.

```
      <PackingContext.Consumer>
        {({newItemName, addItem, setNewItemName, clear}) => (
          <AddPackingItem
            addItem={addItem}
            setNewItemText={setNewItemName}
            value={newItemName}
            clear={clear}
          />
        )}
      </PackingContext.Consumer>
```

A pedantic issue, but the readability of code should always factor into API, and on this front, Context starts to feel a bit dirty.

> The Code: [React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/context) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/Context)

#### Redux

[https://github.com/reactjs/react-redux](https://github.com/reactjs/react-redux)

I’ll dare say at the time of this writing Redux is the most popular state management tool, and therefore the most attacked. Writing a solution in Redux took many files, and almost double the lines of code. But to Redux’s defense, it’s simple and flexible.

If you’re unfamiliar with Redux, it’s a functional approach to state management that provides time-travel and clean state management in a form like a reducer function. Dan Abramov’s video explaining redux has been watched _many_ times.

* YouTube 视频链接：https://youtu.be/xsSnOQynTHs

In short, it’s like having someone shout commands in your app (Actions) which are projected via Action Creators. Data managers in your app (Reducers) hear those shouts, and can optionally act on them. I love my pirate ship analogy, so shouting “MAN_OVERBOARD” can tell your crew counter to subtract the staff by one, the accountant to re-split the treasure, and the guy swabbing the deck can just ignore it because he doesn’t care.

I like this analogy, because shouting is a powerful way to manage all corners of your app, and in larger applications, noisy. Combine this with no way to handle side-effects and the need to glue on an immutable structure to make it all work, Redux is the bill-by-hour developer’s friend.

> The Code: [React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/redux) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/Redux)

#### MobX

[https://github.com/mobxjs/mobx-react](https://github.com/mobxjs/mobx-react)

MobX is one of the EASIEST state managers to get started with. Open the readme, and follow along and you’ll have things running in no time. It feels like mutable JS, and it really kind of is. The only part that might throw you for a loop is the decorators like `@observer` on classes. Though odd, they kind of clean up the code a bit.

> @observer is like an automatic `mapStateToProps` + `reselect` if you’re used redux things — [Steve Kellock](https://medium.com/@skellock)

Be sure to checkout Nader’s blog post highlighting some more advanced topics on switching to MobX.

* [**Ditching setState for MobX - Nader Dabit - Medium**: In late 2017 I worked on a React Native project with a team that had used MobX as their state management library. I had…](https://medium.com/@dabit3/766c165e4578)

In summation, MobX was one of the smallest and simplest tools to add!

> The Code: [React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/mobx) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/MobX)

#### Unstated

[https://github.com/jamiebuilds/unstated](https://github.com/jamiebuilds/unstated)

Unstated was as easy as MobX. Much like MobX felt like mutable JavaScript, Unstated felt like adding more React code. I actually feel that Unstated feels more like React than Context did.

It’s simple, you create a container, and inside that container, you manage state. Simple known functions like `setState` exist inside the state container. It’s not just an apt name; it’s an apt React based manager.

![](https://cdn-images-1.medium.com/max/800/1*sRBWrKW_51SILd_CQhy1Aw.png)

I’m not sure how well it scales or handles middleware etc. but if you’re a beginner to state management MobX and Unstated are the simplest tools to get up and running!

> The Code: [React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/unstated) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/Unstated)

#### MobX-State-Tree

[https://github.com/mobxjs/mobx-state-tree](https://github.com/mobxjs/mobx-state-tree)

Yes, this is VERY different from vanilla MobX. It’s a common misconception.

![](https://i.loli.net/2018/05/09/5af255441b56f.png)

Even my co-workers try to shorten the title down to “MobX,” and I’m always pushing MST as an alternative instead. With that being said, it’s important to note MobX-State-Tree sports all the great features of Redux + reselect + Side-effect management and more all in one opinionated bundle with less code.

In this small example, the only thing that’s obvious is the terse syntax. The lines of code are barely bigger than our original MobX example. Both share that succinct decorator syntax. Though it takes a bit of time to really get all the benefits out of MobX-State-Tree.

The most important note is that if you came from ActiveRecord or some other kind of ORM, MobX-State-Tree feels like a clean data model with normalized relations. This is a great state management tool for an application that will scale.

> The Code: [React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/mobx-state-tree) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/MobXStateTree)

#### **Apollo GraphQL and Amazon AppSync**

[https://github.com/apollographql/react-apollo](https://github.com/apollographql/react-apollo)
[https://aws.amazon.com/appsync/](https://aws.amazon.com/appsync/)

If you haven’t jumped on the GraphQL train, you’re missing out. Apollo GraphQL + AppSync is a great way to manage your state, AND handle offline, AND handle fetching API, AND handle setting up a GraphQL server. It’s a serious solution. Many have projected GraphQL to effectively “solve” the state debate. In a lot of ways that’s easy, and in a lot of ways, that’s hard.

Not everyone is ready to use a GraphQL server, but if you are, then AppSync is an easy way to handle all your data in your DynamoDB. It takes more time/energy to get this up and running, but with clear benefits.

In my example, I don’t really use all the bells and whistles. You can see the delay as the data awaits from the server, and I’m not using subscriptions to get updates. This example could get better. But it’s as simple as wrapping the config with the components. Tadaaaaa! The rest is history.

**Special note:** Please be careful what you put in the packing list in this example, as it’s shared.

> The Code: [React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/appsync) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/AppSync)

#### setState + react-automata

[https://github.com/MicheleBertoli/react-automata](https://github.com/MicheleBertoli/react-automata)

This is a strange one in the group. In many ways, you’re wondering how setState is involved, and the answer is simple. The idea of breaking state down into a state-machine is very different from most state management systems.

By creating an [xstate](https://github.com/davidkpiano/xstate) machine config, you handle how state gets passed, called, and identified. Therefore, you must identify ALL states your app can be in, and ALL ways it can move from one state to another. Much like dispatching an action in Redux, you have to `transition` to another state on a given event.

It’s not a full state management system; it’s merely a state-machine for your state management.

[Here’s the chart created by our statechart](https://musing-rosalind-2ce8e7.netlify.com/?machine=%7B%22initial%22%3A%22idle%22%2C%22states%22%3A%7B%22idle%22%3A%7B%22on%22%3A%7B%22CLEAR%22%3A%7B%22idle%22%3A%7B%22actions%22%3A%5B%22clear%22%5D%7D%7D%2C%22SET_NEW_ITEM_NAME%22%3A%7B%22loaded%22%3A%7B%22actions%22%3A%5B%22setNewItemName%22%5D%7D%7D%7D%7D%2C%22loaded%22%3A%7B%22on%22%3A%7B%22ADD_ITEM%22%3A%7B%22idle%22%3A%7B%22actions%22%3A%5B%22addItem%22%5D%7D%7D%2C%22CLEAR%22%3A%7B%22loaded%22%3A%7B%22actions%22%3A%5B%22clear%22%5D%7D%7D%2C%22SET_NEW_ITEM_NAME%22%3A%7B%22loaded%22%3A%7B%22actions%22%3A%5B%22setNewItemName%22%5D%7D%2C%22idle%22%3A%7B%22actions%22%3A%5B%22setNewItemName%22%5D%7D%7D%7D%7D%7D%7D)

![](https://cdn-images-1.medium.com/max/800/1*cUt6fM6NwrKzjPypisJuMA.png)

Exciting benefits come from using statecharts. Firstly, you can be protected from transitions you don’t want. For instance, you can’t transition to “loaded” state without first typing text. This stops empty adds to our packing list.

Secondly, all transitions of state can be automatically generated and tested. With one simple command, multiple snapshots of state are generated.

```
import { testStatechart } from 'react-automata'
import { App } from '../App'
import statechart from '../Statecharts/index'

test('all state snapshots', () => {
  // This one function will generate all state tests
  testStatechart({ statechart }, App)
})
```

**CAVEAT**: On React Native I had to `yarn add path` to satisfy some unused import in a dependency. This was a sneaky gotcha for native only

> The Code: [React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/react-automata) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/ReactAutomata)

#### Freactal

[https://github.com/FormidableLabs/freactal/](https://github.com/FormidableLabs/freactal/)

Of course, we’ll feature the awesome work of Formidable Labs. Freactal is a very advanced example and states it can replace `[redux](https://redux.js.org/)`, `[MobX](https://mobx.js.org/)`, `[reselect](https://github.com/reactjs/reselect)`, `[redux-loop](https://github.com/redux-loop/redux-loop)`, `[redux-thunk](https://github.com/gaearon/redux-thunk)`, `[redux-saga](https://github.com/redux-saga/redux-saga)` and more.

Though this was probably the most difficult one for me to setup, I still see it has great value. More examples would have helped. Special thanks to [Ken Wheeler](https://medium.com/@ken_wheeler) who agreed to answer any questions I had while reading through the docs.

The final code is succinct and straightforward. It feels a bit like the Context syntax in the end. I especially like the use of name-spacing `effects` separately from `state`, and `computer` though there’s not much stopping you from taking this convention to other libs.

```
import React from 'react'
import { AddPackingItem } from 'packlist-components/native'
import { injectState } from 'freactal'

export const AddItems = ({ state, effects }) => (
  <AddPackingItem
    addItem={effects.addItem}
    setNewItemText={effects.setNewItemName}
    value={state.newItemName}
    clear={effects.clear}
  />
)

export default injectState(AddItems)
```

> The Code: [React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/freactal) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/Freactal)

#### ReduxX

[https://github.com/msteckyefantis/reduxx](https://github.com/msteckyefantis/reduxx)

ReduxX, while probably having a bit of trouble in SEO, is still a pretty cool name.

> “Why is it you can add X to something to make it cool?”
> — Gant X

ReduxX reads pretty well as in some ways it reminds me a bit of the charisma from Unstated, as we’re using _react-styled_ verbiage to set and mutate state. One aspect that might seem alien, is the state is retrieved with `getState` as a function. This feels a bit like keychain access, and I wonder if there could be some certs/crypto mixed in easily? Food for thought. I see there’s `obscureStateKeys: true` which will swap keys out for GUIDs. Security-wise this library might have some interesting advantages.

As for how to use it, Set and Get via keys. That’s it! If you’re not worried about middleware, and you’re familiar with keychain globals, you already know ReduxX.

_Special thanks to the author_ [**_Mikey Stecky-Efantis_**](https://medium.com/@mikeysteckyefantis) _for providing this example!_

### The Missing State Example?

I’m sure there are other state managers out there which are being sorely under-represented here, and if you know them, please send a PR to the public repo. I’ll happily accept contributions so that we can all benefit. I’ll even update this blog post as new systems are added. So please, file tickets, and more importantly contribute! The museum thanks you 😆

* * *

![](https://cdn-images-1.medium.com/max/800/1*kePT6qGxTucg__Uz9IC_mQ.png)

[Gant Laborde](https://medium.com/@gantlaborde) is Chief Technology Strategist at [Infinite Red](http://infinite.red), published author, adjunct professor, worldwide public speaker, and mad scientist in training. Please clap/follow/tweet or just say hi to him [at a conference](http://gantlaborde.com/).

#### Credits

*   Header graphic thanks to: [https://unsplash.com/photos/uqMBLm8bAdA](https://unsplash.com/photos/uqMBLm8bAdA)

Thanks to [Frank von Hoven](https://medium.com/@frankvonhoven?source=post_page) and [Derek Greenberg](https://medium.com/@derek_39555?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
