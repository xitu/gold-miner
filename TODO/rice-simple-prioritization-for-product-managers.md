>* 原文链接 : [RICE: SIMPLE PRIORITIZATION FOR PRODUCT MANAGERS](https://blog.intercom.io/rice-simple-prioritization-for-product-managers/)
* 原文作者 : [Sean McBride](https://blog.intercom.io/author/smcbride/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Prioritization is a perennial challenge when building a product roadmap. How do you decide what to work on first?

If you’ve put the effort into brainstorming new ideas, finding opportunities for improvement, and collecting feedback, you’ll have a [solid product roadmap](https://blog.intercom.io/where-do-product-roadmaps-come-from/) full of good ideas. But the order in which you tackle those ideas deserves just as much thought. You need to take the time to prioritize well.

## Prioritization is a difficult problem

So why is prioritizing a product roadmap so difficult? Let me count the ways:

*   It’s satisfying to work on pet ideas you’d use yourself, instead of projects with broad reach.
*   It’s tempting to focus on clever ideas, instead of projects that directly impact your goals.
*   It’s exciting to dive into new ideas, instead of projects that you’re already confident about.
*   It’s easy to discount the additional effort that one project will require over another.

Even if you make it through this mental minefield intact, you’re left with the tough task of consistently combining and comparing these factors across all project ideas. Thankfully, you don’t have to do this in your head.

## A simple tool for prioritization

This is where a scoring system comes in. A good one can help you consider each factor about a project idea with clear-eyed discipline and combine those factors in a rigorous, consistent way.

Using a scoring system for prioritization certainly isn’t new. Systems designed to balance costs and benefits abound. But on my team at Intercom, we had a hard time finding one that allowed us to usefully compare different ideas in a consistent way.

So, last August, we began developing our own scoring system for prioritization from first principles. After lots of testing and iteration, we settled on four factors, and a method for combining them.

## RICE: Four factors for assessing priority

RICE is an acronym for the four factors we use to evaluate each project idea: reach, impact, confidence, and effort.

### Reach

![](https://blog.intercomassets.com/wp-content/uploads/2016/03/15031653/Reach.png)

To avoid bias towards features you’d use yourself, estimate how many people each project will affect within a given period. For my team, it’s “how many customers will this project impact over a single quarter?”.

Reach is measured in number of people/events per time period. That might be “customers per quarter” or “transactions per month”. As much as possible, use real measurements from product metrics instead of pulling numbers from a hat.

#### Example

> _Project 1: 500 customers reach this point in the signup funnel each month, and 30% choose this option. The reach is 500 × 30% × 3 = 450 customers per quarter._
> 
> Project 2: Every customer who uses this feature each quarter will see this change. The reach is 2,000 customers per quarter.
> 
> Project 3: This change will have a one-time effect on 800 existing customers, with no ongoing effect. The reach is 800 customers per quarter.

### Impact

![](https://blog.intercomassets.com/wp-content/uploads/2016/03/15030742/impact.png)

To focus on projects that move the needle on your goal, estimate the impact on an individual person. For my team, it’s “how much will this project increase conversion rate when a customer encounters it?”. Your team might replace this with another goal, such as “increase adoption”, or “maximize delight”.

Impact is difficult to measure precisely. So, I choose from a multiple-choice scale: 3 for “massive impact”, 2 for “high”, 1 for “medium”, 0.5 for “low”, and finally 0.25 for “minimal”. These numbers get multiplied into the final score to scale it up or down.

Choosing an impact number may seem unscientific. But remember the alternative: a tangled mess of gut feeling.

#### Example

> _Project 1: For each customer who sees it, this will have a huge impact. The impact score is 3._
> 
> Project 2: This will have a lesser impact for each customer. The impact score is 1.
> 
> Project 3: This is somewhere in-between in terms of impact. The impact score is 2.

### Confidence

![](https://blog.intercomassets.com/wp-content/uploads/2016/03/15030748/confidence.png)

To curb enthusiasm for exciting but ill-defined ideas, factor in your level of confidence about your estimates. If you think a project could have huge impact but don’t have data to back it up, confidence lets you control that.

Confidence is a percentage, and I use another multiple-choice scale to help avoid decision paralysis. 100% is “high confidence”, 80% is “medium”, 50% is “low”. Anything below that is “total moonshot”. Be honest with yourself: how much support do you really have for your estimates?

#### Example

> _Project 1: We have quantitative metrics for reach, user research for impact, and an engineering estimate for effort. This project gets a 100% confidence score._
> 
> Project 2: I have data to support the reach and effort, but I’m unsure about the impact. This project gets an 80% confidence score.
> 
> Project 3: The reach and impact may be lower than estimated, and the effort may be higher. This project gets a 50% confidence score.

### Effort

![](https://blog.intercomassets.com/wp-content/uploads/2016/03/15030800/effort.png)

To move quickly and have impact with the least amount of effort, estimate the total amount of time a project will require from all members of your team: product, design, and engineering.

Effort is estimated as a number of “person-months” – the work that one team member can do in a month. There are many unknowns here, so I keep my estimates rough by sticking to whole numbers (or 0.5 for anything well under a month). Unlike the other positive factors, more effort is a bad thing, so it divides the total impact.

#### Example

> _Project 1: This will take about a week of planning, 1-2 weeks of design, and 2-4 weeks of engineering time. I’ll give it an effort score of 2 person-months._
> 
> Project 2: This project will take several weeks of planning, a significant amount of design time, and at least two months of one engineer’s time. I’ll give it an effort score of 4 person-months.
> 
> Project 3: This only requires a week of planning, no new design, and a few weeks of engineering time. I’ll give it an effort score of 1 person-month.

## Combining factors to get a RICE score

So, to quickly summarise our four factors:

**Reach:** how many people will this impact? (Estimate within a defined time period.)  
**Impact:** how much will this impact each person? (Massive = 3x, High = 2x, Medium = 1x, Low = 0.5x, Minimal = 0.25x.)  
**Confidence:** how confident are you in your estimates? (High = 100%, Medium = 80%, Low = 50%.)  
**Effort:** how many “person-months” will this take? (Use whole numbers and minimum of half a month – don’t get into the weeds of estimation.)

Once you’ve estimated these factors, combine them into a single score so you can compare projects at a glance. Here’s the simple formula:

![](https://blog.intercomassets.com/wp-content/uploads/2016/03/15030740/formula.png)

The resulting score measures “total impact per time worked” – exactly what we’d like to maximize. I set up a [spreadsheet](https://docs.google.com/spreadsheets/d/12BY8jlCPOVav1KFocIx-wruLjO-TVE2tpLO-oFM3SDA/edit#gid=0) to automatically calculate the score for me as I estimate each factor.

[  
![](https://blog.intercomassets.com/wp-content/uploads/2016/03/15032115/spreadsheet-screenshot.png)](https://docs.google.com/spreadsheets/d/12BY8jlCPOVav1KFocIx-wruLjO-TVE2tpLO-oFM3SDA/edit#gid=0)

_Feel free to duplicate the spreadsheet for your own use. Or [download an .xls](https://blog.intercomassets.com/wp-content/uploads/2016/03/15033140/RICE-scoring-example-spreadsheet-1.xlsx) version._

Once the initial scoring is done, sort your list and re-evaluate. Are there projects where the score seems too high or too low? If so, reconsider your estimates and make changes, or accept that your gut instinct may be wrong.

I’ve used RICE to score over 100 project ideas during the past six months, and it has helped immensely when deciding between hard-to-compare ideas. It forces you to think about why a project idea will have impact, and to be honest about the effort that’s needed to achieve it.

## Using RICE scores effectively

Of course, RICE scores shouldn’t be used as a hard and fast rule. There are many reasons why you might work on a project with a lower score first. One project may be a dependency for another project, so it needs to happen first, or another feature might be “table stakes” to sell to certain customers.

On my team, we sometimes work on projects “out of order”. And that’s OK! With a scoring system in place, we can clearly identify when we’re making these trade-offs.

A scoring system like RICE will help you make better-informed decisions about what to work on first and defend those decisions to others. Give RICE a try in your own prioritization process and let us know how it works for you.

