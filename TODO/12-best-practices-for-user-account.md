> * 原文地址：[12 best practices for user account, authorization and password management](https://cloudplatform.googleblog.com/2018/01/12-best-practices-for-user-account.html)
> * 原文作者：[Google Cloud Platform](https://cloudplatform.googleblog.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/12-best-practices-for-user-account.md](https://github.com/xitu/gold-miner/blob/master/TODO/12-best-practices-for-user-account.md)
> * 译者：
> * 校对者：

# 12 best practices for user account, authorization and password management

Account management, authorization and password management can be tricky. For many developers, account management is a dark corner that doesn't get enough attention. For product managers and customers, the resulting experience often falls short of expectations.

Fortunately, [Google Cloud Platform](https://cloud.google.com/) (GCP) brings several tools to help you make good decisions around the creation, secure handling and authentication of user accounts (in this context, anyone who identifies themselves to your system — customers or internal users). Whether you're responsible for a website hosted in [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/), an API on [Apigee](https://cloud.google.com/apigee-api-management/), an app using [Firebase](https://firebase.google.com/) or other service with authenticated users, this post will lay out the best practices to ensure you have a safe, scalable, usable account authentication system.

## Hash those passwords

My most important rule for account management is to safely store sensitive user information, including their password. You must treat this data as sacred and handle it appropriately.

Do not store plaintext passwords under any circumstances. Your service should instead store a cryptographically strong hash of the password that cannot be reversed — created with, for example, PBKDF2, SHA3, Scrypt, or Bcrypt. The hash should be [salted](https://www.owasp.org/index.php/Password_Storage_Cheat_Sheet#Use_a_cryptographically_strong_credential-specific_salt) with a value unique to that specific login credential. Do not use deprecated hashing technologies such as MD5, SHA1 and under no circumstances should you use reversible encryption or [try to invent your own hashing algorithm](https://www.schneier.com/blog/archives/2011/04/schneiers_law.html).

You should design your system assuming it will be compromised eventually. Ask yourself "If my database were exfiltrated today, would my users' safety and security be in peril on my service or other services they use? What can we do to mitigate the potential for damage in the event of a leak?"

Another point: If you could possibly produce a user's password in plaintext at any time outside of immediately after them providing it to you, there's a problem with your implementation.

## Allow for third-party identity providers if possible

Third-party identity providers enable you to rely on a trusted external service to authenticate a user's identity. Google, Facebook and Twitter are commonly used providers.

You can implement external identity providers alongside your existing internal authentication system using a platform such as [Firebase Auth](https://firebase.google.com/docs/auth/). There are a number of benefits that come with Firebase Auth, including simpler administration, smaller attack surface and a multi-platform SDK. We'll touch on more benefits throughout this list. See our [case studies](https://firebase.google.com/docs/auth/case-studies/) on companies that were able to integrate Firebase Auth in as little as one day.

## Separate the concept of user identity and user account

Your users are not an email address. They're not a phone number. They're not the unique ID provided by an OAUTH response. Your users are the culmination of their unique, personalized data and experience within your service. A well designed user management system has low coupling and high cohesion between different parts of a user's profile.

Keeping the concepts of user account and credentials separate will greatly simplify the process of implementing third-party identity providers, allowing users to change their username and linking multiple identities to a single user account. In practical terms, it may be helpful to have an internal global identifier for every user and link their profile and authentication identity via that ID as opposed to piling it all in a single record.

## Allow multiple identities to link to a single user account

A user who authenticates to your service using their [username and password](https://firebase.google.com/docs/auth/web/password-auth) one week might choose [Google Sign-In](https://firebase.google.com/docs/auth/web/google-signin) the next without understanding that this could create a duplicate account. Similarly, a user may have very good reason to link multiple email addresses to your service. If you properly separated user identity and authentication, it will be a simple process to [link several identities](https://firebase.google.com/docs/auth/web/account-linking) to a single user.

Your backend will need to account for the possibility that a user gets part or all the way through the signup process before they realize they're using a new third-party identity not linked to their existing account in your system. This is most simply achieved by asking the user to provide a common identifying detail, such as email address, phone or username. If that data matches an existing user in your system, require them to also authenticate with a known identity provider and link the new ID to their existing account.

## Don't block long or complex passwords

NIST has recently updated guidelines on [password complexity and strength](https://pages.nist.gov/800-63-3/sp800-63b.html#appendix-astrength-of-memorized-secrets). Since you are (or will be very soon) using a strong cryptographic hash for password storage, a lot of problems are solved for you. Hashes will always produce a fixed-length output no matter the input length, so your users should be able to use passwords as long as they like. If you must cap password length, only do so based on the maximum POST size allowable by your servers. This is commonly well above 1MB. Seriously.

Your hashed passwords will be comprised of a small selection of known ASCII characters. If not, you can easily convert a binary hash to [Base64](https://en.wikipedia.org/wiki/Base64). With that in mind, you should allow your users to use literally any characters they wish in their password. If someone wants a password made of [Klingon](https://en.wikipedia.org/wiki/Klingon_alphabets), [Emoji](https://en.wikipedia.org/wiki/Emoji#Unicode_blocks) and control characters with whitespace on both ends, you should have no technical reason to deny them.

## Don't impose unreasonable rules for usernames

It's not unreasonable for a site or service to require usernames longer than two or three characters, block hidden characters and prevent whitespace at the beginning and end of a username. However, some sites go overboard with requirements such as a minimum length of eight characters or by blocking any characters outside of 7-bit ASCII letters and numbers.

A site with tight restrictions on usernames may offer some shortcuts to developers, but it does so at the expense of users and extreme cases will drive some users away.

There are some cases where the best approach is to assign usernames. If that's the case for your service, ensure the assigned username is user-friendly insofar as they need to recall and communicate it. Alphanumeric IDs should avoid visually ambiguous symbols such as "Il1O0." You're also advised to perform a dictionary scan on any randomly generated string to ensure there are no unintended messages embedded in the username. These same guidelines apply to auto-generated passwords.

## Allow users to change their username

It's surprisingly common in legacy systems or any platform that provides email accounts not to allow users to change their username. There are [very good reasons](https://www.computerworld.com/article/2838283/facebook-yahoo-prevent-use-of-recycled-email-addresses-to-hijack-accounts.html) not to automatically release usernames for reuse, but long-term users of your system will eventually come up with a good reason to use a different username and they likely won't want to create a new account.

You can honor your users' desire to change their usernames by allowing aliases and letting your users choose the primary alias. You can apply any business rules you need on top of this functionality. Some orgs might only allow one username change per year or prevent a user from displaying anything but their primary username. Email providers might ensure users are thoroughly informed of the risks before detaching an old username from their account or perhaps forbid unlinking old usernames entirely.

Choose the right rules for your platform, but make sure they allow your users to grow and change over time.

## Let your users delete their accounts

A surprising number of services have no self-service means for a user to delete their account and associated data. There are a number of good reasons for a user to close an account permanently and delete all personal data. These concerns need to be balanced against your security and compliance needs, but most regulated environments provide specific guidelines on data retention. A common solution to avoid compliance and hacking concerns is to let users schedule their account for automatic future deletion.

In some circumstances, you may be [legally required to comply](http://ec.europa.eu/justice/data-protection/files/factsheets/factsheet_data_protection_en.pdf) with a user's request to delete their data in a timely manner. You also greatly increase your exposure in the event of a data breach where the data from "closed" accounts is leaked.

## Make a conscious decision on session length

An often overlooked aspect of security and authentication is [session length](https://firebase.google.com/docs/auth/web/auth-state-persistence). Google puts a lot of effort into [ensuring users are who they say they are](https://support.google.com/accounts/answer/7162782?co=GENIE.Platform%3DAndroid&hl=en) and will double-check based on certain events or behaviors. Users can take steps to [increase their security even further](https://support.google.com/accounts/answer/7519408?hl=en&ref_topic=7189123).

Your service may have good reason to keep a session open indefinitely for non-critical analytics purposes, but there should be [thresholds](https://pages.nist.gov/800-63-3/sp800-63b.html#aal1reauth) after which you ask for password, 2nd factor or other user verification.

Consider how long a user should be able to be inactive before re-authenticating. Verify user identity in all active sessions if someone performs a password reset. Prompt for authentication or 2nd factor if a user changes core aspects of their profile or when they're performing a sensitive action. Consider whether it makes sense to disallow logging in from more than one device or location at a time.

When your service does expire a user session or require re-authentication, prompt the user in real-time or provide a mechanism to preserve any activity they have unsaved since they were last authenticated. It's very frustrating for a user to fill out a long form, submit it some time later and find out all their input has been lost and they must log in again.

## Use 2-Step Verification

Consider the practical impact on a user of having their account stolen when choosing from [2-Step Verification](https://www.google.com/landing/2step/) (also known as 2-factor authorization or just 2FA) methods. SMS 2FA auth has been [deprecated by NIST](https://pages.nist.gov/800-63-3/sp800-63b.html) due to multiple weaknesses, however, it may be the most secure option your users will accept for what they consider a trivial service. Offer the most secure 2FA auth you reasonably can. Enabling third-party identity providers and piggybacking on their 2FA is a simple means to boost your security without great expense or effort.

## Make user IDs case insensitive

Your users don't care and may not even remember the exact case of their username. Usernames should be fully case-insensitive. It's trivial to store usernames and email addresses in all lowercase and transform any input to lowercase before comparing.

Smartphones represent an ever-increasing percentage of user devices. Most of them offer autocorrect and automatic capitalization of plain-text fields. Preventing this behavior at the UI level might not be desirable or completely effective, and your service should be robust enough to handle an email address or username that was unintentionally auto-capitalized.

## Build a secure auth system

If you're using a service like Firebase Auth, a lot of security concerns are handled for you automatically. However, your service will always need to be engineered properly to prevent abuse. Core considerations include implementing a [password reset](https://firebase.google.com/docs/auth/web/manage-users#send_a_password_reset_email) instead of password retrieval, detailed account activity logging, rate limiting login attempts, locking out accounts after too many unsuccessful login attempts and requiring 2-factor authentication for unrecognized devices or accounts that have been idle for extended periods. There are many more aspects to a secure authentication system, so please see the section below for links to more information.

## Further reading

There are a number of excellent resources available to guide you through the process of developing, updating or migrating your account and authentication management system. I recommend the following as a starting place:

- NIST 800-063B covers Authentication and Lifecycle Management 
- OWASP continually updates their Password Storage Cheat Sheet 
- OWASP goes into even more detail with the Authentication Cheat Sheet 
- Google's Firebase Authentication site has a rich library of guides, reference materials and sample code


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
