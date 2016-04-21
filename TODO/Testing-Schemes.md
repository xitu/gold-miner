>* 原文链接 : [Using Xcode's Schemes to run a subset of your tests](http://artsy.github.io/blog/2016/04/06/Testing-Schemes/)
* 原文作者 : [Orta Therox](http://artsy.github.io/author/orta/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


[Eigen](https://github.com/artsy/eigen) has hit the point where testing is a chore. This is a positive sign, the app has grown in terms of size, complexity, and number of developers considerably over the last 3 years. The test suite makes us feel comfortable making changes.

On my fastest computer, we're just under a minute - `Executed 1105 tests, with 1 failure (0 unexpected) in 43.221 (48.201) seconds` for the whole suite. I think I could probably live with 20 seconds max. So I studied how [AppCode](https://www.jetbrains.com/objc/) handles running tests, and this will be an illustrated guide as to how you can easily run the subset of tests in Xcode based on their techniques.

I [have ideas](https://github.com/orta/life/issues/71) on how to improve time for testing in general, based on [Code Injection](http://artsy.github.io/blog/2016/03/05/iOS-Code-Injection/), but they aren't fully fleshed out and I expect it to be time-intensive to pull off. Time I haven't made yet.

### What are Schemes?

> An Xcode scheme defines a collection of targets to build, a configuration to use when building, and a collection of tests to execute.
> 
> You can have as many schemes as you want, but only one can be active at a time. You can specify whether a scheme should be stored in a project—in which case it’s available in every workspace that includes that project, or in the workspace—in which case it’s available only in that workspace. When you select an active scheme, you also select a run destination (that is, the architecture of the hardware for which the products are built).

To [quote Apple](https://developer.apple.com/library/ios/featuredarticles/XcodeConcepts/Concept-Schemes.html).

### Hatching a Scheme

The Eigen Test Suite is around 50 test classes, these look a bit like this:

![Tests](http://artsy.github.io/images/2016-04-06-Testing-Schemes/tests.png)

Before you start, you want to be able to say, "I want to only run tests for the Fairs section of Eigen", as that is where I will be working for the next few days. To get started, I need to create a new Scheme. You will have seen the schemes before when you click on the Target side of this Targer/Sim button in the top left of Xcode.

![Empty Scheme](http://artsy.github.io/images/2016-04-06-Testing-Schemes/empty_scheme.png)

This is what it looks like on mine, we want to create a new scheme. This brings up a modal window where you need to choose your App's target (this is so you can continue running by pressing `cmd + r`.)

![New Scheme](http://artsy.github.io/images/2016-04-06-Testing-Schemes/new_scheme.png)

I've called mine "Artsy just for Fairs", as I'm the only person who would see it, I can name it whatever I want. Clicking "OK" selects it, and hides the modal. You now need to go back to the target selector, and go to "Edit Schemes ..." to continue though.

![Edit Schemes](http://artsy.github.io/images/2016-04-06-Testing-Schemes/edit_schemes.png)

### Making Amends

OK, click on "Test" in the sidebar, and now you're in the Schemes Test editor. This is where you do the work.

![Empty Edit Schemes](http://artsy.github.io/images/2016-04-06-Testing-Schemes/empty_edit_schemes.png)

You need to hit the "+" in order to add your Test Target to the Scheme

![Test Scheme](http://artsy.github.io/images/2016-04-06-Testing-Schemes/test_scheme.png)

Select and "Add" you Targets. This adds the target, you then need to click the disclosure arrow in order to show all the Test Classes.

_OK, here's some magic_. Hold `alt` and click on the blue tickbox to the right of your test target to turn it off. Then click again, without `alt`. It should then deselect all of the classes. This is standard in all Mac apps, so go wild there.

![Deselect All](http://artsy.github.io/images/2016-04-06-Testing-Schemes/deselect_all.png)

This means you can go find the classes you do want to run, in my case that is the Test Classes relating to Fairs.

![Just The Good Tests](http://artsy.github.io/images/2016-04-06-Testing-Schemes/just_the_good_tests.png)

Now when I press `cmd + u` it will only run those test classes.

### Wrapping Up

Which means I can now get back to work at a reasonable pace. `Executed 15 tests, with 0 failures (0 unexpected) in 0.277 (0.312) seconds`. I can then run the full suite whenever I go and make a cup of tea.

_Note:_ If you want to avoid using the mouse to change scheme, the [key commands](http://artsy.github.io/images/2016-04-06-Testing-Schemes/next_prev.png) to change between visible schemes is `cmd + ctrl + [` and `cmd + ctrl + ]`.

