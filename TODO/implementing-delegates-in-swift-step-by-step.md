> * 原文地址：[Implementing delegates in Swift, step by step](https://medium.com/@jamesrochabrun/implementing-delegates-in-swift-step-by-step-d3211cbac3ef#.er1y3jh2l)
* 原文作者：[James Rochabrun](https://medium.com/@jamesrochabrun)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：


# Implementing delegates in Swift, step by step.

![](https://cdn-images-1.medium.com/max/800/1*q9CR-wzFHkccp7I761piVw.png)

So, what are delegates? …in software development, there are general reusable solution architectures that help to solve commonly occurring problems within a given context, these “templates”, so to speak, are best known as design patterns.

Delegates are a design pattern that allows one object to send messages to another object when a specific event happens.

Imagine an object A calls an object B to perform an action. Once the action is complete, object A should know that B has completed the task and take necessary action, this can be achieved with the help of delegates!

![](https://cdn-images-1.medium.com/max/800/0*l4JyFlg2IPKL6lSr.jpg)

For a better explanation, I am going to show you how to create a custom delegate that passes data between classes, with Swift in a simple application, start by downloading or cloning this [starter project](https://github.com/jamesrochabrun/DelegateTutorial) and run it!

![](https://cdn-images-1.medium.com/max/800/0*mTYwNIwVsFUlDwuI.gif)

You can see an app with two classes, ViewController A and ViewController B. B has two views that on tap changes the background color of the ViewController, nothing too complicated right? well now let’s think in an easy way to also change the background color of class A when the views on class B are tapped.

![](https://cdn-images-1.medium.com/max/800/0*mLo9CmQAdhGb_l60.png)

The problem is that this views are part of class B and have no idea about class A, so we need to find a way to communicate between this two classes, and that’s where delegation shines.

I divided the implementation into 6 steps so you can use this as a cheat sheet when you need it.

step 1: Look for the pragma mark step 1in ClassBVC file and add this

```
//MARK: step 1 Add Protocol here.

protocol ClassBVCDelegate: class {

func changeBackgroundColor(_ color: UIColor?)

}

```

The first step is to create a protocol, in this case, we will create the protocol in class B, inside the protocol you can create as many functions that you want based on the requirements of your implementation. In this case, we just have one simple function that accepts an optional UIColor as an argument.

*Is a good practice to name your protocols adding the word delegate at the end of the class name, in this case, ClassBVCDelegate.*

step 2: Look for the pragma mark step 2 in ClassVBC and add this

```
//MARK: step 2 Create a delegate property here.
weak var delegate: ClassBVCDelegate?

```

Here we just create a delegate property for the class, this property must adopt the protocol type, and it should be optional. Also, you should add the weak keyword before the property to avoid retain cycles and potential memory leaks, if you don’t know what that means don’t worry for now, just remember to add this keyword.

step 3: Look for the pragma mark step 3 inside the handleTap method in ClassBVC and add this

```
//MARK: step 3 Add the delegate method call here.
delegate?.changeBackgroundColor(tapGesture.view?.backgroundColor)

```

One thing that you should know, run the app and tap on any view, you won’t see any new behavior and that’s correct but the thing that I want to point out is that the app it’s not crashing when the delegate is called, and it’s because we create it as an optional value and that’s why it won’t crash even the delegated doesn’t exist yet. Let’s now go to ClassAVC file and make it, the delegated.

step 4: Look for the pragma mark step 4 inside the handleTap method in ClassAVC and add this next to your class type like this.

```
//MARK: step 4 conform the protocol here.
class ClassAVC: UIViewController, ClassBVCDelegate {

```

Now ClassAVC adopted the ClassBVCDelegate protocol, you can see that your compiler is giving you an error that says “Type ‘ClassAVC does not conform to protocol ‘ClassBVCDelegate’ and this only means that you didn’t use the methods of the protocol yet, imagine that when class A adopts the protocol is like signing a contract with class B and this contract says “Any class adopting me MUST use my functions!”

![](https://cdn-images-1.medium.com/max/800/0*0nAPyS5dneFZqjtm.jpg)

*Quick note: If you come from an Objective-C background you are probably thinking that you can also shut up that error making that method optional, but for my surprise, and probably yours, Swift does not have the concept of optional protocols.*

step 5: Look for the pragma mark step 5 inside the prepare for segue method and add this

```
//MARK: step 5 create a reference of Class B and bind them through the prepareforsegue method.
if let nav = segue.destination as? UINavigationController, let classBVC = nav.topViewController as? ClassBVC {
classBVC.delegate = self
}

```

Here we are just creating an instance of ClassBVC and assign its delegate to self, but what is self here? well, self is the ClassAVC which has been delegated!

step 6: Finally, look for the pragma step 6 in ClassAVC and let’s use the functions of the protocol, start typing func changeBackgroundColor and you will see that it’s auto-completing it for you. You can add any implementation inside it, in this example, we will just change the background color, add this.

```
//MARK: step 6 finally use the method of the contract
func changeBackgroundColor(_ color: UIColor?) {
view.backgroundColor = color
}

```

Now run the app!

![](https://cdn-images-1.medium.com/max/800/0*ME6nP1z13pvMyLep.gif)

Delegates are everywhere and you probably use them without even notice, if you create a table view in the past you used delegation, many classes of UIKIT works around them and many other frameworks too, they solve these main problems.

- Avoid tight coupling of objects.
- Modify behavior and appearance without the need to sub class objects.
- Allow tasks to be handled off to any arbitrary object.

Congratulations, you just implement a custom delegate, I know that you are probably thinking, so much trouble just for this? well, delegation is a very important design pattern to understand if you want to become an iOS developer, and always keep in mind that they have one to one relationship between objects.

Don’t worry if you find it confusing it took me a while to understand what’s going on, and even was a hard topic for everybody during my iOS Bootcamp., so just take it easy and if you want to talk about it find me on [Twitter.](https://twitter.com/roch4brun)

You can find the complete project [here](https://github.com/jamesrochabrun/DelegateTutorialFinal)

Peace!