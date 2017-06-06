> * 原文地址：[A follow-up on how to store tokens securely in Android](https://medium.com/@enriquelopezmanas/a-follow-up-on-how-to-store-tokens-securely-in-android-e84ac5f15f17)
> * 原文作者：[Enrique López Mañas](https://medium.com/@enriquelopezmanas)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

![](https://cdn-images-1.medium.com/max/2000/1*nWjJ7GKUSVEQMC0srKK-9Q.jpeg)

# A follow-up on how to store tokens securely in Android #

As a prologue to this article, I want to remark a short sentence for the notional reader. This quote will be important as we move forward.

> Absolute security does not exist. Security is a set of measures, being piled up and combined, trying to slow down the inevitable.

Almost three years ago, I wrote [a post](http://codetalk.de/?p=86) giving some ideas to protect String tokens from a hypothetical attacker decompiling our Android application. For the sake of remembrance, and in order to ward off the inescapable death of the Internet, I am reproducing some sections here.

One of the most common use cases happens when our application needs to communicate with a web service in order to exchange data. This data exchange can oscillate from a less to a more sensitive nature, and vary between a login request, user data alteration petition, etc.

The absolute first measure to be applied is using a [SSL](http://info.ssl.com/article.aspx?id=10241) (Secure Sockets Layer) connection between the client and the server. Go again to the initial quote. This does not ensure an absolute privacy and security, although it makes a good initial job.

When you are using a SSL connection (like when you see the locker in your browser) it indicates that the connection between you and the server is encrypted. On a theoretical level, nothing can access the information contained within this requests(*)

(*)Did I mention that the absolute security does not exist? SSL connections can still be compromised. This article does not intend to provide an extensive list of all the possible attacks, but I want to let you know of a few possibilities. Fake SSL certificates can be used, as well as Man-in-the-Middle attacks.

Let’s move forward. We are assuming our client is communicating via an encrypted SSL channel with our backend. They are exchanging useful data, making their business, being happy. But we want to provide an additional security layer.

A next logical step used nowadays is to provide an authentication token or API Key to be used in the communication. It works this way. Our backend receives a petition. How do we know the petition comes from one of our verified clients, and not a random dude trying to gain access to our API? The backend will check if the client is providing a valid API Key. If the previous statement happens to be true, then we proceed with the request. Otherwise, we deny it and depending on the nature of our business we take some corrective measures (when this is happening, I particularly like to store the IP and IDs from the client to see how often this occurs. When the frequency is swelling more than it is desirable for my fine taste, I do consider a ban or observing closely what the impolite internet dude is trying to achieve).

Let’s construct our castle from the ground. In our app, we will likely add a variable called API_KEY that gets automatically injected in each request (if you are using Android, probably in your Retrofit client).

```
private final static String API_KEY = “67a5af7f89ah3katf7m20fdj202”
```

This is great, and works if we want to authenticate our client. The problem is that does not provide a very effective layer by itself.

If you use [apktool](https://ibotpeaches.github.io/Apktool/)  to decompile the application and perform a search looking for strings, you will find in one of the resulting .smali files the following:

```
const-string v1, “67a5af7f89ah3katf7m20fdj202”
```

Yeah, sure. It does not say this is a validation Token, so we still need to go through a meticulous verification to decide how to reach this string and whether it can be used for authentication purposes or not. But you know where I am going: this is mostly a matter of time and resources.

Could Proguard help us to secure this String, so we do not have to worry about it? Not really. Proguard states in [its FAQ](http://proguard.sourceforge.net/FAQ.html#encrypt) that String encryption is not totally possible.

What about saving this String in one of the other mechanisms provided by Android, such as the SharedPreferences? This is barely a good idea. SharedPreferences can be easily accessed from the Emulator or any rooted device. Some years ago a guy called [Srinivas](http://resources.infosecinstitute.com/android-hacking-security-part-9-insecure-local-storage-shared-preferences/) proofed how the scored could be altered in a video-game. We are running out of options here!

#### Native Development Kit (NDK) ####

I am going to refresh here the initial model I proposed, and how we can as well iterate through it to provide a more secure alternative. Let’s image two functions that could serve to encrypt and decrypt our data:

```
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

Nothing fancy here. These two functions will take a key value and a string to be encoded or decoded. They will return the encrypted or the decrypted token, respectively. We would call the following function as follows:

```
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

Are you guessing the direction? That is right. We could encrypt and decrypt our token on demand. This provides an additional layer of security: when the code gets obfuscated, it is not anymore as straightforward as performing a String search and check the environment surrounding that String. But can you still figure out a problem that needs to be solved?

Can you?

Give it a couple of seconds more if you have not figured it out yet.

Yes, you are right. We have an encryption key that is being also stored as String. This is adding more layers of security by obscurity, but we still have a token on plain text, regardless of whether this token is used for encryption or is the token per-se.

Let’s going to use now the NDK, and keep iterating our security mechanism.

NDK allows us to access a C++ code base from our Android code. As a first approach, let’s take a minute to think what to do. We could have a native C++ function that stores an API Key or whatever sensitive data we are trying to store. This function could later on be called from the code, and no string will be stored in any Java file. This would provide an automatic protection against decompiling techniques.

Our C++ function would look like follows:

```
Java_com_example_exampleApp_ExampleClass_getSecretKey( JNIEnv* env,
                                                  jobject thiz )
{
    return (*env)->NewStringUTF(env, "mySecretKey".");
}
```

It will be called easily in your Java code:

```
static {
        System.loadLibrary("library-name");
    }

public native String getSecretKey();
```

And the encryption/decryption function will be called as in the next snippet:

```
byte[] keyStart = getSecretKey().getBytes();
```

If we know generate an APK, obfuscate it, decompile it and try to access the string contained in the native function getSecretKey(), we will not be able to find it! Victory?

Not really. The NDK code can actually be disassembled and inspected. This is getting tougher, and you are starting to require more advanced tools and techniques. You got rid of 95% of the script kids, but a team with enough resources and motivation will still be able to access the token. Remember this sentence?

> Absolute security does not exist. Security is a set of measures, being piled up and combined, trying to slow down the inevitable.

![](https://cdn-images-1.medium.com/max/800/1*JPErsmBbKjKbFoQYJAoUkg.png)

You can still access in disassembled code String literals!
[Hex Rays](https://www.hex-rays.com/products/decompiler/), for instance, makes a very good job at decompiling native files. I am sure there are a bunch of tools as well that could deconstruct any native code generated with Android (I am not associated with Hex Rays neither receiving any kind of monetary compensation from them).

So which solution could we use to communicate between a backend and a client without being flagged?

**Generate the key in real time on the device.**

Your device does not need to store any kind of key and deal with all the hassle of protecting a String literal! This is a very old technique used by services such as remote key validation.

1. The client knows a function() that returns a key.
2. The backend knows the function() implemented in the client
3. The client generates a key through the function(), and this gets delivered to the server.
4. The server validates it, and proceeds with the request.

Are you connecting the dots? Instead of having a native function that returns you a string (easily identifiable) why not having a function that returns you the sum of three random prime numbers between 1 and 100? Or a function that takes the current day expressed in unixtime and adds a 1 to each different digit? What about taking some contextual information from the device, such as the amount of memory being used, to provide a higher degree of entropy?

The last paragraph includes a series of ideas, but our hypothetical reader has hopefully taken the main point.

### **Summary** ###

1. Absolute security does not exist.
2. Combining a set of protecting measures is the key to achieving a high degree of security.
3. Do not store String literals in your code.
4. Use the NDK to create a self-generated key.

Remember the first sentence?

> Absolute security does not exist. Security is a set of measures, being piled up and combined, trying to slow down the inevitable.

I want to point once more that your goal is to protect as much as possible your code, without losing perspective that 100% of security is unattainable. But if you are able to protect your code in a way that requires a vast amount of resources to decrypt any sensible information you have, you will be able to sleep well and quiet.

### A small disclaimer ###

I know. You got until here, thinking throughout the entire article “how is this guy not mentioning [Dexguard](https://www.guardsquare.com/en/dexguard) , and going through all the hassle?”. You are right. Dexguard can actually obfuscate Strings, and they do a very good job at it. However, Dexguard pricing [can be prohibitive](http://thinkdiff.net/mobile/dexguard-480-eur-to-10313-eur-the-worst-software-do-not-use/) . I have used Dexguard in previous companies with critical security systems, but this might not be an option for everybody. And, in Software Development as well as in life, the more options you have the richer and more abundant the world gets.

Happy coding!

I write my thoughts about Software Engineering and life in general in my [Twitter account](https://twitter.com/eenriquelopez) . If you have liked this article or it did help you, feel free to share it, ♥ it and/or leave a comment. This is the currency that fuels amateur writers.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
