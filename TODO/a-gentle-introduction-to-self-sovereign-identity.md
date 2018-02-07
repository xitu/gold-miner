> * 原文地址：[A gentle introduction to self-sovereign identity](https://bitsonblocks.net/2017/05/17/a-gentle-introduction-to-self-sovereign-identity/)
> * 原文作者：[antonylewis2015](https://bitsonblocks.net/author/antonylewis2015/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-gentle-introduction-to-self-sovereign-identity.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-gentle-introduction-to-self-sovereign-identity.md)
> * 译者：foxxnuaa
> * 校对者：

# A gentle introduction to self-sovereign identity
自主权身份简介

![](https://bitsonblocks.files.wordpress.com/2017/05/self_sovereign_identity_platform.png?w=594&h=434&crop=1)

In May 2017, the Indian [Centre for Internet and Society](http://cis-india.org/) think tank published a [report](http://cis-india.org/internet-governance/information-security-practices-of-aadhaar-or-lack-thereof-a-documentation-of-public-availability-of-aadhaar-numbers-with-sensitive-personal-financial-information-1) detailing the ways in which India’s national identity database ([Aadhaar](https://uidai.gov.in/)) is leaking potentially compromising personal information. The information relates to over 130 million Indian nationals. The leaks create a great opportunity for financial fraud, and cause irreversible harm to the privacy of the individuals concerned.

2017 年 5 月，印度互联网与社会智库中心(http://cis-india.org/)发布了一份报告(http://cis-india.org/internet-governance/information-security-practices-of-aadhaar-or-lack-thereof-a-documentation-of-public-availability-of-aadhaar-numbers-with-sensitive-personal-financial-information-1)，详细介绍了印度国家身份数据库（ Adahaar（https://uidai.gov.in/））泄漏可能危及个人信息的方式。这些信息涉及 1.3 亿印度国民。信息泄漏给金融诈骗创造了机会，同时对个人隐私造成不可挽回的伤害。

It is clear that the central identity repository model has deficiencies. This post describes a new paradigm for managing our digital identities: self-sovereign identity.

很明显，中心化身份存储模型存在缺陷。本文描述了一种管理数字身份的新方式：自主权身份。

Self-sovereign identity is the concept that people and businesses can store their own identity data on their own devices, and provide it efficiently to those who need to validate it, without relying on a central repository of identity data. It’s a digital way of doing what we do today with bits of paper. This has benefits compared with both current manual processes and central repositories such as India’s Aadhaar.

自主权身份的含义是人们和企业将自己的身份数据存储在自己的设备上，并能有效地提供给需要的人进行验证，而不用依赖中心化的身份数据存储。相对如今的纸质处理方式，自主权身份是一种数字化方式。与手动处理和中心化存储如印度的 Aadhaar 相比，自主权身份更有益。

Efficient identification processes promote financial inclusion. By lowering the cost to banks of opening accounts for small businesses, financing becomes profitable for the banks and therefore accessible for the small businesses.
高效地识别过程能够促进普惠金融。通过降低小企业开设银行账户的成本，融资对银行更加有利，小企业便可以获得融资。

### What are important concepts in identity?
### 身份中的重要概念？
There are three parts to identity: **claims**, **proofs**, and **attestations**.
身份包含三个部分：声明、证明和认证。

#### Claims
#### 声明

An identity **claim** is an assertion made by the person or business:
身份声明是由个人或企业发起的：

> “My name is Antony and my date of birth is 1 Jan 1901”
> “我是 Antony ，出生于 1901 年 1 月 1 日”

![claim](https://bitsonblocks.files.wordpress.com/2017/05/claim.png?w=594)

#### Proofs
#### 证明

A **proof** is some form of document that provides evidence for the claim. Proofs come in all sorts of formats. Usually for individuals it’s photocopies of passports, birth certificates, and utility bills. For companies it’s a bundle of incorporation and ownership structure documents.
证明是某种形式的文件，为声明提供证据。证明有各种格式。通常情况下，个人证明是护照、出生证和账单的复印件。对于公司来说，它是大量的公司和所有权结构文件。


![proofs](https://bitsonblocks.files.wordpress.com/2017/05/proofs.png?w=594)

#### Attestations
#### 认证

An **attestation** is when a third party validates that according to their records, the claims are true. For example a University may attest to the fact that someone studied there and earned a degree. An attestation from the right authority is more robust than a proof, which may be forged. However, attestations are a burden on the authority as the information can be sensitive. This means that the information needs to be maintained so that only specific people can access it.
认证是第三方根据他们的记录验证声明是真实的。例如，一所大学可以证明有人在那里学习过并取得学位。来自权威机构的认证比伪造的证据更加有力。但是，由于信息是敏感的，认证对于权威机构来说是一个负担。认证意味着信息需要保持，且只有特定的人才能访问。


![attestation](https://bitsonblocks.files.wordpress.com/2017/05/attestation.png?w=594)

### What’s the identity problem?
### 身份的问题是什么？

Banks need to understand their new customers and business clients to check eligibility, and to prove to regulators that they (the banks) are not banking baddies. They also need keep the information they have on their clients up to date.
银行需要了解他们的新客户和商业客户以便检查资格，并向监管机构证明他们（银行）不是银行坏账。他们也需要保持客户的信息是最新的。

The problems are:
问题在于：

* Proofs are usually **unstructured data**, taking the form of images and photocopies. This means that someone in the bank has to manually read and scan the documents to extract the relevant data to type into a system for storage and processing.
* 证明通常是图片和复印件形式的非结构化数据。这意味着银行工作人员必须手动读取和扫描文档以提取相关数据，然后输入系统进行存储和处理。
* When the **data changes** in real life (such as a change of address, or a change in a company’s ownership structure), the customer is obliged to tell the various financial service providers they have relationships with.
* 当数据在现实生活中发生变化时（如地址变更、公司所有权结构变更），客户有义务通知与他们有关系的各种金融服务提供商。
* Some forms of proof (eg photocopies of original documents) can be **easily faked**, meaning extra steps to prove authenticity need to be taken, such as having photocopies notarised, leading to extra friction and expense.
* 某些形式的证据（如原始文件的复印件）容易被伪造，这就需要采取额外的步骤来证明真实性，如经过公证的复印件，从而导致其他的矛盾和费用。

This results in expensive, time-consuming and troublesome processes that annoy everyone.
结果是昂贵、耗时且麻烦的过程，使每个人都感到烦恼。

![kyc_current_process](https://bitsonblocks.files.wordpress.com/2017/05/kyc_current_process.png?w=594)

### What are the technical improvements?
### 技术上有哪些改进？

Whatever style of overall solution is used, the three problems outlined above need to be solved technically. A combination of standards and digital signatures works well.
无论采用什么样的整体解决方案，上述三个问题都需要在技术上解决。标准化和数字签名结合运作良好。

The technical solution for **improving on unstructured data** is for data to be stored and transported in a machine-readable structured format, ie **text in boxes with standard labels**.
改进非结构化数据的技术解决方案是将数据以机器可读的结构化格式进行存储和传输，即将文本存储在标准化的标签中。

The technical solution for **managing changes in data** is a common method used to update all the necessary entities. This means using **APIs** to connect, authenticate yourself (proving it’s your account), and update details.
管理数据变化的技术解决方案是更新所有必要实体的通用方法。即使用 APIs 连接、验证自身（证明是您的账户）、更新详细信息。

The technical solution for **proving authenticity of identity proofs** is **digitally signed attestations**, possibly time-bound. A digitally signed proof is as good as an attestation because the digital signature cannot be forged. Digital signatures have two properties that make them inherently better than paper documents:
证明身份真实性的技术解决方案是数字签名认证，可能有时间限制。数字签名证明与认证一样有效，因为数字签名不能伪造。数字签名有如下两个属性，使其本质上比纸质文档更好：

1. Digital signatures become invalid if there are any changes to the signed document. In other words, they guarantee the integrity of the document.
1、如果签名文档发生任何更改，数字签名将失效。换句话说，它保证文件的完整性。
2. Digital signatures cannot be ‘lifted’ and copied from one document to another.
2、数字签名不能被取消，并从一个文档复制到另一个文档。

### What’s the centralised solution?
### 什么是集中化解决方案？

A common solution for identity management is a central repository. A third party owns and controls a repository of many people’s identities. The customer enters their facts into the system, and uploads supporting evidence. Whoever needs this can access this data (with permission from the client of course), and can systematically suck this data into their own systems. If details change, the customer updates it once, and can push the change to the connected banks.
身份管理的常见解决方案是中心化存储。第三方拥有和控制许多人身份的存储。客户将自身信息录入到系统，并上传证据。无论谁需要，都可以访问这些数据（当然得有客户的许可），并可以系统地将这些数据存储到自己的系统中。如果细节发生变化，客户会更新一次，并将更新推送给相关的银行。

![centralised_identity_solutions](https://bitsonblocks.files.wordpress.com/2017/05/centralised_identity_solutions.png?w=594)

This sounds wonderful, and it certainly offers some benefits. But there are problems with this model.
这听起来不错，当然也有一些好处。但是这个模型有些问题。

### What are the problems with centralised solutions?
### 中心化解决方案有什么问题？

#### 1. Toxic data
#### 1、有毒数据

Being in charge of this identity repository is a double-edged sword. On the one hand, an operator can make money, by charging for a convenient utility. On the other hand, this data is a liability to the operator: A central-identity system is a goldmine for hackers, and a cybersecurity headache for the operator.
运营身份存储是一把双刃剑。一方面，运营商可以通过对工具收费来赚钱。另一方面，数据对运营商是不利的：对于黑客来说，集中化的身份系统是一座金矿；而对于运营商，网络安全很是头痛。

If a hacker can get into the systems and copy the data, they can sell the digital identities and their documentary evidence to other baddies. These baddies can then steal the identities and commit fraud and crimes while using the names of the innocent. This can and does wreck the lives of the innocent, and creates a significant liability for the operator.
如果黑客可以进入系统并拷贝数据，他们可以将数字身份和书面证据出售给其他坏人。这些坏人就可以以无辜者的名义窃取身份、欺诈和犯罪。这样会而且确实破坏了无辜者的生活，并给运营商造成重大的不利。

#### 2. Jurisdictional politics
#### 2、司法政治

Regulators want personal data to be stored within the geographical boundaries of the jurisdiction under their control. So it can be difficult to create international identity repositories because there is always the argument about which country to warehouse the data and who can access it, from where.
监管机构希望将个人数据存储在其管辖下的地理范围内。因此，创建国际身份存储库是很困难的，因为总是有关于哪个国家存储数据和谁可以访问数据的争论。

#### 3. Monopolistic tendencies
#### 3、垄断倾向

This isn’t a problem for the central repository operators, but it’s a problem for the users. If a utility operator gains enough traction, network effects lead to more users. The utility operator can become a quasi-monopoly. Operators of monopolistic functions tend to become resistant to change; they overcharge and don’t innovate due to a lack of competitive pressure. This is wonderful for the operator, but is at the expense of the users.
对于中心化存储库运营商来说，这不是问题，但对于用户来说是一个问题。如果一个公用事业运营商获得足够的关注，网络效应会吸引更多的用户。公用事业运营商可能成为准垄断企业。垄断性运营商往往对变革产生抵触；由于缺乏竞争力，他们会过度收费和乏于创新。这对于运营商是有利的，但是却损害了用户的利益。

### What’s the decentralised answer?
### 去中心化的解决方案是什么？

#### Is it a blockchain?
#### 是区块链吗？

A blockchain is a type of distributed ledger where all data is replicated to all participants in real time. Should identity data be stored on a blockchain that is managed by a number of participating entities (say, the bigger banks)? No:
区块链是一种分布式账簿，所有数据都可以实时复制到所有参与者。是否应该将身份数据存储在多个参与实体（比如大银行）管理的区块链中?不:


1. Replicating all identity data to all parties breaks all kinds of regulations about keeping personal data onshore within a jurisdiction; only storing personal data that is relevant to the business; and only storing data that the customer has consented to.
1、将所有身份数据复制到所有各方，打破了关于将个人数据保存在管辖范围内的所有规定;只储存与业务有关的个人资料;并且只存储客户授权的数据。
2. The cybersecurity risk is increased. If one central data store is difficult enough to secure, now you’re replicating this data to multiple parties, each with their own cybersecurity practices and gaps. This makes it easier for an attacker to steal the data.
2、网络安全风险增加。如果中心化数据存储很难保证安全，那么现在您正在将这些数据复制到多个参与方，每个参与方都有自己的网络安全实践和漏洞。这使得攻击者更容易窃取数据。

What if the identity data were encrypted?
如果加密身份数据会怎样？

1. Encrypted personal data can still fall foul of personal data regulations.
1、加密个人数据仍可能违反个人数据规定。
2. Why would the parties (eg banks) store and manage a bunch of identity data that they can’t see or use? What’s the upside?
2、为什么各方(如银行)会存储和管理一些他们看不到或不使用的身份数据?积极的一面是什么?
### So what’s the answer?
### 那么解决方案究竟是什么？

The emerging answer is “**self-sovereign identity**“. This digital concept is very similar to the way we keep our non-digital identities today
最新的解决方案是自主权身份。这个数字概念与我们今天保持非数字身份的方式非常相似。

Today, we keep passports, birth certificates, utility bills at home under our own control, maybe in an “important drawer”, and we share them when needed. We don’t store these bits of paper with a third party. Self-sovereign identity is the digital equivalent of what we do with bits of paper now.
今天，我们自己保管护照、出生证明、家用水电费账单等，也许把他们放在一个“重要的抽屉”里，并且在需要的时候才拿出来。我们将这些纸质文件和其他东西分开存放。自主权身份等同于我们现在使用的纸质文件的数字等价物。

### How would self-sovereign identity work for the user?
### 如何对用户进行自主权身份识别？

You would have an app on a smartphone or computer, some sort of “identity wallet” where identity data would be stored on the hard drive of your device, maybe backed up on another device or on a personal backup solution, but **crucially** not stored in a central repository.
你会在智能手机或电脑上安装一个应用程序，类似于某种”身份钱包“，将身份数据存储在设备硬件上，可能备份在另一个设备上或个人备份解决方案上，但关键是不存储在中心化存储库中。

Your identity wallet would start off **empty** with only a **self-generated identification number** derived from public key, and a corresponding private key (like a password, used to create digital signatures). This keypair differs from a username and password because it is created by the user by “rolling dice and doing some maths” rather than by requesting a username/password combination from a third party.
身份钱包一开始是空的，只有一个根据公钥生成的识别号码以及相应的私钥(类似密码，用于创建数字签名)。这个密钥对不同于用户名和密码，因为它是由用户通过"随机和数学运算"创建的，而不是由第三方请求用户名/密码产生的。

At this stage, **no one else in the world** knows about this identification number. No one issued it to you. You created it yourself. It is self-sovereign. The laws of big numbers and randomness ensure that no one else will generate the same identification number as you.
现阶段，没有人知道这个识别号码。没有人发给你。你自己创建了它。这就是自主权。大数法则和随机数法则确保没有人会产生和你一样的识别号码。

You then use this **identification number**, along with your **identity claims**, and get **attestations** from relevant authorities.
然后你可以使用这个识别号码，连同身份声明一起，从相关部门得到认证。

You can then use these attested claims as your identity information.
你就可以使用这些证明作为你的身份信息。

![self_sovereign_identity_public_key_model](https://bitsonblocks.files.wordpress.com/2017/05/self_sovereign_identity_public_key_model.png?w=594)

**Claims** would be stored by typing text into standardised text fields, and saving photos or scans of documents.
声明会被输入到标准化文本中存储，并保存照片或扫描文档。

**Proofs** would be stored by saving scans or photos of proof documents. However this would be for backward compatibility, because digitally signed attestations remove the need for proofs as we know them today.
证明会通过保存扫描或者证明文件的照片来存储。 然而，这只是为了向后兼容，因为数字签名认证消除了我们今天所知道的证明的需要。

**Attestations** – and here’s the neat bit – would be stored in this wallet too. These would be machine readable, digitally signed pieces of information, valid within certain time windows. The relevant authority would need to sign these with digital signatures – for example, passport agencies, hospitals, driving licence authorities, police, etc.
认证 - 即有效部分，也会存储在这个钱包里。它是机器可读的，数字签名的一些信息片段，在一定时间段内有效。官方如护照机构、医院、驾照机构、警察局等需要签署这些数字签名。

**Need to know, but not more:** Authorities could provide “bundles” of attested claims, such as “over 18”, “over 21”, “accredited investor”, “can drive cars” etc, for the user to use as they see fit. The identity owner would be able to choose which piece of information to pass to any requester. For example, if you need to prove you are over 18, you don’t need to share your date of birth, you just need a statement saying you are over 18, signed by the relevant authority.
需要了解，但无需更多：官方可以提供“超过18”、“超过21”、“合格投资者”、“可驾驶汽车”等证明文件，供用户使用。身份所有者能够选择将哪些信息传递给请求者。例如，如果你需要证明你已经超过18岁，你不需要分享你的出生日期，你只需要一个声明说你已经超过18岁，该声明由相关部门签署。

![attestation_over18](https://bitsonblocks.files.wordpress.com/2017/05/attestation_over18.png?w=594)

Sharing this kind of data is **safer both for the identity provider and the recipient**. The provider doesn’t need to overshare, and the recipient doesn’t need to store unnecessarily sensitive data – for example, if the recipient gets hacked, they are only storing “Over 18” flags, not dates of birth.
共享这类数据对于身份提供者和接收者来说都更安全。提供者不需要过度共享，而接收者不需要存储不必要的敏感数据 —— 例如，如果接收者被入侵，他们只存储“超过18岁”的标志，而不是出生日期。

Even banks themselves could attest to the person having an account with them. We would first need to understand what liability they take on when they create these attestations. I would assume it would be no more than the liability they currently take on when they send you a bank statement, which you use as a proof of address elsewhere.
即使银行本身也可以证明哪些人在银行有账户。我们首先需要了解他们在创建这些认证时所承担的责任。我认为，当他们寄给你一张银行账单时，它不会比他们目前承担的责任更大，而你只是把它作为在其他地方的地址证明。

#### Data sharing
#### 数据共享

Data would be stored on the person’s device (as pieces of paper are currently stored at home today), and then when requested, the person would approve a third party to collect specific data, by tapping a notification on their device, We already have something similar to this – if you have ever used a service by “linking” your Facebook or LinkedIn account, this is similar – but instead of going to Facebook’s servers to collect your personal data, it requests it from your phone, and you have granular control over what data is shared.
数据将存储在个人设备上(如同今天将纸质文件存储在家里），且在需要时，个人通过打开设备上的通知同意第三方收集特定数据。我们已经有一些类似的——如果你曾使用过“连接”你的 Facebook 或 LinkedIn 账户服务，这是相似的——但是，不是去 Facebook 服务器收集你的个人数据，而是从你的手机中请求它，同时你对共享的数据有粒度控制。

![self_sovereign_identity_platform](https://bitsonblocks.files.wordpress.com/2017/05/self_sovereign_identity_platform.png?w=594)

### Conclusion – and distributed ledgers
### 总结 - 分布式账本

Who would orchestrate this? Well perhaps this is where a distributed ledger may come in. The software, the network, and the workflow dance would need to be built, run, and maintained. Digital signatures require public and private keys that need to be managed, and certificates need to be issued, revoked, refreshed. Identity data isn’t static, it needs to evolve, according to some business logic.
谁来组织这些？也许这就是分布式账本的起源。软件、网络和工作流需要构建、运行和维护。数字签名需要管理公钥和私钥，证书需要颁发、撤销、刷新。身份数据不是静态的，它需要根据某些业务逻辑进行演化。

**A non-blockchain distributed ledger would be an ideal platform for this.** R3’s Corda (Note: I work at R3) already has many of the necessary elements – coordinated workflow, digital signatures, rules about data evolution, and a consortium of over 80 financial institutions experimenting with this exact self-sovereign identity concept.
非区块链分布式账本将是一个理想的平台。R3的Corda(注:我在R3中工作)已经具备了许多必要的元素 —— 协调工作流、数字签名、数据演化规则，以及一个由 80 多个金融机构组成的联盟，他们正在尝试这种精确的自我权身份概念。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
