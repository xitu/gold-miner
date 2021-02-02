> * 原文地址：[How to Use IndexedDB — A NoSQL DB on the Browser](https://blog.bitsrc.io/how-to-use-indexeddb-a-nosql-db-on-the-browser-f845da3caf35)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-use-indexeddb-a-nosql-db-on-the-browser.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-use-indexeddb-a-nosql-db-on-the-browser.md)
> * 译者：
> * 校对者：

# How to Use IndexedDB — A NoSQL DB on the Browser

![](https://cdn-images-1.medium.com/max/5760/1*w6RCiqFjxootFGuWpCnkRw.jpeg)

Have you heard of the NoSQL database on the browser?

> **IndexedDB** is a large-scale, NoSQL storage system. It lets you store just about anything in the user’s **browser**. In addition to the usual search, get, and put actions, **IndexedDB** also supports transactions.
>
> Source: [developers.google.com](https://developers.google.com/web/ilt/pwa/working-with-indexeddb)

You can find an example of an IndexedDB below.

![[Source](https://developers.google.com/web/ilt/pwa/working-with-indexeddb)](https://cdn-images-1.medium.com/max/3488/1*2XRdyD3uHCnjK-5WXpAfQw.png)

In this article, we’ll focus on the following.

* Why do we need IndexedDB?
* How do we use an IndexedDB in our applications?
* Features of IndexedDB
* Limitations of IndexedDB
* Is IndexedDB right for your applications?

## Why do we need IndexedDB?

> Indexed DB is considered more powerful than `localStorage!`

Do you know the reason behind it? Let’s find out.

* **Can store much bigger volumes of data than `localStorage`**

There is no particular limit like in `localStorage` (between 2.5MB and 10MB). The maximum limit is based on the browser and the disk space. For example, Chrome and Chromium-based browsers allow up to 80% disk space. If you have 100GB, Indexed DB can use up to 80GB of space, and 60GB by a single origin. Firefox allows up to 2GB per origin while Safari allows up to 1GB per origin.

* **Can store any kind of value based on `{ key: value }` pairs**

Higher flexibility to store different data types. This means not only strings but also binary data (ArrayBuffer objects, Blob objects, etc.). It uses an object store to hold data internally

* **Provides lookup interfaces**

This is not available in other browser storage options such as `localStorage` and `sessionStorage` .

* **Useful for web applications that don’t require a persistent internet connection**

IndexedDB can be very useful for applications that work both online and offline. For example, this can be used for client-side storage in Progressive Web Apps (PWAs).

* **Application state can be stored**

By storing the application state for recurring users, the performance of your application can be increased drastically. Later on, the application can sync-up with the backend server and update the application via lazy loading.

Let’s have a look at the structure of the IndexedDB which can store multiple databases.

#### Structure of IndexedDB

![](https://cdn-images-1.medium.com/max/2120/1*c0AXi5lhjUQiLxRNVJwr2w.png)

## How do we use Indexed DB in our applications?

In the following section, we’ll look at how to bootstrap an application with IndexedDB.

#### 1. Open the database connection using “window.indexedDB"

```js
const openingRequest = indexedDB.open('UserDB', 1);
```

In here, `UserDB` is the database name and `1` is the version of the DB. This would return an object which is an instance of the `IDBOpenDBRequest` interface.

#### 2. Create object store

Once the database connection is open, the `onupgradeneeded` event will be fired, which can be used to create object stores.

```js
// Create the UserDetails object store and indexes

request.onupgradeneeded = (event) => {
     let db = event.target.result;

     // Create the UserDetails object store 
     // with auto-increment id
     let store = db.createObjectStore('UserDetails', {
         autoIncrement: true
     });

     // Create an index on the NIC property
     let index = store.createIndex('nic', 'nic', {
         unique: true
     });
 };
```

#### 3. Insert data into the object store

Once a connection is opened to the database, the data can be managed inside the `onsuccess` event handler. Inserting data happens in 4 steps.

```js
function insertUser(db, user) {
    // Create a new transaction
    const txn = db.transaction('User', 'readwrite');

    // Get the UserDetails object store
    const store = txn.objectStore('UserDetails');

    // Insert a new record
    let query = store.put(user);

    // Handle the success case
    query.onsuccess = function (event) {
        console.log(event);
    };

    // Handle the error case
    query.onerror = function (event) {
        console.log(event.target.errorCode);
    }

    // Close the database once the transaction completes
    txn.oncomplete = function () {
        db.close();
    };
}
```

Once the insertion function is created, the `onsuccess` event handler of the request can be used to insert more records.

```js
request.onsuccess = (event) => {
   const db = event.target.result;

   insertUser(db, {
     email: 'john.doe@outlook.com',
     firstName: 'John',
     lastName: 'Doe',
   });

   insertUser(db, {
     email: 'ann.doe@gmail.com',
     firstName: 'Ann',
     lastName: 'Doe'
   });
};
```

There are many operations that can be performed on the IndexedDB. Some of them are as follows.

* Read/search data from object stores by key
* Read/search data from object stores by index
* Update data of a record
* Delete a record
* Migrate from a previous version of a database, etc.

If you need insights about how to achieve the above, let me know in the comments section below. You can refer [here](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API/Using_IndexedDB) for more information.

## Features of Indexed DB

Indexed DB provides many special features that no other browser storage can achieve. Some of the features are briefly explained below.

* **Has an asynchronous API**

This enables performing costly operations without blocking the UI thread and provides a better experience to users

* **Supports transactions for reliability**

If one step fails, the transaction will be canceled and the database will be rolled back to the previous state.

* **Supports versioning**

You can version your database when you are creating it and upgrade the version when needed. Migrating from old versions to new versions is also possible in IndexedDB.

* **Private to domain**

A database is private to a domain, therefore any other site cannot access another website’s IndexedDB stores. This is also called the **Same-origin Policy**.

## Limitations of IndexedDB

So far, IndexedDB seems promising for client-side storage. However, there are few limitations worth noticing.

* Even though it has modern browser support, browsers such as IE does not have complete support for this.

![[Source](https://caniuse.com/?search=indexeddb)](https://cdn-images-1.medium.com/max/5472/1*II1BZYdl_uodU0W-6uOAwQ.png)

* Firefox disables IndexedDB completely, in private browsing mode — This can cause your application to malfunction when accessed via an incognito window.

## Is IndexedDB right for your application?

Based on the many features provided by IndexedDB, the answer to this million-dollar question could be Yes! However, before jumping to a conclusion, ask yourself the following questions.

* Does your application require offline access?
* Do you need to store a large amount of data on the client-side?
* Do you need to quickly locate/search data in a large set of data?
* Does your application access the client-side storage using the supported browsers by IndexedDB?
* Do you need to store various types of data including JavaScript objects?
* Does writing/reading from client-side storage need to be non-blocking?

If the answer to all of the above questions is Yes, IndexedDB is the best option for you. But if such functionality is not required, you might as well choose a storage method such as `localStorage` because it provides widespread browser adoption and features an easy-to-use API.

## Summary

When we consider all the client-side storage mechanisms, IndexedDB is a clear winner. Let’s look at a summarized comparison of different client-side storage methods.

![](https://cdn-images-1.medium.com/max/3544/1*ttpz7RUwKhTJYmfmE5VQ0g.png)

Hope you got a clear understanding of IndexedDB and its benefits. Let us know your thoughts too.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
