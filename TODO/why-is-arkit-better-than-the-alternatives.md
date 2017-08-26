> 译者注： 一位虚拟现实（AR）业界大牛对于 ARKit 的全面解析，且远不止于 ARKit 。

> * 原文地址：[Why is ARKit better than the alternatives?](https://medium.com/super-ventures-blog/why-is-arkit-better-than-the-alternatives-af8871889d6a)
> * 原文作者：[Matt Miesnieks](https://medium.com/@mattmiesnieks)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/why-is-arkit-better-than-the-alternatives.md](https://github.com/xitu/gold-miner/blob/master/TODO/why-is-arkit-better-than-the-alternatives.md)
> * 译者：[曹真](https://github.com/LJ147)
> * 校对者：

# Why is ARKit better than the alternatives?
# ARKit 为什么如此优秀？
![](https://cdn-images-1.medium.com/max/1600/1*CMMUMdnNBmGdFf2fgegJJw.jpeg)

Apple’s announcement of ARKit at the recent WWDC has had a huge impact on the Augmented Reality eco-system. Developers are finding that for the first time a robust and (with IOS11) widely available AR SDK “just works” for their apps. There’s no need to fiddle around with markers or initialization or depth cameras or proprietary creation tools. Unsurprisingly this has led to a boom in demos (follow @madewitharkit on twitter for the latest). However most developers don’t know how ARKit works, or why it works better than other SDKs. Looking “under the hood” of ARKit will help us understand the limits of ARKit today, what is still needed & why, and help predict when similar capabilities will be available on Android and Head Mount Displays (either VR or AR).
 
苹果公司在近期的 WWDC 上公布的 ARKit 对增强现实（Augmented Reality）生态系统产生了巨大影响。开发人员第一次发现，使用强大而广泛应用的的 AR SDK（iOS 11）刚好适用于他们的应用程序。没有必要再关注标记、初始化、深度摄像机或专有创作工具等。毫无悬念，这引起了一阵开发的热潮（在Twitter上关注@madewitharkit 获取最新消息）。然而，大多数开发人员并不知道 ARKit 如何工作，或者它为什么比其他 SDK 更好。深度探究 ARKit 将帮助我们了解 ARKit 当前的局限性，还需要什么以及为什么，并且有助于预测 Android 和头戴式显示器（VR 或 AR）上的类似功能是否同样可用。

I’ve been working in AR for 9 years now, and have built technology identical to ARKit in the past (sadly before the hardware could support it well enough). I’ve got an insiders view on how these systems are built and why they are built the way they are.

我已经在 AR 领域工作了 9 年，并且在过去创建过与 ARKit 类似的技术（不幸的是那时候硬件设备还不能提高良好的支持）。因此我能够从内部看到这些系统是如何构建的，以及为什么这样构建。

![](https://cdn-images-1.medium.com/max/1600/1*uh1y7QZUq87wawGFw2346g.jpeg)

This blog post is an attempt to explain the technology for people who are a bit technical, but not Computer Vision engineers. I know some simplifications that I’ve made aren’t 100% scientifically perfect, but I hope that it helps people understand at least one level deeper than they may have already.


这篇文章面向初级开发者，而非专业计算机视觉工程师。我在文中给出的一些简化解释并非百分百科学，但我仍然希望能够对于读者更加深入的了解有一定的帮助。
**What technology is ARKit built on?**

**ARKit 基于什么技术构建?**

![](https://cdn-images-1.medium.com/max/1600/1*kRZDY5t6kAiNSYa1HcfhPw.jpeg)

Technically ARKit is a Visual Inertial Odometry (VIO) system, with some simple 2D plane detection. VIO means that the software tracks your position in space (your 6dof pose) in real-time ie your pose is recalculated in between every frame refresh on your display, about 30 or more times a second. These calculations are done twice, in parallel. Your pose is tracked via the Visual (camera) system, by matching a point in the real world to a pixel on the camera sensor each frame. Your pose is also tracked by the Inertial system (your accelerometer & gyroscope — together referred to as the Inertial Measurement Unit or IMU). The output of both of those systems are then combined via a Kalman Filter which determines which of the two systems is providing the best estimate of your “real” position (referred to as Ground Truth) and publishes that pose update via the ARKit SDK. Just like your odometer in your car tracks the distance the car has traveled, the VIO system tracks the distance that your iPhone has traveled in 6D space. 6D means 3D of xyz motion (translation), plus 3D of pitch/yaw/roll (rotation).

从技术上来讲，ARKit 是一种视觉惯性测距（VIO）系统，兼具一些简单的 2D 平面检测。 VIO 意味着该软件实时跟踪你在空间中的位置（你的 6DOF 姿势），你的姿势在显示器上的每个画面刷新之间重新计算，每秒大约 30 次或更多。这些计算是并行完成两次。通过视觉（相机）系统跟踪你的姿势，通过将现实世界中的一个点与摄像机传感器上的每个像素匹配。惯性系统（你的加速度计和陀螺仪——合称为惯性测量单元或 IMU ）也跟踪你的姿势。然后，这两个系统的输出通过卡尔曼滤波器进行组合，卡尔曼滤波器确定两个系统中的哪一个提供了你的“真实”位置的最佳估计，并通过 ARKit SDK 发布姿势更新。就像你车内的里程表跟踪车辆所经过的距离，VIO 系统跟踪你的 iPhone 在 6D 空间中行驶的距离。 6D 表示 xyz 运动（平移）的 3 个维度，加上俯仰/偏转/滚动（旋转）的 3 个维度 。

The big advantage that VIO brings is that IMU readings are made about 1000 times a second and are based on acceleration (user motion). Dead Reckoning is used to measure device movement in between IMU readings. Dead Reckoning is pretty much a guess   just like if I asked you to take a step and guess how many inches that step was, you’d be using dead reckoning to estimate the distance. I’ll cover later how that guess is made highly accurate. Errors in the inertial system accumulate over time, so the more time between IMU frames or the longer the Inertial system goes without getting a “reset” from the Visual System the more the tracking will drift away from Ground Truth.

VIO带来的最大优势是 IMU 读数大约是每秒 1000 次，并且基于加速度（用户运动）。航位推算用于测量 IMU 读数之间的设备移动。就像我想要采取一步，猜测这个步骤有多少英寸，你会用推算来估计距离。我稍后会介绍一下这个猜测是否非常准确。惯性系统中的误差会随着时间累积，所以 IMU 帧之间的时间越长，或者惯性系统未从视觉系统获得“重置”的时间越长，跟踪也将与真实值差别越大。

Visual / Optical measurements are made at the camera frame rate, so usually 30fps, and are based on distance (changes of the scene in between frames). Optical systems usually accumulate errors over distance (and time to a lessor extent), so the further you travel, the larger the error.
视觉/光学测量以相机帧速率进行，通常为 30fps，并且基于距离（帧之间的场景的变化）。光学系统通常会在距离上累积误差，因此路程越远，误差也就越大。

The good news is that the strengths of each system cancel the weaknesses of the other.
好消息是，系统能够通过彼此的优势互补消除这些缺陷。

So the Visual and Inertial tracking systems are based on completely different measurement systems with no inter-dependency. This means that the camera can be covered or might view a scene with few optical features (such as a white wall) and the Inertial System can “carry the load” for a few frames. Alternatively the device can be quite still and the Visual System can give a more stable pose than the Inertial system. The Kalman filter is constantly choosing the best quality pose and the result is stable tracking.

因此，视觉和惯性跟踪系统基于完全不同的测量系统，彼此之间没有相互依赖关系。这意味着相机可以被遮盖，或者可能会看到具有很少光学特征（例如白色墙壁）的场景，这时候惯性系统可以继续完成少量帧数的任务。如果说该设备可以保持静止，这时候视觉系统可以给出比惯性系统更稳定的姿势。卡尔曼滤波器不断选择最佳姿势来实现稳定跟踪。

So far so good, but what’s interesting is that VIO systems have been around for many years, are well understood in the industry, and there are quite a few implementations already in the market. So the fact that Apple uses VIO doesn’t mean much in itself. We need to look at why their system is so robust.

有趣的是，VIO 系统已经存在了很多年，在行业中也能被很好地理解，并且市场上已经有很多实现。所以苹果使用 VIO 这一事实并不意味着什么。我们需要看看为什么他们的系统如此强大。

The second main piece of ARKit is simple plane detection. This is needed so you have “the ground” to place your content on, otherwise it would look like it’s floating horribly in space. This is calculated from the features detected by the Optical system (those little dots you see in demos) and the algorithm just averages them out as any 3 dots defines a plane, and if you do this enough times you can estimate where the real ground is. FYI these dots are often referred to as a “point cloud” which is another confusing term. These dots/points all together are a sparse point cloud, which is used for optical tracking. Sparse point clouds use much less memory and CPU time to track against, and with the support of the inertial system, the optical system can work just fine with a small number of points to track. This is a different type of point cloud to a dense point cloud that can look close to photorealism (note some trackers being researched can use a dense point cloud for tracking… so it’s even more confusing)

ARKit 的第二个主要部分是简单的平面检测。这是必要的，这样你才有平面来放置你的内容，否则它看起来像在空间浮动。这是根据光学系统检测到的特征（你在演示中看到的那些小点）计算出来的，并且算法只需将它们平均化，因为任何 3 个点定义一个平面，如果你花了足够多的时间在这上面，你可以估计真实值。这些点通常被称为另一个混乱的术语：“点云”。这些点都是稀疏点云，用于光学跟踪。稀疏点云使用更少的内存和CPU时间跟踪，并且在惯性系统的支持下，光学系统可以使用更少的点来进行追踪。这是一种不同类型的点云到密集点云，可以看起来接近真实感（注意一些正在处于研究阶段的跟踪器可以使用密集点云进行跟踪，所以这更让人觉得困惑）
**Some mysteries explained**

As an aside…. I’ve seen people refer to ARKit as SLAM, or use the term SLAM to refer to tracking. For clarification, treat SLAM as a pretty broad term, like say “multi-media”. Tracking itself is a more general term where odometry is more specific, but they are close enough in practice with respect to AR. It can be confusing. There are lots of ways to do SLAM, and tracking is only one component of a comprehensive SLAM system. I view ARKit as being a light or simple SLAM system. Tango or Hololens’ SLAM systems have a greater number of features beyond odometry.
一点题外话，我看到人们将 ARKit 称为 SLAM，或者使用术语 SLAM 来指代跟踪。为了澄清，将 SLAM 视为一个相当广泛的术语，比如说“多媒体”。跟踪本身是一个更通用的术语，其中测距更加具体，但在实践中它们和 AR 关系更加密切。这可能令人困惑。有很多方法可以实现 SLAM，跟踪只是综合 SLAM 系统的一个组成部分。我认为 ARKit 是一个轻型或简单的 SLAM 系统。Tango 或 Hololens 的 SLAM 系统具有超越距离测量的特征。

Two “mysteries” of ARKit are “how do you get 3D from a single lens?” and “how do you get metric scale (like in that tape measure demo)?”. The secret here is to have *really* good IMU error removal (ie making the Dead Reckoning guess highly accurate). When you can do that, here’s what happens:

ARKit 的两个“奥秘”是：

* 如何从一个镜头获得3D？
* 如何获得公制尺度（就像那个卷尺演示）？


秘密就在于要很好的去除 IMU 错误（即使是推测非常准确）。当你可以做到这一点时，会发生什么：


To get 3D you need to have 2 views of a scene from different places, in order to do a stereoscopic calculation of your position. This is how our eyes see in 3D, and why some trackers rely on stereo cameras. It’s easy to calculate if you have 2 cameras as you know the distance between them, and the frames are captured at the same time. With one camera, you capture one frame, then move, then capture the second frame. Using IMU Dead Reckoning you can calculate the distance moved between the two frames and then do a stereo calculation as normal (in practice you might do the calculation from more than 2 frames to get even more accuracy). If the IMU is accurate enough this “movement” between the 2 frames is detected just by the tiny muscle motions you make trying to hold your hand still! So it looks like magic.

要获得 3D，你需要从不同的地方获得 2 个场景的视图，才能对你的位置进行立体计算。这是我们的眼睛在 3D 中看到的，也是为什么一些跟踪器依靠立体相机。如果你有两台摄像机，你可以很方便地知道它们之间的距离，同时帧的捕获也能做到实时。使用一个摄像头，你可以捕获一帧，然后移动，接着捕获第二帧。，你可以通过使用 IMU 计算两帧之间移动的距离，然后进行正常的立体声计算（实际上，你可以超过 2 帧来进行计算，以获得更高的精度）。如果 IMU 足够准确，则可以通过你尝试握住手的微小肌肉运动来检测 2 帧之间的“运动”！所以这看起来像魔术。
To get metric scale, the system also relies on accurate Dead Reckoning from the IMU. From the acceleration and time measurements the IMU gives, you can integrate backwards to calculate velocity and integrate back again to get distance traveled between IMU frames. The maths isn’t hard. What’s hard is removing errors from the IMU to get a near perfect acceleration measurement. A tiny error, which accumulates 1000 time a second for the few seconds that it takes you to move the phone, can mean metric scale errors of 30% or more. The fact that Apple has got this down to single digit % error is impressive.

要获得公制尺度，系统还依赖于 IMU 的准确的航位推算。 从 IMU 给出的加速度和时间测量值，你可以向后积分以计算速度并再次集成以获得 IMU 帧之间的距离。 数学上并不难。难的事从 IMU 消除错误以获得接近完美的加速度测量。一个微小的错误，会在你移动手机的这段时间以每秒 1000 次的速度累计，最终可能会导致 30％ 或更多的公制尺度误差。事实上，苹果已经把这个错误率下降到 0.01 以内，令人印象深刻。
**What about Tango & Hololens & Vuforia etc?**

![](https://cdn-images-1.medium.com/max/1600/1*fFJ9fSeTrjWPJJ-52qP6yA.jpeg)

So Tango is a brand, not really a product. It consists of a hardware reference design (RGB, fisheye, Depth cameras and some CPU/GPU specs) and a software stack which provides VIO (motion tracking), Sparse Mapping (area learning), and Dense 3D reconstruction (depth perception).
所以说 Tango 是一个品牌，而不是真正的产品。它包括硬件参考设计（RGB，鱼眼，深度相机和一些CPU / GPU规格）和提供 VIO（运动跟踪），稀疏映射（区域学习）和密集3D重建（深度感知）的软件堆栈。
Hololens has exactly the same software stack, but includes some ASICs (which they call Holographic Processing Units) to offload processing from the CPU/GPU and save some power.
Hololens 具有完全相同的软件堆栈，但包括一些 ASIC（他们称之为全息处理单元）从 CPU / GPU 卸载处理并节省一些电源。

Vuforia is pretty much the same again, but it’s hardware independent.
Vuforia 几乎是一样的，但它是硬件独立的。
All the above use the same VIO system (Tango & ARKit even use the same code base originally developed by FlyBy!). Neither Hololens or Tango use the Depth Camera for tracking (though I believe they are starting to integrate it to assist in some corner cases). So why is ARKit so good?
以上所有使用相同的 VIO 系统（Tango ＆ ARKit 甚至使用最初由 FlyBy 开发的相同的代码库！）。 Hololens 或 Tango 都不使用深度相机进行跟踪（虽然我相信他们开始在某些方面整合它）。那么为什么 ARKit 这么优秀呢？
The answer is that ARKit isn’t really any better than Hololens (I’d even argue that Hololens’ tracker is the best on the market) but Hololens hardware isn’t widely available. Microsoft could have shipped the Hololens tracker in a Windows smartphone, but I believe they chose not to for commercial reasons (ie it would have added a fair bit of cost & time to calibrate the sensors for a phone that would sell in low volumes, and a MSFT version of ARKit would not by itself convince developers to switch from IOS/Android)
答案是 ARKit 并不比 Hololens 好（我甚至认为 Hololens 的追踪器是市场上最好的），但是Hololens 的硬件并没有广泛普及。微软可能会在 Windows 智能手机中搭载 Hololens 跟踪器，但我相信他们这样选择是出于商业原因（它会增加相当多的成本和时间来校准低价出售的手机的传感器，而 ARKit的 MSFT 版本本身不会说服开发人员从 iOS / Android 切换）

Google also could easily have shipped Tango’s VIO system in a mass market Android phone over 12 months ago, but they also chose not to. If they did this, then ARKit would have looked like a catch up, instead of a breakthrough. I believe (without hard confirmation) that this was because they didn’t want to have to go through a unique sensor calibration process for each OEM, where each OEMs version of Tango worked not as well as others, and Google didn’t want to just favor the handful of huge OEMs (Samsung, Huawei etc) where the device volumes would make the work worthwhile. Instead they pretty much told the OEMs “this is the reference design for the hardware, take it or leave it”. (Of course it’s never that simple, but that’s the gist of the feedback OEMs have given me). As Android has commoditized smartphone hardware, the camera & sensor stack is one of the last areas of differentiation so there was no way the OEMs would converge on what Google wanted. Google also mandated that the Depth Camera was part of the package, which added a lot to the BOM cost of the phone (and chewed battery), so that’s another reason the OEMs said “no thanks”! Since ARKit the world has changed…. it will be interesting to see whether (a) the OEMs find alternative systems to Tango ; or (b) there are concessions made by Google on the hardware reference design (and thus control of the platform).

谷歌本可以 12 个月前在大众市场的安卓手机中轻松交付 Tango 的 VIO 系统，但他们仍然没有这么做。如果他们这样做了，那么 ARKit 就会看起来像是追上了上了他们的进度，而不是自己（苹果公司）做出了重大突破。我相信（没有百分百的把握），这是因为他们不想为每个 OEM 都进行独特的传感器校准过程，每个 OEM 厂商的版本都不如其他 OEM，而谷歌不希望只是少数几家巨大的 OEM（三星，华为等）。相反，他们告诉 OEM 厂商：“这是硬件的参考设计，要么接受要么出局”。 当然这并不简单，但这正是 OEM 厂商给予的反馈意见。随着安卓已经将智能手机硬件商品化，相机和传感器堆栈是最后的差异化领域之一，因此 OEM 厂商无法融合谷歌的需求。Tango 还强制说，深度相机是包装的一部分，这增加了 BOM 的手机成本（和咀嚼电池），这是 OEM 厂商拒绝的另一个原因！由于 ARKit 的出现，世界已经改变了。看看最后是 OEM 找到了 Tango 的替代系统，还是谷歌对硬件参考设计作出让步（从而控制平台）。

So ultimately the reason ARKit is better is because Apple could afford to do the work to tightly couple the VIO algorithms to the sensors and spend *a lot* of time calibrating them to eliminate errors / uncertainty in the pose calculations.
所以 ARKit 更好的原因是因为苹果公司有能力将 VIO 算法紧密耦合到传感器上，花很多时间进行校准，以消除姿态计算中的错误/不确定性。

It’s worth noting that there are a bunch of alternatives to the big OEM systems. There are many academic trackers (ORB Slam is a good one, OpenCV has some options etc) but they are nearly all Optical only (mono RGB, or Stereo, and/or Depth camera based, some use sparse maps, some dense, some depth maps and others use semi-direct data from the sensor. There are lots of ways to skin this cat). There are a number of startups working on tracking systems, Augmented Pixels has one that performs well, but at the end of the day any VIO system needs the hardware modelling & calibration to compete.

值得注意的是，大型 OEM 系统有很多替代方案。 有很多学术追踪器（ORB Slam是一个很好的选择，OpenCV 有一些选项等），但它们几乎都是光学（单 RGB 或立体声，和/或深度相机，有些使用稀疏的地图、有些是密集、有些是深度、有些是地图以及其余的使用传感器的半直接数据）。有许多创业公司正在研究跟踪系统，增强像素这一点表现良好，但是最终任何 VIO 系统都需要硬件建模和校准来进行竞争。

**I’m a Developer, what should I use & why? a.k.a. Burying the lede**
**我是一名开发者，我应该使用什么以及为什么？**

![](https://cdn-images-1.medium.com/max/1600/1*mNQavIaFI-ZB4Z7AacYMdQ.jpeg)

Start developing your AR idea on ARKit. It works and you probably already have a phone that supports it. Learn the HUGE difference in designing and developing an app that runs in the real world where you don’t control the scene vs. smartphone or VR apps where you control every pixel.

首先应用 ARKit 来实现你的 idea。它非常好用而且你可能已经有一个支持它的手机。逐渐了解设计和开发一个实际应用程序之间的巨大差别，这个阶段你不需要控制场景和每一个像素。
Then move onto Tango or Hololens. Now learn what happens when your content can interact with the 3D structure of the uncontrolled scene.

然后开始学习 Tango 或 Hololens 。这时候要深入了解当你的内容与不受控场景的 3D 结构进行交互发生了什么。

This is a REALLY STEEP learning curve. Bigger than from web to mobile or from mobile to VR. You need to completely rethink how apps work and what UX or use-cases make sense. I’m seeing lots of ARKit demos that I saw 4 years ago built on Vuforia and 4 years before that on Layar. Developers are re-learning the same lessons, but at much great scale. I’ve seen examples of pretty much every type of AR Apps over the years and am happy to give feedback and support. Just reach out.

这是一个**非常陡**的学习曲线。比从网络到移动或从移动到 VR 更大。你需要彻底重新思考应用程序的工作原理以及 UX 或用例是否有意义。我看到很多建立在 ARKit 上的示例，也看到 4 年前建立在 Vuforia 和在 Layar上的示例。开发人员正在重新学习相同的课程，但规模很大。几年来，我看到了几乎所有类型的 AR Apps 的示例，我很乐意提供反馈和支持。欢迎随时联系我。

I would encourage devs not to be afraid of building Novelty apps. Fart apps were the first hit on smartphones… also it’s very challenging to find use-cases that give Utility via AR on handheld see-through form-factor hardware.

我鼓励开发人员不要害怕开发新奇的应用程序。应用程序是智能手机的第一击。
 

**Its a very small world. Not many people can build these systems well.**
**这是一个非常小的世界。 但没多少人能很好地构建这些系统。**

![](https://cdn-images-1.medium.com/max/1600/1*OpVtNYCakmdjhaFCNBAiTA.jpeg)

One fascinating and underappreciated aspect of how great quality trackers are built is that there are literally a handful of people in the world who can build them. The interconnected careers of these engineers has resulted in the best systems converging on monocular VIO as “the solution” for mobile tracking. No other approach delivers the UX (today).

如何建立高质量的追踪者的一个令人着迷和低估的方面是，世界上只有少数人可以搭建它们。这些工程师的相互关联的职业生涯使得将单眼 VIO 融合的最佳系统成为移动跟踪的“解决方案”。现在没有其他途径提供这样的 UX。

VIO was first implemented at Boston military/industrial supplier Intersense in the mid 2000s. One of the co-inventors Leonid Naimark was the chief scientist at my startup Dekko in 2011. After Dekko proved that VIO could not run on an IPad 2 due to sensor limitations, Leonid went back to military contracting, but Dekko’s CTO Pierre Georgel is now a senior engineer on the Google Daydream team. Ogmento was founded by my Super Ventures partner Ori Inbar. Ogmento became FlyBy and the team there successfully built a VIO system on IOS leveraging an add-on fish eye camera. This code-base was licenced to Google which became the VIO system for Tango. Apple later bought FlyBy and the same codebase is the core of ARKit VIO. The CTO of FlyBy went on to build the tracker for Daqri, and is now at an autonomous robotics company, with the former Chief Scientst of Zoox, who did his post-doc at Oxford (alongside my co-founder at 6D.ai who currently leads the Active Vision Lab). The first mobile SLAM system was developed around 2007 at the Oxford Active Computing lab (PTAM) by George Klein who went on to build the VIO system for Hololens, along with David Nister, who left to build the autonomy system at Tesla. George’s fellow PhD student Gerhard Reitmayr led the development of Vuforia’s VIO system. The Eng leader of Vuforia, Eitan Pilipski is now leading AR software engineering at Snap. Key members of the research teams at Oxford, Cambridge & Imperial College developed the Kinect tracking systems, and now lead tracking teams at Oculus and Magic Leap.

VIO 于二十世纪中叶由波士顿军工/工业供应商 Intersense 构建。联合创始人之一的 Leonid Naimark 是 2011 年 Dekko 的首席科学家。由于传感器的限制， VIO 被证实无法在 iPad 2 上运行。Leonid 继续完成军事合同，而 Dekko 的首席技术官 Pierre Georgel 现在则是谷歌 Daydream 团队的高级工程师。 Ogmento 由我的 Super Ventures 合作伙伴 Ori Inbar 创立。 Ogmento 成为 FlyBy，并且在那里的团队成功地构建了一个使用附加鱼眼相机的 iOS 上的VIO系统。该代码库已经授权给谷歌，成为 Tango 的 VIO 系统。苹果后来买了 FlyBy，同样的代码库是 ARKit VIO 的核心。 FlyBy 的首席技术官继续为 Daqri 建立了跟踪器，现在是一家自主机器人公司，与前任首席科学家 Zoox合作。第一个移动 SLAM 系统是在 2007 年左右在牛津由 George Klein 和在特斯拉建立自主系统的 David Nister等合作开发的，他们接下来为 Hololens 建立 VIO 系统，以及。乔治的博士生Gerhard Reitmayr 领导了 Vuforia 的 VIO 系统的发展。 牛津大学剑桥皇家学院研究团队的主要成员开发了 Kinect 跟踪系统，现在在 Oculus 和 Magic Leap 领导跟踪团队。

Interestingly I’m not aware of any AR startups working in this domain led by engineering talent from this small talent pool, and founders from backgrounds in Robotics or other types of Computer Vision haven’t been able to demonstrate systems that work robustly in a wide range of environments.

有趣的是，我不知道在这个领域工作的哪些 AR 创业公司是由这个小型人才库的工程人才领导的，而来自机器人技术或其他类型的计算机视觉背景的创始人还没有能够展示在广泛工作的系统环境范围。
I’ll talk a bit later about what the current generation of research scientists are working on. Hint: It’s not VIO.
稍后我会谈谈当前研究科学家正在开展的工作。 提示：不是VIO。
**Performance is Statistics**
数据代表着性能
![](https://cdn-images-1.medium.com/max/1600/1*MwQ45PxH8q5TVqLhBMKJFA.jpeg)

AR systems never “work” or “don’t work”. It’s always a question of do things work good enough is a wide enough range of situations. Getting “better” ultimately is a matter of nudging the statistics further in your favor.
AR 系统从来没有奏效或不奏效。把一项事情做的应用的足够宽泛总是一件很好的事情。“获得更好的成绩”总是意味着将统计数据朝着有利于你的方向推进。

For this reason NEVER trust a demo of an AR App, especially if it’s been shown to be amazing on YouTube. There is a HUGE gap between something that works amazingly well in a controlled or lightly staged environment, and then it barely works at all for regular use. This situation just doesn’t exist for smartphone or VR app demos (eg imagine if Slack worked or didn’t work based on where your camera happened to be pointing or how you happened to move your wrist), so viewers are often fooled.

基于以上原因，不要信任 AR App 的演示示例，特别是那些在 YouTube 上展现惊人效果的。因为在人为控制或预布置的环境中表现良好，不代表能够很好的应用到实际中，这两者之间仍然存在很大的差距。那些演示的效果不能在智能手机或 VR 应用程序上复现（例如，如果松弛成功或根据你的相机碰巧指向的位置或者你如何碰巧移动手腕时无法使用），所以观众往往会被愚弄。

Here’s a specific technical example of why statistics end up determining how well a system works

这是一个具体的技术示例关于为什么统计数据最终确定系统的运行情况。

In this image we have a grid which represents the digital image sensor in your camera. Each box is a pixel. For tracking to be stable, each pixel should match a corresponding point in the real world (assuming the device is perfectly still). However… the second image shows that photons are not that accommodating and various intensities of light fall wherever they want and each pixel is just the total of the photons that hit it. Any change in the light in the scene (a cloud passes the sun, the flicker of a fluorescent light etc) changes the makeup of the photons that hit the sensor, and now the sensor has a different pixel corresponding to the real world point. As far as the Visual tracking system is concerned, you have moved! This is the reason why when you see the points in the various ARKit demo’s they flicker on & off, as the system has to decide which points are “reliable” or not. Then it has to triangulate from those points to calculate the pose, averaging out the calculations to get the best estimate of what your actual pose is. So any work that can be done to ensure that statistical errors are removed from this process results in a more robust system. This requires tight integration & calibration between the camera hardware stack (multiple lenses & coatings, shutter & image sensor specifications etc) and the IMU hardware and the software algorithms.
在这个图像中，我们有一个代表相机中的数字图像传感器的网格。每个框都是一个像素。为了跟踪稳定，每个像素应该匹配现实世界中的一个对应点（假设设备完全静止）。然而，第二个图像显示光子不是那么匹配，并且各种光线的强度会下降到任何他们想要的地方，每个像素只是光子的总数。场景中的光线变化（云通过太阳，荧光灯闪烁等）改变击中传感器的光子的组成，现在传感器具有与现实世界点对应的不同像素。就视觉跟踪系统而言，你已经移动了！这就是为什么当你看到各种 ARKit 演示文稿中的点数闪烁时，系统必须确定哪些点是“可靠”的。那么它必须从这些点进行三角测量来计算姿势，对计算结果进行均值处理，以获得对实际姿势的最佳估计。因此，任何能够确保统计错误从此过程中移除的工作都将确保一个更健壮的系统。这需要相机硬件堆栈（多个透镜和涂层，快门和图像传感器规格等）以及 IMU 硬件和软件算法之间的紧密集成和校准。

**Integrating Hardware & Software**
**集成硬件和软件**
![](https://cdn-images-1.medium.com/max/1600/1*LbUBiWNczz3hSzvxAxqgcw.jpeg)

Funnily enough, VIO isn’t that hard to get working. There are a number of algorithms published & quite a few implementations exist. It is **very** hard to get it working well. By that I mean the Inertial & Optical systems converge almost instantly onto a stereoscopic map, and metric scale can be determined with low single digit levels of accuracy. The implementation we built at Dekko for example required that the user made specific motions initially then moved the phone back & forth for about 30 seconds before it converged. To build a great inertial tracking system needs experienced engineers. Unfortunately there are only about 20 engineers on earth with the necessary skills and experience, and most of them work building cruise missile tracking systems, or mars rover navigation systems etc. Not consumer mobile.

有趣的是，VIO 不难正常运转。现如今存在很多已发布的算法以及对应的算法实现。但是让 VIO 运作的**非常**良好却很难。这意味着惯性和光学系统几乎实时融合到立体地图上，并且可以用低的单位数精度来确定度量标度。我们在 Dekko 建立的实施要求用户一开始做出特定的姿势，然后将手机前后移动约 30 秒才能聚合。建立一个伟大的惯性跟踪系统需要有经验的工程师。不幸的是，地球上只有大约 20 名工程师具有必要的技能和经验，而且其中大多数工程师正在建造巡航导弹跟踪系统，或者是火星漫游者导航系统等。

So even if you have access to one of these people, everything still depends on having the hardware and software work in lockstep to best reduce errors. At it’s core this means an IMU that can be accurately modelled in software, full access to the entire camera stack & detailed specs of each component in the stack, and most importantly… the IMU and Camera need to be very precisely Clock Synched. The system needs to know exactly which IMU reading corresponds to the beginning of the frame capture, and which to the end. This is essential for correlating the two systems, and until recently was impossible as the hardware OEMs saw no reason to invest in this. This was the reason Dekko’s iPad 2 based system took so long to converge. The first Tango Peanut phone was the first device to accurately clock synch everything, and was the first consumer phone to offer great tracking. Today the systems on chips from Qualcom and others have a synched sensor hub for all the components to use which means VIO is viable on most current devices, with appropriate sensor Calibration.

所以即使你可以接触到这些人之一，所有的事情仍然取决于硬件和软件是否处于锁定状态，以最大限度地减少错误。在这个核心上，这意味着可以通过软件准确建模 IMU，完全访问整个摄像机堆栈以及堆叠中每个组件的详细规格，最重要的是 IMU 和摄像头需要非常精确地进行时钟同步。系统需要准确知道哪个 IMU 读取对应于帧捕获的开始，哪个到底是什么。这对于两个系统的关联至关重要，直到最近才是不可能的，因为硬件 OEM 厂商没有理由投资于此。这就是 Dekko 基于 iPad 2 的系统花费了很长时间才能融合的原因。第一个 Tango Peanut 手机是准确时钟同步所有内容的第一个设备，并且是第一个提供良好跟踪的消费者手机。今天，Qualcom 等的芯片系统都有一个同步的传感器集线器，用于所有组件的使用，这意味着 VIO 在大多数当前设备上可行，并配有合适的传感器校准。

Because of this tight dependency on hardware and software, it has been almost impossible for a software developer to build a great system without deep support from the OEM to build appropriate hardware. Google invested a lot to get some OEMs to support the tango hw spec. MSFT, Magic Leap etc are building their own hardware, and it’s ultimately why Apple has been so successful with ARKit as they have been able to do both.

由于硬件和软件的紧密依赖，软件开发人员几乎不可能在没有 OEM 的深入支持的情况下构建一个伟大的系统来构建合适的硬件。 谷歌投入了大量资金，让一些 OEM 厂商支持 Tango 高清规格。 MSFT，Magic Leap 等正在建立自己的硬件。苹果之所以能够在 ARKit 上取得如此巨大的成功就是因为它已经能够实现两者（软硬件）的协调统一。
 
**Optical Calibration**
**光学校准**
![](https://cdn-images-1.medium.com/max/1600/1*oCmGDa6essRDMTC7v16aRA.jpeg)

In order for the software to precisely correlate whether a pixel on the camera sensor matches a point in the real world, the camera system needs to be accurately calibrated. There are two types of calibration:
为了使软件能够精确校准摄像机传感器上的像素是否现实世界中的点匹配，摄像机系统需要精确校准。有两种类型的校准：

Geometric Calibration: This uses a pinhole model of a camera to correct for the Field of View of the lens and things like the barrel effect of a lens. Bascially all the image warping due to the shape of the lens. Most software devs can do this step without OEM input using a checkerboard basic camera specs.
几何校准：使用相机的针孔模型来校正镜头的视场和镜头的镜筒效果。由于透镜的形状，所有的图像都会变形。大多数软件开发人员可以在没有 OEM 输入的情况下使用棋盘基本相机规格进行此步骤。

Photometric Calibration: This is a lot more involved and usually requires the OEMs involvement as it gets into the specifics of the image sensor itself, and any coatings on internal lenses etc. This calibration deals with color and intensity mapping. For example telescope attached cameras photographing far away stars need to know whether that slight change in light intensity on a pixel on the sensor is indeed a star, or just an aberation in the sensor or lens. The result for a tracker is much higher certainty that a pixel on the sensor does match a real world point, and thus the optical tracking is more robust with fewer errors.
光度校准：这是更多的参与，通常需要 OEM 参与图像传感器本身的细节，内部透镜等的任何涂层。此校准处理颜色和强度映射。例如，远摄恒星拍摄的望远镜连接的摄像机需要知道传感器上的像素上的光强度的轻微变化确实是星形，还是传感器或透镜中的像差。跟踪器的结果比传感器上的像素匹配真实世界点的确定性更高，因此光学跟踪更加鲁棒，误差更少。

In the slide image above, the picture of the various RGB photons falling into the bucket of a pixel on the image sensor illustrates the problem. Light from a point in the real world usually falls across the boundary of several pixels and each of those pixels will average the intensity across all the photons that hit it. A tiny change in user motion or a shadow in the scene, or a flickering fluorescent light will change which pixel best represents the real world point. This is the error that all these optical calibrations are trying to eliminate as best as possible.

在上面的幻灯片图像中，落入图像传感器上的像素的桶中的各种 RGB 光子的图片说明了问题。来自现实世界中的一点的光通常落在几个像素的边界上，并且这些像素中的每一个将平均所有击中它的光子的强度。用户运动或场景阴影的微小变化，或闪烁的荧光灯会改变哪个像素最能代表现实世界的点。这是所有这些光学校准都尽可能地消除的错误。

**Inertial Calibration**

![](https://cdn-images-1.medium.com/max/1600/1*9p9WKsNb9MgGKFlyOhGhig.jpeg)

When thinking about the IMU, it’s important to remember it measures acceleration, not distance or velocity. Errors in the IMU reading accumlate over time, very quickly! The goal of calibration & modelling is to ensure the measurement of distance (double integrated from the acceleration) is accurate enough for X fractions of a second. Ideally this is a long enough period to cover when the camera loses tracking for a couple of frames as the user covers the lens or something else happens in the scene.
在考虑 IMU 时，记住测量加速度而非距离或速度至关重要。 IMU 中的错误随着时间的推移积累速度非常快！校准和建模的目标是确保距离的测量（双加速度加速度）对 X 秒的精度足够高。理想情况下，这是一个足够长的时期，以避免当用户覆盖镜头或场景中发生的其他事情时，相机在几帧内失去跟踪目标。

Measuring distance using the IMU is called Dead Reckoning. It’s basically a guess, but the guess is made accurate by modelling how the IMU behaves, finding all the ways it accumulates errors then writing filters to mitigate those errors. Imagine if you were asked to take a step then guess how far you stepped in inches. A single step & guess would have a high margin of error. If you repeatedly took thousands of steps, measured each one and learned to allow for which foot you stepped with, the floor coverings, the shoes you were wearing, how fast you moved, how tired you were etc etc then your guess would eventually become very accurate. This is bascially what happens with IMU calibration & modelling.
使用 IMU 测量距离称为推算。这基本上是一个猜测，但是通过对 IMU 的行为进行建模，找出所有的方法来积累错误，然后编写过滤器来减轻这些错误。想象一下，如果你被要求走一步然后猜测你踩了几英寸。单步猜测会有很高的误差。如果你反复采取数千步骤，从而衡量每一个，并学习你迈出哪一只脚、地板、你穿的鞋子、你的移动速度、你的疲劳程度等等，那么猜测最终会变得非常准确。这是基本的 IMU 校准和建模原理。

There are many sources of error. A robot arm is usually used to repeatedly move the device in exactly the same manner over & over and the outputs from the IMU are captured & filters written until the output from the IMU accurately matches the Ground Truth motion from the Robot arm. Google & Microsoft even sent their devices up into microgravity on the ISS or “zero gravity flights” to eliminate additional errors.
有很多错误来源。 机器人臂通常用于以完全相同的方式重复地移动设备，并且捕获来自 IMU 的输出并写入滤波器，直到来自 IMU 的输出与来自机器人臂的真实运动精确匹配。谷歌和微软甚至在 ISS 或“零重力航班”上发送了微型重力，以消除额外的错误。

![](https://cdn-images-1.medium.com/max/1600/1*H-6eLqGWhy_SCHzvUWgqxw.jpeg)

This is just a few of the errors that have to be identified from a trace like the RGB lines in the graph…
这只是一些错误，必须从跟踪中识别，如图中的RGB线...

This is even harder than it sounds to get really accurate. It’s also a PITA for an OEM to have to go through this process for all the devices in their portfolio and even then many devices may have different IMUs (eg a Galaxy 7 may have IMUs from Invensense or Bosch, and of course the modelling for the Bosch doesn’t work for the Invensense etc). This is another area where Apple has an advantage over Android OEMs.
这听起来更难准确。 OEM也是一个 PITA，必须对其组合中的所有设备进行此过程，即使这样，许多设备也可能会有不同的 IMU（例如，Galaxy 7 可能拥有来自 Invensense 或 Bosch 的 IMU，当然也可以为 博世不适用于Invensense等）。 这是苹果相对于 Android OEM 的优势的另一个领域。

**The Future of Tracking**
**追踪的未来**

![](https://cdn-images-1.medium.com/max/1600/1*-5aMhxnmjzXOBc4-i0wPgg.jpeg)

So if VIO is what works today, what’s coming next and will it make ARKit redundant? Surprisingly VIO will remain the best way to track over a range of several hundred meters (for longer than that, the system will need to relocalize using a combination of GPS fused into the system plus some sort of landmark recognition). The reason for this is that even if other optical only systems get as accurate as VIO, they will still require more (GPU or camera) power, which really matters in a HMD. Monocular VIO is the most accurate lowest power, lowest cost solution
如果 VIO 是现在所呈现的样子，那么接下来会发生什么？它会使 ARKit 变得多余吗？令人惊讶的是，VIO 仍然是追踪数百米范围内最好的方法（对于更长的时间，系统将需要使用融合到系统中的 GPS 组合重新定位加上某种地标识别）。这样做的原因是，即使其他光学系统只能像 VIO 一样准确，他们仍然需要更多（ GPU 或摄像头）电源，这在 HMD 中非常重要。单眼 VIO 是最准确、最低功耗以及最低成本的解决方案。

Deep Learning is really having an impact in the research community for tracking. So far the deep learning based systems are about 10% out wrt errors where a top VIO system is a fraction of a %, but they are catching up and will really help with outdoor relocalization.
深入学习真正对研究界有追踪的影响。到目前为止，基于深度学习的系统大约是 10％ 的错误率，而顶级的 VIO 系统是前者错误率的一部分，但它们正在相互追赶，并将在未来真正有助于户外重定位。
Depth Cameras can help a VIO system in a couple of ways. Accurate measurement of ground truth & metric scale and edge tracking for low features scenes are the biggest benefits. They are very power hungry, so it only makes sense to run them at a very low frame rate and use VIO in between frames. They also don’t work outdoors as the background Infrared scatter from sunlight washes out the IR from the depth camera. They also have their range dependent on their power consumption, which means on a phone, very short range (a few meters). They are also expensive in terms of BOM cost, so OEMs will avoid them for high volume phones.
深度相机可以通过几种方式帮助 VIO 系统。对于低特征场景，准确测量地面真值、度量标度和边缘跟踪是最大的好处。它们非常耗费能源，因此以非常低的帧速率，并且在帧之间使用 VIO 运行它们很有意义。它们不能在户外运行因为红外线散射从阳光中洗出红外线从深度相机。它们的工作范围也取决于它们的功耗，这意味着在手机上只有很短的工作距离。它们在 BOM 成本方面也很昂贵，因此 OEM 将避免使用大容量手机。

Stereo RGB or Fisheye lenses both help with being able to see a larger scene (and thus potentially more optical features eg a regular lens might see a white wall, but a fisheye could see the patterned ceiling and carpet as well — Tango and Hololens use this approach) and possibly getting depth info for a lower compute cost than VIO, though VIO does it just as accuarately for lower bom and power cost. Because the stereo cameras on a phone (or even a HMD) are close together, their accurate range is very limited for depth calculations (cameras a couple of cm apart can be accurate for depth up to a couple of meters).
立体声 RGB 或鱼眼镜头有助于能够看到更大的场景（因此潜在的更多的光学特征，例如普通镜头可能会看到白色的墙壁，但鱼眼可以看到图案的天花板和地毯 - Tango 和 Hololens 使用这个方法），并且可能获得比 VIO 更低计算成本的深度信息。由于手机（甚至 HMD ）上的立体声摄像机靠近在一起，它们的精确范围对于深度计算是非常有限的（相隔两厘米的相机可以精确到高达几米的深度）。

The most interesting thing coming down the pipeline is support for tracking over much larger areas, especially outdoors for many km. At this point there is almost no difference between tracking for AR and tracking for self driving cars, except AR systems do it with fewer sensors & lower power. Because eventually any device will run out of room trying to map large areas, a cloud supported service is needed, and Google recently announced the Tango Visual Positioning Service for this reason. We’ll see more of these in coming months. It’s also a reason why everyone cares so much about 3D maps right now.
管道（pipeline）最有趣的事情是支持在更大的地区进行跟踪，尤其是户外。 在这一点上，跟踪 AR 和跟踪自驾车几乎没有区别，除了 AR 系统使用较少的传感器和较低的功率。 因为任何设备最终都将耗尽内存如果试图映射大面积，所以需要云支持服务，因此谷歌最近宣布了 Tango 视觉定位服务。 我们将在未来几个月内看到更多。 这也是每个人都关心 3D 地图的原因。
**The Future of AR Computer Vision**
** AR计算机视觉的未来**

![](https://cdn-images-1.medium.com/max/1600/1*4CYPyi8NYq9T8VcUNaZ0WQ.jpeg)

6Dof position tracking will be completely commoditized in 12–18 months, across all devices. What is still to be solved are things like:
6D 位置跟踪将在 12-18 个月内完全商品化，涵盖所有设备。待解决的问题还有：

3D reconstruction (Spatial Mapping in Hololens terms or Depth Perception in Tango terms). This is the system being able to figure out the shape or structure of real objects in a scene. It’s what allows the virtual content to collide into and hide behind (occlusion) the real world. It’s also the feature that confuses people as they think this means AR is now “Mixed” reality (thanks Magic Leap!). It’s always AR, just most of the AR people have seen has no 3D reconstruction support so the content appears to just move in front of real world objects. 3D reconstruction works by capturing a point cloud from the scene (today using a depth camera) then converting that into a mesh, and feeding the “invisible” mesh into Unity (along with the real world coordinates) and placing the real world mesh exactly on top of the real world as it appears in the camera. This means the virtual content appears to interact with the real world. Note ARKit does a 2D version of this today by detecting 2D planes. This is the minimum that is needed. Without a Ground Plane, the Unity content literally wouldn’t have a ground to stand on and would float around.

3D 重建（Hololens 术语中称作空间映射，Tango 术语中称作深度感知）。这项技术能够找出场景中真实物体的形状或结构，同时允许虚拟内容与现实世界碰撞并隐藏在后面（遮挡）。这也是使人们混淆的功能，因为他们认为这意味着 AR 现在是“混合”的现实。它总是 AR，只有大多数 AR 人都看到没有 3D 重建支持，所以内容似乎只是移动到真实世界的对象之前。 3D 重建通过从场景（现在使用深度相机）捕获点云，然后将其转换为网格，并将“不可见”网格馈送到 Unity （与真实世界坐标）并将真实世界网格准确放置在在相机中出现的真实世界的顶部。这意味着虚拟内容似乎与现实世界互动。注意 ARKit 今天通过检测 2D 平面来执行 2D 版本。这是所需的最小值。没有一个平面，Unity 的内容在字面上不会有立场的立场，并会浮动。
![](https://cdn-images-1.medium.com/max/1600/1*63S5wmcPciT0iDUdOiyTWw.jpeg)

Magic Leap’s demo showing occlusion of the Robot behind a table leg. No idea whether the table leg was reconstructed in real time & fed into Unity or they pre-modelled it and virtually put it in place over the real table by hand for this demo.
All the issues with Depth Cameras above still apply here, which is why it’s not widely available. Active research is underway to support real-time photorealistic 3D reconstruction using a single RGB camera. It’s about 12–18 months away from being seen in products. This is one major reason why I think “true” consumer AR HMD’s are still at *least* this far away.
Magic Leap 的演示显示机器人在桌腿后面的遮挡。 不知道表腿是否实时重建并进入Unity，或者他们预先对它进行了建模，并将其实际上放在实际的桌子上。
上述深度摄像机的所有问题仍然适用于此，这就是为什么它不是广泛可用。 正在进行积极的研究，以支持使用单个RGB相机的实时照片级3D重建。 在产品中看到的时间大约是12-18个月。 这就是为什么我认为“真正的”消费者AR HMD仍然在*这个遥远的一个主要原因。
![](https://cdn-images-1.medium.com/max/1600/1*dWuPiA8zq4x7T6db2lI7NA.jpeg)

The 3D recosntrctuion system of my old startup Dekko at work back in 2012 on an iPad 2. We had to include the grid otherwise users would not believe what they were seeing (that the system could understand the real world). The buggy has just done a jump & is partly hidden behind the tissue box
After 3D reconstruction there is a lot of interesting research going on around semanticly understanding 3D scenes. Nearly all the amazing computer vision deep learning that you’ve seen uses 2D images (regular photos) but for AR (and cars, drones etc) we need to have a semantic understanding of the world in 3D. New initiatives like ScanNet will help a lot, similar to the way ImageNet helped with 2D semantics.
我的旧启动 Dekko 在 2012年 在 iPad 2 上工作的 3D 重构系统。我们不得不包括网格，否则用户不会相信他们看到的内容（系统可以理解现实世界）。 越野车刚刚完成了跳跃，部分隐藏在纸巾盒后面
在 3D 重建之后，有关于语义上理解 3D 场景的许多有趣的研究。 几乎所有惊人的计算机视觉深入学习，你已经看到使用 2D 图像（常规照片），但对于 AR（和汽车，无人机等），我们需要对 3D 世界的语义理解。 像 ScanNet 这样的新举措将会帮助很多，类似于 ImageNet帮助 2D 语义的方式。
![](https://cdn-images-1.medium.com/max/1600/1*5297b3XAehlprZaAI3PNuQ.jpeg)

An example of 3D semantic segmentation of a scene. The source image is at the bottom, above it is the 3D model (maybe built from stereo cameras, or LIDAR) and on top of is the segmentation via Deep Learning, so we can tell the sidewalk from the road. This is also useful for Pokemon Go so Pokemon are not placed in the middle of a busy road….
Then we need to figure out how to scale all this amazing tech to support multiple simultaneous users in real-time. It’s the ultimate MMORG.
场景 3D 语义分割的一个例子。 源图像在底部，上面是 3D 模型（可能是由立体相机或 LIDAR 构建的），而最重要的是通过深度学习进行分割，因此我们可以从道路上识别出人行道。 这对于 Pokemon Go 也是有用的，所以 Pokemon Go 没有放在繁忙的路上。
那么我们就需要弄清楚，如何将这些惊人的技术扩展到能够实时支持多个并发用户。
![](https://cdn-images-1.medium.com/max/1600/1*6Dhoz_grn3D8ipadNlLm7Q.jpeg)

As the 3D reconstructions get bigger, we need to figure out how to host them in the cloud and let multiple users share (and extend) the models

随着 3D 重建越来越大规模，我们需要了解如何在云中托管它们，让多个用户共享（并扩展）模型。

**The future of other parts of AR**
**AR 其他部分的未来**

It’s beyond the scope of this post to get into all these (future posts?) but there is a lot of work to happen further up the tech stack:

深度探讨所有的方面超出了这篇文章的范畴，但技术堆栈仍然有很多任务要进一步发展：
- optics: Field of View, eyebox size, resolution, brightness, depth of focus, vergence accomodation all still need to be solved. I think we’ll see several “in between” HMD designs which only have limited sets of features, intending to “solve” only 1 problem (eg social signaling, or tracking, or an enterprise use case, or something else) before we see the ultimate consumer solution.

* 光学：视场，眼框尺寸，分辨率，亮度，焦点深度，聚光度都需要解决。我认为在我们看到最终的消费者解决方案之前，我们将会看到几个“过渡”的 HMD 设计 —— 只有有限的功能集，每次只“解决”一个问题（如社交信号、跟踪、企业使用情况等）。
- rendering: making the virtual content appear coherent with the real world. Determining real light sources and virtually matching them so shadows & textures look right etc. This is basically what Hollywood SFX have been doing for years (so the avengers look real etc) but in real-time, on a phone, with no control over real world lighting or backgrounds etc. Non-trivial to say the least.


* 渲染：使虚拟内容与现实世界相一致。确定真实的光源并将其实际匹配，使阴影和纹理看起来正确等等。这基本上是好莱坞 SFX 多年来一直在做的（所以复仇者看起来很真实），但现实中，只有一部手机的话，你是无法控制真实的世界照明或背景等的。 
*  Input: this is still a long way from being solved. Research indicates that a multi-modal input system gives by far the best results. Rumors indicate this is what Apple is going to ship. Multi-modal just means various input “modes” (gestures, voice, computer vision, touch, eye tracking etc) are all considered simultaneously by an AI to best understand a users intent.
* 输入：这一步还有很长的路要走。研究表明，多模式输入系统给出了最好的结果。有传言表明这是苹果公司要搭载的。多模式只是意味着 AI 的同时考虑到各种输入“模式”（手势，语音，计算机视觉，触摸，眼睛跟踪等），以最大化地了解用户的意图。
- the GUI and Apps: There’s no such thing as an “app” as we think of them for AR. We just want to look at our Sonos and have the controls appear, virtually on the device. We don’t want to select a little square Sonos button. Or do we? What controls do we want always in our field of view (like a fighter pilot HUD) vs attached to the real word objects. No one has any real idea how this will play out, but it won’t be a 4 x 6 grid of icons.

* GUI 和应用程序：没有像我们想象的AR那样的“app”这样的东西。我们只想看看我们的 Sonos，并且几乎在设备上显示控件。我们不想选择一个小的Sonos按钮。还是我们？在我们的视野（像战斗机飞行员HUD）vs附加到真实的单词对象上，我们想要什么控制。没有人有什么真正的想法如何发挥，但它不会是一个4 x 6的图标网格。

- Social problems need to be solved. IMO only Apple & Snap have any idea how to sell fashion, and AR HMD’s will be a fashion driven purchase. This is probably a harder problem to solve than all the tech problems above.

* 需要解决社会问题。 目前只有 Apple 和 Snap 知道如何销售时尚的产品。这可能比以上所有技术问题要更难解决。
 
Thank you for getting this far! Please reach out with any questions or comments or requests for future posts
感谢你看到这里！有任何关于之后文章的问题、建议或要求都欢迎与我联系。
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。




