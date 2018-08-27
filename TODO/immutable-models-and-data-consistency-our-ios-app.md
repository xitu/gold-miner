> * 原文地址：[Immutable models and data consistency in our iOS App](https://engineering.pinterest.com/blog/immutable-models-and-data-consistency-our-ios-app)
* 原文作者：[Wendy Lu](https://twitter.com/wendyluwho)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Kulbear](https://github.com/kulbear)
* 校对者：[steinliber](https://github.com/steinliber), [MAYDAY1993](https://github.com/MAYDAY1993)

# iOS APP 中的不可变模型以及一致性数据

今年早些时候，为了给用户，尤其是大部分海外的用户更快更清晰的体验，我们全面重构了我们的 [iOS 应用](https://engineering.pinterest.com/blog/re-architecting-pinterests-ios-app)。这次重构的其中一个目的是将我们的应用迁移到一个不可变模型的层面上。在这篇博客中，我将会讨论这样做的动机，并探索我们的新系统是如何处理模型的更新，从 API 读取新信息，以及保持数据持久性的。

## 为什么选择不可变模型？

因为现今许多应用都转而使用了不可变设计，‘不可变模型’已经成为了一个耳熟能详的术语。不可变性意味着再初始化后模型将不可再更改。但为何我们要使用他们呢？嗯，主要问题在于可变性在状态共享方面有一些问题。

想象这样一个情景，在一个模型可变的系统中，A 和 B 都保持引用指向 C。

![](https://engineering.pinterest.com/sites/engineering/files/Screen%20Shot%202016-08-19%20at%209.37.26%20AM_0.png)

如果 A 修改了 C，那么 A 和 B 都将会看到这个变更。这似乎并没有什么问题，但如果 B 并（如：没有在设计中）未预期这个改变，可能会发生很糟糕的事情。

比如，我在和其他两个用户共享一个消息线程。我有一个带有一个叫 ‘users’ 属性的消息对象。

![](https://engineering.pinterest.com/sites/engineering/files/Screen%20Shot%202016-08-19%20at%209.38.32%20AM_0.png)

如果我正处于这个界面的同时，应用的另一部分决定将 Devin 从 对话中移除（也许应用收到了服务器更新的响应之后更改了这个模型）。当我点击第二行的时候，我在 message.user 这个数组中读取第二个对象。此时返回给我的对象将是 Stephanie 而非 Devin，从而使我错误的屏蔽了他人。

不可变模型是线程安全的。之前，我们总会担心一个线程变更一个对象的同时，另一个线程想要读取它。在我们的新系统里，一个对象在初始化后无法被更改，所以我们可以很安全地拥有多个线程同时读取对象而不用担心读取到了不安全的值。因为我们的iOS应用程序变得高并发和多线程，这使得我们的生活更加简单。

## 更新模型

因为我们的模型在创建后不可更改，唯一的更新／变更方法就是重新创建一个全新的模型对象。我们有两种方法来做这件事：

* 通过一个字典来初始化模型（通常是来自于一个 JSON 类型的响应）

```
User *user = [[User alloc] initWithDictionary:dictionary];
```

* 使用一个 “builder” 对象，基本上它就是一个可变的对模型的表述方法，它包含模型需要的所有属性。你可以通过现存的模型创建一个 builder，编辑你需要更改的属性，然后调用 initWithBuilder 来返回新的模型（以后的博客中会探讨这个）。

```
// Change the current user's username to “taylorswift”
UserBuilder *userBuilder = [[UserBuilder alloc] initWithModel:self.currentUser];
userBuilder.username = @"taylorswift";
self.currentUser = [[User alloc] initWithBuilder:userBuilder];
```

## 读取和缓存 API 的数据

我们的 API 允许我们通过模型属性的子集从服务器请求部分的 JSON 模型。比如，在 Pin 这个界面上，我们需要一些诸如图片 URL 和详细描述这样的属性，但我们在用户点进去之前都不需要全部的信息（比如配料表）。这样的设计帮我们削减了需要传输的数据量和后端处理的时间。

![](https://engineering.pinterest.com/sites/engineering/files/Screen%20Shot%202016-08-19%20at%209.45.23%20AM_0.png)

我们用 [PINCache](https://github.com/pinterest/PINCache) 来保持我们核心模型的缓存。[PINCache](https://github.com/pinterest/PINCache) 是一个在 iOS 上处理缓存对象并被我们[开源](https://engineering.pinterest.com/tags/pincache)的库。缓存的键是由服务端提供的模型唯一 ID。当我们收到一个新的服务器响应时，我们检查现有模型的缓存。如果找到了已存在的模型，我们将会将现有模型和从服务器响应中返回的变更属性合并后创建一个新的模型。新的模型将会替换掉缓存中现有的这一个模型。这样，缓存中的模型将会始终为最新的超集（基于我们收到的所有属性变更）。

![](https://engineering.pinterest.com/sites/engineering/files/Screen%20Shot%202016-08-19%20at%209.47.14%20AM_0.png)

## 数据持久性

当一个模型被更新后（即，一个新的模型被创建了），变更的内容应该即时反应在需要这个模型的界面上。我们之前使用了 [Key-Value 监视](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html) 来处理这个情况，但这种方法由于只监视一个模型的实例而不可应用于不可变对象上。我们现在使用一个基于 NSNotificationCenter 的系统来告知对象们——你们所关注的模型刚刚被更新了。

## 监视变更

一个视图或视图控制器可以注册在一个模型的更新通知中。在这个例子中，消息视图控制器注册于消息模型的变更上。任何新的消息模型被创建，它都会第一时间知道。

![](https://engineering.pinterest.com/sites/engineering/files/Screen%20Shot%202016-08-19%20at%209.48.46%20AM_0.png)

下面的代码创建了一个通过名字和独一辨识监听更新后的模型的观察者。在这个方法背后，我们使用了 [block-based NSNotificationCenter API](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSNotificationCenter_Class/#//apple_ref/occ/instm/NSNotificationCenter/addObserverForName:object:queue:usingBlock:)，这样我们可以更好的控制观察者的生命周期。

```
[self.notificationManager addObserverForUpdatedModel:self.message block:^(NSNotification *notification) {
    // Update message view here!
}];
```

这个 notificationManager 是一个 NSObject 的子类，他保持了对注册的观察者的强引用。因为它是我们视图控制器的一个属性，他的 dealloc 将会在视图控制器的 dealloc 之后被立即调用，从而使我们能保证所有的观察者这时都被注销了。

## 发布变更

当消息模型变更时，将会发送一个通知。

```
Message *newMessage = [[Message alloc] initWithBuilder:newBuilder];
[NotificationManager postModelUpdatedNotificationWithObject:newMessage];
```

postModelUpdatedNotificationWithObject 将会通过最近的同类模型和服务端的辨识标记检查模型的缓存，然后根据模型实例的缓存发布更新。

## 更新用户界面

一个通知发布以后，新的模型会作为 NSNotification 的一个 ‘object’ 属性传递。视图控制器可以随时随地的更新它需要的模型。

```
__weak __typeof__(self) weakSelf = self;
[self.notificationManager addObserverForUpdatedModel:self.message block:^(NSNotification *notification) {
    __typeof__(self) strongSelf = weakSelf;
    Message *newMessage = (Message *)notification.object;
    strongSelf.usersInMessageThread = newMessage.users;
    [strongSelf.tableView reloadData];
}];
```

## 后记

将一个具有规模的应用迁移到新的模型层面上是一个具有挑战的任务，在这个过程中我们创建了许多辅助工具。请参见我们下一篇博客，我们会在当中解释我们如何自动生成所有的模型类等等。

_感谢：感谢所有使用我们的新模型并反馈问题的 iOS 开发人员们，尤其需要提到的是我的队友 Rahul Malik， Chris Danford，Garrett Moon，Ricky Cancro，and Scott Goodson，以及 Bella You，Rocir Santiago 和 Andrew Chun 对于本文提供的反馈。_
