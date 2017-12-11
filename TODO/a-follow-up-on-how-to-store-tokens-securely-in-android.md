> * 原文地址：[A follow-up on how to store tokens securely in Android](https://medium.com/@enriquelopezmanas/a-follow-up-on-how-to-store-tokens-securely-in-android-e84ac5f15f17)
> * 原文作者：[Enrique López Mañas](https://medium.com/@enriquelopezmanas)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [lovexiaov](https://github.com/lovexiaov)
> * 校对者：[luoqiuyu](https://github.com/luoqiuyu) [hackerkevin](https://github.com/hackerkevin)

![](https://cdn-images-1.medium.com/max/2000/1*nWjJ7GKUSVEQMC0srKK-9Q.jpeg)

# 再谈如何安全地在 Android 中存储令牌 #

作为本文的序言，我想对读者做一个简短的声明。下面的引言对本文的后续内容而言十分重要。

> 没有绝对的安全。所谓的安全是指利用一系列措施的堆积和组合，来试图延缓必然发生的事情。

大约 3 年前，我写了[一篇文章](http://codetalk.de/?p=86)，给出了几种方法来防止潜在攻击者反编译我们 Android 应用窃取字符串令牌。为了便于回忆，也为了防止不可避免的网络瘫痪，我将会在此重新列出一些章节。

客户端应用与服务端的交互是最常见的场景之一。数据交换时的敏感度差别很大，并且登录请求、用户数据更改请求等之间交换的数据类型也变化多样。

首先要提到并应用的技术是使用 [SSL](http://info.ssl.com/article.aspx?id=10241)（安全套接层）链接客户端与服务端。再看一下文章开头的引言。尽管这样做是一个良好的开端，但这并不能确保绝对的隐私和安全。

当你使用 SSL 连接时（也就是当你看到浏览器上有一个小锁时），这意味着你与服务器之间的连接被加密了。理论上讲，没有什么能够访问到你请求里的信息（*）

（*）我说过绝对的安全不存在吧？SSL 连接仍然可以被攻破。本文不打算提供所有可能的攻击手段列表，只想让你了解几种攻击的可能性。比如，可以伪造 SSL 证书，或者进行中间人攻击。

我们继续。假设客户端正在通过加密的 SSL 通道与后台链接，它们在愉快的交换有用的数据，执行业务逻辑。但是我们还想提供一个额外的安全层。

接下来要采取的措施是在通信中使用授权令牌或 API 密钥。当后台收到一个请求时，我们如何判断该请求是来自认证的客户端而不是任意一个想要获取我们 API 数据的家伙？后台会检查该客户端是否提供了一个有效的 API 密钥。如果密钥有效，则执行请求操作，否则拒绝该请求并根据业务需求采取一些措施（当出现此情况时，我一般会纪录他们的 IP 地址和客户端 ID，看一下他们的访问频率。如果频率高于我的忍受范围，我会考虑禁止并观察一下这个无礼的家伙想要得到什么）。

让我们从头开始构建我们的城堡吧。在我们的应用中，添加一个叫做 API_KEY 的变量，该变量会自动注入到每次的请求（如果是 Android 应用，可能会是你的 Retrofit 客户端）中。

```java
private final static String API_KEY = “67a5af7f89ah3katf7m20fdj202”
```

很好，这样可以帮助我们鉴定客户端。但问题在于它本身并没有提供一个十分有效的安全保证。

如果你使用 [apktool](https://ibotpeaches.github.io/Apktool/) 反编译该应用，然后搜索该字符串，你会在其中一个 .smali 文件中发现：

```smali
const-string v1, “67a5af7f89ah3katf7m20fdj202”
```

是的，我知道。这并不能保证是一个有效的令牌，所以我们仍然需要通过一个精确的验证来决定如何找到那个字符串，和它是否可以用来通过验证。但是你知道我要表达什么：这通常只是时间和资源的问题。

Proguard 是否会能我们保证该字符串的安全呢？并不能。Proguard 在[常见问题](http://proguard.sourceforge.net/FAQ.html#encrypt)中提到了字符串的加密是完全不可能的。

那将字符串保存到 Android 提供的其他存储机制中呢，比如说 SharedPreferences？这并不是一个好方法。在模拟器或者 root 过的设备中可以轻易的访问到 SharedPreferences。几年前，一个叫 [Srinivas](http://resources.infosecinstitute.com/android-hacking-security-part-9-insecure-local-storage-shared-preferences/) 的伙计向我们证明了如何更改一个视频游戏中的得分。跑题了！

#### 原生开发工具包 (NDK) ####

我将会更新我提出的初始模型，不断迭代它，以提供更安全的替代方案。我们假设有两个函数分别负责加密和解密数据：

```java
 private static byte[] encrypt(byte[] raw, byte[] clear) throws Exception {
        SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
        byte[] encrypted = cipher.doFinal(clear);
        return encrypted;
    }

    private static byte[] decrypt(byte[] raw, byte[] encrypted) throws Exception {
        SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, skeySpec);
        byte[] decrypted = cipher.doFinal(encrypted);
        return decrypted;
    }
```

代码没啥好说的。这两个函数会使用一个密钥值和一个被用来编/解码的字符串作为入参。它们会返回相应的加密或解密过的字符串。我们会用如下方式调用它们：

```java
ByteArrayOutputStream baos = new ByteArrayOutputStream();
bm.compress(Bitmap.CompressFormat.PNG, 100, baos);
byte[] b = baos.toByteArray();

byte[] keyStart = "encryption key".getBytes();
KeyGenerator kgen = KeyGenerator.getInstance("AES");
SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
sr.setSeed(keyStart);
kgen.init(128, sr);
SecretKey skey = kgen.generateKey();
byte[] key = skey.getEncoded();

// encrypt
byte[] encryptedData = encrypt(key,b);
// decrypt
byte[] decryptedData = decrypt(key,encryptedData);
```

猜到为什么要这么做了吗？是的，我们可以根据需求来加/解密令牌。这就为我们提供了一个额外的安全层：当代码混淆后，寻找令牌不再像执行字符串搜索和检查字符串周围的环境那样简单了。但是，你能指出还有一个需要解决的问题吗？

找到了吗？

如果还没找到就多花点时间。

是的。我们仍然有一个加密密钥以字符串的形式存储。虽然这种隐晦的做法增加了更多的安全层，但不管这个令牌是用于加密或它本身就是一个令牌，我们仍然有一个以明文形式存在的令牌。

现在，我们将使用 NDK 来继续迭代我们的安全机制。

NDK 允许我们在 Android 代码中访问 C++ 代码库。首先我们来想一下要做什么。我们可以在一个 C++ 函数中存放 API 密钥或者敏感数据。该函数可以在之后的代码中调用，避免了在 Java 文件中存储字符串。这就提供了一个自动的保护机制来防止反编译技术。

C++ 函数如下：

```cpp
Java_com_example_exampleApp_ExampleClass_getSecretKey( JNIEnv* env,
                                                  jobject thiz )
{
    return (*env)->NewStringUTF(env, "mySecretKey".");
}
```

在 Java 代码中调用它也很简单：

```java
static {
        System.loadLibrary("library-name");
    }

public native String getSecretKey();
```

在加/解密函数中会这样调用：

```java
byte[] keyStart = getSecretKey().getBytes();
```

此时我们生成 APK，混淆它，然后反编译并尝试在原生函数 getSecretKey() 中查找该字符串，无法找到！胜利了吗？

并没有！NDK 代码其实也可以被反汇编和检查。只是难度较高，需要更高级的工具和技术。虽然这样可以摆脱掉 95% 的脚本小子，但一个有充足资源和动机的团队让然可以拿到令牌。还记得这句话吗？

> 没有绝对的安全。所谓的安全是指利用一系列措施的堆积和组合，来试图延缓必然发生的事情。

![](https://cdn-images-1.medium.com/max/800/1*JPErsmBbKjKbFoQYJAoUkg.png)

你仍然可以在反汇编代码中找到该字符串字面值。[Hex Rays](https://www.hex-rays.com/products/decompiler/) 在反编译原生文件方面就做的很好。我很确信有一大堆的工具可以解构 Android 生成的任意原生代码（我跟 Hex Rays 并没有关系，也没有从他们那里拿到任何形式的资金酬劳）。

那么，我们要使用哪种方案来避免后台与客户端的通信被标记呢？

**在设备上实时生成密钥。**

你的设备不需要存储任何形式的密钥并处理各种保护字符串字面值的麻烦！这是在服务中用到的非常古老的技术，比如远程密钥验证。

1. 客户端知道有个函数会返回一个密钥。
2. 后台知道在客户端中实现的那个函数。
3. 客户端通过该函数生成一个密钥，并发送到服务器上。
4. 服务器验证密钥，并根据请求执行相应的操作。

抓到重点了吗？为什么不使用返回三个随机素数（ 1～100 之间）之和的函数来代替返回一个字符串（很容易被识别）的原生函数呢？或者拿到当天的 UNIX 时间，然后给每一位数字加 1？通过设备的一些上下文相关信息(如正在使用的内存量)来提供一个更高程度的熵值？

上面这段包含了一些想法，希望读者们已经得到重点了。

### **总结** ###

1. 绝对的安全是不存在的。
2. 多种保护手段的结合是达到高安全度的关键。
3. 不要在代码中存储字符串明文。
4. 使用 NDK 来创建自生成的密钥。

还记得开头的那段话吧？

> 没有绝对的安全。所谓的安全是指利用一系列措施的堆积和组合，来试图延缓必然发生的事情。

我想再强调一次，你的目标是尽可能的保护你的代码，同时不要忘记 100% 的安全是不可能的。但是，如果你能保证解密你代码中任意的敏感信息都需要耗费大量的资源，你就能安心睡觉啦。

### 一个小小的免责声明 ###

我知道，读到此处，纵观整文，你会纳闷“这家伙怎么讲了所有麻烦的方法而没有提到 [Dexguard](https://www.guardsquare.com/en/dexguard) 呢？”。是的 Dexguard 可以混淆字符串，他们在这方面做的很好。然而 Dexguard 的售价[让人望而却步](http://thinkdiff.net/mobile/dexguard-480-eur-to-10313-eur-the-worst-software-do-not-use/)。我在之前的公司的关键安全系统中使用过 Dexguard，但这也许并不是一个适合所有人的选择。再说了，像生活一样，在软件开发中选择越多世界越丰富多彩。

愉快的编码吧！

我会在 [Twitter](https://twitter.com/eenriquelopez) 上写一些关于软件工程和生活点滴的思考。如果你喜欢此文，或者它能帮到你，请随意分享，点赞或者留言。这是业余作者写作的动力。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
