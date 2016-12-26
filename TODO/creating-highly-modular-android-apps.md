> * 原文链接: [Creating Highly Modular Android Apps](https://medium.com/stories-from-eyeem/creating-highly-modular-android-apps-933271fbdb7d#.oez87prl8)
* 原文作者 : [Ronaldo Pace](https://medium.com/@ronaldo.pace?source=post_header_lockup)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :[DeadLion](https://github.com/DeadLion)
* 校对者 :[Graning](https://github.com/Graning), [Kulbear](https://github.com/Kulbear)

# 如何创建高度模块化的 Android 应用

>“单一职责原则规定，每个模块或类应该对软件提供的某单一功能负责。”([en.wikipedia.org/wiki/Single_responsibility_principle](https://en.wikipedia.org/wiki/Single_responsibility_principle))

Android 中构建 UI 的职责通常委派给一个类（比如 Activity、Fragment 或 View/Presenter）。这通常涉及到以下任务：

- 填充 View（xml 布局）
- View 配置（运行时参数、布局管理、适配）
- 数据源连接（DB 或者 数据存储的监听/订阅）
- 加载缓存数据
- 新数据的按需请求分派
- 监听用户事件（tap、scroll）然后响应事件

除此之外，Activity 和 Fragment 通常还会委派一些额外的职责：

- App 导航
- Activity 结果处理
- Google Play 服务连接和交互
- 过渡动画配置

这不是单一职责，当前的处理方式包括了继承或组合，这太复杂了。

![](https://cdn-images-1.medium.com/max/800/1*PYTSQy1jyMgZdKzKAK-ImA.gif)

### 继承地狱

>“当一个对象或类是基于另一个对象或类，这就是继承。它是为了代码重用，并允许原始软件通过公共类和接口单独扩展。这些对象或类的关系，通过继承形成一种层级。”
 ([en.wikipedia.org/wiki/Inheritance_(object-oriented_programming)](https://en.wikipedia.org/wiki/Inheritance_%28object-oriented_programming%29))

对于这种复杂的结构，如 UI 构建，继承能让它很快变成一坨 x。看看下面的模拟案例：

![](https://cdn-images-1.medium.com/max/800/1*TItgXrS7WEDGeu5pZNjNzw.png)

据此继承树构建代码会很快变得难于管理 （"继承地狱"）。要避免这种情况，开发人员应遵循"组合而非继承"的原则。

### 组合优于继承


>“在面向对象编程中有个原则，组合替代继承（组合复用原则）。类应该通过组合实现行为多态和代码复用（通过包含其他类的实例来实现所需的功能）。”([en.wikipedia.org/wiki/Composition_over_inheritance](http://en.wikipedia.org/wiki/Composition_over_inheritance))


组合优于继承原则是个很棒的想法，无疑可以帮助我们解决上面提出的问题。然而，几乎没有库、示例代码或者教程来教你如何在 Android 上实现这原则。一种实现它的简单方法就是使用运行时参数（又叫 intent extras）来组合功能，但是，仍会导致形成一个巨大的难以管理的怪物类。

很荣幸，这里要提及两个库， [LightCycle](https://www.github.com/soundcloud/lightcycle) 和 [CompositeAndroid](https://www.github.com/passsy/CompositeAndroid)。两者都紧紧的绑定在 Activity 或 Fragment，抛开其他诸如 MVP 或 MVVM 的现代模式，都不是很灵活，因为它们仅仅依赖 Android 原生回调（无法添加额外回调），也不支持模块间通信。

### 修饰模式

开发者们每天都要面对这些提出的问题， EyeEm Android 团队开始开发一种模式，以一种更加灵活的方式来解决该问题，而不是直接附加到一个组件上如 Activity 或 Fragment 。该模式可以用来对任何开发者希望通过组合来模块化的类进行解耦。

该模式和 LightCycle/Composite 的方法非常相似，由三个类组成：

- 基本类，称为 DecoratedObject（装饰对象），调度其继承和额外的方法给一个调度对象。
- DecoratorsObject 实例化，保存所有组成对象的列表并分派方法给它们。
- Decorator 抽象类，所有方法和额外接口都只声明未实现。由创建此类的开发人添加单一职责的具体实现。

使用这种方式开发人员获得的直接好处

- 职责分离
- 功能动态运行置换
- 并行开发

为了让开发者能毫无障碍的实现上述模式，一个在编译时生成代码的工具被创造了出来，接下来我们会看到，将之前提交的那些职责分解成单一职责类是多么简单。

### Decorator 库

#### 如何三步创建你自己的模块化单一职责应用

要实现装饰模式首先创建应生成的代码蓝图，在这里我们将使用一个带 RecyclerView 的 Activity 作为例子，但同样能用在 Fragment、Presenter 甚至 View 。这这个例子中，我们将使用 activity 生命周期中的 onCreate/onStart/onStop/onDestroy ，但是也会额外创建几个适合 RecyclerView 案例的回调。

```
    @Decorate
    public class ActivityBlueprint extends AppCompatActivity {

        @Override protected void onCreate(@Nullable Bundle savedInstanceState) {super.onCreate(savedInstanceState);}
        @Override protected void onStart() {super.onStart();}
        @Override protected void onStop() {super.onStop();}
        @Override protected void onDestroy() {super.onDestroy();}

        public int getLayoutId() {return R.layout.recycler_view;}
        public RecyclerView.LayoutManager getLayoutManager() {return new LinearLayoutManager(this);}
        public RecyclerView.Adapter getAdapter() {return null;}
        public void setupRecyclerView(RecyclerView recyclerView, WrapAdapter wrapAdapter, RecyclerView.Adapter adapter) { /**/ }

        public interface DataInstigator {
            RealmList getList();
            RealmObject getData();
        }

        public interface RequestInstigator {
            void reload();
            void loadMore();
        }
    }
```

这个简单的蓝图使用 `@Decorate` 注解，将会生成完整的修饰模式实现，`Serializable` builder 类可以作为参数传递。为了完成 Activity 的实现，我们扩展了生成类，并将 received builder 绑定上去。

```
    public classRecyclerViewActivityextendsDecoratedAppCompatActivity{

        @Overrideprotected void onCreate(Bundle savedInstanceState) {
            bind(getBuilder(getIntent().getSerializableExtra(KEY.BUILDER)));
            super.onCreate(savedInstanceState);
            setContentView(getLayoutId());
            RecyclerView rv = (RecyclerView) findViewById(R.id.recycler);
            rv.setLayoutManager(getLayoutManager());
            RecyclerView.Adapter adapter = getAdapter();
            WrapAdapter wrapAdapter = newWrapAdapter(adapter);
            rv.setAdapter(wrapAdapter);
            setupRecyclerView(rv, wrapAdapter, adapter);
        }

        @Overrideprotected void onDestroy() {
            super.onDestroy();
            unbind();
        }
    }
```

现在可以方便的将职责分发到可绑定的修饰类上。每个修饰器包含所有生命周期的回调，可以实现任何可选接口。最后，可以组合得到一个简单的建造者模式：

```
      Intent i = new Intent(context, RecyclerViewActivity.class);
            i.putExtra(KEY.BUILDER, new DecoratedActivity.Builder()
                    .addDecorator(GridInstigator.class)
                    .addDecorator(LoadMoreDecorator.class)
                    .addDecorator(PhotoGridAdapter.class)
                    .addDecorator(PhotoListInstigator.class)
                    .addDecorator(PhotoRequestInstigator.class));
            i.putExtra(KEY.URL, url);
```

### 完整示例应用

请查看我们 Github 上的相关库和完整的示例应用 [https://github.com/eyeem/decorator](https://github.com/eyeem/decorator) 。该示例应用在开始下一步之前从当前 activity 通过简单的添加/移除修饰器来模拟每个用户在 Activity 执行 tap。

上面展示的代码大部分都是出自示例。你会发现一个用 Realm 和 Retrofit 真正实现的修饰器列表，就是这篇文章开始提到的 UI 构建任务。

- CoordinatorLayoutInstigator，重写了 CoordinatorLayout 的默认布局，可选实例化一个 header
- ToolbarInstigator，接管 toolbar，并且应用一个标题
- ToolbarUp 和 ToolbarBack 修饰器，导航工具栏上图标的行为
- 加载更多的修饰器，添加一个无限滚动的功能到 RecyclerView
- PhotoList 和 PhotoRequest 修饰器，本地数据存储和 API 请求图片列表 API 调用

### 现实世界应用

[EyeEm](https://www.eyeem.com) 已经在使用修饰器——并且体验非常好。来 [Play Store](https://play.google.com/store/apps/details?id=com.baseapp.eyeem) 看看吧。我们目前为所有 UI 元素使用 装饰 view presenters（使用 Square Mortar 库），为过渡动画使用了装饰 activities，处理不同 API 级别，A/B 测试，导航，跟踪和新摄影师入职时的少数特殊情况，

### 最后说明

上面所示的代码和实现纯粹只是示例，仅作为指导。

当我们为 Android 创建这个库时，该模式是开放给任何用例的。这个库是一个纯 Java 实现，它在编译时生成代码，可用于任何 Java 类，我们鼓励开发人员在他们任何 Java 项目中编写模块化的单一职责的代码！来

说的够多了-将[它](https://www.github.com/eyeem/decorator)添加到你的 build.gradle 中，然后开始构建模块化应用吧。


*在 [EyeEm](https://www.eyeem.com),我们正在探索摄影和技术的交叉点。除了建立尖端的计算机视觉技术，我们的 iOS，Android 和 web 应用程序被 1800 万世界各地的摄影师用于获得灵感、 学习、 分享他们的工作，发现惊人的天赋，获得出版和展出，甚至通过我们的市场赚钱。*

我们一直在寻找激情，奋发努力的工程师加入我们的使命——编码摄影的未来! [联系我们！](https://www.eyeem.com/jobs)
