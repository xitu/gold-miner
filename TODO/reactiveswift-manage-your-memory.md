> * 原文地址：[ReactiveSwift - Manage your memory!](https://eliaszsawicki.com/reactiveswift-manage-your-memory/)
* 原文作者：[Eliasz Sawicki](https://eliaszsawicki.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# ReactiveSwift - Manage your memory!




Memory management is a pretty important issue when talking about any kind of system. You can’t pretend that your resources are unlimited, and give them out no matter what. When working with `ReactiveSwift` it’s really easy to fall into the pit of wasted resources if you don’t follow simple rules.

## Disposables

Basic unit that will help us handle our memory management, when working with `ReactiveSwift` is `disposable`. At the same time that you start observing `Signal`, or start any work with `Signal Producer`, you will gain access to such `Disposable`. If you are not interested in results that come through that `Signal`, you can simply call `.dispose()` method on that `disposable`, and you won’t receive updates any more. This also means, that as soon as `SignalProducer` notices, that nobody is interested in it’s results, it can stop it’s work and clean resources.

It’s common to free any resources when you exit a screen in your application. This means, that you should dispose all your `disposables` as well. Of course it would be hard to store each `disposable` in separate variable and dispose when you’re not interested in updates anymore. That’s why we can use a container for such `disposables` - `CompositeDisposable`. You can basically throw any `disposable` inside this container, and dispose all of them at once when your view controller deinitializes.

Let’s take a look at how to work with disposables.



    // public variable accessible from outside of class
    var producer: SignalProducer

    init() {  
      producer = SignalProducer {[weak self] observer, compositeDisposable in
          guard let strongSelf = self else { return }
          compositeDisposable.add {
              print("I've been disposed! I can clean my resources ;)")
          }

          DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
              if !compositeDisposable.isDisposed {
                  strongSelf.performHeavyCalculation()
                  observer.send(value: "1")
              }
          })
          DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
              if !compositeDisposable.isDisposed {
                  strongSelf.performHeavyCalculation()
                  observer.send(value: "2")
              }
          })
      }

      // If you have compositeDisposables variable, then you can add it there
      // disposables += producer.startWithValues ...

      // You keep received disposable in variable
      let disposable = producer.startWithValues {[unowned self] (value) in
          print(value)
          self.performHeavyCalculation()
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          disposable.dispose() // After some time, you are not interested in producer's work, and you kindly tell him that
      }
    }



What will happen here? Producer does not start it’s work until `startWithValues` is called. After that, we have to actions scheduled that will send us values `1` and `2`. They will also perform some heavy calculations. After two seconds, I decide that I’m not interested in any results, so I dispose received `disposable` and I will not receive any updates in `startWithValues` block anymore. However, work in producer has been already scheduled. That’s why I put the `if` statement checking if someone is still interested in producer’s work. If not, I will not perform that.



    var disposables = CompositeDisposable()

    disposables += viewModel.criticalInfo.observeValues {[unowned self] (value) in
    // react to value
    }

    deinit {
      disposables.dispose()
    }



In this example, Let’s imagine that you create your `disposables` variable at the time you initialize your class. Then, when you start observing any signals, you add each `disposable` to your container. You can dispose them any time you want, but most often, you will do it at the time that you dealloc your controller, so you can add this code to `deinit`.

You may have noticed, that there are parts where are use `[weak self]` and `[unowned self]`. Let’s take a closer look at this!

## Working with closures

Disposables are one important thing that will lead you to memory management heaven. Next things that you have to remember about when working with ReactiveSwift is to manage relationships in closures that you pass to observers. When you do anything with a `self` variable in such closure, you create a retain cycle, as you hold strong reference to `self`. Controller holds a closure and closure holds controller. No way that they will be released any time soon. To have a weak reference to `self`, you can add `[weak self]` or `[unowned self]` to such closure. If you do not add one of those statements, your `disposables.dispose()` in `deinit` method will not be even reached, as controller will not be deinitialized.



    // weak reference, but we bet that self will not be nil
    disposables += signal.observe {[unowned self] values in
      self.workWithMeAllTheTime()
    }

    // weak reference, but self becomes optional
    disposables += signal.observe {[weak self] values in
      guard let strongSelf = self else { return }
      strongSelf.workWithMeAllTheTime()
    }

    ...

    deinit {
      disposable.dispose()
    }



What is the difference between `[weak self]` and `[unowned self]` you ask? When you use `[weak self]`, you tell your closure, that it is possible that `self` could be `nil` at some point. I usually put a `guard let` statement at the beginning of this kind of closure, so if `self` is nil, I don’t continue with any operations. On the other hand, we have `[unowned self]` that doesn’t tell us that `self` could be `nil` at some point. It’s on our side to take care of that and make sure that this block will not be called if `self` is deinitialized. If you properly take care of `disposables`, most often `[unowned self]` is a safe bet, as those closures will not be executed after deinitialization of `self`.

## A note to first example

Let’s get back to the code from first example. You can see, that I used a `[weak self]` for the `SignalProducer` and `[unowned self]` for the observer. Why did I do that?! When I start observing for values from producer in `startWithValues` closure, I’m pretty sure that I’ll call `dispose` when my controller deinits, so I know that `self` will be there if I need it. With given `SignalProducer` that’s a bit different. It is accessible from outside. Let’s imagine, that I’ve saved this producer at the time that this class was alive, and started it’s work after it was deinitialized. If I had `[unowned self]` there, then it would cause a crash. As long as I have `[weak self]`, at the beginning of my producer’s work I can check if `self` exists and If it doesn’t I can discontinue with any other work. If it does, I’ll create a reference to `self` and proceed with my work.

There are always edge cases, that may cause a headache when choosing between `unowned` and `weak`, but as the time goes, you’ll find it easier and easier to work with them! See you next time!

This article is cross-posted with my [my company blog](http://blog.brightinventions.pl/)



