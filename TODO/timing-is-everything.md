> * 原文地址：[Timing is Everything](https://medium.com/google-developers/timing-is-everything-8218b8df5485#.tlp6t4pxv)
* 原文作者：[Chet Haase](https://medium.com/@chethaase)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Timing is Everything






## Improve your animations with custom, non-linear timing curves

Motion in the real world (you know, the one outside of your phone that you glance at just often enough to make sure you don’t get smacked by a car while crossing the street) is non-linear. When we walk, we accelerate up to speed. When we stop, we decelerate down to zero (unless we got smacked by a car, in which case we experience very sudden acceleration in a different direction). When we fall, gravity accelerates us downward, and when we jump it slows down our upward trajectory. No matter what, we definitely don’t move at a constant pace through the entire motion.

So when we, as humans, see motion on the screen (the one we’re looking at when we’re not watching out for approaching cars), we expect it to be similarly non-linear, because it feels more _natural_. And natural interaction is, in general, what we’re trying to achieve in applications to help users better understand what’s happening in the virtual world of these applications. Don’t try to awe them by your amazing animation skills; give them animations that feel natural so that they can use your application more easily and get to the business of actually doing what they’re trying to do.

#### Android Interpolation

Android has, since the beginning, provided the ability to animate objects in a non-linear fashion, through the use of its [Interpolator](https://developer.android.com/reference/android/view/animation/Interpolator.html) implementations. In fact, the default animation has always been one of [accelerating into and decelerating out of](https://developer.android.com/reference/android/view/animation/AccelerateDecelerateInterpolator.html) the motion. More importantly, Android also offers the ability for a developer to change that default motion, to provide other kinds of timing entirely. For example, you can have your animation start quickly and decelerate out. Or start slowly and steadily accelerate. Or, since the Lollipop release (API 21), to provide a [path-based timing curve](https://developer.android.com/reference/android/view/animation/PathInterpolator.html) for more complex and flexible control. Or even, if you really want to be ornery, to use [linear interpolation](https://developer.android.com/reference/android/view/animation/LinearInterpolator.html) (but please don’t).

With so many options, the question might then arise: which one should you use for your animation needs?

#### So Many to Choose From!

A developer approached me at Google I/O this year and asked, “What kind of interpolation should I use to slide a text element in from the side?”

It’s a good question, and one which I’d encourage more developers to ask for their own applications.

Unfortunately, it’s also a question with an unsatisfyingly vague answer, “It depends.” In particular, it depends on you, your application, the context of that animation, your users, and many other factors that nobody can easily determine for you. There are certainly better and worse approaches to use (such as: don’t use LinearInterpolator for moving things around, and make your animations as quick as possible). But there is no “right” answer that you can apply generically.

My recommendation (admittedly a pale substitute for an actual answer) was to play with different interpolators and decide which felt best for his specific situation. Or, more generally, to write a simple test application that allowed him to play with various interpolators and compare them easily.

Then I realized that this is probably something that we could provide for him (and for everyone). It’s not a difficult application to write, but is one that should be useful for comparing built-in interpolators and it should simply be available for developers to use and to modify for any custom needs they have.

So here it is:

#### [InterpolatorPlayground](https://github.com/google/android-ui-toolkit-demos/tree/master/Animations/InterpolatorPlayground)









![](http://ac-Myg6wSTV.clouddn.com/a821863d8a772e1050f8.png)



InterpolatorPlayground, in action



Introducing [InterpolatorPlayground](https://github.com/google/android-ui-toolkit-demos/tree/master/Animations/InterpolatorPlayground), a simple Android application that you can use to select one of several standard interpolators and experiment with how they impact an animation. You can change the animation duration and the constructor parameters for the interpolators. You can also visualize the interpolation curve and the resulting impact of that interpolation animation on various objects in the UI. Finally, you can drag around the control point(s) for the two PathInterpolator options (quadratic and cubic) to see how to use this specific class to create very custom and flexible timing.

You can also play around with some of the more playful (though arguably less useful) interpolators, such as Bounce and Overshoot (mostly because they’re fun to see in action).

Once you have decided on an animation you like for your situation, simply note the parameter values in the UI and create the appropriate Interpolator using those values in your code.

#### How It All Works

You could just plug in an Interpolator into your code and call it a day. You don’t actually need to understand the details; what you really need is the motion effect you’re looking for.

But if you didn’t care about how it works, why did you choose to be a programmer, anyway? The details are where the fun is.

The way that interpolators work, or more specifically, the way that they affect the timing curve of animations, is by altering the _fraction_ of the elapsed duration. Every animation in Android has a set duration (by default, 300 milliseconds). At any time during an animation, the system figures out how much time has elapsed and calls into the animation to have it calculate the new animated value given the elapsed time. That elapsed time can be expressed as a fraction (where 0 is the start fraction and 1 is the end). For example, an animation that is half-way through has an elapsed fraction of .5, and its calculated values will be half way between its start and end values.

But instead of passing in that fraction directly, we can (and do, it turns out) send the fraction through an Interpolator, which takes that elapsed fraction as an input and returns another fraction as output. That _interpolated_ fraction is the one that we actually pass into the animation calculation.

So to change the timing curve for an animation, we simply need to provide a function that will transform the elapsed fraction into another fraction, and then use that new one to calculate the animation value.

For a very simple example, suppose we created an Interpolator that simply reversed the animation, by returning the inverse of the fraction. It would look something like this:

     public class ReverseInterpolator implements Interpolator {
        @Override 
        public float getInterpolation(float fraction) {
            return 1 - fraction;
        }
    }

This interpolator will cause the animation to calculate its end values at the beginning (when the input fraction is 0 and the interpolated fraction is therefore 1) and start values at the end (when the input fraction is 1 and the interpolated fraction is therefore 0). It will animate the values in-between to vary between those end values and start values, appropriately.

The built-in Interpolator classes in Android use similar (if more useful) functions, both simple (such as LinearInterpolator, which simply returns the input fraction) and more complex (such as PathInterpolator, which uses the values determined by quadratic or cubic bezier curves) to calculate fractions that result in all kinds of rich timing curves to suit most purposes. And if you can’t find what you want, it’s easy to implement your own.

In the meantime, look up from your screen. There’s a car coming.





