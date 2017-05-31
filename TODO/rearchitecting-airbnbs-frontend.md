> * 原文地址：[Rearchitecting Airbnb’s Frontend](https://medium.com/airbnb-engineering/rearchitecting-airbnbs-frontend-5e213efc24d2)
> * 原文作者：[Adam Neary](https://medium.com/@AdamRNeary)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：[Dalston Xu](https://github.com/xunge0613)、[yzgyyang](https://github.com/yzgyyang)

# Airbnb 的前端重构 #

概述：最近，我们重新思考了 Airbnb 代码库中 JavaScript 部分的架构。本文将讨论：（1）催生一些变化的产品驱动因素，（2）我们如何一步步摆脱遗留的 Rails 解决方案，（3）一些新技术栈的关键性支柱。彩蛋：我们将透露一下未来的发展方向。


Airbnb 每天处理超过 7500 万次搜索，这使得搜索页面成为我们流量最高的页面。近十年来，工程师们一直在发展、加强和优化 Rails 输出页面的方式。

最近，我们转移到了主页以外的垂直页面，[来介绍一些体验和去处](https://www.airbnb.com/new)。作为 web 端新增产品的一部分，我们花时间重新思考了搜索体验本身。

![](https://cdn-images-1.medium.com/max/800/1*VMRwDmHVeYC3YnJhhtKn4Q.gif)

在一个用于宽泛搜索的路由之间过渡

为了使用户体验流畅，我们选择调整用户浏览页面和缩小搜索范围的交互方式，而不再采用以前那样的多页交互方式：（1）首先访问着陆页 [www.airbnb.com](http://www.airbnb.com)，（2）接着进入搜索结果页，（3）随后访问某个列表页，（4）最后进入预订流程。**每个页面都是一个独立的 Rails 页面**。

![](https://cdn-images-1.medium.com/max/800/1*epBwi0kxrcW5a6Wv-T4rSg.gif)

设计三种浏览搜索页的状态：新用户、老用户和营销页。

在标签页之间切换和与列表进行交互应该感到惬意而轻松。事实上，如今没有什么可以阻止我们在中小屏幕上提供与原生应用一致的体验。


![](https://cdn-images-1.medium.com/max/800/1*y_gKoEDVvBvJpGq7hfcr_g.gif)

会考虑将来在切换标签页时，异步加载相应内容

为了实现这种体验，我们需要摆脱传统的页面切换方法，最终我们只好全面重构了前端代码。

[Leland Richardson](https://medium.com/@intelligibabble) [最近在 React Conf 大会上发表了演讲，称 React Native 如今正处于和现有的高访问量原生应用共存的“褐色地带”](https://www.youtube.com/watch?v=tWitQoPgs8w)这篇文章将会探讨如何在类似的限制条件下进行 web 端重构。希望你在遇到类似情况时，这篇文章对你有所帮助。

### 从 Rails 之中解脱 ###

在我们的烧烤开火之前，因为我们的线路图上存在所有有趣的[渐进式 web 应用](https://developers.google.com/web/progressive-web-apps/)（WPA），我们需要从 Rails 中解脱出来（或者至少在 Airbnb 用 Rails 提供单独页面的这种方式）。

不幸的是，就在几个月前，我们的搜索页还包含一些非常老旧的代码，像指环王一样，触碰它就要小心自负后果。有趣的事实：我曾尝试用一个简单的 React 组件来替换基于 Rails presenter 的 [Handlebars](http://handlebarsjs.com/) 模板，突然很多完全不相关的部分都崩掉了 —— 甚至 API 响应都出了问题。原来，presenter 改变了底层 Rails 模型，多年来即使在 UI 没有渲染的时候，它也影响着所有的下游数据。

简而言之，我们在这个项目中，就好像 Indiana Jone 用一袋沙子替换了宝物，突然间庙宇开始崩塌，我们正在从石块中奔跑。



#### 第 1 步： 调整 API 数据 ####

当使用 Rails 在服务器端渲染页面时，你可以用任何你喜欢的方式把数据丢给服务器端的 React 组件。Controllers、helpers 和 presenters 能生成任何形式的数据，甚至当你把部分页面迁移到 React 时，每个组件都能处理它所需的任何数据。

但一旦你想渲染客户端路由，你需要能够以预定的形式动态请求所需的数据。将来我们可能用类似 [GraphQL](http://graphql.org/) 的东西解决这个问题，但是现在暂且把它放到一边吧，因为这件事和重构代码没太大关系。相反，我们选择在我们的 API 的 “v2” 上进行调整，我们需要我们所有的组件来开始处理规范的数据格式。

如果你自己和我们处在类似的情况中，在维护一个大型的应用，你可能发现我们像我们这样做，规划迁移现有的服务器端数据管道是很容易的。只需在任何地方用 Rails 渲染一个 React 组件，并确保数据输入是 API 所规定的类型。你可以用客户端的 React PropTypes 来进一步验证数据类型是否与 API v2 一致。

对我们来说棘手的问题是和那些参与客户预定流程交互的团队协作：商业旅游、发展、度假租赁团队；中国和印度市场团队，灾难恢复团队等等，我们需要重新培训所有这些人，即使在技术上可以将数据直接传递到正在呈现的组件上("是的，我明白，这仅仅是一种实验，但是...")，**所有的数据**都要通过 API。

#### 第 2 步： 非 API 数据: 配置、试验、惯用语、本地化、国际化… ####

有一类独特的数据和我们设想的 API 化的数据不同，包括应用配置、用户试验任务、国际化、本地化等等类似的问题。近年来，Airbnb 已经建立了一套很棒的工具来支持这些功能，但是把这些数据传送到前端的机制就不那么令人愉快了（在革命开始之前，或许就已经很蹩脚了！）。

我们使用 [Hypernova](https://www.npmjs.com/package/hypernova)  在服务端渲染渲染 React，但是在我们此次重构深入之前，无论服务端渲染时 React 组件中的试验交付会不会爆发或者客户端上提供的字符串转换是否都可以在服务器上可靠地使用，这些都还有点模糊。最重要的是，如果服务器和客户端输出匹配不到位，页面不仅会不断闪烁刷新 diff，还会在加载后重新渲染整个页面，这对于性能来说很可怕。

更糟糕的是，我们很久以前写过一些神奇的 Rails 功能，比如 `add_bootstrap_data(key, value)` 表面上可以在 Rails 中的任何地方调用，通过 `BootstrapData.get(key)` 使数据在客户端的全局可用（再次强调，对 Hypernova 来说已经不必要了）。曾经这些小工具对小团队来说很实用，但如今随着团队规模扩大，应用规模扩张，这些小工具反而变成了累赘。由于每个团队拥有不同的页面或功能，因此“数据清洗”变得越来越棘手，因此每个团队都会培养出一种不同的加载配置的机制，以满足其独特需求。

显然， 这套机制已经崩溃了，所以我们融合了一个用于引导非 API 数据的规范机制，我们开始将所有应用程序和页面迁移到 Rails 和 React/Hypernova 之间的这种切换。

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

      // 清除服务器上的引导数据，以避免泄露数据
      if (!global.document) {
        BootstrapData.clear();
      }
      BootstrapData.extend(bootstrapData);
      ImagePaths.extend(images);

      // 在测试中用空对象调用 L10n.init 是不安全的
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
      // 理想情况下，我们只想通过 bootstrapData 传输数据 
      // 如果你使用 redux 或从服务端转换数据到 bootstrap，你其实可以将数据当作一个键值(key)传入 bootstrapData，其他属性被使用但是不会传入 app 。
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

用于引导非 API 数据规范的更高阶的组件


这个非常高阶的组件做了两件更重要的事情：

1. 它接收一个引导数据作为普通的旧对象的规范形式，并且正确地初始化所有支持的工具，用于服务器渲染和客户端渲染。
2. 它吞噬除了 `bootstrapData` 的一切 ，它是另一个简单的对象，必要时把 `<App>` 组件传入 Redux 作为 children 使用。

单纯来看，我们删除了 `add_bootstrap_data`，并阻止工程师将任意键传递到顶级的 React 组件。秩序被重新恢复，以前我们在客户端中动态地导航到路由，并且渲染材料复杂的 content，而不需要Rails来支持它。

### 进击的前端 ###

服务端的重构已经有了头绪，现在我们把目光转向客户端。

#### 懒加载的单页面应用 ####

那段日子已经过去了，朋友们，初始化时带着可怕 loading 的巨型单页面应用（SPA）已经不复存在了。当我们提出用 React Router 做客户端路由的方案时，可怕的 loading 是很多人提出拒绝的理由。

![](https://cdn-images-1.medium.com/max/800/1*O2fK16vfyWaDT-IR61drPw.png)

在 Chrome Timeline 中 route 包的懒加载

但是，再看看上文，你就会发现路由对[代码分割](https://webpack.github.io/docs/code-splitting.html)和[延迟加载](https://webpack.js.org/guides/lazy-load-react/)进行捆绑造成的影响。实质上，我们在服务端渲染页面并且仅仅传输最低限度的一部分用于在浏览器端交互的 Javascript 代码，然后我们利用浏览器的空余时间主动下载其余部分。

在 Rails 端，我们有一个 controller 用于通过 SPA 交付的所有路由。每一个 action 只负责：（1）触发客户端导航中的一切请求，（2）将数据和配置引导到 Hypernova。我们把每个 action （controller、helpers 和 presenters 之间）都有上千行的 Ruby 代码缩减到 20-30 行。实力碾压。

但这不仅仅是代码的不同...

![](https://cdn-images-1.medium.com/max/800/1*EpKNHdS4Xzl9fRdGekUgEA.gif)

两种方式加载东京主页的对比（4-5 倍的差距）

...现在页面间的过渡像奶油般顺滑，并且这一步大幅提升了速度（约 5 倍）。而且我们我们可以实现文章开头的那张动画特性。

#### 异步组件 ####

在（采用）React 之前，我们需要一次渲染整个页面，我们以前的 React 都是这么做的。但现在我们使用异步组件，类似[这种](https://medium.com/@thejameskyle/react-loadable-2674c59de178)方式， 挂载（mount）以后加载组件层次结构的部分。

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
    // `loader` 属性没有被使用。 它被提取，所以我们不会将其传递给包装的组件
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
  // 注意 loader 是返回一个 promise 的函数。
  // 这个 promise 应该处理一个可渲染的组件。
  loader: PropTypes.func.isRequired,
  placeholderHeight: PropTypes.number,
  renderPlaceholder: PropTypes.func,
};
```

这对于最初不可见的重量级元素尤其有用，比如 Modals 和 Panels。我们的明确目标是一行也不多地提供初始化页面可见部分所需的 JavaScript，并使其可交互。这也意味着如果，比方说团队想使用 D3 用于页面弹窗的一个图表，而其他部分不使用 D3，这时候他们就可以权衡一下下载仓库的代码，可以把他们的弹窗代码和其他代码隔离出来。

最重要的是，它可以简单地在任何需要的地方使用：

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

这里我们可以简单地把我们的同步版本的地图换成异步版本，这在小断点上特别有用，用户通过点击按钮显示地图。考虑到大多数用户用手机，在担心 Google 地图之前，让他们进入互动会缩短加载时的焦虑感。


另外，注意 `scheduleAsyncLoad()` 组件，在用户交互之前就要请求包。考虑到地图如此频繁地被使用，我们不需要等待用户交互才去请求它。而是在用户进入主页和搜索页的时候就把它加入队列，如果用户在下载完成之前就请求了它，他们会看到一个 `<Loader />` 直到组件可用。没毛病。

这种方法的最后一个好处是 `HomesSearch_Map` 成为浏览器可以缓存的命名包。当我们分解较大的基于路由的捆绑包时，应用程序中 slowly-changing 的部分在更新时保持不变，从而进一步节省了 JavaScript 下载时间。

#### 构建无障碍的设计语言 ####

毫无疑问，它保证的是一个专有的需求，但是我们已经开始构建内部组件库，其中辅助功能被强制为一个严格的约束。在接下来的几个月中，我们将替换所有与屏幕阅读器不兼容的横跨客流的 UI 界面。

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

通过我们的设计语言系统将无障碍设计加入到产品的例子

这个 UI 非常丰富，我们不仅希望将 CheckBox 与 title 相关联，还希望与使用了 `aria-describedby` 的 subtitle 关联。为了实现这一点，需要 DOM 中唯一的标识符，这意味着强制关联一个必须的 ID 作为任何调用方需要提供的属性。如果一个组件被用于生产，这些是 UI 是可以强制约束类型的，它提供内置的可访问性。

上面的代码也演示了我们的响应式实体 HideAt 和 ShowAt，它使我们能够大幅度地改变用户在不同屏幕尺寸下的体验，而无需使用 CSS 控制隐藏和显示。这造就了更精简的页面。

#### 关于状态的“外科”和“哲学” ####

不涉及关于如何处理应用程序状态的争论的前端文章不是完整的前端文章。

我们使用 Redux 来处理所有的 API 数据和“全局”数据比如认证状态和体验配置。个人来讲我喜欢 [redux-pack](https://github.com/lelandrichardson/redux-pack) 处理异步，你会发现新大陆。

然而，当遇到页面上所有的复杂性 —— 特别是围绕搜索的 —— 对于一些像表单元素这样低级的用户交互使用 redux 就没那么好用了。我们发现无论如何优化，Redux 循环依然会造成输入体验的卡顿。

![](https://cdn-images-1.medium.com/max/600/1*12LgecpKz8HA2e2evkYacw.png)

我们的房间类型筛选器 (代码在上面)

所以对于用户的所有操作我们使用组件的本地状态，除非触发路由变化或者网络请求才使用 Redux，并且我们没再遇到什么麻烦。

同时，我喜欢 Redux container 组件的那种感觉，并且我们即使带有本地状态，我们依然可以构建可以共享的高阶组件。一个伟大的例子就是我们的筛选功能。搜索[在底特律的家](https://www.airbnb.com/s/Detroit--MI--United-States/homes)，你会在页面上看见几个不同的面板，每一个都可以独立操作，你可以更改你的搜索条件。在不同的断点之间，实际上有几十个组件需要知道当前应用的搜索过滤器以及如何更新它们，在用户交互期间被暂时或正式地被用户接受。

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

这里我们有一个利落的技巧。每一个需要和筛选交互的组件只需被 HOC 包裹起来，就是这么简单。它甚至还有属性类型。每个组件都通过 Redux 连接到 **responseFilters**（与当前显示的结果相关联）,并同时保有一个本地 stagedFilters 状态对象用于更改。

以这种方式处理状态，与我们的价格滑块进行交互对页面的其余部分没有影响，所以表现很好。而且所有过滤器面板都具有相同的功能签名，因此开发也很简单。

### 未来做些什么？ ###

既然现在繁重的前端改造工作已经接近完成，我们可以把目光转向未来。

- [AMP](https://www.ampproject.org/) 核心预订流程中的所有页面的 AMP 版本将会实现亚秒级（某些情况下）在手机 web 上 Google 搜索的 **可交互时间**，通过移动网络和桌面网络，所需的许多更改将在 P50 / P90 / P95 冷负载时间内实现显着改善。
- [PWA](https://developers.google.com/web/progressive-web-apps/) 功能将实现亚秒级（在某些情况下）返回访客的**可交互时间**，并将打开离线优先功能的大门，因此对于具有脆弱网络连接的用户非常关键。
- 下定决心干掉老旧的技术和框架可以使包大小减少一半。这不是华而不实的工作，我们最终翻出 jQuery、Alt、Bootstrap、Underscore 以及所有额外的 CSS 请求（他们使渲染停滞，并且将近 97% 的规则是不会被使用！）不仅精简了我们的代码，还精简了新员工在上升时需要学习的足迹。
- 最后，yeoman 的手动捕捉瓶颈的工作、异步加载代码在初始渲染时不可见、避免不必要的重新渲染、并降低重新渲染的成本，这些改进正是拖拉机和顶级跑车之间的区别。

欢迎下次继续围观我们的成果分享。因为这么多的成果会有一些数量上的冲突，我们将尽量选择一些具体的成果在下篇文章中总结。

**自然，如果你欣赏本文并觉得这是一个有趣的挑战，我们一直在寻找优秀出色的人[加入团队](https://www.airbnb.com/careers/departments/engineering)。如果你只想做一些交流，那么随时可以点击我的 twitter [@adamrneary](https://twitter.com/AdamRNeary)。**

最后，深切地向 [Salih Abdul-Karim](https://twitter.com/therealsalih) 和 [Hugo Ahlberg](https://twitter.com/hugoahlberg) 两位体验设计师致敬，他们的令人动容的动画至今让我目不转睛。许多工程师在他们的领域值得赞美，作出贡献的人数众多，难以一一列出的，但绝对包括 Nick Sorrentino、[Joe Lencioni](https://medium.com/@lencioni)、[Michael Landau](https://medium.com/@mikeland86)、Jack Zhang、Walker Henderson 和 Nico Moschopoulos.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
