
> * 原文地址：[Deep Learning #1: Setting up AWS & Image Recognition](https://medium.com/towards-data-science/deep-learning-1-1a7e7d9e3c07)
> * 原文作者：[Rutger Ruizendaal](https://medium.com/@r.ruizendaal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-1-setting-up-aws-image-recognition.md](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-1-setting-up-aws-image-recognition.md)
> * 译者：
> * 校对者：

# Deep Learning #1: Setting up AWS & Image Recognition

*This post is part of a series on deep learning. Check-out part 2 *[*here*](https://medium.com/@r.ruizendaal/deep-learning-2-f81ebe632d5c)* and part 3 *[*here*](https://medium.com/@r.ruizendaal/deep-learning-3-more-on-cnns-handling-overfitting-2bd5d99abe5d)*.*

![](https://cdn-images-1.medium.com/max/1600/1*y3guCmNkYLF2uR09Fslh5g.png)

This week: classifying images of cats and dogs
Welcome to this first entry in this series on practical deep learning. In this entry I will setup the Amazon Web Services (AWS) instance and use a pre-trained model to classify images of cats and dogs.

In this complete series I will be blogging about my process in the first part of the Fast AI deep learning course. This course was first given at the Data Institute at the University of San Francisco and is now available as a MOOC. Recently the authors gave part 2 of the course which will become available online in a couple of months. The main reason for following this course is my extreme interest in deep learning. I have found many online resources regarding machine learning but practical courses on deep learning seem to be a rarity. Deep learning seems to be an exclusive group that is just a little harder to get into. The first thing needed to start on deep learning is a GPU. In this course we use the p2 instance from AWS. Let’s get that set up.

The first week of this course really focused on the setup. Getting your deep learning setup right can take a while and it is important to get everything working correctly. This includes setting up AWS, creating and configuring the GPU instance, setting up the process of ssh-ing into the server and managing your directories.

I ran into some issues with permissions on my internship laptop. Let me give you one tip that will save a lot of time in trying to bypass this: Make sure you have full administrator access on your laptop before attempting this. Some lovely engineers offered to setup the GPU instance for me, but they didn’t have time to do it soon. So I decided to take matters into my own hands.

The scrips for setting up the AWS instance are written in bash. If you’re working on a Windows machine you will need a program that can handle this. I’m using Cygwin. I want to share some issues (and their solutions) that I ran into during the install. You can skip this if you’re not following the Fast AI course and just reading along. Some issues that I ran into during the setup process were:

- The bash scripts throw an error

I have read some possible explanations for this, but not a clear solution that worked for me. The setup script of the course on Github is now split in two scripts: setup_p2.sh and setup_instance.sh. In case you cannot get these two scripts to work you can use [this](https://github.com/ericschwarzkopf/courses/blob/dc06ce745a30850e7937858fb26a67df2aff329d/setup/setup_p2.sh) script to setup your p2 instance. If the script does not run be sure to try the raw version as well.

I had a similar issue with the aws-alias.sh script. Adding a ‘ at the end of line 7 fixed this issue. Here is a before and after of line 7:

    alias aws-state='aws ec2 describe-instances --instance-ids $instanceId --query "Reservations[0].Instances[0].State.Name"

    alias aws-state='aws ec2 describe-instances --instance-ids $instanceId --query "Reservations[0].Instances[0].State.Name"'

[Here](https://gist.github.com/LeCoupa/122b12050f5fb267e75f) is a Bash cheat sheet for everyone who is not familiar with Bash. I greatly recommend this since you will need Bash to interact with your instance.

- The Anaconda install. The video mentions that you should install Anaconda before installing Cygwin. This can be a bit confusing as you need to use the ‘Cygwin python’ to run the pip commands in there and not a local Anaconda distribution.

Additionally, [this](https://github.com/TomLous/practical-deep-learning) repository has a nice step-by-step guide on getting your instance running.

---

#### Getting started with Deep Learning

After some issues I got my GPU instance running. Time to get started with deep learning! A quick disclaimer: in these blogs I won’t be repeating exactly what is listed in the lesson notes, there is no need for that. I will be highlighting some things that I found really interesting, as well as issues and ideas that I ran into while going through the lesson.

Let’s start with the first question that is probably on your mind: **What is deep learning and why is it experiencing such hype right now?**

Deep learning simply is an artificial neural network with multiple hidden layers, this makes them ‘deep’. A general neural network only has one, maybe two hidden layers. A deep neural network has much more hidden layers. They also have different types of layers than the ‘simple’ ones in the normal neural network.

![](https://cdn-images-1.medium.com/max/1600/1*CcQPggEbLgej32mVF2lalg.png)

(Shallow) Neural Network
Currently deep learning is consistently beating performance on well-known datasets. Therefore deep learning has been experiencing a lot of hype. There are three reasons for the popularity of deep learning:

- Infinitely flexible function
- All-purpose parameter fitting
- Fast and scalable

The Neural Network is modeled after the human brain. According to the universal approximation theorem it can theoretically solve any function. The Neural Network is trained through backward propagation, which allows us to fit the parameters of the model to all these different functions. The last reason is the main one for the recent achievements in deep learning. Because of advancements in the gaming industry and the developments of powerful GPUs it is now possible to train deep neural networks in a fast and scalable way.

In this first lesson the goal is to use a pre-trained model, namely Vgg16 to classify images of cats and dogs. Vgg16 is a lightweight version of the model that won the Imagenet challenge in 2014. This is a yearly challenge and probably the biggest one in computer vision. We can take this pre-trained model and apply it to our dataset of cat and dog images. Our dataset has been edited by the authors of the course to make sure it is in the right format for our model. The original dataset can be found on [Kaggle](https://www.kaggle.com/c/dogs-vs-cats). When this competition was originally run in 2013, the state of the art was 80% accuracy. Our simple model will already achieve 97% accuracy. Mind-blowing right? This is how some of the pictures and their predicted labels look:

![](https://cdn-images-1.medium.com/max/1600/1*y3guCmNkYLF2uR09Fslh5g.png)

Predicted labels for dogs and cats
The target labels are setup using a process called one-hot-encoding which is often used for categorical variables. [1. 0.] refers to a cat and [0. 1.] refers to a dog. Instead of having one variable named ‘target’ with two levels 0 and 1, we create an array with two values. You can look at these variables as ‘cats’ and ‘dogs’. If the variable is true it gets labeled as a 1 and otherwise as a 0. In a multi-classification problem this can mean that your output vector looks like this: [0 0 0 0 0 0 0 1 0 0 0]. In this case the Vgg16 model outputs the probability of the image belonging to class ‘cat’ and the probability of the image belonging to the class ‘dog’. The next challenge is to tweak this model so we can apply it to another dataset.

---

#### **Dogs vs. Cats Redux**

Essentially this is the same dataset as the previous one, but it is not pre-processed by the authors of the course. The Kaggle Command Line Interface (CLI) provides a quick way to download the dataset. It can be installed via pip. A dollar sign is often used to show that a command is run in the terminal.

    $ pip install kaggle-cli

The training set contains 25.000 labeled images of dogs and cats, while the test set contains 12.500 unlabeled images. In order to finetune the parameters we also create a validation set by taking a small part of the training set. It is also useful to set-up a ‘sample’ of the full dataset that you can use to quickly check if your model is working during the building proces.

In order to run our model we use the Keras library. This library sits on top of the popular deep learning libraries Theano and TensorFlow. Keras basically makes it more intuitive to code your network. This means that you can focus more on the structure of the network and worry less about the TensorFlow API. In order to know which picture belongs to which class Keras looks at the directory it is stored in. Therefore, it is important to make sure you move the images to the correct directories. The bash commands that are needed to do this can be run directly from the Jupyter Notebook where we do all our coding. [This](https://www.cyberciti.biz/faq/mv-command-howto-move-folder-in-linux-terminal/) link contains additional information on these commands.

One epoch, which is a full pass through the dataset, takes 10 minutes on my Amazon p2 instance. In this case that dataset is the training set which consists of 23.000 images. The other 2000 images are in the validation set. I decided to use 3 epochs here. The accuracy on the validation set is around 98%. After training the model we can take a look at some of the correctly classified images. In this case we use the probabilities of the image being a cat. 1.0 refers to full confidence that the image is of a cat and 0.0 that the image is of a dog.

![](https://cdn-images-1.medium.com/max/1600/1*fgOX3G_imeRsodKuBBA8Tg.png)

Correctly classified images
Now let’s take a look at some of the wrongly classified images. As we can see most of them are taken from far away and feature multiple animals. The original Vgg model was used for images where one thing of the target class was clearly visible in the picture. Am I the only one who finds the fourth picture slightly terrifying?

![](https://cdn-images-1.medium.com/max/1600/1*jD6t1ifVrrGq571eh5lqhA.png)

Incorrectly classified images
Finally, these are the images that the model was most uncertain about. This means that the probability was closest to 0.5 (where 1 is a cat and 0 a dog). The fourth picture features a cat where only the face is visible. The first and third picture are rectangular and not square like the the pictures the original model was trained on.

![](https://cdn-images-1.medium.com/max/1600/1*zlSUpvspBf9zYm175uaY1w.png)

Images where the model is most uncertain
That’s it for this week. Personally I can’t wait to get started on lesson 2 and learn more about the internals of the model. Hopefully we will also start on building a model from scratch with Keras!

Also, thanks to everyone who is updating the Github scripts. It helped a lot! Another thank you to everyone on the Fast AI forums, you’re awesome.

If you liked this posts be sure to recommend it so others can see it. You can also follow this profile to keep up with my process in the Fast AI course. See you there!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
