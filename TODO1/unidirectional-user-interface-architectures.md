> * 原文地址：[UNIDIRECTIONAL USER INTERFACE ARCHITECTURES](https://staltz.com/unidirectional-user-interface-architectures.html)
> * 原文作者：[André Staltz](https://staltz.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/unidirectional-user-interface-architectures.md](https://github.com/xitu/gold-miner/blob/master/TODO1/unidirectional-user-interface-architectures.md)
> * 译者：
> * 校对者：

# UNIDIRECTIONAL USER INTERFACE ARCHITECTURES

This post is a non-exhaustive quick overview of the so-called “unidirectional data flow” architectures. Not meant to be taken as a beginner tutorial, but rather as an overview of their differences and peculiarities. At the end, I’ll introduce a new architecture which deviates significantly from the others. This post assumes client-side Web UI frameworks only.

## TERMINOLOGY

It would be confusing to talk about these architectures without a common terminology, so let’s assume the following.

> **User events** are events coming from input devices directly manipulated by the user. Examples: mouse clicks, scrolls, keyboard presses, touches on a touchscreen, etc.

Architectures might use the term “View” with drastically different connotations. Instead, we use “rendering” to refer to the common understanding of “View”:

> **User interface rendering** is the graphical output on the screen, commonly expressed as HTML or some comparable high-level declarative code such as JSX.

> A **User interface (UI) program** is any program which takes user events as input and outputs rendering, as an ongoing process rather than a one-time transformation.

The DOM and other layers such as frameworks and libraries are assumed to exist between the user and the architecture.

**Ownership of inter-module arrow matters.** `A--> B` is different than `A -->B`. The former is Passive programming, while the latter is Reactive programming. Read more [here](http://cycle.js.org/observables.html#reactive-programming).

> A unidirectional architecture is said to be **fractal** if subcomponents are structured in the same way as the whole is.

In fractal architectures, the whole can be naively packaged as a component to be used in some larger application.

In non-fractal architectures, the non-repeatable parts are said to be **orchestrators** over the parts that have hierarchical composition.

## FLUX

First compulsory mention goes to [Flux](https://github.com/facebook/flux/). It cannot be said to be the absolute pioneer, but at least in terms of popularity, it is the first unidirectional architecture for many people.

**Parts:**

*   **Stores**: manage business data and state
*   **View**: a hierarchical composition of React components
*   **Actions**: events created from user events that triggered on the View
*   **Dispatcher**: an event bus for all actions

[![Flux diagram](https://staltz.com/img/flux-unidir-ui-arch.jpg)](https://staltz.com/img/flux-unidir-ui-arch.jpg)

**Peculiarities:**

**Dispatcher.** Because this is an event bus, it’s a singleton. Many Flux variants remove the need for a dispatcher, and other unidirectional architectures don’t have an equivalent to the dispatcher.

**Only View has composable components.** Hierarchical composition happens only among React components, not with Stores neither with Actions. A React component is a UI program, and is usually not written as a Flux architecture internally. Hence Flux is not fractal, where the orchestrators are the Dispatcher and the Stores.

**User event handlers are declared in the rendering.** In other words, the `render()` function of React components handles both directions of interaction with the user: rendering and user event handlers (e.g. `onClick={this.clickHandler}`).

## REDUX

[Redux](http://rackt.github.io/redux/) is a variation of Flux where the singleton Dispatcher was adapted to become a singleton Store. The Store is not implemented from scratch, instead, it is created by giving a reducer function to a store factory.

**Parts:**

*   **Singleton Store**: manages state and has a `dispatch(action)` function
*   **Provider**: a subscriber to the Store which interfaces with some “View” framework like React or Angular
*   **Actions**: events created from user events that are created under the Provider
*   **Reducers**: pure functions from previous state and an action to new state

[![Redux diagram](https://staltz.com/img/redux-unidir-ui-arch.jpg)](https://staltz.com/img/redux-unidir-ui-arch.jpg)

**Peculiarities:**

**Factories for stores.** A Store is created using the `createStore()` factory function, taking a composition of reducer functions as argument. There is also a meta-factory `applyMiddleware()` function which takes middleware functions as arguments. Middlewares are mechanisms of overriding the `dispatch()` function of a store with additional chained functionality.

**Providers.** Redux is unopinionated with regards to the “View” framework used to make the UI program. It can be used with React or Angular or others. In the context of this architecture, “View” is a UI program. Like Flux, Redux is not (by design) fractal and the Store is an orchestrator.

**User event handlers may or may not be declared in the rendering.** It depends on the Provider at hand.

## BEST

The [Famous Framework](https://blog.famous.org/introducing-the-famous-framework/) introduced Behavior-Event-State-Tree (BEST) as a variant of MVC, where the Controller is split into two unidirectional elements: Behavior and Event.

**Parts:**

*   **State**: JSON-like declaration of initial state
*   **Tree**: a declarative hierarchical composition of components
*   **Event**: event listeners (on tree) that mutate state
*   **Behavior**: dynamic properties (of tree) dependent on the state

[![BEST diagram](https://staltz.com/img/best-unidir-ui-arch.jpg)](https://staltz.com/img/best-unidir-ui-arch.jpg)

**Peculiarities:**

**Multi-paradigm.** State and Tree are fully declarative. Event is imperative. Behavior is functional. Some parts are reactive, other parts are passive (e.g. Behavior reacts to State, and Tree is passive to the Behavior).

**Behavior.** Not seen in any other architecture in this post, the Behavior separates UI rendering (Tree) from its dynamic properties. These are allegedly different concerns: Tree is comparable to HTML, Behavior is comparable to CSS.

**User event handlers are declared separately from rendering.** BEST is one of the few unidirectional architectures that do not attach user event handlers in the rendering. User event handlers belong to Event, not to Tree.

In the context of this architecture, “View” is a Tree, and a “Component” is a Behavior-Event-Tree-State tuple. Components are UI programs. BEST is a fractal architecture.

## MODEL-VIEW-UPDATE

Also known as “[The Elm Architecture](https://github.com/evancz/elm-architecture-tutorial/)”, Model-View-Update shares similarities to Redux, mainly because the latter is inspired by this architecture. This is a purely functional architecture because its host language is [Elm](http://elm-lang.org/), a functional programming language for the Web.

**Parts:**

*   **Model**: a type defining the structure of state data
*   **View**: a pure function transforming state into rendering
*   **Actions**: a type defining user events sent through mailboxes
*   **Update**: a pure function from previous state and an action to new state

[![Model-View-Update diagram](https://staltz.com/img/mvu-unidir-ui-arch.jpg)](https://staltz.com/img/mvu-unidir-ui-arch.jpg)

**Peculiarities:**

**Hierarchical composition everywhere.** The previous architectures had hierarchical composition only in their “View”, however in the MVU architecture such composition is also found in Model and Update. Even Actions may contain nested Actions.

**Components are exported as pieces.** Because of the hierarchical composition everywhere, a “component” in the Elm Architecture is a tuple of: a Model type, an initial Model instance, a View function, an Action type, and an Update function. There cannot be components which deviate from this structure throughout the whole architecture. Each component is a UI program, and this architecture is fractal.

## MODEL-VIEW-INTENT

Introduced as a fully reactive unidirectional architecture based on [RxJS](https://github.com/Reactive-Extensions/RxJS) Observables, Model-View-Intent is the primary architectural pattern in the framework [Cycle.js](http://cycle.js.org). The _Observable_ event stream is a primitive used everywhere, and functions over Observables are pieces of the architecture.

**Parts:**

*   **Intent**: function from Observable of user events to Observable of “actions”
*   **Model**: function from Observable of actions to Observable of state
*   **View**: function from Observable of state to Observable of rendering
*   **Custom element**: subsection of the rendering which is in itself a UI program. May be implemented as MVI, or as a Web Component. Is optional to use in a View.

[![Model-View-Intent diagram](https://staltz.com/img/mvi-unidir-ui-arch.jpg)](https://staltz.com/img/mvi-unidir-ui-arch.jpg)

**Peculiarities:**

**Heavily based on Observables.** The outcome of each part of the architecture is expressed as an Observable event stream. Because of this, it is hard or impossible to express any “data flow” or “change” without using Observables.

**Intent.** Roughly comparable to _Event_ in BEST, user event handlers are declared in the Intent, separately from rendering. Unlike BEST, Intent produces Observable streams of actions, which are like those in Flux, Redux, and Elm. Unlike Flux and others, though, actions in MVI are not directly sent to a Dispatcher or a Store. They are simply available for the Model to listen.

**Fully reactive.** The user’s rendering reacts to the View’s output, which reacts to the Model’s output, which reacts to the Intent’s output (actions), which reacts to user events.

A MVI tuple is a UI program. This architecture is fractal if and only if all custom elements are implemented with MVI.

## NESTED DIALOGUES

This blog post introduces _Nested Dialogues_ as a new unidirectional architecture meant for Cycle.js and any other approach based solely on Observables. It is an evolution of the Model-View-Intent architecture.

Start from the fact that a Model-View-Intent sequence can be functionally composed as a single function, a “Dialogue”:

[![A Dialogue function equivalent to Model-View-Intent](https://staltz.com/img/dialogue-mvi-unidir-ui-arch.jpg)](https://staltz.com/img/dialogue-mvi-unidir-ui-arch.jpg)

As the diagram suggests, a **Dialogue** is a function taking an Observable of user events as input (the input of Intent) and outputting an Observable of renderings (the output of View). Therefore a Dialogue is a UI program.

We generalize the definition of a Dialogue to allow other targets beyond the user, with an input Observable and an output Observable for each target. For example, if a Dialogue interfaces with a user and a server over HTTP, the Dialogue would take two Observables as input: Observable of user events and Observable of HTTP responses. Then, it would output two Observables as output: Observable of renderings and Observable of HTTP requests. This is the concept of [Drivers](http://cycle.js.org/drivers.html) in Cycle.js.

This is how Model-View-Intent restructured as a Dialogue looks like:

[![A Dialogue function as a UI program](https://staltz.com/img/single-dialogue-unidir-ui-arch.jpg)](https://staltz.com/img/single-dialogue-unidir-ui-arch.jpg)

To reuse a Dialogue function as a subcomponent UI program in a larger program is a matter of nesting a Dialogue inside another one:

[![Nested Dialogues](https://staltz.com/img/nested-dialogues-unidir-ui-arch.jpg)](https://staltz.com/img/nested-dialogues-unidir-ui-arch.jpg)

The wiring of Observables between layers of Dialogues is a data flow graph. It is not necessarily an acyclic graph. There are cases such as dynamic lists of subcomponents where a cycle is needed in the data flow graph. Examples of such are beyond the scope of this blog post.

Nested Dialogues is in fact a meta-architecture: it has no convention for the internal structure of a component, allowing us to embed any of the aforementioned architectures into a Nested Dialogue component. The only convention regards the interface of a Dialogue’s extremes: input must be a (collection of) Observable(s), output also must be a (collection of) Observable(s). If a UI program structured as Flux or Model-View-Update or others can have its output and inputs expressed as Observables, then that UI program can be embedded into a Nested Dialogues program as a Dialogue function.

This architecture is therefore fractal (with regards to the Dialogue interface only) and general.

See this [TodoMVC implementation](https://github.com/cyclejs/todomvc-cycle) and [this small app](https://github.com/cyclejs/cycle-examples/tree/master/bmi-nested) as examples of Nested Dialogues with Cycle.js.

## MY BIASED CONCLUSION

While the generality and elegance of Nested Dialogues can be theoretically used to embed other architectures as subcomponents, I am mainly interested in this architecture for structuring Cycle.js applications. I have been searching for a UI architecture which feels **natural** and **flexible**, while at the same providing **structure**.

I believe Nested Dialogues is _natural_ because it directly represents what any typical UI program does: an ongoing process (Observables are ongoing processes) that takes user events as input (the input Observable), and produces rendering as output (the output Observable).

It should be a _flexible_ architecture as well, because as we saw, the internal structure of a Dialogue can be freely implemented with any pattern. This is in contrast to Model-View-Update which has a rigid structure as convention. Fractal architectures seem more reusable than non-fractals, so I’m glad Nested Dialogues has this property too.

However, some common _structure_ can be helpful to guide development. While I believe the internal structure of a Dialogue could be Flux, I think Model-View-Intent fits the Observable input/output interface naturally. So while I want to be free to not implement a Dialogue as MVI, I acknowledge most of the times I will structure it as MVI.

I don’t want to be pretentious to say this is the best user interface architecture, because I have just discovered it and still need to use it in the wild to see its pros and cons. Nested Dialogues is just my strongest bet at the moment.

* * *

[Comments in Hacker News](https://news.ycombinator.com/item?id=10115314).

If you liked this article, consider sharing [(tweeting)](https://twitter.com/intent/tweet?original_referer=https%3A%2F%2Fstaltz.com%2Funidirectional-user-interface-architectures.html&text=Unidirectional%20User%20Interface%20Architectures&tw_p=tweetbutton&url=https%3A%2F%2Fstaltz.com%2Funidirectional-user-interface-architectures.html&via=andrestaltz "tweeting") it to your followers.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
