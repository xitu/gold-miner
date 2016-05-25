>* 原文链接 : [HOW TO BUILD A MATERIAL DESIGN PROTOTYPE USING SKETCH AND PIXATE - PART ONE](http://createdineden.com/blog/post/material-design-prototype-tutorial-part-1/)
* 原文作者 : Mike Scamell
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

<span>Have you ever had a great idea for an app or wanted to demonstrate to someone how you think it would work? Have any of these things ever held you back?</span>

*   <span>Lack of time to develop a proof of concept</span>
*   <span>You not sure how well your colour scheme, layout, animations etc. would look</span>
*   <span>You’re an app developer who’s not sure how to go about this design lark but you want to try it out</span>
*   <span>You’re an app designer who wants to learn how Sketch and Pixate may benefit your design and prototype process</span>
*   <span>You’re not sure if Material Design would improve your app but would like to see what it would look like (hopefully this one isn’t the case!)</span>

<span>If you can identify with any of these, or maybe you’re just inquisitive about either Sketch or Pixate, then I implore you to read on.</span>

<span>[Sketch](http://bit.ly/22RgdKX "Sketch design tool") and [Pixate](http://bit.ly/1M2DyBP "Pixate prototyping tool") are my favourite tools for mocking up simple designs and prototypes. I am an Android Developer by trade and I don’t have much interest in learning the learning the complexities of Adobe Illustrator or the like. A few months ago I started designing the [Fantasy Football Fix app](http://bit.ly/1Tb18sZ "Fantasy Football Fix"). I heard good things about Sketch and I had just read a [Tech Crunch article](http://tcrn.ch/1OkuP9R "Tech Crunch article") about Google’s acquisition of Pixate and decided to give them both a go.</span>

<span>Sketch is a design app that is easy and simple to use. The app splits design up into pages and artboards that allow you to group your designs. For example a page could consist of all the artboards for one feature of an app, say the login for instance. Or maybe one page for for beta/prototyping and one for the actual release designs. Regardless of how you do it, it is great for organising your designs. It also has plenty of [plugins for added functionality](http://bit.ly/1V9jYVN "Sketch plugins"). Some of my plugin highlights are:</span>

*   <span class="s2"></span><span class="s1">[Sketch Artboard Tricks](http://bit.ly/1RPufrh "Sketch Art board Tricks plugin") which can help rearrange your scattered artboards</span>
*   <span class="s2"></span><span class="s1">[Sketch Export Assets](http://bit.ly/1UEwVIU "Sketch Export Assets plugin") which easily helps you export your designs to iOS, Android and Windows Phone sizes</span>

Pixate is a prototyping from Google. It’s has predefined animations and interactions. It has accompanying mobile apps so you can interact with your prototypes on an Android on iOS device. It has cloud features which start at $5 per month. These allow you to share your prototypes to the cloud, so clients and colleagues can get access. I enjoy using Pixate as I find it has some similarities to coding when doing condition and referencing layers for animation. We’ll just be using the free version that allows you to share through your Wifi to the app on your device.  

<span>Another great thing about Pixate is that you can create your own Actions. These are scripts that you can write in a subset of Javascript to automate repetitive tasks or create common patterns. For example you could make an Action that fades a button and have it move 48px to the left, rather than having to use two steps every time. I have not used them yet but they seem handy. The ['Actions' feature](http://bit.ly/1ZMSPZK "Beta actions feature") is currently in beta.</span>

<span>In Part 1, I’ll be running you through importing assets to Sketch and using them to create a Login Screen. We’ll use this in Part 2 to create the start of the prototype in Pixate. In Part 3, I’ll provide you with all the assets you need to create the next stage of the prototype. This is so that we can speed things up a bit and get you to the juicy stuff, as i believe Sketch is pretty easy to get a grasp of.</span>

## Things you’ll need to make the super awesome prototype

*   <span>Sketch - $99 for full version but does have free trial</span>
*   <span>Pixate - Free but cloud features start at $5 per month (used in Part 2 and 3)</span>
*   [<span>Assets Sticker Sheet </span>](https://www.dropbox.com/s/6ykfx9gukoacgp0/Material%20Design%20Prototype%20Assets.sketch?dl=0 "Assets Sticker Sheet")
*   <span>Android device - You can use an iPhone, but an Android device is preferable. If you use an iOS device i cannot help you out if it doesn’t look right (used in Part 2 and 3)</span>

The colours used within the tutorial are as follows:  

*   <span>Primary - #4CAF50</span>
*   <span>Primary Dark - #388E3C</span>
*   <span>Accent - #D500F9</span>
*   <span>Login Screen Background - #E8F5E9</span>

<span>These are all available in the Assets Sketch file as well. Feel free to use your own!</span>

<span>Quick warning, i’m going to assume you have some sensibilities when it comes to creating this. If i leave something out i’ll assume it’s logical enough for you to work out yourself! This is not the complete, in depth, how to guide to using Sketch or Pixate. But if you feel like i’ve missed something important then please do drop me a comment.</span>

## Let’s make a login screen!

<span>Adding the email and password text fields</span>

<span>First of all open the Assets Sketch file provided. In this are all the components we’re going to be using to create our prototype. Everything you need for this tutorial is under the Login Screen Assets artboard.</span>

Open a new Sketch file and save it as something logical like “Material Design Prototype”. Next insert a new artboard using the “Insert” menu from the toolbar. From the right hand menu click the “Material Design” dropdown and select “Mobile Portrait”. If all’s gone well you should have a nice white rectangle on your screen.

![](http://ww2.sinaimg.cn/large/a490147fgw1f41t1ndhcpj20i50ef74u.jpg)  

<span>Let’s rename the artboard to “Login Screen” by right clicking on “Mobile Portrait” in the left hand menu and clicking "Rename". It sounds simple but making sure that everything is named will avoid confusion, as it’s very easy to get lost while creating the Login Screen.</span>

Let’s give the background some colour, while we’re at it. Select the Login Screen artboard from the left hand menu and some options should open up on the right hand side. Tick the “Background Color” box and then select the colour box next to it. Paste our background colour “E8F5E9” in to the “Hex” box and press enter. Et voila! A beautiful light green background. Have I mentioned green is my favourite colour?!  

<span>Do you notice how the size of the artboard is 360 x 640? This helps for exporting to screen densities for different Android devices like hdpi, xxhdpi etc. More on this later.</span>

At this point it’s going to be easier to have the Material Design Prototype and Assets Sketch files open side by side for easier drag and drop. Find the Login Screen artboard and find the text field asset and copy this into our login screen. Then rename “Hint Text” to “Email”. I placed mine in the middle of the screen. I’ve resized the text field asset so it is exactly 328 pixels. This gives a 16 pixel left and right margin which means we’re adhering to [Google Material Design guidelines](http://bit.ly/23YKwj9 "Google Material Design guidelines") on layout bounds. Copy and paste the text field asset again and make sure it’s 16 pixels below the email text field. Sketch will inform you of the distance between the two objects as you place it with a red line and number.

![](http://ww1.sinaimg.cn/large/a490147fgw1f41t28fkj4j20hl0cnt9c.jpg)  

## Adding a logo

<span>Now we’re going to add in our logo at the top, because you know… branding and stuff ;) Grab the Logo and place it above the email text field and password text field.</span>

We just need the disabled login button that we’ll be transforming later for our login operation. Copy this from Assets to our Login Screen. If all’s gone well you should have something that looks like this:

![](http://ww4.sinaimg.cn/large/a490147fgw1f41t2lrc8hj20hv0cxgmh.jpg)  

<span>Right we finally have our Login Screen! Well sort of. What we’ve created is our start state. We'll need some of the other components to create our filled in state.  
</span>

## Adding the filled in email and password

We need to copy and paste the email text field with input component. Place this on top of the email text field. This should just slot in over the top. Make sure the bottom lines match up. Now, hover over the email text field in the left hand menu and click the little eye that appears. The email text field should be hidden. You should only see the email text field with input. You’ll need to edit the actual text to something more relevant.

![](http://ww4.sinaimg.cn/large/a490147fgw1f41t2ynw6ej20hv0cxmy3.jpg)  

<span>Next we just have to repeat the process for the password text field. Make sure you are renaming the input fields in the left hand menu after you have copied them over. I’ve just used stars for the password text field with input to represent an entered password.</span>

Now you should have something that looks like this:

![](http://ww2.sinaimg.cn/large/a490147fgw1f41t4vfxw7j20i00d1wfm.jpg)

Next up is the other login buttons. It’s the same process for the buttons; copy, paste, place over the top, and hide the previous.

![](http://ww3.sinaimg.cn/large/a490147fgw1f41t584f7fj20i60d5q40.jpg)

## Adding a status bar

<span>Just one more little thing we’re missing. That’s the Status bar. When we’re in our prototype later on it won’t be displayed as the prototype goes full screen on the device. It could be left out, but i think adding it in makes it feel like you’re actually using a real app.</span>

Find the status bar in the assets folder, copy it across and place it at the top and centred. We added this last so that we make sure it is over the top of everything else, otherwise it wouldn’t be visible.

![](http://ww3.sinaimg.cn/large/a490147fgw1f41t5mjphxj20k60eft9w.jpg)

## Exporting for Pixate

Finally, we should now get all of our assets exported for using in Pixate. As we want our prototype to have a bit of movement we need to get the Login Screen back to basics. Hide everything thatwe’ve added to the Login Screen so far. Only the logo and status bar we imported should be left.

![](http://ww3.sinaimg.cn/large/a490147fgw1f41t60k3ysj20k60ef3zn.jpg)  

<span>Click on the Login Screen in the left hand menu. This should select the whole artboard for you. In the bottom right hand corner there should be some text, “Make Exportable”. Click this to make the Login Screen exportable and to open up a menu. This menu is handy, it can allow you to export your assets at various scales. This is great when trying to meet different device specs. Now that [VectorDrawableCompat](http://bit.ly/1P3A6RH "VectorDrawableCompat documentation") is out for Android, it’s not needed as much. Make the “Size” dropdown 3x and leave the suffix empty. This is also a nifty feature that lets you set some text for all the different size images e.g. login_screen_mdpi, login_screen_xxhdpi but we don’t need to use it. Lastly, make sure the “Include in Export” is ticked below “Background Color”. Without this the screen will be exported without our coloured background, which is not what we want! Click “Export Login Screen” and save it to some where appropriate. I placed mine in a folder call “Login Screen Assets”.</span>

The rest of the items need to be exported individually. Let’s start with the email text field. Make sure the email text field is visible first of all, otherwise when you export it you’ll be exporting nothing! Click on email text field in the left hand menu. Click “Make Exportable”. Make the “Size” 3xand leave the suffix empty. Then click “Export email text field” and save to your chosen location.

![](http://ww4.sinaimg.cn/large/a490147fgw1f41t6cn2ehj20k60ef3zv.jpg)  

<span>This now needs to be done for the rest of the left over items:</span>

*   <span>email text field with input</span>
*   <span>password text field</span>
*   <span>password text field with input</span>
*   <span>login button</span>
*   <span>raised login button</span>
*   <span>disabled login button</span>

Just make sure you’ve made them all visible before you export!
