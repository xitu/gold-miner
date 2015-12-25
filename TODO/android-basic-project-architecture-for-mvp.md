

Nowadays, I read lots of articles about how to create a basic project structure for our Android applications. As far as I understand from them, the main approach is implementing **MVP (Model View Presenter)** pattern which is also important in the development of Android community.

After I learned some useful things from other developers, blog posts and example projects, I decided to create a basic project structure approach so that I can implement it to our client applications for [mobiwise](https://medium.com/u/8d64c93a5e63). I have choosen MVP pattern for main app structure. Let’s start with it and try to understand.


![](https://cdn-images-1.medium.com/max/800/1*OX-xyuKXFOyQSdUKNZRGVg.jpeg)


#### What is MVP?

You can find many explanation and dictionary definition on the internet. Let me tell you what I understand from the definition; MVP is an architectural pattern that allows you to separate **presentation and business logic layers from each other.** I believe keeping separate these layers from each other is kind of pain in the ass!

To present these kind of implementation, we should provide layers across all the application.

### Layers

We should define layers to represent more clear our Android applications. It is so important both for developing stage and maintenance. There are many layers in any android application that fits for project needs. I want to mention important ones here!

One for our business logic in mobile application called **Domain layer**, one for data model for REST, Database connectivity related things called **Model layer**. One for dedicated only to Android part called **Presentation or App Layer.** Last but not least for third party library stuff or common things across the application called **Common Layer.**

I think because there are many layers, In the first time, it looks like kind of hard to understand and implement.


![](https://cdn-images-1.medium.com/max/800/1*fpnNs0T_yWslrfkrQrlv1Q.jpeg)


#### Domain Layer

This layer is completely independent since this represents business logic for **application**. As far as I see on the internet, there is a common implementation way for this layer. According to the naming convention, there are **usecase interfaces** that represent logic of the application, and **usecase controller classes** that implement these interfaces and define the way of working for application.

Let’s try to imagine a newsfeed application and try to define a basic **usecase** scenario. I tried to implement a basic usecase interface. This is really simple interface that tells the app scenario.

```
public interface GetPopularTitlesUsecase extends Usecase {

void getPopularTitles();

void onPopularTitlesReceived(ArrayList

void sendToPresenter();
}
```


After writing an interface, it is time to create a class that implements **GetPopularTitlesUsecase.** Here a basic implementation example class.

```
public class GetPopularTitlesUsecaseController implements GetPopularTitlesUsecase {

  private List

public GetPopularTitlesUsecaseController() {
    BusUtils.getRestBusInstance().register(this);
  }

@Override
  public void getPopularTitles() {
    SyncService.start();
  }

@Subscribe
  @Override
  public void onPopularTitlesReceived(ArrayList

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

As my developer perceptive, there must be a model layer for your application that contains **REST and database connectivity** related works in your project. I always separate three different packages called entity, rest and database. I think this is enough for most of the project. Also you may need to create business model classes that differs from data model classes. For example, if you want to show full name of user, You shouldn’t need to get first name and given name of user from data model classes and make string convention in your adapter or view classes. You should define a business model classes. This is really silly example why you need to create two different model classes. But it still counts.

#### Presentation or App Layer

It is the most basic and common known layer among all. This is the layer that represent Android application itself.

##View
View in MVP represents the UI components.

```
public interface PopularTitlesView extends MVPView {

void showTitles(List

void showLoading();

void hideLoading();
}
```


#### Presenter

Presenter in MVP is a kind of bridge **between view and model**. According to common implementation way, We should create a model interface classes that represent fingerprint of our usecase classes.

```
public interface RadioListPresenter extends Presenter {
  void loadRadioList();

void onRadioListLoaded(RadioWrapper radioWrapper);
}
```


After creating a simple Radio List presenter, it is time to create a class that implements this interface.

```
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


**All these class example from our code base, just a simple example implementation. These are not complete or best case usage. It may differ from one project to another.**

### How to implement

Each Activity, Fragment should implement view interfaces according to the logic that represents. According to my project example, my RadioListFragment should implement **RadioListView.** After implement this interface, You should override methods and put presenter methods related the logic.

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

#### Package Structure ideas

When I first try to search these topics on the internet, I saw many people create different modules for each layer. This idea seems perfect for many developers but not for me. That’s why I don’t create different modules for each layer. I create different packages for each module or layer. I believe in that this is not the base case, but It is my way. I feel more comfortable.





![](http://ww3.sinaimg.cn/large/005SiNxyjw1eymj1ql90mj30cd0lwmyn.jpg)





### Worth to mention;

Lately, I created a project that called Android-base-project

[**mobiwiseco/Android-Base-Project** _Android-Base-Project - An Android Base Project which can be example for every Android project._github.com](https://github.com/mobiwiseco/Android-Base-Project "https://github.com/mobiwiseco/Android-Base-Project")

I want to create a base project (not a library, just a guide project.)that contains base fragment, activity and retrofit classes, Utility classes and common **Gradle** file structure that can fit many of Android project. I think it is time to implement more generic classes based on MVP pattern.

### Conclusion;



![](https://cdn-images-1.medium.com/max/800/1*Rt3vsG8LWHB8LPGrhRftAA.gif)



I didn’t try to mention any of libraries you should use for almost many Android project like Dagger 2, RxJava etc. I just want to keep simple, mainly focus on App structure.

I believe in that there may be a lot of different implementations. I always try to learn from other developers to find the best case and implement it.

The most important idea is here that we want to create a project that is independent from libraries, UI things, database or REST implementation. if we can create a project that contains this kind of app structure, we can have project easy to develop, test and maintain.

**Resources**:

1.  [http://saulmm.github.io/2015/02/02/A%20useful%20stack%20on%20android%20%231,%20architecture/](http://saulmm.github.io/2015/02/02/A%20useful%20stack%20on%20android%20%231,%20architecture/)

2\. [http://fernandocejas.com/2014/09/03/architecting-android-the-clean-way/](http://fernandocejas.com/2014/09/03/architecting-android-the-clean-way/)
