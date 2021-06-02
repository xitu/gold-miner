> * 原文地址：[How to run an online meeting](https://github.com/tc39/how-we-work/blob/master/call.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-run-an-online-meeting.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-run-an-online-meeting.md)
> * 译者：
> * 校对者：
# How to run an online meeting

Sometimes, issues in TC39 can be worked through more effectively by holding additional online video calls, e.g., via Zoom or Google Meet, as an adjunct to other forms of communication.

## Do you really want to make a meeting?

First, think, what problem are you trying to solve? Is a meeting the best way to solve the problem? Some other possible techniques which could avoid the overhead of an additional meeting:
- GitHub issue/PR thread
- Email thread
- Agenda slot or breakout session in a TC39 meeting
Remember that a meeting is not just taking your time to organize, but also the attendees' time, including the context switches involved (whereas asynchronous text-based communication can be scheduled by the participant). This is a heavy-weight tool to be used only when actually helpful.

If these other modes of communication would work well, great, go for it. Here are some cases where a call might help in addition:
- If there's a lot of back-and-forth to work through, to the point where written communications end up being much more time-consuming than a synchronous discussion
- If you want to engage people who can't physically attend a TC39 meeting, and where it's impractical to use written communication (e.g., the volume is too high, and everyone is overwhelmed with GitHub notifications)
- If there's a lot going on, and there's a need to coordinate on a high level among collaborators

OK, if you still think a meeting is the best way to work through your problem, see below for some suggestions for how to make it happen. Note that these are just ideas; feel free to organize and run your meetings however you'd like.

## Scheduling a meeting

[Doodle](https://doodle.com/) is a popular tool which lets you create a quick poll to choose times for meetings. Some considerations to using Doodle:
- Don't include too many or too few options--too many is annoying to fill out, and too few might not lead to an acceptable answer. 5-9 is often a good middle point.
- Don't include time/date combinations that you're not able to attend.
- Hour-long meetings are typical; a half-hour is sometimes not long enough to get deep into the subject matter, and more than an hour is often exhausting for attendees. If you can't figure out how to fit the content into just an hour, think about what's really important and focus the agenda on that part.
- If the timezone of the attendees is not all the same, try to choose options that are plausible for everyone within normal working hours, and draw attention to the default timezone of the poll (people might assume it's in their timezone!).
- Send the Doodle out two weeks before the meeting, and choose an option one week before the meeting.
- Send the Doodle to everyone who you are especially interested in attending, and announce it in a place where everyone who might want to optionally attend
- When possible, learn about any idiosyncratic constraints of attendees, e.g., some may prefer to meet before or after the ordinary work hours in their time zones, or prefer meetings scheduled on the half-hour, and offer options within these constraints.

Once the Doodle completes, create a calendar invite and agenda for the meeting and send it to attendees.

## Writing an agenda

The agenda forms an outline of the meeting and guides discussion. A typical agenda might include:
- The title, date, and time of the meeting
- Introductions of attendees (if they don't all know each other)
- Background on the problem, motivation, where we are in solving it, etc
- A few bullets of technical issues to work out within the problem, with links to detailed background and status
- Wrapping up and determining next steps
  - During the meeting, list action items and owners
  - Including whether the meeting should reoccur and at what frequency/for how long

When writing the agenda, keep in mind:
- Different attendees will have different kinds of technical and organizational background; to the extent possible, make the meeting understandable and interesting to each attendee.
- Consider keeping a balance of technical and organizational content, based on the needs of the topic; sometimes staying 100% technical or 100% organizational risks feeling irrelevant or making it hard to set next steps.

[Google Docs](https://docs.google.com/) is often a good tool for collaborative editing on the agenda. You can use their "world-editable, link sharing only" option to let all attendees participate collaboratively in writing this agenda, based on the first draft you send out. During the meeting, notes can be taken inline in the agenda.

## Creating a calendar event

When the Doodle poll completes, we have a time and date established for the meeting. To help attendees remember to attend, a calendar invite is helpful. [Google Calendar](https://calendar.google.com/) is popular for this purpose. Some tips on setting up a calendar invite:
- Announce the meeting in the place where the Doodle was announced, and give people instructions to contact you for an invite.
- Give the meeting a title and description which summarizes the purpose and links to the agenda/notes document.
- Encourage invitees to edit the agenda, and to recommend other invitees, if relevant.
- Make sure everyone who filled out the Doodle gets a meeting invite.
- Sometimes attendees will have multiple email addresses, some of which handle Google Calendar invites better than others. Keep this in mind when sending invites to email addresses, asking attendees for information if needed.
- Include the meeting in TC39's committee calendar rather than your personal calendar, if possible.
- Send out this calendar event a week before the meeting, and consider making an additional reminder one day or a few hours before the meeting.

## Running the meeting

Some tips:
- Wait a couple minutes at the start for attendees to arrive if necessary, but usually no more than 5 minutes.
- Designate a note-take or note-takers, ideally worked out informally ahead of the meeting. This could be you if you're good at multi-tasking, or could be an attendee. Set clear guidelines for where the notes will be taken (e.g., inline in the agenda) and what style of notes are expected for the meeting (e.g., documenting carefully who said what (as in TC39 meetings), or just high-level points that are made).
- Introduce yourself and the purpose of the meeting; encourage everyone to do introductions if needed.
- Control for time: Wrap up certain discussion topics if they are taking too long and there are other important topics on the agenda that need to be discussed in this particular meeting.
- Don't talk too little or too much, as the meeting leader: Ensure that topics are adequately introduced with sufficient context, but otherwise try to get out of the way so attendees can share their insights. Moderate the meeting so that everyone can be heard.

## Next steps after the meeting

- Based on agreement among the meeting attendees, post the notes in some appropriate place so that they can be read by everyone interested in the subject. This may be in a public GitHub repository (for most meetings), or it may be in a separate, private place. Ensure that the notes are publicized to people who would be interested in the subject. You can convert the Google Doc to a Markdown file using [this script](https://lifehacker.com/this-script-converts-google-documents-to-markdown-for-e-511746113).
- If the group decided to make this a recurring meeting, take the original Google Calendar event and set it as a recurring event--this is much easier than creating a new event each time. If you edit the description or add invitees, be careful to apply the setting of whether it is just for one meeting or recurring--it's easy to accidentally add people to just one meeting! Often it works well to reuse the same agenda/notes document, and just prepend the agenda for the next meeting at the beginning of the same document.
- If some meeting attendees took action items, but you don't see progress on the item, consider sending an email individually to those people to ask about the status, rather than asking in public in a future meeting.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。