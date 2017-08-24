
  > * 原文地址：[Making the Web More Accessible With AI](https://hackernoon.com/making-the-web-more-accessible-with-ai-1fb2ed6ea2a4)
  > * 原文作者：[Abhinav Suri](https://hackernoon.com/@abhisuri97)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/making-the-web-more-accessible-with-ai.md](https://github.com/xitu/gold-miner/blob/master/TODO/making-the-web-more-accessible-with-ai.md)
  > * 译者：
  > * 校对者：

  # Making the Web More Accessible With AI

  ![](https://cdn-images-1.medium.com/max/2000/1*oxCB95q9jaqKSqMw96FWqA.png)

Person reading Braille stock image ([src](http://usabilitygeek.com/wp-content/uploads/2012/07/Software-For-Visually-Impaired-Blind-Users.jpg))

[According to the World Health Organization](http://www.who.int/mediacentre/factsheets/fs282/en/), approximately 285 million people are visually impaired worldwide, and in the United States alone, 8.1 million internet users have a visual impairment.

What most non-disabled individuals consider to be the internet, a place full of text, images, videos, and more, is something completely different for the visually impaired. Screen readers, tools that can read text and metadata on a web page, are very limited and can only expose one part of a webpage, namely the text of the site. While some developers take the time to go through their sites and add descriptive captions to their images for visually disabled users, the vast majority of programmers do not take the time to do this admittedly tedious task.

So, I decided to make a tool to help visually impaired individuals “see” the internet with the power of AI. It’s called Auto Alt Text and is a chrome extension that allows users to right click and get a description of the scene in an image — the first to do so.

Check out the video below to see how it works and [download it to try it out](http://abhinavsuri.com/aat)!

[![](https://i.ytimg.com/vi_webp/c1S4iB360m8/maxresdefault.webp)](https://www.youtube.com/embed/c1S4iB360m8)

Demo of the chrome extension in action
#### Why I made Auto Alt Text:

I used to be one of those developers who didn’t take the time to add descriptions to images on my page. For me, accessibility was always a second thought until I got an email from a user of [one of my projects](https://github.com/hack4impact/flask-base).

![](https://cdn-images-1.medium.com/max/1600/1*uYx_pi9vAI17mQ20D81ykw.png)

Email Text: “Hi Abhinav, I found your flask-base project and think it is definitely going to be a great fit for my next project. Thanks for working on it. I also just wanted to let you know that you should put some alt descriptions on your readme images. I’m legally blind and had a tough time making out what was in them :/ From REDACTED”
At that point, my development process put accessibility at the bottom of the list, basically an afterthought. However, this email was a wakeup call for me. There are many individuals on the internet who need accessibility features to understand the original intent of websites, apps, projects, and more.

> “The web is replete with images that have missing, incorrect, or poor alternative text” — WebAIM (Center for Persons with Disabilities at Utah State University)

#### Artificial Intelligence to the Rescue:

There are numerous ways to caption images; however, most have a few disadvantages in common:

1. They aren’t responsive and take a long time to return a caption.
2. They are semi-automated (i.e. relying on humans to manually caption images on demand).
3. They are expensive to create and maintain.

By creating a neural network, all of these problems can be solved. I recently had started taking a deep dive into machine learning and AI when I came across Tensorflow, an open source library to help with machine learning. Tensorflow enables developers to architect robust models that can be used to complete a variety of tasks from object detection to image recognition.

Doing a bit more research, I came across a paper by Vinyals et al called “[Show and Tell: Lessons learned from the 2015 MSCOCO Image Captioning Challenge](https://arxiv.org/abs/1609.06647)”. These researchers created a deep neural network to describe image content in a semantic manner.

![](https://cdn-images-1.medium.com/max/1600/1*mSvmjcvUbpgB3izigcEi4w.png)

Examples of im2txt in action from the [im2txt Github Repository](https://github.com/tensorflow/models/tree/master/im2txt)
#### Technical Details of im2txt:

The mechanics of the model are fairly detailed, but basically it is an “encoder-decoder” scheme. First, the image is put through a deep convolutional neural network called Inception v3, an image classifier. Next, the encoded image is fed through an LSTM which is a type of neural network that specialized in modeling sequences/time-sensitive information. The LSTM then works through a set vocabulary and constructs a sentence to describe the image. It does this by taking the likelihood of each word from that set vocabulary appearing first in the sentence and then computing the most likely second-word probability distribution given the first-word probability distribution and so on until the most likely character is a “.” indicating the end of the caption.

![](https://cdn-images-1.medium.com/max/1600/1*CW6YVV_zEriaGrxMzN4quA.png)

Overview of the structure of the neural network (from the [im2txt Github repository](https://github.com/tensorflow/models/tree/master/im2txt))
Per the Github repository, the training time for this neural network was approximately 1–2 weeks on a Tesla k20m GPU (probably much more for a standard CPU on a laptop which is what I have). Thankfully, a member of the tensorflow community provided a trained model for public download.

#### Problems out of the box + Lamdba:

When running the model, I managed to get it to work with Bazel, a tool that is used to pre-package tensorflow models into runnable scripts (among other purposes). However, it took me nearly 15 seconds to get a result from a single image when running on the command line! The only way to solve this issue was to keep the tensorflow graph in memory, but that would require keeping the app up 24/7. I was planning on putting this model on AWS Elasticbeanstalk where compute time is prorated to the hour and keeping an app up all the time was non-ideal (basically leading to situation #3 in the disadvantages of image captioning software). So, I decided to switch over to AWS Lamdba to host everything.

Lambda is a service that provides serverless computing for an incredibly low cost. Furthermore, it charges on a second by second basis when it is actively used. The way Lambda works is simple: once your app gets a request from a user, Lambda will activate an image of your application, serve a response, and deactivate that image. If you have multiple concurrent requests, it just spins up more instances to scale to the load. Additionally, it will keep your app activated as long as there are multiple requests within the hour. This service was a great fit for my use case.

![](https://cdn-images-1.medium.com/max/1600/1*Q4EaQYos3s-67OkhhKzDkg.png)

AWS API Gateway + AWS = heart ([src](https://cdn-images-1.medium.com/max/700/1*SzOPXTf_YQNtFejG0e4HPg.png))
The problem with Lambda was that I had to create an API for the im2txt model. Furthermore, Lamdba has memory constraints on the application that can be loaded as a function. When uploading a zip file containing all your application code, including dependencies, the final file cannot be more than ~250 MB. This limit was a problem since the size of the im2txt model was over 180 MB, and the dependencies for it to run was over 350 MB. I tried to get around this issue by uploading some parts into an S3 instance and downloading into my running lambda instance when it was active; however, the total storage size limit on lambda is 512 MB which my application was well over (it was around 530 MB in total).

To reduce the final size of my project, I reconfigured im2txt to accept a pared down model containing only the trained checkpoint and no extraneous metadata. This deletion reduced my model size to 120 MB. I then discovered [lambda-packs](https://github.com/ryfeus/lambda-packs) which contained a minimized version of all the dependencies, albeit with an earlier version of python and tensorflow. After going through the painful process of downgrading any python 3.6 syntax and tensorflow 1.2 code, I finally had a package which was ~480 MB in total, just below the 512 MB limit.

To keep response times quick, I created a CloudWatch function to keep the Lambda instance “hot” and the application active. I added a few helper functions to manipulate images not in JPG format and finally had a working API. All of these reductions led to a blazing fast response time of < 5 seconds in most cases!

![](https://cdn-images-1.medium.com/max/1600/1*e5awvS8Z3k5V9qaxzMadQw.png)

Image with likely probabilities of what is in the image according to the API
Moreover, Lambda is incredibly cheap, at the current rate, I can analyze 60,952 images for free monthly and any additional image for $0.0001094 (meaning approx $6.67 for the next 60,952 images).

More details about the API can be found at the repository: [https://github.com/abhisuri97/auto-alt-text-lambda-api](https://github.com/abhisuri97/auto-alt-text-lambda-api)

All that was left was packing it into a chrome extension for ease of use for the end user, which wasn’t too challenging a task (since it just involved a simple AJAX request to my API endpoint).

![](https://cdn-images-1.medium.com/max/1600/1*SXf884JCTh_Ze-0XcXsxiw.gif)

Auto Alt Text Chrome Extension in action
#### Results:

Im2txt performs well on images of people, scenery, etc. as long as those objects are present in the Common Objects in Context (COCO) dataset.

![](https://cdn-images-1.medium.com/max/1600/1*NE9GCZliWRPy9km6Kmaarw.png)

Categories of images in the COCO dataset
This model somewhat limits the scope of what can be captioned; however, it does cover a majority of images that are seen on social media sites such as Facebook and Reddit.

However, it often does fail to caption images that contain text since the COCO dataset doesn’t contain any such pictures. I tried using Tesseract to accomplish this task; however, the results were too inaccurate and took too long to produce (upwards of 10 seconds). I am currently working on an implementation of [Wang et al.’s paper ](http://ai.stanford.edu/~ang/papers/ICPR12-TextRecognitionConvNeuralNets.pdf)in Tensorflow to aid in this task.

#### Takeaways:

While there is a new story about the wonders of AI on a weekly basis, it is important to step back and see how those tools can be used outside the research setting and how those findings can help people throughout the world. Overall, I loved doing this deep dive into Tensorflow with im2txt and being able to apply what I learned to a real world problem. Hopefully, this tool will be the first of many to help visually impaired individuals see a better internet.

#### Links:

- Follow me: I primarily publish what I am doing on [my Medium](https://medium.com/@abhisuri97). If you like this post, I’d appreciate a follow :) In the coming months I’ll be publishing a couple more “how to” guides for using AI/tensorflow to solve real world problems. I’ll also be posting some JS explainers/tutorials in the near future.
- Link to the Chrome Extension [download page](http://abhinavsuri.com/aat)
- Link to the Auto Alt Text Lambda API [Github repository](http://github.com/abhisuri97/auto-alt-text-lambda-api)


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  