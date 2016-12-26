> * 原文地址：[Building interfaces with ConstraintLayout
](https://medium.com/google-developers/building-interfaces-with-constraintlayout-3958fa38a9f7#.avb3mafbz)
* 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[]()
* 校对者：[]()

# Building interfaces with ConstraintLayout

[![](https://i.embed.ly/1/image?url=https%3A%2F%2Fi.ytimg.com%2Fvi%2FXamMbnzI5vE%2Fhqdefault.jpg&key=4fce0568f2ce49e8b54624ef71a8a5bd)](https://www.youtube.com/embed/XamMbnzI5vE?list=PLWz5rJ2EKKc_w6fodMGrA1_tsI3pqPbqa&listType=playlist&wmode=opaque&widget_referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F0a3cece4e79cc61b0f04ea610e0d2c12%3FpostId%3D3958fa38a9f7&enablejsapi=1&origin=https%3A%2F%2Fcdn.embedly.com&widgetid=1
)


If you’re just starting your adventure with ConstraintLayout, the new layout that’s available in a support library and is closely integrated with the visual UI editor in Android Studio 2.2, I recommend that you watch the introductory video above or work through [our codelab](https://codelabs.developers.google.com/codelabs/constraint-layout/#0) first.

Both the video and codelab introduce you to the basic concepts of handles, constraints and the UI controls in the layout editor, which will help you build interfaces quickly and in a visual way.

In this article I’d like to highlight recent additions to ConstraintLayout in Android Studio 2.3 (Beta): chains and ratios, as well as give some general ConstraintLayout tips and tricks.

#### Chains

Creating chains is a new feature that lets you position views along a single axis (horizontal or vertical), that conceptually is a bit similar to a LinearLayout. As implemented by ConstraintLayout, a chain is a series of views which are linked via bi-directional connections.

![](https://cdn-images-1.medium.com/max/1600/0*nnBhtpeHAkmPvfT7.)

To create a chain in the layout editor, select the views you wish to chain together, right click on one of the views and click on “Center views horizontally” (or “Center views vertically”).

![](https://cdn-images-1.medium.com/max/1600/0*GGOOXZi3nWsiVKgg.)

This creates the necessary connections for you. Moreover, a new button appears when you select any of the chain elements. It lets you toggle between three chain modes: Spread, Spread Inside, and Packed Chain.

![](https://cdn-images-1.medium.com/max/1600/1*ZJRM06bmnEj8YSCyOn2fNg.gif)

There are two additional techniques you can use when dealing with chains:

If you have a Spread or Spread Inside chain and any views in the chain have their size set to MATCH_CONSTRAINT (or “0dp”), the remaining space in the chain will be distributed among them according to weights defined in layout_constraintHorizontal_weight or layout_constraintVertical_weight.

![](https://cdn-images-1.medium.com/max/1600/1*HelCaZczLmEjXPO5iaAs7A.gif)

If you have a Packed chain, you can adjust the horizontal (or vertical) bias to move all elements of the chain left and right (or up and down).

![](https://cdn-images-1.medium.com/max/1600/1*D9Tp-QOkNVGan422xeo1Jg.gif)

#### Ratios

Ratios let you accomplish roughly the same thing as a [PercentFrameLayout](https://developer.android.com/reference/android/support/percent/PercentFrameLayout.html), i.e. restrict a View to a set width to height ratio, without the overhead of the additional ViewGroup in your hierarchy.

![](https://cdn-images-1.medium.com/max/2000/1*RfgavVsO88a44_F5xGnUog.gif)

To set a ratio for any view inside a ConstraintLayout:

1. Make sure at least one of the size constraints is dynamic, i.e. not “Fixed” and not “Wrap Content”.
2. Click the “Toggle aspect ratio constraint” that appears in the top left corner of the box.
3. Input the desired aspect ratio in width:height format, for example: 16:9

#### Guidelines

Guidelines are virtual views that help you position other views in the layout. They aren’t visible during runtime, but can be used to attach constraints to. To create a vertical or horizontal guideline, select it from the dropdown.

![](https://cdn-images-1.medium.com/max/1600/1*8KCJzbcyQJUHxyAJIVaUfg.gif)

Click on the newly added guideline to select and drag to move it to the desired position.

Click on the indicator at the top (or left) to toggle between guideline positioning modes: fixed distance from left/right (or top/bottom) in dp, and percentage of parent view width/height.

### Dealing with View.GONE

![](https://cdn-images-1.medium.com/max/1600/0*sgv4IU2rWyXBbPMR.)

When dealing with View.GONE visibility of Views in ConstraintLayout, you have more control compared to RelativeLayout. First of all, any View that is set to GONE shrinks to zero size in both dimensions, but still participates in calculating constraints. Any margins set on the constraints on this View are also set to zero.

![](https://cdn-images-1.medium.com/max/1200/1*reku7ldbZGxh7qG0PKrZ0g.gif)

In many cases, a set of views connected by constraints such as in the example above will just work when setting a view to GONE.

There is also a way to specify a different margin for a constraint in case a view to which the constraint is attached gets removed via GONE. Use one of the [*layout_goneMargin*](https://developer.android.com/reference/android/support/constraint/ConstraintLayout.html#GoneMargin)*Start* (…*Top*, …*End*, and …*Bottom*) attributes to do that.

![](https://cdn-images-1.medium.com/max/1600/1*sz63HAfIQL_5OrHSCfk3Rg.gif)

This enables handling more complex situations such as the one demonstrated above without code changes to handle the GONE state of certain Views.

#### Different kinds of centering

When I discussed the chains feature of ConstraintLayout, I mentioned one type of centering already. When you select a group of views and click on “Center horizontally” (or “center vertically”), you create a chain.

You can also use the same option when selecting just one view to center it between the closest views that it can attach its constraints to:

![](https://cdn-images-1.medium.com/max/1600/1*yP9P7Fnu4KfB2v1PCGPmtg.gif)

To ignore any other views and just center in the parent, choose the “Center horizontally/vertically in parent” option. Note that normally you will use this with a single view, as this does not create a chain.

![](https://cdn-images-1.medium.com/max/1600/1*1MIe7MsnTXKV6KttdaOtGA.gif)

Sometimes you might want to align two views of different sizes together according to their centers. When a view has two constraints that are pulling at it from two different sides, the view will stay centered between those two constraints (as long as the bias is set to 50%).

![](https://cdn-images-1.medium.com/max/1600/1*lqP6aGkko5sAC2DyC6TH4g.gif)

We can use the same approach to align the center of one view with one side of another, by connecting both constraints to the same handle:

![](https://cdn-images-1.medium.com/max/1600/1*a0pnMNpfUt8NJMY3KZGB0Q.gif)

#### Using Spaces for negative margins

A view in a ConstraintLayout cannot have negative margins (it’s not supported). However, with an easy trick you can have similar functionality by inserting a Space (which is essentially an empty View) and setting its size to the margin you want. Here’s how it looks in practice:

![](https://cdn-images-1.medium.com/max/1600/1*rlTnKZVFd8ftT0H8pcOYBQ.gif)

#### When to use Inference

When you invoke the “Infer constraints” command in the toolbar, the layout editor tries to figure out any missing constraints on the views in your ConstraintLayout and adds them automagically. It can work on a layout with no constraints whatsoever, but since it’s a difficult problem to create a whole layout correctly, you might get mixed results. That’s why I propose two approaches to using constraint inference:

The first approach is to create as many constraints by hand, so that your layout mostly works and is functional. Then, click infer for the few views that are still missing constraints. This can save you a little bit of work.

The other one is to start with positioning your views on the layout editor canvas without creating constraints, use infer and then change the preview device resolution. See which views resized and changed position incorrectly, fix those constraints then repeat with another resolution.

It all boils down to your preference really, as everyone will have different styles of creating constraints in their layouts, including crafting all of them manually.

#### Match parent is not supported

Use match_constraint (0 dp) instead and attach constraints to the sides of the parent view if you wish. This provides similar functionality with correct handling of margins. “Match parent” should not be used inside ConstraintLayout at all.
