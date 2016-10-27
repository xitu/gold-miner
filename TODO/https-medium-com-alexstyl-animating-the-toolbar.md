> * 原文地址：[Exposing the Searchbar Implementing a Dialer-like Search transition](https://medium.com/@alexstyl/https-medium-com-alexstyl-animating-the-toolbar-7a8f1aab39dd#.waucttqbf)
* 原文作者：[Alex Styl](https://medium.com/@alexstyl)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Exposing the Searchbar Implementing a Dialer-like Search transition
A **tl;dr** version of pure code can be found [here](https://github.com/alexstyl/Material-SearchTransition)

### The problem

I have been receiving some user feedback for my app that the feature they are missing the most is _search_. For an app that contains information from different sources such as contact’s events, name days or bank holidays, such as Memento Calendar, I would have to agree that Search is one of the most important features the app could have. The problem is that the feature is already implemented. A search icon in the Toolbar navigates the user to a dedicated search screen.

![A user can search by tapping the search icon on the Toolbar](https://raw.githubusercontent.com/alexstyl/alexstyl.github.io/master/images/animating-the-toolbar/search_toolbar.png)

I decided to reach out to some of my users to see what the problem really was. After exchanging some emails and having some chats with some lucky users I concluded the following:

> People seem to be more accustomed to the search bar found in other popular apps such as Facebook, Swarm and others. In those said apps, the search bar can be accessed directly through the Toolbar, meaning that the user can start a search right from the main screen.

As the search logic was already there in the app, I had the luxury of time to experiment with the animations APIs of the platform and add some liveness into my app.

### The course of action

The idea was to create a transition that links two screens together; the home screen of the app where the Search bar can be found and the Search screen where the search magic happens.

From a design point of view, I wanted the transition to be as seemingness as possible so that the user can focus on searching without having the feeling that they are looking at a new screen. From a developer point of view though, the two screens (Activities) had to stay separate. Each Activity handles their own responsibilities and having to combine them would be a complete nightmare for maintenance purposes.

As this was my first time playing with Transitions I had some reading to do. I found Nick Butcher’s and Nick Weiss’s [_Meaningful motion_ talk](https://skillsmatter.com/skillscasts/6798-meaningful-motion) to be really helpful understanding how the new API works and the slides were (and still are) my go-to cheatsheet for anything Transition related.

A similar effect of what I wanted to achieve can also be found in the [stock Android’s Phone app](https://play.google.com/store/apps/details?id=com.google.android.dialer). As soon as the user taps on the search bar, the current screen fades away, the search bar expands, and the user is ready to start searching.

![The transition as seen in the Dialer app](https://raw.githubusercontent.com/alexstyl/alexstyl.github.io/master/images/animating-the-toolbar/dialer.gif)

Unfortunately, the implementation of the app is done differently from what I was expecting. [Everything is done in one single activity](http://grepcode.com/file/repository.grepcode.com/java/ext/com.google.android/android-apps/5.1.0_r1/com/android/dialer/DialtactsActivity.java). Even though that could work, I don’t like combining multiple responsibilities together, so that I can be more flexible in updating the design of the app in the future. Even though the implementation wasn’t exactly what I wanted it to be, I got a good idea what my next steps should be.

I broke down the desired transition into three simple steps:

1) fade out the contents of the toolbar

2) expand the toolbar

3) fade the contents back in

Those steps can easily be performed with the use of `TransitionManager` class. By a simple call of [`TransitionManager.beginDelayedTransition()`](http://alexstyl.com/exposing-the-searchbar/) and then modifying the properties of the view, the framework will automatically animate the changes done to the view. This can work for both the expansion and collapse of the search bar. The fading is done in the same way, but we are changing the visibility of the views instead. The only thing missing now is how to seamlessly jump to the search activity in a single go.

Luckily, I remembered seeing something similar being done in one of the Android Developers videos. In the video titled [DevBytes: Custom Activity Animations](https://www.youtube.com/watch?v=CPxkoe2MraA) Cheet Haase showcases how to override the system’s animation when starting or finishing activities.  Last but not least, we can further polish the transition and make it seem faster, by showing the keyboard as soon as the Transition starts. A simple way of achieving this is by specifying the right windowSoftInputMode on the application Manifest file. That way the keyboard will be visible while the second activity is started.

### The end result

Putting everything together the following result can be achieved:

![The transition as seen in Memento Calendar](https://raw.githubusercontent.com/alexstyl/alexstyl.github.io/master/images/animating-the-toolbar/memento.gif)

You might be wondering whether this design decision actually had any effect. I’m quite happy with the result as this update brought 30% more searches into the app. This can either mean that it is easier for people to search, or people enjoy the animation ![😄](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f604.png)

* * *

There are some minor UX improvements that can be done for a more polished effect, such as the tinting of the Up icon or finishing the activity when the user presses back without a search query in place. If you are interested in learning how to achieve such effects, **Memento Calendar is open-source** and you are more than welcome to have a look at how things work under the hood. You **grab the source** code at [Github.com](https://github.com/alexstyl/Memento-Namedays) or **download the app** from the [Google Play Store](http://alexstyl.com/exposing-the-searchbar/play.google.com/store/apps/details?id=com.alexstyl.specialdates).