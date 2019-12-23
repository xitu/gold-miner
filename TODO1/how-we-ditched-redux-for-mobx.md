> * 原文地址：[How We Ditched Redux for MobX](https://medium.com/skillshare-team/how-we-ditched-redux-for-mobx-a05442279a2b)
> * 原文作者：[Luis Aguilar](https://medium.com/@ldiego08)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-ditched-redux-for-mobx.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-ditched-redux-for-mobx.md)
> * 译者：[lihaobhsfer](https://github.com/lihaobhsfer)
> * 校对者：[动力小车](https://github.com/Stevens1995)

# 我们如何抛弃了 Redux 而选用 MobX

在 Skillshare 我们拥抱改变；不仅因为把它写在公司的前景宣言中很酷，也因为改变确实有必要。这是我们近期将整个平台迁移至 React 并利用其所有优势这一决定背后的前提。执行这个任务的小组仅仅是我们工程师团队的一小部分。尽早做出正确的决定对于让团队其他成员尽可能快而顺畅地切换平台来说至关重要。

顺畅的开发体验就是一切。

**一切。**

然后，在将 React 引入我们的代码库时，我们遇到了前端开发最有挑战的一部分：**状态管理**。

唉…接下来就有意思了。

## 设置

一切都开始于简单的任务：**“将 Skillshare 的页头迁移至 React。”**

“**小菜一碟**！”我们立下了 flag —— 这个页头只是访客视图，只包含几个链接和一个简单的搜索框。没有授权逻辑，没有 session 管理，没有什么特别神奇的东西。

好的，来敲点代码吧：

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
        // 渲染组件…
    }
}
```

没错，我们用 TypeScript —— 它是最简洁、最直观、对所有开发者最友好的语言。怎能不爱它呢？我们还使用 [Storybook](https://storybook.js.org/) 来做 UI 开发，所以我们希望让组件越傻瓜越好，在越高层级将其拼接起来越好。由于我们用 [Next](https://nextjs.org/) 做服务端渲染，那个层级就是页面组件，它们最终就仅仅是广为人知的位于指定 `pages` 目录中的组件，并在运行时自动映射到 URL 请求中。所以，如果你有一个 `home.tsx` 文件，它就会被自动映射到 `/home` 路由 —— 和 `renderToString()` 说再见吧。

好的，组件就讲到这里吧…但等一下！实现搜索框功能还需要制定一个状态管理策略，本地状态不会给我们带来什么长足发展。

## 对抗：Redux

在 React 中，提到状态管理时，Redux 就是黄金法则 —— 它在 Github 上有 4w+ Star（截至英文原文发布时。截至本译文发布时已有 5w+ Star。），完全支持 TypeScript，并且像 Instagram 这样的大公司也用它。

下图描述了它的原理：

![图片来自 [@abhayg772](http://twitter.com/abhayg772)](https://cdn-images-1.medium.com/max/2400/1*kDO26wU8yMn0Xq7crphztA.png)

不像传统的 MVW 样式，Redux 管理一个覆盖整个应用的状态树。UI 触发 actions，actions 将数据传递给 reducer，reducer 更新状态树，并最终更新 UI。

非常简单，对不？再来敲点代码！

这里涉及到的实体是**标签。**因此，当用户在搜索框中输入时，搜索框搜索的是**标签**

```TypeScript
/* 这里有三个 action:
 *   - 标签搜索: 当用户进行输入时，触发新的搜索。
 *   - 标签搜索更新: 当搜索结果准备好，必须进行更新。
 *   - 标签搜索报错：发生了不好的事情。
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

还挺简单的。现在我们需要一些帮助函数，基于输入参数来动态创建 actions：

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

搞定！接下来是负责基于 action 更新 state 的 reducer：

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

这段代码还挺长的，但是我们正在取得进展！所有的拼接都在最顶层进行，即我们的**页面**组件。

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

// 所有都汇聚于此 —— 看吧：拼接完成的首页！
export default withRedux(makeStore)(connectedPage);
```

任务完成！掸掸手上的灰来瓶啤酒吧。我们已经有了 UI 组件，一个页面，所有的部分都完好地组接在一起。

Emmm…等一下。

这只是本地状态。

我们仍需要从真正的 API 获取数据。Redux 要求 actions 为纯函数；他们必须立即可执行。什么不会立即执行？像从API获取数据这样的异步操作。因此，Redux 必须与其他库配合来实现此功能。有不少可选用的库，比如 [thunks](https://github.com/reduxjs/redux-thunk)、[effects](https://github.com/redux-effects/redux-effects)、[loops](https://github.com/redux-loop/redux-loop)、[sagas](https://github.com/redux-saga/redux-saga)，每一个都有些差别。这不仅仅意味着在原本就陡峭的学习曲线上又增加坡度，并且意味着更多的模板。

![](https://cdn-images-1.medium.com/max/2000/1*x2FqXWuYcGN_Pso4MRfafg.jpeg)

当我们在泥泞中艰难前行中，那个显而易见的问题不停地回响在我们的脑海中：**这么多行代码，就为了绑定一个搜索框**？我们确信，任何一个有勇气查看我们代码库的人都会问同样的问题。

我们不能 Diss Redux；它是这个领域的先锋，也是一个优雅的概念。然而，我们发现它过于“低级”，需要你亲自定义一切。它一直由于有非常明确的思想，能避免你在强制一种风格的时候搬起石头砸自己的脚而受到好评，但这些所有都有代价，代价就是大量的模板代码和一个巨大的学习障碍。

这我们就忍不了了。

我们怎么忍心告诉我们的团队，他们假期要来加班，就因为这些模板代码？

肯定有别的工具。

更加**友好**的工具。

[**你并不一定需要 Redux**](https://medium.com/@dan_abramov/you-might-not-need-redux-be46360cf367)

## 解决方案：MobX

起初，我们想过创建一些帮助函数和装饰器来解决代码重复。而这意味着需要维护更多代码。并且，当核心帮助函数出问题，或者需要新的功能，在修改它们时可能会迫使整个团队停止工作。三年前写的、整个应用都在用的帮助函数代码，你也不想再碰，对不？

然后我们有了一个大胆的想法…

**“如果我们根本不用 Redux 呢？”**

**“还有啥别的可以用？”**

点了一下“**我今天感觉很幸运**”按钮，我们的到了答案：[**MobX**](https://mobx.js.org/)

MobX 保证了一件事：保证你做你的工作。它将响应式编程的原则应用于 React 组件 —— 没错，讽刺的是，React 并不是开箱即具备响应式特点的。不像 Redux，你可以有很多个 store（比如 `TagsStore`、`UsersStore` 等等），或者一个总的 store，将它们绑定于组件的 props 上。它帮助你管理状态，但是如何构建它，决定权在你手里。

![图片来自 [Hanno.co](https://hanno.co/blog/mobx-redux-alternative/)](https://cdn-images-1.medium.com/max/3200/1*QZ8X8IZfm7IPkZj0iyRC7w.png)

所以我们现在整合了 React，完整的 TypeScript 支持，还有极简的模板。

还是让代码为自己代言吧。

我们首先定义 store：

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

        // 一些业务代码…
    }
}

export interface StoreMap {
    tags: TagsStore,
}
```

然后拼接一下页面：

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

就这样搞定了！我们已经实现了所有在 Redux 例子中有的功能，不过我们这次只用了几分钟。

代码相当清晰了，不过为了说明白，`inject` 帮助函数来自于 MobX React；它与 Redux 的 `connect` 帮助函数对标，只不过它的 `mapStateToProps` 和 `mapDispatchToProps` 在一个函数当中。 `Provider` 组件也来自于 MobX，可以在里面放任意多个 store，它们都会被传递至 `inject` 帮助函数中。并且，快看看那些迷人的，**迷人的**装饰器 —— 就这样配置 store 就对了。所有用 `@observable` 装饰的实体都会通知被绑定的组件在发生改变后重新渲染。

这才叫“**直观**”。

还需多说什么？

然后，关于访问 API，是否还记得 Redux 不能直接处理异步操作？是否还记得你为了实现异步操作不得不使用 `thunks`（它们非常不好测试）或者 `sagas`（非常不易理解）？那么，有了 MobX，你可以用普普通通的类，在构造函数里注入你选择的 API 访问库，然后在 action 里执行。还想念 sagas 和 generator 函数吗？

请看吧，这就是 `flow` 帮助函数！

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

这个 `flow` 帮助函数用 generator 函数来产出步骤 —— 响应数据，记录调用，报错等等。它是可以渐进执行或在需要时暂停的一系列步骤。

**一个流程!** 懂了不？

那些需要解释为什么**sagas**要这叫这名字的时光结束了。感谢上苍，就连 generator 函数都显得不那么可怕了。

[**Javascript (ES6) Generators — 第一部分: 了解 Generators**](https://medium.com/@hidace/javascript-es6-generators-part-i-understanding-generators-93dea22bf1b)

## 结果

虽然到目前为止一切都显得那么美好，但不知为何还是有一种令人不安的感觉 —— 总感觉逆流而上总会遭到命运的报复。或许我们仍旧需要那一堆模板代码来强制一些标准。或许我们仍旧需要一个有明确思想的框架。或许我们仍旧需要一个清晰定义的状态树。

如果我们想要的是一个看上去像 Redux 但是和 MobX 一样方便的工具呢？

如果是这样，来看看 **[MobX State Tree](https://github.com/mobxjs/mobx-state-tree)** 吧。

通过 MST，我们通过一个专门的 API 来定义状态树，并且是不可修改的，允许你回滚，序列化或者再组合，以及所有你希望一个有明确思想的状态管理库所拥有的东西。

多说无用，来看代码！

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

与其让你在状态管理上为所欲为，MST 通过要求你用它的规定的方式定义状态树。有人可能回想，这就是有了链式函数而不是类的 MobX，但是还有更多。这个状态树无法被修改，并且每一次修改都会创建一个新的“**快照**”，从而允许了回滚，序列化，再组合，以及所有你想念的功能。

再来看遗留下来的问题，唯一的低分项是，这对 MobX 来讲仅仅是一个部分可用的方法，这意味着它抛弃了类和装饰器，意味着 [TypeScript 支持只能是尽力而为了。](https://github.com/mobxjs/mobx-state-tree#typescript--mst)

但即便如此，它还是很棒！

好的我们继续来构造整个页面。

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

看到了吧？连接组件还是通过同样的方式，所以花在从 MobX 迁移到 MST 的精力远小于编写 Redux 模板代码。

那为啥我们没一步到底选 MST 呢？

其实，MST 对于我们的具体例子来说有点杀鸡用牛刀了。我们考虑使用它是因为回滚操作是一个**非常**不错的附加功能，但是当我们发现有 [**Delorean**](https://github.com/BrascoJS/delorean) 这么个东西的时候就觉得没必要再费力气迁移了。以后我们可能会遇到 MobX 对付不了的情况，但是因为 MobX 很谦逊随和，即便返回去重新用上 Redux 也变得不再令人头大。

总之，MobX，我们爱你。

愿你一直优秀下去。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
