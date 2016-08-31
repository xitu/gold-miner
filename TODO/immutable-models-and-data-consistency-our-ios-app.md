> * 原文地址：[Immutable models and data consistency in our iOS App](https://engineering.pinterest.com/blog/immutable-models-and-data-consistency-our-ios-app)
* 原文作者：[Wendy Lu](https://twitter.com/wendyluwho)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

Earlier this year, we re-architected our [iOS app](https://engineering.pinterest.com/blog/re-architecting-pinterests-ios-app) for a faster, cleaner experience, especially for the majority of Pinners using the app outside the U.S. One of the goals of the re-architecture was to move our app to a completely immutable model layer. In this post, I'll discuss the motivation behind this, and explore how our new system handles updating models, loading new information from the API and data consistency.

## Why immutable models?

“Immutable models” is a term we hear a lot about these days since many apps have converted to immutability. Immutability means that models can't be modified after initialization. Why should we use them? Well, the main problem of mutability lies in shared state.

Think about it this way: In a mutable model system, A and B both keep a reference to C.

![](https://engineering.pinterest.com/sites/engineering/files/Screen%20Shot%202016-08-19%20at%209.37.26%20AM_0.png)

If A modifies C, both A and B will see a changed value. This can be fine, but if B doesn't expect this, very bad things can happen.

For example, say I'm on a message thread with two other users. I have a message object with a ‘users’ property.

![](https://engineering.pinterest.com/sites/engineering/files/Screen%20Shot%202016-08-19%20at%209.38.32%20AM_0.png)

While I'm on this view, another part of the app decides to remove Devin from the conversation (perhaps it gets an updated server response and proceeds to change the model). When the second row is tapped, I look in my message.users array to retrieve the second object. This now returns Stephanie instead of Devin and I end up blocking the wrong person.

Immutable models are also inherently thread safe. Before, we had to worry that one thread may be writing to the model while another is trying to read it. In our new system, the object can't be changed after initialization, so we can safely have multiple threads reading concurrently without worrying about reading an unsafe value. This made our lives easier as our iOS app became increasingly concurrent and multithreaded.

## Updating models

Since our models are completely immutable after creation, the only way to update or change a model is to create an entirely new model object. We have two ways to do this:

*   Initialize a model using a dictionary (usually from a JSON response)

```
User *user = [[User alloc] initWithDictionary:dictionary];
```

*   Use a “builder” object, which is basically just a mutable representation of a model that takes on all of the model's properties. You can create a builder from an existing model, modify the properties you want, then call initWithBuilder to return the new model (more on this in a future post).

```
// Change the current user's username to “taylorswift”
UserBuilder *userBuilder = [[UserBuilder alloc] initWithModel:self.currentUser];
userBuilder.username = @"taylorswift";
self.currentUser = [[User alloc] initWithBuilder:userBuilder];
```

## Loading and caching API data

Our API allows us to request partial JSON models from the server, with a subset of the model's fields. For example, in the Pin feed view, we need fields such as the image URL and description, but we don't need to request full information, such as recipe ingredients, until the user navigates into the Pin close up view. This helps us cut down on the amount of data we send over the wire, as well as backend processing time.

![](https://engineering.pinterest.com/sites/engineering/files/Screen%20Shot%202016-08-19%20at%209.45.23%20AM_0.png)

We keep a central model cache built on [PINCache](https://github.com/pinterest/PINCache), an object cache we built and [open-sourced](https://engineering.pinterest.com/tags/pincache) for iOS. The keys of this cache are the unique, server-specified IDs of models. When we get a new server response, we check the cache for an existing model. If an existing model is found, we'll merge the fields of the server response and the properties of the existing model into a brand new model object. This new model replaces the existing one in the cache. This way, the cached model always contains the most recent superset of all fields that we've received.

![](https://engineering.pinterest.com/sites/engineering/files/Screen%20Shot%202016-08-19%20at%209.47.14%20AM_0.png)

## Data consistency

After a model is updated (i.e. a new model object is created), the changes should be reflected in the views that display the model. We previously used [Key-Value Observing](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html) for this, but KVO doesn't work with immutable objects–it only observes for changes on one instance of a model. We now use a NSNotificationCenter-based system to notify objects that a model they care about has been updated.

## Observing for changes

A view or view controller can register for update notifications on a model. In this example, the message view controller registers for updates on its message model. It would like to know when a new message model is created, because this new model may have updated properties.

![](https://engineering.pinterest.com/sites/engineering/files/Screen%20Shot%202016-08-19%20at%209.48.46%20AM_0.png)

The following code creates an observer that listens for updated models with the name + unique identifier of the message model. Under the hood of this method, we use the [block-based NSNotificationCenter API](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSNotificationCenter_Class/#//apple_ref/occ/instm/NSNotificationCenter/addObserverForName:object:queue:usingBlock:) so that we can better control observer lifetime.

```
[self.notificationManager addObserverForUpdatedModel:self.message block:^(NSNotification *notification) {
    // Update message view here!
}];
```

The notificationManager is just an NSObject that holds a strong reference to registered observers. Since it’s a property of our view controller, its dealloc should be called right after our view controller's dealloc, and we can make sure all observers are unregistered there.

## Posting changes

When the message model is updated, an update notification will be posted:

```
Message *newMessage = [[Message alloc] initWithBuilder:newBuilder];
[NotificationManager postModelUpdatedNotificationWithObject:newMessage];
```

postModelUpdatedNotificationWithObject will check the model cache for the most recent model of the same class + server identifier, and post the cached instance of the model.

## Making UI updates

When a notification is fired, the new model is passed in the “object” field of the NSNotification. The view controller can then make whatever updates it needs using the updated model!

```
__weak __typeof__(self) weakSelf = self;
[self.notificationManager addObserverForUpdatedModel:self.message block:^(NSNotification *notification) {
    __typeof__(self) strongSelf = weakSelf;
    Message *newMessage = (Message *)notification.object;
    strongSelf.usersInMessageThread = newMessage.users;
    [strongSelf.tableView reloadData];
}];
```

## Coming up

Switching out the entire model layer of a sizable app is no easy task, and we created some pretty cool tools to help us along the way. Look out for our next post, where we'll explain how we auto-generate all our model classes and more.

_Acknowledgements: Thank you to all our iOS developers for using and giving feedback on the new model layer, especially my teammates Rahul Malik, Chris Danford, Garrett Moon, Ricky Cancro, and Scott Goodson, as well as Bella You, Rocir Santiago and Andrew Chun for feedback on this post._

