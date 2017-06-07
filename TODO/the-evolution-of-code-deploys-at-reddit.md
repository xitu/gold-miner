> * 原文地址：[The Evolution of Code Deploys at Reddit](https://redditblog.com/2017/06/02/the-evolution-of-code-deploys-at-reddit/)
> * 原文作者：[Neil Williams & Saurabh Sharma](https://redditblog.com/2017/06/02/the-evolution-of-code-deploys-at-reddit/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# The Evolution of Code Deploys at Reddit

![](https://i2.wp.com/redditupvoted.files.wordpress.com/2017/06/header-1.png)

"It’s important to keep an eye on where you are evolving to so that you keep moving in a useful direction."

**We’re constantly deploying code at Reddit**. Every engineer writes code, gets it reviewed, checks it in, and rolls it out to production regularly. This happens as often as 200 times each week and a deploy usually takes fewer than 10 minutes end-to-end.

The system that powers all of this has evolved over the years. Let’s take a look at how it’s changed (and how it hasn’t) over all that time.

## Where this story starts: consistent and repeatable deploys (2007-2010)

The seed of the current system was a Perl script called *push*. It was written at a time very different from now in Reddit’s history. The entire engineering team was [small enough to fit in one small conference room](https://redditupvoted.files.wordpress.com/2010/03/1dff6-table.jpg). Reddit was not yet on AWS. The site ran on a fixed number of servers, with additional capacity having to be added manually, and was comprised of one large monolithic Python application called r2.

One thing that hasn’t changed over the years is that requests are classified at the load balancer and assigned to specific “pools” of otherwise identical application servers. For example, [listing](https://www.reddit.com/r/rarepuppers/) and [comment](https://www.reddit.com/r/AskReddit/comments/cq1q2/help_reddit_turned_spanish_and_i_cannot_undo_it/) pages are served from separate pools of servers. While any given r2 process could handle any kind of request, individual pools are isolated from spikes of traffic to other pools and can fail independently when they have different dependencies.

![](https://redditupvoted.files.wordpress.com/2017/06/pools.png?w=720&amp;h=331)

The *push* tool had a hard-coded list of servers in it and was built around the monolith’s deploy process. It would iterate through all the application servers, SSH into the machine, run a pre-set sequence of commands to update the copy of code on the server via git, then restart all the application processes. In essence (heavily distilled, not real code):

```
# build the static files and put them on the static server
`make -C /home/reddit/reddit static`
`rsync /home/reddit/reddit/static public:/var/www/`

# iterate through the app servers and update their copy
# of the code, restarting once done.
foreach $h (@hostlist) {
    `git push $h:/home/reddit/reddit master`
    `ssh $h make -C /home/reddit/reddit`
    `ssh $h /bin/restart-reddit.sh`
}
```

The deploy was sequential. It worked its way through servers one by one. As simple as that sounds, this was actually a good thing: it allowed for a form of canary deploy. If you deployed to a few servers and noticed a new exception popping up, you’d know that you introduced a bug and could abort (Ctrl-C) and revert before affecting all requests. Because of the ease of deploys, it was easy to try things out in production and low friction to revert if it didn’t work out. It also meant it was necessary to do only one deploy at a time to ensure that new errors were from *your *deploy and not *that other one* so it was easier to know when and what to revert.

This was all great for ensuring that deploys were consistent and repeatable. It ran pretty quickly. Things were good.

## A bunch of new people (2011)

Then we hired a bunch, growing to six whole engineers, and now fit into a [somewhat larger conference room](https://redditblog.com/2011/07/06/its-time-for-us-to-pack-up-and-move-on-to-bigger-and-better-things/). We started to feel a need for better coordination around deploys, particularly when individuals were working from home. We modified the *push* tool to announce when deploys started and ended via an IRC chatbot. The bot just sat in IRC and announced events. The process for actually doing the deploy looked the same, but now the system did the work for you and told everyone what you were doing.

This was the beginning of us using chat for deployment workflows. There was a lot of talk of systems that managed deploys *from *chat around this time, but since we used third party IRC servers we weren’t able to fully trust the chat room with production control and so it remained a one-way flow of information.

As traffic to the site grew, so did the infrastructure supporting it. We’d occasionally have to launch a new batch of application servers and put them into service. This was still a very manual process, including updating the list of hosts in *push*.

When we added capacity we would usually grow a pool by several servers at a time. The result of this was that iterating through the list of servers sequentially would touch multiple servers in the same pool in quick succession rather than a diverse mix.

![](https://redditupvoted.files.wordpress.com/2017/06/unshuffled.png?w=720&amp;h=104)

We used [uWSGI](https://uwsgi-docs.readthedocs.io/en/latest/) to manage worker processes and so when we told the application to restart it would kill the existing processes and spin up new ones. The new ones took some time to get ready to serve requests and, combined with incidentally targeting a single pool at a time, this would impact the capacity of that pool to serve requests. So we were limited in the rate we could safely deploy to servers. As the list of servers grew, so did the length of the deploys.

## A reworked deploy tool (2012)

We did an overhaul on the deploy tool, written in Python now, confusingly also called *push*. The new version had a few major improvements.

First, it fetched its list of hosts from DNS rather than keeping it hard-coded. This allowed us to update the list of hosts without having to remember to update the deploy tool as well — a rudimentary service discovery system.

To help the issue of sequential restarts, we shuffled the list of hosts before deploying. Because this would mix up the pools of servers, it allowed us to safely roll through at higher speed and so deploy faster.

![](https://redditupvoted.files.wordpress.com/2017/06/shuffled.png?w=720&amp;h=103)

The initial implementation just shuffled randomly each time, but this made it hard to quickly revert code because you wouldn’t deploy to the same first few servers each time. So we amended the shuffle to use a seed that could be re-used on a second deploy when reverting.

Another small but important change was to always deploy a fixed version of the code. The previous version of the tool would update *master*on a given host, but what if *master* changed mid-deploy because someone accidentally pushed up code? By deploying a specific git revision instead of branch name, we ensured that the deploy got the same version everywhere in production.

Finally, the new tool made a distinction between its code (focused on lists of hosts and SSHing into them) and the commands being run. It was still heavily biased by r2’s needs, but it had a proto-API of sorts. This allowed r2 to control its own deploy steps which made it easier to roll out changes to the build and release flow. For example, here’s what might have run on an individual server. The exact commands were hidden but the sequence was still specific to r2’s workflow:

```
sudo /opt/reddit/deploy.py fetch reddit
sudo /opt/reddit/deploy.py deploy reddit f3bbbd66a6
sudo /opt/reddit/deploy.py fetch-names
sudo /opt/reddit/deploy.py restart all
```

That fetch-names thing was very much an r2-only concern!

## The autoscaler (2013)

Then we decided to actually get with the cloud thing and autoscale (a subject for a separate blog post). This allowed us to save a ton of money when the site was less busy and automatically grow to keep up with unexpected demand.

The previous improvements that automatically fetched the hostlist from DNS made this a natural transition. The hostlist changed a lot more often than before, but it was no different to the tool. What started out as a quality of life thing became integral to being able to launch the autoscaler.

However, autoscaling did bring up some interesting edge cases. No free lunches. What happens if a server is launched while a deploy is ongoing? We had to make sure each newly launched server checked in to get new code if present. What about servers going away mid-deploy? The tool had to be made smarter to detect when the server was gone legitimately rather than there being an issue with the deploy process itself that should be noisily alerted on.

Incidentally, we also switched from uWSGI to [Gunicorn](http://gunicorn.org/) around this time for various reasons. This didn’t really make a difference as far as deploys are concerned.

So things carried on.

## Too many servers (2014)

Over time, the number of servers needed to serve peak traffic grew. This meant that deploys took longer and longer. At its worst, a normal deploy took close to an hour. This was not good.

We rewrote the deploy tool to handle hosts in parallel. The new version is called *[rollingpin](https://github.com/reddit/rollingpin)**.* A lot of the time the old tool took was initiating ssh connections and waiting for commands to finish, so parallelizing at a safe amount allowed for faster deploys. This instantly took the deploy time down to 5 minutes again.

![](https://redditupvoted.files.wordpress.com/2017/06/parallel.png?w=720&amp;h=103)

To reduce the impact of restarting multiple servers at once, the deploy tool’s shuffle got smarter. Instead of blindly shuffling the list of servers, it would [interleave pools of servers in a way that maximally separated servers from each pool](https://github.com/reddit/rollingpin/blob/master/rollingpin/utils.py#L94-L110). A much more intentional reduction of impact on the site.

The most important change of the new tool was that the [API between the deploy tool and the tool that lived on each server](https://github.com/reddit/rollingpin/blob/master/example-deploy.py) was much more clearly defined and decoupled from r2’s needs. This was originally done with an eye to being more open source-friendly, but it ended up being very useful shortly after. Here’s an example of a deploy, with the highlighted commands being the API executed remotely.

![](https://redditupvoted.files.wordpress.com/2017/06/rollout.png?w=720)

## Too many people (2015)

Suddenly, it seemed, there were a lot of people working on r2 at once. This was great and meant more deploys. Keeping to the one deploy at a time rule slowly became more difficult with individual engineers having to coordinate verbally about which order they would release code in. To fix this, we added another feature to the chatbot which coordinated a queue of deploys. Engineers would ask for the deploy lock and either get it or get put in the queue. This helped keep order in deploys and let people relax a bit while waiting for the lock.

Another important addition as the team grew was to [track deploys in a central location](https://codeascraft.com/2010/12/08/track-every-release/). We modified the deploy tool to send a metric to Graphite so it was easy to correlate deploys to changes in metrics.

## Two (many) services (2015 also)

And just as suddenly we had a second service coming online. The new mobile version of the website was coming online. It was a completely different stack and had its own servers and build process. This was the first real test of the deploy tool’s decoupled API. With the addition of the ability to do build steps in different locations for each project, it held up and we were able to manage both services under the same system.

## 25 many services (2016)

Over the course of the next year, we saw explosive growth in the Reddit team. We went from those two services to a couple dozen and from two teams to fifteen. The majority of our services are either built on [Baseplate](https://github.com/reddit/baseplate), our backend service framework, or node applications similar to mobile web. The deploy infrastructure is common to all of them and more are coming online soon because *rollingpin* doesn’t care what it’s deploying. This makes it easy to spin up new services with tools that people are familiar with.

## The safety net (2017)

With the increased number of servers dedicated to the monolith, the deploy time grew. We wanted to deploy with a high parallel count but doing so would have caused too many simultaneous restarts to the app servers. Hence, we were below capacity and unable to serve incoming requests, overloading other app servers.

Gunicorn’s main process used the same model as uWSGI and would restart all workers at once. While the new worker processes are booting, you are unable to serve any requests. The startup time of our monolith ranged from 10-30 seconds which meant during that period we would be unable to serve any requests. To work around this, we replaced the gunicorn master process with Stripe’s worker manager [Einhorn](https://github.com/stripe/einhorn), while [keeping gunicorn’s HTTP stack and WSGI container](https://github.com/reddit/reddit/blob/master/r2/r2/lib/einhorn.py). Einhorn restarts worker processes by spawning one new worker, waiting for it to declare itself ready, then reaping an old worker, and repeating until all are upgraded. This created a safety net and allowed us to be at capacity during a deploy.

This new model introduced a different problem. As mentioned earlier, it could take up to 30 seconds for a worker to be replaced and booted up. This meant that if your code had a bug, it wouldn’t surface right away and you could roll through a lot of servers. To prevent that, we introduced a way to block the deploy from moving on to another server until all the worker process had been restarted. This was done by simply polling einhorn’s state and waiting until all new workers are ready. To keep up speed, we just increased the parallelism, which was now safe to do.

This new mechanism allows us to deploy to a lot more machines concurrently, and deploy timings are down to 7 minutes for around 800 servers despite the extra waiting for safety.

## In retrospect

This deploy infrastructure is the product of many years of stepwise improvements rather than any single large dedicated effort. Shades of history and tradeoffs taken at each step are visible in the current system and at any point in the past. There are pros and cons to such an evolutionary approach: it’s less effort at any given time, but we may end up in a dead end. It’s important to keep an eye on where you are evolving to so that you keep moving in a useful direction.

## The future

Reddit’s infrastructure needs to support the team as it grows and constantly builds new things. The rate of growth of the company is the highest it’s ever been in Reddit’s history, and we’re working on bigger more interesting projects than ever before. The big issues facing us today are twofold: improving engineer autonomy while maintaining system security in the production infrastructure, and evolving a safety net for engineers to deploy quickly with confidence.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
