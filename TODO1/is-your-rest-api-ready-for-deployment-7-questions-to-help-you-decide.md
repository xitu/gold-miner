> * 原文地址：[Is Your REST API Ready for Deployment? 7 Questions to Help You Decide](https://codeburst.io/is-your-rest-api-ready-for-deployment-7-questions-to-help-you-decide-a371de9faa76)
> * 原文作者：[Zac Johnson](https://medium.com/@zacjohnson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/is-your-rest-api-ready-for-deployment-7-questions-to-help-you-decide.md](https://github.com/xitu/gold-miner/blob/master/TODO1/is-your-rest-api-ready-for-deployment-7-questions-to-help-you-decide.md)
> * 译者：
> * 校对者：

# Is Your REST API Ready for Deployment? 7 Questions to Help You Decide

[Building an API](https://codeburst.io/this-is-how-easy-it-is-to-create-a-rest-api-8a25122ab1f3) can seem daunting, and for good reason. A lot can — and [often does](https://medium.com/better-programming/tips-on-rest-api-error-response-structure-aebe726e7f94) — go wrong. Rather than going back to the drawing board after your REST API has already been deployed, it’s best to be meticulous and launch an excellent API from the start.

How do you know when to say, “Hold on… let’s not deploy this API just yet”?

The following questions can help you determine the answer.

![](https://cdn-images-1.medium.com/max/2560/1*ol3WYuuPV0nhrE0tMNiiZg.jpeg)

**Have You Effectively Documented Your REST API?**

To be blunt, developers won’t want to use your API if it provides poor (or no) documentation. Design your documentation to walk developers through the important aspects of your API so it’s easy to use. Your documentation should also make it easy for developers to maintain and update the API.

Create tutorials that:

* Are publicly accessible
* Provide a glossary that defines terms
* Specify and define resources
* Explain your API’s methods

If you don’t know where to begin, tools like [Raml](https://raml.org/) or [Swagger](https://swagger.io/) can assist you.

**Does your REST API Use the Right Data Format?**

You have a choice of data formats when designing your API, and the one you choose can determine success or failure. Since an API is a connection point between the client and the server, its data format needs to be user friendly for both sides.

Popular formats include:

* **Direct formats** **(like JSON, XML, YAML).** These formats are made to manage data in direct use with other systems. They’re excellent for interacting with other APIs.
* **Feed formats (like RSS, SUP, Atom).** These are primarily used for the serialization of updates from social media and blogs.
* **Database formats (like SQL, CSV).** These are well suited for database-to-database communication as well as database-to-user.

**Did You Effectively Name Your REST API’s Endpoints?
 
** Endpoints identify the locations of resources and specify how these resources can be accessed.

You should follow good REST practices for naming your endpoints, including:

* **Easy resource names.** Don’t make developers guess about resource names or force them to sift through documentation to discover how to find resources. Make sure the names are intuitive from the start.
* **Use nouns in URIs.** A RESTful URI should include a noun (like “/photos”) and exclude verbs. I.e., don’t use a name like “/createPhotos.” Don’t use any CRUD (Create, Read, Update, Delete) conventions here.
* **Keep resource names plural.** For consistency, it’s advisable to use “/photos” or “/settings” (rather than “/photo”).
* **Use hyphens, not underscores.** Some browsers hide underscores ( _ ). Hyphens (-) are easier to see.
* **Lowercase letters.** URI elements are case sensitive (except the scheme and host components). For consistency, stick to lowercase.

**Did You Properly Version Your REST API?**

Your API will undergo changes over time, and you’ll need to manage these changes. Keep your older API versions active and maintained for people who are still using them. 
 
 Proper versioning helps minimize occurrences of invalid requests being sent to newly updated endpoints.

Methods of versioning can include:

* Adding a version number as an attribute within custom request headers
* Parameter versioning, which means adding the version number as a query parameter
* Including the current version number into the URI
* Media type versioning, or altering the accept header to reflect the current version

**Did You Test Your REST API?**

Testing has traditionally happened on the UI side, which focuses on aspects like the site’s user experience.

But because the API connects to the data layer as well as the UI, API testing is now recognized as a crucial task. By [testing your REST API](https://www.sisense.com/blog/rest-api-testing-strategy-what-exactly-should-you-test/), you’re ensuring its performance and functionality.

Types of API testing include:

* **Performance testing.** As the name suggests, this enables you to get a clear picture of the performance of your API. Performance testing includes both functional tests and load tests.
* **Unit testing.** A unit can be an endpoint, an HTTP method (GET, POST, PUT, DELETE), request headers, or request body.
* **Integration testing.** This is perhaps the most frequently used type of API test. Your API is at the heart of the integrations between data, applications and users’ devices. Testing such integration is therefore vital.
* **End to end testing.** This type of testing enables you to confirm the smooth flow of data between API connections.

**Have You Established Security Measures for Your REST API?**

Hackers are getting smarter and stronger in the 2020s. You have to be hyper-vigilant.

Good security practices include:

* **Use Only HTTPS.** Using only HTTPS protects credentials like passwords, JSON Web Tokens, API keys, etc. Also, include a time stamp to HTTP requests. This enables the server to only accept requests within a designated time frame to prevent hackers attempts at replay attacks.
* **Restrict allowed HTTP methods**. Reject any and all requests that aren’t on your permitted methods list.
* **Don’t let sensitive information show up in URLs.** Believe it or not, this sometimes happens. Make sure no passwords, usernames, API keys, etc. are appearing in any URLs.
* **Security checks.** Be thorough and take no chances. Protect your HTTP cookies and databases. Hide any sensitive data that may aggregate to your logs. Practice effective security password checking, and use CSRF tokens.

**Did You Design Your REST API with Scalability in Mind?**

You’ll need your API to process an increasing number of requests over time. It’s important to design it for scalability to maintain its performance and add new features as needed. 
 
 Estimate your system’s load even before designing it. Assess the estimated the number of requests per second and the size of requests. Then, during the API’s uptime, frequently check its load distribution, response time, and other important metrics.
 
 Consider using a cloud service that’s able to automatically scale the system. That way, you won’t need to acquire expensive equipment to handle increasing amounts of data.

**Ready to Run?**

Taking your time and paying attention to details will save you from future frustration. At every stage of the process, ask yourself, “If I were a developer using this API, would I be happy with it?”

If there are bugs or rough spots, you’re justified in pausing deployment to make everything right.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
