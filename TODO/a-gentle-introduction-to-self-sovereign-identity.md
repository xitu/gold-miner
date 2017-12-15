> * 原文地址：[A gentle introduction to self-sovereign identity](https://bitsonblocks.net/2017/05/17/a-gentle-introduction-to-self-sovereign-identity/)
> * 原文作者：[antonylewis2015](https://bitsonblocks.net/author/antonylewis2015/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-gentle-introduction-to-self-sovereign-identity.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-gentle-introduction-to-self-sovereign-identity.md)
> * 译者：
> * 校对者：

# A gentle introduction to self-sovereign identity

![](https://bitsonblocks.files.wordpress.com/2017/05/self_sovereign_identity_platform.png?w=594&h=434&crop=1)

In May 2017, the Indian [Centre for Internet and Society](http://cis-india.org/) think tank published a [report](http://cis-india.org/internet-governance/information-security-practices-of-aadhaar-or-lack-thereof-a-documentation-of-public-availability-of-aadhaar-numbers-with-sensitive-personal-financial-information-1) detailing the ways in which India’s national identity database ([Aadhaar](https://uidai.gov.in/)) is leaking potentially compromising personal information. The information relates to over 130 million Indian nationals. The leaks create a great opportunity for financial fraud, and cause irreversible harm to the privacy of the individuals concerned.

It is clear that the central identity repository model has deficiencies. This post describes a new paradigm for managing our digital identities: self-sovereign identity.

Self-sovereign identity is the concept that people and businesses can store their own identity data on their own devices, and provide it efficiently to those who need to validate it, without relying on a central repository of identity data. It’s a digital way of doing what we do today with bits of paper. This has benefits compared with both current manual processes and central repositories such as India’s Aadhaar.

Efficient identification processes promote financial inclusion. By lowering the cost to banks of opening accounts for small businesses, financing becomes profitable for the banks and therefore accessible for the small businesses.

### What are important concepts in identity?

There are three parts to identity: **claims**, **proofs**, and **attestations**.

#### Claims

An identity **claim** is an assertion made by the person or business:

> “My name is Antony and my date of birth is 1 Jan 1901”

![claim](https://bitsonblocks.files.wordpress.com/2017/05/claim.png?w=594)

#### Proofs

A **proof** is some form of document that provides evidence for the claim. Proofs come in all sorts of formats. Usually for individuals it’s photocopies of passports, birth certificates, and utility bills. For companies it’s a bundle of incorporation and ownership structure documents.

![proofs](https://bitsonblocks.files.wordpress.com/2017/05/proofs.png?w=594)

#### Attestations

An **attestation** is when a third party validates that according to their records, the claims are true. For example a University may attest to the fact that someone studied there and earned a degree. An attestation from the right authority is more robust than a proof, which may be forged. However, attestations are a burden on the authority as the information can be sensitive. This means that the information needs to be maintained so that only specific people can access it.

![attestation](https://bitsonblocks.files.wordpress.com/2017/05/attestation.png?w=594)

### What’s the identity problem?

Banks need to understand their new customers and business clients to check eligibility, and to prove to regulators that they (the banks) are not banking baddies. They also need keep the information they have on their clients up to date.

The problems are:

* Proofs are usually **unstructured data**, taking the form of images and photocopies. This means that someone in the bank has to manually read and scan the documents to extract the relevant data to type into a system for storage and processing.
* When the **data changes** in real life (such as a change of address, or a change in a company’s ownership structure), the customer is obliged to tell the various financial service providers they have relationships with.
* Some forms of proof (eg photocopies of original documents) can be **easily faked**, meaning extra steps to prove authenticity need to be taken, such as having photocopies notarised, leading to extra friction and expense.

This results in expensive, time-consuming and troublesome processes that annoy everyone.

![kyc_current_process](https://bitsonblocks.files.wordpress.com/2017/05/kyc_current_process.png?w=594)

### What are the technical improvements?

Whatever style of overall solution is used, the three problems outlined above need to be solved technically. A combination of standards and digital signatures works well.

The technical solution for **improving on unstructured data** is for data to be stored and transported in a machine-readable structured format, ie **text in boxes with standard labels**.

The technical solution for **managing changes in data** is a common method used to update all the necessary entities. This means using **APIs** to connect, authenticate yourself (proving it’s your account), and update details.

The technical solution for **proving authenticity of identity proofs** is **digitally signed attestations**, possibly time-bound. A digitally signed proof is as good as an attestation because the digital signature cannot be forged. Digital signatures have two properties that make them inherently better than paper documents:

1. Digital signatures become invalid if there are any changes to the signed document. In other words, they guarantee the integrity of the document.
2. Digital signatures cannot be ‘lifted’ and copied from one document to another.

### What’s the centralised solution?

A common solution for identity management is a central repository. A third party owns and controls a repository of many people’s identities. The customer enters their facts into the system, and uploads supporting evidence. Whoever needs this can access this data (with permission from the client of course), and can systematically suck this data into their own systems. If details change, the customer updates it once, and can push the change to the connected banks.

![centralised_identity_solutions](https://bitsonblocks.files.wordpress.com/2017/05/centralised_identity_solutions.png?w=594)

This sounds wonderful, and it certainly offers some benefits. But there are problems with this model.

### What are the problems with centralised solutions?

#### 1. Toxic data

Being in charge of this identity repository is a double-edged sword. On the one hand, an operator can make money, by charging for a convenient utility. On the other hand, this data is a liability to the operator: A central-identity system is a goldmine for hackers, and a cybersecurity headache for the operator.

If a hacker can get into the systems and copy the data, they can sell the digital identities and their documentary evidence to other baddies. These baddies can then steal the identities and commit fraud and crimes while using the names of the innocent. This can and does wreck the lives of the innocent, and creates a significant liability for the operator.

#### 2. Jurisdictional politics

Regulators want personal data to be stored within the geographical boundaries of the jurisdiction under their control. So it can be difficult to create international identity repositories because there is always the argument about which country to warehouse the data and who can access it, from where.

#### 3. Monopolistic tendencies

This isn’t a problem for the central repository operators, but it’s a problem for the users. If a utility operator gains enough traction, network effects lead to more users. The utility operator can become a quasi-monopoly. Operators of monopolistic functions tend to become resistant to change; they overcharge and don’t innovate due to a lack of competitive pressure. This is wonderful for the operator, but is at the expense of the users.

### What’s the decentralised answer?

#### Is it a blockchain?

A blockchain is a type of distributed ledger where all data is replicated to all participants in real time. Should identity data be stored on a blockchain that is managed by a number of participating entities (say, the bigger banks)? No:

1. Replicating all identity data to all parties breaks all kinds of regulations about keeping personal data onshore within a jurisdiction; only storing personal data that is relevant to the business; and only storing data that the customer has consented to.
2. The cybersecurity risk is increased. If one central data store is difficult enough to secure, now you’re replicating this data to multiple parties, each with their own cybersecurity practices and gaps. This makes it easier for an attacker to steal the data.

What if the identity data were encrypted?

1. Encrypted personal data can still fall foul of personal data regulations.
2. Why would the parties (eg banks) store and manage a bunch of identity data that they can’t see or use? What’s the upside?

### So what’s the answer?

The emerging answer is “**self-sovereign identity**“. This digital concept is very similar to the way we keep our non-digital identities today.

Today, we keep passports, birth certificates, utility bills at home under our own control, maybe in an “important drawer”, and we share them when needed. We don’t store these bits of paper with a third party. Self-sovereign identity is the digital equivalent of what we do with bits of paper now.

### How would self-sovereign identity work for the user?

You would have an app on a smartphone or computer, some sort of “identity wallet” where identity data would be stored on the hard drive of your device, maybe backed up on another device or on a personal backup solution, but **crucially** not stored in a central repository.

Your identity wallet would start off **empty** with only a **self-generated identification number** derived from public key, and a corresponding private key (like a password, used to create digital signatures). This keypair differs from a username and password because it is created by the user by “rolling dice and doing some maths” rather than by requesting a username/password combination from a third party.

At this stage, **no one else in the world** knows about this identification number. No one issued it to you. You created it yourself. It is self-sovereign. The laws of big numbers and randomness ensure that no one else will generate the same identification number as you.

You then use this **identification number**, along with your **identity claims**, and get **attestations** from relevant authorities.

You can then use these attested claims as your identity information.

![self_sovereign_identity_public_key_model](https://bitsonblocks.files.wordpress.com/2017/05/self_sovereign_identity_public_key_model.png?w=594)

**Claims** would be stored by typing text into standardised text fields, and saving photos or scans of documents.

**Proofs** would be stored by saving scans or photos of proof documents. However this would be for backward compatibility, because digitally signed attestations remove the need for proofs as we know them today.

**Attestations** – and here’s the neat bit – would be stored in this wallet too. These would be machine readable, digitally signed pieces of information, valid within certain time windows. The relevant authority would need to sign these with digital signatures – for example, passport agencies, hospitals, driving licence authorities, police, etc.

**Need to know, but not more:** Authorities could provide “bundles” of attested claims, such as “over 18”, “over 21”, “accredited investor”, “can drive cars” etc, for the user to use as they see fit. The identity owner would be able to choose which piece of information to pass to any requester. For example, if you need to prove you are over 18, you don’t need to share your date of birth, you just need a statement saying you are over 18, signed by the relevant authority.

![attestation_over18](https://bitsonblocks.files.wordpress.com/2017/05/attestation_over18.png?w=594)

Sharing this kind of data is **safer both for the identity provider and the recipient**. The provider doesn’t need to overshare, and the recipient doesn’t need to store unnecessarily sensitive data – for example, if the recipient gets hacked, they are only storing “Over 18” flags, not dates of birth.

Even banks themselves could attest to the person having an account with them. We would first need to understand what liability they take on when they create these attestations. I would assume it would be no more than the liability they currently take on when they send you a bank statement, which you use as a proof of address elsewhere.

#### Data sharing

Data would be stored on the person’s device (as pieces of paper are currently stored at home today), and then when requested, the person would approve a third party to collect specific data, by tapping a notification on their device, We already have something similar to this – if you have ever used a service by “linking” your Facebook or LinkedIn account, this is similar – but instead of going to Facebook’s servers to collect your personal data, it requests it from your phone, and you have granular control over what data is shared.

![self_sovereign_identity_platform](https://bitsonblocks.files.wordpress.com/2017/05/self_sovereign_identity_platform.png?w=594)

### Conclusion – and distributed ledgers

Who would orchestrate this? Well perhaps this is where a distributed ledger may come in. The software, the network, and the workflow dance would need to be built, run, and maintained. Digital signatures require public and private keys that need to be managed, and certificates need to be issued, revoked, refreshed. Identity data isn’t static, it needs to evolve, according to some business logic.

**A non-blockchain distributed ledger would be an ideal platform for this.** R3’s Corda (Note: I work at R3) already has many of the necessary elements – coordinated workflow, digital signatures, rules about data evolution, and a consortium of over 80 financial institutions experimenting with this exact self-sovereign identity concept.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
