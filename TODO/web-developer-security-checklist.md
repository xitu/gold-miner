> * 原文地址：[Web Developer Security Checklist](https://simplesecurity.sensedeep.com/web-developer-security-checklist-f2e4f43c9c56)
> * 原文作者：[Michael O'Brien](https://simplesecurity.sensedeep.com/@sensedeep)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：


# Web Developer Security Checklist #

![](https://cdn-images-1.medium.com/max/800/1*UOl3ydmbG1ehgoSpBxdGFA.jpeg)

Developing secure, robust web applications in the cloud is **hard, very hard**. If you think it is easy, you are either a higher form of life or you have a painful awakening ahead of you.

If you have drunk the [MVP](https://en.wikipedia.org/wiki/Minimum_viable_product) cool-aid and believe that you can create a product in one month that is both valuable and secure — think twice before you launch your “proto-product”. After you review the checklist below, acknowledge that you are skipping many of these critical security issues. At the very minimum, be *honest* with your potential users and let them know that you don’t have a complete product yet and are offering a prototype without full security.

This checklist is simple, and by no means complete. It is a list of some of the more important issues you should consider when creating a web application.

Please comment if you have an item I can add to the list.

### **Database** ###

-  Use encryption for data identifying users and sensitive data like access tokens, email addresses or billing details.
-  If your database supports low cost encryption at rest (like [AWS Aurora](https://aws.amazon.com/about-aws/whats-new/2015/12/amazon-aurora-now-supports-encryption-at-rest/)), then enable that to secure data on disk. Make sure all backups are stored encrypted as well.
-  Use minimal privilege for the database access user account. Don’t use the database root account.
-  Store and distribute secrets using a key store designed for the purpose. Don’t hard code in your applications.
-  Fully prevent SQL injection by only using SQL prepared statements. For example: if using NPM, don’t use npm-mysql, use npm-mysql2 which supports prepared statements.

### Development ###

-  Ensure that all components of your software are scanned for vulnerabilities for every version pushed to production. This means O/S, libraries and packages. This should be automated into the CI-CD process.
-  Secure development systems with equal vigilance to what you use for production systems. Build the software from secured, isolated development systems.

### Authentication ###

-  Ensure all passwords are hashed using appropriate crypto such as bcrypt. Never write your own crypto and correctly initialize crypto with good random data.
-  Implement simple but adequate password rules that encourage users to have long, random passwords.
-  Use multi-factor authentication for your logins to all your service providers.

### **Denial of Service Protection** ###

-  Make sure that DOS attacks on your APIs won’t cripple your site. At a minimum, have rate limiters on your slower API paths like login and token generation routines.
-  Enforce sanity limits on the size and structure of user submitted data and requests.
-  Use [Distributed Denial of Service](https://en.wikipedia.org/wiki/Denial-of-service_attack) (DDOS) mitigation via a global caching proxy service like [CloudFlare](https://www.cloudflare.com/). This can be turned on if you suffer a DDOS attack and otherwise function as your DNS lookup.

### **Web Traffic** ###

-  Use TLS for the entire site, not just login forms and responses. Never use TLS for just the login form.
-  Cookies must be httpOnly and secure and be scoped by path and domain.
-  Use [CSP](https://en.wikipedia.org/wiki/Content_Security_Policy) without allowing unsafe-* backdoors. It is a pain to configure, but worthwhile.
-  Use X-Frame-Option, X-XSS-Protection headers in client responses
-  Use HSTS responses to force TLS only access. Redirect all HTTP request to HTTPS on the server as backup.
-  Use CSRF tokens in all forms and use the new [SameSite Cookie](https://scotthelme.co.uk/csrf-is-dead/) response header which fixes CSRF once and for all newer browsers.

### **APIs** ###

-  Ensure that no resources are enumerable in your public APIs.
-  Ensure that users are fully authenticated and authorized appropriately when using your APIs.

### **Validation** ###

-  Do client-side input validation for quick user feedback, but never trust it.
-  Validate every last bit of user input using white lists on the server. Never directly inject user content into responses. Never use user input in SQL statements.

### **Cloud Configuration** ###

-  Ensure all services have minimum ports open. While security through obscurity is no protection, using non-standard ports will make it a little bit harder for attackers.
-  Host backend database and services on private VPCs that are not visible on any public network. Be very careful when configuring AWS security groups and peering VPCs which can inadvertently make services visible to the public.
-  Isolate logical services in separate VPCs and peer VPCs to provide inter-service communication.
-  Ensure all services only accept data from a minimal set of IP addresses.
-  Restrict outgoing IP and port traffic to minimize APTs and “botification”.
-  Always use AWS IAM roles and not root credentials.
-  Use minimal access privilege for all ops and developer staff
-  Regularly rotate passwords and access keys according to a schedule.

### **Infrastructure** ###

-  Ensure you can do upgrades without downtime. Ensure you can quickly update software in a fully automated manner.
-  Create all infrastructure using a tool such as Terraform, and not via the cloud console. Infrastructure should be defined as “code” and be able to be recreated at the push of a button. Have zero tolerance for any resource created in the cloud by hand — Terraform can then audit your configuration.
-  Use centralized logging for all services. You should never need SSH to access or retrieve logs.
-  Don’t SSH into services except for one-off diagnosis. Using SSH regularly, typically means you have not automated an important task.
-  Don’t keep port 22 open on any AWS service groups on a permanent basis.
-  Create [immutable hosts](http://chadfowler.com/2013/06/23/immutable-deployments.html) instead of long-lived servers that you patch and upgrade. (See [Immutable Infrastructure Can Be More Secure](https://simplesecurity.sensedeep.com/immutable-infrastructure-can-be-dramatically-more-secure-238f297eca49)).
-  Use an [Intrusion Detection System](https://en.wikipedia.org/wiki/Intrusion_detection_system) like [SenseDeep](https://www.sensedeep.com/) or service to minimize [APTs](https://en.wikipedia.org/wiki/Advanced_persistent_threat) .

### **Operation** ###

-  Power off unused services and servers. The most secure server is one that is powered down.

### Test ###

-  Audit your design and implementation.
-  Do penetration testing — hack yourself, but also have someone other than you pen testing as well.

### **Finally, have a plan** ###

-  Have a threat model that describes what you are defending against. It should list and prioritize the possible threats and actors.
-  Have a practiced security incident plan. One day, you will need it.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
