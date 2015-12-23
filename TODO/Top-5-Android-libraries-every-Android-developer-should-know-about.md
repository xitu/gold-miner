> * 原文链接 : [Top 5 Android libraries every Android developer should know about - v. 2015](https://infinum.co/the-capsized-eight/articles/top-five-android-libraries-every-android-developer-should-know-about-v2015)
* 原文作者 : [Infinum](https://infinum.co/the-capsized-eight/author/ivan-kust)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

In June 2014, we published an article about [top 5 Android libraries](https://infinum.co/the-capsized-eight/articles/top-5-android-libraries-every-android-developer-should-know-about) we were using back then and believed every Android developer should know about. Since then, there have been a lot of changes on the Android scene, so we’re giving you the updated list of our five favorites.

So here's the updated list:

![Top 5 Android libraries](https://s3.amazonaws.com/infinum.web.production/repository_items/files/000/000/308/original/top_5_android_libraries.png?1402486321)

## 1\. [Retrofit](https://github.com/square/retrofit/tree/version-one)

Retrofit is still our favorite when it comes to implementing REST APIs.

From their site: “Retrofit turns your REST API into Java interface.” Yes, there are other solutions, but Retrofit has proven to be the most elegant and simple solution for organizing API calls in a project. The request method and relative URL are added with an annotation, which makes code clean and simple.

With annotations, you can easily add a request body, manipulate the URL or headers and add query parameters.

Adding a return type to a method will make it synchronous, while adding a Callback will allow it to finish asynchronously with success or failure.

```java
public interface RetrofitInterface {

    // asynchronously with a callback
    @GET("/api/user")
    User getUser(@Query("user_id") int userId, Callback<User> callback);

    // synchronously
    @POST("/api/user/register")
    User registerUser(@Body User user);
}


// example
RetrofitInterface retrofitInterface = new RestAdapter.Builder()
            .setEndpoint(API.API_URL).build().create(RetrofitInterface.class);

// fetch user with id 2048
retrofitInterface.getUser(2048, new Callback<User>() {
    @Override
    public void success(User user, Response response) {

    }

    @Override
    public void failure(RetrofitError retrofitError) {

    }
});
```





Retrofit uses [Gson](https://code.google.com/p/google-gson/) by default, so there is no need for custom parsing. Other converters are supported as well.

Retrofit 2.0 is being actively developed at the moment. It is still in beta, but you can check it out [here](http://square.github.io/retrofit/). A lot of things from Retrofit 1.9 have been stripped down and some major changes include a new Call interface which replaces Callback.

## 2\. [DBFlow](https://github.com/Raizlabs/DBFlow)

If you are going to store any more complex data in your project, you should use DBFlow. As stated on their GitHub, it's “a blazing fast, powerful, and very simple ORM Android database library that writes database code for you.”

Just a few short examples:

```java
// Query a List
new Select().from(SomeTable.class).queryList();
new Select().from(SomeTable.class).where(conditions).queryList();

// Query Single Model
new Select().from(SomeTable.class).querySingle();
new Select().from(SomeTable.class).where(conditions).querySingle();

// Query a Table List and Cursor List
new Select().from(SomeTable.class).where(conditions).queryTableList();
new Select().from(SomeTable.class).where(conditions).queryCursorList();

// SELECT methods
new Select().distinct().from(table).queryList();
new Select().all().from(table).queryList();
new Select().avg(SomeTable$Table.SALARY).from(SomeTable.class).queryList();
new Select().method(SomeTable$Table.SALARY, "MAX").from(SomeTable.class).queryList();

```

DBFlow is a nice ORM that will remove a lot of boilerplate code used for working with databases. While there are other ORM alternatives for Android, DBFlow has proven to be the best solution for us.

## 3\. [Glide](https://github.com/bumptech/glide)

Glide is the library to use for loading images. Current alternatives are [Universal Image Loader](https://github.com/nostra13/Android-Universal-Image-Loader) and [Picasso](https://github.com/square/picasso); but, in my opinion, Glide is the best choice at the moment.

Here's a simple example how you can use Glide to load an image from a URL into ImageView:

```java
ImageView imageView = (ImageView) findViewById(R.id.my_image_view);

Glide.with(this).load("http://goo.gl/gEgYUd").into(imageView);

```


## 4\. [Butterknife](http://jakewharton.github.io/butterknife/)

A library for binding Android views to fields and methods (for instance, binding a view OnClick to a method). Basic functionality hasn’t changed from the early versions, but the number of options has grown. Example:

```java
class ExampleActivity extends Activity {
  @Bind(R.id.title) TextView title;
  @Bind(R.id.subtitle) TextView subtitle;
  @Bind(R.id.footer) TextView footer;

  @Override public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.simple_activity);
    ButterKnife.bind(this);
    // TODO Use fields...
  }
}

```


## 5\. [Dagger 2](http://google.github.io/dagger/)

Since we moved to MVP architecture, we’ve started using dependency injection extensively. Dagger 2 is the successor of the famous Dagger dependency injection library and we highly recommend it.

One of the major improvements is using zero reflection in generated injection code, which makes debugging a lot easier.

Dagger creates instances of your classes and satisfies their dependencies. It relies on javax.inject.Inject annotation to identify which constructors or fields should be treated as dependencies. From the famous CoffeeMaker example:

```java
class Thermosiphon implements Pump {
  private final Heater heater;

  @Inject
  Thermosiphon(Heater heater) {
    this.heater = heater;
  }

  ...
}
```

An example with direct injection into fields:

```java
class CoffeeMaker {
  @Inject Heater heater;
  @Inject Pump pump;

  ...
}

```

Dependencies are provided via modules and @Proivides annotation from Dagger:

```java
@Module
class DripCoffeeModule {
  @Provides Heater provideHeater() {
    return new ElectricHeater();
  }

  @Provides Pump providePump(Thermosiphon pump) {
    return pump;
  }
}

```

If you want more information on dependency injection itself, check out the Dagger 2 page or this great [talk about Dagger 2 by Gregory Kick](https://www.youtube.com/watch?v=oK_XtfXPkqw).

### ADDITIONAL LINKS

[Android Weekly](http://androidweekly.net/) is still one of the best sources for learning about new Android libraries. It's a weekly newsletter about Android development.

Also, here's a list of big shots in the Android world who regularly post about Android development:

[Jake Wharton](https://twitter.com/JakeWharton) [Chris Banes](https://twitter.com/chrisbanes) [Cyril Mottier](https://twitter.com/cyrilmottier) [Mark Murphy](https://twitter.com/commonsguy) [Mark Allison](https://twitter.com/MarkIAllison) [Reto Meier](https://twitter.com/retomeier)



