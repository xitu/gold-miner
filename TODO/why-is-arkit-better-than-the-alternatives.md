
> * 原文地址：[Why is ARKit better than the alternatives?](https://medium.com/super-ventures-blog/why-is-arkit-better-than-the-alternatives-af8871889d6a)
> * 原文作者：[Matt Miesnieks](https://medium.com/@mattmiesnieks)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/why-is-arkit-better-than-the-alternatives.md](https://github.com/xitu/gold-miner/blob/master/TODO/why-is-arkit-better-than-the-alternatives.md)
> * 译者：
> * 校对者：

# Why is ARKit better than the alternatives?

![](https://cdn-images-1.medium.com/max/1600/1*CMMUMdnNBmGdFf2fgegJJw.jpeg)

Apple’s announcement of ARKit at the recent WWDC has had a huge impact on the Augmented Reality eco-system. Developers are finding that for the first time a robust and (with IOS11) widely available AR SDK “just works” for their apps. There’s no need to fiddle around with markers or initialization or depth cameras or proprietary creation tools. Unsurprisingly this has led to a boom in demos (follow @madewitharkit on twitter for the latest). However most developers don’t know how ARKit works, or why it works better than other SDKs. Looking “under the hood” of ARKit will help us understand the limits of ARKit today, what is still needed & why, and help predict when similar capabilities will be available on Android and Head Mount Displays (either VR or AR).

I’ve been working in AR for 9 years now, and have built technology identical to ARKit in the past (sadly before the hardware could support it well enough). I’ve got an insiders view on how these systems are built and why they are built the way they are.

![](https://cdn-images-1.medium.com/max/1600/1*uh1y7QZUq87wawGFw2346g.jpeg)

This blog post is an attempt to explain the technology for people who are a bit technical, but not Computer Vision engineers. I know some simplifications that I’ve made aren’t 100% scientifically perfect, but I hope that it helps people understand at least one level deeper than they may have already.

**What technology is ARKit built on?**

![](https://cdn-images-1.medium.com/max/1600/1*kRZDY5t6kAiNSYa1HcfhPw.jpeg)

Technically ARKit is a Visual Inertial Odometry (VIO) system, with some simple 2D plane detection. VIO means that the software tracks your position in space (your 6dof pose) in real-time ie your pose is recalculated in between every frame refresh on your display, about 30 or more times a second. These calculations are done twice, in parallel. Your pose is tracked via the Visual (camera) system, by matching a point in the real world to a pixel on the camera sensor each frame. Your pose is also tracked by the Inertial system (your accelerometer & gyroscope — together referred to as the Inertial Measurement Unit or IMU). The output of both of those systems are then combined via a Kalman Filter which determines which of the two systems is providing the best estimate of your “real” position (referred to as Ground Truth) and publishes that pose update via the ARKit SDK. Just like your odometer in your car tracks the distance the car has traveled, the VIO system tracks the distance that your iPhone has traveled in 6D space. 6D means 3D of xyz motion (translation), plus 3D of pitch/yaw/roll (rotation).

The big advantage that VIO brings is that IMU readings are made about 1000 times a second and are based on acceleration (user motion). Dead Reckoning is used to measure device movement in between IMU readings. Dead Reckoning is pretty much a guess (!) just like if I asked you to take a step and guess how many inches that step was, you’d be using dead reckoning to estimate the distance. I’ll cover later how that guess is made highly accurate. Errors in the inertial system accumulate over time, so the more time between IMU frames or the longer the Inertial system goes without getting a “reset” from the Visual System the more the tracking will drift away from Ground Truth.

Visual / Optical measurements are made at the camera frame rate, so usually 30fps, and are based on distance (changes of the scene in between frames). Optical systems usually accumulate errors over distance (and time to a lessor extent), so the further you travel, the larger the error.

The good news is that the strengths of each system cancel the weaknesses of the other.

So the Visual and Inertial tracking systems are based on completely different measurement systems with no inter-dependency. This means that the camera can be covered or might view a scene with few optical features (such as a white wall) and the Inertial System can “carry the load” for a few frames. Alternatively the device can be quite still and the Visual System can give a more stable pose than the Inertial system. The Kalman filter is constantly choosing the best quality pose and the result is stable tracking.

So far so good, but what’s interesting is that VIO systems have been around for many years, are well understood in the industry, and there are quite a few implementations already in the market. So the fact that Apple uses VIO doesn’t mean much in itself. We need to look at why their system is so robust.

The second main piece of ARKit is simple plane detection. This is needed so you have “the ground” to place your content on, otherwise it would look like it’s floating horribly in space. This is calculated from the features detected by the Optical system (those little dots you see in demos) and the algorithm just averages them out as any 3 dots defines a plane, and if you do this enough times you can estimate where the real ground is. FYI these dots are often referred to as a “point cloud” which is another confusing term. These dots/points all together are a sparse point cloud, which is used for optical tracking. Sparse point clouds use much less memory and CPU time to track against, and with the support of the inertial system, the optical system can work just fine with a small number of points to track. This is a different type of point cloud to a dense point cloud that can look close to photorealism (note some trackers being researched can use a dense point cloud for tracking… so it’s even more confusing)

**Some mysteries explained**

As an aside…. I’ve seen people refer to ARKit as SLAM, or use the term SLAM to refer to tracking. For clarification, treat SLAM as a pretty broad term, like say “multi-media”. Tracking itself is a more general term where odometry is more specific, but they are close enough in practice with respect to AR. It can be confusing. There are lots of ways to do SLAM, and tracking is only one component of a comprehensive SLAM system. I view ARKit as being a light or simple SLAM system. Tango or Hololens’ SLAM systems have a greater number of features beyond odometry.

Two “mysteries” of ARKit are “how do you get 3D from a single lens?” and “how do you get metric scale (like in that tape measure demo)?”. The secret here is to have *really* good IMU error removal (ie making the Dead Reckoning guess highly accurate). When you can do that, here’s what happens:

To get 3D you need to have 2 views of a scene from different places, in order to do a stereoscopic calculation of your position. This is how our eyes see in 3D, and why some trackers rely on stereo cameras. It’s easy to calculate if you have 2 cameras as you know the distance between them, and the frames are captured at the same time. With one camera, you capture one frame, then move, then capture the second frame. Using IMU Dead Reckoning you can calculate the distance moved between the two frames and then do a stereo calculation as normal (in practice you might do the calculation from more than 2 frames to get even more accuracy). If the IMU is accurate enough this “movement” between the 2 frames is detected just by the tiny muscle motions you make trying to hold your hand still! So it looks like magic.

To get metric scale, the system also relies on accurate Dead Reckoning from the IMU. From the acceleration and time measurements the IMU gives, you can integrate backwards to calculate velocity and integrate back again to get distance traveled between IMU frames. The maths isn’t hard. What’s hard is removing errors from the IMU to get a near perfect acceleration measurement. A tiny error, which accumulates 1000 time a second for the few seconds that it takes you to move the phone, can mean metric scale errors of 30% or more. The fact that Apple has got this down to single digit % error is impressive.

**What about Tango & Hololens & Vuforia etc?**

![](https://cdn-images-1.medium.com/max/1600/1*fFJ9fSeTrjWPJJ-52qP6yA.jpeg)

So Tango is a brand, not really a product. It consists of a hardware reference design (RGB, fisheye, Depth cameras and some CPU/GPU specs) and a software stack which provides VIO (motion tracking), Sparse Mapping (area learning), and Dense 3D reconstruction (depth perception).

Hololens has exactly the same software stack, but includes some ASICs (which they call Holographic Processing Units) to offload processing from the CPU/GPU and save some power.

Vuforia is pretty much the same again, but it’s hardware independent.

All the above use the same VIO system (Tango & ARKit even use the same code base originally developed by FlyBy!). Neither Hololens or Tango use the Depth Camera for tracking (though I believe they are starting to integrate it to assist in some corner cases). So why is ARKit so good?

The answer is that ARKit isn’t really any better than Hololens (I’d even argue that Hololens’ tracker is the best on the market) but Hololens hardware isn’t widely available. Microsoft could have shipped the Hololens tracker in a Windows smartphone, but I believe they chose not to for commercial reasons (ie it would have added a fair bit of cost & time to calibrate the sensors for a phone that would sell in low volumes, and a MSFT version of ARKit would not by itself convince developers to switch from IOS/Android)

Google also could easily have shipped Tango’s VIO system in a mass market Android phone over 12 months ago, but they also chose not to. If they did this, then ARKit would have looked like a catch up, instead of a breakthrough. I believe (without hard confirmation) that this was because they didn’t want to have to go through a unique sensor calibration process for each OEM, where each OEMs version of Tango worked not as well as others, and Google didn’t want to just favor the handful of huge OEMs (Samsung, Huawei etc) where the device volumes would make the work worthwhile. Instead they pretty much told the OEMs “this is the reference design for the hardware, take it or leave it”. (Of course it’s never that simple, but that’s the gist of the feedback OEMs have given me). As Android has commoditized smartphone hardware, the camera & sensor stack is one of the last areas of differentiation so there was no way the OEMs would converge on what Google wanted. Google also mandated that the Depth Camera was part of the package, which added a lot to the BOM cost of the phone (and chewed battery), so that’s another reason the OEMs said “no thanks”! Since ARKit the world has changed…. it will be interesting to see whether (a) the OEMs find alternative systems to Tango ; or (b) there are concessions made by Google on the hardware reference design (and thus control of the platform).

So ultimately the reason ARKit is better is because Apple could afford to do the work to tightly couple the VIO algorithms to the sensors and spend *a lot* of time calibrating them to eliminate errors / uncertainty in the pose calculations.

It’s worth noting that there are a bunch of alternatives to the big OEM systems. There are many academic trackers (ORB Slam is a good one, OpenCV has some options etc) but they are nearly all Optical only (mono RGB, or Stereo, and/or Depth camera based, some use sparse maps, some dense, some depth maps and others use semi-direct data from the sensor. There are lots of ways to skin this cat). There are a number of startups working on tracking systems, Augmented Pixels has one that performs well, but at the end of the day any VIO system needs the hardware modelling & calibration to compete.

**I’m a Developer, what should I use & why? a.k.a. Burying the lede**

![](https://cdn-images-1.medium.com/max/1600/1*mNQavIaFI-ZB4Z7AacYMdQ.jpeg)

Start developing your AR idea on ARKit. It works and you probably already have a phone that supports it. Learn the HUGE difference in designing and developing an app that runs in the real world where you don’t control the scene vs. smartphone or VR apps where you control every pixel.

Then move onto Tango or Hololens. Now learn what happens when your content can interact with the 3D structure of the uncontrolled scene.

This is a REALLY STEEP learning curve. Bigger than from web to mobile or from mobile to VR. You need to completely rethink how apps work and what UX or use-cases make sense. I’m seeing lots of ARKit demos that I saw 4 years ago built on Vuforia and 4 years before that on Layar. Developers are re-learning the same lessons, but at much great scale. I’ve seen examples of pretty much every type of AR Apps over the years and am happy to give feedback and support. Just reach out.

I would encourage devs not to be afraid of building Novelty apps. Fart apps were the first hit on smartphones… also it’s very challenging to find use-cases that give Utility via AR on handheld see-through form-factor hardware.

**Its a very small world. Not many people can build these systems well.**

![](https://cdn-images-1.medium.com/max/1600/1*OpVtNYCakmdjhaFCNBAiTA.jpeg)

One fascinating and underappreciated aspect of how great quality trackers are built is that there are literally a handful of people in the world who can build them. The interconnected careers of these engineers has resulted in the best systems converging on monocular VIO as “the solution” for mobile tracking. No other approach delivers the UX (today).

VIO was first implemented at Boston military/industrial supplier Intersense in the mid 2000s. One of the co-inventors Leonid Naimark was the chief scientist at my startup Dekko in 2011. After Dekko proved that VIO could not run on an IPad 2 due to sensor limitations, Leonid went back to military contracting, but Dekko’s CTO Pierre Georgel is now a senior engineer on the Google Daydream team. Ogmento was founded by my Super Ventures partner Ori Inbar. Ogmento became FlyBy and the team there successfully built a VIO system on IOS leveraging an add-on fish eye camera. This code-base was licenced to Google which became the VIO system for Tango. Apple later bought FlyBy and the same codebase is the core of ARKit VIO. The CTO of FlyBy went on to build the tracker for Daqri, and is now at an autonomous robotics company, with the former Chief Scientst of Zoox, who did his post-doc at Oxford (alongside my co-founder at 6D.ai who currently leads the Active Vision Lab). The first mobile SLAM system was developed around 2007 at the Oxford Active Computing lab (PTAM) by George Klein who went on to build the VIO system for Hololens, along with David Nister, who left to build the autonomy system at Tesla. George’s fellow PhD student Gerhard Reitmayr led the development of Vuforia’s VIO system. The Eng leader of Vuforia, Eitan Pilipski is now leading AR software engineering at Snap. Key members of the research teams at Oxford, Cambridge & Imperial College developed the Kinect tracking systems, and now lead tracking teams at Oculus and Magic Leap.

Interestingly I’m not aware of any AR startups working in this domain led by engineering talent from this small talent pool, and founders from backgrounds in Robotics or other types of Computer Vision haven’t been able to demonstrate systems that work robustly in a wide range of environments.

I’ll talk a bit later about what the current generation of research scientists are working on. Hint: It’s not VIO.

**Performance is Statistics**

![](https://cdn-images-1.medium.com/max/1600/1*MwQ45PxH8q5TVqLhBMKJFA.jpeg)

AR systems never “work” or “don’t work”. It’s always a question of do things work good enough is a wide enough range of situations. Getting “better” ultimately is a matter of nudging the statistics further in your favor.

For this reason NEVER trust a demo of an AR App, especially if it’s been shown to be amazing on YouTube. There is a HUGE gap between something that works amazingly well in a controlled or lightly staged environment, and then it barely works at all for regular use. This situation just doesn’t exist for smartphone or VR app demos (eg imagine if Slack worked or didn’t work based on where your camera happened to be pointing or how you happened to move your wrist), so viewers are often fooled.

Here’s a specific technical example of why statistics end up determining how well a system works

In this image we have a grid which represents the digital image sensor in your camera. Each box is a pixel. For tracking to be stable, each pixel should match a corresponding point in the real world (assuming the device is perfectly still). However… the second image shows that photons are not that accommodating and various intensities of light fall wherever they want and each pixel is just the total of the photons that hit it. Any change in the light in the scene (a cloud passes the sun, the flicker of a fluorescent light etc) changes the makeup of the photons that hit the sensor, and now the sensor has a different pixel corresponding to the real world point. As far as the Visual tracking system is concerned, you have moved! This is the reason why when you see the points in the various ARKit demo’s they flicker on & off, as the system has to decide which points are “reliable” or not. Then it has to triangulate from those points to calculate the pose, averaging out the calculations to get the best estimate of what your actual pose is. So any work that can be done to ensure that statistical errors are removed from this process results in a more robust system. This requires tight integration & calibration between the camera hardware stack (multiple lenses & coatings, shutter & image sensor specifications etc) and the IMU hardware and the software algorithms.

**Integrating Hardware & Software**

![](https://cdn-images-1.medium.com/max/1600/1*LbUBiWNczz3hSzvxAxqgcw.jpeg)

Funnily enough, VIO isn’t that hard to get working. There are a number of algorithms published & quite a few implementations exist. It is **very** hard to get it working well. By that I mean the Inertial & Optical systems converge almost instantly onto a stereoscopic map, and metric scale can be determined with low single digit levels of accuracy. The implementation we built at Dekko for example required that the user made specific motions initially then moved the phone back & forth for about 30 seconds before it converged. To build a great inertial tracking system needs experienced engineers. Unfortunately there are only about 20 engineers on earth with the necessary skills and experience, and most of them work building cruise missile tracking systems, or mars rover navigation systems etc. Not consumer mobile.

So even if you have access to one of these people, everything still depends on having the hardware and software work in lockstep to best reduce errors. At it’s core this means an IMU that can be accurately modelled in software, full access to the entire camera stack & detailed specs of each component in the stack, and most importantly… the IMU and Camera need to be very precisely Clock Synched. The system needs to know exactly which IMU reading corresponds to the beginning of the frame capture, and which to the end. This is essential for correlating the two systems, and until recently was impossible as the hardware OEMs saw no reason to invest in this. This was the reason Dekko’s iPad 2 based system took so long to converge. The first Tango Peanut phone was the first device to accurately clock synch everything, and was the first consumer phone to offer great tracking. Today the systems on chips from Qualcom and others have a synched sensor hub for all the components to use which means VIO is viable on most current devices, with appropriate sensor Calibration.

Because of this tight dependency on hardware and software, it has been almost impossible for a software developer to build a great system without deep support from the OEM to build appropriate hardware. Google invested a lot to get some OEMs to support the tango hw spec. MSFT, Magic Leap etc are building their own hardware, and it’s ultimately why Apple has been so successful with ARKit as they have been able to do both.

**Optical Calibration**

![](https://cdn-images-1.medium.com/max/1600/1*oCmGDa6essRDMTC7v16aRA.jpeg)

In order for the software to precisely correlate whether a pixel on the camera sensor matches a point in the real world, the camera system needs to be accurately calibrated. There are two types of calibration:

Geometric Calibration: This uses a pinhole model of a camera to correct for the Field of View of the lens and things like the barrel effect of a lens. Bascially all the image warping due to the shape of the lens. Most software devs can do this step without OEM input using a checkerboard basic camera specs.

Photometric Calibration: This is a lot more involved and usually requires the OEMs involvement as it gets into the specifics of the image sensor itself, and any coatings on internal lenses etc. This calibration deals with color and intensity mapping. For example telescope attached cameras photographing far away stars need to know whether that slight change in light intensity on a pixel on the sensor is indeed a star, or just an aberation in the sensor or lens. The result for a tracker is much higher certainty that a pixel on the sensor does match a real world point, and thus the optical tracking is more robust with fewer errors.

In the slide image above, the picture of the various RGB photons falling into the bucket of a pixel on the image sensor illustrates the problem. Light from a point in the real world usually falls across the boundary of several pixels and each of those pixels will average the intensity across all the photons that hit it. A tiny change in user motion or a shadow in the scene, or a flickering fluorescent light will change which pixel best represents the real world point. This is the error that all these optical calibrations are trying to eliminate as best as possible.

**Inertial Calibration**

![](https://cdn-images-1.medium.com/max/1600/1*9p9WKsNb9MgGKFlyOhGhig.jpeg)

When thinking about the IMU, it’s important to remember it measures acceleration, not distance or velocity. Errors in the IMU reading accumlate over time, very quickly! The goal of calibration & modelling is to ensure the measurement of distance (double integrated from the acceleration) is accurate enough for X fractions of a second. Ideally this is a long enough period to cover when the camera loses tracking for a couple of frames as the user covers the lens or something else happens in the scene.

Measuring distance using the IMU is called Dead Reckoning. It’s basically a guess, but the guess is made accurate by modelling how the IMU behaves, finding all the ways it accumulates errors then writing filters to mitigate those errors. Imagine if you were asked to take a step then guess how far you stepped in inches. A single step & guess would have a high margin of error. If you repeatedly took thousands of steps, measured each one and learned to allow for which foot you stepped with, the floor coverings, the shoes you were wearing, how fast you moved, how tired you were etc etc then your guess would eventually become very accurate. This is bascially what happens with IMU calibration & modelling.

There are many sources of error. A robot arm is usually used to repeatedly move the device in exactly the same manner over & over and the outputs from the IMU are captured & filters written until the output from the IMU accurately matches the Ground Truth motion from the Robot arm. Google & Microsoft even sent their devices up into microgravity on the ISS or “zero gravity flights” to eliminate additional errors.

![](https://cdn-images-1.medium.com/max/1600/1*H-6eLqGWhy_SCHzvUWgqxw.jpeg)

This is just a few of the errors that have to be identified from a trace like the RGB lines in the graph…
This is even harder than it sounds to get really accurate. It’s also a PITA for an OEM to have to go through this process for all the devices in their portfolio and even then many devices may have different IMUs (eg a Galaxy 7 may have IMUs from Invensense or Bosch, and of course the modelling for the Bosch doesn’t work for the Invensense etc). This is another area where Apple has an advantage over Android OEMs.

**The Future of Tracking**

![](https://cdn-images-1.medium.com/max/1600/1*-5aMhxnmjzXOBc4-i0wPgg.jpeg)

So if VIO is what works today, what’s coming next and will it make ARKit redundant? Surprisingly VIO will remain the best way to track over a range of several hundred meters (for longer than that, the system will need to relocalize using a combination of GPS fused into the system plus some sort of landmark recognition). The reason for this is that even if other optical only systems get as accurate as VIO, they will still require more (GPU or camera) power, which really matters in a HMD. Monocular VIO is the most accurate lowest power, lowest cost solution

Deep Learning is really having an impact in the research community for tracking. So far the deep learning based systems are about 10% out wrt errors where a top VIO system is a fraction of a %, but they are catching up and will really help with outdoor relocalization.

Depth Cameras can help a VIO system in a couple of ways. Accurate measurement of ground truth & metric scale and edge tracking for low features scenes are the biggest benefits. They are very power hungry, so it only makes sense to run them at a very low frame rate and use VIO in between frames. They also don’t work outdoors as the background Infrared scatter from sunlight washes out the IR from the depth camera. They also have their range dependent on their power consumption, which means on a phone, very short range (a few meters). They are also expensive in terms of BOM cost, so OEMs will avoid them for high volume phones.

Stereo RGB or Fisheye lenses both help with being able to see a larger scene (and thus potentially more optical features eg a regular lens might see a white wall, but a fisheye could see the patterned ceiling and carpet as well — Tango and Hololens use this approach) and possibly getting depth info for a lower compute cost than VIO, though VIO does it just as accuarately for lower bom and power cost. Because the stereo cameras on a phone (or even a HMD) are close together, their accurate range is very limited for depth calculations (cameras a couple of cm apart can be accurate for depth up to a couple of meters).

The most interesting thing coming down the pipeline is support for tracking over much larger areas, especially outdoors for many km. At this point there is almost no difference between tracking for AR and tracking for self driving cars, except AR systems do it with fewer sensors & lower power. Because eventually any device will run out of room trying to map large areas, a cloud supported service is needed, and Google recently announced the Tango Visual Positioning Service for this reason. We’ll see more of these in coming months. It’s also a reason why everyone cares so much about 3D maps right now.

**The Future of AR Computer Vision**

![](https://cdn-images-1.medium.com/max/1600/1*4CYPyi8NYq9T8VcUNaZ0WQ.jpeg)

6Dof position tracking will be completely commoditized in 12–18 months, across all devices. What is still to be solved are things like:

3D reconstruction (Spatial Mapping in Hololens terms or Depth Perception in Tango terms). This is the system being able to figure out the shape or structure of real objects in a scene. It’s what allows the virtual content to collide into and hide behind (occlusion) the real world. It’s also the feature that confuses people as they think this means AR is now “Mixed” reality (thanks Magic Leap!). It’s always AR, just most of the AR people have seen has no 3D reconstruction support so the content appears to just move in front of real world objects. 3D reconstruction works by capturing a point cloud from the scene (today using a depth camera) then converting that into a mesh, and feeding the “invisible” mesh into Unity (along with the real world coordinates) and placing the real world mesh exactly on top of the real world as it appears in the camera. This means the virtual content appears to interact with the real world. Note ARKit does a 2D version of this today by detecting 2D planes. This is the minimum that is needed. Without a Ground Plane, the Unity content literally wouldn’t have a ground to stand on and would float around.

![](https://cdn-images-1.medium.com/max/1600/1*63S5wmcPciT0iDUdOiyTWw.jpeg)

Magic Leap’s demo showing occlusion of the Robot behind a table leg. No idea whether the table leg was reconstructed in real time & fed into Unity or they pre-modelled it and virtually put it in place over the real table by hand for this demo.
All the issues with Depth Cameras above still apply here, which is why it’s not widely available. Active research is underway to support real-time photorealistic 3D reconstruction using a single RGB camera. It’s about 12–18 months away from being seen in products. This is one major reason why I think “true” consumer AR HMD’s are still at *least* this far away.

![](https://cdn-images-1.medium.com/max/1600/1*dWuPiA8zq4x7T6db2lI7NA.jpeg)

The 3D recosntrctuion system of my old startup Dekko at work back in 2012 on an iPad 2. We had to include the grid otherwise users would not believe what they were seeing (that the system could understand the real world). The buggy has just done a jump & is partly hidden behind the tissue box
After 3D reconstruction there is a lot of interesting research going on around semanticly understanding 3D scenes. Nearly all the amazing computer vision deep learning that you’ve seen uses 2D images (regular photos) but for AR (and cars, drones etc) we need to have a semantic understanding of the world in 3D. New initiatives like ScanNet will help a lot, similar to the way ImageNet helped with 2D semantics.

![](https://cdn-images-1.medium.com/max/1600/1*5297b3XAehlprZaAI3PNuQ.jpeg)

An example of 3D semantic segmentation of a scene. The source image is at the bottom, above it is the 3D model (maybe built from stereo cameras, or LIDAR) and on top of is the segmentation via Deep Learning, so we can tell the sidewalk from the road. This is also useful for Pokemon Go so Pokemon are not placed in the middle of a busy road….
Then we need to figure out how to scale all this amazing tech to support multiple simultaneous users in real-time. It’s the ultimate MMORG.

![](https://cdn-images-1.medium.com/max/1600/1*6Dhoz_grn3D8ipadNlLm7Q.jpeg)

As the 3D reconstructions get bigger, we need to figure out how to host them in the cloud and let multiple users share (and extend) the models,
**The future of other parts of AR**

It’s beyond the scope of this post to get into all these (future posts?) but there is a lot of work to happen further up the tech stack:

- optics: Field of View, eyebox size, resolution, brightness, depth of focus, vergence accomodation all still need to be solved. I think we’ll see several “in between” HMD designs which only have limited sets of features, intending to “solve” only 1 problem (eg social signaling, or tracking, or an enterprise use case, or something else) before we see the ultimate consumer solution.
- rendering: making the virtual content appear coherent with the real world. Determining real light sources and virtually matching them so shadows & textures look right etc. This is basically what Hollywood SFX have been doing for years (so the avengers look real etc) but in real-time, on a phone, with no control over real world lighting or backgrounds etc. Non-trivial to say the least.
- Input: this is still a long way from being solved. Research indicates that a multi-modal input system gives by far the best results. Rumors indicate this is what Apple is going to ship. Multi-modal just means various input “modes” (gestures, voice, computer vision, touch, eye tracking etc) are all considered simultaneously by an AI to best understand a users intent.
- the GUI and Apps: There’s no such thing as an “app” as we think of them for AR. We just want to look at our Sonos and have the controls appear, virtually on the device. We don’t want to select a little square Sonos button. Or do we? What controls do we want always in our field of view (like a fighter pilot HUD) vs attached to the real word objects. No one has any real idea how this will play out, but it won’t be a 4 x 6 grid of icons.
- Social problems need to be solved. IMO only Apple & Snap have any idea how to sell fashion, and AR HMD’s will be a fashion driven purchase. This is probably a harder problem to solve than all the tech problems above.

Thank you for getting this far! Please reach out with any questions or comments or requests for future posts


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
