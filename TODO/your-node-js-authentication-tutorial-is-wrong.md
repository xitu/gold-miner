
  > * 原文地址：[Your Node.js authentication tutorial is (probably) wrong](https://medium.com/@micaksica/your-node-js-authentication-tutorial-is-wrong-f1a3bf831a46)
  > * 原文作者：[micaksica](https://medium.com/@micaksica)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/your-node-js-authentication-tutorial-is-wrong.md](https://github.com/xitu/gold-miner/blob/master/TODO/your-node-js-authentication-tutorial-is-wrong.md)
  > * 译者：
  > * 校对者：

  # Your Node.js authentication tutorial is (probably) wrong

  **tl;dr: **I went on a search of Node.js/Express.js authentication tutorials. All of them were incomplete or made a security mistake in some way that can potentially hurt new users. This post explores some common authentication pitfalls, how to avoid them, and what to do to help yourself when your tutorials don’t help you anymore. I am still searching for a robust, all-in-one solution for authentication in Node/Express that rivals Rails’s [Devise](https://github.com/plataformatec/devise).

> **Update (Aug 7)**: RisingStack has reached out and [no longer stores passwords in plaintext](https://github.com/RisingStack/nodehero-authentication/commit/9d69ea70b68c4971466c64382e5f038e3eda8d8a) in their tutorial, opting to move to bcrypt in their example codes and tutorials.
> **Update (Aug 8):** Editing title to *Your Node.js authentication tutorial is (probably) wrong*, as this post has improved some of these tutorials.

On my spare time, I’ve been digging through various Node.js tutorials, as it seems that every Node.js developer with a blog has released their own tutorial on how to do things *the right way*, or, more accurately, *the way they do them*. Thousands of front-end developers being thrown into the server-side JS maelstrom are trying to piece together actionable knowledge from these tutorials, either by cargo-cult-copypasta or gratuitous use of *npm install *as they scramble frantically to meet the deadlines set for them by outsourcing managers or ad agency creative directors.

One of the more questionable things in Node.js development is that authentication is largely left as an exercise to the individual developer*. *The *de facto *authentication solution in the Express.js world is [Passport](http://passportjs.org/), which offers a host of *strategies* for authentication. If you want a robust solution similar to [Plataformatec’s Devise](https://github.com/plataformatec/devise) for Ruby on Rails, you’ll likely be pointed to [Auth0](https://auth0.com/), a startup who has made authentication as a service.

Compared to Devise, Passport is simply authentication middleware, and does not handle any of the other parts of authentication for you: that means the Node.js developer is likely to roll their own API token mechanisms, password reset token mechanisms, user authentication routes and endpoints, and views in whatever templating language is the rage today. Because of this, there are a lot of tutorials that specialize in setting up Passport for your Express.js application, and nearly all of them are wrong in some way or another, and none properly implement the full stack necessary for a working web application.

> **Note**: I’m not attempting to harass the developers of these tutorials specifically, but rather I am using their authentication mistakes to show security issues inherent in rolling your own authentication systems. If you are a tutorial writer, feel free to reach out to me once you’ve updated your tutorial. Let’s make Node/Express a safer ecosystem for new developers.

### Mistake one: credential storage

Let’s start with credential storage. Storing and recalling credentials is pretty standard fare for identity management, and the traditional way to do this is in your own database or application. Passport, being middleware that simply says “this user is cool” or “this user is not cool”, requires the [passport-local](https://github.com/jaredhanson/passport-local) module for handling password storage in your own database, written by the same developer as Passport.js itself.

Before we go down this tutorial rabbit hole, let’s remind ourselves of a [great cheat sheet for password storage](https://www.owasp.org/index.php/Password_Storage_Cheat_Sheet) by OWASP, which boils down to “store high-entropy passwords with unique salts and one-way adaptive cost functions”. Or, really, Coda Hale’s [bcrypt meme](https://codahale.com/how-to-safely-store-a-password/), even though [there’s some contention](https://security.stackexchange.com/a/6415).

As a new Express.js and Passport user, my first place to look will be the example code for *passport-local* itself, which [thankfully gives me a sample Express.js 4.0 application](https://github.com/passport/express-4.x-local-example) I can clone and extend. However, if I just copypasta this, I’m not left with too much, as there’s no database support in the example and it assumes I’m just using some set accounts.

That’s OK, though, right? *It’s just an Intranet application*, the dev says, *and I have four other projects assigned to me due next week*. Of course, the passwords for the example aren’t hashed in any way, [and stored in plaintext right alongside the validation logic in this example](https://github.com/passport/express-4.x-local-example/blob/master/db/users.js). Credential storage isn’t even considered in this one.

Let’s google for another tutorial using *passport-local*. I find[ this quick tutorial from RisingStack in a series](https://blog.risingstack.com/node-hero-node-js-authentication-passport-js/) called “Node Hero”, but that doesn’t help me, either. They, too, [gave me a sample application on GitHub](https://github.com/RisingStack/nodehero-authentication), but it had [the same problems as the official one](https://github.com/RisingStack/nodehero-authentication/blob/7f808f5c8ea756155099b7b4a88390c356cf31be/app/authentication/init.js#L8). **(*Ed. 8/7/17: *RisingStack is**[**now using bcrypt**](https://github.com/RisingStack/nodehero-authentication/commit/9d69ea70b68c4971466c64382e5f038e3eda8d8a)** in their tutorial application.)**

Next up, [here’s the fourth result](http://mherman.org/blog/2015/01/31/local-authentication-with-passport-and-express-4/) from Google for *express js passport-local tutorial*, written in 2015. It uses the Mongoose ODM and actually reads the credentials from my database. This one really has everything, including integration tests and, yes, another boilerplate you can use. However, the Mongoose ODM [also stores password as type *String*](https://github.com/mjhea0/passport-local-express4/blob/master/models/account.js#L7)*, *so these passwords are also stored in plaintext, only this time on the MongoDB instance. ([Everyone knows MongoDB instances are generally *very *secure](https://www.shodan.io/report/nlrw9g59).)

You could accuse me of cherry-picking tutorials, and you’d be right, if cherry picking means selecting from the first page of Google results. Let’s choose the [higher-ranked-in-results *passport-local* tutorial from TutsPlus](https://code.tutsplus.com/tutorials/authenticating-nodejs-applications-with-passport--cms-21619). This one is better, in that [it uses brypt with a cost factor of 10 for password hashing,](https://github.com/tutsplus/passport-mongo/blob/master/passport/login.js) and defers the synchronous bcrypt hash checks using *process.nextTick*. The top result on Google, [the tutorial from scotch.io](https://scotch.io/tutorials/easy-node-authentication-setup-and-local), also uses [bcrypt with a lesser cost factor of 8](https://github.com/scotch-io/easy-node-authentication/blob/local/app/models/user.js#L37). Both of these are small, but 8 is really small. Most *bcrypt* libraries these days use 12. [The cost factor of 8 was for administrator accounts *eighteen years ago*](https://www.usenix.org/legacy/publications/library/proceedings/usenix99/provos/provos_html/node6.html)when the original bcrypt paper was released.

Password storage aside, neither of these tutorials implement password reset functionality, which is left as an exercise to the developer and comes with its own pitfalls.

### Mistake two: password reset

A sister security issue to password storage is that of password reset, and none of the top basic tutorials explain how to do this at all with Passport. You’ll have to follow another.

There are a thousand ways to fuck this up. The most common ways I have witnessed that people get password reset wrong are:

1. **Predictable tokens. **Tokens that are based upon the current time are a good example. Tokens made by bad pseudorandom number generators are less obvious.
2. **Bad storage. **Storing unencrypted password reset tokens in your DB means that if the DB is compromised, those tokens are effectively plaintext passwords. Generating a long token with a cryptographically secure random number generator stops remote brute force attacks on reset tokens, but it doesn’t stop local attacks. Reset tokens are credentials and should be treated as such.
3. **No token expiry. **Not expiring your tokens gives attackers more time to exploit the reset window.
4. **No secondary data verification.** Security questions are the *de facto* data verification for a reset. Of course, then the developer has to choose *good security questions*. [Security questions have their own problems](https://www.kaspersky.com/blog/security-questions-are-insecure/13004/). While this may seem like security overkill, the email address is something you have, not something you know, and conflates the authentication factors. Your email address becomes the key to every account that just sends a reset token to email.

If you’re new all of this, try OWASP’s [Password Reset Cheat Sheet](https://www.owasp.org/index.php/Forgot_Password_Cheat_Sheet). Let’s get back to what the Node world has to offer for us on this.

We’ll divert to *npm *for a second and [look for password reset](https://www.npmjs.com/search?q=password%20reset&amp;page=1&amp;ranking=popularity), to see if anyone’s made this. There’s a five-year-old package from the (generally awesome) substack. On the Node.js timeline this module is jurassic, and if I wanted to nitpick, [Math.random() is predictable in V8](https://security.stackexchange.com/questions/84906/predicting-math-random-numbers), so [it shouldn’t be used for token generation](https://github.com/substack/node-password-reset/blob/master/index.js#L73). Also, it doesn’t use Passport, so we’ll move on.

Stack Overflow isn’t of too much help, as developer relations from a company called Stormpath loved plugging their IaaS startup on every imaginable post regarding this. [Their documentation also popped up everywhere](https://docs.stormpath.com/client-api/product-guide/latest/password_reset.html) and they have [a blogvertisement on password reset, as well](https://stormpath.com/blog/the-pain-of-password-reset). However, all of this is for naught as Stormpath is defunct, [and it shuts down entirely](https://stormpath.com/) August 17, 2017.

Alright, back to Google, for the only tutorial that seems to exist out there. We’ll take [the first result](http://sahatyalkabov.com/how-to-implement-password-reset-in-nodejs/) for the Google search *express passport password reset. *Here is our old friend *bcrypt* again, with an even smaller cost factor of 5 used in the text, which is *far* too small of a cost factor for modern use.

However, this tutorial is pretty solid compared to others in that it uses *crypto.randomBytes* to generate truly random tokens, and expires them if they aren’t used. However #2 and #4 of the practices above aren’t honored by this comprehensive tutorial, and thus the password tokens themselves are vulnerable to authentication mistake number one, credential storage.

Thankfully, this is of limited use thanks to the reset expiry. However, these tokens are especially fun if an attacker has read access to the user objects in the DB via BSON injection or can access Mongo freely due to misconfiguration. The attacker can just issue password resets for every user, read the unencrypted tokens from the DB, and set their own passwords for user accounts instead of having to go through the costly process of dictionary attacks on bcrypt hashes with a GPU rig.

### Mistake three: API tokens

API tokens are credentials. They are just as sensitive as passwords or reset tokens. Most every developer knows this and tries to hold their AWS keys, Twitter secrets, etc. close to their chest, however this doesn’t seem to transfer into the code being authored.

Let’s use [JSON Web Tokens](https://jwt.io/) for API credentials. Having a stateless, blacklistable, claimable token is better than the old API key/secret pattern that has been used for the better part of a decade. Perhaps our junior Node.js dev has heard of JWT somewhere before, or saw *passport-jwt* and decided to implement the JWT strategy. In any case, JWT is where everyone seems to be moving in the Node.js sphere of influence. (The venerable [Thomas Ptacek will argue that JWT is bad](https://news.ycombinator.com/item?id=13866883) but I’m afraid that ship has sailed here.)

We’ll search for *express js jwt* on Google, and then find [Soni Pandey](https://medium.com/@pandeysoni)’s tutorial [*User Authentication using JWT (JSON Web Token) in Node.js*](https://medium.com/@pandeysoni/user-authentication-using-jwt-json-web-token-in-node-js-using-express-framework-543151a38ea1)which is the first tutorial result. Unfortunately, this doesn’t actually help us at all, since it doesn’t use Passport, but while we’re here we’ll quickly note the mistakes in credential storage:

1. We’ll store the [JWT key in plaintext in the repository](https://github.com/pandeysoni/User-Authentication-using-JWT-JSON-Web-Token-in-Node.js-Express/blob/master/server/config/config.js#L13).
2. We’ll [use a symmetric cipher to store passwords](https://github.com/pandeysoni/User-Authentication-using-JWT-JSON-Web-Token-in-Node.js-Express/blob/master/server/config/common.js#L54). This means that I can get the encryption key and decrypt all of the passwords in event of a breach. The encryption key is shared with the JWT secret.
3. We’ll use AES-256-CTR for password storage. We shouldn’t be using AES to start, and this mode of operation doesn’t help. I am not sure why this mode specifically was chosen, but [the choice alone leaves the ciphertext malleable](https://crypto.stackexchange.com/a/33861).

Welp. Let’s back out to Google and we find the next tutorial. Scotch, which did an OK job with password storage in their passport-local tutorial, [just ignores what they told you before and stores the passwords in plaintext](https://github.com/scotch-io/node-token-authentication/blob/master/app/models/user.js#L7) for this example.

Uh, we’ll give that a pass for brevity, but it doesn’t help the copypasta crew. That’s because more interestingly, this tutorial [also serializes the mongoose User object into the JWT](https://github.com/scotch-io/node-token-authentication/blob/master/server.js#L81).

Let’s clone the Scotch tutorial repository, follow the instructions, and run it. After a *DeprecationWarning *or three from Mongoose, we can hit [*http://localhost:8080/setup*](http://localhost:8080/setup)to create the user, then get a token by posting to /api/authenticate with the default credentials of “Nick Cerminara” and “password”. A token is returned, as displayed from Postman.

![](https://cdn-images-1.medium.com/max/1600/1*wvb2F4-Rx4I1ji2EJIyXZg.png)

A JWT token returned from the Scotch tutorial.

Note that JSON Web Tokens are signed, but not encrypted. That means that big blob between the two periods is a Base64-encoded object. Quickly decoding it, we get something interesting.

![](https://cdn-images-1.medium.com/max/1600/1*5KcDyNtIfWXVe9uVUD0A_g.png)

I love my passwords in plaintext in tokens.
Now, anyone that has *even an expired token* has your password, as well as whatever else is stored in the Mongoose model. Given that this one came over HTTP, I could have sniffed it off of the wire.

What about the next tutorial? The next tutorial, [*Express, Passport and JSON Web Token (jwt) Authentication for Beginners*](https://jonathanmh.com/express-passport-json-web-token-jwt-authentication-beginners/)*, *contains the same information disclosure vulnerability*. *The next tutorial from a startup called [SlatePeak does the same serialization](http://blog.slatepeak.com/creating-a-simple-node-express-api-authentication-system-with-passport-and-jwt/). At this point, I gave up looking.

### Mistake four: rate limiting

As I alluded to above, I did not find a mention of rate limiting or account locking in any of these authentication tutorials.

Without rate limiting, an adversary can perform online dictionary attacks in which a tool like [Burp Intruder](https://portswigger.net/burp/help/intruder_using.html) is run in hopes of gaining access to an account with a weak password. Account lockout also helps with this problem by requiring extended login information from a user the next time they log in.

Remember, rate limiting also helps availability. *bcrypt* is a CPU-intensive function, and without rate limiting functions using bcrypt become an application-level denial of service vector, especially at high work factors. Multiple requests for user registration or login password checking are an easy way to turn a lightweight HTTP request into costly time for your server.

While I do not have a tutorial I can point to for these, there are tons of rate limiting middlewares for Express, such as [express-rate-limit](https://github.com/nfriedly/express-rate-limit), [express-limiter](https://www.npmjs.com/package/express-limiter), and [express-brute](https://github.com/AdamPflug/express-brute). I cannot speak to the security of these modules and have not even looked at them; generally I [recommend running a reverse proxy in production](https://expressjs.com/en/advanced/best-practice-performance.html#use-a-reverse-proxy) and allowing [rate limiting to requests to be handled by nginx](https://www.nginx.com/blog/rate-limiting-nginx/) or whatever your load balancer is.

### Authentication is hard.

I’m sure the tutorial developers will defend themselves with “This is just meant to explain the basics! Surely nobody will do this in production!” However, I cannot emphasize enough *just how false this is*. This is *especially* true when code is put out there in your tutorials. People will take your word for it — after all, you *do* have more expertise than they do.

**If you’re a beginner, don’t trust your tutorials.** Copypasta from tutorials *will* likely get you, your company, and your clients in authentication trouble in the Node.js world. If you really need strong, production-ready, all-in-one authentication libraries, go back to something that holds your hand better, has better stability, and is more proven, like Rails/Devise.

The Node.js ecosystem, while accessible, still has a lot of sharp edges for JavaScript-based developers needing to write production web applications in a hurry. If you have a front-end background and don’t know other programming languages, I personally believe it is easier to pick up Ruby and stand on the shoulders of giants than it is to quickly learn how not to shoot yourself in the foot when writing these types of things from scratch.

If you’re a tutorial writer, *please* update your tutorials, *especially *the boilerplate code. This code will become copypasta into others’ production web applications.

If you are a die-hard Node.js developer, hopefully you’ve learned a few things not to do in your authentication system you’re rolling with Passport. You will likely get something wrong. I haven’t gotten close to covering all of the ways to get it wrong in this one post. It shouldn’t be your job to roll your own auth for your Express application. There should be something better.

If you’re interested in better securing the Node ecosystem, please DM me [@_micaksica](https://twitter.com/_micaksica) on Twitter.

> This post was brought to you by espresso because I’m out of sake.


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  