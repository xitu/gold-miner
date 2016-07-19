> * 原文链接 : [real-world-flux-ios](http://blog.benjamin-encz.de/post/real-world-flux-ios/)
* 原文作者 : [Benjamin Encz](http://blog.benjamin-encz.de/about)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

About half a year ago we started adopting the Flux architecture in the PlanGrid iOS app. This post will discuss our motivation for transitioning from traditional MVC to Flux and will share the experience we have gathered so far.

I’m attempting to describe large parts of our Flux implementation by discussing code that is in production today. If you’re only interested in the high level conclusion you can skip the middle part of this post.

## Why We Transitioned Away from MVC

To put our decision into context I want to describe some of the challenges the PlanGrid app faces. Some of them are unique to enterprise software, others should apply to most iOS apps.

### We Have All the State

PlanGrid is a fairly complex iOS app. It allows users to view blueprints and to collaborate on them using different types of annotations, issues and attachments (and a lot of other stuff that requires industry specific knowledge).

An important aspect of the app is that it is offline first. Users can interact with all features in the app, whether they have an internet connection or not. This means that we need to store a lot of data & state on the client. We also need to enforce a subset of the business rules locally (e.g. which annotation can a user delete?).

The PlanGrid app runs on both iPad and iPhone, but its UI is optimized to make use of the larger available space on tablets. This means that unlike many iPhone apps we often present multiple view controllers at a time. These view controllers tend to share a decent amount of state.

### The State of State Management

All of this means that our app puts a lot of effort into managing state. Any mutation within the app results in more or less the following steps:

1.  Update state in local object.
2.  Update UI.
3.  Update database.
4.  Enqueue change that will be sent to server upon available network connection.
5.  **Notify other objects about state change.**

Though I plan on covering other aspects of our new architecture in future blog posts, I want to focus on the 5\. step today. _How should we populate state updates within our app?_

This is the billion dollar question of app development.

Most iOS engineers, including early developers of the PlanGrid app, come up with the following answers:

*   Delegation
*   KVO
*   NSNotificationCenter
*   Callback Blocks
*   Using the DB as source of truth

All of these approaches can be valid in different scenarios. However, this menu of different options is a big source of inconsistencies in a large codebase that has grown over multiple years.

### Freedom is Dangerous

Classic MVC only advocates the separation of data and its representation. With the lack of other architectural guidance, everything else is left up to individual developers.

For the longest time the PlanGrid app (like most iOS apps) didn’t have a defined pattern for state management.

Many of the existing state management tools such as delegation and blocks tend to create strong dependencies between components that might not be desirable - two view controllers quickly become tightly coupled in an attempt to share state updates with each other.

Other tools, such as KVO and Notifications, create invisible dependencies. Using them in a large codebase can quickly lead to code changes that cause unexpected side effects. It is far to easy for a controller to observe details of the model layer which it shouldn’t be interested in.

Thorough code reviews & style guides can only do so much, many of these architectural issues start with small inconsistencies and take a long time to evolve into serious problems. With well defined patterns in place it is a lot easier to detect deviations early.

### An Architectural Pattern for State Management

One of our most important goals during refactoring the PlanGrid app was putting clear patterns & best practices in place. This would allow future features to be written in a more consistent way and make onboarding of new engineers a lot more efficient.

State management was one of the largest sources of complexity in our app, so we decided to define a pattern that all new features could use going forward.

A lot of the pain we felt in our existing codebase reminded us strongly of the issues that Facebook brought up when they first presented the Flux pattern:

*   Unexpected, Cascading State Updates
*   Hard to Understand Dependencies Between Components
*   Tangled Flow of Information
*   Unclear Source of Truth

It seemed that Flux would be a great fit for solving many of the issues we were experiencing.

## A Brief Intro to Flux

Flux is a very lightweight architectural pattern that Facebook uses for client-side web applications. Even though there is a [reference implementation](https://github.com/facebook/flux), Facebook emphasizes that the ideas of the Flux pattern are a lot more relevant than this particular implementation.

The pattern can be described best alongside a diagram that shows the different flux components:

![](https://raw.githubusercontent.com/Ben-G/Website/master/static/assets/flux-post/Flux_Original.png)

In the Flux architecture a **store** is the single source of truth for a certain part of the app. Whenever the state in the store updates, it will send a change event to all views that subscribed to the store. The **view** receives changes only through this one interface that is called by the store.

State updates can only occur via **actions**.

An **action** describes an intended state change, but it doesn’t implement the state change itself. All components that want to change any state send an **action** to the global **dispatcher**. The stores register with the dispatcher and let it know which actions they are interested in. Whenever an action is dispatched, all interested stores will receive it.

In response to actions some stores will update their state and notify the views about that new state.

The Flux architecture enforces a unidirectional data flow as shown in the diagram above. It also enforces a strict separation of concerns:

*   Views will only receive data from stores. Whenever a store updates, the handler method on the view is invoked.
*   Views can only change state by dispatching actions. Because actions are only descriptions of intents, the business logic is hidden from the view.
*   A store only updates its state when it receives an action.

These constraints make designing, developing and debugging new features a lot easier.

## Flux in PlanGrid for iOS

For the PlanGrid iOS app we have deviated slightly from the Flux reference implementation. We enforce that each store has an observable `state` property. Unlike in the original Flux implementation we don’t emit a change event when a store updates. Instead views observe the `state` property of the store. Whenever the views observe a state change, they update themselves in response:

![](https://raw.githubusercontent.com/Ben-G/Website/master/static/assets/flux-post/Flux.png)

This is a very subtle deviation from the Flux reference implementation, but covering it is helpful for the upcoming sections.

With an understanding of the basics of the Flux architecture, let’s dive into some of the implementation details and questions we needed to answer while implementing Flux in the PlanGrid app.

### What is the Scope of a Store?

The scope of each individual store is a very interesting question that quickly comes up when using the Flux pattern.

Since Facebook published the Flux pattern, different variations have been developed by the community. One of them, called Redux, iterates on the Flux pattern by enforcing that each application should only have a single store. This store stores the state for the entire application (there are many other, subtler, differences that are outside of the scope of this post).

Redux gained a lot of popularity as the idea of a single store further simplifies the architecture of many applications. In traditional Flux, with multiple stores, apps can run into cases where they need to combine state that is stored in separate stores in order to render a certain view. That approach can quickly re-introduce problems that the Flux pattern tried to solve, such as complicated dependencies between different components in an app.

For the PlanGrid app we still decided to go with traditional Flux instead of using Redux. We were unsure how the approach with a single store that stores the entire app state would scale with such a huge app. Further, we identified that we would have very few inter-store dependencies which made it less important to consider Redux as an alternative.

**We have yet to identify a hard rule on the scope of each individual store**.

So far I can identify two patterns in our codebase:

*   **Feature/View Specific Stores:** Each view controller (or each group of closely related view controllers) receives its own store. This store models the view specific state.
*   **Shared State Stores:** We have stores that store & manage state that is shared between many views. We try to keep the amount of these stores minimal. An example of such a store is the `IssueStore`. It is responsible for managing the state of all issues that are visible on the currently selected blueprint. Many views that display and interact with issues derive information from this store. These types of stores essentially act like a live-updating database query.

We are currently in the process of implementing our first _shared state stores_ and are still deciding the best way to model the multiple dependencies of different views onto these types of stores.

### Implementing a Feature Using the Flux Pattern

Let’s dive a little bit deeper into some of the implementation details of features that are built with the Flux pattern.

As an example throughout the next couple of sections we’ll use a feature that’s used in production within the PlanGrid app. The feature allows users to filter annotations on a blueprint:

![](https://raw.githubusercontent.com/Ben-G/Website/master/static/assets/flux-post/filter_screenshot.png)

The feature we’ll discuss lives in the popover that’s presented on the left hand side of the screenshot.

#### Step 1: Defining the State

Usually I begin implementing a new feature by determining the relevant state for it. The state represents everything the UI needs to know in order to render the representation of a certain feature.

Let’s dive right into our example by taking a look at the state for the annotation filter feature shown above:



    struct AnnotationFilterState {
        let hideEverythingFilter: RepresentableAnnotationFilter
        let shareStatusFilters: [RepresentableAnnotationFilter]
        let issueFilters: [RepresentableAnnotationFilter]
        let generalFilters: [RepresentableAnnotationFilter]

        var selectedFilterGroup: AnnotationFilterGroupType? = nil
        /// Indicates whether any filter is active right now
        var isFiltering: Bool = false
    }



The state consists of a list of different filters, a currently selected filter group and a boolean flag that indicates whether any of the filters are active.

This state is exactly tailored to the needs of the UI. The list of filters is rendered in a table view. The selected filter group is used to present/hide the details of an individually selected filter group. And the `isFiltering` flag is used to determine whether or not a button to clear all filters should be enabled or disabled in the UI.

#### Step 2: Defining the Actions

After defining the shape of the state for a certain feature I usually think about the different state mutations in the next step. In the Flux architecture state mutations are modeled in the form of actions that describe which state change is intended. For the annotation filter feature the list of actions is fairly short:



    struct AnnotationFilteringActions {

        /// Enables/disables a filter.
        struct ToggleFilterAction: AnyAction {
            let filter: AnnotationFilterType
        }

        /// Navigates to details of a filter group.
        struct EnterFilterGroup: AnyAction {
            let filterGroup: AnnotationFilterGroupType
        }

        /// Leaves detail view of a filter group.
        struct LeaveFilterGroup: AnyAction { }

        /// Disables all filters.
        struct ResetFilters: AnyAction { }

        /// Disables all filters within a filter group.
        struct ResetFiltersInGroup: AnyAction {
            let filterGroup: AnnotationFilterGroupType
        }
    }



Even without an in-depth understanding of the feature it should be somewhat understandable which state transitions these actions initiate. One of the many benefits of the Flux architecture is that this list of actions is an exhaustive overview of all state changes that can be triggered for this particular feature.

#### Step 3: Implement the Response to Actions in the Store

In this step we implement the core business logic of a feature. I personally tend to implement this step using TDD, which I’ll discuss a little later. The implementation of a store can be summarized as following:

1.  Register store with dispatcher for all actions it is interested in. In the current example that would be all `AnnotationFilteringActions`.
2.  Implement a handler that will be called for each of the individual actions.
3.  Within the handler, perform the necessary business logic and update the state upon completion.

As a concrete example we can take a look at how the `AnnotationFilterStore` handles the `toggleFilterAction`:


    func handleToggleFilterAction(toggleFilterAction: AnnotationFilteringActions.ToggleFilterAction) {
        var filter = toggleFilterAction.filter
        filter.enabled = !filter.enabled

        // Check for issue specific filters
        if filter is IssueAssignedToFilter ||
            filter is IssueStatusAnnotationFilter ||
            filter is IssueAssignedToFilter ||
            filter is IssueUnassignedFilter {
                // if no annotation types are filtered, activate the issue/punchItem type
                var issueTypeFilter = self._annotationFilterService.annotationTypeFilterGroup.issueTypeFilter
                if self._annotationFilterService.annotationTypeFilterGroup.activeFilterCount() == 0 ||
                    issueTypeFilter?.enabled == false {
                        issueTypeFilter?.enabled = true
                }
        }

        self._applyFilter()
    }


This example is purposefully not simplified. So let’s break it down a little. The `handleToggleFilterAction` is invoked whenever a `ToggleFilterAction` is dispatched. The `ToggleFilterAction` carries information about which specific filter should be toggled.

As a very first step of implementing this business logic, the method simply toggles the filter by toggling the value of the `filter.enabled`.

Then we implement some custom business logic for this feature. When working with filters that are intended to filter issue annotations we have some cases in which we need to activate the `issueTypeFilter`. It wouldn’t make sense to dive into the specifics of this PlanGrid feature, but the idea is that this method encapsulates any business logic related to toggling filters.

At the end of the method we’re calling the `_applyFilter()` method. This is a shared method that is used by multiple action handlers:


    func _applyFilter() {
        self._annotationFilterService.applyFilter()

        self._state.value?.isFiltering = self._annotationFilterService.allFilterGroups.reduce(false) { isFiltering, filterGroup in
            isFiltering || (filterGroup.activeFilterCount() > 0)
        }

        // Phantom state update to refresh the cell state, technically not needed since filters are reference types
        // and previous statement already triggers a state update.
        self._state.value = self._state.value
    }


The call to `self._annotationFilterService.applyFilter()` is the one that actually triggers the filtering of annotations that are displayed on a sheet. The filtering logic itself is somewhat complex, so it makes sense to move this into a separate, dedicated type.

The role of each store is to provide the state information that is relevant for the UI and to be the coordination point for state updates. This doesn’t mean that the entire business logic needs to be implemented in the store itself.

The very last step of each action handler is to update the state. Within the `_applyFilter()` method, we’re updating the `isFiltering` state value by checking if any of the filters are now activated.

There’s one important thing to note about this particular store: you might expect to see an additional state update that updates the values of the filters that are stored in the `AnnotationFilterState`. Generally that is how we implement our stores, but this implementation is a little special.

Since the filters that are stored in the `AnnotationFilterState` need to interact with much of our existing Objective-C code, we decided to model them as classes. This means they are reference types and the store and the annotation filter UI share a reference to the same instances. This in turn means that all mutations that happen to filters within the store are implicitly visible to the UI. Generally we try to avoid this by exclusively using value types in our state structs - but this is a blog post about real world Flux and in this particular case the compromise for making Objective-C interop easier was acceptable.

If the filters were value types, we would need to assign the updated filter values to our state property in order for the UI to observe the changes. Since we’re using reference types here, we perform a phantom state update instead:



    // Phantom state update to refresh the cell state, technically not needed since filters are reference types
    // and previous statement already triggers a state update.
    self._state.value = self._state.value



The assignment to the `_state` property will now kick off the mechanism that updates the UI - we’ll discuss the details of that process in a second.

We dived pretty deep into the implementation details so I want to end this section with a reminder of the high level store responsibilities:

1.  Register store with dispatcher for all actions it is interested in. In the current example that would be all `AnnotationFilteringActions`.
2.  Implement a handler that will be called for each of the individual actions.
3.  Within the handler, perform the necessary business logic and update the state upon completion.

Let’s move on to discussing how the UI receives state updates from the store.

#### Step 4: Binding the UI to the Store

One of the core Flux concepts is that an automatic UI update is triggered whenever a state update occurs. This ensures that the UI always represents the latest state and makes away with any code that is required to maintain these updates manually. This step is very similar to the bindings of a View to the ViewModel in the MVVM architecture.

There are many ways to implement this - in PlanGrid we decided to use ReactiveCocoa to allow the store to provide an observable state property. Here’s how the `AnnotationFilterStore` implements this pattern:



    /// The current `AnnotationFilterState`, this should be observed within the view layer.
    let state: SignalProducer<AnnotationFilterState?, NoError>
    /// Internal state.
    let _state: MutableProperty<AnnotationFilterState?> = MutableProperty(nil)



The `_state` property is used within the store to mutate the state. The `state` property is used by clients that want to subscribe to the store. This allows store subscribers to receive state updates but doesn’t allow them to mutate state directly (state mutation should only happen through actions!).

In the initializer the internal observable property is simply bound to the external signal producer:



    self.state = self._state.producer



Now any update to `_state` will automatically send the latest state value through the signal producer stored in `state`.

All that is left, is the code that makes sure that the UI updates whenever a new `state` value is emitted. This can be one of the trickiest parts when getting started with the Flux pattern on iOS. On the web Flux plays extremely well with Facebook’s React framework. React was designed for this specific scenario: _re-render the UI upon state updates without requiring any additional code_.

When working with UIKit we don’t have this luxury, instead we need to implement UI updates manually. I cannot dive into this in detail within this post, otherwise the length of it would explode. The bottom line is that we have built some components that provide a React like API for `UITableView` and `UICollectionView`, we’ll take a brief look at them later on.

If you want to learn more about these components, you can check out a [talk I gave recently](https://skillsmatter.com/skillscasts/8179-turning-uikit-inside-out), as well as the two GitHub repositories that go along with it ([AutoTable](https://github.com/Ben-G/AutoTable), [UILib](https://github.com/Ben-G/UILib)).

Let’s again take a look at some real world code (in this case it is slightly shortened) from the annotation filter feature. This code lives in the `AnnotationFilterViewController`:



    func _bind(compositeDisposable: CompositeDisposable) {
    	// On every state update, recalculate the cells for this table view and provide them to
    	// the data source.
    	compositeDisposable += self.tableViewDataSource.tableViewModel  self.store.state
    	    .ignoreNil()
    	    .map { [weak self] in
    	        self?.annotationFilterViewProvider.tableViewModelForState($0)
    	    }
    	    .on(event: { [weak self] _ in
    	        self?.tableViewDataSource.refreshViews()
    	    })

    	compositeDisposable += self.store.state
    	    .ignoreNil()
    	    .take(1)
    	    .startWithNext { [weak self] _ in
    	        self?.tableView.reloadData()
    	    }

    	 compositeDisposable += self.navigationItem.rightBarButtonItem!.racEnabled  self.store.state
                .map { $0?.isFiltering ?? false }
    }



In our codebase we follow a convention where each view controller has a `_bind` method that is called from within `viewWillAppear`. This `_bind` method is responsible for subscribing to the store’s state and providing code that updates the UI when state changes occur.

Since we need to implement partial UI updates ourselves and cannot rely on a React-like framework, this method usually contains code that describes how a certain state update maps to a UI update. Here ReactiveCocoa comes in very handy as it provides many different operators (`skipUntil`, `take`, `map`, etc.) that make it easier to set up these relationships. If you haven’t used a Reactive library before this code might look a little confusing - but the small subset of ReactiveCocoa that we use can be learnt pretty quickly.

The first line in the example `_bind` method above ensures that the table view gets updated whenever a state update occurs. We use the ReactiveCocoa `ignoreNil()` operator to ensure that we don’t kick off updates for an empty state. We then use the `map` operator to map the latest state from the store into a description of how the table view should look like.

This mapping occurs via the `annotationFilterViewProvider.tableViewModelForState` method. This is where our custom React-like UIKit wrapper comes into play.

I won’t dive into all implementation details, but here is what the `tableViewModelForState` method looks like:



    func tableViewModelForState(state: AnnotationFilterState) -> FluxTableViewModel {

        let hideEverythingSection = FluxTableViewModel.SectionModel(
            headerTitle: nil,
            headerHeight: nil,
            cellViewModels: AnnotationFilterViewProvider.cellViewModelsForGroup([state.hideEverythingFilter])
        )

        let shareStatusSection = FluxTableViewModel.SectionModel(
            headerTitle: "annotation_filters.share_status_section.title".translate(),
            headerHeight: 28,o
            cellViewModels: AnnotationFilterViewProvider.cellViewModelsForGroup(state.shareStatusFilters)
        )

        let issueFilterSection = FluxTableViewModel.SectionModel(
            headerTitle: "annotation_filters.issues_section.title".translate(),
            headerHeight: 28,
            cellViewModels: AnnotationFilterViewProvider.cellViewModelsForGroup(state.issueFilters)
        )

        let generalFilterSection = FluxTableViewModel.SectionModel(
            headerTitle: "annotation_filters.general_section.title".translate(),
            headerHeight: 28,
            cellViewModels: AnnotationFilterViewProvider.cellViewModelsForGroup(state.generalFilters)
        )

        return FluxTableViewModel(sectionModels: [
            hideEverythingSection,
            shareStatusSection,
            issueFilterSection,
            generalFilterSection
        ])
    }



`tableViewModelForState` is a pure function that receives the latest state as its input and returns a description of table view in the form of a `FluxTableViewModel`. The idea of this method is similar to React’s render function. The `FluxTableViewModel` is entirely independent of UIKit and is a simple struct that describes the content of the table. You can find an open source example implementation of this in the [AutoTable repository](https://github.com/Ben-G/AutoTable/blob/master/AutoTable/AutoTable/TableViewModel.swift).

The result of this method is then bound to the `tableViewDataSource` property of the view controller. The component stored in that property is responsible for updating the `UITableView` based on the information provided in the `FluxTableViewModel`.

Other binding code is a lot simpler, e.g. the code that enables/disables the “Clear Filter” button based on the `isFiltering` state:



    compositeDisposable += self.navigationItem.rightBarButtonItem!.racEnabled  self.store.state
                .map { $0?.isFiltering ?? false }



Implementing the UI bindings is definitely one of the trickier parts, since it doesn’t fit perfectly well together with UIKit’s programming model. But it only takes little effort to write custom components to make this easier. In our experience we’ve saved multiples of our invested time by implementing these components instead of sticking with the classical MVC approach in which these UI updates are redundantly implemented across many, many view controllers.

With these UI bindings in place, we’ve discussed the last part of implementing a Flux feature. Since I covered a lot I want to give a quick recap before moving on to discussing the testing approach for Flux features.

#### Implementation Recap

When implementing a Flux feature I will typically split the work into the following segments:

1.  Define the shape of the state type.
2.  Define the actions.
3.  Implement business logic and state transitions for each of the actions - this implementation lives in the store.
4.  Implement UI bindings that map the state to a view representation.

This wraps up all of the implementation details we discussed.

Let’s move on to discuss how to test Flux features.

### Writing Tests

One of the main benefits of the Flux architecture is that it separates concerns strictly. This makes it really easy to test the business logic and large parts of the UI code.

Each Flux feature has two main areas that need to be tested:

1.  The business logic in the store.
2.  The view model providers (these are our React-like functions that produce a description of the UI based on an input state).

#### Testing Stores

Testing stores is typically very simple. We can drive interactions with the store by passing in actions and we can observe the state changes by either subscribing to the store or by observing the internal `_state` property in our tests.

Additionally, we can mock any outside types that the store might need to communicate with in order to implement a certain feature (this could be an API client or a data access object) and inject these in the store’s initializer. This allows us to validate that these types are called as expected.

Within PlanGrid we write our tests in a behavioral style using Quick and Nimble. Here is a simple example of a test from our annotation filter store specification:



    describe("toggling a filter") {

        var hideAllFilter: AnnotationFilterType!

        beforeEach {
            hideAllFilter = annotationFilterService.hideAllFilterGroup.filters[0]
            let toggleFilterAction = AnnotationFilteringActions.ToggleFilterAction(filter: hideAllFilter)
            annotationFilterStore._handleActions(toggleFilterAction)
        }

        it("toggles the selected filter") {
            expect(hideAllFilter.enabled).to(beTrue())
        }

        it("enables filtering mode") {
            expect(annotationFilterStore._state.value?.isFiltering).to(beTrue())
        }

        context("when subsequently resetting filters") {

            beforeEach {
                annotationFilterStore._handleActions(AnnotationFilteringActions.ResetFilters())
            }

            it("deactivates previously active filters and stops filter mode") {
                expect(hideAllFilter.enabled).to(beFalse())
                expect(annotationFilterStore._state.value?.isFiltering).to(beFalse())
            }

        }
    }


Once again, testing stores would merit it’s own blog post, so I won’t dive into the details of this particular test. However, the testing philosophy should be clear. We send actions to the store and validate the response in form of state changes or calls to injected mocks.

(You might wonder why we’re calling the `_handleActions` method on the store instead of dispatching an action using the dispatcher. Originally our dispatcher used asynchronous dispatch when delivering actions, which would have meant our tests needed to be asynchronous as well. Therefore we called the handler on the store directly. The implementation of the dispatcher has since changed, so we could be using the dispatcher in our tests going forward.)

When implementing the business logic in a store I now mostly write my tests first. The structure of the our store code along with the behavioral Quick specs lends itself extremely well to a test driven development process.

#### Testing Views

The Flux architecture combined with our declarative UI layer makes testing views pretty simple. Internally we are still debating the amount of coverage we should aim for on the view layer.

Practically all of our view code is fairly straightforward. It binds the state in the store to different properties of our UI layer. For our app we have decided to cover most of this code through UI automation tests.

However, there are many alternatives. Since the view layer is set up to render an injected state, snapshot tests work really well, too. Artsy has covered the idea of snapshot testing in various talks and blog posts, [including a great article on objc.io](https://www.objc.io/issues/15-testing/snapshot-testing/).

For our app we have decided that our UI automation coverage is sufficient, so that we don’t need additional snapshot tests.

I have also experimented with unit testing the view provider functions (e.g. the `tableViewModelForState` function we’ve seen earlier). These view providers are pure functions that map a state to a UI description, so they are very easy to test based on an input and a return value. However, I found that these tests don’t add too much value as they mirror the declarative description of the implementation very closely.

Using the Flux architecture view testing becomes fairly simple because the view code is well isolated from the rest of the app. You only need to inject a state that should be rendered in your tests and you are good to go.

As we’ve seen there are may alternatives for testing the UI, I’m interested to see which one we (and other developers) will pick in the long term.

## Conclusion

After diving into many implementation details I’d like to close with high level summary of our experience so far.

We’ve only been using the Flux architecture for about 6 months, but we are already seeing many benefits in our code base:

*   New features are implemented consistently. The structure of stores, view providers and view. controllers across features is almost identical.
*   By inspecting the state, the actions and the BDD-style tests it is very easy to understand how a feature works within a matter of minutes.
*   We have a strong separation of concerns between stores and views. There’s seldom ambiguity about where certain code should live.
*   Our code reads a lot simpler. The state upon which a view depends is always explicit. This makes debugging really easy, too.
*   All of the above points make onboarding new developers a lot easier.

Obviously there are also some **pain points**:

*   First and foremost the integration with UIKit components can be a little painful. Unlike React components, UIKit views don’t provide an API to simply update themselves based on a new state. This burden lies on us and we either need to implement it manually in our view bindings or need to write custom components that wrap UIKit components.
*   Not all of our new code strictly follows the Flux pattern yet. E.g. we haven’t yet tackled a navigation/routing system that works with Flux. We need to either integrate a [coordinator pattern](http://khanlou.com/2015/10/coordinators-redux/) into our Flux architecture or use an actual router similar to [ReSwift Router](https://github.com/ReSwift/ReSwift-Router).
*   We need to come up with a good pattern for state that is shared across large portions of the app (as discussed very early in this post: “What is the Scope of a Store?”). Should we have dependencies between stores as in the original Flux pattern? What are the alternatives?

There are many, many more implementation details, advantages and disadvantages that I would like to dive into so I hope to cover some aspects in more detail in future blog posts.

So far I’m very happy with our choice and I hope this blog posts gives you some insight into whether the Flux architecture is suitable for you as well.

And finally, if you’re interested in working with Flux in Swift, or simply want to help deliver an important product to a huge industry, **[we’re hiring](http://grnh.se/8fcutd)**.

Thanks a lot to [@zats](https://twitter.com/zats), [@kubanekl](https://twitter.com/kubanekl) and [@pixelpartner](https://twitter.com/pixelpartner) for reading drafts of this post!

**References**:

*   [Flux](https://facebook.github.io/flux/) - Facebook’s official Flux website including the original talk introducing it
*   [Unidirectional Data Flow in Swift](https://realm.io/news/benji-encz-unidirectional-data-flow-swift/) - a talk I gave at Swift about Redux concepts and the original ReSwift implementation
*   [ReSwift](https://github.com/reswift/reswift) - an implementation of Redux in Swift
*   [ReSwift Router](https://github.com/ReSwift/ReSwift-Router) - a declarative router for ReSwift apps
