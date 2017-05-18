> * 原文地址：[Rearchitecting Airbnb’s Frontend](https://medium.com/airbnb-engineering/rearchitecting-airbnbs-frontend-5e213efc24d2)
> * 原文作者：[Adam Neary](https://medium.com/@AdamRNeary)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：

# Airbnb 的前端重构 #

概述：最近，我们重新思考了 Airbnb 代码库中 JavaScript 端的架构。本文将讨论：（1）催生一些变化的产品驱动因素，（2）摆脱遗留的 Rails 解决方案的一些步骤，（3）一些新技术栈的关键性支柱。彩蛋：我们将讨论接下来要做的事。


Airbnb 每天接收超过 7500 万次搜索，这使得搜索页面成为我们流量最高的页面。近十年来，工程师们一直在发展、加强、和优化 Rails 输出页面的方式。

最近，我们转移到了主页以外的垂直页面，[来介绍一些体验和去处](https://www.airbnb.com/new)。作为 web 端新增产品的一部分，我们花时间重新思考了搜索体验本身。

![](https://cdn-images-1.medium.com/max/800/1*VMRwDmHVeYC3YnJhhtKn4Q.gif)

用于一个广泛搜索的路由间的过渡

我们希望用户体验流畅，要去斟酌用户在浏览页面和缩小搜索范围时遇到的内容，而不是从 [www.airbnb.com](http://www.airbnb.com) 着陆页导航，（1）访问一个搜索结果页，（2）访问一个单一列表页，（3）访问预订流程，（4）**每个页面都由 Rails 单独传送**。

![](https://cdn-images-1.medium.com/max/800/1*epBwi0kxrcW5a6Wv-T4rSg.gif)

设计三种浏览搜索页的状态：新用户，老用户，和营销页。

在标签页之间切换和与列表进行交互应该感到惬意而轻松。事实上，如今没有什么可以阻止我们致力于在中小屏幕上提供与本地应用相符的体验。


![](https://cdn-images-1.medium.com/max/800/1*y_gKoEDVvBvJpGq7hfcr_g.gif)

再标签页之间切换的未来概念，考虑异步加载内容

要开发这种类型的体验，我们需要摆脱传统的页面切换方法，最后我们结束了对我们的前端代码的基本重构。

[Leland Richardson](https://medium.com/@intelligibabble) [最近在 React Conf 大会上发表了关于 React Native 的存在于高访问量 native 应用中的“褐色地带”。 ](https://www.youtube.com/watch?v=tWitQoPgs8w)。这篇文章将会探讨如何在类似的约束下进行强制性升级，不过是在 web 端。如果你遇到类似的情况，希望对你有帮助。

### 从 Rails 之中解脱 ###

Before firing up the barbecue for all the fun [Progressive Web App](https://developers.google.com/web/progressive-web-apps/) work on our roadmap, we needed to separate from Rails (or at least the way we use Rails at Airbnb in delivering standalone pages).

Unfortunately, only a matter of months ago, our search page contained some very old code…like, *Lord of the Rings*, touch-that-at-your-peril old. Fun fact: I once replaced a small [Handlebars](http://handlebarsjs.com/) template backed by a Rails presenter with a simple React component, and suddenly things were breaking in entirely separate parts of the page — even in our API response! Turns out, the presenter was mutating the backing Rails model, which had been impacting all downstream data for years, even when the UI wasn’t being rendered.

In short, we were in this project like Indiana Jones swapping the idol for a bag of sand, and immediately the temple starts collapsing, and we’re running from a boulder.

#### Step 1: Aligning on API Data ####

When Rails is server-rendering your page, you can get away with throwing data at your server-rendered React components any way you like. Controllers, helpers, and presenters can produce data of any shape, and even as you migrate sections of the page to React, each component can consume whatever data it requires.

But once you endeavor to render the route client-side, you need to be able to request the data you need dynamically and in a predetermined shape. In the future, we may crack this problem with something like [GraphQL](http://graphql.org/), but let’s set that aside for now, as it wasn’t an option when this refactor took place. Rather, we chose to align on a “v2” of our API, and we needed all our components to begin consuming that canonical data shape.

If you find yourself in similar waters with a large application, you might find as we did that planning for the migration of existing server-side data plumbing was the easy part. Simply step through any place Rails is rendering a React component, and ensure that data inputs are API shapes. You can further validate compliance with API V2 shapes used as React PropTypes on the client.

The tricky bit for us was working with all the teams who interact with the guest booking flow: our Business Travel, Growth, and Vacation Rentals teams; our China and India market-specific teams, Disaster Recovery…the list goes on, and we needed to reeducate all these folks that even though it was technically possible to pass data directly to the component being rendered (“yes, I understand it’s just an experiment, but…”), *all data* needs to go through the API.

#### Step 2: Non-API Data: Config, Experiments, Phrases, L10n, I18n… ####

There is a separate class of data from what we would think of as API data, and it includes application config, user-specific experiment assignment, internationalization, localization, and similar concerns. Over the years, Airbnb has built up some incredible tooling to support all these functions, but the mechanisms for delivering them to the Frontend were a bit under-baked (or possibly fully-baked when built, before the ground began shifting under foot!).

We use [Hypernova](https://www.npmjs.com/package/hypernova) to server-render React, but before we went deep on this refactor, it was a bit nebulous whether experiment delivery in a React component would blow up during server-rendering or if string translations available on the client would all be reliably available on the server. Critically, if the server and client output don’t match to the bit, the page not only flashes the diff but also re-renders the entire page after load, which is terrible for performance.

Worse yet, we had some magical Rails functions written long ago, for instance `add_bootstrap_data(key, value)`, which could ostensibly be called anywhere in Rails to make data available on the client globally via `BootstrapData.get(key)`(though, again, not necessarily for Hypernova). What began as a helpful utility for a small team became a source of untraceable witchcraft for a large application and team. The “data laundering” crimes became increasingly tricky to unwind, as each team owns a different page or feature, and therefore each team cultivated a different mechanism for loading config, each suiting their unique needs.

Clearly, this was already breaking down, so we converged on a canonical mechanism for bootstrapping non-API data, and we began migrating all apps/pages to this handoff between Rails and React/Hypernova.

```
import React, { PropTypes } from 'react';
import { compose } from 'redux';

import AirbnbUser from '[our internal user management library]';
import BootstrapData from '[our internal bootstrap library]';
import Experiments from '[our internal experiment library]';
import KillSwitch from '[our internal kill switch library]';
import L10n from '[our internal l10n library]';
import ImagePaths from '[our internal CDN pipeline library]';
import withPhrases from '[our internal i18n library]';
import { forbidExtraProps } from '[our internal propTypes library]';

const propTypes = forbidExtraProps({
  behavioralUid: PropTypes.string,
  bootstrapData: PropTypes.object,
  experimentConfig: PropTypes.object,
  i18nInit: PropTypes.object,
  images: PropTypes.object,
  killSwitches: PropTypes.objectOf(PropTypes.bool),
  phrases: PropTypes.object,
  userAttributes: PropTypes.object,
});

const defaultProps = {
  behavioralUid: null,
  bootstrapData: {},
  experimentConfig: {},
  i18nInit: null,
  images: {},
  killSwitches: {},
  phrases: {},
  userAttributes: null,
};

function withHypernovaBootstrap(App) {
  class HypernovaBootstrap extends React.Component {
    constructor(props) {
      super(props);

      const {
        behavioralUid,
        bootstrapData,
        experimentConfig,
        i18nInit,
        images,
        killSwitches,
        userAttributes,
      } = props;

      // clear out bootstrap data on the server to avoid leaking data
      if (!global.document) {
        BootstrapData.clear();
      }
      BootstrapData.extend(bootstrapData);
      ImagePaths.extend(images);

      // It is not safe to call L10n.init with empty object in tests
      if (i18nInit) {
        L10n.init(i18nInit);
      }

      if (userAttributes) {
        AirbnbUser.setCurrent(userAttributes);
      }

      if (userAttributes && behavioralUid) {
        Experiments.initializeGlobalConfiguration({
          experiments: experimentConfig,
          userId: userAttributes.id,
          visitorId: behavioralUid,
        });
      } else {
        Experiments.setExperiments(experimentConfig);
      }

      KillSwitches.extend(killSwitches);
    }

    render() {
      // Ideally, we only want to pass through bootstrapData. If you have redux or alt data from
      // the server to bootstrap, you can actually pass that data as a key in bootstrapData.
      //
      // Other props are consumed and not passed to the app.
      return <App bootstrapData={this.props.bootstrapData} />;
    }
  }

  Bootstrap.propTypes = propTypes;
  Bootstrap.defaultProps = defaultProps;
  const wrappedComponentName = App.displayName || App.name || 'Component';
  Bootstrap.displayName = `withHypernovaBootstrap(${wrappedComponentName})`;

  return Bootstrap;
}

export default compose(withPhrases, withHypernovaBootstrap);
```

A canonical higher order component for bootstrapping non-API data

This higher order component does two very important things:

1. It receives a canonical shape of bootstrap data as a Plain Old JavaScript Object, and initializes all the supporting tooling correctly both for server-rendering and client-rendering identically.
2. It swallows everything except `bootstrapData`, another simple object which we expect `<App>`to load into Redux to be used by children as needed (in place of `BootstrapData.get`).

In a single shot, we eliminated `add_bootstrap_data` and prevented engineers from passing arbitrary keys through to top level React components. Order was restored to the shire, and before long we were navigating to routes dynamically in the client and rendering content of material complexity without Rails to prop it up (pun intended).

### Super-Charging the Frontend ###

Server rework in hand, we now turn our gaze to the client.

#### The Lazy-Loaded Single Page App ####

Gone are the days, friends, of the monster Single Page App (SPA) with a gruesome loading spinner on initialization. This dreaded loading spinner was the objection many folks raised when we pitched the idea of client-side routing with React Router.

![](https://cdn-images-1.medium.com/max/800/1*O2fK16vfyWaDT-IR61drPw.png)

Lazy loading of route bundles in the Chrome Timeline

But if you look above, you’ll see the impact of [code-splitting](https://webpack.github.io/docs/code-splitting.html) and [lazy-loading](https://webpack.js.org/guides/lazy-load-react/) bundles by route. In essence, we server render the page and deliver just the bare minimum JavaScript required to make it interactive in the browser, then we begin proactively downloading the rest when the browser is idle.

On the Rails side, we have one controller for all routes delivered via the SPA. Each action is simply responsible for (1) making whatever API request the client would have made on client-side navigation, then (2) bootstrapping that data to Hypernova along with config. We went from thousands of lines of Ruby code per action (between the controller, helpers, and presenters) down to ~20–30 lines. Yahtzee.

But it’s not just code that is noticeably different…

![](https://cdn-images-1.medium.com/max/800/1*EpKNHdS4Xzl9fRdGekUgEA.gif)

Side-by-side comparison fetching Homes for Tokyo: Legacy page load vs client-side routing (4–5x difference)

…now transitions between routes are smooth as butter and a step change (~5x) faster, and we can break ground on the animations featured at the beginning of this post.

#### AsyncComponent ####

Prior to React, we would render an entire page at a time, and this practice carried over into our early React days. But we use an AsyncComponent similar to [this](https://medium.com/@thejameskyle/react-loadable-2674c59de178) as a way to load sections of the component hierarchy after mount.

```
export default class AsyncComponent extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      Component: null,
    };
  }

  componentDidMount() {
    this.props.loader().then((Component) => {
      this.setState({ Component });
    });
  }

  render() {
    const { Component } = this.state;
    // `loader` prop unused. It is extracted so we don't pass it down to wrapped component
    // eslint-disable-next-line no-unused-vars
    const { renderPlaceholder, placeholderHeight, loader, ...rest } = this.props;
    if (Component) {
      return <Component {...rest} />;
    }

    return renderPlaceholder ?
      renderPlaceholder() :
      <WrappedPlaceholder height={placeholderHeight} />;
  }
}


AsyncComponent.propTypes = {
  // specifically loader is a function that returns a promise. The promise
  // should resolve to a renderable React component.
  loader: PropTypes.func.isRequired,
  placeholderHeight: PropTypes.number,
  renderPlaceholder: PropTypes.func,
};
```

This is particularly useful for heavy elements that aren’t initially visible, like Modals and Panels. Our explicit goal is to ship precisely the JavaScript required to initially render the visible portion of the page and make it interactive, not one line more. This has also meant that if, for example, teams want to use D3 for a chart in a modal on a page that doesn’t otherwise use D3, they can weigh the “cost” of downloading that library as part of their modal code in isolation from the rest of the page.

Best of all, it is this simple to use anywhere it is needed:

```
import React from 'react';
import AsyncComponent from '../../../components/AsyncComponent';
import scheduleAsyncLoad from '../../../utils/scheduleAsyncLoad';

function mapLoader() {
  return new Promise((resolve) => {
    if (process.env.LAZY_LOAD) {
      return airPORT('./Map', 'HomesSearchMap')
         .then(x => x.default || x);
    }
  });
}

export function scheduleMapLoad() {
 scheduleAsyncLoad(searchResultsMapLoader);
}

export default function MapAsync(props) {
  return <AsyncComponent loader={mapLoader} {...props} />;
}
view raw
```

Here we can simply swap out the synchronous version of our map for an async version, which is particularly useful on small breakpoint, where the map is displayed via user interaction with a button. Since most of these users are on phones, getting them to interactive before worrying about Google Maps comes with a tasty boost in page load time.

Also, note the `scheduleAsyncLoad()` utility, which requests the bundle in advance of user interaction. Since the map is so frequently used, we don’t need to wait for user interaction to request it. Instead, we can enqueue it when you get to the Homes Search route. If the user does request it prior to download, they see a reasonable `<Loader />` until the component is available. No sweat.

The final benefit of this approach is that `HomesSearch_Map` becomes a named bundle that the browser can cache. As we disaggregate larger route-based bundles, the slowly-changing sections of the app remain untouched across updates, further saving JavaScript download time.

#### Building Accessibility into our Design Language #### 

Doubtless it warrants a dedicated post, but we have begun building our internal component library with Accessibility enforced as a hard constraint. In the coming months, we will have replaced all UI across the guest flow that is incompatible with screen readers.

```
import React, { PropTypes } from 'react';

import { forbidExtraProps } from 'airbnb-prop-types';

import CheckBox from '../CheckBox';
import FlexBar from '../FlexBar';
import Label from '../Label';
import HideAt from '../HideAt';
import ShowAt from '../ShowAt';
import Spacing from '../Spacing';
import Text from '../Text';
import CheckBoxOnly from '../../private/CheckBoxOnly';
import toggleArrayItem from '../../utils/toggleArrayItem';

import ROOM_TYPES from '../../constants/roomTypes';

const propTypes = forbidExtraProps({
  id: PropTypes.string.isRequired,
  roomTypes: PropTypes.arrayOf(PropTypes.oneOf(ROOM_TYPES.map(roomType => roomType.filterKey))),
  onUpdate: PropTypes.func,
});

const defaultProps = {
  roomTypes: [],
  onUpdate() {},
};

export default function RoomTypeFilter({ id, roomTypes, onUpdate }) {
  return (
    <div>
      {ROOM_TYPES.map(({ id: roomTypeId, filterKey, iconClass: IconClass, title, subtitle }) => {
        const inputId = `${id}-${roomTypeId}-Checkbox`;
        const titleId = `${id}-${roomTypeId}-title`;
        const subtitleId = `${id}-${roomTypeId}-subtitle`;
        const selected = roomTypes.includes(filterKey);
        const checkbox = (
          <Spacing top={0.5} right={1}>
            <CheckBoxOnly
              id={inputId}
              describedById={subtitleId}
              name={`${roomTypeId}-only`}
              checked={selected}
              onChange={() => onUpdate({ roomTypes: toggleArrayItem(roomTypes, filterKey) })}
            />
          </Spacing>
        );
        return (
          <div key={roomTypeId}>
            <ShowAt breakpoint="mediumAndAbove">
              <Label htmlFor={inputId}>
                <FlexBar align="top" before={checkbox} after={<IconClass size={28} />}>
                  <Spacing right={2}>
                    <div id={titleId}>
                      <Text light>{title}</Text>
                    </div>
                    <div id={subtitleId}>
                      <Text small light>{subtitle}</Text>
                    </div>
                  </Spacing>
                </FlexBar>
              </Label>
            </ShowAt>
            <HideAt breakpoint="mediumAndAbove">
              <Spacing vertical={2}>
                <CheckBox
                  id={roomTypeId}
                  name={roomTypeId}
                  checked={selected}
                  label={title}
                  onChange={() => onUpdate({ roomTypes: toggleArrayItem(roomTypes, filterKey) })}
                  subtitle={subtitle}
                />
              </Spacing>
            </HideAt>
          </div>
        );
      })}
    </div>
  );
}
RoomTypeFilter.propTypes = propTypes;
RoomTypeFilter.defaultProps = defaultProps;
```

An example of building accessibility into our product through our design language system

The UI is rich enough that we want to associate a CheckBox not only with a title, but also a subtitle using `aria-describedby`. To achieve this requires a unique identifier in the DOM, which means enforcing a required ID as a prop that any calling parents need to provide. These are the types of hard constraints the UI can impose to ensure that if a component is used in the product, it is delivered with accessibility built in.

The code above also demonstrates our responsive utilities HideAt and ShowAt, which allow us to dramatically alter what the user experiences at different screen sizes without having to hide and show using CSS. This leads to much leaner pages.

#### Getting Surgical and Philosophical about State ####

No Frontend post would be complete without touching on the debate about how to handle app state.

We use Redux for all API data and “globals” like authentication state and experiment configurations. Personally, I like [redux-pack](https://github.com/lelandrichardson/redux-pack) for async. Your mileage may vary.

However, with all the complexity on the page—particularly around Search—it doesn’t work to use Redux for low-level user interactions like form elements. We found that no matter how we optimized, the Redux loop was going to make typing in inputs feel inadequately responsive.

![](https://cdn-images-1.medium.com/max/600/1*12LgecpKz8HA2e2evkYacw.png)

Our Room Type Filter (code featured above)

So we use component local state for everything the user does up until it triggers a route changes or a network interaction, and we haven’t had any problems.

At the same time, I like the feel of a Redux container component, and we found that even with local state, we could build Higher Order Components that could be shared. A great example is with our filters. Search for [homes in Detroit](https://www.airbnb.com/s/Detroit--MI--United-States/homes), and you’ll find a few different panels on the page, each operating independently, that can modify your search. Across various breakpoints, there are actually dozens of components that need to know the currently-applied search filters and how to update them, both temporarily during user interaction and officially once accepted by the user.

```
import React, { PropTypes } from 'react';
import { connect } from 'react-redux';

import SearchFiltersShape from '../../shapes/SearchFiltersShape';
import { isDirty } from '../utils/SearchFiltersUtils';

function mapStateToProps({ exploreTab }) {
  const {
    responseFilters,
  } = exploreTab;

  return {
    responseFilters,
  };
}

export const withFiltersPropTypes = {
  stagedFilters: SearchFiltersShape.isRequired,
  responseFilters: SearchFiltersShape.isRequired,
  updateFilters: PropTypes.func.isRequired,
  clearFilters: PropTypes.func.isRequired,
};

export const withFiltersDefaultProps = {
  stagedFilters: {},
  responseFilters: {},
  updateFilters() {},
  clearFilters() {},
};

export default function withFilters(WrappedComponent) {
  class WithFiltersHOC extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
        stagedFilters: props.responseFilters,
      };
    }

    componentWillReceiveProps(nextProps) {
      if (isDirty(nextProps.responseFilters, this.props.responseFilters)) {
        this.setState({ stagedFilters: nextProps.responseFilters });
      }
    }

    render() {
      const { responseFilters } = this.props;
      const { stagedFilters } = this.state;
      return (
        <WrappedComponent
          {...this.props}
          stagedFilters={stagedFilters}
          updateFilters={({ updateObj, keysToRemove }, callback) => {
            const newStagedFilters = omit({ ...stagedFilters, ...updateObj }, keysToRemove);
            this.setState({
              stagedFilters: newStagedFilters,
            }, () => {
              if (callback) {
                // setState callback can be called before withFilter state
                // propagates to child props.
                callback(newStagedFilters);
              }
            });
          }}
          clearFilters={() => {
            this.setState({
              stagedFilters: responseFilters,
            });
          }}
        />
      );
    }
  }

  const wrappedComponentName = WrappedComponent.displayName
    || WrappedComponent.name
    || 'Component';

  WithFiltersHOC.WrappedComponent = WrappedComponent;
  WithFiltersHOC.displayName = `withFilters(${wrappedComponentName})`;
  if (WrappedComponent.propTypes) {
    WithFiltersHOC.propTypes = {
      ...omit(WrappedComponent.propTypes, 'stagedFilters', 'updateFilters', 'clearFilters'),
      responseFilters: SearchFiltersShape,
    };
  }
  if (WrappedComponent.defaultProps) {
    WithFiltersHOC.defaultProps = { ...WrappedComponent.defaultProps };
  }

  return connect(mapStateToProps)(WithFiltersHOC);
}
```

Here we have a neat trick. Every component that needs to interact with filters can be wrapped with this HOC, and you’re done. It even comes with prop types. Each component wires into the *responseFilters* (those associated with the currently-displayed results) from Redux but keeps a local stagedFilters object available for modification.

By tackling state this way, interacting with our Price Slider has no impact on the rest of the page, so performance is great. But all filters panels are implemented with the same function signatures, so development is simple.

### What’s Next? ###

Now that the grizzly legwork of catching the Frontend up with the present is largely in hand, we can turn our attention to the future.

- [AMP](https://www.ampproject.org/) versions of all pages in the core booking flow will lead to sub-second (in some cases) *Time To Interactive* from Google search on mobile web, and many of the the changes required to get there will drive dramatic improvements in P50/P90/P95 cold load times across mobile web and desktop web alike.
- [PWA](https://developers.google.com/web/progressive-web-apps/) functionality will lead to sub-second (in some cases) *Time To Interactive* for returning visitors and will open the door to offline-first functionality so very critical to users with flaky connections.
- Dropping the final hammer on legacy tech/frameworks will cut bundle sizes in half. It’s not flashy work, but finally ripping out jQuery, Alt, Bootstrap, Underscore, and all external CSS requests (they block rendering, and 97% of the rules are unused!) will streamline not only the code we ship, but also the footprint of what new hires need to learn as they ramp up.
- Finally, the yeoman’s work of manually bird-dogging rendering bottlenecks, async-loading code not visible at initial render, avoiding unnecessary re-renders, and reducing the cost of re-renders. These improvements are the difference between a clunky feeling app and a well-oiled machine.

Tune in next time as we chase down these opportunities. Since so many of the wins will have immediate quantitative impact, we will try to capture some of the specific wins in subsequent posts.

*Naturally, if you enjoyed reading this and thought this was an interesting challenge, we are always looking for talented, curious people to [join the team](https://www.airbnb.com/careers/departments/engineering) . Or, if you just want to talk shop, hit me up on twitter any time [@adamrneary](https://twitter.com/AdamRNeary)*

Finally, huge props to [Salih Abdul-Karim](https://twitter.com/therealsalih) and [Hugo Ahlberg](https://twitter.com/hugoahlberg) , the experience designers behind the face-melting animations I still can’t stop ogling. The list of many engineers deserving kudos for their role in this effort is indescribably long but most certainly includes Nick Sorrentino, [Joe Lencioni](https://medium.com/@lencioni) , [Michael Landau](https://medium.com/@mikeland86), Jack Zhang, Walker Henderson, and Nico Moschopoulos.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
