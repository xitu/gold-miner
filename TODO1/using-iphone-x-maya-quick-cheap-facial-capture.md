> * 原文地址：[Using iPhone X With Maya For Quick And Cheap Facial Capture](https://uploadvr.com/using-iphone-x-maya-quick-cheap-facial-capture/)
> * 原文作者：[IAN HAMILTON](https://uploadvr.com/author/ian-hamilton/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-iphone-x-maya-quick-cheap-facial-capture.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-iphone-x-maya-quick-cheap-facial-capture.md)
> * 译者：
> * 校对者：

# Using iPhone X With Maya For Quick And Cheap Facial Capture

![](https://cdn.uploadvr.com/wp-content/uploads/2017/12/iphoneX-to-Maya.jpg)

Can the iPhone X become a fast, cheap and simple facial capture system? About a month ago Cory Strassburger at Kite & Lightning received an iPhone X from Apple. Within a day, he was [testing out software](https://uploadvr.com/iphone-x-face-recognition-development-strassburger/) working with its TrueDepth camera and ARKit. He wanted to see if it could be used for their game and for cinematic content.

Kite & Lightning was an early innovator with Oculus VR developer kits and built ground-breaking experiences like [Senza Peso](http://kiteandlightning.la/senza-peso/) that used some eye-catching human captures. Now, they are building [Bebylon Battle Royale](http://bebylon.world/).The game revolves around these “beby” characters who have humongous attitudes. He wanted to see if giving these characters a big personality could be done more quickly and cheaply using iPhone X facial capture and he’s been spending some of his time on the weekends on it.

“I think my big conclusion at the moment is the capture data coming from the iPhone X is shockingly subtle, stable and not overly smoothed,” Strassburger wrote in an email. “It is actually picking up very subtle movements, even small twitches and is clean enough (noise free) to use right out of the phone, depending on your standards of course.”

He thinks it represents a viable method for relatively inexpensive facial capture. The system is also mobile, would could make it easier to set up and deploy. Apple acquired a company called [Faceshift](https://uploadvr.com/heres-apple-acquired-faceshift/) that seems to power much of this functionality. Though Strassburger notes Faceshift’s solution had other cool features, he’s been able to extract enough expressiveness using what Apple released with iPhone X that it still might prove useful for VR production.

* YouTube 视频链接：https://youtu.be/w047Dbo-fGQ

## Capture Process

Here’s the capture process Strassburger outlined for taking the iPhone X facial capture data and using it to animate a character’s expressions in Maya:

*   Using Apples ARKit and Unity I imported a work-in-progress Bebylon character and hooked its facial expression blend shapes into the facial capture data that ARKit outputs. This let me drive the baby’s face animation based on my own expressions.
*   I needed to capture this expression data in order to import it into Maya. I added a record function to stream the facial expression data into a text file. This saved locally on the iPhone. Each start and stop take becomes a separate text file and can be named/renamed within the capture app.
*   I copy the text files from the iPhone X to the desktop via USB.
*   The captured data needs to be reformatted for importing into Maya so I wrote a simple desktop app to do this. It takes the chosen text file(s) and converts them to Maya .anim files.
*   I import the .anim file into Maya and voila, your character is mimicking what you saw on the iPhone during capture.

According to Strassburger, he’s seen a couple minor glitches show up in the data and thinks his code was probably responsible. Also, though the capture happens at 60 frames per second, the process currently renders at 30 frames per second so you can see some quality loss. This is most notable in the “Horse Lips” section, according to Strassburger.

“The real beauty to this system is it is incredibly fast and easy to capture (right on your phone) and then import it into Maya or right into the game engine,” Strassburger wrote. “There is no real processing involved at any point and the data seems clean enough right out of the phone to use unaltered.”

![](https://cdn.uploadvr.com/wp-content/uploads/2017/12/processOverview.jpg)

## Next Steps

Strassburger hopes to attach the iPhone X to a helmet and then use an Xsens suit to do full-body motion and face capture at the same time.

“I feel pretty confident that this beby character could be improved dramatically by dialing in the blendshape sculpts and also adding proper wrinkle maps that deform the skin as the face animates,” Strassburger wrote. “As well, using the captured data to drive secondary blendshapes will help the expressions feel more dynamic and alive.”


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
