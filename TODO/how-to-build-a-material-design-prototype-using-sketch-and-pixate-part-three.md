>* 原文链接 : [HOW TO BUILD A MATERIAL DESIGN PROTOTYPE USING SKETCH AND PIXATE - PART THREE](http://createdineden.com/blog/post/how-to-build-a-material-design-prototype-using-sketch-and-pixate-part-three/?utm_source=androiddevdigest)
* 原文作者 : Mike Scamell
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 


<span>In [Part 2](http://gold.xitu.io/entry/574eb491d342d300434cec1c "Part 2") of the series, we looked at getting our assets from Sketch into Pixate and creating a simple login prototype.</span>

<span>In this final and concluding Part 3, we’re going to step it up a notch and produce a more detailed prototype. You should have completed [Part 1](http://gold.xitu.io/entry/574d062b2e958a0069335d8e "Part 1") and [Part 2](http://gold.xitu.io/entry/574eb491d342d300434cec1c "Part 2") before you start this, so if you haven’t already go and do them first.</span>

I’ve updated the [Sketch assets](https://www.dropbox.com/s/6ykfx9gukoacgp0/Material%20Design%20Prototype%20Assets.sketch?dl=0 "Material Design Prototype Sketch Assets") so that they include all that you need for Part 3, your job is to just get them all exported. Remember to export them at 3x so that they will look good on your phone. Feel free to customise them to your liking, just try and keep the sizing the same so that any measurements used in the tutorial are correct.  

## Let’s drawer on some inspiration

Lets start with adding a navigation drawer to our prototype. The [navigation drawer](https://www.google.com/design/spec/patterns/navigation-drawer.html "Navigation Drawer") is a common design pattern in apps today. It sometimes seems to rub people the wrong way but it’s still prevalent.

<span>Hide the _Login Screen_ by pressing the eye that appears when hovering over it in the layer menu. Create a new layer called “Navigation Drawer”. This will need to be 340x640, just like the sizing in the Sketch project. This includes 36 pixels of padding used to register swiping. This is so that we can pull the drawer out. The _Navigation Drawer_ needs to be placed to the left of _Login Screen_ so that we can swipe it in and out. The _Navigation Drawer_ layer X needs to be -304\. This is so that the handle area we accounted for can be swiped. Also, make sure to change the “Appearance” of the layer to make it transparent or there will be a grey bar to the right of the _Navigation Drawer_. Finally add the "Nav Drawer with 36dp drag area" image that you exported to the layer.</span><span>  
</span>

<span>So now we have the drawer on screen we can add a “Drag” interaction so it can be swiped/dragged out. Click and drag the “Drag” interaction onto the _Navigation Drawer_ layer. When you click on the _Navigation Drawer_, you should see “Drag” in the “Interactions” attribute in the right-hand menu.</span>

<span>Let’s configure the “Drag” interaction. We only want the _Navigation Drawer_ to move horizontally so select “Horizontal” on the “Move w/Drag” menu. We now need to set a maximum that the _Navigation Drawer_ can travel right. If we don’t we could drag the drawer all the way across the screen. In the first “Reference Edge” option make sure “Left” is selected and enter “-304” in the “Min position” box. This ensures the drawer never goes off screen to the point where we can’t drag it back in. Using the second “Reference Edge” option, first select “Right” and then enter “340” in “Max Position”. This will stop the _Navigation Drawer_ when its X gets to 340 when we’re dragging. With everything setup you should have something like this:</span>

![Prototype with Navigation Drawer](http://createdineden.com/media/1771/part-3-image-2.png?width=750&height=497)

## Drawing it out

We’ll add one more feature to our _Navigation Drawer_. This is so that when moving the drawer back we can let go of it earlier. It will then go offscreen automatically, meaning we don’t have to drag it all the way to the left.

![Put back in place properties](http://createdineden.com/media/1760/part-3-image-13.png?width=306&height=416)  
We need a “Move” animation for this, so drag this onto the _Navigation Drawer_. We’re going to name this interaction so we’re clearer on what it does. Name it “Put back in place”. This “Move” needs to be based on the _Navigation Drawer_  “Drag Release”. This is so the movement happens when the user has stopped dragging. Our animation has to be “With duration to final value”. Now we need our “IF” condition. We’re going to say that if the drawer is less than 340 we want the drawer to animate off screen. We then need to tell it where we want the drawer to animate to via the “Move To”. Select “Left” and then in the value box enter “-304”. Lastly, select “ease out” for “Easing Curve” and leave the default type to “quadratic”. this should make our drawer move back in a more natural fashion.

Ok time to test it out!

![](http://ww4.sinaimg.cn/large/a490147fgw1f4i39fizqwg205m0a0gre.gif)

<span>When we drag the drawer to the right it should stick in place. When we drag a bit left and let go it should move off screen. There’s more you could do to make it an accurate representation of the real navigation drawer, but that’s something you can explore yourself.  
</span>

## The Home Screen

<span>Right, we’re going to create our _Home Screen_. The _Home Screen_ will consist of two tabs, _Versions_ and _In Words_. _Versions_ will hold a list of Android versions that will be scrollable. _In Words_ will contain a bit of Dessert Ipsum for some content.</span>

<span>The first task is to get all the assets exported from the updated Sketch file for the _Home Screen_. The assets need to be exported at 3x. If you haven’t already you’ll need:</span>

*   <span>app and status bar</span>
*   <span>versions tab selected</span>
*   <span>in words tab selected</span>
*   <span>tab indicator</span>
*   <span>Version List</span>
*   <span>In Words Content</span>

<span>Go back to Pixate and import the exported assets.</span>

<span>We can now move on to building. Add a new layer called “Home Screen”. Resize it to the same size of the _Login Screen_, 360x640\. Make sure the new layer covers the whole of the _Login Screen_. We’ll worry about that later.</span>

<span>Now we need to add a new layer called “App and Status Bar”. This should be part of the _Home Screen_ layer. Add the “app and status bar“ image we exported from Sketch using the properties menu. Its size will need to be 360x136 and aligned to the top. Why 136 high instead of 128 as in the Sketch file? Well we need to account for the shadow, which Sketch ignores. Set the colour to transparent so that we can avoid any background grey seeping through. Ok you should have something like this:  
![Prototype with newly added Home Screen](http://createdineden.com/media/1770/part-3-image-3.png?width=750&height=476)</span>

## Just Tab it in

<span>Let’s get the tabs in now. We’re also going to add the functionality to switch between them.</span>

<div>We need two layers, both 180x48\. Name one “Versions Tab Selected” and the other “Background Tab Selected”. Make sure they are both part of the _Home Screen_ layer. The _Versions Tab Selected_ should be positioned at 0, 80\. The _Background Selected Tab_ needs a position of 180, 80.

![Prototype with tabs added](http://createdineden.com/media/1769/part-3-image-4.png?width=751&height=477)

</div>

<span>We’re missing one thing, the tab indicator. Add a new layer, call it “Tab Indicator” and make it 180x2 and make sure it’s part of the _Home Screen_ layer. This layer should be first in the layers hierarchy; above both the _Versions Tab_ and _Background Tab_. This means it will get drawn on top and we can see it. You then need to add the “tab indicator” image asset we exported earlier. The _Tab Indicator_ needs a position of 126, 0.![Prototype with tab indicator](http://createdineden.com/media/1768/part-3-image-5.png?width=735&height=462)</span>

## Animating the indicator

Ok so now we have all the items in place for us to get the tabs working like they would in a real app. What we want is the indicator to move to the respective tab that gets tapped. We’ll start with when the _Background Tab_ gets tapped.

<span>Drag a “Tap” interaction to the _Background Tab_. Now we need to configure the _Tab Indicator_ based on this tap interaction. Drag a “Move” animation to the _Tab Indicator_. Name this animation “Move on Background tap” so we know what this animation does. Select the “Based On” drop-down and select “Background Tab”. Under “Move To” we want to select “Right” and enter the value “360”. This will position our indicator under the _Background Tab_. Next, we need to select the “Easing Curve” so the tab movement is more natural. Change this to “ease out” and leave it set as “quadratic”. The last thing, change the “Duration” to “0.1” as we want to get it moved quickly like a real tab indicator. Here’s what your settings should look like:</span>

![Tab Indicator movement settings](http://createdineden.com/media/1767/part-3-image-6.png?width=306&height=451)

And here’s what it looks like in action:

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i3eljw7yg205m0a0dg4.gif)

<span>Now we need to get the _Tab Indicator_ to move back when the _Versions Tab_ gets tapped. This is just a repeat process from before, only using the _Versions Tab_. This is an exercise I’ll leave to you. Just remember to drag a “Tap” interaction to the _Versions Tab_ otherwise you won’t see it in the drop-down menu for “Based On”.</span><span>Upon completion, you should have an indicator that moves back and forth when you tap the tabs!</span>

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i3h4kcv9g205m0a074x.gif)

## You see me scrolling

<span>Now lets move on to putting a scrollable list into the app. We’ve already got the exported “Version List” asset from earlier so we can get started.</span>

<span>Create a new layer named “Version List”. The _Version List_ needs to part of the _Home Screen_ layer and is 360x1232\. This will make it longer than the screen but don’t worry about this, Pixate will help us out. Position the _Version List_ just below the toolbar, it should snap into place.  
![Prototype with Version List added](http://createdineden.com/media/1766/part-3-image-7.png?width=750&height=500)  
</span>

<span>Now we need to add the ability to scroll the list. Now you might think that we need to just add a “Scroll” interaction to the _Version List_. But what we actually have to do is define an area that can be scrolled.</span>

You’ll first need to hide the _Version List_ to make this a bit easier. We need to create a new layer called “Scroll” that’s within the _Home Screen_ layer. This layer needs to start below the app bar and tabs and fill to the bottom. Its size is 360x512\. Its x=0 and y=128\. This should give you a grey box onscreen. Now drag the _Version List_ on to the _Scroll Content_ layer to make it part of it. Unhide the _Version List_ and everything should look the same as before. Now if you run the prototype you should be able to scroll the _Version List_ up and down.

![](http://ww3.sinaimg.cn/large/a490147fgw1f4i3o07r4rg205m0a0qb9.gif)

## Switching Tabs

<span>So far we have a reasonably functional prototype but we’re still missing the ability to switch tabs. Let’s put that in now.</span>

<span>We need a new layer called “In Words” which needs to be part of the _Home Screen_ layer. This layer should be positioned to the right of the _Home Screen_ and sized 360x512\. Now add the “In Words Content” image to the layer. You should have something like this:  
![Prototype with In Words content](http://createdineden.com/media/1765/part-3-image-8.png?width=750&height=495)</span>

<span>We’ll need to add a new layer for our view pager. It will enable moving from one tab to another via a simple drag from the screen edges, just like a real app. This layer needs to be the lowest in the hierarchy of layers. It also needs to have the _In Words_ and _Scroll Content_ added to it so it knows what content it needs to move.  
![Layer hierarchy](http://createdineden.com/media/1773/screen-shot-2016-05-24-at-113710.png?width=280&height=248)  
</span>

Drag a “Scroll” interaction onto the _View Pager_ layer. Within this “Scroll” menu there should be an attribute called “Paging Mode”. Make sure you select “paging” from the drop down menu. If all has gone well you should now be able to swipe between screens!

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i3qpkr60g205m0a0gsi.gif)

## Moving the tab indicator on swipe

<span>We have one little thing we have left to do to finish the _Home Screen_. That’s to move the tab indicator when swiping between tabs.</span>

Drag a “Move” animation onto the _Tab Indicator_ and name it “Move on Swipe Left”. Here are the settings you need for it:  
![Tab Indicator left movement settings](http://createdineden.com/media/1764/part-3-image-9.png?width=306&height=447)

<span>Ok so here’s what we have. We base the movement of the tab on the _View Pager_ and we only act when the scrolling has ended. In our “IF” section we check to see if we are 360 away from our starting X, which would mean that we’re viewing the next tab. When this happens we want to move the left to 180 which should place the indicator underneath the _In Words_ tab. Next, we change the “Easing Curve” to “ease out” for a more natural movement just like before. Lastly, we change the duration to 0.1 so that the tab moves across as quick as possible.</span>

If you now swipe the screen the tab should now move too!

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i3xx41irg205m0a0q8k.gif)

<span>Now all you need to do is reverse this process to move the tab back when you swipe right. I’ll leave this as an exercise for you to do. I’ll give you this one line to help you out for the “IF” condition:</span>

<span>    view_pager.contentX == 0</span>

<span>When you have this figured out your _Tab Indicator_ should move back and forth as you swipe between tabs:  
</span>

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i3zyhs8lg205m0a0guf.gif)

## Finishing Touches

<span>All we need to do with our prototype is provide a transition from the _Login Screen_ to the _Home Screen_. You’ll need to make the _Login Screen_ visible in Pixate and that it is above _Home Screen_ in the layer hierarchy.![Prototype with Login Screen back in](http://createdineden.com/media/1763/part-3-image-10.png?width=749&height=499)</span>

<span>We’re going to add a simple scale animation when the user presses the login button. Drag a “Scale” animation onto the _Login Screen_ layer. Make sure it’s on the whole _Login Screen_ layer and not just a component of it. Here’s the settings you want for the animation:![Login Screen scale settings](http://createdineden.com/media/1762/part-3-image-11.png?width=305&height=452)</span>

We’ve based the animation on when the login button gets tapped, which only happens once the user has tapped both input fields. We’re scaling by factor and linking the X and Y (because we want it to scale down evenly). We set the “Scale” to “0x” which means that the _Login Screen_ will disappear. Then we set “ease out” and the “Duration” to “0.3” so that the animation doesn’t happen too quick.

Here’s what it should look like:

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i41gcndwg205m0a0wi2.gif)

<span>Finally, lets make sure that the _Navigation Drawer_ cannot be swiped out on the _Login Screen_. Here are the settings we need:![Navigation Drawer fade in settings](http://createdineden.com/media/1761/part-3-image-12.png?width=305&height=411)</span>

<span>In the “Properties” menu for the _Navigation Drawer_ reduce it’s “Opacity” to “0%”. This will mean it cannot be swiped on the _Login Screen_. Next, drag a “Fade” animation onto the _Navigation Drawer_ layer. Just like the previous scale animation for the _Login Screen_, we want this fade animation based on the login button press. We also want it at 100% so we can see the _Navigation Drawer_ completely. We delay the animation for 0.3 seconds so that the scale animation for the _Login Screen_ can play out.</span>

And that’s the final step! If all’s gone well you should have a simple material design prototype app that you can show off!

![](http://ww4.sinaimg.cn/large/a490147fgw1f4i43y44jwg205m0a0tcd.gif)

## The End

I hope you’ve enjoyed this tutorial series. There is a lot more you can do with Sketch and Pixate that can take you to the next level. If you’ve enjoyed using these tools I implore you to seek out more tutorials on them. There are a few things that you could do to improve this prototype such as:

*   <span>Implement screens based on those in the navigation drawer such as the logout button</span>
*   <span>Make detail screens for each Android version in the list</span>
*   <span>Improve the animation for removing the Login Screen</span>
*   <span>Improve the Navigation Drawer movement e.g. open when only dragged halfway</span>
*   <span>Utilise the unselected tabs in the Sketch assets file and make them show when the tab is not selected</span>

<span>If you do improve the prototype or come up with something better based off this tutorial then please get in touch with me and let me know. It’ll be great to see what you come up with. Find [Eden](https://twitter.com/CreatedInEden "Eden") on twitter and show them off!</span>

<span>Thanks for taking the time to follow along with the series and good luck with Sketch and Pixate!</span>

