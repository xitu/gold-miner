> * 原文地址：[The Best Database-as-a-Service Solutions of 2018](https://uk.pcmag.com/software/116526/guide/the-best-database-as-a-service-solutions-of-2018)
> * 原文作者：[Pam Baker](https://uk.pcmag.com/u/pam-baker)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-best-database-as-a-service-solutions-of-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-best-database-as-a-service-solutions-of-2018.md)
> * 译者：
> * 校对者：

# The Best Database-as-a-Service Solutions of 2018

Databases power everything from apps to workflows, and the best way to deploy these data engines for most businesses is via a Database-as-a-Service (DBaaS) that combines cost savings with cutting-edge power. Check out our reviews of top DBaaS solutions to pick the best your business.

![](https://i.loli.net/2018/09/09/5b94c0c4b03e9.png)

## What Is Database-as-a-Service (DBaaS)?

Database-as-a-Service (DBaaS) is the term for database storage and services in the cloud. It has many of the benefits and disadvantages common to other services in the cloud, such as better cost controls on the one hand but more limited features than the on-premises alternative on the other hand. However, it also doubles as engine-style software that powers a large array of other Software-as-a-Service (SaaS) apps, everything from directly-related [data visualization](https://uk.pcmag.com/cloud-services/83744/guide/the-best-data-visualization-tools-of-2018) tools to organization-spanning [enterprise resource planning](https://uk.pcmag.com/cloud-services/83146/guide/the-best-erp-software-for-2018) (ERP) platforms. But DBaaS is also a solution unto itself with pros and cons unique to [database](https://www.pcmag.com/encyclopedia/term/40871/database) functionalities.

Benefits of DBaaS include lower entry barriers, greater access to technologies that were previously only in reach for large enterprises, and digitally native use cases such as [Internet of Things](https://uk.pcmag.com/feature/88407/how-to-build-a-business-ready-internet-of-things-use-cases) (IoT) data streaming, [machine learning](https://uk.pcmag.com/feature/89094/the-business-guide-to-machine-learning) (ML) training, and hybrid applications such as an adjunct to computing on the edge.

Disadvantages of DBaaS include the general rigidity of databases, the complexity of data science, inflexibilities in integrations, network performance issues, and the complexity that comes with large data transfers. All of these limitations can lead to the real need for assistance from a [database administrator](https://www.pcmag.com/encyclopedia/term/40873/database-administrator) (DBA) despite the claims of many DBaaS vendors that their platforms are self-service and user-friendly.

The bottom line is that data science isn't easy, even if the database spin-up and configuration is automated as it is to one degree or another in DBaaS offerings. But there are DBaaS products and services that are easier to use than others, and some are certainly well within the powers of average developers and business analysts.

I conducted the reviews in this roundup from the perspective of developers and analysts, and to a lesser degree, small to midsize businesses (SMBs) with few internal IT resources. The goal of this project was not to identify superiority from a strictly technical perspective, but to identify how well a typical user is likely to be able to use the service, without the aid of a DBA, while still retaining the technology's full benefit. If the reviews were done based on technical aspects alone, then the vendor rankings might have been different.

## What 'Easy to Use' Really Means in a DBaaS

As with any other SaaS offering, DBaaS is actually software on someone else's servers. That's true even in the unfortunately named "serverless" models. The "easy to use" consideration here applies to more than just whether or not the [user interface](https://www.pcmag.com/encyclopedia/term/53558/user-interface) is user-friendly, but also to the following:

1.  Whether guidance is offered on which database type or engine fits the data or workload,
2.  How easy it is to load and transfer data,
3.  How much of the server provisioning and service configuration is handled by ML and automation, and,
4.  How much of the backup and recovery process is automatic.

If the user must make a long list of decisions simply to configure the database, then it's not really easy to use for non-DBAs no matter how many pull-down menus and explanation boxes the UI has. However, it could be easy for DBAs to use and that's fine, too, but for other purposes and a different kind of review. In other words, for a DBaaS to be a strong self-service platform, it needs to eliminate the need for a DBA to be hands-on with every little user interaction.

On the other hand, if it is to be an alternative or hybrid add-on to an on-premises database or even a company's primary database (as is often the case with cloud-native companies), then being easy for DBAs to use and monitor should be the primary considerations. For example, if your company has been running an instance of Microsoft's SQL Server on-premises for some years, and now opts to add an instance of Microsoft's Azure SQL Database as a cloud-based backup repository, then most of your end-users will never need to touch that instance. In the same vein, if the database's primary task will be to power another app or workflow, then, again, users won't often need to interact with it directly. After all, once a database is up and running, users can employ tools such as [business intelligence](https://uk.pcmag.com/cloud-services/74173/guide/the-best-self-service-business-intelligence-bi-tools-of-2018) (BI), developer, and [DevOps](https://www.pcmag.com/encyclopedia/term/66383/devops) apps to do the work they're really interested in. The database remains in the background for most of these scenarios, and even advanced users other than the DBA will rarely need to touch it.

That said, ease of use in this review roundup includes the entire spectrum of services offered. The service lets developers, analysts, and the occasional SMB general tech person spin up databases on the fly, with few instructions and little more on hand than a credit card and an internet-connected laptop.

By those parameters, Microsoft Azure SQL Database is the easiest to use, with MongoDB Atlas coming in a close second. Deciding which of these two Editors' Choice winners you want to use will have more to do with your data's current format and the projects you're working on than ease of use. IBM Db2 on Cloud is also easy to use, although there are plenty of developers who might beg to differ. Most of the griping centers on design restrictions for developers. There's also the the matter of IBM Db2 on Cloud's fewer options in regions, which might prove a drawback in some compliance scenarios with the European Union's [General Data Protection Regulation](https://uk.pcmag.com/feature/91721/gdpr-begins-today-what-you-need-to-know) (GDPR). It's true that MongoDB Atlas isn't compliant with the [Health Insurance Portability and Accountability Act](https://www.pcmag.com/encyclopedia/term/44279/hipaa) (HIPAA) but it will be shortly. In any case, HIPAA affects fewer developers than does GDPR, making the latter a bigger concern for a larger number of developers and analysts and developers.

## Testing Versions and the Importance of Regions

The review of each product includes notations on whether trial or free versions are available and any limitations that may apply. For example, MongoDB Atlas has a "free forever" version with 512 MB of storage and shared [random access memory](https://www.pcmag.com/encyclopedia/term/50159/ram) (RAM). IBM Db2 on Cloud has a free developer edition with enterprise features, but Express-C, its free commercial version, lacks advanced enterprise features. Paid versions vary less as they are most often pegged to storage and computing use rather than to features. However, it's important to note which features and regions are available in the various versions before you choose one.

Obviously, if it doesn't have advanced enterprise features such as IBM Db2 on Cloud's Express-C version and you need those, then that version isn't going to work out. Likewise, if you have issues with GDPR to address, or a lot of users around the world and you really need to eradicate lag on your app, then Microsoft Azure SQL Database's astounding 50 regions around the globe in 140 countries is going to matter as much as having more version options does.

As to your options in regards to regions, Microsoft Azure SQL Database has the most by far. MongoDB Atlas is second, but that's only because it makes good use of the regions from [Amazon Web Services](https://uk.pcmag.com/amazon-web-services/73783/review/amazon-web-services) (AWS), [Google Cloud](https://uk.pcmag.com/google-cloud-platform/73782/review/google-cloud-platform), and [Microsoft Azure](https://uk.pcmag.com/microsoft-azure/73781/review/microsoft-azure) since it's hosted on all three. And, counterintuitively, Google BigQuery came in with the least number of regions.

Being able to choose the region location for your database is important for two reasons. First, because of regulations such as GDPR, you have to be certain about where your data resides (even in the cloud), where it moves, and how it is used. Being able to select the right location for your database is imperative to staying GDPR-compliant, even if you have no European Union (EU) customer data or EU employee data. Several scenarios apply here.

For example, an employee may be American and thus his data is unaffected by GDPR. His wife may be European or American but their child may have dual citizenship if he or she was born in Europe. So, insurance data on them is affected by GDPR. Therefore, even though the company has no EU customer or EU employee data, it still finds itself needing to be GDPR-compliant. That law is seriously complex. And there's another, even more complex privacy law from the EU coming down the pike. It's prudent, therefore, to know precisely where your data is and what's happening with and to it, whether or not you think you don't have any EU individual data to worry about.

The closer your data and app are to one another, the better the performance—meaning, the shorter the lag and other issues. You'll want to look for options to deploy your app in the same data center as your database or [colocate](https://www.pcmag.com/encyclopedia/term/39977/colocation) your database next to your app.

Versions also differ substantially between vendors and also within a single vendor's product lineup. Some are inexpensive on the front end but rack up costs by charging you for various tools and service upgrades, such as additional security or backup and recovery services. Watch out for that.

For this review roundup, I mostly used mid-tier-priced test accounts that were set up by the vendors rather than the more limited trial or free-tier versions. Sometimes I transferred my own test data and sometimes I loaded vendor test data or worked with their preloaded data sets. In many cases, vendors provided credits to ensure I could thoroughly test their systems. Occasionally, I tested free developer editions, as I did with SAP Cloud Platform, because those are usually full-featured ones. In every case, the version I tested is noted in each review writeup.

## SQL or NoSQL?

Another factor making direct comparisons more difficult in this review roundup is in the types of databases. As all data professionals know, [SQL](https://www.pcmag.com/encyclopedia/term/51902/sql) handles structured data and [NoSQL](https://www.pcmag.com/encyclopedia/term/63645/nosql) is for unstructured data, though that distinction probably isn't obvious to general users. An example of structured data is a spreadsheet while an example of unstructured data is the Twitter feed firehose. SQL databases are usually referred to as relational databases whereas NoSQL databases are called nonrelational ones.

However, when it comes to DBaaS, the options are more varied than just making a structured versus unstructured data determination. For example, MongoDB Atlas, which is open-source NoSQL, runs on other branded cloud services such as AWS, Google, and Microsoft clouds. Some vendors will guide you through the maze of options since their branded DBaaS services offer other product options for other database types.

For example, IBM Db2 on Cloud is SQL, but it will funnel users at the outset to [Cloudant](https://www.ibm.com/cloud/cloudant), an IBM NoSQL DBaaS product, or to open-source databases, such as MongoDB on IBM, as the uploaded data dictates. That's incredibly useful to those with few data science skills or limited understanding.

In each review, I note whether the DBaaS product is SQL or NoSQL and whether other database options are available in the product lineup. With most services, you'll need to know from the outset what type of database you need. With a precious few, such as IBM Db2 on Cloud, the onboarding process will guide you to the right database.

Here's a quick rule of thumb: If you are working with machine-readable data, then you need SQL. Think spreadsheets and IoT data. If it's human thoughts or expressions, then you need NoSQL. Think social media, video data, and audio data. Be forewarned that sometimes the app will push you one way, usually in demand of SQL. But sometimes end goals will push you another way: NoSQL scales bigger, faster.

Finally, keep in mind that ML assists are better than flogging the data on your own. ML support is noted in the reviews as well.

## Featured Database-as-a-Service Solutions Reviews:

### [Microsoft Azure SQL Database Review](https://uk.pcmag.com/microsoft-azure-sql-database/116530/review/microsoft-azure-sql-database) ⭐️ ⭐️ ⭐️ ⭐️ ⭐️

**Pros:** Feature-rich. Easy to use. A large number of regions for more GDPR-compliance options. No app breakage in transfers. Machine learning-based auto-tuning capability. Can use older SQL applications dating back to 2005.

**Cons:** Suitable for structured data only because the database is SQL. Great for complex queries but unsuitable for messy, human communication data.

**Bottom Line:** Microsoft Azure SQL Database is an excellent Database-as-a-Service (DBaaS) solution for developers, business analysts, and database administrators given its ease of use and exemplary controls.

[Read Review](https://uk.pcmag.com/microsoft-azure-sql-database/116530/review/microsoft-azure-sql-database)

### [MongoDB Atlas Review](https://uk.pcmag.com/mongodb-atlas/116531/review/mongodb-atlas) ⭐️ ⭐️ ⭐️ ⭐️ ⭐️

**Pros:** Easy to use. Open source with powerful scaling, sharding, serverless, and machine learning capabilities.

**Cons:** It's NoSQL so it's unsuitable for complex queries or projects requiring HIPAA compliance. Some applications require SQL databases to function, which eliminates NoSQL databases from consideration.

**Bottom Line:** MongoDB Atlas is a developer's dream database, with a brilliantly simple user interface, more automation than most Database-as-a-Service (DBaaS) solutions, tons of flexibility and controls, built-in replication, and zero lock-in.

[Read Review](https://uk.pcmag.com/mongodb-atlas/116531/review/mongodb-atlas)

### [Amazon Relational Database Service Review](https://uk.pcmag.com/amazon-relational-database-service/116529/review/amazon-relational-database-service) ⭐️ ⭐️ ⭐️ ⭐ ️

**Pros:** Stable and powerful. Provides users with plenty of controls. Very security conscious.

**Cons:** Complex to set up and move data. Requires help from a database administrator and a network professional for setup. Expensive.

**Bottom Line:** Amazon Relational Database Service isn't a newbie-friendly Database-as-a-Service (DBaaS) solution, but with the right professionals helping you out, it's a great relational database service.

[Read Review](https://uk.pcmag.com/amazon-relational-database-service/116529/review/amazon-relational-database-service)

### [Google BigQuery Review](https://uk.pcmag.com/google-bigquery/116528/review/google-bigquery) ⭐️ ⭐️ ⭐️ ⭐️

**Pros:** Excellent for Big Data projects. Flexible data ingestion. Fast analysis. Integrates well with almost any type of data.

**Cons:** Built for Big Data so it's overkill for small data sets. Confusing SQL dialects. Unwieldy costs without proper attention to tool use and automated scaling. Flat rate pricing works better.

**Bottom Line:** Google BigQuery is a great Database-as-a-Service (DBaaS) solution for cloud native companies and anyone working with machine learning application development or handling massive sets.

[Read Review](https://uk.pcmag.com/google-bigquery/116528/review/google-bigquery)

### [IBM Db2 on Cloud Review](https://uk.pcmag.com/ibm-db2-on-cloud/116532/review/ibm-db2-on-cloud) ⭐️ ⭐️ ⭐️ ⭐️

**Pros:** Incredibly easy data migration and setup. Well designed.

**Cons:** Fewer region options, which may impact your performance and compliance requirements depending on what you're doing with the database.

**Bottom Line:** IBM Db2 on Cloud is a dream Database-as-a-Service (DBaaS) solution for developers and business analysts because they can use it without the assistance of a database administrator, even with minimal skills.

[Read Review](https://uk.pcmag.com/ibm-db2-on-cloud/116532/review/ibm-db2-on-cloud)

### [SAP Cloud Platform Review](https://uk.pcmag.com/sap-cloud-platform/116527/review/sap-cloud-platform) ⭐️ ⭐️ ⭐️

**Pros:** Great for HANA users and Big Data developers. Yes, that means Internet of Things, machine learning, and Java, too.

**Cons:** Having two different developer environments is confusing and potentially restrictive.

**Bottom Line:** SAP Cloud Platform needs to mature, but it's still a powerful and unique Database-as-a-Service (DBaaS) solution with many important capabilities.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
