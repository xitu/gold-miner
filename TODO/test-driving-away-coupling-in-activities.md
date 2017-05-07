> * 原文地址：[Test Driving away Coupling in Activities](https://www.philosophicalhacker.com/post/test-driving-away-coupling-in-activities/)
> * 原文作者：[philosohacker](https://twitter.com/philosohacker)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Test Driving away Coupling in Activities #

`Activity`s and `Fragment`s, perhaps by [some strange historical accidents](/post/why-android-testing-is-so-hard-historical-edition/), have been seen as *the optimal* building blocks upon which we can build our Android applications for much of the time that Android has been around. Let’s call this idea – the idea that `Activity`s and `Fragment`s are the best building blocks for our apps – “android-centric” architecture.

This series of posts is about the connection between the testability of android-centric architecture and the other problems that are now leading Android developers to reject it; it’s about how our unit tests are trying to tell us that `Activity`s and `Fragment`s – like the cracking bricks in the above image – don’t make the best building blocks for our apps because they tempt us to write code with *tight coupling* and *low cohesion*.


[Last time](/post/what-unit-tests-are-trying-to-tell-us-about-activities-pt-2/), we saw `Activity`s and `Fragment`s tend to have low cohesion. This time, we’ll see how our tests can tell us that code within `Activity`s have tight coupling. We’ll also see how test driving the functionality leads to a design that has looser coupling, which makes it easier to change the app and also opens up opportunities for removing duplication. As with the the other posts in the series, we’ll be discussing all of this using the Google I/O app as an example.

### The Target Code ###

The code that we want to test, the “target code”, does the following: when the user navigates to the map view that shows where all the Google I/O sessions are, it asks for their location. If they reject the permission, we show a toast notifying the user that they’ve disabled an app permission. Here’s a screenshot of this:

![permission denied toast](https://www.philosophicalhacker.com/images/permission-denied-snackbar.png)

Here’s the code that accomplishes this:

```
@Override
public void onRequestPermissionsResult(final int requestCode,
        @NonNull final String[] permissions,
        @NonNull final int[] grantResults) {

    if (requestCode != REQUEST_LOCATION_PERMISSION) {
        return;
    }

    if (permissions.length == 1 &&
            LOCATION_PERMISSION.equals(permissions[0]) &&
            grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        // Permission has been granted.
        if (mMapFragment != null) {
            mMapFragment.setMyLocationEnabled(true);
        }
    } else {
        // Permission was denied. Display error message.
        Toast.makeText(this, R.string.map_permission_denied,
                Toast.LENGTH_SHORT).show();
    }
    super.onRequestPermissionsResult(requestCode, permissions,
            grantResults);
}
```

### The Test Code ### (#the-test-code)

Let’s take a stab at testing this. Here’s what that would look like:

```
@Test
public void showsToastIfPermissionIsRejected()
        throws Exception {
    MapActivity mapActivity = new MapActivity();

    mapActivity.onRequestPermissionsResult(
            MapActivity.REQUEST_LOCATION_PERMISSION,
            new String[]{MapActivity.LOCATION_PERMISSION}, new int[]{
                    PackageManager.PERMISSION_DENIED});

    assertToastDisplayed();
}
```

Hopefully, you’re wondering what the implementation of `assertToastDisplayed()` looks like. Here’s the thing: there isn’t a straight forward implementation of that method. In order to implement without refactoring our code, we’d need to use a combination of roboelectric and powermock.

However, since we are trying to listen to our tests and [change the way we write code, rather than change the way we write tests](/post/why-i-dont-use-roboletric/), we are going to stop for a moment and think about what this test is trying to tell us:

> Our presentation logic that lives inside of `MapActivity` is tightly coupled with `Toast`.

This coupling is what drives us to use roboelectric to give us mocked android behavior and  powermock to mock the static `Toast.makeText` method. Instead, let’s listen to our test and remove the coupling.

To guide our refactoring, let’s write our test first. This will ensure that our *new* classes are loosely coupled. We have to create a new class in this particular case in order to avoid Roboelectric, but ordinarily, we could just refactor already existing classes to reduce coupling.

```
@Test
public void displaysErrorWhenPermissionRejected() throws Exception {

    OnPermissionResultListener onPermissionResultListener =
            new OnPermissionResultListener(mPermittedView);

    onPermissionResultListener.onPermissionResult(
            MapActivity.REQUEST_LOCATION_PERMISSION,
            new String[]{MapActivity.LOCATION_PERMISSION},
            new int[]{PackageManager.PERMISSION_DENIED});

    verify(mPermittedView).displayPermissionDenied();
}
```

We’ve introduced a `OnPermissionResultListener` whose job is just to handle the result of request permission from a user. Here’s the code for that:

```
void onPermissionResult(final int requestCode,
            final String[] permissions, final int[] grantResults) {
    if (requestCode != MapActivity.REQUEST_LOCATION_PERMISSION) {
        return;
    }

    if (permissions.length == 1 &&
            MapActivity.LOCATION_PERMISSION.equals(permissions[0]) &&
            grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        // Permission has been granted.
        mPermittedView.displayPermittedView();

    } else {
        // Permission was denied. Display error message.
        mPermittedView.displayPermissionDenied();
    }
}
```

The calls to `MapFragment` and `Toast` have been replaced with method calls on the `PermittedView`, an object that gets passed in through the constructor. `PermittedView` is an interface:

```
interface PermittedView {
    void displayPermissionDenied();

    void displayPermittedView();
}
```

And it gets implemented by the `MapActivity`:

```
public class MapActivity extends BaseActivity
        implements SlideableInfoFragment.Callback, MapFragment.Callbacks,
        ActivityCompat.OnRequestPermissionsResultCallback,
        OnPermissionResultListener.PermittedView {
    @Override
    public void displayPermissionDenied() {
        Toast.makeText(MapActivity.this, R.string.map_permission_denied,
                Toast.LENGTH_SHORT).show();
    }
}
```

This may not the *best* solution, but it gets us to a point where we can test things. This *required* that `OnPermissionResultListener` be loosely coupled with its `PermittedView`. Loose coupling == definitely an improvement.

### Who cares? ###

At this point, some readers might be skeptical. “Is this definitely an improvement?,” they may wonder to themselves. Here are two reasons why this *design* is better.

(Neither reason I give, you’ll notice is “the design is better because its testable.” That would be circular reasoning.)

#### Easier Changes ####

First, its going to be easier to change this code now that it consists of loosely coupled components, and here’s the kicker: the code that we’ve just tested from the Google I/O app *actually did change*, and with the tests that we have in place, making those changes will be easier. The code I tested was from [an older commit](https://github.com/google/iosched/blob/bd31a838ce4ddc123c71025c859959517c7ae178/android/src/main/java/com/google/samples/apps/iosched/map/MapActivity.java). Later on, the folks working on the I/O app decided to replace the `Toast` with a `Snackbar`:

![snackbar permission rejected](http：/images/permission-denied-snackbar.png)

Its a small change, but because we’ve separated `OnPermissionResultListener` from `PermittedView`, we can make the change on the `MapActivity`s implementation of `PermittedView` without having to think at all about the `OnPermissionResultListener`.

Here’s what that change would have looked like, using their little `PermissionUtils` class they wrote for displaying `SnackBar`s.

```
@Override
public void displayPermissionDenied() {
    PermissionsUtils.displayConditionalPermissionDenialSnackbar(this,
            R.string.map_permission_denied, new String[]{LOCATION_PERMISSION},
            REQUEST_LOCATION_PERMISSION);
}
```

Again, notice that we can make this change without thinking about the `OnPermissionResultListener` at all. This is actually exactly what Larry Constantine was talking about when he first defined the concept of coupling back in the 70s:

> what we are striving for is loosely coupled systems…in which one can study (or debug, or maintain) any one module without having to know very much about any other modules in the system
> 
> –Edward Yourdon and Larry Constantine, Structured Design

#### Reducing Duplication ####

Here’s another interesting reason to why the fact that our tests have forced us to remove coupling is a good thing: coupling often leads to duplication. Here’s Kent Beck on this:

> Dependency is the key problem in software development at all scales…if dependency is the problem, duplication is the symptom.
> 
> -Kent Beck, TDD By Example, pg 7.

If this is true, when we remove coupling, we will often see opportunities to reduce duplication. Indeed, this is precisely what we find in this case. It turns out that there is  another classes whose `onRequestPermissionsResult` is nearly identical to the one in `MapActivity`: [`AccountFragment`](https://github.com/google/iosched/blob/bd31a838ce4ddc123c71025c859959517c7ae178/android/src/main/java/com/google/samples/apps/iosched/welcome/AccountFragment.java#L139). Our tests drove us to create two classes `OnPermissionResultListener` and `PermittedView` that – without much modification – can be reused in these other classes.

### Conclusion ###

So, when we have a hard time testing our `Activity`s and `Fragment`s, its often because our tests are trying to tell us that our code is tightly coupled. The test’s warning about coupling often come in the form of an inability to make an assertion against the code we’re trying to test.1

When we listen to our tests, instead of changing them by using Roboelectric our powermock, we’re lead to change in our code in a way that makes it less coupled, which makes it easier to make changes and opens up opportunities to reduce duplication.

### Notes ###

1. It could also show up as an inability to get your target code into the right state for testing. That’s what we saw [in this post](in this post), for example.

### We're hiring mid-senior Android developers at [Unikey](http://www.unikey.com/). Email me if you want to work for a Startup in the smart lock space in Orlando ###
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
