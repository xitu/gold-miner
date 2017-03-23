> * 原文地址：[Offline support: “Try again, later”, no more.](https://medium.com/@yonatanvlevin/offline-support-try-again-later-no-more-afc33eba79dc#.20vizj1qw)
* 原文作者：[Yonatan V. Levin](https://medium.com/@yonatanvlevin)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[skyar2009](https://github.com/skyar2009)
* 校对者：[phxnirvana](https://github.com/phxnirvana), [yazhi1992](https://github.com/yazhi1992)

---

# 离线支持：不再『稍后重试』。

我很荣幸生活在一个 4G 网络和 Wifi 随处可见的国家，家中、公司、甚至我朋友公寓的地下室（都有网络）。
尽管如此，我依然会遇到下面的问题：

![](https://cdn-images-1.medium.com/max/800/1*7yb_YRDhcX6EJJNCzWvRKA.png)

或者

![](https://cdn-images-1.medium.com/max/800/1*6vn5yYlQjc98odN8cgKHaA.png)

或许是手机在和我开玩笑吧……

网络连接是我用过最不稳定的东西。95% 的情况下网络是正常工作的，我能流畅地欣赏喜欢的音乐，但是在电梯中发送消息则往往会失败。

像我们程序员生存在良好的的网络环境下这不是什么问题，但事实上这是个问题。甚至会伤害你的用户，尤其是他们最需要你的 App 时（详见[墨菲定律](https://en.wikipedia.org/wiki/Murphy%27s_law)）。

作为一个 Android 用户，我注意到了在我安装的许多应用中都存在『重试』的问题。我努力做些什么改善这类问题，至少是在自己的应用中。

关于离线支持有很多好的观点，例如 [Yigit Boyar](https://medium.com/@yigitboyar) 和他的[ IO talk](https://www.youtube.com/watch?v=70WqJxymPr8) (你甚至可以看到我在前排为他点赞)。

---

### 我们的宝贝应用

![](https://cdn-images-1.medium.com/max/800/0*DByDLXS1jHbKUFM6.)

最终，当我开始创办自己的公司 [KolGene](https://www.kolgene.com) 之后，我有了机会。大家都知道，创业公司首先需要构建一个 [MVP](https://en.wikipedia.org/wiki/Minimum_viable_product) 来验证假设的正确性。这个过程是如此的关键、艰难，任何一个环节都可能出错，甚至因为未联网问题而导致失去一个用户也是无法接受的。

每失去一个用户都意味着我们的许多支出打了水漂。
如果是因为应用使用体验差而离开，那也是不能接受的。

我们的应用使用很简单：临床医生在手机应用上创建基因测试的请求；相关实验室将收到信息、提交试验结果；临床医生收到结果，并根据需要选择最好的结果。

![](https://cdn-images-1.medium.com/max/600/1*9r3IDFmhfe5h0bBUeesSFg.gif)

经过一系列 UX 方案的讨论，最终我们决定使用如下方案：抛弃加载进度条 —— 尽管它很美丽。

应用应该流畅地运行，不需要置用户于等待状态。

总的来说我们要实现的是让网络连接不再是问题 —— 应用永远可用。

结果如下：

![](https://cdn-images-1.medium.com/max/800/1*_Cjxt6cmEQ1NeBoUbvN3KA.gif)

当用户处于离线模式，他只要提交请求就会成功。
仅有的离线状态小提示是右上角的同步状态图标。一旦联网，无论应用是在前台还是后台，都会将用户的请求发送到服务器。

![](https://cdn-images-1.medium.com/max/800/1*Jx1PeLYYsKC809YCckpxAw.gif)

除了注册和登录外的其他网络请求都采用了相同的处理。

我们是如何实现的呢？

我们首先彻底地将视图、逻辑以及持久化的模型分开。如 [Yigit Boyar](https://medium.com/@yigitboyar) 所说：

> 本地操作，全局同步。

这就意味着你的模型需要持久化并且会被外界更新。模型中的数据应该使用回调/事件的方法异步地传递给 presenter 以及视图。记住 —— 视图是不能言语的，它只是对模型中内容的显示。没有加载对话框和任何内容。视图响应用户的操作，并通过 presenter 将交互结果传递到模型，然后接收、显示下一状态。

![](https://cdn-images-1.medium.com/max/1000/1*npK-x_AUzNQxRIpsZ4Gqrw.png)

本地存储我们使用的是 [SQLite](https://developer.android.com/training/basics/data-storage/databases.html)。在它基础上我们包装了一层 [Content Provider](https://developer.android.com/guide/topics/providers/content-providers.html)，因为其对事件的 [ContentObserver](https://developer.android.com/reference/android/database/ContentObserver.html) 能力。
ContentProvider 是对数据访问和操作非常好的抽象。

为什么不使用 RxJava？呃，这是另一个话题了。长话短说，作为创业公司，我们动作要尽可能快并且项目几个月就要迭代更新一次，所以我们决定开发过程越简单越好。
而且，我喜欢 ContentProvider，它还有一些额外的能力：[自动初始化](https://firebase.googleblog.com/2016/12/how-does-firebase-initialize-on-android.html)，[单独进程运行](https://developer.android.com/guide/components/processes-and-threads.html#Processes)以及[自定义搜索接口](https://developer.android.com/guide/topics/search/adding-custom-suggestions.html)。

对于后台同步任务，我们选择使用的是 [GCMNetworkManager](https://developers.google.com/cloud-messaging/network-manager)。 如果你对它不熟悉 —— 它支持在达到特定条件时触发调度执行任务/周期性任务，比如网络恢复连接，GCMNetworkManager 在 [Doze 模式](https://developer.android.com/training/monitoring-device-state/doze-standby.html) 下工作很好。

框架结构如下所示：

![](https://cdn-images-1.medium.com/max/1000/1*RvHF6kSmJoUOTxG9JuqsHg.png)

### 工作流：创建订单并同步

**步骤 1:** Presenter 创建新订单并通过 ContentResolver 传递给 Content Provider 存储。

![](https://cdn-images-1.medium.com/max/800/1*V-5Lzm1AaITF4FjH3hcpfg.png)

```
public class NewOrderPresenter extends BasePresenter<NewOrderView> {
  //...
  
  private int insertOrder(Order order) {
    //turn order to ContentValues object (used by SQL to insert values to Table)
    ContentValues values = order.createLocalOrder(order);
    //call resolver to insert data to the Order table
    Uri uri = context.getContentResolver().insert(KolGeneContract.OrderEntry.CONTENT_URI, values);
    //get Id for order.
    if (uri != null) {
      return order.getLocalId();
    }
    return -1;
  }
  
  //...
}
```

**步骤 2:** Content Provider 将数据存储到本地数据库，并通知所有观察者新创建了一个**『待处理』**状态的订单。

![](https://cdn-images-1.medium.com/max/800/1*yKM91Jxgude1NZ4FDkVOkA.png)

```
public class KolGeneProvider extends ContentProvider {
  //...
  @Nullable @Override public Uri insert(@NonNull Uri uri, ContentValues values) {
    //open DB for write
    final SQLiteDatabase db = mOpenHelper.getWritableDatabase();
    //match URI to action.
    final int match = sUriMatcher.match(uri);
    Uri returnUri;
    switch (match) {
      //case of creating order.
      case ORDER:
        long _id = db.insertWithOnConflict(KolGeneContract.OrderEntry.TABLE_NAME, null, values,
            SQLiteDatabase.CONFLICT_REPLACE);
        if (_id > 0) {
          returnUri = KolGeneContract.OrderEntry.buildOrderUriWithId(_id);
        } else {
          throw new android.database.SQLException(
              "Failed to insert row into " + uri + " id=" + _id);
        }
        break;
      default:
        throw new UnsupportedOperationException("Unknown uri: " + uri);
    }
    
    //notify observables about the change
    getContext().getContentResolver().notifyChange(uri, null);
    return returnUri;
  }
  //...
}
```

**步骤 3:** 我们注册的用来监听订单表的后台服务，接收到相应 URI 并开始执行该任务的特定服务。 

![](https://cdn-images-1.medium.com/max/800/1*ZPbhDIWPmIIeTpa_2jqVjA.png)

```
public class BackgroundService extends Service {

  @Override public int onStartCommand(Intent intent, int i, int i1) {
    if (observer == null) {
      observer = new OrdersObserver(new Handler());
      getContext().getContentResolver()
        .registerContentObserver(KolGeneContract.OrderEntry.CONTENT_URI, true, observer);
    }
  }
   
  
  //...
  @Override public void handleMessage(Message msg) {
      super.handleMessage(msg);
      Order order = (Order) msg.obj;
      Intent intent = new Intent(context, SendOrderService.class);
      intent.putExtra(SendOrderService.ORDER_ID, order.getLocalId());
      context.startService(intent);
  }
  
  //...

}
```

**步骤 4:** 服务从 DB 获取数据，并尝试同步服务端。当网络请求成功后，通过 ContentResolver 将订单的状态更新为『已同步』。

![](https://cdn-images-1.medium.com/max/800/1*lMFYUWZZqJPWHp3hXVbVJg.png)

```
public class SendOrderService extends IntentService {

  @Override protected void onHandleIntent(Intent intent) {
    int orderId = intent.getIntExtra(ORDER_ID, 0);
    if (orderId == 0 || orderId == -1) {
      return;
    }

    Cursor c = null;
    try {
      c = getContentResolver().query(
          KolGeneContract.OrderEntry.buildOrderUriWithIdAndStatus(orderId, Order.NOT_SYNCED), null,
          null, null, null);
      if (c == null) return;
      Order order = new Order();
      if (c.moveToFirst()) {
        order.getSelfFromCursor(c, order);
      } else {
        return;
      }

      OrderCreate orderCreate = order.createPostOrder(order);

      List<LocationId> locationIds = new LabLocation().getLocationIds(this, order.getLocalId());
      orderCreate.setLabLocations(locationIds);
      Response<Order> response = orderApi.createOrder(orderCreate).execute();

      if (response.isSuccessful()) {
        if (response.code() == 201) {
          Order responseOrder = response.body();
          responseOrder.setLocalId(orderId);
          responseOrder.setSync(Order.SYNCED);
          ContentValues values = responseOrder.getContentValues(responseOrder);
          Uri uri = getContentResolver().update(
              KolGeneContract.OrderEntry.buildOrderUriWithId(order.getLocalId()), values);
          return;
        }
      } else {
        if (response.code() == 401) {
          ClientUtils.broadcastUnAuthorizedIntent(this);
          return;
        }
      }
    } catch (IOException e) {
    } finally {
      if (c != null && !c.isClosed()) {
        c.close();
      }
    }
    SyncOrderService.scheduleOrderSending(getApplicationContext(), orderId);
  }
}
```

**步骤 5:** 如果请求失败，会使用 GCMNetworkManager 安排一个一次性任务，设置 `.setRequiredNetwork(Task.NETWORK_STATE_CONNECTED)` 和订单 id。

当条件达到时（设备连接网络并且非 doze 模式），GCMNetworkManager 调用 **onRunTask()**，应用会再次尝试同步订单。如果依然失败，重新进行调度。

![](https://cdn-images-1.medium.com/max/800/1*bVnwsrtBifduv8ymaaft1A.png)

```
public class SyncOrderService extends GcmTaskService {
   //...
   public static void scheduleOrderSending(Context context, int id) {
    GcmNetworkManager manager = GcmNetworkManager.getInstance(context);
    Bundle bundle = new Bundle();
    bundle.putInt(SyncOrderService.ORDER_ID, id);
    OneoffTask task = new OneoffTask.Builder().setService(SyncOrderService.class)
        .setTag(SyncOrderService.getTaskTag(id))
        .setExecutionWindow(0L, 30L)
        .setExtras(bundle)
        .setPersisted(true)
        .setRequiredNetwork(Task.NETWORK_STATE_CONNECTED)
        .build();
    manager.schedule(task);
  }
  
  //...
  @Override public int onRunTask(TaskParams taskParams) {
    int id = taskParams.getExtras().getInt(ORDER_ID);
    if (id == 0) {
      return GcmNetworkManager.RESULT_FAILURE;
    }
    Cursor c = null;
    try {
      c = getContentResolver().query(
          KolGeneContract.OrderEntry.buildOrderUriWithIdAndStatus(id, Order.NOT_SYNCED), null, null,
          null, null);
      if (c == null) return GcmNetworkManager.RESULT_FAILURE;
      Order order = new Order();
      if (c.moveToFirst()) {
        order.getSelfFromCursor(c, order);
      } else {
        return GcmNetworkManager.RESULT_FAILURE;
      }

      OrderCreate orderCreate = order.createPostOrder(order);

      List<LocationId> locationIds = new LabLocation().getLocationIds(this, order.getLocalId());
      orderCreate.setLabLocations(locationIds);
      
      Response<Order> response = orderApi.createOrder(orderCreate).execute();

      if (response.isSuccessful()) {
        if (response.code() == 201) {
          Order responseOrder = response.body();
          responseOrder.setLocalId(id);
          responseOrder.setSync(Order.SYNCED);
          ContentValues values = responseOrder.getContentValues(responseOrder);
          Uri uri = getContentResolver().update(
              KolGeneContract.OrderEntry.buildOrderUriWithId(order.getLocalId()), values);
          return GcmNetworkManager.RESULT_SUCCESS;
        }
      } else {
        if (response.code() == 401) {
          ClientUtils.broadcastUnAuthorizedIntent(getApplicationContext());
        }
      }
    } catch (IOException e) {
    } finally {
      if (c != null && !c.isClosed()) c.close();
    }
    return GcmNetworkManager.RESULT_RESCHEDULE;
  }

  //...
}
```

订单一旦同步成功，后台服务或 GCMNetworkManager 会通过 ContentResolver 将订单的本地状态更新为**『已同步』**。

![](https://cdn-images-1.medium.com/max/800/1*MOUPz0cimb0LaUktu4FvMw.png)

![](https://cdn-images-1.medium.com/max/800/1*nquwIHLwfOSyPEQVl-qMow.gif)

当然该框架不是万能的。你需要处理所有可能的边界条件，例如同步一个服务端已经存在订单，但是管理员已经在服务端对其进行了取消/修改？如果他们修改了相同的属性怎么办？如果首次更新是由普通用户或管理员进行会发生什么？在我们的产品中对部分这类问题已经处理，但是部分问题采取不处理方案（毕竟很少发生）。我们解决这类问题的不同方法，我会在后面的文章进行介绍。

正如 Fred 所说，我们的代码库确实存在改进空间：

> 即使最好的方案也不会完美到一次成功。
>
> —— Fred Brooks

但是我们会继续为改进而努力，让我们的 [KolGene](http://www.kolgene.com) 使用起来更舒心，给用户带来满足。

![](https://cdn-images-1.medium.com/max/800/1*o5gY6EvVN7ds02NDgBAAAg.gif)