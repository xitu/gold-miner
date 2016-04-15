>* 原文链接 : [10 steps to better hybrid apps](https://medium.com/net-magazine/10-steps-to-better-hybrid-apps-e8e33831ea5e#.4fh1wbsy9)
* 原文作者 : [Oliver Lindberg](https://medium.com/@oliverlindberg)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


**With hybrid apps rising in popularity, a growing number of tools are being created to help developers create cross-platform apps efficiently.** [**James Miller**](https://twitter.com/jimhunty) **presents 10 tips to help you get the best results**

![](https://cdn-images-1.medium.com/max/1200/1*AaxKJp4gFBPiMv8mYqJvjA.jpeg)

<figcaption>Illustration by [Luke O’Neill](http://lukeoneill.co.uk)</figcaption>

<span>M</span>obile developers aren’t the only ones that are able to create applications for mobiles and tablets. Without knowing any device-specific code, web developers are now able to use HTML, CSS and JavaScript to build apps by using a native application wrapper. This uses the device’s web view to act as a browser to display the web-based code of the hybrid app. These 10 tips should help you to get the most out of your hybrid apps.

#### **1\. Planning**

Planning your app before you start developing will offer a smoother ride and more successful outcome. In this planning phase, there are a number of areas of the development process you should consider.

As hybrid apps use a web view, which is essentially a scaled-down browser, you need to anticipate that they will be vulnerable to the same problems that currently exist with legacy browsers. Understanding your target audience and their expectations will help you define the technical constraints of your app. This, alongside device profiling, can help identify potential performance targets to aim for.

When you know what your target audience is expecting, you’ll next need  
to consider distribution channels. Google Play and Apple’s App Store are the two most popular ecosystems. In order to get your app in these stores, you must ensure your apps meet their guidelines.

Google Play takes a more retrospective approach to app reviews, and publishing is relatively easy. However, complaints can result in your app being removed. Following the [guidelines](https://play.google.com/about/developer-content-policy.html?rd=1) makes it more likely your app will be featured.

Apple has stricter [guidelines](https://developer.apple.com/app-store/review/guidelines/) that can pose a challenge. You need to integrate the phone’s native functionality, rather than just building a web app. The camera, geolocation or other functions will do, and with the right frameworks these can be accessed through JavaScript plugins. Don’t include  
functionality just to get through the store guidelines, ensure it is something the user will actually want to use.

![](https://cdn-images-1.medium.com/max/800/1*KpdzFI7j0VnryX4qGKWIkQ.jpeg)

<figcaption>**Avoiding offence** Use Google Play’s content survey tool to remove countries you might offend from your launch list</figcaption>

#### 2\. Market considerations

Apps are a global product, but unlike the web, which is open, they are mainly accessible from country-specific app stores. Each country has different cultures and laws. It is important not to presume your app is appropriate for a global audience — launching in the wrong countries may  
do your brand more harm than good.

It is also important to be aware of network limitations in the areas you  
plan to release in. Not everywhere has lightning-fast mobile internet access  
or Wi-Fi access points around every corner. Even if your app is not targeting  
emerging markets, network connectivity can still be an issue. Aim to make the app lightweight on network requests, and try to keep them to a minimum.

#### 3\. Scalability

Most apps will require a network component, whether to log in or to keep data within the app up to date. This will require some form of server and  
API. As your app gains more users, the pressure will increase on your backend, increasing the likelihood of timeouts and errors. To avoid issues, it’s important to plan how your backend will grow. Your API should follow a RESTful interface pattern to give a standard to work from. Consider using authentication, as an open API could be abused. Endpoints must be managed correctly, as once the app is published it can take a few weeks  
to get an updated version launched and through the review process.

There may come a time when your API is receiving too many requests and  
falls over. Rather than investing in more servers, there are a number of Backend as a Service (BaaS) options, including [Parse](http://parse.com) and [Firebase](http://firebase.com), that can help deal with this. These store your data and often provide a standard  
API based on your data structure and methods for authentication. There are  
a number of free tiers depending on the usage. With global coverage, fantastic technology and a strong network, you know that your app’s network component will perform well.

![](https://cdn-images-1.medium.com/max/800/1*RslHAZKu3bZscXv6ERaHZQ.jpeg)

<figcaption>**Parse** Facebook’s answer to Backend as a Service can remove the need to invest in your own servers</figcaption>

#### 4\. Performance

With a hybrid app rendered in a web view, the age-old issue of multiple browsers and varying support levels across multiple operating systems  
arises. On the web this is tackled using progressive enhancement, and the same tactic can be used with hybrid apps to deliver a smooth experience across a range of different devices.

Having too many background processes running can drain your users’ battery and reduce performance over time. Consider building your app as a singlepage application using a framework like AngularJS or Ember.js. These enable you to structure your code, making your app more maintainable. The conventions used will ensure good performance and help reduce the possibility of memory leaks. A framework like Ionic, which encompasses Cordova, AngularJS and its own UI components, is great for making quick prototypes as well as finished products.

CSS animations will perform better than JavaScript on mobile devices. Try  
to aim for 60 frames per second to give the app a native feel, and use hardware acceleration where possible to give the animations some oomph.

![](https://cdn-images-1.medium.com/max/800/1*dKzEwQWP3ArLAUfSJh5ZWg.jpeg)

<figcaption>**Handy frameworks** The Ionic framework provides a structured approach to building your hybrid apps</figcaption>

#### 5\. Interaction design

Almost all mobile devices are primarily controlled by touch. With this is mind, try to think outside of the constraints of the web, and use simple, gesture-based interaction to make the app experience as intuitive as possible. Touch devices have no hover states, so consider alternative visual cues such as the use of active and visited states.

> Think outside of the constraints of the web, and use simple, gesture-based interaction to make the app feel as intuitive as possible

With touch devices, there can be a 300ms delay from when the user touches the screen to when the event is fired. This is the result of the web view waiting to verify a single or double tap. While it doesn’t sound that long,  
the delay is noticeable. To combat this, add the [FastClick](http://github.com/ftlabs/fastclick) library script to your project and instantiate it on the body.

#### 6\. Responsive design

Today’s device screen sizes vary greatly, using a wide range of resolutions. Fortunately the principles of responsive design also apply to hybrid apps and tablets. Concentrate on the smallest screen size for your chosen range of devices, and make choices on the breakpoints you wish to cover. Consider  
both landscape and portrait view. Either can be locked when building an app, which can help reduce complexity and drive user behaviour.

Think about how you use app design standards: flyout menus, fixed headers  
and list design. Limited screen size lends itself to using icons rather than text to tell the story, but labelling properly as well will improve accessibility. While users expect certain attributes, don’t let this constrain your design.

#### 7\. Images

High-definition screens are a priority for mobile device manufacturers. However, don’t forget that many users still use older devices with lower screen resolutions. Use the right images for your target market’s devices and ensure every image looks as good as it possibly can. Store images on the device when they are being reused often. File size can be bigger than you would usually use on a mobile site, but there must be consideration for  
the device’s memory. Use SVG where appropriate to maximise the visual  
output for Retina screens, but be wary of device support.

#### 8\. Network

Take an offline-first approach. With mobile devices there will be times when the user has no network connectivity, and their experience shouldn’t suffer as a result. Combat this by caching network requests in local storage to give an optimal experience in periods of low or no signal.

> Take an offline-first approach … cache network requests in local storage to give an optimal experience in periods of low signal

Keep scripts local. In web development, linking to external scripts increases  
performance, as they are more likely to be cached. This doesn’t fly with apps — when there is no network, the app still needs to work. Scripts don’t tend to bulk file size and the speed of access gives faster loading times and a native feel. If your user journey is fairly prescribed, try to preload data just ahead of time, to give a seamless experience.

#### 9\. Plugins

As mentioned previously, extending your web-based application by adding native functionality through use of the camera, geolocation or social sharing can greatly enhance the user experience. Usually you cannot access this native functionality through a mobile web browser, but within a hybrid  
application it is possible through the use of plugins.

Cordova, a hybrid application wrapper, has a large number of associated plugins that can be accessed using JavaScript. Check out [Plugreg](http://plugreg.com), which acts as a directory for these.

Be wary of third party plugins. Device OS development is rapid, and third party plugins without enough support can create problems, eat into battery life and may make your app unstable. Look for those that are highly rated within GitHub and are in active development.

#### 10\. Testing

Hybrid apps are, at their core, built with web technologies. This means the non-device functionality can be tested within a browser. Use task runners like gulp or Grunt to set up tools such as LiveReload to make an efficient  
workflow for concurrent development and testing.

The next step is emulation. Google Chrome offers [mobile emulation](https://developer.chrome.com/devtools/docs/device-mode), so you can test a wide range of screen resolutions from the most popular devices, which is useful for styling breakpoints. Apple offers the [iOS simulator](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/iOS_Simulator_Guide/Introduction/Introduction.html) as part of Xcode, and Google offers the [Android Emulator](http://developer.android.com/tools/help/emulator.html) as part of its developer tools.

These provide the opportunity to test your app on simulated devices, which  
is quicker than building to a physical device and means you can test native device functionality. The emulation performance is, however, dependent  
on the speed of your machine, and the Android emulator can be particularly  
slow. This has led to [Genymotion](http://genymotion.com) creating a rival product that emulates Android a lot faster.

As useful as simulators are, you should never launch an app unless you have  
tested it in full on at least one actual device. This will highlight performance  
issues and any pain points with regard to user interactions.

#### Conclusion

These 10 tips will provide a good starting point in turning your ideas into fully functioning mobile apps. However, as with all aspects of web development, the pace of hybrid app development is rapid. New tools and techniques appear almost daily as the community grows.

If you do decide to delve into the world of hybrid apps, the community  
is one of the most valuable resources. It is well worth coming to conferences  
and meetups, to keep up with the latest developments and to share your own creations. We’re looking forward to seeing what you come up with!

#### Popular hybrid app frameworks

[CORDOVA](http://cordova.apache.org)   
The original and most popular open source hybrid app platform. JS APIs  
give access to the phone’s native functionality. It has a CLI that aids the creation of cross-platform apps.

[PHONEGAP](http://phonegap.com)   
PhoneGap is an Adobe product built on top of Cordova. The two are  
essentially the same, but PhoneGap offers additional services, including  
app-building in the cloud and crosschannel marketing.

[IONIC](http://ionicframework.com)   
Ionic adds AngularJS to Cordova for business logic and its own UI  
framework for design conventions. It builds on Cordova’s CLI and adds  
to it with services like LiveReload to deployed devices. [Ionic Creator](http://creator.ionic.io) allows the creation of apps using its web interface.

[APPCELERATOR](http://appcelerator.com)   
This offers a single platform for building native and web apps, plus  
automation testing tools, real-time analytics and BaaS. It aims to provide  
everything you need to deploy and scale your app, and the service is free until your app reaches a store.

[COCOONJS](http://ludei.com/cocoonjs)   
CocoonJS provides an app wrapper that has a built-in and souped-up  
Canvas and WebGL engine. This makes it an ideal environment  
for games written using web technologies on iOS and Android.

