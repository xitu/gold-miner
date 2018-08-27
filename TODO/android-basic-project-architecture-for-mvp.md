> * 原文链接: [Android Basic Project Architecture for MVP — mobiwise blog — Medium](https://medium.com/mobiwise-blog/android-basic-project-architecture-for-mvp-72f4b33252d0#.ha8kjbx3w)
* 原文作者 : [MuratCanBur](https://medium.com/@muratcanbur)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [foolishgao](https://github.com/foolishgao)
* 校对者 : [kassadin](https://github.com/kassadin)、[Sausure](https://github.com/Sausure)
* 状态 : 完成

# Android 的一个 MVP 基础项目模板

迄今为止，我阅读了很多有关Android软件开发中结构设计的文章。以我对他们的认识，比较好的方法是实现**MVP(Model View Presenter)**模式，这对Android开发者也是非常重要的。

我在其他开发者的技术博客和项目中学到了一些有用的东西，现在我决定开发一个基本的项目架构来用于实现我们的客户端软件[mobiwise](https://medium.com/u/8d64c93a5e63). 我选择了MVP模式作为项目架构，让我们开始了解一下。


![](https://cdn-images-1.medium.com/max/800/1*OX-xyuKXFOyQSdUKNZRGVg.jpeg)


#### 什么是MVP?

你能在网上找到很多MVP相关解释和定义，让我来说一下我对MVP的理解。MVP是一种分离**展示层和业务逻辑层的模式，使两者独立存在**的模式。我相信分离这些部分的代码的过程属实令人厌烦。

为了这个实践，我们应该在项目中提供出各个抽象层。

### 层

为了使项目易于理解，我们首先做的是抽象出各个层面。这对开发测试和维护代码都非常重要。在任何Android项目中为了开发需要都会抽象出很多层，这里我说下重点！

项目中特有的业务逻辑部分，这里称之为**Domain layer**, 数据模型、网络相关、数据库操作部分，这里称之为**Model layer**，只有Android特有的部分，称之为**Presentation or App Layer。** 最后一个，也很重要，用于第三方library或者项目中共用的、基础工具类等，称之 **Common Layer.**

我觉得，抽象出这么多层，在开始阶段，似乎难以理解和实现。


![](https://cdn-images-1.medium.com/max/800/1*fpnNs0T_yWslrfkrQrlv1Q.jpeg)


#### Domain Layer

这一层是完全独立的因为它指定了**特定项目**的业务逻辑。就我在网上查阅过的资料，这一层有个差不多的实现方式。根据项目的命名规则，定义出项目业务逻辑的**用例接口**，在创建出**用例控制实现类**来实现这个接口做相对应的工作。

让我们试想一个新闻应用程序，并试着定义个基本的业务**用例**场景。我定义了一个基本的业务用例接口，一个很简单的场景用例接口。

```java
public interface GetPopularTitlesUsecase extends Usecase {

  void getPopularTitles();

  void onPopularTitlesReceived(ArrayList<Title> title);

  void sendToPresenter();
}
```

定义好接口，开始写class来实现**GetPopularTitlesUsecase**。下面是个基本的实现类。

```java
public class GetPopularTitlesUsecaseController implements GetPopularTitlesUsecase {


  private List<Title> titleList;

  public GetPopularTitlesUsecaseController() {
    BusUtils.getRestBusInstance().register(this);
  }

  @Override
  public void getPopularTitles() {
    SyncService.start();
  }

  @Subscribe
  @Override
  public void onPopularTitlesReceived(ArrayList<Title> titleList) {
    this.titleList = titleList;
    sendToPresenter();
  }

  @Override
  public void sendToPresenter() {
    BusUtils.getUIBusInstance().post(titleList);
    BusUtils.getRestBusInstance().unregister(this);
  }

  @Override
  public void execute() {
    getPopularTitles();
  }
}
```


#### Model Layer

开发者都知道的，在项目中必须有一个Model Layer来处理**网络请求和数据库存取**相关的工作。我一般把这些部分的代码分成三个包，分别叫entity, rest和database。对于大部分项目分成这样已经足够。也许你需要创建有别于数据层的业务相关层。比如，你想展示用户的全称，就不应该通过在数据层中获取用户的姓和用户的名再通过指定的adapter类或者view类等方式做一个拼接处理，这很笨拙，此时应该定义业务层来实现这个操作。定义两个不同的数据层很笨拙。但是仍然重要。

#### Presentation or App Layer

这是最基本和熟知的抽象层，指代了Android程序开发中特有组件的部分。

##View

View在MVP中代表UI组件部分。

```java
public interface PopularTitlesView extends MVPView {

  void showTitles(List<Title> titleList);

  void showLoading();

  void hideLoading();
}
```


#### Presenter

Presenter在MVP中类似于连接**view和model**的桥梁。常用的实现方式，我们需要创建model接口来处理特定的场景。

```java
public interface RadioListPresenter extends Presenter {
  void loadRadioList();

  void onRadioListLoaded(RadioWrapper radioWrapper);
}
```
创建完简单的RadioListPresenter接口，我们来实现这个接口。


```java
public class RadioListPresenterImp implements RadioListPresenter {

  RadioListView radioListView;

  GetRadioListUsecase getRadioListUsecase;

  Bus uiBus;

  @Inject
  public RadioListPresenterImp(GetRadioListUsecase getRadioListUsecase, Bus uiBus) {
    this.getRadioListUsecase = getRadioListUsecase;
    this.uiBus = uiBus;
  }

  @Override
  public void loadRadioList() {
    radioListView.showLoading();
    getRadioListUsecase.execute();
  }

  @Subscribe
  @Override
  public void onRadioListLoaded(RadioWrapper radioWrapper) {
    radioListView.onListLoaded(radioWrapper);
    radioListView.dismissLoading();
  }

  @Override
  public void start() {
    uiBus.register(this);
  }

  @Override
  public void stop() {
    uiBus.unregister(this);
  }

  @Override
  public void attachView(MVPView mvpView) {
    radioListView = (RadioListView) mvpView;
  }
}
```


**所有以上这些来自我们代码中的例子，只是一个简单的实现。这些都不绝对完全也不是最好的，不同的项目需要不同的方式来实践，要视情况而定。**

### 如何实践

每一个Activity,Fragment要根据逻辑功能来实现一个View接口，以我项目中的例子来说，RadioListFragment应该实现**RadioListView**接口，覆写相关的方法并让相关的presentar的方法来处理对应逻辑。

```java
public class RadioListFragment extends Fragment implements RadioListView, SwipeRefreshLayout.OnRefreshListener {

  @Inject
  RadioListPresenter radioListPresenter;

  public RadioListFragment() {
  }

  public static RadioListFragment newInstance() {
    RadioListFragment fragment = new RadioListFragment();
    return fragment;
  }

  @Override
  public void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    BusUtil.BUS.register(this);
    initializeInjector();
  }

  @Override
  public void onActivityCreated(@Nullable Bundle savedInstanceState) {
    super.onActivityCreated(savedInstanceState);
    radioListPresenter.loadRadioList();
  }

  private void initializeInjector() {
    RadyolandApp app = (RadyolandApp) getActivity().getApplication();

    DaggerGetRadioListComponent.builder()
        .appComponent(app.getAppComponent())
        .getRadioListModule(new GetRadioListModule())
        .build()
        .inject(this);
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
                           Bundle savedInstanceState) {
    View view = inflater.inflate(R.layout.fragment_radio_list, container, false);
    ButterKnife.bind(this, view);
    BusUtil.BUS.post(new TitleEvent(R.string.radio_list));
    radioListPresenter.start();
    radioListPresenter.attachView(this);
    return view;
  }


  @Override
  public void showLoading() {
    swipeRefresh.setRefreshing(true);
  }

  @Override
  public void dismissLoading() {
    swipeRefresh.setRefreshing(false);
  }

  @Override
  public void onListLoaded(RadioWrapper radioWrapper) {
    radioListAdapter.setRadioList(radioWrapper.radioList);
    radioListAdapter.notifyDataSetChanged();
    DatabaseUtil.saveRadioList(radioWrapper.radioList);
  }

  @Subscribe
  public void RefreshRadioListEvent(RefreshRadioListEvent radioListEvent) {
    radioListPresenter.loadRadioList();
  }

  @Override
  public void onDestroy() {
    super.onDestroy();
    BusUtil.BUS.unregister(this);
  }

  @Override
  public void onRefresh() {
    radioListPresenter.loadRadioList();
  }
```

#### 包组织结构的想法

当我第一次在网上搜索这方面的内容时，我发现很多开发者给每一层都分别创建了不同的modules。这个方法似乎适用于很多开发者，但是我不喜欢。是为什么我没有这么做的原因。我给每个module或者层创建了不同的包，相信这不适用于所有人，只是我的方式，我感觉这样很舒服。

![](http://ww3.sinaimg.cn/large/005SiNxyjw1eymj1ql90mj30cd0lwmyn.jpg)


### 值得一提

最后，我写了Android-base-project项目

[**mobiwiseco/Android-Base-Project** _Android-Base-Project - An Android Base Project which can be example for every Android project._github.com](https://github.com/mobiwiseco/Android-Base-Project "https://github.com/mobiwiseco/Android-Base-Project")

我写了一个适用于很多开发项目的基础项目（不是library,只是一个指导的project）包括基础Fragment,Activity和Retrofit网络层相关类，工具类和常见**Gradle**文件结构。是时候让更多的类基于MVP模式来开发。


### 结论

![](https://cdn-images-1.medium.com/max/800/1*Rt3vsG8LWHB8LPGrhRftAA.gif)

我并不是想推荐给你在Android项目开发中使用的那些libraries，诸如Dagger 2, RxJava等。我只希望一切简单就好，把重点放在项目的结构设计上。

我相信MVP有很多的不同的实现方式，我经常会去学习其他开发者的方式，找出我认为最好的来实践。

重要的一点是我们应该开发一个可以独立于其他libraries、UI层、数据库和网络层的项目。如果你开发的项目基本满足以上，这个项目一定是易于开发，测试和维护的。


**Resources**:

1. [http://saulmm.github.io/2015/02/02/A%20useful%20stack%20on%20android%20%231,%20architecture/](http://saulmm.github.io/2015/02/02/A%20useful%20stack%20on%20android%20%231,%20architecture/)
2. [http://fernandocejas.com/2014/09/03/architecting-android-the-clean-way/](http://fernandocejas.com/2014/09/03/architecting-android-the-clean-way/)
