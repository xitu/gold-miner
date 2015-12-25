> * 原文链接 : [6 Things I wish I Knew before I Wrote my first Android App |](http://www.philosophicalhacker.com/2015/07/09/6-things-i-wish-i-knew-before-i-wrote-my-first-android-app/)
* 原文作者 : [K. Matthew Dupree](https://infinum.co/the-capsized-eight/author/ivan-kust)
* 译文出自 : [掘金翻译计划](http://www.philosophicalhacker.com/)
* 译者 : 
* 校对者: 
* 状态 :  待定





My first app was terrible. It was so terrible, in fact, that I removed it from the store and I don’t even bother listing it on my resume’ anymore. That app wouldn’t have been so terrible if I knew a few things about Android development before I wrote it.

Here’s a list of things to keep in mind as you’re writing your first Android apps. These lessons are derived from actual mistakes that I made in the source code of my first app, mistakes that I’ll be showing below. Keeping these things in mind will help you write an app that you can be a little prouder of.

Of course, if you’re doing your job right as a student of Android development, you’ll probably hate your app later regardless. As @codestandards says,

> If the code you wrote a year ago doesn’t seem bad to you, you’re probably not learning enough.
> 
> — Code Standards (@codestandards) [May 21, 2015](https://twitter.com/codestandards/status/601373392059518976)

If you’re an experienced Java developer, items 1, 2, and 5 probably won’t be interesting to you. Items 3 and 4, on the other hand, might show you some cool stuff you can do with Android Studio that you might not have known about, even if you’ve never been guilty of making the mistakes I demo in those items.

## 1\. Don’t have static references to Contexts

    public class MainActivity extends LocationManagingActivity implements ActionBar.OnNavigationListener,
            GooglePlayServicesClient.ConnectionCallbacks,
            GooglePlayServicesClient.OnConnectionFailedListener {

        //...

        private static MeTrackerStore mMeTrackerStore; 

        //...

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            //...

            mMeTrackerStore = new MeTrackerStore(this);
        }
    }

This might seem like an impossible mistake for anyone to make. Its not. I made this mistake. I’ve seen others make this mistake, and I’ve interviewed people who weren’t very quick at figuring out why this is a mistake in the first place. Don’t do this. Its a n00b move.

If MeTrackerStore keeps a reference to the Activity passed into its constructor, the Activity will never be garbage collected. (Unless the static variable is reassigned to a different Activity.) This is because mMeTrackerStore is static, and the memory for static variables is allocated when the application first starts and isn’t collected until the process in which the application is running quits.

If you find yourself tempted to do this, there’s probably something seriously wrong with your code. Find help. Maybe looking at Google’s Udacity course on [“Android Development for Beginners”](https://www.udacity.com/course/android-development-for-beginners--ud837) will help you out.

Note: Technically, you can hold a static reference to an application Context without causing a memory leak, but I wouldn’t recommend that you do that either. 

## 2\. Beware of “implicit references” to objects whose lifecycle you do not control

    public class DefineGeofenceFragment extends Fragment {
        public class GetLatAndLongAndUpdateMapCameraAsyncTask extends AsyncTask {

            @Override
            protected LatLng doInBackground(String... params) {
                //...
                try {
                    //Here we make the http request for the place search suggestions
                    httpResponse = httpClient.execute(httpPost);
                    HttpEntity entity = httpResponse.getEntity();
                    inputStream = entity.getContent();
                    //..
                }
            }
        }

    }

There’s multiple problems with this code. I’m only going to focus on one of those problems. In Java, (non-static) inner classes have an implicit reference to the instances of the class that encloses them.

In this example, any GetLatAndLongAndUpdateMapCameraAsyncTask would have a reference to the DefineGeofenceFragment that contains it. The same thing is true for anonymous classes: they have an implicit reference to instances of the class that contains the anonymous class.

The GetLatAndLongAndUpdateMapCameraAsyncTask has an implicit reference to a Fragment, an object whose lifecycle we don’t control. The Android SDK is responsible for creating and destroying Fragments appropriately and if GetLatAndLongAndUpdateCameraAsyncTask can’t be garbage collected because its still executing, the DefineGeofenceFragment that it implicitly refers to will also be kept from being garbage collected.

There’s a great Google IO video [that explains why this sort of thing happens](https://www.youtube.com/watch?v=_CruQY55HOk).

## 3\. Make Android Studio work for You

    public ViewPager getmViewPager() {
        return mViewPager;
    }

This snippet is what Android Studio generated when I used the “Generate Getter” code completion in Android Studio. The getter keeps the ‘m’ prefixed to the instance variable and uses it when generating a getter method name. This is not ideal.

(In case you’re wondering why ‘m’ is prefixed to the instance variable name in the first place: the ‘m’ is often prefixed to instance variables by convention. It stands for ‘member.’)

Regardless of whether you think prefixing ‘m’ to your instance variables is a good idea, there’s a lesson here: Android studio can help you code to whatever convention you adopt. For example, you can use the code style dialog in Android Studio to make Android Studio automatically prepend ‘m’ to your instance variable and automatically remove the ‘m’ when its generating getters, setters, and constructor params for the instance variables.

[![Screen Shot 2015-07-09 at 4.16.13 PM](http://i1.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.16.13-PM.png?resize=620%2C432)](http://i1.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.16.13-PM.png)

Android Studio can do a lot more than that too. [Learning shortcuts](http://www.developerphil.com/android-studio-tips-of-the-day-roundup-1/) and learning about [live templates](https://www.jetbrains.com/idea/help/live-templates.html) are good places to start.

## 4\. Methods should do one thing

There’s a method in one of the classes that I wrote that’s over 100 lines long. Such methods are hard to read, modify, and reuse. Try to write methods that only do one thing. Typically, this means that you should be suspicious of methods that are over 20 lines long. Here you can recruit Android Studio to help you spot problematic methods:

[![Screen Shot 2015-07-09 at 4.25.00 PM](http://i2.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.25.00-PM.png?resize=620%2C435)](http://i2.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.25.00-PM.png)

## 5\. Learn from other people who are smarter and more experienced than you.

This might sound trivial, but its a mistake that I made when I wrote my first app.

When you’re writing an app you’re going to make mistakes. Other people have already made those mistakes. Learn from those people. You’re wasting your time if you repeat the avoidable mistakes of others. I wasted a ton of time on my first app making mistakes that I could have avoided if I just spent a little more time learning from experienced software developers.

Read [Pragmatic Programmer](http://www.amazon.com/The-Pragmatic-Programmer-Journeyman-Master/dp/020161622X). Then read [Effective Java](http://www.amazon.com/Effective-Java-Edition-Joshua-Bloch/dp/0321356683). These two books will help you avoid making common mistakes that we make as novice developers. After you done with those books, keep looking for smart people to learn from.

## 6\. Use Libraries

When you’re writing an app, you’re probably going to encounter problems that smarter and more experienced people have already solved. Moreover, a lot of these solutions are available as open source libraries. Take advantage of them.

In my first app, I wrote code that provided functionality that’s already provided by libraries. Some of those libraries are standard java ones. Others are third-party libraries like Retrofit and Picasso. If you’re not sure what libraries you should be using you can do three things:

1.  Listen to the [Google IO Fragmented podcast episode](http://fragmentedpodcast.com/episodes/9/). In this episode the ask developers what 3rd party libraries they see as essential for Android development. Spoiler: its mostly Dagger, Retrofit, Picasso, and Mockito.
2.  Subscribe [to Android Weekly](http://androidweekly.net/). They’ve got a section that contains the latest libraries that are coming out. Keep an eye out for what seems useful to you.
3.  Look for open source applications that solve problems similar to the ones that you are solving with your app. You might find one that uses a third-party library that you want to use or you might find that they’ve used a standard java library that you were unaware of.

## Conclusion

Writing good Android apps can be very difficult. Don’t make it harder on yourself by repeating the mistakes I made. If you found a mistake in what I’ve written, please let me know in the comments. (Misleading comments are worse than no comments at all.) If you think this’ll be useful for a new developer, share it. Save them some headache.



