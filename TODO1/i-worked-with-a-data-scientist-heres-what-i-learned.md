> * 原文地址：[I Worked With A Data Scientist As A Software Engineer. Here’s My Experience.](https://towardsdatascience.com/i-worked-with-a-data-scientist-heres-what-i-learned-2e19c5f5204)
> * 原文作者：[Ben Daniel A.](https://towardsdatascience.com/@bendaniel10)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/i-worked-with-a-data-scientist-heres-what-i-learned.md](https://github.com/xitu/gold-miner/blob/master/TODO1/i-worked-with-a-data-scientist-heres-what-i-learned.md)
> * 译者：
> * 校对者：

# I Worked With A Data Scientist As A Software Engineer. Here’s My Experience.

Talking about my experience as a Java/Kotlin developer while working with our data scientist

![](https://cdn-images-1.medium.com/max/2560/0*V-3j85eeM0dGnd-o)

Photo by [Daniel Cheung](https://unsplash.com/@danielkcheung?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

#### Background

In late 2017, I started to develop interest in the Machine Learning field. I [talked about my experience](https://medium.com/@bendaniel10/hello-machine-learning-cc89b3ccbe4d) when I started my journey. In summary, it has been filled with fun challenges and lots of learning. I am an Android Engineer, and this is my experience working on ML projects with our data scientist.

I remember attempting to solve an image classification problem that came up in one of our apps. We needed to differentiate between valid and invalid images based on a defined set of rules. I immediately modified [this example](https://github.com/deeplearning4j/dl4j-examples/blob/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/convolution/AnimalsClassification.java) from Deeplearning4J (dl4j) and tried to use it to handle the classification task. I didn’t get the results that I expected, but I remained optimistic.

![](https://i.loli.net/2019/01/08/5c34b6733de77.png)

My approach with dl4j sample code was unsuccessful because of the kind of accuracy that I got and the final size of the trained model. This couldn’t fly since we needed a model with a compact file size which is specially important for mobile devices.

#### Enter the Data Scientist

![](https://cdn-images-1.medium.com/max/600/0*zKBeymXEf00uZbZZ)

Photo by [rawpixel](https://unsplash.com/@rawpixel?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

It was around this time that [we](https://seamfix.com/) hired a data scientist, and he came with a lot of relevant experience. I would later learn a lot from him. I had reluctantly started to learn the basics of Python after I found out that most ML problems could be solved with Python. I later discovered that some things were just easier to implement in Python as there’s already a huge support for ML in the Python community.

We started with small learning sessions. At this point, my other team members became interested and joined the sessions too. He gave us an introduction to [Jupyter Notebooks](https://jupyter.org/install) and the [Cloud Machine Learning Engine](https://cloud.google.com/ml-engine/docs/tensorflow/getting-started-training-prediction). We quickly got our hands dirty by attempting the [image classification using the flower dataset](https://cloud.google.com/ml-engine/docs/tensorflow/flowers-tutorial) example.

After everyone in the team became grounded with the basics of training and deploying a model, we went straight to the pending tasks. As a team member, I was focused on two tasks at this point: the image classification problem and a segmentation issue. Both of them would later be implemented using Convolutional Neural Networks (CNNs).

#### Preparing the training data isn’t easy

![](https://cdn-images-1.medium.com/max/600/0*GllGs9LmPto_7-_U)

Photo by [Jonny Caspari](https://unsplash.com/@jonnysplsh?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

Both tasks required a lot of training data. The good news was that we had a lot of data. The bad news was that they were unsorted/not annotated. I finally understood what ML experts said about spending the most time preparing the training data rather than training the model itself.

For the classification task we needed to arrange hundreds of thousands of images into different classes. This was tedious job. I had to invoke my Java Swing skills to build GUIs that made this task easier, but in all, the task was monotonous for everyone involved in the manual classification.

The segmentation process was a bit more complicated. We were lucky enough to find some models that were good at segmentation already but unfortunately they were too large. We also wanted the model to be able run on Android devices that had very low specs. In a moment of brilliance, the data scientist suggested that we use the huge model to generate the training data that would be used to build our own mobilenet.

#### Training

We eventually switched to [AWS Deep Learning AMI](https://docs.aws.amazon.com/dlami/latest/devguide/launch-config.html). We were already comfortable with AWS and it was a plus that they offered such a service. The process of training the model for the image segmentation was fully handled by our data scientist, and I stood beside him, taking notes :).

![](https://i.loli.net/2019/01/08/5c34b6d806f4f.png)

Those are not the actual logs, LOL.

Training this model was a computationally intensive task. This was when I saw the importance of training on a computer with sufficient GPU(s) and RAM. The time it took to train was reasonably short because we used such computers for our training. It would have taken weeks, if not months, had we used a basic computer.

I handled the training of the image classification model. We didn’t need to train it on the cloud, and in fact, I trained it on my Macbook pro. This was because I was only training the final layer of the neural network compared to the full network training that we did for the segmentation model.

#### We made it to prod

Both models made it to our production environment after rigorous tests 🎉. A team member was tasked with building the Java wrapper libraries. This was done so that the models could be used in a way that abstracts all the complexity involved in feeding the model with the images and extracting meaningful results from the tensor of probabilities. This is the array that contains the result of the prediction the model made on a single image. I was also involved a little at this point too as some of the hacky code I had written earlier was cleaned up and reused here.

#### Challenges, challenges everywhere

> Challenges are what make life interesting. Overcoming them is what makes them meaningful. — Anonymous

I can remember when my biggest challenge was working with a 3-dimensional array. I still approach them with caution. Working on ML projects with our data scientist was the encouragement that I needed to continue my ML adventure.

My biggest challenge when working on these projects was attempting to build, from source, the Tensorflow Java library for 32 bit systems using Bazel. I have not been successful at this.

![](https://i.loli.net/2019/01/08/5c34b69bf3c36.png)

I experienced other challenges too, one of them was frequent: translating the Python solutions to Java. Since Python already has built in support for data science tasks, the code felt more concise in Python. I remember pulling my hair out when I tried to literally translate a command: scaling a 2D array and adding it as a transparent layer to an image. We finally got it to work and everyone was excited.

Now the models on our production environment were doing great mostly, however when they produced a wrong result, those wrong results were ridiculously very wrong. It reminded me of quote I saw on this [excellent post](https://www.oreilly.com/ideas/lessons-learned-turning-machine-learning-models-into-real-products-and-services) about turning ML models into real products and services.

> …models will actually degrade in quality — and fast — without a constant feed of new data. Known as [concept drift](https://machinelearningmastery.com/gentle-introduction-concept-drift-machine-learning/), this means that the predictions offered by static machine learning models become less accurate, and less useful, as time goes on. In some cases, this can even happen in a matter of days. — [David Talby](https://www.oreilly.com/people/05617-david-talby)

This means that we will have to keep improving the model, and there is no final model, which is interesting.

* * *

I’m not even sure I qualify to be called a ML newbie since I focus mostly on mobile development. I have had an exciting experience this year working with an ML team to ship models that helped solve company problems. It’s something I would want to do again.

Thanks to [TDS Team](https://medium.com/@TDSteam?source=post_page) and [Alexis McKenzie](https://medium.com/@lexmckenz?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
