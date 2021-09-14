> * 原文地址：[Trending Storage Options for React Native Developers](https://javascript.plainenglish.io/trending-storage-options-for-react-native-developers-8671fbffb686)
> * 原文作者：[Vithushan Jey](https://medium.com/@vithushjeytharma)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/trending-storage-options-for-react-native-developers.md](https://github.com/xitu/gold-miner/blob/master/article/2021/trending-storage-options-for-react-native-developers.md)
> - 译者：[KimYangOfCat](https://github.com/KimYangOfCat)
> - 校对者：[jaredliw](https://github.com/jaredliw)、[greycodee](https://github.com/greycodee)

# React Native 开发者的流行存储方案

![封面](https://cdn-images-1.medium.com/max/4480/1*4L_oTx-TV7euxNgR-_8w9A.png)

数据是任何移动应用程序的关键部分。它让简单的用户界面变得有意义。但是存储、检索和维护数据才是真正的难题。使用不同方式的存储机制（加密存储、离线存储、面向服务的存储、自动同步存储）对于存储各种数据至关重要，并且可以加速移动应用程序开发全过程。因为应用程序的每个用户界面和功能都需要不同的数据存储机制来使该应用程序更自然。我列出了所有现有的可用于提升应用程序可用性的数据存储方法。

## 异步存储

AsyncStorage 是一个**未加密的、异步的、持久的键值**存储系统，可以在应用程序上全局访问。

在 iOS 上，由原生代码实现的 AsyncStorage 将小值存储在序列化字典中，并将较大值存储在单独的文件中。在安卓上，AsyncStorage 将根据可用性使用 [RocksDB](http://rocksdb.org/) 或 SQLite。 AsyncStorage **在安卓上仅支持 6 MB**，在 iOS 上支持无限量的数据。如果你的目标是构建跨平台应用程序，6MB 是极限。

JavaScript 代码充当接口并提供清楚的基于 promise 的 API 方法、错误对象和 non-multi 功能函数。

此方案适合存储用户、应用程序逻辑和其他人的公共数据。

[**GitHub - react-native-async-storage/async-storage: 一个用于 React Native 的异步的、持久的、键值存储系统。**](https://github.com/react-native-async-storage/async-storage)

## 安全存储

安全存储有助于存储**加密数据**。React Native 没有附带任何存储敏感数据的方式。然而，在安卓和 iOS 平台中这个问题已有解决方案。

![图片来自 iOS 开发者文档](https://cdn-images-1.medium.com/max/2000/1*rQu7_2pJ0VwNqOMe92rbCA.png)

在 iOS 上， [钥匙串服务](https://developer.apple.com/documentation/security/keychain_services)允许安全地存储应用程序的小块敏感信息。在安卓上， [Shared Preference](https://developer.android.com/reference/android/content/SharedPreferences) 相当于持久键值数据存储，可被用于安全存储。Shared Preference 中的数据默认不加密，但 [Encrypted Shared Preferences](https://developer.android.com/topic/security/data) 包装了安卓的 Shared Preferences 类，并自动加密键和值。

除了 Shared Preferences，安卓有另一个可用于安全存储的名为[安卓密钥库](https://developer.android.com/training/articles/keystore)的系统，用于将加密密钥存储在容器中，使其更难以从设备中提取。并且， [react-native-sensitive-info](https://github.com/mCodex/react-native-sensitive-info) 的[一个分支](https://github.com/mCodex/react-native-sensitive-info/tree/keystore)使用的就是安卓密钥库。

此方案适合存储证书、令牌、密码和任何其他不适合异步存储的敏感信息。

[**GitHub - oblador/react-native-keychain: React Native 的钥匙串存取**](https://github.com/oblador/react-native-keychain)

[**GitHub - mCodex/react-native-sensitive-info: React Native 用钥匙库加密将敏感数据保存到安卓的 Shared Preferences / iOS 的钥匙串中**](https://github.com/mCodex/react-native-sensitive-info)

[**GitHub - emeraldsanto/react-native-encrypted-storage: 围绕 EncryptedSharedPreferences 和钥匙串的 React Native 包装器，为 Async Storage 提供安全的替代方案。**](https://github.com/emeraldsanto/react-native-encrypted-storage)

[**SecureStore - Expo 文献**](https://docs.expo.io/versions/latest/sdk/securestore/)

## MMKV 存储

[MMKV](https://github.com/Tencent/MMKV) 是腾讯开发用在微信上的一个**高效、小型的移动键值**存储框架

MMKV 使用 mmap 保持内存与文件同步，使用 **protobuf** 编码/解码值，充分利用安卓实现最佳效率性能。它支持进程间的并发读写访问，允许多进程并发。由于完全同步调用，很容易保持数据。

此方案适合存储常见的用户数据、应用程序逻辑等等。它可以替代**异步存储**。

[**GitHub - ammarahm-ed/react-native-mmkv-storage: 可用于 React Native 的一个超快（0.0002s 读/写）、小型、加密的移动键值存储框架，其使用了 JSI 并由 C++ 编写。**](https://github.com/ammarahm-ed/react-native-mmkv-storage)

[**GitHub - mrousavy/react-native-mmkv: ⚡️ 一个用于 React Native 的极快的键/值存储库。比 AsyncStorage 快大约 30 倍!**](https://github.com/mrousavy/react-native-mmkv)

## SQLite 存储

SQLite 是一个 C 语言库，它实现了一个**小型、快速、自包含、高可靠性、功能齐全的 SQL 数据库引擎**。它是最常用的数据库引擎。它**内置于所有手机**和大多数计算机中，并打包于人们每天使用的无数其他应用程序中。开发人员承诺其文件格式将保持稳定、跨平台且向后兼容。

此方案适合存储比异步、安全和 MMKV 存储更多的数据，支持离线应用程序开发。

[**GitHub - Nozbe/WatermelonDB: 🍉 为强大的 React 和 React Native 应用提供反应式异步数据库 ⚡️**](https://github.com/Nozbe/WatermelonDB)

[**GitHub - andpor/react-native-sqlite-storage: 用于 React Native 的全功能 SQLite3 Native 插件（安卓和 iOS）。**](https://github.com/andpor/react-native-sqlite-storage)

[**GitHub - craftzdog/react-native-sqlite-2：适用于 iOS、安卓、Windows 和 macOS 的 React Native 的 SQLite3 Native 插件。**](https://github.com/craftzdog/react-native-sqlite-2)

[**GitHub - ospfranco/react-native-quick-sqlite：⚡️ 为 React Native 提供最快的 SQLite 实现。**](https://github.com/ospfranco/react-native-quick-sqlite)

[**SQLite - Expo 文献**](https://docs.expo.dev/versions/v42.0.0/sdk/sqlite/)

## 数据库服务

在移动应用程序中，我们可以使用不同的方法、不同类型的数据库服务来执行数据层的各种功能。数据库列出如下：

1. Firebase Firestore
2. Firebase Database
3. Firebase Storage
4. Realm by MongoDB
5. PouchDB

### Firebase Firestore

Cloud Firestore 是一个 **NoSQL 文档数据库**，可让你轻松**存储、同步和查询** Google 规模级的移动和 web 应用的数据。可以使用集合和文档轻松结构化数据，并使用层次结构存储数据以及轻松使用表达式查询来检索数据。

[**GitHub - react-native-firebase: 一个 NoSQL 文档数据库，让你轻松为你的移动和 web 应用存储、同步和查询数据。**](https://github.com/invertase/react-native-firebase/tree/master/packages/firestore)

### Firebase Database

Firebase 实时数据库是由云托管的。数据**以 JSON 格式存储并实时同步**到每个连接的客户端。当你使用我们的 React Native SDK 构建跨平台应用程序时，所有客户端共享一个实时数据库实例并自动接收最新数据的更新。

[**GitHub - react-native-firebase：一个实时的云托管数据库**](https://github.com/invertase/react-native-firebase/tree/master/packages/database)

### Firebase Storage

Firebase 的 Cloud Storage 是在云中存储**图像、音频、视频或其他用户生成内容**的理想场所。它是一种功能强大、简单且经济高效的对象存储服务，专为 Google 规模打造。 无论网络质量如何，Cloud Storage 的 Firebase SDK 为应用的文件上传和下载添加了 Google 级安全防护。

[**GitHub - react-native-firebase: 一个强大、简单、经济的对象存储服务，专为 Google 规模打造**](https://github.com/invertase/react-native-firebase/tree/master/packages/storage)

### Realm by MongoDB

Realm 是一个**直接在手机**、平板电脑或可穿戴设备中运行的移动数据库。数据直接作为对象暴露并可通过代码查询，从而无需 ORM。它支持关系、泛型和向量化。它**比原始 SQLite 更快，**可以替代**键值方式存储的 SQLite **。Realm 的本地数据库将数据保存在磁盘上，因此应用程序也可以 **离线工作**。

[**GitHub - realm/realm-js: Realm is a mobile database：Realm 是一个移动数据库：可以替代键值方式存储的 SQLite**](https://github.com/realm/realm-js)

### PouchDB

PouchDB 是一个袖珍型数据库，使应用程序可以**在离线时**将数据存储在本地，然后在应用程序重新上线时将其与 CouchDB 和兼容的服务器同步，无论用户下次在何处登录，用户的数据都可以保持同步。。 实际上，PouchDB 是专门为网络而设计的。而且现在开发者社区已经创建了第三方库来支持 React Native。

[**GitHub - seigel/pouchdb-react-native:  支持异步存储的 PouchDB**](https://github.com/seigel/pouchdb-react-native)

[**GitHub - craftzdog/pouchdb-react-native: 🐨 - PouchDB 是一个袖珍的数据库，包含一些支持在 React Native 上运行的补丁。**](https://github.com/craftzdog/pouchdb-react-native)

## 总结

试试数据存储方案来增强 React Native 应用程序中的数据存储和检索功能。我相信这些令人兴奋的存储方案对于执行不同面向数据的任务以及创建全面的移动应用程序都非常有用。

感谢你阅读这篇文章。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
