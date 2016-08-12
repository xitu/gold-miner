> * 原文链接: [Creating Highly Modular Android Apps](https://medium.com/stories-from-eyeem/creating-highly-modular-android-apps-933271fbdb7d#.oez87prl8)
* 原文作者 : [Ronaldo Pace](https://medium.com/@ronaldo.pace?source=post_header_lockup)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 :

> “The single responsibility principle states that every (…) class should have responsibility over a single part of the functionality provided by the software.” ([en.wikipedia.org/wiki/Single_responsibility_principle](https://en.wikipedia.org/wiki/Single_responsibility_principle))

UI building in Android is usually delegated to one class (named Activity, Fragment, or View/Presenter). This usually entails the following tasks:

- View inflation (xml layout)
- View configuration (runtime parameters, layout manager, adapter)
- Data source connection (DB or data storage listening/subscription)
- Loading cached data
- Dispatch on-demand requests for new data
- Listening to user events (tap, scroll) and responding to them

On top of that, Activity and Fragment are usually delegated extra responsibilities such as:

- App navigation
- Activity Results handling
- Google Play Services connection and interaction
- Transitions configuration

That’s not a single responsibility, and current ways of handling with such complexity includes inheritance or composition.

![](https://cdn-images-1.medium.com/max/800/1*PYTSQy1jyMgZdKzKAK-ImA.gif)

### Inheritance Hell

> “Inheritance is when an object or class is based on another object (…) or class (…). It is a mechanism for code reuse and to allow independent extensions of the original software via public classes and interfaces. The relationships of objects or classes through inheritance give rise to a hierarchy.” ([en.wikipedia.org/wiki/Inheritance_(object-oriented_programming)](https://en.wikipedia.org/wiki/Inheritance_%28object-oriented_programming%29))

For such complex structures, such as in UI building, inheritance can quickly become a hell. Check the following mock-case:

![](https://cdn-images-1.medium.com/max/800/1*TItgXrS7WEDGeu5pZNjNzw.png)

Code built along this inheritance tree quickly becomes unmanageable (“inheritance hell”). To circumvent that, developers often follow the principle of “Composition over inheritance”.

### Composition over inheritance

> “Composition over inheritance (…) in object-oriented programming is the principle that classes should achieve polymorphic behavior and code reuse by their composition (by containing instances of other classes that implement the desired functionality).” ([en.wikipedia.org/wiki/Composition_over_inheritance](http://en.wikipedia.org/wiki/Composition_over_inheritance))

The Composition Over Inheritance principle is a great idea and certainly can help us solve the issue presented above. There are, however, virtually no libraries, sample code, or tutorials available on how to implement this on Android. An easy way to start hacking around it is to use runtime parameters (a.k.a. intent extras) to make feature composition, but that still results in a huge unmanageable single class monstrosity.

Honorable mentions here are the [LightCycle](https://www.github.com/soundcloud/lightcycle) and [CompositeAndroid](https://www.github.com/passsy/CompositeAndroid) libraries. Both are tightly tied to the Activity or Fragment, leaving other modern patterns such as MVP or MVVM out, are not very flexible as they rely solely on Android’s native callbacks (cannot add extra callbacks) and do not support inter-module communication.

### Decorator pattern

Based on the presented issues developers face everyday, the EyeEm Android team started developing a pattern to solve in a more flexible way not directly attached to a component such as Activity or Fragment. The decoupling allows the pattern to be used for any class the developer wishes to make modular through composition.

The pattern is quite similar to the LightCycle/Composite approaches, and consists of 3 classes:

- The base class, called DecoratedObject, that dispatches its inherited and extras methods to a dispatcher object.
- The DecoratorsObject that instantiates and holds a list with all the composed objects and dispatches the methods to them.
- The Decorator abstract class with empty implementations of all the methods and extras interface. Concrete implementations of this class to be created by the developer adding individual single responsibilities to it.

With that approach developers gain immediate advantages regarding

- Separation of responsibility
- Dynamic runtime permutation of features
- Dev workload parallelization

To make the implementation of the above pattern seamless for developers, a compile time code generation tool was created and we’ll see next how easy it is to break all those responsibilities previously presented (and more) into single responsibility classes.

### Decorator library

#### Or how to create your own modular single responsibility app in 3 easy steps

To implement decorators first create a blueprint of the code that should be generated, here we’ll use an Activity with a RecyclerView as an example, but the same could be used in a Fragment, Presenter or even View. In this sample, we’ll use onCreate/onStart/onStop/onDestroy from the activity life-cycle, but also create a few extra callbacks that will suit the RecyclerView case.

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

This simple blueprint annotated with [[email protected]](https://medium.com/cdn-cgi/l/email-protection)` will generate the complete implementation of the decorators pattern and a `Serializable` builder class that can be passed as parameter. To complete the Activity implementation we extend the generated class and bind the received builder to it.

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

Now the responsibilities can be easily distributed to bindable decorators. Every decorator contains all of the lifecycle callbacks and may implement any of the optional interfaces. And finally, composition can be obtained in a simple builder pattern:

      Intent i = new Intent(context, RecyclerViewActivity.class);
            i.putExtra(KEY.BUILDER, new DecoratedActivity.Builder()
                    .addDecorator(GridInstigator.class)
                    .addDecorator(LoadMoreDecorator.class)
                    .addDecorator(PhotoGridAdapter.class)
                    .addDecorator(PhotoListInstigator.class)
                    .addDecorator(PhotoRequestInstigator.class));
            i.putExtra(KEY.URL, url);

### Complete sample app

Please check our Github for the library and a complete working sample app [https://github.com/eyeem/decorator](https://github.com/eyeem/decorator) . The sample app morphs the Activity execution on each user tap by simply adding/removing decorators from the current activity before starting the next.

Most of the code shown above was hacked from that sample. There you’ll find a list of kind-of real implementation of decorators using Realm and Retrofit that loosely resembles the UI building tasks mentioned in the beginning of this article.

- CoordinatorLayoutInstigator, overrides the default layout to a CoordinatorLayout, optionally instantiates a header
- ToolbarInstigator, takes over the toolbar and applies a title
- ToolbarUp and ToolbarBack decorators, behavior for the navigation icon on the toolbar
- LoadMore decorator, adds an infinite scroll functionality to the RecyclerView
- Loading decorator, adds a “loading” empty state to the RecyclerView
- PhotoList and PhotoRequest decorators, local data storage and API request to Photo list API call.

### Real world app

[EyeEm](https://www.eyeem.com) already operates with decorators — and the experience has never been better. Check it out [on the Play Store](https://play.google.com/store/apps/details?id=com.baseapp.eyeem) . We currently use Decorated view presenters (using Square Mortar library) for all the UI elements and Decorated activities for transitions, deal with different API levels, A/B testing, navigation, tracking, and a few special cases when onboarding new photographers.

### Final notes

The code and implementation shown above are only samples and intended purely as a guide.

While we built this for Android, the pattern is open to any use case. The library is a pure Java implementation that generates the code during compile time and can be used on any Java class, and we encourage developers to look to create modular single responsibility code in any of their Java projects!

Enough said- [add it](https://www.github.com/eyeem/decorator) to your build.gradle and start building modular apps.

*At [*EyeEm*](https://www.eyeem.com)*, we are exploring the intersection of photography and technology. In addition to building cutting edge computer vision tech, our iOS, Android and web apps are used by 18 million photographers around the world to get inspired, learn, share their work, discover amazing talent, get published and exhibited and even earn money through our marketplace.*

We are always looking for passionate, driven engineers to join us in our mission to code the future of photography! [Get in touch!](https://www.eyeem.com/jobs)
