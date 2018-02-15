> * 原文地址：[12 best practices for user account, authorization and password management](https://cloudplatform.googleblog.com/2018/01/12-best-practices-for-user-account.html)
> * 原文作者：[Google Cloud Platform](https://cloudplatform.googleblog.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/12-best-practices-for-user-account.md](https://github.com/xitu/gold-miner/blob/master/TODO/12-best-practices-for-user-account.md)
> * 译者：
> * 校对者：

# 12 best practices for user account, authorization and password management
用户账户、授权和密码管理的12个最佳方法

Account management, authorization and password management can be tricky. For many developers, account management is a dark corner that doesn't get enough attention. For product managers and customers, the resulting experience often falls short of expectations.

账户管理、授权和密码管理问题可以变得很棘手。对于很多开发者来说，账户管理仍是一个暗角,并没有得到足够的重视。而对于产品管理者和客户来说，由此产生的体验往往达不到预期的效果。


Fortunately, [Google Cloud Platform](https://cloud.google.com/) (GCP) brings several tools to help you make good decisions around the creation, secure handling and authentication of user accounts (in this context, anyone who identifies themselves to your system — customers or internal users). Whether you're responsible for a website hosted in [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/), an API on [Apigee](https://cloud.google.com/apigee-api-management/), an app using [Firebase](https://firebase.google.com/) or other service with authenticated users, this post will lay out the best practices to ensure you have a safe, scalable, usable account authentication system.

幸运的是，[Google Cloud Platform](https://cloud.google.com/) (GCP) 上有几个工具，可以帮助你在围绕用户账户（在这里指那些在你的系统中认证的客户和内部用户）进行的创新、安全处理和授权方面做出好的决定。

## Hash those passwords

## 将密码打乱

My most important rule for account management is to safely store sensitive user information, including their password. You must treat this data as sacred and handle it appropriately.

账户管理最重要的准则是安全地存储敏感的用户信息，包括他们的密码。你必须神圣地对待并恰当地处理这些数据。

Do not store plaintext passwords under any circumstances. Your service should instead store a cryptographically strong hash of the password that cannot be reversed — created with, for example, PBKDF2, SHA3, Scrypt, or Bcrypt. The hash should be [salted](https://www.owasp.org/index.php/Password_Storage_Cheat_Sheet#Use_a_cryptographically_strong_credential-specific_salt) with a value unique to that specific login credential. Do not use deprecated hashing technologies such as MD5, SHA1 and under no circumstances should you use reversible encryption or [try to invent your own hashing algorithm](https://www.schneier.com/blog/archives/2011/04/schneiers_law.html).

不要在任何情况下存储明文密码。相反，你的服务应该存储经过加密且不可逆转的密码的强哈希值——比如，可以用 PBKDF2, SHA3, Scrypt,或 Bcrypt 这类值创建。这些哈希值应该用相应的登录证书所特有的数值来 [设置](https://www.owasp.org/index.php/Password_Storage_Cheat_Sheet#Use_a_cryptographically_strong_credential-specific_salt)。不要用已经弃用的哈希技术比如 MDS 和 SHA1，并且，任何情况下都不要使用可逆转的编码或者 [试着发明自己的哈希算法](https://www.schneier.com/blog/archives/2011/04/schneiers_law.html)。

You should design your system assuming it will be compromised eventually. Ask yourself "If my database were exfiltrated today, would my users' safety and security be in peril on my service or other services they use? What can we do to mitigate the potential for damage in the event of a leak?"

在设计系统时，应该假设你的系统会受到攻击，并以此为前提设计系统。设计系统时要考虑“如果我的数据库今天受损，用户在我或者其他服务上的安全和保障会有危险吗？我们怎样做才能减小事件中的潜在损失。”

Another point: If you could possibly produce a user's password in plaintext at any time outside of immediately after them providing it to you, there's a problem with your implementation.

另外一点：如果你随时都能将用户提供给你的密码生成明文密码，那么你的系统就是有问题的。

## Allow for third-party identity providers if possible

## 如果可以的话，允许第三方提供身份验证

Third-party identity providers enable you to rely on a trusted external service to authenticate a user's identity. Google, Facebook and Twitter are commonly used providers.

使用第三方提供身份验证，你就可以依赖一个可靠地外部设备来对用户的身份进行验证。Google，Facebook 和 Twitter 都是常用的身份验证提供者。

You can implement external identity providers alongside your existing internal authentication system using a platform such as [Firebase Auth](https://firebase.google.com/docs/auth/). There are a number of benefits that come with Firebase Auth, including simpler administration, smaller attack surface and a multi-platform SDK. We'll touch on more benefits throughout this list. See our [case studies](https://firebase.google.com/docs/auth/case-studies/) on companies that were able to integrate Firebase Auth in as little as one day.

你可以使用 [Firebase Auth](https://firebase.google.com/docs/auth/) 这样的平台在你已有的内部身份验证系统旁设置外部身份验证方式。使用 Firebase Auth 有许多好处，比如更简单的管理、更小的受攻击面和一个多平台的 SDK。通过这个清单我们可以接触更多的益处。查看我们有关公司的 [case studies](https://firebase.google.com/docs/auth/case-studies/)，可以尽可能小的整合 Firebase Auth。

## Separate the concept of user identity and user account

## 区分用户身份和用户账户的概念

Your users are not an email address. They're not a phone number. They're not the unique ID provided by an OAUTH response. Your users are the culmination of their unique, personalized data and experience within your service. A well designed user management system has low coupling and high cohesion between different parts of a user's profile.

你的用户并不是一个邮件地址，也不是一个电话号码，更不是由一个 OAUTH 回复提供的特有 ID。他们是你的服务中，所有与之相关的独特、个性化的数据和经验呈现的最终结果。一个设计优良的用户管理系统在不同用户的个人简介之间低耦合且高内聚。

Keeping the concepts of user account and credentials separate will greatly simplify the process of implementing third-party identity providers, allowing users to change their username and linking multiple identities to a single user account. In practical terms, it may be helpful to have an internal global identifier for every user and link their profile and authentication identity via that ID as opposed to piling it all in a single record.

将用户账户和证书的概念区分开可以极大地简化使用第三方身份验证的过程，允许用户修改自己的用户名，并关联多个身份到单一用户账户上。在实用阶段，这样可以使我们对每个用户都有一个内部的全局标识符，并通过这个 ID 将他们的个人简介与身份验证相关联，而不是将它全部堆放在一条记录里。

## Allow multiple identities to link to a single user account

## 允许单一用户账户关联多重身份

A user who authenticates to your service using their [username and password](https://firebase.google.com/docs/auth/web/password-auth) one week might choose [Google Sign-In](https://firebase.google.com/docs/auth/web/google-signin) the next without understanding that this could create a duplicate account. Similarly, a user may have very good reason to link multiple email addresses to your service. If you properly separated user identity and authentication, it will be a simple process to [link several identities](https://firebase.google.com/docs/auth/web/account-linking) to a single user.

一个每星期用 [用户名和密码](https://firebase.google.com/docs/auth/web/password-auth) 在你的服务上认证的用户，会选择 [Google 登录](https://firebase.google.com/docs/auth/web/google-signin)，而不需要去理解这一操作会创建重复的账户的问题。简单来说，一个用户可能有非常好的理由来将多个邮件地址关联到你的服务上。如果你能够正确地将用户的身份和认证区分开，那么 [关联多个身份](https://firebase.google.com/docs/auth/web/account-linking) 到一个单一用户上将是一件十分简单的事情。

Your backend will need to account for the possibility that a user gets part or all the way through the signup process before they realize they're using a new third-party identity not linked to their existing account in your system. This is most simply achieved by asking the user to provide a common identifying detail, such as email address, phone or username. If that data matches an existing user in your system, require them to also authenticate with a known identity provider and link the new ID to their existing account.

在用户意识到他们正在使用一个与他们在你的系统中已有的账户毫无关联的新的第三方身份之前，你需要对用户这种对于注册方式所知部分或全部的可能性负责。大多数情况下，要解决这个问题可以简单地要求客户提供一份普通的身份细节，比如邮件地址、电话或用户名等。如果这份数据与系统中已有的用户相匹配，则需要他们使用已知的身份认证，并将新的 ID 关联到他们已有的账户上。

## Don't block long or complex passwords

## 不要限制较长或者复杂的密码

NIST has recently updated guidelines on [password complexity and strength](https://pages.nist.gov/800-63-3/sp800-63b.html#appendix-astrength-of-memorized-secrets). Since you are (or will be very soon) using a strong cryptographic hash for password storage, a lot of problems are solved for you. Hashes will always produce a fixed-length output no matter the input length, so your users should be able to use passwords as long as they like. If you must cap password length, only do so based on the maximum POST size allowable by your servers. This is commonly well above 1MB. Seriously.

NIST 最近在 [密码的复杂度和强度](https://pages.nist.gov/800-63-3/sp800-63b.html#appendix-astrength-of-memorized-secrets) 上更新了指南。既然你正在（或者很快就要）使用一个强加密的哈希值来进行密码存储，那么这里为你解决了很多问题。无论输入内容的长短，哈希值总会生成一个固定长度的输出值，所以你的用户应该根据自己喜好的长度设置自己的用户密码。如果你必须限制密码的长度，请按照你的服务器所允许的 POST 的最大值来设置。这通常超过1M。真的。

Your hashed passwords will be comprised of a small selection of known ASCII characters. If not, you can easily convert a binary hash to [Base64](https://en.wikipedia.org/wiki/Base64). With that in mind, you should allow your users to use literally any characters they wish in their password. If someone wants a password made of [Klingon](https://en.wikipedia.org/wiki/Klingon_alphabets), [Emoji](https://en.wikipedia.org/wiki/Emoji#Unicode_blocks) and control characters with whitespace on both ends, you should have no technical reason to deny them.

你的哈希密码将包含一小部分已知的 ASCII 码。如果不是，你可以轻易地将一个二进制的哈希值转成 [Base64](https://en.wikipedia.org/wiki/Base64)。考虑到这一点，你应该允许你的用户在设置密码时自由地使用任何他们想要的字符。如果有人想要一个由 [Klingon](https://en.wikipedia.org/wiki/Klingon_alphabets)、[Emoji](https://en.wikipedia.org/wiki/Emoji#Unicode_blocks) 以及两端带有空格的控制字符组成的密码，你应该无需任何技术理由地拒绝他们。

## Don't impose unreasonable rules for usernames

## 不要对用户名强加不合理的规则

It's not unreasonable for a site or service to require usernames longer than two or three characters, block hidden characters and prevent whitespace at the beginning and end of a username. However, some sites go overboard with requirements such as a minimum length of eight characters or by blocking any characters outside of 7-bit ASCII letters and numbers.

如果一个网站或服务要求用户名长度必须大于两个或三个字 符、限制隐藏字符或不允许用户名的两端带有空格，这都不属于不合理的范畴。然而，有些网站的要求未免有些极端，比如，最小长度为八个字符或不允许使用任何大于 7bit 的 ASCII 字母和数字。

A site with tight restrictions on usernames may offer some shortcuts to developers, but it does so at the expense of users and extreme cases will drive some users away.

一个对用户名要求严格的站点会给开发者提供一些捷径，但这却是以用户的损失为代价的，同时，一些极端的情况也会带走一定数量的用户。

There are some cases where the best approach is to assign usernames. If that's the case for your service, ensure the assigned username is user-friendly insofar as they need to recall and communicate it. Alphanumeric IDs should avoid visually ambiguous symbols such as "Il1O0." You're also advised to perform a dictionary scan on any randomly generated string to ensure there are no unintended messages embedded in the username. These same guidelines apply to auto-generated passwords.

有些情况需要我们分配用户名。如果你的服务属于这些情况，要确保用户名能够使用户在回想或交流时感觉到足够友好。由字母和数字组成的 ID 应该尽量避免会在视觉上会产生歧义的符号，比如“Il1O0”。

## Allow users to change their username

## 允许用户修改用户名

It's surprisingly common in legacy systems or any platform that provides email accounts not to allow users to change their username. There are [very good reasons](https://www.computerworld.com/article/2838283/facebook-yahoo-prevent-use-of-recycled-email-addresses-to-hijack-accounts.html) not to automatically release usernames for reuse, but long-term users of your system will eventually come up with a good reason to use a different username and they likely won't want to create a new account.

令人普遍感到惊讶的是，原有系统或是其他提供邮箱账户的平台都不允许用户修改他们的用户名。我们有很多 [非常好的理由](https://www.computerworld.com/article/2838283/facebook-yahoo-prevent-use-of-recycled-email-addresses-to-hijack-accounts.html) 不去自动释放用户名以供重新使用，但是你系统的长期用户终将会想要一个新的用户名，且无须创建一个新的账户。

You can honor your users' desire to change their usernames by allowing aliases and letting your users choose the primary alias. You can apply any business rules you need on top of this functionality. Some orgs might only allow one username change per year or prevent a user from displaying anything but their primary username. Email providers might ensure users are thoroughly informed of the risks before detaching an old username from their account or perhaps forbid unlinking old usernames entirely.

你可以允许使用别名，并让你的用户选择一个首要的别名，以此来满足他们想要修改自己用户名的要求。你可以在此功能之上应用任何你需要的商务规则。有些系统可能会允许用户一年修改一次用户名或者只显示用户的别名。电子邮件服务提供商应该可以确保用户在将旧用户名与他们的账户分离开，或是完全禁止断开旧用户名之前，已经充分的了解了其中的风险。

Choose the right rules for your platform, but make sure they allow your users to grow and change over time.

为你的平台选择正确的规则，但是要确保他们允许你的用户随着时间增长和变化。

## Let your users delete their accounts

## 让你的用户删掉他们的账户

A surprising number of services have no self-service means for a user to delete their account and associated data. There are a number of good reasons for a user to close an account permanently and delete all personal data. These concerns need to be balanced against your security and compliance needs, but most regulated environments provide specific guidelines on data retention. A common solution to avoid compliance and hacking concerns is to let users schedule their account for automatic future deletion.

没有提供自助服务的服务系统数量惊人，这对一个用户来说就意味着删掉他们的账户和相关数据。对一个用户来说，永久地关掉一个账户并删掉所有的个人数据有很多的好理由。这些需求点需要与你的安全性和顺从性需求相平衡，但大多数受监管的环境都会提供有关数据存储的相关指导。为避免顺从性以及黑客的关注，一个较普遍的做法是让用户安排他们的账户，以便未来自动删除。

In some circumstances, you may be [legally required to comply](http://ec.europa.eu/justice/data-protection/files/factsheets/factsheet_data_protection_en.pdf) with a user's request to delete their data in a timely manner. You also greatly increase your exposure in the event of a data breach where the data from "closed" accounts is leaked.

在某些情况下，你可能会 [被合法地要求遵照](http://ec.europa.eu/justice/data-protection/files/factsheets/factsheet_data_protection_en.pdf) 用户的需求及时的删掉他们的数据。同样，当“已关闭”账户的数据泄漏时，你也会极大的增加你的曝光率。

## Make a conscious decision on session length

## 在对话长度上做出理智的选择

An often overlooked aspect of security and authentication is [session length](https://firebase.google.com/docs/auth/web/auth-state-persistence). Google puts a lot of effort into [ensuring users are who they say they are](https://support.google.com/accounts/answer/7162782?co=GENIE.Platform%3DAndroid&hl=en) and will double-check based on certain events or behaviors. Users can take steps to [increase their security even further](https://support.google.com/accounts/answer/7519408?hl=en&ref_topic=7189123).

安全和认证中一个经常被忽视的方面是 [会话长度](https://firebase.google.com/docs/auth/web/auth-state-persistence)。Google 在 [确保用户是他们所说的人](https://support.google.com/accounts/answer/7162782?co=GENIE.Platform%3DAndroid&hl=en) 方面做了很多努力，并将基于某些事件或行为进行二次确认。用户可以采取措施 [进一步提高自己的安全度](https://support.google.com/accounts/answer/7519408?hl=en&ref_topic=7189123)。

Your service may have good reason to keep a session open indefinitely for non-critical analytics purposes, but there should be [thresholds](https://pages.nist.gov/800-63-3/sp800-63b.html#aal1reauth) after which you ask for password, 2nd factor or other user verification.

你的服务可能有充分的理由为非关键的分析目的保持一段会话无限期开放，但是这应该有 [门槛](https://pages.nist.gov/800-63-3/sp800-63b.html#aal1reauth)，要求输入密码，第二因素或其他用户验证。

Consider how long a user should be able to be inactive before re-authenticating. Verify user identity in all active sessions if someone performs a password reset. Prompt for authentication or 2nd factor if a user changes core aspects of their profile or when they're performing a sensitive action. Consider whether it makes sense to disallow logging in from more than one device or location at a time.

考虑一个用户在重新认证之前需要保持多长时间的非活跃状态。如果某人想要执行密码重置，需要在所有活跃会话中验证用户身份。如果一个用户想要更改他们个人信息的核心内容，或者当他们在执行一次敏感的行为时，提示进行身份验证或第二因素。要考虑不允许同时在不同设备或地址登录是否有意义。

When your service does expire a user session or require re-authentication, prompt the user in real-time or provide a mechanism to preserve any activity they have unsaved since they were last authenticated. It's very frustrating for a user to fill out a long form, submit it some time later and find out all their input has been lost and they must log in again.

当你的服务终止用户会话或需要再次验证时，实时提示用户或提供一种机制来保存自他们上次验证后还没来得及保存的全部活动。对用户来说，当他们填好一份很长的表格并在之后提交，却发现他们输入的所有信息全部丢失且他们必须再次登录，这是十分令人沮丧的。

## Use 2-Step Verification

## 使用两步身份验证

Consider the practical impact on a user of having their account stolen when choosing from [2-Step Verification](https://www.google.com/landing/2step/) (also known as 2-factor authorization or just 2FA) methods. SMS 2FA auth has been [deprecated by NIST](https://pages.nist.gov/800-63-3/sp800-63b.html) due to multiple weaknesses, however, it may be the most secure option your users will accept for what they consider a trivial service. Offer the most secure 2FA auth you reasonably can. Enabling third-party identity providers and piggybacking on their 2FA is a simple means to boost your security without great expense or effort.
 
要考虑当用户选择 [两步验证](https://www.google.com/landing/2step/) (也称两因素验证或只是 2FA)方法而账户被盗后的实际影响。由于有许多缺陷,SMS 2FA 认证 [被 NIST 反对](https://pages.nist.gov/800-63-3/sp800-63b.html),然而,它或许是你的用户考虑到这是一项微不足道的服务时会接受的最安全的选择了。请尽可能提供你能提供的最安全的 2FA 认证。支持第三方身份验证和在他们的 2FA 上面打包是个十分简单的方法,使你能够不花费太多力气就能提高你的安全度。
 
## Make user IDs case insensitive
 
## 用户 ID 不区分大小写
 
Your users don't care and may not even remember the exact case of their username. Usernames should be fully case-insensitive. It's trivial to store usernames and email addresses in all lowercase and transform any input to lowercase before comparing.
 
你的用户不会关心或者甚至可能并不记得他们确切的用户名。用户名应该完全不区分大小写。与输入时将所有字符转换为小写相比,存储时将用户名和邮件地址全部保存为小写显得十分微不足道。
 
Smartphones represent an ever-increasing percentage of user devices. Most of them offer autocorrect and automatic capitalization of plain-text fields. Preventing this behavior at the UI level might not be desirable or completely effective, and your service should be robust enough to handle an email address or username that was unintentionally auto-capitalized.
 
智能手机的使用代表用户设备所占的比重不断增加。他们大多数提供纯文本字段的自动更正和自动资本化功能。
 
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
