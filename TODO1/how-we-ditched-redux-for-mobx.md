> * 原文地址：[How We Ditched Redux for MobX](https://medium.com/skillshare-team/how-we-ditched-redux-for-mobx-a05442279a2b)
> * 原文作者：[Luis Aguilar](https://medium.com/@ldiego08)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-ditched-redux-for-mobx.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-ditched-redux-for-mobx.md)
> * 译者：
> * 校对者：

# How We Ditched Redux for MobX

We at Skillshare embrace change; not because it looks cool in a company’s vision statement, but because it’s **necessary.** That is the premise behind the recent decision to migrate the whole platform to React, leveraging all the goodness it entails. The group tasked with introducing these changes is but a small delta of our lovely engineering team. Making the right decisions early it’s crucial for getting the rest of the team onboard as smoothly and quickly as possible.

A smooth development experience is everything.

**Everything.**

And so, along the road of getting React into our codebase, we stumbled upon the most challenging bits of doing frontend development: **state management.**

Oh boy… were we in for some fun.

## Setup

It all started simple: **“migrate Skillshare’s header to React.”**

**“Ah, easy as pie,”** we dared saying—it was only the “guest” view which only had a few links and a simple search box. No authentication logic, no session management, nothing magical going on.

Alright, let’s get into some code:

```TSX
interface HeaderProps {
    searchBoxProps: SearchBoxProps;
}

class Header extends Component<HeaderProps> {
    render() {
        return (
            <div>
                <SearchBox {...this.props.searchBoxProps} />
            </div>
        );
    }
}
    
interface SearchBoxProps {
    query?: string;
    isLoading: string;
    data: string[];
    onSearch?: (query: string) => void;
}

class SearchBox extends Component<SearchBoxProps> {
    render() {
        // Render the component ..
    }
}
```

Oh yeah, we use TypeScript—it’s the cleanest, most intuitive, and friendly to all devs. How not to love it? We also use [Storybook](https://storybook.js.org/) for UI development, so we’d like to keep components as dumb as possible and do any wiring up at the highest level possible. Since we use [Next](https://nextjs.org/) for server-side rendering, that level would be the page components, which in the end are just plain old components residing in a designated **pages** folder and automatically mapped to URL requests by the runtime. So, if you have a `home.tsx `****file there, it will be automatically mapped to the `/home` route—bye bye goes `renderToString()`.

Alright, that’s it for components… but wait! Getting that search box working also involved setting up a state management strategy, and plain local state wouldn’t get us very far.

## Confrontation: Redux

In React, when it comes to state management, Redux is the gold standard—it’s got over 40k stars on GitHub, has full TypeScript support, and big guys like Instagram use it.

Here’s how it works:

![Image by [@abhayg772](http://twitter.com/abhayg772)](https://cdn-images-1.medium.com/max/2400/1*kDO26wU8yMn0Xq7crphztA.png)

Unlike traditional MVW patterns, Redux manages an application-wide state tree. UI events trigger actions, actions pass data to a reducer, the reducer updates the state tree, and ultimately the UI updates.

Easy, right? Well, let’s do this!

The entity involved here is called a **“tag.”** Hence, when the user types in the search box, it searches for **tags.**

```TypeScript
/* We have three actions here:
 *   - Tags search: when the user types and a new search is triggered.
 *   - Tags search update: when the search results are ready and have to update.
 *   - Tags search error: bad stuff happened.
 */

enum TagActions {
    Search = 'TAGS_SEARCH',
    SearchUpdate = 'TAGS_SEARCH_UPDATE',
    SearchError = 'TAGS_SEARCH_ERROR',
}

interface TagsSearchAction extends Action {
    type: TagActions.Search;
    query: string;
}

interface TagsSearchUpdateAction extends Action {
    type: TagActions.SearchUpdate;
    results: string[];
}

interface TagsSearchErrorAction extends Action {
    type: TagActions.Search;
    err: any;
}

type TagsSearchActions = TagsSearchAction | TagsSearchUpdateAction | TagsSearchErrorAction;
```

Well, that was easy. Now we need some helpers to create our actions dynamically based on input parameters:

```TypeScript
const search: ActionCreator<TagsSearchAction> =
    (query: string) => ({
        type: TagActions.Search,
        query,
    });

const searchUpdate: ActionCreator<TagsSearchUpdateAction> =
    (results: string[]) => ({
        type: TagActions.SearchUpdate,
        results,
    });

const searchError: ActionCreator<TagsSearchErrorAction> =
    (err: any) => ({
        type: TagActions.SearchError,
        err,
    });

```

There! Now the reducer which updates the state depending of the action:

```TypeScript
interface State {
    query: string;
    isLoading: boolean;
    results: string[];
}

const initialState: State = {
    query: '',
    isLoading: false,
    results: [],
};

const tagSearchReducer: Reducer<State> =
    (state: State = initialState, action: TagsSearchActions) => {
        switch ((action as TagsSearchActions).type) {
            case TagActions.Search:
                return {
                    ...state,
                    isLoading: true,
                    query: (action as TagsSearchAction).query,
                };

            case TagActions.SearchUpdate:
                return {
                    ...state,
                    isLoading: false,
                    results: (action as TagsSearchUpdateAction).tags,
                };

            case TagActions.SearchError:
                return {
                    ...state,
                    isLoading: false,
                    results: (action as TagsSearchErrorAction).err,
                };

            default:
                return state;
        }
    };
```

Whew, that was quite a chunk of code, but now we’re rolling! Remember all wiring goes on at the highest level, and that’d be our **page** components.

```TSX
interface HomePageProps {
    headerProps?: HeaderProps;
}

class HomePage extends Component<IndexPageProps> {
    render() {
        return (
            <Header {...this.props.headerProps} />
            <!-- the rest of the page .. -->
        );
    }
}

const mapStateToProps = (state: State) => ({
    headerProps: {
        searchBoxProps: {
            isLoading: state.isLoading,
            results: state.results,
            query: state.query,
        }
    }
});
    
const mapDispatchToProps = (dispatch: Dispatch) => ({
    headerProps: {
        searchBoxProps: {
            onSearch: (query: string) => dispatch(TagActions.search(query)),
        }
    }
});
    
const connectedPage = connect(mapStateToProps, mapDispatchToProps)(HomePage);
    
const reducers = combineReducers({
    tagSearch: tagSearchReducer,
});

const makeStore = (initialState: State) => {
    return createStore(reducers, initialState);
}

// it all comes to this - BEHOLD: THE WIRED-UP HOME PAGE!
export default withRedux(makeStore)(connectedPage);
```

And we’re done! Time to dust off our hands and grab a beer. We have our UI components, a lovely page, and everything nicely glued together.

Uhm… wait.

This is just local data.

We still have to fetch stuff from the actual API. Redux requires actions to be pure functions; they have to be executable right away. And what doesn’t execute right away? Async operations like fetching data from an API. Hence, Redux has to be paired with other libraries to achieve this. There are plenty of options, like [thunks](https://github.com/reduxjs/redux-thunk), [effects](https://github.com/redux-effects/redux-effects), [loops](https://github.com/redux-loop/redux-loop), [sagas](https://github.com/redux-saga/redux-saga), and each one works differently. That doesn’t only mean additional incline degrees on an already steep learning curve, but even more boilerplate.

![](https://cdn-images-1.medium.com/max/2000/1*x2FqXWuYcGN_Pso4MRfafg.jpeg)

And as we trudged along these muddy waters, the obvious echoed over and over in our heads: **“all this code just for binding a search box?”** And we were sure those would be the exact same words coming from anyone daring enough to venture into our codebase.

One can’t diss Redux; it’s the pioneer in its field and a beautiful concept all around. However, we found it’s way too low-level, demanding you to define everything. It is constantly praised for being very opinionated, preventing you from shooting yourself in the foot by enforcing a pattern, but the price of that is an unholy amount of boilerplate and a thick learning barrier.

That was the dealbreaker for us.

How do we tell our team they won’t be seeing their families during the holidays because of boilerplate?

There’s gotta be something else.

Something more **friendly.**

[**You Might Not Need Redux**](https://medium.com/@dan_abramov/you-might-not-need-redux-be46360cf367)

## Resolution: MobX

At first, we thought of creating some helpers and decorators to circumvent code repetition. That would mean more code to maintain. Also, when core helpers break, or they need new functionality, it can stall the whole team while making changes. You wouldn’t want to lay fingers on a three-year-old helper used by pretty much the whole app, do you?

Then some wild thoughts came along…

**“What if we didn’t use redux at all?”**

**“What else is there?”**

A click on that **“I’m Feeling Lucky”** button yielded the answer: [**MobX**](https://mobx.js.org/)

MobX promises you one thing: to just let you do your work. It applies the principles of reactive programming to React components — yeah, ironically, React is not reactive out of the box. Unlike Redux, you can have multiple stores (i.e. `TagsStore`, `UsersStore`, etc.,) or a root store, and bind them to component props. It is there to help you in managing your state, but how you shape it is entirely up to you.

![Image by [Hanno.co](https://hanno.co/blog/mobx-redux-alternative/)](https://cdn-images-1.medium.com/max/3200/1*QZ8X8IZfm7IPkZj0iyRC7w.png)

So we have React integration, full TypeScript support, and minimal-to-no boilerplate.

You know what? I’ll let the code do the talking.

We start by defining our store:

```TypeScript
import { observable, action, extendObservable } from 'mobx';

export class TagsStore {
    private static defaultState: any = {
        query: '',
        isLoading: false,
        results: [],
    };

    @observable public results: string[];

    @observable public isLoading: boolean;

    @observable public query: string;

    constructor(initialState: any) {
        extendObservable(this, {...defaultState, ...initialState});
    }

    @action public loadTags = (query: string) => {
        this.query = query;

        // do something here ..
    }
}

export interface StoreMap {
    tags: TagsStore,
}
```

Then wire up the page:

```TSX
import React, { Component } from 'react';
import { inject, Provider } from 'mobx-react';

import { Header, HeaderProps } from './header';


export interface HomePageProps {
    headerProps?: HeaderProps;
}

export class HomePage extends Component<IndexPageProps> {
    render() {
        return (
            <Header {...this.props.headerProps} />
            <!-- the rest of the page .. -->
        );
    }
}

export interface StoreMap {
    tags: TagsStore;
}
    
export const ConnectedHomePage = inject(({ tags }: StoreMap) => ({
    headerProps: {
        searchBoxProps: {
            query: tags.query,
            isLoading: tags.isLoading,
            data: tags.data,
            onSearch: tags.loadTags,
        }
    }
}));

export const tagsStore = new TagsStore();
        
export default () => {
    return (
        <Provider tags={tagsStore}>
            <ConnectedHomePage>
        </Provider>
    );
}
```

And that’s it… you’re done! We got up and running to the same place we were in the Redux example, except in a matter of a few minutes.

So the code is quite self-explanatory, but to clarify, the `inject` helper comes from MobX React integration; it’s the counterpart to Redux’s `connect` helper except that `mapStateToProps` and `mapDispatchToProps` are in a single function. The `Provider` component it’s also MobX, and it takes as many stores as you want which will be later passed on to the `inject` helper. Also, look at those beautiful, **beautiful** decorators—that’s how you configure your store. Any property decorated with `@observable `will notify bound components to re-render on change.

Now that’s what I call **“intuitive.”**

Need I to say more?

Okay, moving onto API fetching, remember how Redux doesn’t handle async actions out-of -the-box? Remember how you had to use `thunks` (which are hard to test,) or `sagas` (which are hard to understand) if you wanted that? Well, with MobX you have plain old classes, so constructor-inject your fetching library of choice and do it in the actions. Miss sagas and generator functions?

Behold the `flow` helper!

```TypeScript
import { action, flow } from 'mobx';

export class TagsStore {

    // ..

    @action public loadTags = flow(function * (query: string) {
        this.query = query;
        this.isLoading = true;

        try {
            const tags = yield fetch('http://somewhere.com/api/tags');
            this.tags = tags;
        } catch (err) {
            this.err = err;
        }

        this.isLoading = false;
    })
}   
```

The `flow` helper takes a generator function which yields steps—response data, logging calls, errors, etc. It’s a series of steps which can be executed gradually or paused if needed.

**A flow!** Get it?

The times of explaining why **sagas** are named like that are over. Hell, even generator functions seem less scary now.

[**Javascript (ES6) Generators — Part I: Understanding Generators**](https://medium.com/@hidace/javascript-es6-generators-part-i-understanding-generators-93dea22bf1b)

## Aftermath

Although everything was rainbows and colors so far, an unsettling feeling was still there for some reason—a feeling that going against the current would end up firing back at us. Maybe we needed all that boilerplate to enforce standards. Maybe we needed an opinionated framework. Maybe we needed a well-defined application state tree.

What if we want something like Redux but as convenient as MobX?

Well, for that there is **[MobX State Tree](https://github.com/mobxjs/mobx-state-tree).**

With MST, we define the application state tree using a specialized API, and it is immutable, giving you time traveling, serialization and rehydration, and everything else you can expect from an opinionated state management library.

But enough talk, have at you!

```TypeScript
import { flow } from 'mobx';
import { types } from 'mobx-state-tree';

export const TagsStoreModel = types
    .model('TagsStore', {
        results: types.array(types.string),
        isLoading: types.boolean,
        query: types.string,
    })
    .actions((self) => ({
        loadTags: flow(function * (query: string) {
            self.query = query;
            self.isLoading = true;

            try {
                const tags = yield fetch('http://somewhere.com/api/tags');
                self.tags = tags;
            } catch (err) {
                self.err = err;
            }

            self.isLoading = false;
        }
    }));

export const StoreModel = types
    .model('Store', {
        tags: TagsStoreModel,
    });

export type Store = typeof StoreModel.Type;
```

Instead of letting you do whatever you please, MST enforces a pattern by requiring you to define your state tree its way. One might think that this is just MobX but with chained functions instead of classes, but it is way more. The tree is immutable, and each change will create a new **“snapshot”** of it, enabling time travel, serialization and rehydration, and everything else you felt you were missing.

Addressing the elephant in the room, the only low point is that this is a semi-functional approach to MobX, meaning it ditches classes and decorators, meaning [TypeScript support is best effort.](https://github.com/mobxjs/mobx-state-tree#typescript--mst)

But even so, it’s still pretty great!

Okay, moving on, let’s wire up the page:

```TSX
import { Header, HeaderProps } from './header';
import { Provider, inject } from 'mobx-react';

export interface HomePageProps {
    headerProps?: HeaderProps;
}

export class HomePage extends Component<IndexPageProps> {
    render() {
        return (
            <Header {...this.props.headerProps} />
            <!-- the rest of the page .. -->
        );
    }
}

export const ConnectedHomePage = inject(({ tags }: Store) => ({
    headerProps: {
        searchBoxProps: {
            query: tags.query,
            isLoading: tags.isLoading,
            data: tags.data,
            onSearch: tags.loadTags,
        }
    }
}));

export const tagsStore = new TagsStore();
        
export default () => {
    return (
        <Provider tags={tagsStore}>
            <ConnectedHomePage>
        </Provider>
    );
}
```

See that? Connecting components remains the same, so even the effort of migrating from vanilla MobX to MST is lesser than writing Redux boilerplate.

Why didn’t we go all the way to MST?

Well, MST was overkill for our specific case. We considered it because time travel debugging is a **very** nice to have, but after stumbling upon [**Delorean**](https://github.com/BrascoJS/delorean) that’s no longer a reason to move over. The day when we need something MobX can’t provide might come, but even falling back to Redux doesn’t seem as daunting thanks to how unobtrusive MobX is.

All in all, we love you, MobX.

Stay awesome.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
