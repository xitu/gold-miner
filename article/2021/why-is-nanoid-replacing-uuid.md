> * 原文地址：[Why is NanoID Replacing UUID?](https://blog.bitsrc.io/why-is-nanoid-replacing-uuid-1b5100e62ed2)
> * 原文作者：[Charuka Herath](https://charuka95.medium.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/why-is-nanoid-replacing-uuid.md](https://github.com/xitu/gold-miner/blob/master/article/2021/why-is-nanoid-replacing-uuid.md)
> * 译者：
> * 校对者：

# Why is NanoID Replacing UUID?

![](https://miro.medium.com/max/1400/1*o7-WnAbmlrLnDmfRhl3opQ.jpeg)

[UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) is one of the most used universal identifiers in software development. However, over the past few years, other alternatives challenged its existence.

Out of these, NanoID is one of the leading competitors to take over from UUIDs.

So, in this article, I will discuss the features of NanoID, where it shines, and its limitations to give you a better understanding of when to use it.

---

## Understand NanoID and Its Usage

When it comes to JavaScript, generating either UUID or NanoID is pretty straightforward. They both have NPM packages to help you with it.

All you need to do is install the [NanoID NPM library](https://www.npmjs.com/package/nanoid) using `npm i nanoid` command and use it in your project.

```javascript
import { nanoid } from 'nanoid';  
model.id = nanoid();
```

> Do you know that NanoID has over 11,754K weekly NPM downloads and 60% faster than UUID?

Besides, NanoID is almost 7 years younger than UUID, and it already has more GitHub stars than UUID.

The below graph shows the npm trends comparison between these 2, and we can see an upward trend of NanoID compared to the flat progress of UUID.

![](https://miro.medium.com/max/1400/1*OIOSOm8uIfHAJnbTRJvlIQ.png)

<small>[https://www.npmtrends.com/nanoid-vs-uuid](https://www.npmtrends.com/nanoid-vs-uuid)</small>

I hope these numbers have already convinced you to try out NanoID.

However, the main difference between these two is simple. It boils down to the alphabet used by the key.

Since NanoID uses a larger alphabet than UUID, a shorter ID can serve the same purpose as a longer UUID.

## 1. NanoID is Only 108 bytes in Size

Unlike UUID, NanoID is 4.5 times smaller in size and does not have any dependencies. Furthermore, the size limit has been used to reduce the size from another 35%.

The size reduction directly affects on size of the data. For instance, an object using NanoID is small and compact for data transfer and storage. With the application growth, these numbers become visible.

## 2. More Secure

In most of the random generators, they use unsafe `Math.random()`. But, NanoID uses `[crypto module](https://nodejs.org/api/crypto.html)`and `[Web Crypto API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API)` which is more secure.

Also, NanoID has used its own algorithm called a [uniform algorithm](https://github.com/ai/nanoid/blob/main/index.js) during the implementation of the ID generator instead of using a `random % alphabet`

## 3. It is Fast and Compact

NanoID is 60% faster than the UUID. Instead of having 36 characters in UUID’s alphabet, NanoID only has 21characters.

```text
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ\_abcdefghijklmnopqrstuvwxyz-
```

Also, NanoID support 14 different programming languages, which are,

```text
C#, C++, Clojure and ClojureScript, Crystal, Dart & Flutter, Deno, Go, Elixir, Haskell, Janet, Java, Nim, Perl, PHP, Python with dictionaries, Ruby , Rust, Swift
```

## 4. Compatibility

It also supports PouchDB, CouchDB WebWorkers, Rollup, and libraries like React and Reach-Native.

You can get a unique ID in the terminal by using `npx nanoid.` The only prerequisite is to have NodeJS installed.

![](https://miro.medium.com/max/1352/1*DB4RlTcwQ_2qwHSNY2mp2A.png)

Besides, you can also find NanoID inside the [Redux toolkit](https://redux-toolkit.js.org/api/other-exports) and use it for other use cases as follows;

```javascript
import { nanoid } from ‘@reduxjs/toolkit’  
console.log(nanoid()) //‘dgPXxUz\_6fWIQBD8XmiSy’
```

## 5. Custom Alphabets

Another existing feature of NanoID is that it allows developers to use custom alphabets. You can change the literals or the size of the id as below:

```javascript
import { customAlphabet } from 'nanoid';  
const nanoid = customAlphabet('ABCDEF1234567890', 12);  
model.id = nanoid();
```

In the above example, I have defined a custom Alphabet as `ABCDEF1234567890` and the size of the Id as 12.

## 6. No Third-Party Dependencies

Since NanoID doesn’t depend on any third-party dependencies, over time, it becomes more stable self-governed.

This is beneficial to optimize the bundle size in the long run and make it less prone to the issues that come along with dependencies.

---

## Limitations and Future Focus

Based on many expert opinions in StackOverflow, there are no significant disadvantages or limitations of using NanoID.

Being non-human-readable is the main disadvantage many developers see in the NanoID since it makes debugging harder. But, when compared to UUID, NanoID is way shorter and readable.

Also, if you use NanoID as a table’s primary key, there will be problems if you use the same column as a clustered index. This is because NanoIDs are not sequential.

### In the future…

NanoID is gradually becoming the most popular unique id generator for JavaScript and most developers prefer to choose it over UUID.

![](https://miro.medium.com/max/1400/1*dwhmN-DJNpT2uPtvy2ZGjg.png)
<small>Source: [https://www.npmjs.com/package/nanoid](https://www.npmjs.com/package/nanoid)</small>

The above benchmarks show the performance of NanoID compared to other major id generators.

> It can generate over 2.2 million unique IDs per second with its default alphabet and over 1.8 million unique IDs per second when using the custom alphabet.

With my experience in using both UUID and NanoID, I suggest using NanoID over UUID for any future projects considering its small size, URL friendliness, security, and speed.

So, I invite you to try out NanoID in your next project and share your thought with others in the comment section.

Thank you for Reading !!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
