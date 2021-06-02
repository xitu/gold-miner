> * 原文地址：[How to take notes](https://github.com/tc39/how-we-work/blob/master/how-to-take-notes.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-take-notes.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-take-notes.md)
> * 译者：
> * 校对者：

# How to take notes

### Introduction

During TC39 meetings we aim to take detailed coherent notes about the proceedings, so that people who are interested in what happened in the last meeting can stay updated and involved in the process even if they cannot attend the meeting. Note taking is a great task for someone who is attending their first couple of TC39 meetings as it throws you straight into the action.

### How the notes should be taken

It's important to capture what is being said, but it shouldn't be word for word. If someone is
repeating the same sentiment a few times, do not worry about recording everything they are saying.
Try to focus on understanding what is being said, and getting the core of it. This way we have less
work editing the notes for the public! Also, do not worry about noting down where you didn't quite
understand what was said, others will come along and correct as you go.

### Location of notes

Notes are kept in the tc39 etherpad for a given day. *The link to the etherpad should never be shared*. Given the pace of the conversation, notes can become quite messy, and might be incoherent. To give time for the speakers to clarify their intentions within a given conversation, notes are not released to the public for a couple of weeks, and for this reason the etherpad url is private. If you are a new note taker, do not hesitate to ask what the URL is for a given day.

## Layout of the notes

The notes have the following structure:
- The date
- The attendee list
- The notes for the agenda items

### The date

At the top of the notes, you should see (or add) the date:

```
# <month> <day>, <year> Meeting Notes
-----
```

For example `# March 22, 2018 Meeting Notes`

### The Attendee list


People usually add themselves here, with their name first followed by the initials that will be used to identify them in the notes.

Initials must be unique and should be stable across meetings. Otherwise we won't know who is who in the notes. Normally we use three letters: first letter of first name, first letter of last name, last letter of last name. Old-timers are grandfathered-in with two-letter initials.

Usually they look like this (these are not real members):

```
Joseph Beuys (JB), Martin Kippenberger (MKR)
```
With Joseph Beuys being an old-timer, and Martin Kippenberger being a new member

### The template

The notes may or may not be initialised yet. If they are not, you can use this template:

```
-------------------------------------------------------------------------------------------------------------------------------------------
Template:
-------------------------------------------------------------------------------------------------------------------------------------------
    
    
## X.Y.Z Agenda Item 
 
(Presenter Full Name)
 
 - [proposal](...link to proposal...)
 - [slides](...link to slides...)
 
JB: Ja ja ja....
 
MKR: Ne! Ne! Ne!
 
#### Conclusion/Resolution
 
- Stage -1 
```

This template breaks down like so

#### Title

X.Y.Z should correspond to the agenda number from the agenda, and be followed by the title of the agenda item. For example: `## 8.i.c Expand text included in "function code”`

#### Links

Any links associate with the agenda item are added to the second segment of each topic. This might include the proposal repository, or a set of slides. It depends on the agenda item

#### Discussion

Speakers are identified by the initials which are listed
in the attendees list. Initials should always be with capital letters. In this case we have [Joseph
Beuys](https://www.youtube.com/watch?v=py_uEHL-la4) (JB) arguing with [Martin
Kippenberger](https://www.youtube.com/watch?v=MJxktqTgRlM) (MKR)

#### Conclusion

Once a discussion reaches its conclusion, we record the decision or outcome of the discussion. this
should be a one line point, such as a stage advancement, or a need to rework

## Tips

- Try to pair on note taking, but do not have too many people simultaneously
- With two people, one person can finish writing the last sentence, while the other person can start on the second sentence
- If too many people are on the etherpad instance, the note takers might be booted — try not to have the notes open if you are not actively taking notes

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
