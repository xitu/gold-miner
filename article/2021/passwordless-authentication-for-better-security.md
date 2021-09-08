> * 原文地址：[Passwordless Authentication for Better Security](https://blog.bitsrc.io/passwordless-authentication-for-better-security-ba986df663b7)
> * 原文作者：[Pavindu Lakshan](https://medium.com/@pavindulakshan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/passwordless-authentication-for-better-security.md](https://github.com/xitu/gold-miner/blob/master/article/2021/passwordless-authentication-for-better-security.md)
> * 译者：
> * 校对者：

# Passwordless Authentication for Better Security

![](https://cdn-images-1.medium.com/max/5760/1*fFag6UPoX_EoUotZnZj9uQ.jpeg)

Passwords are one of the most used authentication mechanisms in web applications. But, using them in practice comes with security risks and complexities.

So, in this article, I will discuss SRP, a Passwordless authentication mechanism to help you address some of the major security challenges in password authentication.

## What is SRP?

The [Secure Remote Password (SRP) protocol](http://srp.stanford.edu/index.html) is an augmented password-authenticated key exchange protocol.

> It is a zero-knowledge-proof authentication protocol, which means both the server and the client don’t need to transmit or store password-related information. But still, they can securely verify the identity of each other.

SRP eases off the complexities of traditional authentication since you don’t need to worry about securing password-related information within the server or in between client-server communication.

So, let’s see how SRP works and address some of the core security challenges related to passwords.

## How SRP works

Let’s see how SRP achieves the goal of passwordless authentication. I have described the protocol in three steps for comprehension. For a more in-depth understanding, please refer to the [official documentation](http://srp.stanford.edu/design.html).

### Step 1: Registration

When the user registers with the username and password, a salt (random string) is generated. This salt is used alongside the user credentials to generate a secret key.

Then a verifier is generated using the secret key and a specified SRP group. Finally, the verifier, salt, and the [SRP group](https://datatracker.ietf.org/doc/html/rfc5054#page-16) are sent to the server instead of the actual username and password.

> So, in a nutshell, no confidential information is sent to the Server. So, no man in the middle can use the verifier salt and SRP group to cause harm.

```js
salt = client.generateRandomSalt() 
secret_key = client.KDF(username, password, salt) 
verifier = client.genVerifier(secret_key,SRP_group)
client.send_to_server(verifier, salt, SRP_group)
```

![The registration process in the SRP protocol - graphic by author](https://cdn-images-1.medium.com/max/2048/1*3c_w9py-f7jhDEVniLKHLQ.png)

### Step 2: Authentication

When it’s time for authentication, the client requests the server to get the salt and the SRP group for the given username. Using that information, the client calculates a secret key and a public key. The public key is sent to the server, keeping the private key on the client-side.

```js
salt, SRP_group = client.getData(username) 
c_secret_key = client.KDF(username, password, salt) 
c_public_key, c_private_key = client.generateKeyPair(SRP_group)
client.sendToServer(c_public_key)
```

The server also will calculate a key pair using the SRP group and send the public key back to the client.

```js
s_public_key, s_private_key = server.generateKeyPair(SRP_group)
server.sendToClient(s_public_key)
```

After all, the client and the server will have the following information.

```
client-side: c_secret_key, c_private_key, s_public_key
server-side: verifier, s_private_key, c_public_key
```

![The authentication process in the SRP protocol - graphic by author](https://cdn-images-1.medium.com/max/2048/1*wp92woniVZBYPsNFI6yMdw.png)

> Again, no confidential information is sent via wire between the client and server.

### Step 3: Verification

Using the information gained during the authentication, the client and the server independently calculate a similar key, called the session encryption key. This is used in the subsequent requests to exchange information between the client and the server.

```js
// client side
session_key = client.genSessionKey(c_secret_key, c_private_key, s_public_key)

// server side
session_key = server.genSessionKey(verifier, s_private_key, c_public_key)
```

> These are called Verifier-based key exchange protocol based on Diffie-Hellman.

The client encrypts the message using the **session encryption key** and sends it to the server. Then the server decrypts the message and verifies it. If the verification fails, the client’s request is denied. Otherwise, the server encrypts a message using its **session encryption key** and sends it back to the client to decrypt it and verify it.

I think now you understand how SRP works, and let’s see how we can implement it in practice.

## Using SRP in Practice

> **Note:** Since SRP involves complex cryptography operations, it is encouraged to use existing tried-and-true implementation instead of programming from scratch. There are already [many implementations done in different languages](https://en.wikipedia.org/wiki/Secure_Remote_Password_protocol#Implementations) to use one of them in your projects.

For this example, I will be using the [thinbus-srp-npm-starter](https://github.com/simbo1905/thinbus-srp-npm-tester) project, which uses `thinbus-srp-js`, a standard JavaScript SRP implementation.

First, you need to clone the project, install the NPM dependencies and run the project locally.

```bash
git clone https://github.com/simbo1905/thinbus-srp-npm-tester.git
cd thinbus-srp-npm-tester
npm install
npm start
```

Then, try registering at [http://localhost:8080/register](http://localhost:8080/register) with a username and a password. If we look at the registration network request at this point, it will look like this.

![registration network request - screenshot by the author](https://cdn-images-1.medium.com/max/2034/1*XEWIcLgoW7cI2sVEzTflIg.png)

When logging in at [http://localhost:8080/login](http://localhost:8080/login), the client will first request the user’s salt and the SRP group from the server via `/challenge` request.

![](https://cdn-images-1.medium.com/max/2000/1*ajRkQhiayDNFMp1pN74vaA.png)

Using that information, the client computes its public key and encrypted message. Then, the client calls the `/authenticate` endpoint with the calculated data and the username.

![/authenticate network request - screenshot by the author](https://cdn-images-1.medium.com/max/2190/1*tHtw0uoqUS2q4BeZwPxItw.png)

* A - Public (ephemeral) key that is generated on the client-side
* M1 - Message that is encrypted on the client-side with the generated session encryption key.

The server will send a message back (M2), encrypted with the same session encryption key, responding to the client’s request. Then the client decrypts and verifies it using the client’s private key.

In the end, the client and server have confirmed each other’s authenticity and continue to share information between them.

![encrypted message from the server - screenshot by the author](https://cdn-images-1.medium.com/max/2000/1*QBhZ1ov9TtiGEA-Z9bu5bQ.png)

## Final Thoughts

Passwords are the most commonly used authentication mechanism used on web applications. However, it's not easy to implement a flawless password authentication mechanism. Despite all the secure transmission and storing techniques, attackers can still access the passwords with enough patience and resources.

SRP protocol provides a solution for this by introducing a method to authenticate without transmitting or storing any form of password-related information.

So, I invite you to try SRP in your next project and experience the difference it makes. Also, don’t forget to share your experience in the comments section as well.

Thank you for reading !!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
