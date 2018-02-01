> * 原文地址：[Contributing to Django Framework is easier than you think](https://www.vinta.com.br/blog/2017/contributing-hugh-lib/?hmsr=pycourses.com&utm_source=pycourses.com&utm_medium=pycourses.com)
> * 原文作者：[Anderson Resende](https://www.vinta.com.br/blog/author/andersonresende/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/contributing-hugh-lib.md](https://github.com/xitu/gold-miner/blob/master/TODO/contributing-hugh-lib.md)
> * 译者：
> * 校对者：

# Contributing to Django Framework is easier than you think

For those who are starting to code and wish to make open source, sometimes it is hard to start. The idea of contributing with that fancy and wonderful lib that you love can sound a little bit scary. Lucky for us many of those libs have room for whoever is willing to start. They also give us the support that we need. Pretty sweet, right?

Do you know that famous python framework? [Django](https://www.djangoproject.com/)! There is one section on their website called [Easy Pickings](https://code.djangoproject.com/query?status=!closed&easy=1). It was made for you who is willing both to get started with Open Source and to contribute with an amazing lib!

In this blog post I will show you step-by-step how I got started contributing the to open source by fixing a **Django easy pick** issue and how you can do the same in few steps. I will use a bug fixed by me to explain everything from the beginning to the end. Bear with me!

## Finding a fix/bug

The first thing that you need to do is to visit the Django section [Easy pickings](https://code.djangoproject.com/query?status=!closed&easy=1). There you can find tickets that are easy to fix and small bugs. Every day new tickets are posted there. Try to find a ticket that is not assigned to anybody. Look at the image below: 

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/d7/a3/d7a34921-1f76-49f3-89e0-e0d35c0d552c/easy_pickings_search.png)

In my case I choose that [bug ticket #26026](https://code.djangoproject.com/ticket/26026) and assigned it to myself, let's take a deeper look into the issue. In the image below I am just showing the header of the ticket. Please read the complete ticket.

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/25/92/2592c87c-c1e0-4a32-b8d5-97e35df7dcd6/easy_bug_card.png)

As I have told you before, I have already solved this bug. So I am assigned to it, the bug is closed and there are some related PRs. When you choose a bug don't forget to assign the bug to yourself. This will prevent other people from picking the bug to work with. You need to be logged on the Django site, there are links on the top of the ticket page for that.

If you opened the ticket you will probably have noticed some discussions where the people suggested some solutions and made comments about the problem. People in the community are normally very helpful.

Ok! We've found and understood an open ticket.

## Let's code

The first step is to fork the [Django repo](https://github.com/django/django). Second, write your code and make a commit following the style suggested by [Django's guidelines](https://docs.djangoproject.com/en/1.10/internals/contributing/committing-code/#committing-guidelines). Take a look at my commit name: _[1.9.x] Fixed #26026 -- Checked if the QuerySet is empty_. So you can finally make a pull request.

Let's take a look at my pull request and check the code I wrote. Note that I commented the PR with a link to the ticket it covers.

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/03/35/03350a59-e487-4d51-bcee-01a86e5c9bed/unmerged_pr.png)

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/c3/c8/c3c817a7-bef7-4fda-96ea-12f01d016847/unmerged_pr_code.png)

Simple, don't you think? That was my solution, just one line of code. But check bellow the answer I got:

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/d0/78/d07800d2-d0a4-42db-a285-a011eb4744f9/unmerge_pr_comment.png)

Uhumm... The problem was that I made a pull request to the wrong version of Django. Also, I forgot to write tests to my fix. Let's fix that!

This is my second PR, now against master and with tests alongside my code that I had already written. Notice that the name of my commit has changed (Is the same name of my PR).

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/0d/fc/0dfcc5a4-dd68-4c39-b7ea-151c44933799/merged_commit_pr.png)

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/3c/1b/3c1b3d9c-f8fc-4a3a-a393-2e6fa8af52d5/merged_pr_code.png)

Done! My PR was merged and closed. I have contributed to the amazing Django!

![Alt text](https://vinta-cms.s3.amazonaws.com/media/filer_public/fb/08/fb08867f-2c67-4bed-a7ee-d66839d92cae/dead.gif)

**More from Vinta**

- [**Controlling access: a Django permission apps comparison**](https://www.vinta.com.br/blog/2016/controlling-access-a-django-permission-apps-comparison/)
- [**Python API clients with Tapioca**](https://www.vinta.com.br/blog/2016/python-api-clients-with-tapioca/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
