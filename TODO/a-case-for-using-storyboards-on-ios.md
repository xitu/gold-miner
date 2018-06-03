> * 原文地址：[A Case For Using Storyboards on iOS](https://medium.cobeisfresh.com/a-case-for-using-storyboards-on-ios-3bbe69efbdf4)
> * 原文作者：[Marin Benčević](https://medium.cobeisfresh.com/@marinbenc)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# A Case For Using Storyboards on iOS #

![](https://cdn-images-1.medium.com/max/2000/1*YsN0CVtTY3I5d6UUEtUv6Q.png)

I’ve seen a lot of articles recently that argue against using storyboards when creating iOS apps. The most commonly mentioned arguments are that storyboards are not human readable, they are slow and they cause git conflicts. These are all valid concerns, but can be avoided. I want to tell you how we use storyboards on non-trivial projects, and how you can avoid these concerns and still get the nice things storyboards give you.

#### Why use storyboards?

> A picture is worth a thousand words.

Humans are visual thinkers. The vast majority of information we receive is through our eyes, and our brains are incredibly complex visual pattern matching machines, which help us understand the world around us.

Storyboards give you an overview of a screen in your app, unmatched by code representation, whether it’s XML or plain Swift. When you open up a storyboard, you can see all views, their positions and their hierarchies in a second. For each view, you can see all the constraints that affect it, and how it interacts with other views. The efficiency of transferring information visually can’t be matched with text.

Another benefit of storyboards is that it makes auto layout more intuitive. Auto layout is an inherently visual system. It might be a set of mathematical equations under the hood, but we don’t think like that. We think in terms of “this view needs to be next to this one at all times”. Doing auto layout visually is a natural fit.

![](https://cdn-images-1.medium.com/max/800/1*MS3ALafvQX2fmK-5onF0SQ.png)

Also, doing auto layout in storyboards gives you some compile-time safety. Most missing or ambiguous constraints are caught during the creation of the layout, not when you open the app. This means less time spent on tracking down ambiguous layouts, or finding out why a view is missing from the screen.

#### How you should do it ####

**One storyboard per UIViewController**

![](https://cdn-images-1.medium.com/max/800/1*5MgjKAMD4kH-3clAiaDT2A.png)

You wouldn’t write your whole app inside a single UIViewController. The same goes for storyboards. Each view controller deserves its own storyboard. This has several advantages.

1. **Git conflicts occur only if two developers are working on the same UIViewController in a storyboard at the same time.** In my experience, this doesn’t happen often, and it’s not hard to fix when it does.

2. **The storyboard is no longer slow to load, since it only loads one UIViewController.**

3. **You are free to instantiate any UIViewController whichever way you like, just by getting the initial view controller of a storyboard.** Whether you’re using segues or pushing them through code.

When I’m creating a new screen, my first step is to create a UIViewController. Once I did that, I create a storyboard **with the same name** as the view controller I just created. This lets you do a pretty cool thing: instantiate UIViewControllers in a type safe way, without hard-coded strings.

    let feed = FeedViewController.instance()
    // `feed` is of type `FeedViewController`

This method works by finding a storyboard with the same name as the class name, and getting the initial view controller from that storyboard.

I know that’s how NIBs are used. But the NIB format is outdated, and some features (like creating UITableViewCells in the actual UIViewController’s nib) are not supported in the .xib editor. I have a feeling that the list of unsupported features will only grow, and that’s why I use storyboards over nibs.

**No segues**

Segues seem cool at first, but as soon as you have to transmit data from one screen to the next, it becomes a pain. You have to store the data in some temporary variable somewhere, and then set that value inside the `prepare(for segue:, sender:)` method.

    class UsersViewController: UIViewController, UITableViewDelegate {
    
      private enum SegueIdentifier {
        static let showUserDetails = "showUserDetails"
      }
    
      var usernames: [String] = ["Marin"]
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        usernameToSend = usernames[indexPath.row]
        performSegue(withIdentifier: SegueIdentifier.showUserDetails, sender: nil)
      }
    
    
      private var usernameToSend: String?
    
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        switch segue.identifier {
          case SegueIdentifier.showUserDetails?:
    
            guard let usernameToSend = usernameToSend else {
              assertionFailure("No username provided!")
              return
            }
    
            let destination = segue.destination as! UserDetailViewController
            destination.username = usernameToSend
    
          default:
            break
        }     
      }

    }

This code has a lot of problems. `prepare(for:sender:)` is not a pure function since it depends on the temporary variable defined above it. Even worse, that variable is optional, and it’s unclear what should happen if it’s nil.

You need to remember to manually set the *usernameToSend* property, which adds mutable state to our code. You also need to cast the segue’s destination to the type you expect. That’s lot of boilerplate and more than one point of failure.

I would much rather have a function that takes a non-optional value, and pushes the next view controller with that value. Simple and easy.

    class UsersViewController: UIViewController, UITableViewDelegate {
    
      var usernames: [String] = ["Marin"]
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = usernames[indexPath.row]
        showDetail(withUsername: username)
      }
    
      private func showDetail(withUsername username: String) {
        let detail = UserDetailViewController.instance()
        detail.username = username
        navigationController?.pushViewController(detail, animated: true)
      }

    }

This code is much safer, more readable and more concise.

**All properties are set in code**

Leave all storyboard values at their defaults. If a label needs to have a different text, or a view needs to have a background color, those things are done in code. This relates especially to all the little checkmarks in the property inspector.

![](https://cdn-images-1.medium.com/max/800/1*QQ6_kcvyx1Z1vHdUYsc77A.png)

The reason is that you don’t want to hard-code fonts, colors and texts. You can have constants for those, and a single place where they are kept, so you have a single place to change when you need to make a design change.

Also, scanning the code for view properties is easier than trying to find which checkmarks are checked in the storyboard.

This means you can build auto layout and views in the storyboard, but [style them in code](https://medium.cobeisfresh.com/composable-type-safe-uiview-styling-with-swift-functions-8be417da947f), which gives you complete freedom to create reusable code and a human-readable change history.

#### What storyboards are for me ####

You might be reading this article and thinking “This guy says storyboards are great, and then says he doesn’t use half of the features!”, and you’re right!

Storyboards do have problems, and these are the ways I avoid those problems. I find storyboards very useful for what I want to do with them: create the view hierarchy and constraints. Nothing more, nothing less.

My point is to not disregard a whole technology because you don’t like one aspect of it. You are free to pick and choose which parts you want to use. **It’s not all or nothing.**

So for those of you who want the benefits or storyboards, but want to minimize the downsides, this is our approach that has worked very well so far. If you have any comments, feel free to leave a response or hit me up on @marinbenc on Twitter.

*If you liked this one, check out some some other articles from my team:*

[![](http://ww3.sinaimg.cn/large/006tNbRwgy1ff10iqm6lxj315a0ai76b.jpg)](https://medium.cobeisfresh.com/how-to-win-a-hackathon-tips-tricks-8cd391e18705)

[![](http://ww4.sinaimg.cn/large/006tNbRwgy1ff10jmsrsej314c0aa0ud.jpg)](https://medium.cobeisfresh.com/accessing-types-from-extensions-in-swift-32ca87ec5190)



---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
