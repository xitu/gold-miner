> * 原文地址：[Offline support: “Try again, later”, no more.](https://medium.com/@yonatanvlevin/offline-support-try-again-later-no-more-afc33eba79dc#.20vizj1qw)
* 原文作者：[Yonatan V. Levin](https://medium.com/@yonatanvlevin)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

---

# Offline support: “Try again, later”, no more.

I have the privilege of living in a country where 4G network and strong Wifi is almost everywhere — at home, at work, even at the basement of my friend’s apartment. 
And somehow, I still manage to get this:

![](https://cdn-images-1.medium.com/max/800/1*7yb_YRDhcX6EJJNCzWvRKA.png)

or this

![](https://cdn-images-1.medium.com/max/800/1*6vn5yYlQjc98odN8cgKHaA.png)

Maybe it’s because my Pixel phone is playing with me? Uh… no.

The internet connection is the most unstable thing that I have ever used. While in 95% of the time it’s works well, and I’m successfully able to stream my favorite music without any problem and always, always when I’m standing in an elevator and trying to send a message — it’s fails on me.

We, as developers live in an environment where a strong connection isn’t an issue, but the fact is — it is. Even more — just as in [Murphy’s law](https://en.wikipedia.org/wiki/Murphy%27s_law) — it will hurt your users exactly when they most need your App to work — and work fast.

Being an Android user and observing this “Try again” happening in many of my installed apps. I struggled to do something about it, at least in my app.

There are a lot of great talks about offline support, for example, [Yigit Boyar](https://medium.com/@yigitboyar) and his[ IO talk](https://www.youtube.com/watch?v=70WqJxymPr8) (you even can spot me at the first row cheering him).

---

### Our precious App

![](https://cdn-images-1.medium.com/max/800/0*DByDLXS1jHbKUFM6.)

Finally, after starting my own startup [KolGene](https://www.kolgene.com), I got my chance. In startups, as most of you know, you start by building your first [MVP](https://en.wikipedia.org/wiki/Minimum_viable_product) and testing your assumptions. The process is so crucial and hard, with so many things that could go wrong, that losing even a single customer because of an offline issue is totally unacceptable.

Every customer we lose costs us a lot of money.
If there were leaving because the experience of using the application was bad — well, it’s not even an option.

Our app usage is pretty simple: A clinician creates a request for genetic tests on mobile app, the relevant laboratories receive a message, submit offers, clinician receives those offers and chooses the best offer based on their needs.

![](https://cdn-images-1.medium.com/max/600/1*9r3IDFmhfe5h0bBUeesSFg.gif)

When we discussed various UX solutions, we decided on the following: No loading bar at all — even if it’s very beautiful.

The app should work smoothly without putting the user in a “waiting” state.

So basically what we want to achieve, is that internet connectivity shouldn’t matter — the app will always work.

And the result was:

![](https://cdn-images-1.medium.com/max/800/1*_Cjxt6cmEQ1NeBoUbvN3KA.gif)

When the user is in offline mode, he submits the request and … it’s submitted. 
The only small reminder about being offline is small icon of “syncing” status at the top right corner. Once he comes online, the app will post his request to the server regardless if it is in background or foreground.

![](https://cdn-images-1.medium.com/max/800/1*Jx1PeLYYsKC809YCckpxAw.gif)

Same goes for every other network request-except for registration and sign In.

So how did we do it?

First we started by completely separating our view, logic and persistence model. As [Yigit Boyar](https://medium.com/@yigitboyar) says:

> Act locally, sync globally

It means that your model should be persistent and will be updated from the outside world. The data from model should propagate asynchronously using callbacks/events to the presenter and later to the view. Remember - the view is dumb and only reflects what we have in our model. No loading dialogs. Nothing. The view reacts to user and passes the interaction result through the presenter to the model and later, receives the next state to show.

![](https://cdn-images-1.medium.com/max/1000/1*npK-x_AUzNQxRIpsZ4Gqrw.png)

For local storage we use [SQLite](https://developer.android.com/training/basics/data-storage/databases.html). On top of it we decided to wrap it in a [Content Provider](https://developer.android.com/guide/topics/providers/content-providers.html) because of its [ContentObserver](https://developer.android.com/reference/android/database/ContentObserver.html) capability for events. 
ContentProvider is a nice abstraction for Data access and manipulation.

Why not RxJava? Well, it’s completely different topic. In short — for a startup, when you need to move as fast as possible and the project changes hands every couple months — we decided to leave it as simple as possible. 
Besides, I love ContentProvider, and there are a lot of additional capabilities: [auto-initialization](https://firebase.googleblog.com/2016/12/how-does-firebase-initialize-on-android.html) , [running in a separate process](https://developer.android.com/guide/components/processes-and-threads.html#Processes) and a [custom search interface](https://developer.android.com/guide/topics/search/adding-custom-suggestions.html).

For background sync jobs, we choose to use [GCMNetworkManager](https://developers.google.com/cloud-messaging/network-manager). If you’re not familiar with it — it’s enables scheduling tasks/periodic tasks to be executed when certain specific conditions met, like internet connection for example and it lives really well with [Doze mode](https://developer.android.com/training/monitoring-device-state/doze-standby.html).

So the architecture looks like this:

![](https://cdn-images-1.medium.com/max/1000/1*RvHF6kSmJoUOTxG9JuqsHg.png)

### The flow: Create Order and Sync it.

*Step 1:* Presenter creates new order and sends it for insert via ContentResolver to Content Provider.

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

*Step 2:* Content Provider inserts into the local database and notifies all observables that there is a new order created with status *“pending”*.

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

*Step 3*: Our background service that was registered to observe changes in Order table by URI — gets notified and starts the specific service for this task.

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

*Step 4*: The service obtains the data from DB and tries to sync it over the network. When network request succeeds— the order is updated with status “synced” via ContentResolver.

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

*Step 5*: If the request fails, it will schedule GCMNetworkManager one-time task with `.setRequiredNetwork(Task.NETWORK_STATE_CONNECTED)` and order id.

When the criteria is met (the device is connected to the internet and no doze mode), GCMNetworkManager calls *onRunTask()* and the app will try to sync our order once again. If it fails again — it will reschedule it.

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

Once the order is synced, a background service or GCMNetworkManager will update the status of local order via ContentResolver with the status *“synced”.*

![](https://cdn-images-1.medium.com/max/800/1*MOUPz0cimb0LaUktu4FvMw.png)

![](https://cdn-images-1.medium.com/max/800/1*nquwIHLwfOSyPEQVl-qMow.gif)

Of course this type of architecture is not bulletproof. It requires that you handle all possible edge cases, for example what if you schedule a task to update an existing order on the server, but it was canceled/changed by an admin on the server side? What if they change the same property? What should happen if the first update was made by the user, or by an admin?
Some of them we solved immediately. Some of them we left in production (they are really rare). The different approaches that we took to solve these isseus, I will share in one of my next articles.

And there is definitely some room for improvements in our codebase as Fred says:

> Even the best planning is not so omniscient as to get it right the first time.
> 
> — Fred Brooks

But we continue to struggle to improve it and make usage of our [KolGene](http://www.kolgene.com) App delightful and full of joy to the users.

![](https://cdn-images-1.medium.com/max/800/1*o5gY6EvVN7ds02NDgBAAAg.gif)