> * 原文地址：[Trending Storage Options for React Native Developers](https://javascript.plainenglish.io/trending-storage-options-for-react-native-developers-8671fbffb686)
> * 原文作者：[Vithushan Jey](https://medium.com/@vithushjeytharma)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/trending-storage-options-for-react-native-developers.md](https://github.com/xitu/gold-miner/blob/master/article/2021/trending-storage-options-for-react-native-developers.md)
> * 译者：
> * 校对者：

# Trending Storage Options for React Native Developers

#### Detailed View on Different ways to Store Data in React Native Ecosystem

![Cover Picture](https://cdn-images-1.medium.com/max/4480/1*4L_oTx-TV7euxNgR-_8w9A.png)

Data is a key part of any mobile app. It gives meaning to a plain user interface. But storing, retrieving, and maintaining the data is the real hurdle. The use of different ways of storage mechanisms (encrypted store, offline store, service-oriented store, auto-sync store) is essential to store various kinds of data that can uplift the whole process of mobile app development. Because every user interface and functionality of the app need diverse data storage mechanisms to make that app spontaneous. I have listed all the existing ways to store data that are used to leverage app usability.

## Async Storage

AsyncStorage is an **unencrypted, asynchronous, persistent, key-value** storage system that can be accessed globally on the app.

On iOS, AsyncStorage is backed by native code that stores small values in a serialized dictionary and larger values in separate files. On Android, AsyncStorage will use either [RocksDB](http://rocksdb.org/) or SQLite based on availability. AsyncStorage **supports only 6 MB on Android** and a limitless amount of data on iOS. If you are aiming to build a cross-platform app, 6MB is the limit.

The JavaScript code acts as an interface and provides clean promise-based API methods, Error objects, and non-multi functions.

The ideal place to store common data of user, app-logic and others.
[**GitHub - react-native-async-storage/async-storage: An asynchronous, persistent, key-value storage…**
**An asynchronous, unencrypted, persistent, key-value storage system for React Native. Head over to documentation to…**github.com](https://github.com/react-native-async-storage/async-storage)

---

## Secure Storage

Secure storage helps to store **encrypted data**. React Native does not come bundled with any way of storing sensitive data. However, there are pre-existing solutions for Android and iOS platforms.

![Picture from iOS developer [documentation](https://developer.apple.com/documentation/security/keychain_services)](https://cdn-images-1.medium.com/max/2000/1*rQu7_2pJ0VwNqOMe92rbCA.png)

On iOS, [Keychain Services](https://developer.apple.com/documentation/security/keychain_services) allows to securely store small chunks of sensitive info of the app. On Android, [Shared Preference](https://developer.android.com/reference/android/content/SharedPreferences) is the equivalent of a persistent key-value data store used for secure storage. Data in Shared Preferences is not encrypted by default, but [Encrypted Shared Preferences](https://developer.android.com/topic/security/data) wrap the Shared Preferences class for Android, and automatically encrypts keys and values.

But Android has another secure option than Shared Preferences called [Android Keystore](https://developer.android.com/training/articles/keystore) system that is used to store cryptographic keys in a container to make it more difficult to extract from the device. However, a [branch](https://github.com/mCodex/react-native-sensitive-info/tree/keystore) of [react-native-sensitive-info](https://github.com/mCodex/react-native-sensitive-info) uses Android Keystore.

The ideal place to store certificates, tokens, passwords, and any other sensitive information that doesn’t belong in Async Storage.
[**GitHub - oblador/react-native-keychain: Keychain Access for React Native**
**Keychain/Keystore Access for React Native Installation API setGenericPassword(username, password, [{ accessControl…**github.com](https://github.com/oblador/react-native-keychain)
[**GitHub - mCodex/react-native-sensitive-info: Save sensitive data into Android's Shared Preferences…**
**react-native-sensitive-info manages all data stored in Android Shared Preferences, iOS Keychain and Windows…**github.com](https://github.com/mCodex/react-native-sensitive-info)
[**GitHub - emeraldsanto/react-native-encrypted-storage: React Native wrapper around…**
**React Native wrapper around SharedPreferences and Keychain to provide a secure alternative to Async Storage. Async…**github.com](https://github.com/emeraldsanto/react-native-encrypted-storage)
[**SecureStore - Expo Documentation**
**expo-secure-store provides a way to encrypt and securely store key-value pairs locally on the device. Each Expo project…**docs.expo.io](https://docs.expo.io/versions/latest/sdk/securestore/)

---

## MMKV Storage

[MMKV](https://github.com/Tencent/MMKV) is an **efficient, small mobile key-value** storage framework that was developed by Tencent to use in WeChat.

MMKV uses mmap to keep memory synced with files, and **protobuf** to encode/decode values, making the most of Android to achieve the best efficiency performance. It supports concurrent read-read and read-write access between processes which allows multi-process concurrency**.** It is easy to keep up the data because of fully synchronous calls.

The ideal place to store common data of users, app-logic, and others. It is an **alternative for Async Storage**.
[**GitHub - ammarahm-ed/react-native-mmkv-storage: An ultra fast (0.0002s read/write), small &…**
**An ultra fast (0.0002s read/write), small & encrypted mobile key-value storage framework for React Native written in…**github.com](https://github.com/ammarahm-ed/react-native-mmkv-storage)
[**GitHub - mrousavy/react-native-mmkv: ⚡️ An extremely fast key/value storage library for React…**
**MMKV is an efficient, small mobile key-value storage framework developed by WeChat. See Tencent/MMKV for more…**github.com](https://github.com/mrousavy/react-native-mmkv)

---

## SQLite Storage

SQLite is a C-language library that implements a **small, fast, self-contained, high-reliability, full-featured, SQL database engine**. It is the most used database engine. It is **built into all mobile phones** and most computers and comes bundled inside countless other apps that people use every day. The file format is stable, cross-platform, and backward compatible and the developers pledge to keep it that way.

The ideal place to store more data than Async, Secure, and MMKV storage and it can support offline app development.
[**GitHub - Nozbe/WatermelonDB: 🍉 Reactive & asynchronous database for powerful React and React…**
**A reactive database framework Build powerful React and React Native apps that scale from hundreds to tens of thousands…**github.com](https://github.com/Nozbe/WatermelonDB)
[**GitHub - andpor/react-native-sqlite-storage: Full featured SQLite3 Native Plugin for React Native…**
**Full featured SQLite3 Native Plugin for React Native (Android and iOS) - GitHub - andpor/react-native-sqlite-storage…**github.com](https://github.com/andpor/react-native-sqlite-storage)
[**GitHub - craftzdog/react-native-sqlite-2: SQLite3 Native Plugin for React Native for iOS, Android…**
**SQLite3 Native Plugin for React Native for Android, iOS, Windows and macOS. This plugin provides a WebSQL-compatible…**github.com](https://github.com/craftzdog/react-native-sqlite-2)
[**GitHub - ospfranco/react-native-quick-sqlite: ⚡️ The fastest SQLite implementation for…**
**Quick SQLite uses JSI, removes all the overhead of intercommunication between JavaScript code and C++ code, making…**github.com](https://github.com/ospfranco/react-native-quick-sqlite)
[**SQLite - Expo Documentation**
**expo-sqlite gives your app access to a database that can be queried through a WebSQL-like API. The database is…**docs.expo.dev](https://docs.expo.dev/versions/v42.0.0/sdk/sqlite/)

---

## Database Services

There are different types of database services available to perform various functionalities of the data layer of the mobile apps by following different approaches. Those are listed here.

1. Firebase Firestore
2. Firebase Database
3. Firebase Storage
4. Realm by Mongo DB
5. Pouch DB

#### Firebase Firestore

Cloud Firestore is a **NoSQL document database** that lets you easily **store, sync, and query data** for the mobile and web apps at Google scale. Can easily structure the data with collections and documents and use the hierarchies to store and retrieve the data easily using expressive queries.
[**react-native-firebase/packages/firestore at master · invertase/react-native-firebase**
**Cloud Firestore is a NoSQL document database that lets you easily store, sync, and query data for your mobile and web…**github.com](https://github.com/invertase/react-native-firebase/tree/master/packages/firestore)

---

#### Firebase Database

The Firebase Realtime Database is cloud-hosted. Data is **stored as JSON and synchronized in real-time** to every connected client. When you build cross-platform apps with our React Native SDK, all of the clients share one Realtime Database instance and automatically receive updates with the newest data.
[**react-native-firebase/packages/database at master · invertase/react-native-firebase**
**The Firebase Realtime Database is a cloud-hosted database. Data is stored as JSON and synchronized in realtime to every…**github.com](https://github.com/invertase/react-native-firebase/tree/master/packages/database)

---

#### Firebase Storage

Cloud Storage for Firebase is the ideal place to **store images, audio, video, or other user-generated content in the cloud**. It is a powerful, simple, and cost-effective object storage service built for Google scale. The Firebase SDKs for Cloud Storage add Google security to file uploads and downloads for the apps, regardless of network quality.
[**react-native-firebase/packages/storage at master · invertase/react-native-firebase**
**Cloud Storage for Firebase is a powerful, simple, and cost-effective object storage service built for Google scale. The…**github.com](https://github.com/invertase/react-native-firebase/tree/master/packages/storage)

---

#### Realm by Mongo DB

Realm is a mobile database that **runs directly inside phones**, tablets, or wearables. Data is directly exposed as objects and queryable via code, removing the need for ORM. It supports relationships, generics, and vectorization. It is comparatively **faster than raw SQLite** and an **alternative to SQLite & key-value stores**. Realm’s local database persists data on-disk, so apps **work offline** too.
[**GitHub - realm/realm-js: Realm is a mobile database: an alternative to SQLite & key-value stores**
**Realm is a mobile database: an alternative to SQLite & key-value stores - GitHub - realm/realm-js: Realm is a mobile…**github.com](https://github.com/realm/realm-js)

---

#### Pouch DB

PouchDB is a pocket-sized database that enables apps to store data locally **while offline, then synchronize it with CouchDB** and compatible servers when the app is back online, keeping the user’s data in sync no matter where they next log in. Actually, PouchDB was designed for the web only. But now developer communities have created third-party libraries to support it on React Native too.
[**GitHub - seigel/pouchdb-react-native: Pouchdb with async storage**
**PouchDB, the React Native-only edition. A preset representing the PouchDB code that runs in React Native. The…**github.com](https://github.com/seigel/pouchdb-react-native)
[**GitHub - craftzdog/pouchdb-react-native: - PouchDB is a pocket-sized database, with some patches…**
**koala: - PouchDB is a pocket-sized database, with some patches for running on React Native - GitHub …**github.com](https://github.com/craftzdog/pouchdb-react-native)

---

## Conclusion

Try out these data storage libraries to enhance the data storing and retrieving functionality in the React Native app. I am sure these exciting storage options will be useful to carry out different data-oriented tasks to create a full-fledged mobile app.

Thank you for reading the article.

**Check this out**👇
[**5 Useful User Interface Libraries for React Native Developers**
**The unique UI libraries to leverage the user experience**javascript.plainenglish.io](https://javascript.plainenglish.io/5-useful-user-interface-libraries-for-react-native-developers-d74e99f67da1)

**More content at[** plainenglish.io**](http://plainenglish.io/)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
