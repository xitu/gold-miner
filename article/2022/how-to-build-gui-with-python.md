> * 原文地址：[How to Build a GUI Program with Python](https://python.plainenglish.io/how-to-build-gui-with-python-1e953f5c697c)
> * 原文作者：[Aisha Mohammed](https://medium.com/@aisharm13)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-build-gui-with-python.md](https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-build-gui-with-python.md)
> * 译者：
> * 校对者：

# How to Build a GUI Program with Python

> A program using Python library Tkinter to get the expected date of delivery of pregnancy with the date of the last menstrual period as input.

I was studying GUI programming a while ago and thought it would be fun to practice what I was learning by working on this project alongside. The project was to build a GUI (graphic user interface) program that allows a user to calculate the expected date of delivery (EDD) of their pregnancy when they enter the date of their last menstrual period (LMP). I built the program using Tkinter.

Tkinter, which stands for “Tk interface”, is one of Pythons’ GUI libraries. GUI allows user interaction with a computer program by displaying icons and widgets that users can interact with. Tkinter provides diverse widgets such as labels, buttons, text boxes, checkboxes, and so on, which have various functions.

I built the program in stages using incremental development, continually adding a few lines of code and then testing them. The stages are:

1. Sketching the user interface on paper.
2. Creating the basic structure and framework that will hold widgets.
3. Incrementally adding widgets with their appropriate size and position.
4. Creating call back functions, assigning them to events, and implementing functionality needed for the call back functions.

## Sketching the user interface

I made 2 rough sketches of what I thought the program should look like. I went with the second sketch, which consists of the “photo” of a pregnant woman on the left and the part for calculating the EDD on the right.

![rough sketch of the interface](https://cdn-images-1.medium.com/max/2468/1*lOooDLDNsnYP1H3JX3JTsw.jpeg)

## Creating the basic structure of the interface.

I created a simple structure for the interface using **frame** widgets. I created 2 frames of equal sizes. I specified the sizes here because there are no widgets in the program yet (which is how frames usually get their sizes). I also gave each frame a different colour to see the area of the window they cover. See code [here](https://github.com/aisha-rm/EDD-calculator/blob/main/framework.py).

![the framework of the program](https://cdn-images-1.medium.com/max/2000/0*knnaguS-rCkJsiMF.png)

## Adding a widget to the left frame

I added a photo to the left frame using the **label** widget. This widget can be used to display text or images. Image [source](https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fillustrations%2Fpregnant&psig=AOvVaw3Ed_YWfg460hZNsUeAns-V&ust=1636306992268000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCKiZxMGrhPQCFQAAAAAdAAAAABAE). I removed the frame dimensions in the code [here](https://github.com/aisha-rm/EDD-calculator/blob/main/left_widget.py) as the widget in this frame now determines its size.

![added picture to the left frame](https://cdn-images-1.medium.com/max/2000/0*2qcwLDKPLlQOuOdA.png)

## Adding widgets to the right frame

I added the title (EDD Calculator) using a **label** widget, and the message below it using the **message** widget. I used the **Entry** widget for the blank space and the Button widget for the “calculate EDD” button. I tried to use either grid or place layout managers to arrange the widgets initially because they looked easier. Unfortunately, I was not getting the desired results. Using pack layout manager, and playing around with internal and external padding, finally put the widgets in the position I wanted. I then changed the colour of the right frame at this point for “harmony” with the left. See code [here](https://github.com/aisha-rm/EDD-calculator/blob/main/all_widgets.py).

![added the rest of the widgets on the right frame](https://cdn-images-1.medium.com/max/2000/0*OLFhsBZpA5GysL1Z.png)

## Adding Callback Functions and Functionality

I needed to make my program interactive and have some functional logic. So, I added functions that would take data entered into the text box, calculate the EDD from the input received, and return a message to the user using the **messagebox** widget. If the date was appropriately entered in the format stated, the program returned a message with the user’s EDD. Otherwise, an error message was returned. Examples are shown below.

![returns EDD if the date is entered as specified](https://cdn-images-1.medium.com/max/2000/0*mOF-rxOL5rwuRzcX.png)

![returns error message if date format not followed](https://cdn-images-1.medium.com/max/2000/0*Bp6hEjj_VS7oth2-.png)

![error message because the date was given in dd/mm/yyyy instead of as specified](https://cdn-images-1.medium.com/max/2000/0*EbLXl1k-EN8z8TNk.png)

Here is the link to the complete project on [Github](https://github.com/aisha-rm/EDD-calculator/blob/main/app.py). Feel free to use it to create your own program, make modifications, etc. I’d be happy to see your output if you do.

## Conclusion

This was a fun project for me. I enjoyed it way more than the one or two Tkinter projects I found online that I attempted in the past. In those cases, I didn’t understand what was really going on “behind the scenes”. It was mostly copying codes. Bleh.

Thanks for reading to the end! If you have any questions or corrections, please leave a comment below. I also published this post on my personal [website.](https://themedtechie.com/tech/) You can head over there to check out my other posts.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
